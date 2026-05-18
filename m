Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C6FCD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D44C66B00A7; Mon, 18 May 2026 05:54:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1C7E6B00A8; Mon, 18 May 2026 05:54:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59AD6B00A9; Mon, 18 May 2026 05:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B78946B00A7
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:54:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7865C1208A0
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:54:34 +0000 (UTC)
X-FDA: 84780080868.28.0390538
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf27.hostedemail.com (Postfix) with ESMTP id CE2CD4000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:54:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=XLPdiWCB;
	spf=pass (imf27.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779098072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wgbr+2+9/hNiYiWVufx6FjCu45ByoByDRte7+gOCp9c=;
	b=uDBURftcLkODG/vjyzRIU/Wev+EXciNoDGk8YUFrIJ8Wemz6aOHhzV0C7mD/2N7BbF6ZTK
	XqsEtlO0cN03MaWzu4V+RXPou5bUjNxZNI73ONt5XyZMFSnzzGkCYqylNQnsoQXgWZsIgn
	bmD/m+csui+hGsJJE8MSGidCoxheCXU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=XLPdiWCB;
	spf=pass (imf27.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779098072; a=rsa-sha256;
	cv=none;
	b=rPX5RcetEyqQ+5t7rXrMcQpZ+Lh4ZfFnGT+Kf1WVeb8Gq8yFVkXz28ZR8cNmeV1utH+/8R
	fGuaY3wjz3rL/Rpbf52+2oKaWeImR2FxfcJ2Ot69yO6KaIJKJA0LkoJkAT3W8Sd8Dfrw9Q
	er7c/lWcL1uUEGVTCVEbc8t+nz4mCoE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779098066; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=wgbr+2+9/hNiYiWVufx6FjCu45ByoByDRte7+gOCp9c=;
 b=XLPdiWCBSTzzojXfvVfLm3V5EiuD8qZJ53pghpWj65OMMC8mHXkPwKn/uu1x3cmIBl2mNJ
 sjGeOLzg99PizJFccmkHf3qw7iSZxFF9NQFxe2lbo6Db+3rwwz+F3q1LKbkF/geNlDTXhE
 YQaDli+c5KUpF+UrEnOHdlCSPl+Z4MLLrMRrYbeGfQoXDDppegnZUD3lcLkivRUcGYspAJ
 wx8U3GlBPxgO2iJHycv8NNLXLynnfqzIux9TecZ1yuZ2VsH4hUqLLAm4qYUGNLfySgy1Nl
 1pP8618TIv89cxTWIVs6VchP3cDGv8ZFL45KjJBjgTXII8IAL+qru5oA3UYSsA==
Cc: <akpm@linux-foundation.org>, <arnd@arndb.de>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <mingo@redhat.com>, 
	<tglx@kernel.org>, <x86@kernel.org>
Date: Mon, 18 May 2026 17:54:05 +0800
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <agq29raPaAPlM8kV@kernel.org>
Message-Id: <20260518095405.76367-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a0ae1d0+634fb3+kvack.org+lizhe.67@bytedance.com>
To: <rppt@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
References: <agq29raPaAPlM8kV@kernel.org>
Subject: Re: [PATCH 2/4] mm: add a template-based fast path for zone-device page init
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: m36ygwb7yxsmy8xsj56szk7ty67ncsxi
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CE2CD4000A
X-Rspam-User: 
X-HE-Tag: 1779098071-993286
X-HE-Meta: U2FsdGVkX1+y+SvBsXPOFtW+X8YuCWT9zSJgHaMphhfI/27dOMlhEphHRIrW+Db8C3iuYY5IRcvLNtlWplIgbw9d7fD4Gg3w8VUjHmB1+wajhplOCKPXmeKGhIOZ3C2/mJeD2eS+zpLdXnD9a+UrgWXse5JLLt27ZgaJG0MnNUVqV+5lluJ5fBpkhCa60CyKWPRFPujtgTuL8Q5cpDrDU97myiMvi8LP2+dLs8uvNJmfmFH0+bZKCe4+wvhVHvf8eeW9Nhn7zhJmgfc9PQTThkCbQE+g+ch+UFvJrGGcpdvB7i5r+vZw+FjuaRyGPSuFq3ugnNCXuU8A2oHaSBW2pCD70mfl37ioj6WPS2Lea/jcXfdpCCPgBKwXt+nJzD57Sl2SMJ/izLasuli7V6KwFPCzRX4EkALYazNSr/B/OGaeMuXxZcGuWHFkwptoKMQtpNTSYLoPy6QSRglYysKLDrrm06NmPQkLY2I2THcKMi+Wk/jvAL78ixsdXeroVqROHgUrQIVuGo9pFqKAI2NxdC9UCI01erTjJR/c90adgxdUn0KzZPPI4gp8/GoInMg6i1qRGpDZJlSkGNDp1ixj2ie+OUe6E8GD98eu7AMvvLnyOoFNeCZbrBsDOiWNlmUqecVWQW531bK29mqUgINs3rKvwFEkqZtRhZnItwdIXirYLxIS1iqVzYmvtA7u8GW3BLgF7k0g33XDJYAvVK/kiXw9ruhvx+USRQVdNspNiMhuMY9mlHnIcj1wo26bjyX1NtGIGFznZjXhV1tfGFWbrA8Pflb9Kl4byP1QYO94GcHbCP0gu9E9+H7s4PiMQsiA0/LZxRQOCfvBx0rCEyQL0dARzG1eexwjaT9e2v60pldprB0l9ary/9sAncwvxR2PiQkMv9pUpbG9swmc1eDEEZ+GTIuPkZyKKsPmhDsw9l5hOc/crbrgAXRX/ElGS0xvHNjH8FuYREr/Z96ckDO
 R8g3lbJx
 K4D2CHvnhwOy43QPHT3YtxIEne3NdjDxRlXXEg8S9/ckNw/+ifprkFBDF7//d+SuOK6R0enTEV4Ol2DGURq0d6r0yaHRarXZNvZtfNOS/bQ7MQdGUyxzFewghhOM1lSiNgTpMG9sGq1I/DGu44U8CXRUYTy0+kAbGe1ADrcWSd2fvJRvkCsAp2qCuRiDsJ2FaTnkXJbtyY5eEzAKVjwYAUDWk/crOvxUT4AB+CCCa1zhYdd00cyter2sTu0eUoOzm0evev290i2f64KJZuLsuqb7dQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 09:51:34 +0300, rppt@kernel.org wrote:

> Hi,
> 
> On Fri, May 15, 2026 at 04:20:43PM +0800, Li Zhe wrote:
> > On 64-bit builds, memmap_init_zone_device() spends most of its time
> > repeating the same struct page initialization for every PFN. Prepare a
> > template page through the existing slow path once, then copy that
> > template into each destination page and fix up the PFN-dependent state
> > afterwards.
> >
> > Keep the optimized path disabled when the page_ref_set tracepoint is
> > active, because the template-copy path bypasses set_page_count() and
> > would otherwise hide the corresponding trace event.
> >
> > Non-64-bit builds continue to use the existing slow path.
> 
> ZONE_DEVICE depends on MEMORY_HOTPLUG and MEMORY_HOTPLUG is only supported
> for 64 bits, so there can't be 32-bit builds for ZONE_DEVICE functionality.

Thanks for the clarification.
Indeed ZONE_DEVICE depends on MEMORY_HOTPLUG which is 64-bit only. I
will refine the description accordingly in v2.

> > Tested in a VM with a 100 GB fsdax namespace device configured with
> > map=dev on Intel Ice Lake server. This test exercises the nd_pmem rebind
> > path (pfns_per_compound == 1).
> >
> > Test procedure:
> > Rebind the nd_pmem driver 30 times and collect the memmap initialization
> > time from the pr_debug() output of memmap_init_zone_device().
> >
> > Base(v7.1-rc3):
> >   First binding: 1486 ms
> >   Average of subsequent rebinds: 273.52 ms
> >
> > With this patch:
> >   First binding: 1421 ms
> >   Average of subsequent rebinds: 246.14 ms
> >
> > This reduces the average rebind time from 273.52 ms to 246.14 ms, or
> > about 10%.
> >
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > ---
> >  mm/mm_init.c | 103 +++++++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 96 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index 5244acb96dbb..4c475c71a9d6 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -1013,7 +1013,7 @@ static inline int zone_device_page_init_refcount(
> >  	}
> >  }
> >
> > -static void __ref generic_init_zone_device_page(struct page *page,
> > +static void __ref generic_init_zone_device_page_slow(struct page *page,
> >  		unsigned long pfn, unsigned long zone_idx, int nid,
> >  		struct dev_pagemap *pgmap)
> >  {
> > @@ -1040,12 +1040,9 @@ static void __ref generic_init_zone_device_page(struct page *page,
> >  		set_page_count(page, 0);
> >  }
> >
> > -static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
> > -					  unsigned long zone_idx, int nid,
> > -					  struct dev_pagemap *pgmap)
> > +static void __ref zone_device_page_init_pageblock(struct page *page,
> > +						  unsigned long pfn)
> 
> Please move splitting _pageblock helper into the first patch, so that the
> first patch would contain all code movement.

Thanks, I will move the _pageblock helper split into the first patch
in v2.

> >  {
> > -	generic_init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
> > -
> >  	/*
> >  	 * Mark the block movable so that blocks are reserved for
> >  	 * movable at startup. This will force kernel allocations
> > @@ -1062,6 +1059,88 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
> >  	}
> >  }
> >
> > +static inline void __init_zone_device_page(struct page *page, unsigned long pfn,
> > +					   unsigned long zone_idx, int nid,
> > +					   struct dev_pagemap *pgmap)
> > +{
> > +	generic_init_zone_device_page_slow(page, pfn, zone_idx, nid, pgmap);
> > +	zone_device_page_init_pageblock(page, pfn);
> > +}
> > +
> > +#if BITS_PER_LONG == 64
> > +static inline bool zone_device_page_init_optimization_enabled(void)
> > +{
> > +	/*
> > +	 * We use template pages and assign page->_refcount via memory copy.
> > +	 * This means the optimized path bypasses set_page_count(), so the
> > +	 * page_ref_set tracepoint cannot observe this initialization.
> > +	 * Skip the optimized path when the tracepoint is enabled.
> > +	 */
> > +	return !page_ref_tracepoint_active(page_ref_set);
> > +}
> > +
> > +static inline void struct_page_layout_check(void)
> > +{
> > +	BUILD_BUG_ON(sizeof(struct page) & (sizeof(u64) - 1));
> 
> Does it have to be a BUILD_BUG()? Can't we fallback to slow path if struct
> page has a weird size?
> Just do the check in zone_device_page_init_optimization_enabled().

Thanks, I'll replace the BUILD_BUG_ON() with a runtime check and fall
back to the slow path accordingly.

> > +}
> > +
> > +static inline void init_template_page(struct page *template,
> > +				      unsigned long pfn,
> > +				      unsigned long zone_idx,
> > +				      int nid,
> > +				      struct dev_pagemap *pgmap)
> 
> The name should include zone_device to avoid confusion with regular pages.

Thanks, I will rename it to include zone_device in v2.

> > +{
> > +	generic_init_zone_device_page_slow(template, pfn, zone_idx, nid, pgmap);
> > +}
> > +
> > +/*
> > + * Initialize parts that differ from the template
> > + */
> > +static inline void generic_init_zone_device_page_finish(struct page *page,
> > +							unsigned long pfn)
> > +{
> > +#ifdef SECTION_IN_PAGE_FLAGS
> > +	set_page_section(page, pfn_to_section_nr(pfn));
> 
> Can we add a stub for set_page_address() for !SECTION_IN_PAGE_FLAGS case
> and drop the #ifdef here and in set_page_links()?

Thanks, I will add the stub and remove the #ifdef in the next version.

> > +#endif
> > +#ifdef WANT_PAGE_VIRTUAL
> > +	if (!is_highmem_idx(ZONE_DEVICE))
> > +		set_page_address(page, __va(pfn << PAGE_SHIFT));
> 
> set_page_address() is a not when WANT_PAGE_VIRTUAL, you can drop the ifdef.

Upon checking the implementation, set_page_address() also has another
implementation for HASHED_PAGE_VIRTUAL

Following the style of __init_single_page(), we only want to call
set_page_address() under WANT_PAGE_VIRTUAL for ZONE_DEVICE initialization,
so would it be acceptable to keep the #ifdef guard here?

> > +#endif
> > +}
> > +
> > +static void init_zone_device_page_from_template(struct page *page,
> > +		unsigned long pfn, const struct page *template)
> 
> zone_device_page_init_from_template() please.

Thanks, I will rename it to zone_device_page_init_from_template in v2.

Thanks,
Zhe

