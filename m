Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAA09C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56BFC6B00D4; Mon, 13 Jul 2026 12:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 540626B00D7; Mon, 13 Jul 2026 12:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3446A6B00D5; Mon, 13 Jul 2026 12:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA62B6B00D5
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:21:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2F1071C1E65
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:06:12 +0000 (UTC)
X-FDA: 84984230184.01.CED7A8A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf29.hostedemail.com (Postfix) with ESMTP id 61372120010
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:06:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AiywCJca;
	spf=pass (imf29.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783958770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q5XgwUfgiF7LwE8owY8mO0mCTERwkR2DB0VxeaQwYdg=;
	b=H6v/rt6UbcYZX0PLhgjU4BbVkvh26nz5dfi07DMZl8BRBXBnsbjIqNhiC8BlcsPTmjFrLw
	8fJqx//eGzvga56EkxpzPNLK0u0+o7hzxA4Rc6+iDXsnUdztYsBjnSU4bxcpL8/LncZQH8
	wPfJkp9D8bsuXsY2QBZ36Kuh9+YN0hQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AiywCJca;
	spf=pass (imf29.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783958770;
	b=v774FBUD4JfQcUk8ntfEDmaxzpHKg5bMkjvU5sfPib65YG4ka+lPBo/0sB2/iYotC5x1RA
	Af1pgfRvoyzE7hxOPXSpstKQhme8btFvLSOiJsgSTzP6pVI7s9J6bcc28erNj1iWraVptF
	aMHSS6ys9yaaH4XJFAjK7sOnTfM+n8o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783958769; x=1815494769;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yEMTKovakq9/9otdcLu2gUK0Lo+WFx21FZWFEZv0NLI=;
  b=AiywCJca8dyLHSs2IyFre2PPCN24vikcD+v8/CDmbuLdJbCRQTr7JMZP
   9xtdt7mg3evNBS1uCk7hTCQj1wNeKeJ08YRiUT9W1kLDIKTvFrtqgfwYc
   +mXXXONYfwzosLW7DSlL6B2HULTqF76w+dlPctVPuXE2T5sPzK8tFZuKB
   cx77APQTHaPsf8HMcr1E5sDuvlrkYIN6cpWvFMzFYwdWIgz1ur2fFmVvl
   aLaci7cJSvhb18r8i5IWiYbAPAQQiYb3gILWMkPaKLrg/NjSchaXRi3c0
   Lgsekwd6h0QR0IM3LcFXvXPXVu0YLzAfYI3MlqM3uObmfbx0ndlE56Km/
   g==;
X-CSE-ConnectionGUID: lEy+blClQHOi+/zvc/ovfA==
X-CSE-MsgGUID: qkWl/MH3QBGQrwyKO1u0TQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="95940375"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="95940375"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 09:06:07 -0700
X-CSE-ConnectionGUID: uL4GLOADQ5W80FRjNXjJdQ==
X-CSE-MsgGUID: hTCneDZVRYCkIsbNqa53jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="252965456"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.88])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 09:06:05 -0700
Date: Mon, 13 Jul 2026 19:06:03 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
	usama.arif@linux.dev, hughd@google.com, ryan.roberts@arm.com,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
Message-ID: <alUM69tP-Zayp1Jk@ashevche-desk.local>
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <alHNjbiWFYXSPZtY@casper.infradead.org>
 <5ee8783e-4deb-48fc-a4c4-96b02d79a6cb@arm.com>
 <e0421ba6-82a5-4c88-b5db-23231c265142@kernel.org>
 <alTN0i6XgnI_eDoh@ashevche-desk.local>
 <alTbSRXXqNFPl59U@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alTbSRXXqNFPl59U@casper.infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 61372120010
X-Stat-Signature: 3ajghtpcuyespymm84mw9ieoahmunyx3
X-HE-Tag: 1783958769-573784
X-HE-Meta: U2FsdGVkX19k+0lP3MjgIWDAdHWSiW/tl6Kw9qNUENAwbvHeRfbiC+g80vYSTzv0UQxs/M8gH3WLj8jdUwumxCZybkS7fkgwnsgUCdzTp43TfSl9CALkNXSemkIJ3NOv3uFbWbpVJQp5mgXlr1s4FpeFklfUM8Ul8UzMZSQDcc0cmuQHaxXHhm2JvS3Za2CQ0KyMBuURd2FQzrB2aUVWZREt5MDxqO1Ri490LKalG7SXftTQ8Qr4qm5ebWAmhCw8HUurYAOVzRIxzsYPRZ4oIAJ2T8pRbM9fxpETwCsWe8WULzGs/EzVWGB82j4CzpaZWGO69DVQG9VzNusVxzqhQwN3BtjVi72Yr/lju1f3w9b7HxJGT0ypTZJ4M67PSN77dDC4JUMfdr+AOL61ZtoUOCAJJLekoauXQoLRoUOD4wOD8IfLYf+oygfqBl/IIAnoH96jnzsRONusNS1DubScxs2+drvIkRBCHaJJSC72JuLofnb0Nu0EreOG6oOWEp8KWD5c5zDbMFuMd5wqeUylaO9eGZZtkK/VfsjuRaRHOAGf6P2DEHuYQd3HfS21IFg+mbs+H/7Mvt0SzqIDfzCQvT/iugIOE8vhZtKyAhye6mMWFAlDpmYnSF9NXw/NwEF25je96/qAEKTKqfesJvr2UI8rh1eim2c5fOh5WjcexlYiWy6j4L4lEv/EUObx+0Z1yOwv1eY7xC2GIyf4dkD+QlhMaVBhuBto1Mt9LbdWHmS88UwnjjUSEiFXKRzY1IQf4MUGrIzzBKb0Lm09PxNZBox4CI3RxrtHbAPsqVe+ZXyU0AMtbClBLh2e+V2vxzuh1jrfxMXN0D2War0uyJsf8iY2/K8nWnrQIkduosqv8Pgz3Oj9iLZUTeMAAMMqLSXWaCpQG9t0DQfX30K74QurREUwWwsJ0zXDpdtN7ls4W6FgWscPiwae7yyTqVFC4xQVyTalD0iCbQa5C/vvnrA
 7iguQhFc
 xiYxAIfUjEGMrUkUHbYUf9OtDLVZq1hqwYvYxTzO4lbnTJydmtbkTrRCDYmhHdz/YUlgOmnI/vZY6S8ZR/qUcxws9i8xqW2L4j/C+Q8VItTb10XCVbEzyNBzaSOF6PRw2qKSzD+JV1Sq614RUAdEK6/15ftnJ1ybBaHrHICcERT/HUJS+zJeaQsHSmGx6z9cq+OR1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 01:34:17PM +0100, Matthew Wilcox wrote:
> On Mon, Jul 13, 2026 at 02:36:50PM +0300, Andy Shevchenko wrote:
> > FWIW, we have hex_dump_to_buffer() for that already.
> 
> ... which doesn't eliminate the problem of allocating buffers in the
> caller.

Right, for this we need to integrate hex_dump_to_buffer() into %ph.

-- 
With Best Regards,
Andy Shevchenko



