Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55326CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 01:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC43A8E0014; Wed, 20 Aug 2025 21:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C95688E0002; Wed, 20 Aug 2025 21:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD2888E0014; Wed, 20 Aug 2025 21:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AC39F8E0002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 21:37:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2466F1601E8
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 01:37:19 +0000 (UTC)
X-FDA: 83799051798.19.C72B0A6
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2E342A0004
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 01:37:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TBCnFIAu;
	spf=pass (imf15.hostedemail.com: domain of chengming.zhou@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755740237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=75+8cTaUWk1uklVVN6F+RONMTl3pG47VWO/D9dtV4/M=;
	b=MAEgi39x9dFImDMUehraY6uy14l9rro6PUJD7bw54Y0S+MB1GIUrbq0TPwM+TUjcNcQ/uB
	nCS9O0u3OoLVMY4osa2zPveyu0oQDuR8T7csMIHf/B75kpH3Vy9KgKCTQmzcuzmxF68jS6
	bK0Z/Dr7BxChWbTo8M6wmYxjCa8n3fs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755740237; a=rsa-sha256;
	cv=none;
	b=GVxyZYLlL5Mf4cOx02FrK0UBzqfzKI9TLosNhSb8HtxiAB/dy6eDvKea+DFudSeed+L1px
	V5iyk4UByaOsgEAZt6OvG/yKGsPbTEgyctLbBeei+3ekC9KuA/G8/4CC6Y1I4Fyrq9MZfn
	BBlUNoM5/zTuSMgdBG3xhBCHUFDR/Mo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TBCnFIAu;
	spf=pass (imf15.hostedemail.com: domain of chengming.zhou@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=chengming.zhou@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <65263090-79a9-4d18-a016-c8f08dcfff8d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755740235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=75+8cTaUWk1uklVVN6F+RONMTl3pG47VWO/D9dtV4/M=;
	b=TBCnFIAu1PLgJoeXwQrNHUVpHUlTNud0dY3FaEv5oSA0S1cjvkpMChiG7plAF289VMem4C
	N9dhNnRIE8T0H1rfSDTQ98t/Hs5CgLNF8dJ//tFT2JlFb8FnKndFEPwgJNkI/SJVzgEcEH
	1qwU/IW9XXb3ucGKI3i+KACQZxfDCKE=
Date: Thu, 21 Aug 2025 09:36:42 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/zswap: reduce the size of the compression buffer to a
 single page
To: Nhat Pham <nphamcs@gmail.com>, SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, yosry.ahmed@linux.dev,
 herbert@gondor.apana.org.au, linux-mm@kvack.org, kernel-team@meta.com,
 linux-kernel@vger.kernel.org
References: <20250820181547.3794167-1-nphamcs@gmail.com>
 <20250820224659.88528-1-sj@kernel.org>
 <CAKEwX=NLvQyZTqv15kACZP2wErO9hyv9W+0j-BWrgOh5ZX1LJA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Chengming Zhou <chengming.zhou@linux.dev>
In-Reply-To: <CAKEwX=NLvQyZTqv15kACZP2wErO9hyv9W+0j-BWrgOh5ZX1LJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2E342A0004
X-Stat-Signature: rhqffpjh1d4kzo55e73ezg9xwxditj8x
X-HE-Tag: 1755740236-506290
X-HE-Meta: U2FsdGVkX1+YhpXGa1oQow/7wDbl6rjmPQj8e01rbiy8L551mO+bA8EvaanRXQsOYp3LI4gZqZaXzKNfLrJ2JlVB/vSwJkj8E/6Xz6ClLkkrpzI06k4f6D6OkCSW9JAy0HIAyZpEPDQg/edOndE0gl+d/35fvMa1LlcblRwYUX2EpO1NVyp3f7aLcuWHghiUe2X/t6tWmIHUUJ25NbCsy5Bn9N407m3psa2nlgQF7Bsl3ptm9hdhUhN0GWKvEw55HW0rD+7IonXdqzrdEaaVsLQ435fv+HokQZoGYoC7R5XYCygO/x6nmxxorbrCtGnemq6TEYMO740CCt1eWAT9imX1gBuzI4f2i4V8NduKRCyWkgAE/yc8P1q3skqZAnhNoSI8Jfhcv0Aqbo+KFGigqZAzeAV4CVjVQ/nyAUNKq+SvPiZWnwMRXJfnO2SB3uLQsR8bKnWY+lVhna0D/X4oLKgwJhixF/2evoBiDQmX7k8xSCySpqJMg8nhLXqqKCTQKnGa4zdEtM/9zXW4DlWPL4P/KUx81KKV+EbMzehrFxlwHFtlFPMs1fA//74gaN2OQ/89fhYaH1Ril80YxEtoCU8utQSf4xWkyAxLL+dOLMtUtnMO2oErj0PPzdqAx4d10xk/DDGDk9s91c6/32qs1fodzyhFXAYRFSUWf/pqJT84BwJDl/h8uDIaXJAdV4NQnvg9sCdQLuqCQ9bnoVFUkPVKGJvHk836IaW3gfkyJZlFBSrtJZE6xO+sk5wZj7ARtPVpkaFUw2aBRb+azPv36n5DngTlIJhUYqEDdTAvOcuLpMlgWqJAIxxNLmr+Xhnnt7sItk/P38/rqSJUnFQQ8boTPXkdwpDgfXI54J1iT9VTajqJ+kwQzBf0oe7JYP+VDDryAC2F4SjYVsw1XJ3D7Aj90qXmbFHsLnvmi+sR5LIJ1tFaztaASN1UTrLXyIjrXT6ouSbPvg6KEbt0qpU
 49GHfB78
 +as74es2xPdYwaMNdrGXyjSZoUCPyEN/UqSBrGOowVNApB57zETmR5Vmx36HSCyGMCQCFtme9NoH66qCm06lUlMZpSSjHnUqy2mSsYidgDYipEMYbvUmG1pJPDjWMXkvffdiGjenjHm4yOBwhuv6FC1BuArwWihh3CH9w13ojtEGq6gfpK9+i0VrecW3IOj1n1K2POokQlj9lnc0wKTslN4+/6H5uioXWkz51ludcMtjOmG5A/4A6rnt9R5QC6vFEdDJOjNL5TGhjbnDRuRaP8AHtwrNW7kwEKcZIUQWsf3/AuWWZxnoFJrAOWbpS4jrfmujquXMkViWbwCcgexnJry2tJmUH+/ThTZ9+0SkeDWeW57WTWJq5/kQ5l456Wl3Habbtdzkkig0tT2rbpOhTJBZ4Kch+hSg16+GT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/8/21 06:56, Nhat Pham wrote:
> On Wed, Aug 20, 2025 at 3:47 PM SeongJae Park <sj@kernel.org> wrote:
>>
>> On Wed, 20 Aug 2025 11:15:47 -0700 Nhat Pham <nphamcs@gmail.com> wrote:
>>
>>> Reduce the compression buffer size from 2 * PAGE_SIZE to only one page,
>>> as the compression output (in the success case) should not exceed the
>>> length of the input.
>>>
>>> In the past, Chengming tried to reduce the compression buffer size, but
> 
> Yeah, this should include the reference below. My bad. So it should be:
> 
> In the past, Chengming tried to reduce the compression buffer size
> (see [1]), but
> 
> Andrew, would it be OK if you fix it for me when you put this patch in
> your tree :) Or I can also send a new version if that's better. Thank
> you!
> 
>>> ran into issues with the LZO algorithm (see [2]). Herbert Xu reported
>>> that the issue has been fixed (see [3]). Now we should have the
>>> guarantee that compressors' output should not exceed one page in the
>>> success case, and the algorithm will just report failure otherwise.

Great!

Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>

Thank you!

>>>
>>> With this patch, we save one page per cpu (per compression algorithm).
>>>
>>> [1]: https://lore.kernel.org/linux-mm/20231213-zswap-dstmem-v4-1-f228b059dd89@bytedance.com/
>>
>> This is not mentioned anywhere.  Probably you added this as a reference for the
>> past work from Chengming?
> 
> Thanks for taking a look, SJ!
> 
>>
>>> [2]: https://lore.kernel.org/lkml/0000000000000b05cd060d6b5511@google.com/
>>> [3]: https://lore.kernel.org/linux-mm/aKUmyl5gUFCdXGn-@gondor.apana.org.au/
>>>
>>> Co-developed-by: Chengming Zhou <chengming.zhou@linux.dev>
>>> Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
>>> Signed-off-by: Nhat Pham <nphamcs@gmail.com>
>>
>> Acked-by: SeongJae Park <sj@kernel.org>

