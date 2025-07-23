Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73BD7C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:49:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E51A6B013C; Wed, 23 Jul 2025 10:48:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36D186B013D; Wed, 23 Jul 2025 10:48:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20F246B013E; Wed, 23 Jul 2025 10:48:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD546B013C
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:48:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D2234112EDE
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:48:00 +0000 (UTC)
X-FDA: 83695809120.09.EF7C585
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id 166411A0017
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=wequtP7u;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hShlI4m6hw+YtxzJd2p960yByHj9Zxa7UX6hlMU7/TY=;
	b=l+9KLxHbpK4L8JSK0maw9cqQ8E3iNHjS+7Gbel/v1IaAkLcbsm8LI+zMDXIFPrdUQUmL3t
	zRBCSCwKuRIt89x/vZ7Q13aSNNBQZwOhTLA8oEzrkVn0HXPmIFUrAXewHRCvgIdYxkilKf
	KjmrFlJl5JYttEPblnSlcucN7R5m1u0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=wequtP7u;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282079; a=rsa-sha256;
	cv=none;
	b=QTSJ4gPLyBNFuRQ78re0KOUSCmyAn3rk3ClSVWNp3RUCPD7+qKQz8E87IEwRTHtyqCV+58
	1ecUJWvPTW1b5KyXlUNyl8NqK+2a7x6YR3oNd8nwYigtA/KlsS8FLGjmeVKtKYEjKJ7DgG
	IwhdmSp6LdbmLSuJM6yJzFyexSLFdxo=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-70f862dbeaeso63747277b3.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282078; x=1753886878; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hShlI4m6hw+YtxzJd2p960yByHj9Zxa7UX6hlMU7/TY=;
        b=wequtP7uN9TMoSfjmGhdb2mQaYkfwtVNIH8I/xzK9jnXGFxsM1jMOcPagD3bD6UFFh
         lD90KFf3RVht7abSX0jEIkGf12uk2t2KsJfBkIbm7k+tnK+b87YxZ9jzHOL48u1HvMj9
         v4Fu5ihK1JhiloJtUlhZzjfGisZ04wV7tY2r49Ku0ldPK3ddgocvmBJrfxmPOcpyC8/h
         PvErlpR9Zh2c8wxiUsEJSoNP85I4gbZhsO1RXkREyU9DHD6XSlJ/THYpiQjjIgQd9p8I
         mYAPpaFBxmlMbVeDFDonWlhJOh4pb4a0mtaLOC+xN4mHrqt2e6EAI7LbG3s7p/f7WC8w
         ioxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282078; x=1753886878;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hShlI4m6hw+YtxzJd2p960yByHj9Zxa7UX6hlMU7/TY=;
        b=QlCzrF14rwjXGaboLGzNjr6XpENX+pDTOsucOOixpGcJhtF3gZJGJbV73GGAlnMMWJ
         4ALHRl5DWmMiSKvM52FoXCkfO60Nuk5U4LpnRCimITp8uQFYYsjaKSBf0kQ4rtvITAbz
         pb9BZoP60rO31R3t9dQsQuIJcCsvAOQDhPogJp1BsPycdaH9x5UWCV/6jcQiVm0VOguR
         MPs8lfyjFpFApDoF7GKJu81kDN/1n50hQ04wlUDMx2sAMWN/1pnJGHIHCb7NsaGQovr5
         8lr99/8FsRo+4RqETekwlLaAAl0pIGzu1RGmkMBuijPewbAI9Py6fLZu1XsdIqocDnv5
         pvbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwFtqFWHq7PWR4hKYQ0KGlqnIqZu0vSV/JvLZKBodX4yeCcfwkFs2hPPZL/BbJd8AHgUZugO6HsQ==@kvack.org
X-Gm-Message-State: AOJu0YwjJAP/Xy+KnuYK30oNy42vSSvy+eBCG9/Mjd6WwXKFPe7xN6zv
	V1cXFg0FjBsUPsyIGT7NzmXR6VN6XjA2zbc2AxgTxY9D5g82AMSp9o2xygVYdb58dUo=
