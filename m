Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8BEFC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:20:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D475F6B00B7; Wed, 26 Aug 2026 05:18:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF80F6B00B8; Wed, 26 Aug 2026 05:18:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A608B6B00B9; Wed, 26 Aug 2026 05:18:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 703256B00B7
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B5B1212018F
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:55 +0000 (UTC)
X-FDA: 85142871030.11.CC2F461
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf20.hostedemail.com (Postfix) with ESMTP id D80291C0002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KYRvzG2x;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3e6-OagsKCHAOQYSfZSmhbUUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ackerleytng.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3e6-OagsKCHAOQYSfZSmhbUUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+cjy+nMsHw5PBRs0QTAeMD0IiOId+CkLeVE5YuR6Qzo=;
	b=k81Zm794ux13Lrh3BLIK40iq8Ebv8TNuEcN0Ttpq199mHRxE421rrIkPGz6yPHDvwvo43R
	RxNTXcgXYyi5VAdCN5OXgmEsetlQCqbhx4GSxGzCoOKpt4Hf5o8YAf2+ChVE5COeiNwanr
	+dT3uiJ3+w+tBJBr6DBEb4kSidS8bf8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KYRvzG2x;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3e6-OagsKCHAOQYSfZSmhbUUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ackerleytng.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3e6-OagsKCHAOQYSfZSmhbUUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735933;
	b=ROQ5xpg3cnGxfM8TvSp/31DH3N1+SodHTSOftV60H2oKcSrCCmgWi6DiyEHcUHJxUbPAbP
	TJAPKh/iXFcBuNeWIKzqe3LqVLWNl9Npy1S3AUdxJgaHSmWs01JrFhAZvqu/bzgNJK7XVX
	1wBBBiQNut18xSZhx/KAq7DCSNzLZk0=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cee1ec30f2so12274835ad.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735933; x=1788340733; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+cjy+nMsHw5PBRs0QTAeMD0IiOId+CkLeVE5YuR6Qzo=;
        b=KYRvzG2xrnC9XlvNaPylx0rpZN3Y1hPxNBV+C5rGE9ZWKgJvGHQ1lA/He/UV5BRO0E
         98Nk/gGcGPZ0/mOeSl6h26ZDE6viXcOKEjwzNBqG/wUppfpXh79pSNJEAA33BHZjUnIr
         tZkY0hv6KNDHtI/rY4S5PzZbNzLd/zrF5Px/aD3ik9njIafti5GCkcpx+lYiHbPFKsWS
         TH4uE0TxCh/5dNx4cFdduA+Df3NwrT4kWwsRsrB5b5uqQsXoAGfoek8jjR3Vze66N96t
         PUb/v0TsT8yphJmthdry9LeMubcvqSFKgK6beDHCwXQ2DlDYQs+9WL5bFWKYRnGTuq8M
         wGVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735933; x=1788340733;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+cjy+nMsHw5PBRs0QTAeMD0IiOId+CkLeVE5YuR6Qzo=;
        b=YSauKML2/qi/YmVCQ8A8jz0kwVEMH0fiP9JSTM3vNFCkDYCNMR7W8dVAjm897JBChM
         DncdkJDI+y6ygmGYrjit03dSF8wRN1BX2tFpc+wgw5qGRkLhD6OqtV2ruhUjje8WILvT
         Qbl5bk7U4CpNIUWxjCNMCuX5vjCNKdCy+IuPF4EgOAWGeWvXcW355H5s0eV70oKM2Ko+
         PvzTw4awX3bcFXVR5Md3iNyaC2F/G0Adl78IjHoKXhXHv+/kLecfrZ3REYYelVcmcek8
         81L3B2Dw2Ct4njGKO4zwL65w2CBUavhyQTj8fQRx8FEHXPEtAMUHU8fOhj86VsSQZxJY
         mBmg==
X-Forwarded-Encrypted: i=1; AHgh+Rq3K6bFMJr0hQ5c68yyezqszIhKS3afk2nv5cXJJbuqfRVgV5dddkAZI8/yvZjEjI+75y3bwVCvqw==@kvack.org
X-Gm-Message-State: AFuF++lVUDMY3QBll8OPM32fJdRFfWq3qVsjUvOWxv5F7xPV1IeW2W+s
	ziOX+gArY9lomliaIqvg6VHtXuNd8EXWetDpVNuykXt90pdGOL6NIBYlrFP71s2Q5vGupd6i+wD
	T1+o/t2zyp0iWohD3Bv7CAlfSaw==
