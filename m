Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A6A8D2A520
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6500B6B00BE; Thu,  4 Dec 2025 14:30:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6008D6B00BF; Thu,  4 Dec 2025 14:30:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7806B00C0; Thu,  4 Dec 2025 14:30:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8886B00BE
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:30:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0981AB86E1
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:28 +0000 (UTC)
X-FDA: 84182780136.17.C8C3D2D
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0914FA0006
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:30:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YaLwZxda;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764876626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k6CQ8ZhfqyyFU9/2UA1NETtU6jN0ODo0V1rMBQeu5q0=;
	b=SATm8xvY/o/OwYlJQfutzhjkQa7Z+fxQ3wTEFhb1KqVP4KL8qoJ/PI8/VnbTZbuaPpgBMo
	J8aeozHgQzI8EO7iuFgRml0fgbBJGy/gN65B6WVk0Y5rttLocn9SiAnIS6qk5djJUwsDj4
	HV4aTiTllAv2RHKz9zuvv2AKbbmLsRc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YaLwZxda;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764876626; a=rsa-sha256;
	cv=none;
	b=mPLwGQdzayv5jvkdanthh4Z5vcCY1aeaaYFY/FRhVPrA+eSAyqHpsM3PUM0Q+VR3COCNgT
	pLC6vlWE5f8bJnWb3gffN1nhbiyqwkOJPzpAhtDU6uH1OtGBdnYwAYEoR/M7BK5WNQvQKq
	AqxAWmZuSv+e8ycom2J4pPF2CZJcciw=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-297dc3e299bso12692785ad.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 11:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764876625; x=1765481425; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k6CQ8ZhfqyyFU9/2UA1NETtU6jN0ODo0V1rMBQeu5q0=;
        b=YaLwZxdahBy+n1KL8hVSqEbVnp7D4nSyGjneQ6ijOkz9OmkF04lKogHt06sDKeDnf1
         CK6BFARXuTAqYz/DSB6Q3M2DJxiJkMu8sJ9RtKwRCe0Y7X9URSl1dAgjZIVjwfV9LQ6L
         ngm7s28pwBSEE/m9uO77q170Ch/hIi1s6X5eyeJr3qS+kqxzhvzp1Ex6I+bpnQkMhY7Z
         Pxu00rq4EU5czq/Zq3cCVGCi4f77b9ASD8PfkkrOo+QQhZveJLJM3JoMwUZ2rENK4RkV
         LxS/qx2aNoVJfPgqPBNqUoiGyhxmJ6GjnkVk6PT/gTLGcVFoXgnzUQTw5JwGNti97U4O
         H/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876625; x=1765481425;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=k6CQ8ZhfqyyFU9/2UA1NETtU6jN0ODo0V1rMBQeu5q0=;
        b=l/f1QKYItzcpAd+60bEvH+s17jXxAw7fPtFUPzB6F9xkXqrfH7uQk7G1LjB4i17Ank
         FMCyiip4w2eYLs/uNr+NNhK1TguBsGHUGF+Rkyqb5MJYC/O8rvFkyJTeHa9HMTTGAZVx
         i31Nv6qq5L0JHZm6/+cLwgkQJ4ipRwVGijuqpTVdQxSG9s7Fdv/DPWBBKlEZWp8QECYB
         2HgGjLNDg/4HP3/AF2Ba2ox8koHJjev4WkLcFIii4Ymj3VWyNyman+PBqKz3rDmSeAKD
         BpqVG0245z0YYw4jD27Pgwj5G90VWE1p4X1Af33WvP3Y+4Jje1wSND/9SxX0pgHOviAm
         8VNA==
X-Gm-Message-State: AOJu0YzHopCPrT1D/UorrliPeVokChMPXK2WMTJIO/2Y43Gmqw0Yk4Jk
	jVJlPnPlpseQITy2KmJXQhacD6FkMHrFPeAkjdxKfcwqIxe0IP6tvGfd
