Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFF89CDC195
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 12:51:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416B26B008A; Tue,  6 Jan 2026 07:51:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39A3F6B0093; Tue,  6 Jan 2026 07:51:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27B026B0095; Tue,  6 Jan 2026 07:51:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 123E46B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 07:51:35 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B951E1AA587
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:51:34 +0000 (UTC)
X-FDA: 84301525308.19.849C898
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id A1DF81C0003
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:51:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FdDspAsj;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767703892;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4F0ZC0jAOUKeJK2cjz21QeTVqgVFF5A5YIyxyyxxsc=;
	b=eVbyD8XB4QDgnhgqvedEFfy9ldEKFhPgmHVMwoP4GCFHqvNZbxNzgMQcDywRZLiN1BTWDT
	2yy65ZXK/ozfUBNpjcy/7crColjGSti+DCvLEsbpRiAPwbOeBMvykynOhSeZ48tU2b/jW8
	sZUugWo2I6sW5t4ljEKFhTB+B8nn9zI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767703892; a=rsa-sha256;
	cv=none;
	b=OS7GbO0dsEgwdmyttLXdJh5mTVlKkx+Po/i3L9tYqImXNuJ6hh6VODqFvkL/3vC0p7MMYw
	RS1BwssvXA0wRAu//KzaYjCtnvPE30HnoHMxB5f4aeRIV/SL/IpL/Xir5Qaa/hcuGRW1gx
	ER/OlO9EgzQAzzS3MbtnBo3JpPa/CHc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FdDspAsj;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b76b5afdf04so175267966b.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 04:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767703891; x=1768308691; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r4F0ZC0jAOUKeJK2cjz21QeTVqgVFF5A5YIyxyyxxsc=;
        b=FdDspAsjwi3AWgULlQOZWzrt2EcXXEq542F2f8t3JpTd7N5yvf5GQwDYsaswJSecuG
         rZhSf7Hn6iZbLeUoZyw4gD0+j/7YC6Vl4Akg0zopAtl6H3LPNq7G4kDJdnyDmJ9Iy1vO
         2K3wz42vghZr/lBmw6VudMwy3ath8GfkUM1YniFQvLvLERYMM8zG/iqmi/KReD5EqlNQ
         r4ovCrrMB+GjgM2RL+3lk8u2wgz+9Zz5XdYu6B3Cp2ksEW2lHs43uD9IQTS78frnbywh
         WUpq8Ntn9sAldM4p2Vtvawjn00YEuHkHorjA0ZNvKjGplWn5S9Mhr0c0ClNDcS4iVV49
         /P4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767703891; x=1768308691;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r4F0ZC0jAOUKeJK2cjz21QeTVqgVFF5A5YIyxyyxxsc=;
        b=REAoJoN70cWEgF1oaGLB0vOyJ9cwSdLbJCvD8e2cVC9eHzTwDQpAUy7XyryRbcUxnB
         Iap0JPHHzwbqT06ZDM2lxBOwCCIVp5vOD3FMuapQRIitg/XwfsUxaJlcsqLRjpEufMcI
         KWFojwTH65qjoR2gg/rbVOkJF2y+uOmSZzLN13w1Wls0K8ZA+5aOrOEqGqMXTqdiTbB2
         Tf7vrVfR6v/g8DvCiIgxZa9rY+gY9klg3hx/WYjkYm13Tx9XYL+5YvYlxbI2SWOJDe/C
         WFoklab4ON/n1KAt8tgCiNDroxlybbcPjpdsJRyIJtCT3rGc2gNLjCzGgOIeo4/XEkTT
         fWdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUvc7rW6rV98qtFgq6UttetUyrtbbpIuofnMx107J15r0YwXeIaITMwGYHd8bfNpsYG9/51OcGiQ==@kvack.org
X-Gm-Message-State: AOJu0YxY8i57Kk3O9lNZRRhsDCCQg0/w3CGDVCrHMtR1BFlEfgNfuHbq
	YxngbE/pvaU5kIcD4ue0w4YYE9kVZ2ki8QzDce8A3oBpPzx4yeIc8KwP
