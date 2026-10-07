Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58815CA6009
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 22:40:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 479B46B0092; Wed,  7 Oct 2026 18:40:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42A0E6B0093; Wed,  7 Oct 2026 18:40:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CB186B0095; Wed,  7 Oct 2026 18:40:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF8096B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 18:40:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CBC26140379
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 22:40:11 +0000 (UTC)
X-FDA: 85297299822.29.E588308
Received: from mail-dl1-f70.google.com (mail-dl1-f70.google.com [74.125.82.70])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0F799140004
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 22:40:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tNOylNr8;
	spf=pass (imf23.hostedemail.com: domain of 3RsrGag0KCFMvw23D2z5wvAvE19916z.x97638FI-775Gvx5.9C1@flex--abhishekbapat.bounces.google.com designates 74.125.82.70 as permitted sender) smtp.mailfrom=3RsrGag0KCFMvw23D2z5wvAvE19916z.x97638FI-775Gvx5.9C1@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791412810;
	b=hHCw/aXCR6RUHcTt7nyMi8cP0nLSpynpeKGInVtUZ7Af4jikalag76tP6wFdAojiZO97Sn
	kzb4254P1r2PLS8cJ6Cg5QJWAcloTLEjG1HTriL0eHClQ9lK+QD5O44SKtKGp+Umqe0Z4J
	iNNMQgQOmjmJUZ8ZkUS4x/EWhdWfTf8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tNOylNr8;
	spf=pass (imf23.hostedemail.com: domain of 3RsrGag0KCFMvw23D2z5wvAvE19916z.x97638FI-775Gvx5.9C1@flex--abhishekbapat.bounces.google.com designates 74.125.82.70 as permitted sender) smtp.mailfrom=3RsrGag0KCFMvw23D2z5wvAvE19916z.x97638FI-775Gvx5.9C1@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791412810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmBv5Ov66cfDjrWeOcZ3nkC88AIvTnw99nTSoXculpU=;
	b=mvIzBw1Q+GGJvpsoOsYB9MDZWud6h9BEBg9YC0xoVNE/Ru03OAcqjkKYueRsQDbo/3SiU3
	DA4Q4O+oVY3MTXdLdN/tsowBgRiS66Y986qcL4YjTthXrzI+Ai8yYvG/l/3WovPcxjD7Xu
	ELIpyet/cc/JUMxbUInaR+HVeC7MxcA=
Received: by mail-dl1-f70.google.com with SMTP id a92af1059eb24-147be78cd56so16529346c88.1
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 15:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791412809; x=1792017609; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jmBv5Ov66cfDjrWeOcZ3nkC88AIvTnw99nTSoXculpU=;
        b=tNOylNr8KTpzJqJNp/Ov18y/043BPo9YV8nzEI5iQTVHe62rtvzKqdUTAAHahd3Sye
         Q7xPHbxCoRW27w76J7+Hmbh+hCFyvcQI0YdCW2TRqlBHiByJ3F1dRkxxCzdwds6EbEiz
         t0nHootD4fg4bdQ0Spxr7ljGWGRtjnKiUXj9/Anvh5CpHj1WeXRExD7l97BR1qE1HlTn
         nJiMPOxtGDIW/teqC5JfQsM8kYRmYZiQ9dp7N0g3BD4xf44sgu4j7N29uS/gTvtVKta1
         rFcmsbfs/NOeGv7m/Okz3UOZM7FqCfM6y+3TBXf3MnZN+QCAozpMKsMA+BMZkAGZnnLP
         1K8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791412809; x=1792017609;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jmBv5Ov66cfDjrWeOcZ3nkC88AIvTnw99nTSoXculpU=;
        b=wkwQ+sFUiTBV62C9OyY/ti/LTC1KKL8SSDPFAZKbZIlWdoP7ZKl0msHUUm9HQFadfv
         D3ur1DMtOeQmMP1bQ2nCuW8QKJ+5iMxYTiqxUU4QF6UoR0HwMVkvHhWr2weqEHDFYVYP
         tCKU5HLt1O34fpIWXgiRGx2RANBrqCE2GtXUZXOfeKC8EojIScZ9fb+4mGKGQ9k+fXo+
         D4QjSn2Rq0G47tg4NYWR0ryicjtZV57LPi+9uAjrHqusQ9vT/Ih+n//YGPTUNBW5gFRG
         zEtgr9lz9WiLlPZJ0RAc+QjjsX+cgi2ljokI2yMv9Qv+oSAW/bLC2KMHDpRaJkIe7ztC
         XyAA==
