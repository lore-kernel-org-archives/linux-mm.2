Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FE76C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 17:34:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8444D6B0092; Wed, 23 Sep 2026 13:34:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81BC36B0093; Wed, 23 Sep 2026 13:34:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7592D6B0095; Wed, 23 Sep 2026 13:34:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D1B06B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:34:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0EADA08E4
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:34:31 +0000 (UTC)
X-FDA: 85245726342.05.00F3CC5
Received: from mta1.migadu.com (out-154.mta1.migadu.com [95.215.58.154])
	by imf05.hostedemail.com (Postfix) with ESMTP id A167F10000A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:34:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cO/AhfdZ";
	spf=pass (imf05.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 95.215.58.154 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790184870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5a/WMvvuGUuOMoghidvmDY8vZ3gL9C91wyH+oZ07lY=;
	b=hormAmgqeY1Q4Kp2MnOypPylN5ddiNKhiXphRBHS1osn1FRFP9DHBzZub437/Fx7VjIt6c
	r/WNFMj0nXDT/ECRo/t+pj6ZoVih+Zyp9uOmEGExVSjIuLiq4IXeDdd30/N7a7FAG5VAtt
	Mujmqaxce99C5hY6WF4CyYyLpDKbDak=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790184870;
	b=mpqEeZXarzig5ipNtKIPeCUfz4Mxf/8vJ3aOQRmB64GNLhBz8KQQ6mzQ1FS4KfOBCs8zHD
	t0ZI5Q2zUntGr0cTP4B3I5l4LwV8Zht+Rav07rIbwqv5i6songsWM3WUBW0EyfTW+c9AI+
	y5n8LNLSwoxDAmCcT2DvhjzTaMW+HRk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cO/AhfdZ";
	spf=pass (imf05.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 95.215.58.154 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EJYd5eCHl5xQ8DHPfFFy7axjDaK7yOO1wMEyNS6gPb8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790184868; v=1; x=1790789668;
 b=cO/AhfdZAKbPU3IldkEeFiyrjfrV0BJPZs/b3cOgQivxv0RDmJ6kP6VBEyHwDZUbw+qOxvl6
 Z/3Ibxryusx19MJmlJL17PdtVisLAiL/0Ij2seiRPpegXTjkEqQxSZAU4fV0FJATK1Mj9m2IxpO
 WI7ADKYnMObRzC3rf4JhJyKc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f743616c5fc41547;
	Wed, 23 Sep 2026 17:34:27 +0000
X-Mizu-Trace-ID: f743616c5fc41547
X-Migadu-Flow: FLOW_OUT
MIME-Version: 1.0
Date: Wed, 23 Sep 2026 17:34:27 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Ilya Gladyshev" <ilya.gladyshev@linux.dev>
Message-ID: <56e036665dbeb0a8f51d697220d5ed84f210994c@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v6 3/3] mm: implement page refcount locking via dedicated
 bit
To: "Zi Yan" <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, andrew+netdev@lunn.ch, apopple@nvidia.com,
 artem.kuzin@huawei.com, baolin.wang@linux.alibaba.com, david@kernel.org,
 Liam.Howlett@oracle.com, edumazet@google.com, harry.yoo@oracle.com,
 hramamurthy@google.com, ivgorbunov@me.com, joshwash@google.com,
 kirill@shutemov.name, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 pfalcato@suse.de, rppt@kernel.org, surenb@google.com,
 torvalds@linuxfoundation.org, vbabka@suse.cz, willy@infradead.org,
 yuzhao@google.com, ilya.gladyshev@linux.dev
In-Reply-To: <DLFJL5U9DI6F.3QJP9YP0KX636@nvidia.com>
References: <cover.1789239015.git.ilya.gladyshev@linux.dev>
 <ebd6540ad89a4bb80e2a62d00901b5c827315b66.1789239015.git.ilya.gladyshev@linux.dev>
 <DLFJL5U9DI6F.3QJP9YP0KX636@nvidia.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A167F10000A
X-Stat-Signature: t83o3qraz4x97tbjc4s4gqziqybeqkqc
X-Rspam-User: 
X-HE-Tag: 1790184869-106674
X-HE-Meta: U2FsdGVkX18BwS3zVLaPEKxWvEGwpUxnUINA2a0caVKKFrarQ63mdWQM5VeCmCIfVbKt1Nyiv9tLg7SVDCw1tjL6K+XZcCBHOzOQ4ERvGOneZpIeccSTFGHn1uQdhBIt4EM1d4kyBAYoESkzvTeu6XbiQs0av5EnJEx3pQsTU21bzhj/V5U103nTwUkheTarOM67hjVT9aAmQ2+3t1JEqhu7OQ2oyWuVHK9ss3eaI1Sd4qffk+JiPcG5CEX5LWhj8vh0+pb/iIQhsz/GSrZva3O8lNlA4CPqXoGeg8Cz9ZFtrdc5NxDD5ushMp/JDe1MQqISA+b4ft8CsuKJ/dw9rZvu7S7rSYy/M+LOHe10GuE0FkZeMM4+dccMHO/2lXI59rH/WvqPOV/A53LOo3Ynfn3ldh8RplplNpry3qrGqZPqfcaCw4IUgRAtz9mRCHfwRSkmSlqFTV9WSQz9qEzTq/kX0Z81YfSGNLaH4NfZ77FGx9A9IK1wEACVlrH//anD7vU60m3JiHVZpeYyMgJeGBpQ4vBB1cX5awMtjrpA7wfxdLZ/DDnrdWY3si26cU2MHY3O/9C75dIcHUTKSRwaUglhw4ndXuL3An8VmLMY/emccQHGnIp6nTIifWNoIvYF/zOQhT+hb6ogltHgY7LjigV/qbzGXEczYzKK4MSAe33b39+rI/DjNHMDzz/CnBM0UrpM01WnbiirDGaAISuDWrx9p/+NgIRfa8mRt8fFNYIJG5V5f1i+/c+Kh86ZMD3wsJVEhFbaEMKKgl7H+CW7pmo+UjO5IRVOEqdf/OsyT1DsF266Pat7uI/9hlMakIzTvL8R89q2fMqAjUEMoKpWFlRbed5C4Zc1KpqmZwMZ0kTsNc56db1ACmN4gHTDD25QT9Lt31/AXGIC108uXMEgeuS2ImeGqFS3iNfIWgV+cGJy8oguRGBgxbvfbLGUuqVV/frcYjKmLizkaQhg+Lh
 01+GNIiq
 Te+xHUUz2oDd1OCZobNjFJeVXHgo4RHaXayTQscnseU+z3lwh0tJQnge9uJf0nw6mrpfRQF0BDswL4YzSUN7PoofNw9d9x4TualfiohiKQqSXbxok1/lSbjlPcjML7kQtx+SzOEUsxaB7TFrQ1fz437ENzf4nIywyFwZLJfkQsEJgcXR4vOpIYDdu/0Z5louEWZYfKwm5Agvgo/zqTWTQ/IbkBWUug677LJK92DiHZlrzU/J1/KQ/crnBqWfRHByP3cSP3fOqXUf3/M/viNI0JGbJ7tRsKUnvcZTOZwjQqumAmO5WCxEAW3mj6uO7fPLdtIuv7e7cQaLC5bnF/zYu9Q3ZJxpImiNHufFyC0iO2DBqdXn4YMe4yALmE2HvN5vESk4H28Xluy9TCL0M0uGs6wDTqFXwK4/Yx81ROOk6lSBHvUEmJSVWWLFH6hypQ8anzmmZJHcALUAeCq9nUStTg6wkrwmtgBBnLIwPeR0CHfa881NTL43liF0IJt9BLffJk9VA4VxKTYECpUoN3F4yAnlI70JQFcpzAm6UHAeuHQ8rYbmkK3BqLVo7SQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

September 15, 2026 at 5:42 AM, "Zi Yan" <ziy@nvidia.com mailto:ziy@nvidia=
.com?to=3D%22Zi%20Yan%22%20%3Cziy%40nvidia.com%3E > wrote:


>=20
>=20On Sat Sep 12, 2026 at 3:50 PM EDT, Ilya Gladyshev wrote:
>=20
>=20>=20
>=20> The current page refcount implementation uses a single counter valu=
e
> >  (zero) as dead. So, to prevent incrementing a dead refcount in
> >  folio_try_get(), it fundamentally requires a CAS loop.
> >=20
>=20>  This CAS loop can act as a serialization point and can become a
> >  significant bottleneck during high-frequency file read operations
> >  [1][2].
> >=20
>=20>  This patch reallocates the refcount value range:
> >=20
>=20>  (1) refcount < 0 means dead refcount (uninit / frozen)
> >  (2) refcount =3D 0 allowed only as a temporary state (see below)
> >  (3) refcount > 0 is a regular reference count
> >=20
>=20>  In other words, refcount is now split into "dead bit" and a 31-bit
> >  counter.
> >=20
>=20>  Refcount decrement now works as follows:
> >  1. Counter decrement
> >  2. If it is now zero, try to put it deep inside the dead zone
> >  (CAS to INT_MIN). Or you can view it as "set up frozen bit and reset
> >  counter".
> >  3. This CAS can fail only if someone grabbed a reference in-between =
--
> >  that's okay, this page is their problem now.
> >=20
>=20I am not sure this works. David raised a concern on V4[1], where if a
> folio lands to page_frag_free()'s free_frozen_pages(), it will not be
> properly handled. "this page is their problem" only works if every
> folio/page free functions call a generic folio/page free function that
> checks the page type and does the proper handling.

>> Refcount decrement now works as follows:
>> 1. Counter decrement
>> 2. If it is now zero, try to put it deep inside the dead zone
>>     (CAS to INT_MIN). Or you can view it as "set up frozen bit and res=
et
>>     counter".
>> 3. This CAS can fail only if someone grabbed a reference in-between --
>>     that's okay, this page is their problem now.
>
> I am not sure this works. David raised a concern on V4[1], where if a
> folio lands to page_frag_free()'s free_frozen_pages(), it will not be
> properly handled. "this page is their problem" only works if every
> folio/page free functions call a generic folio/page free function that
> checks the page type and does the proper handling.

After some thinking, this scenario is indeed possible and problematic. Th=
e
complexity of the required setup give me hope that there are some implici=
t
barriers, however I wasn't able to find them. But I am not an mm guru,
so maybe I missed something :shrug:

-- Below is a minimal buggy scenario --

Thread A: network code that calls page_frag_free()
Thread B: calls folio_try_get(). Maybe it is the DAMON paddr scanner,
          maybe this folio was previously used in page cache
          (however this noticeably complicates the scenario)
Thread C: user of folio's reincarnation. It also requires destruction via
          folio_put() and not via free_frozen_pages() -- for example huge=
tlb
          or memcg charged folio.

Refcount operations as follows (FR =3D FROZEN):

A: DEC 1 -> 0  [ page_ref_dec_and_test() ]
B: INC 0 -> 1  [ folio_try_get() ] =3D> success
B: DEC 1 -> 0  [ page_ref_dec_and_test() ]
B: CAS 0 -> FR [ page_ref_dec_and_test() ]
B: * deallocates via __folio_put() *

C: * re-allocates page *
C: DEC 1 -> 0  [ page_ref_dec_and_test() ]
A: CAS 0 -> FR [ page_ref_dec_and_test() ] =3D> success
A: * deallocates directly via free_frozen_pages() * =3D> BUG

This can be fixed with a `s/page_frag_free/folio_put/`-style patch, howev=
er
it seems unreasonable...


> Before your patches, only a speculative page getter can see any page an=
d
> folio_put() handles the last reference drop. So it is safe today.
>=20
>=20Let me know if I miss anything.
>=20
>=20[1] https://lore.kernel.org/linux-mm/086b119c-b777-46ae-b087-798ca3e4=
4ecd@kernel.org/
>=20
>=20>=20
>=20> The size of the dead zone allows performing an optimistic increment
> >  inside page_ref_add_unless_frozen(), replacing the previous read + C=
AS
> >  loop with a single RMW operation. This reduces cache line bouncing a=
nd
> >  improves scalability, especially in NUMA scenarios.
> >=20
>=20>  [1]: https://lore.kernel.org/all/20251017141536.577466-1-kirill@sh=
utemov.name/
> >  [2]: https://lore.kernel.org/all/CAHk-=3Dwj00-nGmXEkxY=3D-=3DZ_qP6ki=
GUziSFvxHJ9N-cLWry5zpA@mail.gmail.com/
> >=20
>=20>  Reviewed-by: Artem Kuzin <artem.kuzin@huawei.com>
> >  Co-developed-by: Ivan Gorbunov <ivgorbunov@me.com>
> >  Signed-off-by: Ivan Gorbunov <ivgorbunov@me.com>
> >  Signed-off-by: Ilya Gladyshev <ilya.gladyshev@linux.dev>
> >  Acked-by: Linus Torvalds <torvalds@linuxfoundation.org>
> >  ---
> >  include/linux/page-flags.h | 13 +++++++++++++
> >  include/linux/page_ref.h | 30 +++++++++++++++++++++++++-----
> >  2 files changed, 38 insertions(+), 5 deletions(-)
> >=20
>=20--=20
>=20Best Regards,
> Yan, Zi
>

---
Ilya Gladyshev // foxido.dev

