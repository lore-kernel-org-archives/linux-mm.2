Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F57E606D813
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 10:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QQcQuH9V
Received: by kanga.kvack.org (Postfix)
	id 59FDB6B05B9; Fri,  6 Nov 2026 05:06:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5793A6B05BC; Fri,  6 Nov 2026 05:06:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B6836B05BD; Fri,  6 Nov 2026 05:06:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 26E276B05B9
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:06:10 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B780120CE5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:06:09 +0000 (UTC)
X-FDA: 85404263658.14.639D724
Received: from mta1.migadu.com (out-157.mta1.migadu.com [95.215.58.157])
	by imf15.hostedemail.com (Postfix) with ESMTP id 99127A0002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:06:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QQcQuH9V;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.157 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793959567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FrQo1zWdhbR37KjzuqMTCbGMlx2UHVUhGDoqAfLgAy8=;
	b=eOidMqUIfS7iOWDZvryId50Zkm41vGgKWdm60zCLaeXHP+uK5Hr2XuPti1iCs+rb6nKgmn
	YBXF0Haa9InmgLEt9pmfRS327bkaVdYfO/FIAxFSYI6a6yCGWo9LojpEokYKg5q549874K
	1EawqSTIO0xmSoRAncjrKCzk37KS1as=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793959567;
	b=kbPxnrlvE4Sp58ko41lwUhcxzJn2Zvyy6Ygak8aUvQfa0uIClFgXnzbCNAb7DrjhSIOg/Q
	nofMciWWEELDnDoVcy3C/Vw5rums4l/70HwOs7Hw4tXi+cqKJT/U2ysGQTzqAfG3VeeVvv
	H/AxBCzyb4j05DJSSIrdAXGN/bMiIfU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QQcQuH9V;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.157 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bNru5tLaTrRcZny2inHzZJIS32KRCi5plf6iM9ROkK0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793959566; v=1; x=1794564366;
 b=QQcQuH9VnzgGtpanWuXL2/YQfHVbyvzI/2MufWqAK8iHgjK9fxO0jO1ZBEOlJWmWvML6hs4y
 cXVhDX5Fi8xY0Llbfo1CLnKzo8/YXAKXuSAIO3xMs2is5wxAaEjhZlBHHgYwJfgoVaUgCoT2m97
 ajM6C2X2j/XcKzdf812B3tOo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f3d9d3dc338d93a1;
	Fri, 06 Nov 2026 10:06:06 +0000
X-Mizu-Trace-ID: f3d9d3dc338d93a1
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mani Tofigh <mt4022@columbia.edu>,
	Zi Yan <ziy@nvidia.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Chris Down <chris@chrisdown.name>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>,
	Qi Zheng <qi.zheng@linux.dev>
Subject: [PATCH v3 2/4] mm/hugetlb: Preserve persistent flags when returning folios to the pool
Date: Fri,  6 Nov 2026 18:05:19 +0800
Message-ID: <20261106100521.30099-3-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261106100521.30099-1-kaitao.cheng@linux.dev>
References: <20261106100521.30099-1-kaitao.cheng@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9q5t711x7a476to7h5dezwioak94dnm6
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 99127A0002
X-HE-Tag: 1793959567-208569
X-HE-Meta: U2FsdGVkX1+Aw2MTZxGsfjiQhh3n94FxtiU9HRSO6gZ8K/XOiHIIUhin7xytuoM2Zjgn45jAKjQ424HjI4vD2XXR0Y7VGx/pHI1RNZH/JjUV4VNekPHO52d5beFbgmlONXHt8BVP//+OxuYGIml7jszJzabM9Cg3iTg7zhbusY3nmmRo8gl3twABwobtIlLfedPBtas1dE0eNa4U7BGNrQnqhvN0JwBbJBrnY+sNGYcfSfrTChWetnTXOeN/bJbL5DVTjwHJ4xnXgh+J3hDS6aUl7zY/ZnRPPVw7XmxIlRIrqG9SK0+AjjIaDthTfzGliIqfB+auYRyM73JYBkWUHxBWaMyq7J/TWna34AJmFhsY+Wxhg//CcA5PHPXCP7o3laNxCN/fDlLHInSEBYx5atYKKveXSrSBGuPp3GC7ORdwn0zkCYpx29bSXlAJZa4hy9EDNj7SfwDjmIIOjssE+VSrGIXdd0O4bK0MRMiE2uv5hPLNvb7u1pBpfG+1V6plA9W2wFNwvPXBkO+aUi6MZFSEYt6OMkjnW5FKswI2IjkJS9z7morLAwh/OEDigQELyEQwEIcM9frWVRpZr5yibEOfNgEENYGNawlMdNUqmQ1Cq0rN1VcUpEN8XufgJ7w0IIdUdCURSqyf/NE0KRhXvoc6NsgY+FBojtiPrQF+xv5mYUQ4C/JkKxF1hg4edSFf08ZxIzKuycQXNgd0y2U7eyfgGoQpPKZ+O1m4R66iNRo8+w04JqZMY6W9sDVK7TN05Jduz/jUtnTKHGGo1eJWqG/N5oID+d5rL6kzClZB0Bb7VGMn8VDoL1aFVAmqpNcaXOGNvTeHpb9nv5wHBjw7CoqUz7NJGeaJGJzAvXH7EjPmboA+iozLHs2m/X2LiEGGruz2RzEU6Ump3e7BQNkseLHcA+4V3WfRVcR2B4nfbwLumLSPffcIjykFKW7125XW4QfHFRxUpDsfOqSUmJ6
 qOG181kO
 t+P0yneRqYifgA4QpiQgqzqsDGD/VSllNBHhQ+xRKiSRVxaQonassxoJFj5gvf454C1YaET1T+aUAuIkiEjg6avXc7IPCptaY/seTtHadQUp/GBx/kBk/J9uWqKObkcGPvDnvARRfo7bhkB775a9vba7MGF/EEu6TOrF4U76HLV5yaGjDbw+dThMAwm8GaOA/pvc/oCrrxhsoKmI0b2R3K818I5SlZNizGgBeS7PSbz+U3Ypcw7SzPJx982ZIdth3sB4EuMAuXsF1DlJYNP6khTuX+xjiPEvX3c9wN0XRXfmfyIsgdwPjEFv6RR6F6Vwmhlk0WB0ukUKAU0KVXw5P8T1f9yBtQkcPj2RKP+kqdRH0oNAO/lvpFUMg90X0ITbrs0I2Krnv5BiYgZxy8oiJlbK6Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kaitao Cheng <chengkaitao@kylinos.cn>

