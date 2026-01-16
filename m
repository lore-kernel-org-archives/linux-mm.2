Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFBFBD47CCD
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2F326B0092; Fri, 16 Jan 2026 05:13:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE2CB6B0093; Fri, 16 Jan 2026 05:13:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0CD16B0095; Fri, 16 Jan 2026 05:13:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC4146B0092
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:13:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 703548C114
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:13:00 +0000 (UTC)
X-FDA: 84337413720.26.81984F0
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by imf18.hostedemail.com (Postfix) with ESMTP id AC4C81C0008
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:12:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="Wlu3/gpc";
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf18.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768558378; a=rsa-sha256;
	cv=none;
	b=OMmnbb9NiqVFWBYoIp7stP7aRtwWDL5ZDVdxcr+bcZUKr/RbIAJzy61MRyf0CjswyqZM4c
	8sy4P25uUcYdgu9WyANht+U9R66cz6xkkA5CBrI7sYlBXZT63YHdO9PBriENsT5lYXX1ZR
	tddhDLUQA0ntv5DjFPRTibb6S+Iv+Hg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="Wlu3/gpc";
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf18.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768558378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mYC8Dqvp92r/wg8xMSAO9zq0NNohCtpUQQiPpSCFoCs=;
	b=h00rrgR4wNLc7qKLjrHVhupppDF3EotLkBF4z4ELEAOuIvQJrnNpsmA3hE/G/UA8KJ1hXj
	5RWCzkAmBLK8fhDkn8eszrlRKCE8gi9qagv6c/VaN7XM12CtmJ8EB5JW/5pysc0ptkxj93
	RXDt1HXfMgH1pfuNFnO0L+szezZOWic=
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260116101254epoutp0184a0815f7634c6360865f390cf73472f~LLni61sud1968519685epoutp01W
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:12:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260116101254epoutp0184a0815f7634c6360865f390cf73472f~LLni61sud1968519685epoutp01W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768558374;
	bh=mYC8Dqvp92r/wg8xMSAO9zq0NNohCtpUQQiPpSCFoCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wlu3/gpcNdeMpzJ58CLEmcpMGyL+ZS1H9/EWZw+4uramp5o3kIwpEw22AoJv34UOt
	 ypGVRVatUCBCp01tWedn9PDMMbWC+XipgGlQmXlQhU3lGy70AXe0EwuKjTgi1AEQPg
	 72eayCEiwiFiv0zHtjo5HhzDEriJ3rplUAsP+K20=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260116101253epcas5p2ca0dc5ea707a8c9493821828dce93539~LLnh7hBVX0062300623epcas5p2Z;
	Fri, 16 Jan 2026 10:12:53 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.94]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dswdw4NxKz3hhT4; Fri, 16 Jan
	2026 10:12:52 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc~LLnfqYF-A1384113841epcas5p1R;
	Fri, 16 Jan 2026 10:12:51 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260116101246epsmtip2a665d2893c692e021ee430a0b49d0bc2~LLnaypkkV0722507225epsmtip2Q;
	Fri, 16 Jan 2026 10:12:45 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	djwong@kernel.org, dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, kundan.kumar@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: [PATCH v3 3/6] xfs: add per-inode AG prediction map and dirty-AG
 bitmap
Date: Fri, 16 Jan 2026 15:38:15 +0530
Message-Id: <20260116100818.7576-4-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260116100818.7576-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
	<CGME20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc@epcas5p1.samsung.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AC4C81C0008
