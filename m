Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E20BC982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 12:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 475356B008C; Fri, 18 Sep 2026 08:38:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44CBF6B0092; Fri, 18 Sep 2026 08:38:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33C816B0093; Fri, 18 Sep 2026 08:38:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0BFB56B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:38:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B7A9160656
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:38:07 +0000 (UTC)
X-FDA: 85226835414.28.73B7DE2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A934F18000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:38:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LoZbd6DX;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789735085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HjoRpOQGdgI3jF+/9FxZtTBNtq2uuhw/a+czWqehIM8=;
	b=bHdkPh6I0ugs96sa80y+dsmlv3HMNGlz+Lx0iLn6saGG5ymPdw74gdi7is1VACo9XERIdO
	R1IQXfK07bzZTQRlYCE5Xh7XyZc8sgOLlYife5ulvTaavhNQXVa9NM0WkEzzTHjukH9URd
	Ag0c2PBYcD3BF55vahv4Vs5Zzbwhdcc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LoZbd6DX;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789735085;
	b=ywi8dzCH26qNkxvDXFnelvLJZM0ZKxcMdGQ1YpGEA+u+h2a72KzqOSkyPAh6QK2cuDhZ1v
	8ep56hMssnpcidoHfJ63x0BqAI9crv5RFG8fL9ghTS6uVZ4fiILnNghfSfYaLeaMuRBNft
	pfrXUIwPyiD8b5hWFMrZefeAalVrsHw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD0054021C;
	Fri, 18 Sep 2026 12:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947D61F000FF;
	Fri, 18 Sep 2026 12:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789735084;
	bh=HjoRpOQGdgI3jF+/9FxZtTBNtq2uuhw/a+czWqehIM8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LoZbd6DX+pORy/h4fvGM0bK/UMuJASInrc3aY0qebM0smo4PSbMjAIYGHbyb9qfNl
	 mJX810DP29QPXgcnaxoZ2coqKfT6thKV1upOUwNADFZz8JbYSELHAf6M5MjE8p5/6D
	 5jCBJgIh5/cqulc9plkjr4sRe/H18SqW+mZJER5mGBzjNKE9cpaRrE/yw/a98Mvrmy
	 WOOnxoZSv4mAeeMuo2/t2UdmkDPpVrSHk+VF1SKpqs4D36/r7IIpxazWxBbWPOzot/
	 85FM4WCrhrmSIkEhEYtVQkqDJUWI8GGkcrt3rkKKX51ovy6U6HgTc6ZaDneAkbOZuX
	 D2aAzvpwMWXOQ==
Message-ID: <9b5e1573-6fd8-48a5-a274-a6e7ff83d2fe@kernel.org>
Date: Fri, 18 Sep 2026 14:37:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: support promotion-only NUMA hinting scans
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, osalvador@suse.de,
 hannes@cmpxchg.org, raghavendra.kt@amd.com, stable@vger.kernel.org
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-2-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260911001826.2109390-2-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A934F18000B
X-Stat-Signature: z6m9ddrky65wmxm349bnfgzcpudanq6r
X-Rspam-User: 
X-HE-Tag: 1789735085-958622
X-HE-Meta: U2FsdGVkX19O7qy8lVlCH2Hof/XZOn3Bk2yulFgrOUuCrXmvGIxv0ce7ucv/36wuigbjJ2zEiagHLStvtk2SY7Em8f9lJxvq0IEEuEHVGbQdvkXK26hLezGbvmGBHckdC0oCJW8HBDJ9fqJacyxsShDJvZqXvVgpuOvkvkte7LokPlfJZiuh37pN/+RkmInXM93lPPskNN7X7r5pXTYYLDEOLQc5oFyWBeTmhTQpK3DZnXgibg8Udhfgq2Bw3lZgC61U18tuzgx5Jny6f2bUet8nP0s8SmXyKIT3jYClr9FFDhROjJsDSUOza99caz70ySc7AaDq1juqJrXMFfXkSLTauU1biGBJRny54sojsc6L6/KWgfOGhOWdp1N28m9l35aNKOE5DweZlvGaU/+2YH1LDBxVNSgKAcAXe2mxzuDnP4siqY/N3xdiKRzElf2gZibWnSaLikM6x7GAS0OdlLDpoi5eYXKnJdOM9gODcRH2RQPjktiIBwuKc+SZcf9ZHkLNPCbHeug7H3zM82LtThWCCZAQpTjk0xYoJw+pI3B2FQhclVmClFGargQ0zlyyjAT3D5sdSX1VIofGucE2UZfeItJqKCbdkdzol8KIYnH4+DclnhsP8fT4KFub3WZt8aezXiSfSPddOH/nutqrJwl1qK3K07Qu4PYdMX8lCii9/Dn+zBe/fHDqilIdWywTscfj8hMV4jW8FPucRTfkWGEicRQmHt4kOtz/hEIfJnvwU3fIVKWP8FewmJCj+kP1sQIRvM8B8Pzhz9mznVNXX8lGCj91Rxp0fgoHWtl7wxoRM7DZag4deIeiI8BhhJ0DvnN4p4KxmH3kg6eCDGUCDT49jyi1J3FC/LqbiX2N1Grqx+j88195I/jpW597v1BF+hEtK5Q3IxXGSkTB/vfAZCG2dNL0nYB898iOfsN9sZC3tmQISIywYOWQ/EI4O2sDTMPDXvLguF/4l1B6F1v
 JD10ABqv
 4HKUuKKyhAxZEXqafk5i+tVyJ6Pe7RmZFUg8azUzLUsR74o0y1XDF2/6wPK8l81hULUJEoP92cd9eOjFeU2Hke+QE0G7mo/wyPhIHUdVI8/XI4nDiYbZBAtqqw5tt53pf5yN3VLpcCVMcSdAMCpI9PKd/qMUj7F2rLQOG7Ab34R2BIVn9c83PKiSy4X1zzKwWJIKUEPw9VvImjBB4lTJ1PF/LA+2TzRsr+FRlKR8F9XCKPdzt+dC7R8xqzCMNnUooH2vQHZg/VzbotUEDbRCKYcBRiScmobhDbcw/M0WSUnRchGi/IjjY7egnXnCDn2+sNpSvgidAzENk3Qbri+WR8etuwlzlmVcXKbt6SFjEEeWg8Gkhlk1Y2ZzRJhxrJM5Ch655ka6S9Q1VKzEVJqBt3GkID/Dp/05D7l0L8Cnj/IxVfp8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 02:18, Gregory Price wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> folio_can_map_prot_numa() derives the eligible memory from the global
