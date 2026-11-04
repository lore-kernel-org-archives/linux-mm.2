Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F9F26082BD7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eUNqtVgV
Received: by kanga.kvack.org (Postfix)
	id 467C66B05CE; Wed,  4 Nov 2026 08:03:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4183B6B05CF; Wed,  4 Nov 2026 08:03:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 307B36B05D0; Wed,  4 Nov 2026 08:03:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0C266B05CE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:03:24 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 876731C40B8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:03:24 +0000 (UTC)
X-FDA: 85397452728.01.5AEA45B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5E081160010
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:03:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eUNqtVgV;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797402;
	b=vBFw6QqiYHbmUlKVPezrrrhTQpdsaTaDIKoDAz8VZzsIHJmiQ9k5VLQpKG6JAFeYfkmY5J
	cHWE4MNwpubdIQp8G2wSnXEAIx4jvoGpTUWIJyfgR5BxjI8bks10PF/EbPpfBfpSMMPF3P
	u4Mz4BKN21ZuF9PfLn2JuSlePqYlsHA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eUNqtVgV;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4Lerps2lD0Mw1JlyAS7XwS+swB42xH028WT2k07pwY=;
	b=x4Pt/a+1l6NNd2vQCJybrDxuSV3BR5u+gK6SNNvnDnvQlBFO3sZCrmXWqMJLarF6400wNQ
	hZurQoC+ZLH0vDvzRCEUYRU9Pn70kFGjnZPyUWj/umX6BCNBjz9UMJLO8/DlC3EunXFl42
	C/cRV/YapanRBu6WuPdQyegaLkXv2v8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 997C240806;
	Wed,  4 Nov 2026 13:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD231F0093A;
	Wed,  4 Nov 2026 13:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793797401;
	bh=n4Lerps2lD0Mw1JlyAS7XwS+swB42xH028WT2k07pwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eUNqtVgVaqAIUkjZ0JpBpJW9MCVPylBfGSUhDJROeF41H3tkdNH9UTwWC+qk5t57E
	 Dk/9fLfy+NL92vu52nWtqYsEti8Igd3HpdGuhLaRZrEPrZc7dw/2s32187CbGcBeiS
	 gh+eNWoRb/OkBHETzyLvqz0UH69jjMnnlUSo2LvRvnuAsZHdRGTNUWR+nS/JYJnLmg
	 aRypEnc6baTkRVIwOkcbOp3KlYAXnNTKmutAuuQIy0QElBs9AHLHf6qzxw/xl7ff3J
	 Cv6Ii72BZvAQkYOrLLaf5mfnuIM4nqu6OXwzLFDJ2TsCNVPCjcCKl1rU7sFUgb0R/w
	 zH65rDCAe/zyQ==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.ams.internal (Postfix) with ESMTP id 5718F1980052;
	Wed,  4 Nov 2026 08:03:12 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Wed, 04 Nov 2026 08:03:16 -0500
X-ME-Sender: <xms:Dy3rasvOZLRorb5Y7XVip4fp4u6VdMfGeH3EQ_kRQSi2pTaTi_RLVg>
    <xme:Dy3rauuBt8SLKdmFox98xDaW_7D3C47nxk6XazFb-E4-bi4XXo2voh0KXBx3tjLjf
    e2UFTdR3bXItk7AjYufdS1uS9LFOcbSumkWhYR_E8EtbIBA7o71yRCt>
X-ME-Received: <xmr:Dy3raqbCy1NgIotKuM19qURDgk8WpBrPETTvs04pcj86_qP52HLNaXO8ll0>
X-ME-Proxy-Cause: dmFkZTEMr2WhNOOY7faPMgOVA86T3X6FAd5Ao5Ndgx8HItBF0IoaqscGd+eHtrr6ZU+W1R
    wMCQkezO/jqDpIXHtWbk1cX7511CWG9nytvgA72O7/GyWPbnFJH1/KoC1oU4eTzQz4uQU5
    XlfKyFGwpRspKwzN+UK6QdrS6nHZaHNe/uNaFH4uocVUyYawgtQju2cVEawUWtGw6nseJ9
    0L4J0ssTWIjAVgg3c4pDpTeUfzUmFwAMWTRVDjkJafKYOQzvk6rFVN4JhIZhnU3qcRTinO
    hOXkX2soZGBKWYo9BWQOgOkNg7aqmmDYjwTnBv89mK8xPBsHNPD99ZxyAasIZtmzxuPIXi
    47fzPLe+sdOALN2WIadaz+v0V41yPbH6g7q0GyrIjlQUEVJ6nKkgOeTR/rwyBciFRt7EHH
    g58VksmLOzWMXLyL3a0htP1FPDOdEr9zZ6g+VxGgoaYryYqBgXtjhUqYvzTZHgcDeIC13f
    6fQIJ3s9NDwRSOYZtqbqX4JtxvQ5tfpXi1KPsQ2ztE0Zdg6KdQdDxdSQvje5bS/vmKJaa+
    1CuYd7Bzw9clj+ohoHK43v4Ya9rMycfJibPWMGaiyBlijmK0ODsTQlZWCdqtAldwiFxi5A
    vR1D9ohmfAuKzdozzhI8WiCVONvLPeLa71yfmZjAYNtPitelHF6AMjM6W0Sg
X-ME-Proxy: <xmx:Dy3rau4gcuXjmPqROjLhx61d3mx9ZM6ALSf-8-GgsAe8LAQ4yiQ2yQ>
    <xmx:Dy3ratlnrq_yIUM4B22Y6ZEvT_aAVw1ihqtBIqK5rjKui9KuPcUgeQ>
    <xmx:Dy3rauo_9K0Jvo6cJMTIlVUVkf2ukYGefcRyY_2y15fuU1AY4ozj_Q>
    <xmx:Dy3rao-so6FzhzXTdMeiQilkuR46dbGPO5Gjavnvnclyv5K9V9OYhA>
    <xmx:Dy3ran44aLjryARxqInszue3VlwsFclKt5yec3-daayw4gskEMXGDEAG>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 08:03:11 -0500 (EST)
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
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
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
	kernel-team@meta.com
