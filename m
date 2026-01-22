Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB0F8D6CFA4
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 20:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA64A6B0351; Thu, 22 Jan 2026 15:55:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7E5E6B0352; Thu, 22 Jan 2026 15:55:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB4756B0353; Thu, 22 Jan 2026 15:55:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B7D566B0351
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:55:28 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F4EE1B26C0
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 20:55:28 +0000 (UTC)
X-FDA: 84360805536.07.E0EC7DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id AD8EDA000A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 20:55:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=orX3vY6N;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769115326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LULGFeZjlgBPSOJxDppBholYYPZ8XPdbGJ2ezvS+Mgg=;
	b=TuLPxqlsEG7ZX9UkYImDTqoDxP/Qh1g8Xx0xXerAH+Hhq3ZCBgH/lFGjAgkGGE/NIl4OuE
	3Iu8mxF9v9UgMjmNWlQ5Nq28q50+WlhMcLn1pUCURmWpJF37Pjn288EC0VIUhb8+jAJZAC
	RuNSEuBQYhi+tv0gPVcBzh1/6+8Od/o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=orX3vY6N;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769115326; a=rsa-sha256;
	cv=none;
	b=2zdruFBKG6/8ujy4+kV8j/mRnIzSu53TBWZDUIu8iddtlq9IDmG4XpteA+oht+WLwbTJVk
	O16Iz5mUXSFj9DvdMiOhFA5fO7j2TZpUpvUQQlU3iIUqHPhn4LqsqddKBVoj9MSFue5fN/
	D5MfKgOUfzHsuJz9cqq/UPjn4FzriYE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 19BEB6014A;
	Thu, 22 Jan 2026 20:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EE2C116C6;
	Thu, 22 Jan 2026 20:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769115325;
	bh=3RonE8sCwdveY09Rm5eaaBB5Ddd2WM38NcpvZaK6rFI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=orX3vY6N+v2bBEqJf/x3rBu+MQkrbKH76zrEvIeO/Ltd+mJYqg+/KAwuVnrgGQyjy
	 sErY3D3bSldRFWNzww9AlX2XJ+MDHT0VA5lGqETZEIxkdkDCUeHo+MGL3SB67con2U
	 9FEV4KOcq6NEqSw801uDKbVTutkHYIYCWpzetXqQ=
Date: Thu, 22 Jan 2026 12:55:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Hildenbrand
 <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil
 Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Michal Hocko
 <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn
 <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>, Ingo
 Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng
 <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>, Sebastian Andrzej
 Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 06/10] mm/vma: clean up __vma_enter/exit_locked()
Message-Id: <20260122125529.1f4a1806fd918155e0a5824b@linux-foundation.org>
In-Reply-To: <CAJuCfpFFW_tcHPMtryoVcSKigEGZxfn3Bz=8BUtrJj8kgEWDJA@mail.gmail.com>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
	<f1981963e3c9421b6ffef19f15d87953895cd0b5.1769086312.git.lorenzo.stoakes@oracle.com>
	<CAJuCfpFFW_tcHPMtryoVcSKigEGZxfn3Bz=8BUtrJj8kgEWDJA@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 383f93ooey9r4km9aex356f59cu3bwfb
