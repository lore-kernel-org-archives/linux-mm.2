Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 057FDCD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 05:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C8DA6B0098; Tue, 12 May 2026 01:37:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67A026B00A2; Tue, 12 May 2026 01:37:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B75D6B00A4; Tue, 12 May 2026 01:37:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CAC06B0098
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:37:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A33E8C974
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:37:43 +0000 (UTC)
X-FDA: 84757660806.01.DFF209E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id DC12D180002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:37:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=zOhBM88a;
	spf=none (imf16.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778564261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ev7MltnomSEjjmIrAClD1smxf1HDQkp+MmOA2POEN6A=;
	b=l7bAHrm4ecTu4xJcJAL6mIEsoaVIIwe/AsUuoGFiOWxfvcfdcpJSR+gLayPVpYqtszb7QW
	YD7MDx1zil68sf08pd3IcF9xdnEo+C14mV/sp5Pr9SVMiardNYTdBGUYTtNhueoHA1Mmk3
	QgjYi/tfV5ewL7cWnNFhEU8LrkISrmE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=zOhBM88a;
	spf=none (imf16.hostedemail.com: domain of BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f3c1ea353498f61ccd0+8297+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778564261; a=rsa-sha256;
	cv=none;
	b=wyIXIQYEZIGyUtTNIw17X0Wg+ytoQWCc0qTsffGimfudHpWCwqiPXvP6y79KShUZykoIaY
	wY4FGNCnHsWRyGwB43IPCpjhdbLlI4b+icQvTbujd7M0AaOIitDEtwwK1GjPDbBz9KaJfI
	q+gVxi+/VfnWQlkWRlzd8Hh6LgZroMo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Ev7MltnomSEjjmIrAClD1smxf1HDQkp+MmOA2POEN6A=; b=zOhBM88aoj3+RmnJTzDvDvX5oq
	9MzT6jc6jjaEccKxyQYyttFDbnopfvJYVRTvD8rnrI3Ljs3ORV4RDMFYqZF0hzK1GyoLlju8YU49c
	dnoc07+jiOkMGYudxEb756NG3xXZ2I4+ryFlzH/OCqMIE6PWkPy8ypBzQ2eo/PcP0REfgJB0rK+Ht
	Q1mnJjTvGTg1lgE6PiC2A4TxfqdYU4PRtOUemJ2/oREQHvCceIpP6h2RCBmZUElPNeD0lluN0F4ym
	3kmCUQ2sDP38uOsiipbmNekSLq9daxjQS9H420VZrcOfYp1xO+fG6rF3yDlpNsMTGI63uZXnHkWuD
	7UfSxpEg==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMfoE-0000000FfQG-1Tlu;
	Tue, 12 May 2026 05:37:34 +0000
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
Subject: [PATCH 08/12] swap,iomap: simplify iomap_swapfile_iter
Date: Tue, 12 May 2026 07:35:24 +0200
Message-ID: <20260512053625.2950900-9-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260512053625.2950900-1-hch@lst.de>
References: <20260512053625.2950900-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DC12D180002
X-Stat-Signature: fbxdkcrqn1kynwuexq5pobng5fpfi55q
X-HE-Tag: 1778564261-569787
X-HE-Meta: U2FsdGVkX19VobuywxwcrwSlgVqqCFEP4LFmrxrc8WFEudiXJMU0GqpnCewL7ZVZnHVqm86pe+yYdVTQyEc0Lmng/yhvqAtC/uLj+v/BB5lm3fOS0z3XjrGolegSPP0faocsdrFOx1Vh2QIpHKLRS0/XE4TUhl5zOVP+xixGnHLgtabmu6KqmGliESUUghqO8rCHLak9URRpWZ7CpITKddW0tJ+ondi2FOsLZVJMt90MZxyuhbZ0Zp7hCWTNwmxfFWOFBfLZzfLrqTwdeczF2YgPBIjOdqqhu9TQOqlPA/15v4U8rGZWhbx+MiZbpLc/4BTNxhuuOsqY7yoNpoKAn3IpNcK8lrRR9T2Gk8PydGob5buSIw8OcL2MSwya0g8SH/a8VDL2sHyHu8wLAemBaeGKvl8Jpqe4SI1N4vD44zov3UUWF0mFjfgU34rFUjoswX6SQVrLDjZtuaBMCjthB8XftDreRZqpwBniwgca+0WH4yoQx1MM2IuUB0ow450/4/iiHeyYx7MfgU/naxQGWz0wAeI9OJtK+y4w6CGv169KrBXrdl0GHL1U2qGGW8++Pn6p+kCQKUl+frpatbSfVEaSdaE2HsQZz3EIPoMGJlNdg4o2tyXXX51sJD3H7rLidaChQF9dOfKs1gltNLw++2J2Tzdok+kDZpFWm4uF3ezM0P0akLdYcj1Is5A+cpw5F1lPc4iWhQmpqSyNcd5paJ4WZr18rgZmcrHN2mQFE0HdnGx2EJVTAvBKcsabcEYdTA6GN0bOt69JlLfoU4zhVaDPc5R9oqWS55Rgi6XddjzBGsJhiThwVz+WL1SFVjLPBPCw5dW8chlK5nj3q+fzI+cJWmo4UgyThwym92E4K74hvo0EiwoI+F/Q6huwQRjPSkCYO/B9cmQ3H7vXayfenkybLNxtus1spixJf5p9XcmIg1u0yaCt8VrMTffVTuGWDmfeRAwgXo/zic1a2qS
 8dryAd32
 hwTwMwP3xz9jcR6HLMCr5/WYgXDnGj7Vwb3LPYUbZBih+bnMRdohS9R5iZZ3gdwoNRuxWlM+i7PA+t/3awPQ1x8w9x2agnG+zqAIY/EA7SKX69ALD6oWz5AaBLf3TjJQiiTS9W5kIiLRNuiAF4vXBv1Yv94Pz4qL7YMP8oSz4kWKDqVyuQ/6H+VNIn5bAz9Ah0ghCRMqzqqkElIGvFcw76sj9yHdrdtisaWH0Wv0EGfc7CO+BJh7GOlUmeaa3BeKci1RtwFisPIe4xcoJ+cX8yGHzcJWQDkkQPvGDDxj9vqgN2rRvm8YuMiK7cSyOg6EGKy2BZRQoj9pyr3NgGoLgX5kDtR2t38hYTKLRk93/BeqxT2JSkaLVx0H+/kqvLn7ZEGyge2xUEOJMH5X+KeanUjIGgoGQX2eeD/oFEkcguROT398hb0um5T11plwWLeAAfr/kb7p5444yPms/sMXRkniKYZ796TLnYIGcxSylsXrVkgfB7mdXn1hZLXMVZ8kdjCkkVdAtlMB66vHbMe6m94pi247b/6ssf4dHvgBoPyofgcT46ddd3N+IwgZXC1IH2RcvkLU+A5rY0FjPGfSg2ZjuIssSMYQj1MXPLXhNoTs98ueHN3Na51sUHdfPMbNGM6/KQJpi+TbhasZFnNK4QUWEZMH3eXLydXswH/nVxDpamXk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

add_swap_extent already coalesces multiple extents, no need to duplicate
that in the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/swapfile.c | 104 +++++++++++++-------------------------------
 1 file changed, 31 insertions(+), 73 deletions(-)

diff --git a/fs/iomap/swapfile.c b/fs/iomap/swapfile.c
index cf354fdfb7c3..a4e0ca462cc4 100644
--- a/fs/iomap/swapfile.c
+++ b/fs/iomap/swapfile.c
@@ -6,57 +6,32 @@
 #include <linux/iomap.h>
 #include <linux/swap.h>
 
-/* Swapfile activation */
-
-struct iomap_swapfile_info {
-	struct iomap iomap;		/* accumulated iomap */
-	struct swap_info_struct *sis;
-	unsigned long nr_pages;		/* number of pages collected */
-	struct file *file;
-};
-
-/*
- * Collect physical extents for this swap file.  Physical extents reported to
- * the swap code must be trimmed to align to a page boundary.  The logical
- * offset within the file is irrelevant since the swapfile code maps logical
- * page numbers of the swap device to the physical page-aligned extents.
- */
-static int iomap_swapfile_add_extent(struct iomap_swapfile_info *isi)
-{
-	struct iomap *iomap = &isi->iomap;
-	uint64_t first_ppage;
-	uint64_t next_ppage;
-
-	/*
-	 * Round the start up and the end down so that the physical
-	 * extent aligns to a page boundary.
-	 */
-	first_ppage = ALIGN(iomap->addr, PAGE_SIZE) >> PAGE_SHIFT;
-	next_ppage = ALIGN_DOWN(iomap->addr + iomap->length, PAGE_SIZE) >>
-			PAGE_SHIFT;
-	return add_swap_extent(isi->sis, next_ppage - first_ppage, first_ppage);
-}
-
-static int iomap_swapfile_fail(struct iomap_swapfile_info *isi, const char *str)
+static int iomap_swapfile_fail(struct file *file, const char *str)
 {
 	char *buf, *p = ERR_PTR(-ENOMEM);
 
 	buf = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (buf)
-		p = file_path(isi->file, buf, PATH_MAX);
+		p = file_path(file, buf, PATH_MAX);
 	pr_err("swapon: file %s %s\n", IS_ERR(p) ? "<unknown>" : p, str);
 	kfree(buf);
 	return -EINVAL;
 }
 
 /*
- * Accumulate iomaps for this swap file.  We have to accumulate iomaps because
- * swap only cares about contiguous page-aligned physical extents and makes no
- * distinction between written and unwritten extents.
+ * Report physical extents for this swap file.  Physical extents reported to the
+ * swap code must be trimmed to align to a page boundary.  The logical offset
+ * within the file is irrelevant since the swapfile code maps logical page
+ * numbers of the swap device to the physical page-aligned extents.
  */
-static int iomap_swapfile_iter(struct iomap_iter *iter,
-		struct iomap *iomap, struct iomap_swapfile_info *isi)
+static int iomap_swapfile_iter(struct iomap_iter *iter, struct file *file,
+		struct swap_info_struct *sis)
 {
+	struct iomap *iomap = &iter->iomap;
+	uint64_t first_ppage;
+	uint64_t next_ppage;
+	int error;
+
 	switch (iomap->type) {
 	case IOMAP_MAPPED:
 	case IOMAP_UNWRITTEN:
@@ -64,35 +39,31 @@ static int iomap_swapfile_iter(struct iomap_iter *iter,
 		break;
 	case IOMAP_INLINE:
 		/* No inline data. */
-		return iomap_swapfile_fail(isi, "is inline");
+		return iomap_swapfile_fail(file, "is inline");
 	default:
-		return iomap_swapfile_fail(isi, "has unallocated extents");
+		return iomap_swapfile_fail(file, "has unallocated extents");
 	}
 
 	/* No uncommitted metadata or shared blocks. */
 	if (iomap->flags & IOMAP_F_DIRTY)
-		return iomap_swapfile_fail(isi, "is not committed");
+		return iomap_swapfile_fail(file, "is not committed");
 	if (iomap->flags & IOMAP_F_SHARED)
-		return iomap_swapfile_fail(isi, "has shared extents");
+		return iomap_swapfile_fail(file, "has shared extents");
 
 	/* Only one bdev per swap file. */
-	if (iomap->bdev != isi->sis->bdev)
-		return iomap_swapfile_fail(isi, "outside the main device");
-
-	if (isi->iomap.length == 0) {
-		/* No accumulated extent, so just store it. */
-		memcpy(&isi->iomap, iomap, sizeof(isi->iomap));
-	} else if (isi->iomap.addr + isi->iomap.length == iomap->addr) {
-		/* Append this to the accumulated extent. */
-		isi->iomap.length += iomap->length;
-	} else {
-		/* Otherwise, add the retained iomap and store this one. */
-		int error = iomap_swapfile_add_extent(isi);
-		if (error)
-			return error;
-		memcpy(&isi->iomap, iomap, sizeof(isi->iomap));
-	}
+	if (iomap->bdev != sis->bdev)
+		return iomap_swapfile_fail(file, "outside the main device");
 
+	/*
+	 * Round the start up and the end down so that the physical extent
+	 * aligns to a page boundary.
+	 */
+	first_ppage = ALIGN(iomap->addr, PAGE_SIZE) >> PAGE_SHIFT;
+	next_ppage = ALIGN_DOWN(iomap->addr + iomap->length, PAGE_SIZE) >>
+			PAGE_SHIFT;
+	error = add_swap_extent(sis, next_ppage - first_ppage, first_ppage);
+	if (error)
+		return error;
 	return iomap_iter_advance_full(iter);
 }
 
@@ -110,10 +81,6 @@ int iomap_swap_activate(struct file *file, struct swap_info_struct *sis,
 		.len	= ALIGN_DOWN(i_size_read(inode), PAGE_SIZE),
 		.flags	= IOMAP_REPORT,
 	};
-	struct iomap_swapfile_info isi = {
-		.sis = sis,
-		.file = file,
-	};
 	int ret;
 
 	/*
@@ -125,16 +92,7 @@ int iomap_swap_activate(struct file *file, struct swap_info_struct *sis,
 		return ret;
 
 	while ((ret = iomap_iter(&iter, ops)) > 0)
-		iter.status = iomap_swapfile_iter(&iter, &iter.iomap, &isi);
-	if (ret < 0)
-		return ret;
-
-	if (isi.iomap.length) {
-		ret = iomap_swapfile_add_extent(&isi);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
+		iter.status = iomap_swapfile_iter(&iter, file, sis);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iomap_swap_activate);
-- 
2.53.0


