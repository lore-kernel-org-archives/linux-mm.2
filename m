Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E2B9CAC59F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 08:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BF358E00DC; Thu, 18 Sep 2025 04:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9487C8E0093; Thu, 18 Sep 2025 04:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837928E00DC; Thu, 18 Sep 2025 04:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C2028E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:52:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 122D61A04C4
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:52:56 +0000 (UTC)
X-FDA: 83901755952.29.83FEC6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4378740007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:52:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L6gVLpCg;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758185574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hGabipNNDw6XeeHu/gW3wNELKtbpfXeCcvUc6Dbo8Bo=;
	b=2GxYlfpNSwUVWA9cjhG4lGROPWDe3jqsMpuc8uRVv5Wof9mUtgXOXiU4K7HeVXJNtqCROA
	elCz2sUeSRZNxAPRi0Ox2IwMhtDD036ublnwCaxxs4prnznDHtBf9LqrIxMWHIi6GaiSpX
	Vhuwe+lz6lR2rmLd7Lej4zqgjEGLFyY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L6gVLpCg;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758185574; a=rsa-sha256;
	cv=none;
	b=zSmfneJz4XyQ6otXqR+rxP72+zibkD8HiaouL9pyNXZOYkqalcikgFnA+wblvx8lRG9aHA
	tCjAliK3u9L9LSL79c0ZNww571PF9DsIwUKBX4D1i9x0L3ev6vlskL7flhv1KAsMkoIQSG
	h7X5IBSJsxZPdMTnab3ERAZn7WXZX94=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2CA08445BD;
	Thu, 18 Sep 2025 08:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4713C4CEE7;
	Thu, 18 Sep 2025 08:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758185573;
	bh=0M5LM0c8y+CtEFZ3d/JKxqrH2sSLDWz7njz6l7NWh3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6gVLpCg20pntw8sER7to9BKLjByFOwJnBTdxoN1T2Nvcbz8fq7Ju1lIAkqTPUOSO
	 YZXp4QQ3kEwz7QrGlrnQyZNRb86q4vx52YoPJVuLZQtzuiSLMRz+XDIxGGhRKG6irT
	 3YV+snln4FfLqXfNwJxhET5ShiuMIWgfPwtiwP46GSExOtVQOyHBBtW562UVPtnnVo
	 ctWKTbHRQsbSE91E3bPJLo8aCOaRP4oqcwMDv9s9I3rws2dUNGEJnjap8uPCiGOEVu
	 VGWs0m1ik01YGI1UOH4hKSb/jLQe5k7qXGm4m34I1iJ7kfTL2AH3Nfilxk+2V+WTmV
	 vkEx37E9NEnVA==
From: SeongJae Park <sj@kernel.org>
To: Xinyu Zheng <zhengxinyu6@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zouyipeng@huawei.com,
	Hugh Dickins <hughd@google.com>
Subject: Re: [BUG REPORT] mm/damon: softlockup when kdamond walk page with cpu hotplug
Date: Thu, 18 Sep 2025 01:52:49 -0700
Message-Id: <20250918085249.58966-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250918030029.2652607-1-zhengxinyu6@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4378740007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: kccmdkb3fqpp436prgp5erejgsiwnoju
X-HE-Tag: 1758185574-256230
X-HE-Meta: U2FsdGVkX19kF1bsFQ/sGsBwsYCZcMitaJFNEo/ZYrLRLUQeW4Ayd6ZrWwPJEincZ6PwnZ77sW69aFSN7r0WIRQcT4xNK9+vqTsWIvDki/6kEkS5ADG4MxUFQKXc+kdTAasa/ab2EMf4BI1wdH38BwdOyYzthgNFrop95MeN4hBaHlcXJmuZSThzM6LLxDveOmBTZVTmCx2Us/biDUIt1H7y4q31WymdQ2GEvujSHE654Mn7Xxv/xUncMQnVot4oMB2WoUs2FkYb8bYmz3nkxPq1b4b4vKa80wRkzo/Q6Ruz6+95eDtCgN6/JiKjwdzxAUjU19UhgwukZMo9aKPPpMY0lnB5WdR2g5RzdgY40jeEAbv3QiDjoj7qxEo6u4SEa4CAZnC38En1wieX9dkBihsJFPwE2qkx+GtbSXJNi/aA66RZN8VokTYH/fDnoyxZKkvFg13CQBVj8fa+QILtX99jKg8nucVAHyV9d/1WAH3y1wBekGmGFv0/t9EBt1MaeyO4lrtj0+cm3PITsTlNAHs+lpqYsxNcmJ9SPnBZjKc9L0qEOF6OewBCzkOFhYzbhVZ0ujfwox4KzHk05RrcKVNRNOwCNRp5UWumBEcED7ouj3QA2gqMPdb+feeQ1gVR8G2L1d/8OTeB3enerT4sqQS/7LG9Wpuhx+ApVkLoTyHtKPJ+BQvVwg4FDl8sf1VDWBunBrIFno2m52FIGkKTZNn4pCcUmn6jcRLCjid8qXL9mHSrdt4d3BJMEkL6XzhSxIWCh6OBRdC2eHNC/3RG4U0yo/TCXALMqX9IikDSrD65J0KrWoVB06BZTkw9xU/xvLNjvv+NyvrINPe3CAKbFDY/2a4oRaT/HStT1tLYcNZ6oIBG8TJ7NZKzMJvLl1xBQPwKE3SUPgyQGuWOBvgrjVze+11Wo3ZEMbHPWYlCzCOMXboWJmZE4gFnB0583W1IUWj0xDVq78CbQhJtzVB
 In5nEyM+
 7iXPT0lZELlEmaRu2TO5tFtSz1Pz//jzkbvvH4pE21LWUdx5KKJAxqN0XlbF4L6ONG4Duq8HQ8ceviHy/YsZ3+B+L0eKyy4z1MV/1OjxY0MbqtcH9ur66unSCnG1XFzPAOJlp2UtC2jgkLDLgPs2Yp24F0zoOETX5O4HpI2bjAWJC0ZJOnFFCl/Kj8dIIaOUpaaK094fzaz8tbMdBEvPbGzzNMtNwTjcXPl4oM8Hul1rn9J+grc7qJs1gpZGmAIGsVD2FDS4QYUm9S8QdFeeeO4FQkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Thu, 18 Sep 2025 03:00:29 +0000 Xinyu Zheng <zhengxinyu6@huawei.com> wrote:

