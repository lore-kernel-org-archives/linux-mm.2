Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEFDCC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 04:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF9FD6B0093; Sat, 11 Jul 2026 00:41:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAA976B0095; Sat, 11 Jul 2026 00:41:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72666B0096; Sat, 11 Jul 2026 00:41:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A84236B0093
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:41:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 386281A0682
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:41:25 +0000 (UTC)
X-FDA: 84975246930.09.2693BF2
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf23.hostedemail.com (Postfix) with ESMTP id 70F30140002
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:41:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=Q09mZMDB;
	dmarc=pass (policy=quarantine) header.from=mavick.dev;
	spf=pass (imf23.hostedemail.com: domain of m@mavick.dev designates 80.241.56.161 as permitted sender) smtp.mailfrom=m@mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783744883;
	b=qcmwWCjYBwhLBbdYtoYTMkcAAEItTlzL6luWyjb9G0OnlgBc7k3oFAHAzLP9gmWsBgZxex
	+OPk78Qt0OEeo5T02Lfh7hptpdPte2fXUQAsCQcmKFufPlXXAlDxDZugabOEqD+tHfXAeE
	GwzL4BI0nVZJ+8epyHIOh2ubZ21qA1k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=Q09mZMDB;
	dmarc=pass (policy=quarantine) header.from=mavick.dev;
	spf=pass (imf23.hostedemail.com: domain of m@mavick.dev designates 80.241.56.161 as permitted sender) smtp.mailfrom=m@mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783744883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+WpDJUffFYkGym8OqsSvgqtunStF+Lue8wI1l/VKbI4=;
	b=eBe0S8mkPO3XQPZ/cBgH+XE1eHqT/3WTr9hdnS/gJS2ZJRpz0U+WZS9+b7eggn5EeeXNFo
	HS4nk0Ce+Al2WmgrTaOwnycWmsIKMkXx/nkxRWWo5Myqfbu2uxUfmCZCBguHRiNmBLxWDD
	OJ9SFpMatDh4Vq9Vn4RIx7SSwVmJA4c=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4gxwy864p4zKnRd;
	Sat, 11 Jul 2026 06:41:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mavick.dev; s=MBO0001;
	t=1783744880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+WpDJUffFYkGym8OqsSvgqtunStF+Lue8wI1l/VKbI4=;
	b=Q09mZMDBC3SL2Aw+Qz9LF/nU3tBPOXtA6NdSL96a1e8e8dmySvxy5+Cfav+dkJpUXt22Pi
	JeN7JHaUTsAqERdODP154c/17aUIO4dKH5MAOuelbkZ5GEFW/i/NKgj/6WlHcW5FpM7uhO
	i5rLjrNn5a1pz1g3kA1r7mTnhShvmN8lxPAHrUDN+EQafdh5oIfunKkvPD2J+x563LjEOP
	JRPVKmM3yFLQFzjsRSNWLx2atapc2C4jCSyRqf8Rssc7+dM7+qz1NnnVqBitsri7r/WL+X
	jRVuFMDF3MjMzuovC779vCM5SA7B8CbytS+qTUxu67X96SFDqcx+jN4JTGBedg==
