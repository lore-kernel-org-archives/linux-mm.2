Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 564FF606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 11:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=UNYAnBg6;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5u8ilGDe;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=UNYAnBg6;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5u8ilGDe
Received: by kanga.kvack.org (Postfix)
	id 8C7256B068E; Tue, 24 Nov 2026 06:59:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84DEE6B068A; Tue, 24 Nov 2026 06:59:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 345BA6B0690; Tue, 24 Nov 2026 06:59:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B26876B068E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:59:11 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E9D6240B5E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:59:10 +0000 (UTC)
X-FDA: 85469866860.01.046C02F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id CABAA100007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:59:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UNYAnBg6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5u8ilGDe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UNYAnBg6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5u8ilGDe;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795521549;
	b=BRcFSWXPVzRIBC647AS1iX+kPX5RXBU7kbH70cr79GfqBUofs1SsQkKw52NpWBD0EKtlaz
	ZKeuBs/8WY+zY0WswjNnLckxPzmwnCWFbTXHGepkNB8xvd+FPBfPmrQdXPkwmfZDdCmxGb
	667BDARJ2zG8W/Jn3qC9KdBkTBfPP5g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795521549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4dvS7ZLhan4maAO1jAthEDA4qGJsixJKMD6dhLuWOMw=;
	b=OkVy4KO4eRrNCcPq1sBtp+fRnpvTxZepKIV742+yEemvki8ZcubM8KrY/x1RBV2sWty9kG
	Pp87kovBOa/m5a525Sp7v3u9PZbO+7TTffw2PDYNyikiYej80IMbbVJ5Su59YbFBuOj18O
	UQPemXVQpVfX4W4r0GH5HDHalTd6d0g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UNYAnBg6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5u8ilGDe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UNYAnBg6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5u8ilGDe;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 774C01F388;
	Tue, 24 Nov 2026 11:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795521547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4dvS7ZLhan4maAO1jAthEDA4qGJsixJKMD6dhLuWOMw=;
	b=UNYAnBg6BHEkqKgbawJ/fAuTWWPkIsJGBvWHHDKzopwsoTc02gGd/+m2W2DDnQexohN8fM
	N5H7+K3kBRsyXJyXtevNorvI8eOQmUPMVCZrtT/CaM/6pV2y37N5PPSiFZj6H7gSE9L9ul
	CU40RL2b6Z1JkUxRAVRHocj0DdS1VbY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795521547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4dvS7ZLhan4maAO1jAthEDA4qGJsixJKMD6dhLuWOMw=;
	b=5u8ilGDeQW8E3L/oWFkjq5xiBD5CfmqMsQ2+X4Jg2s49Jq3IPRZT3y8pliM0gbzz1IDtNL
	aa2N7j/1LN0bcwCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795521547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4dvS7ZLhan4maAO1jAthEDA4qGJsixJKMD6dhLuWOMw=;
	b=UNYAnBg6BHEkqKgbawJ/fAuTWWPkIsJGBvWHHDKzopwsoTc02gGd/+m2W2DDnQexohN8fM
	N5H7+K3kBRsyXJyXtevNorvI8eOQmUPMVCZrtT/CaM/6pV2y37N5PPSiFZj6H7gSE9L9ul
	CU40RL2b6Z1JkUxRAVRHocj0DdS1VbY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795521547;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4dvS7ZLhan4maAO1jAthEDA4qGJsixJKMD6dhLuWOMw=;
	b=5u8ilGDeQW8E3L/oWFkjq5xiBD5CfmqMsQ2+X4Jg2s49Jq3IPRZT3y8pliM0gbzz1IDtNL
	aa2N7j/1LN0bcwCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1B64313736;
	Tue, 24 Nov 2026 11:59:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cBneKQp8BWtKZAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Nov 2026 11:59:07 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id E00712784D; Tue, 24 Nov 2026 12:59:01 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	<linux-mm@kvack.org>,
	Mikhail Rudenko <xyzzy@yandex-team.ru>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2 4/8] fs: Defer reclaim of unlinked inodes
