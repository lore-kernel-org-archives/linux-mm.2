Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD6D1C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 19:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BF136B0089; Fri, 25 Jul 2025 15:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770016B008C; Fri, 25 Jul 2025 15:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65F3F6B0092; Fri, 25 Jul 2025 15:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 52D576B0089
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:22:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E9FAA8090C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:22:14 +0000 (UTC)
X-FDA: 83703757788.09.829AF65
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id E96AB1C000F
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:22:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Lk5sxxlB
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753471333; a=rsa-sha256;
	cv=none;
	b=prOksbHAPOdCQ0WxwMtb1VhDR7Klxbuc+z0oLjMWrfWlgMd4Znb+FF28XmniE9k6lyztLM
	m8bxUzcQ4DkQChyHOn9M4NpQL6lh+zGdL/dzhpcfVUKrd+O84I8A0MRKeglV5reLX8/0CU
	bDExNqjotPeeYpAeaxTgUshzgLceFic=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Lk5sxxlB;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753471333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I09JIX/VR8UzFPSTS0iYzzlehYa6ZqlWHEvSJTEox/k=;
	b=kkzQyZ3xWgALfxVp1XfbwPjOSV3qFSoM9yr2m/wKizyrbS9804ks7INX+9W5SH4GIQ7EuH
	CDgspb0S6j9DD0s1NwnF0/sirp6AidqLXZSBoIbUA7BwjOSU/t0mM1Z5dBkyhRwKYg/4ks
	Z24M68iqk5RG+m9EFV8QbwpIb7Kq2T4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=I09JIX/VR8UzFPSTS0iYzzlehYa6ZqlWHEvSJTEox/k=; b=Lk5sxxlBaxLMJFagMCiKZqdsUR
	yUUw4QhQdsiPB7vCP1L81pqF4ODFPMynDL2BMvbek+zu1WAZCDgMkoYCdkpsYqjS2kORRMU0FWwzN
	9BhN5vNcygaJtEPokCcluYYZv2ezC6OYYWZH2/rRzK7vBa4FOaH/ro+OKi12v5Nusuu+up+AhEXX2
	sNFjpduilWWjvgPbVBizS/CrXhLUNw43Ismd+KKZ+gzJRf9JQaNqKNFdufKY8TvrscDMj23hlJ9bU
	3Kxc7Ms1EYRHq1RHCEcOA+1ldyQmfvjbyrZALPGXfQ2FrrLhy8V6JbCOCLPE/oD79UE4QhSdbIgYv
	+NByrhzg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ufNzZ-0000000Gxp1-3gXc;
	Fri, 25 Jul 2025 19:22:06 +0000
Date: Fri, 25 Jul 2025 20:22:05 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Li Qiong <liqiong@nfschina.com>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: slub: avoid deref of free pointer in sanity
 checks if object is invalid
Message-ID: <aIPZXSnkDF5r-PR5@casper.infradead.org>
References: <20250725064919.1785537-1-liqiong@nfschina.com>
 <996a7622-219f-4e05-96ce-96bbc70068b0@suse.cz>
 <aIO6m2C8K4SrJ6mp@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIO6m2C8K4SrJ6mp@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E96AB1C000F
X-Stat-Signature: joyugiqbyd6ie4s9yj739b1tu4i4cwwp
X-HE-Tag: 1753471332-31100
X-HE-Meta: U2FsdGVkX18JZnhmPyg4ZpMxXhq1183sBTeoCqn4R10yf9dDO+MUPfK+31S/lEVwVFZ4J85AtXPC+P7CSaAHW444+B/7UpuTR31uekexoqQJAc4/ym0VZ7O7NPEFVGnsqLgqwGAX6sROrOg6oIUOJCuVRIkXexbIMffe34W+pB0e6lu13lEOJKXYXOBr2wFlAxQsQso5LyUsxGugqptglqDUSMyuzkIW/l/QZMumdCgeeDRlIWRa+vJ9q/ocHI62LyzSKNreJ1Im7u415nUNrPO3tUU/RUbpbKJTTJZp9UxrZAn0xYT4un5OIFP/Bg3zIdu9UxGIrZ1n4XzZ/8KZeZjx9AyAPhBimNM71hb0FZxy7SO0wpkmTPRxtQTkKBsFaA5QZocsiSDj74DerEUe1tRmcRl7esITe+Sz9oRkbd43A1Yy+06DoBk605y462GC/z8wqPimvkr7595yq2jcZN5Q8Y8OQzPzAdnjZueFmj/Klih53MSfCmQ4INE6dZ24mCignLlN/XTt1YnElj4eQke1Xt/XsATHil1Js61gFwMv8sD/Aqi1PHbm1rjbwhPgcW7AxsFfT8UDlUl5rbpCWha87W8ARj6HxkH91rwYut7xAu6i1ObdiCY6ZBpSjDYKbwJ0zAglGOa/gVMIu54e3U+QIgkSgBl/+ITHORjRs6T+M1TRtTCmiIJIjQInqjQCAQ1c7kXrsXP1TinR8gANDYgq20W8lFZKoFJBIbPudEtrOjr+eOQaQ1tJfdJzY0OkK2lJ5YqJTHdBrDoDCQVam0A/Eiv96CQEY8jRE/yYtOD7t2K9we6dIB+dFtotU+FqsAzmvHK3i112X6HQlQBS0oRNzpNry5g7gbN2LidOuv3ZoraaaY8xTsNpfZ5NIRzys4nyCsK6YSacdWhmdTRmW2bt0inABKgKf5DdvOJCw4fQEzN1YaQP+SGfeLH3I9rSo7ZNB7E4Bs+ofM25qL0
 EQ/abJI/
 P3JNmf2x+X7EFXTx2h8acIlhX094dlIJZ+hrgAZnDbYzzlRHqTnKwaOjgp/GZvfufFIQ/euSX8KkCYB3y2PppEQYS3wkpn6tI+VzSc76Z2dD/lDPj3UaOqJAm8NIYj8/10qgB/UQZfnO9QKRKqdyjBdRqOYtkW7Vne+Ii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 06:10:51PM +0100, Matthew Wilcox wrote:
> On Fri, Jul 25, 2025 at 06:47:01PM +0200, Vlastimil Babka wrote:
> > On 7/25/25 08:49, Li Qiong wrote:
> > > For debugging, object_err() prints free pointer of the object.
> > > However, if check_valid_pointer() returns false for a object,
> > > dereferncing `object + s->offset` can lead to a crash. Therefore,
> > > print the object's address in such cases.
> 
> I don't know where this patch came from (was it cc'd to linux-mm? i
> don't see it)

I've spent some more time thinking about this and I now believe that
there are several calls to object_err() that can be passed a bad
pointer:

freelist_corrupted()
check_object()
on_freelist()
alloc_consistency_checks()
free_consistency_checks()

so I think this line of attack is inappropriate.  Instead, I think we
need to make object_err() resilient against wild pointers.  Specifically,
avoid doing risky things in print_trailer() if object is not within slab.

