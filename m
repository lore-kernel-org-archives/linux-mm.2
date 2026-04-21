Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C960F327C2
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 08:51:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE9276B0088; Tue, 21 Apr 2026 04:51:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99B46B0089; Tue, 21 Apr 2026 04:51:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9888A6B008A; Tue, 21 Apr 2026 04:51:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 838F36B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:51:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A15313C1F3
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:51:20 +0000 (UTC)
X-FDA: 84681943920.23.F640DE8
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6AF1DC0003
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:51:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nxozh7iJ;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776761478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=e5SgX+YVafdn2U1XYnpSWmBJ2zn5M8P1GrVlF6dB2uo=;
	b=H4+sgvfyGan85nXKcug5YcR+5QP6Hg34kXfrLtu3YJHD7RJ2tV1R618/J0/5nclaAdjp01
	sihN1Zv+aR+sEwnBuvS9wbI+Ju+gP78+ZU4tdxSbcbBDx7ZoXruFWB/kGXIJM9dT0vixyZ
	KEHzsjopGWUX7Y3C117bLt41ybH++s0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nxozh7iJ;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776761478; a=rsa-sha256;
	cv=none;
	b=XKg7NK8cISk2qsNi1vjHexrnNFqMVpGy3vri7J+xCtY9FYsvoU17n0oyEbvk0dY21A0kw8
	L8Tm61VJMYrHSYfH/v0yYQ49ItNRvHbcUmvMwiE95/Nv18htvT3Yo5lJhejIToZbCgdn6t
	jNNlaaTXxxujx/Qi1RKdHRMnPXGnTCY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776761474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=e5SgX+YVafdn2U1XYnpSWmBJ2zn5M8P1GrVlF6dB2uo=;
	b=nxozh7iJhH0uYNAXFWM6wRe3FVGgAOfJ2tTWLn4SmSNO7SRk61ymFb3phZSg4iZBL1cRPH
	S6ynxJNRzbGOhxmHPbSkq3LRAET6b34F9DWN8A+RgPZ5rJhT4FigS1RejJrlGSPZPul1a8
	qcOOwzdT/p4NOySUSELC2w2xxZDNIVc=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Jann Horn <jannh@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: handle potential NULL return from anon_vma_name_reuse()
Date: Tue, 21 Apr 2026 16:50:55 +0800
Message-ID: <20260421085056.26033-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6AF1DC0003
X-Stat-Signature: zkigspdnoixjeqzjc7tw6m9cg6thooja
X-Rspam-User: 
X-HE-Tag: 1776761478-36456
X-HE-Meta: U2FsdGVkX1/WtMtUb21CKJQItusFpp/YZB6CQEORzSEePm1kqaHF+uVEABOgqaPhLtBIeaPRrIWuYgsuzgzEcvw5m223xi0ds9emBycWuhtdy841xE4sW6jv2U1Et5zzU+8jy+wQC2SgwwgcLWNfxpdaw6DpZ+ZuUpMc+tPKxe6DWPDpEajbMn/xAn67tqrW2J1M10p5hni+oaL3qtpSZ6S+RxAnaMaQUl403pARAqqzj4qEdhJg/Cy4BdB6hKDyDyqO+KlGymfextzPk96r/0aP3H0b5GuaqMFJSVdiblY68fUdNpm17FG5aTaniHzZJGHGRdnPx9WX7TvysSsJajEDF69i6xqBgrl91iTd21lng1oFmMZIOVSnos0fMyFw50/nfHk+4tUfoqV5VJf2sazW9+sPW/XjBKk5c0dmAKZzw8thIP7DfABlmwoVazMtrx6q1nP9hZrHyzwaM0Lj615RKlb48Fu/BN4RPFW84+f4QTNDR8X81zJfqI0N1O9Rina+1SSNtn4MxmFJ4/FCEQJbF0Xgldk4AVH9UFgVelaqfYvoBQAgjA1c7TnlB9F2eBqfHBU3Ze3I2/yxUeiqwzVDEqI563o2I4aDJ2IMnGspSb3vzMn/8NtxLWqQ1RW464dJg2wJDtZDPf/XHeLSg1vf8n6Va7NhboNSI8ms9qrwh7ElWnM7Oj2eaDAeP8c9BEjV0niF/xc0iedphsSEv1p9tr+Q4m0evD9J5zh/qMY0y7tBVLQWbLRve73AXW0gM8T30GGeRRFjjxYnzuNnimztssqrfZ3EUoBo0HmQAFq/C5CIt+6223U2A4SGSxrFTsUCn38cjWI/e8W/3fUjn/g6rjOT73qPH6D993BSsbcuHEsuT5zrUVts9fUvy5IWiXLi+8amA5jkZ+YXehhYG1aL3sMSqnEjLmKhuXgPtM8lShBrDs2DQt6M3EnPUCQWx5DN8SpBXhr+3ZFVvs2
 6dILD/9/
 gh7Q1/Tew48Nc2PCM7JcpAGW46nngDpfJIT1NBA1ykWbnuaxZ8N12XhoRtozxkZr6J3dCBsTPC77u0iR31dKZnPbB5xG9ms9mz/+DBfhu4qUSpIWqxX1vwOvOOmIZQaOfNjsaIUxOmyVdPHub1D9lUPw5n6xatRa46Vy2igfoSy9SSe7dlfcqi6A81LoP3qeDFTv35hCNF7FFGUU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

