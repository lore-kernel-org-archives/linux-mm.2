Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8F4E1098782
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14FF6B00D5; Fri, 20 Mar 2026 09:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A47F36B00D3; Fri, 20 Mar 2026 09:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A596B00D8; Fri, 20 Mar 2026 09:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6DC8C6B00D5
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:43:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32510C09B3
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:05 +0000 (UTC)
X-FDA: 84566557530.05.7A7DA80
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id DA376C0004
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m3kGs7d4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GswqmZ8Z;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m3kGs7d4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GswqmZ8Z;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrTgdRDZY7w6M/u85YX9hxAeGXT4iZmtaDipM5rnVgo=;
	b=SBR5I87o4S4o38qYUAe7Zlv87664X5ShXh4Ug7amzCMk9rmO3V87jouaVXVYQCzWQcbibz
	pW4XMvfCHNC8Jwu7XvpTNDQl9fT6OkzdmLMuL7RhNLgwYlcbHvtBMC2m9AS0ekTeo6F40U
	dTq+niTK+37M+vjRrSMTqatzptABXVY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m3kGs7d4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GswqmZ8Z;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m3kGs7d4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GswqmZ8Z;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014183; a=rsa-sha256;
	cv=none;
	b=A/MyENqfN54Jr/Eq1cwZ6kSFw+sfhZ984xO3ougSNpcZFSB8NUrEkgccKdv4LOrgfBk1wi
	R3xVecQAPuXhzfh7nGukb8IS/633vAEW59qUXfh9rvQ8w3tipabbxZMW0o4LlRrQQBtVKd
	/AVWzbzO3zeB8jB5RpraN3WWDKB3iQI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7C2EF4D32B;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrTgdRDZY7w6M/u85YX9hxAeGXT4iZmtaDipM5rnVgo=;
	b=m3kGs7d4J6v4QvnoUSD/e0rS1VEcdTA3AYUgR8kmCLK6KKEo8T1RnBC4HJfY88aC70Yvq7
	dIK+kvjDLiZJLIqf+4pB6t3NtsaP/W51qTtDmwF4DMO/K5A1dFyD5+alEEHk8LmXo+9X0t
	2eYRMsI8OCAGtJ4P/BdwunKe4piNfUw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrTgdRDZY7w6M/u85YX9hxAeGXT4iZmtaDipM5rnVgo=;
	b=GswqmZ8ZHX2vYj9kI9nAHpreAmNVLCIA5VKsGlnBVRKHgbpDTn/I6F3BUOIpKLHVETYCJG
	cjC2oXu62YH5HFBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrTgdRDZY7w6M/u85YX9hxAeGXT4iZmtaDipM5rnVgo=;
	b=m3kGs7d4J6v4QvnoUSD/e0rS1VEcdTA3AYUgR8kmCLK6KKEo8T1RnBC4HJfY88aC70Yvq7
	dIK+kvjDLiZJLIqf+4pB6t3NtsaP/W51qTtDmwF4DMO/K5A1dFyD5+alEEHk8LmXo+9X0t
	2eYRMsI8OCAGtJ4P/BdwunKe4piNfUw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrTgdRDZY7w6M/u85YX9hxAeGXT4iZmtaDipM5rnVgo=;
	b=GswqmZ8ZHX2vYj9kI9nAHpreAmNVLCIA5VKsGlnBVRKHgbpDTn/I6F3BUOIpKLHVETYCJG
	cjC2oXu62YH5HFBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7185842817;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9Fq2G5lOvWmBCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 22956A0B4F; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 24/41] fs: Remove i_private_data
