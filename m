Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93345C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 03:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EB616B0088; Thu,  7 Aug 2025 23:15:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BBED6B0089; Thu,  7 Aug 2025 23:15:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F13A96B008A; Thu,  7 Aug 2025 23:15:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E174A6B0088
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 23:15:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 81FDF1DE954
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 03:15:29 +0000 (UTC)
X-FDA: 83752124778.01.B2C0C5B
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id 71B89C0002
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 03:15:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AVn7eE4d;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754622927;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7p2cRQXKBYMkx/IIEN+NpW/CJNL5It+Gq++nljhLm6M=;
	b=qaeKXomiwnlS2R7oC5KJqFUAvYi31/+Qq0AfnoML4Gwm+hwBhknS9BlHxDmA7GPdtuPPzA
	JH/MAkvn9RmoGloweR4/eCHdKlJpnm2zYefKmqIU4wAEPaIzdgy9RFQjM2El8CcoWa3TUV
	nbUwwJwjudF+ypks8MQyuCAvX3PqB4c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754622927; a=rsa-sha256;
	cv=none;
	b=hxM4wUBcM6SDr//LMSyQSfaE9LJsAQgBFm1zeMspu2mG1t2rNcfUnU/gmnfyGcCu31rSNz
	6UyVqJqS5N9glX5Ru2qFaPhtBGZ+XTRCGTAYjyT2ZykzSYuDOi5z9qR/WVfNIhjPvQZvcW
	QbTKoXuoqHN5AYb+5X1fOOUtSZWU1Qw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AVn7eE4d;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-617d43a5fd3so1323249a12.0
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 20:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754622926; x=1755227726; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7p2cRQXKBYMkx/IIEN+NpW/CJNL5It+Gq++nljhLm6M=;
        b=AVn7eE4dcQQ3HJPExC3gB1UfjlyRTM+Jps2voDtORPDLSb1KuMML4tFKkx9riH/xKl
         1s4o1MvaHQYDhJjyMKFVulM4OxNUNzohLL7J/raOydmG+cu8HRPdUwWPVZkMK19GW6qT
         6SuHIxC0eCkfTM/9Sen6YqNtUViQmSyB5KifvpAgOmXaGNT9vyUQyMlV431Ce3lvePhI
         f34LoeYP0Tg0ny7/fwGD+bt51YaPHQMmQDLxPvqgJzxZ5ggwKYpM9ArOVqg1FhbfwRVF
         MANvn72uP+KORfRe/1ZFNjm9YXws0+wLFuh89Gg6hZcgW9cgFqzM3Zv1YRlTo/cZwNY9
         K+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754622926; x=1755227726;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7p2cRQXKBYMkx/IIEN+NpW/CJNL5It+Gq++nljhLm6M=;
        b=wwraK/QXH8jMgpOcdjKa7h98c9lE5ehC5TK4Klo2Edp1p2WEGNUUGGeAC2T9dtJvwp
         gjoDF29CSSnpHU1WAz1hUlRBq1fpMIHmfENp5dg/NqcvjVukMIbu6tofmKsOFlgORN9H
         /CttMPnmc37l+aseyThy1wfLhxTqfptftBAPiy0TJyuED+mrg8q1UV+Tt6OMinGRZSor
         P1SUZXl+RZ2wETJyutCM+k3k4nPs4TQKmLuSt95Jo7k9+Pww9gilbFrECNlCJ4I1/DhM
         3+UVab68rdd+zmdYdEJ2eqKRfL+l7SOXKDyujl3nhLblhit+UwiSG9edg6xn7YCN+oas
         uzZA==
X-Forwarded-Encrypted: i=1; AJvYcCVhQoX1O84uI/L7f9eddIkppEGtTtxi4s13RQbDNR6qBnCyaSXZil8F21nsrRPy0SOzthxdBfZEZQ==@kvack.org
X-Gm-Message-State: AOJu0YzZXDTNAd7canAcwDhpicj14L+jq02p4mko6WW10pwOFy+OiOJZ
	c7zPVlyA8j6SL78mwYiKz+FKlxNCKhPumLaYSaHN65gp7kLczKVUilrj
