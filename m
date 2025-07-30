Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BCFC83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 17:20:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABF7F6B0089; Wed, 30 Jul 2025 13:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50226B008A; Wed, 30 Jul 2025 13:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E9CD6B0092; Wed, 30 Jul 2025 13:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE5F6B0089
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:20:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4638E592DC
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 17:20:05 +0000 (UTC)
X-FDA: 83721593970.09.5E41BAA
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4E16A14000B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 17:20:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V6mbSR3f;
	spf=pass (imf26.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753896003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m56piLiCUsf4x2+WWsFp57PljOix1hfz8SW0ckD+2q4=;
	b=UbvmKlIR3w5hBVuX9HDUzmV9qiHG/uoPt8yATAG4upz35TigbJtwDbHsNUyKVa7ovOXo+/
	o4b9/HkIQHgzg1B2bxbVcs5pw3HYjVrI8dYXjyIplYOsKkf55Mrvyw/bnpeR5mcuIOkTVp
	MkMjdV5Vi5sOuPljpCUE2kug1iBBcXo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V6mbSR3f;
	spf=pass (imf26.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753896003; a=rsa-sha256;
	cv=none;
	b=ZjpCIwQznaHClbDVHuT0TZW/dFk16Sio1yGpfy2GoxoVlv44IqplvR1TuOMaEfcqUaxteS
	qGwR8yQ7QhzQ90sshFCqwagMqZ8GfbCohqn+KZ+WSklSa73b5IAmPIsLsOQEy127Vtt8Zx
	SBCJSyr7JSC+6C/ZeSiJYWQuczfoh2Y=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3b77b8750acso832789f8f.0
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 10:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753896002; x=1754500802; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m56piLiCUsf4x2+WWsFp57PljOix1hfz8SW0ckD+2q4=;
        b=V6mbSR3f+VFyn3Yl78r3wSDiWfgenhrOLwIKHqtQ1Mf4+YIK9/UAIqzVWXat8wpWob
         JBVn7/113VW9QaTLyf/8sU++diI5ZWhzt9Eo3aKPjHeub+sQ8C9RmyQn0KoR+/5XvqM4
         JYNrUHDeCH3a+xfD6Bj69eWG1rD5iAxCjqr/06NEM0UhAQNGbkiztP8y0EVd7hJqv5ze
         BXDhemSsy1eM5vijLB1r2DoWayn2atjWeTCTkcNrQlMqsVclzCwpn76N1S5q/oxCZVgN
         B07Wzlwhryz7xTRbY5vhcRGwaLd+tNtU7ecXw3OeBYai5F4M3/r1qQLvnt5MEqv+OmxA
         LDnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753896002; x=1754500802;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m56piLiCUsf4x2+WWsFp57PljOix1hfz8SW0ckD+2q4=;
        b=nbpErXX83uwHzteVtJYI0O4gN9QJlQ6/CJSnS3H9LjUIhaR4jwvIaAHAvl8Se39OZz
         YGz1aBTrFGX6Jbmv+rRR8q0jnFGiuYhRG1uIXxXNQnEQ/k0Hu4Y97ZcsTJ/qN7e/yPdm
         aAHcx6ZSVTZQM9mDysqehwu07d3E/toJyWB3HuOcQfDspl6GaN5eHzUR4QvmgFEVnBqZ
         4Sk63jXRtxgG0VqCQ7IgcI5dakDPOzyuEaaGWnokvvOAN4dTgcoX6Rh98U44jqPBkVy+
         4wPq9nZyGwMgE9uJb24Uz/RMgGbdOkNiutSop4N0c1HmgPBnhGBqeRGBu0ixQhbniHVL
         1pBg==
X-Forwarded-Encrypted: i=1; AJvYcCWVy8Dpr41Kmun5c14h7WRxKjjkQYh+9RkkKMJQw9Dlwf8jCw6OHzYTvD1REMImif9J/9RbwBvO2A==@kvack.org
X-Gm-Message-State: AOJu0Yx3u3/YZ6x8H5AunOKTy/PEyn71cMogwJdhSu9mUnBYnqebXMyo
	QGSFBWRVMwFziWy1i8jXvAdPUFFqQ2nvnymNmqmAGwwv2ZJUL4xWPGby
X-Gm-Gg: ASbGncumZ0ik+jWPZU+ROAKHqkELRe9hRXzdgbnR3wKi/fwM864sCaFULOx8fQgv5AY
	wM3SmJLBxDRVQiJ6T5ffc9qFD6e+7CBLOR54VaGPW2LqIVrtU5R8DNDwEKBrUwHPwFCN4NouSrI
	/Hjco4ALwhYM9gwmhUycw5veXh3bP2PSgZty7MAwTfx5RGYF9t+2cDvOIfKj+5ouKtDepvG/w5n
	m7fW7X1oc7Nf49ZIglmujdChUCeLsvoV4fICLGhF2uSN25rESjCNJwoU8PFHnURM/oKKpRZDGGa
	nzkVRH0Ve8B6pzUxZ9ZXxLorAx7DAgPXpObHLHB6y6rQ7l09JNugWHBxOULT8MgT28/2RcOTyhc
	GUG+j27mVCLu9BJg=
X-Google-Smtp-Source: AGHT+IGCdHpb01HVcfRvMatDM7O3m0xWJobij7p29QqoVPfMGp10ngvKQXKEPQiuMocwu72i1Rx6hw==
X-Received: by 2002:a05:6000:2311:b0:3a5:8934:4959 with SMTP id ffacd0b85a97d-3b78e72803dmr7193414f8f.27.1753896001745;
        Wed, 30 Jul 2025 10:20:01 -0700 (PDT)
Received: from localhost ([2a03:2880:31ff:74::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45895377ae2sm33277545e9.12.2025.07.30.10.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 10:20:01 -0700 (PDT)
From: Yueyang Pan <pyyjason@gmail.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] mm/damon: Add damos_stat support for vaddr
Date: Wed, 30 Jul 2025 10:19:56 -0700
Message-ID: <c05b1b4f66758c0154e4d037adcb15c43917f38b.1753895066.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1753895066.git.pyyjason@gmail.com>
References: <cover.1753895066.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 981y1fgheofb9mdwi87s9iufpr8gupfq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4E16A14000B
X-Rspam-User: 
X-HE-Tag: 1753896003-709120
X-HE-Meta: U2FsdGVkX1/6ukj1rWq6rq9Ta7QpWwfVQO0TH4fOWp6qkpgGR4/jgAkIIA0WCRVSGDcpBg3RCX/Pg9nV9UtFXXpTcASiwkHHotA+XhPbFNPQr/ZE95Nsr3UYJNpd5To9rg2BE0taSsVDvgfQXY2cReB3yFh2NapUHcDZaC5M/nFXv4fIqb5UQORHshlt6+AkLTWtcpYgER81nAYd7o0MZm2N50c/gGB97JOwZ72+sifBIFIckR49w7Wh1Yc0aeFOhHNlOdINwm2Ni/XKKB80idbRuObEHaBRUgZAsEt+6rW1p5gcVYakDP2IF2DPkp/eYdHvtNCNVndGiDZsu/JhQ14JvdpEjUqPwQuitYlsAEbE11ZHPHtG8+2D2iruZgVpYNySadyoDT1lxeEQOCk994sVj30bBZlPpIT4HBOeUKTCcUlLbsH8h/4AprICB2FvdunPg51RB8qZ0d27zjcY6/1hi35hUJZrnQCjWaG+0JHcqVabWheFwGaUM+l99lSPnyB2sQVY33KVLYHzH2xgMZQIVxGKUb6hxKu8JBX1d2oU8OoXBYp04d6Fvi85imfjYdidsciTx5e6Sa6IU8S8O/ZYSehYrOUi62DBS4nYNIL9m7sj+YQl/m0eTX5NLfV2eEEwHqKR681f6wP+l/tW4r3K450YSbAs2qyoOA5Y8MX1SF+LbzHBBLJW2UPRlq1ZUFUndpvflC25a+t8Lu+No5AOfllK4/FQceGju6RQNazePpPg9XY0JkVZ0qYFTtZvbZbG5A6uSBWbfHYO4Hc9yt0W8OJkw51eQveQCqRFGYtbuw2PSC8t3tyrAIFm7QT+ghTLtupF5tgP09LM+vTbM5i9JkqQ2pk3eZMjy5BYcCy+JP1yz3hx/8Gc43nLNUyefGy74JdYHdO0+GJn6nkTYucvV934kBG7ndyAPTVzF2gYb2Pzvtn17VduJ1hLRzR/yZAIhlkDuR6tiZZk8P0
 tnB43KEx
 GCAwX7P+HL0O341YcwbIoSUQNQV3er/B3f2bO6hUrnJlaM/amx2272VupP/AnUc8m0uGEldz0lLT02mc9BYulDNewanitfs5vb/Lo0pwvDhVAMEuhccKXWhZ/1A/V3GOdtEekqk7E5q/5oFB+dIQhAkLJ6I48jsvBRQtRJekvbFlMu2+ovSx2RukafolM/xNxuz+/joKATxo4IHhqvJ42Vb0SPSEeHM7m563uzA5xAstd86wWF3sM2YUJVgL1FdR7HNRA3Vaq0sgDPGvV+4NPjOiSDRTWE/TCpto+JjWzZcIE44PU3BtSG82LdDNBGEkC1geTCKpMW8T18sVpR9oX999LOH3+kT0jUlyoyCjX7N4G2rn/Bf+njbe0XrtnachvQwc6f7VGoU4mFZ8WvBkzHsffrZuBET0NcnlgxzrAS1pgvFoqpc0cC7U0xB+iQ9uXKvM1lY3LoATZ9ce3vyKH8fMjd7F8hkvGdD3ZSQStpaQn0+rg5gsf+wxBNBVanOBOoun7SkXZje2QxMb/hgMWs6RO2CKQsouK7YaO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds support for damos_stat in virtual address space.
It leverages the walk_page_range to walk the page table and gets
the folio from page table. The last folio scanned is stored in
damos->last_applied to prevent double counting.

Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
---
 mm/damon/vaddr.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 104 insertions(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 87e825349bdf..6ed919e817e2 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -890,6 +890,109 @@ static unsigned long damos_va_migrate(struct damon_target *target,
 	return applied * PAGE_SIZE;
 }
 
+struct damos_va_stat_private {
+	struct damos *scheme;
+	unsigned long *sz_filter_passed;
+};
+
+static inline bool damon_va_invalid_damos_folio(struct folio *folio, struct damos *s)
+{
+	return !folio || folio == s->last_applied;
+}
+
+static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
+		unsigned long next, struct mm_walk *walk)
+{
+	struct damos_va_stat_private *priv = walk->private;
+	struct damos *s = priv->scheme;
+	unsigned long *sz_filter_passed = priv->sz_filter_passed;
+	struct vm_area_struct *vma = walk->vma;
+	struct folio *folio;
+	spinlock_t *ptl;
+	pte_t *start_pte, *pte, ptent;
+	int nr;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (pmd_trans_huge(*pmd)) {
+		pmd_t pmde;
+
+		ptl = pmd_trans_huge_lock(pmd, vma);
+		if (!ptl)
+			return 0;
+		pmde = pmdp_get(pmd);
+		if (!pmd_present(pmde))
+			goto huge_unlock;
+
+		folio = vm_normal_folio_pmd(vma, addr, pmde);
+
+		if (damon_va_invalid_damos_folio(folio, s))
+			goto huge_unlock;
+
+		if (!damos_va_filter_out(s, folio, vma, addr, NULL, pmd))
+			*sz_filter_passed += folio_size(folio);
+		s->last_applied = folio;
+
+huge_unlock:
+		spin_unlock(ptl);
+		return 0;
+	}
+#endif
+	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	if (!start_pte)
+		return 0;
+
+	for (; addr < next; pte += nr, addr += nr * PAGE_SIZE) {
+		nr = 1;
+		ptent = ptep_get(pte);
+
+		if (pte_none(ptent) || !pte_present(ptent))
+			continue;
+
+		folio = vm_normal_folio(vma, addr, ptent);
+
+		if (damon_va_invalid_damos_folio(folio, s))
+			continue;
+
+		if (!damos_va_filter_out(s, folio, vma, addr, pte, NULL))
+			*sz_filter_passed += folio_size(folio);
+		nr = folio_nr_pages(folio);
+		s->last_applied = folio;
+	}
+
+	pte_unmap_unlock(start_pte, ptl);
+
+	return 0;
+}
+
+static unsigned long damos_va_stat(struct damon_target *target,
+		struct damon_region *r, struct damos *s,
+		unsigned long *sz_filter_passed)
+{
+
+	struct damos_va_stat_private priv;
+	struct mm_struct *mm;
+	struct mm_walk_ops walk_ops = {
+		.pmd_entry = damos_va_stat_pmd_entry,
+		.walk_lock = PGWALK_RDLOCK,
+	};
+
+	priv.scheme = s;
+	priv.sz_filter_passed = sz_filter_passed;
+
+	if (!damon_scheme_has_filter(s))
+		return 0;
+
+	mm = damon_get_mm(target);
+	if (!mm)
+		return 0;
+
+	mmap_read_lock(mm);
+	walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
+	mmap_read_unlock(mm);
+	mmput(mm);
+	return 0;
+}
+
 static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
 		struct damos *scheme, unsigned long *sz_filter_passed)
@@ -916,7 +1019,7 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 	case DAMOS_MIGRATE_COLD:
 		return damos_va_migrate(t, r, scheme, sz_filter_passed);
 	case DAMOS_STAT:
-		return 0;
+		return damos_va_stat(t, r, scheme, sz_filter_passed);
 	default:
 		/*
 		 * DAMOS actions that are not yet supported by 'vaddr'.
-- 
2.47.3


