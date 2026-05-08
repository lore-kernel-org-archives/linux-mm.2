Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40772CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 08:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A51256B0117; Fri,  8 May 2026 04:22:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A022D6B0118; Fri,  8 May 2026 04:22:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917B66B0119; Fri,  8 May 2026 04:22:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 805B66B0117
	for <linux-mm@kvack.org>; Fri,  8 May 2026 04:22:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42326C2709
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:22:10 +0000 (UTC)
X-FDA: 84743560020.30.247F605
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7C03640002
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:22:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EVoVtMjN;
	spf=pass (imf12.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778228528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OEo6pPRll8yeBR0FGcshp1quwBCDN7gi2UMXNp6Yybs=;
	b=Iuy1sbRSM2C64wiSPXFTun9Evn93KOGSuDODMyeIUK/FvZXJ8BYFBu8FrtiOcyca5BMGj4
	6BjLjNbq9pHTH4iYIyviKbtQyxHP+4cNX3v93S45FIxhtK52qdMk/z8A/xMUnm54fHH8eS
	FZwA97BifcaHij95Gu4qN6FK4aoYV+4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778228528; a=rsa-sha256;
	cv=none;
	b=bWq48kIhHnl14PrnOozoxBZFAK4EGAQArJtaaZ+0pBzu+O/Zra44EMIxA1kMI4PUjbC+PN
	8ktzLdP6fJfgIoqY5DUgbgyzkCyi1fi/VLjcBxroC+2uNqxP+aLVaXumgkiKoGbVYfSs06
	/0Ccr2esQd/312SkePMTYqJUkkYhb2Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EVoVtMjN;
	spf=pass (imf12.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso27333445e9.1
        for <linux-mm@kvack.org>; Fri, 08 May 2026 01:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778228527; x=1778833327; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OEo6pPRll8yeBR0FGcshp1quwBCDN7gi2UMXNp6Yybs=;
        b=EVoVtMjNfaWrvDhgteFFCD2/lCHBVtCkxyLqEUrwPMsWx6K23I6Y+LIkeuI5mn1G3Q
         JtKt1dHN7tdeTUCO0eV/qHIwCRvTB9ygdZw/vQH/hFAvvimKkvHf3shSGO7+fz7RbsGF
         rGchB9dCilYK8jOqwePYRWLPqO5MUBBFVpdHd9kGsNuJEQ5n5B6jjXkvgT+RLfezxk66
         ntYCp1Jj4HL/03N03gTiQ4sVycMBTSBeI3i+t70qJsVf53E0Z596Xn9GYv097YLpFdRo
         dOeSdLy5mkBIZY9dH0CFh428B7TwC60q18WrNpg4Vm29UeCCVg7VrRbL5hwBtaz5y2UU
         fM4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778228527; x=1778833327;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OEo6pPRll8yeBR0FGcshp1quwBCDN7gi2UMXNp6Yybs=;
        b=YfTTYTgujy1gq4n8OFteFevUHh6I9zjdjSNp9J4U8/Pi30D102D5HLkqBnXvy/0twY
         l8uz5lt6En6qZCWYqHwVEa2APkBRbffQI9AMIc+fAFnrFOu2bFL+K4obFmZeLttzesYk
         FgJMWT+uATMC84jhx9rkalH2sRQj7Y2jhXgils3rggR/i8iu5sxZBjwjtV8CgXA3fyuJ
         NcoeegxQTIhwgOT/g/2iY03E7mWHxk2kUYYYyJ3f5ZpFcUdhPZ6uR7DXsuKpCv7sqN9R
         ydFhAIE46cFY0/D7d7va2KpUDDuSOECszFd+N8tQ81l9XxMMEI6+Usnovmf/6AXyemeX
         lbGA==
X-Gm-Message-State: AOJu0YwH0ROvOiyYJFHSrVA/dMNkDq2iEX+9t7JBiLMlpJAZoNNwIwL2
	ftG+PJD/UV0+DeM535KN5P23DjkQi7Xm2cjp5bsZoleSuaiZnT49Cn7p
X-Gm-Gg: AeBDieuzpbjNZT0t1HMhakaBtg+X4oa4JjxdjMon2M7/SQYz9kRIYNAhs9o6gzVE3qd
	k9qa/zoC3FSHWSMczhn3F7Q/QTNV72qx0u1WbzFIhfeuOL0ibtNosMfAcdPHxkdgT/UpKRa+o8A
	SBOUHukyVMXK9wnpUsEup+EpF8WbC6t+DR3xH/hm6Z1tLWtGenTdZBXTVDTL0PtgkA/taR0jOpZ
	/sCGI8xd5FmZsxOvtRUgA5/s+Ewrvba3Ut79j8H0ruvZ4pyT5bnWOYQEAIunb+B5gH47GTT8Txr
	g8Il0GJT4g6/MMHVBTyI4KHi+0FANNOTJs86/+N+FBUHknGI5CGYN/Qmcpks8Q9AUpWNLH8zoLb
	Qdtec0/zZhiUlCtrprSyUr/WwhPE/YebheXWcgBEj3+pkqe4hlVzo3FrCryqkxOxRfVnvFdn59g
	+u4XrMYFfPbS6FKr8WAehvHOEXIbPF23VpTRG6BpQLq18FG9YF61VyVYnmWax0
X-Received: by 2002:a05:600c:c4a5:b0:489:1abb:5559 with SMTP id 5b1f17b1804b1-48e6cbd6c10mr311585e9.5.1778228526387;
        Fri, 08 May 2026 01:22:06 -0700 (PDT)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.218])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e643f891asm21071455e9.4.2026.05.08.01.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 01:22:05 -0700 (PDT)
