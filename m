Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 309D5CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 23:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58DB38E0009; Tue,  9 Sep 2025 19:49:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5371B8E0001; Tue,  9 Sep 2025 19:49:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 425378E0009; Tue,  9 Sep 2025 19:49:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A3258E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:49:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC3B116070E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 23:49:47 +0000 (UTC)
X-FDA: 83871356814.01.6B4E2E2
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2AE891A0011
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 23:49:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DzcRMzQ8;
	spf=pass (imf19.hostedemail.com: domain of 3GL3AaAYKCOEVXUHQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--surenb.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3GL3AaAYKCOEVXUHQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757461786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nWhDazcpSKC+AMTc7oUhp0RNtPqVbOFG7KBfwJ/eX+U=;
	b=JYng0hC1vzPzTpTHU6BdpSDhv4AAYBm1kKF/6J0RC1KSEJdUkX+F3jYX9OR/ZixK7tsj//
	GjhHcaFE5ArQIoD95/xcjgC6r5JbgQgekmKY0w7T+/MdT3Sz8Go+giYLOVZKq/xAGcWwza
	fH2TUMD/Y2NG8WWmDjalvFKDLh98TBU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DzcRMzQ8;
	spf=pass (imf19.hostedemail.com: domain of 3GL3AaAYKCOEVXUHQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--surenb.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3GL3AaAYKCOEVXUHQEJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757461786; a=rsa-sha256;
	cv=none;
	b=D9r/mVEHOzeT5JqA9oLSFB2m/Q/ACBsGDdgdCjhe0vhMFKGEkTSb7OiEewlH6ArIBuCzq4
	765TEPgINvEJLZE4ZPuOg716m3u/YAldNM1nT+wtzIS0oI2Tyi0A7PX4vAmEo3p43MQU1E
	uCYEWzhDfJs9Ms+bwE/qAfDZOOqs9gA=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32bbacf6512so8905452a91.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 16:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757461785; x=1758066585; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nWhDazcpSKC+AMTc7oUhp0RNtPqVbOFG7KBfwJ/eX+U=;
        b=DzcRMzQ8YbE21IJWCc866UHe6t6JQA0eQPW+Q73R5fPPlHeSrD2XQQ7LkowOz6R96l
         oTh76Rzm0XUnshqRCrl7k20Ej+wA4YjTOKMrDKMnKqmbmgzUqxYqj4c5XfGsj7fq17Ut
         78NlbcIAyz33Bi98p1rJZmiffWBfR6y9jy9FeIMwDtdixuDWkyuGAt5Ri7PefSSvNFAG
         u652/TW0L6ZkTrIIOTqAAoOwSTGDY7t7/MUthWnLOFsAKHAekknsN2gvbdxhd22u+WC2
         qZY9rRoB9p0JBX1YXGsw6A0EN/s6UVLZc+HDuH4y1r3LpCy9ZvNIun7Yfr0PccN+vGPt
         943A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757461785; x=1758066585;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nWhDazcpSKC+AMTc7oUhp0RNtPqVbOFG7KBfwJ/eX+U=;
        b=Ru/KW/XmNJsUiYHzrR8Sr3VGQpZ2ns4OxReUvKXmf1w0B4J7SU/5KXeh2pZNUgspmk
         8hYzVa8b9h0yMKyV/WXnLu4kfhULTiF7BOH07qnHPbtlcDf35oKyH7/k/UoGql75MZJK
         YEjhrchd6sWPYK1Fu7+f9q+LLipFwuvDcUQXB+xQhY/cLACdD6LAIn7wMBZbrxcYdY4s
         hfvzCR61kiTxR8+Ric2/yYRc5IL6smEBGydx3vvbnHcWyFMivy4S//IUR2SevIS/oarZ
         3tgK8R8QNdYliR5nK7OssTg29S50yINpu+9cwRfiI+qbufGsGN7IT9bJNi63Sh+8qswZ
         knGg==
X-Forwarded-Encrypted: i=1; AJvYcCVBc/B4ARnTk8i2jvo1lmYKPkic/KDjjlsvT7TAdYry/a5wjRkVFyYmKv69uZ7MvEtYq/wbW3sZcA==@kvack.org
X-Gm-Message-State: AOJu0YwXdhpIL6FDXOsQ2Cgrt76d6T6tFxnXp3cU5j107P0rsPrclLEW
	iEttAcyo+ubdKmG+h4/WrhOmmb0aXsoqqHZw2qJWSHxbY/ZKKRRalKI9seki1WwdvefdCRm0n7C
	JQ1d2FQ==
X-Google-Smtp-Source: AGHT+IF72iXNiE/M7Su4ZVf/nk/3OYPozXy/wJrW2w9tdXbFUYfFNYOP8Pyxkf2InrNA9TDyU0OW+E1pXRc=
X-Received: from pjbph12.prod.google.com ([2002:a17:90b:3bcc:b0:329:ccdd:e725])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d4f:b0:32b:dbf1:319e
 with SMTP id 98e67ed59e1d1-32d43f8fa03mr19354008a91.23.1757461784993; Tue, 09
 Sep 2025 16:49:44 -0700 (PDT)
Date: Tue,  9 Sep 2025 16:49:42 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909234942.1104356-1-surenb@google.com>
Subject: [PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pasha.tatashin@soleen.com, souravpanda@google.com, surenb@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2AE891A0011
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: o7pfbfuzutq71hctxqeezfk5aqitu8on
X-HE-Tag: 1757461785-304508
X-HE-Meta: U2FsdGVkX189GiRHUOTpb6OVpEQkKfzkYl+tvYKHcVea75cyl9TVukWz7cxh1dJkCsFdNoRCGlkadEXdDEtvCKWkCKGt2UEgKNzGy3dQ9GF1ptcofD74+4bYiBTjxUXXxB73RM5TtMOIKj+Aw0F2X3HV/oBqpOeZb2qFHoiBvrzw/Fzb4XVeq6f+Ke9lxEFZRAhtSy1AtqSzoTgazErxNXpUEEQE5lZqK1QlTgEWKQo+hiStMC3sk9LiOYkjFIn6HoUrKnG4t/qE0YOYCdYY7ONPr+fda6pabot58NUBLWNw7wW0LxAiICU4JvbNrAg9WpcyAK3qr3VuBTZENQXA+4C5uYo1EIfJrSiWh6NAw1RpogD0s6ey42R5qWFVANs2aSZ1eRI8VfCaepihHNv2C+v7Z+6aZRTCCZtoxUiah08rh4f5YnxCPwAVJ0In6+AitVwnogFNGp4xqO4sGqG3a3/XnEwzilByV+d/LQQGnqd/SbTgkwN/rqv3h2rOSZpPHgGpr1e0iYJq+vAO8iOGv6j9giILAyzPEgYzH/H0jKeuV4jAg7oxwVVewR1posjP6Pye+lVZvC/3c+lOJ0ghMLhA7cIkoNmUTaLFqmZrOoCuriUQMmBNVSgU5EDD/pVUdtrxHh41UkwuDniwLFyBQYPsL0othakTQKkYh50crO6VIAwMtN5NifDLRawaNsiiJFhUy8DZ5KHprQstVshbCPEJ3MUc2eNCC4aznCasdgfjxrVd0cYD5DFyqFzleJBzsJwTaZ80aIboZwH0Ir034MaSSn/EFHXsUIRil103bwidbfJZMpx1Y9EpuHLsAitYiyPD9Ft5PjDMm/SIwJJIT7gWbw2M0qwd9/dYQXQBpTnEN/FRWjc2h+enrGo5wJcpF0Q/VsJ3EnH2lRg471URbiHF8QTD+6L24yQk/kzwUj6fmveeq5ILUbfyQb/inWu8TfRxVWhz0xeocw7iEY7
 WG1OgUQk
 jTfRTg34c22H8ymi2R0o9TL4eMbF2VMnWws+oVoMTHwT5CBZNeEjko9nt9I/z/eW8FthYojsRwKNlzG5TjuST1911NYtQiJnECwWDI3/RhqWJKOR27A7MBsNdZ7wW4FJ/tvuw6oXnhE/wEcYtAhEeuo0m1yYGwTuxQqLQvgCFGZxM1tAGTTutq0HjrPEdr9fsu3HsrwH3iZJW135c+7T6iuQ3HgScRv0qHqRWEqnP2THFN02Jo+tO6sHqKUIBBSM3DnHmRuVAZvGc+weGxbFHx7u5IT+fb3kWI1sfieAQkX1ToizoGMOUtMHQdds6I9UGdR1xilCsBnjbjoKCT/x4Q4srpc/tsRqL81Z9c3t6cVshxKwng9TUhOfc7zUACkxlY6kmjR6m0kA8ol6NLNpGkr804IJwMYO5uEVMgc0tcRL/8BGCF+3o+sjDWnTVmUmI/SCW2wLF3WwF3GVAPaCXLZNmEblvXAJ8bJRwhhUCPymql+srM+l1guDgEXm7IunMTTSncpUgG1JNcIS1MI6C3Jgqxp3Q1WcB2trB2z2QZtSy6+tEQf0hI06z8uQNye9cHBQH4Ivmgv9rYkxbfMfV8r1Sz/CU7sc7mhKxC2o1yzVDLll/lNF4aACfm8myvQ9PHcDznxt+JCpm8TQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While rare, memory allocation profiling can contain inaccurate counters
if slab object extension vector allocation fails. That allocation might
succeed later but prior to that, slab allocations that would have used
that object extension vector will not be accounted for. To indicate
incorrect counters, mark them with an asterisk in the /proc/allocinfo
output.
Bump up /proc/allocinfo version to reflect change in the file format.

Example output with invalid counters:
allocinfo - version: 2.0
           0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_data_nodes
           0        0 arch/x86/kernel/alternative.c:2090 func:alternatives_smp_module_add
          0*       0* arch/x86/kernel/alternative.c:127 func:__its_alloc
           0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs_set
           0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_realloc
           0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_enable_hybrid_capacity_scale
           0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func:init_amd_l3_attrs
      49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create
       32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_gen_pool_create
           0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_threshold_create_device

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
Patch is based on mm-new.

 include/linux/alloc_tag.h | 12 ++++++++++++
 include/linux/codetag.h   |  5 ++++-
 lib/alloc_tag.c           |  7 +++++--
 mm/slub.c                 |  2 ++
 4 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 9ef2633e2c08..d40ac39bfbe8 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -221,6 +221,16 @@ static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
 	ref->ct = NULL;
 }
 
+static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
+{
+	tag->ct.flags |= CODETAG_FLAG_INACCURATE;
+}
+
+static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
+{
+	return !!(tag->ct.flags & CODETAG_FLAG_INACCURATE);
+}
+
 #define alloc_tag_record(p)	((p) = current->alloc_tag)
 
 #else /* CONFIG_MEM_ALLOC_PROFILING */
@@ -230,6 +240,8 @@ static inline bool mem_alloc_profiling_enabled(void) { return false; }
 static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
 				 size_t bytes) {}
 static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
+static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag) {}
+static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag) { return false; }
 #define alloc_tag_record(p)	do {} while (0)
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
diff --git a/include/linux/codetag.h b/include/linux/codetag.h
index 457ed8fd3214..8ea2a5f7c98a 100644
--- a/include/linux/codetag.h
+++ b/include/linux/codetag.h
@@ -16,13 +16,16 @@ struct module;
 #define CODETAG_SECTION_START_PREFIX	"__start_"
 #define CODETAG_SECTION_STOP_PREFIX	"__stop_"
 
