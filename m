Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67D8460A4AE2
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hufKA1g9
Received: by kanga.kvack.org (Postfix)
	id 7567D6B00EF; Mon, 19 Oct 2026 11:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72CAF6B02CC; Mon, 19 Oct 2026 11:50:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FA176B02CD; Mon, 19 Oct 2026 11:50:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38F856B00EF
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:50:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C59781C3EEE
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:50:39 +0000 (UTC)
X-FDA: 85339813398.08.C59C730
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id DAD12C0002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:50:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hufKA1g9;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792425037;
	b=taqp5HWG7k6solTjDeqSHsXb+6nNmHVoMQURjqK5UbBORfG7lVrGutlPytwt+W5zTSKl76
	KeAAulfrWbMJz5TSr0fl3t/CikSCvU694Q1PSzzATatlkWgLAt4VuvDsSuueT7j3xl8wMX
	X/1giVcOwDL3tP+7L+GY9S85PgXqLnM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hufKA1g9;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792425037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UMGOxPNVHDCZHjJ/y4wrnwe474JMBsZe9H8zYo9bB5E=;
	b=qnskurZnjO29r+RlNlP6TKiu1WIcFJpS2WAM6YXx0V2HUdwmY+FzGzdZYLS4tezZnd5HiA
	LQfXD4wTIZYZDj6FMjIE6QNSLWNmolv2amq/TjH400Xwby5xQP6NjVokAkfWVIzfhkAOyI
	5MWEn+uB20VBbDxkdfnXiZav4DJ5cR0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E38F60220;
	Mon, 19 Oct 2026 15:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473581F000C4;
	Mon, 19 Oct 2026 15:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792425037;
	bh=UMGOxPNVHDCZHjJ/y4wrnwe474JMBsZe9H8zYo9bB5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hufKA1g97EKvBWIP9U+sEXfnsKRj7lxnGOyTt0Xt9hgyR0V/Mo7z+NOxdKx48r8m9
	 MNQ/yZ1HcpdUeTq9MIKjHEdIslhkAz3yFFhBTd0ugIp2k2DOMSEuYWn65uKrt4wOnR
	 TqwnI28qJcjbNinfyPf/xYD0CZWzOOlBBQXNNG1X3wYJBe+iLOIVyQ7NzKnrTmlYtW
	 FVTV3v1cnRYTbh5b07M4qVHylGvjzfLatA/9myYFGp7lglyFfQbAvsuKDUyoEAowM/
	 AHC9dV1vRe3/zxbp9roLIYqQwb9nvw7h2mXB4BybUJDZcC8wVYDtVy68jkB7m9B3l3
	 IHaQqq+gIntfA==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id 486601980047;
	Mon, 19 Oct 2026 11:50:30 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 19 Oct 2026 11:50:34 -0400
X-ME-Sender: <xms:RTzWarrRMrVUJFi54EKx0DCmuyXlEG2ELefD-0EKzI8czGQ9GWmoVA>
    <xme:RTzWasm31JalJVkj10loaHy77uZH3Ty5ZxKMaK7SBY_NTxYyvpPs3ti6kmQPM7jZi
    _XtFAoTtmPuAy0eQHLJyF47YBkS8v0481twj1BfJoiXz3HQcvTLB0j4>