X-Forwarded-Encrypted: i=1; AKwUvBw/MB6cB18hvidmmD3beK69ZCzeZ0xpx1omCDkd9O41pHT9gp3Is4i7/sEqie9weB1Lv8LnaFko0Q==@kvack.org
X-Gm-Message-State: AFuF++lUAxIrDYKUakUc7djBkjycUMX7Systie7JX90QrAG/wQlAVi6w
	0wQYjIsFe2ooyYHf45GplQiH6W0UwHDSiqNS2tyPcuZjG/BIx5UkoLNDxQtMvo0FwSs3Gzgd5y0
	52JUFxtuDf5TeixF1sFBCuwEjv2shi9B7dg==
X-Received: from dlam8-n1.prod.google.com ([2002:a05:701b:2088:10b0:165:775d:c25a])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:4343:b0:13f:c85d:17bb with SMTP id a92af1059eb24-161fe969454mr4304117c88.1.1791412806650;
 Wed, 07 Oct 2026 15:40:06 -0700 (PDT)
Date: Wed,  7 Oct 2026 22:39:59 +0000
In-Reply-To: <cover.1791410885.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1791410885.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <ba9bee624103492dde1c8bf57943b691b4f1596b.1791410886.git.abhishekbapat@google.com>
Subject: [PATCH v2 1/4] alloc_tag: Add trace events for tracing allocations
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0F799140004
X-Rspam-User: 
X-Stat-Signature: 3qsbab5843ouhw57esh4zekqs5non1sc
X-HE-Tag: 1791412809-486934
X-HE-Meta: U2FsdGVkX19Q3aJrGplnyOxmm5ZBJAvoFjcm9M0/dTim8hf8mxToH1Eo+qqH+XjoYCCQD3KKwD26epsB7NV0Hk/GtXI0SADBLmXsyINszUTIdbAAweyUyoGbfB8h+/Y/IeJRFF8wZRvJe8pdHwF/5Ga0VbQojdNBZBzMRj+RMoOVXH3AfeKH5Mwbhp+8g+wngysTyObEd6K2+4xKsIEsOhxxLtvMAX7L2lFCNbVK9by3/b8ihUs5MTwN47X5+EZHgiZyANmv5Ct2cyYEy1C1YFQDAvtnv+E5QyCvQNrOhHo3DZcwyVpyz7M3fvop+bNRD54aRabvpQ1mqgHvfkS4zQnLQlJnazK30yaeotQnDA24C4R41L2LsKvhrt669skD6Y8BBL1Qk/PUdUpZLxCrINKtBt9Ya7ERrx2c8Z2AQXdzjZaNeeD6aw5AJBt/4Cmt6NSV7xRkzOyds/WaD/V/S5HJYxaLtZXh/HsOvMJiQKowHN+iAevGtUWeJYLk/1PRlsqthmpyy6QxTBiKOOsKJVOC7kSkmjFjAEJolrp2Vq+RvEq9KyTDPbyUvv+XOrDxOK7/OgLG7FhT2E6Kv0ZYPU3nL93jWrn5HdfcmWkmBTAk1qqfDDli4CYQT5FzrjOv6ov3+Jn5iFGZ1WomEyEqA3aCL8iHQokPFvksdEWsYQLMRhN9LT0mDpbFBoLikkc93Vo9evjCAG/6sT7GR+Wk84o+v+oEG9sjrYVjTAyDJUhwJC++EZYKuwEHI93XpWSCbHxqmjkrt3YItyaxIWEcazw/p9syOoIPcHB+zO6BJ5Ps/lcZVDl1Wv94nAahjIDYocj95Q8/+GLZv6euSPHstzrcdvRba6eQF6cCnQD138tS0KdFUCVfavMp5w561dsqoVw0ISUdO1CxJJT2QobZiiSUnFSmxPJHgho63x+cSoIY5noNbwko/EQ3z06t5qbjFo+ohTQjcZcJYY5ir/I
 Xd0UpTO8
 u7kSdGnVJ4xx1PTNQjxOzVCIRzEZsbkroH6I8+3xsq1NuoGjrlXJybVlSn/9VtHR53kIoChv+W5vUMh3nUaOnKMeqyjM8do3YpKl7zyRwhkbqWB6oiua0D2coKiWgj+ScrL/4gbjUovDeD220DFzMZSX9lm33fzWoiuPeNjlc7OmHWYIWLMftgtEU4lNJWyq4hkLiKyxcYQmcWh7Dku9NSj4aPgroBjMJ76thgOhuWMilPwXkHXF1hDwsC4u1ZBg6mt+lLBjslZIHNL/cGMSmlyaTkZk8YcSjJm1HO28U1CDeHFYc3M5/Y0rjjBSPJXBygwwdAiucOSLRHSXU25oOM/tMK19P5CeF21hq64Jq5srBhQzoGZfNn2acCSwWfj+IlGoxWuMEE6nY35YYsBBglpLcc6lAAjMGHIv5yf1UWTNeIsqfrKcTQn2wpXGZ3ZSPmIikP0eYm/QLyTqzKKKXN5O5gIdmDLWId8gS9QxxIJ0TX06Sm7riyUd56uIJEmlVgpzmkJZ5lNq7MYD2mpULWjm/NGE14XKRXhw5Inz5UMOxus1A3qw0pV1kvRZnoCKEqslfdQK8UrHLTApf/T39YjeAjPiytgKSgoWUAXPofYMEB3XANcXe2b+Zf5/0OLqj9WkvPQxBuQplqXmgtPCuHC49V6YPHDYomklIVwqeA80kM0M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memory allocation profiling framework intercepts allocations across
