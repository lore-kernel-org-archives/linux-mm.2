Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54EC2C55172
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 11:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE2146B007B; Sat,  1 Aug 2026 07:00:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6BA06B0088; Sat,  1 Aug 2026 07:00:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D38FA6B008A; Sat,  1 Aug 2026 07:00:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BB146B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 07:00:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0296414029B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 11:00:37 +0000 (UTC)
X-FDA: 85052407356.24.8555266
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf15.hostedemail.com (Postfix) with ESMTP id E2AF4A001B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 11:00:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b="O07omYD/";
	spf=pass (imf15.hostedemail.com: domain of m@mavick.dev designates 80.241.56.152 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785582036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cBoaakX6zBs/gj7AiDhBmuJ67OOemsvukMx0aYqxBDA=;
	b=Aq66pghS6vVZ3yfE90UOERNbGqajdIVLpJHIBI0CG7ywGUeqTsOC05hx8Y7SJtpqIq9wFf
	vji9zAzVtX2hOpqz59cseFpOPclWJY/iMKc58Zmr/l8OLPnSc/ZA6xNAc5ZWRa78JFJF8s
	iZcqdUp9eaEz/UzD+ejxZFwi5lJw6MQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785582036;
	b=bfETk1Fkg+u3nktkt6aTh1OgSuc19OxWkfY/dNAlz2GwEdZHBlaMQ79EzKocsO7niMkZQX
	B7vzm+iiX4aEZtxgcGR9id4sXQdh3JpRCJjyM7fPEAcBkR5DMOJJuymRh0luF3m7ZSrxgs
	mbHU1rTYZKOw3Ntud1D3fHdvvfTX8A4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b="O07omYD/";
	spf=pass (imf15.hostedemail.com: domain of m@mavick.dev designates 80.241.56.152 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4hC0N01PlYzKw3H;
	Sat, 01 Aug 2026 13:00:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mavick.dev; s=MBO0001;
	t=1785582032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cBoaakX6zBs/gj7AiDhBmuJ67OOemsvukMx0aYqxBDA=;
	b=O07omYD/TKlY63qs5PoW+4ZZDTwT++VB+WIsmTm3OoxI5CHDTxH+/38tsULm3OLJo7rPRT
	Fd6C2ctmmJbNp9OwmPmp2RhwO6irb62yallXsFSvv8eQ0cbWpvWMWnWYrpV7KHj4SQrlqz
	3KU5ievSD16OPQOYw+IkA8Nm+D19guSXZBJ40LlRbNZi+sjVF1y/qs1sRL/EqOxT8LpDe/
	DHEcMor8Zegp7VTwGHY0BSepw5ZjG6TGyRK7Ag+rh5AOeaTKLLBtbJCtH87pC9WH8hdhEp
	i1PFhnjbk9Mr34S/7oVIBfhyjiq4PUcJZmDhIg19hSxqxMKvmj8NO07iqlDtog==
From: Eugene Mavick <m@mavick.dev>
Subject: [PATCH v4 0/5] tracing: add ref_trace_final_put tracing
Date: Sat, 01 Aug 2026 18:59:40 +0800
Message-Id: <20260801-refcount-final-put-trace-v4-0-2e58678f0ffd@mavick.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJzRbWoC/53QzWrDMAwH8FcpPs9F/oid7LT3GD0olryadklxU
 rNR8u5z2h26Swe9CP7C/knoIibOiSfxurmIzCVNaRxqsC8bEfY4fLBMVLPQoB04bWXmGMbzMMu
 YBjzK03mWc8bA0nY9+WBqbVDU76f6Mn1d6fddzfs0zWP+vk4qau3eUA8P0KIkyN623jpCFbV/+
 8SSwmFLXNYhv0LzjxCIAJR12mH3nIBWkYkE3LonBUDujGPqfQP3wnqbYu7uodQDyVTJeRvaCIa
 6+GeX3bIsP6HZLKnRAQAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3594; i=m@mavick.dev;
 h=from:subject:message-id; bh=MDafnfB1GDIM5zQPp3sjU0DDGIR5zawIDkA6gcsYcNo=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFm5FzeeFft0x3O/2rmnlR9FamzU3yqGbV3xccYJ2ZzqC
 f6/RL4kd5SyMIhxMciKKbLUZCW4Z6yclWh8dFIPzBxWJpAhDFycAjCRkHBGhimZDU93pScrXEhi
 uXHwtMaBibqOn7vv+tR+XvUzq8bh3QFGhk15cZdY+ZQOnIhJ0F8xJ9/Krveho40Hv+I2u+M5/kX
 1nAA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E2AF4A001B
X-Stat-Signature: ibnqr7c8rzzxtkydoupqrds1p9cuhgy6
X-HE-Tag: 1785582035-528768
X-HE-Meta: U2FsdGVkX1+n0PQc2CfA3Elp0KCuTB4itU5nCuLHHvlKtjIz5ADzrczg7nbY0yOSSxNgd9OfNW6QNSEPcmEIkMKG2AhyQUgKL4kfCjdSoHQ7GIpULFpxHfrt1iC0J7+9Sqh0V2TX+wJcdrZ94WJoGEgxl8+jP8S88raIBxf2Q0rM4JEIZWZAr+RtJP0XW6elUTEuIsghTZJCos7crV55npYpsUlGfQTaiR0W1FUg0rglNGSVFj5bQafR8NU1sUMwTm5eK6iu6mBJcMf3UEqVm7RawYVID1AiyIX2cIq4xea5pLRXdK+Uh+DlwCOLYBpbVo2SAyW+yGnwO33WCf2U7uupgJyI/ls9CEz38qN1We65sYwvKdNpox5mIQ18mzMeseiB5KMIHXUTn2PxHCrKrBIVT4bAXaHY8kYQkE9UX/zoo3UbiOXayjUDozWnDWWwAA/xk7pnbZRKJK+sU9mOasJ3Xk3sk6ucH//Jxe04SluqNUk4USspsVfI/7q9FWazul4dj/wmk2MdMmLEeqfWRV7KWQFOhD9RnXiGmytvRMbZ/bAybpXJvVynBxLLTnGuH+o9/cGDy/GSYB0f9+eZBSrn6sePGc/ahJCxN2Gl1bv3lAzp3hYxtSSBlA6ze2uOWV9xxeVvGyWnXnaIs2Kng3X6NVN8pbDCo5wg/QPfoZta7QsuJ4cQ8DcmeGAubrIECTh3PNCFgLNeTYHppmu7Hi64601k/RkKES4XJfcgDJ5OtHo1Ix9eNP79260l+Rnl4KWzohf6u1L3/G/UaTq3OEvHGCqfWL5Alsj7Ot2N+t0YsaTp+FNl0jmVycKLnU7jL3gj4ooY5MKcPivKn6YpCtqDok9itHyQ8wUTYXRbV7RbPT+Izr+brBZ8NbUw7pM/Xlyn0eB6kVmyGM/eWv3IpV7HQfG/lk/UaAVdXhOCDfdiWiyypcg4MO0LITjoNIFLdOO3q8sSmBVAKcpcE0b
 evHtaYzg
 +vLmeTTwl2W5NfSUUWhnM/BP0b0zCwdMMnjdGW30DDJmltBajK4UT8uQTPv+erkvwxuCPTJpSRpvIBVcXSo2UKprPS+dg967kBItfFBzLGn7ahBqeF4y9Dzzx1GDstkaFVcYUjYw7aaV2qfEyfrVbIY+1QX3nCSjwWypyH3LF36eQwwaHtwSUgzswgmhfLiAmT3TqOYs9XCrc7K5uNhbpspexsB0z0F6cylcRUPtSJBUzVy+BGeKDUxw1zlHKTYYBCMmJd0j9KPt0gLJRt+mA0L8AmRWPbsCIcuIKqTmMZgdPGjTes3CtvYsi1D0sa7a7ZmgBBgnDzVCf0/s75LDOhon2cgKvyXB/xC8u
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
- ip: return address of the trace wrapper macro call
- obj: refcount object(struct percpu_ref, refcount_t)

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
Changes in v4:
ref-trace:
-remove fn
-add ip variable
-change trace wrapper macro respectively, _THIS_IP_ is used for ip variable
-change relevant code respect to fn removal and ip addition
-fix style issues in include/linux/ref_trace.h
-add new macro do_trace_ref_final_put_cond that only calls tracepoint if cond is
 true
lib/refcount.c:
-change from do_trace_ref_final_put to *_cond
-remove if statement above since _cond already performs the check
KUnit:
-change relevant code respect to fn removal and ip addition
-check if caller and ip are valid addresses
-change timeout from 10 jiffies to 10 seconds
-move didn't timeout assertion from before to after probe
 unregistration, to prevent it from impacting next test

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

Changes in v2:
-include/linux/ref_trace.h: change macro name, use direct tracepoint
 call in macro to avoid double check
-add tracepoint to refcount_dec_if_one
-kunit: make significant improvements to design, fix critical bug, add test case for
 refcount_dec_if_one()
-Link to v1: https://lore.kernel.org/r/20260705-refcount-final-put-trace-v1-0-0ae936edb750@mavick.dev

---
Eugene Mavick (5):
      tracing: add ref_trace_final_put tracepoint
      refcount: add ref_trace_final_put tracepoint
      percpu-refcount: add ref_trace_final_put trace
      kunit: add test for ref_trace_final_put
      MAINTAINERS: add entries for ref_trace_final_put

 MAINTAINERS                      |   3 +
 include/linux/percpu-refcount.h  |   5 +-
 include/linux/ref_trace.h        |  40 +++++++++++
 include/linux/refcount.h         |   2 +
 include/trace/events/ref_trace.h |  51 ++++++++++++++
 lib/Kconfig                      |  10 +++
 lib/Makefile                     |   2 +
 lib/ref_trace.c                  |  13 ++++
 lib/refcount.c                   |   6 +-
 lib/tests/Makefile               |   1 +
 lib/tests/ref_trace_kunit.c      | 141 +++++++++++++++++++++++++++++++++++++++
 11 files changed, 272 insertions(+), 2 deletions(-)
---
base-commit: df685633c3dbc67441cc86f1c3fee58de4652ba2
change-id: 20260624-refcount-final-put-trace-49bd7c39bd5a

Best regards,
-- 
Eugene Mavick <m@mavick.dev>


