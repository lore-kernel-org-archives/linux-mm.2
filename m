Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF6FCA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 12:49:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B83B18E000B; Wed,  3 Sep 2025 08:49:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33B38E0001; Wed,  3 Sep 2025 08:49:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FBE48E000B; Wed,  3 Sep 2025 08:49:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8784B8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:49:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30EDA11A767
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:49:50 +0000 (UTC)
X-FDA: 83847920940.05.B94FCFF
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2DF0040007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:49:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hvwb6DAW;
	spf=pass (imf11.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756903788; a=rsa-sha256;
	cv=none;
	b=iQXiFU8bf+ACqs8vUYjm5H8bKLrq9gbtKQx8uiPd4ax/RdgUQEh5eeqmjCmQI13k8X/mhT
	rDB4oSei1DcHBOYNtcRG25W/EHVi+EsaNhrN7hJekNVqnksiJyH7QKVyajBodCyy3aILwq
	D80T80eoPs7H04IPjSXkaiJKjeuh3Po=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hvwb6DAW;
	spf=pass (imf11.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756903788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qioTky0DA20wU3b9bBxL/z2sHC6Vqg3Be64wxGFGkZs=;
	b=PAYbCK1S/KF4I/eH37sW+eMg7WM6/yGfyhqtHh1IS4H9KpvG3pv9RLqq/HZlPSzhMh/IgP
	B+/1m6kzd6TRBWruLBLzQpCo63/EOsZqDZugVTmrkGEbmfqZGuUB3Y7nnIidBEyydmIzpO
	Ol+JmaHGks+dVxbVAStsS24fZ2GrCtE=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3c46686d1e6so4444064f8f.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 05:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756903787; x=1757508587; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qioTky0DA20wU3b9bBxL/z2sHC6Vqg3Be64wxGFGkZs=;
        b=hvwb6DAWMa+/GGnkk3vvGk7RKTutWaIOd6mXttPQW0ipqkqAQJHhpf3jrWjXqaN6GG
         TnTy/KZt5ekiFIOXMBr4m72/pzOwLuNmcmumsx1YNySLcEmZrICzN8oS7getwWyof52W
         OMsUyYxo/5+DR/70odN5N9tvyfle9aipPredvf/TpAGIdIPmu8s7BwHL9F66i5JtuAG7
         nVe8w7+GsfpAW39EZ65rsSU+G/hEHPb+PMWXAj6BO2juZ9rqUsNnBBdVTBF5q9cK8G3J
         MDqPDASjyawlv817maVlrpyKbDbgD5xdH+cu1RT/nloeJdSft2LQ8BugmGQU8vqWUC1u
         /3ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756903787; x=1757508587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qioTky0DA20wU3b9bBxL/z2sHC6Vqg3Be64wxGFGkZs=;
        b=P81oRH0BDInNJc1IXqTNw/Q5B5jnV/5M/ZuVRciVmEU2V2Wzn5t7JzNDslodYimxUk
         dXG66JED+Fii1JxEMKyv3aTG0Uytt3OTHpJOQgUnTmDM8yNyj0AlU496lwhX7x48gNym
         S2ohuPTW3RKajOE9ThMBDLqYY5HVNgXpJ2RYVaePxXKtAcJomBx8sfwE5LEnt4659R0C
         ThKC4D3AboTiSJNSTlOXHznhqXIC/gfUGHBM7x6It5MxUa327Q1SqwtAtwDzXEehs8tf
         fISPDfdiuMUTDW19aqdm/oRAVvcbguEe5yE8zOpXvrg0eoktZ7h3HaIniMpheXmIidgV
         DFPA==
X-Forwarded-Encrypted: i=1; AJvYcCXnT5CHtGcx0lYN9CPn03tFLGfN7YTP/oOLNp1/vKV4CjPundbC7ePSW5bQvX4Oew1uR3EN29MsDQ==@kvack.org
X-Gm-Message-State: AOJu0YzgaOFy1GfzjnYlpHPYftvoyI+k0+3IaO2+B0TjyYpSKaLay6xM
	d4QXLmoauai4jFuHg8R7j7lp1wozesv61UOmVxIprjq3OQh30s5jqn/IUM/80teJgi0OkG1G0iV
	qAUgWrGsYo+P76qY2SvBB+RWqemQzcoc=
X-Gm-Gg: ASbGncsqIbGFwQhF0/Nbh5rOX6nuN609el98opTbIVTYhSYBH1rv7jjZo2RWeeIZVlH
	HmuEY+dQBd+QuNKjKxY9fBBPbMobk21pUmMEcJQT9eeT429b+t0bLKBmDcOYwbXIIeTf16KQzM3
	6yA8vYuSrl9y0Wh1PJhEL8Vngon4o2zvdBq4kJZycN3f0u/EUUqXm6eMHhAalKFeQvHl1JTbUMC
	SWT+Nvx
X-Google-Smtp-Source: AGHT+IG4+8guXK6dPRv/VXyLxQ/FpO33e3SLX5O7uf6Y+CRIlj9YZLYgvT0PmeUaSWp86M24p22so0J1gqtN5Ff9B7s=
X-Received: by 2002:a05:6000:2890:b0:3de:c5b3:dda2 with SMTP id
 ffacd0b85a97d-3dec5b3e033mr1667450f8f.34.1756903786262; Wed, 03 Sep 2025
 05:49:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250901104623.402172-1-yeoreum.yun@arm.com> <20250901104623.402172-3-yeoreum.yun@arm.com>
In-Reply-To: <20250901104623.402172-3-yeoreum.yun@arm.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Wed, 3 Sep 2025 14:49:34 +0200
X-Gm-Features: Ac12FXyu_2MW1p9hqzVMXrUjzZRBuRkpC_vIzVYx2h5zKsSvlwoHHiBIosQjurc
Message-ID: <CA+fCnZeyKuet2XY9=jOdiK4Z6f4_=Xb5ZBzBaDL-2gFPv9yJ5A@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] kasan: apply write-only mode in kasan kunit testcases
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2DF0040007
X-Stat-Signature: aqtxohtoffczfeu9f96s5knqz8s65yaa
X-Rspam-User: 
X-HE-Tag: 1756903787-163647
X-HE-Meta: U2FsdGVkX1+/mqrBxTL8XfHplg8GHREbBpLTmNebvR5Zb9WGHW8vuHydfZzabYvtRkRDcu7AtLbGKfWuTjF9szqi7E/rc2n0UjKDf6uigVNHpXfMWTqzcs8E6QLl/7HNiVAIcJksfBJKJR/lomDz1uCvHJhpCtJIDWMefaMgzrXMneW4XuHxp5SIHaotonCdvC2R5CWB8CA2B4ThJSFPL6KN0fIukgnEdRuauVa3cUCXyWK7PVMbGd873zYVN4O1OsFJ+ivxnY3uOLXrQqnQL2Loi4HCRw7Q8iIT9VQUKnYESdiJ2zQzUlCgr/gVvy3/2tDhgi9zCVdJOnNwpgl2U/5Phl6zYPzXeSX59x+ioHkjf1IoKs763xaanejOEzdSf3oFz87KRJsfvF+1i+deFFPyzXQRRbu2KF9AePyx7JMrrbrFn6fR7GpQEUr9wXdcBQhj9ZCF5Z8oB9EZEYnpgNvfysJUxEJp7xD12YXYUjPnqVqS5iO6OCD3JFfl8wGkIjGC0kmPN1fg2Q6MGk8Wqbh6ryaJEGP60mAtNtIliqhK6Zw6CjpsyV8gholeTe+VOUSRtE1FhWKtoFrwNb+wkR8DdkbloQRn0dNQ9WQcLelUniN/+/dXZ3G0bhAIPbgMLXup1KCfKv7HcohXYdAdGkH8IwKz78/BoolG2JK1dcpa0z/TItaehA2oTY1UWmXNT8OEEqB9V/hwEXCM3oPXQtjgXswI+7Lh2ec5g59Wnjos0wcSKew2F+PzhmmHoiW9/tejFItLaRyPuksKrghmC9hhpV+vcx+zue2buYeHRUrUGnbhZH69va7Jc834UCx2jk+VDJCrjC9O9kKNfw0QfS3ljXwVp3d29GVofl69cJFr4jCKQHkbMIcbewkI2nqGCmuRFO7ta5HBFs8lzOLlKStQaCp0B+Uaf7eK6MNeRy7+41O1dMkembKyIYLnrWZnGT5tqpTrktp3dxIegsU
 SeeC9rMD
 87b68J8oh3EsriCKrW13YESE0weZuZaNnZAovNUll0ZzbFFdwGKU8DeqIfplL3joSitlhiSKpskzI4h+vvNyAdTkA3r0z4nldt4r4cPXMSUNjzMPCaCrfYCiHlu1cxJyk6L/1oPo/bEVye1pFEhqoLdQTgMbVRVtxlPrxazKcXADs3oP6jGY1ltHCnB+HMJN0cAoTy2NGDQ/q9nai4L5XAWxnAP8qAbv98wi3BEmaSGmpTOW7ZwSkCRmCtim9j++4spHyAqM+vhoq/WXUaY7ILPwVVdWaxrdxzaqM11wD4Zm1VHqbsJjKiz2VABVSZ4/NIWU6Gu+rzxO+FCj6jFDP5/re5ecah9WmBS6Cag6/IHNeTb9phaYDwzhExuu0Z8j6h4yiHBE/gEP+kQB0sjvWmI1xqegoDe0q9kC0jFf0vHzDiMdNxyf/B14bRnGnMbSGej8GBYDrkbS2zAa5YBLn67ovob/Ir6HtcmHtz8MmShOC5YNnq4XQvwk4Vvxnix01TRSK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 12:46=E2=80=AFPM Yeoreum Yun <yeoreum.yun@arm.com> w=
rote:
>
> When KASAN is configured in write-only mode,
> fetch/load operations do not trigger tag check faults.
>
> As a result, the outcome of some test cases may differ
> compared to when KASAN is configured without write-only mode.
>
> Therefore, by modifying pre-exist testcases
> check the write only makes tag check fault (TCF) where
> writing is perform in "allocated memory" but tag is invalid
> (i.e) redzone write in atomic_set() testcases.
> Otherwise check the invalid fetch/read doesn't generate TCF.
>
> Also, skip some testcases affected by initial value
> (i.e) atomic_cmpxchg() testcase maybe successd if
> it passes valid atomic_t address and invalid oldaval address.
> In this case, if invalid atomic_t doesn't have the same oldval,
> it won't trigger write operation so the test will pass.
>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  mm/kasan/kasan_test_c.c | 204 ++++++++++++++++++++++++++--------------
>  1 file changed, 135 insertions(+), 69 deletions(-)
>
> diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> index e0968acc03aa..8b3bb33603e1 100644
> --- a/mm/kasan/kasan_test_c.c
> +++ b/mm/kasan/kasan_test_c.c
> @@ -94,11 +94,13 @@ static void kasan_test_exit(struct kunit *test)
>  }
>
>  /**
> - * KUNIT_EXPECT_KASAN_FAIL - check that the executed expression produces=
 a
> - * KASAN report; causes a KUnit test failure otherwise.
> + * KUNIT_EXPECT_KASAN_RESULT - check that the executed expression
> + * causes a KUnit test failure when the result is different from @fail.

What I meant here was:

KUNIT_EXPECT_KASAN_RESULT - checks whether the executed expression
produces a KASAN report; causes a KUnit test failure when the result
is different from @fail.

>   *
>   * @test: Currently executing KUnit test.
> - * @expression: Expression that must produce a KASAN report.
> + * @expr: Expression to be tested.
> + * @expr_str: Expression to be tested encoded as a string.
> + * @fail: Whether expression should produce a KASAN report.
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
> + * In between KUNIT_EXPECT_KASAN_RESULT checks, test_status.report_found=
 is kept
>   * as false. This allows detecting KASAN reports that happen outside of =
the
>   * checks by asserting !test_status.report_found at the start of
> - * KUNIT_EXPECT_KASAN_FAIL and in kasan_test_exit.
> + * KUNIT_EXPECT_KASAN_RESULT and in kasan_test_exit.
>   */
> -#define KUNIT_EXPECT_KASAN_FAIL(test, expression) do {                 \
> +#define KUNIT_EXPECT_KASAN_RESULT(test, expr, expr_str, fail)          \
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
> +       if (READ_ONCE(test_status.report_found) !=3D fail) {             =
 \
> +               KUNIT_FAIL(test, KUNIT_SUBTEST_INDENT "KASAN failure"   \
> +                               "%sexpected in \"" expr_str             \
> +                                "\", but %soccurred",                  \
> +                               (fail ? " " : " not "),         \
> +                               (test_status.report_found ?             \
> +                                "" : "none "));                        \
>         }                                                               \
>         if (IS_ENABLED(CONFIG_KASAN_HW_TAGS) &&                         \
>             kasan_sync_fault_possible()) {                              \
> @@ -141,6 +147,34 @@ static void kasan_test_exit(struct kunit *test)
>         WRITE_ONCE(test_status.async_fault, false);                     \
>  } while (0)
>
> +/*
> + * KUNIT_EXPECT_KASAN_FAIL - check that the executed expression produces=
 a
> + * KASAN report; causes a KUnit test failure otherwise.
> + *
> + * @test: Currently executing KUnit test.
> + * @expr: Expression that must produce a KASAN report.
> + */
> +#define KUNIT_EXPECT_KASAN_FAIL(test, expr)                    \
> +       KUNIT_EXPECT_KASAN_RESULT(test, expr, #expr, true)
> +
> +/*
> + * KUNIT_EXPECT_KASAN_FAIL_READ - check that the executed expression
> + * produces a KASAN report when the write-only mode is not enabled;
> + * causes a KUnit test failure otherwise.
> + *
> + * Note: At the moment, this macro does not check whether the produced
> + * KASAN report is a report about a bad read access. It is only intended
> + * for checking the write-only KASAN mode functionality without failing
> + * KASAN tests.
> + *
> + * @test: Currently executing KUnit test.
> + * @expr: Expression that must only produce a KASAN report
> + *        when the write-only mode is not enabled.
> + */
> +#define KUNIT_EXPECT_KASAN_FAIL_READ(test, expr)                       \
> +       KUNIT_EXPECT_KASAN_RESULT(test, expr, #expr,                    \
> +                       !kasan_write_only_enabled())                    \
> +
>  #define KASAN_TEST_NEEDS_CONFIG_ON(test, config) do {                  \
>         if (!IS_ENABLED(config))                                        \
>                 kunit_skip((test), "Test requires " #config "=3Dy");     =
 \
> @@ -183,8 +217,8 @@ static void kmalloc_oob_right(struct kunit *test)
>         KUNIT_EXPECT_KASAN_FAIL(test, ptr[size + 5] =3D 'y');
>
>         /* Out-of-bounds access past the aligned kmalloc object. */
> -       KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] =3D
> -                                       ptr[size + KASAN_GRANULE_SIZE + 5=
]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ptr[0] =3D
> +                       ptr[size + KASAN_GRANULE_SIZE + 5]);
>
>         kfree(ptr);
>  }
> @@ -198,7 +232,7 @@ static void kmalloc_oob_left(struct kunit *test)
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>
>         OPTIMIZER_HIDE_VAR(ptr);
> -       KUNIT_EXPECT_KASAN_FAIL(test, *ptr =3D *(ptr - 1));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, *ptr =3D *(ptr - 1));
>         kfree(ptr);
>  }
>
> @@ -211,7 +245,7 @@ static void kmalloc_node_oob_right(struct kunit *test=
)
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>
>         OPTIMIZER_HIDE_VAR(ptr);
> -       KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] =3D ptr[size]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ptr[0] =3D ptr[size]);
>         kfree(ptr);
>  }
>
> @@ -291,7 +325,7 @@ static void kmalloc_large_uaf(struct kunit *test)
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>         kfree(ptr);
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[0]);
>  }
>
>  static void kmalloc_large_invalid_free(struct kunit *test)
> @@ -323,7 +357,7 @@ static void page_alloc_oob_right(struct kunit *test)
>         ptr =3D page_address(pages);
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] =3D ptr[size]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ptr[0] =3D ptr[size]);
>         free_pages((unsigned long)ptr, order);
>  }
>
> @@ -338,7 +372,7 @@ static void page_alloc_uaf(struct kunit *test)
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>         free_pages((unsigned long)ptr, order);
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[0]);
>  }
>
>  static void krealloc_more_oob_helper(struct kunit *test,
> @@ -458,7 +492,7 @@ static void krealloc_uaf(struct kunit *test)
>
>         KUNIT_EXPECT_KASAN_FAIL(test, ptr2 =3D krealloc(ptr1, size2, GFP_=
KERNEL));
>         KUNIT_ASSERT_NULL(test, ptr2);
> -       KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)ptr1);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, *(volatile char *)ptr1);
>  }
>
>  static void kmalloc_oob_16(struct kunit *test)
> @@ -501,7 +535,7 @@ static void kmalloc_uaf_16(struct kunit *test)
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr2);
>         kfree(ptr2);
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, *ptr1 =3D *ptr2);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, *ptr1 =3D *ptr2);
>         kfree(ptr1);
>  }
>
> @@ -640,8 +674,8 @@ static void kmalloc_memmove_invalid_size(struct kunit=
 *test)
