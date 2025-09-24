Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ABE7CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6850E8E0013; Wed, 24 Sep 2025 11:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65BE38E0012; Wed, 24 Sep 2025 11:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 524DE8E0013; Wed, 24 Sep 2025 11:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 439E88E0012
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB4DF1608CE
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:16 +0000 (UTC)
X-FDA: 83924454432.23.2F55E89
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0C340180011
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="CC/2Riqz";
	spf=pass (imf24.hostedemail.com: domain of 3fQfUaAgKCCoPGIQSGTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3fQfUaAgKCCoPGIQSGTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CX5Q5YH/plIL1ST5QoPko2JUmjdnIY0LBvORLR/qltw=;
	b=HE0S3aINKk45LKdES5eUAcp4L/RH8V/Uanicta8tS5sY7/N1cZMYyrsfMm4CxxlfXTPj8W
	t52w3uueX1SgiRUqne1tj9dwepIi5/4vU8Bzg8G8RnmfrgpnglPEntiKxx0WqNskUA+jdU
	acsDbP2jT3YE4jNw3Lzg6S/YzfSh8gQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726015; a=rsa-sha256;
	cv=none;
	b=irn26rK730rIMqHRvwFs/vQ26wE9DMBDGlp6nL5ouMtmRyhD/5H0MDVZKEpYXMYowYwWGJ
	u6evw71s2vDc1EUaNRLXvF3AUL9MTME3RIaWHOCjeoJyMyXKKC8Ypa9v9CLQQpCAQpvxGS
	WrbbsHadPYQKok0rWVjGQHdM6kZWddM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="CC/2Riqz";
	spf=pass (imf24.hostedemail.com: domain of 3fQfUaAgKCCoPGIQSGTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3fQfUaAgKCCoPGIQSGTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e2c11b94cso5443615e9.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726013; x=1759330813; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CX5Q5YH/plIL1ST5QoPko2JUmjdnIY0LBvORLR/qltw=;
        b=CC/2RiqzqwZS6HETapVF6t1YevJPxHgNr7JLG8faJEaG+CCOG8ijjLXj7KEDq56JrR
         wiIABoBeInc9qq99Zz9u1XjiPWyCMsI9sg8z4q24hZyT+MJ/61qPXtyuwgdOT7wwaJ2+
         YyAYT4o1tiL1VHERp3BEZZ+PifJrwumUiz/wckMViKFF1+w0DlV8lQ+mEqcXuGebNNaN
         4aoBniIn2HAvW4SSjmLG7ln8frirXQB51OPuZcsJqb+8b0SSAgb6543JBK2+/3jNR2dn
         q5f9wxVnFS4z6lSwZtrHxPEal4KNDq2pfF3wxsBieOvdS4sNixhx2RcsviHi0Q/CpBJk
         6H6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726013; x=1759330813;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CX5Q5YH/plIL1ST5QoPko2JUmjdnIY0LBvORLR/qltw=;
        b=t51MptNe5uxUFUkntRv581zrNcW4+ipqcVSkWd2yafKXfaiRrU9FKCQmOBgOkFkHPL
         570s6k168HhCYTeF7VZ//vM1kGz/Ypj5a1Tfg5MXeZWxXw8yT9OjJzsJLRyCxOFQu4Sa
         i4GaLQJE9kDU8JdlqKc/jUtScLOCFUlzENxzXbKh5m/Wu56BcQ5rQgKo/bHwBKMVkmUG
         wrn+p7nhD2KdkzDms66KWFW4TYSeqIbFKavGjeNDW+0Q4kNErpmjf7DWaqjV/s1ShquK
         cOaBAm6emWZj8ed4ZLGnI9KiudruwOlNx1MpVZpJxd+dZNQ3khVChELeQ8515MLcfx8d
         7LXA==
X-Forwarded-Encrypted: i=1; AJvYcCX6v6/PRbxk/1YHTqj5y8EnYEBr7WrM/KxwuJJJlYNTdoMsl1tTGrZ04WDIJk/CngiZzdC5hjTdow==@kvack.org
X-Gm-Message-State: AOJu0YwlP1M5N7NlCp5yVkkLnQG57iSi+z6d7LwcfMlN9aA0ky2h4VSV
	PY8+wcqZu1FRO3bR0fMgtyYaqGbM+frRzWw2yFvaicAvzphwQFus/ZuKGxuaH0INkV3bija8wcR
	QhZ+lKzzJlJQkqg==
X-Google-Smtp-Source: AGHT+IH1z5403qKBJ7o7GKoFaP/RUEDwuiU+FQ2BI25kf1Pv6Ap4eL3k4PLg1ZIY6q/Lrj8v/DOCur38GOqArA==
X-Received: from wmbdr13.prod.google.com ([2002:a05:600c:608d:b0:45c:b682:883b])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:17d0:b0:45c:b53f:ad9 with SMTP id 5b1f17b1804b1-46e32a1919dmr978105e9.33.1758726013525;
 Wed, 24 Sep 2025 08:00:13 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:41 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-6-2d861768041f@google.com>
Subject: [PATCH 06/21] mm/page_alloc: add __GFP_SENSITIVE and always set it
From: Brendan Jackman <jackmanb@google.com>
To: jackmanb@google.com, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org, 
	david@redhat.com, derkling@google.com, junaids@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com, 
	rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0C340180011
X-Stat-Signature: iw4mraq6w699ny97kgd1b6gg9ok8o44b
X-Rspam-User: 
X-HE-Tag: 1758726014-610849
X-HE-Meta: U2FsdGVkX1+SIwmbyCwqIZU/8EGrHY9McXGSEHvetvNClvfOal39q/Kb1GAEZ/wgCZi2lC+SCCatcLY2aEBLO3N0n9E/3I2TDEUW1Q1NXXBDpTPgxO5sQTryyFamIIhB3tHcRmdxLts0oLqTaMRATyyhMLXV26xM8poQ/YuYfNhlyetvGr4xxauWZgX3iGMEfsiGWffQi45/q+lzSOvlgDXsJDbZb2Dr0lhlenECR/QDA4+eMqM4hU8DJWMZwM4Vc+/B1W9BpoaFulZxSt7paqYZuJ7JRDgPewFSKpovEz7ebOTGMT2ix/HMS3kfpAkwQUXGjDA3XqSsDXHN3RgSmhtFhxHxfbaRbnpBrSVR5RZRLH3ZIVq36sBr0z9hY8AuUvduaEqztRSsZ08OtGXXWNMaPFkDSWj3bDAOWqclrDOT5W0F3K+1uzXZisdbvirgBbBI1eLHShUEWWOWzTevSA/q0ZW7KbgNaZ0/1T1ClWEOKwFUqlr2Bkrs1e0RJmkZQuPr1wSH1iDfvJvlZgFq8XtYP5hna3RTT9C8Nb0WNwXpcoUZZhZ2vixuR3vaaI0qZWM8bFH3yehH5TXH8NouIyJDm/5Yb89ZU3Bpl2i7JmOrUnhexbdnc7XLb23IqUcy5C6jPkqRy/FEZ2w4zaPVM3I9yJbP5RdFonvWwJldySBkx1/fzxWhpa6kfzKVvI+Y6CW9f7Ffh03HUPh6mBQWl7/3ZRpoLOp9twEPSjmIjG6W4OnWY1a49sDnYIgb7IdxzhleojDtWIvGGs4CWqRx415+RgoArSvEVqjXGVENQXBMgu8524Mgv4E57S0yE9o6EoylOd1woHjunNi9fdqXW7nIrQsApBUHlvLgFYm5/wbOVW70b0n4ysDhOmnWXS/X4wYRTghTRH0Ga4NFuQiJuvja2hpHZ431io67g91/gjdaNDNOMDFVAbBr5nt0D9i/UbK9odatGtIKJIv6wEn
 xgB2KGWS
 9HLaOtPtmTBWsY1vZQG8eHj/gwWwOQUjQnTXiWa3CU0JXYB3bUONC/GyEmHlUxW5VJCGMR6ZACGjrHH4H1ITM65sJkeLJqfptEgoTUmHcxCfatw7ZBQhZzHW6aUTDfnSEBCCa4fmO76HGLSScpw2+Hhc9f1j9c2ZFu6Bq8wxu1lNMZVk8nKf46aZbd02w1rwVw5Ipxbu0m15bWUO4EPhSajIB3zYZE5NTbkkzM3DQ/7pf5h6ip+0EiFQr/xYIOUQmM2Saae0yGeHoIywawbmXGqL59hGDT7pGZ48o4/h89IMNpmGdiDRpGYIyaCHV4w1lKfLCIcyDLs2oxObhwWFy08QpoK37L3Wtg5KYaCRIqAsHql+H2ZkzlQ+mqTygprN/I8HiZVpebWuLZd/nmZBhJF2+7R9ask1oJ+bT4qMqSxyV1vTux4rRQa2rHmf3+FxAeGvOgo8mS6qT38GogL/yMGrKJugN0gRcpLcRpSlzArijyUPKodl1fJqx06zmgiWcnYnfyA8AIdlwmXXx9BcPiG8ToFMZr0ZjVdKeENYg15GDcuL7BVyHubmBEkRZYFVCtIY7ugnAzmxZ0LLaqAUJuiX683R0/b6YE1fu1ZXFEVkd5vc1pSorcUhiFr3SyKZxHZY6pxzOmPSKW90=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__GFP_SENSITIVE represents that a page should not be mapped into the
ASI restricted address space.

This is added as a GFP flag instead of via some contextual hint, because
its presence is not ultimately expected to correspond to any such
existing context. If necessary, it should be possible to instead achieve
this optionality with something like __alloc_pages_sensitive(), but
this would be much more invasive to the overall kernel.

On startup, all pages are sensitive. Since there is currently no way to
create nonsensitive pages, temporarily set the flag unconditionally at
the top of the allocator.

__GFP_SENSITIVE is also added to GFP_USER since that's the most
important data that ASI needs to protect.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/gfp_types.h      | 15 ++++++++++++++-
 include/trace/events/mmflags.h |  1 +
 mm/page_alloc.c                |  7 +++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 65db9349f9053c701e24bdcf1dfe6afbf1278a2d..5147dbd53eafdccc32cfd506569b04d5c082d1b2 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -58,6 +58,7 @@ enum {
 #ifdef CONFIG_SLAB_OBJ_EXT
 	___GFP_NO_OBJ_EXT_BIT,
 #endif
+	___GFP_SENSITIVE_BIT,
 	___GFP_LAST_BIT
 };
 
@@ -103,6 +104,11 @@ enum {
 #else
 #define ___GFP_NO_OBJ_EXT       0
 #endif
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+#define ___GFP_SENSITIVE	BIT(___GFP_SENSITIVE_BIT)
+#else
+#define ___GFP_SENSITIVE 0
+#endif
 
 /*
  * Physical address zone modifiers (see linux/mmzone.h - low four bits)
@@ -299,6 +305,12 @@ enum {
 /* Disable lockdep for GFP context tracking */
 #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
 
+/*
+ * Allocate sensitive memory, i.e. do not map it into ASI's restricted address
+ * space.
+ */
+#define __GFP_SENSITIVE	((__force gfp_t)___GFP_SENSITIVE)
+
 /* Room for N __GFP_FOO bits */
 #define __GFP_BITS_SHIFT ___GFP_LAST_BIT
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
@@ -380,7 +392,8 @@ enum {
 #define GFP_NOWAIT	(__GFP_KSWAPD_RECLAIM | __GFP_NOWARN)
 #define GFP_NOIO	(__GFP_RECLAIM)
 #define GFP_NOFS	(__GFP_RECLAIM | __GFP_IO)
-#define GFP_USER	(__GFP_RECLAIM | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
+#define GFP_USER	(__GFP_RECLAIM | __GFP_IO | __GFP_FS | \
+			 __GFP_HARDWALL | __GFP_SENSITIVE)
 #define GFP_DMA		__GFP_DMA
 #define GFP_DMA32	__GFP_DMA32
 #define GFP_HIGHUSER	(GFP_USER | __GFP_HIGHMEM)
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index aa441f593e9a6b537d02189add91eb77bebc6a97..425385b7f073d05e9d660ad19cb7497f045adfb7 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -100,6 +100,7 @@ TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
 	gfpflag_string(GFP_DMA),		\
 	gfpflag_string(GFP_DMA32),		\
 	gfpflag_string(__GFP_RECLAIM),		\
+	gfpflag_string(__GFP_SENSITIVE),	\
 	TRACE_GFP_FLAGS				\
 	{ 0, NULL }
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 600d9e981c23d75fdd4aec118e34f3f49d3de2e0..0d1c28decd57b4a5e250acc0efc41669b7f67f5b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5152,6 +5152,13 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
 	struct alloc_context ac = { };
 
+	/*
+	 * Temporary hack: Allocation of nonsensitive pages is not possible yet,
+	 * allocate everything sensitive. The restricted address space is never
+	 * actually entered yet so this is fine.
+	 */
+	gfp |= __GFP_SENSITIVE;
+
 	/*
 	 * There are several places where we assume that the order value is sane
 	 * so bail out early if the request is out of bound.

-- 
2.50.1


