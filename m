Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DC10CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 20:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84FA26B0005; Tue, 12 May 2026 16:50:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 800DC6B008A; Tue, 12 May 2026 16:50:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 717186B008C; Tue, 12 May 2026 16:50:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 638026B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:50:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07AC2160403
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:50:48 +0000 (UTC)
X-FDA: 84759961776.08.D10C055
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 52876C0007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:50:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=MqXXv57B;
	spf=none (imf22.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778619046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWStSEwgzx60kVon+5J/IIIjCujBnqO9UfUs8RrKRaw=;
	b=XqMKYjl9JhrXGlzVxv1u6zU4f0yyo5CLkRd1m7OTimgwhiaOyshj6UVJyAr4WUrXBQEdc9
	J8O4f8AhzfpxT49GIKMJDQqz5Ra4tifhJs4T2sTlhruBZQWf2fdfEQlfh1Wu2T5yIG3/K6
	BQZgAC3e5B8laMefvb/7+DLjh34GgKw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=MqXXv57B;
	spf=none (imf22.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778619046; a=rsa-sha256;
	cv=none;
	b=nSfr2r8ajSKlgJ+cmyQO6KFkgifde8n8qkv+zo8LYpkIvu0zdo3stls/g+RiW5gp24z+yc
	XLwbBnGVhlw8xqQ8GYvV0jc0J6oIijomKFODHAHyc0lZqPUK/BGTVJSMLDKrIvG/VxFITe
	56IdEsEddpemrSLxvKEbcudG94heB9o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EWStSEwgzx60kVon+5J/IIIjCujBnqO9UfUs8RrKRaw=; b=MqXXv57BUFTs0Lc7VnWZ4gN3aJ
	KkLgMSwbveGvop/smi29ccAw+P8gcmimJ3t0ApUBAOgkV4vGk4kbuGQJHynvlj0cf1B1OXjOOCeai
	El+LLjfNmtVG2p/i15tSBh3ihmehDCDnNfjBKHntMLVAYW26/q2B5PTBoODj2vTR30KWHgjM/Ka4e
	AZKbYahRnuH4JgQfHZOMfYCwlcJlQCV4B9c6PJDJVvb9A7aAhG9Doww/l0yJQF1BtKY6TL1AAEhkD
	8DB941zsS6xIo7XUaMqv+eH8XsuH/2xshdjq6j6VuVNzMuq/8mhAuO3uO3x1p9+Jm2rjS0pizRAHb
	KENrQTDw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wMu3v-00000000OE5-1sSh;
	Tue, 12 May 2026 20:50:43 +0000
Date: Tue, 12 May 2026 16:50:36 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 2/2] Documentation: maple_tree: Clarify behavior when
 using reserved values
Message-ID: <kkunuk6hph3uwljo26qqgskczsodydsxvbadycube6n2rldjba@rz6of4335slj>
References: <20260504165746.1422057-1-weilin.chang@arm.com>
 <20260504165746.1422057-3-weilin.chang@arm.com>
 <5qnwgdcxqat2zo5qe7qy63xm5awo5l4lkdkf4umbj3sl2ct5sj@v5c3szzdbbq3>
 <q2dtphja7i45kknjk3bs4hn2bpictyoaideyjfbdh4sz4pxllo@xtsyvo3eztdb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <q2dtphja7i45kknjk3bs4hn2bpictyoaideyjfbdh4sz4pxllo@xtsyvo3eztdb>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 52876C0007
X-Stat-Signature: 3y1m1p8dgoyefb9jbudtnyqarjzmcmf8
X-HE-Tag: 1778619045-339374
X-HE-Meta: U2FsdGVkX1/z/rlkR/MElcw8cvxZUewH86zmNHqzH7TheQUURHxT8evpXG/X9qzKwzm6FFTS9/H2RZg7DLTpnYz/s/R0wCDWKpB3BRRgVqKQ+36XpgO82R+qLOiE2u7qcPCKdX8jHkvMM4I+UpMXjuu5z8p3123KaYsH1hrwiI5zT5NJ9YmqjHf2qCjXtKWpkYjqUjC4qmpLhLbNjPS35Oy82tYY8tX2bgtcQEdqOaXRJp1ABnNwkvcKAm5Sope3zZAxKIAL7aOyxTa9+/sKXhhervXS2ibadEopLSMxcFWHMzYny/MbHWhbi1f2zpSniJOZ7qUYDc74pyabzZS+B0o2W1jeuRVg8VqvP2gf8dSPMhtGrXIRdh4hBvG3fFX40fpG5lliBcvnZyDoIrktSMNxhPCPxrEjXCLqg2Ofu582kZJYd9ygT3xoihPJtvJgiBikibp20JtB3M8OPdVbpRiVJxI3BZev3GhlIgdrcwM0teWevCz0rM6Zlq5EGcZi+OGWPbr0JcLHD+rlMn+mA86cnkajuBPWXak8GuZ5tiphx4Jrmp+ewrVWNYVps6C+PBnBPs0frVDLKD1PxoGb8Ftqv4Rxya1dTbT53bIQba6fStVHp+KjMlqOxPMsLIT/h8vpDePbB2w7x3oh6HUZ8zHaXGruAwsBJdRMjt78GwBI4rc8OW7hApCZTmDVgWWi1vkABjCOgb9aeAMrtKa9mcAabmYWbMF6r14LG17oBOlTAdLqJNcepRIMA65fGLxpQeULsDel6WFMd7TvFKrtwJNO9cDDFsM2o89/GtZcMV9/jJstrmKdEdD8NkRbSOWMRNQ7kH75bGrn2yvWEWMUZc8kDKoCdGvMdi02JCLJHHSnJXyzqpKCmX3znZlbNYvdcMlYE+IdBSmDDC4rg+79gQm+CfXB4VQZw9BW0F+Rhf/N6MiZ+R3mTjrs7fVlokXLt5oeu5uMV0DmsvQgK09
 7844/0Ym
 WFaRNCzC0agin4GAb96k2fhSj87vyRb6D/SiQgtPi5erZ6E927GWD9/htix4/pAeqfH6M88Ydq9kkO7PK+cTfJD+aXQx5KLEczexja78NbsJk7q/hvstCUeLwV1YiFqLx+wHvuzECMLfdRo/oFCtm+uwyuMO7NJsvu1Lp9lha00umCH9/PPxXWwXNS01zSTXAHKo6RE80SALGRPu8M3fjKFa7JE1jT2sy1v5PhVun4tc/Rk4EA+QoalR25EipwlQSW7HbHfESmAJ2PWLU6VGaLzENHGOnDc0QzEwQspnxoVkWe0+nA+aip0LySVSS4sL0D86ecslpLBpaapbHUE8AG5DwCaiGAB9zg/aXC/1+/+NY8b1/cK8sMRcSavMBcmrCHY/0+rylI0zeDSk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/07 11:09PM, Wei-Lin Chang wrote:
> On Thu, May 07, 2026 at 05:24:11AM +0200, Liam R. Howlett wrote:
> > On 26/05/04 05:57PM, Wei-Lin Chang wrote:
> > > It doesn't matter whether the normal or the advanced API is used if the
> > > user uses xa_{mk, to}_value when storing and retrieving the values. Just
> > > specify that the normal API blocks usages of reserved values while the
> > > advanced API does not.
> > 
> > Your comment above is incorrect.
> > 
> > The normal API will filter out reserved values on return while the
> > advanced API will return whatever is stored there regardless of the
> > value.
> > 
> > Meaning, if you store a reserved value with the advanced API, it will
> > not be returned by the normal API.
> 
> This is valuable information, thanks for explaining.

Hmm, maybe I answered too quickly here.  We filter out XA_ZERO_ENTRY on
normal API searches, which is in the reserved range.

> However, I'm confused how this shows my comment incorrect?

It matters if you use the xa_(mk, to}_value since the top bit will be
lost.  Re-reading your comment, you don't specifically say that though,
you said 'if the user uses..', so I was confused by your wording of what
you were saying.

> 
> From the original doc:
> 
> <quote>
> If the user needs to use a reserved value, then the user can convert the
> value when using the :ref:`maple-tree-advanced-api`, but are blocked by
> the normal API.
> </quote>
> 
> To me this is conveying the following points:
> 
> 1. User can convert the value with xa_{mk, to}_value() when using the
>    advanced API if reserved values are being stored. This works because
>    those functions transform the reserved values into non-reserved ones.
> 2. User can not use reserved values with or without xa_{mk, to}_value()
>    with the normal API.
> 3. What happens when reserved values are stored is not clearly stated,
>    but the normal API will block it.
> 
> In my understanding 2. is incorrect because if xa_{mk, to}_value() are
> deployed, it doesn't matter whether the normal or advanced API is used,
> they both work since the values stored aren't reserved.
> 
> Please do you mind pointing out what I am getting wrong here?

I think you are missing the part where the top bit may be lost?

I also don't think the reserved values will matter if you use the
advanced API exclusively.  You would have to filter the special cases or
whatever you want - that is, if you mix the interfaces then you may see
odd behaviour in regards to the special cases in the normal API while
the advanced API would return the reserved items and need to be filtered
at a higher level than the maple tree code.

> 
> I was genuinely confused when I was reading the doc and trying to use
> this data structure.

Then we need to rework the wording somehow.  Thanks.

> 
> > 
> > > 
> > > Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
> > > ---
> > >  Documentation/core-api/maple_tree.rst | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/Documentation/core-api/maple_tree.rst b/Documentation/core-api/maple_tree.rst
> > > index 87020a30ba69..e5ccafb84804 100644
> > > --- a/Documentation/core-api/maple_tree.rst
> > > +++ b/Documentation/core-api/maple_tree.rst
> > > @@ -30,9 +30,9 @@ Tree reserves values with the bottom two bits set to '10' which are below 4096
> > >  (ie 2, 6, 10 .. 4094) for internal use.  If the entries may use reserved
> > >  entries then the users can convert the entries using xa_mk_value() and convert
> > >  them back by calling xa_to_value().  Note that xa_{mk, to}_value() bit shifts
> > > -the given data, so the top bit will be lost.  If the user needs to use a
> > > -reserved value, then the user can convert the value when using the
> > > -:ref:`maple-tree-advanced-api`, but are blocked by the normal API.
> > > +the given data, so the top bit will be lost.  Usage of reserved values is
> > > +blocked by the normal API, and will cause undefined behavior if used with the
> > > +:ref:`maple-tree-advanced-api`.
> > 
> > Which behaviour is undefined?
> 
> I originally thought storing reserved values could break the tree
> because of its internal use (see 3. above).

You can't break the tree by storing reserved values.  The normal API
will outright not allow storing it while the advanced API will store and
return it.

The issue comes from when you mix and match - if you store a reserved
value using the advanced api and then iterate through with the normal
api, some values may be lost.  Today, that's XA_ZERO_ENTRY only, but we
reserve the right to change that if it is necessary for some tree
version.

Does that make sense?

Thanks,
Liam

