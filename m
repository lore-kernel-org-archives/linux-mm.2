Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A266D106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D7FA6B0123; Thu, 26 Mar 2026 05:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A226B0125; Thu, 26 Mar 2026 05:57:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB9556B0126; Thu, 26 Mar 2026 05:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB2326B0123
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:57:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0A6C160C72
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:57:03 +0000 (UTC)
X-FDA: 84587760726.07.DD72863
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 492AD1C0006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:57:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YmcjOrSP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sO0Chhzi;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YmcjOrSP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sO0Chhzi;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774519021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BnFp6fRjMsNYweIm8BSLYVMSE5XI4m1fbc7vtBPME0o=;
	b=yhIaQHUfTWNav/MWd7GtOn8F82puK4V9Yx1l9BrPIwyhXWtFF3e6QHVALYNy+l6zpP5VPf
	rJsfpXYGkDu+VVS2g8NEecBVk5AxKfsnagDrG9AhPcIhNOleFX9i8CVsQ0sE0Q8UC1CAHQ
	yd74CaCNx9CWSMeFX2qNAsjwMGdtZ3Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YmcjOrSP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sO0Chhzi;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YmcjOrSP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sO0Chhzi;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774519021; a=rsa-sha256;
	cv=none;
	b=RGo0KxXKGfQ6lk474LBGwY1n/HO6ZRM4xBz3dOAAiXHW/7tWCHe08HLL1F/cOobCSvMYEs
	OGPeqRuLt4odIf7fl1ymO41C3RAMKLjzrLmD0uzqOVK8Qeon84CzZZW6tQtC8Bnv6DI7W+
	g6dnoMnzfczN6byYozs8/9R54HeZfso=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A1EFD5BDC9;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BnFp6fRjMsNYweIm8BSLYVMSE5XI4m1fbc7vtBPME0o=;
	b=YmcjOrSPxqzOvwbWDIs+Dv+H8ZUWLCrnoyIqWMS9lKmPSI73nJW/5dhIQohWmtryQpuLBA
	kxTTP1SjEh4fLCU5r5jy95Fc2tQiBkd9zrla8qGQnCxabDCC8CvnnoirWgx286iG/NOPMa
	zThjFYSCXKw9kJ/pKzYipG6lRHi7E+k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BnFp6fRjMsNYweIm8BSLYVMSE5XI4m1fbc7vtBPME0o=;
	b=sO0Chhzi+iWLjP/4ewJVSq/bmeuss1RPPw1eaL/BbucXY9oSVzQGHIEysgnvaOfv7zIufO
	nzvBzQYVFxulTsAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BnFp6fRjMsNYweIm8BSLYVMSE5XI4m1fbc7vtBPME0o=;
	b=YmcjOrSPxqzOvwbWDIs+Dv+H8ZUWLCrnoyIqWMS9lKmPSI73nJW/5dhIQohWmtryQpuLBA
	kxTTP1SjEh4fLCU5r5jy95Fc2tQiBkd9zrla8qGQnCxabDCC8CvnnoirWgx286iG/NOPMa
	zThjFYSCXKw9kJ/pKzYipG6lRHi7E+k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BnFp6fRjMsNYweIm8BSLYVMSE5XI4m1fbc7vtBPME0o=;
	b=sO0Chhzi+iWLjP/4ewJVSq/bmeuss1RPPw1eaL/BbucXY9oSVzQGHIEysgnvaOfv7zIufO
	nzvBzQYVFxulTsAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 965754A0A6;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U4izJHUCxWn+YAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C518DA0C7C; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 37/42] fat: Track metadata bhs in fs-private inode part
