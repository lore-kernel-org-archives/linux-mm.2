Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC3A1CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:10:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C23F8E00F4; Tue, 14 Oct 2025 08:10:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 072F98E000D; Tue, 14 Oct 2025 08:10:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA3D8E00F4; Tue, 14 Oct 2025 08:10:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DBE4B8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:10:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF6981A0882
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:33 +0000 (UTC)
X-FDA: 83996602746.27.900450E
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1BBBD100010
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=ThcGvJtD;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf05.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760443831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Fpri/DmmIz0lhNfmDYWM4M9dqrldIQivF7NvztYdbQ=;
	b=TCK037jX+3kpbSt6HJgCi8UFKd/qN8VBL4FWi+YYcMIDR54f8+dNE6aoiSYeo45+UtQ8Ci
	NLZO7TBiaZVyuo0Iv6rpoBV+2XyqDz3oYeZ9iTBs/V7L1IWhbWNbELfe7iZFRrc1rLEqVI
	KXtB1GayjcqxFknDEzz4uQv/vGe9WaE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760443831; a=rsa-sha256;
	cv=none;
	b=SwofnHuOeoAXxEfOExrG7IYfSoMVKhRHneUxYfuB5X9JSPJhaqrtbeHhAmn+/uh5CpO4ez
	4tSMgXB/NUYONzn/kB345e3grrlKCLL8f0w2JIWdUmFVvjaBpH4devQyBJtowzmGzi4oyt
	48UDgNwquJdNCMXoBO28D3UMP2l6kpg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=ThcGvJtD;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf05.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20251014121028epoutp049cd76ac7cbd094537bb6cf71fad658b8~uWlW1sHPn0829908299epoutp04S
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20251014121028epoutp049cd76ac7cbd094537bb6cf71fad658b8~uWlW1sHPn0829908299epoutp04S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760443828;
	bh=7Fpri/DmmIz0lhNfmDYWM4M9dqrldIQivF7NvztYdbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ThcGvJtDjMZOIP5h5Rwuk+Tgmz1tWjYMn1kCPySidm5U6ktLxw/wJlnGFhn2OKj5q
	 T5/A2RWR+c5cI7n2Uq954TnJU6r3k5/eX3HkXfraM4fdC59SCj3Cqr1Vqgf/KUrjnq
	 jsUwUrc9gm7BZvfZ4zO8CA3lHIscLOzTXdt3kHPg=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20251014121027epcas5p2be9b795d75fcf8516e4e7d26e5044fca~uWlWT01iz1631916319epcas5p2m;
	Tue, 14 Oct 2025 12:10:27 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.91]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cmChy70jsz6B9m6; Tue, 14 Oct
	2025 12:10:26 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20251014121026epcas5p1aecefead887a6b4b6745cca0519d1092~uWlU6QPmR0760907609epcas5p18;
	Tue, 14 Oct 2025 12:10:26 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251014121021epsmtip1a54fa06a954b7223466d190130d994e5~uWlP9AoTA1188911889epsmtip1i;
	Tue, 14 Oct 2025 12:10:20 +0000 (GMT)
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
Subject: [PATCH v2 03/16] writeback: link bdi_writeback to its corresponding
 bdi_writeback_ctx