From: Eugene Mavick <m@mavick.dev>
Date: Sat, 11 Jul 2026 12:40:21 +0800
Subject: [PATCH v3 3/5] percpu-refcount: add ref_trace_final_put trace
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-refcount-final-put-trace-v3-3-674c8f03d9f9@mavick.dev>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1198; i=m@mavick.dev;
 h=from:subject:message-id; bh=vVWsfTjSGw6e33WP2d/uyqteLjy9dxiqe2AmCt04NhY=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFmBJ23vb111w/3P63trb8dvX1hUVb2tbVrViy+RZlzPg
 soe2hQ+7yhlYRDjYpAVU2SpyUpwz1g5K9H46KQemDmsTCBDGLg4BWAiR58z/C+57H/Vr0pIcnoy
 z/HdNlUnXF9PqMw9nTRVSt3p+OOmJAGG/+GL125TbDn11LJ25e+wI+kO2X/rNbp9ehKjTgduMxd
 14QQA
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspamd-Queue-Id: 70F30140002
X-Rspam-User: 
X-Stat-Signature: m5s5w8ufoyxeewdpd57qfqckpa6e1h65
X-Rspamd-Server: rspam03
X-HE-Tag: 1783744883-718596
X-HE-Meta: U2FsdGVkX19HedJ0G/VfIgHA4OgYZDPQhPikuGOnMOQXlUVybnOTtBUvdOimeapQj5+0u62thVSPgY9d0WUHBBQvcoZtcQm7nxDzhtOA3PsxMgUV0SEIP6F+MP6QQfUrENIiJ4i8Cbm9eCtBY8HnROdqv9HBZHdOFWACZohWxC4qKfsbF6LjWlaJZCWRViERaxO5Gxqtg/xupWccsQ8CC2izk2FssDqe5gnJzpxbfUuwiwBFR90PSjAKKQJE686p9ZOy2sCp6kOFZgF/GF7QRdhyRXA/JVAN59P+j/UCtSuMStBFbEyMtcEUB5xBbkC5Fj/lDU0SjFzCsn0kfKXvVlhnuyUoyizqDZv0PzRSvfcvz1a6qZOXxIe3Au/B37gpEO/SxdVYRM1uZkbig9gc1xm87/0JCS91L953EXZu9wdoQrp+6J416GdpHEhByvX2d5wi/vKICYWbYwJY/2k9Na6Wa09enxaZ8F7z/qbVeRaHZGHJiHf/8mMr3D+iBp0f8eOlT2r5O6z3Gt94zr23daRdSUR8HBn8atXbFs4E1xQgaREH25SkxEAHcbZCvmELXf/uiG6dhftoYmgC1Q2o2E95n22vHrkxLl9rP3b9O9giAF+Q1mFzW6RIw4JxAtMfx5b13ySjvSEjPRpN1mJ1Ay2BKP0cNbIsgrS27UrTxje4NGw3LHc/1LGNbGdZlsa3qgTQkyvU2E3tqylpPHw5EnjF5ZqqpQqTFaAVtx5oM64IlJX+sP7VPKcPhIf9eIf+GLABb3plqzCJXbhWgxNgXXmF7BSj9W0/6mpn+7TeOz5uzn065pXI09IbpESQDUNCKXLi9Ysgzij9pzyA7A7XS1pu4n1DUSF1B5K/pmu3H83KAHtLMV9IwsyOzdHhK+Tf8G++RN8RdXXpoaOxv7eg1NliSaREzqoYEKlHs0PTkrunM0XUi5D9wuJ5Nrey+HoLS6qnQkIBGPIUcJlXWsX
 m4V4IBE+
 tdiJ/ZM7gO4u8OeYKzWMX/AspIDdky02vIeejzJWk9zbwq5N1NFS1IgDj0Bu6H2anj34dK44xXBIRNWlg5SDmKzakAxaEwXRf0K3PGlk5xsStrbjCBcMpCKX+ISZqgZA2j5yyULcuUTxA+8jdaAAzSmhP5KbsDTrySEPlpf5L7HxZ31dzA+xnUM3D1eC657+7Eh5dib7BZA9UDKQNY26x9V9z7cm3R2o+Y9rsNVFxd8M31yi4o9mLVBkVchMcjH5YO8XgTFYyBI8ruPXr1tKv08w4t03uCtIMvq9Giybf7h4BxRuAwVZmS7ZgjHqBxOHBD92k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the ref_trace_final_put tracepoint to percpu_ref_put_many().
The tracepoint fires when the atomic counter reaches zero in the
atomic fallback path (after percpu_ref_kill() has been called).

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
 include/linux/percpu-refcount.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index d73a1c08c3e3..f870ac0e8c06 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -55,6 +55,7 @@
 #include <linux/rcupdate.h>
 #include <linux/types.h>
 #include <linux/gfp.h>
+#include <linux/ref_trace.h>
 
 struct percpu_ref;
 typedef void (percpu_ref_func_t)(struct percpu_ref *);
@@ -331,8 +332,10 @@ static inline void percpu_ref_put_many(struct percpu_ref *ref, unsigned long nr)
 
 	if (__ref_is_percpu(ref, &percpu_count))
 		this_cpu_sub(*percpu_count, nr);
-	else if (unlikely(atomic_long_sub_and_test(nr, &ref->data->count)))
+	else if (unlikely(atomic_long_sub_and_test(nr, &ref->data->count))) {
+		do_trace_ref_final_put(ref);
 		ref->data->release(ref);
+	}
 
 	rcu_read_unlock();
 }

-- 
2.51.2


