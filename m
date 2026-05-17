Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D04FCD4F4A
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 17:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A94676B0005; Sun, 17 May 2026 13:59:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A45126B0088; Sun, 17 May 2026 13:59:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95B586B008C; Sun, 17 May 2026 13:59:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 80D036B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:59:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2D18E4065C
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:59:21 +0000 (UTC)
X-FDA: 84777673722.02.12F2BA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8288F40009
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:59:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iVFvnMWT;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779040759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Cs3dzoHQUj33veDb9qtnB8y4AHgcnd6/+g8vQ9616eY=;
	b=urywMk1SlDEtG17Ttl6VgeBU8xQMSN7VqSyzypEBqqJc21Tx2eC2gfS67B1vCw7jOTxzCb
	mV0aiB9bpxutpUklSmixhh2FSUeMbaQ45Cba1AkwQh560l3F58l8NDH10QSuCxYwebEuva
	LBxDVKVml6IFvOPGxT/EydGfIEooeX0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iVFvnMWT;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779040759; a=rsa-sha256;
	cv=none;
	b=Q3zx1N9RFflcKi4974ZsW7TkPAVxrTEzWNphYv1WZXcktKWfl2RWFUisZZVI1Wx+OreAXu
	xOGLGxHDKa26X9Dia8zmVuq3jlMbD1+JxBvdim2pWPJE8tVY+RePZ3S1NBVbTglaTBMiur
	NVDNyvDQtteRecfYqpaZMebm1nrKPaw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BE6A445BF;
	Sun, 17 May 2026 17:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3004BC2BCC6;
	Sun, 17 May 2026 17:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779040758;
	bh=9oeAOM3C3JyLTWhy1VBvlaGvxy8pkJWaNVHEz9VMkTM=;
	h=From:To:Cc:Subject:Date:From;
	b=iVFvnMWTyqqjm79NBQpe7V4oI06vsZGTDzY7tpd9W7zIPiaryq9eo59WDqrHXIYZe
	 fOsQLG1lXTSIRX0IjraqXSbRAfnAZfF8xDJ5A2xaUFGakSTwysu9RUzmkwW+6oGd7M
	 ByIiZXCVC20FsfKH0YWVg8zeMst/q/aPqahPxvSpO+eBINm4fyA52cfrnrTjJygumH
	 E800lzDMC3dsnouqtEFmCVVlLuZefkiZNHIdIRoB3/TperCfQUxLBIVhUdTUqQc0gB
	 TXYPY7mhgXindqbA5v1FyDSB0o+u03KNUcT+ZS104wTiaRCq6xft0PUBWGc81BtQCq
	 ajvu0jOT4DWWA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 2 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1] mm/damon/sysfs-schemes: delete tried region in regions_rmdirs()
Date: Sun, 17 May 2026 10:59:13 -0700
Message-ID: <20260517175915.3352-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8288F40009
X-Stat-Signature: 9w14w1b8nfrxx67iaobcjpmg3itcqgjq
X-HE-Tag: 1779040759-834854
X-HE-Meta: U2FsdGVkX1+B4TdpS1zF73FgwAVHEVAUXJ0PJZxtDGc9iTXcB+BxaMRVJEntWx68P9wMg9zQ1Zqp9qqHsfk4MFow+ojsZLUVIQ/Wpa13xUEhiLv06awxtBm8i/NOdIYulKqg8C94D7xyeQWoq0iW7TLOUrAgbhw7jlqcw6IF2juiFb0IYobIWpEDLG9KE/QlrY9ikLvWdt3WGxmvzhc4wf3VRUi9TJqp8X/3KRFE/Nl3W/TQJbxB0h9rVtBEdj2Ab/yG7PqL5Yn6KZIzqUwWMBxb1TrkaeLWzhoHqEWnlsIqudrRO6UtUA0RQwVyFhOySke6tSiovQG44U/NGPWeAvIom8m2PF0k3j3M1oBrjSIk4EWXhWZ1Gc5nBSVdJydYdFg0SNt5NtGjo7P7X608ZMzITB+VXPw/JWSSN5/k267aRxUIhqm6tMmrTWvRUDU3eH8EGf7XM/zWDhfrtaz1mhsk9WkyPhkNGqpz/7DNa75oG5W9+kkuBq/Zciqq99n2XunO0BgVn204EmDtwqUJBFa2q81RRf/jfjQItRlP/5n+fBWX6te7+sml7hyQcbbiy93nTEfdQUxVWKMdttXrZqjlr9CDWu2n3RahGr8k3Mq0fD+cxQFWkY4Tn/I4RPtdx0/JJX1BDO03rwVzpXNkfNRm0dVKhgLlSqzfxDSaUrcoxQ2MPskhUQpLp2hHAn6MChqgef2yNmVQF7kXkcPvxvdJmVNr0so2yafvWBKyCv6EYxie8+pT5KzkaE78YH8HsTlzIEGv79QHfPN4W6hajSS3ChRkTxrwqq7gJKc1hlpmRQvBiTC9Ra4hgn+1c2Dq1Zk0I1SFelefVS0t3HkJZJ/asQCrcBi+EkR/zY+8bs21HX1Vk40bJSw9i2LMosNLw1fxOr+mpNrhH3q4hofyhbM3jjMwnRZyr3hq4sv4rCqVXUzLJXvOfiNj2pJ9G8uNS/u3YUnU7gvXJUaRbno
 O2eNIRCY
 XbkVZacK4oLIrXyYppYVzlPnmrgJeGQeM/tFiAaTHIWnu9OSNMAIZkT/kbzLLPeP7TQdi5Bg1sW0rQE9G+IjhNdpKa6eC5thh2xFupWJrMAFcPYUrTmcA6y6Q+Hj7FvikVZT3JZJZekWUfr5Nb0IBMbZTpX63mMu4S7vsFGD2o6hiqt6e662uvs4w8lz4oqjUHNWoRvcPnbHlFEwFGTy/U36zebJ9QdU/npuuDheOQhnxCAR6EKvhbY8r2rfNoQuB8lL7WGHfRX6M/t5x8iKel3l8O71eyn3ahwBMFOUdJUWh1/s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs maintains the DAMOS tried region directory objects via a
