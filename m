Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6AF5606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 11:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=xzBzklWi;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ABUp6gT1;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=xzBzklWi;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ABUp6gT1
Received: by kanga.kvack.org (Postfix)
	id F2D366B068D; Tue, 24 Nov 2026 06:59:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8F5E6B0692; Tue, 24 Nov 2026 06:59:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B828C6B0691; Tue, 24 Nov 2026 06:59:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 828566B068A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:59:11 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 00B66160B07
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:59:10 +0000 (UTC)
X-FDA: 85469866860.05.3D9F52C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id C14071A0005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:59:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xzBzklWi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ABUp6gT1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xzBzklWi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ABUp6gT1;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795521549;
	b=6mtqaVv5ooEEq4rkGHaWUABopzAeMmNbyRkdYgSGGABM9uzBOChGU1V2xMg23hqA5QvHbH
	W1WbwPZiENx012sb51v+Dgm8KEb+41NlbXolr3FtpR2LJveuU0HaBTFEpekjMHE51Qs5ih
	9hSSa/unJAgQ0ABMC9f5XlB+zGkWCt8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795521549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vM/IZQhk0I+YZrMUMyvaUdkXXS5Qyxy+JD9srcvw/l8=;
	b=aTVAXMGwIwJ9J8cgbDjC0l8hkH+mU0O2ydsz0iX1FUk9GqPMnxk6U2ukTD1hMc75Lj4L67
	Vq/cR5+t2pIeq7Fzt+xqafQbIKy2IdRfErGIMkmg/cU59l0iaLzt+FU8FgoPntdiIAJSIB
	PSGteb50y83/pQSVvZOUIeXX55cTG6s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xzBzklWi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ABUp6gT1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xzBzklWi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ABUp6gT1;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A8DDD22255;
	Tue, 24 Nov 2026 11:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795521547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vM/IZQhk0I+YZrMUMyvaUdkXXS5Qyxy+JD9srcvw/l8=;
	b=xzBzklWikUFrHyyxarAbaVaM1ixid7UGQee9dZIpfOquCWAIS4DqT7m0/n8844DPu8/C7X
	3AD0LbSCJpR8M/VlEOv33T7qHI0618jVbcDZePzpo6g/5ZK4zbDLA6i4WyGnYWd/eQuiho
	7vBSDEBd1fA1rz4wMDgwoju/jApKCXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795521547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vM/IZQhk0I+YZrMUMyvaUdkXXS5Qyxy+JD9srcvw/l8=;
	b=ABUp6gT1zeRrZtdyU9+dA5xaAKygtGXDYpchyhcTCh/Zx9JH2L+dY3XOMpL1+MxYheDYdh
	um4IZrPml26WbGBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795521547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vM/IZQhk0I+YZrMUMyvaUdkXXS5Qyxy+JD9srcvw/l8=;
	b=xzBzklWikUFrHyyxarAbaVaM1ixid7UGQee9dZIpfOquCWAIS4DqT7m0/n8844DPu8/C7X
	3AD0LbSCJpR8M/VlEOv33T7qHI0618jVbcDZePzpo6g/5ZK4zbDLA6i4WyGnYWd/eQuiho
	7vBSDEBd1fA1rz4wMDgwoju/jApKCXU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795521547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vM/IZQhk0I+YZrMUMyvaUdkXXS5Qyxy+JD9srcvw/l8=;
	b=ABUp6gT1zeRrZtdyU9+dA5xaAKygtGXDYpchyhcTCh/Zx9JH2L+dY3XOMpL1+MxYheDYdh
	um4IZrPml26WbGBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3B75B1373A;
	Tue, 24 Nov 2026 11:59:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id s/CNBQt8BWtQZAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Nov 2026 11:59:07 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id EB5B127851; Tue, 24 Nov 2026 12:59:01 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	<linux-mm@kvack.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 6/8] fs: Add throttling to deferred inode reclaim