X-ME-Received: <xmr:RTzWatXyw9LMVHLJz5MnfBiZPogV4NQxnsGEm0-LU067yKXiVW0mA8nhrRU>
X-ME-Proxy-Cause: dmFkZTE+kjgISKw/D5xbtovMvE/5+MXw9OAGtDBfqR9Zk5dZNOqhNWGTcEGO5Lmn7qsaMJ
    P+2+K5eT4SfShSSEvxMo9+0NhMtUrbV4W6Uy0A3XpuEB672w8089GbqFaxEF0wWgdpl5Mt
    ZGUplA1E9XDXzNgkO2MrFgMfcNS4u61SieDRP0v46gjH0l2eZ2DL9zme+jYfCIiYlLA1YJ
    nvbn1HssXPAJFHKdL+OCiEp78jaTWZC2fJHjA4vCnfghQrymIXyUGAHupLMJJEm2bjt0nv
    kEsuBoXYnW/I4u0Q3SZjAxl07Y4ERxrcHOAeD/N6wYko4+jO11wXgs98kOmjLgJ2rMOJLr
    4FP7CSXILgep+V+bnFblzLb2zNX5VOi9HTV33Avp2CU2x/3slL9UpGUX8QP3dV/RyCFMFG
    7imraoXV3UkaOEWfGmHh0OoG9j6M1axwhaJN6nA2HyYr2TdqTNigjbOhwoon6MyVdyyZ+U
    9DK1iVoT/QBuGfOV2J/7tFEPGkQChXo/3aa8Xv7Il7b4za6LWrtfdMTzCHeTrHOuCuyBi+
    7sZr0XoHceQEgIL5FXJB/u/mTl9LrcQBv3ckBqQ40FYXHHMxv6YS0bNZIBfxbsZ3EpISc7
    FhCZ+mKuDN/rcicdBgn/vjQLHJDQGooDmhyDm5AYtLzSQEnR+OVRpfY12e7g
X-ME-Proxy: <xmx:RTzWajRRDhEXwNdv4QdP0IIVDhzS757ZHwZeCSwxqJe02U5VhKd1Tg>
    <xmx:RTzWaqldVlkDWLJJTq6z3PL5cmBNLrOmpBc9C8GUUHT8H_Bbcb4Deg>
    <xmx:RTzWauLwN8-iEtFQpRKWyz_SLVPxzM5NymW_8F2UJGthEucpDGN5aw>
    <xmx:RTzWatXhb0yp2qE_Nc50LD2PMAYq1wBFgDVYpnHWI5ywE3RZIILLtg>
    <xmx:RTzWajF8Q58INwrzpSXejkJdDR5V-g124CSsLWrJZoASPgC4ioqqoNu_>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 11:50:28 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Harry Yoo <harry@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC PATCH 11/18] mm/filemap: set PG_rcu_free on the folios that reads keep coming back to
