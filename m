Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D79CDB47C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 01:33:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE90F6B0088; Wed, 24 Jun 2026 21:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A72B86B008A; Wed, 24 Jun 2026 21:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93C5C6B0092; Wed, 24 Jun 2026 21:33:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63D3D6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:33:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7FAA1A051B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:33:02 +0000 (UTC)
X-FDA: 84916711404.21.6F6F5EC
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id DD9401C0002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:32:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lgI7gvgu;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782351181;
	b=obg4SFKQoQLgMhoFri1nktSZSDoQL7oHnK5t2ToBNPVs76t1o6kPn7wXEY4ZwzaRCoX9z4
	JK86/mTn7pvjvwLHURbtZSNOtBTxF3z73/yeNfMJBgApAjnHaAnvXsJMVSN1n557BV9mF7
	r0d/16x84lrh7QF3VOLkQ/ULC+u85Gc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782351181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZGtCqgsXrr13qIHByA1VHU34o5Uf7Cq8eAoTpcsoR4=;
	b=7DLQ/lU/71VB/OxpZve/0YiGU9AeyARxxLW0QvKdlOCX5FM+Jh/nZGCyyvOSVeFaMpbgW+
	iNIF8ZRZjG2Munqi6kScskVkEwBp3WEcPD4oUXsv7Blv3sPzCUFY0RI1E365IJ0oK/mHfC
	iEJccuYocjTysokQswZMJ9UAf7qAwaE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lgI7gvgu;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782351175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DZGtCqgsXrr13qIHByA1VHU34o5Uf7Cq8eAoTpcsoR4=;
	b=lgI7gvguAJlE1AGlGy2emZi3GmquktUv5NaqJjQLJGjw4syCzwXTEJkc8YHh8czWD/oVfS
	vEQIzUYp0mkqumnTkrfWsYM6XxRJjmG50+6njmXZ2rizyRB/glIF4yi2Ro+PJ4QVHcFTJl
	u4Im053yJmqP6hDvXRXY/2CoUdnnzto=
Date: Thu, 25 Jun 2026 01:32:49 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Hui Zhu" <hui.zhu@linux.dev>
Message-ID: <20bd8bbbd5a8cc52d267f550fc0314cd0d81a223@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v2] mm: avoid KCSAN false positive in memdesc_nid()
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "David Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Hui Zhu"
 <zhuhui@kylinos.cn>
In-Reply-To: <20260624140104.eacc15e291eec123bc7b3349@linux-foundation.org>
References: <20260623084432.701120-1-hui.zhu@linux.dev>
 <20260624140104.eacc15e291eec123bc7b3349@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 1ti93ye1sm71gyxa47t93q881e3egzrz
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DD9401C0002
X-HE-Tag: 1782351178-35904
X-HE-Meta: U2FsdGVkX1/hvrQ24/ocwPmXSBGdOyyZdzhKj8Nhx5znsqKtyDayK27Af/FMzyd/tHEbVXZ+jhcXDw2ZYChC7PqPPNUqKzEL5tRHmb3GFjlbCywG6p+/+/ss8q4++vAbTwcNNHP2j5KD4y3PBwD0KPnG0e0Fb2wJa+L5FNs7238ECXGgvBw/ThqXOyfWigM0RoD4ZfWkmUEHWgndUuIAZtTmk1uMf7XVV3C/iMNdPI7jnaeYaLCmR1msCYpUhDcyMcCZbtqqken0PkhpN/Y7y4a2++z9Qj/ihDMo/5pJAwHozGS+rDvSp5pxsKYE+bGyaK2mTbHBn/2hBNxtXEKrMYvWEQ7hBrQf3+NqUWPtRjIMcXo9az9HNqhf0MlRa3YTsvV78zQ2hvJw5aCoKmFYaK7FMml3Hsn5EKw6LocEFM2PB+4uUhDApdXGxogqOn5KVu+PbcXXpTNsRl+hTZDTDnP5eH6vi4zCwrLjRppoe6MDHLLlDiEjh8RRpzvjcSWSXnv70/QWqwwzDX2kHp+JlVhfiHiCX9Ozxv4A4uDJEopoctw3vYUswzAqm6FfuxwArSwRys8fFDJgl8jT1tXmhYuoJSnCREanzoURqelkVRv7sr6vBNcJr2/WIR72wCSMMcs0tEYKl6gk4m8pH6la/Q7OwFam4uQWh3dsxPQIRo7k5QQE/f3Wztny1DOjTErOgZ6UeNX5YHoiih+5Zd2tiR0AYvTsmYmA1Tb9XINCpJqgGH/WWFDNGxdaRWL5SWOAsXNVdWu3jjp6bYLSKBVuhvrn0z0m/DKoaFgsLucYwlP0oPr4CkFeh5OaVRN2CWGyzO25pBgJXSd3klnC0hAagD84oK4cbzXNlrUS76Y73JJ2vRZ0d42jvj/We0WVOrrRUjbTBAIC5gcRWys/JVslAN0EMTNvsfmlPN4CQrjiWIQT8V8tDhJumxc74DuWccxsfE7aVYALxPtsOilCW15
 4cXwJ1nv
 j9OCcil5Q1yNgvauPOWJ2beceWFqt6416SK6BEQzdzMRn8VjSRHAxVisDNyaHv4S7G7UMVokoqdcPA1CfKOx8O7EIzJDRJnskUNYdcq2ZLuUaJWWT8ykUQQv1kvYHXaT/AU2/90AA+Hf2QKIMbBqeP1Q/F2eqKt86hOjRDl7tMq9xcyM9JcOmU1pfmGFaY66vnWlBFIhyQRnGhZXHH6Dr5AWLgnaSmtqQzFcMoCJ+3BN8WkfU5BvOTIoJeFjkdd2FXCfpo8nJLcB9iI7Rl4JIraqhHlE05jqNAqZYpBkMNc8xk6WpWWRelaG1bUUbUAP9bl/QfbH4aCsAjQw8iUzFw/YCD+7/lYQE72Ix00AYsHsNV0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
