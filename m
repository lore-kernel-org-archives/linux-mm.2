Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A6C6CA0FFE
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 07:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 404956B002E; Sat, 30 Aug 2025 03:48:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B5516B002F; Sat, 30 Aug 2025 03:48:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A40F6B0031; Sat, 30 Aug 2025 03:48:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 189C16B002E
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 03:48:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9FF4E1A0A95
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 07:48:53 +0000 (UTC)
X-FDA: 83832647346.27.B10A02D
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 84B5B140002
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 07:48:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k5UCCC4u;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756540131;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9ikxbGqFGezwBfgbw/sJ+KYqXnrmuu7/VUhqL/4vCE=;
	b=hAA2zQ67Cv/VNQ0LEULgI9wAjCQt39fAx2giYzalffdVjZ5Bm3NFuOxl+mhqDv1Djc/ziG
	DD8t56zzoCX1VPrV0IO/7M3I3O2azFgsyXs9JKM6v0p8ivHxlALOuRtOZd0hasQDp6K3N+
	5zTE/X6OQ+AnIggSejy96QsOYaEMRoQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756540131; a=rsa-sha256;
	cv=none;
	b=y/tZj3fK8RC2O+mmKUVmc6kz749/0E3VnoB0mQFBUcO5FUAnQrCdOm7xRS47GQg2KKibna
	xRbfcY5iKyrKk59ihNgLG/fltZJsk+jFNArxF73Aa9JL/w6OVh4E2pJrq4PKxsuZYozZTI
	v9K4zbg4ZsU5ivVmHJYho/RKkKitqwo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k5UCCC4u;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-61cd3748c6dso5664770a12.3
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 00:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756540130; x=1757144930; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C9ikxbGqFGezwBfgbw/sJ+KYqXnrmuu7/VUhqL/4vCE=;
        b=k5UCCC4unmc/yDqHftkGjWpFdIj5woEbco4cr0qgeOd408WmfWHoyroUQlTCqVN0Zr
         9tG+/bTPJbOnAjtdDnjXkIOgk78iaGquWC97PUQA3ElZbB8WYDZmINopJoOP0LEhd3p4
         cn514WNP7b1waUVDTqzDI0Ee6QdS/FJu0wEKqehyFih3NZgo3Lhw6SLG8ONMvdUKj0E3
         50u/g6FfhdfK4fySmN++Me6lwlEbmTNrGgJviXaRII1DUsIRXWPr5YwyXsU1cT3iTHIj
         PjkjBaufZqzsXw7rtm8VJ9ge6g56/jCQu9T1iua2YaU0q9WmSyJk87Ckvm5EXYTOK4uG
         DmfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756540130; x=1757144930;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C9ikxbGqFGezwBfgbw/sJ+KYqXnrmuu7/VUhqL/4vCE=;
        b=j9rhhqd2y7q43BLLYYf0q5dGe8EUo3vyNoJUzZC/z5RdHdorpDDkd02MztLa4DC7v0
         IlvTtRtlrYW3jdrCwU0iMDBLvSFEuks+aqcoAXk6vPoAHQg1B1WcsJP0kXPjFiL8vvDK
         klQlQO7QU5YhOvLrEJoWevf9gyYHPa0jcCcDB9maDgBQFgmUE68+N+GfSqZM6dv6wSY+
         Kjv1BEGBXWz/eYHmp08vmZ30bVHex+8FU80nUM9pjKQIz8aTpEt6Xbiz/Cd4OxP9t6q5
         nBJS68zfc4kKJHs1zHitjaJPbtwZQvUg9tuYKVeUkOPgy6XCiiCzzMCouZsgGzVBwWsu
         5K8A==
X-Forwarded-Encrypted: i=1; AJvYcCW0V1rNHUbKXm4v62eIPl0srWdGWAh9WGpv2kZ9IpthIvD8rIAf744iZ+MltSO3AIjq+RMldjQqqA==@kvack.org
X-Gm-Message-State: AOJu0YxC+FNGq/ANapHcyfSQJne7JD8YvHAwxICxOVqqKpyswHBxZSuR
	E4CeQE1YY4WXYHokTAKE1vwSEZKtxOleJik10RZU4u8/Eej+jverSAVa8JdXwg==
X-Gm-Gg: ASbGncstju3VhbA6UfjpbLQErqyWUGOBMECrY4L+vGNkCLWSgJSCIz7lNXHLYsRw/A9
	7/qO090RDfujWXS/7TCqEylzLUl5LWogUBqmQfxawgEb/Vmgd/G9jEkcePvaLQ9H2x6bfLwZtnm
	Pzk0FDjVhIhXwXl3vatwBGavJLcTpjsJPzSYtJK/cTcAqTxexilvfcf0yErP3Kzyhe0LJ90ryRK
	fXK9d+QiKUWyQaHXE+lVkWNo3Bq3ehSA53VmqMPhFbaY4DA9AgVTs5QNXb5lkj+jDty9j+NSJ6Q
	xVoYB0xJi2jqFTdGVsF1z/SLvdf4JxEcgA4n+CaRnOBXOLz+kUehK/HNuHrFRE3g3+dzRwkVWc1
	26DhDEEr5nJWr49l1TA8H8nYrXg==