Date: Thu, 26 Mar 2026 10:54:31 +0100
Message-ID: <20260326095354.16340-79-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8925; i=jack@suse.cz; h=from:subject; bh=z7dxkAezePiNXAc4aZS1jzema0K0KhJ1ERZ6rWueUhA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJSE2w1jnzWGYSjvpuLaWDkDX7Uz5tCiqqo6 cURIGB3Xl6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCUgAKCRCcnaoHP2RA 2f1XCACEg697pzAgCUABP8yDwxBDit/7S9+mF/YW/fxQHl59JPPK+BsuDQoymt8CAQLc4vxa+La UL8H+HHu2mdsxrHOJ6Qi/xc5rTMt2OBWL8hsHzp+CWb5uUXidAPw2k/7K4ONhXdqH4HnxP0hQEH 3n16+W9YVMDxGK6Bf3GIlYKYGfhpAHe7M6vOuUeAXXQMzqG8iXJc9Kk4PMcL4FsTY2x6nzVsT/z b7Sp73t4E8LxbM/+tapKfT4yabDRp7Ak7hldk/YDM2E2aHdn/BwCTUNTNwrHDvkKMw+UsoDlnXO cz3nqfbWc50gfDs65YORb0pZYMDp+frkP4xVtOizhXS6h30d
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 492AD1C0006
X-Stat-Signature: ohdhjrb3dihyrzs1dnpa97miktqo3htg
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774519021-998043
X-HE-Meta: U2FsdGVkX191d9A4WRPw8IYJpLUMWHL9GSRAdFeG+M6OQXcnSVN1u6ORORifd/JF4DrqIHqmle4u9UFmBpfRTTqY6f+ZfkiCw+7gkoP5aLCDRpNP+ZwW+VUkx/oZXQxuUAmhrikvn6zmrgPfyVRo+N6gqkisF154PO1O2X4RMpqd8+dFoLeMaZ+dseD2phpUc0OkayIyXnxz2D8OjR83WTGYidHFLzZslNZoupgIN5dOlbyv88adsRqCPsG6DG80P1RWXUhIR+E3dx+kXxD4AL8/76VFFD7m5ETuS0lbNNR9Eo34J7npTfMEJIFt93/R19iuUg/GASPqjrJX5mIwRQb9v48Rf+tIass581KHuYGM2OGMUX4aimJACtdZyPh9GkQEGpC5XuVrZYRfRo5l3JKUZwIEoNqdiHsQNwNK8lF/+qs9zG1YSZYl7OSGESvl7VfC5R7B9Jym3mnhf5b1PWN/B2JBbuOHlX2slzzfisKNQwSsNmfxXkKu64Jy7qJLUSHZ0yGczJlEZ3wnNiNwgs+ZcQeMc8uKp46TslnRMfiBlXrmct/XKAcnh9igv+U7XViYm5D47UdDe8fn3Np16iIy81v13EkhDpRXfxsNkOJC4JfV3UYxRpYItvrZjb0xog9U3aeECDdI4MODYHwaf5xctDD6bF2+NcA9hmzIaVV1D1MGDAioflFOAm+0591F8ms7tYgETf1q6msm29/vrg/jK9xt3FJoxO/QpxR4Rot+bHB/+i1hlT6exCpR0ah5khQ9EpauJ44YNq2DTmNAZXqt7SzNJEOk75MBQ2UaDYRVsxqP3sWYdiQKL6+23n2QApC11FhPUSiduxX+SW1A69t5IMTCHPo2dfHdC6K1DSvcKuSYPkN0YMyjfzaXoWAQXhZvZdaTirkFgqXEM8hVBQzYZVzFbfxUVCkTAFlAnIVEaW1zzhsVOVVD82rzgyu1gr4eA2rlV3uwQEchtEf
 icbBc30t
 wBKnEJTapxiepX3EHPJZI1cM5l/a1xnev226IOkc5KikLrVwiHRPIU2TGDQnoj2rs80ZoewaylXbQJovET3a91YOFtAkqN52XVVJyS8OglnPSCU2iQ/ga4JN1g6ZifLAM70+sRyz6p57K5ihbMK/PxVFnouUwoZllgs2sBgaMiWChGimkvPaSKNmWpfAQF4/p2IgJlA3pUtiUzXjQuatF6nqpAwIxCUUSZi16hGKW4ByZhyuWQDfTI57W5JQkvkRMsCCdejuIt4CaM5uKnx1uRt5xClCX5E4vj4r5hU8XgxgrnP44VE+wnj8gFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track metadata bhs for an inode in fs-private part of the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fat/dir.c         | 17 ++++++++++-------
 fs/fat/fat.h         |  1 +
 fs/fat/fatent.c      | 15 ++++++++++-----
 fs/fat/file.c        |  8 +++++---
 fs/fat/inode.c       |  5 +++--
 fs/fat/namei_msdos.c |  6 ++++--
 fs/fat/namei_vfat.c  |  2 +-
 7 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 4b8b25f688e4..4f6f42f33613 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1027,7 +1027,7 @@ static int __fat_remove_entries(struct inode *dir, loff_t pos, int nr_slots)
 			de++;
 			nr_slots--;
 		}
