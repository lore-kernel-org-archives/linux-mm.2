Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF7D710AB82B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AC646B00E3; Thu, 26 Mar 2026 18:25:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7818C6B00E5; Thu, 26 Mar 2026 18:25:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64BDB6B00E6; Thu, 26 Mar 2026 18:25:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 546B96B00E3
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 282ABC4099
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:52 +0000 (UTC)
X-FDA: 84589647744.23.D50124A
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4966520003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D0OJ0fIB;
	spf=pass (imf03.hostedemail.com: domain of 3bLLFaQsKCD0Zbjdqkdxsmffnnfkd.bnlkhmtw-lljuZbj.nqf@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3bLLFaQsKCD0Zbjdqkdxsmffnnfkd.bnlkhmtw-lljuZbj.nqf@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563950; a=rsa-sha256;
	cv=none;
	b=uy04mxAzgNS28ek/H36rMTti1HXzJqL5GFLKYpgbk23y8nrE87KH7hUk+eGCSnyFazfcNX
	d7Wo0aePCZy7HU5BgCWN5cI+s7q9YOInhn6XzHBIWB0Scwo4Uey1YYJWfuS7KsA9sMmsIR
	lQuT8UdwetWSQ+jMpG1MQ5V/HhzmAeY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YsFx8S2ZIsHTA7mxdUPwMmhoKs9OpIzRTtvg/d03faw=;
	b=4YjmWci0XbJs10ziHOgop9NFA+qOD6xbHoWyM2PUVzj5VNm6qaVHUyvzwUoNffRraIYG3m
	/IFWl1T4IVe50A7xvRX5/pypgzhrA0MB69w1SXIc9cQuGQ/I35NMcspw82xJ0hbO6Vye5B
	EUYO6nJLVCKDbQA9oDPA9ERCUc4pjbg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D0OJ0fIB;
	spf=pass (imf03.hostedemail.com: domain of 3bLLFaQsKCD0Zbjdqkdxsmffnnfkd.bnlkhmtw-lljuZbj.nqf@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3bLLFaQsKCD0Zbjdqkdxsmffnnfkd.bnlkhmtw-lljuZbj.nqf@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c737b6686ddso1031036a12.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563949; x=1775168749; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YsFx8S2ZIsHTA7mxdUPwMmhoKs9OpIzRTtvg/d03faw=;
        b=D0OJ0fIBaMc2blMBvKlIjIIi/Ch1Y4spfOrbJ4G01IsjLcwRNHoISJ/rcqosYXCxkv
         HP5n+rSs6rjRVrPaz/WsyAIi1U9Cv5AVJzTAUXLmOkNl+oXjWVCvBIwSvq1X+n7DSpWk
         5AnCgEVyoRKTpkzUZOi1F+wSAn/qoX8R00e9AR6Pavxq1B11PD1S6DyVPPU7WV/qWN6y
         7OItBB2lI+Qt7f+77xjSWeRD52IdYSyoH9AQ6YcCetdgdjiLvqTSVlED8eFYLh8ulJcZ
         XA8sMj4aJHEJrmagtjDflMziqoJE3Q7t2U3f9uB9UI0kK43NwcQY679/zv571RyK8yoq
         CFkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563949; x=1775168749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YsFx8S2ZIsHTA7mxdUPwMmhoKs9OpIzRTtvg/d03faw=;
        b=ksMN3aEasrX5iDoZcRXVTwi+lE8ZcjElPNuG/wF+RqQamR75fcfD8LDeuAx1OSKYpk
         oHCD7D6RWciiccanX/P5NRx371SxfJHnL9XYsZXBM9TwDuYr61E1uc1/62GfQOW+HlW8
         jID2G1SBzjzu/ZkIKCayz+g0Y1efzPdL5jI318S4VF0MSZ8ugj1+jIFktiFJ/V6eQ1Hi
         XEv1INDJYsuSZ7moyaYEYr2V8gQXfF6hmMsv9HIW20vEpNCAg2SK1QGp30Bysq7VhFQt
         y9Yu0yf+WC/1UFQrrcvGXGyEs/IIYcxztHT5E4X+vbJkOllTTZhCVJ9zumazYVP1I67C
         SpQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNd/+p2CQ9FeL8YWZwv2rRsoiyj+dntlqhBx3iybG9VKnf8ut2hoYSw/nE71PKvRVGHash0ygLnw==@kvack.org
X-Gm-Message-State: AOJu0YwCXl2IWfioR7xVXXKezpc4AOF66Q/ttzd0b5JDjGBewH9mnZl6
	4NVcNSYyYibhLGgnu2DACRETMN+DsZLvh9Aw/cmri+g4kRkkizz3EZZ6n9E5EW5zitdNgUTGWDh
	/CXN5aZDw46MwYczDLLXolU6gyQ==
X-Received: from pfwy16.prod.google.com ([2002:a05:6a00:1c90:b0:82c:6e7c:ac6d])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:b488:b0:82a:60ad:874 with SMTP id d2e1a72fcca58-82c95e9ec0amr174041b3a.19.1774563948768;
 Thu, 26 Mar 2026 15:25:48 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:50 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=5336;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=atM67lZrb3L/4FSuzE/lIWzYT7CU6pwH5U1B0OOVyHY=; b=5MuqTkb5deqhYAPqYmfVeS6JWQaZBgzlViovjh0d6q6SQRu7C3TxjQOxMfoLP3N43SByS4Jw5
 ZnxOUmxggc7B4jsUWt0qDmE7eGPO++o93Lfuw6k6XZIImuFyIUiBC0X
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-41-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 41/44] KVM: selftests: Update private_mem_conversions_test
 to mmap() guest_memfd
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4966520003
X-Stat-Signature: ms497ohxcm7e4o6xrhp7uxcxbjs5ebcp
X-HE-Tag: 1774563950-697523
X-HE-Meta: U2FsdGVkX18gZfz3JodfvIRHHxoM54+C2So79hrglJzXIEL1CQ3TbGVWG4F+m2wBJ9a/MG8ab5M9l8ns7rK0b1MRZ4dJfpge8Of3S+NbuB1/qwHH/JoJ6LtF9AF+kJL0tQu13ayu2PYeS9m0uIZ8vQjVpdi7SmMSvdESD2op6xBoWb+sVBU8rANTwLu7VsNF0yR3ej1fnqZkcMVTHbqfC3cP6RrUCfWkkO294gdpR3tWYwkGIGhOPJDYEa3M92P4328fw8IZEJB0euWMRVp3ezFaIskhsWAj1/O16OEc6A51214EQkj8iYaTxtvHtvNzfWnYXh/1FgNHT0AlNzHvbWb99LRmW2G0ec+lmRT+1kuzv2tuZ5oM+d0B/R/SxhlVzaSRdq1iqAZ8GMNIdt8TCXzKoy4jSBTUxrFGXqBYNkuraosEhjJaiySKiLyfjdCJJgETtNLb/talmXJNbUySEn629yiFQ6cnyS29kjaglvwSixMHa2y/CmDpfYyH5ji9C/mKNsui+nVwt8kezRyB/p4Bs0fVnZin+7pnpz1LTjHyCA9lPmOkiDh0rfrIFkAqaFrtcsagaQFu4G0NRoIFfFH9ciwwnRcc5oH2gAHEVFyh73gjxUGv3t1owHWyKQYOeHSQeyfYv5tKSNgoL/lPxvju3zQQettHX5bBubSbYcYDDHTXCd1K9UxRz7HN2pST6AAgGOFzdegqgBuO5/6wMakBXmGu26+Aig6XMYqA2aINwzSMFq5pmW2z6K+lFjaEbKWMv70cPCbShk8IdFuvKF7wS2OIDF0/BlgOuEq49y2D2ENUr56DGe9lZk0eIPRvakAtj/guXUH4Ir9ANdWB/HSwBrUnxrJq7/XEjJ8n9npnTussnc+Xk2HIS4NgcHvvv4quVtw0YWDL9jbxRyitfQSNZSEdO6vNjCgeZoqXDXjPbJqvXW0Xg9YIaTkDAH3EOJ4uQyqcF+OSJJ4LJQn
 ToT4FcFz
 5DAlnLhwP9UjCm5r8vWUZLFbtnetD6zdr8Voq5OhMJGc9mBFFdYLFAnVP2hf4K+CZDY4MryBu57Lu9OfLmJdQ1fwwUOnfm7R4XB+uTeniDZrQqKGgEOpJAxUvIVp15TGou75nPtwX+9JHDLwBAgu/TEqHGftF4/7b82hq6YSsij4Wkm9NOVcEuC2ipfGO+Gzs0CN4c2ITSee3eDOeRB1FVzGtbEUBArKdjQvCaRxwN9dkEP2ACBkBw2X8ZEwbPmgr9cM+bsL4ikFQ7rhPHes7XfhFLShTH+EQLRTXUDQct8gM5nlpyXbLDUnQBmELbpZsuxK980a9OL7zUb43HoaiSvqdv3UiuJcKg2WhjL1N2v5q63khcqq4lMfpFAeuBLRTNN8WsNHEI2OpQz8NMI09sZ4rKFEYnJXrlrxl15W0LBm+vMdYAtRdfchD+GDB+nu6LlHkvR0u7WCkuEZKGO/JXL82KRGrixGPis3TknxeRnDuMntkp0k/Py1EaY0Mxwajnx2Y85y88aT+siJ0goMV+FD4xVLuk4SmrpukVh2oJ2IKHvvAIWSg5CuLH2gI6aSxd6LlEvg6qInF2Zppn1RtDFeRplw2VXxd6GQnjc6AeUvbVEo/MzYedgGrC2WDIetdXetn5C4MXWWfI3s+ty7UGmubSBJ6A4DCv+mXXanV7vx0JM5hS+xD767iKQyBbqApHJkgYu/LTWp5yjwm5Do1Wm80ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index 47f1eb9212591..29c3c5b2f538e 100644
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
 				uint8_t *hva = addr_gpa2hva(vm, gpa + i);
 
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
@@ -382,6 +399,7 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
 	const size_t slot_size = memfd_size / nr_memslots;
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	pthread_t threads[KVM_MAX_VCPUS];
+	uint64_t gmem_flags;
 	struct kvm_vm *vm;
 	int memfd, i;
 
@@ -397,12 +415,17 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, uint32_t
 
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
 		uint64_t gpa =  BASE_DATA_GPA + i * per_cpu_size;
@@ -452,17 +475,24 @@ static void usage(const char *cmd)
 
 int main(int argc, char *argv[])
 {
-	enum vm_mem_backing_src_type src_type = DEFAULT_VM_MEM_SRC;
+	enum vm_mem_backing_src_type src_type;
 	uint32_t nr_memslots = 1;
 	uint32_t nr_vcpus = 1;
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
2.53.0.1018.g2bb0e51243-goog


