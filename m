Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E22D6CD4F26
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 01:33:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 810B66B0088; Tue, 23 Jun 2026 21:33:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C1AC6B008A; Tue, 23 Jun 2026 21:33:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D9176B008C; Tue, 23 Jun 2026 21:33:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46CC36B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 21:33:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8BEC5165CBE
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 01:33:32 +0000 (UTC)
X-FDA: 84913083864.19.B6010E4
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf01.hostedemail.com (Postfix) with ESMTP id B445340007
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 01:33:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="abwr/AD8";
	spf=pass (imf01.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782264810;
	b=zy51j1T/oSggAtabJxAvwzZv64dQAocbF5jB5M3RwcexHEfJ+CiRDrImyoPxOb4eBhnpBi
	95VjnYwGRxtE7OzuIV241DLR6lSw/QLgmmAwOz7EU+bP9aIjWsDh+biRqk7uoOaPb5ZkS6
	N+FDDpNW011aaHMzfOnILfsEPEw0GTo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782264810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mOg8LkKs733xmlAKwFCLPd9WcpZag1FHz/doRiCKuQs=;
	b=gx0uFSaY/jkb9xC+TVOYrLy/nqNI3DZr6L+zPbzUKLw5TCDEj/ehG0U4ttJNDvttIzEB7j
	ha3q0u5wLhT8k4wa7iO7pqxvKEbgYsgPYiAINeWetqKqFQa2IHGdRNHDOLoHMloj7f+v4s
	yxHS0JDGc8rQfvAe8k2ATmiVjhbFdU8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="abwr/AD8";
	spf=pass (imf01.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782264806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mOg8LkKs733xmlAKwFCLPd9WcpZag1FHz/doRiCKuQs=;
	b=abwr/AD8vQqSwbq2irwDX2GN/P3JNdPfgkgjBL9KjFbvMJECnelvvWbegzVFbt/XYO6T5B
	3op63GPNqAcGng+pSEPtPkyb/b18jT3E4jbtRnfYg64C96kOKRcC5ly80bXbWuLOGIflZx
	1iPQB14pcZR3tadYbDppjCD2+DMXBY8=
Date: Wed, 24 Jun 2026 01:33:24 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Hui Zhu" <hui.zhu@linux.dev>
Message-ID: <40a6017455ce039225fc331940be6cb27d13bc3e@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] mm: avoid KCSAN false positive in page_to_nid()
To: "Lorenzo Stoakes" <ljs@kernel.org>, "David Hildenbrand (Arm)"
 <david@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "Hui Zhu" <zhuhui@kylinos.cn>
In-Reply-To: <ajpehMzABvNh1wN_@lucifer>
References: <20260623074157.578113-1-hui.zhu@linux.dev>
 <97f2c4ad-c302-424d-a7c8-fdfa0fc0d811@kernel.org>
 <ajpehMzABvNh1wN_@lucifer>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B445340007
X-Stat-Signature: umukg99weniqnwxtzchnhxx7unb1fsd6
X-HE-Tag: 1782264808-207010
X-HE-Meta: U2FsdGVkX1/0AB0r1ZL6autZPLg3D9nkRz8ranSQ2fSoN0hfbmcOVU6i69xhXm1PHOggc4Qb8aG/eNxyWL9APYNNzcMWb5B3lgOlwNnwT2+TNLlnUPWMPq+DNJnJuRc80cRlJVMl5BiG11jluBsjwWI2z63ko2fLKpqJ9/1JXx2nv2eOd7iMU+EHJYG9Ekn8z0VsJzypVKqC13bve3uuG93w+jir5CP+SO6yWeD4b1Wy5kRbguNZVSJRtTVaESyhDybK7y5cb/Jw+tEUZgNx/wk85DLX52UqnlzviPaig78UOnmobUzkr/URIG5USdQDtenpu1fvDqtYEfMkb9NTA48wE15p/gd0UkbTvx8XhQRWTmFCG/w9R4I9QyE1E0FOEx9PjqpFX2JNHxRFTf+RoV/m1rFfGz/bYxUbtcYQtwQZSvkG/niBKpHy9iCr2dbLxBMqeJBq0/3dTWMyK6c1/Rmh1M2LYC1RGP+IFZR0M5opGHJGCbIsqBiMGxyXpOUh7o14UQ4HSQKVFd9hONgo8YN/irbUI2AIDmMOu3qlFwvKAHFnhXk5Y+7TJANI8BY4r6GDg03Rfy2wxkX7g+30NNt159ouOyIDt5FmAWExQjuqTmfReI628y2aUz2RmUudouMtNIhGAuVXxQZ5WkBpzyf3Fq9DDdZKBAPoud2djc06zgjA/OL4C3sjKYFI1Hf8S98kfcDEp5doAQ2SC60yoB/hx7QaE9WDZKNzBgRNyoAu096pO3GSlf6jgrPx8f8P7COwrws6HviS6dhXnbeWIKAq4JepHEr+uWV7F1uu++bUnfiZvJ4gLE+6ZCq3SzReE3JdY6Y/7DXTbEPG/vp0oF0na+wB+loURRJEoxqNxzoFztQG0l4QdkVj+0jUjWriwSJIirMKPEmUaPbZnmG53vy3IuB5oUlyfNiUWRmgXDSu4fo6BqrkZmlfCmBV6YSWBLm6IjQIWDduxredEwl
 xV/arbdL
 pxkh+/3VqXkpWj/TQ5YNuRN+rpgzY6h8sM5FjahGX/nlqS2fX61PgnpY55rz3fnhqcjDJ66lgXwn0ZKjJVEhnVvx6ZKya+Qfom4EluS8x5HkzZCi2tbp3aCZ2IA0DvdhsNfe8wAfXvGAbnxEDiXfilCys44Kq5s2MdQ1/igZu265qajiJR6BNw01krDOF60zjjFQMVDjn31tCeZcUgL1HO+0sayHo0Chk2BDzQHXEbUoW9FdcgFTbax4OvozX7g1Eg2i9sW3XYPFMhMDaxUdfGEwm34XBkLqm2WWpz8W5aFjntOlH9mzDUTba6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
>=20On Tue, Jun 23, 2026 at 09:59:45AM +0200, David Hildenbrand (Arm) wro=
te:
>=20
>=20>=20
>=20> On 6/23/26 09:41, Hui Zhu wrote:
> >  From: Hui Zhu <zhuhui@kylinos.cn>
> >=20
>=20>  KCSAN reports a data race between page_to_nid() reading page->flag=
s
> >  and folio_trylock()/folio_lock() doing test_and_set_bit_lock(PG_lock=
ed,
> >  ...) on the same word from another CPU, e.g.:
> >=20
>=20>  BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio=
_gfp
> >=20
>=20>  The node id occupies a fixed, high bit-range of page->flags that i=
s
> >  set once when the page is initialized and never modified afterwards,
> >  so it can never overlap with the low PG_locked/PG_waiters bits touch=
ed
> >  by the folio lock path. The race is therefore harmless: page_to_nid(=
)
> >  always returns a consistent value regardless of how the read
> >  interleaves with the lock bit ops.
> >=20
>=20>  Wrap the flags read with data_race() to tell KCSAN this race is
> >  intentional and benign, consistent with how page->page_type is
> >  already annotated for similar packed-field accesses.
> >=20
>=20>  Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> >=20
>=20How did you discover this?
>=20
>=20A syzbot report? If so please include Reported-by, Closes tags.

This wasn't reported by syzbot - it was found by our internal
fuzzing CI on a KCSAN-enabled build of our downstream tree (based
on v6.6.121), triggered by a multi-threaded mlockall() fuzz
testcase.
There's no public bug id for it, so Reported-by/Closes don't
apply here.

Best,
Hui

>=20
>=20>=20
>=20> ---
> >  include/linux/mm.h | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >=20
>=20>  diff --git a/include/linux/mm.h b/include/linux/mm.h
> >  index 485df9c2dbdd..122d3b39369f 100644
> >  --- a/include/linux/mm.h
> >  +++ b/include/linux/mm.h
> >  @@ -2296,7 +2296,14 @@ static inline int memdesc_nid(memdesc_flags_t=
 mdf)
> >=20
>=20>  static inline int page_to_nid(const struct page *page)
> >  {
> >  - return memdesc_nid(PF_POISONED_CHECK(page)->flags);
> >  + /*
> >  + * The node id occupies a fixed high bit-range of page->flags
> >  + * that is set once at page init and never changed afterwards.
> >  + * It cannot overlap with the low PG_locked/PG_waiters bits
> >  + * that folio_lock()/folio_unlock() concurrently update, so
> >  + * this data race is benign.
> >  + */
> >=20
>=20>  Do we really need this excessive comment?
> >=20
>=20Agreed, just delete it. For a trivial benign data race it's a bit muc=
h, and the
> commit message can cover it off for those who are curious.
>=20
>=20>=20
>=20> + return memdesc_nid(data_race(PF_POISONED_CHECK(page)->flags));
> >=20
>=20>  In memdesc_zonenum() we use ASSERT_EXCLUSIVE_BITS.
> >=20
>=20>  Can we do the same here inside memdesc_nid?
> >=20
>=20Also agreed
>=20
>=20>=20
>=20> diff --git a/include/linux/mm.h b/include/linux/mm.h
> >  index 69daeeab7fe8f..76d3bb54be844 100644
> >  --- a/include/linux/mm.h
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
>=20>  --
> >  Cheers,
> >=20
>=20>  David
> >=20
>=20Thanks, Lorenzo
>

