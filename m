Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B015AC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 14:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B4B66B00A0; Thu,  3 Sep 2026 10:09:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 966426B00A1; Thu,  3 Sep 2026 10:09:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 854E16B00A2; Thu,  3 Sep 2026 10:09:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 56D296B00A0
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:09:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C7BA312056B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:09:14 +0000 (UTC)
X-FDA: 85172633028.01.26A82F2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf03.hostedemail.com (Postfix) with ESMTP id C5E7020008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:09:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NEMdakYw;
	spf=pass (imf03.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788444552;
	b=MptmmRu1KI7z0hpRbL7YNzKRBBOjxvdfm+fplsrcU+p7OjYL+oX2tHV3AueftuPU4o7OJC
	HpYMBCXOlWwHIxta0hUrUht0ZwcpGFu5nhPTGZAxkXrtPfhU5fkaA6rW2SmNIT+bIwybAq
	W2f2AhKU1/hICg/9TZElIx4ZZoZ7QY8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788444552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tPplquRMc965lVo/zHjvE6qYYPupXg2TboHflXCrSzI=;
	b=ttubwyvGs6tXrXSlRRut59Gge4C+ELNn0AGgoI5sgYukj1nNJlNDsjh6tyN0tB3OcdipgW
	eKSu0G6AtZiQgbdXACfrxZJs56n7ozl/0TwnmEz7ZNarg5Z+z9HIIRXL4PKPH/8QZBiefN
	uEnHOFYIDTAydErvIxT0pUMSaxb1FgM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NEMdakYw;
	spf=pass (imf03.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788444552; x=1819980552;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OTjNezSxFLwvnnT9iv3PCVJ+8+JAE+Ed7X8Y6VFEHCM=;
  b=NEMdakYwR87+VjAscDsqtSlhwNCg2VayPfAVfMoINTxL6HVrAx4zehFb
   Dtp+i/BgCbyHV+y3yFF8GcdtD4VVGHxG3V5nQbbfKBsdfj+LsYIG3sTrf
   PcjMB4QExFzF3iURE3Jb5zuQdR8UuazLlYg71QyZjIvEcqJlZt1nd8q2m
   QyvUU16OK7RczxNOHD4mxbcdC03W6X9HqutPquU6MVLF0n35oB8nEjCJz
   xfHeuqyhVJIHUNMrLhvDs9SgNzX5zOM2F7Lx6JMm4iO5ULMm01eBDqGOg
   /GvYrAwzROO3BOCXWUWFdpbURJSeSBBRpf6x4bTSmERpWBThmHh3oeO0E
   w==;
X-CSE-ConnectionGUID: QtXfnLbSRp65+Q0BEji9pw==
X-CSE-MsgGUID: K48+P0t4QVS8XHETsHcGXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="88952388"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="88952388"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 07:09:11 -0700
X-CSE-ConnectionGUID: sqkLtLQkSrG19ohlwpkNug==
X-CSE-MsgGUID: NhEX0h3dQKKL3kmHczyrDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="299605415"
Received: from jmaxwel1-mobl.amr.corp.intel.com (HELO [10.125.110.172]) ([10.125.110.172])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 07:09:10 -0700
Message-ID: <1aa2b2a6-b068-4856-97ef-91ab848f01c3@intel.com>
Date: Thu, 3 Sep 2026 07:09:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/3] mm: make persistent huge zero folio read-only
To: Mike Rapoport <rppt@kernel.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, usama.arif@linux.dev, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, kas@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org,
 peterz@infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-2-xueyuan.chen21@gmail.com>
 <5026dbec-0b71-4408-a78a-484a4b8e77dd@intel.com>
 <apk775HfHg_DXpiW@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <apk775HfHg_DXpiW@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C5E7020008
X-Stat-Signature: nygbyrx3z68gzn4nc5sukdyuj3bqade8
X-HE-Tag: 1788444551-63113
X-HE-Meta: U2FsdGVkX1+sXaOoLqE540mGfCfqwzdd2UnFN3O0GgvPJ/vlnmHF1ee5DTrR3jZ7bEwjdraloNz0TVXpxLnlyapD0F+z2CG4v675UZ/jaYW2KN89dBCJ601esx4magf2U4Wx0WnawiEVGyK18LmH07Qf2qRZ15UVjOiqhoGiwM49Ya+szOiRZn5Q+eUKQd+eLPoz6A6Z85bJIFkkFPsRC+5AKGXQia1KIgk6sei40J7+GhOdQ9kW+w0Ca6+xL4clLhTofSrzqukFYXmb+PWdmEDGXiLOjVyNbvB+WY7ORIJiJ2rcGNk1cCodofxFOswTlm1G3S6rybsfOpm2p3yTX+q12ME87fD/gqMLGXxJhclkSractk38X0FtjjmitYrv2RFcOsv3pPVHQH9YaJTceZNPoU9xzc3bFTvtkyKqG3BMY4bUaBVW0kUd+XoMX5Kbp5k/ou7ljJ5ClgK7z4gKRj1sgdcc8WMWdsRrn8VUJMW4goFxKS3/Pl3UOthoB+MvckeMfs5WJjx7xhZYItb87UEfuwvWfribA8rX4bKyPSmPWPsXoBt2A6j7qzTKpUKpRwMGNRQfBzi+ncBY/rDp1qOYrPtMiT+pNf18rAYwmxrgAbWtdLytzmv4GkQaNKkdjSWb9XQTY0sKM/eKohXyxdqXjVEzs/wsT1iFhEI16AwubLM/TmAaTcF+yZ+IO+W8ujcOqzj1c5IQrUQ6d7TO15v+EpMswWfZYM8ibS6+5g3uBh34zyTMCC5qye8AQvrJWpeDpILI9sjh0buuJ+AGtTFMKbapCyosFxIDpQQwr24Bj5tRxzkhVhEr3UMsvLi3E70s1B6af0n+4ENuZ0Gr22+ytz8H3fZ2yRS6P68UJO9rD14vJMrNTLYISLqvO+9DemNWNPtL0HM2teJ81lTL9Itw+wIacUQ02kBQqP6BAM1k1XOM8CeHpGB4uNiV9eSeFnp4mmMBdQFhqQ5Z0c7
 aoX9Jwa1
 CulEVGp7BViASEOPL/Kf6/e0us1AOeTdBB0464XqRK5Z2dC+XPRvzZlxXx+sQka8COiRyCgyUmVdM/hmiwo/dsizAzOeimEI4r7Wpo/9XG6LlY6avHT7giWFL/KA+pvfouvKC8as50+gRMZ29I06DkT8jAKKSV3PDg6Z3wNHxqY4r/oj37vMIJsaEgW5c/gp65BRXUH6+NQOvQCiVuj5chbfY6gHw8bQ1TdBB72IbK1JWQ2jQWV0bQYQG9vitwGrs+Y14rIs6qyIjWL8Z+3HoRdxAyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 02:20, Mike Rapoport wrote:
> On Wed, Sep 02, 2026 at 01:59:15PM -0700, Dave Hansen wrote:
>> On 9/1/26 08:18, Xueyuan Chen wrote:
>>> +static inline int set_direct_map_ro(struct page *page, unsigned int nr)
>>> +{
>>> +	return 0;
>>> +}
>> I still really think the stub here needs to return an error *or* the
>> thing needs to just be void and tell folks that they can't know whether
>> it worked or not.
> All other stubs return 0 here when an arch does not support set_direct_map.
> I'm for keeping them all consistent and fixing that technical debt as a
> whole rather than creating a one-off here.

Oof. I didn't realize the set_direct_map_*() functions all did this.

I do think it's generally a bad idea, and I'm also OK if it is not fixed
up here.

