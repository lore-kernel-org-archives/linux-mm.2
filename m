Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D06D3CCFA19
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 21:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F7178E0021; Fri,  7 Nov 2025 16:06:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679E28E001A; Fri,  7 Nov 2025 16:06:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 458898E0021; Fri,  7 Nov 2025 16:06:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2BF338E001A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:06:16 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 02EFC13B2F2
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:06:15 +0000 (UTC)
X-FDA: 84085043952.17.D2EB8B9
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 20FAEA0003
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:06:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KVuHz5Lh;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762549574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qjuXuvmfL1K8By8qdYZh9RjNKTHIKCPX1bM6iJVu4Us=;
	b=Ow3moea3O/H2S9tgdZ7h9WNrfhzdh8s4Sjv6n2G+ve2faYo+zsm9bGqA4n2vMsB0lhyVNN
	vAY6gtYat7T/VnjCY5S+x4ubREi1wDLZxe+Lj61D21rTfM4VGkEG6DG4Pvpjgu9UE0ZVih
	Rj9fYZyQye+lD46nWHRXI3LNLpUpXTI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KVuHz5Lh;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762549574; a=rsa-sha256;
	cv=none;
	b=Spe3crgzCz1XLYov3lW30g9Oc3VtT7EB+lM88wphb5JdauSQAzINm0zOjqJGXDsD/CJvHm
	s+pcZT2SWB7lub5Ynx2LcgE0bKDl2IkaeYRVXBeW2GAMtUXhDbPcWPBbneKY0XfGeaK8xJ
	UaettlAnKZwLdCd0vID7EzbIKW6mFjU=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-78665368a5cso12266097b3.3
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 13:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762549573; x=1763154373; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qjuXuvmfL1K8By8qdYZh9RjNKTHIKCPX1bM6iJVu4Us=;
        b=KVuHz5Lh0IV2dByrywx5aW6AluJ1KpVnSwmNTNBa1B7OdbkpSLZIC7TZXHaKdb79bh
         +dcf7J2JBFXfIXyaRJp2j5XEukLiJluN8gtrgOMvSc7o1dQxlwrkvuxUZe+zdagcjmYg
         xO0qvOj/lvi5YGEdDdKfgcCD1WGefh5U3M/kpbKY9hkB21gJlklja+LB3QzXkEBM4oWs
         mSeJUzG0055Z78cQ6Go4qHd59a4/5UmGYSJsuu+io/t8jSFLj8Tjq6TvY9nR6qoo6RLU
         dyGyMTpRdSFtUC3hW/Y7O8O4lAZXQHa2BBXmEoiBz3b6FKdTr4RqSOnWs6oU8SAsUPwk
         aanw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762549573; x=1763154373;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qjuXuvmfL1K8By8qdYZh9RjNKTHIKCPX1bM6iJVu4Us=;
        b=ORDXQitOgCQQzuhblXFmT5Djl9lBG3Pn3nWO7WEMD4RnHrKQh9BtIG6zuNNQTNf5+S
         tO9ENOv7kZsVVpgYktWFw44f3zxqavSCy/RvaT7sQ60tJwSduh6Vn7eJ/2NFh99SaGno
         sa/tNgUwOE6svWAYfFCgn+g4egYy9GyJlR9Qdpc+0ArUIeJLIFevwzHdcqru6DiHd9Er
         178LuPzqD1dsrvNPp5hlFsk5Ma5p2o1LQBRIwSslmx7XfKxc/zXPw1qMtD2sHNYCuC9w
         lmwqG/r18LpiuJHFTe2+GCEIk8w7Qpg20Hkf9vZ/O6fZ70kJwPPFZV+iq5BPg10NnLBx
         S8EQ==
X-Forwarded-Encrypted: i=1; AJvYcCULLQOZLhzjnMscYuhLaQZMqNuBo4xnpQUfw7L85RVJYVyaHiSb9kKdtaKBSZBvUyTTd6d/hu2xLQ==@kvack.org
X-Gm-Message-State: AOJu0Yy7BbZOoUnlKS77q6zcaTtePU74yVnDmXdP49RQtauTK8JzWXX3
	VZoE4IEn2To3/++LwrRrDP4+rjgNyuYKsSyIg6N7KS+LogwlIYJb9Vu6qLAXJPZHnKA=
