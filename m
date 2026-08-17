Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D193CC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:21:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC98D6B0847; Mon, 17 Aug 2026 12:21:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7AEA6B084A; Mon, 17 Aug 2026 12:21:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB9156B084B; Mon, 17 Aug 2026 12:21:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABFB06B0847
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:21:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 402C1A337E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:21:24 +0000 (UTC)
X-FDA: 85111276488.22.FA47177
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf28.hostedemail.com (Postfix) with ESMTP id A13BBC0007
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:21:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=nJpuQfOJ;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf28.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786983682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9F/ACPnFlOKzN1qnCocK+E50n1xvgbeljIK+tZNmXMQ=;
	b=uApcCz4m2MiPHqAGopdV+9GsDR5KRMkBtyXo98hqO4ARvjMVJFUPySu9nOlbvLlmzZB6JK
	ikEFp3G9Ayw5AvbfMznscpp7f4IlfHWdF5wrpLTyE4U51BOyLFsP976GJbZmbhznAcWqro
	YIaSpIVk1761x/LEEJcx39W/atV2WEs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=nJpuQfOJ;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf28.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786983682;
	b=QqdwUejFUS0Wg6/sQayAT6r861lncITHg9+uzZpgqRSc3kEi85WPYSmowhrsnIBZRIDWPu
	zrM+885lIganpcwo/nuG3+PNPR7KwUc9sahlBGIXiclabumkZy4W5Cnes4MOtl5CBpYZkt
	SpXQPkITtYa6NO8YC7fpis7MVfjLuqA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=9F
	/ACPnFlOKzN1qnCocK+E50n1xvgbeljIK+tZNmXMQ=; b=nJpuQfOJHi3VbxiEMc
	gO1WfDjsU6o0FEJRIcOBNKDB6L/wr6gohlMupxocT8BHtUGoVeNtf+bAoVs20utm
	iwDEIh6+RA03yo0XVqOxXNTzYagYIHyDdv5zpAl0yNAuE4e9iwN/vDfjudYigZes
	so9FVGgPyEw7KbglB/V6r+AlU=
Received: from XLL-9950X.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgAHP_3uNINqKLsLLw--.30203S2;
	Tue, 18 Aug 2026 00:21:03 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	mike.kravetz@oracle.com,
	mhocko@suse.com,
	linmiaohe@huawei.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH 1/1] mm/hugetlb: do not dissolve gigantic pages without runtime support
Date: Tue, 18 Aug 2026 00:20:36 +0800
Message-ID: <20260817162039.1511838-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgAHP_3uNINqKLsLLw--.30203S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cw4xCry3Kr13JryUuF18Grg_yoW8GFy5pF
	WDWrs8GrWUXF9rua1xJr1UXrn8Jr95Xr109a4xtr43ZFnxGa4DKrs5Ja18tayFyw1fJa1x
	urZ0vrWDX3Wv9aUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jYWlgUUUUU=