Subject: [RFC PATCH v2 18/18] mm/filemap: add a debugfs switch for lockless page cache reads
Date: Wed,  4 Nov 2026 13:01:14 +0000
Message-ID: <20261104130118.2507513-19-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104130118.2507513-1-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bytugkq4rmh8qe6yiu7ooxgufcd4w5ke
X-Rspamd-Queue-Id: 5E081160010
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793797402-654064
X-HE-Meta: U2FsdGVkX1+V8c61W7WWTLTX4HK+D5LYbNLgNecKb5Dnru4HKjOmQPE1s7Z3nKvu28+VPvwlkRSSrceLa0cXtG/tgosSLPQDc10HS5QOuoT9s65GC/xp6fa94v/B4yRb7pYkC3q9IaIrvWmPEYZEu5/7lP5VClvMQjTagJzCf48ScrJFKfSlYKrklxB/RTyHydZ7NdW0DiPhFryKbvwdxYsawRjgqLSm0WlWrJee1/STjLL2X7aqXSJo6ZfNKM2hOMNOVCXintlaBG+aeU7yt0MOUnhSrBBXeXUTth4JFRvuUR4hGKaCJb8UwPhxQE6P8R+OVjlAnt/yniynr0yFjK8/eGC5/s7IimQkWsO5Xb4dJ7OoqujKqkOU4FvXqybCF/2HbQNKdWPikAOKqVQ3Ay/tOjaVIas1UzxjSAhFdt9ce3WFtpqTgyHCOWCnuri77rYdURTUpuKArudj9A6YTbCblVEZOniS79tvIUSc3x+L91YnB0Ju/G625I+kYeJdCDqli8DAIOj8szcEnLnczJNDHFy+uF7tXFhWWKy12q4RlnbLof0YSObmXOfffZE4eD0K74c3BxASat799iOrlhW6TX+OOnW+UR9Kx8vxcpdErX/NgKJgcJRXbLOvhqiaZfuipbfHNeqKAG5x/tE0MdfZFSS3U0lClG+u2k+8XW8trIp2exOtx6PQuiwzIdEAZTlqzlQMmPJ2h8jqZHbODddUK6A0kxGYuPL//kEMgnaPAZRN0WtBZV2Khx7gK4pJpy49KJ6mp+qCH17HFEhG3vo1mJx5FKUoKhFf3RSdPSkrglBUoaC5FPsi2hjPgQkMA59dODNvNcBZ7EJFcIGFTpkttg9oS8tHNdqvuoiaEThsRFwM5s5wHLYYgv2ayIWKYzy95UpLiSzfl6nczkew6p8Hk8dPeDugAwmfGKccXTmPcJ/4h4bcs4m9mJY/8U9w6wkswPYn+cO0lI1ik5v
 t13YgxXl
 UzoFOxVUr9Zj4A3rbScoX2SSQJJT5XYnNRbq1Lr8XdN0SSeSrFlbvGblyiRGu7syau00bYNdrIvqd7tF0tWSkdCVJqFsM3exFcDYKPwZ3sG6MidAOEs7xqxk0hB65ehEbDsKeu4GuBM596iPtV1jSt3bnCnSCsBLHhz+OPG5AoG0SsLooa1vT8Iiw8iXMZoa7UR+DV5h+wBy70lXLriiFDf/OxX+E8DzPN+b45ZvLadUYSKkcENMa8fM/+y5Mda2MlVUK6v1NxHMce3x/is/kPBOrm9SA8Ztcjfn4u8PNnkNV0VdyhbmrxsDwmGzKcRVcwMXNwrlREJdScuzJlHofzNQ5pRDSCjOCZJykdbV5RDcOn+rOggNfmiKblw==
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

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/Kconfig   |  3 +++
 mm/filemap.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 6e5341b0bf64..768873ebc71c 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -733,6 +733,9 @@ config PAGE_RCU_FREE
 	  32-bit.  Not on PREEMPT_RT, where expedited grace periods are
 	  normal ones, so freeing the waiting pages on demand would stall.
 
+	  Writing 0 to lockless_page_cache_read in debugfs turns these
+	  reads off.
+
 config PHYS_ADDR_T_64BIT
 	def_bool 64BIT
 
diff --git a/mm/filemap.c b/mm/filemap.c
index e148490db4da..eff29d501f58 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -48,6 +48,7 @@
 #include <linux/rcupdate_wait.h>
 #include <linux/sched/mm.h>
 #include <linux/sysctl.h>
+#include <linux/debugfs.h>
 #include <linux/pgalloc.h>
 
 #include <asm/tlbflush.h>
@@ -2759,6 +2760,50 @@ static inline bool pos_same_folio(loff_t pos1, loff_t pos2, struct folio *folio)
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
@@ -2769,7 +2814,7 @@ static void filemap_mark_hot(struct folio *folio)
 {
 	struct address_space *mapping;
 
-	if (!IS_ENABLED(CONFIG_PAGE_RCU_FREE))
+	if (!lockless_read_enabled())
 		return;
 	if (folio_test_rcu_free(folio) || !folio_test_uptodate(folio) ||
 	    folio_test_dropbehind(folio) || folio_test_unevictable(folio))
@@ -3028,8 +3073,8 @@ size_t filemap_read_rcu(struct kiocb *iocb, struct iov_iter *iter,
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


