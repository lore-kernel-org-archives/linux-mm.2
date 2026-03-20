Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E00B71098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF1BC6B009D; Fri, 20 Mar 2026 09:42:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D54816B009F; Fri, 20 Mar 2026 09:42:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C68796B009E; Fri, 20 Mar 2026 09:42:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ACB686B009B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 531BB1C829
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:02 +0000 (UTC)
X-FDA: 84566554884.07.59ED478
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id EB8B2100002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:41:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=i3ZAuXwc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="hY/DWDGm";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=i3ZAuXwc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="hY/DWDGm";
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xEoAflJRM7Hd/KP30RTJ0C/33uYEsxXokECxD0i9oqc=;
	b=4KBOs1wqeOYFwIlJdsXIgwONsmVAZ/uHmJ4xqlrtlrCgj/jDShKepIGO2VfzvNoQUDh4Ik
	fnUsuyBBUw0NzJEsakbrHM89hoUQpFmOoJkyF59TMsZ4uX5aFtNL4HCzNOVQ1LCmr8qJJf
	sfFZCi6Y5osSgX70geQcSvjT0O10y6M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=i3ZAuXwc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="hY/DWDGm";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=i3ZAuXwc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="hY/DWDGm";
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014120; a=rsa-sha256;
	cv=none;
	b=ol84TPFjqHGdMqjKgfx0LpxfeWGm/klpRg89jwDPH8DG3oyw8e+qoLoyi6HFW87dxf0Tjb
	RCHdE+48OROWyRrIUIcpU/HWFV025+bs5t9EfD9DBk85kDrFubX6c2mrrWqg8yGEO7Nap3
	U9r8mG0qnP0seaue2vGkETGJX9mV0zM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C4FC15BDF1;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEoAflJRM7Hd/KP30RTJ0C/33uYEsxXokECxD0i9oqc=;
	b=i3ZAuXwc35r3TMofgZlHkAcNMsYqX3UQ6ZBVury6Imay3gTNNT6j82RPA0X0iSQCpDX1Ov
	W5RySzJQEbpCl2x/sCjl02ZWQVkS0DHt8xiZNM9DTFGd7WUleohLO8D93jNVcSHncXtf2C
	BQKsMIV6BzZlb0A3p+vtd/vvgLaejjI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEoAflJRM7Hd/KP30RTJ0C/33uYEsxXokECxD0i9oqc=;
	b=hY/DWDGmRhA2OKmvbjkDIrnW32E5cQRzGV9LM+KdS3D+eBISnF93ZE08P00oecqeS5KMND
	EJXz3DOEzwnI/AAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEoAflJRM7Hd/KP30RTJ0C/33uYEsxXokECxD0i9oqc=;
	b=i3ZAuXwc35r3TMofgZlHkAcNMsYqX3UQ6ZBVury6Imay3gTNNT6j82RPA0X0iSQCpDX1Ov
	W5RySzJQEbpCl2x/sCjl02ZWQVkS0DHt8xiZNM9DTFGd7WUleohLO8D93jNVcSHncXtf2C
	BQKsMIV6BzZlb0A3p+vtd/vvgLaejjI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEoAflJRM7Hd/KP30RTJ0C/33uYEsxXokECxD0i9oqc=;
	b=hY/DWDGmRhA2OKmvbjkDIrnW32E5cQRzGV9LM+KdS3D+eBISnF93ZE08P00oecqeS5KMND
	EJXz3DOEzwnI/AAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC8334281A;
	Fri, 20 Mar 2026 13:41:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /iWtKZhOvWlACQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 69BAFA0B2E; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	ntfs3@lists.linux.dev
