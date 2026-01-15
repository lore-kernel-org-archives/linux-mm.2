Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 103CDD4660A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 654A56B00BC; Thu, 15 Jan 2026 13:14:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CECE6B00B9; Thu, 15 Jan 2026 13:14:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 425C76B00B9; Thu, 15 Jan 2026 13:14:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23F1F6B00B9
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:14:45 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA0C613AF6B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:14:44 +0000 (UTC)
X-FDA: 84334998888.12.5AA3743
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0168620004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:14:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lVxa516Q;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768500883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O45eLppLOCW6F7IMGZ1ULnrc2pXJxucNBG4tS3sUSSc=;
	b=05t8BEIHLjaW0/S4e5KEnOwbtQEsfor8jf6xz3webREuEue64UX/RpoJSCchI5Z62T8C8d
	BqMKE5N2iclZv0lF4AInYYLTPX6eXgSvDXi0kSV3QcbH3Kb0OCSGFLRuyR0RmiU4AwXfjn
	4vHes4ZoPCcNtQDlwvntB/jtTHOmflg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lVxa516Q;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768500883; a=rsa-sha256;
	cv=none;
	b=v92KdwwSdA6zX6GlU6E4HVEQyGtjXn38Xcdf3ENy9uf4GaCeWr00OvCEfQApKgLKRIpPJQ
	SL2Bc7Ee+aq8NuEh/kS/GxG3bw1HvtAWyp37mFBovhVBtKA2SF1dd8/g38UgrZ9C3PoCsz
	HGhQDWiFt1M4Lw1xtcz2ld7wMIXQUFw=
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-6442e2dd8bbso813634d50.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768500882; x=1769105682; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O45eLppLOCW6F7IMGZ1ULnrc2pXJxucNBG4tS3sUSSc=;
        b=lVxa516QHn69fvF06fjj2gfu29R4JbK4DWtdqn2buNOu/NQDvcHBL55NnGZOpAWJOm
         jIaAWOm+rRFGeyt3u8A80fiq51aRVBPg7ZMzKVLejM3G5oeHesuqvbXzJ3zVP8JNoTuj
         3WrvSyoTsTY18BL6qpp2DYIJcEn4cI2TomXiIw6RCgjYlehRlxj6AAQnxr+zOr3XwUSJ
         51ZkYpwt25tnItQSVdwrgZnN3UDjVD9aFrPxl0OKRJAZb6Tk5P4WrqlhTeWhvwixv7IL
         XXJSOYPQzKaILUeNXYJfGJ0F1kf2d7p+o4+/JvHdcFH3or17h4RzRAMb2f1lTW7HNea1
         Xevg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500882; x=1769105682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O45eLppLOCW6F7IMGZ1ULnrc2pXJxucNBG4tS3sUSSc=;
        b=VuszmUiBO8AfhfT0P7gytXKhyyCTW0V+Vr6uN14JT+fGHqRj3HtJmu6WzNtZGdAjuz
         0rcmXioqgjexnG73FRA5r8bn0tfMFOtN9FO+LEKSrDxrkF7LmksjuU8DZzWhhhfTHNGi
         peRAzinbiUQ/GXvTyGBxVopwpsqzXvxEINqrI6xDc6K85NzY/tEB2sWYQR276YfjoLbH
         K/WyhODLFlIKNKnDnNRMmRRtxszBlQW+2/JRl3evxLGS2RiaC5QrcMIoJjLwkEAuERua
         7RBey00QdIiH/tuOAcrC6bXAKx+ZjC6W6nQubSf9ZbahdYlhaZXOyDdT92CuaYp5XkiW
         se/g==
X-Forwarded-Encrypted: i=1; AJvYcCXSuDsWHgmE2fq2HC/Zo+NCh//8YQ1HTHLCW6F28tffW4AObObcSUroKsH6lq1SYdjSlvXVtMqMlQ==@kvack.org
X-Gm-Message-State: AOJu0YyZnxuClc6q8kJHR007o2Ocaw3Ylrmk7EQy8O/awpSKromTKjii
	Ld/uVNXyNnqf5EwbU1psWjrlR258MkI76bwLj1n0+SEpL4ioyYpF9DPV
X-Gm-Gg: AY/fxX4lvARZn2dOMZwZvMnA1nEfXU/ry+49yt0fyvzpOsQD+/GB5uTxBqabgwLgFuy
	xoBgdmfSqtCkwGTlkVPl8sWi7711IwK4L0Pht6vMZC72I+BhJ/7ZEe2eUma6Ajm1EK7UM0ba3S3
	/+lTBlo3RpmvnVL9mIlzvb4wpAeq4zAnkd1/zsgpbg5glF71L7Iv++VGTM7hPOm7v5XgGPoiHhF
	/78UZ3KZ64BN1Sf9uF7FmVX886zn3jFlQSH0HgPul9nYucQX/0h/M0BHkR/PX/psjvXAsEip7GP
	RFFM+TZ5nkBUVJ3mhmZnKG32qrMOHWTlnATrehZBFIoNoB83+Lh38V1Oe7cdzROSL53xn6cFxGK
	N6YSNtfipSL23RggIpJNjZ6W461OAmsPXkhr8NrVdV4xM6CiEbS/4eCyWXhp+i4otxbyxUjWnfK
	PpMQ1JdUjQ/uOCvwqLEMUQ