X-Gm-Gg: ASbGncsDRSTAUJQIfmygtif7+7cABIslE5OgkXta36zhGBGK5Mz42CA5iZP2FcSIoEv
	oS8ZNlcLOGyi9feR+Zn00285BtwvGoVdCTc8YRMf24DNItMbFcodpEKO2HNEKNOoH0CQKOggcBl
	C9H2bLaRZB4cK3KkPuBj1oZYaxWJpBIxLdsmYtyV7CA3Znx7cIdwpBrrEC9JL//cUNZVCTIToch
	27PS7iDq/siDfI5/b4QGqjrGi4CCJR1KYKnVueTOzal8CVfWXi2AS6ueWSf3h7VsySnZ14cL5Gi
	d7/ndAsnucQc0fBfsgLk9pDxJ2UnYVQ6czO73G22W/cN3/Kx/1y4Yizq0lrXYtjO9zI8LuCzq9r
	6SdZP3SkDKhwem31OXl/C1iwIScBp4hJz165VfoaqxfWb/47elr8tC5mX5Xjw4voTdU5thf3mmw
	mWFrVwCunLIKIJ5w==
X-Google-Smtp-Source: AGHT+IH675RnRNbWShRM8kSWIrUMBTag3AVm1BnglGtYW6J1tHoiU+7BSxfTq41Ub2U0xE0WezZ+cg==
X-Received: by 2002:a05:690c:9a0d:b0:719:671d:255 with SMTP id 00721157ae682-719b41e6aeamr42227787b3.3.1753282078060;
        Wed, 23 Jul 2025 07:47:58 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:57 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
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
	zhangguopeng@kylinos.cn,
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
	witu@nvidia.com
Subject: [PATCH v2 31/32] libluo: introduce luoctl
Date: Wed, 23 Jul 2025 14:46:44 +0000
Message-ID: <20250723144649.1696299-32-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8aq68jp4ogn99rj7b8w91drrpfczfn4n
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 166411A0017
X-Rspam-User: 
X-HE-Tag: 1753282078-931650
X-HE-Meta: U2FsdGVkX1/2gBBFpl7SWS9DIyPFfrPUhgBkzwB8xM1bjwfUOYFcDhpYqnETNRutmn2kRLhkVmBqgmtofwjzpW6EY5mq+JGAVRr6DGhmoM3TeUv/XEGsiIKRbBCC4G9FadZDdhwmUTSsPG6vcFG7vKADg1FKrPmsd1vlvc+oIxluUBgPUp20j+LGkc8zzkfcMnJhMOJ3D4AIG665r/X47Bbkks/DSNDT2yWD3Vj8YIodmhjpgUJExDMp7jS2VZ0jZ6Xmw8PIgAJ7dqRhsZEib9NjgVXoBvPstfTT8o6LkGksmvq68Ytezo5+t4rXVLN5sOVxknT8ym0m5qxFdhk1QMt1cZRj2glAU6g0stF6CSsjSPh3HLTuJQtDyUOZSqCxXhRFFvQP6U6zrRTcPtpebGXyD9KvD78eMRCtd+hZVLMOywG/fl1tUKLwiSVFTOr+/whJSiXcv/bdepEAkMA870P0vhgvT0iOPVl0hNHmXPybfR8tPN8q011D0QMRaFW4kWops31EnkqYEiK6td0owAByDWIO0CS9C+5CNLluM2sN5MlgD8kom2Rs17W8j+P7EJavMr9Ug67LKsIvStRVi5D9vdTxe6Yly3GGAk3YVmWrywKy5E+LORA6lg0kgQZ98nKk/lTnIm8URYYte4TRGSZ0Wj3GZc/pQwsMbLAJnyOhAZAwjJQOZV9qJyqOmvmhaNzfqa+VnQ2ulzurHOxD89WlXgPwgfcNZJlF/nfhQXBJqlwLkNNVde16EfEwddJAoxqDHxLkiDycF4zuAM6vkxOqiD5S1jItpr51BMToTmT4zYPCOiqx63/yzC7CJZeTQlHyyPw2o9+sQBsu8MFQcWaHsJ+izQcve3mdY2fcwRt4RfnjjRdKbxbrtfiWSZq42TNdbDEHsZHKfZtyd18BWZQ342HyF6YoRd+iA2ExWdKkOrGZU39faguodlYd0d5HSZP2Z/Fj2MJaCIjmecn
 mB8dMso0
 8c3UNrAXVcsrscnAxnYrY4r9FY258CyjMHmv0p2nlWYiaC9Vm7M5zN1Sy+gg79kWXTZ6Gmr9OMbMcG/BoempNVg+ypZsZ2vzXQl0CZl9DPtPf4HqZ5b0H6DMbVoViIsfUAVqd8y434T5xXhwRu9rFoD/Crh93aPF9BjXfbhGxISjKfntKwxegmlwLnTZ5DKDiszL/Ko65RaZcgcNwLGpVI8JaZv5FKZPiZ3hcQ0K6YVK0YqbThG8DfaO4zmBB+McRDxN4tmjkiaHGWdKB8g/vum9Z6d//40E7dvT6OYnPjWrv2L/dj09CcKXYbipns9SUKWA9O39Xl+KIeUWqjqC6EHwXQ6LJloCzYrLLY6IIQviKF7Vuk6TWJuKkvtoYy3S3A7XE3p2d9gFeDTiVPPbivvJ6tvS68kDPdgxRNh6FQLN2gJNsZc6i2IhydTcoGdshgMoLA9W6VpQvq0u25Aslt2+ziGKP/0z6UpExhjytgrUgvN8V+lYtkf87eQBac8X4orZRjrv4lW0gl2U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Yadav <ptyadav@amazon.de>

