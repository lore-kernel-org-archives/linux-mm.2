Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3F39C5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 18:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 099B96B0092; Fri, 31 Jul 2026 14:04:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 077AA6B0099; Fri, 31 Jul 2026 14:04:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA906B00A1; Fri, 31 Jul 2026 14:04:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BFF036B0092
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:04:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8511FC0459
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:45:08 +0000 (UTC)
X-FDA: 85049646696.26.E3D187F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0EC9618000F
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:45:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gvIhcwn1;
	spf=pass (imf06.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785516306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rKIuXVAQxBinLsqe2l2r/I0mxnjKp1xskcVhmjIrGQo=;
	b=ayiXgfGdEC+DAGaacIIPpgjUxI4xtGsJR1ppPoW3NTIg1LJ7g1wunwx7BqngBGZod4PFMi
	VvJGWuFcZhqIvAxeTpMiH7zCHWYDiHTcfVBBjFKghppeXHpPUsQ+P3byFOLr2UONGJfxHV
	wUzC8f1bFIfoUu61QUmAUMkmSY2/R1w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gvIhcwn1;
	spf=pass (imf06.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785516306;
	b=35Vt8yT0WGS1Q/4y9JpY6fembeG+f9Ro8SM59FCF+ygFc8OsGkmPFCQ9eGxCAKb5x40qHT
	OF+mSUcwphGVWWOxwuLkCyBu8Hdt/WhhYP4+ERV+Z/JwxzBeh6pmVK4rrtpXf91+k6nWhI
	Di5I4+XCFdZ2iji/FLkZu5gL/GwuL18=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785516305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rKIuXVAQxBinLsqe2l2r/I0mxnjKp1xskcVhmjIrGQo=;
	b=gvIhcwn1/YKGG+OhuLz47Dg75jpfCSEH15/F7MgdaIyKCF6ouLFHaIp0NUAa2CFSP9lBHS
	CA0+wScKN8L7E1Yy97Dtww/saveRrOvM/I+2VMRywhFmmgDmUhuvP7PT9nXefD4QtJ6UHF
	goL0AdE2AN/ea/2wWd0ZuAEqLuopyLE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-gI4KFA3pOsmIemNhm64TYQ-1; Fri, 31 Jul 2026 12:43:53 -0400
X-MC-Unique: gI4KFA3pOsmIemNhm64TYQ-1
X-Mimecast-MFC-AGG-ID: gI4KFA3pOsmIemNhm64TYQ_1785516233
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-69c2f98aa9fso1450370a12.2
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:43:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785516232; x=1786121032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rKIuXVAQxBinLsqe2l2r/I0mxnjKp1xskcVhmjIrGQo=;
        b=m04t4Kz4NVK4+XjrFUdU3mpQn+XMp8tfjX0HxEv0k5SruuV9VvUSdbxpsKCxPd98GN
         r2xGnm8ZVL19YygUWsdrCEKvFSGlCL6mfcQc/Hm0MipMsFpQbM4Dl2nyeWUrrqKbLfso
         MQ/eNOQLxW8KL2KSQfURegP/GSeyOO61PKpE4hYVGm6BG9BzlO5w47rYlFTv/sMIULTi
         W41z42/7Pl9baeb+VIYfelZnSKsijdTdtQLqILz0yfHXwpD+HR9C6thg3Cc3SeeYp8/S
         YbpTrQcOmm/LHYF2RGHqP+TuxtZae+diXbJyjN4nZ/e42CjGHJ+O9V11jy+6Ag32Q7G5
         bA/g==
X-Forwarded-Encrypted: i=1; AHgh+RrFD5rcba7YXkGuqm6C8qy7NhRKmXeNjgdMl6uYAGn7wRdgCw7S7V2XcvbDbzwN0yE+EdP9K7nPvg==@kvack.org
X-Gm-Message-State: AOJu0YydlJ/4tAMVTf0jhVZr81X97QZN91eoQ7zxaSGM0GA78VBvCIUK
	Z0XLMzpaRcCHMrMemslJEh5B7qA6+hGHa5ZqgCDvU30UMFvwjJItWSe5RMU7Z4TJLSZvNKSe/OV
	6G2TLjaOgfKpn1Y8CDf69CAO+oPkc5lZVurEJcXGgpEHpzN/hLB+l
X-Gm-Gg: AR+sD13wxWnZouXiZ72O+zPcUKnZ4JLflmJ0ACQnm6DhoGPJJcmNb/oynxSxw/IwRuW
	eNpjVzdYKDAxKiZN5nIj/rUK99d/E13veNl5q1F9+fcKF3XBEEF+bInpeFfcX9UaWaw1tu6KdaQ
	0xLhfP9ypEkzWkCxDpt8TdQiMtoYEDYaCisQw85zl4bUDqNDA2GOKOvcMgnEnLkvgVH8wsOepO4
	pGUOze7KWAHAMZ/sdS538TGCpg1WF+JH7GQWZMUu67xT6o0RTSRqZq9d/puwTKHGKzeqcS00JhA
	nxoFSwVcq8oKaCKxX8EUBtp3sS1vYZku6a6W5KsgDCU2wPJH1jHUM+bbBf+QoIJp/IVjYB3cLxA
	fyRN0BtOLpE69FGhHF+pplM5vlNZ/I1YMtjPzXlsRpm/XLqDV75I5cPtYztKjBGwWN2zUv2TqRt
	dYAJU=
X-Received: by 2002:a05:6402:548a:b0:6a0:923a:cfe7 with SMTP id 4fb4d7f45d1cf-6a0a7cf5cf6mr192235a12.37.1785516232528;
        Fri, 31 Jul 2026 09:43:52 -0700 (PDT)
X-Received: by 2002:a05:6402:548a:b0:6a0:923a:cfe7 with SMTP id 4fb4d7f45d1cf-6a0a7cf5cf6mr192219a12.37.1785516232159;
        Fri, 31 Jul 2026 09:43:52 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.34.92])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a09c5a0556sm2582577a12.5.2026.07.31.09.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 09:43:51 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Sergio Lopez <slp@redhat.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	bcm-kernel-feedback-list@broadcom.com,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org
