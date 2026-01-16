Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE38C982FE
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 20:40:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0B06B008A; Fri, 16 Jan 2026 15:40:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 787E36B008C; Fri, 16 Jan 2026 15:40:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69E946B0092; Fri, 16 Jan 2026 15:40:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53DC76B008A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:40:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A68D579F4
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:40:41 +0000 (UTC)
X-FDA: 84338995482.09.951CFB4
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6263E180004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:40:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EhWlUol6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768596039; a=rsa-sha256;
	cv=none;
	b=W/jOtcQWhPTSMtpzP8lVfWBAqvSINFtmZjlfblgZH2gTyBmn+9UE7HcnHvvKhawBr0ntmV
	TlkdRVHJ01ahrL3thLC+TbJwZLuuvK4UajBcFgK12lJAK/4ISTxq1OK2xwH3xmvlrfbtaw
	RxorKNmn305jsS3oxKMNr+A16c6kQZs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EhWlUol6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768596039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=plLru19BPw4Gzl5/9w7riKopb0P86akIwhjnuskNV1s=;
	b=muYny7VuKsK7OqGxVqKouWidLEJl2Nz6CuaBBT4qDuBHLpPSjOoyjVkdUy+vBsfkeOzXPh
	KVFTVwRVruRm1wgytxoGO53cqNINUvZO7fQFQeES6XEraz0GBMPuXC2+rd6McgQuUl48MX
	lWhJrJqx/HeS3h5fYD86svNV+FGTFO4=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-78fba1a1b1eso39839157b3.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768596038; x=1769200838; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=plLru19BPw4Gzl5/9w7riKopb0P86akIwhjnuskNV1s=;
        b=EhWlUol6PpG6h54/xaPe9OyRx4J4G2pPpGn/vjteQsB1je2Dd1CGlNSpiilS/nzUDN
         8UHAmATBxSFj9DNoC711UhDpwd4vEcE4qIcprjYutBDlvRfjzC+e4uLYdiJYBPjrKVi3
         MUMPSKxzTtfALgy9kpVJyrhdNu9YvRdOfxz1Xwgg/ejWLDzdo02awrwGzL8qG6X/z4yi
         zboZbujPUx5RDbYieP6HlM7lMusS/zq4sPVWTzuM080SceGAI+pD/t+bmUSshPdymJRp
         po/iKHHJ90PWnlPBsdodMLmk52ai0F1cmRCDyGNvLpJYJD+Q4lJzstwfoW/tB1j+ZWEk
         EYyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768596038; x=1769200838;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=plLru19BPw4Gzl5/9w7riKopb0P86akIwhjnuskNV1s=;
        b=pFBA+KFi+755tAT5vj1l72b1siDQSgUgwSYIcS3CsPLdo9L5awukV0cXPswxUfQlIh
         2zALAEocTEeUzRxAToBrMGr3FoCyzev7FHED0BM6jxPwdBjmSQ7sT3aGgFYWv7TX/y+2
         vvqL2G+WDBi4AGlwTxSWOrqVY/qVfFUZeSnZBR+i4dlZlZNu1HXzXH7+HfUc5LNJtjXq
         RX2+oT9fZezDFLeaTZ9ny2yMxvYLO71kfBT/JRAEGQzjNOK1vvohT0Fmhn0aHHPyE354
         VRQdGGutalMi647edMtMSbJAAgCItw/FN89ooYRkRgqqe4h5bnPW9JN8vB9Lj/DxsA14
         duyw==
X-Forwarded-Encrypted: i=1; AJvYcCX2BvU9AXJ49BH9fhlGxEj4PufZjkphfhRi+WjkhcsaW6g1E0+12HAwEI+Mi9EaE02brWNZoedDuA==@kvack.org
X-Gm-Message-State: AOJu0YxE7zrhW1IxWdiow3Q8saUakdMPVuQg32Kq0uD7cP3pBuFkgm8j
	ie7XAGpHWZyI8offpyG1wz1NxKTqxz3lclm7cadUv6m2SRUzzWXRnSSG
