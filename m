Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D188C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D2D56B00AA; Wed, 23 Sep 2026 17:32:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AB746B00AC; Wed, 23 Sep 2026 17:32:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 713A36B00AB; Wed, 23 Sep 2026 17:32:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 419626B00A5
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:32:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C858D14013F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:48 +0000 (UTC)
X-FDA: 85246326816.15.9DFB614
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id CBE8A40007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UO6CmGIq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199166;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+CAjL4cIipyWRW6ha3s0Gd/Nmy5UlGkm0VEm4TIBXWI=;
	b=3L173MinRIYJIHSHuFHpEPYkapheisn+HnzusON4N7O4RdOqSM1x7Cyd4tofTQV5hQGQD6
	xOPSmB7lJwdyW6nMJSp0BbJ2MQvbAsBJ+euu1C2c0U/uJjAvY8MEEq7LlpQ0KYNOGWBzy4
	nP7AyTXpwTRKwsOu4I8eorDjGzYc0ys=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UO6CmGIq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199166;
	b=SLy0qx1sS8NwZcvWBw+U4fM57CwocsO8divWftF8nOo6pUs4QG8/1InJvrE9Rgd6g9idGR
	gEnvftb+AGeu+5wUNrjTsifCxdZVV7Z4bFyAnYVVQOFMSAz+m66lfOiXploMlqmXFOy2eD
	fhX465bu6xFa9PgV92Dw9etlTdDROu8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BAB0F4478F;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99064C2BCB8;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790199163;
	bh=HryFPDO+o0DPrLt3FJ0uwMdDvPOPxQxH9aBcZB4iPP0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=UO6CmGIq+mt4WHgZKtR/B01p7dLt6r9MdFjKo8cir3xX4AcYUekqg474uIIfqDvyr
	 d2sRPPIt40vOapgBLnLJMBN0vE+EeNb4CevOP9qqFO5Tqe56aLdK8rq6k+Z7KBFngO
	 H+06bdg5lG41pKPG5XCd3t2A0AfB/WgzKmAoiNql/vgTu95RZ/C682abqnP2czTVVs
	 brrlKgOtO14oLfjrA260m+6cI6uiISgH3A+J2YcyrZxV8MBKk3IRlbslW38uX9fzR7
	 dkEas21DAcP3NvHbJ4D2bYaqCxN0L7ObLv95v1HXoY5UFp/+emJ/1ZdKlXlOd7meDq
	 seCWS0PeX935w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF58C98304;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 23 Sep 2026 23:32:40 +0200
Subject: [PATCH v6 09/17] mm/huge_memory: rename remap_page() to
 remap_anon_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-swap-thp-cleanup-v6-9-ba1b4ba72c6f@tencent.com>
