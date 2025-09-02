Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DE76CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D7188E001F; Tue,  2 Sep 2025 11:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AED58E0002; Tue,  2 Sep 2025 11:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ECE78E001F; Tue,  2 Sep 2025 11:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6DC8B8E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:13:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1A76B1190DC
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:13:04 +0000 (UTC)
X-FDA: 83844653088.06.BD4E7AA
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf06.hostedemail.com (Postfix) with ESMTP id ED0A7180018
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:13:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=xJFsZOp2;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.218.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756825982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lsDWrN0hLpgohFIMsGJpxtTW9Wct+jUuJCPQGtn55/Y=;
	b=WmBHGCwQecggVgmDxuncTaJEe1nqa1TburlzQbbUQco/e8LlKDofhmEeDYLkRislWCOybF
	rgOqlpZJhlnajWvWqYm/PVBzlFSqQWzZkasKtz/zJBuLP003EHz+B82WkuQZILOqp848Ko
	GmPWd1/twDQlLhquI0LNB/3xqcrABpc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=xJFsZOp2;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.218.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756825982; a=rsa-sha256;
	cv=none;
	b=kbz+URn93kZAsglM8ZXpNIcUdaf8EvJzhp8lpxkDetbMMTAgyhfh3tBOQAc9v2PcGOSqr1
	rhLz3rLlhnqv1oBqIBERyP4EwoaMcox9wn3rRzpSvUcewcubhEJL4+7Sv0ogKyaX7dSJlm
	zIo9IV3iI27cKVrxnfjzuT+JS53h27o=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b0449b1b56eso180264466b.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 08:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1756825980; x=1757430780; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lsDWrN0hLpgohFIMsGJpxtTW9Wct+jUuJCPQGtn55/Y=;
        b=xJFsZOp2u4icfQyTtnT9kSdZf7hKfhaGmdq7bLJkmV/U/xlFPAklHgZatCYO70UnKm
         a79iC+CMBkIU1hjnH/E/OThSqKTGBx/tttQVUhOQyzbpaeEQMpro9fTLUyYjl0kFuWBu
         SdekUYmJAaxkfx7sUIQmNMX+irfp/47TzLItscKAxyY1zIsiKtAHjRjf1a07gUS0L8uZ
         MgSbdPu2Rl+Y/MQU2f+lStO3MqD2Aj3KvUCNY7PZkf9U6hf+6XgXyJmJnpvmVutOAZyE
         QmEIy+CpMBCimNU4awEVdeJ4vRx96fAOfd35FlQ0Tz4MbuvAm9939VZVp4utawTWUso/
         y8mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756825980; x=1757430780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lsDWrN0hLpgohFIMsGJpxtTW9Wct+jUuJCPQGtn55/Y=;
        b=w3uj1vRsusLOhmyLcbL3iWRNrrv27rrZujK857x6XwDYubyBq3ijWFEiqzxqKwHdOi
         1pl2APAaltpIpIfqYXOescgPwIqgYVv8IfNzskl/J0VeVpJ1oPoTv9+9Ft0NWkxcpINr
         OxzaqAdWgVIDpFJlDpy8TQtG9IUpb8aD98KC+Nw6mdtrL+XF6CpVI8kY7fORbyYImFWe
         rObtI7qbf7R9D2b9dck7FkPcjQRv9/vSqhJtjkAJpurhGji8lGVOGIP7W3g3UnmPUC9z
         ENZT54MfQx3XPyLOpXDcxs5JG83H6mbzspse9SJY3OzLErF1ELYXrtDiN9wy/3qUAvNI
         hDew==
X-Forwarded-Encrypted: i=1; AJvYcCVhElg24RbqpLxaTPAqgtLQiIIrfcqcavAh/pBD5tHu0fUmD/zxTu+M4crUO1ovWg7EFjQCowm4Qg==@kvack.org
X-Gm-Message-State: AOJu0Yz4nTqq1BBG8ltwjnME1nLeCwOVGUaIiWFXoJEgvMp+zJVEu51u
	iUYSOTzYHFmpZmvO151k9BDy5BnDuvHkqLh77uVRdltjzyozQXhCP/yE5l8R35RX844=
