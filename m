Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAFC6CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 01:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E673B8E00BC; Thu, 30 Oct 2025 21:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3E808E006B; Thu, 30 Oct 2025 21:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D55598E00BC; Thu, 30 Oct 2025 21:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C1A888E006B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:50:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B2C612AB59
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 01:50:58 +0000 (UTC)
X-FDA: 84056730996.23.3D33815
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5C2F720007
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 01:50:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="eei/2bSW";
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761875456;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pd5aUGoNZBVk+hr61/uMOtMCbuzNw/EBXyaze1BnvIQ=;
	b=IMbLn7bNcRjdcphE76sjjFQei7pEDlb7pSb9C6r94TTIbdJXf47GySDJi6CxYGk/z/k6KM
	dWGv2Zs4BYFNL/y8y3qj8/XzWDuCIb3+hJXW/Fke05r71PYM/r4ARo3D/65jtAoLdSoslv
	UeQ1BhtngyTFO7LoS1zflc5FHjFYJro=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="eei/2bSW";
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761875456; a=rsa-sha256;
	cv=none;
	b=uO8bQdQ2wPPf4uqmH0zh6R1hdypF8+ZzQauBEAM5ESm6QEw0bQ+F+3K/umacEgHIc25jXf
	ukplG7+MFeeP23r8AlCFk8psVp5v7m64B53bxgeXZ2ftSjuBwqAHwMg1deGzj0hcIJhRoB
	XSKfK0qvqUg8ZyPISKy7ECq3Y4sjj/g=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-429a0d1c31aso1172789f8f.1
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 18:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761875455; x=1762480255; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pd5aUGoNZBVk+hr61/uMOtMCbuzNw/EBXyaze1BnvIQ=;
        b=eei/2bSWPlM170AQatDtN9F0gUyLy8YjoLpdHC/Agq9/woRwVVMpUw3YPvhMqeKDnK
         EMG3QYD8VR8DA3hZKH7s7jWAbJdGOpnDRFW17vF1Nm5pkXVqKelhocaL7+CXWieWiz9r
         IuNqt0b5x9S64MpDTbQc6fzaL8Y1ISTQdRZGSYRH0ByvWQtMOMswaHyRA1PhSzGgmXSm
         dWV6Fwtk38jd9ziE9EkH18OFfyvmsqJDmA+QMEfF+pL0edZ2cycuVmZhd14rS0LIZxFC
         fNRxHtLvZiPHADPSXyhRPY0+YWHbIX3QpgblaHUuFJmoQNfL4u5/1jBQpJin4yeKcYFy
         Njdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761875455; x=1762480255;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pd5aUGoNZBVk+hr61/uMOtMCbuzNw/EBXyaze1BnvIQ=;
        b=VqebZde5iC6XKueSDgDx//U2Ge5OpzRH4Zhbl+JllDG42dGpfOoniJy3gQp7DSllWu
         gXTf8ug8XjjUrL7dvNR98YhK5GauEt0gBqavRPhfoB/0SIS9zDsyqHzL/PviRgboKtG3
         /10GWVqgEvvr2QLJWfwPt/sWCktiKdtxVejL+KRuNruS5MO0mpwkaNHy6H6ut9R7G7U/
         SF89n/3Jd3vnUKzkBI8ULq/EgUfJjhOfE+nzoB0lmAFUYizPerR0q50Jl6cpAR3MjEDV
         nRT/6dRP9Xeq78Gg4tFcJK3wxNQVeBtWk/Q4u/mNDFTMv0dmCo35raMtK2G9nu85muX9
         lNnA==
X-Forwarded-Encrypted: i=1; AJvYcCXkTyBrvNMaVPeKepfedJhty3Favf8poiPlJeLaMNbQilrzZwAk+yoh7jCO+ML02iLulsR5GydNGQ==@kvack.org
X-Gm-Message-State: AOJu0YxIAyr8yhmq6v8gMXVzUr8EC2vukpq7q7aKAlmIRL6piPT3P6Ev
	Qhh9e1GHOGO4r0ckeGkrTUhW8/my5n48pj4iuX63Peq40zGOKHwcLzhQ
