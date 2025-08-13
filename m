Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CCCDCA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28AAF900089; Wed, 13 Aug 2025 09:57:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2168B900088; Wed, 13 Aug 2025 09:57:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0F18900089; Wed, 13 Aug 2025 09:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C62C9900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:57:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F03CC03B1
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:57:33 +0000 (UTC)
X-FDA: 83771886786.19.E92E80D
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5DEB540008
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:57:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="GoC6SNZ/";
	spf=pass (imf07.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755093451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3kqCfvmoITnU4TaO9geqjU+Qj9ga3dgKWCs8tCFtXqw=;
	b=soWCzIjIxJBjOTTdyybxIxb7fSqtrBYcY3HJAHpdKzB6DZjlmf6iPs7R9q3ZgRi7t4ulEC
	2knjcE88aJk8h20v98avbc/YKvZIqunSeiUxNvphwk55a40Ga7M5eSYnrWtHGhz4gKgocj
	/rm+JE9NfUpvboQBRSJIPNwn795W8pI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755093451; a=rsa-sha256;
	cv=none;
	b=Q0Saj51/Rss3Rn69yk1fRcnwZEZeowygA1n1aQJpW+Yf0sdNxjPLK1fMezVNhX8QB5hWFu
	pxkbE/jFawKRhZXzZN5smVlVZT061koaGiuXrNfGJsEZpWkdEKAYF+EpTgWOs/IqDmXNs7
	bhgS/PiLhKirZ7qLIXkNLpcDkGt1F44=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="GoC6SNZ/";
	spf=pass (imf07.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b0a13bb0b7so76956521cf.2
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755093450; x=1755698250; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3kqCfvmoITnU4TaO9geqjU+Qj9ga3dgKWCs8tCFtXqw=;
        b=GoC6SNZ/9GANYoflqpQOKe7PnTpzt2ioePYo9jgafVZ8DnR2Kk7/ifR47RSgHSLHBf
         b+Y8Ye/mqAvxENTt5hca7bVj47S4PNpvfwTqo14y4wdjesK3aXPZndNwwXF+gvZkEsOS
         5kgPkz8KsJYV1tM0ckrMbVLtGg6WqfNlvRikiTPP0c4htRGXNAjKWKwRCnxCfsoEy7m+
         zkvUH6/mFF9dCn6+p+dl9TEQB9GtWd99EkOal/gX/ROW20SsR+xtbl4EuOVnXA56NO+y
         eqMhL0bk6GxrA01GEzQ1Q+Ba7QkRR2FCJyMIPJSZNEMUcEKpC52D8GX6SA3BorQO0UGY
         i20A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755093450; x=1755698250;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3kqCfvmoITnU4TaO9geqjU+Qj9ga3dgKWCs8tCFtXqw=;
        b=lKEg+cv4fjqe283h66ya1E+Ic+sD8O2/rpXoSDes5MCfbG27d50x+3UtrLMfXxe99a
         V48KGvzpY6W5Bz+dCXmq3GtjqPCMXOzRLet0WqH4bUg/CMEaFEJ+50teST5peu7F4UB4
         1NTa/QErI6wtzGu6We+FQILdm85J5XwTVJ6/126O0Ntqo+dz3Wzw6+OW2w8qgH8enQmK
         jnhMZqLoxnXL2LQtsxu4tviKhwy+FCdV+cPmKAERjexClOSJUmmMiYbNJQnYtY+bMP7X
         2co9FE3BRCk57UMBIQrykRBKKMg09n9e7QucKIgYqW2qCi5+6FVRxi3TCm0Nr65qFFtG
         CrPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjRp6/OeDi2nCy9mPu/PAIrPM5RKKQK6T80Ghu/VVWRvrXl22SL34erQg0jWU9PMcVjmm0FM5V/w==@kvack.org
X-Gm-Message-State: AOJu0YwF4ntsgMI7vg+ycgyuQ1JxHACJEl+1nUJwaMWZBe2Ou2TZexxt
	6eZBa1pVKR87X0PM3Q4eiDOA2IVVakbl91va6MdwdWe8/TmOrDWx53yX
X-Gm-Gg: ASbGncvcJvwRJDzfrhoVJSuMX4tAr8ic/OF55F7jGtKM641yvCsAYjRqRH+7pSfBrMi
	6xHma1vUNRNTIe9FtutI/zKNQ1BSgUE7I5OdIuE+HJIyG9c7dV1apzoqc+aqWB+m1Ju2jMjlCpm
	p93rNZl4eLH3SDsz0MMvFJxIJKFM9VNf+gmhEBYAt2ZaN6/Ab+UpWHJFoOtdZW6R9JWPIKbtlnD
	lqmL1UYxzVanPq9zkLuhWUAJBeg1of/kebJEvlgWYGNsGiGFmwTU9naGtKjn1Zepqxlkrma4fsv
	r5aqs9a/wgKWU5KQMbZFZLdZ+Yckh8iKgIKH+3cGYJqzmJA0XBcBW+GblaPQkPiIMOAUnUcYSau
	x8OXlyE45dkF3tEUBcYOH
X-Google-Smtp-Source: AGHT+IGxTRrNBzbf3/rNk5hF1EnPo8VqlBkLyeEkWuG3aLZikyxze650n4Zvd5NcLHqPHT5dSzvaFw==
X-Received: by 2002:a05:622a:1985:b0:4b0:8392:80e0 with SMTP id d75a77b69052e-4b0fc896cf3mr40720351cf.48.1755093450303;
        Wed, 13 Aug 2025 06:57:30 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:70::])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4afb76dcadfsm149895151cf.19.2025.08.13.06.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 06:57:29 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com,
	linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	corbet@lwn.net,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	ziy@nvidia.com,
	laoar.shao@gmail.com,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>,
	sj@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v4 2/7] mm/huge_memory: convert "tva_flags" to "enum tva_type"
