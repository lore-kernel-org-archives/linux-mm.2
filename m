Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 075CDCCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 22:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A1C08E006E; Thu,  9 Oct 2025 18:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 451EF8E0002; Thu,  9 Oct 2025 18:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 319958E006E; Thu,  9 Oct 2025 18:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A9198E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 18:58:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE3821A0AF1
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 22:58:02 +0000 (UTC)
X-FDA: 83980090404.15.83E9F6D
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	by imf30.hostedemail.com (Postfix) with ESMTP id CA9EC80008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 22:58:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UFHCzXeZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=vipinsh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760050680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TS3X0oB2KcD5loH5VjDML1tNfmcYzwsUaHGn/yfIcO4=;
	b=2Kf7Pw/Fk6ji/hCwoSX6xjTpH9rRSuI0cVhmio3T5WKz8I8j1nnMEpE8XWy7yrbjeyk1Fs
	7QvlCcbDXMPMu+DTSs4P2x+jTIWLmy1HZTMRUFGvsrE0E+d9XqukR6kZqaVdkaWl5sKbO/
	jhYnfbsL/JXsrFpd7xduT0y242GwUqs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760050680; a=rsa-sha256;
	cv=none;
	b=zwuQB4xWcPGhq1sYFJKvVKh/OfHO8YPaS8WTMfs95vNnsu4MQh1oAVMEE0KFMK11An+Cm8
	WmpA2zHKb9PFVl3VCCC3zDnJS/vCg6wKrl1v9iTCQUi3TzzuIMSXQ/ql8KIJxyCLXFDxtB
	4XabcediyLilqz6vAUdiUmUdX10Dbik=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UFHCzXeZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=vipinsh@google.com
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2731ff54949so40625ad.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 15:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760050680; x=1760655480; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TS3X0oB2KcD5loH5VjDML1tNfmcYzwsUaHGn/yfIcO4=;
        b=UFHCzXeZi6Nfjyfs+H8KNVMR/cdBgfngAe2i1pPYOhglKDObsH5bT+8cBnXOg0Gq7U
         8p222XxVSCrLniM+0zMlHWyUC0OTULJGyyy6HjFQibxDjnfHcuQyV8gUja0Op8Z91wVq
         H0pSpCFMlPsU/AC9jLLtbrTUJWtcJ3RcRdfGeOjUNhBLsQP+ltyJWqxij2GfYuP1HGwW
         FuqfsbohuFCNJMjSTDpj+nH4ygwYWEq1N9Juho21wZxw89i+JsOrgRsUkAl7ZyeAnxNU
         4vAKti0ra5o6D0xkzVg8v1zv7kRmeO0vZbgB2ac8NOFRGvwqjPrOeLtqRIEMb4JkCPKd
         /c2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760050680; x=1760655480;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TS3X0oB2KcD5loH5VjDML1tNfmcYzwsUaHGn/yfIcO4=;
        b=Tcs6tqul7/6teS9m/5nBnUY9/dUO1cIv0TQA1iCFDURBYtc0XcyQ6SpDFPULBpXHNT
         0KgQF2JoUssTFKTXXCirP5xNwq3gTHf2u+R6/nuKoZOPcg/TeJQlvAuRZEt9Qm4HhRnA
         rhPkzlRo1OvKee3G5VqxQGUNEx7Dh6Y+NkwwFcjoAtp62W+AqUyVcdTUhGAsAJe6Wmr0
         Fmz/FMyP3QfnxQBqpJcizsHhh8VgY6MCAAXjwb4m0xAU9UVMytsMXBOErXxtjMLcwC9Z
         nBwnqGdcc28sXG5X4KTaQdvX5OjT9O/JNFclo8gzaySVYTdWKf+wPqFWaT7KBYlpmzzh
         7YmA==
