Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13A62CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D70A6B00B6; Wed,  3 Jun 2026 11:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 787E46B00B8; Wed,  3 Jun 2026 11:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69DBF6B00B9; Wed,  3 Jun 2026 11:46:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5752C6B00B6
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:46:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21D011625FE
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:46:29 +0000 (UTC)
X-FDA: 84839028498.02.00C8C26
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5C6AD160012
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:46:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SpRjgyKY;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780501587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=psMAwGaqe9xuyJY3Mn283ARVP/GQQXmgr+1HpWpGRKs=;
	b=TDm+liG6XyMe9KsK7/7iQ9Ss/T0Oz9r3YTuqPDimEO1dzejC9dPHn4rpVYFZYX8TKdUpet
	rDCFMi3FANHX9YHwchP4Qg2vthEvjGb+nQVVnfmQVq6D43EgooOxN0EYgha5/WbIE0vxMB
	yjQs9sZ6zhkuBbwd95bUNNw/1kUCKAU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780501587;
	b=KRFXci3+1NUPYdwSy0Enoy0zQbIYKXmuAieXG/Eb4nNMwPXyQgBfv33SZOcyF31KZaLU5h
	IQFYv9p4ge2kn9zZ09wI3bl4ZAVUREj3vWTcHkBYQm8SK96PHm4xS1eGRyh2CXuPFGsz+7
	+1RNPMFotFjrjm5Wm74ga0PS4m7UQjU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SpRjgyKY;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-6c3154fa46dso1772622137.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 08:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780501586; x=1781106386; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=psMAwGaqe9xuyJY3Mn283ARVP/GQQXmgr+1HpWpGRKs=;
        b=SpRjgyKYBu20GfbE0KE+0vG64uDtkSzB3pFfHhIEsxvthx2owfRaEiLpE8X0noF1/D
         cWOSgjeireKNbf2AbyjJ8YBCYb4UAb7BTqqiW+UHhSh+VQuDrT6z8GgqDzDmUtQIoz1q
         DzPC5HU0uOl2bmm9JU0RELR+vsbf1ErUs0X2VNyi7azzIbs5xe0gCPYSkUksv8p3hEsV
         l/L+oPn3FcLKoJzN4bPJckJewjf9CfeAERr8MACUmKd/IM0ITMd5iMhNCW6yh0E7/PyA
         Xn3wLB10XkW8uOmL4Iu3Dk8ZhLvg9XJxoTo/Qfqld4YKemXyk88lvxovLsFGzOdbGsmz
         VK4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780501586; x=1781106386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=psMAwGaqe9xuyJY3Mn283ARVP/GQQXmgr+1HpWpGRKs=;
        b=l6vNB/myalWTrA9CFiyXFKEIBhCFri+s4fuSeJEEnwXKT8Qj2fPZuruJtRB5XqD20x
         //RLAarlgaoj0MoiVF6KT/WlTwXQdfrD0Mhc/yc3jOKVFJn/Of5slL1XIVVWBF8rGlaO
         DGofl7aQwnOQ4Nb6AfGHWfWJRBwDuqJYzGVU1oEMG2yxyN8RdI+SdrueUfQMJRYE1xP0
         NpSqEto47xmgGyak+WHagwGq82aFmjU0ZUls2GDlVMNFS/VrjNwMFgK5/6LM9sI4JEWJ
         dGr+wdq25LtAd7w+jv/LWB9rj13nfCN/+XNwg9/bbjVlGNoWPbQa6UGeXDiT8WaZfc/h
         DEKQ==
X-Forwarded-Encrypted: i=1; AFNElJ8BWQbOUdOaSN+WQdesbkAgHT21kWgPxS6eiz1pD8ziwUi+8mU9z4mm7eSU6fjOvxB147gYL3vZgw==@kvack.org
X-Gm-Message-State: AOJu0YxkE5IbYOVzuQPuJI4gJUVFiScdxdKz/XPlum8DZ2fbIX747IhH
	YOuaGtk/Qe5Yhe0Rm/GOimiloSVWJsVsX4xc9aYMYgnmq1ypabQwjOcTczE6UfVcrLZFB6nJNzJ
	rYK2d
X-Gm-Gg: Acq92OEggcLqzfZm4hmxKJeg+JIK6QdQajeM4f9/tGG94p9FJ7ilipJKIsughSmfL2r
	4VawgAhLpUBUPkUM0S9+k9i4JH7NrZNlIbOSiKLEqZuUbYUMLHhu8TxWG1uwAQjEb0xK0oE6nGR
	chmeikOsj8eCEzEyel2IS2jQvd+sg8O0//bXTDb9SZ1X99Vg0UXO826gCtRVHIgm774RtssR2wW
	o8/7xfUpDT8/7hFgM5+lwCC0AIAtEbFSfWyy3sXnU/432gW8sy4GBKdzXh7gcK9UkkOLN1aWtR8
	MDP+gqXyRWXVbhwgIuRaXtIVg/pSityVYmGLG1MGjbwRqB2qzRIvLK4wcHALlJS3xuBJWGc0AQY
	nlopJ8UaMbpSYXb6t3g6desjjv+I6vkOY3tm+7zbNW6b8kgnY2oYODDT4klMQDNX68rP8tRUWuC
	yf131uJLupurLqZbjj4UwallbhEvZQN0KC1In3lk/Eyt1dgfZVHrL2xmIBTwgy9Q==
