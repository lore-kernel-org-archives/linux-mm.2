Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99567CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92FE16B009E; Thu, 28 May 2026 23:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9082A6B00A0; Thu, 28 May 2026 23:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CF656B00A1; Thu, 28 May 2026 23:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68D056B009E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:21:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 343B11A1103
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:23 +0000 (UTC)
X-FDA: 84819006846.14.8206C54
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7446BC0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PXZxiRWw;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780024881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/PRPWvWF9f7qW0XjjBpwGc/NadY8LWCtXHDn2RYoSI=;
	b=G61a/aasr6cd+UI6RQB4RHOzY/O4vOvOQ10G7zv9njM399rDFHnfiFgTE2Rybv9g36seTw
	0Pvf0UA6z5VxhnmdVTdG1tupNltOoxmPVFM8OOBhSqz3/Kl0/VeHFDfnzTwCglcvwYO9OY
	C8GGNAbOCUM0SW6k6x4Dh52pmjZKJp8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780024881; a=rsa-sha256;
	cv=none;
	b=2KQVddUqTJOg3J1Rr4t60ycMdTTdIihkxkBKVJVJHaB3rU/DNVeBm5tQHkfXz7bduxAOE+
	ngwV24OnxF12q2G3nfVgD7qznr41Yhx8XZzxA6ItHcjqpRRxF5pIMab4H+/Byg+bQwiWtA
	Nj0V2uek53DOZuA6SrbcX3XvMndOupE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PXZxiRWw;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5102582e23eso107089031cf.1
        for <linux-mm@kvack.org>; Thu, 28 May 2026 20:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780024880; x=1780629680; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l/PRPWvWF9f7qW0XjjBpwGc/NadY8LWCtXHDn2RYoSI=;
        b=PXZxiRWwb9W/83vF7K4CpvYHumqEfIKv9BVYIfLPbKPc4pNiyL/OXHteDMHF21Nbkc
         TU84VSTViceP+UHTxO97AfGC+n+v3XqZboiXU765q+1I+81oHMBy+WGA3A3ouaS74xv0
         df8Tqz8YBN8IL6JFNij91+sh6KByuncRFpnVk9bUrWy9bE2fml55r8yT1OZENuJa58p5
         CnxjI8qwNjSH/R1RqnoBc4V/ceKvXO1fsr0MVJJymkznUG0b1/UToeQp3NMjDEO4Qk2l
         IjP7ikXw16KX1LoP0GuOb6cg2wifEGqvy7NBr9zyqwx2S/UJkV7HUiKIV+HB+pn+/nzY
         Slew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780024880; x=1780629680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l/PRPWvWF9f7qW0XjjBpwGc/NadY8LWCtXHDn2RYoSI=;
        b=GojQ7Gq4Xal67TRmNRSe16SqdtXOTlcpUdmASYljBvLcJdFHlbv6mvMeYQ7JYV5F26
         CY08DayXqb5iql/96pskAMwh+/GTcwTIF0hSYRZQT7Gbr/7Wjv48w32C8T3Jl5UbNovt
         58g2IN2BZvzvhwPJy1WtqS56lgVCIuwuVfRjSYSxSjVO6rqeUjn5MPpMO6murp86NZzt
         E1R399tgBztFZ46AsvVCyrU/hn0KOSXnBXNkd7aiPn6nNUi6HXdiuWoDpeMkAHhI0bZT
         RDyLNwtnZhd5BcCHzOovAynu2Id2oTh1acITpfTrsPSmMDXkgGw+v8do/IUOO48qHvI7
         amiQ==
X-Forwarded-Encrypted: i=1; AFNElJ9eM3Et0oqigM76UGK+usLfDQfeV6j5ooqgHk9MDFyT8Dqcay8hZGFjZdA5slrVeFF9jkSDSbdPYQ==@kvack.org
X-Gm-Message-State: AOJu0YyWGESAP5zJ7IN0TCKJf0msriTADqk0A8zDNpesmpMWALkLHnZ/
	RjK/aPTlVFsE5PBrh5eMxL3KZEDWhvR0wBOYJFjVJFWCHS6xOjqeg+u4BqLvA7GwCes=
X-Gm-Gg: Acq92OHdgU4pgNWn8xjGHMvDe2H88PI8jL8LXRO4AmgtiACKmfhanPtXh9XXoI1g7TV
	q9Fg2i4McLDORa34bxtbDkJeiLMXfQq90mh2YUYi5Tooa2WBMaLTYfYBBYpXOH1YCQFtTAQKdeg
	q+G92mrYPNq7UslF6yjo6+qhLMTyEF/xUi/BhC1yHaDBT1ZrlPEIQwRwArIA1NHkWEhuXy8PQnR
	9e8MKYUl5AE4ckD/3nbZAZ3Vo+iCa0qP/wFeJKanNUzhn5PynvDQCIbXHgC2iGigR5k7thxCAsc
	RonEnY9FJcLB/f244eqOubzUhStdywE9s1kN8NkITSpuju1tZYsJiUx7OzE2Cz/9VO0RJ5dmpWF
	prAcMLn7sf/r+ITRkDiOolyI+JQ40PKqxB1vKZMtodNz8MyL/0LCj6lEUsByqPFdYxNUT3ZvCIE
	Y39r92wPTC6MPKRuuWt8trPMje9NTndd9i2kLgBkqbU9KxD9aGPSnwq60DRL+KHvsSuz51s5/n
