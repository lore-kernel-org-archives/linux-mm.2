Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA393F9D0FA
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 20:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D312B6B0093; Tue, 14 Apr 2026 16:02:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE13D6B0096; Tue, 14 Apr 2026 16:02:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFD316B0093; Tue, 14 Apr 2026 16:02:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ABCF46B0093
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:02:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 29794578AB
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:02:47 +0000 (UTC)
X-FDA: 84658234374.09.25C7A93
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2E00A18001A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:02:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PW8mDIEg;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776196965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yCXGOxyW+pw6N8ft4rnwW7MuGB9g0PHpMRF3XlVYG+8=;
	b=G3ZkvEPNO3zOsmoJgb7WXDbloijshuPPjCJcYqSM3YUrq+1V6L5MN85qV0FZcQvKC/Szzt
	qYXFFBw5O4/8BkvthXFw1pxr1VqNOpygOlS8I1yZNFHsV6PUA4W26u3CTFmpHHMNavCdhq
	KQhrcQP9p24eDz3bjHxyVlrIudkYRJQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PW8mDIEg;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776196965; a=rsa-sha256;
	cv=none;
	b=FvO774q8p2ONPRPJwPYEQnWFVke7/h7QfqFZZ1LM0m7TWhcnZu09T9u0LM7fJSROX0DGCt
	SXHGx+01hh5XY1sVkrI2eudskx2idVAVw4Mi0j8mTsUZkQHiRFqD0499oqZPimuQ/eE7hB
	crg+R56dqIuAefvosU85DrhwS4R9kkw=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8ac9ef74131so44813076d6.1
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776196964; x=1776801764; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yCXGOxyW+pw6N8ft4rnwW7MuGB9g0PHpMRF3XlVYG+8=;
        b=PW8mDIEgGrpEWtjG9KkiGrpN7qpf/PGxDIgRlE8/ImiB6zKFIjxz3t7nOWUunVfeur
         ZY0UsD+XzwvOL8/nfRmHuNzt72vLmC1jsDSiI1+5BOr/TNuNXxsWN65oaTq4DSM9GbWt
         r44Yw9fDBbKmQQIiNwG2Sf3ppuGzdevKU0kzlmawLRAfaUWAfSWF7329n+OO3G9eHWXd
         3+i5w3dY3cJwTYmQij6Ejwm5ZAAfyFVZFnT22IqqpiC4b34l4h8J7u9NJOqJDOqKUzdk
         d8mLDiowWYALKKoRaWvHKxeatoQHHyVw0Th3qn1o3huxPMiFmAyJZNdHp0cOiAu0lOtc
         NsKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776196964; x=1776801764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yCXGOxyW+pw6N8ft4rnwW7MuGB9g0PHpMRF3XlVYG+8=;
        b=e5NQ5zK8yrPaNmR96tMoMA647ixW/28maMH7WFBjcDCuNc2qTS6toiObOt+aklc7xA
         aVmhtWemYLkREvm7v6wmkvcaUfsRDBBc2lD6BCUUJ0Dw2XJOALp3XTStNWnRWyRHSXvD
         zSNJsv46ryXInTANQqS2Sduh5TKFjaUST+SoQP8wJ2v5CajwNSRXWIjqDO9H+9EgwGVb
         ArXHra94ugsc3PhFK6kLTMLsGrgmJtk4CVbHSKAy4WeS5EKXwgnsQ7VmNXk1LZqkUiI5
         sZIlkscw1kRdEH5pc37KPs8TroBKsNBbOuqomvGWjau1EwYjgB0s1rRYijSVBycWTgDT
         RS/w==
X-Forwarded-Encrypted: i=1; AFNElJ9o9cQWNBl5mxC4X3CeFMsJwrOJC0Pz3NFY08jh+dMr8OxEwQDehjLud+Sk6HSNjRM0y+VKqnfBYA==@kvack.org
X-Gm-Message-State: AOJu0YwCJuLLUZHKrUbOY+DOG4bHpotYjZiBWMe22v9KIjSM/hLvSDCX
	z5rNe2NC6B8/7ScuralbsaTTMbA8/+3oVg65jLWUCmFaGypXr0Unyw3gSMWC13sLj0Q=
X-Gm-Gg: AeBDieuhlWsr4OHUSk2UgWg2ls3tCGRIda2L8tL1wzB7QV0z6TQKiDgzK1VctQHoyxe
	Cy6fMattus6PvaGjiuySaYW5IhybTlq5cTyvZVts+6PggY48ivB/cRQYFi6SDrCjAxP2xH9B79Q
	YGdXchibfscmQBE+4XOmnhH3yQNoCFesM40p5/uXQAupIhkEnFr/FgE3IQDCvYm10btwtjpkhJi
	3vD1fGskwdyha/4aMR5D512wZ/vPAj5Fiu8OajoegarJPkp9A0GZg8+XcEy+VU9mXWM2qIa7mqn
	f3gIRcn2YIpN+U1HsFNqugqU6rcQo5XRR4cSJeXkE8LYAUNRaYnGlXEq8KuvPPkC/XzMuFcFich
	+nVHMrnNfTEFYBD4aI4bgLCuTyi9//7AqHQ2VzV3Yvyay30sJLzaZLTEKFtgwQuX9QXZWpxpKtr
	G+UJOrljvW4cQpqDmLh32pXZn3hdGhoaiKM7SaORc05EPpmbSG1l1pokO2c3yhE/iOtQ==
X-Received: by 2002:a05:6214:f24:b0:89c:4cb3:4ea1 with SMTP id 6a1803df08f44-8ac861ef1bdmr302331696d6.20.1776196964120;
        Tue, 14 Apr 2026 13:02:44 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac84a180a2sm132213656d6.15.2026.04.14.13.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 13:02:43 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH 3/5] selftests/liveupdate: Test session and file limit removal
