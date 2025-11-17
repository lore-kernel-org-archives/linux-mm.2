Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00352CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 11:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60BE48E002D; Mon, 17 Nov 2025 06:47:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3B58E0003; Mon, 17 Nov 2025 06:47:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FA068E002D; Mon, 17 Nov 2025 06:47:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 39AAF8E0003
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:47:05 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D33745D494
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:47:04 +0000 (UTC)
X-FDA: 84119922768.28.CB7E2BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 28DD280017
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:47:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O8UX5FJS;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763380023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+rvu5ERu2ShmTxZU6KDsFQ75CH/dfzj/xM1wZSCf7TE=;
	b=dP7vKehpFtXVryKA28gKL7zk5n5ajg5G6/EgBdaa+85HjEID5c+Ca7JbZjBvak2UM8O+rI
	/3WUkIzjSVPqgM0OwJnYG3dSVKcWFnqBc4tGIazNimBtqqi3ez7mGIY4xHC11sPnTXf2Q+
	1QRS0xeo6QedrkJPV3oSzoKekUY/edY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O8UX5FJS;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763380023; a=rsa-sha256;
	cv=none;
	b=i44SV3heUOocTSk02G8wkWor55AqaZ+iN2ARsTUcZQEYtK7Yt4GLdEAL0B8BKxn5pdfLMy
	0iO0HYN9u9C9W8z7VXIFiaxNFhFeR2HRIYiE21s3NMzRqdAxsOocXHVEFCmL7wa2E2JSX2
	3jeaNSp0jQGZG1rzVD1IgQ63b6H+IVE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E936601DF;
	Mon, 17 Nov 2025 11:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577AAC19422;
	Mon, 17 Nov 2025 11:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763380022;
	bh=h8iM1V294GwM0YHrw7ozBTpi1JGWrn7/s48f8890vrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8UX5FJSiJdTcEG3REy6V2AlgMJBt/IhL1oU13rvGS33McOro6n6HxI5fPuED4ish
	 oKifpoVHZqjpslWPfFkDjy7lEhoGIaxJH+ISoMj5BXrmIholFoh90nkhJH3MM5KHQf
	 U0sscO5fqNeipAtqlAo1LD8nR8HP9lZxPPHKzGq7bEOSJbYWed5/oX/nMx+2uaXxZ+
	 tzZD/Mj+BCJI/TWAhGducVtENC2khabGoX0n8KwcJC4uPIMefzan9oOHbCZmco4NZe
	 C30j6WwCnorBwFe/v0Xp3FDKxjgLLoRp75g5pQ14GEN4Yze1XA/A9POTLDwtPpSqyo
	 e1ginZR0p/nbA==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
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
Subject: [RFC PATCH 4/4] KVM: selftests: test userfaultfd minor for guest_memfd
Date: Mon, 17 Nov 2025 13:46:31 +0200
Message-ID: <20251117114631.2029447-5-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251117114631.2029447-1-rppt@kernel.org>
References: <20251117114631.2029447-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 28DD280017
X-Stat-Signature: x44tucxehm7h1bbitdsoq7c3ax31omth
X-Rspam-User: 
X-HE-Tag: 1763380022-419497
X-HE-Meta: U2FsdGVkX194LXJrgubUivWtbcowOU70W6jea0kedIuhGRLox1Rhnt6nLBkl6yvrN94bmPER9GfYc+kYJ2CbtI6s9zwyBkcf3Dt754g7ZwIdG25Hynm0R4uUwa0sExwbfxFfgh4UB9HKNagdhLySqHQI23BL7xIt8GnSEzRuBZS0shahmRPFCYBgQIbDNZ5DLY4W+H5eUSU78/+R3E/FeExAfGQCVfJ1BL6ZcPsWvxfxBwzFwMTIakUfToEhUoiGfV07o3NXst0pYSVr03DBiWsEOiTA0N11xmo0DJYgrQNiZZu0MwcupJhW5tbjliJ/kcujnaNqMvN49Cn2SegBu1yWv8i3UFIZmfcdJJmQfrSTPnb13Q2ewRBYFvfipkWRUvTo0WgrvOypYRr+41+ks51MBK5sMtT9r1tHu9A8ZIUUczrR6CUGFv1K9rixquK1ZgZx4AKZCjnQmRoo8ValSKW4TuIPbx4lF1MSQ6Zxb+LLUhmmlQ/2hfaE9wbX6m+D+N75dN77qJJ4W5uVzxqHbRtL8d1AnBaQSw3ndRTTMqHcimPcPQ7Fo84ubHVm/KKQ/BgSR3ThylUJ6nJUAfViXZTN5zuGGg4Gvr+geJNSfUQWL1Eyo3TDUOou75xUrcX+L6V2lmWA/dLYmYhx/VwZ3oRD2Gxq9lfA3MviKVqfgkD/4ecprWAQXwKaQWwNU/SEuRybv937CRU7y8Iv/JECEhWDeickKVBTTDjnF7/jGkT1lVfFGaUVZQd/87sn8EBrLpHi2pgKqp1FXw4osfHSLsTIIYH3U2G3g/AdgtDjM8+9850YXcZLl/zLPg78KxBmYf6ZdbCugGXCexYnA6m9gBbrTuM0iSxyJhk0E+tWl5M7NfQkFp7bgTn6g3timJlYDLEks0AyFGiVLkik69kuvYavO5jSqXO6tDJoy4XCrEwSHH5+yXi9XUzapLWvW1ln4gHIOP6SJo53JydHbx4
 6DKp8kA5
 Q8GJM+bDg6594kRdpLLfvHBgBhtD8owaRY2u7MkKc5W3lxKN+sX2jqz4CRZk2yCZ4RZ7iwffPhCDJ/FeFui3h+8s0R/9NW3/O5ZQ7cjFqeOC7DoOuLV/0mJd+mfaGNttMjBbJFCkJCH6iM3kqmhwW34A73goalspASXyNxSClc/z8oNTfocN2ZGpQ6PEtOQWbpizUaCOqaJp3XtLDrLkSxMk19Iq/0TvdOjvAFOdy/zCLq8dSGJtMi9KNtTNDybQtYYLP+JyzrzKaFZuXnrR0k9cZRRAcXNDYwFwXoel+0ljLfYs=
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


