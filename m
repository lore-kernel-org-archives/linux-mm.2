Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F19BC44506
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 05:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 560E66B009B; Mon, 13 Jul 2026 01:01:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 538D66B009D; Mon, 13 Jul 2026 01:01:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 279986B009E; Mon, 13 Jul 2026 01:01:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 069016B009B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 01:01:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6FC6C939C4
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:01:31 +0000 (UTC)
X-FDA: 84982555182.13.6AF0FE8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id CC3D920004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:01:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ntlp0W5B;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783918889;
	b=qJIEeegTkY0+JZ8KUNYMWPO/yWi7dyt6qp6LHTvtp34iI0YOK0DguHG6G1x4kmZcRAXIDV
	c2vU241And0IyNYyB0y3nt4xp76wTUNZhBNHoTc2HoQIzi10UBC98eIXOxaMSKwzkq3IF3
	8faJuOcp+63Wlb4o8N9EnzeChQGDtrk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ntlp0W5B;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783918889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yOWoQ/WWgh1zuMhLKAb8U2lb2gkA5JujQZwyj0DsvLg=;
	b=mWa5AoXZjbBROe1SNXFjuF9oIv/0oiNwF+/lVyE9yOKsA32B3RSVU7mWBM29zRVgjomdJZ
	0MNc2Rk2u6On2cJR4Zuali2NcWx+FcvSFtxmwmVJpMymFFZePBDxGcsBkwmvMQCslEJb1U
	Jeuqtc8SswYSAADanWci4qHlKX7LhSE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C313E1684;
	Sun, 12 Jul 2026 22:01:24 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C451E3F93E;
	Sun, 12 Jul 2026 22:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783918889; bh=KuaZLHuzy0dG06j3prcBZtyoR6+/OAf7qPsxNHf3+/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ntlp0W5BoL7iTWRGP9zkQL/I2E/SZILT9vka5i8uN2KgxHLkG3Rtz02kO6lrFotKb
	 gTTVE9SxEoqALxlukPuR74Gsv8SBrXwFl3a1FnBtvZ5CDqB+sUTDaiP6743moGBT0R
	 4WZlJoiJxFRuDXYWr6N2x+Krw0eCiT3oYlqzdRk4=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 5/5] mm/rmap: add anon folio unmap dispatcher
