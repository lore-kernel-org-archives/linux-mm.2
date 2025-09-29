Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A9AECAC5BB
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:05:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E7838E0023; Sun, 28 Sep 2025 21:04:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672928E0006; Sun, 28 Sep 2025 21:04:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44E7E8E0023; Sun, 28 Sep 2025 21:04:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2A9D58E0006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:04:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E74D584FDF
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:54 +0000 (UTC)
X-FDA: 83940493308.14.06B779A
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id 24AFC40003
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=honvEUmo;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ydKBwOyRTlAOFM+HzD45Tc0PX6eZlXsguWH3WK3DRQ=;
	b=FVwOVu08YA/K8WBCxcPYpVf280sjgZg45V6H9RiWj23r/OHzMUiMlUs4tVgVlNJb1r8YTg
	7N0rY7UivcdyJiSHbBWBRoVbN+aKFWA6evGdkJH3vskxmjNLshIyBn+8JuiXT22D2OGOGq
	2ZyWvxHy12pOgQ8xikW/VlCVAW+XYbk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107893; a=rsa-sha256;
	cv=none;
	b=Mbue/NgygrABF+cWEC4ux1CJDmMWRh4Rk8ODmRGhMalGksO88Vp7ODV6WsLDdn020stxoz
	weHNgUC1SqhpM1r10g8O/r5GFoTuUy/vCXch5gC55pDA2IUSJAYSfD5tpKlE2wfzeFM2a3
	Jw3uSNVaJ6fGI24syk+dpEMZOF6oE4I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=honvEUmo;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4dffec0f15aso13102301cf.0
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107892; x=1759712692; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3ydKBwOyRTlAOFM+HzD45Tc0PX6eZlXsguWH3WK3DRQ=;
        b=honvEUmoNQZQ7fpzkAuVG/na9GGNVqdEM1Mvbyg4ip4/8iwCZ58VShUetw/l1Y/NfN
         O9SYmfSzGyZDpOMvc63yo8PnnWSbOg+U8oy/lm7dDAdfJT6gMrXyJElVcKeFDUj0Ki4N
         aa9oR1jnRUd/Fuetct/RL4oKXaqGT8fPCJ58v1It6ikqGy+/mTtLC2vlXe+1vFX0JiCw
         ZpIPEOMy2dW2i7TLyyQI14J6LLcevzrhNXE1yYcryfFBJ3OdX3uJFORGB24OuzZS//dr
         VjbLujGwmgTvj/dsxrn0aL3p01ld7pPMejcrpVHAMrwavENA9DqMp7rj3/UN+c92JEOM
         PvzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107892; x=1759712692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3ydKBwOyRTlAOFM+HzD45Tc0PX6eZlXsguWH3WK3DRQ=;
        b=mY+CsuJPw65sX1+yvwusdZVXpBOBmaZ69AyLSZ2pqL69Ap/oOtltphIYgFrpeol1AV
         09IbDB8KaxLbnkzQei+YUTBF/PTCiYmiOOXoRy0JmtiqNXSQUX6+Rh8PpAvn8i41Wu45
         RR04NqhfqZi0KZN8NfCliNar8JiB+D4X/J8RSje32yYxFjZrl3gK6F5MlkLEKBRNRe5j
         SzFNpNmrUUKf14+BW3bSDsel+6kEAZDi8lvtW/c+BnsZozeER7tbq4MF3Q/eZBrzGE8/
         jp3bhbGE8Hm/L7Y4SCk0RfR3xIj68dCBmBdCWRGiOhwjbgpPOlo6/+3goAg2aIL7vhuA
         kP/Q==
