Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6301EC1426
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59FA16B0105; Tue,  3 Mar 2026 05:35:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 522FE6B0100; Tue,  3 Mar 2026 05:35:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B0DC6B0106; Tue,  3 Mar 2026 05:35:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFAC66B0100
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:35:14 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B267613AB3A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:14 +0000 (UTC)
X-FDA: 84504394548.22.C0972C7
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6963640012
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ByH8CAwW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZmbLSVir;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ByH8CAwW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZmbLSVir;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hJ7zC/j7R3U6pbGqWS6D4Xl469nqbcAlVJWcqDjGzgM=;
	b=oJwWIGyXntDwHnlGSseJ2ZdlnfJzw7Ec+z5kGQ/aI8zUNN0ADCL/jIsCrEajH+uOYBV1Qw
	W+ebeC77pVirQrkgRwmUnXd8t5UoGD82sl3Vjqfvn2Kiyp5kJxtlTPP5rgrOL+yBEsCJnV
	ALaWjJp8AaYRtCfR0CjwwIc9Cwd6W3I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534112; a=rsa-sha256;
	cv=none;
	b=aSBqUwd9Ctt8FJMZEJRJcCpFULmJtIjhbbTihqCpcQ4AZtNG2J6uvBPqFUvCeR+kuoqf99
	VOUG3pt76Eoh5dkoOxF4uiaMMMzyvM4ZiO6W5myTTyMN6QEStpjTyig4/tOS2DYzVDk3Ym
	f/EiVIxtDidbZ09zhCjhHnUUrmhOVPY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ByH8CAwW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZmbLSVir;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ByH8CAwW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZmbLSVir;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 07BC23F907;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hJ7zC/j7R3U6pbGqWS6D4Xl469nqbcAlVJWcqDjGzgM=;
	b=ByH8CAwWnnOP5zLPLhwBTrkHOVpGk1q3aRnxudTPADe8fEJM1IBAXgpCL/zZnMSm9CXKwG
	bTE9sPoNz/VGT76l3Z6cJm5GKtKEPmm64utTGn6Y3r0RAa076XHbCQsflSGUUbCM4ItQMQ
	vn3A/p2JfZQYrzt5i5RcPl3EO5U+zRI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hJ7zC/j7R3U6pbGqWS6D4Xl469nqbcAlVJWcqDjGzgM=;
	b=ZmbLSVirQ59fjY/aQtX22KUaNpFPbChL91REC0+yBo42mUWKUSYXio9VesEbDKkPt7T+Zt
	6/LCQ3WWnUzVL+BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hJ7zC/j7R3U6pbGqWS6D4Xl469nqbcAlVJWcqDjGzgM=;
	b=ByH8CAwWnnOP5zLPLhwBTrkHOVpGk1q3aRnxudTPADe8fEJM1IBAXgpCL/zZnMSm9CXKwG
	bTE9sPoNz/VGT76l3Z6cJm5GKtKEPmm64utTGn6Y3r0RAa076XHbCQsflSGUUbCM4ItQMQ
	vn3A/p2JfZQYrzt5i5RcPl3EO5U+zRI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hJ7zC/j7R3U6pbGqWS6D4Xl469nqbcAlVJWcqDjGzgM=;
	b=ZmbLSVirQ59fjY/aQtX22KUaNpFPbChL91REC0+yBo42mUWKUSYXio9VesEbDKkPt7T+Zt
	6/LCQ3WWnUzVL+BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F0BEA3EA70;
	Tue,  3 Mar 2026 10:34:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /H3POkS5pmlwFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A999EA0A79; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
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
Subject: [PATCH 12/32] hugetlbfs: Stop using i_private_data
Date: Tue,  3 Mar 2026 11:34:01 +0100
Message-ID: <20260303103406.4355-44-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2743; i=jack@suse.cz; h=from:subject; bh=0Tf41qNynOHKl++Dc8Ys4dS/6PbXDeCtzOfQHkFchp0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkocjhNcBjeQBoJK+/oG+RPKznFY3ANKEkrw 7JMLSo6lVSJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5KAAKCRCcnaoHP2RA 2RCeCADYnSWtfW84q5MK+DZ8tuZd1qK7zQCmmcgw+76u2f6KbmpC8RIoN4Tf/73mWwsDv6YPgmj zunEJYotmXAvAM2GI2VT5lUeDw3zAJDpHK/c08lGvzVmRvy0HL1+6CNSaBeM+HK4jD6iU6YCC7e 5rTcKhAMZzQ/pbn83ZE6p7W/oQbVEcd6d6DJJ3ezAut0+leirtnXqge0Clxj16glU9y/GTYuoh1 tTnhflaPAT4LbCWBPrnEi8jQi0TSNfAIxMeadmriYqBRZ0kFHbdSFSVUbFqIHJT2tKloc244C5e 4PolSoFOr/1rNc3+T2Z1Kl+4Gq8Vu3X2z+kRI0fc/aXysucO
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4h98ts4r4o5w4ype9ndxpd6z5hre86cm
X-Rspamd-Queue-Id: 6963640012
X-Rspamd-Server: rspam03
X-HE-Tag: 1772534112-794522
X-HE-Meta: U2FsdGVkX1+N7VfeTd10wUMNsu7mfe3nctZCyn/qM5ipA6wuVGW307Yo7vUoHf5QUp/b3nRuEVMAJa7em83CpNT2dt3FxARygkGBVPYiSVgoM2itSjj0esJo4h6crG7VsR4WJJMFK+5Aq8HFg2rVaVSLvlPvgVsW92G3phS3D3pnpuTEioT6oZeysa/6diaMB7Om5Q8M8kS/pcFr+VcNFNOOXhZdHac3HgMoQUPj+JvLVNxglppAVgSbiGD0UBDOUZbCuir+UKcRWzHVbgwvnYKH2Mq1PjQYW3vgOMUEEqq88ZkCxEmRPvWvr3j+Zk2sZ7/F0CzOWOxOIERl6CwGPps8iwMU/nn3JqDtws6IT0u+UeoEY0NDRj3JiUEX/g1d34ZXo47YTJZnNt4jbKLzeRUVZAaeSBGD907Eixt1WNTZPAqQ6CwOFh/K2hh/BS8ZVHmY1piz2+j3B8XwVLdudpuS/EXdjp7oCazH3jdiwxE8ePtD/4lANEgCBqNhNvJurwCvrgQSJj4H1ymr22lfvfhTL2IYm4N1UDVlfmGToRiLAm7SHcHJDoV05Tak1piJlsPcPLMAVMJjxEOZp/rHhKXPELlexB0b7hbyfKsI6lHC9UpDF8z7et/oNC4aIDcEM+QUrLj6mKdzniM17uiDptDNC/P+t8JjbJJ7/3GoHOcO5GzrkTUvz4icMfQLvDcki1qwqnXyy5A3OQG/8FRxdx0ova7MlKMXS2ky2BEUnMT1wD1JHCbYkiuw0ci0TH1R33fqvWiDsWQyD6EBWP3/BylrK6kshCmNbjIyc77HD9Lnv0vbJXkWToT/cxkOOKC8rk8Vi7eB+XQB97WWlQVPvtq+1SHKR9muvhxbsItRExlwgCzelyE8PaKkeegme5uX+brTarl+rcjm+92k4nfmfzbv0YfVDZdvYNRBLtnSphCfiwav8Sb8IWbmZtRCBeq5uOR78Jpd83VyxFDWwal
 3acqtIJd
 zj+8V2UKHFN3o2DrICCV08Va4lMgTu73mspBZ6d/n7gHj2TjluoYaxIJmoSOSgrEMsd5PwC9Mxeq5zs5QYHRJoucIoPC+EZKNvoDBSpVKLlGEs2Wt2tfVvNgQm1zK6ztdu6Zr3ZUcaszkqIRkZHt0ZnrELNTI5iukk8Tsu3jLLlOi8esEKgTqluuWMIEqE9Lc54uQjMs18vNjp/Pmf71mTV0JHo61H38AfS/xxBypChs3BAtbw1vUDeitVA+2dBOsMwtT0sgv72UKx9JYla2TnfzACtvrtjmXmNrUU70/MW2mqYFh9msTpaBvQm+Mrk367rbQ
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
 fs/hugetlbfs/inode.c    | 10 ++--------
 include/linux/hugetlb.h |  1 +
 mm/hugetlb.c            | 10 +---------
 3 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3f70c47981de..0496f2e6d177 100644
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
@@ -950,7 +944,7 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
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
index 0beb6e22bc26..7ab5c724a711 100644
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


