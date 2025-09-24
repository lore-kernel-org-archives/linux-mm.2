Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFEF3CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 00:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAD548E0002; Tue, 23 Sep 2025 20:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85428E0001; Tue, 23 Sep 2025 20:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC1B38E0002; Tue, 23 Sep 2025 20:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A9FEA8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 20:05:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50023140656
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 00:05:33 +0000 (UTC)
X-FDA: 83922199746.08.AC13B31
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4A55E180003
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 00:05:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QwYVDpoL;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758672331;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s8LFgeXb9gHKtwwpVM/3DbEOOlwyLh5XmXzOSt25IfQ=;
	b=2/V8rLmlXsXJejc4fz9Y6q+4/bOsirM27XIBhiJ5sFERku5JyaKCIQ7Ck234KLuYYdCrGf
	g4C4aaPaqW3TkF19lXZWS5tKdDAac63LRDRYftxGaJSqveesUz932IDZPLthyrFCFvYh89
	JjXeYJTpHmP7JUAkmH1+Fd8frt5E/8c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QwYVDpoL;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758672331; a=rsa-sha256;
	cv=none;
	b=2XEPOxTpwH1KrltfWS7Tf7/kctciXjAFgyT4Txu2NRaxhgqRdll+6jyBdJTXsZva1goKs2
	jJUVY0TQsv4hoT3PJyiOpL7GMzrnViQGR5YMjVycuxUN8r1SvQ15kPE/t7gG92wD1heYJf
	6NL2cd8EvdFvLxAs/WDnQPA8Lty61QY=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-62ec5f750f7so10495178a12.3
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758672330; x=1759277130; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s8LFgeXb9gHKtwwpVM/3DbEOOlwyLh5XmXzOSt25IfQ=;
        b=QwYVDpoL4fEo8lTySzKE4zgCES8a5V+fm7X+TSOjb+sXT9y0bkiJ9X/BGDDUgLv2Kx
         67DhssCNxRrJq4KYqRQnbM+b1b+Lh28YOqASNlqAWQjZA+7QfSq/g5vI+dp79HuryYZc
         jdjy8xGaWR2souFJ17JVWMezTnqvAEewzxNjMGfQFFpldjioyO4C+TG+/Z6A2a9WPBz/
         5HtxXU5sqtrfR7vCnpwnM1Vh74PfkxfAOq1C9NWbBG6RVWKcR/Xa2RqgAtkEbPLH3N00
         XcgpBhPjGQNIotpISUXuU+zbAUV584hMQKCzoSwvR4nGwuxiKKm5ET1aYOVWoUJiULni
         IQtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758672330; x=1759277130;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s8LFgeXb9gHKtwwpVM/3DbEOOlwyLh5XmXzOSt25IfQ=;
        b=UCf0X1Fp0PGut/+28MUkJSeoUTS3fqf0k4caqyOZgxJJoSUvMfTHc8uF2KchTopyvZ
         pP26unyWdhVgb9kQoMhIbWWh+m4EuLqWcmzfIw/q4THmjrH7OoKvb0L0YPE1zraNM9MB
         VtKBL7nqR70gwHpJO58qyS1Y6pt+cQa9RgUs2dM8Xe56QuJRXXReQikaZgunnp3ETzoM
         cpfElb66x+4DUfmBGOHp6uMt7e+RTeVYvbOc2swzg1QuHsCisi5+58tgVhanJMLqep7P
         d2vvbTUDCRpG8eEp4rEp/w3gzvR+69FTJOSOAwIEqaD8TkhgxfCtocV2kwFlexAgEWn1
         8FHA==
X-Forwarded-Encrypted: i=1; AJvYcCXrmynU64RG9S75KuTgLLFEpIXKPlWXJVJorKpVkm0vOpczSzP+Um1ArmQHChLQxiaQvw5xVmz/gg==@kvack.org
X-Gm-Message-State: AOJu0YzQBIqLtv3uqm1uUi70GY4Tklfs5TFt9v7ax+nji/65JX2BLJeS
	5tyIL4DVAiCOAAwy39DXu6/cuZvjw0g5KA6wnXBSL+/ZOJnT2ynql/G6
