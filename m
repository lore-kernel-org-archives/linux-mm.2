Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B07EC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 543096B00FD; Mon,  6 Jul 2026 02:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7976B00FA; Mon,  6 Jul 2026 02:47:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BB046B0101; Mon,  6 Jul 2026 02:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA2FE6B00FA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:47:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6778D1687DA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:47:32 +0000 (UTC)
X-FDA: 84957420744.12.F6BBF72
Received: from mout-y-111.mailbox.org (mout-y-111.mailbox.org [91.198.250.236])
	by imf05.hostedemail.com (Postfix) with ESMTP id C654810000A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:47:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of m@mavick.dev designates 91.198.250.236 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783320450;
	b=C7RMK3kGF7hwp86TFqyPRCxukVpdq64kVBxf+ZRhLc2NSJIhe6DUniAkvuFnPVxbXnCwY8
	WzoI1F1oQcvWMFCdudpluFLDaN9IJ3nzui1s09gc4wMSb3WkAxLOsMUD42RXd1TUNn0Ruk
	RC06ij3it6Cv06wBgc4I+bQqBJEWHZA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of m@mavick.dev designates 91.198.250.236 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783320450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=gYvWa0a+H8FfjqJJnBn2v0RRcagiBJzaxOLvVSTlOmw=;
	b=XeZNOrhEdw0Acxk7AXWyAQ450dzbHeLmN9g7GGcwxZlkwHTKMz8MPqbF6tUHb1PGMLsZ5R
	BUd8ZOCtwKMqNPxkM5Od4fG2m2qaxtAI1CAzjRqz5GBEu8QtOOxr6ogYRgdM5zTVxCTAQo
	JGaS8Q3518QkUWLC0WQjfLrUVlKH7Yc=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-y-111.mailbox.org (Postfix) with ESMTPS id 4gt66635JfzMlcT;
	Sun, 05 Jul 2026 01:19:58 +0200 (CEST)
From: Eugene Mavick <m@mavick.dev>
Subject: [PATCH 0/4] tracing: add ref_trace_final_put tracing
Date: Sun, 05 Jul 2026 07:19:19 +0800
Message-Id: <20260705-refcount-final-put-trace-v1-0-cdd0014626a9@mavick.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPeUSWoC/32NQQ7CIBBFr9LM2jGAWLQr72G6oEDtRKUNUKJpe
 nex7t1M8n7+f7NAdIFchKZaILhMkUZfgO8qMIP2N4dkC4Ngoma1kBhcb8bZJ+zJ6wdOc8IUtHE
 oz51V5lDuUUOZT6VJr019bQsPFNMY3tunzL/pT6rYH2nmyLCTJyVrq3kv1OWpM5n73roM7bquH
 7W3lW7BAAAA
X-Change-ID: 20260624-refcount-final-put-trace-49bd7c39bd5a
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Eugene Mavick <m@mavick.dev>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1625; i=m@mavick.dev;
 h=from:subject:message-id; bh=VAHi+PBb8b+++SWfPayXCtK/lkvsgLLw/50K5jGemuU=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFmeU5l0mb+pzLrx2OpOQE3IPgYTWysVB97a7QY11zv3P
 f4Tt+hhRykLgxgXg6yYIktNVoJ7xspZicZHJ/XAzGFlAhnCwMUpABO5IszwP463Sk32nW2tdd5m
 jeV1e+SvdR/Udb74YjeLhZiPwt6wIEaGx5LTt+iK/fPfKZ4YUzlf621d/Pe5s3aULPpUEfA5Ro+
 JCQA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C654810000A
