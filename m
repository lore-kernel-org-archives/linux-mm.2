Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE22FD3EE9A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D9F26B03FC; Fri, 23 Jan 2026 01:53:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4908F6B03FE; Fri, 23 Jan 2026 01:53:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35BB96B03FF; Fri, 23 Jan 2026 01:53:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A52B6B03FC
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:53:27 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BAE4A14038B
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:26 +0000 (UTC)
X-FDA: 84362312412.04.0298688
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 84F42180004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TwaNSJ22;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SNEpdW+c;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769151204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N3DPRc87aFtnpwc8583i8li1YmCTDsn4GBRi/xoPavM=;
	b=ve/DiF2kvRvqPEJYphmKdXYdSNFFAw+WGbLbUQFNTiUPe6LJ4umpPDyKaJuuJ67nW36DK5
	nWPSh8kNdFmkm7DIkMOP9QWFmnFVB6nNEJzBsI5RPPU6+COkChj9fDGsm0eNTIz+lPIb+0
	psFsHkR7g6kcWH/ERGE1/s7zdWDDY0g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TwaNSJ22;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SNEpdW+c;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769151204; a=rsa-sha256;
	cv=none;
	b=PjSIT07wWeMDnBr0nk6JLb9hFW1aZO+lWrvSNlh/uk9b3ZBzyZ/08ZjAnGzkB6ZmeTxaKs
	hjGc9vYgRX5fhFqpoxuLedPp9pzzcRbHLCtA/wfcPsdQnY4WrNu4O6xzkrHgUHulm/S+T4
	weGBybexcgw0wA6IFjJxd6uZepfdLgA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5590D5BCC7;
	Fri, 23 Jan 2026 06:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151189; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N3DPRc87aFtnpwc8583i8li1YmCTDsn4GBRi/xoPavM=;
	b=TwaNSJ22lUVkujoTIcvlmVUlFpzLKghPixm3xazahkIhiI/v4TrTd+WtWioUyaylUhhp7T
	FRbngh8djjheSnvOCQ6NZhq46zfaMkyu/7bpHDVUruTcSaryiQM9w+Ug1fc7wqbN7O6Mrp
	E6bNPUFcj3w4jWxip5wq5q8xY6i26Ls=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151189;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N3DPRc87aFtnpwc8583i8li1YmCTDsn4GBRi/xoPavM=;
	b=SNEpdW+ctprfZkkprEqg/5KnB8JO8nS631UuFA1jSQ0f0vyJgC0E2/s9y3iaX05lqkGrNb
	bJ9qxNkxCKfWBwCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 277A7139E8;
	Fri, 23 Jan 2026 06:53:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0O5fCdUac2k4YgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 06:53:09 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 23 Jan 2026 07:52:39 +0100
Subject: [PATCH v4 01/22] mm/slab: add rcu_barrier() to
 kvfree_rcu_barrier_on_cache()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-sheaves-for-all-v4-1-041323d506f7@suse.cz>
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
 Vlastimil Babka <vbabka@suse.cz>, kernel test robot <oliver.sang@intel.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 84F42180004