X-Received: by 2002:a05:6102:e0a:b0:631:2a80:e492 with SMTP id ada2fe7eead31-6ec4ce590b0mr2408029137.30.1780501586216;
        Wed, 03 Jun 2026 08:46:26 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd053032sm23998326d6.24.2026.06.03.08.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 08:46:25 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v7 12/13] selftests/liveupdate: Add stress-sessions kexec test
Date: Wed,  3 Jun 2026 15:44:01 +0000
Message-ID: <20260603154402.468928-13-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603154402.468928-1-pasha.tatashin@soleen.com>
References: <20260603154402.468928-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5C6AD160012
X-Rspam-User: 
X-Stat-Signature: mm4th7cgtpzcg64s9tx9p3kn376w5esi
X-Rspamd-Server: rspam08
X-HE-Tag: 1780501587-942646
X-HE-Meta: U2FsdGVkX19jTVgR5CIGHvATZWioaVFcwrWHskPMyrRy2HJwTfqi1byqrH5pcPxcg/hOT96fjDofVIpGJbacog/SiVw9xiVJc3nKUgnhp72HO1Tpuf4Zg+pUF3fU+KlDVRCWYpRC8g8iaADEI8n6ctRr5W441jK5r7NvmiFUEphLs5g5ja5guoUO8i1ieWTvrVyoOLhSYlSePgzy7p29RB+xv2XMSixURMKzmg5xXMBH08SwZHJvwGMRbiZFCpG4/Kqa4kAvGZJgairjRWUwFVpMuuYTzczeq4LFeUVTM9MsDovBSllW1kYQMy3UITh5VP4nLZQ8XpXSLQzCqdYJcPlbYiZF68zPMr21n+ykQki/afZwN2NwaYkcOeibPGmuZy4d7zibJX7OfIoiNqrBOlEWVDztEGhLds5QdtH0hm4JWF0XeJ6cUUKZpxI9QUxQCq5xgCbqHmVeWyX0L3iMShGqVjhlnIsPWs0700J49fltDbGM27Ut1CEC7xc5i9DH6nv3B9/BjVXkYtwPZU11PeXPF8ky4hLtWIPnXW7eTqMUJxZkGt3xNgjxrjMRUY8nylu50ng1LvO5vKcewazOTRoBfQDbrCLoylaz/AVv/E/9bKF18O0qRWnxeXWNxtWj/+pERucboHeHPy4+A17AmBSAi0yGjYdtRkxhiBxLOKSOpY7qf6UMzCAu+Y0W8Ak6sJVO+lf7TbWMsPDeOMZdqVBPL0A9uKdiF/IBWy0oR1vldSVwZ0LOjg1qFM+d3fw68Zid4xoU0qstpLmHbU1YXmvedrEogWJoRgz9zCiPeLAIuY6B496yB0ium19S5f2IIKorjnbn83feT/pVMkoYAILeTacmsRg7gvvajEHayXMj3rc72CtZeltPGAufqrZp23sD5ONcLq79oldsT1FIheoSMtsYwDxa862G1obe5JxeYgUtmnX3K1j9cE/Rem86FlvW5zkR5H9Aea5Aq28
 YPm5OIna
 ROPrmq4iUFTRp7C8ISoljIoBQ2dVgsSvZM23opz4EIjlq8194Gb4Js5fqya1hr48yFYbYjcaGESA2ti7tTtKdqhaIaSVkt2FfyoXy7uHEyFF0GjjjpqRhLujQ3e7tLu7LBI6CIf996CMY/PNGUuwJlPK4SVMLeRnN5SmFMFTMaXd1jUtIrlHYUnAiN6zNP0ODS5H13qIfIt+67gd1O4bN0Z076qJZdUj5HAyJPwEZxNbcwKzdokc3Qx6H2W+49qjv95X2QdyOhl7oVgtWW+nJRut+lHw1O//ngeEYxFrk3FLBXK+2h6FXj3RnFPHzABTJJXl8ADYxpSRxMT9mg8JSM5Vs2nNm2YXnoC4dggXNvqdQ585SfkznwFjWlO8nckaRVJbsKGRVtjf2r3mS6zvxMMKpsEABwNv+t9KvIpjYgCrle0t9z3yYtnYizg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new test that creates 2000 LUO sessions before a kexec
