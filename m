Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403BE109024D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:08:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76E026B053B; Thu, 19 Mar 2026 12:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 746FA6B053C; Thu, 19 Mar 2026 12:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C0D46B053D; Thu, 19 Mar 2026 12:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7536B053B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:08:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E94358C186
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:08:29 +0000 (UTC)
X-FDA: 84563295138.18.E55211E
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id EBC50140015
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:08:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=phjBDdAV;
	spf=pass (imf26.hostedemail.com: domain of 3eh-8aQgKCP0ofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3eh-8aQgKCP0ofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773936508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rjopGIRqFFR8FL/MLwWIQbXbXtXyPbnj+84kMxSBPQ8=;
	b=oYXS3HprQL46l/asHm9ZOWHroaspmsJXnGMOOwCHW6Rmghp3zD2cp5JtGiY4bL1IwZ3zZL
	duOnvKzjgQ1Au6o08/FmNFRbdq5AXQflOdvXMw3992IOEGBWHnW0M4rF0bvmMuCYa+I4NO
	wnq3eL0IeMmes8TqzqrzaWuYKYHLHFg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773936508; a=rsa-sha256;
	cv=none;
	b=RYElCNPSr8Tv0mnyZMwFstg4NDBad5KLdAMHy4oiZp68K7TX+kfuf2cqhR3twE0v3UhArM
	9DGRRvITV0oOxLQpOiX0HjRZ7I53EweVXQ6eNtThJIqY097SO/Bx9CNLhcEsteRBm4/6N6
	2vx3mgHlmceTc4/HzzzkX2HSBIT+h3Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=phjBDdAV;
	spf=pass (imf26.hostedemail.com: domain of 3eh-8aQgKCP0ofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3eh-8aQgKCP0ofhprfsglttlqj.htrqnsz2-rrp0fhp.twl@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4852cf0318dso10429335e9.3
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773936506; x=1774541306; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rjopGIRqFFR8FL/MLwWIQbXbXtXyPbnj+84kMxSBPQ8=;
        b=phjBDdAVLAJ4WRW4HZ26u7Qr3b1ZtoIX4gvnR3S9SQkT8egDUPSCj6tKIiHslHCMLf
         JQnw93XRFw14i+S+najDKvIT19VamgQ4Gf39T4UFoMLzP3eQyaVxw/nfYPkypccpbtOs
         kPwd5RR+047gkoXj3a8Jie62I7TRJb216KgAMjGwxRZe0WemsvKYhDIqDi2XXtHPW97U
         BQHwpDSK9bOIod8Y20Kf4eLGkzK8VUJcSb510NKIJsYWN296Xn55qF5unzq8TpVn81qO
         rYthjMe/WSxzpyXltJQJeGdFFHv1Lqm0ZYivb/mjrsG4pbILXspH5HrPeKXjOchZUQq8
         cvjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773936506; x=1774541306;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rjopGIRqFFR8FL/MLwWIQbXbXtXyPbnj+84kMxSBPQ8=;
        b=rTpDYxT5xkmS8qmWrWvneQYq3uQafNlp+9+PIVZbjCdEz+PiSng75bszbHKRmvdm2P
         jVsIKnQ4E+iX8Ed8HKBkVB3Mn1NC4IIKmT9OTXhiB0K3hz6AcC0DFbwWWgxMzkmZXZz1
         5pTwsCSOppgCe4cfrhUWc/S1IsilQWUMg0S25mt7/qFXFZ7hxzT1t7LweCHQFWeh5vXJ
         JflmMTA7jtd+qJZ0AYOY/n9IQEE0gtZgAqKq1Ug+DQu/mKKYcRfPKadYQz+kU0rpChOd
         ZJ75wjl/w7B2rWCiIPTbSbTzvrmmAWRYJUcChk/fBQZ76clMifwZlgnlSFLndASyA3pO
         W4QA==
X-Forwarded-Encrypted: i=1; AJvYcCWV9gGVHVWNcoiDIznzZcqGfw6AOwK6J+huQC/cgRXbXe3KcoD7qzn+7vLWyjWAPWO1Jv0bOx59fw==@kvack.org
X-Gm-Message-State: AOJu0Yzbt9T8mRiuTIBgAUyJMdbKjR9mm20sCmkF8VDI1CRq7AzCHa0a
	yOHg2XPglarnd9LrQmLIR85UPkT4aQTytRcAZ+TrX2jDGMLOLF6MBC5taeXrVz8B54Pb4VlC6rR
	qaPRg0Eg7vzRkKQ==
X-Received: from wmjq10.prod.google.com ([2002:a7b:ce8a:0:b0:485:2cf0:2668])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:810c:b0:477:b642:9dc1 with SMTP id 5b1f17b1804b1-486f4475342mr130632885e9.20.1773936506286;
 Thu, 19 Mar 2026 09:08:26 -0700 (PDT)
Date: Thu, 19 Mar 2026 16:03:28 +0000
In-Reply-To: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
Mime-Version: 1.0
References: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260319-gfp64-v1-5-2c73b8d42b7f@google.com>
Subject: [PATCH 5/5] mm: Change gfp_t to unsigned long
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Uladzislau Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EBC50140015
X-Stat-Signature: j67yju9t3xocisssj6egynoxfhkhrjjy
X-Rspam-User: 
X-HE-Tag: 1773936507-50079
X-HE-Meta: U2FsdGVkX1/6AJWb8TkXJm5qAvy51kyZ/t5PIuSAHceeqYFlGus8u5/JLdoD1VgcDkgSIcZTs7Cjsw/deQuNvyfgVPnuenRfviUS6w7YUFLqBp9goTLqJ+pbWsDlaxAvQ2sQjQtmtxNERGP8soo2RRiSApnZ8YMjUgnKpVbMvzFBG35Owun7CJFbAo9TiVQ+YxPUh1jVuFLp+sdjU39EHP7/iLoLp/p7e1ZuyZeN6JdOB5qASUO2nh2+O3dJD07k8ZYumySkm1EpzzMZpT/NEreiu4PKfq1jQ1Sj722dy/NK+5fc2j1Eo7xAN0CBhx6rQ1RcuO8rfJnWFKCmwe8PnLKSdhAMaft7qDef92OPnwa0Vksftv/EsfBnxzRhdFKffz83+B+3bfd8qbY1RW1haUsQrBg30DDywWshbFA9mHJaJAfRDdLec42990GksCjRAOXDyI5U2n9V2N6u62x3ODnxCkM1hJ/SZlU3pEdr7982PguFVooEwU7XKBggmppq6BMIQGXwtPzLbr6nBu5anvGjfUNnOekh1dLq/UosPpLH3W2rMGjHoIhRaa354ak1QwMDDMJ66n/0SxBjws93jKt9qI8j2i3+OMhsZnq7ejgTaCikYNEAJ0AKa2mU0pjTW9U29AYsvNmQ4FXD/mFm6OEgEPwwzW3ycb9rZtG5XPEMge4ESS1TKIzyw26q/vKaPIh02DbBJf8iClRW7qgf9j/7jv9xNn2QYRMTkOHVe/JXDptMwVlWZhC+0H/idonc6jomjlUxL0oWePmfBWlyJQOfmzp8eqQXkE1LsZ0bSgq3z4GYXSD1rUzbKr2Y5lxuZbJZHZnlQwdIKaP47gJD0hrM1ScgbkY0doO+P3ao5yiY/eBO9tnQr6xPsDPJvcBpMkArVvURJyLG6fTxLX/hJzwJ2iZ4zyfDnCy6esGbVd7hMY2m3MoFKMXGctoAv4aQxMGjY/sJUGwa1N8bjGT
 7GtzAfih
 L4LpTh0+3o1M384X09LC4nVwOX0ajYP4Ga5+vQRdlgW9trE8d4ArpU5/1Om0w7voDqpAHZDjYD7LLFTu2h9iM9XN7w+T7ayDvaJsadguDP8zU1Xzkbrdm051LXjh2ieVJ9+UXDgnIaS8Al+U6caYyjroAyHMgBLbIZPSvYKwg7pXaXpHsXsq0KeobBQJx+qBPyVZzw2IEBKRqhY+/tn0v5Rx01w82stieHdxTUdnOFL7OTXYC8esSZ1Xsczs6EUbvU1Ek9MUIWrL8UPRCpPzq/Zx94rUpzd7Rml/QWQtSDKB0FWz17txsz9zJ4HCIyWsuslSdxXDutS7H4GOqegM9wOlBIWpf+u++Bn5vS27msO+Bw3rBzyTOPKNQzOctqDfjsENAUnUXPGOj3S3S12/7cwGW3F4uNwdq9qeT/CKStOW58zUey0LaO4npJLNDop6kd+ULGZNQ1rZ1r/Km/PXUIPbWVJ1luqx3yq5lGXLuJ45KULF/SvSTVAswAYNYBxo1tlAKacQ1PZhRV9Ogi7/8LIRR9GCEXCX6r9le8pOVfS5ZwgWeJ3KMrabYLTOep39N8fXk3FOhuAUEWwtCVM282YuDmUm11aY+AkGiU+hcUIkPugs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

GFP flag bits are starting to get scarce. There are upcoming features
that can tolerate being 64-bit only, which offers a simple way to escape
GFP bit scarcity: just make gfp_t 64 bits on 64 bit systems.

Update mm-internal printk formats to use %lx - external format strings
have already been decoupled from the size of gfp_t. Also
lib/test_lockup.c which uses the arg in a module_param_unsafe()
invocation where gfp_t doesn't work.

Some care needs to be taken here with code that converts between ALLOC_*
flags and GFP flags since the former are still unsigned int. The current
code is fine but just to be safe, add a BUILD_BUG_ON() for each GFP
flag that gets converted this way.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/types.h | 2 +-
 lib/test_lockup.c     | 2 +-
 mm/oom_kill.c         | 2 +-
 mm/page_alloc.c       | 5 ++++-
 mm/page_owner.c       | 4 ++--
 mm/slab_common.c      | 2 +-
 mm/slub.c             | 2 +-
 mm/vmalloc.c          | 2 +-
 8 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/include/linux/types.h b/include/linux/types.h
index 7e71d260763c7..a8490c1381f99 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -160,7 +160,7 @@ typedef u64 dma_addr_t;
 typedef u32 dma_addr_t;
 #endif
 
-typedef unsigned int __bitwise gfp_t;
+typedef unsigned long __bitwise gfp_t;
 typedef unsigned int __bitwise slab_flags_t;
 typedef unsigned int __bitwise fmode_t;
 
diff --git a/lib/test_lockup.c b/lib/test_lockup.c
index c3fd87d6c2dd0..7adc03ac0b39d 100644
--- a/lib/test_lockup.c
+++ b/lib/test_lockup.c
@@ -130,7 +130,7 @@ module_param(alloc_pages_order, uint, 0400);
 MODULE_PARM_DESC(alloc_pages_order, "page order to allocate");
 
 static gfp_t alloc_pages_gfp = GFP_KERNEL;
-module_param_unsafe(alloc_pages_gfp, uint, 0400);
+module_param_unsafe(alloc_pages_gfp, unsigned long, 0400);
 MODULE_PARM_DESC(alloc_pages_gfp, "allocate pages with this gfp_mask, default GFP_KERNEL");
 
 static bool alloc_pages_atomic;
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5c6c95c169ee8..272ecce090f75 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -458,7 +458,7 @@ static void dump_oom_victim(struct oom_control *oc, struct task_struct *victim)
 
 static void dump_header(struct oom_control *oc)
 {
-	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), order=%d, oom_score_adj=%d\n",
+	pr_warn("%s invoked oom-killer: gfp_mask=%#lx(%pGg), order=%d, oom_score_adj=%d\n",
 		current->comm, oc->gfp_mask, &oc->gfp_mask, oc->order,
 			current->signal->oom_score_adj);
 	if (!IS_ENABLED(CONFIG_COMPACTION) && oc->order)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554ed..f0b9e8a950ee7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4036,7 +4036,7 @@ void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	pr_warn("%s: %pV, mode:%#x(%pGg), nodemask=%*pbl",
+	pr_warn("%s: %pV, mode:%#lx(%pGg), nodemask=%*pbl",
 			current->comm, &vaf, gfp_mask, &gfp_mask,
 			nodemask_pr_args(nodemask));
 	va_end(args);
@@ -4504,6 +4504,9 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
 	 */
 	BUILD_BUG_ON(__GFP_HIGH != (__force gfp_t) ALLOC_MIN_RESERVE);
 	BUILD_BUG_ON(__GFP_KSWAPD_RECLAIM != (__force gfp_t) ALLOC_KSWAPD);
+	/* Alloc flags are unsigned int, gfp_t may be larger. */
+	BUILD_BUG_ON(___GFP_HIGH_BIT >= BITS_PER_TYPE(typeof(alloc_flags)));
+	BUILD_BUG_ON(___GFP_KSWAPD_RECLAIM_BIT >= BITS_PER_TYPE(typeof(alloc_flags)));
 
 	/*
 	 * The caller may dip into page reserves a bit more if the caller
diff --git a/mm/page_owner.c b/mm/page_owner.c
index 8178e0be557f8..70afbdb945b1e 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -558,7 +558,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 		return -ENOMEM;
 
 	ret = scnprintf(kbuf, count,
-			"Page allocated via order %u, mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu ns\n",
+			"Page allocated via order %u, mask %#lx(%pGg), pid %d, tgid %d (%s), ts %llu ns\n",
 			page_owner->order, page_owner->gfp_mask,
 			&page_owner->gfp_mask, page_owner->pid,
 			page_owner->tgid, page_owner->comm,
@@ -630,7 +630,7 @@ void __dump_page_owner(const struct page *page)
 	else
 		pr_alert("page_owner tracks the page as freed\n");
 
-	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu, free_ts %llu\n",
+	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#lx(%pGg), pid %d, tgid %d (%s), ts %llu, free_ts %llu\n",
 		 page_owner->order, migratetype_names[mt], gfp_mask, &gfp_mask,
 		 page_owner->pid, page_owner->tgid, page_owner->comm,
 		 page_owner->ts_nsec, page_owner->free_ts_nsec);
diff --git a/mm/slab_common.c b/mm/slab_common.c
index d5a70a831a2a5..548e0d0f9aab3 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1028,7 +1028,7 @@ gfp_t kmalloc_fix_flags(gfp_t flags)
 	gfp_t invalid_mask = flags & GFP_SLAB_BUG_MASK;
 
 	flags &= ~GFP_SLAB_BUG_MASK;
-	pr_warn("Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
+	pr_warn("Unexpected gfp: %#lx (%pGg). Fixing up to gfp: %#lx (%pGg). Fix your code!\n",
 			invalid_mask, &invalid_mask, flags, &flags);
 	dump_stack();
 
diff --git a/mm/slub.c b/mm/slub.c
index 2b2d33cc735cb..083f4e9de3ecb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4235,7 +4235,7 @@ slab_out_of_memory(struct kmem_cache *s, gfp_t gfpflags, int nid)
 	if ((gfpflags & __GFP_NOWARN) || !__ratelimit(&slub_oom_rs))
 		return;
 
-	pr_warn("SLUB: Unable to allocate memory on CPU %u (of node %d) on node %d, gfp=%#x(%pGg)\n",
+	pr_warn("SLUB: Unable to allocate memory on CPU %u (of node %d) on node %d, gfp=%#lx(%pGg)\n",
 		cpu, cpu_to_node(cpu), nid, gfpflags, &gfpflags);
 	pr_warn("  cache: %s, object size: %u, buffer size: %u, default order: %u, min order: %u\n",
 		s->name, s->object_size, s->size, oo_order(s->oo),
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 61caa55a44027..e353e281fa95d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3949,7 +3949,7 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
 	gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
 
 	flags &= GFP_VMALLOC_SUPPORTED;
-	WARN_ONCE(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
+	WARN_ONCE(1, "Unexpected gfp: %#lx (%pGg). Fixing up to gfp: %#lx (%pGg). Fix your code!\n",
 		  invalid_mask, &invalid_mask, flags, &flags);
 	return flags;
 }

-- 
2.51.2


