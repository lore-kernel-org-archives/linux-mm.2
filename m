Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABF51C55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 05:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98B436B0095; Thu,  6 Aug 2026 01:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914556B0099; Thu,  6 Aug 2026 01:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B54C6B0098; Thu,  6 Aug 2026 01:38:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 56AB36B0095
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:38:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D44F012046B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:38:00 +0000 (UTC)
X-FDA: 85069738320.18.0374238
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4009E180008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:37:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Id1rU/o4";
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785994679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Gxrj0U0TiP8+yU9iwhzCoyYc5aalHZiiyVeTT4WwA0=;
	b=FN5hp2MwOi+M+KOBE3hnKLRXUptYv5j2gTeD8jyu1CN3C1nxxyJO0jqfuXwXur3pPPVgT2
	O3EKBxHdXJ6XZVRVyhYjA+LUt1Lh9/kDj1lMGLDVvQHg0DJrci5dviO0OW2hIaoex8M26i
	W7nEQPQHfBaB8wKfrW2+OR9p3UzB8MU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785994679;
	b=nEAHNS3sujTXJGPMyoHvkO2OFS4snCinAj4fAANH40nbhJvvUz0A5WaES6zESjc0gmYT5i
	uLj0OZs+JTuzyHcMPmrB6I8lKMRLZ8EBWnQ8knh6JY3CLK+AgJHgPp2nRj1EWKQOIH+4ux
	doXm2ogw9hlV9HrwwM6xI3vgp6IBA+s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Id1rU/o4";
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C33960A80;
	Thu,  6 Aug 2026 05:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34F51F00A3A;
	Thu,  6 Aug 2026 05:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785994677;
	bh=6Gxrj0U0TiP8+yU9iwhzCoyYc5aalHZiiyVeTT4WwA0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Id1rU/o4OORX759+s/IAHVgSW5PB7oL26k+YKFn/QIrF8O5ODpOgA0v8vE6jM+OP7
	 Q5raRFFky+UP4ULxfIrkcN53XLAzQsJZVUJgUA4tvPzRSULicHsOsJpNvRQXHI1+gh
	 V96PnOEKxKE7hDtibe7cWoWtzFxtTu547ND80cN4ZyaSwKa13/3et+7grxDLRLClS5
	 Jbtv3z26OU0lUvCNaFtu78B0kupWrzf/TPoBmqpWnzAC+F2fYyY1xrDieWwHX1W9cO
	 WZoShgibgPBVUG7YD0LuE57Fq5a/skxzh+yhwhOaC8WMiCaeVfkNjjIXubUgsUiW9m
	 F29+ecolWKpdw==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Thu, 06 Aug 2026 05:37:41 +0000
Subject: [PATCH 6.12.y 1/2] lib/alloc_tag: introduce
 mem_alloc_profiling_permanently_disabled()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-kmalloc-no-objext-for-6-12-y-v1-1-036dfc3273fc@kernel.org>
References: <20260806-kmalloc-no-objext-for-6-12-y-v1-0-036dfc3273fc@kernel.org>
In-Reply-To: <20260806-kmalloc-no-objext-for-6-12-y-v1-0-036dfc3273fc@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry@kernel.org>, 
 Kees Cook <kees@kernel.org>, Danielle Costantino <dcostantino@meta.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Hao Ge <hao.ge@linux.dev>, 
 Hao Li <hao.li@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 "Liam R . Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4009E180008
