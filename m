Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C381C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:12:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0D816B00EA; Mon, 29 Jun 2026 09:12:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBFA86B00EC; Mon, 29 Jun 2026 09:12:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C85EE6B00ED; Mon, 29 Jun 2026 09:12:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CBD96B00EA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:12:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 114331C37C7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:26 +0000 (UTC)
X-FDA: 84932989092.19.81C3B1F
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf30.hostedemail.com (Postfix) with ESMTP id 59BD680007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vV60xjOM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3Nm9CaggKCHceVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3Nm9CaggKCHceVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738744;
	b=C1vTdMkKxh0tVKOg6KYprtyqHx9DqRBag39KjZVNrgsqsHeFgtHdHFq46NOL+DErnrINK2
	O9A1LC4MXo+7BEBLDg6ZYbisbKFOtLZSJLrLIuAtzqngmJtkdxW9MvSQoF2GWNXjJ6GWNQ
	nJs2T5l8RQDfAyGsHv8OB2vRq3l6uE8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LAoUsjWph/3flUCSB7flZmzGzWVdy8wS9hni21TX4N8=;
	b=q/ngUBiAD77ZoMclSH0QWr5Ci6HNGQJ+a+9Fxxz/T+uVuYAncXnvJlonCtf6oWfU34ghjG
	84CGEH4B+T8xbJ6FbZnfMWuax/T9V39VOBuudY8pwK3Dtpwz3eGuDVGLRL6jily1JgvD4J
	rFvegngAK89sLsld1qOeCBz6mfn0LpY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vV60xjOM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3Nm9CaggKCHceVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3Nm9CaggKCHceVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-46fb9079a04so1330725f8f.3
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782738743; x=1783343543; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LAoUsjWph/3flUCSB7flZmzGzWVdy8wS9hni21TX4N8=;
        b=vV60xjOMCh8qm2fIJ4Z5gyW3ZNXYuouOfwUbmy7HTH1ahSzHuQ2Ssn+Lju7ynduoND
         bPCfNuYOUEfKuhmu19Lq23Gw71Pqa+EKsXVHfImQTc1MDzv3f6Yhwz8jLB89nylISefX
         b2ax4ldTZlP2lmt0Mjc3DB5p1GI1jzR1Wjaqcnt8ADfJ0OR9fpXYeJag7U44sTspR92Q
         VOJbrhhxFstZYdezWXE1U97cTkub6mwy7fvIkTwuppmXukjKp4FbGIxO6ls3kq4M+BIK
         37+ePCqQDbDMQUJk2/lLjX9j+/5oyo4tiP3awDOxcjDSOB/a5TvrroTx1/tglAm8upj1
         zqpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782738743; x=1783343543;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LAoUsjWph/3flUCSB7flZmzGzWVdy8wS9hni21TX4N8=;
        b=NXz62qAGByEpBybkwXE9b0SzdzdV3wwXZ7Cuez8X6Hd0ad0abp5aD3fhJCBX2blCJC
         zc6/y8LFcJt1Ah/fy56XjunPkp9MkFWQ53xCvPCehUXZRNlWQJ/xcJla4hbiQBGYU3kQ
         y3A45555yIiWf/RfSI+NjMQEG2EZbS5SlLyJ/5ZkYXitR8SnHVNdXG51BfJR3w049I4D
         qTzAaj3drcjJUWGa/Ofr4zzxQGbRwmkGJIPPjYSDL3M+PW5xCW08uzhz2hSgXD6Jys5Z
         /RAflcyYp4axiF3R2rSChNbS8+fdgKLs+ODEIPunZ/z33CrAoskND/XAWQqYXN7Noaob
         uGTA==
X-Forwarded-Encrypted: i=1; AFNElJ/rQ6P24YItgvv4itY5l6Laz6XH3DpgASScs9GLTuHP4tTRZU/4JCkjVivFz/xh2cpYjxd0VxTPig==@kvack.org
X-Gm-Message-State: AOJu0YzUCuE8qIQ+tkA4xORcd6wJMerxtEsi7geB4XtKoqkpgr7pVRe1
	LVorTYnj0LsSTA1sSClpgJvfXumBck3iKFSexxNTsMkl+jxVGwWMRQCGgT92IclGMC7La6d2M7Y
	hwia2dmafsJcqOw==
X-Received: from wmjq19.prod.google.com ([2002:a7b:ce93:0:b0:492:450b:fe7b])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e45:b0:492:4948:bfce with SMTP id 5b1f17b1804b1-4926fc45f89mr171546305e9.16.1782738742815;
 Mon, 29 Jun 2026 06:12:22 -0700 (PDT)
