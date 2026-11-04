Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43469606A32C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bQWp9KhI
Received: by kanga.kvack.org (Postfix)
	id 6990A6B05BD; Wed,  4 Nov 2026 04:16:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66ED46B05BE; Wed,  4 Nov 2026 04:16:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585236B05BF; Wed,  4 Nov 2026 04:16:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 395886B05BD
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:16:14 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84C441604D1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:16:13 +0000 (UTC)
X-FDA: 85396880226.02.FC6963B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id CC747C0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:16:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bQWp9KhI;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793783771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ovOevQ6/0ArQF2qyajrFoA2dRWz7jgN0t8Al0f9gBIw=;
	b=PBpsAlOcV4CNNpSA833rl1yfU9Hyr/HsFSOE23VwGBEwJgj1USe1StVHccqTONVxOD1khA
	YbfG7KTTvcgYAsVYbSsmrHOSGsMR8EKszaMQcJ92JhbEWv5v+JUBMd6ZKPb5gaVaehEPp2
	NQRhwCNyPkcgc0LywSkvgKbFMJhYzs0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793783771;
	b=OvrFn0zrG3Oz/b2ynlJ2QPrgP/oEIM5fAy87iB5XVnY8oFngPo2Y3QPps1zKcFs2ULRs/r
	X0qPcXTV33G7aWwyB9qaGwuQVXKEuchgpsTeGe9jp+fFSUxPVu3pDHeTdddcrQkNCC+L8r
	pb38rE5J70oPgqlfxQ56VNo/LUZO3ho=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bQWp9KhI;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 61ED560ABF;
	Wed,  4 Nov 2026 09:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0931F000C1;
	Wed,  4 Nov 2026 09:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793783771;
	bh=ovOevQ6/0ArQF2qyajrFoA2dRWz7jgN0t8Al0f9gBIw=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=bQWp9KhIaG6cCe/dKbExBuWWrsaqTMREWjvKXKfI5t4XC6ZC9AMDyz+tYYi5jHtXq
	 1wYiM5lGXqbtusVcYup3lE2HfgaUXBFhW+dfIUyIuSLLovLiv+uSI6ISDa6lIb6Y7J
	 L4myGCiHkxb47GBVnxd3ZXI/hAohQWyiM6wPDBWI4vh3D9KT2HQ8jrn/s5XZgozXhV
	 5OIZm09+ZGOQA/FPtwPa5IF/ptxaexBui0qUHFcbLlcsjgkD9Uhw/8Waly3AXGxAEe
	 COrtFxdR07RYu2NM/BIf6wUxZknvI2W6Camm31J6GMAnoNINl0hqrh8t7Oki13n1a9
	 zYfDerupu1SVA==
Message-ID: <750560f3-4c5a-44fe-b72a-0611be383f32@kernel.org>
Date: Wed, 4 Nov 2026 10:16:03 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/rmap: use release ordering for small-folio
 mapcount removal
To: Pranith Kumar <bobby.prani@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Lance Yang <lance.yang@linux.dev>, Richard Cochran
 <richardcochran@gmail.com>,
 "open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:PTP HARDWARE CLOCK SUPPORT:Keyword:(?:b|_)ptp(?:b|_)"
 <netdev@vger.kernel.org>
References: <20261104013139.1341582-1-bobby.prani@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261104013139.1341582-1-bobby.prani@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: r6dxrmwaggrz6td196tu9cr5939fuhig
X-Rspamd-Queue-Id: CC747C0005
X-Rspam-User: 
X-HE-Tag: 1793783771-736305
X-HE-Meta: U2FsdGVkX1+cetXUt7RaOYzJuYVSK93XLY1iI9Z8DWZzEkFJcWhHaugC7Rzcx3GbirrzGeoSiq4W1dTTTZSNGKGoXgDGMODhRnB/p0EWiY0H8lh1adZT6J/CYx2LVSB1l/F/NToNapL1xpff5TMFQaepIUhx+p4t8qygeLDR6xHLWyVU9wKFlh/U7OJab5c6dO2ewL5dTGQXxtCTgRL7t6za6RXEO7bZKJPcoz3Vzarb5UFeTR9sxWGeHga9bBP2txaC42m28UDJQTKmy81UNoVt2lKk6OmFDuFBF5i5oSt/cW4zBk1W1BTgpU5Is3pPA8F8bShRAYWsbEF0OTTl+Lz+IjVUjpRmojUEM82ywBCfLK3uHF+/3ZgZNj/SQhqvBeDzdXfdjHHdxbf+J0rzzOrta7SsJ7SXdY0tOIF8YmA/ZI8LtrkyZ9yI/MGw3oTPVkKAVfsJvekIgARxfVgBkrRECnIC7kfzEFfzu07KF/4Lww/51siCyPUhyln76yRv+1B93lQ985s7UYvcMY4tmDC9AiOi/0MfkDUZGZKT+pExQMCt3ZsoIruf7AyxfRGP54RacKOoKTDT6ZIc05pY2cVx0isIVi1GGwtLFaJint9suOBE1peJ+eo3A2VjgnLQN7MNZRdcEArPb1AsZu1Vf9/BQEcwL8SAgm2Lg22x4kJnTgBHIgR9IKtUMM7FaizS75ta/gBtAHKAKQTahGzg8B85YrG9Xltj0+nZxPK4ZiKazwGsvrFLhHbgX2VcjBUoOupzXzzfOgopT7g7tCHSORl+F4HNnLVQYGchx66Rpfqj15YUWmzKxmI1h2T+ykpF3CifRonyTVxYsumG0MV/EIUcnurY+b7D5Q4ULng6Keg43vodUalsZnA9chflj9c/HRXBRJBIW/HMn5g9fuxDIVY+wInzUrWxT4H3mUcdxc0wKkAT5rf/O6VnEVfK06yf4QNZ0xZgngb2NHM54qU
 zXG5DnEE
 6KOnz0FJVfUqGWvACS6Xad6aZ3tZlI0hBn2uz3Sw4Op938SyYCaMIN7suO9n5wpAki9PlfbnN0xVSR5gxallmCTJe78Ixnc8mzsor+xr/eECMHUv5JrVvL4r4nv68TN8tdJnatqENwSFStDJODRut/5u53rqOMWnOz5zQsUDkj+tLc/Mc4OM2kNpAtRrb7S6r+mKlQf0h3yC5owkT3zh9WpFIrFWu+2u6N8zRDoH1SEMEKKDc9TY/l/FkhsvOdj5TvD/Afw8b1UVN+/7lVWnBP4RrJS0fn+feM76rzWKxd5PLml3BuHtxA21Gpb/dGe0Rq6PI0e4zpkizmr8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 02:31, Pranith Kumar wrote:
> Removing a PTE mapping must precede lowering its folio's mapcount.
> The COW path relies on this order to keep the old page from being
> reused while a stale translation can still access it. The mapcount
> update needs release ordering for that edge, rather than the full
> ordering of atomic_add_negative().
> 
> Use atomic_add_negative_release() for non-large folios removed at PTE
> level. Leave large-folio operations fully ordered; their path can
> queue a partially mapped folio for deferred splitting. Update the
> COW ordering comment to describe the required guarantee.
> 
> In an arm64 page map/unmap microbenchmark with 20,480 minor
> faults, simulated cycles fell by 1.54%.

Thanks for the patch.

While I see value, I am not convinced this is the right time for this
micro-optimization while we are busy with other things.

This needs a better evaluation: 1.54% in a micro-benchmark without knowing the
stddev isn't particularly helpful.

-- 
Cheers,

David

