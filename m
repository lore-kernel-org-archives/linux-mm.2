Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88B83CD98FA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1F326B00A5; Thu, 18 Jun 2026 20:31:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCEB66B00A6; Thu, 18 Jun 2026 20:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4DBE6B00A7; Thu, 18 Jun 2026 20:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 881C96B00A6
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 103CC166197
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:55 +0000 (UTC)
X-FDA: 84894784590.25.430B7DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0CE1BC0002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YE+iyQA6;
	spf=pass (imf22.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829113;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yn+GI1/+AiEBGp9qt2QxV2ZAM7i5gr4di+m2NLWekKA=;
	b=1XJaMK/Hs+VUsfWnaJxY1gSeCw4qHz9XUXmYsi8ncaZBAnqWnFrATrPCBEVFqye/bg8hH2
	tf9g6NEpB28s7jwWRDJrtzlvlgGjDW/p61TwbC+deLHyocl7DdncfW5u1rP3RerxDsntiY
	A/rRGhUFSq9dysjvHVPdlMSn9N2hHkI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YE+iyQA6;
	spf=pass (imf22.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829113;
	b=PYO1JIymkP4s1GvsKzN88cEIp7E0hHR2VQaWcmZ89EqdZ4oKG7XTs6XGG08qtpi0C5/RPO
	UtX3suFbRqtJGQObttkCdTvwdT+W5+o7PG8sSkhCl1UgnGoWk6W318xOc2KMU7Q66XBdh/
	NleywJ2WyHmSURxMN17c6HtIu++OtZw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 456F544663;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E543DC2BD01;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829108;
	bh=A9BWuh0zIJhcTYm8FbYh9REZtau55hLwvqXKIUHAvpg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=YE+iyQA6e/GZfqGWv1x+modBZL8bs//7+F06KFgydnIvGRMWTGC1PwHMxaSKinKdy
	 mruNfTOis2H2CtrkL9X7dzgLKnVYVzBmHXGs15CR5qLPvMkJ5w69Z2mxPclS4JoBpo
	 WJdhi+cQDunTXI71rrNkzSsT2WJ6LERQw31FCymSN3V/kzcsN/BruqVUPhjRkyJP7S
	 H910xSvPxmbocyTvnItLEfaAiwrMEUKKMXDFf1mqsyObkJ3LPnObObZZahYBsUiWVC
	 609hqM/qK8IaM5BtwO7lQiRtjxGWdzcS/05f9vp2DPxYVWiDN1y7AUZmOSxWNiHMeY
	 4JJRBw5NapbNQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF06CD98F0;
	Fri, 19 Jun 2026 00:31:47 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:31:49 -0700
Subject: [PATCH v8 12/46] KVM: guest_memfd: Only prepare folios for private
 pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-12-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=2293;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=mLc3enLG08WtEKTF9ggxBdgxX6UxmOzxM2zY9AloEPg=;
 b=oZe/Yv8AmFIG+JqyaagwRcu5MeZw2HObrghbwkqyq3I/Gu/hckIe3WskdZS5xQYXmPWHN5vRC
 FNOBAuaXkL+AWJj4/aQuX0oAXi6c/BQJwVkXeI90j6dbh62iWW57ZYW
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0CE1BC0002
X-Rspam-User: 
X-Stat-Signature: 88fmwwudska9tgaou4ehi8meskw45pes
X-HE-Tag: 1781829112-540857
X-HE-Meta: U2FsdGVkX1/0zuueUmOAD8ezmQ+LnnZ9BRbjMMVr9cWJ8VwGO/Ha1axf7BZqO1y/1KH/wVlGLe7UcBEYiWUVK0zeex0hLv3UdZ3voHl9PjO5Zs08ixgkHrl/DW5ftCM6dnJiocDn3lM+SfNvEHuYNSk4fwFLG+q/5GhpXP8ifJ7ZAj5FKQDFix3vbjn7BhIx60Nss9g1GbzcXYO0DgNKfGDCWkHOUX7kIuSgByEFNMA7NSG2BrSUdnWWzhJEmH79j5+45MEUHvW/XROnHidRQ5fMWvOKo4Iu41IHNR69UvO6bIoqZljEjjofM4fWbvB+dDrNnuPoFDLmVljYGtb5waN4MR1U4S3XejWWTP/d24fVZjs1qKDr0VCI9Oh2MjQRRPngbm1lzChOgDoqHm8o5N2pI7iAB1izreuE+IYbqZQVSPRJUE9WC40MjzflzcbW6f1t9AvQW3c23ZmRqPbFk191I4PCaMOJMFPl77DC4tmjlpt1tzoq+OOV9ZbXnI6BOHjK5fx5Oi12tnZa8/Aul9MO1e6gh/zZjW2UkZrH5cKP2WhxZY87wozxX0dCstYBFo4tWw82yjaa+zWUemVcvv4HcZY4TeIC70pO1d0VbIbkEscsj8IRBCt/6d0s0XMisFJEeiSd+PPUVT41kACQzHrbr6yJWcig+5uwBWsBro8ZKLu2tBU/DOhw632ZmvtFoDrjXBeFJoDyI6E0yxlLpuHKR2Ncya9qlG+VD3r35cCwqF+Hu3IlbbPZb3JdWgMnNNYDy+SC5lXuyneAonf5dk09qDIfrSO7yDihVsmUkfhh1W27y268jzIjFjXEUNf+It4ALJ457KGLIl2L2Ul50LKiyIC8UZCqZokHP4twDici0AAZAKUh1M/JLnnhQN+ma7bYgXJ6R2gDjPAw2vSq0J59RP7m6xEbFxs6BGCkELkTRy7v02dCCgYDKBARUntA8ew7kgJHLAjg/O21gOQ
 M3n9/1Pr
 pCIYe7/aRyNW8wCMHze2fwndWWZK+3RI/q54UpiUYXvTHex6wxBpBY0MO/3ki5UrGIjMTMflfRvQ8rej0mQ4TR+D9AEqg3CdyEOlmQdtpyvzUjyb7Mlwm7xnGF+smb8U8X7rkc+ppZYa9JcBjbDeny0nidlZvpYKICnoc7h9CAgYSSHfZ3TS4MOlbxkxaVL+4Tw0PGnxZ0Yi6mZWBj7nbpQ5of9+UHScMHYX1KYA1cVjmn3/6Y1JkSpdaS10EXL8+Zgo8JH5j4/jVUpWFv/JjhJwf+N24M/xMw8UwvhmZt6LXTM7fBXAMvVQnpbBLrhllyzWIvfDs63IEYTqMaey63hrQXqadSJbiFSAzxuGcNuOZ8VZPagOnr6/boFphLx+b6KUsOFQvtKbpFFigvNXcgFEUmCYaiXjsSGAdPHzJSkwXmFTcN7rAmNgwVlSVC2X8xAiOlAjUwkrpFIAK3fPAKS2kb1NvJOjWFfoTqSGjBBwYgsv37r/b35AkNhu4sZIyviBEt1I7iX1M4YpKCmwwuN435Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

All-shared guest_memfd used to be only supported for non-CoCo VMs where
preparation doesn't apply. INIT_SHARED is about to be supported for CoCo
VMs in a later patch in this series.

In addition, KVM_SET_MEMORY_ATTRIBUTES2 is about to be supported in
guest_memfd in a later patch in this series.

This means that the kvm fault handler may now call kvm_gmem_get_pfn() on a
shared folio for a CoCo VM where preparation applies.

Add a check to make sure that preparation is only performed for private
folios.

Preparation will be undone on freeing (see kvm_gmem_free_folio()) and on
conversion to shared.

Suggested-by: Michael Roth <michael.roth@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index e0e544ef47d69..65ce795c090d9 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -890,6 +890,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     int *max_order)
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
+	struct inode *inode;
 	struct folio *folio;
 	int r = 0;
 
@@ -897,7 +898,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (!file)
 		return -EFAULT;
 
-	filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
+	inode = file_inode(file);
+	filemap_invalidate_lock_shared(inode->i_mapping);
 
 	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
 	if (IS_ERR(folio)) {
@@ -910,7 +912,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		folio_mark_uptodate(folio);
 	}
 
-	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
+	if (kvm_gmem_is_private_mem(inode, index))
+		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
 
 	folio_unlock(folio);
 
@@ -920,7 +923,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		folio_put(folio);
 
 out:
-	filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
+	filemap_invalidate_unlock_shared(inode->i_mapping);
 	return r;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



