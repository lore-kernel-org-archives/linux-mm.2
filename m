Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F4FB606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UC3PL9cl
Received: by kanga.kvack.org (Postfix)
	id B41CD6B0AC3; Wed, 25 Nov 2026 16:34:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF3146B0AC5; Wed, 25 Nov 2026 16:34:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08326B0AC6; Wed, 25 Nov 2026 16:34:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 72D946B0AC3
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:34:30 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 09F36A8EAD
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:34:30 +0000 (UTC)
X-FDA: 85474945500.03.D99FE3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6460B14000E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:34:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UC3PL9cl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642468;
	b=389TGg0to2a2JuAoGfwOyE7UiYoxXvFMKseFg6FkYzxIVll6TJVEuToBN+WYMFx/rKXvcF
	QUhrvbl53FbRBcELtJrwOYji6CEo6Av1io6o/MRjhyvHLR4RdOYtQVHt5eGd00tialp+w4
	111mN/8/2FZhVzVfb6aoIutMJ/PHeb8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642468;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dY0OuKBGrZdWMkiz3N3oKt65elhubUri8QQeTOjU5wk=;
	b=XUPG/nNZIL9Mfj20CTV/QkMaklw+mntE6CFDoPmAeIN1gmkTBZvY7QshDfPkhTku3emI8A
	29WK+0L4pSi1By92fzB33aDNQqGFzmLBHbZfDGNnt5Tg4Gl6pod9tYFTe2FVsL1fEch7ec
	bv5K5vymappgBkSdR/UIgs2WuYTGggg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UC3PL9cl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DC3DD6156B;
	Wed, 25 Nov 2026 21:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D734D1F000D2;
	Wed, 25 Nov 2026 21:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642466;
	bh=dY0OuKBGrZdWMkiz3N3oKt65elhubUri8QQeTOjU5wk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UC3PL9clU9qo3x8Gm6yERrd19clLIWXsMILCH4TdOMbPyPFqT86ktd/OGK0B1Flma
	 GGL1o9AAAxdqRs0tLP/U+LJYSYeRnbLWYxRwQIQKmt+LIKB2ljGg8Ff7obGCX0g5fc
	 JqkX9FD/eFbW82K3KwKYTP6Egg1q+UTx0iDpx1/8hnbW6cxNRxopCV5jbfXFi0+KM5
	 zs6PSRTF+0lWjFQNKL+vwbypr2azyW14zi6JpXpC26TEfhkY1s3kieZEjqLiH8HqvS
	 ONYHbH80GSz/F9gBemaLEN6pQdy3diDgcdwxaHO+quweFW2n5rsrT1MVmwlxCK8P+p
	 ComkYJQqGp0bg==
Message-ID: <sashiko-outbox-234186@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] xarray: fix index jumping backwards in
 xas_find_marked()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qian Xiao" <heyheyco@gmail.com>, "Matthew Wilcox" <willy@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, "Krystian Kaniewski" <krystianmkaniewski@gmail.com>
