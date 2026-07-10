Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05AFAC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 08:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B820E6B0088; Fri, 10 Jul 2026 04:16:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33DC6B008A; Fri, 10 Jul 2026 04:16:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FD2B6B008C; Fri, 10 Jul 2026 04:16:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 79F136B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:16:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F0BBE1203E2
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:16:19 +0000 (UTC)
X-FDA: 84972159678.18.03F8833
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4910B80003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:16:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JxC+ZLDg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783671378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C3lfbzXwAKJJMyBDQQnH0hMEZobiBMZs7iflO0l0S2o=;
	b=HsnBIteRn0dDSs5KzCCl5os0CrM8tYuIpfuDv4GQY3ZGoeRKa7BADK/2pGIf0NZAOQM5+O
	rLRLkNkOHGwnATrRr27VswwIL6a648F6DMDpflgcUB/7UuWn3sPbuRZXOxZYMt+TvlFxzq
	6TTh6K25gdXFu5RXHIyFYya2jPTE2zQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JxC+ZLDg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783671378;
	b=BlqYeZUG729RjfWAJNq3Xy47U8focn1Me0FiCPsGlcXjV9Z95fZZYz4fjHMtQJhtWfygwK
	gEb1yDYHobtsYW1QcSxqQTEbQd/j51uX5DFcRAfGrK1Y6BhK2cvyWnHnla5Akq0HD2swPT
	T17kCMWo2o3ZVL1UtF5tppeRIbvvUAk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9005A600C3;
	Fri, 10 Jul 2026 08:16:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329961F000E9;
	Fri, 10 Jul 2026 08:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783671377;
	bh=C3lfbzXwAKJJMyBDQQnH0hMEZobiBMZs7iflO0l0S2o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JxC+ZLDgIXwuH9JuHUjDWYdggID9/dxMCsywLopj9ykUTKnr1KkuuBzBnTLeqXQZJ
	 qJxq93cUryMnIbJXZWxWajUaQtUBBDoK0VmlOxhhzu73ZLFfqGzRtgcpAWdX+aHqBd
	 6kWfpY6t3+aaB6wbZwLIdKuZNOmeEKx8F6ttyANmRUxkNSXTdTLFJVq55VtEiMQpjk
	 k7YZwBbwoCFRrZ3ZgODKjjLBbWQDj13Z2laqRZ7yWx3kO9eBwm7h/uye09H9s/f5Rx
	 GfoHgz317VhnsBc57u32V6NNc/WPfUuRNEjyeuAMO8Ik6dRI41dVFjFkilis8GKYQh
	 O+Lxf3BIw5M5w==
Message-ID: <22bae03a-1a7e-41f4-8012-a511c173400d@kernel.org>
Date: Fri, 10 Jul 2026 10:16:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
To: Andrew Morton <akpm@linux-foundation.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, andriy.shevchenko@linux.intel.com,
 usama.arif@linux.dev, hughd@google.com, willy@infradead.org,
 ryan.roberts@arm.com, linux-kernel@vger.kernel.org
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <20260709170816.4e876a16eef9a93f41bb1940@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260709170816.4e876a16eef9a93f41bb1940@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: m3o9x8sbmnbesjdr4bj7nx46asit8i8k
X-Rspamd-Queue-Id: 4910B80003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783671378-740286
X-HE-Meta: U2FsdGVkX19F8lPv2gFDYebZcrWAdadCUt20P5HTivgaKPPD1KSuFAkf/1vMjyoyz8VWvXIOB6y0bkIwn/mKrotToF6roIgp+DZVCq23CWSU5bdmV/gpt8BWjoWB4+ZWlUgvIGq4dqutp8RgYMpTCnIZbjfmVx3GMwBqz5ig0CtwZoN9lcD6aEtbMeOuQ/NX+s3DWhDxI3vJVw4s9an1qis+tiAPNE1mLaotv6csjLSMgNtgoszVJVZXujw0pWfFdIcVys0O3L+g/ni285Uzcuivgy/UUKav6YDqZ4xHaWVv25hIPTvlnuos/AJ4w4ucpsQqWIXYrPeB8Cl2iz8CXOaVZO0uAZJRONdSAlinxafPmdAWw3HoQp1/wACRcjd1dDZdoewq7CdXfFKs15Z+ya4frN+74LU3CJ/HpBoBILYD/KAS2ldJoLVhfZQG0EPR+KRLERI7Gw8Nz/VPz4BNlyKt5D3EdnJYdsEDnRP8f8YVk1ZkFzwQUtzzvRr3oHx8lpwl+73zGUpRsgf/afejUb8yvkh3WCR8isCdBkLhBHBzBZBPpKxg5lNrCN3jUejsRYcoBlQinEgkTvVhUdwcby0oUwyEFPQqgFVFPYNATFCfinLMomPxPB8ocV19p91+s6TnFj25Skukx7Pe5i46IxbsYHSEop38m/N/mNo6YVATcHI3gu/1zTHDsGyzxsbx5uMpJoKlhRjoZ56iDc70n98q+bZeWItPiPaDC1bGI0DJal2vPTJfXrblmgFIYJrWaGkO1XenTixwXrz4Re7XQMnI1/M/BqrzuuvMpXg6nt9SeazbKnLOEh3zDC5/Y2K7DhyHNbsmirrV+iPgoLDtBK0OV5bHzrQJQdNLdOuHCkgvv4Hf3a12+njkyq17IGxwQQkjydC2RgJS3MAwnd0xFo/+LY2FaiRAFKPZ1DgE6u48HegU0eLknkQdLkXWsdiAQvE/KC+trzRt2eBfP/T
 G/t9msu0
 DhXE72VYHEx2jVN/xhOviSEJWtL9Xq2n55CY6kB1eN3m0gvsG4wVieurWlP8zZ0K1D8VrUi5QbB3s8uEUom1LSJStH02vjR9r2VvlcZX2jZV0qqTWS28dbqLSlKyWnfdC+EnbHOobI7UdfljAZf6geFNzNgbg5elv9vbALdpnG1RMrfmPfj3VVDkM/HCjiHJThpry6ZQQ4Vf0UX7hhQwWEzyHJhASluQN3LysFNItYPUk86WLISfSJWgvt1D58OcSQSgyvpfFsmioqA04De9oKoAImuLnrECMOa7x5CxkZNUkGIrWTKmiC2l2jwj3pdx12FyFI/hyUC/4LgeJKfWeVWdc8HKbi4e3MP64rHKhRGkj9tI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 02:08, Andrew Morton wrote:
> On Thu,  9 Jul 2026 10:13:34 +0530 Anshuman Khandual <anshuman.khandual@arm.com> wrote:
> 
>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>>
>> Bad page map reporting currently stores page table entry values in an
>> unsigned long long and prints them with fixed 64-bit-oriented format
>> strings. This is inconsistent across call sites and does not work well for
>> architectures where page table entry values are not naturally represented
>> as 64-bit values, such as 32-bit or 128-bit entries.
> 
> Well grumble.  It's a lot of fuss for something which nobody is hurting
> from.  Or are they?  What's the actual utility here?

Hugh seems to rely on this information heavily when debugging

https://lore.kernel.org/r/3afa822d-3cc9-1068-9a10-94a5f2e4d29a@google.com

-- 
Cheers,

David

