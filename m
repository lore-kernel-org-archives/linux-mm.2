Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39D0EC88E54
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:52:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1F2F6B0096; Fri, 11 Sep 2026 04:52:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7E616B0098; Fri, 11 Sep 2026 04:52:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F77F6B0099; Fri, 11 Sep 2026 04:52:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40EC36B0096
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:52:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E282180157
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:52:10 +0000 (UTC)
X-FDA: 85200864420.18.5E84DB8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 99C851C0003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:52:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=st1FxkHp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0bbW30OX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KbOpvMfq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ICjy6isH;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789116728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dz6C2louXbYTzx8xCxkNV3bt+061Wbi54iimb+Q9SME=;
	b=kErna/aDmkkQYNa4VH3+2f21RdaVphYgEF/0CJEtiKNtEGR+9QiRiADFeXiygY+UX24MHc
	bdzS61Ty1NuRj27Ma6PXzG5hJH8uY102CmZ2FHpcFBHvNLfFB9Icrp9ueGN9pLncU91xRH
	G9Q4L7+oAWSSe1NCZ9DxPGOfSHN/kSE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=st1FxkHp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0bbW30OX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KbOpvMfq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ICjy6isH;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789116728;
	b=Hpi2Qry3s/bKehcreZeDVNmCUtpqOn93atK7ovEGoPtrYS5X2P6y6tJ/1C81EppLw48LdP
	diEc5oUtY1sUCj9j9bD55Z4AMxeTUzKbybDYSM06jDi6tHpgWZiBsXFQtOGV1BeEq7lqLH
	1G/InogEZtFx8W3D5Zmbs0FLbb82r5I=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9D7A021D33;
	Fri, 11 Sep 2026 08:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789116722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dz6C2louXbYTzx8xCxkNV3bt+061Wbi54iimb+Q9SME=;
	b=st1FxkHpLKZygnEUBYPlh/AesXJkGTfNrIUaaH0N+3JkEQ4QuDFL9PZdBBKBlpEoqAVgew
	kDf82GS1kvkUgxMhLRJqun0q9fR1A8ahRnbDlVY4ldycfv+2oTKxVqd095BV1h/R9uHG54
	mEHiBkEcfyKuLPZESjgd1JYuKYF8nZo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789116722;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dz6C2louXbYTzx8xCxkNV3bt+061Wbi54iimb+Q9SME=;
	b=0bbW30OXrCXZxdM03u9STOjde++HznqxAZFAdZo0x2Zp7hM8/PRYSSWHGTaMuI82nyfiAC
	Ukpk8n3jA9sV5xDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789116718; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dz6C2louXbYTzx8xCxkNV3bt+061Wbi54iimb+Q9SME=;
	b=KbOpvMfqc9jsb4/1MAy1bQTj2Gk9NQ394MgyUW57y4LiFXOdvLtGy010gjaMsK2y4U4D2p
	LCMzu5BVoa/j6BJrKVeevL1ovgAXn0VSYIwgqFzUtNF4tQjQ9E9RrVVLxoPOILJLoOxZHf
	Xxu+Hue7CYSbsK/eESekyGHgMkUg9mA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789116718;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dz6C2louXbYTzx8xCxkNV3bt+061Wbi54iimb+Q9SME=;
	b=ICjy6isHfvoK/KrXyuQz0AlZtp1n4XW4iaKpqvlMv7ZT34+XwN63zcAErAPKcOQbttcU+w
	GgJnnXqQUk7PSFDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5959C13770;
	Fri, 11 Sep 2026 08:51:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id q1LIFS7Bo2qwHwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 11 Sep 2026 08:51:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C30D9A079E; Fri, 11 Sep 2026 10:51:53 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 1/5] writeback: Fix missed lazytime flush
