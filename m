Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C237C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 18:23:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 285396B00CC; Fri, 17 Jul 2026 14:23:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25DDC6B00CE; Fri, 17 Jul 2026 14:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 173326B00CF; Fri, 17 Jul 2026 14:23:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CBC0E6B00CC
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:23:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57C4EC0133
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:23:18 +0000 (UTC)
X-FDA: 84999090876.03.F299CB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 801E480007
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:23:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dU5t7A9x;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784312596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K9J65l4/3tAXQjoApUsRo6wpq7Iiti7b+Q54PqfKy2U=;
	b=h/ttfcHavIBlGL1JfuhrBdmll5bj432QPvxDPuvLJAmEkc/xIcUNcfwDPaq6Ar1804aM5X
	meDVF7R6vKNrlk9mR0HJiF3b2dNcV2wKjzaef741Rfqz6+pgDpFizUxWigTb7wh6rK3WHN
	RuDEOA4Ux+0L+76tDGFmb6R0SjG2piY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dU5t7A9x;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784312596;
	b=LB+D2zb7zscCcW1Y8o0mH9ttDbLPhyOGinazX4lRpJLvVVBHQeLe29DfpYmb3TUMMSRSMX
	vqsGXE+k/e3bXr4Y3fTsGHEK6asIgoe22PrZUKA+dY2OEPd4KDgrJ3cGg2oOwfbUKjesdd
	6tvNeFWDM8jpv4dB9E0qzmS3kixYCsk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D64A243EEC;
	Fri, 17 Jul 2026 18:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5601F00A3A;
	Fri, 17 Jul 2026 18:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784312595;
	bh=K9J65l4/3tAXQjoApUsRo6wpq7Iiti7b+Q54PqfKy2U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dU5t7A9xxE1rqZ1PA5/5f+2Wu21cdQEJUSBHMauC5kMnYT1kDL/cyheogHKuFwzqj
	 nvvku9uzuFSlcxKvF6cMFaQKmuQ+XEQbHDw76+48dB8c6jtLQ6mzA9yFY2jYf9S8Qk
	 RMT42K1WAT+Rd9rPdoqum4UcK1jGG/mognui1GF0gBoawsjVNZlFz+ahHQKymI6PH/
	 43xsPxmL5ftrK1PmXmi/TQzpS23MDE5C/fzN+mP39M2jWR0qKWuJ7gqIPvmeB9/JNy
	 i6O/EuYQ7aNMaKns/e8vPC/7Yh18CEFXXoq/Ekqu/sxlQUiqneWIVkyE292QIejW/q
	 dah186Oj1sn/w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 19:19:45 +0100
Subject: [PATCH 07/15] mm/rmap: track whether the page VMA mapped walk is
 anonymous
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-scalable-cow-virt-pgoff-v1-7-cf24910ef094@kernel.org>
References: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
In-Reply-To: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3223; i=ljs@kernel.org;
 h=from:subject:message-id; bh=M2DuEa+QMY+cZQChTlOi3eUq8pPFDxokrv+qbMEdb+c=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKiivblzmr2WeH22/fBFcFjy2Ou3tW+uCCw3bjgQOHjH
 0eXX1S06yhlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBE/MwZ/opfdj+rxXiu75RM
 47b+P7fu5Oz4s/ceV0vY+g871Itau4IZ/sfvNxJQ6JsxdS6DQqDQ/FbW4832Wlw/JYqdVn11E7q
 txAIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 801E480007
