Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F626EC1423
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:35:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F208D6B0102; Tue,  3 Mar 2026 05:35:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E99A96B0100; Tue,  3 Mar 2026 05:35:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE8006B0100; Tue,  3 Mar 2026 05:35:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A3A706B0101
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:35:09 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B2AB1603FA
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:09 +0000 (UTC)
X-FDA: 84504394338.22.E26C772
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3204180004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZfpWi8mDNyBOMa2tfuFTBqwvX2eA5Kp1+U3DtplQ7SI=;
	b=Vg8roUc1+saY7VLHOQKS/u85h06IrMQIuRDwciWGY/uv8iweXjpprQnWOQIDlyvtPkn5Du
	x6OtSuvdjxhsqTArOKJJnu0x7pv1YbioE8kxYkprwujLq20KYw1G99Y3sG0zoEg+insHqF
	8k8Hx2/uzPVpePoAtIvNGgC4QiR69WE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534107; a=rsa-sha256;
	cv=none;
	b=v7jaco++sSIh8Ga1YZTP0oUHLPok3RH+wCVcHCfuGDzk3u0ap8G90zztLbbQPe7R+IQOgf
	w3773wevKSp3CzRROGRvCn/e65BA5/kTJEDOBej5X9NTYcHuEKj8CGjAFTfQGt6cqXRm50
	6zqLe0YL2+Cy4bW3xHIgUffVYVR4fQw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 121B75BE1D;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 00EB03EA71;
	Tue,  3 Mar 2026 10:34:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id v5tsO0S5pmlxFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 98C65A0B3F; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	<linux-ext4@vger.kernel.org>,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-aio@kvack.org,
	Benjamin LaHaise <bcrl@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 10/32] fs: Stop using i_private_data for metadata bh tracking
Date: Tue,  3 Mar 2026 11:33:59 +0100
Message-ID: <20260303103406.4355-42-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1862; i=jack@suse.cz; h=from:subject; bh=21rbptBohvHLbIzoeM8IfhTkwdubfon9k5dpdTlpgfs=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkmRXfvEFOavnw88KSkCELSYzUGb6FJxDza0 lFuc/BYWXOJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5JgAKCRCcnaoHP2RA 2eF9B/sEW3OFX69Cefii5uJoJbX2MlFQ9v7XXSlUg4DiHPmiJ4YNVL9wzueyr+M9Xc3mCrZ04sp 3R4b5iAESEUkWT3/ReBfvXEhfXQQ4ynvWT3qqkz5cZI64xr7HLGHyS+QRHYxNPUeRL9zlgI2Doo Q/a4g1ACdCL4MzFZgGKeja2KlZ6EMnNYaliS8/2SKb6EjoaucHSGksgqpe2UH0SKJF+jp3QD+yE UfelQAhsh8WS8vs9O+tMNdFm3C39yJ2Dm0cbDl267sccawqPmR3MuohLONNUoojt/zTycdJ/f6i yj+urmXK9n4+ukLJcSUa+QuBKa4TqFGpUO3VG0tuNlO5maNm
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3204180004
X-Stat-Signature: 6iifg5ayzjhi887o8x8pko1j11zz7xqq
X-Rspam-User: 
X-HE-Tag: 1772534106-345309
X-HE-Meta: U2FsdGVkX1+Yn211/Zw6KGVAvfM1oA4UHCeEXmEy0WCmCsEWRWv1UgNgR8e1vE+eEqye8H3UoFoX0zPz/gUtzDbIJC/P1RPAr4i5yA7i5bYqa1qL4ORvwNw8fPVE+pu0HJRFI8zVaW1jGkKbgE4enjGTPA4BG6o2ec9/t4H/C8q8HOQzMEZkNpH27cVQMxYqROnOUxEoVKv8wjapDq7BuvzIkVChUZESMX9PZCCf5Fl/Uf8i56f6Q4czd7wcLqtWdUJ0CJ1+HU0JzDltORh0ukx/VTaUEbtWes0bEHxXPXoeccJ2C/1hLjSWqkMJ232gm0wqgBx5N/NUbTZh9R7Y3EoglXyV+4mnkzW4RLUnAmDb0tciOUsuzmnQPpvqEWQshTwQX0qH8Ca1sdPc08ZwB0mA6vND+DgQfGc1hvvb5gBxU9Vp1UptcaI0gJX3a3TGJd1LQT7FkdW4Lbosho9ce0hIPBo4NpzTm1nB++eC+8KgSwKGwDi9Eflt1HSdMa+Qz10IutUEtn4CUn4oLaQgi8dMWXcEvzgfW+u06rfdsCzHmZ8hDJkVJnIaC+vyE7/Xqiujcry1PHdV9PHc0SNm3sYffYtnv6lIuMHo3Fsiz7WLfgWDXtdpbw92jK2o+WgZYJFJfzo3rid04n0YQJ0OHGWsAL4KG5ohRhOhKDpv0D1fXYd6RyrW9Fdy7vnIhzRkeNygQdhBZSf0TZ1BeFbI70GkJmPmNp5ThcK+/MlkBmA2HZdo2jsj0I9IU/m6ujqqy10oeijqDBHeCndV/VcTjVW3KVmNa5jZi2PP9nXXDNG823fm/SkDx0uPpj6jRWPUCRToX+owMpR87D8TmWrxCkjafKZhNWjFDHIIV/V+ateIKnd989yVgqbRT5ijVFaPesAXtQ9R39pwLAwMgVB6pL0zyNedDBY/oM2Eg2DnUy+iezOLDWGaIIKsgE8J5fVifkjjxr+WnhHnC+fXb5N
 vgi6szI2
 DBSAuHIi6x7/hNi001duLsDzSSqSytGUQtS/BByQu/VrjwtD0iqvQUDdfxg1Q3sOkQqMcpTSitOjI9Ilj2WylUgyAVgTJ4DxS+JmRo/7lheUxpLTgd2P3+4ryZG76DJ9kqveoEynrIaf6xi5Xta4ocVqD68fXkoi+sgqxqnrooh54RDBPFvrsapX2++q+89/ox/Cx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All filesystem using generic metadata bh tracking are using bdev mapping
