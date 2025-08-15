Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D85DCCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 06:09:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B8C28E01D6; Fri, 15 Aug 2025 02:09:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5696B8E0002; Fri, 15 Aug 2025 02:09:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47FDA8E01D6; Fri, 15 Aug 2025 02:09:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33EEB8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:09:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E2CC83924
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:09:14 +0000 (UTC)
X-FDA: 83777964228.28.ECB2E26
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id 981951C0005
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:09:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Ta/cq+aU";
	spf=pass (imf18.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755238152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wACT+FdhCtuGzqGpHgePPwt5rag7S82b8o2EOM9TWRM=;
	b=W6sV5VVVGRtQlCa84P4qRrMEw1QPV5WCpK84xPxGfOA7IUojSNcSUguPr0ji/25Mqb7Y3n
	Vv1E36ioYqF3sHmW2VUj+MKB3MguoeSsmzTpbD2Yntjje8EsRknm2l+Tku4jZVZSqAGhkM
	1da9PkV2cTqJBKMVXQPZxqmLTo9B/dA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755238152; a=rsa-sha256;
	cv=none;
	b=2C+AbPc5w2wIE1vn2fHX8gfYlXmtmsRV5R5P9/mGluf9Dq4I+uq/lFobmaoB0fF1ZX+GLp
	k52N1FHQ2Wz3RPnb6WssytnWKsnTrXYmD6h6nCwyqUVJ4a/ILEqKflCWHHHevsYyX8flSO
	Wa0KQ++sGIhKVOibygKeu6KGn28HPZY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Ta/cq+aU";
	spf=pass (imf18.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3b9e41101d4so925807f8f.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755238151; x=1755842951; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wACT+FdhCtuGzqGpHgePPwt5rag7S82b8o2EOM9TWRM=;
        b=Ta/cq+aUkfFg3FmfGB2bfUqqc82p9R8zVU55u2dJ+iGDG8EUBW7B1fj80iwQt65Mn3
         ZxkgwAA9sBMzjpKmlpRwk6Uy7EnT1pPp940RrFhf37GaHu0VgITXKKjISc+089stbp+Y
         ZOa6sZ+1XhFPFJPXjFx78If+ALb3EcEZ7jT3jxlcjOBbMyYtXC2E7VOpTbn6gXqkq1fX
         YpzO0gshd9JcTiK/xg0CLeodSKJnFh4CWqriTR87Xcqqi4aFeDgDBh96utA1W+7fLVIk
         pjJDbHP1fXx3btcFyzMID794KjAYB0fNNtlS95W3A+JrVjTfcVSmJu7LTr9D7xYGHBTY
         oi1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755238151; x=1755842951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wACT+FdhCtuGzqGpHgePPwt5rag7S82b8o2EOM9TWRM=;
        b=trTCAvlkQ+K8+jYqvcVem2gEyjNq/lyySRQPRKWoXifFceOKpFzHMMz6qsl+bkI2uy
         BDyzRY64oPGkIAXMCjiKtJJviA/fhlM2a5mxvFlai7y027xiPSulC/VYu+6bzT7R/b2U
         xNvW61Y75c4WRlZu0oZx+ZCkBdfD0cukbkvJhqa+TutuSZbSTxxmb4d7XYB1sqiqp/5N
         1WQP/sfYKPOUtHd5d6UVhFXznUzRzJ858EMNKU0tKa2lP/P79WTsY2CFdTn6flUdmwr2
         HfijcwKBEDoUR7ggt5q+QWuu/TuWbeFW9waaIEQYc6/nP+mJ603+XXZd98jEr/jVpnY7
         qF/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWam/zVCqFJ8vm8lBrNwo0Y8dD7yDW88sQ/ZCtEaH1f2+79BIO3vBCfu8Ln68pafPRzPyb7HHftdA==@kvack.org
X-Gm-Message-State: AOJu0YzoPXjRMr0K5JY8/JGPAmSyDbrPNvB9Gu4AUDg6tOx4HyQGUYiv
	qj/4lS4X5WHbRXmWjMe+CVRBGaHh+wf12UjVwPLb426YGk3hjQk5beQSEk4J2w993kOAZyIuh/7
	BdBPKb3J8lsXPnR++9ngqzRDpJlCC0Kw=
X-Gm-Gg: ASbGnctnJEN0H6QCq2g7Q54aEFV4QreBkcL9gNDMHfTea99s3qREUvT42DFB0ZQQSjq
	KvIqbq9QP0l+nZIP7n1QZxp+eFKvBi4IBxthoEas8U0rvxYRIZm2RWJvIxONtAvBa63V63Vw4oM
	aJHTzMZ1BcuS7X0xqdVRWHtqCYKl0pKDpueIDQWLoCr55S5Jkydf6ZbWLDkNmSNkrrmtmPj9N8Y
	o1aX46m
X-Google-Smtp-Source: AGHT+IEmY4UxHNmzT5mmcGJ5yVWYiyyr32yQzIRK7G4RTu5taVUk+2ZjZyZEW43hZqMKpqbwNBeamGx203WJvwXYLvY=
X-Received: by 2002:a05:6000:25c2:b0:3b7:926f:894c with SMTP id
 ffacd0b85a97d-3bb675d3c7bmr406864f8f.23.1755238150774; Thu, 14 Aug 2025
 23:09:10 -0700 (PDT)
MIME-Version: 1.0
References: <20250814-kasan-tsbrcu-noquarantine-test-v3-1-9e9110009b4e@google.com>
In-Reply-To: <20250814-kasan-tsbrcu-noquarantine-test-v3-1-9e9110009b4e@google.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 15 Aug 2025 08:08:59 +0200
X-Gm-Features: Ac12FXw5QESzTXxkbg4UmhQH3TfIEeRhPi07Vg1NeAqS36aDi6tcJzP5tYrOvmc
Message-ID: <CA+fCnZcNy5NGL38YdKiqTVYeO2dAp_VEKHe6iOEo49H15X8gzw@mail.gmail.com>
Subject: Re: [PATCH v3] kasan: add test for SLAB_TYPESAFE_BY_RCU quarantine skipping
To: Jann Horn <jannh@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 981951C0005
X-Stat-Signature: 9dzs8to4xgm3qw6wu8emzctry65s8y39
X-HE-Tag: 1755238152-677303
X-HE-Meta: U2FsdGVkX19mbFtdKPpK9OIlMp3j00mHmqWn5YnoZ50fI+O5aIU/lc5ZyltNJG4CyEBxkWeIRsFo9aGAsJ98PNE+Cgf8vOanBA8sQZJ7AV2fg0xcx8j0mIinDvqSCU+oswxsP4523Q4t/m68QIR4WPZ/1VkmfVvVAYbqSjWC6BLKopJK2bDTfIBuPWgw3mV+HZkJ7q9OuuLEflwP69WQy5+J76esCNQAIHi48Ft+zSpRaRJJ4i97H3c2pf3IOPmB53twvQwlS4YDAMyiWwEuvXDAYIgfi1YUR6gNwcwBb6MeuBDaj1n7OFqhJ8KHFtSqTjmpDXhCsb6MOL+JD1Eqj4JY2vVeN++jv1wVLFB9O4gH2d8KZvs56aWaEr44uVOt6iA/ZNdKlDdvkcJ5gtTe9wRb+KS1iSOxPvWK2LTSkfd8vFgQTa/j6Cza/OXXJop9MXVXjaOho7UBQciIhGSh9Qbyzsps3F+D/ay6NztQC+vPFN8F6gNswZwONz8Vob879IGWxz6sEDcoq4Zw++QBy7m7PMYaHDY/eNGvPNpVv9AtxsJjuW8qdduKS6FylJiFb1prBfj0IFKEiOWnW2mRyHmUSY5rW7KwQWWL6Vcxq7CIu0stIO/bA4SG3470Sc0b5Hg45EsZ6tQK4wK1gpYInGotKC1+BAPpeUdspbyEa7n1OP5UKMRASvjZdkIZ605PpYflddF3Bpa+TEPwHvfQcY1molyiHLmHcigVIsh9ed+mk/k/KROfQJecyayjcPCybT8ohCL5UF3UavwhSA+5DZBjliyAGz/vy5jILO84BUDv93j/JpQlK4jBqlnqfE77LrYRvkPoBMw0R7FAlN0DAU/teIJ3DcMu67zUCbQKKoPPVd9OOujl28D2zJ5oZ5yo6nAOeA67ALVzyO9DpRiMnwK6gMsaXkyILMNrTzZ89zbf9upArC06CsOtlvVfxJ9HUM7cIYGJF3UiJcgVQol
 yXjpPXZI
 7I4FJo+sEjvmJKFEl+MAoD+9C0Qi2V8nkN1sk9hOLvnuajpBjqWXaUuVsPFI1UBdmzfA2tJdRuPCtuaIQ9rjt3l22CfyAJ92kPmMtuVmWdr4kjsNnBDtUSnWkBsXIkEPDCTIy8K4Mlegdc4+0KKm/fs3w1YZ+eSICinLsFSwNiIGB9XYniFg9suud7Cx6WHG3H/m0zBxqw6GVPFJa0pVGV/lQ+9RMq8mb6RShBRf/ZjiwWSb37kG8hHVfjrYdnIomtEDSkV1gbyZTcZWM6jKDKCNt4rlEh34XTKgE295Lfv2SZrxXDKBMu9TiMH9ctpY4x3pbkyiP/JtbB1zuZhFqeIzx+ldBhbb5JYQ+hylQIDOHYQtihL2mXBu+51bgujmJXdrjXQ2inQbevm3OkEi/KLNp9pyXzvicKAm4SgOPe/we91A5vSYj0G6NE6x1rf0dhbj64+YxaSHwkIbG+dNoEhUls8KbOFi+y2qvJZgrsIM0bPDig+jvj3lRnkoxQTtrgVBGVrdeq+ieJy2y+yzGCDCgx5GzKRhG0b67
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 5:11=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
>
> Verify that KASAN does not quarantine objects in SLAB_TYPESAFE_BY_RCU sla=
bs
> if CONFIG_SLUB_RCU_DEBUG is off.
>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
> Changes in v3:
>  - add vbabka's ack
>  - make comment more verbose (andreyknvl)
>  - Link to v2: https://lore.kernel.org/r/20250729-kasan-tsbrcu-noquaranti=
ne-test-v2-1-d16bd99309c9@google.com
> Changes in v2:
>  - disable migration to ensure that all SLUB operations use the same
>    percpu state (vbabka)
>  - use EXPECT instead of ASSERT for pointer equality check so that
>    expectation failure doesn't terminate the test with migration still
>    disabled
> ---
>  mm/kasan/kasan_test_c.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>
> diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> index 5f922dd38ffa..0affadb201c2 100644
> --- a/mm/kasan/kasan_test_c.c
> +++ b/mm/kasan/kasan_test_c.c
> @@ -1073,6 +1073,45 @@ static void kmem_cache_rcu_uaf(struct kunit *test)
>         kmem_cache_destroy(cache);
>  }
>
> +/*
> + * Check that SLAB_TYPESAFE_BY_RCU objects are immediately reused when
> + * CONFIG_SLUB_RCU_DEBUG is off, and stay at the same address.
> + * Without this, KASAN builds would be unable to trigger bugs caused by
> + * SLAB_TYPESAFE_BY_RCU users handling reycled objects improperly.
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
> @@ -2098,6 +2137,7 @@ static struct kunit_case kasan_kunit_test_cases[] =
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

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

Thank you!

