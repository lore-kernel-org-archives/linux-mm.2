Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA564FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FC226B00AA; Sun, 26 Apr 2026 17:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D4AD6B00AC; Sun, 26 Apr 2026 17:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C31D6B00AD; Sun, 26 Apr 2026 17:48:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ECC5C6B00AA
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:48:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B16951C0707
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:09 +0000 (UTC)
X-FDA: 84702045498.12.4B0E4E4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 75FC62000A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="QnA/nKN2";
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CI0eARfgql4LoyAd3/aNb/WcXh5TjMiJ3J1/62uF7XY=;
	b=MdYGb0OMKODMaI6Ep65ndWonWRRbklSskQdjc5l2RGsAx8knap+9GiWBiHZ6HZ51puyhXg
	3Dc68W6Ai8QHV2qfcYbqv8Fea0xQ5e40ebNzjKItjlW41DbfpPIGvrwOx0BqY5YJVZsjOh
	U+LwYicYESdz0Yw+F1bHGyPOn0qIAzs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="QnA/nKN2";
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240087; a=rsa-sha256;
	cv=none;
	b=uueFfvwm+rKHIsWAIK/e1qrpMFs2IV2PITMOS9paLAH4LfWqSN1Lxk0RtiaaLD2Mu9VB8n
	SGKUK2WjIzxa88zEhn1nIUdMHDWGcjI8EQa9tns6PaPfOYDBfV5A66LTSsnMKMq6mqDldt
	JqM882lgOAnhOqUR1a5zd7aJMuES2ro=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CI0eARfgql4LoyAd3/aNb/WcXh5TjMiJ3J1/62uF7XY=;
	b=QnA/nKN2504jfoxv0bGhwImtgqQaIKkJdHtIlPiyM1jSeL+OyDCL/XuIULu80+KnL7juaH
	eq7nkCzrT7op6lRVQbmF4vHHfykkDCdpKfAschtlDTMea+pPqiJEdxtAk9UJXC+l/Yt1Wu
	zY2s10KX/H5Z0QggO5+45i9uBQDCNlg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-AcxOKkZkPpeJKsPXaSks7g-1; Sun, 26 Apr 2026 17:48:05 -0400
X-MC-Unique: AcxOKkZkPpeJKsPXaSks7g-1
X-Mimecast-MFC-AGG-ID: AcxOKkZkPpeJKsPXaSks7g_1777240084
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-488d8deb75fso78403455e9.3
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:48:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240084; x=1777844884;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CI0eARfgql4LoyAd3/aNb/WcXh5TjMiJ3J1/62uF7XY=;
        b=CTf1EAOfxMkX2PvfNa4iWe/cn28Bj89woBLU7WLzttIDGRPPhmCnsZtoB027l3ipbU
         xOhr2qJEkiH9k0SznQsfmdA9nAdnU/LKBzE8vkAqItPe+RVdUS+Cuvn6yrtYWFPVmW7J
         2Uwh9YS4ZesAn/VbkMQ9xEWaSooc/wn6e4gJKgeu+B8KWgBuujfI671zNeHbB/36Dc1v
         pWnGQk7qv9e6N5k5+/HtoTkhcziwcKxCaNFuNvxBmSgP0tYcRWJNYJyKsYehjksTxG2B
         p0Uk5BwM8o4/uSKg0+Ja9vN1E5NoxchFz8vziqUSNt6+QlA+HnN5g841H6vNPGbAoRVF
         CoRw==
X-Forwarded-Encrypted: i=1; AFNElJ9i5LYWukBjBzkcJPIyzRHhDEtrPB/tRW4cywErhkVaj0aVCHbWNVM4Ki8BIz4igBfB4Asn60xtkw==@kvack.org
X-Gm-Message-State: AOJu0YyhIU0fTwyeGMPV+cfCEyRbZGX4D9m2+zsrADM6/lrgMjhZ33Uu
	dxhcWJ3OWo5n1sbBU6EaXpFpdX2FzAu43al3FQ+gBRbKBt58HelaZTEUbyHGfLP5sWWANju1yAf
	43s0vEA6kCWqrrT3m5RgUnIzuMDHoZmn4A7YYcZ5L0abMCUAyuCmo
