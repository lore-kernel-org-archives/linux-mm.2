Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BB0A606A335
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CUs38TV3
Received: by kanga.kvack.org (Postfix)
	id 10FC16B05B1; Thu, 12 Nov 2026 07:19:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C1826B05C8; Thu, 12 Nov 2026 07:19:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF2D26B05C9; Thu, 12 Nov 2026 07:19:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3C446B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:19:48 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B265C1A0444
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:19:47 +0000 (UTC)
X-FDA: 85426373214.10.F4A6198
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id D0D72120006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:19:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=CUs38TV3;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794485985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nUSryPc8FOxmi8aSaPQaQCxq9NdA1cPGVMbhIcbhZaQ=;
	b=WOz8rCO5DLgMziPQ4N+oPnEk5VMKBslfpcYj5o0NGNK39Boa9F3LBvG2xdsaHM/yOPLuvt
	hNh9iQqTw0FBANVE7fairQ98l1sBup8RdDKWNWccfja2jEtD1joIFtS69wcNmS/slr+Kfw
	1O2sQyz7iwCS586Eds/r3/h+XGz+yDs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794485985;
	b=re9BJrSVPHZwiX2PGimIaugBuA9wfmNVH3KyZ3qjydmBOmi/XtRBvYR9YOUO6hQzoA4nEG
	QtqfdamwaT6EgU3TRnqYsusIsqE8uBSiaueo4J06JtxdsyBRP66FHzWRgha/hhhUi0M+zd
	6YbG3OhzJC9PnbVAEi3D5kKG+aqv8sU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=CUs38TV3;
	spf=pass (imf29.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b596569640so1411569a12.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794485984; x=1795090784; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nUSryPc8FOxmi8aSaPQaQCxq9NdA1cPGVMbhIcbhZaQ=;
        b=CUs38TV3aVMELWE1qvKYK+sgVuAz+i2uLVDr3RrC7HzoCjiZ9A9LlzXeNYG5kpvVYe
         Klh55kl3CKvduSBb6bD/106VdMEHyBQbaUQxDlRhp3ZLQ2qoT5Gck7WDh2lpfax5eRRh
         BmGsjnJD9snT90xLNk0QbvSrErbUif/3lcgAN9pEr64gGepke40LqA7hYbbOW256MBI8
         hEU3c3/Z+KBebie7wlbgsEQIolcLsMfIdYPwK+Mmc0TAnxeNTPZcJgBJR7TVV9zP0/Fd
         MaQwDd2el+I+mW6aHgjr/fRkQezpQBYOQFvUkjwojQjtEasSy38mQ1DrvavUnmt7K26J
         scWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794485984; x=1795090784;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nUSryPc8FOxmi8aSaPQaQCxq9NdA1cPGVMbhIcbhZaQ=;
        b=BnSYGAA4oI424sfjgNnE42NbrFJHzaP7tn1ggTr9BWhruNpjiO/HvWzystILVFYI+6
         byQK69fstMETtGppdeBUeLR/LFEcFFSzpgMB1wFFJly6PRyJTxh3hSGI7DUsnMmQltR5
         aTMhWDjnFeVwdDHQ+fd0hOncqx10lq4zcJ9bru50FitOqk3rO7s1WmrPuDXULE0IdEYk
         D+vdyUkqSFACBLNrQhz/C+2crknK7+8OTY7OXBYFktPET+6o3qiCtyZHeAE9QO3lu5PR
         pJtyMSNP+L0YxYcr6QLk63Q+hssgF6qMlofTpI3UCOBRvpzqxrLrxRBLU7hfKVyu/UCt
         sfwQ==
X-Forwarded-Encrypted: i=1; AL+hErG+QqT0b2/9+va+0QE9tAHIJECvCZzKhzN3BTGYeRGzBifs34K++VRX6ZqQgXtfIJBuf6d3ARdAeg==@kvack.org
X-Gm-Message-State: APuU4Z/KA5sgUArRm9WP05/04sLZQq7nTJLwb04qmP24ZIFSznXpKEvg
	Oe4GT9Mo/+NiEc0VZf7SrLbTk+wBDTUL9MYVQdlIwJJaT3lFYN6FGou3
X-Gm-Gg: AYBFou1ifK4vu68cRJAABiTccquNEtEpknIOLxW/G05GSnzl52DIRxxgwug1NTaBWUj
	3WrIXYC3tDEFh3LpuhUGVvYZnphI++lNYCRaU8hL25RGW5doQJDR6Jzq2nir+bCizNvPcIZ6Sp2
	+I8krkkgH65lh6dYtpGmKzeHs369ybk6mwcLeQEaTdp6QT3zaFr3PL69Y0R4wkq3HvB5lNpc2ja
	2IfonQzUk++NycIMv2LQcdlviZPBpKQvgkh+zN44XfuJLB6GZhJ2Q+47FFGHu5S4QfQ3VXrOexS
	qZ+ShTSh02bNCf6cRJOysY4WYfZVVJgCPAnoHwuemSiWO1L5TTpOcUtYV1FMYJl1y66H3hSwNOm
	QY+5URlgGWui40i5R78qxY8Lg/DMa9jFyd17953VScEkAsT+TSRUTtG326FYxAjRgYMwrRKILyV
	xpVZZs9eKotPHkr74Rps+5IoxeRIxq089BGSCHApkDhiKeK7ow8uKeyphr4p6675jir8xrui1UD
	AiFVPPzYj1l3wLdMFdtMeezZdenbcLpZG3EyuHpzT8sT3KKrXquO2u+4/ZgFFwDdxYT2g==
X-Received: by 2002:a05:6402:54:b0:6b7:834c:ebaf with SMTP id 4fb4d7f45d1cf-6b79e0b5b6fmr1355144a12.12.1794485984373;
        Thu, 12 Nov 2026 04:19:44 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7ada54c88sm329841a12.2.2026.11.12.04.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:19:43 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 12 Nov 2026 13:19:41 +0100
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 7/9] mm/vmalloc: undo partial mappings inside the
 mapping functions
