Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC851C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2616B00A7; Fri, 28 Aug 2026 14:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04B7C6B00A9; Fri, 28 Aug 2026 14:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2DEB6B00AA; Fri, 28 Aug 2026 14:37:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B4E3A6B00A7
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:37:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A400A0543
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:37:43 +0000 (UTC)
X-FDA: 85151536806.02.43C1395
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8D88818000C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:37:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QqZ0paMt;
	spf=pass (imf24.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787942261;
	b=ohphyUOj0GIdaTVhHPsXzrp8HInSSYHLof0Jg0FyA3njpOHy2RWt/8z91oVslqFgy0Iu8J
	iQYIMGBSjbfeb+DckGLMzBGS+0phiuu+9xCaX37Q/xSVKGxi/ILH2PrZLkA6VfTnMlHryr
	uuCgZXn/aXWSFsVXndSzK58Hhd+E3F0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QqZ0paMt;
	spf=pass (imf24.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787942261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p42zDyAV7UZaUy//KUdiOCk0RqqsUcLlIr4kopLObvw=;
	b=XQm7L/Te9v/yR6f9CdfOvAJoZjlSltCfVsrIXzNKD2yCW9Rb/Kn9gApXuoXA7Q5tyG/wws
	K8SmqHap3PwKcpQPt25aPxjpjrD/Xkha8FHLouaENlytXTXUfbkjaxagwY68ymyKCGdjcb
	LYqo4Hi3BPyrrETqyzWPY2cYlrQP2QA=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-85590c5aeabso1168041b3a.3
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787942260; x=1788547060; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p42zDyAV7UZaUy//KUdiOCk0RqqsUcLlIr4kopLObvw=;
        b=QqZ0paMtUxPsEYKgrpzQyQKAMNNNNHiZln7/7flDly3Wsk/7HL2CkQG7a7p4cMDJLq
         txu8dMCQiUBiRus48byRMNPlJ7w0/xeYB9tRHPMiL+lHLC34JhELGApCFbiM4m6zFKVZ
         3Js27yCEtKhh0gkIlc12eTxtvcJUOY826myVChjOZGUha1tAEj2YS0bBgMMLDFcVng15
         yYoAgWTjFLFLZLW1XRQZgBY3LBHElb1BZnvDVAGLb9XT7hMNgw0n5dPRlJDlXfdb+wxq
         1PWDUdR5DOUeh+F4tdviPSHrXRbPuv4HLVZ0+wXpIBcn7dFCAWnWlx5piDfAixVorQNa
         CR8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787942260; x=1788547060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=p42zDyAV7UZaUy//KUdiOCk0RqqsUcLlIr4kopLObvw=;
        b=X46KtMrisJNPdtribnRffvZhrMF1qNyYYda5d/jh7F9iwdNdjlGahNpCAl/UWnRNXJ
         hA3BXX14sJyVUJAWNwknWOOTCfFqOAGjJ12+BqOmYCCePbfGi9dBNFPHJUr/FTxzx0Fq
         yh9+o06a8w671An8MkMvCFxyJAOqR5lMt7OLOp8dvBXf0bWZ5WC7+FJ4cGpBKpU3ClwK
         F3OdUs80VL7ADjHqjRX+EgE/3x8B9cC6urO0uVLk00l3ivccH/8Alo0sZHml6bC0BvFs
         nY7Bxe3VP3cY65UR2CrJYCAG5oEU8M50VWkRS+ORSm3fSKZ3LcUqzcTGOXMCnCYahfXz
         L5yg==
X-Forwarded-Encrypted: i=1; AHgh+RoqYuD+AEQSDA+uVz15XF6yL9LMT0L3gE1eDH6fOtAa0xVdaur7C7AaCCCxF4BkIhoj7wZJSJOU2A==@kvack.org
X-Gm-Message-State: AFuF++n/zrQEfQW6XobmaTAS4YcwYDBuoeB/hg4yfBajunzIDk52SuK2
	6BsKbtF6WW+Becc46c/Gl4ReMOq7iNF2wEovtVK5HR57QwKQQ1NYqAP9
X-Gm-Gg: AR+sD10SIvw3KViDf8Br+j0aBMYopJbaZ+tFNv3Idynuj5ym1eX4BBGxt8xLkJLB0WC
	IaZ7ziA2KDi02lWKTQ0LGK0eCuAMoeyWw4WsoJ1YHQGfcdOD+yz6PvDtVoA6UjgWyskB6mrsTsR
	uPPbPK7eFI2yAaPZMbSkeEIu74mANlgD2IaiX3opimeIjOM69xiS997zF8LyiZ7dITjB+kJSv3m
	WkS7DUahJCM4bT5TQY+W9wKLV/c8n+g1J/7Kij/o9+WxOmcAx2eHOn5Z8p5AwdNgvPZoI/EYQRe
	hs5fVrec9zgIXcarKCZuExwXPaa86BhhAzXe2v6Q6vKgFmSQjSA58jFQrVTS0tDinMNL9d1opcf
	pqA1oS9c7mJ4l1M6Ko47MDps5AcVG3IuiAp/t9vArkFdo7xs5RLYiFbLPk8qs1lygGjzh7aYNxH
	yq+G2umz6DLlCXZc92LZWtilfiY9NYptvxiCU7G2Y0DNbfiO8KtWhD6+w0eyQjhXfQVG1gzojF8
	n0SW/dV0g/A1Fh2g7Y=
X-Received: by 2002:a05:6a00:4f92:b0:845:dfef:75b8 with SMTP id d2e1a72fcca58-8562c04ef5emr16403554b3a.15.1787942260279;
        Fri, 28 Aug 2026 11:37:40 -0700 (PDT)
Received: from aig-kmd-01.. ([120.133.49.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-856a2ea6fa3sm844230b3a.37.2026.08.28.11.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 11:37:39 -0700 (PDT)
From: Yin Tirui <yintirui@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	"Liam R . Howlett" <liam@infradead.org>,
	wangkefeng.wang@huawei.com,
	chenjun102@huawei.com,
	linux-kernel@vger.kernel.org,
	Yin Tirui <yintirui@gmail.com>
Subject: [PATCH RFC 5/9] mm/huge_memory: dispatch on the folio when splitting a huge PMD
Date: Sat, 29 Aug 2026 02:33:15 +0800
Message-Id: <d405f7cba179d5383352f88cabe563eb900eaf20.1787941780.git.yintirui@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1787941780.git.yintirui@gmail.com>
References: <cover.1787941780.git.yintirui@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8D88818000C
X-Stat-Signature: hgwty5gg36durwziajy5jfrbhwyzyax1
X-HE-Tag: 1787942261-765968
X-HE-Meta: U2FsdGVkX18iokpLeqe/QcL/xdhl+08Uoo2AMwsBWoAXvTV7Mll8PQO2PC8U5f05j2EHyRZMWrgABQ6+d+3zqHJEJafF4svCQ8RX2GcB18lk2QK295MIEEqLyYdBTCmW1Gnj7gGWYve4xM1I+iHb3skigP2PrUR1WftShufekKi0OUZkrIGLDwpt9nvj9bqOlqdAProdAiI+vV6D1IZhxd56LSJ77rkH+sv9gtGkjdJiPHJZ01eMTHq+UiPkNTPGyqVV9fRE51UJGcoHYoakPchtreqSW9gyyrrGruSjiiyL2kpgMILdoG+NjVkK8SBuPG+HxjzP1xcHa+wH+K/l//iKmtIINIXOc5wQBgD9QbX9Yf8fIGsgyk7BQZk8loEgPcTuw0mbKJJRTjQ5PUc/bR2upC25xogA7ocdzPAufC2gsyfUSWBYSrd/BsrUKLcpEKwqzUClXd8aZgIQqDD2KtpZ9GD6eLiUjwlf7WtbdRRwYFuTqN7E0gJeN/qxVeMf2zDJi0P4fvpZBTpG2vMuLvuGFts4IuyH3QQU6W3x4c+/LjqbJ0rU4+B5InW9bdwvJSss/Y4oYf4pMzY9FzSjAkWUCvBC/BDqver8NkF8SVOwcoWJp8CooueOdv6x7ISMvMGqG4SdCrr+N7lW2WnYWgmMOKeYBojKZ73carexzeb5AvrsxbP/DMRdULNl2XGaJLpJJaoJzFhG5dWSIs6Mporz6rG0gNrk7mgk8xTqKE3tvG0EulZfjQnsA5KV2xHuGlXSPE1Duo4UhzwMuu8OYjiRlieqhPtE2TkqYSEDixp996yC0UHaqffo6zmxN8VyuF/8GPku/Ecv5IOX1WPhdFFy4kFDDi+nkUhO+MENKgboHwpGUPZctdNyDTSGsaSprgb++FNtllOWu0422NtIfAsdUO0F85ElAdMihHS9C9pKe1IMgUq03C/o1YmBbUxLr2uXywjVeN9+e4e9Eq+
 AtJgn6oP
 gmK1TF1xFUZzOCqMwwae/ogOdiZ0lnIDNI0qN2hVP0k8UENvhWSUxnI6kd5/dlCyBLr73/XPQCEAae5wOcQSRyWoCPI3w08buJFGlH9FIuC/OmsxQH8btAnPn7QT+kSuu2R0B5aNYTXQ31Y5ZKrxhkEoqUjgs0viDY9aC3dGewdhP7Vgojp8tXsHtLF+JetbrNJGLXzVBEKToCLzbdu0YmG2doG/t9cWa/C3t0ULVhCwkN0dGFFSVNyu1wMCI2VZpb+vJ1f0Z7+dFftnOKQitRMqRYKw3N8g4nVS+xn0QvQNSbsHbE7AxHxDCiFGzQfS2FWGyMfZPE0rs1weySeyTpkv9BiTEhS1u2dVsMhdfNe3DEky9FgaHtZFVW8R+9EP+goLKYD2pQQEIW0Dajkccb4Acj4zY829AErmzZoC+xgbtuyY5wRY9/jhVhfW3EtU1R08ufa5ZX30X5bM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Only anonymous folios carry the anon rmap and PageAnonExclusive() state
needed when rebuilding PTEs, so decide the split path from
folio_test_anon() rather than vma_is_anonymous(). Treat a NULL folio as
nothing to rebuild.

This only changes behavior for folio/VMA mismatches, which are not produced
by any in-tree path.

Signed-off-by: Yin Tirui <yintirui@gmail.com>
---
 mm/huge_memory.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b2ede9a6ae5d..1cd8878edc1d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3244,7 +3244,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	if (unlikely(!is_present && !folio))
 		return;
 
-	if (!vma_is_anonymous(vma)) {
+	if (!folio || !folio_test_anon(folio)) {
 		unmap_huge_pmd_entry(vma, haddr, pmd, folio, is_present);
 		return;
 	}
@@ -3254,14 +3254,12 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 
 		entry = softleaf_from_pmd(old_pmd);
 		page = softleaf_to_page(entry);
-		folio = page_folio(page);
 
 		soft_dirty = pmd_swp_soft_dirty(old_pmd);
 		uffd_wp = pmd_swp_uffd(old_pmd);
 
 		write = softleaf_is_migration_write(entry);
-		if (PageAnon(page))
-			anon_exclusive = softleaf_is_migration_read_exclusive(entry);
+		anon_exclusive = softleaf_is_migration_read_exclusive(entry);
 		young = softleaf_is_migration_young(entry);
 		dirty = softleaf_is_migration_dirty(entry);
 	} else if (pmd_is_device_private_entry(old_pmd)) {
@@ -3269,7 +3267,6 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 
 		entry = softleaf_from_pmd(old_pmd);
 		page = softleaf_to_page(entry);
-		folio = page_folio(page);
 
 		soft_dirty = pmd_swp_soft_dirty(old_pmd);
 		uffd_wp = pmd_swp_uffd(old_pmd);
@@ -3321,7 +3318,6 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 */
 		old_pmd = pmdp_invalidate(vma, haddr, pmd);
 		page = pmd_page(old_pmd);
-		folio = page_folio(page);
 		if (pmd_dirty(old_pmd)) {
 			dirty = true;
 			folio_set_dirty(folio);
@@ -3332,7 +3328,6 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		uffd_wp = pmd_uffd(old_pmd);
 
 		VM_WARN_ON_FOLIO(!folio_ref_count(folio), folio);
-		VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 
 		/*
 		 * Without "freeze", we'll simply split the PMD, propagating the
-- 
2.34.1


