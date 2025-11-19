Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3704DCF256A
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 02:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 936836B0012; Tue, 18 Nov 2025 21:56:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 905D56B0027; Tue, 18 Nov 2025 21:56:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F34A6B009D; Tue, 18 Nov 2025 21:56:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C2E36B0012
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 21:56:26 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F065C1602D3
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:56:25 +0000 (UTC)
X-FDA: 84125843130.17.BF53DB7
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id DC6DEC000B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:56:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eD80tEGJ;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763520984;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dOMJS2JDPGL93B19O1WVoKfDxgEhOzXhZGq1xHqsZnM=;
	b=8pVBZsd0VKHnAv+WBfDXtQOpWXEFC4Oh1qQ479DTU1qYM+mdz3y8kZQkJjWPfQZJFmTWEh
	wr61M9lYFEXxAe1tmNM1nXNoLi0VWD9dxfew1eSyhsLdpoO1RQTfa/O3iG4WHIEE8QjOOj
	daa/nGUZoQ1nFgWpjjqD3wF6e3gGlWg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eD80tEGJ;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763520984; a=rsa-sha256;
	cv=none;
	b=jZCIvJmjbwr2rUvnhQuHYl+/JN6DHCwlmTzOHxMo0X+BnBgXIbVwJI8ggogwoTcMA562OL
	NrMZloDwnv58/5H7Awh+MTc0/gk7a2y8mQBWAd124Dd7fMRX0BBXPWoj4sDuQo6ETxnoZl
	pCD+xn+rloiiOVSZJvFI5Y/LrRiB8PY=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6418b55f86dso9991181a12.1
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763520982; x=1764125782; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dOMJS2JDPGL93B19O1WVoKfDxgEhOzXhZGq1xHqsZnM=;
        b=eD80tEGJ5BXrzWW8nh9qih+7hu8SC/trdymrodLlRajCRfVWYrVPnCAOr7QvQa+Bj0
         Urn+ID8w6qxs+joGLAcHIt9KcukD7lreij2bR9Fsx7bHbRILFJu0i84kUmKeOZXNkXH0
         /t9vOC/EvH2x8wbHxx0H2Zn/dqsx1tMu6R3dJfZlTD+4YKEhINzizOVR4WQzImQsZpdu
         rSfnRXYCXI4etlgfTiCX0X6HkcEJKRxt1Sl0Tt54M242sqg30YXW59Cfig2EgJLweIB0
         r/iZvdXkS2c2i8REC3P6vA5GmpOyV259blqz9mVDcPjzyPkDPkUxRiJMhCFlnCwb4TIB
         qGeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763520982; x=1764125782;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dOMJS2JDPGL93B19O1WVoKfDxgEhOzXhZGq1xHqsZnM=;
        b=L97gLUYAS3FgbY1nyH8xyYQi4ELjtNc8XRxmVEmmYBI5iKIjxF66wDWCAWvccXuKdT
         jjkvBnQ+9DmV3fylUTl05m0WZMbRQsmNXjfCPZ8fFnHChoV9sSTnGPVqqyBmskDhuuvN
         lyF27Qo1DETpHQyJmqHHJuhvrbV+2xOROiI2Xc1p5lv2a95bY/iVEJvpoguuLdsXTtTf
         Vp3eUSv2WOAZ11NBeJ6QyF2dSn03YBr63+1PLGz9KHCCWDupja04w5wEGr/Y9aXB4ljI
         FNRPDMH+u9xUBvdZcETbM6WjGm4fNJ8sOBjwBms2rsFrvah09qfx7k68K3gGW1aOqIO5
         3lug==
X-Forwarded-Encrypted: i=1; AJvYcCVR0gI7rBCsAbTDBcDt2jRgPc/zvLWzvp+TKuwf5Gq3yZljqFWNF/H7pybt2NCR0K4tx2Q1Xwk3eA==@kvack.org
X-Gm-Message-State: AOJu0Yzjnwa5M+RdhOLwPiKwctd6vvwvKpzAUml1ep36SPymLYK4wMhS
	KfXcYAuBtqBbO6nzwxxQAPy99pb9JawqQPGJ3xasdowltt1wcFxzk+wG
