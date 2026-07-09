Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90C6AC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 10:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C7246B0088; Thu,  9 Jul 2026 06:43:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 778236B008A; Thu,  9 Jul 2026 06:43:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E166B008C; Thu,  9 Jul 2026 06:43:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 490866B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:43:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9DB731A0470
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:43:26 +0000 (UTC)
X-FDA: 84968901612.13.6C27F46
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf05.hostedemail.com (Postfix) with ESMTP id A7A4E100004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:43:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=H37oZXe4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783593804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ty3/D0G4b2e+KmJEySti4uf0ShmQy+c+8Sngom0io9c=;
	b=YiTkFiWvWHXqlW6B7MAXam+FMch0JcD1j9d6auQ+E1R54hipMpaHVun26KmXfUPzzMRXNa
	a1gZipbPVt9mPdbBv0CKItaRPIuqyAWVQV757tbNWnrco4LY4uFY36ewzpMrSCu6Waw7/o
	glPnkTitE+J0T4mWx/7HZWYdLInC3ZY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=H37oZXe4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783593804;
	b=4jwrlV2Z+R1yJ12lsUivtO3MaoWFxqySacw2udpMgz3ubyVEJkRYYX5uoV38rDORCiqk3P
	I/SVhLNmZg1t1/5ec7C3PAM8x7X4L8jdNAYtwakMthvR94wnbz/P3klPwVL0g5umgufLfj
	fm2kLdgHZUkRdlT9vfO+lKz/X6M3nOs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783593804; x=1815129804;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mqCjFT98lyntQtuLHJA1DbTT0KIDY+LcRiiRyh8xCHw=;
  b=H37oZXe41illKl0SV34E7Qnp4fdKcvx5hl23ETtsxL6PD2i4Vzey9RyY
   kQrt8oJdfZpcTDRhl91SCz6gnYKzcOcp4LU+U91/akCtb3DkBJcW+ehGw
   LuDEKvZaQA42NtSm9T+E5kMO0e5FWUAI2EfRV7QwyISdb3IL5TlI2/LR1
   Q2wqxbs10GvAEzZFASqq0YhmP9SvSGQBoSAaicobbJXheJGKBSb7zizN7
   hDlXflwfMN/CJ3pX1DX8znT78xUsCm/hpaebtVGcfUagq8LSkqPBAgOEw
   2u1Y1RnvbkkX6ZouzQdgmvKrDbeGZwID/EGzIF3xy4CU6jSi2KyKXtGPJ
   A==;
X-CSE-ConnectionGUID: jrhcKs9ORw+b8hYt4NTPMw==
X-CSE-MsgGUID: DiODr1mLSeuBdoct0YND2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="95643104"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="95643104"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 03:43:22 -0700
X-CSE-ConnectionGUID: KCjKhrLsTWOM5utjz4jMcg==
X-CSE-MsgGUID: Ww5JuRfCS/WP0cX9CwvoYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="259449554"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.235])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 03:43:20 -0700
Date: Thu, 9 Jul 2026 13:43:18 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
	usama.arif@linux.dev, hughd@google.com, willy@infradead.org,
	ryan.roberts@arm.com, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
Message-ID: <ak97RtqgNMV4O-D6@ashevche-desk.local>
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <ak9Qe1G7Rv3HF6ZR@ashevche-desk.local>
 <ak9mrw37kTORZXmc@pathway.suse.cz>
 <ak9z3ZRdRqGoOu-T@ashevche-desk.local>
 <ak90WW3I4tmg7Pwz@ashevche-desk.local>
 <a23c0ace-b52c-4f28-9f40-d0b6dc4ca2d3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a23c0ace-b52c-4f28-9f40-d0b6dc4ca2d3@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A7A4E100004
