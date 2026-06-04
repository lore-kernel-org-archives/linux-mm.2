Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9BC1CD6E6D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 14:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D811A6B0092; Thu,  4 Jun 2026 10:45:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D58BE6B0093; Thu,  4 Jun 2026 10:45:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96DD6B0095; Thu,  4 Jun 2026 10:45:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB2AD6B0092
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:45:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 398784011E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:45:47 +0000 (UTC)
X-FDA: 84842504334.14.1451CBF
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id C59D380033
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:45:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UunZbDmJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780584345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LoH9pVzSpYK0TgEx0hXQxnSD6c2BaICmL/xjSUK10Ww=;
	b=fSrIEEcLvwMCawhECDnpJ6AsYZ3RyUgxloXc5KRXC+lJTFOIR6pBoW00+g3HEXUtvBYRZy
	f9BoXXb4tsA7gNqdYo3CinueQU7Tu/9we7gJ+Dvbbnhb+MawGZzsxxI/2ckS4SmcdnadU+
	AxE/3br291kSnSLxoHGKwAbh9qxVdjI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UunZbDmJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780584345;
	b=8Gzo8nCAwK7qslE/3ZkcixqCZX46vIy/O7txJlF2Zv/aIFvTkBDl/wCDB5zbKZVENWACS4
	g0Ab8wIrZsPcmKfWNHL7+UluNh59LpHbOzDkO25QqrbDMeWeNXGyrb8hDnBCGNVRHk/v/n
	iu12cfY7/+Wqolglb1J/yfLByVkx34E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780584342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LoH9pVzSpYK0TgEx0hXQxnSD6c2BaICmL/xjSUK10Ww=;
	b=UunZbDmJFl2Hukw9c9Op95EHjP5Wse54/m/q/IlZ7etwX58pebkfyhKwUwj1wQiFgiXAWZ
	Gk38TisXJS8L6yZGP9fJd+nu8bTes3YLNenILQ0e0QyogbJL9pKJOfGhjqkzmzMtySFZEs
	VbgOWsG1RIFkQsZSvgh6sx/5q6Ncvm8=
From: Usama Arif <usama.arif@linux.dev>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v7 3/3] locking: Add contended_release tracepoint to sleepable locks
Date: Thu,  4 Jun 2026 07:45:36 -0700
Message-ID: <20260604144537.3249856-1-usama.arif@linux.dev>
In-Reply-To: <02f4f6c5ce6761e7f6587cf0ff2289d962ecddd4.1780506267.git.d@ilvokhin.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: d3dyb8idh995y7cbu9yhtuz7ps5e5mar
X-Rspamd-Queue-Id: C59D380033
X-HE-Tag: 1780584344-899088
X-HE-Meta: U2FsdGVkX1/f3S5FuQt3ji7FkmgN+Nk3M23T/buHE/OEV/konO/yKUeqfXUl9GcLLtuQYXEptAlgBj9qnnJ7DF2YroyfhUD9+iJUWRT96S3y4qY8YCh+EmkBDNo0lGKrcwWojtFa2JSdX5B/BXHV11R6oZ5N9L/4C0+cOjV7k3qjcj24UfFACru/N901L095LubMT0NSNY/XHdldmtdPVrPUGxS/PwOwEeIhLRNSPvHtr4VTcMI3ktOc7IDMp8L4X+e0oSVNOLHnIa+FFIac6ig4FIdFBVfbq8dqZq+/2S/SGvrKCnEdbobMkjgYSLLCeYA2ASP3UzioiR37FNNiwadngNjNRuixl3n8cUQoq2Jo7QQbc467b0Uee4GUTiDYdlD/sDa9aF57bnP3+yrju8OZjXM17P+XpoG63AXj57NSiyQf8m2eOLc+O/6iPTAHz32GXdon2Qw8gEE9oTbaGGkzIa95mRpfAKc2Q/p72WGAjsVs9boFCyKVEyEpLNgRjHqeahfxMN7wz26ubyRnlezI482oypQgC5+x/E/sWruddNTKDJpHdbCqS+PKI7EdQFq7aMf3raq/pAIwTBfqRSytTHtNTEXNd4asH8QpDdKwsfHqoTmM1b90XvXvqRtfN3XGRPQoBl93sMHqxF0ARoXOy+8SZfZzz9tdw6/XWcdVcJMCJheAvB9uEWV+p6axNpB6CQaV1uRmdqF2VPXtITIsJYDj/efY1xt1KCMI0yVwj5C/n46vCpfuiy4lMwYDCXJR/CDOV6W6WAc6GTzvkJtGkV14DGDOEXxSIWjYpvjm+a/SpHYA78CW73glEF+PEIZh3vRAQyt4tgfnSF8oLnOhKv+MxkjN5iyNXwlyKDckjvWXEzeobygI+JVUwjtMwhmfuL7GXZLxHPnHZGdxATFA6XQmBZdXPgHKMgEq2hVAo3MpAH1fQshaDZyoi7FykYqf2aB9zmflQmTcCCo
 7StGTHkY
 wnjwdZ1lfyp9GDskHOoK3PeZWYVjkU6Yol8SG+Ir99zM8lJGD0ZqODgFFn91rPSXIqHbTTPq6hRhHheAAqZR51SC9feilREqRoqBLrgNPsAeGC6wBJhXnutQtzvot17VDsQMtyHUjfKgzPrhwe2LhknBlV451KVqYUvG8f6QkRzWCW3Ui10v1Sp2MtZFKbG4t6svUfFG1J0FJF7muO08tI6VmerhUt+ZkAAl/HHhI2BJE712pooXNIuH330aJEOh0sDsIm6ZnktLcsIlW0++p/6UIlb8d6wm0CGxFT9yl8ePbwoSXhqQalygb8rs60B2pZ+hTwuZi05IZ5hc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  4 Jun 2026 07:15:07 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> Add the contended_release trace event. This tracepoint fires on the
> holder side when a contended lock is released, complementing the
> existing contention_begin/contention_end tracepoints which fire on the
> waiter side.
> 
> This enables correlating lock hold time under contention with waiter
> events by lock address.
> 
> Add trace_contended_release()/trace_call__contended_release() calls to
> the slowpath unlock paths of sleepable locks: mutex, rtmutex, semaphore,
> rwsem, percpu-rwsem, and RT-specific rwbase locks.
> 
> Where possible, trace_contended_release() fires before the lock is
> released and before the waiter is woken. For some lock types, the
> tracepoint fires after the release but before the wake. Making the
> placement consistent across all lock types is not worth the added
> complexity.
> 
> For reader/writer locks, the tracepoint fires for every reader releasing
> while a writer is waiting, not only for the last reader.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Paul E. McKenney <paulmck@kernel.org>

Acked-by: Usama Arif <usama.arif@linux.dev>
 

