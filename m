Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E68D6CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F0AC8E001D; Wed, 24 Sep 2025 11:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A1B28E0012; Wed, 24 Sep 2025 11:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 090F78E001D; Wed, 24 Sep 2025 11:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF36E8E0012
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AED8413BD97
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:28 +0000 (UTC)
X-FDA: 83924454936.12.D7708B0
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf07.hostedemail.com (Postfix) with ESMTP id B63CC40006
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="WuF5/HzI";
	spf=pass (imf07.hostedemail.com: domain of 3iQfUaAgKCDYbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3iQfUaAgKCDYbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ymn7hQz/pKJzXD8tPM+aagOUbUEwxLcJswgCIwaE8Js=;
	b=UTdTFYbgjpK4+PbArNmSyF2FwnlsC8Uk6X3mTGYvY3dmlfVpPwavr8vLAfopfxn1SkCZyc
	C/IyV/gjVITsTxLTeSGnCb7TzhrM/Mfp66Vev5/y2a5gDI4Zg51rl8WFHT9hqjXUhYmUdj
	czY+pZZjGcAgd4WgVdlP433NweKNdW0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="WuF5/HzI";
	spf=pass (imf07.hostedemail.com: domain of 3iQfUaAgKCDYbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3iQfUaAgKCDYbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726026; a=rsa-sha256;
	cv=none;
	b=X9HDnbK//xOAdn4LtIYjtSWeUYO6XhmSuHMQpGO8b72eB+uQv5b/qHZcnFXZ/BYjVa27Wq
	9atM0ZUvvDCKbm8LaAZQio1KD0Ct50/ZtY2IdkJ44c1oJroKIpqnZ1FFro6txAl00CZjk2
	1c3hgIbh+zmcvdgI1Tj/gQRJqOowtIc=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45df7e734e0so56609505e9.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726025; x=1759330825; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ymn7hQz/pKJzXD8tPM+aagOUbUEwxLcJswgCIwaE8Js=;
        b=WuF5/HzI9frY9qcIeUfmmJ/KU6E2ciBq5TI3ZWuXyI0Qg1sM0D956TenEh9jXZOJBl
         Jk/BZHlebuwix7GHFUEKUG38L38CI+sFUfxp8Vkz7ZAStxYOMBHJx7EeMpUa8J0vv1jO
         BQrs7lu1lm2S6OC2wJMluncU/g3R4eHoti3AmT36KQ8AXFMgfFtIq82x/IEaG5dkg+FL
         djN9ZgpJ0LLCyAHd3lH2muMygwSSbTCPslVSOk33Z8PAAauBXy+vZORxOoDD70nVYlNt
         bzDBdpS8DlTnaPeiZ0TV8coVTUQhosckbUQM4ExAJg/vRhy+xx2H26LeFQI3uHiQjSO4
         25nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726025; x=1759330825;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ymn7hQz/pKJzXD8tPM+aagOUbUEwxLcJswgCIwaE8Js=;
        b=p23jTObn/aB6BFTsLDiRn+LcFV7qUeFVl/NhZ8iM4MMoQZrQe5tw/vjjVrKDIk/779
         b3/MEVOO2kRHGcylyT1Kr0a7XVOgqsCqWPR5HbsYIpnR6hk6C/sNKS4LtxSc+C5rauAh
         /JfTIMwgjyUqlgCqcgJMDCmShDgPBqojnh6AFd5MKjHEJD6eQ8sQJdNSdw8BGXXT2+Dj
         oaSU9mhxrArhGgSlttQ+hVd/qM3ldy0PgZSJYI8wFa+IaLKWL93IH9LH5Z4bFhyzC+k0
         wyLLXrM2SslWPU681WIv8KjfdPn1209Uf9WBka7j1VnTx8qgNwhiHeadY+dqnHdnwRgk
         7uJA==
X-Forwarded-Encrypted: i=1; AJvYcCWhSThV9q0wH9BTHRoeHumpmGNVeRlx3LD7mg1eC95daIwBT22Cm2wrP0wxYur4gYphdaeFCt+Y5Q==@kvack.org
X-Gm-Message-State: AOJu0YxtUO+YxRAhnmDqOa13O5XELwleT52ZK6NMcHJz6sk76dOyuF+b
	VQq5THGIfmhn86rWQZ3cRcPxKnhOGaaogB4qzCs4rAUkJ8MLkMrUJk9rkxlkt1GkIMfnI2bmJGo
	Fypi8ZOSUXcnplQ==
X-Google-Smtp-Source: AGHT+IEpWYX5czTdErtD0ucu84grAEj2tMZftfqJQYBrWaTJqn3fb8Jtio2hFIBWofbJn4+DEL2AmWmtTqntmQ==
X-Received: from wmbgw9.prod.google.com ([2002:a05:600c:8509:b0:46c:8b6c:6cc2])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:46cc:b0:45d:7d88:edcd with SMTP id 5b1f17b1804b1-46e32a030cbmr1610275e9.30.1758726025028;
 Wed, 24 Sep 2025 08:00:25 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:52 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-17-2d861768041f@google.com>
Subject: [PATCH 17/21] mm/slub: defer application of gfp_allowed_mask
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B63CC40006
X-Stat-Signature: hirmzufeqh91ucf1zcx3t19f9giiu8j8
X-HE-Tag: 1758726026-803495
X-HE-Meta: U2FsdGVkX1/4TAcEyNUx1DB06PXylfjalE75XSaJQN86x/r1m0OUM2cc0nMOvDoSukbf19WO9FEASqIBlXtf05oPjJmrVVBKHDGAFHJzL5CUActRZ/IWk8aQIlmRr9Tjz+bmkZ+U87YrtN171qSrcLcX1UTdLSSkeyKdaAupYV+QG2w5XkwUesUamrAmCqI3pO9BG4j7Ryk2tyhEL0QUhT52wmyU9iSiDhbN24ss8vQwTwQSXjKXN5hXy22XZUteYYvBdcaQmYtnN5l60/4lLkvGwcyiTy7idQQmMtxwrKn0EUHshjlDyVxav0JQw6czj3lPLHZtvFOAiKH/+TdGQhtXzKsjDQvZhL25wZ1E01m8WZVSiFIsF0oE1ofh534esf4LwK0sxlz+v4az9e2PaQZAYxQpyyPe+O8/hYy//u8CpctvHNV20MBK0rgDM8PdqkntnF7HR6UNn9F79ZEbDXamvzurdbqUBx9a8w3fLLAQ/C+Jfd+Szr3asbhEewZbV4nUfcrScJUlydx7foMBRjyXko+W/45IN2qLAIaX79LYpvp9pkjidnFTUQBf6XaTtEA40x9nYpaUTVhn8BrisJLs+RkHmBevIV1NytY4c643mqNHPVUJP29pR1KpODCngt4tT577rL26ABLARZoueHzsnp8NboNETh5ft46yQQUS9lEB8/tDyBc74p3RN49SDl1ujuLljq/nI8Vo3uCOcKflmOvySg/QwFeGB55HlXy/ICBhufUJVWLxYMku8UzbHXiONgAqBKJjDatmpeW4XtKEDtuu5C3xmdMWCS2183zFnx+eHaE6X5royVQCtn4j4JbvSH0bVmsUur9f3cB+QZ1rou3+ybD8ce63vttRnEJnmtAvjt1Co1V7aFPjMyLX7yHxoQZg31VRJtR1+wi48IzBT/gUSuPnODr4Z0rCjednH4sMCF831A3t9BMm51HEog/vfuVIG+MjcgtHVT4
 ZXp/ZVpB
 jABZ301Rscen2NCSdiNXJFZu3qlmkNhqyD506UQvIzbtWpyHzhgx/C+A/uDCYVysbMBMiafDDrMoIBXlJ6HP39Fb8jMOmyolwh4+ameLYdH5Lphw8TllFAkA9vQC7dqzpauYrn7Do6dk1K/u9lNHGQ+84YVFcfvIXoDdCB7WvmIaDz0kdoWGkwlnSc/P7Yvp0Gm8dlyuTxZfC3jG8elzeW862mkV7cVTIGgFlQDXsJ8G7yTasRZZV96pw0ujSzMAG0gXsMsCcXshh9j5CsTUD5Kqp0J0kkVQK97fj3PwiTRGy3yYqdAs+au9RUU0cGRzyKNLHxdlz1PlN4U86sPOjyzliuyQDAko9k+evUN9Z4+tyh4iVn2dBYFW/zL1zW7d1foqUX4vVomJmMhM0PDgxLvtozgK0EchJ9C8L3RS//9+9RzJoGG81S5dyxwR7mOjTqPLzV2p1JmWf9ccWwlebj5FiBTlEbHAY19vHJr5+YCtyOR9cheA8GxkcT0A35cexGgmjb9egYTiLXRiNqHBY/H2YJSkwaKICMXK+JKzgdv+dxjRgoA8hSMobb3gRmOY+lnRTbRznFJmP9sKG2IqqQWvoVB0mQH1mln6apA1uQLV3m2Q/sver4NONIi3qBgnQAfYIuFXMbM2Dc2Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page allocator will take care of doing this so SLUB doesn't need to
do this before calling into it.

The page allocator will soon start using the GFP bits as a proxy to
infer if it can do blocking stuff (separately from whether it can do
actual reclaim), hence SLUB will benefit from leaving
__GFP_DIRECT_RECLAIM set even when it's forbidden by gfp_allowed_mask.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/slub.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 867a07260acf9e3c0f92de66e2d25f081ae51dcb..0f8724af4ce63f6e2a32e889f6490be7a25823eb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3177,8 +3177,6 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	int idx;
 	bool shuffle;
 
-	flags &= gfp_allowed_mask;
-
 	flags |= s->allocflags;
 
 	/*
@@ -3212,7 +3210,7 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	slab->frozen = 0;
 	init_slab_obj_exts(slab);
 
-	account_slab(slab, oo_order(oo), s, flags);
+	account_slab(slab, oo_order(oo), s, flags & gfp_allowed_mask);
 
 	slab->slab_cache = s;
 

-- 
2.50.1


