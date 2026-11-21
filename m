Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB156606A6B9
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nF2zaZlQ
Received: by kanga.kvack.org (Postfix)
	id 4579D6B05C1; Fri, 20 Nov 2026 20:09:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42F956B05C2; Fri, 20 Nov 2026 20:09:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D0686B05C3; Fri, 20 Nov 2026 20:09:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0696B6B05C1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:09:43 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 90292802A4
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:42 +0000 (UTC)
X-FDA: 85457343804.02.3D4090E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E971F40003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nF2zaZlQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795223381;
	b=weS6+MfxDlw5oDTqvzhUeHprAGkEhlfoJN6I4uKiuGb1lbjCkXwxzbHDdVNDuv1LVz8B1r
	ZC+9Pg8Kj+ENE2E8qEWOVMzYmFBM+llOSJ9p8UokdA+0PGZs+qDe9JBch8m6StnRLHrjN2
	cV0DXGtd8vts7KYRJk7FVgAeRvPDx4Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795223381;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rki4KZxG50yegnRJAiPv7uPcvwl0wAJojGoYn1fisT4=;
	b=NB7i9xiw0vWXO93FwPqmIBPJROX7rwEGRxMHmAZDxesTHmgmr/H29zBCqRXderS59hIp2L
	vLZW4+coM52iBBrkb0yOEUeL7DmStyoV4x4MXmBCXRnShDnEvBZ75fu2RPojG1pi4bWR0L
	ZcuAzStQaz41y6ktsDEV/Xpj0c8y7YY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nF2zaZlQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2961841237;
	Sat, 21 Nov 2026 01:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815E61F000C6;
	Sat, 21 Nov 2026 01:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795223379;
	bh=rki4KZxG50yegnRJAiPv7uPcvwl0wAJojGoYn1fisT4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nF2zaZlQz8/udnUwGLCqSsJX9ACchjuM1MwHzBi9k+iBp1/cwL9t+u3xcP0uJo7nN
	 PXzdfaQ9MOu9ZBPvdP2NpEXq/AsbJAVxj8tGLDhMvXJC9q7CCBKguoBkfUPrtZjfWn
	 cTT97Z56/TkuZP+i0fzwBnULQsqkxB6AXCDrz4FTfXXWl2P5EjKhCQ6nVXycT5Fw/b
	 QvHEVbkUBolJZI/sDQeZSw6wN8GxYWsN54c6l9zotVeNdq2zaik/SeSeukRPzlhsgF
	 8sYu4xqYmD+sIatGkaLKInksf/rkHRd0Oa31HI/NgSMq8eNFqEv/IbY02P8wcQ8P2Z
	 MDsr/lnhJEsjw==
Message-ID: <sashiko-outbox-226480@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 16/25] mm/slub: Add SLAB_CACHE_PISA_RO for
 PISA-backed slab caches
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luigi Rizzo" <lrizzo@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Joerg Roedel" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin
 Murphy" <robin.murphy@arm.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>, "Jens
 Axboe" <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, "Luigi Rizzo" <rizzo.unipi@gmail.com>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Zi
 Yan" <ziy@nvidia.com>, "Harry Yoo" <harry@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Hao
 Li" <hao.li@linux.dev>, "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Jann
 Horn" <jannh@google.com>, "Catalin Marinas" <catalin.marinas@arm.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Simon
 Horman" <horms@kernel.org>, "Jesper Dangaard Brouer" <hawk@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Willem de Bruijn" <willemb@google.com>, "Kuniyuki
 Iwashima" <kuniyu@google.com>, "Joshua Washington" <joshwash@google.com>, "Harshitha
 Ramamurthy" <hramamurthy@google.com>, "Alexander Lobakin" <aleksander.lobakin@intel.com>, "Christoph
 Hellwig" <hch@lst.de>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Dragos Tatulea" <dtatulea@nvidia.com>, "Naman
 Gulati" <namangulati@google.com>, "Pranjal Shrivastava" <praan@google.com>, "Mostafa
 Saleh" <smostafa@google.com>, "Randy Dunlap" <rdunlap@infradead.org>, linux-mm@kvack.org
