Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78B8FC4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CC6D6B0092; Mon, 20 Jul 2026 10:16:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A49A6B0093; Mon, 20 Jul 2026 10:16:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1926B0095; Mon, 20 Jul 2026 10:16:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68E6A6B0092
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:16:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A2271C012D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:16:37 +0000 (UTC)
X-FDA: 85009355634.22.6DD88DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id A0E07C0011
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:16:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UVbvJRN9;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784556995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UPQckxndCEJ7gON+eXBCmL7lkfNrS7vyJZGPPaJdfGA=;
	b=X4agbkQwqbxqinJEV02fsTCSVtLNehNCXKwFmZ9E7YswRVaT4QSnjMyKZYOurNv0MBS+I3
	H4GCmY4/C0fLflIp+h3OdV0dxb4rHemnFwvL9rw9kB7+n8cIaoTba4+/FcmsOs5V32rSHS
	mHp6lBk5pNOr+bvrR85jF1BZYmdf3x8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UVbvJRN9;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784556995;
	b=0nLo3nmVuP8l8w5v+EXlV3ANmJJkjbyAbjZPrDeMf5eBd4VcSxow+BHHEUZYLnZievUkPU
	yCn37r0GbZCcL5UFuWm/DUIN1zCO9feHbZvYW9xaSfi2ErdlIqsqA//YrLhNPaZldj50lE
	TXnCThQk7VWDOhG/41XfzyhkYm6uM4Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D36260A60;
	Mon, 20 Jul 2026 14:16:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509CB1F000E9;
	Mon, 20 Jul 2026 14:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784556994;
	bh=UPQckxndCEJ7gON+eXBCmL7lkfNrS7vyJZGPPaJdfGA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UVbvJRN9/886lD9oa0A2+WveR2vmD3E/+I7suSHl/DV4hQsc6R14wqnSnmUXna/XP
	 g4+9TLjdZkn0KgzM3fJk4FOFQYSzTCvLZ2g3HRl/XRsTPUNv26iNFsYwdAstYntqsW
	 PtkYejuJ/aC86tPbd3vYKnUl1TjnWaBbjn2FP+6v1i6yOCYWzMcFzpRw20by+R60CT
	 6uQGdpGO72JeOTRBAPYtmXobECi96RNQPviEKAYUYAZr/hdjmT9NRWOxTR+18lz63+
	 y2vZJdk/9DPTUN3G/CsCRA8V/4/0YYSfsb50D1VeODZQuyOmaa7q88kSHZxXU4tBhC
	 bggomyliIG0bA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:16 +0200
Subject: [PATCH v2 02/13] mm/slub: skip handle_failed_objexts_alloc() with
 profiling disabled
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-objext_split-v2-2-2fa7c6f60dbe@kernel.org>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: A0E07C0011
X-Rspam-User: 
X-Stat-Signature: fmw49ksjn1titdn8cwy4yb1qjryibzsx
X-Rspamd-Server: rspam04
X-HE-Tag: 1784556995-658666
X-HE-Meta: U2FsdGVkX1+0Kz3qrVivRXzLaI2jQ65t0zMjvExVZyB9ZpxkQqVHbQq8KabALW5GdqojBgxUnQNu6oTX4O6cjQKLbgX8lhz5c3IMum/Yksv6PHPlBKX48LVPq3qb7V0ND7r4Xzntc8hrwZeh3rA2lY0DTMYEQSXarwgdn4M6VQJlYvDc1wkIq3pc5GaoNonZNL8OC+1L4xUK+dj0MFCNz5s46Dhe92syrTI2JzNEpKr07T7oYluF+p121zUSrWcRgrNhsJys1bHklouj/uZbMAqrBwsJrP5FrzMZ8BpAlUywOEl8G0Z9LpMDzByedjIOW965XZ00aiE+ECVNPo9xBIqOPByCg6meb9wjzdCyANnhSMiG/u0PgV5LBbEoIwYzuWd8bCT4oXATUs+KmSj2DinvtoRF6KZxhEfdQ/mxPUtxdR/4UQ1IqpB4qeuaLjdCX6Cpd9ryNy8SkjS2TaboVvClg9Kj8ZoF8PNo91cAtTw5HXJsCiH3cUEEvxHJGRofCdWnbr6x92/b1QQ0QxUxPMKwu55aygEesCbyqJ/LLc42nhOY/NB9EdO3CVcn2GX1QDUbOPUt9vHG4d8k9IzDkUn6kGPUp/S9dYii41llUWm0IUj58q5gLin8lt6N0+GVK1zMop0o+HLgri3mZ/KvNkX9ZIQ4QzVWq7dMmrIJAcm2IOKP+Xyt7KakKhovKu4rzIcGOvHxXMnt6BW60HE8WsAma8A397fuNnk+9B5WPh4UBq36e+0+ibupWcp91M0rDKJFt18XnYuVss6t+zzAUMScKOY/oRqWAmHpnZDalh/t9r2uLSBsw6Ve64fQsWS+J2gOi33RDTZBVoKf13or+5X5r9+XqIUDhtWMauYNhIUbVhSD7k1uUG+amPmTjbScln1IyWO96PX9VrAjwWPsFNmCVt9/qSZPPAlAXG/NR2RDhPDLmqJNqQsvnMb4nRcJ2wRK/33z7cuoz/yeDbA
 nehSZtzK
 AE7MfMZqWWHXaWN9y8MJllZJMZHHf7/yJMGv06ODQHle3pXS2unyiyMWdPefVY5ySP+5AJPs7Qq4ChSpnhidB16FFVV2Zu6msLr+QTKjz6OWGuDZhFCTfRRfizUULPozIcSmpy2fLFEHC8xDj3q8c31DDyqapvHrxAHsMm8ZMyOWMeSOHAf4XNmtcm9urY/AZKQG9tWA8TU03jsRtJoEPvs28Z1TnBygosFv/uIxQ2wVrO26wogoh4RK7p/EngfqifCoQZ3tp3K9epApH5LNdI1nFCxluj0dJqw+RjRj56KR3LoWdaPeL1FHgd5EGHSa2d+U7CvdzcVZcrPcTn5LsPonDIFW+QGukh+w/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function might get called with memory allocation profiling disabled,
when the obj_ext array is allocated for objcg pointers only. The
handling is however unnecessary in that case, so skip it.

This would otherwise become a real bug later, as pointed out by sashiko.
For now it's just an optimization.

Link: https://sashiko.dev/#/patchset/20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org?part=10
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 76acb78f2655..95fa6fbad11a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2101,15 +2101,16 @@ static inline bool mark_failed_objexts_alloc(struct slab *slab)
 static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
 			struct slabobj_ext *vec, unsigned int objects)
 {
+	if (!mem_alloc_profiling_enabled())
+		return;
+
 	/*
 	 * If vector previously failed to allocate then we have live
 	 * objects with no tag reference. Mark all references in this
 	 * vector as empty to avoid warnings later on.
 	 */
 	if (obj_exts == OBJEXTS_ALLOC_FAIL) {
-		unsigned int i;
-
-		for (i = 0; i < objects; i++)
+		for (unsigned int i = 0; i < objects; i++)
 			set_codetag_empty(&vec[i].ref);
 	}
 }

-- 
2.55.0


