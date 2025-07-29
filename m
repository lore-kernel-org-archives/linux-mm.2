Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2305CC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 16:51:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 903206B007B; Tue, 29 Jul 2025 12:51:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B4106B0089; Tue, 29 Jul 2025 12:51:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77BF76B008C; Tue, 29 Jul 2025 12:51:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 645856B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:51:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 121F9C01B5
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 16:51:37 +0000 (UTC)
X-FDA: 83717893434.26.243F1C8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 85409160002
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 16:51:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yqzfRphf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=I48tmce0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yX4hHVFV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XaVHeA8d;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753807894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B9zblHd7B1NwjU/h+HwxYaQdPAptYF7/21/a0/VsbEc=;
	b=qxLBvS0z3XBGhGtoFC8yH+rEkcYG5GOvLhg22+6gUhhYr3occFVprgV73ZhMs8CZmosfWd
	ibR24yzUdOJVppffho6+kKe5gu50d7sg915qcMhzIv554xOk4nkwGxfkjzGtCbL+E08bn/
	nnreYzGTCewqDGkOwfAO1sByYVyD7Kw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753807894; a=rsa-sha256;
	cv=none;
	b=RGMfMYhInwEQY3kt4wai4l1iYbjl/giJETHBZVm7dHeQmdxDNqB5g7NhRxAIFS5pCEhhkM
	XX7Lgst0tOz+QgNvRHc6JxCP/g7hvhjv7O8rkP8E9y+BtD0K+ZsZEwg5x0sp/P8EIjCETU
	I3DvxDRIJfTHFDXO+YQzcAT0vX73/IM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yqzfRphf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=I48tmce0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yX4hHVFV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XaVHeA8d;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EE6CD1F385;
	Tue, 29 Jul 2025 16:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753807893; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=B9zblHd7B1NwjU/h+HwxYaQdPAptYF7/21/a0/VsbEc=;
	b=yqzfRphf9jC5BiFyxz3fXNnbJmByA+v9APZxQGIaP9Krk97OwRCMuTvlnOu4Owe6LcF7k7
	TPHGUohLV7gU24pVyW3INz7OZ6NZ3RblqTlV6AuQpoX+0cLtybzcmXegGXlbeAFzmU4Ywz
	S5li3mLTsZx6JkLwDzK26Pt4ewIuBn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753807893;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=B9zblHd7B1NwjU/h+HwxYaQdPAptYF7/21/a0/VsbEc=;
	b=I48tmce0ZtJOcexFDq52omqHVzhRrINZ9jfwRmeTrUH+korNd75DytPlNw5mOHQUqlReSg
	DraJ/rWVioA94NCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753807892; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=B9zblHd7B1NwjU/h+HwxYaQdPAptYF7/21/a0/VsbEc=;
	b=yX4hHVFVhrQY1PQp6QbW6Jdq57HzpoeVRm4yX2IJVThIW0eH+nLYfZtuvTpkjxPZHNOhGG
	UcY0xDGcykFn5DtDNC3qhO/IdFXudAcBALjtQbkR847Tnfu3UXjRSHm9qmka/FTqlNf83m
	m94aIvlPyqheOWUqowyyQAb8yiHZQyE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753807892;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=B9zblHd7B1NwjU/h+HwxYaQdPAptYF7/21/a0/VsbEc=;
	b=XaVHeA8dY0LNEbmrPDrXmHXjJowE68u5ER+L4LkDC2qKC+xyJl8oAtOngCIlh2uV0B2oP1
	9cHSDWMOeys6vgDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D477613876;
	Tue, 29 Jul 2025 16:51:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QTteMhT8iGhnZAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 29 Jul 2025 16:51:32 +0000
Message-ID: <5109febc-21b4-43fb-98a2-14c552c27bfe@suse.cz>
Date: Tue, 29 Jul 2025 18:51:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] kasan: add test for SLAB_TYPESAFE_BY_RCU quarantine
 skipping
