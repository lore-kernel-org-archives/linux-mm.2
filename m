Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2403DCCD195
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 03:11:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BCBC8E0006; Sun, 19 Oct 2025 23:11:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794928E0002; Sun, 19 Oct 2025 23:11:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9B48E0006; Sun, 19 Oct 2025 23:11:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A03E8E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 23:11:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E78E016070A
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:11:43 +0000 (UTC)
X-FDA: 84017017686.21.BB7055A
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0DA0B100009
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:11:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="CtJQl1/f";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760929902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wS0ztavQX8+iBVk3TNt4J3TSJ1VjYfgq/vGWWJG8qiQ=;
	b=WQItNOyK2zE56zbP9eE/Lbx2p1c81OdMU8KtQlhdNwzKRlgMd/KiC1kU1PZr0KX1T+1b6O
	5RPkHWxbl2hp8NbUMvsNCKlEgY8/4rTxjOpQ9jjz9EUx0G/VQcvAPLqQTw1UW/eQ4ZruXF
	pCn1lK1nzCUeTAYeJVgYVuF3mq3JdbE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760929902; a=rsa-sha256;
	cv=none;
	b=LVxPT3lI1eHyojbgy4sPPys2AnQL7qOaK4Z82zKJBDF6ljn3mqdLTP7TUGzAOANHeb8a0D
	Uh4anfzH0d6xUK092qLqldPz/3YU0YpoEz6gDhgjIOuwA8+qtR532dnzCtf213EM50U6IE
	UlabWviGhMIwn8l8S1quolnlzgOFo+Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="CtJQl1/f";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-290a3a4c7ecso41561625ad.0
        for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760929901; x=1761534701; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wS0ztavQX8+iBVk3TNt4J3TSJ1VjYfgq/vGWWJG8qiQ=;
        b=CtJQl1/fLb2ojmKTwWvLk54yNctHpNmHHwGTU7JSq5rlhIzPhEO+4026zvbJD3PFRc
         JIFhR/O1ezWaJeGNSsgqsTaj6EhjbMdaAQ8Ya2Z6biiju71iZ16Nxfr0zm7fw0pBbrXK
         anmkje/dgeJl4u/1e3HB+WguYdnuni0bHn2Omhzu1iW+L20Q4PlrvhWgYYwvWgw022Ur
         grIQw6jAv0Ny7E627qdIWENNVyKqU40dlaQnS/NgltjB0FHszBzymf5+8EGuEUhsvm9x
         mZp3R+CyrwHTTQ70GlnVrBrjhUVTvogKWVVURysEVkUpxWLUhcA6ZDWeWou2MA4kjYLh
         Mnxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760929901; x=1761534701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wS0ztavQX8+iBVk3TNt4J3TSJ1VjYfgq/vGWWJG8qiQ=;
        b=IMWxoI3VFtTpc8LzAeACIZstsrXiPsJYFUBE3MfMin50cz93/Hvr88Kbjqaa8WNmvN
         d4JXLUYGH8C6wpqHRI3DwsVVslBiHp4wo9AX63WwE0gk75V3J4JPja8JfaJItqj+fsKH
         ICc+3orgWWsDYs45eAzixCYcFXTtW2obalfFPo0+4ctmaPgaKlOUXYanZtLm0G/vE4tX
         yvBL73JGo6dahqOloC+Owsu2T8qeFRyKnCi2YNBQusgrC1JEEwqaaC3IJ30XdF9J0QYj
         gEBDCojNNau6BICNn5JHZt6fgfCeDkMKoP4RYsqqnhWKyXneZpKwyGReOFi1DB6MCfqq
         +0gw==
X-Forwarded-Encrypted: i=1; AJvYcCXEPOwIkmphQyz4iHVGm+y7EB/B9AUCrvChaaj8BW1l9wi/fTYlS3p3UGagRCAfzGGTVUhQoYTYfg==@kvack.org
X-Gm-Message-State: AOJu0YzbPK7eMal6DrAkLJxjT0dN7U+aPShuHgA5u/1PwxsVoynvSOaq
	3S+fkqMIm6LC0rmqsKDy9DPfSH+IgDy/V4jFrfTO/6vkdFkaot831Shz
