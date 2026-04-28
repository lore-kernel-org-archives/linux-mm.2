Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 203B1FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870526B008A; Tue, 28 Apr 2026 19:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 848436B008C; Tue, 28 Apr 2026 19:27:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 737246B0092; Tue, 28 Apr 2026 19:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 64DCA6B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:27:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7958EA103F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:26 +0000 (UTC)
X-FDA: 84709548252.13.20B9168
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7675340003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g9sRFF7e;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418724;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kp9IfZzLhXRPrHQo64oM/l1Sk0f9MiZHatiogmmdti8=;
	b=kxZto/GCKiK4kRr4DMMFMm3VQzQukA9T5nkThMMsEBKg3cgTR2vOvD+N1lCh1K2InhEpqn
	pKCsn4dMYoUQNvzH/UeLv0YDwyGwbLZSUhfknhCphCZSOVVyY1MCE6UOmX5wyjA60Y7Onw
	/KGX1onIPw6uQFf9Lg5Rn4mGomrYt+Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g9sRFF7e;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418724; a=rsa-sha256;
	cv=none;
	b=f+Qcno2YIjcKsK8tWTD+0pURv8ejecwthaRxea2YHrYHR2LPD4rPqYWAmbmReHIAmfwYfo
	Z2N07wtaPm5+h1fEnzHhYhpu/W/7Nb705FQKcQnWOHmt91uefFvSTKE7L+HOR2HFlTyg1t
	8aGBFVpo5Stb1uLPxAAapCWeG6ugzx4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 89C8F4498D;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A4F9C2BCFF;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418718;
	bh=hBmKFJnOCs0S5g+APYD+DID3z1acALZDNcnsp4e/ipc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=g9sRFF7el4fEV5s0maeinfAKTleEfhhp6J904O234x5NF5cP7/mqyGqI1TL3At/cF
	 vc5C0L/C1SObDX9GIcocqJ4y2b9TDFB2yNaVHb2Li98zHzuFPsZOzPLgv2loINQBrG
	 0fSPZbjBQuQtdG3v6RvTjv4lswKBlby+7Lee9R2FmEotsWpMy9bTpmg34g3JLjEbnP
	 Btu10P464zJ77Y8OpywMRHg+q5yVHUd+X5wRgfeIcmwExg4K7+gjjni2+OTWrc0xmH
	 mTivun07fYtU4dpcmuhiOuQJWqvKXM4+rix+MYgK18rEdjSUrpBoUd4VCQm3N77IEY
	 bCjmjOsrMCaqQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2391FFF887E;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:08 -0700