X-Rspamd-Queue-Id: AD8EDA000A
X-Rspam-User: 
X-HE-Tag: 1769115326-352234
X-HE-Meta: U2FsdGVkX19/RCDj8RW5OtVS1kkfcOqjJMftANahmug14cYdWkimtiKm4uPWYhpnk3hRnmUxUUH1A8w6tq8bvxcIXefBD8ZWTE8TBSaWJrZTit/BjN1zLT61AQ8IOm61xKomhS3Mlj5GyPw9fHLq9s6EAVR5qb9cSgC9pdQo20lYCDQb7PiGOTgiaveVOpF/O/eRCXoiZH3wnk3ttWo48tFf7MEhCRmahtqHJDGCSDP7zuT7iyXLlGFrQu4Zc70BlQoFvVJohbgQMmNpBJdQv1AydCstkSyQEd3E3FaQHMe9klxmROT+Q9P1hZ6qp1NOb5ugD9XN6nxuRujEUf2kVFKtThwaIZpEsg7FDdqOoNGRv0tw+eqYenj0yqhqFVw458ntr/LMQ3JPio2nbyAEougavvNOSsEH2sxHgNncI7D4OGKvQrH8BNTIeWIV5UDaUYzxcO7SQtI7Ched0yv9trQkiHfb4bjY5rII9W4rbOhT0lqCf6T3DiqNopu+sl2sCKRy+SXMAVFRjs6xhavaskwKckFDDhM+M6hQGk1QZpz8XSyL02HQb0ck9SpofwyLu62XSDkEoU6kL258yz77wDbyaV0uhEwpCG2UvYkS+im+z+cv/fjeHJFKZSahUf48NQO+5k9kV7XlNlQAi51YeFoQcBztwawkR61IZQ1Kg9B4WY64/HyfSaLl3QZYrijGlJzlU+qCVZNSYqURFkN4o27Hngl1Gai0puhaPUGxkqeEwNy+caOeMyfyJNK4ZLb4f7QdFOizXI8hWESbZBLMX4DiU7TdEvn2fcz8FGkAYrTtJiplZxQ8ZlDL+PY8bspSQiZGPjG6kTdp3uOHBcQaNgtyuGGldl3uVyE3ZYTCj+3RXiBJUkrIekwlZq5g4Wnum265ggP91fk7fh/BUfI7Jl8djn4XqSkiV8cNOk+8TR20/hzw8p3lG0rQBF2ouU6MbmoYGdKBj/FoOS/uQ+8
 Yzcqnpf2
 0SSrcjxfciUaIrvgcewKT5R88rcsL1yCF1k1vq2IL5R/JRw0LYizJPCcx3SS2cJEAXvIrjA6zo2Upo2GGtg8unGq0dw9ma5Fj2ncodJ4+LaLEg2CsVkUX0ak5ITP8OX8A1N/R1K/AmXOG3yUb5EUBumR2utGwjpuW2BzRh6giA5lrQ48o+PERo8kIZktjVEcgexfPuxHGjdxheKt2rzMG3DWtXFmuzf2ZZuNCro82ozC9+Issg4St74vG5R/fG4Awjzy3yy0oFzhat5a4lzrLE1rDArc8MWZwM9r4pnk+VoalrNoJN9Y8zITKm95GmRXa7M1GDlw0BzULqFKi28nqV8YL3WZ7wCISMhZ7Ln3rZgMiYXAxMYq4v9FR1XRYqamca697e/DOpNPcVNI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 12:15:20 -0800 Suren Baghdasaryan <surenb@google.com> wrote:

> > +       /* vma should remain attached. */
> > +       if (locked)
> > +               WARN_ON_ONCE(__vma_exit_exclusive_locked(vma));
> 
> I'm wary of calling functions from WARN_ON_ONCE() statements. If
> someone decides to replace WARN_ON_ONCE() with VM_WARN_ON_ONCE(), the
> call will disappear when CONFIG_DEBUG_VM=n. Maybe I'm being paranoid
> but it's because I have been bitten by that before...

Yes please.  The elision is desirable if the function has no side-effects, but
__vma_exit_exclusive_locked() changes stuff.

Someone(tm) should check for this.  A pathetically partial grep turns
up plenty of things:

mm/slab_common.c:	if (head && !WARN_ON_ONCE(!poll_state_synchronize_rcu_full(&head_gp_snap)))
mm/slab_common.c:	if (!WARN_ON_ONCE(!poll_state_synchronize_rcu_full(&bnode->gp_snap))) {
mm/page-writeback.c:		WARN_ON_ONCE(atomic_long_add_return(delta,
mm/page_isolation.c:		WARN_ON_ONCE(!pageblock_unisolate_and_move_free_pages(zone, page));
mm/page_alloc.c:	VM_WARN_ONCE(get_pageblock_isolate(page),
mm/numa_memblks.c:	WARN_ON(memblock_clear_hotplug(0, max_addr));
mm/numa_memblks.c:	WARN_ON(memblock_set_node(0, max_addr, &memblock.memory, NUMA_NO_NODE));
mm/numa_memblks.c:	WARN_ON(memblock_set_node(0, max_addr, &memblock.reserved,
mm/zsmalloc.c:		WARN_ON(!zpdesc_trylock(zpdesc));