luoctl is a utility to interact with the LUO state machine. It currently
supports viewing and change the current state of LUO. This can be used
by scripts, tools, or developers to control LUO state during the live
update process.

Example usage:

    $ luoctl state
    normal
    $ luoctl prepare
    $ luoctl state
    prepared
    $ luoctl cancel
    $ luoctl state
    normal

Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 tools/lib/luo/Makefile       |   6 +-
 tools/lib/luo/cli/.gitignore |   1 +
 tools/lib/luo/cli/Makefile   |  18 ++++
 tools/lib/luo/cli/luoctl.c   | 178 +++++++++++++++++++++++++++++++++++
 4 files changed, 202 insertions(+), 1 deletion(-)
 create mode 100644 tools/lib/luo/cli/.gitignore
 create mode 100644 tools/lib/luo/cli/Makefile
 create mode 100644 tools/lib/luo/cli/luoctl.c

diff --git a/tools/lib/luo/Makefile b/tools/lib/luo/Makefile
index e851c37d3d0a..e8f6bd3b9e85 100644
--- a/tools/lib/luo/Makefile
+++ b/tools/lib/luo/Makefile
@@ -13,7 +13,7 @@ LIB_NAME = libluo
 STATIC_LIB = $(LIB_NAME).a
 SHARED_LIB = $(LIB_NAME).so
 
-.PHONY: all clean install
+.PHONY: all clean install cli
 
 all: $(STATIC_LIB) $(SHARED_LIB)
 
@@ -26,8 +26,12 @@ $(SHARED_LIB): $(OBJS)
 %.o: %.c $(HEADERS)
 	$(CC) $(CFLAGS) -c $< -o $@
 
+cli: $(STATIC_LIB)
+	$(MAKE) -C cli
+
 clean:
 	rm -f $(OBJS) $(STATIC_LIB) $(SHARED_LIB)
+	$(MAKE) -C cli clean
 
 install: all
 	install -d $(DESTDIR)/usr/local/lib
