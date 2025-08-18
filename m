Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26BCDCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 18:26:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA8566B00B5; Mon, 18 Aug 2025 14:26:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A80686B00B7; Mon, 18 Aug 2025 14:26:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BD4F6B00BA; Mon, 18 Aug 2025 14:26:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 898D16B00B5
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:26:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 155FC5C240
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 18:26:31 +0000 (UTC)
X-FDA: 83790708582.26.8D2D012
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2C7FD2000F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 18:26:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=X9diEnfv;
	spf=none (imf03.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755541589;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O75UIUPO5Nhi6baLItc5aorQTbl3aXRmvPV/kSs4z1U=;
	b=aXyEFJyjRWUhS35eE0qChF0x+K7vocRRCEoHPuhDfLPMnLRInphKyLM3ilPSYC+szlkbQR
	uL0h6/I7X1JO/ytlAwm4iveFE+YOOlfe4GAGIoXusYvHflja6baXSPinaPwftU8/MIuS6i
	K4GFCJxnPbjfmmPF+q1/JaG5+xrTUrI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=X9diEnfv;
	spf=none (imf03.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755541589; a=rsa-sha256;
	cv=none;
	b=YlXdL8irW98x+EZAXNVdJ/whzHLjDCOFWuqCBMqcyVSOVNUCe82oDKCwZSwVqk+Umzs/jx
	mKQhhX8zjHDE7jtkFa4zd4zTrqLasiSdmvpPnYhILo2abV5KcAVPARtkAoj9F8AsbByDof
	Bqo9tFGuEeqZB6xABRFqFSeWNGtrJNM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=O75UIUPO5Nhi6baLItc5aorQTbl3aXRmvPV/kSs4z1U=; b=X9diEnfvb8vsZSK7H4Ybwyad7Z
	VGXrBAuw2mdZ8xiMQYV7DxC1p7tKM3M5WM/UjU+XMGlCrjrjI0Mq0M2JvEz6MXJ/BXJXw3nLzU4eB
	F31BmJj5GovtvGO5IMSUv5I5qPzczC99qT8PEQtKonLLVan26mNpujoOC6QIPU+yvJoFIl9SUOf76
	2hseD7EdBenfHkZApwqQFF0MXHvA3024HDtRdCoDNq+Ckj524lpzzRDJl5aRZcKllFh0tupl83bby
	fcgTywetRcz6pD8NZawdz1QNwugUBHj9I4e7ncdz+FXNc7WYaaBKRPGbtmb4pGRJIetez3cU3LH64
	+7DImIsA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uo4Yi-000000078b6-0d8k;
	Mon, 18 Aug 2025 18:26:16 +0000
Date: Mon, 18 Aug 2025 19:26:16 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: syzbot <syzbot+1ec0f904ba50d06110b1@syzkaller.appspotmail.com>
Cc: andrii@kernel.org, ast@kernel.org, bigeasy@linutronix.de,
	bpf@vger.kernel.org, brauner@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, eddyz87@gmail.com, edumazet@google.com,
	haoluo@google.com, jack@suse.cz, jiri@resnulli.us,
	john.fastabend@gmail.com, jolsa@kernel.org,
	kerneljasonxing@gmail.com, kpsingh@kernel.org, kuba@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, martin.lau@linux.dev, netdev@vger.kernel.org,
	pabeni@redhat.com, sdf@fomichev.me, song@kernel.org,
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
	yonghong.song@linux.dev
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in sys_umount (3)
Message-ID: <20250818182616.GB222315@ZenIV>
References: <67555b72.050a0220.2477f.0026.GAE@google.com>
 <68a2f584.050a0220.e29e5.009d.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68a2f584.050a0220.e29e5.009d.GAE@google.com>
X-Rspamd-Queue-Id: 2C7FD2000F
X-Rspam-User: 
X-Stat-Signature: ojzxwp7n4upne4trafh88xqk8ni33h7s
X-Rspamd-Server: rspam09
X-HE-Tag: 1755541588-555324
X-HE-Meta: U2FsdGVkX19Wx78t9eAB18taAVyO/ZX3Lqc0jL07Vb2T1/eZLm0QQUkHXcsdPrHWUAFmigzwDKOVkw7PS6yY1/Cx32X8obS92AizvE1fSMaOgV7ZDB2L0xTEl/hBXoSf5X9fGC4RXOnHvXEgT+saA2CIiTZ0dBNESbvG6mNd0yqiMFC6tSDW0qPiab3Q2OCWzfkTx2XvQz1HjW8fEk1xDYq4VwXKEsNwm51T2avXgsP7mXe/VltYDl8KPlf9ElP8gzsL615DeYCD4L3ozSPnr7YA0YK3JejC+6jVbp9SITwbI+G8huoWEkAPJDk6JcPRbIWd/N7s4cdWL2YngTCivUjuMc9Ps0AgF9lVeP2hiA5FVk+Ae1cTO+EKxddmBwCSwd5YzHhwtlxuEoDkzBzp9DU1mhTDTxf6UJ7M8yXrsmcXq/pQig5ENYxRZNGlXdrA5OvWYcmF2073NPR3THdrlN3kBl/bhYyfb7XYMZ1a48XHJdaaZ1lRVjDC+Pq4p7V4B4JNnb/cSyiNVMwGdjaPXm/r2FNjVi/RWmT1YPeYwu4OSIhAMwSBN6GOqqliBq4YhJpWBXYu9dkSMzJxNrwIkoAs31O37BrRHu6K4bBQwjjPruFM+twZuwXLI+xLRWqzZZhYsgmLQTZ2/jBjcc+s1EhvEYCQHOJzUMaxuFSdUaP42dPnsHPPa9US5CP9dG476DoxQQD41t/NlbizLbrDvmkQf9hETvUb0ImwofJY6XME7+43iZ1jFE2TR7X2VfrK6Ip5Vgz5CH+bTMyVIpcmBiyHFKyhNaIh4BH4zOqlQ6JyzC9YmZTGUm7k/SD0I/cCGcIIuwbAeU7UyOL3JtV7hLgaG6ZnHGx3bU6Jgrg4QnICrX/IEzk0lXJbKmblcPooV9sayZh/MNzK6T82i3XzRnLfu0JvbuaeuxH0b33Ic/P9gez8yd30N+wpjzerFHvUPxaIdazBmFSbJdsYW1b
 SoRxFBlH
 /atrDG13S5QkVvWaYN1euud+XRsiI17+lN3Pss9zHcSvwBY5XE8LtlpR5DoDlhUQF9PDIyppjXafSUcsaEDOVB8skd8if87LO22RjtfAzpwKeItaWBl4yUA0vKAtQ16J0LkXh+JMteOseBnYJAsbFw8ovdFPBvxRioH5G/kLwCA/Lqsa8Pl+sQs1RZv+xgeBAgvW4Ne4HuQt9mbjYrpeTsw5zaMPW0R7msrC6hFMl+FiDdSLZgHjPiH22xP1oQviFBsMeqYfl1WtEmj7kWWcwN/EGAaMuOeEx6X+p8v9dHkb9eBmraY8pjhdImFXd/l+Lo/zR2L073fwWy0Q5aDWfLW1neC99zDS1pH8d6/gxuKT7MAJ7U+XEosEDgcV5NaNKBJaN/hJGjaAslliUscvd/HKlulro81HY4bNJDJU9bp8z1s6MyxQPf3cJKVQ3A5C0fL9/s1Y/dV7qu1NHTtZwc/xbOl6XpIdzr8502Qc1BpvoDODJmRalk4PN1BzN35NWLaJPISoCOb1O1i1zRJVM7mkaJjNwDDDAZuPfCjx9HelL1UGr6Cx5XWzh8P6tvYQp3xcV07IaCenh6umeuMsQleEUc6sSE8q1nkkiM0Y4UJBC1N9yW6Ef9c18b+M01cN+zNWDSF6tMrx9Ht0WD5PVxehbDjfGeuH4cX53C1hEIMbCt1Mofo5OKKMjOyicP3PmtjX7UNOps6D3sI07QgZC5bsn6VHYqfz6NHXDZErgEEKhBnpcbE/WgPsEsD1HFc5dvzBm5BSaIcDYt+M36D2ToQ6eW58qFqK5gr9pdG8lTg8aTCNNJX3+CYrTuLgQc4vq1ptU9mxU1YMXTdaaB7QlzgMngIP9E3zo1bmhZy06Cit4fJT46jTA1Ec1u2O4PHEPmKKNi3ATKkdjg9SezzUsOCGOKw8cH5OVnXSOu9kt1JMMQsO3ntUi3trqY6eX1TDbd2Ug2Cy3QkHL28ES0ASseEwKEQjT
 JT0425Zh
 Z452LFAkaT06aIb3VU8gHzbV2hCmixj+cXvOsttXF4Z39jrJjp5IOiUmEhEs8sykTigLmHLD8BfMdo5ZFcMn6h/7CdK9p4AfQpc/NZ07RUNz/doENv7K2U95Uo92KBCC+TN2Q4FKf/M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 02:42:28AM -0700, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=1321eba2580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
> dashboard link: https://syzkaller.appspot.com/bug?extid=1ec0f904ba50d06110b1
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10cba442580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10a1eba2580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/disk-8f5ae30d.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinux-8f5ae30d.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/Image-8f5ae30d.gz.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/43186d9e448c/mount_0.gz
>   fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=174ba442580000)
> 
> The issue was bisected to:
> 
> commit d15121be7485655129101f3960ae6add40204463
> Author: Paolo Abeni <pabeni@redhat.com>
> Date:   Mon May 8 06:17:44 2023 +0000
> 
>     Revert "softirq: Let ksoftirqd do its job"

Would be interesting to see how it behaves on 

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #fixes (cda250b0fc83)

