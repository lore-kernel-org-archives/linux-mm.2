Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17FCF606B9F4
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=V+M8RuWc
Received: by kanga.kvack.org (Postfix)
	id EFE236B05C8; Tue, 10 Nov 2026 19:24:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAEA16B05C9; Tue, 10 Nov 2026 19:24:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC4B16B05CA; Tue, 10 Nov 2026 19:24:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 937576B05C8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:24:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 22086A74E9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:34 +0000 (UTC)
X-FDA: 85420942068.10.16825F8
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5D3CFC0003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=V+M8RuWc;
	spf=pass (imf28.hostedemail.com: domain of 3v7XzaggKCFg3C0JB02A6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3v7XzaggKCFg3C0JB02A6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JWNWBuYt8VDk6MSopmwG6WRR0xCPHmDtNzfk+bYbRIM=;
	b=KvTGHDux1H6X/Mz/Ur1GdiRftY/ExmRIc8WIZ8cXdPcNAO4GGoUYlFsEVT53Iyv1zNto++
	EXmRgOfZX6/yiT9iDdSzTjsErbJ00pjeNEq5xj7ee591rsNJlXujelAxiW4VOl/Rz2WiVG
	p9bt5KsVDfzegJseF6HgDCCmDd/ASY8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=V+M8RuWc;
	spf=pass (imf28.hostedemail.com: domain of 3v7XzaggKCFg3C0JB02A6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3v7XzaggKCFg3C0JB02A6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356672;
	b=HERws8/CVo9J9gvAS84KAJQAjXIRhtwfZrawXpFluDColyyW1lZpCIk95YMFLjPphKMpOS
	xWP4jZA2E4b/ZDS7ufzriEePyg7LHXlwhcMZaCP241qMQSw8xqpRL4NFljS+/dX19hQNYX
	x0yLXG+2UJX30gk3RnTb9iKAsZXJyp8=
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4dc57e2a3f2so3741113b6e.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794356671; x=1794961471; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JWNWBuYt8VDk6MSopmwG6WRR0xCPHmDtNzfk+bYbRIM=;
        b=V+M8RuWcO4dTp07Hn5JVWe34EOmPrbDmxdahONqcy2IPHTa+rMpwJQmSnQgcrTLmnv
         dNBzjDw3UOkeBD+noOkrSsliC4MjRbdsIDSSejZQO1+VWW9vVZS6leAX4Clo2WWt+1YJ
         xZKJu0fyQiHV21dydsZFsrLICUzbq6YAaGsSTeayynwr58r/aRMAv71KuJ/HTDBPoHkM
         PmJl55CBkI3vtcQDELQwrqiEjaS/m843BZrQo+fPB305nWYNym1CiA7wCU0NujhqPl0w
         SSv0MDT1rZO7MeHRsO1ccO9y/q3Zz+FcAXjHI9fyi5fRZtkq/BxfhMERXTzoJ0lSj15P
         t0GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794356671; x=1794961471;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JWNWBuYt8VDk6MSopmwG6WRR0xCPHmDtNzfk+bYbRIM=;
        b=2IJU4QDa1qEmuGYb/NofX2cJO+/uMkEft55tXdLbJEKn8xZv/ERWgc7sX50DYQxTc4
         QB1kwudOel8sVUoHM1DEjKVQ0rneG9blu4SyFKffheSSYUlUGIx7XxQiRfQiChpdIKO/
         sCaYy+eRdFN1YvMBn1di7zRt/1RoiJbiALLAWmWwH30cz3n4Ba3OYrqsR6nvebp6/Was
         zryByvWsegmVXoMp57KVsFcqUu5lP73yCs0jTYDUpcasnKjlNf41umQyrx7P+Hbx2eji
         Y01nfHnIlhNfsL1oKJp+H2WD10ijUbOLWQkH1h/OdR1zZggxOsoxwz1B3pnQOZVlhH58
         0/bQ==
X-Forwarded-Encrypted: i=1; AL+hErH3zdPSI5Lcqn1clZIfLRVeDpQM78Jq4yOklL2NRXfWnqmCof2nTzyIOqUKPf4l+S1z0g7dElRhYw==@kvack.org
X-Gm-Message-State: APuU4Z82K75kJbxYiIz1NL1z/xlcN1rSxrQPmOGdbI5yyS1GvadI+Y8e
	9e6aJAY+j2Ur5etLgGft+q5t0ELF7kTpQlTSA5iRjvIy7hpKt8ZIDvrl6gu6Ia5SGx1Iixw1tj7
	fMU/aFHyKXDf75A==
X-Received: from ileb20.prod.google.com ([2002:a05:6e02:c94:b0:53e:21cf:3e01])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:309d:b0:4b3:3e1:4a25 with SMTP id 5614622812f47-56b963a8dfemr634281b6e.11.1794356671089;
 Tue, 10 Nov 2026 16:24:31 -0800 (PST)
Date: Wed, 11 Nov 2026 00:23:57 +0000
In-Reply-To: <20261111002358.1842967-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111002358.1842967-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111002358.1842967-20-dmatlack@google.com>
Subject: [PATCH v4 19/19] selftests/liveupdate: Test block accounting of
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
X-Stat-Signature: gtah6mktp6empufbyzdgotm3jruq4rwd
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5D3CFC0003
X-HE-Tag: 1794356672-890761
X-HE-Meta: U2FsdGVkX1+xFeGeF+NrLyukQ3InDg2PlnwGYUqmpTGW7GtffyzrtAg1WbX2DZf8Bg5m2wm43qSpKxh1TW6LcdH8npauzwgzj3xkG+av1s8p2IbkfRkdbwC6dydR34CyzErOTiuPCp+bn+ZY7Viq65CuuF4KEmuK66aBIb8wRQ0Lt7+tjnAHPNW43cJP1Q+uXfFxbM8nuhAQRvS4GLYBj6BIactucg3DsYcP4Km96+M289bUgiPH7upXwCl2dIHtaVJ9IZyrBB/2s+/HHbWXjDB8QsEvwxSLMjFvjFfCoqmfyGj4mYcsyNa4KnzYcZs0PGbEOGEELeMj/+6MJH6H+aqbSHnM0LDBQbEz79/rpYZXQRm1yTSnbnfOr9gqmWH1H7UEm+wBImz++HL98sbehXn74WbswxI/5SirTcooo8K1JZcE7XaM+CBxHZiSNi5StxwP7JOPjArUaKacfym24aSvlwBiYA/c4i3B2M2siGujlDPorHdV1qJlKCjXE7H4SQXearsAPH1bzBewnDaHutM8sM4ZSDzDRSwd1CFhCGLPJN6/xieh0QVvfTjDqqzmnEQe+qx0ZwmssZ4iIvOjtPqioqS7KIEmrHDzQwiOIxqV4jX/qzVh3lXW28i9lCeIVmeF8LVRkP7zU5g9bqUk1nS9Z9qqGKN/urr867aVnkCWA4GfKXRsk32GO3wjJLsq7qUVALTrkMRCuv1+4/xm/a+Zs927c/RkVqVsHr11PAB7XHtyM0AFx5ESFTSwxHdSvg4uKr+8aOyo42gbJrBFuvZkZbigNGOTsmdUceaXNDIsnA/4rmSs1CgSSg2LgnQlBnGT3RzcMljNgAD8Q1Z+awo2bpbiyLZglENnRAQPTj1ksIz7Yj1LG1AlYsH9xsV7HEf/pXSj7X5aErjWc9NYwpexudl+ISysEwQAdRylm7OFa1KwAgfUuopy3rheCD/boANq1Z+qDGcc/CJe9BY
 a2Xgot69
 WRF1VKoX+JpGrUBkZIOtxjcgeums1Cw62TvhZIGG6xhpGKNYX25WFwsgezpb42Dfb+0PI/WO2s6UTMQnJlIn0M8eG/3nCjAHctvEaiDmw/5Cf8GeHu33mfH16kpfz4oXYyiOh93XMHTNO9/ltGlmf0YKgYyyajtM/JmPDW8PUha+6YB24QXT6z5y8e9qHRvgLnTXhnGYOrURYVJJiPsN3Ia9aKjvXYvUP7Ritl7KEGUuSbNsGRyZ8djWzXETKgCfV2GcA7sJhOyLVAWlyNjHCRSp/UTNnZZov4BvaTPIo3rkNhfyS8wa/gRxtqhhe6VXenxCYHFfGeyKxvRZEMVGHEt1knzVu412vMakt38Y54Tn34Wi7ErvZhHVaXK8ZQsXUXgeixfiYxnZRvv2DQC++IVJRaj+Bgs7G7eczrRCyBxFfgPwVcwqxHF/OHu2nlEzsLuRHbAo0jLqQLeUtkNHWNohIihuwzAzoi9kbaqslCyek3Hwd0DJ0isFMc0luw3AQQlEqSQt5oIt8IyQc/WDzwXVXQBPqPYu2X40tG6zyAn+o1ruRN5c1j4ylDQFtgYGUqHbdbAuyg3mUpSoGajJWIdThLtp+49d3N+nH
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
 .../testing/selftests/liveupdate/luo_tmpfs.c  | 278 +++++++++++++++++-
 2 files changed, 279 insertions(+), 2 deletions(-)

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
index 0bd9b95f0575..783c46715fc1 100644
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
@@ -209,6 +211,16 @@ static long mnt_used(const char *path)
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
@@ -244,6 +256,26 @@ static long read_long(const char *path)
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
 /* Retrieve with the argument @arg. Return the retrieved fd or -errno. */
 static int retrieve_arg(__u64 token, struct liveupdate_shmem_retrieve_arg *arg)
 {
@@ -451,6 +483,33 @@ static int preserve_memfd(struct test_case *tc, unsigned int flags,
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
@@ -1305,6 +1364,181 @@ static int exec_after_finish(struct test_case *tc)
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
+	 * Charging small folios may invoke the memcg OOM killer. Protect the
+	 * child, so that the retrieve fails with -ENOMEM instead. Charging a
+	 * large folio doesn't invoke it.
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
+	/* A memcg without room for the file. */
+	CHECK_EQ(mkdir("memcg/small", 0755), 0);
+	snprintf(limit, sizeof(limit), "%zu", tc->size * 3 / 4);
+	CHECK_EQ(write_file("memcg/small/memory.max", limit), 0);
+	CHECK_EQ(mount_tmpfs("dst", pages, "huge=never"), 0);
+
+	ret = run_child(memcg_limit_child, tc);
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
@@ -1629,6 +1863,42 @@ static struct test_case test_cases[] = {
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
@@ -1733,6 +2003,10 @@ static void run_stage_1(int luo_fd)
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
2.56.0.542.g3ef89b7020-goog


