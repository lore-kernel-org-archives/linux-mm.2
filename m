Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 726EACAC5B0
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 02:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8599A8E0003; Fri,  3 Oct 2025 22:37:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80B218E0002; Fri,  3 Oct 2025 22:37:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F90D8E0003; Fri,  3 Oct 2025 22:37:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5FD3E8E0002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 22:37:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 11AAB45544
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 02:37:50 +0000 (UTC)
X-FDA: 83958871500.22.76A212B
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3A572A0007
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 02:37:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=M9ke1iw2;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759545468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WX2AvTRjoMsNn7rSSXm6NpMJfKCTCSB0TADy4mhOSmg=;
	b=w7FsEOJ5JBSfObkh8Y+4s3Ca6BJPtqGhLXmhIH7EqPsslr/LMa01CBQxuJJ2ttXM7TXZl7
	jU6uoST6aXItP40z1m/6IppfK5dfaiM5MAAVi5oZBJqUMD05CSE1swK8PbG3cUonhaLiiK
	aC01PFhjhPZCKYyWKLMnQ18sUSiLQmY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=M9ke1iw2;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759545468; a=rsa-sha256;
	cv=none;
	b=e1utdWXP4PvlVbxE4FGfcIlzLgCRsvEw5Tu4aErPhW+23J+clGX9OAWpNhdBpspHAcavgI
	lN+LAp92wY99U+63zCXpSPZSC52zsvgYCaQxX5mkkO5LLipxSxG3BlORzqkvo75XFn4azS
	HS09afnj+iJjcrR1ovvZK707wze9VSk=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-85d02580a07so337816485a.0
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 19:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759545467; x=1760150267; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WX2AvTRjoMsNn7rSSXm6NpMJfKCTCSB0TADy4mhOSmg=;
        b=M9ke1iw2P+0Nedsn1E50Av58P9EWUmuLI50dZqZuc+Dr2FJzvxicS+YYd/Z+90cvCU
         ZsCgbaPxRI3N/QvAjj/xDmSV9UzM3vifJS/j9IiiskD1nd0QvTyuEJoQ4dS6FYT7297M
         QwIHL2MBr7QX0Vs4t9Mr0qMAN+I0WFy+Foab+jZ6XBPpidlGNBMr22Y1pVOOVYKEENAn
         9i4uw/+1cWmam/BvOn8QdA5XX0cbNZBqNcBJFfBK+m6nNQtzdawrBlaLTe4AQUv45pCs
         oHe2Tjbrf2xchsqNVFd/Z9+40fW2120JsiYp+q8C0bZBju9/YI/jTgrBGCLwYDWmhWab
         M3HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759545467; x=1760150267;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WX2AvTRjoMsNn7rSSXm6NpMJfKCTCSB0TADy4mhOSmg=;
        b=dDXuWPPYPGmDsmEJJ8aFyQyHyFZOkWBAHIh4Ngc4aURqLIS3lKgW0dv99bnKmLUtMQ
         V18UTEofstKlsSOWVOEL9Y41eCkFth4eja05WhcQqiwh2l2eF4d2T5R5eHtYiB9gKv9z
         5nIWbC4TyztR+3WT8AlW+etKHxOUyKzzLdUf+ehF/j1MJonC30r9RnGBdZXN8q/Z0cxd
         x/SbFz4vWC3mPOD6gDlABDrfWO5Cy2b77tfWC9ziISC0cTWlqy3Gx287nLVVkWrnK+bq
         A25naU23zOq+ubG+bBzCVmR4eEfoDCaUCBdWMZIJXgElXnf+N9jKz6ZP42J/zZ3gu+gz
         r62Q==
X-Forwarded-Encrypted: i=1; AJvYcCXkmDbKCfe0xe5iViEMY3DXvJtwo8NHlCp+m4SONuUEy7PiVBwJx61J0VdaL1vWg/Na4e43jFWDkA==@kvack.org
X-Gm-Message-State: AOJu0Yy4psJ3bH8Zkx02ifUfyWoepPM0pACFz7vw1WutBwVhKqhug8KO
	clDeIfBak328UvhU1dfhx3rQfQfrPHSf3L8BoZc27JfGLc1EJLrZopkNVLr9UrOJuMfl3dMvlCu
	GZSdJ+J7AUM1i4jD4I1DxiKYwNHNIIwadYfF1riEMfQ==
X-Gm-Gg: ASbGncvwZOUX4D8Lp8WFJO+PLZuxsR/PFt6vtBdH3Y9aUbx2l0/yGH8FtBlvWMNw2mE
	k23PX8H1IuufHc3W+TDQK7DJt69uuxIkNTdV7whKzDWjf1C2Jf1q9Iv9uWhEYB6OCjdpHjUNkSb
	9QRxmZo1Bcv0UL6fJkFQ3wTvPBua0zcX7yLf68ta5oGwPZZdqwz5S4fePQIt3w0ycDz5H0GFTOD
	/ASzaEtW7tB5U2hC7nvPg0dp24H
