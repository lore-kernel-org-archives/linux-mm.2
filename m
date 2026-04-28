Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E89A8FF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6059E6B00EC; Tue, 28 Apr 2026 19:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DC716B00EE; Tue, 28 Apr 2026 19:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3A66B00EF; Tue, 28 Apr 2026 19:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 412DF6B00EC
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:32:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB7158D36B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:36 +0000 (UTC)
X-FDA: 84709548672.02.5206051
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B916814000D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MhCaGfkS;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418734;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9CWELMWi2PT/ZgfyQlX/nk78CZTG6z354zaSV5z9XC0=;
	b=qwGARLevvV30Y5qVXtZgEpjdolZ4UjFdnXzLQvEQMtTPlXAu6CFV4HgCFOn+ltQTWuw80Z
	cwXI6x9QaY5E9MVIJNnlgY1qeZWqv6lU3fViu7syiCwVi6dioF+fyz6KVoM55k6pFim4CK
	coqyVppVC06EWUrhx3Njk7JbsFGK7B4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MhCaGfkS;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418734; a=rsa-sha256;
	cv=none;
	b=mvidZ9kRII+uo1QtOj387vDb1cWRxYg7UkVT8BbMG2De0aeAVbiKWCUj/vr2gA2Gh3ZO+b
	qbgfch1Z+vtOFBAI1Cb+HKMu0bnEVSyljwk0H11++DuiLXwlYP5BAVNrXswb77maOivfOb
	4q6kDAtqU2sd61cxrMVITVLc7i1G1nI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 30831444BA;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0307EC2BCC6;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418720;
	bh=oaMCVr675WJC546KIj/mKMjwWvZZUtAMLOTjcjvW/Zg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=MhCaGfkSo2e0Gx1wfvAoSnhHc+4VT5ecU+eVZ/vtVAio4FyMM1MQiJebO9BrKagrC
	 DXFx/CFhL29aDunYDYpfewVQ3Kcm5C9Vh7vOJz0jPyoVWSJZNei979sHo2FU3779B3
	 hszG4qs2ZssVUAIRRtom2lCQ7Z2wlpWgWCu1NSbAUI0jxS+AA/iWUbTsIudcE45TNZ
	 D60St3rZWyjumZDKxD5ICUOu2qr4AFy7V2LZnz+K4/8xHEt85g2jq/ncUHu5qyd4Bw
	 TXikXygO7GVg6BtIGG0h7yZTfG+2wup58/Qn9FtZU9jP11vqtSHkI4ioSSsTep+J3z
	 x/DFudyL0eO7Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB594CCFA13;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:28 -0700
