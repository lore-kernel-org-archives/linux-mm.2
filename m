Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43B29EC1427
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:35:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2C676B0115; Tue,  3 Mar 2026 05:35:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCAF46B0118; Tue,  3 Mar 2026 05:35:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E4EE6B0117; Tue,  3 Mar 2026 05:35:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 816316B0115
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:35:35 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4CD3D140430
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:35 +0000 (UTC)
X-FDA: 84504395430.08.F7FEBD8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 11EF74000D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NRXGmGWpcPGnbiOJ2fVks/sdaoBpLk4SyZLEare7vMU=;
	b=483sdXIKIfgDKsE/dkHyK+sgUyFZ+FLZvPabz7kBL/3qHYjdXeScf7oq/t1WVBdWibaFXz
	fU0TmSlAEQAbIW7jke06kQNLkXldM9SpUTdBco1jAd6YxBTxp5RQIT0U7e6V+B5aqz5m/l
	zL3IF7NPGZFVNbPZcthOc4pVL7JKyDg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534133; a=rsa-sha256;
	cv=none;
	b=8NAilKR5JWj74IpquHlcerWNatZI4/PqSb39RDUvp2pkS8M95/gL8M157qD1uZgcAy4OaH
	8dcK5eqOrd5yZGNbRFGoDilKpZkQZeqUIaapSBqtax0XsB/+y0ew6v5NO+GbBoA+sv6zgx
	KrkMQ+1jflpIXxGLTbZmkCZbX6MnAmM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 49C2A5BE26;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3E0493EA6C;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ixYeD0W5pmmLFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 068E6A0B73; Tue,  3 Mar 2026 11:34:41 +0100 (CET)
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
Subject: [PATCH 22/32] fs: Switch inode_has_buffers() to take mapping_metadata_bhs
Date: Tue,  3 Mar 2026 11:34:11 +0100
Message-ID: <20260303103406.4355-54-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3341; i=jack@suse.cz; h=from:subject; bh=h0e6MIg5l952kKWgsDkEqfN2Mt10ryaKvGQbfI027K0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkwiZ1a8GXqSyp+bg1UghDh217roqsu+Pqts 3l7xohlZBqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5MAAKCRCcnaoHP2RA 2VsCCACymLlBzpHgLUzLMLNGiTzCzJYKtadD8BzeD3oIfJpU55WORZv8s9WWKnJx0DuugeHHYaJ /dABsPjGb7ZAJqvnvJD7vTxnH4Ripsn5ClgKEzseSezvzeoYc9f4NK1wcxE8xOaqC3p+GixOn2w 3IX5XdJqLGfPwlrOlmS2qYNCfgFGg7GWJqyaQGY5/dpiO0ypa5pUcBUryqcmYIZNBl9t6MceMcu wEHO808n6FSVwuQHghWYooFwiF8jYx6uFn2AFYTGpVofVdn+MVLqXE0jQoU+bZRVsOP8rAexQrR f+VIdfVyuHdnurySWXk+Kfo33m+PVmSNN6koXlwWEdP3RwC1
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 11EF74000D
X-Stat-Signature: fikf3xjksp3aud9iej77yd4kign5iw7z
X-Rspam-User: 
X-HE-Tag: 1772534132-663575
X-HE-Meta: U2FsdGVkX1++Jqi38IvhmZeCQLqdOXuYyHFFlLdjd3nCGA7V4/ceart5xjf6oaklHoiydeVz0WX5dGt7DfMSvfJkEt6xB45csvDQsel1vHv9Q+PXwXPruxQDdp5/kwAxjxewr9efieUUplIB/IDlbXwtyKxvdllCVXvDhXJ4cQ/YYbzAb+aCgMWDo1GqPEompwnkSjpXhrDD80DrjzwMP23qmbLvtSTSoZOiBP+2gjGlLHspIMn+nea5w5Qq3f3IRKVcHYteAXq7wx7AAOSSDUOzrmTfOcjavsVZSrhKIRTRY9bnOL0LtGw0XEZB2z0Ii9l/6hZhAN43++d2YcodzJMyXpkyWbtLwAXSB5e/bDYut2hEGqdw/mF9w3ma0qxUmsVoi6MMbBDeXRWtMtOihRirrOICVgdfudRIADZ8iDgGan1p/7d45h4XrB/Mso+vMoGH9IZws0VQF16gp5yhdqSCMueI5rCfyexx9YyCAqbDNpma+HTDiw6HERrd9rtA3wuVJsBYfK9x72OrHoPnkd2luJJjNzX/GYmZMlF2T/B0FSDH8+HZ4imDGsB6Y28AbQGgpMgB8jgcrCZfVx98uXJBZ71euknOXRZhuxMWQZCyS4lmvA36qXU2CCEDZB7D9wOB160SjlDSlwqtW38qNyStFvGIK+wSTBH0CrSeQSJBB++/ttfL0WX8MmFlh1KQvTo38Gjmse32tpqaBt5zk+7wQHj+Igvcdy1X3IMYHPC2YX3b9Z904va5aJ2OB+8MVgJAifGzm1Ap5MIv/bBqP5GAHYdSfysH5cJKLZhDabJ+MBH+STu5VSGRqjR1qeWDt644ptVGVpwkIzttdW0ThBokrp8IPlavj5j6S8tW3lTaRflM0SF5Yfj8v0LO+SzHzlEtW2EmBniAkYzPn777oFpjzTfujK9vPYaaQLOzZr9t4v2jhqiPLM/8igyekuTpIivcqMyl82Yjma1Y5vs
 AG1P0PUb
 Y7PZuyLHegT+Sm1TFx3JRO3RscjbgOhtqcNJL3TF7VxKenlJfAZVAHlazZJcS3jtPXpSGF+SlMbsVPKUJtr9FklPGoTJvwV4pzIbKvx9sMbXwJxZWyk1BwM9eWdzXts37pC01HJrafqeA+McRhdiy+cjXbWbEkTJDoDxvNpFrcvNjX2MQMY0xohtHtIwAzr+FL3Z4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