X-Google-Smtp-Source: AGHT+IHpXmfwm/zD9D+zvb53ixNC14PQWRGIATDbgGewBobYXO/nEIYfu9ZMcBO3awLQMttSyQvIKLOwmKCMpwF49ms=
X-Received: by 2002:a05:620a:1a0e:b0:828:804a:47f2 with SMTP id
 af79cd13be357-87a32af5f30mr715143885a.9.1759545467113; Fri, 03 Oct 2025
 19:37:47 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <20250929010321.3462457-27-pasha.tatashin@soleen.com> <20251003225120.GA2035091.vipinsh@google.com>
 <CA+CK2bBuO5YaL8MNqb5Xo_us600vTe2SF_yMNU-O9D2_RBoMag@mail.gmail.com>
In-Reply-To: <CA+CK2bBuO5YaL8MNqb5Xo_us600vTe2SF_yMNU-O9D2_RBoMag@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 3 Oct 2025 22:37:10 -0400
X-Gm-Features: AS18NWAFqUB-LYy2SykxO160YAKxge0tVD8HRG9MgImFDuYaat9DVXaJFYTvN7M
Message-ID: <CA+CK2bBSObHG=9Rj623mahyhE81DhhKbN09aHS96p==8y_mCGw@mail.gmail.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3A572A0007
X-Stat-Signature: f3jkxx6k9for477nz3dpd5py4j6nnnh1
X-HE-Tag: 1759545468-941552
X-HE-Meta: U2FsdGVkX18wTJe3N77Nr65TEYlUx21mziXZFlYp/gp2rli3Fyth8J//XnasQNonCrqytvBLRXGG+hts8fF0zk+9Rh+1YX6vldkL46O668VlT4mTLwcrr7NqjlUwue5FYoHaavTXvzIEccQlo6UaL2icqAs0UWNiMG+W3Gi89jI94e1+kOYtVfb7PunoloJHH0wa3oug4ige/W76AgVO34nflRyluh/Bp7nGEfzZujETtS+i+T2KhAe+g2OMrTg1VAoZ0Jlvtxe1kP3tE7CmdBX1sim2EMnDUl0rRL2fRJfripSNWY27uWapGYph+pWfPHixg9n27jWdz/s+CBDmhh0YwE2By0pmT+MlYlBC4ihbOLbfHohDkR+uLG2L0aRByFSxcrEf62GCpgieWz6SlEStKsWnbyQt6cmiNqH3tOSHfyGPJ3rjXef350EjfvC3qOBm0TR7dr0bwADLRRRlxfc+qZ3lJrA/OuVGF+xd+f4URXVuPz7ezAkLYk7kZcdmaUYi5hPD+17DRTznNcGpkKi8KJ8YhrANJgTB2r67vCck1h6MAUj+tXOl85s31TOAcWMzvQzruO5DGw8hwG83Nmi+kFKszc+y5CM/z2JvwAR9sCGCZwJopSd7ysPeOgY7KeajtMJueUEAu38EmCaQ2r6Pz2fx2EFHlbS2KTGLy1uik5e5Kw5xksGi5FrKQZrS3Ptc0FYNsW+WVLVrhlq2qol3eO4mTeH4awntQVgnRhMrQobrkD8slYD8EHncH+g/qb3fP01REb6/yV5zsG9pTkmXHpsmOtnA8U3a7ejU25Mn/nHOz3ixLRHyfMbmPWhm3ZZUlL0SpZmJpnLQBPutHtjukc5fWwQ+vcKyZEEGmb5wBjUo+yIjkxiNDVShE+mHj/wSl3mPhvUXqGK5kAmH/3XB46Nh5mNSBDDk6Nfo4IN+CU07Tr4QVpAxe57NMwZHPRetfg8LpbsiL44dC40
 MFRwTQn4
 JrIuCKASSNZuhj+7Yc+zp+EI6C5wh1hpzakUFfrAHAisbaGfKj0hnJBeXwSYvgeTbdBtJs7/ca/lAIJKQ5O5PNVNLvIjTIPE1qhiW6UI/97G6En0c+HnYOYC8EDrSnzTJIhtONsLrqzEi8OnvPQNTBVIPe0Y33f3MWLP14anYqWEtZF2GgO49Dh01HaXG10jmmXKIUG+6scgeiwgjzliniTIBKEvEP1BqTHTgrilPuaNorCFOCPnkagbV84+50cTSJcitzuazgz7IASEWxrW8ZzQwCfQV3PpNgwWVKyllOAlPn3mJYP3s/NVnBi0x9CgxYiFoTVE49kXArEJ1uHgkwHIPJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 3, 2025 at 10:07=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On Fri, Oct 3, 2025 at 6:51=E2=80=AFPM Vipin Sharma <vipinsh@google.com> =
