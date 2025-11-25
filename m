Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17B3AD0EE0F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A23A6B00A0; Tue, 25 Nov 2025 11:59:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07BBD6B00A1; Tue, 25 Nov 2025 11:59:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83D56B00A2; Tue, 25 Nov 2025 11:59:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF90B6B00A0
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:59:41 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96A5B1602E3
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:41 +0000 (UTC)
X-FDA: 84149740962.25.71507F0
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id A9E9420007
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=A5aqaXuT;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764089979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=56ycedZJemtskFHXt7gNPJP5doNt+tRE9168VaCAAZg=;
	b=czy1xlEoZXeVPj+Km0dgEdqIcwcTvG4+xjBVn8sadFgK/jYXY3kr+x3Ut5XOzPGL0vvY7x
	OFCuwabhYCelRE4UIr9l88xo29tnJHwVOI59kTK6A7SN2X0NqTh6vEjIeEuCznii+6R5iS
	/adbUaX8kgolgFjuRt5vDd6QyH1+SOk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=A5aqaXuT;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764089979; a=rsa-sha256;
	cv=none;
	b=ikNWwEZARG0KP+E5jNfn33kzGAEgiJf3DNzLbg4jt0QiSPLp89ZORi4LeJwuVR1hLluc4f
	x35BRI4eBpMXYHD1244NFi81sMMXL2esi8GT26/53MaPPP4To4OfRy86mpgFPvLkTv467m
	ycrt1l0fkAi+ejvqgge1xao+UPnTlU8=
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-640d4f2f13dso4748543d50.1
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764089978; x=1764694778; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=56ycedZJemtskFHXt7gNPJP5doNt+tRE9168VaCAAZg=;
        b=A5aqaXuTjR4NjUIovhTzTsgEHbwJNCJlyYFHmWpR3W2s8NMZTULNreaTjv7QwrW3m3
         sc2CspqHYjpyg498PH/ogJlwsCjeuOxKhRsjOdzof1kPzT4Ur67f8cM7hARIxoAKTu5V
         NXzQdz2OXlHFKewuObh/M5KFcXm104Cqi3CBY8+6FZlymzY1hNfmB7OuETI1UcnRp0/q
         u+Wtk7Iq1ITmdYVIpj+Gh5Ydr2PVOHohka+b+VAEtzHew5l8i088l3BYaIs7fowgkwU9
         UvB6+xgu4xAIiOmAkUQ/pfVESgIA0iwgJiSZVNPPFtftIdSZTtaZBskJ1mRnYGYCcgjY
         xWHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764089978; x=1764694778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=56ycedZJemtskFHXt7gNPJP5doNt+tRE9168VaCAAZg=;
        b=o6mbtVD99+ogQT7eHzZZRUQtVjl3/KNP9uqPia32CUi5Qsi9lJop4s049jhhbZqcOI
         fZYZiTIujumTHTUtAuJujzn0CAtLTo98oXx9EZ6uMfLENT5Ze3pj3viKut2CXLzxrZT5
         RH/1w+I48a5hEtRWAuXxayK99R9COKBDyhRUyyPZ8VqlGu0ylMI8AcxIgRrPPnQ97QqV
         fLHFvtsTRdJtr6v1WTAj1+LqkfwwJXZ8zjabDl3yZmHvUruU9TpP0cQWgpFTxpNhSBpj
         viOo95X7IYk/JdmBXTfw6HGxGoOI47kvuqZBaFgDoCVon3DPCkeDBmj2wg2FaLbodinm
         CaPQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0hfI4vp/G/ey649enW2n27TXaEqvRiVF7GjaukdGAuegSr315MB75C90GOa93Hl11eLRi1mSJzg==@kvack.org
