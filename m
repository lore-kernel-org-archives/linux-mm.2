Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E24B9C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:33:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DD516B00CF; Fri,  3 Jul 2026 08:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28E496B00D0; Fri,  3 Jul 2026 08:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CAC76B00D1; Fri,  3 Jul 2026 08:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECC266B00CF
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7DDD21C35D8
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:45 +0000 (UTC)
X-FDA: 84947404290.28.37D2555
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id D016BC0004
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S2TMIEDd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 36qtHaggKCLkiZbjlZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=36qtHaggKCLkiZbjlZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081963;
	b=26ioBCs+Cv4hjurcXtv66lRVUhtQGNZoTGKWe/WZy1CU5375I6psep0t+yKR/IDU0nGDhb
	X+92LuLzfMY24fZbLuuXNH6cS8cyxdNJ5qriA5JIVH0MYlx3QgTOP1oybtkY1x4clvTLea
	PBizo5oEp+NVb2h3ap8qzVazy5G+bpA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qmGplZPZ08UUT4GJp4VHEL7joXJ434YzWEyzXagN1Q8=;
	b=bbDtXDJXDuECSuXXnQGhbYXzMywcwzOTtuyNxQdqpBaOabDmmt06ApNdipI/qz3YE+t9qz
	mJViLfk8lvx5sP0+iQie3z9IHUhcuPlSrKYSxjBSH9Yai4zrZezn2T1kbbiC3kZfmuYfNA
	ndvL0cXHAbb6R3UAsGL8dpfI9fEZkKw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S2TMIEDd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 36qtHaggKCLkiZbjlZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=36qtHaggKCLkiZbjlZmafnnfkd.bnlkhmtw-lljuZbj.nqf@flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493c20d0468so7263495e9.1
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783081962; x=1783686762; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qmGplZPZ08UUT4GJp4VHEL7joXJ434YzWEyzXagN1Q8=;
        b=S2TMIEDdv3V6c4lsxMxBojE2oSTXSNJhlZ1VZckTATF1EU/nIaYnMQRvyheU6Ztwxn
         zD5757TQJm0sLlXnwDBjVX5LXoj3UkGr+XzMS6rx0dBk5qp+iW0U5yUL8SQS7jDwHnAa
         l2Fa0JjFtr5ns08TGk5NDY0+pJdKM7J8JH2oz1ifGO/o22Ybi7D0nQ5LCuHzAJg+JD4S
         p22apZq5jcCJ2XjzlGZdGueTAgTlirRUCD/x0FJ3azZ1v1DaJRNsmCAC+elRTymNllC4
         wK65zP2uvfwRGS7JB+4ZWr06lhPoRI0Ozdg6bNf34yIrZphOZKL0W5KGcYT16B1ZMsLa
         mafQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081962; x=1783686762;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qmGplZPZ08UUT4GJp4VHEL7joXJ434YzWEyzXagN1Q8=;
        b=KDKXRI3ohif6Ka+im19TSids9RlEDHELzprn+G2bv3QX2qeUON6RE/l+ZUe9oQl255
         3m21ZPoXRQCnHb8O/Y0+/d6bJOZz/9Zk+0CHvf6w/SLrrzSv45Wb9626brFsied/Bujp
         +ta54XSjEVhlw5MmmO0cdne3zV43upasywhyiemFUXjDYmJOk48iRuzcoF/DtnNks0gt
         Lo3xv+uXWA5hXVG2kNGd9T3zYYCutNa8cd6EdD+giClcfu7MZd7jtqbp2a2s4IE3mrUJ
         UpOqrRtZPtBrt2GRUHhI4frvUGKVU5kL7tga/qb0oyPPnCvdOJeLZUyvphdTQQ1t15mS
         7dbw==
X-Forwarded-Encrypted: i=1; AFNElJ9ykrxZ74amw5J4LpdfV5cek9TI/pbZApDazgTc80b3eani3l70V0i8bFJX8ndRmsM13Rq7suCIHA==@kvack.org
X-Gm-Message-State: AOJu0YwT0sCe2wHbOvGo3Je8jWfE8lXXaO0hyFRJDgbAzDlD78pcAvmi
	n87qpO0EoimavtbBeYU8pJBUzKNtDxiFhGUjhHTEw4eWuC3VtweUZbRJOz+Bk7bW0WZb3DI6IBq
	jvo3shppcXkgoVQ==
