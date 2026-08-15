Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F903C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 01:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 105D06B0744; Fri, 14 Aug 2026 21:55:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DDE36B0745; Fri, 14 Aug 2026 21:55:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F35CB6B0746; Fri, 14 Aug 2026 21:55:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B75C96B0744
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:55:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E8001A02C6
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:55:39 +0000 (UTC)
X-FDA: 85101837198.22.7FE7922
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6218440002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:55:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TXwkcB44;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786758937;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KJfedCHwXV6kZVr0Cknx5A9jpM+kExPkRG8SEE/c37w=;
	b=4TozZSJnf3YW+zZC4h3jUhgxWG/ZxrWH3lo34WTdepnnTEtHulQjT5dxLhMGwb1hAPomYt
	CQ7oYtQf++Vi6oP5fg5Fm4PnQfQnkGOqK+3zTmj813s7OU8gwP/MNJWaLJFLPzAUKs8iV+
	xONX5CMvVyAo35LReA/6rdFdjSknIYo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786758937;
	b=ngEJbI1a/QewznqFFlJXJBvi81+VeYxaq9su/vYSZTNKtjat9TteSjxvoFeC1u8NOmvRIs
	0v0GByUJ/aIhb0LBGeEbExQB5advzDEsC0XJCIPHvOhx2evAYERGfYXcT3SXYtix4TDIq2
	lhzygS6OxT56g/P5CPFzsQk8E7wZKIA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TXwkcB44;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c197e7e4e94so294214366b.2
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 18:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786758936; x=1787363736; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KJfedCHwXV6kZVr0Cknx5A9jpM+kExPkRG8SEE/c37w=;
        b=TXwkcB44eFw5UO2FRjMvq5fo/lAHdUkbhQLxEJNCPL7sW973yFlvTg1lB47TCkKwDy
         sCk9ePLMq3CItaGqse1jXcpl3mwN6Lbcdl96PLpdBz/ft/ZBuTmyyR/OpAHbj8xT3rY8
         ZcnTdFVeJIvM7DoFshQdWFBxgy15JAX6VTsAQQxIvhyuqqCJQYDDdpAl7tsHiGNuJpf7
         0EgKyg83076rOmg8/UJ9ZNAsv8Sv9E5K0gzAPKQYMwUXbV0Ymz4ONTyM8qhFkpg1oQEl
         QuDosY+iLu1nYL6KkdpEUfE0zxvcB66hO4fWEsle5oS7gG9BsgPKQDX2dlSL4hNwV8j4
         HBYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786758936; x=1787363736;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=KJfedCHwXV6kZVr0Cknx5A9jpM+kExPkRG8SEE/c37w=;
        b=TNzp69OGfVF6DuEGZfK3HAuGWmpfbGMZgcFJTTOzz2lNZND3BeH9VgarENFMUBkNIt
         1BmFG+YQkcX8dAJpH+GUsOctclLcqpT1a4Q6fw33feD8RVzOGiXf03hj5mEk+y2We4Tg
         p1ufBrSivGbbXgQrZD6GHp/NZCUdOvFlk7qMpRdSr2LiY/vD9E1zpGyB04sGgmhnbPMm
         yfB4cV+HdSXJNBcNSMvXEFtDGm7Yfb7+eFq8vB+gzWrqJ0j1Wty+b70YC3iwhnDV0s96
         Zyk9XU9lkozY8um0OdBtoSCcG2S89X8Z1Cu/mFt6rOlwXEF5ZB7A02xfReYhm7luXrMT
         40TA==
X-Forwarded-Encrypted: i=1; AHgh+Rr5Ziav0VidZsQWh1GXI5gZyHChHjqR0zEeUuS1UjJ+Giz07wN6/onEfVZ+D5UIvLs7i1qXTQNESA==@kvack.org
X-Gm-Message-State: AOJu0YywT9L0jJupmPGFH8ZXr6/KYiDb8F17jZ6vSiXMeT9SAiLRZgrk
	e3M3zrwmo503My4jOyM9LPiwctCMpBpt+4gyAPwaooq7dc4UebYBCr8W
X-Gm-Gg: AR+sD11cS1noSgkIiJEzKRQifdsawqsfQWKHYdJRgx6ikYKQ/ukOwHd2ntEg9cbGI1s
	G9BzXXNBwuraublDiHSwKkWIhbpD558V5poJO45wkdti6/0e9YHsrR9bVcOELplMlCkpLEF+2gn
	JpZQHp4qq8b+BIWex0Ek2Qj1BSd7rnFRXGKrdmfwZrTnYgahcJMdDdjbdJlNRUklSCcbchQIRti
	nQ1Vaquo9xbrDEUm/XJN/mr/CHp78VXy+669jh8iwhvmPiR4rtGd/3TN3t8Pf88+vdrR4B8K15x
	XaLIu60SwTxtup8gHPUHVME2/v9CkEG4N7Dh7OhbF34/VJGZjcFuTnKQx72R67D0C4T8QtFqSJC
	vq0pUdLhhi68viuhfZiGOBWeFVXty5EBPMwFbarxPLp8YPxGWYXgFf9Ru0N34A18SHmnQ7ZgNYQ
	udhNO/aT8QIlE1hDUA4snPP819q/LGqiWDw+ox6NVGqEENRYpUOSgnwGNVAdb+SgtjAUWIbA==
