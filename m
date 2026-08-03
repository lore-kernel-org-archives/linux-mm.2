Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70972C5518F
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:48:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 753486B0092; Mon,  3 Aug 2026 08:48:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72D346B0093; Mon,  3 Aug 2026 08:48:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668266B0095; Mon,  3 Aug 2026 08:48:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41F756B0092
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:48:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC4F81A06A7
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:19:41 +0000 (UTC)
X-FDA: 85059561762.07.D6D2C82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 390CE80006
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:19:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ng5+8DMZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785752380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Calt/307KNtJWkdgXAaLvbQuXAUY9A61wZewMbZh70=;
	b=jQlchLaBGGLbEZcFQqso6/c3iZC1ZgC8o0ZzwtSWcsKtWxSS7MknOKhtZNuienPLbX1ri+
	uzpoZ7gcCwj+MpXp816GkXEUWUMsLHMprNb8Gs8gbIbabefOnYmTYc8lCKQhiMV/Cp11Ju
	A+9ixcpDzLuhrfP7YMRO9FIoH6bc2S0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ng5+8DMZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785752380;
	b=xgQV++lKmPiXE+bd0+Ta3pkpRrLgH8erXL8G1o51m/cQJY7ZYaxUnXoYSCbHKT5GT+Dt+G
	hpmr9U4osJS0Fy/tis8Igg0bvZ4s3tSp36Oxfj471cVA0YD4X9d0nPZeHJj/rzZzG48QkA
	hCS8/aTukF/Q8CN5Hnov+X8/sKedkto=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3113042B0E;
	Mon,  3 Aug 2026 10:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC771F000E9;
	Mon,  3 Aug 2026 10:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785752379;
	bh=8Calt/307KNtJWkdgXAaLvbQuXAUY9A61wZewMbZh70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ng5+8DMZLWORmfsZsD86xD4jesgzvb9X5altilrjo/7i9jmsg7xuKWjOJ/gfRV5tO
	 8fzVFdM1AIWECwrfdrJ+TXz2wZLM+iclMvXu4n30Ls6HFiva8ZNxrp4gyqEilXbqnZ
	 6BAZcBS/dOD/8BPCwmOigxUn9lQIrS2VqYBNXPqfOMVmS+uRPQ01Ve9VdV/ZfP3E6B
	 ts3Tw7GIIWTaJQTeTaSwKDpF6lLcECWEXdqN2Ml3JxMKEEC5KbJajQYO9otNUffjEw
	 DpyBexfE3thgwcsqwEriB9WeApPb4CMgalZLCUSwtevtR5O5x4yU8qqhqcqZUSo0ys
	 bVC7pGX6AxNXQ==
Date: Mon, 3 Aug 2026 11:19:17 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 04/15] mm: update print_bad_page_map() to show
 anonymous page index
Message-ID: <anBqV9z6hVLIqoIn@lucifer>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-4-e8ecfefea812@kernel.org>
 <amrvgjPNfKqWPUU0@gourry-fedora-PF4VCD3F>
 <fec1be38-406d-4656-95eb-048729afec40@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fec1be38-406d-4656-95eb-048729afec40@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 390CE80006
