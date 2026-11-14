Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26E44606A333
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BYDplYd1
Received: by kanga.kvack.org (Postfix)
	id 245296B05DD; Sat, 14 Nov 2026 15:08:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CE696B05DE; Sat, 14 Nov 2026 15:08:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E3B6B05DF; Sat, 14 Nov 2026 15:08:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD0586B05DD
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:08:46 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 51B261A03ED
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:08:46 +0000 (UTC)
X-FDA: 85434812652.23.D9EBA4D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id AD1BD100009
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:08:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BYDplYd1;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686924;
	b=vIib3UxoeQ9FLAlNxOR7DsRn+qR4yumZDZVF3tWZRExbL1q4sx2ajEpnCm3T2apL4ciKIw
	oYtYQi6n5f8i4xfDwVQr8yFBpnpdYIjSx2HCoZPwZFIRfwzaCuPEKBd64b5vYrJ2ILUJ/r
	QiX5bJhacKXdRKD/P+Rc+gM9QcmNMos=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BYDplYd1;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ezq18gHIz45Kz1JSXDZjpuR0ZwqFcCzL6dRcguaRMw4=;
	b=EH4/nVHpPxK9d9YKOM0NNONqaX9o/jLZ5v98ckro/HLPTFrqILTAIexAsBZ0ELVdvGA1ZX
	6MEXigs6KG6Ov6VPNDQuKee0XkXgC+eobapsid9+8V10mM2Ju7Pm2KqOED2XP5No0pGmQ6
	aXl3g0aLlcga3pA/Zje7nWTvDU45h0g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C6184237F;
	Sat, 14 Nov 2026 20:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310A21F000C6;
	Sat, 14 Nov 2026 20:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794686923;
	bh=Ezq18gHIz45Kz1JSXDZjpuR0ZwqFcCzL6dRcguaRMw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BYDplYd12wGj0zV7FRN5cJajx6LmjGREGd60GueNn3xuj2yt0NoP8Tm/8TKCmCxXL
	 foBwABCUEsjvetT8pq8pG/zyiMgpAJpnc2pJrCXGWUBp7AoavBmHWTE3b0S4LpNfmH
	 ls6Jf52lGnGOTEQlALsDOVp/3/oG/RQE4YLzE6f5HgQTAsP6EXwFpAQagYHqnmqqVP
	 9I4PSg4YtzSlwSjnRpQ0r0BrBZvKgE2gwUzSxn1ZRBK3Ho5HEVzjcVjcxpIGvHxhA6
	 qVExLaF4ww3PKOmzUjE6k4/of/plt5dP6rKRuWlm2OHZt4nw9YcT9BtfwafFckiwpL
	 DRGeYXQqzhFLg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	Barry Song <baohua@kernel.org>
