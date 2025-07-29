Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E128EC83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 16:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 822386B008C; Tue, 29 Jul 2025 12:14:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FA516B0092; Tue, 29 Jul 2025 12:14:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E8B66B0095; Tue, 29 Jul 2025 12:14:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CEC56B008C
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:14:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0AE781D63F7
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 16:14:17 +0000 (UTC)
X-FDA: 83717799354.29.5C2F883
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 86247A0005
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 16:14:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dV7yyvvm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RXsNpneX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dV7yyvvm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RXsNpneX;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753805654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tRO/PahJzO9a91Wm1hhkBQhQCmcAHpY0UEI4yNOBKrQ=;
	b=PaUh97VK8TnYkilJ8r1OUJl3x5UqE0w1FUXCmDi61lfB17zQdnZuAUbpRqbBIGGz3yWot/
	W8T/Jh2DIIExRAh8A6l2Ay3Ee/9jmixXNN4AByTMYmoH2bnG6NFau87jYeRQAu6mU3hMAU
	RsCX4DqlhCYzIpys7SKmSIRT2Yr2laM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dV7yyvvm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RXsNpneX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dV7yyvvm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RXsNpneX;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753805654; a=rsa-sha256;
	cv=none;
	b=8FpV9WwqsjGR2Wui98UqcpPa5Edhwbs6c9X6f/7Eq3NpmPRe8oq/ItZUCbsJE01OFOKudD
	lu/7br6Qefiv7xyD4/PYvyaKZ9FnlMUJwrWZx5pGePMu/J+kkOKJonCvwT1SeC74PImElc
	xH6NXYDeBWmMG+1ZUONMvZkpz6iix14=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C04191F385;
	Tue, 29 Jul 2025 16:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753805652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tRO/PahJzO9a91Wm1hhkBQhQCmcAHpY0UEI4yNOBKrQ=;
	b=dV7yyvvmaHLt7JH6e2ekQfvH/Cip6RPffVBlpCMyfcNicdy8u2qhpk227wnarZ2Enm0iTk
	ZaUlSwIo+NZSfZ6f/ntz+R1juWPS6MBPVu2DLnp3ZPwThXyC3Nr8DnESCgtSAZ1UsdM0H0
	X5+vQE5AzG19EueQBd8LdzCyVGk8HZE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753805652;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tRO/PahJzO9a91Wm1hhkBQhQCmcAHpY0UEI4yNOBKrQ=;
	b=RXsNpneXSJ/9FfueZ3vsC6Z4qnHZPlKUW6vVh5Om7wzxWAU7rEcQfnFqWj3oUDuMaF2zlI
	pJ2wYuKOJZyk9xCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753805652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tRO/PahJzO9a91Wm1hhkBQhQCmcAHpY0UEI4yNOBKrQ=;
	b=dV7yyvvmaHLt7JH6e2ekQfvH/Cip6RPffVBlpCMyfcNicdy8u2qhpk227wnarZ2Enm0iTk
	ZaUlSwIo+NZSfZ6f/ntz+R1juWPS6MBPVu2DLnp3ZPwThXyC3Nr8DnESCgtSAZ1UsdM0H0
	X5+vQE5AzG19EueQBd8LdzCyVGk8HZE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753805652;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tRO/PahJzO9a91Wm1hhkBQhQCmcAHpY0UEI4yNOBKrQ=;
	b=RXsNpneXSJ/9FfueZ3vsC6Z4qnHZPlKUW6vVh5Om7wzxWAU7rEcQfnFqWj3oUDuMaF2zlI
	pJ2wYuKOJZyk9xCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A63E313A73;
	Tue, 29 Jul 2025 16:14:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 29nsJ1TziGg5WQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 29 Jul 2025 16:14:12 +0000
Message-ID: <6aeb9c5d-7c3f-4c0c-989f-df309267ffbe@suse.cz>
Date: Tue, 29 Jul 2025 18:14:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kasan: add test for SLAB_TYPESAFE_BY_RCU quarantine
 skipping
