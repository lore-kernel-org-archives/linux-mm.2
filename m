Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BD28C5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24FBD6B00D1; Fri,  7 Aug 2026 17:53:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 226D76B00D3; Fri,  7 Aug 2026 17:53:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07A206B00D4; Fri,  7 Aug 2026 17:53:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C2CB46B00D1
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:53:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4898DA0153
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:00 +0000 (UTC)
X-FDA: 85075824120.08.E4CE1AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5B83FA000A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MZ12nlj4;
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139578;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wyhfVq6+9yuP6TWJZxXH+6QG+xDzMv/ebj4CntnCwIo=;
	b=TrwXthnZiMTWp7jZF2ODji8VUjflnS/R0gATDw5yu7bIYDnjaeMwzffgLRAP+0zPrDROHS
	WaDv8HZJuToDydvaGds1Y3s57oVMjFrRqIc0qnLhtB/Usi+5cTPTi08qt0XUFUAoTyg9po
	MLepVEGU+PRQa9nhYxTu5LUg604fFgM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MZ12nlj4;
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139578;
	b=mxh74GL5L9jcF4H5MItmN0iv8smObYjsadzJN/+gSLcfVfMWoea4RKN6G8JYh/avEiakB9
	0OAk10A0fQhorWvB4GExAuARzYWQlAtJtDPjuFexjRE+3g5ql65J2Hhwt3Zs63hb2Bf+6O
	tDq1BEbpytTOeVtgKFTJ41PsoQm5WPw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A4FE451B0;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DBD72C2BCB8;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139569;
	bh=FoI3ZMvAwFhi7kaXsVeKkdELz832DofYJBPVRl9mtgo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=MZ12nlj4zg6jc33zJXDKBEAaD/2iRklHNAS3yqR77/cY7X3ZJKAcrJ58VSIp7lhGu
	 ACCJy4wxgey6mcl1O1bfQezwlRgXCE9weYeGS1Bxn5M/OSPMvj/Je7PmCQNt7iGrDE
	 S5hmlbXeV/ypmRrGSir13wZ+hn+H/TNo/ffnLg8fsX7v2CJDSOY9uwYskZzfRq/e4e
	 JNyfbgPDjLv2fI83BbyS0+oKR6WkdWJ9A3yES7p7vG3wELaD/VDZMou/U8gsYdtxHC
	 BK40gZGMnLuCMYH2q9rrdO0a6QC7TIsM+y2Qf6UxXhX98fpJ433AmOOKhmgaZBjtop
	 qqA644ZGh4obA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7290C5ACD4;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:53:00 -0700
