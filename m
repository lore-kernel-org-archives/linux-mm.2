Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB849CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 10:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14D0B8E000C; Tue, 16 Sep 2025 06:29:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FDAE8E0001; Tue, 16 Sep 2025 06:29:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2E128E000C; Tue, 16 Sep 2025 06:29:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE7598E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 06:29:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86F701608F9
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:29:03 +0000 (UTC)
X-FDA: 83894740566.13.7473915
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id B89D3100002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:29:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=FIuUf4+I;
	dmarc=pass (policy=reject) header.from=cloudflare.com;
	spf=pass (imf14.hostedemail.com: domain of ignat@cloudflare.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=ignat@cloudflare.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758018541; a=rsa-sha256;
	cv=none;
	b=jNX8dIdNlxBvclWicYIIr3c3WiXzE0sC5IB699t6Aq2rfL0P4DxniNxh2Cgcp1Q6wh+P1a
	/peO2DH3OrWLATYDz+lMbq1jwTtoSxztgegUEtn8KE++YioxfGdVI03g3c2fw70gOjI1fI
	cIn7Gtl2SMePxPMLEf3RRDRzb4K0oek=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=FIuUf4+I;
	dmarc=pass (policy=reject) header.from=cloudflare.com;
	spf=pass (imf14.hostedemail.com: domain of ignat@cloudflare.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=ignat@cloudflare.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758018541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dVtnxKhUzhBsXhVoc6XgCECsqL2+mal6aWmAQ944WSU=;
	b=qOBNBrI4zZYLHCjqMtuq7WXENfciS/S1JaGw5ujwQF+FwOnVfrAqCHvZn/EJtxTo0WYdNu
	Qik07HS1R+7yJq4ooAMbMCpstmErfVXhTHiZ5QY+IWSS2ZewyRq12L4EOtNQrWmq+2tjzS
	mzwtlBjpMGVb31Dq0q9Q1/EXDbQWhqk=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-82946485d12so208695085a.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1758018541; x=1758623341; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dVtnxKhUzhBsXhVoc6XgCECsqL2+mal6aWmAQ944WSU=;
        b=FIuUf4+IMV3m4ol18I9R5E4TXGz0E7+L2EWZCgD1lfUobJRMrUUAEkYadkCoaon6M0
         xMNHwDk4VhKz/g6GSpw9jtbtnmAN8+9wfkntMNLMGjfyzylGIhr9KHfhdTTA1Xs10XFA
         AdmcRUdmX373kcJ4s9KJKGkaE8JO4cQ5sjMtR+ZeXwEMzQhRVzI4UABlStrEATgwA30a
         NE7fLzJIk873XjHUROz1NEHPS30ZI+jb8YIxDTG5RLXqTVuGLuinJws7bkjXm0Kq/3b7
         S0gr7t6CWxMdrbWJY2ZRtvYFbZ715ku5YDp2oClcKvQ6tE/Ww7Ta2HNYcAwT9AH5iTLm
         XXTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758018541; x=1758623341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dVtnxKhUzhBsXhVoc6XgCECsqL2+mal6aWmAQ944WSU=;
        b=OETAKP/+YKJ7JfJdShB5x2R+I2ixwQcjnY+ZSaCjs6BkrAMba77y/vm+LwN2IsBDm8
         KBuJwERYtO4Sy3SA4qCZz7GiyKFULmc4yteZH9hq4YBKcWF8wrF0MgNt9djrvVI59cV2
         v+DkH3RUG3mjlW+rE17SZAkvcn27PZL1WfaqNK44MOixtgD1o6orw3hUqHiYjhWgrFll
         Q50sygo/ozr3ZnNPBOTaUc+M8wNWtsa23IgviwrNIY4WAqlQnnuRbncny6HJc2ySxDor
         WLD8wh6YI9oCV8mqNr6TqJ4vbsAQFh1aFTOsmx7bZXdjPy2Ufz3dh7Vu7g4ZjhA4vLcj
         gYVw==
X-Forwarded-Encrypted: i=1; AJvYcCVDGlrmRL6Wo1EXFa5vduDkbAUO/ZUfVrEbFmmBEK0gVlLmqyl/4Igpxl0jKCf9yES1psS9cw+pZg==@kvack.org
X-Gm-Message-State: AOJu0YxFPu66C2gpU9WGSDsg64jSjZOnhZ/BQYyP6RtDdcHoNFdaTGwc
	6jkhMCmdEz/kXFvUYZvc3UkUSuF+aBOLTXnBd6Ws8QBq8dEOAIcxvGJQsiY5tJZ9QEEyf4xXNml
	l0q016/QZgbLRSQVEHnnSBHkyxrir6E3il6+P5Xpx2A==
X-Gm-Gg: ASbGnct2xzInSyLmb4DY5871XXFxXSUWLVv8ZPJKNc2xfcnsDNmcer8w9+gxImaPoLG
	yoRKGps8yyHUQw/ux+Hehm8tEf75RrPHaLkAlkDVatm9gu+m9alg7d5+nI/teG9UM1l8IQ2tyvQ
	ArPcVo05MQYVVWSV6zIFnVM+LtCC1SV3KP+WgRUAR86RejVX39N0699S9DbY33RzPhf/fU0ik8F
	KM1Beo35LZxLEpgx9S0IUU=
X-Google-Smtp-Source: AGHT+IFxa/mHkO7l1jsYGXV11do5FbykxlkVIrkhepiY3N/e2eXzxLE7+I2R4McxIU568VBCzMXFRrIxTXk2KTMaFf8=
X-Received: by 2002:a05:620a:4107:b0:802:78a5:a86f with SMTP id
 af79cd13be357-824047c8dd0mr1779923485a.79.1758018540609; Tue, 16 Sep 2025
 03:29:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com> <20250916090109.91132-8-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250916090109.91132-8-ethan.w.s.graham@gmail.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Tue, 16 Sep 2025 11:28:47 +0100
X-Gm-Features: AS18NWCkhNpkebAoSzpi6YfP7wdFTOupUdzVBrFWuQqh8FgNjyJdBm5a2YlrxX8
Message-ID: <CALrw=nE9jYhHZnix8RV9UHApOZaF7otRLPHn3cmvOPaqQLzrnw@mail.gmail.com>
Subject: Re: [PATCH v1 07/10] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, glider@google.com, andreyknvl@gmail.com, 
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, elver@google.com, herbert@gondor.apana.org.au, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B89D3100002
X-Stat-Signature: w5rpjxtugpmbm69kfe1jn14gwichoese
X-Rspam-User: 
X-HE-Tag: 1758018541-290558
X-HE-Meta: U2FsdGVkX1/L7L0AXvFbkUwkwyUsZ6bDjHeUQ53JEtEt6w5tSWr8E0LLVNhKYFlfpWBwh/kCwVJJJtmbN3D+l8KpUxCIfWmQMrEJy82tmN+o77zDANjax86/eoqbCehYH5psCDG5ojvpgF34PISpgDAwrNA4h+JVd6VtcZMa61Z6/S3VltJeVHrxDHEo4RjsXNIfPOEHcoJ/573hToLSZUBtB+pDVE746UBeKiz3hExC6WtK7TO9ASX665FIlmkgKLVrqhF0vKh+YLBTYzFTV1s5ybf3a29G9v8bM+r9WD8AbcO1VwNBWYqoZc4/5xThJPgna+WvBcrts9i1vBCbTY1ZkSzUkPbs/pmoVSKNoGuZyizUBDWAC86NifFPQfL9MsNpKxENUj98epOSCf7mTaE2FpOLF/4/OsffgM4zcL5wBBJfjQ4kPIqcd4ISEvhyEj5CN5uWUO4PwVp8mJsnF8Fzk7XJ4G1hr2fKLqLfbowX3/wTttkr4+o1DpPjLfLA4DmWg5icEm9CBEon5LuaTSlazSVfFAKJWBC9q8Xl5eQQJTOszrK9HF9ndEyvm0cOoeEYfUeCmHxILVLgRFYikCO6Wnf9nB6pL6oJSMbZWLX1gZn/pe9lCE9zy+Ha0bnczsHQDUOHruR+zkbTKJm3BCW5uUCF5K/pC7eKXfmGdumx71DDTMikS5kS8vbQ950Jlfhxw8F8XV/NTq+d4zz9a/NDCII3dfxt6AXQiwYiZhRFTh8atLrpqq0F05cnlbB2D+XxGTb0vqmQJFWDQyd4cpI4hw0OwktCiVHIFa/N4dBlkEdAwVutYYZlrvc0Mzn8cyMpdP6u+eJpSo7VcAEuMi/p+dPb6+hFxEXEEEshI917gMthiJ2tm2CmHeaPy1tkYvfdPYIJI+YUaLDr4BwA0Phyjh6I4NyYPsJ8lpQ6d79D8ZISAgXy7Yor5tTHzN2UWTi/rRAx/PXz4jXVuMT
 T4yH6jHG
 dd5nc3N92YVu8F3+xJmuYx75/XOe64X0lqYh1WBbRR21kn8e9JLAJ/7eujU65TrXn3uSM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 10:01=E2=80=AFAM Ethan Graham
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

Reviewed-by: Ignat Korchagin <ignat@cloudflare.com>

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
> +}
> diff --git a/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c b/crypto/asy=
mmetric_keys/tests/rsa_helper_kfuzz.c
> new file mode 100644
> index 000000000000..bd29ed5e8c82
> --- /dev/null
> +++ b/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
> @@ -0,0 +1,38 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * RSA key extract helper KFuzzTest targets
> + *
> + * Copyright 2025 Google LLC
> + */
> +#include <linux/kfuzztest.h>
> +#include <crypto/internal/rsa.h>
> +
> +struct rsa_parse_pub_key_arg {
> +       const void *key;
> +       size_t key_len;
> +};
> +
> +FUZZ_TEST(test_rsa_parse_pub_key, struct rsa_parse_pub_key_arg)
> +{
> +       KFUZZTEST_EXPECT_NOT_NULL(rsa_parse_pub_key_arg, key);
> +       KFUZZTEST_ANNOTATE_ARRAY(rsa_parse_pub_key_arg, key);
> +       KFUZZTEST_ANNOTATE_LEN(rsa_parse_pub_key_arg, key_len, key);
> +
> +       struct rsa_key out;
> +       rsa_parse_pub_key(&out, arg->key, arg->key_len);
> +}
> +
> +struct rsa_parse_priv_key_arg {
> +       const void *key;
> +       size_t key_len;
> +};
> +
> +FUZZ_TEST(test_rsa_parse_priv_key, struct rsa_parse_priv_key_arg)
> +{
> +       KFUZZTEST_EXPECT_NOT_NULL(rsa_parse_priv_key_arg, key);
> +       KFUZZTEST_ANNOTATE_ARRAY(rsa_parse_priv_key_arg, key);
> +       KFUZZTEST_ANNOTATE_LEN(rsa_parse_priv_key_arg, key_len, key);
> +
> +       struct rsa_key out;
> +       rsa_parse_priv_key(&out, arg->key, arg->key_len);
> +}
> --
> 2.51.0.384.g4c02a37b29-goog
>

