Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F28FC9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92DF26B0096; Mon, 28 Sep 2026 08:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DCA36B0092; Mon, 28 Sep 2026 08:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77DA76B009D; Mon, 28 Sep 2026 08:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 541A76B0092
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:17:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EB820A01C1
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:17:07 +0000 (UTC)
X-FDA: 85263070494.12.5C9BBBF
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 14408C0006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:17:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790597826;
	b=noZblSVN4XPMhqjE1S/ZAA5zmZN1EXPrqXlBfYTzgQP8UiYrf13BVlfYMdGkEd84cHDPlB
	wV/wtW4gZ9stOikDE/4PbHCNNQfxv/eOhJQ3weUf587Dt+XEVBFMMQZfq3oErbjtrDvK/Z
	Rm1kbrUd6RHubcfsG4hXDIP9/AInvYY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790597826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2rnE03nwRUs+qLoAwPe1OF7/f7g2okqDZ3g2gWbWfIY=;
	b=PKgQvLMDAb+v8dvvx3oTGIqKX1ziEqMLhESi9Dc3QRYSuW0gaUyT6/ryJ3U/SedjDobEN7
	E2sG/d24HR7xTAdgJmym93uvJJohf0MHBChjYq+hvGiWyahLjzaziMVqdN8fbZo4ZjQN6J
	gPdCHTyieVBkwMfBG21WPmLKFcVW1RY=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4htgJy6TKjzYQtny
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 20:16:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6216D40579
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 20:17:00 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCHVim1WrpqTZH9Bw--.4739S6;
	Mon, 28 Sep 2026 20:17:00 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	bfoster@redhat.com,
	joannelkoong@gmail.com,
	djwong@kernel.org,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wangkefeng.wang@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v5 2/4] mm/truncate: look up the end-edge straddler by index
Date: Mon, 28 Sep 2026 20:08:31 +0800
Message-ID: <20260928120833.3440834-3-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260928120833.3440834-1-yi.zhang@huaweicloud.com>
References: <20260928120833.3440834-1-yi.zhang@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHVim1WrpqTZH9Bw--.4739S6
X-Coremail-Antispam: 1UD129KBjvJXoWxJFW7XrWkGF1UJry5Xr4xZwb_yoW5KFWDpF
	WYgrn5GrWkWr1Ikwn7ua1jyrn8CayrXayUCFyxGw17AFn0q3WDKryjga4vg3yUtw1kA348
	XFWjvF909Fy5AFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjTRNiSHDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Rspamd-Server: rspam06
X-Stat-Signature: 79zj5bjrncqhzxbw8a8518w774mz3umr
X-Rspam-User: 
X-Rspamd-Queue-Id: 14408C0006
X-HE-Tag: 1790597823-222314
X-HE-Meta: U2FsdGVkX1+d+1TrFj0I36+AHZuJxKHxqYBHk1BdSItz+zkI/K6cWMPJeze0M++GxYyqDq1XXCSs9P6BjmcWA157oRdOE73Fgrz3VSy8uUmwfmpBO2gHazXYquqF1U1yeVKsdAFB7zeLNbJ74LeFhBN6cNEFbCFx04LqDvn06AsWxvWoYby3w7kLsOyUi25PqSWYk53hAvjeQuyE8WSRn1ddlQetQGEJx7fznzqLO6U7ow87QCTmytgR2QQr5zmvYcLJ6f8nhaH8qZDQCarr7rKmVK/FNDvCTiNTo8kKsmzALD/OXUxeeqQgAB5dI+1pTqjmczZC2X7FYpsGmq+l7VDsgYcjYEzAtthpuzjsQwOXdpFevTAAInREsP15dCCwLirwd+z6wr94lZOARG1i88JTHCZ6ZSaNgQc5W+FlI9C5H+CH2gXkf1SpDkSbgCyhfE9Hz8m22uv+E/mYRL1etTiO9XzMxS6UQQKUnacDuL6tvvShGEGo0oyaklJUA6b+hUbq46VzXHxch+kvQAmqP4AGtBmMDzLmpIBuDNWhmcURvpSOnXbKjNdHSJy7/ZE+FP3mn1xulEMuEOHgHwr9zKsMo9g3rXSCtrppQzLTGH3j0UgGTQo+kIADJQkEfjvMB12fCAgc/LryEc5HcQaWzCptF4Q65jRYnD/IlXzLmFa/Fwev4FrkGyue8JGhw5+AqjvGr7fDXqvoIskytlyWJhGp6Qfy8c4AzpQLknZh3p9nGp1X1sKiiYSLD8uDq3tMejHKomCZKJ4VdYqWL9A1MhsbdjphZYNjuEWzowU+hghcxuzaeVKE4geLI22cL9I28yvjUEXKSL0BfN0j+lLUKcOQzUDS1j8m2Q+zdofIUqgxByeY9mhLTKaAooAgsPH7ODYVEXiJLaejp82ZsAsvIpLR4UgtH7XvcyoBBIEPKMgkGNXwTn0QKH0q5JDd8bbpjYMLtSUWIjATs5fnh8k
 +BYryS1s
 fYuG5PRDCW2LzDzK0fdqiwEin09fQpiafoBOP/jtwgXmGzQt0XYNQlyfV9r7bFiehSWbsyaULvvtpBtLDNEorZcYpGUYWuSF0nh/MGpCHANsK49zP1aTnqg3TQz+1NwDqaghUktoc9hoe5EMZa9+BuvKs5EN3fmBXqz+oIjg+VRJH35Ngg2xVeM295hMXpR320YyRcj1pnYLiN04rTxO5IdZrMH1JAR0o2tLY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhang Yi <yi.zhang@huawei.com>

