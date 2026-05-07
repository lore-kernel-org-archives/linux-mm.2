Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B473CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C5976B00BF; Thu,  7 May 2026 16:23:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 700226B00C0; Thu,  7 May 2026 16:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615916B00C1; Thu,  7 May 2026 16:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 506AD6B00BF
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1FFB71C04B4
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:16 +0000 (UTC)
X-FDA: 84741748392.23.D1A2BF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E77B41A0002
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cOYBmAOL;
	spf=pass (imf19.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185394;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Pof9zAAgN4Y92ZMLNmi6WJ6LzpCQgnEE2pycC3ewyo=;
	b=fyHeVWyZne7qDOEvALaa8rKR6XZGgql1brpT+dmlGTPI0lYL20tUPQASSrFEuiI/aKp/HK
	IgDZ+0VtZbKewBWu+kmwPfSn4VCGS+xGGiuHTOzO9w84WCUdEA30EiRnez/J6kwe+tOE6u
	ZDLyd16PvO93x7U/4aXeUr/XeNC5aYU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185394; a=rsa-sha256;
	cv=none;
	b=MGlW70mpnPSLTUpFNA3+9MRMQ/V2vlMgq0XTreRUCFR1GjXxOWyC5zoyKW85aRshgmXQie
	6B7Ttr5xI76z6OAqZZ5ICX6jXkVNZMWzW8tqA4bnYJPKxAc3CfF/H1H4g+ktVqvlTJxHPS
	tdnqaKPXjo3TYm8SCrM8iQlOtY7ATjI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cOYBmAOL;
	spf=pass (imf19.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 92CE544908;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5EAD2C4AF13;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185373;
	bh=TZVHm5ogLzeWpi0KHsJxKop5bpcsbyiaYZnuy5Cjpag=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=cOYBmAOLDB2dQuL0CyYw24sx/PhlClQWx85LmOObixoiKV7+W0XXT1Vvn8hx1XR9X
	 oKvhipAJ3E2lZKQTFsGJSvWkQdwjgR6D+OeL7VeNJNxRlTa8lRVu+1qgULgI1adj0r
	 WCL3vbtFaEUq/lCalAjLMAp72iApnTP+iAFQXOa/drcK3yIn2qw7AjR2xVes7yhD9x
	 a3JE2AzKCtPOjB5UieErzEGdTFdNhhoKvmW1+tWQJtk5EAPWHk38D0my8dWYmVcj2p
	 QTFR+0iwk81CWy+eK+XO/kscZeIR/VF2eBRxWkCyCn4edb0OM9Cc2dYfJyCe/K9l5S
	 /sVKvjGcO5TvQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53FEECD343F;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:23:00 -0700
Subject: [PATCH v6 41/43] KVM: selftests: Update
 private_mem_conversions_test to mmap() guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-41-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=5213;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=LA4JCt1MbMdT859eaL0iM2MudWbUqdXxNIR3WkBLDGk=;
 b=kwWSNqN6jp8rUUMmXqRD8BJqeMg/9gq1QwdWXLMujEN9NFlQbRbmngg5LNuqP5OAst+Mn5NMx
 ty6lQAK1yGQAdgcI0fZXHhOeN5pvEUqiI6clz8puJ3ZkhYc2p8uPerM
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E77B41A0002
X-Rspam-User: 
X-Stat-Signature: bqfu9ytkerr3maxxo6p9wyuq1gncnowm
X-HE-Tag: 1778185393-376168
X-HE-Meta: U2FsdGVkX1+SsU+hdLnPXMlkgsjeYDkM95bOEvfDV1VB3HEYRT6ip16sAvgq/njlAqTHskupqc3L0vVQu+A0Y3YpNGzEMZqCPocofZoTVR4hDujV7GbN57x0klYP4twxQkUM4xFdS4BOpXTd1ZxZaHxc57YM3j0yFz+GZWpDpDwaPNd/nwgs2lDbeCPmutnGzlZJUvw30nwHNScESyopk3EmfKnPYqIWdWAwcpJA1ewo6yP9sQsmS2SzIKKn0/CG6EtLdeTYTIQww2ZqR+ili0AVKSRBFjde8FlRYl4plTjXEOXb54yOX3ruapU6P5AYSMqaR+iA77irNn4BdlLAzZHNDtEk0KdxYj9vVyz2ojt+wcK2hivlzgdd/jHxOqtUueLUtva6oPcpsgLRv5HuyqNDOQez3YIWSQCxRO9bT0h/19bzt+41g4b6J10mpF6pxCniSDze4MDeIwLwkpy+/QO4UDQ5h5T8wXPC6YofmaxZy9iVI+bPL0Rtg8HQW5xbXPWCDCjzW3e/0vhkjX76O/hNXsI9ScWOf/RKUOV6Tx2kjhSnlyPumYZ19Z7aN3tGaGNoxVE0B78+MwIZyxsNlAKkHvf9tUbB7QyzJxcf+yMojI4619A4NSLUkk8MzYQsEpwb5xV73N/EQdJvtmO44aOwOMsTxHjfSaEc/buWK3x4eNRCwWC6h20DjVXX6CTm6KqG7erex/LmYXsyDdGW60kzixZPKsh9ecWwzbzSQGfOMLzGtf8PkfYb039UJewwJEMIYl7lEI9lHp5gtzdlwKHVoUwSNWz9J0G5aYda+Scw6Q7BURW4YMlbB9eg2RzF1vBmHXmkKiUXmN/DJhSRA0nNcPVFSUEtZZfVWqz648HdGlT5pUg8zi9gsflT02rldWb9tYY4LHJ3KL2lG/YiGfmoB3jCko6YEgPxz0ofRWwuMNxgvOWSE4dy2tL+tr28ZdC1PBbIz0ti479+Jx/
 ztIlt5qD
 1JAa2ONd3duNc5NmGWl3gKBHUef1hpct+Nrg08fJqlKPSy/GTR6G+g3CIhwMnXM34nFu6YKpgdi31IJTKQnj+98naGzKH07z7Aoq/pqT2nqbFg5+B58XFRZXpVnyuDgHZA0J5OJ0VtchIEzptxwTVjWIOj00WFt5jqiz6jgl2BVCvG10PLkEn2M45RyCpH5KFYA+lHnjZDPHyvUXsiT3sbkBeScVEUX/59btg3GgUuswivHmvoPsYTqAgvtwLD/vxOy6LRFIYvX9iwaiDT5VUFCMQKyrSCWKUIJOj0yUV/fS5p6Nq6bqS0ySxGJZUfUv6XVGJGKEcn3Mtiooazwoq3GXPmhIh1jdnNSScCKg9iU2NIBiLXHDfccL5PdkfhWETAaSz2YIDFS+ExOXl/3qXKyEEB8xim6HsWu63AvRfSDBRhpjJoJudtIbnhfRawfppTHvM0qWoCpAHmVlT2TzphcZ76Q==
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
2.54.0.563.g4f69b47b94-goog



