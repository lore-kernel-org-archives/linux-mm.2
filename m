Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 863D4CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 13:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D92106B0096; Fri, 15 May 2026 09:15:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D414C6B0098; Fri, 15 May 2026 09:15:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2FA96B0099; Fri, 15 May 2026 09:15:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B2AAF6B0096
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:15:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4E7581208ED
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:15:06 +0000 (UTC)
X-FDA: 84769699812.23.7E552D9
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4282A14000A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:15:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WVhf23wR;
	spf=pass (imf26.hostedemail.com: domain of 3VhwHaggKCAMmdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3VhwHaggKCAMmdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778850904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=53U0/0WbYXGpXcNIwxeYgyri/QpasHpNUn8IYc1HDQk=;
	b=Js+5QgLQntJS0aLKzPNquvv9ujlW0NPNn01OxVJQ2YPR1SbDqgAfWIhoyBR/NtB/3/c2uw
	LplMreaU+6xyO9TOs7g59kFg0EqbI5xgFAxwx4V+0IQz2iPDdfHrdTWbPcpQ58nQFyNDiJ
	UqAUu79rfm/wqeeeCoTRhNxPhSGpob0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WVhf23wR;
	spf=pass (imf26.hostedemail.com: domain of 3VhwHaggKCAMmdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3VhwHaggKCAMmdfnpdqejrrjoh.frpolqx0-ppnydfn.ruj@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778850904; a=rsa-sha256;
	cv=none;
	b=m3yB6SHYrABpqIpc9ilm0oc0MezA9VGl6eyc9eDLAbdkd7ZiO9D9J0OzCit6N1Du+pDxLv
	GhYKWKxKZmXVHOn0pcud6re1GRm0dnigd9zhCpWR5ix3AiaNqVP4wVfR1203xlO2cOFaXd
	o+fQnIJXakj5DKjPBJ107u6XzGKR9Gw=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48fed2519daso3676045e9.0
        for <linux-mm@kvack.org>; Fri, 15 May 2026 06:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778850902; x=1779455702; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=53U0/0WbYXGpXcNIwxeYgyri/QpasHpNUn8IYc1HDQk=;
        b=WVhf23wRt3rH0IIGO7m5R5gDqEXvPE9ItM6szWwXcparQa8UNazzL9GHFbYh4kf/5+
         vftCfhvzcpXd6SXVMXOpn4nLzMVnnb3RC32IIlsMse0iiY+jfpxPOq3b2QRHG8dhhJ+k
         4NEIh+NqZFhFeAF7aoDwIi1qaWiyO1P5vTRwtka3T8vL8bMGnuofdDOkIkbzPcg/W1/8
         2EvpDRPLtq830EUPFtTJh7tnZTbw8ZWWBKA1Pw4smh5YPiJAwxs6qlSucvJHBMiX5zL9
         Ifzo5VethjSsoDiGSj74LHPMfwGdudb8hhkGRnjN1YPKJubUTUEbxlAcEEuEkhrbkL3M
         fXPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778850902; x=1779455702;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=53U0/0WbYXGpXcNIwxeYgyri/QpasHpNUn8IYc1HDQk=;
        b=BpP3j66k1FhYYColswvzgBJZtkibSqRluUAyGTC+iujVZz6CbIgmcZ6EhaFE0OnqtV
         EddniDfhPEB+DLLpo2Bl7q7E5sTfi62b0zNUcHoD36GCTVA77TyJwLarkuuwTpZqeh5m
         DRgm9cr6avXQBGntLte8e1DiJNMfB6ERTrxnA5lrrPTufCyOg6ZMG9QJlw7q1vNYmmWi
         fmiPyiowp9mgwzRFykTL2cLiaI/TsLzJV5gBJAykihJjP0h9WZiUt51wsV9xWu3ESoyo
         BrObctJnAHOwIN8tbNJLUg24Ds6/iVINc/JjLqRgSCoQuVO1vK5YlF0azZ0ogthW6DGh
         kz6A==
X-Gm-Message-State: AOJu0YyipNsLNeDT2Otj0R9BwQY+KZakaPmeH+LuhNtkuE9tCf4vqWvy
	y0sWssVqpX78xNn6zsHbozadf/dEGZvPn4gnCQ3KHdX69qWDz/YxACjO4ZkAGCWMT3MFL89IzR1
	A7pPv7P0z6i9ttA==
X-Received: from wmsl28.prod.google.com ([2002:a05:600c:1d1c:b0:48a:5459:ee82])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3104:b0:488:ab1d:dcc5 with SMTP id 5b1f17b1804b1-48fe651b57fmr51391315e9.27.1778850902255;
 Fri, 15 May 2026 06:15:02 -0700 (PDT)
Date: Fri, 15 May 2026 13:15:01 +0000
In-Reply-To: <4074a816-9e75-45a6-8141-25459bcc106b@kernel.org>
Mime-Version: 1.0
References: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
 <20260513-page_alloc-unmapped-prep-v1-4-dacdf5402be8@google.com> <4074a816-9e75-45a6-8141-25459bcc106b@kernel.org>
X-Mailer: aerc 0.21.0
Message-ID: <DIJA0MM2F3D2.61WBO3MJZRNQ@google.com>
Subject: Re: [PATCH 4/4] mm/page_alloc: remove ifdefs from pindex helpers
From: Brendan Jackman <jackmanb@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4282A14000A
X-Rspam-User: 
X-Stat-Signature: uff7ac8cnjzqstkegx6a191aqtuq1xj4
X-HE-Tag: 1778850904-743605
X-HE-Meta: U2FsdGVkX1+B0oYsl3Cd59wovuxnEykGco52hpdTzdD9GF8Lf4vvhmEbk5T0SFDEjBQPR/gqH39ZFqwEv2Dlqv7be4637ffktG856h7HodQTChkgJ+26onbXgGDbWtV0htXQd0yrj95r7KU6/r+AZItqGfPhFR19yj1bzqC07+FvITE9LFHtcV6Ozl+QhKacKntPe/fouLnZVDAtI0DVzNSy31O+khHvDsyuvivBSeZwTl1LiFYoXUvzqREPCTbKZ65R6RVeHDm9eNcJ7a8VrEeMZ9S8etIWM2S7jKz2TkaYOdgZMp2CP01OliawCT1BGWQVaDkYU7umhYkj0qwvxJsWPOO/CUMSEnJaf4MdQeiS7EvCOaz+hAb5Ds77Rzs/v/XXPSFbj4WhKWjO3X0nTaevpcmUauX8yMMDOF9zIneOVXS9G01eZca2Kj17b113u3C88zpfz9bCXik5vHfcE5NL/e5eyqRpuvqdWLSj43zxHouWO30+n2a+EBOFHDeNiiZc0qpPFzqAiue6eNYy7JxuoQCny6Fxc/cBdxJL6y05MvLAeS+avABEJIKK3WxDR9ycv35Oir5aLzO+WZJ/wPe5vQCLa9+r8idOBcx3dUBoH+i0ZbSM/HA4SQLbI7UjgnBtksyF5lYb2xeZ4Vu3UeQ7OeKbnVx9VeY1zR5VcqSzOwQSNZQbfVehNCHHFS4GnOFqPcNnOupGfcsVszUpEevrmSC7p9EtAWo37J60c5wy5+rjuD/f/XSJ3S2k4yaI3PBFWtmmT0Hg5oxgihQApBJ39b3EN+qRpELY7vPcsdR3oztQoFezaNTNfhTqDuv2hrki8oSRx5SZ54o7bDMk/8HCweH1pY3j7uxshhE0YxRSDsG2igiKGf+DwmpHNcDIsds51J11JHZSJbWr8WioEIzme4K/F1P79BSbkJmPGitBdzYZVI7pwsq85BAG6TviofooVdkE3YolbqOUBKE
 QhhNBs2/
 d62Em6ywOuJ+MJ351U5pMHqYQX6iaVz27IgZoGTG/55HZ19R91uOZGHJ5VKpW28KHqQeA61ArWm+IFLdam4XSzGD7UlN6P/zl7j0CpzcsSTmQC6v0lPr0x3G9vDBmiP9btcz2xQpsUknNNNVlmhqYZCXaqpGdsm2h/EEYzQFdiTPKqq4UOvBxhyJGJnzbBV5J+1OqXD57zpDoPmSTO4V56fU1OYrQCdkybLjnSRfwsIgYoZVZxcZMD2+o+6qdhLlP64j4acLNNK+xJgho8Xr11hrv0H/N59DqhpiNttr2ent2gQ+9kTxHnQ4lUZf7Ali2n2F2J2qek+Q7qDv1PM9ILcLiqneY7HuTkQc9B3q4x+NLBHmdSQy+XiEBjkYEXVcoMbpecOQnewirmfKPvmi5XChDPkRw6msFEJf127Hfvdj82nuHs+van2DcGDdkjV7JphiNYWGP08Zf9jtbsZI12lWM3MSvY9pKbPAIOwe+B/4owYd4ivOfD/JiDixa/TQZzWldOvCiBV8PCz32JBDBcD1v/PIpKjr7f5rA2PdAYjpIWuTvnN3uI5nbc6MeTgMuuhlAVja+tomJQW+uERX3THLi6lOPRWSIUqHQEBUjZAwYWmljdiVvJA5beFCJRYp5z0Z4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed May 13, 2026 at 5:19 PM UTC, Vlastimil Babka (SUSE) wrote:
> On 5/13/26 14:35, Brendan Jackman wrote:
>> The ifdefs are not technically needed here, everything used here is
>> always defined.
>> 
>> Switching to IS_ENABLED() makes the code a bit less tiresome to read.
>> 
>> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>> ---
>>  mm/page_alloc.c | 30 ++++++++++++++----------------
>>  1 file changed, 14 insertions(+), 16 deletions(-)
>> 
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 5d6144c8860ed10fd641184f389c4953465d5178..2985ad0ab1044bdfda8ccc7aaed2ded19b5ac7ed 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -650,19 +650,17 @@ static void bad_page(struct page *page, const char *reason)
>>  
>>  static inline unsigned int order_to_pindex(int migratetype, int order)
>>  {
>> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
>> +		bool movable = migratetype == MIGRATE_MOVABLE;
>>  
>> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> -	bool movable;
>> -	if (order > PAGE_ALLOC_COSTLY_ORDER) {
>> -		VM_BUG_ON(!is_pmd_order(order));
>> +		if (order > PAGE_ALLOC_COSTLY_ORDER) {
>> +			VM_BUG_ON(!is_pmd_order(order));
>>  
>> -		movable = migratetype == MIGRATE_MOVABLE;
>> -
>> -		return NR_LOWORDER_PCP_LISTS + movable;
>> +			return NR_LOWORDER_PCP_LISTS + movable;
>> +		}
>> +	} else {
>> +		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
>>  	}
>> -#else
>> -	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
>> -#endif
>
> Uh yeah, VM_BUG_ONs are frowned upon now. But doing a VM_WARN_ON_ONCE here
> makes little sense. There's no safe fallback if we end up here with a wrong
> value. 

Isn't that grounds for upgrading them to a real BUG then? My experience
has been (I broke this code lots of times lol, I REALLY struggle with
this arithmetic stuff) if something goes wrong here the machine quickly
gets irrevocably and undebuggably borked. Crashing is the best case
scenario.

> And it's all internal to page alloc so I'd just drop those checks
> completely at this point.

But, I won't die on the above hill, if people really hate BUG that much
happy to go with the flow. 

In that case, I'd suggest we drop them as a separate patch.

