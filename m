Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 877EACAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 05:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E9548E0002; Wed, 17 Sep 2025 01:56:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 944998E0001; Wed, 17 Sep 2025 01:56:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80C388E0002; Wed, 17 Sep 2025 01:56:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 694E58E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:56:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A22813ABE4
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:56:39 +0000 (UTC)
X-FDA: 83897682918.08.447C79A
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3955C4000C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:56:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758088597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=4rL2rlM29fREnsY3UP4GCd3w0RbbtqI2tzuuAuaZNNM=;
	b=TMFwQy3K47CJtpM4rxUyXN1upk2tst/NzhfXRSNOwpwAtmKZqtOSRXRYJ7dwA52OwW9bqq
	owACBqvEq4HC91gatQwBiK1HQmdTzlca7WSSBobM+4TAlFhBszd74CvtCt6MrMhdWYXLKd
	FZ2Myt81fDBjuADF5COe7odGarjXSEg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758088597; a=rsa-sha256;
	cv=none;
	b=fH7W46hmAgQUWc7XibkwPhaXz+MYUvQvEHnFLxbIk5oHOyEoimS7MMn6H78tVnAQ+QkLOy
	Gc0BMQzaSpBMSOwRZ6kwXaP7O2wUxGho+xUipllITg/v0KLS8c4tN73CPfJFNBIWt7TdAN
	q2GLKQ0gK+ob2cprtCZOFohC+UhdA4o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3ea3e223ba2so2891563f8f.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:56:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758088596; x=1758693396;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4rL2rlM29fREnsY3UP4GCd3w0RbbtqI2tzuuAuaZNNM=;
        b=jvfVpOUOWF2QJQ1BMEUMpLuBvfXDuFMdkMN9eNM8y4I4wpTuu0/vQHlurlo/vtObit
         VRwe7xmbfCQiB5c5x2cqYDCzN7O+FOh4ontlDU5MCnASwP9VbVkuTmDN0ZtTrT+6GKpm
         Z6HeSmKvOelhvo6pqKWn2yncyWHUHDZggArkL065OrxEgd5lfqGVMLTf2sE0D1obuBs1
         SCrG/TKefGMFnnIH3H91UjFAraP6knADwloFlA0XuU1Vsyr+Zg6zZT5m3XX8YNB/6Wnm
         FmGpSbB5lUiwfK8+pUkbMn2ci+isvJrjWZcDtm0/uDweiTR9yH9GSh7yKOssXibz8+CN
         gYsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWXR843R0otb8e9/PhnG9QCjWkbCw3VE2TqYHfL+6Wjnc0X+CHuZWNaEdW48WPbFBRkIcgfgz7kA==@kvack.org
X-Gm-Message-State: AOJu0YyBU+fY0rU28AZaieUSd+ZZG0olsd+RWEJr83xJ5PNtH7XR1kb4
	TT5Vft3dFfZntmYjc/EuRw1TcSl9qAU0TS4T5tD8n9GyhEWHMRjTOeJ4
X-Gm-Gg: ASbGnctNtEg+8krpcCmuaAfMZRtNCXFYm1Ke9gwxv/O+D1IPfNN3M5OFURdQYJra/Xm
	KIaJUCF/V1X5acw8iyIL0fK1FsZY1+X5iDLGZcGmc2kWrBd7LmzcAJiwPigjCS7WTwGs6T3Ad95
	l4y3d6fTQsJUYR3APxPLE+8m8lGbSqoSmNQZvdJMovOwmsv9ETUVDb3UdEcXEd1Ssz9mcnmWMPg
	AiltsxEigJl9cjBcGl4uxHafm/yOss5jirIrTLU5j8rrwnLPJkAuhV6IGMwm9uqPbJFZxrGacnq
	8/O0+5tCQdz2V5dPnoTfdBFLM48w38rh9uKDQi0OGm3DDtai+cldqKqSHLWhgW6DwrZ3OtuhGOh
	e9lTqe+Vj
