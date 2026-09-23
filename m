Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93E91C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 10:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 640676B00A2; Wed, 23 Sep 2026 06:15:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F1EB6B00A4; Wed, 23 Sep 2026 06:15:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BB096B00A5; Wed, 23 Sep 2026 06:15:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2985D6B00A2
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:15:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E14AA06E5
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:15:17 +0000 (UTC)
X-FDA: 85244619474.02.1D32DEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 06F4F140005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:15:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QGnSIAF+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790158516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7JRcQFcD/nLSCcRzyB24nV92nZBWi01kt7jJ+1f3Ug=;
	b=uYSf1suDCJg2LklRpf164N27CRyntuipSAKoOn5T+mxJr52QgcIqYoO7Lq0/P9NFY2BLCa
	HgFsR3QRMBkw/LXgw8vXgNe2Jced4f8TjgrHqx/9KN6+02QnuMzcuXXDAQFrWH8fhp0BHa
	sO8+Vv/jMksTE2DvzuxPXXBFpu2KQAE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QGnSIAF+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790158516;
	b=3Oc4tmcPY9ydjjgk58S4H0gop6PfxnmHWFn6iRaFibaBNMysdk0Cs8CN7x5fDXPpjgd9xu
	IwnsP8ghNTnjIBxPcYwa8fEVIiY1WEP5z0Gts8vivsI0wNO7Nuv1VRrkgl9GrWfN6vNc4L
	oGNZE9Zz3cQdvbd2Ea2sQyvaG8h7R0A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59B2440E59;
	Wed, 23 Sep 2026 10:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44C91F0089B;
	Wed, 23 Sep 2026 10:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790158515;
	bh=s7JRcQFcD/nLSCcRzyB24nV92nZBWi01kt7jJ+1f3Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QGnSIAF+YAH7QPIIk+YoBktEsy9/RjQmeN5BIv8wzE96jANMKcwFC7A5bMccseKTU
	 RkllXwBOdg5qOJvjV9pNFCiPRCsra8Rej7BXiy4tjyL+4r+uUr2dQBlQw4Jq0Cbg5n
	 +W2tWXmflDSfXKCKYY0vEFo06nTMfc/BKcHDkoujHj4GdxJ2rgni5vU1jf2zqp3AJh
	 /352QzvBMr4n6lXut8kPaUxNvWKIQK5DktQiBhgdS3OiothQ2q1ggHdwpMdFTOojGH
	 rCHsU63C70Q4q5BinpYcQhKOg/sNGDuByxlgqOiDfqjoKNkU/e1kkTd9NSUb2f1fr5
	 CTh2xnLPxs0lg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 5/7] Docs/mm/damon/design: document damos quota goal complement flag