>         memset((char *)ptr, 0, 64);
>         OPTIMIZER_HIDE_VAR(ptr);
>         OPTIMIZER_HIDE_VAR(invalid_size);
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> -               memmove((char *)ptr, (char *)ptr + 4, invalid_size));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test,
> +                       memmove((char *)ptr, (char *)ptr + 4, invalid_siz=
e));
>         kfree(ptr);
>  }
>
> @@ -654,7 +688,7 @@ static void kmalloc_uaf(struct kunit *test)
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>
>         kfree(ptr);
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[8]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[8]);
>  }
>
>  static void kmalloc_uaf_memset(struct kunit *test)
> @@ -701,7 +735,7 @@ static void kmalloc_uaf2(struct kunit *test)
>                 goto again;
>         }
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[40]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr1)[40]);
>         KUNIT_EXPECT_PTR_NE(test, ptr1, ptr2);
>
>         kfree(ptr2);
> @@ -727,19 +761,19 @@ static void kmalloc_uaf3(struct kunit *test)
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr2);
>         kfree(ptr2);
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[8]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr1)[8]);
>  }
>
>  static void kasan_atomics_helper(struct kunit *test, void *unsafe, void =
*safe)
>  {
>         int *i_unsafe =3D unsafe;
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, READ_ONCE(*i_unsafe));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, READ_ONCE(*i_unsafe));
>         KUNIT_EXPECT_KASAN_FAIL(test, WRITE_ONCE(*i_unsafe, 42));
> -       KUNIT_EXPECT_KASAN_FAIL(test, smp_load_acquire(i_unsafe));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, smp_load_acquire(i_unsafe));
>         KUNIT_EXPECT_KASAN_FAIL(test, smp_store_release(i_unsafe, 42));
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_read(unsafe));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, atomic_read(unsafe));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_set(unsafe, 42));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_add(42, unsafe));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_sub(42, unsafe));
> @@ -752,18 +786,31 @@ static void kasan_atomics_helper(struct kunit *test=
, void *unsafe, void *safe)
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_xchg(unsafe, 42));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_cmpxchg(unsafe, 21, 42));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_try_cmpxchg(unsafe, safe, 42=
));
> -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_try_cmpxchg(safe, unsafe, 42=
));
> +       /*
> +        * The result of the test below may vary due to garbage values of
> +        * unsafe in write-only mode.
> +        * Therefore, skip this test when KASAN is configured in write-on=
ly mode.
> +        */
> +       if (!kasan_write_only_enabled())
> +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_try_cmpxchg(safe, un=
safe, 42));
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
> +       /*
> +        * The result of the test below may vary due to garbage values of
> +        * unsafe in write-only mode.
> +        * Therefore, skip this test when KASAN is configured in write-on=
ly mode.
> +        */
> +       if (!kasan_write_only_enabled()) {
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
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_read(unsafe));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, atomic_long_read(unsafe));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_set(unsafe, 42));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_add(42, unsafe));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_sub(42, unsafe));
> @@ -776,16 +823,29 @@ static void kasan_atomics_helper(struct kunit *test=
, void *unsafe, void *safe)
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_xchg(unsafe, 42));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_cmpxchg(unsafe, 21, 42)=
);
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_try_cmpxchg(unsafe, saf=
e, 42));
> -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_try_cmpxchg(safe, unsaf=
e, 42));
> +       /*
> +        * The result of the test below may vary due to garbage values of
> +        * unsafe in write-only mode.
> +        * Therefore, skip this test when KASAN is configured in write-on=
ly mode.
> +        */
> +       if (!kasan_write_only_enabled())
> +               KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_try_cmpxchg(saf=
e, unsafe, 42));
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
> +       /*
> +        * The result of the test below may vary due to garbage values of
> +        * unsafe in write-only mode.
> +        * Therefore, skip this test when KASAN is configured in write-on=
ly mode.
> +        */
> +       if (!kasan_write_only_enabled()) {
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
> @@ -842,8 +902,8 @@ static void ksize_unpoisons_memory(struct kunit *test=
)
>         /* These must trigger a KASAN report. */
>         if (IS_ENABLED(CONFIG_KASAN_GENERIC))
>                 KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size=
]);
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size + 5]);
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size - =
1]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[size + =
5]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[real_si=
ze - 1]);
>
>         kfree(ptr);
>  }
> @@ -863,8 +923,8 @@ static void ksize_uaf(struct kunit *test)
>
>         OPTIMIZER_HIDE_VAR(ptr);
>         KUNIT_EXPECT_KASAN_FAIL(test, ksize(ptr));
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[0]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[size]);
>  }
>
>  /*
> @@ -899,9 +959,9 @@ static void rcu_uaf(struct kunit *test)
>         global_rcu_ptr =3D rcu_dereference_protected(
>                                 (struct kasan_rcu_info __rcu *)ptr, NULL)=
;
>
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> -               call_rcu(&global_rcu_ptr->rcu, rcu_uaf_reclaim);
> -               rcu_barrier());
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test,
> +                       call_rcu(&global_rcu_ptr->rcu, rcu_uaf_reclaim);
> +                       rcu_barrier());
>  }
>
>  static void workqueue_uaf_work(struct work_struct *work)
> @@ -924,8 +984,8 @@ static void workqueue_uaf(struct kunit *test)
>         queue_work(workqueue, work);
>         destroy_workqueue(workqueue);
>
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> -               ((volatile struct work_struct *)work)->data);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test,
> +                       ((volatile struct work_struct *)work)->data);
>  }
>
>  static void kfree_via_page(struct kunit *test)
> @@ -972,7 +1032,7 @@ static void kmem_cache_oob(struct kunit *test)
>                 return;
>         }
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, *p =3D p[size + OOB_TAG_OFF]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, *p =3D p[size + OOB_TAG_OFF]);
>
>         kmem_cache_free(cache, p);
>         kmem_cache_destroy(cache);
> @@ -1068,7 +1128,7 @@ static void kmem_cache_rcu_uaf(struct kunit *test)
>          */
>         rcu_barrier();
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, READ_ONCE(*p));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, READ_ONCE(*p));
>
>         kmem_cache_destroy(cache);
>  }
> @@ -1207,7 +1267,7 @@ static void mempool_oob_right_helper(struct kunit *=
test, mempool_t *pool, size_t
>                 KUNIT_EXPECT_KASAN_FAIL(test,
>                         ((volatile char *)&elem[size])[0]);
>         else
> -               KUNIT_EXPECT_KASAN_FAIL(test,
> +               KUNIT_EXPECT_KASAN_FAIL_READ(test,
>                         ((volatile char *)&elem[round_up(size, KASAN_GRAN=
ULE_SIZE)])[0]);
>
>         mempool_free(elem, pool);
> @@ -1273,7 +1333,7 @@ static void mempool_uaf_helper(struct kunit *test, =
mempool_t *pool, bool page)
>         mempool_free(elem, pool);
>
>         ptr =3D page ? page_address((struct page *)elem) : elem;
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[0]);
>  }
>
>  static void mempool_kmalloc_uaf(struct kunit *test)
> @@ -1532,7 +1592,7 @@ static void kasan_memchr(struct kunit *test)
>
>         OPTIMIZER_HIDE_VAR(ptr);
>         OPTIMIZER_HIDE_VAR(size);
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test,
>                 kasan_ptr_result =3D memchr(ptr, '1', size + 1));
>
>         kfree(ptr);
> @@ -1559,7 +1619,7 @@ static void kasan_memcmp(struct kunit *test)
>
>         OPTIMIZER_HIDE_VAR(ptr);
>         OPTIMIZER_HIDE_VAR(size);
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test,
>                 kasan_int_result =3D memcmp(ptr, arr, size+1));
>         kfree(ptr);
>  }
> @@ -1594,7 +1654,7 @@ static void kasan_strings(struct kunit *test)
>                         strscpy(ptr, src + 1, KASAN_GRANULE_SIZE));
>
>         /* strscpy should fail if the first byte is unreadable. */
> -       KUNIT_EXPECT_KASAN_FAIL(test, strscpy(ptr, src + KASAN_GRANULE_SI=
ZE,
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, strscpy(ptr, src + KASAN_GRANU=
LE_SIZE,
>                                               KASAN_GRANULE_SIZE));
>
>         kfree(src);
> @@ -1607,17 +1667,17 @@ static void kasan_strings(struct kunit *test)
>          * will likely point to zeroed byte.
>          */
>         ptr +=3D 16;
> -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_ptr_result =3D strchr(ptr, '1=
'));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_ptr_result =3D strchr(pt=
r, '1'));
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_ptr_result =3D strrchr(ptr, '=
1'));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_ptr_result =3D strrchr(p=
tr, '1'));
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =3D strcmp(ptr, "2=
"));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_int_result =3D strcmp(pt=
r, "2"));
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =3D strncmp(ptr, "=
2", 1));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_int_result =3D strncmp(p=
tr, "2", 1));
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =3D strlen(ptr));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_int_result =3D strlen(pt=
r));
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =3D strnlen(ptr, 1=
));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_int_result =3D strnlen(p=
tr, 1));
>  }
>
>  static void kasan_bitops_modify(struct kunit *test, int nr, void *addr)
> @@ -1636,12 +1696,18 @@ static void kasan_bitops_test_and_modify(struct k=
unit *test, int nr, void *addr)
>  {
>         KUNIT_EXPECT_KASAN_FAIL(test, test_and_set_bit(nr, addr));
>         KUNIT_EXPECT_KASAN_FAIL(test, __test_and_set_bit(nr, addr));
> -       KUNIT_EXPECT_KASAN_FAIL(test, test_and_set_bit_lock(nr, addr));
> +       /*
> +        * When KASAN is running in write-only mode,
> +        * a fault won't occur when the bit is set.
> +        * Therefore, skip the test_and_set_bit_lock test in write-only m=
ode.
> +        */
> +       if (!kasan_write_only_enabled())
> +               KUNIT_EXPECT_KASAN_FAIL(test, test_and_set_bit_lock(nr, a=
ddr));
>         KUNIT_EXPECT_KASAN_FAIL(test, test_and_clear_bit(nr, addr));
>         KUNIT_EXPECT_KASAN_FAIL(test, __test_and_clear_bit(nr, addr));
>         KUNIT_EXPECT_KASAN_FAIL(test, test_and_change_bit(nr, addr));
>         KUNIT_EXPECT_KASAN_FAIL(test, __test_and_change_bit(nr, addr));
> -       KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =3D test_bit(nr, a=
ddr));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_int_result =3D test_bit(=
nr, addr));
>         if (nr < 7)
>                 KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =3D
>                                 xor_unlock_is_negative_byte(1 << nr, addr=
));
> @@ -1765,7 +1831,7 @@ static void vmalloc_oob(struct kunit *test)
>                 KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)v_ptr)[si=
ze]);
>
>         /* An aligned access into the first out-of-bounds granule. */
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)v_ptr)[size + 5])=
;
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)v_ptr)[size =
+ 5]);
>
>         /* Check that in-bounds accesses to the physical page are valid. =
*/
>         page =3D vmalloc_to_page(v_ptr);
> @@ -2042,15 +2108,15 @@ static void copy_user_test_oob(struct kunit *test=
)
>
>         KUNIT_EXPECT_KASAN_FAIL(test,
>                 unused =3D copy_from_user(kmem, usermem, size + 1));
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test,
>                 unused =3D copy_to_user(usermem, kmem, size + 1));
>         KUNIT_EXPECT_KASAN_FAIL(test,
>                 unused =3D __copy_from_user(kmem, usermem, size + 1));
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test,
>                 unused =3D __copy_to_user(usermem, kmem, size + 1));
>         KUNIT_EXPECT_KASAN_FAIL(test,
>                 unused =3D __copy_from_user_inatomic(kmem, usermem, size =
+ 1));
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test,
>                 unused =3D __copy_to_user_inatomic(usermem, kmem, size + =
1));
>
>         /*
> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
>

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

