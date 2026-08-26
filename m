Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DBD8C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002CB6B00CA; Wed, 26 Aug 2026 05:19:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFBB86B00CB; Wed, 26 Aug 2026 05:19:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4426B00CC; Wed, 26 Aug 2026 05:19:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB0336B00CA
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:19:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E14C71202F4
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:20 +0000 (UTC)
X-FDA: 85142872080.10.5BC4283
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1C09240009
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l81RAIlM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3la-OagsKCIooqys5zsC71uu22uzs.q20zw18B-00y9oqy.25u@flex--ackerleytng.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3la-OagsKCIooqys5zsC71uu22uzs.q20zw18B-00y9oqy.25u@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PLqZOLBapggAgTh0v8ToB3YKqPPya91M3lrmoBKPLbM=;
	b=KklcBb5Fvf1kqO67iQWRtz0yN9xQfnQtz9fqCx0xnwD7BFngAhd97eazFTsPQ+ED3sLSuT
	/amYiidweANjtyd6cHbPktFBl+XTG0eBm2gu5LJ/Ry6AitYuw77FtUmybGgT07nelRdRft
	nkCW43tb1J/OasatDlfopZcRKtBQ4ZQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l81RAIlM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3la-OagsKCIooqys5zsC71uu22uzs.q20zw18B-00y9oqy.25u@flex--ackerleytng.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3la-OagsKCIooqys5zsC71uu22uzs.q20zw18B-00y9oqy.25u@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735959;
	b=OFKfH0XLc9zqlhFhL7Zfkr7LBU7PGXgmzEMMPLxeu6BHy7hRp7/b4VUToHn4STDpv8D9D4
	AoHrVJv4F0IUJqzsIAKinpm9bYc7dAHQZulcExGj4TezNrnTRSSQ46iPFafdzXKebwqhG8
	o/8RrGGeYoCixiQuymRs8TpdzDEAW2c=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cc7e86e7c5so13431505ad.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735958; x=1788340758; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PLqZOLBapggAgTh0v8ToB3YKqPPya91M3lrmoBKPLbM=;
        b=l81RAIlMy6ykJcWV5Fffa/WaPPqs8AeJimh/NvlHyIyL++tdz3V9XYNOfGE/Rep+Xg
         L3sMFCC3YSgWmqX8q0BFPI2zH3qmWO2eXgD677dOP9yH4mgTprT940hjTQ60ChEQvTFI
         F5nsMxvBw5srr+mNG8OMsHjziA5IBZiTmgcB5CyZFcjTcn64WR0ZJKSQevZSV7uv8uly
         FomhsipKtKULXLNVHnzm9TFRp3wrQaYNfkpwmO5HiKDqnZXKzBYRNsjJlbDsApLLPS5z
         b1y+rbgHwv5xxyTBql2Ral6yqtzMVZl5rUkAwclJLmLafTb2OKrd7r7b19dEGRv8lsG0
         Ii9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735958; x=1788340758;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PLqZOLBapggAgTh0v8ToB3YKqPPya91M3lrmoBKPLbM=;
        b=aaYEUurggf4qrCCZ0Are1uVIWSFLy0G50vhlgeVOaRILpfH7wbY8+I/pFok0xZ+RSn
         R3oawrvPbdcbPEfWawxOm3Wl64b06Z6Fwg0k94qWUdwarISUhmbnbU0sI5kvI9RGV9Bd
         mLbMTE6HGA3QEOccxaMnAauIWI8cULBChIc70cGiVYARqvb6JRRCcXVQx8PxI8mRZe6/
         SmZQ8ICi+DXyTIYISpGZHkpYxAcmufyUwS9RdZ6hG7EriAARFVESx9V9LZfrAIh7zzMR
         7jCLBpnNZwtDyyFZcZWTXTAOFDIsn9GCT9lCyiODeOJGQOKTXhl9xHooRGDbi6Q7GufQ
         7RZQ==
