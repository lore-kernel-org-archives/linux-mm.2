Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DBB6CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 14:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCBCC6B0088; Mon, 25 May 2026 10:57:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA3476B008A; Mon, 25 May 2026 10:57:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0C76B008C; Mon, 25 May 2026 10:57:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEA746B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:57:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 532DB8B00A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:57:46 +0000 (UTC)
X-FDA: 84806246532.30.1E16B40
Received: from outbound.pv.icloud.com (pv-2006d-snip4-11.eps.apple.com [57.103.67.63])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4CFC94000A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:57:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=Nt58n+BQ;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf17.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.67.63 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779721064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vYeCbJz1qvnDRDXrZFPnGvD5lPvltNFcb/fwP8QSlLA=;
	b=eEY8n1/pX8PAYhGqtGc74NYDKjXeaIuRzoTjqSix2p/TUxvSUPMCzko7Dl/2lcnZohpcDC
	KAZ9n3mHiTLQDtaTJ07+OroBjmDVS2oPhZIWeuu7C69P9Gsbw5WGY5eHKPHS+3ZDvSF3db
	NYPfKeyAcUpKzcrYaHFc46Q+tzZ2v2I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=Nt58n+BQ;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf17.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.67.63 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779721064; a=rsa-sha256;
	cv=none;
	b=sX4ep1TioQgFCYFNjRwcdA3LdeEWsKTCy19IyLTN+FP7KZK+VM66b0G3rSBvrc737UGS2u
	UUCtm6lM5OSxfaEDcxWoqt6MgnrvKbfa7wOw6oOw8tQ6WfzH/ruF9y1R/iAN/GKAgDD6Qd
	lAqrbfKLiLH7UE24tK7Xj5lvNtjBNq0=
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-11 (Postfix) with ESMTPS id 2FBD418000B3;
	Mon, 25 May 2026 14:57:39 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhMHV8FRQNBF0kFWBcOVk1DEUMdUhlfH1cTVhR3AlEcVg1XQ1QEX1BfHA4EVAddBV1WUAJaS0ATBEoDTV8OXh8EF0YZVQRHHl1WQxsZAlEcVg1XQ1QEX1BJDEFQbFoARxdIHV0ZWW9QXRwOBFQHXQVdVlACWktfGV1FD18HWQRADEoGQFUKRhNRVUcBVUZUHEwLW0BBXx9BFEAAWg9SVkZYGlBdBytbE1UXRgkZCF0dB1hHFEcODxlaFFwYUw==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1779721063; x=1782313063; bh=vYeCbJz1qvnDRDXrZFPnGvD5lPvltNFcb/fwP8QSlLA=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=Nt58n+BQ471CG0lbBKFMrOjiRTvJYWpLtMo0f07CvdzLhvgjbyJiLARQ5WCOLwhFgV4kgGae2DbdEqmkoKTjYdr/pDSpWi5fK+WwkaY+1GVqD2kyOKD/36F56VGTflxrZiNJ5Yw6Wrp98LZh0hVwRAuWI0XmLtKvOM47eQLMBEAfZVR1aZknBTuA+96QnVfXhTLJEssbxMNlGomGkJqqRmPrVyJRSNLMO2fTilx3JzS+dg+/PJKZCGexKD9glhavbmi1deGsh0EncUNx9CgYz07lYP7BG6OeOOlYtUa/HKRhJVFtLhiONZY5yvUGe7wBWp3uDYXGNKp2UeewC81lgA==
