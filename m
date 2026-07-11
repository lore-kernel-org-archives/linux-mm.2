Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B7D7C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 04:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EC596B008C; Sat, 11 Jul 2026 00:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29CFB6B0092; Sat, 11 Jul 2026 00:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18DB96B0093; Sat, 11 Jul 2026 00:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E5BF66B008C
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:41:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C67F120669
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:41:18 +0000 (UTC)
X-FDA: 84975246636.27.4BFDE25
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf30.hostedemail.com (Postfix) with ESMTP id B7A1880004
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:41:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b="g7EnXko/";
	spf=pass (imf30.hostedemail.com: domain of m@mavick.dev designates 80.241.56.161 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783744876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cyrDKc6+UkaIRpwi1rdgsrlg/YNeGkCxs/T+ipMB7oQ=;
	b=ndSfNS4PRL/aJHN6ImYYu2CWp1a8Cki1CnpBhJZ2Ft6DSaw0HIWRgQ6tjLsauWDWojAmHO
	1iNAgR+H6w24XcvqTpQ89QSW3TOo57UL9wVd8+JxeUzlFzuFmUOJ68+QJTpu/6sdyVU+Jg
	HFYAWHZvOO+FKEXVAPAuokRiknZXcZ0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b="g7EnXko/";
	spf=pass (imf30.hostedemail.com: domain of m@mavick.dev designates 80.241.56.161 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783744876;
	b=cjFq34uK4uvqn+yfSkplrZxUcM1FZscXfgfHLGExX1EnAR/T7+hIA93cHOd80VHLIv8K+o
	0D/XF0BLpFXovzdLDZJBaosMkld0AHWvB9x5Md9qW1CXxrJ2TjhvgUVBdPdMOqbtxln4A6
	9pK8J029Le+kYYfCug5WYIcQNwr6XnA=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4gxwy20X6BzKnH8;
	Sat, 11 Jul 2026 06:41:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mavick.dev; s=MBO0001;
	t=1783744874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyrDKc6+UkaIRpwi1rdgsrlg/YNeGkCxs/T+ipMB7oQ=;
	b=g7EnXko/wyf0WQiL5mY/hafIxjSHVbzwUQZMxD7y2AjmpFOraUFpGjgXeQGUdtmooi7BiD
	+95iclcvJevGEr+gvO5jx6jh8beqtHZ5ASeZeSEoCl7XDwGCtzYthQqS5MAPUY/QLC7TmR
	HiZqrlD+ldR0967fvHLseFSrwD1RYtD5DdHcOgBN05ptp5FpiAts9oq7CcneBV1l0PBBsb
	iiUwVdxtrVsxHeQWpr/qFOUHBKLUiF6bl/a1C/pqihKhWsIc70IgwOS6Yo/R8WFQEzFUuX
	2M3VEi7sXTuPLGXGXj6uOfkSd8rezz/WHUAHHwapS5yPKFb79KXzQOuMYOfgDg==
From: Eugene Mavick <m@mavick.dev>
Date: Sat, 11 Jul 2026 12:40:20 +0800
Subject: [PATCH v3 2/5] refcount: add ref_trace_final_put tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-refcount-final-put-trace-v3-2-674c8f03d9f9@mavick.dev>
References: <20260711-refcount-final-put-trace-v3-0-674c8f03d9f9@mavick.dev>
In-Reply-To: <20260711-refcount-final-put-trace-v3-0-674c8f03d9f9@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Eugene Mavick <m@mavick.dev>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1624; i=m@mavick.dev;
 h=from:subject:message-id; bh=aDxzfY6bT7IXzsjvVe+q/A+3qkycq7qCD2NucCrMON0=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFmBJ22DJp8//+h3OEPKfJ3Ewv/Xkitub5dM3K7tfU5r/
 5/zC3XYO0pZGMS4GGTFFFlqshLcM1bOSjQ+OqkHZg4rE8gQBi5OAZjIRSeG/yW3P+YbybFllu5j
 XOG+Q710ps4jq+cLFoXt+vZv/ZQnRwUYGV6lCb9T3Pv7ktqnjtyS83Nfex9mWiTsPs38UpC3TbT
 NHzYA
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Stat-Signature: uaszfhk43gtzfwdtfpis5ekuxpgemce7
X-Rspamd-Queue-Id: B7A1880004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783744876-410375
X-HE-Meta: U2FsdGVkX1+Ue9SSKBECJEPTVjsQIRjAIHiI+Zykk/756P8Mio55R/BQcMgbHcMcxXhrnl+/BEnvFdtYRqF2CFupEMpeYN3bNOfSpxQIZl4Ilbgwx/s5JqCu9D0wllPopqLbXbDQtDhTrRaN0jFLk5hT/U7p5bZEv/p8QXWGRkTGQlBdqq2t01ZGrOQBbn4lXENeHoslAhbIaFq5481B4Wktxz88TQXX5wAEdmIgrdZVlUsxMkgwQpjsjfjNU0hrYFScfhYdFmU8Bynd332jx2prn5k/YiYI8PMZ4I5RsbqREJ42DlrI/CtYKGD4Ld3chOr9u6+Du4GJG0++Ju4mQNODj2ogJizW88hvGPNFAuqGDMDXsfLmJKIvbXRHyCs3x+4ZfKiMaKSxzrqenQzfgoQcIMiHTEfVGKaPaIS7I17U2i3njmHYTkiCSmQExK5tpNiATNhvWl7t0bDjoyyZDlqq5At+dvVD5W382cR84t3U/yKyTXQQw1bR4JtPNAnMKqOkqRYm0gbRRZx7XxhUqv05KUUzvvZucEHiaefvGhOkHZPyzceAySGKvqPk9UIFQK6MxWPq+zSkbzJoJFDZX4yl461TPenn+jENm8jfus38Gwks+MWp6si4KhQZi2KwAum06l4mbYxo7qPjx/TkxCRpTHraCtGSUsglpHWcJM5bSZ1pMiUu8cVeqrAeLwDtk06r2cN+nccJTAfqLQFr9/t6M8DKOD+e4byBpWUImoWHORFjHEmcHBXtV+xXQkcq+mIpwun5a01uF/h1QX7fbw2+keYYhFcXtgZZqTvXDj87MSae012JlmhuQHpSbKTKRR3TgjgHPonrHaGMEUwnAgCw2n9SZzq9NtUkbht71flg8JMFZ4GDKiqQtF8jQeqpHlXQrHy12n8L78uqx3w4CnT8SOCkU8oNUYJo4dMJwEklBI0Cij3rFCRXy2WenyOKnnGltcLdkl6ThJr1D4d
 KvmNwXBB
 D4xtkjvS1NPahc9+XM4O8zO0C2cawv9cflKhSBpkiX35OmAAejLF9sFVUlobJtMe+CCND6plYwsT28OQeCmElxArFcbv+YuyuaQld3etcn3nX5uLAULMlmeBJiEPwwPWuggmHU+jX9XgWzSJ9Cbl8EdYiEGesi9H2lM44OWwEIRC6qxXqQeg+1SqqX/g3QeUCrz8PwbC2q2CabE7E3U9Le6CiKqObZ7k1hI96bqUrSdj07MF4QJLiizN49yjb9rSift6WD+R7DreVTBEZ860QgG+Ckj04ZcuUkmNnNPx73KFkgMFGcyfG2hlkoqlO8swflii0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the ref_trace_final_put tracepoint to __refcount_sub_and_test() and
refcount_dec_if_one()

This tracepoint fires when a refcount_t reaches zero, capturing the caller
address, the function name, and the refcount_t address.

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
 include/linux/refcount.h | 2 ++
 lib/refcount.c           | 8 +++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index ba7657ced281..70d07a462da1 100644
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
+		do_trace_ref_final_put(r);
 		return true;
 	}
 
diff --git a/lib/refcount.c b/lib/refcount.c
index a207a8f22b3c..cd7e32df3919 100644
--- a/lib/refcount.c
+++ b/lib/refcount.c
@@ -7,6 +7,7 @@
 #include <linux/refcount.h>
 #include <linux/spinlock.h>
 #include <linux/bug.h>
+#include <linux/ref_trace.h>
 
 #define REFCOUNT_WARN(str)	WARN_ONCE(1, "refcount_t: " str ".\n")
 
@@ -56,7 +57,12 @@ bool refcount_dec_if_one(refcount_t *r)
 {
 	int val = 1;
 
-	return atomic_try_cmpxchg_release(&r->refs, &val, 0);
+	bool ret = atomic_try_cmpxchg_release(&r->refs, &val, 0);
+
+	if (ret)
+		do_trace_ref_final_put(r);
+
+	return ret;
 }
 EXPORT_SYMBOL(refcount_dec_if_one);
 

-- 
2.51.2


