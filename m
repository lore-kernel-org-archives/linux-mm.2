Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E222CC6B01
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5CC96B00AB; Thu,  2 Apr 2026 00:13:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B34566B00AD; Thu,  2 Apr 2026 00:13:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A716D6B00AE; Thu,  2 Apr 2026 00:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9769F6B00AB
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:13:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32E848B85F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:13:44 +0000 (UTC)
X-FDA: 84612297168.04.B9EB81D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 968A414000F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:13:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j3JlmQ5U;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775103222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bj/m8TNOzP7qOzavXuSIEO8AJVi44udp9x7i1Rj/N3Y=;
	b=rhcC3D92UgXzExYTnpdcqTSD7gAMYT29FnTHulXKDDLCU/+diGmJdJcgDdFOr32zgUB1lp
	otFvfT+DPfKLinKvLadHVe3qGNOhnx15ZE5GWW7Ypv6vMB8GpIji8jH6NcNSwdE7ZqpHGN
	Gv95jTBXa9uqKFkrS2yyFyrejfx4J4U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j3JlmQ5U;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775103222; a=rsa-sha256;
	cv=none;
	b=K1Rrw/EFoyNwE/1wwhq9SMeKyEpqlFcxu4M86SBVRy6may/lhwkNr2dkndRbYT6fGPAWf7
	kN6Sy5TU7wK8UpZ4n0hHVkrVHfJ8VGUkA24EJ0pcjCW9FxbKiU0Bhj6k7oQLtEQHl+cv6a
	JO9+njn4wqCTbKceVfg46dodEOx84y8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 01C6B61862;
	Thu,  2 Apr 2026 04:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC8EC19423;
	Thu,  2 Apr 2026 04:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775103221;
	bh=vrai7iUOkplMitPBGsDeCd9GnVnwQZI906Ju/ms0Utg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3JlmQ5UKZxGjgiCtzC0W6uqZcmLn2kyTfoJnQiKz2i/pv/SwtJGFtCAOUeOROnDk
	 /vKD7hQ8UjLfaJDLtV80QgDLvF9ZgGOtuAnQ8cmLEagcaBhFg21F2yBipSLqHYRpoc
	 Djwy3xo5w6pyA7bJM/+AQAG45GKkRXg+ylI4dkiiAsY51DvQXT+c9DMZ/EyT3iqIgh
	 20pYyx0b9tLquYgScpjI4KvD6qufTJygxWNYGwZCEYITj0sawuNF1ny3VzCrKyt298
	 Iwu4iHRrlOtzjKFPQbtoJh8L8JfKfG7Mus4CG4OFJ2/hSKNa1HxVWRMWtjbTEfGX3p
	 QyQs0CoaHZ52Q==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 14/15] KVM: selftests: test userfaultfd minor for guest_memfd
Date: Thu,  2 Apr 2026 07:11:55 +0300
Message-ID: <20260402041156.1377214-15-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402041156.1377214-1-rppt@kernel.org>
References: <20260402041156.1377214-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 968A414000F
X-Stat-Signature: 9n3wgdhjop91ntkxnmgrc97s8mo7jzpk
X-Rspam-User: 
X-HE-Tag: 1775103222-687260
X-HE-Meta: U2FsdGVkX19NKvpqY42aEXU2dBYQ9KwfOZ1+e3F9st5ea+OGwzDwL7h74R1zTGRzkFuUNkPLMZMmCZTJFHC2nk/SZh2+JdeZfmJOC6uzwHpCxw5IyHOCaGl6kiLzFfUvBj1ya34nI29B3KQRtRLfSYf4BXTpZOtG2XEabrpxPDysYFhWmDOsMCxwnG5MeFicADO3dSdlZ1wi46ZXqfYoAK5RwGZmF8oX2YdU5g+63Eh9ScHcSpDAGjUfXOEtCdlscgCuQ6qRrEYUCLLIPZ9NxK46MfF2zS59S77Ckj62LfOkfW1xf12k6zfghca6P0+Cm9s/O1HK9dV+uMu7PYuBLT/F+aRNN0B6Kqlb7fXiQh9QrCfIyZApthh/4Q6GbJ/p8jwCFATR7+aUkZOTm+vPeWstJ2YL0OjFoN8PxvrqEJV9sd1G+V/nGBSNZ8/HHACHNX53KC+2VMKGzgWxp9YKH2b5HAI2Z1nBcyT57v1SwEKFB7x3QiBg8CPoVzyUVkWPmKMOiR+ltdH3ISFx2qgxhrUCt5lN0VQaiu4sqglO7m09yGEUBBRJ7J2ZrFAsEyJQdTdNb1YvRd16DCeWflKzdHl80Vx7+5mGrSIpze+xhVZrie27hVElgGNICTHXiC2p7Si/Gult8JTadCxoILvBULg3QOhuTQabQZ7BQXKGp+WCLDuOBuE5Y+T0KWXSORLq1mOHVUPvdRQGN/OLZaqa9AalA8Ccy49zH6U3XKM9Igi6PrDExtMU/Ka62X7uBlgBLPZFHwGn9U+SgIWZHXOlkACX6UGNh3QLdvtUUV1KyNuo9eZA7F4rwIO1/8dyTSsiPvJ0xRg5lDjeDwN9u/Mu9NTcrsQ1yyNr+aVkgORW1cf2ERZ7OhXviJHXVbravlUfw92mvHkZNRZGY+/nTY37ckSWzlzi8qdClTRRVzDBMalmOmcfJ2XiVc4qe1d1qNGzoroeeTkFGz4L3IxjNpW
 VlRJbFwl
 ejbxHsMwi7QS8YmzD+S7Zqyov/XC/CDTsQ1frZe9YvIIuZwvZ/V3/6Q8Alfvr3Pkza1Tvsw1RDbjYKE1okdHYOaBY0Z1WRiV+Cphns+gPMzUHlX6tNHThoMupMew7yfNKr5dhWYlUACiZ/bCu3k5zjgroX4R28uRDsvLDcqI4xOP+az9Nub7hnJtKkIe8v7Ib7nsuoxg5sqQu9jBanK8DmRwfCxJVZhjF7extGTsBN452qrBjXCTi7lIKAXToHZC23gDxezqiwjiaZkQs2U5o+Xu1fie2C+f3M32vkxOpWPhbzcTjUE0jVcUFUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <kalyazin@amazon.com>

