Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B0C4CD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EFBE6B00A5; Fri, 22 May 2026 20:18:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 628A96B00A9; Fri, 22 May 2026 20:18:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42C596B00A8; Fri, 22 May 2026 20:18:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D0836B00A5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EEA2A4077F
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:09 +0000 (UTC)
X-FDA: 84796772298.17.9F1FE9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 06EB0100008
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="M1nOqQF/";
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495488;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9p0xgF2EEdf85x55bUwR5ncB8osHBBhrceuuO5MAeO0=;
	b=k788s5lyUZVLpoH07rimGl8rP/+Z+25NmQW/LVZXkzuZyKGHeJTpbyVITnv7IDzKkLceUM
	KnheRc2UVVHVYdEpnAAWGDxBHPiwbR2MVCUMT6JXxj+U0xZeKBYjA8jZHwlmFSCYkLRZez
	sVj8euDdHs/WmjMwBZESLSg1Ys0CS9Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="M1nOqQF/";
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495488; a=rsa-sha256;
	cv=none;
	b=6lBFLtxRcEmn5Gram9Tm3dzFfCymghKoSjkW0w7GmyTb1uLHT31YGWzEAVmYHF/AQmA713
	U/MTAS334rgQAHLQGqmPG43EqWy+9NS3bRC5hMATlSTga/0zo2Lhr24o3Shnawtgj0raHi
	rghTHw09GIcEziKbVQ/bvCPopdJwGeg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 37E3144641;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B80F4C4DDEB;
	Sat, 23 May 2026 00:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495483;
	bh=oJM7nJBDdKU4ID2TwtDymLUlfWmy7eHecttaOfqNCrA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=M1nOqQF/HawPGPB8VNNv1MP9/Dscc98DMpYMI4pQ5RLrDPaB/VyVE4S46Kyw4sg8o
	 D4KVXHJ0MvPVI/IzZHbwQ9KFDIwcZbDJ5yFBA0/As6nrcMX9jC3IllAIieOztPU2wO
	 YpP5Ng7jodf0u+cZwGb2wRm5URldhlrbAvLlkZ8yHtpSFCSS4uoSyAcoETx6mtV5iw
	 GJcUmsMakj9GB20rFIWjih/mFXv4wdmF8gHvbpOpT3KfnKLLyDPb3vfLw7CQLbDtaq
	 WKwWX7ChO8GuUgp8rJdIYsSTTIEOTw6onfbJQAhCa+pjooG29gt4ZidPoMKKCOnH8h
	 4QjgwyxE2vSQQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7946CD5BBA;
	Sat, 23 May 2026 00:18:03 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:17:49 -0700
