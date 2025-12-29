Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0192DE8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 06:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 663BD6B0088; Mon, 29 Dec 2025 01:59:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60E536B008C; Mon, 29 Dec 2025 01:59:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 510836B0092; Mon, 29 Dec 2025 01:59:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3F0A46B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 01:59:19 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C3FEFC56E4
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:59:18 +0000 (UTC)
X-FDA: 84271607196.08.55BE236
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 265FB140009
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:59:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LX6iWUyw;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766991557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z24o1bT1ugcsbBAq+DlkXsAbqHC8CQOJHAmR6N3rhQg=;
	b=sLN83E76dc5Z3hxb071ITmOCsBXC4il7e2/fmq81VmaU7McMUH4LVs9qq3mI3+JB2f14wR
	v+/WE4mz/YzNNJWxcqDmNuByo8463bzTSFk8FproRqikZF68nDN0VkCwOgMvDrl8CApDYU
	bfuBAQmASuXvpt9Fr2tqstUTteBRXrA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LX6iWUyw;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766991557; a=rsa-sha256;
	cv=none;
	b=gryJTL76/S4sNch5QFNW+5iPjYIj3lOtKuihd6QuCHRJRTXhLV5XD6GZYA7KAOiGnSCEsQ
	qlgl1PnHOmnef3i1wlszWY0Y3jkCmRrKsIiJREHfJ5n32BLW12UhGnuLEhR9bMDcMl9jCI
	O7D3BxqIy1zETeCmxWdSaxYgDw+maCE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4110343E5F;
	Mon, 29 Dec 2025 06:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013C0C4CEF7;
	Mon, 29 Dec 2025 06:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766991556;
	bh=o0wgikOuKph/UYuKT9+K1YO24u8iftLUAb48sk35Re0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LX6iWUywtDOVwU3j9KaL9yXGKfNvvYoCb2qlBXzbFyPsnG2vGbJfpde+T2rxhLMi6
	 2QkUnuWKjSpsWFFAsUzRcNl579W7HN0vsLwnx0uIdqDYc9pemeno7sciMWkg6kcTI/
	 4/xSfoSw/2dLsoppKWxsEq5G+zDhlITLjIbe3xtQyDd3VX8EaYH8uBU7LN15p9UqQL
	 FVs9iNnIt/1eTm9Frc5o3vv9Yv1CER2nZ+JljzygBIBdOv7xURTNYUtEzZKhlQ+g8z
	 HHaOgTGPYzoj7al1VV0VjV+KDjSPLts8cDtlXEe/iJFkjLIODRbrq6dVEwqGplAjPU
	 8vCr0gtMZU5XA==
Date: Mon, 29 Dec 2025 08:59:05 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Eugen Hristev <eugen.hristev@linaro.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
	pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net,
	david@redhat.com, mhocko@suse.com, tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com, linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, jonechou@google.com,
	rostedt@goodmis.org, linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org
Subject: Re: [PATCH 20/26] mm/sparse: Register information into meminspect
Message-ID: <aVImuURq0FXsfsrp@kernel.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
 <20251119154427.1033475-21-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119154427.1033475-21-eugen.hristev@linaro.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 265FB140009
