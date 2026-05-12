Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E104CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 05:36:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5BC86B008A; Tue, 12 May 2026 01:36:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABF426B008C; Tue, 12 May 2026 01:36:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D4A66B0092; Tue, 12 May 2026 01:36:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8277B6B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:36:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 565EA1C0283
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:36:51 +0000 (UTC)
X-FDA: 84757658622.22.D2FB0C9
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id B9DC440005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:36:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=WpIBIsdB;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf07.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778564209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n899WPhwIZ+KymzRJYJT56SoCbIK1OLetz93e2eg8Xs=;
	b=thpCBmKQ0t/94QpW0qq7xUFXFWaAXEw9CK7DBEtDtzz2gg9ibkWeAXDp6XAiEjgGMp8FgX
	HeOIe2imRnDvRM9+vozRFmcvNX0CKaVZAqkZy4WEeqcPcZa/1AtN9XFyDusMUAsd6zd5kY
	j9e4Bovx2C7ZQN9dNSg5WW5J1667Yqg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778564209; a=rsa-sha256;
	cv=none;
	b=UUUvk9xf7BBPQBflF9zctOw7eScjNmhNfm3mvqDWx+UKQChOZboneroOqLP2O/a7w11ss8
	yVpGWRsuPb38GIqLaYPgvYGFV8Yd2DUEUfqUkBLzXQyxaJIGuedsp/uykfSyUDb9+TEJyk
	Tb+o0SdrJ9ldF6EEGok69/MtfJSRtRU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=WpIBIsdB;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf07.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=n899WPhwIZ+KymzRJYJT56SoCbIK1OLetz93e2eg8Xs=; b=WpIBIsdBq0sBt+PNrgh3yLlis7
	6qDcTGTooMfAWemyiheQrD2xqLTMjj9shCEExwkg8sQgrypWxqhtXB8NtwvKzCDQGLh7arQSgqpRS
	vp6OO9kpk5BFFrHwqKH1Aq14wFz9j/vt9QTrmrWM0n4dMrCEk29dM2vGLGoosLHWnkBGEe9RJodgS
	L0ZAgsUHOLJSoH4Ls+ioKqJlrBZzoHbAPhWU8PgVPfiV57u10K8gCsAriG2aj5XIquIS/COy+I0+w
	6sdAMS4yE6R/qIihIut2DLnwPcK/zKF4yCW9j30M1/q5xrO+zrpDcmTnG0PoO2MhHGS5rQ+OSAcBD
	i4G4GVUA==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfnN-0000000FfF1-0DCt;
	Tue, 12 May 2026 05:36:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong " <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH 01/12] swap: remove the maxpages variable in sys_swapon
Date: Tue, 12 May 2026 07:35:17 +0200
Message-ID: <20260512053625.2950900-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260512053625.2950900-1-hch@lst.de>
References: <20260512053625.2950900-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B9DC440005
X-Stat-Signature: 94ex4k7gofmxx7h9yszkifi3y96fq6bb
X-Rspam-User: 
X-HE-Tag: 1778564209-346790
X-HE-Meta: U2FsdGVkX1/MmNTgbrRNLHp1NenJKhTM8ACEkFcRrGG9WB6ediNAXsaxtpVj4iErwJWYy8jI/tF8PfMPf7HsstG5bLUKRB7SAUyuSmprGvPs9tqlnHm8wEjEIcazm/CnH0B5Opa6wFxKaGssHsggx67jTQU1LhIc+AWosKYN6S1U0lHbfawxwIv8xb8Mvp6WUSQOZysslNJCYHpQvFoxB6+vqI3/bXTvILwK0sOU94/deeIFkYeIZmj40c6lHu50ji4YTK1hT4rn0mMge3+jdXVHhfGax6NRGvBom4pbOalOBi+9Ggp/esZE5fW09I/uWj1dh8McXxI+5aboAQ7jRiDIRSBpH75qTx2+w3pLrV6YeQTwIRfrLTOSG0xHnyYthvrdYn01s6gh0IUoDoTjccgSi5Wha2wBn2Mg8uG676Rk2vtN0tPd78f5gbNKYt1MqKhcSWCB+y0iaEjd9dBG7gRXoIrC+gZGHX4tN3MRNTCHoJYP2fiHDz+9kF3XxQlZ4wPeJMQ2f41uAj/1MawbCeUjcj/ktHe14tbWAxF0OJ/jZ3liC7vuKW0SsNIYh6zyTEC1gqr5ocnKV0PEtqn3Lj2q+EWiEFaKTxd9bbXeFfFTZh/IvNP+vXRl984Ggg29FBJb1PkbJOOj7ZX//lf/xUkh5GGDFHTwfUAAsfx2sklFMg5zExbsf9ijxnEHC/vGD6P+GsDlyRmUJdfHBM5U6YFLsjUBdfaAmbsR73G0NUMtnU3JbjYasf9woXT2T/9k6A95MQoggVWZJVwq2NczpGs/O8HPbCywEASIyznZKdJDNbob8nJvm6WM03jy4MbvaWCbzAt280SKEtcmRBNRRQScGro2VOiPmfDgsP7WvVL+YVoCJGeBYDl0f4OvsEzFlFc9Tt6h+yqUOGKH16hVfBY+Tcvv7mLVeBLJYUBr/EcpeAVvNSo17FUgCxd0JhMO9tSeaACmyEt3K4wHQR+
 tImWfhgS
 AolYY7z65bWN43qbPS7EG8eEwIsr02vmmrBTgYkQiIgDzMSzuu/osTJvK5/AkvHYA90iklPhgRFMsolOck9GPinjaslSgqyvticdnfTZvQHqjVUKKPah0s2pmxHsrn74KAD4dSNtvxlpfgOTXLhKtDL16UVauTmMxmb1P5kBdIhEqhST6F5auTesqquZXJgzvHzkWG+890UDOFmBm8qZETKMI2tcVYCIYxI5mj3dFHP8BUuJ+JCBgYaiTa1sRXWSyOIHOQlWGW/7VLSDzSKW+Y8/O3Nfz1Dc9wZr0W8RyA4i/xmQFR01IuONPhgrm/zNPl23NdwgNCfc+AzTmbLfND+G1zhw/Ldw535dduAq+6v2ND2yaSyXZKuEXxYSuxuEowDoc1QOOzSW68I0oYQZyBjU8QXvfQNGwfXW62YIb13Ck9xuRWfTJRxGAhQrpcPIFLnupHjLwRrTNn5GJJHIvHGGWvm3AHQLR1zmyf9se9TfVISWn4eDMvdxKiXkd2TKNiaz3JBy7adDHQ5fxVcg7nCr8HSmb/5cJGyi2XYp2wofyfBBiCo5A1x3aqacVTPXH7QydPd7YvlUqOzj66mYKhUG2dqn+bOpy3SQPkPW0st9mxeICCxSPYexiH4QvldX3/DPU0sFU2gHDyGevcOIZcKq7Ihw2pRI0JyDNmEAaxVUJZ3Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Always use si->max which is updated setup_swap_extents instead of copying
