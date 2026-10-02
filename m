Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AAC2CA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 14:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06CA16B0088; Fri,  2 Oct 2026 10:15:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0439D6B008A; Fri,  2 Oct 2026 10:15:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73756B008C; Fri,  2 Oct 2026 10:15:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6EF16B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:15:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4AA9514070F
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:15:49 +0000 (UTC)
X-FDA: 85277884818.19.D8FA3D9
Received: from mail-ed2-f32.google.com (mail-ed2-f32.google.com [74.125.228.96])
	by imf07.hostedemail.com (Postfix) with ESMTP id 67B6840011
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:15:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="lx3/WOUC";
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 74.125.228.96 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790950547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zcpSt1gDUaHzC+rz1E47o28EjRtid3BchWuzvfuo1o8=;
	b=zWtKq2g3IjD3KTHWzJZgYN83guvdNOFTglz/5lLGSb5ptQ0rYQXZ6rEABE67SPYKnnBgpb
	gNpmvjs7Z0wKT0XwpwSPx2sRu+59opNT6dpwx86Ok72k2D6nmqv9XNHHBoeewRoT7FCOmL
	ZOjgw9FZObiGJr86dWSmDCGsI0/r0zo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="lx3/WOUC";
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 74.125.228.96 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790950547;
	b=CEVBqmt0WneuH+sxNVAuqWh8zutJenOMhmN7funfrfE/jXnDVvsTvzgrcLY1GT4Vv5nB09
	YHPzNzu3D21EMf0d/Exb1BerIqZ7E2egA3XyZVZGkuHihYgVR32GOC1hvAL+4tDIdIfV5m
	DFBo8y13B49tVleQzsyVjqI0DyiwK1c=
Received: by mail-ed2-f32.google.com with SMTP id 4fb4d7f45d1cf-6ad186afdf4so6138265a12.0
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 07:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790950546; x=1791555346; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zcpSt1gDUaHzC+rz1E47o28EjRtid3BchWuzvfuo1o8=;
        b=lx3/WOUCAuIzHDWHc5jUOh+r35MHGuvEWlZMw6LuNFBqPuwq6IdeUY3fgRvLrRLzyO
         fKakRN2CqyBAwvtF2K/9agGsJc5W4n0BablfNPG4lKTvTtw3uDjrKogCKIlS1byHu8Eb
         E/ID+jL+nmMJmXrgGbbeUVTOxt+26EQLBmXiJCcVoqzOiJG/HRjoxruwDDA1Pv1jZzco
         QgSyCBd4yNQcwrkII/r6Eadw6A7uztD/F6yyMqL3X0rtX/2HFQF4km42h26Q6dTQdMDY
         h/gs/bHB6bMlxiP1H0+sL7CFVeH8aZn4J9PJXnAXsUyWKS96fXGRZ+UUrxa+oSycAWxK
         3Sjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790950546; x=1791555346;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zcpSt1gDUaHzC+rz1E47o28EjRtid3BchWuzvfuo1o8=;
        b=gbnwFkiQ/U5M5sQgLkzb+Ez+gngiLE6+I0+O5A33nb+S591fuDdlW/gl0NPCBxA39Y
         J2nse0J/zix3IO/ulZmHpdO2oTJpq6nEpDP1JXm0FC47o1JaPzVrUqkF2oUAaT4W+KoF
         QQW9MkobQ/l6otEkjPcd2i4zmu8K94GISt8m38npnfZNGE4I+JOpZVE0PlYYj5BmLKZK
         wsTVdUuRp7WGIB5JiKsh1WuuHMJ8Ieg2ea7MyqS3Yjj999PGv1ZxZv2QH8cseSLRE+GQ
         O+Jc/U872IV74kNCRQKaMUJ2waJkTjggED+hNECTGaRfZmCe9DV5LukLOaKlSH2GmBuT
         KEeg==
X-Gm-Message-State: AFq9FYLaEBE6rj+kI3KCDuGayo+sK59v/C2PhldnhrkKdghs2HyGu+j3
	i3PgoWXAVwIDaR+33VdVw4yWjt60UATVGa1ZbSANdio9ht9P4foQC4lu8r6VxHsKqM4EWm6aGDr
	gTIvq
