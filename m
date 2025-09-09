Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB124CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 19:21:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 242908E000D; Tue,  9 Sep 2025 15:21:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21A2A8E0001; Tue,  9 Sep 2025 15:21:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 157A28E000D; Tue,  9 Sep 2025 15:21:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0249A8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:21:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B01DBB9801
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:21:02 +0000 (UTC)
X-FDA: 83870679564.27.6FDB9C2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf08.hostedemail.com (Postfix) with ESMTP id EF12616000B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:20:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=O7askgFQ;
	spf=none (imf08.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.11) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757445660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3uaBMgx1tRiguOxLwqiaeFe22d+U0LyGGH1XSiFjBKE=;
	b=cRbKl8VChei8e31DBASReCPeIlxuJjIbUizRg4UBWasY0sRp2IOj4f7CTG96ziwBVo7s85
	aH77kElukjlftAEgKebH9iwkRHBqDatVBIQPxpyD67FCPtMqHeqotwMNWguzORcuq3v1/G
	4iZz243CvFHjqAcpWzupYKjWUSj1d0s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=O7askgFQ;
	spf=none (imf08.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.11) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757445660; a=rsa-sha256;
	cv=none;
	b=3wajss/sO89n2JYWBVZHIFG+bU1ODaxNtg3gdlLfXPEnugF6NptDyfj1BCXwMmvKG5NgUv
	7uwO3HR4fJnhuZanVphqu3W5KMH2PwbbMR7hm5hko6y6S3fYJBAKdZ5gta/H4GaHzjiVD5
	YHD0YESaPdmbyGpCaCcAWTzNsSPdIlw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757445660; x=1788981660;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hcjqtg/1buYqemHe8vyu9yPhcW7/0Rq1/Z5Z5WmXe8A=;
  b=O7askgFQeyM1cP57gWi/hDexjLaYFkJFlPM7md4vlzjUFXaZ0f5PoY5c
   zIWkYKjeD7YtUFp6yU041iYzUjwsRxe2yKHiSKRATGXR7/0arJpTBIt9r
   58AJTCfZ0lUk05XV/BI9kY6+Tzzts7YBcW6vws2jgcJ/e64i/H6MVOw1G
   YqSOEiFhHE8MPXREGQi0CEHpoAu2Fpz7wkd8PIG92JLc1lRiWeZXm48cm
   FIK/PLXuItWrFnIkbiWM4+gL9LgIcc7rDRj8QXZlCtsQZ6OBAI3V5DO3R
   Ys5pRqSUaqVmESCA3gZ7Y24OUgog6KC69FneRjKKAEGSHrNkbE6ti5Qos
   g==;
X-CSE-ConnectionGUID: zCYdRRoHQ/asH0BhIQGcLw==
X-CSE-MsgGUID: 1YO1J7KAR6G7daQQHCQ14Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="70358343"
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="70358343"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 12:20:57 -0700
X-CSE-ConnectionGUID: CJff4aiHSuGiEcUS/1DR3Q==
X-CSE-MsgGUID: U/RToG1uTFeCKPDxk7m0/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="196847577"
Received: from ncintean-mobl1.ger.corp.intel.com (HELO [10.245.244.108]) ([10.245.244.108])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 12:20:55 -0700
Message-ID: <823c4b68-64ab-4e0f-bb6b-e8d52586e7f1@linux.intel.com>
Date: Tue, 9 Sep 2025 21:20:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] mm/mmu_notifier: Allow two-pass struct
 mmu_interval_notifiers
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: intel-xe@lists.freedesktop.org, Andrew Morton
 <akpm@linux-foundation.org>, Simona Vetter <simona.vetter@ffwll.ch>,
 Dave Airlie <airlied@gmail.com>, Alistair Popple <apopple@nvidia.com>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Matthew Brost <matthew.brost@intel.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
References: <20250821114626.89818-1-thomas.hellstrom@linux.intel.com>
 <20250821114626.89818-2-thomas.hellstrom@linux.intel.com>
 <20250909171831.GC882933@ziepe.ca>