X-Received: by 2002:a05:690e:b46:b0:63f:b634:4224 with SMTP id 956f58d0204a3-64916484f7bmr462440d50.21.1768500881797;
        Thu, 15 Jan 2026 10:14:41 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:44::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-793c68307b5sm98567b3.32.2026.01.15.10.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 10:14:41 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Wupeng Ma <mawupeng1@huawei.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	stable@vger.kernel.org
Subject: [PATCH 1/3] mm/hugetlb: Restore failed global reservations to subpool
Date: Thu, 15 Jan 2026 13:14:35 -0500
Message-ID: <20260115181438.223620-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115181438.223620-1-joshua.hahnjy@gmail.com>
References: <20260115181438.223620-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0168620004
X-Stat-Signature: x1mc81a965r9o4erscx3pwuq9umwdfnn
X-HE-Tag: 1768500882-403455
X-HE-Meta: U2FsdGVkX1/5ZVOG2MIFghgs8+E6gH5KTCWm7uv4Kepoo6Y1HhSTwR8UJAYECUSuOGlLYW8g+UCyoW8/j7pGHKm2CKM+KS8lEX09rsTBnDz88WzNOnPCiVWFoicEjTdNnTLNMnu3P0uXo4wLzv9B7oE9bzH/tmCbg/LKqSKZ07zZoVwthCN8IT/OJLZ3BmDXMFFokjm+7F9Or+CRA/zeU+eE6txAHceCiIapbjN9gdp+ZeUtSlkORt/1ErIzHjMXovgpC7LvZOF58UAXTb6/zTCITskcwJOxSOcXwulrCXtHVKSLYQ6oSsGu0bmyxod9b9VfuB55lawyUF5SGruYKWND0Bzm2M5f+c756pzAwBGde74mBLJ4emKYyWCjHZ4drVQqpoQW+cFkHN/uA7DAnRU6svFs9w3h1oTN/0t7lNSq/5zLFU1XXt2ie/VSyUg7YwYIKWFfT5wXWfFtEWj7n088A42CxKejSM11R/zHp+a0gp4DBmqhcAGAv85Iyz/4rHQvrk173ykA3iBlg/ws6imaeeSqNCSmnBH5luSpwYNdbiY3FAcwjxNxn1ESrjdnf392vqVPOG0/gmdl2uPLpwkAbY8Q0QN4rMX4mVSn10TZKpFkdz9upSmCblE0mbHk5cOw6vYwwvo7WmlM/xbmpvC2RddCpzH8cy01NdHkg1vkYgYWyLDv1f8msVo8npF9mXZPpM5SCkn2t4U255JbADj/PeFAb0exXZHG0Ne34LtZhM6eHdC86sfft4gO4O858Z/epRfGXzhzSdZ4Zb98Vo5Qz91n+askzHPh/VTIRMFfoAL5km6YbcfEDhnJmKIEjIZHh21Aezf+/n9LsjkMPCqPAhIhW4b5FV98vr90w/xJQlJeQ2dqATWDRarginyKVmtuUe8oxD2QfwpHQl9tDpJZSQs/bR3LOF6IXuCwaYio0MAd4HKNw+7KJYcFDIVtYc9eIb8GeMDVUj+texx
 5Pf9csz2
 a5AhrZU//9yPNl+yWj+vElDpccokJRLsMdyOgxxgkuP03RKpPWwXOaDjg+sJZ1BZ6gc0YR7LnXexYm92ju84xdtIiHN/5oLwW/+L3ZxRf/WhAQLOw6SFuZKssgBTWRb7tDaBtkhNnc6p6ZlGmmjeqySPmweP3zBecEbFAOa2ozFgiLzszaQQNmy2NbO8iVU3ld/QuuOBXWAiffXxs/jADwLwVqty78rhCRCx6dk3dd5Pd/yTErTNGi0GhKgAFOAmSFCub+0SChuDPKpaF0Jf20AJcpJHYnRtwXqCoEMI1czNX/8EQE9iRo1CayVoeLnj0eCH/euKKEeBPzbWMbuFvkjUywjb9lyXFK8+KUyz480G8ZZ1yCEVX9O92oBzzBBekc704h/VJWUsM5wRJBsR6/yD6LcjKdYjs5fc/Cf2V/3NchNCuz5CC/P1OJIOlKF/f1DJH1x/kCDrjkoSDWMET1Gbn19XG+OrcltPxJdGKzOHn9bFUbdyS274+NEB/8UHAmjjahfVAUnsBBik=
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

The underflow issue that commit a833a693a490 fixes still remains fixed
as well.

Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: stable@vger.kernel.org
---
 mm/hugetlb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2e296d30a8d7..88b9e997c9da 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6560,6 +6560,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	struct resv_map *resv_map;
 	struct hugetlb_cgroup *h_cg = NULL;
 	long gbl_reserve, regions_needed = 0;
+	unsigned long flags;
 	int err;
 
 	/* This should never happen */
@@ -6704,6 +6705,13 @@ long hugetlb_reserve_pages(struct inode *inode,
 		 */
 		hugetlb_acct_memory(h, -gbl_resv);
 	}
+	/* Restore used_hpages for pages that failed global reservation */
+	if (gbl_reserve && spool) {
+		spin_lock_irqsave(&spool->lock, flags);
+		if (spool->max_hpages != -1)
+			spool->used_hpages -= gbl_reserve;
+		unlock_or_release_subpool(spool, flags);
+	}
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
 					    chg * pages_per_huge_page(h), h_cg);
-- 
2.47.3

