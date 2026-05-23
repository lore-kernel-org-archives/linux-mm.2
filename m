Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CDE8CD5BBF
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E3FC6B00B8; Fri, 22 May 2026 20:18:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 147676B00B9; Fri, 22 May 2026 20:18:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 035776B00BA; Fri, 22 May 2026 20:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E55F66B00B8
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE0151C06F0
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:16 +0000 (UTC)
X-FDA: 84796772592.30.E612AFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B030540009
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N6swOKow;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495494;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FVrlIzVzZhXlvW5B8/mqGZI5XI0m0F7NNZJwDKS+mpo=;
	b=erpXghqsfeR4R82/94zmB34VkMlaaXcbXiBF+8LbMQJrO1GfxSfxTF3By7kGDb+Th6Q5jn
	NUGDHioNd9BVgKs0tKrnH1CMnJc6JdNy06iVNMpE00Q90uptuFALCxSJ2xPsm8wyP/oBm0
	zQn1qZewW6xFCTzYg3+y2HBUL72SKxU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N6swOKow;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495494; a=rsa-sha256;
	cv=none;
	b=TDzT5qEsu/U3DWnzafiGDvblOJa/V01MLvgWgvJ02LuFhr5c47/lygLqLVEsoOSB4i6ZYH
	RgXZz9sD79UvJR5XyH9ys0BFhKdbD10nCuGgT7ioh16j+Z0T5LRr//tBQ8H16kPgfvhH7l
	1xtnO0Zj27TCq0PY535g4iY4vXGaRE4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 216FF44615;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7EC40C4DE0D;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495485;
	bh=zVhi1pyMQ0pIjuaAO0Kw3IrJ5dsGrqNxt9jbqFPYF/E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=N6swOKow4RcP0h6SZDuxXiib1Qpj/+tfWup4aRxYgvHVFpDvlgFxJbg9lbV0EK3UJ
	 ce+7mnn0TJwbbGFPpX6cmxtg9qVwMF+c2FoDxUZ2FccUeN79tU6U+THgxho2M3xidf
	 ClI5uBWeHHaLIJFRFxIwB1qDcT0Pc5+BBU6cWarTXUl6im9SA8qchlcx2roDlH8jC2
	 y9VcxkrQqcBQEPPWeL2QpAn7Z7Fvh9z6+RqNOo/TiwpjpKZV7NLLtCtAXFgquCjMyU
	 ygg6GG3tqG8fBZWZD6aGZmua5nsbzy78lhnlpMBcgf9OtrTNLaJTY5g+USH4ebVQdj
	 NiB15MFwyJ7Sg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA0ACD5BBF;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:08 -0700
Subject: [PATCH v7 26/42] KVM: selftests: Add helpers for calling ioctls on
 guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-26-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=5283;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=McA1AmIH7E91D/QmRpzIgrP/vCm1rSWJ4IIkDTz7ZMk=;
 b=dcVKIGI5IbuzO/7Xq3a05QtEzwojtGJPg4W9rZhWf6GepzUQOYzvADiUVDFrPj5ul0IuTMbWz
 sNM+iJj9PZpCMao+BC6NvAoMIXHtxQOPQNbIbJuooci+7PsQtaFXDVL
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B030540009
X-Stat-Signature: 7mh4eqhgybgqgo4njpw3bydhpr8crm71
X-HE-Tag: 1779495494-712261
X-HE-Meta: U2FsdGVkX1/X+FgDHkPijQ3SFs9dG4NL+shlUugGrAR/GhdHzu4FAfZYFcM/eZAAIvcfTMMYOQrjITP/0sD88zVt0rfnSqYqfUMbYAE+6SGfYJgSSA20d+lP4yoA8H8FcjJiWVLlGJJCi74wAyUHr32NO0EfLEG3Wn383uVPX16GwlbvIyIzjee266jkcGq4EySp+eXZ+0/+4yCFTi77+eA0pvdXy/qnZ8K8WEk5qsMFivIs9sLVgOQCfTKIUqcEWHkvxujASzvIcytH8lZkr4xTCth0YIh1VDwHJlKOA+blb4ZglELILSAqFjKzBZmRpgIbiEI4sthO6XFl99eDwAInW5GZsAbebrGoo+raLSl0+U5MjO0G7Wkz3ib/b+QhI3B3mvRLUOB2BVOSBe+OsS1DxHv67oPU2PE5NM9mxhvha8NDTXXuLbgAAu4WxqVwbfF/ybbutoBnhoXPnxmRO7xWdgdGwgU+Z0VYn8hIPhivYaR//ofpSBKoz9W72cHIdYeBQP1wmBVqPGr0Njd4fDcJMfyS6XPdzR3E+O7fh0HdH+gTSHWGhGJrPy9505M8MGrKVxZnlCaFeTo4uWu1TjY3vi/LDrUM0OhqI+u1q5eNfTG2pl927Kxb0xIxi/u5wGekYoaqAQEdiWOMga8eknPgnTaSqvIq6pFupOg5Q2/Q1x9rnxOFfBTxlNW61F+FfEiAy64+N5VJ5m5zLTyhkzGLFQz5yuq0SD1kfn6nTCeI7hdAIByXYYLZIJy2U/6vV1LoHhVd2eBtu80ozPTq7+Ev/qLXvdalYrdDhVz3+IFnTxmr77RP9VpToG16Bs3QcVZfYFf0QFuuAjkbEsdEOKi3XTPTM/qp63p63GqZrSt1XckoEm+DfUjaerTJmpiv3Y/23litq3O1q/OMDToqSKu27G7hFGP+DkwiBe4Ulyu5oV8FvI4bLv63gmWckULXLpPRJUxAtDilBwFxSwC
 fRIeC9zB
 lsX5BbmT7ZV0Rmd1JpiTrL1XclKerb70i3G0pbxWigCh0hW1uKjofByG5ehqlAfVMKOPk3biUHp++fZD0O80OnYeAzEGBvy2pWYyV6S55kaERWaZOps454K8sn11EOjaAPeBYhyQzgAGbzAAx93CFxa55xYxFH3yYn/3YdQ5tQWkWEMP0DvZTR8uOc8am03REsnZNUxzouYH1Y52YHOgqLV+yQMezEaPMiqd40A7CPVJnXVE08jd351DBXg6tysW+PTWuMze7fPhvS4LjJTmidKANnI5sLXF1Wmei+7U+uBhnUrCz9vqojC0qPlrFjCV7E4TA5+v6In5fkFQVqb0hH1GIkQOaf7iYc80QgO1GMWBm6ZzbecdDsIkQ3VXiQt6Ir36E9mU6JUwGu/4bCFEd0s4vH0ETytZOizXRWMw8Lwps3w4etZRXW5hRfSMI4Q6ktwJRXjro8tLwELlhBx+++T83NA==
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
 tools/testing/selftests/kvm/include/kvm_util.h | 94 +++++++++++++++++++++++---
 1 file changed, 86 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index fb54694e6568b..d4c285c6fbe44 100644
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
2.54.0.794.g4f17f83d09-goog



