Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1394ACA0FF9
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 01:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 366828E0003; Fri, 29 Aug 2025 21:25:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33E588E0001; Fri, 29 Aug 2025 21:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 253E98E0003; Fri, 29 Aug 2025 21:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15B638E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 21:25:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BA8313AB3B
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 01:25:11 +0000 (UTC)
X-FDA: 83831680422.20.51C57C6
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2193A140003
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 01:25:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SX0TAWsH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756517109; a=rsa-sha256;
	cv=none;
	b=suizYgheXcsvfXkWZNHf+z3hJhrB6HV9Pb/XxaWHySocyLGUyWSDwDEk6VCQLubQ5Y7+iP
	I6RXi9+82/ROh1cSo9Y0rfivcULtVy3IIT/zULgpGz8+OxYT0lI4WG75bgGVZJpsobDuqh
	cquEtR3uEaHNEIcKgeYW0uHaxs3qlVI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SX0TAWsH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756517109;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0q0tkB5YsM9LP4ZSbEIQX9izNB0ZawfcC5ZOKdUJ+54=;
	b=BOo2EDJHbvVPHE2rtyGDYewqHfiFgreYCZa0qs+56QPoRWtCcf+lxGZROlqjEqS9Hb3FBA
	rxTkeS3y9hnKSpgxzU9ITSDLK8U2EvJMfOCsDNnPoJiMVYjgVzzLPKiJutouGO5/NA2KEj
	N2EWMj0gjrR2UoviQ5uvUUgo23AlYIo=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-61cf0901a72so3313208a12.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756517107; x=1757121907; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0q0tkB5YsM9LP4ZSbEIQX9izNB0ZawfcC5ZOKdUJ+54=;
        b=SX0TAWsHqytjN46IvepSWiC/+2gRp79NAErwWHKm/n2phl+VsHE0iOCpxgp50Cj8UP
         Q797sTnC4nkSxvxu3Q87WoTvTP3jTS8r0yyfS9F7bYgVyaDzkyXed9hZbFIPl20ycljt
         Rg2vuaINFhCySfsU95RgXhCkeHk1RoPYLpdJZl0aD/uROQzB4QDHJqss/G1LxZlOs50E
         w5W+28eilxuTViTi2VhBeHItboW+SDeVoS982fhn6IaCg+QH3HLoYOa8K0zGEVRXTmba
         TjyGE7GxIEOApVJ5NaZ3kEY7vqRQ4wZhuA1M/rZZRiquZgTJy3cHaGOd3lxxIU5VALkp
         VHnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756517107; x=1757121907;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0q0tkB5YsM9LP4ZSbEIQX9izNB0ZawfcC5ZOKdUJ+54=;
        b=TDq1bRcSYVLeX5nJbOHfgRbIdT8Ja6c1NDwH2Nkq6yALvs/e6MWHwB35vutpr7ppIQ
         bNG59ZMEP4b1pN4N4wLBrFFUo8qJqD/Oh0V1ftUAqnC+HvXAdnNPsWytWXMJq34GQXHc
         CnIV/T4VmNpRDqUR0lnj3ECBG1i+mQ01XyoKgGbfHjchim/Rk1T07IbQul3UZfeWHC9C
         UtgA9A/HwmNwemI7GqVL5oAv6qzaGzsQXZKXGQgV90LoeYkCvwhCMLqMs9OnYsdd1Jdo
         1CmGDiGulbYSMPGnMm9V1OCICkkZqLidqovtCkocK+rk56n9HqEpn9C1KBaDnVPaw+zG
         4OTg==
X-Forwarded-Encrypted: i=1; AJvYcCVNYiVnS3fbSwX4B0Wk0CuzoMN/l8+MZizJQe1jaEaq+cQzlL4qeH1GCndJw+kmvCjRthCmE+WQ/Q==@kvack.org
X-Gm-Message-State: AOJu0YwISls/x7awvYEGbLxhROQKTkqUsq9x09g3UQkSdqjChn+1RdO2
	GFLBrCg9vrRWcEa3uWRhFSpU4O7WA4RP5QHAgF4tve9jmjQlsvg0JdWO
X-Gm-Gg: ASbGncubAqQuA08nUTPYSf7BE+CPvx+C7IcRQm81LmFTEJrs0jtD/8DU2S+uaRDbPrI
	KndAioMnyVxUGQBsn7up9ktIaa+Wgai2qVyFhW1p6ZgGnBUKNVzUeoNxLiwg4MPYdFspSTpQNDZ
	PB5mmfaS9B7kRhnKl45VPq3Kd3s160b/o+6TrSaiBNJRUGJVF2tL3SgdnUKHhwF9NrLE2di7OeN
	BBrBu+UylHPgcW70XnEuiFeWfRuiD3S+b6RhFUptIo8NaEsGcMAPO5xLid4CxgX1KpUsLu8V9dw
	e5a8/g8BOsMb/NuCYtpeMwokFxOFjHjT3wjY3/LhH35UQC4Gai5nwKvB0fgY4PBKXckm0CvRcpa
	EVwzLGCDPlidu3oz8Qm1LMKt0hw==