+/* codetag flags */
+#define CODETAG_FLAG_INACCURATE	(1 << 0)
+
 /*
  * An instance of this structure is created in a special ELF section at every
  * code location being tagged.  At runtime, the special section is treated as
  * an array of these.
  */
 struct codetag {
-	unsigned int flags; /* used in later patches */
+	unsigned int flags;
 	unsigned int lineno;
 	const char *modname;
 	const char *function;
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index e9b33848700a..a7f15117c759 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -80,7 +80,7 @@ static void allocinfo_stop(struct seq_file *m, void *arg)
 static void print_allocinfo_header(struct seq_buf *buf)
 {
 	/* Output format version, so we can change it. */
-	seq_buf_printf(buf, "allocinfo - version: 1.0\n");
+	seq_buf_printf(buf, "allocinfo - version: 2.0\n");
 	seq_buf_printf(buf, "#     <size>  <calls> <tag info>\n");
 }
 
@@ -90,7 +90,10 @@ static void alloc_tag_to_text(struct seq_buf *out, struct codetag *ct)
 	struct alloc_tag_counters counter = alloc_tag_read(tag);
 	s64 bytes = counter.bytes;
 
-	seq_buf_printf(out, "%12lli %8llu ", bytes, counter.calls);
+	if (unlikely(alloc_tag_is_inaccurate(tag)))
+		seq_buf_printf(out, "%11lli* %7llu* ", bytes, counter.calls);
+	else
+		seq_buf_printf(out, "%12lli %8llu ", bytes, counter.calls);
 	codetag_to_text(out, ct);
 	seq_buf_putc(out, ' ');
 	seq_buf_putc(out, '\n');
diff --git a/mm/slub.c b/mm/slub.c
index af343ca570b5..9c04f29ee8de 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2143,6 +2143,8 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
 	 */
 	if (likely(obj_exts))
 		alloc_tag_add(&obj_exts->ref, current->alloc_tag, s->size);
+	else
+		alloc_tag_set_inaccurate(current->alloc_tag);
 }
 
 static inline void

base-commit: f4e8f46973fe0c0f579944a37e96ba9efbe00cca
-- 
2.51.0.384.g4c02a37b29-goog