-		mark_buffer_dirty_inode(bh, dir);
+		mmb_mark_buffer_dirty(bh, &MSDOS_I(dir)->i_metadata_bhs);
 		if (IS_DIRSYNC(dir))
 			err = sync_dirty_buffer(bh);
 		brelse(bh);
@@ -1062,7 +1062,7 @@ int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo)
 		de--;
 		nr_slots--;
 	}
-	mark_buffer_dirty_inode(bh, dir);
+	mmb_mark_buffer_dirty(bh, &MSDOS_I(dir)->i_metadata_bhs);
 	if (IS_DIRSYNC(dir))
 		err = sync_dirty_buffer(bh);
 	brelse(bh);
@@ -1114,7 +1114,7 @@ static int fat_zeroed_cluster(struct inode *dir, sector_t blknr, int nr_used,
 		memset(bhs[n]->b_data, 0, sb->s_blocksize);
 		set_buffer_uptodate(bhs[n]);
 		unlock_buffer(bhs[n]);
-		mark_buffer_dirty_inode(bhs[n], dir);
+		mmb_mark_buffer_dirty(bhs[n], &MSDOS_I(dir)->i_metadata_bhs);
 
 		n++;
 		blknr++;
@@ -1195,7 +1195,7 @@ int fat_alloc_new_dir(struct inode *dir, struct timespec64 *ts)
 	memset(de + 2, 0, sb->s_blocksize - 2 * sizeof(*de));
 	set_buffer_uptodate(bhs[0]);
 	unlock_buffer(bhs[0]);
-	mark_buffer_dirty_inode(bhs[0], dir);
+	mmb_mark_buffer_dirty(bhs[0], &MSDOS_I(dir)->i_metadata_bhs);
 
 	err = fat_zeroed_cluster(dir, blknr, 1, bhs, MAX_BUF_PER_PAGE);
 	if (err)
@@ -1257,7 +1257,8 @@ static int fat_add_new_entries(struct inode *dir, void *slots, int nr_slots,
 			memcpy(bhs[n]->b_data, slots, copy);
 			set_buffer_uptodate(bhs[n]);
 			unlock_buffer(bhs[n]);
-			mark_buffer_dirty_inode(bhs[n], dir);
+			mmb_mark_buffer_dirty(bhs[n],
+					      &MSDOS_I(dir)->i_metadata_bhs);
 			slots += copy;
 			size -= copy;
 			if (!size)
@@ -1358,7 +1359,8 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 		for (i = 0; i < long_bhs; i++) {
 			int copy = umin(sb->s_blocksize - offset, size);
 			memcpy(bhs[i]->b_data + offset, slots, copy);
-			mark_buffer_dirty_inode(bhs[i], dir);
+			mmb_mark_buffer_dirty(bhs[i],
+					      &MSDOS_I(dir)->i_metadata_bhs);
 			offset = 0;
 			slots += copy;
 			size -= copy;
@@ -1369,7 +1371,8 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 			/* Fill the short name slot. */
 			int copy = umin(sb->s_blocksize - offset, size);
 			memcpy(bhs[i]->b_data + offset, slots, copy);
-			mark_buffer_dirty_inode(bhs[i], dir);
+			mmb_mark_buffer_dirty(bhs[i],
+					      &MSDOS_I(dir)->i_metadata_bhs);
 			if (IS_DIRSYNC(dir))
 				err = sync_dirty_buffer(bhs[i]);
 		}
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 0d269dba897b..5a58f0bf8ce8 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -130,6 +130,7 @@ struct msdos_inode_info {
 	struct hlist_node i_dir_hash;	/* hash by i_logstart */
 	struct rw_semaphore truncate_lock; /* protect bmap against truncate */
 	struct timespec64 i_crtime;	/* File creation (birth) time */
+	struct mapping_metadata_bhs i_metadata_bhs;
 	struct inode vfs_inode;
 };
 
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index a7061c2ad8e4..f0801d99dd62 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -170,9 +170,11 @@ static void fat12_ent_put(struct fat_entry *fatent, int new)
 	}
 	spin_unlock(&fat12_entry_lock);
 
-	mark_buffer_dirty_inode(fatent->bhs[0], fatent->fat_inode);
+	mmb_mark_buffer_dirty(fatent->bhs[0],
+			      &MSDOS_I(fatent->fat_inode)->i_metadata_bhs);
 	if (fatent->nr_bhs == 2)
-		mark_buffer_dirty_inode(fatent->bhs[1], fatent->fat_inode);
+		mmb_mark_buffer_dirty(fatent->bhs[1],
+				&MSDOS_I(fatent->fat_inode)->i_metadata_bhs);
 }
 
 static void fat16_ent_put(struct fat_entry *fatent, int new)
