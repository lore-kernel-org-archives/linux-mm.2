Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40C8FCA5FCE
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 03:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FF446B008C; Thu,  1 Oct 2026 23:03:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6E16B0092; Thu,  1 Oct 2026 23:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1143A6B0093; Thu,  1 Oct 2026 23:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DDF2D6B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 23:03:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 78BADA03CE
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 03:03:36 +0000 (UTC)
X-FDA: 85276190832.13.58CBBE1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf07.hostedemail.com (Postfix) with ESMTP id 90A4D40006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 03:03:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DUW29xBg;
	spf=pass (imf07.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790910214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iq5eYmIxixZmbVOALSoJV/BRr6qgYm9qhgJO3tPtB+Q=;
	b=lqrJ0KkVwYQraKx1ac1Dm/kX2Ujwi1b1LwGw1Cba1bB7f+7Zs+DOZrt/pnDp6Yt7fKae7j
	1cJS9AO/ObGv/QnFUUMVwPh9Num3emwNszSFXHEzYu8HYuO9PmqiGmOIsWSFDL7eji5kBG
	zaefXxwB+rse5iRgDJ/APysTPxbmNV4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790910214;
	b=HIoKyv1c+Kp4d0jQEtBG4Nirrl+gJ2y3EAtBoFI5s2K1vGiJ6QFMiZwreJGDNKMpMsJI2o
	j+QgIwSkUTxkpoLcXcW+e5sm2U1pq4eV2QOdjp/RlSsgoBocCsXAGuwWYKT2LsIAmk3cn0
	ynLloJfaBJV45B0pIbTVmJlUo9JhJaQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DUW29xBg;
	spf=pass (imf07.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790910214; x=1822446214;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=R5uGZziUWDsA1Ci/pCr6s5hpqjNrZYBUeqFKIURcGa0=;
  b=DUW29xBgZdckw+6YjHoJ84ouvzipusGrno5Tx8GxGO3N25mtoVK+99yG
   uKrfWlhBFtW62sKtCyvKmoeRN2ant/8n52opdpE7cp1GMYRoxlS7wIKHi
   6CqFY7s+NVRLuBynidkf3M5Wb+0JCcFtu7tanvXCmX748gsYPU0EOMaf4
   nh+ZQh/9+lqLLwCQuWGL9MOlc/p0c/m/rwf19mxzrD5cPSVmOceTboPoT
   k5Lb0bFtYoPfFg97Giv4JF5cz2hO5G6Z6MHlko8XqcqTR2qNu2WvnRcgo
   eGjnH+qqDRgOs4h7DeLL2XT1ufPfhlUkGr96Dqr/iYQ6gVsh/X0J2T/EJ
   A==;
X-CSE-ConnectionGUID: 4XlL9inHQ2WfLngFp89lzA==
X-CSE-MsgGUID: ohctx8D0R3u9wr3pQdmSPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11922"; a="95492994"
X-IronPort-AV: E=Sophos;i="6.27,135,1787036400"; 
   d="scan'208";a="95492994"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 20:03:32 -0700
X-CSE-ConnectionGUID: eSiPyL4ETDijiCl2MLOARA==
X-CSE-MsgGUID: Uhtg7cSbTCeBgO4x5+/fjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,135,1787036400"; 
   d="scan'208";a="168957"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.111.241]) ([10.125.111.241])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2026 20:03:30 -0700
