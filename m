Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 434E310FC456
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 01:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 631DF6B0005; Wed,  8 Apr 2026 21:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E2BE6B0088; Wed,  8 Apr 2026 21:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F8B66B008A; Wed,  8 Apr 2026 21:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4027A6B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:43:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB1101A0333
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 01:43:38 +0000 (UTC)
X-FDA: 84637320516.15.2A2976C
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0B57B40005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 01:43:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GCefANrc;
	spf=pass (imf12.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775699017; a=rsa-sha256;
	cv=none;
	b=6q7p2cQ74cjVpF+/DYA+yGL9D8cT9LQ/NIdbi8i3kjHjcfyGQi5S8PxjvMGpoO006yNZht
	BlbeN+4+FcF45L8iuVFikxuygzLnlYX6amRfbx4SLBbCRnBlksZCOFF/yUgXVZZRzi2oM3
	jDgMj7nQbgefb/HvkLpECcReZB6nd/U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775699017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YyOcfs4RbmFbfLD1gD7SLpTnMTWxwH0cAknM+2b/2so=;
	b=wzIiQIhrbvZdKWJg3GyqGBaEYbw4136RDgR/I1Eh2GCbCdNK3Bh99GSNM1VmC6kRFFQbln
	UuFR/nDZC1349ctNVf6aIyElBjPQtea4iPZoIuOR3AGG3tn6S4jVl21whwhhH1xwHjNTEg
	PmaNdYWJ1lBRLm5MBiasv4q8mfi2ZlI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GCefANrc;
	spf=pass (imf12.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775699014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YyOcfs4RbmFbfLD1gD7SLpTnMTWxwH0cAknM+2b/2so=;
	b=GCefANrcjTcgoArGavz/8QXmV7OhLYJwxPguf8WsExTszsNR4Be2PotIiq2No9MGAQOiPa
	Os8VwCeKssEKPdnYc3v453qu0flxDsJ7IUwuptzzKRXKrc42bVzlFcQepq+NcMeUdro/hc
	ZFNNCVi6jE2AC+DHkOoxObatUJmONrY=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/khugepaged: use ALIGN helpers for PMD alignment
Date: Thu,  9 Apr 2026 09:43:22 +0800
Message-ID: <20260409014323.2385982-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0B57B40005
X-Stat-Signature: zt1kt5esi3en1yqzg54f1cckupygw5ff
X-HE-Tag: 1775699016-335022
X-HE-Meta: U2FsdGVkX18wZ+elfa0t8crxYQGYxCkx6WxYk1wGwuCeH2JAgouOlbDCFCHJC6z89zyasL0+EymFO9NjngdqnZir6gH2D0Wi9yq/ueR73/8mKEX1ncLo6ON4s9a5lqwVb8nWCi9k5UMotii3KPem0RA/NFeViiGmU+DnMTrWBaFKeP0yF7k0awbmCZSr1yLxoUOH44gNz25NT09SmM7EVKpoluUN7WhwY2YnQQABtTxdJks5NyJ1s8vqZuNF328aBOS/zbaghI70xBDo+D3sntFrBCeR/4vjsREdPWjjE67EV5OScmDcgsRqdt7xJekEMVWnfrX479JXaNDSXagVHCNokZB8m062wAVnuBqJcoslp9cYWm63lHXBDdQpN1abv7pVRC/BQ7FxtD5n2q/ifLdfozoHmLT146oQYRXtIoLdxNESap6guGFC/gLCjBoI3wfmqkH7LeNJR5ede+WSJfpuxnNMLKXtqj8V4VOGXQfvQKN59s2NkkH0q0PUM/bnCVQJVMSFgvpV7NBXcVDs8H/U73lJQo+x/Qfqq9AnyQ8p2zIoCFCcwN6uvZnVqt2SH/LQ1Tfb6GOh/SXVdQdfVA+7rYy2M4tin6nsGumjaRaSZNHYP7iOlmVP+U8hviQdaZ2oC9iigbjHEvHQh3BKhH6PVpgAHz1DKqjM94j7EUaA5F6Thp0yDeFZQBtCsbgm+G/Nl2pyiDGVHrIGqbH3AzxjZvX6ADK7P8EHCK0vgSG9Pjpg6KwsC3Xv6638l3szxm/EXTsQPZaeSnVUoBoOTj9jahVaTxhxYRGSoVBDZDYsjQDz/YarJopVw7RQHi8COq2EPymXYZ6ErZpeAtpsHliW5IoeFfeh6+saIf7/M23dUNBJeyvklH7354J70sAXg6kfs7jLNniNJjmcDu9xNHJzAAnJmUWDhKdhNVi4Nej7fJONY89hKzCgYEEmRbUYdFAzXjlPDcz5tNo/UcE
 f1fRH8+u
 RKZ6FfGfy23cBI3N0ag13c5s8EO4p6kbA+gJBOx+NUIz2sL3BYGlefeC0wpfJ33dUnq6ptTAYPiajRLQBEzXwonkTqE7nT3F7iL3kvuxvRg9px2LSzXRfDjDXyqets44Vw3dTn8jaUpKkjQl8dis1LwrPQlhkzg01rUOpkNUGE44zv6pfxpFVYwZxDcozqDp+/O1u5fC6fDE+MG+rQ1ti78HFOBmaXtuhJD0K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

PMD alignment in khugepaged is currently implemented using a mix of
rounding helpers and open-coded bitmask operations.

Use ALIGN() and ALIGN_DOWN() consistently for PMD-sized address range
alignment, matching the preferred style for address and size handling.

No functional change intended.

Signed-off-by: Ye Liu <liuye@kylinos.cn>

Changes in v2:
- Switch to ALIGN()/ALIGN_DOWN() per David's suggestion.
- Also convert collapse_scan_mm_slot() to keep PMD alignment helpers
  consistent within khugepaged.
- Update the changelog accordingly.
- Link to v1:https://lore.kernel.org/all/20260408093534.2373007-1-ye.liu@linux.dev/
---
 mm/khugepaged.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1e2bff40d014..1b1d1a881ec3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2518,8 +2518,8 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			cc->progress++;
 			continue;
 		}
-		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
-		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
+		hstart = ALIGN(vma->vm_start, HPAGE_PMD_SIZE);
+		hend = ALIGN_DOWN(vma->vm_end, HPAGE_PMD_SIZE);
 		if (khugepaged_scan.address > hend) {
 			cc->progress++;
 			continue;
@@ -2835,8 +2835,8 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	mmgrab(mm);
 	lru_add_drain_all();
 
-	hstart = (start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
-	hend = end & HPAGE_PMD_MASK;
+	hstart = ALIGN(start, HPAGE_PMD_SIZE);
+	hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;
-- 
2.43.0


