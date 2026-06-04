Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E5BDCD6E55
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 02:38:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 872DC6B008C; Wed,  3 Jun 2026 22:38:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822C46B0092; Wed,  3 Jun 2026 22:38:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739026B0093; Wed,  3 Jun 2026 22:38:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 656396B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:38:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2BF03A059D
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:38:51 +0000 (UTC)
X-FDA: 84840672462.05.7201476
Received: from mail-pj1-f67.google.com (mail-pj1-f67.google.com [209.85.216.67])
	by imf02.hostedemail.com (Postfix) with ESMTP id 672588000D
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:38:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="P1R/FhOK";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.67 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780540729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=903p+XYNW6RRuBbLdT64GGYbi0Y3SIaWw22qBNVgp0Y=;
	b=yFs0ie1iIVOWliBAxnFYGhcAcpP5vUkY1KlwbY0kLJf6CHAnuRXPsAzAc+QAGZPIUb/IKB
	QMumfQArtq/1KhFWPF9MdEjOw3Xcy85TO6nf00f+Y2wUPTbfdOJoU6Q+l24Z11nhV4JWW5
	ejZLHHKBUOLr+hsU+JABD30KtTSZeqQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="P1R/FhOK";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.67 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780540729;
	b=1c6LoE7hic+w7mN8iF8m0Qv7FA9G6wrvV6jrRuZTghVgfBzhxcsIknW5curnX1MufuRHNn
	S0n4399/tf8zDNqyrgQgLpyaOSZnSzQFGUQyOtuASLNV5XQfLq3AlmCk2v5vB43h/MTJq1
	6DpCeWXfJFMM8IEuGqoknOVyPaKMJGY=
Received: by mail-pj1-f67.google.com with SMTP id 98e67ed59e1d1-36ad15213fbso133793a91.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 19:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780540728; x=1781145528; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=903p+XYNW6RRuBbLdT64GGYbi0Y3SIaWw22qBNVgp0Y=;
        b=P1R/FhOKtFygnkXGotSg9kL+uUCBi/gUDo9yURSJF7rDGnC5mA98xSmMC+Ighnpy1L
         pmb/ibkYkIR8NiaNHD5A/B8eRdiNfBuZxpVpmTOCwwKk+ri8kM5K5kZrPBQRJFm5QHuc
         1mKtmub8UfWb8EvQO3wU2jtfrXiPrWbY9OD+OQN6h+09wTFZzeiJXH+O77SaGie5mmj5
         C4iy61mSBVVFO4UUKi4M8cfX8je/YvGCDKp7+5F5uYjv9fCmiF1RB1M3axkOq1DK+qBZ
         Nn0yzqsfF7iRlhMnUfnaZRdxqDpcOAwwjg8RrnkNg1xsKfwjdOtzqmdJt0xAYByFjdYO
         JuCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780540728; x=1781145528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=903p+XYNW6RRuBbLdT64GGYbi0Y3SIaWw22qBNVgp0Y=;
        b=ND3rgubwMk3nEq27s/SlJPVQ8O4Li5ChskupI7U+xKY+vj72pnV8yD1iGixpmM4+je
         BDJsTWCwKnQp8Z8Gz0W2F+81a8Fd3jouzf1ljQTX++1qCWnWGdlNaa9fC/0O4W1NS08j
         nY3j/iWqNqHxlAR/ZQoSyScPBvbFfOeRHD6qSnd2CrD2pBjpTzE9vIAWdvUUC2eMtxs0
         mnF4m90YAZVmYSyhZixuc9jvYOT0suAmwrYR9J1XDB9t5areFLOGc28dUmurzz0EBell
         lFkJGnPF9MMTvs9AnwbU+ZZ2uMq+HDKpbPyA9lRWJzIJhyCBXquBYwIKQNisflku/g8W
         JDug==
X-Gm-Message-State: AOJu0YzepsvVuUVjDJ6hCDpB/Eu6QlBsMaFW6BOr6QCpmR+VkRur+aq/
	KYFUxqMJXgQr9kW7jt1DEvKLdCa7s0n/+ZVb6tcl46JduN7LtP1F0dBV8Y7GaLwyHp2NSw==
