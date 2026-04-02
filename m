Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F381CC6B01
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF8D16B00AD; Thu,  2 Apr 2026 00:13:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD0F46B00AF; Thu,  2 Apr 2026 00:13:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0D726B00B0; Thu,  2 Apr 2026 00:13:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A37B46B00AD
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:13:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4468D58A9C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:13:51 +0000 (UTC)
X-FDA: 84612297462.25.4FF69C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 875CD20007
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:13:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J3swZE2Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775103229; a=rsa-sha256;
	cv=none;
	b=agQWnymEECcyhdZv/qr1KZIchtjz5oxvN98RdDe3IVmx5yyVyRHat840lPHfUrigk9kV0O
	hZMgW35dJFsQzPa+30r1U9edTfcYjYmzkYmQgLHLqp9eEjDKDdFVZ7JSTW434ksfDzEi/R
	cPsJwYLVtjIjFBQL2OtLixA7aB5Il9A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J3swZE2Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775103229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awGkkm2OWaLy5ex/oeihGcD8JB0EhmX9CKfQ3dh92HI=;
	b=5dFouzX8X+Qj7/vlRKI4doVtKoE6SfEWLQ5vMN0W8507FIh5hsvykvxAxKvDPOTj4pdG6N
	QJ+pzRBkuyv8YMyRO5cKNgHr71Pm9GGxV7yhUYq4MeQl8oqJWnH6GIi+dw4WfRaD78Kjup
	R/uShdNXvTlwjddqS8xysnkr7WAMv3M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 96FBD43DF9;
	Thu,  2 Apr 2026 04:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37256C19423;
	Thu,  2 Apr 2026 04:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775103228;
	bh=z+HQ68nm/PN2NlXH0rkdfjkI55JODdIviAntTrnHsgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3swZE2YyH+2pVU1N5DjDD0TDSZ1KNCz6a4Nu7f6LjmQzi0SwxCUvgzT5USIMVc9X
	 BgSZs0ognCJH2fM7GMkGPxOQ6ozAUdeZZOM4Im2vQOWQp5udB+LyEss9fBrJeZ2+N+
	 kvzlxOjYOJh/UAmNuJMoF02Gu4ey/B6DEVvfzWqpsdPBjIRBEIu09fEE7Zt7xmtiEA
	 olaAmOrM1jgq5/OIe3GLLQ6FIS4cqOgT+KTV8MOy09Wi0YfV6WVZvX52QkSC6tNn3+
	 PEObeLaOxTOGniECbLzDzzPSmCul9xI4ymX3Aacbun+ZL5oyTFkO+T9imVEdL+WUZh
	 BToHP/KPtvuyQ==
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
Subject: [PATCH v4 15/15] KVM: selftests: test userfaultfd missing for guest_memfd
Date: Thu,  2 Apr 2026 07:11:56 +0300
Message-ID: <20260402041156.1377214-16-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402041156.1377214-1-rppt@kernel.org>
References: <20260402041156.1377214-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sba8a5idixd9ud6wd95zbqirkpw4wsrb
X-Rspamd-Queue-Id: 875CD20007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775103229-135893
X-HE-Meta: U2FsdGVkX18af0AlBsb0YiN7CJBnpG+dlzdG2wcIF58x1IipIJ1TdwnHCRlWC20/MILcjh8KCL75L2c/9r83d7kKP5hw/JUmkRieyGYxtCKvjd9iEmOIuXcXMbKQsyXJiMK88zjaRDh404KTNKdCFwT5r/ZUM9kzROS00IfjL6JSaIStidIvCnXwvGHQDldT9nUdRyX1uuh2fTMpwKVWnYxnmAkOi5Hv7jTQwD19vrVoSwQH3DFXUpJgyernWZhrYo0du0QT0U4fBYTs2rCW1qx2b+lZH4jRkG9zGqYmSL2CIQe4H0iPXzG0K/CKHhZK7pfF3hgboiQNRgA8xeleHfqkT1LgIVNFjDBeGbc/WPRocgVT8OKyTZ6c2n97E8b9JBCgr79bLFtgch+ezEXmK89I2wr8ZrBb7+loPuWuMEKwgLBS/ZnjBtftuvsuFZpJqFe9w9PUi4kO95R7SweavkWPCXHsZmxWAfdsaxt4IgJOdW6m2v7pnliteo4JS4CXQxBL9xtEWcjGXNK9At83ex97SUxg0Pr4WhLZ49M26h5kyGtc5Sbxt9/Gss7CbgxgvlPVegJlxO7MZx1bNyF+6cIsocDlS4kcq71CAoiHCgf1Mpt+1EXxulGrXVJiUhBWbo8nrSrrcIteXE15C0FmYHBm5Aym5gECcaNy0G1YUvhrTeQ8CFabjmMj2h0dnEcRK6+JE2iP3rcOAJcveOf/4aF4SLaiSI320T5ii5A3rT9fwn1sZ60f9Yiv5vTt+c1hw8cTUrZpYGJybi6gopu1YrzXSuX4VOP8CXCcggjB8G/yux5GBxS/oGcjmgPwSswKLBsjbUT73BJL2iTumBcnzIFhnRuO+M0FG0zDF8+tku1ER6PTkGP/2nhSgDIQWg/EXEij9cxbG0jQ4CpsFisGEoebPw6SIDG0ywilrqsZ5hqD1Xh893egMgXxeEwCqRC+7iqMRS8CvgjJjw0JusG
 8cPFSvnF
 Z/qiIvzqQy9r2/A0AgJcGKjXQaijens59fuOSVVmvgafvsWeiHEYQXELILfPE05rc16CA77mRPCE2U69EmBBeDaqSlIWl6FUQ9dFpP3lBLL/sCQ/uXbXuKvnhgtHJ3t3vsxtAYeQ+LJ2BNcZFl3Xk2Kp2t9xVeaowxRSZ+z33wOAZ5fRIItaO8wsrY/tGa/3TS2cNSzStEyDRVD09PjwFDrddRfgMz0IRsFWRWTmMt69RgFtUQcX7cDe2jBFd2oiYSySUnkXTg7bzPksTVdgLTR+G0BBUGBATdQKO9h0XkOruW3zUNtZsxTI0Ow==
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


