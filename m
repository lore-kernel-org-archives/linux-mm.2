Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CCB4CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 10:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 805686B008A; Thu, 14 May 2026 06:13:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DD136B008C; Thu, 14 May 2026 06:13:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719D06B0092; Thu, 14 May 2026 06:13:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6396A6B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:13:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C8891C07A3
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:13:37 +0000 (UTC)
X-FDA: 84765613674.12.62F6B40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 77DD71A000A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:13:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VNOUZxJy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778753615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8aQyMIS3m+Niiuo54AwvGw0COQizyzw7pYl8AwyS/EU=;
	b=DVtCdE4Qdz9bxkhSIdh2f0HRQPyteFodqsgUHw3sBkXjXQXX8qzZ5/1jTDFcAuBelEcsX3
	hNIRqbMQn8Onr4SBkdw+nK4nUIxOOpYRSx3hR1qyw9AFjBX6jI7DEmX0eJosrQJuoX9g1K
	1BTboCENpV43vNci/sY9sJmEkE6iyHk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778753615; a=rsa-sha256;
	cv=none;
	b=UszS+RzKr//OrtdT8Ii7AgtKQS4qV4BPxCGSzUgPO9WTQfjlYoJ5BX3c9pwzb+OyEBEIMy
	tX8Qr4adVqcGFrHbp0+UHb6Q8HPEKvKRXPtoq2B3GBDlgXXogHl7NTova09lytXFGIKQ3i
	vp7Xr3hL6LGVJ2bNXK06mcYW6Smurk4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VNOUZxJy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D973760132;
	Thu, 14 May 2026 10:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0C1C2BCB8;
	Thu, 14 May 2026 10:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778753614;
	bh=pyFB4ur/KVLGcKl/yLNGIfGo7BXMPQnbBHd8aTS1kt0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VNOUZxJyCkN4NYFp1NdTxIviv6fdawFQatfOjrTjzUFG5RC8e2NCC0DV935mjzNBQ
	 TZei+awNzZKo3nMD8AykyxLwChCts8nwLKZedeUXLi9EWZLSYbqrVDRGEQL//xDNUg
	 M7PAyBJcV26zRYDU2OnWw+KdiSR14zuT1u7e1qLuWWZIRwSqo/1lUYf1xSVMs08VAI
	 qyP+RI/VF8ZJCPwSf/SO5cYTH+LIA1jHr90zhyMz+RG+khuUUCf3nmJ5B2JNQa89jd
	 b3LmwFwsbOnim/OouN+nFUdEVHG5o71G9ay1tAkaE1Kk6pEkGuU3m4oZ1d3YG5fx7F
	 bsazcJySO0Uyg==
Date: Thu, 14 May 2026 19:13:30 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Marco Elver <elver@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Bill Wendling <morbo@google.com>, David Hildenbrand <david@kernel.org>, 
	David Rientjes <rientjes@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Justin Stitt <justinstitt@google.com>, KP Singh <kpsingh@kernel.org>, Kees Cook <kees@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Matteo Rizzo <matteorizzo@google.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	linux-hardening@vger.kernel.org, Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Hao Li <hao.li@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Alexander Potapenko <glider@google.com>, 
	Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kasan-dev@googlegroups.com, llvm@lists.linux.dev, 
	GONG Ruiqi <gongruiqi1@huawei.com>, Jonathan Corbet <corbet@lwn.net>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] slab: support for compiler-assisted type-based
 slab cache partitioning
Message-ID: <gmzc5ul56yvsdgha4ly53zckhmhnbylak2rcxwxlerhkt2d5lm@gellfjmlzmr3>
References: <20260511200136.3201646-1-elver@google.com>
 <560a84ed-7daf-4a78-a314-b867c73bce22@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <560a84ed-7daf-4a78-a314-b867c73bce22@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 77DD71A000A
