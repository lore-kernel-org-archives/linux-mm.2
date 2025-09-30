Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11677CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 05:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DCBD8E0016; Tue, 30 Sep 2025 01:59:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B4708E0002; Tue, 30 Sep 2025 01:59:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A3788E0016; Tue, 30 Sep 2025 01:59:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 387178E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 01:59:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA5C013B521
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:59:07 +0000 (UTC)
X-FDA: 83944863534.06.5B17C47
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id 163E4180005
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:59:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XwyMgcCa;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759211946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vy5v9XGDeS4JIoi1WBeevI4rwn9UOnGGFWMHMux6eVM=;
	b=SDffzK1PICu5rwHKFExVGk4XhPLo+zZDFrlEbGm0U44cCI3Sg+fvj+yJ1rZW3pE8nlLw3X
	vrHkSeu4R+dIFix5+edDEnIr25cSs45cmV6GdyccUG64h5dysgdxw3yYmyIJ6kHb+4qfxs
	2Q4uBCjb9E9KqTPfdTG4Bt0tKkX3ZRI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XwyMgcCa;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759211946; a=rsa-sha256;
	cv=none;
	b=vSsv44DjiKWIZoDpa+U14W9de5xgYKlpCv0iT4oxtlU447OYJ449BJz7sqaaDafMLXK7r6
	sOZ2tuna0P4AURNYhec803cPBd4d3OolAGVV9HxTaho28UK4DLyi6k+HtdEoJQJ4M10rZE
	qRvQibSpgHc8fty/emCqlkzQsRcq3vI=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b54a588ad96so4228304a12.1
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759211945; x=1759816745; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vy5v9XGDeS4JIoi1WBeevI4rwn9UOnGGFWMHMux6eVM=;
        b=XwyMgcCaEdWlBG0JF/utMu7lR/Bx9NRv/5do8BsJjCbXgZrJSlhCh/oQEyREpulNkI
         iJudzvvhcIKNB3nbpVSv5Hfh6swUhiDa+bWOo38lj77z06FynZG50rhkPGq5OkbLCeRP
         ohC6dVwNpKACNyvwXIupePid4ZWdpwLj3MEtwVZ1GSgz4H/UwNQ1ryNQ8jbNMScrXcKr
         +QDXD6y8tx/Ns+aExc4GAW+uMA8jzcq98Hp8aB0oloMj81Yy9wqYOh60DO34bmr7xbHe
         cFlrYEJY0LpVplwLwhyPpUM+5qeKCUuMcSYIfxeMenehin18YUFaOYrpse2FPUMK240g
         sQ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759211945; x=1759816745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vy5v9XGDeS4JIoi1WBeevI4rwn9UOnGGFWMHMux6eVM=;
        b=UZXiPGZWqn9PwMcyd2w6qxgOcc6TysaGwNp+FEbTSXFI348mLc7mgKptAkMwQsZhkW
         BILRtPHtkABtC9BfmzjcygU07OzE6u2sDmp2LhhZpsrIyooisBOTVSCfOd2U29C5FKDB
         poTL9EFeOgXU/RUTX5StBtl+5MlyBsaSPh43pFJOXhv2CXSlPfYal1tr0UDOaf0pSlyz
         ZyfukFE37O2qQ3BU9ug70mWNFOfppXCn6flqwtAXRSU4Dh6Zdb6SH7dDYdqR9+7oc/8n
         f+CccxSPOJqB/1gUwI1TvIpnpdKMinBM6PKS8KHZ4VAjZuZfvhwY0U/cS++MZ4EzejCT
         FxSA==
X-Forwarded-Encrypted: i=1; AJvYcCVdzBkZYOE8vb3QayDbFS9l2R6og2ocNcDYMmq+mym5OnfcNv/ozxZPtmKi4ECNKfEBEvWxHzcbdA==@kvack.org
X-Gm-Message-State: AOJu0YxNGbVKX5Da0GBhqmc+D4EUFjevINfCJzHcqPrSbpNNBNEmR7Ap
	RPFS4P0EcvuwWVavWFGcw3tAG+vIazD6Y51/x38EBJcU4b606xkGaU8x
X-Gm-Gg: ASbGncs6vwjPCTXmuFM3decaKlBKOI7tqFja9cYFHI33FrhSoQNvGz5sOT3M/OcSqAo
	r7twJ2dIFhmwCFD9pzCkoTo/5treXabwFfc71/Pg77GsKfe33Tr4nTEnvZqWDFZSPp7KYLTBCcT
	cRoVwodsqnvGeamdMmnvLKZOiwlMdE4/hlIRZ3rm/sfLrafJyxsiuv3heK/MVK0apDippMlYeaX
	u7DTQecV+9OsAt4a3bDGQZsjv3gs9WleYXjDpYv9+fuPB9qKJVlkxmQe77/HqK+AR8QbIx0mw1/
	29b98as8+evsui3XgoV8tVqhP2GQ232q07HSFtfFDRGCmefEv1MAhIuNPoWXcyGJVTXAn3AK2GG
	3kx2XeXrqvdsO740dsx8Ke/nax2M8rw4z3SDKEzod8GpEvO8z1uwHXKAUw0aWtsj4mpQBZRp53e
	4INJVv6+ArpMY0CBISieGMZejMzbg=
