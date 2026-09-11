Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FC1CC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:52:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7240E6B0098; Fri, 11 Sep 2026 04:52:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3376B0099; Fri, 11 Sep 2026 04:52:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2366B009B; Fri, 11 Sep 2026 04:52:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8B56B0098
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:52:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75625C0161
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:52:15 +0000 (UTC)
X-FDA: 85200864630.17.ED66439
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id 557BEC0003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:52:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GAk8hEHa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3gSdYmG3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="2Gr/ahqS";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LAP0FqxC;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789116733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xEjVr3VqOsgw2/6xz7pzlUq656yoK+pHIhRM+5iKwcc=;
	b=Y2GZo8EnI6X3M+NSlzWRLCv8LMuqZQi+A0ZqcIsG9aSsrmaHgLR5u6rlXfh0ANqSS8pH/a
	fFPIUjeK2ZXNLymoaxkRk0lrw+CZHyXn/MNydtsaT1+UeFmfuL9xco8Te6Jp69Oua2bEAg
	UHM8tct8Jvf9H4OdFcRYeL+gL8AJNog=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789116733;
	b=S22NykrShrdTZCPSeMSNHH3iI6uEMZweJC+hSXcQyZ2vzvp8PlPibMUwXAzeKy98np/q6j
	DWoygx90QPCq3S7bYucM81uOwhoMyWKreKMx6IRFFYgx4/PY2Mxcur0PueCXG2DwV+HhkS
	XxEadg09uZ9eErKY7cY0x+jvPHcmobc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GAk8hEHa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3gSdYmG3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="2Gr/ahqS";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LAP0FqxC;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E7C2C21B8B;
	Fri, 11 Sep 2026 08:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789116728; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEjVr3VqOsgw2/6xz7pzlUq656yoK+pHIhRM+5iKwcc=;
	b=GAk8hEHaX6uRqvvjj9LAN0Xi9siOtOTW1hvF15VUt2ZdR58fTrfxu1z8EYsXbqfn2sKhGD
	1pKxTF2fw4YCHReRJZQB4HL58HzlhapyMn1WJ57RXlGumgao4eT0WTqES5J8TptCUo+Tsm
	KJrIo35ugRE0Mnb48NkbKT9BtWG9E+I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789116728;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEjVr3VqOsgw2/6xz7pzlUq656yoK+pHIhRM+5iKwcc=;
	b=3gSdYmG3s0Ft4Ct8cqEsPYFabItr37j+88E0i+yMhIGOPiEawE0cvKZ7AA5JrszfKN+jO2
	852EwAEkfbi003Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789116723; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEjVr3VqOsgw2/6xz7pzlUq656yoK+pHIhRM+5iKwcc=;
	b=2Gr/ahqSq9yEOaPV4hdG5/XFZP0sQtZALrvdx9a38U8p7ifiAIGzdcK9qsBRNYqO7zrRoE
	a6JvthhLSuJPN5WgYuX/sOhdqJAQT0peu10rZ2Z1D0SlAs6bdlZ5wu1KBmhEbS6xn4ZhAW
	m3nkFW16ezdpb9saZEE1r8vz2m8M3Ns=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789116723;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEjVr3VqOsgw2/6xz7pzlUq656yoK+pHIhRM+5iKwcc=;
	b=LAP0FqxC/uWh0Qwg2qjue/d3ZUDMjzMEAyciL8XrcKUhSDxNVHmzV7/Tj7P2rox3GUdTh+
	AEvVvqqpD/W3oICQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B36CF137DE;
	Fri, 11 Sep 2026 08:51:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rWvMKy7Bo2q3HwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 11 Sep 2026 08:51:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D37CCA13B7; Fri, 11 Sep 2026 10:51:53 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 4/5] fs: Add throttling to deferred inode reclaim
