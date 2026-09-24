Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B36A2C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 21:40:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66BC66B0088; Thu, 24 Sep 2026 17:40:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61C276B008A; Thu, 24 Sep 2026 17:40:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50BA66B008C; Thu, 24 Sep 2026 17:40:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2096C6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:40:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F4EAC0366
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:40:44 +0000 (UTC)
X-FDA: 85249975608.10.5E8034A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id D69191C0003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:40:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FrnIxpwO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790286042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0YAyGdOukJ0qYZkjGuAKlfkUUfncvLOSrgHap0ySDdA=;
	b=IIrKMZqm30elptl+OMIXAnky1ITbhrCvoOCuaIiTFM2mJzmLLe+5q7dS3//USOfPDOz3bm
	gcED4nQt/1jKRq4TgqzXIpDYi4QGfx6diLvXjb0V3KY6+ys0nb0tMoo2MhYoG+ANxopdI8
	ncWYPmcAP6zoYqAKDmR5wtwWLfAXfls=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FrnIxpwO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790286042;
	b=o3O9OrKVi4h0CePROUt8DpgsKBu44uhgBoj61AYRhoXGjBLETQ94Y53nGR2jseKQ1eeHkg
	gX82KWPdN6o0TlXKa5GZZTR7lzCuO1PuigsrOwDpC4F5csfesBQUuMXs5gX+aSaWevFqbK
	uHpxqS9kbUiptFDASv9ZlUjCtaftzTI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CEB8601DE;
	Thu, 24 Sep 2026 21:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C291F000FF;
	Thu, 24 Sep 2026 21:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790286042;
	bh=0YAyGdOukJ0qYZkjGuAKlfkUUfncvLOSrgHap0ySDdA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FrnIxpwOKuSGUoioG2GBn+/QLM8IKz+YSsUUrfyi6alteNwu1uQlQG9g6vFmflRmG
	 7g92FMn2ZIQGZ90hDu9+jMIzR903S0SAt1N6h/CHCaXvJ7oBFCUJ6pNxA9D6E7tfAi
	 qrz4GUpFwpixKFhk1H+uleVEOVbz1nU+q7iUPBgZu7VKRegE7lAYKWPgKLzJBoi0Yz
	 0GGrv3ZHUL5XeHmWUI9IhLj+mF74VgaFZKILr6qcZBPZiWS+PIcl178ZvRuxa1j983
	 WA8lLBoIl7R6HX8ClLq0Vcq5C8+t0TH2Nb2WWJP2q1rJTJqv77ffM3h84wZOYJDdrv
	 177TSnNApOQKA==
Message-ID: <c73021d4-60c8-4446-9c08-f9d7807a3a0f@kernel.org>
Date: Thu, 24 Sep 2026 22:53:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/7] sched/numa: scan read-only file mappings in
 tiering mode
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
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, hannes@cmpxchg.org,
 shy828301@gmail.com, raghavendra.kt@amd.com, stable@vger.kernel.org
