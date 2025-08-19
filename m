Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0268FCA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 14:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798388E0010; Tue, 19 Aug 2025 10:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748018E0007; Tue, 19 Aug 2025 10:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636316B00CB; Tue, 19 Aug 2025 10:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D6FD6B00AC
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:20:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 204EB1607AC
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:20:39 +0000 (UTC)
X-FDA: 83793717798.12.A9D3137
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf25.hostedemail.com (Postfix) with ESMTP id BCC4AA0019
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:20:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755613237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=sGdgU8+wyZFhFJFIdr/cZ3pxwy3E6J9zkKeKNpTBiMc=;
	b=art8/+2u/jRSf6crK50HU+q+Xnvueat/E2KKee2Gwdp18MW0gqlVQVgbebVxIYwLtlRbYk
	BViO9RMGG5iry0dGMscojPEtXZLhslznUn3ckQOyzvi9fXR6PBSCh/pccGcuL6XQaCoqJg
	oNY3EANzd3Ne0Kcyk5dC9lSzgkKLzlc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755613237; a=rsa-sha256;
	cv=none;
	b=umd5qhqm0X600sq8NMAWEs0GO4o5ywVmHYmdC19mPMfNhLMvOWPfA8tEZ9+0yyMzXvq6UA
	grLenDv6u1zn/wSoXT5CbTHfukttOr6YdzG1qrfKvU/0ewjMsL6pfvCs2ycroCCBt38Tn8
	o2+necDIZsV2rS6cZD+uNgA6FRcqAT0=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c5s7r58BZz2CgHj;
	Tue, 19 Aug 2025 22:16:08 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id 203CF140259;
	Tue, 19 Aug 2025 22:20:31 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemo200002.china.huawei.com
 (7.202.195.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 19 Aug
 2025 22:20:30 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <fengwei.yin@intel.com>, <willy@infradead.org>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <tujinjiang@huawei.com>
Subject: [PATCH] filemap: optimize order0 folio in filemap_map_pages
Date: Tue, 19 Aug 2025 22:06:53 +0800
Message-ID: <20250819140653.3229136-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemo200002.china.huawei.com (7.202.195.209)
X-Rspamd-Queue-Id: BCC4AA0019
X-Rspam-User: 
X-Stat-Signature: egfw7kmibqc3xe5reuj77x83d3isxpei
X-Rspamd-Server: rspam09
X-HE-Tag: 1755613236-506422
X-HE-Meta: U2FsdGVkX1+NTvfV4vHL2g0WkH4thftGh6n/g8f5ZB5QuLPq118oqIWlrtac0GqSmkJqHvw5LYJhNyiaNI34KsYkHsFFWNewfLhbcNkKIB5dtqfK5d1R5XPR9WlEYSZOr55DgKV4gg791FP+d2ktZd6qCx35iVUwHpVN1vafXHDy/HgQHBKYG+B4qLFcrHSrmtBDCED/kB/ZP2cPoHpHlJ3sNqilAgMM798Magcaa4GroiUL5SzA3EZZ8gksgvPNyr+gS+LH2P80jBwTsbm88hpdqf/ilntSrc3Cd6rq4ZzggH3j87PxxgTHDsD8rmRQqkuOSMPmQ8fOkUv7rU+2ormoiCfiGloVEDUiQ1K1qWypAWcFAE2/D8vqWtiaYI6/mKpMoonjWqdFdMwJY1ckKpDEmmrQphxv7zpJxz14ldaI4SCIyyUFMSVHZc37rWPs7vJdMZc1S0lXxOaooY7YCpQimxRa62HWLVzD3Tsfc9+fUee5DRB1dd+pqDW7dtmtgLVz2b4kud35clJ58Na5uEXUCvPxvWO96HEsfEE+XXwlyUYeXkOicTiW+T1iK9ohyb9ldPHEXtMlIv5CXAhNcTbHVqWlgQwEluA/uAvQ7HY3mgu/7kOoNs9XtpsQtURbRV00mGJ/gvUI+Ia9UaD4TbLuDV3H7675lKWNRoiZ7+35i6Cmf9IRT+8MMaOWzXM7Wi0N/NFoPZsMCZtAvtdOIdGy32t0KIj6OrjEUgOVlWI6OtSib8YuTw0L2zNk5pru7Kp9qFlFkNatgwf1HuIz51nAieV46lJ6XSmAzJpBNbcx/argsItMPNyDe57cuwtCT1jttJzlXWsqkrccamRWQ7RLeZGp2DlKEB1N2QBuSCV1ASyagUlmMWrqeM35GP8GCNmI/JvCHYgMu2XShFXeuCZLdkWYkV1yg9ohCcMvxl9KC8asGCvLR9BNjcov9kCdO8KHzs+mUwENY6C3lEa
 4fU4sFWQ
 P1peDcbAcev33gbHjY0M0pYQ0OBXe8NvWV1X0/QC0Pb+ecxante5uLjaWZwiXIrtlxBKyFtpp2zQfWmaiyReXreU3COYhtjC52ZcnQGlHDJGHPaBiLL0urvawLCko0Hvzs508tWd8/alyhrYKiFwB+Tfi7rlnmycObI5JECmLqrFgsKHFan2wyHjwDkSU6gzyl+atg/E5duUBg7jH+rwcBeJHVOJqr3V54RXA144mNTV94OJSn3pQW0kHHFlgl24lqDJFTBksCrmP7r9HNnXsntPdkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are two meaningless folio refcount update for order0 folio in
filemap_map_pages(). First, filemap_map_order0_folio() adds folio refcount
after the folio is mapped to pte. And then, filemap_map_pages() drops a
refcount grabbed by next_uptodate_folio(). We could remain the refcount
unchanged in this case.

With this patch, we can get 8% performance gain for lmbench testcase
'lat_pagefault -P 1 file', the size of file is 512M.

Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 mm/filemap.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 751838ef05e5..5de52deab138 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3693,6 +3693,8 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 	}
 
 	vmf->pte = old_ptep;
+	folio_unlock(folio);
+	folio_put(folio);
 
 	return ret;
 }
@@ -3705,7 +3707,7 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
 	struct page *page = &folio->page;
 
 	if (PageHWPoison(page))
-		return ret;
+		goto out;
 
 	/* See comment of filemap_map_folio_range() */
 	if (!folio_test_workingset(folio))
@@ -3717,15 +3719,19 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
 	 * the fault-around logic.
 	 */
 	if (!pte_none(ptep_get(vmf->pte)))
-		return ret;
+		goto out;
 
 	if (vmf->address == addr)
 		ret = VM_FAULT_NOPAGE;
 
 	set_pte_range(vmf, folio, page, 1, addr);
 	(*rss)++;
-	folio_ref_inc(folio);
+	folio_unlock(folio);
+	return ret;
 
+out:
+	folio_unlock(folio);
+	folio_put(folio);
 	return ret;
 }
 
@@ -3783,9 +3789,6 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 			ret |= filemap_map_folio_range(vmf, folio,
 					xas.xa_index - folio->index, addr,
 					nr_pages, &rss, &mmap_miss);
-
-		folio_unlock(folio);
-		folio_put(folio);
 	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
 	add_mm_counter(vma->vm_mm, folio_type, rss);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
-- 
2.43.0


