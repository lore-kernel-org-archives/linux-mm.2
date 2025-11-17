Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12AE6CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 19:28:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16E236B0006; Mon, 17 Nov 2025 14:28:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 145386B000C; Mon, 17 Nov 2025 14:28:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05B1B6B000E; Mon, 17 Nov 2025 14:28:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9DB46B0006
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:28:21 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8BFC3C025E
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:28:21 +0000 (UTC)
X-FDA: 84121085202.06.5349CCE
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id BA9B91C0011
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:28:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IPbmk6XH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763407699; a=rsa-sha256;
	cv=none;
	b=RQZjPknumIt507VHGegmQ2kpaJNm0rJ3suVECujCCKZuFEL60Y6N0pvQEisFDHWdTsxzaZ
	iTIpDhIiPhvSDzqiBEkHoj8VPl5N6u+Pahsno/fOd+8Q3mfWMXnjApqwlEV1Xer8M1VmEV
	WxPiDPo6qiyfOiJrCNVYrVyeIFyWr9I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IPbmk6XH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763407699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4BRv+8HFratcORC0sQfd604lhFEiEUlZ0QaYy4EdL4s=;
	b=19d6gwhYsBg5n9cxAzCjFDgDzzk7wo6G3F8rh4fVK9MxywNRIwd3Le1E4S18TKubR5NWXU
	CQxZm/KNkiTQPCBjH/TA5gKHAZI9jyidRIVsxWeK08H9aS8WXjZTSVafguGkeVWpHpMntU
	uklIgjgGaIOgDHeDCHAt7fBKTGPMETc=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-595910c9178so1181673e87.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763407698; x=1764012498; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4BRv+8HFratcORC0sQfd604lhFEiEUlZ0QaYy4EdL4s=;
        b=IPbmk6XHlK8G9ow0GpS3rMD3qzUc4jGv5aOyUo3W08bKRojO9rOspbVJ/Zi3YUzW3P
         keVIJeYBdH02gHRrJtNvWkPwzY1c4X0y+USNhmzBATUs3rP3hqBCaAQY8pL6dMISYvzw
         LAI9v9U5MJZOafSpjlqcvvAqsaaXQgeZRWewN87+cCmog/l+yabEOKBFQ7BdPpC01R3d
         rvjxI1OSSZ4MlvOLbQSSIa4vCqGvcafTM1MpoRTM1lir1xUXFpwE5XS3O/6gEX5+xfuM
         nqqnkbKn8y1yOEd5TWtXSA0b/PaiQgA8zcb49PEFS2gWskS5Q+8Mbt4KZqlRb8cTwAIg
         TJNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763407698; x=1764012498;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4BRv+8HFratcORC0sQfd604lhFEiEUlZ0QaYy4EdL4s=;
        b=sIuKufGrxOTsA8ORUvtgjeM48HcDwOFbZoasTq9VA42imkB22WVG8yka9xzSkcVDpy
         iNjmtaLT4hIucJ9lwmPBXJayqqoU+2JBnMzyLeBEKxTr6t8agMvk3wE08PimxzuDYA+w
         7MSO9jQ3luNf27lfTU+lIX98A1x7DC3sXUxPcyJSpb/p91ueFztcDsB7M7XNrxZItUSj
         Juh2k19j8qe/2Pvdl0Dk+/nH22nyCT82SYZ1Ebmad82xcoQSTTzsWynIARGaMizYBjaQ
         UV7lirkjEuBlYfSk2nRtRNJdw6VjLURdz+dbUNV4fiEoICvpzgcVqCy3DsqfEbwwSkg1
         T/gw==
X-Forwarded-Encrypted: i=1; AJvYcCVF4uRvAejnjClUXbioz8tj4E/Qk39UxUW+jpSmVFXXxKfCexyRW9B02tFu0aiHFoVbARuL/WjEGQ==@kvack.org
X-Gm-Message-State: AOJu0YwZ0VTZVoc04xpY1mS3N304nDmlwFOfY2ZiaTZhan8wWjaML7Q8
	1OLJWQ6xh/TnPo5a3GaRwRnDncY/dTUdZA5fOOKcEhDFAVATub9sL5Ond6fdoAitLwmZ9gyEQ6m
	szLRy2WhAXfehwVpvw1Nw6fvm2a9PmKfj0Nne5R4l
