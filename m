Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC60A106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40B766B0092; Thu, 26 Mar 2026 05:55:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393936B0005; Thu, 26 Mar 2026 05:55:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 234256B0095; Thu, 26 Mar 2026 05:55:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 118DC6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:55:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2753BD16D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:00 +0000 (UTC)
X-FDA: 84587755560.08.96DF90F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5B06E120002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:54:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=j1W3Lwj+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zLp9BDkb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=j1W3Lwj+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zLp9BDkb;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qLbxD02dHUb8m8m5bbUbo7PwrJ0F2rU6l0JoHr7uT18=;
	b=rctIN3uYEC7dn+4DkXZBeBKTAQX1w0WKUSt55oyXpNzuQBre57k+Oaw1awEY9NZORi3akq
	ea8FnTG7WJDZDf9FDvO3Gylf4SVdt7g2MkVHQad8b5eDNRNu4OitDM94BXrjGT/Casfuwp
	7SHf2mK0vq9NSJRgkzIIF8X8aUUKVbo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518898; a=rsa-sha256;
	cv=none;
	b=Qw5w42/aRIn5kHkR9lnnrBelgGmbfzlGEKCrc2wrVkbh8qUfXX1Iuv9g4Abcpigwd91/Df
	FfKrFBKUlMIBIjkil/Ggf3OhuU+zk43XE66q/LBjXkCwEETjql+EZTWNb7KPkbsxpfCbnJ
	8L67U9C6s+USrTjpVVdDMBbeO2fH8fs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=j1W3Lwj+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zLp9BDkb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=j1W3Lwj+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zLp9BDkb;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B7C2B4D262;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qLbxD02dHUb8m8m5bbUbo7PwrJ0F2rU6l0JoHr7uT18=;
	b=j1W3Lwj+uEoS8aFrKeTVDJPYW72hkRf2vJn5hP1v8DJRKXyPA/DGKSQZrgq2NvkdbVTbbD
	5ESD2AguXcKfvWXc6T2v7RPcyUeA2G8aILDWcIG16IsgVJ6cJNfnUXUKj9b+pvb004Npix
	1gd48bfXQKWcaGY5bBI+fIK0Ia5XO6s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qLbxD02dHUb8m8m5bbUbo7PwrJ0F2rU6l0JoHr7uT18=;
	b=zLp9BDkby0P/CPnv8vfM0qp2HOKlcED2HspXzwmc+GSh3oHLojR5MxCbnA76CXYJ4IoDUx
	IX8LGkCjL1D7tDBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qLbxD02dHUb8m8m5bbUbo7PwrJ0F2rU6l0JoHr7uT18=;
	b=j1W3Lwj+uEoS8aFrKeTVDJPYW72hkRf2vJn5hP1v8DJRKXyPA/DGKSQZrgq2NvkdbVTbbD
	5ESD2AguXcKfvWXc6T2v7RPcyUeA2G8aILDWcIG16IsgVJ6cJNfnUXUKj9b+pvb004Npix
	1gd48bfXQKWcaGY5bBI+fIK0Ia5XO6s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qLbxD02dHUb8m8m5bbUbo7PwrJ0F2rU6l0JoHr7uT18=;
	b=zLp9BDkby0P/CPnv8vfM0qp2HOKlcED2HspXzwmc+GSh3oHLojR5MxCbnA76CXYJ4IoDUx
	IX8LGkCjL1D7tDBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AD5A94A0A3;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id khhIKnACxWmbYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 70AB7A07B2; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH 01/42] ext4: Use inode_has_buffers()
Date: Thu, 26 Mar 2026 10:53:55 +0100
Message-ID: <20260326095354.16340-43-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1573; i=jack@suse.cz; h=from:subject; bh=7NK1Luw5u3sFPoI2MABzxVh/UFbS1BdfliomKZSEhSc=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQIy322tQJD1bTpLOCCusW8JNc9TXDdWifJtU FNx1ADgBgGJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCMgAKCRCcnaoHP2RA 2RT/CACYvdN3lGJhBVD/JiAhbPkyZucipsmsOLf44AneuLqHJM4Wl9XFzG8f1KtIvt7/zHgTG98 jIQ0mVhMwcYPk5SQcdl996xUwcEQ+rZJKPfdEJRMc4HH7f6bdWAgR2Se8xf3QUDFyhtk7JH5RIf A+B70fDJuJyEaiV2N88PDM9uHrLgSSEAJY0L6wcsvHzU1l35Pwe4guAYJwFsVf8R08qnVDIG5CZ FwxT6/WqAu9WbIUcZlhTIfsY+yrFEXAqnuQE31XgPg4eARSbVsNvjHRLZtwbrOAAxvqwXvtHsKc YYkM0KkUHCXLhiSfNL08tOis9FxZg3jUQrhCCUqSQayiAdxo
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 9ybdi4nuk165sd7nynrqii5j6tf9x46q
X-Rspamd-Queue-Id: 5B06E120002
X-Rspam-User: 
X-HE-Tag: 1774518898-730590
X-HE-Meta: U2FsdGVkX1+7BeQTgIwPCt1j2mZc5igiNNKbWf3iRpM/4BMoFHgw92AJc0qIos5NBPIHnzj6iJzJggITk17syY9B4iVWbkTNokDihvAF3wlu/jLDpXq/wlO2mGImB0vyjA8/u3XQNWrV9aiLEBh87klZ48Jr6BeaYu075W1fj6hapSxQ+mYe0I3gDTxJFq4Gcsi0QuY+SdzC3595NefRMfa3dQU/CaDx2XZxLVxGHAPtm0pqXYBuMGOI1mM28OzwQ/iz0cIVDAMkr9CLVih2XVh++cYcQWPOvqSRbAUaCaK5HRpU/GVzmzfprDF/RDOc1O/EnM/AkHWli9+IaK41/Hp5PNEDHTtvAoEQbJFeERIE0EQ/2ziK13VEaBsCnbFmCTx9Rfrnw8VIYG7Chzigy/+wlcZK6bw7Qf1yiHSVfrOPtFkGU0LBXiBQzQbv5pPHVdOOm3k8Y7X7QaDxCW6ajP4T6/JMpOj4XpjP5l9Gs82VIwE6xm1dWZvlD82tVZVat6OB1fnwM6oPYMhHTlBKh1T1hnEmEn2MEaS/+0tdmhQMfp4KBLncqSBboqQlNZA9GV2wnzNkvNqbOBizzfBHz0cmt467DJ6aCJDTfBpNVtp1t+qF8T7bPFKSgWfW5B2r5E3u7uvLf0XX1gd8c4rcEdgs51unXdfymoVdezCekRYndi8MN6Jrg39sILlJ7sjo+9BW3xsivgo6f8P2rQZ0iDlsZ9/cc1m6yYvLD2K5hD/n0awOcKylJ/UBuyQ3/dUqs82i7X7APCiqe1ghnNlSq4/V3FAkcI48DUcV5kYz2avZmWUa/JGvWFFURy1NIg54yfiXyN0DFkEOxYQHpete0UMCtLzVb7iMAfL9r11atULY4qHkWPcn/SUbqqL41YYX3pv21+hppgHYZfqUtOXC3Uo740uhN2zwuhIg/WsGuIJVFj5z0rSzW4VUzIPc4Vgx46Z1ji09cMzfirPlz13
 h3s2RMBM
 s/PxCUCRj9AMGQDCPnDbwk0oaTRqJ2hRSXdDt7tYFFIUq5SQ5kiLgTBbhxr/iy+XF8Qx/S4fnAx6y3OJJ2CdD7yW/8w==
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