X-Google-Smtp-Source: AGHT+IGjxHPHG8T6fPu431Ka9rSzcuna7td6QNzojHq1qsMru8NT7pUxzrEnuuQd7KWe/4SL2weFmQ==
X-Received: by 2002:a5d:64c8:0:b0:3ea:e0fd:28ea with SMTP id ffacd0b85a97d-3ecdfa0d2e6mr682457f8f.39.1758088595501;
        Tue, 16 Sep 2025 22:56:35 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a09:0:1:2::3086])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdf0bbf24sm1433237f8f.63.2025.09.16.22.56.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Sep 2025 22:56:34 -0700 (PDT)
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
Subject: [PATCH 1/1] selftests/mm: skip soft-dirty tests when CONFIG_MEM_SOFT_DIRTY is disabled
Date: Wed, 17 Sep 2025 13:56:22 +0800
Message-ID: <20250917055622.46564-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fzxopm9weccb69gsy5d4i74b6ceuyjej
X-Rspamd-Queue-Id: 3955C4000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758088597-62477
X-HE-Meta: U2FsdGVkX1/QsAeAaaeK9YPEgg0Y/bcJWNr+30rwXK5HWK5hI5yCQ44RmIv5Q3oO78rpCmfjv38M1/xdBk5XSgPeyvzBdJVRo9ss4EirAexGwW8TxawC1prjUzZ7+8z8jPEHpcM+lZTJCOeJl409ZDQD1tm3OhZJieaULYHiOJBvHR3jiKnEpmy7KmY2wgwL5QsNclRxSJKrU/ucxhWDjjpAzwUNWmz9hCMCKKnaUayzmXRV4EQjcwNTuF8RWb8NmHt7KyI3LZqD0ZCUzsNEe+RfSHNoRRGeRhs41odXVa9JU/UfMvRdm/mfAd1npXr43UC4W0wpyYL/mm0F51gs1HYWD/NqdIgB7ic2ZrodYgCelviDP/HUht6GuIJtLuBTsZbln4z1VvrsTut4TcHK8Acfqr4uTlPyxhfFkCEdF8ID6CViwATlqPGTTNMy6z4H1M97FWogS3CQ0uiG0paO/6c7HEVy4K5HXXEtOF4HjmYhrlKhtCkF0sWl1SBcijnISzcJ39/Ze+4EgE7Va5HjgeoFpl+DYpfELuyoTm+/2A2j3pSGcib4l+SRODcwfLtOP/duEGZB4rgrNWq2CpHwTio9H0G2w2jP+IljU4e8w+xe96BdVdDxLRX16ykT4HC/kekO/ACk6eSi4Foo5juQLA+elDUyYO9DpygISu8XlvWw/s6xZtpqFE4I5pstk3oOXzp5LRkMH/jNVBy67OaqfNtzYKqSDOixhUMwz+e7ZB4dANoXF+2UjMYgJdTjdGyb4w1zTaL1WH5hNYwvC/osjXuWLucz3EFzLNIbEPWlfJfcRM9JX9c5Qp2TH18kY4SXcyWqwDIbItzB85IMvt+10Ke3S/abAdBP7d4nsEOXZHKHnQgqVdIM81upOkhJluJY/MwyiKKHCXZqxmXyAkLcRLBfhBnkCJ5RLoBl3bcjpBZ9xlz1eH2CXrNvbCubJT0P96EOJuTuM2H6c0h7mR6
 wiKd2mF+
 gIcMvjW15uoqubM3wESdjuuBj3L2ls0PvsPH3OCjgOAyTnPO3oPhhowGO258Vl7IqP1ysBIAhAQpzfa/w24XnTdbv4WztZqCuj+t62vrUul7y/Ol6KRA1dYNTWcqRuZypq32Dhc/EB+cZ+1JXawnJOTIP9ctU2XUkw7H2iDHsl5QAs1P2E8i4dgdR2cTWZpqV62Ojfv6aMPXJifOjWiW1r0cGGwJ7bW14l1tRIxDAssSfyEqNgcf0pTyX8dEQVZ29eu8vl3+eSarwfEgnoXp/LlduhrNHBsDovXeOLaSRCylBUHjreoXFUUrMSRmrVy7Z5rQODiLScSq/1zuKKXjvVy5dS8sw/KV7r13lMc4w7Sgy2umMqHIoKExCtXuhA4x8nmJ6idShva9GLUXSZKcJH7fZu4qV/HuAKJ2fdj+IWvZqgZ+5C+uBwYF59IB9BRWBYBr3ie4AteQj7dF+V5qzYN2IzjZyycCGkqUZThB6Ntq4VDs=
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