X-Forwarded-Encrypted: i=1; AJvYcCX+1xVFD8YTnre+A3pWlb4St3/iDkHjF50IdvLwE509iQttc0WXRPKjo4gN1P6/ZCmJhYS762qzIw==@kvack.org
X-Gm-Message-State: AOJu0YyNCaq0YyWGu0DyQMAQ+UfuG93Bf6+ZV5F4988auCM5URVUBytO
	dx2qlMrqkJgb0saUNpQt7TWrR2wPoJ8Rfd/zg/FZ3XaXd0SaTyVJWsWxSSvMBFz2Qg==
X-Gm-Gg: ASbGncuVB5eVcaYsLijfonsVmV4cbwk3V2X7AQjm96xiIBqn6mqifrb0QzAIRIB/iHp
	mg9DZ8SymNOHcJ+WMIi5O+IUjS1/8RRFw7fu4P+ims/mjnMvRQQHosZw1VgDKEdSkkIHH/nkVvq
	5G9Za8MpktVnY8cjL/sqz9ZwC7VXxGSAycF+E1h6dSeWasBk6/smVp7MdU/KlxgO5dITk7JaOJH
	Vb0xqO8ZAFW25MwRcMjvHo1B9LVsoN2Y2u8TvxTsCisioQbHMsp+Vd0DWadO+KLcDHt24d0lRiS
	+6wC8FTk6bZRgxIdOz4UI4JAH+6MSC7NmEuRNCH9uY2wfNSdEIvBN8Hh9FNLGo+gOKR0LU6qEFG
	PNYJx3Vir39pU5UNVjL3WQMi4jZaK7L9j/eriTisz71FrS45Hxix0Uu8dFHMQqbW8z+van6/p/n
	Nq7ekkgfhiInc=
X-Google-Smtp-Source: AGHT+IEUelxecU4Ltxm3QGl/GGQDXbTCrG57RujR1Y9rUZidwWpY6H+v0tk5x12Foy4wJMi0lrd0zA==
X-Received: by 2002:a17:902:ce06:b0:269:63ea:6d3f with SMTP id d9443c01a7336-29027613a04mr13422595ad.8.1760050679106;
        Thu, 09 Oct 2025 15:57:59 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992b252f23sm847400b3a.6.2025.10.09.15.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 15:57:58 -0700 (PDT)
Date: Thu, 9 Oct 2025 15:57:48 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com,
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org, steven.sistare@oracle.com
Subject: Re: [PATCH v4 26/30] selftests/liveupdate: Add multi-kexec session
 lifecycle test
Message-ID: <20251009225748.GA2098969.vipinsh@google.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <20250929010321.3462457-27-pasha.tatashin@soleen.com>
 <20251003225120.GA2035091.vipinsh@google.com>
 <CA+CK2bBuO5YaL8MNqb5Xo_us600vTe2SF_yMNU-O9D2_RBoMag@mail.gmail.com>
 <CA+CK2bBSObHG=9Rj623mahyhE81DhhKbN09aHS96p==8y_mCGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bBSObHG=9Rj623mahyhE81DhhKbN09aHS96p==8y_mCGw@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: 435j347xyhgcqrk8hz81zxc4nhdy89yw
