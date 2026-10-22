Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF6DF606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 17:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ANB8fcZe
Received: by kanga.kvack.org (Postfix)
	id 748CF6B09A0; Thu, 22 Oct 2026 13:38:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63C976B09A2; Thu, 22 Oct 2026 13:38:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FD476B09A3; Thu, 22 Oct 2026 13:38:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D6926B09A0
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:38:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 307AB12021B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:38:31 +0000 (UTC)
X-FDA: 85350971622.12.83C49D1
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by imf28.hostedemail.com (Postfix) with ESMTP id 71CB5C0003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:38:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ANB8fcZe;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3E0raag0KCG4MNTUeTQWNMbMfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--abhishekbapat.bounces.google.com designates 74.125.82.72 as permitted sender) smtp.mailfrom=3E0raag0KCG4MNTUeTQWNMbMfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792690709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YMoLhmzCD6JxbrpCSqjwsvmu6iiWdz6TWER3dxYKCwc=;
	b=pwyDxXZ/bDcbv67EDM1lBf7zDVqO+ojz1mwGEBhTVuzvscGOjDOGW21v35YrM7qPF4EZEu
	+ov+HU2LtpBmT6HMF+N23/tXmvxBby7Mhbal0AipOO9g7wEkH72cMgAnlaap6wMF75EO6m
	aSROZV+YbrOwRBK/81MQkYHAGbgRowU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ANB8fcZe;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3E0raag0KCG4MNTUeTQWNMbMfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--abhishekbapat.bounces.google.com designates 74.125.82.72 as permitted sender) smtp.mailfrom=3E0raag0KCG4MNTUeTQWNMbMfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792690709;
	b=Go+LKq+FB1cGc7y6ya6ozDsUeG37AimpteV95ZHtz+YYTDuIZhJSN+AZ+jMuAIgoHS2N+m
	uJPB0dZG5/gYoshdAOvBFyablMCMSSkiOdrpuLOQNIbOJCCXjeJgZEz0a+onmryDaHPPFW
	AYU065liveufor60su05f8q+X2ucZ08=
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-17dc865c94cso827930c88.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792690708; x=1793295508; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YMoLhmzCD6JxbrpCSqjwsvmu6iiWdz6TWER3dxYKCwc=;
        b=ANB8fcZeD6Z4N47r/Ai9YDLOyXQp56FErSOIu/YSkVI0yB0IIJHlU2C/O3LZlScnuB
         PKmhMvhQ9VAdg0TUfcyjZ76LFtlA73PrTcMPvUDKYmE3hOseP7aX1LU/iW11U0bko5UT
         +V7BQ+oqlrWsMt29Z+QOHB2/VW+FGljZkSf6bW4hr1pJBEt3y8UuxNn4/ihH8oxJMDmp
         pAQi5X8YD2pUeCa/9+bDr8WCHaTmgLWLzPX8+9hnh+UDP7PMjWl+xF5jRGl4S+4odwvD
         18VmhO8PPr58jwLVB8c0UsDqz1H4G3FAEiK0ncLorQLoTIMxDJ4yoiZMWp1SjGRzLDv4
         Aqiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792690708; x=1793295508;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YMoLhmzCD6JxbrpCSqjwsvmu6iiWdz6TWER3dxYKCwc=;
        b=eIzw40avqWRZ/IDZaBBif57k0t9tUFsymfoZd3jI7H5zkzHMqvTT0EiLKXPn5JTESt
         hsG3Xpr/IDmC6HgKkd4jRUD3zhmtJsbj0tQV9ajhBHhS7z32dvtwJhjNVz1Hd6GKZgOn
         JMwKVX++F2Y3sK6qHBDm6UCdVESXy+A3o3e90TbHS+uHAzonQyczFD3whlXlJxf1PnU+
         UhRKeomBMv1EGmBZyucIoI/ujAaYQSFFCxXj0RKPgjzp0bwORTnrsGK/sngLH4EvJhi4
         CDC0UkRCJsCGVsmj1d1MTU5vZC3yq18KqGFLyL9DQog9ia2LVIR+BkORnJy4XSPzRzu2
         2Dvw==
