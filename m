Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1CE4CA9ED2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 08:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4EE26B009E; Mon, 12 Oct 2026 04:24:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD6BC6B009D; Mon, 12 Oct 2026 04:24:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4F066B0099; Mon, 12 Oct 2026 04:24:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83B816B0098
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 04:24:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC6301409AC
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:24:16 +0000 (UTC)
X-FDA: 85313286912.15.B250195
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id B07CE140005
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:24:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=I7db5idA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="trhqWu/H";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="iTeS/ozs";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="H/rO+ziP";
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791793454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p4TK6AUvLenbTf0x+nwoWS4sSHUrEZN3CU4cYNSyZf0=;
	b=VQ++O3fr/oeJ7i9bB5mlIrxQxGpPnE7xX6z8mo1LA9nZOQh1vjFKK880aNDk+QSNT78f9u
	YiKGvyHRlzd+v6iZmmayno20mA9YFo04o2cCQ3N9Ngf/u5IMJ8fk5z6Sx0XGPsS9gz54gv
	IKZzI2iQVp3n/aRwfZiE2BCRkPNf7lU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791793454;
	b=leCZv46/nCNPH+RH1ZheVhhD2tQAE+jOvedUAgoX5OXWws8H02jUkl9hj+/dLTdTaVPjzB
	p4nIcudxcSvwZ2FZxIf2aynJuW3sR0L4WLZ70ubGeIHqR1Fj0oI6XzwLMe3QQ81b3ppx1i
	XJbAMu0StZzY51271fhUXrVSWotPVKQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=I7db5idA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="trhqWu/H";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="iTeS/ozs";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="H/rO+ziP";
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2AAAB21E44;
	Mon, 12 Oct 2026 08:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791793453; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p4TK6AUvLenbTf0x+nwoWS4sSHUrEZN3CU4cYNSyZf0=;
	b=I7db5idASIQRSW8ETcp889nTVNrCfSoWejXWm4Jw7/5VxBcP3Bbj0bRqHeVuOTKLJ+dE6A
	J8XvWgX5JtBFnIYbCXe8xmrzFo4F4icEjuWsACn9/dVawYMmj2DXCS8VBexTB81VK0V0zH
	SXdDPC8726ukvql0cj2lkg5Up6ugoZ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791793453;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p4TK6AUvLenbTf0x+nwoWS4sSHUrEZN3CU4cYNSyZf0=;
	b=trhqWu/H9JRf/54LpFKaXT//PJrhAyHaBbrjGG/2XkkEqfZFWKEA7LvKgyupH8mislUk8I
	v27o3/6xQ2VpKpBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791793452; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p4TK6AUvLenbTf0x+nwoWS4sSHUrEZN3CU4cYNSyZf0=;
	b=iTeS/ozsC8uuZXYevZLD0+RZYcx6TXTL+8k3nMQxWchaXZ9b45jqfZIdjaZsapJKha+7yI
	8o9lDKC0yl7zAjJ91nAac24TFK98qI47d8EJ9m3X/QfNSJkrnirs/nBIHmE8raOvOD+wfA
	VMou0WakBADfNcYKwQp+1r9KhfQySkk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791793452;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p4TK6AUvLenbTf0x+nwoWS4sSHUrEZN3CU4cYNSyZf0=;
	b=H/rO+ziP98QWoQ+sV6exjQAHNmNsfU34Re7I6LXu47zZibtvlWQ61ikJSzNqYnAZ70m7D/
	Y8lsYBO+p7jXKJAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B7433139AF;
	Mon, 12 Oct 2026 08:24:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Qrl4JSuZzGoYHwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 08:24:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A58F3A140D; Mon, 12 Oct 2026 10:24:10 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5/7] fs: Add throttling to deferred inode reclaim
