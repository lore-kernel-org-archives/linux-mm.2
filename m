Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F5DFCFD2E3
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 19:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46DD56B0011; Sat, 22 Nov 2025 14:13:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41E886B0012; Sat, 22 Nov 2025 14:13:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3346F6B0022; Sat, 22 Nov 2025 14:13:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 22CB46B0011
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:13:43 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3353BC510
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 19:13:42 +0000 (UTC)
X-FDA: 84139192284.04.0C9AA97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3B39040017
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 19:13:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=czXNTPSq;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763838820; a=rsa-sha256;
	cv=none;
	b=beRHM4QbFgknEA7vw+B3wdQbGnM8H+AG1ph9Urr+/7s1YNKClpxu1m2pL+L0E2SKpUwn1F
	PyWl0GhsAnCHrPCaoPl5SH2BdjxFeQ7B31pY/BQ+TfDDJjLo4ok3eU4jkUPQsvxltjCO3N
	qveWpG4aGs6gruqQIVp1oDKeU1e6aBE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=czXNTPSq;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763838820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6DyFJlH3kbPj/drw9emLsQE9ftRsZmkxnTEweOh8NOg=;
	b=XhEbWhMW7d4nUbeumphFmQn0UFshII6roVoao01h71zFpACAkVkmc2YOW2aIXP4tLOFeAG
	A7kvRvNSVmAFqoNBQx9bXo9cMLA0vB2ns5JlxTSRB7rAPvK0iYZPuCQQaeI5HRqpMuKfZw
	4CPCjDbtKboE4Wbg7fbXe/xVMelsV2w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B067240431;
	Sat, 22 Nov 2025 19:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ECA5C4CEF5;
	Sat, 22 Nov 2025 19:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763838818;
	bh=P+IvViypdqWTsu2iUchRRO/BOZ/npDCJSLzUqKJBHTY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=czXNTPSqe45T71X7q+uZSl5WU7lNGQWLBNpMccvRrHs0Y/LVEHxdhDD9iqtEykBhl
	 S9ry1g9ioR5zeZj8Kj2L8MOBEe2j9ADEXH1F7e15xF4yNSKj2LrXKXzERmc+OVHfuF
	 ftYbqquy5hDcL/KFxtpqhnM+5seZdfENlIP0Dlao=
Date: Sat, 22 Nov 2025 11:13:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo
 <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Martin Liu
 <liumartin@google.com>, David Rientjes <rientjes@google.com>,
 christian.koenig@amd.com, Shakeel Butt <shakeel.butt@linux.dev>, SeongJae
 Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett"
 <liam.howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Christian Brauner <brauner@kernel.org>, Wei Yang
 <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>, Miaohe
 Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, Yu Zhao
 <yuzhao@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Mateusz
 Guzik <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Aboorva Devarajan
 <aboorvad@linux.ibm.com>
Subject: Re: [PATCH v9 1/2] lib: Introduce hierarchical per-cpu counters
Message-Id: <20251122111336.56b060c86ff6ba41fe76bfd4@linux-foundation.org>
In-Reply-To: <a3652f6b-cd3b-45ad-a3ad-e92369cf4068@efficios.com>
References: <20251120210354.1233994-1-mathieu.desnoyers@efficios.com>
	<20251120210354.1233994-2-mathieu.desnoyers@efficios.com>
	<20251121100308.65b36af9e090a78a66144c6c@linux-foundation.org>
	<a3652f6b-cd3b-45ad-a3ad-e92369cf4068@efficios.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3B39040017
