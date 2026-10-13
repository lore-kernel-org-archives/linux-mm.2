Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21501CC6B0F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 23:12:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ACAE6B0088; Tue, 13 Oct 2026 19:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65D086B008A; Tue, 13 Oct 2026 19:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 573BC6B008C; Tue, 13 Oct 2026 19:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5BE6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 19:12:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8A02BA03B2
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:12:29 +0000 (UTC)
X-FDA: 85319154018.21.32D30BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B80A2180008
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:12:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nh0uxDtZ;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791933147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=chWKPe6Jv6DSrpAzSu8B8yBVA/m1DZxXRX4ZIJ40tPs=;
	b=d5mgJ8EFlKruCuVc85Eb3Az4G0RyRpOfjsgeRmOeL3ciywvqGrD+A+1FqwSxibdUux+7NA
	VaAb3jYuejOCeTvzMtX5/zoT3smMcjpbEOkJZZRhKGdh3shye3vbalbv/ph2bKCdxtNRKG
	nIjFV7KPTcRGudqTHN340a34sJASnJM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791933147;
	b=0zxudYeskTohkckPmqmb72jWXDZtK59wAsoyJIcnjPYDmWKd4qUYqZTOV5VhfS9GlHXvh4
	ebjI5KnxIPqfBynJRJt+3H+ubEBTW7yqCZztxXOPD9VFH9BifPDFI7JCQpJYhESLyZNvic
	wYSi1suVPRgFlLyIgPd3nLvbWwZldgY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nh0uxDtZ;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 668FD600CB;
	Tue, 13 Oct 2026 23:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB341F000FF;
	Tue, 13 Oct 2026 23:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791933146;
	bh=chWKPe6Jv6DSrpAzSu8B8yBVA/m1DZxXRX4ZIJ40tPs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nh0uxDtZ9iwQ1ZIEtlXgAVgxR0jRhYBNM8kDLNiv95iV5WEL1a3Sp9b6a6OaHqemf
	 3aqCellWqqAGtRlWzYIuN+WL2rdrschvIrwVoQ6yopfczTVqRn3qCDIZeX6ZJ76LPi
	 8TnyEBudwHh0wO4116e4p5lnM1SOpT47j/JdypWI=
Date: Tue, 13 Oct 2026 16:12:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harry Yoo <harry@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph
 Lameter <cl@gentwo.org>, Suren Baghdasaryan <surenb@google.com>, Hao Ge
 <hao.ge@linux.dev>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/percpu: account full object size for percpu memory
 allocations
Message-Id: <20261013161225.9286887bec0ee7fe6627aadd@linux-foundation.org>
In-Reply-To: <as6q8H5qxb5Gd471@thinkpad>
References: <20261013-fix-alloc-percpu-accounting-v1-1-03e788a1e41f@kernel.org>
	<20261013145424.341cb25ffdd488297bffd1a1@linux-foundation.org>
	<as6q8H5qxb5Gd471@thinkpad>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B80A2180008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: cdbfqchkr9ape75rzpdz4w7suwmra4zt
