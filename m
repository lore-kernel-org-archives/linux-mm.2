Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4259ACD5BB1
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 17:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444C16B0092; Sun, 24 May 2026 13:46:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F50F6B0095; Sun, 24 May 2026 13:46:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B2D6B0096; Sun, 24 May 2026 13:46:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D8F66B0092
	for <linux-mm@kvack.org>; Sun, 24 May 2026 13:46:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A165F945E5
	for <linux-mm@kvack.org>; Sun, 24 May 2026 17:46:19 +0000 (UTC)
X-FDA: 84803042478.06.4654A8C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2A9BA40011
	for <linux-mm@kvack.org>; Sun, 24 May 2026 17:46:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DvWzH3mc;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779644778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uBIKyCDUB4AI2j953g540RjbdIOwXHSPmEWd/lmfFd8=;
	b=UoKonIDsrlhihZhOMAoxc7Z2XtqIPCIE0q1iC+Vbo/WM9grjCFZE+IhIr4Pk6xFcK7MWqT
	dge8MrUKkcPHSCvYpeXs5KklPEfGnFGjihknj7ZmHcD5U0sXrbn1ORlgYfw9w0EQIgWgTp
	WRlNEuUy8kAC+uC9GYUKovPBy30tDH0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779644778; a=rsa-sha256;
	cv=none;
	b=THQT3d4PESLs6Ryw4vkN0+updIPoJSBA1BQLRbDyTreI3ANxpS9wrYd4dgjTg8D98cslT5
	tUXKT7zOXvlTvoOHwDxve/dCu6fH6NZjh8rzIlAzLHnEcZLyQjeEl8d8jGB/s+w0jkwdzh
	Et1hw9WeYlS6Rg6Q1txtaipAliaKOBs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DvWzH3mc;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5729F4321B;
	Sun, 24 May 2026 17:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5EF1F000E9;
	Sun, 24 May 2026 17:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779644777;
	bh=uBIKyCDUB4AI2j953g540RjbdIOwXHSPmEWd/lmfFd8=;
	h=From:To:Cc:Subject:Date;
	b=DvWzH3mcrvKY3cjnYwotg5mUYKLb8jHI/4yzSTjUWoxSvfKxV8VO9lcJSONFtzOPC
	 B0WTssgk/v7CM0q3iY5uQkTNV/p9vsB2ID3IDcQZWC35VrihN0v82e2+j+dzpPopa6
	 m8/Dmz82tYqTJrjbSVngHh1RDjVTgdpK2eMmm1sLTW8K7WdIqV2hnxPHW5ckkS4NpS
	 nbKfYxkIddoIX2hjYU16kQFgzIeIrTf6AaBHL2TTuP7q2RDkbiUco1NyRssNjonTyx
	 KVjI6xNkxSdVvQdNZP897Bnr05ksiW0UrShKlGE/fC8DHRpEAIGopnYybrnNE5K7Fi
	 vfQ3n3ZQk/8Kg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 15 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Fernand Sieber <sieberf@amazon.com>,
	Leonard Foerster <foersleo@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1] mm/damon/ops-common: call folio_test_lru() after folio_get()