X-Gm-Gg: AYBFou2gnXDBGz228cV5okdoklPNBttjQNcI0l6nIjRYkXWTIcg6mQLReXSp/hzR47f
	JIUbRh1vGI0riWjD0RPObrIE8UE5TYETP3NqjeJJlhxh+yTFjdL8eXzTD75Sd7YfmeJ0lwGhNTQ
	jEQYSu2V/R/s4bGkJ81oznydsUApNkpQB6bGmpl96Z7sOnGnE02yTS2KupSwkdmBv46sPmtuuXi
	4xGzO8b3b172UqoT+Z7L3z9859PEyXRnJsQaufMOF8LU/giZxVNr3oOAp83T1up0nE4uR/Cf4Er
	4sudMATRFAAcTOtiyorFCVWBriE8qjJX8jIExNYkPg+biIqH+m7rekqxS+CLxMxkMw4VQmxidvh
	hhlrx/9mzy7q8wWlLqLWvx6hFWoNTrHplRrj+rpNEV4+HbctBXSxagZIa2ctw0fFUcwqZ2EvMbr
	g3Q9FezQzvzt7WYHdcMKrArzr89sU+UYD3UIkY/2YOH5x1gJJLinqWmAsUi8tntLp2Ddvp+B9GI
	uiC2H8Vaxr1ABrY