From: Qing Wang <wangqing7171@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qing Wang <wangqing7171@gmail.com>
Subject: [PATCH] mm/slub: hold cpus_read_lock around flush_rcu_sheaves_on_cache()
Date: Fri,  8 May 2026 16:21:49 +0800
Message-Id: <20260508082149.182139-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7C03640002
X-Stat-Signature: 6brfudgqhgawxnon5kjj14sxeq46brp4
X-Rspam-User: 
X-HE-Tag: 1778228528-43347
X-HE-Meta: U2FsdGVkX185we/PhzphgUHOyKe820rAwYlFDCB+d3142vBblU2lzYIbHFd6xznzqexv8k3+BwlwQM728v631MOQOXr+byv1WWBJEaaeROfedte/EDOw/Qd+b86jJsXRHO7Ca1JT0vkdZZvvVzroEmfFiJv6xusTg4TVYAbXXRt0xXNG/8AoSpPoSrG35u+XXmuu/sz6V78JJCujxZbNIm953i0wkpeOJDjLrNMzYEuRP2zC66z3dkF3OhCKz2ETjuMyD6a+fvdWp2vmrALCs51tcU7M//GCu60aXICVYVuD+Fu75+QwBXXGrcikAPHdSBmuF34pa2BzJWnqJW94gFqygAEWLvX2DD0exsHjZ3o4cBw2T5+IkJgSBO/KfpSHmZZtcpLdQuHyVB1LpVc6tMAirgabpa0gDrcGTsmVafC8o6VqRvH2hFGuIHFCAJF8cu23Mag5I5Khm9Uqwey6QqVcafAY8BpLEYo/X24EX49krPbdnQum7DPlT1940uzkdYH1jYctXz1hzs5s0MfssKkcx712S6QeNQuTxQNY9x0jffh4bXsDTY0yWLfJJwpAwIdubWCkx7PwLBr98igiLEmzhGtwCT/Mxzw8NM52UVs3xpYLLNO6dxWCSPMJb9K/LdLUAhQTExv5/SeB+AYzlzSe07ExXrCf8VOGMu6OfYo8HObIM2rlGYohlgVOUCLJVFSokv0c0rXUmd68v4WHijHBICmZobGklsdbAvjKro0rp4HCst6qgqFoz1USpCDO8QeL4M3P5X7m5kFQNM7rXuZ4xow6li5gCipUlX0XWZ3qmdaENoHNTPLPtNvmDY1BXca7RxJTQ3kIJrNlZNHyEHUIfNtNspuuNGhAMrliAP6nANhKemWDQrdJg0Q1viTJLg5C9S0FpV81ASmafqa3P46yFD66s9qPheLyVFv2rTmweUFAAr1wl9lTCWddeNBiXmg8yLAEl1h61KaQrLe
 TBy4Wi+b
 ziU6NPUHnry5bSI+pyRRU/DSIyIZm0mmOznRPBPdnt2bmV19UMmukW3gBj3ptXSzlZNWA7YtN3kA2qlMP3gCGR7uyalJKCGLfYwEa2JQhWBvTu3sdZ8x1RHFFvFGx0ffM8PGENJCmhs7ybwaF5Fj/n7BX/w5DYWs70Rl/Hy7S8moVvEnAZ20zD6yj2+Jup3xuR2ij9Iwv2MPtxGQnqtbAb1FkvGGGCG9xL4LWsL+j8XeLQEdaQnZhlFFXxOvA+Vfiif7YRKZqv0unR7cXSPYI/vm802KUC2BGEosEavZpOZFMtyxrZIWvyvMQYN1f/0s/n14TsSVGciBxWPaxCsQ/f4SnN5TMTEIxX76Lpz/K0+bjCE0f4XR3maOvizQb5b0DnizgRKrHbNP0iH35G7up6bMvx2tow0i/yqcFfgrdI/pfKetWbeKpr/LLbyBmVR4sA/ICb1au6dWVd9yPxTnL+4nPB5oQ2h1jIRhDpmQIxIuBrRZcdUFNGc/7h6lBG733qPe9w2KfhRwDf60TYxg/RBhrZ3lwNddadR9rZbK+Ed/lwvc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

flush_rcu_sheaves_on_cache() calls queue_work_on() in a
for_each_online_cpu() loop, which requires the cpu to stay online.
But cpus_read_lock() is not held in kvfree_rcu_barrier_on_cache().

There are two paths that call flush_rcu_sheaves_on_cache():

  // has cpus_read_lock()
  flush_all_rcu_sheaves()
    -> flush_rcu_sheaves_on_cache()

  // no cpus_read_lock()
  kvfree_rcu_barrier_on_cache()
    -> flush_rcu_sheaves_on_cache()

Fix this by holding cpus_read_lock() in kvfree_rcu_barrier_on_cache().

Why not move cpus_read_lock() from flush_all_rcu_sheaves() into
flush_rcu_sheaves_on_cache()? The reason is it would introduce a new l
ock order (slab_mutex -> cpu_hotplug_lock). The reverse order
(cpu_hotplug_lock -> slab_mutex) is established by

- cpuhp_setup_state_nocalls(..., slub_cpu_setup, ...)
- kmem_cache_destroy()

The two orders together would form an AB-BA deadlock.

Finally, add lockdep_assert_cpus_held() in flush_rcu_sheaves_on_cache()
to catch the same problem in the future.

Signed-off-by: Qing Wang <wangqing7171@gmail.com>
---
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


