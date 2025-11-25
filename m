Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63411D0EE13
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:39:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C08476B00BA; Tue, 25 Nov 2025 13:39:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE18F6B00BB; Tue, 25 Nov 2025 13:39:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7056B00BC; Tue, 25 Nov 2025 13:39:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B1BA6B00BA
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:39:21 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4EFE989538
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:39:21 +0000 (UTC)
X-FDA: 84149992122.17.999B4D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 94FB318000B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:39:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KpDwkVxx;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764095959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+rvu5ERu2ShmTxZU6KDsFQ75CH/dfzj/xM1wZSCf7TE=;
	b=K4Mdtzs4iysE4SxeUTz55nZe8AG86iCbitu/1q2+K7SpqMIZfCxMoTcwGanF0x3oh187po
	nHGIwmnVlGqARnNp3Y9K8DJQxDReV1Ae27YewS/hKNVL0DC8O0eJQTqR7gv5qPJhoG3JMk
	053J1suOQ5SlpHbwf5/PyejcTgKiE7E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KpDwkVxx;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764095959; a=rsa-sha256;
	cv=none;
	b=zy388K+DYLtWm+wqcsCj74Z2RWdJDHebJDxNm2zyUxQAAERy+I8LM2NweZle94Nl+kzgxo
	w0g1FLqsGdRhar87t3wRHRNxl4wAXjQ0XE+fC2VkZ5BSbSuILdLhGBtvol897jvgNem6um
	HznXIb2Wxv+QiG7th/O1uYx5Qv+5chg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D29060142;
	Tue, 25 Nov 2025 18:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AD5C4CEF1;
	Tue, 25 Nov 2025 18:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764095958;
	bh=h8iM1V294GwM0YHrw7ozBTpi1JGWrn7/s48f8890vrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KpDwkVxxtG+c/qJ0jcnelffGjd9pZ8i28l7m24NCzRasNoczK4TLJUiC4FHrUVaCw
	 AMm2bkuOsfFwGpAZXg7G1uz4FFGTXpegz25u6UWhwWAnGyt3SmmtayEZX9gcNA7iIs
	 CchiL5Gq2x1uxopNFkGoDUHpdoyske5ZnY4SJjarxxF5Wqb/U15YQyXu1s2fTN5FxD
	 m4rDkPMt5n+5oAMJ8eK5Ynyyhze9OzC8iHSXholCKVJ2nY4VQ3enOtW8kKu4pNkA5t
	 +3vdhqEYDVoRkY27/+boIyypSnPNhybF118rh3aEMFTfx+DPijTJan3lagof8ge2Aa
	 SE50WKNpTSC2A==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 5/5] KVM: selftests: test userfaultfd minor for guest_memfd
Date: Tue, 25 Nov 2025 20:38:40 +0200
Message-ID: <20251125183840.2368510-6-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251125183840.2368510-1-rppt@kernel.org>
References: <20251125183840.2368510-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 94FB318000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 9soppck45fi3cmi6a4npfyhhpewp1pqa
X-HE-Tag: 1764095959-605071
X-HE-Meta: U2FsdGVkX19xIyoUXnXrJjftgFQuoulFPQ5B0KUblc2kR/K4P+2Fsaf0TcGfvYkajZHlK/wrExiNAe2T+QLBL1Rv11Mb8NwDwzLksyDpLKHQZStEZ+1+6UB+SBRlpGQzL2jYEkmtB0jqeo/9rMiebMncFwHWTrgPcG3ZMq7Xl6ya4W3JNDzeBJVJG1kjF5GmKgkFLQni15XC7DfyGn1UTgXL4r0tFhjP4ypkbGn5MU4NVb+vn/jl5jK/hGOzqr4Ii8gCm529w3wYIxomvv/uaD1sxnuBf3UW+0UOqWOgTLahikSoicYgaLd/6oE+2hzV6jIWrHScuyyZGa5k1EVCgJzOWZcsFKKrrFiZE7lygd65JC1/ZQMXw4EoGWKfo1+dikrNsX1qXIesNlemAbmT1f+zJYlX8sleY/rSpBUmVySBzH6lH2knzJd5A75ApEKSCLLrkmyu1vi/rJqPjxxiUmU+MDmCfIwVybx9uHkIItintigCTBXh8//bwrkK4OJcMq21yFi9FK3G+K6v6+eJFUJulBYk6AT46VhuEu50nkOneU6lw0i3VM44vEyVUqwjfh6y11eslmZml7E2bcQc9jKNdZ/Vr4dZSZX0OsROaFPhZsmwPcVc51NLlc3aHdvgJ01J08jq5JHfH4NZjQlg75ZBtY4FXBRBPFYAekZpNqCHVT8YqUqsnLFpaZFzg5YDyFtfBG2DhI1lCdlCYY+4JqQekE/kJhOxS71T8UDMbOq3Tc5THoT7X+xM4PSf5KhcCEiPAftehGbw0k8XwKxgpIak7ocAhZIxKzo87mE9PKHCUa6Si5HfHGl/1EV3VtAFTEVBgEjObu8I+HsYt479zvKwOXd8Tj4jq9vTu+E2514bvsGT/tuJIpTdQsj7nwpkzVjO4WQCetkaZupNkiw4tlvSptZcrOyseZ3ftkJP1c6CkCH4dCWSeUHfQZl2zHTEw9FmKwn0CyYGoNPUHnf
 h0PnGwyj
 KdFMp9INBucbfz/WqriKusURlry9/B1X6z8oWpKZ0W8C4OBJzjxK9Dpg0ey18+6kHsE6XCI0b1rpPGv70qsIl3ZWU/JmZqqMIhuX4tbfJueixho2XPBNSRr/lR2q/h07RWnS3DzGbIFm/5lPMywjhA+WWO8uoqdNq982AKQtWeDB2XYaSzTrQay3b/vp6jF+mqHH2IGu+hoy5gjTLZKOkgHdGlW03bPmxQkTwPSWlqSDai+Jh0F46IRG5boowveuDhvwUfIZxf2rh9/q4rmfjrtbxA6/oUVhVZ+httD0ulDpkpl4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <kalyazin@amazon.com>

