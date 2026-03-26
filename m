Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59AA5106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D81106B00D0; Thu, 26 Mar 2026 05:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5EEF6B00D1; Thu, 26 Mar 2026 05:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6EED6B00D2; Thu, 26 Mar 2026 05:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B981C6B00D0
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:56:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8598B1B8CDB
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:08 +0000 (UTC)
X-FDA: 84587758416.07.7819340
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3F728A0003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VOuvWxZR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BhADEN1L;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VOuvWxZR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BhADEN1L;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=assKLN0wShA/6MK4HbUyihg2H4M5nGwRr85aE2wyHPkpt1H+DKG6YqvfBs8wJnl1Q/HA+j
	oXYUqB6FKZyUOjUSWSW0WLPytdFTjKCOSPuu2KP5AP6F2zCjR4UMmEwLh2m2PgB+URUpJZ
	iSK7LRyAj+BYVxhUSIkJb2qoU3LcsFs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VOuvWxZR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BhADEN1L;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VOuvWxZR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BhADEN1L;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518966; a=rsa-sha256;
	cv=none;
	b=XhGA5PoSoKJScYwEIsyRqs0MCEzf2B21CL/2WYvQiJJfPkOnBEUcq1KNlbv7QX2OC2S1Ew
	OrnhvtTT8+yc21IOX9E/bwDdQzPxN0VlSLU1qrbofydAhhwndiQZaWHO+JrBD8UHckoBdj
	+XVXbb5HNQCBZvUaSQggc3+rAOkUCRo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4B4615BDAA;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=VOuvWxZRG2aG35N6U9VlmaHrKhH9qUL/5N+ExEyBhAhkQ53OE2Q4OlmKS9bd1Cz9S5SV9o
	ewEop/lz9d3R6bzgpnmd70f7V37cfCvGbNUy3+793J+sHILeHapjugmjCdwA5BUIUtENxY
	Bjn3euhuialGvxtAFOTQ95ArFmprffY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=BhADEN1LXwRg7fM+KpfWFmUxoKgWyXbDmnQwXEr7aUSpjGzWHl4zXO305Ip1iQQwVihS0r
	a5iQp52EXFv80eBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=VOuvWxZRG2aG35N6U9VlmaHrKhH9qUL/5N+ExEyBhAhkQ53OE2Q4OlmKS9bd1Cz9S5SV9o
	ewEop/lz9d3R6bzgpnmd70f7V37cfCvGbNUy3+793J+sHILeHapjugmjCdwA5BUIUtENxY
	Bjn3euhuialGvxtAFOTQ95ArFmprffY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=BhADEN1LXwRg7fM+KpfWFmUxoKgWyXbDmnQwXEr7aUSpjGzWHl4zXO305Ip1iQQwVihS0r
	a5iQp52EXFv80eBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 429CB4A0A3;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /wVAEHUCxWnTYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1707DA0C63; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 18/42] ext2: Sync and invalidate metadata buffers from ext2_evict_inode()
