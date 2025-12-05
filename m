Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02573D33995
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 23:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D0046B0321; Fri,  5 Dec 2025 18:32:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A6CF6B0323; Fri,  5 Dec 2025 18:32:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E4A76B0324; Fri,  5 Dec 2025 18:32:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 082036B0321
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:32:23 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B1834C0380
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:32:22 +0000 (UTC)
X-FDA: 84187018524.11.6D471F5
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id D85C51C000E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:32:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R6vFyLQL;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764977540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xVNIZshLyuSr21iBy7gYlmgdiF5+BHlPixcUrdxDgUM=;
	b=B3DakQhx8jIOnSD4Hwu6L9+SuM02dg4VqMDoInlLWcSbHXJaQvjVzfEYC8F5Zu37iwjzXX
	wRm2VspcUnu81h+qo6mDQCjoOgT1/9oIIrGMptoJ8zsRihpVQAFKaBh2huRmxzMZmqkVyM
	7oU4WtO/qWrhlAmGma3gDD1n+ZcODTc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764977540; a=rsa-sha256;
	cv=none;
	b=pg41HgpyPXrckWdA3ORXXGckmktQ91oYk9rBhJRP4F5IP0PMD0gUrb7Xy6fvjR090Cum3E
	PBVIxUnli7SvMV9/69OCliVitKLBMy3JVC5k4LVcPgiwDB59fF9yZHvlsw+Y36kBzEaw5U
	L+4DhFadTfoXDny8ePPQ8u3yoeQ6Ex4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R6vFyLQL;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-63f996d4e1aso3028474d50.0
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 15:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764977540; x=1765582340; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xVNIZshLyuSr21iBy7gYlmgdiF5+BHlPixcUrdxDgUM=;
        b=R6vFyLQLq0nFkzXtBz56Jc6nAC1J4zbEM33tQd/g2V6BlFKiH1l5GaO6rKAmoWu3WK
         euAB+oEE9bPWoCT+xy3aPMU9KfbR8ygunwiExMq7fMUndBEjBXm4x9JxKcv/bwqwIeX0
         RmcoHwQ8bU/RGsYyrgimUTr6Z9AZHYqmoyNY3q+wHFoEN8PM29ffoQIE/1Abn4TQrf4G
         p22XQ/6a1gTAIchz2x9gDvWnkeHZdihRmDZ86jyKN8eC6LCICSoh0pL6L+sGEnCzKzfm
         /6q3NVeOeHCBdQODPJrlPzFqHV84hWtIF72Gq0HFtBOHe+gBqI8viSmeI733Xe2XGfDm
         /E3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764977540; x=1765582340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xVNIZshLyuSr21iBy7gYlmgdiF5+BHlPixcUrdxDgUM=;
        b=GP4pPObqwlAXYVhpDgkf02GJDRQvO+PCmRL1z1z/4kSUp61L+CXK3jHWIjmXGVpw3c
         AtogAYi0xraJ/t8Nk7db9aEWtCsytlq6zLK+bD5zoW6kSurMyZfZVp1MPGFJr+Q16COC
         6L5yQTqEvUT/7RrIKzp2BgIvO0XrGubtDJPYADW53ARoilMjmCZCICOwFuaFbS1uV2zB
         fXwJnklajX1EJy+4WzpJ1nxLSeVR8/IdphcfYFZts0rNRhhBRXkuo7hcedyGMhPBg1RI
         YDAejqi8OgdIBDRHR6c2dOTwMy+JIJrd6Lv/JD+mxeZlQ6ZalTABGJk6GdvYL2f8ykbN
         qseQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOKOckTwLRJnWlSyTE4YkTWaVGH4WuIGxZLN4ZbBevOKrQ/Bgk3K9JCDmJ+cngXdt30UP4GuocTA==@kvack.org
X-Gm-Message-State: AOJu0YyRP1wKIEFcKXteRHVUpnlntNL4Y6PX0fGxb+cwvunIevktqBky
	4LdeXXYXktMAHPia0v+hKCxH4GCHjTUCb13GTdT8DXJ8lIBkfcUvhxcN