X-Stat-Signature: hd49xhwfxn1udig9f8cee5poycphq51k
X-HE-Tag: 1784312596-242750
X-HE-Meta: U2FsdGVkX18LAs843gWdjm8sWoYeKWfyEZKGSHQ+YIIfFQwHb5xIvn4mTbLwwfxvjMXHZqRC3jsaW4SfibK3O1uic9d2HSr+LyS8/WUn1ykvdBDXUR+B/voIIQANdCYJ1TKdSDv37H1AvPfM4ty7tYk8OllEeqShigNTjVNqisHFzoT+VlZMr98FpzzWD/xWLs72ZDAi3vdaAnV8EK10PgSzUn4VKJD+43f33QQpw2tcl6wTA+3omreiwTbwCsqJ0amio8epMcVMmbkVeKYH8PfqctiCDD0zxE6qRbVKce5EBOISu/Ondy0a/n95TtM0O2Gx9XrFKVhdQN42w6duAv4KQrkrTb7GcRrZeu6LLMvnhvluYgck1hX6Gs6itvN6MRgIbayrx+MGZSAg907yrkGiWnUt6+4ShlzT8EiFTfWswcIX8sfB2IE2uyJ7dqkEIvi+hqp9fe3PVARRuwuM+6bOWsvhzvql7dsyzArD7GB+e0Q36skFA3TGjngtEvtF7lRxXn/soMf95qKSk0vesAAzxSWqGU/73//O0YKVpJlDgKwoaQLU/44dOaxY3/DNiANTmobyBbrOxb12KRdqOG6mgJdbEz861cSnRTol2sU88IIHRsoLfExnR2sNH/YA3MeVAo/N05V5DW0WcXSyKVUP9q+e/d2r8APd0ylfsCpyRiRAvFJpnzNJNgzPXfSP/gbDFcSAL4cwyFM5Cz5Dns2JlvKMfdp5FBZnwTZdPcXYYzeTiEz1PKanux6y6sPM4kRyRvj1vGEZCCaOtIg94fKkzNtSGjtIO1bGSe2XAmTsQ05puVK+7FL+NEoG/X+vnACgaDk2V5NJQp0hRrWh3XJK0DRRpfUKLNhA2qiL/BpPBEfTKbaeMJO6ji0Ql81Ol5x/w4rfvohSRA4yeE0U8cXMxP7Rzq4TwY6Y8n8tJFv4ilbW/V+oeC8m05RvtaMOG92tKK5zbnd6YRqrfxf
 U4wBAYpn
 q2JwVNl3xYFJ6o6hO7hdN312t5Pao/RfjV6VtSaQ/wqAAOzFl+9KSlIGpoRP2nPQ1XQxyqtepCeZQek4X3wJZmSqAyvaSWXuKOB/5IgznGOnz/rls1Kk7iJN9IEfpW/1maYgZrmYtc0Jdb9ECinznStC+mJjp5QSn4XPE0dD8yWn9TvipC+SHN73ZMD7yMsU/xTwZXWqzNrYDcTQ661CwW/kyLqZBp0WUSGdJscu6JWXb5dM3lx8hg3ig+ByhMvyQIReUoNHZ/WM9zxuCEgveYNl4t2o6IpV3w9PKN2yYSQ6B4+n8YHwtmT65FhMskw2hbWdd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the page_vma_mapped_walk structure to track whether the walk is over
an anonymous folio or not.

This is necessary in order to determine the correct VMA page
offset (virtual or not) in vma_address_end() ready for a subsequent change
which adjusts which page offset to use depending on this parameter, and
update the comment slightly.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/rmap.h |  2 ++
 mm/internal.h        | 13 ++++++++-----
 mm/rmap.c            |  3 +++
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 8dc0871e5f00..a48ae9575bd2 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -871,6 +871,7 @@ struct page_vma_mapped_walk {
 	pte_t *pte;
 	spinlock_t *ptl;
 	unsigned int flags;
+	bool is_anon_walk;
 };
 
 #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
@@ -881,6 +882,7 @@ struct page_vma_mapped_walk {
 		.vma = _vma,						\
 		.address = _address,					\
 		.flags = _flags,					\
+		.is_anon_walk = folio_test_anon(_folio),		\
 	}
 
 static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
diff --git a/mm/internal.h b/mm/internal.h
index 73f90aaa979d..7ed8bde7890d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1079,22 +1079,25 @@ static inline unsigned long vma_anon_address(const struct vm_area_struct *vma,
 }
 
 /*
- * Then at what user virtual address will none of the range be found in vma?
+ * At what user virtual address will none of the range be found in vma?
  * Assumes that vma_address() already returned a good starting address.
  */
 static inline unsigned long vma_address_end(struct page_vma_mapped_walk *pvmw)
 {
-	struct vm_area_struct *vma = pvmw->vma;
-	pgoff_t pgoff;
+	const struct vm_area_struct *vma = pvmw->vma;
+	const pgoff_t pgoff = pvmw->pgoff;
+	pgoff_t pgoff_vma_start;
 	unsigned long address;
+	pgoff_t pgoff_end;
 
 	/* Common case, plus ->pgoff is invalid for KSM */
 	if (pvmw->nr_pages == 1)
 		return pvmw->address + PAGE_SIZE;
 
-	pgoff = pvmw->pgoff + pvmw->nr_pages;
+	pgoff_vma_start = vma_start_pgoff(vma);
+	pgoff_end = pgoff + pvmw->nr_pages;
 	address = vma->vm_start +
-		((pgoff - vma_start_pgoff(vma)) << PAGE_SHIFT);
+		((pgoff_end - pgoff_vma_start) << PAGE_SHIFT);
 	/* Check for address beyond vma (or wrapped through 0?) */
 	if (address < vma->vm_start || address > vma->vm_end)
 		address = vma->vm_end;
diff --git a/mm/rmap.c b/mm/rmap.c
index 5798427d007f..cfd4195ff1ae 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1240,8 +1240,10 @@ static bool mapping_wrprotect_range_one(struct folio *folio,
 		.vma		= vma,
 		.address	= address,
 		.flags		= PVMW_SYNC,
+		.is_anon_walk   = false,
 	};
 
+	VM_WARN_ON_ONCE(folio_test_anon(folio));
 	state->cleaned += page_vma_mkclean_one(&pvmw);
 
 	return true;
@@ -1317,6 +1319,7 @@ int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
 		.pgoff		= pgoff,
 		.vma		= vma,
 		.flags		= PVMW_SYNC,
+		.is_anon_walk   = false,
 	};
 
 	if (invalid_mkclean_vma(vma, NULL))

-- 
2.55.0


