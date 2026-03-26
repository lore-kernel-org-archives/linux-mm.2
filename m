Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A10C106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36EE56B00CB; Thu, 26 Mar 2026 05:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3207A6B00CC; Thu, 26 Mar 2026 05:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172066B00CE; Thu, 26 Mar 2026 05:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F22F96B00CB
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:56:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C75A1140341
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:02 +0000 (UTC)
X-FDA: 84587758164.03.789903F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 98BE41A000A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=b08ZOEfJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pShrlopN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=b08ZOEfJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pShrlopN;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iqluYAMrm+dlJHnbDot2ZiSjiPqYlwY3anHC6KE3E/0=;
	b=HsnHm3gzvU6CZC7b64HHa/OCPEPNSimS8YHtqGL1xSeau14xvwHzHr3hcTqkEovToaKvPY
	9lu6vo73drAYLA7d4Ze1qp/svJlSrOqEf/TM0SSRCEGPIcO4D2dEc0XBYNtiAazOWfJMh4
	F7fvDxESfmskhs50pwbVSukL/gNccf8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518960; a=rsa-sha256;
	cv=none;
	b=qcrhsvG/5Z70oZ4HS0Vp+zV167aBjEyPKc5+Gn2fVazkOP3UpJfU48NgNKyd7Kr1ka41So
	/xkQ2Oswzbq6VWZMyND5FQ3yiHq0tjgk4oks8y61PVpMvf1vA281p+h6UmAe7pyWTaLtQh
	fpxkIoz1zFHuU4UPTRY1B+54WtEGXN4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=b08ZOEfJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pShrlopN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=b08ZOEfJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pShrlopN;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5E82D4D282;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iqluYAMrm+dlJHnbDot2ZiSjiPqYlwY3anHC6KE3E/0=;
	b=b08ZOEfJtM2Ynt1u5G1/GAbwjMwgKPUxST1wMsTKKpdcjD2NhN5EBV29T+ReboLfn+MmGL
	ZMxyS5iQg+/k52/6RQL05KRL1liFfFYFYexTTvl1PUutVDhlPNdG79umPVg9JQSNDNI80/
	G4y7nRrXpMt8XlrXkh56jkt96/FoOmU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iqluYAMrm+dlJHnbDot2ZiSjiPqYlwY3anHC6KE3E/0=;
	b=pShrlopN7+EXYPlUD6CGFrvOK+DfsalAJqLpwNhE9jvBQprSz5I8bxfdPeZwtXEzz6000j
	Z9EJrP0bzadH50Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iqluYAMrm+dlJHnbDot2ZiSjiPqYlwY3anHC6KE3E/0=;
	b=b08ZOEfJtM2Ynt1u5G1/GAbwjMwgKPUxST1wMsTKKpdcjD2NhN5EBV29T+ReboLfn+MmGL
	ZMxyS5iQg+/k52/6RQL05KRL1liFfFYFYexTTvl1PUutVDhlPNdG79umPVg9JQSNDNI80/
	G4y7nRrXpMt8XlrXkh56jkt96/FoOmU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iqluYAMrm+dlJHnbDot2ZiSjiPqYlwY3anHC6KE3E/0=;
	b=pShrlopN7+EXYPlUD6CGFrvOK+DfsalAJqLpwNhE9jvBQprSz5I8bxfdPeZwtXEzz6000j
	Z9EJrP0bzadH50Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 53C934A0A9;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id S+RzFHUCxWncYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4319CA0C6A; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
	Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 23/42] fs: Stop using i_private_data for metadata bh tracking
