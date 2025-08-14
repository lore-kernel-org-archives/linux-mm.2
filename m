Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D625BCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 15:28:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D94390018B; Thu, 14 Aug 2025 11:28:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B114900172; Thu, 14 Aug 2025 11:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EDDB90018B; Thu, 14 Aug 2025 11:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D3A1900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:28:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CC70483492
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:28:29 +0000 (UTC)
X-FDA: 83775744738.26.FC8E145
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id BF6AC140014
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:28:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=Vfzbxo4y;
	spf=pass (imf26.hostedemail.com: domain of ignat@cloudflare.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=ignat@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755185307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CNZq1Plf7qYhg3FaQgA7s7d5l7vZ/mBnFNpSg0zUHLI=;
	b=zNBe92dLX0iEqfFQI7YzBX6Cj2Pnuq0fhIqztqQHtlx66Le5z16BtKbGvB/VjQmRrmTwOl
	V4AXddUNxTfKiQFS03IFG2p2084Ko61UnTxR3WJlaO+7yRPE/PrQbb00sAOe+IqGVKcqeT
	2UHVpv26Yx20NWJszxto1/eWyYgvZgE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755185307; a=rsa-sha256;
	cv=none;
	b=Prrp4ccVcQ4sMqpRFohfWuEJFAdKfneioYUCZfReW3nduDpohQiziaChH646UCKxbfCT/o
	XHymN7BctjCAYAXcUiN7NmRqsuYgTCeVlC9uFxkjQkQBLXhN5q9Dj5FqpsDat7o7TzBs+H
	O6r+L8gPKlS50VJae4sjN9qobsXL+t8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=Vfzbxo4y;
	spf=pass (imf26.hostedemail.com: domain of ignat@cloudflare.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=ignat@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-55ce5277b8eso1105708e87.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1755185306; x=1755790106; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CNZq1Plf7qYhg3FaQgA7s7d5l7vZ/mBnFNpSg0zUHLI=;
        b=Vfzbxo4yaX7ptoM1YdMLM5k1Jh18Im9iUzcHhskTd2eRtmI+Ui6djL/40dQTfl69/0
         sEtqp6WUi67BmVL3sZiQ3+WpwwhnUreAlISGxvneIRUjirwxdw23OfFL2BNesLm0aRBl
         J964Hu45n57cTIpUD7gJxfrH65wnA4u8+3NyDAHj7GarGcsoPg//zj33eqZdl0Gc/MFR
         wdbkn48/2jUhfSliHFgjm2NuPLbKj0s1vs7JIbKz+TyiIJSU3MB5iWmzh45mgHRSuULf
         5W7EQByLKb97LY8OE6/0v/zYcOw0ZD9zBOymJsZDtLZ41FjBnsSvsmdDK7s4/yjm0xbf
         UsiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755185306; x=1755790106;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CNZq1Plf7qYhg3FaQgA7s7d5l7vZ/mBnFNpSg0zUHLI=;
        b=p2vDIpXti9jpNWlQB1v0T6USNQea1mOfC0JtCOhqfFEWmZHfhw9dOwG2jggjGL0BAp
         7oOVxcjLHXNyr9ThuVVxEOn9gN7kTZcKK9S6v7LU+hLpdfTqanoeHXQOUgbGDWeouGsv
         cMurklIajUcCMWmmiE1u3OVqCidZzV+uYC32R95z8DzRGEPMvKWSudDKZFfCwzulyO7Y
         rDXcuN0LQaP5HswuUhqHQLmSTpUmIK7y9qAAcVzs9TJWvj8ELjuCwjB6uh5tTFPRv1as
         38JuVOctSpp3mftzC3qAhDGNXU5xp2lLY9st/aLfa2lNP4rjaxejjsoNV4vMV/kxfzyC
         FLGA==
X-Forwarded-Encrypted: i=1; AJvYcCXmUxJr+fpiyXBoNlfRFyTPc8McfC3ZJHPMoi5okYwJYpIQ6F3E4h49aLrJJCoMnnx4tbj6rEQ9SA==@kvack.org
X-Gm-Message-State: AOJu0Yw0cdeyn1dgNbwxpQ6nek505mWbtnI/NUwTrJiaIMiFTCwN0gP7
	rP+duqrHHLNLGpaXhf4/ZuyKIiiajC9q00RuzRWGFobSHRbe0p8WzGFFgqgD/2KH0H5izDSNJ+8
	c952sQiqQagrXsu6NffmZjoF1fPyy5RLMYopBUewo5A==
X-Gm-Gg: ASbGncuQveNiUvQgzKGnZcvCaHW13rXbg1hYRwMOSUhbmTfvAL8RZt4340mLo9l4Tne
	tJd85VhCX+gwXxib+h6kXANBnougEpzXREIzfrfX5MwLpds7BhVQHfcuPRr0RAC4BcznRMPIRKX
	BkmN6/aV8wfVl08YgXpQMYV2xa80xjgh27JpO7VY/SKdJyKGj4J7VerJTIuIGJA83rkgvrx5gE4
	hfRrHga6oCBYgfnhZjexRqfkQ==
X-Google-Smtp-Source: AGHT+IHQ8F3iADMu1+UWrg73CrYiGwX8UpQYUYOvtGC+LP7TmJAAopR8WHzWm3NU2ztOeAgz1cMRk77sbhDWFguLt2c=
X-Received: by 2002:ac2:4e16:0:b0:55b:8540:da24 with SMTP id
 2adb3069b0e04-55ce50133c8mr1226637e87.20.1755185305657; Thu, 14 Aug 2025
 08:28:25 -0700 (PDT)
MIME-Version: 1.0
References: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
 <20250813133812.926145-7-ethan.w.s.graham@gmail.com> <CANpmjNMXnXf879XZc-skhbv17sjppwzr0VGYPrrWokCejfOT1A@mail.gmail.com>
In-Reply-To: <CANpmjNMXnXf879XZc-skhbv17sjppwzr0VGYPrrWokCejfOT1A@mail.gmail.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Thu, 14 Aug 2025 16:28:13 +0100
X-Gm-Features: Ac12FXx9I9MrbtuwHaesyssft3AApB1lCQVaDorKwBHz1btfjTXbPnGjfwlVOBI
Message-ID: <CALrw=nFKv9ORN=w26UZB1qEi904DP1V5oqDsQv7mt8QGVhPW1A@mail.gmail.com>
Subject: Re: [PATCH v1 RFC 6/6] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
To: Marco Elver <elver@google.com>, Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com
Cc: glider@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, rmoar@google.com, 
	shuah@kernel.org, tarasmadan@google.com, kasan-dev@googlegroups.com, 
	kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BF6AC140014
X-Stat-Signature: opcsbpxono45bew9oa53pdpa5wtuxu8b
X-Rspam-User: 
X-HE-Tag: 1755185307-591947
X-HE-Meta: U2FsdGVkX1/TUFfvYMMVMKz8ANy0B87eLgC7ADD6bs/Iw9c8zm1n9pQmOvsy56k//fKvJ/L/BwySKE9DZeFBZ86nPXBQw2n8y4wq2vU5vUdzLmMXNjbWRYUO1kSt/RhWok7MBqfvd79xPIMETY/w95+nRVUHQvZWllDQzF/nCuNVjsRRc7p3sODdLfy+z+ESva0iUFfvuaEmeDY3QQ7CmixewNou8BQohiBsqN5sJOfx7hjlfG3mUKWrvoCIxnhzlDAJZ5bL1aFLFOaNsQQ1T6ShqBS9nmpkstZTO5fynqQv21LqWiyU0hZcaz+Vh6vcCh1EO7j62D9usuBKqw7kBgL+7mrJ4C5v9uxgOx86GWr1sPMtISy3CeSLTd0drIdcHfh2RCzcsyDfav3qpyaRdHaVVgSIWqpl7MrY/YWhBGuOcHPrR0Iu/qb3JZESCNvJRE7hzEjl2EGFxpliJpqTUv+zlLCekjK/nFmeTfhlAYvek1OfiOCVeHBjQrzSlSUlX8OUTcXF7xxcL5345qwbGtxCertWVcYBs2QeaMpCnu/5gKfMySvhq8N+GDpvhn6DBl2drkZ2Pflnj+5uQBNgtPmn/SvrjGAdQaZBppQrX1jEEugZ/DIaLQoqsjfJ6G3tCDowpY/YqTdxRyCtfj8ru70nxjUd4LxJqfRIIJ/K/LosjOBh3dp4qgIVkgH85yNdZPEbPJvUkKbyQKcsphJurBAnyyAcyKGX5UGadlBZf8OCayLDA3OJP/yftFJs9MSB9NHTLDRXFrbzjU+Wd9Hlw2RQ9itZM8YtgEo5qbmOUnjQjMGKgXlILtDqhxwngnER17VCizHsKRXvt9MPvpqNkxxXIkwecZqhlPOShAXXeGttHoO+Y8+rVrqDeTl5tITshoQcWKPTSrN489ywpjv6ID5Rlu/Kq9y0bpDKnVjPvnL17LG1Pe/WT1daUfhMSsf0Jpy8NHt7z4Zq+oX2M/Z
 lg7JU1U/
 vr5+sD7WdSro9OsETp7FgyuRzE3xGCyM4Lw9ruf9to5+T2nW/iN2HbPjuNplfeKMzcy4YTGbiOEubRpTzFHBsTR9Y3o+wUSycHs9vxZwdQShxAQTUjY0/XAc6z7KXBVeB+Ohbr6UHqXHY2ziSayhHjNda9XdyeYXiYQF3TT5wqmMxYM5OQiaQdPZR0yVxqBw05MNKErI++p2enVkUtZjkBDvCFnObwPe+eHoxYYD7OOsKn/DP7K93YoGjuIcs/IzWgldLFrdl7pwoY8kkxdd5SjhyDjNthuy/JZLceBRNZu3HJeTQTP08Nitx3vQdzo+wetZzs277A5a6j6esvfEHhIdFB/rCMZG0zfDJcBVFUSJc/PxnU19LkuwS7DnDlrXQG9WzoGj9Y+2fef9P5xqPOLJu3bHBp0nuAIEd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 7:14=E2=80=AFPM Marco Elver <elver@google.com> wrot=
e:
>
> [+Cc crypto maintainers]
>
> On Wed, 13 Aug 2025 at 15:38, Ethan Graham <ethan.w.s.graham@gmail.com> w=
rote:
> >
> > From: Ethan Graham <ethangraham@google.com>
>
> Should also Cc crypto maintainers, as they'll be the ones giving

Thanks Marco!

> feedback on how interesting this is to them. Use
> ./scripts/get_maintainer.pl for that in the next round, and either add
> the Cc list below your Signed-off-by so that git send-email picks it
> up only for this patch, or just for the whole series (normally
> preferred, so maintainers get context of the full series).
>
> > Add KFuzzTest targets for pkcs7_parse_message, rsa_parse_pub_key, and
> > rsa_parse_priv_key to serve as real-world examples of how the framework=
 is used.
> >
> > These functions are ideal candidates for KFuzzTest as they perform comp=
lex
> > parsing of user-controlled data but are not directly exposed at the sys=
call
> > boundary. This makes them difficult to exercise with traditional fuzzin=
g tools
> > and showcases the primary strength of the KFuzzTest framework: providin=
g an
> > interface to fuzz internal, non-exported kernel functions.
> >
> > The targets are defined directly within the source files of the functio=
ns they
> > test, demonstrating how to colocate fuzz tests with the code under test=
.
> >
> > Signed-off-by: Ethan Graham <ethangraham@google.com>
> > ---
> >  crypto/asymmetric_keys/pkcs7_parser.c | 15 ++++++++++++++
> >  crypto/rsa_helper.c                   | 29 +++++++++++++++++++++++++++
> >  2 files changed, 44 insertions(+)
> >
> > diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_=
keys/pkcs7_parser.c
> > index 423d13c47545..e8477f8b0eaf 100644
> > --- a/crypto/asymmetric_keys/pkcs7_parser.c
> > +++ b/crypto/asymmetric_keys/pkcs7_parser.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/err.h>
> >  #include <linux/oid_registry.h>
> >  #include <crypto/public_key.h>
> > +#include <linux/kfuzztest.h>
> >  #include "pkcs7_parser.h"
> >  #include "pkcs7.asn1.h"
> >
> > @@ -169,6 +170,20 @@ struct pkcs7_message *pkcs7_parse_message(const vo=
id *data, size_t datalen)
> >  }
> >  EXPORT_SYMBOL_GPL(pkcs7_parse_message);
> >
> > +struct pkcs7_parse_message_arg {
> > +       const void *data;
> > +       size_t datalen;
> > +};
> > +
> > +FUZZ_TEST(test_pkcs7_parse_message, struct pkcs7_parse_message_arg)

Not sure if it has been mentioned elsewhere, but one thing I already
don't like about it is that these definitions "pollute" the actual
source files. Might not be such a big deal here, but kernel source
files for core subsystems tend to become quite large and complex
already, so not a great idea to make them even larger and harder to
follow with fuzz definitions.

As far as I'm aware, for the same reason KUnit [1] is not that popular
(or at least less popular than other approaches, like selftests [2]).
Is it possible to make it that these definitions live in separate
files or even closer to selftests?

Ignat

> > +{
> > +       KFUZZTEST_EXPECT_NOT_NULL(pkcs7_parse_message_arg, data);
> > +       KFUZZTEST_ANNOTATE_LEN(pkcs7_parse_message_arg, datalen, data);
> > +       KFUZZTEST_EXPECT_LE(pkcs7_parse_message_arg, datalen, 16 * PAGE=
_SIZE);
> > +
> > +       pkcs7_parse_message(arg->data, arg->datalen);
> > +}
> > +
> >  /**
> >   * pkcs7_get_content_data - Get access to the PKCS#7 content
> >   * @pkcs7: The preparsed PKCS#7 message to access
> > diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
> > index 94266f29049c..79b7ddc7c48d 100644
> > --- a/crypto/rsa_helper.c
> > +++ b/crypto/rsa_helper.c
> > @@ -9,6 +9,7 @@
> >  #include <linux/export.h>
> >  #include <linux/err.h>
> >  #include <linux/fips.h>
> > +#include <linux/kfuzztest.h>
> >  #include <crypto/internal/rsa.h>
> >  #include "rsapubkey.asn1.h"
> >  #include "rsaprivkey.asn1.h"
> > @@ -166,6 +167,20 @@ int rsa_parse_pub_key(struct rsa_key *rsa_key, con=
st void *key,
> >  }
> >  EXPORT_SYMBOL_GPL(rsa_parse_pub_key);
> >
> > +struct rsa_parse_pub_key_arg {
> > +       const void *key;
> > +       size_t key_len;
> > +};
> > +
> > +FUZZ_TEST(test_rsa_parse_pub_key, struct rsa_parse_pub_key_arg)
> > +{
> > +       KFUZZTEST_EXPECT_NOT_NULL(rsa_parse_pub_key_arg, key);
> > +       KFUZZTEST_EXPECT_LE(rsa_parse_pub_key_arg, key_len, 16 * PAGE_S=
IZE);
> > +
> > +       struct rsa_key out;
> > +       rsa_parse_pub_key(&out, arg->key, arg->key_len);
> > +}
> > +
> >  /**
> >   * rsa_parse_priv_key() - decodes the BER encoded buffer and stores in=
 the
> >   *                        provided struct rsa_key, pointers to the raw=
 key
> > @@ -184,3 +199,17 @@ int rsa_parse_priv_key(struct rsa_key *rsa_key, co=
nst void *key,
> >         return asn1_ber_decoder(&rsaprivkey_decoder, rsa_key, key, key_=
len);
> >  }
> >  EXPORT_SYMBOL_GPL(rsa_parse_priv_key);
> > +
> > +struct rsa_parse_priv_key_arg {
> > +       const void *key;
> > +       size_t key_len;
> > +};
> > +
> > +FUZZ_TEST(test_rsa_parse_priv_key, struct rsa_parse_priv_key_arg)
> > +{
> > +       KFUZZTEST_EXPECT_NOT_NULL(rsa_parse_priv_key_arg, key);
> > +       KFUZZTEST_EXPECT_LE(rsa_parse_priv_key_arg, key_len, 16 * PAGE_=
SIZE);
> > +
> > +       struct rsa_key out;
> > +       rsa_parse_priv_key(&out, arg->key, arg->key_len);
> > +}
> > --
> > 2.51.0.rc0.205.g4a044479a3-goog
> >

[1]: https://docs.kernel.org/dev-tools/kunit/index.html
[2]: https://docs.kernel.org/dev-tools/kselftest.html