add_hugetlb_folio() returns a folio to the HugeTLB pool when vmemmap
restoration fails. It clears folio->private and restores only
HPG_vmemmap_optimized, losing other flags that must survive the rollback.

Clearing HPG_cma causes a later free to bypass the CMA release path,
leaving the CMA allocation bitmap set. Clearing HPG_raw_hwp_unreliable
loses the indication that the locations of poisoned subpages are unknown,
undermining the checks that prevent freeing or unpoisoning such folios.

Preserve the existing flags instead of resetting folio->private. Callers
already clear HPG_restore_reserve, HPG_migratable and HPG_freed before
returning a folio to the pool. Clear HPG_temporary in free_huge_folio()
before attempting to free a temporary folio, so a failed vmemmap restore
does not leave that flag set on a folio returned as surplus.

Add a VM_WARN_ON_ONCE_FOLIO() check for flags other than
HPG_vmemmap_optimized, HPG_raw_hwp_unreliable and HPG_cma to detect
incomplete transient flag cleanup.

Fixes: 161df60e9e89 ("mm, hwpoison, hugetlb: support saving mechanism of raw error pages")
Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA areas")
Closes: https://sashiko.dev/#/bug/linux-5363eb09-9c3c-4f8b-9f3c-a998a8c4b258
Suggested-by: David Hildenbrand <david@kernel.org>
Suggested-by: Muchun Song <muchun.song@linux.dev>
Suggested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/hugetlb.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6fba92b0f674..5b5353ff5ee2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1450,6 +1450,12 @@ void add_hugetlb_folio(struct hstate *h, struct folio *folio,
 
 	lockdep_assert_held(&hugetlb_lock);
 
+	/* Callers must clear transient flags before returning to the pool. */
+	VM_WARN_ON_ONCE_FOLIO((unsigned long)folio->private &
+			      ~(BIT(HPG_vmemmap_optimized) |
+				BIT(HPG_raw_hwp_unreliable) |
+				BIT(HPG_cma)), folio);
+
 	INIT_LIST_HEAD(&folio->lru);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
@@ -1460,9 +1466,6 @@ void add_hugetlb_folio(struct hstate *h, struct folio *folio,
 	}
 
 	__folio_set_hugetlb(folio);
-	/* Clear all folio->private flags except hugetlb_vmemmap_optimized. */
-	folio->private = NULL;
-	folio_set_hugetlb_vmemmap_optimized(folio);
 
 	arch_clear_hugetlb_flags(folio);
 	enqueue_hugetlb_folio(h, folio);
@@ -1750,6 +1753,7 @@ void free_huge_folio(struct folio *folio)
 		h->resv_huge_pages++;
 
 	if (folio_test_hugetlb_temporary(folio)) {
+		folio_clear_hugetlb_temporary(folio);
 		remove_hugetlb_folio(h, folio, false);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
-- 
2.53.0


