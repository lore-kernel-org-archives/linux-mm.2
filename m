Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC483C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 18:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A1576B009E; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 229396B00A1; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02D9D6B00A2; Mon,  7 Sep 2026 14:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B88E76B009F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:12:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4935B1601ED
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:21 +0000 (UTC)
X-FDA: 85187760882.25.F6479D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3B88B40006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d2cp8bhu;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788804739;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0f2fTEV8gHvUofS2U4iN+IpR10gD2NjY5nYEjQLLTW4=;
	b=G02vo4aIenszx9sx3irisWvr+nwBo/T4ufBkfrKdiUoveAW+LQoTLthJ8tpjZLSwcWpT6p
	uh1F9nRZJGrNzJw1f/EE2UqDctPbSDU9ypQ5fF4tO1PBd7z6BOsUgTKnod54+Ax6aeFjyr
	pa3clHYnMiTuF4G/89PQ8eawQ/2XxJ0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d2cp8bhu;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788804739;
	b=GuwKDK5qYkhRjvpgoTBBGJh1vfjxIlDjYUy5RhnldtzwpyF8O+sdtdOZRfdy76zHNdC7FO
	3DW9U3NzWMMyD8luP+dF7wxixP5i+2ThTu2TnXZtN5nfjR9btibe0gpVh+aHOFLvpYy44F
	fgIMyibGm1zdIu+D3CaqZlG3mmV/LBY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 65CED44516;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 45065C2BD01;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788804736;
	bh=CLYd+9rqSeAXmfOGfQPaGz7sWGXnVTIa35extcVMPFE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=d2cp8bhuIi5bmka0XQY7r0XQXITvpri9z+aHB3uMN+xpkGa/XLScdyEWthxrkA/oC
	 q/3U/PE4WIgGO4PHK8z7HAyTCFsbqjMmu3K9AcYsVjxW4Dc8facI7MqtHV50CtJdT7
	 HWcI2gpgy+JJspGq2YOxC0LGmqWRgd7APaT259PN4BcvEia30bTSjFg+RmqT9NcK0J
	 bbeedZ46IgwfvbKxxxTm+rRHUO55cn1WmizxHAGE7bvQ2fpHkHysLyHYAXCqUZ/PIk
	 bVMZCwk5QdKt2p02K02wGASWBRwJu0cv2zwBBt8QK+/mjJ/l27vG+DkxIF3iRzVd/G
	 oxbzvnW20TQvw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E779C79FAA;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 08 Sep 2026 02:12:11 +0800
Subject: [PATCH v4 07/17] mm/huge_memory: move EOF trimming into the file
 split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-swap-thp-cleanup-v4-7-b532a3f20e71@tencent.com>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
In-Reply-To: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788804732; l=4120;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ftkoXBBw3sFhzSDR+ufx8DUBg1yWFWLNTYmDd04kdNg=;
 b=RFswOgque5Oaf/nioeXAMNZpU66pzyHQFsZ9WV62FE/pJp+Fw3tJfkRgqdEIIJNhjSDhRF/JC
 TIybDy7ifI0CcoAujx5xjsR0GVdtPfi0zk4ewWdO81siP4Ei7RJhhf9
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: dztjz143ji7jy3odn3d4qu717dwo38ap
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3B88B40006
X-Rspam-User: 
X-HE-Tag: 1788804739-885716
X-HE-Meta: U2FsdGVkX1/5i5gEHz1qzLnOfrFGilE4tGIcFwCDR4+OLdO3D8AAo00hYLyt8pLO99kHkGALgEt+EkC/WDaxsaDnd+fj0gAzC2XluIK/hkvODVQo/mbHUyMMaeWG87XQlo8IhsbJ2XvhcO4O+by+vPN9y4kzALUCikAsYFwL64vmEC6hAUDzDyokVgbzcfrAKbJaQei2J8PD5eAn2xdnNFxuhW+XknBpCr5Vp0NHpxXfMksKk5MAG+Vs2rnspMZimf9mtrWg+A+dZ9wmL8gtwp4+JzXQjs/LaszPDf67Au4UyRfuyNJruf5Qug3bORwEIX2Zr2CCr58ER91YBYU+q3Jizx09P36pkkkHN+3HrRpnCmZnnroA4MlznXxHN7NGEillLI/gojxSNkUk5UV2gcL0v0Z7GcAZeYRI5ekK0i75mQrNO00JS8OrOpYbZNlnSnZ5PjPedh7LILyuOPTAAiW6aNVGoCLnB5zMEmFLqEO3gjKwxkW1l86i3Ka8fj0AIwvDicSwejyeVX97TbF/arcquBZz3YnohbCv80/LIL954o5i0nRxaWkXJQYZatLlTJmYcVB8jPsVoyBhwEe4WjK1FhKXVM23Wp6EmZGO5OI2EAVF1qDSCaP1sJefrXKRnS/qQhtX7nwK859Mxx7EAYNVE+5i3K/3i4BPr6xvLeVGISaS65NZkosymbQ2zEQKvXhsZBaGrPFi+zNPLhysz1JuKsdr5dp3uh4nGnMjIW0OzJwkngnnoCv8DFblRmYsN7YyH2J7cqPQT2J4sfEwn2xtTBQ0L+e71oWXxvAyQy/2xibqIxJZS90/pmX5LDHMLVm/c2xa6NSEFRVqP9UDMdiu+d7cVNalQHCXQauX9SY7tY6R159/w0MMdZMZEAQjerWGn1SgBOsTob6m5Ifzb9tdd2DOUlYpjaAl195c0AQJ2HCcQNqO+b/ftCUmNigixIFgsF7HRkKe6tz/CHd
 dKYxIcI4
 Wt6ip4VglLV8d8BcNY0hblMSvbKz2oMtQUmK5I4x+h8GqprbGltl3BY9NrBWpWd4TyzcFP8b28Wwxh2DdbIo5SjXCk38ABKt8u6fzdwANaNM8nAb5pc9yQ/8R/h5oz9oNYpxzPdE4G/ZErLLAqZo832y2ewzah7z01kTDiiFJQAJsbXMPy3mvbOtdYqznLuQSd1VeUWEh5HlI3GJ6taGaUvIVhG/Sr6yIxsciOnSbaZUykJCi68/nbMXn9/dwp/c9v0O1/Vk2/GGdo+Uly5you2vOfp0DWfz0Dv20t9UUfr+judmYiMFvdRX5kP2M1eTelJr2k+vfd1F0HF+26mkZQklBLqDCMs3uGnFbbFZPqVSxLpW3GxR8Fv7c2j46LMTeEju0VEZ/K/cw0FHagXWNKiYXZFoAz1PBzXFR2Sv3aiQwto6sovh/LJmXVlkYKYgEUL1GzWETwx7qH4Xll6JcD1/tatiiOTbo6wnwg2kv/eFE3bZ7vKgcvd2mO68ZtPmkVTZUKN+2DlOV8F34s8R1N1kztnMKveK7Hq9wInSkGVeXQhMYfRSBU5lVvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of receiving @end and @nr_shmem_dropped from the caller, the
