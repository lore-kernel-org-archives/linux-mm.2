Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72093EC1426
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F9ED6B0155; Tue,  3 Mar 2026 05:36:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 977A46B0154; Tue,  3 Mar 2026 05:36:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84D286B0155; Tue,  3 Mar 2026 05:36:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6F4FD6B0154
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:36:26 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40C7A88C0F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:36:26 +0000 (UTC)
X-FDA: 84504397572.01.A82A841
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id E6F8A4000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:36:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=riRJ8NW+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=f30DNEh2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=riRJ8NW+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=f30DNEh2;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8kyywLHolUFfflmeKoQmwdoShpEfRfGPbaWvTfEWyg=;
	b=SCmy9srdWPbhkhFom+KX3Ow7PUzDSwfjTo1KjAxCmGWs5gHjF4rULH+zzM6bdNoS9rC3Bm
	PYV3Bp9+M9m06nxVyiokRCTr17XDOkxkusGPlhRcv+a/wn4h0PGxjVxc2yLnjOOUX0vauJ
	BCl6VUcSKKCpC9oTg561ixlJz5jLBUk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=riRJ8NW+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=f30DNEh2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=riRJ8NW+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=f30DNEh2;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534184; a=rsa-sha256;
	cv=none;
	b=n71RzGrZve40TvZ4pYO0WOMKfhM9H4Ti1qkOlKgqC94BJMzcWoU6SYSL2d7rBL6U993C1k
	6NNxZwrCD5mlyGBgpksR3f9AiRx4kDjMqwmsP26jD7f6dkS7WfA2oLvQBxEg0JjOXLzM3D
	2yAoEipIMiM8Uz9i9u4pjAejROf4d9E=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 649573F93D;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g8kyywLHolUFfflmeKoQmwdoShpEfRfGPbaWvTfEWyg=;
	b=riRJ8NW+V1zZx8cER/1x1sr8pnsKHIaIEIx/c05/7IhYddMIYhuBNB1YeexWxKoiQEsyD7
	mXtVQzMuEF4htuZU8Dv5ODkB5ct1+hD8cb1vr5ua86U8Vqc4Pszk3VqqOBLf/mGm3+/J9u
	5cUnoWpr+mXwJp46KaWZZY5yiKRosj4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g8kyywLHolUFfflmeKoQmwdoShpEfRfGPbaWvTfEWyg=;
	b=f30DNEh2hU2XMQ+xlXR4PJS2MO4i4h5WSF36OjO18kXAC9PPALuN454QGTgM9ci/Y2IZVF
	Z0KSrzaLupvc61CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g8kyywLHolUFfflmeKoQmwdoShpEfRfGPbaWvTfEWyg=;
	b=riRJ8NW+V1zZx8cER/1x1sr8pnsKHIaIEIx/c05/7IhYddMIYhuBNB1YeexWxKoiQEsyD7
	mXtVQzMuEF4htuZU8Dv5ODkB5ct1+hD8cb1vr5ua86U8Vqc4Pszk3VqqOBLf/mGm3+/J9u
	5cUnoWpr+mXwJp46KaWZZY5yiKRosj4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g8kyywLHolUFfflmeKoQmwdoShpEfRfGPbaWvTfEWyg=;
	b=f30DNEh2hU2XMQ+xlXR4PJS2MO4i4h5WSF36OjO18kXAC9PPALuN454QGTgM9ci/Y2IZVF
	Z0KSrzaLupvc61CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 59FC03EA6F;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VL3cFUW5pmmXFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 35DD4A0B7D; Tue,  3 Mar 2026 11:34:41 +0100 (CET)
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
Subject: [PATCH 28/32] minix: Track metadata bhs in fs-private inode part
Date: Tue,  3 Mar 2026 11:34:17 +0100
Message-ID: <20260303103406.4355-60-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2840; i=jack@suse.cz; h=from:subject; bh=w1z6jnxF8yDzKQW95qXVLGcI3yol4PvG2FoQtSuAD3M=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprk2v2FfAPa1w9f7A49GkDXcSeq/sH/iUnnvR jcCiWxatWiJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5NgAKCRCcnaoHP2RA 2fMjCAC2dbhicKhyynE4JWWF61bmiCpPMpGAK4sf7cvJyVAxew2gXZFeKUCnksLJWiqIa2IcejS wrjZW+nVCA9RMis6u/+vQ9JVCdCcKDwwmlD2EBfj7TNmerBc9slRwdKESJrpOMXCh54ge6J8m2a chM5bCBeenSjKH+a6BpbBFoQIQNvG8xsu8m7q/S66uGG7MyXYxHTudyjoxrGO0huJ13UQd9jaZl DGhwTyyFI+fZZ7Mctuvij+ZdwlaUXK6CGjJTuZwE9yTjDpRNw6y5tl6HCayh8XW5NKwonRXfsM1 AMX68dkZN5OALYJfmcyZLrQ3/8X52nXd7TZwuSOb9+ZZVkRG
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E6F8A4000B
X-Stat-Signature: arkgbn1ey1sb8tgujncbjexpzas6h1uq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772534183-47043
X-HE-Meta: U2FsdGVkX19YLhiYBkC6eOEHa7vVmseBcAqsvlOkn/KUi2PGp30E4xpkJhzbfZP1xIPEZfs/uDueW5gx6/Kyx5iAFAeCDa1R9li85Uy1juk7USmymqijwBojIBZHtwQdhlrTo74W0QcdKhF1hP61CGz/8iFv39dQODf6yB+7l30VHy4E1kbAMlkp79gPzSqwfSJrDPtaVMJoRHP3CwNcMKuBHa5Siyal063bPuR1oXhJliDqlNWPQOkFnLu+yeo4uOdPcvn852v5dLovBmUAhCwk1axlGhRHcyd/umkSc1E/VE4WIJ48o/0dHCSrqQ2OVYggyJsxm3mz+32pCuHD2wbFk8vlOPneVa1uSdQY+KqsgW1rUe1sTcJvPgR5ZX41w0kOj8h/EsSH48L+NW0o21ciHapMXhM0NwFEjP3f2+2f9lqS0DUKCLONsj85jEelmYKt+UvtAyX4fyVWYQ2BmxMhHcFQKJ/4Xl0b1SP9mLCKbYF/2cy4Chigleu2MIQqKgrMCQFyLj3TDlhIpVbnWcLQtnPkHCsWOnCKc9N0D42yrrOk7Xdlxu+vbxfNJL2cK3BFL3keu0muFEU0dcwDTAnCVZkxP5qA/jpB2uSx0r1C+c/J9BfRud5FA3KeNF1imdSJ8t6SvN61W3dlvCSnfuCS0tvegWEB0CqTmOJSk0Cdx4duKDWvbnhkHISYXUAuTmOncVFS/slqKVfxLr4QDxoNw0Ns6hWN6M3suOAuVOKG8migFW4VwISc9At8MHG48nB8l/ZaQ1yVW0vdP8cMLBcU8A6bGYitvtfH/HDsLz+S08B1jcrX0j9PqrL5g1J8abZWXiOMK+/NuATTFpRPDGmKC0/vxyxE+7h/9QKUkbgmsH84RMm4oa6yJ8rsTw/wULPcXyNZks3HDXDPvcSxNE5lRpg2t8meFENwkAyd2qFRGOXcdkTEIq1WjjKyIg0/qViCpDx6bIVjxdIsOqA
 defrcGGD
 zIKbTCLU3zc/PhXnzS3EsoQsXrywegyKHCRqAhJz+1m12nNVOVCTXioZmwBDP1beZa57YLvq13rOHHZAC419HZ61T/PyN02+iSb3iOoeKIba3qiWhyO7BgGRhXIpbB+yRY/2ccFsMueQPEeu2FD5LZ/PFWsUMcO/wEAmmLPBwcIq++C1mvpbBcDgADYZ6gnu4WCJchKRPbiNfirn6ak72jLspuv5q8OMok4XN6uHfNLcTC+jNfPuEsa5NACbya8jZqFXd/lt4kT/7aY5YO8E42BmQnv+pImwQLtASgQ9gGVoyzjYJvTicLsekeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track metadata bhs for an inode in fs-private part of the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/minix/file.c  | 1 +
 fs/minix/inode.c | 8 ++++++++
 fs/minix/minix.h | 2 ++
 fs/minix/namei.c | 1 +
 4 files changed, 12 insertions(+)

