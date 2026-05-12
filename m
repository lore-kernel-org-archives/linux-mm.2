Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A281CD484E
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 05:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 012916B0096; Tue, 12 May 2026 01:37:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2BB16B0098; Tue, 12 May 2026 01:37:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E692A6B0099; Tue, 12 May 2026 01:37:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D78666B0096
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:37:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA6688AF66
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:37:21 +0000 (UTC)
X-FDA: 84757659882.07.DACDD76
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 29DD140005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:37:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=fBrYSimV;
	spf=none (imf27.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778564240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SFnfiE6eXJFzgFJiNYniWIOwAjN0Z4qYfw3E7XgNBJs=;
	b=Q/2sodAYv6dvUtFWoFc6QE8lLjyAOieCPzh8wpR+dwFdtNu14KfagwAkfeJF3CpJ9n9z+9
	UegVeXYaLr2pijRRbh1MaagV/joCV7hU4DUp4Jn8W4I1QkRHAq8qYhgeVtHmykLT3ANsWM
	ArJ+wFdibZpnQozskBq9inUN34vszDQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=fBrYSimV;
	spf=none (imf27.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778564240; a=rsa-sha256;
	cv=none;
	b=IOMFNtHcznbuW1oOjy9h9+U6OTabfiHX6/TTuMz4R59Uq5SZbPTFzlofNO2bbYBVKMOqmN
	uQWztQqEROpSZeCEE5Q09GqRk1YRIAeOLbdVQpIX/KSw5GhPpZrlrMegduUiExDq3Bh2+H
	OLjOrBRC3+3UyuMURxS61uxbFW3Xk08=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SFnfiE6eXJFzgFJiNYniWIOwAjN0Z4qYfw3E7XgNBJs=; b=fBrYSimVUdqrWfQJb5ZGKTYrxO
	a4Q2JOWiqE1CrUKooGJ+LnGljcIS8i0i67sgotq7jYGDfkK4CReONqXDgpdqL0znEO5HEjqAeTVi8
	xILDvqBWxJWjF/OI/KDh56u7zEK8MasUS6riWjIJ6RJO/PBZmt7PIHIwBbtxNNUzWvywTl8FBUngp
	ttTGV9wVPAzvKL/ydNorpVDlfSZXsRT+mFxIzvvFpNdabt4qSFEM+hU4NtmDYDGVH/LhwHQYIXmNg
	+785VZ7NDn66h/wVUqsB1lC5B/w0u/0Zv8F7lWQfn8l8nnNUP7CB+0nr3BgxUAS9rRdxQv0hrzSEf
	sYvsiBQw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfns-0000000FfM7-0BDl;
	Tue, 12 May 2026 05:37:12 +0000
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
Subject: [PATCH 05/12] swap: cleanup setup_swap_extents
Date: Tue, 12 May 2026 07:35:21 +0200
Message-ID: <20260512053625.2950900-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260512053625.2950900-1-hch@lst.de>
References: <20260512053625.2950900-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: unpggoxpmwkx7tiujaon3wj5pdsc37i7
X-Rspamd-Queue-Id: 29DD140005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778564240-193966
X-HE-Meta: U2FsdGVkX1/vw3RUlTeoNyA+18g9mZjqpLVZns4R+B8A7uTvm7szt1RGWHVplxj9QDTKoM2dSUI69J+n6lQF9FZWf/sVw4hD40us0ogmue9siQZnXXXUhZMm9mz3igTa+CfwSit100Tc+Dp+iN56c4108n9SWqroq+ij5DyFbRo/6egJeu5tWJomKS5Gt61qBYPKIeUaAhZwJ6Ta2aGFyKXrzqiuLcPaaEEXuDdCMN4ywRTagnB0BnEYp/AWmtivKil/ILRKHs5xyM74GVYQsilko7CL+D1Xsgd18Ha9vJv3RWWOzvrbZ6yTofn5QV7ngk9Mst9+z6j5BcQSWMAf729Xmoss/v6g36VzsXA+SBAj4L7P1GPDuv7PSp72QrEB9NYlgXdpXsrzw4rOZQt4zuijRmUAOhpETqNPsEd950PkvQS1Ly3rBQLHNwLyn7sYi0orBMvLl5cBjFE40WBHbLEhNDm1KIQzYzuIOUh7YvWmAroVx71VfDITgKQZsTqAsN5jJm9xe8Gdo0kCIonaYxXmi5LZhpJV/9eThI5o0x1hhHlRfkZU1pbPG1v6qW2c59FbXqKIv2uu4g3vhR1IwoY0ynGiEHDKbOb6uANlMnuzqJ41Wo6iKauOM8vLC8tJeNmWvS7GeBuFbsruqb2/u/0KvSIwMwwmDUnU8TMFd2wSvXIfY5Vgf8rROmbg+iY1V+ycm5sqZIIWfb+MYAgGVrpHqaEJK5WdxjeSq9tcVIXuzuSRNqM3PhxNnm4/K+itfoiUH+rnPxBbIWIUn+lNAEoKmWrTCeFZ+500l/bYkRyRFosb7kSnnpdXAg8HkGRdTEyeFDdHMXIgHZNfTNSDF8uBl1jBRoNWW5STN6gx/zEQmBog6C3NbcEGCnQgYndK3Dwzie0EEyo26671BQp10G1YhWbLhK+NduPx2DOkVdetswFrYFdS2AdfJV3yiMlUvBWh2NVsznJ4nwWOtTf
 NN1GKBm1
 wWnu4ztkizIMae1f9MsVsqJXkmiB26/loFFrNO2ZKRsGLIlJ0D+yiqvIVnwgRV+eG4yScs3cbldMlm6Ha4D06GLXv9eVDWMXOjxM9WyHJTH0yS5tDbgp9eMP0urXZOT7GhmxBViHGEiicYKyyYZeIM7iuj6eYj1zbuGm6c/YvYk+M8R0uFYhQYwqQ3l3rgXHZkCENqFEvDZd5Xy8bqinCO+x3m5hPYqSbPHwTWSjUz6aHhwWH159eMvmHNFeW7llsyOYJrO9OeyoCP6ny/goUDRcuNNGylQYzI2M+JPwEizSdStsnIVzXJGSNwZlSE2ESWTtM0+aXYYuxhzkxmPuy21U8J9HS8boe/Aw/7XS+T8aLNum1ctAGiOsu/ZN5KtxS3ElCrsCQdpjKGlk9ykrRJfJp9FuHN4pISKhzKj3WP1BwcB+A2R4xva/bxo8Y1eAc1sHPS3Srpkz7KStCBBxIjObaznPAcvDpETePMrTvf1rdHkmBYqraIuZscoRSewIV196RU+zjRTfUMm4YH5yqXvnFW6oa56ywRou+AHEUYt5Wkg2ks6cqosgEcFyzVWS/HpEps0K3ehvHmdYWaCWT1bd7NO/BXJSHyehZ0LzLawdXTQGnULSD2pDEsH/d0IKj6JeBBKC4IcisoDi51KyMznEGgI0GCGL/6bjCe0XxCnHud00=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reflow setup_swap_extents so that the flag checking is not conditional on
a swap_activate method.  This is currently a no-op because the swapoff
code still checks the presence of a swap_deactivate method, but it
simplifies adding a new check, and also makes the SWP_ACTIVATED flag
more consistent.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/swapfile.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 651c1b59ff9f..1b7fc03612f4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2783,25 +2783,24 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 {
 	struct address_space *mapping = swap_file->f_mapping;
 	struct inode *inode = mapping->host;
-	int ret;
+	int ret, error = 0;
 
 	if (S_ISBLK(inode->i_mode))
 		return add_swap_extent(sis, sis->max, 0);
 
-	if (swap_file->f_op->swap_activate) {
+	if (swap_file->f_op->swap_activate)
 		ret = swap_file->f_op->swap_activate(swap_file, sis);
-		if (ret < 0)
-			return ret;
-		sis->flags |= SWP_ACTIVATED;
-		if ((sis->flags & SWP_FS_OPS) &&
-		    sio_pool_init() != 0) {
-			destroy_swap_extents(sis, swap_file);
-			return -ENOMEM;
-		}
+	else
+		ret = generic_swap_activate(swap_file, sis);
+	if (ret < 0)
 		return ret;
-	}
 
-	return generic_swap_activate(swap_file, sis);
+	sis->flags |= SWP_ACTIVATED;
+	if (sis->flags & SWP_FS_OPS)
+		error = sio_pool_init();
+	if (error)
+		destroy_swap_extents(sis, swap_file);
+	return error;
 }
 
 static void _enable_swap_info(struct swap_info_struct *si)
-- 
2.53.0


