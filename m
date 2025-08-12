Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF671C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 16:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BF228E016B; Tue, 12 Aug 2025 12:28:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86F118E0168; Tue, 12 Aug 2025 12:28:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711628E016B; Tue, 12 Aug 2025 12:28:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 589868E0168
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:28:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D85BF58A87
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 16:28:28 +0000 (UTC)
X-FDA: 83768638296.25.B08E689
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id BFF1740006
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 16:28:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TFyNeHyc;
	spf=pass (imf17.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755016107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1DEQJQSXLAUts9QuH9e8jbi6NmiQPvWx/N73fs3TVeM=;
	b=BbfaDVXhwX1k7wnKhhz6hw8aodtSQf88kkGjmJU9qjuajBPT8eqDHXA2k2gZJ+QS3Sw6UR
	t5uFmglCF5I1xMpQB8VSYkCKEg5LXtbYSvsZfidaVAuLNeMyl+3O25tV5iqXey4SRDeuOz
	ucEyOVbH/S0VY2LAD/n5YrIb4bIWxpQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755016107; a=rsa-sha256;
	cv=none;
	b=gx99Tk6B5eFzA5UL+eLRw/sgSELIuzV+APR44Ar3UtOSB78r+o4hW3pTC4cwi2PRs3TCBj
	Vn8Yw7+Pi3UCqyvqjWaCPPeO8yyUBXoeVRZOXyRbu2+WG0qzip5xhs98fTOVK2GOf0mGmW
	LKUoWdRvoi54ZNwGCmwafzinTltTpUs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TFyNeHyc;
	spf=pass (imf17.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-458baf449cbso55227305e9.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755016105; x=1755620905; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1DEQJQSXLAUts9QuH9e8jbi6NmiQPvWx/N73fs3TVeM=;
        b=TFyNeHycnRq3uJpOJpgBsCR7CbRZLH1tlk/nS4WKIxzbe6hneO5QsNaAbjHUfPmGkF
         l6Wu7QgZFECm7RbKZQYdyST7pRR0+uYuiItnz/8nrdXfIMo2MSn3wR/FziNfHuqOcfTb
         zHnQwr553hMGcLKh8ON9lvobBof+IztuLIdlR7lehpuNsOD0CDMoBoSP76Fq8ABY/Ofj
         ENC79QiNQA2ZZOPLOeM1map4lMOnNX4DDdJYGmCQE/nrVhhrQ32mJbycYwrJfHBkMciT
         oHCTB4vI2FCQQI0nOYnbNyLodFoZADU2SfeoIRDHw+EwJBBduJTa9XX3vWhOhs3za1kk
         s5xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755016105; x=1755620905;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1DEQJQSXLAUts9QuH9e8jbi6NmiQPvWx/N73fs3TVeM=;
        b=vsacDHF9d2gN5Tm6qEShBns1VGdpd1arkXjun+9iLMDbQ92KgHWfY8X26aFUbVBUaN
         M0r1RbTP9gNj3TD/QfMPcgkYTbWqP0DXtPemTLD6KDrDvS1ALFKBKxZWyi8al0BoMXwj
         ebJphaTLThBN3N20G38Z+wTko6bhhE56ZAyyqFJog67dI4eMlFknClfAar2ijQyZp4BU
         5tmSjqQuaG3+yU+0ha583ItBI8sDWIL7rl37kXTvOindA/C8cA57iqaIyCWfbNjtnfA4
         EO48fIEIzwA6FxwZPHtHtaDz9ybKxHH7NXrAZzaMGQhLrm4kG/ocvn83Vj0wLqGKdmBu
         oJow==
X-Forwarded-Encrypted: i=1; AJvYcCXpH0VnjDTifpedC76yZTpicNT38P3Pmg7ow+y34KdRlXUyDhmmq+VDPmIWcnASkXWpm2fhVqy6Bw==@kvack.org
X-Gm-Message-State: AOJu0Yy+UYDgDW+xCuU5gnohgCYup27MDOeTf9V0He7v0wmGi2faKRDC
	RsTg2Eiht78+Utmjj1q2ki3Uae+a7ZG4+Efsr1XfPJYx+YQh1B3PlsLJDsJcU+0GBWffIW5q4Vl
	SBJwF59PCkwkqLywf7/6HyKDQBLCchkw=
X-Gm-Gg: ASbGnctQiTEV4OET8EhQoILFSWrXv4q1cP5t5+IBsHk2RPzSVDPL28nBF9gIZtB9cxS
	U4fx508f2o25Oh1uqMeHWCHv13s/KNM06bkNlzU5xaqpqps8uRZK3I3nZ8IlkZCsjTdNHosW13N
	yATsr8gJnyFRi0Xtg/XcLfkCQQ/+sRl4cLbOrXG73zAYT5Sq8j/sgKgTqfa/hHfw7oBpR7CujVV
	+CFWP1fuA==
X-Google-Smtp-Source: AGHT+IH3LcFrZP4xMU06DK74RgD0UODfe3deWBFBu8fZRXAKt+I4e40tKgIh39y6/0pdqOfCUGxAxa42ZahzhHUYv5c=
X-Received: by 2002:a05:600c:4585:b0:458:b01c:8f with SMTP id
 5b1f17b1804b1-45a15b1f996mr4788815e9.8.1755016104985; Tue, 12 Aug 2025
 09:28:24 -0700 (PDT)
MIME-Version: 1.0
References: <20250811173626.1878783-1-yeoreum.yun@arm.com> <20250811173626.1878783-3-yeoreum.yun@arm.com>
In-Reply-To: <20250811173626.1878783-3-yeoreum.yun@arm.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 12 Aug 2025 18:28:12 +0200
X-Gm-Features: Ac12FXwkg1JQz-u0IFfkfNxUBQy7VDQUXrQz_SW_sB6Boita2CZHjuZOWhhTDCM
Message-ID: <CA+fCnZeSV4fDBQr-WPFA66OYxN8zOQ2g1RQMDW3Ok8FaE7=NXQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] kasan: apply store-only mode in kasan kunit testcases
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com, 
	vincenzo.frascino@arm.com, corbet@lwn.net, catalin.marinas@arm.com, 
	will@kernel.org, akpm@linux-foundation.org, scott@os.amperecomputing.com, 
	jhubbard@nvidia.com, pankaj.gupta@amd.com, leitao@debian.org, 
	kaleshsingh@google.com, maz@kernel.org, broonie@kernel.org, 
	oliver.upton@linux.dev, james.morse@arm.com, ardb@kernel.org, 
	hardevsinh.palaniya@siliconsignals.io, david@redhat.com, 
	yang@os.amperecomputing.com, kasan-dev@googlegroups.com, 
	workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BFF1740006
X-Stat-Signature: e4uuuo61fbica1d95s5twm5jpa7hcf4y
X-HE-Tag: 1755016106-846010
X-HE-Meta: U2FsdGVkX19nilL2vYTW5THJkEyxPzDHLCP/u4lXLWbMyzLZ+u8oLAavJbOqKjsy8IvRl58ObUgCbEMtKLlS8Y78ZUeC8gR645ps+0W0It8kuCywE3FUMgYeitmcE5VMRbFyEPjFd3W2IxwBXToAEBH9oPUB8ZHtgUqn2fNi6gJXiEoo3g+Ko/BZvmccUoZCp+nIyC2nWJOw65wOd6JKSvTS9n8/G7/ejikWWTquvUd6GsLf5BhC5Ng5saV72jwXnpd98r8GQM1yJiala0/SG1XMcUkaoGXWwlDDr9ktClkueEPSCPutjv2ADNbS3yl8PbNLMLG5uKTTAja8e90LXoWGi9lKdZfAxCCSK8hoDx3NU14i53dbOvOHJQcygtDA14/1oZEXByvunSgHH5eY66UCOX1Q+tuwtjoMQ6gxxbK7IY+6MZ5RFX8kMzLE114wbmNX81WPWwNG5ShSvXPDDzciNLalJ6UJ5UzAB1Ak1rA0URfEtxy/dhfTCZvPpWj7+hDB61WQmw8vgyn51/vZ4dfnCNiF9I3bygQl0YzFwMyZvtzoFEWWZSjDvr5ZZSdmrp9tVliTT0NmZwPpqh9rqrl0UqfuS8SBmPBLl07rtbwd227QyBtOgHUphjfxVLvM/a0gck6Y0ZzqI3NLTpEGT9ePE5SUVO+F/sIoA+qbjxsT37eYUCaQoHzGaVr2T5u5F7UK1jF50mJ8NnumXmvjAlhZS5+nJ59ARREk3ujj62+M4TvYj7NNUEXSXa4ameefsarNER5Vjggehf3auN/fU1Gc4GxteVKUuC6Bmd/jiLFQQCAXAgOOdanwysjRq2GEyv7yAuJ7KPGD4TzVo4WmfBJ9rUCoTFovdYBJoXYJIQAT0L8/c1DMGwiq0/O5Q8stpS+5ks767I+cJVyz4ejtbD4bmYDzd6/zAsYHdaQZv6sBfH9+iT0Q1uuqxeA+FgMbqxSQQrfyIZz5vJX+kO+
 TXS+Gv+9
 L7hyqOkr+ljvBZPpl6TP6K+VVrn8rf0/RKUxsNGycl1D9nBAou/8ckdaVY28qSXBhywR0wo28LWw1nnbu2gcgpgkwjiCV6+QvHB2SK8Axm9eARjJAdphQfGDAxx1/0sVUwp6Pr5QFMppZe77YZwQ8toUevUB0TTc1Tmh7RKxCTun/29kAkwfpfxUZAJ0Z0yakJbdzJ5BHPAkELR3ZvWuKLF+rnknGtVFmaDt/v5cJnfgu+aES8bIdSEISXYRgBJTq3ZSNIkiuxzQY2rINPe/BD6dItdnkdG+a687YVDXPdurlgagRAOjjgYzKsxJXws+vQ1twlylSNWhOgvUrO/881DuhUIUWGsEZMkDoygot9sHM5U8IKuCydqlxm7KXcmXZObct2P+EuPCG/Q6tfU/MI+oBeKwa3ZHBHvZg0H2MQ1tE7RynoNjsLEFxSQpOtqYsQ0wbNrKhCDq8F4zLe6pFTd8LzmPWU49L8ltcI4hCyfKsUGw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 7:36=E2=80=AFPM Yeoreum Yun <yeoreum.yun@arm.com> w=
rote:
>
> When KASAN is configured in store-only mode,
> fetch/load operations do not trigger tag check faults.
> As a result, the outcome of some test cases may differ
> compared to when KASAN is configured without store-only mode.
>
> To address this:
>   1. Replace fetch/load expressions that would
>      normally trigger tag check faults with store operation
>      when running under store-only and sync mode.
>      In case of async/asymm mode, skip the store operation triggering
>      tag check fault since it corrupts memory.
>
>   2. Skip some testcases affected by initial value
>      (i.e) atomic_cmpxchg() testcase maybe successd if
>      it passes valid atomic_t address and invalid oldaval address.
>      In this case, if invalid atomic_t doesn't have the same oldval,
>      it won't trigger store operation so the test will pass.
>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  mm/kasan/kasan_test_c.c | 423 ++++++++++++++++++++++++++++++++--------
>  1 file changed, 341 insertions(+), 82 deletions(-)
>
> diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> index 2aa12dfa427a..22d5d6d6cd9f 100644
> --- a/mm/kasan/kasan_test_c.c
> +++ b/mm/kasan/kasan_test_c.c
> @@ -94,11 +94,13 @@ static void kasan_test_exit(struct kunit *test)
>  }
>
>  /**
> - * KUNIT_EXPECT_KASAN_FAIL - check that the executed expression produces=
 a
> - * KASAN report; causes a KUnit test failure otherwise.
> + * _KUNIT_EXPECT_KASAN_TEMPLATE - check that the executed expression pro=
duces
> + * a KASAN report or not; a KUnit test failure when it's different from =
@produce.
>   *
>   * @test: Currently executing KUnit test.
> - * @expression: Expression that must produce a KASAN report.
> + * @expr: Expression produce a KASAN report or not.
> + * @expr_str: Expression string
> + * @produce: expression should produce a KASAN report.
>   *
>   * For hardware tag-based KASAN, when a synchronous tag fault happens, t=
ag
>   * checking is auto-disabled. When this happens, this test handler reena=
bles
> @@ -110,25 +112,29 @@ static void kasan_test_exit(struct kunit *test)
>   * Use READ/WRITE_ONCE() for the accesses and compiler barriers around t=
he
>   * expression to prevent that.
>   *
> - * In between KUNIT_EXPECT_KASAN_FAIL checks, test_status.report_found i=
s kept
> + * In between _KUNIT_EXPECT_KASAN_TEMPLATE checks, test_status.report_fo=
und is kept
>   * as false. This allows detecting KASAN reports that happen outside of =
the
>   * checks by asserting !test_status.report_found at the start of
> - * KUNIT_EXPECT_KASAN_FAIL and in kasan_test_exit.
> + * _KUNIT_EXPECT_KASAN_TEMPLATE and in kasan_test_exit.
>   */
> -#define KUNIT_EXPECT_KASAN_FAIL(test, expression) do {                 \
> +#define _KUNIT_EXPECT_KASAN_TEMPLATE(test, expr, expr_str, produce)    \
> +do {                                                                   \
>         if (IS_ENABLED(CONFIG_KASAN_HW_TAGS) &&                         \
>             kasan_sync_fault_possible())                                \
>                 migrate_disable();                                      \
>         KUNIT_EXPECT_FALSE(test, READ_ONCE(test_status.report_found));  \
>         barrier();                                                      \
> -       expression;                                                     \
> +       expr;                                                           \
>         barrier();                                                      \
>         if (kasan_async_fault_possible())                               \
>                 kasan_force_async_fault();                              \
> -       if (!READ_ONCE(test_status.report_found)) {                     \
> -               KUNIT_FAIL(test, KUNIT_SUBTEST_INDENT "KASAN failure "  \
> -                               "expected in \"" #expression            \
> -                                "\", but none occurred");              \
> +       if (READ_ONCE(test_status.report_found) !=3D produce) {          =
 \
> +               KUNIT_FAIL(test, KUNIT_SUBTEST_INDENT "KASAN %s "       \
> +                               "expected in \"" expr_str               \
> +                                "\", but %soccurred",                  \
> +                               (produce ? "failure" : "success"),      \
> +                               (test_status.report_found ?             \
> +                                "" : "none "));                        \
>         }                                                               \
>         if (IS_ENABLED(CONFIG_KASAN_HW_TAGS) &&                         \
>             kasan_sync_fault_possible()) {                              \
> @@ -141,6 +147,26 @@ static void kasan_test_exit(struct kunit *test)
>         WRITE_ONCE(test_status.async_fault, false);                     \
>  } while (0)
>
> +/*
> + * KUNIT_EXPECT_KASAN_FAIL - check that the executed expression produces=
 a
> + * KASAN report; causes a KUnit test failure otherwise.
> + *
> + * @test: Currently executing KUnit test.
> + * @expr: Expression produce a KASAN report.
> + */
> +#define KUNIT_EXPECT_KASAN_FAIL(test, expr)                    \
> +       _KUNIT_EXPECT_KASAN_TEMPLATE(test, expr, #expr, true)
> +
> +/*
> + * KUNIT_EXPECT_KASAN_SUCCESS - check that the executed expression doesn=
't
> + * produces a KASAN report; causes a KUnit test failure otherwise.
> + *
> + * @test: Currently executing KUnit test.
> + * @expr: Expression doesn't produce a KASAN report.
> + */
> +#define KUNIT_EXPECT_KASAN_SUCCESS(test, expr)                 \
> +       _KUNIT_EXPECT_KASAN_TEMPLATE(test, expr, #expr, false)
> +
>  #define KASAN_TEST_NEEDS_CONFIG_ON(test, config) do {                  \
>         if (!IS_ENABLED(config))                                        \
>                 kunit_skip((test), "Test requires " #config "=3Dy");     =
 \
> @@ -183,8 +209,15 @@ static void kmalloc_oob_right(struct kunit *test)
>         KUNIT_EXPECT_KASAN_FAIL(test, ptr[size + 5] =3D 'y');
>
>         /* Out-of-bounds access past the aligned kmalloc object. */
> -       KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] =3D
> -                                       ptr[size + KASAN_GRANULE_SIZE + 5=
]);
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, ptr[0] =3D
> +                                               ptr[size + KASAN_GRANULE_=
SIZE + 5]);
> +               if (!kasan_async_fault_possible())
> +                       KUNIT_EXPECT_KASAN_FAIL(test,
> +                                       ptr[size + KASAN_GRANULE_SIZE + 5=
] =3D ptr[0]);
> +       } else
> +               KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] =3D
> +                                               ptr[size + KASAN_GRANULE_=
SIZE + 5]);
>
>         kfree(ptr);
>  }
> @@ -198,7 +231,13 @@ static void kmalloc_oob_left(struct kunit *test)
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>
>         OPTIMIZER_HIDE_VAR(ptr);
> -       KUNIT_EXPECT_KASAN_FAIL(test, *ptr =3D *(ptr - 1));
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, *ptr =3D *(ptr - 1));
> +               if (!kasan_async_fault_possible())
> +                       KUNIT_EXPECT_KASAN_FAIL(test, *(ptr - 1) =3D *(pt=
r));
> +       } else
> +               KUNIT_EXPECT_KASAN_FAIL(test, *ptr =3D *(ptr - 1));
> +
>         kfree(ptr);
>  }
>
> @@ -211,7 +250,13 @@ static void kmalloc_node_oob_right(struct kunit *tes=
t)
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>
>         OPTIMIZER_HIDE_VAR(ptr);
> -       KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] =3D ptr[size]);
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, ptr[0] =3D ptr[size]);
> +               if (!kasan_async_fault_possible())
> +                       KUNIT_EXPECT_KASAN_FAIL(test, ptr[size] =3D ptr[0=
]);
> +       } else
> +               KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] =3D ptr[size]);
> +
>         kfree(ptr);
>  }
>
> @@ -291,7 +336,12 @@ static void kmalloc_large_uaf(struct kunit *test)
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>         kfree(ptr);
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)ptr)[0=
]);
> +               if (!kasan_async_fault_possible())
> +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)p=
tr)[0] =3D 0);
> +       } else
> +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
>  }
>
>  static void kmalloc_large_invalid_free(struct kunit *test)
> @@ -323,7 +373,13 @@ static void page_alloc_oob_right(struct kunit *test)
>         ptr =3D page_address(pages);
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] =3D ptr[size]);
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, ptr[0] =3D ptr[size]);
> +               if (!kasan_async_fault_possible())
> +                       KUNIT_EXPECT_KASAN_FAIL(test, ptr[size] =3D ptr[0=
]);
> +       } else
> +               KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] =3D ptr[size]);
> +
>         free_pages((unsigned long)ptr, order);
>  }
>
> @@ -338,7 +394,12 @@ static void page_alloc_uaf(struct kunit *test)
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>         free_pages((unsigned long)ptr, order);
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)ptr)[0=
]);
> +               if (!kasan_async_fault_possible())
> +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)p=
tr)[0] =3D 0);
> +       } else
> +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
>  }
>
>  static void krealloc_more_oob_helper(struct kunit *test,
> @@ -455,10 +516,15 @@ static void krealloc_uaf(struct kunit *test)
>         ptr1 =3D kmalloc(size1, GFP_KERNEL);
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr1);
>         kfree(ptr1);
> -
>         KUNIT_EXPECT_KASAN_FAIL(test, ptr2 =3D krealloc(ptr1, size2, GFP_=
KERNEL));
>         KUNIT_ASSERT_NULL(test, ptr2);
> -       KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)ptr1);
> +
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, *(volatile char *)ptr1);
> +               if (!kasan_async_fault_possible())
> +                       KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)p=
tr1 =3D 0);
> +       } else
> +               KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)ptr1);
>  }
>
>  static void kmalloc_oob_16(struct kunit *test)
> @@ -501,7 +567,13 @@ static void kmalloc_uaf_16(struct kunit *test)
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr2);
>         kfree(ptr2);
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, *ptr1 =3D *ptr2);
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, *ptr1 =3D *ptr2);
> +               if (!kasan_async_fault_possible())
> +                       KUNIT_EXPECT_KASAN_FAIL(test, *ptr2 =3D *ptr1);
> +       } else
> +               KUNIT_EXPECT_KASAN_FAIL(test, *ptr1 =3D *ptr2);
> +
>         kfree(ptr1);
>  }
>
> @@ -640,8 +712,17 @@ static void kmalloc_memmove_invalid_size(struct kuni=
t *test)
>         memset((char *)ptr, 0, 64);
>         OPTIMIZER_HIDE_VAR(ptr);
>         OPTIMIZER_HIDE_VAR(invalid_size);
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> -               memmove((char *)ptr, (char *)ptr + 4, invalid_size));
> +
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test,
> +                       memmove((char *)ptr, (char *)ptr + 4, invalid_siz=
e));
> +               if (!kasan_async_fault_possible())
> +                       KUNIT_EXPECT_KASAN_FAIL(test,
> +                               memmove((char *)ptr + 4, (char *)ptr, inv=
alid_size));
> +       } else
> +               KUNIT_EXPECT_KASAN_FAIL(test,
> +                       memmove((char *)ptr, (char *)ptr + 4, invalid_siz=
e));
> +
>         kfree(ptr);
>  }
>
> @@ -654,7 +735,13 @@ static void kmalloc_uaf(struct kunit *test)
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>
>         kfree(ptr);
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[8]);
> +
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)ptr)[8=
]);
> +               if (!kasan_sync_fault_possible())
> +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)p=
tr)[8] =3D 0);
> +       } else
> +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[8]);
>  }
>
>  static void kmalloc_uaf_memset(struct kunit *test)
> @@ -701,7 +788,13 @@ static void kmalloc_uaf2(struct kunit *test)
>                 goto again;
>         }
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[40]);
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)ptr1)[=
40]);
> +               if (!kasan_sync_fault_possible())
> +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)p=
tr1)[40] =3D 0);
> +       } else
> +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[40]=
);
> +
>         KUNIT_EXPECT_PTR_NE(test, ptr1, ptr2);
>
>         kfree(ptr2);
> @@ -727,19 +820,35 @@ static void kmalloc_uaf3(struct kunit *test)
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr2);
>         kfree(ptr2);
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[8]);
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)ptr1)[=
8]);
> +               if (!kasan_sync_fault_possible())
> +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)p=
tr1)[8] =3D 0);
> +       } else
> +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[8])=
;
>  }
>
>  static void kasan_atomics_helper(struct kunit *test, void *unsafe, void =
*safe)
>  {
>         int *i_unsafe =3D unsafe;
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, READ_ONCE(*i_unsafe));
> +       if (kasan_stonly_enabled())
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, READ_ONCE(*i_unsafe));
> +       else
> +               KUNIT_EXPECT_KASAN_FAIL(test, READ_ONCE(*i_unsafe));
> +
>         KUNIT_EXPECT_KASAN_FAIL(test, WRITE_ONCE(*i_unsafe, 42));
> -       KUNIT_EXPECT_KASAN_FAIL(test, smp_load_acquire(i_unsafe));
> +       if (kasan_stonly_enabled())
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, smp_load_acquire(i_unsaf=
e));
> +       else
> +               KUNIT_EXPECT_KASAN_FAIL(test, smp_load_acquire(i_unsafe))=
;
>         KUNIT_EXPECT_KASAN_FAIL(test, smp_store_release(i_unsafe, 42));
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_read(unsafe));
> +       if (kasan_stonly_enabled())
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, atomic_read(unsafe));
> +       else
> +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_read(unsafe));
> +
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_set(unsafe, 42));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_add(42, unsafe));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_sub(42, unsafe));
> @@ -752,18 +861,38 @@ static void kasan_atomics_helper(struct kunit *test=
, void *unsafe, void *safe)
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_xchg(unsafe, 42));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_cmpxchg(unsafe, 21, 42));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_try_cmpxchg(unsafe, safe, 42=
));
> -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_try_cmpxchg(safe, unsafe, 42=
));
> +
> +       /*
> +        * The result of the test below may vary due to garbage values of=
 unsafe in
> +        * store-only mode. Therefore, skip this test when KASAN is confi=
gured
> +        * in store-only mode.
> +        */
> +       if (!kasan_stonly_enabled())
> +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_try_cmpxchg(safe, un=
safe, 42));
> +
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_sub_and_test(42, unsafe));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_dec_and_test(unsafe));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_inc_and_test(unsafe));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_add_negative(42, unsafe));
> -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_add_unless(unsafe, 21, 42));
> -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_inc_not_zero(unsafe));
> -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_inc_unless_negative(unsafe))=
;
> -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_dec_unless_positive(unsafe))=
;
> -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_dec_if_positive(unsafe));
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_read(unsafe));
> +       /*
> +        * The result of the test below may vary due to garbage values of=
 unsafe in
> +        * store-only mode. Therefore, skip this test when KASAN is confi=
gured
> +        * in store-only mode.
> +        */
> +       if (!kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_add_unless(unsafe, 2=
1, 42));
> +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_inc_not_zero(unsafe)=
);
> +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_inc_unless_negative(=
unsafe));
> +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_dec_unless_positive(=
unsafe));
> +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_dec_if_positive(unsa=
fe));
> +       }
> +
> +       if (kasan_stonly_enabled())
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, atomic_long_read(unsafe)=
);
> +       else
> +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_read(unsafe));
> +
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_set(unsafe, 42));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_add(42, unsafe));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_sub(42, unsafe));
> @@ -776,16 +905,32 @@ static void kasan_atomics_helper(struct kunit *test=
, void *unsafe, void *safe)
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_xchg(unsafe, 42));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_cmpxchg(unsafe, 21, 42)=
);
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_try_cmpxchg(unsafe, saf=
e, 42));
> -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_try_cmpxchg(safe, unsaf=
e, 42));
> +
> +       /*
> +        * The result of the test below may vary due to garbage values in
> +        * store-only mode. Therefore, skip this test when KASAN is confi=
gured
> +        * in store-only mode.
> +        */
> +       if (!kasan_stonly_enabled())
> +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_try_cmpxchg(saf=
e, unsafe, 42));
> +
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_sub_and_test(42, unsafe=
));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_dec_and_test(unsafe));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_inc_and_test(unsafe));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_add_negative(42, unsafe=
));
> -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_add_unless(unsafe, 21, =
42));
> -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_inc_not_zero(unsafe));
> -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_inc_unless_negative(uns=
afe));
> -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_dec_unless_positive(uns=
afe));
> -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_dec_if_positive(unsafe)=
);
> +
> +       /*
> +        * The result of the test below may vary due to garbage values in
> +        * store-only mode. Therefore, skip this test when KASAN is confi=
gured
> +        * in store-only mode.
> +        */
> +       if (!kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_add_unless(unsa=
fe, 21, 42));
> +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_inc_not_zero(un=
safe));
> +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_inc_unless_nega=
tive(unsafe));
> +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_dec_unless_posi=
tive(unsafe));
> +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_dec_if_positive=
(unsafe));
> +       }
>  }
>
>  static void kasan_atomics(struct kunit *test)
> @@ -842,8 +987,18 @@ static void ksize_unpoisons_memory(struct kunit *tes=
t)
>         /* These must trigger a KASAN report. */
>         if (IS_ENABLED(CONFIG_KASAN_GENERIC))
>                 KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size=
]);
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size + 5]);
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size - =
1]);
> +
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)ptr)[s=
ize + 5]);
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)ptr)[r=
eal_size - 1]);
> +               if (!kasan_sync_fault_possible()) {
> +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)p=
tr)[size + 5] =3D 0);
> +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)p=
tr)[real_size - 1] =3D 0);
> +               }
> +       } else {
> +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size=
 + 5]);
