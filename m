Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BB12E64012
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 04:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE1FF6B0088; Sun,  5 Apr 2026 00:44:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C93866B0089; Sun,  5 Apr 2026 00:44:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9AB6B008A; Sun,  5 Apr 2026 00:44:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AAEDD6B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 00:44:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 47D9AE1E30
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 04:44:29 +0000 (UTC)
X-FDA: 84623261058.10.D5845DD
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id 831B520003
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 04:44:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GSljTMOT;
	spf=pass (imf03.hostedemail.com: domain of hughd@google.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775364267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xtgGDgjtBD56dVtNB5hQReT+fRX/K7Or/PqyttNi1iU=;
	b=0xMSA03lVlb6QKfhtSDgiUjmMRgvmM+GExtfhivS9kRQGZlVrqEPtaQ0wYdenwPFUL0y9A
	LIhTLb7PwDN2GzG61NmgxcegYKtN6FSPQCoKeSOkIJIYmXtJplv5QWXFsENPSYnmy6bDQt
	hl2qj3wMqf1A7pC1lI+/yWGJWYEv2YY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775364267; a=rsa-sha256;
	cv=none;
	b=mcS30E4DXuSemWMsHQZ2sKQJ0CoSnr4BelTKiEjqWHzOegIer4+aiDgAkj2ZJSLioE9ZR4
	I6QAx69u7jsAn/+Bh/TTKmsLfWyWOCMkPE/cn9uRnmkwo5V+vgXZ2m4Y9uwVPkKAglYsLb
	w/tMpNwKozHdYa7scZvmqbMQ0MNrp4Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GSljTMOT;
	spf=pass (imf03.hostedemail.com: domain of hughd@google.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-408778a8ec4so1865762fac.0
        for <linux-mm@kvack.org>; Sat, 04 Apr 2026 21:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775364266; x=1775969066; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xtgGDgjtBD56dVtNB5hQReT+fRX/K7Or/PqyttNi1iU=;
        b=GSljTMOTzAYydZudUjtfc9LUCursBVCXyKzII0khWR5hc/p2HJfBR0kN4rL59347cM
         qUlC4j99wxJmnKn6Aj4Cyvzt9fyK5LAszejICeEQ6yaowVKyUUPVWXcpLwf3M+67z/Vq
         7eYStief1U7QGWrx2Z+AJ04pBWTjMHvltUijjVwnC8NhIaQNqPIvhPEDyS0bnEa7zIN7
         LC0BJZvbX7M7+VnnbHq0mAe/pIn9h0IC65D+cthq2VIHPrG8kOVhmzA0PTPqhzLyGX3Y
         K5EjFP1X/S9Pl6wBUX4tc5EWUOUNHYMLZO1etirR7Ixn9PHvi7u+qT71IPo58RTMskxP
         UNTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775364266; x=1775969066;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xtgGDgjtBD56dVtNB5hQReT+fRX/K7Or/PqyttNi1iU=;
        b=jlYh9WvU9ouHO6TZpqyACJUNBTwI4hit5o0hrCRsPkJSOBP68F6xteZbjbmmJYssup
         NPM4Y9LeYfDIa+tWhOcuFuJhI9K5On+v8rnys3xduiJTftgOaSFzrYdGC0XQxt9gr25n
         3gUMqvQq68B5KuVLREvQy+v1N1Z0dXjyOScEuRoB5HrPvJJZOfmsBaD9KseO7USkFw5A
         AXoTVSxXFd0UPuJfJWtzT5wA/3+06qebrEnwtGn1ICIV4074RAqFrdlPm0r9xWbY8AWT
         ho7xrbthXDRsUMfSJdWq++681rUYn5tLMMHxJsEZGVTO+hIBpAY1C3urmfzFzoakZ0SR
         hLaQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8mmeFkN9Rx0amvXqqbwzw0tSxMSvGiqZPBD2t28ytj+l+InH2NmXqhtKSYNYir/S1NhHO+PgaTw==@kvack.org
X-Gm-Message-State: AOJu0YwC+4X+3dKtA20G8HCsx7xtgjmv+cAL+4fImnUFUi6slRooA54E
	NJgiT9cwLIevzMf+p3MeMVbglmH1Xb+j4c/WDXzaEK/GbRtnsD0ZrurDVwpqGD+3Nw==
X-Gm-Gg: AeBDiev1+ggw0LQH4/ivllFbAxjdugPK2Kx27SzNPFF7T1zpfhaOMCqJAKVyB0GGDXU
	a9fxN+xyj/bS8/HeltaDUldkkVa81NQLtYTrSTEtM0hcWNXBvAKnuQlXLzunD8WC2FL2RKrW0Xk
	S4e5cXh9FKyrFMZuQfOEkuRm5t2CSvYtXYWjOxurMEVU3hWzxjjxqfZ/GwpvEDgDxmz4l7zko1l
	zQfmZmceXLgRxY79OkhQfD1Na7dHst/5x1QPqXRzUKAUXQELNnznsgFZLcXVskTump+Lo4G2cLV
	3VudQNoVP8sK69uIR5n6hM6S+kIwvVosQ1bXfVvfg62fZPkbxHtf0UnlIRypiXHctn/1ov8/CId
	sEo65ccrUECFuXUNic29LNKmJ62fz2DL0uBpBG9MZfutrmD7PC0fblqnqxfkxjy5GPOyKDFJMGH
	b/rSYc2SUezNhNyxOQ7OCCwPB/jfqfjzdEsbG4u2EEcVj8D18dYBwaLQv4AG0yZ0ZcyDGPLX7pK
	VItk/sPCfg=
X-Received: by 2002:a05:6871:73a8:b0:2e9:93c6:6e4a with SMTP id 586e51a60fabf-4231009bc9dmr4704636fac.38.1775364265922;
        Sat, 04 Apr 2026 21:44:25 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-422eb25acbesm10117208fac.11.2026.04.04.21.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2026 21:44:24 -0700 (PDT)
Date: Sat, 4 Apr 2026 21:44:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: xu.xin16@zte.com.cn
cc: akpm@linux-foundation.org, david@kernel.org, chengming.zhou@linux.dev, 
    hughd@google.com, wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn, 
    Michel Lespinasse <michel@lespinasse.org>, 
    Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
In-Reply-To: <20260212193045556CbzCX8p9gDu73tQ2nvHEI@zte.com.cn>
Message-ID: <02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com>
References: 20260212192820223O_r2NQzSEPG_C56cs-z4l@zte.com.cn <20260212193045556CbzCX8p9gDu73tQ2nvHEI@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 831B520003
X-Stat-Signature: je9if1pgrfgfpdpxof69qqj9m7sb9hi8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775364267-945965
X-HE-Meta: U2FsdGVkX19mftXNMrrq5bW7Iul9UZRQodM/8Sk9nS3+mOrwcdnnPGYj5NCmrbDzxNayDJn7Pc8Y5O8uJS3ZyM7AJlxG5VM31U/eW+RlWO+CHMUem/1a1j71r/eLeeYayDGj/B3dhDpEv736vmCssD9ruES9kpEBFXBvWDkuVYsSCkWtf+j+n3ZFoiSeZMi4srA8tixxIdc+aHLPnCUnJV64G9vzKndA7Xc7NehzOBo98JY1R3b7+L1f6+lGrGGdfIMbDdjvXucjPGJ9Rzv7REke0SyJD9XzLIhH0djc3TBtom2ryG21Q2BOzjnUhRhV5D85iWglOcARlRJqTPBXKqY/97brI7aRSf5vRo8gbu6e5PgEr1RBc430jSic/otQtWpC9LP1GvHESbFdnhzckJCvAce8nnl7xRUHbQQXuWFIalDKv2FX9WGobAzz72ETXEVQiYA5N7b1RM5PF7cKFAqr/lqWgp7kJWPUXXuDuIjEnoTtJLKXAwaSelWk5ZSkyoNq4T81PhsfnelpMjZXbee3/TICtYrrmBf0Xbio/4JrDEEY5aMwtYFpqRJu2Wu4DOEX2WW5ZdE8nsnLcw9vxjLJTCfiD5xwBEcKewf6uJkBabuKobpSu4PPloHLVGkUNnxiBV/gDQkQHs4VgeJAD5FYK/t7aD4gHGILLeFVh6nCX8qAwPskttn6IBe1K9wsyzrQyOOZqclIZyUBJpsho95oq3DuaIC4syZoXJJ8dEs3rboA50PFif90+71VgOEiYY2lNBS4wssDWW7DREu1lisWy1V1oACh0b6F5sOAhj/Zvx+tK8M+QlB7sooXjmNfHcGXUy7WfcewOCoZ56OeZwSyxyLm8+Gw6vUOBN6I91eseVHvZ/eabvUDe0pE2rjx6f1FY5bFg0i7I38ICQCKC6ZobWEjyxepoiuI98F9JAmjj7syak7ynFAnr2wjj+viUpPOhYwmP2id6TqLXq8
 OLARSSwh
 cS7AYz2yHhK9iToZQn7AIwHXh4a+zzpc7sXx9KXjl1PWkDaMofhUX/7wqy77nexCnlwgTY58UzLvzjd5EjvVs3FYIj75+646UJzMdax0aebnftKsIsYrJRzVPSXmq4x8ywWLeRciOMWVVHmx8mUQ8JXz8/pGqSiDYbmocKdtg9TgO4XV8ZpghVpUWi0RGt4ytMReOWjS3K5xNhQWIPUL2bdAq8riTd4jsOybnRcObmnXKKcKItAYRl3qltRt7QJe6bHkyJVR/ngT20HJ4eJhrEe1d3zoyZO4pKiAhWbPWW38TSdMaAhBReXBfZ538pgeCQ8Impke1GEXurFflYTUuWnf2wTM/qRP5DB2x8pYKt/AjbgGuGZNEV7whlvOQn6YVJNFJOBQVbmWFIeqXzYMAjAHclVtAHeOTimpiCUKHF1eUz8U2PhmxGVKSidwnA5V+srp7OTKtzR1rNwRGXLQUFr6M5dpVXmrFHl6QIhA+CicmyjQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Feb 2026, xu.xin16@zte.com.cn wrote:

> From: xu xin <xu.xin16@zte.com.cn>
> 
> Problem
> =======
> When available memory is extremely tight, causing KSM pages to be swapped
> out, or when there is significant memory fragmentation and THP triggers
> memory compaction, the system will invoke the rmap_walk_ksm function to
> perform reverse mapping. However, we observed that this function becomes
> particularly time-consuming when a large number of VMAs (e.g., 20,000)
> share the same anon_vma. Through debug trace analysis, we found that most
> of the latency occurs within anon_vma_interval_tree_foreach, leading to an
> excessively long hold time on the anon_vma lock (even reaching 500ms or
> more), which in turn causes upper-layer applications (waiting for the
> anon_vma lock) to be blocked for extended periods.
> 
> Root Cause
> ==========
> Further investigation revealed that 99.9% of iterations inside the
> anon_vma_interval_tree_foreach loop are skipped due to the first check
> "if (addr < vma->vm_start || addr >= vma->vm_end)), indicating that a large
> number of loop iterations are ineffective. This inefficiency arises because
> the pgoff_start and pgoff_end parameters passed to
> anon_vma_interval_tree_foreach span the entire address space from 0 to
> ULONG_MAX, resulting in very poor loop efficiency.
> 
> Solution
> ========
> In fact, we can significantly improve performance by passing a more precise
> range based on the given addr. Since the original pages merged by KSM
> correspond to anonymous VMAs, the page offset can be calculated as
> pgoff = address >> PAGE_SHIFT. Therefore, we can optimize the call by
> defining:
> 
> 	pgoff = rmap_item->address >> PAGE_SHIFT;
> 
> Performance
> ===========
> In our real embedded Linux environment, the measured metrcis were as
> follows:
> 
> 1) Time_ms: Max time for holding anon_vma lock in a single rmap_walk_ksm.
> 2) Nr_iteration_total: The max times of iterations in a loop of anon_vma_interval_tree_foreach
> 3) Skip_addr_out_of_range: The max times of skipping due to the first check (vma->vm_start
>             and vma->vm_end) in a loop of anon_vma_interval_tree_foreach.
> 4) Skip_mm_mismatch: The max times of skipping due to the second check (rmap_item->mm == vma->vm_mm)
>             in a loop of anon_vma_interval_tree_foreach.
> 
> The result is as follows:
> 
>          Time_ms      Nr_iteration_total    Skip_addr_out_of_range   Skip_mm_mismatch
> Before:  228.65       22169                 22168                    0
> After :   0.396        3                     0                       2
> 
> The referenced reproducer of rmap_walk_ksm can be found at:
> https://lore.kernel.org/all/20260206151424734QIyWL_pA-1QeJPbJlUxsO@zte.com.cn/
> 
> Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
> Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>

