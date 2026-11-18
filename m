Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14420606A331
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ict+HHOc
Received: by kanga.kvack.org (Postfix)
	id 1A71A6B05EF; Wed, 18 Nov 2026 16:37:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17F4D6B05F0; Wed, 18 Nov 2026 16:37:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0944A6B05F1; Wed, 18 Nov 2026 16:37:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4E2D6B05EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:37:06 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 29DFA1408A5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:37:06 +0000 (UTC)
X-FDA: 85449550452.06.DEC67E4
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4F97780006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:37:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ict+HHOc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of sw.prabhu6@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=sw.prabhu6@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795037824;
	b=suAW37WHww2vUQhT3bh64Fd5931AKdPLfFPu0nZtHt+j7Tc6OLpBtxuaDG12Lo4L4Xd7va
	7a9+BOQccLmE9CjMV6cCsDN1BsiCbF3jOQ7Uycn1CEbYFtOrWMdn4wvTnNRM4PBd7H611a
	5Tl9B2krUtWe0g8fIkv1thO2COECnQo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795037824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0UBwsLS/EBzbzU7QpPz3uyEft8mQKTdSfQyTUVJf5Oc=;
	b=lQlvT1oKpxpaSH1zB+4slLx6kR+gd+0Cq+wuwXv9jLeoGcXH5wti3YM8hHLJFRR4Iqa0U0
	PIabKyaleBP+nGR/JweVIiSiIUC+4kMyych7JNWHKxyzmGg2mZu7pdr3elVSv5sIiZFdor
	XPyOz6DrtpVH2Xq8XMcK+ps/g/zNpl8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ict+HHOc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of sw.prabhu6@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=sw.prabhu6@gmail.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-8b503e2a87bso11340117b3.3
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795037823; x=1795642623; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0UBwsLS/EBzbzU7QpPz3uyEft8mQKTdSfQyTUVJf5Oc=;
        b=ict+HHOcQz30yeu+YRpn6D7da4FmXKzfzaxE8WTKxV6FnQgq6bSMkowsAYKdfct02M
         oga8hQZSbOMmq5jow6yGSwYbD8IwJSuokfSAuR4JWCM15mPZkW36HgfCsQ3O2ZGIsZsh
         xSgh7mDAFFeBPRG3FIRhwW0ELJR6c2kAU18kQlWfaVoXg9FnzuED1h/OYyUcGiJtkd9A
         kz4DkbVvoQ6OsSTb/9k5RYDkRuHx20UfYqKjANNgLPvWhlzauSCMenR4MnXla/T347ga
         lRT734sB+c56QjSnT+4MKDI/eGpEH8OshvmZ7ppkkszQ6SCdfja4UFjQ0Y7rcLUFcgqh
         ueWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795037823; x=1795642623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0UBwsLS/EBzbzU7QpPz3uyEft8mQKTdSfQyTUVJf5Oc=;
        b=ikkWcMvpuurzT4Mbrug6ZNlJa3SlZCaiON+vhMRb2yv7/OYWG04po0mygTN5GS9H0+
         wuk5qZI1vlhq/nn2Petor6tG5SVE0jG79UmNQyNOtISlryZ9L9TOWICjMCMNORHiyoRd
         IZMYLvHehWgGFgzubepp4BsIs6nxmHNS0NFxBchF5wPLvIa+LO+/W8LM4gt6tgCgVEdX
         xFOiL7nPcniw9MTaOjVpE4Bqs515iaIDAXwel8iqzXMjpTu/vmZzpi8oN6PXRWknBcII
         ueSs7ZGer8A6XeCENwJIQkTYdhzqTlWyL1s4a07dwd0nsD6PgzJIkkOaxNT8BqjaDR9n
         /CEA==
X-Gm-Message-State: APuU4Z+Zu3uWge9f/LVpSTTWbcsI4C40qnPwcZCP1CIGnPsLT4wmXQgX
	XoB3Zn9yTp0Oljhg0+gkPfOa1jjDPM51PuwPeeOoKZ2k9dYl4t+ZKXBB
