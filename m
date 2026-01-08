Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08029D1D484
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 17:41:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 636906B0088; Thu,  8 Jan 2026 12:41:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608816B0095; Thu,  8 Jan 2026 12:41:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 533F46B00B8; Thu,  8 Jan 2026 12:41:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40C736B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:41:03 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E0DEE57902
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:41:02 +0000 (UTC)
X-FDA: 84309512364.04.ACF1239
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 63817100003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:41:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WHtwXWTG;
	spf=pass (imf05.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767894061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aOdO+JsmYXh6PDL2HBB1YArN+pmXU9dRThl2IzPdTPo=;
	b=xT8VnEGpJqVWlqGktPPGTVFNTPQtAUc4+j1EBvbIAM1GOAINYexicUJUvk8RDhKHii44o5
	H3kZsF5xGrZGGllaNEFjGghEyN08y3uxla97MPcMfcPD5kU9l1Szf9SzckAJczIyfA8GUy
	YIExKge5FUVTyuGPWZhYwixLmY3LDV4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WHtwXWTG;
	spf=pass (imf05.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767894061; a=rsa-sha256;
	cv=none;
	b=Cs/I0ZHM524ic/gRX7TX9s+mPDdfGX1FmI81cDl9zcRwoYbXhxHoxxz48ocff2zi5Ao2Le
	L9CH8qGBpdOXvzZadgvqWBMewoXssiTkYfgKD02olBnWpZWEFOmdDTUM9fnvG4d/EiK1Ot
	054je8hYPkXSg9JED+wDqCaU6miGSK0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B61A960140;
	Thu,  8 Jan 2026 17:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0787C116C6;
	Thu,  8 Jan 2026 17:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767894060;
	bh=BHDdPpb32MY2i2fwkzE3yXM71nGt/m2CVIq2iPGkD6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WHtwXWTGHb9kHiOWzYRLmcK5SrLwYwSLs4AP63ZX7lpeaKpX5t9iEmeEecGGFZJp0
	 xAmLwU5bChPZEPMLXPn0mQjWaEO0a52l/mybjLfoA2hocSEWiHejm3Adb2AC7PUAZg
	 5I26aGJYxIfmfz99qtmj/nQqtWkjQi+zkUgVbyBFfQ9FcHUKkYt3KKeOn20hVfDliv
	 DRksaxI3W8EnZj6XqYdLhjHZLzXTPSa0QWvvQN2urPu/iO0U22fAXMgZCSGha/IgIE
	 BW1pZV4/kWmAmc2n+SMbON22aMWCwYw/tI/Uphd9DRy4hHPXcivkNV73BdmkzT9g44
	 4mzT39lblGS5g==
Date: Thu, 8 Jan 2026 09:40:59 -0800
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-hardening@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>, Joe Perches <joe@perches.com>,
	Christoph Lameter <cl@linux.com>, Marco Elver <elver@google.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Pekka Enberg <penberg@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v6 4/5] slab: Introduce kmalloc_flex() and family
Message-ID: <202601080939.B99FEFF780@keescook>
References: <20251203233029.it.641-kees@kernel.org>
 <20251203233036.3212363-4-kees@kernel.org>
 <f1f06db9-a12c-4999-9723-1fca5e8383a4@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1f06db9-a12c-4999-9723-1fca5e8383a4@suse.cz>
X-Rspamd-Queue-Id: 63817100003
X-Stat-Signature: g1hxuyd9otk1cw3c5ebuhknjeejmdhu4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1767894061-182992
X-HE-Meta: U2FsdGVkX1/vhiyaHlfB1ODBciJwdIJ7dUqIQZni+jRhsDiponc4ZWx+AnbXHx+51uBVZM4DdgUGlm2hPOyBF3zk00t1Mgw69OG3t9B2SSYuvjhXdNb2oe3pTc/oMHfXOJ87Rvmfh22qcOmezX3mGlLgQbYgL2pVj+ASn/hUEqXWtsqJrenx7yapwvSNsit1Cdt8qrKceKMgiQqraMJEI31D4wbkpGy4TUOCncNCw4Jh6tLLhScWS05OeW21e5gIkiihNwWJxYwsrosALtbihJvyfxCR1r9QG6fW5b/CT7jIl6wKNt5Sw666wAFahwgqcq+Fsaon8uoAlPWzSUjF93BxSgOSdiUjoTMAjjA96iUJAABK2xODIohp1e2GIcGu7ZvRITcxH+HKEVV35RwJxoTHmktUIBG807qseP/pO2ygvNWj5LmMMY/tUxQ90C05kUUDZO9I/9MH1/B3zRVTzoGfwfG3JHsjKBabVRF5UljesvYi/tGnynT/A6kSCiHXBoqZzGPMJvUQq8ml4U98zWJTcYiBduqelQtS/isp7dd/etno30FIVjE2liQbC4uKxp6lJGRI3K8hTw2nT6eyzHpEWgMMd1du39caXaO7iKe/ISTHVQkJHzWx/Jk1dboxOZHubInowzFPRs1WIzrU5IFijTBXER7+lQliKcZeN2hlRkiHPstqgbPiJcMgCs8q4wud4v7cQtO6WPPQcQGQ1d6oNn3C9b7mxDAF+95uDgCOEnBlcZgS/fZCDWMfkVa3tHwILEXGs63q/hRDK7AGT95Wb64OksAqwi5gKXUUlJK9Qycv1HBWV1kHDTJ2LObrdIqxgvn/PjtUIisjUndOGLxUNF6WbO+yVz0j2uWhwaYnD4kxhjzZXEIRE4cSeFyJaJZB+tHNGYNq+FWcQC1/qQNx7OchY8GgDoIsBYyvXrrjSmaXI+iq3/KP6j6LidwXUpqBWBRUkqzbfPaIjx9
 k6Vn+tFE
 NAeDfsQ/C7Lj98t9Bx4klj19T1nUqk3iqDHlj474stvc8OJcHDVikqj3hAw9n1ZmDaRRoMmkeIl2CBqsoODkgQwo2Ad7kzrHS5LWHmbJhwpG2pXwAtmiLN5A5bMeDAdcNXAurD1Wj3gRqp4vjqm4xNZhIZVYDiSA5n+cBNYT6dDrVIJwBerRgR87honsIoXVoV68vzveJEH+IFDdCwt4wDoxFG0tOy0ML6eFy+8XmoBksJ2wCjCLgUu33+V1R+egu/2/T+lMM9q5Yg2/7jlyjZvXRKjlR6PLgHjFj8qZsRZ2CjQFBkNg6D7hTinCjSE7mSABhhNy6QkbvvT0oOwY8hXaPBuguOL++alppZwefTHW1PvMM3vGUwY317w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 03:06:31PM +0100, Vlastimil Babka wrote:
> On 12/4/25 00:30, Kees Cook wrote:
> > As done for kmalloc_obj*(), introduce a type-aware allocator for flexible
> > arrays, which may also have "counted_by" annotations:
> > 
> > 	ptr = kmalloc(struct_size(ptr, flex_member, count), gfp);
> > 
> > becomes:
> > 
> > 	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
> > 
> > The internal use of __flex_counter() allows for automatically setting
> > the counter member of a struct's flexible array member when it has
> > been annotated with __counted_by(), avoiding any missed early size
> > initializations while __counted_by() annotations are added to the
> > kernel. Additionally, this also checks for "too large" allocations based
> > on the type size of the counter variable. For example:
> > 
> > 	if (count > type_max(ptr->flex_counter))
> > 		fail...;
> > 	size = struct_size(ptr, flex_member, count);
> > 	ptr = kmalloc(size, gfp);
> > 	ptr->flex_counter = count;
> > 
> > becomes (n.b. unchanged from earlier example):
> > 
> > 	ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
> > 	ptr->flex_count = count;
> 
>              ^ flex_counter ?
> 
> But if it was "too large", ptr is NULL so this will oops?

I've changed this to:

...
based on the type size of the counter variable. For example:

        if (count > type_max(ptr->flex_counter))
                fail...;
        size = struct_size(ptr, flex_member, count);
        ptr = kmalloc(size, gfp);
        if (!ptr)
                fail...;
        ptr->flex_counter = count;

becomes (n.b. unchanged from earlier example):

        ptr = kmalloc_flex(*ptr, flex_member, count, gfp);
        if (!ptr)
                fail...;
        ptr->flex_counter = count;


May I add your Acked-by for this 4/5 patch?

-- 
Kees Cook