The test demonstrates that a minor userfaultfd event in guest_memfd can be
resolved via a memcpy followed by a UFFDIO_CONTINUE ioctl.

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 113 ++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index cc329b57ce2e..29f8d686c09f 100644
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
 #include "numaif.h"
@@ -329,6 +333,112 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
 	close(fd1);
 }
 
+struct fault_args {
+	char *addr;
+	char value;
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
+	struct uffdio_register uffd_reg;
+	struct uffdio_continue uffd_cont;
+	struct uffd_msg msg;
+	struct fault_args args;
+	pthread_t fault_thread;
+	void *mem, *mem_nofault, *buf = NULL;
+	int uffd, ret;
+	off_t offset = page_size;
+	void *fault_addr;
+	const char test_val = 0xcd;
+
+	ret = posix_memalign(&buf, page_size, total_size);
+	TEST_ASSERT_EQ(ret, 0);
+	memset(buf, test_val, total_size);
+
+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC);
+	TEST_ASSERT(uffd != -1, "userfaultfd creation should succeed");
+
+	struct uffdio_api uffdio_api = {
+		.api = UFFD_API,
+		.features = 0,
+	};
+	ret = ioctl(uffd, UFFDIO_API, &uffdio_api);
+	TEST_ASSERT(ret != -1, "ioctl(UFFDIO_API) should succeed");
+
+	/* Map the guest_memfd twice: once with UFFD registered, once without */
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap should succeed");
+
+	mem_nofault = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem_nofault != MAP_FAILED, "mmap should succeed");
+
+	/* Register UFFD_MINOR on the first mapping */
+	uffd_reg.range.start = (unsigned long)mem;
+	uffd_reg.range.len = total_size;
+	uffd_reg.mode = UFFDIO_REGISTER_MODE_MINOR;
+	ret = ioctl(uffd, UFFDIO_REGISTER, &uffd_reg);
+	TEST_ASSERT(ret != -1, "ioctl(UFFDIO_REGISTER) should succeed");
+
+	/*
+	 * Populate the page in the page cache first via mem_nofault.
+	 * This is required for UFFD_MINOR - the page must exist in the cache.
+	 * Write test data to the page.
+	 */
+	memcpy(mem_nofault + offset, buf + offset, page_size);
+
+	/*
+	 * Now access the same page via mem (which has UFFD_MINOR registered).
+	 * Since the page exists in the cache, this should trigger UFFD_MINOR.
+	 */
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
+	TEST_ASSERT(msg.arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_MINOR,
+		    "pagefault should be minor fault");
+
+	/* Resolve the minor fault with UFFDIO_CONTINUE */
+	uffd_cont.range.start = (unsigned long)fault_addr;
+	uffd_cont.range.len = page_size;
+	uffd_cont.mode = 0;
+	ret = ioctl(uffd, UFFDIO_CONTINUE, &uffd_cont);
+	TEST_ASSERT(ret != -1, "ioctl(UFFDIO_CONTINUE) should succeed");
+
+	/* Wait for the faulting thread to complete */
+	ret = pthread_join(fault_thread, NULL);
+	TEST_ASSERT(ret == 0, "pthread_join should succeed");
+
+	/* Verify the thread read the correct value */
+	TEST_ASSERT(args.value == test_val,
+		    "memory should contain the value that was written");
+	TEST_ASSERT(*(char *)(mem + offset) == test_val,
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
 static void test_guest_memfd_flags(struct kvm_vm *vm)
 {
 	uint64_t valid_flags = vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS);
@@ -383,6 +493,9 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 	gmem_test(file_size, vm, flags);
 	gmem_test(fallocate, vm, flags);
 	gmem_test(invalid_punch_hole, vm, flags);
+
+	if (flags & GUEST_MEMFD_FLAG_INIT_SHARED)
+		gmem_test(uffd_minor, vm, flags);
 }
 
 static void test_guest_memfd(unsigned long vm_type)
-- 
2.53.0


