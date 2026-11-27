Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3250E606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 19:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QDsfxLxX
Received: by kanga.kvack.org (Postfix)
	id 036B06B05B2; Fri, 27 Nov 2026 14:09:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00EBF6B05B4; Fri, 27 Nov 2026 14:09:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8CF76B05B5; Fri, 27 Nov 2026 14:09:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B65CB6B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 14:09:15 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 409AF804CA
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:09:15 +0000 (UTC)
X-FDA: 85481837070.28.0B91B2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7FC45C000F
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:09:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QDsfxLxX;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795806553;
	b=e/SKTBgtz5IwOVwzaaHOoVIuZJBm/RunTAYNj8JipYpuGChyw9sNYnz1seZw+MvTmn04iI
	lLBsxFL6M3o9ID7lAQlehFPMt5XzeJMlCpgj/O3Z4aDJCYl0h+KD90TbH/iofeUWUz1pPY
	B+OxXNYbfl/I1dZRgfW1TTr5O8lyaQ0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795806553;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kC6H2oj30l1HIXzQevBR7XRBFd2y6IpFK1zc6uyQ5GE=;
	b=Mnmwp9PNHhluM5ua3OO8TsPlFPc1ytZmJERQ87MM1AVQsRqMIFzU9qDO0+5tXpbpTJCimN
	kfZzOuXa/vfbSR8IgxjoxacU08CuKZhfTjhKL5KBTVp9D9JhukhIWNUCgTi6x8mcoYo6rT
	QvToQMDESVEWLlzbdwrK7+A4mZ7VQyg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QDsfxLxX;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C3DB41568;
	Fri, 27 Nov 2026 19:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF211F0089A;
	Fri, 27 Nov 2026 19:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795806552;
	bh=kC6H2oj30l1HIXzQevBR7XRBFd2y6IpFK1zc6uyQ5GE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QDsfxLxXnJWPfs8tfV1Nl1dfvwX39ynxtb6uAt7bVDPYq1Vf36KT7Jk+nTQ1JHwQk
	 EpQ3AbGgzQNUXXYsvIRNu7H/nAiFUHXuECNJFcNpr7SDNsE0iCqLAKYpjaEjZT8cL5
	 ESl1Xchm6w9v2hjo/sMSLX26oyUQDZayeKqShNoUWkRHLgK8EVi2DqDRXNNa4riNxy
	 6/4BZocrke2khEUpO9iQGyN2l6rzJfbcn6p3zMi7fKcH+U+AOwdl8PhLOTt9Lh7hDw
	 ppvg/FHRuWMx84UnAfxcUKnRhGdPAPT4YsNzL+9gq0MhD/WztPNiRwOMAmlCIaxi0x
	 ejjoIFNlG0xXQ==
Message-ID: <sashiko-outbox-238143@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] xarray: fix index jumping backwards in
 xas_find_marked()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qian Xiao" <heyheyco@gmail.com>, "Matthew Wilcox" <willy@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, "Krystian Kaniewski" <krystianmkaniewski@gmail.com>
