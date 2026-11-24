Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC726606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 11:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=v/4xPgGA;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=XlKLsQ8U;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ppmF17Ao;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=yd4rb57N
Received: by kanga.kvack.org (Postfix)
	id CC29D6B0691; Tue, 24 Nov 2026 06:59:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5FF6B0690; Tue, 24 Nov 2026 06:59:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73C846B0699; Tue, 24 Nov 2026 06:59:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BBD196B068A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:59:11 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD5CEC0B51
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:59:10 +0000 (UTC)
X-FDA: 85469866860.04.2C3CC06
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7E68610000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:59:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="v/4xPgGA";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XlKLsQ8U;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ppmF17Ao;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yd4rb57N;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795521548;
	b=IDaDnH6Vkwit7VUdlkibX5/rmzfRVg9tE16Wf9fF0oPVL/97+M+zChsqNJvgkYYb/tDqpC
	bkpIt/rch0X/WghH2tB2E+0+wTOuFVdddCK7IaLm12uYp9p3hPDD6s5U8d2/smUJ+HCjPz
	XVJD2E/XjUwb4nZREurWZg7HzuZXF+Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795521548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WrgCH7DYy1ziAX1/xl2Q0C/TBl8uP2ZwamWc/xh6a5U=;
	b=fIYNyecTS4CsApq2BUkMbxmdOlPuoxgNg2FQizBISgLVBTyJAK+R7rLra+wJ+RRvXb5ako
	yB5guZoOGQzRWI8yk3zHUzCEz5dALExZp3Wj0w/DRAh0sauLFjzOmdZE0T8Mcl3K9KYfbr
	HEDaUbqNyvk3SnJ/cQt2QULcO4LTw3M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="v/4xPgGA";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XlKLsQ8U;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ppmF17Ao;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yd4rb57N;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E3A5821E1B;
	Tue, 24 Nov 2026 11:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795521547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WrgCH7DYy1ziAX1/xl2Q0C/TBl8uP2ZwamWc/xh6a5U=;
	b=v/4xPgGAPnNrn5p3YhZ4qAzzesbkzLuuHB18SMSyG1HAGDUcVUIowbEKRexFRvNqrh5IjW
	smek/ZlFvSE+7fD+FXIagDSnAGbZZrudRJKhDLWe8F7cIpV6uTuglK+W7Ftl7pQgoFtuuD
	8oSASXsRt51NQ0L4yNf1z5UfFawGm+k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795521547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WrgCH7DYy1ziAX1/xl2Q0C/TBl8uP2ZwamWc/xh6a5U=;
	b=XlKLsQ8U1nuAz+sevn2tma7QznJvhluhDwUbkj2CutgKducUGXU8eViRhOMqNDE3Tfp/8y
	qOORdWRWfzIFMIDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795521546; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WrgCH7DYy1ziAX1/xl2Q0C/TBl8uP2ZwamWc/xh6a5U=;
	b=ppmF17AoyVUvWlnsEE3Y9mZFkCmVnBJW64WgSfBk/NQzGFXK5HzRHv+Nhx/8aHhUpzc8Cz
	bikAjymjHCdz9c6XJW4XLkpfLHyZimfJT7HabWHyc4I4yndAv5syOcSxLpnqlCU6OFWGcJ
	lqFAVC23HxxnI+2q5pDMOxrsiEBSq3o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795521546;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WrgCH7DYy1ziAX1/xl2Q0C/TBl8uP2ZwamWc/xh6a5U=;
	b=yd4rb57NH5aC/A37jCMZ9XrTRkuKtcEuyOCP0LgmL3Wu+Wp2yNgIw6aK/P9uiwBj8lWQ0s
	Ob1gwcndtLikiDDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA4BB1339F;
	Tue, 24 Nov 2026 11:59:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RArHJAp8BWtAZAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Nov 2026 11:59:06 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id D9E7B2784B; Tue, 24 Nov 2026 12:59:01 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	<linux-mm@kvack.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 3/8] fs: Basic infrastructure for offloading inode reclaim
