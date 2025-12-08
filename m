Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DD54D3B7EA
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 16:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 325446B0005; Mon,  8 Dec 2025 11:47:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6A76B0007; Mon,  8 Dec 2025 11:47:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EBD36B0008; Mon,  8 Dec 2025 11:47:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B2E26B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 11:47:11 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74EAA140184
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 16:47:10 +0000 (UTC)
X-FDA: 84196883820.05.9063CB9
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf13.hostedemail.com (Postfix) with ESMTP id AD7AD20006
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 16:47:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="4H/ScCJX";
	spf=pass (imf13.hostedemail.com: domain of 3CwE3aQsKCDoWYganhaupjcckkcha.Ykihejqt-iigrWYg.knc@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3CwE3aQsKCDoWYganhaupjcckkcha.Ykihejqt-iigrWYg.knc@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765212428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y21xYnymZNnyNmi/HtnuQMz5IMpcwyYducXo/2wK1DU=;
	b=rGaIQLMt746jqntX27GXR2b9sbQZNyrpZ8VfizLF5hcZq22bH4Utirhp+Nl/o8i83tV23a
	ddRSeiv2MtOzv324EEz3tSRRjwZSne3eqJqGoYOtITlqh9aLpGyz1NCl2xwG5fcjMYBytw
	+xy6jxHXzETn3DIjZRk/fzASNO6osCQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="4H/ScCJX";
	spf=pass (imf13.hostedemail.com: domain of 3CwE3aQsKCDoWYganhaupjcckkcha.Ykihejqt-iigrWYg.knc@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3CwE3aQsKCDoWYganhaupjcckkcha.Ykihejqt-iigrWYg.knc@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765212428; a=rsa-sha256;
	cv=none;
	b=GzMkWzkAzvC6+cfWDSF3NxlR9FMZ1B+omhHQXOIZ4W9v3Q4qkElr5jypzUGJLuC84rVz0x
	Y4WBaYj2isl1ucTzgOhMcQ7zHWXQDJRrnLiAN7afrbB9t6pmr6Gm2+mLA8iLqORQcpi28y
	h74l08Haf6A1lSqCSIn+G/rDYMwxhfs=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7bf5cdef41dso8211633b3a.0
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 08:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765212427; x=1765817227; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y21xYnymZNnyNmi/HtnuQMz5IMpcwyYducXo/2wK1DU=;
        b=4H/ScCJXWP2DewEkA5ELvCry/sSNZDt0vsLVY5n3sonB3yHD+1WkdRtvDAkEE6yT7Z
         GMG3B3G256LkK4WfwdE+qO1xoASYKd/IylRsItckZCAjg4dNC2gUJAfNSVhFzMN7QD61
         KILnApFK1qYqmQ4MAXUHv+f+JcxLmblnsnkqW4wfRWQs5qPFaajZqUBoxX08nu9U+xlA
         L4yvzKtEKuSnz66BPI1X5tNDk1UiVnzincpaU+oU5cDbhQbaDzAOSMvZ4GRCoHQYESwq
         kkV5leXeZDyUOLFGErCl9aF4Yax41aUOdjJTmETRLaqcP6OKRVK0g5Wi5ntpFvFvelR3
         chCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765212427; x=1765817227;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y21xYnymZNnyNmi/HtnuQMz5IMpcwyYducXo/2wK1DU=;
        b=fIO/ksdzrmoqbGocF1ogY0vbzOLL0LN5xsdSzAm9Zaaye4QCvqw6Bgclt14MEKxIsS
         13ZWb+9kbVt+UEI5MWsFM8A/iE4LUvlA2j+7UIgT/2Q3f2okTJwm3amu2XsyudWMoCkm
         ev9ie4nRkrUy50DntD/Mi7a/6Mdiv8bIKS60QaGwii/XvoO1+3wlQEPBF8jQBEu2VA+n
         Zlc7wiVUQzJKrGT32pyI8O5YAsvKISzrMHb6liiPHuUWVmj7R1Rd9JtGCT7uA4JvLKaF
         c4JwffL6en7ITXRqLbZt1ERR7etzqFdMFuhZfdptcjK40kqq6zW0mZIId6GLEz4w/PVS
         30Iw==
X-Forwarded-Encrypted: i=1; AJvYcCUhs+dGt91fkmQuMhEo6mgKXwN2vbRRRRPcmp1UK1+HoYKM4iRj2nah8X+u/4vo5XLKkuvLshGgrw==@kvack.org
X-Gm-Message-State: AOJu0Yyo6aX64SS4/p6ppf4R4gZlJ0PH0V/rk/iLSMRmAa5THaL2HJSe
	TTrOGsnaf6EVwhkzdeRVmMDFaVtefnjGWKj5ryqUQzohX6/B2WZlxoeKA9d38f7cdqlHijYO4P8
	6D8omp1sGsXEZc0sviSoC4FZL3g==
X-Google-Smtp-Source: AGHT+IE5FQZIbtJOztigBOS9Avg82hSfSlcy7E3hwkLPHM/P7YdR0xqCIo+8j17gC4LIdPH64C7KVQUZllrbHiWF8g==
X-Received: from pghx12.prod.google.com ([2002:a63:f70c:0:b0:bac:a20:5ee0])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:3d85:b0:35e:d74:e4b6 with SMTP id adf61e73a8af0-36617e37d65mr8176588637.7.1765212427234;
 Mon, 08 Dec 2025 08:47:07 -0800 (PST)
Date: Mon, 08 Dec 2025 08:47:05 -0800
In-Reply-To: <E3AB23B6-9B6C-432C-BD92-27520ADA0739@nvidia.com>
Mime-Version: 1.0
References: <20251117224701.1279139-1-ackerleytng@google.com>
 <20251117224701.1279139-5-ackerleytng@google.com> <E3AB23B6-9B6C-432C-BD92-27520ADA0739@nvidia.com>
Message-ID: <diqzy0nc53au.fsf@google.com>
Subject: Re: [RFC PATCH 4/4] XArray: test: Increase split order test range in check_split()
From: Ackerley Tng <ackerleytng@google.com>
To: Zi Yan <ziy@nvidia.com>
Cc: willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@redhat.com, michael.roth@amd.com, 
	vannapurve@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: qb6jj515whcmxm381cqadq6woyrrg14c
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AD7AD20006
X-HE-Tag: 1765212428-142305
X-HE-Meta: U2FsdGVkX19Bf2C8YXBt/rWJ8R9oYunc32IJbLlD9YLkbrfvFWwfYrl+g81A9RAbukvqZ45oa0QSRdNUJqPk+83ER4hD9r9GdEKFdhqcVpLj9pVeAQks7wQALDSkkp5o6uEv0N5OMqU9+8V2lYznbFVaQnIcUKm/AjzK0ewWuRBgk2XjDm/SHhI3ibzm2k+jwNePvUV1Q6S4uSPmcHVl1JG0Ud9o9q1ACwPoaB4oFx54vLJY0gdqWC02PFROeEi+nDCB59p6siO57xBjtC7w7BMI2sgWALSH4tvraJF51cDw5lYvbZ0nPmL9Cle0nR/Tn5uExVK7k8QFZyIBHn2JbErt4lmmq5sAhWJB7HTA/64VS+gtYgqwqZ+oR3vaR/sOTXHDsT9S1RC37c4kkfM5lLsRlAH+E3gZlYKkqQWlQo4LkpNGa1t0W4pIUv50dwsxGCT7IzOevNTBDPplAm+I7B7GZxwONlvhS4eAaojMjw5hpjwvFiaHuFS+r/k8WKYbGXDTiHazWs3IwiF9BUUJn64wLoqhopfa8noVuSVJZ9IhOZW5MkVImTTeSbROJo74vDgfi2zqcFu1rqNioZLHvo3ZDcPXKadF30qiStiCEEtt0qRMQ7HvzVK6OMT6Lv9Krq3snFUvt8NTqpLKU3LmbRxd/fbtYW6kzGixG9rWJzXaFM1j1jFzhs0KqS+ipt44+M8MYAfXiA//YeDUWMkzB+HrwwstZq4xIewOtQoC6W1HAEZABp9uxNxJj/AePqhxk2AlnN20dUtjIqdtFIpKRAacmaXKS/dOM1NpaEDVtt6iWR+Y/r1CxmN7lACKH943i8eJ9T20lxmJz319Gbaio9GB+a6vxddUrXDRUN+tH/Viq9y2GzcVpXzOspGXWc9W+za90Tai+98KjNUKNoa7CbzgVgNFDf8GhqNATxd7HM76GxIzKA5jiRF4j8FQlHZu86c3C3RTgM/HAZhxhSz
 v502Ls2d
 VXts6c3gVmNDIosDKDivf2ukTqJGUGqrnMtnnqWRDBKEfZjbwXaF22X0ZmQ7t/aT53cwAtKRLrK76qtLxNzV7/UDlb9VDVDeUVEMvUy0uX+tOtYSE01vGMV2GVrGGCsevZW+afOfICMEg+rv26IYgKDpWrNPz2BKvblkGFZp0Ftr/MP3ZOXq0oiSaeuFcfEy1iWqSDPbV2m9uajsbKuKGGjgiy0JUcpAXb8UgSuufqvl2emW+iM0dI05zooVetoAhHKT5EZHJrmuRrLD5S/MjbWHcnQy9w2wWFCX9kjt3BsCUCWxemILrbh6NSnMKJ+JudWQbv96frcjIrbjzRI0fMz8p7SlHpH3kJRQH+WBisiAP22iaF38OiykXXM/sqOZTWqN/v9nkFyzJMVtKGoIVjCNz7EwZYzUbySG7rjHlPIKyn4sl4+P+N5zMA0RtrpibV8v5t9UInZvSA8MnhK1jr2V/2B+bdz7Vnq3+ptS1YWILZ4d5Qf7x3NrIq8SjIaD8iBM0d8jEauD0B47OSGuAlwmGZ10YkIF7ZxV8kAzTogXrGtKt+yKYufBjw0IJOL+2b4KxCf4E+lAPDWYhYkOnZu8pcFjuaUoCd9NCQ4tVzV6GxtvyQkvZSpYKJocg7AspSqfBJNVXRf6N/PYZruAMp9pO2W0HSwl1pt7CqUzgIYmtDzUca7IjJZo0W9UTd8zkESqzBpZ4GO79pNU/2zMnQd3Gsw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Zi Yan <ziy@nvidia.com> writes:

> On 17 Nov 2025, at 17:47, Ackerley Tng wrote:
>
>> Expand the range of order values for check_split_1() from 2 *
>> XA_CHUNK_SHIFT to 4 * XA_CHUNK_SHIFT to test splitting beyond 2 levels.
>>
>> Separate the loops for check_split_1() and check_split_2() calls, since
>> xas_try_split() does not yet support splitting beyond 2 levels.
>
> xas_try_split() is designed to only split at most 1 level. It is used
> for non-uniform split, which always splits a folio from order N to order N-1.
>

Thanks for explaining! In the next revision, I'll rename

  + check_split_1() to check_split_uniform() and
  + check_split_2() to check_split_non_uniform()

in an earlier patch before, fixing the wording, in this patch, to be

  Separate the loops for check_split_uniform() and
  check_split_non_uniform() calls. Expanding the range of order values
  only applies for uniform splits, since non-uniform splits always split
  a folio from order N to order N-1.

>>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> ---
>>  lib/test_xarray.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/test_xarray.c b/lib/test_xarray.c
>> index 42626fb4dc0e..fbdf647e4ef8 100644
>> --- a/lib/test_xarray.c
>> +++ b/lib/test_xarray.c
>> @@ -1905,12 +1905,16 @@ static noinline void check_split(struct xarray *xa)
>>
>>  	XA_BUG_ON(xa, !xa_empty(xa));
>>
>> -	for (order = 1; order < 2 * XA_CHUNK_SHIFT; order++) {
>> +	for (order = 1; order < 4 * XA_CHUNK_SHIFT; order++) {
>>  		for (new_order = 0; new_order < order; new_order++) {
>>  			check_split_1(xa, 0, order, new_order);
>>  			check_split_1(xa, 1UL << order, order, new_order);
>>  			check_split_1(xa, 3UL << order, order, new_order);
>> +		}
>> +	}
>>
>> +	for (order = 1; order < 2 * XA_CHUNK_SHIFT; order++) {
>> +		for (new_order = 0; new_order < order; new_order++) {
>>  			check_split_2(xa, 0, order, new_order);
>>  			check_split_2(xa, 1UL << order, order, new_order);
>>  			check_split_2(xa, 3UL << order, order, new_order);
>> --
>> 2.52.0.rc1.455.g30608eb744-goog
>
>
> --
> Best Regards,
> Yan, Zi

