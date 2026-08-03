Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C8B2C5516F
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 06:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D8A86B007B; Mon,  3 Aug 2026 02:06:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A876B0088; Mon,  3 Aug 2026 02:06:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE1C66B008A; Mon,  3 Aug 2026 02:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBA596B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:06:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65C12A0615
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:06:15 +0000 (UTC)
X-FDA: 85058923110.24.BBD43AD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id E438E160004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:06:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iruYuenG;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785737173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dHx0BPX7ougX/+WQX8+Igo3gLORql8pP1IHdnY/dTqE=;
	b=ykPPzS7DHV1p3nrDlW8AILJb+src4PSpnMgwPiemK4VnahKah1TfmkwerhbnNWnGQidBlt
	zyRimnlKT8Op/pNvWVRKDnGUr8txCLIan9vsheis3UVZRt9AV8nQZyDBBPkfyhUCleY6Ri
	g0Y8YIUR5vzd3Fb2Z+HABjjhsrP9R1Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785737173;
	b=bFwzSkJ2RKeRlpOm+OqudrUDR/D2O3rsWSRkUtNKNL5pGiB9XkVBXuzS3blyaT31XqwWFF
	yA8P8ovq88QzgnttPpaWT94yX1FJmCk4TGGYDxZTQBUPw35E9NEesUEVmGX1/Vju+chN8K
	cyjXmTfRC/+N+/nzHoYpbVOWJR5Nci4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iruYuenG;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CF09143D;
	Sun,  2 Aug 2026 23:06:06 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CA2503F66F;
	Sun,  2 Aug 2026 23:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785737170; bh=M5pg11oKIM4Kse8+NHvWTGHhXFBTai4XIbhAYRvYBCM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iruYuenGfjcuF4hB4gbUrvjtkgekeypawf57jFrWr3tb/LSTU6C+vmWThKMqDRhCY
	 559FVcSYzOF/G4bpsrTTmHUyuLSe/eK0D/VX7UUz92C9MRgC8mJxIVuOsI08KTxo3l
	 1NPn/FhW3KHzOCbaa1Iu9XcoTnFRJL2VWLAjw6+k=