X-Gm-Gg: ASbGncuZgJLmXC9pihDyEVTHGvNkNAE3Pc9YC1S1pxwi76c2vhi10Xc9Kg5Wln7NjIk
	tMiuGMz2ZB/9KrphiCd4bFhFYMiMahFqmnoZ9RttG8v4zT52rLWO0me6Q0KTfilNuJbuAqqDcEZ
	a10T9gGj0hddm9feD3otWJmxEhMw8SKW7u5X+3Ba0oo1OC4j3j7iEcanLIqift6xbPwENeSHD/X
	1ofWMMVlN/HQKlMmOwBAgriPfK1E2ibEqFIOibmMvMz+002GFCzQOl8x0WqB7ToP7l5G/ezFQr6
	gOrvG325DzZ8+xyPWuPVjCu1Ad5xy6oRUmeVCQfN6bK0FGKjfVlq8VFL39np5pKqjVPukMTO064
	II0Kse1Rk63IObu52OykIrR+LWfpepDkkCavsK5Q60lywuTd2P19gNdcm6AKboeogNVa6XtVLAL
	Emuq3wFm9rQr5FfRj0nKuyZVqM1umBd5S7b1bwc07/VVKXLqBjz+OC9OWOwHfCbFwVYXPiFDuC+
	w==
X-Google-Smtp-Source: AGHT+IE4r8jHOQKB/UiTHgSqUgazEpkLY0csKmQ3EsY7bV+rYNEGHwWx8lwO5MiuiV1LIw2GfopjMw==
X-Received: by 2002:a05:690c:6385:b0:786:7017:9506 with SMTP id 00721157ae682-787d541b17emr8282027b3.43.1762549573027;
        Fri, 07 Nov 2025 13:06:13 -0800 (PST)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d68754d3sm990817b3.26.2025.11.07.13.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 13:06:12 -0800 (PST)
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
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org
Subject: [PATCH v5 21/22] selftests/liveupdate: Add kexec test for multiple and empty sessions
Date: Fri,  7 Nov 2025 16:03:19 -0500
Message-ID: <20251107210526.257742-22-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107210526.257742-1-pasha.tatashin@soleen.com>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 20FAEA0003
X-Stat-Signature: k35aoa61jrfz36coi993ptrzfqko9djx
X-Rspam-User: 
X-HE-Tag: 1762549573-3563
X-HE-Meta: U2FsdGVkX19iyG1b0SlpaP0qSYdx/tY67mNyBk6iNwkW62Ne3806BIfQDo+pZjd3H+9WsoyrIYCbsDzW8OvdimxX9TiovhHrTmMuGYnbjWcOtHkYq4aDtPla7MDx7WAALu0e/VJEV6PSXKmm2OrlnFKtv7nzGunY1aDOsB4yiKzOkL67P0XJClcolB4ARzNdHsD8CgGVppw31jZV2+78JAdnveqKdtJL4mdmRB2jhlK3eFUZoqz+dCxTZ+kxb9u5RYaNsngeR46opGfze45BxVzSaQMKFCdJh4AMJebzN6vNIGF5AXlDW6sAYfX8WQxAwe71EbQqZavfB8mcF0uRZkAyYMsKd30rSpZSr1WwnQFyj/atsJwZqtgUUFjsL9Hv34WdBdLCDs73wWb65OwiEJAsBpBTWe8SN4WigyoADL6D6WNAKin7IBvm2kd3vhouVmlajKpLb2mtAy6NBkHSq2TNHvIPXZlQ7uSL+aAjdWD49FpibagAVGCo/M2EWO3Bou+8FSIjzIbOmAvMvOk1qPwQjdwdNTlh09jdW8YUJ0CPjulVruJ3jUy2bXCFl32pqHGAR/8zUegNTObhWrgX/ggNBOVPl7A04EY8dfNXvneFwKs1pMdeZW5VV2z1z8dYCzY1G8hADWSjGqZ/6CCTug5Ng75Uus5qVIE8BY6OR3UFZYEz/FZ+DrtXIyFmxhJXEVXbs9HABdOlLTGM7QjlnSBZfxEaEEmx1nog87ibJbO38zApBW7JP/8MMI8C7yuG6bm0YQeYXIjrWziSeAIQZpzFO4AIQmmkfVQDw3yK4RUEVLPWlEbqmbl7vszKE2P7lF/jh6gvCCam9jj6IhZW3jImVOdtJEX0w3f10zHcjQ8o15llVQSyqQXpVsgoaU18h3+RQ4Ix84netfhdO/9bL2sNC7Pc7/RyrBrfRmIzohAFp2rbjUSjy2MP16dxBAMSdt2ZGMkLgRyEUuIjHo2
 nSLtp0Mv
 Vj5NnUqnhYwvPIf01sI/wG6nAYBKnsmLB4t6aD+nf0vC6x5BAsSVbwjPiV7+JHF7OISbdDLXwaXPM7I3JzsOAi9RtiSMzFY4bC6bL8xI2YXJXRVL/8t2mgA6BF1jwV7WtOyzpHOATZKPRMMkUXx1DyGHWspE9QRk01HA9uXHK2oiKTBRQ7DsFJXWLZ+oZtvBuj/Im89wnYipgj+KsBncE+zhSzBTrUY6/u3owyFLCPJeuq3tV6dNDtL9TaZwp/8DJ6Ifw1v4h9QLeDxgsx0BasK1vEmSXwG3ackKMXcpnuzMTC4C1fCkx3pdc3Ly1XVc1tTXWSrJ5w8wc0iSfrIqWT1z2ChxzuWFPh+Y8Gh1ZU56Gp80WEAjFH3g2G8iP0Vz9edu0nNCR9wrJFAB4g+/Rlrlk5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new kexec-based selftest, luo_kexec_multi_session, to