> +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real=
_size - 1]);
> +       }
>
>         kfree(ptr);
>  }
> @@ -863,8 +1018,17 @@ static void ksize_uaf(struct kunit *test)
>
>         OPTIMIZER_HIDE_VAR(ptr);
>         KUNIT_EXPECT_KASAN_FAIL(test, ksize(ptr));
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size]);
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)ptr)[0=
]);
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)ptr)[s=
ize]);
> +               if (!kasan_sync_fault_possible()) {
> +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)p=
tr)[0] =3D 0);
> +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)p=
tr)[size] =3D 0);
> +               }
> +       } else {
> +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size=
]);
> +       }
>  }
>
>  /*
> @@ -886,7 +1050,11 @@ static void rcu_uaf_reclaim(struct rcu_head *rp)
>                 container_of(rp, struct kasan_rcu_info, rcu);
>
>         kfree(fp);
> -       ((volatile struct kasan_rcu_info *)fp)->i;
> +
> +       if (kasan_stonly_enabled() && !kasan_async_fault_possible())
> +               ((volatile struct kasan_rcu_info *)fp)->i =3D 0;
> +       else
> +               ((volatile struct kasan_rcu_info *)fp)->i;
>  }
>
>  static void rcu_uaf(struct kunit *test)
> @@ -899,9 +1067,14 @@ static void rcu_uaf(struct kunit *test)
>         global_rcu_ptr =3D rcu_dereference_protected(
>                                 (struct kasan_rcu_info __rcu *)ptr, NULL)=
;
>
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> -               call_rcu(&global_rcu_ptr->rcu, rcu_uaf_reclaim);
> -               rcu_barrier());
> +       if (kasan_stonly_enabled() && kasan_async_fault_possible())
> +               KUNIT_EXPECT_KASAN_SUCCESS(test,
> +                       call_rcu(&global_rcu_ptr->rcu, rcu_uaf_reclaim);
> +                       rcu_barrier());
> +       else
> +               KUNIT_EXPECT_KASAN_FAIL(test,
> +                       call_rcu(&global_rcu_ptr->rcu, rcu_uaf_reclaim);
> +                       rcu_barrier());
>  }
>
>  static void workqueue_uaf_work(struct work_struct *work)
> @@ -924,8 +1097,12 @@ static void workqueue_uaf(struct kunit *test)
>         queue_work(workqueue, work);
>         destroy_workqueue(workqueue);
>
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> -               ((volatile struct work_struct *)work)->data);
> +       if (kasan_stonly_enabled())
> +               KUNIT_EXPECT_KASAN_SUCCESS(test,
> +                       ((volatile struct work_struct *)work)->data);
> +       else
> +               KUNIT_EXPECT_KASAN_FAIL(test,
> +                       ((volatile struct work_struct *)work)->data);
>  }
>
>  static void kfree_via_page(struct kunit *test)
> @@ -972,7 +1149,12 @@ static void kmem_cache_oob(struct kunit *test)
>                 return;
>         }
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, *p =3D p[size + OOB_TAG_OFF]);
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, *p =3D p[size + OOB_TAG_=
OFF]);
> +               if (!kasan_async_fault_possible())
> +                       KUNIT_EXPECT_KASAN_FAIL(test, p[size + OOB_TAG_OF=
F] =3D *p);
> +       } else
> +               KUNIT_EXPECT_KASAN_FAIL(test, *p =3D p[size + OOB_TAG_OFF=
]);
>
>         kmem_cache_free(cache, p);
>         kmem_cache_destroy(cache);
> @@ -1068,7 +1250,12 @@ static void kmem_cache_rcu_uaf(struct kunit *test)
>          */
>         rcu_barrier();
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, READ_ONCE(*p));
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, READ_ONCE(*p));
> +               if (!kasan_async_fault_possible())
> +                       KUNIT_EXPECT_KASAN_FAIL(test, WRITE_ONCE(*p, 0));
> +       } else
> +               KUNIT_EXPECT_KASAN_FAIL(test, READ_ONCE(*p));
>
>         kmem_cache_destroy(cache);
>  }
> @@ -1206,7 +1393,13 @@ static void mempool_oob_right_helper(struct kunit =
*test, mempool_t *pool, size_t
>         if (IS_ENABLED(CONFIG_KASAN_GENERIC))
>                 KUNIT_EXPECT_KASAN_FAIL(test,
>                         ((volatile char *)&elem[size])[0]);
> -       else
> +       else if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test,
> +                       ((volatile char *)&elem[round_up(size, KASAN_GRAN=
ULE_SIZE)])[0]);
> +               if (!kasan_async_fault_possible())
> +                       KUNIT_EXPECT_KASAN_FAIL(test,
> +                               ((volatile char *)&elem[round_up(size, KA=
SAN_GRANULE_SIZE)])[0] =3D 0);
> +       } else
>                 KUNIT_EXPECT_KASAN_FAIL(test,
>                         ((volatile char *)&elem[round_up(size, KASAN_GRAN=
ULE_SIZE)])[0]);
>
> @@ -1273,7 +1466,13 @@ static void mempool_uaf_helper(struct kunit *test,=
 mempool_t *pool, bool page)