Received: from [21.6.122.162] (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-11 (Postfix) with ESMTPSA id 8D31D18000D1;
	Mon, 25 May 2026 14:57:34 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Mon, 25 May 2026 22:57:17 +0800
Subject: [PATCH v4 1/5] mm/vmscan: introduce folio_activate_locked() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260525-batch-tlb-flush-v4-1-83789d6abc00@icloud.com>
References: <20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com>
In-Reply-To: <20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779721049; l=2251;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=s9EbIFh/LV8iPlyUTN5QDlVlv2e5tCPSHPTZBWN4pmg=;
 b=Q9hFLErSWCqkSz9LhQiyJcXUqZ73JcbBE+VSQfJkIPsQIu6C0SsgjkT7qcNrbu/dskgodbytC
 fbc3JevNMVEC4fG6KrjSyQZrlDQ+IwOe9pX21+h4qbGSTcHLbfr1n4r
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-GUID: 4R-4Yspfm7SXYI4kHMakN0x1YTQYALGO
X-Proofpoint-ORIG-GUID: 4R-4Yspfm7SXYI4kHMakN0x1YTQYALGO
X-Authority-Info-Out: v=2.4 cv=Rq3I7SmK c=1 sm=1 tr=0 ts=6a146364
 cx=c_apl:c_pps:t_out a=azHRBMxVc17uSn+fyuI/eg==:117
 a=azHRBMxVc17uSn+fyuI/eg==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=67y7PdGttH7DD6AgI8EA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=R6HnoDE5lksTgPyyjrIf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI1MDE1MyBTYWx0ZWRfX9oMhjyYCbRfH
 SVyIBplsGl3G/r6bWvuKFXx8sq+EpQI13Bpvclv7Wet/3GcViasapcyuIAQ+AEVVIhssSietzx4
 xUffNfWIIo9UIjU7wwPW7CJOl9ls7Co1Np67i3XVWQsIjedSzJbPhpltkq1YkdG0JSeJ88aqkRR
 Jcc7hsVq0QBB+KO8DKMHr1+OVkYXaqP+WBE+h0Exw+/CJmNQwzpyOiAw34zTK5pRD330P7HI8M9
 hKdMSTHpcRGCWUwQnPylyo8Uhm+/xXlUcNPwRyYLHyq5trvNb0mxgnBoeIgvI+8dR0Z6pNCkU26
 qTWmToWJ4Udmecdb2ucelNnjgffDU3L7+7GbDBfzBXDZCB6sZLrnRiFMUyfWMQ=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4CFC94000A
X-Stat-Signature: nhugi9mzxna9ozute4c7htmh6u4wyf3o
X-Rspam-User: 
X-HE-Tag: 1779721064-289180
X-HE-Meta: U2FsdGVkX1+gd6ejW1+v5L++zo+hMzIoivfjcWaPwPejPaL4Q3wEB/NzzD5wHMa/PLP53WFulmYBq70A4yaF3l4oUpLCde9FVfrTLLReZu8liEul9ma4XAH9ubbMKVFElo/ED4XqKA9iBuoYhJw7loFQaOiobAJlC8LH0zlBybaiOblni069OWESE9QmYpk2Wg1un4kC2F+upjn9kOvzIbusf2myk7jUo8qZ94G2LO7Mp+1bKhFt/kLM6pB0bufWFqHpZC9S7eZuyB8moW4oBIL7ClDL9J4QjhVy5GriWtKV7lQRqJJ27jWJjwl1G2kmoXLDFJfC9ZHIr95W28WzOUII4wE77cVb0PvS1HPhWf2j2JmWuNAAhjl2/4MzYpJQgkG1gP986IYQjy7MZq/chBe0dTqCxE+16opbuDkLLfy7BPEIaCTZed6o31JNTS3CDKYoTpz36Ta8msTOHhjzYlH+OZCk2RE+te5YwYkqls+9XWvp/9dFlf/gl2evhHxPg81L2JITVJJxMEksqZZGPXLjPmCqIyFo2iL3h3WqAHFch2Gi7gAMThLRk+sqGaWkLovsOx8CcAdOlBBmCWDyivZKgAdsd8Of7DCXobtmqR9+STSvCkevRgzKrcrRttpMPI14TcEKx7H402zIRUzVBbXSwYJ+WxnTLKIV1T5LMmVkL23l6bSa+hN+zcgW6pXWNOXy33Csn06pWRJAyFbGbeaRo2C3cPTU/88iBZ8NSZjIBuJVHpZmRNI3nosbLz7ApwOrTf2rhVaIWvOn5FtfgCYzdQj7VwB9JHXppyHL088UZWGJJoZPhUy7lmOlF2Zje5mexIqRwR3ZXPkFcQ0TySQPEcZYAoFLSUl5O88h6l5oVnUHQpxEjFAWThzqQcVXchU7VHsSgqe+cfIyBiBAv2pSLAdwx8ve9b+aWVDqdDg9o9WZDjfmMD/bL13vE4rwH6Nf/iU2xpnT3XngJRv
 n7Pv1xCP
 tSkARjwHH0xzvrj1GIdaNY7T1hU+5pVjMMf2FzkHJ6ICLgL3luPjalWWQmsmp5f9G7LuyOzrR2SasnQla4uggBQIz9u8FpJ+XkJNXWvXK92+kInllcTTEsMt3sAR3Mn3sFMnjn5zRTEl7OURwTDp/l5aTTxl9O0lCRiWpwVQGIn5VuMaQ+RRGTySb9opFZQIlVC8SW8peIsxufxl0j2MVI2lE+gmcpRZDiBZddNkXJmxF1AFtAnEas19Nm+mngK1p3AT2j/r8OTqGR8VHoVCS9BkeQD7aFICtd2DQunVviWvNnBtJ30DA+ewjv5ha/b+dLbhWBOp9vfN9y4b/huMGU+kKgUHKlgoVNo6rJiIXY9RqmbYwHlUNzbs5nK6jVh60c4tvABYuFB1Nj3HNRiRPJAWAdcbX/AWFCSekPJlQyGWTedeWa/MPD0X7SGwvjZEomrZHMlOTj/5A0OMskvE+9i/eM4yDyQzbijACPaGqJ3XLtEGKg134YT+fdZEg8AguJ59WNe1sPDbKKYiAjOOoFysTp2EXllxlHuLr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The activate_locked label in shrink_folio_list() reclaims swap cache
when needed, marks the folio active, and updates activation statistics.
Extract this block into folio_activate_locked() so it can be reused.

No functional change.

Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ca4533eba701..886d8b4843aa 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1050,6 +1050,28 @@ static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
 	return !data_race(folio_swap_flags(folio) & SWP_FS_OPS);
 }
 
+/*
+ * Prepare a locked folio to be kept active rather than reclaimed.
+ * Reclaims its swap slot if it will not be swapped, then marks it
+ * active and updates activation statistics.
+ */
+static void folio_activate_locked(struct folio *folio,
+		struct reclaim_stat *stat, unsigned int nr_pages)
+{
+	/* Not a candidate for swapping, so reclaim swap space. */
+	if (folio_test_swapcache(folio) &&
+	    (mem_cgroup_swap_full(folio) || folio_test_mlocked(folio)))
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
  * shrink_folio_list() returns the number of reclaimed pages
  */
@@ -1525,17 +1547,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
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
+		folio_activate_locked(folio, stat, nr_pages);
 keep_locked:
 		folio_unlock(folio);
 keep:

-- 
2.43.7


