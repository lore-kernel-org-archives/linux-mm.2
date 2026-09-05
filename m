Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29FFCC624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 06:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3FB06B0088; Sat,  5 Sep 2026 02:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0666B008A; Sat,  5 Sep 2026 02:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E08B56B008C; Sat,  5 Sep 2026 02:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B476D6B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 02:46:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2DD67802B4
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 06:46:21 +0000 (UTC)
X-FDA: 85178774562.19.93199AB
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3FB881C0004
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 06:46:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1EH0Afds;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788590779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SrHR5CBRJdLHNcWo7Abm7uItODzcin9yiJGYKuE8ow8=;
	b=g1cJNyUqhjPv6jd8KQJ3yR6y5E4lIq2bY/N3ptgJy3yymYhkV7BJt0rTTUO4JaBaF7M4K0
	NzqnqmVCmRngadiqnzF9eMHIJvWfgFU0MMUdIILDJsBsJlVyerDSRB1u9m4pIL2vWu5POl
	xDnq8Pddi9EElDcjLiaYRiIro/IRJ9s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1EH0Afds;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788590779;
	b=gLKRLPgScj4IZvOl/JK9mz+EWKaFImfTwj3uqD24XHAL0AEwuvfD1WKwNABz7yE8YTThR+
	wDOg8krXycAFqQUrv9utcwu5rCo/4psGkY9WSQDJZSeKz6DkKZql6c2afv8ID5blMcwdxn
	O08WD5/fiaIuPW+RiDRBkxA9BEksIQU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=SrHR5CBRJdLHNcWo7Abm7uItODzcin9yiJGYKuE8ow8=;
	b=1EH0AfdsCHtM/gkEOyE8XqGhMGi5bcM3zOPfQwtxO0wiKE7ZLV3izWfHoEuIkZ/bxqukj7e/P
	NATKx8NQJQzfgljKW7NAz8HgXCechMFFmMRsRSyETMJ9s7jhTL5ki8sNYIRZh6Ntbd+XLtsP6oS
	We+iunXUZGq1wm7rzkfzQH8=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hcNqn4k38z1cyTD;
	Sat,  5 Sep 2026 14:35:17 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id C5E4640586;
	Sat,  5 Sep 2026 14:46:08 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 5 Sep
 2026 14:46:07 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<riel@surriel.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<harry@kernel.org>, <jannh@google.com>, <lance.yang@linux.dev>,
	<minchan.kim@gmail.com>, <lwoodman@redhat.com>,
	<kamezawa.hiroyu@jp.fujitsu.com>, <mel@csn.ul.ie>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH] mm/rmap: fix missing barrier between anon_vma init and vma->anon_vma publish
Date: Sat, 5 Sep 2026 14:18:19 +0800
Message-ID: <20260905061820.642437-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3FB881C0004
X-Stat-Signature: bhfxhn453hbzxqtkub7m38iej4tnwku4
X-Rspam-User: 
X-HE-Tag: 1788590776-651466
X-HE-Meta: U2FsdGVkX1+W1LJc/cpRJLxAgrXI6XEe+s0QrjovZb4uxwfSWf3twJ0SmcpnQZFhfNz2fGggonvCiH7Q+OXJuS7mbNgfFiu/sy/khNs1yKjwrYTSi4AoLG19eR8ezrT/aG9MROHbSC0hkx4KGW/8o8XJBisbvlQp0zOCLDIEaleOJ7qT6sLl16/bOd6WYOvL94PtoDFFpedcdkKHD0mvbyHTmcluZDocMht1MRgfvVegC5QIcnnP2OMuXOQU/sw73pvmBtdLCMNXA6ZwpKwvAXjy4RTa/4W6JEJn0Q2dM+gHvp77ew/4Lv814/cPtneEEoL7NObxV4JlmgUL4XQlnMCy4hYu4b8pdJwaaZy0krhSnnI8xZE5KGkxWlqTRJHEpt1+lGnBlwuS1RUn9GB6FFamluRnpcIZa7Dvvc0Op1KReM/yB2ZXFihQ6cTtI5gOq+xWiAUEAq2J57cCGwNi8KXEmb+LBaA0ZIQz+V8rw8MCLNm9TS9oiaz4EyHryANk7SroVzBKQPpss89FgpfdZk1FJJF6zFlfTRRtCjBHfFudITi6cjLSglyGXhe8Gm714S9B824A7EcS1YwzYA9PJQSCdev5rouUMzRNd6sKMh8kj9wT9PwclbGfeyvj14Zet4od/IyeVznVsJSpCs1XZyJHddohLFyuGN+uVC2bDjv6dscb7FidtVgGjYLLjR4Q5PFGn0mkvvV2iK+kGqgtmYxJKAaTYu3AmKaDNj2U6uAZHRRb6Op57qTaeJVKx7y00KDoiByNiUAyrPpW45BGgXIcaPzXZGL8HreC6cr82/PYRwpJfrqqokIdALnhUkfHoiEfe5XByf6I4OKb4Ajqnn1g/Frfd/EYnToHZTgdKfPcV+WVb8IhwJwzIDs30rLYxOnfCyA50u1kirJ0xvYz/djCTCeRyHhEJTdUyO2CO1PRmXNpvJfMnrAzSZaebLo9G1zl6IVoxceYs244gY7
 ndi5d4DX
 kWBVORYv6+8LLHhsmBu8UGNj+rqkF3WOCGOx3+YOeU8r6MzXWFFbuoTmxyp5Y+WMzstNEXioMRrHRa2A0MT9/bOyB7B2a/tBW+6R5ApClKoB/8q8cO6kMMmOUIIm7NTELmh2OfNRICCSK7ZHY1WDuq0zlSAbvkZfmYzDcgeeCgYv4cChfxAzcnHH/HrxqRx6UQ+0ofDTgiBkgGyhNvPnpdfY8urZbrocfdOKBQLu6hVL9vxGhU2lJ9bJxUAVxNBAZl6voMOcb9LK8Ws7FyHCoMZKeG1rRlHkSpzgBpVLco1F7UhNPRXuxMbd+JUFI4QT90blDOpPdoEwsPOoGMOwctC427HGHtvFkkKixMn6F6NQcJ+e0ZfPrWaitaiPOWWjEUTzLage2eHoxSSrRhRyfIYS7SHfasZH+T3gAI6avESzpEpyQ9EB7f0PsyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On arm64 server, we found  __anon_vma_prepare() reuses anon_vma and
