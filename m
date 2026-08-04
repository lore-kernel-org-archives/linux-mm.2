Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23A11C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F7556B0088; Mon,  3 Aug 2026 23:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A7856B008A; Mon,  3 Aug 2026 23:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F003F6B0092; Mon,  3 Aug 2026 23:54:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D37896B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:54:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 616AF808C6
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:54:08 +0000 (UTC)
X-FDA: 85062218976.15.F5E4B56
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf05.hostedemail.com (Postfix) with ESMTP id 888D2100007
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:54:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=deXx8CPL;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf05.hostedemail.com: domain of dayou5941@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=dayou5941@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jL6TZSIIaxE3VnFNE4Cj/OVuuzHUDt6NL1JVnhUmx4U=;
	b=ssmuV1ToQtRBS3ZdGE2fzGJESQrgrpCKC7CVEwWC7l5dRz5DG5dUFoHE/o9wuW5O7QAchp
	b3NAXM1W9leAsNAmkdcgJBUy5ebWc9lRG3muotruC+n7wtkS3VoR0vFnGPMrWWly7/ZRYS
	zWyn391XIaYu+T9ZZX9sPLLKLpNHRwM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=deXx8CPL;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf05.hostedemail.com: domain of dayou5941@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=dayou5941@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815646;
	b=jAPx18uQlIto07IiC/WDMuQA7Ax35Mlm6FJVuzUryMjOjijuL0QmmvnzpCPi34oqRShIHq
	f+nfa5tF6dqgPOIGUNYfsT63X4wt/QcFa92Y2dU/SWqy9EHEVUvefdxTSFUgb9dpXK87BZ
	Q2ypCObHhzAPWW2EQTuyOVyvwuta5n4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=jL
	6TZSIIaxE3VnFNE4Cj/OVuuzHUDt6NL1JVnhUmx4U=; b=deXx8CPLIrKYcJZqzk
	fvcPUuG6mClyu9QOs9dYop+xQwyIFfOQxzwpJwvmbgmjoHr/PwrWKvjOR7JgHAh/
	UQ2sT1cOdQiiGMQfsI5zYrXJVJzmf+oyV/40zaggDUD6wueq8SkHOtesiR0dyNKP
	HxPFSEw2yQfLtX28iTziyfs1c=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDnra9VYnFqbOFENQ--.8761S2;
	Tue, 04 Aug 2026 11:53:58 +0800 (CST)
From: dayou5941@163.com
To: linmiaohe@huawei.com,
	akpm@linux-foundation.org
Cc: nao.horiguchi@gmail.com,
	linux-mm@kvack.org,
	liyouhong <liyouhong@kylinos.cn>
