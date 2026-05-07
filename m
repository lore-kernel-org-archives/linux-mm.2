Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E343FCD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1FC86B00AF; Thu,  7 May 2026 16:23:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAA766B00B0; Thu,  7 May 2026 16:23:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949686B00B1; Thu,  7 May 2026 16:23:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 816756B00AF
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4B31916060B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:05 +0000 (UTC)
X-FDA: 84741747930.22.AB65588
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1772C40010
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JNKjXbz4;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185383;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fVrArBlhv37OW57iDSv9jnh8qspS0M8gI007w7eZrHU=;
	b=7kqr78isoWAvG8vMiguQhhI/VP031zrzd8CWEsRSi9gcuxln+c1dEavuIpiL7tKSbpXnHl
	a5QeQTiS3SOt4xcH4zfubG5Jpbc6PSxH/vNR6ArPRyW3Dx1B2G5/0/nXFkKGLds3jHoFk9
	gyrhZyd8+t0goO71eDT9ImJEFg78thE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185383; a=rsa-sha256;
	cv=none;
	b=CBzmsNlJOXqSuHb1cwjDwQHIm9UyMUHz0ZD/wduhbQOKwtO8XgV9PNYHVPgqZzQ+VWkTXq
	6x2ENiXaOJm8l6jgHUsQSkrV545kHmjVYS3pRRhWo3MZvb1xZCNvSjOzUw2LhronV+Rof3
	jJBWMuUTB5HWHiqh9nvoxDIUNdDImCE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JNKjXbz4;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 44EB64482A;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D8AA0C2BCC9;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185372;
	bh=CJlpJwdPDCdNGV9cEqtOvBxGxXhC8Pzs7AvwoZe56vs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JNKjXbz45L5yzWzJWbm0bL7c7PJaSFwjjtfisXLx4DcLszj3dg8n7aLUXh9secXm/
	 eUvrMMU1EqR3VVTkt6gEFOMGY8OsE0OPf6TFanxfWm17DY1vapVXuo3wtBQBBeDuoO
	 hER+tZn6Q6s7EdBmSgENO/p4ppgS3SGPWtxeyvdSlEN4Jn2qU80a/zQTNzJiPerU3D
	 WGKnRsYbplEmU5Gggs4IWRohnCRZnFMHoe2hJlMvJ8Ff5Y8g8r68oKIPK/Oeb3pwIl
	 c3vFSMwo1H/DhOLt7XYAw2vd43T0p8rMQygWN9S3hDwP/+u5N5oPUlr2pthBtLMUk9
	 rIDg+dR1XA1Og==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF695CD343F;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:46 -0700