X-Gm-Gg: ASbGnctv4JCNjWBv6LOmnBQPB9j6+2uXm2ANd8UGRZLZI8CCa4nNQACGFJqupr7SgRy
	wu2MMYb/Gx1JOWKviB1ysyKnlpkAKjc55WrL330B2a928Rv1QFddnLFtcjpgFrdQ2amBKCS8lG0
	7bNaDa9Kv5uW/CqpecIfMY0GMFL3P4NaN/9ZA93FLiPtIkdjVwpUxvqSZuaaehuWZatq55pm2o3
	ePoRh5UrjKDZpQ7v0fKn1Itr426btzhYN1IA9ECz5NOIed+mauawrnOuJXRxt/cuPBpdR2nODP4
	/arxGQ==
X-Google-Smtp-Source: AGHT+IGG0IuV9djGbvzmPZdLLDSHaSz0ZC8Mlezk0LH8epioFYDWl+Qb1KTas1rmPphaGx6WZjM3247aMHYjmr5MYwI=
X-Received: by 2002:a05:6512:114f:b0:595:7dc5:165e with SMTP id
 2adb3069b0e04-595841a77femr4400958e87.25.1763407697311; Mon, 17 Nov 2025
 11:28:17 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com> <20251115233409.768044-19-pasha.tatashin@soleen.com>
In-Reply-To: <20251115233409.768044-19-pasha.tatashin@soleen.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 17 Nov 2025 11:27:44 -0800
X-Gm-Features: AWmQ_blZR7KFsAxkxa-ZIGOEZap3-3haAeROnQQby7Ige8teO6F_2irScEIZ73g
Message-ID: <CALzav=edxTsa7uO7XxiUSx+DZiX169T4WL39vYsn3_WcUuVKrg@mail.gmail.com>
Subject: Re: [PATCH v6 18/20] selftests/liveupdate: Add kexec-based selftest
 for session lifecycle
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, rppt@kernel.org, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BA9B91C0011
X-Stat-Signature: i9xtek8m3e6uzpkeie7jy8qthepoj7j8
X-Rspam-User: 
X-HE-Tag: 1763407699-393049
X-HE-Meta: U2FsdGVkX19xf+QNXy0ZoyShVXPzmwC0fENkV2m8agTfE5jMz/AzXCZKS/J36fDeO9HJQwjfsFLDwlgDmQu2A42zk3YYY+4o5sPFSXqvJgJTEV94BRKSk5zk/xdh7yMRr4T5CBcF5iINqK4kFw9svmhKEnnL3iDpfNiz8djDl97Zs0C3PCoHysOK8Z4g2PErgqE3CvAUt+Gmx6UHhwcHgOhK1SYD7LJr+6HK+4po6hBhBH4713sCmH2FUJnHJ0fB3/S26srL9yfZPy8Sk73cDFMSCou3LamfAwSua6U7Kk4m3TnOxpGPqzWU9tCL+ggWvWJV44Ln4AsXcn18WmTn/r5RgcuYS5dng+IKmYezBJczuks12UkoWrqJk9CV6qYOig8OijYCcW8WhC/ENu2wC/yvOEKEkx5XUucjRbDjSNAhA0jIowSbBmdV0/RpznxCWJGhmj6gyf6Ap+7T248tcxY5C6ROF/T8VMNnJmMOSZkcuejiCxFGEouIHmIF0IEnQdzjNe3Mh7EwRZ1fn9fTrTyHyLTIjMSxAmIlHVfkXH/dzlsdfkz5VTolacUbNWcOV/GmymFLi5JjulcUiZusjk90cy11o1AmgM5n0WmLD9VfSzpqjPbVkVtgpXAj+RbKW+D4eFgolAkKWihJFT740GCU3n5lv4ZKjty2uJHh/3AeQpQkqV5xUnRsiirB/AUP7MlGko2tcU0Ys/Q5ezIgj289PLQTw0b6JogYDJADQJt+uhSS17xF760+cJyeqfCn2HA2z7o1vwCxO5y3ivl/FUoxz13sFxQgFvHQ0edXlRtE+/KftHUM3pZYrqQ7N9OHA4tiXpAtN5sUde28lVZUTpmRp+7hAeiMEbYFMtHJC/Gf+kZOHQ9kcEsH/l/FjMHuKPyueQG7BQhjaMvyoB24tvuZ+nhpsDQrqQqTK//5+bcXTIR9jrKoHw+5XByMfYW1Wv81kGByP6P7UhYVN8w
 ZIythyO8
 Uo8y0IcwHJ5QulW0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 3:34=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:

> diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/=
selftests/liveupdate/Makefile
> index 2a573c36016e..1563ac84006a 100644
> --- a/tools/testing/selftests/liveupdate/Makefile
> +++ b/tools/testing/selftests/liveupdate/Makefile
> @@ -1,7 +1,39 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> +
> +KHDR_INCLUDES ?=3D -I../../../../usr/include

You shouldn't need to set this variable and $(OUTPUT). Both should be
provided by lib.mk. Maybe the include is too far down?

