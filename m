Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4936010987A2
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:20:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0E506B011A; Fri, 20 Mar 2026 12:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE5B46B011B; Fri, 20 Mar 2026 12:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A22716B011C; Fri, 20 Mar 2026 12:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E37B6B011A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:20:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 439DAB7FCB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:20:34 +0000 (UTC)
X-FDA: 84566954388.02.51F8BC1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 635351C0017
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:20:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iStf9NT4;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774023632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+TvLQJijp0GxT4a1ka2lN/X2I1seKKn83xh7mzwJWo=;
	b=5H9yyFnniPEZFth7zMXhMiJEfUze5EhUw4DUv/DZ1Hfus85/YWDz4UZMUba9BxzL50ImEl
	EeDiAkxF16pbsVWWQ5X6sPCMn9zKu2KR6yPHhtnQ69zhPXy14npL3PDFfn+VCOPj8zEWYv
	tnegR14Gf1TX0+jOD/0riAWR2I3vdJo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iStf9NT4;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774023632; a=rsa-sha256;
	cv=none;
	b=4/Tpr7Ddrv+UknLqdD2sCb+fqnIf61rUvaCU1jC3FTpCicHv2P26Duf5l7eQs+SYogD7An
	IfxUehP6Ss9NrYOSrymOmVTYutpSZRh4NcDpm0Xgbq35bHLBOWkrBqtORHFHJ/Ic/q5w2z
	Ses7Ep4yeL9MdZhtYrsmzgkOCBuFfBc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0AA8B40928;
	Fri, 20 Mar 2026 16:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860F3C4CEF7;
	Fri, 20 Mar 2026 16:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774023630;
	bh=f23/cWvuFntyKkPcVW9s0H4JKUGUfEjEqYonI0uUxQE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=iStf9NT4SDcQQaDyNM3BjMWqAwsEPKu1Wy3rOsjOXNraunwPj1d3UKqhUaJKvnww0
	 jN+Bw0bAUglB7UKIH6esRRJ0c9nDZkwCfKGqk5H0EUj/tsAKH8AYgKzlJKh514hgEH
	 SXDRLSWkRzv+Zc+Wh76Q47CaQHilRiadCdaw2P04=
Date: Fri, 20 Mar 2026 09:20:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Donet Tom <donettom@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ritesh Harjani
 <ritesh.list@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Ying Huang
 <huang.ying.caritas@gmail.com>, Juri Lelli <juri.lelli@redhat.com>, Mel
 Gorman <mgorman@suse.de>
Subject: Re: [PATCH] memory tiering: Do not allow promotion if
 NUMA_BALANCING_MEMORY_TIERING is disabled
