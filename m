Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13720C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A39B56B00A2; Wed, 26 Aug 2026 05:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A10F86B00A3; Wed, 26 Aug 2026 05:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 816016B00A4; Wed, 26 Aug 2026 05:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57B936B00A2
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD7F51402DD
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:27 +0000 (UTC)
X-FDA: 85142869854.18.7D43057
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1ABBD18000C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="XZpLsP/R";
	spf=pass (imf24.hostedemail.com: domain of 3YK-OagsKCFUxz71E81LGA33BB381.zB985AHK-997Ixz7.BE3@flex--ackerleytng.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3YK-OagsKCFUxz71E81LGA33BB381.zB985AHK-997Ixz7.BE3@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rdZRVSrnkEM/WAJPszboRZoIkHXEJBSzC3AJhV/B8JA=;
	b=Pa54D00l8PFYsAOcPwX0FyIGabY1cGvr/Daw8BAPFm6Ci0rzvbENVpKDCnB4tWhHcUP+9r
	TlyNHtQIq7NE4oR67Kn4N4LI449RnZ8ZCizOR5Py1fdCamXCsMGHipPUB4OO9qae4or17e
	JzZIQYPihWJ7Q9UMrVZgdT97BeUzTo4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="XZpLsP/R";
	spf=pass (imf24.hostedemail.com: domain of 3YK-OagsKCFUxz71E81LGA33BB381.zB985AHK-997Ixz7.BE3@flex--ackerleytng.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3YK-OagsKCFUxz71E81LGA33BB381.zB985AHK-997Ixz7.BE3@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735906;
	b=cLJ2hvUc/e7Z6ig/TY02nbAWcYRvlabO1Xa6R8a5SAPoWZlAEv/I9UMg6Rd2RK15FVFq1r
	75RZvr8PYB/hmbM0NmT+3oKSxo3zxmVcy5f8hvgGVFF1uQpMLzqktiZp+DeptZGsmJzhyy
	ef81qDZFrYLW2Z2xdLSa5CJkDqIW+wk=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cec4226c70so10270765ad.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735905; x=1788340705; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rdZRVSrnkEM/WAJPszboRZoIkHXEJBSzC3AJhV/B8JA=;
        b=XZpLsP/Rp76iuhaWUTG4YB5IpZneN8VcFv3LmUvaHMO+dKo4iZuCbuhIe3Sd8az9Xo
         M9EDhzGPq60yK+r81aBp1eDCoCWD42Dn1uzjRYjMKTtpmGsS3aoM6Iu/Hd2kysph1hJk
         WPUY9AD9SgwNg1m1qzAwkRC+FZAzl7wSulUbG5fyh4xvfGKIJMmfjwzl5eeWeLiEFs3h
         TW24xAu7isEtoEXVcLMPIWcWhRW/AI9cAwExiKNc2sLGPLp0/sg8xLDashRzMe3tELS9
         gm/m5StX5G3fYNzaw6e6oHnrNZplW4IU+pNrTm6AlDvd46tqB9vMYozjUw+AWYU7fJeY
         mgZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735905; x=1788340705;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rdZRVSrnkEM/WAJPszboRZoIkHXEJBSzC3AJhV/B8JA=;
        b=TyTcvhM5LaSoABAD/bkCnzGeTMxAKvJnAoIfaWnDiSqpyciS96IuNufgvFPNnU1Jxb
         TgSIrA2kW5Tl9mmfTgWpU34A5ljN7P1ZSFZNlfB3acFwlquhUtHJrVoZxAtgLmnHmDda
         Nj676YhwFmngO31Kx1FDrGcsTZn7oS/mAF9DxElBIFHWEzqbQ45WfYEDz0mvUrPdUdhU
         K4euJDdB0yKO+NvZkYeec//6j9wW2xP0Rj9cH+WZz6C0KsYGQ5clR8wOTMXoUIcWdHlg
         VDSXk66zJ7aF9jm4B+2stRSAKmlNCuTHclZgVMlJfqW3P41G4e+BUH3Ipio/Sg5VPt1N
         5tFA==
X-Forwarded-Encrypted: i=1; AHgh+RojrSP9OM9CPMnUzUy7UhtijnQZIIZLJUqBfdGYYCJfyhcXok84IB8+5NXw0WDN5GIi4Nn48pYEKQ==@kvack.org
X-Gm-Message-State: AFuF++kUXAuew8v1wELrM4Mvk5kH80c9Hp3vNyzcsvEzk41oO1uSrN1C
	+GULA4cYZFTO5it2sEFf2rMnU0DuLn3zU4MgUVWuBiwGZBzfMuKbusWQGUSeV57W7qVcEry64cH
	qvxf1O1hcvrulS4aqGkG6LawFTg==
X-Received: from plbki11.prod.google.com ([2002:a17:903:68b:b0:2d0:159a:c32f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:19ed:b0:2cc:864b:539 with SMTP id d9443c01a7336-2d7079ffa9fmr95729835ad.6.1787735904427;
 Wed, 26 Aug 2026 02:18:24 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:08 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=2542;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=JEqd6+3Jm2IN8pmwc/4dv/jyCthiIWqttsX9YClt2p4=; b=nsKZnu1YDavx7WArwRNpZYT8oZFR13lhfa0X6RxUzams7dxT8V2wkp13BS2tew8618zVQoSdk
 IMAoO1VhDEGCOdZmT0xofpV4JgTgxEjtuLo5vH+ZhyBHGZ/doYV1t9o
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-10-0a15d8a799aa@google.com>
Subject: [PATCH v11 10/46] KVM: Consolidate private memory and guest_memfd
 ifdeffery in kvm_host.h
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
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: qe1dpnsbqr8341psy66hagahomnnpyxx
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1ABBD18000C
X-Rspam-User: 
X-HE-Tag: 1787735905-323096
X-HE-Meta: U2FsdGVkX1/zHd0PCc/diXQX0EX6WBQMtCG8WQs0Xe+CEFIiSIPA7RwOnXRQhl/rjVxWebKu59f/KftSt/I9y4tSOZcsZSE+jIQQ1PvX16coWagZWMCI2s16vu6AcSGj1Fy89wihViVijA89tjMK7fTLnIWq/dV/T7E7y6VBKZYW3YtU9hTH7fjJWhyiJ662cRwqYD/VC4wPRWb4fINNoh4tKwjDRiecFMOxXZWgJK+0Wqm1B2jNRCgSmOBnyn3pGEjXG+iDLatxJUvjWMQHLAKcY1H3li/chF/g3TIYhlZT/XPOa4HXCp62VQCYeyiuqWY5+00tQh+zyk1gQjjUHQPZbHR2RfG7zUh5+S39ttIz+4zBjptPlkQ86fwIvku4Lno/5LNDWwk/lt7SNnKkKRFu4xeWRBj50UrNJaSBEA+XQNxGpvRnnSGDhfXue0DrJwhOuJoHQIiDZo1RZw4edxypDDfsu6bUPlPcQVqCdLFBjZdaoPOVfPGev4g4hzg3OICjnqICHUEYfkmB1UPaXOxHRjFJuqogDLRItmaIyUCZBmlmmOEUDjlCDPEIduSfZqjVNyJDX6YsnZxpahIMALwXrVVRN9F43aOEFvKxNwp7W7oCrgP4nFNRXU0wQUQ3GPAygjU+1sjRzGsqpZ5HjVZPvwC96X607y5ShpQIaaZanT3hRdgZ5w+CrHWoyK0KnHNHH0LaOokBuR7NNKjD1wApP3S55YnPoii7pf+2FvYPvbtbQee5zgLidr4+evH4Xd5B6Qj66rpOrEg/ckqJkzmnmwc/D9Zq5PC5CfKzbrRvimIjTwsXMuiIbTKy0VFI9jLAF62wm4Z+VGMIxqdurLemM2Ks0Rodou8nMvf56tsErKU6S+0IubS4z8aoQx38stZkGga/1LnWKDA07dNA8Lm7j3UyXfiLkp3J9qrbMq48j1MSQbvD28jaxcqSLJEYWzW358GOnfW43KBaBCJ
 zK+Ra2Wz
 ktguFVRcrVjrZ9nISxEwGxhTflGt55uT0NIRwBMSHKApfUDTtnQhY8WWoTE5VYV1Be8Djeqyb2JGzkQrKudlZr+T+8KgbbqzZlueff4nlCW6ctyA9nWR640wLsLVDiW9KnkKZZn1uBKuhhMZBXOEkAZpabcbcHkneiF9NP5DGcYuea2tEk+xImgzVolgwc4qRfVLH1nghiglSofwGTbqPcX7jr6furBeJHJWgpleMNHu4GA+tATaGdpsleAgzDKzWgzzt47iKYZa/A7lIjk0L34Fc6EhtSZCkSBxEb14qw1W/Bll599BCOZ0Dt4Xi9oNIvOtCGZP6TqpQkUU84UESB2DAiz5xTKIg7OWOB5D2sGpoQ6FXGBFxnkl6O5c5gPgL3vZqw5TPII6Pa1X6tz4u7o+U+DKhFMAD4+muKfSI84/3vBnPOWHSxyE4fyaqMCxjlrw3SEsmhDJYwtWxkNDNJahBPXf/YvI4/NqEUbbjEEQLmloWdam8/i+wes0zutoMC/pWeXSs7tdax0cbuuMA+A0fW/S5zvEpA121E2/EpUrTP2l/iSfJn7w78gS9vEavDavQL6c0AIQtW3AaTXsxKdNfLR4FbpEvkwXqMVknWIUxJ/P72UJYrwhCVICt7FaDRCd5DMMuxc2MI4t1XrtWrn90odSq90RitFViZGvv93/tLXPeddVXkk9IwQOqyVFMauBUAk1kL5X38KqTRyZqyI6IsiuY/z3/W+0GIXhp3riWRXA=
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
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
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
2.55.0.887.g758fc8c411-goog


