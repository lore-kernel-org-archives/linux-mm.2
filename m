Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06AA8C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 23:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CED046B009D; Thu, 27 Aug 2026 19:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9F396B009F; Thu, 27 Aug 2026 19:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17BB6B00A0; Thu, 27 Aug 2026 19:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 875B46B009D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:47:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F2CF160229
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:47:22 +0000 (UTC)
X-FDA: 85148688324.01.2D5DF4E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8578080003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:47:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DDO+VEQq;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787874440;
	b=1wh/P9ltwjdO3vwG8Jei5DOi/0fQfwuYkBXRn5PjmUfdKYuxZopmjwYXlUeFnonilGIc/w
	K0KgLZby1J2K2NT+NvRqyP+gzVqrcsI5Q8YcApmLc5YLe3TipA0pBLwNtR9veAPX9u7b2y
	uMkPVMO5qr7UXaUpz64go0hxXm6jWXY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787874440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2f/gBP+lL9kMBCKcIXbFZ0t49f0KGcv6ig1olyg9Fw0=;
	b=mACYCwnBhUeom3oyxlTc2VR7KKhRP8EQPNwYybg+zWc+qSssHYegfwpeO2POhOPUGuCUmx
	9vzo8kYgE5p8ka+9hUh0HbBRuW1k2jz1rguZ81UbtAM19ZhxatlEWLbOY4f0q21KGUW6Wc
	n/UDGUJ3rQSUj2ZUfMB7ocFmd3kAQIY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DDO+VEQq;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD373601FD;
	Thu, 27 Aug 2026 23:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C961F000E9;
	Thu, 27 Aug 2026 23:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787874439;
	bh=2f/gBP+lL9kMBCKcIXbFZ0t49f0KGcv6ig1olyg9Fw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DDO+VEQqRCzS1cfmBrLQJ50LaIDOsEC9LaOiC2Uzo0Oe5gk2eVQTcRoMVN1zAyqqH
	 fvpVlSo2AcbAjO9Zc6Nj5hvfD/m/DjOhHfH0SiWfwDA5ruE+kOFT+j8t2fP0lE3XTL
	 ul7ftEd6ky1ssOvHyZJdvtjbHDta0Sh4YZlPvt5tVrLJDKvE0idjmq/R66KcZLuMoR
	 JU3/ZgTDPYDfBR++CSNPaGaGlM8Mk1CJQfQH236S4kYn069XhkEHc1JTsReafDxX2q
	 FWuILq5Cw9zObiqIOjwB9L4/WICG/G21Vdq7lpDxejMxmQDCeeVwq3MEOFPm1j7vrh
	 Bh+2FMPr1QPsw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	lianux.mm@gmail.com
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v2 2/7] mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
Date: Fri, 28 Aug 2026 07:46:59 +0800
Message-Id: <20260827234704.63163-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260827234704.63163-1-baohua@kernel.org>
References: <20260827234704.63163-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8578080003
X-Stat-Signature: wih6zxji5rna3qziup85ybwfyr8d9uf5
X-HE-Tag: 1787874440-476736
X-HE-Meta: U2FsdGVkX195vwxojj/TIP2UaCoUlaELbYYUNoDZ70YmITOosXgYgBmWhk3XVPsjXQHTmOdjG8mdbO38u3R27VmmC4FZ7hL03meInrC44vajXdGhaCFS+uyqbu0jVAfAtXQe0E7jRJiZhoYV6w7CzwqMCdiI4xgg8ZG4r9xmOppKLjZuFvJR9SwvBLNfDwrg1kjzjPLDikPBUh5Bf3aDyj1m9HBsUIIni0Ma/RI4ZSUSg45zu82FFOMMQi/SYKeEvh0rhuBF7uCtq4W0VL2vqCC5JFan4+r2uIqTR6itnBH2i8Sb+22QbFv7lnwMwLwXNtvaASQ8V9NhigLd4f2zs0XxQa7vOj//02At9ftnC5uFcaseWb8ig/9FBoZa8A0BXlO9rqPkeUrh+/Ngzl4oxltmthtginbHnvB68bcJHBNzHz3uXnAPNc/njc2WbrA0kEcDY7lsDeR75lnEGABCLshr6YpSPv78y4jXN4D3rEPndhdZtHG4Xsk40vRe0A5qTgdK5sWZtI7dpIiXotc8fo+UYnX2gWuWC6q+lehKBvmgje9G02T73Ie7QBSA64NCC4VHcG3/If2049AmZTdyXhMQStMTFf52wPW7lWOu9vdTrH2s4SFaqVug/zwR7ne3ML0k5OT9TeW30TXNfTS3y+9Cm9UWcg8GrCLgRhjxRrK7zVEF0Rk+tqCAN+bAgu2cz4U5li2XR0ywdDN3Xuryb0aR7GbWkKYKWmqSEDnrBnE0lYC8taZRPtUGpK4PD9h7Af+gYxsnLu2P8h+jPlbRir1L6gChjTZLQZSlpp05yzQPWcdQSTNpVsd6mCGYrjd53D2Vdg8Bo/iHYNCDGWhjx2oQik1+Lso0gJl1zvL9Qzyxd4eep9k2Ofbr6IqCNIVk+pSBzwLqzC/9EhRga5EbXbMONWl/FfDBN//EqGfroQRhK4HwqieRIf68jv10ovD0+CkvZW3bvGymTcagNGD
 LdpP6/gt
 yUd4UgaiwL9SUUe6RMfupGuw7kpzNV1/30hYMUPTsZYoa1YoAVU3fEmL0wEN90kXlD47y1DIERa6RrPtN9/IQoRCrqRvBRiS6YWv/4qok8sxGhVDEGEYV3KHMsXJhSDhHXW173fQMzYUp7Y6IMajjiEP+NQCLJQs+t1hxKg9IJHrTMGiLYcZJWPNyde6qhkJvWQ6xuhg1cS4EOZ6UEsAf8DE/CpdT6/xhSc6Q4T2VNn9jDKhyzQkt8NuEnLcUcOJwRtucRJ/fMiB78T8QIYJ6ligDukZWoeIricsZM3qNxExRWRe+o9O+XlBhAAgn5EGuE1IYLGnGXspFb5OVMGZEiiPF++UIE47l5w0E3ZQOuCJsq2df4GbqJ7H3LDnomO9zN3Zt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, folio_inc_gen() updates lrugen->nr_pages for every folio
