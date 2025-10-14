Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B69CCD18D
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:10:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C82AD8E00F6; Tue, 14 Oct 2025 08:10:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C32848E000D; Tue, 14 Oct 2025 08:10:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B21908E00F6; Tue, 14 Oct 2025 08:10:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3158E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:10:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5CC585BBB9
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:44 +0000 (UTC)
X-FDA: 83996603208.19.0F7739E
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by imf02.hostedemail.com (Postfix) with ESMTP id B960480014
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=j4EoRb05;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf02.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760443842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O2U42LWZMM8201UpxKxW6f/AsVjv4jB1OSfEppuAbYw=;
	b=gAxLo5kMvteo1EXNWJDMtKXvZVQggXXXHBgjhC6qrVKIS7TUCutTL4W5lJlTo6Wt0MHA1q
	u2nkGh9bcRSR7KuGSwHUuW8x4ueZZYo4CIdgD2fCFfjJfR0Vp+554eQ5kIBro1VRTv30Ww
	6vXywBK2+Rnfm2ZINSKie0dy2+9n2K0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760443842; a=rsa-sha256;
	cv=none;
	b=jXGW0p4fFXtb6YHRSsypfgR47LHTTe4yFdtf7XHZjHdhtk/aSi7/mzSn3ILCdyMx0Be2gN
	2AcCC08mBAG+LMe37VOu/XDH0AT1hyeJFeZwjKtWjB0xUA3cOmMY+QXvP8Op4xVI36wTgf
	uXTU+voe0yLdJZ44BP2pq2z3yMraw5Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=j4EoRb05;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf02.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251014121039epoutp038c5241ddcfd666e64080a67ebbeea9f6~uWlg069cW0487904879epoutp03J
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251014121039epoutp038c5241ddcfd666e64080a67ebbeea9f6~uWlg069cW0487904879epoutp03J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760443839;
	bh=O2U42LWZMM8201UpxKxW6f/AsVjv4jB1OSfEppuAbYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j4EoRb052CyFlWparM6vJ+IGSCEWjIS6wVo+S87KDQqDA0Ocmw/12pWxJHIIh31zH
	 Esi8h9OyxeOyR15xYVX5wm7qtnvdwsg04HJRPmJ/1moWx5u2peXU8xFWHwP0Tb4pM0
	 +fUQ0OawY0mVdzW1x06h3YX1hssKOUzItdHKdfpU=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20251014121038epcas5p4685b828d668366916b45d174d16a3637~uWlgJt7Oo0610406104epcas5p4-;
	Tue, 14 Oct 2025 12:10:38 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.95]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cmCj93Ktwz6B9m6; Tue, 14 Oct
	2025 12:10:37 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20251014121036epcas5p17c607955db032d076daa2e5cfecfe8ea~uWleqppMN1447514475epcas5p1j;
	Tue, 14 Oct 2025 12:10:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251014121032epsmtip1fbff11e9fef5c6232ce81ec58fd0763b~uWlaFqXYA1256112561epsmtip1p;
	Tue, 14 Oct 2025 12:10:31 +0000 (GMT)
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
Subject: [PATCH v2 05/16] writeback: modify bdi_writeback search logic to
 search across all wb ctxs
Date: Tue, 14 Oct 2025 17:38:34 +0530
Message-Id: <20251014120845.2361-6-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251014120845.2361-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251014121036epcas5p17c607955db032d076daa2e5cfecfe8ea
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014121036epcas5p17c607955db032d076daa2e5cfecfe8ea
References: <20251014120845.2361-1-kundan.kumar@samsung.com>
	<CGME20251014121036epcas5p17c607955db032d076daa2e5cfecfe8ea@epcas5p1.samsung.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B960480014
