Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FC28CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77FD76B0092; Tue,  9 Jun 2026 05:18:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7306C6B0093; Tue,  9 Jun 2026 05:18:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 646666B0095; Tue,  9 Jun 2026 05:18:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 541F66B0092
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:18:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04BC6A040A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:04 +0000 (UTC)
X-FDA: 84859822530.03.8732AAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5980740007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EwWzpVtx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780996683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bvHD+M5eqRU8vVzuDK3OdPD9YFSs1FhVN9CwKgx6w+4=;
	b=P6Y60NE7/Q5nW/wRDghWzLTBvu9djihUuI6DWWS0tfjQ9VoYU7utIc1T1sCZXPxKSfkRtI
	wf54HzenZMXET0bpf42BLA9zPE6rLTLtI+CfLwKZmtP4ly7D2i14infse/mXEt+/ZKX7E9
	EcYxc+dDBPA6JZ143ZvHKWHQZkM7qwU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EwWzpVtx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780996683;
	b=njRoU4zPjRcw/jdI2IBlLC4A5NLcyHJ0AXSh+w7kGyXUxJJuod6JWxTqNU0TG7HmkrEN6n
	ZNLyjQuNFE0IK7IDvGI+st5BndHWLcwluU7yii2MiJk4JH5mumF5yhOo6ioHHr2F/Uwk6h
	WvQup5gg1UpdqqhWJ5ZPPlcmheGjMWQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA3A540233;
	Tue,  9 Jun 2026 09:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186051F0089A;
	Tue,  9 Jun 2026 09:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996682;
	bh=bvHD+M5eqRU8vVzuDK3OdPD9YFSs1FhVN9CwKgx6w+4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EwWzpVtx8lJmQmJHm7yEhQSONZqQWXPzp9YlWF8zTHmBmWejy22deW0f5F1bJX69y
	 H3psOwlagOJkgHekG275fpHqMAMD9rF4PQwsQF+clC6fBuwuIUKUnmrVft4tEsRePK
	 R0ITq1mDTxnmsTeg5lirWpQd/MAM5cpuvyfmdBsZObis0fN6BZkCZg6xoJZ+PucWpK
	 MzBk7CAqFXU/ynrTHIFGSgiG3v9YDsKl7kQeWb5WcJH6IKN8t9xxHaWA1slsyrqIhn
	 s/Fqtf2Ng2+59Iq0gsSekyju0UdwBprhZdEQGDIwmjCyFmQps+ZWqrCKHyOmcr2SrI
	 YWNTTrY5UMp0g==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 09 Jun 2026 11:17:47 +0200
Subject: [PATCH RFC 02/15] mm/slab: stop inlining __slab_alloc_node()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-slab_alloc_flags-v1-2-2bf4a4b9b526@kernel.org>
References: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
In-Reply-To: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 5980740007
X-Rspam-User: 
X-Stat-Signature: ijkszxa6q7fj5byeau51g3qd5pdo56mx
X-Rspamd-Server: rspam09
X-HE-Tag: 1780996683-326286
X-HE-Meta: U2FsdGVkX19CzdFnXfo5kMjtB+ZmX1wawnBDJSTjjAjQT1sYY+QgfILIBMuAKK0+EIde6OK5WxhDg6aQpq1UPduLLs1R8eTe/jCQQzYxtHGvyDymVK7WzypSFedldDdz30SfUzXKC3xs9+XK3uYp7p80lm59+jMvVHq6qARfB/dxnAvfJ9EpBdIdi5s1aaDQjrQXOwCb6iI13fxRIrzFA+G81We3mXaYq0GmXn1x7syhYDttyrdmPPoGrIXj+B8uOz9SL8dLFMFSqJCBc+gKVpXUR4dJnwO1DtcDeJjmv3JbiGLMuG4kJldj2vMZemyXlEZDd1HJ3SqSDxTGWY68S0nR6jL1a/BdFnkj52yENz1e3hVKyQuT4ybM7Wo2bqqntH+cYAwxgrvD74jJaSEIy1KZmGpEf4gNRylxqG9/pCYkHb2rv/6A40a3F0xX+bvQPYisQf3hVVbGSv12neON0I2cdkxBlf1oAmbt/ow+4HkbJxHyg49vKQKERZrTuC+msbYYWxaMmxygm437SCOiQobgbCGwdaaYWucWK+9Esny3FsedvwAw8ldIcWQF2q3ydqqGK1Z4NNoHL7MY6+xGTjovy1b2ycpGvzaINqDGsilxg+Z4ZTR9c3NIycokn8xan3t4NZdEEV0ptpcp3BoP1WHieHPYh8/laXgrdwoAL+Zutp79uhq0mTJFHFK9oUCvAMHGJOi8X+Vg6p7LnbA4Ra6LCCwYBS3ZL2/wZ/CpdsukRig1HGFvsQtpHVSd9V+a2ApXfShzIFmRp9yIC8m1DGgcQfV2JOj0EYPox/+izaUEy/TP6M554j3+zvWuHWOn+azlNFN7UgJYGB8ISsWPdA+N0UgQGMPnOsi6vQSDGmDcBpXQytZTht4VH9dTltAVW8ODGoRBaU5P6fJ4DRz8DUvf/mdc23jxhXjpHz5nUto/O8XHyyXOmgR7M5foGqiRMqlkLBE29R0eD6/Fmdc
 +F0xXp3o
 0Q5GxfiSZX7y2DWXOTHaeXM2S64mq6E0SGgkTwYl+bUHo/s7erZMcaRSC1ui3eH2xXpwsNgNWIigvXuciuxHNq6+s47N+V7ssAEDbMub/fk3f10wpJfvfwH7ETr9TO+S/Pu8AQ+uyeq8PMqe/oyNKqFAmr+HIMdefV8uIDqA8/umnvsm7Z0BlluUKNhOL2NCENdVI+K5NGLkCKeGJlUvzx+VdKuqqE8lxuG7bR/n+TpSSPQBq4mu1QqcQ1SFiq9ZAU0UcSzw2sMTUZuK+ediup4RsDOdZKtYr+CIP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With sheaves, this is no longer part of the allocation fastpath.  For
the same reason, also mark the call to it from slab_alloc_node() as
unlikely().

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index f787dc422d1b..af85f338db4f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4519,8 +4519,8 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	return object;
 }
 
-static __always_inline void *__slab_alloc_node(struct kmem_cache *s,
-		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
+static void *__slab_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node,
+			       unsigned long addr, size_t orig_size)
 {
 	void *object;
 
@@ -4907,7 +4907,7 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 
 	object = alloc_from_pcs(s, gfpflags, node);
 
-	if (!object)
+	if (unlikely(!object))
 		object = __slab_alloc_node(s, gfpflags, node, addr, orig_size);
 
 	maybe_wipe_obj_freeptr(s, object);

-- 
2.54.0


