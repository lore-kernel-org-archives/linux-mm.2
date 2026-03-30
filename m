Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2666FB3CF7
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:13:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E88096B00B3; Mon, 30 Mar 2026 06:13:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38BE6B00B5; Mon, 30 Mar 2026 06:13:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D27616B00B6; Mon, 30 Mar 2026 06:13:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BEA9A6B00B3
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:13:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7CDA75AF8D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:13:10 +0000 (UTC)
X-FDA: 84602316540.04.31B8596
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id D8E99100015
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:13:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qd78A1P9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774865589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awGkkm2OWaLy5ex/oeihGcD8JB0EhmX9CKfQ3dh92HI=;
	b=V0OkJPWvBFwor1CWzrS/CvpezSOxPkD/QwJpFFgH8nO5ej7VzqERvhFnKTMYNl0rvznTBB
	xR46PRGTpcut5MvUgLPe/9i+SonRsunghpib+hfFnzofVSCDQOHnfeOCQjHsI7qtu9dvvi
	1e/7T1lCdT2gbv+YywKKMie9xj6LMOY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774865589; a=rsa-sha256;
	cv=none;
	b=rIAz4mHFUZxnJN9baWvdJ3jvDrihhoDC05rSQlwVZt3BDwyyyW7J3z4wBdlVj4enpYynMR
	D9xA0KiKthFYy/va2FXNL1j4/j2SL1g7oaY15jEfYjwW30e9SrqMHyrfPkNc6CVTF9qxBg
	vNGqtMkP8BsD5mLXTvQ5oEoyqUV5BEw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qd78A1P9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F07314187B;
	Mon, 30 Mar 2026 10:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A609C4CEF7;
	Mon, 30 Mar 2026 10:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774865587;
	bh=z+HQ68nm/PN2NlXH0rkdfjkI55JODdIviAntTrnHsgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qd78A1P9UWhpE5pfNF5/si0YUJqDBpx6QABMZxnbsGfRv1tputO1o/Fj0hI6yR2fH
	 FvsnZ3AoBWYzWJ6RcLz9fOYYD1ih9BqPFODUF8l6Vh3PzjLcOB5dH2WtsPAsSXEgpG
	 2+ChD4WcGvre9pwNNmv+CFQ0efph6oYKrdKUJ93AefdcAxed2DAnXngn0RfTKB/hzH
	 PLKhreYyx3SRJHaKu3Ob1dWqrvWyNNiReXe6WM02HJLPe3DzUBff3z58LQnwRvWy4I
	 JHLJmjIAFYy7zsrRy7Gj+f+bVK9sOlM4R0u+cgTVjfLpeclDzbfvWJeXXyhPaDh+NF
	 fuwMYcrpMklmQ==
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
Subject: [PATCH v3 15/15] KVM: selftests: test userfaultfd missing for guest_memfd
Date: Mon, 30 Mar 2026 13:11:16 +0300
Message-ID: <20260330101116.1117699-16-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330101116.1117699-1-rppt@kernel.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D8E99100015
X-Stat-Signature: 1uo1a989a71rq8m3wog555xnxk1ma4qg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774865588-8517
X-HE-Meta: U2FsdGVkX1/1oCYZ81rkL+XO++xBWl1/6fMBWUUaxbfFneGkLae/9mtd5v38h3CJAkgp+e2qeTGg5eesbZfTddAzbu2axeNn4f6Baydo180c0uxU73SZ7FcqjyNs8X4Jt+iZ0vAYAumqn+CpfiyGZJdoLJ7fZgoe+E/ylE0CbS1aBG5rPvu71fvAsW3Sdx0PtRwo0vteRpADD5YWeqtszZjzSszPf38i4UwVI2DxxPpmRnoAhzwXjQCg0HqarxopvgxiokS27kwtYsjaUD/ezQ0POxgVuksgFrt9CJR9gUSGa+Lp2SnMMKXCetCxhlBzL4SsQX2xs6IQ6vqzOtVVUCTIIFbjxEak9Og8tlzOlO9HrFPTlyYN4fXkzJKteBEoMUi2FFXmIHTQ0Uo1r95XNIIV36gqB8F57omyDRUv7X954mMkMDRXzUUoiDQaxxwKVMs66N51gx7dXFZFtyQygXo6s0Zg8D++mJBSaypdBEYJJqXEBuy1R43EmUcaP2xFWrgWS3Wm7kN5H2A5CU4AVxE2ycFda+4RZ+lobddMsiAwdXE56K+qUwPrA0tzE9BwQuGosXOBz6VHMnyaq/txVc/0uakip9iMhEXPWb4wC5phuTQDmPRrnZZ4Gs6HhHLt61iTlogGQ+stz6FFx2ki801escGSI88qW00HbuH0atCZxibzpraWmFp2h+Ozjck1p7Ghp3RB2R+Hxq4nAF+kjt9MGEsyH5vbG/jRk6yuU05HNazFq+GMm6LgiR505TiphHEAD3+Kn07Bcsy03lwo2SkRO4QmTs522uy0a8RaVKwFn21DAV8MWCYoPLKllC35haKRadGoJ4UNfgHaWFyN+JI7saEO5zR/NhhklhNmkzbae4gKrP9uv3gLOoqMHSggBpuYUsL5Vwe8iemLT++jH5vZ0JGCf1tgOgqbdfS2BQc/3G9OJVJuSo+Dt+Tnd0D206b2F1gXZLklG3J9o02
 fvNCjnqQ
 k9KLXBBDdtPAiahw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <kalyazin@amazon.com>