Date: Mon, 12 Oct 2026 10:23:43 +0200
Message-ID: <20261012082356.3121725-12-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261009133253.20102-1-jack@suse.cz>
References: <20261009133253.20102-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9182; i=jack@suse.cz; h=from:subject; bh=LwmwmLNOGGuzwypggTSPss0dAlJ7wY1Wv7InMsohE44=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqzJkg1Ix/uG7TAsTkbc5v+g7p2FFDliTXaRwHB nFrKBxUzK+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCasyZIAAKCRCcnaoHP2RA 2eBpCACp6OJW7fZoWklCGz86teMtJMiFFDwkhlaIJjAEI/4tALXE8wUXVXFvUrrf46MQsgygiXw aCk7Ytz8D7TIGFA4T5sKyWWBhrFZcZKS1cBrMhlfzGF3yZX9s792Hr5synnWhHMlcaTGjIMvW/t az+OoOECbNSvqXbETrRmwQyjw/ixIBf7Bt4H0+6NkEK/tLJ3CEsXoZS97WGkr/CuyCXrFs3rd1I X7ngOvu9wAfuBio23AHi3YV4C6OIOdRIf5O/UZb/8EKnyg3czFGeOJkMxhSYjgm9xOp0Re1kGYQ +LAHb3mrzjrSBOZIK61j3vaJ0mywEOha/0asIyPdxjub7nVQ
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: B07CE140005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: wrj5661664dgfok37c5zfef4u6w773xc
X-HE-Tag: 1791793454-358620
X-HE-Meta: U2FsdGVkX19KyF2GF7UrsfDQip+oCaaW43zgIWQLLQ/WW84p86Lj/Xtau9FjoTR0ESo+zmE2n2/d2QcQJbZ5Aul+Bc1KQDl9QdHpyXVbDvLoSapYaDXOWctCZWiKix1N6tBnYuH2/5d/LBZ3gQP/RfnPFNGkHr2/hLzsOqcVb2QAzn1I8lmxQoqJ82Vphizv33f1ySpNopLpl17ZpbT2O1fEtV/ZUYiSdRc++iYXeZd3G/ab6liiOgCrIg72UujE/x4R8I5+KHsk2gZxbyAGy+0d57atZ69MDKfrIwYpoVpVQSC39HOv/aoypzDz9+Q0agpE3WSfwSKVItvn63gxCRtnJFrxlS0+br18cKCPW53gvwpNrw7EUqcXRqsQ1pTIrIOWPpQGZlpfB3gGSybz5AsQU/L9UM7QwcCsBANzoj5Bdcj1w4s0sq93gRxCGhtrI3vvZ7DamCXUCwhnkh4x+Khk8TZgIGcdhMKY+jCd/EU0gf9MiBCpO/0/yLznEtgQ+pIJvE3HZTlc5tRFhPrkV+rIv8yQhzg6DkOSw1EcXiK9mPzhYQEBALzUvo4yWwO6qrxlvmpE1qa1p6HGXAiFz1kXigAX7XJpEyhXp4LfYg2vkm1nB2JjEykJRQfSVLLfQ4G93lDCEi0ERKwtJbrxsNkmvb42CtLMUc6z/mPTU6NcCs/7TaKbjG/ggPBz7FlfwUHtgBc0J5BfY8AOd3XxJZLheS9GqcW/KVDiJXkeLyhdSufhQDkPOLcZ3nZXaFME6Tt/TnUztww69v5QjtViiU8qH2/Mo9GpKE1aTI/dwn5DOBSwMxf7ecuEnL5w7aG0WCTv3CKIlzHi9Ss0R9jFHzBKU0d+9Hhi6ENTH3p4q88zRe8vldhkGd8snQRbSvRnJ8Rfr/40cx3URugZYq9eyb7AeNZD0yNjVBRKd8oHzFcnX5RNa4uHYYnSJfRgc04tim4BsK+9i4qv8pGPn5k
 NSDIVqXz
 vjKuWkEkSY6BP8DBrXkt2LR5LgRP0DuDV3sBaAMOxiDIaGJdD4l7hyQCSy72KnY/QrTZh89t7v23PINMu0AZQmkmCYDYxmJGN3MPsgsb6EYaF9HOGDtnEMV5IGgX6wjdFX8Dq6eE29jbKXK+5TgchzeOSeTEoCmZGbFYlGt0BRUKDaAwpEsmeTF9CGmBnnClSIUXdaehWx3+pti65beW51RndSCVT+izOufTxPZ9Rbernm7Q=
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

Add a throttling mechanism that makes tasks calling
mark_inode_reclaim_deferred() wait on exit to userspace if the number of
deferred inodes to reclaim for a superblock grows over limit. We measure
average time it takes to reclaim inode on deferred list for a superblock
and block tasks proportionally to that.

The mechanism to block tasks on exit to userspace is a bit simplistic
but I don't expect more than one inode to be deferred per syscall and I
expect throttling to be rare so it should be fine. If we wanted
something more advanced, we could store the delay in task_struct and
just wait for it when returning to userspace similarly as blkcg
throttling does it but so far I consider the space in task_struct a
waste for this purpose.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c                       | 128 ++++++++++++++++++++++++++++---
 include/linux/fs/super_types.h   |   2 +
 include/trace/events/writeback.h |  51 ++++++++++++
 3 files changed, 170 insertions(+), 11 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 0b6335df9b48..2d2fc3ce518c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -23,6 +23,7 @@
 #include <linux/rw_hint.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <linux/task_work.h>
 #include <trace/events/writeback.h>
 #define CREATE_TRACE_POINTS
 #include <trace/events/timestamp.h>
@@ -1119,23 +1120,53 @@ static int get_inode_reclaim_batch(int *id, struct list_head *list)
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
@@ -1143,17 +1174,20 @@ static void inode_reclaim_deferred(struct work_struct *work)
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
 
@@ -1189,6 +1223,70 @@ static void __init deferred_reclaim_init(void)
 	}
 }
 
+struct deferred_reclaim_delay {
+	struct callback_head task_work;
+	u64 delay;
+};
+
+static void deferred_delay_work(struct callback_head *work)
+{
+	struct deferred_reclaim_delay *dd =
+		container_of(work, struct deferred_reclaim_delay, task_work);
+
+	schedule_timeout_killable(nsecs_to_jiffies(dd->delay));
+}
+
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
+		struct deferred_reclaim_delay *dd;
+
+		if (!delay)
+			return;
+
+		dd = kmalloc_obj(*dd, GFP_NOFS | __GFP_NORETRY);
+		/*
+		 * If the allocation failed, don't bother. Throttling is
+		 * approximate anyway and next time we'll throttle more.
+		 */
+		if (!dd)
+			return;
+
+		/*
+		 * Scale the delay based on how much we exceed the limit. Wait
+		 * at most 4x as long as estimated time to reclaim the inode.
+		 */
+		len = min(len, 5 * INODE_DEFERRED_RECLAIM_LIMIT);
+		delay = div_u64(delay * (len - INODE_DEFERRED_RECLAIM_LIMIT),
+				INODE_DEFERRED_RECLAIM_LIMIT);
+		trace_mark_inode_reclaim_deferred_throttle(inode, len, delay);
+
+		dd->delay = delay;
+		init_task_work(&dd->task_work, deferred_delay_work);
+		task_work_add(current, &dd->task_work, TWA_RESUME);
+	}
+}
+
 /*
  * Mark inode for deferred reclaim. When slab reclaim path will be freeing the
  * inode, it will not call evict() directly but rather offload it to a worker
@@ -1205,12 +1303,20 @@ static void __init deferred_reclaim_init(void)
  */
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