In-Reply-To: <20261124213409.2224472-1-heyheyco@gmail.com>
References: <20261124213409.2224472-1-heyheyco@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 21:34:25 +0000
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6460B14000E
X-Stat-Signature: tri9baiojet1peoaxy9qratmeikum5xx
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795642468-604978
X-HE-Meta: U2FsdGVkX1/PkqXu+WeQseEoU0Hepy5t9jnrxgfMocOgYSo8GivHv9axkDii0TJPNPZKSpdndtIb/6HBd4eUcHxv8C2bsIwRD93JrvZ4X4P4bfP1vPNu+r2qxV+p9x7C8K7bd0oRof6KB7hWB3lwAmVi2nF1S2VO+A1t89U67H64P0qjHOxaFG97VkA6m00h0kkGiOWo1ZowYSbYi6+5SY3pTi4WfiLSOssvohaGoZ/haAc4qGphUAP/jhzwp+k98AFvbEh15IgyUn7zGiQACE7x3ddtNZLFACVUAsBGANgi70hOx6s+SoxVdyzm7HGjGJIhy3Ld9oqKcV/ZtfbmXlsrB/7Sc0KHnrJwWwW9zEn6+QEemwgokIkP9+I3ObnpF4Yup3eTodd8G24qHG0tBTLwQtGcgEFFlot2CX8FtGO6dGsW1BtbMoldC4G1If2E76gdGWApmTxB4DUaewfpv6Q2UVJWw8KK3gYtcj1KhKReR3lqRcTtMjQP5meMj752HSUa+OyZ4Jf3HWUPvZ+bZzJtWOTt6dHp1WN0CRlFkD5GdwsOIAwqiI0yALtgv/yBDG5xx/ow921yJsCS2SIpY9qsMoP3BLNNod59qQvjdLy/WlI+CSzx1KdiuL7eDUgA8Z8gN3JHWO5DzTvRSm8pB9mnLh0GnScoUrQq21o8WtetT61vOpBYgpPbTExeXTBg1S9I1FgCdP0sxPu+wLT6+8dnvK8mBvkaZJ/aKls21xn4aPZ51WrkZGLiBH7QBsHkyPIIluyksuiwYy6h/h4hCNaTWIxDkunTto7lqQtJPDQgJr5yW8eE4quHX+ykfATI8+K5Agg5suG0dDEoFbE6jJ9Ujl5vjZgQB1k8yWquWc8NvnWEkSbjzhL59OLygUzi/l+hoV63LfUU5DncmCTUyhCB34F7GHgIiifixd75nLghdEPZOI3mHOwFO3rDxacVIvidfg9VCoslWoVnjXM
 WPcgPlXf
 7UEnikNMyyzFqlTMYtLHh+gNH+M+sJV93IGW+yIII/6/bByyV8LwXAZSSRmDkSlW/YePHtLM2E4D/iDy2oNl00/dRr6k0IaP7XOcXUjCapgv/39hzVyusHMhVvLOISVqEB2AFwiwiCzpB9Q/AHJHFkAhx2CJSNZP8pTnK+ro8kySx3lzE3EfBd7XoMQAylCa/yT+oURjcBDW1K0Z28DQY6uBQprVhFXaNodaxoA9bvX4uEaXXWdfjs2xxRcQhpiRVn1PwgMmM34/ICjtGFeTrU7+RJImY1gUcSSpCIzS9FqdFUfKX5XZD0iLIOhE7p9ClqjU9yKtZLsbVm9NP5W2yWhMoktBZS2jmnKIZeXCgzzb8KhR+ZWXQN6YVDEjSM6l0QjIiRCNwu+4ihYEUO6mMEB5szcvKFNxIIEZplBWmMMomc8enVEXlPZB5vQqiVvS79iC1jHEqao/XUZ0MLCwy2s4gKb9GZkGwL/YEU+Rdnt0JdvaMrg9gGrUFKzT6XowP4uOeRpGKOzM3lJKz0rCagXjtU1G3mEHZSRqaVPsL01mN2P1eKMc+7kEbPuFcYBFYmWcKm+QRoGHGtQYvpHYlcJna33V8cIcqOUn2Jz1W6UNYbNgHmeS9bGaIqDBlEvs82QSo8qHRn5COf8tX5gdxzaFWuQ7HrkEhrVOp5p0a3SkZf0/HBmcF1zilCDiBepyTflMuahK9xxxtO+KzHr7/Y0Y1OPMNFR222BGKPvtHgey9QNjNomjvl7yGY5kSpY9ea7u9oU+LRUIMkemVdYjXkLfOLE5+NcKbzNt/1/Q+ZlwtdQEXUisov1xrwDjH+tsOwh8OwvWOPLQ/U/dhFFkSlnyESmmhi1Z8/qpnFJA14T41y4Y=
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
- [High] xarray: race with split after sibling resolution in
  xas_find_marked()
- [High] xarray: missing xa_offset alignment check in xas_next_marked()
- [High] xarray: xas_pause() overshoots xa_index after xas_find_marked()
--

commit 4eb10c5fe97f140df6410177fd9785f2f1edc4d2
Author: Qian Xiao <heyheyco@gmail.com>

xarray: fix index jumping backwards in xas_find_marked()

This commit keeps xas->xa_index unchanged when xas_find_marked() resolves a
sibling slot to its canonical slot, and realigns xas->xa_offset with
xas->xa_index before advancing on subsequent calls.

> diff --git a/lib/xarray.c b/lib/xarray.c
> index 8c09f6c6cd8f7..a433f77f61a72 100644
> --- a/lib/xarray.c
> +++ b/lib/xarray.c
> @@ -1500,6 +1500,14 @@ void *xas_find_marked(struct xa_state *xas, unsign=
ed long max, xa_mark_t mark)
>  		xas->xa_offset =3D xas->xa_index >> xas->xa_node->shift;
>  	}
> =20
> +	if (advance &&
> +	    xas->xa_offset !=3D get_offset(xas->xa_index, xas->xa_node)) {
> +		if (!xas->xa_node->shift)
> +			xas->xa_offset =3D ((xas->xa_index - 1) & XA_CHUNK_MASK) + 1;
> +		else
> +			xas->xa_offset =3D get_offset(xas->xa_index, xas->xa_node);
> +	}

