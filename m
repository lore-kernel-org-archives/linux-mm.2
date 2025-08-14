Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4443CA0EE3
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 07:38:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5502C900107; Thu, 14 Aug 2025 03:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50250900088; Thu, 14 Aug 2025 03:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43F8B900107; Thu, 14 Aug 2025 03:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 30655900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:38:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD0641DD8A2
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:38:27 +0000 (UTC)
X-FDA: 83774560254.30.397DFC4
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2665D16000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:38:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gPNbLCku;
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755157106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2Up7LN5pRzzuJ/r68Q6CcBRepJ9T84L2u1jpkC+lZmQ=;
	b=fPyz22FQhz+tEMYfKmFb/0hmnPw2mMsoigHGhY16txRikYXHNAJR8l8DvfDgMoeqvUD+1j
	GVyrVBD91Wm/HdOJ8lfiv4xqUGqa/1zdjFL4XYxql02iduaxp9/Q+1SV6Rp044gdYJzds3
	+9MCeTKNgZgH+9WQg+FaPeQl9hZ76N8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755157106; a=rsa-sha256;
	cv=none;
	b=j0bEBzPuhk8c802oB2WQZgaqD7oSNgg7/Bcc4+t8HXvFcD+hwlEZvrsnqemDcvE7TWcLR/
	xl7sM1OK5SpnLksKAc2If/CpKgtVqArb05yvKUMSD9nJJEK4hBp/21dJb3Ji/Aex1Qptpr
	15URYmOoUCc+CxlLfCBivFgran0Dslw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gPNbLCku;
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755157104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2Up7LN5pRzzuJ/r68Q6CcBRepJ9T84L2u1jpkC+lZmQ=;
	b=gPNbLCkuG4AgXYU6MmRUxyf21L4YUDuC6QJRvH4xEOxg1KY8TblsTk2iQ4WBFLHA9DiK80
	Ntki8FRNYVS3Jd46hHeLeCA8WFnPt/Ru0usafdN7z0cnzXtcJAnaJ4QcX/lToQzve+O3aO
	4seSCVe/Fcpcce9VEQj6+alAxzDP2h0=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ye Liu <liuye@kylinos.cn>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: Fix typos in VMA comments
Date: Thu, 14 Aug 2025 15:37:59 +0800
Message-ID: <20250814073800.13617-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2665D16000D
X-Stat-Signature: c49xt4xewnenhzek8bnamt1dcf5kjchh
X-Rspam-User: 
X-HE-Tag: 1755157105-307523
X-HE-Meta: U2FsdGVkX18kklHGCges8RdJdP1StuHvBpjCOlve1GUQiyjMoidQQ8Dm7TIMBccr5MW4cObLmhEowwZa7SL9oYGeSfgPtOq3dMtbNv0GlfDOpuGPQkMpZR5bA2pYf39Bm62aM/mr9Q9FcaMZWLiuXSTT/GJ0Hmk7KEkjwnRsJEeVvNLRR46ckXNOqylWMniKgMR33uUMc/PMjO/gI4HFYRpSIOGdoJsOrm7ZHpqoQJGg2B/CXBop2IwMRb2xZcRGdcUqP2ZU4RR8il1IEKiGpcCNVIpG/h/jn43jVdzheU+OB5Vk71E9zlbNGr+lMv4bZsC4ChPncYZTmGHRe4H5Sxmvh+rK0jDynWEHHD/jrqh70lS+D6ZX/YNzrZ66CUAVXQJDZVEGx1DCpPzMHj2oHsbRsixmxjDRcSt+I6S6Q2X+GimbuQDOYaz9Iq06cAVnyCfRqQcHgteKfQXlyKdg0jbYmvDe76XRFj2FeYsWL0kuZ8mlCFbewi51uxORKR5aynsDJizcEuTzhLdxZ13E0NVxSB9FyRmcc+Q8lTVcClnsvwrQ2XLuvJeU2qjnwfw7iN05WsdW9KyZ3rnrZ8DrPSwAfrtZe/J5Nwss1BkhIYFP1nhyb/KK+S7UcQmpZmG40fSFQVI19+fAugQoS38aMGjVJEoJBzXqY/GZKOs+Aufie/gXj+lRgBymCk8WTk3wCf2yW/hNXXC88IcXktpe0yxBHE1buy981jLLmQvveHb6gSIIm+sorn10nLkBp7wyzcMe36Nq8aBZtnvm7KcU56IW3TpJl09BpzriQdKYu4Mp9l+4Z84GBP9tIypar3oCpQJdPKrwMkCoj70yGD5Gld5+k64SwY4JL1um8k96CEovwTVCbPB/PR9wrPDXG0y+3foHfW8VYvl5eWThk5ygE1qN8b9XudLlmbVpvaV36VUcEj/UD5b7YsYpoIpSNhgPRJR4FIM0miQ2yV2lYsc
 tLXWiqsg
 6CctS86QPE5/1GE60Q54Q6Gkc4Ccwy1ejy8kixjIXuVGKF/O1Jz5AuaV/z9Co+YiPRsZD7Q26sHscyN2RCY/tH1BmFDR89XF11isk3nNnFrS+slmn9ujsK+TdHPxY8H3YWgcaClsBZOdVvVfKc7BoPcIKn5KYcO24bLprVJDohpj4G2V7Oz5bYce9VdzGLqVINSiw7Av5pGsEqGkNiU5TweQw2GQHNYg1QfE3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Fixed the following typos in VMA-related files:
1. "operationr" -> "operation" in mm/vma.h
2. "initialisaing" -> "initializing" in mm/vma_init.c

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/vma.h      | 2 +-
 mm/vma_init.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vma.h b/mm/vma.h
index b123a9cdedb0..bcdc261c5b15 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -145,7 +145,7 @@ struct vma_merge_struct {
 	 */
 	bool __remove_middle :1;
 	/*
-	 * Internal flag used during the merge operationr to indicate we will
+	 * Internal flag used during the merge operation to indicate we will
 	 * remove vmg->next.
 	 */
 	bool __remove_next :1;
diff --git a/mm/vma_init.c b/mm/vma_init.c
index 8e53c7943561..d847c6557261 100644
--- a/mm/vma_init.c
+++ b/mm/vma_init.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
 /*
- * Functions for initialisaing, allocating, freeing and duplicating VMAs. Shared
+ * Functions for initializing, allocating, freeing and duplicating VMAs. Shared
  * between CONFIG_MMU and non-CONFIG_MMU kernel configurations.
  */
 
-- 
2.43.0


