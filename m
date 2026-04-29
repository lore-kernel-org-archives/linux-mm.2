Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D960FF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 06:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0FDC6B0005; Wed, 29 Apr 2026 02:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC01B6B008A; Wed, 29 Apr 2026 02:53:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0D86B008C; Wed, 29 Apr 2026 02:53:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 894FC6B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 02:53:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3837714076A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:53:39 +0000 (UTC)
X-FDA: 84710677758.09.C54ED2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 58D321C0008
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:53:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B6o7uOCV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777445617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwtMkfT+6sltnF7j1cEJxZhmiEFv2uzDyIODaaF3YcE=;
	b=5ECbnwOzSOZjbZGjq8MXj7gVsKmWUc3lV+RZ5YiC+xtvPAzE1yGNhT9HX+THpWD/OU15/2
	Gk9yrW8Wm87uU9La9pRXISRhibkQ9Kd60ZPsFtbL9FaXuGSJMv0jl1ynFCyzp4zfYVQs16
	l4x8o7zlhorMfR9AKKmzn/2qYz0fMfw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777445617; a=rsa-sha256;
	cv=none;
	b=RGKo6uo/N5MM8RMY1p/jpL4RrWGZSCpFB/JPvo3srPwzd5Y8fxX1rMLq9RlHz51vXhTta6
	9JWCZUBJlb3++Vi73b+THA+Vfa9c9300H+cVRNx+sHJfO0Sraa/p0PKkcPzCI2cptz/ak3
	+Q7pTdW9HPOXPj8/Bh2orygzI1aIp0A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B6o7uOCV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EF7E043E6A;
	Wed, 29 Apr 2026 06:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70ACCC19425;
	Wed, 29 Apr 2026 06:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777445615;
	bh=ry4QTtQg8gXjbztYVBm6zJYokjTwMcboL55Qdm43+vE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B6o7uOCVUGVofvTMhOIRKEpYQrDDYTS40KrJjZi1lZcjCMWOmBvECYESWQWo2FVEm
	 CHgBOcMLdJr+CPQ9pEgOcUNxvZ0eJonTtXQ1ivm9OO4VTt9xQrU7ffBl3GntJgk9jJ
	 N6zPTFijjshuRS327HvfZssZt7OhHRanMs8zr0NXFlTvbmDSz/8t+Oyw/dxAIS5XBl
	 WQz2fBkof+CazOSWappmrULhQbSwMfZfv4+C0djEyjZDHCHzmVU5jlOMGG2ggTX8jD
	 evzy9JnKbuFXrAYVJ/RJPq6+lbLGkAdZW//k3DqHjytTypZiqpjWUR78XvjEllPR6y
	 XUBdn9/v7X7gA==
Date: Wed, 29 Apr 2026 08:53:25 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/49] mm: panic on memory allocation failure in
 sparse_init_nid()
Message-ID: <afGq5Qa21NOumdwp@kernel.org>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-10-songmuchun@bytedance.com>
 <afBaMEBoR_35Fblc@kernel.org>
 <9FD13495-58E8-4183-AAC0-48E50A694ADE@linux.dev>
 <afCxZ5vYDeAlzTK2@kernel.org>
 <408EDCB4-7F65-4595-BE44-E23300FBD397@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <408EDCB4-7F65-4595-BE44-E23300FBD397@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 58D321C0008
