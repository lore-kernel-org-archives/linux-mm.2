Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86C5D106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB80F6B009D; Thu, 26 Mar 2026 05:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6A656B00A0; Thu, 26 Mar 2026 05:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57346B00A2; Thu, 26 Mar 2026 05:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3E566B009D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:55:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C4DF140C1F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:18 +0000 (UTC)
X-FDA: 84587756316.11.8AF53F7
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4EB9D18000B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RKAYyvE8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MUY2AvQC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RKAYyvE8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MUY2AvQC;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+17yxWIPn6CuZn9atnS4u2W8d1qElD0J/x0UJG76tOI=;
	b=lGM2kdHQTbVtAPx370ns0Gy9dv0yg59dw2BrDcrlMsIX2vOt2S87dudwSrVKjO1pQWhKhR
	MBLbFtDTkFIN/ZnDd/0t4keT2XkxlG5CRBCm0fnL38ffO39G358IBTWLt0tzuwLIYE30p0
	riF7RdhdZCKu1FdFDA4kkzLbH3qGLKI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518916; a=rsa-sha256;
	cv=none;
	b=0Tn7GLuQElG2qMvnjSFo0kd1oa49eE9hwIDzzJjK0qp8p45Ls/vKS3yQ2K+o6N57OMp+oA
	CKYxBSwi06ZbjTZkWULyxlC9w3VEaMSZ9B4po87x3pwSpZHdc235T5Z83xMfJphuYCqPK6
	80QkWxFxAZ3Xx/wnIs59vghcMYqwmxc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RKAYyvE8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MUY2AvQC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RKAYyvE8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MUY2AvQC;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1AD4D4D27A;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+17yxWIPn6CuZn9atnS4u2W8d1qElD0J/x0UJG76tOI=;
	b=RKAYyvE8f4rg/xqehe+0qMO8q96iHmEjacdvA5xfQxeG6OoDugtqnd+nk83HsWXLJYdSFW
	aQEaBqv+T7cqE1qLrNMByVNP5OHaEZ7oQ7667RfJ7P/8YTgLDyBFjKC99X4WAUYRY6ba/Z
	+IraS9pP6I7VsmJC0xiMTgZnd++iuHg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+17yxWIPn6CuZn9atnS4u2W8d1qElD0J/x0UJG76tOI=;
	b=MUY2AvQCtqIM9oSeXHbXt8K1YIsq3z7FNM23k3EeGt3UEm/Kk7qC/hCA/Ox2FI21aSDQcQ
	o7MbgRwCbMxQFqCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+17yxWIPn6CuZn9atnS4u2W8d1qElD0J/x0UJG76tOI=;
	b=RKAYyvE8f4rg/xqehe+0qMO8q96iHmEjacdvA5xfQxeG6OoDugtqnd+nk83HsWXLJYdSFW
	aQEaBqv+T7cqE1qLrNMByVNP5OHaEZ7oQ7667RfJ7P/8YTgLDyBFjKC99X4WAUYRY6ba/Z
	+IraS9pP6I7VsmJC0xiMTgZnd++iuHg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+17yxWIPn6CuZn9atnS4u2W8d1qElD0J/x0UJG76tOI=;
	b=MUY2AvQCtqIM9oSeXHbXt8K1YIsq3z7FNM23k3EeGt3UEm/Kk7qC/hCA/Ox2FI21aSDQcQ
	o7MbgRwCbMxQFqCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0E41E4A0AB;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1Gt5A3ECxWm3YAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B8B85A0B6C; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH 09/42] udf: Switch to generic_buffers_fsync()
