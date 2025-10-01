Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AD5ACCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 20:28:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BD838E0007; Wed,  1 Oct 2025 16:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3948D8E0003; Wed,  1 Oct 2025 16:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AA0F8E0007; Wed,  1 Oct 2025 16:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1AB378E0003
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 16:28:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9207557265
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 20:28:20 +0000 (UTC)
X-FDA: 83950682760.30.7C5725E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf04.hostedemail.com (Postfix) with ESMTP id E0AE840003
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 20:28:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g3tcPX6p;
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759350498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xlQ/eEuYLqdsF9tepaMbkPtMHgOZAonQwHnhaaYoZag=;
	b=04WO3vZE8fvl1/8ak/WJUJx+jGC2b3rXmQrgq6oCQ3ktHMdInwS13jJAm4+oOFpwY617aS
	6aT+SL7PeJQ5kEiAUduD6xTXhGMcpFRPtFjkNKOEPG17k9l40ljKmSeE9L2TeKxGsal3u5
	l2B3cWPTAj82tpcWY7GCiicNxGDlwsE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g3tcPX6p;
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759350498; a=rsa-sha256;
	cv=none;
	b=NU7dRuQ6vO30O2co9lBcMvb+SqxnZOxSFfr1TQfs0Ot04PbzgKFLJl6kM1pPLHixkuNSOz
	VfDUvBuG2ZkR8KW19YyoJ1qopXrAquG1H2rM7MJy/9F98iWNgQF3f3gQA3+llPjoQwCFSb
	cRBJgj46ssQI2xUmfP0URrcA+x70yCA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759350498; x=1790886498;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LlcH7vyJmv35KEF+YeiG5f2vq9X7M5kexM/dDzucHhM=;
  b=g3tcPX6pOAqpm3NA4CShc+1SsVonxpAn3xprKsWZ7D0VfUsgtXbEvbXK
   x1iGNc/PhO8DCdbz3mixzF/+dVVcLhRO5jbTxVln7PYFYWyyEQ0S+cVgx
   OXXTBE9KMjvPxbI0OlSaYL9pvav+6OXw2WU0qr4DLuZilZtYkCl3LEHOe
   /M1ok9707rtXZ26kXcGcD1iBUkWw9eJpPZiVqLTHdIkS1p9bZCUL6R+ld
   XQec/rsTMVixHUqkqzFt3R+scHPNq1iQiKaLTJCX7U/vWBhKAg9TtByL3
   N78hJB0JcF39v2ZiDh/m9QB0wgbrgo4i+GFSq6nU6N1ydVc2BBhEG1Eu/
   w==;
X-CSE-ConnectionGUID: 3biK3G9nSFipVnputhj5oQ==
X-CSE-MsgGUID: lILpO+RgQfOn2VNVWuYiNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="87083796"
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="87083796"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 13:28:16 -0700
X-CSE-ConnectionGUID: PQ55WtNDQVeh6uBnVQvKAQ==
X-CSE-MsgGUID: M0TrMgDRQYu4klrdw2kHMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="215998890"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.109.221]) ([10.125.109.221])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 13:28:15 -0700
Message-ID: <b0fb40f6-8baa-498f-bb88-50113cb80f53@intel.com>
Date: Wed, 1 Oct 2025 13:28:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/21] x86/mm/asi: set up asi_nonsensitive_pgd
To: Brendan Jackman <jackmanb@google.com>, Andy Lutomirski <luto@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com,
 mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
 david@redhat.com, derkling@google.com, junaids@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com,
 rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
 yosry.ahmed@linux.dev
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-4-2d861768041f@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20250924-b4-asi-page-alloc-v1-4-2d861768041f@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E0AE840003
X-Stat-Signature: qz8h5qqqhhh93fdrz5nrwzagu61r9htx
X-HE-Tag: 1759350497-540777
X-HE-Meta: U2FsdGVkX18tVA/+XVznmwu8KqX+0Rsum1So1PAjEHBWTgG/fPyAefPIXdygp/LyPEmcxYKa8pTp0clxUryxOmS6MHjEhRfpC/ZaG0Ji9vlJfueTJO7LrV86/T/DaMCalRg08FrV+fwjGXxrfml9j9N+h3/z6VZARFPwt3dbaINysltjBwXeLTvho9D4kXTVJlIeoeDPdhixPmFKzUnRt0CbgGHKQ7qm97I8UiVolpF+yV5KcJbekpuPHlQaVr2Q/G6zX2JuTqwB8XNHwPYLFvUa9CLRUtEe92S4uFrStiuDnTM4xF0Q6PO/furom4Ys+UbhA5RIVqqZxEj2ZcDuQabOY4YZ+VPnOIxGdpmVT2zzOsf2YAt8YMIX+9zX2fIhTCt0S68L/JPYAs8y9ARZvZdMv1MoZV1RaqqsyoBcVKxBRR9QtZEZEhCnIVY6Y1GD00bqalYO8498BQ7y7KTLOj8SLs+xUq8k/nYoSh4BhldBTY7ubu9LE74IIFVTzY5xvNCYsR3qqTlxNG6bjQPU0w3mApvJSsVqa2tp3mTTAYzFAbtse4r4gYQclGqF7tAdjH/1FvIQ66ik+D6dd909TgNZoEtThbK9NE3LUTrpXjpICZE7g9AwtclKqUCJtQD0nDlKyfKLJp12zhmOimj3fdzDaQLYvdlyylR74UjBYSkgAd1k2ufLijBEC5LUvftKtC+DhxD4R73pG5EOVoKevo6ozxF9egXFIgEgrZwzVw4tylHyHjSz/FXXfn7P/y3HdwNXhN+vCLSoVyvo/kHU/eRiqVFryC74bLV2KdfzRqtWKzcPXsMBs2OzKoghokV69V51HA3wTSAn0dVlverPpwubY75fM5rXBTO2j54WkLZ6qNN8pG1Re4DxIzVD34+jwJlwerao20aTRS/q3PWbER/h/ypsB3bdCEtJERNMcD4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/25 07:59, Brendan Jackman wrote:
> Create the initial shared pagetable to hold all the mappings that will
> be shared among ASI domains.
> 
> Mirror the physmap into the ASI pagetables, but with a maximum
> granularity that's guaranteed to allow changing pageblock sensitivity
> without having to allocate pagetables, and with everything as
> non-present.

