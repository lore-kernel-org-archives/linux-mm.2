Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EB6BC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 06:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F7086B009B; Fri, 10 Jul 2026 02:04:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A77E6B009E; Fri, 10 Jul 2026 02:04:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E4E36B009F; Fri, 10 Jul 2026 02:04:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E1B556B009B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:04:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F354A0379
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:04:04 +0000 (UTC)
X-FDA: 84971826408.29.85FDE32
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E7B0320005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:04:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hW/sGd3j";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783663442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wtRyuqLxHec+AIEMCGWYLc5A5j22LJ1kSJp888lWRJ4=;
	b=7DtyhDZDMDFjLagwbpSvTHFb8K2GxlPa+hjdYHqjssaj1+T3NoIMAOvu7OjfU4602kYCFb
	NW8VcgXbHxJvGamcOh+vHd+dUMdiWQ0gCdm6Hm0rmhpxyY1vcAPacS7SXawuhlBNPlE+EN
	vRdb8CfIiejoiGNmcsjAhTyKKSS1vaA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hW/sGd3j";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783663442;
	b=FAtfC8oAP0NOV3QhJR59YJaoAJ6FCTum0LLnmptul8pXZc+ZmPvujWj+zhAI+2rbiQpr/W
	mebgblynKr97v1S/T82nyfw4iD6pHIIlq7cVaY0yPWEopJ3P8NhnUL4bpJnKA0fQ5auD0R
	OzYi/RPEMtpgfmhDSF7pFjz/t8NkGxg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 525916001A;
	Fri, 10 Jul 2026 06:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8A41F000E9;
	Fri, 10 Jul 2026 06:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783663442;
	bh=wtRyuqLxHec+AIEMCGWYLc5A5j22LJ1kSJp888lWRJ4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hW/sGd3j2nK+la3rJ+AhDmiUN7uUN3qE8EOSoXlKtBWTFzSB4ookz5N7RE/N9gfYC
	 t/yaMkwmM3xJdFKya0TnW3G2KYXzr48e9uWU3ZpsTmlBG7obW5iBKuH2Ri4Xb4y4fu
	 bekwnVfWVis1FWdSAGgZd7gIOnw90gMvAvHaOUJj+0p+JpbhOMf6jK5JHOt+dBMRHo
	 JPfDN5FV3FdbWQHSJMH9NMbddPQ53YmHjdErwEfeoocp7h/jekmEemG//5C8osGhCm
	 UF2WJgS0RJAtcTPufP6JcRPZAvBmKxPu1biODxiYqDQvQ7zaZnL5k1rIXlRAN5x7B1
	 6I/GnMgINrNfg==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Fri, 10 Jul 2026 15:03:32 +0900
