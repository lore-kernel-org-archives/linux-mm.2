Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 394F3D47CCD
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DB4E6B0095; Fri, 16 Jan 2026 05:13:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964A86B0096; Fri, 16 Jan 2026 05:13:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8640E6B0098; Fri, 16 Jan 2026 05:13:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 750096B0095
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:13:04 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 339381A05E3
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:13:04 +0000 (UTC)
X-FDA: 84337413888.29.14DE2BA
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by imf30.hostedemail.com (Postfix) with ESMTP id 687DC8000A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:13:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="GSl/06MQ";
	spf=pass (imf30.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768558382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BgNe2KClDQ4hSoLFcOrhtcJFQXeFNHMsjPEUh+pkpmQ=;
	b=A8i1g5y3OdOLDYBPT7K3Pjg2O+jYMZu6TrjW6bINwABbuwC88wbzd7kKEpZYSK8GHPXtag
	87whdqtWxoiT0lc3Lv8Aq51HFoQNkAMYTlNxATH3W5mbQp+daqtY4dqr3Y+e2QfbseZrBZ
	EApr7EkLyc8DARDntkd37BlahcorCVw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="GSl/06MQ";
	spf=pass (imf30.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.25 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768558382; a=rsa-sha256;
	cv=none;
	b=4R1CkD0MN8DbhIEP6IbkIxHeWMSUkiDNfUOiHBgAgjdmv4vMhzUbtcxHPbxfmpqUFi+1N0
	l4wEip3D1+XtJqkupoDZHtfZPySIOR585KrcVnhenm7IKFk8rzvnZzm8i1MvCqdQrUd4M4
	md9DGNIV1G6nTcKd8QByPSU+w7El8X4=
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260116101258epoutp02e28650582d78b2adc597d3a6bfcabcff~LLnmkbr200443004430epoutp02w
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:12:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260116101258epoutp02e28650582d78b2adc597d3a6bfcabcff~LLnmkbr200443004430epoutp02w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768558378;
	bh=BgNe2KClDQ4hSoLFcOrhtcJFQXeFNHMsjPEUh+pkpmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSl/06MQCTcn6yrKwH56OSOZt3PIWhZ3MeaiPZOxTEyi+iQwUZK8UtF6Gocg2GEji
	 rry/kMmLDkUaeNK1Mw3lK/DFjP2wn3ckcjEB0x1+pt+5MNPUx+6PfNPSWoXYolRUUa
	 IZ1CfLw0VhzP6lKb4M0TblSibEiHPO5ML5Ljr1Gs=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260116101257epcas5p22e003553205af204b04e5d3beb95bd3e~LLnl18QVR0070600706epcas5p2i;
	Fri, 16 Jan 2026 10:12:57 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.95]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dswf06Z0Fz6B9m5; Fri, 16 Jan
	2026 10:12:56 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260116101256epcas5p2d6125a6bcad78c33f737fdc3484aca79~LLnkb0WwQ0497304973epcas5p2I;
	Fri, 16 Jan 2026 10:12:56 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260116101251epsmtip28e575dac3f1710c8d7adf508a92e75e0~LLngPxtb10634506345epsmtip2K;
	Fri, 16 Jan 2026 10:12:51 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	djwong@kernel.org, dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, kundan.kumar@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: [PATCH v3 4/6] xfs: tag folios with AG number during buffered write
 via iomap attach hook
Date: Fri, 16 Jan 2026 15:38:16 +0530
Message-Id: <20260116100818.7576-5-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260116100818.7576-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260116101256epcas5p2d6125a6bcad78c33f737fdc3484aca79
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101256epcas5p2d6125a6bcad78c33f737fdc3484aca79
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	<CGME20260116101256epcas5p2d6125a6bcad78c33f737fdc3484aca79@epcas5p2.samsung.com>
X-Stat-Signature: rzw7xq8oarwuj6bna9iaq6kn41377yp7
X-Rspam-User: 
X-Rspamd-Queue-Id: 687DC8000A
X-Rspamd-Server: rspam08
X-HE-Tag: 1768558381-833336
X-HE-Meta: U2FsdGVkX1/aXXJNXY+r+BsXsIydL4P/mEo9amWd7WO8KkdRXhoBsZumMZyX503kyBnzTDC2pUT30Jdwb8JvbK8n8v+q5MsSeHxD+H8zVClQGd6mAQXxua265kOHXnH+D1pOo+JA9jUl4mKlJm2y0BnjyfD+63LP4hFxw2mq97kyO9zYA1iSXeEIm+Zaaxi/RVfEdtg2UD9ntRqTKU3KUjHCsFnFYftctmbHaa7UQ9GjN2ARc14Tfq6ul6nira6OlcDXMzTSPnYYFZl7wv1WKXGuZTZR70slgN7LEqZ5XF0wAZU6KSRGBiJqzs96CE1lKVvgvd2NMCYeXomOy43dwOgeGv8y1Mdit5ABe73zT08HHeJ7mItJX4aRGYHz9eNAlkuA9fuRT7iJcWeFJd4E7Q2+99VxZ50ZHpxo6OTbtwBzm4A2SkbRLDEYLOKauXh/1w5sIhTO1Nti9XXjECiZBoAq+uN80PlPa733FV1eqza0yKPL56PqnzJlHt5vWAGdMAG/1pofMVrTNO0aVlP+AHssTsPST+Eu/ntmfKnqPw7ffeuQrkE9MAjO7N6X9xgs3XgavN9jpQD4fT6xJccFMB+IUbKfeUL68goUquw+u6QcONLh8AgaVGAcQ5WDduGjdXAup6o2UHaPIRANRvt+R8nY9l42yV3plta4W77RIUpaiv/hZfY6OZ79OFALlziNZ5+KlG7WFqY7UXu0drfSCt8vepgVby2c9XuqbdT4T3ZM/EW/435wzJmSU24wYI0hE3AJljaqClRwCoOxUcG0/+mEoCg8svMXbCm/diqANOr5yOIGeekc0O0V+SX+TYTZ1XjfxCpnTvVn9F682ZEUfBoEkC9/J/SVQm76czeLzUaKNOve9xUUvA4oVBgoqYGVHJTJdivWnKYzVeufSy2cnoy0TCu3/Tpzbq8PGLK5GFyHoCHmIuid9D1G0PfUyzkIpRV+bHcodKMwF8Y5o+F
 4WRv2lP/
 f2uFn8uwCrYhSegbNdT7rghw8LnFDVrU5oQwXPj40osdR4MC7NV18ZsDhtUpE7PAJ0r2SbtNpzRCNgAV7z1xyTBWgaV+Ahivig0j00u+RieFWZXUbej1uQrBnbXMWy2NppANX89F/TH160NgtpcDUliTvI+CBIwiqLtop
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the iomap attach hook to tag folios with their predicted
allocation group at write time. Mapped extents derive AG directly;
delalloc and hole cases use a lightweight predictor.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/xfs/xfs_iomap.c | 114 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 490e12cb99be..3c927ce118fe 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -12,6 +12,9 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
+#include "xfs_alloc.h"
+#include "xfs_ag.h"
+#include "xfs_ag_resv.h"
 #include "xfs_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
@@ -92,8 +95,119 @@ xfs_iomap_valid(
 	return true;
 }
 
+static xfs_agnumber_t
+xfs_predict_delalloc_agno(const struct xfs_inode *ip, loff_t pos, loff_t len)
+{
+	struct xfs_mount *mp = ip->i_mount;
+	xfs_agnumber_t start_agno, agno, best_agno;
+	struct xfs_perag *pag;
+
+	xfs_extlen_t free, resv, avail;
+	xfs_extlen_t need_fsbs, min_free_fsbs;
+	xfs_extlen_t best_free = 0;
+	xfs_agnumber_t agcount = mp->m_sb.sb_agcount;
+
+	/* RT inodes allocate from the realtime volume */
+	if (XFS_IS_REALTIME_INODE(ip))
+		return XFS_INO_TO_AGNO(mp, ip->i_ino);
+
+	start_agno =  XFS_INO_TO_AGNO(mp, ip->i_ino);
+
+	/*
+	 * size-based minimum free requirement.
+	 * Convert bytes to fsbs and require some slack.
+	 */
+	need_fsbs = XFS_B_TO_FSB(mp, (xfs_fsize_t)len);
+	min_free_fsbs = need_fsbs + max_t(xfs_extlen_t, need_fsbs >> 2, 128);
+
+	/*
+	 * scan AGs starting at start_agno and wrapping.
+	 * Pick the first AG that meets min_free_fsbs after reservations.
+	 * Keep a "best" fallback = maximum (free - resv).
+	 */
+	best_agno = start_agno;
+
+	for (xfs_agnumber_t i = 0; i < agcount; i++) {
+		agno = (start_agno + i) % agcount;
+		pag = xfs_perag_get(mp, agno);
+
+		if (!xfs_perag_initialised_agf(pag))
+			goto next;
+
+		free = READ_ONCE(pag->pagf_freeblks);
+		resv = xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE);
+
+		if (free <= resv)
+			goto next;
+
+		avail = free - resv;
+
+		if (avail >= min_free_fsbs) {
+			xfs_perag_put(pag);
+			return agno;
+		}
+
+		if (avail > best_free) {
+			best_free = avail;
+			best_agno = agno;
+		}
+next:
+		xfs_perag_put(pag);
+	}
+
+	return best_agno;
+}
+
+static inline xfs_agnumber_t xfs_ag_from_iomap(const struct xfs_mount *mp,
+		const struct iomap *iomap,
+		const struct xfs_inode *ip, loff_t pos, size_t len)
+{
+	if (iomap->type == IOMAP_MAPPED || iomap->type == IOMAP_UNWRITTEN) {
+		/* iomap->addr is byte address on device for buffered I/O */
+		xfs_fsblock_t fsb = XFS_BB_TO_FSBT(mp, BTOBB(iomap->addr));
+
+		return XFS_FSB_TO_AGNO(mp, fsb);
+	} else if (iomap->type == IOMAP_HOLE || iomap->type == IOMAP_DELALLOC) {
+		return xfs_predict_delalloc_agno(ip, pos, len);
+	}
+
+	return XFS_INO_TO_AGNO(mp, ip->i_ino);
+}
+
+static void xfs_agp_set(struct xfs_inode *ip, pgoff_t index,
+			xfs_agnumber_t agno, u8 type)
+{
+	u32 packed = xfs_agp_pack((u32)agno, type, true);
+
+	/* store as immediate value */
+	xa_store(&ip->i_ag_pmap, index, xa_mk_value(packed), GFP_NOFS);
+
+	/* Mark this AG as having potential dirty work */
+	if (ip->i_ag_dirty_bitmap && (u32)agno < ip->i_ag_dirty_bits)
+		set_bit((u32)agno, ip->i_ag_dirty_bitmap);
+}
+
+static void
+xfs_iomap_tag_folio(const struct iomap *iomap, struct folio *folio,
+		loff_t pos, size_t len)
+{
+	struct inode *inode;
+	struct xfs_inode *ip;
+	struct xfs_mount *mp;
+	xfs_agnumber_t agno;
+
+	inode = folio_mapping(folio)->host;
+	ip = XFS_I(inode);
+	mp = ip->i_mount;
+
+	agno = xfs_ag_from_iomap(mp, iomap, ip, pos, len);
+
+	xfs_agp_set(ip, folio->index, agno, (u8)iomap->type);
+}
+
 const struct iomap_write_ops xfs_iomap_write_ops = {
 	.iomap_valid		= xfs_iomap_valid,
+	.tag_folio		= xfs_iomap_tag_folio,
 };
 
 int
-- 
2.25.1


