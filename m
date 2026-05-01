Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B23C1CD3427
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373196B00A3; Fri,  1 May 2026 17:04:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34A516B00A6; Fri,  1 May 2026 17:04:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1292C6B00A8; Fri,  1 May 2026 17:04:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DFABB6B00A6
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1644A02C8
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:19 +0000 (UTC)
X-FDA: 84720079038.10.C7AD429
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id B37511C0012
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NnUeZIXW;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669457;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fhlw4NBnGoNgwWUdCODkAeSr9covW5MKnNpizHod4Ow=;
	b=OlwUqqoc9O5BCMKKM0fnDJk8nIBO29ciI185+GKhbe3fM29nh6HhLbtzPos345vCv7TR6W
	l/m/hXRkovsCvMOPEFpjDTG27cFrAIFtFK/AjUPGRs9+B+UeEJqsIO7hti5tPuUksWm0ef
	ENiO5WEgAB5i0noY0x47Xd1PZ8DuQMo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NnUeZIXW;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669457; a=rsa-sha256;
	cv=none;
	b=2FfSk87v0IRxeTGZbu3RnfbCSotLSL6A8QunQfN6xEVQbkG3vJaPjPLXZvzFfnUMTLMu2s
	LQNI9/GsqHlXzrSIF5GBLJt7fktajTC+7dYp9+bzcL2aCqDOsJR3Dcg1TQGbmUyvN257rx
	tf24guBfBy29xHw7dY7s6cYM4nHcozU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 47E9D4471C;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21368C2BCB4;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669453;
	bh=6HpqHKl1SwEhSBNLQO59Km2e9sgznTR6swPQ6bwX5OY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=NnUeZIXWBuxNKOdej3BXDeB8GMf0T1irLfF9GFl9K0VefrCJl8OoVFjh2Oe+ciV1x
	 stj7+T4bojxgrthBfP8ACDhsoLfSwrZB9CtIF2QRwtTjWQ3Z9aky6vOSZEAAARe51M
	 p1pum8NximN/MgF5wzz641i0LVhoJ943/pwng9N/ZJbnKSOCSRrXmD3KYw9cWYhPha
	 wDNHZnMuxfmY4yiqkNS66QKIJ8aZrONFyztD2Nei3s0E8s703Lw6etE5jJ16PFYort
	 9cPb3LgfsdmnuSuA4kJzSpJIZPnwMK6xYq77dJgmHNBg/YyBgyck80IkRhig1JIHxI
	 tzqRLJPrqy4HQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18590CCFA13;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:04:01 +0800
