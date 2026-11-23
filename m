Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF62606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=k2AnF6Sg
Received: by kanga.kvack.org (Postfix)
	id 833F56B05C6; Mon, 23 Nov 2026 18:39:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E5946B05C7; Mon, 23 Nov 2026 18:39:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FC2D6B05C8; Mon, 23 Nov 2026 18:39:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 411416B05C6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:39:57 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A46F9A872D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:56 +0000 (UTC)
X-FDA: 85468003992.27.716F38A
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf03.hostedemail.com (Postfix) with ESMTP id D97CB20008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=k2AnF6Sg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3yc4EawgKCNg7G4NF46EAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3yc4EawgKCNg7G4NF46EAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795477195;
	b=X/3YjtqDz8n1zj761larbRsgKUgkBhn84rlt9Tw1ISiSX6j+Tim4xsrKfXcptYXCrqYMJJ
	PN83ZrgrDQHLRKqTeRdbYhUECFDifEQKIk1ZHYwY0AgFQVuTV5YkaKzwxCnAXBtBX5upUs
	saa1KUrbBYdZvD3AaMzNbYPxP0KSLN8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795477195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TfpmwInLEGo5frDChwR3ktzWoQYmqPnvABEvfJfxR3I=;
	b=GdXnFEcOrFsLIKXUWYVjNNCcBC7M16twEfoXTfmR4lVhwDI+YNyGSgqt835tIrDlfQp8Xc
	lw5j2OXv+Eu/+P68aWPgZrkQ6N0jBOo+19df9aGyEjgvct2eFT1I4XB8yrQCMPaySt/avm
	SIfG+62MV3Hu8ZgxWqO0/l9fErYycDw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=k2AnF6Sg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3yc4EawgKCNg7G4NF46EAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3yc4EawgKCNg7G4NF46EAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--dmatlack.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4ab8b4887d4so2786526b6e.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795477194; x=1796081994; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TfpmwInLEGo5frDChwR3ktzWoQYmqPnvABEvfJfxR3I=;
        b=k2AnF6SgAKfHuOtZUDSQfy1BLBfAT0yZqkSSBX64+gOxVqURzTCK/TSfZXOMtuwhvv
         OgEdgpyrjJoD7opQdoRvO/miOs7Can1vultZBwD//7emOchGAJkjZZI/O3doH2vs4fdm
         Gbvr1RLHQq+/4MIvwua6Ui+hnwrsEjGCNk91touCuUwPb0NAK/btCBMQu48wFv0FMpch
         i/z3Fpmgd1bhxUTkjimlO6OWwM5z5JVkwvgvBEuSr9R+oU3lvUCY7iQu0S9PjWRCeVN1
         1Q0I2xSLvFIDUybti7So/VtiM0GK35V+GOzt1WePUzbLl3cfggHmp2tefG+h9JSh8K5X
         1SHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795477194; x=1796081994;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TfpmwInLEGo5frDChwR3ktzWoQYmqPnvABEvfJfxR3I=;
        b=MjtDxkN4vxA8+UQb3h1Aq0q1fOyy2IVh4/z440Gw0liiFH7dAyL1L0q05s/GyCc4d2
         wOAQwUWa91U2cHWZLpjnjMt/FuucamRr2PXMtbEi5+62hnc9NExjQg90dea/pyKT7NJu
         RMTYj8mfq8kDLrYkVdgbLWfscmWbQzWHlTrNVoVPdPtO2ErFmuKiVlhruaWuA0lWimYV
         jbgqy3dMeufIp/VHDUQZQX9FncmhnFp/voEx8wJnwpE02b+RZMjT3P/Zi/EVvC2MWBKc
         GZSJsRj0kwO4bxl7zE1i3QYesG69kMwWexVh2ZVUlezCIeLR2yd963sIdySJq9+XZU1J
         KZ9w==
