Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5292C606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TJKUL4kC
Received: by kanga.kvack.org (Postfix)
	id A12A06B05B4; Mon, 23 Nov 2026 18:39:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1546B05B5; Mon, 23 Nov 2026 18:39:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A9306B05B6; Mon, 23 Nov 2026 18:39:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 535266B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:39:36 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA650C0884
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:35 +0000 (UTC)
X-FDA: 85468003110.19.0E3ED71
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf27.hostedemail.com (Postfix) with ESMTP id 063D740006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TJKUL4kC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3tM4EawgKCMMmvj2ujltpxxpun.lxvurw36-vvt4jlt.x0p@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3tM4EawgKCMMmvj2ujltpxxpun.lxvurw36-vvt4jlt.x0p@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795477174;
	b=nV6oL7vVoprPnfM63clWAQWHgnybNBYzy/K1QtTsvt57wKzQDyVg54VI2/e5kL/ELL+1ml
	64uhNP+FPhov2Yc5CziQ0lLCVXibRS6jmWYQUrF+4gGfbLhEhdkaZX64AIyPHeAiRYVz1l
	dxx/jXk6bCqf2wJc7v3ubwfuMXmRq8w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795477174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EeRPz4sZOybVhfqP/WD/7fCihnY2rWbCdbzpXQtgwmc=;
	b=W9oh5OCjyRiuAWncbsWnwPnRWY2odL/UTxQC1EGObocWFnfGJfHrSe4y6Tuj5113rPwW5t
	WSjk3LzAgrcIg/ZxX08oyMYWWEr/Ra0zQp90ecKhJT7u9J9h+LTZ/k0RyvUe2uZ6NSQIZL
	yzoQrQNaje3cKgPrxy9btghzWfwr6qw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TJKUL4kC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3tM4EawgKCMMmvj2ujltpxxpun.lxvurw36-vvt4jlt.x0p@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3tM4EawgKCMMmvj2ujltpxxpun.lxvurw36-vvt4jlt.x0p@flex--dmatlack.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4ea2c058e67so4396903b6e.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795477173; x=1796081973; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EeRPz4sZOybVhfqP/WD/7fCihnY2rWbCdbzpXQtgwmc=;
        b=TJKUL4kCeD+JrxHv409mK3P8fGPOVA/1wgwvwwLlrPA5x0zeMmrri9ielQBnfDAwfH
         hniPA7HL8N5n2tHURpiwhg0CaQ9343kSFu8kT0CUz6pkI+XmHmqGVi21cb4sLhFty7eh
         XUnnAM7tVVm9fPKVILVyB3fP/CTL+TSMRjpT+RxhHqzcS+OwNXRNe1+ljIbC9WKPmk0n
         AOmJeUbuUBA0UdCYYEJbShBy+HTuEHU216MGphIr5ujW1LlRm6q5KRV2l9XBR7DywOx/
         /Do1r79qa0b6558iAFcWOXPE1IdoAYvct4VPRgmd02K1/5njeUoxlhghlIPDxMvytkS1
         2e4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795477173; x=1796081973;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EeRPz4sZOybVhfqP/WD/7fCihnY2rWbCdbzpXQtgwmc=;
        b=WjarkQ9nOLlg8ORrxvJTnXnDO6wT8X75l+ZztcNHnhNXKJtcrMHIvQy5uqJ+5rk13P
         1llELCjJI9dPwVNZLDW5zvPl+Q6mO5rgquWcEfd7Ef7LDnBw3/FlTIO0YrZcc8GuTaUU
         EdP6N0WdMnFC24Y0LG1A46cjtF0U0Lpx4Pns723akEVnPBaVeVXBnPaum4jyNCK3AEC3
         V/0VwlDRcBSgl0sutlYKuVzY3iFwmUWOmx6eOF4jXIXDkX9iiGpO0pUrW8BpsFlGiDgH
         VG8bJPY9my2DENPq+VG3KG+UY60M3WnL4jFRRl2WUz2q1xMEPJu17nnysuE4QMJPiZln
         9Usw==
