Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9EA6F44857
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233436B0098; Fri, 10 Apr 2026 08:44:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 195FA6B009E; Fri, 10 Apr 2026 08:44:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ABE36B00A0; Fri, 10 Apr 2026 08:44:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDDDD6B0098
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:44:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A8F6D8BC0E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:44:40 +0000 (UTC)
X-FDA: 84642615120.13.76DBE8C
Received: from outbound.st.icloud.com (p-east2-cluster5-host4-snip4-10.eps.apple.com [57.103.79.63])
	by imf04.hostedemail.com (Postfix) with ESMTP id ACDAF4000E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:44:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b="lAQGjq/g";
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf04.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.63 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775825078; a=rsa-sha256;
	cv=none;
	b=IDQ8Oazzxcn1hz3q8cZMHVt7HT0q7o3ZEG1WBnLMoq2dgOY06fBKU06zdZyjpH4fTNwSC7
	bul+iF3zZb8cP+J/JTi6hkJMM/s1zWW6425XIhv97wFrPUpGaLBlmEf/Y9lnqnBLCc+PHx
	Eg5Xa+xTvEOZYCK07R9LZ9pTNamMu3Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b="lAQGjq/g";
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf04.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.63 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775825078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yWdo7Hdt7imdUj5xnZfV2DW+WMLcx/gdexYpPpAmv2g=;
	b=6+/LYjM1/WhKLfh07zFL91sJSjMUQtZ8DI1w9lND4e8G131O43Icy/A5ffu2C43YGrJueL
	o/rrTB/LdgFoXYBDzaqwZjpyuU+vWXozGwDV4M/UScLeNVNz236xu7afoYLWYK+B03Bp9U
	o2rV4sP0pNuhIWDRymzTLAVDg3vLA+A=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-0 (Postfix) with ESMTPS id 42F5418001A7;
	Fri, 10 Apr 2026 12:44:35 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1775825078; x=1778417078; bh=yWdo7Hdt7imdUj5xnZfV2DW+WMLcx/gdexYpPpAmv2g=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=lAQGjq/g7UcTBPINXozb+x/3UkwpLgoir36EfHLkOZFF53LMl6GX+SD8KE5ANiyuk6yokiqNt6IP9eSVaRjuExjPuFXOnt+EvaZAAoesfmWxZ3KsxSGUFJQctRHjiW2+oeaDtUesAcfERGFMl5i+flQXawiME5rcHyEv0e94NXo7wDJZaMs/+jJbMmviQGhI7BUj7l9TEZIGfEwU7Rc8boIPFCWSLKvjhmVWNqwY8gdEPxxoMun/gh6Tiv/1Sl1KXMPPo7aE3OrFizcJlBxrxCBSLUkNRseAUDuzFfcDRY1p3pf/eFFgUFinL3VAexPfCXSp5F+DRLFK70IO/riz2w==
