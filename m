Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0370DCC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 09:38:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3CED6B009E; Thu, 15 Oct 2026 05:38:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9FE76B009F; Thu, 15 Oct 2026 05:38:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8EC36B00A0; Thu, 15 Oct 2026 05:38:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B04F46B009E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:38:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 24D871208D0
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:38:45 +0000 (UTC)
X-FDA: 85324361010.11.12BCF84
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 55A4640006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:38:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VDflUfc1;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792057123;
	b=xafkfqaOWP1agf4k6eZI/4gJzB4q4Gyhnbtgx1OffZw9Bbcl+pwqiXDvMVgUq4FMXBGugI
	deXVvoyk0nqLbRR/TRAnvwoy7Z22jfFXSaeJsnVG3zO7mUhoLZJxU9VOySv8ulTpD/LYAb
	puBWv+H8En4nR3KBnjbgKKqc4ck3giY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VDflUfc1;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792057123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IPTzG9yeWgp2JFe+s9iO1cWtEwA5iuP2nn+kITzaTP4=;
	b=VpsHW+6bGaie/hRD7+PkKq97KU7hkrsSAUW8+dmcA0azW9m4l+Ojw+l73HGOrRGO460M5z
	NCNCdsAlpgAsqIQLxAkmu4+07VvXApLY5t+ZwLxyUvE6zeErqUOKsrtinQvFRVT4P7I8dz
	Suk3XvLC3RTOQOlvaQ9TGSCGQfxafHQ=
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5e82b413858so452242e0c.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792057122; x=1792661922; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=IPTzG9yeWgp2JFe+s9iO1cWtEwA5iuP2nn+kITzaTP4=;
        b=VDflUfc1S882ev0rsN+zir6LJ9KZ6aflspz9WUzrCLHbxwJXjndp16cpmvNx0gHTlo
         qWl5ClvuLctGAemA7suLv64S/6OT113jDvZc44XD0gyDcVK3HQfIiUxVa68lkkTZXHNV
         u/ZoxgYpXlq+lgJKZ22RtcQOwU85plH9xEeXLwNYKFI2jIBPXRF0jQDYw8p0UpGP4OKg
         pEcGoBd+bARC92fJ2ctRnbKeG0JAVRmJKxwdVV8ihqsqL3AMBRspgCi5KBqRG9L2j4QH
         ZXoBs5uhDNPNbtLEi68xtIOyG7kEaDmxd8a52al8jW/3PEC4EvmoN216qzSPynBHJJXR
         fnHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792057122; x=1792661922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=IPTzG9yeWgp2JFe+s9iO1cWtEwA5iuP2nn+kITzaTP4=;
        b=OwqK8ASJQ0yKmoB8VGP3O/YGLClk1LTpC0Nrp2xGUsDU1Lt4yi0tlH0l7uAMm67Oob
         abCqMYfPncGmzER0CFCoecOW7z225lrtCSNKRw40HjV6cDZ3ubzpabcDgi9S+jabORuo
         Rh+m8Uy1QnNThuzQMAiuzhdXJN72Z4B+ku8LZVaqYkHkyrCyiFvhWP0LGTqHwhJV6PdN
         4fcHFaBBibVZoEXgorgToS/QahXNTZGQjKq+2WdLMTa3/aqoOOzfEJdldHaIKWHxXjfC
         x3Ikor7gQX9YX2YyZRiAG1jRDGTCSyGUoqu96YMLsA3wrbtb10qV0B6zwnykcvVu59/G
         3SLQ==
X-Forwarded-Encrypted: i=1; AKwUvBz0M+nrFuyc2Hi6dB3K/wSHcA6pDB5Iv6DzPkNv0HIjOHklqmSI/mycPtK2Go+/KdX09JPp1KTlTQ==@kvack.org
X-Gm-Message-State: AFq9FYKNZBQ9UczSw1jecG5S9/HsFxFLS/5ZQ6Z103fVvmjVZ+kmVx7t
	xiE4kgEdSNMNxs4aRtM/U234Swf1Pt4vZ6BRRzexYnGtFRVQa9hah97bSQtZg1s8LCs=
