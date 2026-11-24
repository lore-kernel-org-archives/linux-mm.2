Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15073606A322
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 11:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=chs5z7qc;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=huW88pd0;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=chs5z7qc;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=huW88pd0
Received: by kanga.kvack.org (Postfix)
	id 3C3DE6B068B; Tue, 24 Nov 2026 06:59:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ABB36B0692; Tue, 24 Nov 2026 06:59:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2B646B068B; Tue, 24 Nov 2026 06:59:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE9626B068D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:59:11 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45DC3A0BCC
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:59:11 +0000 (UTC)
X-FDA: 85469866902.15.3246723
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0CE3520003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:59:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=chs5z7qc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=huW88pd0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=chs5z7qc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=huW88pd0;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795521549;
	b=lenL4IXKCtECVVZxrhnuU249Zb0ru7C68PLYNjVnFtrkudcg72CnWhA/geSNfGqx+pNFDQ
	lYtoBTSma3B0AXJOO0BsvHDsGn33vOrLDCNVKowsGQ2TuPRHdn77/FzmdsAyZf8pHQnb8Y
	Y+YLeaJA2/5uUuXfy9KBZ5WUwhipXgQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795521549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=okfebPlBTlU1o3HpteZYdromYWCBxsPgWE+lWJFWceA=;
	b=1qvccpPpzCcQLydoZ2tu3YToj3d9N/wt9p3zWJFhVU9v8dckm+nMXubTJuQ3DAlD7R9rkg
	UwVQZe2KmoqYuQAQ7561DFGXcWeJNFlRo+d7MaUKPnHdV/F37wyY3KNQWWb1atqzWhWnPv
	lxkAjYgCTslFQVk9a+XyevO+u7FGLA8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=chs5z7qc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=huW88pd0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=chs5z7qc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=huW88pd0;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A92981F7A0;
	Tue, 24 Nov 2026 11:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795521547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=okfebPlBTlU1o3HpteZYdromYWCBxsPgWE+lWJFWceA=;
	b=chs5z7qcYFkut2lneizTR21VDoSRk5dAjHB6hUAc5AQ+20F183+bhBD/B2pMSy5v3FPLjC
	YC7dIa420LiBZuL+r7dmp0IRhVIz1+PfhSDrs3Cf4gGWu7GNuObAdYdw4O9WJfPfrW8BkC
	Dyda48OQI/wBvYsHeEgpVSs/KNe9Xgo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795521547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=okfebPlBTlU1o3HpteZYdromYWCBxsPgWE+lWJFWceA=;
	b=huW88pd0QxsB0Lfzg3B45n4d9S1peI74IQiYcCaMor1vLmXJ+gNXbbOQLRSCdUwGRrVb4B
	Hz030OcFVTR2PpBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795521547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=okfebPlBTlU1o3HpteZYdromYWCBxsPgWE+lWJFWceA=;
	b=chs5z7qcYFkut2lneizTR21VDoSRk5dAjHB6hUAc5AQ+20F183+bhBD/B2pMSy5v3FPLjC
	YC7dIa420LiBZuL+r7dmp0IRhVIz1+PfhSDrs3Cf4gGWu7GNuObAdYdw4O9WJfPfrW8BkC
	Dyda48OQI/wBvYsHeEgpVSs/KNe9Xgo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795521547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=okfebPlBTlU1o3HpteZYdromYWCBxsPgWE+lWJFWceA=;
	b=huW88pd0QxsB0Lfzg3B45n4d9S1peI74IQiYcCaMor1vLmXJ+gNXbbOQLRSCdUwGRrVb4B
	Hz030OcFVTR2PpBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4391613763;
	Tue, 24 Nov 2026 11:59:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OxZzCQt8BWtSZAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Nov 2026 11:59:07 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id F101C27853; Tue, 24 Nov 2026 12:59:01 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	<linux-mm@kvack.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 7/8] fs: Protect deferred inode reclaim from freezing
