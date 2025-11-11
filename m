Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18C4DCCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 749F78E001C; Tue, 11 Nov 2025 04:24:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7218A8E0002; Tue, 11 Nov 2025 04:24:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 637CC8E001C; Tue, 11 Nov 2025 04:24:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5056D8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:24:37 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 153891A04C5
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:24:37 +0000 (UTC)
X-FDA: 84097790994.19.811FD5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6D04F40007
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:24:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b4F6wrYi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762853075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPLMykZl4pn/RCQi5nc7lNKlOM0dPx8XkcupRpUci4Q=;
	b=WUTy3cl/L+b556rhoKQ2UxVwTRdlfN4uREoTAVqEMP0ULPzXPYktMYw3WcKBmSidIjSGkX
	GIpfIuTuxPiVReTuRBl/gRkjkZlPHzFiq8GK+5i8PucDgN3tF07LGVsSU39jWREhexnMCb
	mQbwfBiGc1QgWnP+UVMOBBFXStq5kR8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762853075; a=rsa-sha256;
	cv=none;
	b=sKLYTxRsXPv3CIB2PGehOAK9E6STMwoNIKbCbr2zCdaFWbUbqtFvHsziW4IWyfWK5zGU4A
	WW9OAFfMCTRSkhThLH/9BGLJCrdM8T/XknvsIlBUP4HkbEpdQqPcYyAtPyaJTlVzcudQCt
	CGJxf3+6I1RXE+IgjZquBjMpXOpjM5g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b4F6wrYi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 602954178B;
	Tue, 11 Nov 2025 09:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A841C116B1;
	Tue, 11 Nov 2025 09:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762853074;
	bh=oqo4ODlyQOZAF+e8zvIC1WyiLILrt4nXl7b8zNXWo44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b4F6wrYigF74u/gM39t5dR4yPM/K39Os3h41DM2HEnQyd7F3uIzD8A3fxAuLwXaFk
	 Xr0ugeiA8A+oQ7qOVe0xZvkVcmuX5W7EnOj5B/UEG+VJsA+cxjdU5LxoMnQwH01aAF
	 uQR1i6zpFgV5/1sf/LPS6F2MeS82TASh9CPIwSv+Mo60ws8nZrTolhCqULZXDJ/Inp
	 WNLVu3MijLSIvYeNENkBYXsmFW0fdmcbbcdaBhDUx4nCfby2JC34XSIJby6UGuj8CN
	 uSm04F6slHTJtqvCdO2jkOoESqNVSjsmw7pLJat+5mO2wMbErWhjv4xacl5iobdWP9
	 fu6Hj1x4bETrQ==
Date: Tue, 11 Nov 2025 10:24:24 +0100
From: Christian Brauner <brauner@kernel.org>
To: syzbot <syzbot+0b2e79f91ff6579bfa5b@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	bpf@vger.kernel.org, bsegall@google.com, david@redhat.com, dietmar.eggemann@arm.com, 
	jack@suse.cz, jsavitz@redhat.com, juri.lelli@redhat.com, kartikey406@gmail.com, 
	kees@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, mgorman@suse.de, mhocko@suse.com, mingo@redhat.com, 
	mjguzik@gmail.com, oleg@redhat.com, paul@paul-moore.com, peterz@infradead.org, 
	rostedt@goodmis.org, rppt@kernel.org, sergeh@kernel.org, surenb@google.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz, vincent.guittot@linaro.org, 
	viro@zeniv.linux.org.uk, vschneid@redhat.com
Subject: Re: [syzbot] [fs?] WARNING in nsproxy_ns_active_put
Message-ID: <20251111-lausbub-wieweit-76ec521875b2@brauner>
References: <690bfb9e.050a0220.2e3c35.0013.GAE@google.com>
 <69104fa2.a70a0220.22f260.00a5.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <69104fa2.a70a0220.22f260.00a5.GAE@google.com>
