Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A14B8606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e/Vedqsm
Received: by kanga.kvack.org (Postfix)
	id 994DE6B0AC5; Wed, 25 Nov 2026 16:34:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96C336B0AC7; Wed, 25 Nov 2026 16:34:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A8E56B0AC8; Wed, 25 Nov 2026 16:34:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8126B0AC5
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:34:41 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F03B616013B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:34:40 +0000 (UTC)
X-FDA: 85474945920.27.8EE0DE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 61AAA12000C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:34:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="e/Vedqsm";
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642479;
	b=7YwguOqKyeP4rW0NO5oukkcC7zSyRRcsBA9znWBWWrkVeI7+Hw6NB+y70PSK0ME1niDA9F
	Eu1x+NCQp/XjfQ1piAwhNUajhPIl18FIz6jmZn8MvS/LOnSxw3kxkOW305dmSMBvJJJQix
	D8R+5og9782R/0xDp08RaCMcn/iM1cc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642479;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2QRBdN9xCO5VdXRI0zdyDkW4SZFJ1adboHkzZej3wWA=;
	b=fXGlpNcaUcVrfFwVUC8SQEKeR6Oo63y31FO2pbHRa3DB5FRp6sLTAJXxxUXdYDBswbE4FG
	Ng3hfzW/HrPmxXwA2u/R7cVmAS8ldYVb6D2FCpZF8sP3RmLnDFazPqf2cCZSHP/jHzeRm2
	7RmAdTQjQtf6QGBVonz2/ZMO8nlXTro=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="e/Vedqsm";
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00BB26156B;
	Wed, 25 Nov 2026 21:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050851F000D1;
	Wed, 25 Nov 2026 21:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642478;
	bh=2QRBdN9xCO5VdXRI0zdyDkW4SZFJ1adboHkzZej3wWA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e/VedqsmbHylrLGnKAShIX7NV4zefMLPH7O9+5r4A9VRKTuBGB1f4nXQ23GN0NUqT
	 vpQJk8hYlJikiFnw2qXrb3n1kaNS/MF5cyVbJdoSyTvyud+b7JXDPrceLA9GaBer8L
	 FDey2twG23f1nFp8/ljJTenZZBHRRWO0UbqP+OMXm9XZaxnBQRRITEvc398UMhedVu
	 mSUPWqngPsRU0Ei8OAcfWmr0TiRP3wD1z0z97acqEhvw53SlEYw3n5eZbcqgVnzJgX
	 Z3TXM5BVJp/GDxjtZL10Yi9cHMVoblZrTdW35DPPZRkqT+STYpNKpU9UbAb+cRbQSD
	 JcdISuRYk00hQ==
Message-ID: <sashiko-outbox-234187@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] xarray: fix index jumping backwards in
 xas_find_marked()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qian Xiao" <heyheyco@gmail.com>, "Matthew Wilcox" <willy@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, "Krystian Kaniewski" <krystianmkaniewski@gmail.com>