Received: from [21.6.122.162] (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-0 (Postfix) with ESMTPSA id 9938118002C9;
	Fri, 10 Apr 2026 12:44:29 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Fri, 10 Apr 2026 20:44:02 +0800
Subject: [PATCH v3 4/5] mm/vmscan: extract folio unmap logic into
 folio_try_unmap()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260410-batch-tlb-flush-v3-4-ff0b9d3a351a@icloud.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775825044; l=3583;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=Y4Ryu6QrIkBwzzotoKqlopBsSJ0saBN29iSqKN2EdmU=;
 b=874860+xk4cJPDuTM+XHgE1UfY0vAlWSFQ3ZmtH1qL9yYregIaV76AyXpDLsziUFjGhheoS7F
 Zy8uaGXlcHMD4FgOU7bm2KY/SMLYbXX+UGM1mLfxQgHcycZhLjINmmL
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-ORIG-GUID: GLk-jVPy0vNigIB7TtleosjzPtlVoQ81
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDExNyBTYWx0ZWRfX9qO4tI6tj5qs
 nx99lE9JTIIKEJKnhJrB9tw8ePCLgV5asT1acUP2SPzD5AQxl9QlTRcL9BzUk7eJzRc+NpY7xHM
 /oiULPiY23Ctngm5QjYkFksqqxpFXIQkSAKG6wS+I6yh/OZx3ekGSsMuEmvbC34edd7VkZ3381a
 GoymUqi1JSUSyn6l/W5M2DyicOdcSn6FdgwOvJhgjmGTPk7umdg3HHm1sWA88yHxvfcXkjPkFDF
 1uxh8Vh0lzQZjLkHgIDc9cQ1jSh/WKTKlQiDftWEDLWJgqQHr+svgNgHFo5lRh0+YVSUCFZ2vAm
 WQAq1qgvhbqS7MAcHkZMEKrczabq1ndCMG7++f5MovWyQVJ9evORZjeUtHSmlk=
X-Authority-Info-Out: v=2.4 cv=V+ZwEOni c=1 sm=1 tr=0 ts=69d8f0b4
 cx=c_apl:c_pps:t_out a=YrL12D//S6tul8v/L+6tKg==:117
 a=YrL12D//S6tul8v/L+6tKg==:17 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=Eai1HigTdSjqxVI1HoIA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=R6HnoDE5lksTgPyyjrIf:22
X-Proofpoint-GUID: GLk-jVPy0vNigIB7TtleosjzPtlVoQ81
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_03,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=995
 spamscore=0 mlxscore=0 malwarescore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 suspectscore=0 bulkscore=0 classifier=spam
 authscore=0 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2604100117
X-Rspamd-Queue-Id: ACDAF4000E
X-Stat-Signature: inaig9gjcixaqqbn7e6yei8bunujrbt9
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775825078-714573
X-HE-Meta: U2FsdGVkX19y5ygC0nTXXflx+dJT082zaM2RprRS/Wpo5TgOVJOZ6+zfdQ6ifqt6grUpMF5wZeqASw7DrADoBIiTQCjAXb79G3Bx9y/EkoeuDVsDf5bpCML0Qqh1IqvxNQ/ifF0T1Hhj+LGcQx2pxuekp9KXJtpNtJ6rj6QBgs22/0s0TTeCQo6zI8WapSaDixQBX0GqQvD7jQflYLIFf+sSVPcMNsNdPmvcSUYzHx4o+JhZE8nMKE+SF7dOZRAJgDNtohpKd/qd7KHxjODbYvbwJQ8lbyqlGOLKoJfIhLZXU/JxfJrvw7hygLJcStQYjX0rZqwZKQU2l9qTmqpFo8Wpj7zod5hjSdgTvPoAfu5VVGknYRsH13KVWHi0SqTDjG75EvywqUUeKZj+gYEKyo1eXdMCjq6NoKdzjOvc3jSPnEJ5Rz/DcC5NPP4jh634nBS7BJoQHVzpnaPORaOEyPp+h4cUib7RAUTZ7JwznN2H/ij2GZovjP3m8ib4Hf+RjBR1qfSOQZp6KmABrgNpXz6kIwOAIN8pPW/XiQdpiqZfxLsO9K8KVsGvo133LSmpQs46oQhb/+tdUMJ2wN/N9QhAYzTYdrivasfkaOGTRkK0QEHX1Oh4CvFiB2HRIQUfZkwStKgnP/NWfke/noLpDDQ5Qf17aMtm1XqjLmMNYuEc/YVhk6GX4LbEh7LgtmvuR5cVpVZejuZNqR7Y/zFOamKoMQXpNPOvVvbdaSmaWSYEoEEc5bwm7jMmTVbxjynHTIjSBtdQVd7cSb4Gz7UcJRe0CKdhDoCsJhy5B8rm6gy5yXaQV1HogvOH9Cjh86idn9LNGLmYbWxBgIq2r4cdAWHw7lyPzocq9MZbcCEH9Dw+3+5L7XcWMW5AejFXhBt9SMA8wWuzyyYx87h7IEnje4VlBh6dyoHmonwTLd7NGW7jT3VrdfUDAMuxgYXj+XQv8wPxRc/djdvOpyeDO9w
 bLLmkmj5
 Oz0RC4n4ve8ylCQ1N+OF3OY7bP1KfcZQV+ebEJzf125KAKVmbeG+YzzJo0X28fzUTvYMzmhp+hnWNtvjT32R5081PdBU5xwJRSp/qvH0YEM8uchf/RCwzr1nQNDSLIw9SbIdcf5HrvyQh0QwnnN35ivJcYZvVEsaj39Mfqe4qVuZLtJfd/3yxIyJvINuEae1jx6lqNY8kYcdPvUA1ZdrrEsvNCyaNegRBWcTFUKdY4nX2PHrjZr0H1wvXKVgquS69LGtgjmKa3YzXluRrmdKdnzofciQbLuDLdNT6tNrbP940gA0yKfvq0ls01JrnVmvgt7CAcgyT8rsScLyO1dOFH4iywNngx0dpzYfolOAXy9rpmjjwfp93x3p7q9cO0ItKjRfanckLEMUqILoSgltyoieeRFD9BtQ1aT//b+QZh4fDTxmDiy5rQUhUGBFRBFebukjPME6ntsplCmBNEdj8r3PIPTBYJdS8CiJ8DOd8jqm6eYnlsTkvZE8JC/Ux/obRQw500E1t5PKi0IVlmCVQjrH8n1UfkhS+yiu/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhang Peng <bruzzhang@tencent.com>

shrink_folio_list() contains a self-contained block that sets up
TTU flags and calls try_to_unmap(), accounting for failures via
reclaim_stat. Extract it into folio_try_unmap() to reduce the size
of shrink_folio_list() and make the unmap step independently readable.

No functional change.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 70 +++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 40 insertions(+), 30 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c8ff742ed891..63cc88c875e8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1217,6 +1217,44 @@ static void pageout_one(struct folio *folio, struct list_head *ret_folios,
 			folio_test_unevictable(folio), folio);
 }
 