Date: Tue, 24 Nov 2026 12:58:47 +0100
Message-ID: <20261124115850.3512-11-jack@suse.cz>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261124113450.3451-1-jack@suse.cz>
References: <20261124113450.3451-1-jack@suse.cz>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11361; i=jack@suse.cz; h=from:subject; bh=qUXIx4rdqrWecwgv2f6iPkxWHCcXQn3VRLbwz2GrhiA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBrBXv8KJkE2IzDSvpOzcgtNAlL01hosECHZ5Dvx b979NVg2duJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCawV7/AAKCRCcnaoHP2RA 2Z3cB/93ZJvAlBUKLwVGq/oVz51vFlt2D0W5bjW5Tg2jDoglvGHv12HuLI3mCjiX11KFiA8AHM3 QdhEHj4Pe8lHt3juCTWsmwfbPPmRSHGHfvJnpwhPCc08MDYWgJBJXBjmdGezcuMzyGYJu+wzZg3 tDJV4v4evUerFPC2Sub4hG6KLSAziKUPC5A2ix63gaNe2CaosB3m59vzWx7ZTAFcfjhcSoKI+4k vBbZVl0beJ7i1G8YDMNWtLKz5ASsChtLcy1vuk78IiSMEhxodNC1xudcQPpFcJBJa/mprkSJxKI Pgd/ljU4j+FO4BWSCi8HsADjg9MN4jBG1GG+R8xjCxLuMPpZ
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -11.80
X-Rspamd-Queue-Id: 7E68610000A
X-Stat-Signature: gu3j99pfiois6z3st3ox7jeurhitwt5n
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795521548-726344
X-HE-Meta: U2FsdGVkX1+WbdiifHROzcnt/aIScKqbNigbqhPFEd494ftzk4ep0PTEVLs583iu2eWoyVer965YwDY2HxRhBj1BT2whIQQfgxSmWE7gUZB6y09i45h26e+i9NNaYtFmJpE53myibqjnySukbHT5sutaB/c5HxWjVS6R4SQ5JURxREIQvx9H++6u9mP8d5Bu0RmAvO/4bQda8DI1BU5bONjb3OnnbutOay5Mq06nA33shOCXlUQWFNprM0Y/Eejy1aQSAD5vwFcJbdkxD+SEH7zAhUHb/3IqQ+M/n8QUAvt1wVdplSwnlNnr7z8DcnpgnkVk7yPswGuK6swNoHIGPzzQ72J9rK+hCYjoI6AWEWW0YWrMA9AE1tZo+QePv+Pd/XrVa97qQdOFMNezQ68aqouc0Wa7HE/rQq6/UokudzbGDUJfN29sBcdVQRT+dcWCmRRuj+yzTE9s8sOjbIB5sEwFOWpW7QrnV2khLRODJSK8ZaD4fd+H1xna5B9jI+E6G0ZygecS7QtmQMs8mEW0cv01fQpAFLBPmDw0F6pz3FqtJRfNSAUoEjyCwhUHy+lfEgkhC7uBv9+l6SlFAKZaoYl1rgnm8M8K1qZPUFtPzXADJeh46Y8rd6lmg3dMCO7E5fQU86NY0C1flNOmgs1UIbYzeMc/CLj8p8lubH26kAj+8bHtQj9llJjuTPvMOg6SUdDu+f/pe1HXhyf586yAVjqN97IWcvRYHxmxzrCVczPOMGg8hIFTvOs7s8AAc8trNbbJKfhcnRCdDnnCk0MP5Y4eo4+UWy3/GvO0XGE//amiM+pAsjSYK1oKRwzWI+BE6VRIpLkc+9RRTDxbSKK/OLgV4nVkp7wiDCQZpigIpLWI4ymz3bqaB6TA9gJHUfnVaz5jsxT158VpbzM1Yy8HsZksYGc9DUFNet1E1yF0GtJ7nnQV7t/GMBw3HhaWyPNYC3pvEArKSbGCkJx3N8R
 gq8uLIO/
 ZbZ3jJ9fFzAof/LtPmLNVxd/FrVxxMHR/Lo/eyqAl7jS+tzy9Wxs7JFRsb8+DDLrsvb3WsZ1twvLqW1/dlksxWa0UzxOv/71BcqFZ2zinS5l6MgMid/1BcoyaQg5oZ1alH0zgPHbJmy4MH9v7yOUGf2rzFJ5qhN18XqNBZmr++iUdpBXJ443ppidWe1fDou0N+MIqkW/E5tgtS+sWw1fCRPpmMNdIBFkEHg+0JYFH2Be0qnWmBH/+WVUmkTfkAp11+nET9ApqvefX191ztY5O64QNeQju1ll9Mnt06EwFZzedKz95w9JCPqW5a5Imh66QNmVdAbMMwEC+IgPe3LT9P2SRoD0KEIAeUT2N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reclaim of some inodes is rather complex requiring running transactions
