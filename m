Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F790C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 16:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCF8A6B0092; Wed, 19 Aug 2026 12:01:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7346B0095; Wed, 19 Aug 2026 12:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBE0A6B0098; Wed, 19 Aug 2026 12:01:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 91DE66B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:01:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD1ED1C1786
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:01:06 +0000 (UTC)
X-FDA: 85118482932.02.6BFBC5B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E6740A000A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:01:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rrrnsl9W;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787155264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zv0hA6gazg9s+4AojA0xHWuEoRgwcHIQASoG+FMGHeU=;
	b=z31cOT2OkGRb9TzyGXRV7Nw4hSqE15DRtEszooBpL3pKJwcCX0Rk7FKYmtL7jpRcGpF8p8
	rSZHQv8mqs0g5oAzKNe4osrb5C4Lq596f8Bkx51DiAcHrplrrNqmM3t0ZV8qJKSnRAkd3q
	lpL21tYsTnjUKDWEM0KhGRh2y7KwlVY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rrrnsl9W;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787155264;
	b=IHG3j5cATI3lM2z0XAlkt8KyqUNOM5s23FDHCxTI36jwT6+r24fEgLwVFnmRDy9y0QoBXj
	eM1HarFMdKy42qMdixMMGYb+5tqrGLBntPOAjWYFoz9Ckl2nRDMIPQqwqLunIA6PsHFPzI
	no4Ltm+H0JrRh2fAebzz+EcAfy8xKPM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E4F260DBF;
	Wed, 19 Aug 2026 16:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069461F000E9;
	Wed, 19 Aug 2026 16:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787155264;
	bh=zv0hA6gazg9s+4AojA0xHWuEoRgwcHIQASoG+FMGHeU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Rrrnsl9WjiIvcnbhE0PlpfvBFZD0qNCbsP/c2kYs4pJu7h0kPrDAL0FH/DMQl2lBY
	 e3Iju7wXcbBeXMbD7vfwcntq93zF4BbImeE28mmYLJKf4n6hGAluaROMJlZISvoQvX
	 m0rVkQhNqH5wFYphWS0sTQ/4Fgw9onWD1szzkgjhXGp8sct2N8iLPz4+4hjVGBtCdh
	 24/dBv4aNhWaYoHdl3Mu+emVp5XutFnmyXZhTDo4PHyV9MLWwlkreFbIMRF0+DWEiR
	 TlE2ateTbv0wIw2mDKO7/alPn1WMJBDC63iYV7FikegUf8dDNMykd/ozA1mg2gRLFd
	 ylkoxTqDQOIaA==
Message-ID: <5e321f3f-d636-4baa-825c-adb8f0dfa23c@kernel.org>
Date: Wed, 19 Aug 2026 18:00:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/12] mm: add PMD swap entry detection support
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
References: <20260818131202.494754-1-usama.arif@linux.dev>
 <20260818131202.494754-3-usama.arif@linux.dev>
 <69e8469c-aa7f-4141-be3c-796c9cf11f2f@kernel.org>
 <5baead5e-b9e9-4850-9ce3-e48a2e5db2ca@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <5baead5e-b9e9-4850-9ce3-e48a2e5db2ca@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E6740A000A
X-Stat-Signature: o3e4waxd1xwd4kmmdzehuyt7wdgznxin
X-Rspam-User: 
X-HE-Tag: 1787155264-394458
X-HE-Meta: U2FsdGVkX18Az5ulT2JUyOSppjWF8MHcV4KCO7JY9hw9uR0BTtzq/RcZpyR7/TbT7O/pVYv83YMXzkAFrzyzoBtKBci0sv97OlMNrLDdzlXu/7nGIxv3r5ej9XF/lgdn8H4Gf7rqIRY6WKjX+awwSnSqrWI9rvxrySiFLB9W3mXAJlSrsa4HUpEB1KlIw7arUChHaKFcION/bjYO/cJzdaCxQV0q9WvYflbixTiOxtOyCjxlVW8pstEHAz2Tqu/LkbW5xM0vvWekP9VrxBxXCDgxMlaSiY8GpWnGj1grdUgs4o4t0uDUZCEpCq3IB5fSiKdExHDY4wPL3UQHN+csOTSLxTpXQW1Sh9Bq8lQUf8zuVlf0fKMfJu4nnUoP9Jtmaue0ihmCrHuXLB6Ac8pgZ9a0l00EsZyxmEmECNgDIZ4PFhyOrqgAZqlpNjwbF+NudSLJB6UkXVm/aDGnK8s8AZhb5X5aYORL23Bdb1lfqV7RGAFhzizDObcl13IEpd3qIvvW7deYBiLIW0Q6Hxo8+IohhiH3LO7AEkGfFVfTxMATQboyZmh6QQ/lSrR4S+V5zfMfmPdgVwkM6DORi4fO6OuxWEfqL7o5OaSZ7fLhBepK5wh1otIhBQvRcN3ktQNdt6XvFCgQLLki26y3Z6DgNeZ5GjU83lMGqpDVOGw6K4KwxJF0D+35gYZNoLMGIEUoXmkg6x4YAMs3WYNHrq9hlGoaVV4V5U6JBXvyrkCYJBvNzVHpyepHUVsyRS2n++n+Ols/pYA03PXKtpLeBA7hezK5lGIWE+8SbMgZuJMBg9rnDuPzGNcaUyU+3qL2zVuzlOdBN27+3YLY11ufGqjTHHQ8EIOMvwahoWqV8A75rHmDewbJPPikEUq77wFVyNPQaYGvcizCQYpPNgtD5YnK9GbS5ilJ1h5GWRl8xk+lscqftDQ2ro8yYVIIS/hR+S13LJoFnC05TQw+bCfzQov
 Ls7L+57+
 xhkYwV6hHwuL7lvuy7nuP9AHRuIbzESIJt71zkF7sIHE+N1nnbcI4XapqopzZvsgpmOkwrYyM3kVf8PL6pu9ao6EQ0p70w/HU1Erpf4HuzevdBshbU18POPFKBW18sVJlH2BGeU+tAbMNeUJqWgQpLbasXdGcIpVF0lVM5ZxLTUHjtSrsWFxCvAjBG81hTjMRs7w45HKTOdTUgjJxL+R3pDpqXtWlS+harG0L+BK48oDdqCdc0XmvHt1qH6Rx9UxSGb8Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>> ---
>>>  arch/arm64/include/asm/pgtable.h             |  6 +++++
>>>  arch/loongarch/include/asm/pgtable.h         | 19 ++++++++++++++
>>>  arch/powerpc/include/asm/book3s/64/pgtable.h | 17 +++++++++++++
>>>  arch/riscv/include/asm/pgtable.h             | 15 +++++++++++
>>>  arch/s390/include/asm/pgtable.h              | 17 +++++++++++++
>>>  arch/x86/include/asm/pgtable.h               | 17 +++++++++++++
>>
>> I'm sorry for asking you to compete with Kiryll's series by creating one patch
>> for each architecture that directly jumps at arch maintainers :)
>>
> 
> I have now split the architecture helpers into separate patches, followed by generic
> support for the next revision. I think I will need split patch 7 and patch 12 into
> several independent patches as well? This will significantly grow the patch count
> which is what I was trying to avoid as I feel that makes it more daunting to review
> (atleast for me), but I will try and keep it under 57 patches to not beat Kiryl :)

Note that such mechanical arch patches are extremely easy to review. Doing it
per arch is the clearest ask from arch maintainers to ack a little patch :)
-- 
Cheers,

David

