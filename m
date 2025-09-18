Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02FABCAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 03:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 085E08E006B; Wed, 17 Sep 2025 23:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 043698E00AA; Wed, 17 Sep 2025 23:47:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D55568E006B; Wed, 17 Sep 2025 23:47:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C0AAC8E00A9
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:47:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F64C11AD05
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:47:08 +0000 (UTC)
X-FDA: 83900985336.05.7E8B158
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf04.hostedemail.com (Postfix) with ESMTP id 470C540003
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:47:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=G0v9Xvi7;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758167226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sYxzI8uxfIUVEucc9dtDZh68r/k0MKv1E3eAeGSpuhw=;
	b=EwsAP0eN9pRzmciQ7rZcHinZWdMgZHpjbqoLsP72dFLWxfl8Jy1mzR+Ok1ql/p4j1gRfjo
	pjlDxvdIVg0XVrjwErZK6t3i6O90ojpvf/yqFDpb5jp7BKpgUS63ydH18xe6OCkyNVfFQz
	V5DP0nkqJClnBpfZ52bjid1w7GOO7I4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=G0v9Xvi7;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758167226; a=rsa-sha256;
	cv=none;
	b=Q9JR19ObNz5y7Dy6tleXe3D0CDnCgFwRZETHR5X1NBuJ57lvXzPwCs3e7siyv+XW4SJfx3
	BHE2+gh9XuuwVr7mqt0Fs7o+SzXVcVJ0+VCt2OsJUo7dy6A7jDqeSHF2krx8aDVceadYQz
	ygZwj4L5fqzR0IaFbujs5Hx3DjaYgPM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758167223; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=sYxzI8uxfIUVEucc9dtDZh68r/k0MKv1E3eAeGSpuhw=;
	b=G0v9Xvi7KlyrbdMLnL6/s1VQEGSxTkwzY/YLuLJLndEvGGX5G5ooOzkUF04kpqBOX4+BUX+6OPYy6SpiP1egALp3ivDsFx7wvNlqU7Ga2bJ0BsqdITziTuZqTKOddkHFpjh2qPYq7lJbUpmEfaJVSQ3ePr+wha7EpOSL1qGzuuE=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WoEU2v0_1758167221 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Sep 2025 11:47:02 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: david@redhat.com,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	hughd@google.com,
	willy@infradead.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mm: vmscan: remove folio_test_private() check in pageout()
