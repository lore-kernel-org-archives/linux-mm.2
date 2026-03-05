Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC010F47CA6
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 18:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA8516B0088; Thu,  5 Mar 2026 13:05:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8A406B0089; Thu,  5 Mar 2026 13:05:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988F16B008A; Thu,  5 Mar 2026 13:05:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8894E6B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:05:32 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3237A57B60
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 18:05:32 +0000 (UTC)
X-FDA: 84512786904.20.787B0F7
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6535C40010
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 18:05:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772733930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rBkqhebIOJ9pMwwpPDcn8aKfw0hEhLThq+KYpZOTkmc=;
	b=laN4DGmGteGOqy+2IsmHqdDodLKPrJxx4erfzosCwh7Ud+UtlXYl1o1PWo5OQ/+P7i/0JQ
	+aj079yFtDTmcig18JNvCkE8q9Q/IFrbipkobbbCgCOC34PDuGG1SPVgIi8567MUYEer10
	oB1viVAA33ijA5hF7yxQj1i2fqZKCj0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772733930; a=rsa-sha256;
	cv=none;
	b=wzb3KT9XYjffm2P5GO+mmAgeH0/WAIPxhrhZLqZDDYVd+rJ2LrxZRRXQ72zBlFCTX7IzrK
	o4kjwKMCfT2UWz5qVKKeS8AaWDHiMW73+P3PP5YoFZ1TJUVMHoQZM/hDL1ZDkjLI05ufso
	Dnu63zr36Q38XVo12LVCUmSypN1Xc/Q=
Received: from omf04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71FE6C124F;
	Thu,  5 Mar 2026 18:05:28 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id 8DC0520027;
	Thu,  5 Mar 2026 18:05:25 +0000 (UTC)
Date: Thu, 5 Mar 2026 13:06:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>, Dennis Zhou <dennis@kernel.org>, Tejun
 Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng
 <boqun@kernel.org>, Waiman Long <longman@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH RFC 3/3] locking: Wire up contended_release tracepoint
Message-ID: <20260305130604.659cca36@gandalf.local.home>
In-Reply-To: <20260305174223.GA1442992@noisy.programming.kicks-ass.net>
References: <cover.1772642407.git.d@ilvokhin.com>
	<8298e098d3418cb446ef396f119edac58a3414e9.1772642407.git.d@ilvokhin.com>
	<20260305105924.7069eb23@gandalf.local.home>
	<20260305174223.GA1442992@noisy.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18NdASASaDUUqrewaKrX7VQ1YHMm7kOZy4=
X-HE-Meta: U2FsdGVkX18Cwu3Ie+Ud/EYZs/iZOO+gEKcsZJG5kc+m818AijzCNfTe15GqcbqPGu5UD5364uYz52fYMJsuYKSLuVZMWPUxjHJqTuXpjdqUpzOpgHs/C86AVdvo4JPtJZ8OVPP96+eGAUdAAuEuP3XTuWY8kLZfsaIeqUAJQoDBOJjigtMWDFuNTQr6KFNJdwWtXDCBEIk2yPzkqg/0AShIPEhsBJ4ry5eOCUClWeoRC0Orw1pS3fQA3oU7ihUUpk51cgBmHeIKw4U9PFk6KKWrdgiRwxVPnq+HHiPvjLfLPgH+tR9enQ0AyVzzyjQLyS7dE6UWok/Y7/CrwJRoRvmXZlqb/w4bRh4RZIjZuYl9Qu0jmiVUw+Z/sQk2bP2x
X-Rspamd-Queue-Id: 6535C40010
X-Stat-Signature: 7e37yoxoqbfox1qt9hisz4ytcd6fx6fk
X-HE-Tag-Orig: 1772733925-773976
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772733930-836726
X-HE-Meta: U2FsdGVkX1+WOxZVhI0RjLBk8gxiAqhpkOL9CdZkM6PhqYG4dWfRe+XjCYfXOKptTkL2Zz/mYUZtQjv2RcoiE8ibqXnDifx8SL+hXsAjpVgVtMt6FyBMjzCfWqd3vaAJBnc6FkCFxbiV0eQO7+vivqTfcjR4I2Rsj5BtgOT/6n1lwZWgGTxVVN5ndqs93XtpLrWrU1AsWUN+NFCn65Plid0ZidHPhddw0viQkmCekye1Ar3/AHCLnTyHzMHyj5GkCCm/pz+9NZl2ZugI7DPmMx4OXOykVJQ/z7YBOAFvAIZ1TY7cP8z6xysXs2WV0OkGp2iMZNAMHClpfex9yXGN/Hv4IPW8MeBJxKxiI/oxFkzEoOxNTDgSuRRDsGZcdLKqXtlO+KFRUmG9Oyk7ET8IRFTLf5Z0D5BMZf7ZMGsk46q9qmLiVnBdsGYZyz0wvzzGfj4kbdSEwdMbJhnULs+r9Yv28bmHUdrNOgZeRN4srkAC3zqnT63CQ2FHHaZO0c81QsLe3v+go1nhXZWYkeVxnCae8CZSDSXESiF8aVWKtjWrj23ZDahTEW973J+8hGEn/1vnpt1udHBgtm0qp6xn48SNvQjg5iuwVO7vodSl4BntbBGoDqpEWSHnR8AYBm8gigTqOuwUaG+ApxtU9UVSs6kUa++DV3qajaVitHqaMxVdw0Lz2PUcp+rtj+g8Az+BdNONYYPjIXPHq2WKRnP78U485WZY9DDixVYLaZBsXLUztaJkyRvM+jnU/YmW2Nbe2iYdo6zvI6IJmb6WlVkiDfVo9Lq/3WORnI925sIYgF4WhDPsDvnbaYkWYNfJsE5PyQCI4TWQyJPlepJx5Lj28bsKL1cFw0KvzPtEMQl87sXaFVyljjpLYpqKUklCgrVXAw/c1a9x1ok7TMwQEj2YK7PiJJzPv/J9FdsGFV9xwebr82LxBaFbSX44pG8e58s4ESQ13q3OX4567cj+M9u
 eXFVJaxX
 ZVQxd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 5 Mar 2026 18:42:23 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> I still wish you would accept:
> 
> 	if (trace_foo_enabled() && foo)
> 		__do_trace_foo();
> 
> The compilers can't optimize the static branches and thus you'll get it
> twice for no reason.
> 
> I really wish they would just accept __pure, but alas.

Makes sense, and that could probably be done. It shouldn't be too hard to
do. If I find some time I could look at it, or perhaps someone lurking on
this thread could possibly give it a try! (I may even Cc some people that
want to learn this code).

-- Steve

