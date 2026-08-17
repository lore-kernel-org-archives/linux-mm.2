Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F29BDC5DF70
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 17:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDC3E6B085F; Mon, 17 Aug 2026 13:22:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3456B0868; Mon, 17 Aug 2026 13:22:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA8D46B085F; Mon, 17 Aug 2026 13:22:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79B926B085F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:22:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B7CE940876
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:22:36 +0000 (UTC)
X-FDA: 85111430712.30.FC2D5AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id AC3E040008
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:22:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vgm6nGYx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+jim.cromie.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+jim.cromie.gmail.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786987354;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5+KmLuLMMLwjIxfc/Fnhyr2GjdPZm0VdgVF09lUELrQ=;
	b=KQJfxGk5+WxqgKPvSnBdZvRn9TymTGYX/XaV5aAfXRP8LRCjhb1Aj8vbM+G91LhTr/nntl
	PoCReP9VFDUmEIq3pSs8KQ3xNnrgqARGusWh8JCGvdx/yPxTcjZbqs5DmkZb9e3YRhZRTv
	MrOX3WGEe8OrCjFhWQC/4r1SyfApJJU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vgm6nGYx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+jim.cromie.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+jim.cromie.gmail.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786987354;
	b=8k+B+WgcDFBx8bq/xIPEj5y/FHCjE9mwtqUuXmGPczpEHC07jX15KZ+7vYzdhnbrt+hT14
	686xoZZuPRZlx08g9NL+aswEbcpLhaCG15U4yUEMxqiHWCHHDiOl6N85BtsNy+Vu5WJKJa
	WaRONveInyr5KSvl/yqg544YzwlXX00=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DCC044015;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7AE43C2BCF6;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786987351;
	bh=RVVE5r0NGUE4k5ybuOlp+7aHs2IlhNHimZ4YfYSSYDE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Vgm6nGYxPCpnhsPyBgdcgF8JbuxFF/gy/YpTLAh4AKZLyV0AmkmhdqB4ijiDN8khe
	 d340Rr/KNdjeRaI8m59OUPzO92PqxbPW8i3f3zry1G9MtF/bAX8+tbShkp742iWpyO
	 WfY44+cLHZhbzyyWPz6Txlra1l3JKspyLvgK3BBASHhU+Z2E2AFGwEvsJ7yhzVerx1
	 5v5mnOrdoDy/qA8hk+7aDRJ6j9GQ2IwAj2VkSCRpYdCvRZcljSxlE7ex2jcvYIfaQ6
	 d5uQdEcENIC0s+Px4jfZxngrNy+jKzR6HQvWyTgsY4H/zIr9QwVXyJZkBEMtkk1avG
	 4kb03jlxCo8oQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56928C5B572;
	Mon, 17 Aug 2026 17:22:31 +0000 (UTC)
From: Jim Cromie via B4 Relay <devnull+jim.cromie.gmail.com@kernel.org>
Date: Mon, 17 Aug 2026 11:22:20 -0600
Subject: [PATCH 6/9] locking/lockdep: Fallback to folio_pool in
 alloc_list_entry when static pool is full
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-folio-pool-v1-v1-6-0c1d230aa3af@gmail.com>
References: <20260817-folio-pool-v1-v1-0-0c1d230aa3af@gmail.com>
In-Reply-To: <20260817-folio-pool-v1-v1-0-0c1d230aa3af@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
 Eduard Zingerman <eddyz87@gmail.com>, Danilo Krummrich <dakr@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>, 
 John Fastabend <john.fastabend@gmail.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Alice Ryhl <aliceryhl@google.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Boqun Feng <boqun@kernel.org>, Boqun Feng <boqun@kernel.org>
Cc: netfilter-devel@vger.kernel.org, bpf@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, coreteam@netfilter.org, netdev@vger.kernel.org, 
 Jim Cromie <jim.cromie@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786987349; l=4052;
 i=jim.cromie@gmail.com; s=20260203; h=from:subject:message-id;
 bh=Hw9H0XS3lRz/8Cusmj0TdRoN7GOnkgdGE/QpF+OTKZE=;
 b=7ApQuwEsLmNusDVgP3wGCUer5jWN1Mvb2G7RmfE1VdvcfA0Sc3zPBxPrhepGf2Qoooi58cGiI
 /JMtsQaQwZxAKM58qj6awvp+EWf0JxWRjrcSmYqhuYL91ZsT2xJmsy6
X-Developer-Key: i=jim.cromie@gmail.com; a=ed25519;
 pk=C6E5ODlPQo7ZBynATXH9wg7K6HxP0pIXyf4s38Qw0XE=
X-Endpoint-Received: by B4 Relay for jim.cromie@gmail.com/20260203 with
 auth_id=958