Date: Tue, 24 Nov 2026 12:58:50 +0100
Message-ID: <20261124115850.3512-14-jack@suse.cz>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261124113450.3451-1-jack@suse.cz>
References: <20261124113450.3451-1-jack@suse.cz>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9860; i=jack@suse.cz; h=from:subject; bh=uiFPVSGt+pZY7CCJrKKcK5xITFvp6UojKi3Mz5LMqiw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBrBXv+puIjXvsKOncuDhdUgFlbeatGwb52fgTQB oUVsYgdrGmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCawV7/gAKCRCcnaoHP2RA 2drfCACkCSQMSib1xWK5pawEXr7y/Z0Q1YTLBIOwBHI6MMC8/fhKHgHcDDyqkbZIjgEzgMEZVCv xeWKxfpEa5BNZ/OVRtWDHAnkYtOqCvjcoQ++OHN5Jgv+m7QpuhPGBABwUCBT2qkiNu6W1aZoMmk n9qFR/Tnv5zdSLBFR+Q6QGDx6JOWzumD0qF2IrWOtn/UJ5WUrQ53KPm0UTgsrl6+N0p4LmiQvAH /F5McKZcf/CWm/vcMdmC+gJqYGSbnfXX78+rr/r46TPPLzmLWqsz2j0RX+T7hUbk2+pi5Aiando H6VztlwQpL7h2V8fwrZvd0qSbwvTMM97sLgDVrErO1+GQAjx
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -11.80
X-Spam-Level: 
X-Rspamd-Queue-Id: C14071A0005
X-Stat-Signature: 4muidf1ucmmrdnqjhi7r5atisztu4jho
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795521548-583170
X-HE-Meta: U2FsdGVkX19x8jjeZQlKYW/fKGYp3Vt/5WpfQ3e0i3p+wSWe+s5P8PiI7tm+tXaK0pen/hPEQverZwJv3xLPsiJ73Yb5GsBcqBuF4vYKo4Z9cpvUrTkCVw0prFRPPg8ZVT7nOQxScz8BVlxA5/AUVUp++BEZCXa9b//U8QPkrsYEwHCnImLhHOuleXrRTJJHyybnw7cikZ4xkLdSwxUIy+FztsbUnYI1TM6TI4rSWiW4ZugpauoYKt/510MDxgRYkL4KVLV5kL/RFAd5lNz+ih6vPLkccH8bamsmHxQ5NL7I0n4p7meG2+WpB59BCjp057mAlaXnzgJ5Goko0DHywTi1VYMjNPLvReoOunBpFM7bFseJIeMmKvoHbpFV7uVVHoI1XUkXnHkgWAHC1qdRP0DUhx8ji0pMQTR4mCSE3mv4nfMwzuTTFVDbhmVZ6OiMvEeSWSAKcUzx7EaHGq2oPS8aOEESLLwf4P7jF9gMl7IjEz6KZMWBSvhQwz9fu72DLVhIVL44fYZOHarCydrHSh+WYz7ucpfFyUceTAWRK2/ooHXntc1Kk1yuTwBxw3fIQyoaecKPkGVttneVn9KKsPkVT1ntLsMHd64C93llwJcn7eLGzupE3b1DgUL/orUB/kMIH3F+eSM+yTaaOd98C3AymZtf2B4HOuyar8J5XyWp7C6caAn17kUcVFErQoWtXlT5sG/uyhVX5Nr3Izr4dTgbRP/DEAfdK1HEXDlysea37nAVdyQFgbdYHZwDsgKlWx7EGvFYu12pGB5ApuG8dTKMST42RlFfe+yk8qG4BI65nA01N6evbEEgHtiHG5Y9sl3ZEmD9zPzeFkEOX8+8yMsvKN8RGNgTaTXsi4PW1AdIqjZn+Jt3Zh/dNUASIYiCEDsBQ/tcWVEcahqmbB2LgS3W8BBaPatW1xX1zUn433zs/TUpEJzkDjqeFE/uurbEwCi49StRZW3iwK/3RYd
 osiDyf4R
 ZeIXLg1ai1Dw1wCUDVfkbWyoJMFIzkJ8g79rFhy6yvIwOMRh/eUEm5wC1N1AjCR9P0uE5O4PCmyE+824xKFwyQVX+H+4fcxmrTneyXW5/WzOZThX7r4r0275Kh4bTy/cE0X5vTI/AluBFzQVb6CUeqtS/vADaiNuuYo5zw1VZASsbPyRiRNShoYppoRYQLIJsivJdJGjCwYQ89QsYPhUPPBA2I6A2dKqgtzv8xbt8JF6lfkZouR8wwyvTFhBxqcssrnFYg+AuMUuV3m638SoMv6JKdHBi4PUp1RMIQDfi3exWGN6dcL43pnhsXEyfhNBoemtH8Sgmv2PTKZH5IzIM+aYBEpr6amOjxYQR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
 fs/inode.c                       | 150 ++++++++++++++++++++++++++++---
 include/linux/fs/super_types.h   |   2 +
 include/trace/events/writeback.h |  51 +++++++++++
 3 files changed, 189 insertions(+), 14 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 760c730f4a9f..b6fa2965f4e8 100644
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
@@ -1142,23 +1143,55 @@ static int get_inode_reclaim_batch(int *id, struct list_head *list)
 	return count;
 }
 
