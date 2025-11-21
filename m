Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F188CFC29A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 18:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DE2A6B002E; Fri, 21 Nov 2025 13:30:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98DB76B008C; Fri, 21 Nov 2025 13:30:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C9C6B0092; Fri, 21 Nov 2025 13:30:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 706586B002E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:30:54 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24F47C06D1
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:30:54 +0000 (UTC)
X-FDA: 84135455628.25.1C1820B
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf06.hostedemail.com (Postfix) with ESMTP id 70CBF180019
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:30:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b="tJF/sIc/";
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf06.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763749852; a=rsa-sha256;
	cv=none;
	b=iZq1k5io5wj6tAqnQX66H4V4quX7FmDqsiHXCxJiu3u/d71f+AlRzoG0wCufS2a1VxGxzj
	cb+YiCDy2Bssy0yqgrZtf+D0lcphwXRSatWd0NlBMBs4wKQr2Q1r/TtSw2xmcCvEki/m22
	+ZRuWuEEQSUuMnccVnzI4+HflXwIYds=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b="tJF/sIc/";
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf06.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763749852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jWslEPu1h+kwOX+YdsgP+InMHvzad4h5A0TecdWZjCI=;
	b=u/Sh2GzFA953IHqsnb3iUjC/a6AF7r8LJuNgU55kUTkbtHHwjcwqF8sY2rsFfuYvZ6sc9Q
	dh4BH264qe5hAPqAfILTTn0UmxruvC1bdRsGTbQGCStm2u6FoTM1QJ+opwgmq1jKTS/npD
	M99zMx1uy8KivzXXvpzlH+0agPuKxd4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1763749851;
	bh=jWslEPu1h+kwOX+YdsgP+InMHvzad4h5A0TecdWZjCI=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=tJF/sIc/EnfMzSu+amtP0YEIwtKbY9i/YPE5RHldGP3WzOuUGkOgNn3ZrQxRVC1kn
	 Hop2ettJhJjzv0M8nw5QrrHRo6jY587iX78MZxEcWLr2ARUawoQvtk5ChjQ4al40UE
	 pSnQbJevEBvXKCuEiU/2n8lRuRMrjBZppPH3aB84=
Received: by gentwo.org (Postfix, from userid 1003)
	id 1D331402BA; Fri, 21 Nov 2025 10:30:51 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 19BFE402B9;
	Fri, 21 Nov 2025 10:30:51 -0800 (PST)
Date: Fri, 21 Nov 2025 10:30:51 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
    linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>, 
    Steven Rostedt <rostedt@goodmis.org>, 
    Masami Hiramatsu <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
    Tejun Heo <tj@kernel.org>, Martin Liu <liumartin@google.com>, 
    David Rientjes <rientjes@google.com>, christian.koenig@amd.com, 
    Shakeel Butt <shakeel.butt@linux.dev>, SeongJae Park <sj@kernel.org>, 
    Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
    Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, 
    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    "Liam R . Howlett" <liam.howlett@oracle.com>, 
    Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@suse.cz>, Christian Brauner <brauner@kernel.org>, 
    Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>, 
    Miaohe Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>, 
    linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
    Yu Zhao <yuzhao@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
    Mateusz Guzik <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: Re: [PATCH v9 1/2] lib: Introduce hierarchical per-cpu counters
In-Reply-To: <20251121100308.65b36af9e090a78a66144c6c@linux-foundation.org>
Message-ID: <97a15b05-d61c-0035-82b7-37ac073c4055@gentwo.org>
References: <20251120210354.1233994-1-mathieu.desnoyers@efficios.com> <20251120210354.1233994-2-mathieu.desnoyers@efficios.com> <20251121100308.65b36af9e090a78a66144c6c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 70CBF180019
X-Stat-Signature: edwzcwz7um6yqng89ftremryf51mqckk
X-HE-Tag: 1763749852-298466
X-HE-Meta: U2FsdGVkX189ivUBLJDp4nS1ibA5ZUZ7PiHo7XNkD36lUAs+gJpH4zhGxFSaXOc/OYPHGo85qKisdladHabA86qE2otW200v1cYIIh9UI4hYZ4TqG89UaL/BUvLu+AcLGvbPHHVNB5Ddm8gZfIAdMFOEI0y/4xvkEixjeTOjOcxphyUS9m4MmmUA4Fa2Javpdrx3MCNed08LLKSEvCQFnwxBTHPvKPkJU7tDQsuO010RAxslo/7+QLEaiiezQEwoQv+f3Fl++gUrqvMETGEDTAaljCpAvyjq+DTByBqkz1ywrJNWpAg6uJ8If/fHv+os/n4Lp/Fo72fcBmT5GW3kTYjSwv8UVPf5eRT1natZbQpy1MA6pR+68em2ZmLHByQrw0EFIcW7lo7ym7Rwn1iCHCbzL/6clHUTC56exStdCQ1RCbFShlsQEqqXbIlwPEeJaJpt3/wwBqQguU50epIOr4w5latkgUxFR+7zQ14Oah8Q/wTI6RyRbThyRMuU4BAbYXGOfltsuHXTsLIi1os4JEI1l888VqMUtU2L24GoiXHtOy4p84zI0y5NTrqxS0l3Ng721S8np/ar3B9VknbIKV/XX6lvLF+0wzzWwLcxiLxpwUbD4dAUETw4eBTZJ/Y8mZ5HPoRXclOXA4nDJAe64y8coQS7FF5qMqkgNkR0hhb7gEI9t/M470Gt1vHetICcwu2Xuje/p6jo3/MI3jY1Nlcf0tjHhPSYTbWvCzIWLBD+7WiYhpOiCE3L4nR+bdBnpOTAV3BV6BqMWYg/y2zFW0YmfB/L2jVX8eukDN/RzXrDaWx/U18QSlk8GuyYXDv30psijRhfeLONmnwHLTHsTbfz6jgfEzhber5sTQqNqbmHbrgqQfcZhCm0+ZDrJ8CQYXZAUZQGPfDglk28ia68Ll7frFGTaknrs7TOoNc7u4nuJWIwrmxWH0FQUqNvaHOY4dz4UWPbFraUcgO6NF7
 HUX5A4Xs
 eGJBm0+uWwcy0n1QWspa7uZYhE5VawcHoJkgzZAbdGJtXZenZNeBRmF2mttxV6Cqo4xhVVwWPNhMysftFsljf+FOZIcVxla7nHwXBLTLmtF2L5XrFO672Vlw9Gn0x/0dIHsdo16ys6vsO9RXop5qCoFG6YoqKRsGGDvogG6WjoP0C3M6xzQpAbIoenGQ32pUYnSOtYO1/ApxsTWGb31L1ibrzYVkhP5SIcmcNRlO33G3Fpo71pdcacU0Qi7gh8s1yOjvnBGirS7FHneegMIFRzVQjKrIj6qn6lTC3UTwvBzQuOdrjBlZSdc5x87Q+0qqoCVlc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Nov 2025, Andrew Morton wrote:

> Have you identified other parts of the kernel which could use this?

We need to compare this with the ZVC counters used for the vm statistics.
Maybe this is better and we can scale counters easier in the VM.

ZVCs were designed for systems with a large number of NUMA nodes and a
handful of processors in each of those. What we have today is large number
of processors in one socket (my employer is shooting high on that level).

Hierachical counters may be better in that scenario. Maybe we can call
them HVC (Hierachical VM Counters). ;-) )



