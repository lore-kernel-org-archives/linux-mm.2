Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 884FDCCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 21:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CDAE6B00A1; Sun, 18 Oct 2026 17:02:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A55E6B00A3; Sun, 18 Oct 2026 17:02:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E1CC6B00A4; Sun, 18 Oct 2026 17:02:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1B4E6B00A1
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 17:02:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F296140561
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:02:29 +0000 (UTC)
X-FDA: 85336970418.22.5A46C52
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf27.hostedemail.com (Postfix) with ESMTP id A066340005
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:02:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="dn+nZa K";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf27.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792357347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=83wOCRK/bwy9L660WV5b1gU76W+7QPnUrUylFYSXBl4=;
	b=AGriI3YvEgVaI8TbkZzbSJl3tdVUhUNQNXmWAvg1qw6HwruApFiCDCFVG7+3ngfxRUgimT
	B5z32bSa3fecn4TqaQFfB/7FJsru9puYvxcSFTi9g/UQ5HFRr7Q04KvbYd/ci/0xILBTl2
	U+aGgwLsVSQ0dJJdPDmcMPrJewyo5nM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="dn+nZa K";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf27.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792357347;
	b=YBm6P2nzGWkP6t23jSRf9+X0oPteibE3nIPai85bAO/IC4MUazetJrt8e1QkFx6KORvWvW
	PrFNltwfRvCdw0N2gWLTlzK1i6N2cuSXOscc4RdAiU+GSWVRKb7uhWIETJPbtBAnV+fcVx
	h5dMuuvQadYB8SlnagRnOYVW7uZ2UCo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=83wOCRK/bwy9L660WV5b1gU76W+7QPnUrUylFYSXBl4=; b=dn+nZa
	KTAD2bYgUXJJit3XHbUO8Jg08g4kgGjLThBoD0kanK7RzYhOjD7dqpAZxsKN6zWV++BwW7XC92P1B
	3pb7wPODWSfepqP/DyBATP1044B/S2zcAKunKRrTsbxZAEVdsCiZWt3/Tz5HcWgiOWtAiUBUiYnC3
	IyL759dijGI84iTjbhsQGsQEV7xXlUU5E85Hc5PC8dGDssa2Q8ElmPK6E4zEXBVSFFjMSdqK1y8N8
	CLX41qRACRXu5jiyInar6erpneDSzsMFHOPxepf6tdiFZ4GueHmt/O7+7i3+9alWFgXFzNr0QEz4q
	zR4giyVz/QTDo7s8E4QdftwoVP9g==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xIY0v-0000000Doky-2uO5;
	Sun, 18 Oct 2026 21:01:53 +0000
Message-ID: <c155b536e79ebfc9eb384dc8046cf31865d08843.camel@surriel.com>
Subject: Re: [RFC PATCH v3 8/8] mm/gup: batch contiguous same-folio PTEs
 into one refcount grab
From: Rik van Riel <riel@surriel.com>
To: Yuan-Hao Hsu <aa9736195201@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, Andrew Morton	
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Jason
 Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
 <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
 linux-mm@kvack.org
