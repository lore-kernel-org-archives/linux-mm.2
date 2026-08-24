Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16D71C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:20:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22C016B0096; Mon, 24 Aug 2026 09:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5766B0099; Mon, 24 Aug 2026 09:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F2506B009B; Mon, 24 Aug 2026 09:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8CE86B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:20:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6903D8012F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:20:33 +0000 (UTC)
X-FDA: 85136222346.29.609A36F
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf10.hostedemail.com (Postfix) with ESMTP id 16506C0007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:20:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="GdsbHh s";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf10.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787577631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fI5J35zZVeodU54e2f/003tiost3YB+AH7moLkYpx9Y=;
	b=m3Epi7exSLuYNzYP5/dklclrXFw+oHY5gzXkf/MGkqF4TWDDiQhpg/Mgm0R7Pw9b6CRMqX
	G+ZfPq/HaJkozK4GLLujHKon5R9U077txMmymOhzHUBTcdE/vBO+S+nSzK8oDETmpZqRuo
	SJqfFBL5jPE8866AmZfgaYYk+ugMRIY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="GdsbHh s";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf10.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787577631;
	b=pYVynKuxeMQECfImjAHt9CArJL3UNBSfqIe6jcyOfpNt3Ah2YFljTUPpukQggd6hCJRQlp
	jdwiRZy6DHc0NJ31FmEA0z9UXK9LeciODSJWN2/UoFx/GR/jJ/gShNHdyF+tV3GWSu8aeS
	hVrrpd02ZzfWRSu4m/clxQf9UjhAJ74=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=fI5J35zZVeodU54e2f/003tiost3YB+AH7moLkYpx9Y=; b=GdsbHh
	sqngHZZica6D95+3QCPlSq6hHkQrPU7DKwvRAYadqPHQqEICABi0iS03N2JcLGiFNdDipD57s6AbY
	eghePhj8FkWax4ax7Fu04yWLrA3QXXla6EoVVAG7wwto4SkLrtKR9vlfwqc4G+NIQz0uWqGL73LT4
	eSwf5CRhj8zPSxBRtHq64orT8bRBhDrodNE5hwHFso0yE7cKMZULpvBltJwLEe1CRDJ7678ywCaah
	TPFRdqS0ROjzzxIeMzuT2BOfMkC0aio3htpyXB80Hm8QH+QkUyN2Ozhk0FHXLpQcySjwDHqcg/1RO
	KOHmVleepqzG448gLmv6MKrw9hkA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1wyUar-0000000328N-23lS;
	Mon, 24 Aug 2026 13:20:05 +0000
Message-ID: <99b9a43505c0dba4c656bf950869f76f95e399ce.camel@surriel.com>
Subject: Re: [RFC PATCH v3 3/8] mm/gup: split follow_page_pte_commit() out
 of follow_page_pte()
From: Rik van Riel <riel@surriel.com>
To: John Hubbard <jhubbard@nvidia.com>, "David Hildenbrand (Arm)"
	 <david@kernel.org>, linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com, Andrew Morton <akpm@linux-foundation.org>, Jason
 Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org