wrote:
> >
> > On 2025-09-29 01:03:17, Pasha Tatashin wrote:
> > > diff --git a/tools/testing/selftests/liveupdate/.gitignore b/tools/te=
sting/selftests/liveupdate/.gitignore
> > > index af6e773cf98f..de7ca45d3892 100644
> > > --- a/tools/testing/selftests/liveupdate/.gitignore
> > > +++ b/tools/testing/selftests/liveupdate/.gitignore
> > > @@ -1 +1,2 @@
> > >  /liveupdate
> > > +/luo_multi_kexec
> >
> > In next patches new tests are not added to gitignore.
>
> Will fix it, thanks.
>
> >
> > > diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/test=
ing/selftests/liveupdate/Makefile
> > > index 2a573c36016e..1cbc816ed5c5 100644
> > > --- a/tools/testing/selftests/liveupdate/Makefile
> > > +++ b/tools/testing/selftests/liveupdate/Makefile
> > > @@ -1,7 +1,38 @@
> > >  # SPDX-License-Identifier: GPL-2.0-only
> > > +
> > > +KHDR_INCLUDES ?=3D -I../../../usr/include
> >
> > If make is run from the tools/testing/selftests/liveupdate directory, t=
his
> > will not work because it needs one more "..".
> >
> > If this is built using selftest Makefile from root directory
> >
> >   make -C tools/testing/selftests TARGETS=3Dliveupdate
> >
> > there will not be build errors because tools/testing/selftests/Makefile
> > defines KHDR_INCLUDES, so above definition will never happen.
> >
> > >  CFLAGS +=3D -Wall -O2 -Wno-unused-function
> > >  CFLAGS +=3D $(KHDR_INCLUDES)
> > > +LDFLAGS +=3D -static
> >
> > Why static? Can't we let user pass extra flags if they prefer static
>
> Because these tests are executed in a VM and not on the host, static
> makes sense to be able to run in a different environment.
>
> > > +
> > > +# --- Test Configuration (Edit this section when adding new tests) -=
--
> > > +LUO_SHARED_SRCS :=3D luo_test_utils.c
> > > +LUO_SHARED_HDRS +=3D luo_test_utils.h
> > > +
> > > +LUO_MANUAL_TESTS +=3D luo_multi_kexec
> > > +
> > > +TEST_FILES +=3D do_kexec.sh
> > >
> > >  TEST_GEN_PROGS +=3D liveupdate
> > >
> > > +# --- Automatic Rule Generation (Do not edit below) ---
> > > +
> > > +TEST_GEN_PROGS_EXTENDED +=3D $(LUO_MANUAL_TESTS)
> > > +
> > > +# Define the full list of sources for each manual test.
> > > +$(foreach test,$(LUO_MANUAL_TESTS), \
> > > +     $(eval $(test)_SOURCES :=3D $(test).c $(LUO_SHARED_SRCS)))
> > > +
> > > +# This loop automatically generates an explicit build rule for each =
manual test.
> > > +# It includes dependencies on the shared headers and makes the outpu=
t
> > > +# executable.
> > > +# Note the use of '$$' to escape automatic variables for the 'eval' =
command.
> > > +$(foreach test,$(LUO_MANUAL_TESTS), \
> > > +     $(eval $(OUTPUT)/$(test): $($(test)_SOURCES) $(LUO_SHARED_HDRS)=
 \
> > > +             $(call msg,LINK,,$$@) ; \
> > > +             $(Q)$(LINK.c) $$^ $(LDLIBS) -o $$@ ; \
> > > +             $(Q)chmod +x $$@ \
> > > +     ) \
> > > +)
> > > +
> > >  include ../lib.mk
> >
> > make is not building LUO_MANUAL_TESTS, it is only building liveupdate.
> > How to build them?
>
> I am building them out of tree:
> make O=3Dx86_64 -s -C tools/testing/selftests TARGETS=3Dliveupdate instal=
l
> make O=3Dx86_64 -s -C tools/testing/selftests TARGETS=3Dkho install

Actually, I just tested in-tree and everything works for me, could you
please verify:

make mrproper  # Clean the tree
cat tools/testing/selftests/liveupdate/config > .config # Copy LUO depends.
make olddefconfig  # make a def config with LUO
make kvm_guest.config # Build minimal KVM guest with LUO
make headers # Make uAPI headers
make -C tools/testing/selftests TARGETS=3Dliveupdate install # make and
install liveupdate selftests

# Show that self tests are properly installed:
ls -1 tools/testing/selftests/kselftest_install/liveupdate/
config
do_kexec.sh
liveupdate
luo_multi_file
luo_multi_kexec
luo_multi_session
luo_unreclaimed

Pasha

