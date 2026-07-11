Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E435BC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 04:41:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA53C6B0005; Sat, 11 Jul 2026 00:41:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B285C6B0088; Sat, 11 Jul 2026 00:41:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EEE76B008A; Sat, 11 Jul 2026 00:41:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 78E576B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:41:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1CBAF1A0680
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:41:06 +0000 (UTC)
X-FDA: 84975246132.23.29B368F
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf02.hostedemail.com (Postfix) with ESMTP id 986FA80004
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:41:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=Dw+VcXvF;
	spf=pass (imf02.hostedemail.com: domain of m@mavick.dev designates 80.241.56.151 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783744864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=J8SZk0InEttprJDG8mhzTigtAJH/J1bkTIxhCwzTmU0=;
	b=yzmx2aMZpwpwYTPgwCMCp84JUljDHQAjyZ1WW53JURSJfv6IZmIgWjb45XCmSlof27uzfS
	aTERvcmFkGHRIPQ8hWEQku2ZN8sYbSk0kmu8yxJVJRlef3Rw25V+sjy60kzUu9RAlGeaFW
	XDj5rTq+EBneuJKZIcxLPYGNnfxpTao=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=Dw+VcXvF;
	spf=pass (imf02.hostedemail.com: domain of m@mavick.dev designates 80.241.56.151 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783744864;
	b=Om/kJbgICm7Trp/tYPzIbgt0n+2+XY2Mrobgv/xBBseLkw81H9H5vYM0IiErrbcr1H1K7F
	qp5V1bqwQRarl5tEeddQed4d/s49NS1bFvS8JkCNebwcshyK12Lo1FcWq6zwFCh0cgS3PR
	hyBFlPvUlxQ4PmQfpIGDKb8RqyTjJ54=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4gxwxl1MHpz8txV;
	Sat, 11 Jul 2026 06:40:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mavick.dev; s=MBO0001;
	t=1783744859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=J8SZk0InEttprJDG8mhzTigtAJH/J1bkTIxhCwzTmU0=;
	b=Dw+VcXvFWtGuNenkEtsfTh3g1xjYxDSW8O4jev99FvCELwD+/GBbx9VgCmf4WpHT+L+aWs
	PLOnwO3KPedWAcZXiO+BqCEjGQW8xPoxO/kWxbmihXP4JybM/TbvMxpNbXLLNRe2OxWEzw
	I6WXqNnJsv5XqqETMXRAFySvrysPDY+4foU6YCmHIjTXE+Ec6qZti3oR54F13rDSNrl5WK
	min9LNdMxJCLDS2V/xlfTfgZJKl7N50VvxF2G+0V9Jr/jwc4X04dNW2veFOginm7o9FjSL
	nTuYQDME14Z4Ihd1Csc4p/xEuInLCOPLJM/qDaDyyQsdcwARA78Un92YPtM+gw==
From: Eugene Mavick <m@mavick.dev>
Subject: [PATCH v3 0/5] tracing: add ref_trace_final_put tracing
Date: Sat, 11 Jul 2026 12:40:18 +0800
Message-Id: <20260711-refcount-final-put-trace-v3-0-674c8f03d9f9@mavick.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADLJUWoC/53NPQ7CMAwF4KugzAQ5aZpQJu6BGNzYhQhoq7REI
 NS7E34GJpBYLD3L/t5NDBwDD2I1u4nIKQyha3Mo5jPh99juWAbKWWjQFqw2MnLju3M7yia0eJT
 9eZRjRM/SVDU5X+RZosjvfb4Mlye92ea8D8PYxeuzKanH9oU6+IImJUHWZumMJVSNdusTpuAPC
 +L0KHkL5Q/BEwEoY7XF6j8BjaKiIeCl/VMA5KqwTLUr4VPYTtN0B/0hmgKHAQAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2848; i=m@mavick.dev;
 h=from:subject:message-id; bh=8irLUPm5Lq6cNJ89PXbBgzxwq7P/2J537PB1GhrlIzU=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFmBJ217dtxMUysV1Tb6q6Ods0+w3ecF94YlCec+MXw5v
 mDLp86YjlIWBjEuBlkxRZaarAT3jJWzEo2PTuqBmcPKBDKEgYtTACbCpc3IcHyTcf3D9JjWzj4D
 Fr6HS1bYnD/l3fDDUvZQw8HWy19YVzL8z9thax6oPX1p0d3+fAv1Da8PqB6Mvum/xktcOthJWqC
 ZAQA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Stat-Signature: 3jfsgg16uhgyq8jnfp6xizm75fhs58eo
X-Rspamd-Queue-Id: 986FA80004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783744863-350701
X-HE-Meta: U2FsdGVkX19D9IfdHR7VgEIkf1i5XpIAgC1v0YIZDiXyBv8hY3AflHGPCT4Vo6A7AanZJ6viAT9GkkiwsS2QYeDz2txWyJPXVvKCx5rBFbpU3oJkxeYfuKTxZ2G3McALq3QlgTaH62vB8R2O2/eMSIkAT3E2WNTtkY2RQFNIy0HIHgF8WbymjPGsXbQPWx6YnuGfnuLbk4tOjCSZlngkG1gBnRKOS9F+PsKoOTkFlNZsCrwEo4zCHtBf5VyEqcBce+9UmqWUdHzcBNIb8gvNoZYg/drWB3MHrYOqR7/cqyIEzhPBgWQtCPUz1XkdO8c1JXKDk706wB8o8b+QwR9Hvk4KW5Wxniln/75pWwLHxgwELcmXav8N+sA7dgbiQP6HgyOf3Yzzoxbi4YKqdtC9NhfJxHRlLelWtLkubxZTfgzwEUOZG4hosNjZSdLlFfq5zgjCsjGr4j8uT7ne6tG8eSCl02iZ0LZkYAaJMMtIHccciJqEFXVUsnFenNt1vStdY+4OjaqNVa1IMHex8uCVG40IGw1Xv0fdfg096Q+SZBBlgG1vvE9MVlzCzCzuEHaXaeSidd+jaqnsN2M0XI78SroVOKShC4XWDQxqTTlbwFrkqHluTiMDe7yt1IFR9CAXwImNbhPZRuv1J2Oep2fwpnj86ZofudiJlxR52ImxletitDO+geYebffglMS+WhzHHUkcejY3+xOzRP3g3PdwGuPNjEzBGRgm2vdvgbrxcq4qIw8zr6BmWbzUHlTn7CB6NeAh65uESGJ8HQOBYhXn9d+nCZFcWLiOE6jZGcwoSFRzOQ/ezPzEEoWJJJ0zE0f51eJi+9/3eEoWxQeNVLwGtKQPQG/iG1y1X6/qac7qnfBkxIREFLt52p8PiYJkS3Ogs/PHSWN76oeMN8BHf+Zm0mEauJoSWbydIgeUPuMjv6ZErQ+Ye3quOibH3t0I7XyVy5YS+ZDPOX41S5AsMyX
 DfKI2EjE
 WRuAa/VCetbW6XhrVGCXIu5UCAQbv8HuHigO2X/u+8CR8PAB4OK4w4gKTkJ35VpUSkw4WKi7iwt41THrfFNGF631b/P3WUjksUgbRmGHXFgMLZc2kvFm5KUi6Oih8/vOQ5a/OSkWJ037CAZxM65JmwRYNf/qEtu0cLXulTjmyWw/vyAkNoU0PFVVtRcBiMfKD+4GWwAObaoJ/NQxLJsCoXFvMOvxDd1yLs7hPCKmWvjAEostFMnlmQbbBlp4aTsxDtWon02iPJiUIA80fVjf6+OEnATBS9fdhiuriwSB7aLqAQWMmVwsD5pehXfRWqKSrFuDWwZharIx1T7F58QHPiUzeKVDmibKXvun/0kLpDsT7sDiJcrT3j3NEig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When debugging use-after-free(UAF) bugs, knowing when the object reaches
0 references and enters final release can significantly aid the
debugging process.

There is currently no universal way to trace this information.

This patch series implements tracing of the final puts in the
most widely used refcounting implementations,
refcount_t(and thus kref which uses it), and percpu-ref.

The tracepoint records three fields:
- caller: function that called the refcounting
  function(refcount_sub_and_test, percpu_ref_put_many)
- fn: refcounting function(eg refcount_sub_and_test)
- obj: refcount object(struct percpu_ref, refcount_t)

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
Changes in v2:
-include/linux/ref_trace.h: change macro name, use direct tracepoint
 call in macro to avoid double check
-add tracepoint to refcount_dec_if_one
-kunit: make significant improvements to design, fix critical bug, add test case for
 refcount_dec_if_one()
-Link to v1: https://lore.kernel.org/r/20260705-refcount-final-put-trace-v1-0-0ae936edb750@mavick.dev

Changes in v3:
include/trace/events/ref_trace.h kernel doc comments:
-caller of refcount function -> return address of refcount function
-ref_trace_final_put->do_ref_trace_final_put
lib/ref_trace.c: add include trace/events/ref_trace.h
kunit:
-change Kconfig depends from FTRACE->TRACEPOINTS
-EXPECT_FALSE->ASSERT_FALSE for calling percpu_ref_init
-add tracepoint_synchronise_unregister to test_exit macro
-added timeout to capture.count waiting
-remove noinline and __always_inline from function attributes
 (added for testing, but accidentally submitted)
-add period to the end of Kconfig help text
v2 link:
https://lore.kernel.org/all/20260710-refcount-final-put-trace-v2-0-557cfce860a2@mavick.dev/

---
Eugene Mavick (5):
      tracing: add ref_trace_final_put tracepoint
      refcount: add ref_trace_final_put tracepoint
      percpu-refcount: add ref_trace_final_put trace
      kunit: add test for ref_trace_final_put
      MAINTAINERS: add entries for ref_trace_final_put

 MAINTAINERS                      |   3 +
 include/linux/percpu-refcount.h  |   5 +-
 include/linux/ref_trace.h        |  26 ++++++++
 include/linux/refcount.h         |   2 +
 include/trace/events/ref_trace.h |  46 +++++++++++++
 lib/Kconfig                      |  10 +++
 lib/Makefile                     |   2 +
 lib/ref_trace.c                  |  13 ++++
 lib/refcount.c                   |   8 ++-
 lib/tests/Makefile               |   1 +
 lib/tests/ref_trace_kunit.c      | 141 +++++++++++++++++++++++++++++++++++++++
 11 files changed, 255 insertions(+), 2 deletions(-)
---
base-commit: df685633c3dbc67441cc86f1c3fee58de4652ba2
change-id: 20260624-refcount-final-put-trace-49bd7c39bd5a

Best regards,
-- 
Eugene Mavick <m@mavick.dev>


