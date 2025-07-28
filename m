Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D6DC87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 07:54:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B5458E0003; Mon, 28 Jul 2025 03:54:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18CF58E0001; Mon, 28 Jul 2025 03:54:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07BE88E0003; Mon, 28 Jul 2025 03:54:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EAB448E0001
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 03:54:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C8F056977
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:54:00 +0000 (UTC)
X-FDA: 83712909840.30.9A4419C
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7B587180002
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:53:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=miEFtdqB;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753689238;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uaDofCvBJJi4OU/LmXdHLeynm/OcrnFAPJYm0C8Ejq8=;
	b=S4wRE6yyN9/OTgdBKCK1pualoUFltkdYYtC2sxbctGFlYjmV2ZkWp2ECushrhIiT7Vw6L2
	TBK4cYeicvkwDK+aCwQtdpOZzJFbxNYlslvg7CFzkL+KYpOG/dEKbLq16PxrIfKtcNzxTa
	1LEGhz14CqxFB4l9Lr1hwuRAPbPWGNI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753689238; a=rsa-sha256;
	cv=none;
	b=YR4EoTOzYOS03+H1BmffC87f7QWMd2M11Ai6E95wNBEpqmm8fqudM6GwArDuluPJyfpzKT
	e5Mgk0ndTBcFZyINX/1Jriv5FObR9Kh/NGXbX6oXEXdkupHmWnMagbY/KpeHpq2gUDMrIf
	tHrR36cOe2K3RkjiJ8DOjF3DEb5lrok=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=miEFtdqB;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-23ffa7b3b30so9626005ad.1
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 00:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753689236; x=1754294036; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uaDofCvBJJi4OU/LmXdHLeynm/OcrnFAPJYm0C8Ejq8=;
        b=miEFtdqBcxfs3gWKBhSQXVBir93VX1BLWFb5bJj5MPdYq7b261Dcb8ZlQbLcNUwu4j
         0RQKcnJ7+4MZrwkH0LSWz0zEssz8g9R4JzZZaKS1xxZKVWDO5G2zJmAbrkwBHjUqZfTQ
         YhGcAO164plI471B8MI0fL0c7sS79nCBgz4w9/d7nwdqrTwV3WPUHeNHXSnf43D+lOre
         QGmD7rKQK+3+YtfMWHBR31MDt5bZjnRAhF5ZJoaxPxTn8V4EL5cmt9c7PGHD6jHbpRQy
         hw3OWJLWQCGZJpk7PnTYN9JOZoimlqBw9RY8vW27REGmCtJcEAwlxE4bi/joGOHnx5/f
         dKrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753689236; x=1754294036;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uaDofCvBJJi4OU/LmXdHLeynm/OcrnFAPJYm0C8Ejq8=;
        b=YibRjmsQs31gannLldfzvpnPglMBAQJD0vYuKBkSzvI7ffHM1MJRcYjkGH6MLOb99V
         JhIPLigu5r27sIZGTAlTxGZETwVMwV+zjBZ5FPgzBLBms94GY/Pf6dlp2ypfPogyWYRl
         OIEaYASOtOT7Nw4hgFbRkw/YshDp6u4unrD7Qsx9fvLm02ruZiNs1k9GZkmnaCcIJJ2z
         PuetpXNSR047oW3wX8lAS9Pe1MER8yrAUHtOouyKFevogF4RK4jBTtjVE1vSijwyqrjq
         3LPsyQ+4lDXmVH2c+qY8JzKaSipHToHD4fKmzVZOAZy2SwsMvRteV6iZarwhq7oQcpgI
         aPig==
X-Gm-Message-State: AOJu0YzFRZTaFYyjJYYtQXwKKKrgYZAbo0YZzixJ7PLn+DMM56u+DsdN
	/AbtTmaujqdhH5mOHkh4RUd0Q6hl8PueXUsUiyzR2LTVTiRONDZHIMk0QLMlKBDGSes=