X-Gm-Gg: ASbGncvVJ0xAL7RileCt7gzBrwbLaIQ4Vk1a8TgyJo6Dajs4jNKF9q78vLKEzb+iH/Q
	kSzqlr9WGMBZ8UQIGI4DIZQmSbDCyCCkNQsmXXWfPJ+ZsKQrzc9X/82ZuH/2BijMTOuQ1S4h2Gx
	6Ouyq0Pgq2Fwr11lmAUSnZoVlXZpuH1B3i5N0BoTwca7NUa09HXEeOBl4XRJvGKEYo2HwWK0gDF
	4mh1NspaSNo9N+rC9MmyUWi9c/wNQxTZqf+jaJ7NV1BPFqJE4NbdKbfuib5CkKbyL7G+2V0EGNV
	2zpxjDyagILSMgtiux6+rB9FUJ16snNroq+4IKkkpeowmwslRiePRuVGUur/QQW3jYgl7S1inGn
	bgIVLSEbPBZA6EqbyHJq7Lw==
X-Google-Smtp-Source: AGHT+IFGiL/42r4aIJ9cUqYKGKbDsAn3hsJB8LH8rLcDsIp2O0U60ZeuOkBF5REVkfSxfPGLNp7HVw==
X-Received: by 2002:a05:6402:268d:b0:615:142a:c066 with SMTP id 4fb4d7f45d1cf-617e2e57052mr876640a12.23.1754622925628;
        Thu, 07 Aug 2025 20:15:25 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8f17829sm12621571a12.19.2025.08.07.20.15.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 Aug 2025 20:15:25 -0700 (PDT)
Date: Fri, 8 Aug 2025 03:15:23 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/huge_memory: move to next folio after
 folio_split() succeeds.
Message-ID: <20250808031523.g76tmlghuaorjaoq@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250806022045.342824-1-ziy@nvidia.com>
 <20250806022045.342824-3-ziy@nvidia.com>
 <20250807085521.bhs2o6wk6pe7xf5x@master>
 <30CEAF42-ABC1-4174-8D78-C92B8C8AEB37@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30CEAF42-ABC1-4174-8D78-C92B8C8AEB37@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 71B89C0002
