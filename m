Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F886F417E0
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 14:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8276D6B0005; Mon,  9 Mar 2026 10:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FF5E6B008A; Mon,  9 Mar 2026 10:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72C256B008C; Mon,  9 Mar 2026 10:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 63AFB6B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 10:47:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA29A1C1A3
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:47:49 +0000 (UTC)
X-FDA: 84526803858.12.BF9B612
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id A905F8001B
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:47:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="lB/uQ5QS";
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773067668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nnj4k+XehaMxifjpCjHJ3TnczqL5sK8JKePas2gKMrs=;
	b=0uL5vFKGPVo/Hm3rsPb0h0eBygpwk3rI2tNT3SYbUPD5xTHopBbperWctznBBLiNFIqkj+
	2JYggthpZ0qHG16CgrCheFbrUj7i0kiEsYJSDxy90PpkVqGDe9Q/itUthkVCCQMYc0GroQ
	BsaJCpaV/5dm3/DDmYDdZCy3j3yQpPA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773067668; a=rsa-sha256;
	cv=none;
	b=MpJnbWbTKA0RcIyA1H2Tn8Q9OOv3Nlm+ZPOgJTQdBrpZFppYvVvNuJz3WAX3nUh0/XYicU
	aJBXqbRGWVT4wshwtFV2lhFI/p0/9NXpccYY2EtSuCW4j96wjmwZ1m987Gtwk24qY9YzAp
	Qgf7LtI0kVE3/XFHEyRsjn0D2K2VNAw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="lB/uQ5QS";
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Nnj4k+XehaMxifjpCjHJ3TnczqL5sK8JKePas2gKMrs=; b=lB/uQ5QSLsq6gH+kR+l86+yhw5
	FbuQvAXOsHCyim+YF0hTYAJW0G999xN9zFVOfpoCYd9npU8AV4L+txlNyjDxtjir0wUVDz9TJVj/h
	SLdO+/BelNCrkIxgc5/tKbKH7TvdKEZkthv/TljmV+H91v2wnZt6T0V0lYd9DdF9KvopEZIb0/2p9
	jnI6nwp4w76mtod5tTZKWu03pCo3W9USscMLbZ9LGRGeb0hRaXEceePsbUInZHyMmJAT7DjHGE/2J
	iw1Bq6KCXTRZyMkKs504FvSuHJQhsO4ev1bqdTIl+EMVppbjDl/ThQ6KNnuZiUIEU2RrG2f88TpwF
	NZkyISzA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vzbtK-000000066Hk-0pLi;
	Mon, 09 Mar 2026 14:47:30 +0000
Date: Mon, 9 Mar 2026 14:47:29 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
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
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v4 0/5] mm: zone lock tracepoint instrumentation
Message-ID: <aa7dgQDMEz34eadj@casper.infradead.org>
References: <cover.1772206930.git.d@ilvokhin.com>
 <aa7G1nD7Rd9F4eBH@casper.infradead.org>
 <aa7XdpIVtLFS3FIu@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa7XdpIVtLFS3FIu@shell.ilvokhin.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A905F8001B
X-Stat-Signature: xamea4gind4gjrq7isfd16z91sp7oay8
X-Rspam-User: 
X-HE-Tag: 1773067667-626431
X-HE-Meta: U2FsdGVkX1+sEoeF0UrluspegLuzQvClv/P/NSRpN3s/Pk3spkVK6volpL6T7dtrcwrLe+QFQ1mRHd4Ozg4sTLPS64/1sbLh9c7aUcBL2cIfCA3mKAoRG0O9zz+iQRciF/2ZZluuWn3Dmqnl+x++qtgZ18ndGMF+jNfUrgnpBmH/W9gbcMTjxYRNr4bhAQr2LoaQAMw1eGVHVaRPzDzxv5RrPSVww9qiAzkkGSIOgpnU/mMZVQ65lXvmx0NxUkv6dtYU83Zlt+ECFHKUI2sLVcxdulsSrJAUcTwH/67nJBQQbozxp8CGGIa1uJ3SN/8XITi38zYdgzyFiUilLlDFZccyG+hprkY8rr6ZSjCL4II0UoDUi6BMY4gADIU6KafmbwTTkatyDgkpn5hML/FN2j7PJmo0rwwrnIIw6GlVmp63/nB54XnmLcaBc870SXkXg8NueM0c1s8UfEmoCM4/IeGIlApMNJdtiUXLxFH9bg39mMt1l6oXfDn7NfPgdd3NHcc8yMjXy3gu2BhwuxCEo19MDHs19SIwcZ62GllFZGimwGmnpdrItcZnXPYElRLGrneagE1NOpDpprCO7ZqFn2Fh//1wNkFnOBgAOAPb2LlJw1D6iqmD0ScUS0qQ5r8LJ8UBCDrI0lJM+jPQEQB0P3k1Lt+cdf35EXbQG182RV0Da9TzRrQa2oQwWFRy3vSgobyT9ZBFAyjZTOZDRpRhKGoy2a4TflzBXJtTBXS4+nfO+LVd9uVBaRjsPDM64FT6pigCNI6GXsS/1MCOzLrPvzBh33ovh2vIPZBYDR2bu08NuLdnwJE2+n//+tUKG9V3juXY8t1hJcmmRNpc/Ox+GGx0iJ9FBCD2vjAvx4AogZdEfl3PLyOaXSvvEkzpkAOmucA57/HryZJenDAZp8+71JA4eArfelWp9Erav28KOI0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 02:21:42PM +0000, Dmitry Ilvokhin wrote:
> On Mon, Mar 09, 2026 at 01:10:46PM +0000, Matthew Wilcox wrote:
> > On Fri, Feb 27, 2026 at 04:00:22PM +0000, Dmitry Ilvokhin wrote:
> > > This patch series adds dedicated tracepoint instrumentation to
> > > zone lock, following the existing mmap_lock tracing model.
> > 
> > I don't like this at all.  We have CONFIG_LOCK_STAT.  That should be
> > improved insted of coming up with one-offs for every single lock
> > that someone deems "special".
> 
> Thanks for the feedback, Matthew.
> 
> CONFIG_LOCK_STAT provides useful statistics, but it is primarily a
> debug facility and is generally too heavyweight for the production
> environments.

Yes, agreed.  I think that is what needs to change.

> The motivation for this series was to provide lightweight observability
> for the zone lock in production workloads.

I read that.  But first it was the mmap lock.  Now it's the zone lock.
Which lock will be next?  This is too heavyweight a procedure to
follow for each lock of interest.

> I agree that improving generic lock instrumentation would be preferable.
> I did consider whether something similar could be done generically for
> spinlocks, but the unlock path there is typically just a single atomic
> store, so adding generic lightweight instrumentation without affecting
> the fast path is difficult.

This is why we have tracepoint_enabled() and friends.  But ... LOCK_STAT
doesn't affect the unlock path at all.  It only changes the acquire side
to call lock_acquired() (and lock_contended() if the trylock failed).

> In parallel, I've been experimenting with improving observability for
> sleepable locks by adding a contended_release tracepoint, which would
> allow correlating lock holders and waiters in a more generic way. I've
> posted an RFC here:
> 
> https://lore.kernel.org/all/cover.1772642407.git.d@ilvokhin.com/
> 
> I'd appreciate feedback on whether that direction makes sense for
> improving the generic lock tracing infrastructure.

It seems fine to me, but I don't have the depth in the locking code to
give it the thorough review it deserves.

