Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9F31C79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 08:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09346B0095; Fri,  4 Sep 2026 04:30:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992DC6B0096; Fri,  4 Sep 2026 04:30:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7979E6B0098; Fri,  4 Sep 2026 04:30:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 550C66B0095
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:30:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D3F811C2BE4
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:30:44 +0000 (UTC)
X-FDA: 85175408808.09.29AA595
Received: from mta0.migadu.com (out-56.mta0.migadu.com [91.218.175.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id EBD5640010
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:30:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y6etWUM1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.56 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788510643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tNICjm5Ft59wR6FL2e7NoIPGKxoMgKofYClX+yrCXg8=;
	b=1ndTQ6+xSsYPkSyllWufjPEHEEW2S6llZkHDloc87zWFiAjBgUmcLo9rJbhC32iO8kgKfe
	ivAiW6lEGWhFaQ6J/nBIXYGzxmtRI0Z+6TTIgXrnjq3BocKzn4jh7YvL+4d2M7+c9yUU1W
	0ez42aJgoiLtwtUA77yV5yKSWu/9PPQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y6etWUM1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.56 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788510643;
	b=7JnB3njWerVbwTMHg+T3Jjap9Xbatez7pyhEJITFjyuqs8VB+LHaDH1Y7qPBgAelUomy2G
	N5aJuMZy03U5uJ/DKfO2LG/oPXzDAcAsTnL6Vm02uFgCCeNKvfHTzmzcG6mezaST7z0VHV
	IAP3ahye8Z9EjphbIBckOQ8znKUlLZo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CFKM/oXZIBvw0BqE9/5yiGP7kLeCWI/z9w+COmstMmA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788510641; v=1; x=1789115441;
 b=Y6etWUM1RMTIvN2P7dw85Fry5LCC8U/8IwkjsGKpzZQZ7T/bJLz9a9/zCvGZYb+OTdKWdVgf
 voYRKhnzo7SqYxeWTyHQYfoCRO4CrvSdP6BxvWFyKzg4YnnlP41WXvyQcRPO7KpwsWcopcZ09ej
 HKw1kKmkJa+Ll46FKmaK+SqY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4ff74a31b6f5cb41;
	Fri, 04 Sep 2026 08:30:41 +0000
X-Mizu-Trace-ID: 4ff74a31b6f5cb41
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] mm/memory-failure: convert process iterator to for_each_process_rcu
Date: Fri,  4 Sep 2026 16:29:56 +0800
Message-Id: <20260904083001.553587-5-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260904083001.553587-1-ye.liu@linux.dev>
References: <20260904083001.553587-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 78wwkmrzmcxquzz6to3gkq8uxgt8n4zt
X-Rspamd-Queue-Id: EBD5640010
X-HE-Tag: 1788510642-894948
X-HE-Meta: U2FsdGVkX19tayv4Kzb8AAVvM23Nc7ZiJD+msatKx6WRW0RXc15iaZ1LyOtNg9grt3GTvSCP+BR3akuAi/8TNYDoymF0tF5JD31i3mDH6CKH9rMO2G5FyEcJjjtCi3MxIHdW1xukaZxZPaXqN+ROIDpCSsBH/e4UlmSDaTbZDVjPqSG4+Qinr5OLJMpm0vJgTXyluucAIyPx8bZhqGY1YFi6djQ3FVs/wCpTeMERQCDJhTKGidNvuWKlz3mNTp5nCStcOTAcl6c0t6Shg0zyxnAmTmTUKjpmDUyLRNNSj9HCnaY3ZGdWRI3+rRkihx5aV0t/H1SZv8LJpm70FF0ssIC9nIbkMrJUGm/tUrCND5O625FWbG8at6qalpHohwxJz1D1a50qnxdmInX6gVTW05oZVsQFr1cem03UCrBOUXfIcdDVkLBhM9lKKvgxKIdreN5kr/aptXUNTQ9UGSV27K9kLJjEj0waTMh0ARcYvSY9dlisVUUuexPo6TIK5sx+F+gUKu+Imm68JtZHEX7hLppG8w/87XJRiCoQFGdpK/sZJIJr5Wvd81V0LX29lu+Dmz9CnWiUBVgs7rgWQW8hMvLxUkb3DFiNdCUZOjSVIOKKqH9co666mi3LDjDJ9HnvtJQcbH4k5rIFwMaMUaevI6Cn68SS6PCklA4w+4zBEXXUoTcfrddst1dU1rUhu2SVyaxowYk+CHp402CLAbFsmATl7iwSWTW+O3usVMktmlrmJIb1tZxnzqbOFDsKa1x+w8oEmPkyv1vS26rRw9QsGwtFZr473HKvguUiRRxh86C/KNO5Oc66+8UmQI4aEPTC1cR6QWJ4BSyL+zLyx78KOcBHQ+nDHlDj2KgheoidK9jjMtDoxg2NpZyYKtvLpRIDm1wCV/qe+O//g51IZfCYKdI+3oznZriTj4VeR9Fz28pCk6cBNj82fak8eG1Cs+u0Svm7ByleAaw+or1143Y
 T33GlwTJ
 P6tAJp0YQXamU0LDtUbBba+pTfa5yKHf5WFMPyRqz9gM54nTpZsWO+TtHa62LHqO6oiohoTrGiyA/VntchdYUwV4Yf2hITMgBSIdKmY24G7XwPrShcRvnWW30ZQoVuHYUl7hDdjSuTguetBuJKZYKQdxBuOdqBYy3tgai3GYiYE6CsbNkecSMjGPfO4GCHASqTrEQNCPCKV7jNFK9oWH6PFgEKrhyeXBFc1c0JiQ3dmUZCgin0wBfbVysYcNbRYu8iadofkQKmKc66wKDteEk4gYJRoGcem9fTJ0Ho9RPlRgrb5E89hTXdtmO3eNzkdgXGq9Qm4IAOp6M5bHn5/SXQE2ehZ0gLy/oYRe9oa9tvClX3bIMlx061p7Tksde77urLUM/ay/GBxH7izY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pairs combined
with for_each_process() loop in mm/memory-failure.c with
for_each_process_rcu().

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/memory-failure.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a8b03e2920ba..63a2ff08ee33 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -555,8 +555,7 @@ static void collect_procs_anon(const struct folio *folio,
 		return;
 
 	pgoff = page_pgoff(folio, page);
-	rcu_read_lock();
-	for_each_process(tsk) {
+	for_each_process_rcu(tsk) {
 		struct vm_area_struct *vma;
 		struct anon_vma_chain *vmac;
 		struct task_struct *t = task_early_kill(tsk, force_early);
@@ -572,7 +571,6 @@ static void collect_procs_anon(const struct folio *folio,
 			add_to_kill_anon_file(t, page, vma, to_kill, addr);
 		}
 	}
-	rcu_read_unlock();
 	anon_vma_unlock_read(av);
 }
 
@@ -589,9 +587,8 @@ static void collect_procs_file(const struct folio *folio,
 	pgoff_t pgoff;
 
 	i_mmap_lock_read(mapping);
-	rcu_read_lock();
 	pgoff = page_pgoff(folio, page);
-	for_each_process(tsk) {
+	for_each_process_rcu(tsk) {
 		struct task_struct *t = task_early_kill(tsk, force_early);
 		unsigned long addr;
 
@@ -611,7 +608,6 @@ static void collect_procs_file(const struct folio *folio,
 			add_to_kill_anon_file(t, page, vma, to_kill, addr);
 		}
 	}
-	rcu_read_unlock();
 	i_mmap_unlock_read(mapping);
 }
 
@@ -635,8 +631,7 @@ static void collect_procs_fsdax(const struct page *page,
 	struct task_struct *tsk;
 
 	i_mmap_lock_read(mapping);
-	rcu_read_lock();
-	for_each_process(tsk) {
+	for_each_process_rcu(tsk) {
 		struct task_struct *t = tsk;
 
 		/*
@@ -653,7 +648,6 @@ static void collect_procs_fsdax(const struct page *page,
 				add_to_kill_fsdax(t, page, vma, to_kill, pgoff);
 		}
 	}
-	rcu_read_unlock();
 	i_mmap_unlock_read(mapping);
 }
 #endif /* CONFIG_FS_DAX */
@@ -2288,8 +2282,7 @@ static void collect_procs_pfn(struct pfn_address_space *pfn_space,
 	struct address_space *mapping = pfn_space->mapping;
 
 	i_mmap_lock_read(mapping);
-	rcu_read_lock();
-	for_each_process(tsk) {
+	for_each_process_rcu(tsk) {
 		struct task_struct *t = tsk;
 
 		t = task_early_kill(tsk, true);
@@ -2303,7 +2296,6 @@ static void collect_procs_pfn(struct pfn_address_space *pfn_space,
 				add_to_kill_pgoff(t, vma, to_kill, pgoff);
 		}
 	}
-	rcu_read_unlock();
 	i_mmap_unlock_read(mapping);
 }
 
-- 
2.25.1


