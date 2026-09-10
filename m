Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7993FC88E4A
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E79386B00B9; Thu, 10 Sep 2026 19:55:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E059E6B00BA; Thu, 10 Sep 2026 19:55:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF0146B00BB; Thu, 10 Sep 2026 19:55:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96E506B00B8
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 921B2A54A1
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:44 +0000 (UTC)
X-FDA: 85199512608.29.F699548
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7ACF21C0003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iyUqHxod;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084542;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xnS0AvI2oXJzoAjDf9xtHfGQBNBzTGOmHzx0EAcgQ5Y=;
	b=CmHATsdA2e+hptL8HHcCqhAcatP9QVJ+FRDUcUJDt0hq53ONJ2GXdMs0e/RCNy5iU1H9HA
	7trfhL/eiEf5Zi6BALAriorIEDYMLgrwYP83qpLOj1d2tkBYrXj8fz5tXf7tjs2uigXc0D
	uiUbZv3HUtwHSDeuifCcv+E8D+c06vE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084542;
	b=MXyyawwUzkHMtNc3Z/TPMxOLhDJHtZ3OMWCefyWWozgQUE2BV+CKFBNbf3V8NnUk+xnIaj
	v+5EjK/PkWsWNMHxlOIOhviy35lgiJo0fVW2TPMVtulXUq3XihrDS+E/i88emVydEi2WKf
	sGEPrgvdUrNzMqJa+vgc9NzQj5UpSD0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iyUqHxod;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C4D0444830;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F3AEC4AF12;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084537;
	bh=rzj/OrTlx8pc80O7Oabztnl1wHgg5+tA13JoZ/wH2Kc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=iyUqHxodBoTl7dNcqHXKNHwdNK1nJa8nk0Ks3UasRXGoKPcc9H557/rwnPiNqa/Qb
	 IDzzbiYE4b266J7iqLW1IIvE2tlCPeCjlS1dx2MtKk2df1cSBnBTuU2fI1rQn87lkg
	 9OrXl1NqbAtdmuWPCYhIs0JxbjIDdhN+v0PzwMR6X+2BSE+IbqQpsRUW97m500Yley
	 2wO39t1OxtNY9o/azYbaJz2wzQwdM4MRd66lBCk1VqChMJ8wgjJg1ePQCstsHAN/up
	 flSfu3R8OFJhUaa2gn/BCfQyu60lkksV9C7ya/CRxNgdt/zsC+FkxjWNCQyNYaCCjL
	 QhITXKr2fDhkQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C96C88E45;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:36 -0700
