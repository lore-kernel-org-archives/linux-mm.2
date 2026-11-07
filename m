Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9960D606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 06:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=NpNHKmNh
Received: by kanga.kvack.org (Postfix)
	id 82B6F6B05B2; Sat,  7 Nov 2026 01:54:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8042E6B05B3; Sat,  7 Nov 2026 01:54:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C1E6B05B4; Sat,  7 Nov 2026 01:54:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6EA6B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 01:54:26 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5C62A7C8D
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 06:54:25 +0000 (UTC)
X-FDA: 85407409290.16.EF21F97
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 260961C0002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 06:54:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NpNHKmNh;
	spf=pass (imf18.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794034464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7KJP7j2uL4vPq5fW0b0gSJi5ZwRkv6NnOMBE9fSZtqQ=;
	b=PZbh/+gbv25qeAG5Ra3fWgsdKCn/Di/6daz3bU3cj9XFHJ08cnSYHtlAWr4z09uiUUxumv
	17z5iLUctMcRuJ92Z6m4e9TDSaF9WdYmVPvCOkEfjfOW/UoxZZoDZ5J14/GaNVPlu0q6Qj
	NUJxCauR4eEZhjDoT6MhH44aQqqB72M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NpNHKmNh;
	spf=pass (imf18.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794034464;
	b=sfuHYs9RXC8sX5CyGkgeI4nyfCYYmcIf7N1IUjwji4HPurRFqReTJQQdJyKNENiQtBKHF4
	4toAYA1ga8CbCE11iAW9mUAVs4fyGC88JaSH1VtsbFheCUoZPoXT8ThrVWZ4r+AmmySkH7
	+mwdNmMpYy5dEFROm0kC8cKKPXkwCwU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794034457; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=7KJP7j2uL4vPq5fW0b0gSJi5ZwRkv6NnOMBE9fSZtqQ=;
	b=NpNHKmNhUAx622uQqI6k5wGpxeTIhX+N5T4rWKBE+AQ72WCGu9j9UM+7e6W8lZxFA59qG2q+Oq3riUFzvgIO0R5l4vBQX6kkk7pvmu9vO8gMDN0K7VSCIYVjyJgx4TkY8l9uLjQv4hvIQmg/5nAUVb19vEEDjXL7jDRkzpJJdX4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0XEDj0Ge_1794034454;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0XEDj0Ge_1794034454 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 07 Nov 2026 14:54:15 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Zhiteng Qiu <qiuzhiteng@hygon.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Zi Yan <ziy@nvidia.com>,  Matthew Brost
 <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,
  Byungchul Park <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,
  Alistair Popple <apopple@nvidia.com>,  Xin Hao <xhao@linux.alibaba.com>,
  Dave Hansen <dave.hansen@linux.intel.com>,  <linux-mm@kvack.org>,
  <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/migrate: don't batch the TLB flush when there is
 nothing to batch
In-Reply-To: <20261107015057.1328227-1-qiuzhiteng@hygon.cn> (Zhiteng Qiu's
	message of "Sat, 7 Nov 2026 01:50:57 +0800")
References: <20261106041628.1177963-1-qiuzhiteng@hygon.cn>
	<87zevmwbaj.fsf@DESKTOP-5N7EMDA>
	<179395975709.1235605.1971486611419119070@hygon.cn>
	<20261107015057.1328227-1-qiuzhiteng@hygon.cn>
Date: Sat, 07 Nov 2026 14:54:14 +0800
Message-ID: <87qzgxw2qx.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: ckh36ywdbd65wy7n7pqyq37r6oonof3p
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 260961C0002
X-HE-Tag: 1794034459-516842
X-HE-Meta: U2FsdGVkX1+LIIWPLRY2W0zsqz4YhIHIUpeOMWdtsCDhCv+mpmGY98gwBQO3PAAlYBx2LQMUgdU6AXEoeFwEW6jt53cddrBjdHCBOZk3XLENU5DALL27A6sDp07ShJXY8QV/TcJowV7IjOKP5dyN9gsHby1+hUmJbffwERdI22qbkIm3oFd3OPe3imMr37NSkoRCfe64fLIe3zLSObOaS/kcS7Y2G4aa2T4EZaEB7862XavB3lQN7uoTxXg9B3l+1orXhteqpaLcqCweQ/AhvmhuIbUi/8/ZE+FDr1CK4pGC9zjvVNJKXmrXvWLLpncTTdstATYLPnnfanyrg/rgLlyhOxqi+o6p82e6N++LcaTmH+EwWuB7O6Y4TdPJVAu3jpGbm7ZEQAuBs5VQ6x7BpEa9vS2+eUhh5h3nwdJKeGG7BjqwDZ17mFptrRq/E++dT2U72TKt1ZH9eMXq6MVZSfz285H4MBalg2dmg+jKuydmE761zenQ43LHof6N29LRHvEPKySt+P1g9nn6E+Cay47/4YIl9eIV33Mrtt4kQvLPuj1/oyU6y1KBpba/vCPSvqoZLGvRz10EcJZ1MCGuX7xzozd9XuVys28Ae9cUxJTlKhH2krjqP7+fwtugt9sb3/9iMNv+yp3Uwk7a6WCDmtXy2kwl9czToU5yC0EW7uHLIzNu8pUEXF+12SmPsUzYuzoshw4reMSkuedTAbBnH45Lnf+Wnh6bsRnaQv12qdS5JkW6CHtRXvEVxCTCL+NiTQO25/bVAiYdsNJlU4/kfIXjwwb6R+J670Sn/felId439XdglXqi4hwhw48aNXd0c8HK5Z6dSU05XllJTdsB4KN98N1ht++BIvp1bQWt1fryPaACFaigTOO82eO5XfKIJlxZjJxHcO2RX5l+8LjgA8qgD89tRMD3ol4MZrEf/MxF7G3qlfb+C/4blCU0/etJeB9/Kn70xM984rIewdH
 sXnJv+vI
 23uTruvxc2U7VpbXxB2IPDgHTP1OeCDxs+AvnAajY15QtNqOmBaDI4Cj19lMhnPAr0QvE+cOsapD71jbv3uUQUNAmFBkwdWvPERSyph3NM6FEX2qRbjY2goojQE0yS7ZQqu70VD3n/mcoPwsLdyTjWNAULyByb7QnIyObAyHhw/Ra88gGcBT7jv6h6pv4epzoCLO7YLx8OV/M8Zh9q5x3MmOjNbQes0oJ2mHx68KKMek7MNzwCueuWYupjdd9flhZSYJLfWrxcQbEb7m8y7GD0eh4T8I8LeSsqgEj7YNZR+1znSBCbAvlSURTqcFZLMu0deN1097uWdBVltCBBgEGAW/0qmBA6BakisZyztvH0ECsuQgqogDgcIgGBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Zhiteng Qiu <qiuzhiteng@hygon.cn> writes:

> Hi Ying,
>
> I instrumented the unmap path on both kernels (kprobes, 55 s windows,
> same workload).
>
> b99a342d4f11 does what it should.  On the patched kernel, where the
> old PTE can be read from ptep_clear_flush(), about 96% of the PTEs are
> still PROT_NONE when try_to_migrate_one() clears them.  The flushes
> come from pte_accessible() treating a PROT_NONE PTE as accessible while
> mm->tlb_flush_pending is raised.  On the unpatched kernel that is the
> case for about 42% of the migrations (3.5% with the patch), and each of
> those does a full arch_tlbbatch_flush() to about 380 CPUs.
>
> tlb_flush_pending is raised that often because of a loop.  Each batched
> unmap bumps mm->tlb_flush_batched, and only flush_tlb_batched_pending()
> marks it flushed.  So while migrations keep coming, change_pte_range()
> in the NUMA scanner does a flush_tlb_mm() for every PTE table it walks:
> about 11,600 full flushes in the window, one per 512 pages scanned,
> and 99.9% of them come from that call stack.  The average mmu_gather
> in task_numa_work() takes 91 ms on the unpatched kernel and 6.7 ms with
> the patch.  A longer scan catches more migrations with
> tlb_flush_pending set, and more migrations make the scan pay again.
> With the patch, a lone order-0 folio is unmapped with
> ptep_clear_flush() and never touches tlb_flush_batched, so the loop
> does not start.  The remaining ~13 interrupts per page with the patch
> are the same effect at a much smaller scale: the 3.5% of migrations
> that still overlap a scan.
>
> So the patch helps by not leaving a pending batch behind, not by making
> a single flush cheaper.  I'll rewrite the changelog to say that in v2.

I found that it's not easy to understand the text above.  A figure like
the one in the below commit may help:

https://github.com/torvalds/linux/commit/5a6c9cf117fca3c38a98fb2a2d5549795c8b0b73

Have you adjusted the NUMA scanning parameters?  I originally thought
that the scanning is slow, so it wouldn't be common for scanning and
NUMA hint faulting to race.

> The loop could also be broken on the flush side, by letting
> try_to_unmap_flush() mark the batch as flushed.  But tlb_flush_batched
> is per mm while the batch is per task, so I don't see a simple and safe
> way to do that.  Would you prefer that direction, or is the change in
> migrate_folio_unmap() fine?

That appear too complex.

---
Best Regards,
Huang, Ying