X-Forwarded-Encrypted: i=1; AKwUvBxdsd9d3tgEFW6VLbaWa61AanninSUZYn17HgJcbXxTsyy6leZ7QMLc9oMzyXiBI5Uk1EML2eH0xw==@kvack.org
X-Gm-Message-State: AFq9FYJ5xpBoEbtaaKGB/p9JOtV6PWmK5C2m66MEvc6uP3p7rTeG/yCW
	dBG/mjhHB8qepcktECMQwe2qYgbTmYOs+G1OMgi6xGnjLdgqbAArlqdiXCe2KvdNHk8WiTb6Hgn
	APzycT4++15yyHUZn8gqiGJhz+tn6DvQTzA==
X-Received: from dlbrx21.prod.google.com ([2002:a05:7022:1715:b0:189:931c:18ef])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:1706:b0:176:2095:1ac4 with SMTP id a92af1059eb24-190a50ef697mr7116049c88.18.1792690707714;
 Thu, 22 Oct 2026 10:38:27 -0700 (PDT)
Date: Thu, 22 Oct 2026 17:38:20 +0000
In-Reply-To: <cover.1792690544.git.abhishekbapat@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <cover.1792690544.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <e917826641775fe6a1b36a36eb69657a217fcd30.1792690544.git.abhishekbapat@google.com>
Subject: [PATCH v4 1/4] alloc_tag: Add trace events for tracing allocations
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 71CB5C0003
X-Stat-Signature: dq38cfi8uu4sw3buybu3y3am3yh9gmgu
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792690709-609398
X-HE-Meta: U2FsdGVkX18nLAvwyt7b3rLASaJ5Kug4MUqt9xf9bx1vf6j3c7qL3wrpTgRzSLvXSREZOFb3DFH+tJcVcRZ0zwPr+qwiuGyKIDpjVmMHk/AFoBGJgsJwzSOskyP78oQcwHNzPj+qfxrXww08CaOLYQYbfZt0YUAgv6J74cYEvUJjmEXYJADx4QdPjmwZ7S2Le0MpqB6+yYxfvoNcF+q076dGkVoG4Ker23zRqudRqQ3dKkTF6/Y8dfBiWEoSVNWSesmlsnb5GK0SlB+csO00WU+qO2qCzQ/Ozg/xpfR5CRtLcMX+uaDl2j/x1mRR834UOozOEkHNWm+/w6ACpU7RJkNs+DD+yemIdCOCq6h3x42WjEuSl6DNL7t/I05/KEXYz2YhcEHNLIQSYFDjnH0jR9j8S7NIopB2S/uEM3ID1IRkqjVC7Nh5qeC6dCQiJ8VYnPLijBu9pRlMCnP3WI9Ud634r5NTV1+YbzJR7Im+OV/3nQPZaGL64G6WgL6tM6g23RoloEXa4uPoKGT8P2dv/8DW0jMbF05oZj1keFc1VFYQGB2wbnj2R9Ihw6jkEU6eUwwtE6aJQxtU1It419tC2mrMp2j7OhsZKmZnZRKeuq2oZUbvqtUcSDVpCqDP82Ygxsg3XQ3HLlc9HK8AtQKPkUl0xY4iCfNWLhLwIE2yoFUxY2TP7ggbftVk5ndDRpS6HbZmLy0tuQzcSsPL4PrFXf2exVNgwbx4kjwO6laE+MVVKxRyIvlU6cDdRBWi9BY0hmar8+ryoXG8cVal71i7JOMzOc3yqLOqVBTmjdbBfn4zb+c0jDQMR4TdyiYMjPt8kauoGP6kCD1tdqEl87qdH/BrYCP8yzcOopGSF9Ij16R6tlrz4iSsmft88t8E8h2XRkXctZElBsB5ylSdHG+rjrvP4+j6MfnAHWuAoPfEdZAguwfP9G/lylvO04C1VbuwIR9vWnnwPzejR5bN0pJ
 9kVmNPiX
 L1xj3yzylCJDaf+fo7nKu22gc4WymlwnzqhmSx3O4aUpmBawC6M6yxz9sfEjMwVfHM99aQlh/FLEVNLnKj+2DS1L92ztKRZkVBhFdNerV97eOB53ws7CPTH9Hpe58Hlp2Id/Y3WUuGpx/60flU6OzTymCmJMBI+0erFnDomo236USM1Ea3wh+EOGuMSWE/jWWHP8lR0HOvyRudirpOIOzdhapci3jOoiaP5em9SY0PKVyfL75QU8eYy9DE/Ll9sy3QLx3cvm4E56tVtLPxwaiJtvttQqIHvWuJWCmuR8HH/KSn35Ws688sFhlhz9KQ6vkZ18u5Lbxb0uqe/vGkWIedHZUS1Rz1FWzNbbinaPuksHiC+NlgA1Vu8tv9j6/nx59Wn7K1D7ErE9rpIqvVx5snTfU8az+woP7e+gkXFnjkXu1MgXQYAfBCn64QbjPsUGAfy55ZsVhqJ0LbRJ72dXBMO717Bjj1wBfF4HcJXDoNe4Do2qH4TucvrrWlkiaBSkm+yZEpFKqipG1uazzfdwvthCEY19rpP2siHFAA8kG+zKOpruj8xpZ0dd6r7uiP1m8oqnDjelXZcXbKEsLdEpKsmTCDH7KENQVxgHL0JF/JEPNjq8jeza3sh9OESrUzLGJjYZ8Dl1N3wnECYw3bWjEFRAM6EUIr59xMpyVo2HiFrwJ16U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
