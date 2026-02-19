Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51BB0C531EA
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 23:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 385BB6B009B; Thu, 19 Feb 2026 18:42:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318E56B00A2; Thu, 19 Feb 2026 18:42:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0D456B009B; Thu, 19 Feb 2026 18:42:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A8B2F6B00A0
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 18:42:13 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 67768C2CEE
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:13 +0000 (UTC)
X-FDA: 84462832146.01.84AF20F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 44F03180004
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:42:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qzAcBPC7;
	spf=pass (imf24.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771544531;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JXTAiSSYMSJPP2bb7GyOCX2wL0gD3cGoF7HI0GhXtpI=;
	b=AhIEAtVYjtXjIZ64+tdKWXXm336P+lirS3Kk7FoURkD1BD2O4N4ORGuYP4bt01hzUs+pzU
	rDGqe1CCWJFy8VxbVEAfHKNemedd+Xt8OtvSY0D23bEt0QHx2Ts4FP72K2Gr0P7+quPfJS
	FJ+5C5cqH0mYWu1vlkjc+ZWh8rehJaM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qzAcBPC7;
	spf=pass (imf24.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771544531; a=rsa-sha256;
	cv=none;
	b=q5mtK84rPdE1Y+UstWRt+kHW5a+1iukMETK+t0behR9Z51VNiRDCHjsX0dLH5bviocjpqp
	wND+9nBbv43zkWl4e+3umi1Z8lJkYQ3pGgk37FoLGj2lT5aWPe5AbmyOeHcgSfXCSotxxs
	3A1hjyGymDw+ev0ZZXrV6hz1J1t7CD4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D8B44452B;
	Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDA9BC2BCB1;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544527;
	bh=76c3QaEd2jCZParrzQ0wwU1XNJCt26Ty2dEVwvDZzmc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qzAcBPC7NnS1YB7AxoXXGQTEF+1VDmP1NZlh4N8sjbsSoa7C6LgqlzvqTcjn/WuxW
	 KtztDgSt2q8JQVsHG5I+2cJzQ2pKy430ZswbZKAFiWBrEOjQ7Gb4aFjwzB4iluGWQL
	 I56w4gD1EQXOqzXhzWq73aVOSsz1fLjDb+rW3WnxBcHcpm+ymHPY9hs0qhh3YyhZZz
	 cVGSm7gut/44j3fXJsvasLLay9O9KcMZ0vsWPCBb8JdTU9NrJuad1STkQypRM6w2wV
	 RDMkxDUItVOBAwDslVKgplbY8Xgg7UzQGqIl9cx52zOtJUm0BMCfxjKX3JTBH6oYD9
	 jFA9bDQ7HfhwA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4FF3C531EA;
	Thu, 19 Feb 2026 23:42:07 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 20 Feb 2026 07:42:10 +0800
Subject: [PATCH RFC 09/15] mm, swap: support flexible batch freeing of
 slots in different memcg
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-swap-table-p4-v1-9-104795d19815@tencent.com>
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
In-Reply-To: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771544524; l=2190;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Nr97MkylL+DHtVgOfh389lZsI/jvwd7cCWUvrCs+ZdE=;
 b=VNT+6pjfkVvYVkF9R+AU+XtVKlcJWeED6XPNHYULO17gQljRJAaYmkZ02T9dibmkLNBBvXLp7
 wp61I+XYYaoBXuYFFCdCriXsl76W8j1LTC2XS24nk5qzY39pQZFZfDh
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: tjzorh7ek8fn59as75ub76kpj4o1wudw
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 44F03180004
X-HE-Tag: 1771544531-495856
X-HE-Meta: U2FsdGVkX1/bQ2UQ6kHgauYZtbRqEaWWX12ssZ/cb6fysN6zPnZkI+DCVLorNAqhMPHXSUc2OT1NVSbICQ+1FXq3lwQMB6n1Cmn/8SwfAGXTJE95Xa+qxghdLdafPhfCXk99d9lcl9WLhaIXksnBdzJ9w8aLRn5DG5tIZXwx1NWN/dUcP2znRNde1xU7MLUDs2Fh4Xe6pwTGY9hmZYWWDq4Sf+ADbsQWXm/6NisFs03vWQ9C+ui+UCbpaoSQ3k0EgnDasM34rcz07Y+TCG5AQfdT5wo6M/zWP472kWuZ7EZMIoQOyv1Wly/2r6B6FXZYTPC3ZlVhBBearq/2TRWAfSG7mdaIRutH5X7EyU5oezUUo+wzwFxVJZa6pKDwx/ffy3MmsIVlfTTSEoVKZjWZks/aTZTU4igeAVMmgufzT40PeiV+GlycMNQKq5OS/KSv6B9tvXj7I7WACnkO9f0/CDPR3teVUKl7YXvySlNTXkGFHIDdFTBxt/G1+y2i6P2noJZmLQLAlVLLRKimrrTWYmBv3BTwMINNJUL3tAEI9v8TiCN451Po2ANqWFrQyrbfjo0gS54Sg5qiWmkg71cBxxBsEP+90nIi4g++b54hUCu9aO013Ysm4mGl7FzJdyQAdzyrGgohDwkIWl40UIbI36mCvWYvSqEuq6TD28SDeeTwRKlHWFtYrtzKAVs9aV9vOZCSMHywvYwlxSOkHWRT/pVxfrDf8KqON+S3yelL7R5g5Wkd2FZtupdDbjp2AF1jTyC1Nzy9HhYAdBd2LYzXBkVG8HwLHjpmEmXOI2pa+d4KDcuqyYLQME/784YTQA44ZTU+j3mZyoCr5OBD8HzUuTO4AbS+jez7p8rlpJkVO7z4aJs7u3mL9o93HQu9il4sUAJCLQ3UwV8hTQKZKqH2N0mpBgNs4eLd051B44O0vEnXhUvBUtalIYolc5H1UlAeN/GYMcN7Vdp7S9uFU6F
 1pMnK1RS
 fzd2qhOyCSGNigkTFRlXQv/RFesezx6mDl9tfXCmhrZjYgPAQ6bQtgYAwtrrzgkzTfOgQJlHuVaAk7XO0LUBd4ImPH63D/pLK77M0mKW6ugy0+qBmJWG4jVS3HrVVT4pqSllKaWPY5xgLn6KkBGqQ92DUZUaC+5nHRmoPtVBsdmMoyu/l2nMfQheci85TgpdSTkL0hJ0m2KyOORU/lgmKXYuvS6HMej1e/VfuuU5E/us85NYS5geRnmI3qGK6m+Z0e742j67WBVZSIaRoWbBtZO54owmTouLB0AsKzwm89h4bKayqj88GOI8BCsSQyDfheX9NC4+d/Ps4mXDTVpt75cdezN43O14L0U1ftsokfmmWRTfPAhuWkkrbHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of let the caller ensures all slots are in the same memcg, the
make it be able to handle different memcg at once.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 2cd3e260f1bf..cd2d3b2ca6f0 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1883,10 +1883,13 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 				 struct swap_cluster_info *ci,
 				 unsigned int ci_start, unsigned int nr_pages)
 {
+	void *shadow;
 	unsigned long old_tb;
-	unsigned short id;
+	unsigned int type = si->type;
+	unsigned int id = 0, id_iter, id_check;
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
-	unsigned long offset = cluster_offset(si, ci) + ci_start;
+	unsigned long offset = cluster_offset(si, ci);
+	unsigned int ci_batch = ci_off;
 
 	VM_WARN_ON(ci->count < nr_pages);
 
@@ -1896,13 +1899,29 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 		/* Release the last ref, or after swap cache is dropped */
 		VM_WARN_ON(!swp_tb_is_shadow(old_tb) || __swp_tb_get_count(old_tb) > 1);
 		__swap_table_set(ci, ci_off, null_to_swp_tb());
+
+		shadow = swp_tb_to_shadow(old_tb);
+		id_iter = shadow_to_memcgid(shadow);
+		if (id != id_iter) {
+			if (id) {
+				id_check = swap_cgroup_clear(swp_entry(type, offset + ci_batch),
+							     ci_off - ci_batch);
+				WARN_ON(id != id_check);
+				mem_cgroup_uncharge_swap(id, ci_off - ci_batch);
+			}
+			id = id_iter;
+			ci_batch = ci_off;
+		}
 	} while (++ci_off < ci_end);
 
-	id = swap_cgroup_clear(swp_entry(si->type, offset), nr_pages);
-	if (id)
-		mem_cgroup_uncharge_swap(id, nr_pages);
+	if (id) {
+		id_check = swap_cgroup_clear(swp_entry(type, offset + ci_batch),
+					     ci_off - ci_batch);
+		WARN_ON(id != id_check);
+		mem_cgroup_uncharge_swap(id, ci_off - ci_batch);
+	}
 
-	swap_range_free(si, offset, nr_pages);
+	swap_range_free(si, offset + ci_start, nr_pages);
 	swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
 
 	if (!ci->count)

-- 
2.53.0