Date: Sun, 24 May 2026 10:46:06 -0700
Message-ID: <20260524174608.81112-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: xgj1wc58czs5iggpgkcz6ny6krfimu6f
X-Rspamd-Queue-Id: 2A9BA40011
X-Rspam-User: 
X-HE-Tag: 1779644778-860872
X-HE-Meta: U2FsdGVkX18Yq1im7JX/Wv0+xUYAViyG4Xau6LjjsrxBYMALfb+m3PGXR9L/mLS6LAbrcds4owXbodbV4Yh1D5vMbIsIjt/JmNjx52mG9Uzjj40Eb2BPe1Cm2RJ2/sEWVarx2XvgU/mTZ4bUlu+uxxtyt3U1+7cncVXaX9vgm0qoxR7eFQkR+OCxtBgJdd3jII5wGI3/2bRCgVp8lRGCQvLlvmu8y8suA3/9MiMcTc3XA/pSLIQlpmYSV2UHGKLqUMMTu5JksYnVuGHZnvmA3hq6vDitmvysc3xrxJEsnPSFnKH2Rys12Woh2Gg7cYHROvjvnNMjyTIzJ3xcO8+62Vu71sTZFn8syaS3jzm+fqbbhh8qTy+dENDV1x68o07QvQGA9cRMpDBo8hL+UwRwSkEI1vsdywze/mkQlhZN0Q/+10WdMQelUP738s7/9xaWyoPxP1payRyQLeC8YiUNDZifmE6uvLL2kL3NurCoE3lpuEXa33XNByFoGAD0ckzPeZ3a65Dt6gb6CgkV9L5iUDhQxa7dl73FrQaPrbA/6pKCfzqL11C3Zdhz9Q2VVvNERDiHOAxVi9n03dRQnD2i71j5iyb/NMZtecfFyFCZ30a7AT68rS1VNsTt+zvD4itX1RLCtDgR6gu+bRKVf081GfQiXCH21m0zy0ftYO1LzhWirL7cNsJWzdREAvX7i0VKtFpCbgc4O9komYx4uE9FQ4U8NeD1tYILjoE4XwgNZmb1iiYcEc6FERb8b+5IFxV5sTl0PbSkzh83C2k35nu4aBt6lRQK0cghU8AJ9YUdRB1WP8heQKt12bTjY6+/wKkwjTBD+oOW88Sjb56vG+fKLh9Jr7ZMIq+zrKr2/1dVI7Vt2wnMmNRRmPpBT66Mir+/SfymGykNdToucDYtNEQhSOs2qBBNut7Xe9Iuy+qPu4ttEfYvSmBs5lbelXyklmknXMWvnWkWQr08pPMf6wV
 iaDfzwWO
 ZJF2UQibOJvJyXP/nDd0Yi+gIhOxtdyGFsZm9lo/Xk46saTMK7VXR73vAIdblP04tiIMemS11uHPHYcFv3k7Wx7lNgrcvyNvkNcjMcAdJsQUJMNKcJPJ9/wyNmOVnFcShO+/KMu9PE8krKKlAdz/GpI6uKI/VBQcZK9Joc/YFjs3cbsSDUg9lbK7hV23eZA6+tLNgbK9W1ybuHiWqnmZO+u8V+EVdQZd8mRMUARRQo8RhZL9fd7lDPblajtQDz8UGJnIQjJ8qXb9HsAEKh5N5vNZqeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_get_folio() speculatively calls folio_test_lru() before
folio_try_get().  The folio can get freed and reallocated to a tail
page.  In the case, VM_BUG_ON_PGFLAGS() in const_folio_flags() can be
triggered.  Remove the speculative call.

Also mark folio_test_lru() check right after folio_try_get() success as
no more unlikely.

The race should be rare.  Also the problem can happen only if the kernel
has enabled CONFIG_DEBUG_VM_PGFLAGS.  No real world report of this issue
has been made so far.  This fix is based on only theoretical analysis.
That said, a bug is a bug.  A similar issue was also fixed via commit
3203b3ab0fcf ("mm/filemap: don't call folio_test_locked() without a
reference in next_uptodate_folio()").  I don't expect this change will
make a meaningful impact to DAMON performance in the real world, though
I will be happy to be corrected from the real world reports.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260517234112.89245-1-sj@kernel.org

Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260523194145.93122-1-sj@kernel.org
- Do not change post-folio_try_get() validation order.

 mm/damon/ops-common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 3a0ddc3ac7196..5c93ef2bb8a97 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -32,9 +32,9 @@ struct folio *damon_get_folio(unsigned long pfn)
 		return NULL;
 
 	folio = page_folio(page);
-	if (!folio_test_lru(folio) || !folio_try_get(folio))
+	if (!folio_try_get(folio))
 		return NULL;
-	if (unlikely(page_folio(page) != folio || !folio_test_lru(folio))) {
+	if (unlikely(page_folio(page) != folio) || !folio_test_lru(folio)) {
 		folio_put(folio);
 		folio = NULL;
 	}

base-commit: d30b72f4d0d4a88b1162143322bc99b1fce6ea67
-- 
2.47.3

