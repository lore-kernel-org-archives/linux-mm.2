Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92FDDF0182E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B3546B0095; Fri,  6 Mar 2026 07:31:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04A336B0096; Fri,  6 Mar 2026 07:31:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EABF76B0098; Fri,  6 Mar 2026 07:31:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAFB16B0095
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:31:24 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A68BF1B80BF
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:31:24 +0000 (UTC)
X-FDA: 84515573688.07.1494800
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id F1F6BC0010
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:31:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LvR/7HPf";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772800283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BTF13s/d85AeKY0BUT+g0GhGGYmCw3CXQ9719Ls0ojY=;
	b=f8m4+XAVzyCtYTkDifDRZBeUWrhb5RcgC1jGiuVznNKm9mfMA9NVCrK95gN6BF4r9tF2G7
	l76xkCi8eGFUKNPpA1Wf0qNmuf9W5qYhbnC7CjUiWYGJvz4603toduC5a5Q7ma7Qojsd5t
	tar50N7nwwbTV7mDVz7bfFY6CfvYte0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772800283; a=rsa-sha256;
	cv=none;
	b=kxZ4LukB0GkBI4OYLRyvLvd39VTJBHYFU3HtkTrxiFPt45vUlAYlT012bwvTSt8VM9Fc/t
	/cUQym6HMCSBFiB9+4fbdI99NJ3fc2CK9CL4dexoil9/36vterxQlU9pRHp9c10Z3BVueM
	MDBLU6ig6DU/ffaw9gp9sHs27iJIvXA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LvR/7HPf";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 45BED60018;
	Fri,  6 Mar 2026 12:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF81C2BC86;
	Fri,  6 Mar 2026 12:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772800282;
	bh=LAJ3eHMG09TcFhgWs2EdIeu79xlpIcUA+/nV0cLjx24=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LvR/7HPf6wcbcyYRLsw0NDSdEUL1xaUkAW3JmG67UyRk8nOpjrEr2b2NGZY1Rm0QK
	 rmjZWXs/kgIZrKXYtCLoe2wOfAeqwFjFcPcvt+uoLGfKG/Qo+cZY/KlECky/nu7yfe
	 VWWd7vd2jX7axW3zB4eXySNQkQ60kLA1VNARXlEtx0PgK1qc1mJkOGYLZPeIU1jkWi
	 k2zaxtrQMGavqzpX3B010TqicSFWti+U38spA0MblbRmX/eAooWrBcs3e2lHItMiNa
	 oY8qJI8Dwm7XxpAxiijBNODF9u6hWMWr4FWbAtfufjRBYMdKm2jnZp6E+SB/W5VYzM
	 3FhaTnLG18eEQ==
Date: Fri, 6 Mar 2026 12:31:18 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, 
	"linux-mm @ kvack . org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Alice Ryhl <aliceryhl@google.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Dimitri Sivanich <dimitri.sivanich@hpe.com>, 
	Arnd Bergmann <arnd@arndb.de>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Eric Dumazet <edumazet@google.com>, 
	Neal Cardwell <ncardwell@google.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
	bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 13/16] mm: rename zap_page_range_single_batched() to
 zap_vma_range_batched()
Message-ID: <c63bd1e9-52b0-42a3-a568-bfb0ac0afd5b@lucifer.local>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-14-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227200848.114019-14-david@kernel.org>
X-Rspam-User: 
X-Stat-Signature: u6fkd7rz4dtgbndnxn9i3cqw4pxyc5k6
X-Rspamd-Queue-Id: F1F6BC0010
X-Rspamd-Server: rspam03
X-HE-Tag: 1772800282-801866
X-HE-Meta: U2FsdGVkX19vi/WuMbVgqi1AmmQ2OiX+iBG3LtulGBv1QuN8aH3MvaAM5h76TWpfzcPS2XwJh05cuxIGC7PdollsNrGNaXPVp7JphWwMic1cAh336UrfU3DlmkVU3BsW9Md1ee4JpqE/6bCFwbQY/HuPKu1WKqHaxFYjXWecaGs4eXN1WtFg1p4mN9QwOsBLIBNkGw4juYM82dFxUlmGxxBUyF2X7/mYILDar2mNuo8Fh+7zmUgpO7Lt+wz/Xp4TyjZQ+6ltKTQsCTs0CaCLeEkto2udPsX2lRhJGpwYNerj+knJsWCUzU89Bas/bwQvhaLrGfsMAHloQj/oE7PTl35DCC+cBbTcN4SO7QJeUz9IKjvkuQRdY8QUZSrKi9Jr8yul38tRAn5yXjgER/Rm/UoGjqpmPZ5WPXTPtA6BOefgu/LI49jkcIufGVUy5XzX1wH1q2pczAvQbH4S4fKJk/DypHiS8aFWIThynoRphoOerEzVFgrZ07z0/l6iqG1MyYVHvZ3Wk2HWoB6lrfgUbn47Y+oDpCf37PZN0l8WHfi1t5AeiSZrYHawAtZgJuTgKL7l0Y5QL69IpNDni1hMYTxJstNa9RQBaRF68dVnlfIPM0R065nGOnvYk147yvZUiGlv+uKS33xFm6n4HFyYSGGEcIWqCO7DDU3YCefb1fys6azDRoxGHyEynTm6JL5HmPl9N9B2RKgIWxZFg6DoESfYz0GDC9Nydy5LkoP21mTR3W8dr5z90thLBnmIERindt0DUqsUbUZJX3asMWXaAhOf70aID35OoEe3hIu9F0RI3K6HmiDqO+L01+3kg5jnxm+cBKgNJwEG1eki3zpGPsmv/gI7Dtr89WqDg2laWSt6n3H7dOgi8o/t6FPegA2c3YsAvvHLVc/6OzJWBWWKomlS/EMF/OU9SahsSN36D8XcO64G5ON4zVKNaC9ycqqAA6H59N8auUVE0bxPU5z
 TBWtap2R
 0L4DCUb2zbdPghfvI7wyGc9i/3wMFLADznOddxuqbu/4anZj4oZ0l0aJtRnIdDPg/sP4KMZKd1cSp/auQHPBzbdT/NvOiKdX+h+6lsLBLddsnTPcwbSKev90ZMsIFmCuCtbIZR1IaYNJu/n0OgCevXB8m3FvGNLQAaAcxG4/4Z/71d7lrT04CQjGPmgoT4c4rLrUzO3X04OpihVvFZgbsvPpttDaPg2DKjJB1NTo5zFwTNe+GCZYpi81y3n4jISAeys8SC7eX5L3rKmPah+a0gO6BLkldCjAh68PL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:08:44PM +0100, David Hildenbrand (Arm) wrote:
> Let's make the naming more consistent with our new naming scheme.
>
> While at it, polish the kerneldoc a bit.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/internal.h |  2 +-
>  mm/madvise.c  |  5 ++---
>  mm/memory.c   | 23 +++++++++++++----------
>  3 files changed, 16 insertions(+), 14 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index df9190f7db0e..15a1b3f0a6d1 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -536,7 +536,7 @@ static inline void sync_with_folio_pmd_zap(struct mm_struct *mm, pmd_t *pmdp)
>  }
>
>  struct zap_details;
> -void zap_page_range_single_batched(struct mmu_gather *tlb,
> +void zap_vma_range_batched(struct mmu_gather *tlb,
>  		struct vm_area_struct *vma, unsigned long addr,
>  		unsigned long size, struct zap_details *details);
>  int zap_vma_for_reaping(struct vm_area_struct *vma);
> diff --git a/mm/madvise.c b/mm/madvise.c
> index b51f216934f3..fb5fcdff2b66 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -855,9 +855,8 @@ static long madvise_dontneed_single_vma(struct madvise_behavior *madv_behavior)
>  		.reclaim_pt = true,
>  	};
>
> -	zap_page_range_single_batched(
> -			madv_behavior->tlb, madv_behavior->vma, range->start,
> -			range->end - range->start, &details);
> +	zap_vma_range_batched(madv_behavior->tlb, madv_behavior->vma,
> +			      range->start, range->end - range->start, &details);
>  	return 0;
>  }
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 1c0bcdfc73b7..e611e9af4e85 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2167,17 +2167,20 @@ void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
>  }
>
>  /**
> - * zap_page_range_single_batched - remove user pages in a given range
> + * zap_vma_range_batched - zap page table entries in a vma range
>   * @tlb: pointer to the caller's struct mmu_gather
> - * @vma: vm_area_struct holding the applicable pages
> - * @address: starting address of pages to remove
> - * @size: number of bytes to remove
> - * @details: details of shared cache invalidation
> + * @vma: the vma covering the range to zap
> + * @address: starting address of the range to zap
> + * @size: number of bytes to zap
> + * @details: details specifying zapping behavior
> + *
> + * @tlb must not be NULL. The provided address range must be fully
> + * contained within @vma. If @vma is for hugetlb, @tlb is flushed and
> + * re-initialized by this function.
>   *
> - * @tlb shouldn't be NULL.  The range must fit into one VMA.  If @vma is for
> - * hugetlb, @tlb is flushed and re-initialized by this function.
> + * If @details is NULL, this function will zap all page table entries.
>   */
> -void zap_page_range_single_batched(struct mmu_gather *tlb,
> +void zap_vma_range_batched(struct mmu_gather *tlb,
>  		struct vm_area_struct *vma, unsigned long address,
>  		unsigned long size, struct zap_details *details)
>  {
> @@ -2225,7 +2228,7 @@ void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
>  	struct mmu_gather tlb;
>
>  	tlb_gather_mmu(&tlb, vma->vm_mm);
> -	zap_page_range_single_batched(&tlb, vma, address, size, NULL);
> +	zap_vma_range_batched(&tlb, vma, address, size, NULL);
>  	tlb_finish_mmu(&tlb);
>  }
>
> @@ -4251,7 +4254,7 @@ static inline void unmap_mapping_range_tree(struct rb_root_cached *root,
>  		size = (end_idx - start_idx) << PAGE_SHIFT;
>
>  		tlb_gather_mmu(&tlb, vma->vm_mm);
> -		zap_page_range_single_batched(&tlb, vma, start, size, details);
> +		zap_vma_range_batched(&tlb, vma, start, size, details);
>  		tlb_finish_mmu(&tlb);
>  	}
>  }
> --
> 2.43.0
>

