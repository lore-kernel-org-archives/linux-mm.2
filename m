Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CA8B10AB82C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 672126B00B7; Thu, 26 Mar 2026 18:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64AC76B00B8; Thu, 26 Mar 2026 18:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538F76B00B9; Thu, 26 Mar 2026 18:25:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3AE986B00B7
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 081C9C4099
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:05 +0000 (UTC)
X-FDA: 84589645770.20.0AB5828
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2C21DC0004
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="PqG66/GL";
	spf=pass (imf28.hostedemail.com: domain of 3PbLFaQsKCA4oqys5zsC71uu22uzs.q20zw18B-00y9oqy.25u@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3PbLFaQsKCA4oqys5zsC71uu22uzs.q20zw18B-00y9oqy.25u@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="PqG66/GL";
	spf=pass (imf28.hostedemail.com: domain of 3PbLFaQsKCA4oqys5zsC71uu22uzs.q20zw18B-00y9oqy.25u@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3PbLFaQsKCA4oqys5zsC71uu22uzs.q20zw18B-00y9oqy.25u@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563903; a=rsa-sha256;
	cv=none;
	b=gdnux3vZQTWP1goA++oLFvPcREMe4b1em0C71Q1Kn81n9g8li5HFKgDU8K+TCgedbxF66t
	S5IRrxaisvxOoEhQbuhMcgGExaKMZezl+UwHgkw0rSx40bh3URu0e8bmo3nZpQOmOn5RpJ
	oQpVS2Z+6ouS9EQXawIWZZPJcqfw3IM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=afYjOzvP16h/SfxvhTKPo6PFaH7oiLN+m8p/p0wfDgE=;
	b=1vqtK/uGIPY96MhxHKmNJAqJuuxGmg0Tz8bjXVf7RvPJjHClIZHpgeV1bhYWB2Mw23m0Mp
	FzSHaDvctIioPYsJmEyg+/DlX4vF5pjluuHmKCmUC62NfxeCrQwQ8j1QRPahntLBFXIz3a
	/IDZx/yOZ4zdq/d1VPnqYe2A3TFNSl8=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354bc535546so1637305a91.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563902; x=1775168702; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=afYjOzvP16h/SfxvhTKPo6PFaH7oiLN+m8p/p0wfDgE=;
        b=PqG66/GL6Cn2c7N1wkEG7k6LqMdUZwFCxSFYiyIeg4cVMTCfK4ChGBVJrGIEbbi75f
         qb9VDdv5AzhlKLcMOQbVyeVGjb+8NmcXtooXDvIKmTNNi2xPZy+o42BFuWnp2K8UnU26
         MiYXkS3KZem5FqMEtnYbJqYCycwRdr30K54+zcFaV6H9gHy07jqHzCxsRi4yanSaioCv
         fvzjSyhQZ8JKjKzmjH9GHILQDMX9vtdXN1q3rVL/zbgFb9UR3wqUswS3QR2SgjxTtDe9
         4NjVZtV4iYnNVnx2vImls771mh8ehYfQWhyu/LoeQZaPrZRm+JDiWtzhIhgEn1dTPZ7e
         zyTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563902; x=1775168702;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=afYjOzvP16h/SfxvhTKPo6PFaH7oiLN+m8p/p0wfDgE=;
        b=fUP6+cE5GFTqzWX/1EQM997+k+L+/i0rJcXvpKdJCyzWBBSYQNFCBUBA+SDyfeyX0c
         13Sxlcfa4cwd3yMJMZzBNZg3z+bJOS/hgd0wMpl6eQrGo5VajVPzHQfbpSmkjQDj0oul
         7vxpN2tY0J7pWfKJhQOButZLm07ABjMLgA6BfhBR0fDktQ1up5Oazwv1ScH6hBEAvbaH
         KfBarX8eFIJCL0N/YS3PfAvzpSUncwL3BuKGP2Lxh6Kpbo/SIhsNfTB3ppJ+kNMjXcnr
         57ke7tCH+ZhLd2rFdvAqf0TklMCgpSi3pfqnqXt757V6ei/y6bk2Yf1mcKCTsdF9PXvT
         M9xQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLdC71idSyaGIZrt8ZriUMkIvaSatLVJjAVG4+UCSvuHSzrrFeLtF8sitsYz1cV9C+dsC/zCBVcw==@kvack.org
X-Gm-Message-State: AOJu0YyeTP6Ijy9m2HC//UsnH493YehSBHBaCrFnY2DSzYJ8ksz1VzwF
	6FJlNnjYv0kpEezI5qaC1e6dc+NYlR+QX2gjUd9wasa3GEBffPlMxMQlLsqDfdVB/pIMqgXHiXt
	O7plP96q6tdEjlrdQTEfejshGnw==
X-Received: from pgli25.prod.google.com ([2002:a63:1319:0:b0:c6e:1869:6f24])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:9992:b0:398:a5c7:3dc9 with SMTP id adf61e73a8af0-39c87b6affdmr315892637.49.1774563901450;
 Thu, 26 Mar 2026 15:25:01 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:27 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=2780;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=7TZkUYE885M/wXgOBZe37BZPynsdjK5T8U6+o9woLC4=; b=314JAxzEs6WcJiM6YyGFVmcscyTLi7cuvImPq+mUF9Ii+v6RmtfL08R7F3Q+0ERv7vn2+MJyY
 FZVNih8negYDvxZ4BfDeQXb+WPayqddg+asn8A0sbOoVY9TrZpWfcM2
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-18-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 18/44] KVM: selftests: Create gmem fd before "regular"
 fd when adding memslot
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2C21DC0004
X-Stat-Signature: py66e3qpdq3yaiix9ea14sjkdsfbouju
X-Rspam-User: 
X-HE-Tag: 1774563902-435050
X-HE-Meta: U2FsdGVkX18ng9NwwSz+p+1agqT1tlVLzpNXOSOrV1Ad4/FYi37sWUqpnRsK2t1PLB8ereYQ9mXWtb9VsO+r4qFheStjG/iAc8P/CrIURJxCmqfWgGTKbwo6m1FjtGosxFg1A3neca+w8n8OVm3Oegx1Txg6IPQ1s8pWuzG22N2XHDDqQ+MCnSmqJCxjwJRJ5w4+GqF8OI3hdNlcBx9kMnNXObMdL6jZV+dHhEOmwhoy/qZUxrUnvrAnyUfc2RapOYywFldS3D77tY5600A6WZ3P7IVZJg6++NSoMMntL+aPtLAdVvCx/RFhPnOQQ0jK30WaD8ILH2oPc+D8W3Pvn7vXVgbSRzQHNY2CCuRrRQ4ugoU03U8pbJZ8WFkpGHyKT2y1qXLpYEpzRdfDf3B3sCUTDEzLSqas3BG9BN6+KT+02LnKgQ8bXNhpyPxYStIs/cadsNnsTHL6M/PhXRqWT/pkoU/GbuDtvwDN4d5BTDLBk4ZR/bKOpTubxYIddCIt5JuTF1tfjH+cfKj26I8TIoC4wr83o8LwjGrPtH+Qjwy3o3Zn2f8fAqQnOffCMvayOdVxEAwyv4D9Ey7SXhFfD6ynfImZ8BB4TMsZp0nQtA3oSCZc+9qIDQcSnZyNP7BGbdmTTOjADh7ShiQ2YKVg1yciq8zytD1+7GzeGtYoo5YYv/8Rkgjr8VBRCgXTd0yXDqMErLUYkwl0gO+eoXK5rzVc2/3WbslYr3cLffobzjBALGJa1LTHHX2kM1kx7vCtrDRW9aP5TAObnYFxJIQd45bN/vmmO0mmp0iOXa56OH0mPlUm+mDojX2B1/MI3AAHBZcG+wd1ovOjnQuTiKxruXxYP0ODLHlssWdqvOJrBFtnI+lsPz+VGohpBT9KXD/t2MoNPz99mXnsUTIsCNndp5t9XilccBKfcwy4rO0irJcfK0lXf5m2V7I0KSwq7VdLtR8s84u9EwE1zkukLY2
 46I0/Rgz
 /vnSiPNGHLA4acZc7RUO+987OMOyERe/3Pkfael0ivbgX1XVLeESIdWdhuJad31DyePa3fVkkZDEVidyeYRDlAUYkJUqPeKEX7HYH9w/kWE7N2UPmOCL2WSAM7UPhiOUEfDQ5XYv9VM/ZWDgyoWbi7Uoq8fEjwwEeQplGH2/vPpmPh0PIwbBbevqNL4OSgMHbL0+qIjHvjy6NMVOx8R9LkIJecCOk62EnoG60sRsCP/wZ2tEdKTqwf+7YA/LENSK26R1S+94/XWy8AQeN+GOuCsOnliQNV3Kyz9QRewAsJllBHTcPle5gmew1lDxh2KFFTR8Ld46qmkrmmMXic3bux9HC3L95jVejZvMIqPu1bsOqL0cUZhdyZn15878P8bKWnZ85YVMlArM8UgjQTSOikVuIBE3AtfeFWuSiyR7Sp3EfORjcdM4q0eTeI8dhHFebpJM8CWEDW+aKHv/udyuM8PK8BNSNXANgIjIRhUQhY806y9rzyAe27qQJp4ZwhAYR/xjm54m9WYhNoBW25IoaTgBfo0Bos8lRLk5K6qsNJ0pOQ9O++XxGU0uImTs7odFY5i8P895yGmzGCsKAFZRs8fjowKceo7V2iphuNKdfGx5h2BqR8yZCx+pCiMUB6LPNutK2BKPhUgvlDa/HAY9zP6JZTL4xbhoFxKXXDxug8Jwfas4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

When adding a memslot associated a guest_memfd instance, create/dup the
guest_memfd before creating the "normal" backing file.  This will allow
dup'ing the gmem fd as the normal fd when guest_memfd supports mmap(),
i.e. to make guest_memfd the _only_ backing source for the memslot.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 45 +++++++++++++++---------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1959bf556e88e..610cb32ff207e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1061,6 +1061,29 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	if (alignment > 1)
 		region->mmap_size += alignment;
 
+	if (flags & KVM_MEM_GUEST_MEMFD) {
+		if (guest_memfd < 0) {
+			uint32_t guest_memfd_flags = 0;
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
@@ -1090,28 +1113,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	region->backing_src_type = src_type;
 
-	if (flags & KVM_MEM_GUEST_MEMFD) {
-		if (guest_memfd < 0) {
-			uint32_t guest_memfd_flags = 0;
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
2.53.0.1018.g2bb0e51243-goog


