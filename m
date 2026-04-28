Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91348FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4A96B00DF; Tue, 28 Apr 2026 19:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7BC96B00E0; Tue, 28 Apr 2026 19:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6B416B00E1; Tue, 28 Apr 2026 19:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B816D6B00DF
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:30:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D0F7160EDD
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:25 +0000 (UTC)
X-FDA: 84709548210.28.6BD3185
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 05CCE40012
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tm14C379;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418723;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8qwNuy6S35LgBrfPhdOiC4hGwXWPCb6AvI1JWoW0HnU=;
	b=g6G1Qxv7BVu8uD6Dzs1gU14Y8bkdFS9cDBhjIFk/55hCe69NTVEvS/BlCANuU4mDbq+zNX
	euuZ0v48ZlEGN7onjzgbKG+mUTp0Lj35Lr0uV6rpY5A4kGkwpk0IvgxxLDfspoxYF44bKN
	uaA3wY/WKmyrK380twWNKrzrv7r3AGY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tm14C379;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418723; a=rsa-sha256;
	cv=none;
	b=nuvO9cp0I1ot8GCJl/BvKwmW/IAeFzOtDz81wq8FBagduE/IpovqCve/qOcTAmc553P0Gb
	HN31Qp5XikYBVVK3QjlEiHIm/HcDNL1JQzTirRlMWVNL97cSPCPN8+iS6a8U9Dr8WukvVH
	MlaEWS8wGe2RArmPVTD7w7GypRs1WqQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3AF9D4483C;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF258C2BCAF;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418718;
	bh=UV5hwBR4fiJa9vpZQfRgMxlJB3QfygGG9gpvTP6MjZg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tm14C379IvSTGBuGCigOMQhY9c9uekJTYh+vTloqyFtIDzpXDcYxgoxiIE/My6RoW
	 h5+tuVAtNzUQfyY2k5z3T2JaYci0pFa9NeJngW9Q1Z36H4bxwjqYqxDHS2cO0WzUq9
	 Oax0pMCsnh5Q2UOdxdEZQrlSHT7gt+JGH+8MmaLnmftKX1Piw6pQ/LpGtw4TNUALJr
	 WSZEWCLVdjihvdDZfbdZCCcyw+KQ36RId4A/NkS+n8kgXp7rLuDOti6XwdFzlhZFqo
	 KkIy++617jxo4IwI/VZnUr7WM12CQcPnhm9jN09LpYepmqH89FjflnS/eekxotbdN0
	 EOZTN9lp/Qn6g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A679EFF887B;
	Tue, 28 Apr 2026 23:25:17 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:03 -0700
