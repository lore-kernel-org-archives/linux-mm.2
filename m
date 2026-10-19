Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBF6360ACCF5
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P5De88P4
Received: by kanga.kvack.org (Postfix)
	id 052A46B02DE; Mon, 19 Oct 2026 11:51:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02A206B02E0; Mon, 19 Oct 2026 11:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0DCF6B02E1; Mon, 19 Oct 2026 11:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B248D6B02DE
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:51:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4911D1406EE
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:51:26 +0000 (UTC)
X-FDA: 85339815372.19.C6396FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 49CCCC000A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:51:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P5De88P4;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792425084;
	b=lLNWYqoyBSbx7C8xaIJwOTV5uQJ6K1qwK9qeZ9rpJcnJKWsnJiIigbx4/0JAkxVSJiGa5T
	RPnjTl1X9a3y5Mku0VLz/8zCqNbaQHGujBKzbz5M+E9+2q47mPCCVLOernG3YxtW3U5I+G
	237GnuVjYyNsClz0vMaqsxW4sc5oUi8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P5De88P4;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792425084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V7LU7B522G/Nt7R0FiWPQqjn9CdYZiUxBthyqwKOD9Q=;
	b=uVfbvfAD06dPC0f1BQVjNBop9nKFjyriLNfbhZGbZQzfzJV6FbrGOK8rUPOkQtPNiBf6KE
	IVhUNZCETaO3NLT4MzIk10bf6ZKEX3gwehLDEvv4ixBGxO+I2oBXq2uRH5L/yifeQ5WCnM
	ji8Jxdc+TmO/mVa0yM9yj1rm/896shE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CC2D43EA2;
	Mon, 19 Oct 2026 15:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EFD1F000C8;
	Mon, 19 Oct 2026 15:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792425083;
	bh=V7LU7B522G/Nt7R0FiWPQqjn9CdYZiUxBthyqwKOD9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5De88P4FpvlaJcDtasw/nbGRMQY+HDtwv3F9sdECQSI3TwBZcWKdnWS1/MSOBPAo
	 +T/wcNAnPygUQGJ+vsA/uB7qzmlsM2qTSk/8Nm3rcB3P+6Hf8bCP0AjohxJVfBTKvT
	 cWSnEpMdPx1fRVrpvAmaHQeE5IFomPGIdl1Q/cEeiunxJN/bbG9bO59FmejMJKqgfB
	 4gNgVvVnUoavjWuzgJBkOg6hCris8dZQAlUEFFdN5hveFivqmOcEJRmd4Lxu1g9J9q
	 GDLcY3GsVZcHez+Ri+XPdcopzmdtf0E1PyaMWhG7ZfYmzvMMg1nh6tdOn+hezaHiSA
	 3F/rf7dZVqtVA==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id A1B74198003A;
	Mon, 19 Oct 2026 11:51:16 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 19 Oct 2026 11:51:20 -0400
X-ME-Sender: <xms:dDzWau9M3FbVzylKyeuMuTbSvRi5IhIiOm5vggdDvmx2WLA7P_-HbQ>
    <xme:dDzWaj-PHM48Ndlhrsp1ztoB7LRirKXS6TUWSubRL-nmTgJ5xnjPzKegBHPYb6Apa
    lWzc8x9JYUVJwFZoc-_UAzZlg-D1yIhQhkrMadsKkA2-juVj8DIWp6B>
X-ME-Received: <xmr:dDzWamrnOz-IYgpENDf9AHxZdMqOzb7vuLX2QCJm9BzNQsb3vG9t-cpq8-4>
X-ME-Proxy-Cause: dmFkZTETM5HXVFLzPUxauAkBxER+Z+lTRQkwgIjXhOFN5THGlO0HVgKRB8Wd4BSXaHA5Bq
    7Hki4AkN29JlsW7Oz4whntE9FU2sRh3n5MV6IVyinOcMZqrY6k/BF1c/BxQBvNlfSnbHPl
    QW/SZQekiA5aLb3GJIUgrXyjACrHk/syVIVjTZfD7jaDpyMg1O/dYDf4I6wLOAEwx8xESw
    vWlPZzevy9W/Bx8Vy1OTZuF/dkabbhGDCVd6eGxAa35wXpSJUVy0LPc7oPWN1fg8RR92+D
    ECpc3fgxZvfIHD4VEls/NZQ+K0gffqxM1pWJS3eaXhIg/AZa9YCFosiagiRdAJgbrCIzoM
    o7gldHTvIc7eDhtIlvlXL3C53Ed6FccoFxHkqxXLx6DesQwcRIq2OCKsz71WAjXT1lm5TM
    Kg1S+IlqYIxSJe9HD2GKza9Xs/DT9IRo/iXi4/lAIHvx7zS5svU1pmtsJwFoiXOifXFOJS
    c8+Oeh3NCwMTZdMLywvQlmAwW/Y7WDCES6B0jmV7pMkS4HcOooYUKfO5TR9lAZ5VoW9a8r
    /Sd6cK2NtDUvPD7I9Une5gCLCi06S4ZQdRtRBV9yijBm9YZ31pf3G36MsRdGWua/hTa0oz
    IXvg1wkV9fllJ5EjieDzrGee0JsCZ2XwYMKjT3W5rPPzBpPVPhNKsKgec/1w
