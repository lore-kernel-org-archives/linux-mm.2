Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0913A606D80B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 15:51:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCFEF6B05B5; Thu,  5 Nov 2026 10:51:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA74A6B05B6; Thu,  5 Nov 2026 10:51:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBE906B05B9; Thu,  5 Nov 2026 10:51:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97B116B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:51:48 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 291F8160A81
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:51:48 +0000 (UTC)
X-FDA: 85401505896.19.2502388
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by imf30.hostedemail.com (Postfix) with ESMTP id 31D5D80017
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:51:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793893906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EIK49Tcg3pu8WRBXo8Mfb4XG8bVZ55wdfLeeW4Ym45I=;
	b=pu7eWfSFXaLYZSzJGRxlWCIAJEUtz0XK+jTE6XybYFHG9IJta7Bd1RjqOA7SkeHmCFyc8D
	BAlY6YcZAbiTZ63ZMVBdrxw4nGtI4rHdSUNb3BCYkSQG4KnE9HqHOa+hSokE0oCF2CMcsY
	PdQI0295q5Ssh1PO/KYX+MPhaTR10uA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.196 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793893906;
	b=JkHk+UpDCJAs/Q+SUM8y5bWnBwtYiGrxGMOAzY+nW/QzC8/JpHR6qKHYNHEoHBKYXbxVvS
	Le4gDx85prnLY3/SXK8Gf07uo+P7M+qBOJK/ahwrl+m1S+WVxS11QppjHWG5zXmfbYyxNy
	RKSi8lRFe2SuCJFPFDpru8j3rPh+p2E=
Received: by mail.gandi.net (Postfix) with ESMTPSA id D7CD13EDD7;
	Thu,  5 Nov 2026 15:51:40 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Youngjun Park <youngjun.park@lge.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v2 1/1] mm, swap: only prefer nonfull clusters on synchronous devices
Date: Thu,  5 Nov 2026 16:50:17 +0100
Message-ID: <20261105155032.240457-2-alex@ghiti.fr>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105155032.240457-1-alex@ghiti.fr>
References: <20261105155032.240457-1-alex@ghiti.fr>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTE+woJDVoV0nQAdmju6GXPQzp/37WRGqRlscp+7unek+1nQNJTbvmeTlTd0ZpBK4WOforKxfGb9LZ+Ebki3ZTxLhTP2DkVqpWuUqkuMma22Pq3kWAdenYRiH/OB/oNr+X9LZjsiyptfHUdeuqMNYlPNonH82ECvysafYuTYEheuBQwDfnUuX3Ke+p6SrbAiZtE3gj391nmjpp6K2OwnrClynn4/9TK+ADwy1brBNcyTPAKRRe0o6mQN9X9LB+4Rl3VxjHOqCaEaD8OsyMsg9A6ZENWf6x6JPlMtd5ZZhDJGOcDNERaePHThGJqB6HmyKlCHwAwM62K9AATHCrb14vrLXtPQ59imH+DNJKnRz53f4kcVGtktkkWc0Ur+oVDUdARQKwX1ETe/qFU+1fvu+OMcRDLadNb3dOq6uNpuSZIH4B7lza8uIlF41USk7ZoLjRUsp6ec9+87ZnCfzn9pOkagalwwxyabncFmL06v4qxQya4WOmTYyKAh/Ow/LtIpSwqnGCORCdcGiiPBsEUNXVPHJnjdNjub/6goq4HkNQRXspoOT/KiieGnOpoxglicIEQnb0McGG4LVt8f1nLbhYqSAX4FH1wCKJO1yrIxPd+6jMa/G+gvbjr7NYZfxf3WtzIpOt+l9qIa2nXYKjQTI70eGt4NwdWeiYKvH5ZSjao0/w
X-GND-State: clean
X-Stat-Signature: 6rxc87tuns7pprs5rfa9m41xp1fsbrbn
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 31D5D80017
X-HE-Tag: 1793893905-726306
X-HE-Meta: U2FsdGVkX18HrmERr0IXd9xPvDdmqDVDgBkoFTYEbmNlVV0x/tAgy+egqLQjz7xC906o3dNd9E+lZKZdjQnnTaSWEUlqc7XkR2YD6/+Ji+5PdKt5Y8z2c3O0hAF1qw+3nP9udTUApHGscjS295j9YEsCp+1IDhMaSiL6dk9XxOAs77YE9EHbExNj7A0kJABM2uuq8zevtq56guvKZSIcfgNlI7klz3HPoKzNKJAomiaWsMqBMi4tLLCWeTyHSK1PFJmqA1vQFSnuSzQnAZIRWPs4LwNbSK28ZPzVrxWNfDvyeloaP/REiUhthb46LpvObvCYrNbWgTXOjotkYaL1EwRZwYV/QRNEhydJx2ATzKy7aOYT8asbWJSwj10Sk3+1C+Vd9KuX31I49ypUMAfb2P+jej6bJy8HAZ9awNS+p2blXz9XMCsIHTsqDppGarCLQeALclPdeNYk9tIk4yazijEU+O/KDuuNJesEFqgMWca4Dqxx4LRhAqAvYG9G13fzsNWu6YLbNkZnUHxJQQJaeIOaoYJnATp5xJoulrGd7tTMKek60+tNCuKJ5wR8e/4XdZNLER7DRVyX2GQxn1O0vjVMr1/ugJS83umPX1nnBapOJ7nsM4mHLTP2S4jHe0+rBzm5Bt2W8Qbv2BpDnDUMBkxmY7HvK3n6rsY2gSEu4sIp7h/S+nkn+XbCrukCflRlp4IX4nCTRXrylh4FTSl8A/WqTTCzwEFNlkeujJs2OC0EsLnsuwh3JxdQVzds35xuoOyb+clUFLFxIj+3KNNL0rbtfrp4Xpzc7aNt2nujGDMMV6PR8oizcHnfzI+798xNQRKdIw6WUJS+cvTA71hkV83jHQxMtdxw8/axYtS0TonhotW3hws4ax9RYX9kymsCdannpqpi8Rr0+Fe9JAOf7ITjYqOqRyRPQMQIjy+ZlaxWhaxa4OxfBIZgCvlKDwWj9i6wl9YON4P7J7Tz1js
 rMUZW66o
 IgFiyOjGwg2Wg3n9LmkGrxwdqWBQWqaJswzHq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 9a42aed48421 ("mm, swap: prefer nonfull over free clusters") made
