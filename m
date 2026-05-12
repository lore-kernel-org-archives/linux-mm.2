Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A08CCD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 03:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CFF96B0088; Mon, 11 May 2026 23:46:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 980EC6B008A; Mon, 11 May 2026 23:46:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86FE16B008C; Mon, 11 May 2026 23:46:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74AE96B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 23:46:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F07C4140361
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:46:44 +0000 (UTC)
X-FDA: 84757381128.29.230B91F
Received: from mail-pj1-f66.google.com (mail-pj1-f66.google.com [209.85.216.66])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1B65BA0004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:46:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GjLljafu;
	spf=pass (imf25.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.216.66 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778557603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fe+pv0uhu+8/9x+lT5zEcF9+ZmOubb2ATbUfZcsmgWA=;
	b=5zClLL2c/Ols5LIyXY/5TmHufpoLKng3VNT3i6cEKZmvEqeerA1fD5+zsR30uLn4/3RPwu
	BwJpiUaALzMtmFvJnzkezNqChmm3TPgwbkuhXQhs4vofrGjmQPDBtMnWKKv7KhZ0xlu1Jh
	cncM3uRFEpZBsVL7kN+wwAk4IQXqzh8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GjLljafu;
	spf=pass (imf25.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.216.66 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778557603; a=rsa-sha256;
	cv=none;
	b=BPIYdawgV/JdLGAcxlnwApv9GRVcsz8G5XwPHzuKoLSv3kLRVd1pv88rFLLnGTJp5VVp6j
	FoZHpF+FEPZZRMNDkNC8T3K6fkMPGycEKbYol5nPbqxQRLLdIPjqD/bJMdlSM9qATiCfSa
	SQdOoKkMdO1YXRLBBZR6lu9u+jtnJ8c=
Received: by mail-pj1-f66.google.com with SMTP id 98e67ed59e1d1-3664df30f53so2237492a91.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 20:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778557602; x=1779162402; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fe+pv0uhu+8/9x+lT5zEcF9+ZmOubb2ATbUfZcsmgWA=;
        b=GjLljafu/AdqEBFdvLNMj6QivBQBW3LSokIsYdjgok4pmuHdZt82y/Y2NAG3s8wnbp
         q+b60fa7bVjdWA8uq5bPRj6VdHHNv2w2Ya/BEc2T5OQFdek04hR+IexUVT+8JpryCNG4
         mJ9jBy/9O17mg46VELuJ9/oPcyVGfvAG+ds2kbsar2MTxQu+6DeFiT8WLmz172DThlZM
         +U7wimLm/Zvw3Q8uT6YXS24/6MWhes2FwsF0vDRREl3NVglA1MbZJ1y8wi9QxrVTX7Rk
         FCvJky5ybffpg3d6sVLijtHyQSf7GnxZMepuQlVqmC2ylGIiIr+rSDz7SvR8do+9CXa1
         TAqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778557602; x=1779162402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fe+pv0uhu+8/9x+lT5zEcF9+ZmOubb2ATbUfZcsmgWA=;
        b=pXugRf2a4/NTBNDGXlAOF6V80NuG4LkT3NC0oLDSWb60Xnn1MNYhI0vMKJByMG/P3P
         GVNnvNLFCXdGm8iIo1B+jwOO3fIGSi0OKFYimtA7tiBajvrRu9BZDKFt/955MsQoj+TX
         PIRoU3qLabXHpaspsMIyqb+kiPVccRHXBuSa1+tdKEcc8p5LkMDjDJR/rIpYWTK36PIX
         puSALprdjd6ho5S3tRyWLW4xFxyRVkTFCExoAQqZ4gpq2G+Vc3/5RI4tAhM729u4ISLz
         sXNnBWKwqpX9PrfDJOEP5YF9VbX434cAK8wJrrltH/5L/J/TBgfqzrERa7YIOh89knU2
         GkUA==
X-Forwarded-Encrypted: i=1; AFNElJ+rwi0s6NKy0Mt3K9TMfMPI4+5SnXsVo3vQgKRCnfsoLkyxU7vJk27zM3NZxzgMByo0TzjE5ta+Gw==@kvack.org
X-Gm-Message-State: AOJu0Yxqo1VfQbH0X5g+a2OWdUbZPNfRn5Wm54SRvcu23m11TUAqUckt
	zWili0yQ8J6PRqgP/tjGblw5vG+EjuM4Yrcm+J9UcbFU2kJX4Mz8xELl
X-Gm-Gg: Acq92OEbpTqDxBer9BG8JcfW9L7NsUxsOGdJiIYW+y8YcDlycgJaZH/MahlT7R56Yh1
	N3THDlR9Kzmg3tNUhYFt0UtDjzJuP2YY0e1zEBqwjOiZ8TRfKtDjtr4/vFu37P4aJRvuFWES8t5
	1FvcwieEADrQJBOqlrBZRNUeYxggWGtEdUP7LKGOSg/hBgrHyoO7NGRY4c6Evcd1ggvZLxJRbHP
	v8ZPljsQf/GjjMqU53hcHUxLP/BAtPhn2CmV9Wyi/2CUwRoEIC42S92FF1sFKGdERBbkCnbEsa0
	p8zxh4DdjYyMmmnicAZLh3WS9nmDZNRVOqXQp7uRo2bXZSQsEeMohkJCILXkeGeyjcMQqLTlyWn
	nTiBgU3WWavKgyYJIpCVjmr8uBiWaZ7Apa3wWf+jtf4hH3o9XH47xslaVV/++jUIJBcu+I2WuHF
	4p9eMkSEPkh/R27gf3XDIZpv6GUhhXRUSjtSa+j+LIH/62RVy/9A==
X-Received: by 2002:a17:90b:314c:b0:366:19da:832f with SMTP id 98e67ed59e1d1-368b26649d9mr1377619a91.17.1778557601863;
        Mon, 11 May 2026 20:46:41 -0700 (PDT)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.218])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-367d629f40bsm9341207a91.7.2026.05.11.20.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 20:46:41 -0700 (PDT)