Date: Fri, 11 Sep 2026 10:51:37 +0200
Message-ID: <20260911085142.1774803-6-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260911081309.14137-1-jack@suse.cz>
References: <20260911081309.14137-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1480; i=jack@suse.cz; h=from:subject; bh=avqoHDTNDP0cr+11QWk6Aa9K1cFRty+3fHmLxPaiUJ4=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqo8EfRGeRkQdTdJvHqmm1VeT0FuPNhKPDbcqMI fRgMInHWgiJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaqPBHwAKCRCcnaoHP2RA 2Yt4B/4hrEuD8MXrdckW6oSMpK+y/q2VrKuwDqDBvMrXlCgYkmvwwmR9kzc6D8FoRdU8PmVjTbC GgU1P7kjv0pq7LDXTd2gyHFO8SrDOpdEdjoSRHOM1B6qUyPvZoQENCVq8S//oomjqX5xRyZ4nZT Au/QsMQcZzvc42jczSZ5DwCxVSZrO0ysjJfRWnMd2oR6SlWpTlKGEOcQ7+2JgSnyPbuu7r/W497 QBzMCKr89DISfcXNfADzTcgJNgMLkSktsOBVaXe+HT/o555AnZh6pDocY668gD+XX5LnQIEPdrU LXxq4nclsDtyBGT3J/Du3rg8879NVl2d7dy+g6R4+cuNyLKT
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 99C851C0003
X-Stat-Signature: 7jwmnp74kbba6f64o6g83nbheqywq5nx
X-Rspam-User: 
X-HE-Tag: 1789116728-108322
X-HE-Meta: U2FsdGVkX1+kcLq7DbwfFOkCxmFj3jlgymx8haxiPg+PfAV/81Bi0MscJRdVRqWPP55PecNScqE+0HMpngCqWKPeOaZvLmod4+w++kpoO17NdIw94/yJ6EaxhE4DLEzAdLJ/eMBJPf5+RVWTaIB3/87rq899PghnTMaHQynw5mEhRVmOweQS3hRdjb5eWrkrA/KstgIFFgJFCmcywDANsKgywcbHPV1v1RTN5wKqwfFLVbQdQT1OGhVV9/d3Pw113npo8Kwfe4X1XDUVN0R9EfM8pvDVbotPGmewCRhMeVzq+8E4W5DYBdBT4v8up0Wi7MWv0BX/xFWnwHg0AuKUwWwkS9IwwI9ZBhcJdSxTKykQxhnFF2mni225ON/wV1zD5nnzizgbQrUKa1VfvT+FUNW3sMAujB38OKA2ub4C9Z2w+QjqCzrBBXy6T78JJsqWsughceQz9TM6nBuyLfoutbKQpFEE5aRw19mrmmyNtccJNHdXMBxgdwIsV5DHnFTnxzpf9AFTGWi5+AABzxzdIvMLVwIxAs9UP87uHb0QwH60e0/sklbb6cbwdeIUDsNJmPpHLUTFsGJfZFABsg1PmDuumgqn1vZd6SIvZlFtQKmyc2EpC2Sc6YMP/rgf0za1tVKiXygnwEaaMR8wvfQbUB+bAkpDiuxtRFlaMwvCJThXDsuSR/JtL9GOs3bGCK3de92sG3Ex924hzcJKsaOc1oLDqfspyKVvDPmzudAz1XxBq5FtjJd0l2ItFkMn8xpo27+/kWaz9f+aiRVnbr+LIDNYSpGyNOtziX+/DPraAdF2Mf96ufpmvY9mzyjS/jJDJZk9uTwUg0zhqn7MmYINDMZ0YC4y55vgZJbUA8VUAJen3noycfd/5fe9MedtuYlKBWhNCeFhHQvPSFAjeiErdAwIsvokCN3dTYOcvCLr4rVp5Rr0anpf2+uvnV3RfbIPxxPBRDAodmH2g7o65ve
 Ppx9b2z/
 wFT/nBdyFGr+fr8wHyRedFXWzz0juUYT+K2JFrcEbyjBj8jai7XWOnfxXJ8FqvQuW7AY8WPS8fdOZzAn8pEs8cEZQhjNAr/hvA50rSWQUE2+B7+lykBGgPY4StuqFvMASV6j12WWT+mwHZfr8Q+bKFZKHijo/jFPqhZGQCXQLjkOxcR9I10ud9LOqHA5eKc1bN1rDV29tomM2Y5N//SlWSFyIqWG4lgm235N4Zw1WHFkgdLg=
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
index e744f9f9d43f..bb4546d147dc 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1807,8 +1807,8 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
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