References: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
In-Reply-To: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790199160; l=2828;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=gWQY+D0TFANvAu4vbrZhmhS3l7U0TOtTOCxVNTsk234=;
 b=BnJau7sxut6tkcndu+7uN8tKe/gVNjBYe4mrrOlSP5w/jkUSgTJAegMGiutUDwlxnWLVU6V5U
 OY05PM3iqbGBXLe00rOUGnTFxtoYX7RbhZihp8PqlzsUYUkuIN+KmbM
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: tp5jyp4p7uyp77wd1udtb4tid64mmygf
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CBE8A40007
X-HE-Tag: 1790199166-487467
X-HE-Meta: U2FsdGVkX18JPD6H4wvm0oZdez1lL2bHwqXCxBBPuEmSvopcF/Ow/CAiSUYHbXBIJYqBknO7HMEk0mnc8IHsWqvMgzj8HXMvy9Pyoe9NjeV4WzMMXgOKmVR1say9MHRSvmws7vQ+5Myl0TtuzpwS2WtXp/148NcZzMobI5/Ny+6gkywdGyuJtC26ohUTWM0GBtPVOYbn6hedr9IlqmBHVdc9MksLwH/xC1KkhYVIh9S5u+zKqVlFt8owb7CYtNzptOwtKNP77kG0aZOSp1CsDHYfIutWtRN/SlMM05vcATn+C5xOaq8t3omDlLYZb5ClFi8fHrO7H0jvLyqLn2l91T9fwq/K+YAdRbRbWcp5z5zjnSamE99EaDXdQDTcrAv8Ha8LQrfLWWLvPXfjNk24ZeDmeEdZ2MVnpK3IBBerafkic8CQRLQUdhL7gmtuFZSJM6HLdF1h/DjGLcod9haCg3t6M3oE8FwK2I4VHTnz+L9onPdfzylWGyGGw9cvZb2L5EUjbfcfE9uO2VBDdnGWrO8l7AOQfshPjlHHrB4jKnxebpwQrCnohMFYhgAnFA8hpj3zD1ze8SGvqC9Rb5603G2J/wVaLHYrfxVOxBxHwGw4ienqvBi0f816zLDIDyUU16zu5hVsGs3O1MNhXyUi2uQfZII6FyIqyYuPr2vYm36cP2hTzKinL4EJg+pDi7geMsGEs2TRdJAt+oNuLVf87JdygxN0ZzvIvipvryHWLfG60X3Sn5VBJf0dXUJV6RlbxHWW4SIP69ydZ9QbfcdwOE9SddCmwsgtrjbWx5oTmZD0YW1YsJcPENr9GuXbqOtjvJXjoUx9gCy3HnMmL+H8bze8+3rxdwyI2hKPHJiANlmRZvYoABoH9dHEKo82VfeSCy1HONRLpFOLA/XL+Cq7JdA2xyvmtyjIEZeu2oA1XEXTfblsHnJWkLia6ZrYkRkoRly5RQZR1y4bePJSFbN
 hikbEomQ
 cWikylX/GIwGPygOD8UA8bFhkmYX471WgOJDV4524FEOus3JJUfIc9LB1oFm4yAV0CYoWsnKjvlHbWxgFVYoRhPxiq8ZX1jIq1//cm2+8hlrbGf9F5DAArqGuNq6gbp1qwdrrATdbbcqbSVuJgu3i7xI0yK3U0Dtnb+6GjHQoPUNr1tvrJ0jFhb2jLbOpjeBVE9yNleNQOMmAKFUg+V1r4Yx+tvUIrPoWU3+/CSowAVNQjuwqfAZRNtqVG/I6zPQNtZ814OVyspqjlf0nAzYtLtwj6kGYhLO6IyrwymENHxtXOtMkE857KL6FPWaI83SUm8jxRQAlo/Og5/gu9zizbOZdJYIWV0Ter2FQp6PLedyWA9EII1fYUExEZUaGDv1E+7bj8RUvItiBKAT53TJ2nQNkFw5Kt/50NB+E8wS6Um8JtFkwkZXEvluyd8HP6dluwc2CLftIIUR1/g/XY5bYliTmbvuWxyyh6oZBbDOu/BGS83Tt3Uxc7IBh0BlzB+oZRjsNCdXpt/e70SO2Ioe0MxjLUwh6zHGG0IcRLeEeMZdxXgpvT1efVL+7iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

remap_page() now only has one caller, __folio_freeze_split_anon(),
and is only ever called for anon folios: unmap_folio() currently
leaves file folios unmapped after the split, so they need no
remapping.

Rename it to remap_anon_folio() to make that explicit, and add a
VM_WARN_ON_FOLIO() documenting it.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7ee9eb2e1e93..fa74fada0659 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3551,7 +3551,6 @@ static void unmap_folio(struct folio *folio)
 	/*
 	 * Anon pages need migration entries to preserve them, but file
 	 * pages can simply be left unmapped, then faulted back on demand.
-	 * If that is ever changed (perhaps for mlock), update remap_page().
 	 */
 	if (folio_test_anon(folio))
 		try_to_migrate(folio, ttu_flags);
@@ -3636,10 +3635,17 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
 	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
 }
 
-static void remap_page(struct folio *folio, unsigned long nr, int flags)
+static void remap_anon_folio(struct folio *folio, unsigned long nr, int flags)
 {
 	int i = 0;
 
+	/*
+	 * unmap_folio() installs migration entries only for anon folios,
+	 * so currently only anon folios need to be remapped. File folios
+	 * stay unmapped after the split and are faulted back on demand.
+	 */
+	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
+
 	for (;;) {
 		remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
 		i += folio_nr_pages(folio);
@@ -3723,7 +3729,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		 *
 		 * Note that for mapped sub-pages of an anonymous THP,
 		 * PG_anon_exclusive has been cleared in unmap_folio() and is stored in
-		 * the migration entry instead from where remap_page() will restore it.
+		 * the migration entry instead from where remap_anon_folio() will restore it.
 		 * We can still have PG_anon_exclusive set on effectively unmapped and
 		 * unreferenced sub-pages of an anonymous THP: we can simply drop
 		 * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
@@ -4083,7 +4089,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 	if (need_remap) {
 		if (!ret && !folio_is_device_private(folio))
 			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
-		remap_page(folio, 1 << old_order, ttu_flags);
+		remap_anon_folio(folio, 1 << old_order, ttu_flags);
 	}
 
 	return ret;

-- 
2.55.0