X-Gm-Gg: ASbGnctCNtdTOy8guImp1zq3oE9ZzO+1LTVCZq67bHKetMaF9KSTrbMtohf7yOov5VO
	e0A0+pDl6BM10MJXsGGh9E+cKqMrr3FWL+sxYX+e3qGnpynqKq0dz0U4rb+ZYebT2QMyZAuffpE
	LUrL2omaROhhko18DTO1WnqlBbMVE01NuD+rEXDgSg+nz6g55kdjhcVblh7tHcPzOEPPiAbV58K
	hMacOG9B82Pd0YuPwcQNxeORnGCB4pNVT41YUCoeHWFYGSuG5Bvh4j6pq/DlekD7xPiMKLEWpk4
	heI5or43IFoyLFollj7whaSECHRBvOS42P+X0Tx3eRRsrq3ZgmtneWqllkh99ke8PgPET9+YPs3
	UNmRPBIaWGTbBrtaUq1DiUzfZyc5ERr23A6lDGlTkrmmJ2dH0wE5gEHKJoKRN8KfQ2PruT2ycVr
	LDSYXjLGiUow==
X-Google-Smtp-Source: AGHT+IEPwOcqdXpWrdXFPwAUbnQnB/nEzGVZP0UiQn0glhnGGOtZqkmqEtvzcTfFxxlFmv9h0yFMvA==
X-Received: by 2002:a05:6000:4381:b0:429:58f:26f with SMTP id ffacd0b85a97d-429bcd84e89mr1580727f8f.24.1761875454645;
        Thu, 30 Oct 2025 18:50:54 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c11182e3sm635456f8f.11.2025.10.30.18.50.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Oct 2025 18:50:54 -0700 (PDT)
Date: Fri, 31 Oct 2025 01:50:53 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	linux-mm@kvack.org, wang lian <lianux.mm@gmail.com>
Subject: Re: [Patch v3 4/4] mm/huge_memory: optimize old_order derivation
 during folio splitting
Message-ID: <20251031015053.n44qkbtnmwbtpfmv@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251021212142.25766-1-richard.weiyang@gmail.com>
 <20251021212142.25766-5-richard.weiyang@gmail.com>
 <f1830e4e-1630-4242-be0d-1cf65f20b54b@lucifer.local>
 <9A89CDDB-7C17-4804-8240-E068EA68F7D2@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9A89CDDB-7C17-4804-8240-E068EA68F7D2@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 4nqhrr8taczbk9nzaae8tcec79s7dhhy
X-Rspamd-Queue-Id: 5C2F720007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761875456-74844
X-HE-Meta: U2FsdGVkX18jHpk+xPmiLrUr09IWBo/VCWmWU7lTHSv/Ai9S1s8z1/1v2o3hDkjzFeIZgsg3U1K1TtMaEGo4Oxsn9y6l8f8hlVWr5SQmQslfy16yplChmhKMBOeekJiJPv+P3ZFuFpDxNHyaNbgHBomlgakxRpXvmN+u5cFxxqZsB3NI4wMLI0YMKVUFNRgz7m/8HGF2gBdhqtvFLPMjl9jTKVHHteyFe4GLgSN6U0I+lvBsTzH2p2zR77p3phqmOgV4/L0nxwZzcDpujCbNETikyBsRlWy80HRZ7vzuK5sLoP6HAXZ65LsBSiyt8ZWT7xMJ9DoQw3OuBlSfdUeL/isUYruzDTedel5xWAD+PEqPxbqGIveBhRjXt0UzX+eDMl+POlKET79US7DmlFarZpdb6cK8t2J1Oi/QjKY/xyu+PSssCHFo9fT0eAh7OIUpMBL30+6dNjoJyZgCyjimqWnnfeKPU8RPvshuw2bMYrSnDn9m/npBwvGCx7CerAz4FwzIYc5rWTGvkzZ2WU6nbx6YWYr3ejFtEoM8rXW4lfzE33FqFvI+KKERNG3pCHj96jxDZpUm8ue8k9TAKmVt94QrMUoKSu5RD/u4I/32t2B5eCOJ7RyZZQPPSU12rdfOznMTFzot6v4Gq/iLkwvpFwdjdyzxZeD9jm6jtbvMiVSt7jOC2sS/uYMO0pKE6LnZPAFxMkBeEQRbisvQ7LWygC6NRP2jg82f/altiu0m8eFv3pThtQ9mtMb4+6wfvg37UCAZ6kG9RNgUtWYRIR+jbYx34EWu4Ny58bb5M+wu1zZH1ExcXCb/TnRcG4pASLTrpjUGt7Ss7Z5gkEGoQYD7zBQgupv9p/SHohZqo5USQM1kmIe6N7bc8L6tH9xAdFt3eTs8TQFVIaZxnCp1yYmBy1bUf6LtfkyxDWF5N6BXgJe7L3Gd2INllbahluS0NFsLvIcyE4lpwCSmQZnvZa3
 LCrH3tka
 /D8hyMoCaNcmI12aCyy5AtAuh0Z5Eql6ZEGp+LmdTu5nfa3i5xDQFOUb4yl2rcwQTtXpyvOXB9TqhmN5uhtegjQKvELrUOQvepnrdeDLR/0hIci2DDclOJAO0MTn419QREMdO3okkWEbK/0SUlYxQLwtMpMKWpHalyWRlvm4B3U+UZB5LXKLpV4dXAuGQZbbuKtQNDt4hjzwT3gmGa/+wZ537WOyVH/E/fRDQ8J0zmLHTREhOwGPj1iFn1yCxWUowgEE8OxavzciUN3fXIIl+Z+CcWDIU1Lh0j8X4ySFwtJwytx7YWPglMzA2ZmEo5djS0dew7HcQOa3VaUjl0XjfFILd7cuG1KWIUkEQPAnHwMVA5GWl+YTHLwroSDQj8UePyW68GrqgnqXc8xqy5pyibsh2Gr3QZJqCrJgdlJup/3MBVWo2wUZcDwXYiBmvlWmqiw1lSScBbJw2ANseo3uipFrqHE9eoTG+vTMfWhIp7g/GEaPOYEQb8H0pJjDqL4ZS163Ut9tnuhj6C0OFIjG4QV3CoBHfVWCQdSYAqTN4YneiSEKxeuAqD6VKN+1FLGMRZ3Xv5mC6CKlg02EsqsXIvVaeBBfHwkrS2ctDVj/dXrvVr+NvLTQGczP+wqsGXBx+eGDuCYcxDDHRAS3ebP6odEHUsXlVm85/vrTwCEFjoPhCjdGaVDh3ajwVb3tWRPSpf4Cqucd82IICE8skN4GOcdsgUE+hFmdQPTyngnMs6K95xz4QRTlu9ifra9vkhIHbO7zR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 11:29:00AM -0400, Zi Yan wrote:
>On 24 Oct 2025, at 10:46, Lorenzo Stoakes wrote:
[...]
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 093b3ffb180f..a4fa8b0e5b5a 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3596,8 +3596,8 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>>  		struct address_space *mapping, bool uniform_split)
>>>  {
>>>  	const bool is_anon = folio_test_anon(folio);
>>> -	int order = folio_order(folio);
>>> -	int start_order = uniform_split ? new_order : order - 1;
>>> +	int old_order = folio_order(folio);
>>> +	int start_order = uniform_split ? new_order : old_order - 1;
>>>  	int split_order;
>>>
>>>  	folio_clear_has_hwpoisoned(folio);
>>> @@ -3609,14 +3609,11 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>>  	for (split_order = start_order;
>>>  	     split_order >= new_order;
>>
>> A thought for the future - now things are simplified, it might be nice to just
>> separate out the core of this loop and have the uniform split just call the
>> split out function directly, and the non-uniform one do the loop.
>>
>> As it's a bit gross in the uniform case we just let split_order go to new_order
>> - 1 to exit the loop.
>
>Yeah, something like:
>
>if (uniform_split) {
>	if (mapping)
>		xas_split(xas, folio, old_order);
>	split_folio_to_order(...);
>	return 0;
>}
>
>for () {
>...
>split_folio_to_order(...);
>...
>}
>
>where split_folio_to_order(...) just
>split memcg, split page owner, pgalloc_tag_split, __split_folio_to_order,
>and stats update
>

This looks reasonable, while I found we already have split_folio_to_order().

>>
>> BUT - let's please save that for another patch :)
>
>I agree.
>>
>> This all looks fine.
>>
>>>  	     split_order--) {
>>> -		int old_order = folio_order(folio);
>>>  		int nr_new_folios = 1UL << (old_order - split_order);
>>>
>>>  		/* order-1 anonymous folio is not supported */
>>>  		if (is_anon && split_order == 1)
>>>  			continue;
>>> -		if (uniform_split && split_order != new_order)
>>> -			continue;
>>>
>>>  		if (mapping) {
>>>  			/*
>>> @@ -3643,7 +3640,13 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>>  			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
>>>  			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
>>>  		}
>>> +		/*
>>> +		 * If uniform split, the process is complete.
>>> +		 * If non-uniform, continue splitting the folio at @split_at
>>> +		 * as long as the next @split_order is >= @new_order.
>>> +		 */
>>>  		folio = page_folio(split_at);
>>> +		old_order = split_order;
>>>  	}
>>>
>>>  	return 0;
>>> --
>>> 2.34.1
>>>
>>>
>
>
>--
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