X-Gm-Gg: AY/fxX56waUnSQ0EFGlhKPosv/PTR+TMZztJseb4gKbZh0Sg7lFB4UnZgcpKReNJfFk
	hzhAeuEZOr+/pgCfaPzaJG7QlQCGnSdZsIHwbshrLRdae9y2686nEy/mM86OLMKk1flLUgGBiUZ
	janokt7ILwHwRuWknvwzYTXFpi9Qiu4f0w4V15GisvvAFr/X+v8fcEvoB0LARzgDMkCRP+f66B+
	bg9jHITNmJinAadJgDe3be07xEUCsbchGbjimD/oz864WxkLf+4ie+WzbTVhR1m4O/4Y3EzXCHL
	MfmVuwZPMk9hKci25QYqYPpyZxSnuwawGv1mDtX1cQBLPJqyCJYIC/1WAhDGjbef4t1zCX46p98
	1myQKEXXO0mDLMCJnXTkkWhb2QOE1KF3tUMIKH5C3/HcTFTB0z+dkKNSVpkg0EE24swizH6QpVh
	xh4OlKzWh9DQ==
X-Received: by 2002:a05:690c:10d:b0:793:c7df:9dd5 with SMTP id 00721157ae682-793c7df9e51mr26768467b3.33.1768596038285;
        Fri, 16 Jan 2026 12:40:38 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:51::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-793c66c72bcsm13184287b3.2.2026.01.16.12.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 12:40:37 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Wupeng Ma <mawupeng1@huawei.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2] mm/hugetlb: Restore failed global reservations to subpool
Date: Fri, 16 Jan 2026 15:40:36 -0500
Message-ID: <20260116204037.2270096-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6263E180004
X-Stat-Signature: y4nozgrhi7pkhu878hicb555bwhqt5ry
X-Rspam-User: 
X-HE-Tag: 1768596039-661490
X-HE-Meta: U2FsdGVkX18mjYiiyX1aIL3ofSXy9aiozAM8CZKHhUyg0nt7BwhwfNcaTajPujrD/LM1A4VDTL+GZimTd+WyY9b98Ck+O7Yh4SdE5CTHFQWJSScscSYmtWVOeOIgwWmmrnN+LhffDB9wUeAWLOhhxjDSFe+n8RX71zpCYM61//iW7KuGbZEpxvTZGoyhU8/8Xpz1yYTuff0gG8dyKzCBDQ4EkkSatY4D91cKPYBhdGeKhwor0VsncvfMqcJNcnwxCIW2qzErlBJ+KFmYoBSCmoVF/LJyVvz1TDxxafLOJnljSrKo/ZqHf0YsfzyPdq19ssX2BR/4EZH6aDok7FAS+aoVaSTMbFIMwLVMSSpSvbILoecnIPriXsNgBFjQeDKx6+XeLko667F5rRVNlGmRJxEVeTC60xAOBkZaAA2xUrTd0w0eONXuOIJXme8X4gSmtt1g0OjzpgSki4CXyJlB4yD7MYZRnmT6Q/dJjcKErdp0addgvNZbwrcZ68wAYxgNiidOyEYtwzvYQNxnJm4Ld1LkM1D/E3voNfIDcfIbiFfS5JxbjyXseDPYK6GROsE5PEc75V1XbCGSeosHBy9USjdwm1VkGQScxT2Z7UFJV9vZYLJLoGfpsdr9qBvLaww2jDYCCWVr6BmfY+2jJOXQxT66ctlMkZs3Z4Tt4VWgv5DY+29v6jH+/icXYlK7hKVFpTVCwPN5Mjma2CgPIjywzaqKWoGTagl/6DzM43lZVQ4aCpvLcYKkYxKiq6jGgNv4WfKZrX102yim6kwHoQnzCq64YU9DNNw1s6NHk4egeY23bu9sz1KwFq5BkVlgVT3hVbgV+KJ0BZ1Mh5AZoTvCuK5MnXV2eYdZiy3lB2u5jo6FijLlXR54WxVbtcnfRFdR6cCloZvZ8AQ/c/WB48BILNeCT7xV3i5LHQu/Jwpy6MeD909ZMWUrnjBNgXMAV8y/TM6W100le9SO9gni7+j
 XARKN7Yq
 NCdR7wr7K3zNTohCSyyUSR9bMRn6TN83CihevR6cxM2WRtjJlaH0ehlj6UHSkcBHEggdig198EnO0W/G4ewLvNQT77Bh6w/Fbgu9HY7CDWWWNJAl36UYOc7GHNlNCbuXZoqjEfBJWXyXUUtByMvmq88j0g/XhafiXpni7brUX8I/QGbQUytifbDsqrgP0h2I2caa+aOEh7Jb/0jG9lNMz5jZoZVS1uvSJjJPeQoHA2eNy5tpcevvopqs+yOxl/MQUR4NfclMfZRMzPOp8NPsPTG/7DF9OnKgH49ln8NtOEUlo711iWLePtdxZrF4lncGrhVxz/uDB+ACG0iaVCqG61YKUqfitpB+RwzCv24b4ZsnTe7IpjWnzofTDMV0YgrfA+GSmfsCgW2ykaaSC3AvFLgL9pbTiTyALrcCsIkmcC/Vc0jFAiwK2RP8ouPTLVow5bAjHmOQePSiRi1y/KLnk2gb4mlL/s87Q7sH3h9oP6JlPCEpV9EnfpH0sUU7+71S7joZREJgHcRG4fED408ZyJf0u5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
