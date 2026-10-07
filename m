Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45AEBCA6002
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 18:32:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C96216B0088; Wed,  7 Oct 2026 14:32:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C476B6B008C; Wed,  7 Oct 2026 14:32:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5C7A6B0092; Wed,  7 Oct 2026 14:32:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94E076B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 14:32:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 254374031E
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 18:32:16 +0000 (UTC)
X-FDA: 85296675072.05.CDB4F04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3A30B14000D
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 18:32:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0OS5oqUL;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791397934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wXKdwWcLRR3vqhF5m8FLcwJNO6f5rIMeMs9Q/KXzZf8=;
	b=ZYlyrexDtLeEexD4ZeSqSJDY+QCjrE8fn7QxeVJxxl00INM7sO+8coCAv0RShnnNYJmNUG
	xn7QNHexX0v/GPN01EG1H7DEYAWAAX6EM7T8VEt4WRpglQ6pjQkxtA4aNVE2jar6/amHft
	+epJdLxiRX9qH4Qrn/S6BnzjaBcQoh4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0OS5oqUL;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791397934;
	b=Ex2yfMuNtl/unUevrmqsJkGpq6ork3UfeF8+fO8OkU/XtcNcF2PgAyvio1I5O9SLauSku/
	hNKWaQcnuPM0kIV3t7USVjtL/dj8CWyqE5yneEexx5om5TBRzCXYdu1cEvZcYjhoKMm7R4
	LE8E4vNcwPaqVleOad7rkpEmykYADT0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F29440B04;
	Wed,  7 Oct 2026 18:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1841F000FF;
	Wed,  7 Oct 2026 18:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791397933;
	bh=wXKdwWcLRR3vqhF5m8FLcwJNO6f5rIMeMs9Q/KXzZf8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0OS5oqULRyWgpbfqTjnQ3A6FT/xShl+lOJRGnqnpayMFTGZE2Q1gpaPQrq67yZMSD
	 h2BPLZh0nae2J0BGQ8zjMgPRwmWThPrhTHqAcGCM+aZbxYDTKECvQxUwk7/PgXMxxq
	 FUIpn1VMNp5ow95ENmcKXxp12WAJRyWodq3en9pM=
Date: Wed, 7 Oct 2026 11:32:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Harry Yoo
 <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan
 <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-Id: <20261007113212.1fa804db80cc6f534ca01a59@linux-foundation.org>
In-Reply-To: <asZCEttmL6VlMXKc@thinkstation>
References: <20261006091815.897133-1-kirill@shutemov.name>
	<20261006164122.ea9a673b336b8ac74725c35c@linux-foundation.org>
	<asZCEttmL6VlMXKc@thinkstation>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3A30B14000D
X-Stat-Signature: btiebde3gqubtdocf9ox6fmzi31ptxxm
X-HE-Tag: 1791397934-428954
X-HE-Meta: U2FsdGVkX1+JVL8Fez7bOACy3B+TajX9LRdC28tK2FZyzSbV6XuAjEi7fiOgVyBwa+hjYqW2+2qzNnTsJaMHxL270meqGoL9PscuK5NB9GndnMygS0rR6Z2WgfqPUAMMmJdA3obj7GVFWF9ZMQiIl0cqvRfQp0P6K+4KUyQjPIsF63bpwlh5pyC835vW86PkgLaiWxoW81Cm0PxErKU0aNsEqwTlLFNwYMqhUmcVgmwWI69zDxGr3n19gQdCmn0fXfVZYosdd37neP7CosEqq0H+/RWpx5wcUjQmHsdqP8Db2DlskMlxhT7I0sCIyD1wESg2rP0bm33uscJtJgX7zaYUYEiEAvwebz0uC2Bp6gDOnOMRX6/N58KbRQI+3IPhBXs8WLWxxmMngLJ8d1Yp+mjfAoLSDxHkK5TAOo0Du620bVMu4bvts+73cFyMnzQE2OUH2L5M1RqqYSSGbGojtzDe0Vxb7XwpFXUH2jPcQWRhzAUv1F5eYBvvxBkxGctpKcmfRZOwIClttPpK0NKPSEBpAbMcbcSoCIuVya5iy7gch4lz9392SsCKnAB2qf3zhrI13suwTEXI+W+aInirSiIgbCzMbzo8nSQZZxrrCt/8nG3V5i+fG51U49cRtI9T/nKPu+flz40H1yDGuDvSY0tu8AlqXzHa86tJBredh9lBu1w/Ok7GVqJ6pl8NM+3BozCAaGAcuhtu9RYkcPYhWeWHWf8F9h4fHFyMsQMgDzl3ka2duhCHeM6GwL9pp7lP5wZL8ACHQPtEL79PBnMUvdxkzvu572SZ1k457ysqYo/lStAd30OFM0kMrzRYXChUVQIGGVg0t4NAiCR3X4gJCuC8AcqYtckQ7eQ7/lCi1psfzJYAwgp9eqjOqJvmBUlSwaFUN/LAOdeo05UvG8T+kxb16HSyWKcJ40TvenY5Hqcevmxw/HbtiH3DL4ZxcCnNg5e2ksXfico5Aox79he
 pPSEOhyE
 ULpCHMSjyoeK2nQ7j3IjQggQGSo+JLLsDTUXfAKeFsSheHwZOoe85l/nrbz+Hh4uxaoHnYPCZvBlm+xcriYQgQvltXtPYcE6JVEIZU0rZF/8Hj+UHyVFGB3ghONr5GeY3XbYZIJ3WjpUwqzsahBusWwuhRs/WU5rZJR43EAa+IaPcLscMXwiRh4ITyCdW1gEeek0HDvTjH5/aiE4ontznse6oILslqREWvnQVuIRkNR2RcOvh7xfbBSszy4OrKSDl4j61kzSc8dNBVpLwOyskXnwqv+exf3paZAgqpH7qAi7mxH8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 7 Oct 2026 14:01:33 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> > > v2:
> > >  - keep the compaction priority floor and the COMPACT_SUCCESS retry
> > >    limit on the request order, so non-costly requests still escalate to
> > >    SYNC_FULL before falling back (Harry Yoo, Johannes Weiner)
> > >  - compute the promoted order once in __alloc_pages_slowpath() and pass
> > >    it to direct reclaim, direct compaction and the retry helpers, instead
> > >    of each of them deriving it (Harry Yoo)
> > 
> > Thanks.  That's a fairly large update.  v2 diff is below.
> > 
> > Are we sure about cc:stable?  Or even 7.3-rcX?  It's a pretty big
> > change.
> 
> I think defrag_mode is not widely used. Maybe only in Meta.
> 
> What about keeping cc:stable, but only submit it to Linus for v7.4-rc1?
> 
> By the time we would have the patch battle-tested in the fleet.

OK, let's do that.

