Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74BE1606D817
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VhodTs+A
Received: by kanga.kvack.org (Postfix)
	id 971526B05B5; Mon,  9 Nov 2026 07:26:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 948A06B05C5; Mon,  9 Nov 2026 07:26:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85E7F6B05C6; Mon,  9 Nov 2026 07:26:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DC406B05B5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:26:25 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0623D803C9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:26:25 +0000 (UTC)
X-FDA: 85415503530.20.6311BD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5EFEE100007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:26:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VhodTs+A;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794227183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+EKYQdPiDyWXkzzfV/UN8vBxInBjW4N6ZELhlBfhOI=;
	b=SXtohot3JcazGCjg6Vc9TtPg7ctC3uT7iCsMVcfuBj1KkSZ1K+xkXYDPMVqs9S5dvTdDBi
	ShBtMRK476yHSp/mqBQkZ86QxZrVDIH5qhzm+cOoWAm7CYrIQUovk2TsLxh0BiZgYrLAf+
	u8snEgJFPi+MaztEev9nDKDfqNYsGPg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794227183;
	b=I0APOZtykxKKIsopGBrbZs9Jr0GgxPDvDeL/gO9UBXtPWDMF8/S0cGEnHWzOgBc8MegeR8
	NqXR+GKTH8ydwSaSdCSS9yZKL7G/qXERaN7GONIcAARH2AiRUeUDepy7q0OE0k6cKaJbmj
	ecnUVMGvw4Qeu4PnZ/78lS/j/IzPz9E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VhodTs+A;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 92A1F43D40;
	Mon,  9 Nov 2026 12:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937971F0089F;
	Mon,  9 Nov 2026 12:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794227182;
	bh=6+EKYQdPiDyWXkzzfV/UN8vBxInBjW4N6ZELhlBfhOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VhodTs+AWpB6b78audXhz1hdToGnTfiqsIeh7C9iS51ypshI9FNnayYXFucaMgeLZ
	 xeEIungcy0zjIPzwmpAqArp8eRXgn6aLR4nNmqHiWaRHWsbsQ7Qxh3+PgSaQmGodli
	 iH97FzOVZfiuF5Da5WjkLmXe3XJknzf7SbtxrzdHDZZM2QKqqAHZOHOY4doionvKHw
	 4h930muPKhPQSSHI+AAJgxUYDe3aTAGC8NAItOXceOH2dwmRr1lJ1teB6f1iCQBu+D
	 7GUCaRQliXvLQza+jV5DiZhXeIr64nvzKuidlvAiLong4iDN+nDILPyMHrAS7gpG/t
	 Sxhmv2E4eHoMw==
Date: Mon, 9 Nov 2026 12:26:00 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, SJ Park <sj@kernel.org>, 
	Rakie Kim <rakie.kim@sk.com>, David Rientjes <rientjes@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	John Johansen <john.johansen@canonical.com>, Georgia Garcia <georgia.garcia@canonical.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>, 
	linux-mm@kvack.org, kvm@vger.kernel.org, damon@lists.linux.dev, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH 02/13] mm/filemap: convert fault and readahead logic to
 use vma_flags_t