Message-ID: <avWu3YUFQHj3FaPs@milan>
References: <20261110112546.261415-1-hao.ge@linux.dev>
 <20261110112546.261415-8-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110112546.261415-8-hao.ge@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D0D72120006
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 1k7n3cof994fa58yizw6w66wp1k7sin1
X-Rspam-User: 
X-HE-Tag: 1794485985-732915
X-HE-Meta: U2FsdGVkX1+5mb6LqcSPFh+2MmQl/S/B+baLMUaYThBgttdBReZoaZS4xIqBX8CSTofep5U0vumajOvz/P8QbSJIQHYzmr/QvoCdUkzcWIJd0zSBT7IIzL/QSkC9n428tiTj5vgXaww+CK/A3lVfsBZijQfcvJjJD4vuGIY346dpHzntnd0NgXFR9i9KYFhh7TPPgE8Y8keHzP2MIvtMuii1+I6TlCs/3voIUusFLNVJ40Bb1y4SS5QgPZNet3ArffU/FCa0P86kxnFyEt/AB7ed4Cku4qBe7CNKs4COOakqn6opfYepFoNhszGYOwlTrZQNjmIGB7oGXO+1Ddhfl18XYdIK6caOTr/ICm0xT+BBT09dRR+TzzFCSRdpIWB+1G3F7z6HvgW0SSAAQ+es85s+9QkcxCzWps8jNqCdZYGCiWfhuHu8Cy1HJJNiuY8y/iqiubWxiwDD5cfJfio44TtCDwNj5fFMioU5rYwRnKZCv6mKzZNIbmLMWjE1mZ7n5VPKw9c9h2YlDIsk+vrlLdJGq+Mh5nxRpmn/WnPvIQbNTNPyRKYXftfQ2ADgjfETE/85OckQpsPENNekEcUOYA/B6o5a1YfJ1AFaPwJfU+bNTRGfmxltNcKT8ZlJ4d6Kk6beLfz20VwtJUQiTZl3RIz3DNKl0PktVw2TrJVTvXimxPl0QSht/yTaVKixcU14fBHgWCAMDYFG/jMpxDQ8cjmkpw9kO3+jfnP6rQnriRImjwY3MM1eTX9J6cnyLMylDnNHcF8KCYp494eWDbyXotIUPMVQnjWBBl1ZOxo2Cx78u/EcJT7X1XgyBzILg6Z6RXpkuFyalYqtL04QeCSqaw5au5UShhTj3TIUIWfLPOaxBQ4aw810aZ9WZybfU1Y11a0l/+wgnejYxaoiuEVwU/yySafyUBDeJQZUtxdOXz2ifXI9DZ1rIFloRSY7q8KAu8N3WCqBP99QSMjTuz0
 IEl7xcVk
 0sX3RZp+hvqTov80uZd/ebFmgasfPfjKxLgAh5hZZJZb7kgoimLZrwQ8BJqKUoYpQlHUCtWqok8ie+uT6gBByMOmI2x1oAySNlWcSoxFQULp3et1DT2QPR3CozneLa2YUf618UCWjRIVJLh+rmlGoDFqxgGMWOp04jshGaxN0k6//IWe6dfaZ1UINww6qddKGl7ESI/dUAvTnRrmUBhuUOmHJPlRnbjssqX7EgIdQbemIUPU4mAf2uyA0eoyjwb6enVT94mkzZ17GApFv6WglR5pK0QPZgR2Flei9sg4/eFEZcanTkGchIEggoH07e/FX0zlSMHvlWkc+LKRbbZhWRpR/zZ07ynzZOtH68dPDZWe2JVuZCZiXkMLBwB2m6icfNUo3jB0dfQGVV5Zu8536eilPb9KjOGYpFJETBG7MMoMYGO5mhSAdo+Qcbg6Ko95dryBiRzKNwm5kWYjhmNvF+yfxiH/A+1Dq0J59YNsrdTqDTlZ51qNGsMvlOS3yjdyfC0lKcRVC2bnwRXEqBcsdWJDRfxFIoYy/DNW8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 07:25:44PM +0800, Hao Ge wrote:
