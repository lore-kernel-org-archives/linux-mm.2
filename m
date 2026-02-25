Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E45AFEFD20A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:45:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2861C6B00D6; Wed, 25 Feb 2026 03:45:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 209AB6B00DA; Wed, 25 Feb 2026 03:45:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115F36B00DC; Wed, 25 Feb 2026 03:45:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F06346B00D6
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:45:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8261160252
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:45:10 +0000 (UTC)
X-FDA: 84482344380.04.43EFEDB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1045080016
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:45:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R32xm9Mz;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772009109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sDf9n9i3wgaklmvOnpVf+yTHOhmlYVZHLFGAUOwxEPo=;
	b=8UJoijyFc6DhnZJdlvdcktmQsAJAHZD+nklDGe9eeiKQl8/O2CfxrU/1lIjFT4HeKMedlN
	gK3PS7Xcvl2upUhmiynYwn7YfVQqq/Nxp31/M+BdLm+WxzWehWhxg8FBDd7y5YY/kbxEd/
	OLL1hlAlFo89HBGTGf0QEvxXkfFvnHs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R32xm9Mz;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772009109; a=rsa-sha256;
	cv=none;
	b=SeFsxwACmntd0TXZYc01ZEF2TXqtMV17FWSc0HTro3eMBnivkbE7PVld66pzFat/HYYxWp
	65PwJ9e+7fYqSLSHtx1CFvXP+41/gCHscCjb+BHfVqFptEWFqMN+a171VHtRTOGTSoddDQ
	InGNpOUy3PdoMvCZyAP9GtKs7C5G1+U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C97A60097;
	Wed, 25 Feb 2026 08:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A464C116D0;
	Wed, 25 Feb 2026 08:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772009108;
	bh=jzaWURpUIGyaa1hBlzWd/+9vleP5W6HeGo+lBuhWi14=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=R32xm9MzE8TxcoyKzFlaZmT+e50QdO9vFwHyumznycMPjMjPq6MmfR1bMYVUGVpWQ
	 /X7JULpk7l6XvPEDWYVefaDoqhK6EfH72qx6WHSI4EggY4ktKX/ogNyFKjGyYmZQDt
	 b6xDnS0BDXqluk9HNUh5PDqI6GDaOUqdMNzByh9H8KT+FR+aG6ALeBdd5PpZv0mUmJ
	 Ne+DyWdbj2Dyq2EKgK09VwGMFHsF4yZP96TUC0RqE9elf+B7aWEEmlBU7U8l+FUcYD
	 Sv61GxcUNmkhSgwdbiUAYZkw30l4YlqF6PxGgVODaba0m8fcNFMAQ9wL8t1k5W9D6h
	 gJRm5HFXsiOPQ==
Message-ID: <724310c2-46a2-4410-8a5d-c69dcc8de35d@kernel.org>
Date: Wed, 25 Feb 2026 09:45:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
Content-Language: en-US
To: Vlastimil Babka <vbabka@suse.cz>, Ming Lei <ming.lei@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Harry Yoo <harry.yoo@oracle.com>,
 Hao Li <hao.li@linux.dev>, Christoph Hellwig <hch@infradead.org>
References: <aZ0SbIqaIkwoW2mB@fedora>
 <5cf75a95-4bb9-48e5-af94-ef8ec02dcd4d@suse.cz>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <5cf75a95-4bb9-48e5-af94-ef8ec02dcd4d@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1045080016