Date: Thu, 18 Sep 2025 11:46:53 +0800
Message-ID: <9ef0e560dc83650bc538eb5dcd1594e112c1369f.1758166683.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1758166683.git.baolin.wang@linux.alibaba.com>
References: <cover.1758166683.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 470C540003
X-Rspamd-Server: rspam05
X-Stat-Signature: pjr97dep37tu1xwjxqah5ckbbdocgsde
X-Rspam-User: 
X-HE-Tag: 1758167225-51706
X-HE-Meta: U2FsdGVkX1/SrvgXhLckvgY/kBMCw28J9ygyNI61+153fMx86+ZrgyLY9VXY3xET7/XcTtqzt0XEFOCtyyIREqyJHCSS5mf/N8RPXtVttPXZka8NQtXFDBqcTqKzeZwPTriz6PrOytdBcLZltgH6TbPgrTfVzlB96eNTNDhFBddlnNFlsA1op0zyzaAiIJeFtfkJA3VUHhSDijVldr6ZA+zRLlqzPGsnHAI6XVylGF/g0GRqjxmbWD8c/bwMQmzHDCTCu3hLbaaNxinV6Bs4coewCXA51nvk+DOELX4M+e9iVkEkt/4EjNcEmr4tDlqqp1Wzji2vUjdO+c82IBmVPI3qeun7ZajAq95F6FhWIFq/pPr/QNTjwCtDpydkSkDc2gXQ0Xb9/q9fSA4N3h+wVLHt9uvoCI36ZucI6AZ/xm1lZCW4etbf/V5P0rnZAeiftIR4jPmfm7cXJWNqSOHJBUdcPHzfFqUElKN4UoCSXmI0y5G86eGzAtAJpXTA7o+ivIj9rzuBCOLWtXIt69IfTAEweH6Ta7eD1cjtnSxeuvQ6nMrWVLsZRIySqrWDw2yqMH3z027YLGePjfOfFWjj1nIViVL2bTfz5VnoL8SNfpbn+Ji7/U8MIF/Hjw28kwfCci03TldyFdHJL0hImQgMXod2/iv/o/i5xntwjpUKz03IeAa1GKd6/jBGc5Fj4IQkYWsxKmppgKrpyOMPx8Kki4JH8oLwjMAfKQkHuufsd1hjEOu4C9a4cAqjXEv1IIodD2nHm/ou6/8X6HkhtTAFMmqs2JHASj+sjl1WjJSSkREUHmf8jLQ+Yv5gN+5bYKHd00EcP2yCPq7YGDEpgTuQpkc6I59MGrxw0ajQuTTYeHHHF8zTuW2/3eCiN6wd7+xNegOh1RjRjNpWjKLpmnWTERJHZ12YEIxW68r5vN4ALd7MFF4iBjG7T4BXckkp/6nZn+QeXN/ET/5261mNONU
 vbbpAHFj
 UZ0MjhAsWzfmIReKb/Vh0qHyyy/faYphSIznr6sJBnSB6iZbPLUPU26dtBqhPR6Y5RNX7DCO/LHUXFz1idsp5V8xLWNk1h7UjQVdjoGAujSdKihBHUUDnLY5TN4jhV3rWEZFanA1RS9C690IugSwGMYZuM/LBCOHFgu34wEIPBvfnVIbikMN99xfAJqNEzfBNqWIdm+7v6uclahVrHC6yefsdf09/yauG3NxVI8pxwI8yoez1Ivr6cYlrz2adLSLmqAiGKRWirxCKYVQ9JKA4+zndbYhlA9LMF5LQ37byauurcMjYt1443kPzuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The folio_test_private() check in pageout() was introduced by commit
ce91b575332b ("orphaned pagecache memleak fix") in 2005 (checked from
a history tree[1]). As the commit message mentioned, it was to address
the issue where reiserfs pagecache may be truncated while still pinned.
To further explain, the truncation removes the page->mapping, but the
page is still listed in the VM queues because it still has buffers.

In 2008, commit a2b345642f530 ("Fix dirty page accounting leak with ext3
data=journal") seems to be dealing with a similar issue, where the page
becomes dirty after truncation, and it provides a very useful call stack:
truncate_complete_page()
      cancel_dirty_page() // PG_dirty cleared, decr. dirty pages
      do_invalidatepage()
        ext3_invalidatepage()
          journal_invalidatepage()
            journal_unmap_buffer()
              __dispose_buffer()
                __journal_unfile_buffer()
                  __journal_temp_unlink_buffer()
                    mark_buffer_dirty(); // PG_dirty set, incr. dirty pages

In this commit a2b345642f530, we forcefully clear the page's dirty flag
during truncation (in truncate_complete_page()).

Now it seems this was just a peculiar usage specific to reiserfs. Maybe
reiserfs had some extra refcount on these pages, which caused them to pass
the is_page_cache_freeable() check. With the fix provided by commit a2b345642f530
and reiserfs being removed in 2024 by commit fb6f20ecb121 ("reiserfs: The
last commit"), such a case is unlikely to occur again. So let's remove the
redundant folio_test_private() checks and related buffer_head release logic,
and just leave a warning here to catch such a bug.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/vmscan.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f1fc36729ddd..930add6d90ab 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -701,16 +701,10 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
 		return PAGE_KEEP;
 	if (!mapping) {
 		/*
-		 * Some data journaling orphaned folios can have
-		 * folio->mapping == NULL while being dirty with clean buffers.
+		 * Is it still possible to have a dirty folio with
+		 * a NULL mapping? I think not.
 		 */
-		if (folio_test_private(folio)) {
-			if (try_to_free_buffers(folio)) {
-				folio_clear_dirty(folio);
-				pr_info("%s: orphaned folio\n", __func__);
-				return PAGE_CLEAN;
-			}
-		}
+		VM_WARN_ON_FOLIO(true, folio);
 		return PAGE_KEEP;
 	}
 
-- 
2.43.7


