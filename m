Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2764606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 21:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mztTNeX8
Received: by kanga.kvack.org (Postfix)
	id 9DF0E6B05B1; Sat, 14 Nov 2026 16:27:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9685C6B05B2; Sat, 14 Nov 2026 16:27:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87EA26B05B3; Sat, 14 Nov 2026 16:27:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57BD56B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:27:23 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C6698801B7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 21:27:22 +0000 (UTC)
X-FDA: 85435010724.22.B63D403
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1E556C0008
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 21:27:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mztTNeX8;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794691641;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=22EDqfVTIfyk4rtUf9ZWN7CwOktTOEs/W592TIHQZM8=;
	b=RH5EurWK2+YkRllBWrp8ffRLFXL144P/8QHW9qO+ZnPXc7fCIwt/IU7Ri9mbJUBM5/x2MH
	c8TafXPU7VwzzqcWWz76g2rJr1X+/Tk+EhgdOLVB5qEoBDQ017DMcgT7ucpKKrGNsEy/vu
	B4R/HEm14Gi4sMdH7ig2HPdhbzX8v2A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794691641;
	b=dA99pKX657W2jMrYDmK/bK9MfPptVSAEEDd9jBnkxiE4gKGimwhXhYHR0KdynHhZ4+KxMa
	ubi+bX4WqMO8HC+Q5AL3kjvMfZxsLmYHcVucb1y3ZaLWSFd/BMGMLwZ/A1ggHyITTaGctU
	YK0+kGbildiU4LQzLohIq+SJkzPNZuk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mztTNeX8;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C194435EF;
	Sat, 14 Nov 2026 21:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43411F000C4;
	Sat, 14 Nov 2026 21:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794691639;
	bh=22EDqfVTIfyk4rtUf9ZWN7CwOktTOEs/W592TIHQZM8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mztTNeX8w4E9iPq8P8mRHAm1QSag2DbKVFvIGYmqOWG9+6Kp+KtTWNCQV5bYPQIXa
	 j2I+CtL6bffYSWHwu7662Wh8euIx9SwUBPaEM2+Sp5hijCnoTpgc7zBqEG+ISbFVoA
	 UTg2h7FBQLOqgNL31d0McKnYihyQKV6tavoRdoYWEqVMM3qctV/LoLDva1jvUMHe+H
	 8gJou02Q8gsYehzxrEOHnuSOhXYon21mq/NNQWiW1vCdAlK8cNpymEjEZ1MhkcmSAi
	 0KZvabKEMvP8V9eP8DVwe57RUNBzTJ1wFSqAdMukB8ANbm2xgtsedlWjGdQZmw8Nbe
	 gGy7ngcjeaDJQ==
Message-ID: <sashiko-outbox-215042@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 2/8] xarray: add xas_prev_canonical()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kairui Song" <kasong@tencent.com>, linux-mm@kvack.org
Cc: "David Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Matthew Wilcox" <willy@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Michal
 Hocko" <mhocko@kernel.org>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Barry
 Song" <baohua@kernel.org>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Zi Yan" <ziy@nvidia.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>
