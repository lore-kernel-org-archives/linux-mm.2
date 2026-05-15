Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2C58CD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC7506B00A0; Fri, 15 May 2026 05:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B783E6B00A6; Fri, 15 May 2026 05:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A3AA6B00A5; Fri, 15 May 2026 05:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2CB6B00A6
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:54:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 325BC161002
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:54:26 +0000 (UTC)
X-FDA: 84769194132.25.7800A56
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id EEE0F1A0004
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:54:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nVCH/SOb";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778838864;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kewyYUzOVU6PsIKBmQromG36Ix95eZVkJjR0tx3lnBc=;
	b=oY+f/UFTJgcu3D/nXWrquQiGKM3vCWY46ozyoEd8i44Ncm/K0qqcAL/trp+FtVxfHZPHku
	R5yOW0vvyId8eEDxk9IEc8sgJeQ+zdhjxO31seERtt1G00+mrb//DUtZOsLj+OtsdVqNeQ
	PjqMdxOdDrsv432309h0glBN7WRDx68=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778838864; a=rsa-sha256;
	cv=none;
	b=4fLf6OfLMcbbb1x0MHjDoyeTZ8zujpr8MDaHkELq+A02RvJO2f41GY6Z59A/6hIVh8lH/X
	C9UV0ANQG990eqkhsU6ZRNBT7USb/ogU+u41yvTqrC5uYgeevhuSNnsgYngWUfX19a8ydb
	ydKHRWKa+ltsEmj3aQYwU5r5FMn5BRI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nVCH/SOb";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A28A446AC;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 473C4C2BCC7;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778838862;
	bh=IA+n1x4TGGrmvV2VnYh711ckQlZ8TYsnmX7nmSi5qbk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=nVCH/SOb5Yg+QaYpbXEh5GlGNXT4hIb/clRp/D8pwKZ25Vbu9jjVAv1zsdNUKl6AJ
	 hdo4/MzZhYtG7Zc6QHEjsshN0gQI1dPX50fNI5TNiODGCdQGgpNosTWuLhz6Xbd3Fm
	 qxahay6PY6Z6iiWCA9fVGa0xIWIQdVKmSIg47HGcjzv2C8t88JtFoEA5/ea1o9WjRF
	 MDoYL7N59XsD9YoKPwLNYHf5NZxg7geuS3XVWOlAg8XaffD+g7rjU7cuf0Gxn54Fvm
	 vshmwdo1zfG4680d5Tj9EEQd9I3AgV8UL7K8fusqqR9Y49HChVfe+3CJm2jjoALeIA
	 e1ByGny8kyr/A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E562CD4F25;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 15 May 2026 17:54:20 +0800
Subject: [PATCH v4 07/12] mm, swap: support flexible batch freeing of slots
 in different memcgs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260515-swap-table-p4-v4-7-f1b49e845a8d@tencent.com>