X-Received: from plhq8.prod.google.com ([2002:a17:903:11c8:b0:2d2:f257:ff6b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:b48:b0:2cf:b68a:340 with SMTP id d9443c01a7336-2d707b7f737mr84539505ad.10.1787735931763;
 Wed, 26 Aug 2026 02:18:51 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:24 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=5047;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=mb3uaLD2f73gjBg5EOuTiW5jIrrwXcBsUyiQfGfT2N8=; b=JETiA2QHKaiExWNZCyGlrQT84yI/YT1kdJUQpYKxpqoY5RadHrf8I2YGHK3b4T5c72XHbZUpU
 2Jn4PILDbMQB9KRhsSDSu6kzn90BQELMLsi1gc6Ru6P3p1cgHLRu0um
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-26-0a15d8a799aa@google.com>
Subject: [PATCH v11 26/46] KVM: selftests: Rename guest_memfd{,_offset} to gmem_{fd,offset}
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
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: b84h69fqkxf7dnsfz4kdcsbfoqju3bh7
X-Rspamd-Queue-Id: D80291C0002
X-HE-Tag: 1787735933-318711
X-HE-Meta: U2FsdGVkX18rlPX75DLqQ0XA79vETzkr0L3YE15TU9Q2q+8zG6HIb2ud8nSSTGmSYVjG2e16b+mRGc7/0OhnF+hvrrtgLb+j3g4dTq0Om1+jvCc8YcmrrDeQk2BA8BBrys4gasm86MlzkfzVL2HdjU6V74oHJFbJIOE5MmZ9kl0i4gYplilGZuiPWh6WJxIDloLlyaY6jPRLyuAZjn7HQ0iMVf22TYlJWkg0z9C9qipjxr7M0Mkd9qyOFmFAPhhMUE20eJycsaIpiDdwxxHVyLArQ4DL9QGgqIFQ3/WOaBpGUU/eD8Pz5PESJPude2Q8JdYlO4SmHn2i14XI0wfrreH6CLtqX+h+bFs5ftrXez2ojqvegMq68r6tQZerJz8wnGhZPiLMb9IBvcBcsUZvYqIoLMoQCZpRw8FxslImvb1kdoF0Z/Eg87pQXxHwh2vPWnCqM5rpi+vFn+uGYwRteAOHrh0eYWIRDUycrlWtVaX9KSefSRgnhqxYi1xX3y3Ys3FnkOCv1roqpko5YjcrEb1kh8CIBLgVWBwqBeQWCeiAXcUGCyB1bTWTZOzV6+QBP36hR8+fXEpiJ4X/xaj/nK1afoWqjPwyQgNLDaAtd2f1svisk9ZqITwI57s1y79J6jq8MMSs+M5mOo0//E7cus1xC2C3C/TSRvQI5zpuBnLQogAG9Ng9v5IrArPYW4HUgwx1oRIHP/LD8LRiOxQskQTGbRXAdsDF0UyTtXwWX62musdwOlyXUrZl7zQA1UHMrLcupbHLhP4k3HESPJ1aHTRYJdqqsDIvDJvh0QZw2V70Eas2PXzfQJRDnsZ9cGTBg9XxUdelDlcvqmYVGgLTZmp2Rx+AgUss8aKIdOhV1Y+IrbOOpzqRtggwPPluBUIqLTzPo4UpJIAq4jFpwLnyO1+z7kHhLJQqD3D24UVxZnXMWM9m1iCb/SjfWQ/oF4m99i84ulfyFrOZL0tBjz1
 QXrBn4pz
 plLLGN1J7RMMqMYu4ULk9IzoLzQpGPWAy2GCwE+z7Es4XunNEUcoggvSEcDq0vqSiACeAmtmR7uCwUkyXFl9m35XwbVrxrBYBfgA3VR30o1BuNbG6Mv05U3JJobCAKIhYRVuC42VNa5/iMSBqW618C84BmCniSkKYvkXxyvPccNkwo8tYRddR03hwO7093RyrMqG/rPqLd5ww+vYZ2pgVVRj0zSlbPMQCg2LjyVZA8ThvfP33d9Fa5I7JqiaP5hwxJQ/VWKsMoIIpppj7DzlI4axpLqj4bYsgZORfBnwLcLv86W2M8kihcyauC6rGp2ZUM2r2zuK0rcrxuCskfd9Pj1qOXuqNSNCcRz9+8BWv9ZwGQi7WCLiF11BQmU3VhubNHEJdkHC3t4/dKxeaO1jGV0lukwh1Mzsrju3ZWPgLytoG+6rb4H5vU7rnNJq9TkXtYWBAiHD6YIkAlSDQZd52eqW1Mx+tzwfZg5Wb/B++EVoDugBk95h2IhVhUhOOHRfX5J+HviV2u0FWfQ2u62VpeUdfh6AXv322oJFRgAy1tqE59eZWbqqAMcf82nf7MxOCYTrgvrqzprwDUDGS2/Ri5sYpS6weFP735qw+DYcbViwJp36flWTgOl0RcYXZWSxXBXSIvVCAYztntgmTkCW9GCsr0LA1QgLR+rfofXsgXpTYD4p5usdtaZ72FCjyjy5HUfol
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Rename local variables and function parameters for the guest memory file
descriptor and its offset to use a "gmem_" prefix instead of
"guest_memfd_".

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h |  6 +++---
 tools/testing/selftests/kvm/lib/kvm_util.c     | 26 +++++++++++++-------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 5a7a455b53875..cf49a84de02e8 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -690,17 +690,17 @@ int __vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,
 				gpa_t gpa, u64 size, void *hva);
 void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 				gpa_t gpa, u64 size, void *hva,
-				u32 guest_memfd, u64 guest_memfd_offset);
+				u32 gmem_fd, u64 gmem_offset);
 int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 				 gpa_t gpa, u64 size, void *hva,
