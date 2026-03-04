Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 492F4EB7ECF
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 12:48:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76D066B0088; Wed,  4 Mar 2026 07:48:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71A846B0089; Wed,  4 Mar 2026 07:48:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 626CC6B008A; Wed,  4 Mar 2026 07:48:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6106B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 07:48:35 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2A8C5949D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:48:34 +0000 (UTC)
X-FDA: 84508359348.14.A19E32C
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf01.hostedemail.com (Postfix) with ESMTP id 382D34000F
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:48:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=U5NhpZCn;
	spf=none (imf01.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772628513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YsXg2qDZ+ZjnQnj/eNfiIgU3SLUyimkRR7bx5y5oB4w=;
	b=E0HiuQQsje5pR8XO/ntrMOcHtOqTW/yn7xI8i/9QA3spNfU0Vgk5wZiQgHq6kzJzP/qeli
	rf5eznoDoS+OQ4unwNJm5GE2n9Dvpj2+/dfc+/VBu2uj+LL/uhIbvmsnYhwDasUJyh7Xo0
	EqvX3QFG8UOCKAQDHJs5DqUIfdgC4eA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=U5NhpZCn;
	spf=none (imf01.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772628513; a=rsa-sha256;
	cv=none;
	b=sELyvNUdDvb7J+oAtvyuX7e8TBvkxHARH4oEhzyJGTziH4uZGEkQEIIJyTQfqb1R+wm7bx
	3ta1BYqjvtOkqbfx+iDJ6IQ/okuseCjOnPPNsa3mNxrmikxdzgFpVMZNz426icKay7Fc+w
	j1d82dRUnHrKwr86o+QPFUX1F65cuFk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YsXg2qDZ+ZjnQnj/eNfiIgU3SLUyimkRR7bx5y5oB4w=; b=U5NhpZCn934XojSyVFL1nj1S/W
	2SwNvFKnKgDXQSzq6m51IMvSlZX+ne4bEh4E01vZtYgpLee5ixUDi8qEHb4R97fy2f4d2ReNAtXFl
	2Myy/FM9yjpIi4F5MCjGcXNEoyN2WDgyc7039UPkredIXwYhk1etVNasHnwai+IB6c4ro8VQTd24m
	dlAjACdWYLWNFfSy+VdBxKivYhNczBRSHxMPHao0CvqQusPNjCznq/i4rksmb+FqExqEhxu3s5ruZ
	HIicL8wW2i2h8YBWX0vQS1a34HK9wPAQFs79TabY9VaeD6tSKbvzAdMAvOXPYXBWy7iVhi1jbb7PJ
	KVa5pNSQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxle2-00000004Z42-2KL8;
	Wed, 04 Mar 2026 12:48:06 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 07040300666; Wed, 04 Mar 2026 13:48:06 +0100 (CET)
Date: Wed, 4 Mar 2026 13:48:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
	Yury Norov <ynorov@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>, Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Anna Schumaker <anna@kernel.org>,
	Anton Yakovlev <anton.yakovlev@opensynergy.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Borislav Petkov <bp@alien8.de>, Carlos Maiolino <cem@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chao Yu <chao@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Airlie <airlied@gmail.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ingo Molnar <mingo@redhat.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Linus Walleij <linusw@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mark Brown <broonie@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Namhyung Kim <namhyung@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <pjw@kernel.org>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Simona Vetter <simona@ffwll.ch>, Takashi Iwai <tiwai@suse.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Vasily Gorbik <gor@linux.ibm.com>, Will Deacon <will@kernel.org>,
	Yury Norov <yury.norov@gmail.com>, Zheng Gu <cengku@gmail.com>,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-block@vger.kernel.org,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	dm-devel@lists.linux.dev, netdev@vger.kernel.org,
	linux-spi@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-mm@kvack.org, linux-perf-users@vger.kernel.org,
	v9fs@lists.linux.dev, virtualization@lists.linux.dev,
	linux-sound@vger.kernel.org
Subject: Re: [PATCH 0/8] mm: globalize rest_of_page() macro
Message-ID: <20260304124805.GB2277644@noisy.programming.kicks-ass.net>
References: <20260304012717.201797-1-ynorov@nvidia.com>
 <20260303182845.250bb2de@kernel.org>
 <f8d86743-6231-414d-a5e8-65e867123fea@kernel.dk>
 <aaedwFwXh9QXS3Ju@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaedwFwXh9QXS3Ju@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 382D34000F
X-Rspamd-Server: rspam08
X-Stat-Signature: dbk5stpzdbeeteapktxznkmoz6w6wozq
X-HE-Tag: 1772628511-472846
X-HE-Meta: U2FsdGVkX1/Q30KDCA1rYbx9TZjY2xqDK0OYYCqxB6/nPgZEP60uHzLRHSKMI4u9nE61ltLs6u+ywWWUY67b8Yg4MX2S7hdi51R8szxtj5d6eouIEIMndiHkgXqxjzSr9PYEH+NDeiOaoObqIqA1Eqj3nFS2lneQQeQ1fYe0rKTjQXQOCfrbUsts2JZN78LnfcVISZK2Cz2zVJjZNLaWMn6FJQ47k9+E+Cuxvni6pkGLtTgK8IF8iZu50GbDBEjFAS8Zmdv9BsZZyk2MxJmLmzjQD31Lt9JE7vZ/s3+v5AlBodAXoA95j3JA1jyqSiBXc8NyCoAEwUyjnjJod9zdMfdTx4rPuvXb0p3Gpw+b5CK6DVAEXy93pyICfncqPoHUbKY/GNk7RuapYVGzS4SW9k+1StFay8muIeL9nImNSed7YvGXsueLBX+7z/V81zxGGdB0RWoTq6Zx338aYbQ4XZ2MZNvjv2y9QUyGL/20OtLart0lyCaqT189pysiOvPTmdt2AiPqNBUjToddHggD1Vd1TuFdQZ8hFF/Igum4P59NZWZm2xkW+RxHabX+oRsx+qGlazV4WW/U1FHi/x1GVfjsktbj7dMSQ2xVwrZD6ZiXteAKsfCzPBgZ2hCj187Tr1CAzw97crPmSYFPxXudM68LQm4gnz9LQGAQ6K2tOl05nBeuiCLKUckyrJ54FLPNeVKPRJkZqQ8L5cQqfUrcXLCjhAwBp+7cUsfo/Op7JCOD1hdwVvshIjcMwf1V0SToXAmiYmISazyL5BXNbSPYNxxM0VA2SGmsNevUnQuJECyCufIWwn+vS79u5bxdFCpDONfm0H+fNp2jQ2bCFkYHeNjzTS1GRB0dUUeD8rMMRq+2nrFPZWBzwdDPFbwhBUZtSzX8/F6dF4oTAgLhqPmfyLsoS7dstRpD78rCUUwR94b35NjuAjybyyDawt9hfyyJ8DOq73RRpNAbzz3Qlx9
 0Wmbrwfv
 Euza4sjxF9Ge9V1MSY2YzGEZciXUbvtBKZYz9iBj3RT5oz7DXHoL0SBUv4rM4K/ygC+4ut5H5ozPhyoQPiuxe3VlTZxJkH9kIrjYk7oaUT5iu/wCYNAjVPd5Vq10atm358A6G9cSyrXcg3BegP0doxT3cXwDJnbIaEJsZzsQFm3xeBPKcHdWnJ1lWqGQ67l3kgdIB1XH+yufyeq6TlAWlScbCjwdrRuy9EUK87RkWi1INNIAd7zGAKpFnzbXSG8tdBZhoUFxQ3xaKncF+wSogrqmx4KOvztqVsWVc1WnRn6HohVNXUSSI82zSyc/RPobXt0yuQwTlkLODulqBsaozmH3ail35pnFrm6Rb+Omz9l66dVmH2vHzI8eTl6sdgbpsiwRJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 06:49:36PM -0800, Sean Christopherson wrote:
> On Tue, Mar 03, 2026, Jens Axboe wrote:
> > On 3/3/26 7:28 PM, Jakub Kicinski wrote:
> > > On Tue,  3 Mar 2026 20:27:08 -0500 Yury Norov wrote:
> > >> The net/9p networking driver has a handy macro to calculate the
> > >> amount of bytes from a given pointer to the end of page. Move it
> > >> to core/mm, and apply tree-wide. No functional changes intended.
> > >>
> > >> This series was originally introduced as a single patch #07/12 in:
> > >>
> > >> https://lore.kernel.org/all/20260219181407.290201-1-ynorov@nvidia.com/
> > >>
> > >> Split it for better granularity and submit separately.
> > > 
> > > I don't get what the motivation is here. Another helper developers
> > > and readers of the code will need to know about just to replace 
> > > obvious and easy to comprehend math.
> > 
> > I fully agree, I had the same thought reading this.
> 
> +1 from KVM-land.

Right, this. I hate these pointless helpers that obscure perfectly
sensible and obvious code -- and for me that includes things like
rounddown() and DIV_ROUND_UP().

It just makes the code harder to read.

