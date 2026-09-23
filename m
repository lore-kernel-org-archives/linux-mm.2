Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5C0DC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 20:41:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C9176B0088; Wed, 23 Sep 2026 16:41:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379906B008A; Wed, 23 Sep 2026 16:41:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28FA56B008C; Wed, 23 Sep 2026 16:41:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 089B36B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:41:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7931E80124
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 20:41:14 +0000 (UTC)
X-FDA: 85246196868.20.28D258A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5A1C040004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 20:41:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rjF76z1T;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790196072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qONh2l5INlxfu2beMizxai+yM+C9ThOD0d+OddXoP6I=;
	b=JO/U1KNNyfGQRLGQ7lOZXhs2oZD8RZgG25sPkyoiHEtX5v3tAl4Tqhfd6AfU6VAoTfKAN5
	+gN1vvl1oGPqTqIg4Jhhrolz2tra9THCPD0uT35fBIbQHMmztcruY8+PI6/2Nexlrie+OH
	/E9qnGOqgE2lYfWLSQMUMQvooj8J5Aw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rjF76z1T;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790196072;
	b=r70ZPRRtErIYhazHIXa75pNtog5bHZXGy2XCbdntN2/6rXxEBscptl7PQhcmLDTVg9X0z7
	HzP/J8JEppw03EaVnPy514cnJQikDB3Puvprp4TMsz24eO+qEeo4EXRoeFN3A9NP48YAHq
	PGg7NGK/MQS32i1ST2suVLtZ2gwNIrU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qONh2l5INlxfu2beMizxai+yM+C9ThOD0d+OddXoP6I=; b=rjF76z1TuHFgs86HZvoksm7tHg
	3f8pSQIN7OimPUo6S0pK8X3t7zgmPtNzGFceZ2POItaxvlafK7wPpvO6QM+nczSV7RQLw3cu0wtS/
	1YZ+FrLr1k3WrCz2GpTwGKJ15sp0CXYZwJz0g6n2rW8oKNj8XgWdChHOLHo+gACp1huGBKFWBADeE
	E1223Z7pEp7h+9RFqTakbI4iTeB0B0LDtlV/wpgYCCw+qVI/d3F10bOVK5Lf0og5U0V6KHAtyY8kF
	qcDpy70jtOaCKPn4KzYvi8rITnLWFvKk5KytnCWMP2QadBwSN56gt/2RSNFYY9SGbES9dWwrCckSJ
	FEtL0XXw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9Tm6-0000000EPAO-47vu;
	Wed, 23 Sep 2026 20:41:07 +0000
Date: Wed, 23 Sep 2026 21:41:06 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH] slab: Remove slab_folio()
Message-ID: <arQ5YjQbs3pd5-KS@casper.infradead.org>
References: <20260923183655.3364885-1-willy@infradead.org>
 <arQqdeTaYf08TYl0@thinkstation>
 <9bbdcace-0769-4391-9c97-e18e8a0fd207@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bbdcace-0769-4391-9c97-e18e8a0fd207@kernel.org>