In-Reply-To: <20261120010655.467825-17-lrizzo@google.com>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
 <20261120010655.467825-17-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 01:09:37 +0000
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E971F40003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: sgibe4atgiubn8r3385ra85ppiwfnhfr
X-HE-Tag: 1795223380-929908
X-HE-Meta: U2FsdGVkX1+nJN07+v5hRgeV0r5j3N8nQ2Y9fBsnyOdys8IGDnZxgsPmg52V6zVxJon1mcx2/5u/BlI1Q14MZFArMqFXQkAyVBKMI35PyhjMx1NYa0KjogfCaS5ZgMbXbUZVXxPe6ywqbTIXdB0bQUfoMYx2GD3mFbG+wVHZrMwJpLYgoWgTHDQlHYhYf/UrYLHCIMJKI+3QpS9oX7gL6lh+vsVG0bVAOH/sNM/tjedpBStagAKhlpATxAjHads0kxa+2ngWCt1RBGBWeeiNGlwrY6Efqhy1i++F5vrh929OACAjj69DTZOaeUPGO2u1W3Xh46CjeZYUmV0+Y09vo6psmkdO76jmJwm5BFpXqzUrVewrnayVAf0Du1Y9aXWGz9e7f7jqvlCp4In7XXXHJeey6J4n8AlD3sS0CGj3t+IrW5/nDeYKrOeT5hH9i04rSKoOVgdrbFtUlFVqCEVhBW6wasjP4NQgsqcTa6FQInI3RWWZonn5wAgRFv1fLOUI3CwEwR4yPmBDRUzFnUG2NYwMxHVwoxvlPJ9nRKx1fMl60h66gdZCpG71ZJOB69ROCX3U/RR6jJfLwWxdakqo3QkTGnD28UtnyyZTsH5V5lFaO49kdN30ftEcmvUo0X7zfN5jtlPH1Uq3Babf7H1WJRoY8xYGWW+luB7qN3qiYuu7SN1nTvJd3mve8DxqDU6QoE/JkONtTw+WLkW/9im2QPXgWW0VAcQSiPT3Yoaq7L0d1VV9rP9HtQlh108RJFLBZuc8FhA5dhBMcP+CTnwWssaaLvZceCieQ6VVkmlQBnA/MiOHWLiUpal9Oaq5DUH35pW0QNd5r0WCLTJdBLesoE9kz/Tkve+ACCAGijaRDc6eXcRasUHzhkp3HhgJcuIqcGNW61E0CMw81XC3gNV3b4Ivx36C4rcrb1QJLBPlNfx7FDvHhn6nOUCyehOGkU6B6ipgzGojvO+0p6xcVMk
 5GXl8LUn
 Rq4o1bdd3Ue5RWhxrTj9M4rVl0QQ77eM0mvSBfqY+WuwyQ8EFQgo19MBiyf8xlXYYvrv0+vag9cq+nx+uF//3trG+YEQjiryInzLItp1hPgaxp7FOy3MbgSOGv2kqKARjxDGPNejxgblPvB8VQgyN+Ul6jz4EnATwM07e4lLlxKmvK1S0hC6SaCbgSKRKb2KdHHZIhBfnm0Wz6ukw3BfHo//xlI4/zXgWKeZIqVECIQQlYAElP2mf1v2SJxnYxZK2ku/tkGGQVQXVL9OsmwrvwkwQFXugc3IAZUjro41/wjvUK+ljC2Imu3a2hCGtzG7YT4ac4dTAOf5DYGr+KuH2CAgtaGavs3Yp4TfqPdeVgU3P4dg4PCkCY8Of8HFSFFXaSdznEdYvAeBy3OE8ktCql/3xTEk7hxTOoOd+ymeIA4kRBT3c7AyFjnCkCijI50ZQ8nIqQOuTluaQu4fofoo4zakrxQTqZYFlyNFQFn77mTO0bMDdamFF2/WDrJtdyMrg+f9MfQSxT/MtC3E2eEOACur2eUbi89RBjPlyfZKYZr2oAPnB76beo5u/9BtE0HY54O04k+f08aMss24es9g1qfuyJgH3Se8TRbEzp2aRqLo4A0mu6KxXEa9hJKapErg4uYuMvKty12skGIXUYJ+W7rxwpF0gZEdZNnXP0kRlrKRv8EcubbOEELUFU55fIVQVnLVCprhcf+53c9fvdNDrskYxbAm/GvJIIQYlRIs97jDM7KmO2PCa/gbhXrm4EJzSDcwVyUzqdZyIvkexQXzNQkoRb8GMVVn+vPjFKsiDKlr2gAO0YGOPptIf7h0+rNpmh6Gn2JvuZa+LFs3mJeQsxSTsRfkRQ6OJqbJaUvCuGSRwXNbk/UBhTSIIXc9X7mXS/NehgRQCGAIH+Ah6dqFHBxb2E7ssz5YKx8g9PLCw7HHV0k7fVU2rTB71tQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/pisa: __pisa_alloc_folio() pollutes slab_pa on
  __GFP_THISNODE
