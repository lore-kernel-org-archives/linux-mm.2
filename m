Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A96CCD5BBF
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 763D46B00C3; Fri, 22 May 2026 20:18:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739EA6B00C1; Fri, 22 May 2026 20:18:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F0716B00C4; Fri, 22 May 2026 20:18:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B3136B00C1
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0628B40949
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:25 +0000 (UTC)
X-FDA: 84796772970.13.5922B70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0B72E1C0005
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OCqXAen0;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495503; a=rsa-sha256;
	cv=none;
	b=s3P1IOA7ZAtNpAw9Ql/O6yBugrT5r3NKAHU1R7zNXSKv9k/Tl4EVELdnD5I+E8cnFYp05u
	557ck5Sv8xrk6FmdBIprea2gGK3hnBsKNnbIYqQJvMNorX7LDrpsSEkd7qSDMYnx9ceJsd
	7sxlo46gM7Rf93QkUmsk/nRpoZo9e/Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OCqXAen0;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495503;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0cOhR3Fx59FfTW4NRdkJgh7ia/U8SPGQIsayOIJ1aYM=;
	b=QfwM0o3Fjsg2OqAErdW1uMJmTNwqcbpBgsEfHgLk4MdnE7I97yQr4w+6skXvORiCP4DwLe
	BMaUaN+WSPXGQmmhm6u7GpD2E1Q4PHuGGuRsQ1MQgGvh7RUshhjP5sNGMnb8BJPQi15sL9
	/9MDLGycwv+QkN5ngajYystyzzIARtA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 589B544E5A;
	Sat, 23 May 2026 00:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0137CC2BCB3;
	Sat, 23 May 2026 00:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495487;
	bh=xJTczf0BWRSJkqvroU1NhrQYHKbLrI1xivIurqPltQE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=OCqXAen0/VzpC/OIgK6WAaDSwYClDdEOL5xLa/8zn5QrIhV8/4/JX5sf6n16DgJzc
	 tZH9m0h6HW1aHTXAmZJNSUO5DoSFMpGcVKzn/oBH89D5eQHJwRAbRp78Z2zhREt6+X
	 16H8csMEPyLswUpzGT7ziQnuIWGZkZnlOWwbfISUekWUotsxZc70sdkO+XcXOvJ0w4
	 IpwYkdXmz8YIOxo6NjfImExirDliyRuN3CcJiuQhUKA6K6U6vp/uiCaQBASIONRjzT
	 BhifReSaU4gaBlI18m9hYcz5krOMrrJWEI80FA/uLflk5mGg/h6zAOT59TmTDQQe04
	 As0nRpKS9hPCg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4C13CD5BBF;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:22 -0700
Subject: [PATCH v7 40/42] KVM: selftests: Update
 private_mem_conversions_test to mmap() guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-40-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495481; l=5213;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=uNyv5qcWrsgnUbApJm799ESgGG7iYPZ3A5BHUVo05WE=;
 b=GobT+9iuQJmhESOxo+aCg4Zfd+AKe3rPclBJqQ/aGuxMjASNKpXUZ7jZwYuj/BwZcD3IFh0Cj
 hxzUVX4srApDe9bhGB83RuI1hNhofA6FODKZv9T8xn76XNXZawT5tLK
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B72E1C0005
X-Rspamd-Server: rspam03
X-Stat-Signature: by6wnubdsamjy3p4nzq3r6fwq9rfud55
X-HE-Tag: 1779495502-712291
X-HE-Meta: U2FsdGVkX1/YEcHvCWxTrs9vQAqucvRjMYJgLFqT5xxPOVSUi71N+l4/giI6WeLky4b3y69HK5A8wgYRBKLoeHWllEg/2HCE7+Nvd1cAoIrfu1YiEfv0yY0OC07kqkONK8/cgoTRNdVdFWaLgJjg9UUqC9UV25EEjPhjkv6i+knSdePHaiNyFNiRtNzsv1v0ymc1Ov7SL10TAezAAMsZe8j+ELOvxld3EqGGfVIQyhzT5Hv1xbF2qItJgPZgU6Z6ndNY+tChoIFf/ZUtWSNptiH4BpVpRv0a/PqnbL+BcVAVCDPrU3E/CEO6gz1XT1PhoEC5ShJ0CkeTX+7G/LXJmXVt23VXXFbYndGqiL8uEpPVj35+7IcyMxgS9wp1dbupbjnF9VrJh+9vCK8snNjL4dPaQf3UeUn+E3GYmSluPdBkZ3+x4I+Pzks/OuHdwVllMn+ItVpXc71hEvOmEsk0iuvL4MH98v3nkCS9pB8xaYmwU9GpTdGjB8i4bbzDRIqNLP4xnFsiWFNfbvCVR7dH1b2AD27SxMLhi0wfh2WLxaXifJBIf2+kraE5rgJu3T/s2drk+qltRKjnoKeSqnA8FHv7nlv3oxDiccMfAHXkAlRHOtmdgLmg+nyth5BsTiOl6wjA3tW1Gw+flFs/YeRbvuq0u8lgXVFZ76pdyNlRJm5Sf1jYxJ89P1Vbt6JrfBZhpKEVafnQheTz2CWr0D5spK3WCOPHpPt9lXYyw/tM9SpYb0HWksS07RMRGm7m7xYOp+daCrLDlS4dfyh5+0fzCDupGEulUI/m3C/UYW/5VacOMiNNEHVF+p7AiJXlm4hW22H8hNtnNxe2GgIt6hoUbkxjOuhXzcD8rNkzwCr/2uEYChm25RqSmdYxQGdfdZKISPj8FlfePhlxEKX3x3bh95ozHyklfde815tG/yClumPjfEN4/mt9vNpXNeVo9ikChnwBI9GXRJejdQOldql
 VSvCBMWr
 TjAn2Vc8kmWyX2zGvCeQH8zR4Qf3S5jCu6yk0cuIQ9fIQhNqOFUicASjgIabe9JQMaqWcE4+6vswI01Zwn2WeE9RaosvY1L+MulHBhPIJt2ng3vh/uZJW65RHrvseOhmjeZFkcmdcsacuGfwuLVGGaR1XOtWAishEtjQ4eyCl5gTJUojwv4A9ntTCScE6JWQlNDDFANdVhapkTxy0sToevmJZcSjnAK1Pa10f8ZYlSHOVH0Rn0IySE0WkvVOijlrknGQ+2CyMcUSvywCHsW1vMCFmpoAlM7cc2EPUrXQ8gZsp/Oe6yE2WpyA2zUC/ficosQr/Cpa1poRB8yPMeKQe5+Px+PebL35XA091TAz51yf+eTcm50f0UWSqBxbyLpJkpd80oi9bRTYItKnIMzFDm6atGT1B8sINUxxakmqydbslMTxr3bTtm2OYRX/szuwB3oH1GEhIZOITlvNdU3B3TQrw4g==
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
2.54.0.794.g4f17f83d09-goog