X-Gm-Gg: AYBFou01t0ALoFwCP4VyHrMo9J2yIgNbIqnGAuDZPMhWYBU2Xus0/W4RwRXdSyVifY+
	PZXlU6F4+/RXD6gKQCz/nZijdnBQcnh1s+Xs7+SytOPpdZNtym9M34+Q+3H/VEcDI0dlswHRS0K
	v7vC0mKj3z2q+7mmaoTsyGkQgoKdQkQJSmo1uv0hNzqnMh/uVuDOkU9g1qF45zcytpo1DkZZc7c
	clH/Tem9rXZtmj83iWAm7StWets1/TNFvIDeYrGCkZO6WO8ShnNmF0Azlyo/fXTau5sLWlaU+XE
	JhVPVwl83BsXE7E9vderbzo5iiIdY9Q7VKlOdZka3ZZZDGzB9FgUK0GEBUg/G+HSj/J1K4n/HE/
	i7DKxZeEqYZqTgbKGqpq5UCBBTFG+1DKji30+xrY6/KyF1L8OZhr3cTWhz0ViXOYyjSYWAY1N4o
	OkYcDwjWi4s2AnmztlkLeKT0BDerI2aVUxFGpphXvh6mm8aG7oWSJVj1VZTiNE7a5gXSRpLn9zw
	Fyvvxhnus7PwCuxh9NygPJhAoBoN1q5Zmbh33Jg/g/z31NGEqa3phQXpb3Zi0hQRJm5e9vV3maY
	yksxsS27csNjWaFIsec=
X-Received: by 2002:a05:6122:4b8c:b0:5cf:1e68:6015 with SMTP id 71dfb90a1353d-5e91f4cc080mr5669513e0c.15.1792057122304;
        Thu, 15 Oct 2026 02:38:42 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99003d37009sm12275672241.2.2026.10.15.02.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 02:38:36 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [PATCH v1 7/7] selftests: liveupdate: Add test coverage for tmpfs preservation and retrieval
Date: Thu, 15 Oct 2026 05:38:16 -0400
Message-ID: <20261015093816.2438942-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
References: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 55A4640006
X-Rspam-User: 
X-Stat-Signature: ewjjjm1fo17mme67jknf6pkbsnabendh
X-HE-Tag: 1792057123-324245
X-HE-Meta: U2FsdGVkX19NLYQpVcxJ2bcjGxhGxhwEAS4NoR2bNLyd3E7+JSYzXoYnFb97bHVIoEyEBTKShbmsVTMFT2ZbzmYYvbYc9I8St5HeAKUsE2BHsBfRHGzQAWYyC8k5b5y0MKskgxA1njvAeiT5PGP9QpaU+n6JBC9plDQwEGcx0Yh8Xu1GyQ6rtlCVSDjiKaRUxjXmvmOAb2Cs1SIaJrew+wVOU9di/wtVdszqyvV6X0EdvTMnPqH7vMxLRX7T3sS0xnaF/+HI5x99QHrJE/ww5JLBhurim4tAwXed7OvGG8fo3u8NkF1uN9nRrTj+nknaNFw7Ut30WcGpZi8zm8eHLCF25INsbTfIhf+QdwzglDn/7MkrFSSj5DmVPTG2ICaaJ1qLoErxPJrOsqf/UProvukCuS9a/zyVEIyHP5AYsnR0hc43f5b2FPDUo/gPfm7cPvCkmpSUzyu5sBycm0jRsZwX7xRmt8I+6Iq4zN5tAxXdBJYaW1IsD+4XqR6ciYznYuO+SuwEbH8NXxFl8I+LD+svA+nnZbB8likCPo2LYXnUwg8N7A97qBYTd35V01E/0Ak1tDxtTwPh/LK65Ap6EbLOjl3MCPUDyu+jxa4/91HBy98jp4K9qC6Fiy2ji2OSrz0y5XU7FxACJild30CeXb10PpWmhNzmdYQHGz3mzce5YkGp+iKEqeCS4g65QzEuWDTqsPIP9OHz8/vLGUwtce05srvClEfIwdQgsmR8fXMzQphTRwM2C+KEOFxqyDjnKEdMKx85x1U4NQgcprBF+lEFRKzEeXMiIJRpPGQnPXwM9mP/nKEHMDr4cuuqIlsyf+x6lgSZkwAgyT/u4FeMZZN1YcVtShmSQpVHRDOFLon/BYUGa+ZyHTNPuuNu8mY76AGyWVrri+kYqSGY2EO6COGBkMg2227DTUz10evNPaIM9PYFyRov6qGjxLjA5T0/I8VtIt6qHFmoJ/2M97p
 1dVPMivM
 Y6oFyKO0VKqP2T9OedSCWELHyqLWq6bIXXT4JA64q81ll8gFhv8WDK0fEVgUWShNszlobAb6IfRZWvH3cwggfj6+7pLFLERwLh5+vJt71d5U8cwVNAFNAXV7TwmxO7U+YS2SoM6uhwBACgMYfPILAg8V09zUi4AcO60C7a8d5L85vU0q7h2lAJbNfOjxhqJk98uNneylMozW0r61bWgejwqx5n5FE2z52iQEBcuacCBAYhIOCffNnJoCLKZuX0ubHJwLaHVrzN/68rMyQH/A49Z4KKOgxkT/GqXUKJPzAQGxwlqtoD8tS3nZ/XGRYxIG+HLBUOgF+6m5jZjCB9wL4bBSJukj+N1fg71wH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Matlack <dmatlack@google.com>

