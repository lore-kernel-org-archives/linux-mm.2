Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E60A4C61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F7D26B00B6; Sun, 30 Aug 2026 20:25:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CF836B00B7; Sun, 30 Aug 2026 20:25:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FBC06B00B8; Sun, 30 Aug 2026 20:25:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27ADB6B00B6
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A2B97803B8
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:37 +0000 (UTC)
X-FDA: 85159671114.21.11565BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9E96320003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fBvVPBqz;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135935;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GNwGGhWs43+dgSV8pmlQ3Rj/CzDVpF0zjFTb1rKnQI0=;
	b=4omUGJzFKlMP0VrJZcqWmX5YP5frCRqlLRI5BoT4ddslb1i4IH7/evSjXW92R6Ot/pVlHN
	jE6fimJZo5bV57s6GL4GP7iPAES4mXZO/AhQMKpLDdTRxonc9lYgCtD1BVqT3pKVz4fPHI
	YP9IFMFM/cpah9taPqwVa7CGQsGbCE0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135935;
	b=3DKgPCv+t5+vVAJgHiJPgONZPGI4Jlf8qVtR6Ajl4zVbZrDGSE4aAiNHftFsUchl3ybc3I
	Y+tlXaOHMomXxv6AhXZQg+wppZEF9DjOdPdg3INp0q9wounEfUUzUDoPyCrIG+KdXsiRyQ
	hT1P/KqTRRX75YIBfhwoiJ00b0LzUNg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fBvVPBqz;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BB562448EF;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 841B1C2BCFD;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135922;
	bh=Un65aX2hliMBp9F+laOBU+7N5M3Zse1cuzM3vKCbt0E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=fBvVPBqzFLSplmlBFpA9l87l812gcH4JvkdqznS5UPRtUqBhVYUV5uefA3KxqCmjn
	 2YAd1GXaI+jQA5hrmIlAT2xY6elwmZESqLaZSlwCOT1dSH+Y3kYEk+jVjJRxQxUNpb
	 CjFNz8sJInEFDoLK0jgdXvqPU/pHaz75m5zkrddNUE+NhggBghenl6+CdDD7ElSNTb
	 PRjRul3TtvmEG12mdW6ixhKcs48NqaAGcTreDWbv7m0nfDUAp/FqGtMbEco9xVP+a5
	 w/K7l9Tq1Gz01WX3qysSK/BYABYCNK15oQc/yaF39wokGTxMtqfIjq18M6d8bmdlwJ
	 74ZevgOgXz+9w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B6C6C61DE2;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:30 -0700
Subject: [PATCH v12 29/45] KVM: selftests: Add helpers for calling ioctls
 on guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-29-85e5fd25252a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135916; l=5371;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=kfZyKqtPosaaYAmiKmAsB+X294/S7Udll9mbrIpe02M=;
 b=hmZmO272ZRshRNeKpv2i+PZq14uO3q710ThyELXjUP0dtVdPH1eKjNxLk4f6ocXZLAVgdSVGO
 zfJBxhecQ86BzBD20OOafwTF8PBgzhmORW6dZlxq81ll1kyMZQiNl4x
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: n7p8n7hggx4fqdptdo84bfcrz8uf1suc
X-Rspamd-Queue-Id: 9E96320003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788135935-567179
X-HE-Meta: U2FsdGVkX19sAT+fdBQijgJlOnociDKLW7EDm9y6qm7983f9rFQi6KG8tGQnEdgTKH/3oYRt5Iy885FVVJbRppah9b/WSCW7Deh1ZFFfIRWEci39lCZsbYbEJ184SFKp5h2+K15LS69GjAG8yl7PTf+oApG3uIXpln5BbQ5lw1uJK/2xwWj0h9YlZfmzXpU8jy26ORyBsSFIQ5N1na0vBfVPWfMgWS9iJCKypqP01186Q/tjZXHOFPQTqiW9Ia5lGA2viy3Cd0fw/4FOMG3omTQTRZ0QPn0TwyLxBTZg/B1c7/IdMuew6t2CoTl+w76zl0yPARLJ5zXt5LdrzxzlUeUuzfVTl8ycEJinHAeoyuJKMqczcUfoQcEz++WwAk81WzESh/zQa6j6SosY+fkOn2QFBbYOP3aL5ElTM/FhETjVOpwqy6yG3SwSNfra9GDy7sOL38SutzmyrprnN1EdfGJ9G4fPlPpLJNs/AawXcodr1axw9jHv+3l7odUU5VZ0Pe0s+f4/UMT/6lxN7hICl25rfqm6NA3r+vu1Git0QOb+j/SqDRUQShdy3mBASV4rwi08i9frGWQ6c2wzTf7TxOE8RGvZFhlkWpSJKMOYF/oRnkrgIt8AmyGAZhNQpkBdSpjUX4DBZhIdHGmCt1Q8PAGHcrMuPTe2OdNlVKqovP944AyhkHR5hSRn5zb825oIyiKA49QKw89SVZpaOelXnhimwS9QR6IPgvhXnP2RilH1YPcvq9CMeGcFdYUEO57SKyVJ9GOOQrW/RhtCgVMK8+vOV8i0vLpH3p8nV4HHP1NkQ/gUTNe9m+WCA/OfG9wJmdE2TXb31HI61HmkaLG6MoFsebvA+GrLtGunHcmOrIE1piDxa2dHWbnq8HPRyn10HcZpoJpSLa53FMrP+pY3bLNwW98VzhyamDcv2vkEp+jAE764M99jsCNs/xgZpftEP+rq9urkXqONXmIjoe4
 Dwh6J5LW
 j2yAtP1TOMwjwGeersP9E2vHZLcuMG5tabHvT4CuSJ+tJRu3bjesSK0+qamlmM/1fInTpSH8WJMVu+F7xXufwo3DAVvEUmfYyKb1NA2WewgILfhfnMeVxirvpVCbV7BEu/uZnVdtmY08UB/z7Eh2hFcKy0QhZyN2EGRAcwYGZ4CgQdimFSCa622ty+bqDL8IkvKd+eb/JiawuZ0LNXGmOcwXI3r/nHjkiXUQnT/uyRzxP/ZTlvT8ai7pSj/jQq+zoE0ls+RSUyKzAxxxt6HBhXjIPMwqk/fWd9REXYPL/aSPc0PloNl+pOIZ05OjW/L8HLL4nFMEnS+z3+im0axsfOH534OGGpdIvJYW2XuBlgpg5GBt4MqkfoWGV4HpPpLscHZNCBFkWP4A5liWXIQakUbuidLZA06eWyKijyRbw8Y7nxPvkDB9mMnTss8WBrlIsoVSMQsZ8dYlKqJtbhA2v0x/Tex5pnLYirKqYjBAkgZh4g7vwSyhJz29HYPPMtwu67cI1pI0oE/HmFma+a3xbmfDgVw==
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
2.55.0.897.gb25b4bd76c-goog



