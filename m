Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57086106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67BE06B00A8; Thu, 26 Mar 2026 05:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 604CB6B00A9; Thu, 26 Mar 2026 05:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3436B00AC; Thu, 26 Mar 2026 05:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3782A6B00A8
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:55:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B722BD180
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:32 +0000 (UTC)
X-FDA: 84587756904.18.ECD91CB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9E8D64000A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=N0OAqSIj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="T8dt/Zvh";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=N0OAqSIj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="T8dt/Zvh";
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v8LPpwAx32CRtbBt40P1A/4NgZQbZLc3wlX0s17fsmY=;
	b=KDVMX5sTN64njPZdaAlV6kQr98wq2LqXYj/9hroVcfxCurvsTTzIfb4LLRfdSwajCAWJyq
	bmyGaXxyC/BN6PK/m9o7VgHqMG+vJZDxRx0IRPmQOelnlJAuQU4R3O5OkMsiPglnsiNI/R
	6NztWvzzVgNl+5sOw1jZioUvHbBqnrc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518929; a=rsa-sha256;
	cv=none;
	b=H7vpxWltUv6XUZcQSWLAmQpP1Y0qn68afJVVCtngZERIbImi/b57vjVckP5nmPeZMptGCb
	J7oWGWx+Z7M0A3pUlo95iWkx3MKvY6PWDW1YH3NGNHfwwd9ToLrTRXk6+dRAF4wfrRUgOy
	/DUK0MxMEDC0x4iho2e1gxM99wbQ98M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=N0OAqSIj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="T8dt/Zvh";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=N0OAqSIj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="T8dt/Zvh";
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1B9725BD98;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v8LPpwAx32CRtbBt40P1A/4NgZQbZLc3wlX0s17fsmY=;
	b=N0OAqSIjdFzEqXC+OArpJOITpEDu3I4Yq5v/Mj9Dsv7NijrZFjVWuy1W6BKkQKrR1ZuHy2
	vFHPiV9UEUzzKtjZihw08c8Q0NdLfxGmI9x+iwFtG4OLy70cf0X9qDCtDNR0RS2z+HQ7nG
	rkx/CjpbmtrAp+kjzJ9Ap5FMxrpkU4w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v8LPpwAx32CRtbBt40P1A/4NgZQbZLc3wlX0s17fsmY=;
	b=T8dt/ZvhZUG+W7AYzD3LA4elccJpBdbaYWvf+wT0b0xjNYqvJlgE/J97Ry0RoHTWv2iiYZ
	CjLt8mG55IKJHSCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v8LPpwAx32CRtbBt40P1A/4NgZQbZLc3wlX0s17fsmY=;
	b=N0OAqSIjdFzEqXC+OArpJOITpEDu3I4Yq5v/Mj9Dsv7NijrZFjVWuy1W6BKkQKrR1ZuHy2
	vFHPiV9UEUzzKtjZihw08c8Q0NdLfxGmI9x+iwFtG4OLy70cf0X9qDCtDNR0RS2z+HQ7nG
	rkx/CjpbmtrAp+kjzJ9Ap5FMxrpkU4w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v8LPpwAx32CRtbBt40P1A/4NgZQbZLc3wlX0s17fsmY=;
	b=T8dt/ZvhZUG+W7AYzD3LA4elccJpBdbaYWvf+wT0b0xjNYqvJlgE/J97Ry0RoHTWv2iiYZ
	CjLt8mG55IKJHSCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 12CE54A0AC;
	Thu, 26 Mar 2026 09:54:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZjSXBHECxWm7YAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CAFCAA0B7F; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
