Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77C31C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 18:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F37C46B007B; Wed,  5 Aug 2026 14:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE86D6B0088; Wed,  5 Aug 2026 14:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD8D26B008A; Wed,  5 Aug 2026 14:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B62826B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:57:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33EC1A05B9
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 18:57:43 +0000 (UTC)
X-FDA: 85068124806.16.E3EB804
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6E632180003
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 18:57:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2nnF1amx;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785956261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nwDyT6ioXBOR7f8LHhLyMZ6+J9mboOWecw3DNF5ZsB0=;
	b=vGZqbYZz9Rq0C8iRZuDs9Zvr6YrffcSR74XoWm2UDVf92Lpu3gHMo04eY5CDC0YWVqKTWn
	XT2oW0sOTvjQTS/seKYJp5QYW+Tvs+3IYYEQnCOaKD8qesuHkAEb8g0wq7epmb+qdvt/1F
	L+l3pTaXOAmtKjOD40pIrGaOmmP1Q98=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2nnF1amx;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785956261;
	b=FKq5gMEmMa0jl/0+uGqL9efez+iEkOg7XpJODwmFlnQEGagi7G7Y7Xq2K3F86LHCx8a/NN
	psptnv7p2EhO7jlbN2kqZWrGlIL4lN2Az/vo1reNEoWKPEY6kz4SZO+yUJjks4iO1ZETzJ
	ZbfOr3Naf6xwv4JYjhhkmAueH+kcjLg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E04BF600FF;
	Wed,  5 Aug 2026 18:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826E81F000E9;
	Wed,  5 Aug 2026 18:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785956259;
	bh=nwDyT6ioXBOR7f8LHhLyMZ6+J9mboOWecw3DNF5ZsB0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=2nnF1amxXdN96IjG9P7CLTo8eOvU6Zc75DfdV/NaRRCRmlqbSIotrwMt6dBt0ASNR
	 KByGDFxqQozPe1YghAu4OErL9F70hb9bYYyGU0TyEhB+PbqAgb+ZMt40tZqZpX0qQa
	 wukuXB21ETSCBFvnYk/Z/nyzSCwiL7CcPQEEpULQ=
Date: Wed, 5 Aug 2026 11:57:38 -0700
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
 "Liam R . Howlett" <liam.howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka
 <vbabka@suse.cz>, Christian Brauner <brauner@kernel.org>, Wei Yang
 <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>, Miaohe
 Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>, Yu Zhao
 <yuzhao@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Mateusz
 Guzik <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Aboorva Devarajan
 <aboorvad@linux.ibm.com>, David Carlier <devnexen@gmail.com>, Josh Law
 <objecting@objecting.org>, Lorenzo Stoakes <ljs@kernel.org>, linux-mm
 <linux-mm@kvack.org>
Subject: Re: [PATCH v20 0/6] Hierarchical Percpu Counters for RSS
Message-Id: <20260805115738.5d74e7f41c6f02cc5fd4791e@linux-foundation.org>
In-Reply-To: <10ca9ff9-428f-49c0-92af-698fd5bea3a3@efficios.com>
References: <20260707131544.75906-1-mathieu.desnoyers@efficios.com>
	<0d454717-be7c-47c3-bd5e-2ad304c3423e@efficios.com>
	<10ca9ff9-428f-49c0-92af-698fd5bea3a3@efficios.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6E632180003
