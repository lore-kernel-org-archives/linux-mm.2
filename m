Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7525EA4E21
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DCEC6B0092; Mon,  2 Mar 2026 10:23:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28D0C6B0095; Mon,  2 Mar 2026 10:23:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B9FA6B0096; Mon,  2 Mar 2026 10:23:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA4B6B0092
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:23:04 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3EAD4885C1
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:23:02 +0000 (UTC)
X-FDA: 84501491004.24.510D581
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8F45E40008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:23:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=0XQtejgo;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf17.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772464980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cZrWALVvP/5PCNYa5kN8hhPqzqgPdcu+PQQdFr2xuMA=;
	b=8FjLg/JeYhDvMpUas41aiuwT4TjVlstvuTavk+0kIRgYTP2cuUdUQvilizFZd89RjpfKv4
	G7m6i3kLUpEBDT9jlvC4Zjo8pFqSUdWu8RFDNRYMdz/G5TCTJNGmdlbMTnqjFfgBF0WHY6
	+NDxbw7lP9X3K5AvHFFQ41L7q4z/T6k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772464980; a=rsa-sha256;
	cv=none;
	b=8LG7niZNDSeYq9DG/t+PIp56QUDKUK5nUSBoa6uUrskHviGHoEMT3DmKEEkqRcYxfHUs5r
	gxLoyFGT6bPTHfPUTvA45O9EcJriCRNp5eNyROMKIqwNbwNs0lvgRrtiwhGuxBbx3OHlZr
	7qv7T5TycaT5xSJz+R8/RZOVJxvOQJI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=0XQtejgo;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf17.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id BD9F5B308A;
	Mon, 02 Mar 2026 15:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772464979;
	bh=cZrWALVvP/5PCNYa5kN8hhPqzqgPdcu+PQQdFr2xuMA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=0XQtejgoF4lHXmQZfH+M5Yr/k2dulaPURnPgHTjB3MWoBc4ABdeo9tX28PvlJ0wfS
	 MhnKUH1BcERlzCflotEoBh7ucIj9rGuOw5aZlwAZ3tTbpooMJtXtq+bpD3TPnVM5C9
	 IoQNyU/1h833NedDbDGWDcatze9MhSFM3hlGuVIY=
Date: Mon, 2 Mar 2026 15:22:57 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v4 2/5] mm: convert zone lock users to wrappers
Message-ID: <aaWrUezs2XysV2Kl@shell.ilvokhin.com>
References: <cover.1772206930.git.d@ilvokhin.com>
 <d26a43ebed2f0f1edb9cfe4fbed16dd31c7a069c.1772206930.git.d@ilvokhin.com>
 <7e93021d-53dd-4162-97e6-3bca1f46a0c6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e93021d-53dd-4162-97e6-3bca1f46a0c6@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8F45E40008
X-Stat-Signature: 4x8tq8togmzqbm365oj5emgco8zbou3k
X-Rspam-User: 
X-HE-Tag: 1772464980-341090
X-HE-Meta: U2FsdGVkX1/dyXqXpkmUb4za28e92oPge18tsEBxAeHTb6g87gOP7SIMzhmlPHG8s1GST3cXUuIgCRQ4wzMLBuegqkkRYtDad1eHk8uXP+SRmLxsOrIfd73S/n/02IsK4kx79O5lTC0Glf/TQQW3FQIzFO2rpu4Ue+w3KDnI+n8AVbuszZcUP47ks1NLyLR9uXWVz1ZExp3JNmITB4Uhd4zbk0r0NwB+6yZRK1DlLxBdUKDwI2W4d3t3FK8icKLEckInLhv+tXGZ/2LaN47GRnPwnIalIRqwT5LDZd1+B+xK5sny2gG4cLbvQdAIQDT4CavjwI1iRb7Z5Y+RuLq4voUeE/oX3h/3QMJKPK1rHcjEQEii03sxLO0pizFxT2XJH0uRz/OrY4OcDzWAjGk336vONBn0FPjBjchdvUHNvFRLvjxanRn4YV96GR+NMX3tU2FwpHieEPSeZmEYHE/RRs1P7rS7iTNL/uu7wQE/ZcSJ5lMY8b3ud3R6AmhuMm2b+2eU8upYwkiElH7QmRFnLpitdq7Bf+x1rfJvlDzV5y/2MAs64HSk2ERxMxKKxj9u8P6rVjaq/09Es6a+6fleB3VBFB1tYSyRkFaa+5leZ6NLm9SPv/uEhi0X1878kNaphezHOlVrzfyWREsW+H7DYlp8atasBlKfoME5D7NH8rLscTaLYS/yMWeotd/jUwH6lSS9v+9unNERGE/rknKVka+v1NlsKUtgN5MTeviR2EP9WTG42B5MBCsPeZvxuYFVQmu9/wfTZAY7qvsFMr3XFQIWadWzkif/Q7vtsEiBTCqYXQd8b74WTsrib/bkjsxBbMulLLU81MBTZVQSruS48HZwd53gftdfY8VOhL1FaF55Kmp2Q5OEqd+/+VO+9x4Oztx15FyL4w4sz14A5LZFqAFq5v+A2qmzyrCUHEO/XQLSPMF/xiCChS36ZDANZI0IhnreAo1R8wAlyaWTCir
 iNYf2Tl4
 eMdhoqLisUjb4iIgugIqG9+1PJoXrEw2f36AIMKOGwjce5SBbDsZvc7JAMVyjZVzLgYCN3T6xnhPIFwa8TJLkhPaBteua47dznSu7SurbzI27J2uemsPHKZ9zsJ0qO6UDv8YqCpNLbN9gDp/NUZ466usFSPwQ5L/DqM0+U2LDIX6HjheGGnUOc5Q9QC1smtBayCce3vPUGB+3dNi952oCorMMCtms2/fRkuSlZMoxdpJX7Fx5CKdlDFAtKEwtncVwmSJZdRgc695rzFudo67leRgfcwgtz/RFzgur1DcGavWvcc6hMNeV8GQJMIWylV/68EdP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:39:11PM +0100, David Hildenbrand (Arm) wrote:
> On 2/27/26 17:00, Dmitry Ilvokhin wrote:
> > Replace direct zone lock acquire/release operations with the
> > newly introduced wrappers.
> > 
> > The changes are purely mechanical substitutions. No functional change
> > intended. Locking semantics and ordering remain unchanged.
> > 
> > The compaction path is left unchanged for now and will be
> > handled separately in the following patch due to additional
> > non-trivial modifications.
> > 
> > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Reviewed-by: SeongJae Park <sj@kernel.org>
> > ---
> 
> [...]
> 
> >  #ifdef CONFIG_COMPACTION
> > @@ -530,11 +531,14 @@ static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
> >   * Returns true if compaction should abort due to fatal signal pending.
> >   * Returns false when compaction can continue.
> >   */
> > -static bool compact_unlock_should_abort(spinlock_t *lock,
> > -		unsigned long flags, bool *locked, struct compact_control *cc)
> > +
> > +static bool compact_unlock_should_abort(struct zone *zone,
> > +					unsigned long flags,
> > +					bool *locked,
> > +					struct compact_control *cc)
> 
> We tend to use two-tabs on second parameter line; like the existing code
> did.
> 
> 
> Besides that
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 

Thanks, David. Noted. Appreciate the review and ack.

> -- 
> Cheers,
> 
> David

