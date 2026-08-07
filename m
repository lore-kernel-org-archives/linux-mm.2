Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00B5AC5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35F6D6B00D8; Fri,  7 Aug 2026 17:53:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313426B00DB; Fri,  7 Aug 2026 17:53:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2001C6B00DC; Fri,  7 Aug 2026 17:53:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8AF36B00D8
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:53:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D361A0443
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:02 +0000 (UTC)
X-FDA: 85075824204.20.70A4F17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6FEE040005
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=byQXBm9C;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139580;
	b=vVjVm7QqMTl0qMfk/lTYesTCoPD5W8LL6n6G80Wig2eC/sU2TuECsKQh8d2cP2l0CwyNh2
	UrdfkYh10W5ZO88PaXEbz58H6zGwoTcolaCeddjWhNKkzC/zQSsnYFeCjYkELoGOZ4zHdo
	NdlHr8CSQx3xjMqYlJnQEakguIcPnLA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=byQXBm9C;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139580;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YVkII+UKZzQfHQ1qTCwLGP7pKzn7POScFkcRqirj8k8=;
	b=emH53UuXxBajxSEMFKI3uhoJBxUg+6x3Rjrn+c5aCjVrSPoZGd8BFjwkTn/m0GD4q4JymW
	bVxX3iIbYAn/BIC8lxlny3W+BET8BuTAz7xfyuU+DfIDQzShWb3yj+JarA9orUusDSA3Vv
	DrY0xXL57+F/0ZjVcOHafbrHMhkn4hs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7CD4C44DEB;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5896CC2BCFA;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139570;
	bh=An4LoFfCbfkYxKMIjD8JecRW0dhBJE2uKbwzXFHa1d8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=byQXBm9Cp6SfRJKQQFLpngbooXY0gH9fn5S7Fnp9O7w+lkiNB4RC2R0i1S7xmUT7o
	 vnDq8WBqmbBTFt0qTHuJzko2TO2buKIvB+uKgGXAnLs9EEEMxVeQH7rPjuvfp/bK3B
	 fotVUr2pyldGx8bCFLz49dXAjCQpg6eUDjPFBu9vA4gmbZIN6Q8TWgGsFKi1ydfkjG
	 0mmoMGjW9W8nd6LW2p0VqoWMKy6fMtuu+Uz8JignkWvCPL7iC7UYS4h2sOAPfU59wM
	 U3L432szzaTGgs0QrggBQBZPyhZHUQqFoOzfVfTLfVla+XSx05zC3WO1yiidOhi60R
	 s/Cmb+QkTUddg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 401FFC5ACD3;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:53:05 -0700