Content-Language: en-US
To: Jann Horn <jannh@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250728-kasan-tsbrcu-noquarantine-test-v1-1-fa24d9ab7f41@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250728-kasan-tsbrcu-noquarantine-test-v1-1-fa24d9ab7f41@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: khhf6tfio3m1pptydyj7smmgurumandr
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 86247A0005
X-Rspam-User: 
X-HE-Tag: 1753805654-613333
X-HE-Meta: U2FsdGVkX1+8m2rrWpGGOiJvHmCIFQa+nRr9QSxGuzp1QnjsPHIj++pFyEZRGwzW6jM+N5w0Eg1eMyQxiDWT+2dUjdYUg2dNqeX3h/2zt4vQAyavpVjlU2cWBJOOFwDkE4E2DNC28gKvaIkivkLA/x7+6pTBDWXNO31bmssbuWUw/nCrhSPl8FoeCAmXnb7T99Bt+tu/duvzFSQ67oVCX8XXsP8eeQuWetUWWIYE6+IslzaRzZ5OqEkxkgofoTC8Fo+ca1hXb8jXDqOPfW5vB9vbtYNNrx1QnDZ6ICkKd5UAL+j0L6X5utXlulwoFgpJEyQYD6ehZn/i2GsixXSDVeO12VLilso41AA3FvNIUApiDp5nmW5PqVnrcEJTKLD0WzqEFl1jjP0AAcIFREXn3nRnJSmH2qxfnX+YRHz3iAGpi2c9KET5wpU1Wwt6sIFMVLSY+NEcy3gQtb2Kyco+uXe99aBe1iXo1jI75e8bORuz+YMNNJlpQh2mXl/IZbykVvr3UScVn3a2lj8X1WX18/DfCgAXrdKyGWvRVsqWV7z8Ap/PxBuE2ia0oRW50cCY7i0ANKe+DIa1YtFNLOOWFCDBOIRkIr3kAFv4ukv2fUfSR4Za4Jx9EEcEaAigvqr6tEQTBVUNxUycbXVGhp3YGSi/BrestCBE3VfyYdOBREf75P0tl9xKcTZf/YlNfkWg3KARBFwGNxVQcO3qU/s45zNZ3z8D5Ep6qAn4wxKiN2Qc5KSEmET9ByIYM+unqpYv8C36tAL1L5iZE+YQ15zePQmTI3y8pvzxRVAOg9jPPtMSVTAATRUnimQS60SsjSCKNTBTb39cXQwOxHC0v0w7JoLfSX5ZDei0pZcVxSWWvM7BtcME4hJCyTX/8+lg52a7Tev1sImRZJRIIMqIiHeY02ofvY76UZs6GFcHuOEBuLzW2sGzKTCQngCuKY/3enWJhwO+EQoHxK42fArMUJi
 mZu5RUkq
 7lc3D7pMg3twQue41ar+0T/q20eqylr0nYD3X5yrOK95GQyij2QU5gzGp5pvDg7TvQ4EqWcJxGi84g+F2tHKVWvJ+/wTu3QOOwHxxZUFKTDL3k8CjOnLIJYjjZ3FtTy5zgcF4NljgPKYhOMI25KkZuypngWGEM16S8wFfy9kL9BnrUS03pEJka/Mj2Uq8Gl7m2MFgRC6QW+yVe/HVtdXAOO6UHepvSl25cTnQ4J6DntGJEAQI580bysh2uElzYv7pFYnDlzQsLa0OD1/+6S0wzFDHzLJ7BZaknTQlYZq6IlIoFAUSC7TOn6WwpqegR1iLYtdo5QJMmtMGTwt2caktDETmuKacjIEhwwnZYbLmh4raUqNGp5T9XuwiNRiQYNaFuk79iwaSTzLfDNgQPgCuxmJbCL3PPo0iiYPS5bXB+dEX3dYXMsxiB7ZqAc8a5Wolh0Bed5YT0xx7UOvyzUliDTUkj9BJwUyvKE4XvW0oUx7e5eA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/25 17:25, Jann Horn wrote:
> Verify that KASAN does not quarantine objects in SLAB_TYPESAFE_BY_RCU slabs
> if CONFIG_SLUB_RCU_DEBUG is off.
> 
> Suggested-by: Andrey Konovalov <andreyknvl@gmail.com>
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
> Feel free to either take this as a separate commit or squash it into the
> preceding "[PATCH] kasan: skip quarantine if object is still accessible
> under RCU".
> 
> I tested this by running KASAN kunit tests for x86-64 with KASAN
> and tracing manually enabled; there are two failing tests but those
> seem unrelated (kasan_memchr is unexpectedly not detecting some
> accesses, and kasan_strings is also failing).
> ---
>  mm/kasan/kasan_test_c.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> index 5f922dd38ffa..15d3d82041bf 100644
> --- a/mm/kasan/kasan_test_c.c
> +++ b/mm/kasan/kasan_test_c.c
> @@ -1073,6 +1073,41 @@ static void kmem_cache_rcu_uaf(struct kunit *test)
>  	kmem_cache_destroy(cache);
>  }
>  
> +/*
> + * Check that SLAB_TYPESAFE_BY_RCU objects are immediately reused when
> + * CONFIG_SLUB_RCU_DEBUG is off, and stay at the same address.
> + */
> +static void kmem_cache_rcu_reuse(struct kunit *test)
> +{
> +	char *p, *p2;
> +	struct kmem_cache *cache;
> +
> +	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_SLUB_RCU_DEBUG);
> +
> +	cache = kmem_cache_create("test_cache", 16, 0, SLAB_TYPESAFE_BY_RCU,
> +				  NULL);
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);

Hmm is there anything inherent in kunit that keeps the test pinned to the
same cpu? Otherwise I think you'll need here

migrate_disable();


> +	p = kmem_cache_alloc(cache, GFP_KERNEL);
> +	if (!p) {
> +		kunit_err(test, "Allocation failed: %s\n", __func__);
> +		kmem_cache_destroy(cache);
> +		return;
> +	}
> +
> +	kmem_cache_free(cache, p);
> +	p2 = kmem_cache_alloc(cache, GFP_KERNEL);

and here (or later)

migrate_enable();

> +	if (!p2) {
> +		kunit_err(test, "Allocation failed: %s\n", __func__);
> +		kmem_cache_destroy(cache);
> +		return;
> +	}
> +	KUNIT_ASSERT_PTR_EQ(test, p, p2);

Otherwise the cpu slab caching of SLUB and a migration could mean this won't
hold as you'll get object from another slab.

> +	kmem_cache_free(cache, p2);
> +	kmem_cache_destroy(cache);
> +}
> +
>  static void kmem_cache_double_destroy(struct kunit *test)
>  {
>  	struct kmem_cache *cache;
> @@ -2098,6 +2133,7 @@ static struct kunit_case kasan_kunit_test_cases[] = {
>  	KUNIT_CASE(kmem_cache_double_free),
>  	KUNIT_CASE(kmem_cache_invalid_free),
>  	KUNIT_CASE(kmem_cache_rcu_uaf),
> +	KUNIT_CASE(kmem_cache_rcu_reuse),
>  	KUNIT_CASE(kmem_cache_double_destroy),
>  	KUNIT_CASE(kmem_cache_accounted),
>  	KUNIT_CASE(kmem_cache_bulk),
> 
> ---
> base-commit: 0df7d6c9705b283d5b71ee0ae86ead05bd3a55a9
> change-id: 20250728-kasan-tsbrcu-noquarantine-test-5c723367e056
> prerequisite-change-id: 20250723-kasan-tsbrcu-noquarantine-e207bb990e24:v1
> prerequisite-patch-id: 4fab9d3a121bfcaacc32a40f606b7c04e0c6fdd0
> 