Date: Wed, 13 Aug 2025 14:55:37 +0100
Message-ID: <20250813135642.1986480-3-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250813135642.1986480-1-usamaarif642@gmail.com>
References: <20250813135642.1986480-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5DEB540008
X-Stat-Signature: p3e73gwf6ax5b5i9ayizxstumchxdcs1
X-HE-Tag: 1755093451-578572
X-HE-Meta: U2FsdGVkX1/7PW2IrlcrjxY/KEeOug1366zeoHVKKINRMbrC31e6cdu0e52Y8F6wqJRx5xATCYx9mjhkXhH6MWw2mNNCA07wt/Sl8QO52uUn84uovrgwCd+6ZVuWwy1/uU4+E0LoaYS1/OMdffur8MrvPev/sQKunJIWrPrSqNuvtqW58fr0LQ7d2GzhI/oPjf/rdW8WSxoR9/9v3dYqKA2AL8lafdGF6VPZfMAYOJtx3p/uvuhSiBX07Z7IF5CbNGkvk/olY0oTVn5GwHgNsDn+UJk8dlrbJvDBUwOCF5Bf43asf0Dtek7uxh8O0gvZvH+IcUfV+np1ambee/RAzHeKu6rZSULbC2wJ4nxOWMYyKd4Bo8LwScaIuG1JCcVpcgX2NO/+gzx2JyHOHPqtJCMutKv3aGXQVp3BjFogXgcKr3dS7+ZkxBrt0U/oCMOd9SZTZQissrr83u1oT6cCGQEn2vqarc6C/qc4zKMTmyI1O2f3FA7lRwyZT1/J1VXCvd70IX84LJAd5poHco/XsUfpFiC+rXANEwqOpBhQYLcn9GcswSbEmlZ2GuVcU54I499FRtrGsL4hxtMpJ9ayUg+CamvSjotkXxXOyz9DarcQFa5fwm+49sN1fLDmulimNXtvrcJrOFbS9KLZlNRKF02FjZfTma27z+P8CeoRBx7jkJ4D0DlSrZjlZJkGrfry//nVMoAauMUj7B+xkC0ph29DJ2hoaKVRK88kw8H7LSZwx+/1VbMgd2vdTmQ1gWKWouhT3wpfy+OeoSeJeDTu4yHLARNvRsbzEUzlQmReH/Az+oUpjfNgANbZZIMQjRQxXn+/Z6hz7cld/EEix3J+/1Y/f0KDHiYp+7tchKLZzC7kYFH/3ew/4Z7ZKnAciCGNByQH77qYRBRiN5fCZmAU+8j1g63YoawUHwOMu5h+Xtc01PVyhn4y+pQEQ+z0MSN2iq+LFaziY5LbB3fsQbQ
 PoGG+Vq6
 ax45VfOBpUsAX8ztc1ZPzXd7U7cyfa0ExM9swz6FUhUmvJh9zuJB5G1u9AKoatHqGA2lKcins5SQrJNdgh4qYN4NKcVNwMZ2SNzMmUPu/6NWjZlS5AotzUxPXos5pJn5FCoftHnWajv5vj08H+JD1Qvsx9S2YDm6qNLgKrIiaAweHtA5mG2eLztab22QUjqYW3vyWgCl/h6kmfMlFO9aGbABss1htQEqoN4NCOrsA4xyBF6643HZg2qoiTPa6yzDIANYXg0fyYpiEEPagtuexrUiih0Vn6uruLcl0HNJBUVqKGA7CZy5exlRNRQQZwb3v0cugMZLcFFG37Q1f76ye0TBD6uh+a10zV6nX8Wxg5ojM9Jy2bhuINun+MPHTkRwvxP+NKZ/gHX6+cyWgWkx+oRseTcJESPKVyEo/9KoQyGSOE9+hEpLgLgfWbXhEmIuNoXtHmKSrf1VdQ89W1EMVARVK80PavhLdmErjzokpnjimsxoy/O8MJDN/tZq2BcaTjZjbY2ZLJzZt3cAes4smkbcS/EUK7lJkPzm7ypixdSfycY+HHzPLQ3gEZf5CPYzmnXnxBkHbCDLrHo/yyClUJtm5jaiaLR4Z7e2/heAIM4x8LwQjSZpSnEJcN2eBPpxb5uI2WROoeba4MuPudhsEUK1gIOeF7at9n2tR7/PZPwryhZSx6V0Chbzra6tYSGRzxuXdX3SRE9WIwCckD03Shk0zPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Hildenbrand <david@redhat.com>

