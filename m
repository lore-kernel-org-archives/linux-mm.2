Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1200CC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:20:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EBB16B00BB; Wed, 26 Aug 2026 05:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04E446B00BC; Wed, 26 Aug 2026 05:19:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D20E96B00BD; Wed, 26 Aug 2026 05:19:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A36426B00BB
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:19:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A6A7A3739
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:00 +0000 (UTC)
X-FDA: 85142871240.30.F2157EE
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf06.hostedemail.com (Postfix) with ESMTP id 69468180007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tk9dPm2k;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3gK-OagsKCHUTVdXkeXrmgZZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--ackerleytng.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3gK-OagsKCHUTVdXkeXrmgZZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/81lA0Cpz/oRFwzMFnP0lg485AVXtJOskviG9WvcA48=;
	b=W0M6Eb+nFt1gYNtYZhF1BdnGl4GjduTmN0Qa+YBgJrwBR7VG5kLbdPQrSfOG3LpzTXgzTX
	Hft4c/lvstBOgrr5LlzWz/B8JjQ4gh0b4FOnoEtmbcHpC/OdEbb0l3a10T7NLwU8mcAy9e
	e43irOcJJczF7yjjo+ygjAI/3ePs1QM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735938;
	b=S65G1Vf5dBVztS1YKzYAdevS1gEd97eMJt41JMaR73dP6H9ec01xKMomfXTzIdQ5FrqDoy
	xWhWD78D0562XZjejWt8GdZ3COxILC1jgEt1a7XlYt87E9MNuPyvBWB65ETHOVE1T+1vpG
	DbywUOvU2ubfV4nuKO7WmJbYoh/VWPc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tk9dPm2k;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3gK-OagsKCHUTVdXkeXrmgZZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--ackerleytng.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3gK-OagsKCHUTVdXkeXrmgZZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d63bad3d09so12879185ad.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735937; x=1788340737; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/81lA0Cpz/oRFwzMFnP0lg485AVXtJOskviG9WvcA48=;
        b=tk9dPm2k5BLD2PRFZlFyre2e4AZYyhHGc16hqyIid6H40WXFTN/gatBLQa6YX8IjaN
         0/KJ1gGbtgJVf5lZCrc0k7XjIZ7/XjHQUeNGc9OQI99CmLlFdnwuE/dnNwb5HdLmc9Ul
         M87UqdG3E5w5aRo7suNB4yOxbhY9rlRV2hq8Kip7eEKQSCX1gaLBLYaRQwbG4TNzAldV
         U0Ys2rkSXu/wMxObqzxtoO2zgwyQFPJFm+eaMNuv6jvsqMovKzZeOp0pLsZyjLF7GK79
         5UxQhQ+nsi15sD7FfvmqFMsQ98U5ubyjTXCFwtf3kY7uel+cMG17Xmo2qgK7MaWYGzYN
         fCvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735937; x=1788340737;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/81lA0Cpz/oRFwzMFnP0lg485AVXtJOskviG9WvcA48=;
        b=sLEot+8WaIQnCVDSyDt0AjlY5aXHWV+Pp6ek32VuuU1Ur7KBj9VMp9VJlkTOJttHUF
         /q27CjjFrKPjhxLW/Ts4NjVQ/M68E70Kp6IOLf3T6otFcNJ4tjXQbJVxWxirPPSSdb+X
         1nk+v4xgYt7Wu1Q4XZiHshEHwxx9kcI8PMlFODbSJUKKtmgOu8cMIGDSO10RtOoVYTIX
         zdSzEAHAGFJ01GOVNx4PDPpHPwVE/Um8Gvd3mupd3Xxka1hA0XG/kYCOMhZ5MYtepEN2
         uS65oNyVPbitVfoZ0kLGvQw6sdUa4/j2uXPv0FGapGbvj0wd65zecZN1d0MsTZGwY8tx
         i+4g==
X-Forwarded-Encrypted: i=1; AHgh+RorsRVUvMBdsHfWgJlvAaiIjPREWnkjXiGeeLRKDWOKEhjCbnZ+q2CFKgCwPWdNJvgPsWw91ueahg==@kvack.org
X-Gm-Message-State: AFuF++k2KdZPje4ECFM8GxCex/UEAEfBgaK7EpWgvXXaPhMA32o1v11z
	SsS5Mqas62AJH4/n+JovGOQt9cee/qsEchena5Sgx5FMuxGxL0Q8mr7w9KUdzKQbAEv4odrc98d
	DTQxtBn5GtskkVkZS4oir3NpaCA==
