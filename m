Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57D27CD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 19:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB7F26B008A; Tue,  5 May 2026 15:00:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68046B0092; Tue,  5 May 2026 15:00:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E026B0093; Tue,  5 May 2026 15:00:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 897D46B008A
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:00:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F76840677
	for <linux-mm@kvack.org>; Tue,  5 May 2026 19:00:18 +0000 (UTC)
X-FDA: 84734281716.17.A2758F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4AFE9120004
	for <linux-mm@kvack.org>; Tue,  5 May 2026 19:00:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="F/63nRja";
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778007616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fa/3GBXCv4uF6vQOIsh6Mh24Y8VCpoWicjR7VFvXbUE=;
	b=pbHOaE4nmDck5qeHIu8yrWWz7j1z3BsqqHsphzOlBwuP8Muqo6mvy9wWszq5sJ4aVBHMUm
	f0rfdZzhfMfTdg5vx3TbpSiYdZ23Mh45HoMEshPOZ1Sz3hkfRwRpoz2OF2vs6fGzWWdjge
	4gYvQNnbKy5dLmsU/klyxwH0zXHQr/E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="F/63nRja";
	spf=pass (imf29.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778007616; a=rsa-sha256;
	cv=none;
	b=YNPMoA8s58kjbZED/4YbeDgvHE/uR3bakbnDeBi8RAgTtBJKDy8R5U+aY7T9Kd1ZaN4T4H
	JmEUidv5S5/02pIyp3z1d4Tk5qt+fdwjvd5efMABmElGSKf00l2cbtkOJ0aRTb6cXI8cx7
	TDIUct47TAquYIxS46TtWu7ps5mBQqI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 671DC4398B;
	Tue,  5 May 2026 19:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61ED1C2BCB4;
	Tue,  5 May 2026 19:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778007615;
	bh=VNFDaVKtHxfKb5Jtg4lw1jtyfG4WqayLBxu+KyjdETI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=F/63nRjaUCMUeXblGr32PcC5EvgwHVUSYc2KMVZZYd2AXLUXRg2vrU7OOiweSLmAz
	 Ey0FQDJuRcYeSomo5C5yHitaEH34lItP6ooE5ardeEA4zoOkaQsQn4hg25KW3VqH3H
	 f4vrxfBzb6VdxbtSQOm1UjWHWhEE5K5kgS5TFbyk15gvR3GTdAGvB0bUxXNsHOHlkT
	 a7aKqpIl1NlQb0kWuBjSk1XEpHZVbro8qsNRNIzDG4gs0OmPtwUAQ1ZNin4IC0RxRY
	 1UEXhZuejm2V4wu+l0u/WfRB0cI954NwGaD2b8hKlJ4Ix1ncWVYdVzw41T0Lc7qSQ5
	 3XwrkjU1fJeaw==
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 05 May 2026 20:59:48 +0200
Subject: [PATCH v6 1/2] mm: track DONTCACHE dirty pages per bdi_writeback
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-dontcache-v6-1-66463805dd6a@kernel.org>
References: <20260505-dontcache-v6-0-66463805dd6a@kernel.org>
In-Reply-To: <20260505-dontcache-v6-0-66463805dd6a@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Ritesh Harjani <ritesh.list@gmail.com>, 
 Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nfs@vger.kernel.org, linux-mm@kvack.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3898; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=VNFDaVKtHxfKb5Jtg4lw1jtyfG4WqayLBxu+KyjdETI=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBp+j4zKs26S/A9Ogbbp0fUGJuKz7QkA8Ss6E16g
 9ZgN8VzOGiJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCafo+MwAKCRAADmhBGVaC
 FbHuEAClfB9yntbp0VqHfI94dQPxUMse8RDGZxSS7rytsC1YCO6tM8EOs6PSMXyZ5zGp8ZijYGk
 4MnLilXhL2s6P9YBhrdC3RfRbKcbiY+vtny8oGucvHnEe7Q8MjdUjp31AcAkN0/DhLYYz/jKT/Y
 ctlkhyan7088mUgwwL7jVVdlht6dnp7XEhkNya332Q3tgcffiR2NUUFPY4sorFpkcgkpnypI1tL
 GKhmT+XvPQ/kPeq4d+RfWWe/lJNUGtmU1zgSLJ2RBgrDPkxVOESrzcTVvVjb8gYcjLmmmJqsTzz
 1NGInwei02fIoO79WpaXalTDTNO75+NcCQf+DKjjhX2Ln0e8/LvlGFbr3mYraTuPNBXMw7gMrrc
 5qxd/cM4ruPr5HdoQm8Bn64wdbW3trY9nY8wvb6A6sqbgQbWrXoOAAi3lpv1H2239YovXFBVeA2
 5rWA4tV9zc6cNm4++YD7SA1nR9DeEBItq996hWr89i1WRFgXf6R7Wzw5lEaySOJyBEc1d3zUuLR
 y7+OPc5GMP2p6KjtjjCjovc8GhSyUZ5gdRS6EoKbYh5/R54ypCSxCXmWPHnnXBELS4VmAABQ+8Z
 40tCPbgSmoTKbXnnGurViHDMlpEsnvU/NF8CREIG1YGk1MBneldUdDzSDYk4nsvHFO0NiZmfMTb
 AVtn8Wx8tKTA5Jw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4AFE9120004
X-Stat-Signature: 48dmy983ioendf3tnton6ydfyj47twur
X-HE-Tag: 1778007616-856749
X-HE-Meta: U2FsdGVkX19ryuskkm0zCthP3d+1jAroagqwITp8jcT7rbzLk3eP/ntfbmOTIxzFtnSop4DrnyXVsqCxI+99BVM8npj6fVww7zDMJ2NUJRFQY30EH8e2cumtWe0BKNjTw/xkt1w/Jhew2Zt+KzJgTK0NqvNpLENRpjBJUZ36gfEcmaaUh5uDurHF0Lg7Gcv8ffJjL0hDnsI3L5bEwvZz4s/AiHwlmq4qQd2ehxsO9vERR8kUtusF+frSGgeKOVd/Mqy2wAhARQ7Vok19MucM2wcsjz1CchWSS9zitQQ6MkekNyZQCkaxkUrS2efj7oGpo49V4rRE/JeOWmH0StbTKCLMEFenPHfG2o4zjLgF39IcLe2Su7BOGe109Yz6kmKxRdTkFkld6hzbNyRTixYpm+kv7KDL/4FhWV8seZvJKZsQIFryGnStFao2cRhbAWN14WEQFgxO12xjcjEfFvSu1Ox0UYJ+ie9dNLiN1gWgvSeMtLizIgEToMuNv79TG5ef5QOrEGrGOWMy4BiOHtKAkafr2ZvDkWFv78o2Xai6r21O034CH2EFaW5k9gLHL9xpPj94Ri7AehMu3VWOExKgmODoC8OyEMDbNuOPJcg/pDlZOa88nM10mKIVG3lQ8hyCoP7JQ7i8AXdC7yoygO+lFbQNLsqw7hgaeq92iVzIH5OaKYbMwP6jTQzJWQsgQbXNyrQu95aPEYFYziOOEm9PVbXTrGh1Yvb0gyJkv0SBEQuN9gp4Fe7A6J2QztN5aFMD/SnwZK1SytoewrzzkTXf2sVvMjRTYndiTvNR2hpU0g34Vv0j6Tvl8NNt6/HbZ94PsHWjE7MYZhopHdIMKRhUrlf/Sc3Fz9Q9bKitjASQngPhf3Istq56c9XRDD9kcTezZCEZgzMvk2moYvZyIUz9ebT4DetnZNrwfjB/jve32TVACbUTmkJiSbkA5BLd0czxidyZ0Ht7oMpsmEIkU11
 OIyHe8ct
 1uvnww8BJFp/taHOJKp+smCNy2oM50WpA8OS5oXQvhLJ1bH5lvwsUfW3cXjh5aTS4WQWK74yGEYC2IzH6V+gZZPx0s8+95D82gWHMNiWttKwWqdwZPm8gtdwSyl1/JFpBD26u2kKJQYrzAXptOsa/SjalEW5gy0Fbe1oU1ldiGgs+eas/aD/dhj3JBLTNlboUBbu5Oxthg4g4Q5a4UCqp1neKKBI+z5yrDi6FQsD9BwfoVml1n4WjoswF4umq8s+MD4xQXYlqfnZ+LnEdLqZh4nylud9Cd2a5kxzzpKbS+gOr5/EI0p6VQDVbS0rEDIhk+43f3b7WwiQvLlA87SenA4a06y89F3da+K5RH/iETlvdx0w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a per-wb WB_DONTCACHE_DIRTY counter that tracks the number of dirty
pages with the dropbehind flag set (i.e., pages dirtied via RWF_DONTCACHE
writes).

Increment the counter alongside WB_RECLAIMABLE in folio_account_dirtied()
when the folio has the dropbehind flag set, and decrement it in
folio_clear_dirty_for_io() and folio_account_cleaned(). Also decrement it
when a non-DONTCACHE lookup atomically clears the dropbehind flag on a
dirty folio in __filemap_get_folio_mpol(), using folio_test_clear_dropbehind()
to prevent concurrent lookups from double-decrementing the counter, and
guarding the decrement with mapping_can_writeback() to match the increment
path.

The counter will be used by the writeback flusher to determine how many
pages to write back when expediting writeback for IOCB_DONTCACHE writes,
without flushing the entire BDI's dirty pages.

Suggested-by: Jan Kara <jack@suse.cz>
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/backing-dev-defs.h |  1 +
 mm/filemap.c                     | 15 +++++++++++++--
 mm/page-writeback.c              |  6 ++++++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index a06b93446d10..cb660dd37286 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -33,6 +33,7 @@ enum wb_stat_item {
 	WB_WRITEBACK,
 	WB_DIRTIED,
 	WB_WRITTEN,
+	WB_DONTCACHE_DIRTY,
 	NR_WB_STAT_ITEMS
 };
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..e706f5c4ece4 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2052,8 +2052,19 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 	if (!folio)
 		return ERR_PTR(-ENOENT);
 	/* not an uncached lookup, clear uncached if set */
-	if (folio_test_dropbehind(folio) && !(fgp_flags & FGP_DONTCACHE))
-		folio_clear_dropbehind(folio);
+	if (!(fgp_flags & FGP_DONTCACHE) && folio_test_clear_dropbehind(folio)) {
+		if (folio_test_dirty(folio) &&
+		    mapping_can_writeback(mapping)) {
+			struct inode *inode = mapping->host;
+			struct bdi_writeback *wb;
+			struct wb_lock_cookie cookie = {};
+
+			wb = unlocked_inode_to_wb_begin(inode, &cookie);
+			wb_stat_mod(wb, WB_DONTCACHE_DIRTY,
+				    -folio_nr_pages(folio));
+			unlocked_inode_to_wb_end(inode, &cookie);
+		}
+	}
 	return folio;
 }
 EXPORT_SYMBOL(__filemap_get_folio_mpol);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 88cd53d4ba09..8e520717d1f6 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2630,6 +2630,8 @@ static void folio_account_dirtied(struct folio *folio,
 		wb = inode_to_wb(inode);
 
 		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
+		if (folio_test_dropbehind(folio))
+			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, nr);
 		__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
 		__node_stat_mod_folio(folio, NR_DIRTIED, nr);
 		wb_stat_mod(wb, WB_RECLAIMABLE, nr);
@@ -2651,6 +2653,8 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
 	long nr = folio_nr_pages(folio);
 
 	lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
+	if (folio_test_dropbehind(folio))
+		wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
 	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
 	wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
 	task_io_account_cancelled_write(nr * PAGE_SIZE);
@@ -2920,6 +2924,8 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 		if (folio_test_clear_dirty(folio)) {
 			long nr = folio_nr_pages(folio);
 			lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
+			if (folio_test_dropbehind(folio))
+				wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
 			zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
 			wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
 			ret = true;

-- 
2.54.0


