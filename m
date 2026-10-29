Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B41F9606A332
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XzOcSZ0/
Received: by kanga.kvack.org (Postfix)
	id DD9BE6B05BC; Thu, 29 Oct 2026 16:35:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB1836B05BD; Thu, 29 Oct 2026 16:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC75D6B05BE; Thu, 29 Oct 2026 16:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A9A566B05BC
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:35:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4CDA0A055E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:35:16 +0000 (UTC)
X-FDA: 85376818632.21.613179A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8B2BE40002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:35:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XzOcSZ0/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFAjWqVlFrIH7aRNsfEXW0cTwDAw9D8sfuZWY6alCX0=;
	b=P2j8FeeOMcXSiXou//eBEolsie1Aq1KN4tXPLevsnQvn8CNugsPRWUMbUhFNnWZwDXDShc
	rVYfDj9ZLAaDqw3uJBy9Ze/Us7yxi8yfLjRsXlclCThCJS3yShgYnnojbHz5ZRSVghY7gK
	HeuXfNQ9rKmCFzmG5pZdOVQlsvzORI4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XzOcSZ0/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306114;
	b=6aUE78jxU51tLjfSvDi+dagXx3GzicodYXOokXVn2nNi8CG07dJhyImqF0UJtG33Xod78L
	KYHZVu7wcCUYd4Rs/90JbTxfhUPswicmurl2LegxyCVDIb+BcV3XaR3fVimX7nvDYi/fiT
	5n8z6uIpSraBjgdThj1isKJVvv/FiHI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B0B3605CA;
	Thu, 29 Oct 2026 20:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A761F01828;
	Thu, 29 Oct 2026 20:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306113;
	bh=kFAjWqVlFrIH7aRNsfEXW0cTwDAw9D8sfuZWY6alCX0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XzOcSZ0/8EjfLSpO8K/HcuZSOJbmmXQkIY53mzRn59GBRxsAtfiTFEDVrcM1yLKl3
	 oBTrNqK7TdiI9gM7WJtE7zLxyjhZPpzV0WsUkCfYL/Zq7ZgrFgNEGdSxyxupO/nLIR
	 Fs81prGpuyNkh4h18yqjW9N0cMlbxwMV3ALHT/84WBDoVJ05WlcrWo0o5AIcoX8Ql7
	 0AhvnXbjkE3P/WuPhUNmmNp4c7S4pWbHzyrQPQDz0y4hQDrEGq2WCt9sVPsDVsy6e6
	 zuX6cUOkjI5zZKKMpRFrRsGcZ9emk6B2GcItEG2PBmoGgzccnuLwaPMBL3pmdnj64+
	 bnSOphJYGh87A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:02 +0100
Subject: [PATCH v2 07/47] mm/filemap: don't lose a folio lock wakeup to a
 signal
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-7-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2263; i=david@kernel.org;
 h=from:subject:message-id; bh=7u0AsrX18I9QfeKreay7tXsWSgpaxn4U+CWR4qcEsEM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer2291MuXbnXaLNMw/uX1tOZXcYnK+9aeVL/nlaF4h
 qdaO96jo5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIkcF2P4X16RdGbNIbGQ9tV/
 VrRe9lk932Zp6z6/K2/elLFvtlF9HcjIcMTwqNbp+EmRTVN1f3YYHTcs7L35TMld5fmhDd/PyCm
 e4gcA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 8B2BE40002
