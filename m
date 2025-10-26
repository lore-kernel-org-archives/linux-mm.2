Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47F9ACCD193
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 10:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A50B98E0162; Sun, 26 Oct 2025 06:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D9FB8E0150; Sun, 26 Oct 2025 06:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87ACD8E0162; Sun, 26 Oct 2025 06:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6BE2B8E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 06:02:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2FE89B8CB7
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:02:39 +0000 (UTC)
X-FDA: 84039826038.27.0C8A3DA
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3DAE0180015
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:02:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QM8vVj1t;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761472957; a=rsa-sha256;
	cv=none;
	b=OljU8CpVONYuKxFQNXKSTkSA5OFM4Dq2/UDXhg2g3/47FArBAX2J8qIlu9Pt5DSt4eUaxc
	GgVZNTFrIEp10pV4fWl42jeHrtrVFP25rTu5pycbCVbPgPDTtQPLGyKIcM+Kna1zNi/HUO
	usVlNKkPwewQlBEDgxTQsikVr9phWTI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QM8vVj1t;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761472957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jbVnVGaHqrFJdCRV6n+ajqt/xC8SgFU/Fr8dYnGkmL4=;
	b=MajtOeAhzermbbeQ3oG/H1TCBeg7BR+swAbY9rKWxzIhhquCR+ybZaQAqlRjohM6kDn3GV
	o4oniaxY7tOKaaV9Chsu0h43BFC3HiLZ+wmbPtkunP30woD6FOR+a5CGIIHb674ecg7Yd3
	J0DYW6ZLgIUaqmne6PiTMRTEWLexgf0=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2947d345949so29787635ad.3
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 03:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761472956; x=1762077756; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jbVnVGaHqrFJdCRV6n+ajqt/xC8SgFU/Fr8dYnGkmL4=;
        b=QM8vVj1tx+wPUFI2RXh+/7DCL/MmDIVL3wWA2BAtEqD5gwG5x+1koqI43FNjY+Yz6S
         GLj8RQRGPrtv1wCJ644hzztl/bupHwmeMgqUtQCLwR4LtXHS4i+CJkjR0VxzJ62Ix+/p
         5c18/9e1YBST41vNM02qXSh6uKnEudilXk7K+Ez41/UZbFAfO+pSWSDM5uDGhFdRN+CJ
         6IbVIxit6f3R2kg3PZlb2GjgfY0bMc5zMz+pzr5E+LWGBMyNAZiqfO9N2/qJfJDjSB5n
         eRU7zBkL6GoiZpFOSMicgDb7GxVY59TlVw42Ghqp3eTYKsnmsZ9iXFVlCrp9Xs70/Bih
         5/HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761472956; x=1762077756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jbVnVGaHqrFJdCRV6n+ajqt/xC8SgFU/Fr8dYnGkmL4=;
        b=PORoDbN1i7W08AiPY0CV39vyrxdb8WhczmZvILxmwmcICvBl2xkKE8GPSHLUFKxMwr
         FvQgQwhcGxB9kv8EwEb3r9Mlg+lT1674QsbzZY+isC4E7/qFWlTg0ZCDPOp+sHOOh84v
         sALV194YASbVJc2IzCAYnOZe6adlhwt0xYacqD4KdT2lKr7252iHoO560q3x/+F5h5ev
         a7Tq3lHTsc7hyWZMnI3Z+nV/VNEdjUEOoxCPz0R+sYFfk6CNEp9QWzqiFOlrdUpOvKUp
         n01OMMARj8Q7aFu/spyhXrY3vrXLzuTydm3VgEJagFTzTb2T6rJQRcipf/BhdP6kr4mg
         +2qw==
X-Forwarded-Encrypted: i=1; AJvYcCWhv0eFFSAl3sGz5ny5hdIdoXmppOnZTz/qhhffQecYJ/zmzYdenDWCdXltBb6aIieFsVHfzJj01w==@kvack.org
X-Gm-Message-State: AOJu0YzLweu/AQsg+mzto8X8KYVig3hWy42O+5oHVZ/XMRd7tm+NygsB
	0DnE/hEAlw/5cV7COAjjxEHiJPVjtwtg/c02MaoXPJzzI3mF5FX15xy+
X-Gm-Gg: ASbGnct18VJ5CLqEF+QXBBBsExArWF1wdyL3ExGCRWagWwaIl+yzWag8+zXtZzc5m4K
	qRB7y6Iszf/UIG8D52mrcfs6kWhrtHKcXMWOAISwHCW0C82kexLvx8Xfvg5Fp/1c9Wx4TiYkT1B
	LkaoosYwQBDk0jSLQxmogqZ77e+zrENKaR4q27qw/wKB/yj30/B+GIzUFRQXhMN4+Pv6KZkKFeP
	X+6zigAx+kqLKZFiqiPg03BoyjL0eC6BD0EhGXKr0FsDiGn0+DaIGnC8N3mpZ3aeT9gicP23uiI
	SamRVi2pIocFTRzjf5MrbizL8i7lnVs7eoZ4NEuztrvOMAQuIUqnd04O35JT0dDYPeiFMR2JhJK
	t0GPO5em8xogFGHjDrpEww15m5/vPVIUkLo34zrVTTRy4TS1eAE1DalGNyV4cDXFxy886mAiZEq
	3VX9UXJLFgABxOcxe0Q6ja6HSW8c2B2FbPHzFxTYZem5upgA==
