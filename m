Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56EC8D30CDB
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 01:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCB5D6B0088; Tue, 13 Jan 2026 20:35:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78916B0089; Tue, 13 Jan 2026 20:35:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAF6B6B008A; Tue, 13 Jan 2026 20:35:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 998696B0088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:35:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3EB5A8B4B6
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:35:38 +0000 (UTC)
X-FDA: 84328852356.07.FB9E57E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6AC84C000D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:35:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WFWinnB3;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768354536; a=rsa-sha256;
	cv=none;
	b=r8qtfQ9f73Sj6m2AwOErUe3W6hMnzSSTJgwdWW+3rIj08dVs/jzITXakiWq7+xHDnqA/IP
	wGku08jMELyuL5POab1KCh5J5SntLJvukDgsqY7DDBkg2ZHXSHFJBVZoaxJPSkldnoo9mz
	Am2oLgPglgMk8N2UOAC01JRPZWoIKSg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WFWinnB3;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768354536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FdyM0oWBb3pKJjjD3/cR/PITyvJA7klJSjx4xHk+P/8=;
	b=TIoFMgxCThZjHxTZpSeoryRAU8EQQjjDnw07iR49HVdZ1fmLAGEnAydERKMqYMVYDiCfDt
	zWvywqkIdj5RzU/I7SKA2eoZS+t83YVS486R/eTTqxDSX9A7SSyV9X15lAh1dxxDv0RqnM
	6FaWgaqDXXnwRSWMOe+womGJJf6W5lI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 042C54360C;
	Wed, 14 Jan 2026 01:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68ADC116C6;
	Wed, 14 Jan 2026 01:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768354534;
	bh=6qALRjnUz1ToVYlX9uZ6rJccj/CbX4YXQwA1PWOPaaw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WFWinnB350Gh+ZI0sjON+AkppzMI0aB6KQLZA9feNZIiAHT/+LubVU1LrZA37J23X
	 cQZuJtW+NS4T/g7a4HJCKBxYSPJsaPzGO7XmOwtVTchOf0Dn/7ztycXSE+cMdw+Q81
	 wyfkoQ0v7Zk0vRCzU3NQ3xqTqxAq+7jBXMDO4Lts=
Date: Tue, 13 Jan 2026 17:35:33 -0800
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
 linux-mm@kvack.org, stable@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>, Roman
 Gushchin <roman.gushchin@linux.dev>, Mateusz Guzik <mjguzik@gmail.com>,
 Matthew Wilcox <willy@infradead.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: Re: [PATCH v1 1/1] mm: Fix OOM killer and proc stats inaccuracy on
 large many-core systems
Message-Id: <20260113173533.171248b2f6c11c536e4fc65a@linux-foundation.org>
In-Reply-To: <162c241c-8dd9-4700-a538-0a308de2de8d@efficios.com>
References: <20260113194734.28983-1-mathieu.desnoyers@efficios.com>
	<20260113194734.28983-2-mathieu.desnoyers@efficios.com>
	<20260113134644.9030ba1504b8ea41ec91a3be@linux-foundation.org>
	<c5d48b86-6b8e-4695-bbfa-a308d59eba52@efficios.com>
	<20260113155541.1da4b93e2acbb2b4f2cda758@linux-foundation.org>
	<162c241c-8dd9-4700-a538-0a308de2de8d@efficios.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6AC84C000D