X-Gm-Message-State: AOJu0YwvuIQ3szwmnVyD/YSs7v7oY8baSUFuQJX2xH71jTWtrJx7opOu
	Brx+0Fpf7APw4x1UqvDXYrdnfQ7qJ1W2RxNPTcPqnz/vaIKKv7hi7OvYn0WwSYQ4XBM=
X-Gm-Gg: ASbGncunkWjTEjCXeBeXfNSpXR6n/dOOzZlU7954DhrvFxAlDrt+trPLerLHcLNDXZ+
	R98u/EbFexx44tSfNquUqQdcw1SvEZvjanL2J0LjleIbtwh8tlLmOXMSjIlEgbMWS39iZpzs8ky
	emt53PxdYqJCkg8IO8LRiMQYM5lIjkcYWbG9xf+LPOKzVLlZaC3/+e0gBl5U2eS0hOEOM/h9VLz
	r8kw/dn/sN/5f6UjvCKRIKsBvRXA5VwIeRi9G9Ea2NxzE3MjUlie4mY5jrcE0GwbPImj1XSupkd
	ugT69TK7oinT6qo7bygsX7NhivAtuu8kwhcgrnf/ZFW4gQUyhGymRG28VmXJEbIQJTD01S0uZ6H
	K5/gTubD+WLXiT/lbOwcJ9eK66Djfg6O5Tr8cl0E5TFuTWF4nLVtNrcV4OdpYpR9MOtkvdtbvpk
	sPktWdV5lYz4V+jefSPYhgJBvC2Tj0NzVowujWh+yuRZkvFDLSIAxy2F3cKLsgmWgE
X-Google-Smtp-Source: AGHT+IFkPMOigFOoUXlZI1AX5lk4gQ7DF9aW/Qjd084DWZEkCwHhiHMRNCk0TlUzNybxB3Ue7agvUw==
X-Received: by 2002:a05:690e:1403:b0:641:f5bc:69a6 with SMTP id 956f58d0204a3-6432939b0e8mr2129643d50.84.1764089978372;
        Tue, 25 Nov 2025 08:59:38 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a798a5518sm57284357b3.14.2025.11.25.08.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 08:59:37 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org