X-Rspamd-Server: rspam02
X-Stat-Signature: n8hzrwc3qt8tocpjwejwhoejgqdu9j4o
X-HE-Tag: 1772009108-651719
X-HE-Meta: U2FsdGVkX1/5qTkjVEPIwDl9gBoFLCbHp91g30SUbXU9vCp5zh8qadqr5Ts40Fv/sboHNMdZRi7rsdLLm4G9n4WagfuH671omrR9Zrzof4H2GmFTo+zwTnu1P86BL+finM2845oEI+Zxx62bgGlrmE/eoUXaKAGOCdo0XHrvtfJjER4h7CqNA0ISYC33WACOqkVkA9BDKg9GZl0l4tgyLOZKsC3sRHXnilNEJz8so7LyIq83djtBfw1m3wP0BK4iuN0/faxl55c9W3SWtiwX4u8usaYXWvo4RYi/FjXzYRUm3MW3YLPGZM+QiPsiSv53sUBTsQVT5qgCSiNtr4tJt/Cmc6N6NSSo7aS3/xB4mKdimLmhXgSD8O1fjCW2XOOrL9r/AKihZYKD5C3xMA2sv/KFD7+bmmMRwEqO5lBbhLGSpWYHysZYgRMRP3YOmG2WsFT9ldvrvCbBdulKbTOFKzy2a1AUC4dQe3qB1eyOORu5v5ojl2O54GLmqrKquP6+C0MurgqEo1bQ02vBf9RqLSBsbaze32WJn7XomaAxz+m/3jyBN1dhAhhD2Y4cXcWKt+svCcN+dmjs8BYqIuHxn+JELYpjn5FcY+6YEHJ1CyTrY1bep9mjDQPLEuCK39lcJnFggP1J0jO0udo7YNmvP67eEJkOmN/IUjj5b/Z/cDRC7lrWkDjfBFmb//h5OSzz35rnXmYZZE6QT6ayTDguvPIpgbQB1cP+nEPy1JRy7339UL9YPDTFUCUPJOSnkQ1DXtkR9cw9W6U/1WIBI4XQYow/8pFn4cY6M3aCy8xSdSoijYgiX4xmhnx1iaL2Oesf9GF3Ty8qFfmxErDgEZ4uemYsBuVc2EKoPNO88Wzay6o3yYpvIi0GVv0owvsqODEIn9OoECvQANZ2syO8f/efC24UWcc7XUrEG3ZAMl9saJRANkJtFLFrJpCCr/1DBKwALYxSRWx6nWMvTd3gHBX
 x8P8BUI+
 pDJXshUcWQSwyY6LHjoSv9ZWnHKyoEuFUEO/EpCNYlbHEL8TssYnyLKO296TwhLzL81GnxMw88raqLpKAxYcMt1CBt+UCOVKIMqjAdjlK9HlqoIFqKiNOXE6qnihrrac/kw/HQhqXhqsL3cwJYSye0jSSfNUX3j5uCk/3Tjv0q0RjHZ8bKxAWHMIvzqCPEjaCGCEVC1DWJ6yZbEHCFZ3CxrPi6qV9y1LlAs/1oT2ncBu+urrM3CJD8PkzBpIz8M+6DgOGNfgS/MWr7xXzF+x7jgEHCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 21:27, Vlastimil Babka wrote:
> 
> It made sense to me not to refill sheaves when we can't reclaim, but I
> didn't anticipate this interaction with mempools. We could change them
> but there might be others using a similar pattern. Maybe it would be for
> the best to just drop that heuristic from __pcs_replace_empty_main()
> (but carefully as some deadlock avoidance depends on it, we might need
> to e.g. replace it with gfpflags_allow_spinning()). I'll send a patch
> tomorrow to test this theory, unless someone beats me to it (feel free to).
Could you try this then, please? Thanks!

----8<----
From b04dad02eb72feb1736241518dd4d3dd64aadc0e Mon Sep 17 00:00:00 2001
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 25 Feb 2026 09:40:22 +0100
Subject: [PATCH] mm/slab: allow sheaf refill if blocking is not allowed

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 862642c165ed..258307270442 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4526,7 +4526,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
-	bool can_alloc;
+	bool allow_spin;
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
@@ -4547,8 +4547,9 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main,
-					gfpflags_allow_spinning(gfp));
+	allow_spin = gfpflags_allow_spinning(gfp);
+
+	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
@@ -4558,9 +4559,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 
 	stat(s, BARN_GET_FAIL);
 
-	can_alloc = gfpflags_allow_blocking(gfp);
-
-	if (can_alloc) {
+	if (allow_spin) {
 		if (pcs->spare) {
 			empty = pcs->spare;
 			pcs->spare = NULL;
@@ -4571,7 +4570,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 
 	local_unlock(&s->cpu_sheaves->lock);
 
-	if (!can_alloc)
+	if (!allow_spin)
 		return NULL;
 
 	if (empty) {
@@ -4591,11 +4590,8 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	if (!full)
 		return NULL;
 
-	/*
-	 * we can reach here only when gfpflags_allow_blocking
-	 * so this must not be an irq
-	 */
-	local_lock(&s->cpu_sheaves->lock);
+	if (!local_trylock(&s->cpu_sheaves->lock))
+		goto barn_put;
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	/*
@@ -4626,6 +4622,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return pcs;
 	}
 
+barn_put:
 	barn_put_full_sheaf(barn, full);
 	stat(s, BARN_PUT);
 
-- 
2.53.0



