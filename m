Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA362106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432EB6B00D7; Thu, 26 Mar 2026 05:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 410AB6B00D8; Thu, 26 Mar 2026 05:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F9696B00DA; Thu, 26 Mar 2026 05:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0E0E76B00D8
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:56:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A54BC1A0C62
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:14 +0000 (UTC)
X-FDA: 84587758668.06.0B8D7E6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 470CAC0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=p8iOQ7pB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Owqv/JHZ";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=p8iOQ7pB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Owqv/JHZ";
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PIk+3PM+jG2PiQ44UnRCyz0Pc5nehV9CBwg+OwnTyLw=;
	b=IrDTNtraOGqjC+oltZr7w38gEWVyDgu6sPUuQNUfEZQK8Icz7A88Rno/zzXdw1KejBdWDF
	Hgq8ll2/U9nZVziR8wj9FfpoIbkCOKtZH2ercI56qd54X2tKHWlC0uIP4M5Y0RALzv+zOs
	T9TDPTddOViTkAAD7rGZsNxYMFAjUmM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518972; a=rsa-sha256;
	cv=none;
	b=JTF1PUT939TGiMv/NP+m0BJT3+S39QlURqSt1z8Bs3RKxQS2JyDif8FCGw62qwG/SBuh5T
	F2wpQCGJX9a5n4Jhjhq8CxXArmhQgynl0RIeD3EDbQ2qPP45DJetq6bGeZf1jwFGGzR7Uf
	CHM1zSrB1qS4Xi4lX9SX7JRsTavE7FU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=p8iOQ7pB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Owqv/JHZ";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=p8iOQ7pB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Owqv/JHZ";
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 573685BDAB;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIk+3PM+jG2PiQ44UnRCyz0Pc5nehV9CBwg+OwnTyLw=;
	b=p8iOQ7pBdqUwGQ3YL+/ilzkYqAZP1tciG2nSXxQneodu2vKfuEFU3SqAomesv+Yg6oxbq+
	mHri18JeHvFJxOn1Ex6fzQ+hMHoFiUSZ7fv1TssM/mkKHqBY1IzdCpcHqYUylZLyY/cCAH
	ViEONCyMZGbFe5LgQzXywun6as961z0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIk+3PM+jG2PiQ44UnRCyz0Pc5nehV9CBwg+OwnTyLw=;
	b=Owqv/JHZgMzVHrKwPqZT35c7f8TzxqNw4AgUsRZVZX43xOsVz+WuOriHtSsLEGrxNliiWE
	CuiwCjrYdQSEEFDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIk+3PM+jG2PiQ44UnRCyz0Pc5nehV9CBwg+OwnTyLw=;
	b=p8iOQ7pBdqUwGQ3YL+/ilzkYqAZP1tciG2nSXxQneodu2vKfuEFU3SqAomesv+Yg6oxbq+
	mHri18JeHvFJxOn1Ex6fzQ+hMHoFiUSZ7fv1TssM/mkKHqBY1IzdCpcHqYUylZLyY/cCAH
	ViEONCyMZGbFe5LgQzXywun6as961z0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIk+3PM+jG2PiQ44UnRCyz0Pc5nehV9CBwg+OwnTyLw=;
	b=Owqv/JHZgMzVHrKwPqZT35c7f8TzxqNw4AgUsRZVZX43xOsVz+WuOriHtSsLEGrxNliiWE
	CuiwCjrYdQSEEFDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C3864A0A6;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OomaEnUCxWnWYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 27EBEA0C67; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 20/42] bfs: Sync and invalidate metadata buffers from bfs_evict_inode()