X-Stat-Signature: wpawij6psrph4h3db4iuh1xhziyb9ipw
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793306114-966883
X-HE-Meta: U2FsdGVkX18eM064Ql5KWShcQH7sj9kAhzb2NeH727Ratkb7xxX+paUVRbM40GYGPYQR+3SEqQq6ZlMgaeZx37nDrY8iipcnEXrCN29wL9pnkKMHI4LuMQ13YH5+VRgBIHcQs7dh1hsruOgmf++OL4sHEkun+b9yvJekb/8ZGXrv11mIkv1wvHFrJZBjPuvXOuv7SRNm8XgK4LAzsB2PGNmKaTjCH0jnlbmRYPsDwbBpYgsOC9evJrpXDKHgRTFvOITj2VZ6SL9WMuKeFe6Zl3EIYZTGinK2K8+dFX9K1yVusGViOZqaCgu3+7CDwPAB4x9wHzY0KR/bx+PgmV9EY2l510RtSD5Ybs1YkFTFGgcVGd/tY+1q4DVtpJwH8RaEdXQkNfpEqjbXAtmLfi1JPAl3guuMVu68iV4BKhA3LpMGas4zbkSCRGpQ2+0NL8xCli832QsqjDUdKVkeRvD1TP0XpfAue5baLjfq4/wH56phKOFNhrV34BqihRfJ2UowTXQa24maXsr3qIDpmUVtS7hHCWnss5z3LVoGM/gu6hDDY2LmGZVkNocnsfOAb8bUwHnTOcRT36osXW00l3vODIlmhE4/Njp9uB3OPnhGYgZNHcxSb2S393NckTbrGB8igphtj8IEnUMb8/d8tVdpdPZPzV4tmL2Hzb4PFJO587oVyT0+x4SZldc9IJjdugHWnViJdlpd9yjYN7c45BEcsFfKcvl7J/ZjiHzuiqUplpx9srPv+CEbQYrdzuBBJ1NMCqvDOpUX+OHWt5A+QmcCOxMT6CjTvUgVgKhfLUVImyoa+VEwH1BvGTeekTQZVIl8hiEsp0/t3IEKfv6JZMx2KIMXxopFX5hTt0DGILWskWp0YRHO8W4Lmtv1pwCfWFPpWbwUwFNEV5AJQ1VcRhCjKyLE/FeNyP1UwOWKSGLLyormcE7HxY0Zqt08DRE3izXwU8ZB4x8Ltnt3gU/jwwt
 gkWPM1VU
 L3cnOhzUAuaj0BRe0YVnzkW/4/Rdroc73TJwIx7ONxqhHUWR4okRzTu61Wpu2rIR9jT6EGOtmhPusa3O7dAUq9teBJS5/Kimr1CU9doP98AIRLao6kuAbzK+XlofnCt5YZFwJsc/hVwS0dde/8OE/6klWuplSnHMFayRtArmaUMRzmHPnnSe3PZJ+fWN2X+W9TsQ3dwcktSAHOSlv+hKXFzPpecETTI+ljkUMT0vc3YZvOLB5atoJ7QSizqVLeuDsYHG/1L62U2DBl/CrylkxsQMhb0BafLmh7HV+hGZJHCXJXpO3iEb4IEzUXFb1a71NO82IQ79gBESVn4Gs26LW54DlUzbvcpI5U/qlHdj82iKitGilLEJeSKqWaXkyHXGh1K5NOutkYMURhTrS5XqDEsGwBYhvSCPZEFXtWIw1EAMBvo8a1aZayU/pLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

An exclusive waiter in folio_wait_bit_common() can leave the wait loop
because of a fatal signal, then be woken by folio_unlock() before
finish_wait(). If the waker did not hand over the lock, the waiter returns
-EINTR without trying to acquire it.

folio_wake_bit() stops after waking the first exclusive waiter, so this
loses the wakeup and can leave other waiters asleep indefinitely on an
unlocked folio.

After finish_wait(), let a waiter woken without a lock handoff try once
more to acquire the lock. If successful, return success so the caller's
eventual unlock wakes the next waiter. Otherwise, the current lock owner
will do so.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 5ef64cc8987a ("mm: allow a controlled amount of unfairness in the page lock")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ david: clarify and simplify comment + description ]
Reviewed-by: Rik van Riel <riel@surriel.com>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/filemap.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 906b013c11eb..6b5e1d866a9e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1373,10 +1373,22 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 	 * return value based on that state without races.
 	 *
 	 * Also note that WQ_FLAG_WOKEN is sufficient for a non-exclusive
-	 * waiter, but an exclusive one requires WQ_FLAG_DONE.
+	 * waiter, but an exclusive one must also acquire the bit.
 	 */
-	if (behavior == EXCLUSIVE)
-		return wait->flags & WQ_FLAG_DONE ? 0 : -EINTR;
+	if (behavior == EXCLUSIVE) {
+		if (wait->flags & WQ_FLAG_DONE)
+			return 0;
+		/*
+		 * We might have just been woken up and the waker will not
+		 * wake up anybody else. If we ignore that now, the remaining
+		 * waiters may not get woken up: take the bit now if it is
+		 * still free.
+		 */
+		if ((wait->flags & WQ_FLAG_WOKEN) &&
+		    !test_and_set_bit(bit_nr, folio_flags(folio, 0)))
+			return 0;
+		return -EINTR;
+	}
 
 	return wait->flags & WQ_FLAG_WOKEN ? 0 : -EINTR;
 }

-- 
2.43.0


