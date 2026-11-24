Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D59D0606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CFe2Ckdo
Received: by kanga.kvack.org (Postfix)
	id B25516B0620; Tue, 24 Nov 2026 03:05:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD6A06B0621; Tue, 24 Nov 2026 03:05:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C5576B0622; Tue, 24 Nov 2026 03:05:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F30A6B0620
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:05:00 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 47E78160AB3
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:04:59 +0000 (UTC)
X-FDA: 85469276718.17.C5C54D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7B4AFC0005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:04:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CFe2Ckdo;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795507497;
	b=IrOhEFbmNdjz0Jt4TxbbRnteAFoIbEVb9OV6E+ebWDxlwmDXkGwj7BWb8ofM58NoI4XXDS
	/mDC9lFSp10f6aePMyZVjAwFW6CtFimp4lQXXBNIMKhEzSkqdudaxD52TbNGeW3z4WqITe
	KoRkRgwUYGvnS/SxM3TW44IfNgNSx3I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795507497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hs9uypOQfbHnpPTNW01WGbHmNfbbsXyvVNcORTX/v4U=;
	b=Pf/cQQIiIdn/j3qTDCbI1/82TrEMahBySnLSgszFmx0Opp2t8/50692TwbEFWpT6+hQjIN
	9us6fhWqr6J9hNy+OaqOUINujlQug466NSf0LuG/jgkbmdQ5Kk90KG0kJiawxIiYHF07Lv
	ObfGlnLYYiGkgRYLd7aKBsEyd0OiL7Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CFe2Ckdo;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A18B3611D5;
	Tue, 24 Nov 2026 08:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994DB1F000C6;
	Tue, 24 Nov 2026 08:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795507496;
	bh=Hs9uypOQfbHnpPTNW01WGbHmNfbbsXyvVNcORTX/v4U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CFe2Ckdo05q1ECZMujaLOsgd95d45YaQcTFQjQENKNZOWMloqihcy4iIcN9C7Gq+k
	 RD3lbkHVphvpE39yR5DHEofBUlYLbLvm3Lb9B+7EX5HwMJj2xmNb/3WMCPXPCylXCZ
	 SkKnV1X6dv0b9abphEgwbPKztrMAtNrmJBGzH4sn5tzqjYVotq6hYDgErV4MUwzFB0
	 fiw9Z3wdVQxhZUoauY61BLbBVAhKRBY1MsjEQZABlB6K0N7H1UEXl3n2x6Kb2wiGD7
	 cC8B/cFFDrTJ3RiQ36WZnqJrEaeJiTSUfb/DgrKAErk45XfLJsipmq/HBFbVAbE3oW
	 gI9p7mB0NmQwA==
Message-ID: <c4f270f1-3196-4ae0-8a7c-7b61155285ca@kernel.org>
Date: Tue, 24 Nov 2026 09:04:51 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] selftests/mm: verify ksm_zero_pages is not
 inherited on fork
To: "Xu Xin (vivo)" <xu.xin@linux.dev>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev,
 donettom@linux.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org
References: <20261123034136.209410-1-xu.xin@linux.dev>
 <20261123034548.237302-1-xu.xin@linux.dev>
 <16d172a9-bf5c-4a69-93d1-b48cd53b67b2@kernel.org>
 <awT6Yc/rFuyp2r13@dgvxl46587.localhost.localdomain>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <awT6Yc/rFuyp2r13@dgvxl46587.localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7B4AFC0005
