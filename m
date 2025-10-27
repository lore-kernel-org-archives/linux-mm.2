Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7C45CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 14:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F6A080058; Mon, 27 Oct 2025 10:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A7378000A; Mon, 27 Oct 2025 10:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E40480058; Mon, 27 Oct 2025 10:03:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 260CC8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 10:03:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B85F755B63
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 14:03:05 +0000 (UTC)
X-FDA: 84044060730.19.F299B8B
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf07.hostedemail.com (Postfix) with ESMTP id DBE6640004
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 14:03:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=SLK2W076;
	spf=pass (imf07.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761573783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aF4TpgFPzQfQ4TxKLvGD5GPPUdCoPIU4OMOOCRwa9L8=;
	b=DLe7P68EX73rWjNKdx1lvfYAyeGuBnQZDxWw+MSVLKJM5Di9Jt0UQp+p3hThHP4sFd8da1
	Yg0XFuasClC4r636e+qzX6c7y4mPzCFAmryXyVJfXgSAsvfRT62+tNtXbcZARn9CjPJclf
	2Pbfw3aiFhiosXjben5SL2nqJnLQC1E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=SLK2W076;
	spf=pass (imf07.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761573783; a=rsa-sha256;
	cv=none;
	b=P0SA87mXNutyEjV9rTOgGInvmyXFqlQM3J1mTRHOdzoKNTkxQKUK5zJjesqjZ9RoMfrBzQ
	xt2bmUxZJ6QfpdEGUJsne8AV9bUDTsFM+yPCZG4qTjUpbse7XE70cAOYR3/qbbM1l10jnw
	HIbiROoKQ/rxU1hp4yoEY7mXqXCjw1o=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aF4TpgFPzQfQ4TxKLvGD5GPPUdCoPIU4OMOOCRwa9L8=;
	b=SLK2W076Ok61yovfnWNUbNrMOgVjZYGy30HtbXGUgj1rSQ5AKi3f589GAdFlixGk2LTeF74hD
	SD+8xT9PHE7iVCCKiyCs5wIOKJIIL2dNa3mD4XkBQr/dmyg6JVW+guG3ysoM1iTRIDrdFBypPf3
	PWS7WLF4OIInXquuCFg4EFU=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4cwFZH3YChzLlSH;
	Mon, 27 Oct 2025 22:02:31 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (unknown [7.185.36.8])
	by mail.maildlp.com (Postfix) with ESMTPS id 44F69140259;
	Mon, 27 Oct 2025 22:02:59 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf500012.china.huawei.com
 (7.185.36.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 27 Oct
 2025 22:02:58 +0800
From: Zhang Qilong <zhangqilong3@huawei.com>
To: <akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<jannh@google.com>, <pfalcato@suse.de>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
Subject: [RFC PATCH 3/3] mm/mremap: Use can_pte_batch_count() instead of folio_pte_batch() for pte batch
Date: Mon, 27 Oct 2025 22:03:15 +0800
Message-ID: <20251027140315.907864-4-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251027140315.907864-1-zhangqilong3@huawei.com>
References: <20251027140315.907864-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500012.china.huawei.com (7.185.36.8)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DBE6640004
X-Stat-Signature: 4tg3js7a8w1n3xffkzoe8awm7eqs6c13
X-Rspam-User: 
X-HE-Tag: 1761573782-926290
X-HE-Meta: U2FsdGVkX18yKOoirn/LDu1VFFH5ZFaof44sqWIgIq0s/r5PDie5AImtBlrzly6ymj3uZmwNrIrauf3lrWi4ZjmvU2rNRunL7dKqGGSd4rnmyOzZqxPbReaER/0S3eKfshwBtcLze/k9wRbxJWsXTEoj9cLN1cRehMDoqbsxN6rLIvi6W5PV86PaKe/JR+lqTKefZ8O+89ibQ2YAe0ewOwwIC1dyDl3osj67UxxKWNaih/OCbiqu1+zboW+uluW10S7wRUtak2FM54hiPZUVS+qgNJ/wJyaYk6cNmjNbjAombhrLlpC4ZS2RfN9s0mkR8COVwXGJevRm3VTLPPJCaPyCvAdC7RFOeoXYCl4NVggJHXui9SUeDmGEvRTkbYem6ERPUgNTUtd3QlneHjxwO6npboJrF4fdlH8Rvj+1UxIaai6kMh5uLXyr15TOSQOwLLHSLjB9X66VqthZdoY9AsIN5nH5/CNHPscNpkN7txWyakn3uHp1PpzviYvewfRfBpZ8jtw4h014ml7cDwbKJ9ifu4+fNLqkH6Bt6edA/rSItcocqjUdx7dBBydderJ21shYYhgSDrpFUXW5OsgbufH8YVT4vgz+mp3dpoLfwPfy26BfanPf0Huz2KAWRW9YBZtrassccnqPAsajwzpsjwDwjMEd+VslmVLPY4p191ad7K9doiuhTgoqlYb1UmX9BlQKAAlZWhtej4v5xuAI9dNssXlss+07UId4ZsDymFR+hi1/LcKkGoxmmOrBqaRtjqId+QiL4b9Ig2OjkM48WwpjM6P6VbRlUctDHoeloFWqvoeVevS4eINKlTkBaXKgrQtVG008DhV/htd6GMNB97RnBCTpub0oqDqhBgpToqeUmDsy601RSlE56mCjZP6IJaud6Ir74psuMd5KlK1jUYuNtDUnUWlqdSKijiTSNdbOR+eyCOKyp6cLGDgBfNg7CkPdxHARXHqMpsJiXj8
 sFdSGJLP
 07qpdJRV60B6GYDRa5V5ctD1qdDUsmb5uZ2dsU8QWN3LHY/3WbtV733mYkp8gCSPgMA4YHpfykj8P7tgKNwMW49YQr6pWdbYhxIyBQgLdHPq6TMYAR7hLfgq/iPA3pJ4RvLyCFFevfxLUIiPqSBHYQ6JTGdTk/4lYI5SipudRvBd9/OFfsioR33gVEGp0NQsUhKw3QMlV20rxOHdQ6ocBQhGByu9sfB8q2o0eiznBY7BlxQioT/apD8+UGwKnmOhGN4V0IhbCa5RonoyreUfISYx+YYtQnPiH2kMciB1dgMS8Fmg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In current mremap_folio_pte_batch(), 1) pte_batch_hint() always
return one pte in non-ARM64 machine, it is not efficient. 2) Next,
it need to acquire a folio to call the folio_pte_batch().

Due to new added can_pte_batch_count(), we just call it instead of
folio_pte_batch(). And then rename mremap_folio_pte_batch() to
mremap_pte_batch().

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 mm/mremap.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index bd7314898ec5..d11f93f1622f 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -169,27 +169,17 @@ static pte_t move_soft_dirty_pte(pte_t pte)
 		pte = pte_swp_mksoft_dirty(pte);
 #endif
 	return pte;
 }
 