In-Reply-To: <20261114-swap-thp-split-v1-2-dfa8d4fa448d@tencent.com>
References: <20261114-swap-thp-split-v1-0-dfa8d4fa448d@tencent.com>
 <20261114-swap-thp-split-v1-2-dfa8d4fa448d@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 21:27:17 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: k1qdf4iwthphysgqh8ogaqskyu8pf1w1
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1E556C0008
X-Rspam-User: 
X-HE-Tag: 1794691640-881305
X-HE-Meta: U2FsdGVkX19ElDyI5BzQPoh8Fx3uyESVjU9rIvDX+eEukzv3iW8Fxzo9A1i+U9i7aeNaEHn2Kd7UxV54dMEhVtOUVsY4dgQlFlchsgEhxdAlviLMcUWh3NUd0kEtyj6ZXqufFk9bPZ4+U384nSNs5989k1oyfXItXj7g9/Abpp6K3XuTWZVp0Uz71CoZgyEQsAquKgURjUMlseqy2qG/wrJX12EB4sIzdT8hlKAqEDHI60QFjNV7vad1iJTCQqqSjw7c2wgX2WBMIyJAaYJ+Yf9V33WzF0w4gtZPa9OMK1hS8fxJBLv1WwzNLtZmfVAvyaajbIX3dKN6pThI0MCbqsCvtIdwRYGnQ2fXhpY8aoVq4i2fV0ztJVtI0Y4YHt5X4+I0Dpgy1S5lB8Qv5iHOgUjqvhD3nY9Yao89pbQ04PVPNq9N5DXm/FUKdJbdj1EhQihnDzVMrXbiZ6eQu1BuRtcjwf4qclrQKqRSHLw7r1W4805m3h7VgtHpBanMPP96LlFpUBmOyahwT3mmkI8WecVZhRsvqQGo0PxcIE1WEqpKguicAqzaJtxoU+Mjral4xKvIr4TXaTxkbAkvv+z8hvwsYU24u8BpMpSYDmvZV3Zrgf71aF4Qp/LUUsn+IjfYL+Rlxmoi8OAHeGqfFDAiWrYlQYVqdu+EzL9nhVHnWdEWJ4vY+sytpv9qndVae3P5LzNa3eDrlC45FA/PLYOm9Vi7mqokrhbIYjil696G1JxrYfR9tN1Lo5Xo/UOFiBRL02pulxNbJe+AA/qUz0wA0LGyPuI3v27MdcdPVFHzDZ5Pm6jjg5RE3Le2jqAuiaPdMO7SgMpFElfRRdEWd07LFB2KXObIBHTm6xO/qUc/2atj7dhDuLd8DBxAWWzSPiojJ5s2arpgRbRg4n04kA+mVcCznv/tl48pF7GYtsoyh/KxvoWXGsHeGbFGT4QnJB5vNBvceyEI/foCHyWJHxh
 1dWlFaOH
 vtVjAVawLawfzCImLi7/JJoQEWB9BhaS96D5KNi6oVOgKmBXp77CoqXOfgNiPXsZUJtYMQkjBKcYLBk/qGXByFWDLt6oeZN9bGCYKcmeO9Z9xRqWdq4B1GQ6MCJRWtBPczC3a5IS4R+PX+nNgDQL3TkymqaXiRYWNonWWtCaJY4UeQAJ0FQOW4Z0bjgVNxGtBXqK6X+NdET/TfZItYTNWUWjDoo+/CoRTEGAbZn3fvOtyRch5FfM2PhBJOg862CUsr7yRV3p7oayLNEGIkpE2GlyC/hjqtZY0o+Wwe6QSHGRwFfqlHby/Xrl9tANeEWiAYDzc2h95KaCbLRGUksmVAgwmQ5KQYpPWJN43fh/nXessBRr/SPh3bvPrmqs6I7hWZ/QS3RXqiOgTNjA0pusoqrkg2LkMUhAB9S26a7ISDmGhcibvknNHmckKM8gStCwAQHhGLTWWJrrlCIzFmWUA/tUhMnuXi/M/3ADprxfnWRyWrGLz/j1PJauRtb4xZw5afJcip6U/+EHS4rCVJRFP0Bhe57lOtPgVzm7kJthCmLYJwkikdqU8jVpQYWAQLbHtcDiC7yPgFRFHaqRFOjiiz9WqvJyRQVWj3H2hJhUTULjjnc0HmpOXQBCMR3ezgzkir0SkDQbMtyg8HJc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] xarray: xas_prev_canonical() corrupts xa_index on
  XA_RETRY_ENTRY
- [Medium] xarray: xas_prev_canonical() steps off non-leaf canonical
  slot on split
--

commit b768624f5f5a261ca8a1796cf3f8c4a5e5deca0d
Author: Kairui Song <kasong@tencent.com>

xarray: add xas_prev_canonical()

This commit adds xas_prev_canonical() to step backwards over multi-index
XArray entries onto the canonical slot and first index covered by the
entry, along with test cases in the XArray test suite.

