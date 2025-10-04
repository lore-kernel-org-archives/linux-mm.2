Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 739F8CCA471
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 02:08:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3B5B8E0006; Fri,  3 Oct 2025 22:08:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A12A18E0002; Fri,  3 Oct 2025 22:08:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 928358E0006; Fri,  3 Oct 2025 22:08:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 820A58E0002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 22:08:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23D0A1409AF
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 02:08:07 +0000 (UTC)
X-FDA: 83958796614.10.AB2D36A
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 32C5C8000C
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 02:08:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Q0l2SgzN;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759543685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUzxeZbPvk/JfjYehvQ9soJfDbesrcMGvdBByvWxU1A=;
	b=Fvhk0WKuR38Mhoptg8WNylzi83yOWOHL1GqIQ9PnF4sC1VgtMsFCuke6DbUNbqgCSz1vBq
	MnFBIO/8reFez76OU5LrHDt7WC1T5uD6ePXt3QJ9WKRFRB3JAqBT4l4EtrebToEEZ3QPAK
	K+NUYb5VnuII8I1v25j+D53GG4QcnR0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759543685; a=rsa-sha256;
	cv=none;
	b=rkCCxw1ck8ap336Y6Yja2JsZRYlwRkIhv0N14abItH8P6c7RxSeEQ026Ll5MB5MO7SFCu3
	HMgJ9pAHqXeZ8RSdyd2tyk+ZXVPBlxHPgPwpd8CxnvqpPVxYyKRI1k/mxsAY9eNvexGXtd
	dHJQFORklhcPvX5xe31powegKQNKT20=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Q0l2SgzN;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4de8bd25183so40460941cf.2
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 19:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759543684; x=1760148484; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EUzxeZbPvk/JfjYehvQ9soJfDbesrcMGvdBByvWxU1A=;
        b=Q0l2SgzN7v5dIQdpjnU6B8Cozircstpuv3dCkf1gzNATE1cL+/RPc/2dyD89zWgcxj
         CbX4f6W3xS1KZCH1qjW7hKmHVBalW9YK2jAmyv/PhmtLwUMQjcUV2GxWhI3lnuIjNbgD
         UfvILejqT35S4v+vaoiIzi292sYCWEFMmg4U/MsMybr+PhMxCPL1Eflt/LIhOtm9MwjM
         8i5RVh+V9wRUY4ZER/EctGeYtfGI6gEmYXqV5jplaKVhI7+p3yB4i/KSKTjMbPRuqllI
         cWqlSJ58p/0vNE0zuCMtuVqDDjIwt8r8j5TYeomO4P1HFOkyd3zUyndRueKlIkhvk5Hs
         GsDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759543684; x=1760148484;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EUzxeZbPvk/JfjYehvQ9soJfDbesrcMGvdBByvWxU1A=;
        b=mi5aIXC3eKJKbTYvYKePAQYszZGslG5l6fQmRZG/mmgFTFqQe67RXi8Ap1tOBh4fJa
         4as4VxS1cJFfJ5R2GY6CG5RsTZAitPp+iuglfeg0ylz3bXaz51SrsjY5FRISfczQ4tVJ
         jpjEnk4U75eW/cLwXMX1POGkWD6n+SYnRAvkAU7tJ1lI1uVzG/rAhTskTH0kC8cC1jZp
         QQyj/sNIM4X4e3sW7zX+4cgBL6jaGPPj5RhRpIuBZwWcB3HS1LY6NsOgj1XDXe6bUCbK
         AeQl8N5YRRZaCtvDxuaQIOjlXdMWJnqcPNlZQEVx5XaEmPJWfFLgSU1zhtM1snZYdH/v
         ez8g==
X-Forwarded-Encrypted: i=1; AJvYcCUuSc0fkAfTNCqn8rsh28buxeHCV8It2Uv1Cz/XLG+2Sq9d2KyidEvX0H2Vw1OW5gFmPQ4S1csBDw==@kvack.org
X-Gm-Message-State: AOJu0YxNWKjZumxtAIpSPYoZ/6ZXAJQRjW6OZiMPeAGiZLbc2KhezHqG
	wd95HaOv5IE5bG1uvHVYNHzCP38vNnqHt0HLWSRGKHQc1vbEQMNCC5Mq3U9q4UWaBs1zZyE/rfW
	xj8tKYGOE1K86Yq9MULWp7lAVkifcUJZrdrqQobxqQg==