validate the end-to-end lifecycle of a more complex LUO scenario.

While the existing luo_kexec_simple test covers the basic end-to-end
lifecycle, it is limited to a single session with one preserved file.
This new test significantly expands coverage by verifying LUO's ability
to handle a mixed workload involving multiple sessions, some of which
are intentionally empty. This ensures that the LUO core correctly
preserves and restores the state of all session types across a reboot.

The test validates the following sequence:

Stage 1 (Pre-kexec):

  - Creates two empty test sessions (multi-test-empty-1,
    multi-test-empty-2).
  - Creates a session with one preserved memfd (multi-test-files-1).
  - Creates another session with two preserved memfds
    (multi-test-files-2), each containing unique data.
  - Creates a state-tracking session to manage the transition to
    Stage 2.
  - Executes a kexec reboot via the helper script.

Stage 2 (Post-kexec):

  - Retrieves the state-tracking session to confirm it is in the
    post-reboot stage.
  - Retrieves all four test sessions (both the empty and non-empty
    ones).
  - For the non-empty sessions, restores the preserved memfds and
    verifies their contents match the original data patterns.
  - Finalizes all test sessions and the state session to ensure a clean
    teardown and that all associated kernel resources are correctly
    released.

This test provides greater confidence in the robustness of the LUO
framework by validating its behavior in a more realistic, multi-faceted
scenario.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 tools/testing/selftests/liveupdate/.gitignore |   1 +
 tools/testing/selftests/liveupdate/Makefile   |   1 +
 .../selftests/liveupdate/luo_multi_session.c  | 190 ++++++++++++++++++
 3 files changed, 192 insertions(+)
 create mode 100644 tools/testing/selftests/liveupdate/luo_multi_session.c

diff --git a/tools/testing/selftests/liveupdate/.gitignore b/tools/testing/selftests/liveupdate/.gitignore
index daeef116174d..42a15a8d5d9e 100644
--- a/tools/testing/selftests/liveupdate/.gitignore
+++ b/tools/testing/selftests/liveupdate/.gitignore
@@ -1,2 +1,3 @@
 /liveupdate
 /luo_kexec_simple
+/luo_multi_session
diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index 1563ac84006a..6ee6efeec62d 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -11,6 +11,7 @@ LUO_SHARED_SRCS := luo_test_utils.c
 LUO_SHARED_HDRS += luo_test_utils.h
 
 LUO_MANUAL_TESTS += luo_kexec_simple
+LUO_MANUAL_TESTS += luo_multi_session
 
 TEST_FILES += do_kexec.sh
 