X-Forwarded-Encrypted: i=1; AL+hErEA9fVHMmFGy3i3XnevzcIZt5UXFVPF549m59PIT+rKmkHpuvRxHrlpLxi7LHFuaJ6Pz5yyU26HSw==@kvack.org
X-Gm-Message-State: APuU4Z/R6fgyYh7AvvH4WGkbfuFCsiu/kUcaFSX8tRoLVwtpVp8KP2y8
	LcQIlE0K35GzaUgWKLDKemAlDUhXFegtEguGjFGlU2M47xpmwwx5CQBOY03E+WJ4ijmHPtOrK6l
	ohH1kNpIONF4pTw==
X-Received: from jats20.prod.google.com ([2002:a05:6638:2594:b0:61c:f132:938b])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:c3d2:b0:579:293a:52ac with SMTP id 5614622812f47-57a06a0f737mr14141383b6e.9.1795477193657;
 Mon, 23 Nov 2026 15:39:53 -0800 (PST)
Date: Mon, 23 Nov 2026 23:39:23 +0000
In-Reply-To: <20261123233924.3970932-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261123233924.3970932-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123233924.3970932-19-dmatlack@google.com>
Subject: [PATCH v5 18/18] selftests/liveupdate: Test block accounting of
 retrieved tmpfs files
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
X-Stat-Signature: ob6cheypcfz5mt1h1t63i6uo6d7ejrhq
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D97CB20008
X-Rspamd-Server: rspam03
X-HE-Tag: 1795477194-221818
X-HE-Meta: U2FsdGVkX18SDNBkBnvIAyV4DDt8sjdb1rwnpkXHix5h1RcSDfAIqZCAlF+P+xkg189N9STVT6wGjqBZYmj+u+xXz8hh/YN5kV70WY4RWrIpSipAYMX1sKSrvmglQtT5adYQA32jeFfD3FnpQ6lEVmLucGMQ2D5jSh5Xuo63VTYVEGpCIQRKBXXNQQ/icAq5rWrEWdC6LBrIV2KgeYojiVIZZlpR3RHWZ1xsanuF8eQmvJ8PhON6GSIMPfv69anfwhcdlhw2YnT/u73n8mp3p+0GPWJUMVcEiVy6Ka93Thl8ndP4zwEmfmNKrXuGL9ogGeLpsaEMBclUC0JdKDS++T3t9k0QoixqdjFNiM6mf+3rOkPKIDOWrCTXVAsS+MNjuWREVEbeb02rBIZVqosJLq6JshBeVAvAaSf6rEkvs6KL8htkWghVEhyAkCj/XwY/6XgswppR5+uShh7ZWBT6xqTNBicjBQkC6ybaPFWgVapm50D+zo28YrntaRfMB21iPbLUrF+XsN3L45dvyMeUH8g8THVDSasHUo6ktLjhxmmhPBSsQ7w1CCvaeVTHLT9r1Apg0FpyHw4FZJAlFW/A5PQbHBIV63VgEPuTYIlFU97Djy6OjGbZWrayro5mybQC54N8vfHSKGL2InNUwzusy1LmLaN2zCIcOKo2GrxBx2X4TKFK4A+yRImbYXSAB1msK5hVUbxna0XkOiwpCVd/m1EdEsPgygj/bo0Xq5M7XmJIFmnF1FiobIc63FjdEZTfk5eZul7xdvK4JMG5MAIci9EfJRFr2KLdfJfFvS3hUR5B2/mMDDUGUgAg5uqSbRfRv1ik6p3sKLrEixp4cPPRItww/zOOhNaduvVww9YsORXnLwo5ihzqOd6kRj+sKS3TAGlBbyAabu3e93zvgPNWJuKdwBcvmqguvqS+DrXlGHoT8ykBfy/Lp2ZOu4MpOOWGbNA8doW3p/DmMNzeFgj
 16oKK5rR
 cAKHjLzW93ZkUuJZSn47Hdg4lhaX90hhk7TukP4PREfmMiwE5+o57mp7rsh4zX1yUcyXyeVkktCwndx2yCdea2A9MhUrkETVlfGLOoJoU4OmCrGmnzUbEgTrJQV0HdZE8DXdG3KWNb16PnKSPcHEk9dAFvVwIm97wnPrCMURanv+STPShsEFD2/ezyx9rUNrmnyh7hwPJRuKtxFJeTEaqimmSfv++e/le6Ihrx8q1Y/TPUDpRMapyUg2DxFDmWLywTbsc3MDZEozaNobU/i/dmjkugQPPm68oX3qdZyv4bwmOevQSrxO0FPRzdGtIsSLXbF9XF+UT5qaDxEY1hSGKmVSprqMIojQ3ZgCJMidZJW1BB3bH+IvSNt1uPXSCxVCGPuheOqF2onkT4SEGLXa2fmzKFAGADoFIrdD3JRTK4s1PhxaYbOkTEVMU5DXe30l+0O62wczosry2gRZKmgmXLzPZ5j6z7b7sQUEKt1SFgR8SUp2/a0vll5GQHnggF5yKRxIVFLO0JLIGWSuZ3c/kCcI+bUy1JF+G0zrRJhMwDDDCUJSOdnkQYnKLWQyQsb17Ws1jIO29zmnvD+MD2iHOIsD7pt7Cy2gS7h9HgAhbrYpyJJpWc33u+RlhzM5I7Xn15Qvu7wMtafr54Rf7HwRTxtRpJfDs/uwhK87VnjMW8oYK8JDIJOkB0QB+VW8qzFaY88Hzo804PYs+JWk3o16dgfoIvsBkKdCBCzHk9IKIh9Nhk/1pnmIm/TjyF8d7Cokdhz5dgGjsCRoXAnHbOK633swxj+TidlawcD3W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add test cases to luo_tmpfs for how the blocks of a retrieved file are
