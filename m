Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87B22CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 01:40:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41B6A6B0088; Wed, 24 Jun 2026 21:40:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F33A6B008A; Wed, 24 Jun 2026 21:40:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BE246B0092; Wed, 24 Jun 2026 21:40:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F31256B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:39:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7BAA41A0506
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:39:59 +0000 (UTC)
X-FDA: 84916728918.01.59FD4C1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8198E40010
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:39:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aUv8VhZs;
	spf=pass (imf27.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782351597;
	b=wAVADUJVbptN6gOG9PVp4mZIAzPx047oJmUjsAXJ7caLTZMneBKsLh48zG4JwwACtUwVKp
	uG8dx6Vn6D5oOYAEFSIm72cLnYqbj3Po5Fs3/ZVfi2cfskqR0fW2vK9FJthVIrccdC9uUt
	Pr4Bi4Y1zdFoebkLvGoyFYI4xl0GI1w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782351597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZX/ew8c+/qI3750WiRcQ6TFmCqNgQqSRGrXXFVzAFBY=;
	b=wZpX1/JQtEml0fL9phnDec/qakykqZIWDQooBmvuwrmEelN1UNT7/JMn2YmCv+fnlO1QOQ
	qxhZ9/Gbtf1fjwHirYQyZMDV96aOpzdqxN/FMsp0L1543UWjZ5s+Uo+dvwsry+qsfEfbpl
	Zqtpjhe/vSvi+lQKgrRUCRzeY3lV4+g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aUv8VhZs;
	spf=pass (imf27.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782351596; x=1813887596;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=v+Iu61I1bvimLxwsHz2/KZ1rwv2EUAMBFICllmwPCC8=;
  b=aUv8VhZspDNtVwMaIwdxoqknkvN14H8iV5b993pMhW1FoMXRA9n8yKVN
   LNHRAImSmXBktE/nSSRxY9GtB46exEnlnkZX1vQFNdIPyem/H1m1qSCgH
   Ypd7MQBwmBlgFgV9dlyveyGPfn8KCqrsEucWpHXzR2lkTtwEl67RFqsxP
   pibP1NB2Efrx/gNuELlU2cQalb7Gx6PiZx3ZJ0GGFYU49VFMl1NGWC8QZ
   G+fPyfyC9EFgTca8t33WeCJqmiCpZf5UbEEDnO8KqzQjxbZqrgjlZDBsm
   g+NPoAvlf5lg+7nJLKXNq2JPgP7HS8m12GJcEmu4XVrU9556Cr4dgAqRq
   g==;
X-CSE-ConnectionGUID: jQ24WoWlR82WBtMuNC4Rpw==
X-CSE-MsgGUID: ngvdm2PaSpu1OeOLEtioBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11827"; a="108668569"
X-IronPort-AV: E=Sophos;i="6.24,223,1774335600"; 
   d="scan'208";a="108668569"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 18:39:54 -0700
X-CSE-ConnectionGUID: bjCsAtM5Q2qyMj+6s5rL+Q==
X-CSE-MsgGUID: oxVpr/AoQXahHt8jEyg6AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,223,1774335600"; 
   d="scan'208";a="254484804"
Received: from unknown (HELO [10.238.2.81]) ([10.238.2.81])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 18:39:41 -0700
Message-ID: <2d862356-d9cb-462b-b8cf-bceca6366d40@linux.intel.com>
Date: Thu, 25 Jun 2026 09:39:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 09/46] KVM: guest_memfd: Introduce function to check
 GFN private/shared status
To: Ackerley Tng <ackerleytng@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-9-9d2959357853@google.com>
 <1b59fec2-a464-4429-8532-880394912af5@linux.intel.com>
 <CAEvNRgG-WDzHp-15Mig4hiU5Dag0pFCu70-R-9b=PkD69W=ZMg@mail.gmail.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <CAEvNRgG-WDzHp-15Mig4hiU5Dag0pFCu70-R-9b=PkD69W=ZMg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 14zbqqppmbjn5xo35pp84p1mfgub4ghu
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8198E40010
X-HE-Tag: 1782351596-398416
X-HE-Meta: U2FsdGVkX1/7SWwhU0HnAk2f8qFWAb7O2H+iMlWO3u4Q+Y9qzkYkes0VKNUEbz3Hky+/6aZs7q7uxM4lVHFSjOHZnLDA2yMkQxlWikms0VQjHS++IzQcBiB331tCsKQFIAODNAduk9CfH8h5x2RjP5fCX0NngRY3U6Iy5d3+8GI3n/xE5AadXZuVaCEp7g/rtNdZKd6IAbPL9p1n/D785DAo+OV/uGg1GNb1JII0AntGcRbMJGPrE0stIj8mxuYKj8ArZXbYmvEATYV1UzhTr4CaJJ3wR8LRVjBhgW8hh2e3o9+nx8WrKt0bW2sYc7t6KnlcBKhvWaUmPuYkiR1jQtpXseoHaTP4OLwXEUq692joP7aNW/LxOGiUkEYyBkKFmm+G6CJmXD+c2V83Zgh1uoDZrZYOogEkuxFEaaZKYp662vfVg6DXqJbgbMiIlhHcJAhX00Im7pWPPqvldusgr1bs3FdtzsWfdTCqB5sF2a+f0+mEHteCT2GIjyVDaLuy8Ei1qcLU15x7ICuJCjld799+tJgHEKDsFz7dAOCmOAC0PwBpwYzn1s15KJztkJbsrlMyS9XvlPrFMtWzdnAHc5WKtka0R8hi9v0fUsQjo4hSzg8sX5m2DwKL+XEIdrtPDuhm8dtRI+3UKqBf0vB7Sk07XspiOZHI6kiLKcGoFCDDluONYmJcIgxa8PQvQhws7JCMTUhsGEybvZ/eWRAkBYe/QaWJ5fnNEdSqzI81mYtQFF9l2PsPRvjplC6e2X88j1vbGaYPcTP4SLqywEPuDzXhC5tqfvysU6oWgQM+60bBl5wpEjNVDul5f5rswHlsPR44PGNc2U2mUSAhPma+F0hecbVB9CI96pWxSixjjMKkVAjrVgYeYufmB/bGItyXbsyuKGTOmpLZIrwxP2Ti6i7zpBQWxlRcyu97eXz5bhwfI03B/KvDHV3wDqmLv1DV5q2Hpz0NylUEYwgPN6I
 2CGMy9Jc
 0iKccylxyA8Lg34YUzIyoZwvwrYbOus3pJl/1zph03PKUPjGkZsUoaxzo+TWTJxonrhcvqxVQ7iC10mnXAfUV55Tfkpt4m09Ms9xeyES5C4bG8EtYagJ00BL0bSlkaM0Ry2aTtq/V1u3ay73MA2tEg9+NpbNb+J9EoFiQGFVsdi4VCbyteVeDCcn3ksP/q0YJvpeNHCxxYbwSzn/ORV8XG2tGoAGxHXSpsoZc1or5Nef/Qg739C+V/PheGtuYsmzP3Ba8JxYouibTxChLXN9vU7mbQDpvWy+sd4FoFu6i4Mr0VW4fyeMmU9p47MowVzd0cOv/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/24/2026 10:38 PM, Ackerley Tng wrote:
> Binbin Wu <binbin.wu@linux.intel.com> writes:
> 
>>
>> [...snip...]
>>
>>> +bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn)
>>> +{
>>> +	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
>>> +	struct inode *inode;
>>> +
>>> +	/*
>>> +	 * If this gfn has no associated memslot, there's no chance of the gfn
>>> +	 * being backed by private memory, since guest_memfd must be used for
>>> +	 * private memory,
>>
>> "guest_memfd must be used for private memory" is a bit confusing to me.
>>
> 
> Hmm good point. Is the source of confusion that guest_memfd can be used
> for both shared and private memory?

Yes.

> 
> Perhaps this can be rephrased as:
> 
> guest_memfd is the only provider of private memory and guest_memfd must
> be used with a memslot, hence if there's no associated memslot, there's
> no chance of this gfn being private.

LGTM.

> 
>>> and guest_memfd must be associated with some memslot.
>>> +	 */
>>> +	if (!slot)
>>> +		return 0;
>>> +
>>>
>>> [...snip...]
>>>
> 


