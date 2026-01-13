Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3237FD0C85C
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 11:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5755E6B0005; Tue, 13 Jan 2026 06:34:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 522E16B0089; Tue, 13 Jan 2026 06:34:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42ECE6B008A; Tue, 13 Jan 2026 06:34:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 303376B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:34:53 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 95080D0BCD
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:34:52 +0000 (UTC)
X-FDA: 84326733624.10.883479E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 017394000D
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:34:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LT4WJ8AU;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768304091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dqM1VqPV4pdZPHBofjf5rNabyDMfWZXNBYIxMfUVkBk=;
	b=OFWDrPnk3llrQpXceiFt7O5V+So0YP/RnL0J2j/6GH3OCAQ/NfAtx3FT06Watj35WOofPj
	GvGkmTTZoYM6Ry/EAvuKO5KiytZoXwZyXCWp8JGb8Z0CYj8Ut6kX49G41Gem1roWqEA9Hf
	pSmy+7LQ9OuH75udzYi1iGg2hoc6u5s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LT4WJ8AU;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768304091; a=rsa-sha256;
	cv=none;
	b=wyVuxW3nD6i/dQIu5MJ+PQ9+1NurqVQ1HK+G5WfdpjOqvREl1nptWaTbupuXeiAfq6OaSS
	s8DSeOcX5OIeFZ93HOUkcljI77nP47eD4+KXmGlcTsNk0DYYrveUQK3MxNifGZboZPGptJ
	kH7IBjbsxN4UKuBJKo/tDn7MCWTvwIA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AE1560017;
	Tue, 13 Jan 2026 11:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B10FC116C6;
	Tue, 13 Jan 2026 11:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768304089;
	bh=8SYRj/Bn4n03WlxO9wJ4xkhgbEiQG0xyAbcovfmvVts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LT4WJ8AUH5aCphVvnO6bYgyhUe5bT8rop9QoZ0j0AkV6KUH6ZdnQ7WITlMY+Aroh5
	 XyeoZi06OaJfBC2KeAm4S+VkmZxcpym/0kNLYZyTilDlK1bwM5omG4Vt8DKYZ1bSf7
	 xo4x24DibF7EDTAoAq9j2UXbLez9g3LLPrxGr5BhX1Nol0s+cZSNdyurbPSS6hUWUM
	 3SWI4rToibpkd0bHJGKMqhhPoqZewpast2WdoS/DA6x66M+ynpqiFGsTDFflOUH4jN
	 JGZLUrkIrqD2lHSf117dDkADBOr/T0pUrZqvvaCPOKbZuO3WeZ0vHhfHC7l3MQrhqa
	 EaEU1mX+LRJEQ==
Date: Tue, 13 Jan 2026 13:34:42 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Miu <jasonmiu@google.com>, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 1/2] kho: Adopt radix tree for preserved memory
 tracking
Message-ID: <aWYt0gBHxDCKqj9Q@kernel.org>
References: <20260109001127.2596222-1-jasonmiu@google.com>
 <20260109001127.2596222-2-jasonmiu@google.com>
 <aWTJ2v9J-Aa6ykBf@kernel.org>
 <20260112143904.GA812923@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112143904.GA812923@nvidia.com>
