Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69CD6606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 11:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=UrAvxO0T;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OwvUBuBk;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=UrAvxO0T;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OwvUBuBk
Received: by kanga.kvack.org (Postfix)
	id 1C8A76B068C; Tue, 24 Nov 2026 06:59:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149536B0695; Tue, 24 Nov 2026 06:59:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94356B0690; Tue, 24 Nov 2026 06:59:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8964F6B068B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:59:11 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21C1A120B15
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:59:11 +0000 (UTC)
X-FDA: 85469866902.12.660E06C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id EDAF4C0009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:59:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UrAvxO0T;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OwvUBuBk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UrAvxO0T;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OwvUBuBk;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795521549;
	b=ie/lVnEY2/x/E+3mhc4emINzHTpiRXaA9ftJUfIHlQjNWAyY7wtOqb6iOzeqaOIZUeZX7P
	2ep6F0NFaQJFGnUgLFCaoLepSqHT0PyXEDGJnKlvGaFXTrvUcv/D7ouff9JLZqgOvJ1ZCf
	l/kJKg7rAk4Pe6eibeZWw5h2uEo9SZY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795521549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VqHNRpMmBb6Bj8xpyW6r4He0IHjzmwjAY09SSNXVEvQ=;
	b=zFZQV/EbND+4hX3RpbRf7ZYR3w5FzpqZzCLbsOreOGVsK60kE9mqwlW0P2dv8PryS/yolZ
	SNJa2EhW5VrvBw9eZobaO9zNKw0Mf6s06JMIfp/TSY6cLTmazi2wkIC4PTTiTc7W3IMiLu
	a/mrNwF+VCkcKsdeUPD5o697/GksJT4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UrAvxO0T;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OwvUBuBk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UrAvxO0T;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OwvUBuBk;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D0F141F452;
	Tue, 24 Nov 2026 11:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795521547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VqHNRpMmBb6Bj8xpyW6r4He0IHjzmwjAY09SSNXVEvQ=;
	b=UrAvxO0TSU9Ubl5Z0wZOtRGxFWIYb90mtsx3vRFmk8nHG7qPU9+Z2mQ6hpcDaj8KLmOKX5
	FQcPUWJICWO5YKbqpwJi1N1ReyLfUA/MDc3WK1T/PwuVggxsNqpOKx/pz9+cw0lJ2Ws51M
	IQDBgMczIbL0Rl0rEQgubfKmN3cqq+A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795521547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VqHNRpMmBb6Bj8xpyW6r4He0IHjzmwjAY09SSNXVEvQ=;
	b=OwvUBuBkSY4H6zCoqrs100LydVmVtJONwgB0mZXXwK+Lh5lw+VTRd0a4AB2vMlgGOg/mo0
	0ffDgmC4A+/6tXDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795521547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VqHNRpMmBb6Bj8xpyW6r4He0IHjzmwjAY09SSNXVEvQ=;
	b=UrAvxO0TSU9Ubl5Z0wZOtRGxFWIYb90mtsx3vRFmk8nHG7qPU9+Z2mQ6hpcDaj8KLmOKX5
	FQcPUWJICWO5YKbqpwJi1N1ReyLfUA/MDc3WK1T/PwuVggxsNqpOKx/pz9+cw0lJ2Ws51M
	IQDBgMczIbL0Rl0rEQgubfKmN3cqq+A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795521547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VqHNRpMmBb6Bj8xpyW6r4He0IHjzmwjAY09SSNXVEvQ=;
	b=OwvUBuBkSY4H6zCoqrs100LydVmVtJONwgB0mZXXwK+Lh5lw+VTRd0a4AB2vMlgGOg/mo0
	0ffDgmC4A+/6tXDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 545D91376B;
	Tue, 24 Nov 2026 11:59:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id v4Q9Dgt8BWtWZAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Nov 2026 11:59:07 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 025D227855; Tue, 24 Nov 2026 12:59:02 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	<linux-mm@kvack.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 8/8] ext4: Defer inode reclaim if it has preallocations