X-Rspamd-Server: rspam04
X-Stat-Signature: bdk85o6gdaor41eprt9zjxzsrwzet939
X-HE-Tag: 1777445617-23161
X-HE-Meta: U2FsdGVkX19IrJ3W2ppU2QX8EkXtHLnU4PAbAUZokGJ3QazhZJ2K1hn0isuUM6UKi8mHNz367jvd0qITncPJ4sgDMOxTtunQ9NNxDqsnPVU4wyovvUdeM6QzOM+giCqZu1jkvI9dqV9j/gB9LS7I2qJMJYkr2BS7Ra+sQma8R5SQWtHctLH7FXGurzOGKly3zwYlTTYhybg+HWXkM40lvjXW3Zek0d3Hm5zAuqGfQisYqJCzBpDJPXCkkJg3jKaVYfa6TJb5zGNOsmQtmvkQU9MlmnJ9tp7rCWnzBqz1UZmEXFSKh0U8ZZKDV4WvTErnR40JvULxZytg5GjtxuYf3S/Z44BUn9kkbg2616SUwocLBnOu7BYn9wg3v4n/OnW6ySl2JxKMXquS7N2/6Sw29UAJa7CEHYgLXXZbLXtE5xq1nDH/ar8YpOqVNi/Gf0tXJcPK34mrtFCBEKx57sDj/GjjTIAIPJyw2WpaxVpoB4SeettpRe8BB69mn53aiu4Q3Lf82Jgs/rQfXYojhTXHc5PzxcBbXpN03vXmeXSNkpOalMv5NSOvDTKsHVVJQxCJPeXlxFLmJd6Uvb9xzvIqcKKoBvVjxAILSrytSSu7PhLvSswWDbcqGG7GnmTqVUtBGF5CTm3ocpChYb/u0EwcyJzUyJrn72mXYhR+DkYqOhp6dU06AoGNwr51Mj6Wtx4gOAu7oYkUOLvw+xcoOy3682yZeT0H04EBt7dqYpXs8o13KvErUYHmTqAbDkwqEcxrLtV7Eigh4P8KDFYRGZ1YuJlz0yQZdoE0wXdX2B8iYHE3qjk0QK7murXZpYuEi8VV3bXinuFlshxTdAhJqCECiuSMlr8k1kqPR+u2l1wWeU2aAwdN+dUKGcUBh+An2xZupDVuZRURv71O4wkB/c4apJ3xf/4dFrA+htrEsMHryoBo9Xq4P2YPfSrAI15f0+zXep9g146yY4pFp2uCEeV
 zEhRzty/
 CubTXmTKG68K4C8mE25RUOnaQCq8drqUAvnFO6A4C2pwZqXcikZlbvM0XAlce6qn2X73kSoD1pN6qc7iXP2hivKL4EWHg+PAC1cPvHZdYOKbU0DWr7QkO1UVgQxuWrhvNlsRTBh6i6NLDAU2OOdI9Wk8MPMDU0HGdk26sEhQK1sIrZxIUoxJSOY4502F5TwS8fj4N2Bdxqjh65x0WnKXrzoWSTj7QxBFvpI6656VQEf8Q2pAHUtNkiyYhpj/kLT6F9luc/5NdOxbZ4RxS+q90+Ue38xpXvGV1FSVi/f1S9BUIeYxT14KrdRenA06sGG3PevsutQY9eTKG/hg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 11:14:14AM +0800, Muchun Song wrote:
> > On Apr 28, 2026, at 21:08, Mike Rapoport <rppt@kernel.org> wrote:
> >>>> 
> >>>> +  if (sparse_usage_init(nid, map_count))
> >>>> +  panic("The node[%d] usemap allocation failed\n", nid);
> >>> 
> >>> Please consider using memblock_alloc_or_panic() in sparse_usage_init(), it
> >>> would simplify the code even more.
> >> 
> >> Hi Mike,
> >> 
> >> Should we add a new function like memblock_alloc_node_or_panic? Because
> >> we want to allocate vmemmap pages on the same node.
> > 
> > Heh, I missed the nid part :) 
> > There are a few _node_ or _nid_ allocation helpers in memblock, starting to
> > add _nopanic for them would be overkill. Let's keep panic()s at call sites.
> 
> We can add a panic inside memmap_alloc() because it is used specifically for
> memmap allocation. To some extent, this also reduces the number of places where
> callers need to add a panic. What do you think?

Right, with sparse_buffer_alloc() and with this change memmap_alloc() can
panic(). I like the idea.
 
> Thanks.

-- 
Sincerely yours,
Mike.