allocations fill the nonfull clusters of their order before taking a
free one, on every device without discard. Since commit 3cedb745d354
("mm: clarify the folio_free_swap() for do_swap_page()"), an exclusive
write fault frees the swap slot, so a workload that rewrites swapped out
memory leaves holes in full clusters, which then go back on the nonfull
list. Reclaim allocates slots one folio at a time, so a batch of folios
gets scattered over those holes, its writes can't be merged and it is
written with many small requests.

So partially revert commit 9a42aed48421 ("mm, swap: prefer nonfull over
free clusters") and prefer free clusters again, except on synchronous
devices like zram: they don't merge I/O, so the contiguity of the slots
doesn't matter to them, and filling the holes first keeps the free
clusters for large folios.

Fixes: 9a42aed48421 ("mm, swap: prefer nonfull over free clusters")
Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/swapfile.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 189f04d8838f..1c1b5d0b724a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -973,6 +973,17 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 	return true;
 }
 
+/*
+ * Prefer a new cluster over a nonfull one if the device needs discard, to
+ * spread out the writes, or if it is not synchronous, to keep the slots
+ * of a swapout batch contiguous so that its writes can be merged.
+ */
+static bool swap_prefer_free_cluster(struct swap_info_struct *si)
+{
+	return (si->flags & SWP_PAGE_DISCARD) ||
+	       !(si->flags & SWP_SYNCHRONOUS_IO);
+}
+
 /* Try use a new cluster for current CPU and allocate from it. */
 static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 					    struct swap_cluster_info *ci,
@@ -1143,11 +1154,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	}
 
 new_cluster:
-	/*
-	 * If the device need discard, prefer new cluster over nonfull
-	 * to spread out the writes.
-	 */
-	if (si->flags & SWP_PAGE_DISCARD) {
+	if (swap_prefer_free_cluster(si)) {
 		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
 			goto done;
@@ -1159,7 +1166,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 			goto done;
 	}
 
-	if (!(si->flags & SWP_PAGE_DISCARD)) {
+	if (!swap_prefer_free_cluster(si)) {
 		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
 			goto done;
-- 
2.53.0-Meta


