Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7F2CC5ACD1
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB8756B00AA; Fri,  7 Aug 2026 17:17:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A43D36B00AE; Fri,  7 Aug 2026 17:17:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86EA86B00AA; Fri,  7 Aug 2026 17:17:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 54EF56B00AA
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:17:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E8FED401E3
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:55 +0000 (UTC)
X-FDA: 85075735710.07.5CC8733
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id EBC6B8000C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tNh5Xzoa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786137474;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxV5YhpRxwWgRqhKlS9ywqSoN7+MiRskmhE7pzOTHC8=;
	b=69GWwRTrf3QNCrcaBuTFOltb4/ksnltravWKGy2q2BdIxiapDTmY66PzkaNggQYRkTy6W5
	7WAXeZQ7B2seA1QPBdS1n6Y1lLFkeatWbLqSD1iueRI1oD12faP3Ii2PSJXgCwFSY/kVDn
	ITTRhtxwcfwN/RatJmFAyzsavcustO0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tNh5Xzoa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786137474;
	b=3m+NhCc5hXdYTmiq5XuuIxlzZeQ7actEwBYpcb238Lz/WUt9YyQCLU6xq2HXbcJ68IJMV3
	eCfyaFToyy2jMJuUK44wihQp1120qijCsnQ90ePn8wN8oGwLeT0v8PNU/w1HGYmbiiS+w/
	ZhQNYpbgOjShuXbA8NqJfqI5gmNcy+Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 905C844ED0;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 70AD8C2BD01;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786137470;
	bh=99s4a0IEhVPV4G78O2RX0b+40o7pPLKSxH5+kDAOrxQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tNh5XzoawqV6AZ+Fpaw+p9eFndVOCNn0dmfjss0RKx0RN/lHi6gIVflk4gxRjpM0S
	 NiPNtTAFmmLmwAHdyD1U1fNVG0qeTmVFHIYI//px1H9hBW3F5r/K1nbovsTvV2QD3s
	 qcQdJ/79+Mo/SY2Wk36S5Z/ldOoqZgcQ7mgS169W9WI9jPO67gFmhkwMGLZwK9rxer
	 pkOa3JlXF/yOr1Wsfv+C1bCgL10U9dA786S/URpyIrb66sQWex43RxrqfIBcvnVBin
	 uS9l/hqnT/uCWrbU7wpHuUtXcYqRCt1k8J61Whh7II0MQUanlnEBzqt/jdLp8chtqd
	 VDrPx22kHVp2g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA9FC5ACD3;
	Fri,  7 Aug 2026 21:17:50 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 08 Aug 2026 05:17:12 +0800
