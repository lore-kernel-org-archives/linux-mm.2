Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1CF3C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 17:54:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1B846B0095; Fri, 11 Sep 2026 13:53:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC41C6B0096; Fri, 11 Sep 2026 13:53:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB6876B0098; Fri, 11 Sep 2026 13:53:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0E16B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:53:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 10D221A0344
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:53:56 +0000 (UTC)
X-FDA: 85202229672.08.B836CD9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 595E9A0004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:53:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IHZEFyny;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789149234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LTbZJ30EqsYk8SxQCH9xM+3ZtgdDgiLg204FPahktqQ=;
	b=AQi6Ld/+WbLL1jWitqY9pfObyj+ulAqx1iu5PFtIAFbOGr1tRYtAXG80Sv5Pp6cprenKuo
	YEpjWHw2pMs7lWK1Eoc+T0rm2c59mktlqjlRvkFiHNiZJhfzK3JhDt4gZc7MSpOai1AYRh
	z8Y+jG2FtnsnoxnbxzkKZiTxWd7YgLo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789149234;
	b=mk6g9MJ7QTZkbfgUyIqviDiRJZlrUIH0rpWkFhI0vbNNTxyzm/uqdoa6opxC+lCAGhHjzZ
	rVQYf310RDFKPUz1E364251sd3are0PQ8iknU20SUHm6MjHqtjiBH2CyCD9A1g72xaWCn4
	UqL2qUTMmfWYSjLrQYmuUyqhOSSynpQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IHZEFyny;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DCE2060008;
	Fri, 11 Sep 2026 17:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9AF1F000FF;
	Fri, 11 Sep 2026 17:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789149233;
	bh=LTbZJ30EqsYk8SxQCH9xM+3ZtgdDgiLg204FPahktqQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IHZEFynykFS1ttB1G1hhT9c4tzOzA9AqYZJ88Y9BSXZZdDvIjf+4NqPUDQk35yyK7
	 CxOYStsBLS+l3clVVn16laQauI1rI+M3rVNOIi0RNDB50x3vdWKEJc0uCbZDO1IEWD
	 QbamjbZaYPr6be2JTu1VMqusSWwmdKj+3ixYrrkj1eGQUOqfAigNT33lu/ZYHQ/E/L
	 Ccl2TanUsfTghY7OOxJ/TUiSYVSMB5NO3Cq01ZO1akXYRehszNoEyC0VBwc7bttr7a
	 8SAkj5qM9+X/M3WR7sczHUU12hmM3ygUGefuFuBFR4FdiKFQTjZq39E3+5x9JPTwJl
	 DKu/AWeyQmXXg==
Message-ID: <c2eeb782-a426-4cc1-9231-846db5939803@kernel.org>
Date: Fri, 11 Sep 2026 19:53:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kselftest: mm: remove exclusion of building soft-dirty
 test in arm64
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
References: <20260911125028.1268274-1-yeoreum.yun@arm.com>
 <0e419abb-71ce-4b97-b189-da86a4891920@kernel.org>
 <aqQrIkcPf6uMlouk@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqQrIkcPf6uMlouk@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 595E9A0004