X-Forwarded-Encrypted: i=1; AL+hErHKIUWbluFDXva5MpyvYErF/Y9Edj9GbD7wNKLVmlIDtl8GwullrA7inzwxC0hSRiPUSAZbEGjNkQ==@kvack.org
X-Gm-Message-State: APuU4Z98jGOa7Ij/rQqiYYxht36zEkr7WO3U2+gJpac3QfjhK0L9LdEZ
	Ifz5vF8UUEK9AZBglaSRLua6qSNLumm281PAa/aKMio14toxeFj9ZHQdrGJ30eyCN//P2Ih5S3J
	LS92jWzA7TY9K+w==
X-Received: from oixz16-n2.prod.google.com ([2002:a05:6809:410:20b0:4f4:549a:d85d])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:4fe1:b0:575:39f9:df7c with SMTP id 5614622812f47-57a06504990mr14793633b6e.2.1795477172875;
 Mon, 23 Nov 2026 15:39:32 -0800 (PST)
Date: Mon, 23 Nov 2026 23:39:08 +0000
In-Reply-To: <20261123233924.3970932-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261123233924.3970932-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123233924.3970932-4-dmatlack@google.com>
Subject: [PATCH v5 03/18] selftests/liveupdate: Add tests for preserve and
 retrieve user argument
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 063D740006
X-Stat-Signature: sshogd1o31zk9h1md7yby3fn9yrhy8p9
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795477173-621687
X-HE-Meta: U2FsdGVkX18zuFwzu+qWuqt9krNBmhTfhIhXSuml4NnzqXxYlynIfvyOV3o+F9PL/64ADXjF20iMERdYa1vK9gLEzYVESC7Rie0Kc9Ilbzv+yZz1+Cc9fY0ckDWuKsdpMTGrpQHA8+AqP9navETrFVFwFSVHQmJVI+Z9dnth2ss00RKCNCdGwBxqqxeaD71PnKSvYwqE1NJrz4tcZ/WGmAXrbN3O+xI1JDeP0LS1NMhrqgxnIHLy7mhadaudHKvQBo5Do60tR4ra6jIcC1J7Htec0MF80EPNEyHixChOMtVIpxmTVme80qKSTMhSufWtfrePDoa7vcG01vRuKfoaFqGAgdlLi+JedxtQHDSfP2a0I1L97w4r+d4TI0VL29eXnwenTUOhif0lkVZIlHT16WDdK4UKyMe81Wn2UnzH1THgyF1/mjQ4EbVLS65Y8sE5duaZmk66IikR5aXz5TBOVrZBk1LooLeFOyLQXJyz0oNs9rVmzppdKeYHpNDJCcUPwqaIAOV2mNT/9CmbgaSh7X1H1L7KubMWJi6Wjl/CAOxC0ycw03UI5U8VyvRWW1FkfcgMVLQDV34IHz8qo9mxWFrP/Gqd8uRR4iQ8jLnAyBzYKAdKMEki2LI/RWBlwjgKgCz3ZvwiWOm7DiD00AwLytDXLQ6+vwixVpJyHQPIDCShaI3osGogbO4acD6yY8PKBwdyvniBC/37pcuDJ+Qk1PcddVBs4q3IvVZGLLtRHt0mXtfCD7CHZlqAbZFeT5NEmcSgJxd22yAXsKAVimW+ck7LH70xrLicmPmBOz76zVgqh9N1yw+/JAiaEleqAVyx6923SGGr3DLjBYZ6IDj1p8KCh0zMr90maYVUzVMmGZ+sddNU+aLc0pnNE5NNAZeQmLfBVdS2p+OYX4bmhP2MAaZDiRV2zsE5AkLDGG+5RrJ6UWbL4rqkZmihMMGkTOaxvTehD9k0KUe+es8jELE
 JRzxCBv+
 ORs/xQI9Z6M5pyaQyRylkPecGvcTHk768TaJyThqs+MrVgK1VG5SxQg/8/amgGMhYkO2IdV2zGl19MvxcxXQQoB1PMU6bUsGa9FEybAowAeLc73naO3QzUCYS2V5Yw1VDSGKeiZD033SItomL37z51RoUQc6CGSUPcHOY4iyuZBYQEBpzQi2iVR1jQjZMXS5Jmpn5HLt2m2Vgn5S2LOZJHkPqXWn0kDH4DUWBblfdN5laTMtOMGPjMbZCtDjIhkd8roxsjt11zssx428owv2/opsv3qI8E41bjEm1qFDG2IZiZPIys4OvG/ilU1r4ksV7H1RIA7y8qZo82xqZ8k4KL9gcDl4lYtrjRgG0QXvsyfyeaEb6HfOGRE7jIARmnNDnyEcqEbVff17CRR3ojt94cYvswBzAHz25+6lQULXp27ocwIaLRvc2sAHKfIHIMiIlw3/U1hUKnLObrxhXiGCBk7YSJKNa9GH0PnTbgXlvaiAzAijNr3jll23YCgkiveQP/H3/wght7w2q0Bxydj6U7J2CiKJPkorDEmH2QfrjYqiGyKpIyQbgXo2rVOycPP1j5LcdkGnfejeClgOwbQA9HV11BLs/VX9mQCPWs2yQDeMV8BIOhTzBiX3cR6B4rPphD8OfH0TY4Lf8YPKWdu+6GN71vww+pVi1KrTkhd8AJ8yGsNu3pDMW2ruD0C0yAgQzOhX9WXGaui1Zz/8xUYgHM7p9IWNQGuZwzS2sLfTg6GjRMkGOtq91XJFXFhlNFzOl3NtXgZNQMT8qE4g53NjOar8BaHUlYeDj/qRpsjJcyfX0FyS9rAJE5yF6Yr4uwEwCRoWfB+FOojhvVV6ddYCw1yC7Ho1hEajtdRzqJVRfoeWgct0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Pasha Tatashin <pasha.tatashin@soleen.com>

