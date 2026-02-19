Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2DE1C531E3
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 22:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D845E6B0088; Thu, 19 Feb 2026 17:21:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D31A46B0089; Thu, 19 Feb 2026 17:21:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C33DA6B008A; Thu, 19 Feb 2026 17:21:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AED3C6B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:21:21 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 53C621CA1F
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 22:21:21 +0000 (UTC)
X-FDA: 84462628362.18.EC6F9E1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7A863C000E
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 22:21:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WvIPJ5ke;
	spf=pass (imf28.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771539679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CDNu++qCWNlg48g3YKHWSfGgP0fMd8u4C9qksqT2Mpw=;
	b=xc22KE3xf2jnWK3jk7Z7y5ZufOzlNnL7TSB2SETFNGzWHuolj/0bLL7z7AfNAEJzH9dlon
	Xplqj5x1JSsslToZx+usrPmMXgUSKFVD+bpFtulwAiJK7UKtyp5LOSksXjDRYn9NTWv+iv
	ATjWKdCVEuCWxaqhyTv008+LlPyXIIQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771539679; a=rsa-sha256;
	cv=none;
	b=ocDOhISgDEzLWE3UnIsjBFYACOkyWe7FXYY0kBF0RTMiOi9Aq9ovv5qA2tSXbd09Zv+2X+
	38+xkZSi191kPNRpeXaeX9VNwzHGbPoQ7+NEUUdZN+wKo5tkq7aKrWy+Pdr0KAMMfF2w7v
	375ScaelHf7JnHcX1xbjs+jUNQ0iS98=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WvIPJ5ke;
	spf=pass (imf28.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771539679; x=1803075679;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qz2nanuLEb45BMsI2pik4KU3HFkN3KaRfgsmvFgAE1c=;
  b=WvIPJ5kePyK1wIWRG6sDzppDvJBrjguQ5H+JglBjk1Bkk/tr+wKNZhG3
   NfE44pLro2VHwFuevSQd6CrmjNVW9rxwT0eiIgalvze8iTCWKn8luYBo5
   8pZLFhZ0+C+x6tR+uAWPTS6NTD23AimTiRrUtUAV5izEjr6OHtJHXpKz5
   Egq6xrOBCERKgUMvQZvJpKfJBTkAJY+Iyb+400LPEkPLP4woXm56xyuKr
   HT0i8O8ravpgRydRf5wFVkSgZopPGd4QPv3QWLOr0vMVNA48kbaeAwIfC
   V+7ankxiGrNY61R0mLJfkzOWCs9FI/Yf3+Y1eg1WgtaIRN0gttez0ofTc
   A==;
X-CSE-ConnectionGUID: hElYY13KQxKHPPTdrA6ASQ==
X-CSE-MsgGUID: SmC9Yi91QueK5WGVX3iQEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11706"; a="98102585"
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="98102585"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 14:21:17 -0800
X-CSE-ConnectionGUID: AYRZEmtdQo+MH/DRmWgA3w==
X-CSE-MsgGUID: c5oMvE3XR+mVT8o7kzTUEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="212528943"
Received: from dwoodwor-mobl2.amr.corp.intel.com (HELO [10.125.110.49]) ([10.125.110.49])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 14:21:16 -0800
Message-ID: <a6ff6568-0a97-4db1-a33c-4a42075d1f13@intel.com>
Date: Thu, 19 Feb 2026 14:21:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
To: Kiryl Shutsemau <kas@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <b0c7cac9-1c3b-478d-b274-c06f4e58f356@intel.com>
 <aZeJP-GhoqeTtjRe@thinkstation>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aZeJP-GhoqeTtjRe@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: qk3q5yrxubhjiji5qj61dq4xhwcnhnuw
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7A863C000E
X-HE-Tag: 1771539678-754748
X-HE-Meta: U2FsdGVkX1/TLd9AeFzBsLmwFNMlg8HN39NPZsWZk11LIuO7dYNP2mf61RPx1aR24UxF4eE8sVyBeO73ffy9ioSlFEgxkFCFWAaCsXX9ICXeu2Rloj0tUlCF/USSi+VhvmOCdztD8H4JNsm4vpx/AqEwTASd+k/+qtQC4f9I/I0cLd7vphZQEkl3uaslbG8zsVXxAEcZhR1uNIaeTFddM6iFHy61EhF+VouYb76KcG3osp3GTj0UHSlYi4Q+AMu1zLwqoglAXaWbVkcxpRvs1xc9XphE9fzHWhbb8vltt8++E9kaoLPJm5I1NYmY8qXGybGpt+gD6Muhq/nVrXQH9JsdtAkk0qXhNOxGs5VvobJ5qdjTUvc8CgXR1oagsKiCqP5FzfdFJ9A/iPiZfGh+rttELimOnSWn4/FsroI8qL2dBD2d4NxkGS9LXj0EnNLYzAJJsh/n2tKeHhWGd1mqM/VliO0U19JutkXyhBZiAHjh5HlyEIqVOEbLfMDUbdIS5xSNYYIgXbNciAnAyIMnvJRQD92vtLcu+lc2U4oCoHkGNM+LODNe8w25GlxIf7DjM1Xo37sSohH9hDIbCLWV+V7Qbq/Y4eLohOSQaA6K1lA81goESLAqXJZ3dhGu4fMWXnris7gKtol3kAyIxYyNaf2tGutolbicHyYN/dLg3lW18bi25upUfOVkYb8TinFMYYSTlebTnPFnpeDHU/SZaoRWsPQD/VxDllsV6I5UiJYuNzJuZemqDx6zAwjGns8rAdUW1J1Fd+ig/dUicF22RZjCg/bK+ygDJDBxIo93L9QJDYZx6kF0rP8RAw2w8iRJBGTNIf1U8gSapluD4OYPtOS1AL6CdPxB5mbCOOJZk3cpXBYuL1dGBs/3fJ4syNeE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/19/26 14:14, Kiryl Shutsemau wrote:
>> Others mentioned this, but I think this essentially gates what you are
>> doing behind a full tree conversion over to ptdescs.
> I have not followed ptdescs closely. Need to catch up.
> 
> For PoC, I will just waste full order-0 page for page table. Packing is
> not required for correctness.

Yeah, I guess padding it out is ugly but effective.

I was trying to figure out how it would apply to the KPTI pgd because we
just flip bit 12 to switch between user and kernel PGDs. But I guess the
8k of PGDs in the current allocation will fit fine in 128k, so it's
weird but functional.