or doing other IO. Consequently filesystems end up doing GFP_NOFAIL
allocations from kswapd or even direct reclaim which is problematic
because forward progress of these allocations isn't guaranteed. Add
infrastructure for marking inodes whose reclaim is difficult and offload
reclaim of such inodes into a workqueue to not block kswapd with
difficult inode reclaim. The processing of the queued inodes happens in
parallel from several work items so that the reclaim has higher chances
of keeping up with the inflow of inodes if reclaim of some inodes
progresses slowly.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c                       | 215 ++++++++++++++++++++++++++++++-
 fs/super.c                       |   2 +
 include/linux/fs.h               |   3 +
 include/linux/fs/super_types.h   |   3 +
 include/trace/events/writeback.h |   3 +-
 5 files changed, 222 insertions(+), 4 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index a9f757fba23b..e08c6f0b0336 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -74,6 +74,25 @@ static DEFINE_PER_CPU(unsigned long, nr_unused);
 
 static struct kmem_cache *inode_cachep __ro_after_init;
 
+struct deferred_reclaim_queue {
+	struct list_head list;
+	spinlock_t lock;
+};
+
+/* Inodes for deferred reclaim */
+struct inode_deferred_reclaim {
+	int workers;			/* Number of parallel workers */
+	struct workqueue_struct *wq;	/* Workqueue for workers */
+	struct work_struct *work;	/* Workers */
+	/*
+	 * Queue of deferred inodes. The number of queues is the same number
+	 * as the number of workers
+	 */
+	struct deferred_reclaim_queue *queues;
+};
+
+static struct inode_deferred_reclaim deferred_reclaim;
+
 static long get_nr_inodes(void)
 {
 	int i;
@@ -965,7 +984,7 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 	 */
 	if (icount_read(inode) ||
 	    (inode_state_read(inode) &
-	     ~(I_REFERENCED | I_METADATA_WRITEBACK)) ||
+	     ~(I_REFERENCED | I_METADATA_WRITEBACK | I_DEFER_RECLAIM)) ||
 	    !mapping_shrinkable(&inode->i_data)) {
 		list_lru_isolate(lru, &inode->i_lru);
 		spin_unlock(&inode->i_lock);
@@ -1016,6 +1035,38 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 	return LRU_REMOVED;
 }
 