Date: Sun, 18 Oct 2026 17:01:53 -0400
In-Reply-To: <20261018182652.691-1-aa9736195201@gmail.com>
References: <20260811025157.1632867-1-riel@surriel.com>
	 <20260811025157.1632867-9-riel@surriel.com>
	 <20261018182652.691-1-aa9736195201@gmail.com>
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
X-Rspamd-Queue-Id: A066340005
X-Stat-Signature: w65f3awywzyh73jj9w8juo6kszqru6kb
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792357346-630445
X-HE-Meta: U2FsdGVkX198qCHaHdg9AIK4jyjlv/6on2R7hR6UCNy/iDWjZABaD+ThhWFy2NxevNjYi0dMOxyBJ9YD8YS0dFRbAroq8hq3fH9WyHvYGeGQo8LvQb1IhzBwNf0sAuXZPopuYDKdcOpx/5uQw+9fRjSn3HCqM3niMmIrC6rzwjlyj1RbtK16tiimzlxTkQYTaUEgEt1SvyFhYUspYfFhrCZgbKXtsqRlRHt6qz5C5sLs2tuICGgUleOurGeKCPudm+WpvRKlhyHmDWe7F3fQDuOhsoTVUHGJH+478IaWP+dgziOv3sTj8yRnpbv5QNtioOC9n/dBe7+uTB/FOpTuE/8TqDYhmFx0Zh2qsM0dW2h2kVnEK6o82wlmUXoGtpLTyFR/uJIA1ieieASNM/7PNVOphw0zEdYw7XREkD7nUE+9yM/GU/fHMgG53LFQCP+z6ybkCSsSylgtKRz6oO1VV2I+H3EQ43poX1yM5lGOQE5Ie6+1uW45TkrPYas2cyHNsf70wcq3wLcrHsoYJhzmVr6GtlpNPJ+7IFDftkm5eHyHSujMQm5d1/Yxeolx0zSf1n0krdajwGf8rK/SmgEBBuvJQoGuyAWXk6NIFRwztTwSP65k98ZluC2T13CaX0koBGsoCz36GlKOjjnipEuHFDDQINx02dcJOwSgsWBxYAw6gMXCN3KXSpFSnfqJ4/wHAvldpkh6w/uBEWn8Ph5P7nzYB9Dtd+sooMXg+B+ljQLJPNm7xVn5Hdp5x/INtIvLluzMRE6VCl5Wv0DB4wV45RWN+qfNASlEGov+Mz6chgCwQ7jS31JxzPZa/+TZSWA0FKURIYRl7B0NwwGbRVCpujWb1BK7xAo2bNOB0sgg2jNrEdZdnUCnRKuKRJ7+YHkeZh+V7yELK7qz+ImMuPymX74zISc3lCquThrymroyhPZYyYGtqC97pAQNO04SSWO89hxw5zPayerZjkh8UTl
 JcdaWKib
 GeAjwItNE3d7cSMfaUuKDZyu0fNS8QkfR/F+o6DJQedolaDuYfcoaVrBtIhaiPuNNUcV2d18n3jYBMtAhQYRtS9hcAzSWvGK+e3GngPkpEs39cAyGu35CuoV8gKhTcaO9MLWS/cZbawvovpttg0ujB3cRo3jQxiSMChM1OqsK3VbZq/u43Ws3wd4pjd1EVawlxD4sfHkdv+JyzNsKtfftzW/z3N2SSaxCzG0VRQJ0kdBPP2WKy2QxQvgPiUuAZcFNZ+x7yh6Kw6TbemlrExEzdxh19A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-10-19 at 02:26 +0800, Yuan-Hao Hsu wrote:
> On Mon, 10 Aug 2026 22:51:57 -0400, Rik van Riel wrote:
> > Add follow_pte_batch() and give follow_page_pte_commit() a run
> > length.
> > Each run starts with a full per-PTE resolve, then
> > follow_pte_batch()
> > finds how many more PTEs extend it with a pte_same() scan rather
> > than a
> > re-derivation of each page, and the run is committed with one
> > refcount
> > grab. Runs stop at folio boundaries, so plain base pages are
> > unaffected.
>=20
> One side effect worth a sentence in the changelog: with FOLL_TOUCH,
> folio_mark_accessed() now runs once per run instead of once per page.
> On the classic LRU the first call only sets PG_referenced and the
> second one activates the folio, so the old per-page loop activated a
> PTE-mapped large folio from its second page on, and a run now leaves
> it referenced but inactive.
>=20
> Measured with one get_user_pages() call over 2 MB of freshly faulted
> 64 kB folios (kprobe on folio_mark_accessed(), flags from
> /proc/kpageflags):
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 before=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 after
> =C2=A0 folio_mark_accessed=C2=A0 512 per call=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 32 per call
> =C2=A0 after 1st call=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 32 folios activ=
e=C2=A0 32 referenced, 0 active
> =C2=A0 after 2nd call=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 32 active=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 32 active
>=20
> That matches what the other two paths already do (follow_huge_pmd()
> only calls touch_pmd(), GUP-fast only calls folio_set_referenced()),
> so it looks like the right outcome.=C2=A0 It is still a visible change in
> aging for anything that reaches these folios through get_user_pages()
> rather than the fast path.
>=20
Nice catch.

You are right that this should be in the changelog!

I'll get that in for v4.


--=20
All Rights Reversed.

