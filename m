Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BE77C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 13:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DD8E6B0092; Thu, 10 Sep 2026 09:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48ED06B0093; Thu, 10 Sep 2026 09:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A4E86B0095; Thu, 10 Sep 2026 09:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B09E6B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:12:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 608E5404FB
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:12:53 +0000 (UTC)
X-FDA: 85197892626.08.B4DEA88
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf11.hostedemail.com (Postfix) with ESMTP id BAEA440004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:12:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="AuqZrEh/";
	spf=pass (imf11.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789045971;
	b=zxqQ+DAAOkxPR+skBwe1Q66bLWC8+sSiZQ+AI89mF78jy4UbVNIZ62ieEgOiq3b2z8mkZp
	x0jiOi4wotoIYuQgj6Khjqn9pgyT8TR3TJbVpr4NgR1lcmN3FHNuTaXyRn0Q3y7Dv7g0q7
	iSJsu+ZC5S8I75JDC09Wr+hTK+3w8gY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="AuqZrEh/";
	spf=pass (imf11.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789045971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNyABl3CZEW2VceQ9RPkhr81c66ogdLDFwy8ZLemQBA=;
	b=S4a0OSF5sBapIfive+45nF1WAuTFNmPgRUqDNsQlrY+op/hKV9mnuLRiehVsd41TYt227o
	6Fb5AChYxOYuVA+ZyK1GJd9rI1SWYB22UTzKcBe+YWuSI2CbAqC6Dxyk1aIUHg7+QJDcS8
	hNnfmchD7RX1YH2iCiyeROeFrUiscgs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kNyABl3CZEW2VceQ9RPkhr81c66ogdLDFwy8ZLemQBA=; b=AuqZrEh/loPwu80xoo+6bFKkEq
	D6bmTxKs6ubIzvlQLl6ThDG3wDMZZmUNKuNnHTkItBlmAFUBBN/Pnk5cX8FViRxsGwizxtujk1/mO
	/BqoKI/sTi5zF2MRq9wUXR2K3bqUKC3ujAzlrBvPnMwhmV6Isz7sUSBU0qULx1hOzj2ZpTuQ+qqR6
	taU/sjiiLY39JDGLcN5Q6Ux6mxw6A0JgJu/H456kgzTzNX1r26Ogi4u7JfELMyAGRKufRQD9eXZlJ
	JFXG0fLOR1FwHdLSDNtwKtVbMd4i04PUi2uO0SFy/nP7GRIsXioBCLJJuABTsbQJWIwb3P8J1D1pZ
	q2iks6CA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x4eZN-000XBL-1U;
	Thu, 10 Sep 2026 13:12:02 +0000
Date: Thu, 10 Sep 2026 06:11:53 -0700
From: Breno Leitao <leitao@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
	kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, harry@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v4 2/5] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Message-ID: <aqKhgPKzRf0e22s3@gmail.com>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-2-359313564495@debian.org>
 <2c9a7bef-3189-4f78-a6cb-61d2f7afd643@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c9a7bef-3189-4f78-a6cb-61d2f7afd643@app.fastmail.com>
X-Debian-User: leitao
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BAEA440004
X-Rspam-User: 
X-Stat-Signature: x8uyxn9beipxbbstwmttts6ccihau53s
X-HE-Tag: 1789045971-151995
X-HE-Meta: U2FsdGVkX1+wlI9uOQpyPbRZbAqkXJ/UmE3Br+46RcMuEr+E7zwBTHvs71/LeAGIvFmLgOyb1I9eTVZxA2f2wvIRVd8zA5veTa16NbTzSSQGDWnSy9TLrzMYPtSCAW1nc4ky/UkxJfNlTqBhJaDuOtzeSayyYHcNDawff1jtngna7H4vDEqVGr4El1Q7rDxadVfB42UAwwYSkVK6GsZpeFDNQfwOjGdM44JfI2P7nVf6b0qScM9yqtDO1k1c/eCRvGvzw5kcuZo4BdsGPwOPNN9XXpMUfR7Lcqo8973Ea2miyuS70fYLu2aG1rAqIGkzQPnkq+wppW/WxbYYczNWdYpOTsEEXAjLaYOs+j/peXyuIpXB3BtwngGdPyz9ldjdU/hrTc7ZwAXi3b0wJ8EYm8s15uixeSyv+WKUtXpI8mIS0tIlGR8STBBbnm4uZgIwMIHUSNTHpMVdZjU2eXFSiJmNaCq9TO6oey16esSKtil5dATzORp5zPSCmAu3LKkQdaN2SP2doyc/077EID7qYHwoOaNHPsTX7nwJ+i1qfdMXA6Lq+fflYnVUYpluhhavmJkQIKTfX8hy0ZD9DC9+hLXYKQbOIoxbQXrF+55PEykaMDwmj6LWlrNjA3cnIi15rYJ2939Ph1KEpjSJt2Qk6OYwCd4Owl+L1lyJXhrlbZQ8I/PPXoIDOxUFtO0ofL1Q5SoAHHysb9p8kKNkHGafKcx5MVRu3+hF9uKeEKBL/M+AXMku6+LQvrBVYsQ3CBw0LM81F0pN6NG1/XU2B73K9bwGo1eJzuMA6/+YwthsL47G8IGx7+R48wH4gYzq9gQwXhO/9gz7TyNn7wOxiDa8bhjGe2SWV3Uw/mKPjVRr9qoMpZq5DGmTIm6HGqyFR5SDhOVayE/XRfyv1/PmvSWPNIIF5zcu5AujVnHYZ0MvPH171F7cwV+dlf84MRyqnsyYXPhcXormzcwvyBJEmJV
 JzlMXxwd
 BXKm2KdxeQOvZXj0Iimh7gR6DmtWenen1MR80kg3oukcqVjJRJG/AyjvA6IdhtVaaJxLuli/WhgAO7y4xM+rLCvMTIw3Wf+XE7tuQLFl2wClF7sVgm0LRj43MyAPp/RToy9Sa/d1Qm4clJ7CloGcjHIEcIAldFSCJHxK6AmvFAkSqmZhp2ItlKeZW61ZwalRhpD+FytnsJZb66JDmpN2M20nGnTbNaVSOk5RUatMpqkTKwTeJMf0MRdHzMwEdZIdrwkqs7dp+mP3psho96R9svcalaYNgb/b+AEjYZrxDjJZk2XQCjPuwr6/rRED2gcSBk2VjcttJNguyJKsPEUyaHBkdaYJww7oVhHiq2MmqEiABjeiQraPqblbdbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Ard,

Thanks for the feedback!

On Wed, Sep 09, 2026 at 04:47:27PM +0200, Ard Biesheuvel wrote:
> On Wed, 9 Sep 2026, at 15:05, Breno Leitao wrote:
> > A EFI config table can only be installed while boot services are still
> > up, so the stub has to create it; the running kernel can only flip bits
> > in a table that already exists.
>
> This is true, but that also means a config table could have a 'next' field
> pointing to an allocation that was added later.
>
> There is a EFI memreserve table based on this principle: this is a hack
> that we added for the arm64 GICv3 LPI table handling, which is a braindead
> piece of kit that must use the same physical allocation as the previous
> kernel. It is not currently enabled on x86.
>
> Please consider whether or not that is more suitable, and can be repurposed
> or shared. (Feel free to make changes to the current format if needed).

That's actually what I tried in the RFC. I passed an almost-empty EFI
table, then built a linked list of poisoned pages on top of it.

It looked like this:

	struct linux_efi_poisoned_memory {
		int		size;			// allocated size of the array
		atomic_t	count;			// number of entries used
		phys_addr_t	next;			// pa of next struct instance
		struct {
			phys_addr_t	base;
			phys_addr_t	size;
		} entry[];
	};


The allocation walks that list the same way; see
efi_hwpoison_record_pfn() in patch "[PATCH RFC 2/3] efi: record hardware-poisoned frames into the poisoned-memory table"

This is the RFC patchset:
https://lore.kernel.org/all/20260717-hwpoison-kho-v1-1-9c5eda551998@debian.org/#t

> I don't have a strong preference either way, but I feel the 2M granularity
> may be a bit wasteful, no?

Maybe. It's the same trade-off as unaccepted memory: reducing the
granularity means growing the bitmap.

We can reduce the granularity, but I don't think we should reduce the
granularity if we're going to KEEP using a bitmap.

So I'd say we have two options:

1) Keep it similar to unaccepted memory, with 2M granularity.
   - Pro : Similar mental model as unnacepted memory
   - Cons: 2 MB might be a bit wasteful 

2) Move to a linked list like the RFC, keeping it outside of the EFI
   table.
   - Pro: Reduce the memory granularities to page instead of 2M blocs.
   - Cons: Another way of passing memory information between kexec
     kernels.

Any any other option or strong preference?
--breno

