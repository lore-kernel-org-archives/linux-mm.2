Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C5ECC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 15:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BBF16B008A; Mon,  3 Aug 2026 11:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96DBD6B0092; Mon,  3 Aug 2026 11:12:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 883A46B0098; Mon,  3 Aug 2026 11:12:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66A426B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:12:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EEF8C1C057B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:12:21 +0000 (UTC)
X-FDA: 85060299282.04.6AC0157
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7FDAE8000C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:12:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ONEOu75G;
	spf=pass (imf02.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785769940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nYkiDqZ2s4jvTz9taNY7nkfTxdmOdt6GrT7E1WYDfzE=;
	b=o2njJvhGjQy4j6qmTD2qiZG0mcGLkRPvchnL+yp0IxC/0KUozP7EbeT41oCVgH23md4Dtk
	b4cIkS77DMpRezV3erjW2feyiLscDIiRn/hnZSKtA2mP70r5nVqyF7JllFLyoHpyjkJYyk
	gOAjQrH3Yu9I90ZxY4bliPnDcJHedJ4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ONEOu75G;
	spf=pass (imf02.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785769940;
	b=nNqlc2N6ySlonSYYo0t40BDUlo5xm2rBIYVZF7X1JN3ddMxZlWiiXPUvRQ0rN3OA/tB1Ko
	utRxIC7yBEGg41IE+FzErbrBcZxDdvMS8mo0MmGxQes5kiyaLkVmfiDEJm/DcIvf5jjiy5
	BX82vB7OzJ5KrzgcKxz5/TtJTae0+L8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=nY
	kiDqZ2s4jvTz9taNY7nkfTxdmOdt6GrT7E1WYDfzE=; b=ONEOu75GH0kFmaLupU
	O4B/FR0pDt7YCt5BnMuQsMBCROJIBGzJ3QFx2zmNYNDJNTuthHAeiQ4x0n7nGPsY
	LNZHlGOFLtwPI2YtqKiNZri4NiV4LogRrW889zbmJ+bdjV6b8v1SPq2AmVFhwSLP
	9yHuqeyLU+j8EO2X8TOC27Wx8=
Received: from XLL-9950X.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgDHDym5r3BqxJTWKQ--.40551S2;
	Mon, 03 Aug 2026 23:11:55 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH 1/1] mm/ksm: validate KSM rmap items before hwpoison kill
Date: Mon,  3 Aug 2026 23:11:51 +0800
Message-ID: <20260803151151.3472893-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgDHDym5r3BqxJTWKQ--.40551S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww1UWF1DAFy3Zr17Wr4Durg_yoW8Kw15pa
	n5ZasxJrZ5tw1a934xA3yq9r1Yv3s5ta1UtF1Iya4Svas8trs8KrW8Ja9rJrZ8Ka4kCas3
	tr4q9Fs8GF4rXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j4ksDUUUUU=
X-Originating-IP: [61.171.203.210]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC9xvQyWpwr7tctQAA3S
X-Rspamd-Queue-Id: 7FDAE8000C
X-Rspam-User: 
X-Stat-Signature: u979rqksfawbsan65h76wtjeg5ogttr4
X-Rspamd-Server: rspam04
X-HE-Tag: 1785769936-461956
X-HE-Meta: U2FsdGVkX1+iw/dtBnKtjehjtmVNpBlOhF/jJV5BfA7OjjuUuRb0hHSTvBP8X7SifQDgEM4MtL6kPCiefzB2JpHs+FyENaHoQjRCtBnvfcBOXvCg9x2+BVYLySENJbEYJR0A7k8ZUSLlWw5RyMxvvt5i4y1QHH4B9UAY+QOQKFVFTDbCtSLofrd3EWdS9dz5uMvhULcaaz/58fSSn/y0FUWdH9m9SM8MjELTYxg6srOJh/RqrrCd6crK9V0d/oBFqxBJlI5IdhedJIcnthi4aDTtqVUpZJf2WTdg70AAuFLk61+nQlkEyJt9e0iiQ8sQ1KOU0I3G2U4xhAFVcNF6mrt3SPRH+GSzRM9S7oY4W8xSDDUOg9QeBWrPPOcIWNv3irO9Z6hwSCAEAoFuEt7y04MPid3k2fChletxzJ7NM8CGXcm4RfVXt/dlSWjeCZAk2bL1s0jLK7J7nrAe9RlvwD6CffdfeBVWY7N2SV5ORtzRMblVKyYj3umAOCtxYULZXY4/paO1JR4swsG0lF+VwGBo8Tj/0U7CwlD2vwv4ErW1ukoYe1zuGK+qY7zB5hoCG0yEortGwKkUY52YDEie9lqMiEb4QM9TtymqHtqn+692UbWZv49Cq+VDOIedA8Z6yVqVtCbtqWMe31zLt+ke65KjxHIh5kYIE68flXrZ/8ianwa1FfXE+LhR15zbR6xC8Z8e4fXYE3z005aZivJQYYtt8cZ28/TaWkrW0HDE/VgwfPlT3+2BhPnNAkFg14hgrfQShYxGQosnIE8HCIKeqDeRJSonF/8uqgXNuUCU8BfzdMUjL8A/vSZyVDu+V5ddfo9/z50CBz64gVdbo6PWugqaPq4gA72UE+YL90+Br5sUkgeOrnWzUk8V8s7JR0wz8fQXP4NYTEyJSPP2wljb8oiFGorIkZKJdph0r5ZvwnT20ouSeeezMue9LF+R2rgC3LXCoKiv9BOPi+hKY2y
 o8BTfEDt
 z6S+IjS+GrYy+eSZ99P2gXFnG9zM5qyrDZ+7vCEmbykmXqvLowVUPM+ZGNIMwY3wVEQQzGVkr1Nay+fYiPu59Dj149A3tu8CXHS//WcTvZlbxGj9lE9NRXPXJrCocUV2W70Yh1/Yyn7X19hRJkOfBquHKZKUA7XISHqU4L1ES47RDepqPzJHA1JYBt3mIUSdHuwTHDMuePTHbU1Pz4aftDWGV5EXfhMKE719AtjmmVkIu+UEyfyelnO4hYES76aGpA9M0uE4PYEiwhgq7wSk85LCT/Z5C638cUqFiONBqsrK8DkkY9Vbc+ZQ0s/goBL0OXvUbhUvTkDLtwuTetBkcEx8QAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

collect_procs_ksm() walks the stable-node rmap list and queues an
early kill for every task whose mm appears on the anon_vma chain.

That rmap item can be stale by the time memory failure handles the
poisoned KSM page.  A VMA may have been split, unmapped or remapped
after the rmap item was recorded, so matching only vma->vm_mm can send
SIGBUS with an address that no longer maps the poisoned page.

Check that the saved address still belongs to the VMA and that
page_vma_mapped_walk() still finds the poisoned page there before
adding the task to the kill list.

Fixes: 4248d0083ec5 ("mm: ksm: support hwpoison for ksm page")
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/ksm.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..bc4b2dd894d8 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3222,6 +3222,27 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 }
 
 #ifdef CONFIG_MEMORY_FAILURE
