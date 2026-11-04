Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A676606EEBA
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gl0bVr9s
Received: by kanga.kvack.org (Postfix)
	id 3CAD66B05C4; Wed,  4 Nov 2026 08:02:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A1F96B05C5; Wed,  4 Nov 2026 08:02:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21BF36B05C6; Wed,  4 Nov 2026 08:02:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAB156B05C4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:02:47 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 792A71A06F5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:02:47 +0000 (UTC)
X-FDA: 85397451174.10.DF7CFEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5AAFA40019
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:02:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gl0bVr9s;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m6xwni03PfAM2cWecuEikX6+gVfqDGMam7JV3RwA/00=;
	b=7hVyQGGMNfLH7UetboVQ6ogLyMzREin9COcDSjDgVZNob1rLI9AlYuvlY2soDiov6T/cpa
	AposmXKo5Z6T7hM8HA4Aqz3sgL2bwPFaZK35UgY8/+jd4IvCYmSBmB4Vn4Fl1U6+/+ZeYa
	w0JCpd9XIchFTR8V/QUG0/IeI7jr4IA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gl0bVr9s;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797365;
	b=dGoTzMS5Y2QQ183BHYFayskyzf82lkmt+0agmJb0M+L8LAlfeGZPPA20SDHay0bzEhMB8V
	olrJB3S5PpwF7ZHWrClF2RDo/nwrcmEzhGpoh8Qsb/1YFPdZ6xKCeKzFtjStPHT6SYrIno
	zEkpANB+y6Gd+ieMQmiUg+V3CssN2S4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 881A944836;
	Wed,  4 Nov 2026 13:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5AC1F00A1B;
	Wed,  4 Nov 2026 13:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793797364;
	bh=m6xwni03PfAM2cWecuEikX6+gVfqDGMam7JV3RwA/00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gl0bVr9sIGprDntcvxsHGzoDFbwYldomWHY+V1rKErVnUHDhDrsORBUSEix5/0B0f
	 wj11uowS+fY/tfC4nbGDaHng3mRD93gABTVpnAUHYIGKo63ZvV+mn1j1SRdUbpTN/f
	 FM12/T++l/Rv7X/N4bcOxH3s7aSLbIJCXnz4XD0f2QI1t6Hlaf5u7TmWq/eVRo3+BC
	 Er4DxxOUrIFSBNufz8dh9slJr0P6mrv7XfdKOI7/HXKFLq+c2WGOpI3kFMhYnH3eWC
	 qJiu/Sm35Xy7ybS9QKMMt9bkn0f67oOWOpIyA4P7bVOiLyRDpr3eFS3kIrAOR/dhe1
	 szhNooLae9zGA==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id 9737D1980052;
	Wed,  4 Nov 2026 08:02:35 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 04 Nov 2026 08:02:39 -0500
X-ME-Sender: <xms:6yzrah3dCOaUn4w_fdvNgr9fFu4O-dFEnxMIpYOD0MInUteHXVr-mg>
    <xme:6yzratVGB5zIJKkPhXw8lEzQCZU7b86vxPmeqjXLIv1aF2DY1dz5NgGf3qBpAT2jg
    3yKgrvNmPwWfm5dJK1DbjZ03e14K3FwSAXki6bLgJGPRsO8R9pv4fQ>
X-ME-Received: <xmr:6yzrakjWZB9vBAugsnw2QrYmtFXOjLorYTPxwTqwzpUqf0ucL5L2Q_ssLLU>
X-ME-Proxy-Cause: dmFkZTEkTGQme7AYtjF3GuVS96P2KQmK7WXeTlUb1QwwiuzIvAmashPSlbgOXzJn8Vwnwy
    GtuimX8GVaozomoo/zh+dZJa/50iMsle5DQ+rz1xv6q7s8h1ROZ32xDIMTiguWiavpmC2D
    BBwjWvlIRSWZcXI9bWu6+sLs7omuy7lLW9/gOc6hVkazqru7j3LnWdj5tmV/csyW0bsTmS
    EsxaoHyCeNrVLjcn3op2UYLn5kjIXtndJ2M5CWyKjF23KtNnUBacMFKYutyyEO2UkxXzYe
    RLi75JY7cBimTx0NOw8ItiGvjmUs48xoopmJA34QoNHmlECPZN6WTQStnLRujBuoPTyyAL
    RZqBSN8icGx9O20vLT7l2QclXCVUSZ9An1bc6x7PXtyywU0CbZAQUO3CeU9qmOHR+OqhaU
    mqcwjgmdE6/tw/BZqJGNjLqOwYk4vNbmC6b87jlwaNGKro2HQy5/yZdmchcMQl6O+1p70w
    5JZHpUmu9YQmaqyxE2DudQ7HpdJ8cYa2CwbkfAcut4JoxG8dSCocdQ6MBXaECCKxkEDq8/
    Dexam+4JamIR3UHMtV1TBxcSnuIjd5NgKAtzaKXUqojjFJQUJPxjjrAnH+LUAR3Bw+nbOQ
    kci1Qy31il8ic/peoAbkKwEOFFOuYxDZOENv0T3jnpl5XW3RUMNCCNi6oSMA
