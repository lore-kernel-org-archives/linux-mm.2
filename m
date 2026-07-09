Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BAF1C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 11:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 868976B008C; Thu,  9 Jul 2026 07:55:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83F836B0092; Thu,  9 Jul 2026 07:55:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77FE76B0093; Thu,  9 Jul 2026 07:55:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55B4E6B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:55:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E3EA8140131
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:55:01 +0000 (UTC)
X-FDA: 84969082002.13.D5B35A0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf25.hostedemail.com (Postfix) with ESMTP id 11BF2A0004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:54:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j9XRrpmA;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783598099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nS18UXcKOiVS7ZzGg8KeM+2KkR8kRtJ4w3FiYEgW9p8=;
	b=2bZmYqn1J9sWRAvAIOTLcxZd4CLZGb1WBSTwDh0ugO/eSaoKq5AYAKeinsDyZ/9r4zmOav
	tukbDKL1rAY60mGWDq3VSdwXNdLH+dJv0kwCZHHg2VS/pz05DF0oAuuKkJ4gbZtLgIMT2q
	gHFI/C82xama65QHXg+MY6KHnmZsMTs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j9XRrpmA;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783598099;
	b=wCF/vvMz6tDxktfQTCt48g0pSMjTcsiXi85A5wEXnyEP+72XzxmPEp8lGLz09J5y176s4m
	7d+U9ye+W484TYG949LR9fsylUMJyFWuZbR0ju60LAeki2ausinEWr1KAaukYvUsq04ubh
	9LrzmjMWtg7zfVPF8cJoAUNa7OXA0qA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783598100; x=1815134100;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5bsRsa5pptjNQSJi/7ecvl6kZTK9O+Ae+0CnnqVjmU0=;
  b=j9XRrpmA4qh8eAz4ERUSjg1srPpu+9zOjFJ5MX6M0IgFmSXtiGCFySlF
   90HJvixwUR4QZAkbvLpwiPVt9DDnTJ+OL9Lu8l5sjMhaLxDouJsquYkgU
   joiRqJbQtALY/TEx+KOuFA0LtFv8VoEqT5HKupZuWDAqFs5IjEmIxpUDe
   BbAwgQvSf5pXYdwFC9fUTNJ9kKhCqJWG+wfqLycmX+4TkL1dS4Dewcp4h
   OB9DzyHJXdN3nGmM28aQ8si5/psZYEMgfTYrSkJaeuNp30Q7P5RHjQw6F
   ag9X3yQKg/8JCRO1yw5ofTV93E+fPHMhdkuzOk+Y25MXTHeO0td+QRbR2
   w==;
X-CSE-ConnectionGUID: DGvgXRl2QhitvU0PGPNvRQ==
X-CSE-MsgGUID: 6zt4ralMTOaAncKqzXySgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84468260"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84468260"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 04:54:43 -0700
X-CSE-ConnectionGUID: QgWH0aTBSbmRrg4couPFmw==
X-CSE-MsgGUID: IMCYNFYWR4W4LPlx1dFX2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="254684281"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.235])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 04:54:40 -0700
Date: Thu, 9 Jul 2026 14:54:38 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org,
	usama.arif@linux.dev, hughd@google.com, willy@infradead.org,
	ryan.roberts@arm.com, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
Message-ID: <ak-L_ogu1-u3GdUv@ashevche-desk.local>
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <ak9Qe1G7Rv3HF6ZR@ashevche-desk.local>
 <ak9mrw37kTORZXmc@pathway.suse.cz>
 <ak9z3ZRdRqGoOu-T@ashevche-desk.local>
 <ak90WW3I4tmg7Pwz@ashevche-desk.local>
 <a23c0ace-b52c-4f28-9f40-d0b6dc4ca2d3@kernel.org>
 <ak97RtqgNMV4O-D6@ashevche-desk.local>
 <f2b27d81-99cd-411e-8fe6-e9a529f3b68b@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b27d81-99cd-411e-8fe6-e9a529f3b68b@arm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 11BF2A0004