--

commit 1f383ac0c30c2d9cdbc7439034c54bc1d3d3fce6
Author: Luigi Rizzo <lrizzo@google.com>

mm/slub: Add SLAB_CACHE_PISA_RO for PISA-backed slab caches

This commit introduces the SLAB_CACHE_PISA_RO slab flag to back slab caches
with zeroed, read-only PISA folios via pisa_alloc_folio().

> diff --git a/mm/pisa-alloc.c b/mm/pisa-alloc.c
> index 8c4c0f1f1cf50..4fc3b4d29de67 100644
> --- a/mm/pisa-alloc.c
> +++ b/mm/pisa-alloc.c
[ ... ]
> @@ -710,6 +712,64 @@ unsigned long __pisa_alloc_pages_bulk(gfp_t gfp, uns=
igned int order,
[ ... ]
> +/* Allocate a zeroed read-only PISA folio for SLAB_CACHE_PISA_RO. */
> +struct folio *__pisa_alloc_folio(gfp_t gfp, unsigned int order, int nid)
> +{
> +	int target_nid =3D pisa_sanitize_nid(nid);
> +	struct page *page =3D NULL;
> +	struct pisa_alloc *pa;
> +
> +	if (order > PISA_MAX_ALLOC_ORDER)
> +		return NULL;
> +	/* Pairs with smp_store_release() in pisa_alloc_ensure(). */
> +	pa =3D smp_load_acquire(&pisa_nodes[target_nid].slab_pa[order]);
> +	if (unlikely(!pa)) {
> +		gfp_t ctx =3D current_gfp_context(gfp);
> +
> +		/* Only for a node that got memory after pisa_slab_cache_init(). */
> +		if (!gfpflags_allow_blocking(ctx) ||
> +		    (ctx & (__GFP_FS | __GFP_IO)) !=3D (__GFP_FS | __GFP_IO))
> +			return NULL;
> +		pa =3D pisa_slab_pa_ensure(target_nid, order);
> +	}
> +	pisa_alloc_bulk(pa, gfp & ~__GFP_THISNODE, 1, &page, true);
> +	if (page && (gfp & __GFP_THISNODE) && nid !=3D NUMA_NO_NODE &&
> +	    page_to_nid(page) !=3D nid) {
> +		/* @page is frozen (refcount 0): __free_pages() would underflow it. */
> +		free_frozen_pages(page, order);
> +		return NULL;
> +	}
> +	return page ? page_folio(page) : NULL;
> +}

[Severity: Medium]
Can stripping __GFP_THISNODE here attach a remote-node PISA page to
pisa_nodes[target_nid].slab_pa[order]?

In ___slab_alloc(), SLUB passes GFP_NOWAIT | __GFP_NOWARN | __GFP_THISNODE
on its first try_thisnode pass when node !=3D NUMA_NO_NODE.  When slab_pa
and target_nid's reservoir are empty (or when nid is a memoryless node
redirected by pisa_sanitize_nid()), __pisa_page_alloc() calls
alloc_pages_node(nid, gfp, PISA_ORDER) without __GFP_THISNODE, which can
fall back to a remote node and bind that remote PISA page's pisa_meta to
pisa_nodes[target_nid].slab_pa[order].

When page_to_nid(page) !=3D nid then rejects the block, free_frozen_pages()
routes through pisa_free_page() -> __pisa_free_page() and recycles the
remote block back into pisa_nodes[target_nid].slab_pa[order] rather than
freeing the underlying page.  Later __GFP_THISNODE allocations on that
node will then repeatedly pop blocks from the remote PISA page on slab_pa,
dirty them on free, and return NULL even after local PISA pages become
available in the reservoir.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120010655.4678=
25-1-lrizzo@google.com?part=3D16