Date: Mon, 13 Jul 2026 05:00:48 +0000
Message-ID: <20260713050050.1017741-6-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713050050.1017741-1-dev.jain@arm.com>
References: <20260713050050.1017741-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CC3D920004
X-Rspam-User: 
X-Stat-Signature: f8nt868yen4jxzn66mztztoczuuqdigj
X-Rspamd-Server: rspam03
X-HE-Tag: 1783918889-160824
X-HE-Meta: U2FsdGVkX18oQvK9OAds8+CnL5SNZYWUMFw6bN2x/bKLbfWK8MBWti7wNQNxh4MGU9pvGDgc+p7yxe1+okEzXhhTzaZI/P0Z4COdTcqhYpNv9qpwCsQlai5fLAqHa2NLphDy08Enlnuv3ihFILjhz0YjeN310S/ELb7TN+PV1PTXnOjkzAq7yutwTztqTugYZps++qUgqqfwJS17tDaoLR3xhadlWDL+aq6W1Ln60AA79b2GzcEYIhK0lNmQyQeV7UJfBymMC1KNT2C0h11PJHd9olxoDQsV/Ho9d0Gm26qLUlgYJbd3FfXca55SvIeQdJePu4JLkYYcqGeKWxfIRlZjEVjmCgouAvT7tJYIu8J8xO2tq3rm6y/WCwflNrPU1PmogoSMVq7e34KkcBv25YIvcNRwKTg1vjps2YmAN5GN1agrjsWY24zLX2SSF9BQJfJ7PGstzdjtM7IF7io4oP9y3Rm2jy6khr4wcYnA20AmEuzNT6yvv6ocpxFH95Nv1xD312wV9UgyUVIV030HP6hH8raqMCD8r3NIQ9Is9KSUCg010mKP8pPuM+d2t/31258gA5jdqdN3mnY5t0FybuA5qiqntwdkPt5BnNzF/J+NcV31OMfXPDIM/xYKWxKe3mHFayYCa8sp00CvDzmODTMLC3OhXHQtW7l0gP8cK73JD8H1WkuqlxqhMVRLNdII3s8oVzPLKdSsIMkPidTAP4hPxhRtBm0b1/yNNMUZ2SDAMBZwXYmKsMTyn5f622b4Mrj6iRVmdtOrBDLjyhMg/Cn6RjQXmVD1NXgFbwZOQHKtW1q2J5+XpW2DrnUjmPS3nAUaZHBG4rrzwMCjUB7bl9aQvyqL7RVHjcKInZWuooQRpk3SjrqDrESiEengGdda519EF6KKDucea4iBry0J1bY048v/rI28zcq1nkXwkOfrXLnKNpQKav8QO84sq44P1dqQ2QqSTczuQj5+PEO
 ZLN8jPOb
 6LXHaUIN2+M0oqvoEDgA7nYlQmpH16SsfJ8gJVBQo444pzv3LyeM1OB/C7CbfzLGHiP3E1ahZkRkRS7w6cr7QFA1RmvjCWDiOOJWArWHuif8YQq+FokYT/DAll6PRG8sPl76lqb3Qb0r7bB/SB2WgAW0Hb+EcJeXpNZRacrACQH9fNZRP+i99L6sX7XWQsV72bogc+puJFcX/L423PYLJNqA3xFvMuPeP+c+SNBQwpxFto/ScDBer05dT2xE/Xty7CDHZEXFsLC7YGmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add ttu_anon_folio() as the common entry point for anonymous folio
unmapping. It dispatches to the lazyfree or swapbacked helper as
appropriate.

Keep restoration of cleared PTEs in the caller, where the PTEs were
removed.

No functional change intended.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 2c910d4575981..fe67ce6ceb5eb 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2172,6 +2172,26 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
 	return true;
 }
 
+static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
+		struct page *page, unsigned long address, pte_t *ptep,
+		pte_t pteval, unsigned long nr_pages)
+{
+	/*
+	 * Store the swap location in the pte.
+	 * See handle_pte_fault() ...
+	 */
+	if (WARN_ON_ONCE(folio_test_swapbacked(folio) !=
+			 folio_test_swapcache(folio)))
+		return false;
+
+	if (!folio_test_swapbacked(folio))
+		return ttu_anon_lazyfree_folio(vma, folio, nr_pages);
+
+	/* nr_pages > 1 not supported yet */
+	return ttu_anon_swapbacked_folio(vma, folio, page, address, ptep,
+					 pteval);
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2349,31 +2369,12 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
-			/*
-			 * Store the swap location in the pte.
-			 * See handle_pte_fault() ...
-			 */
-			if (unlikely(folio_test_swapbacked(folio) !=
-					folio_test_swapcache(folio))) {
-				WARN_ON_ONCE(1);
+			if (!ttu_anon_folio(vma, folio, page, address,
+					    pvmw.pte, pteval, nr_pages)) {
+				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
 				goto walk_abort;
 			}
 
-			/* MADV_FREE page check */
-			if (!folio_test_swapbacked(folio)) {
-				if (!ttu_anon_lazyfree_folio(vma, folio,
-							     nr_pages)) {
-					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
-					goto walk_abort;
-				}
-				goto finish_unmap;
-			}
-
-			if (!ttu_anon_swapbacked_folio(vma, folio, page, address,
-						pvmw.pte, pteval)) {
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				goto walk_abort;
-			}
 			goto finish_unmap;
 		} else {
 			/*
-- 
2.43.0


