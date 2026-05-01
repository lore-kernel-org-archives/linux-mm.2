Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC4BCD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D111F6B00A5; Fri,  1 May 2026 17:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E396B00A2; Fri,  1 May 2026 17:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98BF76B00A4; Fri,  1 May 2026 17:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 75C416B00A3
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3CF55A0276
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:19 +0000 (UTC)
X-FDA: 84720079038.26.01DC0FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3CB84180003
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PFBseTCo;
	spf=pass (imf24.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669457;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u3dEgAKJbMtYajda3XGexu4ZriQLDaLp5CzsCP1+xwA=;
	b=LBy6bRgyHxZIaJQPHdZISCA1AzMs20cUiOiXOYjEFXhzbhVYKnNoJkOY35iJXLUmF7cNtT
	04o4EpHdYfA7ZOV/CzLq7wRdrZP1q5GMcnIyDAzci/PfouYhbDscJ1IWXj6i5Sk7NvL4Ze
	amstYi8h5tJEnewL4dP4b2wSE5tUCcY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PFBseTCo;
	spf=pass (imf24.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669457; a=rsa-sha256;
	cv=none;
	b=W3Hda+P7rQhxfs0lc/BbaYKvqm6CDkylyEB1tOI0PrxTfpMpTbMlibpslAW4RCHhol/ssY
	YRIQdMebEVEjJ9kprhNJvHE3Zfy+48daMXfSLB20s3qp3ay7Vx3U0yLKb0b87HU7IZ58JF
	kUJqcl7OUsgX5GDfkAzocnyHSsqU5Ag=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 198D34470A;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED3BCC2BD00;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669453;
	bh=tEQvyj84bVP6Fstmv7rAnw0q1fJ254JkDNTXkCqnrAs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=PFBseTCohhWhGfR0FM/Nmk7ev53x9Ud0IzpvJXTUQ3CDHhJDeDoRXsp88mW6xPEUm
	 y/OiQgDmlbBRmGeAdS4C9yQShd+qM8HSsuBbMm219+FN834qRqZoQJL354OYVQ1Wqc
	 Ua5Ov5SpZuGZX2jDpZDLUnjKpHDNbFA/rH3c+N60doj1nSRzSh98JfljhU17STbLlh
	 mQEOfAb0RCI5AhIDpY7Rl90jC381G4qmzrzLVYPNSwUtGpcZIE45K95BRDMR5evUup
	 5mtYg/VrkuB+/cW4YSsjkbP/M5YX80FK9y1fKg1rpKQu94JJdudcAJphb9AJ4T6MPX
	 b8a3nqGbymECw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E445BCCFA13;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:03:59 +0800
Subject: [PATCH RFC 13/32] mm/khugepaged: consider workingset folios as
 referenced
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-13-913619b014d9@tencent.com>
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
In-Reply-To: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=1950;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=UByiLYjFt2+kqAxm04OpzowbaWLuDjdJ8bJGsAYOXBE=;
 b=rN+ZBnZrzZD6vSDJMUHL0q+E5ZYHa/RaFdPJvCTAyQgAUBzFuz+g/IdZd5U6SrCWwaRFYnHSv
 Iys2yTORjLYCkFTarebaM66SXYa0dlv8YaJMk+cjtcUCldB69BmOlrO
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: zqhxysgrf1ni5h53ph5gh41xw31uoxxn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3CB84180003
X-Rspam-User: 
X-HE-Tag: 1777669457-392452
X-HE-Meta: U2FsdGVkX1+uB/E2XQv1tiIwxfLxAIUt7ksZfWQKK1bUe8v+1320ZA3XvGIWLq1zZs63IjqxcV8QLRwpLOKEjf71zbb8vyGs4XRlxNVxQ+Y3hFKQ7HxKOe+0zuPj6urgGia3mjPLhgEA8OLwp3gfgMGsW5dzEQtNqhCKbDljDNN43Fh9KuReCm4dVU7XJ79SFENakzIdMSwpYmPS8mWKHGtqulABKCnGruVvHoUB6jEMceSoxTjXcnFwexLi6noav6lYfVxxH11Usnum42isD9EZCsk1VFL8seruYdMq+3oSXBdYDfWLAhyYqt0An6H5PTCV3KtnHbbH1SU98c0z7DnB6DJSfZSN1i8zBLbDsMiXArUGgUV6Gj1hTs9gRe3+I4fBTr7eqE60ko4NDaAAi7Y9JwTkpzwO6WUKoRndB8kNDiYPU/RovwEzhIfFgw7ETtU7pF7i+JG36CYSexxwlsVVFHXgRD7tzo5o+6pEAAo+WgT7zwWRkbYDAuSIMYmrzEV33oRaMf0xt2KnQoPAisG4d7Yi+OjS1J1NMorrQLi03yDXuANkS3ktqrpDnSxaD+zhwECy66ulWMjN0qMbzhvrcebVho9TY3+ubcQ1Nb8SAjudVNjG37HvfFh7BF3PNRKZAMmj9ShaZ5nPDJcIKP2Fn3KoUvvKZIuMpzxzXMFBxBgqqcTVZJzrrOwNEdNO92C5G5pGqWitB63E3YK5KgUMUSfXUuGWXSwUlewKMt2vnD9lbMJeLtFfILYGhIbnTcMM2LGmYtsc4RdAo4lTrqQTSSPjEk49+vGsBq35rNule9pLNmM1u2Mh7OVWW2zjdMhbQByxCemweXCFUtDYTCzYksCSyWFlFBkiihsZZ3E3ndp01mYxLMnoPbscHHbZacZym0EBvBchFbtNoNEcf8hZtVeHu4tj4n1Efy23kNKy+NANmM6eIiyAlFsA4rxPVs0Qm++3YDpq05KyU5U
 GHMtjddk
 Y+aHkwp9ti188y856iI/rn2sP5zh6ZZHanIN9G4j2okFS7rGhA7xe6BtFw4QFrRY3TbjewO5QIyQNGQ+MWZvFIC/GGWWPmqrAa80K1V8+Y/RHqDjqYvL6saRbaxUOOpmep/C6UShMSXdrlANQyh1oKBLjv83mDRS7sEc3w1O7DvG/e/WXKJwvS811T3RoNQTEpVV/hHyZe6ZzWMMMW+dYgFL2nIizTVCpt+L8m9W73brf/RSToI68Dv+jT4iMmZd628b8boyB+d5iNiO0cNvhZhdVFk5hCffoxBqwgg7geoxYIyanBaKYWqGWcxmZxY6L9pjhiB2jYR1689G50XJviE1DzGMX3vpZDvvb/2vjzsSz9pFr9zG1PIouaqiJpUGqv58O96le5OQjVnp6T9MCqIVHVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The folio_test_referenced check here is clearly trying to test if the
folio was ever referenced. It was first introduced by commit
8ee53820edfd ("thp: mmu_notifier_test_young") as an supplement of the
young bit check.

Folios are marked as PG_referenced on first access, but following access
will clear their PG_referenced on second access. So checking only the referenced
flag is not accurate enough.

Switch to use the new helper, so we can cover the secondary and following
access from MGLRU side. For non-MGLRU, this will make it return positve
for workingset folios too, which should be OK.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/khugepaged.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7d48d4fbd5f3..af9217e19eac 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -815,7 +815,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		 */
 		if (cc->is_khugepaged &&
 		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) ||
+		     folio_is_referenced(folio) ||
 		     mmu_notifier_test_young(vma->vm_mm, addr)))
 			referenced++;
 	}
@@ -1743,7 +1743,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		 */
 		if (cc->is_khugepaged &&
 		    (pte_young(pteval) || folio_test_young(folio) ||
-		     folio_test_referenced(folio) ||
+		     folio_is_referenced(folio) ||
 		     mmu_notifier_test_young(vma->vm_mm, addr)))
 			referenced++;
 	}
@@ -2729,7 +2729,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		/*
 		 * We probably should check if the folio is referenced
 		 * here, but nobody would transfer pte_young() to
-		 * folio_test_referenced() for us.  And rmap walk here
+		 * folio_is_referenced() for us.  And rmap walk here
 		 * is just too costly...
 		 */
 

-- 
2.54.0



