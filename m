Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D7C4CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 12:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A3C68E0014; Tue,  7 Oct 2025 08:20:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72DD18E0005; Tue,  7 Oct 2025 08:20:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6268E0014; Tue,  7 Oct 2025 08:20:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3FAD08E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:20:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1AF7B160152
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:48 +0000 (UTC)
X-FDA: 83971226976.26.710C417
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id 27A6640017
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WxkEkje1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759839646; a=rsa-sha256;
	cv=none;
	b=uahLWA/yxspNDFfwJwcyf5/Oc6rMsTMUerYtpwxD7/VmzEmnJZPI8GUqVjts/uRBK+D4iY
	LOSF5fCYr7SeWUB7+XUKqgyNY59mojZ2WgyySzQlw89cu6NnfL32vRgbRf2suehSpvb2Yv
	nYfjX4Ogcupjq9CdRk/g5cHvfVijpqM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WxkEkje1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759839646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0yCAVXUd+Xggdo34An12Zy3AWPX111PHofILGlMoG8c=;
	b=Mj8smFLqRr1+S00hGUVfw2keyiv6eIKLDyAnYHYs08KY3zKG61ClBF1Gg9uChSiAgyGCgs
	Ebi56WZHmj0fzmQTH5q9kIrnTrlPo3xSObACTlb3efnxf2c6KQQXY8JVfibQVQNvPvqfqz
	uqVpFtYWprMYxa/+Ymd4DyiXm4cGE4M=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-57b8fc6097fso8183357e87.1
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 05:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759839644; x=1760444444; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0yCAVXUd+Xggdo34An12Zy3AWPX111PHofILGlMoG8c=;
        b=WxkEkje1PguMOfAzgKn2qZUbRguISlQM+wL4jKeBmRoc0sRo90BtUQGL2gGqivYQVq
         E+tX+Q0iQ2VmmvxPH3C3yd25LGDuwVippR1Mc6kp6H0rWIFLi0SUPLM++L+Qi16b4pCy
         t2uIzghnbTayCiVuLcwtwMXk/dh3a7fMabrMoM0jgPojL8gn7n+aX8d3FKlPfSDUUT0E
         RCaGE8cy5KO3qG4WrScAEckaHJOxmchCVUQ9b5olfVOwxkn0jrG2WI9r8UzuwficmdGB
         BqlMMFgZk9axgXhabg54kO95m2k/CalMAmN85ouFhxS+cU8XcGfwWX8ZHIDaxmJYE+13
         Iajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759839644; x=1760444444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0yCAVXUd+Xggdo34An12Zy3AWPX111PHofILGlMoG8c=;
        b=b5jC1eaGhU4JID5wKo/3oE1BesxKlpAV7Zrya8UfwqAkuf4D/M0htpRPaEYU4Jxmll
         pvLN9Oz67uCX25dLJQZrGxu+8vhWquHKnlNNGZzdlHaLCOkr71b13zQESF1BYpH8JjTE
         aM6NsYix8Au9rBhLnFSUyLax9iJBNUuGNQ5ad3qmWQqernlaprQ5n9H+3Naqg7DSZyLm
         K2osJkIlFBlIeYL2bDz0i4VQqmaq3UC8Gm9YK3cGM98N7fzoSaFlki2J5Xn3CwSqeJCf
         06U3C2BZ9HAXFkW9D29/JD5YNV1q3xk+gKDeCffHPS0u4vDumqE9EThoORdXp+GxBYy0
         oHDQ==
X-Gm-Message-State: AOJu0Yzj+Osr8LD2F6/HwsNhLLyl8s6geIm+KODi+vkJmB6j5jtGwcVz
	+cysJN0BBk0ASJVb103J9ZsOgpP9hU9JDASSJQMCRK9HTtFEBy0COgt95/IUywW7
X-Gm-Gg: ASbGncvkZRtgT9SZ3nz1EN0fbORAihjy08/yglgd8ZI0Hark9sQ29XCZNNVcLS7mPUb
	AhKNh3th0AIQOk/pk7mz0votF5E6f1+P29Pt8GbNaXa3Pf1uWaijng6SrDqEoOUFgQ0wENfvs63
	sOJQdy5EcWpZMr9NlIwPkm4inPwBZq9b1bozwSpOi54ep2+jeGHlPpN9efcBJtNqGVZX7fX/a8C
	WhB2F6r1x1dZX/96eyz0SuBIEcu4IosNPuRp33rxlr7MmEXN5qc9aQ7w8lFfngZWvEtrflOH5UZ
	ok7vSTCBaO6+UuSzgUalGWHfqis1X81AqAoRA6FBLbLygKUCj6Qf/E0qU5TYFQ3lxN5FJZrH6vd
	t6AVvGwec1Zqal6NUgCOXWVjnYKnUQoVKqBvod352
