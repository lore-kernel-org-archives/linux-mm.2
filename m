Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7827FEC1423
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:36:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27F356B0131; Tue,  3 Mar 2026 05:36:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D531C6B0133; Tue,  3 Mar 2026 05:36:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7776B0134; Tue,  3 Mar 2026 05:36:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7442E6B0130
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:36:06 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 40E571C35F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:36:06 +0000 (UTC)
X-FDA: 84504396732.19.F7153D3
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0350F14000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:36:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=27UM7qcFczVW1jLCZWEcgRp8gADddSOONt73sPr9cW0=;
	b=zq6EvJ9ImBsWgOywLBAP8ypBdFsJmdVvYze/lenF1FYXGOdWpI/7zjipic/kgZvZVjyOZf
	kHUSoTc0xQnx5Fg+nOTk0cxp65vnwqGi88NWJ/+lxiSthoy1P1aJ3MaVSIT2sCVziv+VLE
	UWB8dc51xcLmOX3x8TsdOJq6QVRXC/g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534164; a=rsa-sha256;
	cv=none;
	b=T/OntnrZNFPFnYaVBBR2mJ/4du8eyUPShVP7cTyVEis+fPe3OspDjRGi8iw9LtDxkIYwVM
	r68yvfrTPhvm89FFqvQQS0KMIsJkiCKI0pKqHaMwmMEMS38BrSBgcBJnVUhzz0z0EHFP3P
	pczTeGUHFq3ZZXTnDpaLvQMbWSQSII4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7B47A5BE33;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6EC693EA6C;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nHwKG0W5pmmfFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 463E1A0B7F; Tue,  3 Mar 2026 11:34:41 +0100 (CET)
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
Subject: [PATCH 30/32] vfs: Drop mapping_metadata_bhs from address space
Date: Tue,  3 Mar 2026 11:34:19 +0100
Message-ID: <20260303103406.4355-62-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2964; i=jack@suse.cz; h=from:subject; bh=t1ZJ98uKW/mjTlAtf9li2hXoonFOHXZVBOd5Czf0muc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprk32Wxql2wtTkldVHgQyouf3CalCsOswKYUJ sSpBtaI5ZGJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5NwAKCRCcnaoHP2RA 2SkZCADLjRuMocQoKB6Huvda5j98SKmeWKpdEXSnbq26Ng0XEuFXFEkxnuwzhg3/zoIHhmJ4hc6 V2x3XgNJZSxtORfX7CMU9xit+xaKCRcpNW9XK+JYjmdSi1y+fpqzHqbceOtPnNoQ9mzDrwKvdlL ve8qnUNotEyH3DKsaPJZrUlEzq3PhCKJT7eyQysuSqgketXfzetTdLN/njPfReA9nq313q4VcY1 fu8RNYPFC3XPNFCxJ4zzXqLgd1zNmR0LYEx+DY0QIx2tVT1cXHujtkjbfRUTxHLUcv762X7+ynw CGVtg9VV4BMqYPOi2NyaIcF1JYncPuqXu1OiAsCjU8N9DXpc
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 0350F14000B
X-Stat-Signature: 8xa1u79zu6gorh5f6s7kcnt1m1jymppg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772534163-753392
X-HE-Meta: U2FsdGVkX1/5Vmesy/uRu9V6TxpULlTCkb60Uu2CXNLFxsXtYXKw+1W62PPKJkHL4gnJO+YGSgvBfotFagG60s35Atu5IMbahXEvsXCFoRvE+CuUB/5+HyYhqbdXMo0/+01CRGEt2SMaAGG2n5ZvN00wRa+hneNUSX7BDD809zLNWZoB8x9ugCvs3iEb/zol1USWc1PFcQozzbSIbMaN9jmeyDjG2thUIXtGFWFX87D8T5pPipzC9oQm+Kc4hvM6yL+p7I9XCTjX9HbPDiIPNpqj70QF//lxaeZ9an/bhr5fM0kj5GjwDYS0uomqXhbGpFXlKWqbyOh+ol0WCLzs8eywCH2MleY5tb4+nmqbzDqWPuQqK9vdVlqEn9h+Hh70jorVECBldsnV2daUdRPE87r9nx2jrIINgN/MAxb/AaQQtlWJGBuxnTedQAdEi+CpHW70lLmuXS2m3s6fIHlyRz9iTR6e0zvUVqUunzkmRH0FPzXgzfy6lG7Zlr8j65hVAL1/SdE2pj08D2L4GuxKkPgUgPNLSp8N1e4rPYRL38icA62uMKj2O3arfas7PVqpSpWkjzPDXRNOhugeYO23CwXXuWWQKU5Z+KZ1YsdvRxDtC/8ELsOgA7h2s8AKtMRFLLr7o8FWuQxanHIstDa+pxF9pIX3wpTeNmW4PszWVen+YRZAT+XlWEj3f2By0XbLybHT5lwsaiTP8U0Jd/wz3YoqQCt4J+jd+ZmpQuELpihRCltR66PFlSVxNTx28VDwKNsGjPmaW/pi/WBGuFcJ+rewIzT+0az9YYz1wyeC2xMLyutTgubVC/DkQvuLPvYAeQNQKvbfqb/2/nu4PYmGXg0sdR3RA5SogGFf758ewAO2ts9+6Ekcps16FFoIE92YeezCzY3/3iZaI+XFlrPNFmUvY1NXtuHnYDY4H4t1dHTKC33NPF4J7nGYvCDNWJMD1gyWcRRAoIW5Mu/GI4F
 wax720AN
 vQtRPJoO+jgHBAcMpbeXtkFexpnsI70OtOjZcsS7trzrfH6tSm7VOqw1CVKzvcK8Ill0ucbjSxqrdauftSroQGil57nT0kz3ScDVaF2H4uFhnam+9Xzuwna0GfcOBX9Yu2hcb7PmuyHDxAYjZLhiPnuMJtlHeJJTFbFbq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nobody uses mapping_metadata_bhs in struct address_space anymore. Just
