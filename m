Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED037CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 19:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 544CC8E008B; Wed, 15 Oct 2025 15:00:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51BF78E000C; Wed, 15 Oct 2025 15:00:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459C98E008B; Wed, 15 Oct 2025 15:00:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33ED38E000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:00:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB8D6C0284
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 19:00:50 +0000 (UTC)
X-FDA: 84001265460.28.26654EF
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf13.hostedemail.com (Postfix) with ESMTP id EDB7F20013
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 19:00:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="RyCC/Fvz";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3X-_vaAYKCEwACwvo1u22uzs.q20zw18B-00y9oqy.25u@flex--wyihan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3X-_vaAYKCEwACwvo1u22uzs.q20zw18B-00y9oqy.25u@flex--wyihan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760554849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNUm5TxoGqq4kCj6yXsKowaihB2Pt1TXPKBWeL6tI2k=;
	b=mx+U7h5x4ew2ZEUuhnpEmdDJ0X4qbyp1SlsjgsJ+4Dqzo/IxplYtiMtJ2OgwSrqjDugKCF
	cHARLU4EggYiQhjvquYClRGA+8QWnMcMAHzf7HeqatHeuLylc5jIDpctxUAQlu1H86b9Wg
	lgHc88m44jAkGZZhokt9ImLibLU9lEU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760554849; a=rsa-sha256;
	cv=none;
	b=1mDvwEpnbm/h5YcrT64kfahgm9npSMpb9REklGu6l2Bsp3gm58UsdyxJdu7/SZFpoQxVrm
	T0FzE3O6PdXNaMjiU0kWnet5sPf0mnVGD2L9Xmcms3jCYmjlDvoGfZN8UeYuI0QAPX272u
	pHEk+FmWmNq8nRCrI6GjINj8V89cS2k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="RyCC/Fvz";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3X-_vaAYKCEwACwvo1u22uzs.q20zw18B-00y9oqy.25u@flex--wyihan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3X-_vaAYKCEwACwvo1u22uzs.q20zw18B-00y9oqy.25u@flex--wyihan.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-780f914b5a4so9291413b3a.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760554848; x=1761159648; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pNUm5TxoGqq4kCj6yXsKowaihB2Pt1TXPKBWeL6tI2k=;
        b=RyCC/FvzZIqlC56JO27cBTI+seKqj35s/ht4+9gAlr/AD410uBBViTg4jZA79Iq/KN
         p+9gsDHJa0PGR1eYHwz1GcYNoRS3e8fkex3ULmQjkjp6U2UvHRkC/oiXCWavwDWZCC57
         i2l2EvsfeVWfORkiSzd5wrBRCb/G/bbUzRYY/W0cFTWWiFWwMNql9Uc/zYAHKsKJr8Yq
         Rx2ZShx+B5GYtIVhIvCC1d4w3IT+zS4VZrEkGivYhA+mveIaSXs75BKgO0pZdfLBXMQs
         AxaaGnkpozc/hvvwO8eKMVC75ExWMW3s1wgVAV951AnxdsIwQAAgLGq40T8rJJLZ1W5X
         OhdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760554848; x=1761159648;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pNUm5TxoGqq4kCj6yXsKowaihB2Pt1TXPKBWeL6tI2k=;
        b=gxj28rIifK9d1EeYh7GqLSDL6HjW8NOrRAwRHWJQUlf4TecIxdmyx4FKxRS6Mh42jp
         z645WYey8UsUwObn+Yo9FjiTQ6/sqpPFoReuGK7unrBwEnBHXQr6bisB/fTgsOQ2tavJ
         yyIOZfEpm6KUgQUKywyTkuVM0m5RBI49Xpf6F9zasKfwv9uYRQ/u8DeRTJQ06YyFHdis
         kQ9DWLM7cGvXMsm3QSQigj57PH66fwQlamDI2O2brR6m9IzLM5zOwQSVDf3m6iDBeXwc
         VGDPLWtEpbp+vq6mkAANabfeI71m8XepidRGkarLVMtX7NG2aETT+9YFaNHSIBXXXncz
         5mbA==