Date: Thu, 26 Mar 2026 10:54:03 +0100
Message-ID: <20260326095354.16340-51-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1242; i=jack@suse.cz; h=from:subject; bh=wPJ9zVJ4lqUpVYC5Ni5nLLn32cvu5QyHuHetHoyfP48=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI5xxrhitQ8Q7p/SWVFyx65EWrf4RlTbHdVU N0+Km8nwOOJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCOQAKCRCcnaoHP2RA 2dbUB/94BEZI5325tW+32n40xA8r9pbA84uXKhxYWGc4KSRwy1oU3pQ7ix2Ccou7tPo0oNFst/r 92A+QmB3LrqQKmKEQLWTz6INJ8w+lOGJWIsGr5nu/P/90KixvGNewBCeyGW4foOdlohHzfdskZt CCWa5tTW9VB41hqMQZPDkJoXJeZHvu1eeoXwVTzif9qrXTjrqyR7OBLW+T6SsalFUfbUfbHCqIh 7G1hbwIx9udjV1a4HMMkOTP6XG8usJ82XWVNU0Ix2RnYbFP5iY9DW/J7CtNJmMYDHuY6AE6bHwj S2dUY9xxcsIL1jPSojV/APkX1Q4Z/ylX8E/eg+yax+BXShz9
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 4EB9D18000B
X-Stat-Signature: 518oykc96di3skf8ysp46g5f5ty5bgtz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774518916-925329
X-HE-Meta: U2FsdGVkX18BDW/SXtULP9zrTweGEiEnnxE0fCh5nvnf0zBQUoE3AcrEZDRjqR/Jc+Fgs823hRSoirORCt/f6fGhzdzmsX6Nb3VR5dglBDopACT1Dl4w3ReGXbXCRs8+1AIrPkBBN+cywxniu1tqU8/OSS3j6Sqp7ViA7NIiqyfvWF/GHGoNAWV+pD9C57Ps05lduXAazGj74M4+rucRFPgqxslM4Lp0RWIPzD+V1WTLV4WziRezIp0WwLuLxFMvhdGPR0W3bxjOqV7vZbqLwWEBJHkoWKwSqQwhcO7bm1zBsYKF53ICqCjKXbmq+1Ek23wbB2ZugD5QmPMCcjbvBEBN75Uf6NCyg6fQLoXaIsZYeguXyrSKmAqHklwgroHkmQ5Uhxu0MlgUvDBdKvQZHtqjWzdT3IdStXQthWPxWcB6PS16RP8oPFF6KHUsFvmiUbSyUQ+3V6BIzWyXz3pY7uaWkLIFg9txj370HFxdLWd9bzTpqYm84tb15AF+cyalZwvu8KdBcMroqBlu1RyB0VYukf/2EWafg2/tRtjBTFxxH+tmQ5tB35yU1v/PdMZNOzaX1F5acXAf7NpIFkMMA8rqH5zTSJK0l9kQci/dCmsM5bSKB6sJaxJBXKK2qK2JiFEFiCWUQEqcgxWZASXGkqRwooF+AuCxuJavb3N3M+mlBWrD2GM6vaKvCLn6rdPGsPiT0pyaSsA7GyUXH9sr+omKDrZn+v5KZ4U5QMLmwBPio0DNcvBmBlfsFIDqRUu+KrFkpKXE4R24a/0bYesn1M2K75M1zZXJAlLWuSWzeMp+hej4/hqmDmCOPhfOAv1eXXwuIJNjrUGWU9/Dd1pDnCjT6NYuRUar9G1dZDzNHwYwy6vBUH6on8Q5iYJy7wojptRsnF5M01qum3ULgBzXlooueEQuhdrGeoieKl+Sf4jqirXRu464z0TmNvacI9cCjJ9HR/VuO5e1iolQ4Q3
 s0zwqsJ3
 HgqOGj/LPDep1HmqCJgqYQYnCZ0XYVAV/6ZtSJLj/EfTuA7h40JJ67XwXe9VXovem4jkDNkMppSJWlf9G9eA2ctFTgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

UDF uses metadata bh list attached to inode. Switch it to
generic_buffers_fsync() instead of generic_file_fsync() as we'll be
removing metadata bh handling from generic_file_fsync().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/dir.c  | 2 +-
 fs/udf/file.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index 5bf75638f352..a1705aedac46 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -157,6 +157,6 @@ const struct file_operations udf_dir_operations = {
 	.read			= generic_read_dir,
 	.iterate_shared		= udf_readdir,
 	.unlocked_ioctl		= udf_ioctl,
-	.fsync			= generic_file_fsync,
+	.fsync			= generic_buffers_fsync,
 	.setlease		= generic_setlease,
 };
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 32ae7cfd72c5..627b07320d06 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -205,7 +205,7 @@ const struct file_operations udf_file_operations = {
 	.mmap			= udf_file_mmap,
 	.write_iter		= udf_file_write_iter,
 	.release		= udf_release_file,
-	.fsync			= generic_file_fsync,
+	.fsync			= generic_buffers_fsync,
 	.splice_read		= filemap_splice_read,
 	.splice_write		= iter_file_splice_write,
 	.llseek			= generic_file_llseek,
-- 
2.51.0


