Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52744106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 172B26B00AA; Thu, 26 Mar 2026 05:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FF0E6B00A6; Thu, 26 Mar 2026 05:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB7DE6B00AA; Thu, 26 Mar 2026 05:55:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDC756B00A6
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:55:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A7F661B92FC
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:31 +0000 (UTC)
X-FDA: 84587756862.14.C688D24
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 52EC21C000E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=auK1kjzn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5H3HM+XA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=auK1kjzn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5H3HM+XA;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=auK1kjzn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5H3HM+XA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=auK1kjzn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5H3HM+XA;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518929; a=rsa-sha256;
	cv=none;
	b=2bMXCtzqQJdVRm/xxDLZW6SDls2SjVE6ao0wOv8LPpvM8cd1nz7BE3Z3s1wr4giV0l3wWu
	LtovXSZMtdpnpDkIzD09BXWP5kUeUHCRmnwkZ8KZUkVHydtLOnYJfRf8lG+ayQXSJvz2VD
	LxKFp7EB6eO1Gx2ox5s48A2zx2GKS3w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1WZrCR/hrplAz7CrGGN1pyhuwAsW6VsYXtl7pMQKKRw=;
	b=MANTDBNLFrfJ9Fh04SWKcDAA9bTj0BfkZPEB0Nsknb4PmtiZz+E0uf6vBF0bvoftAMU3qr
	VGj5RAL7uM6p7TcUqVlDcpbP9FpMMSp1w2A/8dPIe2sU98oAlCjYscWWL9wyLhuyaz9lfT
	GBmzN0fXpEB0rLcYi4RTs/ggNwtpXXA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 287044D27D;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1WZrCR/hrplAz7CrGGN1pyhuwAsW6VsYXtl7pMQKKRw=;
	b=auK1kjznc8woJpI/n1LKgos6QwI1I6y0MERfu6eLryJUXVAS124LSfTUWiKLYubLzycEBb
	2jMjsnTHhRDGpKF8DmHyt7+Ljje3jVKGSpJcbPuC8tt70StMXHHRq7XyJqXsG7rtje1wf6
	67sA8T7d7Eyi1eFexVywXA0wcDwc+ro=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1WZrCR/hrplAz7CrGGN1pyhuwAsW6VsYXtl7pMQKKRw=;
	b=5H3HM+XAu7TWqcD89+9dRZxM2u/Ku6EXFTRqEIUa2Nfsy5msTGcrycCJMF6lavtEtUmf+t
	ok9PcFHa72SxyTBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1WZrCR/hrplAz7CrGGN1pyhuwAsW6VsYXtl7pMQKKRw=;
	b=auK1kjznc8woJpI/n1LKgos6QwI1I6y0MERfu6eLryJUXVAS124LSfTUWiKLYubLzycEBb
	2jMjsnTHhRDGpKF8DmHyt7+Ljje3jVKGSpJcbPuC8tt70StMXHHRq7XyJqXsG7rtje1wf6
	67sA8T7d7Eyi1eFexVywXA0wcDwc+ro=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1WZrCR/hrplAz7CrGGN1pyhuwAsW6VsYXtl7pMQKKRw=;
	b=5H3HM+XAu7TWqcD89+9dRZxM2u/Ku6EXFTRqEIUa2Nfsy5msTGcrycCJMF6lavtEtUmf+t
	ok9PcFHa72SxyTBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 198254A0A9;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YF85BnECxWm9YAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DC155A0B99; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH 13/42] fs: Drop sync_mapping_buffers() from __generic_file_fsync()
