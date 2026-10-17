Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 607A7CCF2CC
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 21:31:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3207F6B0088; Sat, 17 Oct 2026 17:31:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1B36B008A; Sat, 17 Oct 2026 17:31:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7206B008C; Sat, 17 Oct 2026 17:31:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C76596B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 17:31:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 94DAE40339
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 21:31:39 +0000 (UTC)
X-FDA: 85333415118.08.E984994
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 03A61120007
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 21:31:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cp/cX3FE";
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792272698;
	b=xHjndreieh/xzJyOj1SmT94UD55n5PUibp8rmw+ZQK032KCeotX696MstfqIiiBUZR8PB6
	ji96VzUHi24esHtPWArvECFNlBYAm00id8dN4MqLZoZA0ujOBYzcnrRcZG0UH4F3sdtx1U
	0Zz2yW6v2SXXl3oHkzd5TOPM1/mQiB0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cp/cX3FE";
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792272698;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LfcIRZkzNhVBYriP+PkLhm3GnpAehPIIrwSuJbYsqto=;
	b=XUKYVdm0Svw3OV6WphyH7ntSmjPa31e4FjDE5JhT7Ec+ObDyOqoX0YdcsgEq3ugOLlO9Lb
	jXNGaBgOPcXfqo1TrAnKKcqfU3LRDIoNOBwA1RLOSAT/KeUF1sKwszFa4YEno8xGNyk3fR
	M8cWRUfKno+LReHIoVflIhH1Dh9Ev6c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C34D460142;
	Sat, 17 Oct 2026 21:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBCB1F000C4;
	Sat, 17 Oct 2026 21:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792272696;
	bh=LfcIRZkzNhVBYriP+PkLhm3GnpAehPIIrwSuJbYsqto=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cp/cX3FEBTQXco9fsDQ5QLELoeGq95PbcOWg1JmO+BT+XWWMR1hmJPB3nWJMMXwFv
	 oMr4NIJ3c8X3KT4/WYhW6GbGPrC6czpaev0yNWFYcxa+roMj6mwYvKAvB9k+9nuG9U
	 k1H44QwTy+8OrFSgk0wY1ioXPoJhuMQzMCqxQAgZMuHcgl6ymPXiXjNNR21KGpnda+
	 GPZ8ASmsn6IBniEZ2TVJepIVIgTgIZkxx6VRiggJgYIZztNTfSviB72sTVIY88HB3V
	 9k+gAL+QASl+B6x0Nas6qaunRudRSA+VdDDTbbIzegX+eQxDfOMASKvj97nUS/CCfH
	 jOVT0QRjND+Cg==
