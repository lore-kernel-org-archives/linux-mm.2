Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 826B71098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53F9C6B00C5; Fri, 20 Mar 2026 09:42:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CA066B00C7; Fri, 20 Mar 2026 09:42:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 343096B00C5; Fri, 20 Mar 2026 09:42:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14ACC6B00CA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A249913983C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:45 +0000 (UTC)
X-FDA: 84566556690.16.EEBB6B8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 406844000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=shrhiTU6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=d+1AGxDR;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=shrhiTU6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=d+1AGxDR;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=IA1SH/zegK6VDQnCu2IxF/8P2wLmkEb2c8HybQQxp2MX483pcynj4IOtsr00mraOrwfE6l
	4IoGNrQj3wuoS2KCiOYGaZuXO2v8qVftpBWm9AD51Cc/LzTdjCZNGbIkY99kaSMqNWly+T
	mgWt5NpMK+PbhliJZa3HvXOJcJg6rJk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=shrhiTU6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=d+1AGxDR;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=shrhiTU6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=d+1AGxDR;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014163; a=rsa-sha256;
	cv=none;
	b=w1QKrodKQFPNAISvJ5EJNrEhnMn+TileicIUBWrxQIIxQhu3r/yr0y8dbkRURJ7IagfQRt
	kuOcqwQ0OjV3rQ5avtmMP+rIpUhky/HB1VOq9VWyWwnEjGTl4VzfGPQo/coqHv/qa4SjNX
	0UTfQNi+FuamlBP7xzdO3ryBAJ5Ovao=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 588A24D288;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=shrhiTU6j5Tx0HiWP0P++KcPYqplbpKjvY4os/kfaJnnie2g9d+IpZ1xRDO3Ff9YMVlrNG
	VebHX3w0dRMjuC2AaxrXzo+iJxNAUWiO2gPZ89WphEhaYdnKvJdyYR+0hKnwGlCooq67Tp
	zdWMjSAmoXvJS1NaIDH9PF/zW52b39A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=d+1AGxDR7HVptYrlZfyZW0fQ+95b4dLEmCfTxO0oGZMDO7MaVVsdMhNSftGjnrbzSg8/dJ
	Nt1vcH8sXWc3k6DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=shrhiTU6j5Tx0HiWP0P++KcPYqplbpKjvY4os/kfaJnnie2g9d+IpZ1xRDO3Ff9YMVlrNG
	VebHX3w0dRMjuC2AaxrXzo+iJxNAUWiO2gPZ89WphEhaYdnKvJdyYR+0hKnwGlCooq67Tp
	zdWMjSAmoXvJS1NaIDH9PF/zW52b39A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=d+1AGxDR7HVptYrlZfyZW0fQ+95b4dLEmCfTxO0oGZMDO7MaVVsdMhNSftGjnrbzSg8/dJ
	Nt1vcH8sXWc3k6DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F9E542817;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WPZuE5lOvWlwCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D1011A0B54; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 16/41] ext2: Sync and invalidate metadata buffers from ext2_evict_inode()
