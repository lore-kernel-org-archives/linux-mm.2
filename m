Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B6F3CD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 04:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A7FD6B00E4; Sun, 31 May 2026 00:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7573A6B00E6; Sun, 31 May 2026 00:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 646656B00E7; Sun, 31 May 2026 00:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 506506B00E4
	for <linux-mm@kvack.org>; Sun, 31 May 2026 00:24:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2FC3A03F8
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:24:48 +0000 (UTC)
X-FDA: 84826424256.17.21C5530
Received: from outbound.mr.icloud.com (mr-2003d-snip4-11.eps.apple.com [57.103.69.23])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0005C14000A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:24:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=VHkdIhzZ;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf26.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.69.23 as permitted sender) smtp.mailfrom=lukafocus@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780201487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bhbmzU8f+DtLeo7/JiKJOt5bFOzMaSbF+v57Q12naMo=;
	b=pyPmpVXmsOvCDWTBwAA0uytPVJ2Wfem/gd8b01HIcpi65Gd7jhOQZFl96wft/0hw7XndXy
	pXsdA/4WxorJXwKhnMPgd8vqJ/DSMdbmeuqUbpbGf2O3MdWMG2Hm/ymJiFTMtY2rmldDA+
	T8jp4JAAYNgW6zlxYrC5ymBqGJYr1Os=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=VHkdIhzZ;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf26.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.69.23 as permitted sender) smtp.mailfrom=lukafocus@icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780201487; a=rsa-sha256;
	cv=none;
	b=OrMlM3xwyAf17iOg6kNsfn5RBbyz5MHlMoSsuAEw/66BTHrpplv251ejNd5+b8iXLaXCsR
	VCVeXt7PeS6kZCmW852GxdRmSQX9tukLvUunHk4c8ATAhbpda65w/vMJ8KmFvZ1bWQ2Rsh
	5PD/u6My62lZL8n6cPaTcT7jWnj8W9A=
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-3 (Postfix) with ESMTPS id 4925D1800101;
	Sun, 31 May 2026 04:24:42 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhJB0MFXwteDUAdVAVLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEEVABWB5WXloXXk1FCA9CAVhbCFsEDx9MDFECQgVWXlQKHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQVKA18BWwdDCFVHBUc0UR9VFFIdRA5tGFAWR0BBWh9EFB0ECw8IAEAKTQVfBitGFVcbVgNDRVEfVEYTGU4bV01QG18CQg8=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1780201486; x=1782793486; bh=bhbmzU8f+DtLeo7/JiKJOt5bFOzMaSbF+v57Q12naMo=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=VHkdIhzZnjFk2cZXEnEBPjAHnj87Z5xuzl8IbwKDWknQke1S4ttuSE0Yt2AJKxnjqb6ZHbeSHVENFSvtyqsw4hjP/HrOqVHPgFN43+P6Ibb77XpeTROX8fI3oTP0YrXStjV9nbcmfxQw59gAPPBuY5sonSU9EA5uYxnTWKDcN5V/z2Pd7dTTyzTYR1FwONLjP7bk0v748u6vZLWEQYOP6cefmsLw8amrxkt4HKpAzRX95qEhFl6yJQsaMmLo1o5ybmMCOsaYDel49V/GVzLsD32091lyIk4tyby0JHlYh0ahxozv5Tzkg9F4kWtCUVg6ZoVw4IhrqA+54Y9V8QH15Q==