X-Original-From: Jim Cromie <jim.cromie@gmail.com>
Reply-To: jim.cromie@gmail.com
X-Rspam-User: 
X-Stat-Signature: metx3hhwmdm5uh9o77nwra5hf61j5b6a
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AC3E040008
X-HE-Tag: 1786987354-869115
X-HE-Meta: U2FsdGVkX1/3inrQa2xqUr9fk7JtFThGmdAgOTFo9C+oSkf7IDVnzyXX4FhX+xcfNAxTkXc1cepdL9UW6/A7p8gaIoh10Q3hGIm0LM6R05bm/dUkS3kA8LoVUzsS0cg6kNDNwTzBewYbJ4bkCa/IduW4/1WW5bQP+dBJ83mE8AeA2ykqtlmDbyA8cycdUeMx1ahQNeelblt7sceQctbZzqvkQN1tqSvwVfUVe7XbR6yZksbDUsLroC1GmbeqjrM/AKmGm8lxAucCXbCq2uBGdL3m878oQweXrowG6Ico44gDi8ORMMXObBoawnhaDpKKVzczQolNCymrTh6Q4F2NrnOqPOMfUYTjF4n2OHzgav+WSU/xU94qjO3eW9tRcVluCPWWlfWgtLR7NkE+RqPs90tJ3kLSnk5qt0MxsSu3qQ467yPJEtIoDWURNFkQd1Kj+TznnAruNxNGK7ym6t4ZasbqGBnIH07NRJbJQhKd1ajLNtu7KKt0k6QcMdVypNeyt0n9E9WckuJy1Eviq5qjTdSAoaotB23Y13zLbQQcosDsbEgANRj8LUbHhUglNfEoxdIDnSvRZ6BIyOkLhQqACnurNcOuCHCM5goJemXgEAWPkFDZj69vV6cN9gfSL1fYQ0auWlXonYXITr5PxN9Y+lAurf/JZCq+BxP/eEMhsCiXIpoqrxTdb/fs+gagTAufVKset7sX4/xjUHOn6PbnvdNb5SCj6/EfE4KSPPlZtBNxdWCkpBEYhnc9Zp7JVCO2L31ZdT/a4rwpluyAWskAmXorvuaLt39K0wqtQog4A0KhYWZSDZ5lw8z2wUPnQOX9Y91230eRIJuveLESSLVBzg1T/pHQh+F3cQ2ZeWkGZlXGvhC/e7jx1wDsM30efnO6pDvXS7BksFYg1n1D2wksMF+kW3fFnlI0pJ2B0cnWToB+wZE2z2Mwe2RaTejzGdCXJgKN4NnQ/7CIxLBwPvy
 js6sjjG2
 l9QGYmLlG9amDcKnCkQikd6LRgs7KwpTeZD/PMjKo+Dr0NQkK+soqJE5BarLC+3iXOk5X/4AbOP6CEVhYY0A9YOSSJEFqdLuRUIhQWe74+OLXz8OhZuKDCe4qS+5joY9+AVsX2AI9/vUlcJInQbZh8dOOyoQx2OzS+Kp62FBs6A5c8wfrvX3J5pXSh2zdaN5Ri6B780FkbV1JR+9Q+2Y6lza5Q3f1a4Ra9509cLZZyFKvs1y1XAyJDFPpkenFoljvd/WetKT2J5nnoPKhp3/4ynqHIWCIBketHMn9+qI/r28fH0op7Eh49XXLRMdurgdCnWfjkhumQ5fWawua1IBJAx8+XTj5vufiEp0yRM+H1SKF/+MOk6PGdjt7PRchh0tnOoIR3SWWRMCg45gB18XOf8AMQVxNNF04BoK24PXLHVG/8tG5Yj6ikvU4BBhxVi1krra9E3vacow3fm2N2xwGCywvXQ6vHV9VrlNQdAhYWR5I56NWxEq3JHIEkyr5F2HJfhn01rSGeMnYi1Rbe0qNiA1MUIGsjqopnmnB5rwPm3qv5dhbx0HPIkXhAO7Kf5/qh9f1gpVbGabNNfpudltlY5NiPj8VsHyDcdPrwwn0EBIht9Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jim Cromie <jim.cromie@gmail.com>

Use struct folio_pool to dynamically expand lock dependency storage when
the static list_entries pool is exhausted, avoiding premature lockdep
disabling.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 kernel/locking/lockdep.c           | 35 ++++++++++++++++++++++++++++++++++-
 kernel/locking/lockdep_internals.h |  2 ++
 kernel/locking/lockdep_proc.c      | 16 ++++++++++++++--
 3 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 2d4c5bab5af8..f0f58db090ff 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -58,12 +58,37 @@
 #include <linux/context_tracking.h>
 #include <linux/console.h>
 #include <linux/kasan.h>