>         mempool_free(elem, pool);
>
>         ptr =3D page ? page_address((struct page *)elem) : elem;
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> +
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)ptr)[0=
]);
> +               if (!kasan_async_fault_possible())
> +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)p=
tr)[0] =3D 0);
> +       } else
> +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
>  }
>
>  static void mempool_kmalloc_uaf(struct kunit *test)
> @@ -1532,8 +1731,13 @@ static void kasan_memchr(struct kunit *test)
>
>         OPTIMIZER_HIDE_VAR(ptr);
>         OPTIMIZER_HIDE_VAR(size);
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> -               kasan_ptr_result =3D memchr(ptr, '1', size + 1));
> +
> +       if (kasan_stonly_enabled())
> +               KUNIT_EXPECT_KASAN_SUCCESS(test,
> +                       kasan_ptr_result =3D memchr(ptr, '1', size + 1));
> +       else
> +               KUNIT_EXPECT_KASAN_FAIL(test,
> +                       kasan_ptr_result =3D memchr(ptr, '1', size + 1));
>
>         kfree(ptr);
>  }
> @@ -1559,8 +1763,14 @@ static void kasan_memcmp(struct kunit *test)
>
>         OPTIMIZER_HIDE_VAR(ptr);
>         OPTIMIZER_HIDE_VAR(size);
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> -               kasan_int_result =3D memcmp(ptr, arr, size+1));
> +
> +       if (kasan_stonly_enabled())
> +               KUNIT_EXPECT_KASAN_SUCCESS(test,
> +                       kasan_int_result =3D memcmp(ptr, arr, size+1));
> +       else
> +               KUNIT_EXPECT_KASAN_FAIL(test,
> +                       kasan_int_result =3D memcmp(ptr, arr, size+1));
> +
>         kfree(ptr);
>  }
>
> @@ -1593,9 +1803,16 @@ static void kasan_strings(struct kunit *test)
>         KUNIT_EXPECT_EQ(test, KASAN_GRANULE_SIZE - 2,
>                         strscpy(ptr, src + 1, KASAN_GRANULE_SIZE));
>
> -       /* strscpy should fail if the first byte is unreadable. */
> -       KUNIT_EXPECT_KASAN_FAIL(test, strscpy(ptr, src + KASAN_GRANULE_SI=
ZE,
> -                                             KASAN_GRANULE_SIZE));
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, strscpy(ptr, src + KASAN=
_GRANULE_SIZE,
> +                                                     KASAN_GRANULE_SIZE)=
);
> +               if (!kasan_async_fault_possible())
> +                       /* strscpy should fail when the first byte is to =
be written. */
> +                       KUNIT_EXPECT_KASAN_FAIL(test, strscpy(ptr + size,=
 src, KASAN_GRANULE_SIZE));