X-Received: by 2002:a05:622a:5805:b0:516:e722:5ed1 with SMTP id d75a77b69052e-5172dd1e2a1mr15106211cf.29.1780024880588;
        Thu, 28 May 2026 20:21:20 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea26d286sm1179476d6.48.2026.05.28.20.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 20:21:20 -0700 (PDT)
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
Subject: [PATCH v3 09/11] selftests/liveupdate: Test session and file limit removal
Date: Fri, 29 May 2026 03:21:04 +0000
Message-ID: <20260529032106.1505796-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
References: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7446BC0005
X-Stat-Signature: 7jz6diyg3uyqb16depsj15hgmkpnzynz
X-Rspamd-Server: rspam06
X-HE-Tag: 1780024881-155352
X-HE-Meta: U2FsdGVkX1/IYxUkcIyNK20QVwQj8qHDZsUC0CSB3upqEZK/tgBrlxH9GujrA6nzZWobUopf/3hRbAU/hUqIrgLoHXsxU+FN9/Bpvsn823CkZS8MsHYD5bnXEFPyoJ0DUm+Sp6ugjyUIRqlCd7SGaHM2nLmEwdsV/gGQ9Pqd4wBYrh9rUGz8eY0Kr2okhMUhVr297dM3p3LaPeSgHNnPOi0mpen5Adxoy9v5waiWms7zAgItaBXzT06nh/9+9WxkHtuqvlZrPjJoNobdTMyEoP3Y/702+EastgT2kvNXubnI0ApXRmkRWZ+5pYiilJauO2v3yNC7TEw7sB3yFM9fOVet/HkjsPXHlvjEwrweBoSE1VQjvUjh4guKIrt4Cp8e+Seo6jNj9xzHWVSPosQH+eJZ+CoghzlKgI+4+mVqqesKXatVjRIMXrny9FXvk/xu+3168ex4y/MY/2oiznxDw5oRzTeMt/vFJhHOi7DqmaUe529FHS49+wysUM85+6cmQhxSxaGuLsHu3fBArpWf6TRhSF3FVds3FVcJh66uZTdSWL7KLXfDgsciQ8f1p3zXJ+JuvP57XI6zuzR0broyXOpPZz6+pGanCqSzgfsV+KjMb7fK2YLAeUtkEHg01fnAh5aBEQO3he644k80ychhNt+PV+7EAoob5qeUau53Dv4PIpEj8P1ffkEY0WbojY67edBZdkl5ncQfTQbZU5wHMXfh7kNz/xPcwhVzUyV6Hv39ue8ihc+fqcAGrhUjK5ggfzr9v0gqkEonSJKjxHO1OwvjST01D9Uc7PAXhXbHpCnuWuB8G2Co9trEVHmuJ4AQqPU9XiBv60/MKCuKXHRG8Vh+aasxGF7DIFj/kW7qsMY/ZfQJgTaV8FAQHkW8GcXiIeEIVg1FSlxAfDN0OucLlUb+awnWbdj9IJSui32Sn+8ZTu8iCQUuCgPq65o/LqbHp9aVJO0gF2eaJoIIyJz
 EPJKZcE7
 z/epkbajBEnHig9mO46o7dfB38uxo9OSPBZDTsdURaXLI805LdzQTsGX0rB1oYcYWrbWdWYu12F/jnBytirRa6LNwjnzNw4ut57F2JE7WbXgTBU4Fx8L4uNykXKJrPzF2L3dHkOLo+RmU10fCCOwYLuIHjz4oKJkUu0BROiP9qzq6K7t9TJcdjnNWQPUsc6eESQM8SGMTFbnlIucOm3afLvJj/qcmm+zC8q7tCf6H50fBIkL0PIlFBKmi/h2D7lDtJlzLuN8l6EDg2wtzS7JYVxj/moTMc8UKX+NhFpn9gZR1S9lNBHmwRYelQcPzncqIufmUyATsAp0ikAwdixbNFUzhx/htLhpv0aXGzVaJ2n61tl8hMspLGgiDPi6dUJHUSRGEzDdSAvrCDrsI1HQZqLnRUF47k6oOhyIumWYTcv0P0XA+KsWkqsyrOstxtXWXgbYl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With the removal of static limits on the number of sessions and files per
session, the orchestrator now uses dynamic allocation.

Add new test cases to verify that the system can handle a large number of
sessions and files. These tests ensure that the dynamic block allocation
and reuse logic for session metadata and outgoing files work correctly
beyond the previous static limits.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../testing/selftests/liveupdate/liveupdate.c | 75 +++++++++++++++++++
 .../selftests/liveupdate/luo_test_utils.c     | 24 ++++++
 .../selftests/liveupdate/luo_test_utils.h     |  2 +
 3 files changed, 101 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index c7d94b9181e1..502fb3567e38 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -26,6 +26,7 @@
 
 #include <linux/liveupdate.h>
 
