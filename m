Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83E02CCFA1A
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 13:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFDCC8E0018; Sun,  9 Nov 2025 08:39:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAE2F8E0002; Sun,  9 Nov 2025 08:39:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9C528E0018; Sun,  9 Nov 2025 08:39:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AECF48E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 08:39:32 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 57A185BDA9
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 13:39:32 +0000 (UTC)
X-FDA: 84091175784.16.FB414B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C6AAC80011
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 13:39:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JCDTG7yW;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762695570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ilDuKMsUzA4ReOjIyBNkskTq0lsErvMCbOUpEiB2v9o=;
	b=FASxRb69E6AV0PqrdKlg/EzasEGinMey2Z5uDLCVAevboFyarRVA0i+pEsceM+lnct9H2c
	DO2BN5NtznbdH8yx/iVUyFj6qrTgp+cyDY/myOtpKH1TTecqGYi7tZqwloS4qQBJQX6qTC
	rUIdsj/WY0JfHjX1nv8actpYYRpR3ug=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762695570; a=rsa-sha256;
	cv=none;
	b=hjCxCvU6Rd8EpiC6lGTRKAbP7CPC1qBPn+jr3V6B87odWnRc8BDVeZEZUuZaxBU4KtkFMQ
	za4XOHP7WCynn98e9ogYU5bXLri6chPuFh8DD8cCC8GdIqP0WiisQFDoyY1nWu9zJuK36g
	AkZDTYza7RmP5kP3ooohMzIKpIihVBQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JCDTG7yW;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D1C9B601E5;
	Sun,  9 Nov 2025 13:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E154C4AF0C;
	Sun,  9 Nov 2025 13:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762695569;
	bh=FV6nIOrd9444B+mlGQsh9CSaoRsJM/FxBjLlQCcf7Ig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JCDTG7yWV3lfOfydcImpyi17b3P3GZLuSATHpoliBde4zFx8fh61QvaCh34B/HHii
	 pJ27gbrypWJWTH4Ulv+LOs72Quk/MUQ6LEtzHk02x8ZrpVtg5X87QGI4Nl3RU6aGOd
	 lbBJpjgNUXe1JyH6/xkSaHKgUVe/JH/zCh1uPdHSwDpYxG/tMvoJ6iGev/uMqQHTV4
	 SjvlJSoXJyzeQtNvM3gIcK9CnH290NCNuDjzDbc4fDFlbBYmlnB7RJzXJxV3foHm6E
	 9exKHGGww7iriJrIByK4WlNzn/KZiugBpkenja+mrf9Vg9KpQqyMj1qWw4b0Ao2ATp
	 aQQdmL5ydsFsg==
Date: Sun, 9 Nov 2025 14:39:18 +0100
From: Christian Brauner <brauner@kernel.org>
To: syzbot <syzbot+1957b26299cf3ff7890c@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	anna-maria@linutronix.de, bpf@vger.kernel.org, bsegall@google.com, cgroups@vger.kernel.org, 
	david@redhat.com, dietmar.eggemann@arm.com, frederic@kernel.org, 
	hannes@cmpxchg.org, jack@suse.cz, jsavitz@redhat.com, juri.lelli@redhat.com, 
	kees@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, mgorman@suse.de, mhocko@suse.com, mingo@redhat.com, 
	mjguzik@gmail.com, mkoutny@suse.com, oleg@redhat.com, paul@paul-moore.com, 
	peterz@infradead.org, rostedt@goodmis.org, rppt@kernel.org, sergeh@kernel.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	tj@kernel.org, vbabka@suse.cz, vincent.guittot@linaro.org, 
	viro@zeniv.linux.org.uk, vschneid@redhat.com