anon_vma->root is stale due to missing memory barrier, leading to
lock and unlock two different anon_vma->root, thus leading to a anon_vma
will never be unlocked, and another anon_vma couldn't be locked anymore.

The race is as follows:

    THREAD A                             THREAD B
__anon_vma_prepare                __anon_vma_prepare
 anon_vma = anon_vma_alloc();
 // writes may out of order here
 vma->anon_vma = anon_vma;
                                   anon_vma = find_mergeable_anon_vma(vma);
                                   anon_vma_lock_write(anon_vma);
                                     // may still see the old root
                                     down_write(&anon_vma->root->rwsem);
                                   anon_vma_unlock_write(anon_vma);
                                     // see the new root, never unlock old
                                     up_write(&anon_vma->root->rwsem);

thread A triggers page fault and calls __anon_vma_prepare() to prepare
anon_vma for the faulting vma. __anon_vma_prepare() allocates and
initializes a new anon_vma, and then publishes it to the vma with a plain
store. anon_vma_prepare() only requires the mmap_lock to be held for
reading, so two threads can fault on adjacent VMAs at the same time. While
thread A publishes a new anon_vma, thread B could finds the anon_vma via
find_mergeable_anon_vma() and then locks anon_vma->root->rwsem.

However, due to missing barrier, thread B can observe the published pointer
but a stale anon_vma->root because the stores from anon_vma_alloc() aren't
yet visible. What's the value of the stale anon_vma->root? __put_anon_vma()
doesn't clear anon_vma->root, so the root of the new allocated anon_vma
may point to a valid anon_vma.

As a result, thread B can call anon_vma_lock_write() with the old root,
and call anon_vma_unlock_write() with the new root, leading to a anon_vma
will never be unlocked, and another anon_vma couldn't be locked anymore
(it's count is dropped from 0 to -1 due to wrong unlock).

To fix it, change the plain store `vma->anon_vma = anon_vma` to store
release, so that the fields of anon_vma are visible before anon_vma is
published to vma->anon_vma.

We don't need a read barrier at read side for thread B. The load of
anon_vma and anon_vma->root have address-dependency. According to
Documentation/memory-barriers.txt and some investigations, only Alpha
needs address-dependency barriers and it has been handled by READ_ONCE().

This issue needs two adjacent VMAs aren't merged but are compatible for
anon_vma. We reproduced this issue in v5.10 with KSM enabled. The kernel
doesn't merge commit cf7e7a3503df ("mm: prevent KSM from breaking VMA
merging for new VMAs"), so there are many adjacent VMAs that aren't merged
but are compatible for anon_vma.

Without this fix, our production environment could reproduce this issue
about 2-5 times each month. After adding a smp_mb() before
anon_vma_lock_write(anon_vma) in __anon_vma_prepare(), which is different
to this patch, this issue hasn't be reproduced for one month.

Cc: stable@vger.kernel.org
Fixes: 5c341ee1dfc8 ("mm: track the root (oldest) anon_vma")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 mm/rmap.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index d1819fd69938..a868e835eadb 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -209,7 +209,11 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	/* page_table_lock to protect against threads */
 	spin_lock(&mm->page_table_lock);
 	if (likely(!vma->anon_vma)) {
-		vma->anon_vma = anon_vma;
+		/*
+		 * The fields of anon_vma must be visible before anon_vma
+		 * is published to vma->anon_vma.
+		 */
+		smp_store_release(&vma->anon_vma, anon_vma);
 		anon_vma_chain_assign(vma, avc, anon_vma);
 		anon_rmap_tree_insert(avc, anon_vma);
 		anon_vma->num_active_vmas++;
-- 
2.43.0


