Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C78D1C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A24B86B00A5; Tue, 11 Aug 2026 13:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AF0D6B00A6; Tue, 11 Aug 2026 13:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876886B00A7; Tue, 11 Aug 2026 13:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5672F6B00A5
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:22:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CC776C015B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:22:22 +0000 (UTC)
X-FDA: 85089657324.16.740906B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id C8A1D100010
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:22:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="bmkn/KxE";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o6vE+0Uy;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kg9th9bj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WyX1Rtkz;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786468940;
	b=rpB92APL0WlDOaluaNIpL0RaqgULCLdZ7BF6KysHeTk4I5IYFzKT1tV5d3zgizdrwEWdvg
	qMmYqzd8UIMNp437Qf9yqVh3BBgBNwE6LkW48vBxUJ+CVsGX4YHMpoaG1UQvnyPD5uf3HD
	ferf1bePLppJ21hBetR3E0aUG+AOrz8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="bmkn/KxE";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o6vE+0Uy;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kg9th9bj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WyX1Rtkz;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786468940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QVVRJXXPliRw542MzPPo/aSrNZpWcD5mogMspae6XJg=;
	b=HSennGDAwH5YyGS+h1DeCR6ZB9s1uJ0cy+V9mMWiusN7dsvk9YRmk21fSEuyq7hJHDIjLR
	xNwYxbJOzWz/CMhM7GDFsM/WByi/pBfTUAX8+MAbYJpmJ2aw0Z3HMZzfclVTBk4NqD9B18
	+eoRiEItTuStA6LGyyH50Fx+rU4HykI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6843881E24;
	Tue, 11 Aug 2026 17:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786468935; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QVVRJXXPliRw542MzPPo/aSrNZpWcD5mogMspae6XJg=;
	b=bmkn/KxETuYeMw7x8dcFnw9dIhsrAQCJC5yTHtppE9HguWipXZpNneGBjsH2nVCE5BRfSc
	qRYCAMZUJgSx+uYsxrAm3j1Y+eSvbonBTjslA3dQmuLIC26rs8EQvW1LpcDP7CGkUdlgMz
	cScUFBy1a8Uy3gMcYbsRL7yGFv72uew=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786468935;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QVVRJXXPliRw542MzPPo/aSrNZpWcD5mogMspae6XJg=;
	b=o6vE+0UyArwueO4JKqOqo64yikHdC0UvQ9cq//mu+V9uHVnJ1P6qeg/IEIkY41KvXTjJLd
	/tiALZCDWc+M1gDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786468931; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QVVRJXXPliRw542MzPPo/aSrNZpWcD5mogMspae6XJg=;
	b=kg9th9bj0aBc+OEPaRUPY/JpVcY2EBCoCSOLU/h60H2ruut+EXaCqrB1DY1P3eYPUVqQmF
	Ov9RDagYfXAe0AsgXw3dMqxtfNGaXVVE2jltvBhk+HER+8Q5LbvalcBp6Va3JUk0XT92Nj
	I/Rnt0EeHOHjp5LR1FQ4A5nscrnJAOY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786468931;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QVVRJXXPliRw542MzPPo/aSrNZpWcD5mogMspae6XJg=;
	b=WyX1RtkzCgFCkwYHcdrvhNzeFN32s09tnGRHNebjjL4A0F4TyFBmlS8fF0cV5J+chMbAA4
	SROgW/k1rRDDofDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7CE5C779C3;
	Tue, 11 Aug 2026 17:22:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SMgLG0Jae2r4TAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 11 Aug 2026 17:22:10 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm/page_alloc: replace custom bad page ratelimiting logic
