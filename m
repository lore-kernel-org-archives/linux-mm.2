Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C65C9C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:32:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B07EE6B00E0; Tue,  4 Aug 2026 10:32:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADFC56B00E7; Tue,  4 Aug 2026 10:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F5F26B00E9; Tue,  4 Aug 2026 10:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 613F56B00E0
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:32:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89B2212012D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:05:44 +0000 (UTC)
X-FDA: 85063457808.11.7E57586
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 23849180009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:05:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PKygjsxy;
	spf=pass (imf24.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785845142;
	b=rM5P15LQjXFsy8LeV9gV8ZZ2jPL3qMAeQdSC0vID0aJKUj5L0+JepRcpdVsN/fIwT4iQ0w
	DsCv0KCB+BexIxLqGGxMVnlJ+v77DFuUoFy1DiMitklF8ARiBdycFVV89gSSFcVwk5W6X/
	ty45Ne9xtmSqFxaE3tMLVYLPG0/BSzc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PKygjsxy;
	spf=pass (imf24.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785845142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=taQNLA8VzPi8pIAuKLKHCaHnQR8Qtlo0OLpkQO4wnlM=;
	b=tuf2RDmyJ8JILjQNNhUAiKC9mX64EeoyDBqwqmPYjrIGSOWZiKbissJ9HrfjY3ZSf7tXdy
	sBbCoY75ZtWnuiP1HShnDKzwylp/83DmSha4dds9krjvFwmNFHib+91zX21M8erK9p4onl
	3i0daIlCaneS/gEpJrPosgNMdA2T4UQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785845141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=taQNLA8VzPi8pIAuKLKHCaHnQR8Qtlo0OLpkQO4wnlM=;
	b=PKygjsxym/UgwOezMMJO4uguIgX2PhyH+vFXK+H7jEq/yusCrAEDpA18obMZf5TR7EmRi9
	kdsncBZ1P+MjSqMoEebSfke2u070bkgKwrrFfc+oqr1xsRJow0iO3Z5SrK287NyQ6XPhtl
	Jbc2crVt75K/g1FrMvC5qQROcb+Kl/8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-ar1jPsXTPt2SCVkByZtGlA-1; Tue, 04 Aug 2026 08:05:39 -0400
X-MC-Unique: ar1jPsXTPt2SCVkByZtGlA-1
X-Mimecast-MFC-AGG-ID: ar1jPsXTPt2SCVkByZtGlA_1785845138
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4954dcd6131so33952925e9.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 05:05:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785845138; x=1786449938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=taQNLA8VzPi8pIAuKLKHCaHnQR8Qtlo0OLpkQO4wnlM=;
        b=i0ctl6zUSlzZwOTqqdHE+gpRrmbjvYfdnHDAcIBfPKGhW18O77CbVz8Dg6x4ONngbB
         rmWy3MvFRS8OJm06lKy5lvkl865baVBajcU97+/rWGD0dhU8fJQlEtbnoxKFaBQKSoUX
         dkqNb6yA8CyFkyG8Z5QsKyxHE8M9FyQRhta94/ufXr+bGyzHEmEHlwwuk5+xyAoXOdx1
         PE1k/hFn7F4mzjvC5JWTX7AQFFT//VP8/IGyP2Iq0gsKk5Pob295AjVVA1/YPsglYjqe
         EGfwE085QF8s8oOtpI8tgsleqDv3NQpIMZL5V9Vm1ykDFR/ikEFGcde78hzeL5HoVcGI
         t2IA==
X-Forwarded-Encrypted: i=1; AHgh+Ro9bhlM42SrSP6RMmGLNhc2Cq+VpTVNQxIK/FAWf2qFy22rf8vOh7ahT5Hlf4QcI0KUXzDUzwFMiQ==@kvack.org
X-Gm-Message-State: AOJu0YxCEsXziBboaq7PfPW18mgWUGbv0iTA2wGSdBcYuOZmt6wZ06ys
	8zVgNXRvTF9yn2idNsWq1/lD/Km6uMjwnkCn2HQ1ZAfT6FRalx3G7KQb4fO1n1qUfeE+qJ6+t91
	mlWVm+y5qoAjDRq2fqjP8C+iQYaDd3ff83QjVrA9IiO6AuWq76Qa3
X-Gm-Gg: AR+sD12BKycbmerskugqE7g29861FsgdkY5CMgyfXadbQwQdl5PI4hf06VZoTQD0u7U
	osK7xweUDNd2E8JoNv2e2Rlg4lsWXYVq9tjp1uHOgZezov9FQ/8U5RiPD7WAnj6yNKoD52dHhwp
	ELzXY/0ZP+vttbF+WE7XtRBiiOEohTgK2I06iVttNkuINhZmrtKTK7fPIqxoUVhGazP+OuHFCkw
	G8PKpnuYamzF6UV2jLNkLcQTBhBaODIAUOm5O0jELPstWCItwtRv5Q3nBUdllcIQhHn7j9H2p9m
	Jjub++tLke8aJazZ3WV5YAJN6DBxHvniPznlMhVfeiq+S8OHJXat8rZnJIxgKOX1OVE1pqzc2Av
	mSQ6C63TvdoGDPePx31BzkZ+2HI9IgqGg4e6myTaJeg0yL5AXJZWdRJMOpNdBAY/9q5KS/6Swes
	/p6b8=
X-Received: by 2002:a05:600c:6298:b0:499:484a:7644 with SMTP id 5b1f17b1804b1-499484a7693mr122467155e9.9.1785845137696;
        Tue, 04 Aug 2026 05:05:37 -0700 (PDT)
X-Received: by 2002:a05:600c:6298:b0:499:484a:7644 with SMTP id 5b1f17b1804b1-499484a7693mr122465915e9.9.1785845136990;
        Tue, 04 Aug 2026 05:05:36 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.34.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807b8d04fsm453070475e9.3.2026.08.04.05.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 05:05:36 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Alex Williamson <alex@shazbot.org>,
	bcm-kernel-feedback-list@broadcom.com,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Christian Koenig <christian.koenig@amd.com>,
	David Hildenbrand <david@kernel.org>,
	dri-devel@lists.freedesktop.org,
	Fei Li <fei1.li@intel.com>,
	Huang Rui <ray.huang@amd.com>,
	linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>,
	Peter Xu <peterx@redhat.com>,
	Sergio Lopez <slp@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/6] drm/shmem_helper: use vmf_insert_pfn_mkwrite()
Date: Tue,  4 Aug 2026 14:05:24 +0200
Message-ID: <20260804120529.1730187-3-pbonzini@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804120529.1730187-1-pbonzini@redhat.com>
References: <20260804120529.1730187-1-pbonzini@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6_Xt5Fkr9wBtb1xiPT-_YcCkwYJYhTgBN2jHtm-obTY_1785845138
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: qn61c6fy5yrpgjcdea4n88df5zyus6ag
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 23849180009
X-HE-Tag: 1785845141-386459
X-HE-Meta: U2FsdGVkX18QXmFXVoO0sxiGvvtN21OPVQEAP4veVp/5Qay0d7DR9auCJ8FXwPViQpuj4Rwhfs5FQZhZ4r9bOBsmC1CeC4slZeO65MykXlqmtr3Rg9BRYwt/3flccKqNXstGI8dUGGSal91FYtN4NTNvrILTWO13lBhyvhHJVFdmxbh8QxWJgGMoinX/45Bd3Kqn+tPQtOr9pnEp21QcOcOV0s5TU3PUe7knx0LpF6fjKnafV2XkubtJlI++epxUoCIfNwltZrMaFQBxM/4iKb0xYKOgnb2hcX1EujTDko/FpK7VrghhA6rFR1LnHi1csQTQuq17T9WyTo2QeO7SzuaLlvc0lx0kuZS+OR0YKhX8EN19NA3g2aZ1+gVj3e80n5wkH+7fkp9M0nufAuzBO2BU+Jy4x5QwEr8aINDJ/61ULMogCiMUWHgHBQsEMGtFRN1e4SrLYXmTnPTIyo9CZj+rIRzcm9hVjohoOq5wDnJ2NVFy3eeSt8e/MpMRrqZvCjyYR41I58Ow6OneIj3c2LQEIgAih73ATvydruvaHCBzPzivGV8FNAKltMGXX7QULChYqiG1//Q1awGECV00uxTVW3Lq+PgGEfBB+A3FHxRqYeFENOJmgR++joIbNfCHJFZ6tJb6YdrJLdPt1w/wZJaL6XlE52Df0H4gw7LCPl/xIP7gFLrbXJeSQ/VYdCeVy5vY/qR7R5hC1T5hXtSINif/G1yt3g+pXE+EpNonogWCr3YE9PTTdcE3WPrU4YneK2XL4VIpQDGdhQUv27PgxkDobdxHkRRlVyRbvW59Jif9evcKPvPeNgjZmi+yW6B1Fun25I975Ldm8WEeYT2ywg+SF/DKCfqbiF1zZqVyugDYkbpINw5zL6JbCAiOAD0zlW3tEbG/wESVz+pHrTw9vNKu8JL/iLexhEMJCsgAw99/s8mgJEH5EFf1Iyv6HV6S02pp8MWxyD3oLI7q8Ch
 SWohxrIZ
 unBIwECgePuSsj0FjNlUbtQKE9f2QgaWbZ3kexIRi0U2P5axaevcCozBy1fbH6klnIq54GaoDaOTF05fHrMvBEIzMpYcdZG746OkO1WzCaJotpKGsmg+YiBeNLu0zXokwVCv3XmSV4NRH/lAwydjRhbze/RcWR/4tCm/wshi8OdcjCJK4Y//m+foO+CELma6+MB4gBo7C4GXNG8mVPHXN8h9rDwN3dzKYiS1LJWWHiFfu5Tx83zUkyeYuN0ZmpTzc9QOgxdS7jlT1KLO6xVhMoRqrEvJe4ItMEdKJLR5uaOizkcndkmsZ8ezIqUuX4cJmQa0Ho18jjdDCle6bftozcl5muGEY2SZj8P+jzVUfUnkgAI7b6v3m7twlNR3Vv5UwPG26XpiBmIAcGwWCTaLrnioIeJPjSjvHfi0bSGCpo1uJaYisFgvyteDHsCyhNrYKCmp8ZwisBQwlZrk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This ensures that KVM or VFIO correctly see a writable PTE when
they request one.  Otherwise, a guest write to an unpopulated
PTE from a mapping backed by a DRM GEM BO triggers a VM exit
with EFAULT.

The code actually is simpler, because the same logic already
applied to the hugepage mapping case using vmf_insert_pfn_pmd().

Reported-by: Sergio Lopez <slp@redhat.com>
Link: https://lore.kernel.org/kvm/20260729072044.25796-1-slp@redhat.com/
Tested-by: Sergio Lopez <slp@redhat.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Fixes: 28e3918179aa ("drm/gem-shmem: Track folio accessed/dirty status in mmap")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 38 ++++++++++++++------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index c989459eb215..c81be3e97317 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -589,11 +589,25 @@ static void drm_gem_shmem_record_mkwrite(struct vm_fault *vmf)
 	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
 }
 
