Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D88891073CB6
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 13:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E1976B0092; Wed,  8 Apr 2026 09:33:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 743B36B0093; Wed,  8 Apr 2026 09:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E46E6B0095; Wed,  8 Apr 2026 09:33:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3BE096B0092
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:33:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 105FAE0297
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:33:45 +0000 (UTC)
X-FDA: 84635481210.25.8B021D7
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf15.hostedemail.com (Postfix) with ESMTP id 49047A0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:33:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=FVkie+Wd;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf15.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775655223; a=rsa-sha256;
	cv=none;
	b=V/8u7+SD0dzR+ptCSx5cmJmU9Nr7tdjCi6P85BQ/B+xqJPOfGzy8w5VxYASVw9INl72CR+
	SMG4zhSYLuHK72ty+fZQ6M7M5ztFX1Iz8tNpgFedZoiQbPACgC4HznxutY1tX4T4n48X2d
	o31k72q47e3aneVPtXV1+wl4i7884Gs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=FVkie+Wd;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf15.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775655223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9RL7qlVm+YLvixvcjLOGszgw3jk5/elO9uH+N6Bi7A=;
	b=75lS/2D3Z5CKRff8lmkLZrcb88X7jnfsCLKQ37xjd0Yg2NwbxJ6zJdSvrd0GIcBYTb+WlO
	vA4eFcdauaJCPJ6HKcOrRjQMzLpeOEdMinnudybO/JY4KEAk/xwmhkp15DnqJVRmuHnWjB
	2A+fyJoWE8eySrwhdFAb9Jqu5C1x5f4=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 25D3FBE721;
	Wed, 08 Apr 2026 13:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1775655220;
	bh=e9RL7qlVm+YLvixvcjLOGszgw3jk5/elO9uH+N6Bi7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FVkie+Wdny54lE+/KOfWJvPFtAY/yHO3JfDVQnUuzKlfTwS3xfI8Qd3qUCiavRuzh
	 CldXlyfYRKlKEhz18aWP3UncrQM2riKMZpFVAWv0CwomSkc/KSaVl14R/R9nMNdAqQ
	 Q6/Y9R29lykm1rEbvweJkkdxTnCrGa9Lz84sMgwQ=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [RESEND PATCH v2 6/8] mm: use zone lock guard in put_page_back_buddy()
Date: Wed,  8 Apr 2026 13:33:21 +0000
Message-ID: <24453163aff5187d34797a879ac89516c2828fd9.1775654118.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775654118.git.d@ilvokhin.com>
References: <cover.1775654118.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xyot18jyd4uns64be5nnc1mfw6u1ggnx
X-Rspamd-Queue-Id: 49047A0005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775655223-48599
X-HE-Meta: U2FsdGVkX1+1i8TW7V9oez6ccpWsa/lVHgLbR5tumwT1iKBYriwTvyQGYtptgn+aki+ymXXElpG++J66O+xBJRhzn6fIOIqwDQR+xaIYA9hYjrA6VepB4FUaYkprT+JeUFRvP3xR0iosa+T+nWSi1JUISmEEqvfs3e7Xs+goZKd8QNaoj0ExAb5o5RnfV6gmSLuLUklKKfqM8hFUacNfdAps60vy8vv3nRle8fxW9lKkcrt1HENGvi+0qCFKDU/dz7z5nLbTCFxas0HXn44im2pPGwIbac4cpjPzv/REZkDuLlkecDqyfNHvp+gA4G+jSWqhP5uLK7pr8KFBx+S7m2jaTE/n/PJ+bjugGJhMAw56jeWq6FGPXVBAvN0oGaP8a5RRKI1bm8wlZDw0tJtW3RdrwHaWjU7UWfaJ+MIo/9kIY4B98okUSYm9rxRXvuW9jpi7rJjCw/DwrX1ZrdVPf5ZKf4Fx+0wQamGGo27mqBxQS3iBh+oXQzRhYJclBbYO96U76TcpZonWnFjw6u00ROU8atpcU+Bo5WCylt+S2MB2ITHzQb/IMpUoK3DKiwoQysXD/lhHspeHNuSpibGkiSB94WvE5KGGZ374Ftml9af+7OEdRROlvbKMuqSt7gBlR1u+WcHWM96oPLFqE/kSO/i9NBMW1PY6c01i4KPM5RjxTDIRaI+hAgi7nooKi9F0bobwLnU3t5kBKYd1YqoB3oSQPPbmwQTe6Z6Tf3bQXh7WwCDCtP9KXX+l37OT2apuSfLhdvHpJNnPgYR/fLSMKzRiA2CST+4kryAlwP82PCUmo8faQmu1mTGdOcCqq7BHZVcn8Cz38QPMpJuLT5KTIfAXpdm+VtWJ7OyoxXy77MOlr/1VwZyWyGYIAB3jPbvmNuwAFOjxyTqEl7qjAgwt7wJgigNDAuhb48u4BvkdCk+N8JIToNQQ6sEU4dlaQHM2CDe92Vwx52PNVLCaDj2
 aULiJk9x
 OCFV75pK1He/ejap+J+3EB1/xULHbwdbj3aWrxT2g/2NR1Ac1Xw8QWdnwNv0SzCHY/Yt9VVPaR3n1nSlfedAEaH6u38F71xU0OYYlruBw4R3LLjczcB8C5vO3qkusRXIGULscvfT7SlN6VxV350Q8Nq+Rbbav37nHmIJIaa4dFshPw7idVzHUlMo0LuwS7wAkeo/eHGeqCObmJfASavni6Z0iNUKoIPTXrxa7xoVub1mUUZB68oqwwipIByB+/HxNjT/CJPrMIukaxden6kaqwYkMwlvMpVzhAgAkBT1kdX4Zb5nSLGRvzZwXKhO9gPWWSsrYWZcUFr+EWWRGn3AzHVjLDSGpDt10xd6L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use spinlock_irqsave zone lock guard in put_page_back_buddy() to replace
the explicit lock/unlock pattern with automatic scope-based cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/page_alloc.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4d074707c850..096f5fef0eb5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7540,23 +7540,19 @@ bool take_page_off_buddy(struct page *page)
 bool put_page_back_buddy(struct page *page)
 {
 	struct zone *zone = page_zone(page);
-	unsigned long flags;
-	bool ret = false;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 	if (put_page_testzero(page)) {
 		unsigned long pfn = page_to_pfn(page);
 		int migratetype = get_pfnblock_migratetype(page, pfn);
 
 		ClearPageHWPoisonTakenOff(page);
 		__free_one_page(page, pfn, zone, 0, migratetype, FPI_NONE);
-		if (TestClearPageHWPoison(page)) {
-			ret = true;
-		}
+		if (TestClearPageHWPoison(page))
+			return true;
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
 
-	return ret;
+	return false;
 }
 #endif
 
-- 
2.52.0


