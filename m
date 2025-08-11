Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE36CA0EC1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 14:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 423318E0063; Mon, 11 Aug 2025 10:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D2E28E005F; Mon, 11 Aug 2025 10:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 274A88E0063; Mon, 11 Aug 2025 10:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 122AD8E005F
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:40:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8CACC01C2
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:40:04 +0000 (UTC)
X-FDA: 83764736328.22.4EB2ECE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id BF30F80009
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:40:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MC84uJb8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754923202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K9pQ6cfOAd6CYMjiXktr++2RllUSiQ1vZU8nA2VfkG0=;
	b=jIemqkGofplZVCtJeIYvWB5zRfB1RurKBNayk1wcplqprnDJZFGvWPNhUQdpzGPZHk33EK
	/0Dc8bUShFR2FN/QEvO42fKZbDwMAnKea69uMSJIfnPB086M3ojuMFISw/KHOr2Zap0oLp
	k7kNdTs5hQ7A9+aJ2DifWOFja3+RLiY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754923202; a=rsa-sha256;
	cv=none;
	b=LHtIbACr0RVyZUomuOLOB2AGCuRdaWif5dDCjthED1RAWk6hb9aG8WouXCEakwOEFfRuAv
	iaIyffArL5kotJJOiIG4SCCZGsLDdZg2HP+TmPTjF/36itDsisHvtGgg+jTcre4/j52202
	kA3RiZnQG+tlPaSkOOxqFYgVoZ8fTmI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MC84uJb8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754923202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K9pQ6cfOAd6CYMjiXktr++2RllUSiQ1vZU8nA2VfkG0=;
	b=MC84uJb8smzXNAVXs6BCQKezHIhHtawMJa2Hjl5yo9xr7D7uXrZH58sU3UWTX5cVZCKmw9
	mVgmpAser0Cz/XJFGqn23Y9S6Xn8r/UPRnQ3RzHF4soTAqVAGPMiS+EiXop62H6DIXnL64
	FKmulliBEmcWPFmuBFgTePRjZIoLxls=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-lZ3-2qJPM5GoDP8fgiBSag-1; Mon, 11 Aug 2025 10:39:58 -0400
X-MC-Unique: lZ3-2qJPM5GoDP8fgiBSag-1
X-Mimecast-MFC-AGG-ID: lZ3-2qJPM5GoDP8fgiBSag_1754923198
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-459d5f50a07so25883715e9.3
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:39:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754923197; x=1755527997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K9pQ6cfOAd6CYMjiXktr++2RllUSiQ1vZU8nA2VfkG0=;
        b=mZOxQKpnbhyMwVD6Fr7fNnfV6DSDQuPvqQBYBR6FhgjwX8nRXlPPV4GLlZrAkYfQEn
         3mQ1bxNxp313RPke43Xq3JzdRsN5r/CvP+5L0RUMKULOHE1Uzm+x5t+lxqib5kHE8JP3
         AKt6Oxmg9UAGojgT9mokFZVDt+Zl7OhyhmfQ/P9Tq6GO4v3SM1NunEgh6n+/wEd4bfWB
         qqn1mLwrdpkTlZ66tsT6o+sYP37y4AUz0AkVGJNkoz4PFsWJd5cfuymwwRDYt4kwBuIe
         xZfy1e4tJHhiJKskFVJO+doP3B1mDhfsuzGRSzQenJ9LVEpzEvpjK07fHSJn7Acy8bgz
         C+Lg==
X-Gm-Message-State: AOJu0Yy3Ey+W0upN+K4FdxalA8CFpnmdhj7xto1JNjNNpoV3xroUGPdP
	MS4fieXDqAhjH9qF5cHkMTFVwUFfYbd1zs9oA+l6nTHiiop1VapJxc9HovqpZPoMbX+EDxSnYm/
	8IOG6jvwBwXsPNIvzitwcN583ux5tzRHhKZTZr7SKxl0pRrmZfjDo
X-Gm-Gg: ASbGnctl7+eB8gyFqUGlrD2Cxg1/R28DCnZmXMm8m2EHpjm9NmzqJMjVoAB7CjGzfe1
	bdh081hihYlpuonBiGskzzZcTarj6mrqtgXoKeIE4XQSqL83ZWXB8vDeHfJB2l8ZrCl4BvZg7Tz
	rSF3jxv0uozsBaEXYUW3RJALoR8NJFpKLxuy9RwCHZkPxW1f6RxXoWYCINPRc3GCI8VrmHjjeCP
	0ExZbNIgquS3QObjFQWjh5vEdRPyWCU7o/oEz3KqBeFHMbaW9IHcGAXggnjQlhlSmiYnHFlXP5q
	qC44eDEeckpygY2bpwZ6N/AcuWkaUjr+mIH8QvhtmNGhn61Vl166TpCpDxe67IaxgQfd12RVP+k
	KOD2DqiucgVBkfpmAmtR3mojO