Date: Tue, 11 Aug 2026 18:21:56 +0100
Message-ID: <20260811172156.356053-3-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811172156.356053-1-pfalcato@suse.de>
References: <20260811172156.356053-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C8A1D100010
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: m1bnujdb4cc7a6uwmq86ou1y91aio7mg
X-HE-Tag: 1786468940-539743
X-HE-Meta: U2FsdGVkX1/q/Kp2Ud3jsd4bIBunFKWKOgtWq5t2TJ4hI7QMrOZ7QL4ip7L7Ibgg3BYaqvjadyZCVc2HydUJ4B4KlnbuEkgZj7xLBMTawjGgjjCDJFVjLT9jq6qaD5IhM57Nw7eqKKrS2YfdRRqlopcG8TlXxi9YKRh8YYe/YqtIkIcBt/Xpgk6Dg8XKJsPr/36ub4gAELksE0t6J7TU8bQWrpVhYkHknXJGB+3C6yHcDDWoSPwpBkP/xElcQqlABnMRkWpl+09iRM/nSTy9Zr3RoDj3vi+aZ/1RKJp94/6ukoB5wAsq/AMjgG7x1YksgBcY6AAV0GKvEfka5PuNyl2uWLssjnaK61T4Y0l0l7JnZekj2Eu7spZ9ERh0kur4qCPqzKKe9KY1bVboca25rkw1GXUdMXgpszNwfl8UIOBaEwHYboHJcJ3uNl1Auvy3CgCzDoKJrIbet8C3WmkbgtIu0WfXnnk49GhRd/KioLarz/48FmiCeA3F8hrEKWPHZSN/9BqdjwTRCjXq0ycqKtDwqmPGZNt6h+NN+YJ/kzOb95XAGswb0+aT2ahDZMl3kGd9hdfZushHGP8qxyo9hn/qy9fQ/hlDZfV8GbgPJPeRtuLHu3ApVuJQR9hlzglLMh08oRPNv85MHgNxFc+mud04jtNedwbcv9/l0LVcyNU0Sl2AKQIL26t1EN8d78v75SkT55rot/PTxGcw7wOwy8pWmP3+WkI1mqx4GM7Cy4Ucsyjtg8kZjC3tJ/hbfiGuIfTz/HzTUEfS/qVRrTRAvQgiVNj5uCah6gflfLImuU+lOiRju/Bi9xY2joYaA+/AxCEHAY9MZhZIrsZIYnnyca+ClKgB7mFlp34CgkBWAxg8F/meTwUC3ihY7/FAefOkLOp61u2hT9WzBcbJhIBNFgLEQ7yHbUywdz98ePahIYDFwkbVuvgiUgZmliBh3FgMgqh+rwKf3YYRlmJ287w
 +ZnSyPeD
 ge4TlJ8NRcU0iC6wWyZx+0fyeCq9YW9B4Yb2T6g72+6YFEqPlNCsqKvhOPpCb1mSY78/Zr5K7YGuQZ0BYLsq3bgLNQoZJ9Fnzfyor9TFUb75Iu+LWfVPM4/fXH4rt6VaWaY2meDGIIs7omdqB1DPZ/QQ8vAD7DZ8xF0nMxA+9q8dy1efCh4PEBaAEmRC9C3+imrX1EOBe+xORny+JMokrF45bN+lh9VF9gSrn+X4w4uTlXCJxtoSLY9sFzi8YPwssg0BpvgdUX9pXLDoxRWs8i8QVbryPzhVqrmb+UQbAujgArP5HzMCTdLu3Wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current logic (allow up to $BURST prints per minute) can be entirely
replaced by the generic version in lib/ratelimit.c, used around the kernel.

Do so. The only functional difference should be that the new logs will
read something like:

KERN_WARNING "bad_page: %d callbacks suppressed\n", ...

But that should be fine enough.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/page_alloc.c | 28 +++++-----------------------
 1 file changed, 5 insertions(+), 23 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..9ccfd87bc273 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -613,31 +613,13 @@ static inline bool __maybe_unused bad_range(struct zone *zone, struct page *page
 }
 #endif
 
+/* Allow a burst of 60 reports per minute */
+static DEFINE_RATELIMIT_STATE(bad_page_ratelimit, 60 * HZ, 60);
+
 static void bad_page(struct page *page, const char *reason)
 {
-	static unsigned long resume;
-	static unsigned long nr_shown;
-	static unsigned long nr_unshown;
-
-	/*
-	 * Allow a burst of 60 reports, then keep quiet for that minute;
-	 * or allow a steady drip of one report per second.
-	 */
-	if (nr_shown == 60) {
-		if (time_before(jiffies, resume)) {
-			nr_unshown++;
-			goto out;
-		}
-		if (nr_unshown) {
-			pr_alert(
-			      "BUG: Bad page state: %lu messages suppressed\n",
-				nr_unshown);
-			nr_unshown = 0;
-		}
-		nr_shown = 0;
-	}
-	if (nr_shown++ == 0)
-		resume = jiffies + 60 * HZ;
+	if (!__ratelimit(&bad_page_ratelimit))
+		goto out;
 
 	pr_alert("BUG: Bad page state in process %s  pfn:%05lx\n",
 		current->comm, page_to_pfn(page));
-- 
2.55.0


