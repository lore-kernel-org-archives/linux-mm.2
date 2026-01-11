Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1703AD2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 17:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02A2D6B0088; Sun, 11 Jan 2026 12:48:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00B9B6B0089; Sun, 11 Jan 2026 12:48:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E501D6B008A; Sun, 11 Jan 2026 12:48:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D28536B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 12:48:28 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C7721A0D81
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 17:48:28 +0000 (UTC)
X-FDA: 84320417496.27.CAC39FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7C496C0009
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 17:48:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GhY6az9g;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768153706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YYV4mN0tz0jcz/iwbzR0+lZXCu+hs9CXTSkiFz6ajnk=;
	b=KaUaS9m/54gBKsG+8C0hRBgIVUdfZfh2fV1MeqtWDh4b39uqHkUiZcoE1fR351Tw6Aq30m
	/+rSgnbCNzksqmY/Ob2dzDnP/hsbCkGsC9f4eXkK4tIlYOP50KdkETABL3+iIUWb8QuJJM
	7FC5sjIuGkGuGZUbAkv/lHPTBDjEna8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GhY6az9g;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768153706; a=rsa-sha256;
	cv=none;
	b=QV4287cX4OtGI9278I5g0leGF2j6Uss93GAIsvQm9r+t5O5QrLO0V3N8cNFoeyeypVwDWn
	CwPTP1aXeofHwCAVQBQt0z3ewaSdqMN8mbLXdyLw5C4hrAau66bv9bPUHINkz0On2+8nMK
	MQ1plSt3UUKIVULqrbKAySiufFjAUp0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 204634390B;
	Sun, 11 Jan 2026 17:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CB1C4CEF7;
	Sun, 11 Jan 2026 17:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768153705;
	bh=tAZQO9fZL+JCzR/NPdben4nsIslJaqE+/9xN+WeZAqo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GhY6az9gPT+YHZRlpbbkHcZtCPSU1JiLV2/cEVfjET15oezT62Q8szgpeGZUbhJdR
	 ODZezElIfHzTUWpG4wwCkSvNIq3rZy8dH0Y9Ni2lTWRoR0BlPHtbUC/dedIlRThJx3
	 TRK44p702DI7/hFWTItDmpBmGEMMc7un6OkKqO4Y=
Date: Sun, 11 Jan 2026 09:48:23 -0800
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
 <aboorvad@linux.ibm.com>, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH v12 0/3] mm: Fix OOM killer inaccuracy on large
 many-core systems
Message-Id: <20260111094823.6fcb1fcceb7cfca2dd37b66e@linux-foundation.org>
In-Reply-To: <20260111150249.1222944-1-mathieu.desnoyers@efficios.com>
References: <20260111150249.1222944-1-mathieu.desnoyers@efficios.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7C496C0009
X-Stat-Signature: rbzm51bxatrimr9ia7pboiieddpgpxiw
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768153706-353600
X-HE-Meta: U2FsdGVkX18Qm35bxeExdgqDLfs2ld2ifpNregw/Y50V+JmR0trbKu4CLnv68qCQ9C/TnnYphqBABf5sVtWrFpVzeddjRd1FXEyTYoePJL0pd+/oZ+xEXV8KBe+4Og7wZeR+1WrdOaLskgvzbeXfvTWUYSWpxQHw8D8zUIbTWJdzvK9zSE4rtk1ikmoN7EvgqtZ1lnI1ZPbJPcTeFCVs0Zw/5XF3XG+YcfcZqk5GQ4yw6hv3ypsJF0qhVQhGY027rr/Z+Lj9vQzcDXozdxmKmCD0lFOarx/Ft8kuVD/QCqjMssQpI5duGwLH1t8jy6D2L7AEfTz1n7rZy6TrCo5RJxy1J2qTPSCyfxw5BuXVIvZBAki+AJJX8w6wKq3CxqysPPLqTjxntGshjLYKLTnUjfwFxJtsyjtXXkcP1fdXJf5JugVtO9T5ZwtBs6GmmNlsQKdDqpAFqd3+q5Hpsk1peHauhL2YkiXOcbkPOs6t6pWmWJDX6IPaMG/Nx3RC5SaqfPmZTEWenpRaPQFqMJtDGq4L+QL0L/vtxtPw6KxTMEubpaYfT5pe7ue2+vu3KWfvaC6UAF84moIl+enSrpQ2fIVCwc8PrsnYTYqD0Y5qyqitkIEWS06H0B8hGI0SMu5t7X5GJu/i5Wuiwigc1kfm32qjRAOBC+MIv1XQjZT9cE74QiXdQPU5yhPZtfY44ZiJFLmdv5npGhScQ9Ui+PCzJCHxZ52aWrVWPoL+Stw6uQphCsCpEZhSf3g68D6GbcEDLerKvsXaEmf6hUAb97G2q5fmwYmxDuS4i33C+hIt94WArNxfDZOUb2YW9RaakFEriJLe2XdcUSn5nNee8uoR2UhHy5iFXROl8zK2FuH8mme3dJdleaZNfy2OQf9VnzE/O/qPCKzitD3+bnt2Zk+pFkNXqZeE12Nih+xSG2zX/3gqwSorWtQeL6ELABwGKhMzjzRLUOXW4oyhcqCRvB4
 /uh5d3Od
 b0LQKZE1AXUNB5/EIayGdXCmpzddGB0+mlaSXMndl+JNAXa8lIuqfI+C/Sp99mQ5GBrnoApDU3YrveaXbkLZ4T7Qllrzs3aJ7xd4e0+X5hKajH2ZAz9Rj1USkZxMh+v8SWplV9MCqjB3ld6OcCL8oFnuTpMNCKOaJ2YiIv+1Weu7BeBWiipmiVG1yPttJ8UeVmedbVhUmVgEnqgWrSFChoT8+QmGeeEVJso6/lykhtTAgm8oarpIJZ+TCXX3NFrQj/jnuY+jl78+jm91ExnDLhgIlQCusurHVonOL5mSvFKZlQf3v3Ikep7LIGGC6iVj8Qmdai1PRYiuub4vAxWJEoCwQqpS0BvlVDSF9mrWocv/7G9/W9iQuaAHK0a/0wwmVx/3c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 11 Jan 2026 10:02:46 -0500 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Introduce hierarchical per-cpu counters and use them for RSS tracking to
> fix the per-mm RSS tracking which has become too inaccurate for OOM
> killer purposes on large many-core systems.

Great, thanks.

> Notable changes for v12:
> 
> - Reduce per-CPU counters memory allocation size to sizeof long
>   (fixing mixup with sizeof intermediate cache line aligned items).
> - Use "long" counters types rather than "int".
> - get_mm_counter_sum() returns a precise sum.
> - Introduce and use functions to calculate the min/max possible precise
>   sum values associated with an approximate sum.

May I ask, as an early adopter, what is your overall impression of
the Gemini reviewbot?

