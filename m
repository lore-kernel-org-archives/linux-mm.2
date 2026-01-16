Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BE75C982C7
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1A476B0092; Fri, 16 Jan 2026 09:40:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA72D6B0093; Fri, 16 Jan 2026 09:40:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBDAB6B0095; Fri, 16 Jan 2026 09:40:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C89856B0092
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:40:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8CF3A1ACA0A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:40:52 +0000 (UTC)
X-FDA: 84338088744.28.6C2F260
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 42E3820004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:40:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VIx4ysKc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lUDMhmHY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VIx4ysKc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lUDMhmHY;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768574450; a=rsa-sha256;
	cv=none;
	b=FxN4QAR2KuWd5pKNcBLMGPWyJC4yoxho6fC4Bbgdwnds64nqLgzGUGT5ALmcLqpmTOXiGX
	twhikuA4x4qQNX3LJYiAGmUHjRPlb5FDx5ZXbtPOUq50RUVY/W9WOX3b5QDl6HOxpOchZv
	xtcEFK8GQQa31oYJx/YgFLlOZDHnV3g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VIx4ysKc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lUDMhmHY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VIx4ysKc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lUDMhmHY;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768574450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N3DPRc87aFtnpwc8583i8li1YmCTDsn4GBRi/xoPavM=;
	b=Oq4FBDCYKIg8YtLIgtQi6HDdth8a+2C+ZAg/qmSnHtWgelCJJihZO2/0atyM4ky6rhPSsd
	WLbLspyuDh8EA/WJOrE/AEpcwx8U+emfkC4YkPpawI+uFKCk0pZJvvcge6xiXaElrYhDTM
	5ptbN45TZN1rAfg9zccjw+bmNh/Y48E=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AF381337C8;
	Fri, 16 Jan 2026 14:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N3DPRc87aFtnpwc8583i8li1YmCTDsn4GBRi/xoPavM=;
	b=VIx4ysKcVd45gYQ05wOQxYUCWqZWv0RkE8KFAngIZWuPyVPw/A3nlnjsZJ3Pu9JOmeYdzO
	az79Ytn2bavsmsW42oA7p5lHvewH6Ys3FmoRoP4OlXN2mS3dnOQlq4HJLsewwYypRi9OsG
	P2FSirPQ7oaRxHt8wVMxtCvzOCoST2o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574436;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N3DPRc87aFtnpwc8583i8li1YmCTDsn4GBRi/xoPavM=;
	b=lUDMhmHYsrl4K7lNpMBUcqhJq2GaLk9ZOMCidLB2S6PYZPd5WWdyL0SImiMebL5HArMOph
	/D8S4kbBtC4qu2AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N3DPRc87aFtnpwc8583i8li1YmCTDsn4GBRi/xoPavM=;
	b=VIx4ysKcVd45gYQ05wOQxYUCWqZWv0RkE8KFAngIZWuPyVPw/A3nlnjsZJ3Pu9JOmeYdzO
	az79Ytn2bavsmsW42oA7p5lHvewH6Ys3FmoRoP4OlXN2mS3dnOQlq4HJLsewwYypRi9OsG
	P2FSirPQ7oaRxHt8wVMxtCvzOCoST2o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574436;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N3DPRc87aFtnpwc8583i8li1YmCTDsn4GBRi/xoPavM=;
	b=lUDMhmHYsrl4K7lNpMBUcqhJq2GaLk9ZOMCidLB2S6PYZPd5WWdyL0SImiMebL5HArMOph
	/D8S4kbBtC4qu2AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A1043EA65;
	Fri, 16 Jan 2026 14:40:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uMFpIeRNamnydgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 14:40:36 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 16 Jan 2026 15:40:21 +0100
Subject: [PATCH v3 01/21] mm/slab: add rcu_barrier() to
 kvfree_rcu_barrier_on_cache()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-sheaves-for-all-v3-1-5595cb000772@suse.cz>
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
 Vlastimil Babka <vbabka@suse.cz>, kernel test robot <oliver.sang@intel.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 42E3820004
X-Rspamd-Server: rspam06
X-Stat-Signature: e6z8yhkanuznzrcw5kdcbx743qji7o6p
X-Rspam-User: 
X-HE-Tag: 1768574450-770789
X-HE-Meta: U2FsdGVkX1+V2aSPs9D3TLwbKd8wkbs2QuljTs01DzMVi8BFeAHk/5MY7JDwEYCRlaXlSlCVXc7xa5VNEI7Y++y+ZHt6e98S8MlI2ZVTvjjrdIlQK0u1XkTcIH7xPDZbDtp6XjUJ9a6z6kuReSSWEZr/+rspga4IAY+zsMJ5jCLwduAg/fPasjMfPgziKfQK47KT2d81XjUeNSK8QCAn+zBdx0WEAlQD53KuD1vAouJhdROr3QyKoZBcEmXZn6hTXugbGqOKgsU9VC0lQg8hH6wMFwg9N7C1imI70SYz0yVk0zVcE1QE2t8UA5PLDrg5nqESflXiaJbssJW2eDlGq3zNmhpohNHa4yPeVc7nzRsqSfVBYrUYT5q4RLsovXEiBxhEtqYB4AjbiL5vdKy2Dj3PLNZLHlN5HmycRvdBKF3K4/a5X3nZJC59COmJ+p+6fuaprtmA4/k53FVUdafMdqy4lBpPoFZYkKPClLFlyFtm4lr+1UR+YL90G9G2fVCoKSfZDbj8EFtIh0fgGOkv0mZ5YLAIXsrC1MOQAx9PwVb759lyNb8qyLAKAOXSxSK6SOoKBBnLp1kghbv7vDcoHSF10VWWtIOzgN6qF6TzkDb+g/R8faC3aDxHVvb46vhCqmeDTJ/rZeEwKajQAQ7KUkkcorm3ntH6G92zasd2vWVj3+O+xI1/So6jIwFOAFnUlcg3yLcp59nIZu1zdO3CfXvQh3WHda6v/Als3j5YT0Nqpn3nhASjWj+X8knG/BwhPBj3YN8t/xE7OzoxrL3EZpz1M/UUcuis2BAN0TkeL2qDPKrqsCwiL0md+KC8pTlGfUmTrKyI/Pe4EataGauPQNl4eLh3U1GSL6180BcAYTfjLpvZVwX7IhpctXLZM/TT6YlRwSruVmvSRjKzsumADpoGa3cvL6sFj7YKUbCF7NaHHAtqjoenpQKdLECOQzRgvguPdmmpwCuskxxAdOO
 ytf0UwZq
 zyG2VQDSz/h0ufg1N4BWhfQaEGxn6bg+BZbiyMCf30/BGvG0MNVCLKSz2tTbMVqb0TZUKXeJ6yaGbFOhfzhx0T3P3qUgvCvVpsW936uT0Fg0C3iFW98wePWJgKnLw7tHhl2q77XkYFtAsjiP6GbiuaZHwYfsYQBUA/2iJuLq2JsnHRan5UiqEpHQ0ugd+yb3RnfjuBdkxa9JvY/eyKwC3yjQT4K0bYUikgFoL0GMFJF5GvdCSOnc0c5ZYhk5kHdD/mkD2Ji4+tFmJ89N//f4VlwWEsyHUsDWourjR4Ly4pygno/DAvbzLbsGHN7W1iEjfRlGag8GaUaHczKukeHiyOTh7L8+IICteyY/qgONzKsMksb96teWpz6K1sulXug2mz1yG2UNimmgukgA=
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


