Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EF0FC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 080DE6B008C; Mon, 14 Sep 2026 13:15:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F03E86B0099; Mon, 14 Sep 2026 13:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D774A6B0096; Mon, 14 Sep 2026 13:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A9C676B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:15:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1F1E120208
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:56 +0000 (UTC)
X-FDA: 85213020312.18.9D5630E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C7694140009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tcpLb9kJ;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789406154;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n90hcQDNUTzDy5wNrd1Fd4JkWGCgiKtVAR4hPAIdIMI=;
	b=bsUcO5E8jftvQAn2R1dXWaQDhuFVPfus61tuAXSDRqpscd0Ru0zh8tsvTQLPIYLs0CVu3V
	LpDZ9ZbHtotKb9NdpJ3iO84abHF80d6rzYoR5MlahQJqU5/kXmgEkjuPvnOd1pU474SvKW
	UOEDrahr4yTlxBAGx93C0AZOhY0Akkw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tcpLb9kJ;
	spf=pass (imf09.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789406155;
	b=fHnvdsnAR9qkbuJMWg8ZopB8TgK13kdqyUxng1+Nooq2MJqtihbgojMwIzEyqIJqBWVFzV
	IH1rw5ipZ4tq6SByaqPZW1DQDKPbAOyH7J3+BxUOu6NCMKvPYlrVwfoFxodLTk7sIxB44w
	fDARDgKqw9/NTMksFVF7yUYv1Dd9fnE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA06343D02;
	Mon, 14 Sep 2026 17:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D584C2BCFA;
	Mon, 14 Sep 2026 17:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789406153;
	bh=q6d8QZgJ9uVNO04KnNDgtygNJ+rHQadMULxGSKbRmEg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tcpLb9kJ28FmtFy5JvuCEPC70mkaGA2lAAjhkmF/9Tlt3B1ayNzdO4vEGsKbw4YYn
	 W5A4zIzLNVFskozAy/YG7oXBY4F6J/ZCzXrSIstlEQG4oDjNX+fK7EvV9VyjT5DbI+
	 gQjnQ8DOFl/QsSkmInplsH3yi/e6P2og2I+kPCEPaqF99iUj/IgPAR8B5Xr7ctZy5A
	 dx3BwwY6a7IUarqJ6uEg1hmMiulpY7AQL/6I36S9/GkIhet8VTjKABGVA4v8z3Qt/q
	 GzctZozrOQoE+NWg/nelfTLd6vf1IDT4wnV/l1Cf/kc5lZJftN/UzWf/lLuQ6UO8gk
	 swSb3dMadgS5Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B20FC88E72;
	Mon, 14 Sep 2026 17:15:53 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 15 Sep 2026 01:14:42 +0800
Subject: [PATCH v5 01/17] mm/swap: fix off-by-one in swap cache replace
 sanity check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-swap-thp-cleanup-v5-1-39878b37dfb0@tencent.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
In-Reply-To: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789406149; l=1650;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=810n4do4aOKMWihCxqnhsHXg2hcES1SAm+rRly1NOZc=;
 b=TD7AokuIIIO3qHuTryNrrJFaeotme90f+Sx8e3cBvBRNKxx+8aj6JZLK5qKRH21lcwrMz1ac5
 Z6Yn5pDcF3EAmvXXtvcBrZhV529Cqpzegiilz1N9cpCkU/1k+pvbA9g
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C7694140009
X-Stat-Signature: oxxeug86g5dditehmiwm7qro69fhusuk
X-Rspam-User: 
X-HE-Tag: 1789406154-984078
X-HE-Meta: U2FsdGVkX1/6JgLaDOgcxioKZPRKVMuQJfWoY6151QOhxZmZE8QNSSrvzJAdX1ZCnTTuGsrtxkf9tehMJx142pzRZ2L+OY1rIpoNcP2fvJrnagXVPJwrVZXG4RvLklMC9Br2YKWNzlHELMCfy7FY4ObH/3zDdGBCkPqQemGmkV4a6UUMLoLJ7LH3qgH7TvGk+mwunosqEC/zRzspUN5ek3ZkyoTRYX3zOA5dvpJlQg50z3UNwLFe1d+pIp3de5iuYKFv+T4+OEaWs/0r5QuoR8zrjEDs8kZv5SepvNmf4CtY5KqnBzgjHoldVpHHWmmx+EpuRCUSg/DeTbWedN0N6/RCbYhOzYLuM/ffG+1X1h6mUFJcIoaqReoc4noqv/sbBNfObAQv9fvFZJZKkK4ldKyCUco99476adf9lpsrKcrOwGsgn+mET8Li42AEtlYUUL4k4mEJhZtCypqewXtfExqRHBeNkQaLap55CYh4EIlOfYu3dBTDuwRiXH9ZCVZpIKwDQ36rcbS1/2UeOom69EiAyS+rsj8N6ZdWd/KB6sIQieUyz08zCHG2EdwWbeN1beJtDd5soajwDtxvJhtF9yH9U+me7sHKLS1vSMC2h+csz3gTpDWKi3RtPvQo2PiA/B1mT5/Eg7NoWELRxwUyvu5Qu9zDoQKW0+jJbuLKJRPsiGeoOlNU4hmJ9kDx/pmyH+vylsKRqVWqzp/bu7mzikMJb9IkAj4ao5e6av0SG5f+ACW5QkTJdvMvEjYdFw7V0JF1ZwQvjxjbe0+wFQFXgnTbr06r5c1ZrdWirQx3YSinuJF5772EZ3IBtBZk4tcZNCpN5npGl87SLhpBGvI8UNc3WO3ZNq8KKDEYFRfMiBq26Bq31Z0WouKFJGU970iKdKGPQ6iQ69l4Fr5+n+NhNR0XVP/OSDWLE2pdE8VsBVagdroZndI6QvLtiBHduJeI+2iWjDYMjmB9UES+aGH
 fkeznFPV
 khHwtUZiFgYnHfcDr1ZfmJ3sOD2aupLKZrPvdHmGkNX//MyAqGSjnfahzBo6OYwEcCvBuidl5vOmpYHDiC2IrlrzP4hiMIwF/eXtxp6S9WbO7eASVIy2okULLbufPcux5L4+iKEZhYpKBE5LaI2O98zeVPnlFD9FXKvje4bMm3/0vsqNWIWnI5B7LtIPwQcDuTBnngXSQvG7koIFD0kOpeXMgMxYPHCW6KnY00I6F6wnUI4kQ4YLAyk4+PYXaF2Dh1YQiXKPZmBgdjYVMFOwqluIIcjq6eI8jiVRPegFfp9Fw3HBA/T3REqJfqlyMcVRdtzx68X+jKbeffrJhmH9yYIL+GY9DkHMMgVcV5eofdCIFqje5D0rTHOiLLI0C3GQKhs6n6gZHIVHdqT9xBYcAPjU2P3rZvu0NNJWAT6na2KZUonVauCwlIoVEx9twlA33t073BjQYlxFDFcuuU4e/Sej3l630i5Y0D/ALFED9fBWNgXLzHC/5TrVk/KO5D9JBKVEl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The DEBUG_VM sanity check in __swap_cache_replace_folio() iterates
the old folio's range with "while (ci_off++ < ci_end)", so the loop
body runs on the already-incremented offset: the first entry is
skipped and one entry past the range is read.  For a folio split
that entry belongs to the first after-split folio and was just
repointed by the replacement loop above, so the check would warn
spuriously whenever sub-folio orders differ from the head folio's.

Currently we don't support non-uniform swapcache split, but this still
needs a fix to clean it up and prepare for non-uniform swap cache split.

Use the same do-while pattern as the replacement loop.

Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and switch API")
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_state.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 625c185a1ca4..cef44aadee61 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -396,8 +396,9 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 	    folio_order(old) != folio_order(new)) {
 		ci_off = swp_cluster_offset(old->swap);
 		ci_end = ci_off + folio_nr_pages(old);
-		while (ci_off++ < ci_end)
+		do {
 			WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci, ci_off)) != old);
+		} while (++ci_off < ci_end);
 	}
 }
 

-- 
2.55.0



