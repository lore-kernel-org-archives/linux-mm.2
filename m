Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCCAFCAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 12:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 318B68E0103; Thu, 18 Sep 2025 08:28:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EFEB8E0093; Thu, 18 Sep 2025 08:28:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206C88E0103; Thu, 18 Sep 2025 08:28:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D3548E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:28:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B77751394E9
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 12:28:58 +0000 (UTC)
X-FDA: 83902300356.02.A4F171F
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf18.hostedemail.com (Postfix) with ESMTP id A7E371C0010
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 12:28:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=g81jj2VQ;
	spf=pass (imf18.hostedemail.com: domain of "prvs=5356f0da48=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=5356f0da48=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758198536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FlRouMpQLtB0kvLMyco0duirmI8eBjXnc7Q75bnW+0A=;
	b=rWfN+rpCK0+MRqP11k9Eq8EBzhDFJCQ3f4sboXIqJ/6bo/n7HZAcUCwQruLNVWp/cRlTX3
	QH0AKparkd1fOhIrJDhrclG1hDEh6ghlW5kEAUDYxYntTkGO89GC/D/xTbHQCAQMFaTwaw
	vizMYBfNH3cWiHzHFhEd0TGkWU3zaCY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758198536; a=rsa-sha256;
	cv=none;
	b=3y105GpOwNBPrgT1YjLBAQ4l1GoQh1bwHL1JW8g61S2oyN9oHjoloSuQlH/jjIRhoQEfWo
	caUQe8WpaynQ6PuU2/mJALsG9Hs7MIHDFpJKmL/BMpt5kDo08u76XXGviF+/VxwAj2jIKc
	IFP1d37wExysrQq+mhvvuDSprDKMx0I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=g81jj2VQ;
	spf=pass (imf18.hostedemail.com: domain of "prvs=5356f0da48=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=5356f0da48=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58I9CmCw3443791;
	Thu, 18 Sep 2025 05:28:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=FlRouMpQLtB0kvLMyco0duirmI8eBjXnc7Q75bnW+0A=; b=g81jj2VQgise
	74iFa6WsCOD4OQ609NXSC1qPlYP8DSb6+fY7rrbX5Fr1x7PI3yF21ngdSewJLV3W
	zm6PtPSv/vyXAtjz6QubO9OP2thUtdEis25qtPtqFQBSL5PbYyPRT3NjX6LdMOfA
	c0WDFm/ZcfwMM8mlFGYomzH8pI2QmsiZJU8TU7EQCde0CAQucJEPPx3+fMNNp3jA
	wn9mNAaf/Rc/Vsa+YKzFPByqmip3jmxQOkdTVxcczGr8x4c+kB9ObJPtxDF6REMZ
	HrBk+PltATGNFFCkw9u9sd1rEGvfTlrsS7R6mzS1eklGPI4o+smtpKI0D1LA4A5A
	Mf+E3D9HfQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 498f8d0yrx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 18 Sep 2025 05:28:47 -0700 (PDT)
Received: from devbig091.ldc1.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Thu, 18 Sep 2025 12:28:46 +0000
From: Chris Mason <clm@meta.com>
To: Balbir Singh <balbirs@nvidia.com>
CC: Chris Mason <clm@meta.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <dri-devel@lists.freedesktop.org>,
        Andrew Morton
	<akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Zi Yan
	<ziy@nvidia.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        "Alistair
 Popple" <apopple@nvidia.com>,
        Oscar Salvador <osalvador@suse.de>,
        "Lorenzo
 Stoakes" <lorenzo.stoakes@oracle.com>,
        Baolin Wang
	<baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain
	<dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lyude Paul
	<lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
        David Airlie
	<airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Ralph Campbell
	<rcampbell@nvidia.com>,
        =?UTF-8?q?Mika=20Penttil=C3=A4?=
	<mpenttil@redhat.com>,
        Matthew Brost <matthew.brost@intel.com>,
        "Francois
 Dugast" <francois.dugast@intel.com>
Subject: Re: [v5 01/15] mm/zone_device: support large zone device private folios
Date: Thu, 18 Sep 2025 05:27:58 -0700
Message-ID: <20250918122813.1440093-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250908000448.180088-2-balbirs@nvidia.com>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::2d]
X-Authority-Analysis: v=2.4 cv=H6zbw/Yi c=1 sm=1 tr=0 ts=68cbfaff cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=yJojWOMRYYMA:10 a=Ikd4Dj_1AAAA:8 a=K8UWYa9OKnGta0qZC_oA:9
X-Proofpoint-GUID: ZImvgmQS0UbOax2DQ-586paFWLlyJOK7
X-Proofpoint-ORIG-GUID: ZImvgmQS0UbOax2DQ-586paFWLlyJOK7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE4MDExNiBTYWx0ZWRfX+t/DLb3/wcJO
 VdnVVdyaFjelpm5ethMiMrJ0GLnxWv2EOnh0DeHIYvc4eZY3GUJo7+higP3SJYTIXJikjRYAT36
 0ffqylSzfqylOL6k7jlXMsj8+iLWD1XwvaCWdh9CCUazYkBCIXaILZw1Wz8GfFf9Vy8Aqyr8bxe
 GCLpoxBewYIONgvMTJRlm2deijGxwpmw6kBGdp+iwejKNZ6/TT/iJJWNdV5ow8me4IKrD5Lerqy
 S15dKO6er4CuYMzEBYUJr4JACF2gU6aoY0rLHT64HRHNKsvHpDf0L4HnYd8jhUv2gahF2QuLxAK
 Dxw7Zj7fWXHzLmVkplYdrFDS8WZzc4D53x3qhAD8n53OvHvWDkr5U9isB2K3+k=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-18_02,2025-03-28_01
X-Stat-Signature: 87gmtoxfcsh7q7imtm1bxnzj4t8ao7za
X-Rspamd-Queue-Id: A7E371C0010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758198536-264903
X-HE-Meta: U2FsdGVkX1+1cfbPbai/0v/iZjcrruUQ8CjGcjgmUvLqe0OgSy+6k95h1aMYTt3uobHTtY/iBja+xi3JtqE2tNsvh+ikWGbHS28KLthOe619zeQ3DdbfSy1tO7TAv+dRalCegpCG2lcIwn1e0uVQjSqHoTFSBJDm6OfJezbTOmn4lhynl6MRDnRwfdaz4rvBjUH63zez2YyuWlDAyORbRMhlfVxjvC2CqEh2RTNPOpYnWO3ROahVefrkhOuG7fw1lz+jNBkUP+1KMBwcM5OUQi6atjVFyFAkvmhRrw9QTGmOz/PcA0xnkaaQFYmHFK7/tYFo79f0S/GZd4W67DJRUXawYvzptoDkddrQIQAmBuspLviFbhsuSg5fq2P3jt2cItWQudo+eCewIPTUWKY2qM/AQU+KgXZZx/GYwfrRRF6gpAgYf+IRp/QVhq/zK3f+ylfH83bvZzoSg/0wBz64A+QBdlITu8xw+ppC5QATYW+IenwkQxGbBBPCZ+jPhmZmAfwcziuNsAG0CGvvVi2GKAQBjhavbFE0/yjbEMeSiUkfqwEbfPs83M9QSgzmY2x5vKp/6iWeB2LRDroPpr34RDci46SEqAeJ1ZtRLDWWcmG4Jvw3tBExr91A870EWVgNT6hsb8afSk1ZKbcqiZxZF/q/yCORPksWgVOGG/ZvfZnQ/MI38VxMaZ2df7cQYBV4XRCWO3N+HKG3eENbNU7zahmxlCM8HE0Ytpz/WdudaYzfNl4E/rGzLubhYUa12f9C+CnfZvLZwSZj9nlLLk+IIoRm2XA2hwfNMpmxn1BYPFg+PUlcU42qayCfVH2KmO0Wy8AMqzt1kKfJLIv722uPtwhArYRMQd4Bl6yGfvX644zd8CCwbYANW9ARzJOjdA+GiI/th3lIYwycMxtzIMDJK4JCvR+Fy2PatV8dIwlDSXMFKfKyWYJTt+EBlUVD6eehsPyx6VZEgs1ouLDCBKC
 Ej6HYR+X
 EyzmZPDECa3yfXRZnNYFj0K9BK5FK0yC3kySKFFP97DAV+9c6YqPIIqjv/gbsTCNeWyCIyU9KiZL1VK53DoHQkflrBV0ORGnqcWb6PshsxnpceVZWZN9AMIZPESFYN/8u1EoBTBkbFLUR6pEgRt3bGT1GcFJ7XflDWppPaRGbcHrhJJXKmhyn8fNlRYNCVcs2Itds0exHqe3qSh8kuW62RJZjMQbz8LDQFi5s5jumqEDmPlJgm177RvSu9+tOqtBaZYWgS8XYIaLm1UqHgIg2+4kguAUBk35fH3TKzM3tQ4Xy9ZeIHD6vc2jMHLH07crcfK8uyaoihLZoZzEinapCv+6BxMGLNLCB1BN64rcWWfk3duB2Yuq75U1MBS7f8Q/Dhi899NwSyjLuWrduLjcXrVhhVqW/sxEBS4V9cdvcR/A77SLAbzcs6lGBsNCvEpdMH8EZxDdkYzqbKaXHQt+bkE5e9+MAPc3+ZyOn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


[ apologies for resending this, debugging sendmail ]

Hi Balbir,

On Mon,  8 Sep 2025 10:04:34 +1000 Balbir Singh <balbirs@nvidia.com> wrote:
> Add routines to support allocation of large order zone device folios
> and helper functions for zone device folios, to check if a folio is
> device private and helpers for setting zone device data.
> 
> When large folios are used, the existing page_free() callback in
> pgmap is called when the folio is freed, this is true for both
> PAGE_SIZE and higher order pages.
> 
> Zone device private large folios do not support deferred split and
> scan like normal THP folios.

[ ... ]

> diff --git a/mm/memremap.c b/mm/memremap.c
> index 46cb1b0b6f72..66f9186b5500 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -453,11 +452,15 @@ void free_zone_device_folio(struct folio *folio)
>  
>  	switch (pgmap->type) {
>  	case MEMORY_DEVICE_PRIVATE:
> +		percpu_ref_put_many(&folio->pgmap->ref, nr);

Here we're dropping nr refs

> +		pgmap->ops->page_free(&folio->page);
> +		folio->page.mapping = NULL;
> +		break;
>  	case MEMORY_DEVICE_COHERENT:
>  		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->page_free))
>  			break;
> -		pgmap->ops->page_free(folio_page(folio, 0));
> -		put_dev_pagemap(pgmap);
> +		pgmap->ops->page_free(&folio->page);
> +		percpu_ref_put(&folio->pgmap->ref);

Here we're dropping one ref?

>  		break;
>  
>  	case MEMORY_DEVICE_GENERIC:
> @@ -480,14 +483,23 @@ void free_zone_device_folio(struct folio *folio)
>  	}
>  }
>  
> -void zone_device_page_init(struct page *page)
> +void zone_device_folio_init(struct folio *folio, unsigned int order)
>  {
> +	struct page *page = folio_page(folio, 0);
> +
> +	VM_WARN_ON_ONCE(order > MAX_ORDER_NR_PAGES);
> +
>  	/*
>  	 * Drivers shouldn't be allocating pages after calling
>  	 * memunmap_pages().
>  	 */
> -	WARN_ON_ONCE(!percpu_ref_tryget_live(&page_pgmap(page)->ref));
> -	set_page_count(page, 1);
> +	WARN_ON_ONCE(!percpu_ref_tryget_many(&page_pgmap(page)->ref, 1 << order));

Here we always bump by 1 << order

I hesitate to send this one because I don't know the code at all, but the
AI review prompts keep flagging this apparent refcount mismatch, and it looks
real to me.

Are the differences in refcount handling inside free_zone_device_folio()
intentional?

-chris