X-Gm-Gg: ASbGncs2DMKZD/r7k7Qa1mcKtG5cDaGc7VsXs5HsffNbvkvKPySBgrSsODrdmH/62pY
	VAuTFWcYSSm+PXPzO9byNTKEeumbYFkCjNhnq/OtbY8SELoNbzusnXrnNL4vcP65WXJvk0aiuh3
	IuxxWqaRWQC6mJhlSlMZXdloBotCxL4BoT1ZPu6c+0m42qF++qFzJx/cpIQ/6K3LF1iZQGai2Ep
	SiS9RF847fk9UrTMdAt1HPF7T3BxEaoffp90CzoASi8lKqw3bqC/cNOftxx5+HPWWlvIah4xAKq
	Y2aqUNePcXhrUcr88rzVOXjUgjjrgyEsYHjW1JieWDhct3C6ImjwdCqrOmgymDXdFebB7Z9X6W8
	NcDnSSTjZjSXXTwkgvSwqGAaI9A7wpOArADADB68RdZw0wUK8+z59kP7//YbtK7bS1LrXSiRDZF
	RrjLp7Feodi1Wfe8G+JuiLU4p/kEO/cms7PmKDhAzit/fTckokb37D5vRZcqo=
X-Google-Smtp-Source: AGHT+IFHyywcPX1/2rRywR3A3G3qtQXd16j/VV0NMDNxSNumz/8b1jacGP1q4rkQk6BYnCOs2mhl6Q==
X-Received: by 2002:a17:903:298b:b0:298:58ae:f91a with SMTP id d9443c01a7336-29da1eea914mr49921075ad.57.1764876624820;
        Thu, 04 Dec 2025 11:30:24 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf686b3b5a9sm2552926a12.9.2025.12.04.11.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 11:30:24 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 05 Dec 2025 03:29:18 +0800
Subject: [PATCH v4 10/19] mm, swap: consolidate cluster reclaim and
 usability check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-swap-table-p2-v4-10-cb7e28a26a40@tencent.com>
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
In-Reply-To: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764876574; l=4270;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=EXBJk1CmynZyFl/MBOO52+UVDAeGzVYnf+qyN2ZRgnU=;
 b=Zd7rpSLnPPYVIUN/r4Lc3fHgl3rBvcSEdXFO75CbxeJaKwwNOpHKjGCvFPVxKi7nFw4/XqKRd
 61GAcg1cDkjBmr3CJMoif3qk9vXF4k4zAkoLoB0Jn0B18JpyUIPmrXc
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Queue-Id: 0914FA0006
X-Rspamd-Server: rspam02
X-Stat-Signature: mujhd8trtuy3gzo547b9p474g693bb45
X-Rspam-User: 
X-HE-Tag: 1764876625-693662
X-HE-Meta: U2FsdGVkX1/bYfJCC1a1EpWDNFO+Rkslcq5EJz+bFK6JBzfKapVdlEbHGZ+vXHC1484RlvGuQWGysydCPxZXkHlnghPTFR28SV8wElZdQveAPKAMtA3XBEEt5suAn4k0meezrzU34Pxib0Y1R27yRPLaWW4GMwQki/K2/WtpmdqzxDAKskD/8i8Or4WGvM3ZFQ4qZ1MuHZ5Tl9oKzbIyYOtb1QYKMj33bPXEuLBD8InL9M7xyNaRaRYCA2zFGG73R5grGxr9WkoaeI3idDVJqrRAfpopAXa6scb1eKoGZdgAnVmGh5xRnRcj78aKDZQFHloCuVuLooc1fzC2WAsAyoUZeir7otOxkhLUzkraFx0GV11dbA2EBguLDgQpNBM5fn+uAsBD2tc2lApRA2YEqUTsn5HN9Y5/Yr2KvJvvCN7cJGJPyoTmjixsC3HIoEyS57OnNDQyEItu1efx2DMy8NTXJYk0hLiUCTWOUQD3Y/ET+J3GGJi3Klq5PQBbMBdCK02JZA9GwK7W1dfp8VTOPAwfg/1pGN8xr+XKllgg2Ie5PhIOqvVj709w8bgjFnrzJHS5eYaSoB6rQdPfapKfL2HhKaZKgp+RsWg2Qfl8k4rbyAPK8NqAFLHp6uethoe6DmtGAyBkVgMQp20d72ivPf9mZeXBNAfD/KBBRbG7mzc4NQ5J2uPOadfrpRzYlSmX+FDYSxFrKIyoOB0+M9lb5+9VB8deL3+k7lHo2Bc/MNpbXSqquj6AV9fIW11+vu+dXLM86VbUdGYuYxfWXCNWPRskrTC6ZzU0Kw6UP+y4ZbRxNs7bpRP8ppys7/IkugwEERcF9J6/rQVRda/nMvZ88vxxRDy564JbBi1r+dHNmJrJuuyRrqpiQOzuEk5NO5HhgGRQ/omVWcLRR5drRiffYDLLJp0oGNZD6C3oPCvD+UPxdHd0sPpm1NIz5bRrpND4UKuYVPASYkT+wzPTanI
 6kcotosN
 MDQ4w0pCaiNGGu4YAQh0x1Ojn8K/IzBmvhAqQnpmtgFyUzNejbCFvJ44sWNPsiUaEWl+t/8lPPYFzn8Osh5bSYDiWbltyKUDD5rRGqCUjw9TG+MXnmti4sW2OZ2pYeTSfvBozhYf6kh3nUif3SF3+AIUxRd4fVBK1vz6bax2PYZuO4cSKk4vMm2fa53uO2f8irRtSB6L4PiO1RAPnVsM+/X45U7IQOa7AJf6nTaifawV7VgGH/ZvbMWUsELkEghw+FMiWlAEbdBdAS8EOcR3zpe3uPtaRacGXctW23DDZt0VDMALpwFWZn4gieGZSgQNXgCaw2H9Ink/Lpetd1jbzR+drtWE0jbUyEqx6kI6PzOLGApPfuVdPJQ1mkLKcRf02ohWeanm7ddWojcLMSMeIgvHW8LmLoWmmj22gQ9gAZuZUsDFZQ8xgQIvinw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Swap cluster cache reclaim requires releasing the lock, so the cluster