Message-ID: <2a0bf5e8-281f-4c9f-a0ea-ac195604eae9@intel.com>
Date: Thu, 1 Oct 2026 20:03:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] nvdimm/pmem: remove test_and_clear_pmem_poison()
To: Kaitao Cheng <kaitao.cheng@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny <iweiny@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>, Oscar Salvador <osalvador@suse.de>
References: <20260923055318.57485-1-kaitao.cheng@linux.dev>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20260923055318.57485-1-kaitao.cheng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 90A4D40006
X-Stat-Signature: in6bh6abs8ec8iryom9unn369e9pfpgf
X-Rspam-User: 
X-HE-Tag: 1790910213-978610
X-HE-Meta: U2FsdGVkX18Qt9DxHFFHXRPYCEAR0u6w5QuHPEl/k/QcSfcZ3dCvp57Q7zQglnstposDshY5U8o24rwefibQk2XlzHpp7DQzNmFe5Rmukw640pKRlaZ5aXPOKfy7MaV1Bu9io+7xz5C+V3n3opy14Y3uuEO2H2uW5xow8qOwCLe8TQYLIlwSjr/gPaT/lK0D9iDepS6TJo5wsva240MKgy0RTS1t1EMMeuOrsiMpPQWOaW8Bl9Y0zBRL80SriMHnjWCtkNR3S7DVi6hs7jY6N4LQS24yBxOR42WkDUhEhZhwP9NyDdPDYN6Z+9ML1pZX5rPaX9U7oFviGs09u01gcxyDwP6s0bpFOpIiHegtBUIAxQ84ArNwjsuz6MB5NbpMYoUC0G0iwStqwFlCCcTKWM9ZcPtltEQW3PfK0EipTnjilteX1xfO1jtz4SOF9R7QiUmxpznJwznO+QZAhWZFn9WeY0pbkCpUbFEcMB3JMqr0EBYE3+LWFV1dyRe3a2fggjP1oAhU3xO4gR7a6WphuO4hlvsJRm5fGzVjX35MQBFo8U80tE0Vx3pq2ZiTa0hv9ro1RrUDNDkdtYtqcuZxWmtajbc/P9HLsRi9Kzvt5opx1hexnuO0Qb3atSAEIM5h6SKecB8L1/rEg4Y3gWe6ds9b7JZ4XYxegGsiHTgG7bMXlrfDpWGPOd19avpkZjTvjKpsXMX2WhmNa4FxV7rlKVrWtIzC1jtmd9B2V2GnOPFU5JTLEJV3ir13i0wDEUeby4d8/YzFKa6i8ZB5FyR9ySFSkKEXiPgZmsoDBJc4pcJN4DWKgh7ZrURjAf2qbZZsgnT1IEKmirovChNaFx2zhxA4MFx2a4F5Winp/aXxo6Rrc5ZK8n3Fy1uDdhy3C2cPAWtKEeb7691Qc8r8tyNG7N0+meIhVN0rhtuA0neainXwR6K2Smx5A+Mf6+NK5kcJHhjw2+j64TwRIVrQto7
 R6Z9+E8m
 CQLexrkAWj3pVJrX8J6R3oSholepRMPMj3gW+iR54ojYopi7NsE5NBKGm4+0lPaUlq2tFTaTY1jT4X+bWwI17tfG+6z9UNpgphDMA63rJDleHhWLxImLzw2+0Yy60NV6S+sH5F036SEOdq+lzwXzFH2XucwtPsATUNKU5SZJ/UkrwWeyTECzzjMLtOIZS7rzfME3H78b31u+juFSwXoLp4ccbuSNlRHwxM3IyBJnIqwhDkKcb8XRq4rI19ui9ZJuO+IB/xNWw8fLo0kRIyXt0Qo6z9FAV3B4CXBF8QMyhr9Buaqw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/22/26 10:53 PM, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> The pmem driver provides test_and_clear_pmem_poison() only to handle
> the CONFIG_MEMORY_FAILURE dependency of TestClearPageHWPoison().
> The wrapper has no other pmem-specific behavior.
> 
> Define the HWPoison test-and-change helpers to return false when
> CONFIG_MEMORY_FAILURE is disabled.  This allows pmem to call
> TestClearPageHWPoison() directly in all configurations.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
> Changes in v2 (David Hildenbrand, Oscar Salvador):
> - squash patch#1 into patch#2.
> 
> Link to v1:
> https://lore.kernel.org/all/20260903053535.17611-1-kaitao.cheng@linux.dev/
> ---
>  drivers/nvdimm/pmem.c      |  2 +-
>  drivers/nvdimm/pmem.h      | 12 ------------
>  include/linux/page-flags.h |  1 +
>  3 files changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 30a51c365ce8..5fb86595e8bd 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -80,7 +80,7 @@ static void pmem_mkpage_present(struct pmem_device *pmem, phys_addr_t offset,
>  		 * here since we're in the driver I/O path and
>  		 * outstanding I/O requests pin the dev_pagemap.
>  		 */
> -		if (test_and_clear_pmem_poison(page))
> +		if (TestClearPageHWPoison(page))
>  			clear_mce_nospec(pfn);
>  	}
>  }
> diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
> index a48509f90196..76870505dd79 100644
> --- a/drivers/nvdimm/pmem.h
> +++ b/drivers/nvdimm/pmem.h
> @@ -1,7 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #ifndef __NVDIMM_PMEM_H__
>  #define __NVDIMM_PMEM_H__
> -#include <linux/page-flags.h>
>  #include <linux/badblocks.h>
>  #include <linux/memremap.h>
>  #include <linux/types.h>
> @@ -31,15 +30,4 @@ long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>  		long nr_pages, enum dax_access_mode mode, void **kaddr,
>  		unsigned long *pfn);
>  
> -#ifdef CONFIG_MEMORY_FAILURE
> -static inline bool test_and_clear_pmem_poison(struct page *page)
> -{
> -	return TestClearPageHWPoison(page);
> -}
> -#else
> -static inline bool test_and_clear_pmem_poison(struct page *page)
> -{
> -	return false;
> -}
> -#endif
>  #endif /* __NVDIMM_PMEM_H__ */
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index ae2ebaed6d4d..3dc79c0c5adf 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -655,6 +655,7 @@ TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
>  #define __PG_HWPOISON (1UL << PG_hwpoison)
>  #else
>  PAGEFLAG_FALSE(HWPoison, hwpoison)
> +TESTSCFLAG_FALSE(HWPoison, hwpoison)
>  #define __PG_HWPOISON 0
>  #endif
>  


