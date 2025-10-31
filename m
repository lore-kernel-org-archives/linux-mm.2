Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07D68CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 17:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49DC58E012D; Fri, 31 Oct 2025 13:48:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 476448E0121; Fri, 31 Oct 2025 13:48:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38BCC8E012D; Fri, 31 Oct 2025 13:48:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2185D8E0121
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 13:48:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB37614057A
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:48:46 +0000 (UTC)
X-FDA: 84059144652.08.86C1B44
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id D70D512000E
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:48:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PKmCu+pJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761932924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ICLN39FJdVD/075eTRkrmHvRsCawcGixIB7gQzMC3KY=;
	b=Yqr2/mD+gl00B0q+Fh64PaxgWNJ4u4lu4Yvpb/PPRulttOmRfCMFNxkVFpdIzCkIFJon/O
	8PN4PH/Ulr6nw6YwRVszqtSd6bHR+YsliqLbX8VeWWk+JAV2fKWlYjUD658RDxhlPlAJlG
	lMLGsct8IqMRhiAp6UobMjGlGygbCbs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761932924; a=rsa-sha256;
	cv=none;
	b=MFC3qdr+J9rDTMSg49cYImGIn3aj4EqrrwqAqVn/XeGZy/JIvzII+7S8OLVcbdjqHtyoUe
	6C3a6EMKM0ZMWjvMNyDz6ffSX+x34aGYqsrFp2hdD/TJxYi2JfBEUrx2DtGoOiUSj6wmkN
	R+LybMthqOjC2CX/GvtGcWCMGWG+dkg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PKmCu+pJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-295018cbc50so27167455ad.3
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761932923; x=1762537723; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ICLN39FJdVD/075eTRkrmHvRsCawcGixIB7gQzMC3KY=;
        b=PKmCu+pJnJTBOeEQbyk2A7V9/Aj4uJeQSbaBy3518ffRwXk/jGfoWtlQX2uMz24V0F
         IURmMo9FY0ZdTSHNTECsXC+2Nc+3WtBhAQKmIoFvm4jGWFkCGp44O+fhhNChartbJ6ed
         rfQiDjGHcoqfn1DtMRB2/NrasMxKfJ1YQHjd/R/jl299uHgXWr3VwH4z5RDX/CBnVtxk
         wfR9dg6wwjBfBPRmMoW9mP/bXmRl5heNOrX/oaiAiIumLKUF45w8uYuM6gco4vFSLTvu
         kohqgve/3MuIzVsWt3JNV8cKnX3MdXGXkC7lxsWdp6WGCoLbUm7jz76aL2jTbVOLNbS6
         3sFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761932923; x=1762537723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ICLN39FJdVD/075eTRkrmHvRsCawcGixIB7gQzMC3KY=;
        b=exl/V4wSwwjGdkHIdbyjfwpwJPsGI5XmIcDkf6Eoko9KU4n72GmZbN+lHck144RdEO
         kU+z+iiamRbXJqceyWBdaxjK8YJb6YMTvliwt1BjX5+NWj8FoDKNAgE8FzHniS/9V67P
         rFA/peE4XUbtC/Yago1txOCgN/ibCH6/JtDTzd1f+IzYW2pHS/J7K/YkZss1/LabjBwL
         i9t36ZV4iqmQkDkQfqGqDgNA7IEIQvVgwRi4+FRZjgHB5wBu8Dauf9wPteLtAz3KHAuU
         qe9RbSCLl91WBNbAk4hDoOzrZCwr9u5jau34GX3AYexKoQZ31tJtonnxkmlKf2QSAeSp
         ENAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUoQJoX4HJcENxLJ8sfOr4oqvlYxR6kFoqXv7Ss69TNRT4QLPgRhxWS8nnshz0j1XyG3aubeUs5dg==@kvack.org
X-Gm-Message-State: AOJu0Ywr8Wt7Hwa7aoBCJ06jHBT/9MIMXYg6kEkQw+Oge99s9GCX0L/A
	m4UOpdiT++hLVjk1aEHYEOksmTkdr6RcWSx79lWK7Dqw2br0AfN7Qj3Q
