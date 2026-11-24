Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEA07606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 11:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=qqN7+pit;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=YgiKa8gA;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=qqN7+pit;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=YgiKa8gA
Received: by kanga.kvack.org (Postfix)
	id F09406B0695; Tue, 24 Nov 2026 06:59:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C25DF6B0693; Tue, 24 Nov 2026 06:59:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A712D6B0695; Tue, 24 Nov 2026 06:59:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3FA26B0693
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:59:11 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF6D6140B32
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:59:10 +0000 (UTC)
X-FDA: 85469866860.19.0B3AE69
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8104980005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:59:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qqN7+pit;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YgiKa8gA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qqN7+pit;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YgiKa8gA;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795521548;
	b=KwSyeMyXU4d352TeAs333z1kI7spYKTmBzwy2CsQRElLj89Vm5kGTGk75lApbJM8/Hz9MQ
	3mgZnTlFSHTZotS7eMLPzXbsdwayBdNwpgDyX1aXhm+N53GA1D1ozK/QUL3Z/IrRzDXdt9
	WTD4vwFQxta7nalYlARQMxpkmrHuOKU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795521548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F8rZXwgteqbZbs17ttmtOi9dk6Yv88pwn4UCPhm5Pu0=;
	b=6W4fMUSdUiKHBpoRDjQhaS5R2ZmfSHZPJMyFgGw4kAqwpfL188JRLrfilWuF8UQY99YueY
	Pc2PPNCXHFyNOhOHoqdYCzcQx6YwAREa0mON8CCgMVCxmCP76R5S/WlZIoVGlAnky6poxW
	68IoJWjHZQUpuX/eZVHoGLyv9eew2dI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qqN7+pit;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YgiKa8gA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qqN7+pit;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YgiKa8gA;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 45E1422244;
	Tue, 24 Nov 2026 11:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795521547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F8rZXwgteqbZbs17ttmtOi9dk6Yv88pwn4UCPhm5Pu0=;
	b=qqN7+pit0cJBGQ/CO9g9Ef83VzDK+aDh1wVlT1UdoRFmiLGsWM0EdCMNUvulbyvd91V9fK
	KCbw7WqWOXkJgDsb6TuKlyqEZ14EgdtUFU/g4bTmeEGqkA3XvHlKjfsOpjiB6olM03d4Wd
	9HKOBOtX56K78WeoWcalw65v8uK91Lo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795521547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F8rZXwgteqbZbs17ttmtOi9dk6Yv88pwn4UCPhm5Pu0=;
	b=YgiKa8gAaEZBOMiynYKCrMLdT6BFP4sWMo7WwRRM9JrigvtclPlAdVEQNn7m0HytdzVaC9
	gRNIbRzm1TVUKHAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795521547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F8rZXwgteqbZbs17ttmtOi9dk6Yv88pwn4UCPhm5Pu0=;
	b=qqN7+pit0cJBGQ/CO9g9Ef83VzDK+aDh1wVlT1UdoRFmiLGsWM0EdCMNUvulbyvd91V9fK
	KCbw7WqWOXkJgDsb6TuKlyqEZ14EgdtUFU/g4bTmeEGqkA3XvHlKjfsOpjiB6olM03d4Wd
	9HKOBOtX56K78WeoWcalw65v8uK91Lo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795521547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F8rZXwgteqbZbs17ttmtOi9dk6Yv88pwn4UCPhm5Pu0=;
	b=YgiKa8gAaEZBOMiynYKCrMLdT6BFP4sWMo7WwRRM9JrigvtclPlAdVEQNn7m0HytdzVaC9
	gRNIbRzm1TVUKHAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E2F011352B;
	Tue, 24 Nov 2026 11:59:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mucAJgp8BWtDZAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Nov 2026 11:59:06 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id D108127847; Tue, 24 Nov 2026 12:59:01 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	<linux-mm@kvack.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 1/8] writeback: Fix missed lazytime flush