X-Gm-Gg: ASbGncsb78kY1xW7JYTqyDX4zNC09wz0zMMvKonWRnVFPjHSImYrWNBKGUYFqJ6Jncl
	P7PiHjauDKd+BCgH2IFHyCJtmbWHxi4iYI2nDo2beqt5R/rE5yzu/fdCF16Rj80+RsmGLM4Nl+N
	+tu5n3gzhGF5w/EmxPBDI4qBPFKuUmxlG8+EpV89KduF/Xq3GWWxfZOwC1cIAHIxLQiqPt6kDVJ
	IN6fJXs6QyhZ4aWgq7sFmAu2Tl1IbGqcPM5DPdjqasV0fphyetCbFHn1wAV//yiJFZpaI4u+GFY
	yIkjPJB4anU4+SfN9+Wt6Yith3k/ibQI0NpQjRah565l6vQvQT0fRShGJv7gTcIRzsyS6YFPyuH
	w/+PAfiKzj7Sq6xMC/+I9tgmvXYtCOqHodWje
X-Google-Smtp-Source: AGHT+IFcjk+VnwZPRERIPqhI1RvqOKp0YIfha59JqXJyCrT3wpyy9RckeBIOnrxvrdcmptyOyK+pDg==
X-Received: by 2002:a17:903:1111:b0:23c:7b65:9b08 with SMTP id d9443c01a7336-23fb3050816mr151982835ad.1.1753689236321;
        Mon, 28 Jul 2025 00:53:56 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2401866c2a1sm20272305ad.4.2025.07.28.00.53.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Jul 2025 00:53:55 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Matthew Wilcox <willy@infradead.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v6 6/8] mm/shmem, swap: simplify swapin path and result handling
Date: Mon, 28 Jul 2025 15:53:04 +0800
Message-ID: <20250728075306.12704-7-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250728075306.12704-1-ryncsn@gmail.com>
References: <20250728075306.12704-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7B587180002
X-Stat-Signature: ekiahztxhs5t3p739friqkyjb1c85f3j
X-Rspam-User: 
X-HE-Tag: 1753689238-126671
X-HE-Meta: U2FsdGVkX1/cxcIw2vsNT+X7PEPiUkNpa2PPy8H6qJUVv9s5uS8PJxYkHVMdyX/h7OGdBSQ12wMgKO32ZQaL8QvDQgSjwCiWUEnjag0YYPtla+liK/XBbyhL9olgM7v/Ab17cFryuKYa5kRDKch9dzR7moN+vtIUMJRQ4nYGRRqYDBToPPu25dbCJqE54SJRlxY/HNdAN12SEi15hA22VKJpPPX/jMexKaOFtZHjTldFbqtmgDBU7v93Vnf+A8rM/pSCMExLwaxA424W1p/gWlft1mERdUWUbbsyTB3xBhQOBHgv8Xo5htjVFy9sUcKO5mzeEO+PZK7HjubDFdTOxiu0zzt6bqXscHDuj9opTjnlDaJVi84rKY25z41ouaSvTQ3quViepKwGfidBmGdAZMlMBlhw1GvaeunAa8uJQXaKi9RtB2RAOsGcnyW3grbtgyC++tE1kR/tvm+LqX64OhphvXtxQAlDmfWoIBFHv12s9KDZvNwPWmn82ohzIDELVKh5Jktq4DdyGCDbs7ZIq1i6rbiXpKO+WFQYHMq5fOjxr7NCVBt4zKYzbYYe4dRYNjHpOchnFsJ9VEKF4q24Bw14pa9sAmux4WafYXsV9K4l0QDGaI/5K+R52g2XfQIEJ9sR3Y4kk02wfCektZW4kRnZEho+CGhPyrSYMQmjkjrVe/Qoup8wzvMOG0Zj26VSNziSKLl8n2ZGOGep/ofyao9dRP7VBMDj+vTf64eI9YmVer0VY3MEjZOIMuWsBgevrd9dRZhp2We5BYCaVQHfY8h+Ncd9yMc+EeUNMdVJ8NmOQVNjo6rMnAvH8U9NUHq6zFMkIMXv/cmCLJjhUaH2w4FDIh6866dwoPSSpAmk78QFt5WNcpmsZTC2Gd8NY+FqbmGaBxbI3YqjhRtidySl9SUFcIPNO6dfTo08W5mV1ByqGN1Er1O/S5vWgzpkI14zjATK/xi5yBr9GHU5CvB
 TZLSVxZn
 QrkdJXnMtRtEwUgGaLsymBewDpVYOXpxZuukFvC5sIn+6GnCK22froTEHh9aIRPLARKFfivmZ84NvyRGGPvcRluiBMB5t1j4fcZguAZVrh6XVTVGkfgisiIPY2tvxPF4nDLD8mDhSJ5mzm/VUxj/bABl9llaIGW/kXjOIx2t0o2PaMSEQiCpH9lJyLD/ZcTj6Vx0f50yfXKOBG7+rcRtcXwtrC/qUJjJqANODi/nX5efbr8JrzHT663aH8QgJ5AvxUWX8jLQXGnV0C0X448TV3fd4+3Dzr5zFIavsqmXxDUJBH6LkU54Ks1NOnLvCY0WxgYBA7P8/tQeeWkxog2tPuAB8sejiWHFIOgLeFbetEChizwp3TAMIreHkUunC8iYzONvQl9G27keB91vJYN5MDhv5N4OLjZWj0MfUPIloZ0NQYFWn4St13wdQAOrEpNqL9H1EoHzLSefK+sTnb3nq+fBMd/scBfySrSA5Wlvkbe4KMOdoqP2FTVvEeaFyN3C1nGPvhc8Z5ZNXFlUt5fGidFHUFfnuvrLTNTjp1A2nacuWtYCNO69nFTwYL4Xx4vh4j5AbYmksh57GR3345J53Z21I7WVtDl5frEQpLprHPVptEwPp7749z3pS6WgwkO/4pkIk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Slightly tidy up the different handling of swap in and error handling for
