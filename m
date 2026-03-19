Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91C2F1091932
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 23:31:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C7716B04B7; Thu, 19 Mar 2026 19:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A0DC6B04BB; Thu, 19 Mar 2026 19:31:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5776B04BD; Thu, 19 Mar 2026 19:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E1B966B04B7
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:31:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B198BBAFA4
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:31:07 +0000 (UTC)
X-FDA: 84564410574.01.E43A3C4
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf17.hostedemail.com (Postfix) with ESMTP id D3A7440015
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:31:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y5SO1Y0B;
	spf=pass (imf17.hostedemail.com: domain of 3OIe8aQYKCI0DFzyr4x55x2v.t532z4BE-331Crt1.58x@flex--wyihan.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3OIe8aQYKCI0DFzyr4x55x2v.t532z4BE-331Crt1.58x@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773963065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0XVkZljvWyJMdTaa7/apTU+xEzctUK1Me6jsTW57n1c=;
	b=TKGBX/d+3DIUVkPH2+HOJRtRSp6pFuNr/w7gCayJ0+r16VF6MLkERKUih3TOmdMg/vW8mF
	07nAefNvtgBkQgT/KA5g1NMINGfX5VTxTJwR5KaYr1OzMEY0TGkbISJzroHbmIWHf90mIT
	Xb3op5FbI6VDxcSU+OjU8ucIyfqgsNQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y5SO1Y0B;
	spf=pass (imf17.hostedemail.com: domain of 3OIe8aQYKCI0DFzyr4x55x2v.t532z4BE-331Crt1.58x@flex--wyihan.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3OIe8aQYKCI0DFzyr4x55x2v.t532z4BE-331Crt1.58x@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773963065; a=rsa-sha256;
	cv=none;
	b=djM4QB26EU4c04McSY5wUPaTn0YeUuP5urWlAoxsMHi6sAWvVkujw7f2DhOcgt7r8QaSig
	fTPbk0FU82mwGyRc4NV8W6gD0R1P++4TTtOWupwBTvLXX8qgEE57G8DZxbAqXQdPI2Dhch
	usMRQJuWW+mp9UIgzURGtAl0m9OIfU0=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b0565d77a6so20551405ad.2
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773963064; x=1774567864; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0XVkZljvWyJMdTaa7/apTU+xEzctUK1Me6jsTW57n1c=;
        b=Y5SO1Y0BT/v7o1e+NVzH87thUi+e3ijoswcygb5V4qxQTXvMzBCdri/iQH92cBvrvo
         hsHBJfUMD9fx8rk+kr9FbS/U8DOG+OVPqf5DQCWpsezZ63TnnroAb6TM25dbBCoXDvb0
         poX66JK72fQlKAYTb8q0DJzj2VsT87OYVxh5TEV0gPIX1U12en/KDvKZIyA5+BLvDOmQ
         3qcp9HPxrpxJAQxy/lsibICPsye51HTwZl9X7e5+OHllWr19QLIqm6F2bWGxnusDQyz2
         E+jc8cDaczJH3POmtRfCcX0aCHNXCqCQ48qFkoVG6wKpV5DAecCER/YfficY/eyL2Ghi
         4FsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773963064; x=1774567864;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0XVkZljvWyJMdTaa7/apTU+xEzctUK1Me6jsTW57n1c=;
        b=Es8HkSuZQqJlg2re1P91N8Wm6yg+l170HT7ILSzNBMv3shvZ4iG+npEMosGM7ZieL7
         j7Vx+f2KfHoyD3aLkf7Sc1eb+6YJS0okIVpKANIBjUT9L3jUVXhIQkSTFBpaHXnoeiD1
         43IEBTYLWFbDErFX0lNgohFHZqatfMA5qPBinwyKRbn8fkJ79aq4Lpi8k1CQrU3ToJ+Y
         5ZD+iepXJSCwDPuMy30eDQ5TM2ZYwhrtgFUk0DkLk55aowL+YyRtxMuXFnS/m4/snKjV
         o8kyUnZC5x2aVEl0PtKsoj14xPVEIQMhpGuWnzS8KryKCqAWq8WmeVx0MsmimJ1On35W
         rgfA==
X-Forwarded-Encrypted: i=1; AJvYcCVrxc6jEeEEYbNwvZoQz1uTqYgkwPuYXf/jIedTKtLv2NksD+dPezhjmkoFZY/3toCNmX3uclK3vw==@kvack.org
X-Gm-Message-State: AOJu0Yy3FFtymx0s76eBtzR+RxhUJG7J2fM/2Rc/UDBYCpkicpD0QpWZ
	bnMFujVmZjeHw3aUWrVQfTEI1zFjZBw45ovKGf7VytRaDrc1F2SnR1yMl+fxxAXnFM9G5Wjb6BQ
	sQuEQ5Q==
X-Received: from plgc17.prod.google.com ([2002:a17:902:d491:b0:2b0:6147:a0ee])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:8c7:b0:2b0:5d60:7f43
 with SMTP id d9443c01a7336-2b0826b89fbmr7160295ad.8.1773963064231; Thu, 19
 Mar 2026 16:31:04 -0700 (PDT)
Date: Thu, 19 Mar 2026 23:30:33 +0000
In-Reply-To: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
Mime-Version: 1.0
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773963053; l=7959;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=/IV7lWhsJHF0x5A2Fq993vbJ4R9Cdskri5oidvrL+zU=; b=qXdjX2Q9/G5HKD4xyXrWxsOPx0Rn2uqxCML7evRdxyatc8uCc0KSmI17m7e+7pLSD0ksRHo+C
 w8h0S2a/h+KAmDqsho3FoLLL9CKZl1BZ7RTrb4jtLnaSxH9mgAItGtl
X-Mailer: b4 0.14.3
Message-ID: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-6-92c596402a7a@google.com>
Subject: [PATCH RFC v2 6/7] KVM: selftests: Add memory failure tests in guest_memfd_test
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
X-Rspam-User: 
X-Rspamd-Queue-Id: D3A7440015
X-Rspamd-Server: rspam08
X-Stat-Signature: hb9dgezhbfsu8o1cdtdqymeqk17krgpw
X-HE-Tag: 1773963065-524819
X-HE-Meta: U2FsdGVkX1+QFTs7sBZIVmdugCbOaZgaFPrWndbitJtdOeYtpFFCj+MrGOQTsa/HeAYjR+Nxw14LgNPNASRX9QVvwldkhMFYCvKMNCObEe4/xsPTqIYBTIAfyDed0zHOSBv8fjxiGurPJO6aDaR1eQyLLjv/NjeFCc/7UfSOGoev9Vt5Tgd2zGjW8uU9dhz+57I+gwP/7zKrezMcd4Mw/JeDqFRzF33KxcME2lrkDS1Zzjr4e2QKn1Aq8kXSOYT9gZ5KlzYd2fjZb4y2Vplh41KyVsodpf9+lgsMPthjcM3+LtsMbwACB2H6D4VFdPcVDvsjjmSXLu1cjtvaavRrGJh7bHIj5Es8Jr9RDm7WNTlDJJhg9nCYR/c7hq8hYVQoY1D1VSrGuKaccTQuSgc8IAiqdxvBKEWgMZwac4Gq9LJInjonLRvnRDe9j9w3BKOSJel/81819gnxiB5vwCd9Vbjacyg2MxMf4Vmx3LvUd8UKIcwYFfCEBVCC7fJs41yXV/g7Tys+btyQV/AMtkwYswfvua34IsQ6oajOSxZkkJgDHF7kAbgaFVPYQHHCRHjK1SbxOfRcADQG98lAC+yhFmyR0gDP8VRHOLbkMQTAHISJlwo6rq2QoTg95VK8fuJB+sLZe5XUafBeBBn1OKGH8ZJmLzPVliVu06jXIs/2jQbh5ImF4VS5izMf61VbXSooJ4ekUOPskbmLL01Tjtq7FTVzvYmCY40wmp2jM00Fca3zoKNgtSg1pqAY2U7oYTDTMgw0SUyWyEiRYBypV+OdRDfb6ZaNwnlYWIVg2QjcQKQRHrVXXUZ/YCEthO1ZRVLuUx2EE5qTd6pwM6Zh9dVli1dh8eirr+ZraPY6BXWkPbMnOFQtoASYbzuKypfIwblg0KUBd+pfygWrVZLLcYOcRlxRLgAqPSk4+jgreGjw6mjvsNwvSHxP4lPqp3XqYrFcldC9zJSI/UHtgzW6Wid
 lbCe2XlW
 7fsvECG2f+a6lqEYcktPQhR/ti1PPal2wEfO94kv3F45QuXDwpXizDNGozyiBM2svWHT0eJmXz2S40AHsaEIpznD3NSTMVOxsNEaALy1nyhTx6WI1gPsdDMfMP9DzRDOkftbQnMlL35CdAEpDScZIdVi5sDYts2L8GqT28eP4eZNFuwAS7mhKQDEvZtonJdcqXMrjSjvUF4MMKCDS+j4Ia2Q0+DmLp7HnJaXwjP+/xuOmoU3D+o9OIqwbgrpI66bH6xemK0eCX0ILMEUmTTBmrAWkHuRSCJK/mk0/JQDHhdRnSSvJG683h7kHb0tDMZv025rKO+61SGHVrwdQBpLBYRyTu54Hew0vAmFJy5E5tsI065Jf7XyrlI1KaCC3LxwNFp8S58+JzimAh7BKBNNrOTc3H74yqpjCczYQnzJ7Qq8utCgUOZeshNAx+C/BV4L7iQ4s8AiPB85pd2T6G/Uku9gjSXJqb5E/1zT4yjmb3yJqjEyoYGigWBTFg4zKsAy8p9X9ShZmD6i6ls94bBTin0POVmHpqzi8ucrQhhyWf4PRxIaGsePf5Xgq1bsS/w9BijXksS+afM+KPnX9A43sMGHSabDSeF3H66FeIZU0KAzWvM73oQwcghtSBzWNnG7Yz1PKoAngeBsils4dMiF6f/IQnJPgSnY5haPVnRUmMPq3lPfwFd/GHAHv6R/nA/iyZh07C8P/TL4QC3Wkjrl1PDNXmUtkelYOmH3hXRatkZ2H36weuHtTuU2a1g==
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
index 618c937f3c90..445e8155ee1e 100644
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
@@ -370,6 +537,7 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 			gmem_test(mmap_supported, vm, flags);
 			gmem_test(fault_overflow, vm, flags);
 			gmem_test(numa_allocation, vm, flags);
+			gmem_test(memory_failure, vm, flags);
 		} else {
 			gmem_test(fault_private, vm, flags);
 		}

-- 
2.53.0.959.g497ff81fa9-goog


