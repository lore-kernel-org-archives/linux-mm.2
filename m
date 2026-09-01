Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43A30C624D5
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:19:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 339E26B0191; Tue,  1 Sep 2026 09:19:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 278EB6B0190; Tue,  1 Sep 2026 09:19:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18F956B0191; Tue,  1 Sep 2026 09:19:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC0056B018D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:19:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70AB71203D1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:19:01 +0000 (UTC)
X-FDA: 85165248882.06.BF4D619
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D53CF4000C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:18:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wwzgo9sU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ZB1yfEGzN5K33ID0e3bcOFkHhvifJ8hhhrNtAvrugg=;
	b=fHCQruEExxrZ8MhSDw6tnukxghMqy08EYe96YCwVGbxcnP+kpVTw87m7Xbj+xMWVPCbIKQ
	ZyGpb3NehvvG85ImN3OAv40tWakZnPGziKy1jfq7roiGeW8UmovTGTQgaTnbPLqFToWiUL
	FUNBilg0jfjSENLg6Q728JXEgJaxMcw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wwzgo9sU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268739;
	b=zJZIBeMBjro+R3+bZE/GUCjWL9S0ArvJsRFve3jT2TNoNcWI3llB9d7B940rvsaoMRmzuf
	3afBBfV29TPc7vALoMz9AIxs1tfZW7YYDmBr11HmvyUHmTUcauqMz04lEFTcQIoJcOWcTJ
	y4uBivDQGK/mLmnV+ErLk3LvSMVo4RE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B98160213;
	Tue,  1 Sep 2026 13:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA971F00A3D;
	Tue,  1 Sep 2026 13:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268739;
	bh=7ZB1yfEGzN5K33ID0e3bcOFkHhvifJ8hhhrNtAvrugg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wwzgo9sUB5TGy5zNJC4yHnKl5PtqWaoL8Dz9GwQCTVx+obhlYqR1i0dXlvtkkUxsH
	 d+W+CRtkgAwmR64rN/I4NsWsEeAvHdwvnu4Vyozpe6/CE/q0+kr6mHKbH0iEm4/4Jm
	 FJYIaONRuASM+kaXuNw2QgWGSuP929VGyraDfmNW86cRwkx5yeM7103V36kmVm4szn
	 bx6KyNXzylnXnBWUo3/kFBeCT6ycgOkaxm3HK56Di10oFNNBgRUz7AZm9oAxaCElpM
	 kHbjXf9YQkEdZIG8KxU7SY9fRBE7hp39GHgeYEPLuM+IgfzjovwWd0RP6pk/iArJRp
	 pbVx5n3G7spjQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/8] mm/damon/paddr: respect folio end for DAMOS_STAT
Date: Tue,  1 Sep 2026 06:18:43 -0700
Message-ID: <20260901131850.98037-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901131850.98037-1-sj@kernel.org>
References: <20260901131850.98037-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: exiucnusy817xy6taaodz7ic1ra74zgr
X-Rspamd-Queue-Id: D53CF4000C
X-HE-Tag: 1788268739-801292
X-HE-Meta: U2FsdGVkX1+fCvqrcVQ67FUSRDNmGv93ctT5cXwArff0TtT9kc859Q1C/9KDFVgpl0KbW/OJj5WK3QtQ3dirAyN6XqFK5OMJT+X76WtdcXipNyoWAB9TvENQSFTB17DKZZz3ugA2NYjBPPnRstfsP/WBl09W1WSS5skhiyvNdmspFVUd4aCJFAXPSdd85q/U3x4uY8p4qxRxY7Oqpfh2WZSyy17XMCgmk4f88yaGHlrGMyuhZN180Z2XxtbtcTNHo+7SZMM0Q/XR8Cio//LAmCFgCctRyb/NCmIa+AMlU0IvDNx8CtjRueDmDv6JGLYuzyubp6zUIRutLZWEP0uOSW+QUeaUmz6RtkZBEXSEjFgP+8vBvsdCkqP6DE3aKr7pvlrWPatXok8ytvtpDThPOJpJH6cYgod+GniniFHSTAyL1Irq1LSWuyYTGWFR77/tVVY/fOytSsf4t1utyRyBW7bBw3h3jLtOwcjCnbaEjGBl+RRG084kyEPFfEJm9yjI5YKKejYfNky4vCoT0EcD9IpWcjjhQFaMhmrLCoN7y5s00U9R80IcaA3xsQU4DplOUQSHMHc7iK/1zDU0oKzjoELd30uDG6dhliguAXoHrHcxU3cVk1u0AJO4SlxfkI2/PS0Yo9XT4sgquGPG1wyDp22iezQnmDuDnpAkbK++H3tujBpCCA9VpOMTmlCvA1NnJU8cyRF5ec8Em1DSUGkFQOdv1BUbpazhdLRAC7VLE8Yh7tRSs7io0B27xGk8MLmYFKHrcrSGaz160FjUw4xpB68a4adFWe1wZUz6TVcXadz/Kv0ezrAvBQz9P9owPI5oBirPI1KNzJGGckA+4TMzgxvLHVq4lX+XgIQ4hZoVS66d5FpOuEhfzH23vxk36Z6r3u0/Fn1/Whf2xK6COaIgRevQcDM+wbxMQLm8SHL5VRJ4oTTB59XdL0oj423EwUpwp8q6vb1qrLh8ENFgUgG
 uwpG1h1p
 qBXvDvxoYxs01nzLHp3v1XKdExlHsJ7w6cNi4TwEVOpyxGsOCu7R0LqWrPMdlOISrOr4UiEcfDCFHEuhsOD1oYzrUzIF5ZUp7HAgTPKAtCej1hrrX3osGo0LnbFOcboo/9gnQxfTlAnXg+4Dqle4zaGxp8gZlmtbSYJncsLGY4Zghl6ZrcnGzWqWnc0zqJWQKUqruqFRt+0wcUpPzCDvDVTUDevuSQZ15Gn0A2PpKDjZ3RDnvfIwA3oINDEeQVezCmEWU2ZBnheTBWfX0L00V6XLS+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function for applying DAMOS_STAT in DAMON physical address space
operation set (paddr), namely damon_pa_stat(), applies DAMOS filters to
folios of the given region.  For that, it gets folios of addresses in
the region.  It starts from the region start address and advances the
address by the size of the folio of the address until it goes out of the
region.  If the start address is in the middle of a large folio, and if
the next folios are small, some of the next folios could be skipped. Fix
the issue by advancing the address to exactly the start address of the
next folio.

The user impact is that the DAMOS_STAT-based page level monitoring
results become inaccurate.  Since the page level monitoring is supposed
to provide relatively high precision, this is definitely a problem.  It
is arguably not critical since it is only monitoring quality
degradation.

Fixes: bdbe1d7bc325 ("mm/damon/paddr: increment pa_stat damon address range by folio size")
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5c6c3a597fd0b..2ab7b3842701e 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -379,7 +379,7 @@ static unsigned long damon_pa_stat(struct damon_region *r,
 
 		if (!damos_pa_filter_out(s, folio))
 			*sz_filter_passed += folio_size(folio) / addr_unit;
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	s->last_applied = folio;
-- 
2.47.3