[Severity: High]
Does xas_next_marked() bypass this leaf-node offset realignment when
iterating with xas_for_each_marked()?

When xas_find_marked() starts at a sibling index inside a leaf node
(!node->shift), it now returns with xas->xa_offset on the canonical slot
while xas->xa_index remains at the sibling index.  Unlike xas_next_entry(),
which checks xas->xa_offset !=3D (xas->xa_index & XA_CHUNK_MASK) before usi=
ng
its leaf fast path, xas_next_marked() only checks node->shift:

include/linux/xarray.h:xas_next_marked() {
	if (unlikely(xas_not_node(node) || node->shift))
		return xas_find_marked(xas, max, mark);
	offset =3D xas_find_chunk(xas, true, mark);
	xas->xa_offset =3D offset;
	xas->xa_index =3D (xas->xa_index & ~XA_CHUNK_MASK) + offset;
    ...
}

If a leaf-level multi-index entry is split after the initial lookup, the
next step in xas_for_each_marked() searches from the canonical
xas->xa_offset + 1 and rewinds xas->xa_index backwards.  Adding
xas->xa_offset !=3D (xas->xa_index & XA_CHUNK_MASK) to the fallback conditi=
on
in xas_next_marked() would match xas_next_entry().

> =20
>  	while (xas->xa_index <=3D max) {
>  		if (unlikely(xas->xa_offset =3D=3D XA_CHUNK_SIZE)) {
>  			xas->xa_offset =3D xas->xa_node->offset + 1;
> @@ -1512,10 +1520,8 @@ void *xas_find_marked(struct xa_state *xas, unsign=
ed long max, xa_mark_t mark)
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

[Severity: High]
Can rewinding xas->xa_offset to the canonical slot without updating
xas->xa_index corrupt the cursor if a concurrent split occurs before the
slot is reloaded?

CPU0                                  CPU1
xas_find_marked() [xa_index =3D 127]
  /* shift-6 node,xa_offset =3D 1 */
  entry =3D xa_entry(..., 1)
  if (xa_is_sibling(entry))
    xas->xa_offset =3D 0
                                      xas_split()
                                        /* replaces slots 0 and 1 with
                                         * marked child nodes child0
                                         * (0..63) and child1 (64..127)
                                         */
  offset =3D xas_find_chunk(..., false, ...)
    /* returns 0; offset > xa_offset
     * is false, xa_index stays 127
     */
  entry =3D xa_entry(..., 0)
    /* loads child0 */
  xas->xa_node =3D xa_to_node(entry)
  xas_set_offset(xas)
    /* descends into child0[63] with
     * xa_index =3D=3D 127
     */                               <-- returns entry for index 63
                                          with xa_index =3D=3D 127

Because xas_reload() only checks the offset within xas->xa_node, callers
such as find_get_entry() reload child0->slots[63] and do not detect the
mismatched subtree.  On the next call, climbing out of child0 via
child0->offset + 1 moves xas->xa_index backwards to 64.  Similarly, if slot
0 is no longer marked after the split while slot 1 is marked,
xas_find_chunk() returns offset 1, which satisfies offset > xas->xa_offset
and calls xas_move_index(xas, 1), zeroing the low bits of xas->xa_index and
rewinding it from 127 to 64.

[Severity: High]
Does leaving xas->xa_offset on the canonical slot while xas->xa_index holds
a sibling index also cause xas_pause() to overshoot the next entry?

lib/xarray.c:xas_pause() {
    ...
	if (node) {
		unsigned long offset =3D xas->xa_offset;
		while (++offset < XA_CHUNK_SIZE) {
			if (!xa_is_sibling(xa_entry(xas->xa, node, offset)))
				break;
		}
		xas->xa_index &=3D ~0UL << node->shift;
		xas->xa_index +=3D (offset - xas->xa_offset) << node->shift;
    ...
}

xas_pause() masks off only the bits below node->shift and adds
(offset - xas->xa_offset) << node->shift, assuming get_offset(xas->xa_index,
node) equals xas->xa_offset.  When xas_find_marked() matches an entry cover=
ing
slots 0..1 at start index 127 (slot 1 in a shift-6 node), it returns with
xas->xa_offset =3D=3D 0 and xas->xa_index =3D=3D 127.  A subsequent xas_pau=
se()
computes (127 & ~63UL) + ((2 - 0) << 6) =3D 192 instead of 128, causing cal=
lers
such as tag_pages_for_writeback() to skip marked entries in indices 128..19=
1.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124213409.2224=
472-1-heyheyco@gmail.com?part=3D1