Date: Fri, 20 Mar 2026 14:41:19 +0100
Message-ID: <20260320134100.20731-65-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1510; i=jack@suse.cz; h=from:subject; bh=p58QfOPdeBSF+GFT64AjIbjHzbd4gdcT7JjSAJNis4Y=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6AToiVV0GqpqU6pE7PQT9P/O66rCCDmO9KI 4afzBMrY+WJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OgAAKCRCcnaoHP2RA 2UQ9CADYF93eU+lysMgRD9NC+J4reatt3UWiFSymsiFzUbhTUnhlS5oiXgnlRCpok++GtXhbsZI FZINwnZekAvGBqDbSCKZfIC2ZSRuaEd6Pzo9lPYRzN+jSfBMMziLJQ7O2f8nr6jQTf/yWR/Ecmi GhyUqGm9JEp2QWO6cod4WIVQ8HOf5GFZNk4y+SYXfftv3tWA+J3gS5P0Op/t3a+n4eNcrntnt38 Fw6+EIdydcLj3hs4ta3UNBxbIDKBDgNAVUY7oW3tR11iLJCoOC/wkFIoZm/KeZsAEi5SNw3wHGq IqBb7w0Ym3x9dZoiV/iOP3s/FSJGos057kaVEJqGDMTTO3Pi
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DA376C0004
X-Stat-Signature: uu97jszco4tsexmhcabqbrashnbn59a4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774014182-244204
X-HE-Meta: U2FsdGVkX18BFtvU1KTlZ+fg4xy7PnrDN8rMREBwrRTTkG6f14v9KAiUE2315CT2yW+PEeGPOiPuyClQ47EuaPe8XVleTY7MD7pa6KKVucVd2tT9Txq7nIwHFcy09FbZ13F3nGk7/c3kJy5l6F/1ht6Grai2aBVmlo9ZuS9ZR/0mluMXaKGKB/mgui9BQV9dp4WixS2vdtrdJdN2998XNwPCKldrrAedqEkRDIXHwcVdfTRSiSLosBjbC5oiDNBx8w76a/2dUWqDtgn7CeMrJWsrrZANttx/dDjvFcLpCPsvVoaiNIJqwn9Jwpv+w7r7Ml1NYmbGVCP7sQrZen0cDpbiiOtkVR6dgLw/PZ50bnl/y4p1dBsKGuVgt/nzTJl9iuDW9Rsd/IxfaNufVY+yGh09CDLeMOtATXDduDR9/nhwvqz8iTrTS9txPbs0j5RfTKwjzNn5FwUrtmAtvoO33tt7WBwoGOvrHYK4hHSpwasxZ6qz+3ypkWdUmW63yjC/7wjvATBc4LUNNhOJiv0+SS4XYWAcU9R8aQKgtYEGQMu6zWGM6oPcuEzTNk2I5RdomQOlFzbevK7E5KPqR1xfNy0UqK1cz4XetavxJ1qaJkEL8+uxuj05nXGhfRHKii9ztBAjLW/phB4/wtGslxCWSR0JF4tkLTuI4lQfvPJNh81w7rjMoVvx9H+DFQSGvwrBSdb/g4q9QzSM6jes6/j3saiVn/q4MrEuVYNQCD7PKSTxYWFiMK152FiQFrPCoS8w9bz1E+CdRV8TGwvL1pSDO4b7zHKN30zoZAcy8+9ru8DQWpZxIM0nIRnefl6dW7KeWQlHKnRTxjbCHeEV0o+juZS+lOCWJaTgmJiDuvkIeUYcnay3JV7mevd5ttE9UjP0uI9fyJsfANKRLaHUJJSvQWsV5pRV6C19aavLzK4Gi9RisYd5Vtpr54MKk+Qklby6vuQFYMmW2Xra3BP90Jb
 UtrWOu6W
 2XRoRbzPpFJvu+YGaNaY1LXT/H6MbAOt2coVddrgAn4tf+0sT7/ZRWk5jR75IGEO2pbUEW2sprC7i2uGZJv1J9MT8e9CEte48X6pL8+Ozp7QbJGtLVQSZ5YFpQouCwepDp131sSFSCtZmVm3Pm+CHooUrx+12mMZSBc5xNW8H1AKc/9kQ5IH2BSP5eaPzIraxlmeZmaq4PL4S7YPte0Vvxqj/Pk2c8aFHCCbZymtKWDFjgQt0LlVHP3IjOqN966hOAqnq27S/jfxrMa8KO34NDD7IPr65j/0UkHNLtmkjwTVhuqQAbM+7zGyJoJBfl5QJdVAX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nobody is using it anymore.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c         | 1 -
 include/linux/fs.h | 2 --
 2 files changed, 3 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 4f98a5f04bbd..d5774e627a9c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -283,7 +283,6 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
 	atomic_set(&mapping->nr_thps, 0);
 #endif
 	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_MOVABLE);
-	mapping->i_private_data = NULL;
 	mapping->writeback_index = 0;
 	init_rwsem(&mapping->invalidate_lock);
 	lockdep_set_class_and_name(&mapping->invalidate_lock,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8b3dd145b25e..10b96eb5391d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -465,7 +465,6 @@ extern const struct address_space_operations empty_aops;
  * @wb_err: The most recent error which has occurred.
  * @i_private_lock: For use by the owner of the address_space.
  * @i_private_list: For use by the owner of the address_space.
- * @i_private_data: For use by the owner of the address_space.
  */
 struct address_space {
 	struct inode		*host;
@@ -486,7 +485,6 @@ struct address_space {
 	spinlock_t		i_private_lock;
 	struct list_head	i_private_list;
 	struct rw_semaphore	i_mmap_rwsem;
-	void *			i_private_data;
 } __attribute__((aligned(sizeof(long)))) __randomize_layout;
 	/*
 	 * On most architectures that alignment is already the case; but
-- 
2.51.0


