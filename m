Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CFD3CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:37:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9EF08E006F; Wed, 15 Oct 2025 14:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4F4F8E001D; Wed, 15 Oct 2025 14:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C9D8E006F; Wed, 15 Oct 2025 14:37:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 97A8A8E001D
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:37:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 44DF5140218
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:37:04 +0000 (UTC)
X-FDA: 84001205568.11.F41740A
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf14.hostedemail.com (Postfix) with ESMTP id 90CE5100002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:37:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kyw19XK6;
	spf=pass (imf14.hostedemail.com: domain of 3zenvaAYKCK4kmWVObUccUZS.QcaZWbil-aaYjOQY.cfU@flex--wyihan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3zenvaAYKCK4kmWVObUccUZS.QcaZWbil-aaYjOQY.cfU@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760553422; a=rsa-sha256;
	cv=none;
	b=HiP2icZn7/qEcbOEHCqIBoaw9FgCbCnxhe8fqD8qZFwpI9SaGJ6EIHobBSqzyQRsG3qwxO
	gLqbXjTcn5NrwcLPcfZR/jw5cHhyq2WHpFLQjLtixdm8Ffbn7SWEB1uI4TKsrTyA8A2AtW
	PWCv9wUSGqZ8SzLkoOytn9mQ8M9EmVA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kyw19XK6;
	spf=pass (imf14.hostedemail.com: domain of 3zenvaAYKCK4kmWVObUccUZS.QcaZWbil-aaYjOQY.cfU@flex--wyihan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3zenvaAYKCK4kmWVObUccUZS.QcaZWbil-aaYjOQY.cfU@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760553422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNUm5TxoGqq4kCj6yXsKowaihB2Pt1TXPKBWeL6tI2k=;
	b=1HDfcHaCfvx6mp5vv2h3lZt/Ha6OUQIpjQtsQvo/vg9AHlcd4ar6RqAAd1c9cUv2JsxTZa
	qFCop2WA0u3xg94+PWBdk0KY9E/2z6e0dnvHwMEx2+6d5N2ZwJL+J1E7ScXGTNyQf1Qe1/
	L2pIW/34fseQfrLAHQdgg/8fV7bMzIA=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7810af03a63so18793311b3a.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760553421; x=1761158221; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pNUm5TxoGqq4kCj6yXsKowaihB2Pt1TXPKBWeL6tI2k=;
        b=kyw19XK66PG190JAh7A0FJU+vU73+cVg87GNSvKPsk0o/q+BktUT+pTeZQBJzn/vF4
         k25qBo5J/J6b7ivmHEd7vfEJBamcn9q7afJ6Rh/R5v98yLf67VVth4+i2uNTkQwOXUgE
         KABhSUxrHc9CSKTyVN2sVDaCJOY4KJe7dOy4jrvW/xW4L1V/pTH/2xdkteyzISwwnhuX
         jyq/0uoBE3jU0Pr9EWvsDvYALw/LAcqsRBt/ZmLA5J5/hAIlEumup4GEzc6I08xMtGnW
         RDrst6thBn10bOO6rHwSjZdazX2/cZCmlUF3iHC1sbxX9s2XUbdPkQKGwkDwbM0p3T6L
         tbCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760553421; x=1761158221;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pNUm5TxoGqq4kCj6yXsKowaihB2Pt1TXPKBWeL6tI2k=;
        b=UudluQeDaDo294R72CqDGe+d306jDzKgaM56fQTYjfxwS4mIgVEep2Zt6H6uePza0+
         xGHz+wdbsy8earn3hqrt4lCL9mBaLskLCT6/wYRp1cjk0bqgR14opC62GKkYM92Pp4zY
         Nw/SH2oCgUVlRWyQbgvUjJtMlf85DsnTUKPPEfMlepdcaF7mmJJEVq5DVax5RAP7NfPh
         0gZzc6KZGC+fx3Tfa1WSMNuocG/XYubBKYt5gNfSbYmjnShs5fpEocxfyU8UtQMmXblN
         iC3gFREM7WEWCmk686qjSr6Vvjq2/gVWDIitGAfRDMM53yeW9DQv3Cwz42MeYStSIdUx
         dzig==
X-Forwarded-Encrypted: i=1; AJvYcCWoumoUvkqCvPDFRpzWPJq5PG8OOqSQmXIvI/euCPxWN7eluzmRi01lUeYEcddbQwuauFnrF8B6MA==@kvack.org
X-Gm-Message-State: AOJu0YxFlD70o4bTqNimXPg+XRMW7StWNyXqbEpGnSBwzQqMKY21t4Zm
	LJY1vxvZo1rJ35JiwCsDe9Y+8PCqdnVrX7PEh2karwHlMl0Qizl8kxRlkNTCvLcDeX+/KbGSZdL
	CjVoUgQ==
X-Google-Smtp-Source: AGHT+IHLdKy38sFu9TnafNft1eGkPjEu7P3eYK+dKeIOsoTjhzPq3NWVPBrize9lj05WI9yvd58sUurqB5M=
X-Received: from pgww4.prod.google.com ([2002:a05:6a02:2c84:b0:b55:1380:417c])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7289:b0:2fd:a3b:9349
 with SMTP id adf61e73a8af0-32da84e8482mr38825805637.57.1760553421530; Wed, 15
 Oct 2025 11:37:01 -0700 (PDT)
Date: Wed, 15 Oct 2025 18:35:53 +0000
In-Reply-To: <cover.1760551864.git.wyihan@google.com>
Mime-Version: 1.0
References: <cover.1760551864.git.wyihan@google.com>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Message-ID: <cc4764476c69139866d8baba84b4eff6de85b8fb.1760551864.git.wyihan@google.com>
Subject: [RFC PATCH 2/3] KVM: selftests: Add memory failure tests in guest_memfd_test
From: Lisa Wang <wyihan@google.com>
To: linmiaohe@huawei.com, nao.horiguchi@gmail.com, akpm@linux-foundation.org, 
	pbonzini@redhat.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.or, 
	linux-kselftest@vger.kernel.org
Cc: david@redhat.com, rientjes@google.com, seanjc@google.com, 
	ackerleytng@google.com, vannapurve@google.com, michael.roth@amd.com, 
	jiaqiyan@google.com, tabba@google.com, dave.hansen@linux.intel.com, 
	Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: wbh5uupbuk7b9pk8psmjp5hauip3km89
X-Rspamd-Queue-Id: 90CE5100002
X-Rspamd-Server: rspam09
X-HE-Tag: 1760553422-443588
X-HE-Meta: U2FsdGVkX1+o1i+D9CcM+DdXjVq27ZAAfjHj7V45m2DPBuEhhTLxQAXc4a41y1VrcJsuLJv+Iuu52D8cK4MskJVBl6SVxav4ZfvcRWhF8DrDI2IEwD4GO4BHPCp0ElLs8jQrBxUkGHJtnO537xDdwlHDs1UZRZMDOvLYu1JrSsyE2GvHP7MjwB7B8IyH6ltaQ1b1x/V/T5GEpibWNIAXk3+c+wEgwMysO7xjnDyQEkM83j8lr2Bgv1kWZIQlsEbJKH5eODA6P5JEfZA1zxw+VOuRybiBxMQWLBS2nyPhGJ7FPq/ld4fzMDnOl6e69PJio2VPT5KAyAg4vLsxpBqiVKhoO+PnIVzYlmvQE5rmblYbPEkrCqKR27QJv74BTlP9IzhXFP4B/cZwVsjxapmbIdac/0EbkGxIlPkuy8lB4tZ1ixr8WlKZKTufBbw9SNhLEtP27sCOc4Rm08fOLi1JhYBFP9jBjg1z6pxtqBmtUKvsm1NW8QriC1tQtCOZ24BmMIDAkg86HHa5Jpi6Ex0u+HJ6ABHcI4oH+Ovrhwvf67P9d1l1DI8ilBx2PTN6g25SypYVBhra3peXYWNO1Z2fp9CQ9iKCh5KSc4nm21KCNVI4+hdhNiL0DXHxu6hw1TEN4AjFrJZ7x9Jyv39JlwciYyOT+fzXyn6pdC92Q4D36xcnz6K7R3mwxPfRkhLt/HZ9E9sz0qkzNzMMil/9tm2hL4sI7QUf621pK/8pfaBsz7AOQN2Pmmfjs/XhqdbY3ak5uEtmIzxMjap/CQ/N1hGd0Mc6l0dYRHOjBHry08QXLLWK9L0QpxOZ45yNJ6PZ8fs60L2aWAe+g0kKgME9757C8NDZLNV6WsYMA2Svdph5uPlmVAHoHoyrswFM6c93qObB8m0ZPDTX3njtrEKlchni6wzofaEUkB8agB7f1Y0yuVM/Ci4iBUKBFOe0ufBhsGav9NY8eBE7cbjfoKiWYkX
 dcZThWZu
 NTPJsNsGaQ2aaMiHr0MTFRZpdkI6M+uiVdU1CzSWCDZQfChwO/wsZ/k4vehHHv5K8saeI1RZkJbc2AiwqqRgOZaG1QQC5yzkM2R0lajhb8cV8x1voX3Dtw8xQU8FcArTrfgx9RdFdUxlly8NeFrGhEHQcSkf9iV8Hgh6C6atW+VrC7VDBjRKijvZsgsgxD2o7JKyHUmKtHM30o7dA0mroqRvfV3l8Ssv9E/wTMJhSMEA8xpsIj+5EP7zm6leFyZ1NCltSS/6LLQbH6hKjyDcdHLoV74JRCfVSC6KVWyXShUfE64N+hYcMWaCPoWVhiN4W5Gvtrm/6QtdOYyhvM70lQZokRdXJE1S7J75/1hqXk9mHWeGnV/pAYHv3Nw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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