X-HE-Tag: 1791933147-417868
X-HE-Meta: U2FsdGVkX18bmy92gT1mLIxyZbBUOD8V9ES0h65UYud8Z9TicjB0BQ1jUAnXO6afCmUYaog9DFFQUOZy5d8SIW0bNmF84IupQT+z358/oZNupKh/dzceu4P/sipekSeZSsQk5Z4RIro4oSc3TsORow3z+8069D6smwpqYnx90thkiKEcNoTeBZnWfV19QL0MozBcs+izMJxviM1dAXiHayKDJhTK/u1Xxuk5Yu/ng/eFvkJUnoDTLqkF46B32I05/fTVNGTFjj2cSCeaLqkyU5rwd+ZRHclRIChwB7K48JGeNjv4EoqVAr+ZDHN0upRT9dqadBnXWH9qTknsCCVYt4aUXMx3i6MWt4XvmjuvNLbQ2E+G5Tj7p70eGsTA+N8+nGG5GwSgEbdUWgGvAqiTIpm4ub/ssr/9pleQsQ6rwU/q3lcHqGkbIw7K/ItCe4yqbN9+5Eze17zh/hkfbXfMSsVlY2kU+lqrEvFSIE6XtIib6KuQx2sn17U1MLG/afEikYjBBQ/hUAWT/2Tvqqewq4pPCFpRLaqwfDLIDFDxx9vp8Mgkh98ThAtDUg8ExkAmEFBCDYgMXg9vYpM2iVbuuq9+GNS2x5R0f2PJ/tz/+IjkxqgqMS/1N/0N8VW2tpIb2nzi9MS7YOra/OahWipzHGb77gsNvm4z43BzUdxJaDTahQ9SaPs28cgT93Vbv6rd/qOHlyr31wj5FGiUUpw10dx8iRh2dtHV5PNv7Bt4gDX0MSsEMoUx72llSVeui+CI+IwkK+9ryep6gOI46xUHM1ezWJN02t3tawQYVvsGg24o2DzpEWvGAurNSdYi9OX/tjgAnvh3FZbpVnTUPTKQJFpukhlzgc46P7TJCMsLtTuqE04P+PkgnJMxY0SEbJz1MzJdXNskVUQyZitFlqJfnEVpeCZhNKUxil12trmnbujt4Lbu2qF/Tceu5uG6AAaqoro8GnBQW9v6xskrM/T
 tuynsSo5
 LgfoPRKBNUTuiNl4XwDTuklg2RU4ChCMIDqVyDCfPnSVZQnBPUS0E/tztq1zBMfCyA6OLW4HOKKHNRAwpfXFaL5Pbj8hYxj2gntcZNVtwIjmxT6oki8aGCBqeMTvGWSggDoeM+Ot2IXjVFqcQXnv6tem8wP4dOg831/p6uR08u2UARUKaZELEAje41hht3lQVfkfBY3aRyuapzWOUeGragdI7HIe4xSC1gLcaT7jLMhD52bNdVENwTIuHKUYcn8Ye+oTs0yKZXh09W+09bcunhGQFvNNpGvoq5btYO1NbzKKiiWc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Oct 2026 23:23:17 +0100 Harry Yoo <harry@kernel.org> wrote:

> On Tue, Oct 13, 2026 at 02:54:24PM -0700, Andrew Morton wrote:
> > On Tue, 13 Oct 2026 20:34:39 +0100 "Harry Yoo (Meta)" <harry@kernel.org> wrote:
> > 
> > > When memory allocation profiling is enabled, the pages backing percpu
> > > memory chunks are attributed to func:pcpu_alloc_pages. However, the
> > > accounting of individual percpu memory allocations via alloc_percpu()
> > > and friends record only the size of a single object rather than its
> > > full size across all CPUs.
> > > 
> > > As a result, it is often not straightforward to identify which kernel
> > > code is actually responsible for percpu memory, because the size is
> > > under-accounted by a factor of num_possible_cpus().
> > > 
> > > Account full object size with pcpu_obj_full_size(size) instead, which
> > > multiplies the object size by num_possible_cpus() and adds the objcg
> > > pointer overhead. This is consistent with what memcg already does for
> > > charging percpu allocations.
> > > 
> > > Verified with 64-CPU VM by spawning 400 processes in a memory cgroup and
> > > measuring mm_init()'s rss_stat counters.
> > > 
> > > Delta of kernel/fork.c:1142 func:mm_init in /proc/allocinfo:
> > 
> > Please make it use mm_init() rather than func:mm_init.
> 
> This is the output format of /proc/allocinfo:

oh, OK.

> https://docs.kernel.org/filesystems/proc.html#allocinfo
> > Example output.
> > 
> >  > tail -n +3 /proc/allocinfo | sort -rn
> > 127664128    31168 mm/page_ext.c:270 func:alloc_page_ext
> >  56373248     4737 mm/slub.c:2259 func:alloc_slab_page
> >  14880768     3633 mm/readahead.c:247 func:page_cache_ra_unbounded

Well that's odd.  What can a caller be other than a function?

> > 
> > Why cc:stable?
> 
> For anyone who uses memory allocation profiling to understand which
> code locations allocated how much memory, it gives a false impression
> that certain perpcu memory allocations are not as big as they actually
> are.
> 
> On some workloads percpu memory (func:pcpu_alloc_pages) shows up as one
> of the biggest memory allocations, but the actual users of percpu
> memory allocator don't show up as they are under-reported.

OK.  I guess it's a small deal, but a larger deal for allocinfo users!