Subject: [PATCH v10 26/41] KVM: selftests: Add helpers for calling ioctls
 on guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-26-2fc18ee6d3ba@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=5371;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=8UvBMuLdULVikAkOmOgNwZEpUmR3XOSiX8ZbtcAA7h8=;
 b=id25AOQXYxAU2fhUjboBx62DxhKQXAQhUqYPjkGYJ1lwXkIzB/jvotUmYQOqQKMcvazqhW/y0
 NAlz2QlNDI6CSuUTnGjy3NDs9O45/NCcRJiIRR/Fhqh+bcOCvdhIi4a
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6FEE040005
X-Stat-Signature: 1bbxrhyu14d7995hqhuxyzwc1d3rzp83
X-Rspam-User: 
X-HE-Tag: 1786139580-11747
X-HE-Meta: U2FsdGVkX1/vCg2fc9eFK4E+yATN+75sqKry2+B5FuTsDCh93M2c/rm4c8D3Mwu5TVpbnfT4Shf4Y/6bTiY9T3MOt1Xod7kexqQpLt7lu15NgOgyCkYWlS73RLskaRNJZ935Dka9nuy5KdkwPONezvXit0HNWwvhBUG76Q8ZQDRUQbM8zRfOXE/ry7HOUnYvK1P/F0dRZ1+oBPjLZiYe8JeVJnJp20KGRJl6Pha41H4OpOsOt3rOiJjZbeVXsYbLQ4CM6zH2tyz3QNZpsCxy/cvw4yfz7dJK1fKLcXthxZAf8//s4MdwIru1okSTm+II5pmxs836eT/xAF2QoDo8t9H1iJKFajQL6Z0MH5ELIgdTfzjkXBsu23178iLu1Pb5PeA4vOoBvPDOhkKbMDmqH+sJopHjjlIsLKiYNet513lYYOJHlWmTEp2Ai6NUrn+otRXqe3y1W8ntiG2zwrRrDEAikLP18pg2KFn5vqJMwQkhplKVHWfmAFHq1SS4PO2rUpbDTNAAz8+Al1rbbgVgMgMkdIwlzgOCnDvz4QcF56O2BYl1pjewYExCwHlEmCEZQy+lEaGIt7q/groV8xEnP40uDbCztZw61C4KcYX4Y5OwJX5Sy15nkXY97G7RnF31z6w4iCqJM1l9C1ORpH2NqnxuR7x6vY19bRRRqrn5RE55Ces/fWGAA1IqAejJWTCJ/JtB3y6idcN6lpd/Rsg39YvHVCnGQdaeD11Tte9jJt0hnZLYIFDJWimQmgwJe4I8fUoev3/ygxvS8/wyGslQ+PnN8y3VFTiLH2aVVPZxqAYwrJu424ARybKr8++m0IaHNFKhA3aDPtPNL6kp3N/xeerO0B2OMMre1LIT58Hw1CfdYWD4bFyTZtP+gXqy6hHJ//kc9P9igk0D9zxAUtdsGfKmxZD9u/ozIphgtBX36/9rMWcjXgeASFBq3/dse+uXw98XLQ+0J333xtQyk58
 3hH5eSy1
 JaB+2oT/FuQuofHyrn+V4zVXRNLycpo37Xla91EfsROdQzU1Gs6VVKMYh5YyrPryv0NQIWgJepVDHeiAa+eJZdvfumYdJmRnc8jspXDUsweRoXICm5srP5/fd+Tf8YfK2YM1rIYdbxDOAUZ8XCpovY+1xH3MgsBN400Z5TkeUZbl/sxq3MRW929xMSDSJK2ZTlPznbV9vHayTwvs1t/VbkcNLL8cFMhBb6PrBQye9MYSrFjcWx2BcBfFHVtPKbqhmHSshpQ2J0Y6B8iYJNUHHL9exqxzu5nj5Wov5Nu8v6T87gHxe3f4BvVrkpOIv7OdnEq2gNiksNo2M1gp+br4kH12TCR8JZqe3rLP6H/8tZPIAA4ZhQaC79Jwus4abKirUeCFV7u3OGSs1ROR8kzvuQZQDkOw7H1tdkcV8pb24q72Y+dv7pN7C0/2UDURJk0DbG+4H87cKiIlzlvV1Rd470XtO1MOoTNd8DD/WAoKTWp066wd9hdY6nTahyAjeqYZYRWKDsRa+p1a4hPtBgJqzAe7foqTVsaTi+ONefqF8DO8pixEm0qpW4KUDpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Add helper functions to kvm_util.h to support calling ioctls, specifically
KVM_SET_MEMORY_ATTRIBUTES2, on a guest_memfd file descriptor.

Introduce gmem_ioctl() and __gmem_ioctl() macros, modeled after the
existing vm_ioctl() helpers, to provide a standard way to call ioctls
on a guest_memfd.

Add gmem_set_memory_attributes() and its derivatives (gmem_set_private(),
gmem_set_shared()) to set memory attributes on a guest_memfd region.
Also provide "__" variants that return the ioctl error code instead of
aborting the test. These helpers will be used by upcoming guest_memfd
tests.

To avoid code duplication, factor out the check for supported memory
attributes into a new macro, TEST_ASSERT_SUPPORTED_ATTRIBUTES, and use
it in both the existing vm_set_memory_attributes() and the new
gmem_set_memory_attributes() helpers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 94 +++++++++++++++++++++++---
 1 file changed, 86 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index a091c495442a1..575032e9791d2 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -392,6 +392,16 @@ static __always_inline void static_assert_is_vcpu(struct kvm_vcpu *vcpu) { }
 	__TEST_ASSERT_VM_VCPU_IOCTL(!ret, #cmd, ret, (vcpu)->vm);	\
 })
 
