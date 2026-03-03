Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA2C2EC1427
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D298F6B0107; Tue,  3 Mar 2026 05:35:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB64E6B0106; Tue,  3 Mar 2026 05:35:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B63D86B0108; Tue,  3 Mar 2026 05:35:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E7296B0107
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:35:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6019D13AC5E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:16 +0000 (UTC)
X-FDA: 84504394632.12.B802F77
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 18C8210000D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nrTgdRDZY7w6M/u85YX9hxAeGXT4iZmtaDipM5rnVgo=;
	b=WbWduShUwz2jYdgqyW7KYcmIf6wk4rhlX2ptrzAzvPFVUw/+nGh/ndqHBkIRww5h8J4FUF
	KeTPwUC+iPt/4Pn45TWoLkicv/easwPcIvMWgrXLu8TRXycZU4o6XSFx0ZoSMwjDat0m+N
	HMF70QTsIV0XulKsiUQ9u/tpIz4hsNo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534114; a=rsa-sha256;
	cv=none;
	b=e4s3LmHMKTDcBIZ2X1FwoFj4YHPdEGQ/VdcnPiZFJfYZ0BFwW+ukBHJUHNKr+JUi/vIbg4
	hKtih0RxwUI41KMHA7DNz1ebVDJXrvEGH3IoOESkVZQ2rgh2D83ZnYJQCCoWvU9qqCZMMb
	C0hSJAnrvUmokTn7785v9ld+iUjHUbI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 18AEC5BE21;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0612E3EA72;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /Zx0AUW5pml1FQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B7201A0AAA; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
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
Subject: [PATCH 14/32] fs: Remove i_private_data
Date: Tue,  3 Mar 2026 11:34:03 +0100
Message-ID: <20260303103406.4355-46-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1510; i=jack@suse.cz; h=from:subject; bh=p58QfOPdeBSF+GFT64AjIbjHzbd4gdcT7JjSAJNis4Y=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGDKX7dT065ga7rhq2VKrJX7nHe39/7zbtUahecZ7L+W2+ WeEtZOfdjIaszAwcjDIiimyrI68qH1tnlHX1lANGZhBrEwgUxi4OAVgIl5rOBg+2HvtSMtctuXI 5Y+JO5YV6J9vLV94yWqe7WObnA079NPfdna0eK+VOBstVSebEBa0WXabZKAGd6XCaeNK+Wifm/e d0sVlPzhnK1wzvbwl9Ul30QuGjxYJX3a/OXHQfckZs0OG/2aucGdtO3rOJeVI19b57uddrkgeqG +ubdZpFhb00zO+LButkJi9Q/PJHU2NsMlW+79HGqSssQq8KBmg8fkTa6rcnRRZ4UJHpizfGZ71w Stl5CQ2Srx2P3Te+Ukye0x9nnht1I6PLk4Bx26wvHh1tSiYa26i5bv6J5bfVO7whVlGbK6SbP1S +Ytne1aLzPKMZw7WbmF5va5BB7jVnxhMTlm+5uEOx+/JAA==
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 18C8210000D
X-Stat-Signature: 4n91is3x7cauefwbdtijranbg4k4j33k
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772534113-930025
X-HE-Meta: U2FsdGVkX1/lh1pB+QSgSGozRjcBElVWljLi//4wpWZ1C2YPBSLw+uOw9g639hcjEOrKkgOxAJGCSAn9+4i6a9zfpU2efkDm/LDvtAxN13Ryri1Pp8ZnODFOh2i5e3fKM8nptG3RYSP6MQT0dHJjLTf+VDng1FE0wmIGYs2WAbCxTdXwjJ5G3/ZAR1O/nyeYS0XKtkQIZnS68KhRoijnkq8dATDfKeusNRMs01B23X+8hboPlAG58TLUIUrNIXq2IarAZS1q2ewH0uutgZ5F+hLYHV0Ye167tTTu4QjOYDKGbha+t8CeVGSxXHCwws9O570dsYkHJksidKUQw+1JufZtwtkG7yV+i3nclZGzsT0oSGvHS4RffGMkgdoAYl6XrTtyz9Gbbn3/lrmuK02reR69yesG10zqgmmeGtVHMb1mVEJWL5r45INH+g8RFo3xdC3m2ZBxn+xIWLv9Zp295asSP6n43jk1MCBBYKw/k2NXVuj3tAk/L+cutLrMoKU9elIw5QxLJA5d6W8EATUyklvDR40ARGDqFibd8j11RzRzJgsjcJBN7wjTNxHu0K+JGDnVyHRjTnW5H0vohlE6dlJjCqP5nCXr1opfKeDQl7RFZjmGS5OlPlzZZ8atiSzxktPm2fGhZZGivm7OsjlEAbHd8hrT2yfsI9TTcs4pN24ZEsFwk/tGAFc5yOHQCSrBLpsFSc9K9yA4NJpvMcJv7TkpHDTfztZyoQDo+ujlx06xhVbLwwhy1f53p16+4/z+//Nfkkw3fqMk5+B3pEiGIEdRgwx35Q/oPkLjkeqGtOPIfEhCCCQX5s7emueUwof5opqDW/abvjzxS0fvtkSTjPe8FqJeUHzyJxhvwvkozczz2yRibQC596XOcZIogPZUtFMPEh5KnwRte+Yrxs0hz9wMtE719PohK37b6PnW1VbP88vRnHkaYK/5q3mEB4Z3FXdROxwFk+A1ufv2E4x
 MXafhxNf
 Nl732Jz+x2TQ+/Rh62vDVSWufyqapjy9Bhu0cwnMFCofDMGSkLEVCet9YfcRplqIHEezK2EqztxprraqCwpCjxbj/qL+awm5gJVkkdurJXNmc7UqZ//NSmy/UmIz4CsSVWfjWqVZG4qADIUvGQWwwtVSKn1JKlDx/teVJTSJPMPawFZhhY+/jbzQbJ6zKA35p0NB2
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