X-Received: by 2002:a17:907:7b9c:b0:c19:6104:e5e4 with SMTP id a640c23a62f3a-c212a2b216cmr427391966b.20.1786758935575;
        Fri, 14 Aug 2026 18:55:35 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c212378d9fcsm168007966b.34.2026.08.14.18.55.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Aug 2026 18:55:34 -0700 (PDT)
Date: Sat, 15 Aug 2026 01:55:32 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Liu, Yuan1" <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Zou, Nanhai" <nanhai.zou@intel.com>,
	"Deng, Pan" <pan.deng@intel.com>,
	"Li, Tianyou" <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	"Zeng, Jason" <jason.zeng@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 1/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Message-ID: <20260815015532.ei4abygk4erdtlhh@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
 <20260723084946.189392-2-yuan1.liu@intel.com>
 <a15107de-ab16-433a-a504-72c3e8dbf2a6@kernel.org>
 <PH7PR11MB6932A554A6D18A4F1A29E90DA3D22@PH7PR11MB6932.namprd11.prod.outlook.com>
 <2cbd42e1-b5bb-474c-b0e7-ce3f46541891@kernel.org>
 <MW4PR11MB6936594CC6B15968AAB781DCA3D22@MW4PR11MB6936.namprd11.prod.outlook.com>
 <0b02ef3e-363f-4b49-a208-54cdfea56c75@kernel.org>
 <MW4PR11MB69363CCE15647FD7D85542B6A3D12@MW4PR11MB6936.namprd11.prod.outlook.com>
 <f0593f56-870e-4e79-8552-1760fad255bc@kernel.org>
 <01795519-54e8-4ed8-a94e-2b77780abc3a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01795519-54e8-4ed8-a94e-2b77780abc3a@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Stat-Signature: umw9ms5ataegrdqxcmfme63x9tpsdxd1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6218440002
X-HE-Tag: 1786758937-975939
X-HE-Meta: U2FsdGVkX1+JBTEdo3J9ciZBoqBVqq2JevkjUNEwKRpSGjK7oHBLXgC8VrRrW+h82qkyqF51L9QmmV9PdDDAJf9ULXZpWL6ISivWWo0ZMSso7OdmK87Eh5dt2vZIXOgX+tKox/Cr1ZROGaSrq/0A4Zrd3XGPBB7LmWYIxei70luk3SeyWuJPLzKiGItQ0a2DL3Qey8a6c0u0Ri9z6TJYpy7POBv3jJqDswrIjIIxVshM8vGXdQakuFqcgO5Svgyp/SC2LYmkkosMtpax+1r1szhGi6hZyiFXqyyjq6tq53gopeXHh7DsoPdKPaciMrtiWRtl2ZoXUmczyEzKbb6hS3lKiQcElCbTKU/SSPiU6KEPKON/CZdp6HJkLBJOcQLtFXkwqqJgY7dA1cVp86g76/7ETsuHbNmvB47QtDhIBCmU7uZFT1Q25noIlKdvbB2Xs2w01w2+n0gykPUpPRdj01l7jKnd+ADaCAVbwAjvuv/W3PQN4Z3uddRxQ8Z8QFPRwpKFu6cgNwEh1SH+mU9svcf3b0A4isrIzdlHGvjO6rEOCL8nE1wsL2kwtpvCsOOq0TFUMCaIaBxg3ip9C5P1dGPTf0Fs1sliEQ+mB6moPu6BbE+yFwH0rom4C+ZF4tLy0Tz14hf5PlpgxGNLE8Sgw186M6Y6lIgrw5Hbx9a7ahdNzhlEwcXO4OS+43VD7pJRsTtrpUUnetbaJX6mVotQ25ZRqouDPU5vOlV9PV6XuW/s3311gdXGRgqUbC9ga6zY4/0guyqpN9sHhxsvLW58ORLQTyVWefmezfGn8BHUOIAiZaQpvF5SLV6QTta32E0Kt13RjG5kXajGJL0NCpYny0t01IwUED1WOpsVeAfwhU9xckoUpr5abInrMOmDOJNSCcv4OSccRuuesx0F9/Pi7IDo5GHqtO4cSCX/yoIunswszas3LuA0wo/vMUNxD2tXiDhxRgI/zU8uKFTw1xd
 EjxXfBHa
 n9Ubi/vFoVQ6t/ts2etXMD6uCKGCNruu+OmJ/KuaX4PRQd/Kv4iomYujEwqqJHeERf9ey3U86QsKrW3vST5SlAYV56Q722hurWVKYiSeu8rcCg3kLoIouKl4JzIBJKkjCBoapcWNzc3L6T1xM91B5p+1XRJDXUeGZh1FQDPM8hVV7HVPubT1mxhf3HtuucnpSDw1NHjxzIGrz0nEf6IfuX9BijwcTGt+ww/EPqHo2Wmo3GfsG5J57WtJh2KKghXzQNrcKM+GUtRxCnE1bturXysN0iCkHiXh7JhULNOVwFkZC6EtDb29JRQJ2FEA9ncWFaMlHLrrou7B/i6nwhSQhj7BHapwoABtsc9WagLo33Ne9vF2GowfJ7T2x5c9k+KbVG6WhkYfZXH7PojpJIldyZya6Z3cFW+mWbeuyeiSceJwwNNO2MPCZeYYvw5CFX/+Z1m8O8+64SjICLs6uSGcRykbWtgQbrulRN5h3+QjrXME8mF2QxiUTvD5/PxajxEpdah+ydmL7iun57jELcTWx4J2/Pvv0uRBIPKOpdU+Hcw8b9nWQsE3ZTogGdyuva6YdGRbL6an1DEyAss9MyH2h2yrf3j2iRe6TP/t8CPNQf2EDAnyBkvco+VuHVSJzx0kzsmifZqb78dBSRqhaNDyjtuKxf180/I2UpzplXChfK8c4Z6hl+OWg7dEyiUPhnGgRKyZTZOjJHI9V5SzzULP3kPPSAdlpQSB/XSSYMUeMu5JicBmN01n49XPQdA6VdrHfaZOov6qBUq+3yWk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 02:23:18PM +0200, David Hildenbrand (Arm) wrote:
>On 8/10/26 16:04, David Hildenbrand (Arm) wrote:
>>>
>>> Hi David
>>>
>>> My understanding is that init_unavailable_range() initializes all
>>> PFNs that satisfy pfn_valid(), but not all of them satisfy
>>> pfn_to_online_page(), since some PFNs belong to subsections that are
>>> not online.
>> 
>> Thanks for reminding me. I think the right direction is to finally clean up the
>> pfn_valid() handling.
>> 
>>>
>>> You previously mentioned:
>>>
>>>   pfn_valid() says early sections always have a full memmap, so even invalid
>>>   subsections have a memmap. pfn_to_online_page() says an invalid subsection
>>>   cannot be online and its content must be stale. for_each_valid_pfn() follows
>>>   pfn_valid() semantics, and we use it to initialize memmap that is not going
>>>   to be online and account it as pages_with_online_memmap, which is wrong.
>>>
>>>   The cleanest approach is to avoid allocating memmap for subsections, which
>>>   also removes the special early-section handling from pfn_valid() and
>>>   for_each_valid_pfn().
>>>
>>> I also share the concerns raised by Sashiko in the analysis below [1]:
>>>
>>>   Scanners like isolate_migratepages_block() will then blindly iterate through
>>>   the pageblock and access the completely uninitialized struct pages of the hole,
>>>   leading to functional errors or kernel panics when reading these zero-filled
>>>   structures via macros like PageHuge() or page_zone().
>>>
>>> That's why we went with the current approach in v6 instead of your
>>> earlier suggestion. I'd really appreciate your guidance on which
>>> direction you think would be more appropriate.
>> Let me take a stab at just having pfn_valid() / for_each_valid_pfn() respecting
>> the subsection map.
>
>... and that turns complicated very quickly. The problem is that we have some users,
>in particular the buddy, that just assumes that MAX_PAGE_ORDER regions are fully
>accessible.
>
>The fun begins once we have MAX_PAGE_ORDER span multiple subsections. So we'd actually
>want to initialize the memmap.
>
>The pfn_valid() vs. pfn_to_online_page() inconsistency is really nasty :(
>

One thing I'd like to confirm.

pfn_to_online_page() is expected to return an "online page", which is in
buddy, right?

>I mean, in init_unavailable_range() we could actually figure out fairly easily
>whether we are dealing with holes where pfn_to_online_page() would succeed.
>
>diff --git a/mm/mm_init.c b/mm/mm_init.c
>index e9c4204b73adb..54e71e17f2c3c 100644
>--- a/mm/mm_init.c
>+++ b/mm/mm_init.c
>@@ -843,11 +843,13 @@ static void __init init_unavailable_range(unsigned long spfn,
>                                          int zone, int node)
> {
>        unsigned long pfn;
>-       u64 pgcnt = 0;
>+       u64 pgcnt = 0, online_pgcnt = 0;
> 
>        for_each_valid_pfn(pfn, spfn, epfn) {
>                __init_single_page(pfn_to_page(pfn), pfn, zone, node);
>                __SetPageReserved(pfn_to_page(pfn));
>+               if (pfn_to_online_page(pfn))
>+                       online_pgcnt++;

But a hole in early section could still return a valid page if the hole
is less than a subsection.

Is this an expected behavior?

>                pgcnt++;
>        }
>
>If it's a problem performance-wise, we can always try optimizing by skipping
>checks within the same (sub)section.
>
>
>-- 
>Cheers,
>
>David

-- 
Wei Yang
Help you, Help me

