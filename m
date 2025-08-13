Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C36CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 18:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 230379000C0; Wed, 13 Aug 2025 14:14:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E136900088; Wed, 13 Aug 2025 14:14:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11FAE9000C0; Wed, 13 Aug 2025 14:14:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00B5D900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:14:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A8F4C1DD112
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:14:31 +0000 (UTC)
X-FDA: 83772534342.22.1713310
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id C60AA100009
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:14:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Kpwq9NZm;
	spf=pass (imf14.hostedemail.com: domain of elver@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755108869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4hxBfzmvH2TsE+jx0zUQqB7m43IVHQfBxYfENPa1oII=;
	b=mivWcSztG1H3uxvw1/IaBJyIValsTqT/vC0hBwveF+Txy7h9GRoyR0iYez3Cs6JvOI2DM6
	I6evGB27XXJQZ/EnkyIykIaWsdmnayaDgYa+t/0Cc9ebiQjaDWO7n9j84LugeB9QeDb92F
	r9fNXWwW2rgju1vmgB98MQgu8360PGs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Kpwq9NZm;
	spf=pass (imf14.hostedemail.com: domain of elver@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755108869; a=rsa-sha256;
	cv=none;
	b=D6PEVAfpTYtspH7JeC4GRyuG4FxwCHQIlYM65vTWz5eRt/su/R0id2yS108Nng2OjLBxbt
	W/ss1EKOn4ntLu5VuV/nY0ryLLSrZ27e9Kmc7WduEEQVB/31LMmosqqPQ8+1WLJrWTh1Zd
	9KO2mmZRO3gbMfkqJJ+uqERyUuSbMQs=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-24458317464so353595ad.3
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755108868; x=1755713668; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4hxBfzmvH2TsE+jx0zUQqB7m43IVHQfBxYfENPa1oII=;
        b=Kpwq9NZmG7kyfJzBxFS5ibza4aPLJWBoJqzCDce0OtItODx+yEPifCAd8QIYgCyeDQ
         9iPdI6fZ2jfsWlQLY/cN8j80r/5NaTKy7HNe2L8o8vmEEm5LtNqyRApJuVSGQQl3Kkup
         pvWGPzLfrjHF74YSbn6nw8j108LZS+bk/b+bx6wdJcapTHapIUdLA36973q1hdK0ZOu/
         eRAXFe/bAcgXsO1WfG7LLhmkqqiDkW38iaCCJ3b55iqdeQzyEm9vb52/G3eHey80/cO/
         szIZ6V8hKi08DpN9LIo+2B/WMGhcBrUfSr7cvY0qCV9TY0NPXCqOaqzj1e7x4lTACwXv
         vCWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755108868; x=1755713668;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4hxBfzmvH2TsE+jx0zUQqB7m43IVHQfBxYfENPa1oII=;
        b=Gmg5hmYenP/6Iz+11htmV+dIFcZpQ0QxgzcplWzBovP0UeNotQb9n52eFvEG/RFZk4
         2aUl1SDQqDkfFuXdhXq1Ll60hwa9rbP7gLmovbmKIVvyEn/hSA9mblDaNorTg4CAhrl5
         YQ+wn8T3D/JKZC6HncvoCS1xVYrRr3bpJ882lmZqkhVzaw/8s9S8LgXxSWHktjF7f5kC
         KpWG/08Jb9JhZJY8nHiSrZksxlGOJzouSGxpmNH/ILK8GJIXoTynLagz8qJma492j2+6
         5o26dkWClr9QfkgD2luXiT/Rcy3lUCSC1dkhYUKmkIi8ZzEDg4hivA90t6xbaqy1peCv
         CnHA==
X-Forwarded-Encrypted: i=1; AJvYcCXIE+yDiMH/a0bEg5Yvxjv4uMT0OSXUBC0pUTstsw097x4YAP5rpVNLOIIwaSaB4FIvmUofsd2beA==@kvack.org
X-Gm-Message-State: AOJu0Yym55gdMoO6QhnVd9IZsjCioOze1NLK7swuxhlqTEEbOBrOX0C6
	kbv590jUdCFfNIKYse2z0/ksnd23LJWglDlR2Rqb7fXXRfiROI/yvF/QtM1kZ8HV1vK7wAaU9hf
	bMiAgdmI4o0sjw1v4gNLwtVV+oEcLN8G0NeUiU6sQ
X-Gm-Gg: ASbGncsAn0O8Keg7VhPlh9sZwFnRrl5hcx68lGuIb/CqkxUlbcFLxU+0BEcLAB/TStY
	aWnqUIvMXsNC7Q/MiuYhgY3QiZLCAMIKKaCUZns0Fl7RldA6tYv3Uiqk98Xg8Du8sdDA0gRygkH
	zv2JbQUL9U01UqSvaJzKgefEhXDAlw+rLmLwE3yoeQmLYwOcukmh8W7EVVpk+Qzee9F3L8QT7Hy
	951l7OmSAcP+CPZckxQ4EhtrAKSAgCAUy7dEZjc7fa349cL
X-Google-Smtp-Source: AGHT+IHotfho3h1ZZecOKGuq1D2CciZoVsCtf5moBH0RJz5U14Jr0GnJ8FzYfeu03dCe85qFQ/eJAyGnggeHSkOqeXI=
X-Received: by 2002:a17:902:d542:b0:240:41a4:96c0 with SMTP id
 d9443c01a7336-2445867ed19mr701285ad.29.1755108868210; Wed, 13 Aug 2025
 11:14:28 -0700 (PDT)
MIME-Version: 1.0
References: <20250813133812.926145-1-ethan.w.s.graham@gmail.com> <20250813133812.926145-7-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250813133812.926145-7-ethan.w.s.graham@gmail.com>
From: Marco Elver <elver@google.com>
Date: Wed, 13 Aug 2025 20:13:51 +0200
X-Gm-Features: Ac12FXwt2pSL7dVwRutKcMu_hFjjWXkjb4Jh6zDHbgaT8hltdL3d-RuGkNjKm24
Message-ID: <CANpmjNMXnXf879XZc-skhbv17sjppwzr0VGYPrrWokCejfOT1A@mail.gmail.com>
Subject: Re: [PATCH v1 RFC 6/6] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, glider@google.com, andreyknvl@gmail.com, 
	brendan.higgins@linux.dev, davidgow@google.com, dvyukov@google.com, 
	jannh@google.com, rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Ignat Korchagin <ignat@cloudflare.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, 
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: mdn3986ksya8m71ogxod8ewfpf1ofzt8
X-Rspam-User: 
X-Rspamd-Queue-Id: C60AA100009
X-Rspamd-Server: rspam05
X-HE-Tag: 1755108869-817260
X-HE-Meta: U2FsdGVkX1/c71DY/KOOhASV9eAYxCeDhxe9FOC/JLN95lYdON1O/sHxOM4SU16pP0i/E+aoCTkoaDa5ZRkQM2Chm1hk2dSLunsAzLWzV8m1BnaL6mnhnmAgXLUt4H0NWq/Z7Lq/Bw4v3zTezdnNA9wwTxEALWgur9mPUhVEotdUQ21zgcseJmeMaM0N7brm0EOA8agPfXAjTxqCRJVPZX1iH6+F6xebEP+0zNqPPgcMnqVYHdpJSkFB8IZHLKumyQ25G9IteVlkiLaq0ZQj1oLRecF6vJoEStJDJogWjn69IbPJAdQTXeY8q45z+fy71Guy7tVu0R+ASVjZ9NJDM+FGAOCO8xoWIapZlnpG1tCrcVIGrZ1pPkmknyHNPoBT/CG2cs8TmHzAKrHnkkuqjuMBX+7BWPUbs2QU1fcQBo4o+dw0zMMGiT+/qkKFNSU8sS6qK4lGZb+bp5Lf7qdyT9NgTdoUyIIJXhurNBky3uXfnj96Pl6kG+LYc+7lrKPiktEp/m4Ni3pXfbGQzOaVcXY/6IQIrijuemc11iK5E5El8EormLYd0Hbdd0aWefKEF5L8b/2Lb4eQLiZs7WlUbM0vsIK7jEcUlGzPmwAKwNz1xPcQStyIQcP6JJmfzK4Zl+qAukFZQPoXJRraKKH5aL5edGJfHAd0WhYdzINnMwSwHWsTW4K7alFhoL3e5TltOBKEPLgqjol95+9KItri1HP4V5HBtKFAGRukim5jrnyuO6kOOz/3vn0s16r7srsTKQ8wwZBIwtdBvT+BA75stUL2OCFzL1/kzybx8Dd9qxvwAqq4KTnlYOVdCKrieNYXFlAP/hNpG1rgY3DDdGhiZAxRlm8T1XWJTt61WE+etsRAcpnC6MZ4oFR+69qcSTj9zGVNuV8+X61nG+wkn/Y1F4RPTDuSTH5sNpO8tYhgxuwOUoc2MayIvlbQyFg/Z+IRX3KJRUskLee5nVKd2i+
 ceWkIEX8
 rPM+AiFfiwIQnGVgH6ei5KVVhnsTz+fTWg9GdYso9VC/tJmaWw+thcZN03gTlL1ZpvVZ+dsJUhrys87sJoNxkHibLuBxOCC6egJOBDCTi7CK9Mr9cJzjRQf5+WzKoG23jnvhydqyUE8dGpyjNab2idQP3lsW7vMHraHTJfl7EntcffLFufYnoMW+yYZg/F0i8iaycxdmmfEygWeTwcvZApccM8/zbaX8xeJb1iCdrjzNAVdTlP8vmutKbvvD91z20RbAIYbn8P0QdsDRv3+TC5ACIUzl3KmySybLFJv/yWtQu0AuFQ7+DdBZUVc+0qaIiCTlLgAWg4H/l1ZgWAd6G6aMDavFmF/zor3bV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[+Cc crypto maintainers]

On Wed, 13 Aug 2025 at 15:38, Ethan Graham <ethan.w.s.graham@gmail.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>

Should also Cc crypto maintainers, as they'll be the ones giving
feedback on how interesting this is to them. Use
./scripts/get_maintainer.pl for that in the next round, and either add
the Cc list below your Signed-off-by so that git send-email picks it
up only for this patch, or just for the whole series (normally
preferred, so maintainers get context of the full series).

> Add KFuzzTest targets for pkcs7_parse_message, rsa_parse_pub_key, and
> rsa_parse_priv_key to serve as real-world examples of how the framework is used.
>
> These functions are ideal candidates for KFuzzTest as they perform complex
> parsing of user-controlled data but are not directly exposed at the syscall
> boundary. This makes them difficult to exercise with traditional fuzzing tools
> and showcases the primary strength of the KFuzzTest framework: providing an
> interface to fuzz internal, non-exported kernel functions.
>
> The targets are defined directly within the source files of the functions they
> test, demonstrating how to colocate fuzz tests with the code under test.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
> ---
>  crypto/asymmetric_keys/pkcs7_parser.c | 15 ++++++++++++++
>  crypto/rsa_helper.c                   | 29 +++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+)
>
> diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
> index 423d13c47545..e8477f8b0eaf 100644
> --- a/crypto/asymmetric_keys/pkcs7_parser.c
> +++ b/crypto/asymmetric_keys/pkcs7_parser.c
> @@ -13,6 +13,7 @@
>  #include <linux/err.h>
>  #include <linux/oid_registry.h>
>  #include <crypto/public_key.h>
> +#include <linux/kfuzztest.h>
>  #include "pkcs7_parser.h"
>  #include "pkcs7.asn1.h"
>
> @@ -169,6 +170,20 @@ struct pkcs7_message *pkcs7_parse_message(const void *data, size_t datalen)
>  }
>  EXPORT_SYMBOL_GPL(pkcs7_parse_message);
>
> +struct pkcs7_parse_message_arg {
> +       const void *data;
> +       size_t datalen;
> +};
> +
> +FUZZ_TEST(test_pkcs7_parse_message, struct pkcs7_parse_message_arg)
> +{
> +       KFUZZTEST_EXPECT_NOT_NULL(pkcs7_parse_message_arg, data);
> +       KFUZZTEST_ANNOTATE_LEN(pkcs7_parse_message_arg, datalen, data);
> +       KFUZZTEST_EXPECT_LE(pkcs7_parse_message_arg, datalen, 16 * PAGE_SIZE);
> +
> +       pkcs7_parse_message(arg->data, arg->datalen);
> +}
> +
>  /**
>   * pkcs7_get_content_data - Get access to the PKCS#7 content
>   * @pkcs7: The preparsed PKCS#7 message to access
> diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
> index 94266f29049c..79b7ddc7c48d 100644
> --- a/crypto/rsa_helper.c
> +++ b/crypto/rsa_helper.c
> @@ -9,6 +9,7 @@
>  #include <linux/export.h>
>  #include <linux/err.h>
>  #include <linux/fips.h>
> +#include <linux/kfuzztest.h>
>  #include <crypto/internal/rsa.h>
>  #include "rsapubkey.asn1.h"
>  #include "rsaprivkey.asn1.h"
> @@ -166,6 +167,20 @@ int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
>  }
>  EXPORT_SYMBOL_GPL(rsa_parse_pub_key);
>
> +struct rsa_parse_pub_key_arg {
> +       const void *key;
> +       size_t key_len;
> +};
> +
> +FUZZ_TEST(test_rsa_parse_pub_key, struct rsa_parse_pub_key_arg)
> +{
> +       KFUZZTEST_EXPECT_NOT_NULL(rsa_parse_pub_key_arg, key);
> +       KFUZZTEST_EXPECT_LE(rsa_parse_pub_key_arg, key_len, 16 * PAGE_SIZE);
> +
> +       struct rsa_key out;
> +       rsa_parse_pub_key(&out, arg->key, arg->key_len);
> +}
> +
>  /**
>   * rsa_parse_priv_key() - decodes the BER encoded buffer and stores in the
>   *                        provided struct rsa_key, pointers to the raw key
> @@ -184,3 +199,17 @@ int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
>         return asn1_ber_decoder(&rsaprivkey_decoder, rsa_key, key, key_len);
>  }
>  EXPORT_SYMBOL_GPL(rsa_parse_priv_key);
> +
> +struct rsa_parse_priv_key_arg {
> +       const void *key;
> +       size_t key_len;
> +};
> +
> +FUZZ_TEST(test_rsa_parse_priv_key, struct rsa_parse_priv_key_arg)
> +{
> +       KFUZZTEST_EXPECT_NOT_NULL(rsa_parse_priv_key_arg, key);
> +       KFUZZTEST_EXPECT_LE(rsa_parse_priv_key_arg, key_len, 16 * PAGE_SIZE);
> +
> +       struct rsa_key out;
> +       rsa_parse_priv_key(&out, arg->key, arg->key_len);
> +}
> --
> 2.51.0.rc0.205.g4a044479a3-goog
>