X-Received: by 2002:a05:600c:190c:b0:43c:ec4c:25b4 with SMTP id 5b1f17b1804b1-459f4f5292fmr128225255e9.10.1754923197466;
        Mon, 11 Aug 2025 07:39:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHeJPd1Ge6IawGRqjGvoUIijF7grEq/r+WrWgIGNnqFvFWWeyhF+SV2vqhPS2/Wm5uHjhsRGA==
X-Received: by 2002:a05:600c:190c:b0:43c:ec4c:25b4 with SMTP id 5b1f17b1804b1-459f4f5292fmr128224855e9.10.1754923196896;
        Mon, 11 Aug 2025 07:39:56 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-459e5868fd7sm275562255e9.18.2025.08.11.07.39.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 07:39:56 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	virtualization@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-aio@kvack.org,
	linux-btrfs@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v1 2/2] treewide: remove MIGRATEPAGE_SUCCESS
Date: Mon, 11 Aug 2025 16:39:48 +0200
Message-ID: <20250811143949.1117439-3-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811143949.1117439-1-david@redhat.com>
References: <20250811143949.1117439-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Jgn5a31f_wjn-7kp2PUyN2o3COPfj_hYBDVBikivjaY_1754923198
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 5k45r66b3s9j1gana53wmxsxjcwd8ck9
X-Rspamd-Queue-Id: BF30F80009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754923202-402
X-HE-Meta: U2FsdGVkX193gZNmhQntEI0bdiy3l7Ebom+t/ejxXCBUM158PVqrNeEVDZamYOpihbLYRtGHjKqEGpXAfK8ZP+m0eTD2yXBWZfG2Z0TuEKLR+wbTMM0xorjSbrgYo0xEe7vzST9Fl38ViP7Dg2W/+udo4JJbke6BdARWZ3g8WM6dlWbcnWN4dwlKrOlRO5+l4b/x6vLaqeQaApQsFWxPMeE1k4MRgNU2puX5k2EjufZ/N5Y5FLoB33qXxyeJ4mdfiLxOkovpIcxfpXN8xeXUoYjecgkKqGG3bCEwKV+5UhSe8YvHVeSavp9Ff3C4mFcJa3BPCTMGx1sfhYNazchHwICPYCJVf9SMW+qlOqPPaHfR7mCbVxv9Cc81HLaIBYRpEaAFZAikv+CKgU1GcvxUgqyR+j6mFLEF+Byd/69SMeLVjxRrtOeoizfjgWuQcXvmDpGuoMGEtpx2V4hxegktNiVOBrPoCUcJF1XFqzBEUv3THEvX9arbhCvOsiKILs+jDU6ZqEMSNT1X3ufPUufKgTakVuIopqLQ2LfBBjOUNaYhdJIicbl/Ox869ZKb4oFDyWqmOPnnn3irX9Ca5gchIpMeJ7Il6T3vAsnxjihT8xyq5e9jxGiQHwtK20xXbTZE5uP9CH7f5gU5iDcuBLy4+SxheohMMCamOOIakmYT4BZDu2ZhcDO4sxFluUu4aZ0wtKXai6T03WK4955ODPN9Xhd0GYeQHjZzNhdadnmXddBH3qfi4+UwZx78qHSqrz7bFxECIKvs6KITCtk7XpgsCKpJbkpPCQSZIXI5VvWh/8X9M9tBid8/vxF+5QZlOX9Zcp8oG28skC16xHHzzYwNechO+4FzN25dp01//jDKT6RIQ+3lZ5RZp8bgklfi1ziQK16B6QZwBncndEV5/tlWs8WRUq7WbhVmGr5Vw2+OURWeucPZCfJFzr+/3KB8HlAES9hThACPMZQ9V5fOlog
 qqEaSP9L
 6bNMaFU2QVp1kg6LHCSX13Fs5oji/Ncm2M5hpfMe0iS3gzbRQcCMRSh++1TKwjfxPQruoS4RodVEAJ6xgJ5GScmpUl0e1Hj5onMllo+0+L4UmYTY6CrfmKWE/SfyweLHZ0LJLDoWqaur8ZzIB1lnI/5yIqNzmtV+ZKyJQdIL41b38LVRd4k9NKxb0XQ0z7mceq+Af2EebhIJ3WXEqMho9tN1aD2kX2ThiPe6vxiW2w6GmsG7ZW+0yPEBYoq7qdrFb+RGS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At this point MIGRATEPAGE_SUCCESS is misnamed for all folio users,
