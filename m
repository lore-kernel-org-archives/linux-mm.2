Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D388CCA100C
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 08:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 362418E0005; Wed,  3 Sep 2025 04:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 339EF8E0001; Wed,  3 Sep 2025 04:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24F848E0005; Wed,  3 Sep 2025 04:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 118EB8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:58:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9E8C813B1E2
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:58:37 +0000 (UTC)
X-FDA: 83847338274.30.A105270
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9775A1C0004
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:58:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=HAeCr7rU;
	spf=pass (imf21.hostedemail.com: domain of ignat@cloudflare.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=ignat@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756889915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7DZbr5IPE7KPqwr8CmuJ7G0mqK+7ozrUki3YjXg8lg=;
	b=C01xcYqTtka1nfTVpkFKJCYfZQw7atgjEgLaOImDuGSStt4U2hHKW22YhS5CvXWo2elnz2
	m7zC6YjY7fT81A2NmgSmX+JQmTiyD1DmbaRvUttTADEu0psS2z3oECL4rPBwRQ/+zpM/YD
	W3zHxONC4dNozEPGX1AePeTZmF7XoD4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756889915; a=rsa-sha256;
	cv=none;
	b=XfNs0b5r2Dl8IKMxkYMlBwk8Jy67453q7UkBphHomyWaR1eKeP63G4B38ChGz6eJ4+25ea
	W4S8fDm7YoDzMzjvOZPBBlLwm2eJ06PPiQCa37iznQJ8Kv2LwSt5gROwSYgwMViuFUBMqa
	sc7NMjYMjWkD4EMaWN0SBvDk6PDtv8M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=HAeCr7rU;
	spf=pass (imf21.hostedemail.com: domain of ignat@cloudflare.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=ignat@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-336b5c44a5bso5913441fa.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 01:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1756889914; x=1757494714; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o7DZbr5IPE7KPqwr8CmuJ7G0mqK+7ozrUki3YjXg8lg=;
        b=HAeCr7rUl9znHI9tejrGzUn1NEHeUc9Ebqfwmr+ene1yLWx8/T7239NlUBg1leCe2z
         zAp2jbR56C2VUeTBNLQqXZ8tl2FNJjQSijFagJPUPeljf2Txy+mFSSy2bayfI+iiEfk1
         C9bWQVJnjZ7rbXxs/6JfUFzLYXaxTJ+fqTxhqXZL+eAYBSjzpgY4WQWwfPuxDuxVibb8
         6OVr2KCdo+7JEMJI6PsCt/IBxB3b5f+oU1xAn+wQB3YTyWFU++rKd53iJV/Eys6/9im6
         /yRdx4AyiFrjQ8omSjJUqsQtwGyMybOEBgs+el5CJJ9QaNvkC7yTkv7yct0zHpZezxPt
         8zDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756889914; x=1757494714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o7DZbr5IPE7KPqwr8CmuJ7G0mqK+7ozrUki3YjXg8lg=;
        b=Z/GeHGeO+sjBIZysFsrvEL09eXYMhA01saPMtOO2xMl0ab57BcCFCCs9v7ove+aHO8
         3P5wDdGVaX4aDR3l8hIofuKGh7MrSvm26VXhLBPzleMjalyNbCl1lYnJaF7/uzbt8/az
         fDrGWXJBdloLStLCIylKUzxTxJ5fAnBaon6wlg6B3P/jPYUigjamh/DKOPjnERqlcvWZ
         zqV9kZpdiAUVXsJp/i2VFSU0NWj/OUlVl5zL4Qg/uMn8Fx3tg+HxjnPL7attI8fzpvzo
         +uO+Lg8BfX3l/Ds/ZfP80NDWr0NbuGwwZ0aKOhm9o0h95ZUNo81/8CNgKf8+eCzDELhc
         V0sw==
X-Forwarded-Encrypted: i=1; AJvYcCUQjPAUQfmnHXqtU0u03L58snEdkcnMaakAhD5jrpjgzxGUboxUaET1+t+HjouBCWktof8ui1HsMQ==@kvack.org
X-Gm-Message-State: AOJu0YwvwwTnOlWNHukFmTJ/LpGuqJ/n5Q3hv9VCNP7a4C04+l6MsdOi
	Y9B68JnOYiD80Z87uI0kQA5i+AvQpc0j/Jl/Cpdj9Mbk80KJg9JwOZpyc1DMTyJS08B9s2Gipx1
	L5NGnbbNCXjyQKmtwqWFYVLrBPwAokJ7dlu3aWE+3rA==
X-Gm-Gg: ASbGncvFGTn5xoPGn6ckXyl8XPQ+KaBNzs5kQwQ2IJWK4krAn7kMIbaQlqWrt0rLeYD
	Whg5HaXL4F9PTO7GlrhlLm2/Ol5Wd9IssWPMFcVwucwiyvqiorfr/q2OFlR6N4AdUfchXVH8xgA
	h7Zm+fYMlTa5yQutxvB/Re8BYQYKMnJBE+6Pokn0UgDGp0LxOCXJg23y0xr34xOX0b1f5B0+bo+
	O79c4rTzITHcR0GSMzr3MMxNikQKaou8yIF
X-Google-Smtp-Source: AGHT+IFWZ1KRHLT58ws0GLUyYgsxqndwv00B/CVuSizWtD5TQIXhe4G2nzXHLgGunu2r8TYG1KYxHIJpaIS7aNOjkHw=
X-Received: by 2002:a05:651c:410c:b0:337:f40b:ceff with SMTP id
 38308e7fff4ca-337f40bd6b0mr10888081fa.0.1756889913537; Wed, 03 Sep 2025
 01:58:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com> <20250901164212.460229-8-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250901164212.460229-8-ethan.w.s.graham@gmail.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Wed, 3 Sep 2025 09:58:22 +0100
X-Gm-Features: Ac12FXzBn0vfVPWXT-oRg7YFxfn5ZjyJ_zA4MQI9Ke7h9u6mEjL9U6otTFUfOcM
Message-ID: <CALrw=nGkk01xXG7S68FggsWQXygTXnXGz8AvseQuRE9K-OE0uA@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 7/7] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, glider@google.com, andreyknvl@gmail.com, 
	brendan.higgins@linux.dev, davidgow@google.com, dvyukov@google.com, 
	jannh@google.com, elver@google.com, rmoar@google.com, shuah@kernel.org, 
	tarasmadan@google.com, kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9775A1C0004
X-Stat-Signature: iwbot4sa3refxppzo33mfb75epzsdi91
X-Rspam-User: 
X-HE-Tag: 1756889915-465628
X-HE-Meta: U2FsdGVkX1+28+Bo+B7WxRWL+E514gM8SDTDyV3ioKX1SyhVT6WyMEi+ueN2qGoJk5XNVDgLHxdV7SX46tDyMLuszKhPOYu7T5bRSP3iSNnfIl053R7ov6ype5TCqgtVuhfrMecjy52yaXxcIYNez5W80shmsTojesvFagRA38x71/SvKuXsAyYG1snMW+3KlbLBCA3Q2NzO+lcmzucmPpA8MP75BKYzOqY/DRQkpfYvh341/nAOcWi++HiV5RtAZsKZ94NWcgVJjbB7eV65fPWkVDBcS7+rHFn7wuhIkwC+AgSkNaLO1m1GWVNtREcNfXmXIGig6oUuyM2+0UMQjOaKD0sclUavOfCEUofJzBRTsRsUf7N0jTe0Cr4d777icMAO82HuhKfkoRk9PqLNmeFTmfgKYR5IzOzqMzIoYE6vS1npfmzHKlTGynq7sdqzqlkJDKP7FWE94E7qdAntT8dnS1syzlfUvbg9I7s/UdpD0KyQf+hof1kVQrkcRjzZv5Qjd6xoR3CqdE4EszxXmXwGh7vdBJb6lkrIghHh/bSeMNQUmb8sGOkWmrylZBzwntRsS8Hs4T7+x+o4IEaBXFVjRwuEuZdf43w9/LSG6k+5nNtFRYvSRy/Kpfe00bQdzllY/nOZbPBStdh/GEEfnL7b+gDMv52SLyHflTHy9VswW6VZ7KCIzWKroLG2rbUTvPHYWinGM3/12orANV7taqOWV+RnmF0+sJf8VedpljL+DtX8RnS9N0pi625IqrcVg7oimb7aM2ATDEDGDM2rOYjHoTMjeA4uyMY1Ur17d1R4F0hwdJOMVeil9ToBysC8ijcJ4vwZ99+OXricmxKc/cb3Lqnqe8FA2KCKHe4fL7guum1uwkxG14dA8ztTmbsqpmfThdm9HCXPZCoz6dbCzNuNFsER/NljQSb5ruWiDyACOOS3PtTrEF401PC/bxMVMYaGg+XFIWW6D/sMtYI
 /2UKbSVz
 AEUV57lImrfBjEkvhOtE9fU92dVceNYKSIFiIxuKDO3zobLE3HSlMh2XYnThCo/wWjiXBVDEBeBMfgDFPFfPgg570b2io+hcZSSKdVfqpnqd21nQcVuseNUc7vYd5lE0Q9GwpHayID1eddohvfoGLLhpldtqCxcXkUeJ7F8y/LPVltf42mg03HbSYtByKkN07TYffg9YUc+wax3qH3kbnQioqJjhUehVBKBR7xCGqcLnl8Nx6hAymv9jQpfm67/fd3dOVL7ssaZsXuQCKa6a28lzBeaHEz/Wj6mkjoS70/N9o+tibbG8IcxGlfEpafTmSOKRJXPzlSbSaG8hZtKRj9tplcJZ+kpzMtFlmIjlHWIg9EGC6VSsj5Y7d/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 5:43=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmail=
.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Add KFuzzTest targets for pkcs7_parse_message, rsa_parse_pub_key, and
> rsa_parse_priv_key to serve as real-world examples of how the framework i=
s used.
>
> These functions are ideal candidates for KFuzzTest as they perform comple=
x
> parsing of user-controlled data but are not directly exposed at the sysca=
ll
> boundary. This makes them difficult to exercise with traditional fuzzing =
tools
> and showcases the primary strength of the KFuzzTest framework: providing =
an
> interface to fuzz internal functions.

nit: can I ask for another real example? AFAIK this subsystem is
rarely used (at least directly by users). However, one user-controlled
widely used parser terrifies me: load_script() function from
binfmt_script.c, which parses the shebang line for scripts. I would
really like to see what this framework can do to fuzz that.

> The targets are defined within /lib/tests, alongside existing KUnit
> tests.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
>
> ---
> v2:
> - Move KFuzzTest targets outside of the source files into dedicated
>   _kfuzz.c files under /crypto/asymmetric_keys/tests/ as suggested by
>   Ignat Korchagin and Eric Biggers.
> ---
> ---
>  crypto/asymmetric_keys/Kconfig                | 15 ++++++++
>  crypto/asymmetric_keys/Makefile               |  2 +
>  crypto/asymmetric_keys/tests/Makefile         |  2 +
>  crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    | 22 +++++++++++
>  .../asymmetric_keys/tests/rsa_helper_kfuzz.c  | 38 +++++++++++++++++++
>  5 files changed, 79 insertions(+)
>  create mode 100644 crypto/asymmetric_keys/tests/Makefile
>  create mode 100644 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
>  create mode 100644 crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
>
> diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kcon=
fig
> index e1345b8f39f1..7a4c5eb18624 100644
> --- a/crypto/asymmetric_keys/Kconfig
> +++ b/crypto/asymmetric_keys/Kconfig
> @@ -104,3 +104,18 @@ config FIPS_SIGNATURE_SELFTEST_ECDSA
>         depends on CRYPTO_ECDSA=3Dy || CRYPTO_ECDSA=3DFIPS_SIGNATURE_SELF=
TEST
>
>  endif # ASYMMETRIC_KEY_TYPE
> +
> +config PKCS7_MESSAGE_PARSER_KFUZZ

I'm a bit worried about the scalability of defining one (visible)
config option per fuzz file/module. Is there a use-case, where a user
would want to enable some targets, but not the others? Can it be
unconditionally enabled and compiled only if CONFIG_KFUZZTEST=3Dy?

> +       bool "Build fuzz target for PKCS#7 parser"
> +       depends on KFUZZTEST
> +       depends on PKCS7_MESSAGE_PARSER
> +       default y
> +       help
> +         Builds the KFuzzTest targets for PKCS#7.
> +
> +config RSA_HELPER_KFUZZ
> +       bool "Build fuzz targets for RSA helpers"
> +       depends on KFUZZTEST
> +       default y
> +       help
> +         Builds the KFuzzTest targets for RSA helper functions.
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
> index 000000000000..42a779c9042a
> --- /dev/null
> +++ b/crypto/asymmetric_keys/tests/Makefile
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_PKCS7_MESSAGE_PARSER_KFUZZ) +=3D pkcs7_kfuzz.o
> +obj-$(CONFIG_RSA_HELPER_KFUZZ) +=3D rsa_helper_kfuzz.o
> diff --git a/crypto/asymmetric_keys/tests/pkcs7_kfuzz.c b/crypto/asymmetr=
ic_keys/tests/pkcs7_kfuzz.c
> new file mode 100644
> index 000000000000..84d0b0d8d0eb
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
> +       KFUZZTEST_ANNOTATE_LEN(pkcs7_parse_message_arg, datalen, data);
> +       KFUZZTEST_EXPECT_LE(pkcs7_parse_message_arg, datalen, 16 * PAGE_S=
IZE);
> +
> +       pkcs7_parse_message(arg->data, arg->datalen);
> +}
> diff --git a/crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c b/crypto/asy=
mmetric_keys/tests/rsa_helper_kfuzz.c
> new file mode 100644
> index 000000000000..5877e54cb75a
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
> +       KFUZZTEST_ANNOTATE_LEN(rsa_parse_pub_key_arg, key_len, key);
> +       KFUZZTEST_EXPECT_LE(rsa_parse_pub_key_arg, key_len, 16 * PAGE_SIZ=
E);
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
> +       KFUZZTEST_ANNOTATE_LEN(rsa_parse_priv_key_arg, key_len, key);
> +       KFUZZTEST_EXPECT_LE(rsa_parse_priv_key_arg, key_len, 16 * PAGE_SI=
ZE);
> +
> +       struct rsa_key out;
> +       rsa_parse_priv_key(&out, arg->key, arg->key_len);
> +}
> --
> 2.51.0.318.gd7df087d1a-goog
>

Ignat

