Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13AD8E93804
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 22:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F8916B009B; Sun, 12 Apr 2026 18:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A8D06B009D; Sun, 12 Apr 2026 18:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BEF36B009E; Sun, 12 Apr 2026 18:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7BE6B009B
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 18:51:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EA529140BB0
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:51:12 +0000 (UTC)
X-FDA: 84651401184.09.CE3C989
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id A78B3160009
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 22:51:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SLW6p5Y2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776034270; a=rsa-sha256;
	cv=none;
	b=T1TONxi4NmnmKd/bUqXVzPT+44GOF0wleBycw+mWl5jEuF8dpME6OaM9p8zaBQRQPZFdQm
	FCLz3kl2vGZoMpy5R39y3MQTRykbo4OZnRhCISv/p+mZ4Fcit6oqydDq2oXU0PVQjG48To
	t002XqBZD4jwO1mYUiy32kEWq+Q8dp0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SLW6p5Y2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776034270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7PQCfO1LkfIlhF+m0/p+q9abrYZpC0b3LWn2Ob4o6U=;
	b=6c2gund91g1E+UvsUre9VDZ6po+kxB6OPmwGDBtzXW+pre7zIldAoBWUXtLvxfVXYw/TdO
	6Dhctjg+kXweXdHr8x48iTvAMD2FWobIxZl0uEeWpwrrdw6ApXk2oXNxpVCdwKiMe5fiVj
	Rw+tbJkwf3h/xzkGWufoxGpOcO40olY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776034270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r7PQCfO1LkfIlhF+m0/p+q9abrYZpC0b3LWn2Ob4o6U=;
	b=SLW6p5Y2yaAkK4/d7uq/UAf5XbXJOvRcs77hqhV4jzEQAG3oRHzBLz1cN23Dx9L57Q/4d+
	2NVZYam/MPxtMsxiAqTu2uURT+3aoftuQYZZl1wB1kyGo5ly8FYtqfH/Wkz0YLx6oO1Bsy
	XGkQscNNmNmSWAd4IHhLdPxQOQukSo0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-H9mCNwhVOu6Gl354TvZjOw-1; Sun, 12 Apr 2026 18:51:06 -0400
X-MC-Unique: H9mCNwhVOu6Gl354TvZjOw-1
X-Mimecast-MFC-AGG-ID: H9mCNwhVOu6Gl354TvZjOw_1776034266
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-488dcaf2f2fso8710545e9.0
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:51:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776034265; x=1776639065;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r7PQCfO1LkfIlhF+m0/p+q9abrYZpC0b3LWn2Ob4o6U=;
        b=D2Jfw1zlBmZoE+VUUI1sSrKoI/BHhGSZhkaecKfsT4aFj+JVipHjIv9DCsKTgOvxdQ
         VspORXlJ4VbcIDDVpY3FeI1hV/gJ8CpNc6m5eDb1eGsQ+j9B7892Y4rir78yFuX05K2z
         enpY/dPeepkINxK/C73CG+rbwa3VW4bN5zXg8Lgf5rRXAhgKqTFmA9hYO6xTVCKDSQbV
         6gYThK6Egd9E1KktSla+SnSrBkRsXJYXOAVleFNqciPC+SGBrPLEomS7vVsr1TYP0U55
         YFdM0uABZhhe0RpLbAN3Oo3uniuyePzwvJgeXTFZESVZYuL5cHQK1Ht4d8VKA3o6STVY
         a5xQ==
X-Forwarded-Encrypted: i=1; AJvYcCVs8li/0VugEx/TfQ7MALDvLSsbgA375uxrFV/gCRHbJz8gUH+RTaKaBiItxWl/aDsuax81KfO3WA==@kvack.org
X-Gm-Message-State: AOJu0Yym+M+ww4GGVVT99LOvroNDFKQzfeDbiMPqQeY9bYirBVW7A8/P
	W+HRhgzG5SIJkSLPZBDPSFc2WctqJ590aGFUe7r3JhAJi8CW8dvcKreqUek7+NbHysNlTlgkq4I
	RjnSsFgzsqRHsZgBfdXMb9bMfzferVZQ5sVOz+q3YVnJSsNsEcePG
X-Gm-Gg: AeBDiesNATJSxcFhRyyoAIgswv5Nn5XoRjKcGjQYcYswwFThBD7mwQFrhsKZnfIa0fe
	Ni6J3Je2Y0/ZEf2xK0s2sqna4ZZIN2/ZBhq6UweHdM2VBI/znAhokZ6qlbQrLE0cMypnXLi6XoW
	/gG6a12PelOcjmj6YfDevIEUr0mNhULbsRIuMgn63uEUyPrZuUFZVOJgUM4qiSVFLklSVGQs8uc
	k4K+J9ILVqqwrdUhLUZmSJBjO4Qj0ETd9IhTzMl9LYrDF6etQq9dN4OxyUajWQ5E7EfXwG4v2l0
	mAdDCAMumA7hnlfk3HEVCbOVcpSIxrVlULwDx6cBjbKVWsoi5IyCiaPk79NA1llLUwa0p33tcif
	bZLY6T5mt79SNARRVv97e3LVUZEOqiebDLnmmaq0ywOI=
X-Received: by 2002:a05:600c:8585:b0:488:9bf8:7f17 with SMTP id 5b1f17b1804b1-488d684bcb0mr113206645e9.14.1776034265502;
        Sun, 12 Apr 2026 15:51:05 -0700 (PDT)
X-Received: by 2002:a05:600c:8585:b0:488:9bf8:7f17 with SMTP id 5b1f17b1804b1-488d684bcb0mr113206465e9.14.1776034265017;
        Sun, 12 Apr 2026 15:51:05 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d6881ea1sm80171315e9.33.2026.04.12.15.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 15:51:04 -0700 (PDT)