X-Forwarded-Encrypted: i=1; AJvYcCV9GmL9yvB3aAtrUltp62I4E1MmhAe1gbvzRx1aDpAKHqC+CT+naSI8Qzn5oBMqAg3iWe5OlYx9Hw==@kvack.org
X-Gm-Message-State: AOJu0YwG9bKQwjpKQymoT2GtRjd7kBxy1OQmVITUOEZdz8ldhAcw1CTs
	H+HtS9wsc/iG39quRkAvfAIjRHyESAjLA8mNC9AhH0LcATYDY/fLggbfExKxP9CJCyY=
X-Gm-Gg: ASbGncs7HEpcgnyQsIc0efmZZ24NN5OtgObetfZC5wMQ2FmyK/97B8t4ULKzKusP5vm
	Om4qfpg1iwvFGg1MoFTc2X+7mdK2650yZM5kYUgE4SpUs2TTz1gC0TZohIfJ/GZVp+r8hi4O+4S
	FhvevJr6zIaYXQKd4eqL+gBL2lgmkiwhyhUUmpR5XacaDPhIT8KC+dfg3+yR3Q05OUV/AsVyLro
	RZwuDClaIRgJ7rH8vFKwK2VYp4wQIU16y5dCMjEnyJjXgtmPcapbGz0CvQjgpD1WTB58bsltegp
	eSqIAITtLvR9HGKhmDO5L7W6aUtWvFNpcckqk6rxosc5jUTcfRIYiDyU8eMH633xzh5qoqp+Rch
	WSltV9DxtzjVB96c7yuE56uZSQjRhnlU0RU07tbOsdGuDreuqtibpvZiDGz8fdO1wZoGy0nBjPu
	RId81MQv0=
X-Google-Smtp-Source: AGHT+IFl5jf3mdJXfLDVCYuyr7wgE9yCTlaWZAFW+PFDbEgMjgXl4J4uX5xR5SoXPcaZ54yBI+aaQw==
X-Received: by 2002:a05:622a:1ccb:b0:4df:8368:4ae1 with SMTP id d75a77b69052e-4df836851b5mr75011421cf.33.1759107892153;
        Sun, 28 Sep 2025 18:04:52 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:04:51 -0700 (PDT)
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
Subject: [PATCH v4 27/30] selftests/liveupdate: Add multi-file and unreclaimed file test
Date: Mon, 29 Sep 2025 01:03:18 +0000
Message-ID: <20250929010321.3462457-28-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 24AFC40003
X-Stat-Signature: 4jix88ww9mpgj3apk7t8pcrsph5s6d9i
X-Rspam-User: 
X-HE-Tag: 1759107892-118662
X-HE-Meta: U2FsdGVkX1/y2NwFmIr8Ni/WK8v0Dj7alVkcsw/bCwqg+7w6VCPQiLfiTIMWpb/Slajt7KYEilOCYfAoQ1eAnWpU8v2nZjuns2qSAH6T4Jzg2bZC6Pfv33yJqvgGNq2WIklMSKkHwgIUuemQ8Ra37odApyH/afsDti+2ibn1ynJJAaFe4ccWgGw8gbd28gk/Mr9cCm272Ggjp7U/ul325lUdk5Uv4SbtNn+2NWy4b+FYFGToj5GqtnRT+jbRFyQH9YnLbav2yauv5A/HjvhfzUnqiBEXrBm9vqIk1BHIGGUWqQWvE20XRjUtE9JddD7mI//dur9usLsF7OsbWLQZtebRg0euW1d+6Y+qHJgG9S6fX1/ZUHJAQKPFfrebsstdbLwtHDDMP7YvplgTXL0RS97PZfn4Ds0pc8J80bGaoQeYD1gC0S9hZ9pf4Blayen+tpgmt9xY6Jjuv2yCx3j12QiaADvtSBDjmeU33tLxglZRZiZ8wjWQD7B3a+okSQXvl5/YM8uY44yfc1wzp6snWS+wF01rHO5AbZHQBozdUZdUYGbPDqkeCQ/Yk/LRkQJl4i6j2gtU9HKfIlyTW9UiPlB2kriX2aX9iMt+AGbsA5ugfTvBMgopxWbkzk4eauyOjKW/Ly42wO6n70Ha9GBrw2353+x0FUUpf3sPTfVI3GHpYjydjWUx0JApIap0CHiHcgUGCwgAjRzcn7bvRbuWXNlorec7O2qSzVchmXlVoGnPt8pb5u5B0wHOhnSndFk5I+8c7LUNuSVgCs7F0FwR0R3JrNAQTApHiYBSd8FS8EfE9aS0w7+c+6gfad2gzNzFkJZCUaQSF2Uci1HhbBt2JmkPWzOzwgqZ/ZP9iCZst9GLZQoHYmDJStX3kXBmx5J2Ozvyc3o7y8aOB1VUZx9zB+alZshp4srS199ckPl4bq8xzhXob3CCNGuxRH7D83n0NMqV3YGOoHjpJxgnSDX
 tdudtKsL
 mQ7CF1TX1+JGQJdoFlfWAGo92Ow6m4xkRugRy6j02/f6ETgUEH/LrxRvaHb7JEd3n+Bg57QLMh1lwOYfjqGN6n3KURdOJYX4c0GbzBKnzGQOZacmcT8/jXwgR2kJ3VoWkF9pes+ZOLr9LvR/cbJpVWxGx2C8RRV2Alwxv92UPMnJXpUKgeDGWtLojfGllq9l6fFdBP42P7xg3vhbWTuhEpuBOZ3wTL1gnuYWpBAWUxZwrk6P13ytn7o7c7gRA/G/cVnBObxSEfCKrSevK78EvvNVuhb8YhqmulPAIM+eXzweTnB/R/9trhzmuoW8aJC6T3xP7mVMRbOIkjrMKduXQt6OXI7REcMms57OAQDQcGWO0qQGkP+9AnuHEwXiT3PY7R9H1U74pNHI54HfOxK83/oMW0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new selftest, luo_multi_file, to validate two key aspects of
