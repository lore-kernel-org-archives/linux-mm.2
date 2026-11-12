Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23DA8606A338
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 03:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=hdevINua
Received: by kanga.kvack.org (Postfix)
	id 49D676B05BF; Wed, 11 Nov 2026 22:08:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 476156B05C0; Wed, 11 Nov 2026 22:08:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B3CF6B05C1; Wed, 11 Nov 2026 22:08:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 161676B05BF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:08:23 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF30480497
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:08:22 +0000 (UTC)
X-FDA: 85424983644.03.4D02880
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id DA1E440007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:08:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hdevINua;
	spf=pass (imf27.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794452900;
	b=vKaClR4d3pYEKB/33iNF9Or4Br462b5UZNULu9jxBm+7sSgSqvsd4rVI7X0TmSoRlSqi3M
	ZZVtZ2H6gaSwmJQOvcdZgjxmJyhMd9rc07GGOf61Hydg2/R4TOIWVvvrLdLQdSi9nZrpA1
	KYhQ9NaTNfzvQ/fVpjjaXhxZeKDSV+A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hdevINua;
	spf=pass (imf27.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794452900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0hASrZa3KsQ/rJDPLJgE3hfFDgP737Rr5tw+ZVyeGEQ=;
	b=O7/vpGqeAjOSMUyZ7mxQ/vgVAkWmO/e+fq2hQuya+RphtGH7I5iTIXWD2w1gDT8in1jLTM
	uoucak+Oydo1v8xb4GHnVXlZgca7w32BOYzXpFlSv3NwxsCy4llDdkqlUj4j3PIduHJD8c
	UZXiL6cPybj/llr3zTtJhZfeE/+eCOs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794452896; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=0hASrZa3KsQ/rJDPLJgE3hfFDgP737Rr5tw+ZVyeGEQ=;
	b=hdevINuaBVEfHEJlhzzsXC9ClAz0O4Xdst4xJ50eJLBfWR8gHTU+wPkcytGkP0mpHTrZ3Fh9n4DZOEcEG+YcLOk0NhZMLSlc4FSpfFbcTKT1sj5+Qu19OAicXvYrpVqDJIk95oBwnzAOeFLsCd1+0ey/QIeAy3Ruucp7S8jMAVw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0XEaUfqM_1794452884;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0XEaUfqM_1794452884 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 12 Nov 2026 11:08:14 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Chris Down <chris@chrisdown.name>
Cc: Catalin Marinas <catalin.marinas@arm.com>,  Will Deacon
 <will@kernel.org>,  linux-kernel@vger.kernel.org,  kernel-team@meta.com,
  Mark Rutland <mark.rutland@arm.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Muchun Song <muchun.song@linux.dev>,  Oscar
 Salvador <osalvador@suse.de>,  David Hildenbrand <david@kernel.org>,  Mike
 Kravetz <mike.kravetz@oracle.com>,  linux-arm-kernel@lists.infradead.org,
  linux-mm@kvack.org
Subject: Re: [PATCH] arm64: hugetlb: Prevent write fault livelocks on stale
 TLB entries
In-Reply-To: <avPxZjjdBIlM_8_g@chrisdown.name> (Chris Down's message of "Tue,
	10 Nov 2026 20:39:02 -0800")
References: <avPxZjjdBIlM_8_g@chrisdown.name>
Date: Thu, 12 Nov 2026 11:08:02 +0800
Message-ID: <87ld6yn3vx.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: okuo1yjubbcxrsew8p6p4ns7pdztg48n
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DA1E440007
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794452899-260321
X-HE-Meta: U2FsdGVkX1/oqunMuiOIiimDlmZu1Ercv1Pse7RMltGeLOISpKqlE3bTuDvgE9mk5knGLmAwcRElcz85h7UY8QkrCipbG9Nzpg4tZnXezYMeQT8QoA4h8AaCQ8hpsS2+JorU6Kv3ZijxAEhbiRocv44RP7bFIoviRfJLUL68+I4YkBoR2ZUfySWWyT4vmBd8oT/SW4sYGnwlr4YIKLUzSn2ipXumQxS2HHCGiiwnVvorhvZWhzGkt2RncNp3kg73DB1oz5M+X/5zg6hzQ5BYo6ad0EE5X59PX7foi/7OELHyg7kOnClQDt8St5hyvHYyt0KRLEDnB1GfGFiv04u9TvGNJzSz1fNY9zJlFFuCyTNSfJlGUSJi0qm5qL7fb1ZdRas9H29WidTLlAg6kE8mm2/N3z3RIM5Nr6YEWeBYkxV2hKh2+l5DynJOZTc3kfZVlTOr8N/Wf7PRjCIPsR00QmQ7f1YNj9NK76MybvtdhXKfZdlFsuWJhuEauQveV7+AqXBC9GxBBZPyMpRyeIn6M1see0b/h8Zzd4SlvK++uq8ntcsdO+yLX8OvYNEmaGXynSDptPq5FBqYHESyB4HcQgkhTDFMbwa5zuaysAwc7A+4gz278a00u0OmYjXzhUbWfMeS1zgN7NdxIhROyyRzjxDBjVd2ULlKO/8/XUXB8rnREQ+GXaDvWBLm7gAhLeGSJj8Nhc6hbPRfY3PKvvojDmXvlFPpmn8+pybvdzD94Squkf+3tAptshh7WrVU2sv7i3enRjCtTkY/c3s1KTOPNMesmGjCnrhf+LidwYJev60Cdw4rp8mGcDdDMXBK8rU1UnBLpo34thUlUlarfCpLVE4Zy1kTa718K+Q99vKu8Y6vTEShX4Wk3zvqogV5LaDXCb7Ki4srlf15rEEpX0CGqtRfLXblwj+n80MN5vehC8Uz8WyijQp5vtlVu0AVVGq/y9Qav7Ju2WNdkeB1JZg
 XpYmQzi/
 jCds5CKX9PWmEUqrWnbUwjAOCiDQTfvGj4j4We/mH4j7IaqVBtAaJ7XP62SHSdc9c7vg8usV30DZEwsd65ZcCwZtuYqamT9vfupAuOEaTMj0Zm+JPJlMvyCgDfrpX7YNT1NcbMk93eZPuqiXa8Rl7aU5GGuXCqWCDGA5C9IXRVWLGDJDX7wmScHz3D4l8VdHXvj+kwxcWd3b9APz/zrudz2M8psqjOpavURJX0ED/y5oy9GAAWrHiwf/9ToXPN6RoxJ16zCpiDQ9VkmVt9uilmg2mC9KHMZa8nE2abyMdMV/+OwU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Chris Down <chris@chrisdown.name> writes:

> In Meta production, we have had tasks get stuck in a fault loop while
> using hugetlb on arm64. During my investigations I found that affected
> tasks share a private hugetlb page.
>
> Looking at the stuck task states, I found the following ordering:
>
>   CPU0                                 CPU1
>   ----                                 ----
>   read page
>   [read only entry cached in TLB]
>                                        write page
>                                        hugetlb_fault()
>                                          hugetlb_wp()
>                                          [reuse folio]
>                                          set_huge_ptep_maybe_writable()
>                                            set_huge_ptep_writable()
>                                          [flush local TLB only]
>
>   write page using stale entry
>   hugetlb_fault()
>     huge_ptep_set_access_flags()
>     [entry already writable, no flush]
>   retry write using stale entry
>   [fault indefinitely. well, that's not ideal!]
>
> The reason is that when a write fault makes a non-contiguous hugetlb
> entry writable, it only invalidates the local TLB. However, another CPU
> can keep the old read-only entry, so its write will fault even though
> the page table already permits it. hugetlb_fault() then finds nothing to
> change and leaves the stale entry in place, so the same write keeps
> going round in circles.

Good catch!  Thanks!

> This is particularly bad because, if the kernel is copying to user
> memory, the retry stays inside the kernel and the task can't act on the
> pending signal.
>
> It can even remain unkillable while holding locks across the copy,
> resulting in further failures. For example, a read into a hugetlb
> buffer can hold the pipe mutex and block other users of the pipe until
> the loop ends, causing cascading lockups across the machine.
>
> To fix this, when a write fault finds nothing to change in a
> non-contiguous hugetlb entry, let's invalidate the local entry.
>
> Fixes: cb1fa2e99955 ("arm64, tlbflush: don't TLBI broadcast if page reused in write fault")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---
>  arch/arm64/mm/hugetlbpage.c | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index 8e799c1fe0aa..ff1f53e435e1 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -429,9 +429,24 @@ int huge_ptep_set_access_flags(struct vm_area_struct *vma,
>  	VM_WARN_ON(!pte_present(pte));
>  	ncontig = num_contig_ptes(huge_page_size(hstate_vma(vma)), &pgsize);
>  
> -	if (!pte_cont(pte))
> -		return __ptep_set_access_flags_anysz(vma, addr, ptep, pte,
> -						     dirty, pgsize);
> +	if (!pte_cont(pte)) {
> +		if (__ptep_set_access_flags_anysz(vma, addr, ptep, pte,
> +						  dirty, pgsize))
> +			return 1;
> +
> +		/*
> +		 * Another CPU may have made the entry writable without
> +		 * invalidating our stale read-only TLB entry. To avoid
> +		 * indefinitely faulting on this entry, flush it.
> +		 */
> +		if (dirty)
> +			__flush_hugetlb_tlb_range(vma, addr, addr + pgsize,
> +						  pgsize,
> +						  TLBF_NOWALKCACHE |
> +						  TLBF_NOBROADCAST |
> +						  TLBF_NONOTIFY);

IIUC, this is similar to fix_spurious_fault() for non-hugetlb folios.
Can we use similar logic?

> +		return 0;
> +	}
>  
>  	if (!__cont_access_flags_changed(ptep, pte, ncontig))
>  		return 0;
>
> base-commit: 067c5c24cef23d913b67eaaf71ae67e7169a6620

---
Best Regards,
Huang, Ying

