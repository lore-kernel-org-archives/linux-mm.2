Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D126C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 04:43:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414786B009E; Mon,  6 Jul 2026 00:43:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39D926B009F; Mon,  6 Jul 2026 00:43:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28DC56B00A0; Mon,  6 Jul 2026 00:43:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAB806B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 00:43:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5527C4028F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:43:44 +0000 (UTC)
X-FDA: 84957108768.14.78CC437
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9B0FB80004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:43:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RQ14D4jb;
	spf=pass (imf02.hostedemail.com: domain of posheng.lin.tw@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=posheng.lin.tw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783313022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pzXSERi3Pv+24MnZlTaOis5p3sESbH98phLSZixVlWU=;
	b=xoZP4FNwUwzA70kyKNSZ9O48jUSYRt5sQhmWdryR6TUGVT3KEbiDxoqGMwF9PK+vnV1mrC
	Rou5r4FKdm+7svI/5Ou3Gf2ZLKshnYBzai6L7zzh95FGJpao1gE5rUGbjUJF66ljL7xbrw
	0JUkrAuHZ38jfhEPOcVDnA8PDQJMUlw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783313022;
	b=m52cuZRSXSH8sdCvckKLkePLBNp7ab0bEtzKERTYkNLgsok1AhkUPQXvLzYNEOlq2PiAbc
	nnttIikLccMKDVRDv5p0WX5rh+3M+Uv7xOfKU4xDRT/CkVB8mkAPXQWcUuDmWApaW+EaB1
	axXULdStP5IEUo6tg2zkgnEJS9Az6Ok=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RQ14D4jb;
	spf=pass (imf02.hostedemail.com: domain of posheng.lin.tw@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=posheng.lin.tw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2c9bd2f8bf7so35011055ad.1
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 21:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783313021; x=1783917821; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pzXSERi3Pv+24MnZlTaOis5p3sESbH98phLSZixVlWU=;
        b=RQ14D4jbe15fwql7sFy2omtgC4Qmge/lNnLLU4tfeaZTYOvvYi1B3SXzj8G++LJkw1
         2rGjpOj3oVf5N9qQJBDek/jcPVZp8wqZy3sub88sT1LqmO0Iimo4DVNrNHPxlH70l75Z
         cTUJwtbpzmwr3JfAgWqhjKxwaxkv5UnoXVzOBreJTIGXbl09nMazknk1+hoUefM3KYWL
         KBAtnAu7xDIwGlXY1jjLEdUraEqZRPu1nI08SQb470a/9XXVwX3xa33VOth3BitbWVhY
         ZyVq8P6Nn3mudPLlnXqyI997G/XLW7gE3bc/rwLE0GnEKY2r3D0EFaoOVyuD5e84Iujw
         +LWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783313021; x=1783917821;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pzXSERi3Pv+24MnZlTaOis5p3sESbH98phLSZixVlWU=;
        b=Yw0tQx7UVmbToMjtV1DWg+CYwoulMUMBa8HErWo2iIkE/0dvz/n412z00aNpn1n+Ye
         8bJxwcdZcFhIeI2TcrVaNQFUq6rnNAlQkhZp6C/1ZzFPsRM9N47D+mtxAPST9MWE97RW
         7khs6MsqT7S8dEaS6AdkPpkG9FFV2BEWNutQfXOvNySutA8MJtIFFec0qjY2r1g4ZhCw
         ArPJ9Z9t1lODE5qjIoyYU/ny3hA6lKwCVmjFhOubl43C5dDFK7qtsQDiUqOet+Yamb6B
         lSo7WpMSowSNfBYiEpi0VoO6AbPTijbfe/j8YAUlSQg271J9NBxNW8QlRirZQLf5VN9g
         msLg==
X-Forwarded-Encrypted: i=1; AHgh+RpbAYnATTLzvsB3pFshQyruVPy9s1pvXGGut7iOmuxNGGR9In7/9j8M7d/LXfjt5vaWeXq6jVj5yA==@kvack.org
X-Gm-Message-State: AOJu0YyMqjLkyKJL4tT3Sc8IXt9tnfSIPAcnS4qNgYsyV/1LYkrsdVBX
	Axw8n/I+W08qxcjXI3u9bB5WV0x9aYYItsPSTVDFr6KM1cjiPMZluW1+
X-Gm-Gg: AfdE7cl/Q+y0dgvPTaGySshq5hGKXhJab8FWIO9k8uACSaxEMZyr586jBuEW/wwwoX5
	m7prOwFAe4HJUpjbTSHwHqvtCR394LEkdtZ3826sexWbqV5uj9uZpLARCPhd5oCAJd2DKZ9HUxn
	wE7bZW0+0Pok6PgPEA/86oPJq89ZzO6VAhmpsmnJv4cnqtVqveSpTguSDX+wh4tKQe121TYrbiS
	3CJ9U9BIpWrxjCdEgHr/hwU4PlU4fmgfATEUQFw8I3wqxVqCJe3OoAIBJFh60O+nPAseH+5TWlf
	gXGLU0PF5336kZwbxMjwnfSN8r77pdDm7wmhWemUgk5OJmphg911wRB6NMTcr24Oihqp5AedPwX
	TeKHy9Rr55ExckO1I/qHtSCPRyRWU4KBX1lplwGimDuP2DkySF74urFX3PGWqPl/EFxTt+vmnuT
	egZi4mbnDYlXWHhTGwKyFR9Yc1U28tWx1xlPCKWoluty9Pk7Pn0apB/2OXMxAD3kkWBWL58kciL
	ji7hLKL0mx2jb8wz9OgWZ3I8xaXYGN/0HSqq3ZspeM5GHVVIA==
X-Received: by 2002:a17:903:984:b0:2ca:12aa:a390 with SMTP id d9443c01a7336-2cbd53584acmr60946875ad.0.1783313021423;
        Sun, 05 Jul 2026 21:43:41 -0700 (PDT)
Received: from localhost.localdomain (2001-b400-e282-3e93-b8c9-a5bb-8a3b-0c89.emome-ip6.hinet.net. [2001:b400:e282:3e93:b8c9:a5bb:8a3b:c89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad776516dsm41440215ad.52.2026.07.05.21.43.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 05 Jul 2026 21:43:40 -0700 (PDT)
From: Po-Sheng Lin <posheng.lin.tw@gmail.com>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	akpm@linux-foundation.org
Cc: muchun.song@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Po-Sheng Lin <posheng.lin.tw@gmail.com>
Subject: [PATCH] mm: memcontrol: use 'unsigned int' instead of bare 'unsigned'
Date: Mon,  6 Jul 2026 12:43:30 +0800
Message-Id: <20260706044330.10283-1-posheng.lin.tw@gmail.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9B0FB80004
X-Stat-Signature: rjgdwff3fctr7c4o4zxdeoini9n1q9m7
X-HE-Tag: 1783313022-410448
X-HE-Meta: U2FsdGVkX1+P2Bp21SSimwTjNR3H8zMQq3R7YXNttM/pqldovKvvjSud36l5OVFVFnz4vHxy+wYwwTcI3deXOPp6MNTYKAGU2cG1jbKxSDfZTE88t9gumzusAtAwPgcvSRLVYOGB4oxIzg4LE35KXpks6nSOsKWp/EI6IHoA1wW6y8cV8meZ3dNrBrAkI2HF+DQWPCrpwTIaz0AV7+EXnM56ijmxRkKPveuqfH6kTclaAueibs6lcs845B6/HGmEK9+B0E58Qk6eo1v/m7FukBUABOBO1szJUpdkcGVHEiVTcvIBraZT5Eq+E40PqJJGQjShwNxu2EAsVAuyTUy5mFSkdSGA2g5vpwk0oay3Y2z1FZDjBYZntjTj3bxDtx8QBwDnA3yGO8Bci2Z28MPoC2kA7MHWCIDwo2adUdXgOED1cE13Gd1Mo5gOduN839olQHFTFFwjSJwRf20Ry82FNyyhd2dgOe0eoc8q6xpvliEqnlaNAhzymIoHPg2h7SVzB3JTc1VFC+LZvPZ+sSgWmE0f8w8VA8i0mRSKANLzwiXBnT8XYbr7TmAWbbfXP/8Xq8xc07TTi3/nm4utBwhBPzGbB0wpn0gByqsa/B8lMwYoZxm/CmudZiV+qygUFl8chodHW09IpOYVlfGVPwMsiaP5jfPsBv45FYvfe54bAkJ18krjwFLFFselKNzbFB+oGm3PTg9n3TYcHWO+7G6w8dm+ZHQkhmRZfnKs+NbW48suCm1ardlP/QfJzkUP9HIiYXTh6+7l/BCoGlfnYuM0vQ1B3Oqx/hJ/2VegoniZMpTW7gslUu+L6HNQJQiRaa3Lz1+rRY4VSufR4YMjgoAG+18W+3UkUpxXcnaVBSdNSGRVonOxFLkuGDEnpqbbrX84bQsY+qMzErjL0RYuQ8kB4srKK0UVb4OIkeXyxJum1/iQTKtCcO6BLjiiKVfJzeKAYSIIqqHDtRqk+148qqI
 t4+9aVHB
 2YKGHZCDvj/fEqpUBITf7x3eCqBwvvDE82l4ZKUqOIsgp6lHVZUtizyv5jX66sKPPxMO04lZGdXhhMt1sjDprPfpKeWvBbUM2Q18DQ952YNnif3gnpsHWThSmEjyJIEx1YeLDI7IKv/9l5jMqnz6ym9cDyGoo5O1YPnB/qdNBtQf8wz0PvMHzvqZo31Bw3bY3TdNik+FpWzDAegF1SDWGpC15mMw/jf/iQ2K6KCvKZ8DRHYE7vWEnv/PVRgzcalchNZnj2G8vsjOobheYvpR+Mc2UQ6dCfbwlpwTju6G2DVO6gGm4HLvavMwZbaBeGfp0jpy8cEQuIpb4pTFE4j42LHr/57FAdzvBZTrUQgwoGCUEK4EVAUQjy9dmIzE2hqkJpsS8BqE042Erj5IxSP5rkme2lq/31+QqW68sLUnb4O7ha+uzCgYhJXMCHE6qrAhYQ//vjLrZNIlxOPwLVhDDZLYyFgeBfUlDE8Qz6RT6S3W7fevZk+FzSqLfJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use 'unsigned int' instead of bare 'unsigned' for the order
parameters in split_page_memcg() and folio_split_memcg_refs(),
and for the new_refs local variable, for consistency with kernel
coding style guidelines.

Signed-off-by: Po-Sheng Lin <posheng.lin.tw@gmail.com>
---
 include/linux/memcontrol.h | 10 +++++-----
 mm/memcontrol.c            |  8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1f46a0016fcf..903a57664f88f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1001,9 +1001,9 @@ static inline void memcg_memory_event_mm(struct mm_struct *mm,
 	rcu_read_unlock();
 }
 
-void split_page_memcg(struct page *first, unsigned order);
-void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
-		unsigned new_order);
+void split_page_memcg(struct page *first, unsigned int order);
+void folio_split_memcg_refs(struct folio *folio, unsigned int old_order,
+			    unsigned int new_order);
 
 static inline u64 cgroup_id_from_mm(struct mm_struct *mm)
 {
@@ -1421,12 +1421,12 @@ void count_memcg_event_mm(struct mm_struct *mm, enum vm_event_item idx)
 {
 }
 
-static inline void split_page_memcg(struct page *first, unsigned order)
+static inline void split_page_memcg(struct page *first, unsigned int order)
 {
 }
 
 static inline void folio_split_memcg_refs(struct folio *folio,
-		unsigned old_order, unsigned new_order)
+		unsigned int old_order, unsigned int new_order)
 {
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3f..33017eb772a3a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3659,7 +3659,7 @@ void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
  * The objcg is only set on the first page, so transfer it to all the
  * other pages.
  */
-void split_page_memcg(struct page *page, unsigned order)
+void split_page_memcg(struct page *page, unsigned int order)
 {
 	struct obj_cgroup *objcg = page_objcg(page);
 	unsigned int i, nr = 1 << order;
@@ -3673,10 +3673,10 @@ void split_page_memcg(struct page *page, unsigned order)
 	obj_cgroup_get_many(objcg, nr - 1);
 }
 
-void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
-		unsigned new_order)
+void folio_split_memcg_refs(struct folio *folio, unsigned int old_order,
+			    unsigned int new_order)
 {
-	unsigned new_refs;
+	unsigned int new_refs;
 
 	if (mem_cgroup_disabled() || !folio_memcg_charged(folio))
 		return;
-- 
2.40.1


