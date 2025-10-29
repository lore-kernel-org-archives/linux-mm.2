Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66087CCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6C0C8E009D; Wed, 29 Oct 2025 11:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C42948E0045; Wed, 29 Oct 2025 11:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B80168E009D; Wed, 29 Oct 2025 11:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A87968E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:59:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5629013BE8F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:48 +0000 (UTC)
X-FDA: 84051612456.21.662C9B9
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id 63BE51C0010
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:59:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HROEIUyO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753586; a=rsa-sha256;
	cv=none;
	b=YVgE+HZN/Du5dOZBh3PzVk4wQBIA6yi1CX7TEYycSaCmzVQ+rxt+PxLFMRixRqAkVtwsMl
	vOXqx/QT6sF7jEeGUkYDtu5I8f4wfwpj/lfKqBvsUPL7XUendFXbVSC6MEh1Ew7rp+fXEo
	lfbr0RTcHe/rwRHraz+DHJTeUBfQSQ8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HROEIUyO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tq6PoOm8fNGczgugQnE/jPj2Q0Y+cXCuawf9c8Nqzkk=;
	b=aEQ6wOfZE1g+phNYC9+EDK3fal2vnxhlLHvT0rvvvWVbbudbZo/sx0MK8kiyknsc0FIPwc
	fgZd16pwkz+uDJk0ist1IjlzcpxcqEOJ5o2wCjwp93v8+eFONOK0v0IL6Tu8UbjATSe5ts
	gC3RuYRPyLmj2jUFjqVvK+nNSNKwmaU=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-34003f73a05so110138a91.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761753585; x=1762358385; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tq6PoOm8fNGczgugQnE/jPj2Q0Y+cXCuawf9c8Nqzkk=;
        b=HROEIUyOcby3NvVjDNTiZyqkcJvs1o82Lwdbx3tLpezEvCO/C3JyMzEPq5EtkMJioa
         SIxiGV2J2/SlOFsQpq+kagZ+pAbOOHE7xFbdvNWfTIJEMdOHQIf92KEA8co/qxSUG57I
         ZT4+CTAAluziu+2x8agsCpa9UnYR1Qvrwy+p3NpYGOY8/iEx0wQuTEvHsWBH9rhWQYbV
         q4dVbVFf5Q5AXYkMb+QS9Uvmiy5L/gDeUbUaEU7OF2xkACKF9xC8saSB7aBSZYMeYANY
         JooAOTnlA7dm3STn31iT2cKsbSC2OEbcI+hSAu1tq88RsnQMK9LuBNxR05hlV/JJfPUu
         wWKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753585; x=1762358385;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tq6PoOm8fNGczgugQnE/jPj2Q0Y+cXCuawf9c8Nqzkk=;
        b=uTre+C3GjgGMTCrD/mc/MIMxoXCS2wtKDwrkeaoHp26wGj0zcG95yeO1bZqaQB2IQe
         rUgF6PT+EYr/8AV4UOXIpmpLyunyfSUOqc/xjcRIYAzzSkBnQnOym22YpqofnbgTTdt4
         GpeTFajFueki9AgGBukBW8wWU7VERD8HvPFE2pZBo7i04pj5co0nwMKOjmPw1eMqdtBG
         +rk9nRWzckVgB6PMMXahqpibCgCJc/zI6Zo47VtBedEcM5gIJdIiSrMcIa+pwvNOTWpF
         32oXBFEPo4xWdxlGREsvzSwILMCcjueE1dYDEEA4SYxzqH/3Ol65J2vQ9ttGoMNfReDA
         EehA==
X-Gm-Message-State: AOJu0Yyrf5IybROW7/dGa47wNkaWYTy8qlrUciot/m1cp2kHufsgc3Yf
	aEQfYn1PpnE2doZVMoI6Bcwa80rBg8xBPSEAkYwJ8gtkHSDkwi4OOxvx
X-Gm-Gg: ASbGncsx0mHSTZqF1ddi4i8/RqtfhlSlIFWwMTH3Ew6Z6TSPWLRs3mUHo6u8UuUkUeE
	p49hwROVfUs55rV3IgGTbkCXnl/D6p2KpEvqNCqNtbDQJIBv78TfnX02iaKKyowvlcuWUAk9eXq
	7JJbQD88SWQ/p+LodK2TNFrl2w7yvi0XqrThyP89nsr6VYqMpxpTKhlG+uJeOds6dPxI9Z6aKOd
	jagr2GW7zykfb3C52LAsQ1FpaLNDKsmpB2tID8D3kQqYU2LpKpyvvPGooyaO5yyzjV0teLjwaMo
	HGyiEWjnKrDvGT/ieAK7yOTVSqTUAdzzMnapjS4t6D5/tyec3uQ/MP/C7KvpyMzse1UzHueADWy
	g5/4JMJxDUPdhh9UP9HOxqzeqnsNdHld15SLs6yfshGOLwGYoLRmk9PUKfoADC3C2WIMy1KEI9+
	+ALwn/cRD5rurtoWktIcoz
