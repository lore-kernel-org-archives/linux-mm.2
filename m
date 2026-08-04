Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AC26C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 18:54:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 361576B00F8; Tue,  4 Aug 2026 14:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3387B6B00F9; Tue,  4 Aug 2026 14:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 227A06B00FA; Tue,  4 Aug 2026 14:54:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED0566B00F8
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:54:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75074A02CC
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:54:16 +0000 (UTC)
X-FDA: 85064487312.12.664D365
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id 33D2B1A0003
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:54:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=hH6y0yN6;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785869654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NcyQc0XO5NGrQMyUDH1X0CTRmn7y5N0IBsdkP7EGScA=;
	b=ncGXwh3XLxWMOgERlgUwsQD5ajmu4U6vgsyjYpF2bmj1PN1yKm+IN8uZh7rnNvBGOmUee4
	KPguzf9Y9PnF5mm+8bmboca+HkytzXgfvlSa81Dc8HkcS4kBlhqfOJ9VEfiSzYbVuQEaXr
	BNQ919JgYCEvd8jJA+G5X1y8v+ppgrM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785869654;
	b=3jMIsha9+Xxs8SKfCqnce9iXNn2GbxuG2jL3Ik4aZGE/MJEBwECGviY/HnGwG0cy0Ncn8C
	hB7Wwpas/Sr1tkkSSYaLDvlvvQhp0pW0RZcl5rttEh4PHumjJU62z5lXMEslINqSODb8+E
	zaSLvD8m7rL4qHNRo1v6j0cb0H72cjY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=hH6y0yN6;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-9034b6b7674so1177246d6.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 11:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785869653; x=1786474453; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NcyQc0XO5NGrQMyUDH1X0CTRmn7y5N0IBsdkP7EGScA=;
        b=hH6y0yN62+f6x69XkU+4NeuGKI7MWR00Dpx0Afu6PHgwE+cY/2ndLNyyRMPvMzzFVQ
         pqVwKio+fJWNa7zqfAUq4sKx6TtVjUM900eX867w8uK6hwuBSzu/eO0cTbojr1Dg8mKy
         yR3aXyykdVi53O8ST6Al38QacgxP3LXvE5bRMP8MPTN9S0bIay3/FJOLYaPnk38wYO2g
         K7WWoasKgE/5TYNpfoIiWZm+WLOZsG40h+yF/lBv8x41kZzUBmnnP1zjFo28c/fcg084
         IkVARs2AEKXn78hBkdXavbWJTsRLTpCKQqQwlqgGibKarIP+7lTiJUZ5+K2fOFwPOq66
         WnMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785869653; x=1786474453;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NcyQc0XO5NGrQMyUDH1X0CTRmn7y5N0IBsdkP7EGScA=;
        b=j7fvvn3GlsIDmFC/lHeaqCkUzFtolhnMRQcvrPt68estrz2ZZw8q0Pibwm1GIZqApj
         5nw6soZv29Jq/liS0FUOkWV/aDV8IK+7Mkjnl/WdR4tcQwSWpeuee5dBlxXycXyEQ63p
         kIXFd3imVGEmHYo7HCIWwXCPm/fWrTi8md4TIduW6SsVGj06zfUL3UGTU0vR7byEnDUu
         7YysZ5sz0vZCuwhuyOWnaqYZp8XvQTtM7NMIPQPjC3sRmHTDPnMicWxgYNrqcGb4aHLd
         XwKWZp+qQRV9Mo2vWyW/MXXGIiE/P0vY2CDVZnpbf+a0CNce6oR0AupESFS7OM1Pb2N2
         bOHw==
X-Forwarded-Encrypted: i=1; AHgh+RoE2+MrEX8yOkK/wx27Ut2xYVJ6AiwC54jv18sv8rgEJufXIip9MB7s7A9dbT9o+DeT6JkNz0/XDQ==@kvack.org
X-Gm-Message-State: AOJu0YzZr3OKQFl91efO69nNGZlkFftxxeMAlV1DZIHd41URddPH7DiB
	0m5IHTV1vPWS6k+d/evDot84ONYRixTdqFqhlcIAb9+CRX7jyo0kkSzVKZNM//HUDkw=
