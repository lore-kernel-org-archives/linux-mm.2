Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95F7EF01833
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A60606B0005; Fri,  6 Mar 2026 07:21:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3A86B0089; Fri,  6 Mar 2026 07:21:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C5D36B0092; Fri,  6 Mar 2026 07:21:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76BBA6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:21:51 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A03A8B97A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:21:51 +0000 (UTC)
X-FDA: 84515549622.01.BBBD696
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7E33440007
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:21:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h5AYGafZ;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772799709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gvWN8T/GaYPfHf38YasNEjP7sKLaTw3uFCTUGO6dVU4=;
	b=G1UHdhRv/+iBoS9cPhHjuoDaRVD+hQ0N6aPtJ2YiOZ1rQz9GHACokt4BuzdpvFbOrufA38
	llvcuW5KPJjJn1tZj+nHWaimeNq+FR7lPkwpR9BqFXHucO1LYzCQjIWWi9E6DBTXnJp3f9
	aUdRo3PdAM8MHi5TX2kQ30ndOiMb2is=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h5AYGafZ;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772799709; a=rsa-sha256;
	cv=none;
	b=varlC/9t1hLNaMSn0yfW1E5a9pnAqdb3aLJXo/kw+MnRdYBE53iR6CR7CFvr394eVKHdGh
	S+kFpbK8F7IYfojUc4dcqg1xaWLCiKTQvKxY14Q6YLNrja78fJxJFGZra/avDbh7YFK2pL
	yULGIXfkTLh8/6egp4dkTQl2MwbNMjc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C1D5E60018;
	Fri,  6 Mar 2026 12:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2EEC4CEF7;
	Fri,  6 Mar 2026 12:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772799708;
	bh=theG/LCt2/q2eE4jZPVvO5dWH6DfzprovWLt+cDnxxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h5AYGafZBAupVubVI+ZD7t499uAUfoIBiWhpl8owqkPKw6XrDaEVq2gk6V3VMTbJG
	 I4jRzHR0ZgmZkpNFwz4WPgqzlj/ZTXG8Mkg6mu7rnyphpzPSp0u7fh1+VK9oWLl6gi
	 IDaaFcFprJbRbe9bTzXRL2TSF66F78vemrV5U33fTWh+G/lmL2lf9YKdm5HPHC4unn
	 ZD1xuMdPWyTYHNQLOcZ7Z+EV+KFd74oVVcNcMiIFZxDCm23EI+oRIIIQqgBzscf/du
	 1PqvIt+BJZaIL/QfENv95huWxRehRctl1ISCOa4xhZ4a1heXH/LVdrvC2Qdmxny09h
	 GIoNXwDaiAUHQ==
Date: Fri, 6 Mar 2026 12:21:45 +0000
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
Subject: Re: [PATCH v1 09/16] mm/memory: convert details->even_cows into
 details->skip_cows
Message-ID: <091ce280-9204-4b85-bf39-5e2a61e3d0ba@lucifer.local>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-10-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227200848.114019-10-david@kernel.org>
X-Stat-Signature: bgskfhp3seo6uoob3818pogqdgmkueeu
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E33440007
X-HE-Tag: 1772799709-249295
X-HE-Meta: U2FsdGVkX18TaDXO/JNQJQDzI/1tGVgmRALj9QC3bKpliZZeNHMCsUexvMuutZEvFLAc2lHZY8NUF1AaFzQoGPpyM+3J5YpQzoSPXLPzqS3mBkSpxCdlOeynGDFqr6J2UNHtooGawgLX2OGI7krEnoOXlAMT5uyleItir6ia2sS7r8eS1b+Tk2OpLwX/KzJ8E0SoIEDKQsxd2MXmBVS6YNJZBHMMWCXtlMip7vGDrIAYlLvhTIJ14yI5ORPyXua/Jyn402YeNO0Pzt5L5NLCbe8gx1yMjq3QVwB/IIxt3W8xEL9IxWzIPKhCLYBzqsrDnryVYVcGH+gseSaCJYzO1oRZotlMUEsJHx3CQ1KGfkGh5nmqToFVUh1bd54sVTiuRSkqSt1gtG4n1fI0lAUq823bZKf/LhJrMGyznZapsU8JVVAdsNA92wPNnQzJd7s5PU7+/Ia6u2ge5DC0Naakc6cwe5A+Ca9dAzT5cD3hfUVBU3WVjaU67EKpZDLhqpkP6sUERV4laljFkBD2mMrqo+yTnRM6D2AOT9cvicTeugtYvDi2dblgLLxHen2nAzGTAftSphGskVBe1UztBlx9TWJUAdyNUaqfwN09MnUC8QBSeF1Dy53d0hHsCWS8JPdRwZndusLJLLRzAVKKn/mbiiQPJoG5wmfPLAIiYFrQjfiUeTxWq1pVKpeK0TeJMNVx6eFNGEp9euMxyz+uFlQD5k+agjKmobBMmj7lCDIu/iMyLqeCr7EPXTHd18rUMZSygveaXQm3kJRcNHdIsocd2TV/B+Z5uzlG9t4UxmlFl95FBwzFz8EzwywVFcZ9vCxmcjBI0C95KKlFlify7zO5q7QqYbaI6TUu6BBN51WQo2XQozIdqd5stdo9ItOCLgtkeV6Bfx5FCD9gh01hqUorvI3XTqmdc5t4HxsT94giEDGP7jefF3yFFjJzL20J37WXytv7AEytWN80SYEbGLU
 DPAP/exQ
 AxtH5k69OWS2n1AcLvKUlKMAIdLZIP7KCB4oXz4jbqiMlVaLSJIFDNk/X7zxuwUPtA+qFNoQ4VkSlTobKXjZWKlaRsFNE58dTUqiR2DJit+z4gBuf9jeqGGHTkeIXcC0TC6pICa7v51fhr9lAeVzg7E1BgPZ9tBQdTEPj6aT6j66MVzJmqXSOGlC4T+AJLpKcmH1+W+iJ5IhscvmH/+JGfH0N1Q5Bhgm1e5QkfTIwR4UlnoXE+tzivuE8oUNGYwNAY9Mzb33eWqMfRXgYGwAX3Vh4U4EGLx6XL8XLvZkr9dZgIjAS0vFBaI3CPeGCMjtbSZSL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:08:40PM +0100, David Hildenbrand (Arm) wrote:
> The current semantics are confusing: simply because someone specifies an
> empty zap_detail struct suddenly makes should_zap_cows() behave
> differently. The default should be to also zap CoW'ed anonymous pages.
>
> Really only unmap_mapping_pages() and friends want to skip zapping of
> these anon folios.
>
> So let's invert the meaning; turn the confusing "reclaim_pt" check that
> overrides other properties in should_zap_cows() into a safety check.
>
> Note that the only caller that sets reclaim_pt=true is
> madvise_dontneed_single_vma(), which wants to zap any pages.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

This is another nice change. I have some tweak suggestions below, but past
experience suggests to me it's quite possible you do what I ask in subsequent
patches, will see :)

Anyway overall LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  include/linux/mm.h |  2 +-
>  mm/madvise.c       |  1 -
>  mm/memory.c        | 12 ++++++------
>  3 files changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index d3ef586ee1c0..21b67c203e62 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2798,7 +2798,7 @@ extern void pagefault_out_of_memory(void);
>   */
>  struct zap_details {
>  	struct folio *single_folio;	/* Locked folio to be unmapped */
> -	bool even_cows;			/* Zap COWed private pages too? */
> +	bool skip_cows;			/* Do not zap COWed private pages */
>  	bool reclaim_pt;		/* Need reclaim page tables? */
>  	zap_flags_t zap_flags;		/* Extra flags for zapping */
>  };
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 557a360f7919..b51f216934f3 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -853,7 +853,6 @@ static long madvise_dontneed_single_vma(struct madvise_behavior *madv_behavior)
>  	struct madvise_behavior_range *range = &madv_behavior->range;
>  	struct zap_details details = {
>  		.reclaim_pt = true,
> -		.even_cows = true,
>  	};
>
>  	zap_page_range_single_batched(
> diff --git a/mm/memory.c b/mm/memory.c
> index fdcd2abf29c2..7d7c24c6917c 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1554,11 +1554,13 @@ copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
>  static inline bool should_zap_cows(struct zap_details *details)

Not sure if you fix up later, but we should probably change this function to
should_skip_cows() to keep everything consistent, otherwise this is a bit weird
and confusing.

>  {
>  	/* By default, zap all pages */
> -	if (!details || details->reclaim_pt)
> +	if (!details)
>  		return true;
>
> +	VM_WARN_ON_ONCE(details->skip_cows && details->reclaim_pt);
> +
>  	/* Or, we zap COWed pages only if the caller wants to */
> -	return details->even_cows;
> +	return !details->skip_cows;
>  }
>
>  /* Decides whether we should zap this folio with the folio pointer specified */
> @@ -2149,8 +2151,6 @@ void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
>  	struct mmu_notifier_range range;
>  	struct zap_details details = {
>  		.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
> -		/* Careful - we need to zap private pages too! */
> -		.even_cows = true,
>  	};
>
>  	vma = unmap->first;
> @@ -4282,7 +4282,7 @@ void unmap_mapping_folio(struct folio *folio)
>  	first_index = folio->index;
>  	last_index = folio_next_index(folio) - 1;
>
> -	details.even_cows = false;
> +	details.skip_cows = true;
>  	details.single_folio = folio;
>  	details.zap_flags = ZAP_FLAG_DROP_MARKER;
>
> @@ -4312,7 +4312,7 @@ void unmap_mapping_pages(struct address_space *mapping, pgoff_t start,
>  	pgoff_t	first_index = start;
>  	pgoff_t	last_index = start + nr - 1;
>
> -	details.even_cows = even_cows;
> +	details.skip_cows = !even_cows;

Not sure if you clean up later, but seems sensible to cascade the change into
the local boolean here.

>  	if (last_index < first_index)
>  		last_index = ULONG_MAX;
>
> --
> 2.43.0
>

