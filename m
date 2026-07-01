Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9BDEC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C764E6B00AF; Wed,  1 Jul 2026 12:29:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C273D6B00B2; Wed,  1 Jul 2026 12:29:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B19136B00B5; Wed,  1 Jul 2026 12:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AC426B00AF
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:29:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0546F1C7303
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:29:47 +0000 (UTC)
X-FDA: 84940744014.13.8E81D37
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4C1DB1C000B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:29:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=FgH4di24;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782923385;
	b=UqE5NMDcrE5aICmsE5Chaa0pjSKY7FWfdZRuev/UwN3RaeoEpTAD7FLyUquJ1zWE3UvHEz
	nE40py6XLyWsF3KjFrbEx2B2O+PkDEm90nNR9XxR6aTBjrlpCrjTtquhpWVOFViWd/+UCE
	1tJCmqtbIVEjRFLne1xXOH5zwa5rzec=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782923385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tb2r/RbeBZvgi8wyzBGYRLANjPVEwwlWhAAzex/BFMw=;
	b=8hS91rX3t6tUzZNzYqo+scaLUqm18ZHDVqtFbqFBsBXWfC/4RIfeDUQ4E1w1qgR5irVrta
	ZonK8rlsQUIoftJrQyEKuo7LqesgzaeXHJqGMifjQ58eKbWLWueFKFsLCgaNuSsJUXiS7i
	qYD83Ao3CSpjSwoRN/Wvv0IcXRzhupU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=FgH4di24;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tb2r/RbeBZvgi8wyzBGYRLANjPVEwwlWhAAzex/BFMw=; b=FgH4di241b3H1BW94w7v0C1trF
	pnsNbPgcnPRkK1L7KlrwB3AwZSdLxgaAPiPab1qX32aLqqklBe9TfNn04TwgvzAK/otSlC1PZfD8M
	X/7Odv3kbv5QgTDsraxFqaJwxIxnVE6fXYpj3QdVHqoCL4iFJv+z4ZN9pEwtrjzMhocnfrBZj41zc
	ODK17Vp8RopwjPpyXxAOX8cUI3hzmKWihZl5I2L9+x9Bn4PRF2KzzxZGuasUCLqcU0iO0gdKI5GVC
	2TjWco6/ahsubvAYKEpmZx5lboaYocv9WsfjUw4AfruL4sMMwmSUCwt7xDLPUfcuPFiZoFaRK2L19
	sQZKwxLQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wexoT-000000000Wr-1rUv;
	Wed, 01 Jul 2026 12:29:25 -0400
Message-ID: <c1bac3b7b4a4cc3f7a3a04269307aeb13dbbf963.camel@surriel.com>
Subject: Re: [PATCH] mm/huge_memory: set PG_has_hwpoisoned only after new
 folio head is established
From: Rik van Riel <riel@surriel.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, linux-mm@kvack.org, 
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, 	yang@os.amperecomputing.com
Date: Wed, 01 Jul 2026 12:29:25 -0400
In-Reply-To: <akUoqvmGtSMgD0QT@lucifer>
References: <20260701134622.3152896-1-riel@surriel.com>
	 <akUoqvmGtSMgD0QT@lucifer>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4C1DB1C000B
