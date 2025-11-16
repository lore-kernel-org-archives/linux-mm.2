Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CFB9CD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD9FB8E0005; Sun, 16 Nov 2025 13:13:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D89CD8E0029; Sun, 16 Nov 2025 13:13:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7EAB8E0005; Sun, 16 Nov 2025 13:13:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B3E4B8E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:13:03 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7546212F1B3
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:13:03 +0000 (UTC)
X-FDA: 84117266646.15.B865F71
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7DF5440009
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:13:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WcFhcLMK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763316781; a=rsa-sha256;
	cv=none;
	b=SixFMbwvX9EbX2+bxvm+yO5hkzIpHWw1+NVljz15RQ9YmAbSlBm5eRfjRCgmLqIxRDkXJd
	K2FFQhooiJ8WA04PWI3jQFWKgixIVmXzz6Kk8MAXXeRWb4fVYBWI3eFHXQ/MZ7XE1WHYw0
	a8caIvu5gYbGt5hBGHKwe6HwR3Z+0Og=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WcFhcLMK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763316781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N5dyJSqyOf74su3zx4aCp7vUNrol9ZYcdrrVb5NykSY=;
	b=LGuLHsHY82QGczEffxl462Hf6xfLogNTQMd7uav1aEGq1qb+WN5gDIT78pj4QPpqFdYNae
	N3PsLyeqaLkzD9ezcq0KkfV0x3mJw8xg7xDvlX2/0u/q0uvrZrdIHuWXGoCKk+2R/pLckV
	DLurBQC2Rq4IwGpgYLvcUh1GVKD3D+U=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8b2ec756de0so27842285a.3
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 10:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763316780; x=1763921580; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N5dyJSqyOf74su3zx4aCp7vUNrol9ZYcdrrVb5NykSY=;
        b=WcFhcLMKqABHM3zNMD6AjxvuIlDJib1qGeurCPE86x8sF6ljgDQPp5c+rfcRm36gpw
         9mgrykmCeJB7ujN2PW9DJVoAw+mqvSLAcCHjEg1twHNqwrJwiKub4b6viUgYSGPFI/Fp
         nR0BU3HKzGdX4DgKPAdG4xC9kARqb5a1on6LVVqqSFbML9Ei0BdbLJRniOFg5TdNQ+Q2
         EZFQI7N7aMgim1xrOPtN/J96WzWwDXFniTD+C59jw6XSIsRJKZsPz9zu13dRnzYBsI7y
         euQXt33ancXf+mpB22VsTkVHNy/VFILKZHXazZ6XVkoI3gbZ28UkrHDS4SHMxBuSCnR0
         xZqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763316780; x=1763921580;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=N5dyJSqyOf74su3zx4aCp7vUNrol9ZYcdrrVb5NykSY=;
        b=Hh8tQK/PnQImzTXK6twcmFDJppohUmRjmIk/pPRyFpI4PTjMsEQ/TYTwVM0cMiTsAO
         brCy9a+h8HCm5VWcXcTQjRfqK6ZrrepzMFZvDU/DwnhbpsthcO3rdWMxiMYFvYM58PzM
         rkuK2QMnFbV3QLAF76AJnk/KbC8ND9m1QGjAIfK/UJgOhmsRHMCiaZtyu8sN5iKlsx72
         +fnHpj/lZGk1/ZjMGUHSJrLjfhhCykyBko0vkxvSU5h7blcx119PH6h13yFZInaRd/cu
         BXnVNtkuQXqKx5oNHy20DU0lPsJijTGucdgQEgWVnjiRu+xTkq691PRqQ3WXEzaHL4fG
         pjtA==
X-Gm-Message-State: AOJu0YwBGpv61tJYVCmiJK4qllzvBOWLvtsDBvQm/kBBARUIlgnko4iJ
	92ZeqVmv7XQ4NeEq4fS+McQBHtfmDdE21ingY0PPrgG4fu30+Bftqoqa
X-Gm-Gg: ASbGncs6yUtFxOHkWh447VTNcMtkgyDZvbOrJku53DtQPl8572ZLOcaNjOY9dYkpKgB
	KW5ko9VrbBiLN1ZR6DPE8Vj35pij9r9OzuTaI/Kki/Uz/n5PXgbY/ieEdSxJ2YeMY4qFMu1p3jb
	X6ILkzrebT/l9Luhs/Bf1+22e9pa4C7ARuAdA2Nri9O4fvqBn9aoff82r9jYzwN6EE07NffvfvG
	f3eMHhdx6N39pIdzjqdbK42DC2tpnGw2NDSfRd1aUoCiiqg/uDkDFTVPBosSBfDlklGOvDr4EO5
	Z5H8L9QGnK+r122wyXRTVVoh+YkOa4iBm4E3F2dUS9Js940y/XTfV+gZVbpSGs3hwm06uvwTRVJ
	Yo1r+N7bM45JPyRTWvD0hEWnn9HAPiRs+qE7A/bPztqR0J4GOv7Jjan4yItmQIHwx0JJ8FsnjBY
	Bh6oZ4/OSvVxIgIbXyR+kMxQ18zL726OvpYNrWqY1rzQ==
