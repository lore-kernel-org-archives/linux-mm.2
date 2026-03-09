Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D4B5F3C24C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A73416B0089; Mon,  9 Mar 2026 09:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4B2E6B008A; Mon,  9 Mar 2026 09:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977F76B008C; Mon,  9 Mar 2026 09:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88C646B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:11:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17C72B639D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:11:05 +0000 (UTC)
X-FDA: 84526560090.23.1041262
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id E34AB140016
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:11:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=QXH3c3N2;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773061863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MP91r6c+y7giftvLR1OcIBEAD8RMncykz3hjSEiLD3U=;
	b=35/AqWoWSYoEFXlUat1l3T1GQvOGzHoiQgUKVrBIHIBVaCqBXszKpd9blYX7oDWv/hHg41
	w2Fb1RcnOrB9ktjAkhJAwu46ojKHGwMhOHFLRbKNC9NzXQN4OOLeNxlHis84S2g7DZJ3ls
	fvTg4lvjwt1vFL6ovyvNtWKN3YdSsDg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=QXH3c3N2;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773061863; a=rsa-sha256;
	cv=none;
	b=agGY49+IDozKaD1LIflBa5+c/ITNU/TF3KcAoM0ecpTL+uY0FHt+SGkXFGoILeOrI0P4mN
	Tbv82WZr3Ci3Pb5io/06mRxHrnY7sB1Ckirh88RPOJzyIUuOSuBT1zp/RNlfkfAhqHXg1i
	OLkSQViXUIu5xriaW14pgEPOir5Omq8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MP91r6c+y7giftvLR1OcIBEAD8RMncykz3hjSEiLD3U=; b=QXH3c3N2WvdAVaSk98rBw2QTWS
	hU5Khg29+699uZHVtoU0uZoe1D1JffMnyRcTC8uQ7cbi7MTdGwkhkTrFM4BxLE7mmonVLmntz5SAP
	IictCbrRUlk+lXjcQDDSzGiCOkzLnQqIORtItpqOvW7X3s3kgk/cOE2ElyskYVfLRf6B9ynL23R4e
	rK4ES1g8jxDUN5iuuqwgC19keOsLHKfFRHgg/jnWLnecoWDm4mQwnmV+S3bnIwP5npEOOGBJmsDeb
	bKuls447s9ARbiGV44qcLe2izeke7FZkNGhnaK8b9FBRLdXrdUrvZp0LPwM3NlLPxUgj1t/dIwV/G
	lBt5MxcA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vzaNj-00000005ZGM-0n5j;
	Mon, 09 Mar 2026 13:10:47 +0000
Date: Mon, 9 Mar 2026 13:10:46 +0000
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
Message-ID: <aa7G1nD7Rd9F4eBH@casper.infradead.org>
References: <cover.1772206930.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1772206930.git.d@ilvokhin.com>
X-Stat-Signature: zukj8gyrhs9fhfgsbeddr1zjanpp795n
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: E34AB140016
X-HE-Tag: 1773061862-616729
X-HE-Meta: U2FsdGVkX19lEo7MYVtjbjNNs+H5cLtF3IsrQQXYzCjEx0jbeDz82S1K0whFh/DPULnF16lHooccV+zzl3Z8ELJCcyp5xotFhrRmEmZx+LMudahhikH9MifD/FddMsbFlAdk2ypMbr4KuRpxJMSZj8FgL8+TwP0i6Zr3fM2YROktCJhwu0AzNbgESz1Z/hHb3J7Kcpnem9brTunjAuFdAlVGrXItEbxvNzOnRW/QpOlGKFzqVo1SA/jg360FsZMoV2rFTt5fWgI8j1PxKGN5dxh7e1jnwneciAr1cxeLXaUBEoVGVQTwC2njxD1JpV/Nnr1ZxioJuf6+iCepvZ7rEJ+bftYlpWOTyKbos7oQMJnH9JX+bS4BCfK96gjD0nTC50fFdylyigR7fjMahQ7OuZFcinGbAH4HArlJpcnw5jnzIW5xMVjiHXeuDRnT6T6TJd/xVO5A/nXs8XPeM6bqUarFnfJrrTGrZA0KXwbMNs5C0E4T1uFhXwOdctc3s5t7Jd22UIVA1cCRXvZcm9fElji6J7OFXMsNOqdR0i8rHdRStZy/y1bgMIcREQKoU373jq2AZzkJbYN4zBzwi55scNVxmmRJRNk0pNRRhUuN9+640wOokr7uaRm5KEJD1khoN6g0m+vRjALYTtHSc0omPnjzkcWZzq/kUaVw5IxqfPiSoGFS+btFmDQkFNlvSeGBvqBfPV08tKQiKHdQxDFbBfjqXN+lF1z4nPdJ/YPPQv50PDtmBmp/jdw0MeJj5PpK2E7/MJvT/TcF04S8q/ZL6pb+9j+bkiRrwSuodDWklxliEM2kMlfcgx2eYJFaxQXjdpIWccWb1jsdf2/BD0NFzV463XbpbNoboOaj/cnkWK9pTKkJlrQUtimEWCxJgC1CfotOP83y7r1MUUR53fxfgjmHzYeSbMVQ8krCgpF4wSVTEkfocXNJSYVnYeWwQs3aaJ3oanSMglXNbSDqgUe
 AZj6RVyF
 iJlYLJ+53kpP7kMQDT9TXt9hybS3N+3exB9AmRbJ29x/W5FDWkBsK996CdmcNWZf9EokTL/KaArx79Rvk5koHwWXU4ZZxpNxqKmH8nzeLuDDSZ8cWnH6597WxVyDxciKj8R74OWQvkyJ8ggmTpuYGqz7VwAXOLiklyiVQafCqe7Ca+kyfu2ByW6p+Fj5tpUpT0fYpIDLqA1+BDddb7YwVAUq9K9nWUZ4gk2NJkKnKvzLl6jfqkJVyWD2h8YY05H/6zdda
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 04:00:22PM +0000, Dmitry Ilvokhin wrote:
> Zone lock contention can significantly impact allocation and
> reclaim latency, as it is a central synchronization point in
> the page allocator and reclaim paths. Improved visibility into
> its behavior is therefore important for diagnosing performance
> issues in memory-intensive workloads.
> 
> On some production workloads at Meta, we have observed noticeable
> zone lock contention. Deeper analysis of lock holders and waiters
> is currently difficult with existing instrumentation.
> 
> While generic lock contention_begin/contention_end tracepoints
> cover the slow path, they do not provide sufficient visibility
> into lock hold times. In particular, the lack of a release-side
> event makes it difficult to identify long lock holders and
> correlate them with waiters. As a result, distinguishing between
> short bursts of contention and pathological long hold times
> requires additional instrumentation.
> 
> This patch series adds dedicated tracepoint instrumentation to
> zone lock, following the existing mmap_lock tracing model.

I don't like this at all.  We have CONFIG_LOCK_STAT.  That should be
improved insted of coming up with one-offs for every single lock
that someone deems "special".

