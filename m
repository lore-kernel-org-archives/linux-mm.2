Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C4EECA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 05:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6F028E0003; Wed, 17 Sep 2025 01:59:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF89B8E0001; Wed, 17 Sep 2025 01:59:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E7658E0003; Wed, 17 Sep 2025 01:59:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8A91F8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:59:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3407D1DE8B4
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:59:25 +0000 (UTC)
X-FDA: 83897689890.12.09CB191
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id 87F0940009
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:59:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758088763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=XlrrbpNOChtNjzl9J83pPts581jGsxoyMpwY2SqwJY4=;
	b=f9EKVX6/ENJw9GyrdXAk3J70JdXTX0wR0RdSZFdU/dx4BXxsDx5l5z6Yw2sRJ7BR4mU6vG
	Khy2puQ0sM4wp4niten0mhrXl1mFfYGm3OLzOKDzocdU7nTGs0yFPS6aNszyMhb158dilo
	kFxaeDIII+ODyoeuefzXSBI1FUnbfuo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758088763; a=rsa-sha256;
	cv=none;
	b=K5fdBLEkUhf53UBjBTiMdnJs6Z/tOXwOcc4RnDAt1WCo5FqWqW5B4E5YvA7kOKMdPaDlhc
	3jqPhoRY6MvtVVxf4c2akjbib+gePwmBgC7Uxqdi4O87JMqOPhyv2ZoqcjwcWpPxJyaCbF
	N4hGgTGjOk/IxXEzTKiUhUIbiwrYRc0=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-45f2c9799a3so21410755e9.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:59:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758088762; x=1758693562;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XlrrbpNOChtNjzl9J83pPts581jGsxoyMpwY2SqwJY4=;
        b=u8dbrqgMMYZxLDBzHF1avsZUymsJcilqBN9Tm3AQQ323B/qEksrOIVvVdeNZ6GABjT
         lwRLqa8iztyQr318nmvQl1VP+b0FuTK7EXhi8Vt5QxjFUo8cv9wIjLG/CwtoUW08q3ti
         uJE5cNbeRVOwjaP6L2ztOc5sajWgPoMvXjY7VcxKbKgnUGW4HjUTe/pxmI8LWhsU61wq
         WcB70hLeyZbWfnT636NssLtStxpzktl9Q9q6gYMP2qxJry5Lm4HLg/MaCZKrmwoiSLeZ
         ezZMjTyZ7zwB5SG7kK6FB8qLL4/3TOnQChhgY3WmJ4W5foquaUbBR1vd/c4cPpnJrqkc
         zG4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWL+X9+Sq6O+bDLBYrSEvoMpKiPXFYKnF0S0cbbxZyGlrkYVnuhT3NBcif/wE/kgR8ioWQ3I3xwYQ==@kvack.org
X-Gm-Message-State: AOJu0YwSaVy9Zqe9v3qIacuj0xw92MV+lvsW9H8vPWR1piwWZFxdNe1x
	TO4hJMdaV6WfQIxWJpFRg8seihWF1s3e5NFOneeDXPeTZwUerfjp3fca
X-Gm-Gg: ASbGncvlcO6mYpbn6uiBAwvrED2k3F7mmCoSLRI00Mm0ay9TjfKxGWo+FBU2XrXt72x
	88HVGhq8kSXZ+yGLEOaoXeuRujvlXhPS6WLzg8nq3l5QR1NmKtVl9BtbgFmpnJur78NUnJvz8G7
	NN/3H5AIubU21HKhDpHyHXlL0XyAdJtEcbLjQylG1qpITRIMe7EfArrxxEOIzqwcb5Hrrf0d/88
	JMmq+VOxWN9a2RU+57BZkS04l2GP8yO1983iyR+kqS007jwp/QrxYEVtBizYFWWQeK9mni62RiK
	F99PBtF+jPHFBmS6x0YiTNvdf+itWNHKQv6jvqbc42nJdTMqlP4G3jrND75Hq5s1CQHK6X4+1Ax
	sRzEaTTlRpAApDwCgJK8=