X-Forwarded-Encrypted: i=1; AJvYcCWpolLm/aVyyN8AoAqmf+0Q+MjRgLQfi6K8U/qI4YDZs4F2IYE8w8UGQLBiTZaud+qP7g90eI5iGw==@kvack.org
X-Gm-Message-State: AOJu0Yy+t6MScq2Y6nT8Is2Gkx9mpdlcgEEXhVNKVjRTdRsHAZ35ZHro
	nL1qGlY0MX1QsjUS/Y/6JARptsgOBz81DSF9nWi2mexp6EHY82CBy41nzoOOZE2YbsaLSc/CbL1
	F1ahpBw==
X-Google-Smtp-Source: AGHT+IH9eWZybGubZq7sC/zD/yq1mEc57rW2Po4y9Ynk1gkxwdxeFsmL8u9gpOHhlAY2ESNOv+PJBInMrH8=
X-Received: from pfdb3.prod.google.com ([2002:a05:6a00:94e3:b0:7a1:f3d3:6658])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:17a7:b0:781:8832:9159
 with SMTP id d2e1a72fcca58-79385709429mr33327665b3a.4.1760554847426; Wed, 15
 Oct 2025 12:00:47 -0700 (PDT)
Date: Wed, 15 Oct 2025 18:58:56 +0000
In-Reply-To: <cover.1760551864.git.wyihan@google.com>
Mime-Version: 1.0
References: <cover.1760551864.git.wyihan@google.com>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Message-ID: <cc4764476c69139866d8baba84b4eff6de85b8fb.1760551864.git.wyihan@google.com>
Subject: [RFC PATCH RESEND 2/3] KVM: selftests: Add memory failure tests in guest_memfd_test
From: Lisa Wang <wyihan@google.com>
To: linmiaohe@huawei.com, nao.horiguchi@gmail.com, akpm@linux-foundation.org, 
	pbonzini@redhat.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: david@redhat.com, rientjes@google.com, seanjc@google.com, 
	ackerleytng@google.com, vannapurve@google.com, michael.roth@amd.com, 
	jiaqiyan@google.com, tabba@google.com, dave.hansen@linux.intel.com, 
	Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: EDB7F20013