the core subsystems, but currently lacks runtime tracing hooks for
standard observability tools to dynamically track the context (stack
traces and lifecycles of the individual memory chunks) of the
allocations made.

Introduce three standard trace events to allow this tracking:

1. `alloc_tag_hit`: Fired at the exact call site. This allows userspace
   tools to trigger and capture a call stack.
2. `alloc_tag_mem_alloced`: Fired in alloc_tag_add upon successful
   allocation. It records the allocated size, the tag, and the uniquely
   generated `ptr` value which is `codetag_ref` for slab and percpu
   allocators and the pointer to the head `struct page` for the page
   allocator.
3. `alloc_tag_mem_freed`: Fired in alloc_tag_sub right before memory is
   freed, yielding the same `ptr` value to allow tracing tools to find
   the corresponding allocation.

Because the introduced trace events occur at different stages in the
call stack, userspace tracing tools must stitch them together to form a
complete picture of a buffer's lifetime. Here's an example of how
userspace correlates these three events:

1. On `alloc_tag_hit`: The tool captures the stack trace and caches it,
   keyed by the combination of the current thread's PID and the `tag`.
2. On `alloc_tag_mem_alloced`: The tool extracts the PID and `tag` from
   the event and looks up the stack trace cached in step 1. It creates a
   new active allocation record, mapping the new provided `ptr` value
   to this cached stack trace and the newly returned allocation size.
3. On `alloc_tag_mem_freed`: When the memory is freed, the event yields
   the same `ptr` value. The tool uses this reference to look up the
   original allocation record, correlates the free, and safely retires
   the tracking entry.

Modify `alloc_tag_add()` and `alloc_tag_sub()` with a `ptr` argument to
map frees to allocations in the trace events. Slab and percpu pass the
address of the object's `codetag_ref`. The page allocator passes the
head `struct page` because its `codetag_ref` is a temporary copy on the
stack.

Also, introduce `alloc_tag_trace_key` static key to minimize the
overhead when no tags are being traced (the usual case). Once tracing
for any tag is requested, the key is set, opening the path to check
whether tracing is enabled for the current tag.
Note that the mechanism to enable tag tracing is implemented in the next
patch, therefore for now, `alloc_tag_trace_key` stays always unset.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 Documentation/mm/allocation-profiling.rst |  53 ++++++++++
 MAINTAINERS                               |   1 +
 include/linux/alloc_tag.h                 |  67 +++++++++---
 include/trace/events/alloc_tag.h          | 122 ++++++++++++++++++++++
 mm/alloc_tag.c                            |  28 +++++
 mm/page_alloc.c                           |   4 +-
 mm/percpu.c                               |  12 ++-
 mm/slub.c                                 |   6 +-
 8 files changed, 269 insertions(+), 24 deletions(-)
 create mode 100644 include/trace/events/alloc_tag.h

diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
index b11ea77c0673..b241450394df 100644
--- a/Documentation/mm/allocation-profiling.rst
+++ b/Documentation/mm/allocation-profiling.rst
@@ -129,6 +129,59 @@ To do so:
 - Then, use the following form for your allocations:
   alloc_hooks_tag(ht->your_saved_tag, kmalloc_noprof(...))
 
+Tracing
+=======
+
+Three trace events are available under `/sys/kernel/tracing/events/alloc_tag` to
+expose the full call stack and the lifetime of individual allocations:
+
+- `alloc_tag_hit`: Fired at the exact call site, before the allocation happens.
+  Can be used to capture the call stack of the caller.
+
+- `alloc_tag_mem_alloced`: Fired once the allocation succeeds. Carries the `ptr`,
+  `tag` and `bytes` for each allocation.
+
+- `alloc_tag_mem_freed`: Fired before memory is freed. Carries the same
+  `ptr`, `tag` and `bytes` as the matching alloc event.
+
+`ptr` identifies the allocation, and its meaning depends on the allocator:
+
+- slab and percpu: the address of the object's `codetag_ref`
+- page allocator: the `struct page` pointer of the head page
+
+Correlating the events
+----------------------
+
+`alloc_tag_hit` and `alloc_tag_mem_alloced` come from different points in the
+call stack, so they have to be stitched together by the user consuming the
+events. Here's a typical flow:
+
+1. On `alloc_tag_hit`: Capture the stack trace and cache it keyed by `(pid, tag)`.
+
+2. On `alloc_tag_mem_alloced`: Look up the cached stack trace by `(pid, tag)`,
+   then create an active allocation record keyed by `ptr` that holds the stack
+   trace and `bytes`.
+
+3. On `alloc_tag_mem_freed`: Look up the record by `ptr` and retire it.
+
+Limitations
+-----------
+
+- For the page allocator, events are generated for the original allocation and
+  the free only. If the tag reference is split or moved to another folio in
+  between, no event is generated for that. As a result:
+
+  - a free event may carry a `ptr` that never appeared in an alloc event;
+  - `bytes` in a free event may be smaller than in the matching alloc event.
+
+  Tools should correlate on `ptr` but must not assume that freed bytes equal
+  allocated bytes, or that every free has a matching alloc.
+
+- Freeing a non-compound high-order page with `__free_pages()` while another CPU
+  holds a reference frees the tail pages immediately and the head page later when
+  the reference is dropped. The free event is emitted at the second point and
+  reports `PAGE_SIZE` rather than the full size.
+
 Notes
 =====
 
diff --git a/MAINTAINERS b/MAINTAINERS
index 5c38da7090db..751ce786a378 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17100,6 +17100,7 @@ S:	Maintained
 F:	Documentation/mm/allocation-profiling.rst
 F:	include/linux/alloc_tag.h
 F:	include/linux/pgalloc_tag.h
+F:	include/trace/events/alloc_tag.h
 F:	include/uapi/linux/alloc_tag.h
 F:	mm/alloc_tag.c
 F:	tools/testing/selftests/alloc_tag/
diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 7f2d80a59792..49825177d8c8 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -128,12 +128,33 @@ DECLARE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
 DECLARE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 			mem_alloc_profiling_key);
 
+DECLARE_STATIC_KEY_FALSE(alloc_tag_trace_key);
+
 static inline bool mem_alloc_profiling_enabled(void)
 {
 	return static_branch_maybe(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 				   &mem_alloc_profiling_key);
 }
 