X-Google-Smtp-Source: AGHT+IEJiZ7ou6E9Ow56ntpYQ8NsRTNR+WJ+uc6HP4HPdJyD9fOV4yH1D0+/1zf2TYa8UuiYOuvhFQ==
X-Received: by 2002:a17:90b:3ec1:b0:33b:dff1:5f44 with SMTP id 98e67ed59e1d1-3404ac129demr113628a91.6.1761753585029;
        Wed, 29 Oct 2025 08:59:45 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7e95aasm16087366a91.8.2025.10.29.08.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 08:59:44 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Oct 2025 23:58:36 +0800
Subject: [PATCH 10/19] mm, swap: consolidate cluster reclaim and check
 logic
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-swap-table-p2-v1-10-3d43f3b6ec32@tencent.com>
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
In-Reply-To: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@redhat.com>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Huang, Ying" <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Stat-Signature: he33ahb5p9tbwdiy9jtgtjpbfi94x6c9
X-Rspamd-Queue-Id: 63BE51C0010
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761753586-571578
X-HE-Meta: U2FsdGVkX19GjvfqeiDSbTW8V71vZ+yQvI21jpqPoDPRvFF5yMwumZhSCkyD2uXn7PL7cXmnIUdGrMy8AQ6WhQi52dX5lyT1SSkBcYudZuzzao5L5L0gF/NFheB8sDf5Ra2MmfNPh82md6cJuEJpfSacsMXB5SCyMm6iJimcQB+7Fr4D153olDkaZdD9l+fkvMTIy3UUSOhcCzrpjitfbRxSIwjxJRm1x6MXB5wak7T5dOxlrAXekXEYEvuk6zAdKZr9vxxR4+bZpu1YvCZGE1nnVtIy5SOqMQj3SOK+yEWM4i+oB7lHxxZ+JEk2/1EJEyAA/2hkdziC5RtfYkYVzGKhnIjxinXpn/VCMoBo0Vxjqyfwme58ZHo+YEeYGjXXj1oqScjOB9sNQKTteigdlsF77myaU0Suy8LU0/EHfC0vhYKB1jtPi9rIO1dPMIec+feWv0XFaru2jaPP+K24NV+ihkBMtHyPTAZYC9AI/yL8lEvCsNTpFi2FsPorr9IQ7P7NSTZIIdaw9qEqK4u2hmktkI4EY80Gr93ibstKWRAIBuVOHbVc/Ake/zQCu+j3ZJZlHiq/RM0SZf6tEwKvgjpNtxDduJleSqJOyH0xivgn2qq2mzh9SZSDI7zN2ZiZJZ0HC7teVkU8sO7NhOVRymYew/+YReeBgYLO9rMV/ttwzYMSAGSvvfsaoRCXLsiUA0BK2eijIujpZ2Oo0HkH00IUKDGGF32y3lqkCiDvAriWQdDIvEoAGmo3L5F/OezIe85ohABF5XFfb7QYkYmVxBM3L3a/wpYFD9ZCYabzxDxDKezW8790fIrO6jKGzq10CCvgDUsgEa2p+afK1s7qaNEBOm34/7OJ3KqWKX2szXADITAw6Q7Hgk66oxpCIumkRcFIJ2Lzt7l/L1XDBDcgont1b+zEQEA8wiRaNwKmI1Z5SarOf8V2+DeX5pnMubJkeKoOF+DHXQQXeCJKEST
 htFXqnxY
 sQPbJaO1uPrynnTvAWxEpkQURYtXN1eDygVBVpopytOoMRmr/OdIsnnYmlkhtJO8B7FDgKtoEKmmUn8re0pMx6qLPId5vSMbbdFlUXb3mLr6lIiyzlZxR0Myi7SSvjkgsbWXNvdSwUpWyxkmqabayCDd2uthpxb0uejsy4tzY7KBgEs5kG2rY65JWKaiLtQTOckVsOrRkbGFfsoCh2aFlTvKKChCTpWIppDb9H7Ctj49JjohdFsjcAwfSh1+xWwFw3gf30Qabx0XILqqqL28S0wGHHY6626QGWyxBJ8c00QWrJKeShaww2is29Sabcm3eezG/obRVYOzhmcRiDCfPEVbydgjKT7iRNTUSvLoMSG8YRB6Jw4LgL0uCzsNXvy4nXW1rOevdKVoXq4oth8pi/Elk2tySiq5o6cLIyaGPiprF9kJTh4CPw/VjGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Swap cluster cache reclaim requires releasing the lock, so some extra
