Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFCABC5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E4C76B00EA; Tue,  4 Aug 2026 10:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 895DF6B00EF; Tue,  4 Aug 2026 10:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 781A46B00EA; Tue,  4 Aug 2026 10:32:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37D246B00EA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:32:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D64DA40154
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:06:00 +0000 (UTC)
X-FDA: 85063458480.12.1AB14A8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id A4D8E2000C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:05:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cdyxOwaX;
	spf=pass (imf03.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785845158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6MKpfy5ngorVqbj+qf8v5CmiQT/j6dhAeNWojtcyJWQ=;
	b=r9Igcg269aZVxcBWpJuOCrVYSsJ5yt7E7hKll6MF1SU+bUFfOaoiqyEfjZE/ybXIrDpD0K
	K2ZcixV+0HUuz9kVnqfeN5ePmgBZo+F5nLrkGiAFh4yEq84bPzezEk+SQXU8y0geea0AOn
	eQDV/71ZNoUefeqaik5wM2NeXub8O1I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785845158;
	b=LB1vceU7asiMlXGFDoXT6H3BsV3+s+0k5U8usDuOz4tS+eJWO8JI5OPTOfsfV7MDGRR+y2
	qHqolxPweWD3r1iyvmYiHCUSr+HsGt2V3vY0nnqcdSdXw4aKd1/kaxP3SZ17hu1gVjeZJV
	mDlEj1H3onIdmMBQhPrBB3vjfMWacPo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cdyxOwaX;
	spf=pass (imf03.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785845158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6MKpfy5ngorVqbj+qf8v5CmiQT/j6dhAeNWojtcyJWQ=;
	b=cdyxOwaXUNZl+m+JRItHFeLzbVPFnBh0OfXJ+JBdyKJO4YXUM+5sCRP5FVRgfrjM89aLe9
	W4VkC3X/YIyqblnf+KmaH2bYX+Jtyh+MIqXwk3DGU03u91SrGfl2CrdDasWZ+fIpmgJ/sC
	mTw8vyk5xJ15LfhHj+z1TCjfBRhVUvI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-06_3hagpOZ6iqm-HBYXuvA-1; Tue, 04 Aug 2026 08:05:53 -0400
X-MC-Unique: 06_3hagpOZ6iqm-HBYXuvA-1
X-Mimecast-MFC-AGG-ID: 06_3hagpOZ6iqm-HBYXuvA_1785845152
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4955ce558d8so32679235e9.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 05:05:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785845152; x=1786449952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6MKpfy5ngorVqbj+qf8v5CmiQT/j6dhAeNWojtcyJWQ=;
        b=gUDCI0lncw+Rvp3YtAVrj2Agyr8gQ9mEWXO70AQ3MwbdBfHAWKG/aDD7SnPRqi+rzI
         Ene0o/PDCgkrgBgd3dxmiTbOFSgc+zXlJ61uu9YOdBNwcKuBnNC05ZheiNHjmaCmzvT8
         NaB067Pp+/qU32aoUS5X1+aVfoGDvK/t4/N0k37o7yBFC51fOxJV0SZ07SgRUYFE7Con
         CZgYF/AcJigD7Fuym0W6J7I3MzsfUH4HNQWZV14F79+4EEjFhyRO1e7QtKWczoXDmDAG
         FHb3XIRcmiKRUMTm4MJ6P1JDcNYjf44gs04s/ssyrXKmGJOIxiZYNAaEuI1+SUk66n36
         3Rvg==
X-Forwarded-Encrypted: i=1; AHgh+Ro8dnP+TkJTRi+RtONKB0Orzei7Hygwff+zvKb2avTaVbjWWGdzF7pVvm2l4sEfmy2CCfvWU+9YKA==@kvack.org
X-Gm-Message-State: AOJu0YxNtIP+69m96x5kUIR0xP85G7/6sBTk+J5kb2SvXuZfBlJqKFWW
	wMU28o1MTRGcU9ifelL+Oz3igP5DRhhKSopd3wpTqv+nwJWgwkJ6CRP89Dxh9Ql2mRic0jGQrhf
	pCbfkwmYyU4ixb4SAdGltew58QlH+YAzRzGztj+fwKH24+GLWGqlQ
X-Gm-Gg: AR+sD107BnZIeozxwzm0Xs16tz0UcH8ro3mLpSFRCfTQzyKmuRCQDzh2tPI0jWt/qtM
	eFGYiCPDbYVkoVD2UNA088USkpPevJbMAZlp/jqQL2LGSO1KeHoJHDoXmqfmE6b1xHm4owMiq8M
	dAj9sVtHFwsymr08tsvZR2I5TQsDWaztDBwOz90I9zcx12wQOqgb+M5DW5eXe3MJGqbOjemDosy
	Lt2Ju8dddyYCqguIL2VZZds+ncGuSMMZkyX4fOdjAJlLuTM/ybwaBhaS7uTXtD1CMGci7AhUJxm
	xaQundfTgnHdKnjauFaIB9MXRkYTZQUTph3Jk30UiOQ+ysKf7fgt1HVXPjSYSWcAEz9BCW97k/i
	qTG9ILn9ZXpd8SMJSRt75ILoxDyzKhqceb2ipPsxVpSJ0IbgggG/W67SQE3OZ4QnAwq/4/cERpl
	XKR4c=
X-Received: by 2002:a05:600c:840f:b0:493:c42e:5be0 with SMTP id 5b1f17b1804b1-4980c60705amr298312275e9.0.1785845151897;
        Tue, 04 Aug 2026 05:05:51 -0700 (PDT)
X-Received: by 2002:a05:600c:840f:b0:493:c42e:5be0 with SMTP id 5b1f17b1804b1-4980c60705amr298311535e9.0.1785845151462;
        Tue, 04 Aug 2026 05:05:51 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.34.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49949fd8df5sm88354535e9.9.2026.08.04.05.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 05:05:50 -0700 (PDT)
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
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH v2 6/6] kvm: return -EFAULT for writes to !VM_WRITE IO mappings
Date: Tue,  4 Aug 2026 14:05:28 +0200
Message-ID: <20260804120529.1730187-7-pbonzini@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804120529.1730187-1-pbonzini@redhat.com>
References: <20260804120529.1730187-1-pbonzini@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FYmNlEk3cgRQpy4JRgegRtd1uMrp6NVdsee7MIs1zW8_1785845152
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-Stat-Signature: j6ruwhh1j83hqmkjmrfzpfcub1cs1cfp
X-Rspamd-Queue-Id: A4D8E2000C
X-HE-Tag: 1785845158-191839
X-HE-Meta: U2FsdGVkX1/QUp8NnWKx6ORkt1seyLD+ZnuIDomdAsCzjjJYEVLPcRGQlN1hjI5TinvGPcg/uUXJvpjnq4uOPMPpeBW4t2KsgbOqnU8T5/tUkniZH79E7HBfVBFM7jcRB6zGboxzJlRGL0thQV88iP65t04GsCHbHOpYbtCnZtu8CB0XscMdnVp+Vus/OEfQ8R+c7Cfo8HRxPqtictrh3+aVYuXKp+iJP4HMoi0Ig6eM12npDwiegoVJcXJLlUez35w93ocjo/yVhWQGxWYah6qzy4vE+/Su2+sv6uBzw2BNQZN5CTzpR4cqlcIJNgzJ6MJHzdZkmo0UsKVDJAl0ruRL4DHaQZ+g2MUUstYatf9LIgxRXTpZ0xLUd1M8XQHJBUI7qBbSqcL3wZgqrd0s33UF90XJ4TSaXt/vWoOxh82O4VQVCModE0pQwvDqyBvTA7celA1ECOfOH7X0jHPSOEKYJmE61gQPAYGt6cV0yLkXrob3WmR0ly/WG6/Fu+8juoGWFKVP+6DfuqaHoGaKBqd1Ter7WSoqDQaj3pfBBu+YKHL3mXsZ8sV8oPezjh86RsRHaBJBFTUx9EAJx0zLUHQPOjKS23PblnW6ibMEauMpnvkpGIG0/3Mn/2/rgpaQT/MUyAwsxQiXzy6+jus/SqToXk3g62bU+UvtPQGIhXLvSrrospII06FaBNgCM0LpNWFsI0ZYxSokcigAaQ2sFLi4TPspcEpNRqvsjSvJwecF7+9/LAAfF8GnYkCFLcv68eA1ocYHUc4rFwlIeg789XRDvrv1EhUj1EVXftyImG3NeVEa1yEX7U7cFLrcv7n0vXh79NQl3t9IBe9tBkpFrMFfJoX42+pZW5DCwi9lM6ap6lIYveIaw4IJyEaYindge1H5KhF+HbER08t5jR4QJch56yHmBwaBRbBdcdyUdfUSfa1za8YcNVTRmqDvSrb/BK9iTnX/cPa+7YBu2cZ
 34cg3lSM
 RQ3zAATC+B2+Pi1YZdcU4DLVP+yCP9eugk7vOf0UtTH29CK/iJgjIz7TOV0f7DsaM4QNVmfUCJxvy2EbvN1dtf2w4GeEoPWjwQKEgp8xJMw22nnQvuFBmuS5zlFy0Cp4WisHZekLvojjwJLTteO1FS1tPcj241BUt6J1oOvep6SFa/XFK9ypV5XUvDUOBkoOPDsmJoY5idDC54ZFgTegrxsfkf35ykQrJexLjIvBIeFXWWr6QLTZtRqyKK20m3PUUq1xLkIE4W1wpyRmmYBF20GoTKNCQuQvdDMy+YdbCY9BiNAQzhhxJBNb03K353WzudUXW/qj5tYxBMEwAMjr3vfG4HJ7TnDA1Kx42tIwmCND5S8hQwvqffG6jnAtx/70Gh8RVK2cRS23qz1YIPRhXRbKJaAEw98+lQiySp6kPvLCU/1HDyVlCLEEpCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KVM's behavior when the guest writes to a non-writable VMA is inconsistent.
For regular, page-backed mappings it returns KVM_PFN_ERR_FAULT and thus
returns -EFAULT to userspace (which is ABI, and relied upon by tests);
for VM_IO/VM_PFNMAP mappings instead it returns KVM_PFN_ERR_RO_FAULT
and thus exits to userspace with KVM_EXIT_MMIO.

This behavior for VM_{IO,PFNMAP} was added by commit bd2fae8da794 ("KVM:
do not assume PTE is writable after follow_pfn"), and even if it has been
in place for five years it is unlikely that it is relied upon by userspace,
since it is inconsistent with KVM itself.  Change hva_to_pfn() to return
KVM_PFN_ERR_FAULT for all non-writable VMAs, and restrict KVM_EXIT_MMIO
to the case of an explicitly read-only memslot.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b7c21a48a45c..da5b0bb62590 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2999,15 +2999,10 @@ kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *kfp)
 	 * or the page might be absent.
 	 */
 
-	if (vma == NULL || unlikely(!(vma->vm_flags & VM_READ))) {
+	if (vma == NULL ||
+	    unlikely(!(vma->vm_flags & VM_READ)) ||
+	    ((kfp->flags & FOLL_WRITE) && unlikely(!(vma->vm_flags & VM_WRITE)))) {
 		pfn = KVM_PFN_ERR_FAULT;
-	} else if ((kfp->flags & FOLL_WRITE) && unlikely(!(vma->vm_flags & VM_WRITE))) {
-		/*
-		 * Exit to userspace for PROT_READ mappings in a writable
-		 * memslot, as this is part of the API.
-		 */
-		pfn = vma->vm_flags & (VM_IO | VM_PFNMAP) ? KVM_PFN_ERR_RO_FAULT :
-			KVM_PFN_ERR_FAULT;
 	} else if (vma->vm_flags & (VM_IO | VM_PFNMAP)) {
 		r = hva_to_pfn_remapped(vma, kfp, &pfn);
 		if (r == -EAGAIN)
-- 
2.55.0