Date: Mon, 29 Jun 2026 13:11:55 +0000
In-Reply-To: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
Mime-Version: 1.0
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260629-alloc-trylock-v3-6-57bef0eadbc2@google.com>
Subject: [PATCH v3 06/16] mm/page_alloc: relax GFP WARN in nolock allocs
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 59BD680007
X-Rspam-User: 
X-Stat-Signature: ja4tng8ap8f84yzt18djzpmz6g7tptfu
X-HE-Tag: 1782738744-507428
X-HE-Meta: U2FsdGVkX18Wu16e1s/bxI/1hcEz+BzWuySxISrz+RZY86pckzMneisNUNhVGavb7KlwtL1sQ8uQzV5FlRiV/YwtJBIAN+tA/pEoH6gQWFvj3PTlLqRVhzmKwkcB7SVqyz93FUZI7Me+9ViUedrVfrj+4LKykXz6mACBMh6gp8/XDbCkJMymu6Wz6tyFO/PgYbLq1EcuoU9Q0m6T0cUTRb8cnVi9BngPjVqMhDoFrxdmaY0ZPjlEbzjyiFz26++pYVo5RdZsejqeW7kpfaXMkwjJS7V8MyCCN453J6N2gley/l3MXAUvOZ/5Uc5XxqzXdWbBmH9wPG+fpLDbQeCPdA28IXZkc5rD2CdR7jJyLTHYX6t7aCLH254p9n6ZRAp4BTp7uB2qhyBKO4SNfN2VhvWy4J5tkKlPSnDhXLkkyj0wiaJN6Hu3Sfyp7vF8O3YbEWhf+wsUeLaSYR5N5dYzXJbB7lbgnKi+obuDie//2hzwXJHa8UszoDfsOtyjB0gPJ2ActOoEOSjslVjJQqQRo6gzz5wzUtGD93mI0lDkKEPa9n4xzqGRCOMOy4mJH07vB9cB+gGim78+1rG4QFROH70F8tfqdLInSglWw33OEj+Cw+lTuNdUeOfECTj5/Q9vNq61grI3a9sidx2up3AyLlZA4SW9Pu/AMK6/0Wq/pS0NJekXzI4nFL17uYgaT0Ti4vMPE9f18Qm4PaXJ5jDpO5QVWga8Qmckg4rZwjmVNP5QyOELJcp3142O+ADHOjHYT/EfYlEyFj1z52lJ2JrPbAbURFitJdOhfVYnkVT/573xxGH3y7n++vNcpji1/fxnG7vXDfb1P9L7zZecYVQKFebQF0Nv2AqNoBWylhcI4z1//j1807Tk3molyFOePYhMvrVQ4czxWH0gujnUEF5m3XUFl2vQgF3V/3pUuMHGQVeQ7ULAIegWTgYv1ue2NSm7X7pMWS2Yazs8p4kVpmk
 Nos4rlfz
 PMXULL7pOxxCsfuU8/vjoQfXtd0MOlWShHgQMzV3Hh9kfRUPk5+EFQr3K1RURYDRKh2TF2TVwoL3ERING6V0NQKGSW9bj+ZS1MbSVxzI6cOxzuERSiTVU+AsvvndPCzGIBR5pGYmIXfcXAC5KbHUfb/Oa4d4d4QiixWUSe51fj3YFDh36NwkVZz3FyIKJjpigFiFTbSf8Od58kUrIRZ0OWGWEs/ZEhxg4sGN72X7r3lQ9wlPiYJvyaJpxBpGyvI/hyhd0XjSYtd3/OvBKo3BbGeVr+tlHqz6o4nYQPTBWUcMDqCGYh229g20MLDbaeFeJ/Og5038neUZCvvMwlTFUxM/nxDdOrcy7pZpE7PIBpKobCKat0veRhsRR2C4gEPEBzJJ4KzDSnaVBis37GWt412DJs8lul783WI9257xbcxJtYfBKI77ATcvHQcohUAxqmNbY85mYADzYcDGik63cx3KHYRMmyxypdnViwmYA86tftb0jHeW94TCDxXx78hFLpktCfx8DT+1Gt+TD2xRrXaN/Np8pGh4gXH/l/sZUNocifpHeevvTQI9Gji5oIZw6AfZHZL/fTtvNvnqBTp1kDwAh9E3s5Szeby7O2cbypazmvnIgE2YJc78JEGsC7hR2lQ7Yb3RideyBSqEv48LMmB2sH9pU/RUDkh8XCMy2KK7TC7i3tlW+2CvPH1vjWJr0bCgtnlRzc5eNLuHByX1AhYb4XcaqutQb4wUjqEBJ6pGxn2Ea1yq8h3NnfiXB9Zr6G97m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This WARN forbids setting other flags than __GFP_ACCOUNT but we
unconditionally set the ones in gfp_nolock so they are certainly fine
for the caller to set.

There are other GFP flags that are almost certainly fine to set here;
Willy noted GFP_HIGHMEM, GFP_DMA, GFP_MOVABLE and GFP_HARDWALL. But,
nolock allocation is rather special, so be conservative to try and
ensure we have a chance to think carefully before nontrivial new
usecases arise.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Link: https://lore.kernel.org/linux-mm/ajS96fWbG4dzP3u3@casper.infradead.org/
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8d409d075e3e9..9cb3f1665b41b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5355,7 +5355,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 		return NULL;
 
 	if (alloc_flags & ALLOC_NOLOCK) {
-		VM_WARN_ON_ONCE(gfp & ~__GFP_ACCOUNT);
+		/* Certain other flags could be supported later if needed. */
+		VM_WARN_ON_ONCE(gfp & ~(__GFP_ACCOUNT | gfp_nolock));
 		if (!alloc_trylock_allowed())
 			return NULL;
 		gfp |= gfp_nolock;

-- 
2.54.0


