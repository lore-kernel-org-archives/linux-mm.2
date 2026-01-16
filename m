Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D1EBC982C7
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:40:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FA226B008C; Fri, 16 Jan 2026 09:40:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07BB96B0092; Fri, 16 Jan 2026 09:40:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBE7C6B0093; Fri, 16 Jan 2026 09:40:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D7AF36B0092
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:40:46 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 663A0B58F5
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:40:46 +0000 (UTC)
X-FDA: 84338088492.09.EB1817D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 65BC4180003
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:40:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0uDN5flZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JWo3tguL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0uDN5flZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JWo3tguL;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768574444; a=rsa-sha256;
	cv=none;
	b=Pyq+R4yc8+oPF6SBwO0XjISAdCR+UkHvY237mJov0fYrXPbMSi1vc/UOPgRbkAdSq9Ey7A
	TyQWbhowpayzVqFLbd40VHU7/JHCrw11J0HRBv2kv8q6qGIvCjpm68pxKi6XaEsZdSod5V
	287EomloEQnEI5Uvew6R/sIRVjoyGnE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0uDN5flZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JWo3tguL;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0uDN5flZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JWo3tguL;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768574444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ROlivulU3ZUUmQJGgAdryy78yr1ISK1JLKlofJUd2Bs=;
	b=ircqZOOxfqdHXlO7dNV7HYnZPwxbSAugPs+/Lol6I4XDOQZPqJcfFdPmMo+DP//cWSuNjU
	VYuwGu6jkNQ9a+sD0az0oe4YHGfS+0nknaoiyuLL1Whex1+c9+OA6LcZQsf5aRMyplq3Mn
	Bu+xctorjnH3JjWBmoYOIMQzDyCvB+w=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CC4BA337F3;
	Fri, 16 Jan 2026 14:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ROlivulU3ZUUmQJGgAdryy78yr1ISK1JLKlofJUd2Bs=;
	b=0uDN5flZo3M3oKooVLtgw+1lGKk3BNo1NGV6Q+KZ0hpQVUJswdO5WN4miVeMNmspxouANY
	R+7UYkcGL+0au9gjLCXfyFcPDhQLP4V+cROAaH0xQhIMWn6Fzk6GPsDMpVr44n/97gkS0N
	nsT1knhA/mMiM0SUCKDp7oDo2BKrqm4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574436;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ROlivulU3ZUUmQJGgAdryy78yr1ISK1JLKlofJUd2Bs=;
	b=JWo3tguLRb0u9hBzlNubo9IPlGnwnN0zFKl8NeAdJ568/UV/thCxqZKK9r/jh3KPEhOm/x
	gDHOe3cDQxTghDCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ROlivulU3ZUUmQJGgAdryy78yr1ISK1JLKlofJUd2Bs=;
	b=0uDN5flZo3M3oKooVLtgw+1lGKk3BNo1NGV6Q+KZ0hpQVUJswdO5WN4miVeMNmspxouANY
	R+7UYkcGL+0au9gjLCXfyFcPDhQLP4V+cROAaH0xQhIMWn6Fzk6GPsDMpVr44n/97gkS0N
	nsT1knhA/mMiM0SUCKDp7oDo2BKrqm4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574436;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ROlivulU3ZUUmQJGgAdryy78yr1ISK1JLKlofJUd2Bs=;
	b=JWo3tguLRb0u9hBzlNubo9IPlGnwnN0zFKl8NeAdJ568/UV/thCxqZKK9r/jh3KPEhOm/x
	gDHOe3cDQxTghDCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A881F3EA66;
	Fri, 16 Jan 2026 14:40:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CEjcKORNamnydgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 14:40:36 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 16 Jan 2026 15:40:22 +0100
Subject: [PATCH v3 02/21] slab: add SLAB_CONSISTENCY_CHECKS to
 SLAB_NEVER_MERGE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-sheaves-for-all-v3-2-5595cb000772@suse.cz>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
In-Reply-To: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
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
X-Stat-Signature: mzmj3cdfitrus8mnaagmwnqe1wd757rp
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 65BC4180003
X-Rspam-User: 
X-HE-Tag: 1768574444-333962
X-HE-Meta: U2FsdGVkX1/LrKkORTjYcqsBRy4SllhUUmSJFiAKNOSM3UOX5kSNV72wHGWBRnInXxircKfosdAUrf/0bgkjbErYxGjR1mauo9EyI1wV1dIjr4HPPWAR9ayNz+rPwkeQLnz3+VnvScc3pjQU8nqykJJuYdfLCuTLNXb4nk9KapfPe94/mkBkRdfy/6MyWCnRp5i+pJVL2ko786Bb+SXwXoKYSCGZmjipThRxtx2zUTAQHaVWyiheZu9jCN5hgQWmxZHijyv5Gx9mCRM4tlSijmKEAMUd+ielCRfAsNSifGeIazxvpBgZPU5YoNNzLH0tshW7KpZ4QFmGHAqztEjWUC7H2RR1VPgUTzIjQ7O47FMPdZeQ3KdXlt9tVvF6T/wDTAbIsnnSnzJkz8gE+Htfp8wgFpHcuEy557Djmri3pSMGOaIyFFbWOhSvmLiRJe0m8SG1nGupULzWTEKzUWmdmbN/t0nBkYJh8l0y6iMXbWuFZReu3U22IWuSvFGXaWu+HdOc5UqoBwhCaFTwVRjK2Fd520fGuyMHrYYjoTw6UxIR/AFqAk5csOIKXww2lGO1JxXAWatRDxSeAkCd8L3Nxfv4AbtxPMxMqd5Kp3O7GU2USEW0NEcw9VA3o7v8H0WoQKNctn5ZOk+vT4/FzhW3U3JESe0BM6xOtz51nwJShpNKiOSwEFmFmomf/rx9w4PCZav0bZd2rvpV+dBwK2Cr1/WUrP694zmwHClqXgu0k7Rvv1jqtFFup+nRuRHmF7bmzcSWTDLKP+im49CJ89wzfpOD40yCyUQ3irO4K9FH5Hp8RMj+hwNzPlorQgEj+nrqvwWzaJphXCjybJC7YHGrIPAoYlUvCT10LMq7RTZLY2TDjrJPEfQsYSHHW2Lrn2nfsk/pc+vO9yht6WoQVPjBaaCDtOVYWDP3p1RsedB0uk9zQSp3LSLUdEn6J23H7F3q
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