X-ME-Proxy: <xmx:dDzWamLg6cF_WAVSMmPrj6q7Spq9p4LSEZCHn9AirSi8MJz72J-B9g>
    <xmx:dDzWaj0knTs9fAMwlRv2eWSSw3MmAJ-GD7Ro5x3412yILKFqsCQDGA>
    <xmx:dDzWan5ODCRnQyiDwSCOgnm3bWqisXfjJ722uVIweErdBv-sNprqtg>
    <xmx:dDzWapPZak97h7nUxuzK1D5s1DiIbQa1A6wNNRF5GxQLRsE0MFuLKQ>
    <xmx:dDzWajL7V6ATZJcx30Qa3GWHT7z1tZ55WDYLNjnvd5l-RPejyxFAhMfr>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 11:51:15 -0400 (EDT)
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
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
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
	kernel-team@meta.com
Subject: [RFC PATCH 18/18] mm/filemap: add a debugfs switch for lockless page cache reads
Date: Mon, 19 Oct 2026 16:49:11 +0100
Message-ID: <20261019154913.1765974-19-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019154913.1765974-1-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6pja9sfcjmswb7o5rx8dbqpun8rbzn17
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 49CCCC000A
X-Rspam-User: 
X-HE-Tag: 1792425084-496569
X-HE-Meta: U2FsdGVkX19ucOry4PI8lbB0Rm4JeJUakI1EGYwhx5Ur4fBprYVLQGwb9tTpGUssTSYyP3iZSMpJOswcimoKMqcsfFkTBQQhQ3axXAPG87DBFsVzxEsXUMPWEdBEw0d/eAraGbJMDcZHZxyTApLXYkGuA/4NRGUZuxMYdTAfq9+CqPmhoM4uSoAIUNtSqu8UKjMxIzErX8PpWZB0M2Kikk0WQSrg3rN2ASXmSevkoujJ3xFw3s77vjZHaydavy766+ZlrAUuqu7Bij7EGeC9Zfp0nfC1ECbjfid2FrGr2ppHXdLRtSUiZ4ZEzQP9782triWyl9xupGe3TbOnVEFi/7xvkzHLklY3l/pxtpm/+s52vBwpTRVmBQQ50IPPvsazjIPn1wHRojZu3KIc/ycromk1wE7unFqOp5I/8EmfDQidz6oGb+zwjtyu42qVrhhF1Ab4vORXnxy1c2rneCvuSiXhOp6XhC185pUa2PVtN+/RuIACtY0GFpA+nzubCzqP4jfDTNNpspspMA8tZKHK/6bNmSpB3wzNUyju/4BOBoYlwD3UkKv6eP+LfMyoPKbfRdDVXOmJj4KRBbDuZ8TK5naANnkFRUAYGCKYo4prKQLWKirtSU3555R+WmdG1Z8meAvEdL4EjN8FQfSQHAPWb7I+7jY9VBwOFiLA1glUhzEA8Pyen65RypqjXsTxIdc4EIUpSQ6gPe8D0dqpq/yWfxSRr6x8NllSd9GNFWvcj44psTQGKS+dD0cO39V6omcKRplMFPzvFgkJrdkwgtI+EZE5RTCsJNaiesWwvih5Vhu5gcFyXThumTO23B2j/FgvoPfK027cYReM9PSsO5KiISJwJ0bKUamE1EI9KKmH7pm8wcxgDxTerdgRdH0YFfeGJA3YvmHb4oJVoaDRaQ239F6S3AnylGF0phQFcgXNAGtqmpzAMgAFU2qD/IxnBrdtm3rMaO+BzfxNLKmXjSc
 K/h4iS5r
 GettPgP0B8iywrYo3aLWPfMunEV2faKi1is+p26N8v7ZdixG3B3FtqZWBrxRbX0QIOODaJq8I36VCQZ7MdDdYZvslHkx55MVQl9fIli954utDDcQ6lYnkT4ib+WiHSReFWAatY7muOfF7KHzNgLuAOgiv6xbSvS/yTVO1XAR+NIgT2AbQ3E+O6hk3qZE/BAyHCuzbFRq3k3a5na1p6BLZe+ODopLVt32nighhJMzp4SMv6jd+1CWzMZJJ091yqOibI8B5eBPkd6bn0eksY/cHQdSwiXYdkAiqCqxRDFMq59KugtiDkdBFmzK5o5SlsOzH0p8cuYrQdopbIkLt9t4YzNQt4sXe8isuiISmIPNFh0ZqiWnP1binOuRsCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reading hot folios without a reference defers the free of their memory