Subject: [PATCH RFC v5 33/53] KVM: selftests: Add helpers for calling
 ioctls on guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-33-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=5522;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Zmzepwj0e0uEpvYD+9DInZXExTZ0/J8Xq30KnpI8mbA=;
 b=WLwccZvFc1hCrzmS+LvCeTiboGB43iB+VTrZ0c3nbl0lNS6dz2+yJAg8q+WpCndvJ8J5zsEhY
 wuhBVOSWSDFAaKh15J/o5yGY/95Y172ex+GGyvsxHevl9jj/bJCUyV6
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B916814000D
X-Stat-Signature: mwipcxkkk3weyrhfokauxmg7zx8gq9wq
X-HE-Tag: 1777418734-802082
X-HE-Meta: U2FsdGVkX19rDrFx5QT4bPl0cRnei4mGU7DOAG7o2LPWbQ5u35oZJS5pH5S6UW21zj7t+C1zvHY2ZoV0V0yws/NnKIoeMgunAVeeF0aKM6uvFcWZYan0xtqA0kFrG+sMXHPfYcpqEd36szYhyux9xw2OTXif5ZgGjnrPUZzfDbcvfNbCYe+GbgV+o+TQkYRrnz3/HVQt2DD3Pm9CD+Vnh41bwC7fKEuyLt+OruaFO8w2eCWcSna5s+RS6n+eOY1iqEht3Dh728YMV1vz2PBj7ZN4L4aAL2m+QJ8ppJKaBz+AzTzx7OvhqSfzyOilHv72N/nmOAz9HfMugPRNcqAp4+bcFnUOH3fqgzkBuc+0A+sr2wJG+iE/1m56GhZYEenUPUaE4bmicIgSIaPRV6pNqY67rKap8InbHfqaB3ILd0E4DuPLXvyKY+zvmqRcAmW7aLkJACtXA1uFCQwTS/Vc1SUIzbFzF/PVeJ4u63zubNHFwU15U8edmRdpuvdpK/VlrmhukE6yCrU5fPrfbLAmpcXsx25jcvJI+PZ+kilqzIk0E+8QwMyALUhNmW2a2qJvnHl2BGK50cxD9qz5JzDkVJfx3hIptus+nMO59Xt0Jld9GYCRsduWWGBmylIAepBbfpaGaVyYDFQsNgabkHeeAcIKPwW3JVRv4nRoA9Wy7YZ4w92MqQX6iiG0ecOP2FwkcXBPw8G4exuHimJdOdRdjX4F7VUAIfTqblWKvS/ApGQndq2swTS5NU3V3XfLcf/dK2J+5MOnejq5DTjSyU5dmzv4EfzgRxcBhhKStot98foFd1knBD0H/XISXNeY3MUrREkM6WwEzlkGdCvisEpqLzawlwpcBn7XoZF4L2OL1lBr6a+fwfYjAKWt2zI5Y46+trc3BMFntd/kEuNSCRJnyMUs3cyZf06I5NXd6gW569pWk2lKwaWyDxhWxzPfKJaDNRQ7GOGmSWgSV0tr9AO
 0q1dGtdZ
 7GbxteBCwWNiWzZGV0X8To5F/9qCQwh0mA/4Pmhai8ODJL2zEtKT+ZyHj7oivWRhgqY3mW+SKEJbBPLMnOtNHKeeLNS2pW7zniG9TEe5dGMz7ZR+h87ejsfgMxSy8ExTYpDgXQ8uHHtjQBa/zs46CJ/qWwK7kDq7r36qhOBTs6/756e8UodE+71UHLifRf3qB11tyuObXxYWTdO4QMkUCUkdfkjjgcEdlUnVdFbkWKxFcEhuvmTlY8QUL5m1aklKoV+t/17viZ7cs9BS11zFPa3AIlg3KbHI135BCXs3uNuH4iq1LkgJ8D3C9+lRwj5nHqfleFBmWjHOhw4+6PkRBkcvSogTaQ2KgdRDJPwB7Uoqm8lEbqI27bx82LjOHCi76wrcEYl2e1V2KqSlcCFQATm8lTrREs3xaEd+ARINkdhUtfbMLLa0uyaLFGNyq68pPC1AdHBZqvrTa2Aupbpjc+3tBkQ==
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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 98 +++++++++++++++++++++++---
 1 file changed, 90 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index fb54694e6568b..62d917a2d2b19 100644
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
@@ -451,6 +463,76 @@ static inline void vm_mem_set_shared(struct kvm_vm *vm, gpa_t gpa,
 	vm_set_memory_attributes(vm, gpa, size, 0);
 }
 
+static inline int __gmem_set_memory_attributes(int fd, loff_t offset,
+					       size_t size, u64 attributes,
+					       loff_t *error_offset,
+					       u64 flags)
+{
+	struct kvm_memory_attributes2 attr = {
+		.attributes = attributes,
+		.offset = offset,
+		.size = size,
+		.flags = flags,
+		.error_offset = error_offset ? *error_offset : 0,
+	};
+	int r;
+
+	TEST_ASSERT_SUPPORTED_ATTRIBUTES(attributes);
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
+static inline int __gmem_set_private(int fd, loff_t offset, size_t size,
+				     loff_t *error_offset, u64 flags)
+{
+	return __gmem_set_memory_attributes(fd, offset, size,
+					    KVM_MEMORY_ATTRIBUTE_PRIVATE,
+					    error_offset, flags);
+}
+
+static inline int __gmem_set_shared(int fd, loff_t offset, size_t size,
+				    loff_t *error_offset, u64 flags)
+{
+	return __gmem_set_memory_attributes(fd, offset, size, 0,
+					    error_offset, flags);
+}
+
+static inline void gmem_set_memory_attributes(int fd, loff_t offset,
+					      size_t size, u64 attributes,
+					      u64 flags)
+{
+	struct kvm_memory_attributes2 attr = {
+		.attributes = attributes,
+		.offset = offset,
+		.size = size,
+		.flags = flags,
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
+static inline void gmem_set_private(int fd, loff_t offset, size_t size, u64 flags)
+{
+	gmem_set_memory_attributes(fd, offset, size,
+				   KVM_MEMORY_ATTRIBUTE_PRIVATE, flags);
+}
+
+static inline void gmem_set_shared(int fd, loff_t offset, size_t size, u64 flags)
+{
+	gmem_set_memory_attributes(fd, offset, size, 0, flags);
+}
+
 void vm_guest_mem_fallocate(struct kvm_vm *vm, gpa_t gpa, u64 size,
 			    bool punch_hole);
 

-- 
2.54.0.545.g6539524ca2-goog