Received: from [127.0.0.1] (unknown [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-100-percent-3 (Postfix) with ESMTPSA id 6C23A18000A7;
	Sun, 31 May 2026 04:24:32 +0000 (UTC)
From: Luka Bai <lukafocus@icloud.com>
Date: Sun, 31 May 2026 12:23:52 +0800
Subject: [PATCH 4/5] mm/khugepaged: add accounting for successful hint or
 non-hint collapse
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260531-thp_collapse_hint-v1-4-e7f8c2035621@tencent.com>
References: <20260531-thp_collapse_hint-v1-0-e7f8c2035621@tencent.com>
In-Reply-To: <20260531-thp_collapse_hint-v1-0-e7f8c2035621@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, 
 Luka Bai <lukabai@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780201432; l=3543;
 i=lukabai@tencent.com; s=20260501; h=from:subject:message-id;
 bh=fMQSPKl1zRvOYMdFUia4IDMTy4aTjy06OEcQUlcbylM=;
 b=bz1zxYyHa5lxtxmHcNXbfs1M3uAkN7ZHBImHk3CMvCXzLxWyotuW5YDKhoOw9ngdW1Wc894ra
 z/FcpQWNm9dBJ4YAfErQdGG5wQ3HDntQnDYSNJ152LuXFBxCapLMPeS
X-Developer-Key: i=lukabai@tencent.com; a=ed25519;
 pk=KeaVteSWd00GIAjFyWZnuFsKAKixjga1ZkLMcI66nPM=
X-Proofpoint-GUID: oIUNazf8Xd8qv7Msv4T_iX4VlZJzjfUE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTMxMDA0NSBTYWx0ZWRfXzQGwx+YHthkt
 NMolnw9VHyMV01ZN5GqsQK8DVS4RUWi3QY55OPudBP/OO0CJG3Hcp4BrszDO2TLL971FndIXa+T
 8MrSOS+hZ06yPsgSsN4A7eiihAjPJSONa9XP0YIduhh/0DuKtk0Nkts+253cIuVPMLCZgos1jH0
 FXmnSY3UzZp4JG88oUHS7h0hOiT+1bZE0mtcjaIS221W+NXaBiS150YYte+NBQbWwk3DqP+y0pO
 BcSNZJJvNS24fGhwLteKKG6o9qeoA4uEjF/REWSmWhXrqBr2WPw5br/c37wz+xUFs98Up7zsJ6o
 VgJNHPAqlc84i3ykuPaUmiWAPcOeWy1K+wsCB7h71SRj+Cj95y5UxRYRQhVrrc=
X-Proofpoint-ORIG-GUID: oIUNazf8Xd8qv7Msv4T_iX4VlZJzjfUE
X-Authority-Info-Out: v=2.4 cv=RJ6+3oi+ c=1 sm=1 tr=0 ts=6a1bb80c
 cx=c_apl:c_pps:t_out a=9OgfyREA4BUYbbCgc0Y0oA==:117
 a=9OgfyREA4BUYbbCgc0Y0oA==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=0Ztl7DgICfUfD0EaiaYA:9 a=QEXdDO2ut3YA:10
X-Stat-Signature: xuottaexburi4s8m45yhtnkjy6zheyz1
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0005C14000A
X-Rspam-User: 
X-HE-Tag: 1780201486-844287
X-HE-Meta: U2FsdGVkX18ehbHG00R6E0KMlY/tOWukNk2l7jZLbKFUbOZIAFBBzhIPbn3wzNrZRjFvOCzVJgbtQbULa0Ft/Es2WzOm5WvdnilAxqG59RPOQg7hAomHF8HNoeU68VfK6BkZ5mnrJJymXxQxII8elZKExM4AcF7sfLgG5pJshcsA0NITfhtaobqakiJVHAmcuRkqarLvIc1GOIDcv3aR5vuPERPoc67Bmh5TxZjZ43vNLAc5KWPxELl8vv58CUZ5B+tGX1VqoNHGya88cmLOsrl+FsV2L4ZH4rdKPxl00G0VBc6piDpYfhVwJG41X09eL/6Z/S1maSNI82+7DbrAWW6lSPFQDvC6r+atO+z8I7ocTZaKouSv3jQXuUHrd3ucRakRBkCwjB6PpR0bg6OehrII/cryXA95x6V7L9qYv/leVrv4eNKInYGuq1kCdaHCEHeI2v/EcN9YgGtnOZAWQATgN0yv1Zf7MKrW5iBa1CDMqj5gwrRKpmt8/Vn+ZyhVbAB2vIQGd/+EqJS8LtUhhgnLhK3RKsU8uVhCclWzZOJHRhLYMsAolm4/hZm62ImkWiyvz4n2pvOSntpePm/ejg07ONiJwLoYINeRcrVDKuvcg9X+to+BgeDKygSGQwV+Vy3McL+6mLvjEvo/V7BCNva7I8jZdFS2XBbgVuJY6g4kCyllE5xg2bDu3cHgfe029fBgbuVioagK/uJwhv50wX9KaP7mqeJF8NtZxEiSdnrvvSE9J6hsLe4ipWX0kBhCxSFtJm20HqZWFC/RAJONBgVeOCj4kO3RsmKyr+Fr9E9+AKz3GrOGSrQs5RcIx6SKoKigNf4Z30u4rB3XewAab9dAJtZAyO0e9+WQw8IAuUZGX1tSTRXxA6yaTjV8orpIJj5ucP9UNpSlmH46eIyzDcfRoT0SVHAx4uW24d/obe0wYfUTju0XkAmKQlB01EPLGRCOPJhNuE/2ZsPTfxK
 lVpCTGaO
 KygID0L/3FSeLdJXPZ0cNgTgs4KbG37tWDoOtSPt1VusEF6J/FRuDtp68n5Y9F/zPI0QYUt0uJsiS4Uk8Wdvt4oK8zBr2WWPwH6Rkiv5H+enIy5k7Gm5GHyThpYpYiz5Yz39XJXEJZ0RxY/XWOPlTyVTuNMo7qzaYQ4um/40z7WUZhI01eEqt0RtAX2+nYlmb2AEhioL2lcbu9D14M13ZfWx42xBg8hWhsF8oB4cVAifnyUjEu6UQunfh0paNz5n6cpW9u8XzMksHHkCFDSyupwnXgueruV0o+BpWUXlum9NwtVyRDEXbok2uorYhd6m2sBAOAE+iDQIkxoSjA6HjicoMHfnKq9KPjzdEcYnf8a/Aldidg1SzazbcPGBB/NDgjC9Mm3I+CiOIZ0Zypr0OYegNHAmem1RHUKq3h1iRiKxZXmBksa0C1ZQ32Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luka Bai <lukabai@tencent.com>

Add two mthp attributes for the accounting of the number of successful
khugepaged collapse, either by hint or not by hint so that we can know
them easily from userspace. Note that these two statistics only care
about the collapse initiated by khugepaged, and they will not consider
the collapse raised by MADV_COLLAPSE.

Signed-off-by: Luka Bai <lukabai@tencent.com>
---
 include/linux/huge_mm.h |  2 ++
 mm/huge_memory.c        |  4 ++++
 mm/khugepaged.c         | 18 +++++++++++++++++-
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index edece3e26985..9df0d7f71e95 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -147,6 +147,8 @@ enum mthp_stat_item {
 	MTHP_STAT_COLLAPSE_EXCEED_SWAP,
 	MTHP_STAT_COLLAPSE_EXCEED_NONE,
 	MTHP_STAT_COLLAPSE_EXCEED_SHARED,
+	MTHP_STAT_KHUGEPAGED_COLLAPSE_HINT,
+	MTHP_STAT_KHUGEPAGED_COLLAPSE_NON_HINT,
 	__MTHP_STAT_COUNT
 };
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bf9b480bb3b0..0031fb4b0b09 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -720,6 +720,8 @@ DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPP
 DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
 DEFINE_MTHP_STAT_ATTR(collapse_exceed_none_pte, MTHP_STAT_COLLAPSE_EXCEED_NONE);
 DEFINE_MTHP_STAT_ATTR(collapse_exceed_shared_pte, MTHP_STAT_COLLAPSE_EXCEED_SHARED);
+DEFINE_MTHP_STAT_ATTR(khugepaged_collapse_hint, MTHP_STAT_KHUGEPAGED_COLLAPSE_HINT);
+DEFINE_MTHP_STAT_ATTR(khugepaged_collapse_non_hint, MTHP_STAT_KHUGEPAGED_COLLAPSE_NON_HINT);
 
 
 static struct attribute *anon_stats_attrs[] = {
@@ -775,6 +777,8 @@ static struct attribute *any_stats_attrs[] = {
 	&split_failed_attr.attr,
 	&collapse_alloc_attr.attr,
 	&collapse_alloc_failed_attr.attr,
+	&khugepaged_collapse_hint_attr.attr,
+	&khugepaged_collapse_non_hint_attr.attr,
 	NULL,
 };
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 3f5eb8be06d1..2f21c0b6ab46 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -147,6 +147,15 @@ struct mthp_range {
 struct collapse_control {
 	bool is_khugepaged;
 
+	/*
+	 * True while khugepaged is draining a collapse hint queued via
+	 * khugepaged_add_collapse_hint(). Used by collapse_single_pmd() to
+	 * attribute a successful collapse to MTHP_STAT_KHUGEPAGED_COLLAPSE_HINT
+	 * or MTHP_STAT_KHUGEPAGED_COLLAPSE_NON_HINT. Only meaningful when the
+	 * collapse is initiated by khugepaged (is_khugepaged == true).
+	 */
+	bool from_priority_hint;
+
 	/* Num pages scanned per node */
 	u32 node_load[MAX_NUMNODES];
 
@@ -3012,8 +3021,13 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 		mmap_read_unlock(mm);
 	}
 end:
-	if (cc->is_khugepaged && result == SCAN_SUCCEED)
+	if (cc->is_khugepaged && result == SCAN_SUCCEED) {
 		++khugepaged_pages_collapsed;
+		count_mthp_stat(HPAGE_PMD_ORDER,
+				cc->from_priority_hint ?
+					MTHP_STAT_KHUGEPAGED_COLLAPSE_HINT :
+					MTHP_STAT_KHUGEPAGED_COLLAPSE_NON_HINT);
+	}
 	return result;
 }
 
@@ -3227,7 +3241,9 @@ static int collapse_scan_one_priority_entry(unsigned int progress_max,
 		    addr + HPAGE_PMD_SIZE > ALIGN_DOWN(vma->vm_end, HPAGE_PMD_SIZE))
 			goto skip_hint;
 
+		cc->from_priority_hint = true;
 		*result = collapse_single_pmd(addr, vma, &lock_dropped, cc);
+		cc->from_priority_hint = false;
 		if (*result != SCAN_SUCCEED)
 			(*fail_count)++;
 skip_hint:

-- 
2.52.0


