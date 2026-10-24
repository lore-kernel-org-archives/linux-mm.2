Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD3B3606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 19:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eCXMwYc2
Received: by kanga.kvack.org (Postfix)
	id ADED16B05B0; Sat, 24 Oct 2026 15:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6A76B05B4; Sat, 24 Oct 2026 15:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CC676B05B8; Sat, 24 Oct 2026 15:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DA976B05B0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:22:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C855BC03EA
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:22:58 +0000 (UTC)
X-FDA: 85358492436.08.4B6CE2F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3C07980003
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:22:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eCXMwYc2;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792869777;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l7LHfOVnwmBcb2C8jtey7mV3GxSr4tp4MJY2sGPpheo=;
	b=ablAPFnBeFK2V0GjM2yS0DXjT2p1m8hGcEtcXFwfXuB9axv9BfodpNa+MZo0CiylwWl9xz
	mX0pOSogf3k1kuVM7nVyaGL1V9R4EijhmhkJ7XtUCTnTG+WTHjp/lZ+FJqDR+4vIYLjpjU
	JE5Eg5o+XeLnLh5J5CdgZvDHuXQvECg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792869777;
	b=1ZrB/yX7FPATx7Ui/+0FtjAtPICLAYk+9r5uz2Zc65Zq7DOU4bWa68FXV+8LJOgNcx58oO
	FY6k+kNboBPsnjEIYtEiVg+PPeWIeUf0sfY2Ax97fmU/HvzfqESERgz+xKi8xFj2va6kub
	nC44jVpRnz0KxMEu/y2xrtRELGaYv60=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eCXMwYc2;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EA62601DB;
	Sat, 24 Oct 2026 19:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4681F01825;
	Sat, 24 Oct 2026 19:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792869776;
	bh=l7LHfOVnwmBcb2C8jtey7mV3GxSr4tp4MJY2sGPpheo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eCXMwYc2z4yu4J+0Jx9PtjUmryGPi66pBWmBwUHGkSsOw9DA77jsZqGsM9dPhAwdg
	 OhOZSxqmDJpUEFh58rH2Z7UCzGNnGMjcLn981RQoeEbHXf3tnHTpmDH4P3bVEdG0o+
	 D7/fqFQnu+MOUl89PM5at3bR1MNVSY1xeWa9GPYBRQGE+byY9GVkTgbFrPmBxG+WnJ
	 6KC/9FF6LS4eREb7x5X9XCVaRRfykuVMtfjSP3Mm5z3u4HRd590jkravzhzC7Uexit
	 8e1ngQZlW3jPhcle4rC03ov+xA7q64bu/cNyHvNB2Lq7LUYM0VU7nI+/7YCDxA01k1
	 /JJWsGUx95+0A==
Message-ID: <sashiko-outbox-183847@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 2/8] mm, slab: introduce slab_debug=N
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Vmxhc3RpbWlsIEJhYmthIChTVVNFKQ==?= <vbabka@kernel.org>, "Harry
 Yoo" <harry@kernel.org>
Cc: "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Geert
 Uytterhoeven" <geert@linux-m68k.org>, "Conor Dooley" <conor@kernel.org>, "Damien
 Le Moal" <dlemoal@kernel.org>, linux-mm@kvack.org
In-Reply-To: <20261024-slub_tiny_rework-v2-2-bf1419ab5ffd@kernel.org>
References: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
 <20261024-slub_tiny_rework-v2-2-bf1419ab5ffd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 19:22:54 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3C07980003