X-Google-Smtp-Source: AGHT+IFdQuV70XfnKzIrxGnDeVxHCfE7ZtMBah41MZey2KkKoK+JJknh/5bTES6bSwyzQm89m1HZ1A==
X-Received: by 2002:a05:6402:90c:b0:61c:61bb:e836 with SMTP id 4fb4d7f45d1cf-61d26988ecdmr939370a12.11.1756540129783;
        Sat, 30 Aug 2025 00:48:49 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61d322b3854sm4669a12.0.2025.08.30.00.48.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 30 Aug 2025 00:48:49 -0700 (PDT)
Date: Sat, 30 Aug 2025 07:48:48 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, Zi Yan <ziy@nvidia.com>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH] mm/page_alloc: find_large_buddy() from start_pfn aligned
 order
Message-ID: <20250830074848.spy2rgvwc5s27tmn@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250828091618.7869-1-richard.weiyang@gmail.com>
 <489045AD-70D6-4167-843D-50A8DD19870B@nvidia.com>
 <20250830012505.v4qoihdqi22na3v2@master>
 <aLJt5GtJLGM3wc0X@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLJt5GtJLGM3wc0X@fedora>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 84B5B140002
X-Stat-Signature: tse4o5d1kg3mbzxihnf6p6bbyiikc8ro
X-Rspam-User: 
X-HE-Tag: 1756540131-577281
X-HE-Meta: U2FsdGVkX1+YcKMx6S/w/z/x1VTdvojh7N7RzLnKTFQzxt6pm3Dctl4Nikd9v0Wzl2dmpHqJts5oXXRM+gqEm8ux8Tr4Krt86sgHtw1H8LL3lMjyHTwmOCTNZu8VKY6Vf+Ud9CZE+/AeC6AbiOq4X7XTBIQFCUwoQL08uDilCzbV3Tov3g9u7dyO/olCFd2X3mXIJUaFsV1vMbx+Qc3REyeu2HaRNpvIcSsFV3TcywO1263dFPxdfGvJrGw9CR/D0YFUtQebWTIqpwvqun61qpz6vy+inxXBtyyBmemrQMp8fMVpgCI/hz2tfJ5mEfTKnV7wsB2yLeEc1eN27MvAmFA+cOECCXOoTxdbeVAilonFE9sHKhXQSfc3ZqVi6e+oLY4IOTOpyyCWkcLir1hw4HxB87KTgN/6hBIppPRxHtZzS9cvrPfVWZJNjkChaCXA/qCTJn7WS0SelrPMjIbVKCLzunyVvyKLKL3A22ZbIh8PxWir2oBltTF4KV7j39OqRI0qGsr+Zf/vYf5NKJrwRuQLFz0qWbSAdPd0VhiFOAB4slbzZk4QcLQw3QBI0k0a+W67UZkTkol839x/EO292ZpmkpXmYzrAX0xMiCDTyLxoWVqjtjluRcR/kItY5F+dwA7Ejpb4OEp7ayk5N4QiTd++eQLWcM1UvGF7EAJnmaDpnQLMMTCU1MEkIWqQd+Tq9I8/RZPHOeUZEH++yLA2mH1/micf61JvputxlcBJouYDmohhyqWSCKq02m6dLjuhx/Lt7pDdHIG5LcGAO9EY39vOXWzc7oiz+FifJ720LPQhr1n06LS2LLBW0ocjStuQbNAQIAmsai61B9RPRzcpIAI71dMktdHglsEVKP0SrP8nwwzGvgun/w/QcPphsosXY10wRQ5jtXc01tbiJjW2phrykelRRuyWhwgGLiUo8v/Y31CWmZTH78wnSQ8hGWNhnY7QJt5pRtzmkho0ezE
 lOu9jLEE
 JL28zHS78I4HD2GjrOV3LeKbohmkiVLikd9+se1LIueCJy+Nn+zj/yGa87ziw0Qkao5DLZTim4zqhnuLMbiMhSdLIUXWGvkY18k3rm6aRqL+5vI301vHJ/KKmkwgJ67j6BLQ/QQDBT0QTsGZTmoc7zN97m4U2c9fCcW/1mM5OIxrKMrnBRG+fV5fDfix3jZIeaxCsxMPGTLlII2qy4ywn8MqXNpyMECAqBlrj7rQFLriu0VvUYJoVJh67yJXEarUnXlL6etf+FQwGfdPXi5HcB+0w12BSq5qkDqzPlfjzdoyBUGzT+q3xovRuUfwpdIgnab8YcX40C5+JTVhqxmd7npfy/4C96Zh6yujcqQrOMKKs7IblSXvphTIIUzRBcXDPX8tQ0EIvmOYmPKWYbacOEZQPuhdTOpusIjDrPUaiTZtPHCJjSdpvAmSH67EB4PodIwgGdx+VXIId48VitQGe7SKai3GQJvp4sx278iPHhRGiBeUczsEA+uBQV925xRvZan+LG/ipSy3qZ6n+CdzSnIr0EHqvgjRk3wT4HNVPYZ0xZvSU9Zye8h0qGjgrvv5BfNvtQLilsQVwevYdhhZaQLmW5NHPODZi0wY138eabyEhXRsIpWItGI3IYw83YmRS2FIfAlLfQSjf+MwqBrHG9UV1xyLDDqaxe8K4qbxBmS/4LSO439PJY6q4C6sHQSTZQEKkKIbvELARKxMb442HGoirM97gAwUiNN8/nwVbu9vI1dstrrUhekr+LWWssZweHjxP0rDS2K2iciPkXOqRFgRlav+yMeAUTxAlEe/pWO3ReUKOmwfVpA26SVU7yaaXyApgv2e7S6E7qaXQPGqxJ4JS6RTbfCDG0rnvwNUht0R2aZxjQYmNjCwYBa+whEazK7SP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 08:20:04PM -0700, Vishal Moola (Oracle) wrote:
>On Sat, Aug 30, 2025 at 01:25:05AM +0000, Wei Yang wrote:
>> On Thu, Aug 28, 2025 at 11:02:33PM -0400, Zi Yan wrote:
>> >On 28 Aug 2025, at 5:16, Wei Yang wrote:
>> >
>> >> We iterate pfn from order 0 to MAX_PAGE_ORDER aligned to find large
>> >> buddy. While if the order is less than start_pfn aligned order, we would
>> >> get the same pfn and do the same check again.
>> >>
>> >> Iterate from start_pfn aligned order to reduce duplicated work.
>> >>
>> >> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> >> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> >> Cc: Zi Yan <ziy@nvidia.com>
>> >> Cc: Vlastimil Babka <vbabka@suse.cz>
>> >> Cc: David Hildenbrand <david@redhat.com>
>> >>
>> >> ---
>> >I think it is right, but the code is very subtle and hard to understand
>> >after the change. It is better to add comment to explain it.
>> 
>> One thing I want to point out is in __move_freepages_block_isolate(),
>> find_large_buddy() is always given a pageblock aligned start_pfn. This means
>> if start_pfn is not a free page, it would always try 10 times until give up.
>> 
>> >
>> >Paste the code below for more context:
>> >
>> >        while (!PageBuddy(page = pfn_to_page(pfn))) {
>> >                /* Nothing found */
>> >                if (++order > MAX_PAGE_ORDER)
>> >                        return start_pfn;
>> >                pfn &= ~0UL << order;
>> >        }
>> >
>> >
>> >
>> >The code tries to find a PageBuddy starting from start_pfn starting from
>> >order=0. When entering the while loop, it means PageBuddy cannot be order-0
>> >and ++order increases the order by 1. Your change fast forwards the process
>> >based on start_pfn. If start_pfn is not an order-0 page, based on first
>> >set bit in start_pfn and how buddy page is chosen, the next possible PageBuddy
>> >order can only be __ffs(start_pfn) + 1. Your code starts order at __ffs(start_pfn)
>> >and it works because "if (++order > MAX_PAGE_ORDER)" increases order
>> >to __ffs(start_pfn) + 1.
>> >
>> >Can you add a comment on your "int order = ..."? Something like:
>> >
>> >If start_pfn is not an order-0 PageBuddy, next PageBuddy containing start_pfn
>> >has minimal order of __ffs(start_pfn) + 1. Fastforward order to __ffs(start_pfn)
>> >to remove unnecessary work in the while below.
>> 
>> Sure, I would add a comment above the assignment.
>> 
>> But in my mind, we are not farst forward order, but start check from order of
>> __ffs(start_pfn).
>> 
>> 
>> How about: (not good at commento)
>> 
>> 	/*
>> 	 * We start find large buddy from start_pfn order, since a
>> 	 * !PageBuddy() means all lower order page is !PageBuddy().
>> 	 */
>
>Personally, the way Zi worded it makes more sense to me. Maybe replacing
>the second sentence with your comment is fine, but I think Zi's first
>sentence provides important context in a clear way.

Hi, Vishal 

Thanks for your comment. I am ok with it. Let's see Zi's opnion. And I will
send a new version. :-)

-- 
Wei Yang
Help you, Help me