Subject: [PATCH v9 06/16] mm/mglru: return for unavailable anon reclaim earlier
Date: Sun, 15 Nov 2026 04:07:53 +0800
Message-Id: <20261114200803.23129-7-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261114200803.23129-1-baohua@kernel.org>
References: <20261114200803.23129-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zfzpj3c67e9ci4wrcumadzd51gntjey7
X-Rspamd-Queue-Id: AD1BD100009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794686924-390165
X-HE-Meta: U2FsdGVkX1/LkjL/t2ib3paOMGrGGD5bCaYkUw512ttmOttZVhi1SQqc2YCZP9D2CHS4Ck3Kz81kBBb9ATewG2O8tMYeOF2qbLby9t0G5wOwogo4F1hKUx31809Rv4ezLtMJWFGPWiec/ihU3vA32AO22xcwMgZ0TDXDQtCgcELkzLUPMG1K175ebeybbD+yt1PXjv4sqx4DMwZsHPlnysajQhEazscqFDoG3sgqYnrMCIyzYt4+WEtOPNMZlvRidwJeiH320fKbnYlCFrpxHhpaO95F2teJgM/AHtt0jcZWGzwEvwlL+GPD3xnXwSpcnoYj9oY08g9rpfKx31Kk2Eekr4a85fFyQyvPmWr4zyeoPG5DoHZ1sqsLASfRJIOW9ZxoTH1VMaIu99yidHK7GiphUHwiZy9KhE9mVWKQBMtHMuelqswUdHK5sQiq5IBnr9N5CL7+FR49oHhhPsZFhSR3Atu1g8tho3BJdFBh0FPLWOliXoL2skZzslzo3TD2v+MP5NFmNB6kNMQ6KzzmeMW3vvLhjkNdMDLvCD5FwmVHdlCeWH+9rtvI5YpolWwoq/TqrsZmPlQuE4oo8Dhv0GRJl8uPeKNa8wsiBxxR0dqp8ZD5s11FSXOHh9qV7jRpVkcI4DIIjhgcyZwFkFI1zivmSKntRDIkKhzkJyLjooKSdZmpUo6gUy1tC+Y34SPJneZQgBWNxtaI86nLuD5h7cc3MIny/ZtO2QLuaNg0e6CMYovrXmDfLG9oP/ycrlGhbNFo1JNxSzZc8wV5WWQLsEYOD00AdtK4Pgs9iYv7U9D4MCqa640JTv3vKV3azH6JbwFep53VG4Fc9q8EGE2aasZPTLSdqHTN4WCx5EIFsmI7MGdajb7EgzR0MIZUjTjVtd4/mD5plQW2mv4pLZVYNvj9JmsYmz97QRa5m1oH/m1cPgGNMZp3NCwcE91hIm9iwDDl7+/1Wy1rJuyxQOO
 MFm9KQPh
 aQW6Auwu9/TO2vyG7cJ5sh56sU0jPLtRjEV28Yn3BZ2JsN4yraXuNN1SoDeRoEmFkmLhgwz8oIeX0Q+ZK+wr3+kiC2JFHNgX8i6K9I0YoeR5B5Vl/OKQFaPgdMpEZvfIGjOXjxdz1cPBeRKIFrtlyadkt7D+TLWOwkQvib6YmWWcGoF3Cd+MyJ8ldeV/gvwbGsZxW2+lN7JSLr+aiwN0sSVJW+L/fenNo6DlH2W3PJ6fiC/pTG8SxM6RQH9jrxbBUOmeKS1IbZS2Rp96DEAyCdD75eqoW09/Y0ahMl5ik8w8zo7avhLBmiYxRfbOe8Mohn3jCnyVFvxOApPqjzJDTEz3Rb1alsHUZNiJS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

No feature change, just shuffle some code, prepare for later commits.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
---
 mm/vmscan.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b3ce4a550a62..f7fbe91fedf3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5060,20 +5060,6 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 			   struct mem_cgroup *memcg, int swappiness)
 {
 	unsigned long nr_to_scan, evictable, sizes[ANON_AND_FILE];
-	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
-
-	/*
-	 * Proactive reclaim initiated by userspace for anonymous memory only.
-	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
-	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
-	 * no swap), return 0 to skip the scan entirely, avoiding useless scan
-	 * work when there is nothing eligible to reclaim.
-	 */
-	if (swappiness == SWAPPINESS_ANON_ONLY) {
-		WARN_ON_ONCE(!sc->proactive);
-		if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc))
-			return 0;
-	}
 
 	lruvec_evictable_size(lruvec, swappiness, sizes);
 	evictable = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
@@ -5126,6 +5112,19 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
+	/*
+	 * Proactive reclaim initiated by userspace for anonymous memory only.
+	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
+	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
+	 * no swap), return 0 to skip the scan entirely, avoiding useless scan
+	 * work when there is nothing eligible to reclaim.
+	 */
+	if (swappiness == SWAPPINESS_ANON_ONLY) {
+		WARN_ON_ONCE(!sc->proactive);
+		if (!can_reclaim_anon_pages(memcg, lruvec_pgdat(lruvec)->node_id, sc))
+			return false;
+	}
+
 	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
 	while (nr_to_scan > 0) {
 		int delta;
-- 
2.39.3 (Apple Git-146)


