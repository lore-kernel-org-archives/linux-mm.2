Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDE481098787
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:14:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E6396B0140; Fri, 20 Mar 2026 10:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 396206B0141; Fri, 20 Mar 2026 10:14:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 285AF6B0143; Fri, 20 Mar 2026 10:14:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 13F046B0140
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:14:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B1A1E160257
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:14:10 +0000 (UTC)
X-FDA: 84566635860.24.3383F1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 15D1810000F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:14:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fZCRBQDz;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774016049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t6q6m8drj5I1MRZIi/nZNZR06P222KtcO4nLIFbR/Rc=;
	b=DQzabaRsuytXxLhVaEPhul3OiJK3El0n/aojiJAcvDWH8LTTiuP4d+dgWErtOEd5qdGvTi
	ZIJenILimTlcA76Kkzyyw6hnCVYSms/MOcxSP3PIpUtlmlTvrskPSRi+4onamuKbyCFCD8
	pNDKr2FrqnBDnum3nV4k8daU+uaSlck=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fZCRBQDz;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774016049; a=rsa-sha256;
	cv=none;
	b=luizCeENhwCUIQGEMxAJBx/BRH/b6rd65FuuXeScUf1XgzULQfFylC6bU1YAO1Ghlieyli
	DtJe8zf/WVmz5jvWTSWSqG6zBmtuKcabGFru+WSP+cvtfdxj7r7h+vY86rsDaCiO/9AhN5
	+EZ2lln60CnFY5fd0rE9dvwsEJA769s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1185040132;
	Fri, 20 Mar 2026 14:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210F8C4CEF7;
	Fri, 20 Mar 2026 14:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774016047;
	bh=VLxnhPhI+BqFW3m4AViBRfkcw3Wc1Miamnuz2Hh3MGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fZCRBQDz58LKtCPVHZTbW7ErjfRh11V5lxfl25O6R8S0EtQ7AKIK+vJDIz7TFzRQP
	 +Qa6NGzYHEwZUzmIQ8PItMDv5CTXAK9qovEqUC/TrCARRBPieLUKCKPJY0dbVy2FIm
	 SBeOwFkiysraAFL3GZde2s5KGn3GWO9bQpzr3BnDVyNkjhvnLBrIdJkAKsGacJMgoK
	 i0XKNstZ/K5203taw70NJ2y7Vu1ks5BkxZ8drAsCSKcmGkWsJ69/EtO4lnyaP08E4B
	 JgxJ3we3LrT/e2NwbLaxRZr8gsSxUJbPJ86glZesRYrj5VDj6VhT5oubEXBCA5aApT
	 Fy+I0vUotcoDQ==
Date: Fri, 20 Mar 2026 14:14:02 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/9] mm/huge_memory: deduplicate zap deposited table
 call
Message-ID: <47ab3f85-28fa-4868-b2a6-f9a33789f8fe@lucifer.local>
References: <cover.1773924928.git.ljs@kernel.org>
 <29fa4129cd560681c67433b4c344b2c9a027d1b4.1773924928.git.ljs@kernel.org>
 <abwr3EmhNZVwOkR3@thinkstation>
 <420f1b11-3b62-46dc-be33-58fbd5a4c8b3@lucifer.local>
 <abxwNW_kKakiYvsp@thinkstation>
 <81116647-1f3c-4ce9-8aea-cbe6214f7c4d@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81116647-1f3c-4ce9-8aea-cbe6214f7c4d@lucifer.local>
X-Rspamd-Queue-Id: 15D1810000F
X-Rspamd-Server: rspam07
X-Stat-Signature: jb5jdpp64t56xdtdf8dutc181rypmd3d
X-Rspam-User: 
X-HE-Tag: 1774016048-793713
X-HE-Meta: U2FsdGVkX19irwxwnhCqLBkaeu9TuBo+rSknTmUupMfHVQvESxVa1/hRE3NN+0U+uqStknXFi6kGwyJMq9JHTbeknreeJH5+8Yx8sbn/pSAdzTBU8tiKMV+w/h783fdUamWzRPxQw85i3MyprRvL+ueQbOT246186IVZVUg+i6JrflIYkp6/INTEn3eKRpBi5z0Zfc8JdT4DJZXvgqGlZpWcZG5U4uVIfVtxOSjJNRc44iCjeamlqqD8mVOtJU9yK5CNxIzIKGH4D2TJtKrt5vT+9xmeZ4YEU1js2Cvj9G/E7dJ208gEE4ctKsvidqHqCElYDlhwUe4PvBazwsb4RTdGxKPVFfvl3ObVoZG+CvV55tLGX95eitJ+Fk+QWPUlcWhaYIUsxJKcdVhLFnkKOjml1ekcqX5i8HisOZdjOxGfrpPGnB72VGGgC8ECI+8liFJLQCWjrofur/2LPitjvuXTNi8s93OcAFQgYQBHbP4SIqrGl0AmOOBiaNp55bn/NA9HPXzEkuLaIbseN1UwbF1NGJ6K82AddWiIZDZqOB4xGNr6z6T5OMvpEipfH+kf1D94PgOK8KBiLTa9S4g2dmPLrzRVPtCbXqijMd1EM//U56LaaFURNaL5UzLsekoD00pNbI8S0LNZTYT0x3GGFBH5EWhojvlhlOPZnG/PWMPJEiV6IyQLxsqqIXKbrLdYg9RvYUJRE/Thfy6VHaS07O0JgZbgTc7Vb3Oizu8XSDwM8DcmLYdcj/z5/PescnSQ9ItZoauLaUtHi1wB4GfWpGyz2GDbHLd3+bW9UtBE1WSDb9K+r7f9zulac31hhEfVIJXCatwycBNFShHcwlLGztaLZTnigKVPNI0N0nspx2/EKV6Wa3ydS/KHygHUS0zS7dY/dR0IB3SEH7z6daT38zEVTbzdofmbC9RvO/QERaV0flR5/5dNmsVDW74gwnRl4lfJa+HBOMLocK+xUWm
 pd1hxCtc
 apXs0B/ldq23gQx6WiZ6hrBvMS144KzN/AQe/p63lh7W0cIvR0HCBcWlaRHZAzUrR2pGzWuEpKo7hxtoX01u4e+6CLV8LgwY2G3xRgPo3VfarDGvS7EvCifmJS6sr9k60lUcuW1sbPaiPEfVsSL0vrD4MbQyAharhlmSMLilTm/tI7Btv3kTlFb/mYjX9z/A2tQEWOSWBraCATiqjDyvsllOzMpzai/rVbu4Tu0KqEiSTobr9adc7cVqsBiwrkESKeUXXiidLQaIKVPwOOaaDGe1CeOXk3J8nc9L8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 02:00:04PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 19, 2026 at 09:56:53PM +0000, Kiryl Shutsemau wrote:
> >
> > 	if (!vma_is_dax(vma))
> > 		has_deposit = true;
> >
> > No need in squeezing it into single line.
>
> Well part of the point here was to avoid ugly:
>
> 	Indent
> 		Indent
> 			Indent

Actually it's not too bad let's do that.

Cheers, Lorenzo