+/* Number of inodes to process in one reclaim batch */
+#define INODE_RECLAIM_BATCH_SIZE 16
+
+static int get_deferred_sb_id(struct super_block *sb)
+{
+	return hash_ptr(sb, 32) % deferred_reclaim.workers;
+}
+
+static void queue_deferred_reclaim(struct super_block *sb, int count,
+				   struct list_head *list)
+{
+	int id = get_deferred_sb_id(sb);
+	struct deferred_reclaim_queue *queue =
+					&deferred_reclaim.queues[id];
+	int i, wake_count;
+
+	spin_lock(&queue->lock);
+	list_splice_tail(list, &queue->list);
+	atomic_add(count, &sb->s_deferred_reclaim_count);
+	spin_unlock(&queue->lock);
+
+	/* Queue works to process inodes we've added to the list */
+	wake_count = DIV_ROUND_UP(count, INODE_RECLAIM_BATCH_SIZE);
+	if (wake_count > deferred_reclaim.workers)
+		wake_count = deferred_reclaim.workers;
+	for (i = 0; i < wake_count; i++) {
+		queue_work(deferred_reclaim.wq,
+			   &deferred_reclaim.work[id]);
+		id = (id + 1) % deferred_reclaim.workers;
+	}
+}
+
 /*
  * Walk the superblock inode LRU for freeable inodes and attempt to free them.
  * This is called from the superblock shrinker function with a number of inodes
@@ -1025,14 +1076,169 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 long prune_icache_sb(struct super_block *sb, struct shrink_control *sc)
 {
 	LIST_HEAD(freeable);
-	long freed;
+	long freed, deferred = 0;
+	struct inode *inode, *tmp;
 
 	freed = list_lru_shrink_walk(&sb->s_inode_lru, sc,
 				     inode_lru_isolate, &freeable);
-	dispose_list(&freeable);
+
+	list_for_each_entry_safe(inode, tmp, &freeable, i_lru) {
+		if (inode_state_read_once(inode) & I_DEFER_RECLAIM) {
+			deferred++;
+			continue;
+		}
+		list_del_init(&inode->i_lru);
+		evict(inode);
+		cond_resched();
+	}
+
+	if (!list_empty(&freeable))
+		queue_deferred_reclaim(sb, deferred, &freeable);
 	return freed;
 }
 
+static void __get_inode_reclaim_batch(int *start, int end,
+				      struct list_head *list, int *count)
+{
+	int i;
+
+	for (i = *start; i < end; i++) {
+		struct deferred_reclaim_queue *queue =
+						&deferred_reclaim.queues[i];
+		struct list_head *entry, tmp;
+
+		if (list_empty_careful(&queue->list))
+			continue;
+		spin_lock(&queue->lock);
+		list_for_each(entry, &queue->list) {
+			if (*count >= INODE_RECLAIM_BATCH_SIZE)
+				break;
+			(*count)++;
+		}
+		list_cut_before(&tmp, &queue->list, entry);
+		list_splice_tail(&tmp, list);
+		spin_unlock(&queue->lock);
+		if (*count >= INODE_RECLAIM_BATCH_SIZE)
+			break;
+	}
+	*start = i;
+}
+
+/* Move a batch of inodes from queued lists to our private list */
+static int get_inode_reclaim_batch(int *id, struct list_head *list)
+{
+	int count = 0;
+	int orig_id = *id;
+
+	__get_inode_reclaim_batch(id, deferred_reclaim.workers, list, &count);
+	if (count >= INODE_RECLAIM_BATCH_SIZE)
+		return count;
+	/* Wrap around */
+	if (orig_id > 0) {
+		*id = 0;
+		__get_inode_reclaim_batch(id, orig_id, list, &count);
+	}
+	return count;
+}
+
+
+static void inode_reclaim_deferred(struct work_struct *work)
+{
+	struct inode *inode;
+	LIST_HEAD(inode_batch);
+	/*
+	 * We start with the list corresponding to the work but rolling a dice
+	 * would work as well
+	 */
+	int id = work - deferred_reclaim.work;
+
+	while (1) {
+		if (!get_inode_reclaim_batch(&id, &inode_batch))
+			break;
+		while (!list_empty(&inode_batch)) {
+			struct super_block *sb;
+
+			/*
+			 * inode_batch list is private and I_FREEING flags
+			 * protect us from anybody else trying to remove the
+			 * inode from the LRU list. No locking needed.
+			 */
+			inode = list_first_entry(&inode_batch, struct inode,
+						 i_lru);
+			list_del_init(&inode->i_lru);
+			sb = inode->i_sb;
+			evict(inode);
+			/*
+			 * The elevated s_deferred_reclaim_count keeps sb alive
+			 * until we drop it. Use RCU to keep sb alive until
+			 * the wakeup is done.
+			 */
+			rcu_read_lock();
+			if (atomic_dec_and_test(&sb->s_deferred_reclaim_count))
+				wake_up_var(&sb->s_deferred_reclaim_count);
+			rcu_read_unlock();
+			cond_resched();
+		}
+	}
+}
+
+/* Maximum number of inode reclaim workers */
+#define MAX_RECLAIM_WORKERS 16
+
+static void __init deferred_reclaim_init(void)
+{
+	int workers = MAX_RECLAIM_WORKERS;
+	int i;
+
+	/* Scale down the number of workers for small systems */
+	if (workers > num_possible_cpus())
+		workers = num_possible_cpus();
+
+	deferred_reclaim.workers = workers;
+	deferred_reclaim.work = kmalloc_objs(struct work_struct, workers);
+	deferred_reclaim.queues =
+			kmalloc_objs(struct deferred_reclaim_queue, workers);
+	if (!deferred_reclaim.work || !deferred_reclaim.queues)
+		panic("Failed to allocate deferred inode reclaim queues");
+
+	deferred_reclaim.wq = alloc_workqueue("deferred-inode-reclaim",
+			WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_UNBOUND,
+			workers);
+	if (!deferred_reclaim.wq)
+		panic("Failed to allocate deferred inode reclaim workqueue");
+
+	for (i = 0; i < workers; i++) {
+		INIT_WORK(&deferred_reclaim.work[i], inode_reclaim_deferred);
+		spin_lock_init(&deferred_reclaim.queues[i].lock);
+		INIT_LIST_HEAD(&deferred_reclaim.queues[i].list);
+	}
+}
+
+/*
+ * Mark inode for deferred reclaim. When slab reclaim path will be freeing the
+ * inode, it will not call evict() directly but rather offload it to a worker
+ * in a workqueue. This is useful when inode reclaim is expected to take a
+ * long time (e.g. because it needs to do IO) so that it doesn't block kswapd
+ * or because it needs allocating memory (which cannot be guaranteed from
+ * reclaim path).
+ *
+ * Note that we currently don't provide a way to unmark inode for deferred
+ * reclaim. It could be done but the benefit is unclear. The rationale is that
+ * to make inode hard to reclaim, relatively expensive things like writing data
+ * to the file have to be done and in such case the additional CPU overhead and
+ * latency of offloading the inode reclaim is negligible in the overall load.
+ */
+void mark_inode_reclaim_deferred(struct inode *inode)
+{
+	if (inode_state_read_once(inode) & I_DEFER_RECLAIM)
+		return;
+
+	spin_lock(&inode->i_lock);
+	inode_state_set(inode, I_DEFER_RECLAIM);
+	spin_unlock(&inode->i_lock);
+}
+EXPORT_SYMBOL_GPL(mark_inode_reclaim_deferred);
+
 static void __wait_on_freeing_inode(struct inode *inode, bool hash_locked, bool rcu_locked);
 static bool igrab_from_hash(struct inode *inode);
 
