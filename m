Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D081CD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6302E6B00C2; Thu, 18 Jun 2026 20:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592336B00C6; Thu, 18 Jun 2026 20:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4347D6B00C5; Thu, 18 Jun 2026 20:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 025246B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 78DE71C1A52
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:13 +0000 (UTC)
X-FDA: 84894785346.29.A05FCA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6E083140008
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u5BWB8ir;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829131;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YN9K5Ou4itBIYPcrNEJsMst4bAWJ67RF+shd3cCSCnc=;
	b=6BD1wgiA/Q+U2kdHIQmW8y3agfd+Dg+A204l6mv6KwtPQYDin6czOASQKG05smLZnNrYZx
	XYwKVBhSt83CgNaWLc6/mP4qwjHY3+7UuAxRyMt20xtTYJKXZQNj6EUigxtLsJkwz+6Tww
	Cwebpq2pijcmEDysaXMWzkEUCG7vaNw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829131;
	b=1AXrfn76A6UPfmnX2Rgv5JTPahceJNNovavDkxH1lGekUt+HFeM4JZJOJxYPftsbNMyW4M
	Vtfwkr2mNF9HxiUMjurbAdgXtSbQCPxJlVjQjcZ8D+X2eK08X8HxLHD2YDHZdJnMZx4mwb
	JJ5qGPxYfEmcOR0MZVpsdoTSryXe4io=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u5BWB8ir;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9082344E6E;
	Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61BF0C2BCB0;
	Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829111;
	bh=b0mKXX/PHy90zcft1RMHGmGn/ttpFqaluhBfgviGqEc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=u5BWB8irFqLkUHfL/3Tk+UM50VosgwoeBd2gd7XctGdeGs4DgsQrWNJpRYC1spLj8
	 px8BXMO383I/KIJaikPum/5aZQ1UGejHNXw9vZ0NgOdw8Gacn3zNEqf/52203as9gN
	 mrSJkKCkBD8jAu+12m7H82WkxsErmHs2d+ux1nL3mKuQJMJCDnG0Vub4VWFaXHPbaS
	 M94TjIKpajZR776mQVC+KfyQbByt52JpLM1AeWnitax9Irh8WyT00u2PvyS7xqozEI
	 VkdizeYTBT/S/6Wtxls5Ncpxr6pDpSk1IDIFnnuqjC02V5uKzhzf4Pe4PjyHvDmJp7
	 0YoIAyDcoCbGg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B81CD98FA;
	Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:22 -0700