X-Stat-Signature: gsqy44hmst11xwt18pkwaw1x8665whjo
X-Rspam-User: 
X-HE-Tag: 1769151204-890114
X-HE-Meta: U2FsdGVkX1+cVD47+LzDJ6+pXO7Gw9WqvHjeAHnm70gPND8TLJDWSsvSoNo30LoVpjzAia6tHQb0p2Te8Jvx5+ZCt3y+TiOZ/Tg6YSinaG2S/8j1sJ1xNXf+qozW3HDZ29CigSSHHnwnP4/LUXHV/BCs023ajFnRp0qtOk9iqyZqkiHLxVi0ATCnpoTm/05OmdMUDSx1zYduCM2RtIGlFdcQ75fVF1DSJ9iWHA3+1KtL0bPK0B9xEOJRsTCN1ZQ12hJYOpMQKresKDsaz6KCSFpVglW0ZnmpvX40i4FpREiA1OITreJP7c7hF3ng1FUUMubL4kK9Box53fzqLWX17YcS4S/cfIFqxX/GQUISdXy8+mQZGFSDljBSoKZQKyasN1bYlaLfElf23Iumv6bukrSe6Cu/1UOtqgrDM+eP5FEExxYYJnplsAe1i6GZYl+PPuUMuWt68Xz7UbU67UZzD/+eo5IuQNVcR2PzkTlUKo9MJRKjYEL0OSFAOFcs8vEt26VV5V8B30B583pPjVqiK5x6N/1v4AqAX+DSYcDSBJZQO4g3hfb+dZhWp8xkRjTgQNtWyE3aHl1e9xo9NxaWFqSMzbLVOtXMpISKcowCLne8hH8YqDZdZ4iX+81zAYbOSwvsyx1sGiBJOAapYVmXcGS9KBZToaokEIiJcyiFjWCnrQY7CHyF0zzEPfQsuIKVBGsg7H1iBh6V1/MIqF1OqwvgiY4jdMQnTOoH+6Svea7OXiFiCYbY45t/DBMs7LyvrkOWSQSqKEW0tQuEdKnRY5dxOucQzxRri1hrP63jy5Ep9HGT4lgkkysj+DmpkX6I5K01Z1sRUbwBRU6e2u7ABmvtxRNffHnKPsRFg8gefsIodDaiuizKXN6Iwfr26bkmmz1aGlFtnDLQwltN4nVBssZPQ/Rs3ZY0Rq/YXWQr1qddX48j1J5dDDyEEWPjYEqj7RrUeti5EeGVMfrw6d6
 bhOwyPvT
 n0eT8PxOUegPhp9dVLZTdtZDTpoN0R0RbMc3r9GOUPI1lUJXEZcWwCTxI9RF0lKvZXwoRjX5jB9bb2LV/0Vlds+5eUl4jQWqYhF9SoR7DXFE6fV3ztWMoux+pI9fuXVttGF9vNy00fr0p7o2vfPg9JJIdVKdGFzEVSCSJT7lUhDyO7qoxyl+SqAhip4fKdSezFezPzn7fC3cfJ3lxg7cuCExcPwDAG5SHv1scKjIz+XVC1DvTzCbuDKqjJLeH0duFR0ueGtoVaz0ZgRtyQgFENFHqNWrBMPaJu7WfKZ4T/oBma8t8Oc2JbQRNj8Uiasl0jdlygk0CoRC4bF62NfaqA36s1YUajZNYlYPMkGurvOw3CUQHCTyQtGw9i8cIC+6NLisWudlupzI8JpE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After we submit the rcu_free sheaves to call_rcu() we need to make sure
the rcu callbacks complete. kvfree_rcu_barrier() does that via
flush_all_rcu_sheaves() but kvfree_rcu_barrier_on_cache() doesn't. Fix
that.

This currently causes no issues because the caches with sheaves we have
are never destroyed. The problem flagged by kernel test robot was
reported for a patch that enables sheaves for (almost) all caches, and
occurred only with CONFIG_KASAN. Harry Yoo found the root cause [1]:

  It turns out the object freed by sheaf_flush_unused() was in KASAN
  percpu quarantine list (confirmed by dumping the list) by the time
  __kmem_cache_shutdown() returns an error.

  Quarantined objects are supposed to be flushed by kasan_cache_shutdown(),
  but things go wrong if the rcu callback (rcu_free_sheaf_nobarn()) is
  processed after kasan_cache_shutdown() finishes.

  That's why rcu_barrier() in __kmem_cache_shutdown() didn't help,
  because it's called after kasan_cache_shutdown().

  Calling rcu_barrier() in kvfree_rcu_barrier_on_cache() guarantees
  that it'll be added to the quarantine list before kasan_cache_shutdown()
  is called. So it's a valid fix!

[1] https://lore.kernel.org/all/aWd6f3jERlrB5yeF@hyeyoo/

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202601121442.c530bed3-lkp@intel.com
Fixes: 0f35040de593 ("mm/slab: introduce kvfree_rcu_barrier_on_cache() for cache destruction")
Cc: stable@vger.kernel.org
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Tested-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab_common.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index eed7ea556cb1..ee994ec7f251 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -2133,8 +2133,11 @@ EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
  */
 void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
 {
-	if (s->cpu_sheaves)
+	if (s->cpu_sheaves) {
 		flush_rcu_sheaves_on_cache(s);
+		rcu_barrier();
+	}
+
 	/*
 	 * TODO: Introduce a version of __kvfree_rcu_barrier() that works
 	 * on a specific slab cache.

-- 
2.52.0