X-Rspamd-Queue-Id: 017394000D
X-Stat-Signature: wifno6j1143bk7i3aheigeizoxb9w8q6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768304090-318175
X-HE-Meta: U2FsdGVkX191U+bdjCsGLmZ1mz1aUAmXEv8+Frd2zUUsiz3m0Y+cmlAEhxZHZPGpxtT1BKCVBeo+4DyfpXRs0dQFP2wnBy4cbTXKEqVMRYA1ZullgwBweqJsa9GCDkOm3+KUarg08BxjBBBz/E1xUaNYQCXj3FGMECzKiD65AXfzFfB7qzGyGO+owmmH93LBfn6IIWf29VaRYB4OP7vkD41XdspYs2HAJum9iSz89EhKKfl6mdi29N3OMBtxLiZP8NJNZOG1Cd3Lf53vAFQVTZLsFK3dkkLDyCWlzcvMyysgV0QD6+80kMlLfyaZP2I/Y/8dXQUH638m1xPtBihb73QLY0Y4Ur+AOoHovhg1WHbChcpJDXeq1T8NUg7dO09HoH9hpZH9iDzKKE5cBXFPhOiihuKFp8RqIE3J6KXjb6IJjAo0qIqwtNx+hmduptJXPKyFVYm2GQY9GCWrpYqI9aJ7tacLnKaS60n1ITCFiFcwi/GYt5tpg1VkaNtjx5lLvnVjrRJTq0hLGQwmmOFUNPrymkRT1LfeL+9fcFa5oAqW0812a73IMZdTNNn3obbuMN53zVM+C46svknsJvk3CgNWJnK2/mbSKT8foQKrzvcLru0b0LAVcrAaYfPF9WAAjbxZPqjfKFaXy9fdbR/Dy3EvfifDaZF8E3c8bsjjDCGIEqcFhn27jphX3G9mzQU2LDrAQGe1Td/lSKzkRvaGyPYTE/LlPidTO702jfuV7gK2uAWItBssQ2JLc8WJ5nJ8Zg4zrLGfVTZ6RlNXDIRwGaAdlZNSWVCZy7ZG8EWPZsfcvSM1Y+jGCSGu/BiBdLTrDEQkyPmLgFkhbeeQJt6UXaQbfLI3mTaUMBbXnQr2IKr//JrfBWZgA/CQWGnE59kAE9UnvaktGeNQPlUzU5ctHY3GDAYMU0AVJUrLZnwQumVK/apMULZw0GW/AO6DXvf8Hs6ReYmgSxcuIqvlfxT
 YxdJp5Lv
 7mlyNP6i3dXZsdrggsCgQdOz6SOqC/HD0LicoK4FHuW4yZdWpbMRVbdb2VaATHxk8hTeFvIsWXjfTTQfSQr35cbR+4Wkw1tbW3F6hckjoA5WmEfZyewDKecZmZk05Z/FKJJ+s7B0CebAzzw6Z58AkwqyM0UHXjdvQIxI4HEVV/8dhiKFUUEJvxEq1L/x54lQXe4Com01ntx6lXvWG4xfpL9IMesAkspyCzqtX/KDJWJC/mg/xL94Fy6XedR/ssEXOgx4w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 10:39:04AM -0400, Jason Gunthorpe wrote:
> On Mon, Jan 12, 2026 at 12:15:54PM +0200, Mike Rapoport wrote:
> > > + * The tree is traversed using a key that encodes the page's physical address
> > > + * (pa) and its order into a single unsigned long value. The encoded key value
> > > + * is composed of two parts: the 'order bit' in the upper part and the 'page
> > > + * offset' in the lower part.::
> > > + *
> > > + *   +------------+-----------------------------+--------------------------+
> > > + *   | Page Order | Order Bit                   | Page Offset              |
> > > + *   +------------+-----------------------------+--------------------------+
> > > + *   | 0          | ...000100 ... (at bit 52)   | pa >> (PAGE_SHIFT + 0)   |
> > > + *   | 1          | ...000010 ... (at bit 51)   | pa >> (PAGE_SHIFT + 1)   |
> > > + *   | 2          | ...000001 ... (at bit 50)   | pa >> (PAGE_SHIFT + 2)   |
> > > + *   | ...        | ...                         | ...                      |
> > > + *   +------------+-----------------------------+--------------------------+
> > > + *
> > > + * Page Offset:
> > 
> > To me "page offset" reads as offset from somewhere and here it's rather pfn
> > on steroids :) 
> > Also in many places in the kernel "page offset" refers to the offset inside a
> > page.
> > 
> > Can't say I can think of a better name, but it feels that it should express
> > that this is an address more explicitly.
> 
> It is "Shifted Physical Address"
> 
> > > +			node = phys_to_virt((phys_addr_t)node->table[idx]);
> > > +	}
> > > +
> > > +	/* Handle the leaf level bitmap (level 0) */
> > > +	leaf = (struct kho_radix_leaf *)node;
> > > +	idx = kho_radix_get_index(key, 0);
> > > +	__clear_bit(idx, leaf->bitmap);
> > 
> > I think I already mentioned it in earlier reviews, but I don't remember any
> > response.
> > 
> > How do we approach freeing empty bitmaps and intermediate nodes?
> > If we do a few preserve/uppreserve cycles for memory that can be allocated
> > and freed in between we might get many unused bitmaps.
> 
> Surely this is an error case??
> 
> We shouldn't be unpreserving at all in a normal flow?

That's an error case for KHO/LUO, but might not be an error case for other
users of the kho_radix_tree.
For example mshv intends to use kho_radix_tree to track the hypervisor
memory and there unpreserving will be a part of the normal flow.

I'm not saying we must implement freeing of empty bitmaps from day 1, but
at least there should be a comment about it.
 
> Jason

-- 
Sincerely yours,
Mike.