the Live Update Orchestrator file preservation mechanism: the ability to
handle multiple files within a single session, and the correct cleanup
of unreclaimed files.

The test implements a full kexec cycle with the following flow:
1. Pre-kexec:
  - A single session is created.
  - Three distinct memfd files (A, B, and C) are created, populated with
    unique data, and preserved within this session.
  - The global LIVEUPDATE_PREPARE event is triggered, and the system
    reboots via kexec.
2. Post-kexec:
  - The preserved session is retrieved.
  - Files A and C are restored and their contents are verified to ensure
    that multiple files can be successfully restored from a single
    session.
  - File B is intentionally not restored.
  - The global LIVEUPDATE_FINISH event is triggered.
3. Verification:
  - The test is considered successful if files A and C are verified
    correctly.
  - The user is prompted to check the kernel log (dmesg) for a message
    confirming that the unreclaimed file (B) was identified and cleaned
    up by the LUO core, thus validating the cleanup path.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 tools/testing/selftests/liveupdate/Makefile   |   1 +
 .../selftests/liveupdate/luo_multi_file.c     | 119 ++++++++++++++++++
 2 files changed, 120 insertions(+)
 create mode 100644 tools/testing/selftests/liveupdate/luo_multi_file.c

diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index 1cbc816ed5c5..f43b7d03e017 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -9,6 +9,7 @@ LDFLAGS += -static
 LUO_SHARED_SRCS := luo_test_utils.c
 LUO_SHARED_HDRS += luo_test_utils.h
 
+LUO_MANUAL_TESTS += luo_multi_file
 LUO_MANUAL_TESTS += luo_multi_kexec
 
 TEST_FILES += do_kexec.sh
