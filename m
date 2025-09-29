Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BCD5CAC5BC
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:05:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D02638E0024; Sun, 28 Sep 2025 21:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3258E0006; Sun, 28 Sep 2025 21:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2CC68E0024; Sun, 28 Sep 2025 21:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 97D658E0006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:04:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6308616020F
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:56 +0000 (UTC)
X-FDA: 83940493392.29.4882ECC
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8861D20014
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YJr5SVEG;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zogfiVWVPuHqZ/hymZklfdYD+7OrEbaP/ax6pqZUiEo=;
	b=MJyC16YqOThfXtPlsUSbSAVy60QL4sel/WONTKg9r16uPt3uIHtkSBygmrahZnRFbofzXV
	+W40Gtm4vuUcQkKAK1y9mazPBHfo5ToVHQ39Qgyd8WdOx//kL3kzhVAK7bqNOITrujoo1C
	jLZf/2gK/JkvV4vcuG/EbTrXHkWXsD8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YJr5SVEG;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107894; a=rsa-sha256;
	cv=none;
	b=ml9hOA3Xm6Mc+W5XGb+REwhBxSSlg5uULKAvxYxuAadX99vEWyuI8niHSASs59gy7GUvFw
	54QbN/GOXA5/ryNbYZ9vyRzoOAJeRcfk83cCfe5qFkFXhU6UA4Nyxogx64uX+GU3dpV7/v
	4hSvbnrnBvet5G2eLa/dPDt0QSlTj7I=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4dfe74ed2e1so12568191cf.2
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107894; x=1759712694; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zogfiVWVPuHqZ/hymZklfdYD+7OrEbaP/ax6pqZUiEo=;
        b=YJr5SVEGiUyi+On8HXZc3J8kerHPDItMgxZVjr2LkT98teyfpWE7SfKAZ9DmfvHDiZ
         sQx5i68zkju7kFZPJRVasYoTZ09nicUHAkotHnyxA8+VKqymYAvl19hsxc23sopS3IKz
         +IqXJYjCQPtHESXIYJelzzDhk+YQG9lyjWyPgMokylcZy1GI6ZLPJfSNeAhroP9K53jE
         dLXVlWDJ8tYijPdYPi5oelqdlpYOJMYsJPMEo1qv7Ffhxn1rnQ/0NJ47AAjv9Urf1IYo
         eCT+JPrrqrQw895kxxCUEZgONzbmbckRO8BgSJjWyt9vwKzpJ6xi03BK6SDCw2U12AN3
         rhBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107894; x=1759712694;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zogfiVWVPuHqZ/hymZklfdYD+7OrEbaP/ax6pqZUiEo=;
        b=u2kyMdYUrgA8s2BUJNBRvwv7/9lUd+iLxIIl9sDDtpGCZFJbwq3kxhAePi16iwtoKl
         ye23nXTYT1sVFo+8ylK8tkZVo6T1qLsJksmSUHwd4UPXmLQZXDSx5k5vOFwtxisEg509
         2ar3OYdwjpqzwDRXyNiwqRrrSdnMc8vJeDS8lplE+Aq//szfx3NSxJh/g2LeZ5VUvctY
         kFkLVPJushfTZIBfkLS6MJ6w+QXIa9q+hR5iJlPxnv9JsWCILzemZ4bh53CsynHgACjA
         Nf/vrGROJmnkm6gze653G1CkGvg4FfHnMYdl+kViQ0Cv6jgT9TupPI6ZoUa5MifZjqSu
         1KyA==
X-Forwarded-Encrypted: i=1; AJvYcCX1t6D6613pdh4ws+v2vcLZ/7i0vq1DI009gM3xLpGQcKyFbKppJAv4zM4vqRpKGKHu2Cqe4f0FYg==@kvack.org
X-Gm-Message-State: AOJu0Ywc5rG3/CMEI9FaRq7ppJT3MwYrR9FpZm1TcxLBcvssWz358gX0
	z04+yTB6OSUvY2LHqG4veaamM3ICAsKXxQ13RUIFeEFyeZYFFJerKhbPLYqydxhte10=
