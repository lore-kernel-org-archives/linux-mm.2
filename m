Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCD76606A330
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rwhelwo5
Received: by kanga.kvack.org (Postfix)
	id 876EC6B05C5; Fri, 20 Nov 2026 20:09:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 829596B05C6; Fri, 20 Nov 2026 20:09:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 717506B05C7; Fri, 20 Nov 2026 20:09:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 441A46B05C5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:09:50 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D20F916028E
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:49 +0000 (UTC)
X-FDA: 85457344098.08.A2ABDE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 44756C0008
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rwhelwo5;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795223388;
	b=iUrAkSBXWD1gUpPUPhb8j+v3Tn9kOVoDfmCNhryfTTl9ZV5sgvU+5eaBueiK7mPRFq2t5H
	4BEGsYgA2XLlG8p9gTZH0xNv92NkcCGa2rXT7+GvuRJ6Y4yjsHpnDuKSKIvhKKTYsapCqK
	V/ALahTBfxal/MMEDD9DqdQLXoexdYM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795223388;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4xbXvQjiv28jWvXO4Vg6i7eBVdh6dE6iUcXF/hgg90=;
	b=nEUj7X5lJc/h5IrOwElACjTBEfCB2PZwFCUsK7agU/u+U9iENO2SpOFB9EdtVvJZJHgnjP
	NnG2TeTtDXl21Do+d/EFRm87cmw0XvDPpMDh0hepFjlgYwBqwrPDyyr841bffjgrR+s6Iq
	zEmMAwboNRPEcl2XzL7DBKsNzuSj6Gg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rwhelwo5;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3ED462058;
	Sat, 21 Nov 2026 01:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B29D1F000C0;
	Sat, 21 Nov 2026 01:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795223387;
	bh=A4xbXvQjiv28jWvXO4Vg6i7eBVdh6dE6iUcXF/hgg90=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Rwhelwo5NE5JSL8OldNqHpOoZTqMv6XYyp7p8yfoeNLt55sREZNjPLf/bymELZHTd
	 P0GYokdChuItC2WkVEMZ+jvrSaU8o7oRATUDgDJNusW6V3P7lS0OZFpDsCNw+dzSEg
	 eCVghnS3Pzwi79Di35dTN3IPT/UqlBiXn1EHwSLZzH4E18s+oDgxP2tDy/SO2SzqAk
	 8UfG76bSbU5ZMC9d8HnTTTQ8ItcP/FyRvuFZvdY/W/nW9xfYdQqv/FXShcNc4kE6I3
	 I8D00x7WNEPOJh+cApbECjc2Iuh3V9WRXYl9vdvud1RLK7TJyqdHhs2DPg6Yo9T99J
	 o++j+63fuS/nw==
Message-ID: <sashiko-outbox-226483@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 19/25] mm, iommu/dma: Support decrypted PISA
 pages
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
In-Reply-To: <20261120010655.467825-20-lrizzo@google.com>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
 <20261120010655.467825-20-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 01:09:44 +0000
