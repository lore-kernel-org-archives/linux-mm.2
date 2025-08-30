Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7445CA0FF0
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 03:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC4CA6B0029; Fri, 29 Aug 2025 23:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9C376B002A; Fri, 29 Aug 2025 23:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1EC6B002D; Fri, 29 Aug 2025 23:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C60886B0029
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:20:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 371A5160A09
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 03:20:12 +0000 (UTC)
X-FDA: 83831970264.10.605B989
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5A5AC4000A
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 03:20:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fHSC3WW3;
	spf=pass (imf27.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756524010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XxXvabSCw+smqg27yv/gnkYF/oN1Nhgc9G9zwr3GQ7M=;
	b=Lc4BEVNwFywgF3AizjoDfNmpMqYEr/j8fClMI12N7k05fO7MRiGZF16QRSTIYrwZ3unkM5
	sSE/rNYs2eZKCMtrjJC6idlr1qmdQq7X7e8cOyZEvd97eDSM9/lVWV/Crdqv1RckpoUAfK
	WJtfTQOzmflH4qKlziYWXw963YvNYDg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fHSC3WW3;
	spf=pass (imf27.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756524010; a=rsa-sha256;
	cv=none;
	b=c6wqkn6NlPS1ucW0CazWu/zcp6IVgaoFlQePLpcLk3rfRW+omXtUFYAB1GOWlOpjETGjU9
	5UsngmI0/anKe6Mmq1vCvLX0mKhqrGnuGbRn9d1Hc3oqUHVXXb/yrnTRMG8wNY27aW1Ia8
	/2FfX8AoIwTqF2Ydk927ktso2LE1OwU=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b49cf21320aso2975181a12.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 20:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756524008; x=1757128808; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XxXvabSCw+smqg27yv/gnkYF/oN1Nhgc9G9zwr3GQ7M=;
        b=fHSC3WW32qLHjdkGJF7y1YfRirDU+km2jErZ9v+ZyCQfMswf0gaq2ujgztNdrgy9R3
         VGGD+6tH9I9oklVm0LF2odReeeOh8jChCD41ZckkWDlVMXIkU2z94dNxn4v/uXSFZf8d
         v3Tmmw7lEYuHmmA0xo7t+c2f/itkaPLjW65f2yWSrXkj63r7ahp62m+xVEwdC3w+9yU5
         QPWLskGdkZINkHG875/6qMzU4ilb3jFoiqEjEIHOMI+/LqACWbOVpzMbWz7gToKCRv29
         c9+aXjbw4AWeLooAiz461XnNoRI1FQ2ADbUTjApTaIh96Ckpc1xpu8T5LhTRacqW6iJ+
         FfkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756524008; x=1757128808;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XxXvabSCw+smqg27yv/gnkYF/oN1Nhgc9G9zwr3GQ7M=;
        b=SY1nc5cpgX2bINhhpCt8SkB0dBNrzfjVgdFsF9+Vi3krB/C5DtQ9KMo0VHw2QLcSg5
         7bDKIxpw5benSDkdr4twv0ZvTSkr0Vp8ZaFCwE2DS7a8AcviDsyNl46ofKDq9RVCFDXg
         u25MeMfq3k+03fbxUOO8yhn9F9KS4d+2uB6n7nZmM5ADFSURGxmMi+cHy76kXH1FRaIA
         5hr6UhVVZSZ16rK/hKGgA8j3roVva6aUyTipicf47jqWTDuIP6+8T5vCTqxqfUckKif+
         fnsUWOtain5OD0TTJdB4EcPSdlFvQy8JZhEl/gHxrfl5XvYq8lPUPlE7uDVLUjlINtF/
         sv/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWC2+xj3hmiE28gK8Kp7gFoAYELfTMaN0ZmGVm/eYAmIk265ba13SQ4QfBF3iAV2iqINJyftL+lAw==@kvack.org
X-Gm-Message-State: AOJu0YxvWNn7V4hhlxvyGNQTiwsGiki2Lp36sZRmuDbARyK2JDEs453g
	6O8tk97u2li5ZpMTnPSj6ad5juMPA96KgEy5SIhZw/2ptveVrJk8CfWn
X-Gm-Gg: ASbGnctREaFgEdmDsfSbHuYgya8ZZyVkWOepTxnibrz3OUh1CZ4brn+Gb7SO5grfW/J
	fDuH/8a/ZyME122kw808dKasetSHS3KtKxDeQJEFDc12oJzmyhKfRgixYp1fffO+/IQLWRR9G+0
	3wezNP2JQaR6eGvM1Vtp/JrVQj53J6/hBEsAb6RwLKys/z8JPJ/cgT7RwSCAv6rE9qIBwpO9dvj
	JJU1aUyVMnvdq5S/xWcjzCca8Bt4ZFlP21HrluWLzbf0nfGdvz6P0lM14VRSIy0W9yL5J8PkrTz
	DCX/sx0kDQRJqnoR+UbwSQFXOCEABCRpggnk+2c82DcayQOXB+bzfiFChWsICvYnFe8szx4mX9I
	Jnl2n4dDDGcTfXglmy1sb/0bsdjFr0Yimt/kr3j0iT9VGcKO8im7lTAcbGjtqF2q5
X-Google-Smtp-Source: AGHT+IGlV84njmsg/Zn6AwMaVoFRHS902Wp+Ju2NjIyJp1Up/117RVQZaBJ662IE5zhGOk4bjgGZBQ==
X-Received: by 2002:a17:902:d489:b0:240:2281:bd0e with SMTP id d9443c01a7336-2494486ee13mr11273655ad.2.1756524008004;
        Fri, 29 Aug 2025 20:20:08 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24906598808sm38215555ad.116.2025.08.29.20.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 20:20:07 -0700 (PDT)
Date: Fri, 29 Aug 2025 20:20:04 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, akpm@linux-foundation.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH] mm/page_alloc: find_large_buddy() from start_pfn aligned
 order
Message-ID: <aLJt5GtJLGM3wc0X@fedora>
References: <20250828091618.7869-1-richard.weiyang@gmail.com>
 <489045AD-70D6-4167-843D-50A8DD19870B@nvidia.com>
 <20250830012505.v4qoihdqi22na3v2@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250830012505.v4qoihdqi22na3v2@master>
X-Rspamd-Queue-Id: 5A5AC4000A
X-Rspam-User: 
X-Stat-Signature: y4sywasarwb8n6zrkukxnnujqerq6y55
X-Rspamd-Server: rspam09
X-HE-Tag: 1756524010-183238
X-HE-Meta: U2FsdGVkX1/YuArMKP3sgznu1G/eDUMtfgJRcvb7s00qYrhazu0EwBrg3zXGr2AXG1tFoT2k2dKnJwpe0F1yQe/XX1aB9cKMT2+Wi6mQ+j+5GpqlxcYuiP0vG462P++FLaCyOTa2a5l6irKdaQEu/YBNFbcRjrNpfAyldJhpgxdHQoS4fFMUnPb0Au9npiXEAYqzjVN8WV4UO6VPAHiFR/RzArpPTtsJvRsaAMzc2pw6hcaHgDRVHHU/vk/Sp4AUDaeR0mi3gdex/TIclBtj+KROPAMTZHcKTn92K0vtJFOmUCuqgqnq8PuCwNbrJsQyIykqthjnRFyN5Tp1ditlo7xZ7UKEPRd7MjI6qQjqHIZ0+NZSNzaK7tzeu3pcsXubiP1U/lnBuVLj4DXyjmBJQhyreUoll2Ezk/1fUEcplzobk41md+WxTq4C2/hX/UBGWsCU3y9M0bmZYvgY4nU3G4KaTZoyboCFFG/GSSN08jLWJEIUIAcvh3WVoDBK5xbStjfyBVeB0B9ai6cSsyZSoXlrkUZykkALyTZ1a4gIH4OGfk9tMrr9YxnaZPAakYRiyJAP4685jmSLdl5ZNRvJ0bey1dXje9pESuff+RPrcxIAwFI7e49RN12UvQ3SpcFEKMofJd1A7oNul6yCjKTitURkj2z1liAyJSccGJ3oQ/tn3zJuzMVtPwlvNGV91tiYb/1H+eD8rdUvdwQFcItfGu9a55vIQgyA+0LfZrKyX83KUzjloHJJKgt1i0kjBbSVh6DC6srJAGNX2Nvhq3UkY+XAAoJ3bzgJRAy7efNin9xHXOCDxilE71ijUIrsFW3jqyWLgF9DCKkrJieRguGlk7REZx4Mq5rF8V8MsN0B3tYzephgKCugCPPQte5RwmMfh9jboFY2hSQeeUDmBGx2ktBI4BfzaglRJL1mTREUuqHy0pK618UcO2/ufQvT1aTjuQ/jtnSQ171xtsF5YPr
 AO7aQIPy
 ocBrCmwARMegU8Sz228wNrGsrYnsyVdyJSNpQMSlpaYSl9NXwhJkrmPKo88oQVc+MB08T+0Vz1r8jpVzL6O5hHQMiq5EK3NZAD5+b3Fe4NlFz74RCfZ86OZm3EK9nMq36sPYWzbqydiYFKgbJEMg2tsIfbPn6VHwbZRHnDX7k9OaclBdMnSZDOKTyuUv6/UW6SQGpOdNVYCxiMqncrEtfBVW8pDf/DiHZ3Ubrqvs8mLp2iggklD50mA34ZqMen522N/xv9EiDay8lUarsu4+tJ0wPkN6x9RwxJ/Yu++HxnPzzbdbPFEgQmApnR/jOonA1ARb+7Gr47rSTymiya400zinSXQPCn4/SrHIHXS7Dt/mV0Szrr9pmrtAr+HqzILvI65/vmfZr1zDHuUegrXXVoP+hwRsPxdDeF1xCtGyKZg2zbswvGp2l+ppwfyXGSdi9ts0C8aBsyU3Tcs/hDXoNTzaK4LldXJgTMyswfdeswGU1Nf1HV38+AOFAwS+npzopTdjWfYhMfYaBCYFzOftW+mIAGYVC/nNokIX/f56jacNPtJy7oi4qeCuRMwd+n3GhkKhcoZ3WEObregT/tzP2SmvRs8zZWm8l7wEyJjItwo1W7+gW15RQ/JFG3lv8uqhR8dw4gCYJQyo3LFq/nR6IXvioYtiltPA2qSW9jlqZGffN3e9jPDSG/jitZa1MgENvi5zF7UWeQPi8KQk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 30, 2025 at 01:25:05AM +0000, Wei Yang wrote:
> On Thu, Aug 28, 2025 at 11:02:33PM -0400, Zi Yan wrote:
> >On 28 Aug 2025, at 5:16, Wei Yang wrote:
> >
> >> We iterate pfn from order 0 to MAX_PAGE_ORDER aligned to find large
> >> buddy. While if the order is less than start_pfn aligned order, we would
> >> get the same pfn and do the same check again.
> >>
> >> Iterate from start_pfn aligned order to reduce duplicated work.
> >>
> >> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> >> Cc: Johannes Weiner <hannes@cmpxchg.org>
> >> Cc: Zi Yan <ziy@nvidia.com>
> >> Cc: Vlastimil Babka <vbabka@suse.cz>
> >> Cc: David Hildenbrand <david@redhat.com>
> >>
> >> ---
> >I think it is right, but the code is very subtle and hard to understand
> >after the change. It is better to add comment to explain it.
> 
> One thing I want to point out is in __move_freepages_block_isolate(),
> find_large_buddy() is always given a pageblock aligned start_pfn. This means
> if start_pfn is not a free page, it would always try 10 times until give up.
> 
> >
> >Paste the code below for more context:
> >
> >        while (!PageBuddy(page = pfn_to_page(pfn))) {
> >                /* Nothing found */
> >                if (++order > MAX_PAGE_ORDER)
> >                        return start_pfn;
> >                pfn &= ~0UL << order;
> >        }
> >
> >
> >
> >The code tries to find a PageBuddy starting from start_pfn starting from
> >order=0. When entering the while loop, it means PageBuddy cannot be order-0
> >and ++order increases the order by 1. Your change fast forwards the process
> >based on start_pfn. If start_pfn is not an order-0 page, based on first
> >set bit in start_pfn and how buddy page is chosen, the next possible PageBuddy
> >order can only be __ffs(start_pfn) + 1. Your code starts order at __ffs(start_pfn)
> >and it works because "if (++order > MAX_PAGE_ORDER)" increases order
> >to __ffs(start_pfn) + 1.
> >
> >Can you add a comment on your "int order = ..."? Something like:
> >
> >If start_pfn is not an order-0 PageBuddy, next PageBuddy containing start_pfn
> >has minimal order of __ffs(start_pfn) + 1. Fastforward order to __ffs(start_pfn)
> >to remove unnecessary work in the while below.
> 
> Sure, I would add a comment above the assignment.
> 
> But in my mind, we are not farst forward order, but start check from order of
> __ffs(start_pfn).
> 
> 
> How about: (not good at commento)
> 
> 	/*
> 	 * We start find large buddy from start_pfn order, since a
> 	 * !PageBuddy() means all lower order page is !PageBuddy().
> 	 */

Personally, the way Zi worded it makes more sense to me. Maybe replacing
the second sentence with your comment is fine, but I think Zi's first
sentence provides important context in a clear way.