diff --git a/tools/testing/selftests/liveupdate/luo_multi_file.c b/tools/testing/selftests/liveupdate/luo_multi_file.c
new file mode 100644
index 000000000000..ae38fe8aba4c
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_multi_file.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (c) 2025, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#include "luo_test_utils.h"
+
+#define KEXEC_SCRIPT "./do_kexec.sh"
+
+#define SESSION_NAME "multi_file_session"
+#define TOKEN_A 101
+#define TOKEN_B 102
+#define TOKEN_C 103
+
+#define DATA_A "Alpha file data"
+#define DATA_B "Bravo file data which will be unreclaimed"
+#define DATA_C "Charlie file data"
+
+static void run_pre_kexec(int luo_fd)
+{
+	int session_fd;
+
+	ksft_print_msg("[PRE-KEXEC] Starting workload...\n");
+
+	session_fd = luo_create_session(luo_fd, SESSION_NAME);
+	if (session_fd < 0)
+		fail_exit("Failed to create session '%s'", SESSION_NAME);
+
+	ksft_print_msg("[PRE-KEXEC] Preserving 3 memfds (A, B, C)...\n");
+	if (create_and_preserve_memfd(session_fd, TOKEN_A, DATA_A) < 0)
+		fail_exit("Failed to preserve memfd A");
+	if (create_and_preserve_memfd(session_fd, TOKEN_B, DATA_B) < 0)
+		fail_exit("Failed to preserve memfd B");
+	if (create_and_preserve_memfd(session_fd, TOKEN_C, DATA_C) < 0)
+		fail_exit("Failed to preserve memfd C");
+	ksft_print_msg("[PRE-KEXEC] All memfds preserved.\n");
+
+	if (luo_set_global_event(luo_fd, LIVEUPDATE_PREPARE) < 0)
+		fail_exit("Failed to set global PREPARE event");
+
+	ksft_print_msg("[PRE-KEXEC] System is ready. Executing kexec...\n");
+	if (system(KEXEC_SCRIPT) != 0)
+		fail_exit("kexec script failed");
+
+	sleep(10); /* Should not be reached */
+	exit(EXIT_FAILURE);
+}
+
+static void run_post_kexec(int luo_fd)
+{
+	int session_fd, mfd_a, mfd_c;
+
+	ksft_print_msg("[POST-KEXEC] Starting workload...\n");
+
+	session_fd = luo_retrieve_session(luo_fd, SESSION_NAME);
+	if (session_fd < 0)
+		fail_exit("Failed to retrieve session '%s'", SESSION_NAME);
+
+	/* 1. VERIFY SUCCESS: Restore and verify memfd A. */
+	ksft_print_msg("[POST-KEXEC] Restoring and verifying memfd A (token %d)...\n",
+		       TOKEN_A);
+	mfd_a = restore_and_verify_memfd(session_fd, TOKEN_A, DATA_A);
+	if (mfd_a < 0)
+		fail_exit("Failed to restore or verify memfd A");
+	close(mfd_a);
+	ksft_print_msg("  Success.\n");
+
+	/* 2. VERIFY SUCCESS: Restore and verify memfd C. */
+	ksft_print_msg("[POST-KEXEC] Restoring and verifying memfd C (token %d)...\n",
+		       TOKEN_C);
+	mfd_c = restore_and_verify_memfd(session_fd, TOKEN_C, DATA_C);
+	if (mfd_c < 0)
+		fail_exit("Failed to restore or verify memfd C");
+	close(mfd_c);
+	ksft_print_msg("  Success.\n");
+
+	ksft_print_msg("[POST-KEXEC] NOT restoring memfd B (token %d) to test cleanup.\n",
+		       TOKEN_B);
+
+	if (luo_set_global_event(luo_fd, LIVEUPDATE_FINISH) < 0)
+		fail_exit("Failed to set global FINISH event");
+
+	close(session_fd);
+
+	ksft_print_msg("\n--- TEST PASSED ---\n");
+	ksft_print_msg("Check dmesg for cleanup log of token %d in session '%s'.\n",
+		       TOKEN_B, SESSION_NAME);
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


