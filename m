Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 250DBC55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 12:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15A766B0098; Thu, 30 Jul 2026 08:24:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131EF6B0099; Thu, 30 Jul 2026 08:24:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 021806B009B; Thu, 30 Jul 2026 08:24:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C944C6B0098
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:24:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 521E1120130
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:24:16 +0000 (UTC)
X-FDA: 85045360512.10.3117F8F
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 89DAC16000B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:24:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="HVKk/U0b";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785414254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/RGpHiNOj0NcL67RlZfv7xKhE6bvWiukeFGqq8NSX9Y=;
	b=Vz/X6w060tgDjrw8a/x7qY6K7h035BeRal5IxYYZT//J/qcF/zh7W4LS3+naOGgA/no6v5
	goXm6QiatYkZ/qrmlezEXZSRjtAPm0RiPuzdrf2gzb9JLF9qKOM29qu3Hw7hXwPANLPwc/
	u2KmrTu1s6DJl6MZdMkIY46aYePndJk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="HVKk/U0b";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785414254;
	b=EP+TaYYXGNdIwqEU5ZbVhxv4m7O/9ga3COj3ImrZIxez6qZaIi4PozMD9BombykBCVTP94
	mMjumQlXZOBiowGfgYxGdbVrrnzcdtuKEkxdXg65LWvDIiVV3ubg+R7UMKGnGgMTWzG6lx
	5jkc5gLQDjHPNGXaNUNXkCjZ9FnrqYI=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84e252fbb7bso178536b3a.2
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785414253; x=1786019053; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/RGpHiNOj0NcL67RlZfv7xKhE6bvWiukeFGqq8NSX9Y=;
        b=HVKk/U0bLGt0jC3Xx8A/C1ZJ+pmia0W8OntGxaq7nhubHRZLZJ741ax6ezfURELJJU
         yaGHJMXnz9/NbKuoJ0+yr7P09pi1zRkBTprt4tcLqxgjqyaXcuB6ZEri8m5A4UM3f0u5
         tv5jPiPFS/jWlqemmLZqUKKgd6RNzElVebaCGz1hemnCLX7XwVEnGdTapcOrZ0A1XjUn
         08WVMRbxtMvjfP0Qbj+RxkwMmGrMYg226BpmEleMunAy7NmmHiimi+UOs0AZsbXxpOB+
         2bSkmxoQ4yRxS/szbiGNDuCl9TfABccRL2ZPAZJWllZceu0iY1ELIwiljswANdXtZVwU
         S2kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785414253; x=1786019053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/RGpHiNOj0NcL67RlZfv7xKhE6bvWiukeFGqq8NSX9Y=;
        b=MkCMftqhtMIwkYpSnYky3sXaBAy2rckgac68ifBOImptfOl72BAu+nPHtOiI5VzUZq
         a1pvik3MBcSq8l4nqrV3AHwi0diHjixoJy+O8x7+cqRK/4Gr5iJbLJlI9QIDocPsEjhb
         pIqBymbZSGVqUJRSTz29+Zrrl3LEHDXGRHMjkTr1s9YpmQUoMfnetioVAQ9NANZYMxP/
         zyxxNarYEIU6q75NM35Ox8uUfD1G3d9CLar8BhJxKXblcp9+3/ESknBVaAyLHIk/pZmM
         m2hqMSjR9Vfph3ViAEMuzVb9741uXAZQ+aUEjFPFjB4xbgQHpozaJJuo71mgk9FGwkc1
         JQXw==
X-Forwarded-Encrypted: i=1; AHgh+RonxRxYMsFHGBCp4+CijbP7cO5JAm04id2JtciId6lioa2RWQrTi12qTHQbtzAOg9j8LpBf0hYLjw==@kvack.org
X-Gm-Message-State: AOJu0YwzLXdwlSMIrDAEnoUo4olWWI+JlAy0R0EJK8b0Mnkrsdb4Goa6
	+ycT9Nv+AjK5Eomx8Czr6tppH6VPlxSKmoa8NSZgqr2poWrLKZQvyrZ6fn0sBwHMLisYkghL
X-Gm-Gg: AR+sD12GJEMLgaGtSXNIif35wmjkyT8hEKiuQZofIJL60Y3zzTHhEdmIUks8FeBCFIi
	Acs+fyvyaYzzCGfU3hH3rSJOgT+WDIgz76n4yh5ypX7iEfZ5xF6Zg4QMwCJsUnFtxZDBQv/HFVe
	Ei7LWTKs206iY6UdMfpeOvT4hFrjiG5SBqQ1YQZqSpcc38zaLY8lGNTL70nJstmymwrgnqh/UQP
	K4FE+Ey/Y8PezQWFRsrzoa2QLnxJ+NAra18BlqMk13pq3nZ+SYui+XTQqKCOv3xOKQgPFTNNVZK
	ng7JE9f7phEwk3Abrydd4uEiDKBnIO2dpPIFZvLLcJ2oCf7TetlEQzw+c53GwFeXK4G4JIRdBjY
	xP+6b6bw3aPFqFyLXq2lYrPazDOKneIA52iI9IilsnxqFsAwcUKTcfeWogueOXtHJCTyWzI5ejw
	qUrCpm6X6OOrgvQlFO3JbQXEo8veX0sch7J9vRC+MmsMLF9NAW57CUNEokSYspo6I9FdLXFbZTl
	uhH3oadYm3HAPOhroohluZbvGx6Sc1cHM3blAhtdzF7KNKyi+Fv