X-Gm-Gg: ASbGnctmQEfgnWso4Tgn7F6+FJ74XGMybBBRGRoz+qoeCGgw/QFxcKRQyP4DchhliQ3
	0inNOfxt6mh08rNdCoGFJ2QZsDjDC6G6R4Ilik1p14N/tDAdjovF8yhYc/ZhyiWX8sSHEhHWUbd
	rN5y8D8MJiSmKkXD2tL2lM7fTYJmxdZY2jEGDUJufHhPrS66xv5t7TyuNYUxyd9qkdXv5HYwPdy
	APFCDyZrDxhhH1mfBdipjhvpboUqJrSMDlGKp8xtPmvA1vlLAcvW5yQaPePqqhGOFvRSq/59NXV
	4ChYazPLJCaLb63iEHHx1G034lyiXr6L1APg6TpJdZOKnwOydUdj9RprRQz+/joEuR5DkVY145P
	p3Dw3MBA953OS9tJkbS+791uh430MUYcF5+zENdDKtzyIJ9qI0iXabAo/TE6oscEqvoQk8VwrxV
	CgQ/LJ2Js+qbiEplyvORTeZMZw
X-Google-Smtp-Source: AGHT+IGhi0w+JwGlUyZXuVhv4DA2Q1T9H6BZyMqMXOqXaCAUEVNLYLkyX2a8mYzeJt6dtljhrtrfDg==
X-Received: by 2002:a05:6402:35cd:b0:640:a9fb:3464 with SMTP id 4fb4d7f45d1cf-64350e06e93mr16239028a12.7.1763520981972;
        Tue, 18 Nov 2025 18:56:21 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6433a497fc5sm14029203a12.22.2025.11.18.18.56.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Nov 2025 18:56:20 -0800 (PST)
Date: Wed, 19 Nov 2025 02:56:20 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: fix NULL pointer deference when
 splitting shmem folio in swap cache
Message-ID: <20251119025620.mnumfajqrojfzv6l@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251119012630.14701-1-richard.weiyang@gmail.com>
 <A5303358-5FA3-4412-89B2-FF51DA759E28@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A5303358-5FA3-4412-89B2-FF51DA759E28@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DC6DEC000B
