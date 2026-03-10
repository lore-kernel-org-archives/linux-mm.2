Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 828F1FCC9D1
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 07:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5EB66B0092; Tue, 10 Mar 2026 03:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15F56B0093; Tue, 10 Mar 2026 03:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C42BD6B0095; Tue, 10 Mar 2026 03:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B4BCC6B0092
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:31:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6E7331A04FA
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:31:07 +0000 (UTC)
X-FDA: 84529332174.10.F44AC70
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id D372618000F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:31:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773127865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ookcdczNtb9Oy3RXvPYPyKSGn4b7Xq32nfaGoxMPLz4=;
	b=lch8RmBE83wfLJKeR8F+sSBXhkrKxlG4lRJ82vpYfgWYa0x5nTMOQqclq8lzmSeGXhIcCu
	7rCNlDeXjLk41V3OLx8EvS5UlQp/BPmR4QuLuz6aYoJsig9m9oZe5rid/Pqlfw6HmQBBb5
	Hr/1KoLtdVX9HUGmmeqHiCIgSuEbkyw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773127865; a=rsa-sha256;
	cv=none;
	b=QjnCTQ78tYvlL0AWeLgM8Kfx8hxHmI0UWGucYNNORaJQTmNjX0uxCibsHc99Ywrf+Pc4Yi
	EPHUoIKhP51desZCb15mSF2h+nu6bqwtpCaoCBeZRl6hGdlrcZUuU/E6ZvMK/tMAxreyBU
	KKlt7rP45v/wXxZSwx9Gbfyoxnv4MZo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CCA92169C;
	Tue, 10 Mar 2026 00:30:58 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 30A363F73B;
	Tue, 10 Mar 2026 00:30:55 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	david@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: weixugc@google.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	pfalcato@suse.de,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	ziy@nvidia.com,
	kas@kernel.org,
	willy@infradead.org,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH 2/9] mm/rmap: initialize nr_pages to 1 at loop start in try_to_unmap_one
Date: Tue, 10 Mar 2026 13:00:06 +0530
Message-Id: <20260310073013.4069309-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260310073013.4069309-1-dev.jain@arm.com>
References: <20260310073013.4069309-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x867y7jk9wqsixfdsqyfkb1mb5xijktw
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D372618000F
X-HE-Tag: 1773127865-572403
X-HE-Meta: U2FsdGVkX18twEyFp2LO/9XVjO4aS3rmRaGi+nftMUWPMecfFxnvUPU8/V0xeHCkuLe1rXOfKnlVLltSs93xTFx/6nb1ANIIV/h/SLkdOxPhzMlQjRfsYtfFPoidMbo9tMX2PS0HmvB48yIEmlsB1nYQAZVm6YsMQPXso/PKGNGEA9XLiMXLmw22kp+nMBR0vMs0DPILw6ElBDF8C6CBIWnovpoTZZTVQUWHLSBZQC/uLH2gXI3Qp/rWwEdVKfD5dZsIO6XRjfss1/Wzm/1rPeSM27XfHp8H9tbhWhu7LwuH5MLbOeqGBXJm1lJN1GcRGvQHsTGqkYY5FdmREZf67KXMvZosNaLxIJ+iILCP5a4wG46ezrtsdsRTwevUSFl0DlLG9Lb1WdvgVfNytSaJ57M+8cVa1VbSnlgtpxse8Y48Pr11oDRpuvxUhhvE4yfjcAoDtqIvYuByojQcuiIA1fsJ1PqrpghpAcoRfVopUlXGFWQDvhnlvllTJHwDfXgiNABPQvBtcJub7X5Qxa/n4nlNnI/VEDGL+BlL7RN4n76YYB5siB+OHb5dERHfR3PkhkaJenkgDVqs75qdx1vGlhWabpDrdgnbRd5D5y6SgwD5PZuopnKKEVZkbnWKlcHzdykuqeq7KX+vEaWAXIVkW3memyv/QumCL2sT5er20xKdKnkR4ApN9n7hSXWFGJ/jofvdAtx8KTPrps0YklwDNSYp8TVZXQjfCM+xe+z8gxPqVIXQXEKzAb0wzk/1LbVNLeYqBF4EFezmbaHM+rxx/eDf9wfPaScvFLmIjKHkNqcUN+HOleLaAYnrUibyku+UaLpWlwe3OZQ0CtBl2lXAf1SGJv8VAVKdx9fISg8H+KDu5hZch/9TJX8cNr6/KrnuPMZeyG0hTsfMZ1quB7ZkoJp3p+qFLCQ+oDrxXKBM1vGUQUJb29HtQkWS6Yz9LqWPzt9e9oylANjP43e/Jem
 Atojjknz
 6GUmFrZiZpRD2SVMqonawrzh+1HY7Os4wb+L9ZCRSFY3sH+j8RyLgKphdcZZl/A6+AO1yKB7owugu7sOr2LWsDmdgAjR99xymbAmfMaXPdXgEtJAgNK4wJCMJPXO0LFrnrNjrslwvaypWvPAeGz9XqUPcyUQaw04LmkGVHiJOkTM/4UKboiagABvE5SZd0cKN8LWI6WIKd5OqKJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Initialize nr_pages to 1 at the start of the loop, similar to what is being
done in folio_referenced_one(). It may happen that the nr_pages computed
from a previous call to folio_unmap_pte_batch gets reused without again
going through folio_unmap_pte_batch, messing up things. Although, I don't
think there is any bug right now; a bug would have been there, if in the
same instance of a call to try_to_unmap_one, we end up in the
pte_present(pteval) branch, then in the else branch doing pte_clear() for
device-exclusive ptes. This means that a lazyfree folio has some present
entries and some device entries mapping it. Since a pte being
device-exclusive means that a GUP reference on the underlying folio is
held, the lazyfree unmapping path upon witnessing this will abort
try_to_unmap_one.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 087c9f5b884fe..1fa020edd954a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1982,7 +1982,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	unsigned long end_addr;
 	unsigned long pfn;
 	unsigned long hsz = 0;
-	long nr_pages = 1;
+	long nr_pages;
 	int ptes = 0;
 
 	/*
@@ -2019,6 +2019,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	mmu_notifier_invalidate_range_start(&range);
 
 	while (page_vma_mapped_walk(&pvmw)) {
+		nr_pages = 1;
+
 		/*
 		 * If the folio is in an mlock()d vma, we must not swap it out.
 		 */
-- 
2.34.1


