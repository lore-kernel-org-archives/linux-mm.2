Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A6C4E668AA
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 00:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABAD66B0088; Fri, 19 Dec 2025 19:27:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68746B0089; Fri, 19 Dec 2025 19:27:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 974656B008A; Fri, 19 Dec 2025 19:27:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 833D26B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:27:55 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0D32B16032B
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 00:27:55 +0000 (UTC)
X-FDA: 84237961710.02.50D0FB5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8495C180012
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 00:27:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IFDFGDQn;
	spf=pass (imf24.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766190473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=z41Y4lYi8ApBh35NT2Kw6vmYaFS3Uq3m5s9hJcP024I=;
	b=x0Z/3YGn2Z0wStmbtb9KHWv7fly7afPsobQYeCS2M03JvaxqvnvcSjrj8mfFN9+4Nx+bpz
	HgJ7VX4Tkxx80FJaPqqmneNwiRpMsrudnlmr4I+JfRMBnTzYik6ZjUaNR/ylhulGjajcPq
	3S41clzay5B8UwP4a5cKD+GmgTY1yE8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IFDFGDQn;
	spf=pass (imf24.hostedemail.com: domain of dennis@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766190473; a=rsa-sha256;
	cv=none;
	b=5VPAsVdRvdlfGBRs7ZQ3o+0NbSeba0Ou1qQ0W+dAxpxHyaiVZmNS1R7TKFWCKWPQxRnjUQ
	y+/88jcS07s6vpuvDjeX0O2xRjIx+s2V5VEGpEj6AtgFoXw58N5wAK5XtWizi7/Fd9fQTh
	COesXf3Tgh9BY86GSQpmtVd+9V2W6hA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D8C9260148;
	Sat, 20 Dec 2025 00:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C86C116C6;
	Sat, 20 Dec 2025 00:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766190472;
	bh=7Z2OUXbptO/NfN1gs7yJUEVPzBYeU2xaHDk1S3Mo/cg=;
	h=From:To:Cc:Subject:Date:From;
	b=IFDFGDQncdyg7irsjOsa/9aWsv/+Acb26f0qgrg8YAxrs22pQGTxDChAWem+2bFrJ
	 EbRLXyi+lW0tTs3xp138QclAIRiecBbtUcuicSE3UerdJujDsUK+Kse0YgWF6JYBXG
	 Z00G1TMsYgnQSs23ADduzsthRm6vD2AfS0RUSGLJvg7aNLE1SRsOrfvmb4KbEgPO3a
	 KHnm7ehQyGxlcZul4ihITO/zG71ScxvHHFnamV/9Vi6HN4QXVIQcqCIzFbKVXCJRVU
	 ZItKb54c4kt/vXb5W8tztQV5r/vXOuXqL2uXzh4gEb2ZAOlWD/zwWpMIx8PlCNUsVz
	 ALcxI5JsrqqeA==
From: Dennis Zhou <dennis@kernel.org>
To: Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dennis Zhou <dennis@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] percpu: add basic double free check
Date: Fri, 19 Dec 2025 16:27:37 -0800
Message-ID: <20251220002737.84100-1-dennis@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8495C180012
X-Stat-Signature: dzk9kcxrcauwxxgmbzpjfpjuqnp7pzw7
X-HE-Tag: 1766190473-124643
X-HE-Meta: U2FsdGVkX18DxSwjOcEaV/zB73QY1BuY/o//ZxROh8bGyl/zYiAyktKlrNMEkG9rI1wSAvcZvFpUAW535u6sv9sLFufD9d6op5hXyTZUaPBy/SI2WnZOtOMsG95/FnKjoURzoUNM6ue37xOg/4NxBCWOPRg28uM6G/aGxUuiGKEfosws3jK4gJhWm46+7HYG1VQJDvR3V4dWqX1OIEywtiKlj2tdYGMiHjUgxtCl3GD9yFAp4VpNVe83bTq4/Uw87Mirmkn1KYFgExOUhvy8dRnPOVoGPgqsSq3y3DoVpllZn7xWjjNg5SEGiCaRmHIMbMyZyoHRxFd7Cq5JE4PTMM/89QbC0YxmMCizJmbc0r0uT5Rn/jdX47s7suQED/1PQ5HGp0fN5d50hQbVzyNDNeweO8BPlijudXIn4m2WCuwizMqKiU0o9Ir7oO+td/DlGnpPYgkFe+txgwPNjdsjkUVeBDsjywpoHWW/E1i/rngksigwG9Sio4VYENhpfWgwKOlWN7ancGzM/i1GDBOwAzOgwjI91ayqjxY1kUBEiT1xKCI3MDCYZTEOQS5eZbOpLHLIFjy4ZDSliPstHtEK8m0xlrB1V/fRfRmVwh0LTVZsEbzu4/pC7HdNIgWBtBGjX4yBQVM7ho0Os46jzX9j3sPZ57NXAF84uBO953fAdUpQj8xedkz0iy2+xAyetXfAqG9ZOUyxT+eDTWdnHOTEdi41/4KFChOyWBx2xuffK5dDIjTfzbpXHnevIybvKlL7QNKsO/NrGycr0Ns65qfowwdtsNMoG9a8aGpKXq4XpNrW9fj/+am/9k79vNB6NfYSqygnqURoxlpX7Dmpwdl02drtkyYwFtwE24804uEqhTwbBP5ZhT2mzW9KA/1VDfC5hMuD94OwMSu6FfegyvgS+xToveQ6JeBV4Ijr1bY6jAz+UprbugaxosptbmFGKSwCUWZafXz0ukNmAzPBQqp
 H4O+lE5+
 CGh+mt337rHt5RKnjsWxPRF20NzB7Q2EGYKa0f1Yxj3a6uGdbIMh/RpLrXhtw8Y15Q7d9cSpPfMOf5SRRx7FOvtUp1TmZsM/7YPASH9a/0bQTp+urOV5JhESK2U5nDkvLIuIfKfGSJmVuO0nFvT3qPUKLXxkpu3iIU2tNcS/X7oXzvQAZpI64KTfqR0KqKMC/8cpvbLhnPxckRAal4XyanMkr7Ss0d8Fa/xJ8iLRoEyuVYFkxGBxyJ8tIUOIZP58qBmqy7a74J6CPPAxxg+dxQD8CVYaRocapK2FfsincOqF72YA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This adds a basic double free check by validating the first bit of the
allocation in alloc_map and bound_map are set. If the alloc_map bit is
not set, then this means the area is currently unallocated. If the
bound_map bit is not set, then we are not freeing from the beginning of
the allocation.

This is a respin of [1] adding the requested changes from me and
Christoph.

[1] https://lore.kernel.org/linux-mm/20250904143514.Yk6Ap-jy@linutronix.de/

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 mm/percpu.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/percpu.c b/mm/percpu.c
index 81462ce5866e..c9f8df6c34c3 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -79,6 +79,7 @@
 #include <linux/mutex.h>
 #include <linux/percpu.h>
 #include <linux/pfn.h>
+#include <linux/ratelimit.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
@@ -1285,6 +1286,11 @@ static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
 
 	bit_off = off / PCPU_MIN_ALLOC_SIZE;
 
+	/* check double free */
+	if (!test_bit(bit_off, chunk->alloc_map) ||
+	    !test_bit(bit_off, chunk->bound_map))
+		return 0;
+
 	/* find end index */
 	end = find_next_bit(chunk->bound_map, pcpu_chunk_map_bits(chunk),
 			    bit_off + 1);
@@ -2225,6 +2231,7 @@ static void pcpu_balance_workfn(struct work_struct *work)
  */
 void free_percpu(void __percpu *ptr)
 {
+	static DEFINE_RATELIMIT_STATE(_rs, 60 * HZ, DEFAULT_RATELIMIT_BURST);
 	void *addr;
 	struct pcpu_chunk *chunk;
 	unsigned long flags;
@@ -2242,6 +2249,13 @@ void free_percpu(void __percpu *ptr)
 
 	spin_lock_irqsave(&pcpu_lock, flags);
 	size = pcpu_free_area(chunk, off);
+	if (size == 0) {
+		spin_unlock_irqrestore(&pcpu_lock, flags);
+
+		if (__ratelimit(&_rs))
+			WARN(1, "percpu double free\n");
+		return;
+	}
 
 	pcpu_alloc_tag_free_hook(chunk, off, size);
 
-- 
2.43.0


