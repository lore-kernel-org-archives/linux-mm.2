Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0465CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 09:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 058AD8E000D; Fri, 26 Sep 2025 05:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 008F28E0001; Fri, 26 Sep 2025 05:34:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E12F28E000D; Fri, 26 Sep 2025 05:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8FD28E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 05:34:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7111F59E26
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:34:22 +0000 (UTC)
X-FDA: 83930890764.13.CBB0C36
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 14F6E10000E
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:34:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PVMXH163;
	spf=pass (imf05.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758879260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8F1HkzqHjtZ4asrnu6+OCuquE7j2zJ/cOO3f5j6VRt0=;
	b=lmvU9a88jHqR8BmNrOt/JEiLPorjSsaR/obEwAzm86JpEKjNaZroNjjdf3yzct22FacuON
	kktcjUWvEPkpqGkJZA+1Nz8/5+/3ufPwddpMvP0F5XlQWwtuwNHz8Q5AOMoQkqAYtdB55u
	/kVkGVK2MApO9vj/tCH/i1GyqhOZECE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758879260; a=rsa-sha256;
	cv=none;
	b=xEfMrIDXhRP50qUa4hY1cEQZ5yCCRYP6nfiRLFTvT641K85SmBKSipJBS88UBsfYAa42AN
	YxanwVPuaNYEChgYGnh7m2Mzc9ftIRYZmBuoVeO1qsdTRV2ns0Nw2vG0PCYf1LJ5xhkE1S
	MtP2qo7mttlJ9cNrP6Nr6eroKIJoAII=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PVMXH163;
	spf=pass (imf05.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b523fb676efso1972402a12.3
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 02:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758879259; x=1759484059; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8F1HkzqHjtZ4asrnu6+OCuquE7j2zJ/cOO3f5j6VRt0=;
        b=PVMXH163OHftDErTtSDDxVFLXYbEFOL5gtGo+Tm048WqRWlgIfiqog7HtSxHJzkffR
         9eO1m5ds/JzfAIRKI/ZL8xtJtMffRzXdduLgrf7dpm0r8VT+fwHB0cXECRUxQnlsAfTh
         PxUh7KaXWwMBnh49epghhjvaDMMYi5/VdEzb1jFuKz6Vdpsz6qs5+YGpyMP5kowrk23t
         n9JhUM5vnoxK0IhayXFE6YFv5kL8c5qhzZuRgoB5blGDh3RSRvg/hGWGnFnR3d5jvnXy
         KvlQGsk5h58dC9qU5SffLWTAYgllUeO7mKygv860jhNZ38Z3ypDaxIsYWUeRnLWuf+kX
         TNKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758879259; x=1759484059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8F1HkzqHjtZ4asrnu6+OCuquE7j2zJ/cOO3f5j6VRt0=;
        b=b8WwHSpHx0J/R76mahHNmjf3pUobaHVumnWfJFii4DUXfE03qlo0twd2Ky5F7/SAgO
         9vTs2pysTubGXf5hj4v23GyTSjqYT6L8/pr0c/R9IYKvP8XQUYlZ9bVLIsCGbgCCMx2l
         JnAKIPgLlUh1md0eb1mFsz40Eg0PRSfbR652Gayl0/Kd3YpL+pHGo8ne/BFwAxN6EiHV
         ctVoOlBTYK+vkV2aouDEaTQqW1lQGZGUZYbV5X4vkTgMpsENgfcWHgpqy+lp2/XwyCe0
         /keMSWsAq4mxowrsGSviGI5yDtkkpdgLWTBNL9D61SdXSIl57d/awivYp9gxZm6llrgM
         fmfw==
X-Forwarded-Encrypted: i=1; AJvYcCWlYugm9vFM3mj0Tz2smYRdqF8ZTF16iX1gf4Sr1iYTN1t9Wgo3vxJ2GCvbEFAzLwX4OKyThTsESQ==@kvack.org
X-Gm-Message-State: AOJu0YwG9/hrf3V0LzPATNFrivhPo5JLofB52OCqIcQVBoSMAUUBZUF/
	8tj3pcFNTOkkX0+AA4TzgkSq8flU7uVA8v6kK+LUrUmGbdRcWTkYZm6y
X-Gm-Gg: ASbGncvJs0jHdzZLB51zbFp6XVUL5opnkpaDc/GrvPcJWoecoqaria9SIQBJ/nvK6ix
	gDKphR6Jt7EXuPD2HfL7WZTnH7Sdt8bTx7Tc3v+ZlxPkUQmHcARv4Qd2021/tAw6ZOfcYVMkTF9
	3c/lmbNGW696WDsFiZYhvn07X2bpP8CPv2hCIAgFU2XDmxdtCC4gM1Zw5x0D9X8k4HewCIPzlcH
	y3lS4t+oJayDtO8+au4Imw8PCyDbucGLT5S/00+BrhW9rCfmQtgxhKIzMNKXmTTBIF0OZwCYRVj
	DqZRh0QHGDXV5jfvNbB3Zispbw9LiWI9LAxZiC2hZsDczS1evMcYHq16PgdRLqodZXccMrRpiAN
	nF/LzEjXjQYbdhBLyxjkuqwoxC7I8hk3MBThjtzNIYLIGUZyHf57bmi5u/UZlhaLtP1zElI5G2j
	trpGOUpnqWkC6B
X-Google-Smtp-Source: AGHT+IGs2RVuLQNle2jpLDUn/dQyj5uYkBVBI0mgx8CiaNeXlryu+CMTBs4lU6XcwR9nFTCXObCvkg==
X-Received: by 2002:a17:902:cf09:b0:27e:f1d1:74e0 with SMTP id d9443c01a7336-27ef1d178a0mr18485445ad.17.1758879258795;
        Fri, 26 Sep 2025 02:34:18 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1c21:566:e1d1:c082:790c:7be6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66cda43sm49247475ad.25.2025.09.26.02.34.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Sep 2025 02:34:18 -0700 (PDT)
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
	lance.yang@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v8 mm-new 03/12] mm: thp: remove vm_flags parameter from thp_vma_allowable_order()
Date: Fri, 26 Sep 2025 17:33:34 +0800
Message-Id: <20250926093343.1000-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250926093343.1000-1-laoar.shao@gmail.com>
References: <20250926093343.1000-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 14F6E10000E
X-Stat-Signature: 5fnmsiy5baocq1nyiakgqaox4rgict9r
X-Rspam-User: 
X-HE-Tag: 1758879259-318126
X-HE-Meta: U2FsdGVkX1+WNMGujbHLxso1aGWn+d8qSwXl5bdycQ3Eu+m/6fgX5w/xtN0gEl64/Ursl/sY6w/V1DBF0qwTkLxH6BKbwaYCLZmWxvX3/enl+xfy1xu8OX1krjplh2UuT+NJgh4DGTDAIFUEQOHTDWTSeAHh36d926J6sRnwzCaQJOYZrSRRF5CQcDoH3ouX6FpiMpqNSYjBt0De4iWFucmr9R9PlTHcFtCMQRR3fCY8ict15/XBYuUah1CuxwSBgswurEkn7lH4Y2be/4RaozSqicHo/yyhvPL585HRQ7XfqmKleXOVtNYJb6XB1ewYlPIBVaDNVlIFI2IVhCBuaXbCIOcxM8RkLXHbXNSyuoY7kx8l7wYh8Ugrl4Iiokfd+qRoDK1YsH2PvIDVWEPKPwq34mihiPlZag0hJmgRK3mYS/SNtzALCN835LIOhnEGlIs7u9093tzrlbeykxUyzRNWuGLcNEg8IkRgq+ouOI1LuVNdy1KqoaAx+96sIu/WkcVJ0OSdVCH+v2BKu84j1HWAPXGVwQsPFuhUnMBzFZPbx6LWAasA4CF1z9fDiG3K3/2dpm5eeJefuTWLgUKmq0yAI10aP8TCMlEHQlCOd7exDtK7Z0pqseiXg39/oiUwt8NmKT20qLlLQQkhl0s1RnzQOPVXKJet7LO+ZmVW6JN6rjcpvbn3qti/t251FfWS45UaqIiWEbWq/1uFQbjgHGNj8V1hi5r34dDmuPI0Qcc/niOI0wokKnwUX1gpUzA0n5f7BhDdE2492z4yOwjD3b4nOxj033QCFAsM1KrOVfLiwdpZTOc7LBnVdxtIltb6l7kP7/n9UZfG18OhRRlOwHJ1N9yOyY6OCQEOcTowNsvAC48lnK7wZ+1xDI9fH6dSYmupuNr4YXWW4PFFSxloWJxDSezotBYrKcmgMH0bAYa8RjrA41/+S3Xt5teBNE3cL3yfdbRKJi8O2eeWL2R
 kI028Bur
 PQO7OGhTbcgHH1SaYrdISE0wOnUM6p/SrilqQN3IuKDcGAa2f7WGSoROJnbVE8Nlvl8Cw3NJYYl+ZN/mQnFYte3kyqXdD0o+/oM9U4AsvDNjVU1PNySQMMrNVgoYSkxfndgEb8pQ1Inf30fcHxLaUU6hB1vh45Sq+6f5akalkpnhqeLvnufLLzGSHqxSrEz1Rah01faNMBAKhAl3MqQY8DbAX+NuI4VfOEMcMtc1p9+F9mZRgJ4D6tstkKfCUEQHvbukYj+qAtdqNa+VnJaY3P6bpeAjZsoO14k7RywzVK+Dzwgw1xeKA55ln//CMjIuxoZ272qXqQPVnzXK5jxgj/sCUeoE3Kqo+/QrHk+xQkf7id1+pntaPhBZ5qlIlBMn57nYD/vkAvJlvEaYHLuwymA8cfSPI/ZHTO9w168evvFhYeoXMpcdFxjh+LVQEbiYxpX291zanW0ghYjZ/hhCXiqELPrU7/ApSWIIDMqt+uoZAS3JJaNdTBjTx8eJZBij7t8XPI1iWPT/7Y++2qybe9fJ8nwJ1JZLxlr31MVQi6m5/V9BJ5yneJIRg9pc11TBPds1SdEkroeIzG5nM7WbvRV7UVPJmGX5IXbgB
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
index 04121ae7d18d..9eeb868adcd3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -463,7 +463,7 @@ void khugepaged_enter_mm(struct mm_struct *mm)
 
 void khugepaged_enter_vma(struct vm_area_struct *vma)
 {
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, TVA_KHUGEPAGED, PMD_ORDER))
 		return;
 
 	khugepaged_enter_mm(vma->vm_mm);
@@ -915,7 +915,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 
 	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
 		return SCAN_ADDRESS_RANGE;
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, type, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
@@ -1526,7 +1526,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	 * and map it by a PMD, regardless of sysfs THP settings. As such, let's
 	 * analogously elide sysfs THP settings here and force collapse.
 	 */
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
@@ -2421,7 +2421,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
+		if (!thp_vma_allowable_order(vma, TVA_KHUGEPAGED, PMD_ORDER)) {
 skip:
 			progress++;
 			continue;
@@ -2752,7 +2752,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
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