Subject: [PATCH v13 10/44] KVM: Consolidate private memory and guest_memfd
 ifdeffery in kvm_host.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-10-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=2543;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Li8vwZiawUoYYTdZnN4TF9mxNMeqyBKCq2YVdy6MSXU=;
 b=+IcE9QITruDSV/+IWPUjDWXhYMop0lnq4tCayVcx+m0/4GBSIOH3/gusJw3UfKw2rq3XShTgc
 4OU7MMJEMdmAr1Ofm10u3qIcN92YBo8qQ3/4v8GPIcsszGv0ohUICU5
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: n63rcbbz8tcpyyad8is1nigox6g879bo
X-Rspamd-Queue-Id: 7ACF21C0003
X-HE-Tag: 1789084542-338947
X-HE-Meta: U2FsdGVkX19easNbzUWxz/8Mi9aYp1q4bREDSuLIkcrtYy3jaksDc5OccR39DNuKeHe+OkrHBzlATO/4/3XUZ4d3f1H/8pFkyxJYRZ2+Ao45/1Bec6z7/Da+1zOycnnXby6hydSX+QMGtQS/hZD0UYMGC1cfrXBpIsC78ybT8gZvhVyz1Tfi9ucjwuZJnvA/7ANkXmQM6ivfKJ37v+5SMmCnJNYmz8UlHIYHE57zAG8G1zj53lcYq+9swLc6Iw7rwwPJE5yuODlk+ySKJ3jxUS8HZGqIo+0o2qwfnUiPNGKTa70UIvLSR4T3sZ1sQpSqVK9ASqyolVt3mEb10X/uk+9npqVXz9jwZY7AIvkO8ZGb3CB+iYcDNeJQRHV93HMhDKrgmIULUAkP/GYK1Fteu1DUl8hAIHmbNdElDVdy2EaKF5mx13MeStSzVXp+5x/aOUoawCcFHIZGdA4DybchE0nyiXysdNIBhbCYCYWRsw/fKuqLSY1iDOPb6CF6iwPYF0Meq0FQRzWHrh6aBkib7Yx/Lb06nkbVGU14DWjjcemfVSb3iJKhVsq1/H6LPfAC4nqAObaySEOG97I62awiEBYI/JLzrqYkKTysQdjmLdH9HYynjoxYaHJakRch45cLpGQI+h1GOKmyYPiDpX4nEuStr4cStV2nPSGYtl4DKyUO/UTOLK0l8wr3Wy3Hoxv//4DxNYGQ9LH1jU2uvhAMLRWSIGa39Dl9o7OewZGPu1sKg7xLMnmnQ/Afqd3AakNpoGywmWcgTSqDNjzlUW8pI7RyzEo7mmRfi8OiVNGqw+30LsBl1dDeO/RUVncCcCfPKWMafc0w8A8sDFssx6/Qa0X6XkanXgLWS+8cb9jLf0lN5qQchyCNH1X40dDtngzJJ5v47+nRhBQaXe/VGOLwxNCIZGfSuPTteaage/vbOtP49e6Hg9CfNiJyR7QG9q4+0EfKl/kjh7DFIwdqPAg
 lDsMmZi0
 rJMRlkc/dhB1j43+TR7d16Gtcw73p2Xw6B4k+22MS/pNBRMA0u1Lo3ezo3tiW/V7uuHWAuE1RYkSkkRwulvtHPZI/C3+6ZvgnN+4fK0xTTFZjNguT7m61fqNfpSTd9U63HcSe+dxyyyRhSQj/VhE1G7c2Z8MBJV/IP669y/4GHDFVOnVMDnZDym4mb1QUT7HcGHfGMVM0GSPQjpfT7XfSJijekA1pKqxnC1akhFROpi9fRA7D+J7I+JwIUQuzLIGzT8srXKzJMpJzoEi9NU/2UogseOf4YeqnlgddXyjJahASRrptLBgx17ZWgVoJbYEOs1+Kho2CXoiuveN6E0L23p2L62xAhZrPP8KBjJTO7tD0RPLi1YQ7G7+Dv0U51/Rp6BMjgpDM4nCoqWElIJIiLSgM4Dg4mOpEfMNNBJNMOnRum49cgB8rqaSJg3JJ94lHVFxGRTrLbaEMwdT9H4jisEBYP4JO6ByUr21aXWgJUgwBwWQI+2ZppeAiRMOB1/hXcYZpfiEIHDm4pt69vcmCwTHDeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Move the kvm_arch_has_private_mem() stub and a few guest_memfd function
definitions/declarations "down" in kvm_host.h to utilize existing #ifdefs,
and so that related code is clustered together.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/kvm_host.h | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b0110143d2ff8..ab87effdd221f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -722,27 +722,6 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-#ifndef kvm_arch_has_private_mem
-static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
-{
-	return false;
-}
-#endif
-
-#ifdef CONFIG_KVM_GUEST_MEMFD
-bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
-
-static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
-{
-	u64 flags = GUEST_MEMFD_FLAG_MMAP;
-
-	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
-		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
-
-	return flags;
-}
-#endif
-
 #ifndef kvm_arch_has_readonly_mem
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 {
@@ -2592,6 +2571,11 @@ static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 #else
 #define gmem_in_place_conversion false
 
+static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
+{
+	return false;
+}
+
 static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
@@ -2600,6 +2584,17 @@ static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 bool kvm_gmem_is_private_gfn(struct kvm *kvm, gfn_t gfn);
+bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
+
+static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
+{
+	u64 flags = GUEST_MEMFD_FLAG_MMAP;
+
+	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
+		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
+
+	return flags;
+}
 
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);

-- 
2.55.0.1007.g17ff1f9808-goog