X-Rspamd-Server: rspam02
X-Stat-Signature: r9zupjbujid4fdgionhi8reanmatnn8j
X-HE-Tag: 1760443841-350480
X-HE-Meta: U2FsdGVkX1+fFrKe6G+5NW2V4s6Fuyfzr1kn0INEDpJgpBjjnRSaAGUBNzXNlhqLR4oiKPZjrqa6T3AaymXyQCsAqlabQ4uYEWZZd/JwEucSJ6+vEEftkp+GBMa2hkucoT91k2CfHCYRB3AUQ/CVTYwzmgD1/KGoTh6SGZYCqfJTDh077l38ZWVYXb1x5mLNwBzSsgSLoUi4lHFvJ3yYH2E8oP/e8aBGOwwUlT/a6hSSEtvam7Dw5GbM4MJVpkKQC3WgfbeDSnOv3RNLsuf/x+/nMpMSvyb/ar9lCDyaFhBMT/1PnV8hsXNCx3n+Z37U+dw3eu4GGf6n+L25i3b/2dSExRvPxyFo1MDMyjCni5MoU/ky61kKiqxPZ0/iV18D0DTPFjalY+s1kbxGZEAsvEjEZd5RvAGLP2CzH300RZcfBBFlUcfJmemAp87j3c49bPcuAVAnk9mXIdn29/nFgg8/md4R6ynFCB9W4a+lEnYQVpAEEOmrDBe0brop8TrG48vqJY4IukiRu1zGmGCumn7txcgpPQbYwG5KdzUSmiE53jJsf8L2O97qSywpxemFuIG2yjVxqvxbOfN9beM31Z75hmh65ZIOfH47jRMo8jfxX1yrchHyC4O3JtTV9CP5jC7sFkb3d8VeGcQjXVRJTXJczHaYDspQbcj/iiZmvr7HzqiplSxDe7g4z9oVLqBhHpZIHqewndZr/MdcnHDQgFkFS3kTF8qhQB1mpvxl2N+IfsnUqYgN9R/61ZI/klk0n1q9X90LQoeGTcbBCZFbc8tvBESglSwrk8o9iOSWgxy1ElwZ1U5B0IQ3NuTvbYWt6wfiRyy1O2RZdPji/dHOngagUfJwKlCzhCsEvyVaIrBooyauxVzwXDN23srcvZ1FKgmCTJbkWtJwQsue+tbJWhf9xmLuCtb6FAz5P080a50p6QVvnjtfnVi6y1x7QJo/hFQy3epRx9rPpSvQ+gE
 o/hBgL++
 I1js3Q9wsXoG21/VqZuVsXjgkh/hXethJdr1+S3h1HxiHKUFxZmxasPm/3RrJ/ckTJW4sSiL2jk9KumzZmv0CwlULVPHqGe4RdEtjyCoLXy+ZrAqrSlJ1yJSJBXgOdFWtVVLbMN2rqCHkihbxiiYzfQw+cDmYS7nmnrnilUE9KXMG5Whke64DO6mUrVIOVb1JmRC0Q2Q3UDjKddyPimzExmGdkfx5QZ5CPm1cguzWnek40Hz4K9t4ISwVqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since we have multiple cgwb per bdi, embedded in writeback_ctx now, we
iterate over all of them to find the associated writeback.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/fs-writeback.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 56c048e22f72..93f8ea340247 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1090,7 +1090,8 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 {
 	struct backing_dev_info *bdi;
 	struct cgroup_subsys_state *memcg_css;
-	struct bdi_writeback *wb;
+	struct bdi_writeback *wb = NULL;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
 	struct wb_writeback_work *work;
 	unsigned long dirty;
 	int ret;
@@ -1114,7 +1115,11 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 	 * And find the associated wb.  If the wb isn't there already
 	 * there's nothing to flush, don't create one.
 	 */
-	wb = wb_get_lookup(bdi->wb_ctx[0], memcg_css);
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		wb = wb_get_lookup(bdi_wb_ctx, memcg_css);
+		if (wb)
+			break;
+	}
 	if (!wb) {
 		ret = -ENOENT;
 		goto out_css_put;
-- 
2.25.1