Subject: [PATCH v8 16/18] selftests/liveupdate: Add userspace API selftests
Date: Tue, 25 Nov 2025 11:58:46 -0500
Message-ID: <20251125165850.3389713-17-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xkr4gzgqxbjqnbwkq3o1drw7j3gxsu3a
X-Rspam-User: 
X-Rspamd-Queue-Id: A9E9420007
X-Rspamd-Server: rspam09
X-HE-Tag: 1764089979-502823
X-HE-Meta: U2FsdGVkX1+uDiaTc3fONWsIQ/Jk4vpU73bvvFGGhWLOlikQqtLivNfkxvFJgCi5eWHKckOr3Ov4obQ/hgNBBZ6sqw9v9kfrV3kqFt9ikcQrbKa5IpZ/Q4ky4KnKlKpMTLp8eBcFCtqnEgP0hi5S/NVFggUq69VTYVbC2aJpWCfsML2N0SAhEDwDNqzZARqq9afTqEdLnd9O+bhDtAr/Twd7vj7nXlH4CI4niy2xso4Ts55lAHy0SyOWQ6sCB0LckyWbqPnWoxwka4isKVIbENPGtyI2Yd3Y/hmc0BHkYejiySSAW6LJvOtfA+/PUQuZYptPgulKZLh+Nomr1cIoM/LJefsHu2lAGcxxqXx96TgCdX4RVekW2jbBVMq+/kpIBFfBRl32di4zEHtRzQakAZ+sZJ2ZtG0JD4e/T2Y8lfJUk1Jmgt+8motc8Rz0z1Kxu2s7RES+258TdGGeDLktfXnyAtv4nqX7D1SPrEeTkzXyMk8An+wZYqA/KFwQgnIe77u748T/KXeYoKyhvCp6UwLfPqDOJ7Dkp3KC0t1q7eV750HLBJVK7/EZ73iTF34ZRs1dkuOI3excJ89zDMn9SxPzm8J2tZiLOtC9Izs2+ZeJS39YhLKYih2fnHE1BJgu/DpVuMK4Dx2OyMEdzzPxGZrtPuq0d4mVNfiOhVYQD2qhZZnYPoQRaenAbeb9/jgfyxRueUuqptMNWSmfypyA9BmRxS3HBlY10Wo75f6zuZznZOUKSGck8vilYviTyIMhLqMy6c90biOjDAhdPz6t/l1GhDJc4bx2FAEDYqkE5cwbcmjfK2FVuiscJGNE0bPq8/6tEwNHvmXZHDbDxTQkJ0QAJ1CA2Sxvk9jSFyl9fZ4Xnuo+jQvtrNWAORNShxvMiWGhjkjMiiEmvNlWQ++8zpjwJ2uYl0R3LVBS8lepx62n5mSmfAPuWab2bWOaYj/83aG0tKsLkyGYlBD+7cK
 nLB5uXHT
 6JXvHMvvAIYvlQ5MhX9UcMlPdbTRs9P4kiu6kIrsdRlr+D6a2h4NejxCmB3TwM0Xf0qWGphRPc/dYrFtPN+MRhBfkjRfkd9v/pFzqF4a8/4PfKgobuyU3JeRlbXS4KSZWrmuUhHycBXPES35Cb2RvocRBQs3TAnL52b61/Z8p8rh9AbA3dloCy0kyN717+niuqxT+1nqOtF8IxLozyJoLhP46gaBQ08ikwk7fMjNs+X6ZSbL4keoP42hdgZx8sl/5WyJsgiTkNC/vZ7jTa5iE3FXT+xymujPhbw5TBrNcnnEagw5qpWG3puEMN9Zl+D+Fq9lAaaca2WHuhDeerI4AxnDA4Ivf3mVjAsI/IN4AcOgD6Wx6TeZ4nAZla86IAhX/2eNxJPygp8zuFZ9+AG3AWGrcB5QTn8Wi3FYTOvzuVsupMNE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a selftest suite for LUO. These tests validate the core
userspace-facing API provided by the /dev/liveupdate device and its
associated ioctls.

The suite covers fundamental device behavior, session management, and
the file preservation mechanism using memfd as a test case. This
provides regression testing for the LUO uAPI.

The following functionality is verified:

Device Access:
    Basic open and close operations on /dev/liveupdate.
    Enforcement of exclusive device access (verifying EBUSY on a
    second open).

Session Management:
    Successful creation of sessions with unique names.
    Failure to create sessions with duplicate names.

File Preservation:
    Preserving a single memfd and verifying its content remains
    intact post-preservation.
    Preserving multiple memfds within a single session, each with
    unique data.
    A complex scenario involving multiple sessions, each containing
    a mix of empty and data-filled memfds.

Note: This test suite is limited to verifying the pre-kexec
functionality of LUO (e.g., session creation, file preservation).
The post-kexec restoration of resources is not covered, as the kselftest
framework does not currently support orchestrating a reboot and
continuing execution in the new kernel.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 MAINTAINERS                                   |   1 +
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/liveupdate/.gitignore |   9 +
 tools/testing/selftests/liveupdate/Makefile   |  27 ++
 tools/testing/selftests/liveupdate/config     |  11 +
 .../testing/selftests/liveupdate/liveupdate.c | 348 ++++++++++++++++++
 6 files changed, 397 insertions(+)
 create mode 100644 tools/testing/selftests/liveupdate/.gitignore
 create mode 100644 tools/testing/selftests/liveupdate/Makefile
 create mode 100644 tools/testing/selftests/liveupdate/config
 create mode 100644 tools/testing/selftests/liveupdate/liveupdate.c

