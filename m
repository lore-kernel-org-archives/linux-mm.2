Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D903CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 962B66B0095; Mon, 22 Jun 2026 06:01:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93ADC6B0096; Mon, 22 Jun 2026 06:01:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DAD06B0098; Mon, 22 Jun 2026 06:01:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EEDE6B0095
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:01:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB684166F4C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:49 +0000 (UTC)
X-FDA: 84907107138.28.B6397E1
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf11.hostedemail.com (Postfix) with ESMTP id D23404000B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HPVeNsj3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3Cgg5aggKCFc8z19BzC05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Cgg5aggKCFc8z19BzC05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782122507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmHe0ClpKecy9d0Nv0FMY1kBXtGrgiG+qiOUOhwXnXI=;
	b=rpkawDauOASc+KD6dxM/+SRuooQircowapVhmEJ+yAhzICRvuSAgvhsTGs4bs6W1HPPQIq
	nXQzWtcF08aGedMdYwzJ4So17EX/YjnTkPJLUmv94ut/TKLcgIR1TBpdkdHdx2p+2UfLu6
	nbZYgM9pCMHR3xHNLcXk0FVcJdqu7Eg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HPVeNsj3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3Cgg5aggKCFc8z19BzC05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Cgg5aggKCFc8z19BzC05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782122507;
	b=GGnHo4sU4VY2eDAqgRNY8/PNSWA7gCNUB1S92fVuMo/JkRmtXZMuKQcf0e1n+iNqnxi0n6
	pfwa0jn1pMyFuSil+Ngb6PtvGND1G+4eY9U+5ZSFfT2em0DvAPAyXs1MBegwuUvy7VgAqg
	GUJpYICEAHkgiF8Af7ySaUrlo5pbqh8=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490c56e2576so33159995e9.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782122506; x=1782727306; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KmHe0ClpKecy9d0Nv0FMY1kBXtGrgiG+qiOUOhwXnXI=;
        b=HPVeNsj3EI07OAnMoIH7U7h110kGlzgXnmwYGyp+MIeMSrmqVw/zcTDpRfUPybzoUt
         oC6e9MOMY2Dw2/QMY6tRsPmBFjhwMTHZzex9zTUGmM4xTZcjy3zRNr84vakzS0/NAaiI
         M+k61ecW9UpTmWNIA3rdOSVg15au5hGc+pgFILbQQafI6kc72bKel6KN09UqxzebIc5U
         CdSph2GM0wn1b+iTDE/AgRdBS7UgGlok8U3CXJRshiOHr8+s64LDwi2pfrEyL6EF+6o+
         gWUAQ/man7lv/JSdehKc2565pUCoGHWbWI0COmpvtKD9/2454etbdjtpK1ySg10bAoq9
         jUYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782122506; x=1782727306;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KmHe0ClpKecy9d0Nv0FMY1kBXtGrgiG+qiOUOhwXnXI=;
        b=X34j2fz50jfy9fqQoAY69CEVdCcqwdUXMUqu/TN2x8QHNhMlBHy6XfGcVQkT1nzBaV
         FrUOt7NY7XBgMR4LrGefIf6Qo7KnzPCgzePMxJahKDjcpa7c92G9eGp9c+FzWpCwRxFb
         C8AnnAVskYQrwK3hU5qmLRkCuSskcy5iv6laZBXzIe2B6XB/CzRj0C6O5GDQFzLTe756
         drGD62eOWXBFPAyfKoGDwpUVbFKLZumphVtoo2AglMiXGKJW4uTLiRVxZftNKsLbFwVu
         nCHUJSKBI7mKclLdLFJJlZhYh+t+q3WcTSq/6Z7XyVBJZYSJ3csz4MrSdHWFEAcw4bWy
         zQpQ==
X-Forwarded-Encrypted: i=1; AFNElJ+1F/Bj46uBSRwrgHFtnd31kvTzeDKGsyAsWO1drMZXnh6YQ+L8MABF5wVg+cM57o/9ElTUvZX2rA==@kvack.org
X-Gm-Message-State: AOJu0YxhNSbWrqb+JZAT4U5wsT7uq4Yf2uhOhXVqumJYZM3b5zP8m8aS
	xCEsDc/c00u1Tx8gArTtXcp/ZbsYGOqLuZxGYULiGM+nlYyTMGuS38LZLd1lSmiFmpGhvpuZS4R
	OVL/YzRfkXks1Ag==
X-Received: from wmsk10.prod.google.com ([2002:a05:600d:848a:b0:488:a71c:cf48])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:101:b0:492:4050:d495 with SMTP id 5b1f17b1804b1-49240ea31famr152824405e9.30.1782122506179;
 Mon, 22 Jun 2026 03:01:46 -0700 (PDT)