> balancing mode. Combined mode needs the scanner to distinguish placement
> scans from promotion-only scans.
> 
> Add MM_CP_PROT_NUMA_PROMO_ONLY and let change_prot_numa() callers request
> a promotion-only protection walk. Carry the choice with each walk so the
> PTE and PMD paths use the same decision.
> 
> Initially derive the value from the normal balancing mode, preserving the
> existing behavior for the following fixes.
> 
> Fixes: c574bbe91703 ("NUMA balancing: optimize page placement for memory tiering system")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  include/linux/mm.h  |  4 +++-
>  kernel/sched/fair.c |  7 ++++++-
>  mm/huge_memory.c    |  3 ++-
>  mm/internal.h       |  5 +++--
>  mm/mempolicy.c      | 22 +++++++++++++---------
>  mm/mprotect.c       |  4 +++-
>  6 files changed, 30 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 969594074fd2..2d1b59a27629 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3408,6 +3408,8 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
>  #define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* resolve rwp */
>  #define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
>  					    MM_CP_UFFD_RWP_RESOLVE)
> +/* Whether a MM_CP_PROT_NUMA change is for promotion only */
> +#define  MM_CP_PROT_NUMA_PROMO_ONLY        (1UL << 6)

BTW, shouldn't we just be using BIT()?

>  
>  bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
>  			     pte_t pte);
> @@ -4736,7 +4738,7 @@ void vma_set_file(struct vm_area_struct *vma, struct file *file);
>  
>  #ifdef CONFIG_NUMA_BALANCING
>  unsigned long change_prot_numa(struct vm_area_struct *vma,
> -			unsigned long start, unsigned long end);
> +			unsigned long start, unsigned long end, bool promo_only);

While at it use two tabs.

>  #endif
>  
>  struct vm_area_struct *find_extend_vma_locked(struct mm_struct *,
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 8dff37059faf..81359b414947 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4129,8 +4129,10 @@ static void task_numa_work(struct callback_head *work)
>  	unsigned long nr_pte_updates = 0;
>  	long pages, virtpages;
>  	struct vma_iterator vmi;
> +	unsigned int numab_mode = READ_ONCE(sysctl_numa_balancing_mode);

const and all the way to the top?

>  	bool vma_pids_skipped;
>  	bool vma_pids_forced = false;
> +	bool promo_only;
>  
>  	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
>  
> @@ -4304,11 +4306,14 @@ static void task_numa_work(struct callback_head *work)
>  			continue;
>  		}
>  
> +		promo_only = !(numab_mode & NUMA_BALANCING_NORMAL);

bool promo_only = !(numab_mode & NUMA_BALANCING_NORMAL);


and in the later patch

if (vma_is_ro_file(vma))
	promo_only = true;

?

But ...

> +
>  		do {
>  			start = max(start, vma->vm_start);
>  			end = ALIGN(start + (pages << PAGE_SHIFT), HPAGE_SIZE);
>  			end = min(end, vma->vm_end);
> -			nr_pte_updates = change_prot_numa(vma, start, end);
> +			nr_pte_updates = change_prot_numa(vma, start, end,
> +							  promo_only);


Stupid question: why can't/shouldn't change_prot_numa() query
sysctl_numa_balancing_mode? Why do we have to query this outside of the function
and forward it?

I mean, change_prot_numa() gets the vma and can query
sysctl_numa_balancing_mode. Why not move that into the function and avoid the
boolean parameter?

We do have a single change_prot_numa() caller in the tree ...

>  
>  			/*
>  			 * Try to scan sysctl_numa_balancing_size worth of
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 30b7c63b0e35..2f9ada1bbcfc 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2784,7 +2784,8 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  			goto unlock;
>  
>  		if (!folio_can_map_prot_numa(pmd_folio(*pmd), vma,
> -					     vma_is_single_threaded_private(vma)))
> +					     vma_is_single_threaded_private(vma),
> +					     cp_flags & MM_CP_PROT_NUMA_PROMO_ONLY))

As raised, maybe just forward cp_flags



-- 
Cheers,

David

