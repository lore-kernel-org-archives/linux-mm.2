Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC553106ACE4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 220906B00A6; Thu, 12 Mar 2026 16:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F8DE6B00A7; Thu, 12 Mar 2026 16:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 104EC6B00A8; Thu, 12 Mar 2026 16:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 004E66B00A6
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:49:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A67E2C1B7F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:49:25 +0000 (UTC)
X-FDA: 84538601490.02.AED8A5F
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id B9F5C1C0004
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:49:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BTBw9zvE;
	spf=pass (imf21.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773348563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lcxaHBH06BievOHzyx1+73CNXFI2tJTwpc5M6kHZ1Mc=;
	b=cIU53CCXOn2oU7IKV3BxfkNl9ElLNfN8DlIoE6BNrMFNn4DvQ9ZO06OPYUkEfrKAFcj7OE
	x+m17ph51YQmbh60Zb0tgdAEf6ErHkWd6ozoFsuyT7NNWpJdT6uo9iDhfwUSZopC8NbUmk
	OP/akfvMk5gd2gnFVwBma50GcIsxj8c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BTBw9zvE;
	spf=pass (imf21.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773348563; a=rsa-sha256;
	cv=none;
	b=y1MVESWJSuGvw/KCg47aoq43D060KoLiCFU7P5bjVl9VAHhSKEuEuBkfoFCqFFRfHKZNyY
	PRbtf4YZy7DxChdTHQm3982VRCXtcCIJ215S/2xUzeERe5F0F2yQFGDMJyL8l1Hxh48B66
	StiJs/tTUPkBfLG8JMsfncz5WB6FLMo=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-485445e80bdso12747105e9.0
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773348562; x=1773953362; darn=kvack.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lcxaHBH06BievOHzyx1+73CNXFI2tJTwpc5M6kHZ1Mc=;
        b=BTBw9zvEf5+mHhJ+0U0WZGZ/yrRzJTFFPG/A0jrLtbdaslWJKRlO8PrRvK3sJLjNpX
         wS+iMU5eSnM7/8nm3PDapIiW5PsV9mx/zgOPaJi+PCDAqdTJiyKg3nlxslmpeRD9eA46
         rcu4sKQAmNERYr4/nH7qOTAU+qEkKu6CKa/doGDBxk461d1rRqFc4BPvW7QAiNOT/smo
         ZUiBDjKvXM97NngT1AgMCaDJLyAw7gFBRtJR0H8adTmp2Od4md/VthVE44xbzpuMGWAs
         EPdgmwgjISrDoPbeun89bSYAZPg9E3fzrcPob7srz2Y0PH7gyzYIgqycHuIXeERENDZw
         6LNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773348562; x=1773953362;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lcxaHBH06BievOHzyx1+73CNXFI2tJTwpc5M6kHZ1Mc=;
        b=xPhTpeXQ2BZK/Qicokbx8UGiHthSPS/t0MF/nVquW+c3rdSkcbOwP+t8qfuMXjwv+/
         kVE6I3RQKMlPsbP70JBeoKwf7SvhyTeVcSmMw9hXPEkIIi+5Lhaq9eDvHtI9M681ewDS
         T2vmViROJTMJofx2QO7JtrbLsRWbbXCza/uH6+mq6o72lq0OdWcsI3sGpPvfTAZx204F
         dzAyvOsRgVjwaWuyGzh1gGeDeWeSbOLsTNizGq6VHPsaJ5O8OpQ8FB3ZqYO57tawCZg/
         sFxsUxTnv2XvH4smOPGQFXcsI6umPEplMtDSUFE1xJA1d2+7BFkL+4tjd2nVbyVdxhOh
         4IiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUotPP9VjCOc0ak1ZUKW3nyJ3dKrniSR8ScHtVL3NEqvtChpWhcw17z01CuqaHCc5sFR4PqRxFWWg==@kvack.org
X-Gm-Message-State: AOJu0Yx+DyUbAEsQ+oO3+DwfwYXVv4jgyEFGzQsmIiRw0gdU0AMWQV7T
	R6ydnpU42m2rucTdpj1Wi85uuXXUlAINLtULT+nLSv1bIIVcELy+OLOn
X-Gm-Gg: ATEYQzxS/iF1uUAaugMAP30Z1yqDLIi5oh6PjgoWGPuUjOBU6hxN6JGo11vYUtDtBww
	6v5aFttim0ZcmdbOCbVmrBV4H6i7SkXh1PrxI7kvPEljdx9OzVNu6YzG5qGhndKUEle2hDsgEyt
	BMSFZvDocfds/s3xgqUpZGeZ+5naNN40ZgCcI2r2E50JmNKI8tIi9L+9KFoVdj31XOBoUNqSRNS
	WPOEPttwHV0yvDMjb5wNvxzewBaZaksOlKgWYYA55cbyOxLtY6ctpJiyRPbv8imqZRYpM+UXxpF
	R2Zxs22XZQpowTAtzHiCRMEWgnq0m311b5T4DltUEOfUWpEY9fClvmiSgJxqcXOOip/WxJBlBl9
	njCaqKlIxIKCei58lnBdyD5E2l7BbtI1c4FkxMhIOsZgGVcUidxBuD6g6sNaE1eK4E0cAcRrmSw
	YQx3u52lKIKcraWIG5ldcoa9LqhA==
X-Received: by 2002:a05:600c:46d2:b0:485:3a03:ced1 with SMTP id 5b1f17b1804b1-4855672737fmr12323915e9.28.1773348561566;
        Thu, 12 Mar 2026 13:49:21 -0700 (PDT)
Received: from ?IPv6:::1? ([2a00:23ee:2968:90cb:1c6d:1979:bcad:501a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4855778d268sm3646795e9.8.2026.03.12.13.49.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 13:49:21 -0700 (PDT)
Date: Thu, 12 Mar 2026 20:49:20 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Josh Law <objecting@objecting.org>, maple-tree@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <b6327414-237a-4262-bf07-c506908fa263@gmail.com>
In-Reply-To: <20260312134531.49c1f9171b4b0bc8352e678d@linux-foundation.org>
References: <20260312184054.23481-1-objecting@objecting.org> <20260312134531.49c1f9171b4b0bc8352e678d@linux-foundation.org>
Subject: Re: [PATCH 1/3] lib/maple_tree: fix potential NULL dereference in
 mas_pop_node()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <b6327414-237a-4262-bf07-c506908fa263@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B9F5C1C0004
X-Rspamd-Server: rspam08
X-Stat-Signature: hqngb8e416hbhq5n1fr4g51potdj61uf
X-HE-Tag: 1773348563-189282
X-HE-Meta: U2FsdGVkX19zj9MF8/sz2pyP4Zn37Lm4X4Ept9RPU/Zb+ZSPhNthxMdkBDDPxLCeK4RQmnBWBFKnXXnAlz9JHkW8W0afjcUxbY1B/B45nWMkIlwrYS7qjqD9gleGTfc80LtPVVKpp15GkXKbuYtGRxsWAVOqPqWhY+ezZBLN3fffateR+sljlJMYuQKmFEqGRFE1AlOMQ1MBsW6E2AJ1x+50WW3QD9NkHgh3SRSFU3EOqcpv8fNitIx6MlUXVfd0V7NFKBlc3+n8X/TJl0PC9ASRl3owfLhSUqVKOXc3G/Y2gs3BJ41R5VlOdp9uLQAopKze4UuiPVZ7wHhze5FeuHJlTiYmVpaBl3907ieQxHr8DoRf0qpVpTm+MIr9X+HKDBVgdKpDspM4sEzi7fy7f6LdnWjxg/JjMNwV5+dXTdiW7a6IanRSh+pN4UiRmwBhiHIVOkKTZhHocKGYJMg7/p3jXkpMk8Jw/lIXRRRMu6bwWzY9kBpfx9u6vXaB2VqzWIt3QPKUvZrQKOLyOM+dr3nuAFIgW5ke1pylSdss+6IrdJ1bVX8ySvGUpHM+F2SrIixXLvk4TmEJwJN8v+4yYrzN1M+gg8oCOUU6PeTuvbFatza9ZaIgNuXvsJFnEnbwbu5effqFaA1zH83SMKMphCjH8Mn6WUKBjp2IWIetwYXanxeOkkJzsaDUBzDyJ5mZjUyuhxJIwV6vx5rRzMw7auaYVpdTGGIZORVWLrcoyYMrMp9AZ1bqT1b9C7dHKCmSzP9Kq0rj6NRvvRxhnjbsT2VY5DX+SW5wDc41f9q/SFSwL9MY/d9rllWE0O+vOwFsmJRYOAqiPA3wLiomKJ4+OIczncsVQFZy/RdgDngNYItd18nDDSa4aVHwxYZER3zCEPVlBKLJmbofj/PRdw208z9Kk1DwDqxlpbMDTPhXnQiAOFYriNajg/m2ph5sHZzWdK7QKWql9HH+UgCmTJH
 Q7oC1IMF
 3k0tGY9ryEqEmw/rXii1K6wdIzHToW08EQLMSFt/Um6CVpC5u323OI1dQ5wMKQNH2Vv+fYP/uo13vsIghCQ3fm0MJ8kbWavTAERgqL0jgF8tIqbE03kfhyQCQSYUKxTYKOGMLJAgqiU7rbvj5p0a8TabIo5hg0q7Plb0cZ3s9Gxtm1STn7WcCWSB+OX8DTWRTDdwTvfMfazrDudZym2yaht6kMqpnUutNAYkWkMnxoZ+H1R8TsOCrwogJqm2hNU8OZOvfimTxkU9Yb3Dwrpo/GgII41BWuDRq3+4ZPTtveKjvhT9znwVQdvXr9mZ3fk9VLCrph8S0MAugCzE0orJlmMDq6xVpogGwtYdzswb4X3fQQnLsTtcpg5xXnTlap43b1FkqFpH4U99/VDsx+A0lQH1UbCAW1y89AQqCOMTgoWmqTrfxyf82ldpGeEvAQcPGvDnH6ujyqzS1P+/G9Q4YKkzL1FfDdeD4yWO3KHTTtpaeV0g41/5A6HAisKXC0Cq15gXFa1hgu45ixX7EM+LPys6D+wvwC5eefQF4+2lr4Ei8P2zWl7yv5vl/xRdLR7ve8P7ZdYkSp8v+JcFcN0KED/qHoX7PvW8I4NI5z1vBDCNyTtcGW7F7wGmfqyaf/DwlDm/L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

12 Mar 2026 20:45:32 Andrew Morton <akpm@linux-foundation.org>:

> On Thu, 12 Mar 2026 18:40:53 +0000 Josh Law <hlcj1234567@gmail.com> wrote=
:
>
>> If kmem_cache_alloc_from_sheaf() returns NULL (possible under
>> GFP_NOWAIT pressure), mas_pop_node() falls through to the out label
>> and dereferences the NULL pointer in memset(ret, 0, sizeof(*ret)).
>
> This is such a glaring bug that I wonder if we're missing something.
>
>> Add a WARN_ON_ONCE NULL check after the sheaf allocation to bail out
>> early, matching the existing pattern for the !mas->sheaf case above.
>>
>> Signed-off-by: Josh Law <objecting@objecting.org>
>> ---
>> lib/maple_tree.c | 2 ++
>> 1 file changed, 2 insertions(+)
>>
>> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
>> index 739918e859e5..87a2ba6468ca 100644
>> --- a/lib/maple_tree.c
>> +++ b/lib/maple_tree.c
>> @@ -1063,6 +1063,8 @@ static __always_inline struct maple_node *mas_pop_=
node(struct ma_state *mas)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
>>
>> =C2=A0=C2=A0=C2=A0 ret =3D kmem_cache_alloc_from_sheaf(maple_node_cache,=
 GFP_NOWAIT, mas->sheaf);
>> +=C2=A0=C2=A0 if (WARN_ON_ONCE(!ret))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
>
> If we're going to do this then we may as well restore !__GFP_NOWARN,
> get more relevant information.
>
> But a GFP_NOWAIT allocation attempt can fail relatively easily so
> callers must be equipped to handle it - perhaps no need for any
> warning.

Well, fair enough, but WARN_ON is equivalent to a "oops! Something went wro=
ng! We will continue anyway", NOWARN is quite bad for logging that that wen=
t wrong, usually it's BUG_ON that causes said kernel panics and that, which=
 is a bit overkill, that's why I didn't add it, and it warns once, then bai=
ls, that's why I'm a bit on the iffy side about adding NOWARN, what's your =
opinion on this, do you think a NOWARN is better then warn on once?


V/R



Josh law

