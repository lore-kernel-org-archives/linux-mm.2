Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2D41CFD30D
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 22:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8984A6B0098; Sat, 22 Nov 2025 17:24:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 848286B0099; Sat, 22 Nov 2025 17:24:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EADE6B009B; Sat, 22 Nov 2025 17:24:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50C436B0098
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:24:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 29F684F319
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:31 +0000 (UTC)
X-FDA: 84139673142.08.7FEAD47
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5334C4000A
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BXnxMC2W;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763850269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oN/lyGO3w6uNr+x1AiuxSkRfzjl2Tv5KHczYeMQDvoM=;
	b=q0Y9HC8g3hWqwAHnVkfx1P0l/cIuTW0GYbi8/5akFwksw4TfUQ045HpelvoBTuj3/YDaIp
	HicoV6zWB1Imh7WtnsCeM7eppTDH+vEbtnIsLtoA6YDv6n74eLUK4dQxkX9kpb4ASyw9nO
	3STiCZ++PgwzPt0dus6sWFSWPS4NhTc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763850269; a=rsa-sha256;
	cv=none;
	b=gKbIQrzyj3jaJ9PYIFN5RiPLDV8bvkylftFyINWdbUO5+A6/CVWkQbIsMER7UqsiHdBQPa
	jpjD7haev9MlTa1Rqy1Ax8Y1ZIPOZeht7uA5blvJZeLlfB9DqMRz1LtMlO5l+2LwqhV18T
	Jt6IP0Pbaa+ZCSPf/+O4zu5jYj6ANh8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BXnxMC2W;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-63fc8c337f2so2979413d50.0
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763850268; x=1764455068; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oN/lyGO3w6uNr+x1AiuxSkRfzjl2Tv5KHczYeMQDvoM=;
        b=BXnxMC2Wev0p4Vlupt5OAAuGvMrnXr/+cyJ8nrzXINrjOag4nofNo+F0JQddJeaXFR
         PEXXROGt0PWdJhD4dqNb05W9aHMXPxC+hl9QAgmaxoQpHlcZqq+3/NMl05sY6BrWe3yM
         D/ciFDToBPfkDn8hPw8/+t26kCs/+oSsGj0ZffY1NGGYxOsmx/1+RkkpJqEJDpZArF8R
         QPxd3t93PxE7n2lr9+hLTmbmBCGFiawydU8f5bHe1SnqFi1arXCSCslvwo49h6nYnJV/
         1lwfYnTFvPYRjHrU1Xw/CPN7ESsb5Mn5SkGCDCNH4XRV9xU1J+h7DsXSmCj+B+vZXlg3
         mB1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763850268; x=1764455068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oN/lyGO3w6uNr+x1AiuxSkRfzjl2Tv5KHczYeMQDvoM=;
        b=XkIx/kiqaK4jIo6wVXPhFjIS7hfNeW5f+qw2UoyidUiHGQkCH6dqSdwfA/YX4DXleC
         yhq3A60uGGvvWcCMUUejZ3PqXMSkS5+4O7Z/l7PuuAUecO+E34AMAyefpkRVDPnjjIZ9
         M5oNi/mZ38P/EU0PIAYv2nok0UspgyNDBgu4qW/D9RPpjCsMOZbgGNUjbUH6rhB1LjN3
         PxR1uWJG+6NC2fjj56a5YR5tUIxWDA+mPJn/6c7lb+alXRGIGbrPaxkk5ZvWZ0wtXSG4
         TKBNa/nd6rfyyxnXZUSbHoo+BS2vUgYAYHvtoaid4ogoIOCxWisKpSyQ8YqCv8eQG/5q
         yMWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQs5vDwZQucqVH5Ed4H13rNTgZGAwxLCHAiT51gyxNsuQmpCbPcGwnVuCZ/FjZn2yOAqbdFZCNtA==@kvack.org
X-Gm-Message-State: AOJu0Yykyvdv8Dvpf3FGP9qKda1HiG3c8jXBaXX9qKH/FNH38kmjQfhM
	49Yd9HqKNX43qYdCkqU1qNGhgYZe1heQRhR4Q457MaLyh2tnEjlI5hd3zwDTbKTSu/s=
X-Gm-Gg: ASbGncvYAv9H/X2RsxUmVLsA5n5QP/OBZgC6+8yrcxn9d+am+ZF8bVTSIbeUHomdOTS
	irUga5SDSZCXpLsUZa7ADco2NAE83POS001U3JTT6xV+6H9ZNh2v7oXpfDQM9qg52Xi+QjKh1aY
	RIu1Dbblnpur500frP1sY6r6B/qQIF5fIXPRruCuQc/Mb0RJoerLBSlWbUP8nKNdgC7XBE4sYT4
	cw9lb1ylk0zZ9oe+k3k0QTmKptcL1JZ5KAjLx+TwDGZpIVI659cmUEGa9mZTTmuSen3FyzJbB/m
	4KgiVCglESW06g7PvFsPxVLti7ASUmGd9ej1DjksO60ewWA67CLU27yUa0118qna/Vc+HyPQMn2
	m/bx7+oDJMVhzX66GODr9lFRbi2/SzMX8L0DgBihEo5nS6OvoLxfr5JgssKMVf7Il+aF7M7zrUk
	hR8TUlG2PQytPMPxdUecByJs/PBOd/XJ6AltkiCwBt8T+vxDXX+7IGmcMiUPBASvRJSu+XPQX7N
	UA/+lo=
