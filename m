Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB8E4CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 21:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D4426B00A3; Wed, 27 May 2026 17:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 085916B00A4; Wed, 27 May 2026 17:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB67C6B00A5; Wed, 27 May 2026 17:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD7106B00A3
	for <linux-mm@kvack.org>; Wed, 27 May 2026 17:04:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 969FE8DABA
	for <linux-mm@kvack.org>; Wed, 27 May 2026 21:04:48 +0000 (UTC)
X-FDA: 84814429056.15.5DA2F2A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7775840005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 21:04:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="V/xlCgGx";
	spf=pass (imf12.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779915886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a7Xt5m4p6IY6vWXK6RUuls+J7ypb2D4QWMRDwzWr9Q4=;
	b=CTNGQySqMKQO/FgVIt0U3ebWstKIEpo5Hpw4TnEV+T2voandotxhQdNp02vOthvm8xiJGt
	zw1bZLlEye8KzLtImaO/FRChOCSjIUneuUCuP/riCKe5YRTmjJNlcmmtgiLJQ/APHCBBQv
	YxdX0T6tceicDYfC/NYgyWYwtq89sJw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="V/xlCgGx";
	spf=pass (imf12.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779915886; a=rsa-sha256;
	cv=none;
	b=VgNRyBxUtXsw18bbpKSvN/qmUGjhAkv6NLI0qGfDncABU52+qmecNJG1J0E1hK4lmKqth1
	HPd98rp7/CNumKfm8gOedEtwf4GsyBiPbWSXaY0BWJxnff3oUS/rqglU6pbUbNCYaFJYoB
	RyiKGS7jY5DTDnbcvmvZQu4s8O8Uf6g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779915886; x=1811451886;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=r5RUVnQnLZnJ6T0pVM8XF43GbEtsenzMnVgsSH9dtT8=;
  b=V/xlCgGxcPwTVvo8ByJCTz2EHmDaPmHZScCi2xiDVnikxo+9KnIYyD4o
   wYvYjsX1iTUMqlSMJacIV/q3GdqDUjtX/15BXrg04mv36TDC9nnxIcUDI
   xAqDpQ2oukR3ux+sd2rQTE9zr3+4Gzi0Jn1bTO0FRJpkEsp6Vt2M9p289
   Q3mU0mYkxu/hmv+YK/KroQK0wWGeSPBOGpZgeXrylt/8ToTKDhWdYLUgd
   tJlKBKk9M/DDOqSFacBVmG5MK3d+17qr/CAzoMfqz4i9xcD/JZIEtYrGz
   FuyBuNodF/muYlg4QZwofmZFMKd3qR8/L3OLW3nqy5tP2Q+cb2sOZxuWX
   g==;
X-CSE-ConnectionGUID: +V0CFuYXT6SBPKeyCvTpmA==
X-CSE-MsgGUID: BPXtvZ/FSkSBNKQCGn0cLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="80814598"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="80814598"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 14:04:44 -0700
X-CSE-ConnectionGUID: aDkngHK4RSCCGhyDj1mzvA==
X-CSE-MsgGUID: Ry8z/F3+TVajjB0FJ4quFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="242505275"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.111.27]) ([10.125.111.27])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 14:04:44 -0700
Message-ID: <5f70e840-9d0e-4cef-8574-b355cf26e0c4@intel.com>
Date: Wed, 27 May 2026 14:04:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] x86/hugetlb: AMD F15h VA alignment offset breaks
 MAP_HUGETLB alignment
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>,
 Karsten Desler <kdesler@soohrt.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>
References: <20260527143643.GO31091@soohrt.org>
 <ahcTYufV7P5Cmotq@localhost.localdomain>
 <ahc31AChKqnfItHW@localhost.localdomain>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <ahc31AChKqnfItHW@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7775840005
