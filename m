Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A820BCA0FF6
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 20:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F299F6B0029; Thu, 28 Aug 2025 16:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F02256B002B; Thu, 28 Aug 2025 16:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E172F6B002C; Thu, 28 Aug 2025 16:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D0CEA6B0029
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:14:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 776FF1A03B8
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:14:47 +0000 (UTC)
X-FDA: 83827269414.22.6558E0C
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6CACE120006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:14:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="D/U9HVaH";
	spf=pass (imf29.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756412085; a=rsa-sha256;
	cv=none;
	b=nKAbz0o4aOPcSyv3Lx1aN6VfoY/CZMS66mKZUuI+y2IKw2BOG60mcpfY06da47WyQM2KC9
	5D2VPZNk3xsOnCBC10p2nvCHFcy3doSUN3OEdLscitviKAxYp3qJDBTXOS74PjN4gyrwN1
	EPsVBknuqOe4nIhyT0AoRi4/8JdypqY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="D/U9HVaH";
	spf=pass (imf29.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756412085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vjm8Lxm33RDNh68uuSoVcCWhNBv32fciRIR1UYiBe9Q=;
	b=Nzs8SnKCn/YIb4f9cg86wNjwlTbMTLvsAwFI1rIORZRRj+143lUiUHGURkDHu+FLwM+O+8
	wt0hJwEC7VjKgtb8hvOzR9r7txbBUShsdb5fvovPMQtWDtd57slIN/vB6A32JpZsS02SJQ
	CnFZ25Us0cq40mU1mTcsPe0FS22Qwk0=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45a1b05ac1eso7412565e9.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756412084; x=1757016884; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vjm8Lxm33RDNh68uuSoVcCWhNBv32fciRIR1UYiBe9Q=;
        b=D/U9HVaHrnsUpNGpPgjUof+TdIxqjfQfJxubuce9kQD+l62F1gvOBhPn6gf6cWrhyx
         a4yFvOnBNdjqu78dFfGpxmtpczf9cGtx7unVGpPuuyeERQhGFChxId4uHm5gEbnGyoau
         Qd4z+TC0MmG1f0qbP5j8OMilWgBUJS2N9+3rWGdPGFoYPSZ8Qh/1NzPknzTObx5sXwXB
         zerwCmyl/U5U5104v2w9Dgo5/NXIpdSrdaMG6Iev/UgSdMgKEeyby5HODQxFgRX5YZF1
         Cyjcg4gSCuzGQ0i/HcJlO9TWBxeuJQ6Ran/xHipVcFCgmRj9/hMDX7ro0bgLLbNOjLk0
         pzlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756412084; x=1757016884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vjm8Lxm33RDNh68uuSoVcCWhNBv32fciRIR1UYiBe9Q=;
        b=A0b6py4gzdcVDl48cGGvU4uB7igwwv5/cwXwJrdfv8vIWkbfVHo/lmmUnmju3vjzpL
         I4eD2ZwA4EYLdLGpvcL4yG5q/GxDe2iZ8Qu0sqcP+T9yYpCaX0kSg3a/SLveAATyBr+e
         RLEEtQ0fHFlbi7qJzAZCdoSUb9L8Vwjk7F/5wtoLxEmrkp02kJDOoKhxUsphHjjzsU9Z
         bb4VbzT4V6HHUPM4INmBfAB+ERxDnTvBNFfGuJaO9+4YLc7T2zb4wi6ZcwXnqaiP3/kz
         5guLxfEJuP2qyDIWKxzJdV2N7SGp0xHyM7GtVFi6GLTPlleJFgm1Uju+UY1y7FzhPnWd
         PwvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgqwg4X9uLfJzgUxb0TDNEWO43wBHzSg00KEReBR7Ll1QvpyH7bvTjlUbylRSg+2hhinVt4LilMg==@kvack.org
X-Gm-Message-State: AOJu0YzGFPjvDzDuUwGvsvBC/TNO+5nc8pDE4Uxt8tXCjdrz5oiW5WVM
	gZqeaCauC71jDe3BgWmYR5Yq3gQF4Q5EYZ1XzJmnw1hiQihE8nZTDyGy+//JvH/PNR8QddlOIta
	qehVw17LV1MlDjLgINnSihcH9x84APtg=
X-Gm-Gg: ASbGnctr7df5uSWyeNvdg0UHV3qteHBDfUiFgy5YVwNdWJLEcUJTx26ZUb24FSycafS
	WmvNs24ch/DOSRziQ5L3nRQjMk05jj9fgrzt/Wdu6fnE5++TapVZLHI8d1aVEM+yEubWw3Xr2PD
	fXQ/lLnUHHitKtx91IfwaxpPBf5DZCGXyu6jJz30Timn7aUeiCAd2VvvbyGxiyaq9k5WQqwmR0p
	CWpqvXTxg==
X-Google-Smtp-Source: AGHT+IEViMjJi7LhgYuDFYxrHNZt1E8MDnRlIu8HZAZcdWK+ZZnHI/QAtnXh555hX1b3h0Kl3sckRY2bDQgyanTzWdc=
X-Received: by 2002:a5d:5f8d:0:b0:3c8:d236:26aa with SMTP id
 ffacd0b85a97d-3c8d2362b89mr14409036f8f.58.1756412083727; Thu, 28 Aug 2025
 13:14:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250820071243.1567338-1-yeoreum.yun@arm.com> <20250820071243.1567338-3-yeoreum.yun@arm.com>
In-Reply-To: <20250820071243.1567338-3-yeoreum.yun@arm.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 28 Aug 2025 22:14:32 +0200
X-Gm-Features: Ac12FXw4bc7WhGV15pNer-clBCZfyRwT3DSN0R6PuwxC-KzCPndNwcaBAIW1SFw
Message-ID: <CA+fCnZcAgW1iVKJ-MyzzdFoaDpRpA+CnTt2y22uZcUbSegc8CQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] kasan: apply write-only mode in kasan kunit testcases
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
X-Rspamd-Queue-Id: 6CACE120006
X-Stat-Signature: fmufuy7diw8g4k11hzp5w54fo6jpfsa9
X-Rspam-User: 
X-HE-Tag: 1756412085-103303
X-HE-Meta: U2FsdGVkX1//lk090MUlWmLEvaQVPyCX7CJeaxkqD3mtQLoTA4dJd7hYzrnydzVJHYgWtxF4Dki8WFIeBHTvSQY0u/3eA3qx3/rn+K72kv2xoRkCvq0s0e9ofA9uUJt1LwQEEmIFi1pvDJXuV4X4EogAeEDSctSscLRlubpo/tZEjnec0/RStoat9VBU+ojldUtE3RaSOpkjA0Mv3x0GNDhcjV003aJdn4H7zNeDKf8HkXmsukZlXho0lfwh3s7qUbqY2JKjolk6PJBxv+FCm7geQP0EU5DJBy+N57A20csgU17DpSO7nL7D87m8+MTm+TGVDEOENEBnFTGVP99uWH1BfcJ0ai/TNWqON0WpVg+h2pg4hXFOoRyZ/9HtKZpqpkoYvqcv3INhhb0/LDYGlE323xbiJe6H9HkK8awTZO0UNI0+8spixS5viGAjC4EOGgnuZx48iyY+kzrwAzv/EX2lqhSxHKKOpODwXeeC+Dza4NX1+eEIFr0R+O4diibNZ77DiB1+tgjt6NV8M5kXYvtvRxytKQ1dgVbE6qW1rC/nT3UD7FHNjYBK7Jy8/MRLXYS3xG8ombr3HbBoXMquhJFJ87yE5MGYm2iNGZnpSwYfhfcJjRA21pUvDX/zrvS4Zcw2cN9+MlNwbwLHSOuy49No/BzbIrre1cdhxPVEQId1XxFCwdH78RnyjdHF41DwomBFfA/XpilvJrjSpzxLKzhpqds2lY8iyI1kRMar2ZNnRKOJYpvzGEu9g9dNgc2hP4hC2f7bl17m2eRtG1I5yNoZ0/dVoJ6nuwJm6hlkrSeIAjukNwh+mwsMCcxEc7qp+LmZvmew0NDVokbStOM+OG/NEk9nmxBxqkgeEzmjCxBOOC3DmmGmUIEZlx3/Y1a3vk0H3vpwxxlEpXM4cc20vhIu201VMoo5sK3dE2Ryu4nVC+LY35+dFjEFTqvFuSV6nu+Gf3D9PMQjRsxWiph
 5W1BxCnM
 N/UWKswAGhf87F1kmMyKiqPdL/PrP7ekJXzyLlogcGKxOSKi/yFG0wqCp+XUf/tMU/dTebwrvoyf2fjEBvsrAvAuPDEkC04clZBEdYeGnYeU32bYGxm4CFpf/SUnVbUuDyTy+WqbO+TaOH5BJWsR6Ht2JlLkFWke28QGtzQNkhhGi3mMywaji52wZ9AGndZ0mGbEx43jlCXzcztv0VH515y9nZGSZmKiB5ac0IROugK6N9QgWK/fvTzSDz6ec/1xVGRBrKub2f2SO/Uk8gGt1fudeCEYTyjWNSE6C1UDgJpUkVEG8sEO068Qg57P/vL5f/ZVId9HrvGKY0kETXtdYiUSGdvVy2K3PF6jFBUsVmEa60ZS/86u1zQVNdRXhnHrXiIHWqE/m8MhtrmWXgnQ6gIq3JJ6NFgzhaHHNbl3pUVao8x9kB9DswrhTPndnBX7yqqdjrOMrtfsOaulA26rbZiTezU6eCDqV3P/wwP/u3VK59pE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 9:12=E2=80=AFAM Yeoreum Yun <yeoreum.yun@arm.com> w=
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
>  mm/kasan/kasan_test_c.c | 237 +++++++++++++++++++++++++++-------------
>  1 file changed, 162 insertions(+), 75 deletions(-)
>
> diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> index e0968acc03aa..cc0730aa18d1 100644
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

Let's name this macro "KUNIT_EXPECT_KASAN_RESULT" and the last argument "fa=
il".

> + * a KASAN report or not; a KUnit test failure when it's different from =
@produce.

..; causes a KUnit test failure when the result is different from @fail.

>   *
>   * @test: Currently executing KUnit test.
> - * @expression: Expression that must produce a KASAN report.
> + * @expr: Expression produce a KASAN report or not.

Expression to be tested.

> + * @expr_str: Expression string

Expression to be tested encoded as a string.

> + * @produce: expression should produce a KASAN report.

@fail: Whether expression should produce a KASAN report.

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

Let's keep the message as is for the case when a KASAN report is expected; =
i.e.:

KASAN failure expected in X, but none occurred

And for the case when KASAN report is not expected, let's do:

KASAN failure not expected in X, but occurred

>         }                                                               \
>         if (IS_ENABLED(CONFIG_KASAN_HW_TAGS) &&                         \
>             kasan_sync_fault_possible()) {                              \
> @@ -141,6 +147,29 @@ static void kasan_test_exit(struct kunit *test)
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

Expression that must produce a KASAN report.

> + */
> +#define KUNIT_EXPECT_KASAN_FAIL(test, expr)                    \
> +       _KUNIT_EXPECT_KASAN_TEMPLATE(test, expr, #expr, true)
> +
> +/*
> + * KUNIT_EXPECT_KASAN_FAIL_READ - check that the executed expression pro=
duces
> + * a KASAN report for read access.
> + * It causes a KUnit test failure. if KASAN report isn't produced for re=
ad access.
> + * For write access, it cause a KUnit test failure if a KASAN report is =
produced

KUNIT_EXPECT_KASAN_FAIL_READ - check that the executed expression
produces a KASAN report when the write-only mode is not enabled;
causes a KUnit test failure otherwise.

Note: At the moment, this macro does not check whether the produced
KASAN report is a report about a bad read access. It is only intended
for checking the write-only KASAN mode functionality without failing
KASAN tests.

> + *
> + * @test: Currently executing KUnit test.
> + * @expr: Expression doesn't produce a KASAN report.

Expression that must only produce a KASAN report when the write-only
mode is not enabled.

> + */
> +#define KUNIT_EXPECT_KASAN_FAIL_READ(test, expr)                       \
> +       _KUNIT_EXPECT_KASAN_TEMPLATE(test, expr, #expr,                 \
> +                       !kasan_write_only_enabled())                    \
> +
>  #define KASAN_TEST_NEEDS_CONFIG_ON(test, config) do {                  \
>         if (!IS_ENABLED(config))                                        \
>                 kunit_skip((test), "Test requires " #config "=3Dy");     =
 \
> @@ -183,8 +212,8 @@ static void kmalloc_oob_right(struct kunit *test)
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
> @@ -198,7 +227,8 @@ static void kmalloc_oob_left(struct kunit *test)
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>
>         OPTIMIZER_HIDE_VAR(ptr);
> -       KUNIT_EXPECT_KASAN_FAIL(test, *ptr =3D *(ptr - 1));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, *ptr =3D *(ptr - 1));
> +
>         kfree(ptr);
>  }
>
> @@ -211,7 +241,8 @@ static void kmalloc_node_oob_right(struct kunit *test=
)
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>
>         OPTIMIZER_HIDE_VAR(ptr);
> -       KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] =3D ptr[size]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ptr[0] =3D ptr[size]);
> +
>         kfree(ptr);
>  }
>
> @@ -291,7 +322,7 @@ static void kmalloc_large_uaf(struct kunit *test)
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>         kfree(ptr);
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[0]);
>  }
>
>  static void kmalloc_large_invalid_free(struct kunit *test)
> @@ -323,7 +354,8 @@ static void page_alloc_oob_right(struct kunit *test)
>         ptr =3D page_address(pages);
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, ptr[0] =3D ptr[size]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ptr[0] =3D ptr[size]);
> +
>         free_pages((unsigned long)ptr, order);
>  }
>
> @@ -338,7 +370,7 @@ static void page_alloc_uaf(struct kunit *test)
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>         free_pages((unsigned long)ptr, order);
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[0]);
>  }
>
>  static void krealloc_more_oob_helper(struct kunit *test,
> @@ -455,10 +487,10 @@ static void krealloc_uaf(struct kunit *test)
>         ptr1 =3D kmalloc(size1, GFP_KERNEL);
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr1);
>         kfree(ptr1);
> -

