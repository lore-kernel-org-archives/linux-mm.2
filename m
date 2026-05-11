Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B994CD4855
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 20:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95AAC6B008C; Mon, 11 May 2026 16:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 932126B0092; Mon, 11 May 2026 16:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 847B76B0093; Mon, 11 May 2026 16:02:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 767A56B008C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:02:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1EF001C077A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:02:17 +0000 (UTC)
X-FDA: 84756210714.08.5A4B00E
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4F3601A0015
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:02:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FmxGOGLp;
	spf=pass (imf19.hostedemail.com: domain of 3xTUCagUKCJAy5FyB08805y.w86527EH-664Fuw4.8B0@flex--elver.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3xTUCagUKCJAy5FyB08805y.w86527EH-664Fuw4.8B0@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778529735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7kSzWbBLsBd6qB4iAbq+envEAJK7ihSlVnGWw0+sGFs=;
	b=Jje2ax80yiL2eelSuFAvLcuno1c3mIVdbSpUYoLeuMvqBrkzqsQ8BnUmXOUvCiKruCyT+z
	LV63ZrY5mNoRSI3lawQuhVOdRJLlD9ggGGu0wyihQFifORCXcLfYgkZfr1k7gAvUQ8rb7X
	3VZxqGQGE8J1qtVbeM2dP8srMGPZDmk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FmxGOGLp;
	spf=pass (imf19.hostedemail.com: domain of 3xTUCagUKCJAy5FyB08805y.w86527EH-664Fuw4.8B0@flex--elver.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3xTUCagUKCJAy5FyB08805y.w86527EH-664Fuw4.8B0@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778529735; a=rsa-sha256;
	cv=none;
	b=Bd5xYLtffH67CnUC+f+5xzlb4QdRN/2JNb0qRk92Wd98u2PC1m6pR9oN4JTltsEcxZlD7M
	YktV8m7JZ1ObcbTa2oJPjwMiKb/FMTmibSGkUsNHhFSbL3kKQpFNHmfSjHD5oYAUQGzAOA
	x5PKzKpFH139wDr0gAHmActxZJ6CrRk=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-bcd55c93265so140198366b.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 13:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778529734; x=1779134534; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7kSzWbBLsBd6qB4iAbq+envEAJK7ihSlVnGWw0+sGFs=;
        b=FmxGOGLp9PjrSlJ6ogtzd6Si4KUEJWaZRZp4pi/nwirrmYklL+tjA/4PxIi6HnPd87
         6/v1DW/5WTb2RlApCJMa1P4nVKlHefb9JJ+SumFvNFZudzIbZ60zcUVGNTds5bDs7fQ5
         3oJtT+cEsI6uiMAoEvgeFvha6/u1U94JRb+AJ6aawanC5CXNIelQ096qdfkl9LD/DccB
         EDzz+DVFmGs+cje/b+BBp+hZmujKTvU5l9w8ujmMr9kdU8WuvHRNBnuAAhSEsicMNLdZ
         Y+AvoyxeuDVUCGjXBA8npsEn4mDQt40Q0ebj+gF+7TQlL9xAbuHkY4kx44yh+MJhiddq
         Jkug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778529734; x=1779134534;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7kSzWbBLsBd6qB4iAbq+envEAJK7ihSlVnGWw0+sGFs=;
        b=rdkvKGl/O4tXKw3PSiYNN0YGGFcc9MRKiRGfcP4ZQ+3yjqrNnz0xx/oxkeWTwCreOR
         CRqwz+LRZ6zHfIXcRNxi4Vs7z7EEirrEJ9jBjQOLQa9go9zysBQ4m4Z6hJPmfofEyqhU
         C2S7zDhTqaPGLMT2IyUmMuyTMsLiKdQXQ/HNZzoiABWE4PTyhpl97lgLE9hGlkY13a4a
         zrNEtx6TIOVmutaGiR8BlFjcaE3WFvWn2Om5gE8U4/jXGu/2MAn5+Rb+13e9iZgBuUzm
         MqmzbYe9yZbiSNGIPNluw/52FmmzRC7vB3qHeec8m4U+aoraCZoL41jQ9TEeb334p1lO
         JYxA==
X-Forwarded-Encrypted: i=1; AFNElJ/09wyGcb++c9jf5NMKiZ7cDKmCOmax9/+9ZtAidnaOl0udtljXPQZlm8Y1ApQEAWEAbWoMF/6moQ==@kvack.org
X-Gm-Message-State: AOJu0Ywd8dXaX/qwosnH84olZfOQvuVWxQOd6YHDH9VZ6cpGVY+WXm1w
	SEUpJ/aaFV6Dp7q9aB+w6iZTvBlUpB800gqgXlK+O3W/tff2f6huQNFT8O84ATU9ZPI0lkNHUeB
	OCg==
X-Received: from ejche33.prod.google.com ([2002:a17:907:3da1:b0:bcc:71b:9645])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:a01:b0:bab:f5c7:23ca
 with SMTP id a640c23a62f3a-bc56df0650fmr1477434066b.38.1778529733351; Mon, 11
 May 2026 13:02:13 -0700 (PDT)
Date: Mon, 11 May 2026 22:00:49 +0200
In-Reply-To: <20260511200136.3201646-1-elver@google.com>
Mime-Version: 1.0
References: <20260511200136.3201646-1-elver@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260511200136.3201646-2-elver@google.com>
Subject: [PATCH v4 2/3] slab: improve KMALLOC_PARTITION_RANDOM randomness
From: Marco Elver <elver@google.com>
To: elver@google.com, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Bill Wendling <morbo@google.com>, 
	David Hildenbrand <david@kernel.org>, David Rientjes <rientjes@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Justin Stitt <justinstitt@google.com>, KP Singh <kpsingh@kernel.org>, Kees Cook <kees@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Matteo Rizzo <matteorizzo@google.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, linux-hardening@vger.kernel.org, 
	Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Alexander Potapenko <glider@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kasan-dev@googlegroups.com, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4F3601A0015
X-Stat-Signature: rz1gjyue5hxswrdzstxkpozs7gx1k5zm
X-HE-Tag: 1778529735-186185
X-HE-Meta: U2FsdGVkX18rk3fW5gS/i/EAb688ESnQfLdjoC+wo5pfdd9VOYZEAy52yBXdKMfM78dsgAF8Hw+wkxMWzxaT0uXLUyNBYFewThSd/JAYOBd3nn2CKg8Z994bL1QlpAmfxToXdg0+iNiZRodnGS3g1nbSV1+RcF3d3kPvt9i/j9HbMyMduG25CiI+sRNJSax3vr4FC+lNv91G5/eHaU5QqWW6WcqiU2ge6enIjFVDlEI3XwWVzbOH/rFGfBRkS9DZozIBOypB/pB+2K/CuxaZVawl40cIqBH43UtT73rW2k2cOeCE41WVbJyJ5vB71rM80AEEHgW9zpVRzPbKcHjvyz/KH9gA1spraW1rq39JdmiIWCgNYSZjvXRWK144ZCXWi6hLcEy4qs/m/V6Pq0AgNy1kSpuTWDR4sgurNByVBH2w4hlV7vnrItVnouMPs7c5ZT1eaD5rYnqtUsSV3T7d6VSyF6kVCYu/ghDXGOgemeOxbJMXm7wdM4Ut+sCxwqVsvWnj2RlHMlor2cbjMqtgnjjQescuCtrEdyxGIul/jQL4DKxJfcDHkDyvjCVmGRgbDe1j6tLIGPaaVDli9TUlUF9itmdsicHTNmvbdLKxChRDYPsF4qvRXqil6FmPBh2dCYqeAL3SMyde1myKaXQkWki9V4KVpcNthIfZc/tt5l7gcdrItTVw6H2HQZHQTV6IzCh+5jOqlduxp7LufzhKHWRWrNNXg1+2SMg/Sc0hN/zsgq77U2a5psN8m22bLIVoFXMnO2pHeAl4AEyDM0Lx/8U99G+qAkXm88yiGFhUF5vDIn5ramMYAx5Lvw1/2vwQgvpmFS4SGlemqGLtqfQEaWT3y91enFeupUuDnGoPlRF7Ca5fc9+fF0gtPD+qGQdwBI4w1u2q5B5RU4wZsjBRwvLT9plWuuuisLhqOX2HnOHBWvheIFZFXYTK6WKr8mzrK3J7XzUtUXHsDUpUaHp
 hpZvZrlQ
 qXBN97LvJkaZRuE9BHx8xn8oWha6iHxXh3o9QMpvaxoLCxjH+BCARWPJmC971jMzA/fgrxtUzzbuCfVDdDbzsz9dt5DsAePU6W10TTLASkEkSITJfJAdQRrVXii5XkLK8MIDw6xvg8rvg9rjMmAZoIIVeRsIFAjmE4E8WvsTEvIdgIaoO321FRFF3e34ux31yz02WYPEZxEMDUDUruQDO0FBEEmj8o4p9SrHQC2Kj2L0twlzxhsrhVByX13us3iS5orZm/d09aGKXzSJAraOwfKewigsu0kd+DA9vwag82SV2sYELvS3yYz5eVxwHEGNM8vurZ+sK+bqR2Ulvj+NJJBpjIoykEvXF+K8MV4Fuc5ulysCjSXbDEt1gA4S0iTDKGrDJFmT5j2c2Ow6yq4qVoq58bKPipftpYyOAXtrJ33QSDvXNo6POcSIuwKyXfD0BNqwcuUseYF0MW5zlGOVUkTNgcV30jUSHf7VEOhPZoPdC5WU6msLJ3N6ABI43yaVNwCwLhg7bg5Gpb3Bc9OZ7wD8o2SAgEzd5lRC0SDoCYo82MwVr5Z6b9PjOI4iZ8tZY9AhhCU1DnoOF8qPyLubonv+JoHCSb37L8ZBg0X8DUETVfiWV19rt1ynDGTjxZRus5IVjDJzY7C0+ho7W86/zeglLxnVFh0cMDszKFHU695WI0F3/klD/SZBd+7h/oN0Tn+TSLEvazWQNQVzuh8RRXZqafxOVh51lY3tQj+DMNrNeYpi/N6Zfg0xfQ4LjdNoRudb+RmbQIhPcPALXl43WsKDVT162HLbvprzg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When using CONFIG_KMALLOC_PARTITION_RANDOM, _RET_IP_ was previously used
to identify the allocation site. _RET_IP_, however, evaluates to the
caller's parent's instruction pointer rather than the actual allocation
site; this would lead to collisions where a function performs multiple
allocations.

With the generalization to kmalloc_token_t, we now generate the token at
the outermost macro, and using _THIS_IP_ would fix this for all cases.

Unfortunately, the generic implementation of _THIS_IP_ relies on taking
the address of a local label, which is considered broken by both GCC [1]
and Clang [2] because label addresses are only expected to be used with
computed gotos. While the generic version more or less works today, it
is known to be brittle. For example, Clang -O2 always returns 1 when
this function is inlined:

        static inline unsigned long get_ip(void)
        { return ({ __label__ __here; __here: (unsigned long)&&__here; }); }

To provide a reliable unique identifier without breaking architectures
relying on the generic _THIS_IP_, introduce _CODE_LOCATION_: it resolves
to _THIS_IP_ where architectures provide a safe implementation, and
falls back to a zero-cost static marker where _THIS_IP_ is broken.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=120071 [1]
Link: https://github.com/llvm/llvm-project/issues/138272 [2]
Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* New patch.
---
 include/linux/instruction_pointer.h | 24 ++++++++++++++++++++++++
 include/linux/slab.h                |  2 +-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/linux/instruction_pointer.h b/include/linux/instruction_pointer.h
index aa0b3ffea935..ea5bc756bd99 100644
--- a/include/linux/instruction_pointer.h
+++ b/include/linux/instruction_pointer.h
@@ -8,6 +8,30 @@
 
 #ifndef _THIS_IP_
 #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
+/*
+ * The current generic definition of _THIS_IP_ is considered broken by GCC [1]
+ * and Clang [2]. In particular, the address of a label is only expected to be
+ * used with a computed goto.
+ *
+ *   [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=120071
+ *   [2] https://github.com/llvm/llvm-project/issues/138272
+ *
+ * Mark it as broken, so that appropriate fallback options can be implemented
+ * for architectures that do not define their own _THIS_IP_.
+ */
+#define HAS_BROKEN_THIS_IP
+#endif
+
+/*
+ * _CODE_LOCATION_ provides a unique identifier for the current code location.
+ * When _THIS_IP_ is broken (generic version), we fall back to a static marker
+ * which guarantees uniqueness and resolves to a constant address at link time,
+ * avoiding runtime overhead and compiler optimizations breaking it.
+ */
+#ifdef HAS_BROKEN_THIS_IP
+#define _CODE_LOCATION_ ({ static const char __here; (unsigned long)&__here; })
+#else
+#define _CODE_LOCATION_ _THIS_IP_
 #endif
 
 #endif /* _LINUX_INSTRUCTION_POINTER_H */
diff --git a/include/linux/slab.h b/include/linux/slab.h
index c232f8a10af6..efab6b2ccf21 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -503,7 +503,7 @@ int kmem_cache_shrink(struct kmem_cache *s);
 typedef struct { unsigned long v; } kmalloc_token_t;
 #ifdef CONFIG_KMALLOC_PARTITION_RANDOM
 extern unsigned long random_kmalloc_seed;
-#define __kmalloc_token(...) ((kmalloc_token_t){ .v = _RET_IP_ })
+#define __kmalloc_token(...) ((kmalloc_token_t){ .v = _CODE_LOCATION_ })
 #elif defined(CONFIG_KMALLOC_PARTITION_TYPED)
 #define __kmalloc_token(...) ((kmalloc_token_t){ .v = __builtin_infer_alloc_token(__VA_ARGS__) })
 #endif
-- 
2.54.0.563.g4f69b47b94-goog