X-Rspamd-Server: rspam02
X-Stat-Signature: oabuhaqg8tgq6u681enc8196bqyusxm6
X-HE-Tag: 1760554848-427698
X-HE-Meta: U2FsdGVkX1+dUw5jTDVevcRS0DYkQxUdyjsdg4kZAfHn3fmI9SYlWznEyWAsbXdPUH3hFB8rUudE2lvs52ZKPrQDh9YZJsn1R3F93rk2/wzIoON/L9LIU3WdTsSA9xNtuj+bDn6RKkeHEeGfRslmZoajxiBqUhkPHwvT3awBUWSH2dSSKfD87k1y7ONNEnFTTwIE3sXNwec+QU2QGPLZp+1k3M+yobhpn07VfnlVJQ7AOIA/YEpn/7zmaLw2E9coJ+N7Ks0SrJ0vs6mOQF4dmMF7m+92bN8fwtBU4AQ16428Lj0H14U4/c4nnBgqe2594HJTKQeAKUwP6D7lmGsY9niMLlcg5EsL1Qt1Gh8Kd7Ajdwksdj95/qV3xxduVHDWJCClVx1KVs79qav2+mg3qmni5wXkzSXpO7AheIPBV/Cnhq4GEQjIbhzkfyC0sn8QQbYCExPbDXP8ATb/KwxsFK9WluWlsHL+5PfzYEdhvULsJU4z8NcTMy7ca+iz330K6Yn5SPr7dPBrltMKbmLGaPooflkdFeX20OfoPXpBXBhh77FimJLA7bH9UlTfyUUlFsrp90xFwUSXLdBpKK5PIynfqh4uuiSR9ckOtS5oPhLACCw1YJeB0lImJOehUU5s09yaSa3KzcMqY6WOH611DU6y1PQAvcf1/Lzb3/RBTb+0HlsV+ANsJEo2mluzcvgpHMCIAYqyNQgvWNPwCB71iRyY6KLbFtvvpskv8TfTx25qYTlHfo8SxBvjhCMVb34/SPXlAU9qAVjMcKn7xHGIIL/5u13W7v5QbYHZOunTGZApna34LJzXlh18vPlUDbkdvtRZX6MKwQ6miWCBlZLjqh5F0r1puLY/79GvDJOrzlu3mBeo2pnCOMloHlqsnt5p1wxQ4gYEd/ai+S9n0yk4MvvQif576TXDFh1HDRpzaJXKn79Bf84nCpMSiGLnb3DSTrkkdyVEHlrAM5p4WWf
 qZO7y/aO
 DILn8A8XERyckfU/KVmo7pQcuRH4yJvGn/q6NKY0qkH2gbkRid66tvEmX2q428PAuON9Mi5knV/xCjmY4bcdlaTqKfKOXzGXYGrEKm4JCugltICXIGNh+IIK3QBGFUjXz9pGyjP//00ZwfmOrUsXxxn238/GJSKCsD2qQsYn/WadnrR3sXgEbp2K88cZ2i1min7RKafNre2uRp46ygmmbAZ21zw7bYPtc0IJfQrem9JcEAeGRA9YDKEC1hJoIW6ZG4ecaKZWTfnJLqRxyBNJfwF04gGsv3g85IA/kXVotaOSTxnndL5c3A1hbcMiLaA5SLe1r00d1AgixbTYcm4nzP7Rt5Iv3mADrMCyrxRMkj8NrU56tx/SasuwKtcCXhuprc1Fj64nSzI013Vk+TIEKenUuYfSOmU0HDewOKOQ1oSpgIDM61u1hEfBUyl53/cydkPmLvTSvxOBUN90T1tdwZQCOyuIcXOXBmBXwRkEFyQivfD++KbuwDDBdwy2Yg97MJnB7AeqAPIKE3tRy5g6UYlfUUa0Tzn2+z5rTCdHCX2g6pl2jwZKVkv8C2XCak5/ScYeqYV/AhT/jryqENbcNeHppi+aZSubQYns1PSWNL0R+wwztXihHBHOUWEYW0kY9lhhVFrQywcWIH/VonCS3RCLeIymmNDYU2uKd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>
Message-ID: <20251015185856.ZR2rQwQbZ8jtaKCHUIrelo7sRxkjH2MCFivyEUTpUfs@z>

After modifying truncate_error_folio(), we expect memory_failure() will
return 0 instead of MF_FAILED. Also, we want to make sure memory_failure()
signaling function is same.

Test that memory_failure() returns 0 for guest_memfd, where
.error_remove_folio() is handled by not actually truncating, and returning
MF_DELAYED.

In addition, test that SIGBUS signaling behavior is not changed before
and after this modification.

There are two kinds of guest memory failure injections - madvise or
debugfs. When memory failure is injected using madvise, the
MF_ACTION_REQUIRED flag is set, and the page is mapped and dirty, the
process should get a SIGBUS. When memory is failure is injected using
debugfs, the KILL_EARLY machine check memory corruption kill policy is
set, and the page is mapped and dirty, the process should get a SIGBUS.

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Lisa Wang <wyihan@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 168 ++++++++++++++++++
 1 file changed, 168 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index e7d9aeb418d3..7bcf8d2d5d4d 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -10,6 +10,8 @@
 #include <errno.h>
 #include <stdio.h>
 #include <fcntl.h>
+#include <linux/prctl.h>
+#include <sys/prctl.h>
 
 #include <linux/bitmap.h>
 #include <linux/falloc.h>
