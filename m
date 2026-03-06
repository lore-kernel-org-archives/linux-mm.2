Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62B93F01830
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73CC6B0005; Fri,  6 Mar 2026 07:07:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1DD76B0089; Fri,  6 Mar 2026 07:07:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B207D6B008C; Fri,  6 Mar 2026 07:07:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A37606B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:07:58 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E03059445
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:07:58 +0000 (UTC)
X-FDA: 84515514636.21.594B4C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B4F241C0008
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:07:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=roeMH8Kf;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772798876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bR8aYhstrfCuuS3764yFUqV6v0ASA2Glapx1jZlr/O8=;
	b=TNFty6SHprFisOlgk31OWnd1Q8aMlApjoTM5v4VDcHqSZ/w0vCosesrZkLe8UMXw0qoAYR
	1fdf5mkoHu3owll2iB1vejRBwNZwwZHBm1cm1hamrlVsneuAFZuNHikHEaZ8XaDKBiAx1y
	feYdZ9jX19J2QYwgPc8/QzmpysVQiqQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772798876; a=rsa-sha256;
	cv=none;
	b=Jph5+XNXpJ7djRNoCGvLjfqA2yqBaNAIRQTJ7LwcmUP6VATbrzvY+HDdaxXGlPVQPJxV0t
	kclj+803JjBurYtY6xqN8/VFx9GpP0hJNz4W8ZKpaHaYVAPatdZ0Bn637XeSJ2vGJw9NFD
	ZRaMDNbYl2ifeoh4ERTnE0a0w4LJnIs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=roeMH8Kf;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2472160127;
	Fri,  6 Mar 2026 12:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3635AC4CEF7;
	Fri,  6 Mar 2026 12:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772798875;
	bh=IJiEATCx3KH7Ih3WoWiyfikf1eOEPdfJ9CNxxKLM5Eg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=roeMH8Kftj8MRsWE1Hp/mVV1SwsBtfCWiiiXCPi7krCUZ4blCgdJGU7GHSUjbZok1
	 b73rFiWJzPYENmWhMs2aF/Ex4R+V0J1o1W+enrxeRzpCIUyx6/yReiQuRarpkX8LG+
	 lLQ62drq0d7kYS1tzFLC8NKIKLnFKQew0+t1HYPjU6XFudRqQeosg1NEfXqsGR+VD3
	 193HJwTkEwoGPyOPSn7wL613KKTFkEp68XT5pmvDSb59G+kLrWQaIBAfxgMjWA5VLL
	 Cy6eEN2sjc6AIdqSynsvJHCNfmRINyoRwDhEZU54uFvMBCB89U3pcRIfzj/49ti+/9
	 2RO128kVNT5lQ==
Date: Fri, 6 Mar 2026 12:07:52 +0000
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
Subject: Re: [PATCH v1 03/16] mm/memory: inline unmap_mapping_range_vma()
 into unmap_mapping_range_tree()