X-Stat-Signature: g8orcw5dcciqxzgkz8b1krg665i3q31r
X-Rspam-User: 
X-HE-Tag: 1763838820-302590
X-HE-Meta: U2FsdGVkX1/CgzR0TVt6nLRKn0Bzl/WsO470t1Y/IMscILCa4kG/0eeuOU2SG4c/wI+HW/z/jgSAiobCl7lJWOHRB43TEyl7J1cAJLQhR2MYswGXPlPKS8WDsW5eXjaUnFec6SRtlGZQPnCyGT75a378XKY0uXSUdGscDocLUvcpALDvIjwvRG1nUuJAsUg6no/cy6axq1/ZWum5cFomTnWvtjLVjoKJfX2YWum6aBNuRLdvp7GvZvTi5LwBbO3uqTabci/8NHc253aP4Ie9xUsWTVIgZexyziV02znbU0kNy1mEVlt4YDA5qmsFXv5HCQHGIQs3vQvHLFR96q/xgYS8jHIg0UAD2sdCKBtTmO10JeffOs6g7uq1wDKhWGuNwpCnjdsSsS7+2JNPF3b/rzUNscnGb2BcWuC/TZN4PtEt4dWJ2wWQsEuQxiNBQ+/lLm9JOH3BfBomIhsSNh87ctIwJIWcuJz4HNun+CsTkIafXZs4R9xwOp/8cTMmmpDggknKSlVnlms3RR5aYJNimQ8tqBCfdmc8ht2/DkX0caIb60aoy9AJYdooeZ2SAikFyJ8ox/DTOjIIxqIFmjWW+DbW2zNiAP0+qhtUNTrbwefDgLBCsdm3PoMMHpks9tX8ZpX3coulLpYiqN5yXcc//V1VkPVJXLv0K1D6aToc1NrdQ0cWIeFxgxvrFUB1qqhZIwfheZhoi+7upFcL0vvYcTJKThvljQRF6OAInHI3oNVFn44ci+pIDeljOZmgeyhSnTwdgnn3JkItM7MchwHjP9LBvkW7OAQ8ihPzRERl/5EJLvC/9UpFgdjSW1K66mUdyyQV2Ogk2QaejrXHsI4a/eA3Qzo59mgljGX/wsAgTovPpGvOT3sXl/Ur7EdVeRX2DgMdhsvbcNEqVJTkuwGGzRkLSw5B8/UU2NVwH6zVtPr6hFwkYvgerA0dCTh2aXpb2DVnJkzUm2raQvSHX3q
 HL8KV8a5
 fTwW6MSy1lMcnqg3mnDsRZkh6CO9Qq19isjdFK7a2WzjpJOo/tyVUuiVUSOWrVMe+ZaoKWExbTBkhE2SyRcz3ouuxujnQkM4UvXVKcozSDKj99GmPdzY70GPRys7bToZHdUpk9Ln7Jmd0YaLoNXTyn1cJkr77aCOE4HO2TnwzCWQ2fLkHiLw0/V9NHhCqYxpLElUoyRRprMKQz9OV8hnKnn9K/Xhnkzr14H74LmKwAMUh8HYZWazAvExCi2W1fn8xLxJ4vDwwa7Up7ncugpk1PmwgkhOzg+QJ9r8Ri1YiuDXLGk0mqRAryY0PBd1SumujjK/DRrUPAwPWDsOsIczKUPm3pnEFOGCtZnwqMvoYVff0QOu9ouKPIfCQpCCxipdDoMWH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 22 Nov 2025 12:15:02 -0500 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> > 
> >>   include/linux/percpu_counter_tree.h | 239 +++++++++++++++
> >>   init/main.c                         |   2 +
> >>   lib/Makefile                        |   1 +
> >>   lib/percpu_counter_tree.c           | 443 ++++++++++++++++++++++++++++
> >>   4 files changed, 685 insertions(+)
> >>   create mode 100644 include/linux/percpu_counter_tree.h
> >>   create mode 100644 lib/percpu_counter_tree.c
> > 
> > An in-kernel test suite would be great.  Like lib/*test*.c or
> > tools/testing/.
> 
> I'll keep a note to port the tests from my userspace librseq
> percpu counters feature branch to the kernel. I did not do it
> initially because I wanted to see if the overall approach was
> deemed interesting for the kernel.

It deems interesting to me - certainly seems useful in addressing some
nasty problems.

If it hasn't been massacred by reviewers, please poke me in a week or
so and I'll look at giving it some exposure in mm.git's mm-new branch
(which isn't included in linux-next).