X-Google-Smtp-Source: AGHT+IF82eqDIem7nhAJwZNsrqSxav3QJ8c7jd8T4mCUjNEDwxXmd8be6sTBs6ajuflZe7SsNNOkLw==
X-Received: by 2002:a05:690c:e1e:b0:786:5afa:375c with SMTP id 00721157ae682-78a8b56859emr99751897b3.67.1763850268245;
        Sat, 22 Nov 2025 14:24:28 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79779a4esm28858937b3.0.2025.11.22.14.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 14:24:27 -0800 (PST)
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
Subject: [PATCH v7 16/22] selftests/liveupdate: Add userspace API selftests
Date: Sat, 22 Nov 2025 17:23:43 -0500
Message-ID: <20251122222351.1059049-17-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
In-Reply-To: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6r9f48opctmbe61y1qdg67iu685uxp3p
X-Rspam-User: 
X-Rspamd-Queue-Id: 5334C4000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1763850269-566945
X-HE-Meta: U2FsdGVkX1+DtID+FSrTjttlkLyaafuubRFmFDfvD49Q90eF5js0/cwtC7PArUYxYXSHm+Q8mHFcCGcQgEzpnD0N3qWlE6eO1iL/G7GVx/M9bfP9NgGKWeK2Yy2PlzBQsZfXhZ2QJjAPoxrHhpJO9sksHV7uY5KJUL/ebWmgbrMQHugtzWj7RZG8Ev8vBuxsVA5FlhS64L8px6jdLZdO4HQI5ymolMeiU2PqE/Sv4kSsIkwRnm4++xu6GPFGnHXcMOlPT+QU9Bi9zcSQ7DnXMlzhGEe7o9/0lA9CaDuUJWYogQ6zfST/q70+VNSXINd2vbAnUdNCeSgl08uGiIKry63xpwsWaogKdEFnKLsKQG4ogwnaVKA0yrP7y+Q8Ax7IbLz/9x6eFm0majaLeLwKIiqCcUlpcjUlNQ453Z56SipgMwNTSbLFxl9U/+EahyZAydY/ofTg5ZQEwpBM23opUOtYpW4RBTWhCo+VLs369ZcXVuysqsDh0p5rBDrOQiKj1xSECAX2f1nkgu6VuMmRZtvcgLk2Jyy2jRoI10ZoojLSTh9Iv05WT2Eap2mgOI3CnGZVZ1zDinp4Y+LPSVSfZ5JNoUB4AbIy7BzSJKVADKeKCNTRMZWR/DUxCbvBc4ePSd4diI0XyW+tQP+PWA4GRnPlwJp8FEVWOLDTACU+DMVkOyULvnpsNeRjdvlozI1zuP8H/vohkeoAJSfeGQYDnxbgumI0aA2q1fN9a2kaXWJOEcXnw29JLDgexVy+jDbak4JjGjNrsd0hewYvgfxBHs441KoEyIknwzZc3SH/jMizacqB9OH1/8RZsj6Ima3kTapD0V6JiD1MUzmJD5OxJRP3aO1tiAAxm0o5PJV5XVLrw8ZOchAy/u/5rzzeNbZQBjlwWPhDYK8d1WdsZssVuHhWCo+kscFR9350RL7hw6OKUBR57N0AvEUogxuaremRS/H4QZ0kwABIZ0D1+CQ
 wvUvQQv4
 EvBGGBhO2u2ZQKdFPghcrnnkTGpP88plGBn2eAV84wf9CwQlRNR3IwdbeHbI4Gvd7hlTehGQ9PRs4+WHpz4xWu2533r6wa/yZBhfDu6SpwFD6ULyeJUtkSz1FYIdlR7VqB+GVi9x+1p2/N1ByptBDCy6UBT8PW+QdeRwUD9Qkt5Mf7UP8t6e4cR81W+xvaT+qIUSO+NkmoXONkOxjZfBBP/Hyfw4GQlpY9QuBwF6wYLYeoPhFvd0kBxLAKUFXZO9AiKrbUJ9ioJKenOcAtuXBvCVG5jPpgMiPlbBUYOvm93tuanNUTeFVNeUXMHjOEQ0+9DYpPTYd+atP60k1aWd5hjKxbRf5ibh1/2Ou2OONO1NYVzjQ5foE8dN/s05lZtkZaaHKAEHSPoRPOvj+4f0/rvVLXbDfVEAoYYivGjgcIICD7WQ=
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
2.52.0.rc2.455.g230fcf2819-goog