X-Stat-Signature: 3hxf9iqo7ooub7it35isu9qsdsx9jsub
X-Rspam-User: 
X-HE-Tag: 1763520983-254316
X-HE-Meta: U2FsdGVkX19R9lXZ7s8IYNyEaBV0buM2UIzcPQNb6i+p40SCaPmQAbCQWlTT9pwhvyNc4qcptMhZPH5kcEHJPXXuI54CiQEZknX6DV1daaPZMZw+AoLh36iX5R7pj5aqseWzYuV3SS4aSzCUWuQD8eaZ6eDkj2TGNuO7U05nsAwl2+URrPjPAH6MiApiiMND3bFKtUEOyFTTfOQmD6tkagQp53B4LUUfpg0TLWZqFM/Rb7sknHx6LjsSowgd5N2aigjv753rtQgu6GR4uyW5TVddn/nrL9z64cewVmGWqC5tOVwEsxGaQFI0C206KNajupNSe3WaxxRe3l8MChfD4uZY5phIgQA92NXlEC1OqQlXnPvaD1fxT9iirvOJb3U8S9vsxCd0NRd0sXAdIEDuJFkuU0W9Mf40mqVxaPX3uJ9XF1kANm1eylbsohuLNcaUsYsxtWKIO/7QJLK69Oj7XHbWMMvr4HMylwHmDUCxjzjp9/YenCyB21iTC3U1Z4UDir3DW2xslZ0gsCCpYPuR0rOs2q+Y5np8LQd9nx30P4nsgeGBX1chBa0t+/cUH1l2n04NafXh+eF+kQC72wiscxnY+OZOQpkl6vSk9RPiczw0xwNOPzVFvejBFGsZBlPakWyoSheS2u3y0X8y4esGFzHgOeqcuUGcXphq5NtDQ6jlp66mChFdxB3kv9d3tCveNwq1Z/5RRv50TKm3gViRKpGVuhtAZz98hx4ZQhYulSHoPoBqfi2jPnGGtyzp/CO7sX1gotGP3F+bTHIiqr6LNgUCcq8QOcm1KhjTJ9cjLboQUxPVtckYwbrIRTtRpSu4yqoWERlnyFaq36moQ3UpCGC4V9vUf6IuXcd6EP/RPqJSNF3iuLUWBgE1gkKy/flTbqykYLQ+8l3HtDYLn5N3XVki4u32+kk6nrOc+uptOlAgsxxplOGb1RrrCwFSAh3RHXKnzFw0ZdOxbv+EeuK
 o0yqARQO
 gA+/Feqks8HfFUG5JrkhU22yn6LGn/A46bXn1bRtpL73eoWWKsoeOWZvnoPUgnudOsrCqgFpzo8+STXXxGJak1RK5xdXfb07IAjBIAm3zSCi+2TK2DQL4dNIYOOYYUCstZQ8l8w9//QBlOOVjhG50EyQw+YX3N2214kpA2oyWWVYfyKg6vpp6N31lUmJAN7/zh9xSZzHX+MM+4QB+LjO2em9rSYmizTjNIisufyzotoFvk+VB4jTUIN6BFAXWNK6ECfxYPfvoIYOFhEIQSObqJQO3P8ytK15wg8A5UezvwHStaBwBjYU9AFe9zU4TD1fZOj5j4l3vPcZKDDCtDxcfaSgQ5IK77Z4bmOL/Nch7z26P7MkhF7heXRyRl3kRU+J4soFHn4/skKlV1Xzt60o4AzokcUd18tA3QnI/JJ+eEv4CZWVDijoZIVHysrTW2BmiJmyuMwS8sywO5a3wT/fqbW0MlVsc1MkO5OGvqkEk70gsKIguKnraDww0ZdfjWkaK/ueMN4lItitqN0aoOPLRO4QaOxWhxOy4zdAiJtgKH70lBb4VPcd9z84g5v22imNJJf7G6kGvy4aUrosTysPglaTJnTeRZETWweAjPk99kI79HpuACC1yWvS+wd2/74DB7frq7O5d7AX+Eh1lHnKhQz7DTscKc5jq8/qpdo2+ZxZAmu1cDM8ligiDVBIPhU+dhAcn/0JF14CFmir4FObcvmBGJ5g6VPBVPqCqtoYO7615fNubEP33FFug+ztHSkE+PEZHDl30XSKTIByzHneHlkpFAUXjBC7DC/Xt/RVo6qjsuBoiENT+6gPzgCbEwQDRitaIz4Qnmt6KtkH+Ug/Ir9+kwbsIYc92HXkGDYUTyCSU5LZ8Jcofzh0cpC/uOm5QVUyM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 09:32:05PM -0500, Zi Yan wrote:
>On 18 Nov 2025, at 20:26, Wei Yang wrote:
>
>> Commit c010d47f107f ("mm: thp: split huge page to any lower order
>> pages") introduced an early check on the folio's order via
>> mapping->flags before proceeding with the split work.
>>
>> This check introduced a bug: for shmem folios in the swap cache, the
>> mapping pointer can be NULL. Accessing mapping->flags in this state
>> leads directly to a NULL pointer dereference.
>>
>> This commit fixes the issue by moving the check for mapping != NULL
>> before any attempt to access mapping->flags.
>>
>> This fix necessarily changes the return value from -EBUSY to -EINVAL
>> when mapping is NULL. After reviewing current callers, they do not
>> differentiate between these two error codes, making this change safe.
>>
>> Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: <stable@vger.kernel.org>
>>
>> ---
>>
>> This patch is based on current mm-new, latest commit:
>>
>>     056b93566a35 mm/vmalloc: warn only once when vmalloc detect invalid gfp flags
>>
>> Backport note:
>>
>> Current code evolved from original commit with following four changes.
>> We should do proper adjustment respectively on backporting.
>>
>> commit c010d47f107f609b9f4d6a103b6dfc53889049e9
>> Author: Zi Yan <ziy@nvidia.com>
>> Date:   Mon Feb 26 15:55:33 2024 -0500
>>
>>     mm: thp: split huge page to any lower order pages
>>
>> commit 6a50c9b512f7734bc356f4bd47885a6f7c98491a
>> Author: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> Date:   Fri Jun 7 17:40:48 2024 +0800
>>
>>     mm: huge_memory: fix misused mapping_large_folio_support() for anon folios
>
>This is a hot fix to commit c010d47f107f, so the backport should end
>at this point.
>
>>
>> commit 9b2f764933eb5e3ac9ebba26e3341529219c4401
>> Author: Zi Yan <ziy@nvidia.com>
>> Date:   Wed Jan 22 11:19:27 2025 -0500
>>
>>     mm/huge_memory: allow split shmem large folio to any lower order
>>
>> commit 58729c04cf1092b87aeef0bf0998c9e2e4771133
>> Author: Zi Yan <ziy@nvidia.com>
>> Date:   Fri Mar 7 12:39:57 2025 -0500
>>
>>     mm/huge_memory: add buddy allocator like (non-uniform) folio_split()
>> ---
>>  mm/huge_memory.c | 68 +++++++++++++++++++++++++-----------------------
>>  1 file changed, 35 insertions(+), 33 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 7c69572b6c3f..8701c3eef05f 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3696,29 +3696,42 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
>>  				"Cannot split to order-1 folio");
>>  		if (new_order == 1)
>>  			return false;
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
>> -			VM_WARN_ONCE(warns,
>> -				"Cannot split file folio to non-0 order");
>> +	} else {
>> +		const struct address_space *mapping = folio->mapping;
>> +
>> +		/* Truncated ? */
>> +		/*
>> +		 * TODO: add support for large shmem folio in swap cache.
>> +		 * When shmem is in swap cache, mapping is NULL and
>> +		 * folio_test_swapcache() is true.
>> +		 */
>> +		if (!mapping)
>>  			return false;
>> +
>> +		if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>> +			if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> +			    !mapping_large_folio_support(folio->mapping)) {
>
>folio->mapping can just be mapping here. The above involved commits would
>mostly need separate backport patches, so keeping folio->mapping
>as the original code does not make backporting easier.
>

Thanks, I think you are right. I tried to keep the foot print small for
backport. But it seems not benefit much.

@Andrew

If an updated version is necessary, please let me know.

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
>> +				VM_WARN_ONCE(warns,
>> +					"Cannot split file folio to non-0 order");
>> +				return false;
>> +			}
>>  		}
>>  	}
>>
>> @@ -3965,17 +3978,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>
>>  		mapping = folio->mapping;
>>
>> -		/* Truncated ? */
>> -		/*
>> -		 * TODO: add support for large shmem folio in swap cache.
>> -		 * When shmem is in swap cache, mapping is NULL and
>> -		 * folio_test_swapcache() is true.
>> -		 */
>> -		if (!mapping) {
>> -			ret = -EBUSY;
>> -			goto out;
>> -		}
>> -
>>  		min_order = mapping_min_folio_order(folio->mapping);
>>  		if (new_order < min_order) {
>>  			ret = -EINVAL;
>> -- 
>> 2.34.1
>
>Otherwise, LGTM. Thank you for fixing the issue.
>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