Date: Wed, 23 Sep 2026 03:14:50 -0700
Message-ID: <20260923101454.5748-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260923101454.5748-1-sj@kernel.org>
References: <20260923101454.5748-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: oxfphxy5gke6qf5trdz7bbup4gy1a1n8
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 06F4F140005
X-HE-Tag: 1790158515-281531
X-HE-Meta: U2FsdGVkX1/j/cwpNdrueea7DyrFP5Uu3+ApQJFOarq4II/L3wCEpEH8xCiePGzokFOG0M11n5tT+uG0F49oXXJcfOJE0uYjR4lo7b09ION+xWXnZxUGd80QcVLqGeNIicp/7iJ9ZhZZw6HPdOSdbotQzHwv1KIemy4qlH3YuzQpL4EHTw7+qsJJWzkWgysqjoODH1H1SIGwrJc1yXxvYXn1fnxFS4Nc603Yf+ydURK59PW9aXPSjmTY1hCsfnCJLhgnWAQHKPADgfhs5UU0HkyaPIt7XaEj4o4Bk0L1fVc77k/UReDyiDJJlQt3YToSiO/x63WmfLs547iQdZSOSHs65tYNsPC1Q455pHvqvVo2r46V2kQCg8+gRCqF2t4GWRFc3k67jz3EsKoggdx+gzZqFbVDJn8J/cQqb6zSLUX8Zjx4bojTFtQGXLwLd0dMuZnO/ERY5/MhaJ3qqVGB/jiaV4zdSZQqJGBNM/y8HEuWnry+3nSJMFa7aWipy9V4jg1uTu9abUlaRewocXm3jZZLproWQr81qkUckWA0cOEo1cC+JVMhRo12wQY6poHuTqTFm4j4Yq0Bxgk0/WUe0PL2xxhg+FxTrNLgCn4/DLKeOdeEYnRdmpceRxfvS8Qwfd8J+bSSuBWX8tAK9FJnBjnuW4TuWNknw1MLdcUDKUnA2aVJ9LHsJJ6g5qMzXBKGZHz+KmbLJj1+xywffcbz9/3KUH6G2SBw2OzmyzFWCrhS/BM3gntwvq8+5acboWXj68aWyOLpHPfCoPbuqVwOB18KKcfMCac2DfdNhDojwdVctHxmO9kV3/ZcFPMGCkCaTXTNRrJV/iNjADa0t+SndUGt8F+Rcfmt46t1QOg7mJqBssW5tcibP+zteifpmPjFfcL9ik0LSWhgE+YDXKirrhzcRwS3YegZ+PzpChij0c5ow95z6hO4ouGlGK2xZvV8PyGU91HgKyivZyOHhdJ
 Z/5oG3Yv
 Dbm4GqMwaXFJy5MMc2f0NBGuwQeUIBROvG2uDR1LyKupbjAbXVlGqcut5JXHa0mDzq/JT6+6uo+5l/YqAEAwTPC1eCUngmd+sx+gGJYOdbKyNUmvKR5T1eV7wRmTTMW9SDLcyOnuzd75rMUJYyNOCf7r6I7s17IhL6VK+hOeInsLtmT1M36o/hiA5qX8hyV5yPs4PogUnlkz1ECQuoBwIaY/zfOBhfQXUnJ4EOP0DZUabYjk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added damos quota goal metric
value complement flag.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index e82390e77a70..5cd651b1b7aa 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -702,10 +702,10 @@ There are two such tuning algorithms that users can select as they need.
   that the zero quota is a valid quota, and therefore ``qt_exceeds`` :ref:`stat
   <damon_design_damos_stat>` will keep increasing in this case.
 
-The goal can be specified with five parameters, namely ``target_metric``,
-``target_value``, ``current_value``, ``nid`` and ``path``.  The auto-tuning
-mechanism tries to make ``current_value`` of ``target_metric`` be same to
-``target_value``.
+The goal can be specified with six parameters, namely ``target_metric``,
+``complement``, ``target_value``, ``current_value``, ``nid`` and ``path``.  The
+auto-tuning mechanism tries to make ``current_value`` of ``complement``-ed
+``target_metric`` be same to ``target_value``.
 
 - ``user_input``: User-provided value.  Users could use any metric that they
   has interest in for the value.  Use space main workload's latency or
@@ -733,6 +733,13 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
 - ``hugepage_mem_bp``: Total huge page to total used memory ratio in bp
   (1/10,000).
 
+``complement`` is a boolean parameter that determines whether to use
+complemented value of the target metric.  For example, if ``complement`` is set
+and target metric is ``active_mem_bp``, it is effectively same to
+``inactive_mem_bp``.  ``complement`` is no-op when the target metric type is
+``user_input``.  For the metric type, the user should be able to emit
+complemented metric values on their own.
+
 ``nid`` is optionally required for ``node_mem_used_bp``, ``node_mem_free_bp``,
 ``node_memcg_used_bp``, ``node_memcg_free_bp`` and ``node_eligible_mem_bp`` to
 point the specific NUMA node.
-- 
2.47.3