X-Google-Smtp-Source: AGHT+IH9W7esOzFT5IkroJVMwtaxdDK6d7E9R4NeEsWdBedzAfyvLtUnHVT1+OGn9VtvheonzXFrmg==
X-Received: by 2002:a05:6000:1863:b0:3e7:6474:1b63 with SMTP id ffacd0b85a97d-3ecdfa3d20fmr589203f8f.63.1758088761975;
        Tue, 16 Sep 2025 22:59:21 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a09:0:1:2::3086])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7c778f764sm19485191f8f.57.2025.09.16.22.59.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Sep 2025 22:59:21 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: shuah@kernel.org,
	ioworker0@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH RESEND 1/1] selftests/mm: skip soft-dirty tests when CONFIG_MEM_SOFT_DIRTY is disabled
Date: Wed, 17 Sep 2025 13:59:13 +0800
Message-ID: <20250917055913.49759-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 87F0940009
X-Rspamd-Server: rspam05
X-Stat-Signature: qusdhcbfid3uj7j7xndnfndyxfzb9uwf
X-Rspam-User: 
X-HE-Tag: 1758088763-673866
X-HE-Meta: U2FsdGVkX19GbLAlJnu8T28Ho2vF/I0nqq7Sjigpf1LPYGT1JLSiFYX+KxB+g71A7T6nVBIqkK7xAqFfik5DxAMqUF5lHSGRXLIhdgd0hQ/BAgIozlPg32n5NipfDqHoohbnqVdeQM4xSorJ0NqjRDlj9Q8DTi0E1FyDsLWGlSmuGgf0nIgTdrUKu3Q3iDZvRvURN272FIcmu5Pw1WUAcsiKgdDqx37LqTCjwCkijxKqZDVJMvbi77A5mjk1rK6eiDqrELhoN7NLNXzorF89p4V+6TsVm1i3ktbHeMRnPhx8XdZ6Gp80eIfahX6HjJbgc0fdsOmj3tsETawakUt0eVCKRsaFQsxXG4ur/x0sHlbXbeqSLDsUb8uuP4TX8wU3pF2vBBHa3+FasJmj3wAd4oap6w+pSb8FKe8BXAtQ3jCbkaf4DKUBlEliBo6glBzQjdXHwipRfXODli4Hg7fMoBp+Lq85U283ee+0qUtOmgI6HwwhBXGeeNiTb79Sf01Ah54w46UuJJRD3yWWxh1lsp/zKjhT65C7CKgcTprvOkDkUiqtLCdYO2OapKTR822xAbY69k4Cf++cdIIz5MHKRhpPn2kuXZ8m5yNdJsCpZgO464EnkI1ISOWPAA21lkuJN5xYDO236VdSvBBJYlFmTUiSL7HvmZSf0MwL97fzO676oCfZNYzMySIHcTGeVIEihHhbRf99XTIblZJMiKJi852mm9U1QW31WceOm5idtbU/UyOOiRwselqzfOsdZMw6I/RsVch22lxBDBSKBerL7BQ5Wgp/jPZ/fAkzer9iBcQw3f/cLzimlSRoyBAdrI7ALlJJRU+HUhcKQ3UqtAYUt8jL9jC9DOx0I8HtA/PTeSmhqRrX3nazBrMVrQKLr27HAeYU/0eqqPdy4/uV7sSJxiF602ZDpYmI8yegh+KEnSgHAT9Z79LSC5FZ3jb/LGQMfOOwlik8Tf1tqhZKYyR
 3326Leef
 3dWH8VWpuU6XY14dkTLeo4eeou4ZlzM3aoflhLg3QIcw+8wxtIcuuykxT29vDCqrHOv6Urj7tc8YhgGXvKMbUMCAtAqQ6eNhNkte5nEZU9liU4zV3yEeMUxPTe4CwBrj5IZK/MwaYwJsRA7+QV+tcrKkmFvXPjm1oQMwHJFKeiYmC77GcnMWzuTvc4dQ3MigOiKfxaxDhtaVgapcvLSiJZsCOR1Y6p9DJbTom
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