Date: Tue, 24 Nov 2026 12:58:51 +0100
Message-ID: <20261124115850.3512-15-jack@suse.cz>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261124113450.3451-1-jack@suse.cz>
References: <20261124113450.3451-1-jack@suse.cz>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9157; i=jack@suse.cz; h=from:subject; bh=GhguULg2VJtISQ/4zq4DysAyz8WH840l64psi/AwLGw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBrBXv/fc1gmaKJ8EvJVldKI2uDDB2YO759P57ok OGaqQWeZ9iJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCawV7/wAKCRCcnaoHP2RA 2X8PB/4q7mb4yvP6V8BKV571CNxu13NE2rbGiVdC7IbY9Gaa0P63CRy2Nh+t/eYHBaTsRpsUlID mitIp/LXfc5OdLa+BqBoNxLujR4AQyW1ACWXGq8wJVM2yIDYLf8l1eSUeH/FBp6Ny2zm0YIzo51 04RPQfBXzLWcViPiezTJAmXiXbAiKnb0SreqqYdF4X2Z+dAkWJ0XdG4zxULSZtgsvmi9o1GcHtk LauMqYr9mk68XncTt0FtOkq/g5YiuExax7OKPX51c++YCTCmP+uTOcKcyesaw3gmAwzJHPxn34G owiMpBsk0aJvTr1nSGOUoiUY0nyPbhKU2cD5YjmDcvC7AhQN
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -11.80
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: w46u1uy36zcetawhkujxzwaqs7mbifk1
X-Rspamd-Queue-Id: 0CE3520003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795521548-615031
X-HE-Meta: U2FsdGVkX1+9RjWPLhRVY7y+NrvpngNjORhlqZCOTtGbWHPkGO6Acd+evpekAu6geu7W15jKZNIq/cu+ouQ9CF89WkMrb1NUPzQscCYqRtSfxpKuQiI09JSwuDwLlDh+f6we7firkGooRU6g114tfOuStWhXKm3+rP28+Y7oCSmGt0OO2/FNHPeCNhL2NmCD1ZPY+zF1hWqXSLyOIdTT5e/osG7EKYH/Pjj9IBp9Km9p1k9fqIQYLdlbR4V9tNLVdz87Q+OLK0Nnmi68AUl00BF2RDoNpzp/YQq/s1OGQJI73rdZsc9TyrYzpUZZPRexAmh6hrzGO1VybEDD8z+PLW6ZkGmG03EoenEp7fOxU6m86Q8IzwSM+9JvlED73wFz3/x/9+yUzWX2c3x2t+0J3znjJAovFHOF/gd8YBbsPcDOO3sLwl5w5Hm08oXmNI0ciEWHpi1zch7rRpQcT/8AYRMjgY+3xXr9gybWhHYqK56js7phwjboaABXKT/0Alwe2wimkPk/5IPm9jmBjTpNBPxY033gdOasWFu9I2bs0a7Cm8Pg3vp99t25tE4xv2cPJwuw464n+rGyff7R0ctMmmrzhxBLQqujjcoJ1nEIyCkup4+gNfRCg+qjgg4KjL7swC/bsuzOWlyTcDFz5nP4MsJ/0x3XqFN4iS2aMFXWANl2s6nL/w/MSdh3SBbCO0f4AAKIjIgj1c+GLUsUFSSwmmJlyz4BQ9EFUiVIlTdKo8m6HsAOMccEs+2YKnIuRBbMpJctxaL2bUAyWdICSORPfKxwgUJAtWcTWjxZevCPfHMDfIPa2JP7+kopIqsXr2jkJEPEXFdf71QTMh5PEfjTe3kE9qXNdto5MZ47O3oiQg83qYk7qR/o+kF3IImNqQqTvPwDe7NwVcnwtTGnm2Vyh0tUsmDNOv5LY76be4YoeREz4qjajJG0k5r1+1ydJ3W6i/TJUn643m5i7x465Y5
 BiQTN8Zv
 Uizsz10l5v0cThEEQOSVAVIokVKeP3OqEJHdatAuAC58hcEGnvpNVTNt/eE8BBoLEyC3VcXnsu8ZG2P6qPzEtZwigfqtjGz40fkt62iwRft6xpzHHHgOuv1Q3IxBcwTuVS71oO0vEGzBO+3OJDREOBmTXgI35bd//6MmCzCiJGaOh0kKeU71xisZT9FfH4Iijqq32cUo1ymQjzk5A7Yhei56fs4Jt9c3jdkXtkz9s0IPshEXmuEiPeOBTGFzWcX73zZ8c6w2lwR3idb/7gyljpUdlI29SQzgr9AWktqhyN5RA0IaAf3bCSgA3YITjAmnz76ZCXXqeY34jfrRC17AuV8hWMgseJ+QNMhXP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Sometimes inode reclaim needs writing to the filesystem. One prominent