as it advances generations. Instead, accumulate the size changes
and update lrugen->nr_pages in a batch after scanning the entire
oldest generation, or when the scan stops because remaining reaches
zero.

Since we only move folios from the oldest generation to the second
oldest generation, the active/inactive state cannot change. We can
therefore skip __lru_update_size().

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmscan.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8f187d296b8e..07c22d51debd 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3918,6 +3918,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
+	int target_gen = (old_gen + 1) % MAX_NR_GENS;
 
 	/* For file type, skip the check if swappiness is anon only */
 	if (type && (swappiness == SWAPPINESS_ANON_ONLY))
@@ -3927,35 +3928,47 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 	if (!type && !swappiness)
 		goto done;
 
+	VM_WARN_ON_ONCE(get_nr_gens(lruvec, type) != MAX_NR_GENS);
+	VM_WARN_ON_ONCE(lru_gen_is_active(lruvec, old_gen) !=
+			lru_gen_is_active(lruvec, target_gen));
 	/* prevent cold/hot inversion if the type is evictable */
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		struct list_head *head = &lrugen->folios[old_gen][type][zone];
+		long delta = 0;
 
 		while (!list_empty(head)) {
 			struct folio *folio = lru_to_folio(head);
+			long nr_pages = folio_nr_pages(folio);
 			int refs = folio_lru_refs(folio);
 			bool workingset = folio_test_workingset(folio);
+			bool gen_increased;
 
 			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
-			new_gen = folio_inc_gen(lruvec, folio);
+			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
 			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
-
+			if (gen_increased)
+				delta += nr_pages;
 			/* don't count the workingset being lazily promoted */
 			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
 				int tier = lru_tier_from_refs(refs, workingset);
-				int delta = folio_nr_pages(folio);
 
 				WRITE_ONCE(lrugen->protected[hist][type][tier],
-					   lrugen->protected[hist][type][tier] + delta);
+					   lrugen->protected[hist][type][tier] + nr_pages);
 			}
 
 			if (!--remaining)
-				return false;
+				break;
 		}
+		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
+			   lrugen->nr_pages[old_gen][type][zone] - delta);
+		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
+			   lrugen->nr_pages[target_gen][type][zone] + delta);
+		if (!remaining)
+			return false;
 	}
 done:
 	reset_ctrl_pos(lruvec, type, true);
-- 
2.34.1


