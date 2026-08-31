Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26CDFC61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDA526B00C4; Sun, 30 Aug 2026 20:25:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63BD6B00C7; Sun, 30 Aug 2026 20:25:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0BAE6B00C4; Sun, 30 Aug 2026 20:25:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7672A6B00C4
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A8E01A03CF
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:49 +0000 (UTC)
X-FDA: 85159671618.03.8EB9548
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1A0E220003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="O/5NBW6O";
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135947;
	b=RtSMB/4hTgCHkbgIXb1SdTjz0fwm0a+wtjXbkw6YUEeFVQBz5ITs6Rln7AICyHF24o031W
	ZpRMUK28jQNhcY59Y3s1rjuquH+pzHULeVAkz7IA52ddO94a6OH45/Iw5tECtOi6H6ySH3
	ZIsB9R/Tvmz4yOkxLTP+I1YAyZ3Mc6c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="O/5NBW6O";
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135947;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6PVLnBlD8vX83HI15TFz810HJROwK/AOV4CrH7zQUCg=;
	b=yhPsGnDQ+lrx35k2VfM2PWyr1yBPVs7HHaTRZZsABh3O4rpRNhuwVF8AXOLWvLidr56XM5
	LnVsCkFu9iT4AfereXeP+B73S8oxaTwrR7mFxvurp/VuFzVgM84PBeKY7fVgbPW86lg+RO
	/4SqDyg/VrmBV45iAZmKp3wNsX5QJQY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C37544A1E;
	Mon, 31 Aug 2026 00:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2B0C3C4AF0C;
	Mon, 31 Aug 2026 00:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135924;
	bh=L1SvzQQsKRUvOZ0fQVdIdVUEFR5k64uVcH/NuUMnWr4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=O/5NBW6OI201GlvVp10lsHH14kGYEqgCVacehiFDMnVFB0S/+QISvCCMgW5J7NISs
	 M5dTwBDLWrF2IAOLExZGYZDrRmzvgcbBow1fEAn+tmL3jrUoRBHQ/+153Pg2ZNkim4
	 /Gd5RX8JS86jbiXhlEBAy2lPMiv94sYO2BPRXFgWNgyQmX6UPSftMJPq0vI4Ri/fy3
	 d1CH7KR04eOiQ2yIAsOI6GajGrRt4sNTBv9LiBT06ZbFUuUlG9hfkjVk9F36gKi2e1
	 CiG3O000yZiN5XrtSasyHBxzLNN6V9QShpqA/7vPvFHbUVtrzveSYCmoJO6RipGyvp
	 mCYeEvhB/pOJQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF04C61DE4;
	Mon, 31 Aug 2026 00:25:24 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:45 -0700