X-Gm-Gg: ASbGnct6YWGQcspzIu5FEuBX2zAXi/hsGY5rN0Dd1AJQ8hm35CeDBWR6LMxSZWQG0fm
	lyVrzR/wWYS6w6Z2vmI3b+xtttr+x6NJI2QHuwbIcDGdmHZVn0W3iK5uMJ+Frry0Rhh5jLUwQBw
	yQjRBtsvMEgqPHt2J8C/wL1OAKYqr8RqCQ92LaUyhum3iGnvv+1pjKD8KjLusYP0BEU+JMRc/fJ
	Wq3CmcdQiPvZceZVZeRLZErOjz8pi0Bd8HgM2GUV7Gs+C8NOTYaDd8WJAyxJWnMEe9USYO7hz4R
	3oEZ6bytKTxIT7Vyp3b3WC63ndBtXunsAI1JEZRovwJP4Ao1ZOMD8pclLC+pYIISSZK1QrqtBo6
	QJ8jVBPay20vs04x7ycAba2bcNTrz4U1iq14cSQtP6p+g4UMzVwXuGpQ+BR/vniTaR7wYJkllpH
	Us8mNl/T6EyqZLrXIQV+8qSA==
X-Google-Smtp-Source: AGHT+IGQ5c7kUmmwqDGLvrjuZJ0aZLEBVHhDBqk12LjM5CR3AT6ty5CjA/zMORi2krLA1PmCDUq99w==
X-Received: by 2002:a05:690e:1401:b0:644:41e5:dea1 with SMTP id 956f58d0204a3-6444e756d86mr556035d50.4.1764977539865;
        Fri, 05 Dec 2025 15:32:19 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:72::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6443f2b80casm2356630d50.9.2025.12.05.15.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 15:32:19 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: 
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: [RFC LPC2025 PATCH 1/4] mm/khugepaged: Remove hpage_collapse_scan_abort
Date: Fri,  5 Dec 2025 15:32:12 -0800
Message-ID: <20251205233217.3344186-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251205233217.3344186-1-joshua.hahnjy@gmail.com>
References: <20251205233217.3344186-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D85C51C000E
X-Stat-Signature: 7getmxcirxkw7s38nfcoofn9padgxwhs
X-Rspam-User: 
X-HE-Tag: 1764977540-55458
X-HE-Meta: U2FsdGVkX18lsTPc3iPcn2q+Qo9OFuP8hO844ECDGeyLjWA8QdlEnzdLwVuCAfSGqJ3OHiQmtmWvPnGa6AUaNVk3+RKOYQIkH2xoarfzw/19D+/+065NuG1PBRJLhg1B92095Px9ey9ZI3jo/WE0E662bdxmQXYbKmIbrn4HdTK37jjRyHqJyuB5SO2IYUr1Cgv5ddNgKlwK0W10PkcIOb7HSScJnuAocJCf5264rIyccpZmoAw8pAq51UZ+3qLCwxXRw06MHblOHAsbtZ0OpbRma7JjuC8G9g+nj7fTuUUNieixa7I7V9Cb0OjdzyEz1sqx1lxJHaBvemK2lURRUnYNJKPO9Bn4vWrnZImWv251TeTsxHMceeikVfg5+jUzD8ZnPshEKeDMrL5eaGITUXv1iOKWMv01eWrmCBUYyUdJkF9UKjDGMoWc1jBkUc3/qFHND/qp733eU1smY1/GlKn93ynVEVRzaQTGnJjTa3hlnUdQ+eVd2ANwu4E586HgFofDU92vJFN5tuUARbOfo/apgtHJC4IH4fK6GO4zrGODuR0V6koSrl3gNG9im7ZnE9Gv2EEEmfyy84mePhGqWeRl0rIgmbjeq38Pvu0bjU0npAW4zRHbb+bTQB+9S0UBj+HTtzfsFg/cL56xnB9Sak2S8uACu91P5KHe3Bt+qTT9ptj6nVErnsVVoom2GV74a+vdDxdrTyYkLgQb5XrhIBw94TGfo8P4SL/xprHG1JlHGOG8/WjyjhxLYwpLlBpZwmqRs+c3zG0B7e97GgtQc7qNXcTa4TbH/c67zEp83ESAK5aykEI5t2dIMy+qOE9yUEk7HWXCwUYAAIOz3ip9I8L6DYcmnkMtKIXmDgnf2yj+hoQJnxkknsuCwhnI6ZuYQ7QxLXXOKjjkCWvUYu8rTLB22VoTHLVxcexQWZfRhKQV1iBv+7R/sjglQKMhsQjrtF+BkYmbOyLxe2JkaAm
 hqv7p37N
 Q1Xc9UsLtBptXjgi5Sjxh+h6hpGOm7pSxdKl62zrrT0IY6UqK+RLhDsczkjeQjumMEVCYx3MVUUO98MLWFNoHRvR/oHmLlFiRTVVwaA76Ml/IiPnrycnaA4nyH/P6GIyasaRPHyRC6Q0C6XFImBx/YhcWsixbe3aigxLwVy+Shs3jrNTITfzdZRxXokCu1oCA2qOoHF8BphcXF9wF493z528pRZBpgGEawSdmMzrVdT0xasEzTXNu99JJ6P1bUpOZn90jY10RNiAG3G7KhnDm//MhTlcIm7jkjBSzEZpFD6o0QuIQ8DULPluY5VcP+Er3TMSAUTeDcsgnm76Jv1jGzhVtNFN6QYcUVixbdK6aAeis020N5061hUMoFC6chM7pehVI9g4UDjVfZ5lYY8EO1PxxRJp3tiYrNDLOWU/ApK3fRyVEB25VuY1NitjRiJnJEegu9xXo9t7mGCrdTd+yBhj/er3vHMowhFxe47PryEsoGxFJSj6miVH58OPLM6DCV2JTpNj4MtElsEmyFMyNm+BCnJ1RmMORo1EXX48n8AXyqPVIikK7y0q7+5cmBGniGZhnrlPqHhKsxzI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 14a4e2141e24 ("mm, thp: only collapse hugepages to nodes with
