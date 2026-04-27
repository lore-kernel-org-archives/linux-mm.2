Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95243FF8850
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 05:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2A9B6B0005; Mon, 27 Apr 2026 01:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDAB76B008A; Mon, 27 Apr 2026 01:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEFD56B0092; Mon, 27 Apr 2026 01:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A96EA6B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 01:47:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46D67A0767
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:47:45 +0000 (UTC)
X-FDA: 84703254090.05.6533AC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id A3C82C0008
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:47:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ILY5LQrh;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777268863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2CCxhRo9dzSEFztsNr/qE2E5+PiJ9THNrdHASViPKrg=;
	b=Si6XG1gU9zMOFuYK5uMUcCfGMOtQ5Kf+UbuC81pabRm6aUXGPR+y0BqOlzswreLEjJVfdO
	HKB1OmGgapgpqAw3vam3rDzsydcw/8u2TstoFSUKlovH1H/1to1viu8M9CbJQnauoDLjGD
	Wmo4oX5MzQTMddpiE4rPu8BH/JTsOso=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ILY5LQrh;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777268863; a=rsa-sha256;
	cv=none;
	b=JxDpW9+p4wnYl16ES019JBisl2uTO0K4V99TFz3TCB5itIX9ja7jCm14HC892vxp2FWj1X
	e+F7RetqPEMTnhe+iLMIODC+3HBrY2XKarmwJuFUN+JWPBfaEYdZyKyvqlW9GzAYYh32Fq
	/0W48Yvd9gTrdf8TxIKt2ej7i3wu+Wc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8730C40666;
	Mon, 27 Apr 2026 05:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FBCC2BCB8;
	Mon, 27 Apr 2026 05:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777268862;
	bh=iipSs6v6w0TU4vM721+EG7SCFN/Hickx4k4+AOF1ykw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILY5LQrhTZ3NtMNZSWgVDs+k5D6opsKq+ZzeOYdZs0+O/k5H2CR4JN8dpnL8IjU1c
	 hv96auK1r1xc8LiMr48nGjIncVoimPM+MEHwQGHy+1a9E/jLckoRX9Zg0RpjwVG+p6
	 xP1kZaUUVnxwPSCQ91f702WP62xx9vsWg9mEESV5VQ8MVAmcKmbIL0+FIC9W1NMkpP
	 peKWbGcEAaF01iveYHcOUH7aPaHE8ABlMr6qlagfHwyBo4NaA6u29qwnOGGdFjb4Aw
	 6ifREqBdkEaYq5XSD1L1JdqfWgu+DC9OxaquZQvl/EJZX+Szn7josgahFK9dgof2ln
	 uiLMv91DE4LAQ==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Harry Yoo <harry@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH mm-hotfixes 1/2] mm/page_alloc: return NULL early from alloc_frozen_pages_nolock() in NMI on UP
