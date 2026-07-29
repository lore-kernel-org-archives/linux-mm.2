Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 776C1C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:37:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E5DD6B00C0; Tue, 28 Jul 2026 20:35:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BE4D6B00C1; Tue, 28 Jul 2026 20:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AC4B6B00C2; Tue, 28 Jul 2026 20:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52C6F6B00C0
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 008E3A1900
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:28 +0000 (UTC)
X-FDA: 85039945494.11.34C0AA2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 05CFE40004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bhu19or/";
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285326;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZqtTdxlLxjBKKTkc/Fm7jIeRFTPpvPoeDQ1nFCpH/wQ=;
	b=DtaRXzueQnHzpvhJRae0kCDDR+kcJUMhbTw5yjxGUPWwja6fbkkkysd627ZLV7nWLpxykk
	8VXxxfEWxfitnjlca8lV8lA1I+X0ZM70/M9+aES5Sk4/b6bY0X3sJwXHwM2hS4vR9ZXz81
	2fTjspJc5eS+GRjxEqv0d0N2Orn3NpI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285326;
	b=FrgLvXH/Jkoq10J4E67iW/6DDESpACzgbkuTmjXiUkdqvn6NhVnjC2DdHgGaJSZ+GpVDdj
	8cXK4eO2tC4iLs8KTiaZb+UovqU0y1PdYRrKp3Rzgo4e5xURtT9kyiItf41N/TDgMk1h0x
	EtNO8lF7e8e3cVSHOXzhNQ6Kyn+eTjM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bhu19or/";
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 661324516A;
	Wed, 29 Jul 2026 00:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3193AC2BCC6;
	Wed, 29 Jul 2026 00:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285311;
	bh=q9BBZ2cOicHWCdRcoGK3ipPSEq1AyUQs4MVHuLKkebc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=bhu19or/ASLFVrgBUwFWruum4/g/CCDAZ4/OFFDrs7HIZPJnlx5jvdIKMVTBavn2I
	 CBusPf7uY/awUiMhfIoyVLz83YQrXaLgsp94AbXoUf6AZSzSToEecfuTuZA+GMTJ9Y
	 /tLV1l2AsN/pqiEgwzznXq4uUAi6NG1SBsVomtwidsCqB+3Tk6Dhv3qfHWV1Ds2yd/
	 k63f01FzB+jsE+yqBfsxaqB7sFDjixc2J2caTg1aTOxz1CcD4ZlwhX4SsBDmveKdoN
	 ZQtcc15thz88dakNl+K8wNNqCOud8IeJ5NJ3l8VrMYJ8LQP73Hzv9KSR8PKqvRbq5Q
	 u0a8vZoQRWlDQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEB6C54F57;
	Wed, 29 Jul 2026 00:35:11 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:39 -0700
Subject: [PATCH v9 40/41] KVM: selftests: Update
 private_mem_conversions_test to mmap() guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-40-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=5301;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=9FGPnqnZp6zOn6/CKoJHInYHNbbYZzELHp68giVAOyQ=;
 b=2ZbzlqOCZmveYwcrYPOs2tI8xKIO4RfUIcodM5/9SwrKa4+WcFaBVHFLV3JmB9Gm/2myyBCyQ
 nw/wkq8s9RFC4CXrvycgwBCITi6Zt+oExpRPnQVHrmPDne3ob+ERFyb
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 05CFE40004
X-Stat-Signature: m7oggaa6adikcre8we1o44tw5egru169
X-HE-Tag: 1785285325-556566
X-HE-Meta: U2FsdGVkX19VVYlA3mHm14q5DATLpNNQDJfvQHr8easSIj/aoEc7YlADaxrm69tHl47L0ugpMQ6hWgNuWk6i/GU/vs42FBM6A4RauC6pq+tgCIuWEAnGY9HeAgtSfpU2vylP9ACDfxFm4cODgm7KJqzUbTEJao7GIXqNRpGEMZYD7YSmF/8OWuEW9Mu/ty5U0JI84XZ2zlVq7nMGXMNEAZ61FayOVtUYjiGRMcWsJBeLUSujKiInAVh5nZtcokZbFohMRvCebykVLhF1Q67IvbWu6BPj0IgLmwoLdzGM6hXxs68T4UlL5Dri8llLSReVcQbUsze2a/p1fiIFKmDi54lHC865yopwSAWBqvE3QFtQdvF1XRBWQJsuW/jfgG8z7TmMl9fia6mAEyyEgCcbY/zGN56KKEFvSFdO22WJQIcg0kHbcwP046rBCo4Ftl05IqZtXI+NBrh1HKNQPHiK0/buBsu46DyBvuj48bFlPwrYLQAyBT4aJa4goXMekTp2wArnxbOatIWZhmSTrLj9kffxIU2NN0ZteNzBPdNL2N5ZUs9zw5Hho5LAx3r5c+FlXDEWMQ+OWsD60egHGwNL3/ZOel4FDaTZXy/c4Y4R2OqwVGfb/8CKsyvUedx1kqziwVVuzDspJeSadP2fyowtnbAITj7vnjqUXzENJ1EJ65eIbdZxI/KfQMLxLJEzwxUzUlrkaFMbKuvFcrskFLMjRcBuO2vMuoH/gSfDjvGYyqAiSwc4pzTOdsv1QuQpwM+ldes+1f563R6g2kOcePwYg3QZ9qruykejSIgF+WPcJkjTKTbx0SLhKM6jxarCFCyYVtBBYhxMfO3pLnqKVXUfXuZ5nWrBdVUhl/3+TLmCpWEPTBUtdMJ1EJBpKSHuti5YFXitIx0JmH4TvCiJA4MzELj0iNzOqXJgcfefl336PnOZi963xhyyaPx4R6NEYXmyUEU3x1N5Z5xhE3PQRX/
 qWP5ugSY
 AZ1NxWx9JZ5lyIccvmutGYnQzDBBrlMa4RoUaFG/isM3M3IgvQK4L41C8uzRRClXAaqY+/lHaJ925lDPFGaa/DxQm9OrxdD4IszKTOpCzo0eX58XQ9oZagbh644Bz+QcILmWW9+n7Coucb1Eo2EYLgg6vRpQbm1+ZyW4KnCL+u2hSLXt7BSyhyqqARQLalhGpi1I0Fqdeo2RZ+UW502+LpqM53jzKoLpjxTbrN465af+TuVP9ptxtUBMVxyPyUzXXGPpy+0k8IMq+/W9HE+zQeXC1Ez+hicax4jcRhGvcNH0qGKduDICbuo98Hkm+s2e11GgJ3/K/dAl/jORAL/8+9ZfDFpLIAXIz/Vf5DEBFsiWl5jsDySV6fR5h/wHpyjE05UCQpheUCCItgMaiMj/ZhQ2sEKqBdtz7++2dHU8Q59gQdntiEA0UlNNsbpNsRF2o/CQoskK7Uqwp7uvLJOMWLUglnRLpmBPzYiIeUkLdN0hOlYC9hOkkkvjldlHf3GoBzvEzu/kTS0uvD3Rh1ZVl5rJQCCJhgt6jiu1Lt4j97l/6wfTVI+erSBOKBg==
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

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
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
2.55.0.508.g3f0d502094-goog



