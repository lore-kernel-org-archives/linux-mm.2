Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DBB8D2FED2
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 19:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 147316B00B1; Tue, 27 Jan 2026 14:31:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11BA76B00B3; Tue, 27 Jan 2026 14:31:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03B626B00B4; Tue, 27 Jan 2026 14:31:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E40CB6B00B1
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:31:36 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BAECDB8112
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:31:36 +0000 (UTC)
X-FDA: 84378738192.15.1A2D859
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 21427C0008
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:31:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ER3jWOY0;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769542295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=05NB81Meuh1dfNJFxaWgydluxjBcp09+AdpLalqQry8=;
	b=WaIeUgu4cFbOdaQy9yzsYgMHZNcwqSaLtZcb6Sm6BuS+Sl9HDoty4hNSFE9nzMN0HTV0Jp
	wVlezstZGkM6C1AcQqI9bdZXG2KqY1FmJPRtw1fKBWGNWEUDAkMeKTpRywkK9wg+eXoihx
	1nMg2uLCeciAcgutDU4DrmWk4PBykec=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ER3jWOY0;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769542295; a=rsa-sha256;
	cv=none;
	b=s0CVM4D+aQKeGXbrEkUXwaYXNRG8zcsHIk/iAmewp8iMsuFNXBWxsWjvwipCWjZrdQ2hAn
	JMIXrs1t81lLajrDbottWOUvt8HKYDfwJ4lMxAuT/zn1cQ4kEa4lynsDIZcM08OmQK1q+R
	FzeHQUCH/AJvZ4QkH5NRRLaMvk81jSs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 919D2601FF;
	Tue, 27 Jan 2026 19:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773CEC19425;
	Tue, 27 Jan 2026 19:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542294;
	bh=Z7I33Hc39huXt1KMAEv+ORYc+prBLTGLG9GW3dkBprM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ER3jWOY07iJPn8qyjNDfRFyRgYxyWuJjiSMp41SKhB+56SWGzeoPq6P1kW90+cWm2
	 QTgYAemvCk1w7t5MUfY/l0AkuHfpYBmxwUxPvAWGQI5l5EHWj6aTOFV/Mchq0bEU1C
	 GOG2+qDG6uH2kXDzBlf4UO9UjRz8htNgAuMPwMN0aahfUJeQTxTlfEXYNXD30QDooW
	 GIQamzOkF/J2WRu+6WATk/bFSXVaEhzYGRMmf6YewptxAR1UuZgiZRX7f8snoWqCcS
	 hqMRCqk877/SG5QpuI75iQgPpzMJR/b+46TGplSy9dBIwKC6NM543/hW0GLCkk9KJW
	 IoFmt7fkcyLwQ==
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
Subject: [PATCH RFC 17/17] KVM: selftests: test userfaultfd missing for guest_memfd
Date: Tue, 27 Jan 2026 21:29:36 +0200
Message-ID: <20260127192936.1250096-18-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127192936.1250096-1-rppt@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: eo5mce1911yrjn1tp88mp7jnmu693j8z
X-Rspamd-Queue-Id: 21427C0008
X-Rspam-User: 
X-HE-Tag: 1769542294-404424
X-HE-Meta: U2FsdGVkX1+7euGw+VdwIwqmszMnjoAENI2fxnfB4RoXxguULzBbvm8ULd1MDg/CBb3hPN+evhdOK1DzFCM7Ufk7PSjSUiC9gQMKomsN2qjqvovpWvNRnlpI+BxgqboANI/UI88+HA1kovRCEcEavbsNn8a5WOmGhfCa6AEd6Wg0zucHuS19AcHhbmP3R7a5Q6nINyM59Z7axC2/9b1uUbgS1MhbfjC7vG6q6nBL7NPgrQ0mS9vsxVFjoJi1ondpszHFAJWl8RlSAdHxYVC1N4c5kLoVE2LPdIYCGQhcO3MBiMQ+v0sj6BlqvG0nHhSMWRn0SI01IF8JsMsNYo5X+8orvLuXBMmd1/O80Ie9tkOnd5hghJIRzhaFEuxt0rRiHXvyNuG2msPiyaCjQ4vjRp7mJoRMusjtxj9Y4Xh3ZKxvnR58kyyVPyY8BiqFW+0NjUzsjG50Os3qFgyfdjrTfF/KGcWN9DuWjkBvfbR+XyGcpZmo/ikXp/FSExJqU+NpC/Ds9jcu3ivDLseq5C5KJ9Wv2dhNn0gGMNCh8WLcJj+/HNvKNbxdsrZIJ7KETlXEifjCIcbH4XatZxw9u30Nsrr9jhN9iXn+PaB6hSiAWcf7gCkEeKD91n7G2Hsg92fH5i8WxXYfq7itoPK+Be4AZHFXFPZkfoa3QvMzlTEsHUrx8wNWj5DLCW3mMdTxUJI32db5lfRT7kMYpTxwVawTSN7NJpm9ZdFFn51rO6oJfJVoko5mvJ85/Kr6IWH0cyExKYEJqXFr4gIzDWqyPraMBD9fMszcV3MobEUmiCVxoGKnlWunlYoJDO3yJlAlBSQwHNdTEGqotMOnW2SFS/gjOMIqCxsD++glIp4zERUWfS9P46Ogp8/f/+KkA2H0NKl4bugxsFi+GhxW6PRAUoQYgafTshCpahfqta0SmnE/WkwbDUiD8zU0lqh1u86Bsatya6goEk1IQOJUadRSle9
 eeX95fqk
 cjYKFOr1bwgOlJQnCmB2NfSlif2wiTiFKGQ5G6OpU1HczjhPJo6r0CKj/Ri4tGZ/f1G6IEpc0kCgyhGoggrr3h6DbTIK9aNM5nXjsHg4xNBMJre9LARpLI9TKWH09Rhh+O3PrEIiDJQu/v65yHCbneaVX6E3HxJUTxHfht6SK1Cqewcpo8doKhzMIUwgEKlMC9/Y8o9fw75fdF5RriZWvpmHsdJdzwkeI3N7yHNh64f7HgCoeHsMq7Ikg/MKv9ApmbLHWg3ulN4d1uAo1D68i8nADHGf9TKMSHkMX+UoPYoBfxIQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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


