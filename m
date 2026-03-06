Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E09C3FCC048
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 17:19:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 571446B00C1; Fri,  6 Mar 2026 12:19:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 548906B00C3; Fri,  6 Mar 2026 12:19:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46BA76B00C4; Fri,  6 Mar 2026 12:19:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 385916B00C1
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:19:56 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA3D31B8586
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:19:55 +0000 (UTC)
X-FDA: 84516300750.12.5DBB288
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2729512000F
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:19:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aQTtLBYR;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772817594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gEwaujY6J6vCjiupHvoj6lNk/LN3RzPL4/YsvQ2ZPZI=;
	b=vG77vOVmz3jtmdWP1be0g0OgGA5YA86CU2gmR4or8V9Q8JD2o8T7oPoAAZfl++tTfQFKP+
	0C9Vt7eRo7OU2evsr+nazKaYqI4y8tVyRq7UvnmoTDKUXKOHR4hBa8MZHOEgy/wW5VEbLw
	iJFbR/g1Po5PBIKFfe6Mqsxc6iwyAgQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772817594; a=rsa-sha256;
	cv=none;
	b=5ZPX8gxjQzvACYb6vkwk1iFpiHrjap1QwU+gz9OKxIVbmF76w75ZSnEG+s/8ytshIkMHcR
	S6xg9CpanWQSpIEfeC2O0rc0RZN7qEq5kualM6RqIP93aewEviCmoCZmCSSYQL1k46Z8MN
	ckgPZnpoNl5oMD2xug0tMtBnumoOXGI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aQTtLBYR;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 58F29431C1;
	Fri,  6 Mar 2026 17:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B84C4CEF7;
	Fri,  6 Mar 2026 17:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817593;
	bh=rG3XSy87LBPK/+pmM3kvRr3VcKC4P6b5lnQZUhRBOEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQTtLBYR95i7Q8TFnUCiIF8jCCW6/JH7ZjPzkpbShkuu5ynxIjeTeuWt/K5arUiW3
	 aQeLzok6f+/Clt1krj3fnjwj0KIR21YxhDl/HMvKsstnNdG5+uRBbfL/vFplDbswjt
	 WShH259MkmoV93LTbS+f534uaac/2b/NVVMZ2hXgSCeuAAgfyWYNAZcV93lZDm6B0M
	 QMZlgXYHXcfmK6o9YjXQTeGJ4JIWacUvDajooh1tmAzXblpAitjJWKeVh0V1wzb0e6
	 gNJrXdXhsYYSQGImHjXXQuANbqOoUksRgBeW75euaCvbhHiUm1puXH+iD5Iy126ef8
	 ptgjjMnJomHPw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
Subject: [PATCH v2 14/15] KVM: selftests: test userfaultfd minor for guest_memfd
Date: Fri,  6 Mar 2026 19:18:14 +0200
Message-ID: <20260306171815.3160826-15-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260306171815.3160826-1-rppt@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ufoh395yconqomhseig15kbr7tfd1cjj
X-Rspamd-Queue-Id: 2729512000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1772817593-876598
X-HE-Meta: U2FsdGVkX1+PnqMuRamKYNrsg9pSu9q+9f6dlcSYjkBxyhNz2aPw/W8DezLQfHA/mRODBXi1r5LzqxhdV7f+/WnZ0nEYqkjxjECQVjp31fbYwFPS04WWlt+hgHLSD6SLq56GLxIAkpdRDA/YltfFFql87AO/dfLAbMGe7bU995jiMm0SH1vDDi3viz1eCJQiPv1QKwbS01tQrIsTQbfuMdml/glJ36tqzDHVO00Y1KoiHOVK8p7a98fJeea0kEKQkjmqEegY238HVbv7dTsCsRD5Hfu802ZPPpH80kOZNS0W40Vx7lxEi53Zx9X3OQXW1T1iEHEkwE7AaYbd2djqTdonMgkUA2Eq7FqGLnw1PhGV+uEtC5r6VsbW+AWwftlCNVO8zATvhwsSmlglpzVu1pTe5bADHZQGkwaGr7WaLbg1HMb7P0TCfI2nyioTtZai+j2Uf1v77nHDQswCIqkN5NUb2HziR3WI87UI30HKv+7AryC3Rz5sUMUX5Ms8PLD0vlNONLA7j96Ah3mBwlL77hoYY0jSrFI08OA7ZbN8wDlidKoO/M+tcm+Pa/XL6iomibm6QCFsTZNxRxueCQ4DxYzZrHzHRsyNzAeObZalAi7eewUJOa2/uxt3dtXcQ1XQUur2m7ufUvk1Anisx/LDHmMOEfcPXTWKQP0EVDW5OStplgUDEl6BsedWGwCd1CshjG6QjLmXEdtXRubhIT4GReFmJpCsP4/tMWJ9gAc+P17l4Ag6Z9tuxf+NLIbaZPRxespUjyGQaK9Fn5tTo1PugdULUAippjLj8tBY0k8qcchH0X6P2tyPbaZooMLy/emDFb+RhKfm3K/W6KWnqAJS7lEZ1Q/7/lZwk2xJ9z+ToM4wkdc9a2XeCBd3kw2Tb/26j9iQGzHgFfmWkNUbzqVt+gDx6I/wwHpQQAa39KOhLNV7oKqNvxzMxNyk8bpq6aELvilJM3Ol4+K+wEBgIgP
 w0Nz5d4k
 nbDctdBefqSweSTk7sDxWqggGvxYac2f0nVzIpyziwXZMMmfE4Bdcy6jpfhERmLiCj6BBGO5jvU0U7y/9IH1imToguj4It7I+EkZeOsuncVfuNi+EzpEiZZkXeSjD9GY+QivdRkfpfpwxToFwG8d3aRYFu/KyatvCLbq/ZOhDV3BP4sgKslNe7epMeGBL6Vbevp4lqWZ5m3BANcAKyKMN6p6KrBy+arRVrnAOfCdJDwj+u6Q9FQ2IGO5o5/h3hwwqCrEE5WhneLq/lHb49onMLIxvlBK+feXCVyH3lcXKM67sVwiZKszGtpkU4A==
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


