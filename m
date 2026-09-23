Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 242CEC9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:33:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF1766B00A2; Wed, 23 Sep 2026 17:32:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC8586B00A4; Wed, 23 Sep 2026 17:32:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D05636B00A5; Wed, 23 Sep 2026 17:32:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A92096B00A2
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:32:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B228A3F76
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:47 +0000 (UTC)
X-FDA: 85246326774.07.B863A5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2C187100008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VQZ7swZ1;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199165;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WK97Gq7edc4CWCQmwomLpJOjV1idQ49x43obeOSf0fY=;
	b=X98y9NMo+0AOQ6O/E2eSnQFcCTUYXUcpYUyTj4pykAS5gQ2Yv2m7LM9qVZ+1fQwNU4Hqsr
	3IgILskv0/wp4uYu5PPoXhHilCdG0J0JUS3uI2MsnuwHFL+hG1t7fbHBP7JhHSfRDlnxoa
	XpEb+8SzGeylFr3FQixDli/RY3myVE0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199165;
	b=SGdv0ffeaETKf4DS180Rm1ugXxWhTlZThabjMV07pFqo5Vs0l93AOIjnb3Ha5iGIXM2P+s
	U0I7isT9SF5ddHq8fLZoWRs4MIzCfyK7vWdRNEA7aKusrYdM4v6vOW7zKOc2v/ITX9x3KL
	h/udNr4jdO9tzkRasS8rQ1UnkaRngz8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VQZ7swZ1;
	spf=pass (imf14.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 64DCD43FB0;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35BC8C4AF12;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790199163;
	bh=lCnOjWIjAtP1yg4fNlobLAfUGV6MCr4aJdathae1sTw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VQZ7swZ1RYYjOjBaVVU9PmAPrKsbC+Lkty1FobDdeVBCiT2TZPcDFR4Frisg5OS8h
	 LpAX8GUOEMcGDrvSPKWWNxffAV2AweVArIWzIZntWvjHthyv1WIgJTt8MLHaSkmxFl
	 a5RmJhY8fynEsneN15D5ei53S8uIbORzE4S8PtVEPtc5Z5BrlnEmt4+tU+HqPxb9sZ
	 x59cwBKRfFlg4a7Id92WFYDmkCmjTQzNvFxitSctYpVPUTqDlGc4byFrxiWipXvKA7
	 O5uZd5tJn055798OweROyIuRtS5V8upj2ypopgk7Af70Sl7HgA3NiB/+fHqgdQmlVL
	 O3oJyfZGWcw1Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C0C4C98311;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 23 Sep 2026 23:32:36 +0200
Subject: [PATCH v6 05/17] mm/huge_memory: rename __split_unmapped_folio()
 to __split_frozen_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-swap-thp-cleanup-v6-5-ba1b4ba72c6f@tencent.com>
References: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
In-Reply-To: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790199160; l=4280;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=0tFQGQYoeM+DEYcm38D1h/sxX+0NJVFyUi8PLZkhh8o=;
 b=HzFKI9Us9gEuTHBixDaUISCMUSTKiCmB0vtgkZgPKMJuArJ62XMZbcI4yupzzVIPE+Z+5MQns
 gTKTgOeI9CCBwI2yaWdoH2NHSWm0Y8Ca3OYTOY4NlbNEFnCJXmqXGZS
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: ujoi6b1jr5t7ffqpipmf3r4sarafxp1d
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2C187100008
X-HE-Tag: 1790199165-985422
X-HE-Meta: U2FsdGVkX1/fAhVnhGLlWyCfcCC2zHoWcoUxdvNZh20nl91rHQlB04Dky35p04sVmZHEQCe/sC0Q+8E9Vs3UytExR/D52I9L/mwrohiaO4Z6JGWT/3E8wSaYyjuyP9CBBCvP7QiH71vu85QT6ld+4qHYwsCAkQmACXaAn8QoIkL/osSopQrYR/TEf+r/Ud/PHAJKC3Re1YX+HIYXfli7ZhGhKHAWsUWZYBmPLRAwK8g1ibVMr7wVTs3XIgzfgWrcc735Oo+5W+mik8Cjmrr4dD/ZsyAPEd0ks4Ris4UU5fJsGY0m/PXnIvdQFWHOZkWVlyR0AAfnV2zWQFz1On0gyBdyu1ZfEIntKOWEMdd5PRpBo7/Df9gpglNb7FBZHg/itXh4p/BeiDSEZud74Bsh6eNypUFFB/+eTvS3RYu/MOI7xqRbrixtG09IKC7Cc6z0l7+8kIR0dGGVX0jL7msnh4Wt3KLfchcglI5aQmKDdaMhBCoDeQrY/D90e3ULbzedutA7LSr92evRyy8IKtiozfLMPsnzag8MqiWSIGfGSAtmt7dPnrCXnanFDpi8htYM9GrSyvXoyobd6ioaFTQHiG9mOwUh49lcwmpWUot7eZl8XIIYC6TXUGxt95vhIS4Tzd6bnfy3zwUAWi+rvU56Vva+wF86kM44+jYl5kfj8wqwr6fujc63DlFIGhknGwiQUN21TgMXHTOaGVPY8PKST0uiuQ6a/UXEXw2eE9aFoStyS5cKChxx7ckS8316B7I2NbXV6zUX6eEcOG0lJnG8MbtQBGPcnoFaHWntRjjaN46CCud/t+mSxODezWFqqpDS5D6+xKcWr50jHnzFVPSbvwXYuYZx7BSdY8OSC/wAmmKzzjQ1iSkp+BjueuHIRddeXocRoHM2inMJWrz5E2SS8yjFtlQMS9pP2RM1qjGn3EdFNyxEbJShzF/KYeeHcgBSj9GsLVxKU8icTI5deRO
 2P7epV8R
 qF4gB03pZ3Jzop2MnZpQP3r60O8DnwVSYIWLnpR63Yl+LybmeugPS2ZGGrxMsgWnf2rvx7TzXI6p3vQ/CM9neBb6pVJ+kx61f96wBffQGj9SP1tU9kWxy3QHZNXRPE1pY/qjIQEuxk8eJxD92RBzPVKuaB8sx/lqjCVWBtGXxXR4r2QpfDPKyvK/55bwfr1gj7LaZzFV3jCd+YsDYI+ivs0yAFTqFHkKwMfegeSYG+36S97Ou9PY2qp9zWi+BW0e+XtFz8dJ2hzz+VjWkHcdW4OkRTnJE7Xd9qIFG8spR3+FqR0ljxB7nzyWo3GdjvFEIG1deuQcunBNM5mjU6l9yOK2rztiJCkd6mpDRqGxu3YuTF1WUkBaz/gD989wieqgTThzxCf8Q+5GRqdb99HZjUEAcWXmH5A5FaIsCb8UOR242QKs+NveBt5ympdajZFkg1m3qIWnqek/0YP27JbYCESD0BGn3y8mWoBGuWW5D89RJsyWHdziwuasHv7pe7YVGRYp0265v/k4Mcp7wTSWAUIeGwsXhiJJyKM5zjuzpbTdMhumUPNdwA+uWPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The helper splits a folio whose refcount is frozen: the frozen refcount
is the state it relies on, while unmapping is arranged by the caller
beforehand. The old name caused confusion and people may try to call the
helper on non-frozen folios.

Also add a VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio)) to self document
that frozen implies unmapped.

Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1efd858892c1..5f54a3559e4e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3810,8 +3810,8 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 }
 
 /**
- * __split_unmapped_folio() - splits an unmapped @folio to lower order folios in
- * two ways: uniform split or non-uniform split.
+ * __split_frozen_folio() - splits a frozen @folio to lower order folios
+ * in two ways: uniform split or non-uniform split.
  * @folio: the to-be-split folio
  * @new_order: the smallest order of the after split folios (since buddy
  *             allocator like split generates folios with orders from @folio's
@@ -3850,7 +3850,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
  * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio might be
  * split but not to @new_order, the caller needs to check)
  */