X-Gm-Gg: AY/fxX5lNKhYLL2RyPBqnjQkQfsDHhL8+2FQHJFjv848LOdF6MwtFOoWHNmoKI4qa0M
	2mtKGHIZOmfPDUmw04PNDQIY5gUizhdPGaXl8gPUDAjhuWVnmhLv6XhXtd5ppHNYfCHZC6PGaXs
	HScOHbyl5wsIXZPpNhC3pPlJD06JpegtNPl3aQqnaothJ2tr+A9XL45Z1orLphEeBGvOA/0dL9o
	yTKSqHhVerItdYhFwwm9/8UdD7wKhZPpRarTBpxQV81ROLcMCkqiBQ9HjCKYSmV26OhUHEOm9MX
	3RHV5+9rEBf/g+Cgcrn51CddrfLOFaTdtWHH+6z0j85b6+XjaD7tkEiiKaraOyHMPp4tEZRPOgL
	ZRZJ5EKe2B/4fe7Sud4bKcUehq+zAVRqfW45eKq1dWK1zaPyA9oP6UVMZC62r6hKkmpapuIV+FP
	1/rnjSVuSkhQ==
X-Google-Smtp-Source: AGHT+IHyhhMUN8/oFEyhlAoneFtYLSwAYwrjloYeJb/UfDlUdupbWE9uGcMUAToDZDTK5E6CaSoBSQ==
X-Received: by 2002:a17:907:60cb:b0:b7d:1cbb:5dfb with SMTP id a640c23a62f3a-b8426a43d50mr293215366b.7.1767703890482;
        Tue, 06 Jan 2026 04:51:30 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a27bfbfsm218577266b.17.2026.01.06.04.51.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Jan 2026 04:51:29 -0800 (PST)
Date: Tue, 6 Jan 2026 12:51:29 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v2] mm/huge_memory: consolidate order-related checks into
 folio_check_splittable()