X-Google-Smtp-Source: AGHT+IF6z6G+a6/yk1iW5mtw+5/zL+FuJ/bF3edg1gcNLVbNQRnP7GcktPIDkmFrBLAYTvqyfjba7Q==
X-Received: by 2002:a05:620a:c41:b0:8b2:7558:409c with SMTP id af79cd13be357-8b2c3162bb8mr1383729985a.36.1763316780354;
        Sun, 16 Nov 2025 10:13:00 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e089b436sm305447785a.45.2025.11.16.10.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 10:12:59 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 02:11:51 +0800
Subject: [PATCH v2 10/19] mm, swap: consolidate cluster reclaim and check
 logic
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-swap-table-p2-v2-10-37730e6ea6d5@tencent.com>
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
In-Reply-To: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763316712; l=4184;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=XNFtoENDe576WtAy1cTHm6/Bj/RVg2NJetPJJZ7TblY=;
 b=5N1PHKvjcqHSh3B3QLL//ogepK7lUfOgllKkEU/qtEVGKobcGxAU2lHWLbmdB2VYPYdqPhLBI
 RQpjpzumpyFCp0HIqbrDd99K3StPeVO3epQvKQeBZ5vOlCM6O4FvHA4
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7DF5440009
X-Stat-Signature: rexooyx1yu1shbfogk386mdgi6rq879r
X-Rspam-User: 
X-HE-Tag: 1763316781-387944
X-HE-Meta: U2FsdGVkX18xZDXaVMGDl7HhQMJz5zeu9gHoL2/AHvidqUZ8jkzB8Er9yIS9td3rcBpROMBd6K2b7q1VVSbR7fNiI1N8qgbWgpfBUaTu2z/RATqt7ISGYTkLt4ptK1eA69FYm41oaK6fGdvPRDgSO+syXB/kTCqg3FUyU4uiGyAcPzKaL1WDjEE7F7CxwmdMqPLyxZ+F7REQcd+YUq0MGSu9/tp6ERoFuUt4v6l/hEubxDvYT/tUH0CXAoPofOL6iuQzFKOGx5ttSgAhY0uzZWCeMLh33BnIbVua6dYvfjkepJccQOj5FemGQ7r8TkCEdwjfd/f0a9wYSvgoCyDJeyu1b3C/dmacORV011BfAJWCKHiKHhYP63pxE8HkhRAvt9tkr7ceud7+nX9sjPhSxOUYKgrCC4NiaANV9pcA6IEKiDAM4ePmldRkzqIXPko6NXvPPAdinN1aF9mN6tkiaRPUbD+DvxeM1eqPvVHL2mCd6XpJYc3kkd0SEWj4qggCBvfFu3UUTy5/Vp38WoLblCWZr01gTWhl+Q4ucHVA6Hg70BNKR3zqoyIC295o8L1qYNNCNqEtGvFnZ8V35TNZi6758eIZAQX7JJCRq7geXtEeD6TvqZukGKyzZmdVwAqG2lb0Z2rmMkK3NbiM2R33O5wzlGdtwWFKsZ6XH5Kjjiu14WeVjNlQHWHY5b0nUJ0CkSqKqvwFA+BIkXQbP8d5KxIAe/qc6eeIm+R12F2AWbQiFNXwdZ0JtygOMm3czxdrJedb1EnVu0+1cmfO/3V2V11WpSIvjs2RYi2BP/tdq0UA+PR+GiwKj6qJ30Mt6v88T8rfA7SWIpNykUWDo00+BJ937voyN4ITobPRZKptwMqgk1aB2dWgJvv+VMIZa2lcKm+Gu2EkKfe158SnCaCmqttbmytAdrXFNT9kyVigVUb+3eF+P/JsgNZQF7QCSAujsh4su8XReV8jJxC+5ZK
 VUGPFpwp
 z27JkKAPP2yeDKFlMfKWozFMYTaa1/lpysTQY0SYGstw0uIc4SvgR3RfNZ7VR5AKzNu71K8lTnhtn3JpicaEHtnAV36m4Zp7SDILaAzIkgPnSQZlihUSJtqpTAAkc32A+d4MqwCP0lAJPiP6Du4XsZFHqj0e822yuYiB1fjvYgceqr74q1YYZQXtofX3oZg5icAj2iz+gEJk0B3SYUyOPlatv9jUnaNMOiB9ZdidHpNWkhh3ed4AC2oozKuZ2lSn1Slw6AsrRw/Np4STW7HHg5iUgYuJ34GxYWq+ONB8fz5ZTFdtT+vCaR+x4GT8+tn209bzsCvg9UY0weh7WEx2LkzzSnWTOk0chxoVvurSDbI66vvUhP0iPAWEr9k43C2u+ZPl3LN65v5pYk1Qz6osvKAWiZ6Ad6UZn8lnl9d0/g3wdGwaldl8mopc05g==
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
 mm/swapfile.c | 45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index d2e60734ce8f..d57e83a4d0a7 100644
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
 
@@ -913,20 +921,13 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
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
+			found = cluster_reclaim_range(si, ci, offset, order);
 			if (!cluster_is_usable(ci, order))
 				goto out;
-			if (cluster_is_empty(ci))
-				offset = start;
 			/* Reclaim failed but cluster is usable, try next */
-			if (!ret)
+			if (!found)
 				continue;
+			offset = found;
 		}
 		if (!cluster_alloc_range(si, ci, offset, usage, order))
 			break;

-- 
2.51.2


