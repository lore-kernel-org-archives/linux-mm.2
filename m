Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61F6110BA421
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DAA36B00A1; Thu, 26 Mar 2026 23:33:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8143E6B00A2; Thu, 26 Mar 2026 23:33:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4A16B00A3; Thu, 26 Mar 2026 23:33:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0C16B00A1
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:33:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF9711A0F66
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:41 +0000 (UTC)
X-FDA: 84590423442.01.F7832E2
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf25.hostedemail.com (Postfix) with ESMTP id 217ADA0007
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BHngVuPQ;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774582420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w0STs1QLqmbfKiY/OTrM4XieB5E7WPH8bzjLowLKVe4=;
	b=kuyRalaHnROvJZBqHIJaA3BrN60vnTVKbRs/TGPck6mms0x1xJE8J4Z+X8KWpQvS4XRbDd
	FNASIVVWeHcDm5AzuDhKsrqW6HgpKPwoGeHotIXipfUCycvDa6Nc4aJYvmtRKKLCVTVxag
	kro/gP1D1VE6sfvCwoMTXj3wFO+GZBY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BHngVuPQ;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774582420; a=rsa-sha256;
	cv=none;
	b=Tnf4XYFbFWnj3QLwMFC/0sdh0gMk7v0Mqj38mKqbrsn5Rlfta/r1AnxD+ATtrI1HIl/HRj
	PRPexsGKnRmjczPKlXbtdikDc+YLEuGFiwUPmjeBWTUzpb4MxJZlHQJDXq+HSBDqKfJmqg
	I1N7M1+JS/sf3vbLVR1oDuWEyq250W8=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-89c43c4c383so20466616d6.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774582419; x=1775187219; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w0STs1QLqmbfKiY/OTrM4XieB5E7WPH8bzjLowLKVe4=;
        b=BHngVuPQ9eMsd4+M6bLSvJ4vfn4tmkwY5eQ4kCkH43y0/LqD9k0ECQlya5SkTgq4ZQ
         taJ9ynxd9oDFCZECcWYmKmhPWj76tOusCzayL4oMmjrW/u7n6rdWD2jbLp2Ba75Wl948
         9dtSv2QwTXgnDudn/1A4dCZoW3pT8wdJUglSFvk45S5de0Zngz1uWw6gdzBwS2aaXm9X
         5mimO2vXv/H2GBNtNW5j9GMoc93/VaBECcCsEeHIIu+A8a7mP1K/K5SebgP2T9gVrSz+
         jp4tWHNGImk1/DaLBiXwGNPO7bJxXlxKgsa0inOXJdQHB6cfjZFpLqk1w8GeXcT/DIvB
         Ku7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774582419; x=1775187219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=w0STs1QLqmbfKiY/OTrM4XieB5E7WPH8bzjLowLKVe4=;
        b=RQUF6RJkDHSsHw1dMA0We3/LCUu2kvRUkFvbcMtUCJr2/vkLZ8HjOGRBrr5R/9HKBm
         Qq6QIiv0zjGmFmg2R69gKmLbmU2MAgL6KXLDy9FBxKnqkinOsjOGetCwcZxeRv7Xg+xz
         VA5xWpfCpztm4lsvvsg6YKmQyKwMeMiV/aZJCbdL1xWK7k4P6WYlHkzwyzJcncq38n9i
         brdKzsFNeXaQhTSq3/xbaZyM1bxuB8kphwCWSVfjNjdl1zruKEln9sjqKg6YssnKQVXA
         fI4Wep6RcWup6pIHBUrdxJ/QVrCWKs4XGAMpt+UL/35nilhgF+WTh6Zyca5dlIV8v1L3
         J66g==
X-Forwarded-Encrypted: i=1; AJvYcCXiKUxXGFSE7FaXtbIYNISFZ6qaRMVPA6Hzuvb7mWT9gu5vX91WoazBb+aF/xaGrbSg8ic1/B5uyw==@kvack.org
X-Gm-Message-State: AOJu0Yw+BpY0MabeoD2CdN60QTv9XDJY25ZJUz+jJl0FJ5Gh29yotmND
	sWI9j6j4XKL6aHnopOW3PVQqn+Oo7Coc9apvxnCb454ifC2diLT0D3U51e24uz98C7I=
X-Gm-Gg: ATEYQzzlJvMbI25wGnWfOA9YneyJfNswK7ysQ0YL4ZVgMtadQywAl03gn6O9lVDtnk6
	LHCSmZHJ1xKDFwUn/w1INCcNvRcGSkqi7QUM9hmSSaMBHYWz1k6DJRExPpQMEU+a8XfOcBPmKsY
	CYJ/UDxIC6P7QowQShfzaSJsn4Yx6TNMR5CHRa/iZk7NdlptlZrX6n0egPJ3W2WwVkFGQe18tFF
	Fsuv/i/CGE1I49c0IoWH56QSW85v1fl4pqg+AtxTCOWT9esvNJuB73gxCL4w49M4hQMODkZhCQd
	sPjLOnQM7sNB8eRRyYKwueLyT59YlX0vPlBQK3SLOHciLl5Y02qGBXvLSnPTrORpfm8cEZjklxK
	lTNnfJwyQn2fBvFArJgXZ74QS2vEG2A0LjRLl/nso2E1TtUh7WRUBD0hoMTsadK81zEs30z+E+V
	mgfh+Xf52DkF8ff9Bp7iebB2Y871rjxc42SI90NSFl55ckf5qg+m//1r2VnHhXrbxH6+7f/L7gC
	66h
