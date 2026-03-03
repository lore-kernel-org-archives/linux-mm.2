Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21D46EC1423
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D55A6B00FC; Tue,  3 Mar 2026 05:35:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45F0B6B00FB; Tue,  3 Mar 2026 05:35:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29AED6B00FE; Tue,  3 Mar 2026 05:35:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECEE06B00F5
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:35:02 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE6791C330
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:02 +0000 (UTC)
X-FDA: 84504394044.01.E5FAF24
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8D5A7C0006
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=O3zBfOEm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AYiwz28S;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=O3zBfOEm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AYiwz28S;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PIk+3PM+jG2PiQ44UnRCyz0Pc5nehV9CBwg+OwnTyLw=;
	b=8oozzHih48i43YvSQ1PtUEvYY+P6AazrX8dvq8IlKbb+SBpda7HvClkZE70TDMt15RQS7O
	HF6sQQ7BhdKTnGRyhRYs+TJ1T+hcWGAdoXv3pMwfBP0RCjVTRestR6yx4yadtIpLnNDk28
	4Ol6DpcdCAhexRhk0Y6nYgv+ePzAQH4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=O3zBfOEm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AYiwz28S;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=O3zBfOEm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AYiwz28S;
	spf=pass (imf22.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534100; a=rsa-sha256;
	cv=none;
	b=BJeBzBEJjp9+VFpUAM1lPqXjGkaNKflbO5oLZ/wMf56oZ8ViAxAgxCr0TrQW7yAJYuCdI3
	s/m/cSI2hFmhmI08ejozDmlFv3ovBIbq90X6uluVmDlt7hNNn6KkQwi1OWRLsfIgNShCeK
	jVfIXrPUsMXJgkJu8oRvmbdudCbSAeM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E625A3F8F5;
	Tue,  3 Mar 2026 10:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIk+3PM+jG2PiQ44UnRCyz0Pc5nehV9CBwg+OwnTyLw=;
	b=O3zBfOEmswK/ytkTA6R+NKxminmWN9raaPx+DDA8G6HEaUf1hV5TXIsSkgyryuuFkJz2nG
	pjyQkyNFZpV2ge+5DrFOVEiQBLJ5Y5xEoL1vvI4CO3OHvrYWEx+SVSTQ2HbV/9sc9dDTfV
	pDBq4x4p5qQ075pAM2h6ugKlanJqgCo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534084;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIk+3PM+jG2PiQ44UnRCyz0Pc5nehV9CBwg+OwnTyLw=;
	b=AYiwz28S7e6WKGWDkovy93oKVAOkYtd2/WXEA7MNma3vwGoP3ekJUV5vEsPpsbjEbgH0sk
	dLp91HkIhcHzg6Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIk+3PM+jG2PiQ44UnRCyz0Pc5nehV9CBwg+OwnTyLw=;
	b=O3zBfOEmswK/ytkTA6R+NKxminmWN9raaPx+DDA8G6HEaUf1hV5TXIsSkgyryuuFkJz2nG
	pjyQkyNFZpV2ge+5DrFOVEiQBLJ5Y5xEoL1vvI4CO3OHvrYWEx+SVSTQ2HbV/9sc9dDTfV
	pDBq4x4p5qQ075pAM2h6ugKlanJqgCo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534084;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIk+3PM+jG2PiQ44UnRCyz0Pc5nehV9CBwg+OwnTyLw=;
	b=AYiwz28S7e6WKGWDkovy93oKVAOkYtd2/WXEA7MNma3vwGoP3ekJUV5vEsPpsbjEbgH0sk
	dLp91HkIhcHzg6Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DD4683EA6D;
	Tue,  3 Mar 2026 10:34:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2K4ENkS5pmlmFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7F836A0B2F; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
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
	Jan Kara <jack@suse.cz>
Subject: [PATCH 07/32] bfs: Sync and invalidate metadata buffers from bfs_evict_inode()
Date: Tue,  3 Mar 2026 11:33:56 +0100
Message-ID: <20260303103406.4355-39-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=801; i=jack@suse.cz; h=from:subject; bh=K9wrCKmeO7BfHLYf4wsyZtDcyuSx9fmOTys9wQHOC9M=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkjZOEr4SoMR6litD6xJZ9vyOu7Qv8MRlaIP MceIDomSlWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5IwAKCRCcnaoHP2RA 2VB+CADgFJh19nlSbb70V3fRZwmBUEdqZKelbD2FwM1YKdE3CysN9YBk3d+n0xXje5DqWmFag7J CxfH7uwKQu1nkTgmg+d3F0Ykl3vPQVHl1hA33iwJP/xJWFW2W4lQjysTSuRfixonmgSXdix48eW +LiYGnMgXGA6ywu9FKZ4mrqy9/DP+Xntvp6P98n+Sl5btTcyfCxHgL774GZz9EQ5iFewtj6l0ad 2TGEA8v4kTLREsHeER1VFM3L8LOfwT/7/vrigo9gLT9URxDK1F3nsy8O40f/UX+DZy2n9fg2zf0 sJFonpT5GTYRGT6Ot4tf8e2X7k4qszNew0ctiXB2Zr+DkncM
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8D5A7C0006
X-Rspamd-Server: rspam07
X-Stat-Signature: 4ioq8xjprohk71hiitw576yyoba5611e
X-Rspam-User: 
X-HE-Tag: 1772534100-444435
X-HE-Meta: U2FsdGVkX1+YmbGTobnXkeNU0p+vW72KwIkJzsCiRVTqa+o21/QvXs+YRzhn8BMUx1DXOoWx8WkDh8O4zmM+L4vzmGaJiB5EECnGvI3K/BIKOvh5HtJZIHz3M6WOxHZs15a3F98mJ6nqGnccJE8MyT5j2JP7bGeh/myRIkNQzyIV/r3HpO3Yi0SEVaWsQNrSRsF+OsziXHC/Buyg44p+GwYCLlRq4KC5yTJfo3V3jbXWvAVBkB/jUk6eekTFwTJ6oHt9y3ClmNGyumQtpIkmTcFpBs4QzfUwoD5Vfp3ARr8zcP6PdQiGrXoOk2sJYkgHnnjkNc4EuNZ5DUyrcyDgrvM6jWkRdfvL32jA8lNGhkPXfe0XhvVLQuhu4foSm9n3DVtdwJYMNntsMyQ8f55MicuFWpiGqI/FFNxzcbbk1cF59YnU+sb2Bn57msZ2qu0c9neilh98f0OiS1eAi2Z+hBNk18TGUyruCf9ysSC2alRfcVv3mmGgMYtpyglsRRgZRz35LwqOzqKOSApLI3u+9ioFdE1pLzufiMuoUYv2TwMgGRwpnMQFSM78q1nP/UX19VliR37IsSLNk7/94TaEt0Xis2Urbp+2iJuzyj1sxLsV2NbwPP0ns9Pp9B5iXtNPW2b2cDjQQjyW+jRr7zQy6vcdnIu7+4tHuZyyXHRnhaNTsXI9B1r7eMA/T7CX0BBcAaDaWuozWvqFHg1m3jzrl2CW58PadDOj+NlwG5tnZYmB4tnjMUSzGN6jDOeHqZ/oizSOkgg9J+QwO0B2Mcs3DdEi4G22CZ1LRhG5d6fN0JoRBrt3HzytNtIDgw7wVj+peo4Ppa1s9AEPfRU96BdQECf3cxDiCUzTZ9HDinPmLHnbhVT0OCq4hEJgk1IW0296BwNe9JcCeLpm0Sfuphrg47PPx8vqMoiLc7aF4d8cfCCxXJxQwAh6rxa1ZGgXc1tknUjmNAkxKRGI7zW1jiB
 FzUkjlzl
 xPeJ1fiaRI8AkWr2uvU6EiB9SG6+uPfjimKjklpMMSaJALUQDyAEUhN2FZ29tKK3/Buy0UAt+iJfehMyZdDe4OIiVBg==
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