Could you also talk about what this granularity _actually_ is and why it
has the property of never requiring page table alloc

...
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index e98e85cf15f42db669696ba8195d8fc633351b26..7e0471d46767c63ceade479ae0d1bf738f14904a 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -7,6 +7,7 @@
>   *  Copyright (C) 2002,2003 Andi Kleen <ak@suse.de>
>   */
>  
> +#include <linux/asi.h>
>  #include <linux/signal.h>
>  #include <linux/sched.h>
>  #include <linux/kernel.h>
> @@ -746,7 +747,8 @@ phys_pgd_init(pgd_t *pgd_page, unsigned long paddr_start, unsigned long paddr_en
>  {
>  	unsigned long vaddr, vaddr_start, vaddr_end, vaddr_next, paddr_last;
>  
> -	*pgd_changed = false;
> +	if (pgd_changed)
> +		*pgd_changed = false;

This 'pgd_changed' hunk isn't mentioned in the changelog.

...
> @@ -797,6 +800,24 @@ __kernel_physical_mapping_init(unsigned long paddr_start,
>  
>  	paddr_last = phys_pgd_init(init_mm.pgd, paddr_start, paddr_end, page_size_mask,
>  				   prot, init, &pgd_changed);
> +
> +	/*
> +	 * Set up ASI's unrestricted physmap. This needs to mapped at minimum 2M
> +	 * size so that regions can be mapped and unmapped at pageblock
> +	 * granularity without requiring allocations.
> +	 */

This took me a minute to wrap my head around.

Here, I think you're trying to convey that:

  1. There's a higher-level design decision that all sensitivity will be
     done at a 2M granularity. A 2MB physical region is either sensitive
     or not.
  2. Because of #1, 1GB mappings are not cool because splitting a 1GB
     mapping into 2MB needs to allocate a page table page.
  3. 4k mappings are OK because they can also have their permissions
     changed at a 2MB granularity. It's just more laborious.

The "minimum 2M size" comment really threw me off because that, to me,
also includes 1G which is a no-no here.

I also can't help but wonder if it would have been easier and more
straightforward to just start this whole exercise at 4k: force all the
ASI tables to be 4k. Then, later, add the 2MB support and tie to
pageblocks on after.


> +	if (asi_nonsensitive_pgd) {
> +		/*
> +		 * Since most memory is expected to end up sensitive, start with
> +		 * everything unmapped in this pagetable.
> +		 */
> +		pgprot_t prot_np = __pgprot(pgprot_val(prot) & ~_PAGE_PRESENT);
> +
> +		VM_BUG_ON((PAGE_SHIFT + pageblock_order) < page_level_shift(PG_LEVEL_2M));
> +		phys_pgd_init(asi_nonsensitive_pgd, paddr_start, paddr_end, 1 << PG_LEVEL_2M,
> +			      prot_np, init, NULL);
> +	}

I'm also kinda wondering what the purpose is of having a whole page
table full of !_PAGE_PRESENT entries. It would be nice to know how this
eventually gets turned into something useful.



