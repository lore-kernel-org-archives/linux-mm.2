Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC363106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9A1B6B00BE; Thu, 26 Mar 2026 05:55:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4C036B00C0; Thu, 26 Mar 2026 05:55:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 960EC6B00C1; Thu, 26 Mar 2026 05:55:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 870FD6B00BE
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:55:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 506871A0C7A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:50 +0000 (UTC)
X-FDA: 84587757660.15.AE1FFB9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id E03A44000C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x2I30ShS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/oTi4QXc";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x2I30ShS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/oTi4QXc";
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518948; a=rsa-sha256;
	cv=none;
	b=vLifNmlPX6yvmKr0DHDid8t13sO/Y7dbjoxwv6A9JeCsVZfDmAjrGv5WoNEvsk6UWaizao
	JyLLWQeR1KUenU6Un1gQzVLj5DQQ1+/9FTmd+oUGKUfMx/1GI3pSztgmlDuhNhXrdIA1IZ
	47SB3famr0PtKnEP23Jae1AgCMDPGb0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x2I30ShS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/oTi4QXc";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x2I30ShS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/oTi4QXc";
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xVDg+F2e6CtK7j6uBwAUoX9A/+ujgxFslk6X0y4sj2w=;
	b=ex8+JWFeKesZY1glXwl6bnMur51QZbYr1eZp+Pm0eIIJD+hbF82PButV8f0VdKFypEF6Xo
	Gi2riEvs8HnY7u9tEIQ6qnYs3/kWSfnJ+O4oQ6XHoBMexyAVnJ6mPg6ojG1VKes08AoFbv
	0ZlGe92wyEkAas0vVVxnxYS82tFOkV4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 55B324D280;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xVDg+F2e6CtK7j6uBwAUoX9A/+ujgxFslk6X0y4sj2w=;
	b=x2I30ShSDytLJbrX5Rthxf2Ef1xf7RQB2asBKGwJ3s8Yas38lhWdis4/h0rS9eHtzdf4nF
	YSHTHVjG+n6H9RpnjO9a9IWzOeBM2DrLhcu6P8QYV5GHNTIbCWpirJ9KrecZKNrAS53qUB
	s7uSRelIt3fQ6xxAzgPTmI62geffsc0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xVDg+F2e6CtK7j6uBwAUoX9A/+ujgxFslk6X0y4sj2w=;
	b=/oTi4QXcjRgOIjz/ARfDkC2JilZkH3fHD0zDYH2y3y2UNK06jXHG4uGuSgmWjmV9SCOp7M
	3+40AbSUaqCe7/CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xVDg+F2e6CtK7j6uBwAUoX9A/+ujgxFslk6X0y4sj2w=;
	b=x2I30ShSDytLJbrX5Rthxf2Ef1xf7RQB2asBKGwJ3s8Yas38lhWdis4/h0rS9eHtzdf4nF
	YSHTHVjG+n6H9RpnjO9a9IWzOeBM2DrLhcu6P8QYV5GHNTIbCWpirJ9KrecZKNrAS53qUB
	s7uSRelIt3fQ6xxAzgPTmI62geffsc0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xVDg+F2e6CtK7j6uBwAUoX9A/+ujgxFslk6X0y4sj2w=;
	b=/oTi4QXcjRgOIjz/ARfDkC2JilZkH3fHD0zDYH2y3y2UNK06jXHG4uGuSgmWjmV9SCOp7M
	3+40AbSUaqCe7/CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C4324A0A7;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kDudEnUCxWnXYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 20998A0C64; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 19/42] ext4: Sync and invalidate metadata buffers from ext4_evict_inode()
