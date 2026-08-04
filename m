Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6BBBC55838
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2166B00F5; Tue,  4 Aug 2026 10:34:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2B106B00F7; Tue,  4 Aug 2026 10:34:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA60F6B00F8; Tue,  4 Aug 2026 10:34:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90AFC6B00F5
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:34:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C998A0838
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:05:49 +0000 (UTC)
X-FDA: 85063458018.30.86A7CB5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id F1A8540008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:05:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cxTqsXHD;
	spf=pass (imf07.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785845147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tjD464vOIu2Voqk/KOGceV068H0b4O8GMn0RbRgTxRU=;
	b=0pShCD89fu/geN5wKmrH/9xd/umgbeowjh7hmc6/0skA+d35UXcBvYntF9/09FXZlvV09t
	J05aufChtcW57o+xPq2EyQrMueZkIoQV456vXhDc9Z1qgFcINraHldC21JkBtg1CYsmCYd
	8NKTbsGJc+eyx9I/OhDXzyl81N7CUes=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cxTqsXHD;
	spf=pass (imf07.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785845147;
	b=vbUEaBhUC2nscdTtDqN5Zwf+P/M0GGluyEJuxaZCktVf5XWMSXnlU5/UD6FET/s7jvntPL
	DpzTIT3xKM7o/tMfv6yOTv5J5C4voEDQnViY43vjFZ8+9iVoWe6wU17b6vR5cMvj/Uo0tr
	pNcPukAoum21ajABkw7dySNc2e2CleM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785845146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tjD464vOIu2Voqk/KOGceV068H0b4O8GMn0RbRgTxRU=;
	b=cxTqsXHDlToD5LRWMCSUNB85DJXYfEmWUmCb8W85muQTWqMvFLIhJwpygpXXpqUPYhi+96
	H4dCxPtrTH4BuZF+G/USm//9Ob2BmNFWz1Rp/QW2pYZKBgWP1WGNmeb0MuQ+tk9lxHQdp0
	hvIFv1QlEqnpTcwKG7mKdFoDSiKPPHk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-64N1BX6oOyyPW9mKVoMGpQ-1; Tue, 04 Aug 2026 08:05:43 -0400
X-MC-Unique: 64N1BX6oOyyPW9mKVoMGpQ-1
X-Mimecast-MFC-AGG-ID: 64N1BX6oOyyPW9mKVoMGpQ_1785845142
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-495529a93f9so33867235e9.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 05:05:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785845142; x=1786449942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tjD464vOIu2Voqk/KOGceV068H0b4O8GMn0RbRgTxRU=;
        b=qLYOgvbNd0fagNvnCi6Y3O2wUXWZPsurXvINmV9lZXtPbOyI26SGlndTmJFyOzFRu4
         D6eTFypArFaUT/TJ2ra2Ack3pvJk41gp98FMurPOtjUGaC9BxerGmiKDoUO+cMrTn0yz
         +BPIIwN3KRSH6p8a0j/R5mAZfJgL6ItvOwR+9PSKzSjc9sQfDfu4DdTzZYVaADBZ5Ffg
         pjkRkTUBi8m2Yl5THX0YJ0Jk8rqMI7Yi0jnRnYKiNYpW6aIYoGifGbz26BqnsObwYMqa
         ueehjWnfzWFB9JFGzl1Mh5eT48ZerI5wnElOnVIhIE+L9E36ZRnZeCrK8n2K9ru87+IN
         KcJQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrxzjg0oN9/AdUzvXLW0f8ioef+DR06wXTqiKZtRdAkt0uIESUp288BocAA9c2IZin6+50U8dNJ2A==@kvack.org
X-Gm-Message-State: AOJu0Yw3C6/3amrzHAcVBavrfjuDIobObZwDJX32OJy+p6e/uZEzETa6
	enJaDRsgWHMI9BeWmLl9VGD1U4L/U8aqqnC+PSjlR4WbcB2wPwUDulmkblx3gIfX3EacOA9XMme
	tmkyp/kbJ7nwACuF4sJyy7IpIwii54bcAsT6mDDLiS89PZxOel3fUANXQqh8N
X-Gm-Gg: AR+sD13x0q2xHhI1VnVnE8DpOvOlkbGdEbnZQ+1EUbQQc2FyGqaT/q5mdwyrn06QJC5
	mDLVC6GCdsmsNg6G4s0qgUDjXI7BI5Qm5AuolaIG30vt205Ejo5nZ411TnERLlmr7+qfHi1gU5R
	en19DTPhCBqApOtJqOYKPSlGNqHPxPS7VNe78NqoR1VISYQsMwRnU/1ANYChBtU1w3Sp7kBc4Wg
	awwuHM013dxbDZyW2UHsTI1uTcWNZwLeNikOPErLipbgV/dUOht1xfs2MQ5ohlRIyHr2QWCm7Kh
	1Pa0asziJQtDXO/HyCBIBlpbxVc06b93uhB9+K0TmWAefeIg2EnOYL87XWOmffrP3XXptuin50N
	jLj9UKunmmLLX3uQEX2VHVcBAXoQLCL1kwJ8uHljgu1O9E1hzCnVopD0RAv6+FX22OB+blVCHmE
	uJLwM=
X-Received: by 2002:a05:600c:c8c:b0:495:4589:707 with SMTP id 5b1f17b1804b1-4980c6452f7mr312396145e9.5.1785845142101;
        Tue, 04 Aug 2026 05:05:42 -0700 (PDT)
X-Received: by 2002:a05:600c:c8c:b0:495:4589:707 with SMTP id 5b1f17b1804b1-4980c6452f7mr312394755e9.5.1785845141410;
        Tue, 04 Aug 2026 05:05:41 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.34.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49949fc2ff6sm79768615e9.1.2026.08.04.05.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 05:05:39 -0700 (PDT)
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
Subject: [PATCH v2 3/6] drm/ttm, drm/vmwgfx: directly create writable PTEs when mkwrite is in use
Date: Tue,  4 Aug 2026 14:05:25 +0200
Message-ID: <20260804120529.1730187-4-pbonzini@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804120529.1730187-1-pbonzini@redhat.com>
References: <20260804120529.1730187-1-pbonzini@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _RJU3TIsKyOHxSjmV4zjY8ByPA85xKbyT62jZrTjN0g_1785845142
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F1A8540008
X-Stat-Signature: 946d9it1b7mf3t1gzijuc3xfgpddp6cd
X-HE-Tag: 1785845146-728343
X-HE-Meta: U2FsdGVkX1/8xSzt+5I3us/X6zC4sHObvDMKqLfseUkNVKvzCZhCVYbQIre6oo7ztE80HRX+cnmuy8bSWLWrDd+Ee5N31ujo7E/Ty3/dAZc9DF3aqd6QsJeovcA74hZws7AyoyF8IVdTR5qsIfCNeSqJ652ZktldD8EdXgTDh7ecxCs5KAiVH/Y/3Q5fpKL0/MpdSXpnhte5erSQ07T56fQyy+uDDopbWYVJhQMnY0i7E9EtQeOqHSxHId2WsERpIVSuESlq7of0qvTYNebNp0kJTB1W+fkQit7jriBdodaa90Rhu3+NpmyxZbbtD+wJ2yaKCbc0cR6c5/aZhUMfHQhqNpFeb8yWRqXp4y5IGMB41dnvNN7a4WIaOHIEIueKki3SR8f1W/r7cEepSWsrxlcmgDy1do7vr7zGSOcNzFJGmrqhoUZy3UjtN8++teWKaO3aAalxhLlsdlzN3ORuI0/Y0kPII0fTkirnnCLOb1putbTbU2E3gPEWZhNlLe1SyJ51/M4HHJq33/5vrRnw37UyWaUEwASQpaVCngmcwGkCr0hncC8kf/H/FN+yo59HN34KnOjA58yppzgvqNuFhsMLpRygkVZAFeZ1tzSDorPegS1rut06jHn1xRkV/PqdkXEkQupyDMrmD4dRKfBVFK8zXWIUg6KsSbeSd7tFW0qCTlIcNEiI9ZyyvihQzIo0lVEOgj8FsktxtdG+5wRF0ixoWgtSKl7TWNEJdKkzgO7SfXjuYoPOyaa5JdgBDP7PeB+3RrbBi+Jm0ZC+fyPNpPXzL70LzNK0DpLoxgq+XI6//R6bYIc4Ug14/laULAf/rl2p0dhtkIAvLsGRXKHntyl+RrWArj2oRlIiL01HzTfhHsD4e72uRpGRXBGLz4WA5Z6bYvwBqAL7klDdculXTfM2noqaqeBYOwwXnER+81Qx5YfBhgsNv3Qw3rd62v8iW5tll6w+m3/w1ZQ1ix+
 63KJbS4h
 z4N6nhlVvvb2IH9EcM/f6I2TXMEiZFWl5nmy24BBJJTBfhMoU6vxmSW5mSkLPIQc/rc0ZZpi0sRpvvIKHzzEaZtWT9j6iz0Geaf0zu162gixwQMO04rtKiW7pGWlaJXtpPlD9fE20jCFGsnBypYCeA+fKD/IgzZ6EJ5uZSxrEt9pfNXRZW6bpyruixM+5jZHxLxDOxr5fxRnYOYeutNvMueLzkDXZIpjYkJznvCHV+0htyiNoLtNBLPzrPXOnJrJo0OjJBpXqxQ8lfXxJL2UHVllTMHPUINT0y80LrXH4e96qtt5CzMmY6z8vjH++p5YWosX+SopOlAms86vFtJJN2J/VhLxDf3yaiPZH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This ensures that fixup_user_fault() users see a writable PTE when
they request one.  The flip side is that vmw_bo_vm_fault() now has
to record by hand the write fault, because .pfn_mkwrite() is
not invoked.

Prefaulting works as before because only the first entry comes
out writable, while the following ones still end up executing
the .pfn_mkwrite() callback.

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/gpu/drm/ttm/ttm_bo_vm.c            |  7 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c | 42 ++++++++++++----------
 2 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo_vm.c
index a80510489c45..3ebde936ce60 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -191,6 +191,7 @@ vm_fault_t ttm_bo_vm_fault_reserved(struct vm_fault *vmf,
 	unsigned long pfn;
 	struct ttm_tt *ttm = NULL;
 	struct page *page;
+	bool mkwrite;
 	int err;
 	pgoff_t i;
 	vm_fault_t ret = VM_FAULT_NOPAGE;
@@ -242,6 +243,7 @@ vm_fault_t ttm_bo_vm_fault_reserved(struct vm_fault *vmf,
 	 * Speculatively prefault a number of pages. Only error on
 	 * first page.
 	 */
+	mkwrite = !!(vmf->flags & FAULT_FLAG_WRITE);
 	for (i = 0; i < num_prefault; ++i) {
 		if (bo->resource->bus.is_iomem) {
 			pfn = ttm_bo_io_mem_pfn(bo, page_offset);
@@ -263,9 +265,10 @@ vm_fault_t ttm_bo_vm_fault_reserved(struct vm_fault *vmf,
 		 * at arbitrary times while the data is mmap'ed.
 		 * See vmf_insert_pfn_prot() for a discussion.
 		 */
-		ret = vmf_insert_pfn_prot(vma, address, pfn, prot);
+		ret = vmf_insert_pfn_prot_mkwrite(vma, address, pfn, prot, mkwrite);
 
-		/* Never error on prefaulted PTEs */
+		/* Never error on prefaulted PTEs and never map them writable */
+		mkwrite = false;
 		if (unlikely((ret & VM_FAULT_ERROR))) {
 			if (i == 0)
 				return VM_FAULT_NOPAGE;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c b/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
index 45561bc1c9ef..3099558c0762 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
@@ -398,15 +398,33 @@ void vmw_bo_dirty_clear_res(struct vmw_resource *res)
 		dirty->end = res_start;
 }
 
+static vm_fault_t vmw_bo_dirty_mkwrite(struct vm_fault *vmf, struct ttm_buffer_object *bo)
+{
+	unsigned long page_offset;
+	struct vmw_bo *vbo = to_vmw_bo(&bo->base);
+
+	page_offset = vmf->pgoff - drm_vma_node_start(&bo->base.vma_node);
+	if (unlikely(page_offset >= PFN_UP(bo->resource->size)))
+		return VM_FAULT_SIGBUS;
+
+	if (vbo->dirty && vbo->dirty->method == VMW_BO_DIRTY_MKWRITE &&
+	    !test_bit(page_offset, &vbo->dirty->bitmap[0])) {
+		struct vmw_bo_dirty *dirty = vbo->dirty;
+
+		__set_bit(page_offset, &dirty->bitmap[0]);
+		dirty->start = min(dirty->start, page_offset);
+		dirty->end = max(dirty->end, page_offset + 1);
+	}
+	return 0;
+}
+
 vm_fault_t vmw_bo_vm_mkwrite(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct ttm_buffer_object *bo = (struct ttm_buffer_object *)
 	    vma->vm_private_data;
 	vm_fault_t ret;
-	unsigned long page_offset;
 	unsigned int save_flags;
-	struct vmw_bo *vbo = to_vmw_bo(&bo->base);
 
 	/*
 	 * mkwrite() doesn't handle the VM_FAULT_RETRY return value correctly.
@@ -419,22 +437,7 @@ vm_fault_t vmw_bo_vm_mkwrite(struct vm_fault *vmf)
 	if (ret)
 		return ret;
 
-	page_offset = vmf->pgoff - drm_vma_node_start(&bo->base.vma_node);
-	if (unlikely(page_offset >= PFN_UP(bo->resource->size))) {
-		ret = VM_FAULT_SIGBUS;
-		goto out_unlock;
-	}
-
-	if (vbo->dirty && vbo->dirty->method == VMW_BO_DIRTY_MKWRITE &&
-	    !test_bit(page_offset, &vbo->dirty->bitmap[0])) {
-		struct vmw_bo_dirty *dirty = vbo->dirty;
-
-		__set_bit(page_offset, &dirty->bitmap[0]);
-		dirty->start = min(dirty->start, page_offset);
-		dirty->end = max(dirty->end, page_offset + 1);
-	}
-
-out_unlock:
+	ret = vmw_bo_dirty_mkwrite(vmf, bo);
 	dma_resv_unlock(bo->base.resv);
 	return ret;
 }
@@ -484,6 +487,9 @@ vm_fault_t vmw_bo_vm_fault(struct vm_fault *vmf)
 		prot = vm_get_page_prot(vma->vm_flags);
 
 	ret = ttm_bo_vm_fault_reserved(vmf, prot, num_prefault);
+	if (ret == VM_FAULT_NOPAGE && (vmf->flags & FAULT_FLAG_WRITE))
+		WARN_ON_ONCE(vmw_bo_dirty_mkwrite(vmf, bo));
+
 	if (ret == VM_FAULT_RETRY && !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT))
 		return ret;
 
-- 
2.55.0


