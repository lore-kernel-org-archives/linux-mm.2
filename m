Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 343CECD98C7
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 02:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB9236B0093; Thu, 11 Jun 2026 22:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68C46B0095; Thu, 11 Jun 2026 22:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97F236B0096; Thu, 11 Jun 2026 22:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 812056B0093
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 22:27:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 26CC31402EE
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:27:47 +0000 (UTC)
X-FDA: 84869674974.11.FD727F2
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id 81998C0004
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:27:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I6VwxpXW;
	spf=pass (imf28.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781231265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J25QEy3RWj5FukLYgh1MkxBYO+iaiqbLpHb0hwGiAxs=;
	b=hKbcuSwq9D9OWegO09S/V68QEuq5bGvkYyahZ74SqOpme6BrVrolzI9g6LGS0yCxPFV3g/
	uNhXK/ASLCVsuLtpRAARd2id2eeuo++DghR+NDvUCzU3TjasaoF3Nwn18MQUx8ppKYoE3T
	8WL3Vmjj4fnijoY4ZXlgcGl4byUybpo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781231265;
	b=IEqDblTi4ex2vSlnxAv0BSscS7pu3jSo4ukqlrgvFIhlW6YpIRUtZEIj8ztLoC/nAXFJVX
	Ndk2xP++b9wVOFAOvSGZnbAkxxoLEHF3dP42yQkuz/wd2twCnGERSow3vMmu5CFamcFhAT
	fXgASDmXrzepyEd+WS/9v3WZZjmZZ7c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I6VwxpXW;
	spf=pass (imf28.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781231264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J25QEy3RWj5FukLYgh1MkxBYO+iaiqbLpHb0hwGiAxs=;
	b=I6VwxpXWie5zX4bjcsziDOFXe5AWH/DMYXpjOwi6qMFieGYjdrbsvnPPaD7alXKgMU6kP8
	LPiYNEGoAqZcHi4rXFYmhp9W6ZtxYv9lvq3bwy1PDW2G7lrLnH/Wb2oPCujpmyjgGPmtL/
	xwx86JQFYPSLpmllQFfAgMuUgE2TLlg=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v3 3/3] mm/percpu: Avoid IO/FS reclaim in backing allocations
Date: Fri, 12 Jun 2026 10:26:48 +0800
Message-ID: <20260612022648.13008-4-kaitao.cheng@linux.dev>
In-Reply-To: <20260612022648.13008-1-kaitao.cheng@linux.dev>
References: <20260612022648.13008-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 81998C0004
X-Rspam-User: 
X-Stat-Signature: dd4ue15iyhmw6hsfkztphrrtsbhhu6ng
X-Rspamd-Server: rspam08
X-HE-Tag: 1781231265-45255
X-HE-Meta: U2FsdGVkX1+2pxTN048R/edL06wM10iboDBmR2eA/N+JS+DJ2xBIuMExm7qvC17b4VuvmIMLhxYF6w+rxDBIEIyEsyHenDR39Z86gPTVwvTUF6X1fldjuQHakfxJ59d/kJW871GjTwA0Oc/WvUKBYi/f+DksNn9HlJjaYQf3g+HCjmF+NEagYPeQBgueiSH7v9SababfR2WGZx/WA9ZFtUjyNM1gYnIR548zgJHAwjvX3Xu/He5AlVGkZzueoO40/acpDYH/eoNAz7R6LQYqeNPJ45bWiryhs2Al9R0VWIOLar1zBTyZOjh35A0wfQjFCPei5eDGSTCbHVS3trRINW/Ix5VFbM0Az8dCgX8f2zrlkWfl3xlzOQzQg5LPdREz6mXdIyxcMWUUKN4vk7t3vL+2YMzPqjVRcNyU0EM3OquP52+FLhtEBQHBRm1/AXMQwye0PYewZ41SShmmihlzDExyX2Ki3/NvK2sthNJj9T6KeBrynOq2nShoLuQ1rRpPX9Dey1K3t9meSqw5jbYSkl8tC17MiYwYOQ4BT+V6P1TeTSLrxlLOfjBlotPMPHl60HdA0DDec5FWct/agolcsSrEFFM0mP0BT65JOJ9kd/ISaesRfsGjQA+pnsw0YQKE5tK+CYHxAunYpiZQJs/rXu+6wdGkja83VsrAmYPJM5eiLbYy+3MMJYiFMnr+LvTqfE019Ado3IFzEoUeZ7/p7B9EG/dJMUVV45uZYrgtFkqJLoWl+Kosna+/SinDvqaBuq38qSoDDztm3bAQ+9MxEzoax7ot7+E/xAREe/qPlWTYWT6/CyY7I3fIzyqQ7EASwNa5Y7CRm2MQxENc5pb+0BMTcy50F1iFE2KBKWzdNTeuL/l/5qU61PTOdx4FVJWWlaTi/LzP4sLKwBCGjsTK5pSs3iCwGzbrjNTaKL8exoJ17lf9fcXoFTyzjZ365za9XGuyEI+yYHtuO74wEJa
 CV3M6IcB
 PIa5/NRGSPIV9bNlaYlQyBRBLBuxdFOZ3Y+nGShpuL4Eplp9efg6ThPFGwkpIj4xAg9arhoxLTeU32fkuHfbkNu1HFgiAVhQh2W3w4i+JbEGxYap3CMNTnU6EpmHP2lboDxf8euYtBwdvIxHa2JNcQ3e1LhTAkd3IAi00lF8eYl0fiVLVKE2tpW+G1hrcVCnpNFsvmvSaG5LyfFA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

Commit 9a5b183941b5 ("mm, percpu: do not consider sleepable
allocations atomic") allows sleepable GFP_NOIO and GFP_NOFS percpu
allocations to take pcpu_alloc_mutex.  This avoids premature allocation
failures, but it also makes the mutex visible to callers from constrained
IO/FS contexts.

Thread A calls pcpu_alloc_noprof() with GFP_KERNEL and takes
pcpu_alloc_mutex. Since the internal allocation is not constrained by
NOFS, it may enter FS reclaim while still holding pcpu_alloc_mutex,
creating a dependency like: pcpu_alloc_mutex -> fs_reclaim -> FS lock

At the same time, Thread B may already hold an FS lock and then call
pcpu_alloc_noprof() with GFP_NOFS. It will try to acquire
pcpu_alloc_mutex and block, creating the reverse dependency:
FS lock -> pcpu_alloc_mutex

This can still form a potential deadlock cycle.

Avoid the dependency by restricting percpu backing allocations to GFP_NOIO.
The public allocation still uses the caller's GFP context to decide whether
it may block, but the internal memory allocations performed while
pcpu_alloc_mutex is held cannot recurse into IO or FS reclaim.

Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/percpu.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 4d89965cba16..47824061a701 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1726,9 +1726,9 @@ static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t s
  * @gfp: allocation flags
  *
  * Allocate percpu area of @size bytes aligned at @align.  If @gfp doesn't
- * contain %GFP_KERNEL, the allocation is atomic. If @gfp has __GFP_NOWARN
- * then no warning will be triggered on invalid or failed allocation
- * requests.
+ * allow blocking, the allocation is atomic. If @gfp has __GFP_NOFAIL, backing
+ * allocation failures are retried. If @gfp has __GFP_NOWARN then no warning
+ * will be triggered on invalid or failed allocation requests.
  *
  * RETURNS:
  * Percpu pointer to the allocated area on success, NULL on failure.
@@ -1749,8 +1749,14 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 	size_t bits, bit_align;
 
 	gfp = current_gfp_context(gfp);
-	/* whitelisted flags that can be passed to the backing allocators */
-	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
+	/*
+	 * Allowlisted flags that can be passed to the backing allocators.
+	 * Backing allocations under pcpu_alloc_mutex must not recurse into
+	 * IO/FS reclaim.  Otherwise a GFP_KERNEL caller holding the mutex can
+	 * block on reclaim while a GFP_NOIO/NOFS caller holding an IO/FS lock
+	 * waits for the same mutex.
+	 */
+	pcpu_gfp = gfp & (GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN | __GFP_NOFAIL);
 	is_atomic = !gfpflags_allow_blocking(gfp);
 	do_warn = !(gfp & __GFP_NOWARN);
 
-- 
2.43.0


