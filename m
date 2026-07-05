Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75A83C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 01:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 469476B00A5; Sat,  4 Jul 2026 21:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EB136B00A9; Sat,  4 Jul 2026 21:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23D196B00AB; Sat,  4 Jul 2026 21:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E3A016B00A5
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 21:21:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 56AA91205CE
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 01:21:22 +0000 (UTC)
X-FDA: 84952970004.17.1779501
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 662D5160003
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 01:21:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CH2rm2gT;
	spf=pass (imf08.hostedemail.com: domain of devnull+m.mavick.dev@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+m.mavick.dev@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783214480;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gYvWa0a+H8FfjqJJnBn2v0RRcagiBJzaxOLvVSTlOmw=;
	b=dWZEMNq0rKx7VyYWn2PrELJqsRwnjb9LnFNQUADdVlOBIMFQK9Nk0OKYA4nRMylgA8kW3l
	xJWp7WHmEzzUt/o/eOnFYse4+rc9l5CzdIs+B2tWvPlw2Dyj5mhH99S6P4BNJ11cA1xERn
	DbVDVaEGR2adxjjaCh5D9WwnFm4rN1I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CH2rm2gT;
	spf=pass (imf08.hostedemail.com: domain of devnull+m.mavick.dev@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+m.mavick.dev@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783214480;
	b=gzf6k0OS3UVJ1t3BYb/y83yG8mpLXlUzXuqMVfeWgfV6/aVD2x4bglwgC3wn89ZngDkVHO
	+nxG0FETmebLG/esKLnM35BcaJbSkZslD2oAxWvC8Sr7px1ZD6394e2aOhocu2jrDbSssP
	5FlyMNEafjeGZjf08XIJ8Ez25Q6fB7g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7198A42A2D;
	Sun,  5 Jul 2026 01:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2FB70C19425;
	Sun,  5 Jul 2026 01:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783214479;
	bh=VAHi+PBb8b+++SWfPayXCtK/lkvsgLLw/50K5jGemuU=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=CH2rm2gT+ENl17AEUVXEarn9rco7+PovrVKWa4fIZiN8ItaO4zCzgRN7LmzLiL7ev
	 4fXCx7l19wP6jmoCLdvcJnlvuxgReAJpiBnjGAkGS0mie9k2Jj6xirh+5jovU7Vc4j
	 wM69DRXioDMzMHQFCgPMs8ixhxqTIJiGqEIzxynzbMXYl9Y11Vwafy2jaa8FDFdhV3
	 bLgPX5Xfy8hrD8sjDWNJPyziXr31a1UfhltefJqOq9RYZEB69Y3P0636tnUhtJcdee
	 x38DoOR/I3kFM8YJTQ3RPK9vmepoGK/2R7Le8UamfEWWzqL4clGBJQl8oHzN2vvqV7
	 FSby7J6wivrgQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF405C43458;
	Sun,  5 Jul 2026 01:21:18 +0000 (UTC)
From: Eugene Mavick via B4 Relay <devnull+m.mavick.dev@kernel.org>
Subject: [PATCH 0/4] tracing: add ref_trace_final_put tracing
Date: Sun, 05 Jul 2026 09:20:50 +0800
Message-Id: <20260705-refcount-final-put-trace-v1-0-0ae936edb750@mavick.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHKxSWoC/53NTQ7CIBAF4Ks0rMUApdC68h6mC8qPJSptgBJN0
 7tLqxs3mriZ5E1mvjeDoL3VARyKGXidbLCDywHvCiB74c4aWpUzIIgwxAiFXhs5TC5CY524wnG
 KMHohNaRNp7gs86wEyO9jvrT3jT61Ofc2xME/tqaE1+0L5egLmjBEsKM1p0wJbAg/3kSy8rJXO
 q0lb6H6IUilEMKUESaa/wRBsSqNQrpmH0K7LMsT7EtDCEUBAAA=
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
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1625; i=m@mavick.dev;
 h=from:subject:message-id;
 bh=VAHi+PBb8b+++SWfPayXCtK/lkvsgLLw/50K5jGemuU=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFmeGyslgz5sbDXY/cjNem4Q8wlzhtnsPpu3/pN6mzPJ9
 kbg9qpnHaUsDGJcDLJiiiw1WQnuGStnJRofndQDM4eVCWQIAxenAEzE1Jnhn84GqSPPEpdu+mpT
 JLou4bdi7f9Dedbc/6Z+zhCceWVKfTDD/8AVk68+Uta2fjT/vh3L0aXHcrvqXyRrJDKfZ5Bv8a0
 QYgYA
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Endpoint-Received: by B4 Relay for m@mavick.dev/default with auth_id=850
X-Original-From: Eugene Mavick <m@mavick.dev>
Reply-To: m@mavick.dev
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 662D5160003
X-Stat-Signature: jwqw19h7sur4pijbzh84otnyeidhihhs
X-HE-Tag: 1783214480-221180
X-HE-Meta: U2FsdGVkX19MbJ1cUhRpHX7gsnjSNWqZvsdJP2h05K+3J4jqba3jKWEoBMOPQCoEO4wV0m0ef1MIeFfrUfcF4qVnRyf7/lD8MXWnw9O1XNjYp1E8mGBs3gRQrE5v0LHzZ+RqaDCG2oz7M8c0xEsKwXmAsfL8bOZrOmMjOIA1zDVUJDGVeDs3v+TYweqcM4WBoEl87IWFZJDjb/UU+mdkQctIg8P5TEbKer9w/xxE1gGEuuVOuAUaPDtnlcpcywOIOF6PffWnHQkjCoR4Fs0fIwygojfvFUvm896iRics705VyAbxlFYZcAXKJtvArxkxkfDiKGtPADKMvA7OIeEB85yVMwpjIGNt+NDJxgCh7KzB5dcTvd/nfIkAAr+In67PHyWGSioOJTRwSL19Vynv3mxUrSiDUlfdJlNQWC+VFeK1BLv9XOLZtnuNVaC3zz88L8Spzx7HjVfGkm0H53Cs3o2JFbY8o9IQiszWhZQNXBturln6QXAb2Lymx1idJ1Hj9rvxz29aJpBTq0xPItDGNKmeKNBWF+i2odYl7VegIKk+JVOiAdTaNKAyE8Qp6TmV/yHWOrWw/yF/jZdAfxhbWfH1hU7Mlv4Du5lILnsD6GRXLcJU15LZw91KAollWUBhPVwIaO64ns1xhMUgBvaokxdITztwLLdTwEfLt8vszZrWXr5sH5xdWV6owaCyAyU8vH2tl/Tlhf5SvNaJq009fxpuLQl4T8QGXT88sSBp6Yc1FitD9826ebNGqkvw/al/irNeeclk4/BHWthwmSAsBDuRgxaUCYbb/whM+oQ5zCMkMqshuBlhPs3mJ3/LQY/zbQv8uhYLJhH3UGwbwCvS0tkZ9pZWLBaVRMgYS1kCzYAYOHhGxxi5Og9qeLWPmMOjABbTEmbNp7akmuCQbNURpps/9Ha862kqM/Iw421m8qnR9uzOgmtCpUKU1SiUVBNjR0U9Xnja8CQ2t5RXqVE
 WyqXiKxR
 C51VoM6Fk0G90nCD7jIrIIC7JwrxKlm5Z3J/QYkI//l8tH3us7VcgHkYpI7j8rqdSd3ziCP4OdXyZS8AuvVIGvFVIU0dg3UM59vb1asWkFvUn3hkHnQ6/CRfClYDK0sGb0a2sOJ81q+5RIGTKLN5MhGiflS5cBKnZFWhA5r+yKhXpQotkIBnco/pKpQXCTYtMrRUhJBrlqVaRGxkykv9FUE+JTgWPb3vOiH7BDnQoc4owTSTKZjxVfQAmp+bNyLReQ4Tmo1Espld9DytzHmxJGpf0yRnpL4Mfx2KZId1lq1Xzw8R9sdQmUfLdAYoOvsCddwqgNY8RiuoIhgbbyK+XcxjH3klyYXeQ8MznTPq0J6J6JOgi0AMJ08akK0TqUndP6Dj8fvKcvhQ0ojSt4ra2mQrkC+ZmtAVlD4chlzV87CQnwF7K9UBQLrwZzQ==
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