X-Gm-Gg: ASbGncvGEO805U7CHythEqJdx5Ci81McYgW0uaDQcUH6jQCzMnepwStXJTZBU8bd/fn
	Pwx0RtypTb7ceKVZ2vXiukkQpr/XoaYFWu12gcwEqctpuQPMr0ndlJqUDs2DKI39ZHA2YgAKv9n
	kSrBuRvHeXr8pE6ScVRUXW2ghKWMgAdYP5uBzf5zdnlM3aHnrdh3AjPANAOLOMyQa8HlI/VgQM4
	Vhn80m3gYZZCOIZa1LrcFh/GEr2
X-Google-Smtp-Source: AGHT+IFAx1beBR5GfbaocbXfkSDXQDNMN60sJRbMybIKRDn++zqfipiOogFVh7nBoj/mLbN0/PW9BivaXIC2sgg2LhQ=
X-Received: by 2002:a05:622a:728d:b0:4dd:7572:216f with SMTP id
 d75a77b69052e-4e57e29e758mr31789071cf.32.1759543684209; Fri, 03 Oct 2025
 19:08:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <20250929010321.3462457-27-pasha.tatashin@soleen.com> <20251003225120.GA2035091.vipinsh@google.com>
In-Reply-To: <20251003225120.GA2035091.vipinsh@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 3 Oct 2025 22:07:27 -0400
X-Gm-Features: AS18NWBWoPm9Z7b0vbgm_XuBKnUybemYL0aTisq9eF8wk73w7jPTSRsrgP_RACE
Message-ID: <CA+CK2bBuO5YaL8MNqb5Xo_us600vTe2SF_yMNU-O9D2_RBoMag@mail.gmail.com>
Subject: Re: [PATCH v4 26/30] selftests/liveupdate: Add multi-kexec session
 lifecycle test
To: Vipin Sharma <vipinsh@google.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org, steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ftmawfj1xq6qqn5d5qcjzr37gx563c1i
X-Rspam-User: 
X-Rspamd-Queue-Id: 32C5C8000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1759543685-797364
X-HE-Meta: U2FsdGVkX19D6hBz3MRY3lMPddcnNOgey4g0QevIe8Xrbq9xR/n7UkVjX/PGkGX2Nx434SXbKhBAhym3v6vUB0tr1koISOaRGWu2DYV8gYf2VZbbNhFZ7kXE4ee8MRTBa4wiCKI8fJb9Um/cZIaGp3aAscqlYPa7zoswsqFxGNexdRysq/SO1Vo965DYGR5U3j7oO1SJbixvM/k8SbuZZBMkCsPnB30+0yj0ke6RkbvjW84yoM7W4m32WY26BPEMS0m1T6Viyv2uxTnlB4A8BIxkA06eyspoC6Hecoq3aA4Dl4abCRpIAt2Ysprm2FzN/g63Kd8RUv8dAMlneQO4ZniGnuVRAgwed9r0dU6DhhSm8ICVSzhNVFDhoHB3GTUnZJbQO74wxFk8HBIe/YkAZDJMFo9LVGL9iQ3EOwnxswLS4k/a58tunzaT+qTTL2UVas3B6d2Ts5RfvpDNG0BvjzLTqctGAyfJHJx0kE6nDJzf4pF0nvS6Ms2OPnR4D7QramqRNpqMTjRSgxbjtqimn8M/St0PkiNPAoYLOwKoJCU1YX3o+4DRhGZ0BBt75qQytcvJ0o0X6mqDEIF8qq+u7O0yEeVwJjYqWUzl79OoAPCHuCn55bdP+K8dfcYEnDnwmNYOUPELf8lfxS6Ld+JEt3fcy7h6ZCQkUUXiUjSg8ewDoOECh2KCFJjLibxEVmmjEafnLKN2ThycusacIyIoxnOdGec2koQxWNsu+5if1c16Ckq0UAGkznzIq/7o/QOqNiUZImcAnD8DCRM+Noy4Y8GhFZ+QSqk+36ZeZSMQ1yIjT34iCNf+hKv5uv+hG2pMLPLP9SeJYLsIyoQpLhCFUEqLUalMUA1H0wm+6BPmFdODruqRuAATgd3vjnmYKXN3n6AIxgMqKl1EPNpD/jaQ6i6fsdRVcnjt9P72rA1DWsPrBpcyn4kqmsY0EJuyYFelw/Nqasf4Nnz0Agvpp4o
 Xvd6ZM9p
 baEWrOzM03oZEUib7XgDO9L71TmXl6APUEkouHBl5uNoJL25LRDq0vxzEnB9g2GPepw8p7hiYhx65fpqHdsuJWRiboXI6spWd8DdS9KrXbwD8GMy+XjftqayOW2EWdqsnUV8qtFyzaxRphYemme4nTyo5ISI8TCm9/MDz823/mcgJdS7RfMigIjnuoP77POh6CvVeIjjk0z3maPznPH1+HskLwG5FrkbnWCU89FvXsKVIkN4XCdvxpdX60kdqyaybks8G0MQtOcHpRVd2VZcjVLR0SKEmrDcajswtLrjVrpa9OM6eYv5WR70cqY9QDnzaibFu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 3, 2025 at 6:51=E2=80=AFPM Vipin Sharma <vipinsh@google.com> wr=