X-Gm-Gg: ASbGnctgQcpeMuxOtdZQRjyMMX03+NBLJ0P2pDjgXdXSNTnjEJjf+LI81DZiRgdIMHt
	nLdJhtdFfnLbk0SC3BU+uItZWwRFZZT22RpFQ+wnkGfaJwfFMip4uKk6FntniY2VBkaBQr1bNhy
	Y0CVgU4onVd7t5pfAAyBiQeIoks7XyUrgIUmKGtBPBraFoIVNLu+Pu3O3GqhixAMoWTOFwSxzoI
	x7PwxbHZiJSj018Bdx1qn4cZtLSkFJatSP5rxi+lWKMHOrLWGeFOg07IpkcOkZruEm4upqaUDfR
	XoqEpnLGTKgI0UvrzO7PWG7jumH5V1q1d0B2E+6c66yNqdMv+kpxcRPOK0IvQS8JVNdwYqkXGFR
	KeH09+ssd/taueCTquGwBj/BUnQwN2XY2
X-Google-Smtp-Source: AGHT+IGOh6rjhc8wkVOYKKj8yWr9c6kHArw3jCfSo9xui7yPRJT5Q16CQsUetAd0JYmYPqBICC5LOw==
X-Received: by 2002:a17:907:7e88:b0:b2d:b5d3:9628 with SMTP id a640c23a62f3a-b302ac2b7c4mr369546466b.34.1758672329351;
        Tue, 23 Sep 2025 17:05:29 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b2761cb52fesm982792166b.59.2025.09.23.17.05.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Sep 2025 17:05:28 -0700 (PDT)
Date: Wed, 24 Sep 2025 00:05:28 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com,
	anshuman.khandual@arm.com, linux-mm@kvack.org, dev.jain@arm.com,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/page_alloc: fix alignment for
 alloc_contig_pages_noprof()
Message-ID: <20250924000528.plhmkfn4qnx44a6x@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250923001943.2479-1-richard.weiyang@gmail.com>
 <aNJMSNYflPqYMjuE@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNJMSNYflPqYMjuE@tiehlicka>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4A55E180003
