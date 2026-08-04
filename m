Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D62B5C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 713CE6B00FB; Tue,  4 Aug 2026 10:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69A8C6B00FC; Tue,  4 Aug 2026 10:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8AF6B00FD; Tue,  4 Aug 2026 10:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 134926B00FB
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:34:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2C44C0133
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:05:51 +0000 (UTC)
X-FDA: 85063458102.26.EF5C417
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3F6BEA0012
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:05:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FhGBwKRc;
	spf=pass (imf15.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785845149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7VbhR/EeseCGUhv0h0yNN2Py/m+SxPzo7FfzMk4g7pY=;
	b=KHKqK2uAhVAh65UFaWMZFMGXaKWF9KfkvOoMQc/GMZxAi1/hehbHxzNauOu/u8lLFCuHav
	uA6J2RHHmnaDRj/sd81pF8agLK1hx92A+uaIzMBHQ1LOYuMlqHcPMuBVc3RtTQUMMcFCC4
	nES751nr24TpTY46uHTnPDkeowpUt2g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FhGBwKRc;
	spf=pass (imf15.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785845149;
	b=8PBwH8DWATyWu4/MlomfoeoF2LKNEgQgMWNUx91WZ2w7HPPDj++9Ur0J8ezy/cFN7fxiyX
	0yVmyYIHlxYkoKcfdpH6csGTvdRHY6rX2NOIDz9AIuXaR/ewnz/9aR3RQdwtvP1uQ7Cisa
	uREDbDrv+NiIBpcMGeSdONjBkMcWC9o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785845148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7VbhR/EeseCGUhv0h0yNN2Py/m+SxPzo7FfzMk4g7pY=;
	b=FhGBwKRc2hjV63slm53PYKXuAU+KNXe3nsUwIOZNM0ENN7y5EZIYkTfEE6l40McXnCI+cD
	A+dsLZyCh2ei9lXpUa13Y/jzKrV6q5MUDTrgXB177jnHKznUNJHdfGTVCYgPuWqN/Uck65
	qZk3zZDkNG8571+nBkIiGWfykBno2I4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-NH6TWh4XMF-aBnM2J68VAw-1; Tue, 04 Aug 2026 08:05:47 -0400
X-MC-Unique: NH6TWh4XMF-aBnM2J68VAw-1
X-Mimecast-MFC-AGG-ID: NH6TWh4XMF-aBnM2J68VAw_1785845146
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47f4601af62so2019145f8f.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 05:05:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785845146; x=1786449946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7VbhR/EeseCGUhv0h0yNN2Py/m+SxPzo7FfzMk4g7pY=;
        b=sRl0OEKn3op5w/HTeuQ5UjDpn5WWRs9xkF/X2M89yvCHEiF59K33aaSJ6jvmREV+yi
         ZzeSwkFtu3UAsdCYIHRQwNwQJAwm6iDqLUlntP5UJgdR0gW7QwS4j70QCQsAuO8toT0n
         gPkPD2EjvS27+SLJL6vZgT6WlXqomVGLMf87K49VaEF0zd+QnUaObPL/H+ZRayR3QNhF
         liYfjFzFaSIzbLitPNFYmU/HrOrQB0iumyKUJ3xmsgzB3fZMpy9pTeWVfcPzjxeJN+/M
         BBPtjPYOlD3GynCiVqd6AgRwF21p4m6cm8COpLXiuf1dRy1LctYa9/zbYm6brBLoVuH3
         MpQg==
X-Forwarded-Encrypted: i=1; AHgh+RoneX6aXyd7xQz7BfrpUJoshZFIOB2eFPIu2J2zVReoI1kep6Y2B5tyFV2+/1xpqok1rnWZYdZqOQ==@kvack.org
X-Gm-Message-State: AOJu0Yz7g4Z7+8uQdBplDBojd8gbrvjCEWE5jH8egxb15Xk68IEjbfeX
	s2JpTFWLAtO74bMLas0WOsRCMH6O/+sd1Km3vSTitO8xY+qRWfHkkEyzVsuzqOCegLaxZPSKuT1
	YUxRe2ew57coq88CIjLm66t6Y//+nwsnhvmUDKjLsXg8AV21FpIqy
X-Gm-Gg: AR+sD13XyMEUDvGXQTk9z0vzRAVL5PWd03v4VfMpcv53cHz7P22QufkCnTpjs6zO3Kw
	Q2pj37zHWY/C+0DUFG+GI6Ikii6K81vWR4tbBivG4FQcN4MVY7I9icd+WWHoCsPO4OvY4Ht7YbK
	UmODaM0Q1mhXXv4nGh1BnM7wmHf1I8jfLimBDHPX/sNr1xqIjwcjMshMElMQga2V6PbFG5+X+4+
	stMtlebJONuWt1JPk6Rn2aOsTrzSNIFEhLhcUNXAiCFJRjRv9Fwk4mP3KXfw0v1q8GZ4sk70q2M
	bVLauBcMoMN4BtuC4dirdbdSe8Tj5arKLs0WtZMboJfyJg7Oc1iORSiT/srWA8kmpkFzmnKJ0NJ
	KK2GhSb3VVi1H3uUkjL/HmWIYeVPclND0uCLb8JSf1OQ9V+mO8Pa4g2rMCnzpgChfP5fbeDB9Ah
	qT1Ok=
X-Received: by 2002:a05:6000:2989:20b0:47f:7154:9dfc with SMTP id ffacd0b85a97d-47fd72a8e68mr29813790f8f.9.1785845146063;
        Tue, 04 Aug 2026 05:05:46 -0700 (PDT)
X-Received: by 2002:a05:6000:2989:20b0:47f:7154:9dfc with SMTP id ffacd0b85a97d-47fd72a8e68mr29813677f8f.9.1785845145601;
        Tue, 04 Aug 2026 05:05:45 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.34.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd4562667sm45367660f8f.24.2026.08.04.05.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 05:05:43 -0700 (PDT)
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
Subject: [PATCH v2 4/6] kvm: apply VM_READ/VM_WRITE checks to all VMA types
Date: Tue,  4 Aug 2026 14:05:26 +0200
Message-ID: <20260804120529.1730187-5-pbonzini@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804120529.1730187-1-pbonzini@redhat.com>
References: <20260804120529.1730187-1-pbonzini@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1DcF-u1nHqkyRK-eNHV8rv4gtAUCN42N9ZtuPjxzvfw_1785845146
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 3F6BEA0012
X-Stat-Signature: t6t8aksmwg745bypde6i3nu5qypc9fy8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1785845149-870778
X-HE-Meta: U2FsdGVkX18nOc8OEH/5QJJ0zltr0VXSrGZBos/cHPQjiws8gBHn+Yjhpm/KxvImizySG9aLudjQjCAgsn0NyjNRlZaFyryULi8yYNWCjPyscjJqqexkf3xbhySW4lDmTSnsQVwgg9yT/i8boNHWB9ikfZrrqkc+mv/oFxfFPpDA4zb+/MqWrVrj2Awmci5yXFMaOkMeAazz9aBvCzHQzhmpJJ3pFaQ0u7bkDndfmefTZqHrBKdmYdsbu6FM6u9V3eIAnJVazjS3wDEwijAsEW28eeT/siFpCMtm8k0tnFCz2E73s1Ew60edK68HrTz8EaDD3+447xXWiM+wz1asXzTJwASSnt4Jnvy4l9sytZ333F4uciPNUX/mVMgEGWhRiPT2MtzTt0lXyCXHlMZuYoZqKPpKkaWu2yu1pDo4/Iz27VVo//mSTu1kxucD8PIzapHVrQffye3aoAT2HL8D9ENIkGC2YS6Rdt7EuEch0FVEv1uEZnTGWgIcIPEihXL7Mqe68UIEmQyxBZz0kFP4L5Gcaotqf+2ni/jFMrNM7VlJ7udzAGKuBe+yDSWs3OK2PniFFnOlQ/HeTeBDtX8JGcjnzRgaICuB9g0hz7u8WT8dUmvunBv9M7tj4AwCvvXYGgXgw2HrNc/iOyXe+/gPuNWZLCgR0+uQgJDmIBVDUYXlqJD9/r7adVLKIoXOZxc567gAMH76XnJHcpcWUrqL6vR82CWFYOPN/KXvbSpg5mpOl5anwSN7JPVMl23QdhUPUS9HzBmQZOKAnkhMu8scEBKcWJRxeUs+yDPrOCTYdt+xaAe40nxBg3MF5CK+hD8PIuwPX6oFs4agXgRIUyMQ6sAUWKB68gq1Qsk/rFZBYWksJgh2NRAM82X/QlHu8ekuHz5DW7tUCqgN2e45P4HOLixUdw9eCBcNS2ur12Lot1FC1ypdrzec+INMgU6xxTycUPu1F5RVQjW83auI4ou
 gseUjjiE
 gjopEAo7H0JKGuh/ZMdNiZtHYUnCEbCVk+xEirsy2VdQJUI7mkIDO8q1CW9QTRIy3yb/gt1lejUaTGIF7SXEoOVcaSZunk6LdErcM/CuOgGNCeASqEzHjZpe658JYe4oNpVie/ZkwNvuSyv6aaUhh4F9sS2XDnymI28YyU1SWBELMlLKCqgVqin3NJoE+p+ceo0fS3oqUXd5fP81Rtd2k66HgTOt23YuYvXTl8mNOzbNFH2oxuwcpdXnCKL0mTZPXQtRR6Sy/NtJ276ca5FYdzEo0kUaHxIawTtZJQf8XRZCGkF9tMc5FvlujuJ/XQnIdxcdfOWch0oAhyZpO5oEvBdsqM93hcu5syUYHLVEqY73lsyrYAlzrWQ9z5XPZd3dB9YDifl+wOYujuu8JeI4FE9oNrxAeceq49TRgcN8wd/7hF0g04ed4WdNk93OtfXODO3TeJbVStx0KKhs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The VM_READ and VM_WRITE flags are checked only at the very end of
hva_to_pfn().  For both the hva_to_pfn_remapped() case and for regular
mappings, this adds unnecessary cases and inconsistent error behavior.

For hva_to_pfn_remapped(), the code is relying on fixup_user_fault() to
detect this situation.  This is fragile because hva_to_pfn_remapped()
returns different error codes for a !VM_WRITE VMA depending on whether
the PTE happens to be mapped:

* if the PTE is present, follow_pfnmap_start() sets args.writable to
  false and KVM_PFN_ERR_RO_FAULT is returned;

* if no PTE is present, fixup_user_fault(FAULT_FLAG_WRITE) returns
  -EFAULT after checking vma_permits_fault(), and hva_to_pfn() ends
  up returning KVM_PFN_ERR_FAULT.

With this patch KVM_PFN_ERR_RO_FAULT is returned uniformly.  Likewise,
a PROT_NONE pfnmap VMA would be mapped into the guest if the PTE was
pte_present()[1] when the guest attempted to read it; with the patch
instead KVM uniformly returns KVM_PFN_ERR_FAULT.  Doing the check early
avoids these special cases and also sidesteps the issue pointed out at
https://sashiko.dev/#/patchset/20260731160514.1101989-1-pbonzini%40redhat.com.

For regular mappings a PROT_READ VMA, if placed in a writable memslot,
would return KVM_PFN_ERR_FAULT instead of KVM_PFN_ERR_RO_FAULT when
the guest writes to it.  This would cause a -EFAULT exit to userspace,
instead of triggering emulation as the VM_IO|VM_PFNMAP arm would do;
however it should be considered part of the KVM API because mmu_stress_test
relies on it.

Still, even with this snag about the returned pfn error code, pull the
vm_flags checks in front so that they are done for all VMAs and the
above inconsistency goes away for the VM_IO|VM_PFNMAP case.

[1] on x86, for example, such a page would have _PAGE_PRESENT clear
  but _PAGE_PROTNONE set

Fixes: 28e3918179aa ("drm/gem-shmem: Track folio accessed/dirty status in mmap")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 45e784462ec6..576bcb21be3a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2925,17 +2925,6 @@ static int hva_to_pfn_slow(struct kvm_follow_pfn *kfp, kvm_pfn_t *pfn)
 	return npages;
 }
 
-static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
-{
-	if (unlikely(!(vma->vm_flags & VM_READ)))
-		return false;
-
-	if (write_fault && (unlikely(!(vma->vm_flags & VM_WRITE))))
-		return false;
-
-	return true;
-}
-
 static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			       struct kvm_follow_pfn *kfp, kvm_pfn_t *p_pfn)
 {
@@ -3008,20 +2997,29 @@ kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *kfp)
 retry:
 	vma = vma_lookup(current->mm, kfp->hva);
 
