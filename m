Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66EEFCD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FF296B00B7; Thu, 18 Jun 2026 20:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B01B6B00B8; Thu, 18 Jun 2026 20:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE1366B00B9; Thu, 18 Jun 2026 20:32:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9E006B00B7
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D1701A02DB
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:03 +0000 (UTC)
X-FDA: 84894784926.12.1DC5272
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 32FBD140003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dkFZmLt7;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829121;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4720zGVs+oP+hia1XyMeiWKCNOWI1pJEGuxQXi+cze8=;
	b=FMRPN0s4GAEPE0M89HLENTbiBDM9oVKsKCy5uX8nJHkjdcsU27XrYebxiy2H3ncy9oQy00
	vIZVeaT8MzgDS9hXPaHJ52XcMnOhlrvwS0JC6VP933q1h7oyJ0fXXGqJT5/fNz1hsQ2dMv
	eay5L7UvZtEAbVW19pj6SkPnDTLgHms=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829121;
	b=pN96gr9IC2P3OsGjon9UcBfoSCpWQLlU88jUOrFwl484MTYfihdjjfp+P1BaScIg8RP1bF
	2x7mpY3iLCsC0tHi3v3P30/zPLFYBwUwhnRKVDvldu2yeeVXJYDv9lj5TltQsTmX3Fw89O
	j6h6dqA8qCYH8yaLTzfnG0hMXk1fSoM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dkFZmLt7;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FA0844D30;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2207C2BCFB;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829109;
	bh=6jO/B3B00thbpfn2aWkjG+JeqMZFu50P/2ZGaZX5oTk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=dkFZmLt7yCHyPIQNvZ3prPus9JfN9iQZ5LSRGNPS6yI1sgMy4G6BSuOOiDoQw1R0i
	 oMM8Wl1hPNpdAqIwm7lCHedjWMe9rUZg3RJ8e91TduhFvCHcaIsCqZqN6QJu91mdGE
	 RLbJ27If+4PMeqv4qv7HFc/yE3QkJdyu51QlNqJgvwMHnYtUB+Bc2saVEO2xmsnbgv
	 7vF9Wc+dXXrFuEQGYnPnrGUeZXXcUn9bue4kgyq6xSGBZbP02o+5J8/UunXqR6qwxo
	 pGd3vurd0Zq++2kXatiz5pc7tW32k/se7i209Zv+SIc/x5J6GWzvH+cMpURhOeB9Qc
	 mNFPA9vF+xgHA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D62E3CD98FA;
	Fri, 19 Jun 2026 00:31:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:07 -0700
Subject: [PATCH v8 30/46] KVM: selftests: Add helpers for calling ioctls on
 guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-30-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=5287;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=hbN+yAqQISjxMIEVr6SVho5msOILWqIwNPf9evYOET0=;
 b=yXs5e8cuGSsKHi7D2IhOuGh6jNQF/8vmb9Fhw3d5NSAPnjJghKvkpHbuw4kLoSo9C3BxJTete
 fqs+1G+cQjJAQhjtO6bj3+TxuHzKn7nZaaaQRtvijc9iyqbDfvMJQDP
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 32FBD140003
X-Stat-Signature: wgkbhdbk1nbtnzx6qyzdr9p45owxihey
X-HE-Tag: 1781829121-401633
X-HE-Meta: U2FsdGVkX1/w4hFxpdkcKXLqulwSxElJty6Pmvm7UTqUPKuzgn7cd8JbiNuklQPX5YbTRtgAJ3W+MphT2bnWAxlVe0OgEMRFI3eTkQbx49inN4WUeTrIpo6aAKkTrB/Vo4oP/LAbVhskl+xmAHDcZBhLyXzp/+HO/6gFOBZFfpiojpMwuVLhHhuNmyR3G5z7RvhLBOBjf1n1LmM4hdgXrjrw6F5M9+voFsYpf6tSq50QVEkkij1IGPOaBQl5ioj5VS2ZBRosYukT0C//d4Il6TGUe4p31KSunSJFpe/r4xcgcklvMBKnU98B3+rTwQPUFkY3jQRcwasx/oXbHJLdwtax1YOXTHKg2YdSY4cVaSCjvO6p74qaFKxFVw2zvwxLOllXSDabhw/6jAu4i6Eu9+Hb4kQ0k1eDwtse2jDfffvKfepJZIB+/bxAQwKGCiPNPJTUhESQdndsy2C3vH2wTC+/r7ngNBOi9MLm1FAYEOCYQIjQ3AlziYEbIXRc0CwFzU0k2fAOo3rI9mUl0Q5Kb1hRVX62khS+OcVB9+pZIWOuY9OukKmkci4aBAci5bUYPa/d0+Ue/02plreLNjI23G7DF0cIqvHlPCmNpbrimDs3EbAaQ4xUOLAi10XImrRIN9qF+jDTK+jIWwRIgIIWUNl2samtseUqM7EofPZFQTLYrxJ7XgkfD4qKWcWbg54SjFI74NEpGfhJKTQsY2C1gJm3l31MJv9NCmVkjRVCs0zCkxSEAZhd4w9qmp2jPDP/uqpwkYX8a0GUmy3AY6hmW59jlGKva7LoDrD5kZPC/Vo93fUMRZTnUoLhuIvRmkUlkxBjUinCBtW9aOOZNx7DxX20UGr1ObMq+WmqEtjHG3EqhSoESiCnxVRtSPKHo5O8dy1rmls4u4URlhRWkQSM1vf8T2uauhSCYx8UVG4b4mv4h5NZPfbvuFa7/v1zwS923HSC1Uo2A2GgPTAuKbP
 /WRe75b9
 lyej2oquenvJ/0MTaiA9cuFRXqxwp1AqU3gqkANW8QSE9x1o/7QWd1if/OvEUnNDvo4EjUQDPyJ4lQhrxoVv5q77tIiJnk6FsMfrLI82zom1oaHTotMqMC5IwOhqyIj6vOPcicVOm0hKmqH5uhvqGKxJfgJIluIZHx+D5Kn1h6SMVS1aHUn9L3R2NRbmxqGalS4+ir8OfvhwwdzZk8XdDoHGxKQD/60JihAhETGeqwkbg9b19Hr24QksX7q4Czd21993LOMzVekSM6Zg6giL4b1cXbUEVMvjhCOM7zcV9QAUmHozj81d28tiXhXihUbEo+d6Awq6AT8mC732zdYge4DrHxFol8PVUJPLykrm7mm9bJa6y+QArDbaeFsNznpAbccDFXW1K9A06ByDg5yGjuHqh9D7gAn5pH2BZKtlfkHFSAxandsObBwuHlmHIjQ7bXi59faxZFWmdUDSoakF3MHinC/CDvmiwPcP8tXqMmC7kHLCToFxrJrO98Q==
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
index 0cacf3698b259..323d06b5699ec 100644
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
2.55.0.rc0.738.g0c8ab3ebcc-goog



