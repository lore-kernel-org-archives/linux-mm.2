Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2178606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 03:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C26F16B05B2; Sun,  8 Nov 2026 22:59:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFE886B05B4; Sun,  8 Nov 2026 22:59:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3BA76B05B5; Sun,  8 Nov 2026 22:59:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DB5E6B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 22:59:17 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 07129805BA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:59:16 +0000 (UTC)
X-FDA: 85414225554.16.C549D31
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf26.hostedemail.com (Postfix) with ESMTP id 219AE140003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:59:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794196755;
	b=Sz2ZK2U0TaivgvJ0xcvVlo90vIWt4QmSr+Fhsg4PVpmqBXmtmAqz2gzWx2SqqJWHhTlvRa
	cWkd5NozJ7hgcV7HMtQk2R+Lyuv2NIQe9wgrq63VAaThvzXgOKBLquu/oZl7YwQkHTGIja
	7WgpXJ8CbOLSeT9+MONPBnB21ja9gMc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794196755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=ME3PhzKv+3KgT6aXu12teusJRCWDcoOwJXl3TiAU6IU=;
	b=m8m/q9UdANMFBNE0t2D6cHNL5HRQSLVHk6a5I4CGCIk+23A+wH4ViasotB9F7nSASW4i4n
	MzSDktXhGPtBk2yAsdtXYcK+TFqf7TtYlr32nKFa11Ot+fAu2DyGrfKFZb+97OgHpHp6Sc
	T92yDB3eOT02ZwFLzibgpNoIxHWRw9M=
Received: from loongson.cn (unknown [123.138.236.242])
	by gateway (Coremail) with SMTP id _____8AxXdIMRfFqsLIdAA--.20397S3;
	Mon, 09 Nov 2026 11:59:08 +0800 (CST)
Received: from linux.localdomain (unknown [123.138.236.242])
	by front1 (Coremail) with SMTP id qMiowJCxtMwKRfFqyxszAA--.12328S2;
	Mon, 09 Nov 2026 11:59:07 +0800 (CST)
From: Tiezhu Yang <yangtiezhu@loongson.cn>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org,
	loongarch@lists.linux.dev,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/slub: Genericize x86-specific cmpxchg16b comment
Date: Mon,  9 Nov 2026 11:59:06 +0800
Message-ID: <20261109035906.10857-1-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.42.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxtMwKRfFqyxszAA--.12328S2
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBj93XoW7ZF45uw4UCF4xKw4DKF1Dtwc_yoW8tF1rpF
	4xurW7Xw4Dur4S9a47Aw47uw43Jay8KFW7Ca1rK343Zwn8Krn8KFyIkrWrXFZ5JrWI9a1U
	Kan7trW5ZF4UAFXCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
	02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAF
	wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU7_MaUUUUU
X-Stat-Signature: 9kdnjdxmyitntyh4h9u9r7thp6qx1yfw
X-Rspamd-Queue-Id: 219AE140003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794196753-249239
X-HE-Meta: U2FsdGVkX1+ZN/gHLjwb6iqLouiF9rLBbDJJxO6Ai6uxebSgeA3GN6C9BTY0dQciswraDixY/XFolF4LyBoXCy2G/ua476qsJOSQ6XkGSXZH6Pfzmfv5QNAP2EITMIfE7SyO7baewX1YJu4Y4lskfhVULIh1bC4BYiv9oBnKil9DLoBeJpA1tqAsoXJ8Llm6lFGdUk1rqqlfTIGIuEmb4ilAQEZwzwH8ihaKHS3Sf9gTKUf575OEPJMnEDtJmxjGIDmEhj/QuocRfeMLjMTgaAgof/Vp43U1ISruvWYkhVYcXp4fHYeh0DRP8hQHVXY2w2tm+xUA7l8UueAIlyusYo8z8AAi5tP4MHzfIJ5BZ5KAWYCfwAgQflqURCwJ/GyyrFK/1ePeQO+HhIBYCRX0t8/PTIr/9SZDz7nY5NeCnI31n/uBvD1qCZMOj/2yClFeVAAFjF0uOaKk61zcjB7MDVE7wiRl3bc1E22ohUNC7cjVThxOwwCqqhms+uj8jUHg7mz7RvpGMJ9On/yv5eomAJ5UUE8rbuhEoQ3V6TGS1xXwhKy0D2lWE0NRb1CMLh2SZq4hBAiy0q5oAblFHNPuD4ZTjlPwawNSYdbueg8IFrEdui4bL3GZVWDjtwDr9wOxE2TbijufYBbTlBec6Dc2d/VckWLLE0ZRWWuOVgDbkABpSL9659RPt7LUSbtI1qSBDeNQFBhrnC0xEKNtasB9XtICPM5ONxgjVqCpEI5AdvINCr+XFcMKPYFu24qLf5IA7TJ2qKOsjBW/6ORfHBxhzUdHzep/cdLw4mD8Ht7JpZV+waT64/b348tRibHgXX9jPhV9dMTCQdOxRwJXOpcKAkvrOB/QR8YwS1NMntjectN7JCIcj6mxCIHcvNh8FuuM8P9fTFNss4g0lEcQ5WagnXxFqjsCTnqoen5K5+ZsIyAMWgj/NaHE8ehfLAZKjjBMbqqJq7F31eseYEsmUnE
 c4lkSUBG
 YU545
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The kmalloc_nolock() infrastructure relies on slab caches with double-word
atomic cmpxchg capabilities (__CMPXCHG_DOUBLE). The current inline comment
in __kmalloc_nolock_noprof() uses 'cmpxchg16b' as the prerequisite hardware
capability.

However, "cmpxchg16b" is an x86-specific instruction mnemonic (CX16). On
the modern architectures supported by the Linux kernel, this double-width
atomic primitive is satisfied by different hardware implementations:
(1) arm64: satisfies it via LSE atomics ('casp' instruction)
(2) s390: satisfies it via native 'cdsg' instruction
(3) riscv: satisfies it via ZACAS extension ('amocas.q' instruction)
(4) loongarch: satisfies it via SCQ extension (using an 'll.d'/'sc.q' loop)

Update the comment to "double-width atomic cmpxchg", which provides the
following advantages:
(1) Accurately describes the cross-platform hardware invariant.
(2) Covers both 32-bit and 64-bit platforms.
(3) Aligns well with the __CMPXCHG_DOUBLE flag.
(4) Avoids misleading developers of non-x86 architectures.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
v2:
  - Update "128-bit atomic cmpxchg" to "double-width atomic cmpxchg" to
    properly cover both 32-bit and 64-bit platforms, suggested by Harry.
  - Refine the commit message to format the architecture implementations
    and advantages into structured lists for better readability.

 mm/slub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 45e077c7526c..090302f1daeb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5589,8 +5589,8 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
 	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
 		/*
 		 * kmalloc_nolock() is not supported on architectures that
-		 * don't implement cmpxchg16b and thus need slab_lock()
-		 * which could be preempted by a nmi.
+		 * don't implement double-width atomic cmpxchg and thus need
+		 * slab_lock() which could be preempted by a nmi.
 		 * But debug caches don't use that and only rely on
 		 * kmem_cache_node->list_lock, so kmalloc_nolock() can attempt
 		 * to allocate from debug caches by
-- 
2.42.0