Subject: [PATCH RFC 11/13] mm/huge_memory: clean up after-split folio
 freeing in __folio_split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260808-swap-thp-cleanup-v1-11-689939a7ccc3@tencent.com>
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
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
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786137467; l=1476;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=eR9RHfz1xKpkHU93Mx9UnV8mmj6dwPjTBi2fADo8ZCE=;
 b=MRnjAlkZDWKZcwh9ZZOzHGfILV2xObDl270yF4y4lR624UzRVeTzjlIe0yhnhMF8Tdg/4sun/
 4PbZdRJJClJBW6FZBZO7PeCkCAslk3cUW4f6CZXwkeolC1ahBi+9oZi
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EBC6B8000C
X-Stat-Signature: irrmzwdgnns3hysue5qub3m4wxga6of6
X-Rspam-User: 
X-HE-Tag: 1786137473-290919
X-HE-Meta: U2FsdGVkX1/H3nQPBngEo9if4uIiJ9AkOzQ/HFIugPHu7Ke03j/fDAtSvdi9AyRGTUEAvpss6k3NUx4r5JzQzH53toK95GuvNh23AU2BvppPjRdsJ2xW4go/sqpWsAQ8Y78WScKbBRlBbtTnlWgYoBGfQFVF0IsD8RsuzU9uEwdF9BoMejqYLVb/q/rkv8brkJp9qF2FpHZm1p97GDdia/bMQ/g13dzIxp+8yK9H4e3XvG1bjO8gZtK0UmdJt94kWnCi6XwvQA/vIt8Zud3ZonypaWnfW/r7QH7nR4c3tLfOkYeimtN3b7BNVkD1xnQRmRVE4s1q5fc9LbkZuRhgHkaTm1gIGJACFQP/LDmK1ddJRlfclelod9reafIPbC7jq+nbhUO58Sk2IdQFz8pZMt9FR9G4ne0bn4hZCOz4i01lFpDZl7gmfIxqwXAGahxzpWU5lebatdyxaTi54oMOTVCZPG0bNwxtmutjPpDHdP9tWrFO3D9u6D93Gwuk3kdkTfWB0YwNTbTtR6bAmlmJdgGhe8+aH0gQzdLTduh6BcxBpWoxAO8SL/DnZt7qMZ3Advzd7/q/l6RS81ShLA6ts4wweT/2OR0uRq3h2Exc3mBd99ZbQJmog0OQ/yWbUydqw8LKKzW0Hlys8ra1sL/FwQaCPgZW0h2eZTdycHivBhNS5+3CgrLF+6eYoRUwKTCXPIADVcegZzUvpEExwTIOxWNJGx+fZcHe+IjrrQbWQH6qCDhPlE+Vq5P/pABTmxjdrmXeKV6DzQ+oNEG6WF/q4o6m3kTuGyUjst1itfeT3swGFwuRUJSgsDHPZUwGbQtgql3ZVDpmZrUm7MZluio24P8QqEa8lchUY/XZ6JTtNrtVgvI5acjK0v51k39u4UTldF24fDj8TzT+/Y2fd66oKbM3Jt0cz2fgBKKPA10mEpT8xk2oCn4cy6gBynMBnc3oHAjlYDgnBTRcDNue19P
 AzsYbLfl
 tjhph5TneBEHirjP7GfokitnsXDoy12uv8NS99jNOFU9hwYrggKJATqIL/aXRI/3q1b+taWiSw/b6Xjr8LjqlRf/WhY5PpIvbPk3SXP5KHkgFwyPXqvmRK5tBEMFqgmIhIrhBzp3+XZTTJaxOLwH7tkHV9Mhj60vWiT7m6P+wC31HLHuTcRq0seu/7dRlMXtgta0xIzRuBK4DU+akAFi0IEqAShOtqrjFfohh0w/trLEpo26+Rw7qqqWYm2qhRBDyfl3KwxA7YFs4iNnBsrgFwTqhYpnYi38GLj2nX5Hic9Yl3cz5LN2CEmagzYbpliGLnri/yA6qpZx8CLvAqEQk9zQSYlJTUebDS6CPn5xZotZfkosoi38pk+O+0eM9xvhUXNUoDw5I6SpWjKvXJJtxEqcrINT3L3rAenEZ07aoh+9HT92P9Gg7UnjJtcxh7vGeoFC/8/HFMCVaGik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Replace free_folio_and_swap_cache() with an explicit folio_free_swap()
and folio_put() in the after-split loop.  free_folio_and_swap_cache()
unlocks the folio, then free_swap_cache() must trylock it again and
re-check folio_mapped() before freeing the swap cache entries; if the
trylock loses a race, the entries are left behind even though the folio
reference is dropped.  The sub folios are still locked and unmapped
here, so just directly call folio_free_swap() directly under the lock,
unlock and drop the reference.  This makes the swap cache freeing
deterministic and the reference drop explicit.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b80d0db63225..39c91c8e5bc8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4304,14 +4304,16 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		if (new_folio == page_folio(lock_at))
 			continue;
 
-		folio_unlock(new_folio);
 		/*
 		 * Subpages whose mapping has been zapped may be freed
 		 * earlier, but freeing them requires taking the
 		 * lru_lock, so we defer put_page() on tail pages until
 		 * after the split completes.
 		 */
-		free_folio_and_swap_cache(new_folio);
+		if (is_swapcache)
+			folio_free_swap(new_folio);
+		folio_unlock(new_folio);
+		folio_put(new_folio);
 	}
 
 out:

-- 
2.55.0