X-Rspam-User: 
X-Rspamd-Queue-Id: CA9EC80008
X-HE-Tag: 1760050680-56764
X-HE-Meta: U2FsdGVkX1/AiUYhwVLBiFh1b6P+grcu8Xb3dKdmQg/7frdaN+zh2Eaj5v82H5Af9aW7M6rdscpP0m3waIUDYx79dG0lKad4eRC1AAXRkFWMZwi2U2AO8zVuir7Fsx4tADw0rZ3usrpZ2K1HObNwexD9TIhlyE2kyYxd5Cl9YZZJEChWJGnUgTpLP1EwIVGwyEzTZOEOC+IjeilgNpvc1xi8cllnFMSVYR4eM9ZZGG2j2LAS09Ab8+OoT4/QJFHvvcaDtVdwGTiUMQsxtibtxyy1iFSsX5m0fcKxj3weZXV1FJOppcCBJdkVAmc/hdYshXC1KRBaPDBVK6uCGekUbLCzi8vEF6BnhYp7UASUHDaCqfa/B4zprE5ZLkACwYW7hgfPlq7UwCj8P4ptfycrMq7wzoHBkc57NyEC3bp+p5mxNjrBiTTmMVOulLL6X36ifZeGZBsgHX4AvO1jKbkrz9KcwURBWTnAUd6RRZ2zffsQf6JqoDSyZoL5nYdv22o1yOVM5pIfhmPzVfAQI8qELcIm0mFe6h0tiKa+GH4xfn4q6Kh8hMftGAsiTdhtLJhNz2iGi6O2SFiht+Jklx3CmXrjTK5CC2k3E3gaytFqCYA65b0fYxs9Uz5+caZyTzAKXPmpV7qblJ/+npvoUqN+65gN6ZvNjpfCCNNW+fqfhyMo3BY1Gh5cQKWqR2/T0NaIS3kj4JSN73Ca5OoRTSLWk3qZDLZWpLdRlzoDJIuirwzkjkziYrQi8//4WhasaSRXXLd21NSIQ+4e1+Szvm38ijbz7uJJmPQCFoUM7HcqLeq0ZFWgo0ew3vCk3ePWirlBpaFUkOBGiZAa9ZCyW85PwPjwtctizbbm3XfgTjg047vMqgZGsLnZkH84GdG+YdzAWmuGvqw4QOk3GQPumzdapF83T3HdyiYTfCopRJpp2ORRox1Iixs+S/u/p+8NLa07d3Vk7w+K8OADd+xe9vR
 PeHjzyVH
 9ePYFgpI+CQekuTGV8R2voeeNXQb/CfF+iYI71sB1mF7/i8qmupHD5ej73Wso69YYDuu6D7jsBU4UjzkPR3Z7RDJZXVywufR2vkfnFEgjYOlx3ZJ8jCb1+qzmnmeVBUQaWqTHkk/lkYV/GogRj++KNUwjm46y9W/PzybxO06FlsDMIhHryXONP4H02upoFPoRAuEFRlBfOJdeZOwju5sFTEEzjNEpuSW6teILbzHQVB+R82FzixmbbzzoHT7CUe4UeEbo01Fcbm/GU4mjtdeK8aSOeYC3l1FG04Nkt6dYVHWrZ5QEMjj8VVxWXOwL3sh49Nrbfw5D8YTs/NX+DZl4/VpPVWF+U1Mpu0s/NM5BvdWBc+/r0xkIstc7oDRMSh3Vir5wY9LmOY8VLQ06HQGtxrkb9nSFrZrD6eiq+JBVmXn8PFZ8jcVj+1j/CgTHHNv+yFTu/KDxvgtMUX1KcXV5zwP97PfHEiz8ZRZYexp7/w6nxDniT5VC8N7MPORP0/6FhrUzjqUj92uGDVROmLgiddgvJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-10-03 22:37:10, Pasha Tatashin wrote:
> > > > --- a/tools/testing/selftests/liveupdate/Makefile
> > > > +++ b/tools/testing/selftests/liveupdate/Makefile
> > > > @@ -1,7 +1,38 @@
> > > >  # SPDX-License-Identifier: GPL-2.0-only
> > > > +
> > > > +KHDR_INCLUDES ?= -I../../../usr/include
> > >
> > > If make is run from the tools/testing/selftests/liveupdate directory, this
> > > will not work because it needs one more "..".

This causes a build issue, see my response at the bottom.

> > >
> > > If this is built using selftest Makefile from root directory
> > >
> > >   make -C tools/testing/selftests TARGETS=liveupdate
> > >
> > > there will not be build errors because tools/testing/selftests/Makefile
> > > defines KHDR_INCLUDES, so above definition will never happen.
> > >

If one is just building test using the above make command (without
install) we don't see other liveupdate test binaries.