Subject: [PATCH v8 45/46] KVM: selftests: Update
 private_mem_conversions_test to mmap() guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-45-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=5217;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=EOkmG6Hl5a3ii1VI0IHghu74jvofoo9LxlTkLBxEW10=;
 b=dOnjZkMIDWO9tAQXU5IKBRuDy0dweAurbc4iZ9OYtrYhax8ZN8p0aYOqYeJJ8il4YHlhsSiYq
 e9is7/G2FIrBa1mc0zH8WUUq/pn06bhX/hHbsXFyOXbSeVO8Nsk97Pk
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: 6E083140008
X-Stat-Signature: 1pzdtgm6brjbxguxmqtyb179drow1ze6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781829131-823604
X-HE-Meta: U2FsdGVkX19DdHKmORFCAoGqcpkQQl6NexBth8DeUqVYx7aUEWpZzYIdWMk15AdJdqdz6lqc2nU+lEzw0v6h4XVrASgrUt8+BSK5uTfbHvTGya6JMYXxQN+9y8VpwNZdtSYk5S9U3lgoesoHxV25lBRSkARZiuRhRYbuwRy+ym19i3Y6OAra7CzEod1x4JUZgpjGQQAQvZMI+/QLPahC+ylQmbdZdn8t5P+F/9WebKN+1AxxgoVG0Qn7/M5RhLPKuLbkHoFn/gjWk1Pg3eelB5a7Ixu5SLa8LDXwp/Xi+bP0G5lazYRh46WBw9wWC4HJornKnP0rntOPAbdd9pGULVF4KWMhVjGYT0AMmYE4Df7xvoO3Kb4JuXiFeWCZWBCcbDqv/UF3NadY92+OO9kw5j/GoifC/Jnh/QUqf6ry7PAJ7dvfIxJ4NM9Tzu4fuy0qjdjCFwGCeatGotRg26idiFPcdPVmJObc9/qWX4VLYPxqpgZi1ZhY5TPIV/daPIikcfkaKi3BlLOGEJVpaE9EKCt1A91YSC/NTWpe6CGrb/UzW7QPgiGz2Y4oDQG8c4R+eWYwce9qJuw4Hubne7YCJqE+k6CiSsan/+aqTyrDEo0E+hAP+yb+JO9KDm2wyc3xi6pegobsveufbPKEusWmufxwJeQGQPyZhMAcDpijwvl0LD5k9ZVb61feunh6Uf0fTLIvMxfBRX75AgQVoCzwRiJS/WJ2GoIBRI4sWmtTWT3qvFf9YraiYSVs3QZ+U9QOgfNl3vlS9THfxhnI9jY/k7LvQHZu6y1oOOFeUah0UOnFbShOI68PsBYB4OdVUB+JKdFa8Pu53EDCn2vNraiG6hpw63u1DGjN+G1YKCWKKWRdGxTGqobLfirJXThbh1oauX1XMHbD33yDDWpQbBFf81pewep5HVZHdc2WfuhGskjeZetPiw3RfDaVGC8gmR7B4oVSoXBjAy7tpF56Laz
 Jldx9ZvJ
 TLjf3qA4ZCVhUi/7KBhLxOV+N7Mh6IPtzMuQhu40MpR4BlaZegaIb3SEg4dot1lgpCwBya0xyio36GzkoGF8Zcbu/tRJQmq+o9gMtHWqCOB0fQvJOj61YF+64nCuGtzU1tbvq0nRQbkssFfuYe3wRHta4koVEX6CnqzJTeF2uz4z4VNcWwIXX2t+dE0beMrDwJXgyLav2uiZMEr09aS54M27Dd0FQCJITJxbjFKtecBeL2ve82CD8kmDlj144DPUGtkaf75vEtoHkqw0GcEqE8eN0KGOn9wVq0kHQff3wUh5mvvaL6/gxfHkAubY2tcaPwM+Dikbc6rCyAI5LE+e1qq1N2UhU7C6NwuUhisqRaYUUHBHauqpfE76RJmuXhK8i0iMsO6fR8/fNeMjnmUEV75sOHHim8ClK5p45FASBkWgXYft5X5g5CthLfs6rtwbtNteF1/P6/7VCxeiRUlR55yzOFHOVY/21xDl43u7wIabZ40tycVDqfCI5Qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Update the private memory conversions selftest to also test conversions
that are done "in-place" via per-guest_memfd memory attributes. In-place
conversions require the host to be able to mmap() the guest_memfd so that
the host and guest can share the same backing physical memory.

This includes several updates, that are conditioned on the system
supporting per-guest_memfd attributes (kvm_has_gmem_attributes):

1. Set up guest_memfd requesting MMAP and INIT_SHARED.

2. With in-place conversions, the host's mapping points directly to the
   guest's memory. When the guest converts a region to private, host access
   to that region is blocked. Update the test to expect a SIGBUS when
   attempting to access the host virtual address (HVA) of private memory.

3. Use vm_mem_set_memory_attributes(), which chooses how to set memory
   attributes based on whether kvm_has_gmem_attributes.

Restrict the test to using VM_MEM_SRC_SHMEM because guest_memfd's required
mmap() flags and page sizes happens to align with those of
VM_MEM_SRC_SHMEM. As long as VM_MEM_SRC_SHMEM is used for src_type,
vm_mem_add() works as intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86/private_mem_conversions_test.c         | 44 ++++++++++++++++++----
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 289ad10063fca..4308c67952310 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -306,9 +306,12 @@ static void handle_exit_hypercall(struct kvm_vcpu *vcpu)
 	if (do_fallocate)
 		vm_guest_mem_fallocate(vm, gpa, size, map_shared);
 
