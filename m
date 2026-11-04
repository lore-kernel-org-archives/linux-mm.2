Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 027A7606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 03:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=FLJt7xeV
Received: by kanga.kvack.org (Postfix)
	id 8D28A6B00EF; Tue,  3 Nov 2026 22:58:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 885376B05B1; Tue,  3 Nov 2026 22:58:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79ABD6B05B2; Tue,  3 Nov 2026 22:58:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56E7C6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:58:28 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E13901405BF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:58:27 +0000 (UTC)
X-FDA: 85396079454.23.5DD507F
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf15.hostedemail.com (Postfix) with ESMTP id B62F1A0004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:58:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=FLJt7xeV;
	spf=pass (imf15.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793764706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jBo07fOEWVwUuN9u4WHUrXqePYbjYoVaNQovLhhi8es=;
	b=7M7anenVOUPV5lpHowpZ3u7ACqUoA7xXLnX8eVJaUwGqrCdWvErZzYu3uuuWjeHeIBo+ed
	Y8pEfzSDBfJuiZCyJC5ycqAitHaDRCUXnrQ6sdd8CNL1tyizc5XSbgR6o7Ad07U03i4m7W
	7ra7CPDKRkGDsPjtQX3xuWz7wpnYvPM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793764706;
	b=nwAptkbT5fVL6Kh6JO+Vpimf4vVMeOENZqBo1ss703f4PCjeP5wJwbhXKOjq7+Xwc+pMJB
	wqnhO4jHGdhnwBJ0RmcIPcTrtC/oAul2KrcHO453qw90EqI7Z6JVOyv8aIDUfdkURIn7Pv
	K5M4jmCR5d/s+nL+UFKIWFZdG1Z9bBc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=FLJt7xeV;
	spf=pass (imf15.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=jBo07fOEWVwUuN9u4WHUrXqePYbjYoVaNQovLhhi8es=; 
	b=FLJt7xeVbrruK9dl1EfStDNmT/eXoP41VWYc61uQoHO/NVsnVVfM8iUpSVku6SIYJ0zVWkNcdFV
	e9+dAoUBDUFeBcDrX2bX4/tjNRm646Rq5IDpJdNBn0f/yWoCJuTtsCSy7SdVWW8OSD3yyChilwtj4
	hJSO033W2f6d510VftXQzarE5VNkpNy6cGw7LthhGPe1CMESDEpWRQKbcb1pJUOE9GEOoOWvDdBfa
	8cJScxPAfIdpx4ZWnZlBsP9VsGfnRl2WfheGNks9e+aaMYszYHMYHTAsrCA1xveNoDP+MG0uNTuwz
	w5SczC3p/8LzmTqoIrPyFxNJFnXReRTeUf5g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xOS8U-0000000AisY-2lVq;
	Wed, 04 Nov 2026 11:58:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 04 Nov 2026 11:58:06 +0800
Date: Wed, 4 Nov 2026 11:58:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Liam R. Howlett (Google)" <liam@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>,
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <auqtTjXhD8is-y9f@gondor.apana.org.au>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au>
 <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ecitxd33iagbkbtk811dogma8xou96om
X-Rspamd-Queue-Id: B62F1A0004
X-Rspam-User: 
X-HE-Tag: 1793764704-450512
X-HE-Meta: U2FsdGVkX18Z7foH+2KpnbAyQzPjKeAQxTyLhr1ql27+ui61NooOxwjXQTUkrzHe96GY3WRGpZBXXhjJAIJ+dR1Ku19JzUyTHwcexVPCTaqo08GhrK4EUEdglIdMpAr7LBkuK1UXsDRU9ELGVaGuGm+j7dmJ6VcMjdyTyjD0Ei9XaQIqPBfCstenOFc0WpOf4oE1U5YgDKA9IXxTQ/uRxS/beiWODn0K2514wjKqFrIDvh2gfeFH63LL9sl0/yHydcARZXEMdE67GpWyH2/C770ca/rn3MKKXHGYA710Qi1sfmqLNaOTWewM6LHZqt+zeE4/u7F7n62iWGTAQiyZA3m6+K7CXQW4knJt0J2FSxrIUSplFM/KlCmUzQ07mxML4unCaOeT0HzLGAAN9NIVhr5H2/OcMfmcm7T87WW2EFPU4cw8bxB3jaKR1cxi8jJ57L4Gu/jbqm1Mn4gY5N5EV9IT+rCPeFTQTxl0Qgvq6qJ6/FboWi7b6rn4gc8+Bm3ZRTAz6l8iH38wZSZoOeiiEXJ9gVoFH7dyVN7gHTT0t5v6jb95AwFQbx+m451xcgE8esqA6FQNnoLoVMgRQCidTV8YaqBkQlso3bYJenTLpCWv2jhrjCR3fk1UJXhsTyVMhRT1I/RZxDhYucDV/VH3P6Nxo5Fk86ojeZlF/olO44upORv9M4cqW8VqyN173Y7gcYiNzN7qpX1CCu/9zewIqpliN8kEITfWitERHREJOVpz/68dC7KL0l0g/yksCQ50S3ERsbSJUoMrbeppXHFAO01qDK2wh7LxQMvHuyt1xflQThGMko1zmsxrfpTDrp920ZglDsr0+l/lf+yKWomNzkf4JmDU4Xo3MamDRgYfiQwb3EYF+dAnaN2SjiC3ObeaoBgr7X5u6FYERIN8xMR+dgvee0a2g+t6R6RnBRYrKXuq+dDMTpTBSRAJ6FHHHXncXTDkaXz2AEBFXWlwQRW
 vaBudbkw
 Sl+Buhfe8G3ynVAt7aghC3hSZDHqo7r4SVzJns/y/z/A2HeIkaPCyJc6x1o5FE28z0/ictAt/Oi3FXJM7Uikdc/Lxv7ZC+sG5EwmU6u2MM0w3+x114E29LDaknn05hd5rRRDJoN0CtzgyjaTgbsiHFZ9c1oO/OvXkr6kIzK+Hh4IwddQzCknaWc/HIda4xkWLR+8NU4fKIM9y2xGY+r/+dtVz4SnvWtOplxJI4M/+ZSqt1UZzyujXGHfXabLoxy58seHRQ9RXlg5BZk3ZuBqwDnwIOR4qmlX+1zbje9FepaKDbtZuvTYpz0U1pVeQwzsz2rUHGJ+Ew0U/NNcsmb340ube22ebLS3iiWCE8c3KEzF2gRe2CcP6Suuewm2CoxsY7LtQKENQ0yRX6veK8LnBwZpVPxKmQofOUS2Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 08:49:23PM -0500, Liam R. Howlett (Google) wrote:
>
> I don't follow.  Reverting that patch gives the same functional flow as
> the patch I already sent; kzalloc() for one branch and kvzalloc() for
> the other. 

I'm not talking about a literal revert.  But that patch is what
introduced the use of an unconditional kvzalloc for the !GFP_KERNEL
case which is what we are trying to undo.

So it should at least be mentioned prominently in the commit
description.

> We will, however, restore the useless __GFP_NORETRY flag to one branch,
> and a broken check.
> 
> -       if (gfp != GFP_KERNEL)
> -               tbl = kzalloc(size, gfp | __GFP_NOWARN | __GFP_NORETRY);
> 
> gfp != GFP_KERNEL is supposed to just send GFP_ATOMIC in here, but
> instead you are sending GFP_KERNEL | __GFP_NOFAIL as well.
> gfpflags_allow_blocking() should be used here, right?

That made me dig deeper into the original change and why it was
made.  It was actually Linus who suggested merging the two calls.
It's a shame that we have to bring this pattern back.

https://lore.kernel.org/all/CA+55aFxnrwFniJq6nCFn4pWRHLH-Wac9bVFKieBC-TixTsFg=Q@mail.gmail.com/

Let's add him to the discussion and see if he can offer any insights
on how we can avoid undoing this change.

To recap, kvmalloc was modified in 2025 such that it can use vmalloc
even when called with GFP_ATOMIC (commit c6307674ed82).  Unfortunately,
it does so in a way where it has to wait for other CPUs to do certain
work.  As a result, if you call kvmalloc with GFP_ATOMIC under an
external lock, this easily leads to a dead-lock when other CPUs end
up blocking on the same external lock.

Hence rhashtable is being asked to undo the change and reintroduce
this pattern to avoid the dead-lock:

	if (!gfpflags_allow_blocking(gfp))
		tbl = kzalloc(size, gfp | __GFP_NOWARN | __GFP_NORETRY);
	else
		tbl = kvzalloc(size, gfp);

My feeling is that the new kvmalloc is simply broken but its author
disagrees.

> You are saying to add it to both branches of the if statement, right?

Nevermind, I didn't look at how alloc_hooks_tag was implemented.
This is simply disgusting.

But instead of

	if (gfpflags_allow_blocking(gfp))
		tbl = alloc_hooks_tag(ht->alloc_tag,
				      kvmalloc_node_align_noprof(
					struct_size(tbl, buckets, nbuckets),
					1, gfp | __GFP_ZERO, NUMA_NO_NODE));
	else
		tbl = alloc_hooks_tag(ht->alloc_tag,
				      kmalloc_noprof(
					struct_size(tbl, buckets, nbuckets),
					gfp | __GFP_ZERO));

, plesae do

	if (gfpflags_allow_blocking(gfp))
		tbl = alloc_hooks_tag(ht->alloc_tag,
				      kvmalloc_noprof(
				        struct_size(tbl, buckets, nbuckets),
				        gfp | __GFP_ZERO));
	else
		tbl = alloc_hooks_tag(ht->alloc_tag,
				      kzalloc_noprof(
				        struct_size(tbl, buckets, nbuckets),
				        gfp));

It would be even nicer if you could add a kvzalloc_noprof helper but
it's not a deal-breaker.

> The fixes tag should still point to c6307674ed82, since that's when the
> issue became visible.

Sure that sounds good.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

