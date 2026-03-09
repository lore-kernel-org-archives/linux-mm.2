Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 612CAF41810
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 16:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7314D6B0005; Mon,  9 Mar 2026 12:44:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B5826B0089; Mon,  9 Mar 2026 12:44:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 588DA6B008A; Mon,  9 Mar 2026 12:44:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 488896B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:44:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E2A2B1C1DC
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 16:44:17 +0000 (UTC)
X-FDA: 84527097354.02.DF5538F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 26A1D40011
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 16:44:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N83WeFjH;
	spf=pass (imf07.hostedemail.com: domain of puranjay@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=puranjay@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773074656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NOVoG9KITiNeupSxk9QiIpe2VAcqgB5WuMByhOKIFxc=;
	b=7tasmLlRF0dP+pACz6v/PnC9NkkEYoX8bA3+ctaH/DW1RP4qbwPKvQhHboWTeRFmz+wsOj
	5O3wdQ3es0+EKFS56MV+DcuJcDYfr91IYxd4ICYyY2FXc+4RfkL6n2gk377f27RurcUEBV
	6ef/v1e7uL3bDvzvwpp2iSOqBo+kQL4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N83WeFjH;
	spf=pass (imf07.hostedemail.com: domain of puranjay@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=puranjay@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773074656; a=rsa-sha256;
	cv=none;
	b=XwQGUUC43kI8ILfvYaiF88yRd2YpZLI/8det/xIuK0WzYfz5DqLXe6xdbWWI3wQaDrfn7D
	mvDn64tdnYnG6YoghNY7CUjLQMbdFgrD5qrirS6pPQmD4Oh6OCdI2nfKWrYE3WnKNBJiRi
	JNatk5eN4lDNpDds99jFx4UWhYzzucw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CEE21401C4;
	Mon,  9 Mar 2026 16:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F45C2BC86;
	Mon,  9 Mar 2026 16:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773074654;
	bh=Uk7QgN6xzOCWYu8MBXFyjWy0R+x2ZeLTbcNOpvXhzcE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=N83WeFjHOOqWdbT02p7u6F13MMV7RRau8GbcaBSyL47Q6vraRT6zI0/uD7vTeMN+7
	 jEganNn2JAI3p1bhGbQgVTlIj/PYZ25c4VNozic7qKb9tSU1YYc6xWeetAnJuwud7a
	 pSpMO/wkDQeTMONUSdQx3eHU/4lrDnGQQ3MZbE10I4mXfspZDeSov/kUkNe0L78NCB
	 rLiNZBXTOVj0tOlyFahCjpdld9enU7FrrwsPTSrEy+IBzIG7ccingg6ZVLS4fysV0R
	 cvMYjW5kHwTVCmuY0LVXEcsy6DmN2iZknFT4/P+pQzGtvpHCm6qJ5er7m3qAR6IPTW
	 T4Mx+idBPe/FQ==
From: Puranjay Mohan <puranjay@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-kernel@vger.kernel.org
Cc: "linux-mm @ kvack . org" <linux-mm@kvack.org>, "David Hildenbrand (Arm)"
 <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Alice Ryhl <aliceryhl@google.com>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Christian
 Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Arve =?utf-8?B?SGrDuG5uZXbDpWc=?=
 <arve@android.com>, Todd Kjos
 <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, Carlos Llamas
 <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>, H Hartley Sweeten
 <hsweeten@visionengravers.com>, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi
 <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>, David
 Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Jason
 Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Dimitri
 Sivanich <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Eric Dumazet
 <edumazet@google.com>, Neal Cardwell <ncardwell@google.com>, "David S.
 Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Miguel Ojeda
 <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 02/16] mm/memory: remove "zap_details" parameter from
 zap_page_range_single()
In-Reply-To: <20260227200848.114019-3-david@kernel.org>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-3-david@kernel.org>
Date: Mon, 09 Mar 2026 16:44:10 +0000
Message-ID: <m21phtx89x.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 26A1D40011
X-Rspamd-Server: rspam07
X-Stat-Signature: 9iru6cj6sqzgcxjo656igp7gdbqixbt3
X-Rspam-User: 
X-HE-Tag: 1773074655-140892
X-HE-Meta: U2FsdGVkX18VYHR6P4nltEUej1oLSpeFVp9D+aclkpgz/nR2OJvS3QF096iDyjJ8mAgGIcr4XYPJl65Oq8VDYnHsL1gRTVI6uCCXbJcquZNonTCVQa+1uC6u9hip/LbPHrddiiWQ72OEX2cI6k6RhgPFE8S3s4V4KFOEsUHxBc3nrNQEliGHwKEvWDm9oQI+VqEjgKSQgNc5MDUUhNlG/gsmq1TfF1PPUE9t2sMdilmwIfOFXTndRhwSwqdIjkRcSREnMDbmLTIqfHbZJpCqjzoksR/rUQRluRpm+9lElEev1kujJ+It7ocD4IISRSyLQlCDZEsO/x52vDP04A5MO3OrSx8iyygXqD86sKal7NTUWyi80NRONB19fazzbvXEr/fRzyRilFTK/XPsDaih5U69Phm70qiUYmgstFp2HxvU+6mrW/K39BZAq3a++mdGPrOB/QANoX/lGzEH4eACPpPgVCUExdPmsQNBbPbulcYaEUMdVD8TLy+8UJXq/54C7Uz6IZcgJyPOaqQ+u9/+V21F3oP9cHPMrGHRjQMS9urFGUkqd5cA9lZk3rQD0XIzpWCk5Bx4KKmDs5d5F3ZO9GCz5w2t638QYAgFDGg6g3g6N7a+KQNc3+BUK8LHwOQWZeU/WmsMS5C5v/Nw9/yRJgPpMf1Shkt1i1VOgDG3hF7mAM3b0TAObJSUAq4MaKAqiAzrAuw8eKrBXoNfCLw29JdvCM1QpX8BrJNNVlD/CAdOFFA3Uw4/NJkMN//WwkaDGuah1kBM2FxNVfgSoi7CNrP2F0AyVvJdu/8NoP5zMwAZ2u278UM6NeFUBBtIqQJkZQGNsYoVBj4ammSKBerjUx/TcUkr/vlDJBtRF8yuHleYrUdXBB9o0rMaILRnfOElpOAIIduzqgdB1txvoUIqB2ItOAG3K3TSJ0+aB9LsCxo+7/tDA9ZJlL5g5j8u+ogK74/lVnremZ1z0LSesUz
 /NLX4PEm
 e5sL4quIHzv6gYNuTSnNZLZai8UKNnLc/fx9cGLO/kawJZ3r0/3suLvYQJIswYJvdfZjuGfSbh2rWybHwMIz6A3YmlG/GIm4KjmcnjNx3QXBIZimB86bxld4fFXHQmdm624Eb+gmoVHsxO0G4Jd/2WJiOOpFMTGBp0av6jW4YEPdSek2CT1hQgPOgVqYW0ANcf1MBPDa0yUa7h4khOZ84X0/IoklPipysAnH6ObrOFXB+n6fQ4Ow+/XYdpMfN09wpMopO0I0us7VnWPSN5ZCtOvWFarkCFqmiqgspBVm12MotlRj30TQkVG6Hew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> Nobody except memory.c should really set that parameter to non-NULL. So
> let's just drop it and make unmap_mapping_range_vma() use
> zap_page_range_single_batched() instead.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  arch/s390/mm/gmap_helpers.c    |  2 +-
>  drivers/android/binder_alloc.c |  2 +-
>  include/linux/mm.h             |  5 ++---
>  kernel/bpf/arena.c             |  3 +--
>  kernel/events/core.c           |  2 +-
>  mm/madvise.c                   |  3 +--
>  mm/memory.c                    | 16 ++++++++++------
>  net/ipv4/tcp.c                 |  5 ++---
>  rust/kernel/mm/virt.rs         |  2 +-
>  9 files changed, 20 insertions(+), 20 deletions(-)
>
> diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
> index dea83e3103e5..ae2d59a19313 100644
> --- a/arch/s390/mm/gmap_helpers.c
> +++ b/arch/s390/mm/gmap_helpers.c
> @@ -89,7 +89,7 @@ void gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned lo
>  		if (!vma)
>  			return;
>  		if (!is_vm_hugetlb_page(vma))
> -			zap_page_range_single(vma, vmaddr, min(end, vma->vm_end) - vmaddr, NULL);
> +			zap_page_range_single(vma, vmaddr, min(end, vma->vm_end) - vmaddr);
>  		vmaddr = vma->vm_end;
>  	}
>  }
> diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
> index 241f16a9b63d..dd2046bd5cde 100644
> --- a/drivers/android/binder_alloc.c
> +++ b/drivers/android/binder_alloc.c
> @@ -1185,7 +1185,7 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
>  	if (vma) {
>  		trace_binder_unmap_user_start(alloc, index);
>  
> -		zap_page_range_single(vma, page_addr, PAGE_SIZE, NULL);
> +		zap_page_range_single(vma, page_addr, PAGE_SIZE);
>  
>  		trace_binder_unmap_user_end(alloc, index);
>  	}
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ecff8268089b..a8138ff7d1fa 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2835,11 +2835,10 @@ struct page *vm_normal_page_pud(struct vm_area_struct *vma, unsigned long addr,
>  void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
>  		  unsigned long size);
>  void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
> -			   unsigned long size, struct zap_details *details);
> +			   unsigned long size);
>  static inline void zap_vma_pages(struct vm_area_struct *vma)
>  {
> -	zap_page_range_single(vma, vma->vm_start,
> -			      vma->vm_end - vma->vm_start, NULL);
> +	zap_page_range_single(vma, vma->vm_start, vma->vm_end - vma->vm_start);
>  }
>  struct mmu_notifier_range;
>  
> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> index 144f30e740e8..c34510d83b1f 100644
> --- a/kernel/bpf/arena.c
> +++ b/kernel/bpf/arena.c
> @@ -656,8 +656,7 @@ static void zap_pages(struct bpf_arena *arena, long uaddr, long page_cnt)
>  	guard(mutex)(&arena->lock);
>  	/* iterate link list under lock */
>  	list_for_each_entry(vml, &arena->vma_list, head)
> -		zap_page_range_single(vml->vma, uaddr,
> -				      PAGE_SIZE * page_cnt, NULL);
> +		zap_page_range_single(vml->vma, uaddr, PAGE_SIZE * page_cnt);
>  }

Acked-by: Puranjay Mohan <puranjay@kernel.org>

