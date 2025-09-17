Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 822F6CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 13:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBEDE8E0013; Wed, 17 Sep 2025 09:08:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6F1F8E0007; Wed, 17 Sep 2025 09:08:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37B48E0013; Wed, 17 Sep 2025 09:08:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0348E0007
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:08:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4C12E1A022F
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:08:51 +0000 (UTC)
X-FDA: 83898772062.28.2CC5B5D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 14A69100009
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:08:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZQjHyx4v;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758114529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nzfWfGht8au98LeWA8/zuY175JB8QmmK7SOvZDIdVlY=;
	b=bkqg4atlViA9iJyZiJEKJHSQFWp21EaQPQgn9WVL4eGIuuaMre13Mh18ZwaX9l42d8JxIa
	2HO8lKJ3ljUrw9gdE455gZmF1t5gAp48M9JUvFk73sgME3lVEGBDWilcJGGJyYMKcSG3Ly
	up7T1c9+EvZb44VYnp7tSjFuDoovT1U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758114529; a=rsa-sha256;
	cv=none;
	b=aZaJEP6m3lqmtEihyzWRl1vjDs9bFV/gP1E+e0BgHpugnl4QRSp7ShT0LDMddCa67Qh6pr
	ZR9GB7+ptCdRXhNa80azKan50Df7xY97f7J+rT4uDdF1MMqODuj52BUyrMTUZRmuAxB7en
	Pc5ebjWc4qmwwF+qYFQNNqZeOChExn8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZQjHyx4v;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758114528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nzfWfGht8au98LeWA8/zuY175JB8QmmK7SOvZDIdVlY=;
	b=ZQjHyx4vDDtec9o0tYdb4EsDN+RlVv5aS0xExHc/ubl6VqFVS1EPeNSq+tUw7Voj4lGm6R
	gCYFe/AIVowZYDpzwx4NGpNEspoGXbQRlLqKn8QD9ku5dYH1GF+7iSC73FudfZF34sXV9Z
	UhGYSjgR+krkVirchFvRf+qeqh/9WLQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-0jIIIaixPK6d0YXa3VQQug-1; Wed, 17 Sep 2025 09:08:47 -0400
X-MC-Unique: 0jIIIaixPK6d0YXa3VQQug-1
X-Mimecast-MFC-AGG-ID: 0jIIIaixPK6d0YXa3VQQug_1758114526
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3eb8215978aso2565344f8f.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:08:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758114526; x=1758719326;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nzfWfGht8au98LeWA8/zuY175JB8QmmK7SOvZDIdVlY=;
        b=HMMNpmBmR9ZS5eapxJW1HjSv9RnOJfdwKciL3gd2U9ytdEtWKlQEk0h1T0qtYBnjuV
         cbbd4ihwbNXZlv56cIcUn0ZUYsHEw0trls1Qs+aqbyp25otEZTR9/fJEa6i7ZpeGCIWv
         1ZuI3uA6DgIU6+Cd68IYQglCnjZBsZnUm2+xQbsO/gY5XWsevGId7Vxj3hLwowidAxw1
         lqUKnbCTXh/t1l+FuOCyIDoURWEQ0XGft8f75RES6sAsTh8HWEI8+4mq41hcVIkfm0pQ
         3d9wzJR9S6q+o+npObVM/VuitkdXJNcw+nYkIkz9ca8GqtyXiypGRm59ZEu2WHtirZzf
         Y1bA==
X-Forwarded-Encrypted: i=1; AJvYcCUO/s/6Q0VK3ffHwFWT8ITdxmCZI2mobN0NpQVec2k2KhXtarWX1Md1MSibQXqX2O7DJdwMzDtPRQ==@kvack.org
X-Gm-Message-State: AOJu0YwREWsq7Ugzg+/0wFESIgdxDg3xPcymDrBbLHACE3UMGt/eevEW
	fb8kG4kbppUMbQ+zVnjWLfav/8wbx+KTlrvM0WqjHjP8m3B18Z+rlCGsKtldHvTWgc79oo0d2pj
	nVcLi+q4WkkW3+5oSmrgvLZvsK2Qo6noIN12x0sXvgNeOvzDZEGJB
X-Gm-Gg: ASbGncu4sdh4O0EiqABSobLFg38YVx1CqluurfYmbeYfofcNA2pfI1fs5JKGXBq0PIQ
	4+yDROMHtbX6nQB+6GZMclun3Cs3Ep3iDsqsSwLZvAI0SPncuuGWeFZFWA7relR/9rkWSiT3xXp
	OF2I5eo8iXCQ9k6wGWugc2vyvEXaajIK1C8Fdjtm2ayWe/3AvLpWZyhpztzXxzoqm4pCj/Hacvh
	AXkf23CfSgcJ7mzP9JTPQQEeGUBnM4oEoWQ58b1winnyaQH0cfaUKr7kCHLKsCsMSaAa6QCHD9r
	GxzpctHmp/ZSbbEID8kBN93KwPR+cWRIoL1O5rRCv+iZXYi3xBsUwokDENFaPvKQ2axGMUBAVVC
	bAopw2FTMe6I2WnW3k9NvJ3KJfmplsLfRxdg03WhUam+BAERk+dK4IPkZEwj/LvyE
