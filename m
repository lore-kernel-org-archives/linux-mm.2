Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 160B2C5AC67
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 00:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3C1F6B007B; Thu,  6 Aug 2026 20:56:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C5D76B0088; Thu,  6 Aug 2026 20:56:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866B26B008A; Thu,  6 Aug 2026 20:56:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 49F016B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:56:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B798AA02B4
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:56:47 +0000 (UTC)
X-FDA: 85072658454.15.46710D2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf28.hostedemail.com (Postfix) with ESMTP id EAD4DC0005
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:56:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Qhn7L6um;
	spf=pass (imf28.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786064205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cFaQFmQKBg6ASUeFA5iPFkDy6Gqt+BNir+tEhwk+l4k=;
	b=Z2n2YriENUlO3QNqvedtdN1uDl5Ib3SBSwD30VStwinVIEbkKAkiR9GEl7ut21aOm4NxLP
	TrcJksntRLEGzTqNLe40IgeOveUs455AwWEXew4K+sdguzGhuAGRk+xFhyTM6hePzGsAIr
	7VgEUfeV0HVWGJBoNsUHANVwqZHzS/Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786064205;
	b=WjmezS/cTov8via9c9+YGdm4/5zWOi7v95egmoY6hkRMoj+btjfMIxb2cRYYPUT9LNd44W
	XSW8VfwcGMVUiWLzhciL+u8MNoCxfpuhI0XTNmAGvvSs/zM4/vdWDbpFrBV4wRts7U1QKU
	J086E4imAgmo+yQ5QyJZ2p0KWsN5Q2E=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Qhn7L6um;
	spf=pass (imf28.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786064205; x=1817600205;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xaqEawUcKzqcXHKZwNsMONvFjoxesrE/pbHOtm3vIQI=;
  b=Qhn7L6umkL0AW3/X2pGEecWfXAMOWcDNqLBbXvSiwS12wN+SCpa/oOAM
   WZjaSFHKPufmopI4md77QM+KZT3JBwD2dk4BCKZO2+aMaE9VCwFpdGsNN
   7GKdWL/xP90AnKaYdU59Ar/7VzZmkFcBCLkmezVGtPTflFobyHhQi7yzX
   DO4OqFLsTZXJxKelt5I8hS+Y9ulKtWL+pDrYcCoXB0DhBiW3zAsNeMPY5
   6hW5NMSIC5/bcybsc3VBp105yn4DuAJTJ8oFcM3ilj4VTpInWhb5VmXzF
   LvSJSFOu2bWLKVMCul7OrBteACBptOv4llC8LsGJns0KGDJsYuJntwJn0
   w==;
X-CSE-ConnectionGUID: BY8fbyPRTm2MdbsLff6Mhg==
X-CSE-MsgGUID: LnJ13JlXT/qgOcebqNrz4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11867"; a="104204169"
X-IronPort-AV: E=Sophos;i="6.25,209,1779174000"; 
   d="scan'208";a="104204169"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2026 17:56:43 -0700
X-CSE-ConnectionGUID: 5WDPTH/PQKq7JVutMVnZiQ==
X-CSE-MsgGUID: GAiCsshUS6uEexCdJ2ouSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,209,1779174000"; 
   d="scan'208";a="262316399"
Received: from ettammin-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.50])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2026 17:56:41 -0700
Date: Fri, 7 Aug 2026 03:56:38 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
	usama.arif@linux.dev, hughd@google.com, ryan.roberts@arm.com,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
Message-ID: <anUtRinHGQyqtXJo@ashevche-desk.local>
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <alHNjbiWFYXSPZtY@casper.infradead.org>
 <5ee8783e-4deb-48fc-a4c4-96b02d79a6cb@arm.com>
 <e0421ba6-82a5-4c88-b5db-23231c265142@kernel.org>
 <alTN0i6XgnI_eDoh@ashevche-desk.local>
 <alTbSRXXqNFPl59U@casper.infradead.org>
 <alUM69tP-Zayp1Jk@ashevche-desk.local>
 <bccce409-e105-4a7a-b962-35905dc1ff38@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bccce409-e105-4a7a-b962-35905dc1ff38@arm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Queue-Id: EAD4DC0005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 4b8qps66ucxe7yj5w6wsxgh89568rc1i
