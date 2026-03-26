Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42B4C106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A755B6B0127; Thu, 26 Mar 2026 05:57:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4CA76B0129; Thu, 26 Mar 2026 05:57:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93BD16B012A; Thu, 26 Mar 2026 05:57:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 832646B0127
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:57:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40B5C8CE4E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:57:10 +0000 (UTC)
X-FDA: 84587761020.09.9B92B41
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id E69C340008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:57:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zSP+paXw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vuXdFpKj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zSP+paXw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vuXdFpKj;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774519028; a=rsa-sha256;
	cv=none;
	b=QjGD5WYHO8nsX11BY70GrfS3BHkHEA0QazXIu4vTuiBbyY0TjNcDHLELpFXhpGDR1KpPVQ
	ZQj+h1goi+Ll6NkWSndO4R1J7CkIlM8hJXQOCCg4PG9KwOdQqwDQKOllZj9Vx8iYevbWIC
	kBcKskaz1X18sNCIUDoF3sheS4NZLgE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zSP+paXw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vuXdFpKj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zSP+paXw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vuXdFpKj;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774519028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/mWtwh20v8xZ3gLOb8YfzfttWRltZG2tHqVQmdVNSOw=;
	b=re3ovs92+nyH8Y/XC11CO5NLE5dYDhL2zmR3qmU4o1w61fqXA1uHMLP10Zb7v4ZGKNaABV
	Iy337CV9Ruzzqm4aAI+dIhnvT6Jn5Qqe0XyA2i520gKjlgqpTCFd/Uy6RuRUJd0uz6QHLa
	EGbMFeoGpDh6MohcIX6CJcOCvu7jT6I=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B3F075BDCE;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/mWtwh20v8xZ3gLOb8YfzfttWRltZG2tHqVQmdVNSOw=;
	b=zSP+paXwYwAcsf9TxzoyaEiWW1Krka5GS4Z/pbRIhNLXpbeZqt6wB5erabVO9KlHjE2DgM
	aoZsqvK+PHSxCFujntgLK7GV0sEqiifE7EJQ12mYJlnFR5yZh0OWNVGrmhJ4+p0EBqa3vE
	+nR69/Ggssr53TsWWnKqPl7dW3M84fc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/mWtwh20v8xZ3gLOb8YfzfttWRltZG2tHqVQmdVNSOw=;
	b=vuXdFpKjrt72htYVcph8w7j2TTI3PVvEDnmsh2992ubSFkc972D0efdLeJsGssTvBFDlFw
	7XxCq+Jk4GRy79Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/mWtwh20v8xZ3gLOb8YfzfttWRltZG2tHqVQmdVNSOw=;
	b=zSP+paXwYwAcsf9TxzoyaEiWW1Krka5GS4Z/pbRIhNLXpbeZqt6wB5erabVO9KlHjE2DgM
	aoZsqvK+PHSxCFujntgLK7GV0sEqiifE7EJQ12mYJlnFR5yZh0OWNVGrmhJ4+p0EBqa3vE
	+nR69/Ggssr53TsWWnKqPl7dW3M84fc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/mWtwh20v8xZ3gLOb8YfzfttWRltZG2tHqVQmdVNSOw=;
	b=vuXdFpKjrt72htYVcph8w7j2TTI3PVvEDnmsh2992ubSFkc972D0efdLeJsGssTvBFDlFw
	7XxCq+Jk4GRy79Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A90484A0AC;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CwNCKXUCxWkHYQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F3D92A0C82; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 42/42] fs: Drop i_private_list from address_space
