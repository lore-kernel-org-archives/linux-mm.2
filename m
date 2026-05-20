Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02FC9CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 01:49:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EC6E6B0005; Tue, 19 May 2026 21:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C42F6B0088; Tue, 19 May 2026 21:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF69B6B008A; Tue, 19 May 2026 21:49:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE78F6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:49:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 87A90140E3C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:49:29 +0000 (UTC)
X-FDA: 84786116058.05.CA82408
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id 79C26180007
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:49:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iWGUdKqZ;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779241767;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GbAWmpIeWrmIKRd0AiWx+CX2tvOghhIGhH7OVpuTfyA=;
	b=EF2FzZZ4NaIClYn7vU96M/fL0tsMGr12rSZ95JhS23hFxyEI6fxZeKoUj7NrzDRs02/C0z
	ZkGezj61WNOFf9pV8P2+jReKROcybtCAcUmHEPhRcrp+8f1mM6mXGjIanzC+jWTyFcphwk
	rG59W0NUOKrz0W1hvL+3bmnHkIf0Q7w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iWGUdKqZ;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779241767; a=rsa-sha256;
	cv=none;
	b=zzjBnuJ1lV+x1khgtMOY9jEwM6ScjksaWjGjTSuVykevvxhMXd/9x6V/0oATS6q5Yo2kjn
	Qfom78ZpP+S9X7ypexWIQqFneZS4Cu0sBGY4BSywy6INFzYIvroLwUHpKhSrplUgWOMhgs
	KX0QSZKjrD4PHlPgVZ7dNZMOVjiZ+Qw=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-67b6da5a618so7355598a12.2
        for <linux-mm@kvack.org>; Tue, 19 May 2026 18:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779241766; x=1779846566; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GbAWmpIeWrmIKRd0AiWx+CX2tvOghhIGhH7OVpuTfyA=;
        b=iWGUdKqZHQ6re09K1RhePhwJOvA2xZRD3lkD/g8384LwU+xQQtnITJPexWq2kr/Tem
         x/IxrfXo0Hcdkb9bnyVywBXnw5KBsBb1cTkBEM3/kJVCfRROZJH0ptbHapQj/qRKKtlZ
         EtJZjmJM9EqDfIj+DNB4hSRSfVtWd+yht5IwQClffZ6aPL3R1gFJTpoSpaYnsOAOwIMv
         rWvTyKHCGVgPi6xlwLSqXxruvPkNqyqQc/G+rY/I/Po0RCa3bZOVL+zuYtJw4mYs7Rc2
         q1DY0rG2wIGR6ysJZYlZiTZUphMS4+cKvxxoDbkwNjrquaUqCLnSRKF7bgXDFKAqI0v7
         vsPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779241766; x=1779846566;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GbAWmpIeWrmIKRd0AiWx+CX2tvOghhIGhH7OVpuTfyA=;
        b=SDSRAW4+8vox/6E7w8bLj6aTbG7HA3RuB3cXmMnfDNr98PS6tkZUdYQL1K6hp9eoaO
         578IzYrEpIQz39UxJJ9MBTzHXhaseKsNdElUDCNIwR4w0QBiJLrDX9w3TlI3DjNt9l15
         A9wd1oD/BYRx9s3Qss5YQpbnQWEh/asfz4as4Vfg2py/FYCAwW69KuJxF7ZOH5EU6uEr
         lfRguVuexokf4detOgllfDyzaoyk4y5GMX7FeB2iFO7ZmrV/3Ydugg61hs9LFXhkHXvW
         fmL5BYIcjig/5Zez59krIAiJoBTVS8iZw8xkiu3ypug+ynww8rQGOvUUPTPhTsnAkM/q
         e+kA==