X-Received: by 2002:a17:90b:33ce:b0:38e:549:9e04 with SMTP id 98e67ed59e1d1-38f9bd12949mr2653937a91.1.1785414253215;
        Thu, 30 Jul 2026 05:24:13 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b72d243sm995698a91.10.2026.07.30.05.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 05:24:12 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com
Subject: [RFC PATCH v5 4/4] mm/shmem: split large folios only on -E2BIG
Date: Thu, 30 Jul 2026 20:23:04 +0800
Message-ID: <20260730122304.2496440-5-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 89DAC16000B
X-Rspam-User: 
X-Stat-Signature: wd4hrdxime78jh3e44mrr8niyy9gq8gd
X-HE-Tag: 1785414254-535399
X-HE-Meta: U2FsdGVkX1+YOk/WZ2WoLhgDkO8W+Tr3BdD8VpJ8HG4UTl9/PkF/coVFAuscZQxJGe8CipKUR7F6V7I2qVKFsj38DiYnjos3HHIKItFpkF7/3GaRHVgbnH03dDxhcugjl6TVQOrpSkARd8ZUAgwP0gUfqBxaoVl4pVg92DHOqLeBbSg+/4hiHq81PyPp/JxSsc4zQJooGf+ZfGFyPIvq8fWNtPZC1ehivrHTtEa/mTKGxeV6DQ7goWp5bn7Sbrhts7loEGXbgFbC2oanp9qb7CiLXcJQ8uNE9w41KwjP+tjyNQtdTMNEFgnlhjuaQ8M0S7Algv7Z+h2Kt0BHWDtSZC/rFOtB9MkyMj0iEbvUtD2gVZwjXzETKwsvpPV4iMEja8nUIHLJDjQxNmY20uAel5VG5835gOTIIsLe2W4Xl4zTpYd4EAd9Vo/3pTkAu/zelTLpy8123OV9FwwotOaU2ENFlw9mr7tN1Iod3uCKELQ2rQdcY+qU/gxOHIExGwoouWxl8bApa4Nxnf9zaM5WFeUK0dObgi9okd1AEvXuXHA4Eubi2s6d1GjtWjlIHkM6RHAlP4hVqdW7Gv/Eiq8t+4p18E+BTFPsnq0+gzCziQ1sNCFSFeRFOj81sLTh3uzWkd/dIYk8ZXYzKPC0denOWd0xqvkGTp3zU0zKDN/G56yG46tdYyJpvXp7GMZP/RE1EktYZ9Z07IYYXC2qxN3kw3/kDSjaHcU4zCTjNYHml9M17HUrAhjZ2Hy4+YnxuEhpgqvK8unv1iRdbvFDAyg6FH74LIs0WFHsSEH+0KcOORRLZmydDIVblZHuN7j/W9xD20zZGfgobQhM386vCCFKqM+9gcrYCjaldTq0rsPZPmwN6dfhqMHgx0upvo0noDh1M4UIInmcOO3SBRIIKpSnZCFpgBb8wKKrvYb+nfOPQQ2zbvoDHgAtKhiU9Ieok+oIr0jmnu/Opu0joc7R8QO
 gMfyNwPV
 IkGRa2EEUI8dL7WaXUytNVGHA0ZDiIc5uxYZggJwiIpdZtAkILX8CW1HlcB0S1pitH4pecSqwzpc0QljB4lK2aJ5nwT3/mPXniWUJHDAo07xak4HIts5LtmXsm0OAuryEJ+83ds0n2jsxuR7EfR4GxbeMSzj4NRnedaVh5WUBFn5/F12fywNT1SssK3QwrqJvFPpuTpJYGvQ8xu05anqYEX1nmNX1S/kw/oNBk96BS6P7o3vv+LoOMWkc2/+Vs/piXS/XRXtsHSziqvVzw6ZCuJl+9LjiTd7WYrfskzyMstDbxTCSHPyxldTEPONq06kNLvq9ezfcItyjJtytOf1lopAJJucOGnXEDIZuNUsRKtz6etJ1Ggjquty1uRXfimqHb8HLp5bT8vtNkMos78yBiLFvg4hFMFMARdGwEu4W33tlD0Nq78jadtzvDWk7YGqYZPqHZS8avJir15+77ed1Vc5JHDh4+dLZl+U/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shmem_writeout() currently splits a large folio on every
folio_alloc_swap() failure. With the refined return-value contract, only
-E2BIG indicates that splitting might allow smaller folios to be swapped
out.

Enter the split fallback only for -E2BIG. For -ENOSPC and -ENOMEM,
redirty and reactivate the folio as before.

Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/shmem.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 6641823bed16..eff38bb33d8a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1608,7 +1608,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	pgoff_t index;
-	int nr_pages;
+	int nr_pages, ret;
 	bool split = false;
 
 	if ((info->flags & SHMEM_F_LOCKED) || sbinfo->noswap)
@@ -1689,7 +1689,8 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		folio_mark_uptodate(folio);
 	}
 
-	if (!folio_alloc_swap(folio)) {
+	ret = folio_alloc_swap(folio);
+	if (!ret) {
 		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
 		int error;
 
@@ -1742,7 +1743,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		swap_cache_del_folio(folio);
 		goto redirty;
 	}
-	if (nr_pages > 1)
+	if (nr_pages > 1 && ret == -E2BIG)
 		goto try_split;
 redirty:
 	folio_mark_dirty(folio);
-- 
2.47.3