X-Rspam-User: 
X-Stat-Signature: 3qeqgyrkjpjb3keo16cfba45aitqkbp4
X-HE-Tag: 1785752379-395332
X-HE-Meta: U2FsdGVkX1+NTixm226Rh3tLsjZ+1x4HS7dJnGUkymSkw6tVVbTMgivW5dszP1BFQQg9xVw47T+cn8GyI8yG5KEILdCXYCntPsz4DQO3oxZWRo/T0xgISmmgPcEieLh0DYxMXMmibg8GgowzQdu7EMxCKXiM4oOyxMOhSMdZwMZZEGhJgo2t1NrfzgUx1plLB0iBraN3pp4XgC/YXo94Jvw01PY8xN5ZdPyrnc6YTwm26hkqip8EqLnlx2a6fjNMQQ3DLo7nzUn5EjmxOlwTltaF+ur6lJaV9HtcxsyJF1joPwJL9J2m0yLz/+/yQHq63uyrisRE4HnsSPiBdG/7cuVnWpis9KDmt0DHSv5Ov1ZbFTVgGfYN3KMmEBg/nLMhcC+hOhx4bEIw6FyrDxpLE6k0K7oBdgI0IvK5TQoTptxvuHx35CZ3+4Q66Ub3A3W7X5QE+Panmqj1aB0g7sjZOH7p8iXgkN/2FYko63OyhgM1KApDJ8hVwJ/uwU80yjL4Nq9+woJ0viLePblPuZT0AKBeOo1dDDVUXD7DYFU4lXjf8Ok2LpEWUS0DtVnia7ndMieKdffmNPBZGPZV6K9x4BI3rfH1edEOrAJZzzW+T+635iQHnSnjD4/iOWxfAJRPSd/g7lXiK7UohKiGy20lSy+dnJmsJM9922Bh9IguGI5TI/mNchP8DyuxNoDozDc6Z8RVCSbeNZAMu0KkV8UK1FsdpGMu2sbVKFgT4NJh+Zn/kHfYeoftbrAhs1k9LUQLue+bxzkweMlfelIOvf26KI2vGp5aDUSknvRg+5OFH9T6nWmo/TO33WjN1DrIaV07tnrr4CajySasHg/jG4YhfVMwZZ6MCMrllHpqWsQGwTj6L4UcY+UhsbsRQg2S6yVBmu0OjK3EG7A0zezHa8ZnFhHen9L7FzN/SW7FhyYv/zc+Bs2zY3EuBr2gq1tJzZUTSogaAnzd7/nH00xANaD
 YJ/Lg+gC
 ZyO1bW5L1+uW1HrnzrTdMVtjaH7zil3kT40xd0qtrCEaNxUNO4ovQ155kWqwtjSaRbzt23cLzWfeksd7I9c454aUKYIzbrdBuOyuRARma6X27oB0iKDMXhb2A6DCvHWFpXq/p6sMCXVIuDFIv/E5N806Xed1PJ2hF88+5yLpfa0YIUkSB1OFeO1xnjRj40DRqAFkZPqvqnwWf5SYSHYl5WsE5H+UyL9qFDUIFxxZxBCJnHOjM9m6v6q8Nb5GshoXH9bbocHSN1hjeSQHUcSmlWhaDA4ohdqPSjJr1mBh6MYiqjz7UGoJSLuxsl9z4BiGn4V8GLArKti1w8sG5JZv1VtH7AgWa+n2QXArcWvj4xYk54xbh+P27mpY9Fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 11:39:11AM +0200, David Hildenbrand (Arm) wrote:
> On 7/30/26 08:32, Gregory Price wrote:
> > On Wed, Jul 29, 2026 at 05:48:39PM +0100, Lorenzo Stoakes (ARM) wrote:
> >> This is potentially useful debugging information and matches the existing
> >> page offset provided.
> >>
> >> Use the raw __linear_anon_page_index() function so as to always output this
> >> value regardless of whether the mapping is file-backed or not.
> >>
> >
> > Begs the question whether we should mark the value based on whether
> > it is file backed or not, but i suppose you can gleen that from the
> > other printed values (anon_mem, mapping, vm_ops, etc).
>
> You mean something anon_pgoff_t or what did you have in mind?

I suspect he means e.g. adding a (A) suffix or something? Like page offset xxx
(F) or yyy (A) I guess?

For anon_pgoff_t it'd have to be a typedef struct { pgoff_t val; } anon_pgoff_t
to be meaningful and then you'd have weirdness with assignment to
e.g. folio->index/other calculations, and especially linear_folio_index() which
returns the right pgoff_t depending on file-backed/anon :)

So I don't think it'd be helpful, and the asserts already prevent incorrect
usage.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

