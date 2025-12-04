Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E09D8D1D86F
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 06:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 229E56B0011; Thu,  4 Dec 2025 01:07:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18BB36B0012; Thu,  4 Dec 2025 01:07:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07BC66B0023; Thu,  4 Dec 2025 01:07:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E7B906B0011
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 01:07:40 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7774B52059
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:07:38 +0000 (UTC)
X-FDA: 84180756996.29.F89D46E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id CDC0010000D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:07:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZlPO1jE4;
	spf=pass (imf14.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764828456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yqvJm6uJUw30BK5grM8L9SL4qml1BXr2UM/5fM2dmZA=;
	b=B3Lp77ELwQo8srnE0ibGhces8Qc2G+pnQAb/9cq5OgBe2gQKf3IzBhGh9lafIHGR5zr1be
	iPFnhjYcZhwwcgIqkOopAQhQzXmJ6Hzal6AmED2HinH3oiqBzBt9LKivdf4bTIxqwvyU15
	KqU6HGeJcGnyXzHEVV41WzlVnX/sLEA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764828456; a=rsa-sha256;
	cv=none;
	b=oLRERS9LDbJi7k3yMraMaug+J50nLEDZDXB8Z9Io+7tu3ZzjJ19MNoJg335fMt5U+ouo7T
	hrKgoooIgu1ge1n3NNGcibgsyRVIk0ER+ILsMRtOF4BsOlnhfM57KOg6sSFgkkdn61b7i3
	HOph4Xj402XvP0bgpCGTuTm7Lfa2BXc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZlPO1jE4;
	spf=pass (imf14.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D422B44404;
	Thu,  4 Dec 2025 06:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A065BC113D0;
	Thu,  4 Dec 2025 06:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764828455;
	bh=oW9YKnJzWB2+6bhflZNJrm7g/KPV070xkxno6gjgYUk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZlPO1jE4+cXIEbXbrYgmI1LOZn4FWTmffO/oZULe8KxYnUHl9HGcFtfewnOWg1sVT
	 sIYh97Lk+BAF8ZjuTTQar07UmTVtc5kBka1ROibQScS+3lduJMkBNTecSDfHtz4Qm/
	 h61HX/Ed1WyJW6H9QfSasuIDq/T+Ci4L7jEYYosAqSkoulfvkurQeFjk3IU60wWk/e
	 AMbRg/allsp9drBAGnL7GFJbtcge2ygnVUrC6+lXUrGBbqhpbrD/kUR1PjzE8xNQM9
	 NzINl3oGv/K0tdXi8zWMEA2e+mHrNDJkQ9vV7GrN6E59gaux4HmKLK3Vs9soHxn4pe
	 z/wrdO7FIhuUg==
Date: Wed, 3 Dec 2025 22:07:35 -0800
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>, Joe Perches <joe@perches.com>,
	Christoph Lameter <cl@linux.com>, Marco Elver <elver@google.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-doc@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v6 0/5] asdf
Message-ID: <202512032205.BCA3A5B1@keescook>
References: <20251203233029.it.641-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203233029.it.641-kees@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CDC0010000D
X-Stat-Signature: mz4cdzpnwg1kncjgxtxeuscusfme7rr4
X-Rspam-User: 
X-HE-Tag: 1764828456-296863
X-HE-Meta: U2FsdGVkX19DXf/QMdDAeb9iNxkLTjAL0vjDxPsW/ec92U9C7Em4c4wEluOKitw6UJ9KGheWmH4h1lYrJrwysSes3OfhsOxccz+gFHggz1yC6laWQtf/BKG6e2+Lrh7lovlI0NJCLS2t8Rw9HW/i2lnsbbnctQ3bPnDqjvR+85eo8WxQhljDpMjnSwVd0cm6rUoM9E0KkzQ2PyZXAoWOHRjx9bk2xp/ZYb04zmTywvw71W2xsdhJb9365Bw8nqLIHfy2fLqUVzm6ceozprqZsKJsE5P2XtIt8dgRVVVmHFnSE7S6+ILcCp+dXgbO+i28QUd6c4CwaETWcM9unDYZXCWIQH43rRRX+5fXvI3ADKsBIRN1gWSZQtQYhklfTesiLLFICsLkLix3iOZ2Bl28fVjdYUJ+ntemKf1IH9+mQ5T9jXUf4c96s+pCqLNxRd8txss7qILIx2hAoCEba3nT6kihzIlXc+RCO5g63Q92OU34TGWP4odwr629AWsz4yGEz+mEHLs9+hOEk+iNS16LJs35gHQfmLceHliFo4fb8uVXOnzzMkaS+jsXw4HOb3bAaOSqwrBzrskBrX7yQWQpLFnpXEYLFmyJZe0zsVuHEfGdtwBqUAZiYJdNZx8cr0UBNM/R3NBZcKQ6AqAoUa2RzMMpygo6ORkLjZ2cqviP9f1srZ5Z++jeXgnVDtelmzHVHs+4oC00MEOKqBtFTXhnRFVzc6mhG8ELGGccujOqO8bw3+hns9wLicomr3Z6ZUBGDaPMn558z9YUs4RIXpvgMq451VJyIIsGCJrXKl/LFekEZ0PYzat8Z6FJS2GNVWUbV4P87McVtYOpUrrMQgM4MwekMRssqLzWLSPtaLaNypMi0bYk/Y4GcyDgUBGpJYL4HFtMttn2HM9QcB2PRMu/dWfbUIuE6rWyJz8+WvUHzjXL3EeGXxR/U/1UUy/5buvVu4EHkShmOl5FbcEE3MQ
 1BgTp7t2
 DOLXVUSRycwlhwK0webOG5RCHf5QgDRhTAErT228gHqE334F41mG4m5t1yrU4/DQJowSEWcfwhL2I3boh7J72nMZf2mP87+mwwVmEnx2EB3AfcNEnHvW2lPInUWoh1/rwaIC0pyxavB3yEh4ID3DvYVhzGksAS7MHsYqZyFXRkyPouo+7MY7c6VA9rDAXUB8LY6wKDxHyXh/KACN8dx2ZY8pJJly4y1dLC3s6ha4fdWX3n3cVgYKN/9HiBWmSAzHzcDTbToSRWIIllqXw1IOds199wXLWw/BCJ7XKaJCZ4IbnNsz0EHLtXe15duO7x04e0xD4ZnHvZOV3kfc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Subject: Re: [PATCH v6 0/5] asdf

*sigh* Should have been:

[PATCH v6 0/5] slab: Introduce kmalloc_obj() and family

-- 
Kees Cook

