Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E5F1F4180E
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 16:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C9D16B0089; Mon,  9 Mar 2026 12:46:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5813A6B008A; Mon,  9 Mar 2026 12:46:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46C8E6B008C; Mon,  9 Mar 2026 12:46:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 335D26B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:46:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF6BB579F4
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 16:46:16 +0000 (UTC)
X-FDA: 84527102352.30.137D0D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1BA8480017
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 16:46:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LzK0cQVs;
	spf=pass (imf30.hostedemail.com: domain of puranjay@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=puranjay@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773074775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HHpTgBH/1pdlBt7gfG4W877BfmosGBp7vW+6BcH8ozk=;
	b=scKJ++yyK+RoSovx3VFCw5RAZZnBnrQnlPnTekKIks2daXv49uu5ZTvyftbfbldzEojT83
	WF/coSyixKUuRVXXUEvTE5mtNxxmxamKptJlKeaS1sIY4+cnzXU9+FiTuLX3oi+gmR5qFX
	/jIXE9BEWSx1YVve2meqCwj/n44cEh0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LzK0cQVs;
	spf=pass (imf30.hostedemail.com: domain of puranjay@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=puranjay@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773074775; a=rsa-sha256;
	cv=none;
	b=wEFZMU/zePvOpSWns7N+cjLvnaxht3hVDtqOBbrBh619wZ5AtdyOrk7WclAk+unGClTclI
	SfsgIEMjg3o5fq8HSEoZWcXzstNS1Nkg06zY5B4j9blLYI1JL84Qg4JAj1fpaoDFCikyWN
	c/biqoSul1YIzlyalQ25xh9otWB3/2c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 09D5440E3A;
	Mon,  9 Mar 2026 16:46:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49200C2BC86;
	Mon,  9 Mar 2026 16:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773074773;
	bh=Tqx7dK7zOG7rDfy0y5qpLKhV/OEzGrhs5r7m6DAJi38=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=LzK0cQVs8ML2i3sxYVbeGEnQp3w8SiK+QCVVNiljg5JvL/h1NF64fnF/LeKgIGdiK
	 FOGHzG/pM6V0WQ0+b8SQ0t/UMvJOUMcusbuLVmT/L9OqD1faOj86rMgMiOHjdxvqGI
	 yIQ/9OIKCWBpkH4MHWrgENng96n48RfZlIt9izmWjO4cti60m/ZwnFqRYcL5mCDTwP
	 DfuORlXZKGVaEPeUO4naijPeyrfCDna/PZ7pWLYmdFjFehFa05pbi7AVJIw8tnnEyc
	 ZTPJPpl/MNPND8YXYuNEC+NesxXKrtqgA8aH5SvyaoIRcGYq2BHQTMuqf6hml1zBOr
	 7JQtnjx5KlFCw==
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
Subject: Re: [PATCH v1 14/16] mm: rename zap_page_range_single() to
 zap_vma_range()
In-Reply-To: <20260227200848.114019-15-david@kernel.org>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-15-david@kernel.org>
Date: Mon, 09 Mar 2026 16:46:09 +0000
Message-ID: <m2y0k1vtm6.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 1BA8480017
X-Stat-Signature: zz5iypec7swzhmm7ktiadi96c16rkgkz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773074774-559959
X-HE-Meta: U2FsdGVkX1/FnLoSPmdoWDZ48LDRTMcdpzkV5nFeTpWXTShm7E3EEBhsyRvXzPin7UrB4AQltFst+uD11QYB11R1fc3vssctVzJ/G9xjXWXTQ15keyIRFsEyDNV3JyN2idatOgiiI/YflmeaF9NXb6TdoONjWW8OSYp+8WKuSy64pSR4A8X/VxIuleQZvtADh+3hZCX3rFfpnmcm+vazoiGlLm1ZIuNnBN3/xqX+aiv8InuX4/zmuwA1uhLdUxEUI3qLZrx+g5N16vJwQV1hqJemkQuo+b3FIlq+iSPmvXVeylkqVhv2k9fkUPi8VuWQAv3yvnAOww3oUzPcwUMxdM6jJmsFDtNTshBtDVgqmaTSAoDoJFtvqos1dQ4cE/sH1gZT+uilqtphBTdWiTuPQT3sWRWhnLiW841RhBGEVn3msCShLwWYI6AsnMaLm/uWwQe4alCuMA6Wdbpj9pskrk5xIvCaS0FEvMzNtZYTLeXj8khpStz852JuK1b58mjcJQhLsA5/o/sx0CQQwn6EB8ARY8kK3zFfME7QbxIc9V5L3yke+dQ9zJ1oW8ZsiZXNz+5LG9RZdzULpKwDX2jG6/ZcLtfibAFBRB8ZTpN3sadN2Z4RPYDQD9Q/nxSj+T3RtRwKTSYTN2nICzOsd4W75A32YHvkL8jYlhcL6VPATpiDlH9gbPOl+wBn/+wNDJDKVOFMQcBJYzQEF6NmoDG/jaZO21dfPp8Hw7jnd0YeQN4m49nNI5jasjMJEi9Dc2XK4MkMDuLy6O6kqXb9qYkrrF6ijNBfvNgBdXI2YwmLgeJlLmEx4saFW7Ht4sXNWm09Bxeab7+FVjiHReZj71Rtp1MAh6lIwTS2858JzVA1ZL3ohGBgACGYA5YBheILdXX5Yie5S2+kbp4wGcGT97Z/GnWZJi2GGIsmuttZy/K8i+qvevL2eP0/NNQ2M8L9MKeEoeMyKKHWAAMFzE4EXM4
 r6n2G7B6
 4J06uPxv+YQ/Jvv24XhYASFh0/bXY6O9DasIlzzP+Y8Zv6E9wrHgI7qBBH+7ohmDr2YufZ6VAcx8oVw7EbCjB9NBU4RTm1PSE72FCr9I/S/tW2x6NCp3boXtsPogVCoifdwz6+kQdlqPWWhH9HrA7G0zC4g/UUOyrsVtEJTEWmOyiJxyITgveh1DWN0I9eCStA6PQs7CszWdsXwSnOCH8PuV1RY5IBvenCHocFENfeLOXF5G4PLziuz+KCgE0rWgioGJtYFJmGSED6BbXgmtx0BDzkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> Let's rename it to make it better match our new naming scheme.
>
> While at it, polish the kerneldoc.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  arch/s390/mm/gmap_helpers.c          |  2 +-
>  drivers/android/binder/page_range.rs |  4 ++--
>  drivers/android/binder_alloc.c       |  2 +-
>  include/linux/mm.h                   |  4 ++--
>  kernel/bpf/arena.c                   |  2 +-
>  kernel/events/core.c                 |  2 +-
>  mm/madvise.c                         |  4 ++--
>  mm/memory.c                          | 14 +++++++-------
>  net/ipv4/tcp.c                       |  6 +++---
>  rust/kernel/mm/virt.rs               |  4 ++--
>  10 files changed, 22 insertions(+), 22 deletions(-)
>
> diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
> index ae2d59a19313..f8789ffcc05c 100644
> --- a/arch/s390/mm/gmap_helpers.c
> +++ b/arch/s390/mm/gmap_helpers.c
> @@ -89,7 +89,7 @@ void gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned lo
>  		if (!vma)
>  			return;
>  		if (!is_vm_hugetlb_page(vma))
> -			zap_page_range_single(vma, vmaddr, min(end, vma->vm_end) - vmaddr);
> +			zap_vma_range(vma, vmaddr, min(end, vma->vm_end) - vmaddr);
>  		vmaddr = vma->vm_end;
>  	}
>  }
> diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
> index fdd97112ef5c..2fddd4ed8d4c 100644
> --- a/drivers/android/binder/page_range.rs
> +++ b/drivers/android/binder/page_range.rs
> @@ -130,7 +130,7 @@ pub(crate) struct ShrinkablePageRange {
>      pid: Pid,
>      /// The mm for the relevant process.
>      mm: ARef<Mm>,
> -    /// Used to synchronize calls to `vm_insert_page` and `zap_page_range_single`.
> +    /// Used to synchronize calls to `vm_insert_page` and `zap_vma_range`.
>      #[pin]
>      mm_lock: Mutex<()>,
>      /// Spinlock protecting changes to pages.
> @@ -719,7 +719,7 @@ fn drop(self: Pin<&mut Self>) {
>  
>      if let Some(vma) = mmap_read.vma_lookup(vma_addr) {
>          let user_page_addr = vma_addr + (page_index << PAGE_SHIFT);
> -        vma.zap_page_range_single(user_page_addr, PAGE_SIZE);
> +        vma.zap_vma_range(user_page_addr, PAGE_SIZE);
>      }
>  
>      drop(mmap_read);
> diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
> index dd2046bd5cde..e4488ad86a65 100644
> --- a/drivers/android/binder_alloc.c
> +++ b/drivers/android/binder_alloc.c
> @@ -1185,7 +1185,7 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
>  	if (vma) {
>  		trace_binder_unmap_user_start(alloc, index);
>  
> -		zap_page_range_single(vma, page_addr, PAGE_SIZE);
> +		zap_vma_range(vma, page_addr, PAGE_SIZE);
>  
>  		trace_binder_unmap_user_end(alloc, index);
>  	}
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 4bd1500b9630..833bedd3f739 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2835,7 +2835,7 @@ struct page *vm_normal_page_pud(struct vm_area_struct *vma, unsigned long addr,
>  
>  void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
>  		  unsigned long size);
> -void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
> +void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
>  			   unsigned long size);
>  /**
>   * zap_vma - zap all page table entries in a vma
> @@ -2843,7 +2843,7 @@ void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
>   */
>  static inline void zap_vma(struct vm_area_struct *vma)
>  {
> -	zap_page_range_single(vma, vma->vm_start, vma->vm_end - vma->vm_start);
> +	zap_vma_range(vma, vma->vm_start, vma->vm_end - vma->vm_start);
>  }
>  struct mmu_notifier_range;
>  
> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> index c34510d83b1f..37843c6a4764 100644
> --- a/kernel/bpf/arena.c
> +++ b/kernel/bpf/arena.c
> @@ -656,7 +656,7 @@ static void zap_pages(struct bpf_arena *arena, long uaddr, long page_cnt)
>  	guard(mutex)(&arena->lock);
>  	/* iterate link list under lock */
>  	list_for_each_entry(vml, &arena->vma_list, head)
> -		zap_page_range_single(vml->vma, uaddr, PAGE_SIZE * page_cnt);
> +		zap_vma_range(vml->vma, uaddr, PAGE_SIZE * page_cnt);
>  }

Acked-by: Puranjay Mohan <puranjay@kernel.org>