+#include "luo_test_utils.h"
 #include "../kselftest.h"
 #include "../kselftest_harness.h"
 
@@ -499,4 +500,78 @@ TEST_F(liveupdate_device, get_session_name_max_length)
 	ASSERT_EQ(close(session_fd), 0);
 }
 
+/*
+ * Test Case: Manage Many Sessions
+ *
+ * Verifies that a large number of sessions can be created and then
+ * destroyed during normal system operation. This specifically tests the
+ * dynamic block allocation and reuse logic for session metadata management
+ * without preserving any files.
+ */
+TEST_F(liveupdate_device, preserve_many_sessions)
+{
+#define MANY_SESSIONS 2000
+	int session_fds[MANY_SESSIONS];
+	int ret, i;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	ret = luo_ensure_nofile_limit(MANY_SESSIONS);
+	if (ret == -EPERM)
+		SKIP(return, "Insufficient privileges to set RLIMIT_NOFILE");
+	ASSERT_EQ(ret, 0);
+
+	for (i = 0; i < MANY_SESSIONS; i++) {
+		char name[64];
+
+		snprintf(name, sizeof(name), "many-session-%d", i);
+		session_fds[i] = create_session(self->fd1, name);
+		ASSERT_GE(session_fds[i], 0);
+	}
+
+	for (i = 0; i < MANY_SESSIONS; i++)
+		ASSERT_EQ(close(session_fds[i]), 0);
+}
+
+/*
+ * Test Case: Preserve Many Files
+ *
+ * Verifies that a large number of files can be preserved in a single session
+ * and then destroyed during normal system operation. This tests the dynamic
+ * block allocation and management for outgoing files.
+ */
+TEST_F(liveupdate_device, preserve_many_files)
+{
+#define MANY_FILES 500
+	int mem_fds[MANY_FILES];
+	int session_fd, ret, i;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = create_session(self->fd1, "many-files-test");
+	ASSERT_GE(session_fd, 0);
+
+	ret = luo_ensure_nofile_limit(MANY_FILES + 10);
+	if (ret == -EPERM)
+		SKIP(return, "Insufficient privileges to set RLIMIT_NOFILE");
+	ASSERT_EQ(ret, 0);
+
+	for (i = 0; i < MANY_FILES; i++) {
+		mem_fds[i] = memfd_create("test-memfd", 0);
+		ASSERT_GE(mem_fds[i], 0);
+		ASSERT_EQ(preserve_fd(session_fd, mem_fds[i], i), 0);
+	}
+
+	for (i = 0; i < MANY_FILES; i++)
+		ASSERT_EQ(close(mem_fds[i]), 0);
+
+	ASSERT_EQ(close(session_fd), 0);
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/luo_test_utils.c
index 3c8721c505df..333a3530051b 100644
--- a/tools/testing/selftests/liveupdate/luo_test_utils.c
+++ b/tools/testing/selftests/liveupdate/luo_test_utils.c
@@ -17,6 +17,7 @@
 #include <sys/syscall.h>
 #include <sys/mman.h>
 #include <sys/types.h>
+#include <sys/resource.h>
 #include <sys/stat.h>
 #include <errno.h>
 #include <stdarg.h>
@@ -28,6 +29,29 @@ int luo_open_device(void)
 	return open(LUO_DEVICE, O_RDWR);
 }
 
+int luo_ensure_nofile_limit(long min_limit)
+{
+	struct rlimit hl;
+
+	/* Allow to extra files to be used by test itself */
+	min_limit += 32;
+
+	if (getrlimit(RLIMIT_NOFILE, &hl) < 0)
+		return -errno;
+
+	if (hl.rlim_cur >= min_limit)
+		return 0;
+
+	hl.rlim_cur = min_limit;
+	if (hl.rlim_cur > hl.rlim_max)
+		hl.rlim_max = hl.rlim_cur;
+
+	if (setrlimit(RLIMIT_NOFILE, &hl) < 0)
+		return -errno;
+
+	return 0;
+}
+
 int luo_create_session(int luo_fd, const char *name)
 {
 	struct liveupdate_ioctl_create_session arg = { .size = sizeof(arg) };
diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.h b/tools/testing/selftests/liveupdate/luo_test_utils.h
index 90099bf49577..6a0d85386613 100644
--- a/tools/testing/selftests/liveupdate/luo_test_utils.h
+++ b/tools/testing/selftests/liveupdate/luo_test_utils.h
@@ -26,6 +26,8 @@ int luo_create_session(int luo_fd, const char *name);
 int luo_retrieve_session(int luo_fd, const char *name);
 int luo_session_finish(int session_fd);
 
+int luo_ensure_nofile_limit(long min_limit);
+
 int create_and_preserve_memfd(int session_fd, int token, const char *data);
 int restore_and_verify_memfd(int session_fd, int token, const char *expected_data);
 
-- 
2.53.0


