Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38FDFCA9ED2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 08:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39E486B00A3; Mon, 12 Oct 2026 04:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 324C96B00A2; Mon, 12 Oct 2026 04:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 179C56B00A2; Mon, 12 Oct 2026 04:24:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5E856B00A0
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 04:24:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51833C09A0
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:24:18 +0000 (UTC)
X-FDA: 85313286996.13.3A96C9A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 426D380007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:24:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791793456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aQMzDY+7fJOT9W+ds1LqpoGfqIZ2LhEUMZ07VpO8TVk=;
	b=609CIgEtCYSKy0kP9/ZXxIlv7bps5JRB2ciov9sWXXx+xKhtk+cJzbxYVCobx7A7/5VZEp
	O0GgPKPEkHsD5SKuUlwH3JWcVlHUn97WnaCi5sTFEXW5z+4LC4Qt/7m1bo95ZuaIYPh8oj
	FqlQRJoH1nrDU6Cg99aYL/hXD8Cf4/Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791793456;
	b=fjPVqhz+1nvkgXagm+v0jcnyTlVOsZDTGt9QWMQfoG/itgjF0z3zJYVmKZduopvojjLDOk
	5yZNw0ZpItd9rcMCwMAubLr8Y5wKDkPrK2/1kfTtkXZ/cnex1tKZvKqS1BDOdkSPYzNg1p
	2onjm+7EvW1jScO4FzQr3rJqpGpewM0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 45AF821E5C;
	Mon, 12 Oct 2026 08:24:15 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1F55313794;
	Mon, 12 Oct 2026 08:24:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8JBtAS+ZzGooHwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 08:24:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 92664A13DA; Mon, 12 Oct 2026 10:24:10 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 1/7] writeback: Fix missed lazytime flush
Date: Mon, 12 Oct 2026 10:23:39 +0200
Message-ID: <20261012082356.3121725-8-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261009133253.20102-1-jack@suse.cz>
References: <20261009133253.20102-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1480; i=jack@suse.cz; h=from:subject; bh=E5x4LLXUVTiIuVjqdCsPtbdXFw5ngWOMyZaNI/eO16c=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqzJkdC6GVFu55LPDESjRn8rfzMStU3HVGXve84 EoyLfs6eXOJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCasyZHQAKCRCcnaoHP2RA 2a1dB/4zZKx6crA9/G+2ui9Y4XyE37woa98Yo4T+xQ46jU0rxLR96g4Ah6Hud0186d9ELVNl5yX dszJ8HFxwG2ZXDZIa6G84Py0LJK6z8qtqUcndiS8+Ito8tAbFNLWjojWcqETQKuoiTzPeN3nqGB 0qfzyMi5QGT0o+3sfg5/tVoMhe/42dOKokvh6rwAeSGDwNla99vkWdIuNWRCxhK51JSZdVADNSS BW2a8ugpsYvryxpPgWthNswzWr8Q96someoE7DBHAsO0O3sFC+Bxu6SOUZVP8Z7aPYFNcAq8a/x c0mU/gLeJeEg0W13SplLALGUpSa9QA7xBzp91k9BE4fKvk84
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 426D380007
X-Rspam-User: 
X-Stat-Signature: fttt8uz3m8p9q3qxpmh4nkosy79bqkdf
X-HE-Tag: 1791793456-118732
X-HE-Meta: U2FsdGVkX19i0Fb2g8dup1ohgBBPnY2PslcgfB0eSy361ZJXH0FLyLM4mV0Cz7KuGecSNNnjVtq+3h6YzJiZoelW6000UM0qS1ivVhoSorTHKY91wKDRaTL4sKodRNlELjjPjcTzrSh93jcfbgQGBkVrj6u1Q+jey+q2g8+0obhpU/0ZTW4uGyN+m7xjliba9ztBbJpIVjDXU1AtMJQcWDmw5sh4d0v5tkcS59CMMU1gtsoc27egWgz2O3Cva02Z+FiLUl8nasGjmqgGVXhb/vB51eTKEk+hJbkYUXirPHmuHST6193cgc5/+WgOLDTmh2IN5zZSncvSnt5hPjtyK5OJiw5pPfLP6sB2NbpYmoOXDPPmXQgd8lT4D+WL/XQqVq3SgNSbbRIKMqaxGHt16EXUBBuKlAdCht09FfHqc9V5oAUkUIHr8yXFakcSon1GGmCXeCpQK5jkswvAwpNZAuEDUmQ4zoJz25ZGs9bS3G8cYheTWfuS7DoeHKNMZ8vWsFypa6OAWpvEkO2tUQ5s/KXkMTYM9W7WC87mDg2CgXtWVVBfpFAdiQ7T26ArJinFFTkgx4LEsezLMc5/SSni2hVlkTDwLj+h5I8elSQvOkCI8qml2egXDZEgAYxuwrU75Y4dRFuMKkqYib9GNXpH5k3Th6ni5eocK8miGu5TCBCiX5Dk/BRNwJoy6ml9Ph39IOQN2evYpp/cchAWlYxMqBQeD1VUJ0nX9a289NgepMBQ3CImDjJsXMqm5GMDIROEJBEfaCdy8iIrgICn1VkUzcOWYKIa12+i1dJa2iq1GaQh0LaFvHd0+x361qhmjzOx7bt8MQ82GIJrz76hQvFp8qGm+cHVJAJObWDjgRmvdH910OQONX/F5zVbwYRBhGokNeTA7QCMGQUyXn6M0kJhRbhz5F9L02XK5WA2W+kDtj40ZCxE6Ehj2Ep8h1kESfFz8AUXMvOxQmgdonixlVe
 IqQRAYQX
 xeppzC29Ikom8wavq+uITPnKK3k5UP9dDtnwDSALF+MBjJwKw+fNxqGIXFwWnlsGk1sqOtIXh0DDW1OI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index ea3eb40bf828..f6fe797a41b4 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1822,8 +1822,8 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
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
2.51.0