Message-ID: <sashiko-outbox-175822@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/mglru: fix using folio_mark_accessed to replace
 folio_set_active
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org
Cc: ehab.ababneh@intel.com, axelrasmussen@google.com, kasong@tencent.com, lance.yang@linux.dev, qi.zheng@linux.dev, shakeel.butt@linux.dev, weixugc@google.com, yuanchu@google.com, yuzhao@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com
In-Reply-To: <20261016213115.70515-1-baohua@kernel.org>
References: <20261016213115.70515-1-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 21:31:35 +0000
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 03A61120007
X-Stat-Signature: agyd4bgtyjdjhwhex6jd1crip5frtppi
X-Rspam-User: 
X-HE-Tag: 1792272697-320202
X-HE-Meta: U2FsdGVkX18hQYtsIVcbJu4ZGqOIacxfLxbEj+ylThOtsFsaPWRxTgH6EYgwPea8Nthl/xdmmr0+EfNiArhe8P3vpZLTpkoEzaMpKtMFZ5blf4DXtcWd+/afUtPB3wzyley0ejeDW4VtbzXQ6uKbqUxEbfsY7d5toDKDKvCxPhW/iNnhD5tJC3FUG798YG5SgOhbynAvvKOGxea0oF2cYahIf05fP4NwF2feeyVxW++Eh8AueBxx3jEEHNATE1lmTuTcLWtj/0QsGnbp4HleEYPDAgf6vLNAA8vtz88K3AZ6PgFCfsGn8wRORKVLapTBaRZIJJpbNut4KITFtdIfvFWye97D3OCzWXIM204OJsbyCyOg30ufVKUiatZbXbn2AAnkl4mHf6cmQlm76rRRuKCVJIGO4uYhz/w9aBWmgK4HnLXaIbUH22GX7K6nb34khLvdsqvdsn3KaAliknGgFVMBj4JM9OxcfnON0rk2z8g1sB0dcOlKA9wKBRlYzo7la9SDgnIC/r8L3T4brdt1cx3ECFOY04l2+x3qrK6T7Kl2ozBGdtc3BCA8Okg2tZhZoGHGLQhj6nryt1ZlZmhDlCfMf1N2hE6lx5fZe16A8bKNp176c6mUe05Z1xMRKxOgWwIzdTmJ7Sqg/lJeSd+j7InyYFpxYlP75XuEQ3mjQfMV4jvZLW3TcEJ3FVYU76fk466EsYstaK8kvP/x18zTbqX6fMlP2lAXm0G8tHZepiuaMnxlrHHqPFYy0Hzbcbyl1altTI+ugi6wno1LAxi1qMGpnk1HGbWS5FSR1ZaJ0Ij1Cs6Algkjd2FREuBMH8dB7K3Ucg+0fCFz1mnjiYkpU7KCw77Dy305aQysqT+Hwi6Noo3pAax9cdn71R++CvLExC1zP5Uv6+B8sL+i59MkbHZeVLenNXD/8w+vjWQ3Sdst3yn5Jo/BTlrVOMehwAM0mquMpRl+YxIW1Kx6ej9
 P2rpjnmB
 oa/OOZTHDdWFze2BOySSPv1fMYMJ7r50cO0p5YhfWSe7R5RqNYkbps6ZTatd8LqvRAQjzYFX7WhmjPvNeKa7zaTMBSRXN4EBiCnOuaPYxrzarr8trA+mZESbWwx+hS/qoDkJQMjw4/jBmJg2SwRU4C0P5L/LXAhBcI5co6esXAW6kJKwOrlkQVYtrUj+af6aHr5I0Rsmb11K/6UO1FCRqSRr7yqg4Owr+ljWqCAPfn4koyibiE+gjm8G1KQgXM/lD7vUugQKIMloI9vdueTZlgMU5U0Sq3y4qWyJQMUOnBQm8fLW0/UNdDGA3LzIPkJs5P2Qx3zOARhJhi7/VsIWl3b/fUsiXQWNbHjXWTzFZzLD0sUnEdTGZ/XQ5um7yvlsyJIh0yCMXbFu0Ks3cLmgm2N+lqEgGZOi+OJkdLNXzls0ZquwxgtNbeFC9YmskZZUpCrH7oBJYX9efc0tq4Zob2zPomFiidBpOpRyqArWg8ykwDGgLytp+uf05oIoe3tTmV662d+YD8CLl9eivE2Vbm5b0XRjaMOGV02nmAJ7cUtNOiqPFYMsWCs3+LNqPKKSPPgclAWbo3cZHm5hGnm5N4IWp+Lo5vq2dPNC7QUcsWz2b1jPYE/PToUOpwy1yhK6UW/Ek6BdTBe68sOIyBZQ/G4B7KnSEU/XjKkE5fQJm5j+gdz0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mm/mglru: lru_gen_folio_seq() demotes non-workingset active file f=
olios
- [Medium] mm/mglru: lru_gen_refault() miscounts WORKINGSET_ACTIVATE_FILE
--

commit fa50b3cc1b1d64cb457afbbf37dc545c6d4e06f1
Author: Barry Song (Xiaomi) <baohua@kernel.org>

mm/mglru: fix using folio_mark_accessed to replace folio_set_active

This commit reverts the use of PG_referenced on in-fault readahead file
folios from commit 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to
replace folio_set_active"), and instead adjusts lru_gen_folio_seq() to place
file folios with PG_active set and PG_workingset clear into the
third-youngest generation.

> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index ab69b9930893f..97f157aafd581 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -319,7 +319,8 @@ static inline unsigned long lru_gen_folio_seq(const s=
truct lruvec *lruvec,
>  	 * |<---------------------------- MAX_NR_GENS -------------------------=
--->|
>  	 */
>  	if (folio_test_active(folio))
> -		gen =3D MIN_NR_GENS - folio_test_workingset(folio);
> +		gen =3D MIN_NR_GENS - folio_test_workingset(folio) +
> +		      (type ? !folio_test_workingset(folio) : 0);

[Severity: High]
Does assigning gen =3D 3 (lrugen->max_seq - 2) for all file folios (type =
=3D=3D 1)
that have PG_active set and PG_workingset clear break other MGLRU paths that
set PG_active expecting the folio to land in an active generation?

First, in mm/vmscan.c, evict_folios() promotes folios rejected by
shrink_folio_list() out of min_seq[type] by clearing LRU_REFS_FLAGS and
setting PG_active:

mm/vmscan.c:evict_folios() {
	...
		folio_set_lru_refs(folio, 0);
		if (lru_gen_folio_seq(lruvec, folio, false) =3D=3D min_seq[type])
			folio_set_active(folio);
	}

	move_folios_to_lru(&list, false);
}