X-Stat-Signature: zhmwbqwfdu6mix8cmmxwiz7xbu66dmzx
X-HE-Tag: 1758672331-530141
X-HE-Meta: U2FsdGVkX1/svGQx79lMfYcN4LzzzPWEdScHuAAjn4oiQkF4FhZk+PhBrzM1bommrkS65wJ3oRlN6qaQwhloGnrGGgfOCRKfkLDw6j50lZ7XeMPrfE1wXIHBws/V2fAcJbpkeHrxBELele5ods+pRFcFqmhnr38VSY7ZzX9PBiWYyRgGCpWcDj/DH7awQgYWVNEGkrSSDkGQAHUKuew1wjxoTLV3giJea4T/n9ni6G6D0CqS+Gw1LkwWDUEuWb6Z5lwuKFhBY2R3S8VTBqfLSwzBf06ntGIbJbosaX8O/ijxCQ4UCsq3zT6C5APZLCSzglGfIFnJvyAHaaO7hHFYppLwsZYwiPPqa9a7ZMlRNQ/ERKh655t5XeKtztK8WYLLc3iPqy0bemsiDfT0kNfefuCxWEQU+v+pffbwJdu1y6cn9RvF8TAb3QD7u0+FO4B8cTHZjRYH6hT7QfujerADiJxQfOvHh6Z5DJWYnscXUDvMkzV5CPN57DJbwRkT9YI9uFS+ezKBcSzIYaiw73zQOltKmil0AgGr23ysv6HGJBsf6LPQDcVvpERQkCDK5lldq6V8rfu/tDQA4RW8wxprBH7BaI69ayJOBranD9nvaV593yYEviq6nthacwR/4jmp3/RR/D4FnCo05+jFFrb/I+67i1OYwF9NcCHSoR+kSOYKR7nysox0wV6SKusocs4quQ0jhdAowYAg988TrO88p01CT3FFc5GExZ1XcDNNsDarezHJvmmO3Hb7dlT8u1ofrmOuHLrnSoK5D3ZYIurkYYWsaI1yZUPaaUbWNft75G9HwIh0i1NhGEP/s82zU42DegRSIuAOP42Y/sNZw7hGj6AWjxC/AfrJVXKYL9u+xZP2TTiNr7MXIfYJuKMtC+FH6sutnCxZYgAw1go7kFVigdsaIxnMObL0brYsVnZhFPPouavEAl8DLOf5QaJM8g7UUfcJFyGvixs1pRHZRY7
 df0XbraI
 3o26pJQZLz9nMw8Qbh/mC5/fnvcJw0BlF75hHcRgirRld39/Wq9AF6mllzSGpo7SciYE1wsqcBK9its2v+BOBgn7ceIapd2Z05MQsYTf4QopO5SvgMRUa4N+skBASl1YpVoy3FkICX0V8WWWUks4S+NFyRlmLXMa9a6tvTfF38QehKbercRLykBnK2aD+TKhYbrVFPLDJCdLMhPzcYd73zSQr4dMKfP/k7s6QYb6EiDsZ45W9zFC7s8/GapKPEkzP1WY39TZtuGNz43crtOIz33QN48GoQqslBavlWSB20qO9YxNjdRYe6Kkor7dMu4e4ZiV2bjC6GjUffZzvYP1PuTlBSJVM+S19Vta1+eD4WMZWnPGyeHSFA0TxuRGJBrTuApNpplqsa69v7mnMq8sCCnbJjeW0G7/H/WrvIW5Kv6moxOKAEYAJoUNkfwU6U41h4FQ83ZSS+98DXYHoxytX7IgPyav/HGPQMTVdwZpo9e7iRNR6wJrKs1kj6UkRaaXzH7b9ue5prMmEgYibMw93S4BK2y8gkq1zalbE8SlAUQT5qQbnlySryLm27P3F3ytswjvWaaW9ywNVZU+vKLVReTRHcTX6GfkBQE2v+gL/he/3m4Xk4vxzNE+X+6Dq85DY62Z6G6oK2kcQtj3QY3xJG6KQDD1Xiky/KM086Koat/aOFL1os5eCCgu2GsEw0fzkasycI5vbJJYZ2nDekFo7pfFR1CnDVl4c0dyytNYiwfsauoYlFOuRxdJbLFAwjGqPrHEf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 09:29:12AM +0200, Michal Hocko wrote:
>On Tue 23-09-25 00:19:43, Wei Yang wrote:
>> Commit 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
>> introduced generic method for alloc_contig_pages(). But the alignment
>> calculation seems wrong.
>> 
>> Since ALIGN() only accept power of two value, while nr_pages could be
>> any positive one, the result is not defined.
>> 
>> Use roundup() to calculate the correct alignment.
>
>What is the problem you are trying to fix here? The ALIGN is certainly
>not well defined for nr_pages that is not power of two but does any
>caller of alloc_contig_pages assumes any specific alignment, especially
>when nr_pages is not power of two?
>

There is no real problem here. The initial thought is ALIGN() don't expect
non-power_of_two value.

The discussion above sounds reasonable, we don't need alignment for
non-power_of_two nr_pages.

So this looks we can start iteration from zone->zone_start_pfn for
non-power_of_two nr_pages.

IMHO, How about the change below?

    pfn = zone->zone_start_pfn;
    if (is_power_of_2(nr_pages))
        pfn = ALIGN(pfn, nr_pages)

And it looks making code consist with the doc above.

-- 
Wei Yang
Help you, Help me