+static inline bool alloc_tag_trace_enabled(void)
+{
+	return static_branch_unlikely(&alloc_tag_trace_key);
+}
+
+void alloc_tag_trace_mem_alloc(const void *ptr, struct alloc_tag *tag,
+			       size_t bytes);
+
+void alloc_tag_trace_mem_free(const void *ptr, struct alloc_tag *tag,
+			      size_t bytes);
+
+void __alloc_tag_trace_hit(struct alloc_tag *tag);
+
+static __always_inline void alloc_tag_trace_hit(struct alloc_tag *tag)
+{
+	if (alloc_tag_trace_enabled())
+		__alloc_tag_trace_hit(tag);
+}
+
 bool mem_alloc_profiling_permanently_disabled(void);
 
 static inline struct alloc_tag_counters alloc_tag_read(struct alloc_tag *tag)
@@ -198,13 +219,19 @@ static inline bool alloc_tag_ref_set(union codetag_ref *ref, struct alloc_tag *t
 	return true;
 }
 
-static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag, size_t bytes)
+static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag, size_t bytes,
+				 const void *ptr)
 {
-	if (likely(alloc_tag_ref_set(ref, tag)))
+	if (likely(alloc_tag_ref_set(ref, tag))) {
 		this_cpu_add(tag->counters->bytes, bytes);
+
+		if (alloc_tag_trace_enabled())
+			/* Trace successful allocs with their unique ptr */
+			alloc_tag_trace_mem_alloc(ptr, tag, bytes);
+	}
 }
 
-static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
+static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes, const void *ptr)
 {
 	struct alloc_tag *tag;
 
@@ -222,6 +249,10 @@ static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
 	this_cpu_sub(tag->counters->bytes, bytes);
 	this_cpu_dec(tag->counters->calls);
 
+	if (alloc_tag_trace_enabled())
+		/* Trace frees with their unique ptr */
+		alloc_tag_trace_mem_free(ptr, tag, bytes);
+
 	ref->ct = NULL;
 }
 
@@ -243,25 +274,29 @@ static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
 static inline bool mem_alloc_profiling_enabled(void) { return false; }
 static inline bool mem_alloc_profiling_permanently_disabled(void) { return true; }
 static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
-				 size_t bytes) {}
-static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
+				 size_t bytes, const void *ptr) {}
+static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes,
+				 const void *ptr) {}
 static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag) {}
 static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag) { return false; }