-	if (set_attributes)
-		vm_set_memory_attributes(vm, gpa, size,
-					 map_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE);
+	if (set_attributes) {
+		u64 attrs = map_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;
+
+		vm_mem_set_memory_attributes(vm, gpa, size, attrs);
+	}
+
 	run->hypercall.ret = 0;
 }
 
@@ -352,8 +355,20 @@ static void *__test_mem_conversions(void *__vcpu)
 				size_t nr_bytes = min_t(size_t, vm->page_size, size - i);
 				u8 *hva = addr_gpa2hva(vm, gpa + i);
 
-				/* In all cases, the host should observe the shared data. */
-				memcmp_h(hva, gpa + i, uc.args[3], nr_bytes);
+				/*
+				 * When using per-guest_memfd memory attributes,
+				 * i.e. in-place conversion, host accesses will
+				 * point at guest memory and should SIGBUS when
+				 * guest memory is private.  When using per-VM
+				 * attributes, i.e. separate backing for shared
+				 * vs. private, the host should always observe
+				 * the shared data.
+				 */
+				if (kvm_has_gmem_attributes &&
+				    uc.args[0] == SYNC_PRIVATE)
+					TEST_EXPECT_SIGBUS(READ_ONCE(*hva));
+				else
+					memcmp_h(hva, gpa + i, uc.args[3], nr_bytes);
 
 				/* For shared, write the new pattern to guest memory. */
 				if (uc.args[0] == SYNC_SHARED)
@@ -382,6 +397,7 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_v
 	const size_t slot_size = memfd_size / nr_memslots;
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	pthread_t threads[KVM_MAX_VCPUS];
+	u64 gmem_flags;
 	struct kvm_vm *vm;
 	int memfd, i;
 
@@ -397,12 +413,17 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_v
 
 	vm_enable_cap(vm, KVM_CAP_EXIT_HYPERCALL, (1 << KVM_HC_MAP_GPA_RANGE));
 
-	memfd = vm_create_guest_memfd(vm, memfd_size, 0);
+	if (kvm_has_gmem_attributes)
+		gmem_flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;
+	else
+		gmem_flags = 0;
+
+	memfd = vm_create_guest_memfd(vm, memfd_size, gmem_flags);
 
 	for (i = 0; i < nr_memslots; i++)
 		vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,
 			   BASE_DATA_SLOT + i, slot_size / vm->page_size,
-			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, 0);
+			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, gmem_flags);
 
 	for (i = 0; i < nr_vcpus; i++) {
 		gpa_t gpa =  BASE_DATA_GPA + i * per_cpu_size;
@@ -452,17 +473,24 @@ static void usage(const char *cmd)
 
 int main(int argc, char *argv[])
 {
-	enum vm_mem_backing_src_type src_type = DEFAULT_VM_MEM_SRC;
+	enum vm_mem_backing_src_type src_type;
 	u32 nr_memslots = 1;
 	u32 nr_vcpus = 1;
 	int opt;
 
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
 
+	src_type = kvm_has_gmem_attributes ? VM_MEM_SRC_SHMEM :
+					     DEFAULT_VM_MEM_SRC;
+
 	while ((opt = getopt(argc, argv, "hm:s:n:")) != -1) {
 		switch (opt) {
 		case 's':
 			src_type = parse_backing_src_type(optarg);
+			TEST_ASSERT(!kvm_has_gmem_attributes ||
+				    src_type == VM_MEM_SRC_SHMEM,
+				    "Testing in-place conversions, only %s mem_type supported\n",
+				    vm_mem_backing_src_alias(VM_MEM_SRC_SHMEM)->name);
 			break;
 		case 'n':
 			nr_vcpus = atoi_positive("nr_vcpus", optarg);

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