In-Reply-To: <20261126190847.3064508-1-heyheyco@gmail.com>
References: <20261124213424.2224554-1-heyheyco@gmail.com>
 <20261126190847.3064508-1-heyheyco@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 19:09:11 +0000
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7FC45C000F
X-Rspam-User:
X-Stat-Signature: 1dgfcjrqwt449du8ryc393q8pu6ztq1x
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795806553-495966
X-HE-Meta: U2FsdGVkX1+lT+6iFmEpcwbaZy6ekWCVGBsPxuCI4AjGonL2r1pkYVRkLwBeswGVAVNWm6amsfvHOXfE3DbpD2UpsNmflUZ7ZuBPiFIUCiFcEDPuCW1vVh3rqAvtL0M0EDVtcGfEFuNQ2h43pDP7Unhjj50hw2RUHV5usankD1HEogPsRGH2gBKvBwQHmSaPkvKuGyXsdoOI4OHEtMx+VgY6GxbQporY46JH6ohGsapsyAwXggoJpiX/vTdrQjyKcgAbAMmvKuomdC79NHhSnzANb7g8pq/Sa8wbR/ShT6tWmt4dgK9x/Cu20xUZkK+CPJ57RXBDOLjZD0doA5VBoephRBBwejugULEqOHPXaNBsC1rhDCyy7dloPC6U1ewDZtFeOcZZetAJoWM6HtxXPXHyfNiazHkBELwki+dpdXQLqIJlnPIA9KTiNtrmC7WQ+GWoLLGCM8IXQGDT7NMctubdMpw4veB/bKT2C/9g3IgFuMh+Qt/sqkw8MbgGeWBw2BYDG3/Spat8L7yvj+1iHCFPg/q1Xwf8shGbdkrsj6PPUMl6GzU5mt3DY+pcgSBhky554clYAazidgXSYc3iYepCEFVH+96uTkEGd8Hy6x9IbkSjkkyqPLOtCMP/BXE0cIbEDyVEoH2fj4abTksZmNez7addWTcWTmybYMUvvUO3wb0t69mUIG6mcRqIUsBcG+WlQrjoT+ZlV3mfNt6Pg+qYWU9zF859c5guVX9wWN9QakvOHo+zZeP9QSS7A5nuOSAiVUG7V+jrHVPOmMzn0d65ca65XV0XaalbiA+3S7BzNodLvCn4d7/Ch6Efl+n+rWiZl0tHFHPiMcgpTZj9ho2s6Fl5rD0CjbL/Vu82iO5zJO5MmZtFf2y59hpJqkJCTNwGkmUmZhgkDm9PuMKilNYGxas8qvm1IetlHgxGYjHynNSzKwI0TpoKJAifB6iDWoDPGi38ci7wfIwSzRD
 uTPLnhRa
 PTvoaRY3GUVClJCAWES+kbXRdDneaxP31YcuMFhKSJYzgIafb9pzn6mP9I55f5gPn+xcoh9dvj2kh+0XqRZdrSX5yb8uXjBwDtNAfOsi3Z0j/93kiIWQdOUQpB5R2dsK/dHXDWPcik1ko8E6bVfuTCZw0kSdi/mhytxanTy7EWXtk3C9hWztGh6v1yRT1FbR7HGlait+rB966TRmCiJJRYATBJyOnxiRwiJrhh4lo9ATfcRUIDfBENXBiAujJONzzPLBglHtKBp3hDUo+/hm7RmvVAm/W4stZpSBY7JnAh37P3Y0Vr+uMHswBGzT0jwRkIGhN82nRQvZPP1wVp0dKWF3HUPynJD59u4mVPn4wzk6Baayzo5lrnfevBrY8kTy7zU94E7aXaV6an+cvKhqObdV6UcGuX685Qm9Fe/GArs5Qwu49z0Heo5oas2Of3dauyfq7Z50EMdZD7mdnzYFGPurRpZZOXIbV901fOS8xct2NImUpwxwsk3SfIPDSZYrGa/1MORzAOqY8dAMQFyKpHfOGefQ2lp0KbtIVpPswiFQLFTjQR2w9U6WTuA82lz70HXH9KHjenqDw40+149Cze0Mb1VP7o9teqKWDBBbaWXTPAT3O4FBflQs/ml42cR4Zwas8FLAig69jcpmATRGzXOgxVAgU6wKWpFMs5pB0xz37PgTUtsT9srfqZwZRreC+GAPXoHqWySwa1vq8lpXNfKOtAP572KWOqLa1ZCOC94etonXfveZGUEMO9c9tos2KumbNdNXGZKty67kzBGVDBTdXCqPCLVRfJ/AHgoyVdSgSY9YeFtbXgEDhC3J4xt7qJBoY4DVu8KFupr8IK/x3+Y0lRqy0yK+iXhIyPsXudbaJxZc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Critical] xarray: 32-bit shift overflow and wraparound in
  xas_find_marked()
- [Medium] xarray: missed retry in xa_find_after() after sibling rewind
- [Medium] xarray: cursor desync in xas_find_marked() on concurrent
  sibling store
--

commit 7642e490f837a825b02324be66c62d579219e1aa
Author: Qian Xiao <heyheyco@gmail.com>

xarray: fix index jumping backwards in xas_find_marked()

This commit keeps xa_index unchanged when xas_find_marked() resolves a
sibling entry, aligns xa_offset before advancing or pausing, and returns
XA_RETRY_ENTRY if a concurrent tree change would move xa_index backwards
or descend into the wrong node.

