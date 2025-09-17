Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 580E0CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 10:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE91A8E000C; Wed, 17 Sep 2025 06:51:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99F48E0001; Wed, 17 Sep 2025 06:51:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961558E000C; Wed, 17 Sep 2025 06:51:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7BCB08E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:51:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 358B61DF258
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:51:31 +0000 (UTC)
X-FDA: 83898425982.02.62E4647
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id A7E3C100004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:51:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jTnkE6Ae;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758106288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nERaJxhjcjrAaXh7c6wWUw3HqICZEnqzuOIyghOUsOY=;
	b=oJvBxvIl6B76My8E/HFWIlqGYgPm4NOs5KxhqV9Ebd7cv2O/ke3WnFr8r0K9CMrDTunCQG
	dfOfA8zj4YICRSN5s96TaWbN+5xTTPKuts7BHUqQAyBPw6oLa9I2jv8mfhG3S22y7IrbtS
	BNajEo6yoLlQQABQcyXWZAaFogxfShE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758106288; a=rsa-sha256;
	cv=none;
	b=AhFsaxkHT/KLiAet8xtssaTmrAhWGwTSnFsVYa6w3l4QM9o+yZ6qsGEnv0jn5HwQIoZzoL
	y9yI1esKezEtu9h9xKf2BnXPJ5tVG5ok6Yl7g5T7cC8ymcfhp7WWNMdQdygX3zyPMD6MG8
	8JzjDFsJ/D8grAm42oezQ34ZSNMdK4M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jTnkE6Ae;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758106288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nERaJxhjcjrAaXh7c6wWUw3HqICZEnqzuOIyghOUsOY=;
	b=jTnkE6AegwR+1c8VnUzW+V1tTRE1urB0pXFMCR3TRZEUKFoaiOgOZrAMWHVdwRyEsOU8lH
	FOfyRtBdrn+EzOQqVHzJyqGRuqucX+G8rRKnpY6TBTsSN+WzvW3ECKVmeEHam0KtfbjL4j
	AlDVQSdTdZD2dWYKKYGaOGhQESJB7Cc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-BecWWwkGOyyoISzJZDIVoA-1; Wed, 17 Sep 2025 06:51:26 -0400
X-MC-Unique: BecWWwkGOyyoISzJZDIVoA-1
X-Mimecast-MFC-AGG-ID: BecWWwkGOyyoISzJZDIVoA_1758106286
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45e05ff0b36so3535255e9.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:51:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758106285; x=1758711085;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nERaJxhjcjrAaXh7c6wWUw3HqICZEnqzuOIyghOUsOY=;
        b=jC2B9aTNRrnbrrqmFgg5ImJjo37WS4nOS1II+cew2KH6IeYiLNYjFCTz2kkh/IPxhN
         7eGTbnJAXXvqGyAnRZzmqMEO/MwPZZIRy6Wh+YS0OsOeE2y3zz818PzWIkP5RhKT5YW4
         0sQ/nCokkHnNYvssZSG5BaJH0B2d2G2SRmFLta7bV7ozDZMOKNWRgxi3X+hLZEIQ1QOm
         uyZuLG/bEDqAB3UpQuWrTV0/uT+w9ybgAkEPcwEYIYxs74S9TbMePkLgEhKo/qCxHhx5
         8d0PEKvEGqwoOY/TzTPz3GBgNW8NZ1vRqLQuMkYEBrIy8bq9D6p6yVFc+hYBGmYIGNwn
         pLFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXvKiPYctsXmGHX5Ex0acaGTW3kE6z9y0X1AA7vX7axLKx7d3sTT9YccLu6GI9TOj65zCz8Y/Dcg==@kvack.org
X-Gm-Message-State: AOJu0YyBPDtjetxNxxCzSbHs1v7H5atSwNWYxt3pgIPPQWWSyLjWwgTs
	1jXXkMBZcKrHmkS5XaoVBnc5sUdr80cdG3BqG8dtD15ti00MW4uTvFDHrRm5S9yCJqm6qLFWGIN
	kc2Uov+byQ6qStGIAEAYkQTo6qtv+B5m1X9C2FM/DycCNTqIKZ2xR
X-Gm-Gg: ASbGncvBl0i3PABA8+5dloBHH3Abp1OyPeux4TVhSZYPTBxHo0+axgLN1fVWjRIbyD5
	BOe3My2/8CTJoJ0m8EV8NMg3/vUunyg98lIbkofCZ3TIEGb50RYnHslJZTvJaiNjlGwCQcpxYvB
	2NWmJVJAc6bHt9RbKaZOyLIWdfwAs+Bj9WjjrhxxQ43GVvIihbhZ9v219TWpd95rzLsdQ6X3cTj
	+Fix3i5bnZ2emtBDeFKPi4r21Yfpsyq2F/bLe1i+MgsevnTvo/nvcAhj6UNBHRIcePmDVyzqoNv
	eei4fCc5ljxw+vqErn85zTAWmavQoX+jI7a3fgVMiNbKJtSknkMg0+NgCZyJew0ZvVVN6AXfxU+
	Ihm8zxu/I98JG0+cweUXQadCckyYGWkoaJtDQFuO/qBuDVkz84Z7w7qpNjJMf7cRg
