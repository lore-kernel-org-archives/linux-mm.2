Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF4B3C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 09:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B3276B00A7; Tue,  7 Jul 2026 05:02:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98A406B00AA; Tue,  7 Jul 2026 05:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A33A6B00AC; Tue,  7 Jul 2026 05:02:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68FCA6B00A7
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:02:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB3D0168C39
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:02:43 +0000 (UTC)
X-FDA: 84961390206.16.4A075CD
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id EBD5620005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:02:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mQnCMUt9;
	spf=pass (imf13.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783414962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Rx789viijXUmM3OKxnbqk3KcKhRqEoHeN7taWskeA2M=;
	b=tPdWKpF5RNAwSY90bVIbFIFvaa7hTueEKgvKP6Pr7NL0lnWdRLBiz//OX8wTymcj1ReEL8
	C5+uHfh3oqGHZtzMilLx3F7V7IXSsCOSnaTqgLMVwVV4XUgsADvlRT56V1rcC2xXhFpElV
	m78lU9eGlAdzs8JOqMcOo6vysKUy+TY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mQnCMUt9;
	spf=pass (imf13.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783414962;
	b=Y9rx6o18k+LA0VujHsvXhSSqLMx1GfHwtbMsrpY6NomFOcLLSnHVCBPLwLz7Hg+ITWBTj1
	xsTt7InqNO9oZGaEvIIJloIJ9NyG1je54BJbkjGU+s/BIOwunHgz453gtvwMiw9aK6JUuC
	ttjs85NtITIXS7EI5/PCfDooXvsU8YQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783414959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Rx789viijXUmM3OKxnbqk3KcKhRqEoHeN7taWskeA2M=;
	b=mQnCMUt9hyZ7sE7pI1SC7pOHR7oinKvwkCqrkqNzKHrV9ykAL+pz3kXLPIbrnNZSbOcj9w
	L8d4qWdeTSKSCtsVd91QVqkRMlXT9wtn6J5M+FZYHf08GlghKXnWrIksih7RNkB4d7JKC2
	8zRI/3lSXs4oFTSTPiZmbYt85TBy+Vw=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andi Kleen <ak@linux.intel.com>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v2] mm/migrate: Avoid copying hwpoisoned folios during migration
Date: Tue,  7 Jul 2026 17:01:36 +0800
Message-ID: <20260707090136.52904-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EBD5620005
X-Stat-Signature: qdn594k164b8f5kyxo6gexgq9cqyxga3
X-HE-Tag: 1783414961-529309
X-HE-Meta: U2FsdGVkX18gPa0ovo864AindDBcUH697uxQ2HX0MlFNDLczMF8/vt/16YxF7ss6JkehohoqJJEy6pY0scnTHvmOFoduS45FdoTA6zHa0QO341uuBqNDq8q1BJEBiEZl6ZOwOYAgqwKG5US80DD2+ohPUAN+qy7VwvnvSAQVjJnY4NS5XQHDkjhpvjjhUFQbOKVWQ6DgCQ2ghwS1cEJIiKkbtUqmU32CEZDeDFpQu8oRTE1DwjwwjQT1CdpcjvxCRKLrNKSxmdoTGxRk96wOEa7siStdSyc09JOao4bOIcteMlBPkaAUSRZwxAsvQwmmYOd7hlxL+YF27KNOdYPdZsht2V2fvpftus1Iq1x2s4iINqb2nfcqM1eQVLfhq/MTxrh+srKu+awD3FXwkwBsflydfabQ87buZLZF/noDJTfadhIZaAws99IXz8gHf0t9wvPdC7QgBkPbzMzBbQoxH/pdWz4fO/uDlBbDju06TIE2C80dJKvJA3Qmqb1U9wLPHCQgrzJ7bQjmdU82cVl/ARVCNLMWbYjVaFzH/HtJ1bxFIteCfob6QtrxYLRljhfa3CqgMrhBWTmHYWxcYTJtVU68YFJhwOVRVtlQVrqEyNGenHyH4xnYxWLMgQOjSzwP+QOdH220jyFyEkcDvT3JY8pLx+Wn/ersLSced+ZyLF51BQO4Lx5fWkxypyBZzV0nsKChey+PzwIzilkU3005FmItLabSa9awfWjI8yqkFR9t2BgoZraBItMPVSzM3Kv9iLszNfHCV5thC4i/36W3vGsK/KCmUW+flAjMUrl/3oJcCg4fGBtDwiIR6DlqPhHjtNr/ANZhsOzazoRPjLPsAzRW0ixMUSoxmXN59tGgCO9DM9OJlrKXsMxR8YnW1ZSX659cHFPY8VYHLf9hkw7TodJr8s+vPJBctUKthWIubzvpMqrhNFhk9ugNshGinmtxbxaO1bZhQoDCInNdSNX
 ODYBdJb5
 QrVKmYzn1iXcwJjpjk72CfQv8j5SQK8omLtfLRPZ6m/waLGKTVlxYCs3UVXnGC5QpeDC1HEoZacJVDms6NdMFb52RlRJMMWN3q69GVTUnxQM4Lv0mIJ3UifmV7kl47dER16jiT1OcP8Wt76OONlSmIs+PqfoiBvN6mN3upvGHMCriN5ykzNlDeZZs+8XOqhWvvqVJBliwl+sJ2w7jQJhBpre5LQdC3htJulHGpd6Zr4VQVFlAdmViEKdZBqVtiOkP3KrsUJhQS7IpnqUw2mzJhUSrHsCqHdhHBOY8uhE0+ApCoXM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

The generic folio migration path can copy the source folio after it has
been unmapped.  For normal and THP folios this goes through
move_to_new_folio(), then the filesystem or anonymous migration callback,
and commonly reaches folio_mc_copy().

folio_mc_copy() uses copy_mc_highpage(), but architectures without
copy_mc_to_kernel support fall back to copy_highpage().  If the source
folio already contains a hwpoisoned page, a normal copy can consume the
poisoned memory and trigger a synchronous machine check.

Check whether the source folio contains a hwpoisoned page in
move_to_new_folio(), before invoking any migration callback that may copy
from it.  Return -EHWPOISON so the folio is treated as a permanent
migration failure instead of being copied or retried as a transient
failure.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
Changes in v2:
- Move the hwpoison check from the hugetlb-specific migration path to
  move_to_new_folio(), so the normal and THP migration paths are covered.

Link to v1:
https://lore.kernel.org/all/20260701105544.97059-1-kaitao.cheng@linux.dev/
---
 mm/migrate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index 7301e424f8d8..f4f55a6fc23c 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1098,6 +1098,9 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 	VM_BUG_ON_FOLIO(!folio_test_locked(src), src);
 	VM_BUG_ON_FOLIO(!folio_test_locked(dst), dst);
 
+	if (unlikely(folio_contain_hwpoisoned_page(src)))
+		return -EHWPOISON;
+
 	if (!mapping)
 		rc = migrate_folio(mapping, dst, src, mode);
 	else if (mapping_inaccessible(mapping))
-- 
2.50.1 (Apple Git-155)


