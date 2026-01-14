Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 485E0D29FF8
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 12:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A940A6B00AC; Wed, 14 Jan 2026 07:28:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A41D06B00AD; Wed, 14 Jan 2026 07:28:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9446F6B00AE; Wed, 14 Jan 2026 07:28:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 815FA6B00AC
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:28:53 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F395C163E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:28:53 +0000 (UTC)
X-FDA: 84330498546.14.B1ED0AF
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3DAAA1C000A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:28:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jmpLntCD;
	spf=pass (imf20.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768393731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LRMIFkzXb5IBhiTKdWbjWhp1Z2C8Xy7d3z7GyFAcX9o=;
	b=UOTkq9xxzisd3NYm/W6wPUBkiZ/QVOgjTJZt07xwe9tL9ya9UpCVMZ03ONtXvy31nAGpAb
	PYeCTMIuqhQPZTIV5P7N25HXRVIrRl2+ztH0nEEEKkvSZHRuhzugiY55poS6SI4XJwH+Zp
	wFYBrE1aOazmivNCCyKk8l0ijJugDmw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jmpLntCD;
	spf=pass (imf20.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768393731; a=rsa-sha256;
	cv=none;
	b=4hT0Qy6M1tOAV4HLxJHIV280Q70hNA8tdNRKPWfwDJh1tMOLx4CRj8QsFS6RFM8kHmJyGa
	5DrPCUlX+DHfX1s/clyR31957BHgrU4yrV0SJ543uKWulg70zrxaFBzUo5uGgRwIhjxNJ9
	nu1Q0tbvjaUErBfZrX+X3ygVj+i6p6U=
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2ae38f81be1so9398628eec.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768393730; x=1768998530; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LRMIFkzXb5IBhiTKdWbjWhp1Z2C8Xy7d3z7GyFAcX9o=;
        b=jmpLntCDJr6/syuIDg/QRB3gdfPS+XZ7TIhTqdFNWeHX4lty2M5uH94eBss+BuIkop
         pgIaMTri7ND/A2cpAIIrL0HK/xAM8W7ckSiPJDIUhE+yRdQfSF3+xU5rUo2ubpD5DEBF
         Nefb5G3ASYsRMAEGWxybfss6Rp/9xQazQFKKIgpKruBE5VdSBQHxtCkQpFEwN2NowIWe
         wtVhaUOzFsL5v0ndBC+Xnv9Z5/nBD+hOu5apSeV7yLKCbV6PVIGYGOMyi0p1vaRyKEGB
         QDdXXnQ9rWweOkfoTrVAqxQo0PZLSUEPq+eHDtYQKQdDhqn2cjTi+SDrHaPoIIsBcy74
         mFsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768393730; x=1768998530;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LRMIFkzXb5IBhiTKdWbjWhp1Z2C8Xy7d3z7GyFAcX9o=;
        b=YPmGm9LZhg6WUbaiFgZ2ovYz73DAnAX/4TqZuQp7ZcTP2T4EBR7p1a4CrVfeZ+Syin
         kb+m/hN1d2r22UUlzcLZ/xNIRpqmzufVBMiflUOzbpb3Il0SZvt7dlJGROlpM59Oyrmp
         kdFaXsK50dsCBx8/98ml/oDQZJHL+0SL36miOIBe/WkYV/2+Dv/S94BTz7ZyU5zyQOSu
         pcmFGVNSP77yJLN07vbgdSr1zzMBb+lIKe4YWBskSZydDV45QTjLr9rjtzVtaG3hvegN
         bKmwRO97msb5V7Qdkf/l4yeZsEPgxLyj0d52ewMb/4vGwv5w/T0tLWZu2ouMhQK0mPsx
         LbWg==
X-Forwarded-Encrypted: i=1; AJvYcCXcTvvEw2cAyII1r9rTgzM9G/NYpAcuQ23hXRXqjfti+0jrgFN3uk9H3JY17Hxqld+PEE8UUZbZrg==@kvack.org
X-Gm-Message-State: AOJu0Yw7c+wutrWydtwAfxK44zH6z51oBkwH1l9eKw6ABBZtOeU69Y/y
	0Icdv70OvZO43Q9Hrp3jhQXpKcPuXocJiJJHv2jzgpbHYafqV8xKVVwBFYScJ0RP1b7esMJUPzo
	F1/4EvpVHdxyqGFrjYRACC1uHppJpQFM=
X-Gm-Gg: AY/fxX6MiLfclZXg5h6Kl3aY88HBQ7zKd8VgBcjzRNdbwXTFnmls6tO+qpC5d08B4ql
	P8RTeGhutZ1v4Fxao6cg2Rx5QPUJt8Cd070BWgrrkqDMSpx7vYrof4Cg0YZ7+dYPNIzrZ7osW1f
	DWUXRPkw/w4QFhPSoYEQn9hF/80CQMiw0RYl/blDoPmPoZxD8fci0EPhBHulANnplpzd+4DXq0i
	lElEqIh+4XoSGbr8Cgk0/SEJ1YFyxs0HyH2HTyHVYEcfTgWgish8J49/3YFvujhpk09huOOnAad
	EyPSi6/CpJvW2R561IAytOwl
X-Received: by 2002:a05:701b:231a:b0:11d:f440:b757 with SMTP id
 a92af1059eb24-12336a8ac7cmr2122254c88.26.1768393729717; Wed, 14 Jan 2026
 04:28:49 -0800 (PST)
MIME-Version: 1.0
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
In-Reply-To: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
From: Ethan Graham <ethan.w.s.graham@gmail.com>
Date: Wed, 14 Jan 2026 13:28:38 +0100
X-Gm-Features: AZwV_QgmF4HyCsXk2jh6zEFc90ih1bVBX_Jk6twBkZMZEi05K-WZZcMS9j7S7Fc
Message-ID: <CANgxf6yGDGAD9VCqZyqJ8__dqHOk-ywfSdhXL5qATfxnT-QGFA@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] KFuzzTest: a new kernel fuzzing framework
To: ethan.w.s.graham@gmail.com, glider@google.com
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy@kernel.org, 
	andy.shevchenko@gmail.com, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, ebiggers@kernel.org, elver@google.com, 
	gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, mcgrof@kernel.org, shuah@kernel.org, 
	sj@kernel.org, skhan@linuxfoundation.org, tarasmadan@google.com, 
	wentaoz5@illinois.edu, raemoar63@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ei4nusnhj1mxkhtj7fm13dd38zrsxdx4
X-Rspamd-Queue-Id: 3DAAA1C000A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768393731-550080
X-HE-Meta: U2FsdGVkX18x3ghGSUMCWSnyE3ZtS6RAqwABwk4oM7dusI+QZq3hIAdhcvI3g9kG02eDiSsUp8uzA6CgPVto83Zi1mO3JbNbD1Lg89PJSBImzyyOzXxh1SU7UQvy6MeW12BgzFAtbf1u6qcVSsveSmxBd24vgp/1lpB4hLQD+c/ITlHIsxE5zTTyP/4EEXuYhAL/WHzKCuCeO7L5DSGfuYgD1UjN9fGAm0PG0sQ3j71+YmEGTfwFACDbFAkUICYY8q/FJYWaj+oNjDcwC6eISe/EXaf1u7WCugm8FMHwiVoOXNzoNgn3lxODwZJGwxWmdjyKJXG7n8q+dzl1UJ0WeD/9ToXf6JdoBDZV9kZMnhvgk7A1OsNbLxM1ZE/f2j+JhqaajYWuFg0KSfStBMw9juf8MoCIxW4f9C/yX7l0yvRqNIbSkir/xj+Gl0EIZh4JdApUFPArjYdSg+NKA74ZtalgYmlvetyFx92kPPwyrDlXB5bsdRnnpcFXxF5oDcFYxRSK3A5UIZHvcyOy1OKqeaizlAXcHyUrJD9nLNlA36yzrs+KaMbLmHq34RGIGeLMaKZL2wtZd7jZs1yzSCv/8fOUz+iJY1Mamm6NyQkjLH8kXru8TeAubxS7JQd6fB2Z7zmUKAlKUOdfprVpADGXjmcjpKE8FLCrVE4iY2ZFg36I1JM5lhyiYbz3jGh+nokHJSzSLCrMhN9XM/dG0UbmQBYLh3I+qLXRWvIvlZWf6HviNQqSPbv8YRWbgOadLRAMWhCcmSSqwGU7E3NSFp02st0URNi29frVhX58lT6oibmOdh+P/rSZdJxQ7V4aCrWjFX8cBPODW/RVynkmRCJbdGL4r32j5eTBVvULGQV1MrSVepGW4jtpe1MH51mg+00qrtccLbkld5/civeUUwSxrhUCj9bAEW14loSSG2n2Z+RCFDjAMuK6tyaFhkbEzQGlKJf1TUVKwUfBpX/DH/Y
 xAtVRohg
 2sfMIcBNrFNY0aRgUEacLfTGb11XOfuY7+VQHvEnNO+FoASsbHZOTBsSspKz7mbl9kvwVxd8t87nEI/gw4Db34yoF1knHDJFpkWVkSvYdHnaXPI2aEpgbCTZkSMceqmQrwNOOlHRKKTcoYlR7oy4lHqlkc40ZgwLsM5sB42EwkyBbivPxEGA5LDCptveEtHRqeYlyBl0sH7whQpd6mT8AD19HeeenQm/iAJnlY2cGrsSxyrh0cQSkBxJjmcuxKJ2RM6OMuquo3lQ0MG+JZEYhrdqqWrb7E/D+MaBRysqM6zDrIf0Y3oK5vfTzznxTBipMbbLN7Agbcf+Uj0iqcx5d2cYVI+KMAn4eR+V9paRo3/HuwuxxUiPz9xV4vJcQjFal6hooITPvdcq8eOKS20YyxcMJ+EGOoE19wVRX8TN7U5e+rL1z0lhsqAQPZE6UxpJ7PlCHYbGZ3vtRIDwdPpWxsNlZcrD74+A0ohnn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Johannes,

I wanted to check if this v4 aligns with your previous feedback regarding
the tight coupling with userspace tools.

The custom serialization has been removed entirely along with the bridge
tool. This series now focuses exclusively on passing raw binary inputs
via debugfs with the FUZZ_TEST_SIMPLE macro.

The decoupling eliminates any dependency on syzkaller and should help
remove some of the blockers that you previously encountered when
considering integration with other fuzzing engines.

Does this simplified design look closer to what you need?

Thanks,
Ethan

On Mon, Jan 12, 2026 at 8:28=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> This patch series introduces KFuzzTest, a lightweight framework for
> creating in-kernel fuzz targets for internal kernel functions.
>
> The primary motivation for KFuzzTest is to simplify the fuzzing of
> low-level, relatively stateless functions (e.g., data parsers, format
> converters) that are difficult to exercise effectively from the syscall
> boundary. It is intended for in-situ fuzzing of kernel code without
> requiring that it be built as a separate userspace library or that its
> dependencies be stubbed out.
>
> Following feedback from the Linux Plumbers Conference and mailing list
> discussions, this version of the framework has been significantly
> simplified. It now focuses exclusively on handling raw binary inputs,
> removing the complexity of the custom serialization format and DWARF
> parsing found in previous iterations.
>
> The core design consists of two main parts:
> 1. The `FUZZ_TEST_SIMPLE(name)` macro, which allows developers to define
>    a fuzz test that accepts a buffer and its length.
> 2. A simplified debugfs interface that allows userspace fuzzers (or
>    simple command-line tools) to pass raw binary blobs directly to the
>    target function.
>
> To validate the framework's end-to-end effectiveness, we performed an
> experiment by manually introducing an off-by-one buffer over-read into
> pkcs7_parse_message, like so:
>
> - ret =3D asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen);
> + ret =3D asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen + 1);
>
> A syzkaller instance fuzzing the new test_pkcs7_parse_message target
> introduced in patch 7 successfully triggered the bug inside of
> asn1_ber_decoder in under 30 seconds from a cold start. Similar
> experiments on the other new fuzz targets (patches 8-9) also
> successfully identified injected bugs, proving that KFuzzTest is
> effective when paired with a coverage-guided fuzzing engine.
>
> This patch series is structured as follows:
> - Patch 1 introduces the core KFuzzTest API, including the main
>   FUZZ_TEST_SIMPLE macro.
> - Patch 2 adds the runtime implementation for the framework
> - Patch 3 adds documentation.
> - Patch 4 provides sample fuzz targets.
> - Patch 5 defines fuzz targets for several functions in crypto/.
> - Patch 6 adds maintainer information for KFuzzTest.
>
> Changes since PR v3:
> - Major simplification of the architecture, removing the complex
>   `FUZZ_TEST` macro, the custom serialization format, domain
>   constraints, annotations, and associated DWARF metadata regions.
> - The framework now only supports `FUZZ_TEST_SIMPLE` targets, which
>   accept raw binary data.
> - Removed the userspace bridge tool as it is no longer required for
>   serializing inputs.
> - Updated documentation and samples to reflect the "simple-only"
>   approach.
>
> Ethan Graham (6):
>   kfuzztest: add user-facing API and data structures
>   kfuzztest: implement core module and input processing
>   kfuzztest: add ReST documentation
>   kfuzztest: add KFuzzTest sample fuzz targets
>   crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
>   MAINTAINERS: add maintainer information for KFuzzTest
>
>  Documentation/dev-tools/index.rst             |   1 +
>  Documentation/dev-tools/kfuzztest.rst         | 152 ++++++++++++++++++
>  MAINTAINERS                                   |   7 +
>  crypto/asymmetric_keys/Makefile               |   2 +
>  crypto/asymmetric_keys/tests/Makefile         |   4 +
>  crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    |  18 +++
>  .../asymmetric_keys/tests/rsa_helper_kfuzz.c  |  24 +++
>  include/asm-generic/vmlinux.lds.h             |  14 +-
>  include/linux/kfuzztest.h                     |  90 +++++++++++
>  lib/Kconfig.debug                             |   1 +
>  lib/Makefile                                  |   2 +
>  lib/kfuzztest/Kconfig                         |  16 ++
>  lib/kfuzztest/Makefile                        |   4 +
>  lib/kfuzztest/input.c                         |  47 ++++++
>  lib/kfuzztest/main.c                          | 142 ++++++++++++++++
>  samples/Kconfig                               |   7 +
>  samples/Makefile                              |   1 +
>  samples/kfuzztest/Makefile                    |   3 +
>  samples/kfuzztest/underflow_on_buffer.c       |  52 ++++++
>  19 files changed, 586 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/dev-tools/kfuzztest.rst
>  create mode 100644 crypto/asymmetric_keys/tests/Makefile
>  create mode 100644 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
>  create mode 100644 crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
>  create mode 100644 include/linux/kfuzztest.h
>  create mode 100644 lib/kfuzztest/Kconfig
>  create mode 100644 lib/kfuzztest/Makefile
>  create mode 100644 lib/kfuzztest/input.c
>  create mode 100644 lib/kfuzztest/main.c
>  create mode 100644 samples/kfuzztest/Makefile
>  create mode 100644 samples/kfuzztest/underflow_on_buffer.c
>
> --
> 2.51.0
>

