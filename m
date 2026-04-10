Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7A53F44855
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F2326B0095; Fri, 10 Apr 2026 08:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C98C6B0096; Fri, 10 Apr 2026 08:44:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E00B6B0098; Fri, 10 Apr 2026 08:44:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A7FD6B0095
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:44:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C1DB9591D5
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:44:29 +0000 (UTC)
X-FDA: 84642614658.03.5F8C959
Received: from outbound.st.icloud.com (p-east2-cluster5-host1-snip4-10.eps.apple.com [57.103.79.13])
	by imf25.hostedemail.com (Postfix) with ESMTP id B7C37A0013
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:44:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=NggYHnO4;
	spf=pass (imf25.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.13 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775825067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+PRHeM3s2DI2yQOSrDPnTDvHR27Fnjgpu54ajqjWKM=;
	b=GMd41sQ08972snCcCKMXB7100wY3EKsoxhdQenGFJQkzYHB/XEWlGIuqZwgrF6ZlvMssGV
	LD/esNoT1Aj4c6QuHEuWFKefoxAGzmivODWuPDkdyIY8xq31slh6OpyEkgHb4nx3dWCLjh
	gMe9MJU2k4Lyy1RGITtzmddyAmT4e58=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=NggYHnO4;
	spf=pass (imf25.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.13 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775825067; a=rsa-sha256;
	cv=none;
	b=thc6XxqqH9cdiYPL3wsYOrKH8NENWuLD3WX/rVQdZd64KC8sECjKOZhBw1mXCfIJqR78P6
	Ynlw68vpg/F6k24OvRRsAd7VI2GJpQc6JlRPaSolmWW2vxz9uQTDFpGTIZjaaCjYeYW866
	m6gBlUZxRZFTg6ixsiC2PXY53dhiRiA=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-0 (Postfix) with ESMTPS id D5BA7180035C;
	Fri, 10 Apr 2026 12:44:23 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1775825067; x=1778417067; bh=W+PRHeM3s2DI2yQOSrDPnTDvHR27Fnjgpu54ajqjWKM=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=NggYHnO4sCFiWf2yFeD6rksIwDpSw5yxCxi26nNqpz/6DmfEeQq/s5yQcbpafCjC3u86NGruNIuxFFxBEfUNrqff969cVpMFeNg9kffWOjSeA2WVFu6R8LCRCc+ktl7hBGCS9QDJZ2+Nt+i+dDtwFwKl2DsS3t384wx51BwUZxlXXb2FqUgTohxH1MztHwR7mUYqWjC+rv8yc7ytntwh2uopoly7RtFbyb/dWdn7hJZbSLq7O6pNmB6SHfHIpX4tIdUUdDS4BzBD1rQGXfjB2LilghNGYo/JpZE4yuACanaONuMVhzLqiR2SmNtWsOUCWrUw2KKOPlclStY7gQpg/Q==
Received: from [21.6.122.162] (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-0 (Postfix) with ESMTPSA id D257B180036C;
	Fri, 10 Apr 2026 12:44:18 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Fri, 10 Apr 2026 20:44:00 +0800
Subject: [PATCH v3 2/5] mm/vmscan: extract folio activation into
 folio_active_bounce()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260410-batch-tlb-flush-v3-2-ff0b9d3a351a@icloud.com>
References: <20260410-batch-tlb-flush-v3-0-ff0b9d3a351a@icloud.com>
In-Reply-To: <20260410-batch-tlb-flush-v3-0-ff0b9d3a351a@icloud.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775825044; l=2167;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=MwBPaFWPFTZ2m6kdtZRGEvS5uyMpPolk6vIxczHd7KA=;
 b=XuRAinfERZ2Os9psc4BxOrW2+d/eB2893MURTJHmBehjAGSD2yk28pf6dvlnr4MR8QpkWRk0C
 GkBfS5+/tOUDxEzBpWDrzBUO114U9QSuMrOTttn1auf5zpTB3m/Ornh
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-GUID: 7VQ5o_7CxGS7jTlLb2DDTJXiqvZ-pwy7
X-Proofpoint-ORIG-GUID: 7VQ5o_7CxGS7jTlLb2DDTJXiqvZ-pwy7
X-Authority-Info-Out: v=2.4 cv=edowvrEH c=1 sm=1 tr=0 ts=69d8f0a9
 cx=c_apl:c_pps:t_out a=YrL12D//S6tul8v/L+6tKg==:117
 a=YrL12D//S6tul8v/L+6tKg==:17 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=tUYT8qNuPuMAWAmJffYA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=R6HnoDE5lksTgPyyjrIf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDExOSBTYWx0ZWRfX4/cDOcCkKePu
 3FbeuyWGTLWr3SZ7vWpug4GM8Fri06MlOfPZODbyqIWdMcBlEiIGf4a18bKniQ62gHVcvmH4WOF
 XUry12O/5NkMvgTyC3m+lgbxWUMwtGYo6eybPYHiawvEhREp/WWgEgMBifHtY4dFmzEziIm5/Fq
 r5Al2wsZ6ahvImQcmgTuxj98XI0qe+27gJq/hxcQDdHBxSuNbxc54k5j/ZrhDQw7NPIHBXGJxvT
 wDxlaE8pykTgfcnx1jBRqDi/Ul9zpZzxHSB5HjdgRlyZfYtusprajOnPPXd1+ANt6WAP0LVxis/
 jAGmtSYsy9TtW5nWurst4XbEI/cx2909BdT4wpl/cPLEpTKg1SShGzvMEuSbvA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_03,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 phishscore=0 clxscore=1015
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 classifier=spam
 authscore=0 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2604100119
X-Rspam-User: 
X-Rspamd-Queue-Id: B7C37A0013
X-Stat-Signature: hr8k7d4c3gc9m3wgium1fsrquyj6t4yn
X-Rspamd-Server: rspam06
X-HE-Tag: 1775825067-110418
X-HE-Meta: U2FsdGVkX1+ufsKSKYkSrt5Itaj+rZl4k9FdtEEZcrcuutxhSEyedrimX+f3eSTtWfn6TVbp3qwoX1k5nrP55N6U89lIT0xwgEAMppPtkRW9JItNWK8iMS8r4U7fak/9p/x6fUz1xili9v91A8GORI/4RDgyRTe5apiKYQNeUHuRAgBbI8jwlNVDYaufrBivGA+qUQ345KQ//QJV0kDYwdVjbZyyl2GlR4D7qpuEDYxQIy8zD3TlwhmmTz4nwEjvLDvccb5FSMaewbGgjUyqg+bwH7I4uFsSElFyHkcUb31qV81Ci/AF/CMCht6bvi0X3b4Y7ReRN++F91vQZ51Kp6FaF7rKmnJtGkbohARE/b4gH78gE1/2HxD24nHFEWYO+73TqB+pTXzeoterbGhtBgLWJzFL8Ap9N08ADoLCE++tuUm7r4HQToAjLPwPqFHMyX5tOOhNueSwmHb/GueLlwj7FygSI1lM0pUDQ55prYsaN8FxOXxEnvWnr0cXbYzpEaRqoOOPmvxlLnDhWPkTiY8xAlxAwiyJeAQp2xEbVWYQ+wQaG3jHzYdYaLw3Hwl+BxDWJsfhs53jHufCHP6eKTyocmd3f/LdZXoCZehpthEihDtRI25fyZuCXbol+Re2DMCkGixXs+HezfxUKxB/T+/p7hUB5N8rQV9j7cSFkKT97XgDNQJyT6eTxWP/bNKzdCV7fUV3FOtiwYIKOPydeobtVW/uoQS9e88MmIvGX0tdPtzjZvPA+ZHdnVViv6HWLQIRuM8n7kIm3PjC9qieizZI21pifeWAYmYRDtkuHjahVDY+0R5mo4d4vGM0VW/0DUustYfJgcHNGUZC8J07k51owqmVch43R/hZuUAbn2+dv+XdJO/5kNNcH0ds0ZVjLVmUq0+jY9mf9q7BJZas8F5ou5pie4aZDNgDHf8aJEgA1aQ4Np9xJZPNBUiP0WIn5NL0OPLyk5xUOIKck4e
 fuk01i1W
 LJTuBk4fj23JxMqAZBUjFDJ1HtUp7D8NNgpo/LzhcH6BDmePXmrKnYR2Jh1b99RofdseWQpyrcrfILYTl46n6Ar6Jt6mpme18zZ1eSAHSnZlmqgm0Sa0mdlzLvbPQu/2l6jp278pMljiTXnSlVx1u007oNqO4qjWZqCGeGgQZeIis0Mxv/x9IyVWctpf30pBwmPJWEHN2rXePvT3JW/0QMuMmYqza5EuCrEIVhFbxpgA9QAS7oTTbsGMQuV23rwwZx3nKWrQdL20CeGu0K5PIR2Vd6S/itb+5HLDczjbJ8f8h32vfbYV79/Y0XZ7kOkDTuSlwpN7m6A2APe2CbVc5V0LQ64dViCB2PLCMfRVSzmrErf7lg12LZVE30sv7h2eiHS5SgCVMqI0mVC02xJ5s6Z6J0ElXGdYrZ/EvvCjcUL+5pi2IHhlAr8sjrH8O6bvgYZrYkSqCDbPtYtUIpQWcqXJeahi3EcW+XXThzhBv6aGN+Y1qSE4X5UPs2+BckHgMxuU7DGViJlyiKCNczXJD95srFCcnZU4PQBP0
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