+#define alloc_tag_trace_hit(_tag)	/* NOOP */
 #define alloc_tag_record(p)	do {} while (0)
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
-#define alloc_hooks_tag(_tag, _do_alloc)				\
-({									\
-	typeof(_do_alloc) _res;						\
-	if (mem_alloc_profiling_enabled()) {				\
-		struct alloc_tag * __maybe_unused _old;			\
-		_old = alloc_tag_save(_tag);				\
-		_res = _do_alloc;					\
-		alloc_tag_restore(_tag, _old);				\
-	} else								\
-		_res = _do_alloc;					\
-	_res;								\
+#define alloc_hooks_tag(_tag, _do_alloc)					\
+({										\
+	typeof(_do_alloc) _res;							\
+	if (mem_alloc_profiling_enabled()) {					\
+		struct alloc_tag * __maybe_unused _old;				\
+		/* Fired here to cleanly capture the caller's stack trace */	\
+		alloc_tag_trace_hit(_tag);					\
+		_old = alloc_tag_save(_tag);					\
+		_res = _do_alloc;						\
+		alloc_tag_restore(_tag, _old);					\
+	} else									\
+		_res = _do_alloc;						\
+	_res;									\
 })
 
 #define alloc_hooks(_do_alloc)						\
diff --git a/include/trace/events/alloc_tag.h b/include/trace/events/alloc_tag.h
new file mode 100644
index 000000000000..b79efb7dd25c
--- /dev/null
+++ b/include/trace/events/alloc_tag.h
@@ -0,0 +1,122 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM alloc_tag
+
+#if !defined(_TRACE_ALLOC_TAG_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_ALLOC_TAG_H
+
+#include <linux/tracepoint.h>
+
+/*
+ * alloc_tag_hit is generated at the exact allocation call site and can be
+ * used to capture a clean stack trace.
+ *
+ * To link this stack trace to the actual allocated memory chunk, tools must
+ * correlate this event with the resulting alloc_tag_mem_alloced event. Since
+ * multiple threads can hit the same tag simultaneously, tools must match BOTH
+ * the `tag` field and the implicitly recorded PID provided by the core
+ * tracing subsystem.
+ */
+TRACE_EVENT(alloc_tag_hit,
+	TP_PROTO(struct alloc_tag *tag),
+
+	TP_ARGS(tag),
+
+	TP_STRUCT__entry(__field(struct alloc_tag *, tag)
+			 __string(modname, tag->ct.modname ? tag->ct.modname : "NONE")
+			 __string(filename, tag->ct.filename)
+			 __string(function, tag->ct.function)
+			 __field(unsigned int, lineno)
+	),
+
+	TP_fast_assign(__entry->tag = tag;
+		       __assign_str(modname);
+		       __assign_str(filename);
+		       __assign_str(function);
+		       __entry->lineno = tag->ct.lineno;
+	),
+
+	TP_printk("tag %p, module: %s, filename: %s, function %s, lineno %u",
+		  __entry->tag,
+		  __get_str(modname),
+		  __get_str(filename),
+		  __get_str(function),
+		  __entry->lineno
+	)
+);
+
+/*
+ * alloc_tag_mem_alloced is generated after memory is successfully allocated.
+ * It captures the exact byte size.
+ *
+ * The `ptr` value identifies the memory chunk for tracking its lifecycle
+ * (e.g., matching it with alloc_tag_mem_freed).
+ * - slab and percpu allocators: address of the object's codetag_ref
+ * - page allocator: the head struct page of the allocation
+ *
+ * Because the kernel isolates active allocations within the task struct
+ * (current->alloc_tag), this event will always share the same implicit PID as
+ * its corresponding alloc_tag_hit event. Tools should use the combination
+ * PID + `tag` to correlate them.
+ */
+TRACE_EVENT(alloc_tag_mem_alloced,
+	TP_PROTO(const void *ptr, struct alloc_tag *tag, size_t bytes),
+
+	TP_ARGS(ptr, tag, bytes),
+
+	TP_STRUCT__entry(__field(const void *, ptr)
+			 __field(struct alloc_tag *, tag)
+			 __field(size_t, bytes)
+	),
+
+	TP_fast_assign(__entry->ptr = ptr;
+		       __entry->tag = tag;
+		       __entry->bytes = bytes;
+	),
+
+	TP_printk("ptr %p, tag %p, bytes %zu",
+		  __entry->ptr,
+		  __entry->tag,
+		  __entry->bytes
+	)
+);
+
+/*
+ * alloc_tag_mem_freed event is generated immediately before memory is
+ * freed. The `ptr` value matches the one emitted during allocation,
+ * allowing tools to match it to its corresponding allocation and
+ * call stack.
+ *
+ * Page allocator caveat: Pages can be split or moved to another folio
+ * after the alloc event with no new events generated for that. As a
+ * result, a free event may carry a `ptr` that never appeared in an
+ * alloc event, and the `bytes` may be smaller than in the matching
+ * alloc event. Tools must not assume alloc bytes == free bytes, nor
+ * that every free has a matching alloc.
+ */
+TRACE_EVENT(alloc_tag_mem_freed,
+	TP_PROTO(const void *ptr, struct alloc_tag *tag, size_t bytes),
+
+	TP_ARGS(ptr, tag, bytes),
+
+	TP_STRUCT__entry(__field(const void *, ptr)
+			 __field(struct alloc_tag *, tag)
+			 __field(size_t, bytes)
+	),
+
+	TP_fast_assign(__entry->ptr = ptr;
+		       __entry->tag = tag;
+		       __entry->bytes = bytes;
+	),
+
+	TP_printk("ptr %p, tag %p, bytes %zu",
+		  __entry->ptr,
+		  __entry->tag,
+		  __entry->bytes
+	)
+);
+
+#endif /* _TRACE_ALLOC_TAG_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 82e2c3448dcf..ca2412a67312 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -18,6 +18,9 @@
 #include <linux/kmemleak.h>
 #include <uapi/linux/alloc_tag.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/alloc_tag.h>
+
 #include "internal.h"
 #include "page_alloc.h"
 
@@ -54,6 +57,9 @@ EXPORT_SYMBOL(mem_alloc_profiling_key);
 
 DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
 
+DEFINE_STATIC_KEY_FALSE(alloc_tag_trace_key);
+EXPORT_SYMBOL(alloc_tag_trace_key);
+
 struct alloc_tag_kernel_section kernel_tags = { NULL, 0 };
 unsigned long alloc_tag_ref_mask;
 int alloc_tag_ref_offs;
@@ -484,6 +490,28 @@ static const struct proc_ops allocinfo_proc_ops = {
 #endif
 };
 
+void __alloc_tag_trace_hit(struct alloc_tag *tag)
+{
+	if (unlikely(!tag))
+		return;
+	trace_alloc_tag_hit(tag);
+}
+EXPORT_SYMBOL(__alloc_tag_trace_hit);
+
+void alloc_tag_trace_mem_alloc(const void *ptr, struct alloc_tag *tag,
+			       size_t bytes)
+{
+	trace_alloc_tag_mem_alloced(ptr, tag, bytes);
+}
+EXPORT_SYMBOL(alloc_tag_trace_mem_alloc);
+
+void alloc_tag_trace_mem_free(const void *ptr, struct alloc_tag *tag,
+			      size_t bytes)
+{
+	trace_alloc_tag_mem_freed(ptr, tag, bytes);
+}
+EXPORT_SYMBOL(alloc_tag_trace_mem_free);
+
 size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count, bool can_sleep)
 {
 	struct codetag_iterator iter;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7682aecc2c07..5e3e411d4ffe 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1239,7 +1239,7 @@ void __pgalloc_tag_add(struct page *page, struct task_struct *task,
 	union codetag_ref ref;
 
 	if (likely(get_page_tag_ref(page, &ref, &handle))) {
-		alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
+		alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr, page);
 		update_page_tag_ref(handle, &ref);
 		put_page_tag_ref(handle);
 	} else {
@@ -1268,7 +1268,7 @@ void __pgalloc_tag_sub(struct page *page, unsigned int nr)
 	union codetag_ref ref;
 
 	if (get_page_tag_ref(page, &ref, &handle)) {
-		alloc_tag_sub(&ref, PAGE_SIZE * nr);
+		alloc_tag_sub(&ref, PAGE_SIZE * nr, page);
 		update_page_tag_ref(handle, &ref);
 		put_page_tag_ref(handle);
 	}
diff --git a/mm/percpu.c b/mm/percpu.c
index 3eff382e565a..12b6c97d1596 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1695,15 +1695,19 @@ static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,
 				      size_t size)
 {
 	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts)) {
-		alloc_tag_add(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
-			      current->alloc_tag, size);
+		union codetag_ref *ref = &chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag;
+
+		alloc_tag_add(ref, current->alloc_tag, size, ref);
 	}
 }
 
 static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 {
-	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts))
-		alloc_tag_sub(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag, size);
+	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts)) {
+		union codetag_ref *ref = &chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag;
+
+		alloc_tag_sub(ref, size, ref);
+	}
 }
 #else
 static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,
diff --git a/mm/slub.c b/mm/slub.c
index 544cff39762c..a866576ccb98 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2404,7 +2404,7 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
 		obj_ext = slab_obj_ext(s, slab, obj_exts, object);
 		ref = slab_obj_ext_codetag_ref(slab, obj_ext);
 
-		alloc_tag_add(ref, current->alloc_tag, s->size);
+		alloc_tag_add(ref, current->alloc_tag, s->size, ref);
 
 		put_slab_obj_exts(obj_exts);
 	} else {
@@ -2444,9 +2444,11 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
 	get_slab_obj_exts(obj_exts);
 	for (int i = 0; i < objects; i++) {
 		struct slabobj_ext *ext;
+		union codetag_ref *ref;
 
 		ext = slab_obj_ext(s, slab, obj_exts, p[i]);
-		alloc_tag_sub(slab_obj_ext_codetag_ref(slab, ext), s->size);
+		ref = slab_obj_ext_codetag_ref(slab, ext);
+		alloc_tag_sub(ref, s->size, ref);
 	}
 	put_slab_obj_exts(obj_exts);
 }
-- 
2.56.0.385.gd3acb90ef8-goog