X-Gm-Gg: ASbGncuPitVyeISTZiHx4+h1tOIOTHBBdy2sDcaLLdGxbEX/QseE62WcK/BUDr7FEqf
	E9bwCXcwKggdkYT7uhn08VhC7VObsxLiwTay51n1vUMszEuEENLSCasDf2bfmNhFJImOspONpag
	kS+q6pXKFYclc6SjjPjZf+ky7i/R6WAB2vlk4+fdUF118xWusbURf8HrDI2PybcBu4q2ujstFsL
	Lu0qXIkqyOn2nunz7Z6HZZJoftbLfsajFWkyvll9Uc4VvGwerilw/RSZPDe2f/wTjXX2Ui14ubO
	0iE2yohZajAJgdhwbn0S9gEWUY7Z2Y6Pwsmq1JszgHNro7CsndJGo/pzdkNy3tl/lP43Y9CxKqx
	71y3CZb98cHzQaEl+WFieqaAYuen6i2qys8o=
X-Google-Smtp-Source: AGHT+IG79VjAytAH2Ld/5Q/mD2WVxbfufOuRuAWQMBaXVCO+NayoVR9b/HB3/kbK7Kta8D3faNTdpA==
X-Received: by 2002:a17:906:6a29:b0:afe:dd76:7cd4 with SMTP id a640c23a62f3a-b01d97b6ab7mr1457047166b.57.1756825980144;
        Tue, 02 Sep 2025 08:13:00 -0700 (PDT)
Received: from localhost ([2a02:8071:8280:d6e0:e14f:ef73:8858:fa53])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b0416842ffasm680150366b.38.2025.09.02.08.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 08:12:59 -0700 (PDT)
Date: Tue, 2 Sep 2025 16:12:58 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	vbabka@suse.cz, linux-mm@kvack.org, vishal.moola@gmail.com,
	David Hildenbrand <david@redhat.com>
Subject: Re: [Patch v2] mm/page_alloc: find_large_buddy() from start_pfn
 aligned order
Message-ID: <20250902151258.GB6654@cmpxchg.org>
References: <20250902025807.11467-1-richard.weiyang@gmail.com>
 <20250902143357.GA6654@cmpxchg.org>
 <6D364315-80B8-44FD-A0DE-E78244CFEB70@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6D364315-80B8-44FD-A0DE-E78244CFEB70@nvidia.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: ED0A7180018
X-Stat-Signature: kd3oq1j9kitpbm87pkihbjpkjgexj6ff
X-Rspam-User: 
X-HE-Tag: 1756825981-510149
X-HE-Meta: U2FsdGVkX18jtrgPs2rnyAs+qi30Yv+BBlRd4D+ODtwMhFGDhPz4DdayzFXeai4wHjD8XMPVr20AZ+MLRuxDyJx1jMIWyTt/CBxpEKkOMNra0XrS6rfTRCURuypXAwT7LMA3dkaOYIfsnx/63dxjH0OtbWFyUptmFhe3C44UjZu9GYGijqb5phrdww+X3eNhYFEw6GQ+r+TZCDJ4hi3RxuotdhEjW4vpsOM4CxWn0iss0udYveCc7GE0xjRkEodPfHZvQnZxlGu7P+glaGw4wFsseI7kWKh6dJeLJEe2/9l8RdhpH9fBoYPZMcGd/R/YXPdfb3petGUhvWlvwmDu3xDUST3or8bBwSogO0zELNtYAOy7FRe8bRdHFqqR28K1NeDBMEt1FTEenzt1f1CJhb2YMVovdeLLphkacXty+ItDgOmvU6xVpGOy0Xr/UJg28TMohytzogrCv+u2Xptl13awtPxTy2cNZBjFBibgiXpfFf5/gjjAuXBvqGf1gXfYF1AY2bgIxKAm40411OG9HVZ9cQhZc2S4oBCct4jhomQ334OzNGz/qCprDJ2NoiRTzPFmerFosHBq0GyqVK2OZHyq/fET+q04ECCjiDXvDuaTSesQi/gW1/ai1sjc/DbEBd50x6iCstCb/ojAi9gHZrjdXRmzfLKjgHbkDFeKilXKsoZrK9XpBzjgJOwJcSy6GBkGcdvsWd86gjX+Yc7baLQqA7CuK61YtRBC4CvWO6MEVr67g0IAFW96swq20VNPXeVx68MGoaqQ1SZKj/Pr7fI2nlhoYeoeV7mW/OeaXr7+uTOgahjsXYLBvtfFKw1kfYjLJWMZXSxj6ID3/5aaEg6RUs6UXA73XBUMdRgEObQlVqSm+Jb99HmXm7EiuFTNlP0o0tvuSBghz6I+S+ZDaAlJeZ8uqZTmvTkiGuv1uFsZFmJfVcfnToz2g8KQUNYSp/Yq1fMFOYZAkxPFaRt
 kNrYMAuo
 XVgViqjKUZJqB+SnBhaI78ZEbm939eV3eKu5J4HVvLc5nYgbNB29kSRSwj8aAqCESOgsGXPf7sey2KD8gttzRm3VzWoSrVrTu61Shaog5jwSUj0wxe2B2esfjn8JgQ2lSQPjaDTMg8Qu/SDs+5ZYRr7QGhH5+4vw81hlxbbzedESDvF4CGQsv3vkLe4tqIpj7NgukSnU+MuYkNAWSfraXPmVlBWzVzubQFu/N25zSZSkauXO6GIoY6ZzHTIuyRXlyz6JrX4fq0UT7adkJBtSbZJZ45tEKsedr9/jYmlUY7IXGz8RZ3+6PdGlRg1oAcVDjUT+PPZT+9uDpEVB3ZqhoNturS3eZ4rdXBWDoR/IzoZq5LmHHXAYqWW/AeQXrijK6NRefKGwvYVmlg/qRBOIcJyWwxZbrJiBJJWXCWGYMax+PDKYai+MdxpJSe0KetNjYXBHVbUYG8pLwBqjTHhUGcyo5GRmKBd1mJclRKgyhbrVzfsUHBvX5O3rzTro+aEPmE16z2zZEBMqZ9sLN4+GE3B+V3UwPaETPmn8/lnB6Y7GNgdzF0h7Dkl0BFzY/xasEMYb7vuRin2qvAAIpSvJFmul0BclJRJGzpiVZeVc9/5R8lJmWYV/s/U8+Qa7m1wZN85xkFj6JitNngZfkvbBDOPy8GQxPV7Zm56Ay8UuhkjqDxtCmgy29IoM8Kq1Il/Gu+w6D8IP7PDahrBxQsrrpsB7Z76cF2k9KTR36iDWOmorlUU+iTFb/pCwO2dBXviWtaM8oSP5dRhBF5miK2yNm4d2b1Hcg7DKdFkJI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 10:36:14AM -0400, Zi Yan wrote:
> On 2 Sep 2025, at 10:33, Johannes Weiner wrote:
> 
> > On Tue, Sep 02, 2025 at 02:58:07AM +0000, Wei Yang wrote:
> >> We iterate pfn from order 0 to MAX_PAGE_ORDER aligned to find large buddy.
> >> While if the order is less than start_pfn aligned order, we would get the
> >> same pfn and do the same check again.
> >>
> >> Iterate from start_pfn aligned order to reduce duplicated work.
> >>
> >> Link: https://lkml.kernel.org/r/20250828091618.7869-1-richard.weiyang@gmail.com
> >> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> >> Cc: Johannes Weiner <hannes@cmpxchg.org>
> >> Cc: Zi Yan <ziy@nvidia.com>
> >> Cc: Vlastimil Babka <vbabka@suse.cz>
> >> Cc: David Hildenbrand <david@redhat.com>
> >> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >> Reviewed-by: Zi Yan <ziy@nvidia.com>
> >>
> >> ---
> >> v2: add comment on assignment of order
> >> ---
> >>  mm/page_alloc.c | 8 +++++++-
> >>  1 file changed, 7 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> index 07d79ae557f8..5d9ceca869e5 100644
> >> --- a/mm/page_alloc.c
> >> +++ b/mm/page_alloc.c
> >> @@ -2033,7 +2033,13 @@ static int move_freepages_block(struct zone *zone, struct page *page,
> >>  /* Look for a buddy that straddles start_pfn */
> >>  static unsigned long find_large_buddy(unsigned long start_pfn)
> >>  {
> >> -	int order = 0;
> >> +	/*
> >> +	 * If start_pfn is not an order-0 PageBuddy, next PageBuddy containing
> >> +	 * start_pfn has minimal order of __ffs(start_pfn) + 1. Start checking
> >> +	 * the order with __ffs(start_pfn). If start_pfn is order-0 PageBuddy,
> >> +	 * the starting order does not matter.
> >> +	 */
> >> +	int order = start_pfn ? __ffs(start_pfn) : MAX_PAGE_ORDER;
> >
> > This should be __ffs(start_pfn) - 1, no?
> >
> > If you have the lowest bit set in the pfn, you should check the
> > order-1 buddy to the left first. But ffs(1) is already 1, which means
> > the loop will check order-2 next.
> 
> __ffs() seems different from usespace ffs() and is 0-index, so __ffs() is
> what you mean ffs() - 1.

I'm going back to reading school.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