X-Rspam-User:
X-Rspamd-Queue-Id: 44756C0008
X-Stat-Signature: xbhc5w7p1ff819c1pkp4w75u4z3dq3zf
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795223388-248746
X-HE-Meta: U2FsdGVkX1/QeqsDFfBNzOah/zpnLqylk7xuyNoeJgLRFxsuop1P7BQO4D3ClAz4KF6dLYqYmlLdOusauiAdtvb02eO8Y5cP95q9UeQJJQXofnhwH7NNj1/jVl3hZ5TBVsOnn0zCcdGXyl6XHEFrtmTQaE/2IWYl7kOzIdC/4GwoYAakcOrq2zJBpqmH830mStxVnLRdyF62bFzDEJaL99vCQfyjUR38VD7e8hNfyQ62RfUbtAMyFdXu1XqY4P1ChPRQp6/s8Rsq5QahBpH1dSeGRV8DJXW4OlG7hrUJpS90iwxF624hTaLlPbjMyZ0qnAkc3TlK7+tNjarO4kTvUTOJHf6k8pcqjY/WQ42CIiDMtpYUMQc8YfdBFTI6j/yjmTccz7ScMrzxJJM/Ljs7YEnio0tAUrTsibCpxEWyHyZMLbFPgim2EOB+lyXBdPTNiQluSefaKkH/aB1Rm+qNsKDlCBMHvK7l9V9/HZe2Zba8kF3cB+EYLqPwvXiUgvtv3o8yZOVqAmgilxW3Sg9GxuQa0IzahanenzOnf1jb0bnUEmFxfWHQ2VgCDrNGUIVZbyc/Y8QKkY6TBCrJNCQI5EJnFBHO2w/Z+wdhRifPXaKNPeEDEy3+4wQXpKjr/WhdQ0nb9fYHumiDDNqkEIY+FLFOf3tlpkSar9ig+ZTZKSgrT6Ob36JIhofEWu+5vwS3a+kBDB89Wit4ZNR16kUYWGwwp4blQyFcDVBuzn42A42euTqQrBL6DAA7Fpf1LUx4bqbmxvA3b3hqjWkG6MF/lqVlXccDzhjaWEU547fks7LceJ427F3XxqaT/tbe2udr4P8Br19nidO+4q2qj5nnweTmxZA+Nc+5JG5bXh+k9E15g33Qr/z+ZK2GBFxBlsuFhJEzEKqshYALpH3rZ1iB27BMxOWhP55nfwuIkHLGihIxnJEPecGS+M89DLb+FvXCa2RqHqxfQCouUMV203O
 wI2aMOGj
 xxr2wvwSCo5v307lP6SPlH/UmSJRiJo47efAyQQvPPdWfCirm0e0oDIpakQYtgpOYUj++ukHTa+bWFz4+Xj8MG5GCwUeDIrcMxg0j0tyDESNYTjcofgpcN0EWnIX4t1V6dnvv0sVialtVQuwA4GKikE4v2tshl6OQIlFHUabANQcSm//JpQv4kcNIesglEMdZe9g5cAPWbOgNZAH/wSWNRi292o1F2rRk23zeQB3aQbuCqE5LcUIjCUjcPc9F6NIX+9mDhAjuNSc//eGEm7/YaXKVvAFJCaCq3FIAOLGBI6s8VZd/2juUgDP9qmFh9T2RVjUHiYqaEQiF4RrZ5uii7Oz1H8M1eBEGpCJy6AoQDeIUs5ZAuHlm2NoS1K42GVEPhv7TuPIIZv+SzCDPvVAVcrel57KtKVX6ZahflCkH9PzEIfT5CNfoakBSx7SaNBUMnswdmGmqG54Ycg888u8Tyx6OrBeGli62Dd7b8mRBwvyRocrbPL5QoIGFYlXvQMuQ89L2KU6eumUfmbDtCr3w1xHz6se/z46AEJGnhvXor1bmjBGHd+OAxY+6rv//NFGVFH+f2xaR/gx6qpzMHwwtbyNZhMr1ta4QJexW/SExnXMCFzxnEG+CprHf75DGLcb2+OHd7kAE4l6mInwKBTt0TnSW2EWekgPYb6SkYpudLUxLiJNq9ASqwLiYDKF8NfTac7gnMG/Rdh9c6sLV6LeZ+Ii11hr+yck1G52bpdGFyKNqrf+JQJ62r9lpMbckqf9LCleAAdRnU/YalH3jHMYWdgfmCDMG5rOuzhqphbLdNv0S+FnJHtyTPuTIhll8dcX8Sg8l83lZiP8uWmc0c4ozf/nwEcaDuhy9dU7XZ/d5Uhtq5pjiTBSiM8nhKuBXWv+EjgyB
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
- [Medium] iommu/dma: iommu_dma_alloc() rejects CoCo allocations before
  PISA hook
--

commit 9188f1b04aac4884c0b7b2222a205db844b8ac89
Author: Luigi Rizzo <lrizzo@google.com>

mm, iommu/dma: Support decrypted PISA pages

This commit adds support for decrypting and re-encrypting 2MB PISA pages in
Confidential Computing (CoCo) guests so that DMA mappings can bypass
swiotlb bouncing and user mappings use decrypted PTE protections.

> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index 45e9432d2a020..5e4d9803645b4 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c

[ ... ]

> @@ -1780,6 +1781,9 @@ int iommu_dma_mmap(struct device *dev, struct vm_ar=
ea_struct *vma,
>  		pfn =3D vmalloc_to_pfn(cpu_addr);
>  	} else {
>  		pfn =3D page_to_pfn(virt_to_page(cpu_addr));
> +		/* A decrypted PISA page (CoCo guest) needs a decrypted user mapping t=
oo. */
> +		vma->vm_page_prot =3D pisa_pgprot_decrypted(virt_to_page(cpu_addr),
> +							  vma->vm_page_prot);
>  	}
> =20
>  	return remap_pfn_range(vma, vma->vm_start, pfn + off,

[Severity: Medium]
Can iommu_dma_alloc() ever allocate a decrypted PISA page in a CoCo guest?

When force_dma_unencrypted(dev) is true, dma_alloc_attrs() sets
__DMA_ATTR_ALLOC_CC_SHARED in attrs before calling iommu_dma_alloc(), and
__pisa_alloc_map_coherent() accepts that attribute.  However,
iommu_dma_alloc() still bails out on is_alloc_cc_shared before calling
pisa_alloc_map_coherent():

drivers/iommu/dma-iommu.c:iommu_dma_alloc() {
	...
	/* Not yet supported */
	if (is_alloc_cc_shared)
		return NULL;

	gfp |=3D __GFP_ZERO;

	cpu_addr =3D pisa_alloc_map_coherent(dev, size, handle, gfp, attrs);
	if (cpu_addr)
		return cpu_addr;
	...
}

As a result, coherent allocations for IOMMU-backed devices in CoCo guests
always fail with NULL before reaching PISA, and this new
pisa_pgprot_decrypted() path in iommu_dma_mmap() is unreachable for them.
Moving the pisa_alloc_map_coherent() call ahead of the is_alloc_cc_shared
check would allow PISA to serve those allocations.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120010655.4678=
25-1-lrizzo@google.com?part=3D19