-				 u32 guest_memfd, u64 guest_memfd_offset);
+				 u32 gmem_fd, u64 gmem_offset);
 
 void vm_userspace_mem_region_add(struct kvm_vm *vm,
 				 enum vm_mem_backing_src_type src_type,
 				 gpa_t gpa, u32 slot, u64 npages, u32 flags);
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		gpa_t gpa, u32 slot, u64 npages, u32 flags,
-		int guest_memfd_fd, u64 guest_memfd_offset);
+		int gmem_fd, u64 gmem_offset);
 
 #ifndef vm_arch_has_protected_memory
 static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 3413d45e34faf..af501a27211a2 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -970,7 +970,7 @@ void vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,
 
 int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 				 gpa_t gpa, u64 size, void *hva,
-				 u32 guest_memfd, u64 guest_memfd_offset)
+				 u32 gmem_fd, u64 gmem_offset)
 {
 	struct kvm_userspace_memory_region2 region = {
 		.slot = slot,
@@ -978,8 +978,8 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 		.guest_phys_addr = gpa,
 		.memory_size = size,
 		.userspace_addr = (uintptr_t)hva,
-		.guest_memfd = guest_memfd,
-		.guest_memfd_offset = guest_memfd_offset,
+		.guest_memfd = gmem_fd,
+		.guest_memfd_offset = gmem_offset,
 	};
 
 	TEST_REQUIRE_SET_USER_MEMORY_REGION2();
@@ -989,10 +989,10 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 
 void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 				gpa_t gpa, u64 size, void *hva,
-				u32 guest_memfd, u64 guest_memfd_offset)
+				u32 gmem_fd, u64 gmem_offset)
 {
 	int ret = __vm_set_user_memory_region2(vm, slot, flags, gpa, size, hva,
-					       guest_memfd, guest_memfd_offset);
+					       gmem_fd, gmem_offset);
 
 	TEST_ASSERT(!ret, "KVM_SET_USER_MEMORY_REGION2 failed, errno = %d (%s)",
 		    errno, strerror(errno));
@@ -1002,7 +1002,7 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 /* FIXME: This thing needs to be ripped apart and rewritten. */
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		gpa_t gpa, u32 slot, u64 npages, u32 flags,
-		int guest_memfd, u64 guest_memfd_offset)
+		int gmem_fd, u64 gmem_offset)
 {
 	int ret;
 	struct userspace_mem_region *region;
@@ -1078,12 +1078,12 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		region->mmap_size += alignment;
 
 	if (flags & KVM_MEM_GUEST_MEMFD) {
-		if (guest_memfd < 0) {
-			u32 guest_memfd_flags = 0;
+		if (gmem_fd < 0) {
+			u32 gmem_flags = 0;
 
-			TEST_ASSERT(!guest_memfd_offset,
+			TEST_ASSERT(!gmem_offset,
 				    "Offset must be zero when creating new guest_memfd");
-			guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
+			gmem_fd = vm_create_guest_memfd(vm, mem_size, gmem_flags);
 		} else {
 			/*
 			 * Install a unique fd for each memslot so that the fd
@@ -1091,11 +1091,11 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 			 * needing to track if the fd is owned by the framework
 			 * or by the caller.
 			 */
-			guest_memfd = kvm_dup(guest_memfd);
+			gmem_fd = kvm_dup(gmem_fd);
 		}
 
-		region->region.guest_memfd = guest_memfd;
-		region->region.guest_memfd_offset = guest_memfd_offset;
+		region->region.guest_memfd = gmem_fd;
+		region->region.guest_memfd_offset = gmem_offset;
 	} else {
 		region->region.guest_memfd = -1;
 	}

-- 
2.55.0.887.g758fc8c411-goog