In truncate_inode_partial_folio(), after the first split at the start
edge, folio_split() unlocks and drops the refcount of the after-split
sub-folios. The sub-folio straddling the end of the truncation range is
therefore unlocked and only transiently ref'd in the page cache while
the code still derives it from a page pointer inside the original folio.

Between the first split finishing and page_folio() resolving split_at2,
that tail page can be reclaimed, freed and reallocated as a new large
folio in the same mapping at a different file offset. folio2 then points
at a folio that does not cover the end boundary, yet
folio2->mapping == folio->mapping still holds, so the stale pointer
passes the mapping check and folio_split_or_unmap() splits a folio at a
wrong position (or, with a transient refcount, a use-after-free window
opens between try_get and the split). __folio_split()'s own
folio != page_folio(split_at) check cannot catch this either since
split_at2 has been reallocated as part of the new folio, so
page_folio(split_at2) resolves back to folio2.

Look the straddler up by its page index instead. __filemap_get_folio()
returns the folio currently covering the boundary, ref'd and locked,
with the mapping validated under the lock, so the split target is always
the real folio at the end edge.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/message/20260916094500.C30061F00893%40smtp.kernel.org
Link: https://lore.kernel.org/linux-mm/DLGXT0ERY79Z.3C5DYVJVX6S9Z@nvidia.com/
Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
Cc: stable@vger.kernel.org
Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 mm/truncate.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 8a28f4a21267..f252619ae6c3 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -259,30 +259,32 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 		 * for shmem truncate
 		 */
 		struct folio *folio2;
+		pgoff_t end_idx;
 
 		if (offset + length == size)
 			goto no_split;
 
-		split_at2 = folio_page(folio,
-				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
-		folio2 = page_folio(split_at2);
-
-		if (!folio_try_get(folio2))
+		/*
+		 * After the first split at the start edge, the folio at the
+		 * end edge may be freed and reused concurrently.
+		 * __filemap_get_folio() looks up the straddler at end_idx
+		 * and returns it locked and ref'd with the mapping
+		 * validated.
+		 */
+		end_idx = (pos + offset + length) >> PAGE_SHIFT;
+		folio2 = __filemap_get_folio(folio->mapping, end_idx,
+					     FGP_LOCK | FGP_NOWAIT, 0);
+		if (IS_ERR(folio2))
 			goto no_split;
 
+		/* make sure folio2 is large */
 		if (!folio_test_large(folio2))
 			goto out;
 
-		if (!folio_trylock(folio2))
-			goto out;
-
-		/* make sure folio2 is large and does not change its mapping */
-		if (folio_test_large(folio2) &&
-		    folio2->mapping == folio->mapping)
-			folio_split_or_unmap(folio2, split_at2, min_order);
-
-		folio_unlock(folio2);
+		split_at2 = folio_page(folio2, (end_idx - folio2->index));
+		folio_split_or_unmap(folio2, split_at2, min_order);
 out:
+		folio_unlock(folio2);
 		folio_put(folio2);
 no_split:
 		return true;
-- 
2.52.0