X-Gm-Gg: ASbGncuKFTaLwh+GXVzOacuw7n69KKWkSpeR0yhl3B0etOD9KyX6iKSd5Q2aB6nxic7
	9p9s/PuFUgH3FKAILkj+VdIsXOs/z1ecv1Zp2d5ZchNVwlGrPK8AxCu5YK4Jn9zGmnHQ2Rm3UsS
	I4xH5Ekdh/FywesaSr0BtXE2IPRyw2pF3SA+bF7oNxw8TgV/ZF9kfbn8J437eBWp0+4GdhNS4Jz
	8sav95BbRwUmxDqf+GIThtGX1b+5nlnrHwSrqIfPlc5pggxQaWbams3zXSMDgVwcVTs/Ms1xSQe
	5zLyFeUd8nCGkfvrYk01W89wGTA7VSPzFAvzfZ4DCniYKI6GXF8VcCRVrPmQLhOoV/SuFdb1E8O
	KFYVQxl0BxO7XHuLvdrs/ZRk3FftXyj/QvhzfrHupw6KHOK4aQYtsn/yfErGiutuSD4SuF2xYR3
	dd1ykvqtBVUajcV01o1P3KOqkA8XKSIdZTGgodPNHPB+mLetoWJr4=
X-Google-Smtp-Source: AGHT+IFZa8bdnJfGatdhT4z/apNEwqAYj8cy//pXsskU7DFSbEPNKqHirldfR0k8NNqQ+2jTU+oRpA==
X-Received: by 2002:a17:902:e806:b0:290:5601:9d56 with SMTP id d9443c01a7336-290cb27af33mr152351615ad.46.1760929900727;
        Sun, 19 Oct 2025 20:11:40 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1da1:a41d:2120:6ebb:ce22:6a12])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471d5794sm66007245ad.53.2025.10.19.20.11.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Oct 2025 20:11:40 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	david@redhat.com,
	ziy@nvidia.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v11 mm-new 02/10] mm: thp: remove vm_flags parameter from thp_vma_allowable_order()
Date: Mon, 20 Oct 2025 11:10:52 +0800
Message-Id: <20251020031100.49917-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251020031100.49917-1-laoar.shao@gmail.com>
References: <20251020031100.49917-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0DA0B100009
X-Rspamd-Server: rspam02
X-Stat-Signature: tiuh8fa7wjdu4opg6epo6b4t1f4ngwzx
X-HE-Tag: 1760929901-405244
X-HE-Meta: U2FsdGVkX1+LbjTTNxKsOB2NLVoOyagMLcEOgE/OXaUJxIb/gB2AHtS6GBcw64Fk5Dis4+alKWGduvDZHV9VtXZfXdlxoIoSPKMsdIej97KJfM60FW0xC4AusOsYlGU56TzBXo/YiFehypdUrayZl71gYkBBB5dYKqcx2UVyOyZRiNXbuN+o5skpmU+0AV1fY4CjpOk1YiC1EaSzvSuetocYjgeGsRc+dtBkIY8N1u8RBe/A3ZvZjOBkO90XOYauLVc18PX43kBOPlE8afUmRcIAeidUSbTuCu4GWVC71nIsWicy6rnMrDJ4yuDD1vpCV5/6Vx4SNPGtTQlfvHr61Qh5eNdFO9eg1i553+RDi2668/JbCCro26ecCmGGOsNWcrcEM1UJUNIuI3Iup2GTbt/JFsHbzct2xW4hC5dA0IXzJwHtPaT2stjVNSbkGoxzJNxwia1PZdlLxkyLpqrBXR8dOXxqzp4v/39G9bWxtNrLbHBAu3tEGCEP1Pshx7xf7vqFnzlzv3AVsAitFwRrwRgk8pjzvCY6DLkPP8H0bpqDfXD8akrFhPxwjgYsSkHPKFid82GGiJ+NdW+0gAyhVC9uh3kmvfgg+OIIXn3mvMLcH4p7TZdi4U6PIA0gc1kMtc+aHj7yC2AsLV5KsNIECMnPnljbEBI0OGmrnSX+k9xlNYcphD/H/bwxZdPO5sJrqPN/Q5gsj8BJfOwoims/J4FGk9AyKppWKLrmm3L2qly3gsfit3zapIoG8I6Oqiznx5cIPknAtBE/ZxkkvmByTQw/5/n3o7Oyn1R9+im0L0wr+WZaJ/aWBkPxUPHdUmUM1et36HOqcyPxv4AKHvYzdK4EJnD4Axjq6ZPR3IDymEFTVlouJ2B7Dy5ryQZtDfPaQ2JO2S+xnZx4NM09r1o7onJdsN2vmFN/lIPWNdDPvfPb7KM4a3vZw2KCF3fVWD5qTAMkL73dWQDGmaYafLB
 doPUDuPm
 8RqJqCKYKnqfFJJQHG6JG08AUYER/3w2w4/ud2BKwX/m/gCmfVpHVyeJPD13VFTD9NYyauZh//RDBnlS025DDw/IcNzOFWmZ1Jpmm7k8/GoLCd+52PeRgaoR9AU/v8Qkli24edm80JwqziCqd30iwane/h60S7rJJCA/LeXT0Rg61rgaENRmY4S8ZwK2CARaUxku45YstEgHAJwQCBXC1hlosKKOoEj14dNi2XvAUHO56IpiEm5NKSZHj54aRdxRfBYGuB8yrUPGwzoqhWZgPwEMqYm/wq8U7ocA8jMhAd1uUrWdNdefwoxNFXLQJf3TRnRhwqxl1EfYcpc4d+2mWK9H6zyAkofoGNhy+kz4oW+v0WBru1+Ea0ddoGZm72mmVaIYrE+dcJpLdicxMaL9Na3jot3Bve7EoBGCm/GI2s6NXev6m1pEAhzbv6uyve2ntgTRGZ1QOUSr1mUrte5ceaFtcNagXrZ7E9bmxFI6EjogLa6QlT7KcJ4MOmfpodE87cTPUF/zMrTA11PJLSFz0w+aQqJd9hkc4sbzotcXvlc3k9v6LADk+knq8GR+uiuQRUw8Z+QaUaz3nHq01xJj/JDp/OqP9cZk9sYbC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Because all calls to thp_vma_allowable_order() pass vma->vm_flags as the
