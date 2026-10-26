Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00C8A606A329
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 22:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=GgzoNQ26
Received: by kanga.kvack.org (Postfix)
	id 1C9376B05B3; Mon, 26 Oct 2026 18:06:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A736B05B5; Mon, 26 Oct 2026 18:06:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0A406B05B3; Mon, 26 Oct 2026 18:06:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C65F96B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:06:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 57C4B80899
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:06:35 +0000 (UTC)
X-FDA: 85366162350.06.40B2374
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9813040008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:06:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GgzoNQ26;
	spf=pass (imf12.hostedemail.com: domain of 36M7faggKCGMTLIBXBKBHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--skhawaja.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=36M7faggKCGMTLIBXBKBHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793052393;
	b=eTNtUE1yxxERH6H46xhxsh0UM4gWqOPNN7RKFCtaFYrJgcUs6f2suGlslwKa0me5GwHAju
	P6PKu0PaAXTPxQi2oKFUbz93mhBEMrlGGkx/h62WKcoFKUMw8Q3gm6fF/3uFeoQB6VUBSI
	laxUL+doCTzxiP5zCok2aKlnuESq/HI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GgzoNQ26;
	spf=pass (imf12.hostedemail.com: domain of 36M7faggKCGMTLIBXBKBHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--skhawaja.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=36M7faggKCGMTLIBXBKBHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793052393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JbeI020SnpugISxSyc+z9N6JHGvPCZP0HYKr/jk1BYM=;
	b=CHjll1blrlvzA9yYgxCmZp5M9aUVm3LKIE1e56U00+kkHEG8OtFDPYO4yc7lcjOJ40Lhup
	n/fu8IzJ+KHSQKCK6YnGkauXKWMW7SjFpplKWIv7nv8dDWET6MSL5MeHcBaK6BX0DMqwEC
	dCx3tHy3/6iU3Bi52/H/yQRFxjR5Rf4=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cd66551e02cso3705365a12.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793052392; x=1793657192; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JbeI020SnpugISxSyc+z9N6JHGvPCZP0HYKr/jk1BYM=;
        b=GgzoNQ26+GnVMiMXmsQ/OSvzxX+KOxjnvETvbLJw4fSC7GcHmHmsdS3EXUznZPIiqA
         DY74m5YlDgdm3749UP2y59Zq0lKULtyJw6ZDADNnCy07ZdyGtFsc9fW6xBTQC9JWtCCn
         wd0GSKLUF/Ox051XsYgr95v4piJw2Crub31h6ZtcI6Oy2nmOgHGH+sPfgNRGcYTlUCA7
         xpS3xHYPhLsQJKDq9hJDctbgzeu/ml6FbkxpWxyO1Aa00pAo1ExUYVZ9oG4eedEsoqTd
         +1uvC1c4FYk0WVsTupS8muXFGBY6+grF7kowX9CDwzfqbvG/azFoiefcyzYKKe25VO/L
         PWdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793052392; x=1793657192;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JbeI020SnpugISxSyc+z9N6JHGvPCZP0HYKr/jk1BYM=;
        b=I+BVCQKxAZpNeKD2n+q/PKq5o5/yCFCvxHSYHOsTl13aD+wPa1+Rj5jIusMj76qipL
         t+zEKb+JEmU+IAIQrPbslPxDjQWmm6soPzBV75swx/8aO1ropRBW5Y8s2CYE/klqB9fa
         TQFWdConUZf6lbk0RB7fvhj6liqsHK8/xLwwMslaTwar5FdGKSHPuwjQUyCcqNrVu8SX
         0scrkUK4ZjF1DWx2IjI0vnm0bhKvwdNrcLm9c3zNnSXrsYsiA7sBbpRXZ4R0Cjw9coNy
         Ssv+4d5UoWHHsN566EIRN+E8Ee+VYvJ/yGGbDAJdFcjFITyL3ENg4WjH1Alw+4BKk01v
         AKbg==
X-Forwarded-Encrypted: i=1; AKwUvByLfXGRxDV3I1VR3oFUVLxlCl/KBIeVFUHz+3G7Bmaa7vKrRqEm6Js7LbvKTV5y3WDyRd/l5gWx6A==@kvack.org
X-Gm-Message-State: AFq9FYIP06RdUb1SurqsYbKIhwfXlrKaMzS3OGVc58OfB+C1WuzNO2WE
	vI9hCyBQRlZ/9ptwAEV1lm8x5wIreExd2XLhMkrS61IdoP+GFiEfXSRPKJ3fQvz2l6dz9KcM4dG
	MQ2HmB0SSxV/8wQ==
X-Received: from pgdo1-n2.prod.google.com ([2002:a05:6a02:6201:20b0:cd6:b08a:e7cb])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:4e0b:b0:3e1:8890:8400 with SMTP id adf61e73a8af0-3e7bfbdb8dcmr6859849637.15.1793052392197;
 Mon, 26 Oct 2026 15:06:32 -0700 (PDT)
Date: Mon, 26 Oct 2026 22:05:46 +0000
In-Reply-To: <20261026220546.3114241-1-skhawaja@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261026220546.3114241-1-skhawaja@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026220546.3114241-3-skhawaja@google.com>
Subject: [PATCH 2/2] selftests/memfd: add F_SEAL_PUNCH_HOLE tests
From: Samiullah Khawaja <skhawaja@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Gerd Hoffmann <kraxel@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: qxz99g9ck5bciz1aqfza7txa8aadhr4h
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9813040008
X-Rspam-User: 
X-HE-Tag: 1793052393-650195
X-HE-Meta: U2FsdGVkX18aRlpuOV7gjTS/I9SLDn3dAUBz6K/YJq7PCIcYRPHObPrE8JTRjRrTdCV3S7g8KeZMaJuodfOc15pR/3pv8WBP0SIKc65U1CR2z1gIPPuaUygYE7TTwsdbxJfWj3MfX1Cs/j0cCiXW6pQEkXKXUBKXpgFSfexVtQjtnMC8N8wgYCcX15I5rLFPqmGlH9VoEpSItbherkhItv+kpaKQgVT+GcWrBJHCtMmaQVKWaT29zgiMbOAB409QqyE/SHGMWAlp2idXhVdrKQ3EHX5uHxFG2QPYzyS03Pm+DuiAO/K65o1jsk4h+UfFYO6BC5ZE83s99I3tTAN/mp47Hf4Oq47pdxBikS4PO0KAGVuJXOZUUU5YONSmBYW/u5wazV4M+Jq8j5hHqP/wNBD5e21wOPnQVQNp7sz2q1V9NOsNO/h5tj24r9mnP8s9QrCSyrds9JXi8RVwlpTJdYUjNg8FJ4CDVa1r/s2cQWF62dw+9PE00uYLjWspdTdcBzJJuSoF3x9AC6KOoQGLWO9qA+I6J5Xk3ceTqfG4/InUAOvBSLddS/lH//Lgx78IDtWN5N83FtiCMtkHXo8Xu2Xbr4e8DltaZXfzQ2akLI8IjSReTaUxsRfbJO85H96X9HHE0xXsFRRdEfB8XQEPIq45jtpVc/5LMyKqTS6nvO2yzuG4NEPqHfBtDV610+31K3mxYuqsUnmy5INGw1guOm6anQLakDwPvNbxNbkfLh+y64FYZfwZGkcCVK6HN20r6g4JgeUBS8cVFwgYCvVhDna/N+gbfZ5yh24a6+hs7xSXJOug3Flhs+mZ45Mj/R0Ru72jWf8m64usjvYix1K/jhql4HW0VNLDGsJOi1PlZpLoUjdfj+kKr9KU2gKrDkJZTFZ6uqdODPBzbmsgJ0dsH71h5F7npq0LKdflAg3cHVZokFuKjhq48cgjEnW495twk0GbhHF1PNPUgsNlpx/
 ckBgSBDF
 vVK3GmIkScyRRPNMv9MjOv0oB4xFAk6YMiaydehn/Xen7JOygTNwR+QabTjEqJB+RVkFXoXk81Q2pYnPcZTN0rUvdvxN8MN9EHdDKp/TwDlqbDZvnJaCWWJz32ZVuxBvkohy9Xk6uqqRLy7blfo719CXWcQwkNzbPgEd4zUGW/S1y9CnkofwaPfeIsfZZquhDaaNG6+6ZcLlrbCpTwuF/Y1VNoQeAv6M6xinXpd4QaGNjYWK11Gk5ce8jV+lC0zbk6hO50srA8aLClPALkIufWe0Q/1H/c8FnRAQdIZATNQimO6MCB4NzxMnrNB62Z6TiuTUtZcSCRsLFk/ONP9v+2v+dQJCkv/MsI8BFXapdePSputrSYNGQD7d8XSVzxcjfojLe0IkWlzSZZX0hUASRx3XEIuP2DDUJpY4X4aS9GELwPmldIaEOJC+7o8F3CBaccJ9sfkbz0qkCcsJ0rqqJW6EEPrR1tam70E+eRm3BkAvXP/sYXcdsfjHibTKs2AaSOkMn/am3xFGAKtRU343mEpD9OQV0FB1TGHkvcIlp5wqQC9oiN2CS7bowbNirUBgH1QXSW9I9v+bNQceCzuwwzz4e2nEpXgmWBV/3ftY/6Fdb5Blha5cKS3IMe9Ro49nc63oIhZp8DE/ai+9g4e1XPcAUBG9XI76jQCPm70hwwrlUBKjlwJSl6KTLiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add tests for the new F_SEAL_PUNCH_HOLE seal. Like the rest of
memfd_test, they run on shmem memfds by default and on hugetlbfs memfds
when memfd_test is invoked with the "hugetlbfs" argument.

mfd_assert_write() checks that the file can be written, and then also
checks that a hole can be punched into it. The second check no longer
holds once F_SEAL_PUNCH_HOLE is set. Move the write checks into
__mfd_assert_write() and the punch check into mfd_assert_punch_hole(),
and have mfd_assert_write() call both, so the existing tests keep doing
exactly what they did before.

Add mfd_fail_punch_hole(), which checks that both
fallocate(FALLOC_FL_PUNCH_HOLE) and madvise(MADV_REMOVE) fail with
EPERM, and use it in two new tests. SEAL-PUNCH-HOLE sets only the new
seal and checks that punching a hole fails, while writing, shrinking and
growing the file still work. SEAL-PUNCH-HOLE-SHRINK adds F_SEAL_SHRINK
as well and checks that the file can neither have holes punched into it
nor be shrunk, while it can still grow.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 tools/testing/selftests/memfd/memfd_test.c | 111 ++++++++++++++++++++-
 1 file changed, 110 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
index cdab3a837624..095c5eb255af 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -35,6 +35,10 @@
 
 #define F_SEAL_EXEC	0x0020
 
+#ifndef F_SEAL_PUNCH_HOLE
+#define F_SEAL_PUNCH_HOLE	0x0040
+#endif
+
 #define F_WX_SEALS (F_SEAL_SHRINK | \
 		    F_SEAL_GROW | \
 		    F_SEAL_WRITE | \
@@ -455,7 +459,7 @@ static void mfd_assert_fork_private_write(int fd)
 	munmap(p, mfd_def_size);
 }
 
-static void mfd_assert_write(int fd)
+static void __mfd_assert_write(int fd)
 {
 	ssize_t l;
 	void *p;
@@ -523,6 +527,11 @@ static void mfd_assert_write(int fd)
 
 	*(char *)p = 0;
 	munmap(p, mfd_def_size);
+}
+
+static void mfd_assert_punch_hole(int fd)
+{
+	int r;
 
 	/* verify PUNCH_HOLE works */
 	r = fallocate(fd,
@@ -535,6 +544,49 @@ static void mfd_assert_write(int fd)
 	}
 }
 
+static void mfd_fail_punch_hole(int fd)
+{
+	void *p;
+	int r;
+
+	/* verify PUNCH_HOLE fails */
+	r = fallocate(fd,
+		      FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+		      0,
+		      mfd_def_size);
+	if (r >= 0 || errno != EPERM) {
+		printf("expected EPERM on fallocate(PUNCH_HOLE), but got %d: %m\n",
+		       r);
+		abort();
+	}
+
+	/* verify MADV_REMOVE fails, it punches a hole as well */
+	p = mmap(NULL,
+		 mfd_def_size,
+		 PROT_READ | PROT_WRITE,
+		 MAP_SHARED,
+		 fd,
+		 0);
+	if (p == MAP_FAILED) {
+		printf("mmap() failed: %m\n");
+		abort();
+	}
+
+	r = madvise(p, mfd_def_size, MADV_REMOVE);
+	if (r >= 0 || errno != EPERM) {
+		printf("expected EPERM on madvise(MADV_REMOVE), but got %d: %m\n",
+		       r);
+		abort();
+	}
+	munmap(p, mfd_def_size);
+}
+
+static void mfd_assert_write(int fd)
+{
+	__mfd_assert_write(fd);
+	mfd_assert_punch_hole(fd);
+}
+
 static void mfd_fail_write(int fd)
 {
 	ssize_t l;
@@ -1117,6 +1169,61 @@ static void test_seal_resize(void)
 	close(fd);
 }
 
+/*
+ * Test SEAL_PUNCH_HOLE
+ * Test whether SEAL_PUNCH_HOLE actually prevents punching holes, but still
+ * allows writing and resizing
+ */
+static void test_seal_punch_hole(void)
+{
+	int fd;
+
+	printf("%s SEAL-PUNCH-HOLE\n", memfd_str);
+
+	fd = mfd_assert_new("kern_memfd_seal_punch_hole",
+			    mfd_def_size,
+			    MFD_CLOEXEC | MFD_ALLOW_SEALING);
+	mfd_assert_has_seals(fd, 0);
+	mfd_assert_add_seals(fd, F_SEAL_PUNCH_HOLE);
+	mfd_assert_has_seals(fd, F_SEAL_PUNCH_HOLE);
+
+	mfd_assert_read(fd);
+	__mfd_assert_write(fd);
+	mfd_fail_punch_hole(fd);
+	mfd_assert_shrink(fd);
+	mfd_assert_grow(fd);
+	mfd_assert_grow_write(fd);
+
+	close(fd);
+}
+
+/*
+ * Test SEAL_PUNCH_HOLE | SEAL_SHRINK
+ * Test whether SEAL_PUNCH_HOLE | SEAL_SHRINK prevents removing pages from
+ * the file
+ */
+static void test_seal_punch_hole_shrink(void)
+{
+	int fd;
+
+	printf("%s SEAL-PUNCH-HOLE-SHRINK\n", memfd_str);
+
+	fd = mfd_assert_new("kern_memfd_seal_punch_hole_shrink",
+			    mfd_def_size,
+			    MFD_CLOEXEC | MFD_ALLOW_SEALING);
+	mfd_assert_has_seals(fd, 0);
+	mfd_assert_add_seals(fd, F_SEAL_PUNCH_HOLE | F_SEAL_SHRINK);
+	mfd_assert_has_seals(fd, F_SEAL_PUNCH_HOLE | F_SEAL_SHRINK);
+
+	mfd_assert_read(fd);
+	__mfd_assert_write(fd);
+	mfd_fail_punch_hole(fd);
+	mfd_fail_shrink(fd);
+	mfd_assert_grow(fd);
+
+	close(fd);
+}
+
 /*
  * Test SEAL_EXEC
  * Test fd is created with exec and allow sealing.
@@ -1736,6 +1843,8 @@ int main(int argc, char **argv)
 	test_seal_shrink();
 	test_seal_grow();
 	test_seal_resize();
+	test_seal_punch_hole();
+	test_seal_punch_hole_shrink();
 
 	if (pid_ns_supported()) {
 		test_sysctl_simple();
-- 
2.56.0.307.g5fe7bd680c-goog