Date: Mon, 19 Oct 2026 16:49:04 +0100
Message-ID: <20261019154913.1765974-12-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019154913.1765974-1-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7kuzf5ggk8iqegjg1d4wri78ms44eziq
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DAD12C0002
X-Rspam-User: 
X-HE-Tag: 1792425037-634233
X-HE-Meta: U2FsdGVkX1+wkFdreotYjo/EadGcuU2Cx4jcuu+sVHnq1r1zdFOHnhvgNbMARINQH7yzsgHIDHuV15T+C36q+/anwKPiczU5U3qUkELgnlAZzh8yRRvnnUaKqqegUVbHWtlriFlWn0JDcjUBysAmhnVccMz6B/hbComOLGiOiZY3YC8WYWqjq74YNEwP/lzKPtSPWYO3eM1U8EzKOPb2NvmYZUeDUAFFTmxbTqzk/rL61P+XC8aP4dtjRLk7ZL48BQSDDvmKt/CiarqlP6EK45B7hIeCN7WpzfvX+yt0Dg8PI0fbFe8kEf9dgWK96wztLfpmNSj0vyfWrRuBLi1S91gFj1gxKKxZVQlhvBtNtXCNCHezCk6d6vlODK0iBG2W/+HChYEvBkQU/rXaQwgvotSH1MozR+9lUi+4qXKKaCISqQPExV0Ax6PbdqgBBsy6raJks737old6/1quuTnk8MZcfmGQ3BKWDtHT4SuhswbI7KG83V8N+GxnzFXcc7Ef2vjNsKaLb/2WntmqTgNMtvWnc+tyDRv1pe6f2kNx5wFMW62QnGZDV9gNTkjHD9eOzj4m3ioXbQa7XgpRhaF2zlOqQnhIQX4H83wgfYhs5hCaNkusiLt/cdA7JlkuqMw+oR+kdcT6pFoVubgNzNeCGzo+/CtiJcGoy3iC/JxvJBiZh5iI4H1BhI9or8ZOfHezIdHpYducZmRMOSvNp3bM+yxjA9CLZWE6bpacsp6F49f6JHz0UHA1pY7pf184oo2ViDWVdI6VD2QyK62LP2+n3lwL1VlJ74DBEE0dcS2BrJ+FIZrFoVmuSiBRveYTunjWUEkrx7ZDeot+7QTfraQZjHBjGAKGnF7636XcMWHGM/ifdebekJmB0ZJtUCEuvafscJJRQlJHfQOzPNwVLcI77tg/HVlhABaMFx27xhx8/DHMIK1/YkO0qVFFIVvOeMy1OdQlXl5CvkHFegrOvfq
 EyWefnd9
 yHj5/jbAzLs4pk5IrEE3G7za0QTefPL4UyaiSFNOQy0vLGGuLyeHuSIGLzqCyzM+XFKYYUxPREN4yGs9HdSsZPlxx6ipUMPg3Z+AJFV7vSA/k+3zQEe5Yq3KjvXnaFVq+9nv8UM/XKIh1iV7styhu4zSL/7JT4gJd/d8eBsVP+kbiB5saCG3/hakp+lpswcNHQkSeIZ50vUjX6/D7IEVnMaIPb1N8O/XFViSQYFNHRvv7voYYy2Crm0nH3x5nYSx1Wj7YxF6s9g8ll6d9RGAD3lIuu7wsSBU9jj2FCHlOo2YYAKJAGyuC0nHCiJMbWZZ9wElyiISI+XoU9x6hfsEzR3ZIMnlBN7xEfQwzALLy/4b5w+eqjUPHv4a3XR91NCHDyFpEi/5fMWxiCrdjMvZWbKP0gne+QdOFfWaMGzhtvrlmIWtOHE9Gjy8ezFeyk7RRWBBcgybqsLeda7ArZOYeKTkfKDaT4kpCTUVM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Linus Torvalds <torvalds@linux-foundation.org>

A folio with PG_rcu_free can be read without a reference, but its
memory is held back for a grace period after it is freed.  That trade
is worth making only for folios that readers look up again and again.
Flagging every page cache folio would also delay the free of streaming
reads, truncated files and reclaimed cold data, which no reader comes
back to.

Set the flag in filemap_read(), under the read's reference, when the
folio turns out to be hot:

 - folio_mark_accessed() finds it as accessed as the LRU records, or
 - the read goes back to bytes that the previous read through the same
   open file has just read.

filemap_read() does not mark accessed the folio that the previous read
ended in, so re-reads through one open file do not make a folio hotter.
The second test is for that folio.

Leave alone a folio whose next read needs a reference anyway: not
uptodate, readahead or dropbehind.  Leave alone unevictable folios too.
folio_mark_accessed() calls them hot after at most one access, so every
ramfs folio that is read would get the flag.  An initramfs deleted at
switch_root would then have the free of all its folios deferred.

AS_RCU_READ records that an inode has had a folio flagged, so that a
lockless read can skip the inodes that never had one.

pgfree_rcu_mark in /proc/vmstat counts the pages that get the flag.

Assisted-by: LLM
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[kas: count the marks, AS_RCU_READ, 64-bit only, shorter comment,
 rewrote the changelog]
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/pagemap.h       | 12 +++++++++++
 include/linux/vm_event_item.h |  1 +
 mm/filemap.c                  | 40 +++++++++++++++++++++++++++++++++--
 mm/vmstat.c                   |  1 +
 4 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0adfa6605653..6c7f58803eee 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -210,6 +210,7 @@ enum mapping_flags {
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
+	AS_RCU_READ = 11,	/* a folio has had PG_rcu_free */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -269,6 +270,17 @@ static inline bool mapping_unevictable(const struct address_space *mapping)
 	return mapping && test_bit(AS_UNEVICTABLE, &mapping->flags);
 }
 