and now that we remove MIGRATEPAGE_UNMAP, it's really the only "success"
return value that the code uses and expects.

Let's just get rid of MIGRATEPAGE_SUCCESS completely and just use "0"
for success.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/powerpc/platforms/pseries/cmm.c |  2 +-
 drivers/misc/vmw_balloon.c           |  4 +--
 drivers/virtio/virtio_balloon.c      |  2 +-
 fs/aio.c                             |  2 +-
 fs/btrfs/inode.c                     |  4 +--
 fs/hugetlbfs/inode.c                 |  4 +--
 fs/jfs/jfs_metapage.c                |  8 +++---
 include/linux/migrate.h              | 10 +------
 mm/migrate.c                         | 40 +++++++++++++---------------
 mm/migrate_device.c                  |  2 +-
 mm/zsmalloc.c                        |  4 +--
 11 files changed, 36 insertions(+), 46 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
index 5e0a718d1be7b..0823fa2da1516 100644
--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -545,7 +545,7 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
 	/* balloon page list reference */
 	put_page(page);
 
-	return MIGRATEPAGE_SUCCESS;
+	return 0;
 }
 
 static void cmm_balloon_compaction_init(void)
diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 6653fc53c951c..6df51ee8db621 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -1806,7 +1806,7 @@ static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
 		 * the list after acquiring the lock.
 		 */
 		get_page(newpage);
-		ret = MIGRATEPAGE_SUCCESS;
+		ret = 0;
 	}
 
 	/* Update the balloon list under the @pages_lock */
@@ -1817,7 +1817,7 @@ static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
 	 * If we succeed just insert it to the list and update the statistics
 	 * under the lock.
 	 */
-	if (ret == MIGRATEPAGE_SUCCESS) {
+	if (!ret) {
 		balloon_page_insert(&b->b_dev_info, newpage);
 		__count_vm_event(BALLOON_MIGRATE);
 	}
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index e299e18346a30..eae65136cdfb5 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -875,7 +875,7 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
 	balloon_page_finalize(page);
 	put_page(page); /* balloon reference */
 
-	return MIGRATEPAGE_SUCCESS;
+	return 0;
 }
 #endif /* CONFIG_BALLOON_COMPACTION */
 
