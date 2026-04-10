Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62501F4484F
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95356B00B1; Fri, 10 Apr 2026 08:19:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C46206B00B3; Fri, 10 Apr 2026 08:19:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0E126B00B4; Fri, 10 Apr 2026 08:19:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99BD86B00B1
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:19:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 666621B80DC
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:43 +0000 (UTC)
X-FDA: 84642552246.12.15C5235
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id AF6B814000B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:19:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t3jBR9hr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=l/i7/xAykrEqhXZEt+AYWUOXkyMBaQ0jVLhvmI8QgSc=;
	b=q6eVnfYFj/8uBcZFLKiB6HJmTM7Uym52jyDR0Sqvn7iszYNrgpvj5b3Pbo/V0ECP3c40fi
	7GneXZgS6Q+lbuz50b4i3IKjMmeQSe55h1tRbc4RCHWFVrykyxyrtnooIVd8KvOaB/Z/m8
	eRNhdinWzkgmwcnn7OsGURnXXoa7kCA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823581; a=rsa-sha256;
	cv=none;
	b=DlCChfKBYSVGs8NppZKyvZjIRkHT1HVYtqbwtTLKW0wtQJyYJMwR2dZlDYdXPELEi1k0Um
	e8YzYcOQJw3eXtUktENBL5+uEOb5h34pwhgt7V2Wwb3GvXC2pMJ+o6hw8b+2oLFdgj2GbX
	KqDm/8R88oZCUuqFegK6+hpCpumryFE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t3jBR9hr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B87CF44580;
	Fri, 10 Apr 2026 12:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0FAC19421;
	Fri, 10 Apr 2026 12:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823580;
	bh=mpxbBHJF6rhzMhSEUiQvC99JYsoAEEbwdTduYzlxEPc=;
	h=Date:From:To:Cc:Subject:References:From;
	b=t3jBR9hrloEPurMHDq+39Qmu/knh8sc4zRVE8/2evrp72m0jjf5ZLkiqhTfHJf3lQ
	 UuLDw1roDamtB5PCEFrCj4Am/iqY2B6Eqxv0IhuFUbghxXFtjb45YYjGv/1iSpakD6
	 TFwz04dexWQxc2lpHNkB6gue2paUp+SphQGzt3h2nfY78uDiPTzZOojY3e61FIsW5V
	 nWhQqjnOO5JiF4o/mhmPEmcNABsipUeHkNa04EcUPJl0rFmYRv/1fqlaU1qeGqFkTx
	 Wm9D7sRbThBkNSUjiYqRay+oEzZSBtooNF5Q5Yp17uiVAaos9NzjDw3gIyxmgs/heb
	 T0VBqEkO+l/iw==
Date: Fri, 10 Apr 2026 14:19:37 +0200
Message-ID: <20260410120318.525653921@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org,
 Arnd Bergmann <arnd@arndb.de>,
 x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>,
 iommu@lists.linux.dev,
 Michael Grzeschik <m.grzeschik@pengutronix.de>,
 netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org,
 David Woodhouse <dwmw2@infradead.org>,
 Bernie Thompson <bernie@plugable.com>,
 linux-fbdev@vger.kernel.org,
 "Theodore Tso" <tytso@mit.edu>,
 linux-ext4@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 kasan-dev@googlegroups.com,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>,
 linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org,
 Dinh Nguyen <dinguyen@kernel.org>,
 Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org,
 Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
