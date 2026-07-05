Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 334B0C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53DC06B00E3; Mon,  6 Jul 2026 02:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EB106B00E6; Mon,  6 Jul 2026 02:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33A6C6B00E7; Mon,  6 Jul 2026 02:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D72CC6B00DE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:43:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6375E402B7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:43:24 +0000 (UTC)
X-FDA: 84957410328.15.57C2532
Received: from mout-y-209.mailbox.org (mout-y-209.mailbox.org [91.198.250.237])
	by imf01.hostedemail.com (Postfix) with ESMTP id 886804000C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:43:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=mavick.dev;
	spf=pass (imf01.hostedemail.com: domain of m@mavick.dev designates 91.198.250.237 as permitted sender) smtp.mailfrom=m@mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783320202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=gYvWa0a+H8FfjqJJnBn2v0RRcagiBJzaxOLvVSTlOmw=;
	b=ok83EDTOBnPcB8r4mOtYWCPdupptY9Zp0dBBx3eXQQysHztKcHo0elVRPbWde82O1SJEi5
	MLVRt0C9ZnGs3T/vcXHhADhMdJOBlkyClZw3h+aEhnDjXfrbv/yJ3+1s6IH2xiW4HpLIYq
	w5nYrb/jAeQvgokPYXt9PX/+p06WLwE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=mavick.dev;
	spf=pass (imf01.hostedemail.com: domain of m@mavick.dev designates 91.198.250.237 as permitted sender) smtp.mailfrom=m@mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783320202;
	b=WzJk3sPb35Ldex0oCSPzXslvSmfBmr4N5we8GrwlpbKjS+m5YjGDYOQuQ+7GaSvgDdDMGs
	n+ZJYCDoOLnJf89mTDE4zUvwjal01NnE4vHgUpFzE+aD7B/HpYt6HwMo9aW/g+E57p8Lwh
	ZGSQzRtUR8iYB4bdbeBoG+t8IhuVhnA=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-y-209.mailbox.org (Postfix) with ESMTPS id 4gt7qs06Vwz7vTg;
	Sun, 05 Jul 2026 02:37:45 +0200 (CEST)
From: Eugene Mavick <m@mavick.dev>
Subject: [PATCH 0/4] tracing: add ref_trace_final_put tracing
Date: Sun, 05 Jul 2026 08:36:55 +0800
Message-Id: <20260705-refcount-final-put-trace-v1-0-a41d3fd0e869@mavick.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACenSWoC/4XNQQ7CIBAF0KsY1o4BpNS68h6mCwrUTlTaACWap
 neXVheudDPJn8y8P5FgPdpAjpuJeJswYO9yYNsN0Z1yFwtociacckklF+Btq/vRRWjRqRsMY4T
 olbYgqsaUep9noUh+H/IlPlb6XOfcYYi9f65NiS3bN1rSH2hiQKERh1JIo1jLy9NdJdTXnbFpK
 fkIxR9BG0MpE5JLVX0L9TzPL/+OceoDAQAA
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
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFmey21X+6y6OWVye0/AZ5Y1L17lvI5JDn6cYiI1LfOFx
 8bJZV/+dJSwMIhxMciKKbLUZCW4Z6yclWh8dFIPzBxWJpAhDFycAjCRW8wMPw5uMYn9xxHwYqPo
 TuXFebp3d/1affJ1WNP+FVtdJnxflcnIcLtOlEHxU9W+3zW+PdN3zlDQKd7R1He6U14pRVPMu2Q
 ROwA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Stat-Signature: t3kkpwj9sh9dj87o9gs36nrra4tmiw46
X-Rspamd-Queue-Id: 886804000C
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783320202-559301
X-HE-Meta: U2FsdGVkX1+CQ/EvucBStmL8CU9abLCLBGmVGBwOa2oRC3rkDlA4XSgrHfgt1gDOKP6VHVgSbXqfs6aUR6YNh6qDAZCdz44UUB3LGl+zKan52cqCKs4nzECg72CGEtXy1956J8h2/gHhn7QtlgzQzUlhLmcrIg9s3hUF1cXPnXJuAWEOazvfK7d7cQCjLH9U+e5HcaIJJMBBfQPdrI66zZmiAz1IQoIaeSTEfImFqtH1bWD5UIt8gvxo5ulynm/HycwuCuDBZAkRpGnvUz9T8gEuB0v3iFM0xZE9gYf+uriAEci5lA6oC2/p2WVeasvRnHEwo3Vpkw5lh9bh/5xsWa8ACSt1ZUtGTUYMiJVW1dsMYiwY+g9/DEWxrSAF9nt8sbXZDudr3Zl0IVZkyWS3BPAwsJkb5RZW5lDB8aWUXUy0qng0x/+boIQq4jvcRlMWYZYUp0O31xboU1KZXFWlv/itF4v6RhNg7N05b4XeRyT9kT689tmh/yfXwnPHfTOAIsoHgdgTj0/Avzc/i5Fc9zcGlnNSdzQJNGeiZJNRVo0BEVJE6Vtp/pKFIYTvFXpVEGqh6o7dgH1bp+afSd70gZzbHykk2pA/KNEpc2hh6RY31xs75CAX45b2o6EAwzTDI7d6nUapd9zYEKYkUPMdxsR0ufPQwJiFftgoUS4wxGmJNJftMjjOp3yhBKCVCEA+XgGPd8bI1S/x/bjpNBKJl0+ur7NKK7zBs0k/OLgj1u6P817dy3PtDaYdPPe4Ism3xYuWLRjVa5ckPMMx30Zm9Zv0FVQ6sUJHTufv7Z2X0Y+RY4ySqwyKX6KCNqoTZykijOt/NqIbQI7l/sssDT/Jt2xD029yuHvoWpzy7aaYYrjEP/MadndQe5m6Npr7JIkOoqZKbISQrAX3gVjxkgBiHIDTSHH/TvanvlD0i/3VrlMgWClmbM8lMQnl/ya2worpRJCWag+TXXdFEN0GiLM
 JBCys2qO
 Xxrr3JTiqHCP9pGQMT3RyYWMSUGV7xU0QDJVgUAU/lnK5+IdUKzQa2MAEf6isxmS2PsFeZKHf7edVH24RibeeEzgRvXQBK2VaDExZHJun9O83KgJojtIkDDV1VKIc06gTvmsTlPB0Yz7DcaOxV13EbtxlNPWxf0TRdaBaJxj+y+yP3mNFvnyVoOhVS2BwqvWlVKcvCRtMr81C6AXM8erx6EPb7CDtoTGjv+M4lAYqel+4JNfQyZUnG98eopWneE8jzWH0
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


