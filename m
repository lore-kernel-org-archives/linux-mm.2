Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 804E2D3EE9A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E469B6B03F2; Fri, 23 Jan 2026 01:53:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1CBF6B03F4; Fri, 23 Jan 2026 01:53:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D28C06B03F5; Fri, 23 Jan 2026 01:53:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD8CD6B03F2
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:53:14 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 877B11A032A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:14 +0000 (UTC)
X-FDA: 84362311908.03.315A8AA
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 54CD240008
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WZgDDmnw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gnFCVeRb;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769151192; a=rsa-sha256;
	cv=none;
	b=WMPkablANDp8avpqznFDX0X1rnVWOvYv3IIRqAyXyP0m9GXXRQnQYAySyQzMGducf0YvdH
	1q50joXCJrUmMXygP/jI6ToQGgK34U7gWcIikSpjC4OdTvM0rNtoKwE9f2lz9+o0elSlH6
	auJFzzJPHicE0/jmmb2YczPCAuycwFA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WZgDDmnw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gnFCVeRb;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769151192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p1HSP8e11HaumGUNzZ8v9KE8CG2FWMpTiIvIoTBcPSA=;
	b=rDMNGT/U01tPj/Bbbu3aZ7o19JFDkbFsQrd7H6ZmhvPyJCtSup2frJP5u/B85jNOU7ozRE
	+WMyn+iBTBwRF8IdUmq8SRKtcc0tq5kCTBVBy+A4RqV1LI2WT+eF43ACxmC+pjvH5LKbFH
	m34JnpxXg9HT9S2zd+EuPo58vBXHUHk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 95E685BCCD;
	Fri, 23 Jan 2026 06:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151189; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p1HSP8e11HaumGUNzZ8v9KE8CG2FWMpTiIvIoTBcPSA=;
	b=WZgDDmnwgSFIVN9eK+o6iWr5OJFyCQ+Kb3BW8u693CP0/uQzTyRAjjILPzFXfQ+Qk0sZMw
	yyx7gNG9XTG1TrW0kzFafNOlo+vOiQWgT5URXow5I9+2+CKWZkv0dBB9EgHvqx+butrY5i
	nWaEj8+DMwZ5n/rPjADQssEBeFt9Rfc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151189;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p1HSP8e11HaumGUNzZ8v9KE8CG2FWMpTiIvIoTBcPSA=;
	b=gnFCVeRbIsPX31z3chUGfEkPi1tOAjKcm2WzVvRAI47B1Mef3iwY9ohZvqFw015ggqPIWT
	QbF8XnEge4sXtnDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 61D11139EA;
	Fri, 23 Jan 2026 06:53:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cLyTF9Uac2k4YgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 06:53:09 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 23 Jan 2026 07:52:41 +0100
Subject: [PATCH v4 03/22] slab: add SLAB_CONSISTENCY_CHECKS to
 SLAB_NEVER_MERGE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-sheaves-for-all-v4-3-041323d506f7@suse.cz>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
In-Reply-To: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
To: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 54CD240008
X-Stat-Signature: hfsbsdw9d6ogfny8eag56en7jesa3kfp
X-HE-Tag: 1769151192-249820
X-HE-Meta: U2FsdGVkX18DZSEZlSuEip5Xy2R2IyO0Z4YoEbWeHuL8BCBGVP170UnLldSuu20FmWYub0DbHxjZyeDLS1sRZpzyGZer8kx2x5xZSLk6U5wX7DOkTPRUGvKEZ2j4sIvsG3H9U/OekwUovardTwNWaYwCOPn3XLSKxVCFsXIGDdcPlV8xVS9MVtDoQVt2gvYk3bgjWm9gyVQd10tP+BeJZyZjgFh/iFgsGBp5jjdph4cuL9oDOCQv+yfWkaI7IvX7DocJTDCpLlvEplKVcSnRVpmeCffeB2BXAT3hfd48286dIxYn1rjYHTg563mbEr9Rd7NuHjTtrnquyrn36COTS3jcJiun6RfjSQiKxpeMIibjGeHUs3LVl1rLx+k3G5z4sGZmu9PBMTsk9DFXmdpqeR92FVSLafcngFW1JGtRVCtd/KbOGu8rfOguJDo7Dr4DRXFYvhXeZIAY8If8ADNKyRUtaw82rRc118Yi3NOySFHS5hL0rnBH/eNma3JsLzoSZTMnFCqELL91yBEO3yY7SSoyQyNCsfalW6T/snlB9LzOMg602hiZehmtkZKH+E9PaTTDcG8+gYiCUMLUQeCChSGWCF0Zq+O50g9sBd766AgJ2wHwWxeG+YR7MtcXgf8E9KPGrLj7jvCo67PE7PC7XPIuilJjJILmyD4im2mKkKQ3Vcilx6cLxtpMAv5T/olgYzP/QX5J4tYSEBlaney5e73b9Yg38j8IF6VpKED7Oye8jfwGXYc0B/ubpzWe7hib6WwEBFyFLxJAEesyjzCgvLOkR0ih3HWj2LwyWH2/10zBgSMUeTFiXoRwRVDKo1rppgVwMNzMyAby9i0niw6YbiIPJH2TV/FNA9hE6nKs9NgBdYf3/cw0Q34fcab3A5dcZY4PAFVxvM95cdM3SHZz9PT1ePX3/X3Y+z0hDPUFvUxhtburWbsL2L3DAfVyTlldvYpWpBQChrHiKucI2wA
 TjGEkbN8
 iuYvb8vgSzWkyPMqT+YIsM10E/OVS7WRFrc26euIbqY4eouuoAakdFu798JSHviG+zyrWmkB11NqO5sXTmXip8xvXZB3THX/8N2lDAr+ouGBW4IecbWafkR3r5Vltqd+S0dzDOHVlDlYFqYy03T1YUcmI2KdO+xzwW0B4b/LUb46/pHxpGaUrDYu1MuglAfEcLWfhz9PkDNndybQVuASOyLXGaFRCE45A1E09fx0yW0ApzL/InuzcQHyn4IlQKRzkoA1UgvKVd1Dexx6xbkGnaCyCZt5/jySTNdQpDvzJxTXTKBDWERcI5huKrpuaDva6DjLSVwuo0qSSOOBJei/v8ETxJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All the debug flags prevent merging, except SLAB_CONSISTENCY_CHECKS. This
is suboptimal because this flag (like any debug flags) prevents the
usage of any fastpaths, and thus affect performance of any aliased
cache. Also the objects from an aliased cache than the one specified for
debugging could also interfere with the debugging efforts.

Fix this by adding the whole SLAB_DEBUG_FLAGS collection to
SLAB_NEVER_MERGE instead of individual debug flags, so it now also
includes SLAB_CONSISTENCY_CHECKS.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab_common.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index ee994ec7f251..e691ede0e6a8 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -45,9 +45,8 @@ struct kmem_cache *kmem_cache;
 /*
  * Set of flags that will prevent slab merging
  */
-#define SLAB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
-		SLAB_TRACE | SLAB_TYPESAFE_BY_RCU | SLAB_NOLEAKTRACE | \
-		SLAB_FAILSLAB | SLAB_NO_MERGE)
+#define SLAB_NEVER_MERGE (SLAB_DEBUG_FLAGS | SLAB_TYPESAFE_BY_RCU | \
+		SLAB_NOLEAKTRACE | SLAB_FAILSLAB | SLAB_NO_MERGE)
 
 #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
 			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT)

-- 
2.52.0