X-Stat-Signature: fyyfis71rtrecjdhtwernaquediru67j
X-Rspam-User: 
X-HE-Tag: 1785994679-789423
X-HE-Meta: U2FsdGVkX1+1d3T4sGvaJ7Xyer/Xxu+Vpfo88UFLNllcUm1714g9KKmFilnkulOt7YoMxneVNaiwC0RLQDjUjDKijGL40m0rIdvfRw1NqPM8PdJ8g4XHxHiUMylfCZu23+Vd8EjB6ZgtOXs6/cA3tARylzYEjqpPra2L00AN7yswbFMM0vC2IU8ppigdYfXWEjQwcRztSVLEzu8TFjD2/+TnIOdvTxon9pgKe5s+HrioouVI2ENSWlbwX+74kP3DaiBgVw0x8mpRI7ZU+R1XgIoq52ERZkyZy1UToIZ+B8TzGIc9qNrA1xsM95Ydi/68GD8nRKo3ybnKmVTWM1cJE/sSNNsgiL89Vk7D6ESX3cZjxPv12k0pMV/89oA8Q9QXzYyq1j1ErbnQxx5+Imm6c6lWF8f1Y9wfFyOsmcy4oVGTx6/NtuMTiMJrk+748sIv5tNafXBAxxck84eAYRmD+EjTxjyA5ryYMWSPXHuxSufyGTrY2ZVsmtgbdPgzwbImgQGCsPom66nUDCcUP0MD7GaghEgBJogduNx3LBtuF4VJAq4HoOx+Gy/d7GuHFMhFo5l9YQhDMI2WuVAv/y8EXWtpAA8ut3uRJ983FHWRfB7o+GgMbXUeHuL/CqM1j3vBJdnYORXqQkQl5CNiS9i8eaW6j9aQf02WDC9G5c14X3pOSe7540yfOR4DPDtxUEAxAb+Z8vHpwHou0MszTlqfKCcfXH7jyzyji6w0/HXFd5fzl5avAVFPzJSRGqtabg7I8z40lsnizkZZHzAJolqvfSnE479LZy4iJTxxT6lRkdSI4z5QrjnHg5oH3oPnVx/IANnMGQaN2iRSSAi3Ftj5CXKSMc0e0jGCE2EdA5E44k+emAectYLHe7tfiwTy7R6eu0yw/AXQHZuvNRA522pm9wNVYWy4P29XfhsdnHZriTyZdfY1TOp89hCaaoN7Md2//1XLIFvI+TgAovGu5/i
 I09EVdyf
 My4Pq4zBAEeDxA/ePHY9QhIQom2iyndk7XcG1ViRha37rJzGBxi4fz0Ikh9ybI26qQEFJ/5GEiCEqM4V7lfi+KSSNN6pJbjnXmBhEXPuzAPHJ0VwOY8D/iPaEfvcy+j1b/6Lm9bmWLX4RHrvVv6ApaVn/NC7q/shSmrfUOgFSG+5ZunUBsYqKZXRw1RDPQydlQcu/cQz8zH+CoXRFybZLFhZ9FnTmQCveJ0QC+Oll/+K4r/LsaAJvi/iHQ0mX0PU4qpZvK7V5H4uelzCvQj01ylCYx9jDQIkzqDh+YfNHLQVUeFmgjp/I3A6vbKNd2Yeqeh7fgKQaAOlMJsIvpoT4R8YFXSpv5Tkd0KsK9/PWzOhIXOLk0tIkpkZoc3GEEZCINUHnY0uQgUIqQBE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit a37b0066a10aabf3c968b4566706fb866eaf9a85 upstream.

mem_alloc_profiling_enabled() tells whether memalloc profiling is
currently enabled. However, even when this function returns false,
it can be enabled later.

However, this is not enough. Some optimizations can be applied only when
memalloc profiling is permanently disabled. For example, to skip the
creation of KMALLOC_NO_OBJ_EXT caches at boot time, mem_profiling must
be set to "never", "0" w/ debugging on, or have been shutdown so that
it can no longer be enabled.

Introduce mem_alloc_profiling_permanently_disabled() for this purpose.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Link: https://patch.msgid.link/20260713-kmalloc-no-objext-v3-3-47c7bd138de7@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
[ harry@kernel.org: Move the definition of
  mem_alloc_profiling_permanently_disabled() after
  mem_profiling_support.

  Unlike 6.18 and later kernels, mem_profiling_support is marked
  __init and gets freed after boot. Since the function is needed
  only when creating kmalloc caches, mark it __init as well. ]
Signed-off-by: Harry Yoo <harry@kernel.org>
---
 include/linux/alloc_tag.h | 3 +++
 lib/alloc_tag.c           | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 6073a8f13c41..70025f8e2499 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -105,6 +105,8 @@ static inline bool mem_alloc_profiling_enabled(void)
 				   &mem_alloc_profiling_key);
 }
 
+bool __init mem_alloc_profiling_permanently_disabled(void);
+
 static inline struct alloc_tag_counters alloc_tag_read(struct alloc_tag *tag)
 {
 	struct alloc_tag_counters v = { 0, 0 };
@@ -198,6 +200,7 @@ static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
 
 #define DEFINE_ALLOC_TAG(_alloc_tag)
 static inline bool mem_alloc_profiling_enabled(void) { return false; }
+static inline bool mem_alloc_profiling_permanently_disabled(void) { return true; }
 static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
 				 size_t bytes) {}
 static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index e76c40bf29d0..a0d11582029e 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -183,6 +183,15 @@ static bool mem_profiling_support __meminitdata = true;
 static bool mem_profiling_support __meminitdata;
 #endif
 
+/*
+ * Memory allocation profiling is permanently disabled and cannot be enabled.
+ * Must be called after setup_early_mem_profiling().
+ */
+bool __init mem_alloc_profiling_permanently_disabled(void)
+{
+	return !mem_profiling_support;
+}
+
 static int __init setup_early_mem_profiling(char *str)
 {
 	bool enable;

-- 
2.53.0