X-ME-Proxy: <xmx:6yzraugIm7LEaAbRjbY2LeeCKAoI4fEOj05mkdS8Rcsrpw-Xx19PyA>
    <xmx:6yzrakvJ-3BCGQVdUzt_3K7p0vng9q_htTKIeWlcWnqAuf-9Srt58g>
    <xmx:6yzranQpizLjex5p2e5xROmYqadHdJHjo1UnRZ8MF4JvIg-hnRXI5g>
    <xmx:6yzralEY76JYarv8x4zscqn5ntzMUgskNp_oE8szU2yeQVcBUpdW6Q>
    <xmx:6yzrahhmLZu8e3g1Ou8j3upRiJ6-tH-Ca4O0kYROTH4MfDk3e4TGSUkh>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 08:02:34 -0500 (EST)
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
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Harry Yoo <harry@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <liam@infradead.org>,
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
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC PATCH v2 12/18] mm/filemap: set PG_rcu_free on the folios that reads keep coming back to
Date: Wed,  4 Nov 2026 13:01:08 +0000
Message-ID: <20261104130118.2507513-13-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104130118.2507513-1-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pu1jdzy4hqgywyx3qnak9u5yb5x1jypj
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5AAFA40019
X-HE-Tag: 1793797365-7723
X-HE-Meta: U2FsdGVkX18xcwAOju2vra+/sdsKrPChTNTt5Bvd5B1O26QxwHNTMrXSsIYL1K+wR5QZ/zfvi6qwMchoPmpG+K/1DF7h3xuBRlEn9iu0MT40Jii+WwS4Ya46o1OG9xXmKPLQW8y52zZyeT1z/iqd92O5kG5StThRn5dRccSi/n0NQjXF955CZoPcg1Fk/MdQXkj1X3U4X2EKcSmK3u4K7IjpSuU52ouXc0QoEBlqqZi+lWf2e2Q/dkNAGzUFaRlpDyQwuE5Mrw138yRz+siScXQZYkNVlEKxmm3OmJLhak00Wiel0gmqRWKqfIbkWf0WxhNWNnBGS6OqqK1sISEGd35tLhHnKkzzPQCLYxlsFlEbb5D4ybTJklkUPsuLXBPpHndSym/GeBunz8f8+UP5x731cM6UlN4Or1gAqMCClkmyvDwCd7lgaEPQDsdgiiJvr/FE9M+b1vMzVECGSp+ZvQxC6g23ycDXLJbad4MioEiO2fJiayG6x0fiN19FitCdCkZOG21JZ2I+U0Y9KtzZ1u36M6qUt75GeNJHQg6BbSlT/+2mOsgyQOfLBAWbSENwcSf1fApYR7+OS9jIy0ZrO6Oe0EVTR4iRsVSHD+YxhVYFid4is+7KViqbE4ylVhtmEHd0hTEeY76VI6pR98DqZUf+Lazrevx+PgO/UVX9wTOLdp6qhmikHs71+pv8M9eQKJzw/601QjYMZIZPZ1mpu1Xlw1txi0WcoM8r5af9NWjtIAK0k/EetlOURLPbwKNm11fomn6l5ob3l6gG0SIPS3YSXm28FRvW7YQk7nEFK+/lBP2OiNdA1WDStcdW1F6B/r8wdh0v3JR4SidlTl9SLTVvmCU/hILQcYo6wW6aBX6V7Jg9KDMVccqE3MrsZwEMX6cmZgySh3YaxMiKSr6G6ykYURcpCdvxMUmf6tLEBtPx6osysLqc2wPVPlDEemEpHg29PdRl+X3RmyjVyZV
 eqnYmKdv
 WWgE+sljt8TXkH55K+RKOttBl1v7sTNzitMI5bnm1EOalTz91FjfUg+B9S0vfotrRQO2D+d5/7E0VuuLhZnbaKflhiIWDG86OJdecnUjrIIUi/9Nz1/exR9PCXI+4O7ksB70b6Mw4OoErcNEyiDNy83FqpEf+qrylspYgc5mdYqAwNZycDNjnmNjs9umrwSxxE4pROjhNAXytxGNxjP55ellonZ0a8YIY4SfkWyjy9Y5J1Mhj6ihVDCBBwGdk8q0dNthOJ//Y7tO0tGE7MraU7/YVS1Tl8Ao0M1dyqRvA57WnMIdB3QbXl7Bgjy7At4FmVrAPG8K+WzMwOqHvIpg6nOX383lM0bvR/A8e5uXypaxC6IIwYJ93l123h+Rdm6aS4g2Cxyjs9JKbqifH6VVRAQBlGqhwt37yVlc8dakc1Xjx6c+rELt8F26Karx8/xKZAIaq9OLlcRjQMJt0ifPu39pcimzZ7hnqymYo
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