Date: Mon, 27 Apr 2026 14:47:34 +0900
Message-ID: <20260427054736.566559-2-harry@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427054736.566559-1-harry@kernel.org>
References: <20260427054736.566559-1-harry@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A3C82C0008
X-Stat-Signature: ugujxte7z61j6k63ho8enpfiu4eam1nj
X-HE-Tag: 1777268863-463018
X-HE-Meta: U2FsdGVkX1/FlUxeNmJI2OsKYOV0s3HIQabi1QKDq6PAo1DW1MSbxeeFCKjI6akilvGzhIyxnZpxYbe/PAAwy7H6UkcIybCNENOjyk6W7iaf/Es7ovgGTIXKbLp3L3enpneODcAMKFmqWaz4K+ctaDjt8nnNRU4j8Y1DRsiO1zY9pDbEgjMa6TVCEKtA6952ToTzVaGJC5i+Fk2bK95traBxV+Qkm5VMAH47QtwHk0qiOWXXJP/GcNV9KLJgmyoTISSurz4HBrp59Dju8MNBJBDVssj7b9UROQbvVuWWeX/LiClrPpYn6XOnQg41/9QoQGJBHKq0tfdl0XGsVIgHVxjXy7j4SwLzUJlQA6qVwX0wtcNV7Ut43hO54gIMlPIwCskt86bAcs03tGcBRl6CNFaIOt2V3YBO4GJjO/smmV3LNt93EP7dvzrBxlrlCcwA8U5S+ewpSG6SADrtzLCuMBb6IJRR3gpFGndIZOJWBub2f9VZY2y7zvcVNo43bFBpxmNm1NckxEYlkvRiAo0JRESMr0pjVrzCp75x8NOexNOXsYg3MEcy2N5l+euTIC6y66RZ+7OZmtg22sMGFAbpnMjyxBxM9i57SqTRbnUEB7q4/XKjBxa27j2/yF+GnYOxQEm6bH/ZGlNkUcGiV7z7r6HtwoIB9M7fCOl8YFB0SA5d3OZDgVy0TEht6IhpI6/+nRl4Bs8/e78JMZD13UwYRIXvx4/ujVy9LP9F6jEBhCoUfH1Fq+k5KiVdXDvCcRhRPaOqoKhQHAxAiLSODtFuAyJla/PHPckZJbDXHih7RLdfP4n7BWv7jjjluN98BBlY/yejlffLUUub1vK9urEATz1Md8MdzNasczAI6IIMa80pvkiDiL1RmLPoPgs3DFAa9oWCvasp09C7+dS0bmNzWIySOFrSYhOm3FpYWDHCdOqRIYYlSFROdnZxNaXlCz+1jaTU0cYB1PzdITqqbbY
 R+mSZHRc
 df9LRGdLqL1njfgqiPzrgFJ2wAddA7Y7cSgNnM6A7JFQBoX2evDGhDB2/+3t1xnJ9+6J9cvf8T8Tl24OsF5kF4X/IGvQG2VhS5bi+v369eD6Q9wQ6enK4Zc/yZUZ/zJpQ/wL842oobmcKs4/R0u/s8ZxnnU0390l99VG2akIopvzNri+HNrMCogO7Gd5s5jhgZrlZxwjoS3DV79BobMtn5k0/zpYnfycdvTGreyYX5CknmNcuBmxLTXHsP3kmsbO3Tzg8nDhlR6nAgY6JlGHvmb9TPnHNNOu05nYQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On UP kernels (!CONFIG_SMP), spin_trylock() is a no-op that
unconditionally succeeds even when the lock is already held. As a
result, alloc_frozen_pages_nolock() called from NMI context can
re-enter rmqueue() and acquire the zone lock that the interrupted
context is already holding, corrupting the freelists.

With CONFIG_DEBUG_SPINLOCK on UP, the following BUG is triggered with
the slub_kunit test module:

  BUG: spinlock trylock failure on UP on CPU#0, kunit_try_catch/243
  [...]
  Call Trace:
   <NMI>
   dump_stack_lvl+0x3f/0x60
   do_raw_spin_trylock+0x41/0x50
   _raw_spin_trylock+0x24/0x50
   rmqueue.isra.0+0x2a9/0xa70
   get_page_from_freelist+0xeb/0x450
   alloc_frozen_pages_nolock_noprof+0x111/0x1e0
   allocate_slab+0x42a/0x500
   ___slab_alloc+0xa7/0x4c0
   kmalloc_nolock_noprof+0x164/0x310
   [...]
   </NMI>

Fix this by returning NULL early when invoked from NMI on a UP kernel.

Link: https://lore.kernel.org/linux-mm/ad_cqe51pvr1WaDg@hyeyoo
Fixes: d7242af86434 ("mm: Introduce alloc_frozen_pages_nolock()")
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/page_alloc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 71859993dd54..23c7298d3be2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7737,6 +7737,11 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 	 */
 	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
 		return NULL;
+
+	/* On UP, spin_trylock() always succeeds even when it is locked */
+	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+		return NULL;
+
 	if (!pcp_allowed_order(order))
 		return NULL;
 
-- 
2.43.0