X-Originating-IP: [61.171.197.12]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC2xDEvWqDNPA6QQAA3k
X-Stat-Signature: 9u8f94nmho9ko55nrxc79ogi39mmgz7m
X-Rspamd-Queue-Id: A13BBC0007
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786983681-35317
X-HE-Meta: U2FsdGVkX19f/J/j21LwULVUU54UHoJtocwIDl5QdhP/q88RW+WHZvTCRb2+46UOmqT/+eN071yf2iV1x77NzYeUC6uoLRD1wC4PyKkkHhp2S/8KcMpfTxNZNwZEZTCmDJPzYN/uaMRyznFJMXddm9AfRs3L1Xrkzpl3WVVbM9iZ2lAfTG/i7JpWGPMVlCQQ1E1Q2idNH1EePH3hNq83TSesa+De89OD7vYBKV9N1hg4ZbH7Ed5IzU8g/cqwD5A6Hh+SpW8qxWZvF+0G39nuOnUzFS3PXIoRde+RBiRSI8Z/Z75zEDE70aGa+teHBEVBu5jegndwFL0C9WsOEtNPzUoS1zbG8ovRfI8UH25U2KGO/ivbyrgC1F54WQPO2HzzcLICK9XM/LqpbKzK50zpeulydmbQd7R/NgPZypWzMiuLiaEoz4kFLRnGgm3F7lABoTcSizDDdoQ6bZaEkDMSf15YkgVBpkkWgc/I0Ik47uVwE0RwHnHvIUkXxIsX8lfhvo1EdwYGzqNo5RqobrzKrltRoHSma2B3iXolhGPS6pi1KfOy8sZvu3aHB7djS0ne6E39TftgNIq3SmlTGFE6kLnq6/tJH9cqyDJWkQ9z+Cz0TeLMBqj2S2pJtZIOJU1y2Bi7YGNDhlU1FcWJz7SyJ9pLhBYYqBk7SsMhhPU4Bidv2SXNM3ZyWym77zAa0JGsirt+oVSu2xxprJJzZPJ3yPVVlFA0fg5kV+YrYOc1HQLj3baq364blddoCI3teFuf9+UFlM8z3P1crN3x3tzcVW83FPdXz0xPyRhQlTtRXzC3dGLJcTCd+iP2iy2YrsyuHIBvJc3G6ZzHiB1Mcyaz/Iurw7CWY3f8k+dGTqTabu0kSxqBBFgpZInnYkEVlVOdU8x2c4RvzDVvZsxOSu+UBnOWnrmslcwQyiHOxogukKihuS2JswqpkBBv8oGQvCoW/w2VWewi1bP/yCVjFpg
 ZbpqjGy+
 SD9hq30z6yVQTXjHEwxPhMgjYA1EMU01gU/JP1r+wZUxoLoM3XT9CNQEHluixqU/ASWK/KJG7afRg03s/D6A5mN8eC6xdnnVsm/SMfM14g43PklnagJGxGbV49hq9Zf8ClL7oYkVDZlCxwaR/lbCR1L6/SvrYBjW+TT/BjaGlgaOtF+gJ7oxZOZbBZi8A215wNleEHlMh0yPd4OdG1w0kkBkBe7PnyEy0a+XCKc6HDwRWnewpA4XCOYa/vxv0XVfEqPplGjdmI2BsqUHm9tCzJ20KPWnfMnIriQwUYeC603nMXpPCBtEQbXRA/CR80qQFsaP2JcbuS8+Wlvj11jQiut02kmvQ4ivu+tL9pjnj0IQD+XwD7LFcmbG5yML0RUGB61oNcXJLuLiEz/Y60Ykwxk9AmafCpDZAKGencZc1HaW3BrU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

dissolve_free_hugetlb_folio() doesn't check hstate_is_gigantic_no_runtime(h)
though remove_hugetlb_folio()/update_and_free_hugetlb_folio() silently
bail for such folios, so it frees a still-listed folio and, on vmemmap
restore failure, the add_hugetlb_folio() rollback corrupts the free
list.

Link: https://sashiko.dev/#/patchset/20260814083027.1419487-1-xialonglong2025@163.com
Fixes: 6eb4e88a6d27 ("hugetlb: create remove_hugetlb_page() to separate functionality")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/hugetlb.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2239e2566a52..f8370da93647 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1977,6 +1977,15 @@ int dissolve_free_hugetlb_folio(struct folio *folio)
 		struct hstate *h = folio_hstate(folio);
 		bool adjust_surplus = false;
 
+		/*
+		 * remove_hugetlb_folio()/update_and_free_hugetlb_folio() are no-ops
+		 * for gigantic hstates without runtime support, so dissolving one
+		 * here would leave it on the free list and, on vmemmap restore
+		 * failure, the add_hugetlb_folio() rollback corrupts that list.
+		 */
+		if (hstate_is_gigantic_no_runtime(h))
+			goto out;
+
 		if (!available_huge_pages(h))
 			goto out;
 
-- 
2.43.0


