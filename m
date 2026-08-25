Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36725C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35D536B00DC; Tue, 25 Aug 2026 09:55:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 335386B00DE; Tue, 25 Aug 2026 09:55:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2245D6B00DF; Tue, 25 Aug 2026 09:55:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC85E6B00DC
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:55:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 860B2140418
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:55:41 +0000 (UTC)
X-FDA: 85139939682.06.63C207F
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9D46EC0011
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:55:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787666139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l1Wr327vWvY2YB9hPvrLFnEA38xvvBBz2BCBITeU5pU=;
	b=C1DBnCxmLaknEwAyLdl/SFrvK/OGQ0GDDbNPAk1itv+8XwzHRte7ZGn1Pz0g6aLGdx/ftP
	WqLpdQK2TlypgWO/9JFp+itiFZA7DMPhjg0bpFBq//biR0vmgiweOeLYlddNGe1XxIPJqo
	EPR77OVEhpxAuQXFy0Q3FXhPLC6N+Cg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787666139;
	b=t8tQxhxXVQNsTZkTyG9S3wRlTwMUzgfI/7Wf085lQOmKfJT5Ynps4zCYlYKEtYkPBgkobL
	fS6lStJ6RqttKBtAlCcBeKEk4Uq1KV1tB8Usr1jRQ3GS6BVJkNaaDEpgPRqVoy7dzsdyDK
	sUFEzMGWnsf+j3rC6Usn5SwPhgfntb4=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 4CF8C3EC48;
	Tue, 25 Aug 2026 13:55:33 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Kairui Song <ryncsn@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v4 3/3] mm: zswap: drop cold writeback folios via swap dropbehind