Message-Id: <20260320092029.7b2e2a9f24bfd5197541223e@linux-foundation.org>
In-Reply-To: <20260320092251.1290207-1-donettom@linux.ibm.com>
References: <20260320092251.1290207-1-donettom@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 635351C0017
X-Rspamd-Server: rspam08
X-Stat-Signature: hdqropupayb6f54kkpq11r1hcwhdzke3
X-HE-Tag: 1774023632-626258
X-HE-Meta: U2FsdGVkX1+U0o/lYzJHhkpA2Djze6sjlhor15df6l9h7GMvrYiMUmS9XJ0PdxyZwzn1+ZXYChVjj/XpLea6wnjzcDDKDcEQbf+fIqTFMrGNB9u+KC8gD5k49pvnZND+kSqndY0vO6JA6TzCOonDeIlZ1HZ4nENsk7ONimI880GCYRXOlGYtQ5mht4x4TPQmJfYhJFdX0vybtUPy7oOfXy1dgl+rDV8HH4N6xrrZ7CQ11YVwlXluMeD/UQbJVsOVl4gbhti28g6E/2Ipo6NRhrf/nYzz/05am3G6HPQOAP3UTH7ojZRETIlhtyymtoPWjWnl1vps8UVKf/x6+sx5MOy9+p+ri9JJTxOX6blv6mt+q3TNUEw0isCnqA2ixI1aIBq0Hp4qpmMcG7hq3LKA7IPJyQQvuSYOwzhFYDbOkdNCU5r1g+2LISWKjgUPJq0hwwhiJS0ZZBqYw+yAPnxqAU6rSQw18PN6fXTJTwjpZntXq5edbFYi1Cj4JQI+UEiOXVXt7KgXyxQTYhctkNMB7gnsvHI6PM5uoXwxCn4Z98+zh/LxKVVy8yHS3kRigmOsmjCgoH9XpI4+UzsKbD85uFnPoigsY3A0iwaxtlxJb+YWv1WMMgCbT4Hk6d1TqNB/XRijISFRNZox4e94zabWgApOLglrY2xdMr9JosZCy71IVZZ5GIykj9O45Jtx51iHgQgxqCxFFloTqvkhPV+WdCqkIqGQHAiAAtQsH82LKBJTn6Y9P0pbElafjecDeRbY6BM4hp1u8h84SJGVnej9L7yT08rhbLRkz+rJNjvaG2eQSBOOXUoA0XnjkTTKgWCkj3AnCO1Qgxv44GHCy8h69VdGV2UOwQS6ns9rC5yv028IMEO61+v8LAAMR8lLtvlrtvCPIW2HPTyusH+6dVJ6QTsGrqrQKZ7h9UmEY/A4xupffd4MFBY+UnsAE0lzWfFSugwym7C6uhLbNfpz1aQ
 ZZvJs+T2
 ymEi14bVv9QQthuO7ggUq6Mr7NaUYe7RD0lM22sJHATFi/dvNTq6dnMfeSIXozJDbobeuxfomVSZG7vPkKaHUktvIYxHV5XuzLJcOndxLq7mvNYo7uCJLe9otYZukwSLiuhaT4QF3wcZU71TsdtoCt9hsQNxLigKxaHIpF/NjEi48K2WVVQenyOI8Bt/RD6y3FHebNup+QCsDLnMlIyMyMFrmVC6Hl1Mj5+FplcBxE++QeKqJmtIHWNmECbr7fVf+UYjFi6i9WwYsi4fHUx9wZHhdiYP6YeT8ZnfG93L4OZhyKPtVs902oJUweYZeraH48l359AkjxMlHtoePn1bXI+9AXuX77hGfNnKAZ9RgBBErEmjYVOOnNXWumj0GwMRfbhr0+KoyFxECB6Dgjmws1Nm1qAlIi6VQhtdoFNH3gWtWRUIuqte0TqZa4ihtmJ7Fv2kW7PjzAxmm280=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 14:52:51 +0530 Donet Tom <donettom@linux.ibm.com> wrote:

> In the current implementation, if NUMA_BALANCING_MEMORY_TIERING is
> disabled and the pages are on the lower tier, the pages may still be
> promoted.
> 
> This happens because task_numa_work() updates the last_cpupid field to
> record the last access time only when NUMA_BALANCING_MEMORY_TIERING is
> enabled and the folio is on the lower tier. If
> NUMA_BALANCING_MEMORY_TIERING is disabled, the last_cpupid field
> retains a valid last CPU id.
> 
> In should_numa_migrate_memory(), the decision checks whether
> NUMA_BALANCING_MEMORY_TIERING is disabled, the folio is on the lower
> tier, and last_cpupid is invalid. However, since last_cpupid remains
> valid when NUMA_BALANCING_MEMORY_TIERING is disabled, the condition
> evaluates to false and migration is allowed.
> 
> This patch prevents promotion when NUMA_BALANCING_MEMORY_TIERING is
> disabled and the folio is on the lower tier.

Thanks.  The AI reviewbot asked some questions:
	https://sashiko.dev/#/patchset/20260320092251.1290207-1-donettom@linux.ibm.com