> +       } else
> +               /* strscpy should fail if the first byte is unreadable. *=
/
> +               KUNIT_EXPECT_KASAN_FAIL(test, strscpy(ptr, src + KASAN_GR=
ANULE_SIZE,
> +                                                     KASAN_GRANULE_SIZE)=
);
>
>         kfree(src);
>         kfree(ptr);
> @@ -1607,17 +1824,22 @@ static void kasan_strings(struct kunit *test)
>          * will likely point to zeroed byte.
>          */
>         ptr +=3D 16;
> -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_ptr_result =3D strchr(ptr, '1=
'));
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_ptr_result =3D strrchr(ptr, '=
1'));
> -
> -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =3D strcmp(ptr, "2=
"));
> -
> -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =3D strncmp(ptr, "=
2", 1));
> -
> -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =3D strlen(ptr));
> -
> -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =3D strnlen(ptr, 1=
));
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, kasan_ptr_result =3D str=
chr(ptr, '1'));
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, kasan_ptr_result =3D str=
rchr(ptr, '1'));
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, kasan_int_result =3D str=
cmp(ptr, "2"));
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, kasan_int_result =3D str=
ncmp(ptr, "2", 1));
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, kasan_int_result =3D str=
len(ptr));
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, kasan_int_result =3D str=
nlen(ptr, 1));
> +       } else {
> +               KUNIT_EXPECT_KASAN_FAIL(test, kasan_ptr_result =3D strchr=
(ptr, '1'));
> +               KUNIT_EXPECT_KASAN_FAIL(test, kasan_ptr_result =3D strrch=
r(ptr, '1'));
> +               KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =3D strcmp=
(ptr, "2"));
> +               KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =3D strncm=
p(ptr, "2", 1));
> +               KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =3D strlen=
(ptr));
> +               KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =3D strnle=
n(ptr, 1));
> +       }
>  }
>
>  static void kasan_bitops_modify(struct kunit *test, int nr, void *addr)
> @@ -1636,12 +1858,27 @@ static void kasan_bitops_test_and_modify(struct k=
unit *test, int nr, void *addr)
>  {
>         KUNIT_EXPECT_KASAN_FAIL(test, test_and_set_bit(nr, addr));
>         KUNIT_EXPECT_KASAN_FAIL(test, __test_and_set_bit(nr, addr));
> -       KUNIT_EXPECT_KASAN_FAIL(test, test_and_set_bit_lock(nr, addr));
> +
> +       /*
> +        * When KASAN is running in store-only mode,
> +        * a fault won't occur even if the bit is set.
> +        * Therefore, skip the test_and_set_bit_lock test in store-only m=
ode.
> +        */
> +       if (!kasan_stonly_enabled())
> +               KUNIT_EXPECT_KASAN_FAIL(test, test_and_set_bit_lock(nr, a=
ddr));
> +
>         KUNIT_EXPECT_KASAN_FAIL(test, test_and_clear_bit(nr, addr));
>         KUNIT_EXPECT_KASAN_FAIL(test, __test_and_clear_bit(nr, addr));
>         KUNIT_EXPECT_KASAN_FAIL(test, test_and_change_bit(nr, addr));
>         KUNIT_EXPECT_KASAN_FAIL(test, __test_and_change_bit(nr, addr));
> -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =3D test_bit(nr, a=
ddr));
> +
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, kasan_int_result =3D tes=
t_bit(nr, addr));
> +               if (!kasan_async_fault_possible())
> +                       KUNIT_EXPECT_KASAN_FAIL(test, set_bit(nr, addr));
> +  } else
> +               KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =3D test_b=
it(nr, addr));
> +
>         if (nr < 7)
>                 KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =3D
>                                 xor_unlock_is_negative_byte(1 << nr, addr=
));
> @@ -1765,7 +2002,12 @@ static void vmalloc_oob(struct kunit *test)
>                 KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)v_ptr)[si=
ze]);
>
>         /* An aligned access into the first out-of-bounds granule. */
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)v_ptr)[size + 5])=
;
> +       if (kasan_stonly_enabled()) {
> +               KUNIT_EXPECT_KASAN_SUCCESS(test, ((volatile char *)v_ptr)=
[size + 5]);
> +               if (!kasan_async_fault_possible())
> +                       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)v=
_ptr)[size + 5] =3D 0);
> +       } else
> +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)v_ptr)[si=
ze + 5]);
>
>         /* Check that in-bounds accesses to the physical page are valid. =
*/
>         page =3D vmalloc_to_page(v_ptr);
> @@ -2042,16 +2284,33 @@ static void copy_user_test_oob(struct kunit *test=
)
>
>         KUNIT_EXPECT_KASAN_FAIL(test,
>                 unused =3D copy_from_user(kmem, usermem, size + 1));
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> -               unused =3D copy_to_user(usermem, kmem, size + 1));
> +
> +       if (kasan_stonly_enabled())
> +               KUNIT_EXPECT_KASAN_SUCCESS(test,
> +                       unused =3D copy_to_user(usermem, kmem, size + 1))=
;
> +       else
> +               KUNIT_EXPECT_KASAN_FAIL(test,
> +                       unused =3D copy_to_user(usermem, kmem, size + 1))=
;
> +
>         KUNIT_EXPECT_KASAN_FAIL(test,
>                 unused =3D __copy_from_user(kmem, usermem, size + 1));
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> -               unused =3D __copy_to_user(usermem, kmem, size + 1));
> +
> +       if (kasan_stonly_enabled())
> +               KUNIT_EXPECT_KASAN_SUCCESS(test,
> +                       unused =3D __copy_to_user(usermem, kmem, size + 1=
));
> +       else
> +               KUNIT_EXPECT_KASAN_FAIL(test,
> +                       unused =3D __copy_to_user(usermem, kmem, size + 1=
));
> +
>         KUNIT_EXPECT_KASAN_FAIL(test,
>                 unused =3D __copy_from_user_inatomic(kmem, usermem, size =
+ 1));
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> -               unused =3D __copy_to_user_inatomic(usermem, kmem, size + =
1));
> +
> +       if (kasan_stonly_enabled())
> +               KUNIT_EXPECT_KASAN_SUCCESS(test,
> +                       unused =3D __copy_to_user_inatomic(usermem, kmem,=
 size + 1));
> +       else
> +               KUNIT_EXPECT_KASAN_FAIL(test,
> +                       unused =3D __copy_to_user_inatomic(usermem, kmem,=
 size + 1));
>
>         /*
>         * Prepare a long string in usermem to avoid the strncpy_from_user=
 test
> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
>

This patch does not look good.

Right now, KASAN tests are crafted to avoid/self-contain harmful
memory corruptions that they do (e.g. make sure that OOB write
accesses land in in-object kmalloc training space, etc.). If you turn
read accesses in tests into write accesses, memory corruptions caused
by the earlier tests will crash the kernel or the latter tests.

The easiest thing to do for now is to disable the tests that check bad
read accesses when store-only is enabled.

If we want to convert tests into doing write accesses instead of
reads, this needs to be done separately for each test (i.e. via a
separate patch) with an explanation why doing this is safe (and
adjustments whenever it's not). And we need a better way to code this
instead of the horrifying number of if/else checks.

Thank you!

