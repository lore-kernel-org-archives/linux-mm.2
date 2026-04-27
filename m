Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CEE6FF8850
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 05:42:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 929DF6B0088; Mon, 27 Apr 2026 01:42:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DA056B008C; Mon, 27 Apr 2026 01:42:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C9616B0092; Mon, 27 Apr 2026 01:42:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 68CD06B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 01:42:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 006E94073E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:42:16 +0000 (UTC)
X-FDA: 84703240314.18.6800EC7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 714641C0004
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:42:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F3oJE57P;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777268535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z5hrwim/hNXfhNtfYHkmQC0PpZKbYNPFezxtkPUxjDs=;
	b=olh5Xu3fH2JYMvqCeB0qM7D4og6cj0dIQsH5CyPNJdY9EFxOZ+OV1k9iq74tdUQSv91XND
	iL+kwGULmzZmxaG17VGtXNR7K1s79KNPPGpHZ5qKS8USYY8+7z7uUFz5d0tQTA9m6dT/8c
	ZjzGZWD5DFtjmXBvAEUe2a8cMpy9zHQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F3oJE57P;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777268535; a=rsa-sha256;
	cv=none;
	b=dMDlk5vpZ+oBcCQLg/LCngMkmoufGs56K9GENjF1PsP5HIz2DLDnraLR+TWtxTsAHWXEct
	QEqcu4sE8dMo9BI+O8oxtxqvOOo9+5OD9qaKTvmF7rfjoh7y2aDU8BchRrioQ2K2VEM1jj
	riOcFNP5Mi9zl/LYnB11Gke34XX2W9g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C999860154;
	Mon, 27 Apr 2026 05:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BBBC2BCB5;
	Mon, 27 Apr 2026 05:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777268534;
	bh=s6RWkj+HUih9pUmMqw2vjrtv/MWn2+njvQOUZJznKuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F3oJE57Pl77p8yz5spNbOU0joeqRG3lsmlsrTB6SfUsfAGJz6vMV1anNEqqXHVuOE
	 ByIQkmzL25/9IXxxF1pgIeGjIDMznShs2Di2Za4u7/qpCo672Qgut9x1ITjzTSODDG
	 GXPAG2fycvf0sLjXV/WYjr5Pmi6FXtgrnuS3u+AaSQX4Zer7m0JDEiveT/NaJ4tvrd
	 Y8juBWLFjpo/6VB+CY8q5Suq35jtspKX/CFVoLCzFI598Giz4/6Z5rXYlCi1TnxjaZ
	 atURZUXrg1nByQzWtUEfUolCaiKSGVM+gfz1hvifTSEL3dxlxciKW1WX1OzQUTp28n
	 BBNil4h2fDQFw==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH mm-hotfixes 2/2] mm/slub: return NULL early from kmalloc_nolock() in NMI on UP
Date: Mon, 27 Apr 2026 14:42:04 +0900
Message-ID: <20260427054205.560734-3-harry@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427054205.560734-1-harry@kernel.org>
References: <20260427054205.560734-1-harry@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 714641C0004
X-Stat-Signature: ggz1jxcd3fw847k1jneemrxzizocqqx7
X-HE-Tag: 1777268535-867806
X-HE-Meta: U2FsdGVkX1/1eIioQqqV3PYa8uxu/rB5AklhOyi2XB9QOELgaU2A1CSljA0TbooiMoEATfxswyGsaYR7YZNmpXH45PNB13xD1sW3oG/ZCNPZJhqwPNmbtwBoMRrH+GlJ97bT0kuSlD7wAbMYmkI9+H1whcruA1nq8Ggnnb3gy4tD/SgldIsVUeMgTafqUo9hX4ZHK6j9QoUbkb9G20yUNPGL0SHMmvIm0UKaZh9Pt920pTK4oJJKI3/GRagwY0qJi8E1GrXOVELovvZCAb5zdweV0Lhus9XHrM/bXtwJCGFcohjzi/UvS/lpvzLh9TMw675qhfvZYz7wuIiAM+1a9XHOK7opCkk0jt3B794KSd9v7WkxfYVrVVuBcMCshndGUJWapJ4wzKhqMImfK+Rktk9QHV3TvGCHtr/faHZQ/YAxkD2iIloNroZMZAtSC/FHANlNTx59dmaR7QRl3Vibd0XzSz35L/MHPLAyGqAXxZuBljAV9p8hN6v8tTauG1xjti3ZWxHOgngL2KjJWyBEk2mqbV89SJvRPLrvs6CJGNrvKEdopcIYZxwO6MbugvNL8JRL4bvY3MlPshtAeEc6boP2afWh8gz1geJoHHQV1ECwPbQnNEHbh0SPWqpBDjsKv/vqHelLYzoz6qrAn9NSqGZTddXYlIkN9rPzMqx1ywz4jtJVU7GN0EBX/plo2nkS7TXCbCJk/n9iK4adpjT+EAxGLsXJkuzQ9+DtUjulUV2V6y1AHpVXmB3928E/6d16Oaakpe0W/hMcufbW9j9lhAoTTX9K7fRFht3alGfWbXgw7NwcdgSumrv911D4Iq7MkiyiObxpfTeVuPwvlGoOgCxXQvvI8zcnIbG9xsUdMwtR2Qlyvk0JrAXWFK+ALrDm/nDrCamk8PD5ZHLKCpH5RNwBhDh5dHQ5Y8szeYHQ4+vi5BWMU0b0tPMyyW89EzMZ5l6EM9YklMSZwk2rLfW
 0/Lo2oJm
 nB9SvNSnuUfjwWxIx4ns0ATcQ7q7rAyqX845USHKYE3ks02hW1f3oTuH5v7+sEw8iqeUaFXUD7bPJ8tfRSWZeT+ZTz57hZX/fiyVcWbNq9aFnaaJhA5+LincPPD793s5xT8g24UDJg2ckj3+hYJkD2ruSOP5nJo1gUZPXoeL0spHltcNVnsz/sPirFv2IML3WFRqroBMIFGriLrq0K2ZPt5qe66leysFuF2eIXfqLje9OI9XUX69KWUTbLN9XchtQwgb6bBt0K+tIEPsdW48HH8N2ZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On UP kernels (!CONFIG_SMP), spin_trylock() is a no-op that
unconditionally succeeds even when the lock is already held. As a
result, kmalloc_nolock() called from NMI context can re-enter the slab
allocator and acquire a lock that the interrupted context is already
holding, corrupting slab state.

With CONFIG_DEBUG_SPINLOCK on UP, the following BUG is triggered with
the slub_kunit test module:

  BUG: spinlock trylock failure on UP on CPU#0, kunit_try_catch/243
  [...]
  Call Trace:
   <NMI>
   dump_stack_lvl+0x3f/0x60
   do_raw_spin_trylock+0x41/0x50
   _raw_spin_trylock+0x24/0x50
   get_from_partial_node+0x120/0x4d0
   ___slab_alloc+0x8a/0x4c0
   kmalloc_nolock_noprof+0x164/0x310
   [...]
   </NMI>

Fix this by returning NULL early when invoked from NMI on a UP kernel.

Link: https://lore.kernel.org/linux-mm/ad_cqe51pvr1WaDg@hyeyoo
Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slub.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 92362eeb13e5..b4ec15df92f6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5339,6 +5339,10 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
 		return NULL;
 
+	/* On UP, spin_trylock() always succeeds even when it is locked */
+	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+		return NULL;
+
 retry:
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
 		return NULL;
-- 
2.43.0


