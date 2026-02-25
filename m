Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 570B7FD376C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48BA76B0095; Wed, 25 Feb 2026 11:04:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 455F16B0096; Wed, 25 Feb 2026 11:04:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 396846B0098; Wed, 25 Feb 2026 11:04:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 24AAC6B0095
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:04:03 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5593C080A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:04:02 +0000 (UTC)
X-FDA: 84483450324.01.F62E245
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id BE6EF14001F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:03:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dj9Dk53q;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772035440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0J9g8glZ+C9CG7kUr9i2GkA6jzB/Q/+QP9Ox+/ZoIEo=;
	b=Z08T1/1vGJRvOefaynxlshsxpm5R89nGkX5TRbaLftL6zTvpM2USmEFtUmmxs7Akd4lIg0
	gnIMEE4TeRgrLjUc/QIJh//djLYcDITX0q/s+SWo77D6gxltsYibKff2DaeKcmuv/KliGe
	T2vsXMbNyYu9GmBcO8SsciFLHBADPYc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dj9Dk53q;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772035441; a=rsa-sha256;
	cv=none;
	b=x0qLLXAeugb7knInZKgGlzsZyH6+rmwrP7V1eiQoa2X611iFBtbnE3Tblz+S5piFMlsbfs
	9Q2mQxdP9pYBFS8buYp3ArVS12qoCE9Nw8CPdhjrfs5qhZd7NV5pbyqiqfUtqXkLBMKoqh
	Sis1HlmGuIiUBeJ3cpgvZChsWEH7AZA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0J9g8glZ+C9CG7kUr9i2GkA6jzB/Q/+QP9Ox+/ZoIEo=; b=dj9Dk53qD1T3gEZZjGN45q0fZD
	rQKifH55s16xa+rDffcwJr9feocDEB0brkJJxpJwJgJQ9uv9xFTbIPNpSTgDz+lEWJHXEPyVJC7nD
	Y2DD3D+KwdFRDllP8yehqZYVfq2nIVjT4R9wLmXdivXqDf6olo23/DmmW42AVwx//Bs4pk3iPQ4qq
	vhk+23SLbevluYXNxnWvXg/TVqyScR8gOXssjFU/rG3rP8QtQtriv5rst9CbUvCK2I7r8MrLvYWHH
	bqsXwasdupeD2FfwhB3yeJ9LKc9Prz2LUsLCTRSa40+Ui9Q7jx+fTtBLfAUpPN1moyrGTMpNyeoZH
	N4lDa15w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvHMg-00000001Icb-2aQy;
	Wed, 25 Feb 2026 16:03:54 +0000
Date: Wed, 25 Feb 2026 16:03:54 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "ptdesc: remove references to folios from
 __pagetable_ctor() and pagetable_dtor()"
Message-ID: <aZ8dasxUYuuWF9M1@casper.infradead.org>
References: <20260225002434.2953895-1-axelrasmussen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225002434.2953895-1-axelrasmussen@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BE6EF14001F
X-Stat-Signature: 79tjganzdw1gf3bkfrp4dbi89njxr8k1
X-Rspam-User: 
X-HE-Tag: 1772035439-310137
X-HE-Meta: U2FsdGVkX18LDedTmeQ+6uP2xu159FRnwpEr0ubjyju6HpX2y/jgN2aDyeqOZMLFajLBoEx9CkkpolappSkf5ydFLzUUitBXuSwkN2s5asiXh6uvsPG9bJCyf8UCx7YWyFVqMhRtg0813sKPB2tLhYJ9JzhdRL5jM8lOZcbqpXjSp+rTMevWpP5NmWNnhIS3XlKaX/J5xr3uPKHeapXD/hmjDPWcU7Rolz1EejOXNRxRp18axowCMm2ZDRXystkzpypROJafLDzxHGpm2YCqAyFaJH3QOukDBIO4TAHTUf6zofJOfNwJ/XYw7baIhr+vsozrq2HV+Rpu7kSd+F8Rh1HUESuKTpLw+iXSTpfrEB5PhquvHHwokIHlpu0OhcEw/WaGINVHLDr9bJIQidrhzcMX6grHSXKVMKPghAAw+HXTQGsWvtJJk3LMvMxYO0hhEcqi8YXBIvWBp41h6cwBFyFh2VYVmgXvAoW08xfBp/b9+CEoYEIBim6vsZ2s0UoQFlBk++NZHxBx0P2I4jTyx6Q4kZK/KZolEbTL7fKivh3cfIWx89d1cdADoeRrK9dlUr7DGdBYNC2l1nPAa3WBrJ9CtnG/8UDMlz0XLMbEtg4oGfvUcOWdzda2c3/8oVn+kpECGmeXmfOulU2eQd68Gli6DUHnmCRbZGa7XJsf38lluGLpepHaohxFAPcpxpLVToCkyQFaRTf9DrXq2akb45YI3dX5P8Ta3hieK0lGrHEtjPlNScSUhaxT0X/RY23fJ8w6EUOBgRqitrcdu068UwjmSobbqavWjhmK4ixuNTsDkAuSJ0+0Nl2O3OXz5VlYfTqcsGGyUnohT4O/7ad2QA7PoFYHhe/5naOSXm4B9NKQxRqEeaPfMHkN6kB+I6tV03qktgovoaMMb5Kh2v1wJos1o9ZJjs5Pz1k7GOFDfrFeWhL8OiugRDBbXSkXeShuhI6dZ3buidkcGADM52T
 vPth91aG
 B7i5NIbnX/+6HLyIidGpabRptVfo3CIlr6sXQfjSy7gWCmRYve0aoD0Ayfy4pA68rLyUVnpUPZ5Q+X87i8bqETQTK2vLcguZC7G1HCFW1wHesQVz4X7NH1xUdPw1oDMCK5VQOW/m4MpqQ/nVhGfBdCEuAtCIr+KTw6cdfL6MKhnsuZlNjPMi7AvJ3DetnS5XwSiRPK+KC0JHeEu98stBn+k15GBA/TuBvbvOcEglXeRXix5xliyEm+CcD2r+kvZZnNlH9IjGnW92tV+Qb1qkBoC3FWd7xwAmiwN/vX6dKk8yoeFY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 04:24:34PM -0800, Axel Rasmussen wrote:
> This change swapped out mod_node_page_state for lruvec_stat_add_folio.
> But, these two APIs are not interchangeable: the lruvec version also
> increments memcg stats, in addition to "global" pgdat stats.
> 
> So after this change, the "pagetables" memcg stat in memory.stat always
> yields "0", which is a userspace visible regression.
> 
> I tried to look for a refactor where we add a variant of
> lruvec_stat_mod_folio which takes a pgdat and a memcg instead of a
> folio, to try to adhere to the spirit of the original patch. But at the
> end of the day this just means we have to call
> folio_memcg(ptdesc_folio(ptdesc)) anyway, which doesn't really
> accomplish much.

Thank you!  I hadn't been able to get a straight answer on this before.

You're right that there's no good function to call, but that just means
we need to make one.  The principle here is that (eventually) different
memdescs don't need to know about each other.  Obviously we're not there
yet, but we can start disentangling them by not casting ptdescs back to
folios (even though they're created that way).

Here's three patches smooshed together; I have them separately and I'll
post them soon.