The madv_populate and soft-dirty kselftests currently fail on systems where
CONFIG_MEM_SOFT_DIRTY is disabled.

Introduce a new helper softdirty_is_supported() into vm_util.c/h to ensure
tests are properly skipped when the feature is not enabled.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 tools/testing/selftests/mm/madv_populate.c | 21 ++--------------
 tools/testing/selftests/mm/soft-dirty.c    |  5 +++-
 tools/testing/selftests/mm/vm_util.c       | 28 ++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h       |  1 +
 4 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/mm/madv_populate.c b/tools/testing/selftests/mm/madv_populate.c
index b6fabd5c27ed..43dac7783004 100644
--- a/tools/testing/selftests/mm/madv_populate.c
+++ b/tools/testing/selftests/mm/madv_populate.c
@@ -264,23 +264,6 @@ static void test_softdirty(void)
 	munmap(addr, SIZE);
 }
 
-static int system_has_softdirty(void)
-{
-	/*
-	 * There is no way to check if the kernel supports soft-dirty, other
-	 * than by writing to a page and seeing if the bit was set. But the
-	 * tests are intended to check that the bit gets set when it should, so
-	 * doing that check would turn a potentially legitimate fail into a
-	 * skip. Fortunately, we know for sure that arm64 does not support
-	 * soft-dirty. So for now, let's just use the arch as a corse guide.
-	 */
-#if defined(__aarch64__)
-	return 0;
-#else
-	return 1;
-#endif
-}
-
 int main(int argc, char **argv)
 {
 	int nr_tests = 16;
@@ -288,7 +271,7 @@ int main(int argc, char **argv)
 
 	pagesize = getpagesize();
 
-	if (system_has_softdirty())
+	if (softdirty_is_supported())
 		nr_tests += 5;
 
 	ksft_print_header();
@@ -300,7 +283,7 @@ int main(int argc, char **argv)
 	test_holes();
 	test_populate_read();
 	test_populate_write();
-	if (system_has_softdirty())
+	if (softdirty_is_supported())
 		test_softdirty();
 
 	err = ksft_get_fail_cnt();
diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index 8a3f2b4b2186..98e42d2ac32a 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -200,8 +200,11 @@ int main(int argc, char **argv)
 	int pagesize;
 
 	ksft_print_header();
-	ksft_set_plan(15);
 
+	if (!softdirty_is_supported())
+		ksft_exit_skip("soft-dirty is not support\n");
+
+	ksft_set_plan(15);
 	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("Failed to open %s\n", PAGEMAP_FILE_PATH);
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 56e9bd541edd..3173335df775 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -449,6 +449,34 @@ bool check_vmflag_pfnmap(void *addr)
 	return check_vmflag(addr, "pf");
 }
 
+bool softdirty_is_supported(void)
+{
+	char *addr;
+	int ret = 0;
+	size_t pagesize;
+
+	/* We know for sure that arm64 does not support soft-dirty. */
+#if defined(__aarch64__)
+	return ret;
+#endif
+	pagesize = getpagesize();
+	/*
+	 * __mmap_complete() always sets VM_SOFTDIRTY for new VMAs, so we
+	 * just mmap a small region and check its VmFlags in /proc/self/smaps
+	 * for the "sd" flag.
+	 */
+	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (!addr)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	if (check_vmflag(addr, "sd"))
+		ret = 1;
+
+	munmap(addr, pagesize);
+	return ret;
+}
+
 /*
  * Open an fd at /proc/$pid/maps and configure procmap_out ready for
  * PROCMAP_QUERY query. Returns 0 on success, or an error code otherwise.
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 07c4acfd84b6..87ad8e0d92c0 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -104,6 +104,7 @@ bool find_vma_procmap(struct procmap_fd *procmap, void *address);
 int close_procmap(struct procmap_fd *procmap);
 int write_sysfs(const char *file_path, unsigned long val);
 int read_sysfs(const char *file_path, unsigned long *val);
+bool softdirty_is_supported(void);
 
 static inline int open_self_procmap(struct procmap_fd *procmap_out)
 {
-- 
2.49.0