diff --git a/fs/minix/file.c b/fs/minix/file.c
index dca7ac71f049..b3abe380634a 100644
--- a/fs/minix/file.c
+++ b/fs/minix/file.c
@@ -50,4 +50,5 @@ static int minix_setattr(struct mnt_idmap *idmap,
 const struct inode_operations minix_file_inode_operations = {
 	.setattr	= minix_setattr,
 	.getattr	= minix_getattr,
+	.get_metadata_bhs = minix_get_metadata_bhs,
 };
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index ab7c06efb139..20abbe21a632 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -85,6 +85,8 @@ static struct inode *minix_alloc_inode(struct super_block *sb)
 	ei = alloc_inode_sb(sb, minix_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
+	mmb_init(&ei->i_metadata_bhs);
+
 	return &ei->vfs_inode;
 }
 
@@ -122,6 +124,11 @@ static void destroy_inodecache(void)
 	kmem_cache_destroy(minix_inode_cachep);
 }
 
+struct mapping_metadata_bhs *minix_get_metadata_bhs(struct inode *inode)
+{
+	return &minix_i(inode)->i_metadata_bhs;
+}
+
 static const struct super_operations minix_sops = {
 	.alloc_inode	= minix_alloc_inode,
 	.free_inode	= minix_free_in_core_inode,
@@ -502,6 +509,7 @@ static const struct address_space_operations minix_aops = {
 static const struct inode_operations minix_symlink_inode_operations = {
 	.get_link	= page_get_link,
 	.getattr	= minix_getattr,
+	.get_metadata_bhs = minix_get_metadata_bhs,
 };
 
 void minix_set_inode(struct inode *inode, dev_t rdev)
diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index 7e1f652f16d3..38981a30ac99 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -19,6 +19,7 @@ struct minix_inode_info {
 		__u16 i1_data[16];
 		__u32 i2_data[16];
 	} u;
+	struct mapping_metadata_bhs i_metadata_bhs;
 	struct inode vfs_inode;
 };
 
@@ -57,6 +58,7 @@ unsigned long minix_count_free_blocks(struct super_block *sb);
 int minix_getattr(struct mnt_idmap *, const struct path *,
 		struct kstat *, u32, unsigned int);
 int minix_prepare_chunk(struct folio *folio, loff_t pos, unsigned len);
+struct mapping_metadata_bhs *minix_get_metadata_bhs(struct inode *inode);
 
 extern void V1_minix_truncate(struct inode *);
 extern void V2_minix_truncate(struct inode *);
diff --git a/fs/minix/namei.c b/fs/minix/namei.c
index 263e4ba8b1c8..e31e84a677eb 100644
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -288,4 +288,5 @@ const struct inode_operations minix_dir_inode_operations = {
 	.rename		= minix_rename,
 	.getattr	= minix_getattr,
 	.tmpfile	= minix_tmpfile,
+	.get_metadata_bhs = minix_get_metadata_bhs,
 };
-- 
2.51.0