@@ -181,7 +183,8 @@ static void fat16_ent_put(struct fat_entry *fatent, int new)
 		new = EOF_FAT16;
 
 	*fatent->u.ent16_p = cpu_to_le16(new);
-	mark_buffer_dirty_inode(fatent->bhs[0], fatent->fat_inode);
+	mmb_mark_buffer_dirty(fatent->bhs[0],
+			      &MSDOS_I(fatent->fat_inode)->i_metadata_bhs);
 }
 
 static void fat32_ent_put(struct fat_entry *fatent, int new)
@@ -189,7 +192,8 @@ static void fat32_ent_put(struct fat_entry *fatent, int new)
 	WARN_ON(new & 0xf0000000);
 	new |= le32_to_cpu(*fatent->u.ent32_p) & ~0x0fffffff;
 	*fatent->u.ent32_p = cpu_to_le32(new);
-	mark_buffer_dirty_inode(fatent->bhs[0], fatent->fat_inode);
+	mmb_mark_buffer_dirty(fatent->bhs[0],
+			      &MSDOS_I(fatent->fat_inode)->i_metadata_bhs);
 }
 
 static int fat12_ent_next(struct fat_entry *fatent)
@@ -395,7 +399,8 @@ static int fat_mirror_bhs(struct super_block *sb, struct buffer_head **bhs,
 			memcpy(c_bh->b_data, bhs[n]->b_data, sb->s_blocksize);
 			set_buffer_uptodate(c_bh);
 			unlock_buffer(c_bh);
-			mark_buffer_dirty_inode(c_bh, sbi->fat_inode);
+			mmb_mark_buffer_dirty(c_bh,
+				&MSDOS_I(sbi->fat_inode)->i_metadata_bhs);
 			if (sb->s_flags & SB_SYNCHRONOUS)
 				err = sync_dirty_buffer(c_bh);
 			brelse(c_bh);
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 1551065a7964..becccdd2e501 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -186,13 +186,15 @@ static int fat_file_release(struct inode *inode, struct file *filp)
 int fat_file_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = filp->f_mapping->host;
+	struct inode *fat_inode = MSDOS_SB(inode->i_sb)->fat_inode;
 	int err;
 
-	err = generic_buffers_fsync_noflush(filp, start, end, datasync);
+	err = mmb_fsync_noflush(filp, &MSDOS_I(inode)->i_metadata_bhs,
+				start, end, datasync);
 	if (err)
 		return err;
 
-	err = sync_mapping_buffers(MSDOS_SB(inode->i_sb)->fat_inode->i_mapping);
+	err = mmb_sync(&MSDOS_I(fat_inode)->i_metadata_bhs);
 	if (err)
 		return err;
 
@@ -236,7 +238,7 @@ static int fat_cont_expand(struct inode *inode, loff_t size)
 		 */
 		err = filemap_fdatawrite_range(mapping, start,
 					       start + count - 1);
-		err2 = sync_mapping_buffers(mapping);
+		err2 = mmb_sync(&MSDOS_I(inode)->i_metadata_bhs);
 		if (!err)
 			err = err2;
 		err2 = write_inode_now(inode, 1);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index ce88602b0d57..28f78df086ef 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -658,11 +658,11 @@ static void fat_evict_inode(struct inode *inode)
 		inode->i_size = 0;
 		fat_truncate_blocks(inode, 0);
 	} else {
-		sync_mapping_buffers(inode->i_mapping);
+		mmb_sync(&MSDOS_I(inode)->i_metadata_bhs);
 		fat_free_eofblocks(inode);
 	}
 