+static bool ksm_rmap_item_mapped(const struct page *page,
+				 struct vm_area_struct *vma,
+				 unsigned long addr)
+{
+	struct page_vma_mapped_walk pvmw = {
+		.pfn = page_to_pfn(page),
+		.nr_pages = 1,
+		.vma = vma,
+		.address = addr,
+		.flags = PVMW_SYNC,
+	};
+
+	if (addr < vma->vm_start || addr >= vma->vm_end)
+		return false;
+	if (!page_vma_mapped_walk(&pvmw))
+		return false;
+	page_vma_mapped_walk_done(&pvmw);
+
+	return true;
+}
+
 /*
  * Collect processes when the error hit an ksm page.
  */
@@ -3237,13 +3258,13 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 	if (!stable_node)
 		return;
 	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
+		unsigned long addr = rmap_item->address & PAGE_MASK;
 		struct anon_vma *av = rmap_item->anon_vma;
 
 		anon_vma_lock_read(av);
 		rcu_read_lock();
 		for_each_process(tsk) {
 			struct anon_vma_chain *vmac;
-			unsigned long addr;
 			struct task_struct *t =
 				task_early_kill(tsk, force_early);
 			if (!t)
@@ -3253,7 +3274,9 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 			{
 				vma = vmac->vma;
 				if (vma->vm_mm == t->mm) {
-					addr = rmap_item->address & PAGE_MASK;
+					if (!ksm_rmap_item_mapped(page, vma,
+								  addr))
+						continue;
 					add_to_kill_ksm(t, page, vma, to_kill,
 							addr);
 				}
-- 
2.43.0


