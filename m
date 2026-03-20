Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF4101099B37
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A7286B0188; Fri, 20 Mar 2026 15:47:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0574D6B0189; Fri, 20 Mar 2026 15:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E612E6B018A; Fri, 20 Mar 2026 15:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D25C86B0188
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:47:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 825BD14032C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:47:09 +0000 (UTC)
X-FDA: 84567474978.11.FCB60A8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf10.hostedemail.com (Postfix) with ESMTP id 23D95C000F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:47:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d0VOZCk7;
	spf=pass (imf10.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774036027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BfgoQStwPqjCn75prLllAdlpDZj4y2Rn8F/Q/K3NVRA=;
	b=sJZSSUO3d3SlXGIC7udCnMvt3kbEG8h6hX1z1gLU8EvSkoGXIUWLjfFFYABpo0Im/T+6mi
	iAPVu+GEhm38dDA4sE73MioGbMzYtNt/RoK/g6AybW4j2Ml4TVCmdHoJCnvLIYAZoGXJNa
	kUgUywlCwsy8IGsWCjixb4EX/UpKyRU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=d0VOZCk7;
	spf=pass (imf10.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774036027; a=rsa-sha256;
	cv=none;
	b=UUIoY87SUdqYbrz+3OcElUPq6F/n3CoUjjR4UfEUhbkPwqi/s6pZwjrvCdqZYrLa3QOvnW
	eg2b5/YhGt2KnGijkr0K9YqeFY4vXP+8eywb1BhQG+R2ntSxhnb55W0leoeKHZOB2QaZRQ
	UEbBO9FnhQvzHhi4ckZnMGm+gunBiOY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774036027; x=1805572027;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YiQamPDxyeIiPbovBOuuWqfFgcYq7aRawRSOec17w7A=;
  b=d0VOZCk7cRy2M7jK6bEIGrLhmSqRqCCvye7JjyPpcyHb4C+SEzJ83DfS
   jJCGSn+BYjQumkUr/A5MMFuCDs/n8AvfCHBywgALRAuPVzNlRtQJ8Vc0T
   QXE6EDpPGdTH2IQMvymZpcYC9FP3RB9kdzrqSbwIsSaWEMPfioi96okcz
   VFgvMuPgHNRoeRfKPPSugDbHq0II0f8Yd5juFsdjezIiO7BDejpiLJrb1
   qO4moUCugk75n93NyCiQ4lXIP3aSrYBk+VLPboCZy+50GG6N5vTJKzrwW
   nCYDGfeeB9nEau5UAqASCA2rbpLmHpTn0F0He0dBdsgPkUWoZtW58ZfbF
   g==;
X-CSE-ConnectionGUID: Wjjc8ZqzQvKPKkJ9nm1uEw==
X-CSE-MsgGUID: yiOfyNuRS9e17hPnVJsmeA==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="85442857"
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="85442857"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 12:47:06 -0700
X-CSE-ConnectionGUID: r2V4PA5UTweUfGTFBq68dw==
X-CSE-MsgGUID: v8VAW6WFRv66cG/HLAQlWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="228112168"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.109.109]) ([10.125.109.109])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 12:47:04 -0700
Message-ID: <17e58542-1221-48dd-88b9-236128515ed2@intel.com>
Date: Fri, 20 Mar 2026 12:47:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/22] x86/mm: Generalize LDT remap into "mm-local
 region"
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-2-28bf1bd54f41@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260320-page_alloc-unmapped-v2-2-28bf1bd54f41@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 23D95C000F
X-Stat-Signature: fhabx9qc7rbixm7d3cuok4jur8owec47
X-Rspam-User: 
X-HE-Tag: 1774036026-368833
X-HE-Meta: U2FsdGVkX19MKfSe0RiKIquvrzC9oVEV2F4BHgjQo1BQGawDddzKGR/xPg3P/ll0A0ePVuJvlp366zQKnI6DBOED+0vcL6id6vsJ6ypo3qDcEKU0OdyDtlnI18BmkTm5201XnPSREh8Zqi28GDN3pUYm8pQ/ozIEIyMR5yikl5Bm+JCvFK3DC0DPVsE2DPYkLVI/XaTTcd6JeXht8wrxDO7lkdLAtDlDWf2niZ7UV76QD47Am8hdkTvdgSAZyNcxmcJnhyZL3ciqhwqRids3U+GKNXhJKlecYSLWQBf3kEN8T4+yIsNCSvH9cQWOZmAJwEA2cg5lKbIfJoHXaPnnb71KMmyp6SEKeF73ElXV7mEjVhdWYn77Z1KIKQ6/7Kn0/Qfoph6MkEA+i9FRqo2VTdtFXudhkhVVDo3HT1KrglZf8ct/M1nf67l2XvU9yn6vk04+Q+Hdx7Gp7r4zrJM6vJ2DFZpj71+CDRotG08shw8XLXuU30JUmGmVOiRzhNP7jFsOYWfENWhhA5aB/aE0XT7mmjDdb2jjCwNRn1nXW3bcWAmyUPHzsrmgcUquxoTG1hYT1Up+nDV/nsO6vFHELFa2Svh7rLplahhCppmwAGkUXyQWW2Uw3pnsWJdU8RHq8aOD3cZwUfiAnXaPvoP2ETitBx1z8uSzhlXQGXn85vpQ1Aq0+xDz2OEPA5tNYlyAF08KCyEvSP4fP+9rCujCMVl4CCvUppsV1yaJA43V/H7xSeogv9Rrf8Pw70wNkmqvMijBsXkz6b4PvYYyUcxZbcySbMg2e2Hkw1ugaf0okmKpOEBFCE/FmvWvJimxy/hkV1GJtnHfBfObS7DBxqWlDkiN7sCQxCT/loh84lXqUGAp+X3YBSu3lGAlwvKtzcgmdLjMBdpwxsGt7BesfXkBBFXWxlboWSnzLTz8S+iaVFT0Q2GOiWu+cuMvl0UalMLhVx/rILTQ3cls99CvtGq
 pSumoXyq
 DOpd2JWFBkk/NeoCvL1I6Un/4AvsofNL+YMZ/8UftnNsFTE9Am68S/lY8zHF3Hg5Ju9zv/94EkQST0NI5FzVFzF/HvdKyHLZox7RtXV4xAgwfDjPCWOXdqpu9LabA7iGoe7buQdggVBOUDwixGUA1A5FSt7ErfZdSZ/E7EAYb/mydBZYxjFerlysN8smWDMtyNZPfIgNIkzCGFUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 11:23, Brendan Jackman wrote:
>  
> +#ifdef CONFIG_MM_LOCAL_REGION
> +static inline void mm_local_region_free(struct mm_struct *mm)
> +{
> +	if (mm_local_region_used(mm)) {
> +		struct mmu_gather tlb;
> +		unsigned long start = MM_LOCAL_BASE_ADDR;
> +		unsigned long end = MM_LOCAL_END_ADDR;
> +
> +		/*
> +		 * Although free_pgd_range() is intended for freeing user
> +		 * page-tables, it also works out for kernel mappings on x86.
> +		 * We use tlb_gather_mmu_fullmm() to avoid confusing the
> +		 * range-tracking logic in __tlb_adjust_range().
> +		 */
> +		tlb_gather_mmu_fullmm(&tlb, mm);

These are superficial nits and I need to go through this series in
actual detail, but here are the nits:

Indentation is bad. What you have here double-indents the whole function.

Do this:

	struct mmu_gather tlb;
	unsigned long start = MM_LOCAL_BASE_ADDR;
	unsigned long end = MM_LOCAL_END_ADDR;

	if (!mm_local_region_used(mm))
		return;

	... rest of code here

> +		 * We use tlb_gather_mmu_fullmm() to avoid confusing the
> +		 * range-tracking logic in __tlb_adjust_range().
> +		 */

Imperative voice, please.

And a meta-comment:

>  Documentation/arch/x86/x86_64/mm.rst    |   4 +-
>  arch/x86/Kconfig                        |   2 +
>  arch/x86/include/asm/mmu_context.h      | 119 ++++++++++++++++++++++++++++-
>  arch/x86/include/asm/page.h             |  32 ++++++++
>  arch/x86/include/asm/pgtable_32_areas.h |   9 ++-
>  arch/x86/include/asm/pgtable_64_types.h |  12 ++-
>  arch/x86/kernel/ldt.c                   | 130 +++++---------------------------

This is too big and there's too much going on here. This is doing a few
logical things like both introducing mm-local regions *and* making the
LDT remap one of them.