Acked-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Suren Baghdasaryan <surenb@google.com>
---
 Documentation/mm/allocation-profiling.rst |  53 ++++++++++
 MAINTAINERS                               |   1 +
 include/linux/alloc_tag.h                 |  69 +++++++++---
 include/trace/events/alloc_tag.h          | 122 ++++++++++++++++++++++
 mm/alloc_tag.c                            |  28 +++++
 mm/page_alloc.c                           |   4 +-
 mm/percpu.c                               |  13 ++-
 mm/slub.c                                 |   6 +-
 8 files changed, 270 insertions(+), 26 deletions(-)
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
index f93d7ed7a14c..d6ffa8ff0b05 100644
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
index 7f2d80a59792..cf8a29d463aa 100644
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
-#define alloc_tag_record(p)	do {} while (0)
+#define alloc_tag_trace_hit(_tag)	do {} while (0)
+#define alloc_tag_record(p)		do {} while (0)
 
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
+		/* Fired here to capture the caller's stack trace */		\
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
index 000000000000..58d420e64516
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
+ * used to capture a stack trace.
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
index 2daf358269ae..e8bb12a6a721 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1241,7 +1241,7 @@ void __pgalloc_tag_add(struct page *page, struct task_struct *task,
 	union codetag_ref ref;
 
 	if (likely(get_page_tag_ref(page, &ref, &handle))) {
-		alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
+		alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr, page);
 		update_page_tag_ref(handle, &ref);
 		put_page_tag_ref(handle);
 	} else {
@@ -1270,7 +1270,7 @@ void __pgalloc_tag_sub(struct page *page, unsigned int nr)
 	union codetag_ref ref;
 
 	if (get_page_tag_ref(page, &ref, &handle)) {
-		alloc_tag_sub(&ref, PAGE_SIZE * nr);
+		alloc_tag_sub(&ref, PAGE_SIZE * nr, page);
 		update_page_tag_ref(handle, &ref);
 		put_page_tag_ref(handle);
 	}
diff --git a/mm/percpu.c b/mm/percpu.c
index d7883507dc15..16f29020bcad 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1695,16 +1695,19 @@ static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,
 				      size_t size)
 {
 	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts)) {
-		alloc_tag_add(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
-			      current->alloc_tag, pcpu_obj_full_size(size));
+		union codetag_ref *ref = &chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag;
+
+		alloc_tag_add(ref, current->alloc_tag, pcpu_obj_full_size(size), ref);
 	}
 }
 
 static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 {
-	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts))
-		alloc_tag_sub(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
-			      pcpu_obj_full_size(size));
+	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts)) {
+		union codetag_ref *ref = &chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag;
+
+		alloc_tag_sub(ref, pcpu_obj_full_size(size), ref);
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
2.56.0.257.gf7497c7d27-goog


