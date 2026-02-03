Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC3A2E8B365
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 21:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C42A76B0005; Tue,  3 Feb 2026 16:15:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C23CE6B0088; Tue,  3 Feb 2026 16:15:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4CE66B0089; Tue,  3 Feb 2026 16:15:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A29A86B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 16:15:57 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F39DD53E8
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 21:15:57 +0000 (UTC)
X-FDA: 84404402754.14.56E76B6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1CF391C000C
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 21:15:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Knk8SLhD;
	spf=pass (imf21.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770153355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xp65GXgNTfcGoJPQUF5aSkgYeEu1LCeYms5bjM78M1Q=;
	b=kpJjBjImkdHCIN2/Tzxeh+NEOEfxU727ALhH4mYYYOtky4wFLe927THdGV7VBGh4gTswEN
	91gNqN0aZsZaUNWaJDTfzQnd25D7T31bcVs4H0SOxwH6zEl9qg9dyk+03hKz3Ci8p51KCv
	Asl1ifZU0rZfl2qsCGDPsYPFnk79bkE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Knk8SLhD;
	spf=pass (imf21.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770153355; a=rsa-sha256;
	cv=none;
	b=heg9onLMXd5HbIfsQuOs5KL3IZHb1FqgaDLhZBqcegfKynsJG2pUdiqEAX7AfuN7Y/gH7v
	SahT4n6HGxhdzx+SMdOOdn0AM1G0vyqj9rxgU/YzzoA4xGOmpUYL8HbOgde7lGqHVNrvms
	AoTWMwBpNHeTrdwmC8R1AQsC38gVv3E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770153354; x=1801689354;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Xp65GXgNTfcGoJPQUF5aSkgYeEu1LCeYms5bjM78M1Q=;
  b=Knk8SLhDcd4XWlltJZtb+xgDXsP+9dFwILhcF/HLUpWU3xTUJiGJxKpx
   6J+wugWAAdxfJenyqbwBxHTidA8rR+gs0UtqcH0Qtqa1RrftgGNpM4Cei
   Yv5AIGJ6KQ3UqzFZHQ3SrDoExjuHM6OB+PJj51OaH/jUBIt6N2KCC4Ihf
   d1R+bwT9nh19gEyNx4+aJWJoGxmRqLOuQibUtpI4qCPeeYiGf4YZHRHJo
   ouvLlcKbEpQDI8jdxQUAEV7t516iO1VgZvn+o0ybXIR0HCNTlZ1u78kHy
   Q2oj6hqCijggA82W9UCj/C3ik9+mKnDu140nkpa/aA8xg8WFtVLjbqgu3
   w==;
X-CSE-ConnectionGUID: Y+zSJuusQ5i5iJK92D07NQ==
X-CSE-MsgGUID: 1TnFmvUaS+aYbx71MhhOyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="81649910"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="81649910"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 13:15:53 -0800
X-CSE-ConnectionGUID: B1Zxac+dS46fBXj6mwD08A==
X-CSE-MsgGUID: gWymDN+XSQeinnplnI287w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="210065588"
Received: from dwoodwor-mobl2.amr.corp.intel.com (HELO [10.125.110.207]) ([10.125.110.207])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 13:15:53 -0800
Message-ID: <d477dc42-acde-41f4-926c-400a9ea02164@intel.com>
Date: Tue, 3 Feb 2026 13:15:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] x86/mm/pat: Convert pte code to use ptdescs
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, akpm@linux-foundation.org,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
References: <20260202172005.683870-1-vishal.moola@gmail.com>
 <20260202172005.683870-2-vishal.moola@gmail.com>
 <e029f69b-6d99-4029-94f5-caafb5eb767c@intel.com> <aYJjnh6qI_bzfAo_@fedora>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aYJjnh6qI_bzfAo_@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: up1do9k6wzmqaixhoe3xtnxtr3wk5b5b
X-Rspamd-Queue-Id: 1CF391C000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770153353-265980
X-HE-Meta: U2FsdGVkX1/dJrv5IhVrjk3Z01OKj6KJKc1O5X0UO5tUH21F90lKaqQ6nfVCY1j9qhklZ6xtY/sHlwbuWPS77q7Sba0UlBA/dz2O0j6NxwggJunESDHjWR3oYOBGBOR8lvza7pi3t7d+5ry+j4f5kT39Zy3egZAZu5QPry+XIXjBAH8aYlk2odX5hGVquRwI7yJpYRz/Kn+g9V1LXdewd58XMjVGk9/DSvq+57Rx+g9w576qb1GUTYtMzIho75Mlu3fwhjT/EZHelYn4KTsfIVGlLbuQhzqABJLF0RL43dhF7VxFFTLFh/yRXewXNELV9Rh7t8a2d9bifA68w7Us/4j/hxLJRhlw0+jN/9gvAnnYtQNPuQDoEdrARrymEvtINE8exypcEIQvm3TLa0cffkIH6IvWnVApJfNHwF1KmAtF1xpbjyhwpGpmcKoLmzcClMDgvEoH9XgOpA/2AXylE1Vhl3tjMOxitArrXshb0aBGf++qnuo2uAFZJuVzDgOU8jpuYR0dqKJTsO1gHXqwhz1+s8cJlG7jhydpOOdd4Ao3wIWhYqj+8lIGUX4FtbFp06GaoAmzN1ksrgIBlLWtBVG5d14wHAWymsILLpuQZlSDd5G3WRc8X98dP6HXf5jm+B9Med1rVKSVWQwm/YdhARz5vw7gVFKC2gHDuxDPS7IxL3gh87W99OaOEHo27JRgaPoYPeWJrGlUc47nAuzd+PNrQVEjuR3Ykh3VJyokCSneAtJS7CqhL8kxpyg7MhgsKckqjzPJ1J+AoaPiNxnfJy/ga+D7jW5+zQC+ChGPDFdIYoO1yfu1/V0mh5rnGwmJsGN3nG0KTFjFQahYwqPAzIUO5BRtIWhA0CnYhN7ol0V2t3VzSfjrPC3k1VV0nANYqi/ESYZ76ROkpU29dOomESG4Wih/V/BHScQd0B/l0ke0BfkFq3JwTjUjQ4w1jUN4BRmdJzcLxnpcwqf6YPK
 R2qd1DLR
 9NESp9plAvEkmf+lJvt2FH9fmqAC6NJ4Mawkifrtw8vEwj6zfrGPa6UzRWfN8jtAKowru+ybruwBjmklP2jDPQGmCuOU3sboTT7C9cIw4VpY+0preVpmWdZcdcsGktpEkSpxRQwctSCmxJ8TkpleLZ6gZKRaOsXAlvi3xoX4xUGULuR7187C+DU4hAioiZs1HcOIRSVvIqRySHLa64iHyFqYJ+52aNNDmT2uQJA6sIiWG2/Wz7w2luqnihYMAcTv74au03YSPM/X5yxnDC7jOnJ/fbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/3/26 13:07, Vishal Moola (Oracle) wrote:
> Would you be ok with taking these patches if I add these relevant apis:
> 1) A function that returns and address (like get_zeroed_page())
> 2) A function that frees by address (like free_page())

I don't see any problems taking them if those changes are made. No
promises, but I don't see any other issues.