Verify the user argument support in LIVEUPDATE_SESSION_PRESERVE_FD and
LIVEUPDATE_SESSION_RETRIEVE_FD. Add luo_session_preserve_fd_arg() and
luo_session_retrieve_fd_arg() helpers to libliveupdate so tests can pass
a handler-specific argument.

Add a preserve_memfd_with_arg test case to verify that memfd
preservation rejects a non-zero argument with -EOPNOTSUPP, accepts an
explicit zero argument, and remains compatible with callers passing the
legacy struct size up to the token field.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 .../liveupdate/lib/include/libliveupdate.h    |  3 ++
 .../selftests/liveupdate/lib/lu_utils.c       | 17 ++++++-
 .../testing/selftests/liveupdate/liveupdate.c | 48 +++++++++++++++++++
 3 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
index fa07fed08364..cd1d843a0d3d 100644
--- a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
+++ b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
@@ -29,7 +29,10 @@ int luo_get_session_name(int session_fd, char *name, size_t name_len);
 
 int luo_ensure_nofile_limit(long min_limit);
 int luo_session_preserve_fd(int session_fd, int fd, __u64 token);
+int luo_session_preserve_fd_arg(int session_fd, int fd, __u64 token,
+				__u64 user_arg);
 int luo_session_retrieve_fd(int session_fd, __u64 token);
+int luo_session_retrieve_fd_arg(int session_fd, __u64 token, __u64 user_arg);
 
 int create_and_preserve_memfd(int session_fd, int token, const char *data);
 int restore_and_verify_memfd(int session_fd, int token, const char *expected_data);
diff --git a/tools/testing/selftests/liveupdate/lib/lu_utils.c b/tools/testing/selftests/liveupdate/lib/lu_utils.c
index 74d41115c281..db7a90b002cb 100644
--- a/tools/testing/selftests/liveupdate/lib/lu_utils.c
+++ b/tools/testing/selftests/liveupdate/lib/lu_utils.c
@@ -79,12 +79,14 @@ int luo_retrieve_session(int luo_fd, const char *name)
 	return arg.fd;
 }
 