X-Forwarded-Encrypted: i=1; AFNElJ8Mi3nYCyn73nK+s8xvdkk4R9Ow0mX3sQa11lfE7XEuTc2N5dQZ22Nlaetg34j4TiTN+G1pnd8HYQ==@kvack.org
X-Gm-Message-State: AOJu0YwFgOsx2ShLtnSZjoOMlwHi17rwunGy8jkiQHwPDnWLUSA08VAE
	yZ/3H6uUjF2a0T3Zd7Xxk0xTKClRdYvHrxqqo8C1Yn0mIJLM6FDCnIzE
X-Gm-Gg: Acq92OEsrCLHfFIIp5sFGDCw7xnGQTk4+iB8BnHUop2DaGCy6RWRwXPdJx6GrE/9Ct/
	XckWMp6hXgeCTE82PS1+0R5BkpNcmJ7U3EMX2HoOnS//g1YkpBsyPu5uSeHfshc6NcO3wK4Msl+
	fiHhWo5zzOibAZGBboySfhX4DPBqspqJ1oGBkOF2w5DsnJomvvMS7R8lJwHTsfHMm1OhpYz462V
	qF1dkXkzD8kZjzJcItyBxzVQyP26QZVvhV5HIwzK/2gHMrsa7JmzqMNaBrUmpKmdNdln0vVn7JS
	v2vWIsVm5uTI00KNogEYkBgASm7rYqH5GES2tBJMCwInzdjNH98kvhVwPPkKLykn995QygqX/B1
	G6pNfnEs4yRB5GNq/ue1/50kVev7kHGsG7D7ynZbZB6rtpvcUHikkMSf0IQ2MKyfKQHb//UsF7o
	EmX0+NzyJrUjG4fSwoBm2ygWD16ljOy0bD
X-Received: by 2002:a17:907:8dcf:b0:bd1:2c29:a6ac with SMTP id a640c23a62f3a-bd517992f0emr1317114866b.44.1779241765510;
        Tue, 19 May 2026 18:49:25 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4ded99dsm770246766b.30.2026.05.19.18.49.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 May 2026 18:49:24 -0700 (PDT)
Date: Wed, 20 May 2026 01:49:23 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	Vineet Agarwal <agarwal.vineet2006@gmail.com>, david@kernel.org,
	ljs@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: check file initialization writes in
 split_huge_page_test
Message-ID: <20260520014923.zowt3fimptgzgju2@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260512074924.27721-1-agarwal.vineet2006@gmail.com>
 <20260515092211.qkmaxcofxwfdexld@master>
 <20260518163553.447a45c54a3d419b9bb916ca@linux-foundation.org>
 <20260519025141.lguv7mrtvqgqpltc@master>
 <20260519121813.4b188b21f7280d6e1d9a55e1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519121813.4b188b21f7280d6e1d9a55e1@linux-foundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: jutsqyjcnef79mwnj74jzsj6qbsk6gh8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 79C26180007
