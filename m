Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EB46C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 01:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21ED06B00A6; Sat,  4 Jul 2026 21:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EEE26B00A4; Sat,  4 Jul 2026 21:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08FBD6B00A8; Sat,  4 Jul 2026 21:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D0C686B00A4
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 21:21:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60269A060A
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 01:21:22 +0000 (UTC)
X-FDA: 84952970004.18.6128B47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7B00340004
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 01:21:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CvIeACEb;
	spf=pass (imf12.hostedemail.com: domain of devnull+m.mavick.dev@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+m.mavick.dev@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783214480;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LeODDjNxEBNzXLjL9KKikSgLdXZG8K6OsYc5c6RFUzw=;
	b=IPfLDNfkq8X7FybV9t18JqWwRiEBwKMEzpcMz5uVKeUwd7cTw588iwbLET+ISRx6PrAJGC
	RMNRxmDGnCE6af1Dr8OP/u8LTPgkOE+2cEc09laYEgSpAJmLYoDqOz6Kb17mdbORp6qmsf
	ya1qdPRZ1+UK26s7ila366/vYQ/tBDI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CvIeACEb;
	spf=pass (imf12.hostedemail.com: domain of devnull+m.mavick.dev@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+m.mavick.dev@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783214480;
	b=pipHdohUIKdoCTYw8XQLT5dOnmig25WbMtpuRcltQdR/pCJ3UV9mAezqGf3sQ9BuDwVY25
	Wz97KGhz/XWC0axo9Z7gzjyfCf5ebe99Biw3+tFvSi1+xZ6EKFjeJgWdAzUs1YEcAMAnCq
	8Hx7XJ0d/geeN5bakCI7dMeMQ83jH68=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 847F142A9B;
	Sun,  5 Jul 2026 01:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3777DC4AF0B;
	Sun,  5 Jul 2026 01:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783214479;
	bh=aJl7nlLOWLA1emiT3W2w+Al8DEuLxD7KOL2U/1Me0R4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=CvIeACEbSj+AOfNaRgYMCZGKu+lLtS8WS9X586BjNPYzHeyA6WJ3bCcIwNNSezb02
	 D17g0J8LDrLTA/hmoiZGqcg5kZxYYZ1FZZvQwAu5xDdmjGtNZX92ikIWXGly2Dog8M
	 Zo2n3Sh5Hbb9b12Tll07xY501t6NIu9eqJHUFcWxb+ycFzOmrX8GFuX7bfQCKoJQ2G
	 30yYlo1dvX4ufffod6YouNt+e1HPFSwk5Bft+r5Fxvs5I5T4YPp7/Yl0ao8w/BRQeI
	 likpXVKeInaxtHqQKYnyllw1cC2wj8aL2iLEx+Kr0VBz3bMHNU2FO9nU+oGIcyEEuZ
	 2L8b40f+vHfHQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18989C44501;
	Sun,  5 Jul 2026 01:21:19 +0000 (UTC)
From: Eugene Mavick via B4 Relay <devnull+m.mavick.dev@kernel.org>
Date: Sun, 05 Jul 2026 09:20:52 +0800
Subject: [PATCH 2/4] refcount: add ref_trace_final_put tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260705-refcount-final-put-trace-v1-2-0ae936edb750@mavick.dev>
References: <20260705-refcount-final-put-trace-v1-0-0ae936edb750@mavick.dev>
In-Reply-To: <20260705-refcount-final-put-trace-v1-0-0ae936edb750@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Eugene Mavick <m@mavick.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=878; i=m@mavick.dev;
 h=from:subject:message-id;
 bh=oxdQX1dkebrHkQOKFGbMe1L7jn1KmiWYDIa5MeosIJI=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFmeGyv/807KiA0NbPXYPkn7mHjaVUmpXYse5O2/nPh50
 8XpL0UudJSyMIhxMciKKbLUZCW4Z6yclWh8dFIPzBxWJpAhDFycAjCRI7WMDA/MrTK8W0pXGvLM
 14mQLjER/Vx4pUtRfGNCYHGoZ7NZMyPDgq+JyszX12/Ufi2bXiGsJ/xxrXn5lo5M4zYNvpwAwxk
 MAA==
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Endpoint-Received: by B4 Relay for m@mavick.dev/default with auth_id=850
X-Original-From: Eugene Mavick <m@mavick.dev>
Reply-To: m@mavick.dev
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7B00340004
X-Stat-Signature: 6d9g4666ssgfbndykfw78boz195x9eho
X-HE-Tag: 1783214480-842573
X-HE-Meta: U2FsdGVkX18eHMXVMMHKaAoGpVQo/n5o9M0Jh+TFZ9xUEezCcb8BfgqmGuFBlskNS61Mr2Iic+M+RaHcbeXiSUK3ZZxKN67ncGi00OSj2ZD3l5n3rSwG84MKuNZOrA2nsMnHBHMO4oDTcA/QxYJkXOb7BIgK9jHInqVJjwi1av+O3Les/4XSWxPQ0h4brOZE8luN2hfo8DNwLwt4ccWtpcIXLV5biSgSgg/1vlO04ABCeBHTnCNpNCq+wDTXPo3PTmIzSgP5k+0IF1NgJe/7u4DDYOkN/TNEGAblQBVR3GnSnNBWFyywMwvWH0UIOo0Ur/HSngIhfxi5qvBxFtWYoT8qqnXFZhmTVjMYRcI42+SiJkcblENPBbPvXXXCiPBUqYJUP/Ozqmq/eBpNtMTLDd8TvmgnSexenOnLjRdLm2nQLMpg0QBAF5qd1lGxZE3bfkSvArefNMW1hTk+wRFUfjkQ1HPFbtsohDzYxPNmlno0GmU+HYpJpYVcEsoodprK4q3Q0hCHVmLhHYxZysPuxthrrbQYG0IGL59NgLAC1vLf6t3C8P8rLpFWUG35G0f8mtcgxHQQI+50VjsZY7kdx3nP9dbb2QdBBRp2M12nOxCixYGumP+QYFvjrnLKoDDzgWH8g2CW7x7UFj9J9sQYuvcaCMy++RLvuad08oM5jiVZcQspzDTuyRKPZxedzi/pjZkgSwC9HogBfYXVd7H8vO0xlpsVUXFunVAN9W7vRhamG8Sk/eTuYmfyHgZpXbkxbqJVn/TMwk6UZhhposYS9lH9HZhZfxeXk6eN+pOAERNf/1orNrSD5RuHv+1ZUsZ7D5t+OCqBUNxvlI4C80HtlUnsBxGr/EV8pxnyAqw5QAHaADv2L/cz7ouwqx9kp6c4v0ZXwlsDD02Q4SVVT7D2KkE4LdZOHDdUkwLAKb6k4f3/MGliPiStyFry1yeOG74UAzEop80gMrKQQ48BPhL
 CyJLu/Uw
 5ZGJrd/R+rEtAF1K9n4BVrxCWwIjn/gcfbxPTWJ8zgtpwLOBMJDunTRxzDxa/3jzrYvJOW4l7nx+MP+sd0n07fR1CUG/JAkhEwZMJGHR1b/HDIbj6BXXjtdE1Hf4N3ZwFsqICwvhlNbnieSWGqFIOVElWI8S6r9sP9i2WYwACxIvpLgbnJj6lOR4iFNlUsfiZGkgVGzxPpS7OkaEoFP9PV1fusv9EPf2iz233Hx71QhR36Vj1QjF7By7oo6tdgsvED+yCUA79zETKE5pJApr18EkEtR1KODAPOsgjznz0t4qUSuXrJnhGY13DixP2UfP6zw+EbVAPq0+/8ojU0GqhkXXhPVk5H9rz8QQs53VMfgiWOxQkuPe8y5+N53SVwTw3mku7sjeanOcCGTR1jbrrNzp+NCidCBnM3Xo9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugene Mavick <m@mavick.dev>

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



