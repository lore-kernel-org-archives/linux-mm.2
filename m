Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B47FD2FEDB
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 19:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BF8C6B00AF; Tue, 27 Jan 2026 14:31:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 194436B00B1; Tue, 27 Jan 2026 14:31:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08CC16B00B2; Tue, 27 Jan 2026 14:31:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E6D006B00AF
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:31:30 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE42258742
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:31:30 +0000 (UTC)
X-FDA: 84378737940.29.61EDF30
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id F15CE40013
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:31:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RB3nfRHp;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769542289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gEwaujY6J6vCjiupHvoj6lNk/LN3RzPL4/YsvQ2ZPZI=;
	b=WrCYTAtIJdjYKloonMVUlRX0nzb3hMzv9mXXvQ3WZ3tyVuEKnEMXipjhh8aOGAuH0+QW4/
	IAihq4PcXgi/3ZiyAPZZbEcVD43xzpBp5/vgzV9Qx9jJQ2qk+ziiLANoAhSKw+UBIvWxrV
	+BgJLxfeqIY6AQoFrnodQ1euqHZRwJg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RB3nfRHp;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769542289; a=rsa-sha256;
	cv=none;
	b=obGox+fM52oNlnQe5m9jg13Utqg/4uY8Q/qyeuzDFNlNnk7mQkQrTAlnWULncyaadZVdXF
	oEchRg+ddb6FBXyiUm38+LSD78evj83viqbl0MupdVaIW8sPAKuftqpWGqajJdA9XIegvW
	mTzY91HnrfIqfAShtN1xLH6tCUQVbSA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 16F7A43E64;
	Tue, 27 Jan 2026 19:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39806C19422;
	Tue, 27 Jan 2026 19:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542287;
	bh=rG3XSy87LBPK/+pmM3kvRr3VcKC4P6b5lnQZUhRBOEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RB3nfRHpGiNvOqxgpNiZzo3iMscL/p4GfrLZS4edKXp9deTKvngWQ5yIEGQy0e/5F
	 O11XOAS9zwA6WwsoT5yGilgWcmyGjht22jVBfE4D1zPSTO4Lh29c0kFGZKshLmP6KU
	 PjQLJdYQfcKIxrcRWATTIx/t8rhoV5ZQlgVt047UW/54jrp0GBag8tfnI1+HZy+7NB
	 nkhOJ+iWIM8WROA3H4dahP0y9fxV4wT8efsNK6Viw+ggJHFqJrxDQq2fYuWUuN2X+S
	 sHd7xyeTtYygAw8GtnHJxxga0bCx/Vc+eS/AblKFNnTFaa/PSOraMhjSU3JAzWMVbi
	 VPiCBLnWztFEg==
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
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH RFC 16/17] KVM: selftests: test userfaultfd minor for guest_memfd
Date: Tue, 27 Jan 2026 21:29:35 +0200
Message-ID: <20260127192936.1250096-17-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127192936.1250096-1-rppt@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: njo59rshxgwtpq85d3ebz5uzc11xoz3o
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F15CE40013
X-HE-Tag: 1769542288-618851
X-HE-Meta: U2FsdGVkX1+dgfVQ6zckmIDMhBEPWpLE/owvRCrH49wq5koMFjs2XkrElgfnS/Mh0GsazHVKQzymivrI4qAQ54JyrXOhNAFd3jAUpS0DoLMOS/kZ7Y+oepxpHWeiB8qvYwPsQgYAKeLRkoEZOF2oaQHq8fQZhPtvOKHkLj98Wp/ILMx+IAJBuVHOxwVNfPUlwYXrDH1OMY3Zb4pXd08+PZEfOf7FWls708/aez7VJuBvKcrOA+0D4q3WXkLWImwzsZXsmbEm0WWAZFwnUKTd/nbBTyEm7DUddv0sZJcj3G/1RpZEE5xnmrf459bN7qT5aoL9IG2aNcYWSeD8uGH3JccHc3ZkK18Oqb2JI9AdaYArBqYaMQH7oeEEg8hmkWeHvg4a+2g3NVMXTrAGcwbvaFYY9sWs1vrjAp9PwJ4lDA3d5suh/6muGejBzcJUHO2dRPYdpYCi1rThfJHS5UfP0Sk9CBduIfKnW0stOES1qePLvkP5GUyOXnZcaabNpPyJaXg7D5MBzx2Z1WCvoInf9uDXxpBtqeRIrteFp5+hu2P7yy3oUblQSbm/fvCpSPjXaDFvZD3RPORet7nxbw0NDFPdZBSdRUXZ0UV/83mwlB457BJ4f2VLNHc9fRsKRbTy1rAUQMmhfW8GL+Lr/R57Q8KBye2uTmsjXLAW2N4aGO7cDoTFWoZ6740cMvccAOSMUmygwY3ScHeX3NVyhIx0cyktUKWu4HJpfSkECfwnDXaq7Bw4DAgAby44w+tAJTznC6u6s+tHhR/ZDReh70rvWoDcHvFjR8LXud/phrnYbHQRiYlFl8tt+4FZKCkZbEJ9fQU628VN+ZsqvowHxawt8GRTcL/YZrKNyIIqfNTPpzTLwaT7gm5XPRD81G7gqB80Q7d9aJf0Po8EsaJSI62A3yUzR3QIJ8bFoJX896LUXUc4SlFTIRXbtQOBNtzZGx9GRczvYbO2dotLiLnwsKf
 IGvnL/JI
 PnOsRhx329sdY9jga70lK0ddA3/HwFzqiOfaDMJJ9jX65fMItLLDl3PAxNwxc5qzp/AQgb6G11LJTuKmQzNR9xGXd6XFWUDZiZBMMaELY5qb9l77kxA1CDhynPzGveWOTIwKxHYWlRq7v/w5CauVp9V2RPWLwjvuDNAXx74ijFGPiaEjX59JT/PlfFQ/MVjOl2yV1V4NQlYA6Ud1xNgR6G976iCMHwPWeZ0SKysw+crvUig3zNE7nkw4Q3AlJVt7e0ncUfuU77VuKnm5vso/FoKuJXcIWi1AxnGUK+oGsJW96j78IVLDH4LqT0Q==
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
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 113 ++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 618c937f3c90..7612819e340a 100644
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
2.51.0