X-Gm-Gg: ASbGncu5nOphMK02YgkiiqVRPjeG9NH+m4GndT5ld4caRE8I1NZyd+yA8WahR1rxBFf
	v+Limh09fcfM4e2PuJx+hivrf6v1tg1aBPha/oUF9oqTfIYjwHTM+rk/DwAZwmJiX6fLctIeVp5
	hAdzyRv7IPu+1gY/Khwr/if6bSsnDut03tJlVMwxIAJdq+52J/wc83uHBdFGAUJY568QdywOPoq
	CiFTKUeRxhPzQgQ/yyXDkDjgvPvE1T0OVK5/3VlMX9Ae8Gicykz8vcxC0fhFirujWQsScgcDGc7
	S61yd1pADCC8X8WB/1NThEOgEnpyCI14By64TdmBBL8P7duky2MLUMplGaEm694ZDXu13G6mZR/
	L75c7xWDnJIrT9FNFmLLh4j4eaYEKwz5slT6KggU2Yj+Qoh6hxDQNisBmpVRkY+HPPYcrLjUZvE
	ohDvNrWbY=
X-Google-Smtp-Source: AGHT+IFJy+gdoGTPdKklQMCl/lbBiwtV/NLqoePakM8hqAPjFKr61eCoWw/x5r7bMaORajvgVwYiZg==
X-Received: by 2002:a05:622a:1e08:b0:4b5:4874:4fa5 with SMTP id d75a77b69052e-4da482d6300mr196629091cf.18.1759107893586;
        Sun, 28 Sep 2025 18:04:53 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:04:53 -0700 (PDT)
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
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: [PATCH v4 28/30] selftests/liveupdate: Add multi-session workflow and state interaction test
Date: Mon, 29 Sep 2025 01:03:19 +0000
Message-ID: <20250929010321.3462457-29-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: acsxxqpnmoq4gu4en85ciowsempc177e
X-Rspam-User: 
X-Rspamd-Queue-Id: 8861D20014
X-Rspamd-Server: rspam04
X-HE-Tag: 1759107894-672446
X-HE-Meta: U2FsdGVkX1+tO7a3frXRn1gq4zLt/SHmB0KZRJA+o/o25JeIuBHGIskFza8+Hvc06Xh9XG8n1m2ftgN5fbgS5v0gG4cakhTdr49uha/PVaNVe0Tk5Ij9zxpTaT0GsEHoWpDzSZcPdM5BTD3i81xcsqI4fNszyMCbXPaKSOZXHrC4YWb60SOQGKlrp5spsD+qYCBRTGFODhBm6hrMLDtukaU2Tz9tSTLXR6VefK0DsOFrpL3HMq1PEjVwuZebSw9e6s0TN2AAgXvcvhgxPZKrJ6UE/cm8bvwohHbnzHZ+mKA8qdCn2u07vDVUMMpq4KibQkQfN7ePxoJxBDIqn9EQquiDpPSLOWdbd0K8DTc8mZVnCQozG+ocBGIiWz9Sg8ng1b90v/L/s+/g9blVyVjVraw1dWjQmqVrcwRMPJcqjECGHRoRxv2jvUt+E1hNTm6SBWylXJVmgViW3L/N9qarmZBAghbo7LAXash3S7/ULoZAN54gIu7eXkl5SagycRdzctAGsqIQaNHT0tAb2F6jYl384GD1AjW8Xz5RkwBW0uNCB0YlR0pSo9WuDScqssS3UWMupBLdI5p+dCCVOSBDx4wUCqkwVAk8pOa5iA+YAH7r/HKlvwM1F8SezdMJaHmGRrTISSBNPJuON2v+ssa899raANiZKNrFZde1IXa8g2kSEwnp9EejD+ecyk+XGl9YI4+wO7UtSctjggOy85wKm2Yy/5ndUH/YASp41NI03YnsRrWNU8zcV0m9Dl8yLSmoWTt5MvcW3qSCO2SqfjLuTUgQgSy21lCctdoa6J+IgV6DyL6bkr8j9ewBzXBishY4omPoOsieiqqLW2imfIIJhLWl97IDSqxq/HPuxPMtcMyKzqZl9SH/adCu/CEZDnoDolepk2Tezssd4ku0ofE+1dZilT4JcTM+opepTk/Woc3qcVX3M4xXREo5H0vFNBq8Ffyx0guPloLLWTu4F2p
 HZPCOuU0
 eVehj0rziSjB+pFQ5GcOvnREttRMLVHMi9SpvM5BHGZmmF0o04B4klKABMs1UI915kRzyvGsAmEKqEAaSo+wUCjPG3PLxCk13V8/ZzTei0c3r4RmZwlVzvtjsluOZfOXrH8y4tGQnb2felSrgHjMu09mh+EyuamrnzJ1714zUg+3vsv5BnRdEM1WkA5bkAydaLqNOObq3MNo0JdjDDVX+bOV5xsLbx25hovlVxD2fr7TRcIYZoEV8GsqANlNkcPAP0UOyewMMRdmLy7mWpKkqG57KUBP88/3Yo9MZGuQ9V70f8vxuKDNUjSOK0yZdCCZSdZL2sZykUh9r6WqcBieReGL5n+Ja53NdMRlErfqR9WXhqOgdrI3K1oPAsBVY6zX/ESOL9lGvz/E5mNLcBjjiOUxjFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new, luo_multi_session, test to validate the orchestration
