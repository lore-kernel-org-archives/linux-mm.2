Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 422EB606B9DF
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=eBVw07Vs
Received: by kanga.kvack.org (Postfix)
	id A92416B05C7; Tue, 10 Nov 2026 19:24:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A66C76B05C8; Tue, 10 Nov 2026 19:24:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959546B05C9; Tue, 10 Nov 2026 19:24:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CBA56B05C7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:24:33 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D2FB7401AC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:32 +0000 (UTC)
X-FDA: 85420941984.05.2BB4D6C
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf23.hostedemail.com (Postfix) with ESMTP id 21E07140009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=eBVw07Vs;
	spf=pass (imf23.hostedemail.com: domain of 3vbXzaggKCFY1AyH9y084CC492.0CA96BIL-AA8Jy08.CF4@flex--dmatlack.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3vbXzaggKCFY1AyH9y084CC492.0CA96BIL-AA8Jy08.CF4@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1CoGe9fD/ZgqdhBgpqd0QzDfzCHvOXqOoSwskwbt52M=;
	b=v2ftu9TRtdNKuxAbfaAfTUS9Opd5CVYdMhEsbaQAe1fVGKTJMX8S8fB7wmAfeMieb8WUFU
	BK7YE5B6mkPJAqWJvVCZU8/OyMTW0cSwwUXRA8v5oQchPq0S6uBc+Y1rWsOXD45gUC4m9J
	XE1r7QIfrOiFZgv4hvDoVJ4FzYP4tpc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356671;
	b=7JBqLCWYOf3GihHZFiYsF4ERdau91cK7CdipWmOzrcUUGwOB908jEJ23jwpTWwk5zvMLcJ
	H6iTm5KOti5xS8zOazyotaiKLU7YP/y5lQWa0oM+1HoxjuVmli2WqwDtK/I8NqKX+oCoQ5
	ZEDNYuUj5podWkR4j+75hrLEEqXq2KA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=eBVw07Vs;
	spf=pass (imf23.hostedemail.com: domain of 3vbXzaggKCFY1AyH9y084CC492.0CA96BIL-AA8Jy08.CF4@flex--dmatlack.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3vbXzaggKCFY1AyH9y084CC492.0CA96BIL-AA8Jy08.CF4@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4c7f887ac6bso3562439b6e.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794356670; x=1794961470; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1CoGe9fD/ZgqdhBgpqd0QzDfzCHvOXqOoSwskwbt52M=;
        b=eBVw07Vs9t4nOdtjeN9DhN3FchkszUhriEz3hpqKSdLMyvCbjbjNG/sGX+cEms6PLk
         e8cRghHeOQJ9bgZL5rcUrPWRgyjHg5IgdydE3Qa5zGfsc/t5LL3WnkE9pvjxox/4Amo7
         CwSDdszlU1dov55YIVOLVHN8cuq1Et3ZcgDQO7tna4t98lbMtf4QJ0TfPrYe31WoolQW
         ERzP9tBftJrnt7cKE+B9xZfHSiIj4+9yHgGLGUe1HA0Xb7Y1k6Vk2MSomgw8lYAGngob
         S39E3G0BEVlU/sVv+Ggx/MtioKYPPtIWN8OYmQuNzWdE2BSVuKhIlnmuUNtXkuoo67PS
         GhXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794356670; x=1794961470;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1CoGe9fD/ZgqdhBgpqd0QzDfzCHvOXqOoSwskwbt52M=;
        b=1VFOpf8rg7WGM0jyx53jYTF5149MU+idmbPMkQ4YGU+PkqXVogtwIg5v2PP/JKnl+f
         c/xAuaGc04OXyiLStI7TVD/CHPK6AqABvHljz9B/CugL3Ti04BQrpIX2RO9fmEOrHL22
         SAAgjjdixdNeqjkWaPv54/lqlO5+h8yf2enF+yEe1bE6YJpe5XnkftftUqkVhsVpwoW6
         F/uwXopCgR5kxTDRGJHFdNCs9u5EwUqAjqCSKT00JwUtRZH/M8T/YcotqZ016wVF6SUI
         UQ+tIlplPxbnvNrb9rIfRuoiGLg0WS8qB/yOrKilaAY8rjyQK2zboRTtJ/9PLnf/Wk61
         8CZw==
X-Forwarded-Encrypted: i=1; AL+hErHpi1KB5iBiJwTIWMNrPdNccBHubQKwjZXvPOS59Lsd/aZX7lDCQ2T+BasUc3a4E9EimQTRst6HQw==@kvack.org
X-Gm-Message-State: APuU4Z972NFweHTHteRl+NGQcMRWWnA1OPv3VlOw07cH9ChcO+mGnSBf
	TNB8PK621InGTHym0J6xf79Mh7kJhrnBamKmzaQh8cn0R+o6TAzk0wPTrAcY9P50XP/x2mRUufU
	cViCTD4IeU9eFUw==
X-Received: from jablt8.prod.google.com ([2002:a05:6638:ac08:b0:61f:fbc5:133f])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:6605:b0:564:347c:5aa3 with SMTP id 5614622812f47-56b9344c04bmr631370b6e.2.1794356669929;
 Tue, 10 Nov 2026 16:24:29 -0800 (PST)
Date: Wed, 11 Nov 2026 00:23:56 +0000
In-Reply-To: <20261111002358.1842967-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111002358.1842967-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111002358.1842967-19-dmatlack@google.com>
Subject: [PATCH v4 18/19] selftests/liveupdate: Test retrieving tmpfs files
 preserved read-only
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
X-Rspamd-Server: rspam06
X-Stat-Signature: mqubt4pxuqrf313khk514ktwdrhknx8f
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 21E07140009
X-Rspam-User: 
X-HE-Tag: 1794356670-200190
X-HE-Meta: U2FsdGVkX1+wVBZrsi1iSca3Xd6FiljobeWxU4GL4o486/7roBQ0xhMFhv1ltsomWapmPOHA33vaw1HtiDgprR7MG5wYuSdI7IRLqcaMEn3hL268E2XmC32yx7ngzzrZD4cHpXyB9TmChbZ6TM2jDiQXcRTcv7uwm+F+7l43TW0NTvmIM0IUdaIUWbBPST35DHAgOkp0jbuGt/6sOtvWGBtoZ9TfgM3vsHH/BgvNe4oPiYhggC25Fg1Z2QlB3+mNGhq4Za0BzTZTqk+VcW1xEgArPs6Rwo6P+zOsIlJrrtGnRSUmKrTfUMz4jqCCU+D0F3fmRGzbIQVnA2jGvzRWPpAyCMhSj+5+nZHyNCnXro1iXvbRvrw7QBnb0d08EcYg1I4W5Py+V/JpJfCwu2ntfsZT/tzpJoiGXccyCt/rW2V4pjfPRH8lrRyT3q/ThTV9SvpTmpq/LG6PL3ETTgDnnTCu/wSr+XUQw7BFkjYudMS5kHzzPr1ew0KiNe75NTJYrbjF0lkYeCT/lyWX4yqZKkoUKb26PvLWYTKLLW9A5Lh1tLkL+cNeIc95W1VVLiDAGmzQbbmQF6oGRhVfnZYX3Q+eenZaAC/ZY7/D4yMEIke9+8iaUW1WpS934mMB+d7MGFTGT6ASXj1yO5EYnexri77enQx0YdR93y97g6ArS2Q4DZNEfQ9d3f9OCu+csGS5mDsVuGuGipajssSXAL1KJYTwBhslfZmNUr7V5OmiXM78kGxICttpU/yWjShxQZe657d1aQSFkno9fpP4n54H0w4/tFd+sRjq4c9gyZXj8iU1P+0rRG42J4NY24gC/WAyAasxcKrdVjpiWywhDVLKZJ0Lz1e4LCr3ZLC1HsSyfhuCTE/Iiuw+x3s8ERDPInBbv+jERI+7KXkJmA/ub8AeGiAcWd8S2YLLbBVX4Xa+IRuuWJA+j+dHPIo6lcQoYWioBlayAOvj8eNl/++ItxL
 f9Mgiw3K
 QOjJPbOBOPzvogeR6nkbYPEChX/jjRrleUxi4+8Hsa0d9fsEURE+XrMRF+afAYAPUKpKRPtNSZrbsUyCPR2XF1hwbA2GjeyDjCuF8Ek4/uCl6Wqfb5PdjSdTvlon45SN6TWWGXAcQTRbRWnWSAslFhwiMbAcsPPjsBfJBjKqR8YcwtRj/amyub89CkhkQlH4+e4qvLL+O0f6GW/Hvz1AkUNWMZdQKnuHUo6I0Cqt6kfNyJE/hq1v4z0VPVBomnT6i8MshT0hNu8xetJTRDAj+TDvGeWh2tav6pNFXBwCE9GMh0tcGel4ad4KLlUX7M5w17QZrYMqVUK8I1TxzX6QJwSrOO/b6gx4MpfFQALMPYxjMbqP9//6V2d5VCxDx0TL3QydFxlPBIRjXR4VA+AXnwCCyQE/fKEUozTCgvA927RPyckvb+sxvUFTrWO07mgbHeIrvWKj4ZntnOtY9wUd7Ykdf6a/Edcjkzg4owl5dOi0UPDELXlYNjIL5egg/m/249J1cbaqjUyhiZvW1QEYrPbcg2DQ0q4MyNqwkh1fHcfRTNwtZR2wwkUnCcFS1ubfBiYdnPlfE0yvmNcWU6Hn+bfTlr93lhChwhKOM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add test cases to luo_tmpfs for source files preserved through a
read-only fd, through a read-only mount, on a read-only superblock, and
immutable files. Each of these cases except the first also preserves a
sparse file, whose holes are filled when it is preserved. Check that
the files are retrieved with their contents. Also check that the size of
a preserved file is frozen, even when the file is opened by its path,
and that writes within the file are preserved.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../testing/selftests/liveupdate/luo_tmpfs.c  | 305 ++++++++++++++++++
 1 file changed, 305 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/luo_tmpfs.c b/tools/testing/selftests/liveupdate/luo_tmpfs.c
index 2d6dd8f0e138..0bd9b95f0575 100644
--- a/tools/testing/selftests/liveupdate/luo_tmpfs.c
+++ b/tools/testing/selftests/liveupdate/luo_tmpfs.c
@@ -451,6 +451,13 @@ static int preserve_memfd(struct test_case *tc, unsigned int flags,
 	return ret;
 }
 
+/* Skip a case whose source file couldn't be preserved in stage 1. */
+static int skip_not_preserved(struct test_case *tc)
+{
+	ksft_print_msg("%s: The source file was not preserved\n", tc->name);
+	return KSFT_SKIP;
+}
+
 static int drop_privileges(void)
 {
 	CHECK_EQ(syscall(__NR_setgroups, 0, NULL), 0);
@@ -808,6 +815,175 @@ static int linked_target_verify(struct test_case *tc)
 	return KSFT_PASS;
 }
 
+static int rdonly_source_preserve(struct test_case *tc)
+{
+	int fd, ret;
+
+	fd = create_source("src/rdonly_source", tc->size, tc->token);
+	CHECK(fd >= 0);
+	close(fd);
+
+	fd = open("src/rdonly_source", O_RDONLY);
+	CHECK(fd >= 0);
+	ret = preserve_fd(fd, tc->pos, tc->token);
+	close(fd);
+
+	return ret;
+}
+
+/* Create a sparse file at @path, with a hole after the first page. */
+static int create_sparse_source(const char *path, __u64 token)
+{
+	int fd;
+
+	fd = create_source(path, page_size, token);
+	if (fd < 0)
+		return -1;
+
+	if (ftruncate(fd, 2 * page_size)) {
+		close(fd);
+		return -1;
+	}
+
+	return fd;
+}
+
+/* Open @path with O_RDONLY and try to preserve it with @token. */
+static int try_preserve_path(const char *path, __u64 token)
+{
+	int fd, ret;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	ret = luo_session_preserve_fd(session_fd, fd, token);
+	close(fd);
+	return ret;
+}
+
+/* Check that the file preserved with @token has the source of @tc. */
+static int check_preserved(struct test_case *tc, __u64 token, size_t size)
+{
+	int fd;
+
+	fd = retrieve_new(token, "dst");
+	CHECK(fd >= 0);
+	CHECK_EQ(file_size(fd), size);
+	TRY(check_contents(fd, size, tc->token));
+
+	close(fd);
+	return KSFT_PASS;
+}
+
+/* Check that the file preserved with @token is a create_sparse_source(). */
+static int check_sparse_preserved(struct test_case *tc, __u64 token)
+{
+	unsigned char *p;
+	int fd;
+
+	fd = retrieve_new(token, "dst");
+	CHECK(fd >= 0);
+	CHECK_EQ(file_size(fd), 2 * page_size);
+
+	/* Preserving the file filled the hole. */
+	CHECK_EQ(file_pages(fd), 2);
+	p = mmap(NULL, 2 * page_size, PROT_READ, MAP_SHARED, fd, 0);
+	CHECK(p != MAP_FAILED);
+	TRY(check_range(p, 0, page_size, tc->token));
+	TRY(check_range(p, page_size, 2 * page_size, 0));
+
+	munmap(p, 2 * page_size);
+	close(fd);
+	return KSFT_PASS;
+}
+
+static int rdonly_mount_source_preserve(struct test_case *tc)
+{
+	int fd;
+
+	fd = create_source("src/rdonly_mount_source", tc->size, tc->token);
+	CHECK(fd >= 0);
+	close(fd);
+	fd = create_sparse_source("src/rdonly_mount_sparse", tc->token);
+	CHECK(fd >= 0);
+	close(fd);
+
+	CHECK_EQ(mkdir("src_ro", 0755), 0);
+	CHECK_EQ(do_mount("src", "src_ro", NULL, MS_BIND, NULL), 0);
+	CHECK_EQ(do_mount("none", "src_ro", NULL,
+			  MS_REMOUNT | MS_BIND | MS_RDONLY, NULL), 0);
+
+	/*
+	 * Files can be preserved through a read-only mount. Their holes are
+	 * filled as if by read faults, which work through read-only mounts too.
+	 */
+	CHECK_EQ(try_preserve_path("src_ro/rdonly_mount_source", tc->token), 0);
+	CHECK_EQ(try_preserve_path("src_ro/rdonly_mount_sparse", tc->token + 1),
+		 0);
+	return KSFT_PASS;
+}
+
+static int rdonly_mount_source_verify(struct test_case *tc)
+{
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	TRY(check_preserved(tc, tc->token, tc->size));
+	TRY(check_sparse_preserved(tc, tc->token + 1));
+	return KSFT_PASS;
+}
+
+static int rdonly_sb_source_child(struct test_case *tc)
+{
+	TRY(drop_privileges());
+
+	/* The owner can preserve a file whose size can't change anyway... */
+	CHECK_EQ(try_preserve_path("src_rosb/own", tc->token + 1), 0);
+
+	/* ... but nobody else can. */
+	CHECK_EQ(try_preserve_path("src_rosb/other", tc->token + 2), -EROFS);
+	return KSFT_PASS;
+}
+
+static int rdonly_sb_source_preserve(struct test_case *tc)
+{
+	int fd;
+
+	CHECK_EQ(mount_tmpfs("src_rosb", 16, NULL), 0);
+	fd = create_source("src_rosb/root", tc->size, tc->token);
+	CHECK(fd >= 0);
+	close(fd);
+	fd = create_source("src_rosb/own", tc->size, tc->token);
+	CHECK(fd >= 0);
+	close(fd);
+	CHECK_EQ(chown("src_rosb/own", NOBODY, NOBODY), 0);
+	fd = create_source("src_rosb/other", tc->size, tc->token);
+	CHECK(fd >= 0);
+	close(fd);
+	fd = create_sparse_source("src_rosb/sparse", tc->token);
+	CHECK(fd >= 0);
+	close(fd);
+
+	CHECK_EQ(do_mount(NULL, "src_rosb", NULL, MS_REMOUNT | MS_RDONLY, NULL),
+		 0);
+
+	CHECK_EQ(try_preserve_path("src_rosb/root", tc->token), 0);
+	TRY(run_child(rdonly_sb_source_child, tc));
+
+	/* Holes are filled as if by read faults, even on a read-only sb. */
+	CHECK_EQ(try_preserve_path("src_rosb/sparse", tc->token + 3), 0);
+	return KSFT_PASS;
+}
+
+static int rdonly_sb_source_verify(struct test_case *tc)
+{
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	TRY(check_preserved(tc, tc->token, tc->size));
+	TRY(check_preserved(tc, tc->token + 1, tc->size));
+	CHECK_EQ(luo_session_retrieve_fd(session_fd, tc->token + 2), -ENOENT);
+	TRY(check_sparse_preserved(tc, tc->token + 3));
+	return KSFT_PASS;
+}
+
 /* Set the inode flag @flag, e.g. FS_IMMUTABLE_FL, on the file at @path. */
 static int set_inode_flag(const char *path, int flag)
 {
@@ -829,6 +1005,104 @@ static int set_inode_flag(const char *path, int flag)
 	return ret;
 }
 
+static int immutable_source_preserve(struct test_case *tc)
+{
+	int fd, ret;
+
+	fd = create_source("src/immutable_source", tc->size, tc->token);
+	CHECK(fd >= 0);
+	close(fd);
+	fd = create_sparse_source("src/immutable_sparse", tc->token);
+	CHECK(fd >= 0);
+	close(fd);
+
+	ret = set_inode_flag("src/immutable_source", FS_IMMUTABLE_FL);
+	if (ret == -ENOTTY || ret == -EOPNOTSUPP) {
+		ksft_print_msg("%s: FS_IOC_SETFLAGS is not supported\n",
+			       tc->name);
+		return KSFT_SKIP;
+	}
+	CHECK_EQ(ret, 0);
+	CHECK_EQ(set_inode_flag("src/immutable_sparse", FS_IMMUTABLE_FL), 0);
+
+	/*
+	 * The size of an immutable file can't change anyway, so its owner can
+	 * preserve it. Its holes are filled as if by read faults.
+	 */
+	CHECK_EQ(try_preserve_path("src/immutable_source", tc->token), 0);
+	CHECK_EQ(try_preserve_path("src/immutable_sparse", tc->token + 1), 0);
+	return KSFT_PASS;
+}
+
+static int immutable_source_verify(struct test_case *tc)
+{
+	int fd;
+
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	fd = retrieve_new(tc->token, "dst");
+	if (fd == -ENOENT)
+		return skip_not_preserved(tc);
+	CHECK(fd >= 0);
+	CHECK_EQ(file_size(fd), tc->size);
+	TRY(check_contents(fd, tc->size, tc->token));
+	close(fd);
+
+	TRY(check_sparse_preserved(tc, tc->token + 1));
+	return KSFT_PASS;
+}
+
+#define FROZEN_OFFSET		100
+#define FROZEN_DATA		"frozen"
+
+static int frozen_source_preserve(struct test_case *tc)
+{
+	size_t len = strlen(FROZEN_DATA);
+	int fd;
+
+	TRY(preserve_file(tc));
+
+	/* The size of a preserved file can't change, even through its path. */
+	fd = open("src/frozen_source", O_RDWR);
+	CHECK(fd >= 0);
+	CHECK_ERRNO(ftruncate(fd, tc->size / 2), EPERM);
+	CHECK_ERRNO(ftruncate(fd, tc->size * 2), EPERM);
+	CHECK_ERRNO(do_fallocate(fd, 0, 0, tc->size * 2), EPERM);
+	CHECK_ERRNO(do_fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+				 0, page_size), EPERM);
+	CHECK_EQ(lseek(fd, tc->size, SEEK_SET), tc->size);
+	CHECK_ERRNO(write(fd, "x", 1), EPERM);
+	CHECK_EQ(file_size(fd), tc->size);
+
+	/* Writes within the file work, and the data is preserved. */
+	CHECK_EQ(lseek(fd, FROZEN_OFFSET, SEEK_SET), FROZEN_OFFSET);
+	CHECK_EQ(write(fd, FROZEN_DATA, len), len);
+
+	close(fd);
+	return KSFT_PASS;
+}
+
+static int frozen_source_verify(struct test_case *tc)
+{
+	size_t len = strlen(FROZEN_DATA);
+	unsigned char *p;
+	int fd;
+
+	CHECK_EQ(mount_tmpfs("dst", 16, NULL), 0);
+	fd = retrieve_new(tc->token, "dst");
+	CHECK(fd >= 0);
+	CHECK_EQ(file_size(fd), tc->size);
+
+	p = mmap(NULL, tc->size, PROT_READ, MAP_SHARED, fd, 0);
+	CHECK(p != MAP_FAILED);
+	TRY(check_range(p, 0, FROZEN_OFFSET, tc->token));
+	CHECK(!memcmp(p + FROZEN_OFFSET, FROZEN_DATA, len));
+	TRY(check_range(p, FROZEN_OFFSET + len, tc->size, tc->token));
+
+	munmap(p, tc->size);
+	close(fd);
+	return KSFT_PASS;
+}
+
 static int target_rdonly_verify(struct test_case *tc)
 {
 	int target, rd_fd;
@@ -1287,6 +1561,37 @@ static struct test_case test_cases[] = {
 		.size = SMALL_SIZE,
 		.verify = linked_target_verify,
 	},
+	/* Preserving files. */
+	{
+		.name = "rdonly_source",
+		.size = SMALL_SIZE,
+		.preserve = rdonly_source_preserve,
+		.verify = restore_verify,
+	},
+	{
+		.name = "rdonly_mount_source",
+		.size = SMALL_SIZE,
+		.preserve = rdonly_mount_source_preserve,
+		.verify = rdonly_mount_source_verify,
+	},
+	{
+		.name = "rdonly_sb_source",
+		.size = SMALL_SIZE,
+		.preserve = rdonly_sb_source_preserve,
+		.verify = rdonly_sb_source_verify,
+	},
+	{
+		.name = "immutable_source",
+		.size = SMALL_SIZE,
+		.preserve = immutable_source_preserve,
+		.verify = immutable_source_verify,
+	},
+	{
+		.name = "frozen_source",
+		.size = SMALL_SIZE,
+		.preserve = frozen_source_preserve,
+		.verify = frozen_source_verify,
+	},
 	/* The target file. */
 	{
 		.name = "target_rdonly",
-- 
2.56.0.542.g3ef89b7020-goog


