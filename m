Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03401CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60D048E0143; Thu, 18 Sep 2025 10:16:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF948E013A; Thu, 18 Sep 2025 10:16:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D4278E0143; Thu, 18 Sep 2025 10:16:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 39A878E013A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:16:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F07C6C0217
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:16:07 +0000 (UTC)
X-FDA: 83902570374.21.EB89F27
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id EFB051A0017
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:16:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AjxJ9B6x;
	spf=pass (imf19.hostedemail.com: domain of glider@google.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W1m9V0QnucGw1fYjnWnkHTlkfdmFSylGoU4nkl6jTtY=;
	b=7UIuVNz08UQymiBR5H7qyWYcEoeYMpx2YUhNKzI6ZEI7Bm3myZR1H2db8KAnOLlVtVp+sg
	WhtQB0cbZg1jIX4dnbVFkhI6Wzg6/uce0w5Isi2R6NXhLJYpkgkqV0wlYAGM0AavLB5y0V
	vd9PCZsnLv77xrgMdIdu6LVyTjEyMZA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204966; a=rsa-sha256;
	cv=none;
	b=PV3qWnuHVJ4qEN3wDDg1hs0SxrWtRV6/r1GHoU5szdAhJjNNxZ95veFAh7ky+YwyBoDJLB
	DXBblQRt90GoBWR5xsN8T58yokMYt6bVBEeTdFr7SrMtPAllGnYqJgjGirUwbVH8xdm8A2
	yUIN8LCATTe4PaEEZrWzA9+PJ8qD82o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AjxJ9B6x;
	spf=pass (imf19.hostedemail.com: domain of glider@google.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-7957e2f6ba8so4781596d6.3
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204965; x=1758809765; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W1m9V0QnucGw1fYjnWnkHTlkfdmFSylGoU4nkl6jTtY=;
        b=AjxJ9B6xLyI0HJIbiAnoUhVlPUHtmSMC0JNZtkf8ZXV9omiKpXjcmXr+H0SPEHkASS
         rCh/kWiX0wOCHgb6ySug+ACsTy7RqoMtQzt5+M+Np/nMS9Em9tOGJTKVtBQOR49rbsp4
         vfE7eeXbijNe0uYzTYQ40aqF7EvNEkiGSN4Wxw5s8VianO8El/uNMWHUSaHjErpcDBGZ
         dGvrI0YNUDaCSbW8j2mZAggi8rwwwqM2pXjbTCNFli4OZucGSe+d1/qHE1FW5ZmjEAmN
         wp4XphvKp1Yn/PV2cqIRQu7c92l0rygL1b3kWeMIzwGYCpi6n1yAnri3Vsu3zMXSwgY8
         fcXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204965; x=1758809765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W1m9V0QnucGw1fYjnWnkHTlkfdmFSylGoU4nkl6jTtY=;
        b=Os+PAbBbMbAbdklzgF2R5qipEbRTk5hsMJkIrKQzm/xUhxLLzR1EkozO4Sj4bsG+Lu
         yNRsBCNWBWeLrVMzw4sA9d92FzjkqO4g4d85sQK8KAq/oJhyhXcOyRFAl231WsMZW1Ob
         82jefzrbwpkH/lmmo+/ARKklQi/od80F/VuN1QyW8Ptdo24YhKsVD491YNzNt058bX2e
         H8/XNHfVSrS7Hk2Q1jBjt9BJ+utt1CxKCRkzoYbC+J5lFHUbyzHxN2oAvx76U2vpxVYx
         ozNxGsMQfXf36z8+SpS/qHuC0N4Cj4BgvH4lpkC3BmefrK2h/A5ZP0tW8koyPfLQJTkP
         DauA==
X-Forwarded-Encrypted: i=1; AJvYcCV6tF8REeEwqnfiVDMq48ZF0IEFOZVoYyMAhvc5LiHcoSGBYGQ15Fw1wbNTHUQmOAQlmDgVV8H4yQ==@kvack.org
X-Gm-Message-State: AOJu0YwJte3iJTEmXpAc2bKPEqKG8+t8DETjyomfygWmk3onED0sBUlB
	6VT2/BlqJ0BNByeQSr/kdmhhKlsiCD/YBkt18vOq8C1oNmWZjDdyPUisK2+I60byx5Ey7dTQbPF
	QmJExWR63blfoP5+11vhScK+/2Fr6Uliaz1YvopAf
X-Gm-Gg: ASbGncuoX7KeOTcGRiJsvlgGlUxU5CSa5KORoEgUq9NrSWnAgxEUYnREGAHofLviqO8
	ay/1qlZOgvXmQZc8dYlkaw45Fjpc8Avn64qtdFrPpfpI2ROrBwUxH3LBIya/7TioFokxPrGDh6V
	HgBP8zE4hNXvQ9Ejxl3bdPWUM9e1XoF3Lsv8OCDJ9+06Dl/q1hUABVhEVQ/UGZY/WQMSlzpWfUV
	AaaqtoonGoVJU4wqKdy05fCNYr/6bQECe1u5rHlvB9uDNVElVL123Gf6Sy6CVY=
X-Google-Smtp-Source: AGHT+IFBpnDsj/3XitirZWPzOjid3pk9f5ycO+u5s3pMsQEUT+8NOpONrRLGkmiWyeP3kqXiHfhufSRzIIkcKBIaTRI=
X-Received: by 2002:a05:6214:2aa5:b0:782:1086:f659 with SMTP id
 6a1803df08f44-78eccb0cae7mr65869736d6.26.1758204964157; Thu, 18 Sep 2025
 07:16:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com> <20250916090109.91132-8-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250916090109.91132-8-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 18 Sep 2025 16:15:27 +0200
X-Gm-Features: AS18NWDFBwLJ1l73cBf4HqMXnx0YeCt1p-LK845oN4Qc3Ee7lXGT_Tt4s1Okcjk
Message-ID: <CAG_fn=Xkig71cn1xCUP1t=OLAbk+YYLsec0HhciROuiTD6AELg@mail.gmail.com>
Subject: Re: [PATCH v1 07/10] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
To: Ethan Graham <ethan.w.s.graham@gmail.com>, ignat@cloudflare.com
Cc: ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, jack@suse.cz, jannh@google.com, 
	johannes@sipsolutions.net, kasan-dev@googlegroups.com, kees@kernel.org, 
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de, 
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: u6siwdd6psnaw3b8q7enn5p44ds6ea6c
X-Rspamd-Queue-Id: EFB051A0017
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758204965-907694
X-HE-Meta: U2FsdGVkX1+zPcYG1o/Hdvay9vek8iVLmEzjLIVBZST8hRz0122osePArVK1onhgJLGJ19rbLDNtcCis2ZmfeTHJTBnRUpI4M7Hrm0dkBkReRrGwBI4ZW2A+TPJTxc2IWryd2A/2AjkPU0tfWIfQh7epxjJUn+dZAy/t/jj17hghtHIj0LGvATvNM+POvew/jwxuxDQ9nsL1+bHgid1SybzdrHyGtGSPqUqm+kPpjFtal7AbvHuUQvapCroYFeWG5HenbZ+4qFYobK1dJWZbNlN/jtPvCOw22Hso+Fa6XOaAVYSfF0Z17inWv0kWVtsTfONa/atir+tryIhQ4D/UgsNK7sbS6NLYNugQR8WyMSF3umL2si3owKWc02n6r490EpAyK+MT0v42nyUys92vOtIRqZDmAQb/D7pDNgcSLBqTTJxuIXUr88NZcJnLxjGfhtTm/XoLO7Kls2QY6NynK09VFikAZ0zA9+2UfRDGigPa6sHNXADkwz6YBzgGZ9y8pMVN/oWthq4B9rt2NYECyKdBZVMdX7oLWxdik6S7MMwtf6hnZOiMNBXklv+jOH1s5sQzDWC8AQuKt9WRNI7Ga3pPT0cDGjcf/vfNEnXqS+61lb+Csd14kRLffAkpioR1droKyt6yvQvCrqVnAN8WH9hhJyUmm5w+OEmiNn5oDhzCOLHFNcWcCz7o82LT2DJEzC1n09ocbRD2BLPskLR4dlXYQx/8vmi43+abvoGgg9d8DN+9TVtJvkRocvrlfo0fkE10pU/zLnbVfvzpfxV6cIYve0Bwi3m63UBE5FTaOoqFg8ftgs/6DYC1/I0pEWBEVq2VwEjRZiJBnHKxg+iW+oKkqK/2D3GGbgvowYduu4yyf9ZGuVzSKqQvo57CyHc05U1rNmCUqSb07hOdadw2o93dq/gqFY2qB+0kpdWzz+4wJFAlPFpkbYUBRv3tixLWjLVJwXGhx+ClF02GTTS
 KAvlZCoc
 ui6/c3IEjgDSjIPg8QZaGZ53t/3nlp62XixkAl0Zu3IMQrIUWCr67wIKICUH9dbVsV8NxsX/IwgEXFrrEn+S4/GhL7amj9w4AQfiuj4bJndvbB88+V5+iST7Jcs0V9tjbTGsp562YUz7/9+sMhiJFD4X+ML5I0QImx3UrGxDasYEUuv8afBcujZpRUT7L+ly98+WNxKShOilbrZJZsZbFPsy4RKkHP/DCk8AkfM8UlbuQye22yMk4KezZOIiODpqOp1wFWzSRkfCv3e3CX5bcBnj+CA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 11:01=E2=80=AFAM Ethan Graham
<ethan.w.s.graham@gmail.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Add KFuzzTest targets for pkcs7_parse_message, rsa_parse_pub_key, and
> rsa_parse_priv_key to serve as real-world examples of how the framework
> is used.
>
> These functions are ideal candidates for KFuzzTest as they perform
> complex parsing of user-controlled data but are not directly exposed at
> the syscall boundary. This makes them difficult to exercise with
> traditional fuzzing tools and showcases the primary strength of the
> KFuzzTest framework: providing an interface to fuzz internal functions.
>
> To validate the effectiveness of the framework on these new targets, we
> injected two artificial bugs and let syzkaller fuzz the targets in an
> attempt to catch them.
>
> The first of these was calling the asn1 decoder with an incorrect input
> from pkcs7_parse_message, like so:
>
> - ret =3D asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen);
> + ret =3D asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen + 1);
>
> The second was bug deeper inside of asn1_ber_decoder itself, like so:
>
> - for (len =3D 0; n > 0; n--)
> + for (len =3D 0; n >=3D 0; n--)
>
> syzkaller was able to trigger these bugs, and the associated KASAN
> slab-out-of-bounds reports, within seconds.
>
> The targets are defined within /lib/tests, alongside existing KUnit
> tests.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
>
> ---
> v3:
> - Change the fuzz target build to depend on CONFIG_KFUZZTEST=3Dy,
>   eliminating the need for a separate config option for each individual
>   file as suggested by Ignat Korchagin.
> - Remove KFUZZTEST_EXPECT_LE on the length of the `key` field inside of
>   the fuzz targets. A maximum length is now set inside of the core input
>   parsing logic.
> v2:
> - Move KFuzzTest targets outside of the source files into dedicated
>   _kfuzz.c files under /crypto/asymmetric_keys/tests/ as suggested by
>   Ignat Korchagin and Eric Biggers.
> ---
> ---
>  crypto/asymmetric_keys/Makefile               |  2 +
>  crypto/asymmetric_keys/tests/Makefile         |  2 +
>  crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    | 22 +++++++++++
>  .../asymmetric_keys/tests/rsa_helper_kfuzz.c  | 38 +++++++++++++++++++
>  4 files changed, 64 insertions(+)
>  create mode 100644 crypto/asymmetric_keys/tests/Makefile
>  create mode 100644 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
>  create mode 100644 crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
>
> diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Mak=
efile
> index bc65d3b98dcb..77b825aee6b2 100644
> --- a/crypto/asymmetric_keys/Makefile
> +++ b/crypto/asymmetric_keys/Makefile
> @@ -67,6 +67,8 @@ obj-$(CONFIG_PKCS7_TEST_KEY) +=3D pkcs7_test_key.o
>  pkcs7_test_key-y :=3D \
>         pkcs7_key_type.o
>
> +obj-y +=3D tests/
> +
>  #
>  # Signed PE binary-wrapped key handling
>  #
> diff --git a/crypto/asymmetric_keys/tests/Makefile b/crypto/asymmetric_ke=
ys/tests/Makefile
> new file mode 100644
> index 000000000000..4ffe0bbe9530
> --- /dev/null
> +++ b/crypto/asymmetric_keys/tests/Makefile
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_KFUZZTEST) +=3D pkcs7_kfuzz.o
> +obj-$(CONFIG_KFUZZTEST) +=3D rsa_helper_kfuzz.o
> diff --git a/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c b/crypto/asymmetr=
ic_keys/tests/pkcs7_kfuzz.c
> new file mode 100644
> index 000000000000..37e02ba517d8
> --- /dev/null
> +++ b/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
> @@ -0,0 +1,22 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * PKCS#7 parser KFuzzTest target
> + *
> + * Copyright 2025 Google LLC
> + */
> +#include <crypto/pkcs7.h>
> +#include <linux/kfuzztest.h>
> +
> +struct pkcs7_parse_message_arg {
> +       const void *data;
> +       size_t datalen;
> +};
> +
> +FUZZ_TEST(test_pkcs7_parse_message, struct pkcs7_parse_message_arg)
> +{
> +       KFUZZTEST_EXPECT_NOT_NULL(pkcs7_parse_message_arg, data);
> +       KFUZZTEST_ANNOTATE_ARRAY(pkcs7_parse_message_arg, data);
> +       KFUZZTEST_ANNOTATE_LEN(pkcs7_parse_message_arg, datalen, data);
> +
> +       pkcs7_parse_message(arg->data, arg->datalen);

As far as I understand, this function creates an allocation, so the
fuzz test will need to free it using pkcs7_free_message() to avoid
leaking memory.
What do you think, Ignat?


> +       struct rsa_key out;
> +       rsa_parse_pub_key(&out, arg->key, arg->key_len);
> +}

Do we need to deallocate anything here?