Keep this empty line.

>         KUNIT_EXPECT_KASAN_FAIL(test, ptr2 =3D krealloc(ptr1, size2, GFP_=
KERNEL));
>         KUNIT_ASSERT_NULL(test, ptr2);
> -       KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)ptr1);
> +
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, *(volatile char *)ptr1);
>  }
>
>  static void kmalloc_oob_16(struct kunit *test)
> @@ -501,7 +533,8 @@ static void kmalloc_uaf_16(struct kunit *test)
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr2);
>         kfree(ptr2);
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, *ptr1 =3D *ptr2);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, *ptr1 =3D *ptr2);
> +
>         kfree(ptr1);
>  }
>
> @@ -640,8 +673,10 @@ static void kmalloc_memmove_invalid_size(struct kuni=
t *test)
>         memset((char *)ptr, 0, 64);
>         OPTIMIZER_HIDE_VAR(ptr);
>         OPTIMIZER_HIDE_VAR(invalid_size);
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> -               memmove((char *)ptr, (char *)ptr + 4, invalid_size));
> +
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test,
> +                       memmove((char *)ptr, (char *)ptr + 4, invalid_siz=
e));
> +
>         kfree(ptr);
>  }
>
> @@ -654,7 +689,8 @@ static void kmalloc_uaf(struct kunit *test)
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>
>         kfree(ptr);
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[8]);
> +
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[8]);
>  }
>
>  static void kmalloc_uaf_memset(struct kunit *test)
> @@ -701,7 +737,8 @@ static void kmalloc_uaf2(struct kunit *test)
>                 goto again;
>         }
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr1)[40]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr1)[40]);
> +
>         KUNIT_EXPECT_PTR_NE(test, ptr1, ptr2);
>
>         kfree(ptr2);
> @@ -727,19 +764,19 @@ static void kmalloc_uaf3(struct kunit *test)
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
> +