X-Stat-Signature: rfyyzycm87njmawfom1rmq848y7bmmbc
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D04F40007
X-Rspamd-Server: rspam10
X-HE-Tag: 1762853075-383468
X-HE-Meta: U2FsdGVkX19ZF6dxXiOGxcNG1LwkNf3P/eTndrINTh2/PPqDNQzlR25oy6NRGnz05N8lZ6nu0rLzXlQWhK7oDzGehv9/yto86QdzwJp4I7ciTiJfM/6x3oy0nMRgIoL/IgoL79bIgKxO+S105FAJjwfRuhTyDbmBFeEKOab9egzcQ+8QPXqfoElxCOUUHPRTj9TqnfIm+RHM6sqUgRrEmrtzCswzZoqBrHrRFDKZfRpntEzteCJWR6lI9N98CdnEegwzni9Rm0SDtodBlnaFW+brkjTbxzSS3V4KRnkciHxLxYDe00QWn5F9Kjogwa2H/NXR9WkMhyuaoQshHxO7iwmmWokaSvpzEhssiIuJuSB82TMe8IiE83vuRGdY8PzVi23ncm1IFUGJRvnZfnY8BNqcuxtashv/jBvrqxWBMUnExlwOJk9Lh3GLBJesExcCZiW70avRhrR9Dw0yI24pQVY44AiXSOxaysTz2HGqVGr91IXuMGxWJmApaXVQ16NzesE2KOOYqPNV0eTFIAcbrabfnWzrAfv8MVx+QmfydBxKtXcT40wVGHy8rbDuaQgAmJzwHf2TR7rzNROgipsf1GR5R0oLqj1aKbgLwfWI8dLSyypSsb+GuiyG8U2UBiZ/65TvUEt/TY3txWH+SR438zCpiilBfbvL5nxj1BJi5iSp6pBjIPqJtM2mZ8Y3MzxCmfGRqBwCDV34bBDCriZIyERE+S9Lh2IYSgj3scVEYrqnnSgYjWqwDaa3fxcusa2oBWa7FXhIXrU47XeLmrJi+sUEfadyM5eHECRTccD1eRSnbZZ6gPao+jnSDG65Q4R0kvdhKM21oYUBoTXfPTk+9hpttKku1P8AcSHRoJf7bjwHwcGEtdymEmYFGBMh6Tl6prOm+0eb5wZKKNaB7WKDXA8qDk/ncW46/OPiRH0aidbboGSqzaE6418wHvEYHRMzfNQ4FN0pPwFqsJyF4K6
 DDNReQLf
 7ipF4faiGviGdcVkgjUQiRoCQ2iOp007ARGO5QlRdaZdVICub8FI7gAoDATRr4t35ZBbh1NrUXTaRk1oEW8LQjEbVdyZ/uAzFzGbDKPeVuI7dVy4CJOYt2RzAZd13bcQuhA8xdvWEL7EBQrM9V3x2S+V2uAaSlv7DjVfOIkS370/K7QH/uOQAV6K2aDEyYeuxEPdmGHyQiGWy6IrhMo4KCtyfwFiW+bG0y7NW9aPW+YgkG3Vv25mceYLO5eiplN4crCCJ2pqCnADS4JCXd5Sm0710wiNLGrnFUuBYxM/uywKC1/W8jJHkvVKephPuYV2KLimAi8uRopR/eHjER+S0lCnJCsMiIB+oN9ybqBeCsaJ3uoPOLsCzG4wYbhKuQ8pW8UUSubeKTIuEc+5pyuxvTppiTwHIfUH//dQ64xXFkNN+gN86Y/9555fhL0T3IyQvH6mPoqf3dn/89OWK06X8rSNuFWOZ+uin8kZG5CeI8sDYk8sge2ZZvEEUcrvKh7itAZhGeU6L0tI6si/TmjLO85lW50Q26lHRNsTS0r9zvuE8h2x9paJfT2OLIyhfP5WAIxRS1gFdoSyefnNJSdKIs7mWwo5tWDX2BrAqEWXeREO7k8MmMrGRXxPokQxIi22yATb5ld+mSKiYw+hoSfxSBkf1cA1UrVLUdqAzyhTnY4+WqM2FH/sdv3sDMpMTeKi6xLGG9j4MLeRXRusTFbEXlIIDVm9Jov/Z9247ZPGwxx7/c6FHR/HeueCZjMPcUYBgCJal9HzNTCgQn8xak9Gu82TaWawCGkYwVBM/ZD+FMTBILZUbzSH/rxeaubFvskjTDih3TfmMrcM68AKTBVkptE4o/guGhg1nkLQWSlDY3Yy3hyGEqG0IZu0pvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 09, 2025 at 12:24:02AM -0800, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 3a18f809184bc5a1cfad7cde5b8b026e2ff61587
> Author: Christian Brauner <brauner@kernel.org>
> Date:   Wed Oct 29 12:20:24 2025 +0000
> 
>     ns: add active reference count
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11a350b4580000
> start commit:   9c0826a5d9aa Add linux-next specific files for 20251107
> git tree:       linux-next
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=13a350b4580000
> console output: https://syzkaller.appspot.com/x/log.txt?x=15a350b4580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f2ebeee52bf052b8
> dashboard link: https://syzkaller.appspot.com/bug?extid=0b2e79f91ff6579bfa5b
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1639d084580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1625aa92580000
> 
> Reported-by: syzbot+0b2e79f91ff6579bfa5b@syzkaller.appspotmail.com
> Fixes: 3a18f809184b ("ns: add active reference count")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz test: https://github.com/brauner/linux.git namespace-6.19