X-Stat-Signature: 46rsnbym6w86kc1uxnh46co54hj565zk
X-HE-Tag: 1783320450-196143
X-HE-Meta: U2FsdGVkX1+okoDlhMZV8WCIsEItOA4hdaNN864DHXD6xhwjihmxgqASmNBXf4vIShbv70jU08VyHlYYwQFecI6gkIMB5BEWrd7sL0Mu7V5kVukFxUxwbX+LllY61MV7AJeXAGJkaDYbB+gcQP64EadPOn004spTkmv3IRzMlXbI13XLygy6DJP0DsauNlG+BmLrKLLdPQQWujfmwelOl13BfWVff1n9yGB74B+aDVP3uURC1j5ct1F9ATpUHkixA7bM7qplAIA7+5oCL9D14ugvB+IsPnllNXG5LweHBpb9nR8M8OoJyXb+cwyPOfwAEKOIsn0Y7qMPEVtPw1cFABxWHhOt46+EqWbr14hy7pnY+DCII2Hu+0GHAAlqG1MA2vuUIGjLXHjVFEhuxINO5/yGWZxCIpzk7+EYZU6IvCDkowCG5nkQRprzaz3FPcSIufbHRBQbtUhXiJAJtmCWlFmJtbouWZJ32d1ERRKNz03ZrGa2z8BIPNz2RBgg6uX4Qzx+Wj94d2JPeBmc5QIXE4ARipV1udP9SOpom5rNr+0mPXh4JlVJFXourDqPQiQTIpXos6/hu30+s5/T6eW24gXvgllvcp8ugbNtjGJwjDBfyFIJGX5ppDCIfUuE6fNsyYARb+sn1XfgPRV5Z0YS4VFm7Duj/shhcXyNjYWfKTS4OVqsvgcvTdbGngtkgReiAJlJLsUm2HgYOqgLP8ug7TKX4B3PdijJneVb9oZfQDnvFgys2HheHpiYkvFJAHlo/eYWyk6dvGPDkLEbrEqTqFdPCqFDznu6X/CURLPY8gtxva/GVGtwLCV1AVmJ1bDbpyr6DgIrjgCGTwXHK2ZGXHEDCwrcVyMJL3OyDarQN6WTIIen6896Co8rmzTWo6JBlJVT/0e48YJoQI15zmZRn9a4a+JVCAUmM1gnKoOQyhLrCuMDEAyymqmrAd3hPTubsWDMuPwZMsh2QwP3c7P
 2y9S8BDR
 D6FJw7XlDGLt6JQWVYaqnw0whQbk/HbTIJap6wf4I3fhUEgwf9gt3l3T06EzZlqkNH0AcOiJ1xax8/OaUlm0jYv24/FTryzIJFb/6lOUPO/1BWdXgALW9pj8Herqen41bjNYVEtnT+Z2S1tNA3iiwfBJ/EnQSia0mKBh6s97EP5hrTQYE/qw73LVmVBVJXZDZBjblNa6GrBHqMr5QfTKOLheBFQFfE/8s7WcgHEr18E3CpztbjGOCPV+MgdZ2kL7omKIPf2PRvKs/zwBGS7YjwYyUIo8liX/Ycp07
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When debugging use-after-free(UAF) bugs, knowing when the object reaches
0 references and enters final release can significantly aide the
debugging process.

There is currently no universal way to trace this information.

This patches traces the final puts in the most widely used refcounting
implementations, refcount_t(and thus kref which uses it), and
percpu-ref.

The tracepoint records three fields:
- caller: function that called the refcounting
  function(refcount_sub_and_test, percpu_ref_put_many)
- fn: refcounting function(eg refcount_sub_and_test)
- obj: refcount object(struct percpu_ref, refcount_t) 

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
Eugene Mavick (4):
      tracing: add ref_trace_final_put tracepoint
      refcount: add ref_trace_final_put tracepoint
      percpu-refcount: add ref_trace_final_put trace
      kunit: add test for ref_trace_final_put

 MAINTAINERS                      |   3 +
 include/linux/percpu-refcount.h  |   5 +-
 include/linux/ref_trace.h        |  26 ++++++++
 include/linux/refcount.h         |   2 +
 include/trace/events/ref_trace.h |  46 +++++++++++++
 lib/Kconfig                      |  10 +++
 lib/Makefile                     |   2 +
 lib/ref_trace.c                  |  12 ++++
 lib/tests/Makefile               |   1 +
 lib/tests/ref_trace_kunit.c      | 138 +++++++++++++++++++++++++++++++++++++++
 10 files changed, 244 insertions(+), 1 deletion(-)
---
base-commit: df685633c3dbc67441cc86f1c3fee58de4652ba2
change-id: 20260624-refcount-final-put-trace-49bd7c39bd5a

Best regards,
-- 
Eugene Mavick <m@mavick.dev>