From: Qing Wang <wangqing7171@gmail.com>
To: harry@kernel.org
Cc: akpm@linux-foundation.org,
	cl@gentwo.org,
	hao.li@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	vbabka@kernel.org,
	wangqing7171@gmail.com
Subject: [PATCH v2] mm/slub: hold cpus_read_lock around flush_rcu_sheaves_on_cache()
Date: Tue, 12 May 2026 11:46:35 +0800
Message-Id: <20260512034635.760011-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <dpowyf5xneyg36lp25flxyjfy6dhijje7qy6z4sa7q5jpwp23d@uht5ja2rmfng>
References: <dpowyf5xneyg36lp25flxyjfy6dhijje7qy6z4sa7q5jpwp23d@uht5ja2rmfng>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1B65BA0004
X-Stat-Signature: uyrmica11bqaxcf3tk76hexeqp3iwiyg
X-HE-Tag: 1778557602-294470
X-HE-Meta: U2FsdGVkX1+r6cthXuK+/5nTk+Q4KD9Fm5L7/72A9arYDhrRJCGuaYXRAV08GxxEyjbOqaargysvLbMiLElaX/Twe3U/hDRzhkhOPSU+3w+NzTeWKgfrDjc5E0JEFJVoxgpp3jhaoAqu+Rs31rWoNwD7Vh+BP0ieaMduZRogOTRNHLmH07mR1dK95uGI9ZJFWc5e3GeprNMb+IY71TrSR2kBJSShb+ZDSSupKNl+pXOle5StVCOen2Fj5OMrUEmp6/9TqxgsgzRdc70coTsyfchippbc1oTTXsDI5cAkPYHgnwIE6qZ2/MeixWvvfshvtXNmRHemMr10OlAu+1VemwG80U5Gmrr02KxffOtnyJNqgRv/U+zF8xAoUMofHS7eThFChEbij12YSciDPOVc0ieuk/YXTS8b9D1UOOZ0bcdwg8XAKnLv2l0qqRO5CIQHD0T4QaS9u61ZDqATVgpVEmKHtAhE7vYrpxCWHAwq0/W+LSrDcCnBcUt2INyc+QuDglWbCgE0QaEv66DuSKhgE3a9DSEJFxfqRNDP1yTVJwPvUMv2NEBs6aGgXG3XdnFmuaKV6o33wNpYLjNr0WSgv16B4w+0FOEQ2Koj3AgFWv/q+mfKmWoR7fe40k1Rew980J6vhDx4Tn/BOwbNq1wE6oAN4At2n2dFlV9T2mx+r74NOy7Xkud5FxOj4rQtmGyvHHlJHPlO05NAQH0rc9+2oi8LWKzlswZERCtqQyQ0pw5KV/OjL848eU8Ts7Ju4PQ3uM62HuMBMSfNs0EAE2oa1TE3EJZj0Gwtzqz4oAe9WoSpPrsscrN17WJWYh8PbEIO29pNH0fFzfHeMZHFvGBpe+eq4VLkf+NRM7rUX/OQlfyhszX+lWXeS42flVUWt9Jfa6WHXYg3Id9xXgqo2SCn76KOZE+QmzygNtsp+gErp5EphoAa0TUdyaaHIczsjBXHywnjnBEeJNEvy0wb19j
 3Bqbepgo
 ACoo5LcbldAOCFliC87V83PP4qn5Xz40MMavpQiStxWB5r4l+M35P61WyQZULfmJXapDkCYd3orfTajpGZtUmtE+QNYBgb8Hb1148d8W553gB6jvMUh5Woi8naIg+NE5oxFJOfGblBsOoKg3aRdJ1Inr/KZoU9vATwK7QhqBQi2rn5ZOlVlZsk4d0e9g1uhi/dWehRgmaOi7PMZieOc9+MtgP8VA1+ALDA/c/iHz+EqxybnIUr1VWjFvV1cK869iIB609HY4tK+Q3JHD2wYVXUMslINxxXcI5LXNo69tTcj9w6c1pAmF78QzurT6WhW4C/qx+hQj/oAXUkNi9zIgnxuIDhiftT7XQ9kec2UCK2Q3wiGx9J+BVVi7OSCbmXSlxHhPxD52SrCpcdDTfUxGyqFsSOIFstK4cjsGx1KFcNKd1Qna91+l6nPJD/inRMei1+J5jJxt5RNEYVXuj+Jv/0l/fC/XoyL9WVOhOdHN6ACjg3kTilVWgEjIdkG1PhdL0DDs8BPgDkbTR69gCUNV8xUUSfJQWz9Bdu+DT0N8P28F59sU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