Date: Thu, 26 Mar 2026 10:54:13 +0100
Message-ID: <20260326095354.16340-61-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1456; i=jack@suse.cz; h=from:subject; bh=owc5m+YmFPFX9G7b4L5yVqAn4sHTNVwb7RYuqrd3Kag=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJC/m40sh9r+/VqeE/EOztc8+Vm8Hwnlm9ew gLKiBy9a+aJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCQgAKCRCcnaoHP2RA 2WW2B/4lP04dwjwRh8h+wXW0V6DiSHJtT7smkcwZkdsBYBj97DGD7y61i60y7su7lR0Sduf1fSu ciGf4LyMDLUmD01BBY7nuRKw28tD7V4jC6z0Cn3nsoAM1p+9jSb0x1HA4BFHypthgMqctUjd8ah mXXPs6peVD/dB6nOG0Bq2HECOh2Qi4vbvOp4qTou9apnqsReuTP1qjkDcF8/Y26e5XriGDQ4VOS R7iwUP70aga39DSmv67KEmERZfc89rRurre1rYuL+euQTTeJQA2fsbBpRsO9Hx5TwZzf0kCQv2R a4lm0ak2rY0bdnlAxFg7DjV1rFgznBWPwjmjHfFmCk4C9u6k
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Stat-Signature: txw9exqpums5cobzdwdctuhokyyqjobr
X-Rspamd-Queue-Id: E03A44000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774518947-514479
X-HE-Meta: U2FsdGVkX19hS6L3h4Knztxz21sWVu88Eig7FYIiS4o/IUzkznBNa30GxlHcHL/0dB+DSKcsdplI385IvByhyl9vO7BCy5Edp18/BZMV0FDxveDEwEfdLWuFKuCBweuhl3CKp9bAA+h5JgafRpr+WQZaL4ySYpGXzpPdtWDPsrEpOhP5iMJ02PIIWtSN2DdUCcKQhdhBUfd5iSz3cjI2p/iPkVjUN7yHCtTT0NNp9BnjgY7qO2uOuN5IRP6J5EPccz2ofY4pAngs6vJ0vy8cdg3rOVND86N5jlGXSnkVc2bz/ZBmnCFhohspA4mdodAOo0rtDIm2djpjUPDf1TgIDNJBU/scms1CVljzxLNPkOQduljGYnTJAhFoQCEACAiAqm+culLskE7QxZ/YmgB+HLPpnXOTlFeONLXYpTHOzDx9HcojxmZBALLXUOwBYZh6MbvsdyLacabG8v5hxU68oQ+srnlAp9lNuQ8e+m+jXXssracFFhcUpDHXj49DdzgCWk6dKSoel6Q4mTmvpk9C6y5VQ/KS+m6JkB7QKmqjNEYQKDJDr6VhixvyHx/ewBXEYmmAl44qAEJfAPLQyATMYFTqsfNchL7VDbwJIGc3JG2K5pSuTEeC8bVXSZzT53hfF9e2Jgv+Bq80wv9laI4CnsICdPGd/P+UorbtEIqw9LGN9qRAVE8DRlbxa7emaQhR9+PTPpVnSSZJfU+TJEqp7LqMGMzSxCl28Re9lHa/v/HBKTVu/9mdVyf6onEwVEzMJpqe1hmx/Z9bTfnfnQ0JPUR1ypDHXsMXRlOG3FRXDV/OJXEe06ND4JZQST9Z/oGa4s4v9nuVjydR67KuH0OlSmivDv/GpUK2ufu024MuKMdiNGe//8KCTjy9aGU1m3Czy3ytuqP82tgIheQMpimPUAs+qQy5d8wac0baPjBfy9MYonUjAUkL0wsEvkLFfWvTCbzvacoScw+aH2fh3pE
 ctsoPGMJ
 f0lCKO6zUcn6tqMXUkyQRvfg/35bBHNfXXpBBv1O1SrJOPiZ15zPuVUQ+4ufGMpp85TypeuiOVplFp2sZ9dj3HFiLGMGlzh5DX2ODE/SwJOnJAc8x+1BeOebrDrLzaC4RkW2B41UAks9qCf1hkkkfYpQQwPi/m/Joeg2QyAeajDmZk+ffFxGB8rYrl8diSgzxAy2Lu2iv8PsjBhnhvJj8INprcsqyPkOTDA5MsZgPDVM6/G6Muu1iFSi31RF6pmFlLdESkkk+dBWXKaRgRv6oLqY+wWrLZufa6PQmWwGs7W+j7v9dqZWUOszGVAiaOH4y/xmZZuKiGv8A/j0WMMpuzSalUSWumiLfbFlAIUDhi+I2TpE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are only very few filesystems using generic metadata buffer head
tracking and everybody is paying the overhead. When we remove this
tracking for inode reclaim code .evict will start to see inodes with
metadata buffers attached so write them out and prune them.

Acked-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 4 +++-
 fs/ext4/super.c | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d18d94acddcc..6f892abef003 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -185,7 +185,9 @@ void ext4_evict_inode(struct inode *inode)
 		ext4_evict_ea_inode(inode);
 	if (inode->i_nlink) {
 		truncate_inode_pages_final(&inode->i_data);
-
+		/* Avoid mballoc special inode which has no proper iops */
+		if (!EXT4_SB(inode->i_sb)->s_journal)
+			sync_mapping_buffers(&inode->i_data);
 		goto no_delete;
 	}
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 43f680c750ae..ea827b0ecc8d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1524,7 +1524,8 @@ static void destroy_inodecache(void)
 void ext4_clear_inode(struct inode *inode)
 {
 	ext4_fc_del(inode);
-	invalidate_inode_buffers(inode);
+	if (!EXT4_SB(inode->i_sb)->s_journal)
+		invalidate_inode_buffers(inode);
 	clear_inode(inode);
 	ext4_discard_preallocations(inode);
 	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
-- 
2.51.0


