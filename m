Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7721EC5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A1FD6B00F0; Fri,  7 Aug 2026 17:53:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 079D46B00F4; Fri,  7 Aug 2026 17:53:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECFE26B00F0; Fri,  7 Aug 2026 17:53:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7DB66B00F0
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:53:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F32C401E8
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:10 +0000 (UTC)
X-FDA: 85075824540.02.C591132
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 317E620005
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aC2E1zsf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139588;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=16LaKsVD/PztRZ1iYqImdAeX02LQ/qyxGUMpspPv6e0=;
	b=Iodf9tmiQ06FNrCu6ggYgejOsp9EB/JPWbCyfhRWR/EJpfs2gDe3MobJVnYuQmpV0YtMxa
	STSvMC9C7Dv7ULjiIb2vyuRapwAObyR6ER+9G8zEy3mqJb4w6fNY0SR52FtzovlLxDIn4q
	ck3lrrurg5rary/IJg1PrMm1lHVl2ZY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aC2E1zsf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139588;
	b=Ue0GEL9q5QDzBKs4aAi02MNjJja/rpYhFFvKDmeotuZ0eWkBqWMkpBbRaM102kdlKpwby7
	+1MLiitYaU3bKl5Ynpdf2bqPAXFnOT/424DNYIsl5JPXW7YcHbuuU2iyiMNINPqVyY0N8h
	jnITmRivcUI7uFAwUsUss0bjdGXfrQ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 06123452F8;
	Fri,  7 Aug 2026 21:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5E46C2BCC7;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139571;
	bh=GHSWZYSLno8Msa2SPYrlHj9df32+GxqTJOwRUqze0iE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=aC2E1zsfzrFQE9RxSweGEbZiA5AysFxQuaTloOQ1GpYKP9a65YYZwR7ADEx/na7wn
	 tbKK/nsRHfTGo1nfdvx2VBM9u2HodDt5f4zvh9G9uGf7Thy90Bx4/pPpiy/Dk3YBVz
	 gAlnDBX9fhiv/5qiLFZ67J45wFJqRkrQ4pFgpNwx29iWlDjt8ARbGGPf5x3Viper4e
	 zOFk5fuxlz+iUccEWmLnr/q2Toof84LaojpVC+9+hUIm8VkL9yzryXwzr1n7GEGpS4
	 7KdsNDMVq7Eg1puTV92lVVhcOkyt6MyDv/y8mC6OChwYsjAJ9MIEI0bDyqRFwSObVa
	 No9RonnZOP04Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8934C5AD44;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:53:19 -0700
Subject: [PATCH v10 40/41] KVM: selftests: Update
 private_mem_conversions_test to mmap() guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-40-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
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
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=5301;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=xs7fMwhgiH9Gq4d5OQ8oMbU9kMWBZd1SpkQeGjCZdt0=;
 b=xP2hZKeAJgSYqRy2w9Lz3AIrUj/JbXRETp2w1AQAHaWJdlfgRuY4D3v8O108f4UCAr37nhXB1
 bmZHa7GmumwCY5zwoFF7pOTmIg20oysrFZ+iq5GiWk8se8Fz4Guzsbv
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 317E620005
X-Stat-Signature: 591u7f4upzjwtqfaca6s9opi4b3os1ow
X-Rspam-User: 
X-HE-Tag: 1786139588-233250
X-HE-Meta: U2FsdGVkX1/ss2FfiLQq8NrOHBNT0JHrqYoamwrBgpE7V87Q2kYtNeOySkEzJfqREVxAlIKQy/+LCRMJbCiXddyqZ0PfGgoQGarjLDfABDZVkruLOaKlFXpt9ghG2jTVJHK2tHc5cfxxEkbxpibmJozzGfjGHwxEH4B2xDWbsUVlh5ztYjKdhyWL1mYMfaVzd3x8tKC47hsdJb16/87hT6g+X8lmlUObyQtK5h7ybAGhQZQaSkuKOHXgiWHuWudPSd1S9VcJLYE4kURq/G0S96oNBWF++q/j47IyYu/xuVcfKO5Ba/HVL8aFDcacfqyl4hLS7Vk+UJ79Ua7BQIFHJfYmtQp+EzV2ILbL/sIy/2P8F2/53srCGCFU2rGordh8b2wUIbhvkE2efa4JWlEYOvi0F6KwP49BtP60q3r0LIwNGPv9WNQ9n4djCdz2wHC+CAVGk2U3bXyE+i/DkJgUktmm4KGTnG+Dh3hG+lMz6itCvPFR6eGMVMWXMRXZ+nz9IwOVr8IdqyBxP6xTEKImBIM8uiZgvSqYrikoktOnDau9Ks3zelCwzdtEwjb6KvAB0D6z5/WQgQeVhksXbvTPLqZxsGXk+Jtd3NxOkAMYMjfs7CI2TGb8Dy8yl7aTsaeaLiSAy/Kk25e1XiuDPxWdr6GMyBni9P/3bY+5F1VS58wK1+q9rXtk3BogD217mTD2lNv4xucsCDVVfBpN0wePFB/5QZXFV+uK5QoTsAcFYIKwlsN5cFuRHDkL+0JcYuaTlRMEMShbGZOMqpZ++TrEp3Ekgxxwi7XTZ0p5e4C7Q9DlGorlaVvg8HWt1a+dBpmMAhEhXhv5ccR6QBkw9E4eJJg9dHqCzD1kol4KUMqNw5QD5FJ4+GVcwVVUzIc6ROQJBsCz91K7Zb1oUzX9UDvC4tD2dojNw89PZwwjoI1aM4GYf2/eT0OAE7kpPAOTpkn6bSQVXp5LSa1ZNvY7AFJ
 xo3YRCZg
 G2F/x06zwyrQ3/sPCgtGByle3gjkh+MIobRNjZi08Ong2ZGr1rwj/WgxI2c1FAJNLz+VC1DH9/pPcPt3Qtd9V0CMSs/UB0U4WdTjGAkc+xGCBTxPzV9PF52NK9yMY3G1v8tejMHLIGYLPnL/AX9R0kV3/MUmI5F0L2cPnVAxjE2F7969Yqdb0VWOEcW1wb4En1fNdJhllHL8MYt8V9b4/WyDOTP3HapbUacUHxoZGalaxE7ZKDZil1ZG5K/db+EQNonWs6H5PC4Y/BOkj7zk3T3hwLK6Ub0HNFSiWTUno5QoGJHY73fe2REuWg/PApilNRDwHZlUVKNjDpvWNsay/j+MHz6Zaazmk8RmJhYMCpQIZXCgy+B+BKtfihWjcNBgHubkKPHYwUtCPnqnK/QIFoSozsaFYX+Bl5rPAr9pLTiyXjLFo+f0lMrV8Xk3oTb0sGWRoEMZOUB2Co58dKFHWXkkvpY8gic4+sbY1hy9yMRzPiavDK2O7W41V7xqLCvwaJw2pE1OvnmfZ4jzP2voV6NYp0rwlCSWxaUgBp/S9/4EX/pChectRGV0oMg==
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
index cf50e9a332c5b..2af8d41963816 100644
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
2.55.0.654.g21b8a5bc05-goog



