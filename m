Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92ED2CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 20:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E451C6B00A0; Fri, 29 May 2026 16:24:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF6806B00A3; Fri, 29 May 2026 16:24:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5116B00A4; Fri, 29 May 2026 16:24:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC7346B00A0
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:24:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 766641202D0
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:24:48 +0000 (UTC)
X-FDA: 84821585856.26.A701F77
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7DC59C0002
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:24:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tMynjDyw;
	spf=pass (imf10.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780086286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oguaUT6+V1DypHAutD3qNEDdgfOr6liguLrL5/SdR+Y=;
	b=7jZNgV6x9mPEtOhNSShOlR9G7YtFRG/lwbOL3nKBpVkJ0z/ygQnu/orxZ0UbKENwpI9fLN
	Mt+Z7vVhnlbmLyCfF1n0h8beRJ0TXeXsp3eicHOVHvXQcLfTdbTUW6eI8TuE5Sqng/UQZw
	/GqCsQ0QzsWWRgxtT5qM/KtrvRjwoNI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tMynjDyw;
	spf=pass (imf10.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780086286; a=rsa-sha256;
	cv=none;
	b=SrByGXxY8988aSUJJEazKELlYML/kVpLbeFwj1bLvcaSXCfwbMxRc/QngscAh40gS5Mh8G
	vy8cYObi7PWFykfJMRjMYtB6sKVo+CC1bS6pnh/OAYNga60nQ7xMiFt7waqfPFALlAUwv9
	3K1Kz3v4Dpi+F7HB77UpV7EIywjOiBw=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-841513664bbso4680578b3a.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 13:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780086285; x=1780691085; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oguaUT6+V1DypHAutD3qNEDdgfOr6liguLrL5/SdR+Y=;
        b=tMynjDywHZxWNfbUjqaP+TrztJMftg24B6WcWfcWeZZKJIzKBTDrfzOlaeeYObTHXK
         wdjo8kPZoTD4QktYyqZe06nht/Vm94n+J58vhmfKSsZLb2QjBlJqYT9SiNAQ5K+neFqY
         HJUiZ8msqMmQF5hm6k1EloyLuPOLWhr6UTfRiqBm1GZuJ7nejxbP5TbsdaxoOUI2UdAk
         a4ENrRtfGrPQwN61IJSDg/bTm876iS9yOZVGC2HXfLTw9LbUovTw+JnEBwuR6HfNLcbw
         vOcazeaGIHwnQluFW8K9K6xmQVSO3lrhGeSusTByt9lR+Kk6l65VLdPosJZD2SKbsfb4
         t9FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780086285; x=1780691085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oguaUT6+V1DypHAutD3qNEDdgfOr6liguLrL5/SdR+Y=;
        b=X2xMALKp0aAMjE9xRzx11tFKxynsypyOjll6EuqP2tyWtm5mlW/pBHoHQe9F/IiVyT
         rVAIX8bvEfOm8V5GmEbFpKUFe0Y+ack1T/KmJtYXy3AaKR9nuU3s/CysKDrmMjJKmCFg
         AWD+7HhNn9scT2yi8PezFUx0DNtyOwtypgCcUm9JeO5IHsqYThaDVa86r8KhCeCtt16c
         BZ5+VFkGr2kbOIWr9AIiPJyVKCmxusar+pTO1OsZud3+2eVddK+k8Tm03B929cqjStiT
         176LtDP3u6HGE67KPpa/J7GqyMCoyVux5raFkecF3MHAO3WjAicWtxpZQEa04V8mY7FP
         QWfA==
X-Forwarded-Encrypted: i=1; AFNElJ9sz/dgnla13Ig40shojH2fOCnM5sjmmcQy5EHe3TCc+hUVw0w/plygRh/S+CyEb/Ta5lD54QCB3Q==@kvack.org
X-Gm-Message-State: AOJu0YwJCpxDjZBRcbTKlZzNcggMaTmVp0zCFXregmrqhGQ/LBNxbiqj
	kjunf+hhJKHzRZaa284POS0Fold4zeTrWKg+LdmSWqGyX+oSPnWJ1y/a
X-Gm-Gg: Acq92OHVmEGGP5nMZhapQz9efas97Gd2hbzJyHqq3+0otDRhHepmozHMXh1C6xKPXeT
	y1MtGYoVYsbaL8425sOVl1bAxbTRisgBvCSMs7fXLGrJSaOxMf8WjdjaTf8yGaa+mbI/BSxntxL
	sHU1NugoyzYEAGSdvqbNpD4Nii6vf5XbsA0SiFm4XoEhRAgNavZqk5BpS2s34cQktseiLbBXR/D
	1ij9HEcMgX3USevJHWdIYZDq1Hw3ip4twcRfJWOtPInutAA15ZmoXzREdDX/T6EqxIuAg5hQ5aU
	uR9m/0qUZ7CmTKRoxwlSN/AeZsfqqnOCWseaxPnd37PUWMSypZ+m/wgAWlA0IXzK4dxGj+49rSy
	giLD13zc1NX79Y/iGN1L5ZdV4tZrxSKtaazW/GzhwFSsNEtgcKU0X5HEdPtxPwJkMYIp7CMbkus
	wGVf/91FkSVoxy1PvHV01v2GSHhhGbQnMruVtZeCykG5vA4F9cV1AImjpPSzrVuBvgqGTFUZ+Xo
	FN8ExljRa+8XVrmQrWxEWMInJ+ACtaFRPM+217w/Rm6yQ2sX5iuqG/Tytl2BkrcSAtHZC1g
X-Received: by 2002:a05:6a00:1798:b0:842:2082:5fa4 with SMTP id d2e1a72fcca58-842257b0543mr666943b3a.1.1780086285218;
        Fri, 29 May 2026 13:24:45 -0700 (PDT)
Received: from localhost.localdomain ([2601:600:837f:c470:1879:8422:922b:e5d3])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214b67b8asm2632846b3a.25.2026.05.29.13.24.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 29 May 2026 13:24:43 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org
Cc: daniel@iogearbox.net,
	andrii@kernel.org,
	memxor@gmail.com,
	eddyz87@gmail.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com,
	david@kernel.org,
	tj@kernel.org,
	roman.gushchin@linux.dev,
	peterz@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH bpf-next 1/4] slab: Introduce kmem_cache_alloc_nolock()
Date: Fri, 29 May 2026 13:24:34 -0700
Message-ID: <20260529202438.16408-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260529202438.16408-1-alexei.starovoitov@gmail.com>
References: <20260529202438.16408-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7DC59C0002
X-Stat-Signature: jodgj9g6x5m4nddk1m8pz3efzosnfqn4
X-HE-Tag: 1780086286-86950
X-HE-Meta: U2FsdGVkX18WjvL2fclHyg6QtTXGQxeHH7jRHo6XV5ebFbGb/Moee7YwYLd5Rn0p8dfNKQxIfk/2d0ia1M7ix9uzqTAPBEQVKSmY3V8/4/wA7WWweilFvF2I/240QHiic4kuGKhgDT1GJEgOVLq6P6Za/o99eA5WQmrtuuCcU7AvkMtTvw+npxEFDfq/9NXK+yUsbLdSUVz/yyfhZbI5PzZlWmqHzLYo20PvEfK6fgRLe8T0JnlRIuKXZyRkTUsCBOHOreZoD1rCDBDH3Q9bk7B1ZYs0UAUhpUuYeT72tddw+55gbSaprDpdIizJA6sw7En9/91s9SJMXeipv0RvhLLUhmrt970JHR0QLqFh8CmB0O3cTI3LlmmQutKG5olRuUmxeJgNGxmpvQXw47aBcUiGSlykVjhveP1Vp+eocOKVicgeTf9lx40IwwCjtHqxFYSonRcObw94NO+AWhk+CuQxPEgMQvVeFvRpLIXoKuu7O6bFWwX+YQYEUUfe6HxNCcvyE666GMkXNy4zYYNmE4WYanCGtGMU4LI/IgNc7Klusc6IapFeUwVBF4t1ahYZr3vkM+wX5p52zH640J11rkTrJzq91a+RLqke4GYJ4l0JOAnYr68X2PNKNtvNho170LKhn4+BHYs5FFxFQk8Ngg2w+qdwchieNtElA1rfgP+BWUlmSIPTnHtGrvQrqKBgAmP/8kj8V7Ihw2Jfwfd7OjkWyQdJI/c8yVrkCXyFvZ6ZQ2vJ1TcoVTehptQmIEKak5ZJKRf9KxMayJgokUoDBPIcpClUIIqhYQJK/Yud64q3kOwGGKHZAKQMkD2RzZasblwfz8v2ySdVisN75/Ac7By0gwroxqkbmrV4H6mFg9aqfPys7KYDP+KEs28LRp9f9yQo9IKXh07QcfSYLEQrAbh3STCeNjxKEkCJqgDuc1mx3qGSZqcUj0ME7vzcCBZ5EF/rlZKoBrtR0WkLPEE
 KsxX7mbw
 kjjO1mAuwd9HzJLRggB6sp/mcpSqCpzPpmuRQyItauwaYxNd76toF6yqlaLY1dYk8ckNwxHVQpppvTcFDYZlBuy/fVguLrQkuID8MN8jHRspAAyyN6L2+8EmqAxLkg4cbX8peSlss5GUwM4tvIsIarMX1nvZg4nvrDtVIoSM1yECyxu/3F723HRHKnFNvh3C9VBYpM6Ga45ipw7jHzdL9IlAoZYD0SP9/RdeGXKmx7AOth0siW3V5dNKGNEZvYBEyaHbEwqTHvnofPBPTSszk+hB7Xhr94zgJS+Zw/RHTZyTstPL+Fbi2WkcV/+AHLn9HDj8zZVRRlQ0sKBQKwEIaNqALHLQ8ftN1+EeCafzISFUcWYl/yqaZs+8mBpRUmTbOcCMQJ2cXR0zQ3JlmAdrGQle0VCz1M+aT1zMI0/n1v7MU2JZG/bMRQm6B/UsbEaxgg7NXT1UBnLihapi2cLTqnmotDF+uqv25QK5HjL9GZEdFV/VZ2uFVo4ox7SAU3RIIV2ZxNoOC4vsmKPksYghwwI9VXPDLbrGTpiHK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexei Starovoitov <ast@kernel.org>

Add kmem_cache_alloc_nolock_noprof() and its kmem_cache_alloc_nolock()
alloc_hooks() wrapper, mirroring kmalloc_nolock(). Allocates one object
from a specific kmem_cache and is safe from any context, including NMI
and IRQ-off, returning NULL on transient trylock failure.

The new function is needed by the upcoming SLAB_BPF_ARENA kfunc path so
arena object allocation can run from BPF program context.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/slab.h |  5 +++++
 mm/slub.c            | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 2b5ab488e96b..7ce9125a6a2c 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -958,6 +958,11 @@ static __always_inline __alloc_size(1) void *kmalloc_noprof(size_t size, gfp_t f
 void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node);
 #define kmalloc_nolock(...)			alloc_hooks(kmalloc_nolock_noprof(__VA_ARGS__))
 
+void *kmem_cache_alloc_nolock_noprof(struct kmem_cache *s, gfp_t gfp_flags,
+				     int node);
+#define kmem_cache_alloc_nolock(...)		\
+	alloc_hooks(kmem_cache_alloc_nolock_noprof(__VA_ARGS__))
+
 /**
  * __alloc_objs - Allocate objects of a given type using
  * @KMALLOC: which size-based kmalloc wrapper to allocate with.
diff --git a/mm/slub.c b/mm/slub.c
index a2bf3756ca7d..601986aaebdf 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5402,6 +5402,45 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 }
 EXPORT_SYMBOL_GPL(kmalloc_nolock_noprof);
 
+/**
+ * kmem_cache_alloc_nolock - Allocate one object from a specific cache,
+ * safe from any context (including NMI/IRQ-off), like kmalloc_nolock().
+ *
+ * Returns NULL on failure (including the trylock paths that may transiently
+ * fail under contention).
+ */
+void *kmem_cache_alloc_nolock_noprof(struct kmem_cache *s, gfp_t gfp_flags,
+				     int node)
+{
+	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
+	void *ret;
+
+	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
+				      __GFP_NO_OBJ_EXT));
+
+	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
+		return NULL;
+	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+		return NULL;
+
+	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
+		return NULL;
+
+	ret = alloc_from_pcs(s, alloc_gfp, node);
+	if (!ret)
+		ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_,
+					s->object_size);
+	if (!ret)
+		return NULL;
+
+	maybe_wipe_obj_freeptr(s, ret);
+	slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret,
+			     slab_want_init_on_alloc(alloc_gfp, s),
+			     s->object_size);
+	return kasan_kmalloc(s, ret, s->object_size, alloc_gfp);
+}
+EXPORT_SYMBOL_GPL(kmem_cache_alloc_nolock_noprof);
+
 void *__kmalloc_node_track_caller_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags,
 					 int node, unsigned long caller)
 {
-- 
2.53.0-Meta