Date: Tue, 24 Nov 2026 12:58:45 +0100
Message-ID: <20261124115850.3512-9-jack@suse.cz>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261124113450.3451-1-jack@suse.cz>
References: <20261124113450.3451-1-jack@suse.cz>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1480; i=jack@suse.cz; h=from:subject; bh=tLXfmzOP5aDRq6/jjTuDwN0YV3g4qhMuQ+lBEQh65LU=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBrBXv6DckjefXnIPfvqV9LY2Om2mltH57I/iZxn kiceOSv+1CJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCawV7+gAKCRCcnaoHP2RA 2TbGCACLhrVvaliQDB+Km6NTkFURoQsVTlJbuEaQqzXe3iYCpnUN6NTmoWgWzpGRnPUW5JHZo1v rozd7lU80kFBkVyLqV573vVQiaiejmEjwar9+j0F23pp6JqZxToxjrTZu0OYtC7pv5RhNRQ6sZe 82MGVhOZlZbgmN9i9dFMnjTk4AH4ufTXx3Lb7Dh8MiWy4Gj/q51cl4Tt1+184Z+Vq/LIseySzXA QIRWJRBk5POZwCwUZHrngfT0EbdNDGBmegz+UvuJUdu2Y5YKFGfd4yp08gFTSFllVjxDml2v4EJ SdU/Oo8Pamd1WzEP/WJaVTWP/FBuhTwNdZ/VnLuLTpU/drG6
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Score: -11.80
X-Spam-Level: 
X-Rspamd-Queue-Id: 8104980005
X-Stat-Signature: taan3tw8gk7cg9j8w5k71b6uh9u5s8qy
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795521548-880237
X-HE-Meta: U2FsdGVkX19SIfVarQb8s8+mSiZ2/sNehdZoR/aEmgpPJW1AXa+9JA83Z1plT6nnPBavz3V8jrAUrIgk6BDdIFq1bK52EXAndGTWO39MB/afrNdI8M7JyYnCNoSII92fnENg/A0P0hEmtlGjxVvROo3XgE5EbfVN7R1/LGa18OD5FSgM/Kkf5di82HzJMeZMXZ9pJBMTOTF1Y9Ft2lSjiuUVuoAQqnr6T0+NQnmgLTsICp4g/JyIoIFrtReySu9tsLm+KS7VBhAoWw02hdcZH55T9LZNvwkyUSjo37sMYHgZJVIalch5VLBCC7uIFPnSUDPFUMfGQ0wuLXh0WeSZQ6JBO4lj1JwrX7+xKMEqQJaNfk+8r4khV0qnGHMlvyqYIgB8RKjoy183Qts/oxxVxXeptMSudnHdAJZAvg788izSkevpMk9r9kzJh4Vc503f5aiUY+A16uqNDdjNJ4Sq4sDy+1B4lWzOFZ6Ah3sEwjV1323Wmph/APN0ihg1ww8kK4VmzpC86cXC7T9fcV+VY2XsktYizww+y45wnwtPx8jSSxryEFaW1Zqqqr7mK/PbiTytXjyAJnJwG+9n3n7NQK9oL0W5Cu0mcL35IH5sPZTpicql7HOwp1rrHnD/k/2Xke4dVEPqKTinMvlEKOdEM64dMcc9fQDfPnrDU1l6R+Ak6XLyjdgCwAV9TaYyRRS3n05nTpzzAnXKfxgQ3Br0OyU9VacXznSVaofzdDtvKDzdXDE3feQk8E99M7Itu0AT6YNYg9R3sj/hUToHpFfP5W4dVXCQ0++nZf68SyUxJ0jk8K8gtLLtEyA1VCE4uPe8dOAeUgAQxvAfyrl+P9bjJByeVkYr4FtnJWkqglssyFdNHqgWD44yr0HZUKOYaSGBteG6yPnwW1Eq2GYM4udeIut3pBWom99/PWhXmcPcLBnG0wo+9Q4ZrzyF7b08nyG6Rb82+nU+d6kZetAEwZX
 IXvclfMS
 9oz1le8oIvBKDm2c4Q2ZhV5chrR3zo4W5JTHDPpFpF3UyHyovVVvGd9vb2M3puo58+FICdPc7R+BeQXo0bI10MsHu0rmm+QpmVzj3L0JIVAOKxM6/haCDBM7JaIO2WdIdesnJ+YLpOIcNOnacjGPyMLcTilYhwv/J3Dn4ygD9sU/k4n9tYWYmxFPh+86iBH6278uXZuUb2JVgAenpVyNdo+AaIuZP4GVeOYtOmYp7eEcE+mqcStkc0z+hlh9y4hrSfjbHtt9kTXnw75WiTsGTQ9PVj8Jaxhtid/HGDaONL+CzSUKPqGxOjPEbcl7QQgQC6IwFzLgLZgP8mjamAkTpIsLz4Xl2L1q+Q9I+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

move_expired_inodes() moves to b_io list inodes which were dirtied at
current_time - dirtytime_expire_interval or before.
__writeback_single_inode() however calls sync_lazytime() only if the
inode was dirtied strictly before current_time -
dirtytime_expire_interval. It can thus happen that inode with dirty
timestamps gets queued to b_io list, then fails the check in
__writeback_single_inode() and as a result is just placed back to
b_dirty_time list with a refreshed timestamp and so timestamps aren't
written when they should have been.

This is a very difficult race to hit in practice but changes to how
dirty time expiry is handled on last iput() will make this much easier
to hit.

Fixes: 5fcd57505c00 ("writeback: Drop I_DIRTY_TIME_EXPIRE")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index de77b6bc1dc4..65b1af2879e8 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1910,8 +1910,8 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	 */
 	if ((inode_state_read_once(inode) & I_DIRTY_TIME) &&
 	    (wbc->sync_mode == WB_SYNC_ALL ||
-	     time_after(jiffies, inode->dirtied_time_when +
-			dirtytime_expire_interval * HZ)))
+	     time_after_eq(jiffies, inode->dirtied_time_when +
+			   dirtytime_expire_interval * HZ)))
 		sync_lazytime(inode);
 
 	/*
-- 
2.53.0