Date: Fri, 11 Sep 2026 10:51:40 +0200
Message-ID: <20260911085142.1774803-9-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260911081309.14137-1-jack@suse.cz>
References: <20260911081309.14137-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7558; i=jack@suse.cz; h=from:subject; bh=nD2yHzd9rrfz+6A8vWYBVWn86hUooAQeeGgTPFndC1o=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqo8Ehzakv637PI+5cECPIrkAikJItnBL6W/XwU mCGCaNO8KmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaqPBIQAKCRCcnaoHP2RA 2UahB/9ouRJWwI11u5NkcNGdGIx/f45t2/DkKJ+TIdXZ1tN9zJ8f/hRU54+12oqs4wkSl4YdtHv XmnxiTQcNCxIPyxPNl+gt2pAztZytvW3EBBg5bdKMBlWQ+/hQSSytbMn1/rtGUS0xXNJOe0Zae4 4jUkdmH+Oozj/wDaviMrRhGb+zyX2215Mpeffm1+4olNE+fubM4Vy0wKse3WKq0a98FSZBM6DXD 33njSPpxMTAaVLtXmTpKTHL4poQhJQexH7aLc4pzP+8oEqmiu4D+BX/rheFsao4iy7qyuPXS8hM qjhvUkGcWDY7tUNHjFqseG5WwwA8Vsu00QPg/X0oDr9nWgSm
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ti818ja9cc85zj8iunebpswd1cqpuydr
X-Rspam-User: 
X-Rspamd-Queue-Id: 557BEC0003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789116733-790857
X-HE-Meta: U2FsdGVkX19UozlazOGfCNBhRtSfTdUjw7+Mno9Euix93hV+7wPLH38Oah7WHBvARymWfV2uKFCs33dYSfiuzXNbNUte4zJ7i1Cr268ZbPZ/XwOxH9Pv7pp3pomLTDzWR5VIV0Un0oE1JieIXQLGH5NrPOpKXr6/Px0ENDVtHxQe0OKy3K1tGQsymKa6aiQDZI1Jtp9FWErs3XDilUxO/8uoisxO6eq0e3yYi2tmxrDcZjC+LA9ZEuxxYMSqME30cwBawORhSkQMNk+aGsM3rWn256j+cEvb4vKsyyTTkH3+HK1Lx8eD6/Kb9g37UNKR2a61HCyWn2hobhOFD/irUOJglnuh4zvjek7u7Y4pJh38MV7cyPHlVrpiqKMltne7052CDW7TJy3pEf/FlN0Yxx4T8WD/706+uSnANU6KP58srvTQSC+BKSnu51HT8wjuD9ErJLBq1NlMdqGKgP8kTZk1YS4IEOIoQteWOpeDAdlA6pHHKIejalEX6S6kEEbgRQvh+YsZY1PpV0JBpIKWSWFd9uSuHbpyTTSdlgV0LLdMfS8H068HtyHL4Odg1/H3wUmgetrLlLpO+m5YdBLPSAgl9SaUhGJzaFwY1IjlAJupByCOA4eZgWfAzkbaDQabQYFzn2A7xyXeNnLE+9rWW/kNpdfBFdkMYoBjHcF5XNZwVo1PP2W1GUpIDCHp7D1e9qcur0p5qH1NJyT5EBe6MnXTqsBwgU+x/lbBr/UHmAfwjyQw4Me6acGHuEYPsMQkjeYBc6BOSusU9Lk6t3JkyKyUuqioLn+VpsD0HmIjnMsDLQHTOXvchrEcz830gB+sWS54SvesfXeIqeN+lbP/UXdINSwQi0i3RI+7epwBOk4IpfBnzgq17NOaFT2piwMZZFoYxviLlTHcDEhZm4JyRDu9KffFBoo4qJyCNkYot2zcDLisXXkaEyk12Wr1MkTR5qDwsGAdy35uixQxcYH
 m2B+1Fch
 fUEUg+hA8gGVwshgRPouommfVCTFiAMF+ExFikbC5oY5VJ0WiPHy2CF7CZx9azwFgY9PLvqKo6v8/33qyjVWG6jzvA5OuvO1EB+EclwnpjRI9KYj0ZH6otsCLbT3ylyoj/fMWPboA3HJ36eJSeVLixdkPdtguaXthZ5wqncP0wbQY4h2YmKA6gPL1bF9OuV9jm3lpDtDQAy70DpczmDvOF6kwrgTgVp9wV+o92yqdwLD7JTU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Deferring difficult inode reclaim from prune_icache_sb() to a workqueue