ote:
>
> On 2025-09-29 01:03:17, Pasha Tatashin wrote:
> > diff --git a/tools/testing/selftests/liveupdate/.gitignore b/tools/test=
ing/selftests/liveupdate/.gitignore
> > index af6e773cf98f..de7ca45d3892 100644
> > --- a/tools/testing/selftests/liveupdate/.gitignore
> > +++ b/tools/testing/selftests/liveupdate/.gitignore
> > @@ -1 +1,2 @@
> >  /liveupdate
> > +/luo_multi_kexec
>
> In next patches new tests are not added to gitignore.

Will fix it, thanks.

>
> > diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testin=
g/selftests/liveupdate/Makefile
> > index 2a573c36016e..1cbc816ed5c5 100644
> > --- a/tools/testing/selftests/liveupdate/Makefile
> > +++ b/tools/testing/selftests/liveupdate/Makefile
> > @@ -1,7 +1,38 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> > +
> > +KHDR_INCLUDES ?=3D -I../../../usr/include
>
> If make is run from the tools/testing/selftests/liveupdate directory, thi=
s
> will not work because it needs one more "..".
>
> If this is built using selftest Makefile from root directory
>
>   make -C tools/testing/selftests TARGETS=3Dliveupdate
>
> there will not be build errors because tools/testing/selftests/Makefile
> defines KHDR_INCLUDES, so above definition will never happen.
>
> >  CFLAGS +=3D -Wall -O2 -Wno-unused-function
> >  CFLAGS +=3D $(KHDR_INCLUDES)
> > +LDFLAGS +=3D -static
>
> Why static? Can't we let user pass extra flags if they prefer static

Because these tests are executed in a VM and not on the host, static
makes sense to be able to run in a different environment.

> > +
> > +# --- Test Configuration (Edit this section when adding new tests) ---
> > +LUO_SHARED_SRCS :=3D luo_test_utils.c
> > +LUO_SHARED_HDRS +=3D luo_test_utils.h
> > +
> > +LUO_MANUAL_TESTS +=3D luo_multi_kexec
> > +
> > +TEST_FILES +=3D do_kexec.sh
> >
> >  TEST_GEN_PROGS +=3D liveupdate
> >
> > +# --- Automatic Rule Generation (Do not edit below) ---
> > +
> > +TEST_GEN_PROGS_EXTENDED +=3D $(LUO_MANUAL_TESTS)
> > +
> > +# Define the full list of sources for each manual test.
> > +$(foreach test,$(LUO_MANUAL_TESTS), \
> > +     $(eval $(test)_SOURCES :=3D $(test).c $(LUO_SHARED_SRCS)))
> > +
> > +# This loop automatically generates an explicit build rule for each ma=
nual test.
> > +# It includes dependencies on the shared headers and makes the output
> > +# executable.
> > +# Note the use of '$$' to escape automatic variables for the 'eval' co=
mmand.
> > +$(foreach test,$(LUO_MANUAL_TESTS), \
> > +     $(eval $(OUTPUT)/$(test): $($(test)_SOURCES) $(LUO_SHARED_HDRS) \
> > +             $(call msg,LINK,,$$@) ; \
> > +             $(Q)$(LINK.c) $$^ $(LDLIBS) -o $$@ ; \
> > +             $(Q)chmod +x $$@ \
> > +     ) \
> > +)
> > +
> >  include ../lib.mk
>
> make is not building LUO_MANUAL_TESTS, it is only building liveupdate.
> How to build them?

I am building them out of tree:
make O=3Dx86_64 -s -C tools/testing/selftests TARGETS=3Dliveupdate install
make O=3Dx86_64 -s -C tools/testing/selftests TARGETS=3Dkho install

And for me it worked, but I forgot to test with the normal make
options,  thank you for reporting, and providing your fixes, I will
address them.

Pasha