X-Google-Smtp-Source: AGHT+IG/GuKzo5X2gtGAkxoxcY5RXIL1GuZ1I7XfzhS3F4yoMfl0dXHcnQ+2PwfwYreS0+pXAHZ6Ng==
X-Received: by 2002:a05:6402:234c:b0:61c:e86b:8e3b with SMTP id 4fb4d7f45d1cf-61d26c52695mr560516a12.23.1756517107388;
        Fri, 29 Aug 2025 18:25:07 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc1c7ed1sm2744561a12.1.2025.08.29.18.25.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 Aug 2025 18:25:06 -0700 (PDT)
Date: Sat, 30 Aug 2025 01:25:05 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH] mm/page_alloc: find_large_buddy() from start_pfn aligned
 order
Message-ID: <20250830012505.v4qoihdqi22na3v2@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250828091618.7869-1-richard.weiyang@gmail.com>
 <489045AD-70D6-4167-843D-50A8DD19870B@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489045AD-70D6-4167-843D-50A8DD19870B@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 2193A140003
X-Stat-Signature: fifpy33rnzi9x1j8kiji5y6fknf4dipw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756517108-662052
X-HE-Meta: U2FsdGVkX18Tj6k0w4/STp/gnUd/1D2FvqU7pjg+/fO2rZpUItaA5oHF0lSJ7Nu6zAUF9jaQQssq/hGATJnYGHM2vGa7g+rOvs0SoeOE9Gq6xXohyza9T7fnMgknzhQEUghTfRaIeIFRIBjLCAiSWzDITrjpBRv0jIU546UxQgoiiTNtKl+a55YEXfZeH1xTZiVNRQPNQ+SWSDnLfGb8Zg5Pjh6XxDySCa1hHC2zy+RNzJWpIGZslqqHbqOj3Je3s41VIpQlJgYZQiWLiA57GaMdzHEK6YzknfxazB8kfdApCgKXpRD/Q/+dR594IxYdeerxSCj43yhLsuqwMjEtQrAK8qqdeeOv39BKyNh1ldSkcLfLdm4YVf8gs1b9UR9Eln+po9NjOuk54LP5f4eH7hx6JPAbVNO6KsfZ2SAFtDPPpPh5Cx1ZKPWvwSm4qAcLzcgTMUEbYX8uSCTsuP8nwiVewxxijxMu4MYXsf0WsKsKFMmKKv0/w1OF1PEBIBGtYqRhvw2cJ9KildzVK45GyTXWapN2MRZsPmv95TSLmpNt+0hxdkPZtBTHUEn7dkuy3ySNMTS/2ZR0TGOsF+O3p01ouk7NouzUF1BCc/XhB3A0eZJTuCONZYziwcBtdfZ/5YgiNBv9nP/yr53rtQNxtHfsVOJsw8RykFNbNivtyjzM2loJmq4ltTDcTwW0CJM1u+T6Qk4d0Dny7Y3uxOniZLrOCS93g45fxNQd3YvNvFfNz3Cb2NF5RRe+9omkbVxnutVVosI4PjxtIXVvqa1A9ShY2St5ktGw1zfgmyDyv84lhlXF5ONi8dhtNRnz14ekqnP+VELgVhksMcrH3Lh7BP7paA6miKk+lCyJSnT3gQf/i/xp4T99J9pdgscNxKWBt4V1ufb9xhjmCzMVdCr5UluYTuWBKo87lkFOFhCKPw5+7dadpToXf9qQjuTL1leqNQ2pOz5eE3FGCVuO5rM
 NBbUMGRu
 sw3H/U+vFrllinAC0nalwGjqfaZBMKgFFgQajzr+79nwG1KyBp+/dXfr/d4gdb788rX6SIARHFZa8tDU+kLqGRnQkdf3bgngesm9Xl3utvLcUNmbw8RKe+v8XIbcw8ZmC4RbCaLR0yUfy5A+ck888s3YDKTLodVaHm/aWFDkv/NqYqtkWNcQ5SrQo/9Oo3SyyzP7L58neDsanq19b5SP+jt5M82LcDAyGL7aSJZPa5RvRdUB0MlNFICRRFpErGQWOIjBXBuXx7xA70Yhkhk5RkX+2vYbGi0wqes7hHzbPg7M8iBHeC6MfH0mN8dJWDELVaxI1yJPBVcqKXitpYcgNkZPC1xjC6nA3N8uoeQodGtqDzQ5wEc6w6PSjeZ5/oA/rVUIx4OTb0dEHSlyW1TfTAzqsADlsbbK1OfNlcez/o7YZulijQV0Q9SCadow3jfbgIlH52SVR32mhAWXFtI+dC/p4EdCe2qFufSP7O6s0Ti1AauR3XCJOK4vqQxiotOx5whNhH5gOkC/Mt2XbpClyJ7LRbjaY50mS5oxH/72g3j0KWix8akUu7ft83zL8eXiTYG9E6e13gitU4b/YW31+JoNP3mwI7QM8cv15q0C9KzeAiFbP1xr2LjWsQKupXFBNB2AKemrHt7s4f5MutfzI+tEGG/o/8oXCQSBau6MH7juXxWjHsE+nl9HN78QfUvL6SG11lZ4LD9uwI+FgBlqDb0GRjLeisF5XNp2dVIbLItlFrNfw5E4ElP2vaidPqmXD9pj2r70P85Pv94BWCfsY0WvRm0p33bRw7CDFeawvsWJy3uaNjdg6tAQl0M46H+M8dzhEBTpxnbXMQvPnHzyE3XQXN6EnlzFvLnNPaSxcUk5BGoSvCFRKZPh2Z0W4zpP2eWWO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 11:02:33PM -0400, Zi Yan wrote:
>On 28 Aug 2025, at 5:16, Wei Yang wrote:
>
>> We iterate pfn from order 0 to MAX_PAGE_ORDER aligned to find large
>> buddy. While if the order is less than start_pfn aligned order, we would
>> get the same pfn and do the same check again.
>>
>> Iterate from start_pfn aligned order to reduce duplicated work.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: David Hildenbrand <david@redhat.com>
>>
>> ---
>> I build this and run, but not sure how fully test this.
>> ---
>>  mm/page_alloc.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 27ea4c7acd15..7f2dfd30106f 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -2033,7 +2033,7 @@ static int move_freepages_block(struct zone *zone, struct page *page,
>>  /* Look for a buddy that straddles start_pfn */
>>  static unsigned long find_large_buddy(unsigned long start_pfn)
>>  {
>> -	int order = 0;
>> +	int order = start_pfn ? __ffs(start_pfn) : MAX_PAGE_ORDER;
>>  	struct page *page;
>>  	unsigned long pfn = start_pfn;
>

Hi, Zi Yan

Thanks for the review.

>I think it is right, but the code is very subtle and hard to understand
>after the change. It is better to add comment to explain it.

One thing I want to point out is in __move_freepages_block_isolate(),
find_large_buddy() is always given a pageblock aligned start_pfn. This means
if start_pfn is not a free page, it would always try 10 times until give up.

>
>Paste the code below for more context:
>
>        while (!PageBuddy(page = pfn_to_page(pfn))) {
>                /* Nothing found */
>                if (++order > MAX_PAGE_ORDER)
>                        return start_pfn;
>                pfn &= ~0UL << order;
>        }
>
>
>
>The code tries to find a PageBuddy starting from start_pfn starting from
>order=0. When entering the while loop, it means PageBuddy cannot be order-0
>and ++order increases the order by 1. Your change fast forwards the process
>based on start_pfn. If start_pfn is not an order-0 page, based on first
>set bit in start_pfn and how buddy page is chosen, the next possible PageBuddy
>order can only be __ffs(start_pfn) + 1. Your code starts order at __ffs(start_pfn)
>and it works because "if (++order > MAX_PAGE_ORDER)" increases order
>to __ffs(start_pfn) + 1.
>
>Can you add a comment on your "int order = ..."? Something like:
>
>If start_pfn is not an order-0 PageBuddy, next PageBuddy containing start_pfn
>has minimal order of __ffs(start_pfn) + 1. Fastforward order to __ffs(start_pfn)
>to remove unnecessary work in the while below.

Sure, I would add a comment above the assignment.

But in my mind, we are not farst forward order, but start check from order of
__ffs(start_pfn).


How about: (not good at commento)

	/*
	 * We start find large buddy from start_pfn order, since a
	 * !PageBuddy() means all lower order page is !PageBuddy().
	 */

>
>Feel free to reword the above.
>
>With the added comment, feel free to add Reviewed-by: Zi Yan <ziy@nvidia.com>
>
>
>BTW, I also notice that when start_pfn is an order-0 PageBuddy, the
>"if (pfn + (1 << buddy_order(page)) > start_pfn)" check below would be true
>even if there is no buddy straddles start_pfn, although "return pfn"
>gives the same results as "return start_pfn" (no straddle). The original
>code before the addition of find_large_buddy() (commit fd919a85cd55 ("mm:
>page_isolation: prepare for hygienic freelists")) checks start_pfn == pfn
>before the straddle check, so the correct code should check start_pfn == pfn
>and return early. But since current code is functionally equivalent.
>Maybe adding a comment about it would be sufficient. Something like:

The comment above this function says "a buddy that straddles start_pfn", this
looks good to me. An order-0 page that start from start_pfn also means
straddle start_pfn.

This may differ from original logic, but seems not wrong.

>
>When the found buddy order is 0, the check would give false positive,
>but the returned result is still correct, since pfn is the same as start_pfn.
>

I prefer not adding this.

>
>
>--
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

