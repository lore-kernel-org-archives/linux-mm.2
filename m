Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCF57CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:40:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E38366B0095; Wed, 10 Jun 2026 11:40:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E100A6B0096; Wed, 10 Jun 2026 11:40:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4D576B0098; Wed, 10 Jun 2026 11:40:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C33986B0095
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:40:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 754511A01A8
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:40:45 +0000 (UTC)
X-FDA: 84864415650.02.4CF819F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D4DEAA0016
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:40:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UaFWjH3U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781106043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z++mZQokUZ73KMQBNMzzxOT6j7m/HHKA2PQwEqwlqcs=;
	b=3V6aH9fy4mLqRy2ZRSktNf89gqtCJaodVt1Ij4yFC+PnBsQbMwJ+z/VXZQ39m6dkKaJFzj
	Qiu1j+4Gt9tmMy6GLtJGRYB+CQaj2SXK6zC0etMuJNMInpt/rm7kvjM2P7zT3mHcwhF7pJ
	SlApwGY6M4NpdHcX41axoxGg149wx9Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UaFWjH3U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781106043;
	b=ymp/qKSTNCcBQXfBYtwBToCn0izE5f6feaf6hKGKiPx7sMhqk6VoXl4bziZgIBu2zmMuCA
	Ap+NctNPCYsvtOtLPToC7uyi//+jB73A9LSXWwQxqGzkPiJS7/uAvz+3zAuTBdl94xuLgy
	sbJQoqwQ1l6C6vVMwm+hTh6KH58xWCk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 69409601FA;
	Wed, 10 Jun 2026 15:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B281F00898;
	Wed, 10 Jun 2026 15:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106043;
	bh=Z++mZQokUZ73KMQBNMzzxOT6j7m/HHKA2PQwEqwlqcs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UaFWjH3USM6+6T78Sjt/86W5bncAKXl2WivN7Bst2gu6MiEIipnORJuiZFcoMwV32
	 xupyRppQ++6a/7mKK+ctOLW5TePbzH3Yhw2E+7p4WhromGLsj9GNbMMLgRYi6l8/EN
	 ghoK46HcRrwqjfqY+ZGfOJDMbVPniXXl9hxUycYLI1AQyF9WNrUtthXOq224WXXReg
	 i/0NoPpfo7Qa9c3nnyqprZmjds3O4z7fn1inJhaSt31jFA+F8Vt4Wq3cbZZtNGFC6X
	 TmL/+f7gRnrwWNcxtIb4i4ZNqDxx/jkfHxfqjjMFRbq8YCQyI7QkHCTWfzaHOaepxt
	 2H3HaPXzgcwhg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:05 +0200
Subject: [PATCH v2 03/16] mm/slab: stop inlining __slab_alloc_node()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-slab_alloc_flags-v2-3-7190909db118@kernel.org>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 6crf8denkjq6tw3bh6iuw7567pr3adk7
X-Rspamd-Queue-Id: D4DEAA0016
X-HE-Tag: 1781106043-543880
X-HE-Meta: U2FsdGVkX19adtR2L9R5Nahcw8RaiPGtfYnHcPaFkI5o+wb4HZAjTcP0GygkgXHdQZFM1s6m9DLAMyZpivUxvpx70NNFB8AB3xbPY8ej1CLzgUdNPRpx0wq2/pFb8TOxnCcDNImZJJYDgZpZC7rURt7X05lATTP3l/mo6kAT8Bu7fU5OkVoCcgyIf5Im3SJigJeNw9eBJIlp9/J5B2UJKdyDXSpPmTU87CliiCSBpMWvb1ClJbHIcdVVFLoFcdYkPVNydG6s0mDDl3b01OWeiDU+zst9vfK+7YRg4WaiDCOyq2lBDa5LF63ac/nRNjOnlsypOfSSppYPV7837/33LU2kGeVWGxLQx4d96qJIZaGuMUNUQTyoSP+Bs1o5QyYDqDYkvEINkKG62eRByn9alTIc8L8NoVht06IbpRRcSprVm4mku0YV1ti4Ctn0fwOOncPSpLAGxnIgPV+VoymM+nh2lgNKJV3BCYRXe3TLgEQXukjE86AQwWEfe0AdM2iXUK574e3fpYx9KuIW0Di//WqCup3bf8mIdQFr7/8RYKFMkyXyo8C0ODcQ4La2XWTcJbukUZbHlRDe4Yb6EzofQo5xi6gYlNUtsEAPykmY0LTX16EpRmORbGi4vR+mWf7UtKu2fJ1yj+iOl1ahgVc9ADqK8xdHrkTiJSD0XQVXi5XtOMPpK2J2ppbxDfKLlST5xUbbJnVSHH24JXXfBQaDF5aJ9en2fLKwoo9jwnE+2f6jz4UlQcJsE41MO9P7Ia4gK0jdsh+VLTsUEI3AWXu5YXWV/UHzVrBdLgYJ57LGTH2fV3tuvEaQjnG4RQmHiJztzhPAPQOYwf4xy1h5LFT7C8eqoTQXZY9hahFYw/urBnI16ho6lY3AXETk15kV7aMPgJ12yzKgmAxju6dpMOaF1YT2fP89EmyhWoTuNm3++drbWQqt5Itq28vouuvOoGuKL3IwVeih7D1BaHs9t3t
 z4vAef/4
 46ZP2WRqwP2AA1WlMx4UygkVVag2KOMlSDEofnnMVBr/WwDtYPRB6kGlniiH7Hy8txWMwoJnmYgJuj/03hd2JLo7prnp4MjsgSBmq1Wtspr4sAL4kl0gAVAHce+XuFnZTmlKRntYLDgBABxqjqoRrmW67BmjR/K2jXy5AdwZ9kPtdPzZk5Q1AsAzolGSCPGMEg3PlOW8nXbAuHqDWxR+GGQ1CuREpG9QBHj1rkLAt13smtLJOFRTTp79UdSEFFjAloWwpLTX8mPDU4irC82lHG6ElFmYs6ArafKRU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With sheaves, this is no longer part of the allocation fastpath.  For
the same reason, also mark the call to it from slab_alloc_node() as
unlikely().

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8e5264d3ddbf..7b48c0d38404 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4519,8 +4519,8 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	return object;
 }
 
-static __always_inline void *__slab_alloc_node(struct kmem_cache *s,
-		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
+static void *__slab_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node,
+			       unsigned long addr, size_t orig_size)
 {
 	void *object;
 
@@ -4923,7 +4923,7 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 
 	object = alloc_from_pcs(s, gfpflags, node);
 
-	if (!object)
+	if (unlikely(!object))
 		object = __slab_alloc_node(s, gfpflags, node, addr, orig_size);
 
 	maybe_wipe_obj_freeptr(s, object);

-- 
2.54.0