Subject: [PATCH v7 07/42] KVM: guest_memfd: Only prepare folios for private
 pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-7-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=2294;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=k0GJtJCOrjGjQI95D+GhdW9n00EktV+r4Umq57n6oz4=;
 b=DgBXtRSO8YUbWrYPOUpFuN/lWiyQHQD9BYKmFnu6yYxzCDVI8yW0Hc1kGO/ML41OKO1E6nWa8
 K02oEVELiOtAEOvR2XnhnXcE4UkyGRsRZRLff37cR0rgAWvLSTVHwA4
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 06EB0100008
X-Stat-Signature: zog37w965gtmttuui9ko95nexpz87j6g
X-HE-Tag: 1779495487-390093
X-HE-Meta: U2FsdGVkX18/LrS/TvqQf1U8pgPfpW+QVjlwr9D5z2Q0mooV+6cQdz5u0a7UAo5zdd3Qy0XnVY0TUC8g2Lul1dCIDNYiVl3sJqR6m8DwrPkdYChwCkomsMVqZ3fp4TXVIm+MtPzQfbQ2YkcFNR3cKJMclFssysEPD6GLGuULAkVWuaW7xl6Mi020U2h92mlqKW6WX+VSoHlTAfh/1UlCY7BNLnMCX+L+idCrphZptBn2Yv7zK6ldnDjbCMyFz/yZN1tRCFyyRe4vmW9prE3GiXN7IBvlNxWhsaXsW7RI+DerptIbvqUWqsMTRV2SWB5KASLx8qqv6pdGD58C4yGOqTeT1XUUccmXuRFrsXMKFREfUlgCnp/RLiC8V9ZZZWsIIwoV/ROTuvPZSyZS1qFphLukBnEGwEHbDK7aj/KnBQk9cbi2amj3iafcvB4XklJJCcW9+Eph3pkE4wuS6YwR75T84zNvA1ID7C84yKiB7eSz8lHR1uzbE7oFEwZbnw9jDbNqulX+Ps+mN1z+deSPkELKma6pv3l14jhdq6KDnFH566OXcFQoOVhWYU5qq4JI1waGpkueJH+6aM/AlWdhHKVsUVhWZDtd9MfRR9u6ApO0x6NGPLoC/67RWHlIjSePURNmHcj0No2GBdkNVRHtnHHY/6xkIPIweiwg0PLRaUIj3aTSsvnFXm3vkQx7gMShLU2dSYCIklaFYn+5AJt98MOkQuEVov1wEWcZVcWs1oNTmyloix4dm3gDTX26rrfc07O7YTG1wOrcLUlFl8SeD0WfCXRzvwLKNuDhc4IrgBGC++K8q7YpLaWlHWwi3xxvaV8MapTfiosN6U1BGKy/i1pXj64IsmBsKvBwqhkPb63h8kbMPb1wFDF0/JhGTjb7vNDOz5cUUiS427gil/YBj0Wbmci/7CxJqM+tC2kvKPBOLD/fCDSt9pJWWfQcaTnMqj8hqNbtM1+pILWRPyJ
 EnJUlRqk
 VypOEZ1CVVI/GNoeE5v/mRY+fmUOFFdz10Nxvdge4Mx6eP4v0jxc+JbCxHEjNKKQD3QgBqgHIS3a5JivuJZKyrYpBSYNJQsWleKXvN/Ej8R6ZZySU+6KADF+D1YcCuVK7cR0VcZAHs49Ueg1MmgEjBC4GdSyQOjJnaX3BnRglvOzDmhQ0HyvEqBv2Gmovw0QTDetbqMmqv2k7qN7LSPOnThsvZPjVTJj1QJS+tC+qrOA5aSFKlm2Hby+aGJnJ9We8flOQIaFQcbs9oruFykVtAr6/fRp2PezH7WBSOmHv3N3k+TfqR9Btzb1VOCtvCvm8qeG6rshxmuON0WQ16u6/ERK2jpgBe/1uuRVrhcnTZbVNj6pSeSHy3em6OzUcTtAqEx6E0nRfH3E8m2zHzqTnOp0IA7cNkZB8HQiU4k2OiGQNzHbXAVbuab04Ax8IKCwP2ApUK8pFuge5usXyOEFeDdyvGcupTclvuuslyH/WKMdFUjQ=
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

Signed-off-by: Michael Roth <michael.roth@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 78e5435967341..adf57a3a1f5dd 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -894,6 +894,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     int *max_order)
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
+	struct inode *inode;
 	struct folio *folio;
 	int r = 0;
 
@@ -901,7 +902,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (!file)
 		return -EFAULT;
 
-	filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
+	inode = file_inode(file);
+	filemap_invalidate_lock_shared(inode->i_mapping);
 
 	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
 	if (IS_ERR(folio)) {
@@ -914,7 +916,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		folio_mark_uptodate(folio);
 	}
 
-	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
+	if (kvm_gmem_is_private_mem(inode, index))
+		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
 
 	folio_unlock(folio);
 
@@ -924,7 +927,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		folio_put(folio);
 
 out:
-	filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
+	filemap_invalidate_unlock_shared(inode->i_mapping);
 	return r;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);

-- 
2.54.0.794.g4f17f83d09-goog



