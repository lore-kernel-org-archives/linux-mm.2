Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9243AD2168D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F04476B000A; Thu,  4 Dec 2025 10:10:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDB796B0093; Thu,  4 Dec 2025 10:10:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCA816B00C8; Thu,  4 Dec 2025 10:10:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE13E6B000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:10:15 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E4C088007
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:10:15 +0000 (UTC)
X-FDA: 84182124390.09.B0D1266
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3A3551C0015
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:10:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UqXrYUCM;
	spf=pass (imf20.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764861013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sakCo68nQ8rcVde6IgWDv4cz9Y66spTur3aP7RQqpdI=;
	b=2Sj9dxoDglbS9AluapiLLiCh22e2/wPE5x0NiG1LBTf5zuv1s7pqY1eL+QF0jAmytH35mm
	IK8mtl3c0RiFDdmt8m29FKFfKszOczpdWoS2seb3y7bWe4LllYBmXMxrv6Wop2nM5mKTcO
	pr9zBGy2RpZSa0Wx+VqJJrQUOpJtbOI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UqXrYUCM;
	spf=pass (imf20.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764861013; a=rsa-sha256;
	cv=none;
	b=JI1ebEB2WCZ9SGnrISbdWJVgBgPZXy4vHJytZjqi+wtJrfaqhLNzGjxrnewHzu1CYxEjq6
	8HbuvwTKfDeSXWjQhEX/2bvewWX+o1FYw5m88/xMxRxbyVCBaXWXpMUOA8ZBhpnP+qmhNb
	fpotPMKy+jZveJFA226TDOktyv9KwZI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764861012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sakCo68nQ8rcVde6IgWDv4cz9Y66spTur3aP7RQqpdI=;
	b=UqXrYUCMtS1JoeECb9uDHxfk3IsfImWrfC5ytE8M2QS9W2emy1VNc3S3tmgg139PLG2jeC
	001Skx0iCSx0sIJgu+iHoItBTq9JxF3ASpX568R2YXLUoieK4+RutzbRocgLnKhE6i7Y2T
	VB9HG8zHhMy+a+ZgUS+SgnQ5GeDaSoA=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-zrRAMfgcPDuE2cd7BjLZOQ-1; Thu, 04 Dec 2025 10:10:09 -0500
X-MC-Unique: zrRAMfgcPDuE2cd7BjLZOQ-1
X-Mimecast-MFC-AGG-ID: zrRAMfgcPDuE2cd7BjLZOQ_1764861009
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8b24383b680so351719885a.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:10:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764861009; x=1765465809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sakCo68nQ8rcVde6IgWDv4cz9Y66spTur3aP7RQqpdI=;
        b=maI+XvpeRtZGm/FgPuX3/Ab8RPPJwxqnfPPcwGKx9HQcBrhgZ8FBtu8i5tcB+XirJ8
         JYcWQV34w0FBPlMXftAPWFlB8CkSKYF5eUrabIEib2uogyN800oOp2vESIYYVu+8ubZk
         BowL04oJ+BXnenyx/F4GWZTAIIfUE5sm0RaHcCaRv8lURe/2KlyrZGz6nsA9+y6i/ldx
         K5sMBLRjUetiZCYm4QWD76wUuDaJstpICcj+NAZWkoEYljLWXvPzAQWWqGGWf+g490F5
         k/Yn9zVp96XEBwUGND5YVwh8n6GD8AYvKmf2mdfTxp1p18jwh6oUR4KDiDLNqR8B53RK
         guLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhnNO8cWLiXFGzpnMUlErdPH2LeWF1OKy9Q3KIFK/+R6td2ZJcMMQSd5iMP0/sT1VohHYw1otbXg==@kvack.org
X-Gm-Message-State: AOJu0Yx+hCNFey2EXLYc4kSjEL9Jy6kDvwjMBMGoxVcZcIlPOJeoxr3k
	Cg/tApJSqMbzLNYQaANXZWHfsR3uEgL5CcyarJ7IcuEXCUiRr/q1NTARfZEdXCyii7jASIkR72r
	kiixxxKdX37hbDwtAip89oUVFw8QYTUhopUlxlVMDBoguI4ZmSitC
X-Gm-Gg: ASbGncssgvBlmQ3ayQLkmgDvWGXh/2G/hf70f++eCgXMov/6CPcDqjuoJkwjZukkYD3
	sMi2lZz0PqFUdD/AYtVNjrLZSCuJFgjP5G3KdDaxRCxGcK/vWuZJQUQryqkaPCxNN0/AJnMJGK9
	a+sdrCle61Nilug+7iUptvU+ghDKFw8Sueup/5dP2h+Y47spw0eMXhnn7POmCaTAF2uHMLv9MYV
	i7SqE3bypGMq3Vq3Zh2B0Byr2NEa4wxW23OpOH3NDkGRHiHIaBSZqcejdpy779PfA4KiGVgBart
	HunvIid8AxBjcaspnbt0AJRSSjIUzCA4PdXJS2SWA6tL7wIlfyamvqBPteiSF/Rb2m3eoU086mM
	5
X-Received: by 2002:a05:620a:414d:b0:84a:d3ce:c749 with SMTP id af79cd13be357-8b5e6f7aedcmr934168985a.64.1764861008628;
        Thu, 04 Dec 2025 07:10:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHDVl5FRV7K1/nE3AfLW2VTsm3DwP3EmQWe4gJ+Y9zdrDlKNoHx1ohilHm+3n6BN0372Ep4EA==
X-Received: by 2002:a05:620a:414d:b0:84a:d3ce:c749 with SMTP id af79cd13be357-8b5e6f7aedcmr934161985a.64.1764861008037;
        Thu, 04 Dec 2025 07:10:08 -0800 (PST)
Received: from x1.com ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b627a9fd23sm154263285a.46.2025.12.04.07.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 07:10:07 -0800 (PST)
From: Peter Xu <peterx@redhat.com>
To: kvm@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	peterx@redhat.com,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 1/4] mm/thp: Allow thp_get_unmapped_area_vmflags() to take alignment
Date: Thu,  4 Dec 2025 10:10:00 -0500
Message-ID: <20251204151003.171039-2-peterx@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251204151003.171039-1-peterx@redhat.com>
References: <20251204151003.171039-1-peterx@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uRbqP91RPT1uccpxBRxkFjf1NUPbCOKkuM5u97NOAgA_1764861009
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: qxq9w7nr3m1fa88y51ddoeihjipxtti4
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A3551C0015
X-Rspamd-Server: rspam09
X-HE-Tag: 1764861013-556648
X-HE-Meta: U2FsdGVkX1/DleMwbTY8f8SPGpiDABLTXpFQY+cMFJmdDY1uhUfrasG36WwLnNqdsL/njKcsDcAEfFCtUMrQHViGOM/2Hw9GIMb6oP2bOt2paSomyzaVJe7fIza4/az3Xq7QG4oPPKjzpTHs+t2dteZJBuRmm9YysImHHKSl15Cj7vslLzOjk40BvqVBtZFSSafihC8LXZZW3TYF+07sBuIdYwaagjFU1v/CteeQqFkVIyfiD5dRXOjmVMVIzKZHzwoU9/D739YKCHQctFaG/A4UgLCjrNM/ghnMfBEpTRWBxQa87EbOekeeEsfwZhWb23Qcg/eHIrFOpUo4ly9hv78Of0uC4RyAEtnK+KdGzsLcMUV4BzAAzX8qLre2yYHUercg3mZyvAQofvWK5zmUALWZHH4+BAvDLnvRayP4pF6zoAQJEIKHvhOAJSKoZz6MJqdTsXEinLeuh5Gafyw9bbzeYacpwFTlqestTJ+bg4Fa9uYeJy5RURMjoc5gprZDNgSPd5r+EpS9nRcq60Wc3t6Or1Tn7eHy11tO+hYRZyNVEsgkNxixa3T0gTD0LTPg7MJvu/sG4Gi4lmZBWPQ3SXVRjToGE5xJOHn5xo5HyFZglqcyx09ewwCuU/IRv6m0CG9tyzHPw5tY42LSK/qlgZGqwwkPBhBaZIjUBycrywED0uROfAI2VgRVwsH9rSkmkSw+nUgybyNp/lBFUxIG/zqFcYdHmdf0WfQ+0rAWmZRbpDVl3HDM5jZZBY3wTSm/vGZ1Cozk3EYROnwfnz99MemFCLcriCI8UKK1HmO30Wx0sXnkfxHH7eDu5vqKr1G9vAjFByBnk0edsZCVuQXoCf29iANbLQpidecNHVASpqOIA5KMI0EGLSrLmc0n9Ea3WzNjDFjVdurRU0vjP9ES9so33GTlp3pLYcOnf/ue+YHwpLoMTfPDrs8Y30gDemV54PIm8KVK/MJL37YOWi/
 YfjonhOC
 2CFz0eV20yg9hSAzeSeIEJarE+jhROW3++jROTBzAVDB1uG8oSbrv6mDSobc0Wvja7MvSUp7e8+5v9feYJqL8PPg/OySV8BH/LCWB0AmpXdjKZZDYquz7gb8zBhmVu/NuiX8uVof0R0qJJnV6MHwWI7uKb6AGa0XeO+tpFp68NMw/YKPbYSWrRpKCFxmMEhAhgz9ndfUocs+OLcszktnhIAM2W8NUun94Vle9Tv0rs5L7K9VuPE7e9B68A8cDCeaeGfaFmIhRez7y+CLLUmCVUcxOJknfnWnqOadxsKMkqeXBC8OCCXyWDnH4mOzUjKPQ8FKqN8QJEupddo1D9O7QJRD1sd+D3dtLkC7Cn1+D3osi4SAEo4oNb0yrQvhUUgmovcGcnI8ClZ4WFCchZlSNE4LtZ2t3FewCJeUknYwijrp3wdsF0A41AijVMbAXF9to5lpC9l3Llu5i89SNYCtnC7lvVi596ro+V5AZGFkpauYHaRWMUMuLImW8QHLRs60y8IheTkmdSLpfXSyxBER3Cec/9JyHIVcrx1R43DguMpwPJtGYdSdztXlVL1fI5hKi063E7Kw8zRDrU2YnP4EcGJYmAEIOAijHuRGY0mhe/WSDCEQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add "align" parameter to thp_get_unmapped_area_vmflags() so that it allows
get unmapped area with any alignment.

There're two existing callers, use PMD_SIZE explicitly for them.

No functional change intended.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 include/linux/huge_mm.h | 5 +++--
 mm/huge_memory.c        | 7 ++++---
 mm/mmap.c               | 3 ++-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 71ac78b9f834f..1c221550362d7 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -362,7 +362,7 @@ unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags,
-		vm_flags_t vm_flags);
+		unsigned long align, vm_flags_t vm_flags);
 
 bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
 int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