References: <20260922182928.2199090-1-gourry@gourry.net>
 <20260922182928.2199090-4-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260922182928.2199090-4-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 95c6hi3gn51uu7tcy619fgnmzh6rds5j
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D69191C0003
X-HE-Tag: 1790286042-542617
X-HE-Meta: U2FsdGVkX1/HYDQ7Xy9aOe6Y3P3PF2mKAzU2C4akUSIjnZDDINF/r4ho8nOKvuzrFgGCq4n4t19vAJmZuSAz8uauOaxYC3YeEiqEc0FOkfY6Qqfiy0XzwT/VUIqBKq5rtqVgTK087e9b4pQ3l2U7K+xRyCiu5s92X4LZsLOqG/dpgalFjFjcX/e/l0Vwt5BEgaLFcrjMMKneXozKw40m94fY6n+WBw8SRZTPCUJofiJoaUJ2cJ295O5vm1rK8/O+4+Qu3JJQhZ+c2gbYbzUJ4pvGyzFpuRdX/ON9DeBM8FiwSZpwwSfepsfwANIo12znb+uobTEZ61KOzmKQOpJCADZArQWmgp4F8M6wr6dZHD9D0CtlRca3nY0RY0t9Ew0lZEkW00z2+wNnxQ2JqzssX6tdOigVEIRg55bgc5ABh0N8eOukDKof8/63sYZz5SOCTBL900QPBu08O2Kyeli4uhUSbrB0zZLrKX3H+iZuU5PgySTpQthOCyJheAb9uwtvoiA6ctlJooPPvNp/vWRgybK04l0iju0w0WdO6OcaK5iCRDeGg2X9278ZMt+448pa0RICKYO1I6xi0qHG95lqQfBL4/W4o+VzVhtps5xLSigQIgv61b+1uWFeZcS1BHDQTKpe2lieEODbuW4eCJBN6tSLZ609iXpEvUwkz8baBhzWOOl/CTiAAxDIXSNFiVBZuD02UyEHU9P85m+zZ1rZtmx5k/Pxsmxlu9oPtrm5OlYhn9TtweCFojq71ta/MIN4/t+WC4+czFdW0ROyEvkAbdrb9SNYZgkJCaRHGgGjROOJHaWaAIBUTfeYyYVEwCTZvxRj1WOUFDIm8tjKWLZWRCZJauM2kdQJFwARxRh3zBVP1MfcxxUUnAwIVVsHxrBrmGJTNzza+jxJ995DUefvov7rgENnK9fpvbaHYTtjBoNWxm7GZLiUuya1koMcGKQA3rXzdS92Iu1UH8o0FAG
 WTvzrb9G
 3Rbpy613dqzayIP0UaHB94w2Cf86HPCzT3P05V+/HAd/3QycIL8Fj0ZTv6Bqq+fCeoGMIRzhJ8oudwNoZw9Rg+d3lVss8nMWHaoUl8mjCvTQRWJGdWHi8iErmw9BYVBpIt+MxFcccYSHNIQOChrL6EG9E2h9rwKh8TxyRyRjwSG9648tYHDtSYeA/VGjspb96FnOXathvYahNSwwkHZQcpSFngBTa/7u/vWefiGd/py5qqIc9LGthtnUTFL0dKAjwe3bM6+Qm/o5tXu6hHQ2qD1U7+XZ9ZhGJWIFmBTrxj0z++w6SAcRh/J+CufFCcbU0ecDvuMFoodheXOdma4ukgTCHK7p1nYTHK5l+GFBLNGqia3gY0tAJ1ogL6/EcnX5j5XLNfAFw9bIB1x5rwzdRtFgwtg+95wJ91PmP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 20:29, Gregory Price wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> Commit 4591ce4f2d22 ("sched/numa: Do not trap hinting faults for
> shared libraries") excludes file-backed read-only VMAs from NUMA
> hint faulting to prevent east-west placement bouncing.
> 
> This filter hides hot file folios on slow memory from promotion.
> 
> Scan those VMAs when tiering is enabled, but make their scans promotion
> only to retains the existing restriction. Keep the historical VMA
> predicate unchanged for backport-ability.
> 
> Read the balancing mode once per task_numa_work() invocation and build
> the protection flags for each VMA from that snapshot. This keeps the PTE
> and PMD paths on the same policy for an entire protection walk (which
> may be split across multiple scanning periods).
> 
> On a host with 768 GB of DRAM and 256 GB of CXL memory running two
> database services using ~430GB each, 169 MB of their shared 185 MB
> main binary accumulated on CXL before permanently stuck there.
> 
> With the change, the binary tier residency tracks its runtime hotness.
> 
> Fixes: c574bbe91703 ("NUMA balancing: optimize page placement for memory tiering system")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  kernel/sched/fair.c | 31 +++++++++++++++++++++----------
>  1 file changed, 21 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index dc78d24ed8bc0..8a4687f67d82f 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4119,21 +4119,21 @@ static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struct *vma)
>   */
>  static void task_numa_work(struct callback_head *work)
>  {
> +	const unsigned int numab_mode = READ_ONCE(sysctl_numa_balancing_mode);
> +	const bool tiering = numab_mode & NUMA_BALANCING_MEMORY_TIERING;
>  	unsigned long migrate, next_scan, now = jiffies;
>  	struct task_struct *p = current;
>  	struct mm_struct *mm = p->mm;
>  	u64 runtime = p->se.sum_exec_runtime;
>  	struct vm_area_struct *vma;
> -	unsigned long cp_flags = MM_CP_PROT_NUMA;
> +	unsigned long cp_flags;
>  	unsigned long start, end;
>  	unsigned long nr_pte_updates = 0;
>  	long pages, virtpages;
>  	struct vma_iterator vmi;
>  	bool vma_pids_skipped;
>  	bool vma_pids_forced = false;
> -
> -	if (!(READ_ONCE(sysctl_numa_balancing_mode) & NUMA_BALANCING_NORMAL))
> -		cp_flags |= MM_CP_PROT_NUMA_PROMO_ONLY;
> +	bool placement_scan;
>  
>  	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
>  
> @@ -4221,13 +4221,19 @@ static void task_numa_work(struct callback_head *work)
>  		}
>  
>  		/*
> -		 * Shared library pages mapped by multiple processes are not
> -		 * migrated as it is expected they are cache replicated. Avoid
> -		 * hinting faults in read-only file-backed mappings or the vDSO
> -		 * as migrating the pages will be of marginal benefit.
> +		 * Shared library pages mapped by multiple processes are limited
> +		 * to south->north migrations as it is expected they are cache
> +		 * replicated. The benefit of east-west migration in this case
> +		 * is at best marginal and may be harmful due to TLB/cache
> +		 * invalidation.
> +		 *
> +		 * Allow promotion as a cold page incurring many cache-misses
> +		 * under cache pressure can drive considerable bandwidth.
>  		 */
> -		if (!vma->vm_mm ||
> -		    (vma->vm_file && (vma->vm_flags & (VM_READ|VM_WRITE)) == (VM_READ))) {
> +		placement_scan = !(vma->vm_file &&
> +			(vma->vm_flags & (VM_READ | VM_WRITE)) == VM_READ);

Indentation looks weird here as well. Maybe it's my mail client.

> +
> +		if (!vma->vm_mm || (!placement_scan && !tiering)) {
>  			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_SHARED_RO);
>  			continue;
>  		}
> @@ -4307,6 +4313,11 @@ static void task_numa_work(struct callback_head *work)
>  			continue;
>  		}
>  
> +		placement_scan &= numab_mode & NUMA_BALANCING_NORMAL;

Do we have to update placement_scan at all?

Can't we do:

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8a4687f67d82f..fc8862ee31442 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4121,6 +4121,7 @@ static void task_numa_work(struct callback_head *work)
 {
        const unsigned int numab_mode = READ_ONCE(sysctl_numa_balancing_mode);
        const bool tiering = numab_mode & NUMA_BALANCING_MEMORY_TIERING;
+       const bool balancing = numab_mode & NUMA_BALANCING_NORMAL;
        unsigned long migrate, next_scan, now = jiffies;
        struct task_struct *p = current;
        struct mm_struct *mm = p->mm;
@@ -4313,9 +4314,8 @@ static void task_numa_work(struct callback_head *work)
                        continue;
                }

-               placement_scan &= numab_mode & NUMA_BALANCING_NORMAL;
                cp_flags = MM_CP_PROT_NUMA;
-               if (!placement_scan)
+               if (!placement_scan || !balancing)
                        cp_flags |= MM_CP_PROT_NUMA_PROMO_ONLY;

                do {

(maybe I messed up my boolean algreba, it's late)

-- 
Cheers,

David

