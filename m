Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D4941098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:41:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDF906B0096; Fri, 20 Mar 2026 09:41:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90826B009B; Fri, 20 Mar 2026 09:41:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B57AE6B0099; Fri, 20 Mar 2026 09:41:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 89C9A6B0093
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:41:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5730C89944
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:41:55 +0000 (UTC)
X-FDA: 84566554590.06.74E9964
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id EF9D34000D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:41:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u8Anhbfu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=S8cu8Tep;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qLbxD02dHUb8m8m5bbUbo7PwrJ0F2rU6l0JoHr7uT18=;
	b=ocPiaoee769KlbV0jmaJShidWBc34AublaZvo6lpNObbmvCO4L/1hwEbgT6W3P1Zky0SJ/
	uy+Q7xDw6mcW87jiEN5RlkKWuJrE7l3F6xeG7TytlycEfwoiXpi6Upawam7NGIXDJDWHzh
	82yVMH+TPEylXncPMemxTWg0yr883CU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u8Anhbfu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=S8cu8Tep;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014113; a=rsa-sha256;
	cv=none;
	b=atZWTjW0qLivnU2x7LE0rsnSP20paWq9vxTT+tamt2iTEfh7g2lvQI8Dk5BlIzuKt0lDOn
	8vEdD9Q1VSJz4ynEzMmqPKMU+pLxSTzUfnomXKG9UP1QIj+UaB8CnvdkM9f04/nmJgzx6R
	qu2tfhsEmVeV8VPw3ZB4Jqnl388OoUM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B5E785BDE9;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qLbxD02dHUb8m8m5bbUbo7PwrJ0F2rU6l0JoHr7uT18=;
	b=u8AnhbfuzqLhVKau9qx+8eDNwvrQ5rSY9piTMxDabUPxvJEFQCU9AeoET2gcn3zvwppID8
	1GVr80UzG2Fi01pAEJOls/aESvXCFBjGywPBf7auv4IcaqSoariGExH42WEqA3qmJ2UvJx
	mMBEtqUpfsgk2PANvpWXy95LJRe81Ec=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qLbxD02dHUb8m8m5bbUbo7PwrJ0F2rU6l0JoHr7uT18=;
	b=S8cu8TepoEIGSxlC3bSUpW7KejMTQ8/JVe2pkdbGhxnLOoVBnRrcXOrA5LKLs1nFggvzgl
	OzL1KD3hac/ZChDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A061D42817;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Bce0JphOvWk6CQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 57CFDA0870; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 01/41] ext4: Use inode_has_buffers()