X-Google-Smtp-Source: AGHT+IHiNqaI5HcMCjNBXCMCb69rPSRlL4lp8kiQPTncjuapEf6Dsp0eKT1UMyUgAU1qyrFaGosstA==
X-Received: by 2002:a17:902:ce04:b0:26c:4280:4860 with SMTP id d9443c01a7336-28d16d92d9cmr37310415ad.8.1759211944857;
        Mon, 29 Sep 2025 22:59:04 -0700 (PDT)
Received: from localhost.localdomain ([61.171.228.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66d43b8sm148834065ad.9.2025.09.29.22.58.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 22:59:04 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
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
Subject: [PATCH v9 mm-new 02/11] mm: thp: remove vm_flags parameter from thp_vma_allowable_order()
Date: Tue, 30 Sep 2025 13:58:17 +0800
Message-Id: <20250930055826.9810-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250930055826.9810-1-laoar.shao@gmail.com>
References: <20250930055826.9810-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 163E4180005
X-Stat-Signature: sct8ee19npadedc1uibhuauxraox87f3
X-HE-Tag: 1759211945-174039
X-HE-Meta: U2FsdGVkX19qef77DWtTUx/xpKhX0iVFmyox/Ct8Xw7bviAGOHrQF21duSP6BB833ClaQeKxPhrfoVrNR8+M0HwZlp+HWVCDIyzoKO57Aa3dW+VcfKWIpAXMAa80la9dd1BUyAay1jNfYDMoZ8q6foU1Drenlw4GP/PLipA+JnaXTDui1on0z/hxC+9bJMR1PRMlDb/3zsuBptc6V9RR4b0/BojI2AitgpZkVdDjI/7dEQ7kWWoo9PMcNBGnbofURkhDpHzbkTQ/gMDzAXJBLVFVHpTt3m/8NRnFpYnwmgAWx3w8AeKarXtbfHn0xxKYnYnCicDzZjcLRX2NESVt1YqvUCopB9jDTxuERgtPooE+5apkXTbLkWKsE+29nt5q9CJYR8WYZ/4NPLTBhgpJQdx9GgUq8IodvkpMbhHSppp7+vJalk/netT5yKLYj8v27CMJfyjcE9G/MZ5IJRH9CSohm+T7WAJk8zQqQTX7o5s+dAjeyTDwB2IUZ/lXGW3ttIEMtTwVX9RBybP6YVggE+uQehtaVZKYvf/N5uYonEoivkpkdjEriz90V9DtYoKOb3dg8ChKq1lJny3zFruhu8zBrFH7xsdi7KxvRzl05Qtr+mG5qT3ehqoWnR0B+HepC+hqSv03wg7LBm3sjXu1BdYl8YdNsLwMCeW21AevjxOfdCY8Y+gHlsFkRbkadwhzT6qX1ke0Rt+vquWG54mR1A9uAvA32dH2RiFfxm5QEenmQ229PqE6AdKVsNluI+yafDeGEOwg7IGKGIAGz4P/UoQjpXf8oHpf2xNrdjcOhjrfaK0J4bjxLtGiRfr7TEG/KlcNgMPy2AgT9igCwUI6RmQo9/H/R/yRrhfRz7vrokucaYO9No8tOAl2+6rAnj39xAqxFP6wRcbVgiPkfLppzEWYQjk3dtVueIHBIoox92OGdJBHOp050ayijx47akOc9fDXKHaPA1zHLdmvSHK
 AWKqW+V/
 PbkVdLySYAM/d6H6+v6Xbd2pORm1V167uXyAM+PVXo46mJ0T8wz8QypIjbTBQQ86CzhLD9RlD3hP19FArJlkYsinmjGvY0Z3K+8wEJl+qIZ6Fgzt9zZPWsSdj6apn9hdf/wepOeiRn2ELOSQjMJsGmooSz7Q4OylmOgPvCfMYcjVSX1iS3SIy8gZK4kikUSn7EhedNQq+54sOf+7JnUDK81lzgDVctU+8Nu5evytwktHGBV+ECK9RFsNFLA==
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
index f327d62fc985..a635dcbb2b99 100644
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
@@ -560,7 +561,6 @@ static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 }
 
 static inline unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
-					vm_flags_t vm_flags,
 					enum tva_type type,
 					unsigned long orders)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ac6601f30e65..1ac476fe6dc5 100644
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
index 5088eedafc35..b60f1856714a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -466,7 +466,7 @@ void khugepaged_enter_mm(struct mm_struct *mm)
 
 void khugepaged_enter_vma(struct vm_area_struct *vma)
 {
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, TVA_KHUGEPAGED, PMD_ORDER))
 		return;
 	khugepaged_enter_mm(vma->vm_mm);
 }
@@ -917,7 +917,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 
 	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
 		return SCAN_ADDRESS_RANGE;
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, type, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
@@ -1531,7 +1531,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	 * and map it by a PMD, regardless of sysfs THP settings. As such, let's
 	 * analogously elide sysfs THP settings here and force collapse.
 	 */
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
@@ -2426,7 +2426,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
+		if (!thp_vma_allowable_order(vma, TVA_KHUGEPAGED, PMD_ORDER)) {
 skip:
 			progress++;
 			continue;
@@ -2757,7 +2757,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return -EINVAL;
 
 	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
diff --git a/mm/memory.c b/mm/memory.c
index 7e32eb79ba99..cd04e4894725 100644
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
index 4855eee22731..cc2c90656b66 100644
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


