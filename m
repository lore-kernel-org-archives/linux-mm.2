Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A34BCD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 05:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 802436B00A7; Tue, 12 May 2026 01:37:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B2E56B00A8; Tue, 12 May 2026 01:37:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0626B00A9; Tue, 12 May 2026 01:37:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 604D26B00A7
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:37:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20FA6C196F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:37:58 +0000 (UTC)
X-FDA: 84757661436.13.9D41E26
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7F6A9180004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:37:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Ge+4D1DW;
	spf=none (imf24.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778564276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M9+U2qOebilkGiCBYkyQkIQiqg6xsbq5mzyvOEMl2d0=;
	b=8M0hgMERXY6vTVExVAYaYiBU/JIGrlKlRqvsKf13balsOsdHa+lZqsYwzRZHpJNEYnDt+s
	+lbCgHyja25pQgBwvXVnCPLLgUfbXbwl6R0tf8VXW1a49JjVg/sW8Sf8j86c5IZwmPcRgB
	1RADRx0HJ1pMcHYbHgV50z4KXyIrGaU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Ge+4D1DW;
	spf=none (imf24.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778564276; a=rsa-sha256;
	cv=none;
	b=OZdVXZdv5QyAAxQH1D139sF/bR+ybx5j+Er8/ImE36GcdCXvIXkAvke5gTA+2AMMAhHoM6
	PafcBo9q0ZDmSc1tu0W/iRhGC2Gp7xAx2NXRIh36KCw9Qvpo9XLn4hAimgWGSDM0bUlbif
	nsUMzqoJhFUBRS4dSAhzxDgfZApDFPs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=M9+U2qOebilkGiCBYkyQkIQiqg6xsbq5mzyvOEMl2d0=; b=Ge+4D1DW2pmkX62K/Bv0iADaDG
	D9R7VZelwjKVRFhBQMh+fdN1xy3bTuTe0Q/vildGqQgQLb2afEaPyK1v8EjHjl8TnlRLR/yk3EOY3
	CpVRLT1IjABfASeE4xKUXId4njNbkiTLXbvLgvpTV9DskB9fVGLdpCqTkGu0rwCamvFqNjPrjYQlk
	YbHGYfjRwa7iH7D+9ACskU7jjidW0jq5xkwsjL3UJn+LvYQDv+evewZXQlDFu8MBYFt9cGvlHes4X
	x8utjRA/kzC2L5QS64m/B+xrrdAcsM9s1jEftrIQO9KN4bMqlXv1c7GOwxY0yHbsBHC6xopqolwXm
	jLuSKVEw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfoT-0000000FfTW-0JM3;
	Tue, 12 May 2026 05:37:49 +0000
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
Subject: [PATCH 10/12] swap: add a swap_activate_fs_ops helper
Date: Tue, 12 May 2026 07:35:26 +0200
Message-ID: <20260512053625.2950900-11-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260512053625.2950900-1-hch@lst.de>
References: <20260512053625.2950900-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7F6A9180004
X-Stat-Signature: f9zgbmenbw6fhaujy8sxguesrsasm875
X-HE-Tag: 1778564276-738205
X-HE-Meta: U2FsdGVkX191bqUiQRIFWzll07BLcV2tWmm1jyNIv/o8jY9WcZXk1nuJNFZogCPx4mMgAn5aDTRs0QP+alIzXENKRR7JQmyXo0CzngK04aqbJhnGqnoroh45zgO7aO+q1oJ0kl4g08balzDMEKwmwRiYSa5u4E9N1NdunHj63jr1XyVv2Sf7aban57r/1+EqFpYSVu9sxqThJP1bNOsdfcG1CGM8W0U9mj5PHiSlDQL0rOYsIqsYBWQM9z1ttSQB5RbX1J1FV6cqfXFiTKVlob7hsAmK1DaBTew3pFb6pXOzbhqEGENjGf0hEwv0C9IM+ergfkTDiUkgeKMZTJQqDuZltkA3mBBCPFiC9i34M6en8mX7QvTAt0zehp4uP3mQTd5iuqRR0xEBifUFK1ynC4LS/RSfZCYU9+05X7YsXODJgI3mkUFWJ8LXHyj2Bn0WHgmVqzK1M+9EaTAL59lY21jq/FIs5u5aIIKcm/kfcO69RdlQpREtY1pq6yWHW5k88EUqit96WUOV86XG8b/FFUXCBUgGqDrj0ISGb766rq3FQ8EUQEOV1ZXBqaKp3GJT6I3f36qBu2L8kwNes3xzlNs056aRhYLYCend/97oAnq4wxup1JoOH0pILT1ZonVRr0xa2hUsMlxTCj7CI1GYa69sP85m5mWvR2aL77Gk/GTdmF2AvdeE5Ynium4wE1nQ22VGJCkx376TFLEukxMqJ/Ayutl7ujE4OerfaWsADBWS5EQ8/47Mbk5UlHRsoHRMpkOlsuSu+O8pU8JqkMbNQZM2217EdOMDxcsrSbmFNKZibXzxrM9i7Br/hRCHrxhLxbALJai8I5B5DqWfYjkpBgblFD9VJpPuOf7y6KMUcWBDR12fxs3h4osd0dimqa51L8tO7foWAR4BqbMXtsg2vwzvypWD8ab0xy7L1fixlrKi7Nuna8aU8PSK6ffGkK0RZBrtfSurXYffGk4NbIp
 LpZHdE9a
 yOiblnMUVVcCsWj0fcQOFM6eG5kO7O57N69KpyrYCf84C1H1sO3QDt52d/jq/4+csX7Wwes8l2MVEsdyrBcmkHaYtoLHn1bYSU4/OyLrHjuRKUXkjWNi0JXmgFAKMezn4/Shor8QMYcysw+ia+Fn4lKDe3QyaUdeaLcrVcVAKBfv4Zpx1od2Nw/OgM6nHkzu7YO4tYDNhkqywEs9qnPRW48deK4lXt6mkhygjx6JMpyoth7RH/rFRy6TYsqOM3YuiLrwmD+hLuG0W44dZOP+Ybv2rOA8w1KgVGMNY+mp/WHZlwtEP7zsyH9YTPffjyErExRUdROR48MAjIl1DeoSievxA6m1o8aqKDpDp2ivEG9AZluKODXw/+0Chn1fYUbY1TPJN55Z3S659GPD+t4daAjHrHl0N+WF2v1pq33AjzXZhk7i0epoAfXMSW6H29inkkcKL+UrCERu+NY97OigY2emChTaHUJo67TZ72hkF2uGDrxOOme4i8oz9VfLfkNa40/bYtEqGaodYuBqUVYTePJ+jcCWIXm3HzuD8JOKcGEZY93GZH4UqdiAVgKE5qkArxIkhP4dwyQM98nDZEI0dTuQQC5eSrhp5Kg4n799GEGCXQUnzM1gMfVTUQgWYlV4VzX058BL58FsQV5QK5NLAcRjX/fkhZKLQKWOm5TnPw0CCjK8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a helper abstracting away the low-level details of enabling
fs_ops-based swapping.  This prepares for taking swap_info_struct
private.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/nfs/file.c        | 4 +---
 fs/smb/client/file.c | 3 +--
 include/linux/swap.h | 5 +++++
 mm/swapfile.c        | 7 +++++++
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 10ab2a923835..ce4d860c4e7a 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -588,7 +588,7 @@ int nfs_swap_activate(struct file *file, struct swap_info_struct *sis)
 	ret = rpc_clnt_swap_activate(clnt);
 	if (ret)
 		return ret;
-	ret = add_swap_extent(sis, sis->max, NULL, 0);
+	ret = swap_activate_fs_ops(sis);
 	if (ret < 0) {
 		rpc_clnt_swap_deactivate(clnt);
 		return ret;
@@ -596,8 +596,6 @@ int nfs_swap_activate(struct file *file, struct swap_info_struct *sis)
 
 	if (cl->rpc_ops->enable_swap)
 		cl->rpc_ops->enable_swap(inode);
-
-	sis->flags |= SWP_FS_OPS;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nfs_swap_activate);
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index e1bbc65ce7f3..e11065be1e64 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3326,8 +3326,7 @@ int cifs_swap_activate(struct file *swap_file, struct swap_info_struct *sis)
 	 * from reading or writing the file
 	 */
 
-	sis->flags |= SWP_FS_OPS;
-	return add_swap_extent(sis, sis->max, NULL, 0);
+	return swap_activate_fs_ops(sis);
 }
 
 void cifs_swap_deactivate(struct file *file)
diff --git a/include/linux/swap.h b/include/linux/swap.h
index b1cbb67ddd8e..916889738f08 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -406,6 +406,7 @@ extern void __meminit kswapd_stop(int nid);
 int add_swap_extent(struct swap_info_struct *sis, unsigned long nr_pages,
 		struct block_device *bdev, sector_t start_block);
 int generic_swap_activate(struct file *swap_file, struct swap_info_struct *sis);
+int swap_activate_fs_ops(struct swap_info_struct *sis);
 
 static inline unsigned long total_swapcache_pages(void)
 {
@@ -532,6 +533,10 @@ static inline int add_swap_extent(struct swap_info_struct *sis,
 {
 	return -EINVAL;
 }
+static inline int swap_activate_fs_ops(struct swap_info_struct *sis)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_SWAP */
 #ifdef CONFIG_MEMCG
 static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 2c9d2af736c4..26852c2ad36e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2757,6 +2757,13 @@ add_swap_extent(struct swap_info_struct *sis, unsigned long nr_pages,
 }
 EXPORT_SYMBOL_GPL(add_swap_extent);
 
+int swap_activate_fs_ops(struct swap_info_struct *sis)
+{
+	sis->flags |= SWP_FS_OPS;
+	return add_swap_extent(sis, sis->max, NULL, 0);
+}
+EXPORT_SYMBOL_GPL(swap_activate_fs_ops);
+
 /*
  * A `swap extent' is a simple thing which maps a contiguous range of pages
  * onto a contiguous range of disk blocks.  A rbtree of swap extents is
-- 
2.53.0


