Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB86C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 23:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51EF58E0003; Fri,  1 Aug 2025 19:00:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5218E0001; Fri,  1 Aug 2025 19:00:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4688E0003; Fri,  1 Aug 2025 19:00:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5D88E0001
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:00:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA0D11346B6
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:00:36 +0000 (UTC)
X-FDA: 83729709672.04.96FE1BE
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id D9DDC80011
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:00:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ToFBK3lx;
	spf=pass (imf30.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754089235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7UIQftffFi5dmDZFojFIrkTA5pAdhvl7y5sSZY3E7b4=;
	b=MiHbGXu/Eojjq/+Xa71vbR/XRWRwqQhrvJsonEvLDpG9SFp/pYel5M+kt5NUZyPKOrK36r
	Pg+hVCRLuUff5ekFAjbc/Hmee8dVgcuZ0n8hx6n9KN1m+RLwtTOHFCVvN2WjV0Q6YVTCgz
	QJle74F25DLDjjyZLzGkyKec5jYj77Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754089235; a=rsa-sha256;
	cv=none;
	b=KbjdOcymktleSW03Uzt0HZmXPBcvZx6NFw5sUL+6nL/ZUeg0ltus+ZF1fxmu2sJr6TOS6K
	ytgDeLS3TgMrmiTQgjdAPFq6lsCsQn4OtEcux2d7mAAeai7p9KvGOHwRqSsAKQv7SWyUkp
	4/edbNz02Ztj+ahoUFjG91REVVoBKxU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ToFBK3lx;
	spf=pass (imf30.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-61589705b08so5447951a12.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 16:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754089233; x=1754694033; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7UIQftffFi5dmDZFojFIrkTA5pAdhvl7y5sSZY3E7b4=;
        b=ToFBK3lxdI7LVBAa+9yEAveaUEfGXP8FZlihrABzp5kH+Pd3KgGkT2OSJHsGfD1tv2
         uKdILXbPTADiaqjScRQXkOEWfMD+hQTrzkLgi9btgVpshx6tsXlrjJ27is7q8ca7V9mI
         /NYagRUJgMFE5S0gEE94XmCJYXSBifush8eFdz6jqg8FNIsOsvXJj1mDQluWOprWplXw
         oU1/9G/2ouazSKYZYMHA/3GXohfPWiAmf1gFhp3dbk4CLcaEjk+m4JABVdLSGZyP4dLs
         crra+6LuMuL3LyIMoLe0WlVw37XKXRNWN6zbbsc00rSKKJ3WIXmLzb9U0E2U8ozvCAeC
         bWOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754089233; x=1754694033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7UIQftffFi5dmDZFojFIrkTA5pAdhvl7y5sSZY3E7b4=;
        b=a3ixZVu+NCEHPhlf1MWfpOjn0kylk/R8dqr1prfo71LrgMvD7tFQNacz6/BCpcsf2Q
         MstlVwUd0r0Dad6gV08bSLyvrTBt3JSXVEqpCOqUtFQONs1UQ7OfAL4MFgHoPdPcG/uk
         HSJ9RPqayXGAoxYbkImCEEHCVovmG26Nd75XFmlZ2h2DOwvYHBJCoZxhdWbDF/IBnsym
         Hp+zBnjW4BBAXSWzUzNWr7n2+h2xqVCelssGWN2tl+xskWmeDNse80G2vMkTc5wbNx/n
         f2ZMYoHYFHEsMd8Ihb/9MnC9aJP4tFFbW0Y83uUn4vgusm89pfCghA8aCbmsQBLcK2BN
         twVQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/cWWizd22lDJ6dVUmWy+tzqVotArbeqk7gq26EKB/iyf1ockSbbdukTKBwee/0vIkzE+3UusTHw==@kvack.org
X-Gm-Message-State: AOJu0Yw8cXO4PS2fa8wawRvdymMXk2AOcHD9aXL36wAL1SQuzcRuUURT
	nQVKOtBsbJ5GiRmYENFXRMEirlYS+GcY5JvKd9vnTVSY9RMnNGLCmlM/
X-Gm-Gg: ASbGncvGWvrjYKlwL3+OxkU0MoMFATcdUc70MzfF5NF33T7JnrLOb+jrU05qsN6r4kj
	4P9GR5Royyy+RFSiEVPO7OaK2QfAmYond1no+wkI/mDo6Rq80UYTt4sVcmE1RHbHf5K30/FtTcO
	qLP94uM3WKeibbqCKpuLlHZtbfBw+L/uIkHj0c9IVz/rqA6R7geH46sRYobmYgUUfJZD81yQFhZ
	043G3cJSUgD4frt9pQSOCubIxUNX5ZqIgDUAiKk5MuSdYILcQPRwCN/oeQiTkSPZh3qUhHu8N66
	afwHGd9vUq7/tWIkfkXdRd22Mhs9yrW+xYFISH403Q/qymsWkjLgSITKgFGeW86psEd7dYuoTJy
	Q2VYr7ix2ifF+uNBifOXpa6vC5rG9Vjhur8AH+bewwGG6ksjikyOynXepEwkh6B/h5W5C9pXqdi
	Nz9ip0wQ==
X-Google-Smtp-Source: AGHT+IH5K61GDg0ZUw4ARCfYbwftv+OGfOfF0Y0bqBEfg6jRNeqG2wf12EBb3f41tEzQLAjAwRKi6g==
X-Received: by 2002:a05:6402:3553:b0:615:9c3b:17f with SMTP id 4fb4d7f45d1cf-615e6ef235cmr916363a12.15.1754089233322;
        Fri, 01 Aug 2025 16:00:33 -0700 (PDT)
Received: from rs3labsrv8.iccluster.epfl.ch (nat-icclus-192-26-29-9.epfl.ch. [192.26.29.9])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8ffa17csm3279290a12.49.2025.08.01.16.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 16:00:32 -0700 (PDT)
From: pyyjason@gmail.com
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Yueyang Pan <pyyjason@gmail.com>
Subject: [PATCH v3 2/2] mm/damon: Add damos_stat support for vaddr
Date: Fri,  1 Aug 2025 22:59:51 +0000
Message-ID: <88cc271642476fa6025f3789781dfc8c2f576eab.1754088635.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754088635.git.pyyjason@gmail.com>
References: <cover.1754088635.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D9DDC80011
X-Stat-Signature: 9q6xw64bpiqfbmfw3foh8icph53p57y8
X-Rspam-User: 
X-HE-Tag: 1754089234-118951
X-HE-Meta: U2FsdGVkX1/1tzH6MNECI9Ru/LP1SNIezVbGgBtIzabLM8QA3F3GwAks1h4CmifpwgBzgZZU0KcAaaINryI3CcNV0evZk+1QPm6psVaTqs7iM6WnN3r9lsgnyv0CP9kJSwOGgxOqkiS8W+Y8wBGPw4rY2yO//ZrHJwxoDkiy4j9A7pc1lKdRhBC9oCKCNo/N6YGbltG0NJbbSXlkdYA5Phd01el0baoHpwfSaL9RW7cHbgk2tnaEtkI9DXZx6eyyhpc3qZrjvCIy7HB5GRfZqZDWYGSM8UpWZoqzKOtqeE5WwQd5ots0fCH2pIwUfVwrl21CbFtv3CF6rXh2jG+MDt6mJtGgRfuAQg5B0zhNTJ6vPLccwdMcEuDtgUU5uLrR9g2F4RVivK70dlc6jf6+LFv9oiQ9TO6tjmmG4Ai30TbjNWgTiXtksaWD7cC89tb3b0mzClfXwC7G4rsbWAqeFHxuSRw0sHny+WbjO9Hxd0Y9KysAD8bt86XJ+zGMFirlJsoTBUZunCIYhP6dcpXoKnCJYlAk2eYSv3Wp3Oj7tFXxQQEoIx3TFqEVcKQSiiMU8b7UMCuLPnvgv0OyGm73Pshji1jsRFSgS/XWktXgeMRf6LVaxjZFl04D9FWUsL/DxjU6pzRL4ELTam9CjnntVq5H5vuoYDHJasnm+fVMf1WhXsm6SBavIyO5fnJXgE5tFqXQDNiiWyqm0SKUzcNksEI81zVinUzH2UNzSL79kmlP+BU1jjZ4SVAp96Iy1qMjJk7vz7MMNj1ffZmQ0Lcpo9bXoZT9v+ZUtDjENkqokCe2fEUbIyZWdqrKoBBhQNLXXs8GqbaejzAy0VZttkY97cVUZb4KvMCILo/BCN7G2fw7V0Zascd8bMZ8lI7YEMKNwVWRNQwGX1b9ItrB3ClaWYWS482N/718gtYGqV7wvkjGWnCDvZEzR/M53WjguFvsn8Y/wl7mJX7UB309qxz
 DqThhWon
 Z8AlcqlRhwhhs0rKY2yg+WcIsvYK/2XWDd09lm+IG+N3t3zFffX0VN8YTOb02oU+PPjbdIZV6H9NQABMy5r4O7hW02f6MWFt0zY2Kf6KmwrjRxc0ghr1+11ilPFSdvUR9XSWvixRsOaE9GcKXryfj0DthDjg7D+gzAtK69eS0vHBU8k25xjBOMT9+85TzB9kQTfeZQDovRbvxPZFdvAnfuPsrW6nI4So9hpdHyKrBG1kdPqsW9KN9sQ2HPcW7tMwZMaKqSD3amrCVXFBaPVwP/9mMGPWzYjLvwnxNPza84kMxldbGZKsNbSaNdJ4udZxm/Di1JivDxdGwnliieLuRkLR+IALNpfTRzS1u+fbN5SOzXrc/AqXNSTiKsauYeYyQlwzdMqADMc/Ii9VTKMDHi04D6O0JgxkutPiY1B7DLkWXd0ZCQsfc6qfwl8cPUGSEDP4kssjMFlkcBZpzOaGGYnVoqGb6XSCxTu3xSVfLS+oUbJE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yueyang Pan <pyyjason@gmail.com>

This patch adds support for damos_stat in virtual address space.
It leverages the walk_page_range to walk the page table and gets
the folio from page table. The last folio scanned is stored in
damos->last_applied to prevent double counting.

Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
---
 mm/damon/vaddr.c | 103 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 102 insertions(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 87e825349bdf..5960d5d36123 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -890,6 +890,107 @@ static unsigned long damos_va_migrate(struct damon_target *target,
 	return applied * PAGE_SIZE;
 }
 
+struct damos_va_stat_private {
+	struct damos *scheme;
+	unsigned long *sz_filter_passed;
+};
+
+static inline bool damos_va_invalid_folio(struct folio *folio,
+		struct damos *s)
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
+		if (damos_va_invalid_folio(folio, s))
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
+		if (damos_va_invalid_folio(folio, s))
+			continue;
+
+		if (!damos_va_filter_out(s, folio, vma, addr, pte, NULL))
+			*sz_filter_passed += folio_size(folio);
+		nr = folio_nr_pages(folio);
+		s->last_applied = folio;
+	}
+	pte_unmap_unlock(start_pte, ptl);
+	return 0;
+}
+
+static unsigned long damos_va_stat(struct damon_target *target,
+		struct damon_region *r, struct damos *s,
+		unsigned long *sz_filter_passed)
+{
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
+	if (!damon_ops_has_filter(s))
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
@@ -916,7 +1017,7 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 	case DAMOS_MIGRATE_COLD:
 		return damos_va_migrate(t, r, scheme, sz_filter_passed);
 	case DAMOS_STAT:
-		return 0;
+		return damos_va_stat(t, r, scheme, sz_filter_passed);
 	default:
 		/*
 		 * DAMOS actions that are not yet supported by 'vaddr'.
-- 
2.43.0


