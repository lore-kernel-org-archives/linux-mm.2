Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4495C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 15:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61EB06B0088; Thu,  3 Sep 2026 11:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CF366B008C; Thu,  3 Sep 2026 11:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4970F6B0092; Thu,  3 Sep 2026 11:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 100726B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:40:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6581EA05DA
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:40:16 +0000 (UTC)
X-FDA: 85172862432.30.6A7574F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf08.hostedemail.com (Postfix) with ESMTP id DE6FF16000E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:40:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PcGum03e;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788450014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6DjgxxFKIOdVV2Izw3XIECz0W9pox5WVVlTwIOwADtU=;
	b=hIU6yS/kI9H4m9MwmRtwkDn6p+uMBfQHRHLzPRYcmuSRtf9AwboMVqZ0tEaqFO2iSfCoC/
	jNd5Z2c36qdXT8q7yH/6Tx8MtrZlR0OI0oth+M3HnR3rVhsL817eY2AiDKSCn6BiIv/ctd
	HsE72uE9YQZlhYkmDVyBwu9CEqkt/g4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PcGum03e;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788450014;
	b=grAJ2kr4wTcqt2KvZtFWNWEdZm0uhCsvhLWxILoz/redOebh4VHZuOlHM2nTvalC3+1hht
	Ye+GTA6rjLIVHokJtFMseoUSQOeXi0qdFniGVeT2swt6yE4yNGD9mgMj0sqosyImQxa246
	Z2/z6MjPSo5kXuF9byYZipgZrJkJ2go=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788450013; x=1819986013;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6DjgxxFKIOdVV2Izw3XIECz0W9pox5WVVlTwIOwADtU=;
  b=PcGum03eQmzl70RaztWPePfnqU+xwYmbEJOPqdMnYdk7iFB/8hiXCM23
   tcW0RBYMTitTl6gwygogxv19kMhvIcW4mSSqitCIFpnYMeR+R0TVb2fDP
   Tv8uvm4P7HsjaGLiGT3nrcUre4pEV0SnmVsCVgCVIK0YaFb1hZlt5cmVG
   fwVR38TzJlx8nvgyi0pmWl+PMP8PteQHswHdcQgkPBRLy+FxjkywNxOHn
   jbfxtJsVWEP4pe9gpI4cqoruEAzEvrrzugvovvIPHGeheu6rr5LiF8WO+
   VU7befA2azR5ze6ybI+hDRDOJXy6NBffJ5AJEK5HKQpUsu4FEQdova5GP
   w==;
X-CSE-ConnectionGUID: xuhava/2TMy1zs79ob20ig==
X-CSE-MsgGUID: lziEdAdrR9ernNraO/vZzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="88970134"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="88970134"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 08:40:12 -0700
X-CSE-ConnectionGUID: kLJlJJbQS1+WBX2u3Ec18w==
X-CSE-MsgGUID: 5kEBdFiTTDeWmlWnxai5rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="307976337"
Received: from jmaxwel1-mobl.amr.corp.intel.com (HELO [10.125.110.172]) ([10.125.110.172])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 08:40:12 -0700
Message-ID: <8e68ef0b-d88d-4b44-9740-717463550465@intel.com>
Date: Thu, 3 Sep 2026 08:40:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: Fix pmd_modify() dropping the dirty bit
To: Orson Peters <orsonpeters@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Vernon Yang <vernon2gm@gmail.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com,
 rmclure@linux.ibm.com, andrew+kernel@donnellan.id.au,
 pasha.tatashin@soleen.com, kas@kernel.org, tj@kernel.org, rppt@kernel.org,
 rick.p.edgecombe@intel.com, yu-cheng.yu@intel.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
 Vernon Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
References: <20260903031608.1194238-1-vernon2gm@gmail.com>
 <20260902211036.8184c6e5535669bd73c71fd0@linux-foundation.org>
 <CAJxLxMXN+y03VPWyiLcT5-eLVGE8iojDm4+GYd5fdJ4ZtQ45UQ@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <CAJxLxMXN+y03VPWyiLcT5-eLVGE8iojDm4+GYd5fdJ4ZtQ45UQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: hf1m7f9ujqwybyjb1ow7i1t7d7wafouy
