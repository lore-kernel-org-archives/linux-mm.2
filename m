Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24139C43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D41A6B0005; Wed,  8 Jul 2026 07:17:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9F96B0092; Wed,  8 Jul 2026 07:17:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9B16B00B5; Wed,  8 Jul 2026 07:17:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC06E6B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:17:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 626D04074E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:17:31 +0000 (UTC)
X-FDA: 84965358702.16.DE5BE5B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf05.hostedemail.com (Postfix) with ESMTP id 799E610000B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:17:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Xp+nu7ny;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783509449;
	b=xtS2FL6YcEpYncTy2CBs1nPGdKiJMhTBCvnScW/VAllYxDSMPFuuqnnFDt0b+SxOPCjQdE
	AXsEsrWKfK4EwRKsovcELJbJeTbbp1eGCtuuKXYJk7iqkMlazlltPQMMDzuc4omMzKepJz
	O+10Y4VY1zrrWBNF7zLk9nYsOLIrpnM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Xp+nu7ny;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783509449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ln+nTIzlrpQQ+GOWArxr9Ry/rda/mUKsqoMKokC8zAw=;
	b=wErE7lwd7DUvm+7q/uwasNeC9yxRKClj4WR1xrYm0wysHQ8cQbKf9uPAs1l9y300pe4dFD
	f8K0uRl3AKaMM7e72oigdV/pM6bbhdUTGy4d4uJOD3h2pbRKjdydOhMpZTtCJyp5emBsyY
	59oQHfeuix53TyK2tpNgHcY7MkSGleY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783509448; x=1815045448;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1SUytAJQxBuqeggCAq5+Uh8RFQaVx7WpBu6U6QPTItc=;
  b=Xp+nu7nym3mWixmloy5r17JfQb7TnnAdFPaUI1a+Ad6cSzAUe2kb9B9p
   ZlL0Hz89ViJ0hb5565GpNiVSinOZ4I0Ik/QmaT1/k9BO8UrlUJE3lmBHr
   xivrnFEJ/7US5ODa/Tctnvo8temgMHj4fZaCpNAQcW7kbb2TUFFnU4aZm
   /J6y3ysNNDDQSzz0Z/2FlhHFUtDvcFbCC96JkrlVZ9LxsEQypQ44by4Rd
   cZMKNLyy0DaV2WpTk8WV9ZqwJna37mvCgab9JmN0JNJpuu4ZJbx2mZ4X+
   +d/2sqdjaYDg5TDbmtdB9kzFuhDEe4faxbovjmDoCzBJmEEKlzUZU4Jez
   g==;
X-CSE-ConnectionGUID: /16/B4bvRtSZOL6EzPEmvA==
X-CSE-MsgGUID: mSkFKozaSIml4L20m/cpgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11840"; a="71689774"
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="71689774"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2026 04:17:27 -0700
X-CSE-ConnectionGUID: pAVKBk2bQyW7uUlD8uVmdQ==
X-CSE-MsgGUID: +grBGXWSQaq8zO4daOCWCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="259165387"
Received: from klitkey1-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.100])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2026 04:17:25 -0700
Date: Wed, 8 Jul 2026 14:17:23 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, usama.arif@linux.dev, hughd@google.com,
	willy@infradead.org, ryan.roberts@arm.com,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] mm: Standardize printing for pgtable entries
Message-ID: <ak4xw2JwyZk3uTPI@ashevche-desk.local>
References: <20260708032824.969752-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708032824.969752-1-anshuman.khandual@arm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Queue-Id: 799E610000B
X-Rspam-User: 
X-Stat-Signature: woubw1tpnm7mw3u8h853itfm47zwodg4
X-Rspamd-Server: rspam03
X-HE-Tag: 1783509448-478547
X-HE-Meta: U2FsdGVkX19YWVW0EwxcEiCdAj06PUwZ/TXFG6WJhxsUf1gGSns8AGqp+awzv+e1RjUiawHZszTE4diJYfBaG3OIeTrfmlnBy5m+hVMP4ODr0eMbecDNdwQela4l8exVo3TZnPpA74OgHS70rexzp/yISgqNMs0xZRSaOEoKbCkPkoRjLxqHvnrWK7fd9jT0vJpHWbF1mY0xrvvu+jfhhOOLV0nfQJKdwcJ8h3amzkcSh/GFkoAVOJbZw9qkeudXF4INZUw2dJ2uQMpkU8KKacCzQR8/ST+xbK6eQKNmeMumlQkPqxosUoVt+KnVzte2yOQivemT/0ehKS2pZVBQlrDbQaR9SXHvqOCIX04gY7JDxH9l0DxxiB9K3vDHHJjR9b/N+6QLAxSMfKrJE3W5oRkSrCbxv+D3ZopdBLfKb94NptidHXoIQlKnKQcjzQZ34mbr4Y9TI2n50Bex34oU4E6EEq6gSUlb8Zi/ng/A0QvE9Ic26kLxnl2XH3CK7BVnHeXNzGIHqXnag5U8f45GXt9b9LSkBi/3Isb7Ct/u44n/QADZicJ8L2X8BrazHlOKgfKzlm3Q6WmnbtGmWwyUDtZclpSgEwhlZO0k+4p0FbnQ5teb+nYuWZbYlDqCnVjGbljnIntZisBtjUhaf5WCRldFmGAXCb6qn0olEC8VzuCZ1ZzWLDvs9VV3Bp0VaRI84iDFyxiCel1i0PLYBK3DuCO3L4MtuNa+7582qs9Yh+7UuqAOBFDeI3cQMd8JvpM4197xLrSUOinGF8B7JX1vYYzfru7B/o4t/Y699Gi2ydSYM467tT0OA8d2Y1uD56FIzZGZgAdyS+M1dpYKopQZrTzrtfkufbKKoQlz9INErTE+AaRh9TmzKs3tkXJco9QLV1ysZDnJ/fx3HoXofodqiAX7qlce2ivWv61XkieNiOZKUdqEQECpyx/EDc8zi+Is2yzdFLlo7ILm5i4q5Dp
 oyJ9a3/5
 zyGrUsMHVYyKTrPla4ZiRotdE699ey/bCDHtke7oHkHCfrYsp8U7zR2SGaS7WdWY+BoN9am1dbPOM90cjG/8vRKslNdBkesFjltNkgXb+1vkJSkvKy5S8+ELPzKKOpbuFC3LJlR8otz7TqoCN1pNy0WlpI+gRIIcyjZJJLPL9gpXsGN2VD6DjLaeaYkJwhw9HdSOI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 08:58:23AM +0530, Anshuman Khandual wrote:

> Bad page map reporting currently stores page table entry values in an
> unsigned long long and prints them with fixed 64-bit-oriented format
> strings. This is inconsistent across call sites and does not work well for
> architectures where page table entry values are not naturally represented
> as 64-bit values, such as 32-bit or 128-bit entries.
> 
> Introduce a common helper to convert raw page table entry values into a
> fixed-width hexadecimal string based on the actual entry size. Use it for
> bad page map reporting and for dumping the page table walk in
> __print_bad_page_map_pgtable().
> 
> Pass page table entry values to the reporting path as raw bytes together
> with their size, instead of forcing them through an unsigned long long.
> It keeps the printed output consistent and avoids truncation or misleading
> formatting for non-64-bit page table entries.

Why do you still use __auto_* instead of 'auto'?
Please, see the comment in compiler_types.h about this.

-- 
With Best Regards,
Andy Shevchenko



