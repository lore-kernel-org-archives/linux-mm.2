Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C81B2D74EDB
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 15:16:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EADF06B04FC; Fri, 23 Jan 2026 10:16:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B936B04FE; Fri, 23 Jan 2026 10:16:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3DAC6B04FF; Fri, 23 Jan 2026 10:16:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C42D86B04FC
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:16:00 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D8CC1AFED1
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:16:00 +0000 (UTC)
X-FDA: 84363578880.03.00EBF09
Received: from smtp-out3.simply.com (smtp-out3.simply.com [94.231.106.210])
	by imf20.hostedemail.com (Postfix) with ESMTP id 992321C0013
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:15:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=ag1WRAWJ;
	spf=pass (imf20.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769181358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bZOD1qxujIU3XqsrT9Q0is3A3LXGMfjZia6aaXxikQM=;
	b=5zA8PxcutpRMlvvQvk2VM+a7UvorkZ5HxSF5B3ltb+Z17q5wqAMlOYnyfWmShBw+PvfbPw
	BLMSoAKrkm1iR/b4xr11I5te7SzOgE813Qke/Ny4tzZCtVCzE/RI4OV6zfDqC3qvZrzhrr
	SDuaUF9zS+nfJ2xaZUvKQIwXUnZMLj8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=ag1WRAWJ;
	spf=pass (imf20.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769181358; a=rsa-sha256;
	cv=none;
	b=3/gXQj/m3B2nGeMZR5nCQrGBETKGwuNf3Pg5oqfJa2Ukf5uJ6pBVUV29T2LBoFy4Zkj0Yn
	8DBq2kkFWeVidkL8XxWkKy7PXrVm6GL06iT79oQlbwIzR10GVvnTISdgVtopMBMORtuApB
	wRidHj2EjKte/tIEkIeWEJnbmACBnKQ=
Received: from localhost (localhost [127.0.0.1])
	by smtp.simply.com (Simply.com) with ESMTP id 4dyM2M6CZPz1DHVR;
	Fri, 23 Jan 2026 16:15:55 +0100 (CET)
Received: from [10.10.15.21] (h-98-128-223-123.NA.cust.bahnhof.se [98.128.223.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by smtp.simply.com (Simply.com) with ESMTPSA id 4dyM2M10Vkz1FDXX;
	Fri, 23 Jan 2026 16:15:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gaisler.com;
	s=simplycom2; t=1769181355;
	bh=bZOD1qxujIU3XqsrT9Q0is3A3LXGMfjZia6aaXxikQM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ag1WRAWJtsN0/+CXBOsevJVeLpSL3/UnOj7eGnW5g7r2ql6jKEN6uMQEFz39jpWTj
	 70hB6mp8Ve1s6Wp5eFrGmiH/PwtssmQd+OO1x2dJ25+zQ8YZn2M7a8oa0nbx1j6rlf
	 1jVZ+eG2KhetS8xTd2rubzhycPTOvv5H3QVv5BOpKDJUbmQFZnHbjmifqmRJK+rcmN
	 m8LMVMH5b3JJXy0dqOhyCLj8N4ZpFxTGlppCWijPb5T9bTpg9tndXUgxZ+8Iusk4Vm
	 o7IvTCBgZd7VuKCb0Zw5Xn08LvlpLoHpw8Ts3iS9q1RU+69VDDLKM0eepskCzawiEl
	 rXuEIPQaRFOug==
Message-ID: <9199f28e-e2b7-48c8-b61f-0b787e322443@gaisler.com>
Date: Fri, 23 Jan 2026 16:15:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] mm: make PT_RECLAIM depends on
 MMU_GATHER_RCU_TABLE_FREE
To: Qi Zheng <qi.zheng@linux.dev>, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, peterz@infradead.org, dev.jain@arm.com,
 akpm@linux-foundation.org, david@kernel.org, ioworker0@gmail.com,
 linmag7@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>,
 sparclinux <sparclinux@vger.kernel.org>
References: <cover.1765963770.git.zhengqi.arch@bytedance.com>
 <ac2bdb2a66da1edb24f60d1da1099e2a0b734880.1765963770.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
From: Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <ac2bdb2a66da1edb24f60d1da1099e2a0b734880.1765963770.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s5wxnmg3a4qys3ew3fyrktefm61xayfm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 992321C0013
X-HE-Tag: 1769181357-70499
X-HE-Meta: U2FsdGVkX18gD0RIGYRSkxfWCStaxXyz8ThE4C2ZZzVwWf9w2r84sLAby42jK3k2a5QZZynBovuHKdFT21p24ANS7ayOPlhLtyAfRW4Ym/MncWI9dF+xssjb4WHx9ifa0R/ANzD+6vzM1KOWUhzpsqU/65uolW2AfukrE43YHjLKP0n1QBU1i3TrMeR02D38Y5hYdyc34ME4NC0pJdanbNR6kwSu9qzzmuITR4D3IOTYm2mc6XOKQvvX+Uoy9A5OZryEADWxzlagl9t40CR33Rmem2k7Vl39775GSjjQbv5z03Y7jsmVMJFdBA2Kj/mwCeNRWMEo+cxrpcJlCDbnD+5TEuLhT0oQqJ0eAf/AvBypz8uaUcCfFJcjI9nVgGBwt8L9mSwAM9IAi/I/HMc58z523xv3Kj/Tn4zZlDhz0IapdXdYGU1uAp4+JrNbYwyrVIsDcRCvisJwxz2EOTyFzyhx5bcM7RctTqCoM+qKQ7ZryRv5OzOOFFKDlWY5b94LOyNIGrM4xBZ0sNUSFtZsPR4jr/7UttBkdwh68aMbc3/o6sYrWmW4I2cfqU7HlZYEPcrsJ+CBUvm7yh5lAOB5XdxTl1T0c12rxOZDQPxMGoQ1oqOxp5j4YRlDm6MwoMPCIGdOFA5R0dTibpfh9yEPxcp4Ss3O9SDpEn2S7ooAmRB6xIZclyOg8d02JcGcAFUcaXyQpYUMmwbShTy6N4ZTUa0sXO2Fqa7uye1xycsaxSTqI0Xe1N3S2gE0lgZQY8PkNzu/N1YyTSrUzQsHpqP/W8CpVEjxFy6hTFFYFAVO40SpjxcWNSJPT984F0Zk8paL6M6U8KtVb8BpxT7giH3d1skZSRSL9+7gvagww92b5YWq4jpxXfCXxINGSRFdw1u211C5im34Lo2dNy4x0D1Dc+3n3HKYwH1hguGc6PMZKk36iOOAYthXLTIwLZQKsAvEVlBFcnnGeNpcfJDwOBS
 ABAPx+y4
 Nb5Iu00/TTfYH5SXL7JJZLs+VOPI40MWDiAkXkxAn9GkKl3cegcknsfvsJHQT07uivBywqvLuVRgt/rSKTG9PXQM8QCHxmqxCrOTRxW/R/xclH1yWRG6LN/tT0m8BktIcS0gd35dNmGJG/aRKA+8sv/kgtw1HH/YOOY1c4eBoeyWeftPto9tkjaq1CG6NWOEFN/50Sk2TtDWUPD/yLFvoND2nbGTFZWahAG+bncN3Jxxl8plmIik2ejt4+3IUKLwhf+o75w4K/oq1sHYpZi30DZfRHtn+piQXe6R7CvxMkjA9WbrpcKqU0EPZ8gvbCu3gM4ic2c+uCqAAHoOXjhp8HqWpCdJiZGZIyQiPE4BC+1fXmPxvjE4O4HXBw8DX87gOWZwg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-17 10:45, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The PT_RECLAIM can work on all architectures that support
> MMU_GATHER_RCU_TABLE_FREE, so make PT_RECLAIM depends on
> MMU_GATHER_RCU_TABLE_FREE.
> 
> BTW, change PT_RECLAIM to be enabled by default, since nobody should want
> to turn it off.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  arch/x86/Kconfig | 1 -
>  mm/Kconfig       | 9 ++-------
>  2 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 80527299f859a..0d22da56a71b0 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -331,7 +331,6 @@ config X86
>  	select FUNCTION_ALIGNMENT_4B
>  	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>  	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
> -	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
>  	select ARCH_SUPPORTS_SCHED_SMT		if SMP
>  	select SCHED_SMT			if SMP
>  	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
> diff --git a/mm/Kconfig b/mm/Kconfig
> index bd0ea5454af82..fc00b429b7129 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1447,14 +1447,9 @@ config ARCH_HAS_USER_SHADOW_STACK
>  	  The architecture has hardware support for userspace shadow call
>            stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>  
> -config ARCH_SUPPORTS_PT_RECLAIM
> -	def_bool n
> -
>  config PT_RECLAIM
> -	bool "reclaim empty user page table pages"
> -	default y
> -	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
> -	select MMU_GATHER_RCU_TABLE_FREE
> +	def_bool y
> +	depends on MMU_GATHER_RCU_TABLE_FREE
>  	help
>  	  Try to reclaim empty user page table pages in paths other than munmap
>  	  and exit_mmap path.

Hi,

This patch unfortunately results in a WARN_ON_ONCE and unaligned
accesses on sparc64:

$ stress-ng --mmaphuge 20 -t 60
stress-ng: info:  [559] setting to a 1 min run per stressor
stress-ng: info:  [559] dispatching hogs: 20 mmaphuge
[  560.592569] ------------[ cut here ]------------
[  560.592663] WARNING: kernel/rcu/tree.c:3098 at __call_rcu_common.constprop.0+0x200/0x760, CPU#4: stress-ng-mmaph/568
[  560.592777] CPU: 4 UID: 1000 PID: 568 Comm: stress-ng-mmaph Not tainted 6.19.0-rc5-00127-g62fc9f6ccb97 #8 VOLUNTARY
[  560.592805] Call Trace:
[  560.592812] [<00000000004368b8>] dump_stack+0x8/0x60
[  560.592844] [<0000000000482a60>] __warn+0xe0/0x140
[  560.592878] [<0000000000482b64>] warn_slowpath_fmt+0xa4/0x120
[  560.592901] [<0000000000526a40>] __call_rcu_common.constprop.0+0x200/0x760
[  560.592931] [<0000000000526fd0>] call_rcu+0x10/0x20
[  560.592954] [<0000000000730838>] tlb_remove_table+0x98/0xc0
[  560.592986] [<000000000071bec4>] free_pgd_range+0x224/0x4c0
[  560.593021] [<000000000071c35c>] free_pgtables+0x1fc/0x240
[  560.593042] [<000000000074a6f0>] vms_clear_ptes+0x110/0x140
[  560.593068] [<000000000074c3dc>] vms_complete_munmap_vmas+0x5c/0x280
[  560.593094] [<000000000074de5c>] do_vmi_align_munmap+0x1dc/0x260
[  560.593117] [<000000000074df80>] do_vmi_munmap+0xa0/0x140
[  560.593142] [<000000000074fb2c>] __vm_munmap+0x8c/0x160
[  560.593168] [<000000000072cfd4>] vm_munmap+0x14/0x40
[  560.593190] [<00000000004402a8>] sys_64_munmap+0x88/0xa0
[  560.593221] [<0000000000406274>] linux_sparc_syscall+0x34/0x44
[  560.593274] ---[ end trace 0000000000000000 ]---
[  560.593960] log_unaligned: 209 callbacks suppressed
[  560.593979] Kernel unaligned access at TPC[526a4c] __call_rcu_common.constprop.0+0x20c/0x760
[  560.594121] Kernel unaligned access at TPC[526864] __call_rcu_common.constprop.0+0x24/0x760
[  560.594198] Kernel unaligned access at TPC[52b3c4] rcu_segcblist_enqueue+0x24/0x40
[  560.594275] Kernel unaligned access at TPC[526860] __call_rcu_common.constprop.0+0x20/0x760
[  560.594360] Kernel unaligned access at TPC[526864] __call_rcu_common.constprop.0+0x24/0x760
[  567.054127] log_unaligned: 1105 callbacks suppressed
[  567.054167] Kernel unaligned access at TPC[526860] __call_rcu_common.constprop.0+0x20/0x760
[  567.054331] Kernel unaligned access at TPC[526864] __call_rcu_common.constprop.0+0x24/0x760
[  567.054410] Kernel unaligned access at TPC[52b3c4] rcu_segcblist_enqueue+0x24/0x40
...

I bisected to this one on mm-unstable from approximately 2026-01-12.

The warning is from 

	/* Misaligned rcu_head! */
	WARN_ON_ONCE((unsigned long)head & (sizeof(void *) - 1));

in __call_rcu_common() and the unaligned accesses follows from there.

Regards,
Andreas