Date: Thu, 26 Mar 2026 10:54:12 +0100
Message-ID: <20260326095354.16340-60-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=828; i=jack@suse.cz; h=from:subject; bh=KCb+G0Cj2eFjBT81lEvc82rl7DfHgEwXKgkjHk8fdQs=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJBydADQX+7VdRDW1mPf110GpSWmRUvbEo7O PCx4Adt/5KJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCQQAKCRCcnaoHP2RA 2SzXCADo5s7TD0SK8AYz5IGC1RWjgKbeLJKPzuVl8ZPcRhzaiD8CXzkLg9H0naFpr1l7Vcd2gzx mo6xBYl1ei3xwdRuFjSaWpLxRs6xa8PI0tPjctU+9th1cgupd+Il5Z2KRk8mJpyRo7/nUcHBfmj Dt9gie8MjdqNdZlM4WAQoQsMt6Jy5X2tx1sNHvdQVRkv0O8Ek1yUtAkJSv9e1unlGSLPLw3OlMa g2L+Xyhsi1wmEP+zDLRYvDwOd1vxZQ+uL2IVIFEFig+bcnpnNd+cTMxHVVpndqjTYt/BNkV4/ko pOUPI5etCG56Ynqua43GQc/2aVdcsdYIjwETHas9+omx7+Et
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3F728A0003
X-Stat-Signature: hhk7jkpiwnoh6pu3tqrhn6ssfsgwucth
X-Rspam-User: 
X-HE-Tag: 1774518965-582428
X-HE-Meta: U2FsdGVkX19lcyQMQ5GPjgE+8HkaNDl0nyBWdQr9zaX0cokEyMDThpOg4NdCVyb3XTOWpM5rOwtFmeyoLv4dj04+SFsRIPpF1y0MUFIbrfCHuA93Zlm5PAEBrGO0T7SQfbARZHiWiQ1Y/he8E715LfLTKxf3GmxzcLZ5C9K3/owQxQYDqIBmFZb89pw80J7groaiSPaNvIYB/0Awuiuzmu3Xkq3rMSsG24fGDnrDcSXgongXu8ZHct8YN2tj9A2K8P7HZkWVbbEuqYEsaFt80a2XzJ4oSmrzrlxLYzLbXh6HqwhMl/ZDKVwX8DTXMuhkEMWnKCJXa2XfrvSSzFSlWYTRFYjvCOVEWWyZs8lDxLJrOFltHiADf8atuN8fZiNsjDzcARZMrtlhe20oAtLz0/11zW8zY22oBlhr0bBSHu0slCJfFRTIvjBIJgzyIts+4u9g8JuJFvEwCm4OHIyIg8hhYyYi/UMSoYzZdS/AnMzHZKwvU6j9ZscpAw4UURjoUkx6QzpU9NECNb9yCHe3cSTm72WiHEVBuHx5Ax9tZl8974xr0vAy9C1fNJ9YGHQnyRi4V7wcBReR/gY8tflS1oaAI3Dn/449nJfSky6SQRAoT9+5HE/9s2vipdAuiEVUJr3AgGXX+bxk9JXfYW2si24nKZXgNvAroK22dM4k3vp4kaUzqGDpwUYsLCukhuzFGW8a6XzYmIXoLqVg5RON/Eq/OtrXiy1gFzU3+kEmltahOmiO1N5j+mKjJvrXkJFohxxt5Wi0gBD2rBRMpUVaXaqZANfEG4EsrowCTEKEeDIZRa7YguyXKKB1Rr4vM6VTLSblVE6mgdg0z1hx7J3JtGuDqyOQWvV1lYOwqOUsEOEL4pEI/PeOkd9idF2jGp4pd70x9uWV3Q67tExUjPAmTc11RW7lvEwCbcbdnarfHQMq+ULvvtSdXAKA2qjbrP+ZGpAW98HnY2tiKFRGf3L
 sXUtD57E
 GQHwCDhx4WA5ccTGbZY5oYtLL0gmRexdEIg6hBcMPG4LXd6WJVhe7sm8jufm2MxrsqPTuvSvMqSDVrVTJIN7Hdb/YBxwJNtW8lQ0xO69sPS8x1AQ1PFU79wUfM0gQQPYxH2zbi2wYunW8Dr+HSwGxfUTRzIeqsIfTgLV2hkSda4gWHrvckH+g6PCzLVWgPXFA5HqBW6/lQOTwePbM9ax9ngkGAk4g1SL4oSLA0cJxDPL4UGpNFs1iyOoWBNQ3f6BZt5OI2UDhl8wHcMxzFZd56pMCNMm+bJuHDITSQdxXLOo+STFhfUQcrdYBtx6WXAq9MVcfAfDtziiOjw2b3X0PHnTkLMQIB3egGEw36pcwwde/nGs=
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
 fs/ext2/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index dbfe9098a124..fb91c61aa6d6 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -94,8 +94,9 @@ void ext2_evict_inode(struct inode * inode)
 		if (inode->i_blocks)
 			ext2_truncate_blocks(inode, 0);
 		ext2_xattr_delete_inode(inode);
+	} else {
+		sync_mapping_buffers(&inode->i_data);
 	}
-
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 
-- 
2.51.0


