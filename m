Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55EE7CAC5B0
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 09:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B71788E0015; Sat,  4 Oct 2025 05:42:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22558E000B; Sat,  4 Oct 2025 05:42:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5F698E0015; Sat,  4 Oct 2025 05:42:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 94E378E000B
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 05:42:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E15F5C307
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:42:22 +0000 (UTC)
X-FDA: 83959941324.17.C111632
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5F0FD120002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:42:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RH+mARzR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759570940; a=rsa-sha256;
	cv=none;
	b=ESfgxprNJEdrNR4XQ88lB7mz3l7tTqKD1aht8bgoSwWcnAeUuuAQT1PuS2FXN4T3O62okR
	yW1HmwsHgjQT1cglC8YXSNA40mmjD9n5FLV/LOfxfPxGlQAoCZIXYeEaiQFOLuhXMAbG12
	vzzNOt5bXhRMRt8uPdxp0KjW89ZqoqI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RH+mARzR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759570940;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GslXQjNzh/AIqv26b+mMupzmqLiHs7UYgH8GeJMNm98=;
	b=gF7IZM9K4LVPGQ/4UQ8pM6GzEfMS/VCD01ZkVkHb5mksdA+oSEqELzrrz71S0V8R4sR+kz
	/St9a7kTFnuQQ1dpnG7GGGs4WoPIozehjDcQfOl+EWngcQYie5dM8cHVDw6Knq+EFCIxLx
	LfXP36bCqdaYfYEmAxpAPEZbH88I1nE=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b3d196b7eeeso478916666b.0
        for <linux-mm@kvack.org>; Sat, 04 Oct 2025 02:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759570939; x=1760175739; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GslXQjNzh/AIqv26b+mMupzmqLiHs7UYgH8GeJMNm98=;
        b=RH+mARzR2IcItwFgSxcaWnAkaGwEQFVix4qTfPsrv50BFJKr8q8czqIU503BbMB0GS
         DuO2e95VqL/qEAs5r/YA7NZaYGpHL4MiTlQmHeeDcw7cJ8H9ts7y4PG7uBRJOyWJcKgI
         3XaZpSggDuP6Zu7wg/5sRboRg0Z7avqmYI7lk60HHin+d4JtmDEXtOWaDtNA4V5FyN94
         EDwxo48WtLWiSqR13B1TcYs0lHyXddz6Ys4wIaVmliSItmPVcsKqOtIAIvf+7cgUIlbx
         VhAYaZX8Fr/vbKN0N5ekd4I86NH7D/XVHSrH3Ww7LJN6ymu7pTtlnDqA9RAQNQMoHE3O
         JtUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759570939; x=1760175739;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GslXQjNzh/AIqv26b+mMupzmqLiHs7UYgH8GeJMNm98=;
        b=q05TiGRMS3Lq8Y7HZx899tZ6SlETKXeRvuRcig7GYhZ5hH2mfq8kk/4yvcoW8wgyV6
         x+WNEZyKXIldyngST0H8Hf8aWxH8f89lOfgPEsEMLbM6WT66vztgwOGlDJkgmGO2UxEY
         b9ABXKway/XxUHyRJjh95+/cByvrUEQ+EVl+ChR9sXAITsirBdEJahedgo6urxVdNRQt
         U4RuyA83WLo8rdLvvuqNBXLoMTiJjbi8q9MaRH3gt8daCMrOhlmVYzt3KNKG7bL0i61v
         IC01OfGdHh/4hvEYvf8VlVbiFIgPolhMoBm4cRWhG9lFdhe0fTzuMCQlF5e2xqL9EhNQ
         +F1A==
X-Forwarded-Encrypted: i=1; AJvYcCX+mec7tIsDIjKprs8ndv/i25cmy3dBLPcOi5jKWssxTFztVQ7++vgM7vE9FuJenGB69AL8XAzdVw==@kvack.org
X-Gm-Message-State: AOJu0Yx0QIVqWdvkEzMXcr3RLRvrmTLmA4LMz2rNLV5Gg7f4sacsc+la
	DPeMmC0feFQMZ0IjjKvD7EMDo2d7Jls/5dCanex4Xi6iLwV5gm5hqD/T