X-Received: by 2002:a05:600c:3e05:b0:49c:fc6c:be03 with SMTP id 5b1f17b1804b1-4a0276a0e94mr48124685e9.26.1790950060260;
        Fri, 02 Oct 2026 07:07:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.thefacebook.com ([2620:10d:c092:500::7:9b19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0394e6c5asm62670135e9.2.2026.10.02.07.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 07:07:39 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: damon@lists.linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	sj@kernel.org,
	akpm@linux-foundation.org,
	Gregory Price <gourry@gourry.net>
Subject: [PATCH] mm/damon: use damon_get_monitor_folio() for hugetlb entries
Date: Fri,  2 Oct 2026 10:07:27 -0400
Message-ID: <20261002140727.701709-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dph1j5d7d4zsd9ywsorytm595bng9o1a
X-Rspamd-Queue-Id: 67B6840011
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790950547-505793
X-HE-Meta: U2FsdGVkX1+Uu4yGCOeao0jKdnJBS12cqKtNn3HAs1WKBksAoxdGm7uJ/ysll1A2dHp3UKXTiiGb7Nfsuyyp7Ga/grHD3WKWlLTh/VMqjnDvBSDO1ID2u4Ird43URPnzw+gK8ftUDH/ce6XPJb4MDVxLn5vipSW0+3QWbhGmvvCddKpjcISHs7KuQXCpnaInfGcHikiHaREf2SG7jif0hO9CZF6ZMuOK2fg5ci3q9b3rRfY/s+JdsIuc8IFasHkoG+u1/Os58hnoAALXeG5/vnsHxI0XpB4PcQxtLjmNvIMzrS0dtrPBMSTlyIWoi+66iKOxhZ11T9igp3c/hH8fHxYYxMxw/u3qKOAIQ9skX8uaVMI6gJ3jkvUkfGONUFr8t7C0zQZAgszUJ5VJzZozIMLG5jx7T4RYL+gRLj4xujHQd07vyT9fQ2zZq+IT0A5cijAS2MnQUMxRrkyaz9oTkOh5viXv8SMaY9M8devLivORj/6RSONdtOHk0THOIdjJpyeB8C0BjIX9CWEv2E3WZOWNb3NsBhjsSLYVjjsm1nhZmPZ5JHzKVDmw7USNLX9eflRoxMN22AuvOzlFbvl1FxKsmKs6WplVI69nFOEndwX6KFb6RNQClnq3eupFG58yXSfc5VjEGHQw0/ujPTDXHe327OyPpCOJCCtHP/mfHU2cqThNxW9r8u13f/k167LnjJgPWpNOJeIUSoqyC/HOR1gFX6VwLCaGuWno98pXemO9oyy8hMmkc99otXuHc9haqflIwoa38zaG14mVIY5vZ8t1aPkZ6QSnv0SAbhL3uEZ7flqwvb06tyNsuvOf3GpgApX61wN8PzlTHm7R4VBc5Npjb0+8+0CowZejorqVVCl9Kl95FurscAxendlbwsjcyRZjVjVBAfZcAZKL5RTxDvsAbShXGgwSgFEpmltAIUALKztgJQZKnyc71QEd2couU0upWjPHc7CGH+YRRTX
 0bya9D64
 u8c6pea3zw6s9m9lD5WtThlYq4ouJS31dr7tG1yp8WzihFrNmsfaUN5s+2iZd/5tT8sW2pRixABRwgc21/JAN27qJaLcBZcREjYYPq8GdEt8MQckdaY7WfAI20gBybYJwsaDpFFDAK+r0aiswhX5kawvKeLGcGyXAmP6N3FW8H0DlO5DspONk/+B9jdZ4Cmk5ejnJMGRGy3TqLfbCTVTOA9LTiA6iHutvReKx4bmJ+NdDKD8EatAKb1mzizQiLFDPPq6OZ/LFiVh5PZBk236gGfQ5Ie0aMSECuNzYHMzXnfl7pXc09cSnNWg6a86uJYXIjlAa0mU5A0RwQkYC9u0Pxn4DJ3hHXUKuIsp/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Gregory Price <gourry@gourry.net>

Hugetlb folio acquisition is open-coded in three places:
  - damon_hugetlb_mkold()
  - damon_young_hugetlb_entry()
  - damon_va_probe_hugetlb_entry()

DAMON already has damon_get_monitor_folio(), which paddr uses to
get monitored LRU and hugetlb folios and to filter them through
damon_folio_acceptable().  These paths bypass that check.

Use that helper in these paths too, so that DAMON acquires hugetlb
folios and applies its acceptance policy in one place.

No functional change intended. All callers reach these paths with a
present hugetlb PTE under the page table lock, so the folio is always
a mapped hugetlb folio and the helper always returns it.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/damon/ops-common.c |  6 ++++--
 mm/damon/vaddr.c      | 10 ++++++----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 77366f42b3e5..f986d79391e4 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -140,9 +140,11 @@ void damon_hugetlb_mkold(pte_t *pte, struct mm_struct *mm,
 {
 	bool referenced = false;
 	pte_t entry = huge_ptep_get(mm, addr, pte);
-	struct folio *folio = pfn_folio(pte_pfn(entry));
+	struct folio *folio;
 
-	folio_get(folio);
+	folio = damon_get_monitor_folio(pte_pfn(entry));
+	if (!folio)
+		return;
 
 	referenced = damon_hugetlb_ptep_mkold(pte, mm, vma, addr, &entry);
 	if (mmu_notifier_clear_young(mm, addr,
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index d5dde97b3cd0..b549496ea8e2 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -411,8 +411,9 @@ static int damon_young_hugetlb_entry(pte_t *pte, unsigned long hmask,
 	if (!pte_present(entry))
 		goto out;
 
-	folio = pfn_folio(pte_pfn(entry));
-	folio_get(folio);
+	folio = damon_get_monitor_folio(pte_pfn(entry));
+	if (!folio)
+		goto out;
 
 	if (pte_young(entry) || !folio_test_idle(folio) ||
 	    mmu_notifier_test_young(walk->mm, addr))
@@ -660,8 +661,9 @@ static int damon_va_probe_hugetlb_entry(pte_t *pte, unsigned long hmask,
 	if (!pte_present(entry))
 		goto out;
 
-	folio = pfn_folio(pte_pfn(entry));
-	folio_get(folio);
+	folio = damon_get_monitor_folio(pte_pfn(entry));
+	if (!folio)
+		goto out;
 	damon_va_probe_folio(priv->ctx, priv->r, folio, &entry, NULL,
 			walk->vma->vm_mm);
 	folio_put(folio);
-- 
2.55.0