case is when inode is unlinked and we are deleting it, another case is
when XFS needs to trim its speculative block preallocation. When inode
reclaim runs on frozen filesystem, this will block the deferred inode
reclaim worker so eventually all deferred inode reclaim could be stalled
in the system because all workers are waiting for some filesystem to
thaw.

Avoid this problem by protecting running deferred inode reclaim from
filesystem freezing (the SB_FREEZE_INTWRITE level) and by just skipping
starting new deferred inode reclaim for inodes on frozen filesystem.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c                     | 89 ++++++++++++++++++++++++++++------
 fs/super.c                     | 31 ++++++++++++
 include/linux/fs/super.h       |  1 +
 include/linux/fs/super_types.h |  2 +
 4 files changed, 107 insertions(+), 16 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index b6fa2965f4e8..25508c122e27 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1044,20 +1044,11 @@ static int get_deferred_sb_id(struct super_block *sb)
 	return hash_ptr(sb, 32) % deferred_reclaim.workers;
 }
 
-static void queue_deferred_reclaim(struct super_block *sb, int count,
-				   struct list_head *list)
+void wake_deferred_reclaim_workers(struct super_block *sb, int count)
 {
 	int id = get_deferred_sb_id(sb);
-	struct deferred_reclaim_queue *queue =
-					&deferred_reclaim.queues[id];
 	int i, wake_count;
 
-	spin_lock(&queue->lock);
-	list_splice_tail(list, &queue->list);
-	atomic_add(count, &sb->s_deferred_reclaim_count);
-	spin_unlock(&queue->lock);
-
-	/* Queue works to process inodes we've added to the list */
 	wake_count = DIV_ROUND_UP(count, INODE_RECLAIM_BATCH_SIZE);
 	if (wake_count > deferred_reclaim.workers)
 		wake_count = deferred_reclaim.workers;
@@ -1068,6 +1059,33 @@ static void queue_deferred_reclaim(struct super_block *sb, int count,
 	}
 }
 