Message-ID: <20260106125129.qeq33igoaa5clxls@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251223122539.10726-1-richard.weiyang@gmail.com>
 <20260104023756.jufklyl3bl64fnck@master>
 <7ca733d2-ba0d-4792-bcd8-bc153e7b1b15@kernel.org>
 <20260106095413.aqkrh4byh32qltli@master>
 <3BC7839A-B086-42CB-A1A4-F4FDB513739C@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3BC7839A-B086-42CB-A1A4-F4FDB513739C@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: y7pdnbycemyu3the599wtfminy136tgh
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A1DF81C0003
X-Rspam-User: 
X-HE-Tag: 1767703892-409254
X-HE-Meta: U2FsdGVkX19Qxu21Y7ILiMvlDEQtISpMlydlu68AzMUhVetsrp0MxqlgEHhGocNu+zUCZX0eRQ/687yrLVfyqneVixtGzBiEmqVTn0FJ9yYRCsO3dpmX2RWfg1Pch+cqnAxNp/NICdvRJ2VPu9Yjt+SeGuvEngl8R0A9d+jCD16iTyd8Xg08Y+VTLCfFQ6yg3V6bU0UsCknGIXqLyXbzxLpSq0cZUMSLJbMxmbp9u/gBrKAZasEXHejIXhYL+MQJa49W+O/K8YRTBIz1EHF8ec4ac/nCdxtUNmKKO7wnOx76Xks/kZcTEM68HZARffmV6dtlLpkmk4ekR5se8OuVdNraYLMJ6RPTyqNHUU9cLAbjuxes7i6uT5X1tZS/GnJgAmsZJRPpoWaCw+vVMRrY4DZkEj6/8C0ZWtaEYHMsblwXcgFb6NAOlqW7fMrdYgMCNtj5nCR0Pwk2ju/ZoPDxqFEhwevxboKh4WIYfXo6ZmLGmwAa5sDpwoZR1Jpk2PowDMG4jqzBXRqF49o1RR7AF76r0eUhSA+s79FNnWX32zNa/ZeJd9tg/ceHQvaJveGOYeFP403+VFsxKdI1NFgRQ1zZ6nnUh4SV5hQKiyso5lZkgdUfxEgIck/7o4UHgH9bD1cfty8JqaDnqLW7PUwaWZbC3N7ndr7pD5JBs3b7kRIq6OprT/cKcxyo8eW5QemvzPgQwJCLsB+/9PTfywjJZ4BfDfLRX/ZbDx89+O+Fsw8t0wQ5Zq4PNbMZI6eUcalW5cH8GQS6dtRmq8uTpdojQGuly+IAycloNJWFAJ/zy+CAi8/hQ/ftpJamlCw6bTSuSfaud82BP08OoWR+Aug4q8nu+/KpcwvfhynVux8PmJ8zprNMBSZ+WE1rzkfanMgfnxdiU3/LyzcwiJngsYXjZ/wfbRs+ZcknV1w7NbfKhTQtlbVKmseVkqTikVq9zWfK0V0kc6AWKXs+k49JCqp
 +ni3blkf
 XGou6WLoroeBcthZJRV/sBUWgoT9S4uZ7xZvIdmSE7MiUa7BY6k4pTBuXMwl5anbSOkrtRmkbT/e0Kl5fxy0C74upqe1uz4VbuLcsoOi5YblBxHAIZLrnpLEm/nH6qx1iiAe23pE8ZZmBkLXbYWTXOCRv8mlae5vpOdzk2Rvs4reecQWIPw3P2bZ2372zeaYwPHMIMjqqWPmHexAWvAg3VeB42uUSQygUO//px6ro7LBF7M6ZO5tIRxgHXU3QF5WbFvcSW5Zo9gVAtINMeRhl1pIo0x+2xMYx+uKQ/FJqceCsRj7cfyhj3yEj7vHYQBL+Zbt0FL7V1lUDP1ykNZjZUyBLcW4GYZNg88S650MJe0+vMNYs0sofcd5iE8v0Y5MvjdGV/CPX8uz1z5hgIxbyYLQS5S/67hyPo4mecefqM+YLbCeJVqBBLS/HYDhloWUheikENQEc6Yr4sk64GIyXPUOl6G1KJqWunUGOjgmyoyJy7yiQvFHz2SC5lZfW1i9pC0mSVrZeu1b8kD9Zsrt7ED1seXqznwFV4xVa+TxWkIXZObPnnXNhNqcd4wswWHElU4oQxDgJL4xu0XSs+n2tkjVyN5s4g5XPTIftXZf2zroqCZkdrKeG0swxR9IGj0YiS2ztAylDrpHytpqIFFNa9TTovF6VqnOQrtAAU0PiLWFRGS1JmxFFSOA7rxE9M85HRUOBctGwcAZZ4gvB+xueZRSRXAOqQOrYshaqCKfaFWCQgktFKRdMiBTpOyxBkT5mqaKMvdslTifGpsanzG67XOAUqQJPnRyqEAb7FrlpzhzLxxrGHJLlH2wEy6uNVuhAb1Tp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 07:28:34AM -0500, Zi Yan wrote:
>On 6 Jan 2026, at 4:54, Wei Yang wrote:
>
>> On Mon, Jan 05, 2026 at 05:16:45PM +0100, David Hildenbrand (Red Hat) wrote:
>>> On 1/4/26 03:37, Wei Yang wrote:
>>>> On Tue, Dec 23, 2025 at 12:25:39PM +0000, Wei Yang wrote:
>>>>> The primary goal of the folio_check_splittable() function is to validate
>>>>> whether a folio is suitable for splitting and to bail out early if it is
>>>>> not.
>>>>>
>>>>> Currently, some order-related checks are scattered throughout the
>>>>> calling code rather than being centralized in folio_check_splittable().
>>>>>
>>>>> This commit moves all remaining order-related validation logic into
>>>>> folio_check_splittable(). This consolidation ensures that the function
>>>>> serves its intended purpose as a single point of failure and improves
>>>>> the clarity and maintainability of the surrounding code.
>>>>>
>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>
>>>>> ---
>>>> [...]
>>>>> @@ -3719,28 +3723,33 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
>>>>> 		/* order-1 is not supported for anonymous THP. */
>>>>> 		if (new_order == 1)
>>>>> 			return -EINVAL;
>>>>> -	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>>>>> -		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>>>> -		    !mapping_large_folio_support(folio->mapping)) {
>>>>> -			/*
>>>>> -			 * We can always split a folio down to a single page
>>>>> -			 * (new_order == 0) uniformly.
>>>>> -			 *
>>>>> -			 * For any other scenario
>>>>> -			 *   a) uniform split targeting a large folio
>>>>> -			 *      (new_order > 0)
>>>>> -			 *   b) any non-uniform split
>>>>> -			 * we must confirm that the file system supports large
>>>>> -			 * folios.
>>>>> -			 *
>>>>> -			 * Note that we might still have THPs in such
>>>>> -			 * mappings, which is created from khugepaged when
>>>>> -			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
>>>>> -			 * case, the mapping does not actually support large
>>>>> -			 * folios properly.
>>>>> -			 */
>>>>> -			return -EINVAL;
>>>>> +	} else {
>>>>> +		if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>>>>> +			if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>>>> +			    !mapping_large_folio_support(folio->mapping)) {
>>>>> +				/*
>>>>> +				 * We can always split a folio down to a
>>>>> +				 * single page (new_order == 0) uniformly.
>>>>> +				 *
>>>>> +				 * For any other scenario
>>>>> +				 *   a) uniform split targeting a large folio
>>>>> +				 *      (new_order > 0)
>>>>> +				 *   b) any non-uniform split
>>>>> +				 * we must confirm that the file system
>>>>> +				 * supports large folios.
>>>>> +				 *
>>>>> +				 * Note that we might still have THPs in such
>>>>> +				 * mappings, which is created from khugepaged
>>>>> +				 * when CONFIG_READ_ONLY_THP_FOR_FS is
>>>>> +				 * enabled. But in that case, the mapping does
>>>>> +				 * not actually support large folios properly.
>>>>> +				 */
>>>>> +				return -EINVAL;
>>>>> +			}
>>>>> 		}
>>>>
>>>> Hi, Happy New Year to all :-)
>>>
>>> Happy new year to you, too!
>>>
>>> There was an offlist discussion about some of the text below, because a
>>> couple of people wondered whether it was an LLM-generated reply, and whether
>>> it is even worth the time to read.
>>>
>>> So I am curious, did you end up using an LLM to compose this reply, and if
>>> so, to which degree? Only to improve your writing or also to come up with an
>>> analysis, code etc?
>>>
>>
>> The first three paragraph of the mail is polished by LLM, since once upon a
>> time Andrew suggested me to use LLM to refine my text.
>>
>> Others, including the code change is not LLM-generated.
>>
>>> Feel free to use an LLM to improve your writing, analysis etc. Just a note
>>> that nobody here is interested in getting LLM-slopped, so don't send
>>> unfiltered/unchecked LLM output to the list.
>>>
>>> In general, I think it was raised already in the past, please don't send
>>> patches for code you don't fully understand. It consumes quite some bandwidth
>>> for us reviewers/maintainers here and it just gets very likely to break
>>> things by accident.
>>>
>>> The comment change suggestion below does not make any sense to fix a warning
>>> we trigger. If an LLM wrote it, you should never have sent it. If you wrote
>>> it, you should have invested more time to understand the problem and come up
>>> with a reasonable solution ... or not worked on it in the first place if you
>>> don't understand the details.
>>>
>>>
>>> To the issue at hand: Zi Yan pointed this very thing out in v1 [1], no?
>>>
>>
>> Hmm.. this is not the same thing.
>>
>> Actually before sending v2, I have talked with Zi Yan off-list and he said it
>> looks good.
>
>The off-list discussion was purely on V1 and you never sent me V2.
>The last off-list email exchange was:
>
>you: The related cleanup looks merged. Do you think it is proper to send v2 now?
>me: Sure, feel free to do so.
>
>No one would interpret it as “V2 looks good”.
>
>In addition, if your patches are solely relying on other’s “it looks good”,
>please do not send them. You are responsible for the correctness of your patches.
>

Hi, Zi

Thanks for the suggestion, I should be responsible for the patch.

>I am done with wasting time on you.
>

Sorry for wasting time for everyone here. 


-- 
Wei Yang
Help you, Help me