+static bool folio_try_unmap(struct folio *folio, struct reclaim_stat *stat,
+			    unsigned int nr_pages)
+{
+	enum ttu_flags flags = TTU_BATCH_FLUSH;
+	bool was_swapbacked;
+
+	if (!folio_mapped(folio))
+		return true;
+
+	was_swapbacked = folio_test_swapbacked(folio);
+	if (folio_test_pmd_mappable(folio))
+		flags |= TTU_SPLIT_HUGE_PMD;
+	/*
+	 * Without TTU_SYNC, try_to_unmap will only begin to
+	 * hold PTL from the first present PTE within a large
+	 * folio. Some initial PTEs might be skipped due to
+	 * races with parallel PTE writes in which PTEs can be
+	 * cleared temporarily before being written new present
+	 * values. This will lead to a large folio is still
+	 * mapped while some subpages have been partially
+	 * unmapped after try_to_unmap; TTU_SYNC helps
+	 * try_to_unmap acquire PTL from the first PTE,
+	 * eliminating the influence of temporary PTE values.
+	 */
+	if (folio_test_large(folio))
+		flags |= TTU_SYNC;
+
+	try_to_unmap(folio, flags);
+	if (folio_mapped(folio)) {
+		stat->nr_unmap_fail += nr_pages;
+		if (!was_swapbacked &&
+		    folio_test_swapbacked(folio))
+			stat->nr_lazyfree_fail += nr_pages;
+		return false;
+	}
+	return true;
+}
+
 /*
  * Reclaimed folios are counted in stat->nr_reclaimed.
  */
@@ -1491,36 +1529,8 @@ static void shrink_folio_list(struct list_head *folio_list,
 		 * The folio is mapped into the page tables of one or more
 		 * processes. Try to unmap it here.
 		 */
-		if (folio_mapped(folio)) {
-			enum ttu_flags flags = TTU_BATCH_FLUSH;
-			bool was_swapbacked = folio_test_swapbacked(folio);
-
-			if (folio_test_pmd_mappable(folio))
-				flags |= TTU_SPLIT_HUGE_PMD;
-			/*
-			 * Without TTU_SYNC, try_to_unmap will only begin to
-			 * hold PTL from the first present PTE within a large
-			 * folio. Some initial PTEs might be skipped due to
-			 * races with parallel PTE writes in which PTEs can be
-			 * cleared temporarily before being written new present
-			 * values. This will lead to a large folio is still
-			 * mapped while some subpages have been partially
-			 * unmapped after try_to_unmap; TTU_SYNC helps
-			 * try_to_unmap acquire PTL from the first PTE,
-			 * eliminating the influence of temporary PTE values.
-			 */
-			if (folio_test_large(folio))
-				flags |= TTU_SYNC;
-
-			try_to_unmap(folio, flags);
-			if (folio_mapped(folio)) {
-				stat->nr_unmap_fail += nr_pages;
-				if (!was_swapbacked &&
-				    folio_test_swapbacked(folio))
-					stat->nr_lazyfree_fail += nr_pages;
-				goto activate_locked;
-			}
-		}
+		if (!folio_try_unmap(folio, stat, nr_pages))
+			goto activate_locked;
 
 		/*
 		 * Folio is unmapped now so it cannot be newly pinned anymore.

-- 
2.43.7


