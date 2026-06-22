Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4151FCDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:02:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E92F6B009E; Mon, 22 Jun 2026 06:02:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BE626B009F; Mon, 22 Jun 2026 06:02:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061416B00A0; Mon, 22 Jun 2026 06:02:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B23576B009E
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:01:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21BD41C27D4
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:59 +0000 (UTC)
X-FDA: 84907107558.08.7A2406B
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id 33EFD10000C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XLvIZjgL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3Ewg5aggKCGAH8AIK8L9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Ewg5aggKCGAH8AIK8L9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782122517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FrPB48FwcDezsnLpR3fJd40Qt1udKU6vCDBpIqP+Xw=;
	b=lNUGdF7sXf2dDZytAMOAIJeDeROWBxbWlZcus3aIKT3hq+JrxvjlBIkXAIf3SKGhBUKxUc
	PpLBlrJ977oxaI66CcvMVFUJLjwfUq5ryPjeAnCuFu2JTPwFHBIJL7A1c72TlNabKPEmjU
	EzkoroHaN7xLrQtuT/L91C8F3vdp1d0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XLvIZjgL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3Ewg5aggKCGAH8AIK8L9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Ewg5aggKCGAH8AIK8L9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782122517;
	b=svwasv9CJlyaYu5nrHfYhJBl2CZxbtmhjbMoU6gEekjo/gi49M4JekDon+wxh16Sletgf7
	xGWOYCudQaiMTRF2BUPzGVuR/ewqLguJuWE4rWvpR3j8+eUovR0SDKgguBoHGlV0L4DqWz
	iG5UeYMVquOAOlrM4uI7xDbLwGXHnec=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-49244130073so15452755e9.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782122516; x=1782727316; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9FrPB48FwcDezsnLpR3fJd40Qt1udKU6vCDBpIqP+Xw=;
        b=XLvIZjgLgFW4id3/68j6IM7RDLWiyplGyXnX+7JyjMHNYAonTU++Qvgg9Fg1paCefz
         NqFb8ivUTiUeh9gpMY+pPzTwEH6jS2mTqLVj1MxEDnHmjAncVrber3+kRFP/L29ENa10
         LvTG2HWyXxHrFoEkhr6mmoVk9pKx95UUED0numKjn1Rqf36m4Dpt0SJJVVEB6or56D+D
         wkL5aKquyytmiisLq8MtgrXsdUWbzDqSoSIL/MjWXv3DwvahNpmrR0BxHfDNGtBysOhe
         Ctro+FmUO7XE0enVPg4ocZNMGgme6lkqJC1kNVgwF7k7s85OHpqa6euYkQm+4qhrZIT9
         BCIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782122516; x=1782727316;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9FrPB48FwcDezsnLpR3fJd40Qt1udKU6vCDBpIqP+Xw=;
        b=Q9IXzEPXhqUknhr5wr+0Xwb0RV9Fu2pfLdzhTPK/5ehe/q1AcFh/+4jhbEexlRHgvt
         m8QJ1yNZejjqZb63ohl+0C9xtnFmlGMHSR56/9aV9/i5D6OQB71/Br3z+YAt+w/5KyxB
         ZdtGlgKx16CYDDcCTu4+pXJr5+WyXjV7Hbi4I2OZJ4TovkOOndaUkA57On/Fv5SVMMfH
         OPINgAAYsZmrBtDq1SiIKe0ghxVWqSeRSBv3S0MsrtCf9dNsx7m5fGdS0uOGcGL8LoGk
         5fM+v9aesGaEHd83F3J1E3eYzEWl1adxPTxUMPGSA48MhADlBCiKb7mBz5KCdelSbHPy
         4EoQ==
X-Forwarded-Encrypted: i=1; AFNElJ/8tLfrHKtt6wIWvuXsbHiAVzObHk/cc7vVg4WCcsGtG65V6bmfzvsAfWXEnYZvqkoc3MMF7HminA==@kvack.org
X-Gm-Message-State: AOJu0YzQNuQ7nMIY/Ln53XTgsKesJisTJQeIS3wSwabYxWNeFewUBQz2
	p5ikyQOyrpT4vg21LFzSblIWK37LxyS5tK9kqcybj1oKB2QF0KEOv9U1UEFSUrI4TgMnk4iN/cc
	4hAGNTF+Vyoy+dQ==
X-Received: from wmbe25.prod.google.com ([2002:a05:600c:5919:b0:490:7229:9747])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f92:b0:490:a1dc:e542 with SMTP id 5b1f17b1804b1-49242314217mr179945285e9.6.1782122515233;
 Mon, 22 Jun 2026 03:01:55 -0700 (PDT)
