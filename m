Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E116EC1423
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 430936B00EA; Tue,  3 Mar 2026 05:34:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 373E66B00F1; Tue,  3 Mar 2026 05:34:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E6256B00F3; Tue,  3 Mar 2026 05:34:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6E2A6B00EB
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:34:50 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8AF3758CDF
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:34:50 +0000 (UTC)
X-FDA: 84504393540.29.681CD58
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 41E254000D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:34:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mN1vbJ02;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Wp2z8Zle;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pz/dKtOmFCfJ/SjA/GWn8rRYuhiNasxWQhID+bg8soY=;
	b=ilAxJAMeRSJr1f6DqVapUpiuvqRy02p74/QP2E+QXd35Ru1t3+bIaWXVol0DQJCD8CpwJw
	E6KSfwor3cY/lWcyS5MvgEviECm8cP2CydkvWdY/ckSdlI0l7Yxueg8vY5/ekunE60B/AR
	+KNz+iP3jexwF07TrzCJmNVUnogOG1E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mN1vbJ02;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Wp2z8Zle;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534088; a=rsa-sha256;
	cv=none;
	b=O7ZmGI9zmTBX/R//VXglyw7EeKZEQvFs3TJQjRq5nOqIMN4D2/kSSVtZF6gv8nmc/sQdjU
	XM8Jw0sUeKDlJqdVCehxM/Z2bvBUkS0uS9rT7V1SgFOARYKGitRpa4CQhhBnLsNEzfLVek
	xboczWLWjp6QMGD7+bcBxW9igkskTPE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C23C25BDEF;
	Tue,  3 Mar 2026 10:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pz/dKtOmFCfJ/SjA/GWn8rRYuhiNasxWQhID+bg8soY=;
	b=mN1vbJ02BkdHrkSCq7HuC2Q6UX2G3qJp8tUORVZMK7fBn5reytJyxVT+IMRNsTGMMhF8u/
	6qrlolmnA1LZpdfH2rgDIqUn5nDR8uQ6xdn5zhJN/OBtINTE0IFxWZ8TK/ag1m2FhPQEKu
	0Du+EnC3LI//Z9Frtk7a5j3NSCs8+sQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534080;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pz/dKtOmFCfJ/SjA/GWn8rRYuhiNasxWQhID+bg8soY=;
	b=Wp2z8ZleWxA+DpAu5xfLKaK97+vNVTOV/SE9HnXdnG+Q3nif8V3IOx2rTZB6vMQytYp55i
	PhTgz3whSJee/8CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A94243EA6E;
	Tue,  3 Mar 2026 10:34:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 72tHKUC5pmnKFAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 585E4A0AAA; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
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
Subject: [PATCH 02/32] udf: Sync and invalidate metadata buffers from udf_evict_inode()
Date: Tue,  3 Mar 2026 11:33:51 +0100
Message-ID: <20260303103406.4355-34-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=790; i=jack@suse.cz; h=from:subject; bh=MUD4hvw0kKK4/k9ZuBglb9Pnr5A53izwByukHuzgvfg=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkfiH1edR4ShwUvYoFKD7qhhaBFBhSp0KWEX 3MdhTPWkEKJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5HwAKCRCcnaoHP2RA 2Y0DB/97HVCj2WXFdvCdWn1Mjn4V57ViLXdtg/UGbQxVNGIuhtxQQzjyL1R2n5SrG8WkGsbj1YK A/mndm9zIuMINZfD7Mg6eJlYoyvw+ggybLDSBgXkAIr/8iXeI8b66ztUtwFRK0eI/7aDrQ4w8Q+ OdgbRJpDE8/5HrwVjzIUWyuxJx2Yh+5MoEqUwf0tns0Y900/0YwU50KBwez2qGmrD1Q47BMn47D xk19ZaY11yAUMdI+OgBiqzd4relY9//72dN7BDz0o4neGDNsgPibXYBDf8KtVr3PiaBjuCUrEGO H8Y62jlLBbB6iEbUDBztcNYfl42hNcyprs0fj3hIkB4QbPYp
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 41E254000D
X-Stat-Signature: 9xcjxhs8akbknycfx7niw1cu4sfeiwez
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772534088-821715
X-HE-Meta: U2FsdGVkX19G09RHGrZqcJUk4JdIlxNM4tKvOTwkjywPeXHFLkX/STZYDOsrgbCYZS1+hvSGA5aH7jxS+j+hw6xlCgvJysnouZuv54keNak8WG3Yz+eA5kBEB9Sk/7g9S8t0FoHHMTneY0FCDIqY2udWuVvg+NjrV3S3GOnGus9CgiKuJbQ8MZ85m/7f6liHqS5bAefeBStB9hpo2KpNvD5e0uF0lpU/0h/BQap4En3rG9DjbNqlrM7lLc//GlxqIgvjQHTEFaFdGQRLkl12hnIjw6fOhSNe8ggi3CvthpNu6igL8tDsJN9ma7thXa6QeRZNLCPgElpO7SA5/fJJXFgRcKyT4ucSocPPgzZB6E4Gq1FdblTPNI8Fsm26m+gdEztIXf5FqR76YFJE8lnnowL/z9c4fuLLNll34oeIZVaj+n0FZv2wvsKEbLI1jUGOudyJUZNQEnWAfgYaUP0iBxAvCGknIoFa/MrZAbiuGjzBKrWIo8GoGs3V9A19cydsxwus4b+wuIVFEj9qC04wcIa7UpaoGTaIEKZPom/uepnU0HQFNAgDZE5oH7/YstZ42T9KbrFbwCKkX7uoiUjVY4S4TBtvh/CjoXZfvDr0LAVmJkZCIk/6qc3YX1MQH5cyZksl/kjhnf52LpPJN8oN03RSzhvdkf7Ork1Zb3DXTrQI9Xo40rV+65diJ3DfsLfPliuChDEQO6NXNOe1Dxu8bXSrCLzJbe4WsTkqDQzcNZ2q3sITQAhGMt88g7uFKO26QHMw5/nrBXwL1Ujr+4T1juR5szQ5S1z44jlC0ItUhHaQIZD/bilyLzLe8NTPywr2IWEKUulyjFojee4AtIvMHbuvrrLi8c8mDsdAae92ruxB3TZwKdKcSUEH6UpIsIfXlU1dxwZpPEPHBKLU+4k54lX+PpOIW4bgKiQDmmo+LSAu+VDc/suOPjBBOdc55i+llmJFTGRNyM5rhWnwQq9
 stkITXvf
 BuVHEnBq9HmoVTohKhfHUA4AxYsAoTts85J42KgBMDKbqozI9vB5GxtSZCfsOUbB+qg1zNK621tw9c5LhP2GA4O0EE9b0U34Z2UX3KOW03OuU0n8fPHQX+U+CUlfke73vh25P0ev91b5IvGejFkFPaqEUJUqFr8jer/WQ2MNVQWvVA2TZpd0Zaq2lTmVBM268a60aUU+qYs4XbE8ZjabGmTYpSVvu5nNPaXLaC4Hax8HR78GLdPzF8LSzWue9m8s/QD/TYaxSO7S2k9Cnv/5l+AQfYQYQUCZObqEs3CuVoGTlV+6Ud/N3ziSrW0kxTj5tFgepiDMmVBwlo5tlBbeutmPmL2zQEerqCbr2UW5ZlaMKDjI=
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

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 7fae8002344a..739b190ca4e9 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -154,6 +154,8 @@ void udf_evict_inode(struct inode *inode)
 		}
 	}
 	truncate_inode_pages_final(&inode->i_data);
+	if (!want_delete)
+		sync_mapping_buffers(&inode->i_data);
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 	kfree(iinfo->i_data);
-- 
2.51.0