X-Gm-Gg: ASbGncu8vC3n5jIQoZKT1Y8nb5/A76YdSBk360kDri9uERw75jXCIIVUPksZwBzuPFB
	4pkPo8MXgGTifPQTf+OJNc3Fip/yPqNHeVFK+MoUf+mhKPkqSwhhx8My+O2Jmenx9+1LA17XQXZ
	K32pnE0JgCkWObngb4dAaLhuQtaYPesXt4V0BNQStEooY/xADrvDNkeP4Zg9kaW9LtR37LOipCP
	LQTNrsURsvTgJkrOUjvyP3xakIXFAzeMowQxtOvgacJzH6Ktc2tNXx12gHp2ISTBVg890NEQhbB
	i0QCU8TeZmVHiLhKvZqe5/Ew1/zm7UlzitdnkAV6VguYMsuyaWqDm6lgf0HiDhTE6oQFy7jPKTT
	GcsPCu/mC3uYWlAmpPnW3U/zN3K9Ap2DQ/JkU9teEgSOwhbGLANXJBNg8a04wQxKpkmsH9DpZqB
	/QMw5Chhogzme8RwAkGzap1Xyq
X-Google-Smtp-Source: AGHT+IFLP8ni/MiCCDGUKUMnRDX4e3jWK/OtkBZosJW9tmtouHuYrj2fu9vWtsB0S6HQVfeXxnga7w==
X-Received: by 2002:a17:902:e5cc:b0:280:fe18:847b with SMTP id d9443c01a7336-2951a4dfc29mr68076395ad.33.1761932923531;
        Fri, 31 Oct 2025 10:48:43 -0700 (PDT)
Received: from weg-ThinkPad-P16v-Gen-2.. ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29526871693sm30113185ad.20.2025.10.31.10.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 10:48:43 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH v2 1/3] Revert "mm/ksm: convert break_ksm() from walk_page_range_vma() to folio_walk"
Date: Fri, 31 Oct 2025 14:46:23 -0300
Message-ID: <20251031174625.127417-2-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251031174625.127417-1-pedrodemargomes@gmail.com>
References: <20251031174625.127417-1-pedrodemargomes@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D70D512000E
X-Rspamd-Server: rspam02
X-Stat-Signature: 6duswsus1rcaumsg7nqaa9x9c35bkeii
X-HE-Tag: 1761932924-81109
X-HE-Meta: U2FsdGVkX1+JUc+py7tyEqXCM/gS9hSPUvwkrYRDmuarmsFNAkzrjJ390VNDq0Jnp/kMpilt/vd0k0UMrjUMROuogVgmfjJNzZNgUpdeSLr/rIDlUNGcnogtROrJC1k91G/DE5x9y0shge6jr/v9DlsC5flDwke/CYenmIvOpru78q6jMKGRN2JDS7kr2YVW+u9jsEXe1UpdXjsXlUDxG7+YtnihPt9LO6VP5lXrvJ0f8jRkTncOdByd07oZH9eRHns3YH/dV8m2ZLyTmv4YBtIOusyeiYYcmMvuB8gCZMQLCcKxIMihvvjr/9sQwAxtSbK6bZPKKIt8V/BQyJ3cHKxKjIFqIHTm6Rk4Vg6S4IWAjtVuLwfoobFNeS9lyu+mLxkFK0Veu/luSfTSmgFsVIO1V9jk4LxlM7JAvSQVWVMcSlcxjo8B8GohN2pJkAG2/4odhM+rpdNqPN59RfE+F5a6VxqSoEohFB7bdcRFgP0dnDp8nLo3xWJvZ7tbL8sS/UidRHgEhUQZ6EXZ0KndMNBBNUS3EiGP+F/kTPMRSwDsqDi0fO1VFom6loao1/lSwlmE8biZ+hqOt1J1TPA1IFKm+2ecLC10s7NH0FM19fB9aPuCcUxYh8s+ds8BurmfTs/FFiasL7Q0Lc5PNhJBLst0fh8O4TFb47dYbQsAeniEbc/xDf+Zz0AdhiV8/bBBxCgunuVX8ZgVJUMsb/pE/iUEDKTXvQUeuK+xpOXi9NpNgQ11F8Y3me/slB00zf3aus/ORo6NC3paK5g0IZ2GsPpToQl/tn7OQrT6bxqQqqjwUB1zTWgth6SRDE+/ZdVphfatBeHxcyATpyzIDvq1PdduOSizFhEX5u6Kp2CdV3BuNk9K36IGfo/cPhwFO9Pb1O+aYSzP66Qx9YdVUbutgPZ9xbaWKNtqxUCJLdAL99cNUnrUmJs+mDc6nvZg5btY3G8w3VQm/A4TZC8j/fP
 n+V2FMqM
 VKSxJejRrsz5G/oCWVrLvD7JCbzWSzsFkjHxTfGWhtHoQ3dogvNdrKSpSpuTf0dNidThljrIZtclSQR25+yV5lx3ZwtDzJjCeyOqC1ZVmu0YD/A6JfNP7gIrHW0nSrE6hr2HTHStaPl0IcIzJ1wdVjvLnEqAuwgbQ5XDrd+7ermSX3JaojQOeV8I8n5YelHVZ/zixECtU7T0BYm3p+bwVsgqp5v5Yo3aSs0izMziVmW4reGnd15euRNCD8qmFJ1UvCzwtmY+v9fWOUj4fRtLtLactXhKKLISDcfTHkQEVF9CSa0ctYVCimxkes5RmLQQeIXRYOvPjVKCOEJ+SrhO77Mtm6o5AyU8dAtsnp6oEc26ZRVIi9E2QewFJLms8SGhEpOg7/6iw9ruXXe32rliusRk4/ez4zaY1+J5Q32OysbJFwwxpQ6rEVVPtoEpEkl4di+hZgcSgB4ANVWTlv7czMQZgW6pqO8gemZorSNkjhCJwWzY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reverts commit e317a8d8b4f600fc7ec9725e26417030ee594f52 and changes