X-Rspam-User: 
X-Stat-Signature: et5i3yg16nr18mig9e4bhss3nr5hkyxz
X-HE-Tag: 1782923385-70626
X-HE-Meta: U2FsdGVkX1/sGnIuSN/Xxo7GpHpx7Chx0s5BiHUngrUoz5bcwDNMvB5tgswUTZvPbP2FF8lucF79KHel5Vvh7pasOEg9D5hAacjYLiJ4tO9c1yES3xNokVNHOfx4sQ05CaQhtov+ty/jTNhFEmuqJ+JCjmvTMJfN+X0K9ZuHiy3qMFROFor8BdsYHh7ZC5SJSxYk/EJ4hNWxsWiJHeLV7cfXOmgcE0LMSjXKjlt2z5s9GfonRooeyH+2M+7NKS8Hu9osvpeD++e4b/9JYOvnmmYfRf+HqbUmGl6KdiWcXRSkLpc7iBasidQxGgDI7IJQxf9XhxKO+XjTxUewXwEIK5wP9LaQyAq55nbccfMabWdg44dvDh+hYw/+z3ERs/eAsS2UqFJz4/izIXN4C2qDssaMviJw9jV5WLsTy7lHbCXUR4oZaAMP5FCBeMj/3Gc1JxaUiyqMk2NJxx9Q0PeU+wVn6jLi6nFO7AXxAMvR6cNdRvA9aOgiarcWeVe2Ao3r2j+ynXedcogXcfxZSCmDEJCGF2hHXOm8uguABo863zgdkjQnFJUX/ob/XsCUAXJCre3n6q4bFqhMgAwK1p76pL262h6Kmb4qiju8DwYGKus8a/IXqglwCso3m2Kah9WlkvNc44kl4dC1g+ROOURh0UWghvo0pQEue1LkHQ2XBzEsMw0f9MjiIDIpuZbmxGWkn6J1mAe9msFBhb9JWpYSM75dNdKjr4Z9EN5/YjfH2CDGekt/FjQ1FjvtGceY1N1NuCxA9CuLKS81ZvmjT7QWLG5OSB/B6e/GKZRjKsM5S3Z+wKZFQGDqwlK7ufbdnSXZGFHbCtK1BPLI8vd5caJJYvG8X5DLgIwgJAGJljwDDmnumpZa0lOV3jHV4304Pcm0uCJywFgepVta+cgbHXlHog/t1ySBZ4z/+bQTekWtl+nG9NTs18xJbGrLb1VIr51cVRSL8cGjTUGcfqapLZa
 5L6n/kwx
 SLMuTFKFpEGVYSRB6tz9WcgjhIoqw3EzFFnSLbzCXaQFE4L+BFBJ/bEeWLWw4ghK/iQF1FoPKDlHOCtOPnyDtZn3Zv893Jc6VGBEBPzLN0Qj6W1tbYU2Gb2LaBG5o85zzblZtiPasY51ZAN2SrfOyflSEd42SQn9MDjSUY8pcDDP+pl7rozlv+TzMLttWezWajh5oGBtvG80TwFW7LNYD8WZIo7Y/qmd+Q4l9fbq4cvKWdTCkDJt1i9WGS3uIEZm448J0lnZmqgKNEUO24OlYw5QDwXhjVbZkarZUTaw9Motqr1M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-07-01 at 15:52 +0100, Lorenzo Stoakes wrote:
> On Wed, Jul 01, 2026 at 09:46:22AM -0400, Rik van Riel wrote:
> >=20
> > @@ -3612,6 +3608,18 @@ static void __split_folio_to_order(struct
> > folio *folio, int old_order,
> > =C2=A0			folio_set_large_rmappable(new_folio);
> > =C2=A0		}
> >=20
> > +		/*
> > +		 * PG_has_hwpoisoned is a FOLIO_SECOND_PAGE flag,
> > so it can only
> > +		 * be set once @new_folio is a real (head) folio.=C2=A0
> > Defer setting
> > +		 * it until after
> > clear_compound_head()/prep_compound_page() have
> > +		 * turned @new_head from a tail page into a proper
> > folio head;
> > +		 * otherwise folio_flags() trips on (page-
> > >compound_info & 1).
> > +		 * handle_hwpoison implies new_order !=3D 0.
> > +		 */
>=20
> This reads like an LLM comment...! A ton of noise and unnecessary
> detail.
>=20
> How about:
>=20
> 		/*
> 		 * PG_has_hwpoisoned is on the 2nd page, so set it
> after
> 		 * compound head prepped.
> 		 */

It was an LLM comment, indeed. I harvest these
syzkaller fixes from an automated run every
once in a while, where the fix is "verified"
by checking whether the issue can still reproduce
after a tentative fix has been applied.

I've fixed up the comment as suggested, and
will CC: stable@kernel.org on v2.

thank you for the review,

Rik
--=20
All Rights Reversed.