When 3 generations exist (lrugen->max_seq - lrugen->min_seq[1] =3D=3D 2),
max(lrugen->max_seq - 2, lrugen->min_seq[1]) equals min_seq[1]. A rejected
!PG_workingset file folio (for example, a mapped file folio spared via
FOLIOREF_KEEP on its first rmap scan in lru_gen_set_refs(), a DMA-pinned
folio, or a folio failing try_to_unmap()) has its PTE accessed bit and
PG_referenced cleared, and move_folios_to_lru() -> lru_gen_add_folio() puts
it right back into min_seq[1] instead of promoting it. Even when 4
generations exist, evict_folios() clears PG_referenced and puts the folio in
lrugen->max_seq - 2, so the next rmap scan in lru_gen_set_refs() sees
!folio_test_referenced(folio) && !folio_test_workingset(folio) again and can
never promote it to PG_workingset.

Second, in mm/vmscan.c, shrink_folio_list() sets PG_reclaim on dirty or
writeback file folios and jumps to activate_locked, which sets PG_active:

mm/vmscan.c:shrink_folio_list() {
	...
		if (folio_test_dirty(folio)) {
			if (folio_is_file_lru(folio)) {
				node_stat_mod_folio(folio, NR_VMSCAN_IMMEDIATE,
						nr_pages);
				if (!folio_test_reclaim(folio))
					folio_set_reclaim(folio);

				goto activate_locked;
			}
	...
activate_locked:
	...
		folio_set_active(folio);
}

Because lru_gen_folio_seq() checks folio_test_active(folio) before the
PG_reclaim && (folio_test_dirty(folio) || folio_test_writeback(folio))
branch (which assigns gen =3D MIN_NR_GENS =3D 2), won't setting PG_active o=
n a
!PG_workingset dirty or writeback file folio downgrade it from gen =3D 2
(active) to gen =3D 3 (inactive, or min_seq[1] when 3 generations exist)?

Third, when a !PG_workingset file folio is explicitly activated via
folio_activate() -> lru_activate(), or when it is isolated from the active
generation lrugen->max_seq - 1 for migration/compaction via
lru_gen_del_folio() (which sets BIT(PG_active) when !reclaiming &&
lru_gen_is_active(lruvec, gen)), re-adding it via lru_gen_add_folio() now
places it into lrugen->max_seq - 2 (LRU_INACTIVE_FILE). Doesn't this demote
activated and migrated active file folios into an inactive generation?

>  	else if (reclaiming)
>  		gen =3D MAX_NR_GENS;
>  	else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(folio)) ||
> @@ -327,7 +328,7 @@ static inline unsigned long lru_gen_folio_seq(const s=
truct lruvec *lruvec,
>  		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
>  		gen =3D MIN_NR_GENS;
>  	else
> -		gen =3D MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_refe=
renced(folio));
> +		gen =3D MAX_NR_GENS - folio_test_workingset(folio);
> =20
>  	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_=
seq[type]));
>  }

[ ... ]

> diff --git a/mm/workingset.c b/mm/workingset.c
> index 1504f91cdca5f..10d4ce202cca4 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -319,13 +319,11 @@ static void lru_gen_refault(struct folio *folio, vo=
id *shadow)
> =20
>  	atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);
> =20
> +	/* see folio_add_lru() where folio_set_active() will be called */
> +	if (lru_gen_in_fault())
> +		mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
> +
>  	if (workingset) {
> -		/*
> -		 * see folio_add_lru(), where folio_set_active() is
> -		 * called for workingset folios
> -		 */
> -		if (lru_gen_in_fault())
> -			mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
>  		folio_set_workingset(folio);
>  		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + type, delta);
>  	} else

[Severity: Medium]
When a file folio (type =3D=3D 1) refaults in a page fault with workingset =
=3D=3D
false, should WORKINGSET_ACTIVATE_FILE still be incremented here?

With workingset =3D=3D false, PG_workingset is not set. Although folio_add_=
lru()
calls folio_set_active(folio), lru_gen_add_folio() clears PG_active and
lru_gen_folio_seq() now maps a file folio with PG_active and !PG_workingset
to gen =3D 3 (lrugen->max_seq - 2).

In include/linux/mm_inline.h, lru_gen_update_size() only accounts
lrugen->max_seq and lrugen->max_seq - 1 as active:

include/linux/mm_inline.h:lru_gen_update_size() {
	...
	/* addition */
	if (old_gen < 0) {
		if (lru_gen_is_active(lruvec, new_gen))
			lru +=3D LRU_ACTIVE;
		__update_lru_size(lruvec, lru, zone, delta);
		return;
	}
	...
}

When 3 or more generations exist, the folio is added to LRU_INACTIVE_FILE,
so moving the mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type,
delta) call outside if (workingset) counts an activation for a file folio
that is placed in an inactive generation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016213115.7051=
5-1-baohua@kernel.org?part=3D1