>=20On Tue, 23 Jun 2026 16:44:32 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:
>=20
>=20>=20
>=20> From: Hui Zhu <zhuhui@kylinos.cn>
> >=20=20
>=20>  KCSAN reports a data race between page_to_nid()/folio_nid() readin=
g
> >  page->flags and folio_trylock()/folio_lock() concurrently doing
> >  test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:
> >=20=20
>=20>  BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio=
_gfp
> >=20=20
>=20>  The node id occupies a fixed bit-range of page->flags that is set
> >  once at page init and never modified afterwards, so it can never
> >  overlap with the low PG_locked/PG_waiters bits touched by the folio
> >  lock path.
> >=20=20
>=20>  Use ASSERT_EXCLUSIVE_BITS() in memdesc_nid() to scope the exemptio=
n
> >  to just the node-id bits, consistent with how memdesc_zonenum()
> >  already handles the same class of race for the zone-id bits.
> >=20=20
>=20>  ...
> >=20
>=20>  --- a/include/linux/mm.h
> >  +++ b/include/linux/mm.h
> >  @@ -2290,6 +2290,7 @@ int memdesc_nid(memdesc_flags_t mdf);
> >  #else
> >  static inline int memdesc_nid(memdesc_flags_t mdf)
> >  {
> >  + ASSERT_EXCLUSIVE_BITS(mdf.f, NODES_MASK << NODES_PGSHIFT);
> >  return (mdf.f >> NODES_PGSHIFT) & NODES_MASK;
> >  }
> >  #endif
> >=20
>=20It seems weird to be doing this against a local variable within a
> random function, seemingly unrelated to the problematic functions which
> you've identified.
>=20
>=20Seems that it fooled Sashiko:
>  https://sashiko.dev/#/patchset/20260623084432.701120-1-hui.zhu@linux.d=
ev
>=20
>=20I'm wondering what the heck is going on here?
>

Hi Andrew,

Good catch. ASSERT_EXCLUSIVE_BITS(mdf.f, ...) is checking a by-value
copy of the flags word inside memdesc_nid(), not the actual shared
page->flags/folio->flags being modified by folio_trylock(). Whatever
made it appear to suppress the KCSAN report is likely an artifact of
inlining/codegen (kcsan_atomic_next() happening to land on the real
load after inlining), not a principled fix - so Sashiko's pass is
not reassuring here.

I'll move the assertion to where the real dereference happens (at
the page_to_nid()/folio_nid() call sites) instead of inside the
by-value helper. This probably also applies to the existing
memdesc_zonenum() pattern - is that one actually verified to work,
or does it have the same issue?

Best,
Hui