linked list.  When the user requests refresh of the directories, DAMON
sysfs removes all the region directories first, and then generate
updated regions directory on the empty space.  The removal function
(damon_sysfs_scheme_regions_rm_dirs()) only puts the kobj objects.
Deletion of the container region object from the linked list is done
inside the kobj release callback function.

If somehow the callback invocation is delayed, the list will contain
regions list that gonna be freed.  If the updated region directories
creation is started in this situation, the list can be corrupted and
use-after-free can happen.

Because the kobj objects are managed by only DAMON sysfs, the issue
cannot happen in normal situation.  But, such delays can be made on
kernels that built with CONFIG_DEBUG_KOBJECT_RELEASE.  On the kernel,
the issue can indeed be reproduced like below.

    # damo start --damos_action stat
    # cd /sys/kernel/mm/damon/admin/kdamonds/0/
    # for i in {1..10}; do echo update_schemes_tried_regions > state; done
    # dmesg | grep underflow
    [   89.296152] refcount_t: underflow; use-after-free.

Fix the issue by removing the region object from the list when
decrementing the reference count.

Also update damos_sysfs_populate_region_dir() to add the region object
to the list only after the kobject_init_and_add() is success, so that
fail of kobject_init_and_add() is not leaving the deallocated object on
the list.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260513011920.119183-1-sj@kernel.org

Fixes: 9277d0367ba1 ("mm/damon/sysfs-schemes: implement scheme region directory")
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from RFC v2
- RFC v2: https://lore.kernel.org/20260517172624.888-1-sj@kernel.org
- Rebase to mm-stable (7.1-rc3) for Sashiko review.
Changes from RFC
- RFC: https://lore.kernel.org/20260516211436.1883-1-sj@kernel.org
- Add region to the list after kobject_init_and_add() success.

 mm/damon/sysfs-schemes.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 245d63808411a..a2ebc752d9332 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -88,7 +88,6 @@ static void damon_sysfs_scheme_region_release(struct kobject *kobj)
 	struct damon_sysfs_scheme_region *region = container_of(kobj,
 			struct damon_sysfs_scheme_region, kobj);
 
-	list_del(&region->list);
 	kfree(region);
 }
 
@@ -164,7 +163,7 @@ static void damon_sysfs_scheme_regions_rm_dirs(
 	struct damon_sysfs_scheme_region *r, *next;
 
 	list_for_each_entry_safe(r, next, &regions->regions_list, list) {
-		/* release function deletes it from the list */
+		list_del(&r->list);
 		kobject_put(&r->kobj);
 		regions->nr_regions--;
 	}
@@ -2926,15 +2925,16 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 	region = damon_sysfs_scheme_region_alloc(r);
 	if (!region)
 		return;
-	region->sz_filter_passed = sz_filter_passed;
-	list_add_tail(&region->list, &sysfs_regions->regions_list);
-	sysfs_regions->nr_regions++;
 	if (kobject_init_and_add(&region->kobj,
 				&damon_sysfs_scheme_region_ktype,
 				&sysfs_regions->kobj, "%d",
 				sysfs_regions->nr_regions++)) {
 		kobject_put(&region->kobj);
+		return;
 	}
+	region->sz_filter_passed = sz_filter_passed;
+	list_add_tail(&region->list, &sysfs_regions->regions_list);
+	sysfs_regions->nr_regions++;
 }
 
 int damon_sysfs_schemes_clear_regions(

base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
2.47.3