X-Gm-Gg: ASbGncvAwTZCwhrOYUmbpfA3gcHqmAoch5LAlSQR/T37jAYvIJ9uAY1iZRSztYhZ47V
	FT6GU1JQReOBevmRb/iPjH6ZTMAMT6hcLEbA1+gXfxc62HsjMhbCBN/QTHNP+iXf+jHAdYVdB3T
	vD0voq7VMRDD5seVWypK7v3p8mYaX/aO/vq5mkEMYsjj/r7K/Kw1VegN2KAlJfIOjeSrf6npFfp
	5QaDCTQUSZGXtoiKPf/DPpYnNPN/nrunhZ78/RUSt3JWe2+i9kY7uLO+J8FFJb6RQzdO1UZHz1P
	jrPmLlE4wziRDW92AHAWU+V6AXjcvzM8EsZyNGMvNemAUSHA0LK2+vWMxqjCdBEuaNa/QPsD2qp
	9grt0LlZwx8uqI0D1SCrXefWrNokJuthL1/HRAu5rebZ2cInYzVNBJ9tP
X-Google-Smtp-Source: AGHT+IELMv2JCHsGDeiciQPnXFlCugQOB1G8gJd+aFMXhX5vxBQh2qDM8E/2p3liA1SXVMjKe+xQxg==
X-Received: by 2002:a17:907:9728:b0:b40:448d:cdb0 with SMTP id a640c23a62f3a-b49c33501c3mr693267666b.41.1759570938685;
        Sat, 04 Oct 2025 02:42:18 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4865a83bd0sm654284866b.24.2025.10.04.02.42.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 Oct 2025 02:42:18 -0700 (PDT)
Date: Sat, 4 Oct 2025 09:42:17 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
	ioworker0@gmail.com, richard.weiyang@gmail.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mm-new 2/2] mm/khugepaged: merge PTE scanning logic into
 a new helper
Message-ID: <20251004094217.bah5q2zxczrqontm@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251002073255.14867-1-lance.yang@linux.dev>
 <20251002073255.14867-3-lance.yang@linux.dev>
 <0d55d763-81ff-4b99-bb13-3dbb9af53cdc@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d55d763-81ff-4b99-bb13-3dbb9af53cdc@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5F0FD120002