Date: Thu, 26 Mar 2026 10:54:14 +0100
Message-ID: <20260326095354.16340-62-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=801; i=jack@suse.cz; h=from:subject; bh=K9wrCKmeO7BfHLYf4wsyZtDcyuSx9fmOTys9wQHOC9M=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJDZOEr4SoMR6litD6xJZ9vyOu7Qv8MRlaIP MceIDomSlWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCQwAKCRCcnaoHP2RA 2YZXB/42YP7Y55EaDpqaaAXkNNjVhOyVgYsq2ctbzL0o9Pgx3rLeyxhvdd85tPf8dQ6MjO9YTrr rq8Zgxdyui1EW9n01iDbRmAnMnjA09nr6PVXbxxke1Swac4mH9vDoDvrQ80sqblQ98Qw+nEENol Fes3tvRdPPWkwXNPBbzgzCobjFsM9UkEGMcf0e9Ea2q0vGwG/afqblVYXG3A4k0C+rqvs2Jsfqt JcvzGFTKfkPIToKEbOQT3NZ4z79rx8Q+yE0fUTg129GAvwJxQamhFDN2rXLdUKRI3vcZb0DOuAI QQkQK/aLCUAGZeYARe4fs+JcaPgRiUpUoH384lvdKOhq0joI
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 8zpwgwabkqw4esyodfrk3qe4nubyo58q
X-Rspamd-Queue-Id: 470CAC0005
X-Rspam-User: 
X-HE-Tag: 1774518971-512561
X-HE-Meta: U2FsdGVkX19thjMj4iuKtgqLvXwF7mzoqjFJUMcXSybU76hSAxDMou7nfbcf0gbDgtaWeEiOw0fwCRu24FB1VOsWznpa58zQSlCdRahEX5qTcnzlHQohmj0b2vViYcuZGiaAl1nvjoCDjBlCP1w4BAnEUqcTaIsPnPImyFgr5JFXr6wKwA/4LCNSarLx85WvqgybWRSkmfMvkMrwWwl0cZGSXNgkC4X4sfXWtjGidktp/855hreh1vLDienjZUmDxdi16qreCG+aoEAUGBA5K+I26R22V3dvhTy3VLs8CvcL2+FvXKK6DMJaYrqFA3ebvJrN0m8bA+0lxlnhY87QUh2LQ2ZCzUhdDh81nVUiITiKtsV7TBJ8+Y76wH8zJO8CEQipmMKyxziZHn2P1ERwuI8Xpn1Hrfjwm270f1sQAqCE9ftGI/Xwj0OOwOAOTI92kRF3OXMYZ9YWjhREKFioK1ek7YFugYuXUFlpC7BEwTJlFLtr/E01OZYVnxk83fo2m4jEfpbYKeI5jZ2LCth3Eqq0FSFlzpDwjlKUUEYIHQPzTsQxj4iuIFbptZ/72rPs98pYNomTQVLH3CTWquYOcbRjlu1bt3bF5PNSH3F01qKClbV+e0Sts7dJg46/Uyd1h8/vEil8tJNYtFDdeuS1cgyHHbGFrNzex+i4hfsnLkDk+32LSnocF78cPoKujU0qNug9myXLjDGTq9MMbL2iSeVZd2vWU/FdebR7WZPKYAotxyHicGwJWu7fPiOESptcLLIjtWpn+0tPHVeFVQ0zA1cf1iLPY3U6ec9R2U/hhaNUJCwYJF54wBVZ5SArzJVsFgNRUr2zCe4YU2KOUgaIWpTmA2fwOB+ISIzqq0RnN4eVIovvpkIMK2RfvnumOJyeIawQpr2/7AhgU0+I45iwZyiT7gHh+WYOzrqyu9765IN39KPkjQ44nbKhnGkqOuXI9psU5yDp4X/YDthqd9M
 8rFArt3Z
 eKtEP37YDESEHU69uhFLnMKO0uT+Cvaqx7DvH1thgF6uklemmgOeO5j6GUoa1Xa+/v4Kr+hNdX3Z0NoNWMjwCmQSfwdWmXtxswDwgFJEQthsKUIK65kgXL6wopQd6NMiavMvZtqhXPKA/WCa8TFjgjjMquMknR1iFRgZBg34Qay+xrykGS6kvZpx40RHqjDQOa83Tyl2UH7GBi+pEX25jRa7ejEfFN9HWTgteubPXS9e8FGCgPRO9uq1EmGcGhZl/X8ocugR7ny/rFvZtYR1HYYUcjfgIc8HZHK+txrS60bGk0wwNyV9eSRLNOphiotdcqvjSTdxUV6DuSiTnKFJ02NP2BhSOoI84lzvKwKjdhRbSqaQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are only very few filesystems using generic metadata buffer head
tracking and everybody is paying the overhead. When we remove this
tracking for inode reclaim code .evict will start to see inodes with
metadata buffers attached so write them out and prune them.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/bfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 9da02f5cb6cd..e0e50a9dbe9c 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -187,6 +187,8 @@ static void bfs_evict_inode(struct inode *inode)
 	dprintf("ino=%08lx\n", ino);
 
 	truncate_inode_pages_final(&inode->i_data);
+	if (inode->i_nlink)
+		sync_mapping_buffers(&inode->i_data);
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 
-- 
2.51.0