Date: Thu, 26 Mar 2026 10:54:36 +0100
Message-ID: <20260326095354.16340-84-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1755; i=jack@suse.cz; h=from:subject; bh=PNVVxb1C9U1PtR2RSzXX9wc57lK5fwMeMK3Vldbiae8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJWOFtW5g5HcqcBN8D1+JdIPOkjg+6XGAmLb 2D2HdluOYSJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCVgAKCRCcnaoHP2RA 2QpuCACoMS7QR2pp4YSgollxC/sRjTSpyLNVupKMGWEUcYZSjBBpBAxJoy65jMMVsbVJzFkaj2J bDNsgYNvuZF4vnbNSU6s4znQVK0cUfz6aQs6Cfg7HvY/G1TPl0REgglH7nr5ImLCuR78pmLPml8 CNUihOX4S0fE6F2XHptn8AK/ECtT24BA7vdnjuQ7kF10dK/Lfi7C7LZ8B9gvISVSj5xeWLeFRZ7 ZNmbd5YPQzQoz2dPJkX8eWZqp0HuWVhVzUUoyrPnmH819Ftp/z5YEZ3rLMuYFo4MJQEFop9UJTc ZQnhhoGzEF2ibPNdJXDmBE9zgPKEhPRwZaHueLFPyXcKa+sP
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E69C340008
X-Stat-Signature: ah4wxx3c13638d8eqi4de3q34d18pm4m
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774519027-703373
X-HE-Meta: U2FsdGVkX1+eBghWBiJ/5MIue5EWzbohs1Au6xxw1ggpOl+Rz71p/gHcndg1DAJBSQP7wL0ssReDCD6josY/luKwWG4BKJzEouqS4rMO2XlNF0Tjfa/CmaJ1qHJ+npWWgNssXfRhqs57Mwz97dx46PHQLbuSiWQQ9xkPfhg5V3/d4pWFXZI7U3NDeLDdpE6bFT++h3u7wVtNb3TTleeQNyLmgD+0MEi/j09vWYq1rkMAkC1BHBjUe3oTtp3oZsWJvtNiDJvVOjW4pAKT0TlZuFAl+j3jB2ypXBIHpXc1xMAb77VNNuzX1iR33Sj1i4aykc9B8lOni05QB2fSNY+t1tu2rNCClAtjRuVFlNtUL39Im8mQXDL6yuixaETgCk+ON6GsQF5QTfB5eZrG00M3MCuJy+HGJ8esO4K4lR/k5Zsew9t8r+bIABdFL+ZAXU0/2hObRyJ5KW6j4CoNK3EW5AXKnghHRrjkkr3uIDbW76iLwQLnaC31uFUdAfg9YFs+zPgL+IFBT7o5crvOxQOZ0QFmBLnWoPO0VEaULX/iO50Oubcx3mWIwwQLl6WxQTaq+J866DAwbakGNRsYrd3XKmWAMc1Whi3j1LVrZhXK7t/hJWOTmZiWB++IbJvV4sfg9jKwrDAreggQ/r27ITOPhyypaf4wxZmOK1Ol/xD8bzmHV3QJPKGEBDaGizZ4jeXv9/KDqka9LCIuq61ojI+85/vPWjWC2R5Gm57VQFy9LM2eTgGqjDowi6TaqC2Tl+b68NHXVQnbwXD0FtbyaNbToXXYP/hOnbS3HmshjJ/a1S0Asy/RYRXyOlf4howgJg82wIeV944zDXUYIbG/dohJbadnriVGg+hoDTbQqtzawJKtA6YJ5SGymHIqnNRO3/l3CGze48LGYMUT2i5DeOLSCB1IvsOPxNUfTDhVG95bCsiqu9zQke49jpaxg4UYSchmEy+rmUY/RQPxA0OxSmi
 ZiVu+b8S
 HF/Ufdyb+b4PoJSga82v6AK1eMgmWAC4X2gl5qh+54CfRG7i6w5XaJZfmIKNz/UlN+0b0FymZEWWtmbUyXhrz9gXveNswRS28/cOag/K5xp6CkUhklrMQmLeb1wVHuPlX4COv/6xMNWHTLufri24x4pu5bYI6xpiXO+8Ss+NLj4KVDH/xA+1Vte9G+nLpmqN5+Emr39oA5Q1rF4Hm02YFMN74kEdfVrWSYwVYWzntwjS2HnmTKgDgRWFCd0zzo/b+fIXOt2wxHfC9TKEktU29yb36fQtGNovJru5JRt4ZIu2cljpIC/fJL1rPLwLn2M7SULS+fk6yUKgOtZn2GsZQClVMq50u8pQYJN4+370V+8KiChC0JoGdfhb1F5j9Cmau5dDEkp2a0VQrECY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nobody is using i_private_list anymore. Remove it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c         | 2 --
 include/linux/fs.h | 2 --
 2 files changed, 4 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index d5774e627a9c..a8f019078fab 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -481,7 +481,6 @@ static void __address_space_init_once(struct address_space *mapping)
 {
 	xa_init_flags(&mapping->i_pages, XA_FLAGS_LOCK_IRQ | XA_FLAGS_ACCOUNT);
 	init_rwsem(&mapping->i_mmap_rwsem);
-	INIT_LIST_HEAD(&mapping->i_private_list);
 	spin_lock_init(&mapping->i_private_lock);
 	mapping->i_mmap = RB_ROOT_CACHED;
 }
@@ -795,7 +794,6 @@ void clear_inode(struct inode *inode)
 	 * nor even WARN_ON(!mapping_empty).
 	 */
 	xa_unlock_irq(&inode->i_data.i_pages);
-	BUG_ON(!list_empty(&inode->i_data.i_private_list));
 	BUG_ON(!(inode_state_read_once(inode) & I_FREEING));
 	BUG_ON(inode_state_read_once(inode) & I_CLEAR);
 	BUG_ON(!list_empty(&inode->i_wb_list));
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ccfa696253c8..a3bed26d066d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -471,7 +471,6 @@ struct mapping_metadata_bhs {
  * @flags: Error bits and flags (AS_*).
  * @wb_err: The most recent error which has occurred.
  * @i_private_lock: For use by the owner of the address_space.
- * @i_private_list: For use by the owner of the address_space.
  */
 struct address_space {
 	struct inode		*host;
@@ -490,7 +489,6 @@ struct address_space {
 	unsigned long		flags;
 	errseq_t		wb_err;
 	spinlock_t		i_private_lock;
-	struct list_head	i_private_list;
 	struct rw_semaphore	i_mmap_rwsem;
 } __attribute__((aligned(sizeof(long)))) __randomize_layout;
 	/*
-- 
2.51.0