X-Stat-Signature: q9mfb7dsqshap1mieptdgwrwdysc4zf3
X-Rspam-User: 
X-HE-Tag: 1759570940-739761
X-HE-Meta: U2FsdGVkX1/sou/KcQGtQUmLeZlV4AS6S88nrfeBuhGSJvPtVO2H9pqp5E/4VDfV9k86wOvKLvlOysmJtbkRpYOHKUo0kxY6o7JWU8YDtADlixVRI6rykqATfUjVb7tQRCMrL94a7Lz2Kg5taY8ic6WlHrhsKps7FoJY6PhBdJQWFsftF6ggJwL6fk9EIwQB4h5RimKXpIMXp//kZXZk+tN7/5P/TPQq00ALWCLVwhpGYX28QIBPmJoD+wiLxL098zt9N4WM8tiv3YaL9zN/LR9fgt3WL/Aq527gRnCVU4x7VcKXHnwh5ZjWWuk+mZDXbzZid5oMJKoO9SN8QfKxwSRhxp4jHb58YBcJ4pWtAzpRFJEbbsFxeRWWY2WcT+fFA8M3kfMoKpvtP1MYbG2ebfSard0uDXdmUfm5V0f3fkTH2KfEdhKm0RSgGOfB2rTDjoRyubUY9+TQxo/aIdBEmjfac++msLmfbcwIW/btYkTtR3Xce3PG1VNaG3LSh74gVsfJiunciFiiFS9nGiR5jGZFauGfAR5d+Uij3d13J/y5reImdnjMnWW4vmWlQRgmJl6RchiHQnLHuaSlBl9FQXRtTaaLxeAM+MNMwFcnTXzofe3vJCc+MSQBdKf1CPrZwfhk/MtAeiplHqz6vqPY3Z4Ruyni6ZCT7YhT3uSkKuZeM5ND2k4IE2fIfCiHcghN9l9SWGyJ7Gjy8p7bIr8eBJ90VAh8zS+E7Ld/q5uZLtb15rCAnCyyVT32izS78OqSk6vzfI+frM/dqFQJl9wMWRi0zOcDcMkCf0xLyLJ/hRsyJ0X5LnE4Qd+ogqwODa20NzEBB05KqNoqU2ytt7IaXlVeVYWvFtwQOvvjht71/BAzxm6Ki1DTRYTl2OKlJ7SaSi+Ppfq/HSig3zeqH+uNr6xTSKDN7aguTP5p2qPrPYKlEwjryGrkdSQlIdkli42dlkT4kSQAIRyWjBB3GVx
 b3yFDLUk
 6EziEcxlWFOm4w54/3IESbi2DY9vbyDRzDhAXVh9ZgsPN5vGDJ0HhJ2OcBVg0KrLY8kNyJL2BOuxtCGChmfrrJmHhGK3gDluFVpUiDmIJ3cHgeH3YRX2ynqWf1UQ0i9HddZ315/SiitYCRHbWWqz6NG1NJ4hkVp2hN/OZF2fbbI3v/441uDXMt25YBr1W1th7NXIHVrNM8J+MXmp6uQK9O8e1u3duzfacDeYDE+AylnOT02/guPqZTrPCfaZhpijIoYNUYYNX0X8J/ykWi2eGXR9sLY/TrjoVtr401m6Oj0mie02Q4hVPINAegonPvRyHlfrET+WtnTHBRTzTCmI56cWdXursJU3vfrkOflVA4ialSxAbaop+C7OssbRKKCAey8AwB4Pj1SolAsii8szXIOmL7xVJ6kOlZFDG4pKcVsUcuOhbIoqWrIVJcrKI5R2+BGltV6o0E0QbnMaTQbWypaYHuKAX3W9zcNwuOw0s4C2D3AJYkCmLuSoS1LM73quokYwTkICXuFRt4d4PVTeyDqqM9NflWojpkFgsw64JuR6U8fjLr5s1OGI9jxf5PucyZKwtloTmtwZ3IzlMiJPr9mSCJxHxT0pJh3kZffFA4AeooOaQj7aAAwa4r4UN5E6mkrcPpA9qmxZlLq0IyygqkCJsQCnHfvmj41RloM1QYQnva6I4zAIxQWcV3lwbLCraDCF/Wb6o0ihicvtdflMn2caKo4kZb8YwT0t0Lougk0dCNRw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 10:35:12PM +0530, Dev Jain wrote:
>
>On 02/10/25 1:02 pm, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>> 
>> As David suggested, the PTE scanning logic in hpage_collapse_scan_pmd()
>> and __collapse_huge_page_isolate() was almost duplicated.
>> 
>> This patch cleans things up by moving all the common PTE checking logic
>> into a new shared helper, thp_collapse_check_pte().
>> 
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>
>In hpage_collapse_scan_pmd(), we enter with mmap lock held, so for

This is true for the first loop, but we will unlock/lock mmap and revalidate
vma before isolation.

>an anonymous vma, is it even possible to hit if (!folio_test_anon(folio))?
>In which case we can replace this with VM_BUG_ON_FOLIO and abstract away
>till the folio_maybe_mapped_shared() block?

But it looks still valid, since hugepage_vma_revalidate() will check the vma
is still anonymous vma after grab the mmap lock again.

My concern is would VM_BUG_ON_FOLIO() be too heavy? How about warn on and
return?

-- 
Wei Yang
Help you, Help me

