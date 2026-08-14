Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68A07C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 09:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 605086B02F5; Fri, 14 Aug 2026 05:45:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596A76B02FC; Fri, 14 Aug 2026 05:45:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430E66B02FD; Fri, 14 Aug 2026 05:45:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1BD8F6B02F5
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 05:45:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99B6A1C1531
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:45:49 +0000 (UTC)
X-FDA: 85099393218.18.958570A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id ED9A9100003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:45:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y1eS4vcH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786700748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5HIwgrpO1fXJmlHwW1EBASxu2Cq7Szkx1H/G3rD/398=;
	b=ukT4DGtQLeECj/aTnVT9DIBc6gRwXWArUwygWq9RHgWbQpNb9TwBkyWE8wKJT0POScad3X
	de8qbh+wF1R49tbpRXB7MP0JfGK0RUElSafbugcPIihrrdYvDBIa7ZR7Xb/EEj64ffPn+9
	chJBUuwXxdrFXEDRKS+kNTZYYCoVIF8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y1eS4vcH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786700748;
	b=qABk1bxAvf3Mh77OtZUPTRpU7ROyyH9tKdxJWxydsR9ARNUzKAYTaAkyyDhxcOi6AZ8RLh
	bKReMYJtndJqPlwH35VDXasvN5Mch9n1+R7JVwApGu+AgBUMge4DVXa22yFgBJlxZTf3gr
	Je+Hy/301IVKHjhVDcdswA2WcY9TFUU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4645C434A0;
	Fri, 14 Aug 2026 09:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E511F000E9;
	Fri, 14 Aug 2026 09:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786700746;
	bh=5HIwgrpO1fXJmlHwW1EBASxu2Cq7Szkx1H/G3rD/398=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y1eS4vcHSMq+0bM/nbkCMNcnwAnFodiBa9e+itcKuVlj+6p1zLi+IiA5WuDkjYAIn
	 JGpyjlk6a2Ol0t21YFqdfItFcmVwQxPSJaDWeVhtyEbiJNWokMYU/EUI38gTq4JIS4
	 TsVfwKNpaRK0anYl2q2uFtRsX5aPJzgZdEl1t8ZwMqOl4rG7SM+frXo0RL/EM1S++N
	 Sr4/yRe6OpOplXzFeyG3IqTVjQmhij5rCnGF0iyRtjfKyvWuhE4dkgUvf4vJGnOs+q
	 3LQ/JgyfEqf+coYSTWKUIXUhoLnLGAUd1kHFdLzqa8r5jTnoEd+kLbjaCFzNe78lvi
	 FLy5TqJ8Grvvg==
Date: Fri, 14 Aug 2026 12:45:15 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>, Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	syzbot@syzkaller.appspotmail.com
Subject: Re: [PATCH v5 00/16] mm/rmap: index MAP_PRIVATE file-backed folios
 by anonymous pgoff
Message-ID: <an7jq2QI6CaTgFxK@kernel.org>
References: <20260813-b4-scalable-cow-virt-pgoff-v5-0-c21581c0c3c8@kernel.org>
 <20260813115346.2aaad419a351341a4f5f3ae0@linux-foundation.org>
 <an7SkamROquJ7If0@lucifer>
 <an7dekaY7IMMrzID@kernel.org>
 <an7eSrKUHUqPpVGv@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an7eSrKUHUqPpVGv@lucifer>