Subject: [PATCH 11/42] bfs: Switch to generic_buffers_fsync()
Date: Thu, 26 Mar 2026 10:54:05 +0100
Message-ID: <20260326095354.16340-53-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=765; i=jack@suse.cz; h=from:subject; bh=syz4UVfUfj7dzDzM1I8lGwv0Y0mqGA7yHeFyjxEPh1s=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI7je/bj6YX7efCg+wsg0034sVH6QEOHR9SO bf6Z06jxkGJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCOwAKCRCcnaoHP2RA 2VGzCACxL4eJ7nSpgilarxwU3cMOnKYrG7QvQsgn+PasNfI+o/TAStfL7sXvIW5PbYug9mB4A6A plwOtuZKB6JEsSmv9U/R3I0QtTzen0/6Qxz+k1u6wcFAGRfVjpFtrWJF4HiBQFxqd/jOJbK4M93 qSv5XlIJsGHsM9shTSprIDRBbWlAa5BpetQ4YCtwcugz/vqTA1NcxQdtnE10i6dy+hzJrP5fPvZ 2mcUR56iW1FHAhZPAmqUl5mSrQ5U8vs3chfWHNCVOYc34olIfKnt3vFH2kWs+RKmuWThz15BzM4 jtt4w71qyZMg/sPPndKs3hIDTc7fVtcyqDl6MFU/y1F2smtR
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9E8D64000A
X-Stat-Signature: e3xz5rn5g6rora8kgi6cn9emkdb949mk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774518929-873531
X-HE-Meta: U2FsdGVkX1/oX9r3jIVHYknEO3pt6/WJOJn2KvRgIzEBfcH8KWPbjV/dqD9vP37ST208qRNIhGQ6MnhzH/QMgBZywtfa4ZLblAiSf2hodsy1KJ63cl1b50Q0DhDgbshvy/Rj22uFkTqXvQNpbmkbb1NHhs8xeyMffcBWo6vvnFy2GlwsMXTRKC5m5akrASxjZnO1LSDkrt5Xkc+mc5ftY7Y/DRe9iEfXVsRXUacc/P3tFkhNMBHM2By6SI8BfVWQy/9BG6C7rMmO1sSwZvGc7wP4lmIuuXtjnxqPI7/TXe82Q2F9BF7o0RnHAFWPeUk+R4kgeJ5g4Y+K/UTPrF/ym3zOndj6Sl6JTmtec8Eew2BMkI6BHfQ1zfOpFQD9OLSu4C/OaiWAf6x1fNBI5djg/QNViLvtvDSHdOqG+U6a/FOduE2ISFT8adC5x4P4GCb+B8ZdBVaOLRUzmTcNPauqhOSHIDI/vFwuAASncrMrNJh6WgxbfnM9FVpecFCkxzeqWeYjquJ4DLneXi1TKdh2MKO/bhvlEBhKVWs0h/P6zMfgcedsTsnfkIH/kRusQzHAXRSw0J7O5TrXn+llDeYruFKQVRv2GeM2rrtlErldYsdmYqY6lY8u9bJmk+nPKAHsvMofc+mppOaprRNfQxlQi4Pca7wtZN0n5R3sX/1jvqW64PGPEfnWXqpl4om0XGdPrLTCEGl/c6AipvPkz4zXKXNn+kZjlYKvmDFogSQKWjvrFZMMesrtoGcvH7j4N5N3qQXcIW1RcJcctOtTqBrzRBr7GL0f2VD9j+I1KvOzWC1jWB8kML6eI2HwU9wmewFMvpXBsLqzUAW1xqFqEwcVQltgdHAg+rxPRMzKKLjAiQUJkNC671rphwkoh7laoc5cLk10YDVraXX3W4n3uhzyZp7xGZTVfuS53JnMASuP1zUwEreptXS2kmnANv10VAZdNsleueVEtyuNTNxzP3I
 ph5lBhcq
 Ykz7tFgm9niMSoGotXWbk2pf4kE3+/SUAy95/YQDLK6lXVcANGSIfbAnYPe17USXjt6vk4o/MzmxlWQP0fPA4xlJWoo1xnPdbSryQPc10nRQ8ZXHXVTXvlnT1JY1DvC5yzDg8FBYsf868RSzZ5wvdOWpCheYNNZ1VJTT1mQ+HRUSKg6gHyE7c5QCE1VwL2ob48K9vEg5qhYM9Frx9hixAiKrMlEr31Lmow/hnSqdh/j2odKGsY7tncF73XYXf70ibzQAbgB/opq5PtW5+U8kSZo+EackwA6+Xn0/3gWbJ6LOC2hpHYW8iWHObdR0ZzBBlCWKEJgc3N5CS8NbMqmzLbpmV9pRz1AwGfYuac08fS4pwQSA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

BFS uses list of metadata bhs attached to an inode. Switch it to use
generic_buffers_fsync() instead of generic_file_fsync() as we'll be
removing metadata bh handling from generic_file_fsync().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/bfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index c375e22c4c0c..1b140981dbf3 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -71,7 +71,7 @@ static int bfs_readdir(struct file *f, struct dir_context *ctx)
 const struct file_operations bfs_dir_operations = {
 	.read		= generic_read_dir,
 	.iterate_shared	= bfs_readdir,
-	.fsync		= generic_file_fsync,
+	.fsync		= generic_buffers_fsync,
 	.llseek		= generic_file_llseek,
 };
 
-- 
2.51.0