charged: The file fits a mount of exactly its size, and a large folio
that extends past the end of the file is charged in full. Running out of
space on the mount, or hitting the memcg limit, fails permanently,
leaves the target empty and nothing charged to the mount or the memcg,
and the session can still be finished.

Enable CONFIG_TRANSPARENT_HUGEPAGE for the large folio test cases, and
CONFIG_CGROUPS and CONFIG_MEMCG for the memcg test case. They are
skipped without them.

tmpfs quotas are not tested.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/liveupdate/config     |   3 +
 .../testing/selftests/liveupdate/luo_tmpfs.c  | 283 +++++++++++++++++-
 2 files changed, 284 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/liveupdate/config b/tools/testing/selftests/liveupdate/config
index 37230f4c488f..7f38291c979d 100644
--- a/tools/testing/selftests/liveupdate/config
+++ b/tools/testing/selftests/liveupdate/config
@@ -1,4 +1,5 @@
 CONFIG_BLK_DEV_INITRD=y
+CONFIG_CGROUPS=y
 CONFIG_DEVTMPFS=y
 CONFIG_KEXEC_FILE=y
 CONFIG_KEXEC_HANDOVER=y
@@ -7,7 +8,9 @@ CONFIG_KEXEC_HANDOVER_DEBUGFS=y
 CONFIG_KEXEC_HANDOVER_DEBUG=y
 CONFIG_LIVEUPDATE=y
 CONFIG_LIVEUPDATE_TEST=y
+CONFIG_MEMCG=y
 CONFIG_MEMFD_CREATE=y
 CONFIG_TMPFS=y
 CONFIG_TMPFS_XATTR=y
 CONFIG_SHMEM=y
+CONFIG_TRANSPARENT_HUGEPAGE=y
diff --git a/tools/testing/selftests/liveupdate/luo_tmpfs.c b/tools/testing/selftests/liveupdate/luo_tmpfs.c
index 7911ac28188f..df2bc1488c01 100644
--- a/tools/testing/selftests/liveupdate/luo_tmpfs.c
+++ b/tools/testing/selftests/liveupdate/luo_tmpfs.c
@@ -62,8 +62,9 @@
 
 /*
  * Everything happens on a tmpfs mounted at TEST_DIR. In stage 1, the source
- * files are created on the tmpfs mounted at TEST_DIR/src. In stage 2, each
- * case runs in the directory TEST_DIR/<name of the case>.
+ * files are created on the tmpfs mounted at TEST_DIR/src, or at
+ * TEST_DIR/src_huge for files that need large folios. In stage 2, each case
+ * runs in the directory TEST_DIR/<name of the case>.
  */
 #define TEST_DIR		"/luo_tmpfs"
 
