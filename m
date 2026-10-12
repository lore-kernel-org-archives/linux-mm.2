Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B85C0CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 08:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A6D66B009B; Mon, 12 Oct 2026 04:24:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 885B16B009E; Mon, 12 Oct 2026 04:24:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795376B009D; Mon, 12 Oct 2026 04:24:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 552746B0098
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 04:24:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D06AE409E7
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:24:16 +0000 (UTC)
X-FDA: 85313286912.09.2837A15
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9C8D71C0006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:24:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ggo6qnBg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=H3uCJtkF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KoOpSGjb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lAXyifDo;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791793454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Olt3ZgSa2UaXkQo/gyyeUGbIfs1fUSSm5urEkriKz5I=;
	b=abceUi8lqEQxlGSgm2NNILrA1+rpCbyfykABqMWzV02P9Ut5wlCLKTNocpQnnXWv87LC7Y
	jTBFCLoxouaGjk0HUFTmXou+yhjYqK0/beNEaNSwQSA5dIhqaTZCcV3iC/JJxYd2SIx86G
	FsFpeEwrVMxpyk2L2bL1xds+nLnM56U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ggo6qnBg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=H3uCJtkF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KoOpSGjb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lAXyifDo;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791793454;
	b=jU+vM+4eu5Alanhlz3EPeKdtfL0P9SwJPOikzmzaZo5ObN/Ixw5GU7zngBxGQj0exVNU/B
	AtuiDgaX7fIJ6Y1xOpETFwlIUZUn1jiBCTM832jWZ6H4RooslAOtnv0W39iT/e1OU48sMy
	M0207f1tO8N4wmnu+aY/8lv/Nlnd6XA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F1FF621E43;
	Mon, 12 Oct 2026 08:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791793453; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Olt3ZgSa2UaXkQo/gyyeUGbIfs1fUSSm5urEkriKz5I=;
	b=Ggo6qnBgXypjIRWXtAP1AFs4OwNXHhs+3J/NJo+0vutZgDP7stupCtPg17nDWPfu9q15Pe
	ZE3Sclcll0AYcRN+uXUV5Qd3I08HYKXk3wHQfAro+pPgaRGr0x0GABk/Ce6cX5UsLL0xpy
	sJ2n9vgrpDeCfniKekHHlfJAkpXjHu8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791793453;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Olt3ZgSa2UaXkQo/gyyeUGbIfs1fUSSm5urEkriKz5I=;
	b=H3uCJtkFuHv6IGPtL0cQBAf32XW4GCaW/JIqCsYfJ2rXT+y23fgoEL6qIkWMZlMkiXGhZw
	gwX7mK0+M22pJeDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791793452; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Olt3ZgSa2UaXkQo/gyyeUGbIfs1fUSSm5urEkriKz5I=;
	b=KoOpSGjbevtf7bER5nbMnOHLNZW4NzbvrfrJBDZYJ9s/6FPkPdEi0TPDbSivKvB8NaNOyP
	Qo9X3U7Sm6sCsSwgVlcAzVYDNO6HhgWmabcSNJH9mVgdJQDe7SIoLuDUbJKheMzYanw2Xj
	mLh5o1JwHW1b6gcXkbpg+f2WbixNH+U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791793452;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Olt3ZgSa2UaXkQo/gyyeUGbIfs1fUSSm5urEkriKz5I=;
	b=lAXyifDouFVdI0vO5LUuj0Sq1EdVrY8coXuPB5YJR1leKjvV573UxfB78qJQnLbb3SghuF
	6xPe2cmkCdmdI7CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8821213794;
	Mon, 12 Oct 2026 08:24:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id g1geEyuZzGoOHwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 08:24:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A0FAEA140C; Mon, 12 Oct 2026 10:24:10 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 4/7] fs: Defer reclaim of unlinked inodes