> A softlockup issue was found with stress test:

Thank you for sharing this great report!

> 
> watchdog: BUG: soft lockup - CPU#0 stuck for 26s! [migration/0:957]
> CPU: 0 PID: 957 Comm: migration/0 Kdump: loaded Tainted:
> Stopper: multi_cpu_stop+0x0/0x1e8 <- __stop_cpus.constprop.0+0x5c/0xb0
> pstate: 61400009 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> pc : rcu_momentary_dyntick_idle+0x4c/0xa0
> lr : multi_cpu_stop+0x10c/0x1e8
> sp : ffff800086013d60
> x29: ffff800086013d60 x28: 0000000000000001 x27: 0000000000000000
> x26: 0000000000000000 x25: 00000000ffffffff x24: 0000000000000000
> x23: 0000000000000001 x22: ffffab8f02977e00 x21: ffff8000b44ebb84
> x20: ffff8000b44ebb60 x19: 0000000000000001 x18: 0000000000000000
> x17: 000000040044ffff x16: 004000b5b5503510 x15: 0000000000000800
> x14: ffff081003921440 x13: ffff5c907c75d000 x12: a34000013454d99d
> x11: 0000000000000000 x10: 0000000000000f90 x9 : ffffab8f01b657bc
> x8 : ffff081005e060f0 x7 : ffff081f7fd7b610 x6 : 0000009e0bb34c91
> x5 : 00000000480fd060 x4 : ffff081f7fd7b508 x3 : ffff5c907c75d000
> x2 : ffff800086013d60 x1 : 00000000b8ccb304 x0 : 00000000b8ccb30c
> Call trace:
>  rcu_momentary_dyntick_idle+0x4c/0xa0
>  multi_cpu_stop+0x10c/0x1e8
>  cpu_stopper_thread+0xdc/0x1c0
>  smpboot_thread_fn+0x140/0x190
>  kthread+0xec/0x100
>  ret_from_fork+0x10/0x20
> 
> watchdog: BUG: soft lockup - CPU#18 stuck for 26s! [kdamond.0:408949]
> CPU: 18 PID: 408949 Comm: kdamond.0 Kdump: loaded Tainted:
> pstate: 61400009 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> pc : damon_mkold_pmd_entry+0x138/0x1d8
> lr : damon_mkold_pmd_entry+0x68/0x1d8
> sp : ffff8000c384bb00
> x29: ffff8000c384bb10 x28: 0000ffff6e2a4a9b x27: 0000ffff6e2a4a9b
> x26: ffff080090fdeb88 x25: 0000ffff6e2a4a9b x24: ffffab8f029a9020
> x23: ffff08013eb8dfe8 x22: 0000ffff6e2a4a9c x21: 0000ffff6e2a4a9b
> x20: ffff8000c384bd08 x19: 0000000000000000 x18: 0000000000000014
> x17: 00000000f90a2272 x16: 0000000004c87773 x15: 000000004524349f
> x14: 00000000ee10aa21 x13: 0000000000000000 x12: ffffab8f02af4818
> x11: 0000ffff7e7fffff x10: 0000ffff62700000 x9 : ffffab8f01d2f628
> x8 : ffff0800879fbc0c x7 : ffff0800879fbc00 x6 : ffff0800c41c7d88
> x5 : 0000000000000171 x4 : ffff08100aab0000 x3 : 00003081088800c0
> x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
> Call trace:
>  damon_mkold_pmd_entry+0x138/0x1d8
>  walk_pmd_range.isra.0+0x1ac/0x3a8
>  walk_pud_range+0x120/0x190
>  walk_pgd_range+0x170/0x1b8
>  __walk_page_range+0x184/0x198
>  walk_page_range+0x124/0x1f0
>  damon_va_prepare_access_checks+0xb4/0x1b8
>  kdamond_fn+0x11c/0x690
>  kthread+0xec/0x100
>  ret_from_fork+0x10/0x20
> 
> The stress test enable numa balance and kdamond, operation 
> involves CPU hotplug and page fault with migration.
> 
> CPU0				 CPU18                      events
> ===============================	 ======================     ===============
> page_fault(user task invoke)
> migrate_pages(pmd page migrate)
> __schedule
> 				 kdamond_fn
> 				 walk_pmd_range
> 				 damon_mkold_pmd_entry      <= cpu hotplug
> stop_machine_cpuslocked	         // infinite loop
> queue_stop_cpus_work		 // waiting CPU 0 user task
> multi_cpu_stop(migration/0)	 // to be scheduled
> // infinite loop waiting for
> // cpu 18 ACK
> 
> Detail explanation:
> 1. When shutdown one cpu, a state machine in multi_cpu_stop() 
> will wait for other cpu's migration thread reach to same state. 
> In this case, all cpus are doing migration except cpu 18.
> 2. A user task which is bind on cpu 0 is allocating page and 
> invoke page fault to migrate page. Kdamond is looping between 
> damon_mkold_pmd_entry () and walk_pmd_range(),

