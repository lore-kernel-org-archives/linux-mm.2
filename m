Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87617EC1426
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B9FE6B00E9; Tue,  3 Mar 2026 05:34:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8966D6B0095; Tue,  3 Mar 2026 05:34:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EF916B00B2; Tue,  3 Mar 2026 05:34:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 493D66B00E9
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:34:45 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 158191403DC
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
X-FDA: 84504393330.08.1AABA1E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id B1736C000C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:34:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HUtj8IoW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=i70SHgcT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HUtj8IoW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=i70SHgcT;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2PW0X+G87Q0jqXEESIhnV7Zw/Azr5UfRKiauVgcVR0w=;
	b=pnIBL+vapLpYaksumacryEYgJyrMHXCoLBzQasQn+Udh2HcLmGhsjUK35CtgXpzDlLyP+9
	7HAsW3wK7Uhb2pgg3ufYXOW/YWCrvEBQZpbebS9ZwLc6/C+aSlI4gxB1OF+MN00rWDKWzK
	9p9VkhaJvStPc8jUxR6+jTkh7lO2AUs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HUtj8IoW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=i70SHgcT;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HUtj8IoW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=i70SHgcT;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534083; a=rsa-sha256;
	cv=none;
	b=WHl2MPMfReK51qnR/6P7kFENao5IMcLC++kjBCu/+TL6UWI/qubMd8W7sPS31Iq34xMevj
	V8XNtOaoX8tIfZBm+5PxLakhDFp7lfl+a2g0t89uMVZJj5abnFfqRjkOBo271M0Go3VOKg
	x5RHCHRHW8kSJ4ZgAF3QH57SmIrTYJE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A35AA3F8ED;
	Tue,  3 Mar 2026 10:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2PW0X+G87Q0jqXEESIhnV7Zw/Azr5UfRKiauVgcVR0w=;
	b=HUtj8IoWsOwo/attLdC4UcmKD4HtbndQZYTS7fZBHo0KwodaHnCqBxznjievlQ4UQJm89Z
	Lg0YPyK4RuNYs8230r3At73PGZUj43N6khysk9sPk1kypegI5rF5mAdnKgHIZt7s9+3yp8
	/LD9SUcTczbjbShDqyJXg/mzfA/ruYk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534080;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2PW0X+G87Q0jqXEESIhnV7Zw/Azr5UfRKiauVgcVR0w=;
	b=i70SHgcTNUJ7NMAjo96n8YgGmzVbHFUF6jPlmdsdNnCuSZlw/33zd7Kq6bFyPqdgt7A+Qu
	zYwNIB6TLNM/qYCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2PW0X+G87Q0jqXEESIhnV7Zw/Azr5UfRKiauVgcVR0w=;
	b=HUtj8IoWsOwo/attLdC4UcmKD4HtbndQZYTS7fZBHo0KwodaHnCqBxznjievlQ4UQJm89Z
	Lg0YPyK4RuNYs8230r3At73PGZUj43N6khysk9sPk1kypegI5rF5mAdnKgHIZt7s9+3yp8
	/LD9SUcTczbjbShDqyJXg/mzfA/ruYk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534080;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2PW0X+G87Q0jqXEESIhnV7Zw/Azr5UfRKiauVgcVR0w=;
	b=i70SHgcTNUJ7NMAjo96n8YgGmzVbHFUF6jPlmdsdNnCuSZlw/33zd7Kq6bFyPqdgt7A+Qu
	zYwNIB6TLNM/qYCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 96B373EA69;
	Tue,  3 Mar 2026 10:34:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Hj3EJEC5pmnDFAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 51FE1A0A0B; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
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
Subject: [PATCH 01/32] fat: Sync and invalidate metadata buffers from fat_evict_inode()
Date: Tue,  3 Mar 2026 11:33:50 +0100
Message-ID: <20260303103406.4355-33-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=858; i=jack@suse.cz; h=from:subject; bh=rtWRYYCi+3xOxheWOY6jlzCuMWKqys5cHOCNYJEuNWY=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkeVzC4YbQ9T0Z4TeuYJcjZHgbt9+t9ryNIR 3V2CHcYpCeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5HgAKCRCcnaoHP2RA 2ca8CACs8G3pdHr9kW9Q+TKPXSn2npqd4bM2vAfsVoOQ/P2gyi0t8/O8mkzMj/CohCUiyH0qNTc 4TySVlIGRafg5gnSttomZAd3lIx9qrRY2p9FsV2YnjfMGJJKOjm4MGnc7uCut4GOf5H4MUpHrfM kY5/VzZQy7/HyZE435Tg5wuWLOXdMNY1sA9wd2bbSwPO7ZB6kDU1huFJDvu6ik/KYUxgbFeZYzR WO3GlipQ/dmUqVw4HjTWkPA+Xifi2VZ/SnisOeUBk51Es0ro0swV0JsRiTQ7L1nlj5s/f4507Ez +tW0uBn0ZVAmxI2PNJ3LiduM4x+XORJJYCHHL+YkYc/USDl2
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B1736C000C
X-Stat-Signature: 79rodqdc6n8h1kk6ig8cm67c53jnfgjk
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772534082-460480
X-HE-Meta: U2FsdGVkX18bvm1v3jn0JWrOKGkMQC8Gtu/3XUYszZty3zcrF/251Xs/lBm8H3Cd6nh08yY3TSKc5XB/rMnMPx+GpU60kBOT0xHPDOmJvRfmOvvsm62em28vW0Pxq+CJUIydlz+sEqerIZxIW+6es45WKm5QmX1T+V7jhivD1vM0AtwjWeS4KhtEPJ51lpi2VIHvBEIXNGU1HTJXS1ZhnEbrgNLwJdy2gHbCTbkha9MUMH6TRJQXLlIjTKsR5biWmeOQxqOwacdZWiol4euf/vHVhmaGnUy01ZswmNsKFfJ/wYEl52Qm+8xG1O0XmpeWSY5uCsTHaIIEbp1cFUEw1fhJARksF5QApDD3cdaO0Zwgkv4bmz9SLXQk+ukvBbz24MhVO3WODw/563cqnKiGP9CgDY8x0aentFO3ktJAKDsqtb1fCNd/GtBEmJY3KS1YCaO5uw9fjBCSgBOueVGRgUKluDBqMUb9TuXjt5JStWvgeVFcwrlqxi4P5lFC25QIWLM73MCpFBnct/aDah4PPTJTzVok7ub778XLlLYQufR6V1bI3N26mUwqdREnh4ibDM0kOjFmN8uC1nvTkxMsMBri4v9ixdSZ7VYjWW9j5zy/Xh6M0/YBpdO4dtVIyJHXqCIIVAPeeI+4iRo0nEF9WxnEUcF3DxyAVViBrE4Nf8kfGsGGf73tJaJJ7ACS1k+FhYq5xIfP7Stk7QVc1TrLbOafAn3ASLAvBUXYERA77X5PGFiL6lGwKSBd5ggVgUD9rAZdXTOIRMttHp4J8TvNqyklhfqrVm98ztICsxe+Eht28JE4JV3Dn/blHXXOlQOn6Q02Iq+M14MFKdqfjmS9lmgNEKZD6WqwOfaekpOSHwNrJTtPuMh29bT+3iSdMJe8gpQutX+pPBqh5b0S5x/zF2IUf9kPThFrcjtfG/Qj83bPGc5GshZC4FNFhCDvUmVvnDwzajP45LTMXuiBDPx
 9iipY856
 aufj+Athn+inUn7BYiUvcQRvrOZaNOFTL4aNnAYzLCsrO9dAm5+QCO7LXk0A2gszXWssSsc7asQD1bwK9niC+rRKKz0Zjim/nYQE9QaJSxioK6nr7f0lIoOKY6wsPvUAHhhvMb2o3H92FDiDTmEjD+xzGRmuw30DSbQzZ1Sem+rbXgotrczy+cmuq1f3MDb0FO+4c4fSPI/tcC6CeHAgFDORL09ccEP4SPw5RToLMjHUFan+HEA5cCBEY6kRBaFeontokIkgwwqmo3o9jFpQNGw4f9n7+FT2isFgl/EA+WAZcuYqJ0HKBblD693Jd5L+S7xapu3VwFH7u0M92iE+b1gdF5+AWzMAcIGGBIfMqOmPkp9c=
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
 fs/fat/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 3cc5fb01afa1..ce88602b0d57 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -657,8 +657,10 @@ static void fat_evict_inode(struct inode *inode)
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
 		fat_truncate_blocks(inode, 0);
-	} else
+	} else {
+		sync_mapping_buffers(inode->i_mapping);
 		fat_free_eofblocks(inode);
+	}
 
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
-- 
2.51.0


