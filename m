Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F722D3CCA7
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 03:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B95E26B0089; Wed, 14 Jan 2026 22:56:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3FDE6B008A; Wed, 14 Jan 2026 22:56:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4FF26B008C; Wed, 14 Jan 2026 22:56:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 96CA76B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:56:34 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 24F031A01CF
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:56:34 +0000 (UTC)
X-FDA: 84332836308.12.8BA339F
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4043F8000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:56:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d3em8QyP;
	spf=pass (imf30.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768449392; a=rsa-sha256;
	cv=none;
	b=zYc/24OxecpwunxfciMhv5seXw0My16nYkIpTaJwM46y+y2aqTrlWc28penfNQNSRn2ds8
	3eQEsX3m71ir4REIxA881W51fJQZnCz7iO1BMWeDC1Uzr4+GuFX8ef81pddHN8Xpc1Pjmf
	Ftcn3HB4SAwjjxbWqEOx/hkfA2fd620=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d3em8QyP;
	spf=pass (imf30.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768449392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6wDChulrCCyYHOj2zKt8skhqhOtaxdzyPo+s0kBuBo0=;
	b=NhbxOAqcA7OsEcwI58gi7AXweig/Cr55ejsCjqP3R4QHoH1EYgP16aLEFJYxiJ7mGn1voM
	u/WAKp7KMWXq+Q2V317t021zjKES3/ou1XQSxGMSu5lPXG79T0dOvV4iFQKiFxx3xXGvoW
	Ye7KhY9qseDbWek6TWelIDQK2bW8b/w=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47ee07570deso3198225e9.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768449391; x=1769054191; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6wDChulrCCyYHOj2zKt8skhqhOtaxdzyPo+s0kBuBo0=;
        b=d3em8QyPiN7/EYTRiExmwZmgm1ciNaG8lwh1TFRdu9vHVqlaCkbT1QERX+klXezBGp
         5Vc+XLA023kNTGkHCUkF8MoShoXmQ7DjrNZ/bb71DUDMxW9b1lcCRtIEeV4j9/CSQ4Na
         qzk8gTi1H7+u7M2AOEflTuGp4rWn8kHXt3m9RnFegKmvTAy2md0C8iYtIBXdWKx+9shP
         DkKD0AW0R5CvJJUQfDU8PpVaCJ8asjuHFwSQTtzSujsjtmgzySTbk4QSIXZzYVHtyy5V
         MJ1FsLK2hKmNZKm1Dbiag+audKhxMKcD+fktPtf4Po//b0X2bYMGFvqV+1UiuVRry8oj
         B/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768449391; x=1769054191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6wDChulrCCyYHOj2zKt8skhqhOtaxdzyPo+s0kBuBo0=;
        b=PoHozC4re2QhZ5t1lFm4ic8qk6q6x2Z0zqBc0QTzGTQC7Pfed+3k5SGxOdHZyQwSrU
         +xtOjhPUicdWHlUjByknnjn1UJiSfJlQohNWID7ZxEYgWn6EEPQIbCMyA6kOi/jZm3NV
         X6qAdi/D/3PUd4C545lq5NcuTfFl8kX62Ulxgx6SughxzrGhD0ltQy5aUTHClYZafvX5
         WCEp4Rgr6IyIoYHUTxQLKk8wE466uSEAm61Z+ODbzAjPL3tWix4weD6szYXMczXZzGaA
         GsS7Saa+cv3mctm20WjTDizcR0klhO5ZiAdkzcxfcgNegkinJmrvQP3yx/i4QGxzayTJ
         BFvg==
X-Forwarded-Encrypted: i=1; AJvYcCU2OCvygeCT4rxRekmENweysKRStj7JE2hA98gUkBBqC2Q/OxWYe+H+v7G0TYFJtVY66ICigPMjzw==@kvack.org
X-Gm-Message-State: AOJu0YzEN6d/dWycfnW2RFHn06hwyBV9fpGzCQ4lw/6LcjX3L3ssah4y
	KYIi/jWynxDftDZxQpVw0nHh4zXFA7zCTLMVI5aK/XMSP7/V5LjyzRZyuT56ceO+aATEgVHPerX
	DRm+rGAgxZJeYIZfNI28bZZhtEk2VGjI=
X-Gm-Gg: AY/fxX68tyqgZ9RguLzt54Dy7iW/HGbacTCsjYF1jHpSE2MVDaMSAKeP9A75PTm1FUE
	1Hykrp4z1sA15a4fATlK/3v7y5VMDEkuDYjkm4icrfO6NhRkFJ+k69fSwjs2jZqpHZ6UfpDTYfH
	x9Cpfk6fmeaMLPnpJkWX2/iGGXiJ3UqzG/YU8XuDhKKYCBdtlxt5Zfnc6h55FDV8AP3uHnAxu3X
	M1ZOYjUrHf05qkWAmVDKe/CBARPem6QAtIXor3Ki2Gyv2j9x2W1tHw1NKqc36uWSDVIxWZsJ2A/
	bh50G+04vOKuxJS0CYMjgJ2Dzne9uA==
X-Received: by 2002:a05:600c:3f12:b0:47e:e20e:bbb7 with SMTP id
 5b1f17b1804b1-47ee3371b87mr56339005e9.25.1768449390456; Wed, 14 Jan 2026
 19:56:30 -0800 (PST)
MIME-Version: 1.0
References: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com>
 <20260113191516.31015-1-ryabinin.a.a@gmail.com> <20260113191516.31015-2-ryabinin.a.a@gmail.com>
In-Reply-To: <20260113191516.31015-2-ryabinin.a.a@gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 15 Jan 2026 04:56:18 +0100
X-Gm-Features: AZwV_Qi3K6USsjyPImvxh3Fek-pWdiQdbQKJ5dGAgy4-AqQ7tvitC_QRJhvnXmc
Message-ID: <CA+fCnZeHdUiQ-k=Cy4bY-DKa7pFow6GfkTsCa2rsYTJNSXYGhw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/kasan/kunit: extend vmalloc OOB tests to cover vrealloc()
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>, 
	Maciej Wieczor-Retman <m.wieczorretman@pm.me>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	kasan-dev@googlegroups.com, Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4043F8000B
X-Stat-Signature: jsxd8bn8q5muk97p5hy7ffnscjk31xnw
X-Rspam-User: 
X-HE-Tag: 1768449392-496085
X-HE-Meta: U2FsdGVkX1/A4KqTS0GCJhtbFsZuylEsvy0wDIJndZciTlFtF+x9M902I5l1xcE7ZN6Vk7Ccu6PlE+YPwH0voCWfObBK/astRIikpHm0jhp7jMHWkBqCNXDt5az+IBKjdSTVJix3vetuTesjyXDG6DtpJKkR8NEr121auto/AUxRD6MVfNEpjPQiH7pCKI8Zpp7YaTeYUxJVeM7GLUP3n3hZMt1N3FMrVcewa3DqbLxw2lYQ9UmQU+mxF/s/82WQRms1USoQgQIoklLkc2/E0vk6q0UhhFK/sKRxAYlIH6C2eL+3wVqSCEsK8HEsPnaQOobOkrddc3hPzcQiEmM7+3gCW/O3K+HLV8O6LVxWxNhIAZ1O5UtWYJf7vn2leeYdW9cJlNwZcc6xdkuaVXMgBuTYeudTAj/YpAMtF1SPi5eXVGUv5whmUQXhEdrlEsrN2HRW72s8XHPIuKZnmIDG3L7e2IgYkWcLyFu8qJuRHV/IDpb0+OxOnzEhPsTaj0w+z5JEHNuXfGasZo7irgq4f7XkIGvI9fuWFRcOMQRDddSU6D/PDEvLJm9iaxpi3Fu/fy1q93fWP+CU4hbMerBvDCmk3yS8i9go8FkG/iqubLLbMCQY8THrMMzIA3/XrARhzAW5hzoQCugr/sKztJKkOpCqdq/qGDRwTvPyRzqYvYNhehQx792lDlev/lH64XYp0Yic5qeXF07VxrQtsPlmmx4oFJ5oQ+c447qyqll2veryDLtajnbUGSa/dIKxT8Hz0LXEMj+FKgdIu4R/FyCkNssrBhd3zuSBfqhZ5NOKmPJTABSgGBI1GRdjLA/uzgbgcQ32ltKPdo62E7xfSWZUzGK3LXIi2Wc8oTPTeByptcYQzyFk6xhd4e/hDAvNe6Y/qg+81Jn3QR299wPkjkFEfrhBndwyjT+wXseJVEi1yhuZjRxl352k/EzLH1pnYLiN3QhBVa2F0NxxtQAdi3G
 5pyLwJGR
 +11+ZEfXeiMSrpm2pTEk5WgbVbh0yOwz650WAnyIMrjd0JMH+IeRlo8YdicpbrBj3t3k+RFnL+JZIlrYMUqSH0e6optuUQXeFiDXU2PbqQWkV+GKp2kC5G72/FBhYbbmyF0qayo6yiWyaMRL3K9bwN3p+g9GAoZbTz1NLqORHjJ13XHxKn3dstc2KYB2VS/7r2z+glIJqf262wwaxQkO5mT8e2GL+/bEjwuH/TbOS7lmduovrKDv3+GXy6N2HskKTh2GH5z9j+7KG0jYYZL7CTBZ1397BewuAtuIgFBhjjvYNrbmp/EqibPYkqamQi1Xydp5wSCmjtoweUMETkzv66vcLRwJMwNKXupWsnMaA0XpVqYscY++oo85dnm3yHF1BO83QRYZcKLo/ZRg4ysl6duhKCFJFTX775Y6MgVSVfvCkZATI25tgBAfjZuNy312779b7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 8:16=E2=80=AFPM Andrey Ryabinin <ryabinin.a.a@gmail=
.com> wrote:
>
> Extend the vmalloc_oob() test to validate OOB detection after
> resizing vmalloc allocations with vrealloc().
>
> The test now verifies that KASAN correctly poisons and unpoisons vmalloc
> memory when allocations are shrunk and expanded, ensuring OOB accesses
> are reliably detected after each resize.
>
> Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> ---
>  mm/kasan/kasan_test_c.c | 50 ++++++++++++++++++++++++++++-------------
>  1 file changed, 35 insertions(+), 15 deletions(-)
>
> diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> index 2cafca31b092..cc8fc479e13a 100644
> --- a/mm/kasan/kasan_test_c.c
> +++ b/mm/kasan/kasan_test_c.c
> @@ -1840,6 +1840,29 @@ static void vmalloc_helpers_tags(struct kunit *tes=
t)
>         vfree(ptr);
>  }
>
> +static void vmalloc_oob_helper(struct kunit *test, char *v_ptr, size_t s=
ize)
> +{
> +       /*
> +        * We have to be careful not to hit the guard page in vmalloc tes=
ts.
> +        * The MMU will catch that and crash us.
> +        */
> +
> +       /* Make sure in-bounds accesses are valid. */
> +       v_ptr[0] =3D 0;
> +       v_ptr[size - 1] =3D 0;
> +
> +       /*
> +        * An unaligned access past the requested vmalloc size.
> +        * Only generic KASAN can precisely detect these.
> +        */
> +       if (IS_ENABLED(CONFIG_KASAN_GENERIC))
> +               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)v_ptr)[si=
ze]);
> +
> +       /* An aligned access into the first out-of-bounds granule. */
> +       size =3D round_up(size, KASAN_GRANULE_SIZE);
> +       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)v_ptr)[size]=
);
> +}
> +
>  static void vmalloc_oob(struct kunit *test)
>  {
>         char *v_ptr, *p_ptr;
> @@ -1856,24 +1879,21 @@ static void vmalloc_oob(struct kunit *test)
>
>         OPTIMIZER_HIDE_VAR(v_ptr);
>
> -       /*
> -        * We have to be careful not to hit the guard page in vmalloc tes=
ts.
> -        * The MMU will catch that and crash us.
> -        */
> +       vmalloc_oob_helper(test, v_ptr, size);
>
> -       /* Make sure in-bounds accesses are valid. */
> -       v_ptr[0] =3D 0;
> -       v_ptr[size - 1] =3D 0;
> +       size--;

Could do size -=3D KASAN_GRANULE_SIZE + 1: I think this would allow to
also check whole-granule poisoning/unpoisoning logic for tag-based
modes.

> +       v_ptr =3D vrealloc(v_ptr, size, GFP_KERNEL);
> +       KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
>
> -       /*
> -        * An unaligned access past the requested vmalloc size.
> -        * Only generic KASAN can precisely detect these.
> -        */
> -       if (IS_ENABLED(CONFIG_KASAN_GENERIC))
> -               KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)v_ptr)[si=
ze]);
> +       OPTIMIZER_HIDE_VAR(v_ptr);
>
> -       /* An aligned access into the first out-of-bounds granule. */
> -       KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)v_ptr)[size =
+ 5]);
> +       vmalloc_oob_helper(test, v_ptr, size);
> +
> +       size +=3D 2;

And then e.g. size +=3D 2 * KASAN_GRANULE_SIZE + 2 here.

> +       v_ptr =3D vrealloc(v_ptr, size, GFP_KERNEL);
> +       KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
> +
> +       vmalloc_oob_helper(test, v_ptr, size);
>
>         /* Check that in-bounds accesses to the physical page are valid. =
*/
>         page =3D vmalloc_to_page(v_ptr);
> --
> 2.52.0
>

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

