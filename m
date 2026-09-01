Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFDA7C624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 222C36B009D; Tue,  1 Sep 2026 14:07:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1816B009F; Tue,  1 Sep 2026 14:07:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C02C6B00A0; Tue,  1 Sep 2026 14:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D2F836B009D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:07:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 65542C04B3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:07:31 +0000 (UTC)
X-FDA: 85165975902.10.3B2465A
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf30.hostedemail.com (Postfix) with ESMTP id A557C80003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:07:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EbIAk9db;
	spf=pass (imf30.hostedemail.com: domain of 3YBSXaggKCEEgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3YBSXaggKCEEgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788286049;
	b=wIaJwxcnBgechEWnqUk6QHQkeRlBcSelLx4QRLwZsr81MFY8Kw6mlVw/1oVxnwf9dm23Fc
	ETL3CKOybS4ZBD1RRNqEeTbACp2LkqrNyzATBiYEBSB+Vv3bH4VJ7/YEpXIlvQa1RzAZIb
	yHYHsw+Z5B9pWs1Qu++uAOUCHIRTjlc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EbIAk9db;
	spf=pass (imf30.hostedemail.com: domain of 3YBSXaggKCEEgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3YBSXaggKCEEgpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788286049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EEIZgCOB2hl947kqAMQSV91Zoox41yoYUfb/qDb9/EY=;
	b=pzEmxTaqdRwe0yKvIqFRXdLUkp9Tl8sIdc+7KuXeTpG58HAgoM+H3NaQiWcdpdbByaGHWh
	xQ3gOIsUHcB7zTcb/c4MrkBBbp3M2pzbH/czXh8qETNS2wi7y+N4vpJYgfvm8MonP23K/H
	/hrpOP5m9M21HE33h5x7X3FnDWsnw0M=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38ec0f510a9so227042a91.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 11:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788286048; x=1788890848; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EEIZgCOB2hl947kqAMQSV91Zoox41yoYUfb/qDb9/EY=;
        b=EbIAk9dbMrEr3//qosw+JA9LYZEh1qQpPNxAlihWTfuVsHh2oqWlRbeMsxEXZr7r81
         Y7HuAwnlDfDUMzlhitmrXZq1On/ZdCgvAX+m3kDqhVl0YTHNc2NDUGVJJ1sL3I6l3/Mf
         PvIENu+q3SK9Xxk77cSJoPYTA8pFOwJ3SOXatKoKqiMJhZ67i30dxDYxMPCbWLiF5P9f
         eRXgh1VIUdEs9+UwUHNoOVAwiOMnx5WTWZ+jvTibcDcqk2vxqNW2zyHQWPB3KWBUp53T
         i7kofqMUmdzuCB+8M5QhvSVc+iMV+KgmTWBpezC5yYzitIrSNtDGs36i+LZUu7sSSSjq
         9N6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788286048; x=1788890848;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EEIZgCOB2hl947kqAMQSV91Zoox41yoYUfb/qDb9/EY=;
        b=s1oOKhJJ4wNUPWjLlN4Dm+LR4asJZ1Nen4G3n4muOVTPuyezwkY+tfJnVJ9LRe9fWh
         lFlz5ijE7eO6v/Ae7XT5gshCQWjweg2euvU6LtWoRtVykOe5Wn34Ff7GSwXuGzApOiUH
         udgJP3Lewnb6cuUk9pYmeclbj97zoiiRu8RV7CcGb0qw7gBHqmey/GOcqpxi4+i1XYIr
         kYrmnEQwbAy9UnaUPgK4gVzRreml6kxOMkXFXa13fP5IqB7/vfyZAv+8b6dP/d+eadxr
         YY3GEInwfD0bLw/7XYJvVwsy2+U9HwyMaCHlYuoxnzav/rZ5wzv6C2394cj2etcbt/iP
         3lyg==
X-Forwarded-Encrypted: i=1; AKwUvByuN4ajOpYPZQ5/JyLCMh3+DpduhFV0JfYjs5wHrqOC5QroPTCxTosmj6UK5LURk9YRI3mCHCGEFg==@kvack.org
X-Gm-Message-State: AFuF++k0pO3iYYRFfVPtIzt5/Sm0Qf4XXrlMdQRjHhdsJkbFJzy6fzZg
	tkzzRAl8AKcYQlqrOCOnz38JLBdhEyJFiORRnbIBw8+YIjrr+0iDOfi+K8LdjEQQuH9I5wrJFYG
	Ar3WFBOOmmiklJg==
X-Received: from pjbiy13.prod.google.com ([2002:a17:90b:16cd:b0:38e:b470:e6db])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3fcf:b0:398:9be5:b419 with SMTP id 98e67ed59e1d1-3989be5b4camr43204014a91.20.1788286048322;
 Tue, 01 Sep 2026 11:07:28 -0700 (PDT)
Date: Tue,  1 Sep 2026 18:07:13 +0000
In-Reply-To: <20260901180713.4185641-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260901180713.4185641-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260901180713.4185641-6-dmatlack@google.com>
Subject: [RFC PATCH 5/5] selftests: liveupdate: Add multi-session test
 coverage for session_retrieve_into
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A557C80003
X-Stat-Signature: 3aa1d3sdok5yopcct93hp1kug56ywrbs
X-HE-Tag: 1788286049-991508
X-HE-Meta: U2FsdGVkX1/eXxAD/U1H6Ph3nMrMDvA9p+nBXRS5Ucfo3nYtEWFsMZvfvyY++ZTDGLts228q+ypEtBQuDiEouSTAXWfwOerC2oZRjbUfVRjsYyJRMdrygR4c7tdMq7XKw6S2XQcsl6SC+G9kY6OHUPkvjNak9iqtwGpJh8IxQAR1k3zTmDFeDAWhZfiSBvS3cAyURXobo7xsaon8vbWaMuMlHnYbUnF4hJWcGGvvZnkSr1JBQfIQ7bw3fDpe4w55xMD2PbXV9gkCF0CCe39zlXSD2LWYu7xbxDbnsiC2rbbmrXJ/RMymiCVSapAE52DyTIFHJkvBfIswaZ5YaDOUH/hpfZBc7T6QR7ER6N4CkHCMLQM59ZvxadFFnKqK34KNRAu2DtV2F466h4nhxkqBBnNy30fES7ml4Ahm9EK/HdAVrQigJiZWRhqrjk8LBTMgz2zl8mcXnXRgxLsd3cAMX0dTRa0MC2203L5krAVoLEOC2580XKpfwj7faszY8V8i3790CqmH1Gph+sMNOFTltebDpDsm9OMK2+QT5eAT5KUmyl7cisPeDpnZDh3Nd9cL4QtN0oG79YnC/w2pII/7GhkzqLFjSdva0uDX2tunfMmLMTUzYyFCcqUmr2pz6Xt8AgBvV5SQ4iH0+Lkjh5XdbyOMPknoPpOcYCyLCGy+p4LOfkyBSVz2QJodmVYEDNhgb3PQV3k/KSvtFjpok2Ac4VvP6xIM6DcTE06A1mw8NBiaKDohintUamv3+dIQCWyOYYZcu3hyYwV7RnLWyVKSD+1fUJIfQdnwJIQR8uNqtQfYuC1moyUPM5++vjFLIbw/Pb/fp2KaPrEHIcHVNkGxEv9IChhAeMLtbgdQvqQptDjpIWjP180ua3CAYtvxn1+ZqkbkNz/3YMyyn4vICrRTUQrVeAAHJ0+RlSydp5qLxDyOuv7eM2TeuYVYEo1qCF7Pum1q5+xLbE4qtjthcRa
 BhBcFgF8
 bEH1anOIcsAPcNxuHXLSjT8VI/Gy5KRRcET9wl2JQv/h/vc6gjBLRs27Iu9zFwfaXm6xQ8xRplQHv3EPiGdXr0OO/rTP3tXLjzhyuB8TiIivizs6p1MNwUC477ZpSvxEo5LRRsrCOVh883roi+ATSumRgdjopXIKDFLdCi/7bVQ//voFet7oai2EARLTEAsUncl0l1tS47E6urgJG49LIwQMO8ExP0JFDDKzfE01JdmJBrViPEWT/Fcop02TF0mEwtnof2D6O/SwFft2sHe3hyInaMc/lXftrzRToaUhbBLq5/PTfDeB5r6WVVrO0e7sNT51cfM+LOtTE/QA38loZIGsAqkv+TN+hDINl21D/oKCSYFfMTLHgtBxGrGLkE5geuV/1hzaY+MW8WhuT65DewPR3zcOAfBIWQJS4CiBCCq0vjYNMzh83zmYlmnhxkyVA4Fo/+sqYkVAEi8weVQSPOKwWXSp7BpDcM2bxNc/Eo08Y2hZi8UPQzs+kSkQqy0kXERANxKg4aaMdRp6XJlbNmI5NLXfEzJt4z4yEKhFOFj/5XM7pXsBcQ40tAMdJBvD9G+DeufH7rgTCyS9E7IzGG7iOUq5rECEpm+Biz2CpsoD9sFvbacTW3dNHY/VZvnRaWSzluCIsgkruqnI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the multi-session Live Update test to specifically verify the new
LIVEUPDATE_SESSION_RETRIEVE_INTO_FD ioctl path. In Stage 2 of the kexec
workflow, the test explicitly delegates topology by allocating a clean
tmpfs target and driving the folios into it through the new API,
verifying that the data preserves identically to the native KHO mapping.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../liveupdate/lib/include/libliveupdate.h    |  1 +
 .../selftests/liveupdate/lib/lu_utils.c       | 33 +++++++++++
 .../selftests/liveupdate/luo_multi_session.c  | 56 ++++++++++++++++---
 3 files changed, 83 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
index fa07fed08364..8ab1e662eeaa 100644
--- a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
+++ b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
@@ -33,6 +33,7 @@ int luo_session_retrieve_fd(int session_fd, __u64 token);
 
 int create_and_preserve_memfd(int session_fd, int token, const char *data);
 int restore_and_verify_memfd(int session_fd, int token, const char *expected_data);
+int luo_verify_retrieve_into_memfd(int session_fd, int token, int mfd, const char *expected_data);
 
 void create_state_file(int luo_fd, const char *session_name, int token,
 		       int next_stage);
diff --git a/tools/testing/selftests/liveupdate/lib/lu_utils.c b/tools/testing/selftests/liveupdate/lib/lu_utils.c
index 74d41115c281..8ed9c367f92e 100644
--- a/tools/testing/selftests/liveupdate/lib/lu_utils.c
+++ b/tools/testing/selftests/liveupdate/lib/lu_utils.c
@@ -324,3 +324,36 @@ int luo_test(int argc, char *argv[],
 
 	return 0;
 }
+
+int luo_verify_retrieve_into_memfd(int session_fd, int token, int mfd,
+				   const char *expected_data)
+{
+	struct liveupdate_session_retrieve_into_fd retrieve_args = {
+		.size = sizeof(retrieve_args),
+		.token = token,
+		.fd = mfd,
+	};
+	long page_size = getpagesize();
+	void *map = MAP_FAILED;
+	int ret = -1;
+
+	ret = ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_INTO_FD, &retrieve_args);
+	if (ret < 0) {
+		ksft_print_msg("ioctl LIVEUPDATE_SESSION_RETRIEVE_INTO_FD failed\n");
+		return -errno;
+	}
+
+	map = mmap(NULL, page_size, PROT_READ, MAP_SHARED, mfd, 0);
+	if (map == MAP_FAILED)
+		return -errno;
+
+	if (expected_data && strcmp(expected_data, map) != 0) {
+		ksft_print_msg("Data mismatch! Expected '%s', Got '%s'\n",
+			       expected_data, (char *)map);
+		munmap(map, page_size);
+		return -EINVAL;
+	}
+
+	munmap(map, page_size);
+	return 0;
+}
diff --git a/tools/testing/selftests/liveupdate/luo_multi_session.c b/tools/testing/selftests/liveupdate/luo_multi_session.c
index aac24a5f5ce3..7882f49aadaf 100644
--- a/tools/testing/selftests/liveupdate/luo_multi_session.c
+++ b/tools/testing/selftests/liveupdate/luo_multi_session.c
@@ -1,4 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0-only
+#include <sys/mman.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
 
 /*
  * Copyright (c) 2025, Google LLC.
@@ -31,6 +36,8 @@
 static void run_stage_1(int luo_fd)
 {
 	int s_empty1_fd, s_empty2_fd, s_files1_fd, s_files2_fd;
+	int tmpfs_fd;
+	void *map;
 
 	ksft_print_msg("[STAGE 1] Starting pre-kexec setup for multi-session test...\n");
 
@@ -53,25 +60,50 @@ static void run_stage_1(int luo_fd)
 	s_files1_fd = luo_create_session(luo_fd, SESSION_FILES_1);
 	if (s_files1_fd < 0)
 		fail_exit("luo_create_session for '%s'", SESSION_FILES_1);
+	ksft_print_msg("  -> Preserving memfd (token %#x, content: \"%s\")\n",
+		       MFD1_TOKEN, MFD1_DATA);
 	if (create_and_preserve_memfd(s_files1_fd, MFD1_TOKEN, MFD1_DATA) < 0) {
 		fail_exit("create_and_preserve_memfd for token %#x",
 			  MFD1_TOKEN);
 	}
 
-	ksft_print_msg("[STAGE 1] Creating session '%s' with two memfds...\n",
+	ksft_print_msg("[STAGE 1] Creating session '%s' with memfd and tmpfs file...\n",
 		       SESSION_FILES_2);
 
 	s_files2_fd = luo_create_session(luo_fd, SESSION_FILES_2);
 	if (s_files2_fd < 0)
 		fail_exit("luo_create_session for '%s'", SESSION_FILES_2);
+	ksft_print_msg("  -> Preserving memfd (token %#x, content: \"%s\")\n",
+		       MFD2_TOKEN, MFD2_DATA);
 	if (create_and_preserve_memfd(s_files2_fd, MFD2_TOKEN, MFD2_DATA) < 0) {
 		fail_exit("create_and_preserve_memfd for token %#x",
 			  MFD2_TOKEN);
 	}
-	if (create_and_preserve_memfd(s_files2_fd, MFD3_TOKEN, MFD3_DATA) < 0) {
-		fail_exit("create_and_preserve_memfd for token %#x",
-			  MFD3_TOKEN);
-	}
+	ksft_print_msg("  -> Populating custom tmpfs file at /mnt/mfd3_source...\n");
+	mkdir("/mnt", 0777);
+	mount("tmpfs", "/mnt", "tmpfs", 0, NULL);
+	tmpfs_fd = open("/mnt/mfd3_source", O_CREAT | O_RDWR, 0666);
+	if (tmpfs_fd < 0)
+		fail_exit("failed to open tmpfs_fd");
+	ksft_print_msg("  -> Preserving generic tmpfs file (token %#x, content: \"%s\")\n",
+		       MFD3_TOKEN, MFD3_DATA);
+	if (ftruncate(tmpfs_fd, getpagesize()) < 0)
+		fail_exit("ftruncate tmpfs_fd");
+	map = mmap(NULL, getpagesize(), PROT_WRITE, MAP_SHARED, tmpfs_fd, 0);
+	if (map == MAP_FAILED)
+		fail_exit("mmap tmpfs_fd");
+	strcpy(map, MFD3_DATA);
+	munmap(map, getpagesize());
+
+	struct liveupdate_session_preserve_fd preserve_args = {
+		.size = sizeof(preserve_args),
+		.token = MFD3_TOKEN,
+		.fd = tmpfs_fd,
+	};
+	if (ioctl(s_files2_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &preserve_args) < 0)
+		fail_exit("preserve tmpfs fd");
+
+	close(tmpfs_fd);
 
 	close(luo_fd);
 	daemonize_and_wait();
@@ -110,6 +142,7 @@ static void run_stage_2(int luo_fd, int state_session_fd)
 
 	ksft_print_msg("[STAGE 2] Verifying contents of session '%s'...\n",
 		       SESSION_FILES_1);
+	ksft_print_msg("  -> Retrieving memfd (token %#x) from session...\n", MFD1_TOKEN);
 	mfd1 = restore_and_verify_memfd(s_files1_fd, MFD1_TOKEN, MFD1_DATA);
 	if (mfd1 < 0)
 		fail_exit("restore_and_verify_memfd for token %#x", MFD1_TOKEN);
@@ -118,14 +151,23 @@ static void run_stage_2(int luo_fd, int state_session_fd)
 	ksft_print_msg("[STAGE 2] Verifying contents of session '%s'...\n",
 		       SESSION_FILES_2);
 
+	ksft_print_msg("  -> Retrieving memfd (token %#x) from session...\n", MFD2_TOKEN);
 	mfd2 = restore_and_verify_memfd(s_files2_fd, MFD2_TOKEN, MFD2_DATA);
 	if (mfd2 < 0)
 		fail_exit("restore_and_verify_memfd for token %#x", MFD2_TOKEN);
 	close(mfd2);
 
-	mfd3 = restore_and_verify_memfd(s_files2_fd, MFD3_TOKEN, MFD3_DATA);
+	ksft_print_msg("  -> Creating empty tmpfs file at /mnt/mfd3_target...\n");
+	mkdir("/mnt", 0777);
+	mount("tmpfs", "/mnt", "tmpfs", 0, NULL);
+	mfd3 = open("/mnt/mfd3_target", O_CREAT | O_RDWR, 0666);
 	if (mfd3 < 0)
-		fail_exit("restore_and_verify_memfd for token %#x", MFD3_TOKEN);
+		fail_exit("open tmpfs target for retrieve_into");
+
+	ksft_print_msg("  -> Validating LIVEUPDATE_SESSION_RETRIEVE_INTO_FD (token %#x)...\n",
+		       MFD3_TOKEN);
+	if (luo_verify_retrieve_into_memfd(s_files2_fd, MFD3_TOKEN, mfd3, MFD3_DATA) < 0)
+		fail_exit("luo_verify_retrieve_into_memfd for token %#x", MFD3_TOKEN);
 	close(mfd3);
 
 	ksft_print_msg("[STAGE 2] Test data verified successfully.\n");
-- 
2.55.0.966.g6673acef38-goog


