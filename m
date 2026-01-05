Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80476C79FA3
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4EA06B0183; Mon,  5 Jan 2026 11:16:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D21986B0184; Mon,  5 Jan 2026 11:16:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF6676B0185; Mon,  5 Jan 2026 11:16:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD3EF6B0183
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:16:55 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 51B6C16013E
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:16:55 +0000 (UTC)
X-FDA: 84298413990.17.31051A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 97B814000F
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:16:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eGrDbTsK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767629812; a=rsa-sha256;
	cv=none;
	b=Z821FCzdDqo6rrtqDAy2919uidOyRmDtOYHQE4xBcG6pW44ZKeP2L06VUrviF65Q2aBDMx
	BOzzWBum//G12u1fPr8naJ1HNn1CbCoO+My/27rBkemmxxyLSOEj5hm2IcOsWzbDpcxBjN
	pPrr00jg2wpzk4wTF21MZA8FF/ek/UA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eGrDbTsK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767629812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bnv7eR4PlTh/VRrHfI/VZLyEtnYDN1oKh0nDU+AEIq0=;
	b=E2OHlwXajhCKvCXwBW5Ip4wyK/Jb/jRXJRi7VWDUz1zb1wWa/KDGmPKDSd35nwv8Af67J4
	ouSjj5eatfZjv/2nzy0qM35BHeyp8+JsitGNa49FGn7GYksuc99AO45mz5LIFDIj6UjyrX
	cFDoe2LOvmB/1pWJ2CTOEhQODMPPjT0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BE7841987;
	Mon,  5 Jan 2026 16:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DB4C116D0;
	Mon,  5 Jan 2026 16:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767629811;
	bh=yJKheNOHT430R7ojIOfd0gQns/RA63NiAXct2IT/Nn0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eGrDbTsKpxwDxVnt9qq2XGlh/fmAKV5dG+pvhmsdLNTfTxwnsH8xvPE62QRLzZIa5
	 2xkMd9QC7nC2xhKfrCwcKaC6zL+EDMFuf/0OgA62R5KMe1yrJMyl0LG4EqCr7LOTP/
	 3iuyzlsU2fdiwjkswSKS5qT1MxlzOzqPO55+a4bb/7w48YUTctpJthTyp+ZGBBcO3f
	 TotDnqGw/X1aG8aC0Baslh41QlCgCk3zqJ1hY1eHOOktA+IrS5+0QoJJh1D1V8oH6Z
	 D0APExT8+wDWRsN5Mb1kMYpYMrgTCTvKHQLuV+PD+LfVetLzm7I5TyR/C2uxkRNR/h
	 eNJOfwMx68ELg==
Message-ID: <7ca733d2-ba0d-4792-bcd8-bc153e7b1b15@kernel.org>
Date: Mon, 5 Jan 2026 17:16:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/huge_memory: consolidate order-related checks into
 folio_check_splittable()
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
References: <20251223122539.10726-1-richard.weiyang@gmail.com>
 <20260104023756.jufklyl3bl64fnck@master>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260104023756.jufklyl3bl64fnck@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 97B814000F
X-Rspamd-Server: rspam03
X-Stat-Signature: hgu5kfnenq1epoo1m1ukfwhysxmk77zu
X-Rspam-User: 
X-HE-Tag: 1767629812-290104
X-HE-Meta: U2FsdGVkX19MSis9ZHRzTmbj1yvwEnIwqAbfQmaDmXZKF4ixD6GtqWtoAp9IEEZxt5/XGmwnHdI4/FLGCCZi+bZLPNI6uul2YwOmwY4XausnLovAi+nqukWSe37gCYTyxyov8A+8c8kXMY3y9HCbvKb6N88XNmnfH+QEdqEDpUy70cpWHCcpG3WtGJrn8OpKQD0luhnf94mdasFgZvHD9BzjIMARquc8x16557pXlLGeNd2uXh33lx9zPKZzB/q5Mk1FmNNazv3FWwU4Sb4VlxgciMMmB+zeoam0brk6GzfUOW9vHYinFdasWwOqiNdgw4yW7UcC8M4byZ9zrwxg3E/V/qqFpLfzFZgWcfq2MxO+dukJQGSTiwS+CgjwoEJy9CvrVSyRQ2jhPqgPSuTNxKu5TA53W7K7B0xQ4yAgZfzmXK8LAuSd1MKOYphlEobTvVb0pM1RtXO3ngmXYHVa+VaN+vidS8aWfy6+UuNF0QuG7RM9tBZdwfPDFkJ8h8IlLW92j7jKajBdxbEMJJECKEKwRx4A+suJ6TeTfcZnCRH3R4dYYOxeE3W+aCNOTd/dywagToA7/7OS+7S8grY07NAXs5GS9+nL0x59Ren9dxsYNYLRlKeqmvP/CRk42kxsybXCZLD+H8FIJkuycsprydqgTpHvDRQZK0uDRPjyPZ6S98wbwnUpOlLafXUlOZ79AO2WEXJQr5t6EAhu2M9kHdaGZeKkKmLXdemChGGBPAu1X2c+dZdAQFhWKc6o7fxSpuisYZvnqJpS7AlXqd812jMNXUkzCBfsbAz4VEZsewqdc/cnrCJM/QQzWSsNrJzaTU/SQf419nr5GAQ7z87M/VrHPiTYFl0Rp8smJRyI01XsHCoaP7fqqKmsrTbrTUhrpnV8hnGpjxC8rXOWEDwQD3XixKFzRZ8/vORT4kXK6NC1/iHGJP92KFoOEovmHH+7WbaibzUPbZV0J6Gy6sT
 ikztYfY5
 zylt0Df3TQPxp9aoNEFfxMV9tdqZwdXQ9xM9sQk5OtqKifWD49+ypmYZpRsxhnRZ6lHJIN9oZUpGQkzsuGEgw/Cvx/N/jVFGRPEEsWbMxIbCP708WDsW6CrVScis+6Sw34FISADVs0ecuqRWtIHz2nZPAzTxV7MG2TgHj69jBUlfMx0nPhTUINumvrvzq3QvHvf7zYm+cJCCQfglZhvcnYpaMbZjAYw6hUXaVb3036Z9jU5HX1Z0dUfG4wnUZzeyQHQT+3AcT35hoeUmUtaRdYF0qnfih2JOtJ5N3TWvb7CuV/UNeWMb3lpcEKaTtY0xPrNoYVSzOfuJMiVrs3vUdCQmYhlUf/9CsAmFRz7fUQSeKWJJT+Qg44pLql/UXJ9Ismgtb7RqHlzOGqWb1pITMSS47d9ZDHvk/jOY7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/4/26 03:37, Wei Yang wrote:
> On Tue, Dec 23, 2025 at 12:25:39PM +0000, Wei Yang wrote:
>> The primary goal of the folio_check_splittable() function is to validate
>> whether a folio is suitable for splitting and to bail out early if it is
>> not.
>>
>> Currently, some order-related checks are scattered throughout the
>> calling code rather than being centralized in folio_check_splittable().
>>
>> This commit moves all remaining order-related validation logic into
>> folio_check_splittable(). This consolidation ensures that the function
>> serves its intended purpose as a single point of failure and improves
>> the clarity and maintainability of the surrounding code.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>>
>> ---
> [...]
>> @@ -3719,28 +3723,33 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
>> 		/* order-1 is not supported for anonymous THP. */
>> 		if (new_order == 1)
>> 			return -EINVAL;
>> -	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>> -		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> -		    !mapping_large_folio_support(folio->mapping)) {
>> -			/*
>> -			 * We can always split a folio down to a single page
>> -			 * (new_order == 0) uniformly.
>> -			 *
>> -			 * For any other scenario
>> -			 *   a) uniform split targeting a large folio
>> -			 *      (new_order > 0)
>> -			 *   b) any non-uniform split
>> -			 * we must confirm that the file system supports large
>> -			 * folios.
>> -			 *
>> -			 * Note that we might still have THPs in such
>> -			 * mappings, which is created from khugepaged when
>> -			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
>> -			 * case, the mapping does not actually support large
>> -			 * folios properly.
>> -			 */
>> -			return -EINVAL;
>> +	} else {
>> +		if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>> +			if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> +			    !mapping_large_folio_support(folio->mapping)) {
>> +				/*
>> +				 * We can always split a folio down to a
>> +				 * single page (new_order == 0) uniformly.
>> +				 *
>> +				 * For any other scenario
>> +				 *   a) uniform split targeting a large folio
>> +				 *      (new_order > 0)
>> +				 *   b) any non-uniform split
>> +				 * we must confirm that the file system
>> +				 * supports large folios.
>> +				 *
>> +				 * Note that we might still have THPs in such
>> +				 * mappings, which is created from khugepaged
>> +				 * when CONFIG_READ_ONLY_THP_FOR_FS is
>> +				 * enabled. But in that case, the mapping does
>> +				 * not actually support large folios properly.
>> +				 */
>> +				return -EINVAL;
>> +			}
>> 		}
> 
> Hi, Happy New Year to all :-)

Happy new year to you, too!

There was an offlist discussion about some of the text below, because a 
couple of people wondered whether it was an LLM-generated reply, and 
whether it is even worth the time to read.

So I am curious, did you end up using an LLM to compose this reply, and 
if so, to which degree? Only to improve your writing or also to come up 
with an analysis, code etc?

Feel free to use an LLM to improve your writing, analysis etc. Just a 
note that nobody here is interested in getting LLM-slopped, so don't 
send unfiltered/unchecked LLM output to the list.

In general, I think it was raised already in the past, please don't send 
patches for code you don't fully understand. It consumes quite some 
bandwidth for us reviewers/maintainers here and it just gets very likely 
to break things by accident.

The comment change suggestion below does not make any sense to fix a 
warning we trigger. If an LLM wrote it, you should never have sent it. 
If you wrote it, you should have invested more time to understand the 
problem and come up with a reasonable solution ... or not worked on it 
in the first place if you don't understand the details.


To the issue at hand: Zi Yan pointed this very thing out in v1 [1], no?

The patch as is cannot work: we cannot return -EINVAL for something that 
is not supposed to trigger a warning.

[1] 
https://lore.kernel.org/linux-mm/01FABE3A-AD4E-4A09-B971-C89503A848DF@nvidia.com/

-- 
Cheers

David