Subject: [PATCH 03/41] ntfs3: Drop pointless sync_mapping_buffers() and invalidate_inode_buffers() calls
Date: Fri, 20 Mar 2026 14:40:58 +0100
Message-ID: <20260320134100.20731-44-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1214; i=jack@suse.cz; h=from:subject; bh=P6pO8hqSDzDiUMeN+vj6yYZXJszgs6S2wwGl0XVS/3g=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5uHEq4UQTZ1UrVhvgG+EYydxO1nRyNYrdsA +FUT3YdJO+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1ObgAKCRCcnaoHP2RA 2WvvB/0RJYZY+8sRCsZSDxp74cwUlJk3pSPEy6TOgUcor5WSx0fNWsU2RBKMR9lrW0nFZuGAYIE nZ80x+PYSJyIbz3wFzI7uEL92U24vHYHcIN2S1CEPaapKaX5HJshyeVQ6UgC/TBwcGYA6hdc//F xzOyybtQ3kRAgvcT4J2GX2rg07PbxzlH2Lo+E4tcn11rbOyLc/XbK+4Ys1LzsvUOwmYOwG7KCR3 V1O18HYdXkb/Fq6AGulchfOdl/QFKxjNpBYK4UysuSbb6Xxijc4KdoVb0UvbhXr4RLMuURijmFh +XPbvb7v4ubgG4Zhf784lhdxETYhNgSQT/EpvGQIt3NyqP6g
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EB8B2100002
X-Stat-Signature: itnppaxz34dpcrot3mzo9eqjopozo95e
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774014119-616313
X-HE-Meta: U2FsdGVkX1/QyGQm91Dr2Ywa1TxV5IIkgkbmotKyPSNEnAk9tS+Cz9zXfxXCG7NRiUYF3KRlFlSoQ2jwzykQZJuC9g4NiB8zKEJeN4k5bcUFhkdwypsejZjDJoWWsNobUA9Mv0ClhwkgvU+fB/NJFFXoCfQJPH7e1vvb+S7f57XNlfO7rGvXEhhr3NCWXc4jAx4QM5WusG93DLl3OyjnE3hRJ2eqSq1sL1NXShcBOrz8ky3u2cEyZizgiLhtg9Me1uvWdC8U+zbsBfQ2YPgr9945vQ773aFrym++nUr5xERlpO8y+vjUlaNRd8IIhrfzmVmXndutGVctGqc1wBUoRSCElGHeuPwjOF1udvQXlGuzneCzcBqqk1WH9N8mhR5eruy/wdKgUvb8qDLbY1fdGU5dMdTIVgCdbulDTtddfNmUL7O/RQghA0/RVxQ7bJ0JCSEzKecaLAssttYzLSuDX63wr2HlhcPBBcPK10mGmLPFq8zBJt7Kfo5SRTwQUpx3mHHaCbZagcCBN6+5/JUbZadO68MNFJNcEZmymnOk1BkxZ1sgr/iMlAXrI2wAYFFVBa1yM1I1Dh8AioqdVBl8Ol+fI+GFDetrCY7sv8DcRrCvvPIUicdRpI6RAcxHxCS9vkkW49l3JvGAXv5NgmSVXx6BiAWzVpFv8t45srkv4+9y/ck4qo9HvA4JCkxVfIW12kIpIX4TFlRN7MLg+H/j0UxwN+5fkMAE9x+LzSQZtatg+4ff5C4H8tBRB7vkFzggPGWYpb3ubJmTvuQ1GXxQsSPZhRJfubKbOlKDuFDNFDyqeIadwQxYrgtk7oNQzHCpuQOe9mjwmz39DNk6ST3G4ICMxuBKUiquhX9ujHxNCdDnpoUqWuQ7T0jHqL+VsqNrIdDjo6CvfszPHGeAu6HLPYuYY1KNoEu0Zo35Fvy7gI07eGaCsaXi253NvO+slP2Tahwhy7cXaS1O/zMu6GB
 unmbEqAw
 dKhk1QSPhc0zgjQUxTBiDVb+3ItYsgzhzG9QriXxGYBnT4zLspkA26O2rSagiE4P3XxydEvmAfJk1vu4I1ow1Ew4EhPxgitJEDT7rSQK1MRckVhnL5nakZX6iF4CwyOB3M0DouyPohpnlXrjMZuduixn1toxlXXeHD22U7utsA4L/NDqoymWzY79xY/Ot+yOIVrrZce/bj/PsEAdXoyY+rUMOM44cTjZQRO/v938TPptbUwZkfAWsjYvsba+MBbt1NNgIj1CR/K+S/eCDlW32y/J6nOjrkAWeAEVpR40d7lgeo6ShGHW01R5YV1dDQ/aP34M2c3Z2SQrpSUqdXtsMczAMqVmbuVNSr4xSE14e9NaFPmraoEF/e9f4/0SFHy7wwrmeCj9XT7p2GzCfImc+pn9uIqjOIWiSmGoNuxSGrtKCe4XP2fEQAcMgvTAGY4YHNdhO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ntfs3 never calls mark_buffer_dirty_inode() and thus its metadata
buffers list is always empty. Drop the pointless sync_mapping_buffers()
and invalidate_inode_buffers() calls.

CC: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
CC: ntfs3@lists.linux.dev
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ntfs3/file.c  | 3 ---
 fs/ntfs3/inode.c | 1 -
 2 files changed, 4 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 7eecf1e01f74..570c92fa7ee7 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -387,9 +387,6 @@ static int ntfs_extend(struct inode *inode, loff_t pos, size_t count,
 		int err2;
 
 		err = filemap_fdatawrite_range(mapping, pos, end - 1);
-		err2 = sync_mapping_buffers(mapping);
-		if (!err)
-			err = err2;
 		err2 = write_inode_now(inode, 1);
 		if (!err)
 			err = err2;
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 6e65066ebcc1..5d8f04dedcc8 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1860,7 +1860,6 @@ void ntfs_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages_final(&inode->i_data);
 
-	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 
 	ni_clear(ntfs_i(inode));
-- 
2.51.0