References: <20260515-swap-table-p4-v4-0-f1b49e845a8d@tencent.com>
In-Reply-To: <20260515-swap-table-p4-v4-0-f1b49e845a8d@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 Yosry Ahmed <yosry@kernel.org>, Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778838859; l=2512;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ZD2081+ctfRfaBeb4mp+5wkRHhM7k1bXJ2YEQVy37aA=;
 b=aSdJCM1Mf3hP3B66vZNBBfPKh/xIYxC/RcUq0X3J2W1Zyl+7NJU7Rfgt6D1rOoaWtmmKYTri7
 m7u2LCG/bgiD9MEJ6UsXQ/coVW8+UzlwWImuTWMLPxFNJ7aJDpnh8Na
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: EEE0F1A0004
X-Rspamd-Server: rspam04
X-Stat-Signature: qxmu4dr44pjcyobmsyi5xy4bbt96xutz
X-HE-Tag: 1778838863-662908
X-HE-Meta: U2FsdGVkX1+LyvxQT2mJPhWDCdCaqgtc0wUaKPTSLjAsnm2/wa2FCyvCanto7ickR74CyIi5zRyA8DJnQTCrEYRYmca0ihxI3PyiIvDe5ukZ/YlIRwjsnoB5d6993Yt3x5BKCTEsAzXYQtNwVEh7Tkf/y6XQOZdfPd2T6j1Tf8WpYP7/QJkdWAoV7PbNOSzZcoozVb5MDINYvqVehNLTSOlFNFqMMDN9DoKGIKQHWgDnVIvuonoE5e8CvdOAqZPP21K9mXyJw140xUSq59E8zvlUr+rEXSKmj9K0LCU11mmbdWuoIYdEamFUnKzSrcDoahENIH1SBMgpw+THL1vjefBbKzevFOLjWYLw79yP/NfWGFtWT8lhJhUNBLGMqA+OpglHMwnFjJMG5R4trwzcPgl/o0xgF9/uLTS/8QWduwCcKmCoZh2pwqLioJRp7bVDLA46PyPIFJ66FLF3en+Np1XzsrFe660wIeAmsJvyODwPUrPANRJhq0DlVqo+xtyo2bCxHh+Pvip1ZnniAvjOxNBrJxkjV6nRIspy6bnhLR+ipQdxHZSI0HxCq+Y/6JkV36liLWPTZQJms+FtTPP8qBu0uMR0nW6Fhy9vcaHustpHCFzvKPsigoGywhD22fCsr4svBSdkwhRBM6ANPv+cTnFOUgNDUFO27i6MF89049AFYmc8SAqGI0YCKdgE5MZJAnbs529EZGiVfuZN3vBn5CxVlGwwTfVTTOsMQvcoYZ5QYi0hoXmCjNqlLPT7HdkUAlwEeGrSWSQAWBuOVuHINNUR66UlxTeDn+EhowLjrxIawK+IlO5vDXF/G1RcQFg3M7WaCxumCi/EdXX82riIBr2zmvil5DBSxPkmVBEpLLGF45burHtSAQ5UCTHt1pRhVXODKCpR53PtJeb6ZbWYCgvuQHTMqOqq1giWbxgbhUEdgr/yKbcNAJkfbwTOzhCVi8ixXcR9P81PXrOX25L
 fBLr0vJ9
 Hlvce3DlUDb8I7wYdxTJ5RGEaOfrO0WEqGFRh53MpbHnXjAX1o/nUwrvMBPAlVCYZm0BuITBbwBd2mxJEAdv5Uv+D4LeE5OzXGIfGyHOdToJLZOfRXX9SzJwwgTG2O1XC2I6CWK9v7MOr94zxwvFzdhfVK9b/GIMNurJs5B14sipxWG5QDnmdYhAI9HW/G5Gv847P5/tnBUyMweKaJ9aH3fzrEh6KQqUESKH4w1A47dKuteG1g8ELrLqStpg9ecKd4J7iLhTuf9JGjd/bzZK50gJ9VsughEXKyiHHJsOcheNzedVI17PDTwkbFpYAddLkF3x0ajpk+iqmrdX+0spfn5Hog2EH3hwMrqElTKLcufOg/xgaTxtYMoL+qt1aBqCa06y2S40JgHLyDZA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of requiring the caller to ensure all slots are in the same
memcg, make the function handle different memcgs at once.

This is both a micro optimization and required for removing the memcg
lookup in the page table layer, so it can be unified at the swap layer.

We are not removing the memcg lookup in the page table in this commit.
It has to be done after the memcg lookup is deferred to the swap layer.

Acked-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5c8bb15719bf..c9c80ba9252b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1873,21 +1873,46 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 				 unsigned int ci_start, unsigned int nr_pages)
 {
 	unsigned long old_tb;
+	unsigned int type = si->type;
+	unsigned short batch_id = 0, id_cur;
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
-	unsigned long offset = cluster_offset(si, ci) + ci_start;
+	unsigned long ci_head = cluster_offset(si, ci);
+	unsigned int batch_off = ci_off;
+	swp_entry_t entry;
 
 	VM_WARN_ON(ci->count < nr_pages);
 
 	ci->count -= nr_pages;
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
-		/* Release the last ref, or after swap cache is dropped */
+		/*
+		 * Freeing is done after release of the last swap count
+		 * ref, or after swap cache is dropped
+		 */
 		VM_WARN_ON(!swp_tb_is_shadow(old_tb) || __swp_tb_get_count(old_tb) > 1);
 		__swap_table_set(ci, ci_off, null_to_swp_tb());
+
+		/*
+		 * Uncharge swap slots by memcg in batches. Consecutive
+		 * slots with the same cgroup id are uncharged together.
+		 */
+		entry = swp_entry(type, ci_head + ci_off);
+		id_cur = lookup_swap_cgroup_id(entry);
+		if (batch_id != id_cur) {
+			if (batch_id)
+				mem_cgroup_uncharge_swap(swp_entry(type, ci_head + batch_off),
+							 ci_off - batch_off);
+			batch_id = id_cur;
+			batch_off = ci_off;
+		}
 	} while (++ci_off < ci_end);
 
-	mem_cgroup_uncharge_swap(swp_entry(si->type, offset), nr_pages);
-	swap_range_free(si, offset, nr_pages);
+	if (batch_id) {
+		mem_cgroup_uncharge_swap(swp_entry(type, ci_head + batch_off),
+					 ci_off - batch_off);
+	}
+
+	swap_range_free(si, ci_head + ci_start, nr_pages);
 	swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
 
 	if (!ci->count)

-- 
2.54.0