X-Gm-Gg: AZFdTZftZGrUGZQpLW+sBs5JjeOD+w1btrQspkREm3FMaZ5oosl1V19WTcuvDXZJYnu
	QMNHi2GmMmh+bRK50rZ3n7jjkhmzvKVjr3f0qqSY9YYl5XG2GjS4xFwna7QkOwhL4hRS13HFIFE
	jDoTzdzFa6MTDlIabI2S75LtKnNcvrxEe59Gkn2khFpKLI8icP67IlKectygTiS7sN9Gs0/E27n
	p9yOxeETZzq6O7EEl8s+S4H0cfl4H29POE6nTWg/rlg7FgRc/9tA9MqJl4+5gbgA3IoJFTErHR/
	uSQDJC+evw31KPesdIlYnQU2kDadDRiHjSyHmdFCsvhJMRBaEznC/FwmfjE3y4+9NOEsY4EV/fO
	t1CeiqDP3CPjiifdIkUrBF2I4YlOl2zMSj95sxLTLWTSPh2HHPf/IgWfo4goDVt6h2pkMCMTP08
	fS5PCcSNGi7LF0QUwiDvxVso/pPAy6NGDho/LdymSTBgCziI4S6EKNTDBlg9FVawVqNR66O1/RT
	MZ8Zc8JVDSqEuDbkyjgIz0XYW9ha0WkJpzNqeaHT5MEZ3awO8CIy5GqNjMzufN0yCBlsI+sE4zG
	wDDEK+LEkHUkkMRWZzAolBsK50Po+k1UTJurNos0ee2dXBuLoe+9cmw=
X-Received: by 2002:a05:690c:34c9:b0:8b0:cc41:a124 with SMTP id 00721157ae682-8b4fed8df52mr15909757b3.49.1795037823316;
        Wed, 18 Nov 2026 13:37:03 -0800 (PST)
Received: from 5163NRD-SPrabh2.ssi.samsung.com ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4fe030be2sm24565697b3.10.2026.11.18.13.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 13:37:03 -0800 (PST)
From: Swarna Prabhu <sw.prabhu6@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	viro@zeniv.linux.org.uk
Cc: linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dave@stgolabs.net,
	riel@surriel.com,
	yeoreum.yun@arm.com,
	hch@lst.de,
	Swarna Prabhu <s.prabhu@samsung.com>
Subject: [PATCH 3/5] mm/gup: make the GUP-fast walkers record into struct gup_out
Date: Wed, 18 Nov 2026 13:34:56 -0800
Message-ID: <20261118213458.377258-4-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261118213458.377258-1-sw.prabhu6@gmail.com>
References: <20261118213458.377258-1-sw.prabhu6@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jphqqryx48ex7y6m4n9zotfg85jp5ni7
X-Rspam-User:
X-Rspamd-Queue-Id: 4F97780006
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795037824-644148
X-HE-Meta: U2FsdGVkX19FIrNF6qsj3emZaTtiowdhbALquQSypCkpyCBjIOav9URL/ngLNQmevZQ/Lr+vkujpOJbGrxahskEEDY0I4npCEPV4sB1bnH7NlbwltXpiZIM2DMor5gJi28NaawVvmNqWMLNW2Vyy+gtqYMZbEtz/3DNdQfQRzL2uwodPbXrPvY30bewhoAXHzcNBYya6sgJH0+e45ZRRV1iOwJGZ0z2/Fdldti/3qgz2G/qit1NuXOMeSN+SGoILiulgjUpcmwIdlsQSIPU97g24zVgGhI46ZWwRQHdz/k6+pfsAzgAd6VtkBQrxDLS/OoSMYqCqiyygF2JU+XJD+2gDCUXCnWADZpMqMnj0SKuBHmdTdFFvrk05xTqrdOsFjpaUXSyrzlGyh0miiLlfwFzVFyII14eLIK3TRYG4PMxzVewl26v45qHYH01s3JyVl0va61wZFVXWFsvZQk3LC+yHdh9xySt9dBj49Rc9TQ4P1jeu83iz4/sIJQ3cOjtJm7Zv58BTlbQKjDeupr4SGpHdhlC1SmLPahnRbbAgUN/1V2UeFRcm7J9QonEV9sxvQW8Tt7uOuCfpBE5KoJtb1eOo1gPlcKlUNwGss8PKq9JUiTOfRn2EWqhPl+6/wmkcVTGVXzaSMDWO4hPXaixMABV7pYtcvmxCAdiCSkDryWU65iJnnGyibGYo+Jv8CucG2QAlOdValqEPwk9oCe50PCRkTYaKaqY2fRTXmrWddKUjAy4P2nL6wCnR3MRVarMtU3QkrmsThguBHBHPCfNvBAj6wUT9Xv9SKke8SFPg98NiifauI44/TCcJuqEUQz3txuy0ikfamfV3x57m/8Jmz5d8Yd1spD6cdRyFqBu8wI4PV5a+RM3MdvTrOG7HfAE+vk8hYttVsJHTsao+g+nN0TiyFsQ/3N++G80do4fp8+LHlbrFf26i8RL2YKxvv486HSHYv+dXwJxuhJQpHZV
 pcgJkYeK
 AtC5AvW638LKrxvEm2sljSr3HUIb9oAS1lGfD7ydcZnTlCcAImDIbW/MRjFqsvHQDb2C1jqlObsjPtf2z4UNMOBnUEUxd8p/EDPeGH6MWo4XsoO+O2RqCVxT0K1dyQFdjUo3MfRzM5b96/Ct0xCdenGZY7AHigYMkZTjTWUU3MQWVxxOe6VI22OhstyoeyW8dxsq3XBoDHevfhKLtLCryIYMtPhAa2MU1VtqfahbbdANEicCO1ztZG8VKtHx+M1efojogn0f7hE7cd2knAGEAVFKeBwCRLxDat4aGqFUuB0bQ3zD76KJFwdflubXO6GZxeFE86xQYj9uf40fPXVckTqdBKXvoGHU7Lc+7DCZE+xguDIGPPsnKO2xrhYSUb/qbACvSZq0RoYGe9ytlI9uGsQbgXzt2fkFSYtbe18gnJPNvoJddpgO6r/XjmkoQy7zQh2m54uzgXfEJyLUn39r4sm4ku61gK/O4GoeZivwSMnwOWfEBg+cwnBAj5Fau2FENsbLMXN0+g3Y7h8ywgYrrmxIbZezuTHV3e+7GeTS+7WI02JlRc0mmXqh6IWQgtqTorYwYf5bT97LTanZpANF/i/5Yf6XHEAGifcEO09pgpFpbFFOUDlQWo2algEU8OE2oNZ/qsstdi079KeE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Swarna Prabhu <s.prabhu@samsung.com>

