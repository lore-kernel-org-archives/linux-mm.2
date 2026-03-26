Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B357B106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE0376B00DD; Thu, 26 Mar 2026 05:56:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91D36B00DE; Thu, 26 Mar 2026 05:56:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D31C06B00E0; Thu, 26 Mar 2026 05:56:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C28386B00DD
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:56:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C7691A0C65
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:21 +0000 (UTC)
X-FDA: 84587758962.01.1FEB30A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id CEB39A0008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hqLBQU7d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pCcdbmui;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hqLBQU7d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pCcdbmui;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518979; a=rsa-sha256;
	cv=none;
	b=Bmc7PceOL0PHoYVBd/W4y7261liFW5LUvbqqvkcJP1v/KtDl+SK8Omu1zrr02sDk8vW35c
	yj988DIl2E15of9XP+RF6Ag114VhYyWVYbKvV/fHofdr4BUH4GJU5Ior9YUdsWmiaEeNom
	4RtkBQIQE9+O1CT8+ZpM/i56q1+2M0o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2VN0idt6n96Vmu45gqkPTClQxBC+i1ol12Ngkp3rwow=;
	b=e3RZUJE5pDGipznBuozSkWdXERRR4g0vqFazfUqd+eHb6fNp2zsgJxz5P/pK7YUO8WisMw
	HfE7gslYWUoaATKqOoMv1bM/I3mMjACyJFM992enc7pwS935e/puvqmErx3gWdabS0KiC0
	XZblhfM2vrr5iAuheBC9poEdgc+dtRM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hqLBQU7d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pCcdbmui;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hqLBQU7d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pCcdbmui;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7C61B4D293;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2VN0idt6n96Vmu45gqkPTClQxBC+i1ol12Ngkp3rwow=;
	b=hqLBQU7d8s9AMtdxZk95gyXZ2VDZw8FFwi7t1ABbZA56aQlBA5NTJ3alF4xc/2hK/fjrsb
	sWfwI0toNC+sfvOVyAKM0vp9VUGZQsZOizNBMv9iVDYwr6G3Dq6sGmXd076eSnFjM+RSdA
	bZM1h8J3zOFDUmdzhwnURijYCKJrEpU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2VN0idt6n96Vmu45gqkPTClQxBC+i1ol12Ngkp3rwow=;
	b=pCcdbmuiCX2PtzgDNrgpyVaS4QttSR28ki4jT9WQcUSLcTubT179MO0q60LwYfwyG2tbZl
	yufkTnTxn+x8tUAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2VN0idt6n96Vmu45gqkPTClQxBC+i1ol12Ngkp3rwow=;
	b=hqLBQU7d8s9AMtdxZk95gyXZ2VDZw8FFwi7t1ABbZA56aQlBA5NTJ3alF4xc/2hK/fjrsb
	sWfwI0toNC+sfvOVyAKM0vp9VUGZQsZOizNBMv9iVDYwr6G3Dq6sGmXd076eSnFjM+RSdA
	bZM1h8J3zOFDUmdzhwnURijYCKJrEpU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2VN0idt6n96Vmu45gqkPTClQxBC+i1ol12Ngkp3rwow=;
	b=pCcdbmuiCX2PtzgDNrgpyVaS4QttSR28ki4jT9WQcUSLcTubT179MO0q60LwYfwyG2tbZl
	yufkTnTxn+x8tUAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 700634A0AE;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aXxQG3UCxWnpYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7159BA0C72; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 28/42] fs: Drop osync_buffers_list()