Subject: [PATCH RFT 3/3] drm/ttm, drm/vmwgfx: directly create writable PTEs when mkwrite is in use
Date: Fri, 31 Jul 2026 18:43:41 +0200
Message-ID: <20260731164341.1109827-4-pbonzini@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731164341.1109827-1-pbonzini@redhat.com>
References: <20260731164341.1109827-1-pbonzini@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yXXfoLfBWsVnXMNfMXmxmvTCussKes_vHo4OsMUUbOM_1785516233
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 0EC9618000F
X-Rspamd-Server: rspam01
X-Stat-Signature: zkmkyiknszouqwwdyear15qrchctibkt
X-HE-Tag: 1785516305-408150
X-HE-Meta: U2FsdGVkX1+U6jSReiG0nec3aDnadl7nTyaEtJyDrFxG9+w9eVJ2AHEVhRVu6vQKlHG9ybjDOxqg2G/S5iZE7bmA+iny0/kZrcQ5yI00DXiWE0aeJ1JNSx4YcDfcfLzKrq4GQ3j3vmIMlcHKO3SvoX2iVPn/gkAPse1GMaw0hvthL+KcCaBLCYLduxzENRVbq74hfk3Czv4JlmDPPFxSja1FmO4nAhB3gzuVhEU92jln7m3kOSgOjSx+kvjqmAVYc4p8pgIoKu5dxy4jbkYholv+TiNbjqkp+RTbULvdPcDBja79tNVIGZoeaLBsR163QyjAdK7G0TvjdeD90QSAzmrKp5yel1Dy9IU0p0vWAptrEggnwaxGduECBh3mozk1FgB108nUEkae0Dqr1maqwk0ZNY7pbvJXv/K7WjcvH2yFyCodTvxLrupjS3icX4lkam6vKNfOnj8GXhuRMUhDYln7IMXJMxWgcUcUGXX+GMVwPjTVjI9/IX24pMm3qFcdEqRcz0DhghVoPBR/qoHxnD5BrtInCa5LIBR6NNlDLwe8iFZuGJuRGkbTuPLeEd9ppQAB6j4r6cncseTSy+yqdZqj/2qHP0mVlUF+SkOGA38MHWLqNjM1Fflgs3lioVlBQ59xTiKeymDoLucE8UEzTh7ZpP9udEeEc9NqrtPKN+yW2GH8ONLBAipPAdpvSe4FAlh03/Xa/cW9YBTMSYtJZZA1BHjzHKFVKxnLvpvhZ93zAPlj69l0fIgwOv9tcBnebYA871fcYjrlmdL3ovL+1IOJHpZwLUqVRM6osjnDc7Sbcu+0BG4gjISu4T3+TMKB9GKVyZjvyjIbwqoL1w2+mbuM52X/F9f4dzzTBAF/QN9HpjXGridAgCT2ziKjzJB2d/RShpUUVMcwUwQ6DJG1dgITPA3jOnvZHdbMrwqi/cFCtPao0nWM+IBOjBh5QKQL2/d35CyptGGTi20j5vE
 EYCWz2Yp
 jDln3O0Zoq3WISQno/PDFqBl/vmviPmRMOVpQTdlcOnfGjwXeExs+aRfX9C7nn71DjWNGwZ+43f6UkvhiyKzUIY0vjoTjIRPcV4c8lNzvOFgXBLG9wdQivpiW9kZSod7Deod5wP3kgfgcUBaFrtXIwDzc34Y1+Op0/uqnlgBdwTQMScYcDtNxesc5UdGwuCImCfwLkSMENiu5bC6SJBSGOGdqkgQiVVLuvDPldMZLGVEZjqt14IJSNhnD0opwRBqec/AHdcQo/CezYrSIhTy5GwQV3bf9dg9c95i9IUtOZCrHS9hwW62IswJLXYKIMOt/lKHrCu64j3NA+WubV/VC+okOXBknaVYIdKngXJH+TwGI9E73fGnllAqpVm97nJ/2q+JwZJ1oaYAbSn7fZiX6zpDs+xsic/0e5tBgiJtOWQbgK57yfOoDmeK1wN0zJvn4cUzh
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

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/gpu/drm/ttm/ttm_bo_vm.c            |  3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c | 42 ++++++++++++----------
 2 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo_vm.c
index a80510489c45..ef27a2d7afc0 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -263,7 +263,8 @@ vm_fault_t ttm_bo_vm_fault_reserved(struct vm_fault *vmf,
 		 * at arbitrary times while the data is mmap'ed.
 		 * See vmf_insert_pfn_prot() for a discussion.
 		 */
-		ret = vmf_insert_pfn_prot(vma, address, pfn, prot);
+		ret = __vmf_insert_pfn_prot(vma, address, pfn, prot,
+					    i == 0 && !!(vmf->flags & FAULT_FLAG_WRITE));
 
 		/* Never error on prefaulted PTEs */
 		if (unlikely((ret & VM_FAULT_ERROR))) {
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c b/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
index 45561bc1c9ef..2cc490e7d758 100644
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