Pass 'struct gup_out' down the GUP-fast walkers and record acquired
pages through 'gup_out_add_range()' replacing pages array indexing and
pointer advancement. Record each existing PTE batch with one append.

Retain the walker's page-count return value so that callers can detect
short walks. Have gup_fast() obtain its result from the descriptor and
reset the count after releasing pins when a concurrent fork is detected.

Move fallback handling into gup_fast_fallback_out(), sharing the
descriptor with the slow path so recording continues after the pages
acquired by GUP-fast. Keep gup_fast_fallback() as an array-based wrapper
that initializes an empty descriptor.

No functional change.

Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
Assisted-by: LLM
---
 mm/gup.c | 94 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 56 insertions(+), 38 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 0b8dd3fde06b..43b92058a213 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3146,7 +3146,7 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
  */
 static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 		unsigned long addr, unsigned long end,
-		unsigned int flags, struct page **pages)
+		unsigned int flags, struct gup_out *out)
 {
 	unsigned long nr_pages = 0, nr_batch;
 	struct folio *folio = NULL;
@@ -3158,7 +3158,6 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 	do {
 		pte_t pte = ptep_get_lockless(ptep);
 		struct page *page;
-		unsigned long i;
 
 		nr_batch = 1;
 
@@ -3229,8 +3228,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 			nr_batch = 1;
 
 		folio_set_referenced(folio);
-		for (i = 0; i < nr_batch; i++)
-			pages[nr_pages + i] = page + i;
+		gup_out_add_range(out, folio, page, nr_batch);
 		nr_pages += nr_batch;
 		folio = NULL;
 	} while (ptep += nr_batch, addr += nr_batch * PAGE_SIZE, addr != end);
@@ -3254,7 +3252,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
  */
 static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 		unsigned long addr, unsigned long end,
-		unsigned int flags, struct page **pages)
+		unsigned int flags, struct gup_out *out)
 {
 	return 0;
 }
@@ -3262,11 +3260,11 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 
 static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 		unsigned long addr, unsigned long end,
-		unsigned int flags, struct page **pages)
+		unsigned int flags, struct gup_out *out)
 {
 	struct page *mapped_page, *page;
 	struct folio *folio;
-	unsigned long nr_pages, i;
+	unsigned long nr_pages;
 
 	/* See gup_fast_pte_range() */
 	if (pmd_protnone(orig))
@@ -3301,19 +3299,18 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 		return 0;
 	}
 
-	for (i = 0; i < nr_pages; i++)
-		*(pages++) = page++;
+	gup_out_add_range(out, folio, page, nr_pages);
 	folio_set_referenced(folio);
 	return nr_pages;
 }
 
 static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 		unsigned long addr, unsigned long end,
-		unsigned int flags, struct page **pages)
+		unsigned int flags, struct gup_out *out)
 {
 	struct page *mapped_page, *page;
 	struct folio *folio;
-	unsigned long nr_pages, i;
+	unsigned long nr_pages;
 
 	if (!pud_access_permitted(orig, flags & FOLL_WRITE))
 		return 0;
@@ -3345,15 +3342,14 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 		return 0;
 	}
 