@@ -2680,6 +2886,9 @@ void __init inode_init(void)
 					 SLAB_ACCOUNT),
 					 init_once);
 
+	/* Deferred inode reclaim infrastructure */
+	deferred_reclaim_init();
+
 	/* Hash may have been set up in inode_init_early */
 	if (!hashdist)
 		return;
diff --git a/fs/super.c b/fs/super.c
index 4e68e7cac342..fa345d5027bf 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -652,6 +652,8 @@ void deactivate_locked_super(struct super_block *s)
 	struct file_system_type *fs = s->s_type;
 	if (atomic_dec_and_test(&s->s_active)) {
 		shrinker_free(s->s_shrink);
+		wait_var_event(&s->s_deferred_reclaim_count,
+			       !atomic_read(&s->s_deferred_reclaim_count));
 		fs->kill_sb(s);
 
 		kill_super_notify(s);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 92a2841184f3..fc1a2cc9eb21 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -744,6 +744,7 @@ enum inode_state_flags_enum {
 	I_SYNC_QUEUED		= (1U << 17),
 	I_PINNING_NETFS_WB	= (1U << 18),
 	I_METADATA_WRITEBACK	= (1U << 19),
+	I_DEFER_RECLAIM		= (1U << 20),
 };
 
 #define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
@@ -2229,6 +2230,8 @@ static inline void set_inode_metadata_writeback(struct inode *inode)
 	spin_unlock(&inode->i_lock);
 }
 
+void mark_inode_reclaim_deferred(struct inode *inode);
+
 /*
  * returns the refcount on the inode. it can change arbitrarily.
  */
diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
index 4454e3574b2c..fc8f7f2261e2 100644
--- a/include/linux/fs/super_types.h
+++ b/include/linux/fs/super_types.h
@@ -239,6 +239,9 @@ struct super_block {
 
 	struct shrinker				*s_shrink;	/* per-sb shrinker handle */
 
+	/* Number of inodes queued for deferred reclaim */
+	atomic_t				s_deferred_reclaim_count;
+
 	/* Number of inodes with nlink == 0 but still referenced */
 	atomic_long_t				s_remove_count;
 
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index b7dfc9f7bb61..c2a5b492a71a 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -28,7 +28,8 @@
 		{I_DONTCACHE,		"I_DONTCACHE"},		\
 		{I_SYNC_QUEUED,		"I_SYNC_QUEUED"},	\
 		{I_PINNING_NETFS_WB,	"I_PINNING_NETFS_WB"},	\
-		{I_LRU_ISOLATING,	"I_LRU_ISOLATING"}	\
+		{I_LRU_ISOLATING,	"I_LRU_ISOLATING"},	\
+		{I_DEFER_RECLAIM,	"I_DEFER_RECLAIM"}	\
 	)
 
 /* enums need to be exported to user space */
-- 
2.53.0