In-Reply-To: <20261124213424.2224554-1-heyheyco@gmail.com>
References: <20261124213424.2224554-1-heyheyco@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 21:34:37 +0000
X-Rspam-User:
X-Rspamd-Queue-Id: 61AAA12000C
X-Stat-Signature: ezgy1j4fz1b9g849kub6rbk86ipupmdj
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795642479-311877
X-HE-Meta: U2FsdGVkX1/VX/GpufnqeHxrhZxyJbW4ftriqrPfdfwYmcCzo7NgCw5u/Sb8+PFtkRJBSHFlbVu/hO089Ra2fIcREB8CIU00ozCMEj9Bp2ZiXUNlAELCR/n8yBbatroFF2NV/GqDrHU0k5hGdxFlODa0Z8OL1VFpFHzUuY+AIhyMig/dlzj7lbjornPiK9Fq3TTdawsBOuGydAGqj45J+8BAE8Pbs8BJd83kkwKhByAcVr6MQu0SHcx7VhYTWRGbwdUvdqhmzOxQDKF//5bnk3xhMwNvDhLdSowDJ7u3QMQHXgm4HqXNpYA7mfXikJbCdESp/CETBgPhAwcOGhaLPgbYXj2lsyJUWwVxS0vXUjjIcLXXU3npK/GS+6LVhE/2VxbMG64XKVgw3MBYibBeVFBlXRwmjThTw5StErc6WtvyRR+bB6/w1jhAl6Y0QanVg/JiDmnnxH+06Ehrfm3CQPvXXPF0FJypvLShavkjJ6uTdjRSqMyR7HmE0Z/KiM3cKciNsruYxOdJjEKWEDADxWQfxbxlVKeeIBG4G6X1QCPJJU9MmDS+BYm1kRzhnAfz7YKeKdBLVXBMzUzAWj88xgauNxz7uxd0DW0YxH37ELm/segR4A72x/BKkl0Gjlb5PzhljO3C8WeII2H54XA6OBn9//iFh/qRA4rzhm/5pvJVTFuz0kCT/eAzywskkabL+YN1oIMGcPC5UKGIUDwo0/5Oz+espYiitFLffOTWnQfOoWTDhpgdU6BgLw6Xwz/iyLtl5+xLyon4sXGqpjHORvSupInFms7Q4dZlwYk04lkgxVY+ynw2qmsIGjfFSwMlK3zn0dMH5gj8hyuXvmCV79ACTmcCWRMrRy3eUJ2OYnyQD22yTL8PqgvJjuS16JwlRPppy9vztJmEnl+lTj0PHYTBU+1vLT9JQzONN7b4b+w120UtlXUKITyGurSSbf1KAkylZnyLrM9h25tZ9zD
 bFo5chT6
 pgrsMf4/RUXa6y4D2hDPFPJ2eTOyNXyhrQzOqFiFALsBbxBp0yvG1+dU6v70SlNt+4q1S5ExVPzpOuWd/DcJ1Q1KLCy+3jDTL2vDrxYalQtouToSTuM2ffT6l3gEL6uOJgIh1S4IA9A6r2aY0MqHlfuKg0yDuwMd8uKReZxMGLDW94jnQgG01eLyp10pD6jZ6XMl2hl/QuJub4NAVaHhJKsaYogYBTS/Y68MfGNQzHrNh7l/lv9Rgs3SjrvylA40nX3D8LOD1Bc60/oroqJZSwuehKuDvFQmtH5r1zrpPC2Qvax3kWkuWMLzmo4v9rzF5/ccCRmf66W1FP//t7EVXNfb0SgMdb49NQqHH0dDPnjaHrKPGZ80G9XY519Q+oBvAUfg/LiPgF2cIfIeUH/Z80yaw8uD2WYxfBxFI28zc/yQn24PtF2/FlaoB3eHQH7OxXoWqHGZ68IgcfunUYIn6OMrkCkmhPaR69M6l9dLmYFd7AnT8ygjQP/CmzgjpCIT4HZRPQS9SuDlnmYtx4XDdr9LHMOxTGhjDQQPXn9bLKsJ3Z5ynURpoPDLnV2HVQIR4d+cIK2A720MCUlsgJfm7nwavya1KIqX2tzY7BsqIDP03sq/OqArmG6pmvDXILkfIgRBheqOVQPeSi1Jt8M6FD0XBOU4w7H0T1D3Fp441DHLl/QaBFZt3bq06SF9KHi+CDpUKPC8Bz4AeAPpmzkRm3gsUFeJVKRlcvX1Fdb0cWNPy29ppN9qhjkA8ay5O+t4e9Z9dmTXaMT8XqLnMmJDQwa4hjnqQ3VmeqxfDoyDPvIs3lacRflNuzeVhehTYsG5IcuSJU19uzWh1ktRsdEusoPhgydbr8lZv3AXWApmhAvv4/2Q=
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
- [High] xarray: concurrent split race in xas_find_marked() on sibling
  resolution
- [High] xarray: xas_next_marked() misses leaf offset check and jumps
  xa_index back
- [High] xarray: xas_pause() overshoots xa_index and skips entries after
  sibling find
--

commit 9233cae6490ceca4faaeb7112a2155eec3568913
Author: Qian Xiao <heyheyco@gmail.com>

xarray: fix index jumping backwards in xas_find_marked()