X-Rspam-User: 
X-Rspamd-Queue-Id: ED9A9100003
X-Rspamd-Server: rspam07
X-Stat-Signature: 3wm48594k6nmosidgd1z9upuxmkoqzxs
X-HE-Tag: 1786700747-136157
X-HE-Meta: U2FsdGVkX1/1qW6uHwLkGnyRWqlOvthzOgmVmrdhrBorRP7j0rDr7bk+sS4/M4fB/hYrri/OXTynOyChsmfJgxP/1i9QXGdBQD2j8gAQWiUuyHuoLWqYMFGjOTyWy020ctiO+UGFxKILeb+kNzZQxHhMKp0XVb03mZVdW+2ioQZrsoxglSTusQdk5Zj1nMSXpybqy8xDvcV18L1QNhuF25yed8MM6D96SFf4d2hwooo/96jUxNupuMznG/nPjsEEUeNaGYZlS1zVtwN4KkPahj5N+L5W5+obxrcPLo9X8ZYgDmuueqfoT07HP1ebhEEhGz7zaUN/QjvxVGjLbqOPnZuIkbmAVVuBlkdd84/EDfmW97OyhCeDKVW6MGj/6ITTy+y4Ym+B3Mcjl7zDzXwYDuhNwdoxVw5CUkhwGzxQuPm165izeOgCl6MpigSdOpEX+hmljfLXl5tr4FgTGcdiDKdDVsFca+hGYqSQ9bz9OwxB+EDIdRYYLRYHRM1KOt5QOiILs2ilgG4ZHkSK3U8MU7vFXh2twatcJacdIj4oh1NeuB0R7Vkc/xv+tUgB4GC6/8E+Mrd7ndm/57zjH5WBfK9kZ8AaQKHRRs6BFk42ICy8Vj0pvU8JC22M79SyOr1fae7AQRUddcs3UClewCW1msxPMbrxlWTilaqe5pcw2EVfinRBdJKzxVAYVBSQWybMC41NAuLHYO+SdIa0w97OmrICl8bBLMvjdf2OpD6I+d37JAQkBFsoMQ/UpADmuc/3W2PQ+sG9LmqJhv8b93IFopUfpyVtuEIGtQpgt2HoUQAPgJR5nEFw7EJ0n//4xzjBt8WydrUfUoVmP0Wt0OcPFn9vwmU5XlS6BMc/hEpRSji0Q2iCbjf8ALtoZf0tMipNi4Jx4jD81y6TA0LYKJhs5P+Tb6HO7BG+Zwu1IVN8ZKcJSQRGD1ae/7nXtujN7ZU2kK0BLiTaDh/rCkxiby8
 ggODjgZZ
 p72DgjU/0IrBLOhPtUoAHaDwnfgc5uysqBpN/6efIt3nD+QdnDw3k9TLkvm525tYYPEmldr7uulnZvCQphKOdqyJQikZcb2oNRmSuZ8mT/QKyUeaapc7ZvTihUgtEFnojgdUraMAkJABRc/8jYyauQJ523FNS8gz+QtxY8BHdZRgsff6Ud2FvfnkfaXKr4lLg29xksHwoNRopeoqIUH7jq8Ex3hydbjD38zSB2F36hpyG4Sx5kBypva9IB8YMKnWhjX4mHgzQICuiAZ8zmfRB8tLLsB/SviySTtCnZSeNAIge2lbbzqz7C28RHHaV5GaT1DkK7aI17WIw9vQT8QnPXcThF+IoTcRlNB78eCOc7JcY4xbpghEpvfml+/+KlmN3VY/z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 10:23:33AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Fri, Aug 14, 2026 at 12:18:50PM +0300, Mike Rapoport wrote:
> > On Fri, Aug 14, 2026 at 10:01:19AM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Thu, Aug 13, 2026 at 11:53:46AM -0700, Andrew Morton wrote:
> > > > You'll be mortified to hear that Sashiko wasn't able to find anything
> > > > to which to apply this.
> > >
> > > :))
> > >
> > > Well, when it's right it's useful, when it's wrong or suggesting unrelated
> > > what-nots it's less useful :>)
> > >
> > > I do locally put things through claude + Chris Mason's prompts a lot, I
> > > don't always invoke local sashiko as it's very slow and token-heavy or has
> > > been so far, but am planning to do that more also in future.
> > >
> > > >
> > > > Sashiko can be guided with a base-commit: tag but I'm not sure how to
> > > > tell it what tree/branch to try, or even if that's necessary.  Perhaps
> > > > someone can figure this out sometime.
> > >
> > > b4 gives a base commit, but I think because the trees are rebased it ends
> > > up being the incorrect one.
> >
> > It's not only that the tree is rebased, but also that mm-unstable carries
> > the previous version of the patches.
> 
> Yeah that's part of the issue, I can't rebase on mm-unstable as a result
> obviously.
> 
> Is hard to know what is sensible to rebase on - if I rebase on base of my old
> version of the series in mm-unstable that'll probably be a bogus commit at some
> point due to other rebasing.

If the work does not depend on other commits in mm-unstable, it's possible
to base on -rcX. But often it's not the case.

> > > Not sure what the solution is!
> > >
> > > --
> > > Cheers, Lorenzo
> >
> > --
> > Sincerely yours,
> > Mike.
> 
> --
> Cheers, Lorenzo

-- 
Sincerely yours,
Mike.

