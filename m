Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57E38F01830
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A5DA6B0089; Fri,  6 Mar 2026 07:12:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 953A86B008A; Fri,  6 Mar 2026 07:12:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8524C6B008C; Fri,  6 Mar 2026 07:12:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 740346B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:12:48 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3485113B207
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:12:48 +0000 (UTC)
X-FDA: 84515526816.30.A63D757
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7FF6920008
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:12:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=edn61naH;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772799166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FmHWyx9rv+vFIzYL5aWwe4zaNcFlh4tAsVu3dhL4NP4=;
	b=MrhI8OM9nR15b4e51MFFvQ4EaF/LWjEqsullotwruXjMwcuanjfmS1umDigGchMV+YXo61
	ql6KuhW73VGUm7EWP9aqmXbuT7ByjzbLfXOe0CCwJRGlGup7tnoPMmoC6cZBnqXXkepROM
	1tkjDqf86yFhwjYrikKpGfPqqVscGRs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=edn61naH;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772799166; a=rsa-sha256;
	cv=none;
	b=LYxebUhQhySONni7xi1+kEjw9XX3ekFq5XK4oXiMft2aXNubQVGfq88dK6dAtFi5Diysjo
	B6JhgZWnumfp5oT1Q7fiZOqAy930VtT7L4C/N/eJiGwLVHEwhdu1dX2VriX3LZBCshxTs2
	AlniiOepWix0MlgYDhohtA4CuYXc2G0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DDE84074C;
	Fri,  6 Mar 2026 12:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62C0C2BCAF;
	Fri,  6 Mar 2026 12:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772799165;
	bh=0pXAFOIFGu2oV25L8o52sQR97OfC/9uMSwkci4VWiEI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=edn61naHlNfCj6ZsP5AwEUGw9CwfdJ2+qp4E3P9NrRqaex7Mzs8I9+4N3Nb8iPzP+
	 MDPjuNK9A6Qetf2KX0tPdvyQxuXEHgWgnJamhiPEMXHArV5hNb6HubqUE67/ScusgV
	 91Op1mHTejDA5unrODiPadH1XnhaGXoJamDx/1ZP/XFup2VlHpsi86fd3iVR7t4ble
	 +R8KS6ktipoGCS0QCYK2SAjgpa//+C9kqsjUElB2UcpnwNnT+t6UY96TQdEfREXxm8
	 O4hbjLTlhFJ/5gK3fCzWdjUFddgW6o4Vk83yvQglRcCnELrZY+0WRVW3GmusGUbG5S
	 PqwmeKjYrR3zQ==
Date: Fri, 6 Mar 2026 12:12:42 +0000
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
Subject: Re: [PATCH v1 04/16] mm/memory: simplify calculation in
 unmap_mapping_range_tree()
Message-ID: <6c6bf2d6-bc0f-4721-a57d-6b9c5f2a5c66@lucifer.local>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-5-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227200848.114019-5-david@kernel.org>
X-Rspamd-Queue-Id: 7FF6920008
X-Rspamd-Server: rspam07
X-Stat-Signature: hs55uea3gr98o8os81chz1bxd9wre5db
X-Rspam-User: 
X-HE-Tag: 1772799166-704874
X-HE-Meta: U2FsdGVkX1/9xwTh8fHfzAYq0C41BWmDZ8bXqd46TNLLCI2VfDRFb00xm1aVilwOv5iVfQxjDsJU0UWDt8HJZO+QWrfd6c9/UVa4HvrAFZHUjnlEL8Fd5lzqRkCgbc1eFde5MCJhY8+3ZaCoZkqabQhgr6rH0imvvSGcYXr/KUvk6jQH7oztT9uyq/u2L51GwuI5U7hOzasOPlslMag4b4fexz+uAgbOSpFViZAIHUKCBBjNQpKtr6HNq1EehLRJ4h2c9VYwV9tRZdY67ZvWDpUvVz9UP9QIN6C5Qhf2vlU2jYfe+ewpx6/9hFnvGs3Ns8lgPIHqxLUicyJagqx2k6AHAE3hffGjIBasMnbz0Fnga1USJNQlwTx3JUAwRiAdWuCioMzi8THwl1vroZly5dGz2Qc9l9be7ZMY+cDNoYxU+wAiKxnLZVfXpJLIjEDY4i3A+JhNMQD1Ocmp3DDnvTUdVz2UPwkMjrIJmcl2vzXeWCBOnh0eZcJAABcqyXF+BelBIQiKXuCGfdqb7LE7UA+5XliBsyMf44jURmfR92+6P71gVYnNGrwoI+hORbGfSHqM/BalHIBgMmO3eghQMwfJs0Aat5OksAlcmLGyvpIJvgRhKdUdyTd2W5SeKU+64VaIfLRAfvaxcfss3nh4tXIj8lwsAS5MU+mIU75E3bV8P9N84qKUk7m6DyRUksAZEJpDJWZLz09MHhGBDMdO13rDQeh5lat7U6LGsXtqFw1Z9pEDtgcNfn46l8QkGSg22UNqqWZnlO2L2ozkdbqkI2VrVgPNtcj6E/73+pibwPhp098Xdm8D2mSpEjvf85BEatGrMXIw44Fx/AbIwNb99u2nLc1ruVUr8sWE9YewQIjiuENlqDiMMzliGEZ4TVTMiwDFkUtK6voKnEa8BWes1WuYBNLSmXwcOptEiID48w4YYNfGwD0e7Gi8PVMJL8DQAM5BYg1YtYg57g6VAic
 H2MxE5Or
 sJbAL+N6toCH0Wqp8owuiUkrHV/QR4/TzOHRZ9BkeerFldabq8+99SSDUtUfVKm4d80SgYQUQjEam2GlXoA7DLpIDV8v9W1ob1TrjgfPiRVJknsA1FcZML58olR3DRH/Z+yh+ovfwrWedWSZWxlYlHy3L/k3OhPdQJJStq2ht8VsxR5cW1NIRG9I90HCj+I6dtEYBPaf+u8D5zM2Co2ErVxQIQzFTYbCdUptrhV5BMlgY/bmCIg4i+Q0sdin6ulGHCGeKWNPSBdJMSPQzhmQasVTkwpz8osj6ckZ8PucLYFkJ2Ysl+uNI/YIjntTlV6PD8K0o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:08:35PM +0100, David Hildenbrand (Arm) wrote:
> Let's simplify the calculation a bit further to make it easier to get,
> reusing vma_last_pgoff() which we move from interval_tree.c to mm.h.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks, some crusty old code here much improved. LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  include/linux/mm.h |  5 +++++
>  mm/interval_tree.c |  5 -----
>  mm/memory.c        | 12 +++++-------
>  3 files changed, 10 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a8138ff7d1fa..d3ef586ee1c0 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4000,6 +4000,11 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
>  	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
>  }
>
> +static inline unsigned long vma_last_pgoff(struct vm_area_struct *vma)
> +{
> +	return vma->vm_pgoff + vma_pages(vma) - 1;
> +}
> +
>  static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
>  {
>  	return desc->end - desc->start;
> diff --git a/mm/interval_tree.c b/mm/interval_tree.c
> index 32e390c42c53..32bcfbfcf15f 100644
> --- a/mm/interval_tree.c
> +++ b/mm/interval_tree.c
> @@ -15,11 +15,6 @@ static inline unsigned long vma_start_pgoff(struct vm_area_struct *v)
>  	return v->vm_pgoff;
>  }
>
> -static inline unsigned long vma_last_pgoff(struct vm_area_struct *v)
> -{
> -	return v->vm_pgoff + vma_pages(v) - 1;
> -}
> -
>  INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
>  		     unsigned long, shared.rb_subtree_last,
>  		     vma_start_pgoff, vma_last_pgoff, /* empty */, vma_interval_tree)
> diff --git a/mm/memory.c b/mm/memory.c
> index 5c47309331f5..e4154f03feac 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4227,17 +4227,15 @@ static inline void unmap_mapping_range_tree(struct rb_root_cached *root,
>  					    struct zap_details *details)
>  {
>  	struct vm_area_struct *vma;
> -	pgoff_t vba, vea, zba, zea;
>  	unsigned long start, size;
>  	struct mmu_gather tlb;
>
>  	vma_interval_tree_foreach(vma, root, first_index, last_index) {
> -		vba = vma->vm_pgoff;
> -		vea = vba + vma_pages(vma) - 1;
> -		zba = max(first_index, vba);
> -		zea = min(last_index, vea);

These variable names... Lord.

> -		start = ((zba - vba) << PAGE_SHIFT) + vma->vm_start;
> -		size = (zea - zba + 1) << PAGE_SHIFT;
> +		const pgoff_t start_idx = max(first_index, vma->vm_pgoff);
> +		const pgoff_t end_idx = min(last_index, vma_last_pgoff(vma)) + 1;

I guess since 'end' is by-convention the +1 of last this is fine

> +
> +		start = vma->vm_start + ((start_idx - vma->vm_pgoff) << PAGE_SHIFT);
> +		size = (end_idx - start_idx) << PAGE_SHIFT;
>
>  		tlb_gather_mmu(&tlb, vma->vm_mm);
>  		zap_page_range_single_batched(&tlb, vma, start, size, details);
> --
> 2.43.0
>