This commit preserves xas->xa_index when xas_find_marked() resolves a
sibling entry and aligns xas->xa_offset from xas->xa_index before
advancing an already walked cursor.

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
Does xas_next_marked() bypass this leaf-node offset alignment when
advancing via xas_for_each_marked()?

Unlike xas_next_entry(), xas_next_marked() does not fall back to
xas_find_marked() when xas->xa_offset !=3D (xas->xa_index & XA_CHUNK_MASK):

include/linux/xarray.h:xas_next_marked() {
	struct xa_node *node =3D xas->xa_node;
	void *entry;
	unsigned int offset;

	if (unlikely(xas_not_node(node) || node->shift))
		return xas_find_marked(xas, max, mark);
	offset =3D xas_find_chunk(xas, true, mark);
	xas->xa_offset =3D offset;
	xas->xa_index =3D (xas->xa_index & ~XA_CHUNK_MASK) + offset;

When a lookup starts at a sibling index inside a marked multi-index entry
in a leaf node (node->shift =3D=3D 0), xas_find_marked() now returns with
xas->xa_offset at the canonical slot and xas->xa_index at the sibling
index.  If that entry is split before the next step, xas_next_marked()
searches from the stale canonical xas->xa_offset + 1 and recomputes
xas->xa_index backwards.

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
Can a concurrent xas_split() on a non-leaf multi-index entry cause
xas_find_marked() to descend into the canonical slot's child node while
xas->xa_index still points into the sibling slot's range?

CPU0                                    CPU1
xas_find_marked(&xas, ...)
  /* shift-6 node, xas_index =3D 100 */
  /* slot 1 is sibling of slot 0 */
  xas->xa_offset =3D 0;
                                        xas_split()
                                          /* replaces slots 0 and 1 with */
                                          /* child_0 (0..63) and child_1 */
  offset =3D xas_find_chunk(...) /* 0 */
  entry =3D xa_entry(..., 0) /* child_0 */
  xas->xa_node =3D xa_to_node(entry);
  xas_set_offset(xas); /* offset =3D 36 */
  return child_0->slots[36];            <-- entry for index 36 at xa_index =
100

Because xas->xa_index is left at 100 while xas->xa_node is child_0,
xas_find_marked() returns the entry for index 36 with xas.xa_index =3D=3D 1=
00.
xas_reload() in find_get_entry() also indexes child_0 by
get_offset(100, child_0) =3D=3D 36, so the race passes reload validation and
triggers VM_BUG_ON_FOLIO(!folio_contains(folio, xas.xa_index)) in
find_lock_entries().

In addition, if the mark on canonical slot 0 is cleared after the split
while a slot at canon_offset < offset <=3D get_offset(xas->xa_index, node)
remains marked, xas_find_chunk() returns that offset and
xas_move_index(xas, offset) moves xas->xa_index backwards (from 100 to 64).

[Severity: High]
Does leaving xas->xa_offset on the canonical slot while keeping
xas->xa_index at the sibling index also cause xas_pause() to overshoot
xas->xa_index and skip entries?

lib/xarray.c:xas_pause() {
    ...
		unsigned long offset =3D xas->xa_offset;

		while (++offset < XA_CHUNK_SIZE) {
			if (!xa_is_sibling(xa_entry(xas->xa, node, offset)))
				break;
		}
		xas->xa_index &=3D ~0UL << node->shift;
		xas->xa_index +=3D (offset - xas->xa_offset) << node->shift;
		if (xas->xa_index =3D=3D 0)
			xas->xa_node =3D XAS_BOUNDS;
    ...
}

xas_pause() masks out only the bits below node->shift and adds the full
entry span (offset - xas->xa_offset) << node->shift onto xas->xa_index,
assuming get_offset(xas->xa_index, node) =3D=3D xas->xa_offset.  When a walk
starts at index 3 inside an order-2 marked entry at 0..3 (xas->xa_offset =
=3D=3D 0,
xas->xa_index =3D=3D 3) and calls xas_pause(), xas->xa_index becomes 3 + 4 =
=3D 7
instead of 4, skipping indices 4..6 in callers such as
tag_pages_for_writeback().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124213424.2224=
554-1-heyheyco@gmail.com?part=3D1