X-Rspamd-Server: rspam06
X-Stat-Signature: indk119jpdyo7r5ou3akupn3mwdyqqpr
X-Rspam-User: 
X-HE-Tag: 1768354536-913948
X-HE-Meta: U2FsdGVkX18VILicP8e39QABypEU87pJUs9ejCDZn5Scvhsd04r5F4lJOH6FSHvUE1C9XcewnH1IAXhk0vDAwe1y0ehdXd6B8fNQxv4FTXtqwBze8C5h+mnnM2nOYx8ChDWNWgaIfTgFdquunsHqLm/511CB8bslsIFz8mAmJwifNRKF6nhxpm7Gvq3uD39znimyqgRblqjt4AA/9StN2bcmBIv45wSKETrrpfRAMKekd1boKKeTDTJjKq1/hNkEyvz9Jq23DCYqlDLa7K+1r/q5tJlEjOj7+6/8Wy+/VCCgQNvvnRr02TZQJf1b4jJW/m9KDfX6jLZ8x2l39tp8WQaTBvdt24NfXVW1W9rr5IXvobPZEX0CbShOlTu8c4XVKB98P237gpKkx4hTUB8YOG2Sh6eV4PJfI1wgTr33YMgh75IGiCDQUTpb91aJXBI72fKB9ClY57x/JIzWMXu+dS/FVr0sy5NtClY/s4W8qbohN/8kgfl3J77PNKD+jDKJZm7rpHI5xRcRn8thSwMtKIdAZheG0ksX2Y31whiI2nttRk7OLgK8glD54OJIldwuRIY5hlgvozjdPZ0cdQDEWnPoMdScsUt00Kt0nW8riZ2s0aYCNNhf8KUuAYxVcJLoKSgRUsm7qjF+qjUAoTRk6VaUEs9GA1W+Qp6dDqEV9JSAILN13Pkdy7SNF8lK7dxLVtJA0nAnHRDXjBzE0CI+/cPgM+jGRjxf4WRGEfK4Xe6dhNN/kxvown8XeSANSWSGF44/VgNTS8mgp/DRz3DxXfGKxZosME2QVL2zhkhP+KaRyH99Wy1iBDEeh45sYa1IyoeegqYXBZRxcwWCuQew5EKsSKJnP+Te9xtEWZNcxNx3kiviRyEa1uDJW9pvPyrPt4Iogzow/uPqmEM+KzFz/rCeYktZU/xCLw7zp5voU73KPDreiEBAZgukp4I+0IVkdmmsv/imAIfwoMLfrLC
 UsyE7qgS
 Yt/1f6QR96rhw70gLt5F9MvzL9O4g0HKgo4ZlxPNCnsLoWugufA42uwS6MBqmSv+Wjssitkq7TbSEuSzBdy6DrLEVlrIHh21bzvfh/OdaBI/y3c+bjGvaRT5ddwBjHB3lTZivW8HAPV844eqGitarLSJWYSj993Sf270i5aG+Rzprk27sGUpY3TIVeCi3IJWbhBkkqi4BcFm3aVmRjg128aNnkt0LFWhU0RJ3Y2uAuMXpwvywdhexQtUPxiPdM3piB6OZ7KkJqkGMk1HJE4gJEq6zWUwvIKh7DdrkXyiGPvwhm6FfNhipZs/QABSXcT0tUGWyeCoNAKI9NsocTTh7DQDOJLqnQCURFCOpmRg0jSMtNg1ZxLe5Xkb7oG2U6FKtOUBF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Jan 2026 20:22:16 -0500 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> On 2026-01-13 18:55, Andrew Morton wrote:
> > On Tue, 13 Jan 2026 17:16:16 -0500 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > 
> >> The hpcc series introduces an approximation which provides accuracy
> >> limits on the approximation that make the result is still somewhat
> >> meaninful on large many core systems.
> > 
> > Can we leave the non-oom related parts of procfs as-is for now, then
> > migrate them over to hpcc when that is available?  Safer that way.
> 
> Of course.
> 
> So AFAIU the plan is:
> 
> 1) update the oom accuracy fix to only use the precise sum for
>     the oom killer, no changes to procfs ABIs. This targets mm-new.
> 
> 2) update the hpcc series to base them on top of the new fix from (1).
>     Update their commit messages to indicate that they bring accuracy
>     improvements to the procfs ABI on large many-core systems, as well as
>     latency improvements to the oom killer. This will target upstreaming
>     after the next merge window, but I will still post it soon to gather
>     feedback.
> 
> Does that plan look OK ?

Perfect, thanks.  Except there is no "(1)".  We shall survive ;)