> diff --git a/include/linux/xarray.h b/include/linux/xarray.h
> index be850174e802e..b76d24e7a46b3 100644
> --- a/include/linux/xarray.h
> +++ b/include/linux/xarray.h
[ ... ]
> @@ -1883,6 +1892,46 @@ static inline void *xas_prev(struct xa_state *xas)
>  	return xa_entry(xas->xa, node, xas->xa_offset);
>  }
> =20
> +/**
> + * xas_prev_canonical() - Move iterator to the previous entry, onto the =
slot
> + * which stores it.
> + * @xas: XArray operation state.
> + *
> + * Same as xas_prev(), but it steps back over a multi-index entry as a
> + * whole: the state is left on the slot which stores the entry and on its
> + * first index, so xas_get_order() reports its order.  A cursor already
> + * inside an entry reports that entry instead of stepping off it.
> + *
> + * Context: Any context.  Hold the xa_lock or the RCU lock across the
> + * whole walk; xas_pause() is forward-only.
> + * Return: The entry at the new position, or %NULL (empty slot, error
> + * state, or the end of the walk).  The result may be an internal entry,
> + * which needs xas_retry().
> + */
> +static inline void *xas_prev_canonical(struct xa_state *xas)
> +{
> +	void *entry =3D NULL;
> +
> +	/* step back unless @xas is already inside an entry */
> +	if (!xas_is_node(xas) ||
> +	    xas->xa_offset >=3D XA_CHUNK_SIZE ||
> +	    xas->xa_offset =3D=3D ((xas->xa_index >> xas->xa_node->shift) &
> +			       XA_CHUNK_MASK))
> +		entry =3D xas_prev(xas);

[Severity: Medium]
Does shifting xas->xa_index right by xas->xa_node->shift step off an entry
when the cursor is at a non-initial index inside the canonical slot of an
internal node?

When an entry has order >=3D XA_CHUNK_SHIFT (xas->xa_node->shift > 0), the
canonical slot itself covers (1UL << xas->xa_node->shift) indices.
Discarding the lower shift bits makes xas->xa_offset equal
((xas->xa_index >> xas->xa_node->shift) & XA_CHUNK_MASK) for every index
within that canonical slot, so xas_prev_canonical() calls xas_prev(xas)
even when xas->xa_index is past the first index of the entry:

CPU0                              CPU1
xas_load(&xas)
  /* order-6 entry at [128, 191],
     xas_index =3D 150, shift =3D 6,
     xa_offset =3D 2 */
                                  xas_split()
                                    /* splits slot 2 into child node */
xas_prev_canonical(&xas)
  /* (150 >> 6) & 63 =3D=3D 2 */
  xas_prev(&xas)
    __xas_prev(&xas)
      xas->xa_index--; /* 149 */
      /* descends into child node
         at 149 instead of retrying
         at 150 */                <-- skips entry at 150

Preserving the lower shift bits the way xas_sibling() does (comparing
xas->xa_index & ((XA_CHUNK_SIZE << node->shift) - 1) against
(unsigned long)xas->xa_offset << node->shift) would avoid calling
xas_prev() when the cursor is already inside the canonical slot.

> +	if (!xas_is_node(xas))
> +		return entry;
> +	if (xa_is_sibling(entry))
> +		xas->xa_offset =3D xa_to_sibling(entry);
> +
> +	entry =3D xa_entry(xas->xa, xas->xa_node, xas->xa_offset);
> +	/* a concurrent store or split can leave a sibling or a node here */
> +	if (xa_is_sibling(entry) ||
> +	    (xas->xa_node->shift && xa_is_node(entry)))
> +		return XA_RETRY_ENTRY;
> +	xas_move_index(xas, xas->xa_offset);
> +	return entry;
> +}

[Severity: Medium]
Can xas_prev_canonical() move xas->xa_index backwards before returning
XA_RETRY_ENTRY, or lose an XA_RETRY_ENTRY returned by xas_prev()?

During a lockless RCU walk, xas_retry() calls xas_reset(), which sets
xas->xa_node =3D XAS_RESTART and relies on xas->xa_index remaining at the
index that needs to be retried so the next __xas_prev() call reloads that
same index.  Here, if xas_prev() returns a sibling entry and the canonical
slot at xas->xa_offset has been overwritten with XA_RETRY_ENTRY by a
concurrent xas_free_nodes() or xas_shrink(), XA_RETRY_ENTRY is neither a
sibling nor a node, so execution calls xas_move_index(xas, xas->xa_offset)
before returning XA_RETRY_ENTRY:

CPU0                              CPU1
xas_prev_canonical(&xas)
  entry =3D xas_prev(&xas)
    /* lands on sibling slot,
       returns xa_mk_sibling(off) */
  xas->xa_offset =3D off;
                                  xas_free_nodes()
                                    /* overwrites slot[off] with
                                       XA_RETRY_ENTRY */
  entry =3D xa_entry(..., off);
    /* entry is XA_RETRY_ENTRY */
  xas_move_index(&xas, off);      <-- lowers xas->xa_index
  return XA_RETRY_ENTRY;
xas_retry(&xas, entry)
  xas_reset(&xas);
xas_prev_canonical(&xas)
  __xas_prev(&xas)
    xas_load(&xas)                <-- reloads at lowered xa_index,
                                      skipping intermediate entries

In addition, if xas_prev() itself returns XA_RETRY_ENTRY (for example via
__xas_prev() -> xas_load() -> xas_descend() when a sibling in an internal
node was concurrently split into a child node), xas_prev_canonical()
unconditionally overwrites entry with xa_entry() and loses the retry if
that canonical slot was concurrently replaced with a normal entry.

Checking xa_is_retry(entry) after xas_prev() and before xas_move_index()
would preserve both the retry entry and xas->xa_index.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114-swap-thp-s=
plit-v1-0-dfa8d4fa448d@tencent.com?part=3D2

