Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 935BAFEEF2D
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 14:42:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECD666B009B; Tue,  7 Apr 2026 10:42:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E56EC6B009D; Tue,  7 Apr 2026 10:42:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1EB06B009E; Tue,  7 Apr 2026 10:42:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB5976B009B
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:42:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 631B7140859
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:42:39 +0000 (UTC)
X-FDA: 84632026038.24.90E5C21
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf29.hostedemail.com (Postfix) with ESMTP id 75C4112000E
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:42:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hzXIyjkg;
	spf=pass (imf29.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775572957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EujatEDCEJRw1gkJP93YyiWu3J+Jd69SCG7dft/631o=;
	b=JOjDR6ayrsvkLndu8np4ddFezy50NNO817Rigq0gN7EtBFIgba1Od2DVW9FzEw1nUdrx5b
	pYLl2OidDfMD6rMqyHU/n7yqhO/9ChnoSlXyU5RkMlKEVzYvzvJUjrfmQawtb7HE36IZyD
	Y2S74boXwM02sJrnM2xdFlcJZDI+XZo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hzXIyjkg;
	spf=pass (imf29.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775572957; a=rsa-sha256;
	cv=none;
	b=NtmJxTnR/7Y9AVdZjXnUDsGjHZ6Lw+4dD66/HLO4myVW0hGftszgRN3ueY8le0T96cztiw
	wHgssXCBuEKKKbLy7qzYkjy++QX0YF48E/uUPFrIMuJmG0uEiTnwBNPU0NxbLhgZPl/QiR
	a+d7m15qV7tLuznMJTr2WNBWUqvup+4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775572956; x=1807108956;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZKeT3EG9f0w3T6fK4Zy6iKjyI/8l3jfApv9fdEeLazk=;
  b=hzXIyjkg+2RYhkSiwKa7XJgUMqYWfXdKN5Az8/mw1RmT9CYuW7N9usTE
   inoB0y+OMwRvx2mhP7PU3JCHenBaTL2eO7Bj5WzcSc152UHmYfo3CW65X
   V53iq9gI7/65xrrc1uP/gVfg5/AqRygbnom4ypRB0RogdG6c9YtLHv54B
   PMi+NURPd14eNjeWCgD+NoUcI9zv9U/wsibKs23WjWNVzIQvFAFiLbu2c
   RJdvOXICIo/e5nWiTLPrk+ULUBhE1NUSXiBwyAVXmNcgzrg1PQCXuSYs/
   cy+3rrEvmxHv6S5da1anLRE/SmFuq9Bak9/96z0GbDIl5yxMH9fjz6Kye
   g==;
X-CSE-ConnectionGUID: oT1xtiCdTS2XO4a12qSXPA==
X-CSE-MsgGUID: vS2O18O4Raeu7kU5ZIVn/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="75577463"
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="75577463"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 07:42:35 -0700
X-CSE-ConnectionGUID: X9UQn79SSZu5MuDyveNRdA==
X-CSE-MsgGUID: PyT17ImUSAak2sMkKm4OdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="228119455"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.108.118]) ([10.125.108.118])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 07:42:35 -0700
Message-ID: <98880cc2-09be-4bd8-b8f4-f0f0845f939e@intel.com>
Date: Tue, 7 Apr 2026 07:42:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: proc: document ProtectionKey in smaps
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yury Khrustalev <yury.khrustalev@arm.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260407125133.564182-1-kevin.brodsky@arm.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260407125133.564182-1-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 75C4112000E
X-Stat-Signature: ebuet59uxf6uwy51y38hkoku9i1y9gup
X-Rspamd-Server: rspam06
X-HE-Tag: 1775572956-573349
X-HE-Meta: U2FsdGVkX1/kvidtGEC7kWjFRyQeIBXdK8t8H5KUy1qQzy5hQ57tDFQLwhPgn3qRIutMZ63hl/CxLIq/TCkVYdvAgxkX8G2PIp+bUoL52/roQqtBEhC191FAY7fYAzJqszoA4NIDTsEZ1ptV8FdHFMAqlr3NgAbb6LDKFzRdd88BfPt0NjHerepguGIXv2FzQ8E+vfnVYJWvF2SSB4pka5ki+xzTyHoiLE+DzHWyfSbgPyUzn3Gtqze9kIk0Y1L/Gw2Z8Njnw6DS3vftPngbO5O5urOT0GtJwNIvQx2WBLXwz7onouGFmXcmeFfqWakgdeaNM/bw+fNV/tLxY/vhl+P7JEaOxg7vnkEFRSoNGq3tttaOy2gyPl3C9dVLdEGgvwA6tv0KCXhARbPO+Wp5fXkZYST0ZPXqDaD7KjQRkBvKSc7r6XZnxu+5L2T+8ww840/lY4Ceut6ZVircsAZ1bKsfH4c+9V1pz0z6hSncqgNdslLxmaUhri0KfGbEJwB8BFVIr1GNI5TCUsHWQRx1ut5kCvuEX72CuO6FaGNU8vxoaMBQOA9FFoFuppMR+rgGv1kc5OM3iP+0rcWzinZD3uC43IKwuLdjcrC1etyVkONKrGjkCuSKcNmd7bsv01pg1FW7p9RWTmrpRCNyJG/I1/o8Hi0s+leK7us55p2xAyfCSTOXFMyg/IZ0sjx06QpXfDoHzqVU3kIUhkxLrl+sey9cjgKwqZlboeLk6Uxh2ddmnnMj9DEl5fdo3jCe2gNPDjCv7FbV8n5K+S2scx9a2zwtUL6Bf2yhsUiRYwbITMbvOK6vwTTbIMtR1tYIs5zwEwFwafCIW+zNHIClmURDTgIdkmRnmTDa6tDOWusNIDxVSzJvwT4q20Sglm6xIpFmWSJU9Q43zWm+KCqL9z0k0WBueRb8ZzfKJw9kmKw20ifsX0P36udgw9LDw1N6HBS5wbwJsXtVduNGGWDUu+m
 XcihfuxX
 EBanzdROSiUozS5wI5vTam9+9F2m6orMuA4lL8znSYCKf4kKhuZT9e96CW/yZcq60vy1/1tym+NUJTVv9q0D/Ee76GTN75XKxPd2vCiE/p+CVg/XugyCdq5ZRRhUrKqBoa6MXLn23/HTjqKJ5R5H6r6YIevsMw5cUSlQ3pBS2M9Q5M6SZNzxpmjnXvqEidx8TWmprDpHFwZCVh5spIjLOi2exWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/7/26 05:51, Kevin Brodsky wrote:
> +If both the kernel and the system support protection keys (pkeys),
> +"ProtectionKey" indicates the memory protection key associated with the
> +virtual memory area.

I think you're trying to get across the point here that the kernel needs
to know about protection keys, have it enabled, and be running on a CPU
with pkey support.

To me "system" is a bit ambiguous here but _can_ refer to the whole
hardware/software system as a whole. To avoid redundancy, I'd say either:

	If both the kernel and the processor support protection keys...

or

	If the system supports protection keys...

But I'm ok with what you have in any case. Folks will understand what
you're saying:

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>