X-Stat-Signature: 8x8idx4q3ae1xw19rboho4sif4rhp8gy
X-HE-Tag: 1789149234-757761
X-HE-Meta: U2FsdGVkX1+GDB61whF1+1a2IuETU1p6bGwItZXVZ7khL+tIZmCBfMwObVwcHcntWO4wFzNncm6RYfJKsUVIbORezdGosZbdbGFWSWM8EylDxUYFiKfuzh3gTQ7gLC2iTSwREwTUruk/eazDmX6918hRsyv7C+iQ/cCiH4MdjWi0yCArVBqlt2Bgsiy5XBhWQKtys4hkKMU35zzl1s44t96K+b6y6tEX+0Yd51I52dpkSIcpJtPzSEj083TsOc43RacDi77z2gLWigbj0ob+fR1tckarY73U2PLp5zV5kAdcE82jBrTEs9BW72kVHx3uALShfz0V8ZFQUrHGSrI+Z7/A0G495LSpM+9ICbgsMTdnuUD4cbSy1Lf81a1aptShXJW4dRGDcJcGuX8ekvzPA0DtwmZ2anE8U+Ma/iV6/nOKUGjpXS1GhrWuYSaAjNWx/kFfNFP9LVg14Y2u3/ln0YenAmKO3bu9gj3goDT+qJJmvjjKM7DQgpdMHCNL0StBxSMsCrH2X8bvcwrxYC/hUf1iNcGmfKJWvJi+DSLmextQPueZY4XXozhZauQhVpxDlSD4Rza1PkjBWrXqFPYiM1kJDPfiY5gsEZvaPgNffS+vxZfhhjbELqdC5CCd7CbVClyScNR28Hs9RE/grL7NCQR13e6l7m96WaQL2SRX38bQF4Rvh9dPa/OOdo6EMSDE/Ephud/VLdsvnEU6iV1/2527yySDfn7S1eO4iOJs1omtxMxzkTvUbkqP9Y1/MgvJXFmdac4hVIX9Vp7cNHuwkhy19g0Cap+tGUB3StHg95ledo3+Ys0Vw0QngQA1pNOryhJKYwDvgTi+HElLQeSKMu2+g9t1CZ01M6ruERkjhay45xLxP5K6Pd00Z+9uqjRCL9XLVNgr4GznMGtd1qKC2++rtPhunP95jfIhwU2/mn24lkQtDi8b1VK+4m6HiYxUT51Nlp5Q+NLoMHYyW5Y
 IBRDCZIw
 uXQ2vIO23V5BM7s2WvlKm04Cw0rQXmxbOMu1N5zHlsJkKSCtzv0joCu17Gz+Xf74HMBw0jHmCNEEgFpc0V9F+6AB3v4EpL3BK66WSTUBAxCXFbcZjHH3r851Ua2No7L8Yeb2ZgM6xOyZa14/Dd+6jHF+kDi2tE5FJb+OPQ9fZ9KhvvT2QL45pNfuumOrzzuR69JBp5h01YVOnY49AHEkEB0OA7KGqVZkDOn1vOHq9oRuajOSSPNDWWwk+pyLrBlUDhTK0+A0CUduyf1GSDINV7JG5u8aOOhb/Ny0MYpeJk+cxKwRNWvILUYd0FsXveECcIdH8hQsfpJwqatdGU3OBAiVOPvhqIWv5WVLy7IP8/eU3sbE/nBHO5/1xbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 18:24, Yeoreum Yun wrote:
>> On 9/11/26 14:50, Yeoreum Yun wrote:
>>> Since commit 0389c305ef56 (“selftests/mm: skip soft-dirty tests when CONFIG_MEM_SOFT_DIRTY is disabled”),
>>> the soft-dirty test is skipped when soft-dirty is not supported.
>>>
>>> There is therefore no reason to exclude the test from being built on
>>> arm64. Remove the arm64-specific exclusion.
>>>
>>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>>> ---
>>>  tools/testing/selftests/mm/Makefile | 3 ---
>>>  1 file changed, 3 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
>>> index 2d5366196e30..d3e9bd67904a 100644
>>> --- a/tools/testing/selftests/mm/Makefile
>>> +++ b/tools/testing/selftests/mm/Makefile
>>> @@ -104,10 +104,7 @@ TEST_GEN_FILES += guard-regions
>>>  TEST_GEN_FILES += merge
>>>  TEST_GEN_FILES += rmap
>>>  TEST_GEN_FILES += folio_split_race_test
>>> -
>>> -ifneq ($(ARCH),arm64)
>>>  TEST_GEN_FILES += soft-dirty
>>> -endif
>>>  
>>>  ifeq ($(ARCH),x86_64)
>>>  CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_32bit_program.c -m32)
>>
>> Does that mean we can also the following?
>>
>> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
>> index d09f9f6a384ee..33963535616b2 100755
>> --- a/tools/testing/selftests/mm/run_vmtests.sh
>> +++ b/tools/testing/selftests/mm/run_vmtests.sh
>> @@ -390,10 +390,7 @@ then
>>         CATEGORY="pkey" run_test ./protection_keys_64
>>  fi
>>
>> -if [ -x ./soft-dirty ]
>> -then
>> -       CATEGORY="soft_dirty" run_test ./soft-dirty
>> -fi
>> +CATEGORY="soft_dirty" run_test ./soft-dirty
>>
>>  CATEGORY="pagemap" run_test ./pagemap_ioctl
> 
> Ah right. since all archs have the soft-dirty, we can remove the if
> condition.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

With that, thanks!

-- 
Cheers,

David