X-Google-Smtp-Source: AGHT+IHVrpI0gb3Ds4p1Dqen/CPZgYTHQ0n/2z/TsuCGFbcUs5DU+g0Ae0H7GTXue/O7cP3eNfdbhg==
X-Received: by 2002:a05:6512:12c2:b0:57e:3217:61db with SMTP id 2adb3069b0e04-58cb96629e2mr4506999e87.1.1759839644325;
        Tue, 07 Oct 2025 05:20:44 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b01141151sm6061947e87.59.2025.10.07.05.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 05:20:43 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v4 05/10] mm/vmalloc: Handle non-blocking GFP in __vmalloc_area_node()
Date: Tue,  7 Oct 2025 14:20:30 +0200
Message-ID: <20251007122035.56347-6-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251007122035.56347-1-urezki@gmail.com>
References: <20251007122035.56347-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fubenbc6anuda8nu38e74zndu3ucb7zg
X-Rspamd-Queue-Id: 27A6640017
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759839645-76116
X-HE-Meta: U2FsdGVkX18Ig8z+V7LH2gYTYZYjxdF7UFK9y7A76sGF1XjiKrS/Onh+VXQSrG64mL//bRGvLQ0tzNANiOxAdlx68AyVTt/5ohfEIpzmW7dpWHrjk9DjgVA/yJUKaTOKwpFNvKBMW7PlMrzO8XzeQ+sFYtzXyh1B73I8R+UkzYvVlkIzruo+1ekUGodeP6pvJBnA65aKF791d2LK7WufIeTF/cjYc1iN0iquKo69e1RBRghAlTJDO0LyVu/g7dUq5pzsmtYquAL8+mIMTgl3/oSWM3kMiQnnY2joEYx/TjSc4xTu7fopMzRCsoUnJqRHILrUkxZtOUr/ZhMbI8t2ueZTGcbjmrGRb4BImWuFwN2UqRF+BSVyE//FKf2rlOghFt+32JwqLzKp8ihCpG55gptkoj57Z6cb3Sc6jmvKqqlIOvi6WVtOlNcGLlwDJJ4hjuUB74gb4W8r00ECXcSFp4ndXJbT47mM7Mxpnr9WxqZYYMYpN/kPWHQj1aiqKRGLgMOrkZ+q+md3Fr4VfbyWKyQYl21hjgdo5JgOnWj1lsPgfpPr4BNPlIJZauWICYdzU1BrCUNbWrB6ibVYV1NGrXZz+9wpUaPB1Alt9AcvnWy/5He77fkZgoz+ALfAT7QbPGEuF/IdlbRFgD8guKiZo6rItUDgDY/8FUmCB89VFwiWHjObxrbwV2eR2iLagKJdiCqZMHlRBDM/0qo4aDhnWSUXDYV9OoCsrIVF3mQ1a1o/V9wePmHbV68rUEzB3HLXd4BVqjimDL5ZfOV9HqoKmLQYeUmbH2DzpUy8xWFa77UZaZGKXrQ4h8m2efDi/GjNnFKgkeSTbF7INxnltW1DtdyyKBrPUgmHU6F0NUVA5T0nLUWz5Nsq/m9fx0aBh1SJ7KBNngwcd2+/xu4UEHqHC1F40/7WZZCdo9/JmpHLKz8jB7WNc7zmPi+MRTe/T3cRAQ7MyRq55Hl9TILreFG
 ortFcdp8
 D0Y1Pie1/9o8Ux0Lx+lxYNkY61J2kRkI80CpVxuGJiwbRs7iQ5iYymKYQGpAX1f18fzinBocvcfZScv4p0AVg/eKg1OVh1EFwE09QnBkEAvBDxoTsTDX25LUWjzIigVKNU+V5uNre+3EZPeqA0zVKSybthkjJmA+9CpheP+/t8MaD7IxjejV4Uh4Z1jQXFEgSVtAv/CjaayrFIFsRude2iOZ0SMQt/QGXOyypd6zlr1AoHARZNo5a5lJL2X8gKhlTHCzxuw6cQgnsYh+zxGs53j0qbXpfmYFloPu9jcu58TWQ0NWFWC6VuSUXE9FwYVMVcdLJ2M2gZQnaNVoJ0wos5IBq5zZ1woKG3bjXIAxPVZvPt6za6nBzmLPXFmBWe5te/NimtrJYkO6SG8qZiBexBOCDmWtB39G/x0H7WtNgRHyydoZ2L6QHmSK9jeN3/qkaFHre9hkNs6MxJdeA6fFTAVmly46iIBvRb4uetuiL+EeywhKXZIoaua/CVBOihN8kIsWZynucnNhQR97syozAhAYrUZvswuSJ6Vca1DfWYjhQCAB+54Bw31tIIrk1LhmCM7kzqnPRESwPLsw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make __vmalloc_area_node() respect non-blocking GFP masks such
