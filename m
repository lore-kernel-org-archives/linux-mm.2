Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E39851098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F6E6B00AA; Fri, 20 Mar 2026 09:42:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC396B00AB; Fri, 20 Mar 2026 09:42:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95F36B00A5; Fri, 20 Mar 2026 09:42:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7362E6B00A5
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 371C81B7060
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:21 +0000 (UTC)
X-FDA: 84566555682.20.A6176CB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id CC5E918000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="U4ZaHwu/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CB0T4VgP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="U4ZaHwu/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CB0T4VgP;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SuN2MJmaIVCKwWXuZxWRLUlbFFlmlaXj32+TxYfxJfE=;
	b=h0P/XMp6RJuSrK9UBGajpXoVzM+vGl/Yn3uKGrR1B2esAmOAyHjJXb6oEh8iCVvnMXNVYQ
	fh2i/0GaGTclwWrPfr0A0Yyf7UhsN0HVDBGp7ro9KPpmOauSIwN7YaSvlyIH5x5sJ/xZix
	lW8LZfBQw7qJGo1jj183khXMdB6dem4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="U4ZaHwu/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CB0T4VgP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="U4ZaHwu/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CB0T4VgP;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014139; a=rsa-sha256;
	cv=none;
	b=awLaHhOU74JMY3+h23pMjBHe9ytdOyzBMraTDI/l5f1R6Kpxjiv4un359jneK9FktKs+4x
	HvXlrRQAU1kYZfV2J1mNMfC8Y3hA2e+jDNJb5wCwYfZZBOIHXEaDKD/e9vhmbeVqrOAZUE
	DJiBGTcnLlmHVcLTDC4tNXb6KtmyNtA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F38195BDF7;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SuN2MJmaIVCKwWXuZxWRLUlbFFlmlaXj32+TxYfxJfE=;
	b=U4ZaHwu/dP3oVpEULEtXd1cqvyIn3yApqSOz9TMxl/tZ/L9fLwA85vXfzEehTHnz5pifyK
	/ruhuigaJR/dwGLayXs8nCQZ8GKF03GMVQBt4i5mFmcyCETnpe0QU+mvEl6CEiJvquS6fA
	axkqt7LJWD7JEfbg04azYWN9jQtiAgc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SuN2MJmaIVCKwWXuZxWRLUlbFFlmlaXj32+TxYfxJfE=;
	b=CB0T4VgP8JRmQAAeBpmvzC9Y2ARMbeVTzqWgn2c17L0RE30OwvX6Trjp3TeWO7Hwu5w0hP
	Rwprii258XX5aZDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SuN2MJmaIVCKwWXuZxWRLUlbFFlmlaXj32+TxYfxJfE=;
	b=U4ZaHwu/dP3oVpEULEtXd1cqvyIn3yApqSOz9TMxl/tZ/L9fLwA85vXfzEehTHnz5pifyK
	/ruhuigaJR/dwGLayXs8nCQZ8GKF03GMVQBt4i5mFmcyCETnpe0QU+mvEl6CEiJvquS6fA
	axkqt7LJWD7JEfbg04azYWN9jQtiAgc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SuN2MJmaIVCKwWXuZxWRLUlbFFlmlaXj32+TxYfxJfE=;
	b=CB0T4VgP8JRmQAAeBpmvzC9Y2ARMbeVTzqWgn2c17L0RE30OwvX6Trjp3TeWO7Hwu5w0hP
	Rwprii258XX5aZDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E84A442817;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8ou/OJhOvWlUCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7993BA0B3C; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 05/41] bdev: Drop pointless invalidate_inode_buffers() call