X-Stat-Signature: esxbb1hatyoe7w7nxwimsxuasfiti9i3
X-HE-Tag: 1783598098-466544
X-HE-Meta: U2FsdGVkX19RqxD2ltykI9ek3Iu4RcCza9W9J4+yqk1kFvX9zt1rUSRwRLC4NxxzqVeW+aAuI4oc5xPjW+UwsZb1mOyeDALc/CK045Qr8sVszpI8i6UCQ2viwqIu5RA43qyt+I1MpfuCRzEVQjZ1EJTBr2aEgOeQlxfxu4zbUXLrgiIFyNH80PioonWS90jtvoRkrm/z2TGA4sUfYcFZrQUcC4NEskWv0DnEmGKwFZ8OBrXQ5GNveMsmAB/HAdCLwTWlNF0LpGImvIfmOwPCKwtPgylmciyxhQtSk1Gq2jawgSRcC4FEAb3dpR3y+lGYbZXCcqrCyASKv/yS5LDIAzQd2OoZQ9+LX0X3odLwTwyoClcOZ9ViiaCxCYjdtwa8Z/MoK/tAPNnjVLUJHlKAKj4UGoPI+1gqY0TdNnanzHcMqW2cfcomU0URxPcYRbSQSvS38pX2V8FKF52nlg/aJElXEO+yJ/r3vkdo3VPggWVAWHw3TNth1IP3SWqRx7uvVYVaz+fVzCneh1Kr87Ph1yLqg2R7btrk7tw0s7HUNvQV1y/BT5Dnh5/W+3bhvR0CgXDo3bQ7tjz6L5aDOaShlH0iYvUrq0g1CuRK9OYeRpKWH7QTWkv+5uy+JdKPmGxy3keyClWOXQ5AKlwwhFbhvUw/um55FTP8aQY6zeloNu3g8xQkR3SkikYK9TitDpflG3y09eMOhUR2lrvnsv+PXXKeCDh+xx+yVQ5mfLQejYCLkWwdn9UAKQEE/XAcCJa90HLOGjj728iWyQmRlsM6wq9Rmg9CRiU0y9BCiiFqxlimDtMiUgR7ua8HpyvVJQZASue4X9hfa4m0i09xJEYlLUy9QF4q8J3WmRocjUgeBr0VG6z6YQmJA3v+rAWhbyITaSglzqivGL8gEeO79p7FeKS3ErvnroP2zp+6A95gY1t9iFu+6g7tJQOwX6tKSZNAvoByRhf++xPkwNJEumh
 R4eMDnqN
 cA0O2gmSSxeMbvvoCAM0+LZCvPTfHQtRn3OM0IdOrkxBZL41cX1AOSJ2wAB1NOKHuN4R2ysAcJNSJURb+fzlhBdG10iVW+O5COvXZyo16c0iklRVlrRw+W3uQvThKHbkvTdYsj11yNj7NR20NfFlCeT9l2sA2aIf/9ZJ18ronG8yBa8UxlvTUdA+QB2rNwbLuCDAo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 04:42:30PM +0530, Anshuman Khandual wrote:
> On 09/07/26 4:13 PM, Andy Shevchenko wrote:
> > On Thu, Jul 09, 2026 at 12:24:08PM +0200, David Hildenbrand (Arm) wrote:
> >> On 7/9/26 12:13, Andy Shevchenko wrote:
> >>> On Thu, Jul 09, 2026 at 01:11:46PM +0300, Andy Shevchenko wrote:
> >>>> On Thu, Jul 09, 2026 at 11:15:27AM +0200, Petr Mladek wrote:

...

> >>>>> But maybe you had something particular in mind.
> >>>>
> >>>> Yes, I was thinking of a wrapper on top of special_hex_number(). It takes size
> >>>> as an argument and hence will work even for 128-bit cases.
> >>>
> >>> Okay, the argument is limited to 64-bit in there. But I don't think it's a big
> >>> impediment.
> >>
> >> Rewrite number() / create a new 128bit variants to avoid 3 simple snprintf()
> >> statements? :)
> >>
> >> Hm ...
> > 
> > Since it's slowly spreading (I mean 128-bit types), I think sooner or later we
> > would do it anyway. For now we can just have a wrapper on top of number()
> > (yes, special_hex_number() probably too special for this case) to print it.
> > And yes, avoiding sprintf() in this case seems beneficial to me, we will have
> > one implementation of how we print pointers.
> 
> We followed this approach in a self contained manner inside core
> MM in order to avoid adding new printk format. TBH don't see too
> much value in again trying to create factored common code between
> with lib/vsprintf.c As David mentioned this may not be worth it.

I'm not fighting to death for this, just my observations, so we see
that majority of people agree with leaving this one independent on
lib/vsprintf.c implementation.

-- 
With Best Regards,
Andy Shevchenko