may become unusable after the reclaim. To prepare for checking swap
cache using the swap table directly, consolidate the swap cluster
reclaim and the check logic.

We will want to avoid touching the cluster's data completely with the
swap table, to avoid RCU overhead here. And by moving the cluster usable
check into the reclaim helper, it will also help avoid a redundant scan of
the slots if the cluster is no longer usable, and we will want to avoid
touching the cluster.

Also, adjust it very slightly while at it: always scan the whole region
during reclaim, don't skip slots covered by a reclaimed folio. Because
the reclaim is lockless, it's possible that new cache lands at any time.
And for allocation, we want all caches to be reclaimed to avoid
fragmentation. Besides, if the scan offset is not aligned with the size
of the reclaimed folio, we might skip some existing cache and fail the
reclaim unexpectedly.

There should be no observable behavior change. It might slightly improve
the fragmentation issue or performance.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5a766d4fcaa5..2703dfafc632 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -777,33 +777,51 @@ static int swap_cluster_setup_bad_slot(struct swap_cluster_info *cluster_info,
 	return 0;
 }
 
+/*
+ * Reclaim drops the ci lock, so the cluster may become unusable (freed or
+ * stolen by a lower order). @usable will be set to false if that happens.
+ */
 static bool cluster_reclaim_range(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci,
-				  unsigned long start, unsigned long end)
+				  unsigned long start, unsigned int order,
+				  bool *usable)
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
+	if (!cluster_is_usable(ci, order)) {
+		*usable = false;
+		return false;
+	}
+	*usable = true;
+
+	/* Fast path, no need to scan if the whole cluster is empty */
+	if (cluster_is_empty(ci))
+		return true;
+
 	/*
 	 * Recheck the range no matter reclaim succeeded or not, the slot
 	 * could have been be freed while we are not holding the lock.
@@ -900,9 +918,10 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
 	unsigned long end = min(start + SWAPFILE_CLUSTER, si->max);
 	unsigned int nr_pages = 1 << order;
-	bool need_reclaim, ret;
+	bool need_reclaim, ret, usable;
 
 	lockdep_assert_held(&ci->lock);
+	VM_WARN_ON(!cluster_is_usable(ci, order));
 
 	if (end < nr_pages || ci->count + nr_pages > SWAPFILE_CLUSTER)
 		goto out;
@@ -912,14 +931,8 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
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
+			ret = cluster_reclaim_range(si, ci, offset, order, &usable);
+			if (!usable)
 				goto out;
 			if (cluster_is_empty(ci))
 				offset = start;

-- 
2.52.0