X-Google-Smtp-Source: AGHT+IEHiAf1xhYPZcQXWWYJYlUb8+VjgEsLLSD4AaSTvlXk3s9NkaWuatTzU3JvxHW3wsUmkhjPBA==
X-Received: by 2002:a17:903:2f8c:b0:293:97f:208f with SMTP id d9443c01a7336-293097f223bmr176009695ad.45.1761472955908;
        Sun, 26 Oct 2025 03:02:35 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1a84:d:452e:d344:ffb:662b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7d1fdesm4824966a91.5.2025.10.26.03.02.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 26 Oct 2025 03:02:35 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	ziy@nvidia.com,
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
	rdunlap@infradead.org,
	clm@meta.com,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v12 mm-new 02/10] mm: thp: remove vm_flags parameter from thp_vma_allowable_order()
Date: Sun, 26 Oct 2025 18:01:51 +0800
Message-Id: <20251026100159.6103-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251026100159.6103-1-laoar.shao@gmail.com>
References: <20251026100159.6103-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3DAE0180015
X-Stat-Signature: z3k1wjr7pz3omspqt5m7jz8nix1d3cwf
X-HE-Tag: 1761472957-332185
X-HE-Meta: U2FsdGVkX1/SHvsaFo/ylEr01KCIgne9kUo1g8ANTm3K+CT0Vqk7NNdLOhy2XzQU+kwRuOevuHdtmuiNj/isHFWgyPfP19LjvmG6HFQjOi8FOR2cB8oSUF5k0r6/R92RmT0sxvPwSZzb9jt2BXM0iGnEvAAoGqg74z2lOjHwwdy9TfRr0ziiH3IW5OdexxGNQ85pnlOx7Ashor2YkCIFQ2y0ATb4OPSZ5smejuR37HHbsGPq+4CmhmX+L0yNwoGmAcpDtr6bVNuKyd0TcPrPfL+2sXgUell1FTHodkE9Lgi4+wbxFa+n+q8zFW8551rt6HMYJqBJusY5qEG5bf4bWqo8+/qUInxCnd0Ppxirg7w81gyuRGLboZ81/oHQtW/rs8zkpyCck1s2fMe6lyPkoWQ9WGxovElJHD5lz5Ztj+0hkAZWsymxPvFMTAKYS9Gyrf3xh/c8ckFXKazlR9kxd9WePSA7+yqvpT9rvkjhfmnqwYsyas4C5n7wAvfV1MKfjiYQ5wH9Zmzn7TIsYIbX0WQqb7bt/f7mwCD/cTEGCxVN+kbCuSUPDuiqZ2bI+FSTC64eyxG5S6tYZrE5x4ydrEx0LZbg2N54zPlGijXxfqUQRVOlY4DoGmfY48kknXXIwOeNtImre56PuuCGOI9JUdwriXBc5NRogTTlnXI3Zvk9pAhYHZMX3hx2tACQDKaXKYvacXoL9Pkr0lWydm3belGZd841snMYeg6gcPZHBa5pHFfj4iycEW9RQsx2CzIBedJYZhOZBwwgZjf3vqXJdkhFBCbNhBuKXW/pGxlbQwGYxB0TqFJtrT27RioL84+XiNsWc9JvIltXqVBvOf3mPhjpZw834VViTCmbF8P+Qa4yBoyFm0vMcdLEaVF2PXXy9pvb4KhbQi5+y+pi6lsGL5/Coqnf/20P+P8fRjWdpbBZzCczVTZ9wkENH+bIJxyLqtBF+gzpiM971nvLHE2
 cGNO7uia
 wBbTHBYHNypmryEkFLc/23wSWjwmkDg8HudKHgEb/IcGqVY5NpAwSjpNrJ/9+ufEKKCJmBEV/Ra2xa4TVAF6+RAGjr5GerKF9yA/Ail+dYsjKUZ5mSBO8qhsbErVZN0Kt0ERvww7E9uCN0D+BnbRAisF3fi2JwMoCykIpaTmIVybIJluC2oMfnSA4AQVyXsGHUN6Gf8RpFAeoFn5YfVfltM+nm5wutt7KpZF0OCPpiWWZRFomXWTGsOQ3geqhYLzMIr3BU/tS8GMMVeayxod7dmUkNu0ZGjEqS/l3eS5vPdoxqyrbrA3I0geSFsZVlOGZ16e9iLky8yNVSuaQxe3WkEo/5fBMWYWExq9QtKnDsiPhihaa9xPR68L+lCmnPCrghsgtLf+hCliAuQfpXqvg9z7+ysZVzzLPoVCV4XbSXaKywzk+mOrguW8R6WmWP64+ak0/GR2Q+IxKKbrD+VeE7OZSljKpDitaVDGRP4OeTNJshGlPL5mVoazWcciVkQAHs9YpiDUsxvvD1N89NNDYaR8X1Rzxrwvf9UZrLQm0rx9lrtuGNL54u0UQkk02IDjT6KJla8UglBIxcd4qdpAyVK24V7HO1O25FEum
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
 mm/khugepaged.c         | 18 +++++++++---------
 mm/memory.c             | 11 +++++------
 mm/shmem.c              |  2 +-
 6 files changed, 26 insertions(+), 28 deletions(-)

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
index 4b2773235041..f73c72d58620 100644
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
 
