Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EFB1EC1426
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA8856B0129; Tue,  3 Mar 2026 05:35:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B69F36B012B; Tue,  3 Mar 2026 05:35:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A75496B012E; Tue,  3 Mar 2026 05:35:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE016B0127
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:35:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 564A28B932
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:59 +0000 (UTC)
X-FDA: 84504396438.20.2036AC5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 253E71C0004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JZGRSCzVw+dnMxvlEGqz/JeWA6SU2+LFt85FuvrPTw=;
	b=7xbTVutwAshl//YS9MombalmiERDct+7/D1yDXYnPZaeaz6bqvTlVvwu2EL988nCs6kQ+G
	murYjZfd1Hr5dCjWHt24Z630Aw1DTSvmn3pCcDEtonBrFbOWxxA3XH62/rRRoYjSbVPgHc
	mvsh1nTRZDRJRvwvzAMQ3jg13VSe4UU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534157; a=rsa-sha256;
	cv=none;
	b=6XGXvLzUmAAy66usKvYAHpDKKc6Z2JgGYK72tp/y8H4KVIsQytedgdS5D76oiY3UQBu41s
	q/BhDlNlHmkupoUTKzrVuGmoUtiQf3HqtxF/0Czjm+oDdn6DDFsstyPB0UPK0zncjNDrSZ
	X3tlN51KRt5S8uanHpQl1ALMjVtl2gw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 447483F93A;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3639C3EA6E;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WXk3DUW5pmmHFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E8EEFA0B6D; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
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
	Jan Kara <jack@suse.cz>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH 20/32] ocfs2: Drop pointless sync_mapping_buffers() calls
Date: Tue,  3 Mar 2026 11:34:09 +0100
Message-ID: <20260303103406.4355-52-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1308; i=jack@suse.cz; h=from:subject; bh=ud/28G3xYrWf6hhDA8l9j5Yn2n0f8oX/rNwQdYapQHM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkvRii9H+t97Y2LO0i9U30mEMXFAbwMkKJma eYyaJh30hyJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5LwAKCRCcnaoHP2RA 2UAuCACl44+oSXoKVpLMMjiOlzsSYJhi83OocmKg+n6aNdrCBaLaW5GL4UJkAqg3vGC4NxBSbVI dN+/zOKfB6jEEZavQOjXSs8gm3yTIzY/LUR2vkI3wARuyz6LfXqRMAOyfpEsPatajFUP3/GJvPg 9WohJCCNRhEOI5OhIJNpNBD+A9T7KF7yv/pGurqHjAasCRN7RpqBbyjc+5HjgLrHFxZll7hf36I pJY5vGfgxZ+de5q3Sy9Atdq7p8jGPM6/TvVmtqdyR1M+Dwsc4hMMlIkeCu79+XMSCWy6wD7P8j7 yHolzEvmVH4b0K1tZQ3OEumtFv/IfIvFx2yGiie9QmONH6Xd
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 253E71C0004
X-Stat-Signature: z1bgsbdpsmk831cobkbq8kb91kccxdso
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772534156-395378
X-HE-Meta: U2FsdGVkX19CpYHcDIh0R0J/+BFWdnEUAd7iNOLREH0/jzBCfkgxp/kJhVpcJzykcwKnSVvKKgbQ2J8JVFC/QjnNigixKgl5S+QwmzC4g9tFIvlvia2l5bLWfhYqTSZ4LqBxbrBQX+Nkid7B1c0M6t/KLOtlj42+gfOq/B9CH5LD6YNCQ1w8PgSllM7ldzy9JhkJnAwMXzE/EfiOuzJgAfgni3tFaJF7/YInjTmkeVBb6HQhZu1ixqje3MK55BZjaGpDz3jz4pFCrb8elxSH9n/qkBUQdBIF6H/LC0nP6VRm0IyZ6S/7dHhsofiG94nBRL1xiUyU4WJcIyD3He5IYxfWBtnrp/eiPguoxGeislKb27w7AiPJ0dVDxRYvNUrzP7C4WkFYNPUi/PBLCzR8pE9IN6jqBwhyq+jEPBqwwdn/tkacYx9nc8Cn9BHCv3LdfnAkOzoaUV1q/7uQvjCe2zR7z9JAwaC9IGfALyOIBn0QFiE0HDAFQPTj9xKE7vqlXHF6DdzYPerJ7uQfOjAMV+eYlnDJWGE5BsYodKkcEu6FOXg0Ti5eLzTbyzGimaskKUSn7ctH+q3OAVe9Xze7sji90VG0B3RPeIPXqHanYv/tUrzkwaYSHc25ikGDWgJzl9vRr4B43wK2wQOvRAZkxoaJkvYLIGlOsy8vA/apYpbvakkEtvpyAN5UT4NgIb1JZr+ibzsPRgXGju9eLEhiaR/+rndR7o18TFjWl9jJQfVLTYeeEgH1h8ebf6eAfKTPj9C19H86FIwMuTOf0oRvwgb7x73iTL8fDmBY3QPzQYTDqojxlNVA0ZSit5M263FOhROX21w657VPdaowjESxo821BNxlsLhJrlzJTBhwxPsGJ9/vyghj4wgxKPhEjLUhaXrbmP3134VwseVyvQcYRuS+x8f1yJP7Mzu3IFeTkD7kGArZ5cy1z6GjqOa8yQMs8riggDCLLkLUQT6ebMB
 ffBtm57B
 hPdI8Rs1QJCcXxQ+JsiRJMPQ6Q8F9owqM8eFhkVj4dYSWOADyDM5YGCD2zF6+18MgJ965wnsvnSRA4Fz4A7IBNH8lXw2b7KABOTGSUsPnQ7PfiKnN40dBotHS9LyHOvZPDkzO67PQTC0mu6wkEknJ6DYuSXtpLHdQJ6b90BDkL1qU4b0SSDp3mLgMhZ7cHN4XACOJXlSYGnJRJtYZec1h2hkCARf9lP8uOFVYI7bSy6vOqJ9T00+prWR6GbOhpH6D6svvezOQ/pSKtq17OjVGg8oGBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ocfs2 never calls mark_buffer_dirty_inode() and thus its metadata
buffers list is always empty. Drop the pointless sync_mapping_buffers()
calls.

CC: Joel Becker <jlbec@evilplan.org>
CC: Joseph Qi <joseph.qi@linux.alibaba.com>
CC: ocfs2-devel@lists.linux.dev
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/dlmglue.c | 1 -
 fs/ocfs2/namei.c   | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index bd2ddb7d841d..7283bb2c5a31 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3971,7 +3971,6 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
 		mlog(ML_ERROR, "Could not sync inode %llu for downconvert!",
 		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
 	}
-	sync_mapping_buffers(mapping);
 	if (blocking == DLM_LOCK_EX) {
 		truncate_inode_pages(mapping, 0);
 	} else {
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 268b79339a51..1277666c77cd 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1683,9 +1683,6 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
 	if (rename_lock)
 		ocfs2_rename_unlock(osb);
 
-	if (new_inode)
-		sync_mapping_buffers(old_inode->i_mapping);
-
 	iput(new_inode);
 
 	ocfs2_free_dir_lookup_result(&target_lookup_res);
-- 
2.51.0


