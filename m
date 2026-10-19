Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60EC3CCF2E5
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53A5D6B00EC; Mon, 19 Oct 2026 10:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EB696B00EF; Mon, 19 Oct 2026 10:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DA2F6B00F0; Mon, 19 Oct 2026 10:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E4F96B00EC
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:32:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A65A1160778
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:32:05 +0000 (UTC)
X-FDA: 85339615410.25.1EA85D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id D0A8AA0002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:32:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="NbQxnj3/";
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792420324;
	b=WqhvPQSDP+NrGgHIqfXmgda6XewcTQI5HVPfzGgyseIYHlL8+huKbn27Jqij4C5RwAi+km
	Uod5FEh6ltunpm34szok2ns4xk09zeBOHkRCQf6zvnVbUE6z511p+SRdkDSdPfiI1DZGIO
	Xd4+WMCCVxHXyK3tetjDaekPPJGWV3o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="NbQxnj3/";
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792420324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZJgfKZnh+KyHBRkUlFc9hON0UASMOT/JjSHODOYQjQY=;
	b=E7Wh7d6fgt62SiwMLHGtwXQL0YQfdnoKNvbp/+YPZ/4ACHk1AW7hY8DduFNoE7UVyNzI7s
	pK9xyAO4HeKKBYou5ezXslf4zQ1WpZOI58YcHUCBZBTJhtm3Y38fDurWzBIcXDLdVeJFpu
	8LhIfW08jL96ctr9Zn+v3L+fF6PIZ24=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 34A3760136;
	Mon, 19 Oct 2026 14:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CCD1F000C4;
	Mon, 19 Oct 2026 14:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792420322;
	bh=ZJgfKZnh+KyHBRkUlFc9hON0UASMOT/JjSHODOYQjQY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=NbQxnj3/eQBeNqoeo73Qu4NP8xi/B4Sf3/zzgGqRCrR9TtTqb1srXCyjVPzsptdCq
	 Mdj9cF7/chwDMEvqqytfujGNn2YpdV0wFy+VT6pZ4tX6PTL6SPHBMSSZqmaYp5VNAl
	 Dc6Qc/hmR9nZxdlYLk2bIYE3z9nJba7LfNf8e0ps=
Date: Mon, 19 Oct 2026 07:32:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan
 <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, David
 Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal
 Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, Randy Dunlap
 <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, Daehyeon Ko
 <4ncienth@gmail.com>
Subject: Re: [PATCH v2] mm/vma: avoid spurious write locks when
 mm->mm_lock_seq overflows
Message-Id: <20261019073201.aee381fbbdf2edfdd0a68754@linux-foundation.org>
In-Reply-To: <atYJA7nIu_RwpoCC@gremlin>
References: <20261016-fix-vma-lock-overflow-v2-1-9eb778b79b58@kernel.org>
	<atXjbsDn7DJybsHU@pedro-suse.tail5790ac.ts.net>
	<atYJA7nIu_RwpoCC@gremlin>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 79pp1u399emfo6mprdikkmtdxh73wstp
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D0A8AA0002
X-Rspam-User: 
X-HE-Tag: 1792420323-235310
X-HE-Meta: U2FsdGVkX1+4/d/w9E/v/lLI6jaKDGJSeumu5c/pDp05GOuRn9Ca6npZC8N+fTcvx2BCp4Qar0i17681S3eGmzz4MLOQZznU9FB/l9ld7laf0F2LXwMjqJAhr0QypChkuJTJo7FClUIg5PQT0KmM29ELGgy8JNglVG7FFGI/ztDxiDQfzA0wD4GBNZt5O62F0uF3AkhbfCZa6E1nQLGcPIIbAH37QxEM7DBi2bUUcPmybVZchPK5iMEKzG+sVy/EbzM9fc1rh/0MTg/cdJIZ9fBbs6gKGOSo9ASloc4q8sd931ss9IliOAsHNzFBNPtLce6GATdmi1UAPGSeKI0mxCdQXHmyABdEWkLsru+TwK3moPsudtWVCk8Ee28l2qkvLBM0/sUqt7Tgynvn7FSQlXBLUpiljnDFKUL6XB0TKmdgJJYIICbsKa5PNZSe2o2ovJxgB4Ak+Ul0zHqy4CxKdj6k4fUtIlAhrxksPeIdCYQgd4bldjnYQGuNmJc8h2L1Xhx2G97oGIC10UJLhNOA31vvLk2tElLbJF5LEkRzkBv1VPKGB78TS5/uEUr2i4ylV4dhGLj9jENWOC1B+3Ionl5ADzTdYJ4l6dPyM58k2vkDtROnblrtzyKaQbBlXfvl318PYgV43c42qpjxX7i83LICQLvHMADA6cx8V7AJSw1v4VThi3curFsuv8Tfa+mlHKxwt+vx/lwqgzD3L3ZUUkk5EDnYJsquvIJ0aXX8ayO4sNwEq3u3TECHozC/6xUzcc1e10l5EiY6Fwi6BtchCFqFHp5mMXtKaeaafW+uFGPh08gznzyZM6rw7DN0QNu041ReZ2IOUQUwSXcFI26Y+d5evpqcqodTt5YCtBwWL849Nm8CK49pg7fgedGIhahg5AoxDhVPq9oU6OhQJY6huzflxAd09FYFg5MtE5KbtZ2iv/ZribE8m86UvifQNdfZJBxBdP6WIqwCqqKfBDN
 OMz1leas
 usJQxBAU9+3/0FEFpxh9mVbXUH98Jm2D/y7feOgdoMPEWGA5Og2dmkzlkJaWSXcs0A8Kogn+evsl/dYpv9g6jFODeXSHFK5I1aVx2Eh/lU1/XvefuCeofxABPfACTtTOsRUGE0GMD4Syz3g09EoYddDh5T9OOWzeRVFZjkr1JwAEQO4mwemrKoBoc4kHJXOscE6s1tGdn+DVxBRFnpQE4WVuvUVYKEc+DHSaM7QMll86a+eYVc/JmpCgzyf/gr63soSmIc2reNCZtk0eaTYk9MvF6oZ2K4b6aR3cgGQvSek7Gc4BtHtC0SWHhzzfFYlon43mn/jGrfizk1G3Cr8Q6RoQt1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 19 Oct 2026 13:19:45 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> On Mon, Oct 19, 2026 at 10:53:27AM +0100, Pedro Falcato wrote:
> > On Fri, Oct 16, 2026 at 12:34:33PM +0100, Lorenzo Stoakes (ARM) wrote:
> 
> > > So I think it's fine to just send it (early :) in the merge window.
> > > ---
> > > v2:
> > > * Updated comment in vma_seqcount_is_write_locked() to mention the VMA
> > >   being attached.
> > > * Renamed reset_vma_seqcounts() to __mm_reset_vma_seqcounts().
> > > * Used acquire semantics in vma_start_reads() to avoid race with reset -
> > >   there is another acquire immediately after this one so it should just be
> > >   noise perf-wise.
> > > * Removed stable tag, will do the backports manually (just make the value
> > >   64 bits...)
> >
> > I guess you're fitting this where __vm_anon_pgoff_lo now sits? If so, then
> > this patch probably wants backporting to 7.3.
> 
> Ack.

I added cc:stable to the mm.git copy of this.

