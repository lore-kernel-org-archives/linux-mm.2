Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C41BB1098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:42:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF2506B00B3; Fri, 20 Mar 2026 09:42:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7B646B00BB; Fri, 20 Mar 2026 09:42:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC1FB6B00B3; Fri, 20 Mar 2026 09:42:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9AACC6B00B3
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C016B6F62
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:33 +0000 (UTC)
X-FDA: 84566556186.09.29E0B82
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3790C140002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YbVk6QyX8iK8aLH7e/nfEpH6ABh7sHrgDzAqRiE4i3M=;
	b=dhU+qUUnItIGwyHBDIhvrXjA7ylONalOpdabhla7sfflK4qy07A6ZDUtCROuHcBZMyYrUu
	I0GWIWIdSV7qK7B0wboprPYgr4AE0Fzbfzi129r8sG6TwcEivBCU/yJMZnmymIZJ23CHHy
	nqM5njf8LD3Ap2NcSGPR/gBF4ns4FzA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014151; a=rsa-sha256;
	cv=none;
	b=wnwoQnGZK28SiOfQNmQfytspzJWb6vuCPg/IPs7mLI2eaJ3kcUIokG62gbBBDU0RzC/NQG
	9uYoTFHjYaK/0BcgtnOEAA7tVmptD3ZRqgOMmIvAP04IEZqxHCujLveHtt2FznykCVYfit
	SH9U4onqS27HBcRBAHcXIz6gR6OGiBI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 320905BE08;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 113F74281B;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id N/4yBJlOvWllCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B3726A0A9E; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 12/41] fs: Drop sync_mapping_buffers() from __generic_file_fsync()
Date: Fri, 20 Mar 2026 14:41:07 +0100
Message-ID: <20260320134100.20731-53-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1135; i=jack@suse.cz; h=from:subject; bh=YpwlY9gANXCHPNbAIVrmfcTj04CmV1BsSIb2drOA8QM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU52sjR+o4oxbnG9aLagbbudeDN06j+Jq4fhR fjZyg4nS6qJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OdgAKCRCcnaoHP2RA 2a9CB/92F1jsJ3pb11l0aKofBm0Zt/jJjH/fyYCQ5Ttu8zNndGAc1uCOl1EfZdu4wCPY56J6qpT IuHSNDYA+5pelUesuQAxDvEQu4F3gLUKknjg0kLT02ahHvrv2eRBIgctjclBTqbfZUAXbg1vrjE anSm0g5dysaM5JTBnNxD49RNzIEi90xTw7vkRnUy5IZ7PAUqEr2b5nQEOr6rpLyEKh+UWolfvxy 0PQtTkKn4WsGr4tRG4nSX0zbpNKxAGuHMfI4eye0NYi2tZLebr16KDpwVnWRaTE+dSHonwGSdlJ 6OQS+CHCJT2p10Dpz1PJVZJADOV5efY8uzTWx4cvz8x71EYs
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 3790C140002
X-Stat-Signature: mazjb6wx5kndb8na8ybafyztstxsb5ks
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774014150-187402
X-HE-Meta: U2FsdGVkX1/SryTSdcuFbSdJvb7b7rdy1v8J4wOr74fbYUSXTrnWjcPGxwv2QKdBbWLCb0/RMaQD5Z6DARzjTBEVSaHdykA+uzH+KJQqWcWivEnEN9DuGkB1QWeDjxULuCrvLzV+CLYTsdWpvM3i2/4baOC46hKUGa+AWyO989+Pw0yxNTn91CAUuaZ+Q4382ogtWPdX+1vsbfcD3Mo5BFwH5Lci412aCE7JL+Qc4l7WVlFZkz6v2wElSB960fu6p5OID2w0ytO5GF5j/uuD+zp/30Y2NZDj0hkMX8WE4dC8OTxko8VPqRs7WXSgzw7XwiD0wMD+kYPQBUFv0VdXz52RTVafpFAC2SSgflkEbnfdQ4Qx1d6cXXobQ0Kp2zb/H0aqXK/v5D07mr0S94BhpGun5OJlLY8DGAR+s1DejtjJgXxW82HGEize1ArdeFQALBusXGO81XLf4f4wLqnwDv7Rpa039A4LmAFiONB0yYyGBPfv9JsKD1h0S1mWK2UDdocXuYsVm9PM8YRYk8+5bg3tuS4FA7GUYwwS16XIdj3siEvp8+twNrWGL+LMRysBymsdkypZCyQOis1S6WZb8gNXcW7e1rA8OmsBqpwKVwqELtNkKSHbbcmXnwFZjlVkaGYZpJqZrUyx3iYcD4Pxr6NzBZdq9eIRCWveRHCvxxOByMzvnVb5ebOlIdk44p6KQS73q5SXh0YZBYBs9eiLG2nK2IUNb4S5suDiJuZUi/tQ7Wu6AvINIbK2sajlXCz0pZrEGhbb7Fq3zcIuSYhOJBAST27I+KdZJBLdOePq4/0tcyD5v+2EVOEPoip7PhOZNWOy9G/PWKEPEoVw8s1c2HzvDejJIbVVdgra/Ab2OWZsy8rcLt4ohOyBGz94V1iy/yRr2I6LKNQpjk2Ep3ORn4cj92Hjdefg7TL0HFuINCwAVCqUrLbtbBFGaACoBlW+harEa7nq7B5mNGmmOAA
 KEMxFWJS
 b7FxSkh5SgYJ4b58pQVnls4MWNzWv+BmzGC9HoxCxLJeGrU1bYjhPU3rv+Ig73pG0fF24kpiORjm8nfOgmXtL+xyXqFmCWC1hgbeDOMy6Ea7JFmwUWuBzeyA+oGjRtNJ8gXEfmW41M37TkK4ogoC0Fpc0ulD3Is6NHemwqw7BELeXQwuUrENfNhXfcTxbSbCPBQUI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No filesystem calling __generic_file_fsync() uses metadata bh tracking.
Drop sync_mapping_buffers() call from __generic_file_fsync() as it's
pointless now.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/libfs.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 74134ba2e8d1..548e119668df 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1555,23 +1555,19 @@ int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
 {
 	struct inode *inode = file->f_mapping->host;
 	int err;
-	int ret;
+	int ret = 0;
 
 	err = file_write_and_wait_range(file, start, end);
 	if (err)
 		return err;
 
 	inode_lock(inode);
-	ret = sync_mapping_buffers(inode->i_mapping);
 	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
 		goto out;
 	if (datasync && !(inode_state_read_once(inode) & I_DIRTY_DATASYNC))
 		goto out;
 
-	err = sync_inode_metadata(inode, 1);
-	if (ret == 0)
-		ret = err;
-
+	ret = sync_inode_metadata(inode, 1);
 out:
 	inode_unlock(inode);
 	/* check and advance again to catch errors after syncing out buffers */
-- 
2.51.0