X-Gm-Gg: Acq92OGTkswl7ambe3aAvv4QeTBsX0nAA0ZHdYQ8tjY40rhYMMTaVkAzCoLAe2MMVSo
	zum3XM/3s2MqOSz+raQ+GkgSbC9U2OJEJ4eRRazq+i86aFos5bPcjOcTLGsXg3Hj16GZZL1ysK+
	wirV2Ew38UFPP5UuN0eFPJ6SOhG63/+4Eyo465MiRhB1Rr2j/36shcebDoMzfTgGvv6CSt7K9BF
	XgphfbgpFZqACRNHkB3r61wEUATvopDhM1kemBMHb323tC+CDiWBBAt9UwKoCzW9CRKNqH0Ku1x
	BEffE4wAD9lnlDkHqR1B8M3nHurwDpZFbgf7PZyFN77zeBE1JnAY/ZKOFny6KA5p/lG78uExFbQ
	bUMZmuCpoTz7OmUWQQ1lGQ9w92/X2QKQBMkaEsHrOOZH7JfON52idOVM2p6oZWA08vgiQayj7LS
	bnNpOFlYn0oFWLdkSl9rERXy1u9BQkpslw521JGXFq/ZzDBhg=
X-Received: by 2002:a17:90b:2b86:b0:36b:aed6:235a with SMTP id 98e67ed59e1d1-36e33106b26mr5951841a91.22.1780540728330;
        Wed, 03 Jun 2026 19:38:48 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6dba8573sm1253072a91.14.2026.06.03.19.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 19:38:47 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	Alexander.Krabler@kuka.com
Subject: [RFC PATCH 2/3] mm/compaction: add per-folio isolation tracepoint
Date: Thu,  4 Jun 2026 10:38:11 +0800
Message-ID: <20260604023812.3700316-3-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260604023812.3700316-1-chenwandun1@gmail.com>
References: <20260604023812.3700316-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 672588000D
X-Stat-Signature: bh3m4yse8odx76ufz46n9s4jhmd5qtyo
X-Rspam-User: 
X-HE-Tag: 1780540729-122274
X-HE-Meta: U2FsdGVkX18E1DJDOiHUSwaZkyjfSmHzUqTlsg16v56aGKbKU2q3UvzDvvE5E/eqFe9oMBLsqlBEQKvXw6oQrIH4iroPgCGe3f+03906pxWd1K7S7z9o8npZTAfmYuXHnoTz65foKHrYgG59zHeGBJ99yNFUs9yTd7gggYuf5Gfo2iJdjw2AmEJ9hrHxbQlNVADCjpW+UzSn3eJr9km0uTlxo2XvU+RxKBNujLIi9PjCSpCdJAv86rLgriyPkqqtCsFWPckCGBm8dunriM+Glo/HCT+Rzuyz5aeD+kqq6JzpIxD18fWWMfLOjIj9BkwCCOFeDy52B8XUrG2PP7cWHcEUcLcQlJ7JhcemdJvJ2D8OzyJaIGjG9pQmj8t8EZLOVudnhFmaP7FqTjJ1W5nw6S6ywRT5c4JSyJqFF4UyacP/k6l3zA99zSJgQSFHW3VgSUAgRVJQACwKz5EUJ94BQ69t1HVruS0Pgz8ISL2MSc3DblaGvE6uZ4elesopMTMuTWwPQl+4eO0U2OJP5L3lozE81Gmk2KEcTFt+xq3JE9Nd7TnNcCdVJBNruHelfDj3+1tXr77XECuE6+aI/1jDxR49THAwN/SttzGE0o8d1lyR022vRM9plSGVKN6RIR6Eld2zKoS21nsvSWW6fJKgCEvOx/GTVqRT4gZFXxQX7E+Jey7XYjFL3map+ZPVUZXwSn6d76VPLCjWR8cbBEkBLdd5QhZd+CsnqFJwUAgfE8Wh8lKZ0fvsW3j5IT3rwVoHCd2pxb6sr+isjIPZ4XkEjAz1afVmIyo0buWX0JIwKNJs2Y9zaIMSsfc6TvdqtcZNWwy/eyw2mEdVvZiyJkYoXI0qLq9HrKd2s6t4PY4ofMfNMe3bE7dYdzGVjGcsgnlIsdBBjbQ6IoCHaKzed/z9NyVbFbpjbqYrDjlnkjswtungqZodQTwODC909/xi366xAKMorF8Mz5mBfJl4fdU
 zkPCVs3v
 FslZhfSQaMYbI2osS6dX+Jar8Jmj5UsAaQjWHE1W9VyMRvYrkEc2W+YUGp14BpMwU5uvwfM0gLUCXcswIFFo9aGxeh7CaygaOpEuFUZHscaIALNavXvPMv8Xpi4TPnuWP+Yam0PelbHeSPMbpB/nBT/GzwQGNkwZTiuFV8ncFH8jsSwKTQqUvAnzEVYanA8lSXzpR22AorkBcrwja6wd9GXwMBpY95V0KFJRmrM9nX7pna4tn/TGNj+SNZEQLrLqLPtN4OrwZCBiOtkEcJIEicBLeGrDZe3F3ImfiL8DY2VzpyGpIHw36cxyUhfJqP5kKQORVE5wdr3BXJf6CBg59GRO1SXTpKlSPYjHfdbTdEE65kMpvz5HqOIfHewWGL7jQn0nMnXqgoAyhRGjCPHCg5vJ2lARZggOeB4COR6epgIt4ZWbJf+NwnI9bKp2zocf3YuTR+rZQUJkdjucccm3E6VUycXnsRZv6qFVdLLP2vNZ01oYkPiL2XQnWW5s68v75UB3YwtLoSOg3Zxg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Add a tracepoint that fires once per folio successfully isolated by
