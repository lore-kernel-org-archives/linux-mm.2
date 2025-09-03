Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9746CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 08:42:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A5B48E0008; Wed,  3 Sep 2025 04:42:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 056718E0001; Wed,  3 Sep 2025 04:42:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE768E0008; Wed,  3 Sep 2025 04:42:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D74238E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:42:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E738BA285
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:42:26 +0000 (UTC)
X-FDA: 83847297492.17.87007B7
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf26.hostedemail.com (Postfix) with ESMTP id E6DA414000C
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:42:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756888944; a=rsa-sha256;
	cv=none;
	b=opAFz0yOBnAiO8TXVvCExOpK3SbdJUGyFCuEtxNRxo1qvuVcYS1T7Df8aB/kldHnepc5Vh
	sZpMfmg0PF6lthHXMjiZ7uRN9U7OCP+DnimVAC8WBk1QfxaD5JB9nfkzTwuypycyNo04Ur
	/6LkfCe8iVEflqJ0jj2Nyo3N0kggADA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756888944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=V6a7l0GPRDx2xh47VQ6TP5rBICWca4ldNcroSjlOhwQ=;
	b=5r/6Sn6fcpfUrPzznX4EbDOLeC3oGuFOq+UFfG3ps9Vf+JnHYP1fx8zj+/D+DS5tpq7Vsc
	Gx8Zx9qS0qLw6K+DCCOSKxiZNWMl6PXFTa6IypLf9x0bh7DAzQjlKa4jj/U8Y3+sWkifuL
	+jK6ntVvcjWgzCoP/CYRnt02T+U3+V4=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cGwwZ5bWvz2CgS2;
	Wed,  3 Sep 2025 16:37:50 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id C7258140297;
	Wed,  3 Sep 2025 16:42:19 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 3 Sep
 2025 16:42:19 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <willy@infradead.org>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <tujinjiang@huawei.com>
Subject: [PATCH v2] filemap: optimize order0 folio in filemap_map_pages
Date: Wed, 3 Sep 2025 16:42:23 +0800
Message-ID: <20250903084223.1653192-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: E6DA414000C
X-Stat-Signature: j1d766ctmff98qecsoeo85oc9ueyngyu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756888943-4764
X-HE-Meta: U2FsdGVkX18i3jfgu03RL8MUbHPQiWZ/SpEMppeb3Z4uW39iqmfqtB8yu/+Aivj2ab7PVFexSel4Qpl+etN1yGRoG4oqexLWiSypXR/k40wgOPgIMzYApzOiup6FRhOWwORWgQb8mq7jTsqch0rZhJMuoShMnf+f2NFJWUdhfUuNfPvCXITj16x2Z4IxR9o92geCY6ZfkYygu/n9ONcueW/m+hRdmE0AywNqIxrOGjox5n6zUJT2yI1JPv9r+dzgsD5kVMN8jokqcz2O6PjsLXXKlzG4j4d0bEae3WrfqO08eeGzCk6wnuV3VH2e28zIPoSNWX6EjPSh4O0yf/0jwPb1Jtv9GQ8KyTGF5zT/GLK7lcKOvV3CueALSqDnVwxLyGiLF+f4nweHxfWrwjEvxYHeqyil3iYJ/Hgy7tRKoLPOQ9sj2lbnBIokU6knhaMshn3/t+BverSQ6Se6pPAelNu4aw7X4CXtVY/KvmOLVcJH7zd8+HLy99Rzw2mOoynWeT59BOjmWWOPoTmfvue29VMcK4tG3yklTKMjzcp8H/SrexjpdA5UJ6qj/dPO/IPDA+5nMYeFbVh7r7B9XluaJnIr8ATzAmHmXL7mPNVJQWCfnZutKWjObhH6J3BZ5eiihBsdFd+kODAshoTlPnPw+LB8W9MfssrLpKC+AJCrDicpLWlqGMj2+6B0GlLnNdwL1M9nRWB3WX3whHie4WFZOy8jJQHoj4H++IXyhBAMCwvu52HAiYx2L9FIxsuSSFA4Vh+iOtfxfg0b6r76aFnpvBOnjzZz0rLV9mkO6ASpycxsJqeZF0pUDbeOm2h1MjypZCEAH8VODDLHHun1tYOr0zE5rKY6NmTAVfU/LHW8y3POQyGAF2pYgcsZASSISH72T38+i2j1HZ0xU7PRDkwHDleTRooCqfPWzVk9zlW2ZEAh3iR2ciykRFPgYOAKn/BfVxrsq3jev3w3P1uofCQ
 Kj6nxBU4
 GWbfOO/OW23eucN3mw0tRPs2mAC0UbkI+C/KVp0rxAEjcpVdWJslQ4IKZwmtuLIRYj5IQYt7E0S9IGfxX6BQoAs7NiDZX2fEqvbVDz8eRUNC/UgT/sKvhEGBQpdARi4i1u2veAJBj/t6lHE7mATrNXtbh+yJTXnxrua2GbMwpJcfHVrdSPDnlPYS3gDHCZjxne5iiXiYqfuB8li1C+a8TxwD8BhUQ5V21dbVALAhiQ3mTWOVUb1F68N8m23dOcwyiFLz04CUyF3dIJUaQ/lPOqHVXkFnpGB5mqHvkeWiLgjHi0zxe5UkwAVZm7V2//03nkG1twgpH13Tvj2lK5veCoexsmIo527xax9Oq
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

As Matthew metenioned in [1], it is safe to call folio_unlock() before
calling folio_put() here, because the folio is in page cache with refcount
held, and truncation will wait for the unlock.

With this patch, we can get 8% performance gain for lmbench testcase
'lat_pagefault -P 1 file', the size of file is 512M.

[1]: https://lore.kernel.org/all/aKcU-fzxeW3xT5Wv@casper.infradead.org/

Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---

v2:
 * Don't move folio_unlock(), suggested by Matthew.

 mm/filemap.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 751838ef05e5..3da8bf8b93ec 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3693,6 +3693,7 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 	}
 
 	vmf->pte = old_ptep;
+	folio_put(folio);
 
 	return ret;
 }
@@ -3705,7 +3706,7 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
 	struct page *page = &folio->page;
 
 	if (PageHWPoison(page))
-		return ret;
+		goto out;
 
 	/* See comment of filemap_map_folio_range() */
 	if (!folio_test_workingset(folio))
@@ -3717,15 +3718,17 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
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
+	return ret;
 
+out:
+	folio_put(folio);
 	return ret;
 }
 
@@ -3785,7 +3788,6 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 					nr_pages, &rss, &mmap_miss);
 
 		folio_unlock(folio);
-		folio_put(folio);
 	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
 	add_mm_counter(vma->vm_mm, folio_type, rss);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
-- 
2.43.0