X-Stat-Signature: yh9ghhnw6ywo1r9i771kedoa4qyhfgde
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795507497-701209
X-HE-Meta: U2FsdGVkX1+/ljIlMgrMAUVd2whoru2my4C0VM78BFKXmoJEvV1odiTkyzelBcVZI+PZmglQYtGlruc/3RKgRmG0kwkSVxDm8jNPQ5W0P/em4n0fLd0rKw5TYKOGbAzPBLRVnBMr1/hWZptaMB6PUvGPR5iyZR9MqQpwlbR9Y7oFnY26454RxzhqLCdvWcK6q8sz5qYGrgR/pHn3RJaln74k2eAnf8FWSjl4lInr41ZjS2S0uDPiwFPrCVkeaeZ6zf/MT7W6swlA5nr+4rF6i+Tir/o7g0sGowrZeWrqeUQmzxvrdLoKOghFLVWpaRkzz4F35ViHghvFqY+B+j13Cv56E0c6BdmeFabqgWty8m0v/kikFxbzgT/JSEuaUtIGRk3BQS+a5rRxRDyiJFdEdqce6LHdHzrn6M2KuS8PqcMWt6U39tr5QDjGT6uM3bMLEuxI6skDg/cTVwTDTBk8xxHisEe1Mt6p4E+TxaGF8rybHhjp/cCNvfW8ggNGLM1ragZ1T5XMAls+n5/fHzFhCGH3meAm1MOjqOD2Go7N8zUhiNPaJacJXkdzGR5k1bhIbYukhvTskoHymdMKDu4XklGUbscD5GCyZobSnrGK0O87X68txtPSx6qixdGxoUSJFxHkBtMp7e1DoQyqkm9iDjXZh+qH+qyQm29exoaKArKdJDp68EtGSwnwRTmMPvqNrXVAuUQlw+uwCo6jl0eO4fpLGJH5JqEr4qpNx9G7uwiXIKgGP/snBuEvtXLl8hFj5dC0JwIqt/pdQx6MOQ/H5n/tK7YAEkM8k8c8ku5KDopdADvIbb8mfAbmXLMj+8NPCdH0/xEw14oNq4y4QXvOJ/GdkFf72XcjeBW6nzAxQUAo8Qa1I33ggEw4h8G1uTp+NxDl/JmGrb2Gc91lv2wP6lZVKMeHYj1I8gNrYTUhf71Ms312l+fAG4bYn+wuozL+881gQj8SYxVrkm8oxV6
 OTof0qMO
 rU0oRL4Mrg3202KoHcDiMKxDMv9nP6d3OsiOWBgb3BsCD8lZmcDknWnUGGPEuJmERT5hYBu7mRQO1ql2bz8xZlz0owDrPJuIaaeyKqTytKp9dog6AUTG4nV8cTHujL4QrsCDFgBmFg99CVF7FjvLbicBuKOd9mFGnQh0fczidrruGrom0Q86E7GD52LTUGLMPo9UUl8QJ5jIiH99d1WJN40qOH22LIteKdOwr7YKgdlZPCaQA//xyzh7scIBhk2kWd7f8SB4gqj2cg2bPaLsjdi5qSZC2vm1TUMGDDy66PLuWlSPX5uVTSvmo/BIh/LBU8MxNa21GOjBY+0bQ53uNQr9VQ5pJCjAfTY0dkPU+OyJsbSGT34B/AFUgsAf88bde/im77/gnchv3EWwT06+v/H56ExFQvijW3o05c/Vrc9Ugo8iwVP91esAe2p/8ZHG1zs8/wErNM4CEUGlAJi/KxB7F+f6jfyJwYrYeYHPQY3T0CBbZmAf+RLQIgf9yyX6kGDhCV0qtZeSbuNqz6iichJp5PQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 03:45, Xu Xin (vivo) wrote:
> On Mon, Nov 23, 2026 at 05:49:30PM +0100, David Hildenbrand (Arm) wrote:
>> On 11/23/26 04:45, Xu Xin (vivo) wrote:
>>> Extend test_fork_ksm_merging_page_count() to enable use_zero_pages and
>>> merge zero pages alongside non-zero pages before fork(), verifying that>
>> neither ksm_merging_pages nor ksm_zero_pages is inherited by the child.
>>>
>>> Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
>>> ---
>>>  .../selftests/mm/ksm_functional_tests.c       | 44 +++++++++++++++----
>>>  1 file changed, 35 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
>>> index b871d5656688..0e128c579d5c 100644
>>> --- a/tools/testing/selftests/mm/ksm_functional_tests.c
>>> +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
>>> @@ -655,45 +655,71 @@ static void test_prot_none(void)
>>>  	munmap(map, size);
>>>  }
>>>  
>>> -static void test_fork_ksm_merging_page_count(void)
>>> +static void test_fork_ksm_statistic_count(void)
>>
>> "statistic_count" sounds odd. did you mean "statistics" or "counters". Below you
>> use "stats".
> 
> Yes, I meant "counters" (my phrasing was inaccurate). I will rename it to
> test_fork_ksm_counters() in v4.
> 
>>>  	}
>>>  
>>> -	ksft_test_result_pass("ksm_merging_pages is not inherited after fork\n");
>>> -
>>> +	ksft_test_result_pass("ksm_merging_pages and ksm_zero_pages are reset after fork\n");
>>> +unmap_zero:
>>> +	munmap(zero_map, size);
>>>  unmap:
>>>  	ksm_stop();
>>>  	munmap(map, size);
>>
>> This ordering is odd.
>>
>> Why stop in between?
>>
>> Also, I suggest using a single label, like:
>>
>> char *zero_map = MAP_FAILED, *map = MAP_FAILED;
>>
> 
> Agreed, the ordering was just kept from the original code and looks odd.
> I will unify this into a single cleanup label in v4, unmapping both
> regions cleanly before calling ksm_stop().

Thanks!

-- 
Cheers,

David