When determining which THP orders are eligible for a VMA mapping,
we have previously specified tva_flags, however it turns out it is
really not necessary to treat these as flags.

Rather, we distinguish between distinct modes.

The only case where we previously combined flags was with
TVA_ENFORCE_SYSFS, but we can avoid this by observing that this
is the default, except for MADV_COLLAPSE or an edge cases in
collapse_pte_mapped_thp() and hugepage_vma_revalidate(), and
adding a mode specifically for this case - TVA_FORCED_COLLAPSE.

We have:
* smaps handling for showing "THPeligible"
* Pagefault handling
* khugepaged handling
* Forced collapse handling: primarily MADV_COLLAPSE, but also for
  an edge case in collapse_pte_mapped_thp()

Disregarding the edge cases, we only want to ignore sysfs settings only
when we are forcing a collapse through MADV_COLLAPSE, otherwise we
want to enforce it, hence this patch does the following flag to enum
conversions:

* TVA_SMAPS | TVA_ENFORCE_SYSFS -> TVA_SMAPS
* TVA_IN_PF | TVA_ENFORCE_SYSFS -> TVA_PAGEFAULT
* TVA_ENFORCE_SYSFS             -> TVA_KHUGEPAGED
* 0                             -> TVA_FORCED_COLLAPSE