inode_has_buffers() is also used internally and it is trivial so it's
pointless to grab mapping_metadata_bhs for each invocation. Just let
that function take mapping_metadata_bhs struct instead and rename the
function to mmb_has_buffers().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 14 +++++++-------
 fs/ext4/inode.c             |  2 +-
 include/linux/buffer_head.h |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index d7a1d72302da..096a8d9e3280 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -468,7 +468,7 @@ EXPORT_SYMBOL(mark_buffer_async_write);
  * written back and waited upon before fsync() returns.
  *
  * The functions mark_buffer_dirty_inode(), fsync_inode_buffers(),
- * inode_has_buffers() and invalidate_inode_buffers() are provided for the
+ * mmb_has_buffers() and invalidate_inode_buffers() are provided for the
  * management of a list of dependent buffers in mapping_metadata_bhs struct.
  *
  * The locking is a little subtle: The list of buffer heads is protected by
@@ -542,11 +542,11 @@ static void remove_assoc_queue(struct buffer_head *bh)
 	}
 }
 
-int inode_has_buffers(struct inode *inode)
+bool mmb_has_buffers(struct mapping_metadata_bhs *mmb)
 {
-	return !list_empty(&inode->i_data.i_metadata_bhs.list);
+	return !list_empty(&mmb->list);
 }
-EXPORT_SYMBOL_GPL(inode_has_buffers);
+EXPORT_SYMBOL_GPL(mmb_has_buffers);
 
 /**
  * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
@@ -578,7 +578,7 @@ int sync_mapping_buffers(struct address_space *mapping)
 	struct blk_plug plug;
 	LIST_HEAD(tmp);
 
-	if (list_empty(&mmb->list))
+	if (!mmb_has_buffers(mmb))
 		return 0;
 
 	blk_start_plug(&plug);
@@ -820,9 +820,9 @@ EXPORT_SYMBOL(block_dirty_folio);
  */
 void invalidate_inode_buffers(struct inode *inode)
 {
-	if (inode_has_buffers(inode)) {
-		struct mapping_metadata_bhs *mmb = inode_get_metadata_bhs(inode);
+	struct mapping_metadata_bhs *mmb = inode_get_metadata_bhs(inode);
 
+	if (mmb_has_buffers(mmb)) {
 		spin_lock(&mmb->lock);
 		while (!list_empty(&mmb->list))
 			__remove_assoc_queue(mmb, BH_ENTRY(mmb->list.next));
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6f892abef003..011cb2eb16a2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3436,7 +3436,7 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
 	}
 
 	/* Any metadata buffers to write? */
-	if (inode_has_buffers(inode))
+	if (mmb_has_buffers(&inode->i_mapping->i_metadata_bhs))
 		return true;
 	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
 }
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 623ee66d41a8..ebbd73c45e63 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -516,7 +516,7 @@ bool block_dirty_folio(struct address_space *mapping, struct folio *folio);
 void buffer_init(void);
 bool try_to_free_buffers(struct folio *folio);
 void mmb_init(struct mapping_metadata_bhs *mmb);
-int inode_has_buffers(struct inode *inode);
+bool mmb_has_buffers(struct mapping_metadata_bhs *mmb);
 void invalidate_inode_buffers(struct inode *inode);
 int sync_mapping_buffers(struct address_space *mapping);
 void invalidate_bh_lrus(void);
-- 
2.51.0