diff --git a/MAINTAINERS b/MAINTAINERS
index cabbf30d50e1..83bac6c48c98 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14480,6 +14480,7 @@ F:	include/linux/liveupdate/
 F:	include/uapi/linux/liveupdate.h
 F:	kernel/liveupdate/
 F:	mm/memfd_luo.c
+F:	tools/testing/selftests/liveupdate/
 
 LLC (802.2)
 L:	netdev@vger.kernel.org
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index c46ebdb9b8ef..56e44a98d6a5 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -54,6 +54,7 @@ TARGETS += kvm
 TARGETS += landlock
 TARGETS += lib
 TARGETS += livepatch
+TARGETS += liveupdate
 TARGETS += lkdtm
 TARGETS += lsm
 TARGETS += membarrier
diff --git a/tools/testing/selftests/liveupdate/.gitignore b/tools/testing/selftests/liveupdate/.gitignore
new file mode 100644
index 000000000000..661827083ab6
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/.gitignore
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0-only
+*
+!/**/
+!*.c
+!*.h
+!*.sh
+!.gitignore
+!config
+!Makefile
diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
new file mode 100644
index 000000000000..620cb4ce85af
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -0,0 +1,27 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+TEST_GEN_PROGS += liveupdate
+
+include ../lib.mk
+
+CFLAGS += $(KHDR_INCLUDES)
+CFLAGS += -Wall -O2 -Wno-unused-function
+CFLAGS += -MD
+
+LIB_O := $(patsubst %.c, $(OUTPUT)/%.o, $(LIB_C))
+TEST_O := $(patsubst %, %.o, $(TEST_GEN_PROGS))
+TEST_O += $(patsubst %, %.o, $(TEST_GEN_PROGS_EXTENDED))
+
+TEST_DEP_FILES := $(patsubst %.o, %.d, $(LIB_O))
+TEST_DEP_FILES += $(patsubst %.o, %.d, $(TEST_O))
+-include $(TEST_DEP_FILES)
+
+$(LIB_O): $(OUTPUT)/%.o: %.c
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
+
+$(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/%: %.o $(LIB_O)
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $< $(LIB_O) $(LDLIBS) -o $@
+
+EXTRA_CLEAN += $(LIB_O)
+EXTRA_CLEAN += $(TEST_O)
+EXTRA_CLEAN += $(TEST_DEP_FILES)
diff --git a/tools/testing/selftests/liveupdate/config b/tools/testing/selftests/liveupdate/config
new file mode 100644
index 000000000000..91d03f9a6a39
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/config
@@ -0,0 +1,11 @@
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_KEXEC_FILE=y
+CONFIG_KEXEC_HANDOVER=y
+CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y
+CONFIG_KEXEC_HANDOVER_DEBUGFS=y
+CONFIG_KEXEC_HANDOVER_DEBUG=y
+CONFIG_LIVEUPDATE=y
+CONFIG_LIVEUPDATE_TEST=y
+CONFIG_MEMFD_CREATE=y
+CONFIG_TMPFS=y
+CONFIG_SHMEM=y
diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
new file mode 100644
index 000000000000..c2878e3d5ef9
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -0,0 +1,348 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+/*
+ * Selftests for the Live Update Orchestrator.
+ * This test suite verifies the functionality and behavior of the
+ * /dev/liveupdate character device and its session management capabilities.
+ *
+ * Tests include:
+ * - Device access: basic open/close, and enforcement of exclusive access.
+ * - Session management: creation of unique sessions, and duplicate name detection.
+ * - Resource preservation: successfully preserving individual and multiple memfds,
+ *   verifying contents remain accessible.
+ * - Complex multi-session scenarios involving mixed empty and populated files.
+ */
+
+#include <errno.h>
+#include <fcntl.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+
+#include <linux/liveupdate.h>
+
+#include "../kselftest.h"
+#include "../kselftest_harness.h"
+
+#define LIVEUPDATE_DEV "/dev/liveupdate"
+
+FIXTURE(liveupdate_device) {
+	int fd1;
+	int fd2;
+};
+
+FIXTURE_SETUP(liveupdate_device)
+{
+	self->fd1 = -1;
+	self->fd2 = -1;
+}
+
+FIXTURE_TEARDOWN(liveupdate_device)
+{
+	if (self->fd1 >= 0)
+		close(self->fd1);
+	if (self->fd2 >= 0)
+		close(self->fd2);
+}
+
+/*
+ * Test Case: Basic Open and Close
+ *
+ * Verifies that the /dev/liveupdate device can be opened and subsequently
+ * closed without errors. Skips if the device does not exist.
+ */
+TEST_F(liveupdate_device, basic_open_close)
+{
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist.", LIVEUPDATE_DEV);
+
+	ASSERT_GE(self->fd1, 0);
+	ASSERT_EQ(close(self->fd1), 0);
+	self->fd1 = -1;
+}
+
+/*
+ * Test Case: Exclusive Open Enforcement
+ *
+ * Verifies that the /dev/liveupdate device can only be opened by one process
+ * at a time. It checks that a second attempt to open the device fails with
+ * the EBUSY error code.
+ */
+TEST_F(liveupdate_device, exclusive_open)
+{
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist.", LIVEUPDATE_DEV);
+
+	ASSERT_GE(self->fd1, 0);
+	self->fd2 = open(LIVEUPDATE_DEV, O_RDWR);
+	EXPECT_LT(self->fd2, 0);
+	EXPECT_EQ(errno, EBUSY);
+}
+
+/* Helper function to create a LUO session via ioctl. */
+static int create_session(int lu_fd, const char *name)
+{
+	struct liveupdate_ioctl_create_session args = {};
+
+	args.size = sizeof(args);
+	strncpy((char *)args.name, name, sizeof(args.name) - 1);
+
+	if (ioctl(lu_fd, LIVEUPDATE_IOCTL_CREATE_SESSION, &args))
+		return -errno;
+
+	return args.fd;
+}
+
+/*
+ * Test Case: Create Duplicate Session
+ *
+ * Verifies that attempting to create two sessions with the same name fails
+ * on the second attempt with EEXIST.
+ */
+TEST_F(liveupdate_device, create_duplicate_session)
+{
+	int session_fd1, session_fd2;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd1 = create_session(self->fd1, "duplicate-session-test");
+	ASSERT_GE(session_fd1, 0);
+
+	session_fd2 = create_session(self->fd1, "duplicate-session-test");
+	EXPECT_LT(session_fd2, 0);
+	EXPECT_EQ(-session_fd2, EEXIST);
+
+	ASSERT_EQ(close(session_fd1), 0);
+}
+
+/*
+ * Test Case: Create Distinct Sessions
+ *
+ * Verifies that creating two sessions with different names succeeds.
+ */
+TEST_F(liveupdate_device, create_distinct_sessions)
+{
+	int session_fd1, session_fd2;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd1 = create_session(self->fd1, "distinct-session-1");
+	ASSERT_GE(session_fd1, 0);
+
+	session_fd2 = create_session(self->fd1, "distinct-session-2");
+	ASSERT_GE(session_fd2, 0);
+
+	ASSERT_EQ(close(session_fd1), 0);
+	ASSERT_EQ(close(session_fd2), 0);
+}
+
+static int preserve_fd(int session_fd, int fd_to_preserve, __u64 token)
+{
+	struct liveupdate_session_preserve_fd args = {};
+
+	args.size = sizeof(args);
+	args.fd = fd_to_preserve;
+	args.token = token;
+
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &args))
+		return -errno;
+
+	return 0;
+}
+
+/*
+ * Test Case: Preserve MemFD
+ *
+ * Verifies that a valid memfd can be successfully preserved in a session and
+ * that its contents remain intact after the preservation call.
+ */
+TEST_F(liveupdate_device, preserve_memfd)
+{
+	const char *test_str = "hello liveupdate";
+	char read_buf[64] = {};
+	int session_fd, mem_fd;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = create_session(self->fd1, "preserve-memfd-test");
+	ASSERT_GE(session_fd, 0);
+
+	mem_fd = memfd_create("test-memfd", 0);
+	ASSERT_GE(mem_fd, 0);
+
+	ASSERT_EQ(write(mem_fd, test_str, strlen(test_str)), strlen(test_str));
+	ASSERT_EQ(preserve_fd(session_fd, mem_fd, 0x1234), 0);
+	ASSERT_EQ(close(session_fd), 0);
+
+	ASSERT_EQ(lseek(mem_fd, 0, SEEK_SET), 0);
+	ASSERT_EQ(read(mem_fd, read_buf, sizeof(read_buf)), strlen(test_str));
+	ASSERT_STREQ(read_buf, test_str);
+	ASSERT_EQ(close(mem_fd), 0);
+}
+
+/*
+ * Test Case: Preserve Multiple MemFDs
+ *
+ * Verifies that multiple memfds can be preserved in a single session,
+ * each with a unique token, and that their contents remain distinct and
+ * correct after preservation.
+ */
+TEST_F(liveupdate_device, preserve_multiple_memfds)
+{
+	const char *test_str1 = "data for memfd one";
+	const char *test_str2 = "data for memfd two";
+	char read_buf[64] = {};
+	int session_fd, mem_fd1, mem_fd2;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = create_session(self->fd1, "preserve-multi-memfd-test");
+	ASSERT_GE(session_fd, 0);
+
+	mem_fd1 = memfd_create("test-memfd-1", 0);
+	ASSERT_GE(mem_fd1, 0);
+	mem_fd2 = memfd_create("test-memfd-2", 0);
+	ASSERT_GE(mem_fd2, 0);
+
+	ASSERT_EQ(write(mem_fd1, test_str1, strlen(test_str1)), strlen(test_str1));
+	ASSERT_EQ(write(mem_fd2, test_str2, strlen(test_str2)), strlen(test_str2));
+
+	ASSERT_EQ(preserve_fd(session_fd, mem_fd1, 0xAAAA), 0);
+	ASSERT_EQ(preserve_fd(session_fd, mem_fd2, 0xBBBB), 0);
+
+	memset(read_buf, 0, sizeof(read_buf));
+	ASSERT_EQ(lseek(mem_fd1, 0, SEEK_SET), 0);
+	ASSERT_EQ(read(mem_fd1, read_buf, sizeof(read_buf)), strlen(test_str1));
+	ASSERT_STREQ(read_buf, test_str1);
+
+	memset(read_buf, 0, sizeof(read_buf));
+	ASSERT_EQ(lseek(mem_fd2, 0, SEEK_SET), 0);
+	ASSERT_EQ(read(mem_fd2, read_buf, sizeof(read_buf)), strlen(test_str2));
+	ASSERT_STREQ(read_buf, test_str2);
+
+	ASSERT_EQ(close(mem_fd1), 0);
+	ASSERT_EQ(close(mem_fd2), 0);
+	ASSERT_EQ(close(session_fd), 0);
+}
+
+/*
+ * Test Case: Preserve Complex Scenario
+ *
+ * Verifies a more complex scenario with multiple sessions and a mix of empty
+ * and non-empty memfds distributed across them.
+ */
+TEST_F(liveupdate_device, preserve_complex_scenario)
+{
+	const char *data1 = "data for session 1";
+	const char *data2 = "data for session 2";
+	char read_buf[64] = {};
+	int session_fd1, session_fd2;
+	int mem_fd_data1, mem_fd_empty1, mem_fd_data2, mem_fd_empty2;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd1 = create_session(self->fd1, "complex-session-1");
+	ASSERT_GE(session_fd1, 0);
+	session_fd2 = create_session(self->fd1, "complex-session-2");
+	ASSERT_GE(session_fd2, 0);
+
+	mem_fd_data1 = memfd_create("data1", 0);
+	ASSERT_GE(mem_fd_data1, 0);
+	ASSERT_EQ(write(mem_fd_data1, data1, strlen(data1)), strlen(data1));
+
+	mem_fd_empty1 = memfd_create("empty1", 0);
+	ASSERT_GE(mem_fd_empty1, 0);
+
+	mem_fd_data2 = memfd_create("data2", 0);
+	ASSERT_GE(mem_fd_data2, 0);
+	ASSERT_EQ(write(mem_fd_data2, data2, strlen(data2)), strlen(data2));
+
+	mem_fd_empty2 = memfd_create("empty2", 0);
+	ASSERT_GE(mem_fd_empty2, 0);
+
+	ASSERT_EQ(preserve_fd(session_fd1, mem_fd_data1, 0x1111), 0);
+	ASSERT_EQ(preserve_fd(session_fd1, mem_fd_empty1, 0x2222), 0);
+	ASSERT_EQ(preserve_fd(session_fd2, mem_fd_data2, 0x3333), 0);
+	ASSERT_EQ(preserve_fd(session_fd2, mem_fd_empty2, 0x4444), 0);
+
+	ASSERT_EQ(lseek(mem_fd_data1, 0, SEEK_SET), 0);
+	ASSERT_EQ(read(mem_fd_data1, read_buf, sizeof(read_buf)), strlen(data1));
+	ASSERT_STREQ(read_buf, data1);
+
+	memset(read_buf, 0, sizeof(read_buf));
+	ASSERT_EQ(lseek(mem_fd_data2, 0, SEEK_SET), 0);
+	ASSERT_EQ(read(mem_fd_data2, read_buf, sizeof(read_buf)), strlen(data2));
+	ASSERT_STREQ(read_buf, data2);
+
+	ASSERT_EQ(lseek(mem_fd_empty1, 0, SEEK_SET), 0);
+	ASSERT_EQ(read(mem_fd_empty1, read_buf, sizeof(read_buf)), 0);
+
+	ASSERT_EQ(lseek(mem_fd_empty2, 0, SEEK_SET), 0);
+	ASSERT_EQ(read(mem_fd_empty2, read_buf, sizeof(read_buf)), 0);
+
+	ASSERT_EQ(close(mem_fd_data1), 0);
+	ASSERT_EQ(close(mem_fd_empty1), 0);
+	ASSERT_EQ(close(mem_fd_data2), 0);
+	ASSERT_EQ(close(mem_fd_empty2), 0);
+	ASSERT_EQ(close(session_fd1), 0);
+	ASSERT_EQ(close(session_fd2), 0);
+}
+
+/*
+ * Test Case: Preserve Unsupported File Descriptor
+ *
+ * Verifies that attempting to preserve a file descriptor that does not have
+ * a registered Live Update handler fails gracefully.
+ * Uses /dev/null as a representative of a file type (character device)
+ * that is not supported by the orchestrator.
+ */
+TEST_F(liveupdate_device, preserve_unsupported_fd)
+{
+	int session_fd, unsupported_fd;
+	int ret;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = create_session(self->fd1, "unsupported-fd-test");
+	ASSERT_GE(session_fd, 0);
+
+	unsupported_fd = open("/dev/null", O_RDWR);
+	ASSERT_GE(unsupported_fd, 0);
+
+	ret = preserve_fd(session_fd, unsupported_fd, 0xDEAD);
+	EXPECT_EQ(ret, -ENOENT);
+
+	ASSERT_EQ(close(unsupported_fd), 0);
+	ASSERT_EQ(close(session_fd), 0);
+}
+
+TEST_HARNESS_MAIN
-- 
2.52.0.460.gd25c4c69ec-goog