Date: Tue, 14 Oct 2025 17:38:32 +0530
Message-Id: <20251014120845.2361-4-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251014120845.2361-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251014121026epcas5p1aecefead887a6b4b6745cca0519d1092
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014121026epcas5p1aecefead887a6b4b6745cca0519d1092
References: <20251014120845.2361-1-kundan.kumar@samsung.com>
	<CGME20251014121026epcas5p1aecefead887a6b4b6745cca0519d1092@epcas5p1.samsung.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: ug456i6z7kxnm1f9fkb5b44u6gdzbprq
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BBBD100010
X-HE-Tag: 1760443830-438040
X-HE-Meta: U2FsdGVkX1+NezcbYb9+6iN3Jd40asfUfQPm5LZlDl8ZfXx7653/4BXHDgpLtpBKfFg+My7+6FcVXN4iQOuhugzCgjJI0Lp8uhmW1i6icWU9Y6ghvxEUctirDRoV7Lunheow02M1iiD3Y1Bxjdze6xmT9Hn53pk7cHvMIVrRz2JMFlxSWmjKG6Cdpx9uqPyVmep+34YNBYHlQG65iW901H6KNkv/YK5kY2Tt0/qD3n4l/CYUyBJ6AMVuGw2kfgVUT49bvQVOfnICIQmc1uOPs/tOcIa6vuC7pC53FADd3FFdvgqA2l6OJtHsKf/R3DokOOL+cCbf2iZMnBi+wch4uzt8ShYj4Cz5VpZ6wppPvpoLIpVYe/g4PBOeXhxwKjZ+5x25aUzrXrUBJ8GxQwDIPovwl6CZB5bi2s0tOS9bTPw/ZQoeBm1ZTdHE79RK2B+2HINFyliNT2ZMj7nL9oRQ1Asfpc1PqJWNsXNl1/haKAQbgryRuJznQkSF9h8wjfsFV7mXl+veFlJuGKjNwcbrYsVOM8rccSZJPyORO/eIhtMkFa5QN0kJCmUfVamDngF6Zw7OpRWQ39M/9hDd8YEMp5RWO3fz3ou34klRLCFhvzlyGxOJPqi5G3/iIbxDC0Nyvoz82eUGC+abPsXN6cNuwCmQ31k1ZfQ3kMcuF91D1NGMIRPK1IkXu500lPWLwYbC07KEDjPQxgnBm/Kkvo7WDma7c8E29RpKiI8Gy4eCUGgyj1pdc7oGRCJDbKoZBRde/6At+WRUnE87r8Y3Jgs6DdylpvwI03z1XMxBLK1KZn6UXUTWyYnLHUF/GpaTXeHgcImQ6AzlBXnT/yYNXCR6I7Ck3Y28VRxRv81v6lifLQTESzsUJ+afvCyPD0wMSsCymFmei02t4e6rMnA3TY5bWnLX2ZaTiLPM93ByZEdsB4sQFYY21aAXVw3axPhSrnBFH3B83AtrNKd0e5y8AO5
 +BDZ830W
 2btB7pAM5c53r7R5RF1Ry+217uRxK7cQEpGfiCejYu0eZc9pRTh3lfnEmr7GmBCfAW807MwIYZrWjkRhp7wqmch5VunnTXPcSsXuFctLla9mN7P1x8PufYPldQZPOGEUY7L2O+JyIpobuVirp5zBj1UDwcL1pSU8YQnUTKsf4VGfH4UZzaG8xmd2zYZMmO9DsopTmyaEcJ9a3NAJF281eGR/lYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a bdi_writeback_ctx field in bdi_writeback. This helps in
fetching the writeback context from the bdi_writeback.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 mm/backing-dev.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 47196d326e16..754f2f6c6d7c 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -513,15 +513,16 @@ static void wb_update_bandwidth_workfn(struct work_struct *work)
  */
 #define INIT_BW		(100 << (20 - PAGE_SHIFT))
 
-static int wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi,
-		   gfp_t gfp)
+static int wb_init(struct bdi_writeback *wb,
+		   struct bdi_writeback_ctx *bdi_wb_ctx,
+		   struct backing_dev_info *bdi, gfp_t gfp)
 {
 	int err;
 
 	memset(wb, 0, sizeof(*wb));
 
 	wb->bdi = bdi;
-	wb->bdi_wb_ctx = bdi->wb_ctx[0];
+	wb->bdi_wb_ctx = bdi_wb_ctx;
 	wb->last_old_flush = jiffies;
 	INIT_LIST_HEAD(&wb->b_dirty);
 	INIT_LIST_HEAD(&wb->b_io);
@@ -698,7 +699,7 @@ static int cgwb_create(struct backing_dev_info *bdi,
 		goto out_put;
 	}
 
-	ret = wb_init(wb, bdi, gfp);
+	ret = wb_init(wb, bdi_wb_ctx, bdi, gfp);
 	if (ret)
 		goto err_free;
 
@@ -843,7 +844,7 @@ static int cgwb_bdi_init(struct backing_dev_info *bdi)
 		mutex_init(&bdi->cgwb_release_mutex);
 		init_rwsem(&bdi_wb_ctx->wb_switch_rwsem);
 
-		ret = wb_init(&bdi_wb_ctx->wb, bdi, GFP_KERNEL);
+		ret = wb_init(&bdi_wb_ctx->wb, bdi_wb_ctx, bdi, GFP_KERNEL);
 		if (!ret) {
 			bdi_wb_ctx->wb.memcg_css = &root_mem_cgroup->css;
 			bdi_wb_ctx->wb.blkcg_css = blkcg_root_css;
@@ -1000,7 +1001,7 @@ static int cgwb_bdi_init(struct backing_dev_info *bdi)
 	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
 		int ret;
 
-		ret = wb_init(&bdi_wb_ctx->wb, bdi, GFP_KERNEL);
+		ret = wb_init(&bdi_wb_ctx->wb, bdi_wb_ctx, bdi, GFP_KERNEL);
 		if (ret)
 			return ret;
 	}
-- 
2.25.1