of multiple LUO sessions with differing lifecycles through a full kexec
reboot.

The test validates interactions between per-session and global state
transitions:

1. Mixed State Preparation: Before the first kexec, sessions are put
into different states to test the global PREPARE event's behavior:
  - Session A & C: Are individually transitioned to PREPARED via a
    per-session ioctl. The test verifies that the subsequent global
    PREPARE correctly handles these already-prepared sessions.
  - Session B: Is transitioned to PREPARED and then immediately back to
    NORMAL via a per-session CANCEL. This validates the rollback
    mechanism and ensures the session is correctly picked up and
    prepared by the subsequent global PREPARE.
  - Session D: Is left in the NORMAL state, verifying that the global
    PREPARE correctly transitions sessions that have not been
    individually managed.

2. Unreclaimed Session Cleanup:
  - After the kexec reboot, sessions A, B, C, and D are all retrieved
    and verified to ensure they were preserved correctly, regardless of
    their pre-kexec transition path.
  - Session E: Is intentionally not retrieved. This validates that the
    global FINISH event correctly identifies and cleans up an entire
    unreclaimed session and all of its preserved file resources,
    preventing leaks.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 tools/testing/selftests/liveupdate/Makefile   |   1 +
 .../selftests/liveupdate/luo_multi_session.c  | 155 ++++++++++++++++++
 2 files changed, 156 insertions(+)
 create mode 100644 tools/testing/selftests/liveupdate/luo_multi_session.c

diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index f43b7d03e017..72892942dd61 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -11,6 +11,7 @@ LUO_SHARED_HDRS += luo_test_utils.h
 
 LUO_MANUAL_TESTS += luo_multi_file
 LUO_MANUAL_TESTS += luo_multi_kexec
+LUO_MANUAL_TESTS += luo_multi_session
 
 TEST_FILES += do_kexec.sh
 