> diff --git a/lib/xarray.c b/lib/xarray.c
> index 8c09f6c6cd8f7..6b2e838117132 100644
> --- a/lib/xarray.c
> +++ b/lib/xarray.c
[ ... ]
> @@ -1512,14 +1523,18 @@ void *xas_find_marked(struct xa_state *xas, unsig=
ned long max, xa_mark_t mark)
> =20
>  		if (!advance) {
>  			entry =3D xa_entry(xas->xa, xas->xa_node, xas->xa_offset);
> -			if (xa_is_sibling(entry)) {
> +			if (xa_is_sibling(entry))
>  				xas->xa_offset =3D xa_to_sibling(entry);
> -				xas_move_index(xas, xas->xa_offset);
> -			}
>  		}
> =20
>  		offset =3D xas_find_chunk(xas, advance, mark);
>  		if (offset > xas->xa_offset) {
> +			unsigned long index =3D xas->xa_index;
> +
> +			index &=3D ~XA_CHUNK_MASK << xas->xa_node->shift;
> +			index +=3D offset << xas->xa_node->shift;
> +			if (index < xas->xa_index)
> +				return XA_RETRY_ENTRY;

[Severity: Critical]
Can "offset << xas->xa_node->shift" overflow 32 bits, or wrap index around
ULONG_MAX, and make xas_find_marked() return XA_RETRY_ENTRY when no race
occurred?

offset is an unsigned int, so on 64-bit systems shifting it by
xas->xa_node->shift >=3D 30 overflows or hits undefined behavior in 32-bit
arithmetic before widening to unsigned long (for example, 64U << 30 is 0).
Even at smaller shifts, when xas_find_chunk() returns XA_CHUNK_SIZE in a
node at the top of the ULONG_MAX range, adding offset << shift wraps index
to 0 before the wrap check below can terminate the search.

In either case index < xas->xa_index is true on an unmodified tree: RCU
callers using xas_retry() such as find_get_entry() spin forever at the
same xa_index, while locked xas_for_each_marked() callers that do not
check xas_retry() dereference XA_RETRY_ENTRY.  Checking
"offset <=3D get_offset(xas->xa_index, xas->xa_node)" instead would avoid
both the 32-bit shift and the ULONG_MAX wrap.

>  			advance =3D false;
>  			xas_move_index(xas, offset);
>  			/* Mind the wrap */
> @@ -1537,6 +1552,8 @@ void *xas_find_marked(struct xa_state *xas, unsigne=
d long max, xa_mark_t mark)
>  			continue;
>  		if (!xa_is_node(entry))
>  			return entry;
> +		if (xas->xa_offset !=3D get_offset(xas->xa_index, xas->xa_node))
> +			return XA_RETRY_ENTRY;

[Severity: Medium]
What happens in xa_find_after() when xas_find_marked() returns
XA_RETRY_ENTRY after rewinding xas->xa_offset from a sibling slot?

When xas->xa_offset is rewound to xa_to_sibling(entry) without updating
xas->xa_index, xas->xa_offset is less than get_offset(xas->xa_index,
xas->xa_node).  If a concurrent split is then caught by either of the new
XA_RETRY_ENTRY returns, xas->xa_node is still a valid node pointer:

lib/xarray.c:xa_find_after() {
    ...
		if (xas_invalid(&xas))
			break;
		if (xas_sibling(&xas))
			continue;
		if (!xas_retry(&xas, entry))
			break;
    ...
}

Because xas_sibling() checks whether (xas->xa_index & mask) exceeds
xas->xa_offset << node->shift, it returns true for XA_RETRY_ENTRY and
xa_find_after() continues without calling xas_retry() to reset the cursor.
The next iteration enters xas_find_marked() with advance =3D=3D true, aligns
xa_offset to get_offset(xas->xa_index, xas->xa_node), and searches from
xa_offset + 1, skipping any marked entries at or after *indexp + 1 in the
newly split child node.

[Severity: Medium]
Can the "if (xa_is_sibling(entry)) continue;" branch just above this
desynchronize xas->xa_offset and xas->xa_index when a concurrent store
replaces the target slot with a sibling entry?

CPU0                                    CPU1
xas_find_marked()
  offset =3D xas_find_chunk(...)
  if (offset > xas->xa_offset)
    advance =3D false
    xas_move_index(xas, offset)
    xas->xa_offset =3D offset
                                        /* multi-index store at canon < off=
set */
                                        /* slot[offset] becomes sibling(can=
on) */
  entry =3D xa_entry(..., offset)
  if (xa_is_sibling(entry))
    continue
  /* next iteration: !advance is true */
  if (xa_is_sibling(entry))
    xas->xa_offset =3D canon              <-- xa_offset < get_offset(xa_ind=
ex)

Because xas_move_index() already moved xas->xa_index forward to
offset << shift, rewinding xas->xa_offset to canon on the next iteration
leaves xas->xa_index at the higher slot while xas_find_chunk(xas, false,
mark) searches from canon.  If canon is marked, xas_find_marked() can
re-return an entry at or below an index already visited, or return the
entry at canon with xas->xa_offset =3D=3D canon and xas->xa_index =3D=3D
offset << shift, causing xa_find_after() to treat it as a sibling via
xas_sibling() and skip it.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126190847.3064=
508-1-heyheyco@gmail.com?part=3D1

