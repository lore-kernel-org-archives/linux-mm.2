Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6A61C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 12:19:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8CBB6B007B; Wed,  5 Aug 2026 08:19:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3EA86B0092; Wed,  5 Aug 2026 08:19:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C07AB6B0093; Wed,  5 Aug 2026 08:19:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9686B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:19:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F1EE74047D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:19:56 +0000 (UTC)
X-FDA: 85067122392.28.D3A3532
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3E306100010
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:19:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b9LRIgne;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785932395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oE6PLk6zhamRDU5bmWB+c40IOBnOp6EGpgDAJsyDXVs=;
	b=8UQV3lmT5sZkNora9Px5dM/QOU8ZyKYO3pTXi//XuLW67dIYr3s9ZGTf4szpCexy1lmqQy
	h/viTEZgjRd4d3xY5k7cIF5F1nz+L5WoYXRWAPd7vQZmrfDpZJlZ5YENuMrwDq6uYpcLGd
	CaE0xCO5bU3eEQJW94j0+nXP5RELVAQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b9LRIgne;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785932395;
	b=umm1sRgIa2uh0R28jsnFHaz0gzvQsH08zZR9RsAtFB2riGLLsjFuekyagQBbEJ8aWqNN/1
	cZcTdQ/CfMfX9AGcMKLDNv7VtZo20YgtozGIgMZErTf504cV+RRrEpzW49GJGVphWGLYNa
	MZNPT+GecLQGZSGzP2ee1Bn2HM7rlPI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7561860A87;
	Wed,  5 Aug 2026 12:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD641F00A3A;
	Wed,  5 Aug 2026 12:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785932394;
	bh=oE6PLk6zhamRDU5bmWB+c40IOBnOp6EGpgDAJsyDXVs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b9LRIgnew9rjfCXDGHdWBSbm4sDoGzDwTOncLSU5VTsVzU/OQXY257koPpb3fp++7
	 +B+yWQ+c8azWeAP8SuDqmZS8xhl+K7UdqBJb6LqXnCEelNWm98hByR39CNOxoLOcA7
	 DYd3xgYxQHy7PXT8ycDUxEbf/9D9q7KsKEFyh7gVhFazdad9SakRJLyK7kTLXYotUL
	 aqEH0IRc2Z8cbZZf4DYbyrBbg7TnlXrAuQykitld2ekeBXDXHIW8AmFb989pLJvVvu
	 YhYZPxeKAUmVW8kRnRosz93eYv2hjc6WYklu62QSWmo90FPhjLuPZep4cukFfuGH10
	 hqKbZeY7kvjOg==
Message-ID: <72f017f2-89c5-4e4a-9ce3-ab79f70b04a0@kernel.org>
Date: Wed, 5 Aug 2026 14:19:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/ksm: validate KSM rmap items before hwpoison kill
To: Longlong Xia <xialonglong2025@163.com>, akpm@linux-foundation.org,
 "Lorenzo Stoakes (Arm)" <ljs@kernel.org>
Cc: xu.xin16@zte.com.cn, chengming.zhou@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Longlong Xia <xialonglong@kylinos.cn>
References: <20260803151151.3472893-1-xialonglong2025@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260803151151.3472893-1-xialonglong2025@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 4txd7ek5e3mdddpec8utjjjkacyqwayj
X-Rspamd-Queue-Id: 3E306100010
X-HE-Tag: 1785932395-41304
X-HE-Meta: U2FsdGVkX18eHHiJN07M9kyHIj2Y5U+gl0VgHIMjwHxyhibXVnVKwMqPODgYch4UOzJjAtj+bj50nxNVxF207FGAc5foN/UgHoqqcyzcM75ntPvCg5aVCRdkBmDZxyozCRVpSS92NeEBjjPwC4CAuAYuK0540g1Ejn9NJlkCAzkWF60jgCvIIxhg3hr1v0nm43oV4+NV/ZUsZ6nGy1D4u8h9Hf3rqmibs8p7ZrYaRwzBM7XZKe3JEfHfweS4me515Wd5FhURtsbjKODLGhQ5amgfj5xqveVTGWkj4R6SZFJsKXhOLJ6ORWNzGXhAS1eFToSBx03aw84GvZqzzvBcunAr7of9edR+Jz8SQzJx05YVMG2PxJ8p5D/gaabCI//ik+sIey5e2PcmQgGbVS5Mfzc8Z6TJ7xEpsZYVxDupkkuFVfbo0snW148qDqr0MR8wv0E9WG3UYmRrOLpdxSJDOYmi6yuaAs4Bw03F16xtW9XW6lAioDnNRJVxPqYQ0DUC/nOvrsEY2mKqATf5+ZQfTvFm8q+AWAEYx6XJ7+T0U1rJsq/p4fv/Fo9q2iKNhPQn9wogY/0H49iGvYbbV2+KUFS3u75yaXpGCpL3asA00VW9CFaf82HKLrdoBqlSFO213vmLd+P25iBAn4mWaePzqZEXLyBQqICBlJzpCJD9ZGOgh1z4tq1Falnj/tlEzsuxjfRiHCFO1o3fBLyzCqUUT+914SBtpChasIvH2ZzSbSyYK6k9bO/x01dM+0rIX7PUv8CNft28uqpwTBnFJkAXq8tLzcFTSm3YiuVvoh/OfuGWNkRhfB+qZe0UOxU8wY4QSzr05SEHV5E4EtieYwLlKZbpRnOZyPp9dOpa63JGHJAsePrUjjheT/rz3iT68fpaDPZg22DMnZjJZ4gqpePkVh29GTQYfOsbmlqnnEKiZFAz40q2PwCXb02sD4jJgy/n96YJxvTSA5fuV23HyIf
 sdDbLF04
 Bhk1SQlW8xmErOUiFlhQf7RC9AHflDLdahQjvdnAHT4SLYkvm+FbWJWDOSbEY/SW3C076RHBqP1/K2MOa2Lzb+72F7K0Zs5YfpjYzL01CPDA7iVOJQdVn72CeatshPcE1rbywSRF+gJMHAZidfGPWxYsPw6Z0xKpeur78a1Gm2jPRdopNasdYNhH4d1qYOV3p1g1jHoMvDwmcfdQUPz1GJoOUSgMPXpc7+VVzesvZ6gLoYGLvBLvVMRCkhvSoNoXjXqH5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 17:11, Longlong Xia wrote:
> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> collect_procs_ksm() walks the stable-node rmap list and queues an
> early kill for every task whose mm appears on the anon_vma chain.
> 
> That rmap item can be stale by the time memory failure handles the
> poisoned KSM page.  A VMA may have been split, unmapped or remapped
> after the rmap item was recorded, so matching only vma->vm_mm can send
> SIGBUS with an address that no longer maps the poisoned page.
> 
> Check that the saved address still belongs to the VMA and that
> page_vma_mapped_walk() still finds the poisoned page there before
> adding the task to the kill list.
> 
> Fixes: 4248d0083ec5 ("mm: ksm: support hwpoison for ksm page")
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
> ---
>  mm/ksm.c | 27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 7d5b76478f0b..bc4b2dd894d8 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3222,6 +3222,27 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>  }
>  
>  #ifdef CONFIG_MEMORY_FAILURE
> +static bool ksm_rmap_item_mapped(const struct page *page,
> +				 struct vm_area_struct *vma,
> +				 unsigned long addr)

Two tab indent on second parameter line

	struct vm_area_struct *vma, unsigned long addr)

> +{
> +	struct page_vma_mapped_walk pvmw = {
> +		.pfn = page_to_pfn(page),
> +		.nr_pages = 1,
> +		.vma = vma,
> +		.address = addr,
> +		.flags = PVMW_SYNC,
> +	};
> +
> +	if (addr < vma->vm_start || addr >= vma->vm_end)
> +		return false;
> +	if (!page_vma_mapped_walk(&pvmw))
> +		return false;
> +	page_vma_mapped_walk_done(&pvmw);
> +

We have page_mapped_in_vma(). So I wonder whether we can find a way to

1) Modify to just work with KSM (CCing Lorenzo)

Maybe it already does. I'm confused as so often.

Looking at the existing caller collect_procs_anon(), it's really only called
on anon folios. Could it already be called on KSM folios? What would happen
in that case? (does it just work because folio->index is still what we expect)

2) Do the following

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index d7670ba4147bf..7eeb3c336cfe9 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -342,6 +342,27 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 }
 
 #ifdef CONFIG_MEMORY_FAILURE
+static unsigned long page_mapped_in_vma_at_address(const struct page *page,
+               struct vm_area_struct *vma, unsigned long addr)
+{
+       const struct folio *folio = page_folio(page);
+       struct page_vma_mapped_walk pvmw = {
+               .pfn = page_to_pfn(page),
+               .nr_pages = 1,
+               .vma = vma,
+               .address = addr,
+               .flags = PVMW_SYNC,
+       };
+
+       if (addr < vma->vm_start || addr >= vma->vm_end)
+               return -EFAULT;
+       if (!page_vma_mapped_walk(&pvmw))
+               return -EFAULT;
+       page_vma_mapped_walk_done(&pvmw);
+out:
+       return pvmw.address;
+}
+
 /**
  * page_mapped_in_vma - check whether a page is really mapped in a VMA
  * @page: the page to test
@@ -355,21 +376,10 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 unsigned long page_mapped_in_vma(const struct page *page,
                struct vm_area_struct *vma)
 {
-       const struct folio *folio = page_folio(page);
-       struct page_vma_mapped_walk pvmw = {
-               .pfn = page_to_pfn(page),
-               .nr_pages = 1,
-               .vma = vma,
-               .flags = PVMW_SYNC,
-       };
+       const unsigned long addr = vma_address(vma, page_pgoff(folio, page), 1);
 
-       pvmw.address = vma_address(vma, page_pgoff(folio, page), 1);
-       if (pvmw.address == -EFAULT)
-               goto out;
-       if (!page_vma_mapped_walk(&pvmw))
+       if (addr == -EFAULT)
                return -EFAULT;
-       page_vma_mapped_walk_done(&pvmw);
-out:
-       return pvmw.address;
+       return page_mapped_in_vma_at_address(page, vma, addr);
 }
 #endif


> +	return true;
> +}
> +
>  /*
>   * Collect processes when the error hit an ksm page.
>   */
> @@ -3237,13 +3258,13 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
>  	if (!stable_node)
>  		return;
>  	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
> +		unsigned long addr = rmap_item->address & PAGE_MASK;

Can be const.

>  		struct anon_vma *av = rmap_item->anon_vma;
>  
>  		anon_vma_lock_read(av);
>  		rcu_read_lock();
>  		for_each_process(tsk) {
>  			struct anon_vma_chain *vmac;
> -			unsigned long addr;
>  			struct task_struct *t =
>  				task_early_kill(tsk, force_early);
>  			if (!t)
> @@ -3253,7 +3274,9 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
>  			{
>  				vma = vmac->vma;
>  				if (vma->vm_mm == t->mm) {
> -					addr = rmap_item->address & PAGE_MASK;
> +					if (!ksm_rmap_item_mapped(page, vma,
> +								  addr))

jut put that onto a single line, please: easier to read.

> +						continue;
>  					add_to_kill_ksm(t, page, vma, to_kill,
>  							addr);
>  				}


-- 
Cheers,

David