Subject: Re: [syzbot] [fs?] WARNING in destroy_super_work
Message-ID: <20251109-lesung-erkaufen-476f6fb00b1b@brauner>
References: <690da04f.a70a0220.22f260.0027.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <690da04f.a70a0220.22f260.0027.GAE@google.com>
X-Stat-Signature: 5u4aei73i5qsir1tznrhehu9h3g9tazz
X-Rspam-User: 
X-Rspamd-Queue-Id: C6AAC80011
X-Rspamd-Server: rspam01
X-HE-Tag: 1762695570-684145
X-HE-Meta: U2FsdGVkX19XEyML4mENb0M/UELv2p8PqlMqTEDgP9D/WJTZEFAkc6TwJpOWywRoCq2hlgTBk/gvRTBx8n9o5ei7KKd6dIN6AxAwrIyRT+8MLdMwbUBChz8X2C/u0zWg51AguqxcjzHv7HgQIO/yegqUHSab94suasddsd07+DTSSJmdHsY3InEB+9L76HHN2y4kITLsSlCAgW5N6GqmGFfBn4NENffu1CxrnLTOawpbSrQUZt50KRTaSsHPEBmWs6MAMt1yR8c0PhUY8Kej4zLrbfKm5P3sfkd9BWKvMhmcdRmSLgjxrovdex0MCZLjyh6EStjjEiJDElv4AYptdmIadn6Rel3RhTcc3usHiVRf/B9RAUutogbeX2A2pgByV/1jVTvnvYAijXs7kUpl2U9IkDBH9YmBC5FQN3OaNdjcgx2GA6eEHBR80Ekr83k/7g+a+AHAVLxiHiadRplZJa9HlAnavhIpDxJmAr1f3YXIk+Ea9Je8VK48VS+AFXDt2cYNZ4g58/a2QnG6wljej6n3rl7WAcyuXKYJx60+WsPj9cOqprVIJCxCyNWKmuOsRnfroU2fiiztWktOoGbJJPyVgNWnzt2Fivg5jxjY1dPuGbfqSj3cTg1afRHleA41stfrL3JlCjNee0nrbUCJ4qsxOtbdhK15BV93ipmAgomi6oJKqHIHhJc7ov1F3lEVDaj1zQW+fQlvRFLK6YROvtJdOM/iZOHOgzIez7sVoFsSwbAxddllZSZCrhWMAp/rZz2Jg3xJlGyJQ/10SonfLVjDZbU4dmVmCtGoiEN7Zz32kFR6igPsf/55z/+dA5XOzlF4I1Q/cDXi449v0kZQGAacBph2QcOxIBTVAs7yeXJwX+kF0J9NxwZ87P7PAl93sJJ1CecmGG1Q7e3mgSGzJPM9+W2lnUYcrdD4cjK3tqHRwGUL49vcwaHjFm51YKUYPcDBU8GQ4Nc8gGan0cf
 GtXC4EI4
 FEufCwGNuiJTzpMj7CytKoXyTqyMs/emx1JxoA57FVOpsFXNbkPwoccP0JS9+KvfPMZiBK7BEJU/eVfve/eghtkrKUlzQmYBcvOPv/MSanLzuyQG4wHRYFX+8S1rHzMU0fRafk8uo4oJg5rPkMiLwCzkxENk5+/Xcs3Zj0nCpYpuSIcrFd67YT2qtMZrYOtQnMLHua79Wewm7eDnZeM6cnYPK3ENlXZZYIq/czI0c8oZ0fcksb5ujJyks4lujl7RvY0NlkDjw1GK6edYufe0UcyhGXZ27LCEC3IA8UwMbO+VK4V6c5jIBia/U0wxyHqq0hnmZhVXjN93NmhIwwUBTasPS4jVPw3hsJphNgc2fiJu2cnuVzdr3sSk3fmWjl2G3zzlLSsRMmo7iHHHypjkpynnJvxZyZXo+GhqQktLQwhDT7C79EvC4DtufDqZiPJ9fpu4Gz3A5sV2O+LQQqqGHXZFNRJ12/l0LClMYkc52bSBmPsxDuzfoUJw2DQc6B6quvKyWBPX/ZEb7DZp9333ty+c8FcioNFTH6KdnHQZzO5ka1J1mh44kmbDu7jWaMMSTb/zRAduYr5I7SuoiUxaChyrscBbkMfHIknXLHqCyQp1UFpWLRGuEgiXD86CO9mYmYp+vXUbG+NKzLr5++JtXnn6zduSZkDOpAIAuY8K4DTV3fWD5pomw1J9+teePg7tEKppfZAUYGUzLqDkXigc5FRyzQT70gmqzsHUSQOFK1DyhKYWlqAo7Fzrjb94EK03A4taNgmH6gSBr4PJQkzj4KM/MoVh4DtZk5ixAGH7zf1X9x5ttJX2FRnqUVUxJRQKUc3LjB0tSgPVXBG+M+55xxB/BAqmlEQFQw9+ZQxheLb38S/pVTpkWTo6Qx6hpJ2BOVfFW+1TAXorrJJh49GHY0scDWuNb/QZuVJwmH2k22DZx3B40YDcb/hy85cGjAWhkmXm4iOFXM8eYr+TOHwz/Ok2nSudN
 FQvBXAim
 f6trNoSHCjVTEX7sqxS0jujfCylz8HxCmKnnDE2CtRwiB0bsraPVbTLs0QP3V/by
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 11:31:27PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    982312090977 Add linux-next specific files for 20251103
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=17b2932f980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=43cc0e31558cb527
> dashboard link: https://syzkaller.appspot.com/bug?extid=1957b26299cf3ff7890c
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1347817c580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/40058f8a830c/disk-98231209.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/1d7f42e8639f/vmlinux-98231209.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/d8bb0284f393/bzImage-98231209.xz
> 
> The issue was bisected to:
> 
> commit 3c9820d5c64aeaadea7ffe3a6bb99d019a5ff46a
> Author: Christian Brauner <brauner@kernel.org>
> Date:   Wed Oct 29 12:20:24 2025 +0000
> 
>     ns: add active reference count
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=101e9bcd980000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=121e9bcd980000
> console output: https://syzkaller.appspot.com/x/log.txt?x=141e9bcd980000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+1957b26299cf3ff7890c@syzkaller.appspotmail.com
> Fixes: 3c9820d5c64a ("ns: add active reference count")

#syz test: https://github.com/brauner/linux.git namespace-6.19.fixes