@@ -559,7 +559,8 @@ static inline unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 static inline unsigned long
 thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
 			      unsigned long len, unsigned long pgoff,
-			      unsigned long flags, vm_flags_t vm_flags)
+			      unsigned long flags, unsigned long align,
+			      vm_flags_t vm_flags)
 {
 	return 0;
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6cba1cb14b23a..ab2450b985171 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1155,12 +1155,12 @@ static unsigned long __thp_get_unmapped_area(struct file *filp,
 
 unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags,
-		vm_flags_t vm_flags)
+		unsigned long align, vm_flags_t vm_flags)
 {
 	unsigned long ret;
 	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
 
-	ret = __thp_get_unmapped_area(filp, addr, len, off, flags, PMD_SIZE, vm_flags);
+	ret = __thp_get_unmapped_area(filp, addr, len, off, flags, align, vm_flags);
 	if (ret)
 		return ret;
 
@@ -1171,7 +1171,8 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
 unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags)
 {
-	return thp_get_unmapped_area_vmflags(filp, addr, len, pgoff, flags, 0);
+	return thp_get_unmapped_area_vmflags(filp, addr, len, pgoff, flags,
+					     PMD_SIZE, 0);
 }
 EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 5fd3b80fda1d5..8fa397a18252e 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -846,7 +846,8 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 		   && IS_ALIGNED(len, PMD_SIZE)) {
 		/* Ensures that larger anonymous mappings are THP aligned. */
 		addr = thp_get_unmapped_area_vmflags(file, addr, len,
-						     pgoff, flags, vm_flags);
+						     pgoff, flags, PMD_SIZE,
+						     vm_flags);
 	} else {
 		addr = mm_get_unmapped_area_vmflags(current->mm, file, addr, len,
 						    pgoff, flags, vm_flags);
-- 
2.50.1


