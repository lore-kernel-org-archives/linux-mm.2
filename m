Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 225FE10F9965
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 17:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 686A66B0096; Wed,  8 Apr 2026 13:26:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 594AB6B0098; Wed,  8 Apr 2026 13:26:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA946B0099; Wed,  8 Apr 2026 13:26:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 34D816B0096
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:26:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD68F1A012F
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:26:22 +0000 (UTC)
X-FDA: 84636067404.22.7241B31
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id DE0AD1C000A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:26:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dcgm5yfH;
	spf=pass (imf18.hostedemail.com: domain of 3u4_WaQYKCIoACwvo1u22uzs.q20zw18B-00y9oqy.25u@flex--wyihan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3u4_WaQYKCIoACwvo1u22uzs.q20zw18B-00y9oqy.25u@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dcgm5yfH;
	spf=pass (imf18.hostedemail.com: domain of 3u4_WaQYKCIoACwvo1u22uzs.q20zw18B-00y9oqy.25u@flex--wyihan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3u4_WaQYKCIoACwvo1u22uzs.q20zw18B-00y9oqy.25u@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775669181; a=rsa-sha256;
	cv=none;
	b=ryeAD7kBGpLgctvwMGHSocyZlIHl8PazOC6cQNMGaEpRWd8uEqDMm8qPGgPPnJ4y9Vllrx
	27OXv8bRpcR67ktPXgTSNBooRkAP8g11ckqv74tYdGZlGlZazgQ2Txwrm1INYbYLZaDnCE
	zSLv/gKSSXnKcP8zX3SWcJNg7IlapCQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775669180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6M4pXx0B97fE1Sqiv/KOXEr7lN2rUW0ryR2fEAKsbFU=;
	b=UiFBuD9Fxrur4yoziXMkLV3Gkuw3PLcQD7fz/M18WxUpbPurt1DfGlS7CGFdhr+UT1QGG6
	+o8yiBDw3G7rOVpSwtKulpieN1yhc3VTzZMFZWPghNZ5zN6tzov6nFys/X+phBntYEJbqc
	cvEPGpqvMp9de83OtuLvFyOhyKExH+Q=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-358e425c261so187734a91.3
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 10:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775669180; x=1776273980; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6M4pXx0B97fE1Sqiv/KOXEr7lN2rUW0ryR2fEAKsbFU=;
        b=dcgm5yfHjZC15D71lnBfTbIdpTmXDuXizYdYmrjxaE85twOSK5mcyxKGqICgXtc9xZ
         Agfb2pxSXzBL+dqaWgi2FUIFBdphIMog90wmnc2GsNc6c9GD60qAGDBGoi+wuHkHlnlD
         glYVf4GYtwCOcFxttXoK6KOOUvjHs27WReneFNS5jdt7vXc2GAzC/qboNnlt8F47NydO
         NmOl+5noEgm6beeE0N9NL2ufRjLapE7vjpuS2SzyRV8Y8NIahFE/LllUCLi18yY2PZOL
         5hTMNBQ7en4Ccw1Y6LwR9QXgxdIPqpZaaFVenhPNkqJR85MsoelVgp4Hjgiz4db1qI1N
         7tNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775669180; x=1776273980;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6M4pXx0B97fE1Sqiv/KOXEr7lN2rUW0ryR2fEAKsbFU=;
        b=K13MVzUYNIPqkSJ60/TNeJvLN7D1Aeka/mKDOOasMvh+DHbgolKBsXzgBTqm5EF3HX
         LHtCOkp5vjLYiL17/iu8XZ61WXc/HJxEf2UeM9MhDR9XBvuJtrZ9BfUwFygvM3tTXEqz
         FDGbtIEHtJpjYfjOkh33h4y1q7dcExfUmJei0faG+yDt8aFjDL40xYwxKpVKZv7gtQyL
         8UIqr+rHXhkei8QQ3ddsXQSrb05X84qZJMbvxdxhawGCG8bbM5doGGoT5Cg4rtFnnOPW
         Xhs3KoxDBH33kfTTYkWTO4VnTZTF6bDSgUZxpRPEO9u99mDt9veNh9YlQTNbERBVBVtG
         1Z0w==
X-Forwarded-Encrypted: i=1; AJvYcCWJ85iSu6k8mjYPfYobbetx++YtAdXng5BtQ7r0FFqDdnewKAoC9r5lnPtEkQ9cdL+onkdSli8nfQ==@kvack.org
X-Gm-Message-State: AOJu0Yxy6ZEFO10dbDkd7eBkptw13KwQASQR5lK2Q7Kl80vYnHWeJ/dG
	wdKM9J4XcrM7rqq9rGtMMTsZGh7FY5ffDRKviHmdoGkSu8ltAbm8aYU/ttpW8kvf6PAmP+sB8LE
	q3W8ihg==
X-Received: from pjbng10.prod.google.com ([2002:a17:90b:1a8a:b0:35c:15e7:3e9a])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d2c7:b0:35b:e4d8:bb10
 with SMTP id 98e67ed59e1d1-35de6941267mr21599298a91.14.1775669179620; Wed, 08
 Apr 2026 10:26:19 -0700 (PDT)
Date: Wed, 08 Apr 2026 17:24:47 +0000
In-Reply-To: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
Mime-Version: 1.0
References: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775669168; l=7963;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=PRy8p2rUQ0W21+IYbMpy4JGA6ghFl2d0Arn6M88nXQU=; b=SelHs7lTDkGdo9DI5JdcOfHrxMcwdfFhOyxFyu4NGq2go+u9m95IzSNH4SMDLMXwVTFjLz3pP
 ikjRxFwOehVAWvjCfGs7Qg5lqkHHB0cx8vZjdnM9iGQtaPdfF+HPJIb
X-Mailer: b4 0.14.3
Message-ID: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-6-718f45eb7c75@google.com>
Subject: [PATCH RFC v3 6/7] KVM: selftests: Add memory failure tests in guest_memfd_test
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DE0AD1C000A
X-Stat-Signature: fkiuw6rwtwumr55mmqmyny7w4isdxz34
X-Rspam-User: 
X-HE-Tag: 1775669180-861903
X-HE-Meta: U2FsdGVkX18z/0GGGJPGDyUeM4r8oS4lzEZk++gji/7JyThMq8ayusJlHMGiENar1Yh6ukU5sK1hcmNP3f8MdURikKLFNTwMnTo1yP9HubtP484rOcfMFiMcCwdjCa5bkDi+5wDHCBwHbBuIywli72qah+Q/QL+lT+hYPTY0HoEYdcApu6R/DYqgK92CWbIuOW9ZjCxXl8AlRSeT5BV/6mDgjrIiWzhVFz0anTPat1ld4yw3zuYeil5dlEWTqCJKKDjZjkQ3T9QrObn7u338OCNOCptLXot9ynytEIEElMk39xC0MDSOiA8HQ+VkB0uCxbv4QCQYij9eUUISzN5qHqvhW8+JwHrhiiifxmvO/TevAcSkKpd2E6KBfntxfgV3mxGcXHimsM2ASoIXueXzno84a7nM4fRZ7qZV8Zn6z70Zd3ZrAHhvP/Gm+QKQK4nPkOnt1EmH2DEhTOph3rukLIZ6Ii+rPf5H9L4Nlc6692n60644SP4I6IsLBfVhaXAOf1GFY4YzDKdzu0YKjEtEnFoc/OMFkXelwL0nHWHtW5n5QyeaB1cZjeKLZGbKM6ATdkTjgSiM9lCltgr7NSrtzl9mi0hJDwd0WRz6uhqvg20iGmbgEMtHYx7BuqT5TgJh5ckZcoDyu2ti/tRm11ybfaRC/6bVtfDL6va0BOBBhq5H0XNhz78A3cKhDD0FqR6NFGWwyiQk7Q8XWcplyyB7Gc7P5yD/Tejyh0ezLaEAiMQn9VyVAjkc4bM3MPzQKgCspauul17cygRl82dvcvl2b2uEqYXRXN1T8ip4jPXfrGRvSC303f3dwbAUIYgis+FJRAZO3wpo1YU0aex7fm0vSlWGYxoOJPF5e29xeayXHxrJiHw04dBmZ2iuoofs0YGkp+3N0yGoNHcUkMHjQ9rhWyrgbS2iDmzwUqa0l+zF5EsOeCcLaYDTJs642aklopAbAOT8kudDCGfyQrU0uOU
 SHABZh6P
 31Z8lDPIrITwORyqgHEzcbPiQRWadHJ+1TEn0BosB6xrey1g7BZH7gWky+iDtaXMtLTYEcnVyM8m2MQcIBAqzTiwVJHTAd/N7k8xo7Cqrz14+gee+pUKpOrlz4BbyBlVvn60NsXH3j4uu0XkIeTn+Z7Jpo1iiIs8Ywa/7rAqsVG0U2QbKlPdmIKwOdO3ItJyje/0/uNPgR6+txW4DapLe2v7v7xnU56Bq9J+Q52M8CkFHdofI9jshE0Rzf4kRXdteLq+wXphSuKGRoG7it5T+iFs4lCQujOlW6hmet9rmOHgoSCnhdKg0f6KZvnB334Tqlda0n7D6EKIf6sa6Dd9OQ8CIsn3EzYaGvyAqbB0kwPzKkTGvsXT5F2Qpkwl1ZQEiFD8BFz+F5MCHsRdp/Ypd+L7BSByxx5iwYPYaog8I+1I5z8Nxx2Pkb4+0k10iEk5ync62V61mgCcC5yXQiJM95AktOB/ooyLtJ66wUsA+Qbpq2lKVO60fjQan144re2XKHnMRWTQYWxDIZyM4LYPf9whhHGy4z6xsavxQ+TyZeAm/qx9nSLSRbMN3dH1JWszhx5GiS0AuYAhSe33wS7ZkfOtn3VKKMcngUcRB6IW1704YB71l7O2bw+qrSlAMLFCF2jA5IScYP96X5pbZH4b3yEnd0ibvajfZNEels2VqLPvF4xmOKtXsnFHXsJQECrk+ITvHveQvyJLQWoIQhwDs62jqaxIYaKzBfxjAC9fHYhbfcWOEE35IfXz8ig==
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
 tools/testing/selftests/kvm/guest_memfd_test.c | 168 +++++++++++++++++++++++++
 1 file changed, 168 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 618c937f3c90..0ea4e7d7e6d5 100644
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
@@ -193,6 +195,171 @@ static void test_fault_overflow(int fd, size_t total_size)
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
+	TEST_ASSERT(pagemap_fd >= 0, "Opening pagemap should succeed.");
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
+	TEST_ASSERT(fd >= 0, "Failed to open %s.", path);
+
+	len = snprintf(buf, sizeof(buf), "0x%lx\n", pfn);
+	if (len < 0 || (unsigned int)len >= sizeof(buf))
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
@@ -370,6 +537,7 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 			gmem_test(mmap_supported, vm, flags);
 			gmem_test(fault_overflow, vm, flags);
 			gmem_test(numa_allocation, vm, flags);
+			gmem_test(memory_failure, vm, flags);
 		} else {
 			gmem_test(fault_private, vm, flags);
 		}

-- 
2.53.0.1213.gd9a14994de-goog