The test demonstrates that a missing userfaultfd event in guest_memfd can
be resolved via a UFFDIO_COPY ioctl.

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 80 ++++++++++++++++++-
 1 file changed, 79 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 29f8d686c09f..eb29ee5d2991 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -439,6 +439,82 @@ static void test_uffd_minor(int fd, size_t total_size)
 	close(uffd);
 }
 
+static void test_uffd_missing(int fd, size_t total_size)
+{
+	struct uffdio_register uffd_reg;
+	struct uffdio_copy uffd_copy;
+	struct uffd_msg msg;
+	struct fault_args args;
+	pthread_t fault_thread;
+	void *mem, *buf = NULL;
+	int uffd, ret;
+	off_t offset = page_size;
+	void *fault_addr;
+	const char test_val = 0xab;
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
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap should succeed");
+
+	uffd_reg.range.start = (unsigned long)mem;
+	uffd_reg.range.len = total_size;
+	uffd_reg.mode = UFFDIO_REGISTER_MODE_MISSING;
+	ret = ioctl(uffd, UFFDIO_REGISTER, &uffd_reg);
+	TEST_ASSERT(ret != -1, "ioctl(UFFDIO_REGISTER) should succeed");
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
+	TEST_ASSERT(!(msg.arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_WP),
+		    "pagefault should not be write-protect");
+
+	uffd_copy.dst = (unsigned long)fault_addr;
+	uffd_copy.src = (unsigned long)(buf + offset);
+	uffd_copy.len = page_size;
+	uffd_copy.mode = 0;
+	ret = ioctl(uffd, UFFDIO_COPY, &uffd_copy);
+	TEST_ASSERT(ret != -1, "ioctl(UFFDIO_COPY) should succeed");
+
+	/* Wait for the faulting thread to complete - this provides the memory barrier */
+	ret = pthread_join(fault_thread, NULL);
+	TEST_ASSERT(ret == 0, "pthread_join should succeed");
+
+	/*
+	 * Now it's safe to check args.value - the thread has completed
+	 * and memory is synchronized
+	 */
+	TEST_ASSERT(args.value == test_val,
+		    "memory should contain the value that was copied");
+	TEST_ASSERT(*(char *)(mem + offset) == test_val,
+		    "no further fault is expected");
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
@@ -494,8 +570,10 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 	gmem_test(fallocate, vm, flags);
 	gmem_test(invalid_punch_hole, vm, flags);
 
-	if (flags & GUEST_MEMFD_FLAG_INIT_SHARED)
+	if (flags & GUEST_MEMFD_FLAG_INIT_SHARED) {
 		gmem_test(uffd_minor, vm, flags);
+		gmem_test(uffd_missing, vm, flags);
+	}
 }
 
 static void test_guest_memfd(unsigned long vm_type)
-- 
2.53.0


