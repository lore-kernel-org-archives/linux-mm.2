Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47E50FEFB54
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 14:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A68EA6B0092; Fri, 27 Feb 2026 09:46:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EC6D6B0093; Fri, 27 Feb 2026 09:46:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F82D6B0095; Fri, 27 Feb 2026 09:46:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 763716B0092
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:46:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 243945A4A4
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:46:30 +0000 (UTC)
X-FDA: 84490512540.21.E801B44
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf25.hostedemail.com (Postfix) with ESMTP id 20E9EA0017
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:46:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=C48u6fGI;
	spf=pass (imf25.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772203588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ifbx91T1EVW22r0wWKCJQbDbuWq+ff07mPFba4tUWaM=;
	b=6oM7H3iuLC1vPBtXjl9s+a/qbfAxtvjmbBaOf/heh4bzng9jl7T65cbd8G+C+0SzMk7FmH
	6bUjQLGbPK/0qQ8Uqv3fUFt49xGo4Xi9pkmHizIb3y6GXDYW+QjlNY3ZAoTEClPumOns8O
	EAbQ5Xs9U8Oc/jATH+vYxR6OP/M6zVI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=C48u6fGI;
	spf=pass (imf25.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772203588; a=rsa-sha256;
	cv=none;
	b=4zbvTV6Ql5kcQZFOgV8SFB2VKW9SElPyUVFzpnMmFhN98aC/vsIy3pfTJrTihYBFhooMi5
	QkiTnjSCjlkq4+wgUKwi7/cwN8y+gnApH2lcd9voHiMZLRB6G8KfN/EQNa9B6kUr+IrFmW
	2BtJPPq4+ZpLnNh0n+LrHzai55ywFfU=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 06DFEB2E0F;
	Fri, 27 Feb 2026 14:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772203586;
	bh=Ifbx91T1EVW22r0wWKCJQbDbuWq+ff07mPFba4tUWaM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C48u6fGIi6TakoiiyLCPZszKruRGU2YBmMYyVdsHmWQ4YHq37kxnUfjtSxRj5Mrcv
	 eAFQeCrkc9ZU33UtJsKXyXqCV0fI1s1tIOXVLYcuHDYrwYDdQdh4sP9kuQ6HsdhdQ5
	 7SfZFndBozlYu76CVf5I6k+6mOH5be2y1YUi2g7M=
Date: Fri, 27 Feb 2026 14:46:24 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: SeongJae Park <sj@kernel.org>
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
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, kernel-team@meta.com,
	Benjamin Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v3 3/5] mm: convert compaction to zone lock wrappers
Message-ID: <aaGuQFaCij5hvw4N@shell.ilvokhin.com>
References: <01729baf359e4c6612aead53f1fcb644f782d1de.1772129168.git.d@ilvokhin.com>
 <20260227004554.83555-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227004554.83555-1-sj@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 20E9EA0017
X-Stat-Signature: hng4es6gu8uxgftsss99ch64ge4pw3xy
X-Rspam-User: 
X-HE-Tag: 1772203587-884829
X-HE-Meta: U2FsdGVkX19oWvDU/LNt9/EThhgcAyH/VvkU15p7L8f3aXBs39PpxcsqPx4bxRfyq7HXeKTKY94Ef6K+80o3XxLzCokBhJDyIk8XaLg8Ihn4NIwBk4RYDAKDZCst8bm0bWJj60tZ0dMgKPTrYmL2Pb6w0WLrLoYGhVNEJHYiQZqJLBhjsO2yKp97x5jCSijdGaLt0vze/1Y6xeFS8Px7Jh+4x6Et3CEEpz7RdwnXGlTjf4u6K67bAFc4cTaUPdteWckcV4bOfSIKBSrptK81bdPoCE23X3UQRmlUhB99iwF8AVRKPqqdYSejQXKYPgZmcf3fX+tNEY1V1ZNZ61E2Jx1+fwitpRUgFHnUBIAIistg19UU1Kive3O/7lro97yM/cVyePw/gkOQvONtf787vOq1epMbv9dSFNi0FHFdssV76uV+lC2xY6rolNPKniWvcEzs/QWEpctMAb2XvQRPkOjG1bO9c8mGReq8P9VRfjusag6sizVuvZo+0tVlrhGRcwjZr1p/FZRr1eQ8Q024KcDXkGQ+Dbi4NVX6QeFkIaXRTCoy7yCBDDAWYwdbOy1begUSX4aSEQBcXqyfjIEXwTxX0mKbTMMn7aATMvMgwbIFY0OfD5VihFFdBoHPW6hkZqATolFMZcVK2GeBxILkChC3XVYjcXT4Imn+AaodOWXuWWcFLQZ3LDlsvMuxAP+xVyGO5xdinFPUuaE2dXZORtLqmsbNkntS5Wfr954hu3mU57CkEFU70Fs8C1159oiDQ4YcD4XZ6K32SzTtSVUoK5Gu1Snc4kwjW5TVJMZnQzuW2fSY3W1/ZNd6MU1PemvBuzXVYK0aCWCu3Ox477zE4dsJX0AEDOQ4sw58/OdayVnM9woUJJpZY2SsuZlLwxqxirpy+y0j8bRQJKdkNDl9OpJ158rxaggo0aXQrzvva3EvwongVRhtHoc4XqyGEbYkUsbFYD68LTGzkRXnhxO
 vbhaOCnh
 Jw55W7VsSPqKbwveng9lqJYo7IMtXE0rdDSzjnAxGh5B/kc7c/PRi+gpJ7xfgcb8HwBqC1DTA+5hIBx6Yk/g/KXgTlt2tIj68dwSJ+V9bO0Vn6q6SzFG85Ah0npbWEAoH0PiuVffwwWNs1AnskkhAARLi+e1CskiZlMCJqus1ENJLgkpF0/0eNdS/YPoLmXzjwbYhN+itB+jlEq5Mz4FYNMiXwp8S0wqY6L2TH4Hq6URqT8AzBzdDQAExFKImAPPKJXJs9Nk058QIfWyvpLaxeBJGJs991L89jfq5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 04:45:54PM -0800, SeongJae Park wrote:
> On Thu, 26 Feb 2026 18:26:20 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> > Compaction uses compact_lock_irqsave(), which currently operates
> > on a raw spinlock_t pointer so it can be used for both zone->lock
> > and lruvec->lru_lock. Since zone lock operations are now wrapped,
> > compact_lock_irqsave() can no longer directly operate on a
> > spinlock_t when the lock belongs to a zone.
> > 
> > Split the helper into compact_zone_lock_irqsave() and
> > compact_lruvec_lock_irqsave(), duplicating the small amount of
> > shared logic. As there are only two call sites and both statically
> > know the lock type, this avoids introducing additional abstraction
> > or runtime dispatch in the compaction path.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > ---
> >  mm/compaction.c | 33 ++++++++++++++++++++++++---------
> >  1 file changed, 24 insertions(+), 9 deletions(-)
> > 
> > diff --git a/mm/compaction.c b/mm/compaction.c
> > index 47b26187a5df..9f7997e827bd 100644
> > --- a/mm/compaction.c
> > +++ b/mm/compaction.c
> > @@ -503,19 +503,36 @@ static bool test_and_set_skip(struct compact_control *cc, struct page *page)
> >   *
> >   * Always returns true which makes it easier to track lock state in callers.
> >   */
> > -static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
> > -						struct compact_control *cc)
> > -	__acquires(lock)
> > +static bool compact_zone_lock_irqsave(struct zone *zone,
> > +				      unsigned long *flags,
> > +				      struct compact_control *cc)
> > +__acquires(&zone->lock)
> 
> Nit.  Why don't you keep the indentation?
> 
> My impression based on below output is that mm code prefer indenting
> __acquires().
> 
>     $ git grep __acquires mm
>     mm/compaction.c:__acquires(&zone->_lock)
>     mm/compaction.c:__acquires(&lruvec->lru_lock)
>     mm/khugepaged.c:        __acquires(&khugepaged_mm_lock)
>     mm/userfaultfd.c:       __acquires(ptl1)
>     mm/userfaultfd.c:       __acquires(ptl2)
> 

Thanks for spotting it, will be fixed in v4.

> 
> Thanks,
> SJ
> 
> [...]

