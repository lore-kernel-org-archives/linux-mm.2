Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D0B7C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 15:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9C216B0098; Mon, 10 Aug 2026 11:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B72F96B0099; Mon, 10 Aug 2026 11:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A64506B009B; Mon, 10 Aug 2026 11:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D0B26B0098
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:22:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E2C61601D1
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:22:47 +0000 (UTC)
X-FDA: 85085727174.18.FD8E386
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5779FC0007
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:22:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cvLkXbCe;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786375365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAwSONfXZgDRJb+nPm7/YzooPB4h26YPEVaaDW0J+pM=;
	b=LEXFMM2BD2f8b2DcG8H6LoOI0fIGosWfHKC1BlLDSkdZ1HhO/2FEeMj9u8TsJcG1hm81SQ
	od/0JP89BID+8sLH7eWwOdLb/c7UlZaPmAIfZ4J7Aopjd47rGNgLYAMZAiJSnZNJDmANL/
	aqoJ0MI4XyDPHkBxfFAb0QS7n2EcMyU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cvLkXbCe;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786375365;
	b=G2AggiUrOosoQd/zh8dGUTWRpFE+tytR+GI1peS5EzuoC9BtnOleqU8qmgKDgg7iAAxcll
	fsdM33gHrdAbc2ZN66Eyxio0xKeFZ+kbQc/9lI5WUwcx4E76G3WQcR68TD4GYfET1LH5Y0
	y5AubDAIaQpDlAVizSVbCTOY77GHdDE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786375364; x=1817911364;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jdUTzf2xz65Ai0O7Sdg6zSY6KJCF4iv0rolefQAdO4k=;
  b=cvLkXbCeZeCdyP+EB7kAe8kZWy3Qr9yHICU1xgvEKw9TLmaRBVLZ/bh0
   m53Zdj/vaUeCufZlsqO0WBVDytwmshWGP02JwnBYUVy1t4xuL9b+CFUip
   Iqh1uTcVs7rVgHuHH5OpftWImXZuMbzsKMDuRHfB7ApBlaNdzDW2ya8zL
   83PQVG5yGHh0nYRRz/jPhpcMMS4BK6JZC4HRCwzbgf9izxY9EpGu/1UUT
   u1L5WacDkl6uRRnqRI528A1prJmbcWVeqIVgoX97LaF+ExzS6tlyCN+bE
   odzsqMnPhUSEhFH+GxoLm1Jc1AwQL4fTgP1tseaLzBLrsT4PHcngCUuty
   g==;
X-CSE-ConnectionGUID: BmKvhH7YTe2XlcnUv+CHeA==
X-CSE-MsgGUID: guQNs6XxSWCpGy0hhsjhhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11870"; a="86901863"
X-IronPort-AV: E=Sophos;i="6.25,216,1779174000"; 
   d="scan'208";a="86901863"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2026 08:22:42 -0700
X-CSE-ConnectionGUID: Sy1zKHHHRwSgldHFqSg+cg==
X-CSE-MsgGUID: 4nj1kb0QTcyFpOAqD2if1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,216,1779174000"; 
   d="scan'208";a="263673560"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.110.41]) ([10.125.110.41])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2026 08:22:42 -0700
Message-ID: <c8ae7c8d-8fbb-4aaf-8bed-53fdc7dcfcfc@intel.com>
Date: Mon, 10 Aug 2026 08:22:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/5] mm: Make per-VMA locks available universally
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com,
 Liam.Howlett@oracle.com, david@kernel.org, willy@infradead.org,
 shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com,
 aliceryhl@google.com, arve@android.com, cmllamas@google.com,
 christian@brauner.io, tkjos@android.com, dsahern@kernel.org,
 davem@davemloft.net, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
References: <20260806200548.3124802-1-surenb@google.com>
 <20260806200548.3124802-2-surenb@google.com> <anmTYW8X6c9TgaO0@lucifer>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <anmTYW8X6c9TgaO0@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: pw9qzwhnyp93djsd91qppu81zhqb535k