No need for this empty line.

>         KUNIT_EXPECT_KASAN_FAIL(test, WRITE_ONCE(*i_unsafe, 42));
> -       KUNIT_EXPECT_KASAN_FAIL(test, smp_load_acquire(i_unsafe));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, smp_load_acquire(i_unsafe));
>         KUNIT_EXPECT_KASAN_FAIL(test, smp_store_release(i_unsafe, 42));
> -

Keep this empty line.

> -       KUNIT_EXPECT_KASAN_FAIL(test, atomic_read(unsafe));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, atomic_read(unsafe));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_set(unsafe, 42));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_add(42, unsafe));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_sub(42, unsafe));
> @@ -752,18 +789,35 @@ static void kasan_atomics_helper(struct kunit *test=
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

store-only =3D> the write-only

Here and below.

> +        */
> +       if (!kasan_write_only_enabled())
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
> +
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, atomic_long_read(unsafe));
> +
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_set(unsafe, 42));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_add(42, unsafe));
>         KUNIT_EXPECT_KASAN_FAIL(test, atomic_long_sub(42, unsafe));
> @@ -776,16 +830,32 @@ static void kasan_atomics_helper(struct kunit *test=
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
> +       if (!kasan_write_only_enabled())
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
> @@ -842,8 +912,9 @@ static void ksize_unpoisons_memory(struct kunit *test=
)
>         /* These must trigger a KASAN report. */
>         if (IS_ENABLED(CONFIG_KASAN_GENERIC))
>                 KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size=
]);
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size + 5]);
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size - =
1]);
> +