function break_ksm_pmd_entry() to use folios.

This reverts break_ksm() to use walk_page_range_vma() instead of
folio_walk_start().
This will make it easier to later modify break_ksm() to perform a proper
range walk.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 mm/ksm.c | 63 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 47 insertions(+), 16 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 4f672f4f2140..922d2936e206 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -607,6 +607,47 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
 	return atomic_read(&mm->mm_users) == 0;
 }
 
+static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
+			struct mm_walk *walk)
+{
+	struct folio *folio = NULL;
+	spinlock_t *ptl;
+	pte_t *pte;
+	pte_t ptent;
+	int ret;
+
+	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte)
+		return 0;
+	ptent = ptep_get(pte);
+	if (pte_present(ptent)) {
+		folio = vm_normal_folio(walk->vma, addr, ptent);
+	} else if (!pte_none(ptent)) {
+		swp_entry_t entry = pte_to_swp_entry(ptent);
+
+		/*
+		 * As KSM pages remain KSM pages until freed, no need to wait
+		 * here for migration to end.
+		 */
+		if (is_migration_entry(entry))
+			folio = pfn_swap_entry_folio(entry);
+	}
+	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
+	ret = (folio && folio_test_ksm(folio)) || is_ksm_zero_pte(ptent);
+	pte_unmap_unlock(pte, ptl);
+	return ret;
+}
+
+static const struct mm_walk_ops break_ksm_ops = {
+	.pmd_entry = break_ksm_pmd_entry,
+	.walk_lock = PGWALK_RDLOCK,
+};
+
+static const struct mm_walk_ops break_ksm_lock_vma_ops = {
+	.pmd_entry = break_ksm_pmd_entry,
+	.walk_lock = PGWALK_WRLOCK,
+};
+
 /*
  * We use break_ksm to break COW on a ksm page by triggering unsharing,
  * such that the ksm page will get replaced by an exclusive anonymous page.
@@ -623,26 +664,16 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
 static int break_ksm(struct vm_area_struct *vma, unsigned long addr, bool lock_vma)
 {
 	vm_fault_t ret = 0;
-
-	if (lock_vma)
-		vma_start_write(vma);
+	const struct mm_walk_ops *ops = lock_vma ?
+				&break_ksm_lock_vma_ops : &break_ksm_ops;
 
 	do {
-		bool ksm_page = false;
-		struct folio_walk fw;
-		struct folio *folio;
+		int ksm_page;
 
 		cond_resched();
-		folio = folio_walk_start(&fw, vma, addr,
-					 FW_MIGRATION | FW_ZEROPAGE);
-		if (folio) {
-			/* Small folio implies FW_LEVEL_PTE. */
-			if (!folio_test_large(folio) &&
-			    (folio_test_ksm(folio) || is_ksm_zero_pte(fw.pte)))
-				ksm_page = true;
-			folio_walk_end(&fw, vma);
-		}
-
+		ksm_page = walk_page_range_vma(vma, addr, addr + 1, ops, NULL);
+		if (WARN_ON_ONCE(ksm_page < 0))
+			return ksm_page;
 		if (!ksm_page)
 			return 0;
 		ret = handle_mm_fault(vma, addr,
-- 
2.43.0


