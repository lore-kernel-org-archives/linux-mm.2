Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0955AFD0045
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:38:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722BF6B0092; Sat, 28 Feb 2026 20:38:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9F36B0093; Sat, 28 Feb 2026 20:38:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62D676B0095; Sat, 28 Feb 2026 20:38:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5092C6B0092
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:38:43 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2979BC1658
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:38:43 +0000 (UTC)
X-FDA: 84495784926.21.832FE42
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 92CA9180008
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:38:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ckjl8/0E";
	spf=pass (imf16.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772329121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XMyRrNAajDIPc43OZGdCYX05DbABOJEq2xivs3IlwAo=;
	b=12O52AsrB4R9my7o6nlfva4Au+foDv66PDiz3Xd7hjzYSxDD8MOFRHk2D1tcZ4H0OoMlaU
	9fVjCvP6a7DyxSZ3huHAzs9CXtSPwH42qaoKmlKv85p8vyt916ldhSKGUA5RXmy2nV/9Je
	o8/EshqhgkztHFy8gYZnFnYF+7mRBD4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772329121; a=rsa-sha256;
	cv=none;
	b=PJKcDMjb3w98Rm2jkThMNeOcSai47OrUfkhQkb5wYPS2JzZtmcdcIdMQGUnBWIe+Q4kBn1
	YMdPXFHQT4pvC8BJ8dG6CE8F7lmZIyTd6ZdpeGeZhbMWtDmk+VHM561BLA5f8dCSnD6O1+
	gfBsOgc3MeDHU9WlYni8sf2oYJGWSaA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ckjl8/0E";
	spf=pass (imf16.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D0FB60131;
	Sun,  1 Mar 2026 01:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4190FC19421;
	Sun,  1 Mar 2026 01:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329120;
	bh=+7YmQSKJ/fHf3Smb0srHzTVLHJ/J+0CDrQdmpzRSmR0=;
	h=From:To:Cc:Subject:Date:From;
	b=ckjl8/0EW3RxdcrYXG4f+tsQO8SZ+VDLklByi5H8WeTdRKP5f960LQCD33tzoAjMw
	 iK9YWcgZFE7iYIzlgC6ThqSMXW9sOIz2WsUiy+PkHEgZoIP6TV8eK6ctKlw6c1qAt3
	 OpTVxiyOkadISMku731lZBI0MyYFMi4WcgDJ/mPYlVxO0BvQp7hmbjOI9XRfohTHIP
	 0ypLsWOt3Aazea96kSmSyAYtEGGtNKiXMcs34xwlVn4AzVXsqGldhbZFWJE2XaMo8S
	 l24a7TAVmWGoI8nKMAZTk2xVB3s9hEedvSLU8VkgYFZI7yCa8gwjT3jSCB0iECRNPC
	 UOJsb5HCSk7UA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	mikhail.v.gavrilov@gmail.com
Cc: Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Chris Li <chrisl@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kairui Song <ryncsn@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Subject: FAILED: Patch "mm/page_alloc: clear page->private in free_pages_prepare()" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:38:37 -0500
Message-ID: <20260301013838.1699247-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 92CA9180008
X-Stat-Signature: nczemtcifoq7ogsuxfua69c97ernqywh
X-Rspam-User: 
X-HE-Tag: 1772329121-441971
X-HE-Meta: U2FsdGVkX19n1h4e0l3i232CBOr2DfqorUiaT0QlH9/4Kk7D/hg/jyeHfExE45kmr+xC25JUejVo8cc6n1HokH7tWOmGYuYiR/4LxRXAXmWmJ6KEtgGo7Hsfm/Jn0WeKEqGhEXkz21P4evFBqhXqogcJAMxBv2Aq2ttGD7M/j1VAZQx2ReEY1573cxrwLf69XMtFuY34iVevPn2VRORljmwFmavOo9T4mVnIUI5DVD5TNi0uiydtctidsloN7xQzi3FBy41HW16hf6dFdRZZVwu6rINq4xz18uZIgN57iD58HQd9ou0FswVVlloaSIzx1h5hGmpEZT3LwECH7fNj9Hb4KHdTMJyqC74GOKTimNgv7MbsslU0yeEP8t8F0crafiA+PavX+5Xy5nEYu+0A7VJOfs1VsM2idv7Wwwq9pakGwM25YliOTmi5iNmVdCJUJKmp6wrk49httA2NgRygnFRrqkIVC5Bj2Zm35He65oDSH6rI3uOBQew2OSWfbiqUmLunpuaGs6Ku9R9xckTry/lTOaX85KKz7QDUVrloczYvLYSO1IS400JYxoDKpv1H/sQY/Ps0s9Npl2krjGLrOfDhNn4HM900se6UseRcp3jQBbk4gmFw0InzS1zDoUEcPPhvIjRCU+i+Pl8ooHQZlnZXzGEkqcD0uKfx0ZrpuaTtmjcI2Z+E5OADUJhLp0AzugkOjVZ1XJOUUggcofyrp+B7KgZ20jtP5Jhb8lAqzC12lGCiYjZGtNjtqoScO0uQDySGjil6IV1Ngie3qXmL+9xRYQeKapoxlowGmI5/xSXc02m66S+AGRwXVPhzHOaTl78M/+ai8P8b65AtYxio8o3FFY/5DdDceFnvdhBb4+Pf2/CLrkWdjfCXmec7JA3DI75QduyaudV4ugsZvBDNbSVQzNv22HC1QL6D8o1Bnc8HgQvKtjjGZ9M0j7iF/QChzKxr7oIdTvBbS4BIzIY
 W0mOKfd4
 j7M/SlQk/xcGPNblS2IJd4t947hMjDDRGKt19gEk2hvZTXtw2wNlB/+sudzC7V6OnghIgEBCJaDpBc/chWY/H70z55u+rYqmAj8oEiw4KCetnjrcK04PbW85czQ/b2AxC9xc6Fpkdd+JQmQdORfdku3lC4BGZ9jYRIgBxNrGT5ZtrRGzEJuuYdrFTz8Z5UV2ALVpapdoNycfsuCZ02HR8lif0oGbflX2riakTLAIKiLfolivIRBrsG7C0Undv+3xQ/F491fVtKdipl79GIxIEYPkqv3lxaXJgGylIQMMp1gpd+GMEWvAIkjpDv1tcCV4JXI52VzIFB+vKkOsshgKz51TQAF7etwfW6u33DqNh8LB8ep6RhDMdge6s/Uhhbu8IONVdt9QxQSpXV58t+u8vXIXE4SVkcLbXJtyLwJIdWKlPXb2BYyXcY0fdmax2ZzBOgIm8sy6HlJ3oXuj8tExZVOD6blJ43m6YHPkgX1s8gF8O3eZsNrsMrHdL3gO5jl4dSQ9EwRnZx1nzN+zRZSlshnJh1vSXf94OJwa9+xoSUuw8IR+GfTrHpkAnYGWlT8voS0zTpMizp8B12WZpB+ySxzQjk/iyOjnQvmXgllPoqZTdpMf8fBnvJmQOW8rWwpdZIMfBVXwSjddDvMoRZY/OP9Qosg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From ac1ea219590c09572ed5992dc233bbf7bb70fef9 Mon Sep 17 00:00:00 2001
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Sat, 7 Feb 2026 22:36:14 +0500
Subject: [PATCH] mm/page_alloc: clear page->private in free_pages_prepare()

Several subsystems (slub, shmem, ttm, etc.) use page->private but don't
clear it before freeing pages.  When these pages are later allocated as
high-order pages and split via split_page(), tail pages retain stale
page->private values.

This causes a use-after-free in the swap subsystem.  The swap code uses
page->private to track swap count continuations, assuming freshly
allocated pages have page->private == 0.  When stale values are present,
swap_count_continued() incorrectly assumes the continuation list is valid
and iterates over uninitialized page->lru containing LIST_POISON values,
causing a crash:

  KASAN: maybe wild-memory-access in range [0xdead000000000100-0xdead000000000107]
  RIP: 0010:__do_sys_swapoff+0x1151/0x1860

Fix this by clearing page->private in free_pages_prepare(), ensuring all
freed pages have clean state regardless of previous use.

Link: https://lkml.kernel.org/r/20260207173615.146159-1-mikhail.v.gavrilov@gmail.com
Fixes: 3b8000ae185c ("mm/vmalloc: huge vmalloc backing pages should be split rather than compound")
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Suggested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/page_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e4104973e22fd..77dcec36946f0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1429,6 +1429,7 @@ __always_inline bool free_pages_prepare(struct page *page,
 
 	page_cpupid_reset_last(page);
 	page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	page->private = 0;
 	reset_page_owner(page, order);
 	page_table_check_free(page, order);
 	pgalloc_tag_sub(page, 1 << order);
-- 
2.51.0