Subject: [patch 14/38] slub: Use prandom instead of get_cycles()
References: <20260410120044.031381086@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: AF6B814000B
X-Stat-Signature: s8xstd1hrcdfya59n3hmbe4j7pe4wwj8
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775823581-213344
X-HE-Meta: U2FsdGVkX1+Z1MHCOkBPMCnnt6dFcAkFPPUDH604g2FtiGxFfRnBCGgpAWGgwjKyL49YsUVobaRsLO4bFNa7+u4DiaP00l8HmXXiVGQ0StjLdOjr0QFG9mQ3+GIntpTiYwSmBZbLa5dskhrgeb4t5n4mMHgpeUaIFMQ1CMRgTVyNTwkbOB9EbjaRj9pFicIKQvRhJqmLYsYVM+YWDD0dtINcVTtrcY0izSD68tobm18wfM2yS4zP1F0LpFgYz6pbMQsD9cn3IsQl9weNxLrwbeu4paSpdYnkXwnPKw74T0PeR06Uti2FkaFFpid5cPoNDnhXdYQ01Ozvpakb7wd7PyO+y5V6Ewb3DzhJI6Up0h8li4ZQOyc+zx/njRtBli863s5i+8DrUWUrPekSGKPllXcXtNjrgKWRT/JsM5nzoFnb3aQDDTsBi5++U97VtRZKTlRY5+cktp4avo9nelg+Y5FUmbjeeCdt3N+jeHm6YDGcYOtBmGjwTjy1nEvEgJqGXSSeZPIWhA5Uu4gokLNGKw50B6nMxvTQ4aHGyrq7M/uUoiSd+LxSUO1fJ/rnLoW3wiUVhALhI+eFsorN4eJ9bHMGaWprvswkRYXVAmgMWGkthE2XFYFw/gZgCOZ3Lpp6KtODJvIczCu6rcELANkjJLXG7/hWfUHbGVXp6ix87ZfvS2sM9eHeo29NelkSvRdtTQsBz5knUm2A6Xi7ZDlKsCKBSqwhcFtC1/cakezbY/NO8ZJlPMmUNUR2H4Y3HuoNIuxmQUOKqAcXCHE4XWBk0enbUTDfrBilXueep3e6B9DDxmhSVPyjDt/xOgoqJsciPA6Vx5OS0uPAu7KBJx7RIweCepezlp0enCxGVQ132HqIbiJjuGdBmRFtyclu10b4obsviGrs6xlXyi/Tsizl5zdAVsw75IGMf04GUhZqKYLOcaJY2RD0EE4Iy8+ZlaWodNLL4CVkAqc7QkcS2ZQ
 u9ED93LI
 iomtGTixAv45BPQ8Qgr3KursPQ+vk+I8ghEzIoG67dtQR8S82aaGwYvFq2SaGFF+wrzFON0hI8ThRzj3VCRF95bPIL/6rXozDLE47X8a5PtG9srKe/ukr8ECAPeRFZ2pnO3wPZlmQ/bYNZLzuiQqEiFmG4sEY7F3wfMH15Wo5gowi24fgEiBVMf72D3zKBP/R95wsmpE6M/G/gbR3reJo/6WCs/jfKTgqJEtrJtfvI9S4umYgiVvQYKScYSqCL9hePi5yEIsiY30h62bXxyDsh2t1SOZnCaqWGEmgBrvXEyBVtU++b/HAHr+WeN78y83/weBzoi1BppasDO6UuqHrm9AoYtl+tsf+mixTOZVAgeB6dXbaYy2noDmqr7W6fKAenbf9j1/qL5Ik7G+ctGNVFrolBSywcn/IOHZdMasP9eVR+CsPBbp45n9SX16PjLBtqKLamKfOimQgy30=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The decision whether to scan remote nodes is based on a 'random' number
retrieved via get_cycles(). get_cycles() is about to be removed.

There is already prandom state in the code, so use that instead.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: linux-mm@kvack.org
---
 mm/slub.c |   37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3302,6 +3302,25 @@ static inline struct slab *alloc_slab_pa
 	return slab;
 }
 
+#if defined(CONFIG_SLAB_FREELIST_RANDOM) || defined(CONFIG_NUMA)
+static DEFINE_PER_CPU(struct rnd_state, slab_rnd_state);
+
+static unsigned int slab_get_prandom_state(unsigned int limit)
+{
+	struct rnd_state *state;
+	unsigned int res;
+
+	/*
+	 * An interrupt or NMI handler might interrupt and change
+	 * the state in the middle, but that's safe.
+	 */
+	state = &get_cpu_var(slab_rnd_state);
+	res = prandom_u32_state(state) % limit;
+	put_cpu_var(slab_rnd_state);
+	return res;
+}
+#endif
+
 #ifdef CONFIG_SLAB_FREELIST_RANDOM
 /* Pre-initialize the random sequence cache */
 static int init_cache_random_seq(struct kmem_cache *s)
@@ -3365,8 +3384,6 @@ static void *next_freelist_entry(struct
 	return (char *)start + idx;
 }
 
-static DEFINE_PER_CPU(struct rnd_state, slab_rnd_state);
-
 /* Shuffle the single linked freelist based on a random pre-computed sequence */
 static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab,
 			     bool allow_spin)
@@ -3383,15 +3400,7 @@ static bool shuffle_freelist(struct kmem
 	if (allow_spin) {
 		pos = get_random_u32_below(freelist_count);
 	} else {
-		struct rnd_state *state;
-
-		/*
-		 * An interrupt or NMI handler might interrupt and change
-		 * the state in the middle, but that's safe.
-		 */
-		state = &get_cpu_var(slab_rnd_state);
-		pos = prandom_u32_state(state) % freelist_count;
-		put_cpu_var(slab_rnd_state);
+		pos = slab_get_prandom_state(freelist_count);
 	}
 
 	page_limit = slab->objects * s->size;
@@ -3882,7 +3891,7 @@ static void *get_from_any_partial(struct
 	 * with available objects.
 	 */
 	if (!s->remote_node_defrag_ratio ||
-			get_cycles() % 1024 > s->remote_node_defrag_ratio)
+	    slab_get_prandom_state(1024) > s->remote_node_defrag_ratio)
 		return NULL;
 
 	do {
@@ -7102,7 +7111,7 @@ static unsigned int
 
 	/* see get_from_any_partial() for the defrag ratio description */
 	if (!s->remote_node_defrag_ratio ||
-			get_cycles() % 1024 > s->remote_node_defrag_ratio)
+	    slab_get_prandom_state(1024) > s->remote_node_defrag_ratio)
 		return 0;
 
 	do {
@@ -8421,7 +8430,7 @@ void __init kmem_cache_init_late(void)
 	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
 				  0);
 	WARN_ON(!flushwq);
-#ifdef CONFIG_SLAB_FREELIST_RANDOM
+#if defined(CONFIG_SLAB_FREELIST_RANDOM) || defined(CONFIG_NUMA)
 	prandom_init_once(&slab_rnd_state);
 #endif
 }