Date: Fri, 20 Mar 2026 14:40:56 +0100
Message-ID: <20260320134100.20731-42-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1573; i=jack@suse.cz; h=from:subject; bh=7NK1Luw5u3sFPoI2MABzxVh/UFbS1BdfliomKZSEhSc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5s322tQJD1bTpLOCCusW8JNc9TXDdWifJtU FNx1ADgBgGJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1ObAAKCRCcnaoHP2RA 2ey1CADnac5lZB92Hc+MkO/O63gQ3LLWF64hM0CuCoQ05PeJDa6i0EfB5/MxacHwpKXdbtInvlA pVu26IKbkiGo5XfbiJiwqeCZ/jQOfc9AVSg8fg7SqT7F5nbHLZQ6z+kswDT19yUgNAbo7G8M45O mSJaSSZlsuV54S+X7mO2AcbSr9mmcjYII2cSWsqda1VNIh+FhuLCi07vMvert7l4MEF9Rw6RAMD dZj7mNpUFO5WLgKK0YERld197olJGf8tublm3EHaCGDudFEUJ2kyPEZ27VJI86AqYmv4wn1fq3M dHepXVrH7uLnwaAVvqsSBQEiE07BPYUfHj6SvHZ4KKbqu6ok
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EF9D34000D
X-Stat-Signature: bbr4wuwezkcnon3xwxgh66djub98aq6y
X-Rspam-User: 
X-HE-Tag: 1774014112-319215
X-HE-Meta: U2FsdGVkX1+0fVLqyDXEpXR5wByYuSKMu+73/E55z65J/QrA2U1Rs3qHP0RvIKpIuF2B1tCn6KCWMq8xji3NMjIuvBSO64W3dBxvV6s9/t/YUXo0eGlrCbNe8e1LY9YHlpIhD9yPhLvhn999tumjAF59PfN5Bxcq0i9s5huty3IbM1WOdWAvUVCJLX7xzkAZAP80qKrl6dXKhZlAfyT+d2DNeiNJSSRefXQjtVDFRFcttbXm4oNnLD4D5N+IIy1+ZzFMlq894xrVDCfr1n79Nkaz2hNH8ZXJevk8vM9VPSxBTGKihk6PaG4jak8TeV5Oaw3xqDxdX64UZY/+OODzWXxoPKassIfOC0kCh/2VN6fXHewbLtS7ydhjDYgGZ7HuI8p6JdVcpXDpmyCtIAlA3ukDY8ZcS8Af3QC1FggS8CTDgJ6Lz8FWom1I5zfVcQDWQ7nBzVbs0Pjmn0BLJVLTgrRl6K9OIc5C3lvWFpyAi8zOWpP30wKkWut7Ty4s5Z6ck75p8IcLmgTQs88ZUMpQSTypAxPL2EQ4p+1VkkbP5XWVP89E2X9dqbPM/LyOhWzY+PJyFQxaX3OtvCrft+uflkps0CsUlLx2OX5YSXHiq34tJ+9/qsGLmuEsBz14zEHSHRTKq8XV2xJHK6Q6ugaOeTH6p2CUH9qtttAdv7ivg+p63u2n5w+qaFZ2XqKwdsPMkH+Mus4LHhWxbI0Jyb/WCnDmLPYrVtmX7oygzvbk0fV5IQx/1qlA3pgnuFxBtH9k0ertiiiEds51LwjvSPFp+mhiRYPq6S8VcFpHAMea+OJ3caaPSh4KKTz59zl7QskBESQVIrJBubaLTLCGYQLPi5auVk2IY2xbfACr7KVO0nR2K4g99vbJHUnrUbzy7WV5x2AL/2Wxxtdlo2gtZneVBCV9tmHvY9k/vp++H7xiyP7vc8Oljs1Ol6Bkl3fQUfXX2FNa+E6Ow7Qii5oeFh+
 Z9CtL5L9
 rHMifwYfS9zp1IhxqgekW9LX0IBBoYgupNAZu7LvpU77gG4D9eFBbyPggqkC1iAJhHcCFdxQDEg9msnQFGqlGEi203dGwg/Q7BtKgFy1fkvD/XNc96QMi4WIKcA9NnwaSNeH/CHrk5iD32aA7rAqoOeoTFxewYv5k35U/qjGO/lDsjmGIdlGEE84KVEo5kR/TljB1CP8tlyIvnt/dzkjIsTlkjjBnuV6T2g5LwMHmKvNJ11uWm9A7eAUxCi+odMWTJ5lqB9FJAVF9ljgTY3UQxsyyYhw4PU+gaTS8D4UhW6M52st7f1fNumyRGv5mH1CAqlarZMMCijmRs3ALPSOisTuToaqkEsS+tsTK34QIRS1Qd5s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of checking i_private_list directly use appropriate wrapper
inode_has_buffers(). Also delete stale comment.

Acked-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c     | 1 +
 fs/ext4/inode.c | 5 +----
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 22b43642ba57..1bc0f22f3cc2 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -524,6 +524,7 @@ int inode_has_buffers(struct inode *inode)
 {
 	return !list_empty(&inode->i_data.i_private_list);
 }
+EXPORT_SYMBOL_GPL(inode_has_buffers);
 
 /*
  * osync is designed to support O_SYNC io.  It waits synchronously for
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 396dc3a5d16b..d18d94acddcc 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1420,9 +1420,6 @@ static int write_end_fn(handle_t *handle, struct inode *inode,
 /*
  * We need to pick up the new inode size which generic_commit_write gave us
  * `iocb` can be NULL - eg, when called from page_symlink().
- *
- * ext4 never places buffers on inode->i_mapping->i_private_list.  metadata
- * buffers are managed internally.
  */
 static int ext4_write_end(const struct kiocb *iocb,
 			  struct address_space *mapping,
@@ -3437,7 +3434,7 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
 	}
 
 	/* Any metadata buffers to write? */
-	if (!list_empty(&inode->i_mapping->i_private_list))
+	if (inode_has_buffers(inode))
 		return true;
 	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
 }
-- 
2.51.0


