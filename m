Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1662FCC048
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 17:20:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68C4E6B00C3; Fri,  6 Mar 2026 12:20:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64D626B00C5; Fri,  6 Mar 2026 12:20:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5459E6B00C6; Fri,  6 Mar 2026 12:20:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4288D6B00C3
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:20:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 013CFBA5AD
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:20:01 +0000 (UTC)
X-FDA: 84516301002.12.A10A851
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6D6481C0007
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:20:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iZZ0Q6Nw;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772817600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=05NB81Meuh1dfNJFxaWgydluxjBcp09+AdpLalqQry8=;
	b=FCqZ1CiDWmRAaDGq6FQPPpCh6Omnw9SeyDCX80euaqSUhe3xDyoOKvyar/dMSy80rm6Vbo
	Drku3vmAZYZpkxMZ801iQjyy/j0WzMiKQu8/mWG7dw/Qw8hWmvBBnx+Foo6obg9Yz2mCfi
	Wkj6jpJMt3baH1Ag53AVJQ33bSQI27I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772817600; a=rsa-sha256;
	cv=none;
	b=7zdUz5kribhtsH/pe0cSVvCo4xl8VW9CwvRvFBKsAvJKrPcavctdlrYYQemsKvrL7tS06p
	Lj7HKqWHDLrS5GMq255Iywwk9L22KgUU7N0MeoBQ1Rq5fVjwqpopI3RlfJltkFPQvZqTDQ
	WnolH5nW9+OG6NRzY10voBtzFuC+ZWg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iZZ0Q6Nw;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B392A600C4;
	Fri,  6 Mar 2026 17:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32FFC4CEF7;
	Fri,  6 Mar 2026 17:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817599;
	bh=Z7I33Hc39huXt1KMAEv+ORYc+prBLTGLG9GW3dkBprM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZZ0Q6Nw7qv8CZFI8d6UDYrNmF2nArSoJtfi8sTKMVKcWDMEZ2CzlTcMMQotCE6b4
	 MX6mwVM7CSMLPJCKNKdtoq0nkReIXP03U0fItKcDOTRPUeWebXfX+XB1QQEgDuzK04
	 iYe5hcXhXLkQzsbUWB1NFnTIC/zhdAbJnwW1bmUVnpMm4R00qo1KqUk8M7TL2UFH4i
	 CGoCw7ESWEQqmw3VAU2CDYMYkJ/YE1eAcF+AqRHOu/UhwmG+seBFyAise1vqWymY/d
	 73xnZkSefWceJsy9JxFeppk9VUqWAAjQVDEM17tjasvdY1WljUaB5D328CFTNJCqog
	 QXRtrM4L6gaBw==
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
Subject: [PATCH v2 15/15] KVM: selftests: test userfaultfd missing for guest_memfd
Date: Fri,  6 Mar 2026 19:18:15 +0200
Message-ID: <20260306171815.3160826-16-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260306171815.3160826-1-rppt@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x4z7mmnrkg9qc6fkkpan33f9wnh1jxbu
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D6481C0007
X-Rspamd-Server: rspam12
X-HE-Tag: 1772817600-790158
X-HE-Meta: U2FsdGVkX1+iK2joGiSx0cS47nTrBDkpm0r2hs3DTFHJ3MDikPJO9+2zRmweGFE180H0uZFFpm3Fl48qut7dquPX5RfT73W9fuXFwdfUaZ/Oei8rtQeioTZsrn6jEOVhk9zg5FyEW8+15VmMNIE6L8NKu4qYPFinqt7QyyRxHRpaBc/MQLut78Wd3zGxDy27zRuTDLQb0h2R6ooj+nQfHZPJeBq9zdk/3DvXhqZpWgf2kmbMlEggy4/3gfY4hwBohKce+Xr4sjkkrYZGvYaztL3Auz4G5tL8BOPIunxv0nbKVjlUQq2DWNARCrXnLnOA/FG2upPwDCcveCCn6auX0CsVpot74MHQwU0lduXvwhiUKwW/3CuF9UwPGRn3rW905csu0HmyNsOoNmDApQ91BKoWlgU9Q35vZ3URV7hkKYfe0zty2enYCYNC58T41diMef6J/m5lkrQFixrCARN9asMvtcEeJlzJVXVJZU/YBuD6YkL643qywDHqF+xoSfK7qCdRtfbviLvsziaAAEJeOHh2x5FK/trPMDuSH4BZOGDNnDnV9ajlBUXsltQt5k4lqT8BZ0gUXc2IgQGMDzVnkfmhQDrvvEzCb0YwlwQhmS4CfsJsMoSNk+g5McGKM2iaUrQ3oIkd/nV1LWSTIzvvqQn8fYjIkIkO1hnhfnXF9e3RhKGMpXj8q3upcIDxvahLmdsxvWaoVXe1kpCJntIQeJEVBZ6/pr7Q/2I1mIFwmen7mnVxaJHy/b3esuEmJ8SGzY057++yZq9RWwi6gdjkgxx001U+kEW7KFDWUQ2i5kWKhGZFoPoVRRkOGcsP/lgQ+A0p6US3+O8xakU0Ll93Rmr6N+0knL17dFOObhZTWLpi+vtmkCJx5Q3E2sG6H6lexf9dhmA3w35EEt1mbAjbojcm/pstRRUtQLJ9dSOrlP7z7022Hc0bnMD8YzA1lUwhRCEoKA8aDJSJfe/pM2R
 D2zeTwUz
 zroXQmOmLYVK41/M1K2uStLGkMR4eTsJD53JeCEgw6F0SYAySPWhyi5HpY6IUvjypkdTnVzVQpQw08OVBtd1I3MV5NTXGN6h3OpggKeDjqcSob2wrnCkOB5eHL+HVHBQ4c3eWj4JXZyEzmNu6KCDEC7dHQgUcw6f186j7E7juwsFVA5WSfs3oInK2HXVuK9g4vrGg6PPfWprA4TMTdg7xBFAj4/0AGxsm6A86dO35ZBRaYeBuPPiPww5rLGjerra7zqCsEa1vZBE1uyUzVghu7/DZi5TCcTvInFejtscwR7hhY53StwTI67NAtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <kalyazin@amazon.com>

The test demonstrates that a missing userfaultfd event in guest_memfd
can be resolved via a UFFDIO_COPY ioctl.

Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 80 ++++++++++++++++++-
 1 file changed, 79 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 7612819e340a..f77e70d22175 100644
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
2.51.0


