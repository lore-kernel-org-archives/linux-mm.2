Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFC8ECA0ED1
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 05:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6971A9000EE; Thu, 14 Aug 2025 01:10:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66E17900088; Thu, 14 Aug 2025 01:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ABA49000EE; Thu, 14 Aug 2025 01:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 48C36900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 01:10:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A7DC7140517
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:10:30 +0000 (UTC)
X-FDA: 83774187420.25.D6E36CD
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id BA62F40002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:10:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RhecfVX1;
	spf=pass (imf11.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755148228; a=rsa-sha256;
	cv=none;
	b=3EDIZWEpVcgYXYtqe7aMZ6n8NipDY1sssdwPJAQ9hKCLm5vVdbXmCjjxwj+Zt5ThtyIsfY
	a0Rx/oWGw+WH4M2HiuEwU12/IUSaKNhN0FciJy4eDP3n+obiPZjzALO2WpIYpsgMMV5cLO
	RWnCFk/1wQ8RjvD7pEw5HNFNW5QbWHs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RhecfVX1;
	spf=pass (imf11.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755148228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YG44M8DAsMWfH02qr68MhJtAMxD1cxgjmaznwJ5KLJg=;
	b=vkPl9WCu2E3aWc41LG6C1N1EZTViSWssnEEAAr9A6lvZ+a2vBH1VquK0/6ZOkQQmybDbOo
	SeFgjPJ0PBUl1SfJ7thOoMw/gBSGmANPhX+bHO2B7qxUFcSlCEjvbPg3mEe5JettaqztHf
	MT9mwfHK0mgurYEiep77vtygnqiUO6E=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3b9e7437908so420197f8f.3
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 22:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755148227; x=1755753027; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YG44M8DAsMWfH02qr68MhJtAMxD1cxgjmaznwJ5KLJg=;
        b=RhecfVX1cg/SNsBPzGz96IwCopcm98sfVSVmwhozJkLLv7PG711BQtXsH62rMW6TRD
         zamnwmIzRjm6X8U8henehZqCF9hkqZuDBgfGv+AtXyNjypjCrPQsQF4yRZMaPBBe6oda
         19Fa0cZAG5lBpkHw1+4fVNyq+oupCv5uz+Js5wLwQA54s8mFln58esdG/hGoGUOeVtUv
         1mpeqJQUA3BYeWV7i3Ylw/qFcyfYOKB2M85pdDHuT0by/M+vWu+B0gKo1oyboO1DvLwk
         P7nRno++fKMyNRfWAvpOw/d0e+VhlWCfdrPdfgttn8OwQ33REvTl8WQ+g5Z4hubTED2d
         HgnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755148227; x=1755753027;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YG44M8DAsMWfH02qr68MhJtAMxD1cxgjmaznwJ5KLJg=;
        b=eOZckv1VYZdPaolb7wqvdRCvYHd1RTNQZ2XMcleWnQ8+22Wm0kxMh6M9yXt7PSzkaV
         RW6G1IvqEbifimCSpX869X0GwZtU7Z2dv/l1EUDjTanr/Ir+YZEVKaE1TvSPBcykw5Cx
         E0f11qtnKnJ13btnZSyzNc5aDNnesmxt1zTEewPOSRI4ew4nZ+3fqyCVaT8BQraHd5CU
         4BpNT6p38zkBsYMD80e/Q4T/vd+qzOwXHDbALbcSRQJGXcgwnwPOwCdyKmMDsajLMEVk
         u+P5Ax+aq2ffkEoUbCllFKEtNZfgaCp8JkckhJppHQRpajOUxbjVqy9Vf0T/1f9U5RjZ
         ZvQw==
X-Forwarded-Encrypted: i=1; AJvYcCV0or0R9rpsYtoWK1jap0O7wFo8+dmZmka62kS2+lktxu4E9m9wrtgil7p+b6nUzD/6+SDExApJlQ==@kvack.org
X-Gm-Message-State: AOJu0YyHG0aA5csmguGoeDzbkwuRH+Og+OrUlXbNRmcUC+Lc8PK8fkIL
	5QcmqVrwPCABbJNUzkzKGx63c3NQVENAAeMhpna5vDNmdWIZsHs0epzWvPGvdcX5gd/9Kl6uYqZ
	uHiOftzo/NGSMBKipg8R6Y4/dX2JcHGE=
X-Gm-Gg: ASbGnctFnUqrEIeo/cQNVJdqrsArKuChlQdgJg7MgX/R9CfxAb2Uema5pa8uClhtlr5
	XQ9NI326R25eE72cI6JfU1nSt+OjS//hsTT1eweXMymObLP9weReHSw4S3PT5bvxSeYij6OznxW
	aWG+dniK3MWsskSErjlV13+XLix26XVFJIrGRHiZ3GP2VCAM4wNvU04RIxMBApMN/mwlMFSVHFV
	Z00bSOEZQ==
X-Google-Smtp-Source: AGHT+IH3bvcgyzK2aNX18ueV/bOIy3e/jd4WyTGOc9ODs07/SX5JFC5qL+4zGrhveyP0GsCspj9sbn3SUabDgrFM/es=
X-Received: by 2002:a05:6000:402b:b0:3b7:6d95:56d2 with SMTP id
 ffacd0b85a97d-3b9edf1ad3cmr1303620f8f.7.1755148227128; Wed, 13 Aug 2025
 22:10:27 -0700 (PDT)
MIME-Version: 1.0
References: <20250729-kasan-tsbrcu-noquarantine-test-v2-1-d16bd99309c9@google.com>
In-Reply-To: <20250729-kasan-tsbrcu-noquarantine-test-v2-1-d16bd99309c9@google.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 14 Aug 2025 07:10:16 +0200
X-Gm-Features: Ac12FXwk3idO9PD5EAG_isCaljN_b1Avcx5rr-Mcqh7uJPexNYhAO5AIw0nkzeM
Message-ID: <CA+fCnZeuewqXSW0ZKCMkL-Cv-0vV6HthJ_sbUFR9ZDU6PmzT-g@mail.gmail.com>
Subject: Re: [PATCH v2] kasan: add test for SLAB_TYPESAFE_BY_RCU quarantine skipping
To: Jann Horn <jannh@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BA62F40002
X-Stat-Signature: kxwif4t7wwxbfs9ittptqwj1pmk8qwgb
X-Rspam-User: 
X-HE-Tag: 1755148228-743476
X-HE-Meta: U2FsdGVkX1+HFTF9xcp/Plq1JJIMAD+4Uk/Rm7OQoPEqAAZkA0rWcOOhEH/tHAtlJlaRT7pdxgfeDrGNwjCLoVYL3ReuATHlDft2EzPrGSOoZCvxm1Gpp6Z66UsONBx7V9ScxAOeaxXl3601iOAiUUawqQhU59i2laOfo/cYs44Azh0nQyNLKFxHjLwSPWDRUpkr4w96DV37o527aCRivFEpOc6HY8h7XklTuBK9EsEU7Y2Jv7BYGOsxVtXcoZnBpgsLAvJ6GcemsQP6+XesTCfVahkUOhEJlh11nsGepJhkvYPKXsuEdyNr/RICNBom/KtpJNdYgWdiFDT3FC5BDf5vEoanXlBeVQzyhtkHd0LFgS24U+bZ6tlGeZX/WehRGOEaYThajttgU11BNXKUIHHVvbGGDQMLzioUgZ5LGGo/XE53NCF/qN0GW4wA16ITIBc+QXSapckY4pyD2EUOwVdSnXuVPEZAqU4fgAZahXhADizqzRC6POspkCe/es3KeLI0RbPH412K1+TIzB3Qz7xYyDChR3/43mwoa3TdjwV0E2SgNGkdZMKxcTZgKZ7SR5tJJZWGaWdEQ/d6NIn2fHis1tIZ1QVg1H9RT7CkCcymyte4038S/bju+SAHWB0n/oeWfdC1UxhrCzqgOx3xRyyPocs/MAoh8X2oneoWgFPu6b8TY5dNA10OZGOin4nnp0psPUg9h/v/otUDc/jqjBVf17OeqH4EGW2ipO5UXbNsLUkJevlHTA1raeD+HUgTIbPVjTUKGuO8+/P1jTaYGGwtotRP37WVoOZUItL02G786uPT9bi4GKrIlj9gnn7Ko5SDQMxz/4iIHvmRhPzXkgJTFCcsaEsP/3RVYXsoyW4LzCC9sx0z7RLnVLmqUDxmNuSWZtbqw78voWRHX9ZmWDMNHhFR9HR0sD69jo+cFMskZ1FzjJiDVvpmf5wlFJtueAKSjLQo1Yi6xRe8Dgn
 w6iXNh6S
 zWLFj/597JOr7gELu/Hb+/3iHE4F3VFohCTM1Dz+7vufCihMpg8DFTClo9K2NFQprMow7iEvtzqaNaCRO9pLTYBpwUzjJ+qFSQGstljc7y1R9T9M22jLDgRsNPS0gVJoBA/he24yHBurdV8ryW9E6sayz5i1HR153XNftLBab6hw/z19JbZi8jBMwwXdfhnNAH+8sBTja7j9k7BMz850ebFreCjTPED1RjqFdKZ+edT0UlAcEu4RZF3U2j0SEdp0Y36GMlaHHD6m5nR4/egUSQoFoswvYEErOP3bT/nEyBpxN8Ao6tAV3a3MpavUzcuQk/FcE5O/XT7O3NdOaG4EbGTy4oZnKf+WiUxiKwGUE2IMs4VnQ/7Udci5jjIJsJKuRg6VVGUTcAS9S1/jGYAbzrPo+7FYCqZBnwZySqvGNzye62+Y7Os0qmGx1oL4RqECZj3T9Qv76l44e2BJkLTo7HL3cO5UzevDaxrALYpIh0FTv5w7lX5uKK0geuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 6:49=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
>
> Verify that KASAN does not quarantine objects in SLAB_TYPESAFE_BY_RCU sla=
bs
> if CONFIG_SLUB_RCU_DEBUG is off.
>
> Signed-off-by: Jann Horn <jannh@google.com>
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
>         kmem_cache_destroy(cache);
>  }
>
> +/*
> + * Check that SLAB_TYPESAFE_BY_RCU objects are immediately reused when
> + * CONFIG_SLUB_RCU_DEBUG is off, and stay at the same address.

Would be great to also add an explanation of why we want to test for
this (or a reference to the related fix commit?).

> + */
> +static void kmem_cache_rcu_reuse(struct kunit *test)
> +{
> +       char *p, *p2;
> +       struct kmem_cache *cache;
> +
> +       KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_SLUB_RCU_DEBUG);
> +
> +       cache =3D kmem_cache_create("test_cache", 16, 0, SLAB_TYPESAFE_BY=
_RCU,
> +                                 NULL);
> +       KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
> +
> +       migrate_disable();
> +       p =3D kmem_cache_alloc(cache, GFP_KERNEL);
> +       if (!p) {
> +               kunit_err(test, "Allocation failed: %s\n", __func__);
> +               goto out;
> +       }
> +
> +       kmem_cache_free(cache, p);
> +       p2 =3D kmem_cache_alloc(cache, GFP_KERNEL);
> +       if (!p2) {
> +               kunit_err(test, "Allocation failed: %s\n", __func__);
> +               goto out;
> +       }
> +       KUNIT_EXPECT_PTR_EQ(test, p, p2);

I think this might fail for the HW_TAGS mode? The location will be
reused, but the tag will be different.

We could mark this test as Generic mode only.

> +
> +       kmem_cache_free(cache, p2);
> +
> +out:
> +       migrate_enable();
> +       kmem_cache_destroy(cache);
> +}
> +
>  static void kmem_cache_double_destroy(struct kunit *test)
>  {
>         struct kmem_cache *cache;
> @@ -2098,6 +2135,7 @@ static struct kunit_case kasan_kunit_test_cases[] =
=3D {
>         KUNIT_CASE(kmem_cache_double_free),
>         KUNIT_CASE(kmem_cache_invalid_free),
>         KUNIT_CASE(kmem_cache_rcu_uaf),
> +       KUNIT_CASE(kmem_cache_rcu_reuse),
>         KUNIT_CASE(kmem_cache_double_destroy),
>         KUNIT_CASE(kmem_cache_accounted),
>         KUNIT_CASE(kmem_cache_bulk),
>
> ---
> base-commit: 0df7d6c9705b283d5b71ee0ae86ead05bd3a55a9
> change-id: 20250728-kasan-tsbrcu-noquarantine-test-5c723367e056
> prerequisite-change-id: 20250723-kasan-tsbrcu-noquarantine-e207bb990e24:v=
1
> prerequisite-patch-id: 4fab9d3a121bfcaacc32a40f606b7c04e0c6fdd0
>
> --
> Jann Horn <jannh@google.com>
>

Thank you!