removes the natural feedback loop of blocking tasks in direct reclaim
until they make space for new allocations. This can result in the list
of deferred inodes to grow beyond any bounds and possibly push the
machine to a reclaim storm or OOM.

Add a throttling mechanism slowing down tasks in
mark_inode_reclaim_deferred() if the number of deferred inodes to
reclaim for a superblock grows over limit. We measure average time it
takes to reclaim inode on deferred list for a superblock and block tasks
proportionally to that.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c                       | 102 +++++++++++++++++++++++++++----
 include/linux/fs/super_types.h   |   2 +
 include/trace/events/writeback.h |  51 ++++++++++++++++
 3 files changed, 144 insertions(+), 11 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index e902095cf39b..0491300c5ccb 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1113,23 +1113,53 @@ static int get_inode_reclaim_batch(int *id, struct list_head *list)
 	return count;
 }
 
+static void inode_reclaim_update_stat(struct super_block *sb, unsigned int n,
+				      u64 start)
+{
+	u64 delay;
+
+	if (!sb)
+		return;
+
+	delay = div_u64(ktime_get_ns() - start, n);
+	/*
+	 * Smooth delay updates with exponential moving average. Updates can
+	 * get lost if workers race but we don't really care.
+	 */
+	WRITE_ONCE(sb->s_deferred_reclaim_delay,
+		   (63 * READ_ONCE(sb->s_deferred_reclaim_delay) + delay) / 64);
+
+	trace_inode_reclaim_update_stat(sb, n, delay,
+				READ_ONCE(sb->s_deferred_reclaim_delay));
+
+	/*
+	 * The elevated s_deferred_reclaim_count keeps sb alive until we drop
+	 * it
+	 */
+	if (!atomic_sub_return(n, &sb->s_deferred_reclaim_count))
+		wake_up_var(&sb->s_deferred_reclaim_count);
+}
 
 static void inode_reclaim_deferred(struct work_struct *work)
 {
 	struct inode *inode;
 	LIST_HEAD(inode_batch);
+	u64 start;
+	int id, count;
+	struct super_block *sb;
+
 	/*
 	 * We start with the list corresponding to the work but rolling a dice
 	 * would work as well
 	 */
-	int id = work - deferred_reclaim.work;
+	id = work - deferred_reclaim.work;
 
 	while (1) {
 		if (!get_inode_reclaim_batch(&id, &inode_batch))
 			break;
-		while (!list_empty(&inode_batch)) {
-			struct super_block *sb;
+		sb = NULL;
 
+		while (!list_empty(&inode_batch)) {
 			/*
 			 * inode_batch list is private and I_FREEING flags
 			 * protect us from anybody else trying to remove the
@@ -1137,17 +1167,20 @@ static void inode_reclaim_deferred(struct work_struct *work)
 			 */
 			inode = list_first_entry(&inode_batch, struct inode,
 						 i_lru);
+			if (inode->i_sb != sb) {
+				inode_reclaim_update_stat(sb, count, start);
+
+				sb = inode->i_sb;
+				count = 0;
+				start = ktime_get_ns();
+			}
+			count++;
 			list_del_init(&inode->i_lru);
-			sb = inode->i_sb;
 			evict(inode);
-			/*
-			 * The elevated s_deferred_reclaim_count keeps sb alive
-			 * until we drop it
-			 */
-			if (atomic_dec_and_test(&sb->s_deferred_reclaim_count))
-				wake_up_var(&sb->s_deferred_reclaim_count);
 			cond_resched();
 		}
+
+		inode_reclaim_update_stat(sb, count, start);
 	}
 }
 
@@ -1183,14 +1216,61 @@ static void __init deferred_reclaim_init(void)
 	}
 }
 