No need for this empty line - this shows that the comment above
applies to all of these checks.

> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[size + =
5]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[real_si=
ze - 1]);
>
>         kfree(ptr);
>  }
> @@ -863,8 +934,8 @@ static void ksize_uaf(struct kunit *test)
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
> @@ -886,6 +957,7 @@ static void rcu_uaf_reclaim(struct rcu_head *rp)
>                 container_of(rp, struct kasan_rcu_info, rcu);
>
>         kfree(fp);
> +

No need for this empty line.

>         ((volatile struct kasan_rcu_info *)fp)->i;
>  }
>
> @@ -899,9 +971,9 @@ static void rcu_uaf(struct kunit *test)
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
> @@ -924,8 +996,8 @@ static void workqueue_uaf(struct kunit *test)
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
> @@ -972,7 +1044,7 @@ static void kmem_cache_oob(struct kunit *test)
>                 return;
>         }
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, *p =3D p[size + OOB_TAG_OFF]);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, *p =3D p[size + OOB_TAG_OFF]);
>
>         kmem_cache_free(cache, p);
>         kmem_cache_destroy(cache);
> @@ -1068,7 +1140,7 @@ static void kmem_cache_rcu_uaf(struct kunit *test)
>          */
>         rcu_barrier();
>
> -       KUNIT_EXPECT_KASAN_FAIL(test, READ_ONCE(*p));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, READ_ONCE(*p));
>
>         kmem_cache_destroy(cache);
>  }
> @@ -1207,7 +1279,7 @@ static void mempool_oob_right_helper(struct kunit *=
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
> @@ -1273,7 +1345,8 @@ static void mempool_uaf_helper(struct kunit *test, =
mempool_t *pool, bool page)
>         mempool_free(elem, pool);
>
>         ptr =3D page ? page_address((struct page *)elem) : elem;
> -       KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[0]);
> +