+/*
+ * Because the vm_ops have a .pfn_mkwrite() callback, vma_set_page_prot()
+ * has cleared the write bit from vma->vm_page_prot.  vmf_insert_pfn()
+ * would install a read-only entry even for a write fault, relying on a
+ * second fault to reach .pfn_mkwrite() and upgrade it, but that second
+ * fault never happens for fixup_user_fault() callers that directly
+ * walk the page tables with follow_pfnmap_start().  To ensure that
+ * they don't see the read-only entry, pass FAULT_FLAG_WRITE info down
+ * to install a writable entry right away.  Because .pfn_mkwrite() is
+ * not invoked, record the write afterwards.
+ */
 static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
 				 unsigned long pfn)
 {
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
+	vm_fault_t ret = VM_FAULT_FALLBACK;
+
 	if (!order) {
-		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
+		ret = vmf_insert_pfn_mkwrite(vmf->vma, vmf->address, pfn, write);
 #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
 	} else if (order == PMD_ORDER) {
 		unsigned long paddr = pfn << PAGE_SHIFT;
@@ -601,27 +615,15 @@ static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
 
 		if (aligned &&
 		    folio_test_pmd_mappable(page_folio(pfn_to_page(pfn)))) {
-			vm_fault_t ret;
-
 			pfn &= PMD_MASK >> PAGE_SHIFT;
-
-			/* Unlike PTEs which are automatically upgraded to
-			 * writeable entries, the PMD upgrades go through
-			 * .huge_fault(). Make sure we pass the "write" info
-			 * along in that case.
-			 * This also means we have to record the write fault
-			 * here, instead of in .pfn_mkwrite().
-			 */
-			ret = vmf_insert_pfn_pmd(vmf, pfn,
-						 vmf->flags & FAULT_FLAG_WRITE);
-			if (ret == VM_FAULT_NOPAGE && (vmf->flags & FAULT_FLAG_WRITE))
-				drm_gem_shmem_record_mkwrite(vmf);
-
-			return ret;
+			ret = vmf_insert_pfn_pmd(vmf, pfn, write);
 		}
 #endif
 	}
-	return VM_FAULT_FALLBACK;
+
+	if (ret == VM_FAULT_NOPAGE && write)
+		drm_gem_shmem_record_mkwrite(vmf);
+	return ret;
 }
 
 static vm_fault_t drm_gem_shmem_any_fault(struct vm_fault *vmf, unsigned int order)
-- 
2.55.0