X-Received: by 2002:a5d:5d0d:0:b0:3df:c5e3:55f4 with SMTP id ffacd0b85a97d-3ecdf9af23amr2124896f8f.6.1758114523501;
        Wed, 17 Sep 2025 06:08:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESsV8oIC9/D3nBGOX8FOAc3Rt8Xs0bAaprYwXzUAhqjLbNmBfCuTBu4PnllnnmUxZ07rs/UA==
X-Received: by 2002:a5d:5d0d:0:b0:3df:c5e3:55f4 with SMTP id ffacd0b85a97d-3ecdf9af23amr2124841f8f.6.1758114522780;
        Wed, 17 Sep 2025 06:08:42 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ece0d4a5ddsm1768484f8f.33.2025.09.17.06.08.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 06:08:42 -0700 (PDT)
Message-ID: <ada1b1f9-bd2b-4164-ae8c-80264d4f6dc0@redhat.com>
Date: Wed, 17 Sep 2025 15:08:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] selftests/mm: skip soft-dirty tests when
 CONFIG_MEM_SOFT_DIRTY is disabled
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
Cc: shuah@kernel.org, ioworker0@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20250917122750.36608-1-lance.yang@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250917122750.36608-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bKVBq7wgidT0uKBbhBy9mSNF7z7-vZj_lLR6-bdwuPE_1758114526
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 14A69100009
X-Stat-Signature: ynx9ft55b8gg19k4m8xux8ag1momfs37
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758114528-668191
X-HE-Meta: U2FsdGVkX18FOdq5H4gq1MMC5lfip+rwk7eEfykcRHF3y9lFAEOq0u9Jv8G3aFLLTIQYyx/BYUE/GFxu3lFj7BEwmQd4urruOUUyplnNOiqGHAGVavTxbX9psd1qLPM+WrRR4BFUvCRuaFZDzFGUypOYeWu5GPnFFzl3PUtfMEVcB1m8G4HGyioIwjXOvK/XG3hFlvyfSNgOZBvO3cB9pV+/Uvg8GhlO9CoUtk4t0m9PWMGuEA/ERYn5a/VtVIZfhhkQPNVkcYPImd0nXOZFnGY4nJV2HWQcI6H4nY3DTXWvr8gf9bd4Q1uElG89OQB9sobtiFg3kVk+c3ZQlaJAXLUEmxpMNNaPOhirkdYmg1SGQpGvhWPNOcn3nRGHTqR+XXN2HtSn2oWfIcr0KJx8hos7a8pgJRDUNt1HvQ6HfUmZmxQ5bBkjkOTYSOnbnrYS5Gs5x5NOstLCdG7n1NXUIRzUi22zm05bf2IpUF9TS0Hd5zyFRSUCEwaZgYQKB3cfFRhnOAY8gJgGYsozjhykLccPQv1JiGVJuvwNZifXB75X6pTbh3k+Ovwn6BbwUjoAeXRdko3hzlBoC4evnxvMULqoGB3PNa/21/1sCxLRTXh4hD7HtWE/h/DZiq2R/jhFfq5PU5BNnowwYdHwq8i+XXOxKCkfrCnZtN7lJ5loM4rFFHsmUcGDqpr4DJQPq8vGEIGA7lLOM1p5UuXDzaBMwzGvM9wfnoy0eWwmFWld289OdvMvcpzdxyH4BYalbILb3USZuuugg9CptcCg+RWRxEOnqVfQlnZZPpqyb0rrcvSzPJDoRJ5IZzxgRAtbSDatOJyImtge89PUrzC6wkkqM+ID8JcpwNNEYXMc+XgxjdE2DVGzKLcIL8C9W8LqZbfOjY/whxxNS7gHtK+Car+aCnxylIhjHDGitZFBvdkVohAC8BLD60bIhNkGWbc96jWnRfUvv2GnmrbNEUiVBs+
 nyTooXr9
 MslqRSpDetn01qGCvmT/ywxxiZhVnoqSYYisHLGNk0SnjnksDgvQdYV/V7ce5Ibv7NEnSwbqZocAKVfhnPBCrAXjakQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.09.25 14:27, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> The madv_populate and soft-dirty kselftests currently fail on systems where
> CONFIG_MEM_SOFT_DIRTY is disabled.
> 
> Introduce a new helper softdirty_supported() into vm_util.c/h to ensure
> tests are properly skipped when the feature is not enabled.
> 
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

[...]

> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 56e9bd541edd..ac41d10454a5 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -449,6 +449,25 @@ bool check_vmflag_pfnmap(void *addr)
>   	return check_vmflag(addr, "pf");
>   }
>   
> +bool softdirty_supported(void)
> +{
> +	char *addr;
> +	bool supported = false;
> +	const size_t pagesize = getpagesize();
> +
> +	/* New mappings are expected to be marked with VM_SOFTDIRTY (sd). */
> +	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
> +		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
> +	if (!addr)
> +		ksft_exit_fail_msg("mmap failed\n");
> +
> +	if (check_vmflag(addr, "sd"))
> +		supported = true;

Reading the code again, this could just be

supported = check_vmflag(addr, "sd");


LGTM

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