Content-Language: en-US
To: Jann Horn <jannh@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250729-kasan-tsbrcu-noquarantine-test-v2-1-d16bd99309c9@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250729-kasan-tsbrcu-noquarantine-test-v2-1-d16bd99309c9@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6wdecroy1p5y3rchfa6d9sbiotiusoir
X-Rspamd-Queue-Id: 85409160002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753807894-882880
X-HE-Meta: U2FsdGVkX192XOZ1hWmO18MZHvKKTy9eJJCW9J7A/hsCVzdwog6iUy+mcpqDznjRT9Z8YODA2sWwuNdwP7uqe4k/VJt2nf3/XI4pNKMkxNC9LmodaM/6AKbF7mhiX+Idaa/NRdOCUZrA86Hi2L7yGnWzaRbrQghUkcUKF5FnRvQPXBsQAxfq0fc9rfI22e3pgV03HvlB0wmOA3nuJERMvDE+ymM4FobYBTJ3FUmPVQ8hc5VaLexvd/9zzktgtt34adgcjIa06B63RAJVnzaw/SWIqNu0n/bgGYI4isS2PIT08oXnacVI71IBstv2EKnMToauA+ZPRJ/qGvRu7Q+mdEuyb4FlP3modn6LeeBp1k4e412FmMMnfTTcYq1OM3IpwJoKiedyfv33VPVBqpS0ig63UGzJncaCeWM65p+ZpJfp/Wd9lGI9v7rE5hhuEBiJ4wN51GNkhoIuqe4QniAkHts+bTzHxZxThjLeQrCOvd2Dhg24rDQDSNqhBA7IGHL6HPW1QiCsG74cz4ZAYZf1DB9dkAmC78/0OkdRKx9uIouXxUAdol4s4CpZqK++1+4Cu0X06yKcHS4BWwkfc9lXgtcZ8bgZrRv9cH4AgE6lJgmRH3qvRHNIlGCeav9bgft0zEX14V4NHTiT3XhgbPYFhLM2FOMGBpxqFYz90bN5+CElWNDjqhN00Ddi9foNxXleA0yrrAqZn2mabDI6U2+DI02FG3Nrmol5KWejkk7xEP18ypetvDTQ0eLeL+MsxjhDIU9FffwYDIOJhcEHYGQCcWqs6T+Ut5TfspGlKDlnydR5n9C7I3wnQqRAhST0n6zCxOoGCdIZcxft/tbR55cT1uBmmJnxMLI5Jjkp//FTWeUeVH2yowmnQX3jOtml18DN7NNjMWmlZfBXdBRMYSjXHM61Pfp5ITJ71AuyTc2n3BAKry7J0NBk5r7Rq0VUCxZriiAVtyABEEWTiaEsv01
 0o8MDFSV
 qSdsB0h3QID36rlS8+V9wTxDprDuVwZ8V2bN2Fj7jpRO8q0RWe/P+YLoI6OCi5GSRn8/uSR4IEPwr7DTOcwQjeE8HNN4CGc5G/7vUtA9nDzz6qNtQYyWGCogOMUZ5kGMIszg0z8tJoSXVXmiBPKi4HH2QvIbg6xdYMXL6BtaFEMkTKQVL5JZTTyL/t9uxAbl708eswWdT8LouhIliyiHc65BDu1qWyCuAqi17A568RD70rMpTF+mO//VuRh3NN2I3r23YD7f1JdULiJDxRXjnjo4QVFhz0IbTzGQ7SMWBfx5LBIsO5L16c0ATD0u2dVd6YyI2fp2nK9FXQ+y0n74Wsr/MJ2AxG1djD0T2r/qGOUV37eQSMJeLY3qu637zqwz+WGWMt9ukkhSaQUQnP+HaSv5XbgzN0Ng5y2R5cgRMqfbfiGSbc8lXmG+pWdBqAEBpmpHDFg/sAHEIeO6Igjlttvm1Zw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/25 18:49, Jann Horn wrote:
> Verify that KASAN does not quarantine objects in SLAB_TYPESAFE_BY_RCU slabs
> if CONFIG_SLUB_RCU_DEBUG is off.
> 
> Signed-off-by: Jann Horn <jannh@google.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
> changes in v2:
>  - disable migration to ensure that all SLUB operations use the same
>    percpu state (vbabka)
>  - use EXPECT instead of ASSERT for pointer equality check so that
>    expectation failure doesn't terminate the test with migration still
>    disabled
> ---
>  mm/kasan/kasan_test_c.c | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> index 5f922dd38ffa..0d50402d492c 100644
> --- a/mm/kasan/kasan_test_c.c
> +++ b/mm/kasan/kasan_test_c.c
> @@ -1073,6 +1073,43 @@ static void kmem_cache_rcu_uaf(struct kunit *test)
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
> +
> +	migrate_disable();
> +	p = kmem_cache_alloc(cache, GFP_KERNEL);
> +	if (!p) {
> +		kunit_err(test, "Allocation failed: %s\n", __func__);
> +		goto out;
> +	}
> +
> +	kmem_cache_free(cache, p);
> +	p2 = kmem_cache_alloc(cache, GFP_KERNEL);
> +	if (!p2) {
> +		kunit_err(test, "Allocation failed: %s\n", __func__);
> +		goto out;
> +	}
> +	KUNIT_EXPECT_PTR_EQ(test, p, p2);
> +
> +	kmem_cache_free(cache, p2);
> +
> +out:
> +	migrate_enable();
> +	kmem_cache_destroy(cache);
> +}
> +
>  static void kmem_cache_double_destroy(struct kunit *test)
>  {
>  	struct kmem_cache *cache;
> @@ -2098,6 +2135,7 @@ static struct kunit_case kasan_kunit_test_cases[] = {
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


