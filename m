Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2750F483C8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 16:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D2346B008C; Mon, 23 Mar 2026 12:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482DD6B0092; Mon, 23 Mar 2026 12:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 371606B0093; Mon, 23 Mar 2026 12:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2191C6B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:30:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C72491ED96
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:30:43 +0000 (UTC)
X-FDA: 84577866366.15.6CEC3D6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 63DBC1C0010
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:30:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=24Luw+Zi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=b8AtuUMm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="2Zcsqt/C";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q+fbfhhz;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774283441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i5iuLS0psgv4UG8NJ/JK0vW/OF0QFB3QPjhdjzpUBtM=;
	b=rHih+uHpUxfxuPfTgy8bQS3/KALdAaEXrJYKqLZOhHGw/Q9Lx7+aQa0lN984Tq2RFLxUdH
	K2+cBSF3WmAbonly67oTfM1nKonp0GpU+naVlOY6niBBRrZCRQcEUqI+Pj2pePqX5XD3YJ
	Kr36mtXaIicIHlrqxeJnRi5X3Nvm1ls=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=24Luw+Zi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=b8AtuUMm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="2Zcsqt/C";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q+fbfhhz;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774283441; a=rsa-sha256;
	cv=none;
	b=vnLjAaHluMkKj/xC2LHSvUBh3sVwy1QB7IWwk5NCq5RjcI4GrhVQtWSEUovl13IcIkkERg
	1U9pRigNtENqU1o4DlPkN37WVYWNlAsQpZ+/cZBPJuDgOuZyN+FUrJqOcSaTsilTFpQJnf
	M0lLuk0XGhtDacSkT5J0R/rLQEOPMTk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0DF365BE42;
	Mon, 23 Mar 2026 16:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774283433; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i5iuLS0psgv4UG8NJ/JK0vW/OF0QFB3QPjhdjzpUBtM=;
	b=24Luw+Zib8abmfPFof4TwsNu04kCpEOSr4001cUnVAelXrgllci1V58YTHqZ/v8BDYBjc9
	AyrzP6i/t1nfuBIMPNM+OXECbWbjPFntL1kYX2itWnAo5BFTWsWZl2XBT0FEsBJa8Qah9W
	BoZc8ubauZnlBBfo4dFDGZwgl83inI0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774283433;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i5iuLS0psgv4UG8NJ/JK0vW/OF0QFB3QPjhdjzpUBtM=;
	b=b8AtuUMm7kSBU/govh+vlhMS6Zss7tx58cCkgwz4xlt5WuLG/Yg8SXOg4FHqtHIMjeuSQm
	ykC4qMw4n9/7cRDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774283432; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i5iuLS0psgv4UG8NJ/JK0vW/OF0QFB3QPjhdjzpUBtM=;
	b=2Zcsqt/CyowgVP56Qowv78KB2Sv/kq5rICPB9xRd94WPsQKh/thw0vCGRKKf/nqUVIqM2w
	YijCTKE9bof9FrdmsO+OLodhLlHVW7U4pfsEQf7z/NvSCANoG9xZZDpqbUfTqqPYkyR7To
	PzMg/L6p7K5XLiXThgKAbn97u7KOYlY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774283432;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i5iuLS0psgv4UG8NJ/JK0vW/OF0QFB3QPjhdjzpUBtM=;
	b=Q+fbfhhzdZqMWDwz1BK8FGkc+ErwaOq+pNxisuAR1orr3uZV/ZT0Zr01cBbIYbTAFZozlN
	WroFkOxR105JhFAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 042CF43982;
	Mon, 23 Mar 2026 16:30:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NiD9AKhqwWm5IAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Mar 2026 16:30:32 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C15F9A0B52; Mon, 23 Mar 2026 17:30:27 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-mm@kvack.org>,
	Jan Kara <jack@suse.cz>,
	Jianzhou Zhao <luckd0g@163.com>