X-Stat-Signature: 1q1niwx3qhfog88p7zojzy8an4qnik8t
X-Rspam-User: 
X-HE-Tag: 1768558377-886917
X-HE-Meta: U2FsdGVkX1+bLhg5anUyP9R++gan94AVQwDwBHeI5xx3Yj2xS6IcEMib2OLW3ygUExw3IWwnmcs0f9TqTtU9fjBGtjm7L3f9YXgzkGKCARMYkJIUcOxn0SBOg5+/xVAchwhQycYFM2xdXyLlFI0YA2jxGtteI3//+fv8fLKTtn00p4FIHFmxTiXvYDGx/8FqWLq1SSknnnk+XjSqN0gBqT/oadlW4G6BJYoJL3Wn894huat6tdbiyfNj27J0wqoFQzqgtZEa4fr0/d/wcrrIvA1JKLfUTFcZOCmczrQvOBy1GjxssnP3iljp0l1hlhc/X+D7kRZqz5NxYfTYBCDRlK8G65gZ/+RYZvPwYlROwr66RF7PCKlnrlhyzsIAv9ipI8eS+UH1Gi3zfk1K97HMWudElTHEBSqz2kQZv6agnkSrziEfPYdtqgYJzyguu5bweZlzmSXwT93MbQShXeakxi+8v9N5ZbBUeEV7HxlLqjIZoymSU3kM3Wr+iHlGbOT+JP9nJiEpSjoXufjdikCgYPE1AswBlReJL3yI+/x1ZdKhzKKLJvZP6omuyAr2BcF7t4DC/wHpTE8Vr49dzLOnCP3N0KSVptK4YbBqb4Nma/1kEXkXY3jeukh+bRQnGPg7pjEpg6kgFTDQcfrFuhelW8qWM0NJZDThdcmraqO4TormMitMFB/vXQGxP1yxLd2fslBQz6ld202zaaR3yVwCnFV1L5+yzQfvUhf4NfVmv7o53F8tjf8l447Dwseok1pigJ0gARAurpESphRDiazsvqcLbFt2wEK87leX5an+b++Rgmmg2Wju/6A2SyPx473awIRBuzEEU5e+uqC7V6EETshHzv+sYz7QV5uPS3MqJTBTsnqwFL421m4poc2L2eDmEImKldWGvch2kkO772jEh2FHhZotfpfc0TfqrPaN+FNzR1XUq+1GASr6btpHBCAJY/ECTxHPFmhHqFKUknW
 nRmBADq0
 o4q3fw7m4y2pufDRwJBn2Sy70oDadX5AgyB/u7V1cj/XXu3qYg9hLJUFkhVi1lcnf28Gdh0cqLf4VfiXfx2EtXX2xsIpHT7Ttf/AYii75DCf29QS97N6MhU5zcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add per-inode structures to track predicted AGs of dirty folios using
an xarray and bitmap. This enables efficient identification of AGs
involved in writeback.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/xfs/xfs_icache.c | 27 +++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h  |  5 +++++
 2 files changed, 32 insertions(+)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e44040206851..f97aa6d66271 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -80,6 +80,25 @@ static inline xa_mark_t ici_tag_to_mark(unsigned int tag)
 	return XFS_PERAG_BLOCKGC_MARK;
 }
 
+static int xfs_inode_init_ag_bitmap(struct xfs_inode *ip)
+{
+	unsigned int bits = ip->i_mount->m_sb.sb_agcount;
+	unsigned int nlongs;
+
+	xa_init_flags(&ip->i_ag_pmap, XA_FLAGS_LOCK_IRQ);
+	ip->i_ag_dirty_bitmap = NULL;
+	ip->i_ag_dirty_bits = bits;
+
+	if (!bits)
+		return 0;
+
+	nlongs = BITS_TO_LONGS(bits);
+	ip->i_ag_dirty_bitmap = kcalloc(nlongs, sizeof(unsigned long),
+					GFP_NOFS);
+
+	return ip->i_ag_dirty_bitmap ? 0 : -ENOMEM;
+}
+
 /*
  * Allocate and initialise an xfs_inode.
  */
@@ -131,6 +150,8 @@ xfs_inode_alloc(
 	ip->i_next_unlinked = NULLAGINO;
 	ip->i_prev_unlinked = 0;
 
+	xfs_inode_init_ag_bitmap(ip);
+
 	return ip;
 }
 
@@ -194,6 +215,12 @@ xfs_inode_free(
 	ip->i_ino = 0;
 	spin_unlock(&ip->i_flags_lock);
 
+	/* free xarray contents (values are immediate packed ints) */
+	xa_destroy(&ip->i_ag_pmap);
+	kfree(ip->i_ag_dirty_bitmap);
+	ip->i_ag_dirty_bitmap = NULL;
+	ip->i_ag_dirty_bits = 0;
+
 	__xfs_inode_free(ip);
 }
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index bd6d33557194..dee449168605 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -99,6 +99,11 @@ typedef struct xfs_inode {
 	spinlock_t		i_ioend_lock;
 	struct work_struct	i_ioend_work;
 	struct list_head	i_ioend_list;
+
+	/* AG prediction map: pgoff_t -> packed u32 */
+	struct xarray           i_ag_pmap;
+	unsigned long           *i_ag_dirty_bitmap;
+	unsigned int            i_ag_dirty_bits;
 } xfs_inode_t;
 
 static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)
-- 
2.25.1