X-Stat-Signature: ippbcyag1pzga18seg8zihpzgmm9qww4
X-HE-Tag: 1779915885-193286
X-HE-Meta: U2FsdGVkX1/rBYV3NKBn2KVPIolf1Z+8RS6ouxhQxkNJ8DFimafV/j88ybAXt876Mcp66IkxfjJ5n/oM0GBFMjaGg8T9Y12fXSmMk6AWLYuUy+DTQw8pdu/sqXu61XvRq6XRqjX40ocYQz0nqBbXiWHweAJXneBFH7tgBkjOaG2zLklP0mPZQPV/vT/pVraBx1Ydf/N3of8tzEqRpRDS2PXGkkaVGOunzGQSuuUi0FXbLK58ORTipWw1O/eMPAc69yRhLiWYYCqi415kULty5JsahDOFn1pvV2CXRQmrZ+K3rxgPHZDESCSi+/6Kb4t0NxGwnzwgfbIo472HG7AN2TzuVlueEcm9zs75K7uHsw5sv6hnoOu/1v+A5YXZ7mY8e62l7nqLw5c8lgaMlWo+NVfWUwEmv5Vxh6ty8DLJi97ApxPqvfDDvrOji0vUThJ8mcuSAhzZiLHjG50iuEZkW1Bmsh6tQp93NvFNh0nAOQurHryobJG6LJSsNINuPoeqzMCGg8/v69qALhymQeaU8hcXYDqLsWbFlcAQU6V1ym5Xk0HiH/pvbbl2wszv8frzYKgKB10KaBzbUOJt4UemItDlavQD9sP0xp9kypQxS5ITFvjY8WOrE4bTaKWxUrDrFnw/UxLrMl7rNKrlgB+Bkw92TnWv5BuJGyqE9dpr4uJqhARkqxjXlv12Oldg+gZJ/4WNE47ZRwnhVQXOSmdssoWrhazikq0Q4EMJWGOb0tuAyabP2E3w6VCULxyKirGWJ21KUHwKX2vccDHiqLYmCmHKpBxtddNSTtlbB+blbDSBWxZQSWd5zQQfPFu/AY2TdTFaykrigdc32XonRKav2JVzutGlXZBUZzfE9goti3pAtYK8314O2iPFkT/1e7dkGwztpAjDP6yVbLT+C5yVQ0Sy75KEf4RiA86dF2qF7Nep/nwhhF8kvmOwPJ1opyPDGOI+AdDZI0uDN1ZSn7W
 4POernji
 +k20SQX7G2lhOPHm4O82FrkC58MRE9qtRJV0YGO0ZNNBmkp6qXeKR6IeHO8L1LgLJUCWBtJWtsbLyTsv7cO92w4HU6b0HXH4hwyWxoYCv7coYX8E12lBivdqcJTt72g/Kzz5fi5M7vW8yQ+ldYWc4bga0yfP4yhCzb3DPmHjsLfga4Z6pfgQ1ALLacpaBya8D3/X1VOdUrxaZrQmcz1tmElr8/A0daNTWn5YuJdQEXqLPZL2Tj3uFJFKzpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/27/26 11:28, Oscar Salvador (SUSE) wrote:
>   	if (filp) {
>   		info.align_mask = get_align_mask(filp);
>  -		info.align_offset += get_align_bits();
>  +		/*
>  +		 * Hugepages must remain hugepage-aligned, so skip adding an offset
>  +		 * in case we enabled 'align_va_addr'.
>  +		 */
>  +		if (!is_file_hugepages(filp))
>  +			info.align_offset += get_align_bits();
>   	}

That's a good hack to show the scope of the problem.

But I'd really rather this be dealt with in the arch-independent code,
not by adding hugetlb hacks to arch code. It isn't even clear to me what
exactly goes wrong when you set a tiny ->align_offset and have a larger
->align_mask. Shouldn't the tiny offset just get masked off?

        gap += (info->align_offset - gap) & info->align_mask;

I spent a whole five seconds looking at it, but something seems to be
missing from the problem description.

