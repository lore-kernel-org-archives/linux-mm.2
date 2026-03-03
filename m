Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66013EC1423
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAE3B6B00F0; Tue,  3 Mar 2026 05:34:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1266B00F6; Tue,  3 Mar 2026 05:34:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943F76B00F5; Tue,  3 Mar 2026 05:34:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F5456B00F0
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:34:56 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5AB491603FA
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:34:56 +0000 (UTC)
X-FDA: 84504393792.20.797990E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4489B140009
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:34:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ccwnpdOWfUVYMgf2o3zfELj1JMki4h2I4Y3YIVvljn4=;
	b=ThGzT92HHHWN5Xz+2lFgA2mtePZ++RGpjUuziNxPMifMRnOstr3CciynEwjRMoo7RtJAX4
	8fSGrF1yIoeabg7XWeZUsJmBrZU8qpojpaxfbpcLA3VOM/8DqpKgeNm/rgpj3Y4SNikDi4
	q65xXcu7/bZjvIBK2absfWWSJee7ryE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534094; a=rsa-sha256;
	cv=none;
	b=107LJWkmfnIdmwVod05XzIMnCpqHCNFZZEHU5vA5FQGAEtJhnCg95C6xD+iNUlk+zBgUAb
	UHDmysXEwJERoiqNNGsP5sCy5mka+kDhY65tBPpAOJm10s5EiayBZeMKxpzlKlkcX8jfHo
	7uEUtuizol33Q2WVZ4DHdfm+CUmIQZY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E498C5BDF3;
	Tue,  3 Mar 2026 10:34:44 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D91923EA6C;
	Tue,  3 Mar 2026 10:34:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SG0ANUS5pmljFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 770BAA0AFF; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
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
Subject: [PATCH 06/32] ext4: Use inode_has_buffers()
Date: Tue,  3 Mar 2026 11:33:55 +0100
Message-ID: <20260303103406.4355-38-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1532; i=jack@suse.cz; h=from:subject; bh=NSocyVgO/kQGAErs8cha/4S5lFQVkvyp5VDOz50TMvM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkjDcPjRe968iOjtyTk4+S02xDNjEq4RENFS zbxRWwejuiJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5IwAKCRCcnaoHP2RA 2QhkCACpRJHTWCgp3UVShmcjh3k1jfzIfqAWQr1o6ZxLfxYJPnN2AThktcbpTOawdqDzL8zNAF7 TPKXNMDZwSJ62WeoErOrqaZkd8I++A/Aed6Zptq4hY0qEUDYnW6DTw5jKyOwDIAih1w/EP1l4DA qWg7/PuX3cHPXX4FNRnBpnRQwfnGvN2qAEDR7Jn7X4tL2wltRxpcJyBuQYk5vwLLQnB45B44d3j SQAS12MqhIvj8PhOFpJV+6B/9DPL8lDLWvj1AniE9WlrsLtl+SiJBsplxP17ZztDbbVTfZppE5w KWfFd/pvRhppjHcrxes4jlejCtzwSOEMzyw48JePwQ1aXBuU
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: 1oxhjww5ibcqzpju7yyirfzxjroxwn1m
X-Rspamd-Queue-Id: 4489B140009
X-Rspamd-Server: rspam03
X-HE-Tag: 1772534094-374551
X-HE-Meta: U2FsdGVkX1+s4N4fZ1Z954mjN2OODBB3Pm+CZY8MyDxcrAtYO4rbpbv7wY7PLqPiQ+E5cKYv6hNTv9JOrnlAXFE9Ra142G7q1aCM/rmR68c5cZ2tuvqeQtcPwGudtbQWWdi6QNTEc52Z0B7A8Y2ApiOYmb+LfWK1PQxJoRI3EoFUk3+4A4U5sOmq9+yi1gDck7MxUj1Zxcqx3cNrJMeGiae6t+M9PAypa/ep6W9KyE0zsOSMmLjZvTPvW4YTDf3Vhe1RkB/4AYOc9A6lESZ1Qbz8zsUALbP4K6GMViC83hBAmLSLv9MzYs0X2fv1tiS5GWd1Gu0L50SLWchWrgoMS5ozwF2QcS6TFnqM5gl/YJzYlnT5UMyWP+reM3XLlxYKtNrY36KKCIbQf6K5ED01qpaxX40g4WmlM1eINauEGPppbYTLuf7jSOuijWiUyFIg1LuA/4ebvCzEHRiFKC8xZwpcMVF2rpNMaobBi+h2Epc55z8LHC6UsApb+ZZHoI2PD7kpx9dZGsF2W/4d6dNNl9oBp2uoclxznjct/DrlRoz2Sw95EO3yFxNvBpMTzim16HP6M/NdjStFaCg1nVAijyLPgP7KEIS+UUSxVvm64uEueRNqouFziAU9TkdKjuDSSwHtoElGDV4+Z5x2CzkKikRU/LvH346opZx4glgcsrU62lbR5w6MgHzIN8+QYy2NWqPXTx/c2b1lsA1dI8HbN7TtVgQHxhE3HyL9HDKVCkk1AiUHe8jzLbAcpbosl5eyOoyp0azFG4ujiewKzBWmo1Hzn8xH6VDTtklMxbawGTDURy0Wa777bI/OEFntnhCLbAxAPyBH1IYK+10COd8qC/sRrW5PrExr9SRpN/hZtzQxRnop+UwENJBBObgYDAnSdZFUG8TechLeAQO/D8uk3MNwEdfPCuu1hSw8R8unJ3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of checking i_private_list directly use appropriate wrapper
inode_has_buffers(). Also delete stale comment.

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
index c2692b9c7123..6f892abef003 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1422,9 +1422,6 @@ static int write_end_fn(handle_t *handle, struct inode *inode,
 /*
  * We need to pick up the new inode size which generic_commit_write gave us
  * `iocb` can be NULL - eg, when called from page_symlink().
- *
- * ext4 never places buffers on inode->i_mapping->i_private_list.  metadata
- * buffers are managed internally.
  */
 static int ext4_write_end(const struct kiocb *iocb,
 			  struct address_space *mapping,
@@ -3439,7 +3436,7 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
 	}
 
 	/* Any metadata buffers to write? */
-	if (!list_empty(&inode->i_mapping->i_private_list))
+	if (inode_has_buffers(inode))
 		return true;
 	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
 }
-- 
2.51.0