This is a very attractive speedup, but I believe it's flawed: in the
special case when a range has been mremap-moved, when its anon folio
indexes and anon_vma pgoff correspond to the original user address,
not to the current user address.

In which case, rmap_walk_ksm() will be unable to find all the PTEs
for that KSM folio, which will consequently be pinned in memory -
unable to be reclaimed, unable to be migrated, unable to be hotremoved,
until it's finally unmapped or KSM disabled.

But it's years since I worked on KSM or on anon_vma, so I may be confused
and my belief wrong.  I have tried to test it, and my testcase did appear
to show 7.0-rc6 successfully swapping out even mremap-moved KSM folios,
but mm.git failing to do so.  However, I say "appear to show" because I
found swapping out any KSM pages harder than I'd been expecting: so have
some doubts about my testing.  Let me give more detail on that at the
bottom of this mail: it's a tangent which had better not distract from
your speedup.

If I'm right that your patch is flawed, what to do?

Perhaps there is, or could be, a cleverer way for KSM to walk the anon_vma
interval tree, which can handle the mremap-moved pgoffs appropriately.
Cc'ing Michel, whose bf181b9f9d8d ("mm anon rmap: replace same_anon_vma
linked list with an interval tree.") specifically chose the 0, ULONG_MAX
which you are replacing.