Subject: [PATCH RFC 15/32] mm/gup: use new helpers for marking folios as
 referenced
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-15-913619b014d9@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=1672;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=zzj2htF5O3Boz+i6Si7xd6bJD7nkf/a9RkvvaueQ9so=;
 b=sZi3qcG1zBUsLAgNczKqAvDXvOrUzPJS593cEkUbvLcZSL+TA/nS/UnQHUw8/BbKhSltO+z1A
 MbjywAvxq4tDfpfGluN3y7BIjR9yZGpQIA1+BNH1U2QKP35eubRjqAL
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: B37511C0012
X-Rspamd-Server: rspam06
X-Stat-Signature: wy183nj1i1epkwfh8rwm8own851e96xc
X-HE-Tag: 1777669457-617323
X-HE-Meta: U2FsdGVkX1+k3UOHMpCDWFf3/KpQnYQwRGpXt2GEreuQMevyr+cpYyV01DH+OLSOF+t/i/IQGQcF5O5HHzVMzsUKt5j9lNPmm28E6Ul4msdpKLWCEMzsVoEmHv0gBr6BLYk67Tdqu0u6SSsKQdlfrDEL5ymWDHommy52PpymVXU+nYRwTeQqxXSgkzDG6GbQUXwee6vMU7+6xopVYqxLTqHAvP/JHpxPED7LbKZgj4FV8V3/FHkxW9vBehwERM16eFvGCifXEzbn0kUy3wwaz1zi2G2c8aDMs/sCCSyxHDrB0Hqp4LbKKC0bZ68mrfBdemd3zhcbeJ+y8eKF8VOQWmX3+ra8nfhuLD/8g5t+60xsp4w8mfoDa/gDjEwk8QdNA4F3fzlf5nrketU86xNEFWfBdus9wr0QSGcncmwVUI1sM5sTSbzA5RI7MohRF26qbSqJUjAl+CrF9VA5toLxrgT0yljj1E6nG4Viu7xrkwx5JxCtD5geFN6m696tmde2alRsdSKxymiqf/yTH7t+b3wkJJw57gZ3oBc7zQjsR9NQhsIMU0DlMp5EV0XO0CRW+0YXBPIU5cvIepC5B0mfjXo7X65ZWU3KHuyLXLuY+tJTGZuFvZKd5xe2NjXiSayoTx0wd1tYAYzYhTxW2DL+1ohxHIt8otIvKoadGNvI2c2plm/K8q1ypjggWSvq/YhCXwlh8XNo/OtjY726NbC33nCejoanssPB/WEvmJ94m2UfSK6lV8Dx118E2V68ZEodLgCJAq5MQtf7eLj6JglLUE5w9qAkzfxmUH2A1B4hezWkW/pVtm7X/RG1jSM0S8ooBBOFGzG5CGTcn+8e2Q9ZVvUamhmkiIz8xmG2NBnoYlhCH7xmJ5eb9W1gq+oPGioXSHbEYFlN5PZeC78t0nLlkTEOOVoaWRmmUaW1Nqi2WgAh2YjcDKQeMfAiR54+reLLiS96/FsvYbZZA+15oFQ
 lp9nrkmR
 a9vub9FPhQlU8XJDPOXhrrwm8FQNiwBAuigiPN6K3YhWpxDLy7itntRN7lG6mt0EC4oSHRt7R0YgiBJGlFjumgU/gX3Hb/LMHwf4+wBrTslYaa2mTpe+md6CUMScD0AS0fopKabCehuOTZ3UW5ijRa/l8DA+drV5VEwr148J2EDFy9J5oXwKGRQ9nsJLeyOyGNfTuARaNtJ3Pr7rG9IQifUrz56cA/i8afDsf6Tjt+rm/4KccH7CAnS3InBcRGUSyV7k9ZZJ6R5LP0sSTQar1FVG/q0suc5BSMe2KZN9qfIzCrHeNjD3wKR4kEwGAbYMlNwOD21j7ci43qyA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Marking the folio as referenced in gup fast was first introduced by commit
8ee53820edfd ("thp: mmu_notifier_test_young"). Then later refractored
but still basically the samething in commit e93480537fd7 ("mm/gup: Mark all
pages PageReferenced in generic get_user_pages_fast()"). Some implementation
may changed over days by the goal is the same: provide hotness info for better
memory management.

We have made all users that cares about a folio's hotness info to the
new helper, so convert this updater too.

NOTE: it would be better to convert to folio_mark_referenced later.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/gup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 21ea90baefb1..78ffa364ff18 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2898,7 +2898,7 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
-		folio_set_referenced(folio);
+		folio_mark_referenced_by_bit(folio);
 		pages[*nr] = page;
 		(*nr)++;
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
@@ -2967,7 +2967,7 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
 	*nr += refs;
 	for (; refs; refs--)
 		*(pages++) = page++;
-	folio_set_referenced(folio);
+	folio_mark_referenced_by_bit(folio);
 	return 1;
 }
 
@@ -3011,7 +3011,7 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
 	*nr += refs;
 	for (; refs; refs--)
 		*(pages++) = page++;
-	folio_set_referenced(folio);
+	folio_mark_referenced_by_bit(folio);
 	return 1;
 }
 

-- 
2.54.0



