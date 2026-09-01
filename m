Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34730C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 23:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4999C6B0098; Tue,  1 Sep 2026 19:24:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4223E6B0099; Tue,  1 Sep 2026 19:24:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 337CA6B009B; Tue,  1 Sep 2026 19:24:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 13F1A6B0098
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:24:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8EDE212041F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:24:47 +0000 (UTC)
X-FDA: 85166775414.02.6C95D6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id F1CAFA0004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:24:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AxdpiHeb;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788305086;
	b=WHt9uwDIzjnlAO7O5XRII9WIi0SBy4y5Lv77IzigbIOvLsnJjSY8ZDMbnuA0cucu5uZXr6
	WaT0ehRu0k/zyjqt0QYTrdxmNrSK4laRHIaKE7mjYMDTTqTY3dDlZkFJfExNF8FKGtn97x
	XIdp3ZMKXelrqufHmjo6UUPdhu2eE10=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AxdpiHeb;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788305086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PgOmxkUUjVNV1Eh5GMR0aIwGNf9xgs0cOpQXYVxNorE=;
	b=Kotk+VNDWgflSbSIw4VSubKoKmrrxLVg8TUlN/Wk8AiAXDuxFGa9VMgJiqLoROT5JiyPHW
	uMXMuwQ/n3617e0UhPpyXiwbVAjes1xumO9nap5gxQyLX45xubwWeFgAyDMiWT2PTB9LIG
	4grT72ckKkdezs51D3nnJswJDt101ZQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BFBF4349E;
	Tue,  1 Sep 2026 23:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDC31F00A3D;
	Tue,  1 Sep 2026 23:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788305085;
	bh=PgOmxkUUjVNV1Eh5GMR0aIwGNf9xgs0cOpQXYVxNorE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AxdpiHeb7kJvNzMGM7D5vEhXi7aegklfIJNMxOX683Do1AQIZNYHwN6ILMk2lUsko
	 cvujbCse6W3W8ZTMaEckADtZ1pGV2z3BmYmf6cqB9k+7oXeukTVEtTpS9X8Ofkjun4
	 qGnuB77ySAUsIEipMxEHjiJO8xwpPnjSm2BKrcwFxzwOr/nLkwe1KTFzIP0B++Iyva
	 Yxk2e3ZHHRs4mVY4BWaaLD6VscDJJiHGyPAOTmCUpAeCWhOjaTsccmAnobtiZIBaEM
	 4RH3KZqA7379HOf0RhZ/+/hHi9X1HFovC5ei3N5Y8MZ5Jja2V8a9BfAaevKBNkLB32
	 ai2Lhi1XrkGrQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
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
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Ridong Chen <ridong.chen@linux.dev>
Subject: [PATCH v3 4/7] mm/mglru: exclude folios promoted by aging from protected in inc_min_seq()
Date: Wed,  2 Sep 2026 07:24:18 +0800
Message-Id: <20260901232421.40157-5-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260901232421.40157-1-baohua@kernel.org>
References: <20260901232421.40157-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: eipejhn364u47xz9foqg9hw6ouny4wnu
X-Rspamd-Queue-Id: F1CAFA0004
X-Rspamd-Server: rspam06
X-HE-Tag: 1788305085-467140
X-HE-Meta: U2FsdGVkX18m1Zq+oiO5fNm4YJSeQDicY8TXCvYbOlBFgZ6vvKvvu6RJDbGcbXctWWan0hMSEIp5cBny8SIdUS6wscDh5lPcaN+DT7d3MTZVOEvR9fh+Wlel1AM2gU639o3xbr6agOF85Jp53soaaPeQwlZ42xtYZT+0f1rlOCfyKfCs6twzAC3Q/UMecI9gAm+ejb6ngo6tFm9+Kxjz4cS84+No1nJ7mbVMEs+y8FEQUjI+uJlexK3QQ/c81OC9xWBViU1JIE794G1VmYW6JNaocGxuKjQ+ii6UzK0RpjSQh7Q2swgj1OfwzCwqKMnKUQAMYXj3wu4CDb8xXZdslqlT8P1N1Xs+Z1nt21vkb9vaRA61JRNhoeCZjUqIjRcLJT854LSiO7uBcpTzcXF46w1F5f0wSop6tCcXAFmaOa3HihsmSABuHx+zqXZKlZx1MY+rL3+26/1s97ZcWZLRb5AzN2Yusvz/VmvUhkQvFyUqO8h9gOOfPmN6kmdjknaSE9kqSKocg9dncAJP2NllTRzrkm8Xvj1H99Z/POFZBp3R8S/yn8h+hqTw1IGq5iPrBPQJqkOwBvtInuoUbG1mG504N1+lHUG6xTGHJxVT8teT3itJqfyEQVwIFJnvwds7tAsExQBNt+1eMk1b0sYe17ysPv07pjbGbaoUxFchRShYvDP1HhICGe3FcMR9UiDBgNE4opA4P69AEJ7j8L6iG3bA3KAx2ht5qH1bLgCliabwi8952Q9RI79AmrGCNmNcrQJKI3H2l+FJASb0Df98I4VdFYno0ZYhAxRHFHxXgd1SwVWNaqP+f/agV8hNRvm136dA19GdxHMaIcpSnNUJabbXZFnc1AgiIawqSgoxC6uoOVnJD3v3UAwkju5JO/kv3DEIcfuULnQvD0cVHkgD21j6AdggXpUFWoVdRIKoPJNISn0crDjA9kMcRh2yTqwlW82fKFe2iQSGYG66Qpt
 BuTfGs9g
 qQnPccfhlg1g17UwXL+CNsvhpwwIckzdBNOpvsN94IXlYYC1Oos7qy65xxIZA/sEM1X/IfkIOmD+wsrXyANbQp849OAvbCQfsBHowAA8EgT62IlB7Ms247Y1KSE2qunFt2pRBQZ6bdwws+uYysu77AODrFdEULlbpR9AA9k90/aMBCGNL8UisRg8rPIGc5rEYkzCA5pVqw97cwE1iTMStTjDyn4ekJ9dMbVxm06fnw9WpckhFMybqOy1KoNQcKBN+SjqFMi7/R+CpHUM0DYHLD/3AW0oWsCuqKBT70SEl8luR/abhwycgqeMzdJdHcLJ7KmMJbl/814fpdLie9m+oqbVmCFTvZsgo1ovtbzN0dvtPvPYSwL5J7LYq0X8Hpg0J4Sx6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some folios may have been promoted during aging, so don't count them
as protected, similar to sort_folio().

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/vmscan.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 95d48f9efc09..ca57f6095b37 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3957,17 +3957,17 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			if (gen_increased) {
 				delta += nr_pages;
 				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
+
+				/* don't count the workingset being lazily promoted */
+				if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
+					int tier = lru_tier_from_refs(refs, workingset);
+
+					WRITE_ONCE(lrugen->protected[hist][type][tier],
+						   lrugen->protected[hist][type][tier] + nr_pages);
+				}
 			} else {
 				list_move(&folio->lru, &lrugen->folios[new_gen][type][zone]);
 			}
-			/* don't count the workingset being lazily promoted */
-			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
-				int tier = lru_tier_from_refs(refs, workingset);
-
-				WRITE_ONCE(lrugen->protected[hist][type][tier],
-					   lrugen->protected[hist][type][tier] + nr_pages);
-			}
-
 			if (!--remaining)
 				break;
 		}
-- 
2.34.1