Cc'ing Lorenzo, who is currently considering replacing anon_vma by
something more like my anonmm, which preceded Andrea's anon_vma in 2.6.7;
but Lorenzo supplementing it with the mremap tracking which defeated me.
This rmap_walk_ksm() might well benefit from his approach.  (I'm not
actually expecting any input from Lorenzo here, or Michel: more FYIs.)

But more realistic in the short term, might be for you to keep your
optimization, but fix the lookup, by keeping a count of PTEs found,
and when that falls short, take a second pass with 0, ULONG_MAX.
Somewhat ugly, certainly imperfect, but good enough for now.

More comment on KSM swapout below...

> ---
>  mm/ksm.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 950e122bcbf4..7b974f333391 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3170,6 +3170,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>  	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
>  		/* Ignore the stable/unstable/sqnr flags */
>  		const unsigned long addr = rmap_item->address & PAGE_MASK;
> +		const pgoff_t pgoff = rmap_item->address >> PAGE_SHIFT;
>  		struct anon_vma *anon_vma = rmap_item->anon_vma;
>  		struct anon_vma_chain *vmac;
>  		struct vm_area_struct *vma;
> @@ -3183,8 +3184,12 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>  			anon_vma_lock_read(anon_vma);
>  		}
> 
> +		/*
> +		 * Currently KSM folios are order-0 normal pages, so pgoff_end
> +		 * should be the same as pgoff_start.
> +		 */
>  		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
> -					       0, ULONG_MAX) {
> +					       pgoff, pgoff) {
> 
>  			cond_resched();
>  			vma = vmac->vma;
> -- 
> 2.25.1

Unrelated to this patch, but when I tried to test KSM swapout (even
without mremap), it first appeared not to be working.  Quite likely
my testcase was too simple and naive, not indicating any problem in
real world usage.  But checking back on much older kernels, I did
find that 5.8 swapped KSM as I was expecting, 5.9 not.

Bisected to commit b518154e59aa ("mm/vmscan: protect the workingset
on anonymous LRU"), the one which changed all those
lru_cache_add_active_or_unevictable()s to
lru_cache_add_inactive_or_unevictable()s.

I rather think that mm/ksm.c should have been updated at that time.
Here's the patch I went on to use in testing the mremap question
(I still had to do more memhogging than 5.8 had needed, but that's
probably just reflective of what that commit was intended to fix).

I'm not saying the below is the right patch (it would probably be
better to replicate the existing flags); but throw it out there
for someone more immersed in KSM to pick up and improve upon.

Hugh

--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1422,7 +1422,7 @@ static int replace_page(struct vm_area_s
 	if (!is_zero_pfn(page_to_pfn(kpage))) {
 		folio_get(kfolio);
 		folio_add_anon_rmap_pte(kfolio, kpage, vma, addr, RMAP_NONE);
-		newpte = mk_pte(kpage, vma->vm_page_prot);
+		newpte = pte_mkold(mk_pte(kpage, vma->vm_page_prot));
 	} else {
 		/*
 		 * Use pte_mkdirty to mark the zero page mapped by KSM, and then
@@ -1514,7 +1514,7 @@ static int try_to_merge_one_page(struct
 			 * stable_tree_insert() will update stable_node.
 			 */
 			folio_set_stable_node(folio, NULL);
-			folio_mark_accessed(folio);
+//			folio_mark_accessed(folio);
 			/*
 			 * Page reclaim just frees a clean folio with no dirty
 			 * ptes: make sure that the ksm page would be swapped.