With this change, we immediately know if we are in the forced collapse
case, which will be valuable next.

Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 fs/proc/task_mmu.c      |  4 ++--
 include/linux/huge_mm.h | 30 ++++++++++++++++++------------
 mm/huge_memory.c        |  8 ++++----
 mm/khugepaged.c         | 17 ++++++++---------
 mm/memory.c             | 14 ++++++--------
 5 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e8e7bef345313..ced01cf3c5ab3 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1369,8 +1369,8 @@ static int show_smap(struct seq_file *m, void *v)
 	__show_smap(m, &mss, false);
 
 	seq_printf(m, "THPeligible:    %8u\n",
-		   !!thp_vma_allowable_orders(vma, vma->vm_flags,
-			   TVA_SMAPS | TVA_ENFORCE_SYSFS, THP_ORDERS_ALL));
+		   !!thp_vma_allowable_orders(vma, vma->vm_flags, TVA_SMAPS,
+					      THP_ORDERS_ALL));
 
 	if (arch_pkeys_enabled())
 		seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 22b8b067b295e..92ea0b9771fae 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -94,12 +94,15 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
 #define THP_ORDERS_ALL	\
 	(THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_SPECIAL | THP_ORDERS_ALL_FILE_DEFAULT)
 
-#define TVA_SMAPS		(1 << 0)	/* Will be used for procfs */
-#define TVA_IN_PF		(1 << 1)	/* Page fault handler */
-#define TVA_ENFORCE_SYSFS	(1 << 2)	/* Obey sysfs configuration */
+enum tva_type {
+	TVA_SMAPS,		/* Exposing "THPeligible:" in smaps. */
+	TVA_PAGEFAULT,		/* Serving a page fault. */
+	TVA_KHUGEPAGED,		/* Khugepaged collapse. */
+	TVA_FORCED_COLLAPSE,	/* Forced collapse (e.g. MADV_COLLAPSE). */
+};
 
-#define thp_vma_allowable_order(vma, vm_flags, tva_flags, order) \
-	(!!thp_vma_allowable_orders(vma, vm_flags, tva_flags, BIT(order)))
+#define thp_vma_allowable_order(vma, vm_flags, type, order) \
+	(!!thp_vma_allowable_orders(vma, vm_flags, type, BIT(order)))
 
 #define split_folio(f) split_folio_to_list(f, NULL)
 