Date: Mon, 24 Aug 2026 09:20:04 -0400
In-Reply-To: <42d8fc20-4ee6-4bed-b2b4-3f968bd29f5d@nvidia.com>
References: <20260811025157.1632867-1-riel@surriel.com>
	 <20260811025157.1632867-4-riel@surriel.com>
	 <8a9d5a6f-a7c6-468f-8b50-a7aa2b4dea2c@kernel.org>
	 <30b747de6202cd875b7669f8d76ad8ded5c0a4e7.camel@surriel.com>
	 <3b8cb743-702a-4362-9abb-7c30e687c3c2@kernel.org>
	 <ab1661573257d7755d5a48e4f9165ff22febba29.camel@surriel.com>
	 <fe9f0bb5-73e3-4509-951d-e529e37011fd@nvidia.com>
	 <f86ca125a9b63cdab8edeb3c3b02a29141f18c1a.camel@surriel.com>
	 <42d8fc20-4ee6-4bed-b2b4-3f968bd29f5d@nvidia.com>
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
X-Stat-Signature: bp3urea6bkaqen18gaedemutuaze843y
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 16506C0007
X-HE-Tag: 1787577629-82949
X-HE-Meta: U2FsdGVkX18rDGXp2Xxt5BLTEkqDPoxQpioiDFbwOIZxxmf5srM7JETuuRWMnMoGGocaZX/iker4y9mvsGYqcI100VommnquNv8uOpg+MK80YoBpv9ueJyaLOCIg9Aq1gtTfr5JJOmrFeswzu5UHZgnbhSwrDCa7h+m2TSDVC0wqLr8Tz+rSs/JuXjon1xiAUn1mIp4ezTYkl9dIh6m3rUTdbmWY+XB9WK7W8sGXIzQqUhlM/xDfLhnqXVkwGYtiHrw5EOnmU/2c/4+vQCycu2/2cLA9q9wuswvIPc4kXjV4C//l1fA40CkCzxBB5JMDR3+TjkG76rJzu3sdyUN47w4S+bOii2mI9P4C4k/+QC/Cku1tBMka41cA08Inn1f1uDWSEG+5nFcXNKLB+PztOoRE6csxbWpC12RtytqY/9vDh+na9ZFus5wXwkIYOr9lKR+pSIRJzsE0pFtXkZd/ZE0FpPgT/CizPggArSsd/VU9g1oE8DUlRRKCvMXiJZtw+Rd6CgoloTHv6lrF32f+U5PsO2flNiAMtbijXLwjzZ3XjUiLHntgcaOgtzhRUCvzEU50QWeegvEN+nTDYQ/+4quxzcbwyKZW2MPTT7NmU/oRDcEuBigJO/zx1xqbhAlqp4UOwyWtz/nKV3Z4k26kSk2JNnK8sOjwhl2FuZ+gOc5nBZTi9hklR9VVBOaWBkmQ5j1Ooh04GfvJc4z0gpcp23shsdMO2i3W07AlcfBx+l3DmDGdG4JBHadawq8YiJ9atfBmSl+CowMj5Rn1/hQNEBlSuXS8933Ech7iBpzlRKQozVUiBEGA+uPkGa8heM+AHGHH+/e03Gq+4f1HC5XNgqPOw1YowXdkPbCYTiZG8QqiQgdR5dtONABLphGBDHL0I3Ov6Pi73ujlRKOMFNvUmPsjWbRZxhGddgduTfCleKnW67wWREy535whxPhznzcV7Bo4n44p1AACBPoNguh
 0oynCe/H
 cxzsrcFsuoYVT5rIdF9DgBWWa0f219jnMEfH6qa5FtdAr8lGGapa132axXvtuXcEZY/htIyurOH8U1iw5yhlEDGfL6sLuelvBbl1tItmXbgR0DlfG6JbRvjZqJvkdxonTLIieFjKoG7uObPmlnadg6Kt80BrwveTSshAl2qXiiZfj2jIgweDFjgP8TXP+Hcc4I73BDnOiYqWULLW492U8HATOj4uRNfYQ+Vm5812SAXGlVZZv+Pb9IYEyODUSpCGV5BoDs+/jeIkH5CrNHkBjFaWMa+nS/rkaZqdQ2OK86OZSOr+4RswZqouC3I7NcLrtR2+r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2026-08-22 at 14:31 -0700, John Hubbard wrote:
>=20
> Its workaround is folio_set_checked(), which defers the real work to
> ext4_writepages(). If ext4 can't do the preparation from inside the
> dirty call, a driver can't either.
>=20
> So for a file-backed page there's nothing the driver can add. What's
> missing is a way for the filesystem to be told before the device
> writes, and to revoke the pin when it needs to, which is where the
> lease proposals come in. None of that exists today.
>=20
> And yes, unpin_user_pages_dirty_lock() is in the same awkward mess.

That still leaves the question on what to do with
code paths that rely on get_user_pages(FOLL_WRITE)
to set the dirty bit on pages, and then do not set
the dirty bit themselves after they write the page.

Would it be better to move the dirty bit setting
till after the write (to the page) has happened,
even if that code does not queue up a filesystem
write?

Does unpin_user_pages_dirty_lock() need to call
Folio_set_checked() ?

You've made it pretty clear what is wrong, but
I'm confused as to how we could improve the situation,
at least without waiting for extensive filesystem
changes first.

--=20
All Rights Reversed.

