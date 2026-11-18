Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3FC9606A331
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MSM6rHAS
Received: by kanga.kvack.org (Postfix)
	id 2D4956B00EF; Wed, 18 Nov 2026 14:00:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27ED26B05B0; Wed, 18 Nov 2026 14:00:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16DA36B05B1; Wed, 18 Nov 2026 14:00:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB0EB6B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:00:22 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C9F684084F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:00:20 +0000 (UTC)
X-FDA: 85449155400.23.D01EBB6
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id 964EA80017
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:00:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MSM6rHAS;
	spf=pass (imf30.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795028418;
	b=qggE3kTCKfP1y9P9jVDoOzAqVCgSeYrutdatpzDmrzsRnDVM3MQm0j1mk1tB6Z2DK5sikR
	uI0UOHKsOnHLC6J2pg9Smv5cpcn07qcBjKDiX+qmzMUQDQDVnlMTRCVi2AiQElbXZ7Bc+u
	A5AC1A5JUT2OZNYv0qIurnWJGcHM1/w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MSM6rHAS;
	spf=pass (imf30.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795028418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Os+tb29jNMnP2oCpww6m9nFCa+COo9vLvWye7mQzAMM=;
	b=ABfyKBaGr3/bDHXd569PN+dEaywkWnTaEBWT0P3I0EBNfNDwQs/Amq2PcCMGNfFLdCyFTM
	Qy4NwTwyMu/Rg5GMg3Gq2uJfevKWaNS7SJ1gA6r6gcoc51dLgjUqLn5k9a8RRhsAUvxQ6L
	24wL5fl7SDAF0nfpvrA4xbWSPleBnXE=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6b85d0d0d52so485558a12.3
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795028417; x=1795633217; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Os+tb29jNMnP2oCpww6m9nFCa+COo9vLvWye7mQzAMM=;
        b=MSM6rHASYxSEMMnf873F1SkDE1tS37jSUOM8LOnOCXeRboIdvupwfLY2G7uXNRwOGf
         5DPAZ+m6eruhN148sYBRuSZaJC0fYelGREP/V3Xec6N6ENrZU7Au43uJr356foJ2XZ3c
         o08v3L51TRmYXxDzj8n1I8SvvuUZdnxd9q0nCtj9/TJ7B0+nHobYrwyTN3BQn1dlviJX
         MC5YQkwMv0KphnTiuhjCBi91x+kj/1nAwcPEri3+8PLMYZL8HhlRUqqlEB3D5XFm1DXB
         ga/62DUuOvwur3XudCR5FsD9YAIYNm4Vh4s3NctxVvN271RRkeFh5iwmEHZU0Dqe4sgT
         YuAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795028417; x=1795633217;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Os+tb29jNMnP2oCpww6m9nFCa+COo9vLvWye7mQzAMM=;
        b=C5qtJCUhHtD167cF3fEO0cDhfn9CzELcgfhQ8ECd7AXmgkGbHe8y45Xi66yJ9Vuh0y
         rIil9uIgx72W+5rWRpgVjaE58C9zKXyAADeoMzmASVUOEEtWoqa1D20vAdtazUzvf3io
         yVtsdW9RcVgGIYbfKsTIY1Zd3jfoZCfUy4hYc/3Y06GXnUZN+a4G3IgWwUNVhLUgs3SR
         f65eEVWZtTiM96hbdRYMTUwe/Gbs1NQNlu06l/vrEeVMFWjPdEyTvl+ekB4tbfPyiAHk
         mHvre9Mh1aOp5KNMyYGmrrE6lB+PM+2EgkdEHM9Ad3GLN0mJ3wYtdZEr2MTAvMcoNE+b
         rHpw==
X-Forwarded-Encrypted: i=1; AL+hErG5PNB3SCQqGoJqTdQVREln3c1RRxFTfghu1az+xF+pWiKYvX4IyholueUkGFTQyAuXlF0gJQuCzQ==@kvack.org
X-Gm-Message-State: APuU4Z+v4iAOCyRFZV+m0io7GMLHZFfKBFfleeWIY4M9nQSLE4GN1Kwm
	k0viE9+hRLgormU19ConULNoiXR0FQ2aSC4bxNFzXu0R8bKVFCR/a00W
X-Gm-Gg: AYBFou1Yunblg7Xnrq74D+hXs6hofWiuyR5wpyKG97vZgS8KQ2SsWavrfwPkIyeL1Gx
	ebV7OcioSEmDXnM7D2Z5aqVSUkbQHP6mS1j7mXJd1LFpjwWVXy+r6iCanzNIpUQ3SxzTFTRTWhO
	ipSzdTGUokLIj0vbKwovD1CHw12lpy+t7LGTjjSOhNXdGoUYatJ+eayA6Mikk+SaDUTrOavdSZG
	IE/fcX/8/d4ahyn7ejk6webG0SVckfUChiRJ0y2uL2JY+AL5xti2csBffdZYvPab7VaZguxFII9
	AH/H88sjowmVip7V0uHXehFbF7rvmwR8BKZIpujnzFNmI3lQ7zC5V4BPiQ4QjNaJgESJ/SEelLp
	YUWVf5dTgtjAnrHL9ugEo7UFJYDOcLcLS62rJunEgW+IfrKt5vbNbqPktHJL+Yl6r0vviAOtbWk
	CTbcaAvOwFZBgMTf8whwa1M2G3+c74dePYzx5C/i1USRfFPkUfj7LLQ6TKpIWMsPitKaqQPQCIH
	vFnIdcpfq5m3f1PqVjU3iGmUw2T3FMTs8camhnQFBm+8nAA6smdqRGzLTwgE9q4RjNCVc59bhtd
	aqUnKETpVvsfmaw=
X-Received: by 2002:a05:6402:4409:b0:6b8:8815:ffcc with SMTP id 4fb4d7f45d1cf-6b88816003amr2894326a12.18.1795028416871;
        Wed, 18 Nov 2026 11:00:16 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b88a1eb813sm1357442a12.26.2026.11.18.11.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 11:00:16 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 18 Nov 2026 20:00:13 +0100
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>,
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
	linux-mm@kvack.org, stable@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v5 01/11] mm/vmalloc: skip cond_resched() in the vmap
 unmap paths when atomic
Message-ID: <av31vR89G64KJHpj@milan>
References: <20261116071325.263682-1-hao.ge@linux.dev>
 <20261116071325.263682-2-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116071325.263682-2-hao.ge@linux.dev>
X-Stat-Signature: wztt9s51u8e8rkg8zwk49ei45fd53e7t
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 964EA80017
X-HE-Tag: 1795028418-93010
X-HE-Meta: U2FsdGVkX1/iwo2JS1ASSnYDqHzgUxMw2PQ8yUnlTtdqvv3g48ZYuog9MxLWKEDs23IXq/yWVAJ87qcmk6fU1+1iqOxelr22fE5okJXFlW0PP2FpZxfLIXj1Py9ALUckfeO4sY6OaUXWn2RHSNDsjo9pPiA+eGt5Wv+fkaoBLbdCaV/BLpeT6JPNxey6/kRWAR3M1YGQLhOGSZ1izENilx/kXBXLziGj9nSpvFQS8Ak37Evi6rXocPAOXKJwDWysb1dI1OIQDYSBPtkNQcT06eM+mIam5PZ8ysSJkN1mWIJpjGdMB2RckkKaUi63WPG971vkqG7rD9rCwLikOSvfM4b1KfKmponZ7EZXcISRt704H6MU2RWxU7blex1j3nZbIELE0WuqbxOxsM5Z+MiMQrLxjTW3eUkBmuNsmsyQpScvBsN5pTsR9g/BQfmlPJTxSMiQeEzV9StCRrSjYLk4HuZxSAA7euQkFi0a4IIYWlCpSFERDZttQ73vV3tXpfdQqkVr8sD5v7j7kve9jRiIG5lK/RHBecaNQybSvyezJuWFX1Of1az76DIFAK+2jNwZ1HM6xBCdoS5zWaLHrJ51eTIxwvUByN7Lq1Y82Mxz8EtHRmra1bqPPyFm/5y2+78XtLV0Beb4UxY5BFVvu5K7sOfa0lMjYtSIF6JBcS6UQZ5hB0jveqfcG/40x/HRhCfgo/VQ4lHGV54FTW/ym/Ykn4swQ2hhMXJL9lG5pDPlNLhPtfkiY01x+/3pquF1lYXz5Ujslsi4pkfQdW59DXuUjmEN6/PpkOxylBwEFbV+t0r0/Mqoo8p9o2CEL5BF67asbSTI9w5P1KWByJglWCI3iX7W0MALwz0J+VEiltQgntXl+WCoTTIUeeHew1MQjw9T5C6TjUtIkzJybR8lwE4wBr7nrXL8+ZX28+z+1H9osRiTO4cSxLpvqr31KCZoaqfTqgEsrOA6lNCIfJpnFot
 Kh4Vrb1s
 44O0kgIi6PXzmQwwuflRwqaKf4JAzgOFX17CleKtnyJKya7XKQ6GIYDgv6aUCCHuAsXaIDCr57ag79736/jYQbfpV8HtoKxzP2TOA7BXpHqsSkMEni3zWlVlwMmyKVGZy2TYcomeqcHjGYSoUkqic6R+EusIy4AtTGR7PPw4RvPbqs2fBA5AFfiHpfBtDniDZRnEYTJ8jLKqBm7iNVyR5zrIV5mJ2PVVRLFgY77dKr2Cxnv2bA3rEWxCLyoQiu5LM8mCagrc3qzpnfWsj+VAUH4sTgS8FOA8rcXCZOvX2p67RWoygi12H2N0z0R1TAV8J3aE8N2VgLbBZWH9vl8yGWKFTBQmBPs7a9QST3bXTfXzqEFX3OquEUF9rFqKjPEWgUgb9/9pFDorstaNW6SeY9Ws4IGmNSDWzUXTYIXn0ISus12zblfUxcQStzcTM/kMZ1yJa4U4g07JK/ovmjJCIlB1+wIqGHCEcsrfF81h+LGuiw8EhYlFwVWRNtC83jxWSXNaiX/3/o4jQq2/M4usremfc/tzC4t4LQw28hbohVI8obavG8JpkC5r/HxSzRp4bFNTSby9eNyaVfZRUTZbD6zO43eKkwpr8bJEE9mGtgdw7MktnQjgqkVfNvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 03:13:15PM +0800, Hao Ge wrote:
> The vmap failure paths can be reached with GFP_ATOMIC or GFP_NOWAIT
> since commit b186a94227b7 ("kmsan: remove hard-coded GFP_KERNEL
> flags") and commit 8da89ba18ed4 ("mm/vmalloc: handle non-blocking
> GFP in __vmalloc_area_node()"), so an undo of a partially installed
> mapping may have to run in atomic context, where the cond_resched()
> in vunmap_pmd_range() cannot schedule.
> 
> Give __vunmap_range_noflush() and kmsan_vunmap_range_noflush() a
> can_resched argument and skip the cond_resched() when it is false.
> The existing callers are on sleepable paths and pass true, so nothing
> changes for them.
> 
> Fixes: 47ebd0310e89 ("mm: kmsan: handle alloc failures in kmsan_vmap_pages_range_noflush()")
> Cc: stable@vger.kernel.org
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/all/sashiko-outbox-178439@kernel.org/
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  include/linux/kmsan.h |  8 ++++++--
>  mm/kmsan/hooks.c      | 14 +++++++++-----
>  mm/vmalloc.c          | 24 ++++++++++++++----------
>  mm/vmalloc.h          |  3 ++-
>  4 files changed, 31 insertions(+), 18 deletions(-)
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
> index a706666db097..69008b085658 100644
> --- a/mm/kmsan/hooks.c
> +++ b/mm/kmsan/hooks.c
> @@ -136,10 +136,13 @@ static unsigned long vmalloc_origin(unsigned long addr)
>  						 KMSAN_META_ORIGIN);
>  }
>  
> -void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end)
> +void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end,
> +				bool can_resched)
>  {
> -	__vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end));
> -	__vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end));
> +	__vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end),
> +			       can_resched);
> +	__vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end),
> +			       can_resched);
>  	flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
>  	flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));
>  }
> @@ -168,8 +171,9 @@ static void kmsan_iounmap_pages(unsigned long start, unsigned long end)
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
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index ccaf158c5b7f..3c0d9e69b886 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -429,7 +429,7 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  }
>  
>  static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
> -			     pgtbl_mod_mask *mask)
> +			     pgtbl_mod_mask *mask, bool can_resched)
>  {
>  	pmd_t *pmd;
>  	unsigned long next;
> @@ -451,12 +451,14 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
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
> @@ -476,12 +478,12 @@ static void vunmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
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
> @@ -496,7 +498,7 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
>  
>  		if (p4d_none_or_clear_bad(p4d))
>  			continue;
> -		vunmap_pud_range(p4d, addr, next, mask);
> +		vunmap_pud_range(p4d, addr, next, mask, can_resched);
>  	} while (p4d++, addr = next, addr != end);
>  }
>  
> @@ -512,7 +514,8 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
>   *
>   * This is an internal function only. Do not use outside mm/.
>   */
> -void __vunmap_range_noflush(unsigned long start, unsigned long end)
> +void __vunmap_range_noflush(unsigned long start, unsigned long end,
> +			    bool can_resched)
>  {
>  	unsigned long next;
>  	pgd_t *pgd;
> @@ -527,7 +530,7 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
>  			mask |= PGTBL_PGD_MODIFIED;
>  		if (pgd_none_or_clear_bad(pgd))
>  			continue;
> -		vunmap_p4d_range(pgd, addr, next, &mask);
> +		vunmap_p4d_range(pgd, addr, next, &mask, can_resched);
>  	} while (pgd++, addr = next, addr != end);
>  
>  	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
> @@ -536,8 +539,9 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
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
> diff --git a/mm/vmalloc.h b/mm/vmalloc.h
> index d8372a4f65c4..4ec114a75f04 100644
> --- a/mm/vmalloc.h
> +++ b/mm/vmalloc.h
> @@ -44,6 +44,7 @@ int __must_check __vmap_pages_range_noflush(unsigned long addr,
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
This looks good to me. I am not sure if passing gfp_mask is better
here since it is only for checking if-allow-blocking.

--
Uladzislau Rezki

