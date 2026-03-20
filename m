Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D96EB1098785
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B78B6B0103; Fri, 20 Mar 2026 09:43:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3449F6B0105; Fri, 20 Mar 2026 09:43:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE4C6B0106; Fri, 20 Mar 2026 09:43:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 074C36B0103
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:43:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B49C456CD4
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:50 +0000 (UTC)
X-FDA: 84566559420.11.22EB1A8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 641FC4000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GPACIVdX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bzoxRBK6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GPACIVdX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bzoxRBK6;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PIdnoc6AOh4EVvm1ds230hNbFZUhFgVU5FODOS66VJI=;
	b=4h9nRughtA7MAI3urQipKxfnyPdT2skN+PoiPkTvtJ9RF7E4GQxDwnIP6XXhI04+qjnZ8E
	Aw3vzbCyj7JPAToOKTwCULXPRYFAgtE7H77eeLiA/xhT6QoWohPcpH6mZWyICP2pLaO0pz
	ur+ImyW+04ey0nbI8m2fD+NS4hvwCmA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014228; a=rsa-sha256;
	cv=none;
	b=R+InFpb8uaF0GiIH6IpA6+cr0iHIodub3WGDQ7y9RMDwryxtW2AfXrJPPN1OUXmdOAKR0m
	OPScDevKHK5iXvfKLGqpMY4xPHR3W3BeYYS2sQ0Z3uVMnoppnR4hObkBh6FCZC/lZwBm30
	HBA54v2QI8jZQqf9W+xgiLqLbTMAYEQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GPACIVdX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bzoxRBK6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GPACIVdX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bzoxRBK6;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E29CC5BEEC;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIdnoc6AOh4EVvm1ds230hNbFZUhFgVU5FODOS66VJI=;
	b=GPACIVdXPb4Vy60u2/wBOf765q7JBBNsQz8TJ0HaN5e646ZeReIYyK+4JRQ5PAGhUCWa5N
	2T/vgX7lylFuZssnBFkP1jr7S0Cp8Lq0j4PCHdoEZ+0v4qeG4Fcc77COJtGmFpUZKYv06f
	OCGs+rr6bZM7FbgygopCaWJzj7jmoBA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIdnoc6AOh4EVvm1ds230hNbFZUhFgVU5FODOS66VJI=;
	b=bzoxRBK6CSLKo0pIaEqiW6Brnxon0Kn2wYYx8oeyWiWDbVnOnoiUHdesUVbNXaXKhNK+Rh
	DwTBbmGQ/1B+UiDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIdnoc6AOh4EVvm1ds230hNbFZUhFgVU5FODOS66VJI=;
	b=GPACIVdXPb4Vy60u2/wBOf765q7JBBNsQz8TJ0HaN5e646ZeReIYyK+4JRQ5PAGhUCWa5N
	2T/vgX7lylFuZssnBFkP1jr7S0Cp8Lq0j4PCHdoEZ+0v4qeG4Fcc77COJtGmFpUZKYv06f
	OCGs+rr6bZM7FbgygopCaWJzj7jmoBA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIdnoc6AOh4EVvm1ds230hNbFZUhFgVU5FODOS66VJI=;
	b=bzoxRBK6CSLKo0pIaEqiW6Brnxon0Kn2wYYx8oeyWiWDbVnOnoiUHdesUVbNXaXKhNK+Rh
	DwTBbmGQ/1B+UiDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D99C042817;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mp4eNZlOvWmeCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AB253A0B4F; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 40/41] fs: Drop i_private_list from address_space