Date: Fri, 20 Mar 2026 14:41:00 +0100
Message-ID: <20260320134100.20731-46-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1163; i=jack@suse.cz; h=from:subject; bh=IUvivkOnXAhLrZoa3cIuK0skAh9kHyc1wR94Cs3zoW8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5wvaEp5j2MB1rJFDbEn2Uwsbyoww6f0jWoa Faizb2hUY6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OcAAKCRCcnaoHP2RA 2dh2B/9xB+CjcqghZSzN3eCyJyrzBXd7TJt+D2eXsF0P1iy9KZIU2VkQ+nbzKNEX7H2QcweU5E/ KyFUQEwn/IE9wUZ2xi6/7gBNlwMGOt+Qdksuo3DaJDxu9i0xFKu8Uii6WnboFBSnRRZcadd+zF9 CqaEjtsjh0NzkydOwwwc+gixsY+WSTcRTOktMcI609P+AyRcnUxuSURBU9xJZUasYHnlQrFc2j3 +dZ7RfkDrlJ92pPfK5RJlGJYHqje/7r8hKqPIo7QQZ3YeRE1vYwRXRR5DNvrAZWKhYVW5nS57dK n7mvmyhJS/jEc7l5YBYabvZY13PkiTo62Z8UYWhUTNxge7Qj
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CC5E918000E
X-Stat-Signature: 3n8z97xx64ebfkbcgimrmy63pik9d9zc
X-Rspam-User: 
X-HE-Tag: 1774014138-834163
X-HE-Meta: U2FsdGVkX19o95wF5AoRjCDSHrC1Tvi0bwNEoQYlAD3yIiqdn+3fkktdInUJDb1iJLjV2nEigG4kOJk9kY4uo7XCjB03SpJasOEuM5xeMuhUeypUY5RmwYsy4VbhDJOMAJ1KEH26LDnsLhwXnmzsTv99Fd3aOZ/q7ocIReOBrlf7ELozOnc2TydmLFIHyYL3AqMkSa/bdtBb7FAa35wLtc1H0ZH00cZNrL7jMAaYEKbZO/08IwEvwozky1wAtPobdmSyUmvLhqFZFsPZEj0bt2WBmbiJ6nc717YzWPRk3L5REXtO/2eaWQ//DT9arfpP1s6atnTB0fAnE0Hi3dmmO1HpFqB5EwtpCFx8ChXW2hHzo9pxlonKliCPV/pUGU2z5D7FrsqJuPXF0ry2fII3k5T/evNc73tMAaRpyWiiwfD04fBHmLCB7UYz71m+ZCd12jhooMi9ow9MwmQ2sg9eRaf/XLzamU147F2qu0qLAUjMByuuzCtAyBlMVlc8Wnb7n1b4pd6XBLzsbLs3oVpnlhMBBeKPk09paODTj57FYaUAS91KtiTXmGMvvdJcAxZl/ESTim4RLJAuRCYLeJ35Ulwm1KTIHDfV6wyl0LdJfEUm2o3fI/2doFwmeEUZJIJy8dwKRJSqMCv0w1RuR7prnUZsBMjFV6saroUk8Y/nyrEgGTsHe8FsMjCwztwYKRWbHTEF6/BIAKR9/V36C0qf5qXrCWIK0dqr9jDhpnwXufaYtwgK21go9S7ft+IHpxuxJBhcZgvRDJzPxDDgr5ZGeY1oUWr5XCMs4cla0A/m0mvamahimqQI/xqMyA8d7bToFIBP4sU98ipd5bZopon1IibkF6AHK+Ydu12r157vWC5o/xEshvl6o9MS+7lmqFwrcpmGjsDz8mphLYH+f01wls/cUx9lzLmeFcLYEU3GC7rdqBrkK+VSYcMDOZDLgWEpRr16QnzAh+HiEIiolMV
 dBSGjElc
 K6tq+hg/1QoS4tDaRW6Kvv7sB5aTENTfIScY4prBSvyxkJuYxNxOxtUzbfsh0FUeAPKwbrGlG5S+K4Y11c4sPU/+y1hCvbIkcnNdMtNq+WNtOJ7jwAje7yzBOT2TAf4YY0969h87E9VzrpfYd4dPkv8O/SHKZv39eAbOxAfHl4ReAG4yaGh5qdCnLWhKD+PgmpAFw7o2b2460h2OLR5JbeU24UBimEosgqmsr1Y/UzgZXJHMhRUHYjHwLlKVo6vMr8HnAm6llgxlEL8sBmsXB89GVmkwazs/731q3pJyJ8L/vC5YdxOjlUjq5armc1Ny8YcARWlZ3Gssko33KDogfJTwEhaPKK+GX1bKLuB/oAFNc1B0ifg2i683Z8gPwcwImDsC1
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