-static int mremap_folio_pte_batch(struct vm_area_struct *vma, unsigned long addr,
+static int mremap_pte_batch(struct vm_area_struct *vma, unsigned long addr,
 		pte_t *ptep, pte_t pte, int max_nr)
 {
-	struct folio *folio;
-
 	if (max_nr == 1)
 		return 1;
 
-	/* Avoid expensive folio lookup if we stand no chance of benefit. */
-	if (pte_batch_hint(ptep, pte) == 1)
-		return 1;
-
-	folio = vm_normal_folio(vma, addr, pte);
-	if (!folio || !folio_test_large(folio))
-		return 1;
-
-	return folio_pte_batch(folio, ptep, pte, max_nr);
+	return can_pte_batch_count(vma, ptep, &pte, max_nr, 0);
 }
 
 static int move_ptes(struct pagetable_move_control *pmc,
 		unsigned long extent, pmd_t *old_pmd, pmd_t *new_pmd)
 {
@@ -278,11 +268,11 @@ static int move_ptes(struct pagetable_move_control *pmc,
 		 * make sure the physical page stays valid until
 		 * the TLB entry for the old mapping has been
 		 * flushed.
 		 */
 		if (pte_present(old_pte)) {
-			nr_ptes = mremap_folio_pte_batch(vma, old_addr, old_ptep,
+			nr_ptes = mremap_pte_batch(vma, old_addr, old_ptep,
 							 old_pte, max_nr_ptes);
 			force_flush = true;
 		}
 		pte = get_and_clear_ptes(mm, old_addr, old_ptep, nr_ptes);
 		pte = move_pte(pte, old_addr, new_addr);
-- 
2.43.0