+/*
+ * Size of deferred reclaim list from which we start throttling tasks creating
+ * inodes marked for deferred reclaim.
+ */
+#define INODE_DEFERRED_RECLAIM_LIMIT 8192
+
+static void throttle_inode_deferred_reclaim(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	unsigned int len;
+
+	/*
+	 * If inodes with deferred reclaim are accumulating too much, slow down
+	 * tasks creating them. This doesn't provide any kind of guarantee on
+	 * the length of the deferred list since lots of inodes with
+	 * I_DEFER_RECLAIM can be already present in the inode cache and we
+	 * have no control when they reach the deferred list. But if the
+	 * pressure on the deferred list is sustained, the balance should
+	 * eventually be established.
+	 */
+	len = atomic_read(&sb->s_deferred_reclaim_count);
+	if (len > INODE_DEFERRED_RECLAIM_LIMIT) {
+		u64 delay = READ_ONCE(sb->s_deferred_reclaim_delay);
+
+		if (!delay)
+			return;
+		/*
+		 * Scale the delay based on how much we exceed the limit. Wait
+		 * at most 4x as long as estimated time to reclaim the inode.
+		 */
+		len = min(len, 5 * INODE_DEFERRED_RECLAIM_LIMIT);
+		delay = div_u64(delay * (len - INODE_DEFERRED_RECLAIM_LIMIT),
+				INODE_DEFERRED_RECLAIM_LIMIT);
+		trace_mark_inode_reclaim_deferred_throttle(inode, len, delay);
+
+		schedule_timeout_killable(nsecs_to_jiffies(delay));
+	}
+}
+
 void mark_inode_reclaim_deferred(struct inode *inode)
 {
+	bool throttle = false;
+
 	if (inode_state_read_once(inode) & I_DEFER_RECLAIM)
 		return;
 
 	spin_lock(&inode->i_lock);
-	inode_state_set(inode, I_DEFER_RECLAIM);
+	if (!(inode_state_read(inode) & I_DEFER_RECLAIM)) {
+		inode_state_set(inode, I_DEFER_RECLAIM);
+		throttle = true;
+	}
 	spin_unlock(&inode->i_lock);
+
+	if (throttle)
+		throttle_inode_deferred_reclaim(inode);
 }
 EXPORT_SYMBOL_GPL(mark_inode_reclaim_deferred);
 
diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
index a41bd57fc2e6..6db5df6fd35f 100644
--- a/include/linux/fs/super_types.h
+++ b/include/linux/fs/super_types.h
@@ -234,6 +234,8 @@ struct super_block {
 
 	/* Number of inodes queued for deferred reclaim */
 	atomic_t				s_deferred_reclaim_count;
+	/* Average time to reclaim one deferred inode */
+	u64					s_deferred_reclaim_delay;
 
 	/* Number of inodes with nlink == 0 but still referenced */
 	atomic_long_t				s_remove_count;
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 4a9cfe458820..aec38eaeb10e 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -881,6 +881,57 @@ DEFINE_EVENT(writeback_inode_template, sb_clear_inode_writeback,
 	TP_ARGS(inode)
 );
 
+TRACE_EVENT(inode_reclaim_update_stat,
+	TP_PROTO(
+		struct super_block *sb,
+		unsigned int n,
+		u64 batch_delay,
+		u64 avg_delay
+	),
+	TP_ARGS(sb, n, batch_delay, avg_delay),
+
+	TP_STRUCT__entry(
+		__field(dev_t,		dev)
+		__field(unsigned int,	n)
+		__field(u64,		batch_delay)
+		__field(u64,		avg_delay)
+	),
+
+	TP_fast_assign(
+		__entry->dev = sb->s_dev;
+		__entry->n = n;
+		__entry->batch_delay = batch_delay;
+		__entry->avg_delay = avg_delay;
+	),
+
+	TP_printk("dev %d,%d batch size %u batch delay %llu ns avg delay %llu ns",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->n,
+		  __entry->batch_delay, __entry->avg_delay)
+);
+
+TRACE_EVENT(mark_inode_reclaim_deferred_throttle,
+	TP_PROTO(struct inode *inode, unsigned int len, u64 delay),
+	TP_ARGS(inode, len, delay),
+
+	TP_STRUCT__entry(
+		__field(u64,		ino)
+		__field(dev_t,		dev)
+		__field(unsigned int,	len)
+		__field(u64,		delay)
+	),
+
+	TP_fast_assign(
+		__entry->ino = inode->i_ino;
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->len = len;
+		__entry->delay = delay;
+	),
+
+	TP_printk("dev %d,%d ino %llu deferred list len %u delay %llu ns",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->len, __entry->delay)
+);
+
 #endif /* _TRACE_WRITEBACK_H */
 
 /* This part must be outside protection */
-- 
2.51.0