@@ -97,6 +99,171 @@ static void test_fault_overflow(int fd, size_t total_size)
 	test_fault_sigbus(fd, total_size, total_size * 4);
 }
 
+static unsigned long addr_to_pfn(void *addr)
+{
+	const uint64_t pagemap_pfn_mask = BIT(54) - 1;
+	const uint64_t pagemap_page_present = BIT(63);
+	uint64_t page_info;
+	ssize_t n_bytes;
+	int pagemap_fd;
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	TEST_ASSERT(pagemap_fd > 0, "Opening pagemap should succeed.");
+
+	n_bytes = pread(pagemap_fd, &page_info, 8, (uint64_t)addr / page_size * 8);
+	TEST_ASSERT(n_bytes == 8, "pread of pagemap failed. n_bytes=%ld", n_bytes);
+
+	close(pagemap_fd);
+
+	TEST_ASSERT(page_info & pagemap_page_present, "The page for addr should be present");
+	return page_info & pagemap_pfn_mask;
+}
+
+static void write_memory_failure(unsigned long pfn, bool mark, int return_code)
+{
+	char path[PATH_MAX];
+	char *filename;
+	char buf[20];
+	int ret;
+	int len;
+	int fd;
+
+	filename = mark ? "corrupt-pfn" : "unpoison-pfn";
+	snprintf(path, PATH_MAX, "/sys/kernel/debug/hwpoison/%s", filename);
+
+	fd = open(path, O_WRONLY);
+	TEST_ASSERT(fd > 0, "Failed to open %s.", path);
+
+	len = snprintf(buf, sizeof(buf), "0x%lx\n", pfn);
+	if (len < 0 || (unsigned int)len > sizeof(buf))
+		TEST_ASSERT(0, "snprintf failed or truncated.");
+
+	ret = write(fd, buf, len);
+	if (return_code == 0) {
+		/*
+		 * If the memory_failure() returns 0, write() should be successful,
+		 * which returns how many bytes it writes.
+		 */
+		TEST_ASSERT(ret > 0, "Writing memory failure (path: %s) failed: %s", path,
+			    strerror(errno));
+	} else {
+		TEST_ASSERT_EQ(ret, -1);
+		/* errno is memory_failure() return code. */
+		TEST_ASSERT_EQ(errno, return_code);
+	}
+
+	close(fd);
+}
+
+static void mark_memory_failure(unsigned long pfn, int return_code)
+{
+	write_memory_failure(pfn, true, return_code);
+}
+
+static void unmark_memory_failure(unsigned long pfn, int return_code)
+{
+	write_memory_failure(pfn, false, return_code);
+}
+
+enum memory_failure_injection_method {
+	MF_INJECT_DEBUGFS,
+	MF_INJECT_MADVISE,
+};
+
+static void do_test_memory_failure(int fd, size_t total_size,
+				   enum memory_failure_injection_method method, int kill_config,
+				   bool map_page, bool dirty_page, bool sigbus_expected,
+				   int return_code)
+{
+	unsigned long memory_failure_pfn;
+	char *memory_failure_addr;
+	char *mem;
+	int ret;
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap() for guest_memfd should succeed.");
+	memory_failure_addr = mem + page_size;
+	if (dirty_page)
+		*memory_failure_addr = 'A';
+	else
+		READ_ONCE(*memory_failure_addr);
+
+	/* Fault in page to read pfn, then unmap page for testing if needed. */
+	memory_failure_pfn = addr_to_pfn(memory_failure_addr);
+	if (!map_page)
+		madvise(memory_failure_addr, page_size, MADV_DONTNEED);
+
+	ret = prctl(PR_MCE_KILL, PR_MCE_KILL_SET, kill_config, 0, 0);
+	TEST_ASSERT_EQ(ret, 0);
+
+	ret = 0;
+	switch (method) {
+	case MF_INJECT_DEBUGFS: {
+		/* DEBUGFS injection handles return_code test inside the mark_memory_failure(). */
+		if (sigbus_expected)
+			TEST_EXPECT_SIGBUS(mark_memory_failure(memory_failure_pfn, return_code));
+		else
+			mark_memory_failure(memory_failure_pfn, return_code);
+		break;
+	}
+	case MF_INJECT_MADVISE: {
+		/*
+		 * MADV_HWPOISON uses get_user_pages() so the page will always
+		 * be faulted in at the point of memory_failure()
+		 */
+		if (sigbus_expected)
+			TEST_EXPECT_SIGBUS(ret = madvise(memory_failure_addr,
+							 page_size, MADV_HWPOISON));
+		else
+			ret = madvise(memory_failure_addr, page_size, MADV_HWPOISON);
+
+		if (return_code == 0)
+			TEST_ASSERT(ret == return_code, "Memory failure failed. Errno: %s",
+							strerror(errno));
+		else {
+			/* errno is memory_failure() return code. */
+			TEST_ASSERT_EQ(errno, return_code);
+		}
+		break;
+	}
+	default:
+		TEST_FAIL("Unhandled memory failure injection method %d.", method);
+	}
+
+	TEST_EXPECT_SIGBUS(READ_ONCE(*memory_failure_addr));
+	TEST_EXPECT_SIGBUS(*memory_failure_addr = 'A');
+
+	ret = munmap(mem, total_size);
+	TEST_ASSERT(!ret, "munmap() should succeed.");
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
+			total_size);
+	TEST_ASSERT(!ret, "Truncate the entire file (cleanup) should succeed.");
+
+	ret = prctl(PR_MCE_KILL, PR_MCE_KILL_SET, PR_MCE_KILL_DEFAULT, 0, 0);
+	TEST_ASSERT_EQ(ret, 0);
+
+	unmark_memory_failure(memory_failure_pfn, 0);
+}
+
+static void test_memory_failure(int fd, size_t total_size)
+{
+	do_test_memory_failure(fd, total_size, MF_INJECT_DEBUGFS, PR_MCE_KILL_EARLY, true, true, true, 0);
+	do_test_memory_failure(fd, total_size, MF_INJECT_DEBUGFS, PR_MCE_KILL_EARLY, true, false, false, 0);
+	do_test_memory_failure(fd, total_size, MF_INJECT_DEBUGFS, PR_MCE_KILL_EARLY, false, true, false, 0);
+	do_test_memory_failure(fd, total_size, MF_INJECT_DEBUGFS, PR_MCE_KILL_LATE, true, true, false, 0);
+	do_test_memory_failure(fd, total_size, MF_INJECT_DEBUGFS, PR_MCE_KILL_LATE, true, false, false, 0);
+	do_test_memory_failure(fd, total_size, MF_INJECT_DEBUGFS, PR_MCE_KILL_LATE, false, true, false, 0);
+	/*
+	 * If madvise() is used to inject errors, memory_failure() handling is invoked with the
+	 * MF_ACTION_REQUIRED flag set, aligned with memory failure handling for a consumed memory
+	 * error, where the machine check memory corruption kill policy is ignored. Hence, testing with
+	 * PR_MCE_KILL_DEFAULT covers all cases.
+	 */
+	do_test_memory_failure(fd, total_size, MF_INJECT_MADVISE, PR_MCE_KILL_DEFAULT, true, true, true, 0);
+	do_test_memory_failure(fd, total_size, MF_INJECT_MADVISE, PR_MCE_KILL_DEFAULT, true, false, false, 0);
+}
+
 static void test_fault_private(int fd, size_t total_size)
 {
 	test_fault_sigbus(fd, 0, total_size);
@@ -273,6 +440,7 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 		if (flags & GUEST_MEMFD_FLAG_INIT_SHARED) {
 			gmem_test(mmap_supported, vm, flags);
 			gmem_test(fault_overflow, vm, flags);
+			gmem_test(memory_failure, vm, flags);
 		} else {
 			gmem_test(fault_private, vm, flags);
 		}
-- 
2.51.0.788.g6d19910ace-goog