X-HE-Tag: 1786064204-841639
X-HE-Meta: U2FsdGVkX1+/MyxNTsWPup6zx0VFk919S3gANzIaxnHUy6BfvDv3wOJ8RPNbSyTw1bhgN9LjtK1XKv3ZPKo/zcFGfhd2baVoSyaR5c58TivuHjlLzxxuVar+YstwW9RgjzFsFUHqWHe7hRw6+blcpkiwKtMvau8k79Ae+5A6oHpfF0xNfrcKfG16nz+2TR+kzTk42E5FDeq663ay30J2P0ljEO3eP9fvbfYe2ustM8ddVzoeImu9W48L3SpxyeWgHATXkdHE71Hv0fGp15Yjv1qH7FblR7SbzpRYHxd9AbDb/ADpBmMrS9Q7NoYdBWQxrvACF5tJS595/+aqyO/QgJGxtMy19Fv1WoblFr/v2QPIZt/mho0dpnMCCo+xrJuu4LJijgXeOCVYachDZIS+zD7g7VXlVagXl+v6l+RyI8fdKhLCNsmwrLEnJvH4Xyrofoq225eDtM3VouuAComWVKulb/y/UHWSFlahWS9gENShuQUl/GCokXkIWiW2KI8eB9bzq8Ts8lcEA1LMnHV4g69xLmplRmvK+vgoLxPsL3URPyFCNs0+JJuqGysrNR3swboS9EITtmrIUUVn+9PFoP+iSKZDeKprAfPcdYUVuCMrfHTt1lsLlVd5OngO7LUvgK8nDt4llcqseF27iiDNeLPEhl50f8SBTfZjgsLCQxrvczvqO4+X2zLkfMkxc3ovV3pB4PkQNKR4bCTqAjoNeLayrAM4HZCzIyivUiRC/owAeo1hiIUwg9WfcpyeRinzNFolIbCSWOnis7x6EzkolqXezcO5mvW/jRLjd1mlCxo783PgWl5A6bhsaxtXrTmvCokJMX3TVr5Z9cahvKkkFx7XN10HTGoCRYgWeFNF6y2HWwm8eF+Umq8PoHTY2GGzC8C67wXg5fR3mXHT65uUMOOlyLUjbvVRQnrxvhmu+qOSihVkxk6XxVLyh2wPGt2RdSGfstdMCenaEJ1CJJs
 Am8p0CAU
 3Qv+29+0nYnV7Fy5wP7MUsoPxIW0+Mb52xeAwP88xPCKabs0prebQRqI489TM8ZGKj8+NmwoTKCNFyeCJ9gI+rRaIfy15RYfK6D/jxLUghcFLe8cmq9rh9X1mG78sEnKomzXFkWPhSUn8KSMi2H1ypo1ZGdMh7TXWH0+8HkY0RsCACxElJsYfJz6MlTIxGkroYcEXV5istNU6KXL51oHDftDtT6IhAjgcJTTGcCARZr1P9QWXIsY47rX3rrsHo9qgM4dHPcFYu++N7tuIPd9KGpTwTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 06:20:39PM +0530, Anshuman Khandual wrote:
> On 13/07/26 9:36 PM, Andy Shevchenko wrote:
> > On Mon, Jul 13, 2026 at 01:34:17PM +0100, Matthew Wilcox wrote:
> >> On Mon, Jul 13, 2026 at 02:36:50PM +0300, Andy Shevchenko wrote:

...

> >>> FWIW, we have hex_dump_to_buffer() for that already.

> >> ... which doesn't eliminate the problem of allocating buffers in the
> >> caller.
> > 
> > Right, for this we need to integrate hex_dump_to_buffer() into %ph.
> 
> Would not that create more complexity which might not really
> be required here for simple pgtable entry print solution that
> would probably have very limited number of callers anyway. Is
> not that reason - we did not go for the original printk format
> proposed earlier.
> 
> https://lore.kernel.org/all/20260610043545.3725735-1-anshuman.khandual@arm.com/
> 
> IMHO this should be left unchanged. Later if there are more
> users for such prints, those printk formats should again be
> evaluated.

My comment was only to show the possible option to solve what Matthew pointed
out without relation to any exact usage. Yes, for this certain change this might
be an overkill.

-- 
With Best Regards,
Andy Shevchenko