-static int __split_unmapped_folio(struct folio *folio, int new_order,
+static int __split_frozen_folio(struct folio *folio, int new_order,
 		struct page *split_at, struct xa_state *xas,
 		struct address_space *mapping, enum split_type split_type)
 {
@@ -3860,6 +3860,9 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	struct folio *old_folio = folio;
 	int split_order;
 
+	/* Frozen implies unmapped, callers unmap before splitting. */
+	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
+
 	/*
 	 * split to new_order one order at a time. For uniform split,
 	 * folio is split to new_order directly.
@@ -4037,8 +4040,8 @@ static int __folio_freeze_split_anon(struct folio *folio,
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_unmapped_folio(folio, new_order, split_at, NULL,
-				     NULL, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, NULL,
+				   NULL, split_type);
 
 	/*
 	 * Unfreeze the after-split folios and put them back to the right
@@ -4104,8 +4107,8 @@ static int __folio_freeze_split_file(struct folio *folio,
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
 
-	ret = __split_unmapped_folio(folio, new_order, split_at, xas,
-				     mapping, split_type);
+	ret = __split_frozen_folio(folio, new_order, split_at, xas,
+				   mapping, split_type);
 
 	/*
 	 * Unfreeze after-split folios and put them back to the right
@@ -4169,9 +4172,9 @@ static int __folio_freeze_split_file(struct folio *folio,
  * @list: after-split folios will be put on it if non NULL
  * @split_type: perform uniform split or not (non-uniform split)
  *
- * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
+ * It calls __split_frozen_folio() to perform uniform and non-uniform split.
  * It is in charge of checking whether the split is supported or not and
- * preparing @folio for __split_unmapped_folio().
+ * preparing @folio for __split_frozen_folio().
  *
  * After splitting, the after-split folio containing @lock_at remains locked
  * and others are unlocked:
@@ -4274,7 +4277,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		i_mmap_lock_read(mapping);
 
 		/*
-		 *__split_unmapped_folio() may need to trim off pages beyond
+		 * __split_frozen_folio() may need to trim off pages beyond
 		 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
 		 * seqlock, which cannot be nested inside the page tree lock.
 		 * So note end now: i_size itself may be changed at any moment,

-- 
2.55.0