> The vmap entry points may install some PTEs and then fail, leaving a
> partial mapping behind.
> 
> The callers do not agree on who cleans it up. pcpu_map_pages() and
> kmsan_ioremap_page_range() roll back what they mapped, while
> vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
> __vmalloc_area_node() expect a clean range from the mapping function.
> For them the leftovers stay mapped, and the next attempt to map the
> same range trips the WARN_ON(!pte_none()) in vmap_pages_pte_range().
> A leftover huge pmd is even worse. During the retry, vmap_try_huge_pmd()
> calls pmd_free_pte_page() on it, and the x86 implementation cannot
> tell a leaf entry from a page table and frees the mapped page.
> 
> After discussing with Suren and Ulad, we decided to put the rollback
> into the entry points of the vmap API rather than into every
> low-level helper. __vmap_pages_range_noflush() undoes the whole range
> it was asked to map when it fails, and vmap_page_range() undoes its
> range for the ioremap-style mappings.
> 
> The rollback is __vunmap_range_noflush(), which only clears the PTEs.
> No TLB flush is needed, nothing has touched the mapping yet.
> vmap_pages_range_noflush() also drops the KMSAN metadata of the
> failed mapping.
> 
> The undo walk skips its cond_resched() when the caller's gfp mask
> cannot block. __vmalloc() with GFP_ATOMIC or GFP_NOWAIT can run in
> atomic context, where cond_resched() cannot schedule.
> __vunmap_range_noflush() takes a can_resched argument for that, which
> the sleepable callers pass as true.
> 
> Suggested-by: Uladyslau Rezki <urezki@gmail.com>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  include/linux/kmsan.h |  8 ++++--
>  mm/kmsan/hooks.c      | 18 ++++++++-----
>  mm/kmsan/shadow.c     |  7 ++---
>  mm/vmalloc.c          | 61 +++++++++++++++++++++++++++++++++----------
>  mm/vmalloc.h          |  6 +++--
>  5 files changed, 72 insertions(+), 28 deletions(-)
> 
> diff --git a/include/linux/kmsan.h b/include/linux/kmsan.h
> index 7da9fd506b39..0016c032d1e7 100644
> --- a/include/linux/kmsan.h
> +++ b/include/linux/kmsan.h
> @@ -150,11 +150,14 @@ int __must_check kmsan_vmap_pages_range_noflush(unsigned long start,
>   * kmsan_vunmap_kernel_range_noflush() - Notify KMSAN about a vunmap.
>   * @start: start of vunmapped range.
>   * @end:   end of vunmapped range.
> + * @can_resched: whether the unmap walk may call cond_resched(); pass
> + * false from atomic context.
>   *
>   * KMSAN unmaps the contiguous metadata ranges created by
>   * kmsan_map_kernel_range_noflush().
>   */
> -void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end);
> +void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end,
> +				bool can_resched);
>  
>  /**
>   * kmsan_ioremap_page_range() - Notify KMSAN about a ioremap_page_range() call.
> @@ -355,7 +358,8 @@ static inline int __must_check kmsan_vmap_pages_range_noflush(
>  }
>  
>  static inline void kmsan_vunmap_range_noflush(unsigned long start,
> -					      unsigned long end)
> +					      unsigned long end,
> +					      bool can_resched)
>  {
>  }
>  
> diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
> index 107f66841274..0cd1edaa1120 100644
> --- a/mm/kmsan/hooks.c
> +++ b/mm/kmsan/hooks.c
> @@ -136,13 +136,16 @@ static unsigned long vmalloc_origin(unsigned long addr)
>  						 KMSAN_META_ORIGIN);
>  }
>  
> -void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end)
> +void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end,
> +				bool can_resched)
>  {
>  	if (!kmsan_enabled)
>  		return;
>  
> -	__vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end));
> -	__vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end));
> +	__vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end),
> +			       can_resched);
> +	__vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end),
> +			       can_resched);
>  	flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
>  	flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));
>  }
> @@ -171,8 +174,9 @@ static void kmsan_iounmap_pages(unsigned long start, unsigned long end)
>  		if (origin)
>  			__free_pages(origin, KMSAN_IOREMAP_META_ORDER);
>  	}
> -	__vunmap_range_noflush(shadow_start, shadow_end);
> -	__vunmap_range_noflush(origin_start, origin_end);
> +	/* ioremap metadata mappings are always GFP_KERNEL, so resched is safe. */
> +	__vunmap_range_noflush(shadow_start, shadow_end, true);
> +	__vunmap_range_noflush(origin_start, origin_end, true);
>  	flush_tlb_kernel_range(shadow_start, shadow_end);
>  	flush_tlb_kernel_range(origin_start, origin_end);
>  }
> @@ -207,7 +211,7 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
>  		mapped = __vmap_pages_range_noflush(
>  			vmalloc_shadow(start + off),
>  			vmalloc_shadow(start + off + PAGE_SIZE), prot, &shadow,
> -			PAGE_SHIFT);
> +			PAGE_SHIFT, gfp_mask);
>  		if (mapped) {
>  			err = mapped;
>  			goto ret;
> @@ -217,7 +221,7 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
>  		mapped = __vmap_pages_range_noflush(
>  			vmalloc_origin(start + off),
>  			vmalloc_origin(start + off + PAGE_SIZE), prot, &origin,
> -			PAGE_SHIFT);
> +			PAGE_SHIFT, gfp_mask);
>  		if (mapped) {
>  			err = mapped;
>  			goto ret;
> diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
> index 2166086d3dc3..452760a333e4 100644
> --- a/mm/kmsan/shadow.c
> +++ b/mm/kmsan/shadow.c
> @@ -247,7 +247,7 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
>  	origin_end = vmalloc_meta((void *)end, KMSAN_META_ORIGIN);
>  	kmsan_enter_runtime();
>  	mapped = __vmap_pages_range_noflush(shadow_start, shadow_end, prot,
> -					    s_pages, page_shift);
> +					    s_pages, page_shift, gfp_mask);
>  	kmsan_leave_runtime();
>  	if (mapped) {
>  		err = mapped;
> @@ -255,12 +255,13 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
>  	}
>  	kmsan_enter_runtime();
>  	mapped = __vmap_pages_range_noflush(origin_start, origin_end, prot,
> -					    o_pages, page_shift);
> +					    o_pages, page_shift, gfp_mask);
>  	kmsan_leave_runtime();
>  	if (mapped) {
>  		/* Undo the shadow mapping set up above. */
>  		kmsan_enter_runtime();
> -		__vunmap_range_noflush(shadow_start, shadow_end);
> +		__vunmap_range_noflush(shadow_start, shadow_end,
> +				       gfpflags_allow_blocking(gfp_mask));
>  		kmsan_leave_runtime();
>  		err = mapped;
>  		goto ret;
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 3f98056f8c7e..d1986f68eab4 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -372,8 +372,12 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>  	if (!err)
>  		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>  					       ioremap_max_page_shift);
> -	if (!err)
> +	if (err) {
> +		/* Callers are ioremap and arch setup code, always sleepable. */
> +		__vunmap_range_noflush(addr, end, true);
> +	} else {
>  		flush_cache_vmap(addr, end);
> +	}
>  
>  	return err;
>  }
> @@ -429,7 +433,7 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  }
>  
>  static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
> -			     pgtbl_mod_mask *mask)
> +			     pgtbl_mod_mask *mask, bool can_resched)
>  {
>  	pmd_t *pmd;
>  	unsigned long next;
> @@ -451,12 +455,14 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>  			continue;
>  		vunmap_pte_range(pmd, addr, next, mask);
>  
> -		cond_resched();
> +		/* The undo path may run in atomic context. */
> +		if (can_resched)
> +			cond_resched();
>  	} while (pmd++, addr = next, addr != end);
>  }
>  
>  static void vunmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
> -			     pgtbl_mod_mask *mask)
> +			     pgtbl_mod_mask *mask, bool can_resched)
>  {
>  	pud_t *pud;
>  	unsigned long next;
> @@ -476,12 +482,12 @@ static void vunmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
>  		}
>  		if (pud_none_or_clear_bad(pud))
>  			continue;
> -		vunmap_pmd_range(pud, addr, next, mask);
> +		vunmap_pmd_range(pud, addr, next, mask, can_resched);
>  	} while (pud++, addr = next, addr != end);
>  }
>  
>  static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
> -			     pgtbl_mod_mask *mask)
> +			     pgtbl_mod_mask *mask, bool can_resched)
>  {
>  	p4d_t *p4d;
>  	unsigned long next;
> @@ -496,7 +502,7 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
>  
>  		if (p4d_none_or_clear_bad(p4d))
>  			continue;
> -		vunmap_pud_range(p4d, addr, next, mask);
> +		vunmap_pud_range(p4d, addr, next, mask, can_resched);
>  	} while (p4d++, addr = next, addr != end);
>  }
>  
> @@ -512,7 +518,8 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
>   *
>   * This is an internal function only. Do not use outside mm/.
>   */
> -void __vunmap_range_noflush(unsigned long start, unsigned long end)
> +void __vunmap_range_noflush(unsigned long start, unsigned long end,
> +			    bool can_resched)
>  {
>  	unsigned long next;
>  	pgd_t *pgd;
> @@ -529,7 +536,7 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
>  			mask |= PGTBL_PGD_MODIFIED;
>  		if (pgd_none_or_clear_bad(pgd))
>  			continue;
> -		vunmap_p4d_range(pgd, addr, next, &mask);
> +		vunmap_p4d_range(pgd, addr, next, &mask, can_resched);
>  	} while (pgd++, addr = next, addr != end);
>  
>  	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
> @@ -538,8 +545,9 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
>  
>  void vunmap_range_noflush(unsigned long start, unsigned long end)
>  {
> -	kmsan_vunmap_range_noflush(start, end);
> -	__vunmap_range_noflush(start, end);
> +	/* The unmap paths are sleepable, keep the resched point. */
> +	kmsan_vunmap_range_noflush(start, end, true);
> +	__vunmap_range_noflush(start, end, true);
>  }
>  
>  /**
> @@ -727,18 +735,32 @@ static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
>   * The caller is responsible for calling flush_cache_vmap() after this
>   * function returns successfully and before the addresses are accessed.
>   *
> + * On failure the mapping is torn down before returning, so a retry
> + * sees a clean range. When @gfp_mask cannot block, the teardown
> + * skips cond_resched(), it may run in atomic context.
> + *
>   * This is an internal function only. Do not use outside mm/.
>   */
>  int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> -		pgprot_t prot, struct page **pages, unsigned int page_shift)
> +		pgprot_t prot, struct page **pages, unsigned int page_shift,
> +		gfp_t gfp_mask)
>  {
> +	int err;
> +
>  	if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
>  		return -EINVAL;
>  
>  	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
>  		page_shift = PAGE_SHIFT;
>  
> -	return vmap_pages_range_noflush_walk(addr, end, prot, pages, page_shift);
> +	err = vmap_pages_range_noflush_walk(addr, end, prot, pages, page_shift);
> +
> +	/* Undo the PTEs installed before the failure. */
> +	if (err)
> +		__vunmap_range_noflush(addr, end,
> +				       gfpflags_allow_blocking(gfp_mask));
> +
> +	return err;
>  }
>  
>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> @@ -750,7 +772,18 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>  
>  	if (ret)
>  		return ret;
> -	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
> +
> +	ret = __vmap_pages_range_noflush(addr, end, prot, pages, page_shift,
> +					 gfp_mask);
> +	/*
> +	 * The page tables undo themselves on failure. Tear down the
> +	 * metadata that was fully set up before the mapping failed.
> +	 */
> +	if (ret)
> +		kmsan_vunmap_range_noflush(addr, end,
> +					   gfpflags_allow_blocking(gfp_mask));
> +
> +	return ret;
>  }
>  
>  static int __vmap_pages_range(unsigned long addr, unsigned long end,
> diff --git a/mm/vmalloc.h b/mm/vmalloc.h
> index d8372a4f65c4..9ea28845f713 100644
> --- a/mm/vmalloc.h
> +++ b/mm/vmalloc.h
> @@ -40,10 +40,12 @@ void clear_vm_uninitialized_flag(struct vm_struct *vm);
>  
>  int __must_check __vmap_pages_range_noflush(unsigned long addr,
>  		unsigned long end, pgprot_t prot,
> -		struct page **pages, unsigned int page_shift);
> +		struct page **pages, unsigned int page_shift,
> +		gfp_t gfp_mask);
>  
>  void vunmap_range_noflush(unsigned long start, unsigned long end);
>  
> -void __vunmap_range_noflush(unsigned long start, unsigned long end);
> +void __vunmap_range_noflush(unsigned long start, unsigned long end,
> +			    bool can_resched);
>  
>  #endif /* __MM_VMALLOC_H */
> -- 
> 2.25.1
> 
OK. Waiting for v5.

--
Uladzislau Rezki