diff --git a/tools/lib/luo/cli/.gitignore b/tools/lib/luo/cli/.gitignore
new file mode 100644
index 000000000000..3a5e2d287f60
--- /dev/null
+++ b/tools/lib/luo/cli/.gitignore
@@ -0,0 +1 @@
+/luoctl
diff --git a/tools/lib/luo/cli/Makefile b/tools/lib/luo/cli/Makefile
new file mode 100644
index 000000000000..6c0cbf92a420
--- /dev/null
+++ b/tools/lib/luo/cli/Makefile
@@ -0,0 +1,18 @@
+# SPDX-License-Identifier: LGPL-3.0-or-later
+LUOCTL = luoctl
+INCLUDE_DIR = ../include
+HEADERS = $(wildcard $(INCLUDE_DIR)/*.h)
+
+CC = gcc
+CFLAGS = -Wall -Wextra -O2 -g -I$(INCLUDE_DIR)
+LDFLAGS = -L.. -l:libluo.a
+
+.PHONY: all clean
+
+all: $(LUOCTL)
+
+luoctl: luoctl.c ../libluo.a $(HEADERS)
+	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
+
+clean:
+	rm -f $(LUOCTL)
diff --git a/tools/lib/luo/cli/luoctl.c b/tools/lib/luo/cli/luoctl.c
new file mode 100644
index 000000000000..39ba0bdd44f0
--- /dev/null
+++ b/tools/lib/luo/cli/luoctl.c
@@ -0,0 +1,178 @@
+// SPDX-License-Identifier: LGPL-3.0-or-later
+/**
+ * @file luoctl.c
+ * @brief Simple utility to interact with LUO
+ *
+ * This utility allows viewing and controlling LUO state.
+ *
+ * Copyright (C) 2025 Amazon.com Inc. or its affiliates.
+ * Author: Pratyush Yadav <ptyadav@amazon.de>
+ */
+
+#include <libluo.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <string.h>
+#include <errno.h>
+#include <getopt.h>
+
+#define fatal(fmt, ...)					\
+	do {						\
+		fprintf(stderr, "Error: " fmt, ##__VA_ARGS__);	\
+		exit(1);				\
+	} while (0)
+
+struct command {
+	char *name;
+	int (*handler)(void);
+};
+
+static void usage(const char *prog_name)
+{
+	printf("Usage: %s [command]\n\n", prog_name);
+	printf("Commands:\n");
+	printf("  state         - Show current LUO state\n");
+	printf("  prepare       - Prepare for live update\n");
+	printf("  cancel        - Cancel live update preparation\n");
+	printf("  finish        - Signal completion of restoration\n");
+}
+
+static enum liveupdate_state get_state(void)
+{
+	enum liveupdate_state state;
+	int ret;
+
+	ret = luo_get_state(&state);
+	if (ret)
+		fatal("failed to get LUO state: %s\n", strerror(-ret));
+
+	return state;
+}
+
+static int show_state(void)
+{
+	enum liveupdate_state state;
+
+	state = get_state();
+	printf("%s\n", luo_state_to_string(state));
+	return 0;
+}
+
+static int do_prepare(void)
+{
+	enum liveupdate_state state;
+	int ret;
+
+	state = get_state();
+	if (state != LIVEUPDATE_STATE_NORMAL)
+		fatal("can only switch to prepared state from normal state. Current state: %s\n",
+		      luo_state_to_string(state));
+
+	ret = luo_prepare();
+	if (ret)
+		fatal("failed to prepare for live update: %s\n", strerror(-ret));
+
+	return 0;
+}
+
+static int do_cancel(void)
+{
+	enum liveupdate_state state;
+	int ret;
+
+	state = get_state();
+	if (state != LIVEUPDATE_STATE_PREPARED)
+		fatal("can only cancel from normal state. Current state: %s\n",
+		      luo_state_to_string(state));
+
+	ret = luo_cancel();
+	if (ret)
+		fatal("failed to cancel live update: %s\n", strerror(-ret));
+
+	return 0;
+}
+
+static int do_finish(void)
+{
+	enum liveupdate_state state;
+	int ret;
+
+	state = get_state();
+	if (state != LIVEUPDATE_STATE_UPDATED)
+		fatal("can only finish from updated state. Current state: %s\n",
+		      luo_state_to_string(state));
+
+	ret = luo_finish();
+	if (ret)
+		fatal("failed to finish live update: %s\n", strerror(-ret));
+
+	return 0;
+}
+
+static struct command commands[] = {
+	{"state", show_state},
+	{"prepare", do_prepare},
+	{"cancel", do_cancel},
+	{"finish", do_finish},
+	{NULL, NULL},
+};
+
+int main(int argc, char *argv[])
+{
+	struct option long_options[] = {
+		{"help", no_argument, 0, 'h'},
+		{0, 0, 0, 0}
+	};
+	struct command *command;
+	int ret = -EINVAL, opt;
+	char *cmd;
+
+	if (!luo_is_available()) {
+		fprintf(stderr, "LUO is not available on this system\n");
+		return 1;
+	}
+
+	while ((opt = getopt_long(argc, argv, "ht:e:", long_options, NULL)) != -1) {
+		switch (opt) {
+		case 'h':
+			usage(argv[0]);
+			return 0;
+		default:
+			fprintf(stderr, "Try '%s --help' for more information.\n", argv[0]);
+			return 1;
+		}
+	}
+
+	if (argc - optind != 1) {
+		usage(argv[0]);
+		return 1;
+	}
+
+	cmd = argv[optind];
+
+	ret = luo_init();
+	if (ret < 0) {
+		fprintf(stderr, "Failed to initialize LibLUO: %s\n", strerror(-ret));
+		return 1;
+	}
+
+	command = &commands[0];
+	while (command->name) {
+		if (!strcmp(cmd, command->name)) {
+			ret = command->handler();
+			break;
+		}
+		command++;
+	}
+
+	if (!command->name) {
+		fprintf(stderr, "Unknown command %s. Try '%s --help' for more information\n",
+			cmd, argv[0]);
+		ret = -EINVAL;
+	}
+
+	luo_cleanup();
+	return (ret < 0) ? 1 : 0;
+}
-- 
2.50.0.727.gbf7dc18ff4-goog