+static void queue_deferred_reclaim(struct super_block *sb, int count,
+				   struct list_head *list)
+{
+	int id = get_deferred_sb_id(sb);
+	struct deferred_reclaim_queue *queue =
+					&deferred_reclaim.queues[id];
+
+	spin_lock(&queue->lock);
+	list_splice_tail(list, &queue->list);
+	atomic_add(count, &sb->s_deferred_reclaim_count);
+	/*
+	 * Make sure queued inodes are visible before we check whether deferred
+	 * reclaim is blocked. Pairs with the barrier in thaw_super_locked().
+	 */
+	smp_mb__after_atomic();
+	spin_unlock(&queue->lock);
+
+	/*
+	 * Skip waking up workers for frozen filesystem. They'd skip the inodes
+	 * anyway.
+	 */
+	if (atomic_read(&sb->s_deferred_reclaim_running) < 0)
+		return;
+
+	wake_deferred_reclaim_workers(sb, count);
+}
+
 /*
  * Walk the superblock inode LRU for freeable inodes and attempt to free them.
  * This is called from the superblock shrinker function with a number of inodes
@@ -1107,18 +1125,24 @@ static void __get_inode_reclaim_batch(int *start, int end,
 	for (i = *start; i < end; i++) {
 		struct deferred_reclaim_queue *queue =
 						&deferred_reclaim.queues[i];
-		struct list_head *entry, tmp;
+		struct inode *inode, *next;
 
 		if (list_empty_careful(&queue->list))
 			continue;
 		spin_lock(&queue->lock);
-		list_for_each(entry, &queue->list) {
-			if (*count >= INODE_RECLAIM_BATCH_SIZE)
+		list_for_each_entry_safe(inode, next, &queue->list, i_lru) {
+			/*
+			 * Skip inodes on frozen fs as we'd likely block. We
+			 * always accept inodes from read-only fs as there
+			 * eviction cannot require writing.
+			 */
+			if (!sb_rdonly(inode->i_sb) &&
+			    inode->i_sb->s_writers.frozen != SB_UNFROZEN)
+				continue;
+			list_move_tail(&inode->i_lru, list);
+			if (++(*count) >= INODE_RECLAIM_BATCH_SIZE)
 				break;
-			(*count)++;
 		}
-		list_cut_before(&tmp, &queue->list, entry);
-		list_splice_tail(&tmp, list);
 		spin_unlock(&queue->lock);
 		if (*count >= INODE_RECLAIM_BATCH_SIZE)
 			break;
@@ -1160,8 +1184,34 @@ static void inode_reclaim_update_stat(struct super_block *sb, unsigned int n,
 				READ_ONCE(sb->s_deferred_reclaim_delay));
 }
 
+/* Put inodes from sb back to reclaim queue */
+static void inode_reclaim_skip_inodes(struct list_head *list,
+				      struct super_block *sb)
+{
+	struct inode *inode;
+	struct deferred_reclaim_queue *queue;
+	struct list_head tmp;
+
+	queue = &deferred_reclaim.queues[get_deferred_sb_id(sb)];
+	list_for_each_entry(inode, list, i_lru)
+		if (inode->i_sb != sb)
+			break;
+	list_cut_before(&tmp, list, &inode->i_lru);
+	spin_lock(&queue->lock);
+	list_splice_tail(&tmp, &queue->list);
+	spin_unlock(&queue->lock);
+}
+
+static bool sb_deferred_reclaim_get(struct super_block *sb)
+{
+	return atomic_inc_unless_negative(&sb->s_deferred_reclaim_running);
+}
+
 static void sb_deferred_reclaim_put(struct super_block *sb, int n)
 {
+	if (atomic_dec_and_test(&sb->s_deferred_reclaim_running))
+		wake_up_var(&sb->s_deferred_reclaim_running);
+
 	/*
 	 * The elevated s_deferred_reclaim_count keeps sb alive until we drop
 	 * it. Use RCU to make sure sb isn't freed before the wakeup.
@@ -1209,6 +1259,13 @@ static void inode_reclaim_deferred(struct work_struct *work)
 				sb = inode->i_sb;
 				count = 0;
 				start = ktime_get_ns();
+				/* Protect us from filesystem freezing */
+				if (!sb_deferred_reclaim_get(sb)) {
+					inode_reclaim_skip_inodes(&inode_batch,
+								  sb);
+					sb = NULL;
+					continue;
+				}
 			}
 			count++;
 			list_del_init(&inode->i_lru);
diff --git a/fs/super.c b/fs/super.c
index fa345d5027bf..77e6ab6383b8 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -2435,6 +2435,19 @@ static inline bool may_unfreeze(struct super_block *sb, enum freeze_holder who,
 	return false;
 }
 