Subject: [PATCH v12 44/45] KVM: selftests: Update
 private_mem_conversions_test for in-place conversions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-44-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
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
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135916; l=5680;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=1X1DA4tCAHh53esF+mJakIrdUfA/0k+CNqzh025SQ+I=;
 b=q2PZoPyAMrhu+u+7JvbSLoJN9cFAttmsbb84heBDBlERga8e9Hybf0q4RUT8pEXtUMNU1LnQn
 xooi06cBSXdCr8UzLSYDo4mk68lH7DL7w3WrvB1d1g3KSsm0AjYYexF
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1A0E220003
X-Stat-Signature: x5yzf1kxxwadwk18n1jimhz9ap3grter
X-HE-Tag: 1788135946-63606
X-HE-Meta: U2FsdGVkX19WnmeG7qvCdfcq1ttPPaCIrkaJrR+lSkKRmerRWnvNzH+ch79txSB7JrJ4DmDdKozLDfPdu2aC4ijTjLwLMq9Kz+twf7HPe/HP1gtFSQxWoGEYjX647epQRGDl4h71KIAFR6TvqXfntZdC6mupSLB1DtNrLHFXrxK6xPODPRbcOu3J3GRhXTw6i7N51UgIvv7VRsuAImLJ3dn7hXyxqpiEgLR3VCgd1uEo4xsjMl3jT/AxMeTB8fyc1fvITklYhokFHEeGUxZJIGfEbNfk0wtOYir+3ezkYRi9aRImCzRF2ZZY16AiEX/XBOcnT3dVYECFnhz7cZ/H1JRXhIhGobTXPxQOIupomtiPiAI/WdYm8AfICQh2/WXPpOGuAi2rHaKCV/6hVnjlFSNLWU07FYdOuzJN676gqnv7KLUj/D64z50bZJt6fS4ge1TvK6pwmcjKARy98ocTZw+NWCTEAyEptHzVFThf2KpbO8OHtd5WBYX8QJLrHR8tGvv0nKn5yuxgtYqLUy0AngAM8YXkPZVzCfp+ywdRTwtph47qOxAK0W39t9DKIsibzFZqEMxYV0Z8Ty2SXeU3INWsVXiREf+upoLod9iVkCPYROmGTZbuXr1v3sMIj6fJcLPA3NsfU1ydYRLWUlDldgsKRn5wxd03DYrNI4HKMUdDqoWR6iKyNdtpYxgyJsrUsB5JWA5oaC66PGUnwjAmiLoqpjfdUfa2vk2U7Fvhi8RbbUb6QLERoin11xx2QKvz7dzX4PuPTQihSD1b+wI7xjxOS2sbEMDubmBLGCHuj4xl7RFYVGs4giqE+ktnONtNfn9IZPk+wA4o9tYALFdyIrXN2uUaCSiVEAEz0g2jImj6Q/5vY9aUzkaovbVFqg3q3q2609RMjlU5LSVd8WrMAEOBX5xydbeaZVvHncot/0Yflq72IJbioNwbWOdFMPE4wp011m1cnKoAhFkxAsw
 j8mBrv3i
 bqS/nO9Pw9zOQ0zJddEAw58SUylcRVd3CpIyhvONFcqZlp3nNvGRhq7J12qTNuRm+W6ZZoCD0W/cFMh7CfW1nFcD9OwxUb4VRASnfYsPIkMkdmfdDZABe62cvzP0KAJypxgu2svq9RzywU/4n/ibUTWRrDcgOc0/KOEoNmIb56djLkxbM7ZCt3kKykfylnxkZGWad9fltc7u2chEKy8WCdUhn0IcY0x4cj8D2aotB6KjFQckpXwcVgfVWvQLqceQrWLf07T5HnCDj9ddI1USK1uXz+L+8TWaC1KguGVSWsZ4+dDfdsW0C7ZAWzlUYsrafZq11t3sOC2uqHQSRy9vSDlWPt8dqUdcztcNrS9t4aWFdks361hdeHgSFh5bibdMaE/VFeHXYUftkdvxzB0JqJoS5ludeGZdk7ebTpI3dNdL5cBpxcbheNpYblWuWIX7XBHRPMN5XpfNaXQEZHLK1PwQzXJMwBz5eyR1kpYtBAF5p+qu52+JNEuRjcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Update private_mem_conversions_test for in-place conversions. In-place
conversions support is detected in selftests with kvm_has_gmem_attributes.

With in-place conversions, specifying userspace_addr from some other memory
provider that is not the guest_memfd associated with the memslot is a user
error, since KVM will only use both shared and private memory from the
guest_memfd.

Hence, when kvm_has_gmem_attributes, only test in-place conversions with
single backing, where guest_memfd provides both shared and private memory.

For single backing, guest_memfd must be created with
GUEST_MEMFD_FLAG_MMAP. Initialize the guest_memfd as shared to align with
how memory would default to shared when shared/private state was tracked at
the VM level (the test expects this, it was written for
non-in-place-conversions).

When handling a hypercall to set attributes, use
vm_mem_set_memory_attributes() to send the ioctl to the guest_memfd instead
of the VM.

When testing in-place conversions (single-backing), don't allow the user to
configure src_type, since src_type will be ignored. Don't use src_type to
determine alignment for rounding up per-cpu test memory size, since
guest_memfd's backing page size is always the system PAGE_SIZE.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../kvm/x86/private_mem_conversions_test.c         | 57 +++++++++++++++++-----
 1 file changed, 44 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index cf50e9a332c5b..33b610383693b 100644
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
 
