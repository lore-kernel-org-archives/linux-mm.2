Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 829C0606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=awUCTYpT
Received: by kanga.kvack.org (Postfix)
	id 9674D6B05B2; Thu, 12 Nov 2026 12:09:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F0776B05B3; Thu, 12 Nov 2026 12:09:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B8126B05B4; Thu, 12 Nov 2026 12:09:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58EEF6B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:09:56 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AC3F1C0687
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:09:55 +0000 (UTC)
X-FDA: 85427104350.09.7F18014
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0FD5140005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:09:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=awUCTYpT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794503394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQz1mAG4FwwJpOtTSrz+KeRLlzMJvENpxMLZke3zOIA=;
	b=vpvn7084yYqM9Jv6zRBTCBYyUK3dBEG2wxqqVqrGjiJMSm2ApLx8acbGJY4y7ZKjSYa0he
	cTwlUzJp/nVxQhKbagjrrZ/vOXW0oBr840Dg875zEyGrMNctVrrJ154dMFNzQNyIcAWfN0
	yn0CGoBHYJ0y4+Tv4CLJq5LRFW95r50=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=awUCTYpT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794503394;
	b=qjv4dMIztn8FsiN/4qcnjTFIQJxfOgFY4HAR2jFGumPSK9lMiej1iDtbelddPbsimeYMc1
	56uaT+bX0WYA8QPFV+G5ElCBayEQ+4AHyalGeBCz81NIdC2Mzyld4YGZSQZwcApclOl4Eo
	0DqfAEYuZ4cxNMtXkcIcIUOMQY0eP5w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 770F862303;
	Thu, 12 Nov 2026 17:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A801F000C4;
	Thu, 12 Nov 2026 17:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794503393;
	bh=JQz1mAG4FwwJpOtTSrz+KeRLlzMJvENpxMLZke3zOIA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=awUCTYpTsL/Oqe6fVjS9VAtu1JcOzy/ql79vB7BsSjY2uKsKiaHY/Acj8eAp4GSv7
	 e2YXOuKtoTEentofTPEmJdAma196fYP7qDeIgA97OToCwOhpz5uN7yk1e712OJxDHL
	 24aLHcenx9e0ZM2r69lH7TO5CohTbnvw2lC/noUnpF8F0V9751gXt77lOpolk3gwvf
	 VJpQwFBK5zHuosDMEMb6msCer633TwwVNaK3cGSmaEHudN6tdWc+HJMp0dyGlSYI+A
	 x51go4dIRkKaSkbxkP+ZPxnOy4n8s7A53NYiNXDGwOmRBb8MAMG+1stdufFWxX/R3s
	 DEaXKLRxo35iQ==
Date: Thu, 12 Nov 2026 09:09:52 -0800
From: Kees Cook <kees@kernel.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Alejandro Colomar <alx+linux-hardening@kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	driver-core@lists.linux.dev, linux-hardening@vger.kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Geert Uytterhoeven <geert@linux-m68k.org>,
	justinstitt@google.com
Subject: Re: [PATCH 2/2] devres: Provide kmalloc_obj*-style API for
 devm_kmalloc
Message-ID: <202611120905.DF88D9849@keescook>
References: <20260914223212.i.829-kees@kernel.org>
 <20260914223219.901347-2-kees@kernel.org>
 <20261112004039.GA523044@killaraus.ideasonboard.com>
 <avWNCC3_Ff0knO6J@devuan>
 <CAHk-=wgYBrhvo2NAG_Ja-0ovPf=xO20Gcopv9Yrr1u=QVxECZw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgYBrhvo2NAG_Ja-0ovPf=xO20Gcopv9Yrr1u=QVxECZw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0FD5140005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 3xgknn9kybuokxwkoekzh4ywxnghwytz