flush_rcu_sheaves_on_cache() calls queue_work_on() in a
for_each_online_cpu() loop, which requires the cpu to stay online.
But cpus_read_lock() is not held in kvfree_rcu_barrier_on_cache() and the
set of "online cpus" is subject to change.

There are two paths that call flush_rcu_sheaves_on_cache():

  // has cpus_read_lock()
  flush_all_rcu_sheaves()
    -> flush_rcu_sheaves_on_cache()

  // no cpus_read_lock()
  kvfree_rcu_barrier_on_cache()
    -> flush_rcu_sheaves_on_cache()

Fix this by holding cpus_read_lock() in kvfree_rcu_barrier_on_cache().

Why not move cpus_read_lock() from flush_all_rcu_sheaves() into
flush_rcu_sheaves_on_cache()? The reason is it would introduce a new lock
order (slab_mutex -> cpu_hotplug_lock). The reverse order
(cpu_hotplug_lock -> slab_mutex) is established by

- cpuhp_setup_state_nocalls(..., slub_cpu_setup, ...)
- kmem_cache_destroy()

The two orders together would form an AB-BA deadlock.

Finally, add lockdep_assert_cpus_held() in flush_rcu_sheaves_on_cache()
to catch the same problem in the future.

Fixes: 0f35040de593 ("mm/slab: introduce kvfree_rcu_barrier_on_cache() for cache destruction")
Signed-off-by: Qing Wang <wangqing7171@gmail.com>
---
Changes in v2:
- Deleted the unnecessary comment.
- Added "Fixes" field in the commit message.

 mm/slab_common.c | 6 ++++++
 mm/slub.c        | 1 +
 2 files changed, 7 insertions(+)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index d5a70a831a2a..0ee5a4189453 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -2110,7 +2110,13 @@ EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
 void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
 {
 	if (cache_has_sheaves(s)) {
+		/*
+		 * flush_rcu_sheaves_on_cache() use queue_work_on() and queue_work_on()
+		 * must be called with the CPU hotplug read lock.
+		 */
+		cpus_read_lock();
 		flush_rcu_sheaves_on_cache(s);
+		cpus_read_unlock();
 		rcu_barrier();
 	}
 
diff --git a/mm/slub.c b/mm/slub.c
index 161079ac5ba1..2a005d1e3a74 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4024,6 +4024,7 @@ void flush_rcu_sheaves_on_cache(struct kmem_cache *s)
 	struct slub_flush_work *sfw;
 	unsigned int cpu;
 
+	lockdep_assert_cpus_held();
 	mutex_lock(&flush_lock);
 
 	for_each_online_cpu(cpu) {
-- 
2.34.1


