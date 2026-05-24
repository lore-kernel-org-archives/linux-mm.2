Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81B0CCD4F54
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 01:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85FC16B0092; Sat, 23 May 2026 21:43:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837C16B0095; Sat, 23 May 2026 21:43:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74DB16B0096; Sat, 23 May 2026 21:43:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 618D26B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 21:43:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0B62B938EE
	for <linux-mm@kvack.org>; Sun, 24 May 2026 01:43:51 +0000 (UTC)
X-FDA: 84800617062.06.317B220
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf02.hostedemail.com (Postfix) with ESMTP id 37B0480008
	for <linux-mm@kvack.org>; Sun, 24 May 2026 01:43:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=XM+BJ1Lx;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779587029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MfDETxdtQRPcbOGjd01BtabxHo5xKX7Scy4TE+4+ylI=;
	b=ssTLBGGlJ0/HOjIj8QluP9XUhrUjNL77dgjrqsYFFn+Dba2dpnRv3Xh+gnVLEG301B8Sum
	r34lfG5jJhHOiky/+MIA4pLp1/mR9B8zDx4WD54uqNHw85E0EXgjvYwTHK+iylLi2WDJp5
	vvtAiY5me51j92ftutAUS97KgKa2zKk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=XM+BJ1Lx;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779587029; a=rsa-sha256;
	cv=none;
	b=fFheNJTIrIibc8PmZjHz8gV69WsStdBcf4Q+qzaUAQjINi0YNGuBbucvBhELQG23lC6muz
	p8+xhiNiniQwg/hg5tGWUELkZMSEhBhjzTfVC/igQUMObjSAJ8sDWMtT4GO6OtPo/pCU2S
	Nf1QPKjy7Ruy6ZpfL3aTEs7lQ1r3Yl8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MfDETxdtQRPcbOGjd01BtabxHo5xKX7Scy4TE+4+ylI=; b=XM+BJ1LxOPYP05TbJbBLz6dc+q
	8qUY2VLkM+f1aAiGk+6sC+W13J6xHtJeIzOYmBLC5JyEmoF1jGu9pCCJf6Rr6w5rFCo+W3YnLxY/K
	rGZdaS82NDjriVEiGQdq08PRQug4w7E/8y8gHrWPzgnFM3S81OgGAqJDgvej5BxzlBykjfQslvbvV
	KLj76otlWvOvkQN7lx1z2fYHbOEYIpHiOpUUWu9Rjn94nrjaaOBKnFL3CFKQy9pWh3EdDJIoHKvS9
	WJUFX+LBfznhP5PfdWWNEmvh042bAoevAJceHx1IPvpIZVxkNrMxZL3AldsMdzu/z+7g0um+tvf/R
	xrr8+tAg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wQxsB-000000004Gg-20bR;
	Sat, 23 May 2026 21:43:23 -0400
Message-ID: <daa29c92f055d028a5b3ec0e42cfb1ee1496a593.camel@surriel.com>
Subject: Re: [RFC PATCH 34/40] btrfs: allocate eb-attached btree pages as
 movable
From: Rik van Riel <riel@surriel.com>
To: dsterba@suse.cz, Boris Burkov <boris@bur.io>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, linux-mm@kvack.org, 
	david@kernel.org, willy@infradead.org, surenb@google.com,
 hannes@cmpxchg.org, 	ljs@kernel.org, ziy@nvidia.com, usama.arif@linux.dev,
 fvdl@google.com, Chris Mason	 <clm@meta.com>, David Sterba
 <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Date: Sat, 23 May 2026 21:43:23 -0400