Date: Thu, 26 Mar 2026 10:54:07 +0100
Message-ID: <20260326095354.16340-55-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1452; i=jack@suse.cz; h=from:subject; bh=SmSUMyHwm0K50cHCdMR4KDamoJmEJMkF3+TUKO5XXw4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI9kheGDEUE8Z4bg0Qcp/ntGv/hibVmPm3jL c7I6LLeBhuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCPQAKCRCcnaoHP2RA 2eBxCADEaMdSYA4l5xrhxMIj9bv0RkgmP5xWyow8IlNUpzdPlJZNknDMp+bQFC7PrZPd51YrSfx bnumNmF6zOsfs6YEaB6QAmg/PdRy+qvkjxyzr+6qKVrLWxeHm6HOvcVSmUPklnyh52tYvaowSS/ AL32Z6DUEfinD3ZJzIaeH97p09oAr7SlUTNBHs1u6DKNeKBSocDmHRAlyr4boaegHi72x0WROFJ VTOXNurjK3Ho7Ddw/mPoJqcLbQ2EgqkczK94Oulhgu/b3rmKFmMg7a9MTUVzcWcO69bSV8clW26 AMe8xZ3pQVSvll+FZYpQQKq/nW9UB39vZXjlKwMDVv9O2hyy
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 52EC21C000E
X-Stat-Signature: j1o4ums7u5zm1rnwwgrx44zqdq6wawq7
X-Rspam-User: 
X-HE-Tag: 1774518929-613523
X-HE-Meta: U2FsdGVkX1+zNviFgifJ54VNNYX9jQmdne+Q+HE8CsGq5Rw9NGczdLuW03mqVh9rMzoD83fC5jTsxhPn6BEU044yweOQL3dqw6MLbgLI2DF/QiIcaFdGrfr/75kvadTJQWVtrukvCmKW+rj2lh60vvM1adGj5PGVSe/A729Ssbi/jwjNkZjOPE8A4l3CJ6QC6AJDcfuvm7aZCttXXIlsTRohA4e0aFLTe6rZjlHRJPtcIi3pDPoD6KK9kD+ZOBLC76IR3ijopbi+TqxI3EFxTQiestbFKOaT2R433mKXtj0aBqXq6ObaKEUDBWBP/AsPdwy+Ku2Gq3tMpPV3SPl9IwmL/0RDmNaiX8X+Hb1XHix3nTkZZdsDHHUXHtdPCd4RcxhCrGqmLCfVBRJqur8T0qGZkeJwdWWFJA6u9PqHXBpYQAar96czD8eyKxVyXcxEWU6ek1xfg3el3VYH3IGSTB0aqvOxXi999ryeWiMVWHWDR9PrPZ9vdY93reVtvliqa1j3/IYaABmnAOejwYNj3HfM83K6prXmYgnOmYiRZCPak1S8B/nHOU3W5S4JzjyyWKawZp/lj7vHTahxCciBd3Qkblf/CHo7hYc7ko/xweFN9XCCdocfRAOzaHBU2aM/fTE8oFIPaEiUFfLZ/deQiKP6TH/UwzhbdjqMAq98Y8NhVcsmWrUTc8Zl9jIGq11xSQ7h7sStgo0G75hRE3ufjhs6MmzGiVHGcwgPLOk6j1qi5x5iMVPG5ox2gteKG6aXM0ejh7UKI1nXsjDbYh/Upfe3CVV5se5c0TU7UFqHtViTpoUpvRczzwrUm8AEdD6Eu9hV3UsDDvseMF32E5hixyjrGCz1pdRspsTgtjTieoaU6i5si+oPpyGcYu8mk0Dmg3Ajaqxp6c5pd2LIPNSXM14l+tY+xR/IB0Kx6uMB3Wj16NILEPXFwMzeLjbZVX16kHIcIMTtG+Khh5Jract
 26CjMLYC
 XvgUycAeigBqgy7oQAgn/YE2klRsanr26ECXQ/nFIueclkfBCKU6LrFC7gByoPU8qzb/LVYWhNzD1GKsA0TjXOA6f1K4g0ydYpPweSBnKQHEsW8ww0AWYWp3rZboH+xLjOn0kQ82VsF5IU0rEE00/+o0yy0lCiyDc6JCHMFOMeUtC8qdW+5dljMerk0qYhEo2QhQFP3iJ4RXM7QduERYheUMuStcmc2WBCMHrVWUX20xr9z2IB06pS82kDP4VZHz3C7B8gkBm6N3gxBkNZYfCSXf1gr5QmsfnyrTIcyy3KwTVhmZ+D6bR4tojnXfaDumD79FsSAjm7XWUs47/gcKSIw7zArDqJn4lQnTlx9gm6hi1v1vZ3L0HKgFDJfu1xTxLGUeTNnyV/1Jgl8Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No filesystem calling __generic_file_fsync() uses metadata bh tracking.
Drop sync_mapping_buffers() call from __generic_file_fsync() as it's
pointless now which untangles buffer head handling from fs/libfs.c.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/libfs.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index ed7242d614fe..e67e43c6509a 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -18,7 +18,6 @@
 #include <linux/exportfs.h>
 #include <linux/iversion.h>
 #include <linux/writeback.h>
-#include <linux/buffer_head.h> /* sync_mapping_buffers */
 #include <linux/fs_context.h>
 #include <linux/pseudo_fs.h>
 #include <linux/fsnotify.h>
@@ -1555,22 +1554,18 @@ int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
 {
 	struct inode *inode = file->f_mapping->host;
 	int err;
-	int ret;
+	int ret = 0;
 
 	err = file_write_and_wait_range(file, start, end);
 	if (err)
 		return err;
 
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
 	/* check and advance again to catch errors after syncing out buffers */
 	err = file_check_and_advance_wb_err(file);
-- 
2.51.0