Date: Tue, 24 Nov 2026 12:58:52 +0100
Message-ID: <20261124115850.3512-16-jack@suse.cz>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261124113450.3451-1-jack@suse.cz>
References: <20261124113450.3451-1-jack@suse.cz>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2241; i=jack@suse.cz; h=from:subject; bh=5d0bhwSlVwQ2moUUqSxh3fmdkgNHJa3u6plV1bhKRNk=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBrBXwAxLIOrynhOetNAORZ//kv7Z/0JZmP5nrti l805u8MRcKJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCawV8AAAKCRCcnaoHP2RA 2fkwCADuli0r0081nrS/BJ9HGHO6S2HEn0jB8ZM55mc3KOaZ0IoUsUsJzq+Lru5sjQO/rOLSTCI W1cZ9aULpPoSsGelPZ7WXvMmwfj9Kz5mjgCu0AAfZscds6F5ORqvhj2chvOTU3k+hbqG9Rje1eF +4J2m0UoNSEnZk6nR2MswuUlOabi/Iyx/UBaIkQMc1oJB58NeN49oJ12MvpiCMq7zPxbNikrj4k NasownurWyT9KweKiUhshImSHVF5pddOuCmKy/lSBJsbni6R7imN5lVsVhOf0KOy3v+/3s2NBPl oKMHoxZMJTxj0+7O9ZKTmZO4yug7JcetrZXPYuUx2IkDKTLy
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ahbs5f8de9q9whgq4amtibrynz1b7fze
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EDAF4C0009
X-Rspam-User:
X-HE-Tag: 1795521548-922576
X-HE-Meta: U2FsdGVkX1+I1rXDtD0U4I+NXiz6961zMUYnUIsrH3W1DcsLEFOH34VkYcATEI8Z0z6jg3JOhgHf8wtqaH54QRsxbxo05MyQPWwTp09tpIzDydn5VsBlo0AQUXkEl7GJCz+1OeXIxYFXtlPiGlVbGb5VisTuzrlsK2/AfynEsfhm+CK/JLd6NJ8EiTvqqTLeTf26Z9KCMgeiPcjUI79JOpKYtna6F+pcJI3BlWLVhaS4FXRGdJNnnNMQvxIIiCW7UnbiZ0QsLfuTa1C4NOlHMmmtVX2Cc3hmH77i15tLsfVamUfedz9iCpvkbKO7m/ziW9ZsZxAaevmldOcyFPq270APsM73DdfsOvzxypOIWmOEosIkR8fRVdufyzDL3BJxjj/Uk+hl6XBz6DtnvNFxjycOxHKOAzPqDSiAgrilistbMLXYjVLfGLameXaoZc6cCMJnINz4NyuPYK+WrQBFY3vB1nE3kT5xNaiFgf3/aId0ljfPoRYlUT60n1dk2tvPXWURNz86KMFGtb/HT8xiqvCue9WQPf8rLdjH4elGgYw6bbHBMzSL1CDrW+81ZE5UxLLNhDzjQe6sxPlmS/mK9092JTHV5z3o326rdOQZMX8VnHUQjMr6nIjlFrbpxZF8Lf7/l0kpjuZPFEgI2YI80denMAWNrHQpjIzdeWoVjynt/Ag/qCz2odRk3QrRQd1jHRUqjmbHMUYcKVpBx1djqnIyrIV3W24l845f3Mno1hPvOxotJVvKIkImT3AgwjWFZ4cg4MIY+8yEZspiUv5yTGJ5Y6BKbNYYB1x8yTUNyvk4AE3Tayf7CY2YcAKcb3skaUZ7KuJnrTDB2OzKfSY/Z116f6V+6ijAHe0x2d0OEmLCWuFfXZhrqb0YvdReAfWS0mcT1Sl6cKS8wgNc2zU4/W7URWQVzXSYNVs4iiekIQ/v8sUAzUVpQub6jwPoeAumzQQYy8HD3gNyiynrNP3
 /Ufol6ku
 HortjVPk/6wa4BaVDKcC//95Hw3LmLH2u3YxfzvrjfmAXqS/7c/guZ4UxUkCuH8NPyHlVZJzfsdsqXWeMKfL5j/EvyoaI/JrjLxu7M845vLigKriAP6f/OaDrJVz6AGfMVwd4Dc9tJWGDnp1hXViiOB3F6DgYLa1dtt/mRZUeo+QTdHVHlFmjtp8aDkbLG+RRyGzuW6WYSd9zuLRlQCvaQBqodXNjv7b8hIYB4LqRUtXBnPj6ZwaBZc0LyHRwMaDRczWQfo7IL+TR1AFKfDuYiBf18ifSbHvrahylwZSVDJGW2bKdxbTtkSobBv46mN5vOe0BB1S5Xv/eQFdU7QAvUp6LjLqcjW8cl7Ct
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When we have to free preallocations during inode eviction, we need to
load block bitmaps and run transaction to modify them. This takes time
and also requires GFP_NOFAIL allocations. Mark inodes with preallocated
blocks as needing offloading of inode reclaim to a workqueue so that we
don't block reclaim for long and potentially deadlock MM subsystem.

We do the marking in ext4_mb_regular_allocator() to reliably catch all
the cases adding preallocated blocks to the inode and additionally when
adding delay allocated blocks (which will very likely result in
preallocated blocks in the future) so that deferred reclaim throttling
has a chance of throttling tasks generating the work.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c   | 9 ++++++++-
 fs/ext4/mballoc.c | 7 +++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e3129353d4ed..efc2f8ebe7ba 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2113,8 +2113,15 @@ static int ext4_da_map_blocks(struct inode *inode, struct ext4_map_blocks *map)
 
 	map->m_flags |= EXT4_MAP_DELAYED | EXT4_MAP_NEW;
 	retval = ext4_insert_delayed_blocks(inode, map->m_lblk, map->m_len);
-	if (!retval)
+	if (!retval) {
 		map->m_seq = READ_ONCE(EXT4_I(inode)->i_es_seq);
+		/*
+		 * Inode will likely have preallocations which are hard to
+		 * reclaim. Mark is for deferred reclaim early so that deferred
+		 * reclaim throttling hits the task causing the work.
+		 */
+		mark_inode_reclaim_deferred(inode);
+	}
 	up_write(&EXT4_I(inode)->i_data_sem);
 
 	return retval;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a15285224cdf..d138c4b697b3 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3113,6 +3113,13 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 	if (ac->ac_prefetch_nr)
 		ext4_mb_prefetch_fini(sb, ac->ac_prefetch_grp, ac->ac_prefetch_nr);
 
+	/*
+	 * Freeing preallocations requires loading bitmaps and running
+	 * transactions. Defer inode reclaim to a workqueue.
+	 */
+	if (!RB_EMPTY_ROOT(&EXT4_I(ac->ac_inode)->i_prealloc_node))
+		mark_inode_reclaim_deferred(ac->ac_inode);
+
 	return err;
 }
 
-- 
2.53.0


