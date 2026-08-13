Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B5A8C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 03:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 382B06B01F0; Wed, 12 Aug 2026 23:51:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30B896B01F2; Wed, 12 Aug 2026 23:51:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FB8E6B01F3; Wed, 12 Aug 2026 23:51:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED4E16B01F0
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:51:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C5CAA050B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:51:09 +0000 (UTC)
X-FDA: 85094870658.01.2968C83
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id B6546180005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:51:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=MzfwnqSH;
	spf=pass (imf16.hostedemail.com: domain of m@mavick.dev designates 80.241.56.172 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786593067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P8Jl8v7uhIYg0BWuM9zYsmcifoKGiiRIRhrZEbo+mEQ=;
	b=6dyOVQJrq0tpHFHDL12u2FKl93/ZZ4NWtCp7YJTwsa0KPWtbaY7x7S9k+QA2yon4auIklo
	NgHlPtd3I/YrpJ8bhhr7Yd/EqZxqvS0xYH09E4WMpuovTtyNYcnxOTYEUSWaxzxNjXkJX/
	32yRoNkn7BbFSpy6dLxSkGAlR0eFxmA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786593067;
	b=2gsAguzRqldtGydaOb4rzDy4vimkPS/W2DJ993HSS4pxoHvtAJvfHrV67XCvL1SUXEdWvU
	szguAeA9PiznLM3W/45KG+bOprz8ZkS4AX/y+IeYQDyHyBU+z6vIItC2zR7aQASOZBWvUN
	PHRd5Q0oPjpN2reGkgAZOM/GTrLMgOs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=MzfwnqSH;
	spf=pass (imf16.hostedemail.com: domain of m@mavick.dev designates 80.241.56.172 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4hLBGx30BCzMlLk;
	Thu, 13 Aug 2026 05:51:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mavick.dev; s=MBO0001;
	t=1786593065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P8Jl8v7uhIYg0BWuM9zYsmcifoKGiiRIRhrZEbo+mEQ=;
	b=MzfwnqSHOYD5YM5aCrRFniW1OfkUeCU06L/n+43NoY1fVjkCGlzdsXMlgJPPfQBs1W8yZq
	D/lY82jW4YI/Eesc2eJBZhws8aafwSAGu+MBEubTcFqpZeY8Bxtt3PTi7E3XhqbTJi3ZXS
	WwwPUtcShTv8T/hFl3pt+O48G9rGGjvRYZrzqyRTSMCo4zi3SDcHfZdjt7TVZPrlkzTnvQ
	R34OT7PiMu2oKWIJ6qEBDjlg6x6JidqwIkxS9vlRy9I6YT7xYjbzf228K55w2Ompy09vw2
	eJlzTCI6tr3Z+/V+zTAwfGbvwPwJS1PnIvZQjQNlNBWtfoxxWb/9jf/eqZmZYw==
From: Eugene Mavick <m@mavick.dev>
Date: Thu, 13 Aug 2026 11:49:11 +0800
Subject: [PATCH v5 5/5] MAINTAINERS: add entries for refcount_final_put
 trace
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-refcount-final-put-trace-v5-5-6e8bf8a38b31@mavick.dev>
References: <20260813-refcount-final-put-trace-v5-0-6e8bf8a38b31@mavick.dev>
In-Reply-To: <20260813-refcount-final-put-trace-v5-0-6e8bf8a38b31@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, kasan-dev@googlegroups.com, 
 Eugene Mavick <m@mavick.dev>
X-Developer-Signature: v=1; a=openpgp-sha256; l=642; i=m@mavick.dev;
 h=from:subject:message-id; bh=0mtxE/WEsIHruPQpODluMt+xs1Gkb+zYSYfoyG1vQss=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFm1dgf1+nxWHu2zCrJQKOCau/GT8f4nLE8lNvmssjN7K
 PdTdq1jRykLgxgXg6yYIktNVoJ7xspZicZHJ/XAzGFlAhnCwMUpABO58JLhn374JIufT99E1jUv
 3r3d6GZUuF0ek2Hf3BmdHl08F1wydBn+R+xLW/NC4qv5s9D3F1SThVWNJdW/zdtdb8XGZc8i7qv
 GDwA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspam-User: 
X-Stat-Signature: 8fifweamoocgkoupk9y1t55ehwcmytc6
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B6546180005
X-HE-Tag: 1786593067-352767
X-HE-Meta: U2FsdGVkX1+NLx2CssVn+LBb2Itx/J4ZgiuDeej/ni75PoIAUVecGrU4CXOL6z2Ptl+CP3gkgYxe0bV4uL9Xk2Udin65zU7uCQQfyUS7uBtEqFDj8IQ3KIVMzGRPjUG3j5ey0nawVh759ciCx/OOJe/Tziqy4eq4zEhBefjenbjE1iBnh7rsvI4pfFZG/pccryKR/LHdCgo1SNtcrs+QvLQ0QWRW7pefmtn7tH4obXQgiQ1w8IWxnYGL5aku+E1Gg3CXjXRVaZF6fE2mzvp3mYLBcpZ8g1oRNde0hh5AEp9uEdMaNNTMgqlkA5wdEm2i9GvWbGJhDChnfe+DMgFfUV5Qw6PSG9FF8bZ9c2WEfTRS0D16/Irq7DDd8A8zgbVHoslRMjAPmMuHwA3M0qwqZmB6cNHqCsAIliypa0rmqIdAu25iOcQZlOdsMKkvkC1L+OomTEPFedVDJj38wZjBmCdhgl5waEgj05yJrCFdvB7pjd40kda40dt/RloIKhlkiDVd5hdWeyFp7GqBFJK8iGgWTIBDKkIBzn8afDzCKPHYVn0edV3AcD57bC0MYBnKzUuxYXvcKdhByKU4acUan+3+/6Wk65T2iCzI4L7ogkI2nTtlkl+IVa269Rhh31JpA6vDHyKM2FhTHPZj4OU8zI3ENKsIry/WDIeqS8QVeW7ErWehZrsJtLhxIbnrqYOcflmzKkGAhHX0cl1gxZOHxAzltVYcGLMymMUXJ1vh0GP7+BY+Au/k2zFex6HqWX21VC3AwNNtKkqntRLP3Km7x2GTAGmx14UyYuPAVmov7+/NdEZG0QP7Gto9mfyIE23CgbldFR3Pd0kxuH43iPjPrU2MGGcxLdXzinJu6/e30ZfF5cwbZgqGvTZavfVm2z+bEzKhCRSKkD1f3vyJqXwhnMIJEq1Cq237srBK4F0HKkL8ajT0WbVYPXiwK7euQjQSgyyCr0+O+0/Y3HjtBan
 gSXJZov9
 kVdflAXpnw7FFUh7+ud3IsIuEfvIGLoF2WHn9mVWqXv2sI72w55LI3gMkBP63o1d3M8oTmj8NwH/dLgg+jS5jenp9nH13NsGigv9N0RxxNbvdGhzCKoM2LPPmAu6Cuz4+WWJAgL+btBcfblS9P2qpSw9+PdErzwBuH+xdtao1YoC0cVhyeoJnq7VOEWsrcWx0MfsaZsZQz+WxDqTpDMppOmad3EXeaSBtjedGwlhfDNlyfc4N3A7n3CAVzvHLEG4MYwlcWzvUX2oEB2GKAsCmCiAY5ozsC+HDPvmCTZ8D2eOV3Fuz4gHWhoZC92EgAkuB+5Ht9zXznGqkyjP9JQk0cvW3TDqgjRW6pKygQvEo6ZIE5BM+nyMersMRXkAc7x+3dkjgCylWoDpUVVklk/bIPQhHCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add new files added in the patch series to MAINTAINERS

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 10e8253181d3..c37e4cd0e4ff 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4210,7 +4210,10 @@ S:	Maintained
 F:	Documentation/atomic_*.txt
 F:	arch/*/include/asm/atomic*.h
 F:	include/*/atomic*.h
+F:	include/linux/refcount_trace.h
 F:	include/linux/refcount.h
+F:	lib/refcount_trace.c
+F:	lib/tests/refcount_trace_kunit.c
 F:	scripts/atomic/
 F:	rust/kernel/sync/atomic.rs
 F:	rust/kernel/sync/atomic/

-- 
2.51.2