Date: Fri, 20 Mar 2026 14:41:35 +0100
Message-ID: <20260320134100.20731-81-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1755; i=jack@suse.cz; h=from:subject; bh=kN4yQPLaUsCnzIPRZorzisq/QB32Sww7t1iflZdzArM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6OevxZ8hjhuFMo+vS0T5sA1xOyueJaFNrl9 o2FP1Zp8V+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OjgAKCRCcnaoHP2RA 2bKZCADCjeZiMyd0jFL4LwDCM7fprCU/X9dLGSk+ens+8OUfdKCq7itxlRrHK3E3LB+VUm5oUNP ZL//IooQlXV3E8R3O6EDNsAtu+qYYj/UYwBTnY0pb5/+5hL0MuoYCj0wzIZ18VBcxoySOwro0kL 2bVkHmeYK3swxVd0MrdfYLMiSopdpA16VKb+Yy+Us45VhrLh5wVDvbrWaWeQ+OuhVuJhic5Ehn1 c1RyiHkFPfB+veZV9avGuiAzilx9CSsK7mC1q15Q6E3qEFnKd99KkfJo2a6xS2g3dnPX78abneE 4m0hXKyJoWC2MRee4z7k9pOgsjoLUgIQwQ2hkIC36mm6zL1I
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Stat-Signature: knjufoprzo1pjcbaapwmcsmisnr6yqit
X-Rspam-User: 
X-Rspamd-Queue-Id: 641FC4000E
X-Rspamd-Server: rspam12
X-HE-Tag: 1774014228-656492
X-HE-Meta: U2FsdGVkX18WAZdCmLypIRwZMUwdm4hQu7O9qax2tRQV5yWLbxlMHbTfV0DV6w+3FwvguOC+bfIZGRtU6IeW9R4IzafGVKRN1ylby9R9QFWj/0haw39it3CX+TokIJ5CGp3ZlId7QyAs219i+Pm53KtDcPgJLom+ZrktlbPwFUu0WnqwCK3ss4vjMwfCZHKPaJHTOkawRyjqQucHOey6pcjQiO4QbLdKYrwQ+JgHdA3HqeIoDXwczudg0gybMxuQs/Ayxhm0tLRzIHpzVW1tY3ve3fpZIoh7z5UH0xTZ6zvv4xzCi/vcVbaAbgARDE/zaofvYaHZfmBW7Uem7BIAKgzpYh5bQsZktysLOMvaNF7eMQy1ilVWrG1c1tN+LzGS5PPF3f9oC+HpLJnSSXTbotbqOha/kx4t7EkLMp+XAEtrYTnF1DMfspn0F0r4DnwRKKvuQM2F+wlEN3D+i5l/aIMkwMVXQ3cnZuGhM4UwaBfbQrHIty5A/m4tFX54rFy2XEFIQ1eMAAXYaHhjgps6QYQO1h1OfXZ8ufOjIgoddB7ShZQukf4MS1qldT/DMhiiNaLlrZT4oPdwlfk5KzUDoL0lWN9eL5AX1YzqMyoVsqgUA2X+M1lyd+rzWlp59nO38nQHbF0mdmfp2VWX4hf+Sx9kkIVTJ+csMWmNunHOj/GyBt3/A56VC2zhgnSVPIUqGnBteA4RFBThQVgC2Ltw1lQyLQWwPvoj7ZC3NznvinJKbN5U5kQMS2x9yCVcIgTWMko9nkNDIPB65XnalViWxO5m9gmhzhoFnnA0jqWsdY7iHddKkfPsTxe+zgcfrv2cNl2y1knsJkA8HNOFzG+Yt4DNgmTGoeFkDSLPAEVayAH4fMR5iBQ+s5UZY3VI59g5AcjdewX9W7oLSiI76xg++AxdyQJtOdBRlDTsg9EVAdvfHv+VOeyNxtA7Q6z/L+0YmpoNJniKaMQBE7S0g/o
 jm3TnHWK
 Pe0xypjuQmy7zGt+PVpIL32jhJbpztmPECDtBz9RB0VOMLxsr/gJR4SuMYRQLjM7mJO4Y+HmyEg7xyl6dJd+EGjfW2T2h7lTA4GEueYNeNHOeuZpa2aJqexvxAQNnrSUQQfMXVOKofxluZRh+3PiPdG/aNl+ehHiEkvmrS1oWG0xP5ux6+JH9h+Pk/ByCaj2PkF3IfJY+bwO/COXY1Wp5c16jS7bcCdKyKv1pMwj10IvhEMhj5VtbH2Vvhbs6oZzhprlBIfvjaZcg4zhsUpxVh6dI9Fre6uJXt3BmeEaAD7vBpSsO1IImtzzR1Ogmup8E9O6vq+V5MxOyUZto0SgDZfE96LQJNsdMXnliMmYU8mqAiYwiMSuAuKW6EZ/KAtN7tZeN0fmnJVOA7kU=
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
index d2122e1c9a3f..caa9203ed213 100644
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


