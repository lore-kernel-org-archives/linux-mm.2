Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83DC6EC1EAA
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED2036B009D; Thu,  5 Feb 2026 07:11:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAA436B009E; Thu,  5 Feb 2026 07:11:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA9196B009F; Thu,  5 Feb 2026 07:11:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C92A76B009D
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:11:54 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76771C1D97
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:11:54 +0000 (UTC)
X-FDA: 84410289348.24.2D60B5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C18DD40007
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:11:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cy5LbhI1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770293512; a=rsa-sha256;
	cv=none;
	b=ku+39ZIh8D18ZQ9tXVN/+B+miBKg/tjoXZ8DnaPyl/zyAS54mLSGHiI9do1vcMJLUTLYLl
	2b98n3n85IAlT9tEYN3L+3W4qjad0g5pcHNJ9RFT/pL/PpftkVJE4rAb6L0AIu0IclTMw2
	bidMzX70KVslJTfXbYo3I1EOALoH4yQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cy5LbhI1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770293512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WptTZrl7vrK8qFpFh+ckhXxit6B0fQIKPATI7AzXOR0=;
	b=Cr7U4hoX8HsydiQRrySSTUixhnFMECHBytQroBlzDFDqpoW8O8VJt/ya5VuHpo+L4r6IyQ
	os4goUUddQP402nrkOUcA4K43BnJdYR5+WB5j5CNl3CkEojBpgxg+hJ5KIxPdCnJ4q+ZiX
	EaBvufN8KJVwAyKt99bjKaF7nFt6AaQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 311D860138;
	Thu,  5 Feb 2026 12:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B42C4CEF7;
	Thu,  5 Feb 2026 12:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770293511;
	bh=5b8juVLRpJIKwECed2kY1FSz/yk+/qBbP2U+1GXTFhs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cy5LbhI1Ue9TWm1lcg9AHRjJXfcURt/N46ZWJcN5NJ/IqIqVCCTVYxQGeoiEioJ3P
	 ZT7jHv1yZUTlmtxq0HfVd2pQ9zUd39CY1elvOxoIeoICBIvNH8gnyV86RzvKyD3xHv
	 d3L2liZrssxOdkSB8zoZCPvgoYMJ1TVivkmORl00yvg8fH35IX0D0B1h3KHbfb8/je
	 Pg3Oe7XgFJoe7rM/IzzOZ6ldArjT8pg8a1pBAHeJPkF6dFwlGPpNzrQVzTODOCyQZ4
	 ecJkLQwTGAyj+8cjl72zp0YTHcOE3Qrr7WomJTdlAwF3et5KyXF4OXgdXDi61OIqo6
	 PB63bKhoEKKuQ==
Message-ID: <85e8ded9-a9eb-4663-9c96-93af60006fb6@kernel.org>
Date: Thu, 5 Feb 2026 13:11:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v6 2/5] mm: khugepaged: refine scan progress number
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260201122554.1470071-1-vernon2gm@gmail.com>
 <20260201122554.1470071-3-vernon2gm@gmail.com>
 <fd67a91f-3930-4bd8-886b-13f7783f4aec@kernel.org>
 <CACZaFFNGFWv3FG8spJDLfLTe=0QWuBWL+Lbs+W3h9vGL=jrT6Q@mail.gmail.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CACZaFFNGFWv3FG8spJDLfLTe=0QWuBWL+Lbs+W3h9vGL=jrT6Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C18DD40007
X-Stat-Signature: gyzi94fm55ihr7m8cpeshpfydtc44bug
X-HE-Tag: 1770293512-459062
X-HE-Meta: U2FsdGVkX18kRjXfYuZYzENkKfnrrhsJaml0jNdRlWeKL3oNghx438ARzwELEglpEo+iKIHRl3shpVUPlkP0nu/cBMd5gIWd5k8IStlRfoz+/OHciFwwJodqWIKH0CFjV08A9L7lqBvGE+5KP5LLguIT27tayyZ9TIHWrjcXOjmtw+C/y9OMSltf8/WNiDpsV9r+VW3w9vyeOGOhi/PGk4hP1nOMnVC1GeWker6TvgXdZPZTls5dp/4mDctqACnF9y5cUS/N0MY2fLaHbbnqTHF5KncT4rSNy3pI90yc0claLFVjq56GcavyqtrgifbFaJOe/OfGbgG+t+wBkwJRUsAuQjDw1vumGxQaWqZSqCAXx008BS8NGj5g+HXpuIh134SGmgFbRII+/aEC9fH3qidHB64oonFU2snvkPsaU0g26xwI9XUX/GhvCN6W987D0yRQEiNdyr1nrtLgi5TCqAakQfwODkzfig9z5AbZM+L8M3520Bey04R5RsbgXszXDicGdtGlOA1t+ArVbcbDmvh5lTMsrywEHVWXJoBV4eFxPNQBja4GcX3BbIDKp8zn/SQfEsfKFVIrsL7Pbnx8E1hTzHcaSEBfYR8EER5+vNdlVAzM95Y9kaj8aFqpurvUkoBq75b4sBA10x5WSIiT4c4HGQcmUojMex6glsIYxHPeeMT0mVRVxBwXfSsGqR4j0PyzkhjmN4mw3Exc6hDVsIPLfWJcURhWGEB309bNp3q16Ymhap1zqky2nFUhM1ChFFYE82Kamhb+oThoTrgesIcMTlAt+WuBOD+rp+O56zijee6XRuSPkHspLWVaEDSC4NGmBEnpjwzFmcuwKerlNxkOJrmahfVjwS/Xpdcf+nEOdBkhawhu/0SFOBJjdQ6xzsC5ZfA3nTzhF+M04E0y6q2rJUzN4UeyMfEjoi25yVYiQQdKldv7lEcIsVUp8vhrnUzpQaeaI3w5uk9h8Ut
 bP/MJ+d3
 CI6iD0X2ztqaPnvRAm2o33007CDh1Yo8m4EojE/yV4CQVCpMMQNCFECFjnECvKgcxToiPti63NJlQbRGwWqZBWn+lhBpzu7Qc3YBffwr500p1c9SwYpYxrNOJ1k2JzhYwRQqE1MTx9Xpxm1p65RjGXnjZ2x5nTDoPIciwU2i+rLXsFZkTmxgreEkUxvduZL3cETwtlN2G0YpmfHFBdSuXa825Az2/Ai1os9aihCvUrjYy5cyf6ydnoqwOwVBD7yBHwP7rDSBiNfw7Mo/gRpbxg+PrYsMPoN6Me0Yn8Suazas8KhBbLuAsxa0iQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 07:08, Vernon Yang wrote:
> On Thu, Feb 5, 2026 at 5:35 AM David Hildenbrand (arm) <david@kernel.org> wrote:
>>
>> [...]
>>
>>> +     if (cur_progress) {
>>> +             if (_pte >= pte + HPAGE_PMD_NR)
>>> +                     *cur_progress = HPAGE_PMD_NR;
>>> +             else
>>> +                     *cur_progress = _pte - pte + 1;
>>
>> *cur_progress = max(_pte - pte + 1, HPAGE_PMD_NR);
> 
> I guess, your meaning is "min(_pte - pte + 1, HPAGE_PMD_NR)", not max().

Yes!

> 
>> ?
>>
>> It's still a bit nasty, though.
>>
>> Can't we just add one at the beginning of the loop and let the compiler
>> optimize that? ;)
> 
> I'm also worried that the compiler can't optimize this since the body of
> the loop is complex, as with Dev's opinion [1].

Why do we even have to optimize this? :)

Premature ... ? :)

-- 
Cheers,

David