into and out of maxpages.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/swapfile.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9174f1eeffb0..f7ebd97e28a3 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3350,10 +3350,9 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
 }
 
 static int setup_swap_clusters_info(struct swap_info_struct *si,
-				    union swap_header *swap_header,
-				    unsigned long maxpages)
+				    union swap_header *swap_header)
 {
-	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
+	unsigned long nr_clusters = DIV_ROUND_UP(si->max, SWAPFILE_CLUSTER);
 	struct swap_cluster_info *cluster_info;
 	int err = -ENOMEM;
 	unsigned long i;
@@ -3395,7 +3394,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 		if (err)
 			goto err;
 	}
-	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++) {
+	for (i = si->max; i < round_up(si->max, SWAPFILE_CLUSTER); i++) {
 		err = swap_cluster_setup_bad_slot(si, cluster_info, i, true);
 		if (err)
 			goto err;
@@ -3425,7 +3424,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	si->cluster_info = cluster_info;
 	return 0;
 err:
-	free_swap_cluster_info(cluster_info, maxpages);
+	free_swap_cluster_info(cluster_info, si->max);
 	return err;
 }
 
@@ -3440,7 +3439,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	union swap_header *swap_header;
 	int nr_extents;
 	sector_t span;
-	unsigned long maxpages;
 	struct folio *folio = NULL;
 	struct inode *inode = NULL;
 	bool inced_nr_rotate_swap = false;
@@ -3512,14 +3510,13 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	}
 	swap_header = kmap_local_folio(folio, 0);
 
-	maxpages = read_swap_header(si, swap_header, inode);
-	if (unlikely(!maxpages)) {
+	si->max = read_swap_header(si, swap_header, inode);
+	if (unlikely(!si->max)) {
 		error = -EINVAL;
 		goto bad_swap_unlock_inode;
 	}
 
-	si->max = maxpages;
-	si->pages = maxpages - 1;
+	si->pages = si->max - 1;
 	nr_extents = setup_swap_extents(si, swap_file, &span);
 	if (nr_extents < 0) {
 		error = nr_extents;
@@ -3531,14 +3528,12 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 
-	maxpages = si->max;
-
 	/* Set up the swap cluster info */
-	error = setup_swap_clusters_info(si, swap_header, maxpages);
+	error = setup_swap_clusters_info(si, swap_header);
 	if (error)
 		goto bad_swap_unlock_inode;
 
-	error = swap_cgroup_swapon(si->type, maxpages);
+	error = swap_cgroup_swapon(si->type, si->max);
 	if (error)
 		goto bad_swap_unlock_inode;
 
@@ -3546,7 +3541,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order might
 	 * be above MAX_PAGE_ORDER incase of a large swap file.
 	 */
-	si->zeromap = kvmalloc_array(BITS_TO_LONGS(maxpages), sizeof(long),
+	si->zeromap = kvmalloc_array(BITS_TO_LONGS(si->max), sizeof(long),
 				     GFP_KERNEL | __GFP_ZERO);
 	if (!si->zeromap) {
 		error = -ENOMEM;
@@ -3597,7 +3592,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		}
 	}
 
-	error = zswap_swapon(si->type, maxpages);
+	error = zswap_swapon(si->type, si->max);
 	if (error)
 		goto bad_swap_unlock_inode;
 
-- 
2.53.0


