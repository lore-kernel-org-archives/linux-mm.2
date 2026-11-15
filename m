Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB6D4606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 15:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kAUTRrsI
Received: by kanga.kvack.org (Postfix)
	id DCEC36B05B5; Sun, 15 Nov 2026 10:10:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA6BE6B05B6; Sun, 15 Nov 2026 10:10:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C95026B05B7; Sun, 15 Nov 2026 10:10:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC6976B05B5
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 10:10:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3793BA84AE
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:10:29 +0000 (UTC)
X-FDA: 85437689778.06.76C9A94
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 95854100005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:10:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kAUTRrsI;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794755427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2a5kJ1HnqMnnGqSgfzuFucPTLau+/T7+blaKIr3qVE=;
	b=SlYFX8YD84XdSbUPupsa6hXjUrOAvwhyv47JkUYAyInmf6AtNLP4go7QAP63GiJpL6DYMy
	t01Sx9+x3udE2Ft/eKNccaKyuUyD/Fe+0P8ImxKIiev+vskZMGB78SaDs2XEj6GrMY3gu3
	hMIelsurHyTKj8auBdVHGLF9Mg9HHnk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kAUTRrsI;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794755427;
	b=b8rnhtRqHDi9V3RA1TO/7TyZY7mdkGrVpv1T4w7z8XXORSTSpe6PkuNbOPiUJ58DJxbuFT
	UPFweXgxGPZ5oN3NlmJPwhyqWYpggJU+QegweWzSzGb9ZojSfWP+/sYW3UMHRWrX02YKU8
	v0ZXuvaXSOXvFi7KdC9jhLzqivlik/s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 316566244D;
	Sun, 15 Nov 2026 15:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8099E1F000C5;
	Sun, 15 Nov 2026 15:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755426;
	bh=J2a5kJ1HnqMnnGqSgfzuFucPTLau+/T7+blaKIr3qVE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kAUTRrsI5AVKr7aA5OHDZO+Hd92lf/KbZz07Af1lmBv1d0owwSModzgUEhSZ8Jj6c
	 7YZV5bWsVratJSD38MMLTI4GlF2fggwYiXgubkWPXu69/OzBYRKk/KU66yGGL9BOKD
	 Xi/5WJpQMDHj4Gm29zvoLdooGXxu/usbW5pHBJD1xn/a9Fhbar4xXvrlcHPwYjZzp/
	 5lbBoI973ZFbwReQ5BIa9K4Y8bnglwUoLffKskd6J9j7sd+ZRo7i7VhLPXwknVOm5w
	 4tcpJcaq1q3skOsegZbjTj8EANHqExhhtVim6salK6nPgWlBLUPOR/FnVIJazLeNTd
	 pfcJ/AwCHlUCQ==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Sun, 15 Nov 2026 15:09:38 +0000
Subject: [PATCH for-next v3 4/7] mm/slab: fix a deadlock in
 memcg_alloc_abort_single()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-kmalloc-nolock-fixes-v3-4-9034dd4ecaab@kernel.org>
References: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
In-Reply-To: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: fthr4w16fttbothwq88y8wm4uq399edj
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 95854100005
X-HE-Tag: 1794755427-775922
X-HE-Meta: U2FsdGVkX18QHtm695iAkKFynBzNZR3GJLEPBkpRuPk+C468D7EEaEaF+mtwpFcXe1ZC2gDuvcz6WM81aVGyzEJS7jLKB8P1RrAMuaUZr05PamoReAKrL3PqG9p4PpeiXxLNsp92fhewh3po4pS1r0UyhTc5FSZI2S0KQEBWwgxq3KMPywq/OzgTEDLDy9N4M3VSL3gFVwvoeH+b6qvvnpiq/0XkVRlenGerXE2EirVHnY3lEpqbcQUgRs7IVY5d8dBQB7tYMQoNBd133REca0fCXrWwpjSQP/MAXdF35d/YTAa6Vt2/ojpmaudlqoSyb52Y5OwAnlHL0MNRRL+V8aprFZUYAasqaCZpRJ0JUp8nacbv8/zCUzUDthlAKaxr3V177+4QeWgxcCftMqNtvseUk21L/t03ZFw3SezFpCOHH0ePZ+4ceLP6W/OOm71kbvHTYpVguTj5K/4XibXVVJaqOTavyHzqnSAzQtjCdNL+rCW2qYVXFW3nk4rnugXriGKxAA+xBuv0VrHILZrjvGRqSQkb5/cwmuZDXhUftPzhzoJPMV4j84ikfP6y1BeVHTHkgxlyBw971LOShxEmdi8ZAegjcvS2mIF1aNJxFYtLmpuaCWza5OEYmZ4AQvMZ70+BmXcQVmNdK2AnzcmBIuka5Wx1ju4Ftc2ofMX3TSPzOpAvf40N1FMrmbGvUfw0yVQsKa0McZkMJ8HPoCTg0xsHcG7H9yHuJcBW5danMScJlya90HaPzUHN8RAhRd/8vXHtaLqM2Xgz9WiO2Ge2HodEwQ7tjiWDH/ljp7FoUTX5wgxfwHbZ1WSr6B44iKCGeuP2OLTKo5v/8s7hK5T7VKtenY6HCXcxHjeZvENO7aQv+JskH92aXkoZ7J/AlGrxaLXYri9mksXHcZWLDApR9mKTB/ZcS4uG6zbIWBKC+v6IR4/A5ObsjQ7zFTwJOs4BdFNW8ai3u+r2ES3mP9o
 4SNt2jXl
 Gf+tlbW8LKVeaJcsDwBDOU/y9ZFLd3wR27FMgFRjQu9Ht3d8H2vHkcpS0H9fQ8NdHNlJ9qXZMQNBnK/ESynNMNU6WqA+il++wpuXeJe6KAk5T+sqthoR6e7w2VFU21DRb2WHxrJyx0KDfTPMgnTRXYHImaQrLgIiVFkgJ2DGbTw6ZP368o1NE8HbhQwuwK3LW5isBDQWz2AHkrwgF3ZSICUQ8KE5N6653GZ5n/UZi2NtOO6PQUOMR2r3VMoEXre+6bupK672zuK1FvnGbY9+16t/nnkk70/gx7OJJToqhme6nckF8eZTqxrVdSNRYFpd+a+SZQ6MXo3HR5qztoODgfn8N7xMxkznh3JRS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When kmalloc_nolock() successfully grabs a slab object but memcg aborts