+#include <linux/folio_pool.h>
+
+DEFINE_STATIC_KEY_TRUE(lockdep_pool_key);
+static struct folio_pool lockdep_pool =
+	FOLIO_POOL_INIT_KEY(lockdep_pool, sizeof(struct lock_list),
+			    FOLIO_POOL_64K_ORDER, &lockdep_pool_key);
+
+static int __init setup_lockdep_folio_pool(char *str)
+{
+	bool enable;
+
+	if (!kstrtobool(str, &enable)) {
+		if (enable)
+			static_branch_enable(&lockdep_pool_key);
+		else
+			static_branch_disable(&lockdep_pool_key);
+	}
+	return 1;
+}
+__setup("lockdep.folio_pool=", setup_lockdep_folio_pool);
 
 #include <asm/sections.h>
 
 #include "lockdep_internals.h"
 #include "lock_events.h"
 
+void lockdep_pool_stats(unsigned int *nr_chunks, size_t *chunk_size, size_t *tail_used)
+{
+	folio_pool_stats(&lockdep_pool, nr_chunks, chunk_size, tail_used);
+}
+
 #include <trace/events/lock.h>
 
 #ifdef CONFIG_PROVE_LOCKING
@@ -1404,11 +1429,19 @@ static struct lock_list *alloc_list_entry(void)
 				      ARRAY_SIZE(list_entries));
 
 	if (idx >= ARRAY_SIZE(list_entries)) {
+		struct lock_list *p;
+
+		p = folio_pool_alloc_type(&lockdep_pool, struct lock_list,
+					  GFP_ATOMIC);
+		if (p) {
+			nr_list_entries++;
+			return p;
+		}
 		if (!debug_locks_off_graph_unlock())
 			return NULL;
 
 		nbcon_cpu_emergency_enter();
-		print_lockdep_off("BUG: MAX_LOCKDEP_ENTRIES too low!");
+		print_lockdep_off("BUG: MAX_LOCKDEP_ENTRIES too low and folio_pool exhausted!");
 		dump_stack();
 		nbcon_cpu_emergency_exit();
 		return NULL;
diff --git a/kernel/locking/lockdep_internals.h b/kernel/locking/lockdep_internals.h
index 0e5e6ffe91a3..f802160c0dd5 100644
--- a/kernel/locking/lockdep_internals.h
+++ b/kernel/locking/lockdep_internals.h
@@ -159,6 +159,8 @@ extern unsigned long max_lock_class_idx;
 extern struct lock_class lock_classes[MAX_LOCKDEP_KEYS];
 extern unsigned long lock_classes_in_use[];
 
+void lockdep_pool_stats(unsigned int *nr_chunks, size_t *chunk_size, size_t *tail_used);
+
 #ifdef CONFIG_PROVE_LOCKING
 extern unsigned long lockdep_count_forward_deps(struct lock_class *);
 extern unsigned long lockdep_count_backward_deps(struct lock_class *);
diff --git a/kernel/locking/lockdep_proc.c b/kernel/locking/lockdep_proc.c
index 1916db9aa46b..3e6f24ae9b34 100644
--- a/kernel/locking/lockdep_proc.c
+++ b/kernel/locking/lockdep_proc.c
@@ -288,8 +288,20 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 			nr_lock_classes, MAX_LOCKDEP_KEYS);
 	seq_printf(m, " dynamic-keys:                  %11lu\n",
 			nr_dynamic_keys);
-	seq_printf(m, " direct dependencies:           %11lu [max: %lu]\n",
-			nr_list_entries, MAX_LOCKDEP_ENTRIES);
+	{
+		unsigned int fp_chunks = 0;
+		size_t fp_chunk_sz = 0, fp_tail_used = 0;
+
+		lockdep_pool_stats(&fp_chunks, &fp_chunk_sz, &fp_tail_used);
+		if (fp_chunks) {
+			seq_printf(m, " direct dependencies:           %11lu [dynamic: %u x %zu kB, tail: %zu kB/%zu kB]\n",
+				   nr_list_entries, fp_chunks, fp_chunk_sz / 1024,
+				   fp_tail_used / 1024, fp_chunk_sz / 1024);
+		} else {
+			seq_printf(m, " direct dependencies:           %11lu [max: %lu]\n",
+				   nr_list_entries, MAX_LOCKDEP_ENTRIES);
+		}
+	}
 	seq_printf(m, " indirect dependencies:         %11lu\n",
 			sum_forward_deps);
 

-- 
2.55.0