Date: Thu, 26 Mar 2026 10:54:22 +0100
Message-ID: <20260326095354.16340-70-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2509; i=jack@suse.cz; h=from:subject; bh=P2d2o5A/mRUbDC1tll4F9435kE5r2df19H6YCaU+O8A=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJKDavHJWR7z6TonZsIlZ9x63I6Wk1aS5X5k ap0qKlkOeeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCSgAKCRCcnaoHP2RA 2XI4B/9m5jDFDP7odiCDdIr7EejykCusvbqzcv5UUD6AoRXzqfbDMYOjbu4DnxiHT+iceGY1VFt ZLMpAF3whLABWHGOLipy7CSdo74LwlgQKozYD3+qUHiO4YbZHQ17k3GNKVBI5AYZbGwTGiqbBaQ X1ZKIEJsxXZzD5dIQK9Mk9g1rcl4FL/6WQYVZqcFr0zzSr4LESzllVSc0hFuxAoGuSN9nnyFWnd ZgMWTXLw+89hlQJFn2NfpDH20qjak6XbbOXT8FD7wP/7K5qIaAzIqIiyltkfZT8/GoaGiFzKHtW En8xcJPG67Lgv1zcRjym0gq5M8bWCz40/xz73/jR+ezsFtyI
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CEB39A0008
X-Stat-Signature: r6mj1j14my651k3iycq1dwdi5s76m1jc
X-HE-Tag: 1774518978-85519
X-HE-Meta: U2FsdGVkX1+jnsIMV/fQlt/s9nsedFGn/I4q8Dg/va/U9ztqHxWRZFdYiJYsZv0/FipVk8NDMGRqZFTPmLoiVCE/I0U+Y8d0BuuAKI3NdN73A07jlCxqRdXCraCuHarASOfzoT5/X5ruuesUc2RNJ5z1PAhMeAanRHY7/S13US8Zp3n9VeCusrIjNoWLgBzvINZO19OVGRCZpufW8EHoCF9IobX9QFZxQ13tkBTLlsW5l+UOKzdeV5AGqGrcwmepbFPIrlFHdz3+KB5powB5ir4IYxmEhtrcdI29dmWxGJvaSbYS6cl7GGNPGm0K+D0FWDNEf7o+DbsPra/oJ/oQSAAmHAHfuCH586HYpv9jVRRRIhhBrMxDIakrpc8umLi+rbzGXN2CyztF1KGDPINjHLw12DX12rIPzzUV8PgLiYLErm3oFGsm0QAC16mquQ7z7vp6f3/6D96lfeN/VYt+vFXKOUt1nwf4RQtSv8JZSgKhhX+MezmaGnvXZSOKWjnynY3Mx47bCm8YNcQRe53jm9JOH9ZD8pCysvYS22b0PT9WFKyJEjwvdSZKkrcsPjxwwfEuFSf88TStcd0uhcKTBsiO312WzZEafYx7IIPjkp8K5EgE/8VPU9GHrr7/LhJKeSnXFwOr1qWDzJ6dFzo8Gix78vTB58a7OJOwOE70fqpJq9bkbSCmr7H/2hrMe1a8G1HXYVtcROB3y0CKyX/pj3AXq38OyrAD7UWp3QrTJ5nUtvLCqj+uLAIL79JSbnHEr+7/l6FMqFfEzNkhiD+O73ImUH2Yld48k/EXp0Wfct/YFjqsvzIaoFXZX4WwCoCkBT7TTPQ3zpc1pzjvMGZk/b45PBCuIftZ+9YEA47YZNNAGU/Hk/idnkKIST+l2Wgrbuj8N7BgpuHKbIBd2T65IahY4QBGlYwGcyJ+XEmMPA+vQlTcBcEv7Ymy8+m6OkXhpHfn7ESatLnGkvZnNvQ
 PLlnrUs7
 3lWm+IHDtBKVQkpyrQF9ftmgWagJ9iyFCEdrQaDPaqd4OpqKD9Zu1k0LF0nJum+XLjnpT7P1ErPfQr3Y44+MsYOPVcwC0MUEGukTJ22eiqfM/B0wSKEcI1MywxCwt6UhzcFm3B0LhspdJOR1/X2ieiNVqsYOin9k0R7dfFIuF3AnALSVNEehgx0zuCEZ6ns/dGV491YMH08O0ouCaSWODodstwSJFhmEN2gosDCMEQRZ+VRhmh5wV8B51+psErA7m/KNMFZuXeiIAk6U/1DN897ShUtG1g3XdcUYnFIRh3GLxhfTyDdNnfRRayJE596VUhQkA65TFbNG42JGWoZdZJt4GQjV+7UbgB3QlMrsVr3fH8rQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function only waits for already locked buffers in the list of
metadata bhs. fsync_buffers_list() has just waited for all outstanding
IO on buffers so this isn't adding anything useful. Comment in front of
fsync_buffers_list() mentions concerns about buffers being moved out
from tmp list back to mappings i_private_list but these days
mark_buffer_dirty_inode() doesn't touch inodes with b_assoc_map set so
that cannot happen. Just delete the stale code.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 43 ++-----------------------------------------
 1 file changed, 2 insertions(+), 41 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index c85ccfb1a4ec..1c0e7c81a38b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -526,41 +526,6 @@ int inode_has_buffers(struct inode *inode)
 }
 EXPORT_SYMBOL_GPL(inode_has_buffers);
 
-/*
- * osync is designed to support O_SYNC io.  It waits synchronously for
- * all already-submitted IO to complete, but does not queue any new
- * writes to the disk.
- *
- * To do O_SYNC writes, just queue the buffer writes with write_dirty_buffer
- * as you dirty the buffers, and then use osync_inode_buffers to wait for
- * completion.  Any other dirty buffers which are not yet queued for
- * write will not be flushed to disk by the osync.
- */
-static int osync_buffers_list(spinlock_t *lock, struct list_head *list)
-{
-	struct buffer_head *bh;
-	struct list_head *p;
-	int err = 0;
-
-	spin_lock(lock);
-repeat:
-	list_for_each_prev(p, list) {
-		bh = BH_ENTRY(p);
-		if (buffer_locked(bh)) {
-			get_bh(bh);
-			spin_unlock(lock);
-			wait_on_buffer(bh);
-			if (!buffer_uptodate(bh))
-				err = -EIO;
-			brelse(bh);
-			spin_lock(lock);
-			goto repeat;
-		}
-	}
-	spin_unlock(lock);
-	return err;
-}
-
 /**
  * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
  * @mapping: the mapping which wants those buffers written
@@ -777,7 +742,7 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 {
 	struct buffer_head *bh;
 	struct address_space *mapping;
-	int err = 0, err2;
+	int err = 0;
 	struct blk_plug plug;
 	LIST_HEAD(tmp);
 
@@ -844,11 +809,7 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 	}
 	
 	spin_unlock(lock);
-	err2 = osync_buffers_list(lock, list);
-	if (err)
-		return err;
-	else
-		return err2;
+	return err;
 }
 
 /*
-- 
2.51.0