fixed an underflow error for hstate->resv_huge_pages caused by
incorrectly attributing globally requested pages to the subpool's
reservation.

Unfortunately, this fix also introduced the opposite problem, which would
leave spool->used_hpages elevated if the globally requested pages could
not be acquired. This is because while a subpool's reserve pages only
accounts for what is requested and allocated from the subpool, its
"used" counter keeps track of what is consumed in total, both from the
subpool and globally. Thus, we need to adjust spool->used_hpages in the
other direction, and make sure that globally requested pages are
uncharged from the subpool's used counter.

Each failed allocation attempt increments the used_hpages counter by
how many pages were requested from the global pool. Ultimately, this
renders the subpool unusable, as used_hpages approaches the max limit.

The issue can be reproduced as follows:
1. Allocate 4 hugetlb pages
2. Create a hugetlb mount with max=4, min=2
3. Consume 2 pages globally
4. Request 3 pages from the subpool (2 from subpool + 1 from global)
	4.1 hugepage_subpool_get_pages(spool, 3) succeeds.
		used_hpages += 3
	4.2 hugetlb_acct_memory(h, 1) fails: no global pages left
		used_hpages -= 2
5. Subpool now has used_hpages = 1, despite not being able to
   successfully allocate any hugepages. It believes it can now only
   allocate 3 more hugepages, not 4.

Repeating this process will ultimately render the subpool unable to
allocate any hugepages, since it believes that it is using the maximum
number of hugepages that the subpool has been allotted.

The underflow issue that the original commit fixes still remains fixed
as well.

Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: stable@vger.kernel.org
---
v1 --> v2
- Moved "unsigned long flags" definition into the if statement it is used in
- Separated fix patch from cleanup patches for easier backporting for stable.

 mm/hugetlb.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5a147026633f..e48ff0c771f8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6713,6 +6713,15 @@ long hugetlb_reserve_pages(struct inode *inode,
 		 */
 		hugetlb_acct_memory(h, -gbl_resv);
 	}
+	/* Restore used_hpages for pages that failed global reservation */
+	if (gbl_reserve && spool) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&spool->lock, flags);
+		if (spool->max_hpages != -1)
+			spool->used_hpages -= gbl_reserve;
+		unlock_or_release_subpool(spool, flags);
+	}
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
 					    chg * pages_per_huge_page(h), h_cg);

base-commit: c1a60bf0f6df5c8a6cb6840a0d2fb0e9caf9f7cc
-- 
2.47.3