+#define __gmem_ioctl(gmem_fd, cmd, arg)				\
+	kvm_do_ioctl(gmem_fd, cmd, arg)
+
+#define gmem_ioctl(gmem_fd, cmd, arg)				\
+({								\
+	int ret = __gmem_ioctl(gmem_fd, cmd, arg);		\
+								\
+	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
+})
+
 /*
  * Looks up and returns the value corresponding to the capability
  * (KVM_CAP_*) given by cap.
@@ -418,8 +428,16 @@ static inline void vm_enable_cap(struct kvm_vm *vm, u32 cap, u64 arg0)
 	vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
 }
 
+/*
+ * KVM_SET_MEMORY_ATTRIBUTES{,2} overwrites _all_ attributes.  These
+ * flows need significant enhancements to support multiple attributes.
+ */
+#define TEST_ASSERT_SUPPORTED_ATTRIBUTES(attributes)				\
+	TEST_ASSERT(!(attributes) || (attributes) == KVM_MEMORY_ATTRIBUTE_PRIVATE,	\
+		    "Update me to support multiple attributes!")
+
 static inline void vm_set_memory_attributes(struct kvm_vm *vm, gpa_t gpa,
-					    u64 size, u64 attributes)
+					    size_t size, u64 attributes)
 {
 	struct kvm_memory_attributes attr = {
 		.attributes = attributes,
@@ -428,17 +446,11 @@ static inline void vm_set_memory_attributes(struct kvm_vm *vm, gpa_t gpa,
 		.flags = 0,
 	};
 
-	/*
-	 * KVM_SET_MEMORY_ATTRIBUTES overwrites _all_ attributes.  These flows
-	 * need significant enhancements to support multiple attributes.
-	 */
-	TEST_ASSERT(!attributes || attributes == KVM_MEMORY_ATTRIBUTE_PRIVATE,
-		    "Update me to support multiple attributes!");
+	TEST_ASSERT_SUPPORTED_ATTRIBUTES(attributes);
 
 	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES, &attr);
 }
 
-
 static inline void vm_mem_set_private(struct kvm_vm *vm, gpa_t gpa,
 				      u64 size)
 {
@@ -451,6 +463,72 @@ static inline void vm_mem_set_shared(struct kvm_vm *vm, gpa_t gpa,
 	vm_set_memory_attributes(vm, gpa, size, 0);
 }
 
+static inline int __gmem_set_memory_attributes(int fd, u64 offset,
+					       size_t size, u64 attributes,
+					       u64 *error_offset)
+{
+	struct kvm_memory_attributes2 attr = {
+		.attributes = attributes,
+		.offset = offset,
+		.size = size,
+		.flags = 0,
+		.error_offset = 0,
+	};
+	int r;
+
+	r = __gmem_ioctl(fd, KVM_SET_MEMORY_ATTRIBUTES2, &attr);
+
+	/* Copy error_offset regardless of r so caller can check. */
+	if (error_offset)
+		*error_offset = attr.error_offset;
+
+	return r;
+}
+
+static inline int __gmem_set_private(int fd, u64 offset, size_t size,
+				     u64 *error_offset)
+{
+	return __gmem_set_memory_attributes(fd, offset, size,
+					    KVM_MEMORY_ATTRIBUTE_PRIVATE,
+					    error_offset);
+}
+
+static inline int __gmem_set_shared(int fd, u64 offset, size_t size,
+				    u64 *error_offset)
+{
+	return __gmem_set_memory_attributes(fd, offset, size, 0,
+					    error_offset);
+}
+
+static inline void gmem_set_memory_attributes(int fd, u64 offset,
+					      size_t size, u64 attributes)
+{
+	struct kvm_memory_attributes2 attr = {
+		.attributes = attributes,
+		.offset = offset,
+		.size = size,
+		.flags = 0,
+	};
+
+	TEST_ASSERT_SUPPORTED_ATTRIBUTES(attributes);
+
+	__TEST_REQUIRE(kvm_check_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES) > 0,
+		       "No valid attributes for guest_memfd ioctl!");
+
+	gmem_ioctl(fd, KVM_SET_MEMORY_ATTRIBUTES2, &attr);
+}
+
+static inline void gmem_set_private(int fd, u64 offset, size_t size)
+{
+	gmem_set_memory_attributes(fd, offset, size,
+				   KVM_MEMORY_ATTRIBUTE_PRIVATE);
+}
+
+static inline void gmem_set_shared(int fd, u64 offset, size_t size)
+{
+	gmem_set_memory_attributes(fd, offset, size, 0);
+}
+
 void vm_guest_mem_fallocate(struct kvm_vm *vm, gpa_t gpa, u64 size,
 			    bool punch_hole);
 

-- 
2.55.0.654.g21b8a5bc05-goog