Date: Mon, 22 Jun 2026 10:01:37 +0000
In-Reply-To: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
Mime-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260622-alloc-trylock-v2-10-31f31367d420@google.com>
Subject: [PATCH v2 10/13] mm: Remove __alloc_pages_node()
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 33EFD10000C
X-Stat-Signature: zgwp5jamoqm7m4oypofkizayyfjw8dqs
X-Rspam-User: 
X-HE-Tag: 1782122516-134478
X-HE-Meta: U2FsdGVkX18/8zhzW9I//tANbeK1T8d0lZh1yyPh5ZYE9k3hTdD72AfrCfY2DiPz2+8dBhPxpEIrIGfKvX05hU6PLlpEAg/Xm6NfK6ntzvceOKwcuojuzkwa/D0Gv8hudwSOltpbp8H3l3SeqyGCDCZUO3/2lCsnASiNCcRnUNt/BADqcm5Suiye0KIs4bUOqc2QZszdAXH8bpn9nM5H0j2CVCHeOgmLIof+Xxe7FXEygDlz1WTqkUJLaRUb/BxsA93LkAE9laSr4UVDxUIuyeKgy6kET1ZWUwh0XBa7MK8bmH6fK5fIY1E7GRMsBsYPoyQDf9kzKKvVolnEabq9dNokQ/8UukV0x96QJ0w4kdhrGXWCQj15Yly1Pb9rtdPoozNiAT5NgkHp5yAZAJKjWpIifAaI8x+LMNkfu8qgqVBwY6NvENu/q+sCVU6bz0CpZQR2JItWqqhdyoLeB0LKN+dvSdBqbcoPJRerm7q52gCKrSAm+jp66s3B65v6b9w9K5AIH14EGTKgSxB9km0kAv78Gw6NLARwUVM89y8+pJ+uS3R9BJbzlsUKuYtfqkEoyA+b+eJXeTPYSS+fde4ZNDkS+DGDfpKsoVA6a2YSmbeKiBHChCeqpyPlVHSrvUVXwdCWkKiPECUfze1E3O/CQOZrZvrP2kk66tYl0o43ma0hd8OMbdkMivbDTGaFji7ZnEXNUTl04vLCoDFBYIZM9hK5l08pvH8mGUYYDoZw/65eKBqZXZhmDDeuj7ZuNeLDRnLfXuGh1GuBq6/xTXOc0ACe6Dj5VROv8pLM2ZmIBNBq0lXvgIUQI5Q+ydXWL9QsqXe64NiKda6HITU49jmzWjPtbAk3AhaIKdjnLQThDuRAP01E3MX3gsEMR5Q4wW3MaulH0QfJCM/ZrsZ2lHelxuwDpKKjFlbzDn9oyi2YydEGA5v8vrk7H60bQW0O/1B3q3H4VT1dIZ6yqMVNs14
 T6J/dRct
 8CbfNBWALgaFlDPv+r4h0CZhiCm3bTeoAKJYZsqXDH4ae1wt5Am6NckZDNeHPbBqIVN3xmodBo7F2csruguY/3gWAHIfBA7HDnYkTfE3rZwp9sSTHgpu/v/C/yUu/tEyGr9JbKYqoOJ/Gji6V87FhV2B0HR/sWnV3l3diGR8pWbz3c7uja17x6WmfsWy3NLUMbyGt9+xMAMeR44afGCRog8PWXzV+PlYC6HZueaPnZ8le9TP+VCr5FpsdfruCDJfyb0nD6HPePp0vXKlLHzXsrQ82APGlSx6tAnNIxV2Jes7wLghbWunyFQT+IcBQ0YsNk3NkjzASXk1f9FDOF+xhMjZNFwyTq1FNG3GqY8ENvrnZdjDCQdyIJYm6j7G6pqG0zSzuU1Nh9Ycmrs6Z218LAK/ksIswJpKZ7t4HEqQ4qk8YEKNyREWOOOP2MYsKeqyY+D5bPK9V5plOhDA2Ul6wNsRNjIdcZiqS2+zc7JDItjXyFg1VY6d6f6wdQYLPEE/Q4kieE/ZyA+dG+qPWD8oR6gPX2DVPPGVx1P32Nkov82eaUawJ9bryTU0td+tkL+j7sD5Y9w+XOgD7+BLl/H4A5mI/OVWGT8mWxMtqP6q7DbcvJPDPyvUsal4p2ibcIHZBltGOdedsihE4//759zi855yxxUQo/QyC/OV6IR7mq5xpUGFrIohGCWpuQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There were only a few users, which have been removed. The only advantage
of this API over alloc_pages_node() is avoiding a single conditional
branch. The disadvantages are:

1. More API surface, more sources of confusion, more maintenance.

2. Worse impact of CPU hotplug bugs: most users of __alloc_pages_node()
   were using the result of cpu_to_node(); if the CPU gets hotplugged
   out this will return NUMA_NO_NODE. If one of these paths fails to
   protect against a concurrent hotplug then page_alloc.c will use
   NUMA_NO_NODE as an index into NODE_DATA() and cause some horrible
   memory corruption or other. With alloc_pages_node(), the code might
   just work fine.

Ulterior motive: this frees up the __* variants of the allocator APIs to
serve specifically for use as mm-internal API.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/gfp.h | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index cdf95a9f0b87c..7edcc2e0be9ce 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -278,21 +278,6 @@ static inline void warn_if_node_offline(int this_node, gfp_t gfp_mask)
 	dump_stack();
 }
 
-/*
- * Allocate pages, preferring the node given as nid. The node must be valid and
- * online. For more general interface, see alloc_pages_node().
- */
-static inline struct page *
-__alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order)
-{
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
-	warn_if_node_offline(nid, gfp_mask);
-
-	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
-}
-
-#define  __alloc_pages_node(...)		alloc_hooks(__alloc_pages_node_noprof(__VA_ARGS__))
-
 static inline
 struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
 {
@@ -315,7 +300,10 @@ static inline struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask,
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 
-	return __alloc_pages_node_noprof(nid, gfp_mask, order);
+	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
+	warn_if_node_offline(nid, gfp_mask);
+
+	return __alloc_pages_noprof(gfp_mask, order, nid, NULL);
 }
 
 #define  alloc_pages_node(...)			alloc_hooks(alloc_pages_node_noprof(__VA_ARGS__))

-- 
2.54.0