vma_flags argument, we can remove the parameter and have the function
access vma->vm_flags directly.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
---
 fs/proc/task_mmu.c      |  3 +--
 include/linux/huge_mm.h | 16 ++++++++--------
 mm/huge_memory.c        |  4 ++--
 mm/khugepaged.c         | 10 +++++-----
 mm/memory.c             | 11 +++++------
 mm/shmem.c              |  2 +-
 6 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index fc35a0543f01..e713d1905750 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1369,8 +1369,7 @@ static int show_smap(struct seq_file *m, void *v)
 	__show_smap(m, &mss, false);
 
 	seq_printf(m, "THPeligible:    %8u\n",
-		   !!thp_vma_allowable_orders(vma, vma->vm_flags, TVA_SMAPS,
-					      THP_ORDERS_ALL));
+		   !!thp_vma_allowable_orders(vma, TVA_SMAPS, THP_ORDERS_ALL));
 
 	if (arch_pkeys_enabled())
 		seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 8eec7a2a977b..5e5f4a8d3c59 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -101,8 +101,8 @@ enum tva_type {
 	TVA_FORCED_COLLAPSE,	/* Forced collapse (e.g. MADV_COLLAPSE). */
 };
 
-#define thp_vma_allowable_order(vma, vm_flags, type, order) \
-	(!!thp_vma_allowable_orders(vma, vm_flags, type, BIT(order)))
+#define thp_vma_allowable_order(vma, type, order) \
+	(!!thp_vma_allowable_orders(vma, type, BIT(order)))
 
 #define split_folio(f) split_folio_to_list(f, NULL)
 
@@ -266,14 +266,12 @@ static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 }
 
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
-					 vm_flags_t vm_flags,
 					 enum tva_type type,
 					 unsigned long orders);
 
 /**
  * thp_vma_allowable_orders - determine hugepage orders that are allowed for vma
  * @vma:  the vm area to check
- * @vm_flags: use these vm_flags instead of vma->vm_flags
  * @type: TVA type
  * @orders: bitfield of all orders to consider
  *
@@ -287,10 +285,11 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
  */
 static inline
 unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
-				       vm_flags_t vm_flags,
 				       enum tva_type type,
 				       unsigned long orders)
 {
+	vm_flags_t vm_flags = vma->vm_flags;
+
 	/*
 	 * Optimization to check if required orders are enabled early. Only
 	 * forced collapse ignores sysfs configs.
@@ -309,7 +308,7 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 			return 0;
 	}
 
-	return __thp_vma_allowable_orders(vma, vm_flags, type, orders);
+	return __thp_vma_allowable_orders(vma, type, orders);
 }
 
 struct thpsize {
@@ -329,8 +328,10 @@ struct thpsize {
  * through madvise or prctl.
  */
 static inline bool vma_thp_disabled(struct vm_area_struct *vma,
-		vm_flags_t vm_flags, bool forced_collapse)
+				    bool forced_collapse)
 {
+	vm_flags_t vm_flags = vma->vm_flags;
+
 	/* Are THPs disabled for this VMA? */
 	if (vm_flags & VM_NOHUGEPAGE)
 		return true;
@@ -571,7 +572,6 @@ static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 }
 
 static inline unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