X-Forwarded-Encrypted: i=1; AHgh+RonMh+jBFF3JTMA433XL/ZVBbTNyBSHBBcHA1k2U/vszm6FQL5qo7GFN6bpAFFnAt8q+IIv7SDkuQ==@kvack.org
X-Gm-Message-State: AFuF++lPeCJa9vlTDhn27CnJsd4XkWMF2WwjLg0pkZ+niS7u3S/Km6H2
	qWbHOFqcDwcAJSS6UpaUGrKdyT9+rm6jxkywVSQBse0TXvApk9CvT/Mms9zo4X62zc9CRZQvcmC
	yQ2/gSXpu8fQJKf2meby948GCQQ==
X-Received: from plkh12.prod.google.com ([2002:a17:903:19ec:b0:2d6:e427:73fc])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1a45:b0:2cc:d6de:d597 with SMTP id d9443c01a7336-2d707a9fecbmr93482805ad.7.1787735957517;
 Wed, 26 Aug 2026 02:19:17 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:39 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=2853;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=KrfHutYDID9ZpS/QrQgxXNh2ivfNp+DkdslA3yVHWOg=; b=AvojirCrTsfwdIbnWA5buIntUCOjUNcNGy9Bkh8lUDQsgnH2HyYawXH79uUJxeFFALY27Ytjx
 awXjeiPTATiBTlEnjkf3iDdDkOOiMl8oaR9xK+2t16BzXlg+JCNL7Kl
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-41-0a15d8a799aa@google.com>
Subject: [PATCH v11 41/46] KVM: selftests: Provide common function to set
 memory attributes
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
X-Stat-Signature: 351pgrxue6mifk5ikknygm6au3p651fe
X-Rspamd-Queue-Id: 1C09240009
X-HE-Tag: 1787735958-260891
X-HE-Meta: U2FsdGVkX18tnpxnj/sThgsVDkuMVUx7vD4Mm/DPaF5Ibx14pSTz/V5ZGtMtdOkDyBeVTqtzu3tA5nejterO5wJMcgCE3lsgPFG/Kn/0+Ba/SPDYd4RLOATQ7sYPxDyTsV7pUG2Dg8xoiQrv2lkirepJ1gf01BcrLoV4f9xLi2sf+S9juNtlmxQ1rrMZF6Q9r33WRG24pR61qZd2EVy2O2FfrSKlnEKe+TzvEG9EcG5yUHH7QA6UHXrK/0NKb0P09bVYjvGffM8zYyRCi/ypL+WFrnQfqEi0cZdrL6Z9RGkk3EvnXUwYKbPrJ6F45PPoGauRnGGlxp2ClcHlQBZdvek+YxGvYd2ZkFRlEYx/wP0sPtxpRoCGI3EXqX7CIQcubnJwABJgvECcxz1TiRk5BQdofoyIK7F5UsGYctMTOF8HU2MxZcFV5TFB1M98uelWHKTygKzW7sJpeD07DInN2DgFseR1Du546EBSuj37VV68MfEnRz91asSZr8dk3U51RlGzXEMSWGlJd+iR8f73ip491LYw6RY6p1aS4yF00s2ZMI8zSc6jo0wS4LnqHiSj9NaWN2U/OAF/wWUeGDLrTIRsfgSkofwFm123Byb6PxnF5+cSbhn0uktsxrvRkozzpwpVte/of074QyuWAsflYCjz2u+U2J6FlGDMtqa6aIvyW4aGUbKswNE2PhQJWc2RR0pC4fNn1PQpve52uITUNRjcPg/BQ2I8DYE0WNaYV2OMPvVUUaJ6jQIqlvNGMsOgOwQFpHnu37TCEuDOdCEq7dmOY8XeVkmnI/tX2BJs+iuN0STDmWQ+nPKKauW8EpBPZpRkkAMCCLDXt5Rb2WjEsw7eWYbzsPsHaAOu8XPgPnr5+0wGmM0DUR9lgE5urv28O5l8umvkvQrkQDViedItYyDvPTixiwsi1oglpG/9746XeCATmJ7ZVvZTiKbeGB58g+x2w7AwQ+G1xbRF1bw
 zif17Tjb
 OcsqBjGYhQdiyMgLrdDP5OVkcyiarZUyJ5o8BiE+0lw/qxPbnFZWBwtL8mvaA2hoePL8eZZUR+toKc1kjhZzXGCLendgJYvbxEZQuskQPupQZ6yWCb010bJyAjcu9T4I5T673Qx6E0+hxP4YvHxW7xHCfYcMlj1vG8JUNBwNgFmJThpyuofHjTEPvoKzn62hoJwNNoF4JKcz9WSJtH/fn+MgFIaOfJdhI4nIHbx797bxZFEg02tluPPy9yiLIi6hzPSi7FbC4KjL8x9xNP4Oq4pkIlEIX46ejtCjZgXOQQpxlalyKPPnHnF5YdUTkLCJENeODcChA629c066/u3oGGYP4HiRVABrPGfjjozs2ZOu9XhPArDhFnqqduDb3l7NSjz8/6P6c+XBa1fK0Ycp8+wl3GxIczOoA65VP+XQPbPsYFT7gZFM2u2zSFHUFpVP5VmEiA0XIQzBUXWoTblWwnhllfR3+vthkIgekj6plgIGI0ev8ATosRGhTfE/Kx2Lvv8KHeMgdFm2togOU1LzhNvONRj7YpTGpIvI65tWXpuhQZtf3N2NAwusL7zPTRXyuFde0cCCLjAIq19pxFqOgrr61OmHq8+i952kPpcBBlFMQFcBfytTyfH0hfyvZLNzBGGXQPGmOHxPLNeQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Introduce vm_mem_set_memory_attributes(), which handles setting of memory