reboot and verifies their presence after the reboot. This ensures
that the linked-block serialization mechanism works correctly for
a large number of sessions.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 tools/testing/selftests/liveupdate/Makefile   |   1 +
 .../liveupdate/luo_stress_sessions.c          | 102 ++++++++++++++++++
 2 files changed, 103 insertions(+)
 create mode 100644 tools/testing/selftests/liveupdate/luo_stress_sessions.c

diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
index 080754787ede..ed7534468386 100644
--- a/tools/testing/selftests/liveupdate/Makefile
+++ b/tools/testing/selftests/liveupdate/Makefile
@@ -6,6 +6,7 @@ TEST_GEN_PROGS += liveupdate
 
 TEST_GEN_PROGS_EXTENDED += luo_kexec_simple
 TEST_GEN_PROGS_EXTENDED += luo_multi_session
+TEST_GEN_PROGS_EXTENDED += luo_stress_sessions
 
 TEST_FILES += do_kexec.sh
 
diff --git a/tools/testing/selftests/liveupdate/luo_stress_sessions.c b/tools/testing/selftests/liveupdate/luo_stress_sessions.c
new file mode 100644
index 000000000000..f201b1839d1d
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/luo_stress_sessions.c
@@ -0,0 +1,102 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * Validate that LUO can handle a large number of sessions across a kexec
+ * reboot.
+ */
+
+#include <stdio.h>
+#include <unistd.h>
+#include "luo_test_utils.h"
+
+#define NUM_SESSIONS 2000
+#define STATE_SESSION_NAME "kexec_many_state"
+#define STATE_MEMFD_TOKEN 999
+
+/* Stage 1: Executed before the kexec reboot. */
+static void run_stage_1(int luo_fd)
+{
+	int ret, i;
+
+	ksft_print_msg("[STAGE 1] Increasing ulimit for open files...\n");
+	ret = luo_ensure_nofile_limit(NUM_SESSIONS);
+	if (ret == -EPERM)
+		ksft_exit_skip("Insufficient privileges to set RLIMIT_NOFILE\n");
+	if (ret < 0)
+		ksft_exit_fail_msg("luo_ensure_nofile_limit failed: %s\n", strerror(-ret));
+
+	ksft_print_msg("[STAGE 1] Creating state file for next stage (2)...\n");
+	create_state_file(luo_fd, STATE_SESSION_NAME, STATE_MEMFD_TOKEN, 2);
+
+	ksft_print_msg("[STAGE 1] Creating %d sessions...\n", NUM_SESSIONS);
+
+	for (i = 0; i < NUM_SESSIONS; i++) {
+		char name[LIVEUPDATE_SESSION_NAME_LENGTH];
+		int s_fd;
+
+		snprintf(name, sizeof(name), "many-test-%d", i);
+		s_fd = luo_create_session(luo_fd, name);
+		if (s_fd < 0) {
+			fail_exit("luo_create_session for '%s' at index %d",
+				  name, i);
+		}
+	}
+
+	ksft_print_msg("[STAGE 1] Successfully created %d sessions.\n",
+		       NUM_SESSIONS);
+
+	close(luo_fd);
+	daemonize_and_wait();
+}
+
+/* Stage 2: Executed after the kexec reboot. */
+static void run_stage_2(int luo_fd, int state_session_fd)
+{
+	int i, stage;
+
+	ksft_print_msg("[STAGE 2] Starting post-kexec verification...\n");
+
+	restore_and_read_stage(state_session_fd, STATE_MEMFD_TOKEN, &stage);
+	if (stage != 2) {
+		fail_exit("Expected stage 2, but state file contains %d",
+			  stage);
+	}
+
+	ksft_print_msg("[STAGE 2] Retrieving and finishing %d sessions...\n",
+		       NUM_SESSIONS);
+
+	for (i = 0; i < NUM_SESSIONS; i++) {
+		char name[LIVEUPDATE_SESSION_NAME_LENGTH];
+		int s_fd;
+
+		snprintf(name, sizeof(name), "many-test-%d", i);
+		s_fd = luo_retrieve_session(luo_fd, name);
+		if (s_fd < 0) {
+			fail_exit("luo_retrieve_session for '%s' at index %d",
+				  name, i);
+		}
+
+		if (luo_session_finish(s_fd) < 0) {
+			fail_exit("luo_session_finish for '%s' at index %d",
+				  name, i);
+		}
+		close(s_fd);
+	}
+
+	ksft_print_msg("[STAGE 2] Finalizing state session...\n");
+	if (luo_session_finish(state_session_fd) < 0)
+		fail_exit("luo_session_finish for state session");
+	close(state_session_fd);
+
+	ksft_print_msg("\n--- MANY-SESSIONS KEXEC TEST PASSED (%d sessions) ---\n",
+		       NUM_SESSIONS);
+}
+
+int main(int argc, char *argv[])
+{
+	return luo_test(argc, argv, STATE_SESSION_NAME,
+			run_stage_1, run_stage_2);
+}
-- 
2.53.0