X-Rspam-User: 
X-HE-Tag: 1779241767-723555
X-HE-Meta: U2FsdGVkX19A5Ww7ITHvylpvbbJbULRYe7TQnE3prh2N03qioYzgOOsOTJ8/zhZBmethk4OEygUdtqB2x3fuHB+f9G/yRczJc5ClG+vRZ5KZTotU2zPYUa3OetEGLPH7WleC4qi/fp5WEiKUmoqywtoSDjt8MMhDx0Hszcl0XN7hqnlrC4ZdCzJv/3PR2Dy7VipbhMCjm46S1WPomgQbeNR52JScJMXXYDfLZ7SfCxuU/n+eeL3NakAYcVbNifv2NkF0Kyd5or3f/OZXX07TiMC0J545UxMP+ieBnoTKUHoEQ49LiQVQwUPrHdQy/T2aQDHI0Iv4s2YyxGcSFes7QuGPNQZF7L1uR23eyy7fYGH31iFPKJnic7ZZSJfHpLqCX5ukWTfNTZMLNm7ewGghSpD/1J7/ZkSMg4qs8735U2P8lU1SEBbwOGd2wIEUBQ2S68pxejG9hNpvIlfvPgmNo3UVmYd6GY88vFrcyExvVeDVScHxsF+U5dK3KRrFGlVklRE1XhwgQIcEJRhDoFfg/1uJOgAlEqp+8oeBYXk60SzwLRSL0sYnPCLlIvglKyUFh6Vfwe3IPmXIhyl2Yf3FB6Kd34jv5VEsZaoMAdRke4d+oubxVNPRzU1MiFFdMUnS2Y8s1qF2jGM4VqHUEeMjd+xAx0g4FkasqRt/4wC7cR/2gaq8RNrHY9E8XswcUjnQUj14xbd9DFk7Er4gmHw4t/RELwbxkct1V/zGYpFrZIVXzt6AF6wFiAtgKgCf0DtDy5lKgj9KGXXK6zkBM9/MgdWX7gSUEa0qmCfKbDz2kmZfkq8P5HRxWvdX9A2b45aTWSbmvQ1bKxErjxBboKkiw95s1KOb8xBFxTy+McOAJzLPRHC4CSH4eoNkP0jrvvs3XsbYFQ0I9GTcbTV80XljwDgB/5n50mABNm4d6p03HklDLPMP8jMo2Z8gATZq/7jb9pQcgvIy07WVv/IMLPa
 MV6h9Mq4
 fY0lOsYRj1sgvyyMx/b3PLD4g9zZ9/1qmhMXqDUUAHZLiEyq6IEbHQ7RC8pEXNUa9r2syN9DcPbiGg5chizUMpPyIa0jAOX5e6QD8UI7IOEpN9OpaqtvLYGK7123gY0ohMhRrF83goWqMqJHDXWmh5rDD12J+1a37+73RfedDNsgy0JFBcnZp57CTw/xPLJvHTZxtz2/OE58ZFCr7Li+pu4HAjHsipdY90SUprkDqUYYIBgv8gVoWzOXdM25dLKIyKba9QWyiYJSe5MBIGkr1Sz1ffXCWNLBnN++oFZSNKSEiiBiVLyD3b9gh0nlxspQeHvvnzVUqOao6Z6611oif6AvpghawUYS2bP61YVyJWbqMg1wDnU9puse6IqeZxi85oCUQt8mirnL6UV5LKdjEV/dKKrLkwCHZuIOTELIqC4Rqw0pjtzrphtre/UwUanEupTLMLfmxE7kflkC/cKHPuCz3gGXZPuRio06hKwoYNtfjFwomsdYfSmM0RUheyqQQLPaqFvy8j4SjdOkIzK9O0mG9iBfF1FbeMk/npuC8KExohfCAENXmhDJwPKGKNL+m4vbELYZZltUAIb5aDQyOIiV237A6ub99f3BvK86oFwb6mnVOAzeyW1J30rET77kywdLESfnG4HN1nIyxKXAjN1jZXU2j3F5tGUr85//3U8mVu5eh9AFGwBUESG77oeyA55a7C1i1EMmp1eahixtMALCi0I/i18yYSH/R9qk3ZnJULvyFN4THV2sBnkdSbwopOaGhAXYkNnzX5dyLJtE9kAHasg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 12:18:13PM -0700, Andrew Morton wrote:
>On Tue, 19 May 2026 02:51:41 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>
>> >Not understanding - cab you please describe more completely?
>> >
>> 
>> I mean do this below.
>> 
>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>> index 460fa1f606fd..f30402ece608 100644
>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>> @@ -469,7 +469,7 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
>>         }
>>         if (write(*fd, "3", 1) != 1) {
>>                 ksft_perror("write to drop_caches");
>> -               goto err_out_unlink;
>> +               goto err_out_close;
>>         }
>>         close(*fd);
>> 
>> On error writing this fd, /proc/sys/vm/drop_caches, we forget to close it.
>
>Oh, OK, that's a buglet.  Please send a formal fix sometime?

Sure, I am glad to.

-- 
Wei Yang
Help you, Help me