>  CFLAGS +=3D -Wall -O2 -Wno-unused-function
>  CFLAGS +=3D $(KHDR_INCLUDES)
> +LDFLAGS +=3D -static

Is static build really required or just for your setup? If it's
setup-specific, I would recommend letting the user pass in -static via
EXTRA_CFLAGS. That what we do in the KVM and VFIO selftests.

CFLAGS +=3D $(EXTRA_CFLAGS)

Then the user can pass EXTRA_CFLAGS=3D-static on the command line.

> +OUTPUT ?=3D .
> +
> +# --- Test Configuration (Edit this section when adding new tests) ---
> +LUO_SHARED_SRCS :=3D luo_test_utils.c
> +LUO_SHARED_HDRS +=3D luo_test_utils.h

I would suggest using the -MD flag and Make's -include directive to
automatically handle headers. That way you don't need to add every
header to Makefile for Make to detect changes. See the end of my email
for how to do this.

> +
> +LUO_MANUAL_TESTS +=3D luo_kexec_simple
> +
> +TEST_FILES +=3D do_kexec.sh
>
>  TEST_GEN_PROGS +=3D liveupdate
>
> +# --- Automatic Rule Generation (Do not edit below) ---
> +
> +TEST_GEN_PROGS_EXTENDED +=3D $(LUO_MANUAL_TESTS)
> +
> +# Define the full list of sources for each manual test.
> +$(foreach test,$(LUO_MANUAL_TESTS), \
> +       $(eval $(test)_SOURCES :=3D $(test).c $(LUO_SHARED_SRCS)))

This does not build with Google's gbuild wrapper around make. I get
these errors (after fixing the semi-colon issue below):

clang: error: no such file or directory: 'luo_kexec_simple.c'
clang: error: no such file or directory: 'luo_test_utils.c'
clang: error: no such file or directory: 'luo_test_utils.h'

> +
> +# This loop automatically generates an explicit build rule for each manu=
al test.
> +# It includes dependencies on the shared headers and makes the output
> +# executable.
> +# Note the use of '$$' to escape automatic variables for the 'eval' comm=
and.
> +$(foreach test,$(LUO_MANUAL_TESTS), \
> +       $(eval $(OUTPUT)/$(test): $($(test)_SOURCES) $(LUO_SHARED_HDRS) \
> +               $(call msg,LINK,,$$@) ; \
> +               $(Q)$(LINK.c) $$^ $(LDLIBS) -o $$@ ; \
> +               $(Q)chmod +x $$@ \

These semi-colons swollow any errors. I would recommend against using
a foreach and eval. Make supports pattern-based targets so there's
really no need for loops. See below.

> +       ) \
> +)
> +
>  include ../lib.mk

Putting it all together, here is what I'd recommend for this Makefile
(drop-in replacement for the current Makefile). This will also make it
easier for me to share the library code with VFIO selftests, which
I'll need to do in the VFIO series.

(Sorry in advance for the line wrap. I had to send this through gmail.)

# SPDX-License-Identifier: GPL-2.0-only

LIBLIVEUPDATE_C +=3D luo_test_utils.c

TEST_GEN_PROGS_EXTENDED +=3D luo_kexec_simple
TEST_GEN_PROGS_EXTENDED +=3D luo_multi_session

TEST_FILES +=3D do_kexec.sh

include ../lib.mk

CFLAGS +=3D $(KHDR_INCLUDES)
CFLAGS +=3D -Wall -O2 -Wno-unused-function
CFLAGS +=3D -MD
CFLAGS +=3D $(EXTRA_CFLAGS)

LIBLIVEUPDATE_O :=3D $(patsubst %.c, $(OUTPUT)/%.o, $(LIBLIVEUPDATE_C))
TEST_GEN_PROGS_EXTENDED_O +=3D $(patsubst %, %.o, $(TEST_GEN_PROGS_EXTENDED=
))

TEST_DEP_FILES +=3D $(patsubst %.o, %.d, $(LIBLIVEUPDATE_O))
TEST_DEP_FILES +=3D $(patsubst %.o, %.d, $(TEST_GEN_PROGS_EXTENDED_O))
-include $(TEST_DEP_FILES)

$(LIBLIVEUPDATE_O): $(OUTPUT)/%.o: %.c
        $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@

$(TEST_GEN_PROGS_EXTENDED): %: %.o $(LIBLIVEUPDATE_O)
        $(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $<
$(LIBLIVEUPDATE_O) $(LDLIBS) -o $@

EXTRA_CLEAN +=3D $(LIBLIVEUPDATE_O) $(TEST_GEN_PROGS_EXTENDED_O) $(TEST_DEP=
_FILES)