Date: Tue, 25 Aug 2026 15:52:07 +0200
Message-ID: <20260825135209.3135169-4-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825135209.3135169-1-alex@ghiti.fr>
References: <20260825135209.3135169-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTGiHDiWlfQ5ccxBZewsSasowgl6gtfYlDY1PWykUS63s55gMKk5eyoNcDBuK/u7C54COj+K24nRLBNKdyIK2RQTz0Gd7w2H9vLC2370zE+Ddl7i6a/AXnrEXG/Z0BlNEt/8xyMeSW6zBiRZZwvjEQff7MVGCDEPhCRkLbIwEbRTVuxjo/fEYI5R/+1hgmHojmsu8cW0sWOxX9UVZyxkZFjKfn8+jU4byiXlitSGcdBMjxKaqXvJ5iTQAfdm2MFjYyiM9uE53CRdiBRxdil8ElrlmgLmGYOBnqlq0fAMw7kI3FGQeaxVI5JUrPkWhh338+VpDFe89mQ4tcVzXfaSQ8hzO/SV91Cb7MrhV04BuJgiTggGt7Zdy76v+v7di5V0F2GWJCgToIeVaHv/Py1bQ3X7vOAU0B8xrylrXT48j2SQPSTKdpB92XGLcGraHgdEQU91N+ZEkWE0EcFcwWBVjG4UlvtEJ4g3dezAkjFWFHIeOOTWEYYxW6p9quP8zM5YnvsxNCuS9As6YAZcXNMc7qGf3JBHypUwMfNT4exbp8J3xkukcZHG/XNc5XQ7kT1Japjehyh81GsvvoqgbA+JKIPd8DFZWoCTLWUfe7Xjox8gz9Pj2o95Ze/TDPs3/QoqVyZjPFEADf8hZRx/ISlGVw/W3F88XplLHYxgWA1CMdOnDQ
X-GND-State: clean
X-Rspamd-Queue-Id: 9D46EC0011
X-Stat-Signature: poeermnfd3qjojtyw1ed3ioes8nurbs5
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787666139-752449
X-HE-Meta: U2FsdGVkX1+TxVOfwUBeIF5FFt7aL7qGGUEhwMj2ZRWc+5myfeIXRZ9aJVLavZPFOokzgP7gBlZmI3aRmOLjSLRdccvc5npPj9bBV/5VfexPeytRowLecNiM2eripx5iUNgFw4Ptk7W1aTsG4AmbPd4CzFFHT8b63SBzDgGJQqOqDT0cx6w4vYUZtt5oxq4nwmXD2Xarn3W3q0uVFKvW2Dd+k0gRsitmAPxTl4Q5s/ql3tIpHvbgfN+vmAZHkGc1mCLqGmrYuM+FQx0/7c36yzyif9Wetf9hpgGIhbeaPxDRMnLZXm91uZToGQ+94D3aX9Y8amVEKLb3X7/qYzRAUhlWXiBJ8UUcSZV0LCL1GTBj7yCbzn7EBw4KzZATvNtIlDdwAa5yWpQJi1/8iTyPv/qnveerrCjeMpA1EdC6en5s/ebWW36g3ffpvpTKXc4ZnHep2mJT6IJzY/93mMsJ79stNukg0oAZbZGJoxn8QhcIOs55UuGWO3nur+5QN3XVM3WjfiGXjEZJ0f+dsK/vdVBhrxmBBX8a/z5pnUzJ/a0eE7YbzkaeSa3i3lId4a37Ojq9zZA4gVroLjJ5ovf45MHh24Lzvs8MJ6e2TRZXmF7RpGTPzktbiwuI6RcwxdxCUiU4DomegLoa3jnC1g4q76EAfJIOEPMvUyYQcqVzx7WTbm9+yejp48eGQbpr1UUijES7Cn/+XFw/JmuHky/5pPhtjJP+8jC8OKnQh2XztrkXxOa1nh+ikkeV4G2Xwy5XnccfSmjnn5WzY+tNj+X1l9weNC/jjnBYBcj6xaYN5zNz2WG7Y6WLn/gDksonI6Z1Fd7SE+K7jQP3cVsT9OB9qWSIgfMr446Relwc1RRty4wjzP0y7cSFFe8wTK9Wwj+lL1txSqYfps5GKXW7mE9ZO45Rxz1Gd6IOiciob8aiyqQsghtipQqkfNmZDI7rpOkgPOP9sPogJfxRowNr6Tj
 8znmdu3Q
 0nO0HEdEQwzZPtf9GzS1lj7z7uWpg48vaNlXjiZZJx5ioOQfuq/CEsQC60QRn4xh9gAVY+RuMz4bnFBLhbvwoELLS6xyPq2n0htKnJgJlmjk0bQUuPQk74kMSDJYZrmMeMYbQ0aViVS9wxquV0tVQzBsaeLqwTCOhQe2/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap writeback decompresses an entry into a fresh swap cache folio and
writes it back. The folio is cold by construction, yet it is left on the
LRU for reclaim to find and free later, wasting a reclaim scan and keeping
cold memory resident longer than necessary.

Allocate the folio off the LRU and mark it PG_dropbehind so the swap
dropbehind path frees it from the swap cache once writeback completes.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/zswap.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 8163e6c5f76c..d16822a516e8 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1013,7 +1013,6 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	 */
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
-	folio_add_lru(folio);
 
 	/*
 	 * folio is locked, and the swapcache is now secured against
@@ -1046,12 +1045,26 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	/* folio is up to date */
 	folio_mark_uptodate(folio);
 
-	/* move it to the tail of the inactive list after end_writeback */
-	folio_set_reclaim(folio);
+	folio_set_dropbehind(folio);
+
+	/*
+	 * Drop our reference before starting writeback so the swap cache holds
+	 * the only one: the drop in folio_end_writeback() needs that for
+	 * remove_mapping_reclaim() to succeed, otherwise the folio is handed
+	 * back to reclaim instead.
+	 *
+	 * Nothing can free the folio in the meantime: we hold the folio lock
+	 * until writeback starts, PG_writeback then blocks swap cache removal,
+	 * and folio_end_writeback() takes its own reference before clearing
+	 * PG_writeback and donates it to the drop.
+	 */
+	folio_put(folio);
 
 	/* start writeback */
 	__swap_writepage(folio, NULL);
 
+	return 0;
+
 out:
 	if (ret) {
 		swap_cache_del_folio(folio);
-- 
2.53.0-Meta