as a backing for these bhs. Stop using i_private_data for it and get to
bdev mapping directly.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index bd48644e1bf8..c85ccfb1a4ec 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -574,9 +574,10 @@ static int osync_buffers_list(spinlock_t *lock, struct list_head *list)
  */
 int sync_mapping_buffers(struct address_space *mapping)
 {
-	struct address_space *buffer_mapping = mapping->i_private_data;
+	struct address_space *buffer_mapping =
+				mapping->host->i_sb->s_bdev->bd_mapping;
 
-	if (buffer_mapping == NULL || list_empty(&mapping->i_private_list))
+	if (list_empty(&mapping->i_private_list))
 		return 0;
 
 	return fsync_buffers_list(&buffer_mapping->i_private_lock,
@@ -679,11 +680,6 @@ void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode)
 	struct address_space *buffer_mapping = bh->b_folio->mapping;
 
 	mark_buffer_dirty(bh);
-	if (!mapping->i_private_data) {
-		mapping->i_private_data = buffer_mapping;
-	} else {
-		BUG_ON(mapping->i_private_data != buffer_mapping);
-	}
 	if (!bh->b_assoc_map) {
 		spin_lock(&buffer_mapping->i_private_lock);
 		list_move_tail(&bh->b_assoc_buffers,
@@ -868,7 +864,8 @@ void invalidate_inode_buffers(struct inode *inode)
 	if (inode_has_buffers(inode)) {
 		struct address_space *mapping = &inode->i_data;
 		struct list_head *list = &mapping->i_private_list;
-		struct address_space *buffer_mapping = mapping->i_private_data;
+		struct address_space *buffer_mapping =
+				mapping->host->i_sb->s_bdev->bd_mapping;
 
 		spin_lock(&buffer_mapping->i_private_lock);
 		while (!list_empty(list))
-- 
2.51.0


