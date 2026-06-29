Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7CC8C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4493C6B00F4; Mon, 29 Jun 2026 09:12:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F9156B00F6; Mon, 29 Jun 2026 09:12:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0EE6B00F7; Mon, 29 Jun 2026 09:12:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC2796B00F4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:12:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 662D21C6D3F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:33 +0000 (UTC)
X-FDA: 84932989386.11.F4BEB67
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9F3B818000C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D5PaVA1h;
	spf=pass (imf16.hostedemail.com: domain of 3PW9CaggKCH4lcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3PW9CaggKCH4lcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738751;
	b=1JDVRQ35gTrrQvK/AMx7e/F448RIcQ6S2kLKjeKkeYX/wbvQCKPHRg2nQRS+DojTgHhktz
	+pEtXVjjZpW0voh9Ss1nBJXOXmScnz2lECmel5mb7uQVJFKmyPkT6xsZucKrle2I0VjgX3
	YK7ybk9iVTDLGYFSMsvEL27ECHCmGDQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ktspLxRUJ1OyNjPH+J45KSRAMXmzhCyrQ93WTpQoNK0=;
	b=f/jg4bNazCyGmmtimlZAeahJaD22RyDdsqZyK3U+pOkK4AGAVr4S7MY3DeaVXXNRYRNx4U
	RgURtcjjaM1xg6NW0HQbNAj226EEWlzpMOg2Caae5Z47nd0yKrGqtA/iZU0W/rWH4mCJFW
	6qyT0RVk4uTxSPZVxB3rO4GzHNCmBcU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D5PaVA1h;
	spf=pass (imf16.hostedemail.com: domain of 3PW9CaggKCH4lcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3PW9CaggKCH4lcemocpdiqqing.eqonkpwz-oomxcem.qti@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-49277e7fc5cso16475835e9.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782738750; x=1783343550; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ktspLxRUJ1OyNjPH+J45KSRAMXmzhCyrQ93WTpQoNK0=;
        b=D5PaVA1hD1wbihqvs/JV5b6NZa7AcFGl4kSuL1DOAp590yo4JofxpA/Y6NdPPR8B51
         wLWUY6gPX/NbHqzYrRKFOzcwcF1bjjM+pEfw6iWXlDJsCV2OmLBZPzysruOuGAcO7uD3
         xhdGzoh3MHQ3Q2YO5vjY0vd2IcYDwyP6rwGWHj/FcyBkNV3W0n9NXQrdesoXQQFDjXKQ
         l1bmQnSELPrR5GqUw4VgiUERmdpsdc/r1nKQbULutGoi7F+0qMqeGOvzPM6TUizJZUXL
         RNhA1LBG7/Z6jlFo3se9IhOsJwW/OYGRba2trcbCFB3LACVhoQPUbY8j8oUVP6nnueqc
         vtdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782738750; x=1783343550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ktspLxRUJ1OyNjPH+J45KSRAMXmzhCyrQ93WTpQoNK0=;
        b=GVVXDHxQFuSrA7wRq7XTeKgwL43o7+ReQhVKufvUihtYnisfGB+Xlqc1sOEeHEAwni
         6X8cvSfo93hm0MXgqZnf53vno7yQgSAzXAVmlBmZOftqHS5ActGEYMXob7xRH5+00l92
         kGsQKCMTJz9u4WbXr76fWJRSaDh8HxHE+lOGdvvNQwp+lg7dk6PpAed8lZz10JYhfceo
         l7sDviqyEbQsWXLQ2XQ1DT7DO5qjxuMzr7Rhbhg6WbjcLboNImdwdXis0XAeoiRbvJ+H
         ZuiCPIuP03XVgCFX1CtDSB+KRMyTaS+RIoNFzygoypC3fHwMyeB0Ia6AEbQGghmvvqyV
         eEKg==
X-Forwarded-Encrypted: i=1; AFNElJ+A+knzy+qerC/qbjwTGbSwTRLG+0Y/xjjNFB19cpErotmEzkLBj/PaTLBg06PPF7sIpGRf8umItg==@kvack.org
X-Gm-Message-State: AOJu0YyafGQe1xnWrV1kQVsYZdw1Yp0LuYkikipo8BuP+qtErNONnz8I
	IR73ic6J6fNA4pIY1r6MJwGLxVvotX1ItB+8xajwMygdHK0mQL9irlZBHKyFG9mEB6QoVatKZqT
	R4HfYpXwaIPyuag==
X-Received: from wmbfp21.prod.google.com ([2002:a05:600c:6995:b0:493:b734:b4b0])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6296:b0:493:a435:d870 with SMTP id 5b1f17b1804b1-493a435dab7mr98425595e9.27.1782738749960;
 Mon, 29 Jun 2026 06:12:29 -0700 (PDT)
Date: Mon, 29 Jun 2026 13:12:00 +0000
In-Reply-To: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
Mime-Version: 1.0
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260629-alloc-trylock-v3-11-57bef0eadbc2@google.com>
Subject: [PATCH v3 11/16] sgi-xp: Use higher-level allocator API
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
	Brendan Jackman <jackmanb@google.com>, Robin Holt <robinmholt@gmail.com>, 
	Steve Wahl <steve.wahl@hpe.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: e3si776o8bnph1gdo5y5d778iizijw55
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9F3B818000C
X-HE-Tag: 1782738751-400053
X-HE-Meta: U2FsdGVkX1/k1/LT2dxQ4LiZem+OEhWw6ayIr3IrP9spktUN0M70fpOsvnCULx8haM71X/AKTbi18HyYft+ioSAyYmgHBW4If+XePJ7ohgbEhpCtuwoFTkY2rkErV60ZcWxNMZQRbHCS+Hrj4yDMg6I4kll0pQvjmEBfNtqd8SNz6XrM+fgkFbf1uPBBZiOGWQen7leP2vAP4zpWwGnKoN1CJsSGlzu3NjI1LWyRFTSiVrSxUxjxHjne5kJEtvCsrbDkkanIT1zPx6sLN4cImBHoWgnKPXWF5s/pJIpU4NLqU9CVMRzGZLr74g/dgiNYjeCMu7PYA783BiEzvst7m9370unheIDTyJLAQgclfH5O52V1M33w4iq51yJ4uw8XYO0irCwZbVqR+BCZKKMIdbTejzqDtD9X7x4/xNJtoZSs2hMjMCjMAOfrIYNlQYLlor+3q/WfzBg0QPUH0PiSLq1/FmKZ3MGM8rRDRvUhW0iOmeNcR8bWznu6MrtvJNIMJHEW29Xc9S/hzZRsRxer1G4Mo0JBOUHXeobG6SStkct27DjwqBQKLSlrFO9BHt3DDeJ04d7ad14XllyK8cqpBdkSAXAu8MuHQEu5gJfT+ghC2PGUj9IScf3yhYSweLVekF5FCKvuJR1i3jrx640NEokIlO68bLngeO83XtzsgnndX585AtBOVb0TJfNlxNSmzNPVZWXy3yAwPx6BccIiX+hYTx5VVamN881vSyGXNNDloY/0Y6VDMVmJZck81r8/+XN+BfUZHXsqaq0UiD59sHeEwaxprk2b+PmpOR9L4U9CCP7bHuZKnGBErrTOr7HEQuy8hgwYwOhJ7gLwl9TK59vpPyswXpeoMD406cWZyyTtyv2ggtgDLtJz3PoRBStVX6PAB57ixu1fFXk6XemVs5hn3Eloc9SNs+xIsY1aouJMvTG8HC2Rin2sMHuMRuHXLYIv6fnNOFfe7XUCOFG
 qDy95g0o
 DdcdvkjUMjaBqD47L8BmMe8R+gg6cxhqfbBf2uHHBYtxNqib43EEc2yuKSFyufp8/QNLE7kLwKA58+08O8dpbmrQk+/nG6QfNWehFKyG/fuE0GykMIuIip+2Pmw7IDT+8tPy+0cjWBhTm3PAeOATOR8oMtWAfaDR9K8NQgeSsfvSEhUR75mR2pLEBtYEeGQkbxzvJQHYWsm6No5ZNxmYG4s0oZJm/jnWGI0KIhekDT7EWE8d1E2gQCSEIzbDZzDhpToeqB6qgQEs1RMO3Q5Ur4EmcBmbqUIGor+cQzvZIFCSgcQ5uxPeISM++CsyLl3lfgIiqMJ2Zfz2cksROC265eMBJnVyMvXnaGiFS8WniDcR81rl5npu2CAv2dzBszCUxD+k/2uif4i87j7MS5ohpQGPNY8Xg/Y7TaX6uxnLT5tRLczufrHJjPaHXZJHZoknF35efFSxqrttS9i2r5NhMGP6Ocs+61l15cf11xk0AOd3MC1GstdAvMTkGcL9p23RONuxYh8pOqNgnxonxX35JOXO/NvcpukEBvM3ltdbcE8/hQhJczwf62jt7uxgrIdNlMsbME+ZrjYTrn4zYKu6fdS8Apjk2Q4CB0a32AQpibIlsYIrFpTnYtLfBibYxefm6D2lsAyymH9bXEUc+dvnTnPB6+fNl5oxY28RO5Ah2TZmKM2AF2X5xD7k57WrdvMA/k8dJ9+fxtluu7RGrewB64xD/GJM0pEAbBhCfclAjOVGOGNI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The difference between __alloc_pages_node() and alloc_pages_node() is
that the latter allows you to pass NUMA_NO_NODE.

The former is going away and the latter works fine here so switch over.

No functional change intended.

Cc: Robin Holt <robinmholt@gmail.com>
Cc: Steve Wahl <steve.wahl@hpe.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Assisted-by: Gemini:unknown-model
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 drivers/misc/sgi-xp/xpc_uv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
index 772c787268932..aacff70204241 100644
--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -170,7 +170,7 @@ xpc_create_gru_mq_uv(unsigned int mq_size, int cpu, char *irq_name,
 	mq->mmr_blade = uv_cpu_to_blade_id(cpu);
 
 	nid = cpu_to_node(cpu);
-	page = __alloc_pages_node(nid,
+	page = alloc_pages_node(nid,
 				      GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
 				      pg_order);
 	if (page == NULL) {

-- 
2.54.0