Subject: [PATCH v2] mm/memory-failure: fix refcount leak on soft-offline LBS folio
Date: Tue,  4 Aug 2026 11:53:56 +0800
Message-Id: <20260804035356.2615408-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnra9VYnFqbOFENQ--.8761S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGw17JFWrZw47ZF1xWr4kZwb_yoW5Jw45pF
	WfKr1rJ3s2qr1a9F4xAwsxZr1Yk393Ka18ZryfGas8A3Zxtw1vkFWxCw4YvrW5GrykAFW8
	Xw4jqF12gan8Aw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07joxRhUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC3RilVGpxYlh+xAAA3v
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 888D2100007
X-Stat-Signature: ssrhi94en3ediz7wygtqccwt4syntcse
X-Rspam-User: 
X-HE-Tag: 1785815645-641188
X-HE-Meta: U2FsdGVkX18glxK+MPUN+vitRD5BD6Cn3Olsdk3KqM/7kG17uk7qsPxa37esY+Q7OrJpFmT+u+KvUuAhD7iJbm5hoUSToRbW9erCdE357BdVoza27xbwUdYtppWs8PzFvuvhIMZLckQ7hg2bIATZ4Ta7rpsb31KhLsoLUmf3hHbkX4r7ZvW1YWzXEf9AYdNDenEma3bn+qADX2v+pnuxR0ZHdaPR4lNku2iQo7MvjCvM5u35T3QWavdGCjzZeTd4tLsvFIHeGn55+O+cXaTeigODc+61tAmHbM/kLmj4NKNpPVaPyVHxUCucKQOvoyVbc77+BIr3RDb+8TdWIJpslHrz0XSfhYx9u9F8mQ4AHsmgwWWivnuLN95SaYczcj56wPNVTpesscg5lhVt6Y4vgm6SpZojtFo5hNmYCtP7AlSUbLdCTZfCFuEnL5ttcgZ99VTkBWoh0lAQeBhCxw8fQ8reemMDgk37WAJNCgQJxTQezsQzve0SpENZdTOMwFBs5Ma1o366TjQoNAb/ymwIRJCyLC2e4gF5V7Z1F1TN/1RDSt+75LooPB1O+srHalz0ViZB63YgQqwmxV8GrNe2UXXTm5a43Aee17mBEMBAbJHSdPxl3yb3y9l0lnNCZRUqf51HtEBhT+dsNOMsrdJ0CNFxs2Pa9uTgo+QGFr5x+N4I7X8oLRHyd+HWQXr8mw6RO2TuXDDxd5NHXFEYPRhQKgP/M4XpInEm92ddAIFw+EDKz/7Mltsmtfu++mS0NT1gXgVo4agDdcqa7S2TPOfUIZQSZAJflSJEuxFO611vqmtfdCsVWdQFurY7Xe+epLHlFgTqhmBgo1cH74YO5BPbR9835H0OPKJOxigDjjR8AyikJBTmWsaqSdPHE776e+xpfHv5uoK0Jp+FS5i25SKplnxN4G40kdrl1g67D1lG14g/9Un8CAOlEsz2XBai5dW7ihp4JmBgQtYG4kDjEpu
 R4Yzr8un
 YFSI6XglEGw683QWgJi2Cc/KuPkGXV9bWkN5dPlOpZxW846Ne53PADxPD4AmTEg+RvV7wb1ObxYhbH35qWsiGQaX0sASMfV1elOcD8OMxx2pJm2X8+OZKUNCE7AAwxYpghH/pwIPOvWcfa+OwI2jJzLrAwKgoyQgido+zVFIOaKtr3I9ATMzYjRw5VLBdRab9b/6/qIjBAfA/jxMOWdWlp/Cz53IP6riZfjN4OP+IvrMujYbGyrCTpVQT/tqriDyM08wKahtOIqIV114FGe0vurmI+Yaa4EzflBNWFOSStUAoJr+qmvFdChOVVAZsYLsz1F3LX9B/13eYd99vUH5FqGHAvY+deb4yrbGVysomDbWqXGzgqtpZ2Gz74TN3M7cf3tKYl0hK66EaxT0/wLQy2KiEKdMM2RfDUGt5Y735xC9B7LqMsnILjyp/FxLri0e6tu/rZNfCaOo1Br4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: liyouhong <liyouhong@kylinos.cn>

soft_offline_in_use_page() runs with a folio reference taken by
get_hwpoison_page().

Soft-offline skips splitting when min_order_for_split()
is non-zero, so large folios stay intact. That early
return -EBUSY path never drops the reference.

The other failure path is fine: try_to_split_thp_page(..., release=true)
puts the page when the split itself fails. memory_failure() also puts
explicitly on its analogous unsplit path.

Handle the new_order != 0 case separately and call folio_put()
before returning.

Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
Signed-off-by: liyouhong <liyouhong@kylinos.cn>
---
v2:
- Add documentation for the folio reference counting convention of soft_offline_in_use_page().
- Remove MF_COUNT_INCREASED related description in commit message to avoid misleading.
v1: https://lore.kernel.org/all/20260803060001.800638-1-dayou5941@163.com/

---
 mm/memory-failure.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 51508a55c405..3b1e6946821b 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2776,6 +2776,9 @@ EXPORT_SYMBOL(unpoison_memory);
  * soft_offline_in_use_page handles hugetlb-pages and non-hugetlb pages.
  * If the page is a non-dirty unmapped page-cache page, it simply invalidates.
  * If the page is mapped, it migrates the contents over.
+ *
+ * The folio refcount has been incremented before entering this function.
+ * This folio reference must be released before the function returns on all paths.
  */
 static int soft_offline_in_use_page(struct page *page)
 {
@@ -2801,9 +2804,19 @@ static int soft_offline_in_use_page(struct page *page)
 		 * NOTE: if minimizing the number of soft offline pages is
 		 * preferred, split it to non-zero new_order like it is done in
 		 * memory_failure().
+		 *
+		 * Drop the reference obtained upon entry;
+		 * try_to_split_thp_page(..., release=true) handles refcounting itself
+		 * when the split fails.
 		 */
-		if (new_order || try_to_split_thp_page(page, /* new_order= */ 0,
-						       /* release= */ true)) {
+		if (new_order) {
+			pr_info("%#lx: order-%d folio cannot soft offline\n",
+				pfn, new_order);
+			folio_put(folio);
+			return -EBUSY;
+		}
+		if (try_to_split_thp_page(page, /* new_order= */ 0,
+					 /* release= */ true)) {
 			pr_info("%#lx: thp split failed\n", pfn);
 			return -EBUSY;
 		}
-- 
2.25.1


