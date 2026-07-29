Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 461E4C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A94126B00B4; Tue, 28 Jul 2026 20:35:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B456B00B5; Tue, 28 Jul 2026 20:35:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 982D56B00B6; Tue, 28 Jul 2026 20:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 670B66B00B4
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 02A3C804DD
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:21 +0000 (UTC)
X-FDA: 85039945284.13.87B732A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 025534000D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rEz0lCJ8;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285320;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XbmJIi3glfaowFADA8wcfVQpcnHjzuLeNv47Hd1JcaA=;
	b=j4b+gwC/Y0MFOoyc8z2R7mmSJeIwLcWdDNhnTT71hCSoMTaeJTnklU+pCLoirwMNdb3aEg
	CCyd4+aG4K5hitgpWI/zumSQnrnFcvkM1ZmY9jVRWZeP3ReoPjFTUDxoiTQNDbNXtf428N
	uNhVNg6CuQpL1S0KZrKHbqvQNmv096U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rEz0lCJ8;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285320;
	b=zM+rQp7ZI+tFFZw6AiOz0Ey8YuDF2upKqbGeJktVooB1Ber5wvbj2MWLIHp+m/XQEaPcXZ
	0kocgFyxrhTk96rSKvK8dapN8G7haJn3SRcS/1gx/L30DEQ4ZJnrC3/2gT4RqPb/12oKCm
	ZqC+QQ7jBleFzGyNmO0QB48DnXf6KIw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EED24529B;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E67D8C4DDE5;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285310;
	bh=9b4OkH1UVPXahUABlJXnZw6CG9OK9HzlpLr58d+35cg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rEz0lCJ8TGfWd8jIaUIDeLosYBminMY/fuvn+O6CMYX+majBe2lJ4C8Dz1V5NNRoZ
	 1eAu73fMm8dOlyxzP8c5r2zUwrMu0O3j89EWSQhlbzSMRd+L7Y9aYQJn2s9pXWPNT9
	 Ry+bEq7HlTt1lF9suC88etEnDq2datcR2nX19KU2JvXY4qdiqjPtFA0e58cunXkmfB
	 YKyoM1q5fFud3XNWwzGVNNuFGja2hrF9aKBeBtSPSLZztLC3tVQePnjW1lAv75Upv3
	 upSXEORQHVSLIJpbvvNASYRotQUo4heopWdUwHJRV77CEWXCJPntEcdme6pVndsS+0
	 jKmOvFrGPK4DA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC686C54F57;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:25 -0700
Subject: [PATCH v9 26/41] KVM: selftests: Add helpers for calling ioctls on
 guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-26-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
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
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=5371;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=SztH8ywp+zsWQWj3F1zxcBTjt+wFMDPSUxmq9Oc2LcE=;
 b=ibfbjTjCAV9TI7MZlzIl0m2kX9XyXJtAMLcr/jr3yXI8Xnea+IR2gMEEugravqAlY3FTzz9z5
 NZkhNU9wgjxAH4PsjDYJUKzobhKtXyPSEl4cNa4WvDVdm+f4XRF293O
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 025534000D
X-Stat-Signature: e84epspddofxspzrjd4k8fyk36i7g7xx
X-HE-Tag: 1785285319-954552
X-HE-Meta: U2FsdGVkX1+962cSM8vK2pWTfbC9El/EyxK0AwFTv0Dk3Kl5rWDE6V4Xwsg7Q+w5n71FNa8JCbN8wdXF6FX2QeBxiyT2PL1sMfL4ckuhi8n7FWqGbYrtJvOqVsK8pa2vq86ZdAmdUDmbrgpvqX/0+UF/T5V0uhG3NkbeOuJR6bp0I9jytaXmjIycsuLQsp9u0JApdGidC9oAhfiW73bedKwK4d6SKN7lgrzVhjP27nd7Wpi4LJCWe002o0xUXMXwWl6vuBlsRl8KvIS6MzuGVrMDeghVk0XJvH+cT688oDoD6yopGpmu19TDpfQfZMnf5eTQ/mxdv/iZPm7XSMpieVPq32z+kqtf3CuUoPEa7Bvjxbc6EWuxhWPhfQlXOLkCZkjRkLZONBMccTrPm5zlck/jBhxEU2Omsp2gy3AWcPdAoZusGsItwtT4/Wh8N7gawACXP8/U2LzmQ6KB77S4lZ7d6omSDTyn5vCtzJc/OzCk1YeUeSrL8HAWe/a4vKfVe71Zn8tLXQ+i2pguAQPNmYwemd7PE24XdUyYV9BM1zcOhLNKn0q3K1W0gcwzQFY33LIX2EqT6aYqGfcX6fcFjik1TfWk7HN7Fbawdyxartg4nk6j/XwUX8DXW7daibTTT1cvfk9qZlC2JFepVF8PoP93WFONJQdqqLOsZHiVUl1UGlF9M765SWICYgsBujXkT4S5PwKh5Bx716VioHCxsjalnqmOygPUQkSbUH6nVV5FPEd4TFPbVtdpU4ZADeahevrYB3BDoE9czryprnV9WthFKfhT0EVdyDAcqhLmsf/a7Stt12puZNnhASh7ceu/Ll8TV56uMeZMaRyoMdOXI28iqjz//XTQe438NaX5pd94Qi6Y1F2QDL4o/NmgF5c5miHlCRYTsbSYhwjK+1DghPaFrDUyRvuGoLfMM+zbP4NqTuyPRsTQJyhdJfarTudEIAycLfFAhvryouP0CYU
 HMeZyQ28
 MbN+ei43pTFop+gekTL21/J51S85mPBNF7qPojQg3MJUVXrCgWPs6m8eYelslLcwWmAxWKCJzjlQDjE68IbNmUnI3lSpm7QtNUlX4TvJj75vrw4fHXvDz99hnqwcnqUVqjytt0WBtJS1yFgIdTjJ077fjXudlXWUpzSFjoTAOkOOOlVq76xNGASGGrl3x2x/gQBfBGnZcPGgKm1A8i/L2qUDUlEMKidZFBeKVnsd7wEE6UQM/1ZMzdfHQvsu+yCoNZD3rMM1/eh+UtPVlldmII1l8096sqGZL2ScmXeQHeHjOexnzD1rC1mEe/2WkPHhLLUyf37Lq9I5OGFxRyB3qy57xcGvjgR1duCkALaoDtFw9i0t+N5XdaEG4lX2n8CdsZlRIzgMc0Tw5tVlyep/4KMSnKKTtZ3p4fNago4++2YxOYsGLEpbxS2oba4/KmkkhiWvSaV7japbnU3XzxdBza1+lnqKLEaxglpm2JIpWmhESITlzXz3XKncJKy4+QJUc7VnB3tkkgFYc6MbxLaAEyGnbfg4T4ot7bFArgeLQFhStHzgBOTNjnylqYg==
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
index 2186e98583969..626c960b4bb82 100644
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
2.55.0.508.g3f0d502094-goog