+static void inode_reclaim_update_stat(struct super_block *sb, unsigned int n,
+				      u64 start)
+{
+	u64 delay;
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
+}
+
+static void sb_deferred_reclaim_put(struct super_block *sb, int n)
+{
+	/*
+	 * The elevated s_deferred_reclaim_count keeps sb alive until we drop
+	 * it. Use RCU to make sure sb isn't freed before the wakeup.
+	 */
+	rcu_read_lock();
+	if (!atomic_sub_return(n, &sb->s_deferred_reclaim_count))
+		wake_up_var(&sb->s_deferred_reclaim_count);
+	rcu_read_unlock();
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
@@ -1166,20 +1199,27 @@ static void inode_reclaim_deferred(struct work_struct *work)
 			 */
 			inode = list_first_entry(&inode_batch, struct inode,
 						 i_lru);
+			if (inode->i_sb != sb) {
+				if (sb) {
+					inode_reclaim_update_stat(sb, count,
+								  start);
+					sb_deferred_reclaim_put(sb, count);
+				}
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
-			 * until we drop it. Use RCU to keep sb alive until
-			 * the wakeup is done.
-			 */
-			rcu_read_lock();
-			if (atomic_dec_and_test(&sb->s_deferred_reclaim_count))
-				wake_up_var(&sb->s_deferred_reclaim_count);
-			rcu_read_unlock();
 			cond_resched();
 		}
+
+		if (sb) {
+			inode_reclaim_update_stat(sb, count, start);
+			sb_deferred_reclaim_put(sb, count);
+		}
 	}
 }
 
@@ -1215,6 +1255,80 @@ static void __init deferred_reclaim_init(void)
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
+	kfree(dd);
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
+	 * Don't throttle kthreads. They are doing work for somebody else
+ 	 * anyway so throttling is counterproductive.
+	 */
+	if (current->flags & PF_KTHREAD)
+		return;
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
+		/* This shouldn't fail. If it does, just cleanly bail. */
+		if (task_work_add(current, &dd->task_work, TWA_RESUME) < 0)
+			kfree(dd);
+	}
+}
+
 /*
  * Mark inode for deferred reclaim. When slab reclaim path will be freeing the
  * inode, it will not call evict() directly but rather offload it to a worker
@@ -1231,12 +1345,20 @@ static void __init deferred_reclaim_init(void)
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
index fc8f7f2261e2..fe952ef02b96 100644
--- a/include/linux/fs/super_types.h
+++ b/include/linux/fs/super_types.h
@@ -241,6 +241,8 @@ struct super_block {
 
 	/* Number of inodes queued for deferred reclaim */
 	atomic_t				s_deferred_reclaim_count;
+	/* Average time to reclaim one deferred inode */
+	u64					s_deferred_reclaim_delay;
 
 	/* Number of inodes with nlink == 0 but still referenced */
 	atomic_long_t				s_remove_count;
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index c2a5b492a71a..d371d1112843 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -885,6 +885,57 @@ DEFINE_EVENT(writeback_inode_template, sb_clear_inode_writeback,
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
2.53.0