X-Stat-Signature: ct5z395qfzdobf7asf3kkb94eayp8s87
X-Rspam-User: 
X-HE-Tag: 1754622927-394645
X-HE-Meta: U2FsdGVkX18G4OsXL1Dd5VnaiegAuJCn5fc0K0OLGMLZSjJp3u39ReqnGhbMSX6eh3zw2lAi3kXgkKJk2oM+XZm3n8XcDo8AarAwLSFjWjXExnNcfnYiKXs2f0q5LEUQA/bJs2xsx8BznR0nHLz0UYn4XP3TRqazKrCqBkfGOz/Yh2cbF98ceMnR9/6UzsOUbcaoFtu+NhWB7azXT6ZQ37iaD90pRty85/VS80c2XfH32vv5z2a1QYL/3nI7QmeUvzAhYiYqgWXfEOAZGLjT2ktaZjiPMUS8NomcKBRfxQz+743g54GMMLfzsU8PJHhsKrrtOdzOxzzR2Uk0ieW2BFYyMKUAedgjDRzbKyaI6siSDCPdGWmbrYxNcns+Ua0Y6dIgy96b/rbbdiczCIZRNGKhykj5euBiItfSLt789c/ZRJczwT06Ctkx6/g0DHPX0/C5R4IQXB3X7SLrs0qe5481j6uQyfhAquBZxtlv7RI2kwwmQNGHL42g0UABXddP4uN/lKKK9v1yY07gDbic6WSsZ2P2gdcd/QRosoSPcjrdJh4F7Fs2biTBmxQle989FFJHhQwZWK/xrwEod9v0ttR9Iz61Q56Hq+IRw5FO5oDWZ8NxwOV1gpacW6fm0sPkcc5MurlNfn5qgOFWVgNO4JCGG5aTXAMeXBxS5Pr+zHOksor8jW4RPb9yXzl3a3skjaaPgpw4jsvz64G7zMLQ6Nndh+IV3OE9SxFQ6cRY7d2836X/JmNFfDGedWvCcG8EkW9oWJiDzYx6w/1xTLFkPPLgQ8DZlmGT3Xmv3Moe5GrtzJEnH23TVlARc15Y1EnWbaByN88k7WSu/D8G1LTUBhTHpXd/rR8OdEYNYmp58bXskq/w+BfkvAwo1MWQVDPsWmQioo/E4nb9MhZzDaOSguxZmFdry5m7W/H+CsJchZ/YNZnIoAKYDNIUFohDK/p/B5ov+lc+Rtc9Pgbrz3i
 o7gH5oNt
 w2ANIS9jfm9uW3AcHdZ4gi5vEwA62G35oi6fWP3AsEEI1AOnOhp5wLKoSdyAvZy2UKZx3ZP2pdWHfKwtumQlMIhoKgzH/xH8zcFYBDzdInAT83CHfE5PH4zLdJkBxcLe4xQXDWRc8L4xdPimpX4A88hLUFjxvJ4TrxASgZeX9cBQtcP08fiI/VgE9wq/jZC0Pl0zNuS61mUdFFYeqYsTHxJq2/ceLItX6f6prIBx4XLbvPkPZwG/E5GwZ9Lb1oam2B2q0r/O+mp4HwXzHXBvFnW2AI9Z/S0YvLuES0dK8UVKXe3dICUZMWPVmABwusgxr92PHdTWYgA2yzOJBd6s2p4vPn/5MxuII6zzeKm4+JVGGpyPL7O1qLJlrKtx32sykAfMAg7meDQ/MvpUuG+g2L4UrcCtu7851EgSGraB2tPtyXreKFZakxLCg5mtOjFzkdJSb2s72pO8KVFC++YFwCRM3h5LizojKmXtNkmAMMfm3MZFA4SNYEp1XOXSrN6Qp79GURQu2ICEvKaJMDKZxhADPw3/hqyavhdgR2kyyS04Ubl+PQ6BqhLIUdCPxI0E3PhcgIG5EPCmSN3/arGZXRqM2MTNPI6+SU3ek6bjg3OCroNx9RYBIWbIHrH/Qau4KgH4fzKj7phda9DjSizN/9g0o9jrwHeK3QRp4mBaFOoCkEXn8x5I7qOBigYQxkkcBpNZSchNkzvFtT2bFzaNG4ZK+0q/R2i4nulZUjodwlkxz8mab5EOLyf8Lk9JZArFp2YRo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 01:05:09PM -0400, Zi Yan wrote:
>On 7 Aug 2025, at 4:55, Wei Yang wrote:
>
>> On Tue, Aug 05, 2025 at 10:20:43PM -0400, Zi Yan wrote:
>> [...]
>>>
>>> -		if (in_folio_offset < 0 ||
>>> -		    in_folio_offset >= folio_nr_pages(folio)) {
>>> +		if (in_folio_offset < 0 || in_folio_offset >= nr_pages) {
>>> 			if (!split_folio_to_order(folio, target_order))
>>> 				split++;
>>> 		} else {
>>> -			struct page *split_at = folio_page(folio,
>>> -							   in_folio_offset);
>>> -			if (!folio_split(folio, target_order, split_at, NULL))
>>> +			struct page *split_at =
>>> +				folio_page(folio, in_folio_offset);
>>> +			if (!folio_split(folio, target_order, split_at, NULL)) {
>>> 				split++;
>>> +				addr += PAGE_SIZE * nr_pages;
>>> +			}
>>
>> Are we sure addr points to the folio start?
>
>David pointed it out. Will use addr += PAGE_SIZE * (nr_pages - 1).
>

No, let me be more clear. I am talking about the addr in next iteration. I am
talking about the addr in this round.

For an addr in the middle of 2M, we still could get the large folio if my
understanding is correct.  Then (addr + whole folio size) seems wrong.

             addr
	     |
	     v
      +-------------------+
      |                   |
      +-------------------+

Not sure this would be the case.

>--
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