X-Stat-Signature: 1ijtrhn3kzcyt1o3654yu7jb4bqpzcnm
X-HE-Tag: 1766991556-562120
X-HE-Meta: U2FsdGVkX19vtnpdXWE4rQcuUGcIGMgV4aqteLs22ldzsmCUtiZZrI7UrVMORPNUGSDK5U6PqD5a/lLaTlt1Z5xzyG6xCxSzBQPgPT9IOtYcEtDYsiLUMpdBf3LvcCYk6Cpu9nP+Y/obFRq6CtK5ah3aTtqEyO1OL6/MunUjMgUFPn9udPOikaqp/pVc0r6znr+q1AGmx94C1PuldWZpulQqhYrGBeQlQckub/5KVqOtYT4vDkCN08RhIQzHF8prxJl1hhOej9oXcc+fk5946szwsmt1b0F4Ju3Mov9iJ6itFCpg3HTt0gRP8Na1a50A0Vt6W8qj0BQySlNdXzT4oolrV9cFov3XzQLIoPdLEQfibJ5JhdNDHa7eyDNMplSuWmBQILvaF1sdO3vIaRes4ReHjOIcefD6s7rIzdCUIg4sqPAoUYsuFDhsR5LHFPAXraqhznXBBBe6qsRyst3Eh2C9+B4rqj8g5hAOB3WO5HUXSCfsOQp6gsinoXtmIQdshGtX0my8y3R1cezIYXSZV7XBLVvXeVI9zPghK+eUG0BJq7gpA9JyT8/pmmOeG9314VBF1D6D/pDedjr+kRKsN1UC9kb7OCEN7uM8CkRAMMQigXWHmg2kI8bsYVeZwqQxR23SCMWvNU9HFW647Wau6ZjWByIKlaMa4tTi1xYn5rWBNS5wFzQg3TsAu4hSfW7DxK+68BYnVj+UMMJQDX+WdCEC+fUkMjJizKnn/vjp+/RSfwg4A8+gCkf4BL+xXIp8VOQhsx89StGqsEYhlNJfzksqA3Jd9XK2tOsPziAG3G+aNzwqL1JZP0ud4pfzBgAn1gLBn144uEvn84jqTxCXQWy7f+vULnfLpeEhRzIRhf9nwAfGpikRkR2eEIzboYaRD9E+79lfhI7kyeCgRJl/w3Dc+rn9jJgFIy2GLdopsB3U3ENelXhdOjYynycIAauYGuX48LjYBS7SGlCovNB
 BCKHUwRg
 6WJuYR4X9xYac8/U9Hu9PbZDcFGrJIvJ6hiHVZJvEbVjGGv7Kjcmz85sPb/Z5r5VLIXW/pxkF7sRbU2qdQaASEjRxiEdVLupazFj3x++wCx7XJtLmqA3qLzqPSk2oPFDf3PYlw0oxWTPYE4uYZ0ktTU4htkbz+7+LBVGPt/Hy0XBtuU5T8fBQBvbPoj6d5xi83cSdqekqbQv7HfP/mmOoH0nqY9yno/mhu5B9rbc6TaU42mT1ft+adT6hgu02WR9K8SpN7NHyAk5cgJSmrGmWYNEMJAsziXaGY0IMTr0zo9HbB3JK+0cqezf6yQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Eugen,

On Wed, Nov 19, 2025 at 05:44:21PM +0200, Eugen Hristev wrote:
> Annotate vital static information into meminspect:
>  - mem_section
> 
> Information on these variables is stored into inspection table.
> 
> Register dynamic information into meminspect:
>  - section
>  - mem_section_usage
> 
> This information is being allocated for each node, so call
> memblock_mark_inspect to mark the block accordingly.
> 
> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> ---
>  mm/sparse.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 17c50a6415c2..80530e39c8b2 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -15,6 +15,7 @@
>  #include <linux/swapops.h>
>  #include <linux/bootmem_info.h>
>  #include <linux/vmstat.h>
> +#include <linux/meminspect.h>
>  #include "internal.h"
>  #include <asm/dma.h>
>  
> @@ -30,6 +31,7 @@ struct mem_section mem_section[NR_SECTION_ROOTS][SECTIONS_PER_ROOT]
>  	____cacheline_internodealigned_in_smp;
>  #endif
>  EXPORT_SYMBOL(mem_section);
> +MEMINSPECT_SIMPLE_ENTRY(mem_section);
>  
>  #ifdef NODE_NOT_IN_PAGE_FLAGS
>  /*
> @@ -253,6 +255,7 @@ static void __init memblocks_present(void)
>  		size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
>  		align = 1 << (INTERNODE_CACHE_SHIFT);
>  		mem_section = memblock_alloc_or_panic(size, align);
> +		memblock_mark_inspect(virt_to_phys(mem_section), size);

Why not meminspect_register_va()?

>  	}
>  #endif
>  
> @@ -343,6 +346,7 @@ sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
>  		limit = MEMBLOCK_ALLOC_ACCESSIBLE;
>  		goto again;
>  	}
> +	memblock_mark_inspect(virt_to_phys(usage), size);
>  	return usage;
>  }
>  
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