X-HE-Tag: 1794503393-879616
X-HE-Meta: U2FsdGVkX1/Ft5aj8L2B/lGxfbdn8ap1rRMd5FzVegzGprB+92AMXV3VGPMcrc+r9sO/zDnzXVP60bSgxiwCCgOV7w7iJidhU0dZyfhfS+N1AwnM8+hmkK+77gR8NAi5UzQb7Tfjz8RWD3un8tQLnYl4zGc0n7ekcg/8BFjcFdN8T/5So72DeoTvDTQbxpa1utSrPrpv2+iTTT3mBdmAXpIDnlqZR9edaY2ZfDIB0tdzxjbRp850FgQGWBqVliz8AwZ7bK+MSPLZjWO3XkF5GE/vlksZpPuAHb+364+Ropdcn3WLTBY7jpok0LLPn43AqmzXDX/fxZuUDF6DiKdi8C3pOabgLrWm/Q0BPlXBCeFV3RGVBRS6kjjI5Rb30W7MnEA+CNayZHnRI3bRbHPor+y7IVRs4j+u5e3s02BBjTglgDWDKBg2EzpoJKo/UjfBnKlE45ll73yB5dhC8LUOfxi3+PdSbwr0cR2qbpLvaIq1gopq4aROWJCce5k5JrwGI0xH4IG9uGtHhvQ4IWPLNvrYy4J+dp31h8ajcqBJTsjQV5R3lQGK9/TQ7HbFfhGj1Ka5chjOE6IgjWjAm/eaGFS1l6yVTsg4dz810UV7VMN4yoXllAygzxql8VmF2SnW+tjbGhav4Ln4ZCxneU/UOO63qz/LOu0i6ajRLXWa8i5Ntm9Evam602dx8r4XXOZiEN/ADKOTICVcVpzdluY+piH2mtGIcXgnMRq7gB5GCjtcpKqvz1ZxLkswwB2b2yfnUPZCeCc5u8CajAC4Dv7OcmFMeEiCqczpelDnT9sM7BUlYxt7RKwLzQ0q6kZN5wX8h/6ZKkGeIY1P/IC2hgM324yNrZ+XNTTX/egf9/uJ6zvZCh5400o5EI4Pz5looL9RjfrBuaVqjmbDW/o6oClGs+d8dfU0gIpIsohKYwW0diyWBLiRmi5kEO5a0nUCefz5A8jIsWrV6mzcUBwWnd7
 2TZ2Uyr4
 67ECVGhuhM31EzTqsC1ZrzNIGERaTpM9hNi/Leld1WJczxug9s/zOXZh5e6zIApmlZ9EnTrAC31UKV86JLaNoTjxGMZK2LAbIPJd2CHpeJnxB7AVgwQ7NkdKbAUY/vwMjGWl9oM2r6WoKL5FpKe4sKD+ULCoHZAn+G594lyiM8Ekzw5qBs6WixIXOePk2po0alN1jeCYdPXk4U5Mxu/5zGifchG1DQarSxJSznZwHH9nKEz66ipYxq/5TZ6ELNinIMuMJ5ajmW31bSIb5o9Xbymi3FKiJwzsYLcmn1+r9iNlLRk4ELEyeuN6JrG7x80lgWtUJakEYZYIsEEwsAwZ7dkat+udy9Y5Nl+Hiriq1s8UCK9Ky1Ij0JCupwas1c82xuAFO5hrpmJQXKZn2QasmCDWUKi/1pfvGw5Epx/K36RpuonC4Mbf6sVOmNc0L/WSycdU0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 08:34:13AM -0800, Linus Torvalds wrote:
> On Thu, 12 Nov 2026 at 02:13, Alejandro Colomar
> <alx+linux-hardening@kernel.org> wrote:
> >
> > I suggest removing kmalloc_obj() entirely, and using kmalloc_objs()
> > always, with a second argument of 1 when we want a single object.  This
> > would remove the risk of that typo.
> >
> > I also suggest having default arguments without variadic macros.  The
> > way to do that is using empty arguments.  Linus complained that it hurts
> > his eyes, but it really makes these macros much safer.
> 
> No to both. These are both "make the code worse to catch errors that
> the compiler should have been able to catch anyway".
> 
> If you *really* want to catch them, make "gfp_t" be a 'struct'. That
> way even compilers without things like the restricted types that
> sparse has will catch at least that one.
> 
> I did that many many years (argh, decades - I'm old) ago to catch all
> the 'pte_t' etc issues when rewriting the MM layer, and it works very
> well.
> 
> It's going to be somewhat painful, but ti might be worth it. People
> who only use GFP_xyz flags to pass them around wouldn't notice.

One thing Justin was poking at was adding a "strict" mode to typedef
that gets us a new native type that follows all the same rules as its
underlying type, but refuses implicit casting. That way you get stuff
like gfp_t or pid_t that still works sanely but refuses to take values
from non-matching types (i.e. it would catch this case). It's handy for
the Overflow Behavior Type work too (for similar reasons). e.g.:

typedef __distinct unsigned int pid_t;

or something like that. Then you don't need the accessors like we have
for the struct-style wrappers.

-Kees

-- 
Kees Cook

