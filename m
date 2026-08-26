Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFF2CC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 13:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11CC16B0088; Wed, 26 Aug 2026 09:37:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CD816B008C; Wed, 26 Aug 2026 09:37:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F27266B0096; Wed, 26 Aug 2026 09:37:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB3B96B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:37:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4DAD3403BF
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:37:33 +0000 (UTC)
X-FDA: 85143522786.17.7A158C7
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2D22640002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:37:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="JTiB8S K";
	spf=pass (imf17.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787751450;
	b=C6ZwX7yR+zSKSq+narX6gWHJvabGWwEMLqAvkkoHnB0gcSRmupeA2rxxA9f+fJrj9TDmD3
	m1eLHSl9T6YuxBDcuS/fni54vVk1fMTZykHJxUQaEqRvPnVMNs7Og9ueeN/NvUg3yLJJsL
	CHv5Lcq6/ldEcuFcqhzkq89oTymZFmY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="JTiB8S K";
	spf=pass (imf17.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787751450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i3ANaNg2oL63LSUznheA13Z4ntLs2tbjJ1OmjixfiOw=;
	b=p560ZYS2ofTgm7/XNUVtp93M+oYVD87wblPJNjURmqLeH8Dhj7OJX6fsCH0Zuh7qas1JzR
	bOhJpE8UPOnJynLu9CeI6AfumLAhLhVRFU/3BszR2rcC0lqEPE/ZbTsbiLXQxmd0bKTlVh
	YGycOGhsQy1r94S+JoySEKU8+na5NpI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=i3ANaNg2oL63LSUznheA13Z4ntLs2tbjJ1OmjixfiOw=; b=JTiB8S
	KKuvAZUMv/NpTG1/D3G84YSevncWjHJnEbkYiyQF8+tHdUfmjynQtP29cHhakDHAmXwoGphuSRMSm
	01hB+watI6hliEGW4NH07c7PdLWPdii0AxcVfSP1677D5D2x9Q0UwIDgwKz1pLfj5ldwgUKY8TyUm
	xwgqOSr01Peji3DyI7x6C5ReM9XBnXwOQPsNwrpnWDzpgDQo77uKKEnGeLAEviy29iuMjGS+4Mnl1
	5q5nsEPSz14MnJMGKde5xDUjUMINKj6Q3ZAi256WL5SRy/y1lDAFyzwwaz8XvAYIQ3hvsOpZ3jEnO
	ImJWhgwQHZmLfnm3tfx8BIEKkVoA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wzDoB-000000084lK-0kMl;
	Wed, 26 Aug 2026 13:36:51 +0000
Message-ID: <282ef22ff621eb5d1f079b89d067dde29686e08b.camel@surriel.com>
Subject: Re: [RFC PATCH v3 0/8] batch lookups in follow_page_mask()
From: Rik van Riel <riel@surriel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, Andrew Morton	
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Jason
 Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, 	linux-mm@kvack.org
Date: Wed, 26 Aug 2026 09:36:51 -0400
In-Reply-To: <ao5t8lxaCWQvph-l@infradead.org>
References: <20260811025157.1632867-1-riel@surriel.com>
	 <ao1JwEAeNcP9OyKR@infradead.org>
	 <a10c74df79e1db6a9a2448220fe4c4fd6a0e5bdb.camel@surriel.com>
	 <ao5t8lxaCWQvph-l@infradead.org>
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
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspam-User: 
X-Stat-Signature: i3pedcsmwdh5pnhbw5zcbwjptg73bd5u
X-Rspamd-Queue-Id: 2D22640002
X-Rspamd-Server: rspam06
X-HE-Tag: 1787751450-153519
X-HE-Meta: U2FsdGVkX18k5L8VQFnZ5yqQYUrck2u0C+fg3x7dZxvKdFqTvecgflPUAlPYCXJ1j36scanI6FB640GSJ14Q1UKxTlf9j+blTSRdfZiln0MUwBX8OLu81aA5tUP6e22JW8JenfSWGObnemrz2c0ZjHuwYoiQE8WoCTS1+5hdCYfZ83dMBoEUogjwmI/n2GcC4esUGeuN+rO4CNojDAQkN+cmT25n2qBeIXxN9SEAZo+waS1EqFqKRX1DiMtu8cSc/IenOC8eytBv23hKyr7/gFJLuWAN1iGrdKt8vyqd48A6DYobNRV9FiP52NRtjKsdi9rqYpBMy+Wo4rpYfI+KNQwm06aS4AtOFWxPOMg0+VDx2/jezRxvqbJmeOqispQvZi+/uk/Q8r77tlzIEZ+WDFTlu8BQl4anRZmtmYR0fp3klsnpH8CBbTsPZtut+ls1xfZGVS3J+47oUj3Gt4q6Ez2+PqxizAHoHYWVfoqlYr+9F1Eqxr03zu2MhiN1ao5+CT15JoYsD6xGnH51Q7DwuY2QJoJEm/hOjQH1TWHmGKXSfzjii1P5nkL42jUNDemV4ZIkRKe6VOw3Dw/Uj/58iNTjAF7543rd09wU+I2W2F4SFgteXrAK0viPPND4YXUzWVDELUIyBroQRP/gSyAlaXAiPtMLtsV+bHapABrIF43Tn/loaGM/LJxKyonwu93m2yDDR4dHvNNsFeOJhHQSX/G5VR8+XvJxgMQlJ5JdCqqVErNyntAwVt09o6QTKQ0OqZ/dEuKspVF3IYCXtQb+0N2OH6a+WxeyRJ5+gMx3vkXNNI0vlO9zB+/zEWrsVSI+4Zhs/6gT5//sa5oOZldFQUaqx4Sztv0ZQTMwWxbJNfQtfu63AVY3zIQvNACnd6dV6eZr5jkorNKSI0d7OsWfG/7NP0Z5ppB+knJ93trGxrX19UbnwYJvnQETORRQDZ7IYsg9JVUAolAWKT0RYe0
 qr8gG1aJ
 sKw2x+O6HaI5Z5Rov1zYw1GPAViX4xQa3xwAo6FvhSPMYjxVgw+V1xoL/HPEhe8Frt25uEU4gjjMK1vOubjGlOQHqP3VVfLX9ZOtraDzxV15dXxrSRH/TbL2f71FxfufL5yODG1UNGTi2wCZcGCWO+pnLYHc7w1q3CWk3fa2w12QdHIc3+SAadxZ2ciZEBU0OD9gPwW1lO8MvXuQ5EIel4PZvMY4sl1NCdbvFwRJJZ6y2hr/gBm87k+m0B7PT0UTsJcA+3iRZpcsMNuNLopM5JCSXiF3osmmLfGlCZXN0+1uSQw8QPVn8QF86Y+K15qpH/tuH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-08-25 at 21:39 -0700, Christoph Hellwig wrote:
> On Tue, Aug 25, 2026 at 09:37:09AM -0400, Rik van Riel wrote:
> > > And what many including the most performance critical callers
> > > want
> > > instead is really a single bio_vec.=C2=A0 Maybe we can go the extra
> > > step
> > > for
> > > that, as it would reduce the number of calls into gup
> > > significantly.
> > >=20
> > Which code are you referring to here?
> >=20
> > blk_rq_map_user() seems to end up calling pin_user_pages_fast(),
> > via iov_iter_extract_user_pages, and it directly fills in the
> > bio_vec's pages array.
> >=20
> > Is there another performance critical path that goes
> > through the slower get_user_pages() path?
>=20
> The other callers of iov_iter_extract_bvecs matter more, but this is
> the main user.
>=20
> And iov_iter_extract_bvecs right now is very inefficient when used
> on larger folios,

I think it would be possible to create a path
into follow_page_mask() that passes a bio_vec,
and where we fill in the bio_vec fields the
same way bvec_set_page() does.

Then iov_iter_extract_bvecs would no longer
need to iterate over the pages returned by
get_user_pages_fast.

That seems like a follow-up series though,
and we need to think carefully about whether
we would also want to unify part of the=C2=A0
gup_fast and gup code.

Currently the gup code depends on locking
to keep page tables from going away, while
the gup_fast code depends on disabling irqs.

--=20
All Rights Reversed.