+static inline void mapping_set_rcu_read(struct address_space *mapping)
+{
+	if (!test_bit(AS_RCU_READ, &mapping->flags))
+		set_bit(AS_RCU_READ, &mapping->flags);
+}
+
+static inline bool mapping_rcu_read(const struct address_space *mapping)
+{
+	return test_bit(AS_RCU_READ, &mapping->flags);
+}
+
 static inline void mapping_set_exiting(struct address_space *mapping)
 {
 	set_bit(AS_EXITING, &mapping->flags);
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 7626a3e3a07a..c1a63f070aa7 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -37,6 +37,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(PGSCAN_SKIP)
 		PGFREE, PGACTIVATE, PGDEACTIVATE, PGLAZYFREE,
 		PGFREE_RCU, PGFREE_RCU_EXPEDITE, PGFREE_RCU_DRAIN,
+		PGFREE_RCU_MARK,
 		PGFAULT, PGMAJFAULT,
 		PGLAZYFREED,
 		PGREUSE,
diff --git a/mm/filemap.c b/mm/filemap.c
index 3508eea44ad9..b732ecaa78a9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2759,18 +2759,54 @@ static inline bool pos_same_folio(loff_t pos1, loff_t pos2, struct folio *folio)
 	return (pos1 >> shift == pos2 >> shift);
 }
 
+/*
+ * Reads keep coming back to @folio: free it only after an RCU grace period
+ * from now on.  Not if its next read needs a reference anyway.  Not if it
+ * is unevictable: folio_mark_accessed() calls such a folio hot after at
+ * most one access, so every ramfs folio that is read would get the flag.
+ */
+static void filemap_mark_hot(struct folio *folio)
+{
+	struct address_space *mapping;
+
+	if (!IS_ENABLED(CONFIG_PAGE_RCU_FREE))
+		return;
+	if (folio_test_rcu_free(folio) || !folio_test_uptodate(folio) ||
+	    folio_test_readahead(folio) || folio_test_dropbehind(folio) ||
+	    folio_test_unevictable(folio))
+		return;
+	if (folio_test_set_rcu_free(folio))
+		return;
+
+	count_vm_events(PGFREE_RCU_MARK, folio_nr_pages(folio));
+	/* NULL if the folio was truncated meanwhile */
+	mapping = READ_ONCE(folio->mapping);
+	if (mapping)
+		mapping_set_rcu_read(mapping);
+}
+
 /*
  * filemap_read() is about to copy from @folio at @pos.  @last_pos is where
  * the previous read of this open file ended, or how far this one has got.
  *
  * Reading on in the folio that the last read ended in is not another access
  * to it: a folio read in small pieces is marked accessed once.
+ *
+ * The folio is hot when folio_mark_accessed() finds it as accessed as the
+ * LRU records, or when this open file goes back to data that it has just
+ * read.
  */
 static void filemap_read_accessed(struct folio *folio, loff_t pos,
 				  loff_t last_pos)
 {
-	if (!pos_same_folio(pos, last_pos - 1, folio))
-		folio_mark_accessed(folio);
+	bool hot;
+
+	if (pos_same_folio(pos, last_pos - 1, folio))
+		hot = pos < last_pos;
+	else
+		hot = folio_mark_accessed(folio);
+	if (hot)
+		filemap_mark_hot(folio);
 }
 
 static void filemap_end_dropbehind_read(struct folio *folio)
diff --git a/mm/vmstat.c b/mm/vmstat.c
index d994de1fd739..c27caad017e3 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1347,6 +1347,7 @@ const char * const vmstat_text[] = {
 	[I(PGFREE_RCU)]				= "pgfree_rcu",
 	[I(PGFREE_RCU_EXPEDITE)]		= "pgfree_rcu_expedite",
 	[I(PGFREE_RCU_DRAIN)]			= "pgfree_rcu_drain",
+	[I(PGFREE_RCU_MARK)]			= "pgfree_rcu_mark",
 
 	[I(PGFAULT)]				= "pgfault",
 	[I(PGMAJFAULT)]				= "pgmajfault",
-- 
2.54.0


