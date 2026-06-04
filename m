Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA741CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 11:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F0C56B0092; Thu,  4 Jun 2026 07:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C80E6B0093; Thu,  4 Jun 2026 07:32:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DE1E6B0095; Thu,  4 Jun 2026 07:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 20AB66B0092
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:32:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B5D0A4054E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:32:19 +0000 (UTC)
X-FDA: 84842016798.25.EAFC04F
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id C8E40180005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:32:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Aq7frTa3;
	spf=pass (imf24.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780572738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1GuPMUk5HjK1efq543yYrmfWbZP5fHMEwE2PeqlWRE=;
	b=3MKSbH06j/g+egPQMyLunrv4TcP0gW2EgnKDid3GfEG6evEreamrEY5gRfoud53dMlP/cI
	QTPa7mtm4AD2F/d27f4ILNmsogXonSew3UIX4pDYdYLc8q6FC+p4QjU1XOM8YygveXVKig
	maeCocH5uCdB3Dm1rdJFC86aqSo//bc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780572738;
	b=x+QiGWllIdPXHCiEiVMJjoCmB7swaz3NG5UmvtclU7vZaUi/1aKZImQnxoUtBGN7kKWwiN
	aNYP+837bEe0G7SUc41NagmX2CAYvMf06P9bfqPu3EcQtdqcxmJS6SJ1TfCXXieVkoN7aj
	l37Col3W3/aUhj6JfAnGHJwG4wYlEYs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Aq7frTa3;
	spf=pass (imf24.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780572733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a1GuPMUk5HjK1efq543yYrmfWbZP5fHMEwE2PeqlWRE=;
	b=Aq7frTa3xKlY0G3u8Xf7kVfMUeSdceuNDU0VEW/fswn5QlJmNaSTLJBnkwTnHpmxArAYI3
	SA4/98OFIeqzbOAy06Y9+hdk74dYQEaaSFPzpB8z+rhC9aAw/W8Sii2vTLSUPJ/1IoI49j
	LqHYoi0w42eJu1uDpEbDe/X0bT1QumA=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>
Cc: muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v2 3/3] mm/percpu: Avoid IO/FS reclaim in backing allocations
Date: Thu,  4 Jun 2026 19:31:01 +0800
Message-ID: <20260604113101.89510-4-kaitao.cheng@linux.dev>
In-Reply-To: <20260604113101.89510-1-kaitao.cheng@linux.dev>
References: <20260604113101.89510-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C8E40180005
X-Stat-Signature: p4f83dos3e8xsss74qcxn94w8zo7wfe5
X-HE-Tag: 1780572737-411823
X-HE-Meta: U2FsdGVkX1/3p9PMFoK5CneGvefUuuyEuzeUZpY43u/j8VGjJ4O+rX2ZtbjVosVPFf6QA8DdsdVjZ6oltQ2hd8F9rMbGABJP6oPsIqIb4imL8Mn6GwdNdkFl/K9LWFEA5//SGtppCWPXsG+EqT6wRnX8a7M1oEifcc696gVmF96DWOLlxAtyQx2bCVkfa9dgSFyeHkYPbcoYJfFouop8Jg2B3eX8gzgDzFcizNfxuIOWDiTaKoFqn6PeaW2x6eb0NsZa6+FvO1qYJMiPOd/QjLp1X0SX0tT5HrEszb9tHQ0LEPSeHopQGKwgVKWz2safuFsvah9n6cDyjmmGlr+FXRcgoIh6Atms/fGC6cYXodRX5VSuOKwFvtFAH3ylI7qx0hCUqGCpjsPxNKExrg6CdPUi88AHzWrNNUAS1BPC4dO9JorpcWWRbdDHTnK88HFeWAI2A9v9wi1I8Ajpu66jHgl49FwpidgoO22FEhcn1efeEBqqjjlZmiNI4Cmx0tNp3ToEVjMYNcf2PkFCDAvJql2KA89i6VAt5kto6dvZ0VT/vN2JGVrw4EMSS7TDS1ohdxF1YqysJ5bTBfAh/2/TYUtOZ8P/TJbNiOO1YKUzFRRuVl5LHqND2K5CdJSl8+yv8m440eQlGUpu5J/iXkdQ6ObC2rbUbdcpNibYQAnOD50qx6uR1r5itv+CLo4ZhjJgZ/A36b52c/gjfFEujUAh2YBYtL5mvZjvg/Q/7Vo0Ykes7XXwOJfD5Zz/FsqqgKWb1f0yYvUpVQTMQt2wtknlQ7E9Q3Vk2JPaJhRwae0tRhD4eQshZcvJ22X2rN7T+Mnqr2D6YZwyNBnSh6ACFqU702QaEaw2XR1Y6ny7giLicS9AmpRG8OpB3/m4KJwkyTSr9PhcyD/fmvG6M26s/RJNKk8Wua6SfAqqn0OWiCNLMZxIcU+NZSfWKo5uZLcVQ0afy/z34SIZ3jKXvwysIa6
 9XGF/tUg
 hQFMDfw+DKTcb7/JvD3uY1N3Esh45F/rhFyoJMeCX/6SAd1yIY9/JIGMyihlybsydh64KFRij3A8uQBT7n7glCMJbtPGR6E+Zmpf7Srgmza6b/VVvwi+G38xJAYsxJu7RY5pe6pokvX+3Wi5zD13xLJMUpBCJd8e5IIJM+84MwCYSrbySCWe5VsiJwBSOkW3GyLxQKQue1KgTxHY=
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
 mm/percpu.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 4d89965cba16..e6f449323064 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1726,9 +1726,8 @@ static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t s
  * @gfp: allocation flags
  *
  * Allocate percpu area of @size bytes aligned at @align.  If @gfp doesn't
- * contain %GFP_KERNEL, the allocation is atomic. If @gfp has __GFP_NOWARN
- * then no warning will be triggered on invalid or failed allocation
- * requests.
+ * allow blocking, the allocation is atomic. If @gfp has __GFP_NOWARN then no
+ * warning will be triggered on invalid or failed allocation requests.
  *
  * RETURNS:
  * Percpu pointer to the allocated area on success, NULL on failure.
@@ -1749,8 +1748,14 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 	size_t bits, bit_align;
 
 	gfp = current_gfp_context(gfp);
-	/* whitelisted flags that can be passed to the backing allocators */
-	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
+	/*
+	 * Whitelisted flags that can be passed to the backing allocators.
+	 * Backing allocations under pcpu_alloc_mutex must not recurse into
+	 * IO/FS reclaim.  Otherwise a GFP_KERNEL caller holding the mutex can
+	 * block on reclaim while a GFP_NOIO/NOFS caller holding an IO/FS lock
+	 * waits for the same mutex.
+	 */
+	pcpu_gfp = gfp & (GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN);
 	is_atomic = !gfpflags_allow_blocking(gfp);
 	do_warn = !(gfp & __GFP_NOWARN);
 
-- 
2.43.0