diff --git a/tools/testing/selftests/liveupdate/luo_multi_session.c b/tools/testing/selftests/liveupdate/luo_multi_session.c
new file mode 100644
index 000000000000..9ea96d7b997f
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_multi_session.c
@@ -0,0 +1,155 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#include "luo_test_utils.h"
+#include "../kselftest.h"
+
+#define KEXEC_SCRIPT "./do_kexec.sh"
+
+#define NUM_SESSIONS 5
+#define FILES_PER_SESSION 5
+
+/* Helper to manage one session and its files */
+static void setup_session(int luo_fd, struct session_info *s, int session_idx)
+{
+	int i;
+
+	snprintf(s->name, sizeof(s->name), "session-%c", 'A' + session_idx);
+
+	s->fd = luo_create_session(luo_fd, s->name);
+	if (s->fd < 0)
+		fail_exit("Failed to create session '%s'", s->name);
+
+	/* Create and preserve all files for this session */
+	for (i = 0; i < FILES_PER_SESSION; i++) {
+		s->file_tokens[i] = (session_idx * 100) + i;
+		snprintf(s->file_data[i], sizeof(s->file_data[i]),
+			 "Data for %.*s-File%d",
+			 LIVEUPDATE_SESSION_NAME_LENGTH,
+			 s->name, i);
+
+		if (create_and_preserve_memfd(s->fd, s->file_tokens[i],
+					      s->file_data[i]) < 0) {
+			fail_exit("Failed to preserve token %d in session '%s'",
+				  s->file_tokens[i], s->name);
+		}
+	}
+}
+
+/* Helper to re-initialize the expected session data post-reboot */
+static void reinit_sessions(struct session_info *sessions)
+{
+	int i, j;
+
+	for (i = 0; i < NUM_SESSIONS; i++) {
+		snprintf(sessions[i].name, sizeof(sessions[i].name),
+			 "session-%c", 'A' + i);
+		for (j = 0; j < FILES_PER_SESSION; j++) {
+			sessions[i].file_tokens[j] = (i * 100) + j;
+			snprintf(sessions[i].file_data[j],
+				 sizeof(sessions[i].file_data[j]),
+				 "Data for %.*s-File%d",
+				 LIVEUPDATE_SESSION_NAME_LENGTH,
+				 sessions[i].name, j);
+		}
+	}
+}
+
+static void run_pre_kexec(int luo_fd)
+{
+	struct session_info sessions[NUM_SESSIONS] = {0};
+	int i;
+
+	ksft_print_msg("[PRE-KEXEC] Starting workload...\n");
+
+	ksft_print_msg("[PRE-KEXEC] Setting up %d sessions with %d files each...\n",
+		       NUM_SESSIONS, FILES_PER_SESSION);
+	for (i = 0; i < NUM_SESSIONS; i++)
+		setup_session(luo_fd, &sessions[i], i);
+	ksft_print_msg("[PRE-KEXEC] Setup complete.\n");
+
+	ksft_print_msg("[PRE-KEXEC] Performing individual session state transitions...\n");
+	ksft_print_msg("  - Preparing Session A...\n");
+	if (luo_set_session_event(sessions[0].fd, LIVEUPDATE_PREPARE) < 0)
+		fail_exit("Failed to prepare Session A");
+
+	ksft_print_msg("  - Preparing and then Canceling Session B...\n");
+	if (luo_set_session_event(sessions[1].fd, LIVEUPDATE_PREPARE) < 0)
+		fail_exit("Failed to prepare Session B");
+	if (luo_set_session_event(sessions[1].fd, LIVEUPDATE_CANCEL) < 0)
+		fail_exit("Failed to cancel Session B");
+
+	ksft_print_msg("  - Preparing Session C...\n");
+	if (luo_set_session_event(sessions[2].fd, LIVEUPDATE_PREPARE) < 0)
+		fail_exit("Failed to prepare Session C");
+
+	ksft_print_msg("  - Sessions D & E remain in NORMAL state.\n");
+
+	ksft_print_msg("[PRE-KEXEC] Triggering global PREPARE event...\n");
+	if (luo_set_global_event(luo_fd, LIVEUPDATE_PREPARE) < 0)
+		fail_exit("Failed to set global PREPARE event");
+
+	ksft_print_msg("[PRE-KEXEC] System is ready. Executing kexec...\n");
+	if (system(KEXEC_SCRIPT) != 0)
+		fail_exit("kexec script failed");
+
+	sleep(10);
+	exit(EXIT_FAILURE);
+}
+
+static void run_post_kexec(int luo_fd)
+{
+	struct session_info sessions[NUM_SESSIONS] = {0};
+
+	ksft_print_msg("[POST-KEXEC] Starting workload...\n");
+
+	reinit_sessions(sessions);
+
+	ksft_print_msg("[POST-KEXEC] Verifying preserved sessions (A, B, C, D)...\n");
+	verify_session_and_get_fd(luo_fd, &sessions[0]);
+	verify_session_and_get_fd(luo_fd, &sessions[1]);
+	verify_session_and_get_fd(luo_fd, &sessions[2]);
+	verify_session_and_get_fd(luo_fd, &sessions[3]);
+
+	ksft_print_msg("[POST-KEXEC] NOT retrieving session E to test cleanup.\n");
+
+	ksft_print_msg("[POST-KEXEC] Driving global state to FINISH...\n");
+	if (luo_set_global_event(luo_fd, LIVEUPDATE_FINISH) < 0)
+		fail_exit("Failed to set global FINISH event");
+
+	ksft_print_msg("\n--- TEST PASSED ---\n");
+	ksft_print_msg("Check dmesg for cleanup log of session E.\n");
+}
+
+int main(int argc, char *argv[])
+{
+	enum liveupdate_state state;
+	int luo_fd;
+
+	luo_fd = luo_open_device();
+	if (luo_fd < 0) {
+		ksft_exit_skip("Failed to open %s. Is the luo module loaded?\n",
+			       LUO_DEVICE);
+	}
+
+	if (luo_get_global_state(luo_fd, &state) < 0)
+		fail_exit("Failed to get LUO state");
+
+	switch (state) {
+	case LIVEUPDATE_STATE_NORMAL:
+		run_pre_kexec(luo_fd);
+		break;
+	case LIVEUPDATE_STATE_UPDATED:
+		run_post_kexec(luo_fd);
+		break;
+	default:
+		fail_exit("Test started in an unexpected state: %d", state);
+	}
+
+	close(luo_fd);
+	ksft_exit_pass();
+}
-- 
2.51.0.536.g15c5d4f767-goog


