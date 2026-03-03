Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84769EC1428
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EAB06B00F6; Tue,  3 Mar 2026 05:34:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CA766B00F8; Tue,  3 Mar 2026 05:34:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F235B6B00FB; Tue,  3 Mar 2026 05:34:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D70546B00FA
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:34:56 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C5038B93E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:34:56 +0000 (UTC)
X-FDA: 84504393792.08.FDBBD0C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3F5A0180005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:34:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1PXNg7w0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0yNP3QSG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1PXNg7w0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0yNP3QSG;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=Yw3EVZWA/eRCqtBBYGy9l+yPMUoukIFQwWfc/TEFsXhDZFu/TSMt0295p5bmBXmS5gdu6I
	HUYyLIAVroKsFRhvTUtwtMZePhRxF07RptBzYJRlpXanEEll6eUEP3yKh/w6C7GOtP9Pks
	tfwqtcJxEOPOpW1FwI6nH/aGMobvfLo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1PXNg7w0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0yNP3QSG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1PXNg7w0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0yNP3QSG;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534094; a=rsa-sha256;
	cv=none;
	b=DlJ/96VLnM9FGkMj625qOoBsMVk2+P6ck5RLpqsSdU+EE8FtMKfKqRf6aVZFBqDCpqxCjP
	Q8tqiHUjP8F5ekjkqdCmDuT0tKnyDfbuD9YTk+dEeiqkma2SYQLd7spE88UbN1OtAuAbYg
	A+Jho7bYX3f/iPtGkORN0qaBmEl7zzo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C49A63F8FB;
	Tue,  3 Mar 2026 10:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=1PXNg7w0sgjA+IeL2N72IePtRMm5Uas8WgRnS0k2/z3q4ipdWBqe9Qoz9n0CCPynjQ0vww
	BnWQlMfCP103VD3e8vSPghoFjE9Qbw2j+XSM8OtzRjjSg0lPtslRs1m0WFFZwBbK0UPEJ5
	MvhoHUC3LT8sHhFeAWSkq5D6fNp2cCc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534080;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=0yNP3QSGNShW6EPYB08ryvgSD04QbI2sW1aUH/js1sqARP8w4RrZpvtrZG2KLmI2Tnaiz9
	zPqnVKQnHF1usPAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=1PXNg7w0sgjA+IeL2N72IePtRMm5Uas8WgRnS0k2/z3q4ipdWBqe9Qoz9n0CCPynjQ0vww
	BnWQlMfCP103VD3e8vSPghoFjE9Qbw2j+XSM8OtzRjjSg0lPtslRs1m0WFFZwBbK0UPEJ5
	MvhoHUC3LT8sHhFeAWSkq5D6fNp2cCc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534080;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZ//apcpVW94xq1ae7enGtSi0L9g8IU352jjMI8FbxM=;
	b=0yNP3QSGNShW6EPYB08ryvgSD04QbI2sW1aUH/js1sqARP8w4RrZpvtrZG2KLmI2Tnaiz9
	zPqnVKQnHF1usPAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AB4BC3EA6F;
	Tue,  3 Mar 2026 10:34:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hU1ZKUC5pmnNFAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 664BBA0AE1; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
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
Subject: [PATCH 04/32] ext2: Sync and invalidate metadata buffers from ext2_evict_inode()
Date: Tue,  3 Mar 2026 11:33:53 +0100
Message-ID: <20260303103406.4355-36-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=828; i=jack@suse.cz; h=from:subject; bh=KCb+G0Cj2eFjBT81lEvc82rl7DfHgEwXKgkjHk8fdQs=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkhydADQX+7VdRDW1mPf110GpSWmRUvbEo7O PCx4Adt/5KJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5IQAKCRCcnaoHP2RA 2d1YB/99e12GNzLteSvmrAGKqt/jAqRskrgiz6YVLBDDWB8IVAaiVYO+1BBErNEjii3QXmdSryS waEUm0VfTLspBWQfaCGnD5RtXXUwig45Ytn435HFSK1utVdXzW9rpzjyc7QicSQhuoHKs4vEUx8 Pu/fn+n98C+SVI+OVFJG6fMN+rn5Lq2CfmnqjLylhn1/isTHhZ1GKIz9hR4v7mFHzag6/c8aXp/ Op7M8IpIpeZMhIm2PdqjCgdmfxTwOU1dK4uHjK8hgLZ+d/IChSuSvdv3oLrhnyJGYz4fCq66WcM Dg4L1v5FMFlT0+22tylV5dMJJeyIR4j04oq9mgdD02ndUfhK
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3F5A0180005
X-Stat-Signature: 8f6c83hzd6qwy3torxmithpt9rz36a8h
X-Rspam-User: 
X-HE-Tag: 1772534094-924823
X-HE-Meta: U2FsdGVkX18rbI/ynrwQiXVjQCDBsvGw2tbk0BJ8FluJnuhMRSlW709nTRnXm4eyRPPnaA5e6Fk8X4jg/KnizfG8NIjc4A2XsSbfe4jHtB+FaMsZobK9IGpYQZ5YFYZmVC/DobrlTsYXWxfV6jUGU+JqYTRySkgbiw0M/Q4d+MP39eG/jKSViXGpMV6Caf5o1/yoqnKco3VPFCE+bD6zg1QwTP4tR5IKwmnbxSe9gByfzpnhZ5HL4jlM7HQd8Zgioadn9diIjVl/lrxU5e5YMutlLs5XdjKYziea8oceM9qeEJ1zV9gx9ArmDsNwoW5/RFpJpJZvimv26B2/9s7Lc2ooioUjRqSLuIUl21Lo2X7YGXGhBwtAgn8sX0R3BaPFRBZ9d5p0vXBsML8bNbLhcbpqfsI0bYrgFkSCSMZ+2QAYJd8coiZJVjD1Hpx+psCz8apRQsaqwLV1oyivRiYYb0tAu3WauzpcF0DGWmxl3sHjmmjtsizqAmjW6Ni/BR0AvG07y+WTRJ4QSB6FQBGl3mrBYnvmdO2+d73QN9et1RxH7lfDDuqhy+o3VeSRpYy75mMxavT3HZCsBqzlTEMd10zd4dsVmmKkubaVSraq4lOhJRrWlK/reGvSyaPUBQPtuAiCVV3H3iLpTsYHpOTyyhP04QEw43TqJ64zFhoBldBpJwxYOmZatBHobxCTLWxpS97JBNgXoTvUAk7Vf82djXgwveLIIccIhh04B8JCKpUkNH+Ov1qUP3KGItKFNx1P7x10/FA0rg0wHyAsu1hLHhBgG1NvzT5FxcNWBY6j5fuRG1fHnL6VyWVgOyICUjzuFGDRCUap6ejhyvDs58d5JQ303h2+grWTv39qX+lKBfieK/Uren8v0NL/TCQkesbobbD/LQZjPmQlFtHQ1LDlBqLMyD9GBNjmJVP3jnRs/ShsbytTVBcNvIEmD0Oz/WfJSke5yJcD1dhvMD8KSaf
 4IiAI3pf
 MCGNpjtlc1JRuZ6Uuvpn1zx536QLLB7mOrhRE5RarDrSb42dezcPuf6bivNKjJDMhseHbK+EPJaDXd0fcQadcKkf+APkxp4I1IHVJUHpWMP+5XY1Y8Nmqs95Uptd2Lgkb8SKx/+TQWzVYHx4pQbpKupBo07/rW8jPe0yrWS+57ICmTnas1ZOdLl1+4C5q2+hELu7+jJEjBA2gp+42IxvqeGB9kTfQ9Pu0DgDanO70/dVWXFGZhA6yWHZ1DtkcTXLFNypRD/APFz3MPKIWa/aLaMLUQeayexw2UesgdeTbfWLsrDtHHBqu0kZN7Jql/wRdSs9Hg2F/bvTv9HpOiNAbl8V9USGalH+mRB42Ym6KuIMPxGE=
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