Subject: [PATCH v6 27/43] KVM: selftests: Add helpers for calling ioctls on
 guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-27-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=5393;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=XztHGxyPNSB8H1v2gNYQvKsRysu+CQEjvKuuLkwX7AY=;
 b=mmSH/W4XJVUxKuX40Ywy82x3sPyjKw6OhUn0yzZ7g1APAHpeGf4XbvVTjpyykJ/gxVVxhhnB9
 jkGUgxrhHS8BgKvtr13yofdHLJ79ntLUKaTU8cToEXykF3fknCT6hGP
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1772C40010
X-Stat-Signature: 1ujwapmwk7s76cg8syotg34y9oodp3ab
X-Rspam-User: 
X-HE-Tag: 1778185382-900407
X-HE-Meta: U2FsdGVkX18oNMD0Jx8DPhRIm+DoGYeCW9mJViCeaSkNLaXKUnzrFa+4it8FM4m8PsFcHsmF1wYo6iWlj7Mqv8K43+v9UwO5NaLlql0wV6I+eRMyAjGEa0cqCxjhR8D8P5cUWoohFw4BXLq4O2dw4j54+HcauTXbX5r4JzpdnVGXwX6feNyrbyzxlIajmnTcvIfYEuyyzl60dmHnS5nEOMtuSY6sTn4f4Y16A/W0Fgicr8ONiT1d9oZdPNe3StL6cabemSqYoX3N8VG88CQ4dFr4TziF+q9jsyHsYobcJeZpzWKcYjHgJKQPpVCFsoQvbFIwrCP4Xp2V8qF1PoWfAY1Z9M27/C4qP8cNprbA+tFSlVLBPlGUJ4i2D3kFryURr3krdHv0BjPcCO+fqX9GcGHIN9zzfLMAHiZ2dacSJ8bIOQ0qCXEYwf6VAPG0k5boa0TXH9nAlENiQ6IW41CzvLxyqn4SqyTYtHINOEm8rz9IPEM8TpM+QL95VghDQpvr7LMzAzJ1qdKlXYq+NZUIWY0jFFTY2EkYHrc6VVbhAPUNkDaL3yPc/OIhXqsZlSj3cHQtMpqXGcONM6gi9+P+S9defEkPL0dGV+YJg8xnPOJpNUWKCSXVLqplZhGyiHZ9i9+MvRNaaFprO/Toxli/SXEwVHsHMEcm64bvPzMS2AFAIoGNklewXyPTtIu8hQlIqjvtl+sLRy6hh13+oL+0v4cqZG42TsJz+xnZPAMSzMz0KNcK794PzeWxp5igr2uLAPqBynPxTf86XeaIA8Ho6vHPm9Jff4zmEpiBf84CCQbjJp1QKjrLZ3ubuis+OPLqq2KzfUhvaFQPRDTfG/Y13axHhtZjDT+LJQlCL5hBLBJmJIwizFIFtDbWehbD4CR+eQuBhGnPZYZupZDDfU4Fapqld7FW43N4SYpXW0Mr9GfyXLY7mXmi+GjYjMIZe3cycXjqbYZbQSVVfDGtZna
 5gzwMVTf
 41PD5m7WsFjE9WVnzqzMXajJvq/1QJ4EuRe7ACGDoDY6h3SCqA11UbzcXkdKypForzVc3NiS9imWYZ25q2wQDu6O2j7jYV8TEusjiEx4+7W09pyTpCAd9k8rWqDl3rWOGfFDj4LEwR/ReyNwQ2dO7OhmkJXk4/PQSSmmXwRDKItkWbzLfFeyyIU97WSqFwvmn4FYYP7B22Oxc/FwTdVw2qV3dtoRVhwDCfOP0qI+MrS7OT5/BLbyjXP4o3Ex6jaG/Ynh0DWQswr+qN8hQKaL9MmhVCnahftM6efs06gvGKpDoRherGUrBfL+s0lQKdmVR/AxuT4J2g26cMrB+75JDyF8Ds6geBDFZN1vlNCiQQO1/rqPN8V0VWLhEJ5PDMJIXByHnbM80H5Pzu5F5KGAjX9E6xGxvNIe9RtvkJRR4WV/56OTDNqm9Cnrl6EpN1XJ8rPtDPetxe4Uub+4Y7xR/7QmCmQ==
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
 tools/testing/selftests/kvm/include/kvm_util.h | 96 +++++++++++++++++++++++---
 1 file changed, 88 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index fb54694e6568b..f7c49739e97b4 100644
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
@@ -451,6 +463,74 @@ static inline void vm_mem_set_shared(struct kvm_vm *vm, gpa_t gpa,
 	vm_set_memory_attributes(vm, gpa, size, 0);
 }
 
+static inline int __gmem_set_memory_attributes(int fd, loff_t offset,
+					       size_t size, u64 attributes,
+					       loff_t *error_offset)
+{
+	struct kvm_memory_attributes2 attr = {
+		.attributes = attributes,
+		.offset = offset,
+		.size = size,
+		.flags = 0,
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
+				     loff_t *error_offset)
+{
+	return __gmem_set_memory_attributes(fd, offset, size,
+					    KVM_MEMORY_ATTRIBUTE_PRIVATE,
+					    error_offset);
+}
+
+static inline int __gmem_set_shared(int fd, loff_t offset, size_t size,
+				    loff_t *error_offset)
+{
+	return __gmem_set_memory_attributes(fd, offset, size, 0,
+					    error_offset);
+}
+
+static inline void gmem_set_memory_attributes(int fd, loff_t offset,
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
+static inline void gmem_set_private(int fd, loff_t offset, size_t size)
+{
+	gmem_set_memory_attributes(fd, offset, size,
+				   KVM_MEMORY_ATTRIBUTE_PRIVATE);
+}
+
+static inline void gmem_set_shared(int fd, loff_t offset, size_t size)
+{
+	gmem_set_memory_attributes(fd, offset, size, 0);
+}
+
 void vm_guest_mem_fallocate(struct kvm_vm *vm, gpa_t gpa, u64 size,
 			    bool punch_hole);
 

-- 
2.54.0.563.g4f69b47b94-goog