+/* Unblock deferred inode reclaim and wake workers */
+static void sb_unblock_deferred_reclaim(struct super_block *sb)
+{
+	atomic_set(&sb->s_deferred_reclaim_running, 0);
+	/*
+	 * Make sure we see all queued inodes added while deferred reclaim was
+	 * blocked. Pairs with the barrier in queue_deferred_reclaim()
+	 */
+	smp_mb();
+	wake_deferred_reclaim_workers(sb,
+		atomic_read(&sb->s_deferred_reclaim_count));
+}
+
 /**
  * freeze_super - lock the filesystem and force it into a consistent state
  * @sb: the super to lock
@@ -2561,10 +2574,26 @@ int freeze_super(struct super_block *sb, enum freeze_holder who, const void *fre
 		sb->s_writers.frozen = SB_UNFROZEN;
 		sb_freeze_unlock(sb, SB_FREEZE_PAGEFAULT);
 		sb_freeze_wake(sb);
+		/*
+		 * Deferred reclaim of some inodes could have been skipped
+		 * while sb->s_writers.frozen was set. Requeue work now.
+		 */
+		wake_deferred_reclaim_workers(sb,
+			atomic_read(&sb->s_deferred_reclaim_count));
 		deactivate_locked_super(sb);
 		return ret;
 	}
 
+	/*
+	 * Block deferred reclaim so that workers don't hang on frozen fs. We
+	 * wait for outstanding deferred reclaim here. Because the filesystem
+	 * is already partially frozen, workers will not start new deferred
+	 * reclaim for this sb.
+	 */
+	while (atomic_cmpxchg(&sb->s_deferred_reclaim_running, 0, -1))
+		wait_var_event(&sb->s_deferred_reclaim_running,
+			atomic_read(&sb->s_deferred_reclaim_running) == 0);
+
 	/* Now wait for internal filesystem counter */
 	sb->s_writers.frozen = SB_FREEZE_FS;
 	sb_wait_write(sb, SB_FREEZE_FS);
@@ -2577,6 +2606,7 @@ int freeze_super(struct super_block *sb, enum freeze_holder who, const void *fre
 			sb->s_writers.frozen = SB_UNFROZEN;
 			sb_freeze_unlock(sb, SB_FREEZE_FS);
 			sb_freeze_wake(sb);
+			sb_unblock_deferred_reclaim(sb);
 			deactivate_locked_super(sb);
 			return ret;
 		}
@@ -2648,6 +2678,7 @@ static int thaw_super_locked(struct super_block *sb, enum freeze_holder who,
 	sb->s_writers.freeze_owner = NULL;
 	sb_freeze_wake(sb);
 	sb_freeze_unlock(sb, SB_FREEZE_FS);
+	sb_unblock_deferred_reclaim(sb);
 out_deactivate:
 	deactivate_locked_super(sb);
 	return 0;
diff --git a/include/linux/fs/super.h b/include/linux/fs/super.h
index 1f063769ff5c..ad102dc5a461 100644
--- a/include/linux/fs/super.h
+++ b/include/linux/fs/super.h
@@ -258,6 +258,7 @@ int freeze_super(struct super_block *super, enum freeze_holder who,
 int thaw_super(struct super_block *super, enum freeze_holder who,
 	       const void *freeze_owner);
 
+void wake_deferred_reclaim_workers(struct super_block *sb, int count);
 int sb_init_dio_done_wq(struct super_block *sb);
 
 struct file;
diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
index fe952ef02b96..ec0ff6a504d4 100644
--- a/include/linux/fs/super_types.h
+++ b/include/linux/fs/super_types.h
@@ -241,6 +241,8 @@ struct super_block {
 
 	/* Number of inodes queued for deferred reclaim */
 	atomic_t				s_deferred_reclaim_count;
+	/* Number of workers processing deferred reclaim on this sb */
+	atomic_t				s_deferred_reclaim_running;
 	/* Average time to reclaim one deferred inode */
 	u64					s_deferred_reclaim_delay;
 
-- 
2.53.0