by an RCU grace period.  A workload that loses on that trade, or a bug
in the lockless read, has no way to turn it off: CONFIG_PAGE_RCU_FREE is
on in every 64-bit kernel.

Add lockless_page_cache_read to debugfs.  Writing 0 stops filemap_read()
and shmem_file_read_iter() from setting PG_rcu_free and from copying
without a reference.  A static key keeps the test off the read path.
debugfs, not a sysctl: the switch is not ABI and can go once the reads
have proven themselves.

Folios that have the flag keep it, and their free stays deferred: a read
that tested the key before the switch may still be copying from them.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/Kconfig   |  3 +++
 mm/filemap.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 5af00db23f90..1ad1cb7969e7 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -730,6 +730,9 @@ config PAGE_RCU_FREE
 	  64-bit only: it takes a page flag, and those are scarce on
 	  32-bit.
 
+	  Writing 0 to lockless_page_cache_read in debugfs turns these
+	  reads off.
+
 config PHYS_ADDR_T_64BIT
 	def_bool 64BIT
 
diff --git a/mm/filemap.c b/mm/filemap.c
index cde7bc68b32d..7021ed2ab6c9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -48,6 +48,7 @@
 #include <linux/rcupdate_wait.h>
 #include <linux/sched/mm.h>
 #include <linux/sysctl.h>
+#include <linux/debugfs.h>
 #include <linux/pgalloc.h>
 
 #include <asm/tlbflush.h>
@@ -2765,6 +2766,50 @@ static inline bool pos_same_folio(loff_t pos1, loff_t pos2, struct folio *folio)
 	return (pos1 >> shift == pos2 >> shift);
 }
 
+#ifdef CONFIG_PAGE_RCU_FREE
+/* Writing 0 to lockless_page_cache_read in debugfs turns the reads off */
+static DEFINE_STATIC_KEY_TRUE(lockless_read_key);
+
+static bool lockless_read_enabled(void)
+{
+	return static_branch_likely(&lockless_read_key);
+}
+
+#ifdef CONFIG_DEBUG_FS
+static int lockless_read_get(void *data, u64 *val)
+{
+	*val = static_key_enabled(&lockless_read_key);
+	return 0;
+}
+
+static int lockless_read_set(void *data, u64 val)
+{
+	if (val > 1)
+		return -EINVAL;
+	if (val)
+		static_branch_enable(&lockless_read_key);
+	else
+		static_branch_disable(&lockless_read_key);
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(lockless_read_fops, lockless_read_get,
+			 lockless_read_set, "%llu\n");
+
+static int __init lockless_read_debugfs_init(void)
+{
+	debugfs_create_file_unsafe("lockless_page_cache_read", 0644, NULL, NULL,
+				   &lockless_read_fops);
+	return 0;
+}
+late_initcall(lockless_read_debugfs_init);
+#endif
+#else
+static bool lockless_read_enabled(void)
+{
+	return false;
+}
+#endif
+
 /*
  * Reads keep coming back to @folio: free it only after an RCU grace period
  * from now on.  Not if its next read needs a reference anyway.  Not if it
@@ -2775,7 +2820,7 @@ static void filemap_mark_hot(struct folio *folio)
 {
 	struct address_space *mapping;
 
-	if (!IS_ENABLED(CONFIG_PAGE_RCU_FREE))
+	if (!lockless_read_enabled())
 		return;
 	if (folio_test_rcu_free(folio) || !folio_test_uptodate(folio) ||
 	    folio_test_dropbehind(folio) || folio_test_unevictable(folio))
@@ -3025,8 +3070,8 @@ size_t filemap_read_rcu(struct kiocb *iocb, struct iov_iter *iter,
 	pgoff_t last_index = (last_pos - 1) >> PAGE_SHIFT;
 	size_t copied = 0;
 
-	/* Not on an inode that never had a folio flagged */
-	if (!IS_ENABLED(CONFIG_PAGE_RCU_FREE) ||
+	/* Not when switched off, or on an inode that never had a folio flagged */
+	if (!lockless_read_enabled() ||
 	    !mapping_rcu_read(iocb->ki_filp->f_mapping))
 		return 0;
 
-- 
2.54.0