-	for (i = 0; i < nr_pages; i++)
-		*(pages++) = page++;
+	gup_out_add_range(out, folio, page, nr_pages);
 	folio_set_referenced(folio);
 	return nr_pages;
 }
 
 static unsigned long gup_fast_pmd_range(pud_t *pudp, pud_t pud,
 		unsigned long addr, unsigned long end,
-		unsigned int flags, struct page **pages)
+		unsigned int flags, struct gup_out *out)
 {
 	unsigned long next, nr_pages = 0, chunk_nr_pages;
 	pmd_t *pmdp;
@@ -3369,12 +3365,12 @@ static unsigned long gup_fast_pmd_range(pud_t *pudp, pud_t pud,
 		if (unlikely(pmd_leaf(pmd))) {
 			chunk_nr_pages = gup_fast_pmd_leaf(pmd, pmdp, addr,
 							   next, flags,
-							   &pages[nr_pages]);
+							   out);
 
 		} else
 			chunk_nr_pages = gup_fast_pte_range(pmd, pmdp, addr,
 							    next, flags,
-							    &pages[nr_pages]);
+							    out);
 		nr_pages += chunk_nr_pages;
 		if (chunk_nr_pages != (next - addr) >> PAGE_SHIFT)
 			break;
@@ -3385,7 +3381,7 @@ static unsigned long gup_fast_pmd_range(pud_t *pudp, pud_t pud,
 
 static unsigned long gup_fast_pud_range(p4d_t *p4dp, p4d_t p4d,
 		unsigned long addr, unsigned long end,
-		unsigned int flags, struct page **pages)
+		unsigned int flags, struct gup_out *out)
 {
 	unsigned long next, nr_pages = 0, chunk_nr_pages;
 	pud_t *pudp;
@@ -3400,11 +3396,11 @@ static unsigned long gup_fast_pud_range(p4d_t *p4dp, p4d_t p4d,
 		if (unlikely(pud_leaf(pud)))
 			chunk_nr_pages = gup_fast_pud_leaf(pud, pudp, addr,
 							   next, flags,
-							   &pages[nr_pages]);
+							   out);
 		else
 			chunk_nr_pages = gup_fast_pmd_range(pudp, pud, addr,
 							    next, flags,
-							    &pages[nr_pages]);
+							    out);
 		nr_pages += chunk_nr_pages;
 		if (chunk_nr_pages != (next - addr) >> PAGE_SHIFT)
 			break;
@@ -3414,7 +3410,7 @@ static unsigned long gup_fast_pud_range(p4d_t *p4dp, p4d_t p4d,
 }
 
 static unsigned long gup_fast_p4d_range(pgd_t *pgdp, pgd_t pgd, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages)