Message-ID: <avG7mvt0okaFGUT7@gremlin>
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
 <20261105-late-2026-vma-flags-v1-2-0d3cd15ab75f@kernel.org>
 <sashiko-outbox-200257@kernel.org>
 <au2_PPpdAMgRJZtX@gremlin>
 <CAGsJ_4yWQom=cG5vw2B-FR8+7wNU+rwZkvghjAxusym+3OH96A@mail.gmail.com>
 <CAGsJ_4zvRSUSspBe_hNwTYDjK3-TLuq6Mhi5gDyOPZGDXN8gDw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zvRSUSspBe_hNwTYDjK3-TLuq6Mhi5gDyOPZGDXN8gDw@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: k37qaowckjp1rjr8a1gnt3un5pkzxmge
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5EFEE100007
X-Rspam-User: 
X-HE-Tag: 1794227183-624313
X-HE-Meta: U2FsdGVkX1/ts8pRBR4JuJHbS3U8LF6XFIKWyzC6O6Kg90upzkWuF0CZW5yvJ+sz7GbqtJXbS395Y3wvBt6ED1pq/rLr3Nw9kyoA7WCFZqEelaHxHx+Wf3Ul9R9xjdlFzrp6TtLtEv93Y74r2zmYCFX8fCSwfYP4G9+gsB+LZd/NTR5ZXmba/76SD29/siRaf00aF3EgOFcG/WrMXtLJu7MvzYRBUX5yNWZyHM/MkeW+zmXZZXyl89s9t7OlXU6UVuseT6xbDXu5SkLcTSeWBdlLfwhADxZebmIKJSFk12AP1XeJ+hxAFhLqP9/mxiNqyDqjxzRWWbMO3pMR+ym3tppJLDI64Cgnk38Wqt86R1+FscJ+jseXfzi3X9eSsIl9mwqG35txqfCtMsskOK9/bRpCrnKgvSiyQ2kZFKR1YElcBvmSJeKqmvIk72+m/C7phiBenl1SAwlZeYBW2oRKgtJuvoHEScDzJHh7tE4+H9Tp6dQvdqI+KJYRBT/pNsrzs4PKgxMl4DGw2GDlWJxR2Mq+I6r3Xv25QcLIGTA/gpyUFaN9uzBJjtPoaT0bRyj21H05v5Aq0rAIK1ooQTMgeIOzC17W9nSB3paszHRHHQLjbl6JL9X9z8TYhUTO82BIYee68hBQaKPsKo1+tFpOVn/Z510nq3mlp3TO0cIbrAP6pslNaPK5yBcn1VlzQhh2KpyMW80tuINepggEa4rxafMXDcDKSTYi42hH3Ua2IIHVzD/XxU3JFlSEHaetBRsgkd52OKxgFMweU024MFEWjbb/lp1j9gy6bAoA9rL3UMtSfwe3tI/uJOOh0dHlZ29L7X6zXzTajmdzCC01EYSYvOe2+/CtjKiQK4wtk7wlee7XJwl11++nf/rrqELPvixBx5OQmpJ6DzboPjI7VxppLFdJR38jjPLNc4VFo0umSXFBuWYaqD4ZIMS82oYr6stT7dyQ/zC55QML8xgNIKO
 VTdKjCam
 D1RPKJheWRn8ESgfdlE4saY2k2hpvob/l1aMMNtKmLoOBf9DsscO0UAtqBz9hGDu7nDEYeHbRfMblfySkAhU39rDkpNoLYPPlFs1XGuOzwS9sMQXxTm3bt4ZUvJQ5bcx2mz7DGHs7BF8i3vk56JOIBrqKstC52YEBvgTOr3l3Hi5NA7KrffH6+yJwme5L967MQgCFFDwcf0EqLD6LocJFHKKo0vDAOmzOToUW5JSNya1kPFIQipsfXINUXiherCeghAQKXyl0BVd1tOENgAvFjyGEnCKUCcnC9jL2JxG7buWLVeBr2w7Tur7Eq87/RCJdVT8vnjmkzcAQtSeImAT68Uq378OXqVP8sI7A42sZ8FECaYDqzXfGUS+stex2lO+I13UVApXjJ203H6099UeHguFNY1AAC+5thmzRV4XpGC5cM2J6CWOcLAn4ju9bR2/9SSRGlbfU8oJqSa44DB1ZBGiI5SZsfjW4qvZO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 03:42:36PM +0800, Barry Song wrote:
> On Sun, Nov 8, 2026 at 3:20 PM Barry Song <baohua@kernel.org> wrote:
> >
> > On Fri, Nov 6, 2026 at 7:53 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > [...]
> > > > --
> > > > Sashiko AI review · https://sashiko.dev/#/patchset/20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org?part=2
> > >
> > > It seems these are valid, oops!
> > >
> > > Andrew suggested a fix off-list, and I agreed to this as an in-place fixup to
> > > avoid respin.
> > >
> > > I have also updated the series locally to reflect this change:
> >
> > Seems like a reasonable fix. maybe_unlock_mmap_for_io()
> > could have released mmap_lock, leaving the VMA
> > unprotected. but  ra->size *= 2 is still going there no matter
> > if the vma has disappeared
> >
> > For the original patch combined with the fix,
> >
> > Reviewed-by: Barry Song <baohua@kernel.org>
> >
>
> BTW, one question is whether mmap-based readahead is
> still worthwhile if the VMA is actually gone after we
> release mmap_lock (or the VMA lock). Perhaps we don't
> need to continue readahead in that case.
>
> However, we don't have a reliable way to know whether
> the VMA is really gone until the page fault is retried.
> We release the lock to perform readahead, so in this
> racy case, readahead might be happening for a VMA that
> is being removed.
>
> I'm not challenging this patch, just leaving a note
> to think about later :-)

I suspect it's one of those 'not worth checking' situations, VMAs can come
and go at will at any time and theoretically you can do useless work, as
long as that's mostly not the case I think we're OK.

And in general I think these code paths need significant rework before we
revisit stuff like this, we always pay a tax for code complexity!

--
Cheers, Lorenzo