X-Received: by 2002:a05:6214:4a04:b0:89c:d408:b52b with SMTP id 6a1803df08f44-89ce8f436f1mr11006356d6.48.1774582419011;
        Thu, 26 Mar 2026 20:33:39 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89cd5a22711sm46519186d6.27.2026.03.26.20.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 20:33:38 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v3 02/10] liveupdate: Synchronize lazy initialization of FLB private state
Date: Fri, 27 Mar 2026 03:33:26 +0000
Message-ID: <20260327033335.696621-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327033335.696621-1-pasha.tatashin@soleen.com>
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: m1ao7snc7hw1esfhb1bowghxkxehh7mw
X-Rspamd-Queue-Id: 217ADA0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1774582419-667957
X-HE-Meta: U2FsdGVkX18yW8uin1vl9Aihu0rwuSF1TakfGIwykUUdk6PDA9Fsb2bH3R8NiYgLyG1qAIG0gzCYxuI8hprKHnJmoWnGFqNGY3tKWHeoDng2Dmv0FlxiTRf0+MiFHZg1gwGcKxLPW392Hgh80BjwYisNueIQahy8pXkR4yVeHOFP3/gIiem04FXThpE0lA0xFY6zPe1e9G+Disw2a0LHbPZnReXfeFnHa5ghJhx7hkwEg2hGBp9gUs6CEXuZqHviMKNpXJQHSuDI1ju17milJtVYHloBDi94F6iFnJ6+TVbj2JboiAOrs8Q0Ekr10qkFrgJTeTLtWqwqeBEUTMwP7oMO/SS4kn3kmV7bdVZRDLKyvmb9LN0Crx9jCnch/r1uttLLiJ6FUWlz7b0wYRmqRmM7UK2PaA86uA6aEUPiuqpIuApM7hvnMUG/0R1xLryw9jnm6diflSHpxFjcuqiZGmnlD+iSgPHl2DS+x9G2prwpC1uGA9GUF+aEKEL7J+6D8JBVi3DYpBHRk/pqjvKsMypERw1xezxVA1cIRZE+Ht/+q/JtkKMq3xjtIwlJ5Uk0gJbOnIq9P+z5vDIGoAvrdp5CjbS6MqcAN15Dq5JbIF0Z/OCyXBzoEqzreBou9i00wKe/9RbHd9vuduZtb/hQ7AH8XcUvHulVpk3n21Afp6EJ4Re2/2viGmAOfayq9nC37YWDp1+qqNaG5QfHLQq9ko4K7FTVXVeCa1Dq/rJ8+N/wtw0p2Gk451ltR1mDiI8gHO6tWA00J/RvoUGP+j8dDAtgyXlEHg15+o+inD1eqY79tZ37mgRc8ZOen7IJ5Kfq/w86D8dunz2RlQBkfa5uxoUUaz2JgSyFhEchFb0ct6dBsgHU0CFkodh3uR07vjRblZgd4jk1Gp/H88DrldEpCYShkCzZuFA0KCwcBk1zZYHSJOgqLwTXUMfykz9+nJqgmIskUjKHb9X97BJfSBG
 iBOv88mL
 5dos5Y2NZX1PIa0Z3yiIH4RnGx1rYb2vC4aa089N46eL07DOYPevDMkvxGhpzxpOHhnBwTPwKjYev9Z5GznR7E1eno7M0M3okAioHSz/stjVdo9z9seAU612Cr2Qz9gOk2/cqu0gjSdbMFOGM4d98UyAZhqkcByFKqF2NqyDoxbhiLp5nuLUjuC4VcynN6t2zkb0AcU6/UW0CKmh6AH/SrA8SNtmHN7idqBZc8/QoM3L6Skx1bLUvgh5ybXTv3EgIVV2JOIAOorjmpuKhdKJiyZhFiCmZqg6Js3B48LnGs0tCeE/yBqkc1SFi9SVHhwu3WZsPk9e7Fz7PdNA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The luo_flb_get_private() function, which is responsible for lazily
initializing the private state of FLB objects, can be called
concurrently from multiple threads. This creates a data
race on the 'initialized' flag and can lead to multiple executions of
mutex_init() and INIT_LIST_HEAD() on the same memory.

Introduce a static spinlock (luo_flb_init_lock) local to the function
to synchronize the initialization path. Use smp_load_acquire() and
smp_store_release() for memory ordering between the fast path and the
slow path.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_flb.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index 855af655b09b..317c02a94da5 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -89,13 +89,18 @@ struct luo_flb_link {
 static struct luo_flb_private *luo_flb_get_private(struct liveupdate_flb *flb)
 {
 	struct luo_flb_private *private = &ACCESS_PRIVATE(flb, private);
+	static DEFINE_SPINLOCK(luo_flb_init_lock);
 
+	if (smp_load_acquire(&private->initialized))
+		return private;
+
+	guard(spinlock)(&luo_flb_init_lock);
 	if (!private->initialized) {
 		mutex_init(&private->incoming.lock);
 		mutex_init(&private->outgoing.lock);
 		INIT_LIST_HEAD(&private->list);
 		private->users = 0;
-		private->initialized = true;
+		smp_store_release(&private->initialized, true);
 	}
 
 	return private;
-- 
2.43.0