damon_mkold_pmd_entry() calls pte_offset_map_lock().  If the call returns an
error, damon_mkold_pmd_entry() sets walk->action as ACTION_AGAIN, to retry.  If
the pte_offset_map_lock() continues fails, infinite loop can happen.  I
understand the loop you mentioned above is this case.

The error handling (retrying) was introduced by commit 7780d04046a2
("mm/pagewalkers: ACTION_AGAIN if pte_offset_map_lock() fails").  According to
the commit message, it is assumed to be safe to retry pte_offset_map_lock()
inside walk_page_range(), but it is not for this corner case.  And the commit
introduced the error handling pattern in not only DAMON but also a few other
pte_offset_map_lock() callers, so I think same issue can happen on those, too?

So for the long term, I'm wondering if we should update pte_offset_map_lock()
or whole pte_offset_map_lock() error handling inside walk_page_range()
callbacks to deal with this corner case.  Or, other involved parts like CPU
hotplugging handling?

> since target page 
> is a migration entry. Kdamond can end the loop until user task is 
> scheduled on CPU 0. But CPU 0 is running migration/0.
> 3. CONFIG_PREEMPT_NONE is enable. So all cpu are in a infinite loop.
> 
> I found a similar softlockup issue which is also invoked by a memory 
> operation with cpu hotplug. To fix that issue, add a cond_resched() 
> to avoid block migration task.
> https://lore.kernel.org/all/20250211081819.33307-1-chenridong@huaweicloud.com/#t
> 
> May I ask if there is any solution we can fix this issue? Such as add a 
> cond_sched() in kdamond process.

I think adding cond_resched() on the error handling part of
damon_mkold_pmd_entry() is doable.  Since DAMON is a best-effort approach, just
returning without setting ACTION_AGAIN would also be ok for DAMON.  It will
simply make the behavior same to that before the commit 7780d04046a2
("mm/pagewalkers: ACTION_AGAIN if pte_offset_map_lock() fails").

If this is a real issue making your products bleeding, please feel free to send
such a fix for DAMON (I'd prefer the second approach - just return without
setting ACTION_AGAIN) as a hotfix.

Nonetheless, for long term, as I mentioned above, I'm wondering if we should
update pte_offset_map_lock() internal, or add similar error handling
modification on every similar pte_offset_map_lock() error handling.

> Or is there any chance to do some yield 
> in stop machine process? Probably next time there is another different case 
> running with cpu hotplug can cause the same softlockup. 

I'm not familiar with stop machine process, so I have no good idea here but
this might also be an option?

> 
> Xinyu Zheng


Thanks,
SJ

