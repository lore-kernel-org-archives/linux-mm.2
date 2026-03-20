Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C22B11098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14AEA6B00C7; Fri, 20 Mar 2026 09:42:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0843B6B00CA; Fri, 20 Mar 2026 09:42:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E40C86B00CB; Fri, 20 Mar 2026 09:42:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCB776B00CA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 90E611399E7
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:51 +0000 (UTC)
X-FDA: 84566556942.20.3580E5B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3F96F100011
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iGDkbC3T;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="UW/nILKd";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iGDkbC3T;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="UW/nILKd";
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9lvp0R++qfQWARB56fqfCbW048zMxlpbF5E2oVGpTao=;
	b=xZSG7jvty+kC8hipGHeSlm2oPAC8tnhEw4QRpNHXPfqKVEItW2ayFOs8eMQXWZpmdCnuiv
	CEGIWZCZGdLjNk8ncYb97V739HX8w9o66gRG2cw6b/XolkGxLycbVbyY2td7g6hZcvzqjS
	PYYzuQ02ozPEB2cWnsZLEbuIwijC8jI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iGDkbC3T;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="UW/nILKd";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iGDkbC3T;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="UW/nILKd";
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014169; a=rsa-sha256;
	cv=none;
	b=BJwZysdC0BNXQmtZQM2hr0wEuM4KKySB40mOg/xLkBU/wOvrdqIbYny9ZiiJ+3o8CVmRGW
	Hv+iJZGFFXk1Bq0zEQZQ+496b3J/Irlu7NXsHpqsf4p6mbIE8bDi/Scqu0j0VsuZLeZ91k
	/+Ncied/SW1H0ZZHlOzpSvGn0ODCGd8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6D6724D295;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9lvp0R++qfQWARB56fqfCbW048zMxlpbF5E2oVGpTao=;
	b=iGDkbC3TguVpc9x2TaHn3C7kICYSCScxr2q3PEBd81G4txT8jDRVEbn0SzfvjnIpuEmPex
	Dr4rj8NR0FeddJtcodZKchExNMeyUhPVIeHhhviU/FHwai7za0xeqQr63kpBdhUFEyfegq
	tj+nBH2Bue8Fpk6ifPm9hCwIlYrbxwA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9lvp0R++qfQWARB56fqfCbW048zMxlpbF5E2oVGpTao=;
	b=UW/nILKdQOU42hie44SeI16+UAR74nyedUhHNm7ncdtBWOEmlJWXRgZI62MMsh6iwAAMP8
	o5nutzcZxYLtogBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9lvp0R++qfQWARB56fqfCbW048zMxlpbF5E2oVGpTao=;
	b=iGDkbC3TguVpc9x2TaHn3C7kICYSCScxr2q3PEBd81G4txT8jDRVEbn0SzfvjnIpuEmPex
	Dr4rj8NR0FeddJtcodZKchExNMeyUhPVIeHhhviU/FHwai7za0xeqQr63kpBdhUFEyfegq
	tj+nBH2Bue8Fpk6ifPm9hCwIlYrbxwA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9lvp0R++qfQWARB56fqfCbW048zMxlpbF5E2oVGpTao=;
	b=UW/nILKdQOU42hie44SeI16+UAR74nyedUhHNm7ncdtBWOEmlJWXRgZI62MMsh6iwAAMP8
	o5nutzcZxYLtogBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63ECB4281B;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZPViGJlOvWl7CQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 11880A0A81; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 22/41] hugetlbfs: Stop using i_private_data
