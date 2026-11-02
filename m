Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBD26606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 19:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OrJUtj1Q
Received: by kanga.kvack.org (Postfix)
	id EC2406B00EF; Mon,  2 Nov 2026 14:01:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E985D6B05B1; Mon,  2 Nov 2026 14:01:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD49F6B05B2; Mon,  2 Nov 2026 14:01:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD0E16B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:01:11 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E72EA0223
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:01:10 +0000 (UTC)
X-FDA: 85391096700.07.5CCBCB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id BC163160005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:01:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OrJUtj1Q;
	spf=pass (imf08.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793646068;
	b=ngtHcklGO64geikE0UmJNtT5vDfpONtA1bIUNVbmQzlj0jll0h2yz+THhNr7HBpL1WTu1Z
	tdoCSqz3JYhrBUHKSy22FAoDE1+vuqc7VRBkF3g1SBeK66flSJKvLH1/xG/d4rufMSP08u
	99COSNLvQF/GRg0COoq7zWUeN4AuNL8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OrJUtj1Q;
	spf=pass (imf08.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793646068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZecBYjWUhN4z7fJ6GXfUmUEfwYtS6fvFv39qR2svdwg=;
	b=13Jceh/vDWMEo8jxUCpxMoKjT7ntCu4d7Ze8IAayJhEDHTVLDCczBOrLX57ckLPLee9xal
	IE45Se38fnRQ24hqMoef/3WChNWEGkmzGGH2rtvgHE1NUGPaqRj4+DhBamvCYgQrKQPA/+
	bFGPZYjFmkdulA/3B8YKpLuE0XvIYtk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 34DA541168;
	Mon,  2 Nov 2026 19:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6741F00A16;
	Mon,  2 Nov 2026 19:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793646067;
	bh=ZecBYjWUhN4z7fJ6GXfUmUEfwYtS6fvFv39qR2svdwg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OrJUtj1QmMk8l1ckUmFtbmCtyGHk78wo4/k1AMngqmUzGb25vHp7820KWVkl2lSMF
	 rmU+YOR7SyfXAoSs+sjcUYAhq+M4MI5oqqsNvpPTU8IEh7uaxIEn7NNoNaKNUyyDLL
	 ZWN6jw+KcG8SvcYQMTXHaIHLk9ThnnrVMfcODPpGalpIZvpIe0nE1oYlR3Bj9kcrIs
	 C1S2MrFKRWxx39BqfcRMfho537Saox7qxlTGPbwesu/SdrCmRKWuUMinDs4+qNA+fC
	 HgT89W9Ii8pqPgUTdNXc3aR5n5uanYs7dmKQV8zvfmF3zuzQ8BaBFy8poI72foXumx
	 L5zWxtz03WDrg==
Date: Mon, 2 Nov 2026 19:01:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <sashal@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	David Hildenbrand <david@kernel.org>,
	Jisheng Zhang <jszhang@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-riscv@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH linux-next] riscv/mm: fix up the mm-fixes merge of
 free_pmd_table()
Message-ID: <b396618b-fa12-46c2-9140-d9e555dc8408@sirena.org.uk>
References: <as0D2sHzh_UnNF5L@sirena.org.uk>
 <20261030221401.155797-1-sashal@kernel.org>
 <20261030153347.5641a97e22e18ddff6043416@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="d4hTvcyUwKyTx7AM"
Content-Disposition: inline
In-Reply-To: <20261030153347.5641a97e22e18ddff6043416@linux-foundation.org>
X-Cookie: Used with permission.
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BC163160005
X-Stat-Signature: u4xz8o4u1tama64rcrapxbs7khnrcfym
X-Rspam-User: 
X-HE-Tag: 1793646068-885399
X-HE-Meta: U2FsdGVkX19HseGUS9X3ks2+HHknj9KwgsD3eEpYPIxzS3+IhfBbqWnuhHdp4ud6JMl+KG61917OltPH933gkcE+zviZNNDu1JuAxQm7cpR88V6HPOkVnaIfyso/zK4izihp10qhlfkYa/vSvkrXPw7cctpqdWDSkmp+UPl30wX6FuxAPANh7hE1QtzYNp7JVP621qQekGItOOLFNFbHUYUXP1WcF/CDerhW2+cYerf+MfegWuZrGSqnkPJ2UufOA0rwzN4+syHg+W9bWlf3TCnTW/Jwidn9B0vdFegE/Ff+yB+8NzLLRiF16Hb+efJUmZmRP6qmymxmvu7AoWFpYJCR0sZbQGKRB7x61dTskBixrbzAM848iz4PsBFKOyP4KnskWbgYcawlxQMkEIawbEBD5i6r0GnDh8W1EaMukqzCjnabr9mOpMtyft6q1PwCYFxHRfT9vFW8bBm+ceCXvh6X2JdFJx09Z3T03Tkubwxb1zZeh8mMCzHzhRlD2fUaerWM2pS78TvbzH1fhxyOtv/DLFiGm6nKduESpCkrDjdL+YLrVCJEW+xcjrKaIF3HLJAvDql71u2Ijhe9Umrs1UzySysyE1NvcFj+BUFMSFHk5BTXN6D+5/ZOuSY1WKtGONl71cKHYaKWmHzCm2XcBTdwCNY5ZJ9ybr6CTlrFc3iAM/JiPY48tJxN9XyHxxN1TAxevxBJMmfS7M9X2zFy97JzEGzLhwpZW3LR2bZopSmhTTW2RqqMYzgUbAQlixuh6YrmnKqguz7NQB4SudMPILAnr2JKZ1dyh5BMd+pshoxoztjjYGHz8LFkGT7wwKhdpFanzLly84zEiF4XNLhz/bojvs1zakkwB6k5y30IZr+0qfsjgEqgNXz+Fw1ZQfxiGm822RvoL+oB0oQBbugy850F3sOlw8hIDnsteYMdgVUJDaFjOoi8baLXxF9dYqMLob+gvcg4uAchKiL2zCB
 C7rzqTDO
 rR6Nk+KeYnUL4qEk8NFDcMK5SExZGyBriAaiMyv7Zsjy3VVVyv6EiwTO3P5WoCNWMtb/R7I49EnMxU4mIEUcA+eJ42PvYR24Vkdc+/2qN19gayVUUEUFsXZXuhusR99V9GZZZo9eruvxa6vfKFfaOov4sPZzgMgiaxCJQqZoT/IDgqCjyMG1bSuJ+BJals3AuG+1H7fzaaNqIdnHm03q2yoK5o2ac7/39mLMU0pieN22h65NMUOmv6xWNRoa11oTxQRwZeZ7aht7t3VsHLfs3aTXhDPfh58ro6iEUOupL36sCDAA42ajvG0cfENoWyRdXjxnYnF/cfTekS5SbYqqAwwaILPVs/0JhiDpqMYf+cQ7ueOjZoyeSL6IJIrIfXyJLhzfC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--d4hTvcyUwKyTx7AM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 30, 2026 at 03:33:47PM -0700, Andrew Morton wrote:
> On Fri, 30 Oct 2026 18:14:01 -0400 Sasha Levin <sashal@kernel.org> wrote:

> > Mark, this applies on top of next-20261030 and is meant to be folded into
> > the mm-fixes merge resolution. Next/merge.log says it was resolved using
> > a previous resolution, I think the one from the risc-v/mm conflict on
> > 2026-10-12, which had the same problem (next-20261012 has it too).

> Thanks.  The "mm: Fix page-table teardown during memory hot-remove", v3
> series was problematic, but I now have all four patches lined up in
> Muchun's as-sent order in mm-hotfixes-unstable.  I'll push that in the
> next hour or three.  Then hopefully any -next merge resolution can just
> go away.

I skipped Sasha's fixup on the basis that you'd already handled things.

--d4hTvcyUwKyTx7AM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmro3e0ACgkQJNaLcl1U
h9COuQf+O2VXd86qGVq15jkmyMh4j7Bj5xIAx+eVfhmzlQ45rUKfhDjZ6Pq6h5h+
1TdZGPLr1IJxy/0qf1JJz5fkPGJFAsuzPD9EL8N004bOqyyRkfodbCitEFqElTkF
5uTKNfKdCLxamg7DbokoU8IdYo5nreN53iJJrBuXNL4ENGgeiktDyqayZxBFWmcQ
AdV/7nfbFs49gftjcdI7/YdtwCmgYZaVp/jEKTz5aCnxZ0VCLTj0UvPbI2PViwtY
QVB48svqCofi8vlzR0uaYQnws5+YRCLw3Lva/bnMFftefvg+geRww5pCuH5iTPET
QLo+yXOc8G3jxE0EZGeN7Nj7EIF45A==
=TEHF
-----END PGP SIGNATURE-----

--d4hTvcyUwKyTx7AM--