> > > > +# --- Test Configuration (Edit this section when adding new tests) ---
> > > > +LUO_SHARED_SRCS := luo_test_utils.c
> > > > +LUO_SHARED_HDRS += luo_test_utils.h
> > > > +
> > > > +LUO_MANUAL_TESTS += luo_multi_kexec
> > > > +
> > > > +TEST_FILES += do_kexec.sh
> > > >
> > > >  TEST_GEN_PROGS += liveupdate
> > > >
> > > > +# --- Automatic Rule Generation (Do not edit below) ---
> > > > +
> > > > +TEST_GEN_PROGS_EXTENDED += $(LUO_MANUAL_TESTS)
> > > > +
> > > > +# Define the full list of sources for each manual test.
> > > > +$(foreach test,$(LUO_MANUAL_TESTS), \
> > > > +     $(eval $(test)_SOURCES := $(test).c $(LUO_SHARED_SRCS)))
> > > > +
> > > > +# This loop automatically generates an explicit build rule for each manual test.
> > > > +# It includes dependencies on the shared headers and makes the output
> > > > +# executable.
> > > > +# Note the use of '$$' to escape automatic variables for the 'eval' command.
> > > > +$(foreach test,$(LUO_MANUAL_TESTS), \
> > > > +     $(eval $(OUTPUT)/$(test): $($(test)_SOURCES) $(LUO_SHARED_HDRS) \
> > > > +             $(call msg,LINK,,$$@) ; \
> > > > +             $(Q)$(LINK.c) $$^ $(LDLIBS) -o $$@ ; \
> > > > +             $(Q)chmod +x $$@ \
> > > > +     ) \
> > > > +)
> > > > +
> > > >  include ../lib.mk
> > >
> > > make is not building LUO_MANUAL_TESTS, it is only building liveupdate.
> > > How to build them?
> >
> > I am building them out of tree:
> > make O=x86_64 -s -C tools/testing/selftests TARGETS=liveupdate install
> > make O=x86_64 -s -C tools/testing/selftests TARGETS=kho install
> 
> Actually, I just tested in-tree and everything works for me, could you
> please verify:
> 
> make mrproper  # Clean the tree
> cat tools/testing/selftests/liveupdate/config > .config # Copy LUO depends.
> make olddefconfig  # make a def config with LUO
> make kvm_guest.config # Build minimal KVM guest with LUO
> make headers # Make uAPI headers
> make -C tools/testing/selftests TARGETS=liveupdate install # make and
> install liveupdate selftests

Yes, this one builds the tests.

However, if instead of using the above make command, we do

  cd tools/testing/selftests/liveupdate
  make

This will error out

    LINK     liveupdate
  liveupdate.c:19:10: fatal error: linux/liveupdate.h: No such file or directory
     19 | #include <linux/liveupdate.h>
        |          ^~~~~~~~~~~~~~~~~~~~
  compilation terminated.
  In file included from luo_test_utils.c:21:
  luo_test_utils.h:13:10: fatal error: linux/liveupdate.h: No such file or directory
     13 | #include <linux/liveupdate.h>
        |          ^~~~~~~~~~~~~~~~~~~~
  compilation terminated.
  In file included from <command-line>:
  /usr/include/stdc-predef.h:1: fatal error: cannot create precompiled header /liveupdate: Permission denied
      1 | /* Copyright (C) 1991-2025 Free Software Foundation, Inc.
  compilation terminated.
  make: *** [Makefile:30: /liveupdate] Error 1

Reason for this build error is KHDR_INCLUDES in the selftest/liveupdate/Makefile

Following fix resolves this above two "No such file or directory" error.

diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index 25a6dec790bb..6507682addac 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only

-KHDR_INCLUDES ?= -I../../../usr/include
+KHDR_INCLUDES ?= -I../../../../usr/include
 CFLAGS += -Wall -O2 -Wno-unused-function
 CFLAGS += $(KHDR_INCLUDES)
 LDFLAGS += -static

My git diff in the first response fixes build issue and generate tests.
https://lore.kernel.org/linux-mm/20251003225120.GA2035091.vipinsh@google.com/

I am used to kvm and vfio selftests. They both build all their binaries
by running 'make' from their directories. That's why I found it odd that
liveupdate is behaving differently.