X-Received: from wmok15.prod.google.com ([2002:a05:600c:478f:b0:493:b78f:716b])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:35d2:b0:493:c3f9:65a2 with SMTP id 5b1f17b1804b1-493c3f9664bmr156103915e9.5.1783081962154;
 Fri, 03 Jul 2026 05:32:42 -0700 (PDT)
Date: Fri, 03 Jul 2026 12:31:58 +0000
In-Reply-To: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
Mime-Version: 1.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260703-alloc-trylock-v5-18-c87b714e19d3@google.com>
Subject: [PATCH v5 18/18] mm: factor out can_spin_trylock()
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
	derkling@google.com, reijiw@google.com, Brendan Jackman <jackmanb@google.com>, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D016BC0004
X-Stat-Signature: 1y43my9nbc93rdn6mz5ycssxnfwxma1o
X-Rspam-User: 
X-HE-Tag: 1783081963-522945
X-HE-Meta: U2FsdGVkX18/VlPFYQO4g/embP1/TUHI8BOvFqsKDAruoEBajt9eyaFvF5N4ccKBJUPfIXIIGs/t/OXPOXykC1de65nzBBD13y5JZ4PsTpyXmq3VBKzz26YTq5mp8qXUuzS+gGtB896gJVvIf1cYIQR58NiyeoezAzx8CHpxy4QLqVVoxEzpKjDu6pf3icLDqOEr0lFWROb9QUPTrE01CbwGsrKkoZIG5Xj29seAcJ13KpQABDbj5i4vqEODaVSfiH/3rcVGrk7gHzadagghOYSFAlM4gx82L1WTvaImjDWgzNDFwSKCL8preq7yB+FEngomFufmFMA1uLxWRe3nKJFpfk7JffmAEFwlgSqIgAu4XM7C0p4fgB+iA/Bhjzyb7PM7NkiKNyYFh7aZEqUTibUZLEBAim1t2MgFGkEbg5QdrYwX3elR6jouMQBEFfeRkg+cwLSZr7jiJj0uxyK9+IT45jpqfuChWAJE6cKv24skUX9H1tmvq/eAzv1qsb7QlwLoQvwnzhFjTEr7A3MMCKsvg3sqFnNTZOhjrGFNQWUHHlXEuh17ks4Qrh0oKz30VbN4+FybYttdFuPmx92Q5DUowztu1bnQqbnMxfHloV1SJmsmTxg3/XrHpsTQ1TL/EJVGSZtJFDd/69ium2SFY+tLomLraDafGq5OyEYN9/GRL1RkiXhorNlmMRuSWCX2Q+VfJP40XkQ2buTjjAF8se4S7wjEshOxawx0YJ9hL6/H9Wi5PcfuEkfvbZwBH0D67cjy/V6HUlNnwxVcEA5oo3oV6tym2poQrkETyKqaYdv/mHdwg9+bZWPMQzEsP8DYwS5Gwcu4RbIhOjKSnzTfakYPdjBEo1e/NRua60E0PS5aE5pRhJm5MKczy3av9qN5hMHmgIdn/naQ/LDehJaWBFVTQfWRsjoIgg2NDlOAk/lIH/1kcY/QewyMXyG6BV7dSi4QgDPRODCsIVs3hHx
 joJg8HWd
 TPcgQexu2w4DISMs59HTIjwgwiqltcmQHKfGjhtXAuiKs4Rk2GJXl5kLxajfi5FcKFBJFoRwDEkwvv4ebFh4pelE/8az4FKIqq/A7EOMabRqVtzsl1wQ0k74Rh4V2Ww54tu9KNCBGWFGusYxjHEnEUoKWgeoKHz6NIpDMHZhWiCfiloACD/cEsahH70Jtbi0Y19Jp+mGz1eyFvdUVe48Opi+P5jljUm9ZKkRH0+UkIgYzXJcOvzcKKiwgvS591ZYRQpPIP/FT0+91vq8bnb1qE42UNz1rfEjy7x8iGZaZe/wteQ63hmvNi9uC7c1cRI0ZpUh0BLUaZkFbrrFZnAFghbyp0NlEdEOlp8mPE6SHAg81ZhFlzZhA3JbCbnKuq3gjb2w9aU/VhrX2UL5DBuKykFJjtIYVA9OTvZFLnCiUXaMVUnhrBW6A6HvUaZP5Ivrmlnqi6+MgsPmEg8sXoGHx8Tqxl0ntBiuN+kWumnqULh1qL4f+Rt4k3T6T/NgWpKaQlxZEeMBxufvfdnzVXEgG0PKv1CTwnae8vR+DxscDzXl+tGvumGQs0b6Uo+3T7w2ZKRr34O5INB8Kvaoba5z0eoQoS4mcMIf2Svyd1NHhslMMh4zUoQvTCDKOmR40mG2XaVKC0jwZBIVdfXJeW/MiFirHsg45hFUv6KALCf0Xek0w9hD6+96XQfuNHrhevsyckQFPs+VWgGFgRM0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Deduplicate checks for whether the current context is safe for