Subject: [PATCH RFC v5 13/53] KVM: guest_memfd: Return early if range
 already has requested attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-13-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=2437;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=2jwl4vZPlGQvOmnwH/oYNhanxNv5t/UdBGux+AjU5aQ=;
 b=1XrRoXlZ6YyE/8zRKL/CERwfqop5gZw5Z1bMhGmpG5iD5nCUiQ9BfUkM3SKtE7wFQPAeWBH9t
 qnBc56ZHLjWD+SmyF3p6GdHGVRlIhFa7pRDpwx9wFvKpRHafBXps6VW
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: k5eh184whaadz5aybwbmoc13hzjnqxdf
X-Rspamd-Queue-Id: 7675340003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777418724-400687
X-HE-Meta: U2FsdGVkX18I3kfGjRePGjbWe4X7b3OcwWANv8FNwV3bwhXC55S21nhcb5PBQ5QLTq+2l3bD5J3e4Bz6BlC4e5sZxc3G5wsStS+Y8mz3hoR0vMwhCv/DZ/lg5A/n0DwPPuAc5KYTX0t1g8zdRTQ5a4I+1p+E8oRgk5zE2wRVp3W9KSFYQr5SFV+WKfnEILP8F3wMMdU2cQ0AJjXmnOl3KHEYCPVsWkKZRZLf+LDeC0SaYzwM7QrjxTTzZR7XXqbsSP0E4UwruLozWGKOKygUrkp0Jo/esPVPpNPLHaQM6bHjXyyj8s0Lo59K7f/z9CJRrqJqMUi/hSUz2zE5V6ClwtKTobgfTBJyNLbM5L9UuHawBloGuID34Ou9jU+eRt/cYuJzKWUn7tirqnI0j7R81IbErSstrAurtoHoNEZ0IaXn7ZdTpBSjYH5p5gnQQ91ZK8GcCEVl/Sq7kXS7bFPKq1OeqKPPlt2eXUYOeIg8/aUCZjgvgtHgmxqEFputxikTJwB2TPuwhL46yM8yOsB+jUx/jlKx/Af9EA2+oP3RCYgjjYBbtFhcTKAac0DsF62CLM5BS1D3QkvfnybV9gcJewHUPj2wkm8aKqGmz79aAjVz2zxoaMd5HHBSnmyIwOsp0M0VXM6lLa9MyV6RjumY/lEwk5kSxsmIPiinSu2UuT/LB1It+QHkG30j6hJhW2tAloB7oDP6z4cERrQneGoLmp2vxGKzzgoTP1sxgwwm1qhvC3O3wa38BII7+mqHAiWhBTIMoPrtryu5+m7ouFV4h6PvBgTFh/+bYKyhEWgsCy12u4+1DcLMjG/MV66se+OcI9GVJ/CnHYuif3BvDt2J9S53cus+6Y31BXs62N6d7A8aLhzNCmPEowxRSbZAr23hfMsLf/ojVpFcTXwNG1uFxHQ8X+BmPv/WWfOv7FHuUkz+w1PvTri/88WuHnFiXRrZwI+wCNDFiamysWW1ZD5
 /J2GIZSR
 NrwEtqEsXrq71H6EPQI0xnO9i6+PYQbUIIlEJX0QVcawQgRXtWvfuEf9+MJfb9tNl7Z2oJI2eMNW3KN490KXKVpZ4rA6ovAL+S2gd9gvL46OMcdO2cyIJWnlae9E1ut20w43OiCtJrTi69Q0Gx4/jLRL7UcmufErM8EB2SXrEdSeefVIjGMfmYDty/uFdn9lMj12oq02XXrcoXoAx/DstHmc8n2511xICHIaesQEp8Pp1nV6dl2+8p+k69RADhZlofBaNelocbgaDW6iTpNTrGlHDk9RFW0c+cuz4+82DKq2GESbj7B9vjtGi4+vdlR+1RcaA4yLjQZ5N9bVrjs57ZPc2tX+caE/YgSUhCC1E8DMLXdzej4cpYMc5tx5FMnpHfeurTwy9gdqL4KST5KxW2vLlOs8bYQNqSLTb2fjmNhLncEKBaUFq69KuJ2HInmIfP33NzQpbNmOy+kl8DvCiJ1CQvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Extract a helper out of kvm_gmem_range_is_private() that checks that a
range has given attributes.

Optimize setting memory attributes by returning early if all pages in the
requested range already has the requested attributes.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index d563d80d4accb..d8bdb51c50cf0 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -92,6 +92,23 @@ static bool kvm_gmem_is_shared_mem(struct inode *inode, pgoff_t index)
 	return !kvm_gmem_is_private_mem(inode, index);
 }
 
+static bool kvm_gmem_range_has_attributes(struct maple_tree *mt,
+					  pgoff_t index, size_t nr_pages,
+					  u64 attributes)
+{
+	pgoff_t end = index + nr_pages - 1;
+	void *entry;
+
+	lockdep_assert(mt_lock_is_held(mt));
+
+	mt_for_each(mt, entry, index, end) {
+		if (xa_to_value(entry) != attributes)
+			return false;
+	}
+
+	return true;
+}
+
 static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 				    pgoff_t index, struct folio *folio)
 {
@@ -667,6 +684,11 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 
 	filemap_invalidate_lock(mapping);
 
+	if (kvm_gmem_range_has_attributes(mt, start, nr_pages, attrs)) {
+		r = 0;
+		goto out;
+	}
+
 	mas_init(&mas, mt, start);
 	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
 	if (r) {
@@ -1152,20 +1174,13 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 static bool kvm_gmem_range_is_private(struct gmem_inode *gi, pgoff_t index,
 				      size_t nr_pages, struct kvm *kvm, gfn_t gfn)
 {
-	pgoff_t end = index + nr_pages - 1;
-	void *entry;
-
 	if (vm_memory_attributes)
 		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
 						       KVM_MEMORY_ATTRIBUTE_PRIVATE,
 						       KVM_MEMORY_ATTRIBUTE_PRIVATE);
 
-	mt_for_each(&gi->attributes, entry, index, end) {
-		if (xa_to_value(entry) != KVM_MEMORY_ATTRIBUTE_PRIVATE)
-			return false;
-	}
-
-	return true;
+	return kvm_gmem_range_has_attributes(&gi->attributes, index, nr_pages,
+					     KVM_MEMORY_ATTRIBUTE_PRIVATE);
 }
 
 static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,

-- 
2.54.0.545.g6539524ca2-goog