@@ -145,6 +146,7 @@ struct test_case {
 static unsigned long page_size;
 static int dev_fd;
 static int session_fd;
+static bool have_huge_src;
 
 /* nolibc doesn't have these, so use syscall() where needed. */
 static int do_fcntl(int fd, int cmd, long arg)
@@ -213,6 +215,16 @@ static long mnt_used(const char *path)
 	return buf.f_blocks - buf.f_bfree;
 }
 
+static long mnt_free(const char *path)
+{
+	struct statfs buf;
+
+	if (do_statfs(path, &buf))
+		return -1;
+
+	return buf.f_bfree;
+}
+
 /* Mount a tmpfs with room for @pages pages at @dir. */
 static int mount_tmpfs(const char *dir, unsigned long pages, const char *opts)
 {
@@ -248,6 +260,26 @@ static long read_long(const char *path)
 	return strtol(buf, NULL, 10);
 }
 
+/* Write @str to the file at @path. Return 0 or -errno. */
+static int write_file(const char *path, const char *str)
+{
+	ssize_t len = strlen(str), ret;
+	int fd;
+
+	fd = open(path, O_WRONLY);
+	if (fd < 0)
+		return -errno;
+
+	ret = write(fd, str, len);
+	if (ret != len)
+		ret = ret < 0 ? -errno : -EIO;
+	else
+		ret = 0;
+
+	close(fd);
+	return ret;
+}
+
 /* Retrieve with the argument @arg. Return the new fd or -errno. */
 static int retrieve_arg(__u64 token, struct liveupdate_shmem_retrieve_arg *arg)
 {
@@ -462,6 +494,33 @@ static int preserve_memfd(struct test_case *tc, unsigned int flags,
 	return ret;
 }
 
+/* Preserve a file from the tmpfs mounted with huge=always. */
+static int preserve_huge_file(struct test_case *tc)
+{
+	char path[128];
+	int fd, ret;
+
+	if (!have_huge_src)
+		return KSFT_SKIP;
+
+	snprintf(path, sizeof(path), "src_huge/%s", tc->name);
+	fd = create_source(path, tc->size, tc->token);
+	CHECK(fd >= 0);
+
+	/* The test needs the last, partial page to be in a large folio. */
+	if (tc->size % page_size && file_pages(fd) <= nr_pages(tc->size)) {
+		ksft_print_msg("%s: No large folio for the source file\n",
+			       tc->name);
+		close(fd);
+		return KSFT_SKIP;
+	}
+
+	ret = preserve_fd(fd, tc->pos, tc->token);
+	close(fd);
+
+	return ret;
+}
+
 /* Skip a case whose source file couldn't be preserved in stage 1. */
 static int skip_not_preserved(struct test_case *tc)
 {
@@ -1335,6 +1394,186 @@ static int exec_after_finish(struct test_case *tc)
 	return KSFT_PASS;
 }
 
+static int mount_fits_verify(struct test_case *tc)
+{
+	unsigned long pages = nr_pages(tc->size);
+	int fd;
+
+	/* The file can be retrieved into a mount it fits exactly. */
+	CHECK_EQ(mount_tmpfs("fit", pages, NULL), 0);
+	fd = retrieve_new(tc->token, "fit");
+	CHECK(fd >= 0);
+	TRY(check_restored(tc, fd));
+	CHECK_EQ(mnt_used("fit"), pages);
+	CHECK_EQ(mnt_free("fit"), 0);
+
+	CHECK_EQ(ftruncate(fd, 0), 0);
+	CHECK_EQ(mnt_used("fit"), 0);
+
+	close(fd);
+	return KSFT_PASS;
+}
+
+static int mount_too_small_verify(struct test_case *tc)
+{
+	unsigned long pages = nr_pages(tc->size);
+	int target;
+
+	/* The failure leaves the target empty, and the mount untouched... */
+	CHECK_EQ(mount_tmpfs("small", pages - 1, NULL), 0);
+	target = new_target("small");
+	CHECK(target >= 0);
+	CHECK_EQ(retrieve_into(tc->token, target), -ENOSPC);
+	CHECK_EQ(file_size(target), 0);
+	CHECK_EQ(file_pages(target), 0);
+	CHECK_EQ(mnt_used("small"), 0);
+	close(target);
+
+	/*
+	 * ... but the preserved contents were restored before it was detected,
+	 * so the failure is permanent. Finishing the session frees them.
+	 */
+	CHECK_EQ(mount_tmpfs("big", pages, NULL), 0);
+	CHECK_EQ(retrieve_new(tc->token, "big"), -ENOSPC);
+	CHECK_EQ(luo_session_retrieve_fd(session_fd, tc->token), -ENOSPC);
+	CHECK_EQ(mnt_used("big"), 0);
+
+	return KSFT_PASS;
+}
+
+static int huge_folios_verify(struct test_case *tc)
+{
+	unsigned long pages = nr_pages(tc->size);
+	int fd;
+
+	CHECK_EQ(mount_tmpfs("dst", pages, "huge=never"), 0);
+	fd = retrieve_new(tc->token, "dst");
+	if (fd == -ENOENT)
+		return skip_not_preserved(tc);
+	CHECK(fd >= 0);
+	TRY(check_restored(tc, fd));
+	CHECK_EQ(mnt_used("dst"), pages);
+
+	/* LUO keeps a reference to the file until the session is finished. */
+	close(fd);
+	CHECK_EQ(mnt_used("dst"), pages);
+
+	return KSFT_PASS;
+}
+
+static int huge_folios_after_finish(struct test_case *tc)
+{
+	CHECK_EQ(mnt_used("dst"), 0);
+	return KSFT_PASS;
+}
+
+static int huge_folio_tail_verify(struct test_case *tc)
+{
+	long pages;
+	int fd;
+
+	CHECK_EQ(mount_tmpfs("dst", 4096, "huge=never"), 0);
+	fd = retrieve_new(tc->token, "dst");
+	if (fd == -ENOENT)
+		return skip_not_preserved(tc);
+	CHECK(fd >= 0);
+	CHECK_EQ(file_size(fd), tc->size);
+	TRY(check_contents(fd, tc->size, tc->token));
+
+	/* The whole folio is charged, including the part past EOF. */
+	pages = file_pages(fd);
+	CHECK(pages > 1);
+	CHECK_EQ(mnt_used("dst"), pages);
+
+	CHECK_EQ(ftruncate(fd, 0), 0);
+	CHECK_EQ(mnt_used("dst"), 0);
+
+	close(fd);
+	return KSFT_PASS;
+}
+
+static int huge_folio_tail_enospc_verify(struct test_case *tc)
+{
+	int ret;
+
+	/* There is room for the file, but not for its last folio. */
+	CHECK_EQ(mount_tmpfs("small", 1, "huge=never"), 0);
+	ret = retrieve_new(tc->token, "small");
+	if (ret == -ENOENT)
+		return skip_not_preserved(tc);
+	CHECK_EQ(ret, -ENOSPC);
+	CHECK_EQ(mnt_used("small"), 0);
+
+	return KSFT_PASS;
+}
+
+static int memcg_limit_child(struct test_case *tc)
+{
+	long limit = tc->size / 2, usage;
+	int ret;
+
+	/*
+	 * Charging a large folio doesn't invoke the memcg OOM killer, but the
+	 * source may have gotten small folios. Protect the child, so that the
+	 * retrieve fails with -ENOMEM instead.
+	 */
+	CHECK_EQ(write_file("/proc/self/oom_score_adj", "-1000"), 0);
+	CHECK_EQ(write_file("memcg/small/cgroup.procs", "0"), 0);
+
+	/* The folios are charged to the memcg of the caller, which is full. */
+	ret = retrieve_new(tc->token, "dst");
+	if (ret == -ENOENT)
+		return skip_not_preserved(tc);
+	CHECK_EQ(ret, -ENOMEM);
+
+	/* The failure leaves the mount and the memcg untouched. */
+	CHECK_EQ(mnt_used("dst"), 0);
+	usage = read_long("memcg/small/memory.current");
+	CHECK(usage >= 0 && usage < limit);
+
+	return KSFT_PASS;
+}
+
+static int memcg_limit_verify(struct test_case *tc)
+{
+	unsigned long pages = nr_pages(tc->size);
+	char limit[32];
+	int ret;
+
+	CHECK_EQ(mkdir("memcg", 0755), 0);
+	if (do_mount("cgroup2", "memcg", "cgroup2", 0, NULL)) {
+		ksft_print_msg("%s: cgroup2 is not available\n", tc->name);
+		return KSFT_SKIP;
+	}
+	if (write_file("memcg/cgroup.subtree_control", "+memory")) {
+		ksft_print_msg("%s: The memory controller is not available\n",
+			       tc->name);
+		return KSFT_SKIP;
+	}
+
+	CHECK_EQ(mount_tmpfs("dst", pages, "huge=never"), 0);
+
+	/* A memcg without room for the file. */
+	CHECK_EQ(mkdir("memcg/small", 0755), 0);
+	snprintf(limit, sizeof(limit), "%zu", tc->size * 3 / 4);
+	ret = write_file("memcg/small/memory.max", limit);
+	if (ret) {
+		ksft_print_msg("%s: Can't set memory.max: %d\n", tc->name, ret);
+		ret = KSFT_FAIL;
+	} else {
+		ret = run_child(memcg_limit_child, tc);
+	}
+	rmdir("memcg/small");
+	if (ret != KSFT_PASS)
+		return ret;
+
+	/* The preserved contents were restored, so the failure is permanent. */
+	CHECK_EQ(retrieve_new(tc->token, "dst"), -ENOMEM);
+	CHECK_EQ(mnt_used("dst"), 0);
+
+	return KSFT_PASS;
+}
+
 static int memfd_preserve(struct test_case *tc)
 {
 	return preserve_memfd(tc, 0, 0);
@@ -1661,6 +1900,42 @@ static struct test_case test_cases[] = {
 		.verify = exec_verify,
 		.after_finish = exec_after_finish,
 	},
+	/* Block accounting. */
+	{
+		.name = "mount_fits",
+		.size = 2 << 20,
+		.verify = mount_fits_verify,
+	},
+	{
+		.name = "mount_too_small",
+		.size = 2 << 20,
+		.verify = mount_too_small_verify,
+	},
+	{
+		.name = "huge_folios",
+		.size = 4 << 20,
+		.preserve = preserve_huge_file,
+		.verify = huge_folios_verify,
+		.after_finish = huge_folios_after_finish,
+	},
+	{
+		.name = "huge_folio_tail",
+		.size = 100,
+		.preserve = preserve_huge_file,
+		.verify = huge_folio_tail_verify,
+	},
+	{
+		.name = "huge_folio_tail_enospc",
+		.size = 100,
+		.preserve = preserve_huge_file,
+		.verify = huge_folio_tail_enospc_verify,
+	},
+	{
+		.name = "memcg_limit",
+		.size = 4 << 20,
+		.preserve = preserve_huge_file,
+		.verify = memcg_limit_verify,
+	},
 	/* memfds. */
 	{
 		.name = "memfd",
@@ -1765,6 +2040,10 @@ static void run_stage_1(int luo_fd)
 	if (chdir(TEST_DIR) || mount_tmpfs("src", 4096, "huge=never"))
 		fail_exit("Failed to mount the source tmpfs");
 
+	have_huge_src = !mount_tmpfs("src_huge", 4096, "huge=always");
+	if (!have_huge_src)
+		ksft_print_msg("[STAGE 1] huge=always is not supported\n");
+
 	session_fd = luo_create_session(luo_fd, SESSION_NAME);
 	if (session_fd < 0)
 		fail_exit("luo_create_session for '%s'", SESSION_NAME);
-- 
2.56.1.809.ga0b61035b5-goog


