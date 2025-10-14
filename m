Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B654CCD18D
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7B38E0101; Tue, 14 Oct 2025 08:11:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98E48E000D; Tue, 14 Oct 2025 08:11:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A866B8E0101; Tue, 14 Oct 2025 08:11:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9314A8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:11:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70451BBCF9
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:43 +0000 (UTC)
X-FDA: 83996605686.09.0D5E2DD
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by imf12.hostedemail.com (Postfix) with ESMTP id DC0E54000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=IZEVWzpU;
	spf=pass (imf12.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760443901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P26ywqsMnB1wfPCMRtpUS0xgTfcL9X0rkalZt4nakI0=;
	b=03P8wL2xbCZXfwyJdkkHYGBI1jGP94O4AV1z7msg5BPedpBkd4TAxMUaLW/OKKn798/fpC
	CiDs99L/08s7Whf/qhqUZJYaIyBk4hIxnT4uhLcY6ClXN21NzErWvzXyH6GxYZVn4Kk3Ld
	WYVpY0JnRivXWEmtAxx0t0xtTaUmOfc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=IZEVWzpU;
	spf=pass (imf12.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760443901; a=rsa-sha256;
	cv=none;
	b=61ACaK7gu1iI4XC6qX3XS9RDm6eOBqH2z5Xtl7iGSJUhN3mQQjJ3HLnecKVyroUSs/7E/c
	GvYqgzxboxwtpvzc647Z2cRoLlQll5HuVGXCwxt67LAeLSbzHp+7A2FDmTAHrpZXU9+23E
	Ny94zBsEGBbEFfdLtVMZjhihDv2P43U=
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251014121138epoutp039c62e8ccd5eda9ca8e9c8581b9e3d6b5~uWmYJ4ZWb0713307133epoutp03t
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251014121138epoutp039c62e8ccd5eda9ca8e9c8581b9e3d6b5~uWmYJ4ZWb0713307133epoutp03t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760443898;
	bh=P26ywqsMnB1wfPCMRtpUS0xgTfcL9X0rkalZt4nakI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IZEVWzpUM/VeejCxB/jGms73fEuWMwgHnd43yIQgt1GWnuFDZiPddMvQlfgmuselr
	 P8CMZVovdo1GkWEFNVldpJQ8snOLCctSBP9XD24zoZGz9iz9Hp6oLEr1bJQ1M6v5Rr
	 O61UQsByvXzJ7XsFA5175gAii6scO4d7O9zrDXY4=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20251014121137epcas5p252ab21a6f213e2a3de40624cc4a06c89~uWmXXMLo33235432354epcas5p2t;
	Tue, 14 Oct 2025 12:11:37 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.95]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cmCkJ5szQz2SSKY; Tue, 14 Oct
	2025 12:11:36 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20251014121135epcas5p2aa801677c0561db10291c51d669873e2~uWmVjz9X22441424414epcas5p2q;
	Tue, 14 Oct 2025 12:11:35 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251014121131epsmtip1ababe9c4e8295da908008c77b52ba39e~uWmROln091256112561epsmtip1N;
	Tue, 14 Oct 2025 12:11:31 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: jaegeuk@kernel.org, chao@kernel.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, miklos@szeredi.hu, agruenba@redhat.com,
	trondmy@kernel.org, anna@kernel.org, akpm@linux-foundation.org,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	djwong@kernel.org, dave@stgolabs.net, wangyufei@vivo.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, linux-nfs@vger.kernel.org, linux-mm@kvack.org,
	gost.dev@samsung.com, kundan.kumar@samsung.com, anuj20.g@samsung.com,
	vishak.g@samsung.com, joshi.k@samsung.com
Subject: [PATCH v2 16/16] writeback: added XFS support for matching
 writeback count to allocation group count
Date: Tue, 14 Oct 2025 17:38:45 +0530
Message-Id: <20251014120845.2361-17-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251014120845.2361-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251014121135epcas5p2aa801677c0561db10291c51d669873e2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014121135epcas5p2aa801677c0561db10291c51d669873e2
References: <20251014120845.2361-1-kundan.kumar@samsung.com>
	<CGME20251014121135epcas5p2aa801677c0561db10291c51d669873e2@epcas5p2.samsung.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DC0E54000D
X-Stat-Signature: rrq5wfensizetw9t1eyi9ywyyry6mgik
X-Rspam-User: 
X-HE-Tag: 1760443900-705776
X-HE-Meta: U2FsdGVkX18T7CisUsTB4z6YDhF+ajYmP3lOrPD3FvPZHxx1wU5phfQuatNvo94JStPnHnJ2ClWER4YjIKx1z6D9QJuzUUN17EfwfcMcx8JBIt5+gpvOXSe0dy4YJ2zLWGQEroVhZW72zTPrb2UBkyTqSpBPly2cwAnLjrw05FNMsmLRZKWqtNcayi2dk69TirKLREEvqTSsrWeXQWhUQlYny5mVAccKmHBtm/Un0mtg3wlKemvy6wMtlR+7B8lQ5bWeuYmvvzW/mtu9LymS3EPl46+cCNOCP51k2kl6GAlKAYye0kS84wY1cooNV8nw96a6YAo0tcGBQLjqiAvaPRyjva/HmSiW7Fe61VbQ4qpJjspFSB8AIbwmHZ0DzDmbmUUW6o3/cCwgSn9sHDtLUAtrCDMSfBOyEBwHWvwSeKGBllNFGfz9eGHNZczekFblF4BJgZMX3QJUpn4+sCA3s/uxgpjEVIABRhXX7e047V6mGN0cY4/gkPFgnzaoZGh1l24J3IqyZCBjiuF3uC3gKyPxJ5Zr0AKy4Dbssn2jkOWTouv7AUdt3M+e0pQQMJ71R8bISmjTBObn2TpzWaY2tieDaEkwJSma5jNi1+dvoJcHW0WQyPQBm5gF5gy3r2zzSiOjdtucraT0OI3tbDrP8UfJCFxEN8SqW887jw0Q6k8n17X6OJNh9hZ3RN64K4rn5y/pd+oLz/rWb1NMKY3Zv2zUOF9m6wC9b1T+2W88PTCna4xUkgOlsSQ7J1Dy85H/GEDo7iEwRa1kBT98LkvqUgz4L6+9G0OnN4kzzjNjE8cz8ZUdUxM2XODysVH0QyzbA0jqbKKNcX0llIz5jmWJ68K2XH5Uk+Yk/RTPbIO4rUM37wxJoCX2DYFRSI0rQOdifJx1KdS6scqJlKhjMc1tb7JHFqIcTlKYD2lu8TedHHB4viaYnV3I/je5ayuHszwZ7jbgtLcv6xfZGsEEqeI
 xBJz3z6Q
 dtQaXscOqFGKiJWzItBtcAXZINnJnmo6jG6DGv3NEbEWp1Hk0zRj9RalpsO4kHJxCvCKsvP5DOGDB4msZi50ow91qgsnjjNkWrmVQtHLl9eNW7ZC97ksOaI3dfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implemented bdi_inc_writeback() to increase the writeback context
count and called this function at XFS mount time to set the desired
count.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/xfs/xfs_super.c          |  2 ++
 include/linux/backing-dev.h |  1 +
 mm/backing-dev.c            | 58 +++++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b3ec9141d902..aa97b59f53c6 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1783,6 +1783,8 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_free_sb;
 
+	bdi_inc_writeback(sb->s_bdi, mp->m_sb.sb_agcount);
+
 	/*
 	 * V4 support is undergoing deprecation.
 	 *
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 14f53183b8d1..89a465e1964f 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -40,6 +40,7 @@ void wb_start_background_writeback(struct bdi_writeback *wb);
 void wb_workfn(struct work_struct *work);
 
 void wb_wait_for_completion(struct wb_completion *done);
+int bdi_inc_writeback(struct backing_dev_info *bdi, int nwriteback);
 
 extern spinlock_t bdi_lock;
 extern struct list_head bdi_list;
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 5bfb9bf3ce52..e450b3a9b952 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -1219,6 +1219,64 @@ struct backing_dev_info *bdi_alloc(int node_id)
 }
 EXPORT_SYMBOL(bdi_alloc);
 
+int bdi_inc_writeback(struct backing_dev_info *bdi, int nwritebacks)
+{
+	struct bdi_writeback_ctx **wb_ctx;
+	int ret = 0;
+
+	if (nwritebacks <= bdi->nr_wb_ctx)
+		return ret;
+
+	wb_ctx = kcalloc(nwritebacks, sizeof(struct bdi_writeback_ctx *),
+			 GFP_KERNEL);
+	if (!wb_ctx)
+		return -ENOMEM;
+
+	for (int i = 0; i < bdi->nr_wb_ctx; i++)
+		wb_ctx[i] = bdi->wb_ctx[i];
+
+	for (int i = bdi->nr_wb_ctx; i < nwritebacks; i++) {
+		wb_ctx[i] = (struct bdi_writeback_ctx *)
+			kzalloc(sizeof(struct bdi_writeback_ctx), GFP_KERNEL);
+		if (!wb_ctx[i]) {
+			pr_err("Failed to allocate %d", i);
+			while (--i >= bdi->nr_wb_ctx)
+				kfree(wb_ctx[i]);
+			kfree(wb_ctx);
+			return -ENOMEM;
+		}
+		INIT_LIST_HEAD(&wb_ctx[i]->wb_list);
+		init_waitqueue_head(&wb_ctx[i]->wb_waitq);
+
+#ifdef CONFIG_CGROUP_WRITEBACK
+		INIT_RADIX_TREE(&wb_ctx[i]->cgwb_tree, GFP_ATOMIC);
+		init_rwsem(&wb_ctx[i]->wb_switch_rwsem);
+#endif
+		ret = wb_init(&wb_ctx[i]->wb, wb_ctx[i], bdi, GFP_KERNEL);
+		if (!ret) {
+#ifdef CONFIG_CGROUP_WRITEBACK
+			wb_ctx[i]->wb.memcg_css = &root_mem_cgroup->css;
+			wb_ctx[i]->wb.blkcg_css = blkcg_root_css;
+#endif
+		} else {
+			while (--i >= bdi->nr_wb_ctx)
+				kfree(wb_ctx[i]);
+			kfree(wb_ctx);
+			return ret;
+		}
+		cgwb_bdi_register(bdi, wb_ctx[i]);
+		set_bit(WB_registered, &wb_ctx[i]->wb.state);
+	}
+
+	spin_lock_bh(&bdi_lock);
+	kfree(bdi->wb_ctx);
+	bdi->wb_ctx = wb_ctx;
+	bdi->nr_wb_ctx = nwritebacks;
+	spin_unlock_bh(&bdi_lock);
+	return 0;
+}
+EXPORT_SYMBOL(bdi_inc_writeback);
+
 static struct rb_node **bdi_lookup_rb_node(u64 id, struct rb_node **parentp)
 {
 	struct rb_node **p = &bdi_tree.rb_node;
-- 
2.25.1