X-Gm-Gg: AeBDiet8G2F/Q/b7wcmDMWibSYmDAPmaeXe0BJYiGshMLtDW/YeAGXOvURQRKBIUU0m
	rEvGNirdv1dhaiYLqd2z0jNgpfQwFNz3nysLYDXwodekudTDNQdXZXjmu+exjeICHYnsVgZ87Fx
	c0Vd1Tnz2rH5/V8eE+8PxXsMhV+x/eO/csDLQcSnS6Tqxz3l/OUVHFomDnmHxEx2ofEO2VJAp2o
	i8QYhRXIPDYYQ6csZt9P9xd6gD1MSEoNGtVuqVfiweJM5eYFTG11X+dLS4c4eisB2/gC5eSmcNI
	nWKS0Jo/TDs9zRCh/zSuPpm+cMcLdo+Ac0qdTP4XRSt8Jz7fYg/fftM/wE3pgow/H4KlrOycAEy
	Dwdu7WBjY3a0rCd7NcGIK3iNPP8Kaf3o1D1NEa+5QUvmKOHTHXoxZ5zur
X-Received: by 2002:a05:600c:8587:b0:485:3f30:6250 with SMTP id 5b1f17b1804b1-488fb7856b9mr439937005e9.20.1777240083847;
        Sun, 26 Apr 2026 14:48:03 -0700 (PDT)
X-Received: by 2002:a05:600c:8587:b0:485:3f30:6250 with SMTP id 5b1f17b1804b1-488fb7856b9mr439936725e9.20.1777240083430;
        Sun, 26 Apr 2026 14:48:03 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4899dc95920sm158861425e9.6.2026.04.26.14.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:48:02 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:47:59 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH RFC v4 09/22] mm: use __GFP_ZERO in vma_alloc_anon_folio_pmd
Message-ID: <da7623084753450711764033f879ad3c1b9828a6.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Qvs9I8hF6Yc_CbnAG8gbkvgJQB3LyCAP8qF7259oXqk_1777240084
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 75FC62000A
X-Rspam-User: 
X-Stat-Signature: 9qnkfi8aeecus9ry84u43bub3ocfzo1g
X-HE-Tag: 1777240087-700568
X-HE-Meta: U2FsdGVkX1/HgZzuM/HD1dRM1qKN4tSE8DnvGBrjUBsXB+yAoKvE38PKys4SYxwZv4KjbwWfpuNoBdtfzYKiJTSuC6DqwL1UEvUvPXIc7ZGeFDvs7HJQLkdgyFPPZ2JvjRLv/w+pn9erN7OmMY+o+5lbtH9sRs0KrI7tTNrdxVQG23IDhvwdzO0pRhNHMOs4eyZ9LAagG1BNFT1nVBRj2LAlA74WBgy042nzV9RnYvshfU2aaeHOcIEtPLKX4Sr4H4lBJsPKVWjdD/MMhOVCWaJzL2YHBsSekTB/ZUDZ08EO5Z6dsWaxHaSx205k6ynKObStOp2YZ8JXsphptPhgj/Ku+ghSNv1jYvJEHjOYhBIlgYwuJAIX8wlm2Gum8wWIIgm2Lf5UPrkWNorqm7WKh+NQviQ9X/ZzkecxaleeEshETaYzAyQJGqj+gH9tzWJ3oRyKekb9/bcsscokkh0fPOj9b9oUezFgFrFkuWGrfzIwWLkDyOryYTQyNQHzh8KowL+off+zHn45mgJwP1QMbnCHrRbZcqtcsCgF+v6sjDPgENW58XzYZQWvlN097d+vlfZtcdCJQPN3/sbTCzhsMlLTSlJhwIZRF2IGi8pvl33vM7fIybGRku4UZFSKBWY+n6Dk0gzXWVDUyVNfb939xJnUZ1lY1/PvAdrxXTCiZ21RB65PRyEmajt7a2nBS35FkbfnTahiqCjwBVXCBydBkzByl/AUC9AnMQzIsSyOMALYYPCm2mDyLaqh8m6DDTV308stDMw4qG8txhRBhZdzFDunobnC9BRwvk5f85HQPwOYRoCixVHh3RgI2ZnWRG0V52y/VoSlyq9TBM9bOKno8xkUHufksyzlUWUq6dNoYnYmxzXbw7z0tiZKEqyBEMOpXote36hkWCfdh3Z4HlPRz0RpJHF8hHUXt9UFiRC/GEGs4RVBHxl1LEsSfpl/vUasGXDEpgZykJisa5+u+O3
 G3ubee4g
 g3h99J/MYxhTbPaIsbCALUeax9/7dmVGo3WLLbQFGtw0GUQz2pguepL/12ovt7XkcHHVsHmrHcWf3IYNCpVhAUEq/lCHK35GbBRtURwe83jrqJLbg5PDHr5S0WxwyZgED4axkOt5paABOqTVtgCLHCDZyepIrx+KcRbPJrmMK4GKVuP8gCfhy7o/3O7QgbDPOUFs3kogjTyDod5h5/3kQyyfiZnyXPP0gM6+98kltswaFPYEKCzX/H4B5g+a5o7DcIpIFCZRpJEhktnpVl6yFkzIMVmcdov/KEWOuH/uyWGWmIccJpbWL1u5uOhyI124rc8WCty8DSFpyflVoE+KlX7LEymGhZhbSmm8c95jU2OlFxuR3pHy888PM6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert vma_alloc_anon_folio_pmd() to pass __GFP_ZERO instead of
