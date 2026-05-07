Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68B1BCD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 023346B009B; Thu,  7 May 2026 16:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3CD56B009D; Thu,  7 May 2026 16:22:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2B996B009E; Thu,  7 May 2026 16:22:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D2B6B6B009B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:22:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88EBFC2204
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:55 +0000 (UTC)
X-FDA: 84741747510.11.0C464AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7E2DE2000E
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JUuYLPVK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185373;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Grpfsufdq8zMWx1g/s+BVpgu6oKxupSec+sMl7JCuEo=;
	b=LmfCnlt6mGjBKph+7Af8vbq3jYBZ8sldQXacS96ezsQeZLoqDl+4wSiqwpRS8mrCW1Ha+K
	r0f5GNs8vz5p4HWzo2RIEwpx621lsdKwTghvuzu9xgKFF6XqhdnjYiQmXiSA9d+rptyFtf
	8nSKvhaZCW0LXvHsfNZME2iVC07Z37M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185373; a=rsa-sha256;
	cv=none;
	b=YD7eT+089tdnmf3gfMZZK7zrPT5W9D/DdMjv8nbEZhodM/njqZIB6as99OI5vXTI+GbypR
	/a72Fe7ivCgGkNyOD40P6Imq0grssC9WJuEigft8I8uwl40HHLq02O61N3fIWADykhRvC6
	qtSTaX0EnxyT7f2NePjEBWlxkeGqHbc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JUuYLPVK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 93B99444F4;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F638C2BCB8;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185369;
	bh=KGw+g/GrqUHYRmudvCC0jgWydQGxm8wbnDPIEcWsmI4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JUuYLPVK5FvcKkmx6Rx7d1vSSVbD2yARruGmy7AxSWRdqET/7fzWd4ELMXqFE7Llp
	 MGgCTbEyww2imcP5NMuaXpdCOMAf90Widfzfil6U2SgqNMlp6KSGmXIoDB12X/08gY
	 iOeTzmbBXygvudJ8PWeMiAZ3Wsi9xuNJ6afa7AyBn9TV2lNmthmWOmJ8b1Pabd0Vgn
	 YMcTczGXOmnzkEParo3HcMRtGX0EAtPqOayHCAsi4uz8AOJ3+8EydMjmaV5jbwf4fW
	 VkH/yqgK1rDQl+UyYmDOgzaVCR3ynSWNp8HJKfaYYMp+23xcjs/iIKzgm3r8aL2BvB
	 aLBR8tbvVV7KQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C741CD3447;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:27 -0700