Date: Sun, 12 Apr 2026 18:51:00 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH RFC 7/9] mm: hugetlb: skip zeroing of pre-zeroed hugetlb pages
Message-ID: <7d1c82bd0fe7f80212cb5ff7dafe24e1debca8f6.1776033771.git.mst@redhat.com>
References: <cover.1776033471.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776033471.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OWQ-YqEUxxfhMkH7ZkP9pYYnVeUq_VEcDIEBtS5qZOQ_1776034266
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: A78B3160009
X-Stat-Signature: fb9paitg1zsi13hgwy8augj97pfo8hoj
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776034270-24502
X-HE-Meta: U2FsdGVkX1/Wi7GyCOJcC8zkb9uWymWUPem+01si4Z4uNSDc9a+bCk0U78yl37I7+iKYyOeSBMU8npSnqQG97ftiEVtkXMwB9Rt9RUhtZpUtFB49o9gp4JngebgAy81XhYzEog5W/59TfWBCMlL/Ze1nWo3x3IbwCvy8g1gWGZBiXBV3LmoMgL0/S7LXhENlVlBBEIvf9r8ZTCAvtlZXrzZzqP2IJt6B6SXbOiDb9xsnGtoF44QpIKQeUiDlniKo6FhaDCaN/fHfguoaRkgDUFUUWhNX7CpbCsyRQ6CkB44KCLcQT5lbg9a+lQnS1Foe5w54CDhkpX+mYQGxcWBxwAtR8pXNfXqlIeqT2QMMHtAvBOFeuFryetz/i/obyOGSNr7nZk55HiyH9hbHy40u6RQKhfRAoyUOni66S2bPN9Uahiy3HDfOItEWhgiOPFYnz1Jtnyy8gJH7mC4gpbvy1Igy2klH7p8ZL0OxVa6Bua0dyXUP7Xy+1ZVMDw2u7JAPn+eqtWPfMJur0MaG/tjQeOX8ve3JLAvGk+M7jkWNGZi+W2xU0G6undRsBEhG0N4bBva5RtlRVWP674TPTcytIA2lIMyJe6xH8oSEk0+qx3VwsBD9qj87fIeNM0I26DhO78lzshx5WrL8DzO0Y49BH0p9N0lwNDknd1NvGDGz7PgotYulKzrMqockRB4kjqEve0LXaB2nxIGGj3+s8hZPFNsjg0exOFOlTsVkaCslcZ5JLpUrenG4nq4nNwwCoz7xOB5eFfTVkIOIud/Da/sR4OqK2ripU0ctmJFNSBSQEX2E3bVsbzYJkPZcSlLpeXN+HxAakT4iZ+m8ePp08ee2MKbYrtuTp9PWUNGTZNHzlfcqxHdtPvWnMcDx3Gm7yZ1VANfFdq0NLj4l/m2cf7NqB8MzXSCQ/ExlegLbxzRdgiy30Q+Q26Vvuc00YmMZf2vTY/ofo76ewcHYxU6EucO
 O394LX95
 hWh6PXBQKsdLfcfMGddwAJvGcFj0YGaDAzqOFN9/4APLhUGrigtrsVnioiXlnVtZt0GZ3qZIhGi0j5dUZtRuuRFNXprSYvuj/PzQh1SMwZI5x+8plSeOgGKMHaBzCXVWAI1kOh2f6W59s1hHHHLw9bdRxuZQkjKZwYLXMPS+vPfovdVg1FOhBRwgUyGrn25Ph1jvP2mMA959n3ejqfhAcbuS4Rs/tWFLcs9WE247e1BWIwBDaPzH7rmRVpDMdpTvLETbXG0CS3Lt2uNSPKC/EbbhWMYwT5coDztj3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a surplus hugetlb page is allocated from the buddy allocator
and the page was previously reported to the host (and zeroed on
reclaim), skip the redundant folio_zero_user() in the hugetlb
fault path.

This only benefits surplus hugetlb pages that are freshly allocated
from the buddy.  Pages from the persistent hugetlb pool are not
affected since they are not allocated from buddy at fault time.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 fs/hugetlbfs/inode.c    | 3 ++-
 include/linux/hugetlb.h | 2 +-
 mm/hugetlb.c            | 3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3f70c47981de..301567ad160f 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -828,7 +828,8 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 			error = PTR_ERR(folio);
 			goto out;
 		}
-		folio_zero_user(folio, addr);
+		if (!folio_test_clear_prezeroed(folio))
+			folio_zero_user(folio, addr);
 		__folio_mark_uptodate(folio);
 		error = hugetlb_add_to_page_cache(folio, mapping, index);
 		if (unlikely(error)) {
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 65910437be1c..07e3ef8c0418 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -937,7 +937,7 @@ static inline bool hugepage_movable_supported(struct hstate *h)
 /* Movability of hugepages depends on migration support. */
 static inline gfp_t htlb_alloc_mask(struct hstate *h)
 {
-	gfp_t gfp = __GFP_COMP | __GFP_NOWARN;
+	gfp_t gfp = __GFP_COMP | __GFP_NOWARN | __GFP_PREZEROED;
 
 	gfp |= hugepage_movable_supported(h) ? GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0beb6e22bc26..5b23b006c37c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5809,7 +5809,8 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 				ret = 0;
 			goto out;
 		}
-		folio_zero_user(folio, vmf->real_address);
+		if (!folio_test_clear_prezeroed(folio))
+			folio_zero_user(folio, vmf->real_address);
 		__folio_mark_uptodate(folio);
 		new_folio = true;
 
-- 
MST