Date: Thu, 26 Mar 2026 10:54:17 +0100
Message-ID: <20260326095354.16340-65-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1907; i=jack@suse.cz; h=from:subject; bh=g9XgltzhqZEAFeB2kTfq2H5zg7Kg1FLbfHn4nC/1sQ0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJFlCxxMASB9vH5ojG/AQXJTk5+dWsWbkKGk Hlm4JCwJcGJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCRQAKCRCcnaoHP2RA 2WDdCADNYweIxmM0eVGSwoohilwPuv2PxZEG08lAogRGbzNRzWGerA4Mb3r3SIaVaN6KXstCic+ RDMoS444Vyc09q/RiYPAqF3c9bOmL+ZCB63WVEcjlbi8T3+va2aOS5qTLGuySE5eJPrXtidm9z9 CIovP2aCrQp583wrhwlhLnOvLiUFJtljPh2LPhFqc3z4I2kPIrksXMze7nXnSdxToqoBZmSNtGq LVHpniSiQlAKoe8r2sFl+lwKHkSLndQKMkmMk4XST1yIU/ZdFPbuszGqy6gHnJbPo8WV/H/zISo PMoXZpIihwTQfvnOnwoAamOEUXbGz4ZzoydP3mzKoPSXVbLZ
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 98BE41A000A
X-Stat-Signature: kbc1sd17d387iqoyycu1ismm4e161cy7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774518960-896157
X-HE-Meta: U2FsdGVkX18tl8g6FT9ur88ApzDiQ0Y7ryK0Gd29ByYO00Sj0V3da1EMydRi4z0TRjfn5MXYMLIM1Eox/gyTGai2Sc/g4WvneRmVfrF10HETw5A71J8lNHUdHbWtSVAal9hZdeuXQOkb9c8+rv+obitDmm9aCtqXEuYNgkww1EKQeTHIyrvifUECFNYoeJGuX02Xq7BEU0XLiSa0o29Reh3WVLEsQXQvsOPdM8Gsb6yBCcCRcsm+FcQXx1JIn43m2uFKLAhk5oFRvPTKX8mYZrIyjMGB6c8tLrXPC3UeQ18byxHYQtZpKkxHM8QpRuy066J0mr9q9pTuEeHNxgCnyKeIWv5S6I6uBADxoBtlGyUHoWshJLqND3DMl1aX59vkswDNv1wJ3NUHGXCOjxVjlHU/SwMWXv8FmAt6PpfgKYsQ8lMGQbAliaTGZEugJs64q7v9VLP4LG3uzKH/orsbYWHlnm3jXxcmA62eoG2mf5ZaqKuEnKMDhIDKq7RtpD9xNjqQ50OQ7TMe8oQphVdIwu+VUWVOpXfTKEO5RhoIT9pMUZWrGi56ZMRWdtXRgNoHR05XFYxJBidwYBuFvIsYKHehY/M5Goc4ffaXCdhvCmOQS+1StLhY8Qzj3Tp/UQh1h+noLgKfmcyK3sIFYwYeZKZRIhu4CCYfc/oh6NfFyQy4ZhpHl2/NHw3PLoUAz167rIcPhBcCq/tWYfA+EmEmntXHtxh/5Fuq0khPet1JvIKf1kZFwciTVvUqADY55aMRh5l4qPK7ysBBADNcqRKzCLMmD/9J3fEaOLhAJg5TEToE7OuNckrmcqxWzh2Ghvsm0zwASzIhy1y7md4x6EeiGTEuaWWxiVWIV1fEUu/K/wFAQaXi8SlUGeKkyAKMp4A2smokFWAjw0IP8Xgdk2sdpAOAYTmg5e23zfiOHtLbY0sOsKqqBW83tEGAH+BxRpPm42nL+1e15XbgEOBVGw9
 gd8xtLb+
 etLfMx4xOf55yGywwPoxivh/ti/56hks9Z1yM/48wp5v/im3Dc0QThYFZ0lp06uFcYF2yKQHXm1ihYEHEfK4dxy2vDShJUTntA7Tllbyb+9es6aH6jg6oA9AYEVQcOmlXaGAn6I7XStKUNhJPr1szPqLIMxP2IohB8aFZnGUWrooNtWbDzEz5SdlzVe++4mS0vQ+ggr7fZPAuAilmRSoJcNKcalftLWN54k8CJLc55iHfnU/1W8JAVMCArE3DOlnkkgV3kNxpQl9BcLfpBtgn0c0gzr81jDiRS1pS/kVHjIlu3LPlToB82pLgKoCRet3EctdXH5lAK//420ToelCkkn57o8QUNXWY9wwGgCIGVAYfkGM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All filesystem using generic metadata bh tracking are using bdev mapping
as a backing for these bhs. Stop using i_private_data for it and get to
bdev mapping directly.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index bd48644e1bf8..c85ccfb1a4ec 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -574,9 +574,10 @@ static int osync_buffers_list(spinlock_t *lock, struct list_head *list)
  */
 int sync_mapping_buffers(struct address_space *mapping)
 {
-	struct address_space *buffer_mapping = mapping->i_private_data;
+	struct address_space *buffer_mapping =
+				mapping->host->i_sb->s_bdev->bd_mapping;
 
-	if (buffer_mapping == NULL || list_empty(&mapping->i_private_list))
+	if (list_empty(&mapping->i_private_list))
 		return 0;
 
 	return fsync_buffers_list(&buffer_mapping->i_private_lock,
@@ -679,11 +680,6 @@ void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode)
 	struct address_space *buffer_mapping = bh->b_folio->mapping;
 
 	mark_buffer_dirty(bh);
-	if (!mapping->i_private_data) {
-		mapping->i_private_data = buffer_mapping;
-	} else {
-		BUG_ON(mapping->i_private_data != buffer_mapping);
-	}
 	if (!bh->b_assoc_map) {
 		spin_lock(&buffer_mapping->i_private_lock);
 		list_move_tail(&bh->b_assoc_buffers,
@@ -868,7 +864,8 @@ void invalidate_inode_buffers(struct inode *inode)
 	if (inode_has_buffers(inode)) {
 		struct address_space *mapping = &inode->i_data;
 		struct list_head *list = &mapping->i_private_list;
-		struct address_space *buffer_mapping = mapping->i_private_data;
+		struct address_space *buffer_mapping =
+				mapping->host->i_sb->s_bdev->bd_mapping;
 
 		spin_lock(&buffer_mapping->i_private_lock);
 		while (!list_empty(list))
-- 
2.51.0