remove it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c        | 16 ++++++++++------
 fs/inode.c         |  2 --
 include/linux/fs.h |  1 -
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 096a8d9e3280..02176e0acfe1 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -501,9 +501,13 @@ EXPORT_SYMBOL(mmb_init);
 
 static struct mapping_metadata_bhs *inode_get_metadata_bhs(struct inode *inode)
 {
+	/*
+	 * We can get called for various half-initialized or bad inodes so
+	 * verify .get_metadata_bhs callback exists.
+	 */
 	if (inode->i_op->get_metadata_bhs)
 		return inode->i_op->get_metadata_bhs(inode);
-	return &inode->i_mapping->i_metadata_bhs;
+	return NULL;
 }
 
 static void __remove_assoc_queue(struct mapping_metadata_bhs *mmb,
@@ -544,7 +548,7 @@ static void remove_assoc_queue(struct buffer_head *bh)
 
 bool mmb_has_buffers(struct mapping_metadata_bhs *mmb)
 {
-	return !list_empty(&mmb->list);
+	return mmb && !list_empty(&mmb->list);
 }
 EXPORT_SYMBOL_GPL(mmb_has_buffers);
 
@@ -552,10 +556,10 @@ EXPORT_SYMBOL_GPL(mmb_has_buffers);
  * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
  * @mapping: the mapping which wants those buffers written
  *
- * Starts I/O against the buffers at mapping->i_metadata_bhs and waits upon
- * that I/O. Basically, this is a convenience function for fsync().  @mapping
- * is a file or directory which needs those buffers to be written for a
- * successful fsync().
+ * Starts I/O against the buffers tracked in mapping_metadata_bhs for the
+ * mapping and waits upon that I/O. Basically, this is a convenience function
+ * for fsync().  @mapping is a file or directory which needs those buffers to
+ * be written for a successful fsync().
  *
  * We have conflicting pressures: we want to make sure that all
  * initially dirty buffers get waited on, but that any subsequently
diff --git a/fs/inode.c b/fs/inode.c
index 393f586d050a..d5774e627a9c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -483,8 +483,6 @@ static void __address_space_init_once(struct address_space *mapping)
 	init_rwsem(&mapping->i_mmap_rwsem);
 	INIT_LIST_HEAD(&mapping->i_private_list);
 	spin_lock_init(&mapping->i_private_lock);
-	spin_lock_init(&mapping->i_metadata_bhs.lock);
-	INIT_LIST_HEAD(&mapping->i_metadata_bhs.list);
 	mapping->i_mmap = RB_ROOT_CACHED;
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b4d9be1fefa4..1611d8ce4b66 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -490,7 +490,6 @@ struct address_space {
 	errseq_t		wb_err;
 	spinlock_t		i_private_lock;
 	struct list_head	i_private_list;
-	struct mapping_metadata_bhs i_metadata_bhs;
 	struct rw_semaphore	i_mmap_rwsem;
 } __attribute__((aligned(sizeof(long)))) __randomize_layout;
 	/*
-- 
2.51.0