The anon_vma_name_reuse() function may return NULL if memory allocation
fails in anon_vma_name_alloc(). Currently, callers dup_anon_vma_name()
and replace_anon_vma_name() do not check the return value, which could
lead to NULL pointer dereferences.

This patch adds proper error handling:
- In dup_anon_vma_name(), if anon_vma_name_reuse() returns NULL, emit a
  warning via WARN_ON_ONCE(1) since this is an unexpected condition.
- In replace_anon_vma_name(), return -ENOMEM to propagate the allocation
  failure to the caller.

These changes improve robustness against memory allocation failures.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 include/linux/mm_inline.h | 12 +++++++++---
 mm/madvise.c              |  7 ++++++-
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index a171070e15f0..9bbaf8287806 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -421,9 +421,15 @@ static inline void dup_anon_vma_name(struct vm_area_struct *orig_vma,
 				     struct vm_area_struct *new_vma)
 {
 	struct anon_vma_name *anon_name = anon_vma_name(orig_vma);
-
-	if (anon_name)
-		new_vma->anon_name = anon_vma_name_reuse(anon_name);
+	struct anon_vma_name *new_name;
+
+	if (anon_name) {
+		new_name = anon_vma_name_reuse(anon_name);
+		if (new_name)
+			new_vma->anon_name = new_name;
+		else
+			WARN_ON_ONCE(1);
+	}
 }
 
 static inline void free_anon_vma_name(struct vm_area_struct *vma)
diff --git a/mm/madvise.c b/mm/madvise.c
index 69708e953cf5..ccb937a37e70 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -118,6 +118,7 @@ static int replace_anon_vma_name(struct vm_area_struct *vma,
 				 struct anon_vma_name *anon_name)
 {
 	struct anon_vma_name *orig_name = anon_vma_name(vma);
+	struct anon_vma_name *new_name;
 
 	if (!anon_name) {
 		vma->anon_name = NULL;
@@ -128,7 +129,11 @@ static int replace_anon_vma_name(struct vm_area_struct *vma,
 	if (anon_vma_name_eq(orig_name, anon_name))
 		return 0;
 
-	vma->anon_name = anon_vma_name_reuse(anon_name);
+	new_name = anon_vma_name_reuse(anon_name);
+	if (!new_name)
+		return -ENOMEM;
+
+	vma->anon_name = new_name;
 	anon_vma_name_put(orig_name);
 
 	return 0;
-- 
2.43.0