as GFP_ATOMIC and GFP_NOWAIT.

- Add memalloc_apply_gfp_scope()/memalloc_restore_scope()
  helpers to apply a proper scope.
- Apply memalloc_apply_gfp_scope()/memalloc_restore_scope()
  around vmap_pages_range() for page table setup.
- Set "nofail" to false if a non-blocking mask is used, as
  they are mutually exclusive.

This is particularly important for page table allocations that
internally use GFP_PGTABLE_KERNEL, which may sleep unless such
scope restrictions are applied. For example:

<snip>
__pte_alloc_kernel()
  pte_alloc_one_kernel(&init_mm);
    pagetable_alloc_noprof(GFP_PGTABLE_KERNEL & ~__GFP_HIGHMEM, 0);
<snip>

Note: in most cases, PTE entries are established only up to the
level required by current vmap space usage, meaning the page tables
are typically fully populated during the mapping process.

Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 include/linux/vmalloc.h |  2 ++
 mm/vmalloc.c            | 52 +++++++++++++++++++++++++++++++++--------
 2 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 1e43181369f1..e8e94f90d686 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -332,4 +332,6 @@ bool vmalloc_dump_obj(void *object);
 static inline bool vmalloc_dump_obj(void *object) { return false; }
 #endif
 
+unsigned int memalloc_apply_gfp_scope(gfp_t gfp_mask);
+void memalloc_restore_scope(unsigned int flags);
 #endif /* _LINUX_VMALLOC_H */
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 9e29dd767c41..d8bcd87239b5 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3716,6 +3716,42 @@ static void defer_vm_area_cleanup(struct vm_struct *area)
 		schedule_work(&cleanup_vm_area);
 }
 
+/*
+ * Page tables allocations ignore external GFP. Enforces it by
+ * the memalloc scope API. It is used by vmalloc internals and
+ * KASAN shadow population only.
+ *
+ * GFP to scope mapping:
+ *
+ * non-blocking (no __GFP_DIRECT_RECLAIM) - memalloc_noreclaim_save()
+ * GFP_NOFS - memalloc_nofs_save()
+ * GFP_NOIO - memalloc_noio_save()
+ *
+ * Returns a flag cookie to pair with restore.
+ */
+unsigned int
+memalloc_apply_gfp_scope(gfp_t gfp_mask)
+{
+	unsigned int flags = 0;
+
+	if (!gfpflags_allow_blocking(gfp_mask))
+		flags = memalloc_noreclaim_save();
+	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
+		flags = memalloc_nofs_save();
+	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
+		flags = memalloc_noio_save();
+
+	/* 0 - no scope applied. */
+	return flags;
+}
+
+void
+memalloc_restore_scope(unsigned int flags)
+{
+	if (flags)
+		memalloc_flags_restore(flags);
+}
+
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				 pgprot_t prot, unsigned int page_shift,
 				 int node)
@@ -3732,6 +3768,10 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 
 	array_size = (unsigned long)nr_small_pages * sizeof(struct page *);
 
+	/* __GFP_NOFAIL and "noblock" flags are mutually exclusive. */
+	if (!gfpflags_allow_blocking(gfp_mask))
+		nofail = false;
+
 	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
 		gfp_mask |= __GFP_HIGHMEM;
 
@@ -3797,22 +3837,14 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	 * page tables allocations ignore external gfp mask, enforce it
 	 * by the scope API
 	 */
-	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
-		flags = memalloc_nofs_save();
-	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
-		flags = memalloc_noio_save();
-
+	flags = memalloc_apply_gfp_scope(gfp_mask);
 	do {
 		ret = vmap_pages_range(addr, addr + size, prot, area->pages,
 			page_shift);
 		if (nofail && (ret < 0))
 			schedule_timeout_uninterruptible(1);
 	} while (nofail && (ret < 0));
-
-	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
-		memalloc_nofs_restore(flags);
-	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
-		memalloc_noio_restore(flags);
+	memalloc_restore_scope(flags);
 
 	if (ret < 0) {
 		warn_alloc(gfp_mask, NULL,
-- 
2.47.3


