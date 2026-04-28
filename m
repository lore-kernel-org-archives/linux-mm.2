Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 172ACFF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 822CA6B00C6; Tue, 28 Apr 2026 19:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FA556B00C7; Tue, 28 Apr 2026 19:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7117C6B00C8; Tue, 28 Apr 2026 19:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 607376B00C6
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:28:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2F5271C1458
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:49 +0000 (UTC)
X-FDA: 84709549260.13.8A77C9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id CE6D6100011
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o4902lTI;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418747;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=08tie2p2N500PchDC+HfzAbrJmxuCMGhDLF/3PDHX9s=;
	b=pYsqZTF3K7LXcyEa3c8OUnnkdvoxt6XXMdujMxrbsZK7HMrvJjI10rewdN9jVUwA8eTnUL
	CP0dXJE7o0eV/WRE2EM42tJHN1vkyj03DyrS4mj+jT5dCpwOrWY5GM6G0zf7uGBcQ/2peJ
	ha/Bu6taIjFHx7LhAiKG029GZIWxiKg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o4902lTI;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418747; a=rsa-sha256;
	cv=none;
	b=cZl//D5kx4HrA98aWRraDgc0Nj4+bFn8tf3OpSXIjzue9IgFCK9q1IuhgvScVTaSvmgMgf
	wZk/OBcTQrVtnTixgVoTYH8soH2FsmB7mIwga2AgKmFl3FAz2T3MQ3knOn2LNkmTjrq7q+
	8TRr3FVCo9Iup4vFmLthvMgMWha3n2g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A180B44BCB;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B2B3C2BCB3;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418721;
	bh=QOGgIebHJ3oA3+irXcl9BGohiofC0zjPb2yCAcdjnIs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=o4902lTIWzSn6RzsWqcaiQDbh2wnM0mdoLAb88h3ELQ7OieeKgo7+GMVVdvUqiV0J
	 w0/uZkJXzZoMnkIpOi0Pmzx4qtKhrHkT2CSL67nxORoT+5SLewiI6Mmv0Hmp3+x4c6
	 /kVa7kB9ocNok0mYRG+Yzd8R5z/te9/PFUYl0usHbWBdGPIhvuYtMRw/ISNZwcUlB7
	 vT4po+oUH4joJO0bZKQrfD6ObATcLYarBEVojSqs9Haw2AQcyx7QWvGdlgj2sxszyz
	 MLyrXIgcQfxjdrxM81od9at/yoXpiDuImpj0Vz7Rf3Qy0RN6DilEkF6AqVVWwITO7d
	 1N0z314mgkPqw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 706D0FF8877;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:45 -0700