-	if (vma == NULL)
+	/*
+	 * GUP failed.  It could be an inaccessible mapping, a pfnmap one,
+	 * or the page might be absent.
+	 */
+
+	if (vma == NULL || unlikely(!(vma->vm_flags & VM_READ))) {
 		pfn = KVM_PFN_ERR_FAULT;
-	else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
+	} else if ((kfp->flags & FOLL_WRITE) && unlikely(!(vma->vm_flags & VM_WRITE))) {
+		/*
+		 * Exit to userspace for PROT_READ mappings in a writable
+		 * memslot, as this is part of the API.
+		 */
+		pfn = vma->vm_flags & (VM_IO | VM_PFNMAP) ? KVM_PFN_ERR_RO_FAULT :
+			KVM_PFN_ERR_FAULT;
+	} else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
 		r = hva_to_pfn_remapped(vma, kfp, &pfn);
 		if (r == -EAGAIN)
 			goto retry;
 		if (r < 0)
 			pfn = KVM_PFN_ERR_FAULT;
 	} else {
-		if ((kfp->flags & FOLL_NOWAIT) &&
-		    vma_is_valid(vma, kfp->flags & FOLL_WRITE))
-			pfn = KVM_PFN_ERR_NEEDS_IO;
-		else
-			pfn = KVM_PFN_ERR_FAULT;
+		pfn = kfp->flags & FOLL_NOWAIT ? KVM_PFN_ERR_NEEDS_IO :
+			KVM_PFN_ERR_FAULT;
 	}
 	mmap_read_unlock(current->mm);
 	return pfn;
-- 
2.55.0