file split helper now computes the EOF boundary and trims pages beyond
it itself, as this is only needed for file split.  This drops the
redundant parameter passing and sanity check.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4ddef481cfdc..47ccf2326cfe 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4064,16 +4064,29 @@ static int __folio_freeze_split_file(struct folio *folio,
 		unsigned int new_order, struct page *split_at,
 		struct xa_state *xas, struct address_space *mapping,
 		bool do_lru, struct list_head *list,
-		enum split_type split_type, pgoff_t end, int *nr_shmem_dropped)
+		enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
+	int nr_shmem_dropped = 0;
 	struct lruvec *lruvec;
+	pgoff_t end;
 	int ret;
 
 	/* Currently device private folios can only back anonymous memory. */
 	VM_WARN_ON_ONCE_FOLIO(folio_is_device_private(folio), folio);
 
+	/*
+	 * The loop below may need to trim off pages beyond
+	 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
+	 * seqlock, which cannot be nested inside the page tree lock.
+	 * So note end now: i_size itself may be changed at any moment,
+	 * but folio lock is good enough to serialize the trimming.
+	 */
+	end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
+	if (shmem_mapping(mapping))
+		end = shmem_fallocend(mapping->host, end);
+
 	xas_lock_irq(xas);
 
 	/*
@@ -4138,10 +4151,9 @@ static int __folio_freeze_split_file(struct folio *folio,
 			continue;
 		}
 
-		VM_WARN_ON_ONCE(!nr_shmem_dropped);
 		/* Drop folio beyond EOF: ->index >= end */
-		if (shmem_mapping(mapping) && nr_shmem_dropped)
-			*nr_shmem_dropped += nr_pages;
+		if (shmem_mapping(mapping))
+			nr_shmem_dropped += nr_pages;
 		else if (folio_test_clear_dirty(new_folio))
 			folio_account_cleaned(new_folio,
 					      inode_to_wb(mapping->host));
@@ -4162,6 +4174,8 @@ static int __folio_freeze_split_file(struct folio *folio,
 
 fail:
 	xas_unlock_irq(xas);
+	if (nr_shmem_dropped)
+		shmem_uncharge(mapping->host, nr_shmem_dropped);
 	return ret;
 }
 
@@ -4198,9 +4212,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	struct anon_vma *anon_vma = NULL;
 	int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
-	int nr_shmem_dropped = 0;
 	enum ttu_flags ttu_flags = 0;
-	pgoff_t end = 0;
 	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4277,17 +4289,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 		anon_vma = NULL;
 		i_mmap_lock_read(mapping);
-
-		/*
-		 * __split_frozen_folio() may need to trim off pages beyond
-		 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
-		 * seqlock, which cannot be nested inside the page tree lock.
-		 * So note end now: i_size itself may be changed at any moment,
-		 * but folio lock is good enough to serialize the trimming.
-		 */
-		end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
-		if (shmem_mapping(mapping))
-			end = shmem_fallocend(mapping->host, end);
 	}
 
 	/*
@@ -4306,11 +4307,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 						true, list, split_type);
 	else
 		ret = __folio_freeze_split_file(folio, new_order, split_at, &xas, mapping,
-						true, list, split_type, end,
-						&nr_shmem_dropped);
-
-	if (nr_shmem_dropped)
-		shmem_uncharge(mapping->host, nr_shmem_dropped);
+						true, list, split_type);
 
 	if (!ret && is_anon && !folio_is_device_private(folio))
 		ttu_flags = TTU_USE_SHARED_ZEROPAGE;

-- 
2.55.0