Date: Mon, 22 Jun 2026 10:01:31 +0000
In-Reply-To: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
Mime-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260622-alloc-trylock-v2-4-31f31367d420@google.com>
Subject: [PATCH v2 04/13] mm/page_alloc: relax GFP WARN in nolock allocs
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
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: D23404000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ytnczj6uiu6me3yug7x33tdpitfbkbfb
X-HE-Tag: 1782122507-176699
X-HE-Meta: U2FsdGVkX1+ESY11sDR4fBq+40DQtajursyzAQTLf8D0UMAnJetN+7axzQN5G4ILjTlGOg8em86tyAfObt/OzAnSTatQso6skgdBZLnYDoG6yG0vXnGWrsJwFSbGL0Q5Qqmp7DD0ji9jS+KOApuqGaxKRRpb7s2xDFIo8n5ieNIl3ktLHOua/cUiX46S4floCF0pzmZAqfQynVU+DaZtgBuBPHN2DDkNtbUl+i+opuCFZmrbzdPbWieKbyCkZ6uJILRTspJU9gILoOEqoL1bCpRucp5WAgy7VSfEJutxjq49RwjG2RZEchidm1WYnxTcvNRU5G2CkKmPvogdMirjy3ABqEgQSQGUBG69UNDQ8u+ub8g9g8y99eNORro8W7dUhGLx+AQDBHQ02WKSzNgXL4I/5mvfPXT0wshsQ8F0WRNDa98HIduhJe+rX09k8GPpcOYHmxUD0Bj7aiGj0ePOSpwd86H2GE9GKGLspKt0lqkSjYygwu+3+EDEHPIutcKa+A38UoAp/KmrNeYJQoJW0cgFVlhM3N3TjykwlJ1opPnhblU5GYWqBJJrrjV2WDVC+xl/fITmVwVXlyJW3TlYJHPkNggktHZGUMPcpBS7unhPar6DqgaU8jcQDFqQH1Mm4kKHQwBgEiAzIB+xukZ5k3994PbGAEeAK5BChcBxTs9casMXcgCR2p2xpRGocSn6vD4gCZq+KNdD2WGIY5+wqkKP7zfeMUx05ZU/zpeRXlezLQ4G/5SxNdCFg/ErobV2f8LRCHgYD7f/zlog8kmVEglhucehun1xDUlBWAEhqKGwKZ1pzZwca4+GbXKlNxhHKpmCnYZpzVXWO2R9MiGuYbQoyAzL4yDpfLiwQw/R6Gj1COrwYg4iynRp7qNxTXY1YfDQFXYypDRRbTcZ3YNT68q7F8qme96jOR3E8zku8FxqCbp7/KsE5B95wvSw6KIiSvRNnVJE/xUbyembK2m
 Mw+Pmk7b
 G+B9E/mFxhKXrW+ujl8xHIJDj2vfIWrabW8a7ZR7tq32Nf34vpANIFiSeHrP9bj65Nq5HVrJgGz7/quy2YD/54nhAIXEcBpIZFOJs/1KGiLzVHKD0etR1ypjFUgcD+iblMlU4Ibyd5s8zVw5fuBx7UGstK9lkQzmu/qDKSEXiQKeZQ8x7cVK0IUx7PMiozSFURW35qulBqaDZsiSy21Onqa7rR/MRNyTvZZRWWanFFp7J+RhQ9yGS6vDAQbFE+YImdNqmfRs0HMPZiyQD9ywrwfxxYruY6nn4sABsNlcwi4G7NjImik6d/rAm3xgvgmEiKqwTtus81ujHQ1oQ01IR5TxgOPsBhqyg9uxyNzgrSFUQjMDATR26xX4nSICew7VvbY4wShsbVw/1JJbYdsRE+6Vt0OAQEKjFh5yNJU4woLSlb8VnlcQcdOLUPAa87azb+UI+QsKCju539Krzo3+N4tvT3H3ZRWqKbiuv+KczbCVh/Y71Wg4CKnkuoLInlhL8x3uWt0NvFAqjmiHvexXXggYmphPaukLQaKdOlg+ko7VZfRXesLPC2vkXV01KgyhOe62XW0Ht4KOn3HHmDdfO8hFb8sMXC4MPOZQ18KCuy87kaa/vW+d3FZMpSw30sBwwI1tWuBeR7vZANu9bNYif9X3Dcwbuwjl1jzUY9x9LDCx6vNy39NMk48BPNzIDupHtR+/bxs3p9XDCWn2aF6HjNFIPeWSf4Eadn4BlmtHfWwp1CEuBuDy/vD6Jsu2EsLk6trI9sJECak6u5ec=
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
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e31babe2181a1..074e007bf1bc3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5337,7 +5337,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
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