@@ -271,14 +271,12 @@ static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
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
@@ -292,10 +290,11 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
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
@@ -314,7 +313,7 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 			return 0;
 	}
 
-	return __thp_vma_allowable_orders(vma, vm_flags, type, orders);
+	return __thp_vma_allowable_orders(vma, type, orders);
 }
 
 struct thpsize {
@@ -334,8 +333,10 @@ struct thpsize {
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
@@ -564,7 +565,6 @@ static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 }
 
 static inline unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
-					vm_flags_t vm_flags,
 					enum tva_type type,
 					unsigned long orders)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bcbc1674f3d3..db9a2a24d58c 100644
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
index d517659d905f..d70e1d4be3f2 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -499,13 +499,13 @@ static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
 
 /* Check what orders are allowed based on the vma and collapse type */
 static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
-			vm_flags_t vm_flags, bool is_khugepaged)
+					       bool is_khugepaged)
 {
-	enum tva_type tva_flags = is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
+	enum tva_type tva_type = is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
 	unsigned long orders = is_khugepaged && vma_is_anonymous(vma) ?
 				THP_ORDERS_ALL_ANON : BIT(HPAGE_PMD_ORDER);
 
-	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
+	return thp_vma_allowable_orders(vma, tva_type, orders);
 }
 
 void khugepaged_enter_mm(struct mm_struct *mm)
@@ -520,7 +520,7 @@ void khugepaged_enter_mm(struct mm_struct *mm)
 
 void khugepaged_enter_vma(struct vm_area_struct *vma)
 {
-	if (!collapse_allowable_orders(vma, vma->vm_flags, true))
+	if (!collapse_allowable_orders(vma, TVA_KHUGEPAGED))
 		return;
 	khugepaged_enter_mm(vma->vm_mm);
 }
@@ -992,7 +992,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 	/* Always check the PMD order to ensure its not shared by another VMA */
 	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
 		return SCAN_ADDRESS_RANGE;
-	if (!thp_vma_allowable_orders(vma, vma->vm_flags, type, BIT(order)))
+	if (!thp_vma_allowable_orders(vma, type, BIT(order)))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
@@ -1508,7 +1508,7 @@ static int collapse_scan_pmd(struct mm_struct *mm,
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
 
-	enabled_orders = collapse_allowable_orders(vma, vma->vm_flags, cc->is_khugepaged);
+	enabled_orders = collapse_allowable_orders(vma, cc->is_khugepaged);
 
 	/*
 	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
@@ -1777,7 +1777,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	 * and map it by a PMD, regardless of sysfs THP settings. As such, let's
 	 * analogously elide sysfs THP settings here and force collapse.
 	 */
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
@@ -2719,7 +2719,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
 			progress++;
 			break;
 		}
-		if (!collapse_allowable_orders(vma, vma->vm_flags, true)) {
+		if (!collapse_allowable_orders(vma, true)) {
 skip:
 			progress++;
 			continue;
@@ -3025,7 +3025,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!collapse_allowable_orders(vma, vma->vm_flags, false))
+	if (!collapse_allowable_orders(vma, false))
 		return -EINVAL;
 
 	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
diff --git a/mm/memory.c b/mm/memory.c
index 618534b4963c..7b52068372d8 100644
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
 
@@ -6289,7 +6289,6 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		.gfp_mask = __get_fault_gfp_mask(vma),
 	};
 	struct mm_struct *mm = vma->vm_mm;
-	vm_flags_t vm_flags = vma->vm_flags;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	vm_fault_t ret;
@@ -6304,7 +6303,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		return VM_FAULT_OOM;
 retry_pud:
 	if (pud_none(*vmf.pud) &&
-	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PUD_ORDER)) {
+	    thp_vma_allowable_order(vma, TVA_PAGEFAULT, PUD_ORDER)) {
 		ret = create_huge_pud(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
@@ -6338,7 +6337,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		goto retry_pud;
 
 	if (pmd_none(*vmf.pmd) &&
-	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PMD_ORDER)) {
+	    thp_vma_allowable_order(vma, TVA_PAGEFAULT, PMD_ORDER)) {
 		ret = create_huge_pmd(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
diff --git a/mm/shmem.c b/mm/shmem.c
index 6580f3cd24bb..5882c37fa04e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1809,7 +1809,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
 	unsigned int global_orders;
 
-	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
+	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, shmem_huge_force)))
 		return 0;
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
-- 
2.47.3