Date: Mon, 3 Aug 2026 11:36:07 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH] mm/sparse: correct init section annotations
Message-ID: <xcu5b6z5fxnbwesw5zdljksjozgtb7zdtct5envczyibx4gfbi@lgv6pzrfbk6k>
References: <20260731164758.1210668-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731164758.1210668-1-ekffu200098@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E438E160004
X-Stat-Signature: i55kb6wwgshxe4qytxe3ocmtjts5uhxz
X-Rspam-User: 
X-HE-Tag: 1785737171-260852
X-HE-Meta: U2FsdGVkX1+svSskvzd/q4Mg+C0c7J5mcYU6p317fQ/cj4sR5s8WvuEBIqmyFTtSGDXVTGPFKC+lVVPhCBaONd+UrPtEzu5P1CRMNPVQnV4FXat3FcSzimZNbwp75yvyx0FyC6UYYt5i4eK2+/lbEfsT454sLfAiOfGlyveKiicXDKNhByEPneZcH56U3yFrHrpaTMDhovSLOz//c+nz/hR+aiX5WELHd/T5QrlBuWhZ2TQ1So3lZnusrsfiWj/U0eeMSPlsHIh6I6fOQIcdNv458DxXMFzy4wrkvYEJQKXAKzINSDvi8/hEjRS5xwJAffEBDdRu+E+UQwjm2JRFW5KFKMHWuTLAZzuzky5VCqzut4pmcsAiajW0bncjaNBbluZGj0U1r3v8Nndq8tR4jpykI2A8Vw7w3EXrMZWyJHRVvcZrwmmbrDPF1f76XYbj/lqngT/i0D5ME1m3WBE1TpATxjR0LfA1AbHCxoW3EokgNspOsdLJ/pv9iuLqwI1keTPNHo+KYFATpZ3UBS8RFhQB+WNQeuFuCf6nZ4IsT4kDU1P55fF7KBnM3U1b+Z1cIQqXVhhX6diOaoDYseQL62xkNOyiM+sv3TFkccFo8aHXrqtRJzkoU9Euk67rY4ReS5l4ajPv4Pcgi+9didn2kuMqxEosfHr7fdyFMweigqnp3hlrjlPA+ch6tgLvfwFJPcgqzCOzqnBJBMw2QiB3pt0/2IXbfIMDP5iL5DcUISZePXcw4wQg3gQC1QTereE5b+KPHdfaQjiz6Q7oW3DGVrXq5ZLeMJFS4W51dsOzwBswdCKKa2+fCDSqef3OJtyxOmj1GO6ttyjeJZAhj3zCVdJ+WqtPvc5nUYysU1M3JPunKzOMqnMQhKB+HpJS17FRb+YKD/vM4C9bMASIyEcIf7cwmYC9k/3sTAbDerf8yoy3s7VMqVZtzumLfaOeLU7JB4KTuDXFbw6o9TK6ncn
 6fldD7R7
 o/RpNay5xTtkN8V+LsR6b9Vpnr2fR82x3CXFYlKByGEUjORy9pnBH7fLk08IaB4i61PxTeYv7wpRTraIWRUliJZWSUxHLqAPgLOTBxcSktPSYN+g/nmi1POmoIy1d00KKhXOL9/oAN4qbvrkNeTQL8bYA0wEb3maiqSbGFe4L0lPkKvy6YWWK0a21rlDmkMFKTzphQsZRGF/OBgKt8wgM/heno9RDPMriuxr70w9gUHf+JUNe/GHCQ0S1M46JCkGQj2iTQaedgSprluB+cnX/o0gHzNMFeFNzvz6F84SnXEPkCUZk0Tjf4c61V9cB3UfRtSIuEN7gD84uDsMizzcUIgi+HryALheAZauZCfxZO7Gbv4c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 01, 2026 at 01:47:55AM +0900, Sang-Heon Jeon wrote:
> The !SPARSEMEM_EXTREME stub of sparse_index_init() has no annotation
> but the SPARSEMEM_EXTREME variant is __meminit. So mark the stub
> __meminit too.
> 
> mminit_validate_memmodel_limits() is only called by memory_present(),
> which is __init. So mark it __init.
> 
> sparse_usagebuf and sparse_usagebuf_end are only used by
> sparse_init_early_section(), sparse_usage_init() and sparse_usage_fini(),
> which are all __init. So mark them __initdata.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  mm/sparse.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 704a9dec2b9a..67fa192d4289 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -104,7 +104,7 @@ int __meminit sparse_index_init(unsigned long section_nr, int nid)
>  	return 0;
>  }
>  #else /* !SPARSEMEM_EXTREME */
> -int sparse_index_init(unsigned long section_nr, int nid)
> +int __meminit sparse_index_init(unsigned long section_nr, int nid)
>  {
>  	return 0;
>  }
> @@ -127,7 +127,7 @@ static inline int sparse_early_nid(struct mem_section *section)
>  }
>  
>  /* Validate the physical addressing limitations of the model */
> -static void __meminit mminit_validate_memmodel_limits(unsigned long *start_pfn,
> +static void __init mminit_validate_memmodel_limits(unsigned long *start_pfn,
>  						unsigned long *end_pfn)
>  {
>  	unsigned long max_sparsemem_pfn = (DIRECT_MAP_PHYSMEM_END + 1) >> PAGE_SHIFT;
> @@ -249,8 +249,8 @@ void __weak __meminit vmemmap_populate_print_last(void)
>  {
>  }
>  
> -static void *sparse_usagebuf __meminitdata;
> -static void *sparse_usagebuf_end __meminitdata;
> +static void *sparse_usagebuf __initdata;
> +static void *sparse_usagebuf_end __initdata;
>  
>  /*
>   * Helper function that is used for generic section initialization, and
> -- 
> 2.43.0
> 
> 