No need for this empty line.

> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[0]);
>  }
>
>  static void mempool_kmalloc_uaf(struct kunit *test)
> @@ -1532,7 +1605,8 @@ static void kasan_memchr(struct kunit *test)
>
>         OPTIMIZER_HIDE_VAR(ptr);
>         OPTIMIZER_HIDE_VAR(size);
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> +
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test,
>                 kasan_ptr_result =3D memchr(ptr, '1', size + 1));
>
>         kfree(ptr);
> @@ -1559,8 +1633,10 @@ static void kasan_memcmp(struct kunit *test)
>
>         OPTIMIZER_HIDE_VAR(ptr);
>         OPTIMIZER_HIDE_VAR(size);
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> +
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test,
>                 kasan_int_result =3D memcmp(ptr, arr, size+1));
> +
>         kfree(ptr);
>  }
>
> @@ -1594,7 +1670,7 @@ static void kasan_strings(struct kunit *test)
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
> @@ -1607,17 +1683,13 @@ static void kasan_strings(struct kunit *test)
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
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_ptr_result =3D strchr(pt=
r, '1'));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_ptr_result =3D strrchr(p=
tr, '1'));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_int_result =3D strcmp(pt=
r, "2"));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_int_result =3D strncmp(p=
tr, "2", 1));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_int_result =3D strlen(pt=
r));
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_int_result =3D strnlen(p=
tr, 1));
>  }
>
>  static void kasan_bitops_modify(struct kunit *test, int nr, void *addr)
> @@ -1636,12 +1708,22 @@ static void kasan_bitops_test_and_modify(struct k=
unit *test, int nr, void *addr)
>  {
>         KUNIT_EXPECT_KASAN_FAIL(test, test_and_set_bit(nr, addr));
>         KUNIT_EXPECT_KASAN_FAIL(test, __test_and_set_bit(nr, addr));
> -       KUNIT_EXPECT_KASAN_FAIL(test, test_and_set_bit_lock(nr, addr));
> +
> +       /*
> +        * When KASAN is running in store-only mode,
> +        * a fault won't occur when the bit is set.
> +        * Therefore, skip the test_and_set_bit_lock test in store-only m=
ode.
> +        */
> +       if (!kasan_write_only_enabled())
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
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, kasan_int_result =3D test_bit(=
nr, addr));
> +
>         if (nr < 7)
>                 KUNIT_EXPECT_KASAN_FAIL(test, kasan_int_result =3D
>                                 xor_unlock_is_negative_byte(1 << nr, addr=
));
> @@ -1765,7 +1847,7 @@ static void vmalloc_oob(struct kunit *test)
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
> @@ -2042,15 +2124,20 @@ static void copy_user_test_oob(struct kunit *test=
)
>
>         KUNIT_EXPECT_KASAN_FAIL(test,
>                 unused =3D copy_from_user(kmem, usermem, size + 1));
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> +
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test,
>                 unused =3D copy_to_user(usermem, kmem, size + 1));
> +
>         KUNIT_EXPECT_KASAN_FAIL(test,
>                 unused =3D __copy_from_user(kmem, usermem, size + 1));
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> +
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test,
>                 unused =3D __copy_to_user(usermem, kmem, size + 1));
> +
>         KUNIT_EXPECT_KASAN_FAIL(test,
>                 unused =3D __copy_from_user_inatomic(kmem, usermem, size =
+ 1));
> -       KUNIT_EXPECT_KASAN_FAIL(test,
> +
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test,
>                 unused =3D __copy_to_user_inatomic(usermem, kmem, size + =
1));

I don't think there's need for the empty lines between the checks above.

>
>         /*


> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
>

