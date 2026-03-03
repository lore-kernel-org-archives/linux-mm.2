Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94CFBEC1423
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F24276B010E; Tue,  3 Mar 2026 05:35:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECC8F6B010D; Tue,  3 Mar 2026 05:35:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7AED6B010F; Tue,  3 Mar 2026 05:35:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF1E96B010B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:35:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 84DC113AD45
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:27 +0000 (UTC)
X-FDA: 84504395094.15.577204E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 417921A0002
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=03MCN+dR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RFA4Hsw9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=03MCN+dR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RFA4Hsw9;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IPthJE6VVMGk/qjtQ/G9eE0lKHs2glQSc7ppBVHf+S0=;
	b=NK/AB0OqpyM2JmL4BxnipGCub2cR7PGTXlKY5GQzl5wViNsJSE0Baxl6QB1Bq+RGL2J5dt
	TK7wc00XvpQe+uzaAlsBRZDEmEPtfOWD1d5JBopSr83gDx3GyCcJWlEBsjis60NoDBHh/N
	s5GJt+Hcfo1PfXQ2+95zWrS7+ffB7R4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534125; a=rsa-sha256;
	cv=none;
	b=AwcnzV6fRDf5EoWIUg6nFp3J0O7eg7l/kjeDXy1Tpgn4qRWDPHKymEbT62sH/YeBS/+mwC
	ZFNriCncqCyWmfj/ZXiPoOEAuwGfwF5jsWeFsKMnXeesC+9SpNU6Hr/unBxmCcjrc9UR0P
	34d04vqVNwmPHNB/eqKV30r1+s25GSA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=03MCN+dR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RFA4Hsw9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=03MCN+dR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RFA4Hsw9;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 097A53F91A;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IPthJE6VVMGk/qjtQ/G9eE0lKHs2glQSc7ppBVHf+S0=;
	b=03MCN+dR1GVa7o9znWI2olxlHaWCH06h06tIe9FA/qKtVOg0uo3eHyIlIojahXdqfHZkCT
	/VaNr0VTeHaeDtBt9YCsPa4KdjKfjUrRPYW+n3IVC3PoCdKeqRgiZOxu+wUrlarOhOtGBX
	L7x7AbNR9g5MQmcXTrfVyiBk7jn8I6c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IPthJE6VVMGk/qjtQ/G9eE0lKHs2glQSc7ppBVHf+S0=;
	b=RFA4Hsw9cN7NoXU+etKkvj9XHg7IbEpOJNGzgfI8A/ptlUTmzCIQsIk80olHe09GcVmL2s
	Am+0L1MMLdEJX8BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IPthJE6VVMGk/qjtQ/G9eE0lKHs2glQSc7ppBVHf+S0=;
	b=03MCN+dR1GVa7o9znWI2olxlHaWCH06h06tIe9FA/qKtVOg0uo3eHyIlIojahXdqfHZkCT
	/VaNr0VTeHaeDtBt9YCsPa4KdjKfjUrRPYW+n3IVC3PoCdKeqRgiZOxu+wUrlarOhOtGBX
	L7x7AbNR9g5MQmcXTrfVyiBk7jn8I6c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IPthJE6VVMGk/qjtQ/G9eE0lKHs2glQSc7ppBVHf+S0=;
	b=RFA4Hsw9cN7NoXU+etKkvj9XHg7IbEpOJNGzgfI8A/ptlUTmzCIQsIk80olHe09GcVmL2s
	Am+0L1MMLdEJX8BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ED7373EA6C;
	Tue,  3 Mar 2026 10:34:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DPkDOkS5pmluFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A025EA0B47; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
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
	Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	gfs2@lists.linux.dev