@@ -352,8 +355,21 @@ static void *__test_mem_conversions(void *__vcpu)
 				size_t nr_bytes = min_t(size_t, vm->page_size, size - i);
 				u8 *hva = addr_gpa2hva(vm, gpa + i);
 
-				/* In all cases, the host should observe the shared data. */
-				memcmp_h(hva, gpa + i, uc.args[3], nr_bytes);
+				if (kvm_has_gmem_attributes &&
+				    uc.args[0] == SYNC_PRIVATE) {
+					TEST_EXPECT_SIGBUS(READ_ONCE(*hva));
+				} else {
+					/*
+					 * If not testing in-place conversion
+					 * (dual backing), the host should
+					 * always observe shared data, since the
+					 * shared memory is a separate page.
+					 *
+					 * For SYNC_SHARED, test that the host
+					 * can see shared memory.
+					 */
+					memcmp_h(hva, gpa + i, uc.args[3], nr_bytes);
+				}
 
 				/* For shared, write the new pattern to guest memory. */
 				if (uc.args[0] == SYNC_SHARED)
@@ -369,20 +385,29 @@ static void *__test_mem_conversions(void *__vcpu)
 	}
 }
 
+/* Align each vCPU's chunk of memory naturally to the size of the backing store. */
+static size_t compute_per_cpu_size(enum vm_mem_backing_src_type src_type)
+{
+	size_t alignment;
+
+	if (kvm_has_gmem_attributes)
+		alignment = getpagesize();
+	else
+		alignment = get_backing_src_pagesz(src_type);
+
+	return align_up(PER_CPU_DATA_SIZE, max_t(size_t, SZ_2M, alignment));
+}
+
 static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_vcpus,
 				 u32 nr_memslots)
 {
-	/*
-	 * Allocate enough memory so that each vCPU's chunk of memory can be
-	 * naturally aligned with respect to the size of the backing store.
-	 */
-	const size_t alignment = max_t(size_t, SZ_2M, get_backing_src_pagesz(src_type));
-	const size_t per_cpu_size = align_up(PER_CPU_DATA_SIZE, alignment);
+	const size_t per_cpu_size = compute_per_cpu_size(src_type);
 	const size_t memfd_size = per_cpu_size * nr_vcpus;
 	const size_t slot_size = memfd_size / nr_memslots;
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	pthread_t threads[KVM_MAX_VCPUS];
 	struct kvm_vm *vm;
+	u64 gmem_flags;
 	int memfd, i;
 
 	const struct vm_shape shape = {
@@ -397,12 +422,16 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_v
 
 	vm_enable_cap(vm, KVM_CAP_EXIT_HYPERCALL, (1 << KVM_HC_MAP_GPA_RANGE));
 
-	memfd = vm_create_guest_memfd(vm, memfd_size, 0);
+	gmem_flags = 0;
+	if (kvm_has_gmem_attributes)
+		gmem_flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;
+
+	memfd = vm_create_guest_memfd(vm, memfd_size, gmem_flags);
 
 	for (i = 0; i < nr_memslots; i++)
 		vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,
 			   BASE_DATA_SLOT + i, slot_size / vm->page_size,
-			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, 0);
+			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, gmem_flags);
 
 	for (i = 0; i < nr_vcpus; i++) {
 		gpa_t gpa =  BASE_DATA_GPA + i * per_cpu_size;
@@ -462,6 +491,8 @@ int main(int argc, char *argv[])
 	while ((opt = getopt(argc, argv, "hm:s:n:")) != -1) {
 		switch (opt) {
 		case 's':
+			TEST_ASSERT(!kvm_has_gmem_attributes,
+				    "src_type is only configurable when testing without in-place conversion");
 			src_type = parse_backing_src_type(optarg);
 			break;
 		case 'n':

-- 
2.55.0.897.gb25b4bd76c-goog