Date: Fri, 20 Mar 2026 14:41:17 +0100
Message-ID: <20260320134100.20731-63-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3135; i=jack@suse.cz; h=from:subject; bh=ei9DWvxNUOA+Oc2Fqc3sajLvM+z4f9VHF0jmEE/iXJU=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5/W3YOBHarNBWcT2Vha4q+EAh76n0VqIP38 rGiDPH41pCJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OfwAKCRCcnaoHP2RA 2WZYCAC/vIK/RR/oIV+YY1l6eoQR1fUYsao5JPpNuTmerMjTswzrkcs7cTugxN70XNnb0AFZUWQ 4QDYqKN0CPvnS6XxBo+HeqfNoVSqGpeC95J9MsvxoTxRS8PibHe/LkhA5mh525XIZCDPLbwFA38 9xaLnCgO7UM42NZ5oawYmhNWSdpMBVQArUc51iV/NBjIljAafSPy0Y0OySfCWPQ0flpvl2CAdYK 7/ufeo6278Is9wxFmbj8nny5zIpCgnPFnXUZ7NuU1KWtyhxDZ11MxXxEr/RKgQ4+iRHqOczCA2p xHp4MxixPmQ9hfaeM1q5PAkPMuYuBw5DICxFJ8Bk0t2O2O73
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3F96F100011
X-Stat-Signature: wi4gscuy7794t6hxmmg74mkqhxxkgcd9
X-Rspam-User: 
X-HE-Tag: 1774014168-169117
X-HE-Meta: U2FsdGVkX19c/6QS35Qi2GmlKLeN60UjWIioVsCm6Fyw9s3ioclliHfSMJ8IopdrM99ISW5cuzTR8bPZXzaKmkgP4F4BRRpcgFqyAtZx1LQpJH2oeCU4ToTLGw/QbPTVaWax6QwDwlCr1eeob66+N0tV+qBvnCjqtKptN8qpHUwuhXM7JYTuIBAjNvRotw8Z/3tPMzqv4OH34fjJq/ZbUIH3uH7+6MwtkE/YkgfDDEL2JaSBD3/SsUqMJgER6Z0+vHMBQA/WeaqA8brqbQOTegRn34BO8KAB0n8i4BeW+2spD5h9L/uQrRJYEzUn41J2psqcX+Hf5QZtOji6EJ9mLLKt4zO1qV3UfEIgpen0v1s4CR6BwDlfCVhqJ2H3qTKUO9EiuBJMKvQO26VQVuTusvOTB715YBGB6LiL1kJqCTdrstsuGpEUYFDn2gQwGZU6Rm+cU86Ti6RrhvjTPvQbqLsnIvaF5cJ/QDsSv8/KxjgDEEJbHkK0+tL5oeTnZJM3EUKsrND51QviD7DH8cLh8ErrxeFj0e5inBSCRBR2DpVp+rdraF1eQW/ttXdOGouVn3Wh8kQ3rxKPvhVP9vU/OBW2lT29KbRWT5m8SlPFtvxY0ljsI41iL3vcXqLgXvCsA9aWSqYjzZrotZQcfQ3y0HtL2wTkBLQ5dHVkuRpy7qR229d99J6jjSUbN3D1WEv7OCsGdlkxObUdDrNPit7JVeFxD5d5oH+lFOdp9MSleHl307KTZayCQOoqUtY0G3HEWnaHn1CMlAbGSB6rjCgzBWdO8bSL4l1ajsFQGbEY0XmBIlti6oZJ50JUxHkmAT8lRIg+TKaNExmItCQX/+tEr1cjuy6pC2jgrG8qb7xWCgUrI6GEt/d8e8aiV5WpKLVm4kcJWmgruDsYZLk3NeGO3hDOZwJQcE5nu17ZngUQJwfR7fCx4Azu0+pIvl4OHkCSuRjbTyHbEDnHtE2O/CX
 kfup3QQx
 xY9C5QpUVDxR4f4RbyKrqYmy2Wu97MlG+NBYunmHnDUxtw2bZj5FGbYbEdQl+CU47NERi8/aVm6bdGbHPbEdZiC/EWq2IkiN871ROKZ4d3EYXX2kQGp2QjpzYp+m1QGIn+hkP362TBQw1e44Ku91uW4S+likjXWethA90hHt+I/TNF1gK3esAIBr7LuuKOxCfHWsy0A4e8x0E532EVOJtb0Ntb/ffc36nbv4e5CH1d1xuOnUTQP3i/98tH9eHtIgPjnpOfnh5J7TVOTO9DDBWP/yFxUXLUqW4glbIWfN+hPKPQTT7zNo0CIcL1G1N2fqrGieO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of using i_private_data for resv_map pointer add the pointer
into hugetlbfs private part of the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/hugetlbfs/inode.c    | 11 +++--------
 include/linux/hugetlb.h |  1 +
 mm/hugetlb.c            | 10 +---------
 3 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3f70c47981de..6ad02493adfd 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -622,13 +622,7 @@ static void hugetlbfs_evict_inode(struct inode *inode)
 	trace_hugetlbfs_evict_inode(inode);
 	remove_inode_hugepages(inode, 0, LLONG_MAX);
 
-	/*
-	 * Get the resv_map from the address space embedded in the inode.
-	 * This is the address space which points to any resv_map allocated
-	 * at inode creation time.  If this is a device special inode,
-	 * i_mapping may not point to the original address space.
-	 */
-	resv_map = (struct resv_map *)(&inode->i_data)->i_private_data;
+	resv_map = HUGETLBFS_I(inode)->resv_map;
 	/* Only regular and link inodes have associated reserve maps */
 	if (resv_map)
 		resv_map_release(&resv_map->refs);
@@ -907,6 +901,7 @@ static struct inode *hugetlbfs_get_root(struct super_block *sb,
 		simple_inode_init_ts(inode);
 		inode->i_op = &hugetlbfs_dir_inode_operations;
 		inode->i_fop = &simple_dir_operations;
+		HUGETLBFS_I(inode)->resv_map = NULL;
 		/* directory inodes start off with i_nlink == 2 (for "." entry) */
 		inc_nlink(inode);
 		lockdep_annotate_inode_mutex_key(inode);
@@ -950,7 +945,7 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 				&hugetlbfs_i_mmap_rwsem_key);
 		inode->i_mapping->a_ops = &hugetlbfs_aops;
 		simple_inode_init_ts(inode);
-		inode->i_mapping->i_private_data = resv_map;
+		info->resv_map = resv_map;
 		info->seals = F_SEAL_SEAL;
 		switch (mode & S_IFMT) {
 		default:
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 65910437be1c..fc5462fe943f 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -518,6 +518,7 @@ static inline struct hugetlbfs_sb_info *HUGETLBFS_SB(struct super_block *sb)
 
 struct hugetlbfs_inode_info {
 	struct inode vfs_inode;
+	struct resv_map *resv_map;
 	unsigned int seals;
 };
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 327eaa4074d3..2ced2c8633d8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1157,15 +1157,7 @@ void resv_map_release(struct kref *ref)
 
 static inline struct resv_map *inode_resv_map(struct inode *inode)
 {
-	/*
-	 * At inode evict time, i_mapping may not point to the original
-	 * address space within the inode.  This original address space
-	 * contains the pointer to the resv_map.  So, always use the
-	 * address space embedded within the inode.
-	 * The VERY common case is inode->mapping == &inode->i_data but,
-	 * this may not be true for device special inodes.
-	 */
-	return (struct resv_map *)(&inode->i_data)->i_private_data;
+	return HUGETLBFS_I(inode)->resv_map;
 }
 
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma)
-- 
2.51.0


