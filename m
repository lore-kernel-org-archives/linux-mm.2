Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08626606A338
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=T/hTRzGA
Received: by kanga.kvack.org (Postfix)
	id C3F776B05D8; Tue, 27 Oct 2026 08:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF0516B070B; Tue, 27 Oct 2026 08:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2D056B070C; Tue, 27 Oct 2026 08:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 295336B05D8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:49:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B33AE1409AC
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:49:25 +0000 (UTC)
X-FDA: 85368387090.28.856F7DE
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf09.hostedemail.com (Postfix) with ESMTP id D3A7C14000B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:49:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="T/hTRzGA";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf09.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793105364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HfrXUsdFLQaA5FckFCHh54cFFOWKpmXuI7Yv4I221sM=;
	b=oVuBy5aDC3JEdAXN4zLTONUES0xuZe1nZsgPJC9oW9RQviA4aBGGWRGbNbx0N398TwrVoN
	a80J7lamJIIHVLKDFtrR7OQ/nkiKLbNiJtKzv16c8+OHMWQxZhTCzZilqAfXV/iXVXZKVe
	2LJbjn5b2egcBJzoYPCNhqrsyCkK0D8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="T/hTRzGA";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf09.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793105364;
	b=EqjynubzqfOBQPa1wPOwBKZt4axMS33GPBl8S0AK0EN8ACgQ5UkWEwxXsDKtfsNQA6CZCC
	oLn0HUZGJsF54jYD7+AFyqW4WZ+MXkcmvCU1SDspvHKKT4JtVBPnaR8WrZDecWgV3yVqgB
	MvfJc+nvZHcWkLzitfN/bHh2BLzeksM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HfrXUsdFLQaA5FckFCHh54cFFOWKpmXuI7Yv4I221sM=; b=T/hTRzGAYoLrX/cxLl9a0ZtIHX
	KKT8aT75ShKu+I4Xl9h/suO7DJBk6ZDvX7y8gpHvZKBWFcAaRJUoOoQ6byNN8AYceqohUlmEKQL2Q
	hF6V2vtojiWISCS0NgQrAc6cHJ6PW0/H6fvBQJQI0r+Fv9nRKRi2CNAwsALVWiukr77b1bWPwwsRN
	nq/J4MlbBa/Wmfk/kg3e5yC+7zuFml9XGs+eaBF2D7MyccDwycJEL3pjInXFuJ7MhJgxQvojgnODz
	8xmSHxzRrxE7n7izu6v0pXqscvEgRAafGRks0Pz4L4+vp3cAbHDEgasf3uWaK3tTLXNFyCFtdVIij
	rMnFZbdQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLgcA-0000000ExlX-2MLY;
	Tue, 27 Oct 2026 12:49:18 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 17B62300A9A; Tue, 27 Oct 2026 13:49:17 +0100 (CET)
Date: Tue, 27 Oct 2026 13:49:17 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCHv7 13/18] mm: Drop fake head checks
Message-ID: <20261027124917.GA2669272@noisy.programming.kicks-ass.net>
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-14-kas@kernel.org>
 <ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org>
 <at_f43oDv73y-t7O@thinkstation>
 <f97a8d33-50b2-4a86-8381-ee840cdfa2f9@kernel.org>
 <20261027110028.GH2668564@noisy.programming.kicks-ass.net>
 <auCKv_omLGRc6wv2@thinkstation>
 <f3f3aca9-bdb7-4aec-9099-9fb63a60e61d@kernel.org>
 <auCZFckDfBMrlfxV@thinkstation>
 <20261027124716.GC2668804@noisy.programming.kicks-ass.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027124716.GC2668804@noisy.programming.kicks-ass.net>