@@ -264,14 +267,14 @@ static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 vm_flags_t vm_flags,
-					 unsigned long tva_flags,
+					 enum tva_type type,
 					 unsigned long orders);
 
 /**
  * thp_vma_allowable_orders - determine hugepage orders that are allowed for vma
  * @vma:  the vm area to check
  * @vm_flags: use these vm_flags instead of vma->vm_flags
- * @tva_flags: Which TVA flags to honour
+ * @type: TVA type
  * @orders: bitfield of all orders to consider
  *
  * Calculates the intersection of the requested hugepage orders and the allowed
@@ -285,11 +288,14 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 static inline
 unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 				       vm_flags_t vm_flags,
-				       unsigned long tva_flags,
+				       enum tva_type type,
 				       unsigned long orders)
 {
-	/* Optimization to check if required orders are enabled early. */
-	if ((tva_flags & TVA_ENFORCE_SYSFS) && vma_is_anonymous(vma)) {
+	/*
+	 * Optimization to check if required orders are enabled early. Only
+	 * forced collapse ignores sysfs configs.
+	 */
+	if (type != TVA_FORCED_COLLAPSE && vma_is_anonymous(vma)) {
 		unsigned long mask = READ_ONCE(huge_anon_orders_always);
 
 		if (vm_flags & VM_HUGEPAGE)
@@ -303,7 +309,7 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 			return 0;
 	}
 
-	return __thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
+	return __thp_vma_allowable_orders(vma, vm_flags, type, orders);
 }
 
 struct thpsize {
@@ -547,7 +553,7 @@ static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 
 static inline unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 					vm_flags_t vm_flags,
-					unsigned long tva_flags,
+					enum tva_type type,
 					unsigned long orders)
 {
 	return 0;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6df1ed0cef5cf..9c716be949cbf 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -99,12 +99,12 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 
 unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 vm_flags_t vm_flags,
-					 unsigned long tva_flags,
+					 enum tva_type type,
 					 unsigned long orders)
 {
-	bool smaps = tva_flags & TVA_SMAPS;
-	bool in_pf = tva_flags & TVA_IN_PF;
-	bool enforce_sysfs = tva_flags & TVA_ENFORCE_SYSFS;
+	const bool smaps = type == TVA_SMAPS;
+	const bool in_pf = type == TVA_PAGEFAULT;
+	const bool enforce_sysfs = type != TVA_FORCED_COLLAPSE;
 	unsigned long supported_orders;
 
 	/* Check the intersection of requested and supported orders. */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1a416b8659972..d3d4f116e14b6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -474,8 +474,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
 	    hugepage_pmd_enabled()) {
-		if (thp_vma_allowable_order(vma, vm_flags, TVA_ENFORCE_SYSFS,
-					    PMD_ORDER))
+		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -921,7 +920,8 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 				   struct collapse_control *cc)
 {
 	struct vm_area_struct *vma;
-	unsigned long tva_flags = cc->is_khugepaged ? TVA_ENFORCE_SYSFS : 0;
+	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
+				 TVA_FORCED_COLLAPSE;
 
 	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
@@ -932,7 +932,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 
 	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
 		return SCAN_ADDRESS_RANGE;
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, tva_flags, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
@@ -1533,9 +1533,9 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	 * in the page cache with a single hugepage. If a mm were to fault-in
 	 * this memory (mapped by a suitably aligned VMA), we'd get the hugepage
 	 * and map it by a PMD, regardless of sysfs THP settings. As such, let's
-	 * analogously elide sysfs THP settings here.
+	 * analogously elide sysfs THP settings here and force collapse.
 	 */
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, 0, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
@@ -2432,8 +2432,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags,
-					TVA_ENFORCE_SYSFS, PMD_ORDER)) {
+		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
 skip:
 			progress++;
 			continue;
@@ -2767,7 +2766,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, 0, PMD_ORDER))
+	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return -EINVAL;
 
 	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
diff --git a/mm/memory.c b/mm/memory.c
index 002c28795d8b7..7b1e8f137fa3f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4515,8 +4515,8 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
 	 * and suitable for swapping THP.
 	 */
-	orders = thp_vma_allowable_orders(vma, vma->vm_flags,
-			TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(PMD_ORDER) - 1);
+	orders = thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEFAULT,
+					  BIT(PMD_ORDER) - 1);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 	orders = thp_swap_suitable_orders(swp_offset(entry),
 					  vmf->address, orders);
@@ -5063,8 +5063,8 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	 * for this vma. Then filter out the orders that can't be allocated over
 	 * the faulting address and still be fully contained in the vma.
 	 */
-	orders = thp_vma_allowable_orders(vma, vma->vm_flags,
-			TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(PMD_ORDER) - 1);
+	orders = thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEFAULT,
+					  BIT(PMD_ORDER) - 1);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 
 	if (!orders)
@@ -6254,8 +6254,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		return VM_FAULT_OOM;
 retry_pud:
 	if (pud_none(*vmf.pud) &&
-	    thp_vma_allowable_order(vma, vm_flags,
-				TVA_IN_PF | TVA_ENFORCE_SYSFS, PUD_ORDER)) {
+	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PUD_ORDER)) {
 		ret = create_huge_pud(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
@@ -6289,8 +6288,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		goto retry_pud;
 
 	if (pmd_none(*vmf.pmd) &&
-	    thp_vma_allowable_order(vma, vm_flags,
-				TVA_IN_PF | TVA_ENFORCE_SYSFS, PMD_ORDER)) {
+	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PMD_ORDER)) {
 		ret = create_huge_pmd(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
-- 
2.47.3