X-Gm-Gg: AR+sD13GhZZtfB4S3ty9qmmbjdrmJW4nGmkdFAgQrt40S5YWvfZNCW+9x13W81Jqrch
	HH+tBpbkJ1JI7SV7WYQNjao+6jgnkrs3uvKPViQx+4wnoFGnlHDWUUNkgNobHE6/PNEfiSvEFTM
	vxHtt52EK78oaQI7KHs0tf5/MQPzrLEo+gvLonBcU0rkpRLpDiXI7IYgLwN1JdQ2zYtNzeuF4go
	7TJU2lZFvGSoJrbtTWiKUkxBnlDlsW0CeS7O5XauSWr18XpX/B9jbeXmpXUps4caw1nCAt1xR0X
	wSHZO6WDGw2RW/nxWZiUZZwlJvTdja8i0S6vCedajYVtwPGUMXQ8ydpeXxUrHq/sA3LmvphAcGJ
	lGzV3uLug2OhaXk7RNEn3WKPuGW8BA4g7CCl6zcZbJMErXq1HVIfsT4evzIUC2E01/4+AnySvRy
	u+D6ch1QlAIV2WUej72ssjhxk6lfe6L/PhZT0tVdM/2jy6dh3teKcLm7Gh9oc=
X-Received: by 2002:a05:6214:4a87:b0:907:c056:d63a with SMTP id 6a1803df08f44-9088125aa14mr18471346d6.20.1785869653206;
        Tue, 04 Aug 2026 11:54:13 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9087ff9d04csm9065436d6.3.2026.08.04.11.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 11:54:12 -0700 (PDT)
Date: Tue, 4 Aug 2026 14:54:11 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Barry Song <baohua@kernel.org>, Joanne Koong <joannelkoong@gmail.com>,
	akpm@linux-foundation.org, ljs@kernel.org, usama.arif@linux.dev,
	alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, lance.yang@linux.dev, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
Message-ID: <anI1U49rFrlhPx2x@cmpxchg.org>
References: <amtv0YRbSrN6iUEo@cmpxchg.org>
 <CAGsJ_4yWAUcXmVr7Oe1V42szqi2Od-0MhDBspNKURZcBnub9+Q@mail.gmail.com>
 <amy5ZKC2Kc7RX94Q@cmpxchg.org>
 <CAGsJ_4xhbEAiLFt-3N7738zJDoJ=hPRYLpP3tpU2sGOz=ORiaQ@mail.gmail.com>
 <anCpdjEoDNgVbfzP@cmpxchg.org>
 <CAGsJ_4x86EYsMz_n2NKDwTqeiv2pi4AcZb1RuZoBeUBR1iFqOA@mail.gmail.com>
 <anE27CtvCFx7sAuO@cmpxchg.org>
 <CAGsJ_4z7bsDzMtO5PzaSHV4CBYBFS=wmmG3H8xfj-mdUo4VyxA@mail.gmail.com>
 <anHxPU17Ui4MTcCb@cmpxchg.org>
 <65b4baa3-77bd-4d2c-a128-9884f858e63d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <65b4baa3-77bd-4d2c-a128-9884f858e63d@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 33D2B1A0003
X-Rspam-User: 
X-Stat-Signature: wdhghm3cxmwgpmnexuxtm53oc3q15i7m
X-HE-Tag: 1785869654-413142
X-HE-Meta: U2FsdGVkX1/B7tAnBt9w2YV7BGd55JYKoh28hHyF7R08+E6hYAQIiIARVMkaqVoLq2iMj8ZjyPVdYOAcemFQHJOiAe6k4n0I6Z8a1VOJGobs63P+TgXvaKOk8CG6DC8N71y+azorqW7mPR5NaGv1+G2sZumi4aBFvkllINnrnLRJiOV/lo901a7JpOitggSpP1eNL9okyUMdiUnLNhGZU+lBPMZCnvR8u1pTWPY2PH8SqOjtsKCZ7VaDwV4JRsgckLez4Yndr91DyoZl7u5+jXfmSy4O1U/ru9BNOcqR9v1my46Lr1TN9lXZgGVMjguNlp9R0nsap6+CGFWKja9W5Io7m4luAmG7gTRkJlGBzEDOj5rA+JVpaRdrK+ECSBDeb3rJ81zvDfjoMHESiDVkGD/isFWt4ASFBfItTCJSTFuAfNn+IFPbic/9v/5X7QWZdUbRVo5W7n3ipFMmdh6tvyPBx25zVjY+A1mKbsJgBV08nr7HQeNHzDGet3J8Lg0jARdRlhgPxbUE6RF8G3te2LWNkKz3nrPQ9Vk7UIrb00tnGUoVX8jThKhn3pULuLM76CgzhRL7B4PB9J0CXgBm0SdGOUOYEunnmoov4dueFr12O62OHmA9tnKijil+Zrs94ECP0XrBE6mZFgK1ibHPjSZa2Jn9o2aDMmzKD/iueG37XMEHXaSrWRLxabLjfb69LhLLHIiOKh0GmvJIwqZRVyuOQZl6bjrrcueW+38ZgJxUSOnLcsBDq4KD+wljvkMxiOx1y5N9RIdDi7MmSKd/82Eeje469AoxVSxupDbemc7NtZ+aznPIMlUFCqjelQ/5YUCdJfzYnPPSnEHS6kvqKrt5t/nhEeRjECJ+oIH21emclirCyo1g8fQSUlpjdJR/SBnekbBS4pIKYc3XlASWgGx6ba8lhz0IqGGRgb74Alpf3PTxIh7BweYnydnn4aW/CyYGme0woxOQVpvneJq
 qJodPXnj
 VobAq37UemkGaNIXItnowVNZxl3CUeemc9zlwMZcJ3velFQpAPPwPVkyVwy3gJEZhwVHbvaGNgHfGtdJWuZPlXrlVfIZdmowz/IxMlyngXGBqXB7I+1Yg0cN96CCc1L8Chl6U9cood+zI2nESPUm3+Qw91yu9UQIFpTvZFFOhftQuBhK0A/pl0yCcapw01jShLGStQWCTocXQ3SJjXDP3gxWeQ5bZEUUcEwq1X8cYSm2cDbP6vCLDUv6QNSlUZFlAPwcEhbxAI0/L++VToVGlMyqzb5qIBYCWfuHqAUeXut2ymh/BsctEO8Zc6BM6D/GbUIt9Myv14mLEbs7XOG6nPqstPwJMPaV3GF94uaRpoNYAiO4cmgOglOgWxArSoxslYdMTbs3r82j9PDt9QabRBzDEUV0epjEnDu2Xj48E8edydqIgyMruLgeMrNKndg+0Ridf1+JhHd1pz1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 04:11:02PM +0200, David Hildenbrand (Arm) wrote:
> On 8/4/26 16:03, Johannes Weiner wrote:
> > On Tue, Aug 04, 2026 at 10:03:14AM +0800, Barry Song wrote:
> >> On Tue, Aug 4, 2026 at 8:48 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >>>
> >> [...]
> >>>
> >>> I am very confused. Did you not see my proposal above?
> >>>
> >>> Why not this?
> >>
> >> Hi Johannes,
> >>
> >> For arm64, if the base page size is 64KB, a PMD would be 512MB,
> >> and PMD-1 would be 256MB. Usama mentioned 2MB, which is just
> >> order-5, not PMD-1 on arm64.
> >>
> >> BTW, I assume khugepaged_max_ptes_none is intended for collapse,
> >> not splitting. I am a bit concerned that reusing it for this
> >> purpose would be quite disruptive.
> > 
> > It already is:
> > 
> > static bool thp_underused(struct folio *folio)
> > {
> > 	int num_zero_pages = 0, num_filled_pages = 0;
> > 	int i;
> > 
> > 	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
> > 		return false;
> > 
> > 	if (folio_contain_hwpoisoned_page(folio))
> > 		return false;
> > 
> > 	for (i = 0; i < folio_nr_pages(folio); i++) {
> > 		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
> > 			if (++num_zero_pages > khugepaged_max_ptes_none)
> > 				return true;
> > 		} else {
> > 			/*
> > 			 * Another path for early exit once the number
> > 			 * of non-zero filled pages exceeds threshold.
> > 			 */
> > 			if (++num_filled_pages >= HPAGE_PMD_NR - khugepaged_max_ptes_none)
> > 				return false;
> > 		}
> > 	}
> > 	return false;
> > }
> > 
> > That's ABI and setups are relying on it.
> > 
> > All I'm proposing is to only queue pages that the shrinker would
> > actually split under currently existing rules. That's a mostly
> > transparent optimization, not a new policy.
> 
> I yet have to reply to some stuff here (sorry, it's a mess :( ), but one thing
> that annoyed me right from the start is that we have:
> 
> static bool split_underused_thp = true;
> 
> But the default khugepaged settings actually don't result in any splits.
> 
> I think it would already be a big improvement to not default to adding all pages
> in default setups.
> 
> When we last discussed changing that, one concern raised in the past was that
> changing the khugepaged setting later would then not be able to reclaim pages
> allocated up to that point.

Agree, that could be unexpected.

> When someone actually changes khugepaged settings such that the underused
> shrinker would get active, could we walk the LRU and add all eligible anon THPs
> to the underused shrinker? We could remember "already scanned for underused" per
> THP, but maybe we could avoid that initially.

Recovery like that makes sense to me. I don't think we have to be
extremely performant either, that should be a rare setting change.

Would it make sense to use khugepaged_scan.mm_head? That could be more
targeted when policy == madvise, easier to skip over shmem VMAs etc.

