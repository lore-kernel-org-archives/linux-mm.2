Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78AAA106F302
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:36:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E422F6B0095; Thu, 26 Mar 2026 04:36:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF2E56B0096; Thu, 26 Mar 2026 04:36:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBB946B0098; Thu, 26 Mar 2026 04:36:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BB8E16B0095
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:36:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 94E535C864
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:36:52 +0000 (UTC)
X-FDA: 84587558664.28.58AEAC3
Received: from outbound.ci.icloud.com (ci-2006e-snip4-11.eps.apple.com [57.103.90.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7C70840002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:36:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=y5fckf4a;
	spf=pass (imf17.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.90.181 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774514210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+PRHeM3s2DI2yQOSrDPnTDvHR27Fnjgpu54ajqjWKM=;
	b=7gOPvy8Hwz13R7X1vNuhGBgsHIiPDnITYd1/fOg6EMWmMd2g+jbX8kUc7KR+BSKtBDe7Qm
	YbRG4hA322obe28lV43zelNsM7LxxkktPotzX/J6D6MLriN6Rc0nCh8qDEE1yTwBIrEjNW
	JQ09JIA4ZzgvahehLB6F/r4G7XZk31Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=y5fckf4a;
	spf=pass (imf17.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.90.181 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774514210; a=rsa-sha256;
	cv=none;
	b=HMt/4mqyjcCpwETQRiPQfgtVsIhrg75lYdl9NwEtAhIYn1TOMMpN1cLcQkHi7FB/zVOwtt
	XFTj8GpFIaY6x/uv/p/Y7mXeN6wKCbnH4bOf2Jko1GddJvD9e6l1AznQT2DtfNL0PiWnEZ
	S7AGuLa1TigB1775/8sQ2NI4PsfVQ8w=
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-11 (Postfix) with ESMTPS id 277DB1800216;
	Thu, 26 Mar 2026 08:36:45 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1774514209; x=1777106209; bh=W+PRHeM3s2DI2yQOSrDPnTDvHR27Fnjgpu54ajqjWKM=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=y5fckf4aHvY/4d/k3tDLEvwtHArMQ3QvflAZqnGyufERLyAoK0PiQTpsvukg5kdqrz0j8okrB+tex28EDyL+udWlPGM/ov3fG4BDF+XiYWwxf+3UKqcz3R+zDe3BeIP4iqrM7V9PYGoS5uZKNtZZ6wkl4yxvY80eRwp2YTRKkjwveYCkv4yDuS3X7Q+z+YTH3pCIEhhKvCWD7XgJow0O2XvJiEloXr5wF4gk93PrvA8jN8k2pjI3cJ+Ook2Nwf9Tqu7Eb5Im+HIUIv/qwJSy9zwiNx0EGmHah4Q0quA6XXa+coBRXYbyVtk5FHwhLsboRJj/qrvqW2xuNiPopli71Q==
Received: from [21.6.122.162] (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-11 (Postfix) with ESMTPSA id E62D81800103;
	Thu, 26 Mar 2026 08:36:38 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Thu, 26 Mar 2026 16:36:18 +0800
Subject: [PATCH v2 2/5] mm/vmscan: extract folio activation into
 folio_active_bounce()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260326-batch-tlb-flush-v2-2-403e523325c4@icloud.com>
References: <20260326-batch-tlb-flush-v2-0-403e523325c4@icloud.com>
In-Reply-To: <20260326-batch-tlb-flush-v2-0-403e523325c4@icloud.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774514187; l=2167;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=MwBPaFWPFTZ2m6kdtZRGEvS5uyMpPolk6vIxczHd7KA=;
 b=QTpI4KhMzfCr7GoxijlS887QDstZgQYD2aylFzXTg1x16Sz+J6AVX6Kio9gWjhzhmPJWOihxV
 Be08cy4jIvVAjl7Pq55we5fm/FOdC6J27OAWoVx6NKDbz6HMHN7q+Sm
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-GUID: Bkfp8Xp4cWnVHNChC_PiyCLqKKrQZk6r
X-Authority-Info-Out: v=2.4 cv=acpsXBot c=1 sm=1 tr=0 ts=69c4f020
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=tUYT8qNuPuMAWAmJffYA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=R6HnoDE5lksTgPyyjrIf:22
X-Proofpoint-ORIG-GUID: Bkfp8Xp4cWnVHNChC_PiyCLqKKrQZk6r
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI2MDA2MiBTYWx0ZWRfX0eQXWbj8yDBm
 nNm+6008kYFQdsgm+vSpXzEAMOfBLAUxgTxbjuTp3nFrLYrBvfqVPa2usPCCwBFVrEpjKwbI64D
 Vv8ftur/dqMW4Qw6U4XU5f4D9zgJC2Eveg/EOnR4QlHWHSl4YOq7MPY81i6er7qn3lW8mCfbxDJ
 vybhu9hKzPEFNI6GjYG34cC9SAlcFAZqfAI514EAQ19LHhkCQpn/2I6Jtj2xpWvoB/hnpEJbwpc
 mF0mTfIrWmp2CU7O3/j3puvx58XQUjT+SDa4KasECfQmSbf/iipKc1Am1Wh578fgeUv6hMmZifD
 DEzYkMAux4E0yopD5hCzDMLlE/nLG+WNmqo0pCGPTVLQdDXNskZ2aaU+qgdVn8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_02,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 clxscore=1015 mlxscore=0
 malwarescore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 classifier=spam
 authscore=0 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2603260062
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C70840002
X-Stat-Signature: chz6kebozdbe4k8nsye3p7xo3wi43rio
X-Rspam-User: 
X-HE-Tag: 1774514210-171308
X-HE-Meta: U2FsdGVkX19B6uBOaN3gENdxi6gACxUYMIsqKT8OlEhtwlpLZZ9qxGGekOPYqislCr/5ooiTzfYvmjvSDKv5neShNdkFs3HAuXLnBg+2kIcZgfxP51ey+mxg+4VpJ+1Ay79e3YVUCQ1a2PTAm6tOefMkCqvxJE2YUuWQkpGfmTsZ2UzKatPxn9v1D/ySAMdRKd5uBYijGy7esH5q9zcOjQKD6MXkN7IiNx1rlnNnGSBxoya/Hey1dVyDFGGAKSYBsBFH5Is6XNt18EX0xSexLAK8QHrUj4XudinuwElcXB96TTf1IjHAKeXSGB/I0jfn8zU5V0Wx/YSAFLfz+M4qM87v2sQL1qcwnWGgdzj8KDe1ly3AlSxrGUbM3O/RWGD1XFZWpfcYQiUD2/tnFYbgiEfLXdx+AqoLhCiwmNjI6DmI1EbxFuLsmadGZ+BkPJJkRXVtnWzixa2g3peJ6Y+o0+qlLIV20jYfsBaoMNFtViH9ulIQDDyddvJTid/UsWtSSkjRiQsSX7zrgJ4Cpgr7Taf3FnDvvSTD/NiyQA4pzLVv7FSUzHElw1GI2B6jhdPQoiYnsgNPTdi32Axw0hPlYcb2sXUdVSaGO3bhX/XqwhUsczOGnrjuFsmVLvX4p5kP5Br92AkhIEddBcEPqE+tbc7o2l06zMiD7gidHb4sDbcY9d8Rh/qgNocgcIx/5Tf7BVAvvOdAkIJuy5KaM2nH4Ga2z5hLhQR6Y1gtrZge8qLycsd2RUskVZR1AirNnqc2vY3ncyA0AZRaVKFCxHbkRMze83Lo7LGBq9PswJdwiouJhTg7wmH3LMMnZMiP7gPst/XCYxrvVLDo8dcwXQnHuwxX/+U8gGRXsrTSSpsFK4fgN7/QFeWwIbuw5Z9mBScF6h+R2MpWC6CKAS7beEMsZqHcKhX+BIOw8sUFYP0EdFbmX1w3tEwg/djqSBMTQTh/7C6hBxauiNh3DFiEFzx
 TIa4koCG
 ynmNoJsalc4RIcS73OzJTeTXlopOQlxYorpOdQsRhmDEZbRLTAGTDqTiK26P7EfsK7mUqwdlJI4V9OWMf1bzCBRhKBzhSvK8IEu8dpniJI3uytdt+94cdpWyRUvlAHF57BJKZwU2xfVJxd2nu+doPU+GOVFLiC2kiCkVnMksnlJa8XE8ezwExBlfWxPA3e2royZiFPx1mBh0sjg1rXQaFFpq3KdmR8qVeGARE4t0YZ5aZyLkXI8Uz5mwWFmnhEkMI1Mdv+2VReCMY4ia1bVs3T1d3dqxcsLqXc/I1KEhA+QDM4BHm0QHlNxh6dN6B2RbBA/JhrlsNedkCxiZTEPJGVD2W8BxXXitaAfm4aS5EsF/gpMb503ZKw6qpvQiy6D7/G1oYhBd6a7GDRtvZ76Ws/DX3yM1AgpGjctcC1qiIN2BdJ2G99Q7hxNlUbVBnV0ssOQKJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhang Peng <bruzzhang@tencent.com>

The activate_locked label in shrink_folio_list() handles swap cache
reclaim, marks the folio active, and updates activation statistics.
Extract this block into folio_active_bounce() to make shrink_folio_list()
easier to follow.

No functional change

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f3f03a44042e..0860a48d5bf3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1052,6 +1052,24 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
 	return !data_race(folio_swap_flags(folio) & SWP_FS_OPS);
 }
 
+/* Mark folio as active and prepare to bounce back to head of LRU */
+static void folio_active_bounce(struct folio *folio, struct reclaim_stat *stat,
+		unsigned int nr_pages)
+{
+	/* Not a candidate for swapping, so reclaim swap space. */
+	if (folio_test_swapcache(folio) &&
+		(mem_cgroup_swap_full(folio) || folio_test_mlocked(folio)))
+		folio_free_swap(folio);
+	VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
+	if (!folio_test_mlocked(folio)) {
+		int type = folio_is_file_lru(folio);
+
+		folio_set_active(folio);
+		stat->nr_activate[type] += nr_pages;
+		count_memcg_folio_events(folio, PGACTIVATE, nr_pages);
+	}
+}
+
 /*
  * Reclaimed folios are counted in stat->nr_reclaimed.
  */
@@ -1527,17 +1545,7 @@ static void shrink_folio_list(struct list_head *folio_list,
 			nr_pages = 1;
 		}
 activate_locked:
-		/* Not a candidate for swapping, so reclaim swap space. */
-		if (folio_test_swapcache(folio) &&
-		    (mem_cgroup_swap_full(folio) || folio_test_mlocked(folio)))
-			folio_free_swap(folio);
-		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
-		if (!folio_test_mlocked(folio)) {
-			int type = folio_is_file_lru(folio);
-			folio_set_active(folio);
-			stat->nr_activate[type] += nr_pages;
-			count_memcg_folio_events(folio, PGACTIVATE, nr_pages);
-		}
+		folio_active_bounce(folio, stat, nr_pages);
 keep_locked:
 		folio_unlock(folio);
 keep:

-- 
2.43.7