X-Rspamd-Queue-Id: 5779FC0007
X-HE-Tag: 1786375364-293519
X-HE-Meta: U2FsdGVkX1/miBvSnvZkdyguheim9dm+X1bMwMDZbm0ceZR77+gMVK5wqNh8tOfGY9RNGwNF+xk4aYaSUti4HGK+VWujE70b6gGcVEYPo0W6vGsrYfEYNih4ZjEBPtqfuOGFdUIAQofj8YzRueFYdVw6dcAOqhwqFQinlCpjy6czYaBE8m0ATpz9nLYS8A/5wE7fyBKY0Po0awcgdPV9AQ/pjLx+Vwg0669nn/6J+BQ7bVhGhvOaAkUkgPWNmZ1iC/ut8fsU7EUhEFWDWRGqUvz9mBmSt3l5W4e7SAVxFn5gGE1X0tmqW0Y8kBp/Qp15UaZQ7lHgyVRlgCjMJWo0UdIql2Py+LYvV1aW8+TCezdbNqwFcydI5M9WSHGpT7L1AHK8uXyyxfiK4vkCQ5DFOn1SmiKm9X5nEUStMWC/AUniEcMDivUmGxmZJMpx7v9z98c3MEGExr1vwSNl1BXVhJQO+jcrCi1ypciq8lX7IywzAm3tfv2SliaRoIJp7V1reCLve/lCYhirhIxxP9Z85Xt5kBURm9z7BPAvul888uEzPADzz4rB9tVryEkuqwHmFaWjSOyXzik1Hv72T/GdCJnuBFyfkRVrHB+0Dc5YyrO8IcajFWRb7H7mRRwEKjzFoVMczlnckN/pjwHwA0z/upYmOZ+D8VOFCm+C5RfSVGw8oXCFgYJ7pA677dzX9w0coFTkpLewbIgSBlJfwWWqgkimYDu+iv+UIynao3zGSDx85P1wVoxBDTayNjtuEFtLdnsHp3BSJIPse0WMW8LXqm3KT0LHgyb6aSyXy+NGkGb+HoszjCwOT3quaR+I8+rZsLY1FeD8vCTQRzVR/rzjm6A89SHnTObPcIxYTVpYbKo4SIA6PQ5/hUYz27M7WHi0HQ5/xkbm+FL/37VkBDZ0BTOsQQNfxvpRLjgyYxJEI70mhtCE0LYhpqmPUZfscW4mY1f3aperYL3MBPOVt7k
 cMnZzKY5
 zELjPtZ31Th+LcE92curo8CWA6FVQf0nAQiRXaRuOCU57szx5NxEnPLKFGIZ3a+5+AqMycDyFAH6rGVHkjNBOX5e2oyhsGOHEIQPtzwxbCkkQcOpWD6/K+7Gt32zvIjs7Y+FyqbKzKwklFg97Z4jkujo9supZq4pqmdGJ4LjUVvje6qq7u5M3rcOezbJWNaqJxF+cSUdpbYPIsHR3GAZ8M8G0tWhRApnDUkCOfGIKXPNo8AZQqiuHtufFxA6QncuarFiZFtBPYIT8sgYViocLV4ti7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/10/26 03:17, Lorenzo Stoakes (ARM) wrote:
> On Thu, Aug 06, 2026 at 01:05:44PM -0700, Suren Baghdasaryan wrote:
...
>> The downside of this is adding some fields to vm_area_struct and
>> mm_struct. There are likely ways to optimize this, especially for
>> things like SMP=n configs. For now, do the simplest thing: use the
>> same implementation everywhere.
> 
> I think for most cases SMP=n arches are not going to be scaling too crazily
> on threads/processes anyway.
> 
> If real world usecases exist that the struct bloat causes problems for then
> optimisations for those can be looked into.

Yup, totally agree. It's not worth adding complexity and bugs when the
gains would be small.

> But I wonder if cache line alignment would in any case alter the impact of
> this anyway?

Yes, the CONFIG_PER_VMA_LOCK structures are spread across a couple of
spots in vm_area_struct. At least one of them is 4 bytes and another is
____cacheline_aligned_in_smp. I'd eat my hat if there aren't at least a
couple of bytes that could be trimmed.