Subject: [PATCH RFC v5 50/53] KVM: selftests: Update
 private_mem_conversions_test to mmap() guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-50-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=5312;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=bwPTkwZvDxfUUFYwlpNeKbRuK99+tHHLhQpgIWpmwPw=;
 b=28SKjyLa2IUqWFkTFjnKcnXy6T655u38NWUOOjx5dHDE7NQ0XXqy7HzAEe1gatNHcYlDdkdLP
 iBUvyWpIELZDJMKOlTTxgvHdfQJaPjRG4mNsaWlhLHBlWjYGDHA1rYg
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: CE6D6100011
X-Rspamd-Server: rspam06
X-Stat-Signature: 1sxyzx66h5xwk7hs8867r4ok19bpn881
X-HE-Tag: 1777418746-277895
X-HE-Meta: U2FsdGVkX1/PLDNEIbaILtAQ5aqthuM8YARgCO/C52hmqszG1aabew/C8zFipdNAwgIcE06FUCMB5WzWjJhFUTRBHplFfP2R4rbl1pjlTlBCybzcyKUwpH+o9xxgFp3UBWhItH4hhwiGcvO4+aYfEFJErvBuj+ioSDp/NhyP2RK6ClRJUTdSatA+cBeEB0ZwQQvokVCv816Q/zAIcBgP5oReiXTIrfjfWTp7S0VtvRYClid/9DPRYTHcCvKEpTeqH0Tprtktzv6GYWokIKOd2JwITp3Fds1l2kn2w+bNWakpho9IYmG+7m6bODI1OZVujP31sVtO4z1/0a9Yp2eqexyLod8RyyhOLGhalX54t+6zFgILJzmbCqQ3gaetB7UF5wWIz/E3aDEEcUNlx9BXiaknXWbUPkS/kSembb5nj+gHaftuqYYO64VdwwLlkyiADo/IctrX/hqMZErkYWiEAV+CG9FYmro+vsCkaEdfihJMDGx0w2f79M6N3GJba2G7jm+d5unHkIvHXLcx+kC39K34nha4TpY+6FAcfXADagoaQJdIWkC0Q0s24T26C1sgHMphEOGRHYVGnaMXVt8jNjxkMNpB7NJLyxPMVbXx/2I4pxw8RPwjp08yLm5gE5R64c/tqcmGMBDp912BZ1l+qiPMUEhKV6FQsyMwVoNE+Ctjp8j+aN4hLNmq3AM3SIb7fu7QGx6Y18MSnPxzeC0zY4bLC3jCncBvUron0ZrtoZgAbFluwngJ4hR/Gw3ySPPlmCP1ZstKlVtbSdTKn1KtI+31qDGo+CaUoLpxEWFoUyljfspknG3/y8b7X9+YWZylsKQplcd9QnMyCHgLGhy814Dj9rLJWS0N3Sabq1xQHQDn5e+IR+9+nMpuRLPxUuPZZepgpmFlycV2hdRw1YQZK9Fb4L1VFgEGrmuQ3m582Lmbz+XB/q1CDTTxoI4cLKbM2JvLbRNDw0vjz5Amqkm
 3LyIn128
 Wge0j68yUsKiiZsgs34G6nM/Mk86HACLHckGMFllmJrh1bBYo3+TL5q8TCeInxZ7lsBFbkYg0ztExxoOUCbXY+nd2eicDZq4brcN/FsZ/HNTqWdqsdT8bnOUs6dc9zVG1s0SbH0MsnOsv1TwKcXD+VUrpsAxHptF8GcRe5SzRz6b/w2aBw8/Vqf2n2P5Cg6H/yS4xdnsFPZi257Yrp4JanTSDwGz28diGH6kFV8Dn8peItlv/5fKzOr3EuF9ouTTZl4/XglCJq+2XBv+1KsC9CrBloYvbpf2e9jZN1focbIUQLP1AVUVh7/qUBb/V77E1ZEUbTYltXmQvVM72fevllc769tP1wjpPkZF/SHxp1LJPDokTwUP7ChTuLhe46sqT75StAj6asziejbVQkG5JWPFR5Hv1jYTmxKFKlzwe6IHLRfxGGxDJvPDttcsuAmlrZJQ653lBf2Svff0Vws+lAehAEQ==
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
 .../kvm/x86/private_mem_conversions_test.c         | 46 ++++++++++++++++++----
 1 file changed, 38 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 289ad10063fca..14a25609a8a35 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -306,9 +306,14 @@ static void handle_exit_hypercall(struct kvm_vcpu *vcpu)
 	if (do_fallocate)
 		vm_guest_mem_fallocate(vm, gpa, size, map_shared);
 
-	if (set_attributes)
-		vm_set_memory_attributes(vm, gpa, size,
-					 map_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE);
+	if (set_attributes) {
+		u64 attrs = map_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;
+		u64 flags = kvm_has_gmem_attributes ?
+			    KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE : 0;
+
+		vm_mem_set_memory_attributes(vm, gpa, size, attrs, flags);
+	}
+
 	run->hypercall.ret = 0;
 }
 
@@ -352,8 +357,20 @@ static void *__test_mem_conversions(void *__vcpu)
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
@@ -382,6 +399,7 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_v
 	const size_t slot_size = memfd_size / nr_memslots;
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	pthread_t threads[KVM_MAX_VCPUS];
+	u64 gmem_flags;
 	struct kvm_vm *vm;
 	int memfd, i;
 
@@ -397,12 +415,17 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_v
 
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
@@ -452,17 +475,24 @@ static void usage(const char *cmd)
 
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
2.54.0.545.g6539524ca2-goog