Date: Mon, 12 Oct 2026 10:23:42 +0200
Message-ID: <20261012082356.3121725-11-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261009133253.20102-1-jack@suse.cz>
References: <20261009133253.20102-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1687; i=jack@suse.cz; h=from:subject; bh=q/GSyAYlC73bY1ffIrf+AcoWWY6+CO3n77kKwbH1Z0w=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBqzJkf1UVyyk+1usmrk7vODGw4uFw0itng5/yQX 7ttZEIlSmyJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCasyZHwAKCRCcnaoHP2RA 2dNyB/9w/MG5IP2tDdJDgZrSKv9EB34cgdYqW0eT6Nq1XJJSFCkrT8X7GSwPz1DLoAajflSosiZ NcSe/PjC0LZbdE/js+hk+u9Jfu4R4KTQQ5PgjfTAH+R0oxtBziirKJCymjzdr/0X6bVqvuka+ts zfoYdJUQQLWMoyumxQKnsKhiX/LJPk5QShDoWj7/fkjU3eh305zlBsQlhTkpxkEGoLLfqF3HCmx BIvstG0txarWVbfy98k/+ktMbKo1QTz3NTqeVNKL256JI7AwRJDde843HoJHPprPKrftHwzkZY6 krBby55ausged1wD4Mchg4/I5S/GZOPe3182lrKsdvyBexm+
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gqmfj899bjax3sqjzsgawdhx13drbxem
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C8D71C0006
X-Rspamd-Server: rspam08
X-HE-Tag: 1791793454-599661
X-HE-Meta: U2FsdGVkX1/fIQJOowuR+Xkjp78hOfq7EEkUbe1EfD0G965l2I5EyNUQsOsnt59wDxCLNgWILFGzFjMIVAAdjaXUPAF1aYJTCy3yu+P0dyXwmgGp2pIysxpgsXENBewNqT4PmWtIhAFkiMbAMMbD6M32dHSP5EYSDJe1rWNPOktSPAjG1PwVbUiJN31FB+tSEtXMsL/WUNIo6MoMZq3wtFESqe94itTcs8ZEQXF2Bmjx5DhBVWN1pHSEbPjyCbKcxVHt/F2C4el7wBcYqEuBVNvGkkxX8hCdKwSJlyjQq3nlyfCoRh3OgA7ayo6yOmUq/ku+Tb+ZsnsELKJasuKAxKvrt8zcJlC849IjP2Ia/Ayo+MdKLNR32MnXD7Nq7y4KxBAxcA9zJ2FgB+fn06ZPfzgIV2cRbN0ml5gNn5+uCgsnPO3WNXyX8QVBWucdIh/wjpEEOVG+In9KIP2TowJ3oF6c5ms3ULIx+7mTHJtJirSAyUe22FS+neOXlOfyTUfuhC0HvhxPH8XuOdLFida5idq4/kQx5O7Wx5jACVIMHIO/hm/deow34OIFoB493JDLZs1JTC0lXCefv8zvEZ8pJLlyf/iIep2PHIppBIFFTyrBpqF65Enb+qf7ugXikEDjMdBbCNg+v6/ieBe6A/R/qkbv1SUFnmJ0cV6rZzjQGonAH5tLPjpmj5jpt+EatYuKDaSm65JuEuXl+hKvyC3GoaRFQyUxXPZaw34YdsknSWYPHCW6aEKBFLHCbnL5abNJ34HPz/G1/abQWUPEfkB/BH3En7YZjp+dgCGAFrMWmHRhAzycGvi8yPKE0JQivpTynfkhDSGE/I2NpR4ROKrK86IdJYLshchbZS9RLFGGPSnAYezBiFg/R6JQYgl/Xeq94vTvLYKPriVjG1rY+zmOXNMO4YXzAN1qjwwNixwmefs3Y/yHUlHAyWtb8zSWVbLfTJk4g8mHioJMif7I7LF
 YQt2QXdj
 UCBmy7I77/NV9VSG4T2Cu67ZPOhQQD8XiYdztpW7C1HaWs7UU5xna84r0evBeLQFejnLqoI6L0xX4SWsbUOSDHvCFtYjWd2uJ3FMDcg3tZ/I0Ri6xdWvTaWMffRG8JHSreWaps9lJM0QnhXqjxzoyJ6fNpGC3DyO7heV67mNmdio4TL5Odhcc10AIA0Tt9hffkUYWAgHoiFnXgpyyAEbz4TguW3pJjHmnbiKpV5ZaOJRK0cI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sometimes it can happen that reclaim of some slab object drops the last
reference of an inode that is already unlinked. The frequently reported
case of this is a reclaim of overlayfs inode dropping the last reference
of an inode on upper filesystem. Because the inode is unlinked, evict()
will delete it which generally requires writing to the filesystem and
memory allocations - not good from kswapd or even direct reclaim. Defer
inode reclaim of unlinked inodes to a workqueue when the last inode
reference is dropped from a reclaim path.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index 0128db61217e..0b6335df9b48 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2214,6 +2214,23 @@ static void iput_final(struct inode *inode)
 	inode_lru_list_del(inode);
 	spin_unlock(&inode->i_lock);
 
+	/*
+	 * Are we going to delete this inode while in reclaim path? Likely
+	 * reclaim of some object (e.g. overlayfs inode) ended up dropping the
+	 * last reference to an already deleted inode. Offload the eviction as
+	 * it's likely to require memory allocations and block on IO. Since
+	 * this eviction was triggered by a reclaim of unrelated object, the
+	 * inode is already outliving the operation that originally deleted it
+	 * (unlink, file close...). A slightly longer delay thus should not be
+	 * observable by userspace.
+	 */
+	if (current->flags & PF_MEMALLOC && !inode->i_nlink) {
+		LIST_HEAD(defer);
+
+		list_add(&inode->i_lru, &defer);
+		queue_deferred_reclaim(sb, 1, &defer);
+		return;
+	}
 	evict(inode);
 }
 
-- 
2.51.0