X-Received: by 2002:a05:600c:12ca:b0:45b:86bb:af5f with SMTP id 5b1f17b1804b1-462d73e52f9mr7092335e9.6.1758106285437;
        Wed, 17 Sep 2025 03:51:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1ZygKbzExyxPazwktd3Op+PMSIyLXZ5fVLowDy+xVLe7/9FL4ydneS0ztJyucS3gyZvcYNA==
X-Received: by 2002:a05:600c:12ca:b0:45b:86bb:af5f with SMTP id 5b1f17b1804b1-462d73e52f9mr7092025e9.6.1758106284912;
        Wed, 17 Sep 2025 03:51:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f27:6d00:7b96:afc9:83d0:5bd? (p200300d82f276d007b96afc983d005bd.dip0.t-ipconnect.de. [2003:d8:2f27:6d00:7b96:afc9:83d0:5bd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4613ddc01e6sm30967065e9.18.2025.09.17.03.51.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 03:51:24 -0700 (PDT)
Message-ID: <353bf8f0-d9ad-4800-80d7-4177ae64eb95@redhat.com>
Date: Wed, 17 Sep 2025 12:51:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 1/1] selftests/mm: skip soft-dirty tests when
 CONFIG_MEM_SOFT_DIRTY is disabled
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
Cc: shuah@kernel.org, ioworker0@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20250917055913.49759-1-lance.yang@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250917055913.49759-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2-IxwDcg0fEYlktLyZPHYyKdgvhGA6SkG3ffUV1NPz0_1758106286
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A7E3C100004
X-Stat-Signature: on8g84d8kaewqzy4tbkrfrpt1y3ws143
X-Rspam-User: 
X-HE-Tag: 1758106288-177690
X-HE-Meta: U2FsdGVkX1+MxOKPqEc0nSeL+amaZ7D4bXIISIn+xxy+3+2ScS9GrMxt+0F+scV34sJ8GqQruOgkBEP+KvV0iUTly2uXs6zTmGarJOgTmG8Yf0Gzq/4I/wpPnSTNmtfe+IdEiA0rjMoPAjNP62MIMHHq9yRYb+1yN8uyZ1x7RoK5k7ayFq3i10tmf8x2x9e3NRSJpiRCTSTKsk0c5Zo0kNTXqDshp1dmuzn32KUAyew20wxJ9QRxs8pgOkVUIjILoDDbkS32BUyCeDNAHnfkdG2Fdoic3+rcg/5bW1FqjC6RKllaCpaW+l37tephfxZq8k9ZGZZFuOmzPAEZzoOu17xFTwpOsB/iMjnbXSamSAJFtLkuVSpPfcgqbCNwDm/Y8ZP4SVO1b8EEsakU9HMoN+upKC66IT/j5WIq+d3166ZX00SeEQ2OjYt0Ywr5bxg4aEWzY+q13Svyga/XpvLDAYvQ4GFLgV+WfKSmz/6JWdIKHC2t7w+eRnYWmwnwiQs8dilsbpCBRFQ7QlFbNii/56CdoakwP/di6dnJakJdWo99ykw4/sqYkr1fwUVsUtaMAXD9XZdMEW96+Fx6yOr+6yK7gd2sg2sT5law9D709QugMe5c6IbD2OZYPLTjTvTD9hn6JayJ1MZJeOlspo7miaX09R6CKe1KNE5BhI6YpCV6oVulnm6o0n15gEsgswXzLP11yDn87wSLPwqlyI+eO0FYi1mN04J3zjsZ+dDYeT4RWLErjfLFYBChskScZoUMdeZEOB9W7dBUQrJ+7XZIMLUBn4fBhzcG6nyGJg1wvlNajkKv3OlsYjmUTyUW2rlrLsRZD3Ahc88hUb29YW8e7W9+tz7WNi5MdztOlZ+b0erKX8SVuKYgymbnQ0Z2RZh/Srq/p98yVB4gnEr45x1x+jgSUBsM5Q6z27JSARFiXm15EUVta3Dl0QnBGN30ueXM5lG5PUz/EVqgY3D/tlm
 nGe86R43
 NKCKtf04Z00iYfCMc1OYW8R6bu4369dBAA9nH5kb8cZHjp1Q/M2CmwkwAa3xhw3wG3ZkrwgON81fkK2kpy782/nWAnyK5hyPyZwzIvgglm87uvvwXk9oZqhD0upe3tI/UHgXcxZ+gqcaL0OFESdR0M6XHZqPwV4cxtiOeK+l+Vbi6TD901NjryQNm+7c9AjLo9Ebr+pL3fvDn+dRmANGCtsdYSdo0/QgGUIBuJBEA4CiwCSEL3tstKbr7m6r2swhKPm9MphXQpy0g2NMyDZrkXl+kiaSYjDaDbA3zwQloHSaiVt1OMy0l3FEWf2VBocA5AKA8LqJujRxXsA4mPGbvKIZpEOT7PH87osh8ilOp3VRaFGzgrw0N58hNwPsWuE4Mmn0RdcjsD6jssUpegdEF/lzDK5+9RBiUSb3bHHrX1EBoh8u2c4t4JdilWpjGksqB0ppzsXyE2U7IAXsUmvgllRatnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.09.25 07:59, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> The madv_populate and soft-dirty kselftests currently fail on systems where
> CONFIG_MEM_SOFT_DIRTY is disabled.
> 
> Introduce a new helper softdirty_is_supported() into vm_util.c/h to ensure
> tests are properly skipped when the feature is not enabled.

I'll note that tools/testing/selftests/mm/config contains

	CONFIG_MEM_SOFT_DIRTY=y

But yes, the current arm64 handling is nasty, because some other archs 
(e.g., riscv) also don't support it yet.

LGTM, some nits below:

> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   tools/testing/selftests/mm/madv_populate.c | 21 ++--------------
>   tools/testing/selftests/mm/soft-dirty.c    |  5 +++-
>   tools/testing/selftests/mm/vm_util.c       | 28 ++++++++++++++++++++++
>   tools/testing/selftests/mm/vm_util.h       |  1 +
>   4 files changed, 35 insertions(+), 20 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/madv_populate.c b/tools/testing/selftests/mm/madv_populate.c
> index b6fabd5c27ed..43dac7783004 100644
> --- a/tools/testing/selftests/mm/madv_populate.c
> +++ b/tools/testing/selftests/mm/madv_populate.c
> @@ -264,23 +264,6 @@ static void test_softdirty(void)
>   	munmap(addr, SIZE);
>   }
>   
> -static int system_has_softdirty(void)
> -{
> -	/*
> -	 * There is no way to check if the kernel supports soft-dirty, other
> -	 * than by writing to a page and seeing if the bit was set. But the
> -	 * tests are intended to check that the bit gets set when it should, so
> -	 * doing that check would turn a potentially legitimate fail into a
> -	 * skip. Fortunately, we know for sure that arm64 does not support
> -	 * soft-dirty. So for now, let's just use the arch as a corse guide.
> -	 */
> -#if defined(__aarch64__)
> -	return 0;
> -#else
> -	return 1;
> -#endif
> -}
> -
>   int main(int argc, char **argv)
>   {
>   	int nr_tests = 16;
> @@ -288,7 +271,7 @@ int main(int argc, char **argv)
>   
>   	pagesize = getpagesize();
>   
> -	if (system_has_softdirty())
> +	if (softdirty_is_supported())
>   		nr_tests += 5;
>   
>   	ksft_print_header();
> @@ -300,7 +283,7 @@ int main(int argc, char **argv)
>   	test_holes();
>   	test_populate_read();
>   	test_populate_write();
> -	if (system_has_softdirty())
> +	if (softdirty_is_supported())
>   		test_softdirty();
>   
>   	err = ksft_get_fail_cnt();
> diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
> index 8a3f2b4b2186..98e42d2ac32a 100644
> --- a/tools/testing/selftests/mm/soft-dirty.c
> +++ b/tools/testing/selftests/mm/soft-dirty.c
> @@ -200,8 +200,11 @@ int main(int argc, char **argv)
>   	int pagesize;
>   
>   	ksft_print_header();
> -	ksft_set_plan(15);
>   
> +	if (!softdirty_is_supported())
> +		ksft_exit_skip("soft-dirty is not support\n");
> +
> +	ksft_set_plan(15);
>   	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
>   	if (pagemap_fd < 0)
>   		ksft_exit_fail_msg("Failed to open %s\n", PAGEMAP_FILE_PATH);
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 56e9bd541edd..3173335df775 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -449,6 +449,34 @@ bool check_vmflag_pfnmap(void *addr)
>   	return check_vmflag(addr, "pf");
>   }
>   
> +bool softdirty_is_supported(void)

I'd just call it "softdirty_supported" similar to 
"pagemap_scan_supported()".

> +{
> +	char *addr;
> +	int ret = 0;

bool supported = false;

> +	size_t pagesize;
> +
> +	/* We know for sure that arm64 does not support soft-dirty. */
> +#if defined(__aarch64__)
> +	return ret;
> +#endif

Just drop this arm special case now.

> +	pagesize = getpagesize();

const size_t pagesize = getpagesize();

> +	/*
> +	 * __mmap_complete() always sets VM_SOFTDIRTY for new VMAs, so we
> +	 * just mmap a small region and check its VmFlags in /proc/self/smaps
> +	 * for the "sd" flag.
> +	 */

/* New mappings are expected to be marked with VM_SOFTDIRTY (sd). */

> +	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
> +		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
> +	if (!addr)
> +		ksft_exit_fail_msg("mmap failed\n");
> +
> +	if (check_vmflag(addr, "sd"))
> +		ret = 1;

supported = true;

> +
> +	munmap(addr, pagesize);
> +	return ret;
> +}
> +

-- 
Cheers

David / dhildenb