In-Reply-To: <20260523155859.GF183694@suse.cz>
References: <20260520150018.2491267-1-riel@surriel.com>
	 <20260520150018.2491267-35-riel@surriel.com>
	 <20260520174749.GA1458531@zen.localdomain>
	 <20260523155859.GF183694@suse.cz>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Stat-Signature: dwkcoeuuhqc1hean5pecuz6tgntz6x48
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 37B0480008
X-Rspam-User: 
X-HE-Tag: 1779587029-143897
X-HE-Meta: U2FsdGVkX19iHo3/Hko6aM/bYX91iJrpsjZzPEyxZigBkKvXcFlkXE6Kbn8TPv0P5ezKKbd5zQRlVe6iNpVjjvGIoserkSPHSyPqzflJ8WDyyDdtvbaShMeyMQemFKq8hSFvjNdf17Elu4/YhPIonsHNElsRE1imQih8LzMge4BEl8vs3jCc01jd1C0vroIJcVkOIWL3kCUnA/D9n5Z4BGYDX5idaKY+1GBmwImvjlK4wQIVzqJLj0vahGQgryStLSgX0Sfj197/ggTVIhj73r/uHLWxRpJbLLV/yYEfUR2GTRXrMKXWJ93IAcM12fTnmn9YmUYkJ6XxPY1T1LohPOOTjWkIYY4wCJu99FAwWTdbpBc2YP0WOdNxXjIZwXN08GBScwuknOeBI6X+fo8AuVNutePaPrayJcGumcnMt+xrEiSQAEP4/z+z+g+LOl0u9xL0PXGWtyNOiQdPNgNwEgru7ODAbh7HxiKqncEyIOVuAard756ozdGSjEQkJTsZCM+IOMy0l+P5ZiXB+EX6FAUpUWORuxJoWB4raFhvgXHN6Rr7ZK9UV7Zs1kFSnr5R7G5+rJ4lzs76qwe6KHwNUPZHwoqGFgV82OPxBFu/cmy+GKy9LldqfkB/ZDD5O6/UXGx+ZVlMHZM8P75RsXX9QZfR6Ks8LFFQN4JTDfOWNnY5xBWnxT48vZYj6lfe829fhE9ieS8SVDH6WJyXUvOAi4jLgPprINilbPQSR5rF0pxRQQhnYvR2RA9Hx8B9CR8yhx20EcybagJqpEIukyGoGfeyivZogl62U0CSkF3TYpykzu6oTFTfITiA9Ynb4WWsEU49RaQBkePo6/wmh01Osar6wO057oWWxH5OUjp4y3X5p9tiDnoVEhYmHzMuBbmJsOUYS8jfIFwjUJ8+NKcuGHvBvU6iJZzvBUxtuMn4fj/aM6VWuEw+codteJJaOQQNH7m7rz94N/TBNNL1QtV
 WRfMhu6q
 mgemCb05Md9/TLTOXXh7L5eKRoxDL2Q8t7/nLHWfQ4BTH3Idkhl4F/+0eveMV9fkmKpMo/TvP1nFV/SUzjWMFG1lYpPcqZk2o6S/NrIr/YOK0h/lj7ohb9biPpZnKn0W1U9UF/aO1U6pkWchJrcbaUUB3/JPd17LiwRpK12VcpD/+hKleANpfCdo4kLH4TaPcwYa4jPbMUAcnkn97L7u2dC67KuYl5U/KdnY4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2026-05-23 at 17:58 +0200, David Sterba wrote:
> On Wed, May 20, 2026 at 10:47:49AM -0700, Boris Burkov wrote:
> > > @@ -689,14 +704,23 @@ int btrfs_alloc_page_array(unsigned int
> > > nr_pages, struct page **page_array,
> > > =C2=A0 * Populate needed folios for the extent buffer.
> > > =C2=A0 *
> > > =C2=A0 * For now, the folios populated are always in order 0 (aka,
> > > single page).
> > > + *
> > > + * @movable: pass true only when the resulting pages will be
> > > attached to
> > > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btree=
_inode->i_mapping (the alloc_extent_buffer
> > > real path).
> > > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Clone=
d/dummy extent buffers
> > > (EXTENT_BUFFER_UNMAPPED) leave
> > > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 folio=
->mapping NULL, never enter the LRU, and never
> > > get the
> > > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btree=
_migrate_folio aops, so __GFP_MOVABLE would
> > > violate the
> > > + *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 page-=
allocator's migrability contract for them.
> > > =C2=A0 */
> >=20
> > My gut says it is nicer to just transparently pass along a gfp flag
> > rather than a carefully documented movable boolean and let the
> > callers
> > do the right thing. Just a nit, I don't care strongly about it.
>=20
> Agreed, the GFP flags would be better and also a bit more self
> documenting where the functions are called. The patch is not
> standalone
> so I don't mind having the booleans, we can clean it up later to let
> the
> 40-patch series proceed.


I think this patch could go in by itself. It doesn't
depend on anything else in the series.

I sent it with this series mostly because it's needed
to make the series work, and to provide context on why
it's needed.

I'm happy to resend it with a GFP mask passed in by
each caller. That would look better, indeed!

I'll send you guys a cleaned up patch this coming week.

--=20
All Rights Reversed.