-					vm_flags_t vm_flags,
 					enum tva_type type,
 					unsigned long orders)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ea3199ea98fc..2ad35e5d225e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -98,7 +98,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 }
 
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
-					 vm_flags_t vm_flags,
 					 enum tva_type type,
 					 unsigned long orders)
 {
@@ -106,6 +105,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	const bool in_pf = type == TVA_PAGEFAULT;
 	const bool forced_collapse = type == TVA_FORCED_COLLAPSE;
 	unsigned long supported_orders;
+	vm_flags_t vm_flags = vma->vm_flags;
 
 	/* Check the intersection of requested and supported orders. */
 	if (vma_is_anonymous(vma))
@@ -122,7 +122,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags, forced_collapse))
+	if (thp_disabled_by_hw() || vma_thp_disabled(vma, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index c2c683f11251..107796e0e921 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -463,7 +463,7 @@ void khugepaged_enter_mm(struct mm_struct *mm)
 
 void khugepaged_enter_vma(struct vm_area_struct *vma)
 {
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, TVA_KHUGEPAGED, PMD_ORDER))
 		return;
 	khugepaged_enter_mm(vma->vm_mm);
 }
@@ -914,7 +914,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 
 	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
 		return SCAN_ADDRESS_RANGE;
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, type, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
@@ -1521,7 +1521,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	 * and map it by a PMD, regardless of sysfs THP settings. As such, let's
 	 * analogously elide sysfs THP settings here and force collapse.
 	 */
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
@@ -2416,7 +2416,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
+		if (!thp_vma_allowable_order(vma, TVA_KHUGEPAGED, PMD_ORDER)) {
 skip:
 			progress++;
 			continue;
@@ -2747,7 +2747,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return -EINVAL;
 
 	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
diff --git a/mm/memory.c b/mm/memory.c
index 19615bcf234f..8bb458de4fc0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4558,7 +4558,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
 	 * and suitable for swapping THP.
 	 */
-	orders = thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEFAULT,
+	orders = thp_vma_allowable_orders(vma, TVA_PAGEFAULT,
 					  BIT(PMD_ORDER) - 1);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 	orders = thp_swap_suitable_orders(swp_offset(entry),
@@ -5107,7 +5107,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	 * for this vma. Then filter out the orders that can't be allocated over
 	 * the faulting address and still be fully contained in the vma.
 	 */
-	orders = thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEFAULT,
+	orders = thp_vma_allowable_orders(vma, TVA_PAGEFAULT,
 					  BIT(PMD_ORDER) - 1);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 
@@ -5379,7 +5379,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	 * PMD mappings if THPs are disabled. As we already have a THP,
 	 * behave as if we are forcing a collapse.
 	 */
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags,
+	if (thp_disabled_by_hw() || vma_thp_disabled(vma,
 						     /* forced_collapse=*/ true))
 		return ret;
 
@@ -6280,7 +6280,6 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		.gfp_mask = __get_fault_gfp_mask(vma),
 	};
 	struct mm_struct *mm = vma->vm_mm;
-	vm_flags_t vm_flags = vma->vm_flags;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	vm_fault_t ret;
@@ -6295,7 +6294,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		return VM_FAULT_OOM;
 retry_pud:
 	if (pud_none(*vmf.pud) &&
-	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PUD_ORDER)) {
+	    thp_vma_allowable_order(vma, TVA_PAGEFAULT, PUD_ORDER)) {
 		ret = create_huge_pud(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
@@ -6329,7 +6328,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		goto retry_pud;
 
 	if (pmd_none(*vmf.pmd) &&
-	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PMD_ORDER)) {
+	    thp_vma_allowable_order(vma, TVA_PAGEFAULT, PMD_ORDER)) {
 		ret = create_huge_pmd(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
diff --git a/mm/shmem.c b/mm/shmem.c
index b50ce7dbc84a..9549c780801a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1780,7 +1780,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
 	unsigned int global_orders;
 
-	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
+	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, shmem_huge_force)))
 		return 0;
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
-- 
2.47.3


