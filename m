Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B286106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C70076B00A2; Thu, 26 Mar 2026 05:55:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5B266B00A4; Thu, 26 Mar 2026 05:55:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 827786B00A4; Thu, 26 Mar 2026 05:55:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 566AE6B00A2
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:55:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 222F85C9CA
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:25 +0000 (UTC)
X-FDA: 84587756610.04.B115AC5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id E43EA40008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jIR4MHGa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6zGQ8NMd;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jIR4MHGa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6zGQ8NMd;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SuN2MJmaIVCKwWXuZxWRLUlbFFlmlaXj32+TxYfxJfE=;
	b=P9cASvqddhphhs7Axt1BKhZx/rNioRoxrSlWQgIqe7luPusqiLpHFJXrTEe87B8VvkVyn7
	+cRae1yWQQCWDj3rEGRdUdXf1Xmfq9kywA02nQESAuXjNYWMcROPCgntdRFUSfdT9/B0Us
	57nPI3miTrCzlbPv9MT+VulP3OMK6dM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518923; a=rsa-sha256;
	cv=none;
	b=UQRTeNndfi2gx62Y/DHnDns1Nfh/UYdXmOZJ5eCbrZGgXuXRlblOelFKqJm37DtImC//8S
	vSixo09a0LR0RvlBpFiJIvcMaco1METm4oIVvTaYwCvGg2TPZfy3AK7UBH+KrgKSkpXfpE
	mQoXRLaL/oX7Sy0FMHnILt3PxCeeuZM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jIR4MHGa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6zGQ8NMd;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jIR4MHGa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6zGQ8NMd;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 08F995BD87;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SuN2MJmaIVCKwWXuZxWRLUlbFFlmlaXj32+TxYfxJfE=;
	b=jIR4MHGaryEs5OBSN+AANCv2mQUlSnOH6fjsfTY1sDJmFCEE3Pqx49a6kapa2QgXNV8Jv9
	CeEOhORkSiS08jZoY5BGcKGc4zSZHOfiSoIVaO2TnUqPz6oHgwuD9iRkIkX8hxcbRQh87K
	ri5+MoApkVPwfJyrCtCzBDHRWmI6b0I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SuN2MJmaIVCKwWXuZxWRLUlbFFlmlaXj32+TxYfxJfE=;
	b=6zGQ8NMdjs5ino5W4MfukyLwtK1UQgz+2XsEUiJV7ccKp+lDb3fqIa4ltx8hezyexmycA+
	JHWe0djyKehejYAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SuN2MJmaIVCKwWXuZxWRLUlbFFlmlaXj32+TxYfxJfE=;
	b=jIR4MHGaryEs5OBSN+AANCv2mQUlSnOH6fjsfTY1sDJmFCEE3Pqx49a6kapa2QgXNV8Jv9
	CeEOhORkSiS08jZoY5BGcKGc4zSZHOfiSoIVaO2TnUqPz6oHgwuD9iRkIkX8hxcbRQh87K
	ri5+MoApkVPwfJyrCtCzBDHRWmI6b0I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SuN2MJmaIVCKwWXuZxWRLUlbFFlmlaXj32+TxYfxJfE=;
	b=6zGQ8NMdjs5ino5W4MfukyLwtK1UQgz+2XsEUiJV7ccKp+lDb3fqIa4ltx8hezyexmycA+
	JHWe0djyKehejYAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F3CC94A0A3;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id m+uEO3ACxWmvYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 92E5CA0B61; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-block@vger.kernel.org>,
	Christian Brauner <brauner@kernel.org>,
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
Subject: [PATCH 05/42] bdev: Drop pointless invalidate_inode_buffers() call
Date: Thu, 26 Mar 2026 10:53:59 +0100
Message-ID: <20260326095354.16340-47-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1163; i=jack@suse.cz; h=from:subject; bh=IUvivkOnXAhLrZoa3cIuK0skAh9kHyc1wR94Cs3zoW8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI2vaEp5j2MB1rJFDbEn2Uwsbyoww6f0jWoa Faizb2hUY6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCNgAKCRCcnaoHP2RA 2fcYB/4zbot9xZ6lVkLaB3KT2IRCbCO6SZXIRgljgsx0/rbnEVxPrU4wpPASP3aZb6Cp3PB8gHE YL6+zwAXF4JXbFEHlx4ikephuEAOZK2KZFjAawikmpmuYgvqe017x9GBbeJOqdWywGGu0kNtiJm yZf+pE4/WO5fyHba6zReezxB5xXGl7wJTKHCpLWOX88Jg/+mQrNBLwUUa8GR7xpR0Y59s9zYu0r EskYuVKix1uXPaVLMAaY1/opwCKqR8E3r2n6N0vk8OYoT8f7drscA22ueg59Lpc8BcTIGUalyJx 8+Knno0wgPxQGZzDp3w+KG6j1wPqcS1bCop+Y1+g8deiilGy
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E43EA40008
X-Stat-Signature: natjx36qf9ks35kpperk8r5abposhhqj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774518922-761070
X-HE-Meta: U2FsdGVkX1+hwMVq9ft3qA/b8eizqzxaHLEJe6NiyRmbCD3ffQDf+oqbauk5dBaJHG3DuVkuC8zPlRH4jbpzGCQ5ueq7UxL7UCJqX6yJdNOPM1tF3u+4JX2z0p+SWVfX6TuO9XGKrHVPu6rh/EqAIy13w76mttJgNY8SpYW73PlRW5XqNn3yY65Y5Sh1ik9bLv7M9wfQ8pO2COanaFdMn2WoLaVgwlwGhHZRbySDBhRLgVFF8Q9jLj3HOY0z6tLxoaX4YPHaBo7cVfERPudJhypsqTS8hlZ8Rzl6LTlceoR6c2GUJ9cigW4mrQLEba9kz/SaqpbnXQ1m0FdGeyIiG+gV9iAvZYQjaDV2M23CazF4vtBSdw71Nt5cvG4osSE8EqZndV5CCs5RzEGAmOeiDunk3qHUJYGYu6m/gf3MbZWRcApRBf7C08MD066m8zDWVyHrMW0Y+GiMCSDIHV60ez27vehTd+B+nry5iFGmcjYb2kKdiAKZBapodN2zEBXsG84dxvgeioGgxx8o5tcrHUyAb4NJy/53JHV3h8ba9DgUKV8Z71tYHJYkIY2NHOepWpnQKyUg7IiqBjScFL/cLxnNAbrR8DtXITBuYcAL0Fqx6rBbGMN8jRoP1VNpnwovIup17ME5DqUKbAj297RHm2Xt4h8/puqWgdXok21Fz/ka9fVF2ndNoM9Oqz7lp/9nCKrXSWD+Ypsuv8kJzH220M1SNArX3sSXzNi9Z6jOEqi1KWda82lKPbJcvV+Z3+lDYpfgLDBDJLi/lDia8mgQDtcOuKxsPMOz/gxjF0GrPwCtg3drZWxZkH+Q5JmT8lPcTnaP8ymEq+7P27RqRrWBrvWbUUNeFKXXlbIhSu/ZQY7EyPh0QA2LTbr0sg2wrZeIfFmD6ts5n7VVCaGYLqOGTLvTs8AURWg9ZW/L/71anL0ns4DTDD+QUjw8JLr9oSApiaS96PQNjycH69hlxl9
 mHHuHEi7
 fUgq/U2YlxgSvB0dfdtPX4j318eQTdncvAl7nx+WgY4i2JVKzWdrff+q3czpKpyBWTJG+7+jqSY8B7l1quRNUarz4HQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nobody is calling mark_buffer_dirty_inode() with internal bdev inode and
it doesn't make sense for internal bdev inode to have any metadata
buffer heads. Just drop the pointless invalidate_inode_buffers() call
and consequently the whole bdev_evict_inode() because generic code takes
care of the rest.

CC: linux-block@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/bdev.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index ed022f8c48c7..bb0ffa3bb4df 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -417,19 +417,11 @@ static void init_once(void *data)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static void bdev_evict_inode(struct inode *inode)
-{
-	truncate_inode_pages_final(&inode->i_data);
-	invalidate_inode_buffers(inode); /* is it needed here? */
-	clear_inode(inode);
-}
-
 static const struct super_operations bdev_sops = {
 	.statfs = simple_statfs,
 	.alloc_inode = bdev_alloc_inode,
 	.free_inode = bdev_free_inode,
 	.drop_inode = inode_just_drop,
-	.evict_inode = bdev_evict_inode,
 };
 
 static int bd_init_fs_context(struct fs_context *fc)
-- 
2.51.0