X-Stat-Signature: uf6p4id1c7faiujg4i1f3g4pm4ids9ad
X-Rspam-User: 
X-HE-Tag: 1778753615-844898
X-HE-Meta: U2FsdGVkX18J6I5VQEWuO4Dk1veheG65ZA8i+1qXy9nzrwot6ScF0Ic+O98umSwF5mejVsMBav/bFns8t39euQMxSBu6ZqbAngloJIvjXhkavcLFuzgjCAaKD9je18N+VOMCI2lD/Z0BQeTWhLANcA0Y7azAneGRDFXTQRbdVDtYah7I3C84B+fKfJfoeAM81vaqDe7AX7eZXe/TZ4VZn/xB03ZEd6MmmTKjm1pLxxnRgW9pmQ0xozgC9XYYABDw69eeokWivEl3Hn7X7tqB55cEQ0yX0Enr65Apg8s52u/pvvM0p2WEMHuJFr2+8TlXaPLrxrFZLvq9zAJnFLy1opf2ATvVc6hjJv0WxmxtNvNAoaA0CG3k8MZWJ/NQ8zPfR6ltS7SQcBY/A0+jtJN9bNhhvN6E3ZGb3BjBB+5+GrunRH38GiJYvmIvzWNJtTs8HyglTvp6ToDwLCQYZxRo5EuUCZgycLLEUoEoJBfb1mKj14MOV4lbFTkXLEj5kT4ifvl0cX+Wg4fz2ZPnIMXpXq7YX3kFv1OiXM7sjOT5ww8II0GJZZApY4SiSH+GGwbJTvAmyYvugECie9rxXyhOp0gkQFOYnIV0XhT3YfH95VmLoioI7nOHgcC42+jhuyBefzJE1Wo+Q6vPcKiEVNpW9BvuZUl9vlLszw604QmEYyjUs7oeivU4s+/f0Oiuc2SYp2pInVsn96wgY8ORW09fbC/1z9GF8iiBONnkfacIPG7P5jtz59oyALVLfA/UAX+LoOyUCUnA+xQxQqzmzmGiQNF1x5gqnCVQ5RKqtyiQtEwELgE+Hn2cra8tyWuPJn2KEV+SPUwHOqPf3d59FSGlFUko+8FzxK1uy2TrYuI+5g7HoMfgOirLDg5XNagzykkG2LZ/fCPwXXnqIQUOpykTPbnKYCmpE8WbXP3+9qjWLWgcQnzsmwt+E+5hlXWYOYL7PxjrLu3yLaOK3N3t3Qu
 CSkT1cBq
 eA8urw719KZRPs2/Z5TMkNsnHXIqhl/qfI5iIxMSvE8PvxNe8J8RZljqyUtj0fK9NpfbdaluIjww+8C24RzA2I7SYxjeaShYf0cdmFTgu5mhpzR1NdwoZTOcOl6ayGekfPY1Xm2c/4m7tB4+gV6/Q1P5Kyg/N3ynwhP9/qfQ7BykQSCzJSPy9H6xBq9zhT4HGHb/KqRVnwkZOaAiPImOi/KjGbYwVVFXy7xYq8N0IZGf2xvzbq681z9p6pL/uBTsTuHlie/pCZBJy1cjJXKAuhX6+shVS+wZwMQt86yVTkCsqUS4eQMyoXbQveaF9SsnuVwNaBY5d9dD7gWcIRAB6kOLH0jVNdvr/tHKpkyHwWrW7DS8hzaPgjRJPSGriFFC1KfMCS6Pkwas8k7o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 11:01:26AM +0200, Vlastimil Babka (SUSE) wrote:
> Applied [1] to slab/for-next, thanks. That means including the kernel-doc
> workarounds in patch 3. I know Jon said someone might hate it, but maybe it
> will motivate them for creating a proper fix :) It seems better than leaving
> doc generation broken or not applying this series at all.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=slab/for-7.2/alloc_token
> 
> I did the following fixup to remove passing an unnecessary NULL argument for
> __kmalloc_nolock() with buckets enabled. Made bloat-o-meter happier a bit.

[...]

Looks reasonable to me, thanks!

-- 
Cheers,
Harry / Hyeonggon