Subject: [PATCH v6 08/43] KVM: guest_memfd: Only prepare folios for private
 pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-8-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
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
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=2198;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=xtpmgcfndSxNcZVTwB04xXaV1WHVzjM0+b2CjPRcVbk=;
 b=fdwSxOUbKsCq2DngSVKKVn3uTyf4sOf2cWXOoJ+wAwTNq1cgHAjtaBGomllK+0A4FLZxFLN6m
 /APdBUfVVzNDCXAXbQ5KTqGzQmbi2QO+HapCi7/nE88imakiCsic+ap
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7E2DE2000E
X-Stat-Signature: h9kk8ppab9io38yc6a757r8xoj9wi8mj
X-Rspam-User: 
X-HE-Tag: 1778185373-60445
X-HE-Meta: U2FsdGVkX1/sVqnmnDAEoPAtbrFY/sbSmbvQ2ML59hYBu4tj5Gfj0n5t0q5DwkPSLfoNVGPWht5u3LHtDbtNNVDwuQ94IKuSu8pxGXBN08Ksnu1IGP5hBO2XRsTlz1fQul1Gqm8qewG7FAclWHOyuk0jVFvNyeWH0wbCJ77sra3rrq1jhV5eZnvCFNSUgSZ1X3fWzBAtrfB69BF35pjH6WAjb804HZ2qLfb0QL2gd6J8QFHoZ7KkwNPPd3WoyhzAMQCNEnllTaE0KZTwdRrOzjebwS4YW5PtQphsq5o5ZR8H+puJSGNuwwhdqpLfDBna79zq2UJpSN/JAKNFNdx6FwXXVk2CtpsiOzCWqV7hbsJRUac1gz3eRYnoLwWFxPC7WlLoSalZDgMtQcDesAPjbKjEkRIsVc2EV22GeK7ppu3HmF0egtM5irb/tSyQFPGVXF6uijrAOAk6fpkoNU7g5NOvzYQJILzMf/wZ+kZeObADGuAX4p4ZVb7WsQ/snZBX6/dLJTyivPgVEJStCd0JbHj43FUIFxFbD4Fd3NvJZVuTQ6UuDABGkWJnfUaGLb3/LLv7Z2KAOJQR4q08fnjH/QirRLRnc+gffU3ys1RqG4+iArBQJj7iW3jAeVtFJe80nl3D1mVA+xXXIXJM18rtGVPMSNVcQCGy5+oVj3xps11v29t9h6NSUuQqcv7MouXoL8nkm+/4F5W4PHAJfe97giObE5GQdhV/FJ+vEEkZraAZUJrcMS26JlW0rhwxfIAN+rlzmTDdgcwmi3i5oYwRE2TcP6eFkZyRbBSBFkq4RXB3BjJ7gJk6MMlXKbRImMKlQ+DtHj3EDzkDZfCwYDIJE7TL9C64wrAx6a5/ipMq1dGrlS9L5vyhwS3c2bJiKZ+itcid5jrMC4uSjxzssszxLY1tnZ+LCtm35zT3QA7l1Pijj8Z+v+mdMDMHvNefM8eNklaRWSRviQbr+MhW71n
 F7UH6LGP
 CNMEEX2cKoARbkMa7DGEcyZbuk7MsljBtWU7ZxLaSqAsNuqYKxNHyEBKtJAHtRwaSQ+7Na2dV482A8QVpmP/5+JfeJiDoQAQVY69P7FMWvpecNkrOa9TlyhdVsi6IY8nTRs167XFmahr/trKIrIbESlt7eAVCyvXKutFYw0jM2L5B2Qy1q2FbM7JkDHARAa4Rzs8/xcfn32wS/60TagCFKHe56q3rxns63giFd9+ANnHnrKXufNSuOY669N3Z2u5iy0wAqHwU48crYYud4Hj9mIbeGX89SYXUYpYoFI8VKKqm2fPArCzH46jz2vJWaj9q6Z13ts0HDUAZOtFEuZb2/fwn+BHjR6aatfAJLWDdPz6iy0+jrYYOvVIuFiUHYF4Bj6ctSWYB/1NkZeET/pka8AY5tCrnc0LRdUAO1T4pcZDAjbSTTdwcN4q/zgFyuqZgMdbL0GwMktlFT18=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

All-shared guest_memfd used to be only supported for non-CoCo VMs where
preparation doesn't apply. INIT_SHARED is about to be supported for
non-CoCo VMs in a later patch in this series.

In addition, KVM_SET_MEMORY_ATTRIBUTES2 is about to be supported in
guest_memfd in a later patch in this series.

This means that the kvm fault handler may now call kvm_gmem_get_pfn() on a
shared folio for a CoCo VM where preparation applies.

Add a check to make sure that preparation is only performed for private
folios.

Preparation will be undone on freeing (see kvm_gmem_free_folio()) and on
conversion to shared.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9d025f518c025..4f7c4824c3a45 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -888,6 +888,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     int *max_order)
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
+	struct inode *inode;
 	struct folio *folio;
 	int r = 0;
 
@@ -895,7 +896,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (!file)
 		return -EFAULT;
 
-	filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
+	inode = file_inode(file);
+	filemap_invalidate_lock_shared(inode->i_mapping);
 
 	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
 	if (IS_ERR(folio)) {
@@ -908,7 +910,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		folio_mark_uptodate(folio);
 	}
 
-	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
+	if (kvm_gmem_is_private_mem(inode, index))
+		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
 
 	folio_unlock(folio);
 
@@ -918,7 +921,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		folio_put(folio);
 
 out:
-	filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
+	filemap_invalidate_unlock_shared(inode->i_mapping);
 	return r;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);

-- 
2.54.0.563.g4f69b47b94-goog