Date: Tue, 14 Apr 2026 20:02:35 +0000
Message-ID: <20260414200237.444170-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260414200237.444170-1-pasha.tatashin@soleen.com>
References: <20260414200237.444170-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: h9n95jw84uxqi6mh1j4k6jqikwncaqap
X-Rspamd-Queue-Id: 2E00A18001A
X-Rspamd-Server: rspam09
X-HE-Tag: 1776196964-794258
X-HE-Meta: U2FsdGVkX1+7QHWKhJxAP70CiT9Ar/66Bg3+1NeQBLE89Ozv0m1yjo+10RM2z6+skEptodFkIC9m3oCKzoH6eHq0P1Hon8rr0gBtdzpXRos3DZ+xQiipLwFImJjHFq3Ki+XmTUSyHG/jyAebUv/Q0xdXJva0w8sH8RWBTURlZZBKsKLMU+SZrz5wFpgo46YGU7dvrsLoS5T2dPnhtsXpMB5SSksANfQPiw4tt4/ZD1gee3RPwBLhj44stKIxmd0pRjB4jRMZoABy9FBlbyN00fz2PLFJDX/tXFlxhS29kaL9BeWu0blYg1cYsSbw6w/Fs4F6mKe6cFwGGCyNgCjvTIs1tKd07KwTuP4BSoGNycJ6xeuxHTcn8/Wti5x/qnkuWrvdgFv/kaBnvkzKbn2QW6oAhPMKNb+P3/QNbYEsiGDnPuY7HL/8R3jU7EFmLa0EQuv8am3i3qulQONT5J4EE+bQrslUnQeTXlNWe3dkatsRStb/ASRViY8LwdnChhjyUz3syG/t+4+Y3S/QoBqPZCYsA9eisjIp8fgR6bRV+4y3NfmvWErxrJHJZS5c6DkK6pHkJRGH0tQdAxr9Vsi7pjE+AfiS/mGHaPs0ucni65xCo5MB2BdTibGDQ+JvyK3PfiBFrWAQQesiXK8vKzUHITbkyrhrQD/Ko37iI9K8l8E1i5i8DLY7sE5RXJN/2F5irN3WWvRkOqH5g99Yaoq4hkTHeUhEz1mUt7+Qw7+so9A3Y/pm0pU1M4VKLBUEacADpZp0rkaUszgPJU1E5G67A/xOy+Y1bS+6Yyuck/WlKVj6tXJQmxN8x3YH8NbJqLXxFCMZoynULbrwM6IgaN+ho04wSNEO7Mc4aUraHt65CNfhzv8myRzPu3LUBR8hD+1Avh+I3FE3SKNDVoaI9DNYwDfvy+gpVfgWUyns058oy0FQsdlriLBIqfdtwGlHc1uXbINR9gi8h8rXe32IJEU
 8bWr5vH/
 qxTeDQor9qLNppjy4LfWAvt+xXkqrlnzCjxxOa/dvYI6EltcJDfIG6bsXbkJ58jMxZ/2N0yZ+OanEdPFewjvUx1gHyJk/pKRRbyAONKhf52NvAkSf03didqBLQBfC1+1C2FLidT7+vVTVXJZ0famj9PW3JwR652/+gk44jNvHk6Fj2QI/DssK43niB67IaeVOq3IdRsKrLiqEvH0jedMQGxArQANR4ZSe8ajI3x9DDtVyIwsk3JPNxeKIBzWBb6c80ppWzu/MiY6qPW4sxV6J48BEbXxQkp7ZqAzCvET9B2gkDSGPCzyC6akYd5jkAIjO3r5f6UUbdiBY3qk=
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

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../testing/selftests/liveupdate/liveupdate.c | 99 +++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index 37c808fbe1e9..0eaf97b19267 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -22,6 +22,7 @@
 #include <fcntl.h>
 #include <string.h>
 #include <sys/ioctl.h>
+#include <sys/resource.h>
 #include <unistd.h>
 
 #include <linux/liveupdate.h>
@@ -386,4 +387,102 @@ TEST_F(liveupdate_device, prevent_double_preservation)
 	ASSERT_EQ(close(session_fd2), 0);
 }
 
+static void ensure_nofile_limit(struct __test_metadata *_metadata,
+				long min_limit)
+{
+	struct rlimit hl;
+
+	if (getrlimit(RLIMIT_NOFILE, &hl) < 0)
+		ksft_exit_fail_msg("getrlimit failed: %s\n", strerror(errno));
+
+	if (hl.rlim_cur >= min_limit)
+		return;
+
+	hl.rlim_cur = min_limit;
+	if (hl.rlim_cur > hl.rlim_max)
+		hl.rlim_max = hl.rlim_cur;
+
+	if (setrlimit(RLIMIT_NOFILE, &hl) < 0) {
+		if (errno == EPERM) {
+			SKIP(return, "Insufficient privileges to set RLIMIT_NOFILE to %ld",
+			     hl.rlim_cur);
+		}
+		ksft_exit_fail_msg("setrlimit to %ld failed: %s\n",
+				   hl.rlim_cur, strerror(errno));
+	}
+}
+
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
+	int i;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	ensure_nofile_limit(_metadata, MANY_SESSIONS + 10);
+	if (_metadata->exit_code == KSFT_SKIP)
+		return;
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
+	int session_fd;
+	int i;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = create_session(self->fd1, "many-files-test");
+	ASSERT_GE(session_fd, 0);
+
+	ensure_nofile_limit(_metadata, MANY_FILES + 10);
+	if (_metadata->exit_code == KSFT_SKIP)
+		return;
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
-- 
2.43.0


