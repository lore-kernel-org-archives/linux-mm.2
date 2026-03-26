Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4062106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AFD46B00D9; Thu, 26 Mar 2026 05:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0394E6B00D7; Thu, 26 Mar 2026 05:56:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E90D66B00D9; Thu, 26 Mar 2026 05:56:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D100D6B00D7
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:56:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9EE65BD182
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:14 +0000 (UTC)
X-FDA: 84587758668.04.43CAB50
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 396384000E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="zgt/l9+e";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8A+6Hkn1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="zgt/l9+e";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8A+6Hkn1;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518972; a=rsa-sha256;
	cv=none;
	b=T9xamKC0X3wfwxzvOyVAMjlE5vwJDzBJ4uJZ1WQk1N1yhvj+CNdOtbHC5fF1RW7i9r19sm
	lG++Iy3xREUJ4mvVzddIbrxPoabaoj8AoL9Lwf4Yk1pweM6obDRayu7gJ/HRIJPyBU8aoV
	aopQspuAsHW1YZMX/ovAPsYFXC8i/2A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eVNcHqKsegXzen6oPOecG9yyoB9CZ9IMwK+N6eIPHG4=;
	b=oSnJV3SvZrqBHk8iC9xLbmfETlMDHi4BWuFeGzrv6fjZIVOdNOt11PrIZ0nrAGC6aHjkvo
	clQPLYrfvqTrAazpSClZR6omF/saF7zwFpiaMwyMCaZEvb409fJ0KlungTuIbz1PnmsRKJ
	XzcT8JNp9etvCHRDxByKsE9bowQA62w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="zgt/l9+e";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8A+6Hkn1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="zgt/l9+e";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8A+6Hkn1;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 74D914D290;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eVNcHqKsegXzen6oPOecG9yyoB9CZ9IMwK+N6eIPHG4=;
	b=zgt/l9+e3mgqkjhkBnOUuRm97r6GDo1AfibEJkUrEhq7SnHGNx1QvI2jjk0NaF25QrfpvS
	h2bdq5xnoUrO5e5PURzk2I7tai0vSttkQWaa9oGKqQdq/Fj9cuvw5TlzrUhOXJJxr6o1f8
	UFeUXep4f7Qy1yU4GwBU4NFsLLHJGfQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eVNcHqKsegXzen6oPOecG9yyoB9CZ9IMwK+N6eIPHG4=;
	b=8A+6Hkn1rDDsoC70xT/ljIRRuHCer32hiMeLWs+kleav6oLDTZ1e8mzAiVzDLHpifeO/cZ
	bHZiHE3y384uoIDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eVNcHqKsegXzen6oPOecG9yyoB9CZ9IMwK+N6eIPHG4=;
	b=zgt/l9+e3mgqkjhkBnOUuRm97r6GDo1AfibEJkUrEhq7SnHGNx1QvI2jjk0NaF25QrfpvS
	h2bdq5xnoUrO5e5PURzk2I7tai0vSttkQWaa9oGKqQdq/Fj9cuvw5TlzrUhOXJJxr6o1f8
	UFeUXep4f7Qy1yU4GwBU4NFsLLHJGfQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eVNcHqKsegXzen6oPOecG9yyoB9CZ9IMwK+N6eIPHG4=;
	b=8A+6Hkn1rDDsoC70xT/ljIRRuHCer32hiMeLWs+kleav6oLDTZ1e8mzAiVzDLHpifeO/cZ
	bHZiHE3y384uoIDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 697184A0AD;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UPZyGXUCxWnmYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5EF50A0C70; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
	Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 26/42] fs: Remove i_private_data