Subject: [PATCH slab/for-next-fixes v2 1/3] mm/slab: fix a memory leak due
 to bootstrapping sheaves twice
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-kmalloc-no-objext-v2-1-2709afb6a030@kernel.org>
References: <20260710-kmalloc-no-objext-v2-0-2709afb6a030@kernel.org>
In-Reply-To: <20260710-kmalloc-no-objext-v2-0-2709afb6a030@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Danielle Constantino <dcostantino@meta.com>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Harry Yoo (Oracle)" <harry@kernel.org>
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: E7B0320005
X-Stat-Signature: 4b9eqkux74zsbiar66tjxg976ppr5ybj
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783663442-458868
X-HE-Meta: U2FsdGVkX18q0wHL9Aqgo9JBlxhlf471Rg9n5YviEt+FLFgGGs+o7MilqYX4h6gizHuzt4SF5631t1QpGXJtceK1LCNVxYl0oU6geNmDAayk1m50tbP++HPCVF1vJc+zGDwKEJ4QevdBY9Qn4hPTXQLnZmalqXt5/0R7/xSczxCpeJXdW5fPc6fRTpnpJlMokRNO1ngzH3qXQOIi8Y34QLwiDyngMjlROqKZ1DfKzi/drMuhyCAhADUGUbIrQvsJUJRF7QZzcCvm2QUxUOXO/mrei7GrQrNUf6yc5mq3gna+Xx83FXMX+sivDuqs3Ip8Zr1mtCUENVuObohvCknQZx5GOWWmXlsSw3PeCvlQhUgl53OkKOV9pH8yZjy1goQs23RBCjgZkCFe9BDAKMNgMY6B12MUCcC+iT3WpGLVgjDFkOoiIZqihZQCcHfiF2x7qTDWMxi2oBIVtYFihsK23SqXMMa+pyEHdnKml+aXB7g3HA5aLvy/uPQ9KyZ2t1PIPesok0HwWdsvJW6G5qO1AzvjORM7Ne2XZ1hQfE25yih4cRDjbIkLCMTEw2rZ50VmyEL1M2mfrl2FBfNmQRnaXaFYnarTd9HRrRbV9TfezHPs4PLTPwTi015aVBVbYCC0OeWmPyOQnXP2vnmzUEaBsPJVfxQIeL4bo2ViwE+JWshjoCMDOpTYdGQyN/AQ1QFg931DQ3lv9R5CBmSipzFatD+LkdvznYNBP74XzRNkmBfrkeCUXqq08ZY9r2BqL5VkOZiAgJVeElkcv68h6zYB0Kyymr9SnMPHDaU/rDITyeSGhyFYXBG0je/UMFAqVjJcSYXu7DyQPYbxVjdukIj/RrXXIYuqcIIcB+JV3CBXwLOqjHbASdAbTPvnOz8CutN16gJ0195A31pMC+tRQ+j0AN+XHnP/Z0dd0M/7J9V2MnkWa2QXzxqJUeO4ynpeB7pQwwIhhXwFtMydXEkdt1A
 C0XtKidU
 J8Eayy5c8+CFLnjaQFCOxlalCbbWTxNvnvlyd+FmCAQHwHweYUNptPVi43103+4BGPDn0YE7I1LkH+/40DtNjqf5RfPc1smq9G0ykJcXdA6sbOG3hoChWn/VhfuZ157qR8//qZ9EA749Dnyar2dUGqT03uaxh/icikjMMGqsdLkaucxC5wlzQg5HLE3cx55ItXVlz4O9ZI3FRType/ArHDPk8NzQm2gSMk19KLTbJy1aogmUj1p+UgSxijw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kmalloc caches are aliased, multiple cache pointers reference
the same kmem_cache. As a result, iterating over kmalloc indices and
bootstrapping sheaves can bootstrap the same cache more than once and
leak memory.

Currently, this could happen when the architecture specifies
minimum alignment for slab caches that is larger than
ARCH_KMALLOC_MINALIGN.

Bootstrap sheaves only when the cache does not have them already.
Add a warning when bootstrap_cache_sheaves() is called for a cache
that already has sheaves enabled.

Cc: stable@vger.kernel.org
Fixes: 913ffd3a1bf5 ("slab: handle kmalloc sheaves bootstrap")
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slub.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 65febe957886..f9461a0c47d3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -8497,6 +8497,8 @@ static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
 	bool failed = false;
 	int node, cpu;
 
+	VM_WARN_ON_ONCE(cache_has_sheaves(s));
+
 	capacity = calculate_sheaf_capacity(s, &empty_args);
 
 	/* capacity can be 0 due to debugging or SLUB_TINY */
@@ -8548,8 +8550,11 @@ static void __init bootstrap_kmalloc_sheaves(void)
 
 	for (type = KMALLOC_NORMAL; type <= KMALLOC_PARTITION_END; type++) {
 		for (int idx = 0; idx < KMALLOC_SHIFT_HIGH + 1; idx++) {
-			if (kmalloc_caches[type][idx])
-				bootstrap_cache_sheaves(kmalloc_caches[type][idx]);
+			struct kmem_cache *s = kmalloc_caches[type][idx];
+
+			/* Do not bootstrap twice when caches are aliased */
+			if (s && !cache_has_sheaves(s))
+				bootstrap_cache_sheaves(s);
 		}
 	}
 }

-- 
2.53.0