X-Stat-Signature: zmni7awxz8jk9nhcdjw6xrxjhiuicgjo
X-Rspam-User: 
X-HE-Tag: 1785956261-637545
X-HE-Meta: U2FsdGVkX19az0aPrJqD6T6ilZO+aflo6yaMJFs1XtHVQ0/6eT03+HDuDGEkoOMYBwWs3U+Dv0pcLUs6EJbafMza1BNKtWC2w96SZ0ENHqzq0b1FcDQojhrRYJ/GDdd9UA+qneELHvbblE9Jf7Neq/BF+UqTAB8wPWnypHk8MoDsMvCW+sSNSNXWNjxipoPMf3xTUx7mTUtU7gd7j2cB6mOtXsK42ddZyCPaSTwVEr+BN+2ErmPTKnWeVh+lzqSJsamrsBzlc6lE35NO+TPblY9Y2tomgCYbpl5vXFPkiwnWbOHtGCiNfqg47gGHP0CzrniU/0ZQTCuuJKJy85AQ9CTsl/HvUOKLFrFhr6fS0Fy/OFo0mlTRXcEhJZNTOxV6QT5S+QK0zjo1Puod5Fynpvm0B98W9ETuA9hiTSTeuaSM8L4G9oU3NiFvmlCRwTaAvDY4nqstWqTd5UKxJUf30APR7/o7D4oyyxpl3ulTUmzXL7a3laH6FNkp/nilh1ln9LmrmOOx65+JYKhayJo9z8alF8trTWpVALLszSAt/pF3Bq9KKPqj5jY2oN46uGyHicT+P3aUPnioHEtWx9joy4JTwwz8k8dPIAxh8xIGHlXHnZ13LWCbEdQzSK/lHLh0TKPyWUfytUYylCjM5CvoUgqBvU35l0JJlBxVLfgb+Dlj+AIidEg609MKiSygUqAdJdjYinzNONZ+Mzk9qOKTjP/XzmYfmK8+2FvHdXhLSE2nQmK8As13nmZES5+rr5iEQJz+NQiBIUQgZeNkoiXSDRCwtK6N8jg6sX2Gy4hikc8WSb14/NuFKa7lzmzqds/JxpgfF2z9FjhnNCG7NyrsJXNWw6ilQPPDxJk6ltx7uRdOE4YwXhTyOyuxsjF9l0o1Pt/LTu6iUMhTIkJvLyDYNKIP/bgrnowQi33UIJ0JrDTdS7zb5WF56+C238KclYpGyusurxDdbcvM4LJWyOf
 kQvHYp+h
 ueSnAl/NknXFyIIVK7KDZ73N6Z/R8ujl/P0NF8uDZEVqNgBaMipzPmPC78WpWa+x8OXdkrd8UQTL+q4TrajU1mM5+6C7Gw85LRcSthJ+3Cu5Ba+IzdVN1uh73E5Y0HprG3bRuKbbgRqPjAGwXm6NR67MKYN6JPKjUwQF6zGdyiFqTROfhOFUjNNJcOoWa5JSO532OziAnBlVftZ6Dbf3Hf7k5jaxQRX8n+4SG3wWrp3P56HmQpfAFMI/Pd8lrH0HI0fE7DtHD0qdgSUE+vSnbRag3OqhoApd1FuIOPQBn7faxbxEIumKXH5BebkqZvT2qpWSAXkaGSkAnR/MFKtDbGQ0yZ40nbS25O900DDO/8MhhN5LeqZcuvrvkYfk3a0MB69RR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 5 Aug 2026 14:37:08 -0400 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> On 2026-07-23 13:53, Mathieu Desnoyers wrote:
> > On 2026-07-07 09:15, Mathieu Desnoyers wrote:
> >> Hi Andrew,
> >>
> >> Here is the hierarchical percpu counters series rebased on top of
> >> v7.2-rc2. It includes small bootup fixes which were needed to fix
> >> bootup sequence on specific architectures, and a rename of the
> >> test config option to include "KUNIT_".
> >>
> >> This aims at replacing the prior version of the series you had
> >> in mm.
> >>
> >> As a reminder, the goal here is to provide more precise RSS counters
> >> through /proc.
> > 
> > Hello,
> > 
> > Just a gentle ping for feedback whenever it's convenient.
> 
> Hi Andrew,
> 
> Can you pick this up after the upcoming merge window ?

Resending after -rc1 would be appropriate.

> That's of course assuming this is solving an issue which is
> still relevant.
> 
> If there is no interest in solving this issue anymore, kindly
> let me know and I'll drop this series.

This was 1000-2000 patches ago so I've forgotten what the issue was!
Please ensure that changelogging describes the issue in glorious
detail and I'm sure it'll all come back.