X-Rspamd-Queue-Id: DE6FF16000E
X-HE-Tag: 1788450012-875256
X-HE-Meta: U2FsdGVkX1+qNME0eni2QKKOQMLTMhBYVZcEvg/iIGt9kSsWH8gJTGC3hXdf7j28CaFKwcYDO39dOpBYMmeQolNZtoaaJ5NBtKKOqMRY9f6L2Kh5q3FZ+AuILIWl/mRk5USQid44VPu3/POuFmk3foF8PXezomAEFyIgmpPHZZ6ikQwNNefcAvj1iralTsTrCY3Ki8tN3bS4wQ+E0gu4Eu9u3OYGsA2f74SbUua4RiF5ziiGeCpE9tMvkzUjhE4Ely7kbc6Ti1yjQufkXVw/OcYQSjBWYkvYlVF/zF5VXkkPtX1nSasy8ZE1tr2cknfHakzLsKkSxwJ8Uqe1RmOzYitbhI6iYllPxj+0++11iQruKAlJOS2Bi9y3GoLDP8oPiQd5UMJDtwa7UVI2rGLKi4dPENFJadcZ2IP25KKRpEK9jaOevHdo9EIQWBq3xyFEo9UXBgYGmM5PeYTWb9HV3nI+CV7zo/61nmq3Fya2wWLwyzkBWCohkgpy3U+D3t365M7UOT4yz4yJhBSWiCK/RbVaxbRL4PyUHlyMKPizzyOfrtPol8OwwvmD3Xfp8pXG8H/7UtH1XguO3/+9ucRwTs78S1JaVJ4bAc1pN8lRviepHT8bfnnxC5ppxkw9OLw6sB3EUylxugN+bxdBaABkoEl6T1NkX3CNTKQ2WUpLEVT8Ao6gHHyH9kxKfLi37T1tcwKqkcN9+r0+F8oWbNYrnPXCEktqaZMTNOuVROaqIPxYDrgtRFmPP2hhmBeIw/a0KnyQXswWWaPt3N82wcpOrsJgZF3dVdIQUXPw9gO2rIpv6BWtHPktjX/sPCNYV1z0eP09s56p60DcWB2ssghEmkQ9TFCkHOZcn0ZGKc7dur2NRX8VEwIIa69oT3af2nPtUbi2IEKomqMrgeC91wla6ybBvJZ56F0hgcQ+N+dqmQbZ46TR4/J3f2oPngufX1sf6L2WNi+7FUCYrHsryhW
 Ih/2OEFx
 YntgdcXN4TvVNIJei7zWdKlahjFIcW3HwmeSP8oW2HQnQQzYiX9GACMUP2BU/akJ4GKuN6nfJe16Ds/1LsgnPOITq+Q11EkmxE5OoYYZpu8bqOuePsgbInvW6UJx4chjNBwx/mx/gJbLVoWbah15Q/xru2RGWFxBOva42XXbFj1Pc+vaAcwuK3ToM6HodCvNjwDx08An9u+sm3AmsL+UnyOVfUybU314CykJh1ggRxVOnNqNo96HLOM0l6/rfeOm5o+cw6zGV/aYWHNd1DRWnx1mesYLq6xu3Qd61Nu6XXl+/RkdtNDG81O8rLERpsfqmeXRoNUN+KwnkMVwO7tQSg0YA6wHzRZ4SMMF7Alm8XVsIJaU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 00:34, Orson Peters wrote:
> Considering that the impact is so severe if the bug does occur (silent
> memory corruption), will there be backports of this patch? If I'm not
> mistaken the offending line that introduced the bug was first released
> in version 6.6.

Hi Orson,

It's tagged for stable@ so it should hit the stable trees at some point
and make it into the 6.6 series.