Date: Thu, 26 Mar 2026 10:54:20 +0100
Message-ID: <20260326095354.16340-68-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1555; i=jack@suse.cz; h=from:subject; bh=aaS3p7rYcU0Djxp6pNN/3QR5Enbcvk2UVb3ATJEe+lk=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJIE9HM0mjerK2ay1dK/RZJ4GYD4z+qCPm9s Z8cujXnLO+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCSAAKCRCcnaoHP2RA 2SHeB/9xyAbHhSlSNpe0Kpkb4wXcBjVU/YNMpOEk0hdfXskKNhk4tu2t9puIrceJ/eHa10S0gmS hQwjF39WV1aNAlN0zci/XcH8TWra0k4pjYjWsdDQ0bLYxWqDZqXcYxRWhAdz7i3V+BIRHEifrGF GXebltgg1w7b/EU6cwJeAIeRmWzr15yBi92ql3H0WT/RrFI2y/SczgX9JT31wz2+hdsyVugWj1K TYDeys+hYH4dgqve9MGDcXldcuXeNNyj1UYtXkJHJJYIX+rJCiAqG83DZbWhHhQADMWxIUdzEBz NsCXaetBz2Ve4q5CmjG+JoF0s/YFKXwln+mDgliLfOCYo51C
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 396384000E
X-Stat-Signature: 3iai3e9w54famhs5hcu873tunphbdfbk
X-HE-Tag: 1774518971-378439
X-HE-Meta: U2FsdGVkX19grn4pGspdg/VEfhEUnJSXTRF9VXer3vLFVnZwWc2gIetNhItZmdwpbILFmk20Dk9aboU+lxheV06pngn9euuKTT7hhCEVGq2ymlVDz2qWaaYSfvrho83lBZsTHBpUb6CbRotqKJHnyY+J6wPqaXsB4VTiK8efICkEG2F0xoyOlzCe9XW36kUgaDpm161/ijHLTEaecSOQM1xLo3zxa9ojJML4F7bzimKDn8ClwrnlmlYuKvaffHXc7a51203au/Y3SlOXAtZ1D1JLzxYvVOqoEhRjgd8KCpV4QbO2JHgxj5mHMZtvOF926zBbLt/YZmS14MgVmrdhGjzwsAnKbXNQv+Oq+akrPnD0tcmCUKHi25fw7C5unoZwjeImta9cQKOScUYWTtY6Zahx5iNfljDEyWre4TQHHZ47kIl1STXmSkVs2ya6uC6J7B6X3/kfh+eFKry/bD5NBjAde26f62Vn0jAqJZagWzszSAMIJNIemruJJp5RbA/OXg4PHe1uLl+lU2ppRVyxu0w8t7L1bMHqQBnY61NkQdvgYyMuOB3WjIkyf5QJaDeob9S6qLL32xGnnSwHQhl2UNdHBBMGhx2FYV4k9tWcf+EIiGThBEHCFrgmndgVlaC5g5qJUaNEkLhczBwYn2qYLpFMA7dC18OWCyxJrAwPjCr4RT1NN9RZjBUmT9YlUrtaTotSoW+WO8nSNczUnXqb6IRYB2us5qtACVjPtFxSaE1/8A2B5TcuXz0DGFD0rtV7oWWPh8ZcWF+0ve4AWAxwrnePVYmHnhBhSCLWxXZ3y6gkP8Wf0SnoFroFiQWp019YPysar69bfw6cQ5hj6Ic0i4SHS4iJtuTi+B9CNk6Y0yxLYSTUlTyGaLgJ4BMkjKxxFjy/2GbZ1f3xUULf2nUH2Z+Nm+Cl2/m5XC0VinBuRtjdjkfClh3L5aoo9daxHHtFXfzPo7zF7WQBwWaJw1j
 JJV3RUWC
 DmMixv0QVyTEbU1D7mNuCPu//qIiy/IuSn40ufdCF7zdBdul3BsT1vyFf/PRJu27i9jkCVEklsS7icPI0ihnHd9yU1lK4Lz6zvp0NvbB3SEcRkjqf5hslmiYB44ukxRlkREoZTzQt/mjGCtLuAX41aQRaidf4lFK+DgJpAUX1Jfaiy0ij/5JOImehlBF3QpiXTaqnu2GLaY/5Ewz4w67i/inJdnOMujGmhwynR7teCNWnGxhN73vNyHiPvHdylnXgGB3rsaAGq7E4I2Zg75EQZIoz5cYPTMFr2bl65ewNEVTw6dxmq+luNObrOpHZH09Ze+1b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nobody is using it anymore.

Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 0fc0cb23000e..d488459396f4 100644
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


