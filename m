Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0F2FC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 643636B00B6; Wed, 26 Aug 2026 05:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57F626B00B7; Wed, 26 Aug 2026 05:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F92F6B00B8; Wed, 26 Aug 2026 05:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 118AE6B00B6
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63D1C1402E3
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:53 +0000 (UTC)
X-FDA: 85142870946.11.439E29F
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf05.hostedemail.com (Postfix) with ESMTP id 98E94100007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Uz/gqliB";
	spf=pass (imf05.hostedemail.com: domain of 3eq-OagsKCG8NPXReYRlgaTTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--ackerleytng.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3eq-OagsKCG8NPXReYRlgaTTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735931;
	b=LMDk3Etu802JIlhVUcYncVzROrfDRWOdr/Rg4ZGSIWjgEn/VvS/oed1XWwUsFtSf0SG33/
	PlG32TL90N9DUs47uph+6rv03Boe6mF0qtG4QEuXBoqjsyb5J09NsZCZLAR3uB42v7wgyD
	aNlgu1bnlRPILP+gdYmT6eCF4hTdWVo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Uz/gqliB";
	spf=pass (imf05.hostedemail.com: domain of 3eq-OagsKCG8NPXReYRlgaTTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--ackerleytng.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3eq-OagsKCG8NPXReYRlgaTTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TeMJJdODrGJdlu806vqL84QXzoIcKrTnV6sfhdG6lEs=;
	b=AFURWDIeuP/wSx/hk2pZJ2+XvKOy3DqIsfLkMltUB80hD2V407WmRaCqlUAVucJVaVl5aa
	oDCDg3XVDF7XZick07Kso2cc7Gezrh0sj8JOtCyABEwlFSUN/fvwI3Mp40aqSiXWwGq+Zj
	7jovfDOZ8p9u0Du1D7R6GTJ01d3awr0=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ce8a76df2dso16626105ad.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735930; x=1788340730; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TeMJJdODrGJdlu806vqL84QXzoIcKrTnV6sfhdG6lEs=;
        b=Uz/gqliBiFoL6nmNxdH/Q8QlOCy5lQ0P+8b8/Sp1CQJ+SJDfaSddrLm8qGr7NPVShR
         25YLEZkkF14VkLnnWINWrH2xN8UFBXChGDuYMuNzsPeLOplnFcTAw+2Ii/eLxEN3JpAR
         GarIdIt6/9WgIYbyiDLtful6a8vYKil8bjiymFNZd565/Xyyo1AqgaKMuTKvbOV8dH7G
         Lzbd2ioOxcu45XeY4EbWkc+jOM/vsIVI1pSRjNtl91W+Hd51cNBA4MJeTi/iGVhIRvUS
         f0j3sbaiRz0KlP+5guirsr6QKkqMB/ZaxDXOfrW6bOvr6CE+r+HfgapHzgv1WTxN8aoZ
         lgOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735930; x=1788340730;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TeMJJdODrGJdlu806vqL84QXzoIcKrTnV6sfhdG6lEs=;
        b=a5zDxIoGTLCPJ0jEJ+5yRb6ojmMl+fv7MPk8YKoAOYyYc+wZB0zgpWnhHMMX2RNPOd
         mUjTyntlTrgMff50KaXFFy8yEwvW7QsK7rf94mq7JsFE6JZlhaVKvMdBl39BrGFIXiho
         5Szq1lajnmvkswoecsqP6V7g80J7TkV69IgSpW8Sp/LNIluj7IBPHlEKOG20LPauK31t
         1bXmA9OKXd65fZw4pUH1rhhgb1w/yARCgdc0zS04tZZMdV3Dhl1JUmNBBvpbCfTTzrsL
         vAbonsxthVgSBR9hpwMPtW8r4YS9QQFhTzVzjlcBFXPyQU9ndM3xNtqym1e0/d/n6g3R
         9cGw==
X-Forwarded-Encrypted: i=1; AHgh+RoJ2i2cElaLUYvva9KUhwFW5wxoIFDN5aax+AHrKMrLzNs5vlYETflqoR3tq/k3wTxGQnssvlkjYA==@kvack.org
X-Gm-Message-State: AFuF++mZ0/FOAv5QTV5OTy7xpm2R/nmTZl8Db7nbbxoaOXbi8sn9aIa0
	kYwyy/Pci1kUHDdlbQQKQmihWgdUauEy5Kgg47519UgkgWBDMnQWbWjLLSMQuyyay2Wea+8j0YJ
	i6FQcV9Je7WPx6sZlfKnWLTDWlA==
X-Received: from plco20.prod.google.com ([2002:a17:902:e294:b0:2c9:b703:3bfb])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2341:b0:2cf:c543:2c7e with SMTP id d9443c01a7336-2d707b4639cmr87037965ad.10.1787735930069;
 Wed, 26 Aug 2026 02:18:50 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:23 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=2916;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=7deP7h7QgDnwN6/9QKin5Nm8lfgB+57/3gsjOj+zwyw=; b=CZvlPH/OyUE2cOwFZHq3gx+or4V4GkEfPVHtR5IRBhyoJc09nGOpZZvAf2iumEeelzHT+XQgZ
 fFOTyta6nJOBd5QLNDNMDklfHWbkIyZvfWZ5tyanGQIZCv0kpN5zCS2
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-25-0a15d8a799aa@google.com>
Subject: [PATCH v11 25/46] KVM: selftests: Create gmem fd before "regular" fd
 when adding memslot
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
X-Rspam-User: 
X-Stat-Signature: rchz1wu9ty4bkx9ke8w5n6qz37aebpim
X-Rspamd-Queue-Id: 98E94100007
X-Rspamd-Server: rspam06
X-HE-Tag: 1787735931-847527
X-HE-Meta: U2FsdGVkX19tWf96F8RhFRzAL5LLv63YzCunjWBy8wJr5krqYwpBzFL+IxIuvLhdO1gzQLr2UM8w3IuEEqUMIRBX08RRmkgRyv+TMji/FUeQRgpkwgFU1/PSt637tnwDMriKWQg5kFZzEzKLdoWMEle0lvoGHm5MXN5dRtRcumaq57usTnHKJbMUTabCRkg5PvMZXh7hFM3lY4yXRUqZcONjOZP/oJn7Hiw1Jj1QPgo3P686Xw51Z4CT9x81rXSWmb1x6phvsnbAMkrysKo0OHW2KZtF7GQXUcy84iTjoYIfVDnGs17dq2t/FQ9PuIL9JrExyp99RW7nWsNrc5O4VuEW6jrxxIVw3Unf4n7acLudV0xaEIS3Ts0AW1uM2DkYfPFIgY4zRYXyRN5C1t2S/lVydo+bndfHgQSGxjX6Z21A3apzqXE0ccMNttQLe/LvNnPyvLec4ET1bR0ARrSFzbsEknoiqL2Jcesr43J0d8Pbi7q4Ze+WHYxPWy8Fn1PWa4qYRS5pBbwe0eh9YFZG+jVXrxJugULti3RPYNM0mk0/aNnslCkidxKw6Ia19kbk0mMyW5b5T68bDJ+4pk6Obz0IWGCwKolwo5KAadP79IG/V/lFjZN9NxaShypbn+fGyeTqp4u5QlwfpdVJSHCEvJjEdexRWW74yjQLKz2ScJHLgaZmipTX3lQwOMInmcxK3ke2KcXihTZXRNTBc0XPPXmm1chkOQ5p1Yq1qJAnwRiHMRlqxMfEGB4LoxY9kMXIXWPX6xx1T1uZVVrBmddkbkWVYTFQx+dkhA+yrroy1pOhPZOuLiDh1wxqTYFbcUrNlg+rvuaBw8VU7flm5Q5YMeHl/bNK40u0XwseXUGuKLlHMHwsSPMQ0QoIX4YJ8tZ8WiaBBE05DT6Y5gTDvh9aVNdXAAYO1sUjrCCfHpgE6G2CtUuC6xt7Mv/Mmv5Q1ZQaj0vb+lYgI2TDmgE3+gO
 Tx9Uv57Z
 hDODnZBbLaq3b4jFHehTKXe6jLM/Sjq+2m6DoQw4dGlcfcKAJRVL2YXLpl4jUvceJspaG6BL3Nd5HzJYi74BONu+g/S4VrNHfBMfzAnud+y3JamqTDmAG00c6GkTQrovYWIU2LAFHZR4h62mv1yFgKE57RBoIAbzM/kYrDjs3diXBv2yHHA/RMq6WkSGQ2Cyfb2CuJ5LuDVW5E3MdS91zDx7fCEZwce8fOrXaUguQ7+Ao9CLQ0THGBAdmx2OPfC9wvgFsRfLkKg7QR6EGkr7yJmFF8TJsaxOQOo40MrrhLGg7SGicw9E5x0XM5fLOGLw2RI2dZHjjUxDWGn15spKrimDE9fuEVkz/uyGVx1ILGJhFd1kRkt83r7D17Ufnd1qjEnYXrqtieqp/gjrxPr/8zV3OpcFt59fVewHocGvvOtqhfNniOmnDJWTs5a2CQIVpCITwpz2AogC5lIWHIOF9CZMuHsHfkUMPF3MA0Ba5yQ2rw304yog9mK8dfqyDFQXzBRpYiCUYnBR1C6DO4TG/97ZFR0E82NRJMtUE08PG9Zkq3W0nog53jaCaKFzkDp13DkwKXbw/qa/72YKRoFI/5eQ1cGSIjwj99g7jLlrb8Mah3iGs6ydTMwrUZ6i8+4vKkhOeUfmLtZBhwAY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

When adding a memslot associated with a guest_memfd instance, create/dup
the guest_memfd before creating the "normal" backing file.  This will allow
dup'ing the gmem fd as the normal fd when guest_memfd supports mmap(),
i.e. to make guest_memfd the _only_ backing source for the memslot.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 45 +++++++++++++++---------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9ddc047d5c275..3413d45e34faf 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1077,6 +1077,29 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	if (alignment > 1)
 		region->mmap_size += alignment;
 
+	if (flags & KVM_MEM_GUEST_MEMFD) {
+		if (guest_memfd < 0) {
+			u32 guest_memfd_flags = 0;
+
+			TEST_ASSERT(!guest_memfd_offset,
+				    "Offset must be zero when creating new guest_memfd");
+			guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
+		} else {
+			/*
+			 * Install a unique fd for each memslot so that the fd
+			 * can be closed when the region is deleted without
+			 * needing to track if the fd is owned by the framework
+			 * or by the caller.
+			 */
+			guest_memfd = kvm_dup(guest_memfd);
+		}
+
+		region->region.guest_memfd = guest_memfd;
+		region->region.guest_memfd_offset = guest_memfd_offset;
+	} else {
+		region->region.guest_memfd = -1;
+	}
+
 	region->fd = -1;
 	if (backing_src_is_shared(src_type))
 		region->fd = kvm_memfd_alloc(region->mmap_size,
@@ -1106,28 +1129,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	region->backing_src_type = src_type;
 
-	if (flags & KVM_MEM_GUEST_MEMFD) {
-		if (guest_memfd < 0) {
-			u32 guest_memfd_flags = 0;
-			TEST_ASSERT(!guest_memfd_offset,
-				    "Offset must be zero when creating new guest_memfd");
-			guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
-		} else {
-			/*
-			 * Install a unique fd for each memslot so that the fd
-			 * can be closed when the region is deleted without
-			 * needing to track if the fd is owned by the framework
-			 * or by the caller.
-			 */
-			guest_memfd = kvm_dup(guest_memfd);
-		}
-
-		region->region.guest_memfd = guest_memfd;
-		region->region.guest_memfd_offset = guest_memfd_offset;
-	} else {
-		region->region.guest_memfd = -1;
-	}
-
 	region->unused_phy_pages = sparsebit_alloc();
 	if (vm_arch_has_protected_memory(vm))
 		region->protected_phy_pages = sparsebit_alloc();

-- 
2.55.0.887.g758fc8c411-goog