X-Stat-Signature: 1iugazw7dm4pekfo8kqs8mq7imne39fh
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792869777-734852
X-HE-Meta: U2FsdGVkX1/QKofcAv5jayfVWCkKjs9XDT6M15PdvZcIRtDaCft1owmsqY6L99b3PKwM38zAK+cXLkl+2qd4ECfoIrQ3NnUC7gQP5GtY9zkCdzbJ7E1y3gr+5X4D4c7IcVoobu6wwuEVajpoNMrdyVYquWapVW9xr7K1UHaZ5bNrR/d6WrII+0HpX1S1BmvhMqiVZ3nLoa9oa/d+POz3YjnUCed9XDqyC/0egMK1Xop02iVyKEbMrucnoTqRmvxn84o7DNvk6jBpL5qIW31oo8eKZmkF/NhTaDTOnj0I1Fdg7BAyvTM2QHYYHEZz3hgYkdBC+4JYx8ChEw6zB9JP4YjOOuNLO5jlYo8xrnywdFWcVCt34lgDZVqkJ9EZ4Bt88MyPW/CzYJ+X3uMurtKKm84Uoh2smTA33ByTs2RGPcQFD7aPfT+gZeilDXKvMRkx4SAfsckYvI5D54iJTaiA2fOGRPp4zrVXSW7GJ2j27RV2pLQ34wp+jZfk38iWp8Ri1dS6DEhiRjUlMhkTn5YZvqswQQt25ngGZNSy6AVIjjEGVQPdocxqXXKw9p9H1K7cX3IBo6V+KNrr4N37qg16K28v1g7StNJiTg/arpfVv9gNGwxEfclRFPnLY2xkrR/l6w0lT8XT6m8DJZXhNqzz9Ou7oOL7/xEfkAm9TjAzhMM9W4fKnrxptdnkLkTqHoEKTDYHWpT1nG5D4U02NC06c4Z6aVEBaCzxJ8SN+E3ElbmP5nIGGxqNgwiVBKbQB6LzJAwhjdxHplT8U+mDrA/+PCb9X9hgEBNDTN0sNlcUNiecEaZ/PT+EUX+cdhGoeWHDnsZzRUvq0/F0yNjILDsKTdCXUus6y0rSv5oNaDfQ0orm4h2tAVqDSOMxbbZm4ktbqJHxlsEp3rbwoh6owKqjRp61Cd5m96L7ZWTFnao4eEmD3FDxQ3F9sqi5m1+dOwYX0Te9lrQBTjiWGQmupVl
 LwXgtQe+
 mnE11IpaaxzWNJwCjhiK/nsSnJnrAuI60Vad3L8TUCmW5+NyLgPon0bZ5M8VeKjRIHMZ7K7ty2nsvA6VjJGttKoFBKkS9R24r4BcGsCZlzgsl/v9zg1A/2v+7JyqAZ9fESwL+jZtt8xPeg267kf08kAQApKocnKbTEwsYumRENrw5iOCrsXH9FfHOv6aipN23ijMtRSohIQe3TeegY+WNzzz8U9BYj7i6JBTS2/B8YxjCMrukO/2H0djur0SYcGeweEg18pZ5xSP8bDOiJLBp5mGIoKrODsIMh2PE00GZJHr10n/HphO+wSna7RfkMGhPShPMQcKmKR3b4278UNo76mxX8Hm6aQkz5yBq1yZ9KtTtNNakrAitesqXOarPvQ/PlTop6dr+Q9ABs7psv1IraqBP8gzdL9ZaxmBvaZ0hxqwB34ztEvvo/ZlBC70p9zRGgNZz8t3zuOfX+eyFDP4PdohtTRCOAwtO/ZnxAasS4EK6r6BBZecpD2Tm6KVafd+kT84y0ZwD69u1iu+bn86+zWMYt6n/lP4BfawzWgwWeIvp9nfJfovecdYtYtyziaSRTIut/EAG+ff0ixrFOKhEuUyTEvagER1o3DAiZHQvwQjrvXhtzkUCSHGh33e2RA8P1G5z76OGxLWiMIuNUkkdTHYfeR0+I70lN8VU7+RrF+MVrHo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm, slab: missing SLAB_DEBUG_NOOP in SLAB_MERGE_SAME merges mism=
atched caches
--

commit 2d842bc4bf4f28b2b4c86a9001856691abe3624c
Author: Vlastimil Babka (SUSE) <vbabka@kernel.org>

mm, slab: introduce slab_debug=3DN

This commit introduces the slab_debug=3DN boot option and the corresponding
SLAB_DEBUG_NOOP slab flag to force slab debugging slowpaths and disable
percpu sheaf caching without enabling actual debug checks. It also excludes
SLAB_DEBUG_NOOP from SLAB_NEVER_MERGE and avoids disabling printk pointer
hashing when only SLAB_DEBUG_NOOP is enabled.

> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 01c64ef661e7f..02dfe4351e8b7 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -47,9 +47,9 @@ struct kmem_cache *kmem_cache;
>   * Any flag that adds per-object metadata should be included,
>   * since slab merging can update s->inuse that affects the metadata layo=
ut.
>   */
> -#define SLAB_NEVER_MERGE (SLAB_DEBUG_FLAGS | SLAB_TYPESAFE_BY_RCU | \
> -		SLAB_NOLEAKTRACE | SLAB_FAILSLAB | SLAB_NO_MERGE | \
> -		SLAB_OBJ_EXT_IN_OBJ)
> +#define SLAB_NEVER_MERGE ((SLAB_DEBUG_FLAGS & ~SLAB_DEBUG_NOOP) | \
> +		SLAB_TYPESAFE_BY_RCU | SLAB_NOLEAKTRACE | SLAB_FAILSLAB | \
> +		SLAB_NO_MERGE | SLAB_OBJ_EXT_IN_OBJ)
> =20
>  #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
>  			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT | SLAB_MAY_ACCOUNT)

[Severity: Medium]
Should SLAB_DEBUG_NOOP also be added to SLAB_MERGE_SAME?

Excluding SLAB_DEBUG_NOOP from SLAB_NEVER_MERGE allows caches with
SLAB_DEBUG_NOOP to participate in slab merging, which is checked in
find_mergeable():

mm/slab_common.c:find_mergeable() {
	flags =3D kmem_cache_flags(flags, name);
	if (slab_args_unmergeable(args, flags))
		return NULL;
	...
	list_for_each_entry_reverse(s, &slab_caches, list) {
		if (slab_unmergeable(s))
			continue;

		if (size > s->size)
			continue;

		if ((flags & SLAB_MERGE_SAME) !=3D (s->flags & SLAB_MERGE_SAME))
			continue;
}

When SLAB_DEBUG_NOOP is enabled for a subset of caches (for example via
per-cache boot parameters such as slab_debug=3DN,<cache_name> or
slab_debug=3DN;-,<cache_name>, or by passing SLAB_DEBUG_NOOP to
kmem_cache_create()), find_mergeable() does not require both caches to agree
on SLAB_DEBUG_NOOP.

As a result, a cache matched by slab_debug=3DN,<cache_name> can merge into =
an
existing compatible cache created without SLAB_DEBUG_NOOP (such as a
kmalloc-* cache), keeping percpu sheaves enabled and silently ignoring the
requested option. Conversely, if an earlier mergeable cache is created with
SLAB_DEBUG_NOOP, subsequent compatible caches without SLAB_DEBUG_NOOP will
merge into it and be forced onto the debug slowpaths with zero sheaf
capacity.

If SLAB_DEBUG_NOOP is added to SLAB_MERGE_SAME, does create_unique_id() in
mm/slub.c also need to encode SLAB_DEBUG_NOOP so that aliasable caches
differing only in SLAB_DEBUG_NOOP do not generate colliding sysfs IDs in
sysfs_slab_add()?

mm/slub.c:create_unique_id() {
	/*
	 * First flags affecting slabcache operations. We will only
	 * get here for aliasable slabs so we do not need to support
	 * too many flags. The flags here must cover all flags that
	 * are matched during merging to guarantee that the id is
	 * unique.
	 */
	if (s->flags & SLAB_CACHE_DMA)
		*p++ =3D 'd';
	if (s->flags & SLAB_CACHE_DMA32)
		*p++ =3D 'D';
	if (s->flags & SLAB_RECLAIM_ACCOUNT)
		*p++ =3D 'a';
	if (s->flags & SLAB_CONSISTENCY_CHECKS)
		*p++ =3D 'F';
	if (s->flags & SLAB_ACCOUNT)
		*p++ =3D 'A';
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261024-slub_tiny_=
rework-v2-0-bf1419ab5ffd@kernel.org?part=3D2