Subject: [PATCH v10 21/41] KVM: guest_memfd: Enable INIT_SHARED on
 guest_memfd for x86 Coco VMs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-21-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
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
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=1641;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=5c5dIhQl3iWs3iceAiL8YJI/msPrnkAFg0lQ3bgVOW4=;
 b=UFZH2wM8ekLm4JtT1xYICDEeZuWmO10XkYOEwLNUAayGVaTkOQFrtplSWoHHOIzAaNHX6v238
 KUC3rk4iwceAAxaAu6Ixrfp57qOfaUHTUgYifWYSAeKfD3DcUx7Bej/
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5B83FA000A
X-Stat-Signature: 9og11qh3o8jk4b9gyg7yrwztc4rt67gf
X-HE-Tag: 1786139578-746236
X-HE-Meta: U2FsdGVkX1/16NfL5Yz7SdR9yWGaW27xn9w2+8fREjQa0QDX1Fd49as5MHesTWY533TGUzc1sToBIxdsg3RtXSGlOhY+fj+wuVMAYCDyFXrrT7UimIJrszILaVtZY9pZKaqBvn2Ge7+NY6hMun7XQEKwZorhfc+SZFqtmAql2isfdzbLSPIRw4KxzksTNNGmEN4b9MFW7Y5taEYPySuzE5rmKc0TfOBWKVB0i6QnU7qU4fevMkaIldZorEX8urVsldU5c+0FMa56xU6PzANFVs5JXFVlOXKSSbAwGPIRIW5ZNGWkNnvwZllZAdQ1cuJXmLxSuoJwbL6/7x1XDHhHAjp58yjkw+ffgoiAOXC6DWOXm3zdNCW6RWV8PCFggszIianOY35h+R+2HtqZvu8FJWqH4UuszSCDao/v+s2eVd/v5dvg+7qIL9z1GPkf7ddmoYx9oYN/gVaWf0/XWsUKVgwtVieIK5GwvVS5I+yD8IzvcnhsnXbkR4UmPPlZvpOY0/syEpZBTI912d5mVpbcDhoRAe/mTEQ/b5GIkcyilgOWU6sC5kNgYk63QfpQAWI6oj7NSV0PXC4pi7i+V5ABdtmdsFk0SS/tEq9UCbDS+h4QKhb9NuWMQVl0l5eEkHf6HqQDrdEBHdnZVS1mXcTe9L/DsfZRBQnYMFdv5B6JV7IuNmpVVORsvgpcL3SsvH/8weWLbUG6EiSJ/XDf2E6lPech064xZ367fTFoSSQMtDXUQ7GOaemsjFaCX2yzHzdX2sBTAQ2eC6qWIZ5cOPaibGDKVVA3mfJ48/QrGZh4hSO8LGMyToZ6UxSq0rjU00mcPS/bgZP+SJdMap/7tG8cVPYeiQxISWGkLLqv3IXpCCnv57ZT7N8aHjA3Qu/SCWkv2jWkByNX+yz3ysX1i17hJkawnqGEiEE/MDPywHAx2sUlilyyn7PNR8UBEOdGD2w984vX9gN21FEE7Yplr8V
 e0dYZxsM
 DJ+cADW3cNJiFpHOKzwSobeYJeaU5aIysva+xoejj6tGUbByFiJ+7sp79CyuVXhzhOr5OH9exJxLq6fgdBbKeZJr24Kuha0cmnrY4vsSVNAeqZrGnW3DOvMShmmaQNKThmDoq6jdsxhlzD8ktDWc8OImhQxkNpeGJeBDn+T/DKk8ICTnPgOX1GJ62Hr+VRPpvqF+6KnISO6NyPl8EaHeMukN0Ep+di3mKDeTd9VW7BP6D/w3AushgQSGax8vWvRJZlqOhWZsZL1oppoiK19Jw3/EM4MMrF/PtxnFl2uvcJz1tBRjmORny6phARXg1Bc2H2ZHsQ9qsbNxCmb54X3O6JxUuvInDrddkS9pumvxZsxGY3s3haA2rAE8nugFda5UAHORt5H3fZowB29QG89AU/a2LFuD9oAqupw+iE69OWUB74Sy05S0HMJt9GO+anbl9paWKYuIe8cGuc8wOyh4AaJhy6yhujIt1dCxh5cfaeyRTZdePULqPlH9aQzKWSiGKMIZ5MJYMLOjUZaD1TtO7Hdw1pwzmSuPbBHVpe/tSen0nEkPXOL9PQ+X57n8avr2kug9IeSd7FBLo+2Ueq51bKJPbbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Now that guest_memfd supports tracking private vs. shared within gmem
itself, allow userspace to specify INIT_SHARED on a guest_memfd instance
for x86 Confidential Computing (CoCo) VMs, so long as in-place conversion
is enabled, i.e. when it's actually possible for a guest_memfd instance to
contain shared memory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/x86.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 39968610868fd..1ac60628b4c07 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10631,14 +10631,15 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
-/*
- * KVM doesn't yet support initializing guest_memfd memory as shared for VMs
- * with private memory (the private vs. shared tracking needs to be moved into
- * guest_memfd).
- */
 bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 {
-	return !kvm_arch_has_private_mem(kvm);
+	/*
+	 * INIT_SHARED is supported if in-place conversion is enabled, or if
+	 * the VM doesn't support private memory.  If the VM has private memory
+	 * and in-place conversion is disabled, then guest_memfd can _only_ be
+	 * used for private memory.
+	 */
+	return gmem_in_place_conversion || !kvm_arch_has_private_mem(kvm);
 }
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT

-- 
2.55.0.654.g21b8a5bc05-goog