attributes for a range of guest physical addresses, regardless of whether
the attributes should be set via guest_memfd or via the memory attributes
at the VM level.

Refactor existing vm_mem_set_{shared,private} functions to use the new
function. Opportunistically update the size parameter to use size_t instead
of u64.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 46 +++++++++++++++++++-------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 795c9eb311071..777fa3dbf88d6 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -454,18 +454,6 @@ static inline void vm_set_memory_attributes(struct kvm_vm *vm, gpa_t gpa,
 	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES, &attr);
 }
 
-static inline void vm_mem_set_private(struct kvm_vm *vm, gpa_t gpa,
-				      u64 size)
-{
-	vm_set_memory_attributes(vm, gpa, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
-}
-
-static inline void vm_mem_set_shared(struct kvm_vm *vm, gpa_t gpa,
-				     u64 size)
-{
-	vm_set_memory_attributes(vm, gpa, size, 0);
-}
-
 static inline int __gmem_set_memory_attributes(int fd, u64 offset,
 					       size_t size, u64 attributes,
 					       u64 *error_offset)
@@ -532,6 +520,40 @@ static inline void gmem_set_shared(int fd, u64 offset, size_t size)
 	gmem_set_memory_attributes(fd, offset, size, 0);
 }
 
+static inline void vm_mem_set_memory_attributes(struct kvm_vm *vm, gpa_t gpa,
+						size_t size, u64 attrs)
+{
+	if (kvm_has_gmem_attributes) {
+		gpa_t end = gpa + size;
+		off_t fd_offset;
+		gpa_t addr;
+		size_t len;
+		int fd;
+
+		for (addr = gpa; addr < end; addr += len) {
+			fd = kvm_gpa_to_guest_memfd(vm, addr, &fd_offset, &len);
+			len = min(end - addr, len);
+
+			gmem_set_memory_attributes(fd, fd_offset, len, attrs);
+		}
+	} else {
+		vm_set_memory_attributes(vm, gpa, size, attrs);
+	}
+}
+
+static inline void vm_mem_set_private(struct kvm_vm *vm, gpa_t gpa,
+				      size_t size)
+{
+	vm_mem_set_memory_attributes(vm, gpa, size,
+				     KVM_MEMORY_ATTRIBUTE_PRIVATE);
+}
+
+static inline void vm_mem_set_shared(struct kvm_vm *vm, gpa_t gpa,
+				     size_t size)
+{
+	vm_mem_set_memory_attributes(vm, gpa, size, 0);
+}
+
 void vm_guest_mem_fallocate(struct kvm_vm *vm, gpa_t gpa, u64 size,
 			    bool punch_hole);
 

-- 
2.55.0.887.g758fc8c411-goog