The test demonstrates that a minor userfaultfd event in guest_memfd can
be resolved via a memcpy followed by a UFFDIO_CONTINUE ioctl.

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 103 ++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index e7d9aeb418d3..a5d3ed21d7bb 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -10,13 +10,17 @@
 #include <errno.h>
 #include <stdio.h>
 #include <fcntl.h>
+#include <pthread.h>
 
 #include <linux/bitmap.h>
 #include <linux/falloc.h>
 #include <linux/sizes.h>
+#include <linux/userfaultfd.h>
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/syscall.h>
+#include <sys/ioctl.h>
 
 #include "kvm_util.h"
 #include "test_util.h"
@@ -254,6 +258,104 @@ static void test_guest_memfd_flags(struct kvm_vm *vm)
 	}
 }
 
+struct fault_args {
+	char *addr;
+	volatile char value;
+};
+
+static void *fault_thread_fn(void *arg)
+{
+	struct fault_args *args = arg;
+
+	/* Trigger page fault */
+	args->value = *args->addr;
+	return NULL;
+}
+
+static void test_uffd_minor(int fd, size_t total_size)
+{
+	struct uffdio_api uffdio_api = {
+		.api = UFFD_API,
+		.features = UFFD_FEATURE_MINOR_GENERIC,
+	};
+	struct uffdio_register uffd_reg;
+	struct uffdio_continue uffd_cont;
+	struct uffd_msg msg;
+	struct fault_args args;
+	pthread_t fault_thread;
+	void *mem, *mem_nofault, *buf = NULL;
+	int uffd, ret;
+	off_t offset = page_size;
+	void *fault_addr;
+
+	ret = posix_memalign(&buf, page_size, total_size);
+	TEST_ASSERT_EQ(ret, 0);
+
+	memset(buf, 0xaa, total_size);
+
+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC);
+	TEST_ASSERT(uffd != -1, "userfaultfd creation should succeed");
+
+	ret = ioctl(uffd, UFFDIO_API, &uffdio_api);
+	TEST_ASSERT(ret != -1, "ioctl(UFFDIO_API) should succeed");
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap should succeed");
+
+	mem_nofault = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem_nofault != MAP_FAILED, "mmap should succeed");
+
+	uffd_reg.range.start = (unsigned long)mem;
+	uffd_reg.range.len = total_size;
+	uffd_reg.mode = UFFDIO_REGISTER_MODE_MINOR;
+	ret = ioctl(uffd, UFFDIO_REGISTER, &uffd_reg);
+	TEST_ASSERT(ret != -1, "ioctl(UFFDIO_REGISTER) should succeed");
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
+			offset, page_size);
+	TEST_ASSERT(!ret, "fallocate(PUNCH_HOLE) should succeed");
+
+	fault_addr = mem + offset;
+	args.addr = fault_addr;
+
+	ret = pthread_create(&fault_thread, NULL, fault_thread_fn, &args);
+	TEST_ASSERT(ret == 0, "pthread_create should succeed");
+
+	ret = read(uffd, &msg, sizeof(msg));
+	TEST_ASSERT(ret != -1, "read from userfaultfd should succeed");
+	TEST_ASSERT(msg.event == UFFD_EVENT_PAGEFAULT, "event type should be pagefault");
+	TEST_ASSERT((void *)(msg.arg.pagefault.address & ~(page_size - 1)) == fault_addr,
+		    "pagefault should occur at expected address");
+
+	memcpy(mem_nofault + offset, buf + offset, page_size);
+
+	uffd_cont.range.start = (unsigned long)fault_addr;
+	uffd_cont.range.len = page_size;
+	uffd_cont.mode = 0;
+	ret = ioctl(uffd, UFFDIO_CONTINUE, &uffd_cont);
+	TEST_ASSERT(ret != -1, "ioctl(UFFDIO_CONTINUE) should succeed");
+
+	/*
+	 * wait for fault_thread to finish to make sure fault happened and was
+	 * resolved before we verify the values
+	 */
+	ret = pthread_join(fault_thread, NULL);
+	TEST_ASSERT(ret == 0, "pthread_join should succeed");
+
+	TEST_ASSERT(args.value == *(char *)(mem_nofault + offset),
+		    "memory should contain the value that was copied");
+	TEST_ASSERT(args.value == *(char *)(mem + offset),
+		    "no further fault is expected");
+
+	ret = munmap(mem_nofault, total_size);
+	TEST_ASSERT(!ret, "munmap should succeed");
+
+	ret = munmap(mem, total_size);
+	TEST_ASSERT(!ret, "munmap should succeed");
+	free(buf);
+	close(uffd);
+}
+
 #define gmem_test(__test, __vm, __flags)				\
 do {									\
 	int fd = vm_create_guest_memfd(__vm, page_size * 4, __flags);	\
@@ -273,6 +375,7 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 		if (flags & GUEST_MEMFD_FLAG_INIT_SHARED) {
 			gmem_test(mmap_supported, vm, flags);
 			gmem_test(fault_overflow, vm, flags);
+			gmem_test(uffd_minor, vm, flags);
 		} else {
 			gmem_test(fault_private, vm, flags);
 		}
-- 
2.50.1