Content-Language: en-US
From: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
In-Reply-To: <20250909171831.GC882933@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EF12616000B
X-Stat-Signature: uqn6d5qbnfou6a1bhs7gy1yhs17ppmse
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757445659-496955
X-HE-Meta: U2FsdGVkX18avN08BCddUMcfB4kIKCHg5mL68snq1+P1qD0tR2M1daZhUyG5p755icdjsxCMrhkg1H/PDxUE616Qch+fAGj/EoScmNlRNr9v0suwx6m+xyieF7SSu7/R1y7uyYXTBzhJN0RyHWQgHgoUaPwsF2AqcXLeEbpxSa7evB2FuTzB0JJvJfmJYpmRjvYDByNr/nqDX3UQf98RlP2888kgzQlUq5j9kWKiCSwdsjZA2ukbUIot72936Fwv5BNBUlcWD4PEu4EkExG1YhlWnyhSc8Ga7sb/sf5M+XYshH1yXbdLlnwNhLesCcte+kbgamewSh3ao/xhs6QQooz2SnD9BSl3uj3wAhTlDZtcR8fXGOzxSFBm1RaUvuIjuLzxRzWTJsqwoi3w81+v0qv8q49Y1GhqGSbdmoB+HZH1nauds85Nt0l2RtvlIu1+TQv0SQUTaIhVRhYpPN5iAukvhoEifgGzyOn3BMcq9BHmWpo+wFGplW9nUE85bU8G5vH6+aVKgp2C8XPPuAHmpP/H3ZBbbFOE5CaCRyYTeUl8VM8KvFg5hOSkNfhHjmkS7M5tf9fBZrLR0yMN+uyWaKT2Ax3PRPXje3/ZpH2kuGdacIWAKbdqzyfOT4YmoasLAXmXfS3yvMsHvFAiLYTOFLZeoxwK5ztKGeTHf+ao1CFaNS3jTYw1y9fom/w64jlOycsBXqEvHSK0oj02sNP+S132mgjTlEZ0NUc1VDF3Yk12E4b3YlwDnZnCv6Mp+4wrnXOU4BRoQ9ekP7iNq3Ku09j/TZiGPahv+7/BC0/AJQ2S9/irToeq0qc2iv+5/0Xn5ScrpF4eyGzvYn4B7gf3CJl3YUwoNuK00fRLE2cQ7GxY3ctH2t6XnanQK0KnEVT1hk+oqgUu11fbl3t3unxjgC1FJz7OtKpBqaY2ZEE+LmQy1wGK+jvK5y1K6HsgLLv6dlCfg3RlQPjmCk51rjM
 en1CsvYL
 V8kmo3TvYn1g2OT3dq1bivZwuXm/IOv2SM+sxkhB0V7H1BPFnpvgE9SFD67sHkcNXILX2jTyIR+ROXEOMLBiH8pXTLuGJAlNled7fMcfHaU1t/8wTC2O4gESS8zY4dAziTqPHxAlvAldzcJMJrW46p3BXSRymrKflt5ttl2P59etrzyRjQg+uYlGQBj1pJgPvMXbIbgixdgaigYfpaQyj3E30CAdK9DIfYl7Z9LwuD1ChrB1EtPjt2+Ss1zcoMI91O0MNlb2UUP/FeCX6tdJ1kS/gKnx3QZpL3JpFtDVcTK4YV7ac730GPpFo78cs8GQsHxD5B/pMDXWrtNQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Jason

On 9/9/25 19:18, Jason Gunthorpe wrote:
> On Thu, Aug 21, 2025 at 01:46:21PM +0200, Thomas Hellström wrote:
>> +struct mmu_interval_notifier_finish {
>> +	struct list_head link;
>> +	/**
>> +	 * @finish: Driver callback for the finish pass.
>> +	 * @final: Pointer to the mmu_interval_notifier_finish structure.
>> +	 * @range: The mmu_notifier_range.
>> +	 * @cur_seq: The current sequence set by the first pass.
>> +	 *
>> +	 * Note that there is no error reporting for additional passes.
>> +	 */
>> +	void (*finish)(struct mmu_interval_notifier_finish *final,
>> +		       const struct mmu_notifier_range *range,
>> +		       unsigned long cur_seq);
> I would rather this be in mmu_interval_notifier_ops

Thanks for reviewing.

We could have the struct mmu_interval_notifier_finish have a pointer to 
mmu_interval_notifier_ops or even to
mmu_interval_notifier. Now that you mention it IIRC Linus has pointed 
out that he strongly prefer function pointers in const ops wherever 
possible. Would like to keep the linked list, though, as we've discussed 
before, for passing of state and to avoid a second interval tree traversal.

Thanks,

Thomas



>   though I guess I
> see why it was done like this, I don't think it is a great idea for
> DRM to wrapper the notifier library with yet another library :\
>
> Regardless
>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
>
> Jason