Date: Fri, 20 Mar 2026 14:41:11 +0100
Message-ID: <20260320134100.20731-57-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=828; i=jack@suse.cz; h=from:subject; bh=KCb+G0Cj2eFjBT81lEvc82rl7DfHgEwXKgkjHk8fdQs=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU55ydADQX+7VdRDW1mPf110GpSWmRUvbEo7O PCx4Adt/5KJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OeQAKCRCcnaoHP2RA 2WT9CADEmXI5rthiKgABVX3c19nJTjLphSGV6BADWmE2kK6bQKwOeDpesrj692xhQP7GwNbQhYQ PtUccviJY4fYPXcWKWq9zoNgDgyEQRQJ/DH6UhVss5pR/wDQBkbfAIiZSE5PhwWGa1MHi1KvGnt DQlw8Z43lFFcdP2L1JyIPan404WZBV738liDi50SohEMbiI8j1j29QZgaoKYvHrf34CJ8VUhEGs pOtNCle+dOF3GK1u37p6HlB9SgZR4GuZYrVhj05PrwFhrGhdKJjhlUTR/DE99rbd9zDFrzrbSPU fX1sWaEfwAnD4CLVEU1W68PCG+NohJQm0Aosfm1LdeAexz5l
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 406844000A
X-Rspamd-Server: rspam07
X-Stat-Signature: bqcz6aw46rcnamgntogcb7banomt9uut
X-Rspam-User: 
X-HE-Tag: 1774014163-851191
X-HE-Meta: U2FsdGVkX19C+GxpxV1Bs1WEIC89ws7Bc+IUjbNNPX4I3kcUKNUzWBIi1/l4JtV3CQhd1+3af+vmuPu7ebptv3eLdmjv2lO3RR5dIyFlNBen9AqAN7xMZ7TnMR3hbhRIzAmbNZ5PSaJI86Q8E6UttWxqBUdXaz0fYsQi1g0tlp2/AIAF3l8PDSCogo/3tiac7XmBi22sRH9a7l3nA6wHggdx1Mkw0goxjC/xDAJd/DoQU1hpub+CAtiKcC7ViuMVMvP0eiW3sdJQf9aM1sNYQ3knbSkLtaH+ivS+dbGeE0/wvpfCBEF8gbEDuv7nXqyGTEIfd1v29m6cIo6uaUFrvmtjR216Z8yT9r17dRJ38UJHuFs7tJQFN5tBOKThjfeAn0QJVI9a+1Hwp4ZH/QiDpcwYOOja99YoKtcQ40KCpBQM1W99XT90xx/DcrzMQxEN8QM1xnwOw3DPy0PvD/VZPBJW8bltPi/zGow3R9v+yEbA89VKNJmIkq9+qeQGNMouORrJOp7e0l/2VK9hUOZC26p+7+g7LaLkYOQIqAyEe0A30V6OF+eqeAoQGKnwwIedr+xiEzQR51pRl5LnUl/3NpLjQO3+7XckZ4GrPe7nFJvAwg0hykbXp8oWoKV/wDEYeDq2QCtj7hp6VRSxWXTNcYnViqwvI4a4rW6qVq6SVnTue7U63e83zeKepb2zOJ9sznXL7JbFf42WU3zVel/x8plVYenipuDg4V70Dj1l+ym3wuheNGVbDW7UjKu/OBBc0lQv5uDEcNjlK3c5YobpHP/HsmrbiOL67lhNWA9ZkcpgaqsHYi/xhaPkuuzZJkaWSts40OfPnGTxVRjKxH/2JAdkbCsoJUnJnPN/Sn2GYp9Javjiswj7hZ2OvdHgSrU9Hao4R+uzlqsk9mgz8DfGGut74s+vVMM/iqzBR5f4u7jBAjXKoTgLK5NRGuZQerYnE+E1vnbXwH0SiqLodIO
 G/tn5Ce0
 XMvFPv7TwFm6LFYHQ16/cvrqz0VMCNJGGwtbqanPniPdkxGW7E53NTucKsVmJI5oiuDmOuDS0uCunT27aOpnaXgCO4qSSywyzCQVU0ZIMONzUHveBjhvEQEqPbWVdQ+i1rDHzaLgajzPRS7Lsoauj33vI6AG1TfCrXhMpe2CjQYfxYu1eNvtk5FhEPtLVXN2ROLDwR0IaagggAsvfv0e4dgbPwOBAYAJCHcVYZhtsy8VcJSkvkAjOh+d4DVhx6tkh28hrnZ1m5UEKdphzDjh85BAKOD3kztD5qfQ3Cr3mR9EHJGS3RPdpBAUAsbtdz2sKB5lPMoq2QfupN3fjmnXiswufC31KaFX7LBdkzXAXio0+YzA=
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


