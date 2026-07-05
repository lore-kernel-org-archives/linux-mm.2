Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C680BC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B9876B0103; Mon,  6 Jul 2026 02:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CCCA6B00FD; Mon,  6 Jul 2026 02:47:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FA8D6B00F9; Mon,  6 Jul 2026 02:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA32A6B00FD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:47:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5870D1C720A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:47:32 +0000 (UTC)
X-FDA: 84957420744.09.1164C6F
Received: from mout-y-111.mailbox.org (mout-y-111.mailbox.org [91.198.250.236])
	by imf17.hostedemail.com (Postfix) with ESMTP id A9A7740002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:47:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=mavick.dev;
	spf=pass (imf17.hostedemail.com: domain of m@mavick.dev designates 91.198.250.236 as permitted sender) smtp.mailfrom=m@mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783320450;
	b=wPgbOLAn7tk+LE98XdibKQ9FSdpJx7xK8KBEgYN8wCIyEcBfdGnTjDSMTtIO71GqoQjzoR
	YHT3mcNKU+k9y1nGVdbn+0lmgPO0cUTuejuzHJjvJ7BcUJ8ax3gLPZVPEe5rHl5Y/Kd+Ai
	Bd45xwBMQ3uFzddTYJgVy+kwXKtERsc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=mavick.dev;
	spf=pass (imf17.hostedemail.com: domain of m@mavick.dev designates 91.198.250.236 as permitted sender) smtp.mailfrom=m@mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783320450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q10jfyhsC+ilV5voSAeXf96TIcBRjbPsbwt+QWdyz88=;
	b=JfZ29+FXF9ezbwbyUp/dfjw2UyQF/K0S8yrznsfdDDSgApjrgjKhq94oofgzvuVOC4uqtx
	ddv2jSkCtPmMTF6aoFi1qkNOeTK1+HIL2PcHVa5fE9OSp/oMLvS21m8cjgwNPArzzF3MrJ
	GrCeM0kmxfh9fxPzQA18vzNQIcCK+HI=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-y-111.mailbox.org (Postfix) with ESMTPS id 4gt7r818DjzMlfC;
	Sun, 05 Jul 2026 02:38:00 +0200 (CEST)
From: Eugene Mavick <m@mavick.dev>
Date: Sun, 05 Jul 2026 08:36:57 +0800
Subject: [PATCH 2/4] refcount: add ref_trace_final_put tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260705-refcount-final-put-trace-v1-2-a41d3fd0e869@mavick.dev>
References: <20260705-refcount-final-put-trace-v1-0-a41d3fd0e869@mavick.dev>
In-Reply-To: <20260705-refcount-final-put-trace-v1-0-a41d3fd0e869@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Eugene Mavick <m@mavick.dev>
X-Developer-Signature: v=1; a=openpgp-sha256; l=878; i=m@mavick.dev;
 h=from:subject:message-id; bh=oxdQX1dkebrHkQOKFGbMe1L7jn1KmiWYDIa5MeosIJI=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFmey21LVNYs/T5DfbKt57w5905zelUz5NZ4BFh3hdty3
 fmiYLilo5SFQYyLQVZMkaUmK8E9Y+WsROOjk3pg5rAygQxh4OIUgInICjP8lY6tyRF/t3b3x1XX
 rz5s4mfaVaP9+Iu1zEqGsyvZ2hhvsTMydEqbnQi9Jb+RJ+Xnmgc7rn310OS8YWnPLtp58ufvax0
 pvAA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspamd-Queue-Id: A9A7740002
X-Rspam-User: 
X-Stat-Signature: njrcjeri3ksa6qrcdggtbgcx99kw3zid
X-Rspamd-Server: rspam03
X-HE-Tag: 1783320450-706975
X-HE-Meta: U2FsdGVkX18wLE6IOaWoxn8+qBYj/P4ysu+5S1ctL2YEx1RmpQtkUBSGdvPB7b+O8COWocnD2QO2KG+MuJMyGIx/tuabpQ8vrYyxU4BOXAVbhUIgNFVbofNsMNlJtwJNRK0dGN3blRSjqYxizth2wVVrdXJOxP5z0897l0JsJGbZYfsjzpnqRMIsQshc0z8/iCFB6B+ZCYkKdNZQ8yQ0Lx7fFb23TX6z5X6t5O7V+4YxF9mE42rs3ByoM0bj1pJBI15kso/7ZrVd1sB2Q/4iwWSd1bj4Jmt+OFoavARHahZ5qXpabzohlSeEu9pV7UgOwi/b6DKXiPsmT7eb5QHSiQp2izHEVa0CyCFZb3QTxKkBZ8XKyhZDm2wUlzXvck2GrYO3WukAKRyYGKpOV4x/QJUrwrZ3hHH9qFh0gMIPOgbLTjcnVLbdC/uFxNQ0QazqXHl2dA07tIb73hhGCXja3O/niwyEPOV36J/ZZ64kZ+7PDR5z2EivlLOUVoygoQhw8bvnH8CXEwnqcgslNGXBKFZ5axztfxdFzp8nJF30Owy3vurciNUpFHNQjqW9o680H37L8h+VWom/OP1mDogrP9zy9yMhGAtUpNJMfXA9Y3b3xXdradWWRfPwNp15hx4ffE/S6Rwvrh6EnarrqqvgvaVYgVWUoT0Ep27YDKdFzCjwxGkAmWzuCoThR5C8iy4Hlr73tPhIYrWwu7Az7NT3zhpEmBCQq+fSKodRo+eCsTbYTUPglQ3oBVrxEe6j1iQYb8pMAvHm1bI0eEZkfX2ZAu3wYgDkKmkXcWX2w3rllSEPXBFrK7+keQ35YfNtQITukMvrmvNvWPtKfLipMCQ866egPUQVitvgF7cAjRMCP/p+KXUTlWo4fEMXYckBK0g4J5s3dMVKlsyr4o3Fyy4n2EVYi94meqdcVgeaYdEc+tRFBRvpPV5N+rHR2HaSmb/LVy1PvksXcqkQ80XQFSv
 BL1/Sb6i
 rhhQVXEsiFlc31wXL+7I9rkKvefyESFNLyM5jhBfEE66gXSRSCrQn66J/Np7TFBvZ15HGgQYhkXftSx/v9Mt4kQPaNkhbJ+LSxC/EeTo6rVEdLHrMn4n6boJImFr0uUFhvhxf7i8EUTxFXVMrOkXAnQgb+d3wtDOnkM899npD+jgfE44gsxQli/kBxIA8POps3nOdjWfUFJ0fDnK+WB2p4/5t2dfuHHbdLQ/GhAxCPr8nE5g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the ref_trace_final_put tracepoint to __refcount_sub_and_test().
This fires when a refcount_t reaches zero, capturing the caller
address, the function name, and the refcount_t address.

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
 include/linux/refcount.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index ba7657ced281..7b1fbf326a21 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -107,6 +107,7 @@
 #include <linux/limits.h>
 #include <linux/refcount_types.h>
 #include <linux/spinlock_types.h>
+#include <linux/ref_trace.h>
 
 struct mutex;
 
@@ -393,6 +394,7 @@ bool __refcount_sub_and_test(int i, refcount_t *r, int *oldp)
 
 	if (old > 0 && old == i) {
 		smp_acquire__after_ctrl_dep();
+		trace_ref_final_put(r);
 		return true;
 	}
 

-- 
2.51.2