Extend the multi-session LUO test to verify preserving a path-backed
tmpfs file and retrieving its contents to a newly created empty tmpfs
file post-kexec using struct liveupdate_memfd_retrieve_arg with
LIVEUPDATE_SESSION_RETRIEVE_FD. Also verify that retrieve argument
validation errors (passing an argument when retrieving a memfd, omitting
the argument when retrieving a tmpfs file, or passing a read-only target
tmpfs FD) are retryable and allow a subsequent valid retrieve call to
succeed.

Signed-off-by: David Matlack <dmatlack@google.com>
Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../liveupdate/lib/include/libliveupdate.h    |   2 +
 .../selftests/liveupdate/lib/lu_utils.c       |  44 +++++++
 .../selftests/liveupdate/luo_multi_session.c  | 110 ++++++++++++++++--
 3 files changed, 147 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
index 8a38268e89dee..dc5c01408462d 100644
--- a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
+++ b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
@@ -37,6 +37,8 @@ int luo_session_retrieve_fd_arg(int session_fd, __u64 token, __u64 user_arg);
 
 int create_and_preserve_memfd(int session_fd, int token, const char *data);
 int restore_and_verify_memfd(int session_fd, int token, const char *expected_data);
+int restore_and_verify_tmpfs(int session_fd, int token, int fd,
+			     const char *expected_data);
 
 void create_state_file(int luo_fd, const char *session_name, int token,
 		       int next_stage);
diff --git a/tools/testing/selftests/liveupdate/lib/lu_utils.c b/tools/testing/selftests/liveupdate/lib/lu_utils.c
index 5c6f8bf80b297..1b1a556287d3a 100644
--- a/tools/testing/selftests/liveupdate/lib/lu_utils.c
+++ b/tools/testing/selftests/liveupdate/lib/lu_utils.c
@@ -347,3 +347,47 @@ int luo_test(int argc, char *argv[],
 
 	return 0;
 }