+		unsigned long end, unsigned int flags, struct gup_out *out)
 {
 	unsigned long next, nr_pages = 0, chunk_nr_pages;
 	p4d_t *p4dp;
@@ -3428,7 +3424,7 @@ static unsigned long gup_fast_p4d_range(pgd_t *pgdp, pgd_t pgd, unsigned long ad
 			break;
 		BUILD_BUG_ON(p4d_leaf(p4d));
 		chunk_nr_pages = gup_fast_pud_range(p4dp, p4d, addr, next,
-						    flags, &pages[nr_pages]);
+						    flags, out);
 		nr_pages += chunk_nr_pages;
 		if (chunk_nr_pages != (next - addr) >> PAGE_SHIFT)
 			break;
@@ -3439,7 +3435,7 @@ static unsigned long gup_fast_p4d_range(pgd_t *pgdp, pgd_t pgd, unsigned long ad
 
 static unsigned long gup_fast_pgd_range(unsigned long addr,
 		unsigned long end, unsigned int flags,
-		struct page **pages)
+		struct gup_out *out)
 {
 	unsigned long next, nr_pages = 0, chunk_nr_pages;
 	pgd_t *pgdp;
@@ -3453,7 +3449,7 @@ static unsigned long gup_fast_pgd_range(unsigned long addr,
 			break;
 		BUILD_BUG_ON(pgd_leaf(pgd));
 		chunk_nr_pages = gup_fast_p4d_range(pgdp, pgd, addr, next,
-						    flags, &pages[nr_pages]);
+						    flags, out);
 		nr_pages += chunk_nr_pages;
 		if (chunk_nr_pages != (next - addr) >> PAGE_SHIFT)
 			break;
@@ -3464,7 +3460,7 @@ static unsigned long gup_fast_pgd_range(unsigned long addr,
 #else
 static inline unsigned long gup_fast_pgd_range(unsigned long addr,
 		unsigned long end, unsigned int flags,
-		struct page **pages)
+		struct gup_out *out)
 {
 	return 0;
 }
@@ -3481,12 +3477,27 @@ static bool gup_fast_permitted(unsigned long start, unsigned long end)
 }
 #endif
 
+/*
+ * Undo what GUP-fast recorded in @out.
+ *
+ * Don't perform any sanity checks because we might have raced with fork() and
+ * some anonymous pages might now actually be shared -- which is why we're
+ * unpinning after all.
+ */
+static void gup_fast_unpin(struct gup_out *out)
+{
+	gup_fast_unpin_user_pages(out->pages, out->nr_pages);
+	out->nr_pages = 0;
+}
+
 static unsigned long gup_fast(unsigned long start, unsigned long end,
-		unsigned int gup_flags, struct page **pages)
+		unsigned int gup_flags, struct gup_out *out)
 {
-	unsigned long flags, nr_pinned;
+	unsigned long flags;
 	unsigned seq;
 
+	VM_WARN_ON_ONCE(out->nr_pages);
+
 	if (!IS_ENABLED(CONFIG_HAVE_GUP_FAST) ||
 	    !gup_fast_permitted(start, end))
 		return 0;
@@ -3508,7 +3519,7 @@ static unsigned long gup_fast(unsigned long start, unsigned long end,
 	 * that come from callers of tlb_remove_table_sync_one().
 	 */
 	local_irq_save(flags);
-	nr_pinned = gup_fast_pgd_range(start, end, gup_flags, pages);
+	gup_fast_pgd_range(start, end, gup_flags, out);
 	local_irq_restore(flags);
 
 	/*
@@ -3517,22 +3528,22 @@ static unsigned long gup_fast(unsigned long start, unsigned long end,
 	 */
 	if (gup_flags & FOLL_PIN) {
 		if (read_seqcount_retry(&current->mm->write_protect_seq, seq)) {
-			gup_fast_unpin_user_pages(pages, nr_pinned);
+			gup_fast_unpin(out);
 			return 0;
 		} else {
-			sanity_check_pinned_pages(pages, nr_pinned);
+			sanity_check_pinned_pages(out->pages, out->nr_pages);
 		}
 	}
-	return nr_pinned;
+	return out->nr_pages;
 }
 
-static int gup_fast_fallback(unsigned long start, unsigned long nr_pages,
-		unsigned int gup_flags, struct page **pages)
+static long gup_fast_fallback_out(unsigned long start, unsigned long nr_pages,
+		unsigned int gup_flags, struct gup_out *out)
 {
 	unsigned long len, end;
 	unsigned long nr_pinned;
 	int locked = 0;
-	int ret;
+	long ret;
 
 	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM |
 				       FOLL_FORCE | FOLL_PIN | FOLL_GET |
@@ -3553,16 +3564,15 @@ static int gup_fast_fallback(unsigned long start, unsigned long nr_pages,
 	if (end > TASK_SIZE_MAX)
 		return -EFAULT;
 
-	nr_pinned = gup_fast(start, end, gup_flags, pages);
+	nr_pinned = gup_fast(start, end, gup_flags, out);
 	if (nr_pinned == nr_pages || gup_flags & FOLL_FAST_ONLY)
 		return nr_pinned;
 
 	/* Slow path: try to get the remaining pages with get_user_pages */
 	start += nr_pinned << PAGE_SHIFT;
-	pages += nr_pinned;
-	ret = __gup_longterm_locked(current->mm, start, nr_pages - nr_pinned,
-				    pages, &locked,
-				    gup_flags | FOLL_TOUCH | FOLL_UNLOCKABLE);
+	ret = __gup_longterm_locked_out(current->mm, start,
+					nr_pages - nr_pinned, out, &locked,
+					gup_flags | FOLL_TOUCH | FOLL_UNLOCKABLE);
 	if (ret < 0) {
 		/*
 		 * The caller has to unpin the pages we already pinned so
@@ -3575,6 +3585,14 @@ static int gup_fast_fallback(unsigned long start, unsigned long nr_pages,
 	return ret + nr_pinned;
 }
 
+static int gup_fast_fallback(unsigned long start, unsigned long nr_pages,
+		unsigned int gup_flags, struct page **pages)
+{
+	struct gup_out out = GUP_OUT_PAGES(pages);
+
+	return gup_fast_fallback_out(start, nr_pages, gup_flags, &out);
+}
+
 /**
  * get_user_pages_fast_only() - pin user pages in memory
  * @start:      starting user address
-- 
2.53.0