isolate_migratepages_block(), recording the pfn, isolation mode and
the folio flags. Knowing these makes it easier to debug unexpected
isolation, such as mlocked or unevictable folios showing up on
PREEMPT_RT kernels [1].

Inspired-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Link: https://lore.kernel.org/all/20250820142919.HTybedrl@linutronix.de/ [1]
---
 include/trace/events/compaction.h | 26 ++++++++++++++++++++++++++
 mm/compaction.c                   |  2 ++
 2 files changed, 28 insertions(+)

diff --git a/include/trace/events/compaction.h b/include/trace/events/compaction.h
index d05759d18538..8b8b3ec0f324 100644
--- a/include/trace/events/compaction.h
+++ b/include/trace/events/compaction.h
@@ -76,6 +76,32 @@ DEFINE_EVENT(mm_compaction_isolate_template, mm_compaction_fast_isolate_freepage
 );
 
 #ifdef CONFIG_COMPACTION
+TRACE_EVENT(mm_compaction_isolate_folio,
+
+	TP_PROTO(unsigned long pfn,
+		isolate_mode_t mode,
+		unsigned long flags),
+
+	TP_ARGS(pfn, mode, flags),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pfn)
+		__field(isolate_mode_t, mode)
+		__field(unsigned long, flags)
+	),
+
+	TP_fast_assign(
+		__entry->pfn = pfn;
+		__entry->mode = mode;
+		__entry->flags = flags;
+	),
+
+	TP_printk("pfn=0x%lx mode=0x%x flags=%s",
+		__entry->pfn,
+		__entry->mode,
+		show_page_flags(__entry->flags & PAGEFLAGS_MASK))
+);
+
 TRACE_EVENT(mm_compaction_migratepages,
 
 	TP_PROTO(unsigned int nr_migratepages,
diff --git a/mm/compaction.c b/mm/compaction.c
index 7e07b792bcb5..007d5e00a8ae 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1223,6 +1223,8 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 isolate_success:
 		list_add(&folio->lru, &cc->migratepages);
 isolate_success_no_list:
+		trace_mm_compaction_isolate_folio(folio_pfn(folio), mode,
+						  folio->flags.f);
 		cc->nr_migratepages += folio_nr_pages(folio);
 		nr_isolated += folio_nr_pages(folio);
 		nr_scanned += folio_nr_pages(folio) - 1;
-- 
2.43.0