Date: Tue, 24 Nov 2026 12:58:48 +0100
Message-ID: <20261124115850.3512-12-jack@suse.cz>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261124113450.3451-1-jack@suse.cz>
References: <20261124113450.3451-1-jack@suse.cz>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1687; i=jack@suse.cz; h=from:subject; bh=Sf2JWdFsQy1u7TCe/OfACrFdNWvBNlkYL7de6vW/KLQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBrBXv8vBQwjao9n51leSYLrf9RiT9fdHqp3NXb+ bppjNo+ZQqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCawV7/AAKCRCcnaoHP2RA 2cAMB/4vNfLyy0JglxreKU9SyfYA6xvsORqfYfP8oxZuiZymNWvBLXfEEI8X3YVm78uU6T64Dh9 JYlZ21TWpFoBUyDP4nzB8s5+Tq6ccUkwgiZt7BONjfIi0af2XAO1B4qb6BbxcO3ot5GU8p9zhLF TNtVNYh9UOpzwq2FNobKRnGWbYXluPlakFDArxPxPmY2MMhQx2xLOfi6HXfTF5mVLhZzzwWWncl VW6qQ4QhEzrTmsZ7EQ4j00+vX9cQY2k7DHHplEdh/mqHvi6CMQ3IRulX1J+Srn+sEUkKSIg8nCv hL3CK8F+Cg1itCetU/XT9A7i12wzWF+xG5kAnUkBwYdsttyW
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -11.80
X-Stat-Signature: dmggzc55tg3bpswcmeq35hi95z6bgesn
X-Rspamd-Queue-Id: CABAA100007
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795521548-41105
X-HE-Meta: U2FsdGVkX1/ct8HuSd0FmoKbnCqJuOR8K4utbXzi9LenrJIGPh6iu1T38R+XbhO2FtNHQ5dayiG/OUTdZc754AHG4zvA8xWNhO56HJ+Xr169Uraq0YPbzkDQLfc229zJbog4na30m8bXJIXlzCXqJPlhheoDQUpVbD0ZeAjwa3yK1PUuSAdFEL8SASefAxa3KjJumRsKjeI8XoOMtmcRVaJmqr91M5bBZEaFAWvZLYjMRVR2UM2PggmmQVwbVws7KtbpHO7uwR3i1++8AMhOysrnNqAfTmJFmYrDdbhRE6dYmz2ZHtb8OtSmaD5EvHs1rgSqTV/hS7k9c8ngd8tgnfPFaq4fiO0hudRHDjKqdGgdmyp+Qo3BuLreg1fI52g8vEs2DWydxzDtTsNqmunPrbJ1UcEVLZFaEXVLXQViQSB9EUzXp9TRO2W9gCkf/qewDs4Mhw9rwOHSlc1egYve96ZUNIPHLeUz3b9ndVtX7aIwjTLZzmYV0jxH2ax6sywKnsW+4BphOcpL8EZhWt6xb2GIV9Yl0WpvGYvkU/DUSX1xnhs4sIHye1gqa/4VHYnYYGxw8FFhCcpIgkCCHKjQe9T0CqYL6l+Pnt06tXzwoK8BnJsHIp8CEeygrqnHtUwDlek8A82u+f15ved0aZbdbB+nsFYwKShaQf3DD15PBHJMQ02PzdFjexshUnbzV+ncSHjHGsSQ07fsD/TCZUG4UdssLvtgoCZUIm+qyBCDK9wRTiVJDAYBJbkaK5U0ZFQrqXrMmlXeT0/Cg0My6A6Z6z5LzkP4QLxhcoCAhk7IgsNuNV8MA55nq+jfW23BXifCtyvNtuvEPGlxyYJFttvcYp/MWdOLrLAg/M/Ksnq0AVQjcNZI6Kc5Q05Z64rMvXYNSS90IfUd7JIEzG49wJuHQlm6kOcXsJbx4zoopT6swgWrtRWJFS51rnbTuSV2P3dedwjtqyZVUzsExg3z5rG
 R8hZ6MCi
 CpA5j0+7Zch3gH3dWsSRjk8Fh6TMHWfQqhfmjs9TlGi2J4AvgimxwE76VBimkXWshk803T9GpWeX9+Z8p1kAW4Kkxkz/tfOHn8C18dJ5XncWuNuq+gIs3oqxpc9qgEbJ49bO5h9OF23qnQWZ9xkWkMmqw+l0U5b3c2geSTMjZPz1pXbvm7pQWnKxsj/JJTde8bGCd31V+FGHQdiknGd27eziJJn8lLea5kiN3WdTkUhhhVZ0Y7DsvvR+Ssa/xXcnNKnWERXAh9MOfK0WZJCdvg4ciIIsqahDuNgowWJJlKCEMP1IAuAs9eWg+cg1jOlsHN+b0JbtIMsDF+gLAtVFCsEyc+CpMdNmjrNcw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index e08c6f0b0336..4ffafb101718 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2239,6 +2239,23 @@ static void iput_final(struct inode *inode)
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
2.53.0