-int luo_session_preserve_fd(int session_fd, int fd, __u64 token)
+int luo_session_preserve_fd_arg(int session_fd, int fd, __u64 token,
+				__u64 user_arg)
 {
 	struct liveupdate_session_preserve_fd arg = {
 		.size = sizeof(arg),
 		.fd = fd,
 		.token = token,
+		.arg = user_arg,
 	};
 
 	if (ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &arg))
@@ -93,11 +95,17 @@ int luo_session_preserve_fd(int session_fd, int fd, __u64 token)
 	return 0;
 }
 
-int luo_session_retrieve_fd(int session_fd, __u64 token)
+int luo_session_preserve_fd(int session_fd, int fd, __u64 token)
+{
+	return luo_session_preserve_fd_arg(session_fd, fd, token, 0);
+}
+
+int luo_session_retrieve_fd_arg(int session_fd, __u64 token, __u64 user_arg)
 {
 	struct liveupdate_session_retrieve_fd arg = {
 		.size = sizeof(arg),
 		.token = token,
+		.arg = user_arg,
 	};
 
 	if (ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg))
@@ -106,6 +114,11 @@ int luo_session_retrieve_fd(int session_fd, __u64 token)
 	return arg.fd;
 }
 
+int luo_session_retrieve_fd(int session_fd, __u64 token)
+{
+	return luo_session_retrieve_fd_arg(session_fd, token, 0);
+}
+
 /* Helper function to get a session name via ioctl. */
 int luo_get_session_name(int session_fd, char *name, size_t name_len)
 {
diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index 2dedd5fc2534..8b6e61695a35 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -20,6 +20,7 @@
 
 #include <errno.h>
 #include <fcntl.h>
+#include <stddef.h>
 #include <string.h>
 #include <sys/ioctl.h>
 #include <unistd.h>
@@ -530,4 +531,51 @@ TEST_F(liveupdate_device, preserve_many_files)
 	ASSERT_EQ(close(session_fd), 0);
 }
 
+/*
+ * Test Case: Preserve MemFD with User Argument
+ *
+ * Verifies that passing a non-zero user argument to memfd preservation fails
+ * with -EOPNOTSUPP, while passing a zero argument or using the minimum struct
+ * size without the arg field succeeds.
+ */
+TEST_F(liveupdate_device, preserve_memfd_with_arg)
+{
+	struct liveupdate_session_preserve_fd min_arg = {};
+	int session_fd, mem_fd1, mem_fd2;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = luo_create_session(self->fd1, "preserve-arg-test");
+	ASSERT_GE(session_fd, 0);
+
+	mem_fd1 = memfd_create("arg-memfd-1", 0);
+	ASSERT_GE(mem_fd1, 0);
+
+	/* Non-zero arg is not supported by memfd handler */
+	EXPECT_EQ(luo_session_preserve_fd_arg(session_fd, mem_fd1, 0x1111, 1),
+		  -EOPNOTSUPP);
+
+	/*
+	 * Legacy struct size (up to token) should succeed. The kernel must
+	 * ignore arg, so set it to a value the memfd handler would reject.
+	 */
+	min_arg.size = offsetof(struct liveupdate_session_preserve_fd, arg);
+	min_arg.fd = mem_fd1;
+	min_arg.token = 0x1111;
+	min_arg.arg = 1;
+	ASSERT_EQ(ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &min_arg), 0);
+
+	/* Explicit zero arg with full struct size should also succeed */
+	mem_fd2 = memfd_create("arg-memfd-2", 0);
+	ASSERT_GE(mem_fd2, 0);
+	ASSERT_EQ(luo_session_preserve_fd_arg(session_fd, mem_fd2, 0x2222, 0), 0);
+
+	ASSERT_EQ(close(session_fd), 0);
+	ASSERT_EQ(close(mem_fd1), 0);
+	ASSERT_EQ(close(mem_fd2), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.56.1.809.ga0b61035b5-goog