spin_trylock().

Does this function really belong in mm/internal.h or is it generic? Not
sure. If someone ends up duplicating this logic elsewhere in the kernel,
that would be a shame. But if it goes in some generic header, someone
treats it as documentation about where it's guaranteed safe to
spin_trylock(), and then it emerges that there are other subtle
preconditions that didn't affect the mm usecase, that would be worse.
So, just be conservative and keep it local.

Suggested-by: Harry Yoo <harry@kernel.org>
Link: https://lore.kernel.org/all/397859cb-b127-4cc6-9c71-044afc99bf0c@kernel.org/
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/internal.h   | 23 +++++++++++++++++++++++
 mm/page_alloc.c | 17 +----------------
 mm/slub.c       | 10 +---------
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 7e3b2386e274b..0ae6ad2265125 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1716,4 +1716,27 @@ static inline void mm_prepare_for_swap_entries(struct mm_struct *mm)
 	}
 }
 
+static inline bool can_spin_trylock(void)
+{
+	/*
+	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
+	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
+	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() will
+	 * mark the task as the owner of another rt_spin_lock which will
+	 * confuse PI logic, so return immediately if called from hard IRQ or
+	 * NMI.
+	 *
+	 * Note, irqs_disabled() case is ok. spin_trylock() can be called
+	 * from raw_spin_lock_irqsave region.
+	 */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
+		return false;
+
+	/* On UP, spin_trylock() always succeeds even when it is locked */
+	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+		return false;
+
+	return true;
+}
+
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c3b246e67ed14..a63733dac659e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5291,22 +5291,7 @@ static inline bool alloc_order_allowed(gfp_t gfp, unsigned int order,
 
 static inline bool alloc_nolock_allowed(void)
 {
-	/*
-	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
-	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
-	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() will
-	 * mark the task as the owner of another rt_spin_lock which will
-	 * confuse PI logic, so return immediately if called from hard IRQ or
-	 * NMI.
-	 *
-	 * Note, irqs_disabled() case is ok. This function can be called
-	 * from raw_spin_lock_irqsave region.
-	 */
-	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
-		return false;
-
-	/* On UP, spin_trylock() always succeeds even when it is locked */
-	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+	if (!can_spin_trylock())
 		return false;
 
 	/* Bailout, since _deferred_grow_zone() needs to take a lock */
diff --git a/mm/slub.c b/mm/slub.c
index 3989b4758ae0a..b19dc46de73c5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5408,15 +5408,7 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
 	if (unlikely(!size))
 		return ZERO_SIZE_PTR;
 
-	/*
-	 * See the comment for the same check in
-	 * alloc_frozen_pages_nolock_noprof()
-	 */
-	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
-		return NULL;
-
-	/* On UP, spin_trylock() always succeeds even when it is locked */
-	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+	if (!can_spin_trylock())
 		return NULL;
 
 retry:

-- 
2.54.0