Subject: [PATCH RFC v5 08/53] KVM: guest_memfd: Only prepare folios for
 private pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-8-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=2198;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=OqIYnMBXTw/n3yXOP4qWHqQMtRm1sk4cJiE4i/xCg1U=;
 b=yGRr7gPhlI8FntjxRhJIC0FMe/yThO5oZateyTY3fWyRElaN/3eb1/73b2FjJr5Y5u70mlw1J
 ihXyN6WyW8pD8Lsguxbj3FixDVQIszkBT6nZQ+E0TRmn+mxLz4dXdoN
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 05CCE40012
X-Stat-Signature: si1mxjh5rfsfonbszkunyctwcjfyscip
X-HE-Tag: 1777418722-457042
X-HE-Meta: U2FsdGVkX1+grvUFrYoJXFetD9n+I6gER1GvrBqM1WLDnU6x7yEMymcs13wYe6G8cERfefxwNXbJyY4oo/5Eoy/E18sEHLwsf4aW4JXXx297gK1GeDMqj9ZN/Vs3eyOT8W5ehfa2dQ2WHHJ6etMLjWLbVP3RcxHP4ypDwRgNT8rMbBcVAOO0sxyMceKCxXOPa74UasERGIFiKrKWKUnbHNSSBvnClifwu86yNbxAaBwIxjHkXsztCtTwBgiD0+c4q2NdOL84glC2gc6moq3RF9d5XqgLn+TsgacBDZZW7gbchoDA4DvFRh3uy0EGXeWU4u6J0m8SQVqjmN74zvymM/eD2lH3TnWe3/6ErEhmUUby+8vIW+BxC/gLrNWtdWsOEDLmgwM9KUu2xCQ0ceA9V3da61xIS6bRrLXhnUgGANaskLAUlkvsTPIt0H/zh9kbsI2M4Dysmyv1eBQSMRTmGrJfc/MgJ3j3/myO17wBma7r4LxDPxK44fnSAlLEzSTmptFmeG56mShDo8AvIBt5017wcdKIoLf/3m07pL5TSwzEQAG/f/LM6WRaHouEwI0ixjy9Z1cN4y9EbEIHsS3RT5dcyNdWTTrpuqGlHLi6GLmIiiPjldeote+S7X8jsQLyuZEyaRCkptSyDgBGAs/VkFfUmITxLqWB+k7SEdFl2McLvwbiVsEryzVHuj6CIuYtCPznWK+J4dxDQP7JtEyUbGYaVsIYB2QhjaHBevPhlZIW0fz2KWy3uLRGUNSKQplZKVWS0u23t0HEqHlSOd6BS0x7PQN2ipF/y1gy2m4/ZIZquIQe1Np2qcPTIAvEsZOUGNl4vlAB3Op/VFGkFWYvcV7wkBr/ecuqoPVH2PIXULyzVHjbHw5EslBtNRUA2Ao2tlwRWBsv/VPC4oXmt2ZQw1aNdlYriSqBz+N2cD/g1JdfJ25GxlzaXLy6QWRSZDX37aI+WLMv6YBPOTLUek8
 P00wJBNz
 QU2om95pdFqTQoFfTEyX0zc+LgN8kheeXiJ+iOeZb+CPG6ce4Hu0/Mas/OUhR9UajcLO+U0pI+aOTZqS7rVWhz8n7i9CdJLlFpTqYaI/XKvKWkAinGyRc/yy5GBl3ob8i7TFbtY0bwkNOZXlNR7z6inZYVU6qGrZzIiwN5e9jx78DnUtZFHJn5oQh6jnWABVpOUemqzudPC7/YL5p46Dhzbd9+Gysn7yT/58bTyQtQsc9surhin99v1dj9AL/5FOhAHM+6poEbxHby2KPXumhM9UTSXJ3SRWoh6k31bK7TfjFLzmHrMJyLJgd4P6esn9zvmiXqqbAgy3jjW7qbVYTuqNR51vyTfEkR2/30kWxzR16cWh3bGy8Stmek5WR0L8kVC6yWZDnKYUpmsTsp5z18PHySGE+qNNhhMVsmvFeLi32K++4Spb5KzVbjg7EUzD21a1osvfa2c85gGyJRwx0HNPICg==
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
index 758ac24a0ff40..506219e2359eb 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -900,6 +900,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     int *max_order)
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
+	struct inode *inode;
 	struct folio *folio;
 	int r = 0;
 
@@ -907,7 +908,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (!file)
 		return -EFAULT;
 
-	filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
+	inode = file_inode(file);
+	filemap_invalidate_lock_shared(inode->i_mapping);
 
 	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
 	if (IS_ERR(folio)) {
@@ -920,7 +922,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		folio_mark_uptodate(folio);
 	}
 
-	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
+	if (kvm_gmem_is_private_mem(inode, index))
+		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
 
 	folio_unlock(folio);
 
@@ -930,7 +933,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		folio_put(folio);
 
 out:
-	filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
+	filemap_invalidate_unlock_shared(inode->i_mapping);
 	return r;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);

-- 
2.54.0.545.g6539524ca2-goog