+
+int restore_and_verify_tmpfs(int session_fd, int token, int fd,
+			     const char *expected_data)
+{
+	struct liveupdate_memfd_retrieve_arg rarg = {
+		.size = sizeof(rarg),
+		.fd = fd,
+	};
+	long page_size = getpagesize();
+	void *map = MAP_FAILED;
+	struct stat st;
+	int ret_fd;
+
+	ret_fd = luo_session_retrieve_fd_arg(session_fd, token,
+					     (unsigned long)&rarg);
+	if (ret_fd < 0) {
+		ksft_print_msg("luo_session_retrieve_fd_arg failed: %d\n",
+			       ret_fd);
+		return ret_fd;
+	}
+	close(ret_fd);
+
+	if (fstat(fd, &st) < 0)
+		return -errno;
+	if (st.st_size != page_size) {
+		ksft_print_msg("Size mismatch! Expected %ld, Got %lld\n",
+			       page_size, (long long)st.st_size);
+		return -EINVAL;
+	}
+
+	map = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
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
index aac24a5f5ce3c..46889676d9f52 100644
--- a/tools/testing/selftests/liveupdate/luo_multi_session.c
+++ b/tools/testing/selftests/liveupdate/luo_multi_session.c
@@ -9,7 +9,15 @@
  * files.
  */
 
+#include <errno.h>
+#include <fcntl.h>
+#include <sys/mman.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
 #include <libliveupdate.h>
+#include <linux/liveupdate.h>
 
 #define SESSION_EMPTY_1 "multi-test-empty-1"
 #define SESSION_EMPTY_2 "multi-test-empty-2"
@@ -23,6 +31,7 @@
 #define MFD1_DATA "Data for session files 1"
 #define MFD2_DATA "First file for session files 2"
 #define MFD3_DATA "Second file for session files 2"
+#define MFD3_POS 42
 
 #define STATE_SESSION_NAME "kexec_multi_state"
 #define STATE_MEMFD_TOKEN 998
@@ -31,6 +40,8 @@
 static void run_stage_1(int luo_fd)
 {
 	int s_empty1_fd, s_empty2_fd, s_files1_fd, s_files2_fd;
+	int tmpfs_fd;
+	void *map;
 
 	ksft_print_msg("[STAGE 1] Starting pre-kexec setup for multi-session test...\n");
 
@@ -53,25 +64,50 @@ static void run_stage_1(int luo_fd)
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
+
+	ksft_print_msg("  -> Populating tmpfs file at /mnt/mfd3...\n");
+	if (mkdir("/mnt", 0777) < 0 && errno != EEXIST)
+		fail_exit("mkdir /mnt");
+	if (mount("tmpfs", "/mnt", "tmpfs", 0, NULL) < 0)
+		fail_exit("mount tmpfs");
+	tmpfs_fd = open("/mnt/mfd3", O_CREAT | O_RDWR, 0666);
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
+	if (lseek(tmpfs_fd, MFD3_POS, SEEK_SET) != MFD3_POS)
+		fail_exit("lseek tmpfs_fd");
+
+	if (luo_session_preserve_fd(s_files2_fd, tmpfs_fd, MFD3_TOKEN) < 0)
+		fail_exit("preserve tmpfs fd");
+
+	close(tmpfs_fd);
 
 	close(luo_fd);
 	daemonize_and_wait();
@@ -81,7 +117,10 @@ static void run_stage_1(int luo_fd)
 static void run_stage_2(int luo_fd, int state_session_fd)
 {
 	int s_empty1_fd, s_empty2_fd, s_files1_fd, s_files2_fd;
-	int mfd1, mfd2, mfd3, stage;
+	struct liveupdate_memfd_retrieve_arg rarg = {
+		.size = sizeof(rarg),
+	};
+	int mfd1, mfd2, mfd3, ro_fd, ret, stage;
 
 	ksft_print_msg("[STAGE 2] Starting post-kexec verification...\n");
 
@@ -110,6 +149,8 @@ static void run_stage_2(int luo_fd, int state_session_fd)
 
 	ksft_print_msg("[STAGE 2] Verifying contents of session '%s'...\n",
 		       SESSION_FILES_1);
+	ksft_print_msg("  -> Retrieving memfd (token %#x) from session...\n",
+		       MFD1_TOKEN);
 	mfd1 = restore_and_verify_memfd(s_files1_fd, MFD1_TOKEN, MFD1_DATA);
 	if (mfd1 < 0)
 		fail_exit("restore_and_verify_memfd for token %#x", MFD1_TOKEN);
@@ -118,14 +159,65 @@ static void run_stage_2(int luo_fd, int state_session_fd)
 	ksft_print_msg("[STAGE 2] Verifying contents of session '%s'...\n",
 		       SESSION_FILES_2);
 
+	ksft_print_msg("  -> Creating empty tmpfs file at /mnt/mfd3...\n");
+	if (mkdir("/mnt", 0777) < 0 && errno != EEXIST)
+		fail_exit("mkdir /mnt");
+	if (mount("tmpfs", "/mnt", "tmpfs", 0, NULL) < 0)
+		fail_exit("mount tmpfs");
+	mfd3 = open("/mnt/mfd3", O_CREAT | O_RDWR, 0666);
+	if (mfd3 < 0)
+		fail_exit("open tmpfs file");
+	ro_fd = open("/mnt/mfd3", O_RDONLY);
+	if (ro_fd < 0)
+		fail_exit("open read-only tmpfs file");
+
+	ksft_print_msg("  -> Verifying retryable retrieve errors for memfd and tmpfs...\n");
+	rarg.fd = mfd3;
+	ret = luo_session_retrieve_fd_arg(s_files2_fd, MFD2_TOKEN,
+					  (uintptr_t)&rarg);
+	if (ret != -EINVAL)
+		fail_exit("expected -EINVAL when passing arg to memfd retrieve, got %d",
+			  ret);
+
+	ksft_print_msg("  -> Retrieving memfd (token %#x) from session...\n",
+		       MFD2_TOKEN);
 	mfd2 = restore_and_verify_memfd(s_files2_fd, MFD2_TOKEN, MFD2_DATA);
 	if (mfd2 < 0)
 		fail_exit("restore_and_verify_memfd for token %#x", MFD2_TOKEN);
 	close(mfd2);
 
-	mfd3 = restore_and_verify_memfd(s_files2_fd, MFD3_TOKEN, MFD3_DATA);
-	if (mfd3 < 0)
-		fail_exit("restore_and_verify_memfd for token %#x", MFD3_TOKEN);
+	ret = luo_session_retrieve_fd(s_files2_fd, MFD3_TOKEN);
+	if (ret != -EINVAL)
+		fail_exit("expected -EINVAL when retrieving tmpfs without arg, got %d",
+			  ret);
+
+	rarg.fd = ro_fd;
+	ret = luo_session_retrieve_fd_arg(s_files2_fd, MFD3_TOKEN,
+					  (uintptr_t)&rarg);
+	if (ret != -EACCES)
+		fail_exit("expected -EACCES when retrieving tmpfs into read-only fd, got %d",
+			  ret);
+	close(ro_fd);
+
+	if (ftruncate(mfd3, 1) < 0)
+		fail_exit("ftruncate non-empty tmpfs file");
+	rarg.fd = mfd3;
+	ret = luo_session_retrieve_fd_arg(s_files2_fd, MFD3_TOKEN,
+					  (uintptr_t)&rarg);
+	if (ret != -EBUSY)
+		fail_exit("expected -EBUSY when retrieving tmpfs into non-empty fd, got %d",
+			  ret);
+	if (ftruncate(mfd3, 0) < 0)
+		fail_exit("ftruncate empty tmpfs file");
+
+	ksft_print_msg("  -> Retrieving tmpfs file (token %#x) from session...\n",
+		       MFD3_TOKEN);
+	if (restore_and_verify_tmpfs(s_files2_fd, MFD3_TOKEN, mfd3,
+				     MFD3_DATA) < 0)
+		fail_exit("restore_and_verify_tmpfs for token %#x",
+			  MFD3_TOKEN);
+	if (lseek(mfd3, 0, SEEK_CUR) != MFD3_POS)
+		fail_exit("expected f_pos %d on restored tmpfs file", MFD3_POS);
 	close(mfd3);
 
 	ksft_print_msg("[STAGE 2] Test data verified successfully.\n");
-- 
2.56.0.385.gd3acb90ef8-goog