zeroing at the callsite.

Use vma_alloc_folio_user_addr() to pass the PMD-aligned haddr
for NUMA policy and the raw vmf->address for cache-friendly zeroing.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 mm/huge_memory.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8e2746ea74ad..752f0b2e5bac 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1254,13 +1254,13 @@ unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
 
 static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
-		unsigned long addr)
+		unsigned long haddr, unsigned long user_addr)
 {
-	gfp_t gfp = vma_thp_gfp_mask(vma);
+	gfp_t gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
 	const int order = HPAGE_PMD_ORDER;
 	struct folio *folio;
 
-	folio = vma_alloc_folio(gfp, order, vma, addr & HPAGE_PMD_MASK);
+	folio = vma_alloc_folio_user_addr(gfp, order, vma, haddr, user_addr);
 
 	if (unlikely(!folio)) {
 		count_vm_event(THP_FAULT_FALLBACK);
@@ -1279,14 +1279,6 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	}
 	folio_throttle_swaprate(folio, gfp);
 
-       /*
-	* When a folio is not zeroed during allocation (__GFP_ZERO not used)
-	* or user folios require special handling, folio_zero_user() is used to
-	* make sure that the page corresponding to the faulting address will be
-	* hot in the cache after zeroing.
-	*/
-	if (user_alloc_needs_zeroing())
-		folio_zero_user(folio, addr);
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
 	 * folio_zero_user writes become visible before the set_pmd_at()
@@ -1328,7 +1320,7 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 	pgtable_t pgtable;
 	vm_fault_t ret = 0;
 
-	folio = vma_alloc_anon_folio_pmd(vma, vmf->address);
+	folio = vma_alloc_anon_folio_pmd(vma, haddr, vmf->address);
 	if (unlikely(!folio))
 		return VM_FAULT_FALLBACK;
 
@@ -2033,7 +2025,7 @@ static vm_fault_t do_huge_zero_wp_pmd(struct vm_fault *vmf)
 	struct folio *folio;
 	vm_fault_t ret = 0;
 
-	folio = vma_alloc_anon_folio_pmd(vma, vmf->address);
+	folio = vma_alloc_anon_folio_pmd(vma, haddr, vmf->address);
 	if (unlikely(!folio))
 		return VM_FAULT_FALLBACK;
 
-- 
MST