diff --git a/fs/aio.c b/fs/aio.c
index 7fc7b6221312c..059e03cfa088c 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -445,7 +445,7 @@ static int aio_migrate_folio(struct address_space *mapping, struct folio *dst,
 	folio_get(dst);
 
 	rc = folio_migrate_mapping(mapping, dst, src, 1);
-	if (rc != MIGRATEPAGE_SUCCESS) {
+	if (rc) {
 		folio_put(dst);
 		goto out_unlock;
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b77dd22b8cdbe..1d64fee6f59e6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7411,7 +7411,7 @@ static int btrfs_migrate_folio(struct address_space *mapping,
 {
 	int ret = filemap_migrate_folio(mapping, dst, src, mode);
 
-	if (ret != MIGRATEPAGE_SUCCESS)
+	if (ret)
 		return ret;
 
 	if (folio_test_ordered(src)) {
@@ -7419,7 +7419,7 @@ static int btrfs_migrate_folio(struct address_space *mapping,
 		folio_set_ordered(dst);
 	}
 
-	return MIGRATEPAGE_SUCCESS;
+	return 0;
 }
 #else
 #define btrfs_migrate_folio NULL
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 09d4baef29cf9..34d496a2b7de6 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1052,7 +1052,7 @@ static int hugetlbfs_migrate_folio(struct address_space *mapping,
 	int rc;
 
 	rc = migrate_huge_page_move_mapping(mapping, dst, src);
-	if (rc != MIGRATEPAGE_SUCCESS)
+	if (rc)
 		return rc;
 
 	if (hugetlb_folio_subpool(src)) {
@@ -1063,7 +1063,7 @@ static int hugetlbfs_migrate_folio(struct address_space *mapping,
 
 	folio_migrate_flags(dst, src);
 
-	return MIGRATEPAGE_SUCCESS;
+	return 0;
 }
 #else
 #define hugetlbfs_migrate_folio NULL
diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index b98cf3bb6c1fe..871cf4fb36366 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -169,7 +169,7 @@ static int __metapage_migrate_folio(struct address_space *mapping,
 	}
 
 	rc = filemap_migrate_folio(mapping, dst, src, mode);
-	if (rc != MIGRATEPAGE_SUCCESS)
+	if (rc)
 		return rc;
 
 	for (i = 0; i < MPS_PER_PAGE; i++) {
@@ -199,7 +199,7 @@ static int __metapage_migrate_folio(struct address_space *mapping,
 		}
 	}
 
-	return MIGRATEPAGE_SUCCESS;
+	return 0;
 }
 #endif	/* CONFIG_MIGRATION */
 
@@ -242,7 +242,7 @@ static int __metapage_migrate_folio(struct address_space *mapping,
 		return -EAGAIN;
 
 	rc = filemap_migrate_folio(mapping, dst, src, mode);
-	if (rc != MIGRATEPAGE_SUCCESS)
+	if (rc)
 		return rc;
 
 	if (unlikely(insert_metapage(dst, mp)))
@@ -253,7 +253,7 @@ static int __metapage_migrate_folio(struct address_space *mapping,
 	mp->folio = dst;
 	remove_metapage(src, mp);
 
-	return MIGRATEPAGE_SUCCESS;
+	return 0;
 }
 #endif	/* CONFIG_MIGRATION */
 
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 40f2b5a37efbb..02f11704fb686 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -12,13 +12,6 @@ typedef void free_folio_t(struct folio *folio, unsigned long private);
 
 struct migration_target_control;
 
-/*
- * Return values from addresss_space_operations.migratepage():
- * - negative errno on page migration failure;
- * - zero on page migration success;
- */
-#define MIGRATEPAGE_SUCCESS		0
-
 /**
  * struct movable_operations - Driver page migration
  * @isolate_page:
@@ -34,8 +27,7 @@ struct migration_target_control;
  * @src page.  The driver should copy the contents of the
  * @src page to the @dst page and set up the fields of @dst page.
  * Both pages are locked.
- * If page migration is successful, the driver should
- * return MIGRATEPAGE_SUCCESS.
+ * If page migration is successful, the driver should return 0.
  * If the driver cannot migrate the page at the moment, it can return
  * -EAGAIN.  The VM interprets this as a temporary migration failure and
  * will retry it later.  Any other error value is a permanent migration
diff --git a/mm/migrate.c b/mm/migrate.c
index e9dacf1028dc7..2db4974178e6a 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -209,18 +209,17 @@ static void putback_movable_ops_page(struct page *page)
  * src and dst are also released by migration core. These pages will not be
  * folios in the future, so that must be reworked.
  *
- * Returns MIGRATEPAGE_SUCCESS on success, otherwise a negative error
- * code.
+ * Returns 0 on success, otherwise a negative error code.
  */
 static int migrate_movable_ops_page(struct page *dst, struct page *src,
 		enum migrate_mode mode)
 {
-	int rc = MIGRATEPAGE_SUCCESS;
+	int rc;
 
 	VM_WARN_ON_ONCE_PAGE(!page_has_movable_ops(src), src);
 	VM_WARN_ON_ONCE_PAGE(!PageMovableOpsIsolated(src), src);
 	rc = page_movable_ops(src)->migrate_page(dst, src, mode);
-	if (rc == MIGRATEPAGE_SUCCESS)
+	if (!rc)
 		ClearPageMovableOpsIsolated(src);
 	return rc;
 }
@@ -565,7 +564,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 		if (folio_test_swapbacked(folio))
 			__folio_set_swapbacked(newfolio);
 
-		return MIGRATEPAGE_SUCCESS;
+		return 0;
 	}
 
 	oldzone = folio_zone(folio);
@@ -666,7 +665,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 	}
 	local_irq_enable();
 
-	return MIGRATEPAGE_SUCCESS;
+	return 0;
 }
 
 int folio_migrate_mapping(struct address_space *mapping,
@@ -715,7 +714,7 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
 
 	xas_unlock_irq(&xas);
 
-	return MIGRATEPAGE_SUCCESS;
+	return 0;
 }
 
 /*
@@ -831,14 +830,14 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
 		return rc;
 
 	rc = __folio_migrate_mapping(mapping, dst, src, expected_count);
-	if (rc != MIGRATEPAGE_SUCCESS)
+	if (rc)
 		return rc;
 
 	if (src_private)
 		folio_attach_private(dst, folio_detach_private(src));
 
 	folio_migrate_flags(dst, src);
-	return MIGRATEPAGE_SUCCESS;
+	return 0;
 }
 
 /**
@@ -945,7 +944,7 @@ static int __buffer_migrate_folio(struct address_space *mapping,
 	}
 
 	rc = filemap_migrate_folio(mapping, dst, src, mode);
-	if (rc != MIGRATEPAGE_SUCCESS)
+	if (rc)
 		goto unlock_buffers;
 
 	bh = head;
@@ -1049,7 +1048,7 @@ static int fallback_migrate_folio(struct address_space *mapping,
  *
  * Return value:
  *   < 0 - error code
- *  MIGRATEPAGE_SUCCESS - success
+ *     0 - success
  */
 static int move_to_new_folio(struct folio *dst, struct folio *src,
 				enum migrate_mode mode)
@@ -1077,7 +1076,7 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 	else
 		rc = fallback_migrate_folio(mapping, dst, src, mode);
 
-	if (rc == MIGRATEPAGE_SUCCESS) {
+	if (!rc) {
 		/*
 		 * For pagecache folios, src->mapping must be cleared before src
 		 * is freed. Anonymous folios must stay anonymous until freed.
@@ -1427,7 +1426,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 	if (folio_ref_count(src) == 1) {
 		/* page was freed from under us. So we are done. */
 		folio_putback_hugetlb(src);
-		return MIGRATEPAGE_SUCCESS;
+		return 0;
 	}
 
 	dst = get_new_folio(src, private);
@@ -1490,8 +1489,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 		rc = move_to_new_folio(dst, src, mode);
 
 	if (page_was_mapped)
-		remove_migration_ptes(src,
-			rc == MIGRATEPAGE_SUCCESS ? dst : src, 0);
+		remove_migration_ptes(src, !rc ? dst : src, 0);
 
 unlock_put_anon:
 	folio_unlock(dst);
@@ -1500,7 +1498,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 	if (anon_vma)
 		put_anon_vma(anon_vma);
 
-	if (rc == MIGRATEPAGE_SUCCESS) {
+	if (!rc) {
 		move_hugetlb_state(src, dst, reason);
 		put_new_folio = NULL;
 	}
@@ -1508,7 +1506,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 out_unlock:
 	folio_unlock(src);
 out:
-	if (rc == MIGRATEPAGE_SUCCESS)
+	if (!rc)
 		folio_putback_hugetlb(src);
 	else if (rc != -EAGAIN)
 		list_move_tail(&src->lru, ret);
@@ -1618,7 +1616,7 @@ static int migrate_hugetlbs(struct list_head *from, new_folio_t get_new_folio,
 						      reason, ret_folios);
 			/*
 			 * The rules are:
-			 *	Success: hugetlb folio will be put back
+			 *	0: hugetlb folio will be put back
 			 *	-EAGAIN: stay on the from list
 			 *	-ENOMEM: stay on the from list
 			 *	Other errno: put on ret_folios list
@@ -1635,7 +1633,7 @@ static int migrate_hugetlbs(struct list_head *from, new_folio_t get_new_folio,
 				retry++;
 				nr_retry_pages += nr_pages;
 				break;
-			case MIGRATEPAGE_SUCCESS:
+			case 0:
 				stats->nr_succeeded += nr_pages;
 				break;
 			default:
@@ -1689,7 +1687,7 @@ static void migrate_folios_move(struct list_head *src_folios,
 				reason, ret_folios);
 		/*
 		 * The rules are:
-		 *	Success: folio will be freed
+		 *	0: folio will be freed
 		 *	-EAGAIN: stay on the unmap_folios list
 		 *	Other errno: put on ret_folios list
 		 */
@@ -1699,7 +1697,7 @@ static void migrate_folios_move(struct list_head *src_folios,
 			*thp_retry += is_thp;
 			*nr_retry_pages += nr_pages;
 			break;
-		case MIGRATEPAGE_SUCCESS:
+		case 0:
 			stats->nr_succeeded += nr_pages;
 			stats->nr_thp_succeeded += is_thp;
 			break;
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index e05e14d6eacdb..abd9f6850db65 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -778,7 +778,7 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 		if (migrate && migrate->fault_page == page)
 			extra_cnt = 1;
 		r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
-		if (r != MIGRATEPAGE_SUCCESS)
+		if (r)
 			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 		else
 			folio_migrate_flags(newfolio, folio);
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 2c5e56a653544..84eb91d47a226 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1746,7 +1746,7 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
 	 * instead.
 	 */
 	if (!zpdesc->zspage)
-		return MIGRATEPAGE_SUCCESS;
+		return 0;
 
 	/* The page is locked, so this pointer must remain valid */
 	zspage = get_zspage(zpdesc);
@@ -1813,7 +1813,7 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
 	reset_zpdesc(zpdesc);
 	zpdesc_put(zpdesc);
 
-	return MIGRATEPAGE_SUCCESS;
+	return 0;
 }
 
 static void zs_page_putback(struct page *page)
-- 
2.50.1