affinity for zone_reclaim_mode") introduced khugepaged_scan_abort,
which was later renamed to hpage_collapse_scan_abort. It prevents
collapsing hugepages to remote nodes when zone_reclaim_mode is enabled
as to prefer reclaiming & allocating locally instead of allocating on a
far away remote node (distance > RECLAIM_DISTANCE).

With the zone_reclaim_mode sysctl being deprecated later in the series,
remove hpage_collapse_scan_abort, its callers, and its associated values
in the scan_result enum.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/trace/events/huge_memory.h |  1 -
 mm/khugepaged.c                    | 34 ------------------------------
 2 files changed, 35 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 4cde53b45a85..1c0b146d1286 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -20,7 +20,6 @@
 	EM( SCAN_PTE_MAPPED_HUGEPAGE,	"pte_mapped_hugepage")		\
 	EM( SCAN_LACK_REFERENCED_PAGE,	"lack_referenced_page")		\
 	EM( SCAN_PAGE_NULL,		"page_null")			\
-	EM( SCAN_SCAN_ABORT,		"scan_aborted")			\
 	EM( SCAN_PAGE_COUNT,		"not_suitable_page_count")	\
 	EM( SCAN_PAGE_LRU,		"page_not_in_lru")		\
 	EM( SCAN_PAGE_LOCK,		"page_locked")			\
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 97d1b2824386..a93228a53ee4 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -40,7 +40,6 @@ enum scan_result {
 	SCAN_PTE_MAPPED_HUGEPAGE,
 	SCAN_LACK_REFERENCED_PAGE,
 	SCAN_PAGE_NULL,
-	SCAN_SCAN_ABORT,
 	SCAN_PAGE_COUNT,
 	SCAN_PAGE_LRU,
 	SCAN_PAGE_LOCK,
@@ -830,30 +829,6 @@ struct collapse_control khugepaged_collapse_control = {
 	.is_khugepaged = true,
 };
 
-static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
-{
-	int i;
-
-	/*
-	 * If node_reclaim_mode is disabled, then no extra effort is made to
-	 * allocate memory locally.
-	 */
-	if (!node_reclaim_enabled())
-		return false;
-
-	/* If there is a count for this node already, it must be acceptable */
-	if (cc->node_load[nid])
-		return false;
-
-	for (i = 0; i < MAX_NUMNODES; i++) {
-		if (!cc->node_load[i])
-			continue;
-		if (node_distance(nid, i) > node_reclaim_distance)
-			return true;
-	}
-	return false;
-}
-
 #define khugepaged_defrag()					\
 	(transparent_hugepage_flags &				\
 	 (1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG))
@@ -1355,10 +1330,6 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		 * hit record.
 		 */
 		node = folio_nid(folio);
-		if (hpage_collapse_scan_abort(node, cc)) {
-			result = SCAN_SCAN_ABORT;
-			goto out_unmap;
-		}
 		cc->node_load[node]++;
 		if (!folio_test_lru(folio)) {
 			result = SCAN_PAGE_LRU;
@@ -2342,11 +2313,6 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 		}
 
 		node = folio_nid(folio);
-		if (hpage_collapse_scan_abort(node, cc)) {
-			result = SCAN_SCAN_ABORT;
-			folio_put(folio);
-			break;
-		}
 		cc->node_load[node]++;
 
 		if (!folio_test_lru(folio)) {
-- 
2.47.3