the allocation, the object is freed via __slab_free(). Calling
__slab_free() in unknown context is not allowed and can lead to a
deadlock.

Free the object via defer_free() when spinning is not allowed.

While at it, try freeing the object to the percpu sheaves first in both
contexts, as kmem_cache_free_bulk() already does for bulk allocations.
This also avoids queueing an irq_work for every failed charge when
spinning is not allowed.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260610-slab_alloc_flags-v2-0-7190909db118%40kernel.org?part=9
Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/slab.h |  8 ++++++++
 mm/slub.c | 22 +++++++++++++++++-----
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 15b0d98ae1d4..fb80a72ad952 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -37,6 +37,14 @@ static inline unsigned int to_alloc_flags(unsigned int free_flags)
 		return SLAB_ALLOC_DEFAULT;
 }
 
+static inline unsigned int to_free_flags(unsigned int alloc_flags)
+{
+	if (alloc_flags & SLAB_ALLOC_NOLOCK)
+		return SLAB_FREE_NOLOCK;
+	else
+		return SLAB_FREE_DEFAULT;
+}
+
 static inline bool alloc_flags_allow_spinning(const unsigned int alloc_flags)
 {
 	return !(alloc_flags & SLAB_ALLOC_NOLOCK);
diff --git a/mm/slub.c b/mm/slub.c
index 7c0adc104988..8252c0b681cc 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2531,7 +2531,8 @@ static inline void slab_obj_ext_has_codetag_init(void)
 
 #ifdef CONFIG_MEMCG
 
-static void memcg_alloc_abort_single(struct kmem_cache *s, void *object);
+static void memcg_alloc_abort_single(struct kmem_cache *s, void *object,
+				     unsigned int alloc_flags);
 
 static __fastpath_inline
 bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
@@ -2549,7 +2550,7 @@ bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
 		return true;
 
 	if (likely(size == 1)) {
-		memcg_alloc_abort_single(s, *p);
+		memcg_alloc_abort_single(s, *p, ac->alloc_flags);
 		*p = NULL;
 	} else {
 		kmem_cache_free_bulk(s, size, p);
@@ -6647,18 +6648,29 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 #ifdef CONFIG_MEMCG
 /* Do not inline the rare memcg charging failed path into the allocation path */
 static noinline
-void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
+void memcg_alloc_abort_single(struct kmem_cache *s, void *object,
+			      unsigned int alloc_flags)
 {
 	struct slab *slab = virt_to_slab(object);
-	unsigned int free_flags = SLAB_FREE_DEFAULT;
+	bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
+	unsigned int free_flags = to_free_flags(alloc_flags);
 
 	if (slab_want_init_on_free(s))
 		free_flags |= SLAB_FREE_INIT;
 
 	alloc_tagging_slab_free_hook(s, slab, &object, 1);
 
-	if (likely(slab_free_hook(s, object, free_flags)))
+	if (unlikely(!slab_free_hook(s, object, free_flags)))
+		return;
+
+	if (likely(can_free_to_pcs(slab)) &&
+	    likely(free_to_pcs(s, object, allow_spin)))
+		return;
+
+	if (likely(allow_spin))
 		__slab_free(s, slab, object, object, 1, _RET_IP_);
+	else
+		defer_free(s, object);
 }
 #endif
 

-- 
2.54.0