Message-ID: <60b136c3-883c-41fc-ab9a-8ca5977d4456@lucifer.local>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-4-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227200848.114019-4-david@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B4F241C0008
X-Stat-Signature: t8qzy1fb648dwi5pmawmpw76o4prn6tt
X-Rspam-User: 
X-HE-Tag: 1772798876-207803
X-HE-Meta: U2FsdGVkX19dBfCqzjmehTeY/L1q6bt/zFkrUN7SkKN6MtAILwg7bM4svjj0rWVE083HKwnNVi+JUq9jTZE6I4HnMql5OzcsmgzZ3L99S4jbsTeFnvJrUkOto5hcez+4lWY6BXW+gfGTW6yHOPteL4WueZjVFujkUUGxgTIA4hKWQseB+0XmjBxfUKoPf8oGnEiRiwqAJlczMn0ICEnnHmP3kNV5292e0cMGioVNZECWvMRiJscLlmcpPJPI1ye5p4FAFM4N2tF3IBX3NB6DP2yFqFk+cY3ExaHyVRvsZK+8d2Jzd00gp5TX1Bo6qUTfoL/91bWOn9PIb3kt7NJUMt7PiFP3xVPSv/hdTW+BIrh5Qn7rbTFzlvDeaS/olSHvSTf4kbV2Jj4oh04qfh9l/Yzm8r/i88kY6Vu8c1Wba7CBQF5D9Hs93ofB0eOyxhQbszOMuIbHedLf6llqR3NqxKyNFzRH+FjNEOAyXl+vzH8wXE9hbOh+wcsKfmw3JLXfHH/QzTvSeaSA3R/PYfV6ocfpWywCbLzMjYnydVl5lLPsFWNtzMOW8VPjXvg8iChPey7Z7y0zyojoL3qkEvOeoAyIvUtZRg08JJCKJbLfUo/LkmsyBSpEg3Twa7+cTGN/2BfGN9KJMljAmfjA5ZIWMYve0Qincn6/RMOdKR+D9SoDMh0lE9kU1FPgAxQIE95dK1VSJdLe53JkL92NkCqwHVeNyT5/GnFPals/Z9tiwy4wUx7aV7A2CslhK7AJFuwPoXKVzwIScUfAqxe0LXgq5grC+vxmFF3W/3jfyA+yOx/eX/1IpQ+MKTAU7K7Sw+v/NscIdFqYeDo++uBfJXpg1nvy6tqnpVAjNbVdwRo+7NCGrfBqv4cnZ4cgKpbRNYT0c7wFDXFmqDNjFHT63Tzg0ClWhRZHP/dtlwNFp8PRULTSLZsRqWw8BPnggc0WoSsOZVMe0e6lktenRncD4iR
 Dd4Rj/ua
 gZtjmI0Dd1UEWNwZB2G9Sqc7ejktqj9iY8v4KTAGLSKhm1QNhlldJxaz6ZrZ5jZbrwmaov5AK+Yhp4lVx3vjkr46uK8Whz/oMlISedub4aEE/5Az++3x+fL3PdUORvUuiqP08aIT3fpbSEnAFtwOLOcac6dt0HRlJsg69UpZ8629cC2cLz4NOQLuKdea0TgH+BYkSpnJ4GnZf5fWrFwXhVRUVUe9t5SMED/BIojqRnf1K4c5J71YiwIlVfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:08:34PM +0100, David Hildenbrand (Arm) wrote:
> Let's remove the number of unmap-related functions that cause confusion
> by inlining unmap_mapping_range_vma() into its single caller. The end
> result looks pretty readable.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Yeah that's fine, and while I usually like having lots of smaller functions to
break up logic, I always felt when reading it that the zap logic had _too many_
so this is welcome.

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/memory.c | 23 +++++++----------------
>  1 file changed, 7 insertions(+), 16 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 19f5f9a60995..5c47309331f5 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4221,18 +4221,6 @@ static vm_fault_t do_wp_page(struct vm_fault *vmf)
>  	return wp_page_copy(vmf);
>  }
>
> -static void unmap_mapping_range_vma(struct vm_area_struct *vma,
> -		unsigned long start_addr, unsigned long end_addr,
> -		struct zap_details *details)
> -{
> -	struct mmu_gather tlb;
> -
> -	tlb_gather_mmu(&tlb, vma->vm_mm);
> -	zap_page_range_single_batched(&tlb, vma, start_addr,
> -				      end_addr - start_addr, details);
> -	tlb_finish_mmu(&tlb);
> -}
> -
>  static inline void unmap_mapping_range_tree(struct rb_root_cached *root,
>  					    pgoff_t first_index,
>  					    pgoff_t last_index,
> @@ -4240,17 +4228,20 @@ static inline void unmap_mapping_range_tree(struct rb_root_cached *root,
>  {
>  	struct vm_area_struct *vma;
>  	pgoff_t vba, vea, zba, zea;
> +	unsigned long start, size;
> +	struct mmu_gather tlb;
>
>  	vma_interval_tree_foreach(vma, root, first_index, last_index) {
>  		vba = vma->vm_pgoff;
>  		vea = vba + vma_pages(vma) - 1;
>  		zba = max(first_index, vba);
>  		zea = min(last_index, vea);
> +		start = ((zba - vba) << PAGE_SHIFT) + vma->vm_start;
> +		size = (zea - zba + 1) << PAGE_SHIFT;
>
> -		unmap_mapping_range_vma(vma,
> -			((zba - vba) << PAGE_SHIFT) + vma->vm_start,
> -			((zea - vba + 1) << PAGE_SHIFT) + vma->vm_start,
> -				details);
> +		tlb_gather_mmu(&tlb, vma->vm_mm);
> +		zap_page_range_single_batched(&tlb, vma, start, size, details);
> +		tlb_finish_mmu(&tlb);
>  	}
>  }
>
> --
> 2.43.0
>

