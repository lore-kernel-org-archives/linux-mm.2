Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B3BFCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 13:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A25678E01F7; Fri, 15 Aug 2025 09:56:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF448E0003; Fri, 15 Aug 2025 09:56:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9148D8E01F7; Fri, 15 Aug 2025 09:56:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 739C18E0003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:56:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 418B2C0185
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:56:01 +0000 (UTC)
X-FDA: 83779140522.05.3F276BB
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5E3218000F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:55:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y+9Hu25j;
	spf=pass (imf02.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755266159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QxI2HK082hr0nl7ESEup9nCbSYB+C86WtbOumtQTza0=;
	b=rWagTxZRle7d32+RalLGECs9AvTWSvxfQ0+xDycoE3bJEWWF/VjXcL8TMVnfo3AeQgnyQg
	wZykrLwDzvHsqNwrB3paED5Bn0rkBflJB1+PLzU016bxq3pYe9TQu+XvqozjXllP58Brsw
	88cu3GkXF6TVG3TX1/+pcrTxEtl0mTA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y+9Hu25j;
	spf=pass (imf02.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755266159; a=rsa-sha256;
	cv=none;
	b=wyTe3GPiKdU8Q0EgSuN2hLcGIYkBRnkvMSTJpiOEzzAS5a13PxNIZwg1htFiE+RxHtbD9L
	dDsNKm8NqVaWxQnPKE0AmQZvYtQrPcTnpFT0PdbEw9esIkvBIsDs6hPo7Jq59ae8tr3aG1
	LZ5TsubnQv/iI8N2zUu9gV6GV5RI8NM=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-70a88ddc0aeso16320106d6.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755266158; x=1755870958; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QxI2HK082hr0nl7ESEup9nCbSYB+C86WtbOumtQTza0=;
        b=Y+9Hu25j9UDZjsaJAwwDHCoKiHJadz7NhvWbB3w/AFKOtXcZWxUGYGqd9vVsQtjHUd
         6BmOeul/AESR9+RMyGzhtRgD7RiGdSyNKmFCatF4ao+hQ1T0HR8rS2DyZsFu3KzsPU+P
         GozOKrMGSuXD/kKSvcjYXZ4ZSiauRX3jCgI58KjM4B0/vx7nTBvC4PktTss6ChfnMBb+
         cZL688jjmYPvDoM1+IZqldMjkuLh8w0kKdzUUJsSgtQz/S6OxsJ3EAjCogscTzMtHndP
         8n7d8LIsBR4q9ceoC4D/kyToiUa5S+yID3zTnWdCQdMn0n23IqUtv2DH8XFDpZpah7pA
         DoJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755266158; x=1755870958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QxI2HK082hr0nl7ESEup9nCbSYB+C86WtbOumtQTza0=;
        b=t7TdYDwLqQCUCiv6SPewty1cH3l/QPDzi2MSDqWJaZ7xpJXZBh1s24O9c3EB5LTTk7
         NMGvLnrLUQgZYuUKArSMmxXiSHGIkQT7BMBjOaS9B7BaNeQ8tF55KxGDg2uR2IfYvs9p
         QpHhf1vWnjlNk/8OX6Zg7fdAcmGwC8OVxALfNozxffVtHrBAVxM2sEuGUw62x66P154C
         KcME3JhxtOvebsFYhc2NR8mFzDoelQefhkcBrKl97NE+HBGoKr9jZCB+KSA5S6GrYsUc
         rnSYk2XZi2Xh/P+bA+xs4Nh4+jQFA8+jVBFpaEnOCxSYSjrNPxxvt/ij0g9Wpyvw0Zkl
         3JtQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6NEv2gbLukDa6IPoD3b6//tdm2HqUBUUhxgghZiklEUmFIKVIWfOVaL0H12LYhgUd+bivebPktw==@kvack.org
X-Gm-Message-State: AOJu0YxNuVXyennw3Km3hA7heJGLpEFZShDYA902Q6Fq3wYV/gEVV/eE
	K3aZ/qfqb+ShYpKB4s1vQtPf1y+6rXBy39cKNcbQPf+DKgzXlWNgThQp
X-Gm-Gg: ASbGncubYpei3D5KvOLr/LC4mvXjbTgpbJp2emL3RRKt+Uc6Qi3VCeg63qzgzYkhRQp
	T93DuNsACLO/Xwji7TrQ4y5yup9znpzldMw8wv61auYuDjhHZFKF+muuFYKZWYUTVzl1/AzyLky
	EJJ3itRioebstgBuLGfb1H0FQeBhJT4l1CgO93PV7jybKSusz+AwWTfSg/49FzSzE7tEierHU8a
	G7VVekZZAswu0dGknhoV0Wvtc1RJTdq2PDL4CEJE6mcdcbhZJ38cVsnjPe8ZxWwkUZBvKQzmkd1
	EWcwgt3COO7hcNoEga/1UIwAoGICxklFELxT2rFXTzHziPzvbAn1g8EoabmKXMG/IMQqKfRubAx
	LMJ255td+4jJXlMEGjU8=
X-Google-Smtp-Source: AGHT+IHBCaFDPyBU147r0jvUsBcLUxCE+/fT36HT2b9gDmr/4eyis+eapRa6b48Qx3YPx+T7pRkFMg==
X-Received: by 2002:a05:6214:27ef:b0:705:1647:6dfa with SMTP id 6a1803df08f44-70ba7b1e930mr20556356d6.17.1755266158319;
        Fri, 15 Aug 2025 06:55:58 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:8::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70ba902f4f8sm8339556d6.8.2025.08.15.06.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 06:55:57 -0700 (PDT)
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
Subject: [PATCH v5 2/7] mm/huge_memory: convert "tva_flags" to "enum tva_type"
Date: Fri, 15 Aug 2025 14:54:54 +0100
Message-ID: <20250815135549.130506-3-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250815135549.130506-1-usamaarif642@gmail.com>
References: <20250815135549.130506-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5E3218000F
X-Stat-Signature: k1fn5mwtky45gq6brgi666icpokyrgi4
X-Rspam-User: 
X-HE-Tag: 1755266159-114025
X-HE-Meta: U2FsdGVkX18J5mnzwcoc8Ny4qJMvJ6HGnxp+pIe97dGwwgGPduvnQi+tvBps/D1VKuJuUrDTRzubNxJRsgyNutqLyAC9eylx89NTqil3SK6XyJN8xT+ilYjHZgob1XbGzZ1of2G85gJ2fBaZJjr9hmLUovI81gbz4LKNKcci3ZYXZ2yX2RmQtA2WA9vmwb2Gg20F2ghokIzK6a6Yi12LEll+on7FN03SQxwL51mBYNpGLRxUhuWsHQkMv3q7nQEKu9zBgKE/M8aLX//Dthi86NOcjl6rs1jPkdHYSeJZ2ZhyzP5BMewHi7Z5aKZTQ2CWv+amXxoha6Qqdtoyd7OTa+e1E6j8mONX/iJflzxt7xX2By3+ZdGfTNi7r3VVKXsUwt+dE8Q3BgIgvKcIEDRe1N1hyBG5Wfx9vXue3rteiJMwQrWyDpuboeXHL6g9vhdv/oCtn7jWD/Mv95zHGbR4ZlE2s4/dkFYEs8vTWKXirfTIFIHUqXE77h5x66VIwZIRQTjqv26woNh1zsjAJQ29EXaUSjoF0CY6gUFKRutyQbyECXH5IhWndjay47Id4Gdj7urTpACcClZoHI8lAXzC+v0eCct1rALQN1qz+rHec5HoRHD3aykUPyS/i0bImAyhsPvgm+6SJjU3B4erRup5gpjgiAc/Lkhj83z3hGkkKUTy3RMMSwqAUZCIBWCTzWQccfsLlxtjaoNWNmhahQjv/sgD40uP0l0gtcWsvSgDSwYVjPYMrYgb44cBsYp/mYMwyFnSow7fatJ5mjgutojXnOL1gt3mC6w3VQATdUzoUsximD+0qiN2surgnzFCClG06ThspY0uqLQ5Ff1Hm9bbdUbEI5UwOAHEazAdOhajUhq/Kz44xKpZ8f4GLpcyTTN2B+kzrkTC0MqpB3V/LCUIwLFOWhZGaoiUkAcf0/DNqGwzWY5SPEZmtR+hf0WnRP3nyJI3nOA+1Exphxtjh5v
 gisjDtjy
 wb+UQpIk/lRKKzM2Q1PRkQI54zQFwAdnweGIB4C95TmWD8LNslpMG25jXr8XUjZRjRu/mUgG9kkASknZa8jE8mknUYhZtyCbbzA5VPt2MnhO5qjDqZhcSuWeJrdlLKWdj5o/YOkfegIx/D/cJRm1h9lY1wraTVgqxShHx45NLj9CLYOBXoOCUpZBJ98pV+J2+3gwPNaULSjJaRTzHsPBzp/86jw/YcZvwONOGewcGyuzUr+UUdeKWp2vIZyQlEwrFMz1WAehN6fYE5l9pxUeursqC9OPhjUugun8F5n+H93dKNE7YQ/08FeNI+v9/9ZKz96Oz0T6xTZSAUQdZqqahCWvst5Db7xlwiHAE52US9GuFoD6UpCCed5Bl5P17oA3Pzfqf0YqMVVdqtwtuc/YjmM/UpF6+Up7yy3vPjNdNRDJEyXuReNTuPiFJStFLWILoi5z43bEF9WZl7M5LL+pGol9wKhefKJ/0u3e1Bg3R5jforKn4QCpGKr1ro84BwaY5BhEql87iQeNRNSBYXODeoXl+MBKzAz2Zi4xSNVr1iePP0qOXYhbe3f4rCu+8BwQvxCYFPLAMHeozbcCOTTz6Rvgmxvr0x5CQko4Z0HlPifR1oyPQEZt3gx3aJl7SStsiMmOKyaM4em82GtZ6JqysUFilsyiSPnJDPvHI60WAxEmLUbVLZ8JWAKtlNP3unqg4M+vTz1bAZ212y6oAx3Do2gMd8afTCJ1nr96qOmqVnoLMkB4=
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
Reviewed-by: Zi Yan <ziy@nvidia.com>
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