X-Stat-Signature: uzshweyn7posmh3497rohkaos96bre8q
X-Rspam-User: 
X-HE-Tag: 1783593803-225825
X-HE-Meta: U2FsdGVkX1948R4exvUgSEAdRgnLT5nRaEow6uGNZx9sY69QI7/gfjBLJxAmhS7zxTh1IiNh2TG87Ysiwx68/9k4UH1T5oLfU2lMxUW8j/0gk1fLhxe0Rfkyhp0Qu+K21a6CG6Z0L/Ni6VWZL5E60gVYY8PhRSEt4CS7DCpw0jaG5P+TpvPTAnLKKZR8bPCTII5g3lmYqFswhrPFBVi9NRF8k5eerZFar2usP6D9q19GsaEODrIMoe9DQBFrIeGl93r/qL6JWndzIgxenNrr4j8pKo619n/gIye+P8lX03TFank3Gy8vJRL8f5rYlzl1LZnKN26mi8rxTzM6AZ2YYBST2M/WO6ZjiJOT9T+SbjsNH6eTEZ8wLjg/kWb+C3B4ZNuFoMXJVL3KeFvAinL2YrpQXA8vUT9J+eaMwHsQE7YOZq3PBDDbwAFXX/zZNtHt3qYenLcvbSZxpI8QzulXO2+eeDva/+GRo45hxopmoBH92lA2f9cSA2zW2H3CZH4H6UwyYiYPixjszLQ8CBYV0rURrEop8RpVtyG6Pbf2eo1ex4VCCPVn7gE8invJSumNuYa6O6FlEyXUjSn50x/8Qr+Pkl1GZad/x2nTUf4Ip8HttAaG//G39S6WnyS7oUE9orDM+4T3xOaSSECbV0auM6SyPdXOMjb36L/pn+v4mxsyRt8EiHZPLqw5FrbVuW7rFOGExSpNb5JMXRSAwAEnufl3JxHlfYSoZtz/0NpQl/gwatb/JHnEXvIzUCvJ5Pvt1j7UfpGEFfdli3yj48UIBhPDpJjQYfFw9lrOMl3mRTwU/771Jf10GwB+9tLgks+sq/VDAAX2l/Qxl4Z9cX+zWUX3UEK+IvqHkxGGIqDdwx1+vJWOID+uQTNZ77ap8I90SgO46D1KbrwdcNRFtgRo4o1Fa4/Cx3NogCNSEhweBpZogvuj9CNnBieRCJGUgokEqP/Kq/zu3mu//P94Og/
 kHReXGu3
 yBmmkcFFno632czgrkHabzHELjUsXcCJNIN+7CwMu9GhR0/IljgPHRI4r5Cu+SVJVUTLYw3CYbHLXZJl4737ywTpzD0R6Fwn90e9uroLrQXRzXfmIhyPORuKMqfsGOc4kzAB9mlXnoIYKOg62/IhEJWZzdKjwaHKjEMibZjDADYDKB5PTxsIWHaSqTHddC9lYtaKc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 12:24:08PM +0200, David Hildenbrand (Arm) wrote:
> On 7/9/26 12:13, Andy Shevchenko wrote:
> > On Thu, Jul 09, 2026 at 01:11:46PM +0300, Andy Shevchenko wrote:
> >> On Thu, Jul 09, 2026 at 11:15:27AM +0200, Petr Mladek wrote:

...

> >>> But maybe you had something particular in mind.
> >>
> >> Yes, I was thinking of a wrapper on top of special_hex_number(). It takes size
> >> as an argument and hence will work even for 128-bit cases.
> > 
> > Okay, the argument is limited to 64-bit in there. But I don't think it's a big
> > impediment.
> 
> Rewrite number() / create a new 128bit variants to avoid 3 simple snprintf()
> statements? :)
> 
> Hm ...

Since it's slowly spreading (I mean 128-bit types), I think sooner or later we
would do it anyway. For now we can just have a wrapper on top of number()
(yes, special_hex_number() probably too special for this case) to print it.
And yes, avoiding sprintf() in this case seems beneficial to me, we will have
one implementation of how we print pointers.

-- 
With Best Regards,
Andy Shevchenko