Subject: [PATCH 11/32] gfs2: Don't zero i_private_data
Date: Tue,  3 Mar 2026 11:34:00 +0100
Message-ID: <20260303103406.4355-43-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=669; i=jack@suse.cz; h=from:subject; bh=xOXiQzAtrNWDiR7AO50veb6qdtBrMAe4XfXWWLiNxX8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprknbtjHRMGivtKh5++SBYmELyG3KBGp9gefM MGDwJ6NPnGJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5JwAKCRCcnaoHP2RA 2fx1B/kBKNGudUfUYTJuii1aG06VLA/8KFxWPRhB/7z2V9FoDKcR1RHvsBw6gjXgvNcYsyAfcta Su7QOV47Wo9rvgttIYC1ZeAwkxwrURJzVbVIbPNxRaRTPY4iLGivNJQdohTBhrjCdGZxLpkpT3g NNhO8eouLhfk/wjZOkfKXPitXt5O5QT8p8AgMwxgekOB4Zh64imv/x4UHbDUgrDrFF6z5Ps50bx MIsbDXr8dS2nOk5TGRodIhxGCv7yBF+l8lS6Ss5ixIrl9uRQ18v0/rs38VQVcWkg4V8vExQ88S+ YdfbBGrMD5nC6yH7OLMjT08VmyZrxHtf8Rz0N+NBKLWxizrh
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: tset355p5fyqkzibgz89npe81a9em5da
X-Rspamd-Queue-Id: 417921A0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1772534125-622581
X-HE-Meta: U2FsdGVkX19Xxw8I6dv9kxvhdebOdW6U6Ka7WCOnvvhAGGU7cT9+Hmt4Tr5ZC1b6ACmL/9jK5KxC07XR5GuOtP3COn+n+s5GRpQwLkiiytGqkAN+qLnL+n4Tw1h3J45spWAdz1ITkPmmd6wEDAf97kFucZ9utXkL8dQoJp4dLQxaabulf4W1KGXK6W6ST7F/Moy4TcSVAbXIEMWHjJa+8V5QvpA5nIXjuntJpmLQHCu2BlfLwXcPQ/OjS//yNd6yg3APv1T+lCRW5NwzTxIA/fZldJ/6SVtaOs/59I4mOQ4RDdvFITL+duU70fr08M6tOlwe+45tkM7Ic2ifeQ1XSM0QPOLzHgk/Tvzp03QdMa5Hz8oi3+9shSn3pnO7Vwb3dw9eijwDnXa0hXeMgU5hJRhUVOkY0YDf/nsSyzZ8YoHxF901H3hahl+w4t0gahP69fyaQlW3mYHsDlUeMwD3wnYxttJMizw65ppFzeZdUcFt2bmWeYjgc4rylNxNG8E+1pHTnzaIy05dJP/dFyeO1p9TwyjUtK6nSaL5REXE0NsuoPW8pYb7aaPPkFFdKh8jSdsa2LQ5Y//qR9pWlcTMhbvPCOOY8FkwbA/QZMQgJiNKa14fSFNEfm6m4PbkRNAlx9r8zdi9KGSe2tLtmgVtHJb/tWEwb/Tx7BsK2FfWhFCDdsot3J9jrW5LwO4HGcobT/Ca/yYwjNLU0wD2VPVRC/VKoxKBc/nNKAPA8cR93SnpgSIBiArsY8cNHgYIer5/Dj4Lom+31BNMe/6ck/7BxYhmFUpxTUU6QeerrtBV7FRnYjMF+hcyzdOmfNxp1yoSRplGyBFDnf4DnPUTuGgoMlvVK3tZQ3+VG8UDQCybZ69pN35iMS0CbOpxTyAWMhLx85ufojQM/8tWylQmreRQ12R6UDOKpoCYlf/l/F+bzpfBecmec3RPlg/ibC4VhCKjudQMVsjDGkhFPCzaUTB
 8wR/nQN5
 sS0lHPA18CFHL5z6gvQMHwunqvt722RNqtSY96oq/N6Q665SAcOkR+IcnI7IqJLh9WpF0Ee4yJL9yMesSuo755+4LrGfyavjDm+d+An0q9s/GeVA6uf3tnNNp8bq+dydSoXlZMwLynRiOjoTpzYERtbw9byaQqHQqkvoElsVKvUxzWIPmglk/hjVyY8jQP0v6uIA2exXeoDPgC8uYRlgLFZ1X4lyzIZRo6D796OvhtY81vu5BM2hC5xLR2BU0zfo/vWeMnJSI2ZLufqBF1rBXtyby4n0HETb+4QmtYhRPMVOeyXCU1n/cH3Xq3L/YGWZMjyyyws/9coX3mVw8WcbaLZpCuHoMa+Hn72+f7c3r/V45kP2LPs/Hj+PThwNkTk+2tNft
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The zeroing is the only use within gfs2 so it is pointless.

CC: Andreas Gruenbacher <agruenba@redhat.com>
CC: gfs2@lists.linux.dev
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/gfs2/glock.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 2acbabccc8ad..b8a144d3a73b 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1149,7 +1149,6 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 		mapping->flags = 0;
 		gfp_mask = mapping_gfp_mask(sdp->sd_inode->i_mapping);
 		mapping_set_gfp_mask(mapping, gfp_mask);
-		mapping->i_private_data = NULL;
 		mapping->writeback_index = 0;
 	}
 
-- 
2.51.0