Subject: [PATCH 2/2] udf: Fix race between file type conversion and writeback
Date: Mon, 23 Mar 2026 17:30:12 +0100
Message-ID: <20260323163015.3734-4-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260323162617.2421-1-jack@suse.cz>
References: <20260323162617.2421-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2889; i=jack@suse.cz; h=from:subject; bh=OGtjOocrdKlqdiQI/dLkm6fbhUNhmW9EfdpUfc3cwlI=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpwWqYOmwFD8j2urUJzv7/cLydciVl2UeoswRcJ BTSLcAUzOiJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacFqmAAKCRCcnaoHP2RA 2XYgB/9V8mQRIPq9vDoBcx1bRAbmrW1/uL/mI4rfohUfnFh/qEkQZtyM3/QN03HnY8cEM/W0028 w2s0CpKdbvsvXyC33a7GwXIo/DOz62sTIWa2IU6JsnFyVzKd/0egxhm/+jxuzI+ZiOM83zYx0+b Rg5ubVg82HBb4qWSEcGkgdZjipqjhikuDbqqgimiPpRvdt7HPmkiDL7co2aPsTnxUq5ex++Mzkf owMvK7cZjli3eTLmJQ2ygWh5+QpGAYlhu088hkXzKGuhIgQMhF8ASDPr/VpvhRmNN3rcjWHLame 7AHapxq4ZT+eyKe2n4wW+V5dhQgZgOEzXP1qCeakSXCP1neE
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: cqxty3azquyu1h8rira355zb4bidiqei
X-Rspamd-Queue-Id: 63DBC1C0010
X-Rspamd-Server: rspam09
X-HE-Tag: 1774283441-688216
X-HE-Meta: U2FsdGVkX1++GXU9OQtvXspoG64Ae/P6gD+0pLbdwhcTXSIKknNg1GMrQ4EvN+Cc+3mnQDCIjQYrK3Q9ixgW0Fn9UrVy8SncV1TYCRFRkoOqWwunwK5M1eaVrUwSD+CKen0LOSfR6NlY89s7ZRIrBu5L576BbMS97XqlnxKvc7oOyJTa2bIb3EgFRPqJrfSUN1EtZR/BXfJK3OroDpOO8ThDEUnB2C+OTXGpknFC7ZTWGJ22LgwmElZqe7MngNQjizM4wF9o4HpoWZp3ISXhp/i9njkGyfaz1Kz9hKtyKaQWX/+EH3cl1m3NnY4D1OIh2He9G0bpkg4a8i7IBQPEz0StNS2tRkaM7/pWSFvlZgLbKprj/U3H6L9ZSCjI4kZb7oNY38T+PaqgUZT/WDhFN7I/Of4Ao3jKyEVNVMEY46xLGCG2F1/cETJvexrcBjP348DvUgtrQJHv64aB/Kds45kLljuY40kJYNWaU6U8GECk7YKA3BG5kmf22J0G9k8YQ910tzJ0Bq6nsx5tZZfVRJP/d/t9xyLBafOXRlVjhclrLf3KomR0ax8wDKtxQ9Q0KZRDEoMQE2lkO1RXblMeVwxnLQBIBkCPPAL79x/OUdf8Idah9U2gBTSjrMBdNrqWh9fD9azljfppKs8CVK44B4sHdSkO02GyfLQ8SYG132/4WP5Gomffj4GvoL5UsnnaIl3uFh1PFS2DuupnQsaV0DbGwEyLv9Wros+Acc2PtAnDCq/Rr0MhKuMyxDTxVkF0QBVhwewwAYnDFTncNa0ptuoZL2FA9treINatgEzQjH4NS2FDgThcsSuYovbDBWIrr9wTamuG06rVhCic9TV911Wu+5o0VxGqtiOIUJ3INNblLsicE4cLFOcS1ejFPzUvhBu5O+Zpf3PUn1z1eV2btG6V1ppSMG9v2zFFNDlBlEYbC9gSqWsYrwbEB7EhGOISouXpIDIJrOvoPMkpBL1
 wQM5EzKZ
 idITzEe1h5+k1636r+4xDVApV/6ub7n8XiluDkrASBxShwIkLQTia8O6qOaHkGpv+3IRgmbq+UIWRARLJQjU6rmUwCFzDvVWuLXh5MtyocWuqKMm7r03s4ZsYaLvYjYZyqG0TT57UfWouKaBgPJYufSMk1EEk14NB16vP6RJXjlXsU6PiuSe8xlnap6rxPExN0WWRruuzhTH+ve4G0b5xq4jGZMiMsIarnCmGNzu9hDXmbf+1z3ZtBFPWjQS+ns2p+l7CpKdFk1w6CG0gZsnCLMcu/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

udf_setsize() can race with udf_writepages() as follows:

udf_setsize()			udf_writepages()
				  if (iinfo->i_alloc_type ==
						ICBTAG_FLAG_AD_IN_ICB)
  err = udf_expand_file_adinicb(inode);
  err = udf_extend_file(inode, newsize);
				    udf_adinicb_writepages()
				      memcpy_from_file_folio() - crash
					because inode size is too big.

Fix the problem by rechecking file type under folio lock in
udf_writepages() which properly serializes with
udf_expand_file_adinicb(). Since it is quite difficult to implement this
locking with current writeback_iter() logic, let's just opencode the
logic necessary to prepare (the only) folio the inode can have for
writeback.

Reported-by: Jianzhou Zhao <luckd0g@163.com>
Link: https://lore.kernel.org/all/f622c01.67ac.19cdbdd777d.Coremail.luckd0g@163.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 7fae8002344a..8ca73893ce2c 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -181,34 +181,38 @@ static void udf_write_failed(struct address_space *mapping, loff_t to)
 	}
 }
 
-static int udf_adinicb_writepages(struct address_space *mapping,
-		      struct writeback_control *wbc)
+static int udf_writepages(struct address_space *mapping,
+			  struct writeback_control *wbc)
 {
 	struct inode *inode = mapping->host;
 	struct udf_inode_info *iinfo = UDF_I(inode);
-	struct folio *folio = NULL;
-	int error = 0;
 
-	while ((folio = writeback_iter(mapping, wbc, folio, &error))) {
-		BUG_ON(!folio_test_locked(folio));
-		BUG_ON(folio->index != 0);
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
+		struct folio *folio;
+
+		folio = filemap_lock_folio(mapping, 0);
+		if (!folio)
+			return 0;
+		/*
+		 * Recheck inode type under folio lock when we are protected
+		 * against udf_expand_file_adinicb(). Bail to standard writeback
+		 * path if file got expanded.
+		 */
+		if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
+			folio_unlock(folio);
+			goto mpage_writeback;
+		}
+		if (folio_prepare_writeback(mapping, wbc, folio)) {
+			folio_unlock(folio);
+			return 0;
+		}
 		memcpy_from_file_folio(iinfo->i_data + iinfo->i_lenEAttr, folio,
 				0, i_size_read(inode));
 		folio_unlock(folio);
+		mark_inode_dirty(inode);
+		return 0;
 	}
-
-	mark_inode_dirty(inode);
-	return 0;
-}
-
-static int udf_writepages(struct address_space *mapping,
-			  struct writeback_control *wbc)
-{
-	struct inode *inode = mapping->host;
-	struct udf_inode_info *iinfo = UDF_I(inode);
-
-	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
-		return udf_adinicb_writepages(mapping, wbc);
+mpage_writeback:
 	return mpage_writepages(mapping, wbc, udf_get_block_wb);
 }
 
-- 
2.51.0