-	invalidate_inode_buffers(inode);
+	mmb_invalidate(&MSDOS_I(inode)->i_metadata_bhs);
 	clear_inode(inode);
 	fat_cache_inval_inode(inode);
 	fat_detach(inode);
@@ -763,6 +763,7 @@ static struct inode *fat_alloc_inode(struct super_block *sb)
 	ei->i_pos = 0;
 	ei->i_crtime.tv_sec = 0;
 	ei->i_crtime.tv_nsec = 0;
+	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
 
 	return &ei->vfs_inode;
 }
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index 048c103b506a..4cc65f330fb7 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -527,7 +527,8 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 
 	if (update_dotdot) {
 		fat_set_start(dotdot_de, MSDOS_I(new_dir)->i_logstart);
-		mark_buffer_dirty_inode(dotdot_bh, old_inode);
+		mmb_mark_buffer_dirty(dotdot_bh,
+				      &MSDOS_I(old_inode)->i_metadata_bhs);
 		if (IS_DIRSYNC(new_dir)) {
 			err = sync_dirty_buffer(dotdot_bh);
 			if (err)
@@ -566,7 +567,8 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 
 	if (update_dotdot) {
 		fat_set_start(dotdot_de, MSDOS_I(old_dir)->i_logstart);
-		mark_buffer_dirty_inode(dotdot_bh, old_inode);
+		mmb_mark_buffer_dirty(dotdot_bh,
+				      &MSDOS_I(old_inode)->i_metadata_bhs);
 		corrupt |= sync_dirty_buffer(dotdot_bh);
 	}
 error_inode:
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 87dcdd86272b..918b3756674c 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -915,7 +915,7 @@ static int vfat_update_dotdot_de(struct inode *dir, struct inode *inode,
 				 struct msdos_dir_entry *dotdot_de)
 {
 	fat_set_start(dotdot_de, MSDOS_I(dir)->i_logstart);
-	mark_buffer_dirty_inode(dotdot_bh, inode);
+	mmb_mark_buffer_dirty(dotdot_bh, &MSDOS_I(inode)->i_metadata_bhs);
 	if (IS_DIRSYNC(dir))
 		return sync_dirty_buffer(dotdot_bh);
 	return 0;
-- 
2.51.0