X-Received: from plat5.prod.google.com ([2002:a17:902:e1c5:b0:2bc:ac01:8af8])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1b44:b0:2d6:ccc5:a3dd with SMTP id d9443c01a7336-2d707a71485mr102551555ad.4.1787735936967;
 Wed, 26 Aug 2026 02:18:56 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:27 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=5371;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=de7l0dfCPRv0ZFRIHLiesqcC1gyIjIA61Ch8/0FC1RE=; b=+7oSxBwaRZkZFtViFndHGQONA/JOepFmLXygu7h6ctbFbnB5VS7rmsTcrycmZNVjQ7FxUAfj4
 kY06XWKTQARCDaE9SZF9BosN9IpGYMriSQ4JP3/r0vanw2IF0zOZfuR
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-29-0a15d8a799aa@google.com>
Subject: [PATCH v11 29/46] KVM: selftests: Add helpers for calling ioctls on guest_memfd
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 69468180007
X-Stat-Signature: o17xrgq53sn5naoyoqzkbjqu7oqkid6o
X-Rspam-User: 
X-HE-Tag: 1787735938-465167
X-HE-Meta: U2FsdGVkX1+up10Q4aLVPlj32EWYuPIQ9pJVMVWO+YqWZTxPYzsvzY/+7oqH3tXnAW3euXr6i6XJ9b8YE7r7bXc2TYzdLfSo/L7GY+cRZV0H1GZl6Kwr5f7ypEenkyzCaLVscxaUJEenCToVr/WUc0PV1m2npxOV4YOjKqWotRAmt8V6Y1icCFsIeLGsNYvuM5vFnA1SCa7tJ0SrOTx775qisfd+RRGKv6/39nrH2xQQLzmZ9+uBCzh5RRh9I8dpXIY+kyICGVcevRrosCx0jtxgShLEpVmYIvKvPdAP5EW0SNGXHhICYMv+42msU/0fFds1cynbTlPNREzMq/2jLJdpTVj2rhhrngHuZMX0jRiqhbxz54YpIQxDCpiKA7xZ/Zrco9HZQFKnyaSCSK3iLkqBQ0cuGYcKqJaopOECtEKACFM8z/+pOq/rTm9/zzPYHGGvbhD7qKz3JWErwowTLKufsiU4nLqWtMa6zfN01LdP8Rhg5Y3ti2Rd/H9A+6JYysgXUnZoQHcpHV7TbwnOozhKhB075UC+57orkCgR45pCltSP0l12HV6sIiaU2eNX6VmX9/0UsEXvvokr5bW4QxiBqC50EAEBRzOF2zbTGJeHwzgnaqY2jAFg9//r6XsXtgAIBWmjGYDVqu9OpygoyaTsqWRySHviJ0DjmNvA+zrAbj7MgTfzO8MHbbUpCGlb6doSg+6bwBYD7qANWerlY2sFAtakSUsKGWnUhjshYwpyNLT1ypeWSnwVR1QAnT609Glql3HRZUZbIFwNu32cVAMfIUIyEadKeHU0cqwIjm0z2SMBh/VKGreNL7FRx0ryb7zAf3NHH36juQQmSCouj4VcSHqKt2zn2nEiNhdl0v5qEx9QRL3BFX/jf19RiX8H4s4X7znEymjiJBnWotfE7vbog6zqyMmS+z9jV7vz3NUC1vJH3j1vTcirJC5nqMcx638dexnCLeHO4t6S0Fs
 /ALSXhyy
 Ggckt8PJ3FKbbmfz5ig38B4nyq9olXK/7yO9CAppkn2eJPWJoYIWgSLOn01DufePeCuwYsX4iZu0dZQj0YNwEYpUpZqFl2BWUhCXH5UTc02xDLzHC8vP7HKMT450meVzxnVeuu04REQ6hz0SLSEp17OF/HBYoDXvM1VahqkKzVZ4QIoFkHdsw7/c2kKvLbxtOwIpMusbzhiTe5Enfmye8FyHfT2/rtCjoztP3nVovtB6EPYpA4Prmn2+sL17X4sGbXelCrY7D7BPNsLbDm3IH3odwSQVMFB1pw+MGx8CpGr/Hd8lOm6M2BZMW2dX/p3UBJLiM1GlTfcEpgvVs0JlW/UEHT6Coh0U/px3m9mhYpQT7GyW2bFYqX+6gaE5o4YF8Ndx19z2liYQQFOjR0OH9LuTzLhQOIj+JS8ZxSl+WJVfmONF+QhTLuDpeAKY8SEkJX2fZulEtFnexZnCHa6LaX9jr4TaepckzFv6+K+1GzyCkGnXteqJWM/msidREbwMiCPMuJ8KNnTn55wmrlb05ZAF0drkJ1MFszR/IQRz8fzdOZk+T604EmevjnVZamYRu24zsDz83AsBNwQxIoYDwhmCxLthsKJTwVEbPeIueiHmVxgLTj6Hv5+/HWkFLLfPs8tc1l1HxW33RhIcEqXUziRkPll1ZLU7bV++Gf3P0MUAhyVrCXXOYaTdMHA==
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
2.55.0.887.g758fc8c411-goog