SWP_SYNCHRONOUS_IO and non-SWP_SYNCHRONOUS_IO devices.  Now swapin will
always use either shmem_swap_alloc_folio or shmem_swapin_cluster, then
check the result.

Simplify the control flow and avoid a redundant goto label.

Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/shmem.c | 45 +++++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 6bcca287e173..72b6370a8e81 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2357,40 +2357,33 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			count_memcg_event_mm(fault_mm, PGMAJFAULT);
 		}
 
-		/* Skip swapcache for synchronous device. */
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
+			/* Direct swapin skipping swap cache & readahead */
 			folio = shmem_swap_alloc_folio(inode, vma, index, swap, order, gfp);
-			if (!IS_ERR(folio)) {
-				skip_swapcache = true;
-				goto alloced;
+			if (IS_ERR(folio)) {
+				error = PTR_ERR(folio);
+				folio = NULL;
+				goto failed;
 			}
-
+			skip_swapcache = true;
+		} else {
 			/*
-			 * Direct swapin handled order 0 fallback already,
-			 * if it failed, abort.
+			 * Cached swapin only supports order 0 folio, it is
+			 * necessary to recalculate the new swap entry based on
+			 * the offset, as the swapin index might be unalgined.
 			 */
-			error = PTR_ERR(folio);
-			folio = NULL;
-			goto failed;
-		}
-
-		/*
-		 * Now swap device can only swap in order 0 folio, it is
-		 * necessary to recalculate the new swap entry based on
-		 * the offset, as the swapin index might be unalgined.
-		 */
-		if (order) {
-			offset = index - round_down(index, 1 << order);
-			swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
-		}
+			if (order) {
+				offset = index - round_down(index, 1 << order);
+				swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
+			}
 
-		folio = shmem_swapin_cluster(swap, gfp, info, index);
-		if (!folio) {
-			error = -ENOMEM;
-			goto failed;
+			folio = shmem_swapin_cluster(swap, gfp, info, index);
+			if (!folio) {
+				error = -ENOMEM;
+				goto failed;
+			}
 		}
 	}
-alloced:
 	if (order > folio_order(folio)) {
 		/*
 		 * Swapin may get smaller folios due to various reasons:
-- 
2.50.1