X-Rspamd-Queue-Id: D3A7C14000B
X-Stat-Signature: p1xh1o4mjhatrcfm1meapyh3i7ydfd6m
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793105363-20634
X-HE-Meta: U2FsdGVkX19gcTdO/piRNNcpu8mVpM+Z9DYTPFMxli8K8FEXtCp9qzHrHhwhyr5hcd0oMsUhjL6ghtUtM2KeDYbSEO73LQ+nGj8yUK+qOOAh27FgdHQGXY3IP1j96WQIYs1e+jIxS56xHYhWkyx9ESwH8mGFnlTgMhBvwstrgWkKZZkMRfa9AvIVC+5CaC9jj44cCgT62llnOwoMbpSVeuuPZEnjWP5cy2nhd0FnMpD3OPBmXQIreJPzgA3VTzK+PEoc82lqGaFNX05zcKteprbs6jM6rPbfrqUvdIQxBjISKxEmo3LxWOLScXrUNn1tKP+GIaDZMahj7g9UYNT2BJpZqef0iZ6bvOv78YHhg64iZpSh6Sv06BJWFya//vJfMsaCyP2y8TdNUvT+ps26MD3hTBm1rkSwL+TaNQeGsgj6EAlCavr848qmJz6zDjyjWqVydQGJEJ8nF28L0yb4FATc1fhjnKj6AlyA+3RYI7PUkFD2BvJVyxYxgoEm1wPQfs8b5zXMh4XbuIqEj/vrXzSWd8FMJMrvdYO9ZHRYCbTrJwiXQJoiWd91sOCGP+TYHVUk0jGyKXZecS1t61KWhfDh+d2FpxYJ4m4NAV+CNAtIyyek4GVuR3zu3qdPBaS6y75V5OqeFI4CNlsxKJNmdODw/3KwQsNIkZA0QUfNrGykuWMmpet98vnP1GqadglTtR/O3bO2Fm3v8vImY0jDkMDzCTNApavgg03hDVD8e4jhOBIfKMjq/3+CJHg6hoVLmyJ6ADJiXYC4g2Iv7FP0NIegTzC2i8IAKK6RJ6O1DTBv1MgNIYh4KIpvvIFYiCIeALdm3XRIMcvYq6BDV1PGrtYk3D9pyAhJTkVhmmHCqQfutvURPKjSMt/lUex2LB6P7OxrakXydmm6sekC3t9xu8dBjMJLf9wW8ftBLPqgTrxZkEcP0qbuF7LKmd7BBYnlLKSfjYh6mJfYODTFH4V
 vVRYnv0g
 ybwtgAEEqcQO/Q0neMsYs0G4eEDAtdbAoeyTSjnvezPy3xMPjzJmmoz4S94maWnFXHr5wd6Lf/Hh7b4sfFtQ+4H38V6uQeWuqPVC/18jfBeXHfkEDw9rT1jeQo2VSIYviVcCnlujsRC49JPHaSLeA/NIbo+RHAboXZY6XNxROtN3104fMFSYJ8S90Ggo5nuT1Km2cYw+XhFjtIlI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 01:47:17PM +0100, Peter Zijlstra wrote:
> On Tue, Oct 27, 2026 at 12:31:09PM +0000, Kiryl Shutsemau wrote:
> > On Tue, Oct 27, 2026 at 01:05:58PM +0100, David Hildenbrand (Arm) wrote:
> > > > Writing this, I just realized that we have another option -- map the
> > > > shared tail page writable. A failing LOCK CMPXCHG writes back the value
> > > > it read, and the get never changes a zero refcount, so the race becomes
> > > > harmless. The cost is the protection: the page is shared by every
> > > > hugetlb folio of that order in the zone, so a stray write to any tail
> > > > silently corrupts all of them instead of oopsing.
> > > 
> > > Right. Without HVO we would just corrupt pages in the single folio (which is
> > > also not nice).
> > > 
> > > I'm also questioning whether we need this RO protection all the time active.
> > 
> > What do you have in mind? RO only under a debug option, or switching the
> > tail page to RO some time after the remap?
> > 
> > If it is the delay, a grace period alone does not close the race. We
> > would need rcu_read_lock() back around the get, and then it is the old
> > scheme with the wait taken off the allocation path.
> 
> So it used to be; back when Nick introduced try_get_page, that it was
> only allowed with IRQs disabled.
> 
> And looking at gup.c now, I see gup_fast_pgd_range() still has
> local_irq_save/restore around it.
> 
> So what do you need that rcu crud for?

Also; as long as the synchronize_rcu() only lives when a debug option is
on, that sounds like a win. Debug stuff has costs, news at 11 and all
that.