diff --git a/tools/testing/selftests/liveupdate/luo_multi_session.c b/tools/testing/selftests/liveupdate/luo_multi_session.c
new file mode 100644
index 000000000000..c9955f1b6e97
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_multi_session.c
@@ -0,0 +1,190 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * A selftest to validate the end-to-end lifecycle of multiple LUO sessions
+ * across a kexec reboot, including empty sessions and sessions with multiple
+ * files.
+ */
+
+#include "luo_test_utils.h"
+
+#define KEXEC_SCRIPT "./do_kexec.sh"
+
+#define SESSION_EMPTY_1 "multi-test-empty-1"
+#define SESSION_EMPTY_2 "multi-test-empty-2"
+#define SESSION_FILES_1 "multi-test-files-1"
+#define SESSION_FILES_2 "multi-test-files-2"
+
+#define MFD1_TOKEN 0x1001
+#define MFD2_TOKEN 0x2002
+#define MFD3_TOKEN 0x3003
+
+#define MFD1_DATA "Data for session files 1"
+#define MFD2_DATA "First file for session files 2"
+#define MFD3_DATA "Second file for session files 2"
+
+#define STATE_SESSION_NAME "kexec_multi_state"
+#define STATE_MEMFD_TOKEN 998
+
+/* Stage 1: Executed before the kexec reboot. */
+static void run_stage_1(int luo_fd)
+{
+	int s_empty1_fd, s_empty2_fd, s_files1_fd, s_files2_fd;
+
+	ksft_print_msg("[STAGE 1] Starting pre-kexec setup for multi-session test...\n");
+
+	ksft_print_msg("[STAGE 1] Creating state file for next stage (2)...\n");
+	create_state_file(luo_fd, STATE_SESSION_NAME, STATE_MEMFD_TOKEN, 2);
+
+	ksft_print_msg("[STAGE 1] Creating empty sessions '%s' and '%s'...\n",
+		       SESSION_EMPTY_1, SESSION_EMPTY_2);
+	s_empty1_fd = luo_create_session(luo_fd, SESSION_EMPTY_1);
+	if (s_empty1_fd < 0)
+		fail_exit("luo_create_session for '%s'", SESSION_EMPTY_1);
+
+	s_empty2_fd = luo_create_session(luo_fd, SESSION_EMPTY_2);
+	if (s_empty2_fd < 0)
+		fail_exit("luo_create_session for '%s'", SESSION_EMPTY_2);
+
+	ksft_print_msg("[STAGE 1] Creating session '%s' with one memfd...\n",
+		       SESSION_FILES_1);
+
+	s_files1_fd = luo_create_session(luo_fd, SESSION_FILES_1);
+	if (s_files1_fd < 0)
+		fail_exit("luo_create_session for '%s'", SESSION_FILES_1);
+	if (create_and_preserve_memfd(s_files1_fd, MFD1_TOKEN, MFD1_DATA) < 0) {
+		fail_exit("create_and_preserve_memfd for token %#x",
+			  MFD1_TOKEN);
+	}
+
+	ksft_print_msg("[STAGE 1] Creating session '%s' with two memfds...\n",
+		       SESSION_FILES_2);
+
+	s_files2_fd = luo_create_session(luo_fd, SESSION_FILES_2);
+	if (s_files2_fd < 0)
+		fail_exit("luo_create_session for '%s'", SESSION_FILES_2);
+	if (create_and_preserve_memfd(s_files2_fd, MFD2_TOKEN, MFD2_DATA) < 0) {
+		fail_exit("create_and_preserve_memfd for token %#x",
+			  MFD2_TOKEN);
+	}
+	if (create_and_preserve_memfd(s_files2_fd, MFD3_TOKEN, MFD3_DATA) < 0) {
+		fail_exit("create_and_preserve_memfd for token %#x",
+			  MFD3_TOKEN);
+	}
+
+	ksft_print_msg("[STAGE 1] Executing kexec...\n");
+
+	if (system(KEXEC_SCRIPT) != 0)
+		fail_exit("kexec script failed");
+
+	exit(EXIT_FAILURE);
+}
+
+/* Stage 2: Executed after the kexec reboot. */
+static void run_stage_2(int luo_fd, int state_session_fd)
+{
+	int s_empty1_fd, s_empty2_fd, s_files1_fd, s_files2_fd;
+	int mfd1, mfd2, mfd3, stage;
+
+	ksft_print_msg("[STAGE 2] Starting post-kexec verification...\n");
+
+	restore_and_read_stage(state_session_fd, STATE_MEMFD_TOKEN, &stage);
+	if (stage != 2) {
+		fail_exit("Expected stage 2, but state file contains %d",
+			  stage);
+	}
+
+	ksft_print_msg("[STAGE 2] Retrieving all sessions...\n");
+	s_empty1_fd = luo_retrieve_session(luo_fd, SESSION_EMPTY_1);
+	if (s_empty1_fd < 0)
+		fail_exit("luo_retrieve_session for '%s'", SESSION_EMPTY_1);
+
+	s_empty2_fd = luo_retrieve_session(luo_fd, SESSION_EMPTY_2);
+	if (s_empty2_fd < 0)
+		fail_exit("luo_retrieve_session for '%s'", SESSION_EMPTY_2);
+
+	s_files1_fd = luo_retrieve_session(luo_fd, SESSION_FILES_1);
+	if (s_files1_fd < 0)
+		fail_exit("luo_retrieve_session for '%s'", SESSION_FILES_1);
+
+	s_files2_fd = luo_retrieve_session(luo_fd, SESSION_FILES_2);
+	if (s_files2_fd < 0)
+		fail_exit("luo_retrieve_session for '%s'", SESSION_FILES_2);
+
+	ksft_print_msg("[STAGE 2] Verifying contents of session '%s'...\n",
+		       SESSION_FILES_1);
+	mfd1 = restore_and_verify_memfd(s_files1_fd, MFD1_TOKEN, MFD1_DATA);
+	if (mfd1 < 0)
+		fail_exit("restore_and_verify_memfd for token %#x", MFD1_TOKEN);
+	close(mfd1);
+
+	ksft_print_msg("[STAGE 2] Verifying contents of session '%s'...\n",
+		       SESSION_FILES_2);
+
+	mfd2 = restore_and_verify_memfd(s_files2_fd, MFD2_TOKEN, MFD2_DATA);
+	if (mfd2 < 0)
+		fail_exit("restore_and_verify_memfd for token %#x", MFD2_TOKEN);
+	close(mfd2);
+
+	mfd3 = restore_and_verify_memfd(s_files2_fd, MFD3_TOKEN, MFD3_DATA);
+	if (mfd3 < 0)
+		fail_exit("restore_and_verify_memfd for token %#x", MFD3_TOKEN);
+	close(mfd3);
+
+	ksft_print_msg("[STAGE 2] Test data verified successfully.\n");
+
+	ksft_print_msg("[STAGE 2] Finalizing all test sessions...\n");
+	if (luo_session_finish(s_empty1_fd) < 0)
+		fail_exit("luo_session_finish for '%s'", SESSION_EMPTY_1);
+	close(s_empty1_fd);
+
+	if (luo_session_finish(s_empty2_fd) < 0)
+		fail_exit("luo_session_finish for '%s'", SESSION_EMPTY_2);
+	close(s_empty2_fd);
+
+	if (luo_session_finish(s_files1_fd) < 0)
+		fail_exit("luo_session_finish for '%s'", SESSION_FILES_1);
+	close(s_files1_fd);
+
+	if (luo_session_finish(s_files2_fd) < 0)
+		fail_exit("luo_session_finish for '%s'", SESSION_FILES_2);
+	close(s_files2_fd);
+
+	ksft_print_msg("[STAGE 2] Finalizing state session...\n");
+	if (luo_session_finish(state_session_fd) < 0)
+		fail_exit("luo_session_finish for state session");
+	close(state_session_fd);
+
+	ksft_print_msg("\n--- MULTI-SESSION KEXEC TEST PASSED ---\n");
+}
+
+int main(int argc, char *argv[])
+{
+	int luo_fd;
+	int state_session_fd;
+
+	luo_fd = luo_open_device();
+	if (luo_fd < 0)
+		ksft_exit_skip("Failed to open %s. Is the luo module loaded?\n",
+			       LUO_DEVICE);
+
+	/*
+	 * Determine the stage by attempting to retrieve the state session.
+	 * If it doesn't exist (ENOENT), we are in Stage 1 (pre-kexec).
+	 */
+	state_session_fd = luo_retrieve_session(luo_fd, STATE_SESSION_NAME);
+	if (state_session_fd == -ENOENT) {
+		run_stage_1(luo_fd);
+	} else if (state_session_fd >= 0) {
+		/* We got a valid handle, pass it directly to stage 2 */
+		run_stage_2(luo_fd, state_session_fd);
+	} else {
+		fail_exit("Failed to check for state session");
+	}
+
+	close(luo_fd);
+	return 0;
+}
-- 
2.51.2.1041.gc1ab5b90ca-goog