checks are needed after the reclaim. To prepare for checking swap cache
using the swap table directly, consolidate the swap cluster reclaim and
check the logic.

Also, adjust it very slightly. By moving the cluster empty and usable
check into the reclaim helper, it will avoid a redundant scan of the
slots if the cluster is empty.

And always scan the whole region during reclaim, don't skip slots
covered by a reclaimed folio. Because the reclaim is lockless, it's
possible that new cache lands at any time. And for allocation, we want
all caches to be reclaimed to avoid fragmentation. And besides, if the
scan offset is not aligned with the size of the reclaimed folio, we are
skipping some existing caches.

There should be no observable behavior change, which might slightly
improve the fragmentation issue or performance.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 47 +++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index d66141f1c452..e4c521528817 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -778,42 +778,50 @@ static int swap_cluster_setup_bad_slot(struct swap_cluster_info *cluster_info,
 	return 0;
 }
 
-static bool cluster_reclaim_range(struct swap_info_struct *si,
-				  struct swap_cluster_info *ci,
-				  unsigned long start, unsigned long end)
+static unsigned int cluster_reclaim_range(struct swap_info_struct *si,
+					  struct swap_cluster_info *ci,
+					  unsigned long start, unsigned int order)
 {
+	unsigned int nr_pages = 1 << order;
+	unsigned long offset = start, end = start + nr_pages;
 	unsigned char *map = si->swap_map;
-	unsigned long offset = start;
 	int nr_reclaim;
 
 	spin_unlock(&ci->lock);
 	do {
 		switch (READ_ONCE(map[offset])) {
 		case 0:
-			offset++;
 			break;
 		case SWAP_HAS_CACHE:
 			nr_reclaim = __try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
-			if (nr_reclaim > 0)
-				offset += nr_reclaim;
-			else
+			if (nr_reclaim < 0)
 				goto out;
 			break;
 		default:
 			goto out;
 		}
-	} while (offset < end);
+	} while (++offset < end);
 out:
 	spin_lock(&ci->lock);
+
+	/*
+	 * We just dropped ci->lock so cluster could be used by another
+	 * order or got freed, check if it's still usable or empty.
+	 */
+	if (!cluster_is_usable(ci, order))
+		return SWAP_ENTRY_INVALID;
+	if (cluster_is_empty(ci))
+		return cluster_offset(si, ci);
+
 	/*
 	 * Recheck the range no matter reclaim succeeded or not, the slot
 	 * could have been be freed while we are not holding the lock.
 	 */
 	for (offset = start; offset < end; offset++)
 		if (READ_ONCE(map[offset]))
-			return false;
+			return SWAP_ENTRY_INVALID;
 
-	return true;
+	return start;
 }
 
 static bool cluster_scan_range(struct swap_info_struct *si,
@@ -901,7 +909,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
 	unsigned long end = min(start + SWAPFILE_CLUSTER, si->max);
 	unsigned int nr_pages = 1 << order;
-	bool need_reclaim, ret;
+	bool need_reclaim;
 
 	lockdep_assert_held(&ci->lock);
 
@@ -913,20 +921,11 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 		if (!cluster_scan_range(si, ci, offset, nr_pages, &need_reclaim))
 			continue;
 		if (need_reclaim) {
-			ret = cluster_reclaim_range(si, ci, offset, offset + nr_pages);
-			/*
-			 * Reclaim drops ci->lock and cluster could be used
-			 * by another order. Not checking flag as off-list
-			 * cluster has no flag set, and change of list
-			 * won't cause fragmentation.
-			 */
-			if (!cluster_is_usable(ci, order))
-				goto out;
-			if (cluster_is_empty(ci))
-				offset = start;
+			found = cluster_reclaim_range(si, ci, offset, order);
 			/* Reclaim failed but cluster is usable, try next */
-			if (!ret)
+			if (!found)
 				continue;
+			offset = found;
 		}
 		if (!cluster_alloc_range(si, ci, offset, usage, order))
 			break;

-- 
2.51.1