X-Stat-Signature: pbfigairwiqheido3d6p3bn6ad99344g
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5A1C040004
X-HE-Tag: 1790196072-476891
X-HE-Meta: U2FsdGVkX1+XJZkQ0Vb/rMOKiTM/RLTDFVhq370e4Pw3K7hpFviWnGLhE/dsT/9ZxIgbSggS6fHyfpkYxagjcme4sn30REs+YL0V2hE4wNwIzspasc47qr2zu2YvyBilKdfgdOqC7E3CcMPkV1UmXiOnojwpso+NneT1flOD28XpKKbKvD6xfijVRJS2EXuvQPbKjIkWTWUH6mLlN92o6CsbUlwqYcJY1UzEIL/zauj1Vp0N8qphi153C5PqC2629CKASiojlslOLLMYEBg3wgP8QvUpkcAnsRJCUl2QMuvgTIbMhJ1DMXVm6mEASlxYyK6JyOyCIJHanQYMDXlNJdwBVLF+Ex5pojqd/H8vO5ZJX3WOk+qXYHYTKs6wg8Y+vfNpXxQEqzmPVfaeOBTx+Cq1PpcjekwBOqsPoPE8y197JJQ4GcWtmqDscIWQ7dn0/hlWAmZZIkiZu9KvPZ5Acv2jDs1Cm6fzLQ82sSyRUEK1pmLqeZ2ex/KBvynfaFqs7hwxI7VdSFtjxreK3EQn76rgQN5+UjqSes84usgIsF6m8B1psMS8JQae1bo0TN5mzVkhxKpwBi34NwBupTJt+srKTE/q5+FuosqIW1wzROx3G3zTM69O8hDK9jQi9yM5MrlCc1CSFpxjQHiMGMPjsm3XBoEoELu8QWrE8o/c5S2bBLEbHtA96Tb4+nubWE6RbPDN5gwCsf62r7lR7GPsL6U3v1Etsahdjc6Rb979ZfpHRTFHEXFMjnefNBgW24wnV9nhmbWUd2KKpydBb4zujftoT8E8Ausg4j0Qfn35SD7yTkkJVV6k5QyE5a6fE4B2u6q+G4oF75H6EyshARI1N5QYQRZMGegKmaxVg7zKjFj57ZGKCRDzUzCIn3WENtT/Lo/Vgrfd1IvwGdF8bdwFwMN7gEaXrtZtCDU4DAsJ5hDH/wXrYZTlso2IMS5kXBVlLc2zc9gzrn9iaH3XQ1O
 iLx6CXpB
 MUq9F1wVpTqpujnC5pcs0HRW2BRbRZt7RqMHuXngZgc5pE3nb0YhD06493fHmhkiykBVwxQZ5ca6mPu4MKqeDzpmL+N5dIKpZfrV36n5oisWrku+U4mmQwnIKuxgFPjSShltIhTJHcRO5o/vDnRRa/C3Sg5y6ZCQPV2vWClUUIBJgEmAnfueRKKepV6krBReRNhoTUwpRwNQLNysafTlf0ybCmaH5xwAU+ljSYk8oxCkVp8QYUEJKKcTu5Hk1EpGy7qhN22Dpq0e5Y2aGWFoYsa3JkTVmrmn02XMw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 10:11:06PM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/23/26 21:45, Harry Yoo wrote:
> > With a tiny little nit:
> > 
> >> @@ -184,15 +169,16 @@ static inline struct slab *page_slab(const struct page *page)
> >>   * slab_page - The first struct page allocated for a slab
> >>   * @s: The slab.
> >>   *
> >> - * A convenience wrapper for converting slab to the first struct page of the
> >> - * underlying folio, to communicate with code not yet converted to folio or
> >> - * struct slab.
> >> + * A convenience wrapper for returning the first page allocated to this slab.
> >> + * to communicate with code not yet converted to struct slab.
> >     * A convenience wrapper for returning the first "struct" page allocated to this
> >     * "slab" to communicate with code not yet converted to struct slab.
> >>   */
> > 
> > Perhaps you meant this?

My eyes are old and don't notice punctuation as well as they used to.
What I meant was:

 * A convenience wrapper for returning the first page allocated to this slab.
 * This is for the benefit of code not yet converted to struct slab.

> Yeah, and I wonder about the "code not yet converted" part, and if there's
> anything we can still convert right now. What I can see among slab_page() users:
> 
> - slab_order() - we could probably add order (aliasing page's order for now)
> to struct slab right now and that would be future-proof

That's trickier than you think because it's stored in the ->flags of
the second page when PG_head is set.  When divorcing slab and page,
it moves into struct slab, but we can't do that in advance.

> But:
> - slab_address() - I guess can only be converted once slab is divorced from
> page?

Yeah, it becomes slab->virtual.

> - __kasan_poison_slab - same as above?

The loop calling page_kasan_tag_reset() makes me think kasan really
wants a page here.

> - several VM_BUG_ON_PAGE() usages - same?

We could probably introduce a VM_BUG_ON_SLAB if you're interested.

> - validate_slab_ptr() - same?

That'll change dramatically -- if we want to validate that a pointer
really points to a slab object, we'll want to, er, ask if
virt_to_slab() belongs to the slab slab.

> __free_slab() - same, obviously

Right.

