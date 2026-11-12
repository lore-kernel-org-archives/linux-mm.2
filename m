Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B21FD606A33A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DxxL4ezP
Received: by kanga.kvack.org (Postfix)
	id B135D6B05B1; Thu, 12 Nov 2026 12:51:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9D786B05B2; Thu, 12 Nov 2026 12:51:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 964986B05B3; Thu, 12 Nov 2026 12:51:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74F316B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:51:51 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 055061C3F88
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:51:51 +0000 (UTC)
X-FDA: 85427210022.13.949C5B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 554014000D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:51:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DxxL4ezP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794505909;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FvCJjk4HmOQgdyN0aiaJqibbKwE92Q6yec0QwycJ7tE=;
	b=o6LwpSTXKad+XsLZKQd/lJ1zH0ucO5VXG3LYCzTkay0VRy8WeN8IlO4n5lCRbelX6ysOVG
	jFSz6DSHTd595xg0r92Vzrl2wCwLQoy3SctJbDvvrN8DRxlmEmo8Yzp3By1HhoaNY3LUok
	g/1pUT2fzrURgdQYIjWt4DcrbOlNGU8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DxxL4ezP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794505909;
	b=YWsP3A82u1sn+i0qrkz8dOD/7D7VnJzueQHV4I2M3sBV9g6kSaX73njFN48mMzw/iSvAkk
	Qw9l1YY+YA9Or5kDz0BFMRF+e648th0ei9ENoWaO6Dc+UsUzirv7Bwnyds68ugs+fgPrma
	d8GJDTBQl9N5EEJWz/4ckOboCe7MxWs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E73445B99;
	Thu, 12 Nov 2026 17:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD09A1F000C6;
	Thu, 12 Nov 2026 17:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794505907;
	bh=FvCJjk4HmOQgdyN0aiaJqibbKwE92Q6yec0QwycJ7tE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DxxL4ezPzXAbO3J1Rmul51iTm+ghaSHaAky9P57UD3Hps2s8kfhx1VDqdTTmOwbYi
	 /bOngA0kqeQnf04nxzHlxNOkQHhVJjUzkFSwpNUllx2fTV8wYnMDQ3cXtrHz7rYdkM
	 kYuG4cosKVZa4Bf/UHebA6vyxSODigpDViHH9wCWSKBhd+q4wFQ3yMIYpUNN5J2Vvt
	 ezSHREmeIFjPQ+vE2JXp2iUKlKrC9KrPnAWgfyDLpKajoMHBGSVl2T4FCWPnQ7+5EQ
	 PmliRr/7SWbNuZAKTfPCRDDKzxrLzbOBRUVXuFDp8CWiJPQvYpZR5IXJPItEoHhk81
	 0PjM1i0Atbtvw==
Message-ID: <sashiko-outbox-211629@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/8] mm/khugepaged: separate out windy folio logic
 from collapse_file
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pedro Falcato" <pfalcato@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Zi Yan" <ziy@nvidia.com>
Cc: "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Kiryl
 Shutsemau" <kas@kernel.org>, linux-mm@kvack.org
In-Reply-To: <20261111175121.1328383-2-pfalcato@suse.de>
References: <20261111175121.1328383-1-pfalcato@suse.de>
 <20261111175121.1328383-2-pfalcato@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 17:51:46 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 554014000D
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: hrb67wft5ggj8q9uuxcfizb8ioqi3yng
X-HE-Tag: 1794505909-239090
X-HE-Meta: U2FsdGVkX1+Aw+PyfK+x6XneVNZ0dhm6RpZF61wGGgAs87fqckOMTXxBTLMPU9tOa0tbw1IGXtx30rRKVrCidZvGM9Vgzu971TjtFWQEg/jxB4LjEg3FedrpoJRMXrDnIGvgPEH2FiX867glyuIi/5pQtEIZRdOJswvrKyILeLQxgthrgQtPoCcfRbXApCmRDIP0lWwOXKfi5A1XnXunchnKlEDnloEEWC04thxwCp8Afp81Aga5qltVQRDZd+See6y3/fxVtkOkMXyY7iqKb6yWshfv4o+HxZNxhvJafA1rT8OXi3N+dBtZKxDnfPJ4vGNDVGXG79JWviKCxSTYfOAjlrMOozoBJvrGqG4hOhJTDVdT9zkM2ktkFKJE3zxbgfGrakr1pIYEMolF0lh664vAqZt/aYMZJ+EkkAk4DCSjudVVhEa7NzPgyXC5JJ893yRiTozSpRgtrh13PBIrljC3Pxg4qfEtWW4iHfg7n5/vsq2A/lzjICszPLRH6ExY4e85oZKkCCTM5Hc1Q3mIRJf8JKHxN3XOuojLupXWnX4huBFJKHx84kkAW5XGnwCVxhBga1snl+eIF2hVyhhI6zXu0Yu4ipIBzR2L2dG7q1zSkjNXzcuHqaZ8KCqKziYWy31VhZd8UEMdQ1SiR7T8ohd8AV3HpucEArl7UWlUDb1Skm5zynoXIqQ8j3u5tZHYJWoxQmWeFx+QZiqfN0PQ+fqjnV+5Dc7xdJ6jSRq2TRI7Cep9RhyyzqLYAEK0oGi7G885I+XWanAOvvOpAsHYLZwtkRV7Ka+dGs7X9CEXEQavwFXoWmbIcCN0N8F9HVVw4TFoVteFCuHSzaXxd9v0U44hmeiy/kPAOO8zR+cCJTZuLAYPk4Plmt7BjsYkXTWsUJM+wtBvALznI+uUIggR4ijhu6PLsUuAfavsEWCwNj5r4P+ZdxJ6QFjYXKBTGt1NLwQPUBOm5FO5I5Jb72k
 EWwkjXy2
 Owd7rPRzEBUA2KvSy06uPFiS5kpcPrPhHUPkDTyvSYXzfB1CmVaToNhOWgjMSIcUtExD494wk9Gkq8tgo1Pq/0OkP9g/8DIbTMT5mC+rdqXqQ5HoxZP+AmxxHIO0nzT7gKDebces6uiks+Uo7YxR8BrZW9L2ZEHeVP9ms84y/MtOzWgU05yFf/G2u7XxogwO8uP71Ao+Ve2kgFCAJVbGiWOdZSba2upFGKeH8Bn83AftW3cjuZlb+QQNi3k1cUlNWjGqglIa5kTyQf43+fPJIJmIWEmo/DnXc5VdKayIhe9mYW8RFEI5mMqqL0zuPDOTtSDOYlmUELZmdPBfRt67KidsqSFfQ4A62p6A/0esGlLrE7s9TKd/QsUWHvGrZW9iozQ0QROq1104/2UyQV2FqAUDXWSfO3yQLAyei3C2QGvxCPPBzZnsn5r8xxiRd1UIu9Ds8FIvv5ofk//T59Dh3KMZjo+AoR40WcUEx6adDw+W7H+/E4bHMc97LouEJfUvxYXAenymaugsx99N2d3IIOsZonyZT6zbAm0DSy43/D8aKOgSW4EhCUngWi6GNwCCY9g4MkQwfJ7t0Orbu6HKBYFX1EBSWvm2a0gbIcGD/r3tMubI=
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
- [Critical] mm/khugepaged: unreleased xa_lock in
  prepare_collapse_file_folio()
- [Low] mm/khugepaged: unused file and end fields in struct
  collapse_file_state
--

commit 4417d51ddf77d1023dd61cf9f5007c13774865df
Author: Pedro Falcato <pfalcato@suse.de>

mm/khugepaged: separate out windy folio logic from collapse_file

This commit factors the per-folio preparation and locking logic out of
collapse_file() into a new prepare_collapse_file_folio() helper and
introduces struct collapse_file_state to pass state.

> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 24eb8281ea3cd..0fe19acf470b7 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2211,6 +2211,105 @@ static void retract_page_tables(struct address_sp=
ace *mapping, pgoff_t pgoff)
>  	i_mmap_unlock_read(mapping);
>  }
> =20
> +struct collapse_file_state {
> +	/* Inputs */
> +	struct address_space *mapping;
> +	struct file *file;
> +	struct xa_state *xas;
> +	/* folio is in-out; preparing might modify it */
> +	struct folio *folio;
> +	/* collapse end index */
> +	const pgoff_t end;
> +	const bool is_shmem : 1;
> +	bool do_readahead : 1;
> +	bool readahead_done : 1;
> +};

[Severity: Low]
This isn't a bug, but the file and end fields in struct collapse_file_state
are initialized in collapse_file() and never read anywhere.

[ ... ]

> +static enum scan_result
> +prepare_collapse_file_folio(pgoff_t index, struct collapse_file_state *s=
tate)
> +{
> +	struct address_space *mapping =3D state->mapping;
> +	enum scan_result result =3D SCAN_SUCCEED;
> +	const bool is_shmem =3D state->is_shmem;
> +	struct folio *folio =3D state->folio;
> +
> +	if (is_shmem) {

[ ... ]

> +	} else {	/* !is_shmem */
> +		if (!folio || xa_is_value(folio)) {
> +			state->do_readahead =3D !state->readahead_done;
> +			result =3D SCAN_FAIL;
> +			goto xa_unlocked;

[ ... ]

> +xa_locked:
> +	xas_unlock_irq(state->xas);
> +xa_unlocked:
> +	state->folio =3D folio;
> +	return result;
> +}

[Severity: Critical]
Does jumping to xa_unlocked instead of xa_locked here return with
state->xas still locked and IRQs disabled when a non-shmem file range has a
missing or shadow page-cache entry?

In collapse_file(), the !SCAN_SUCCEED path also jumps directly to
xa_unlocked and proceeds to rollback:, where it sleeps while atomic and
deadlocks trying to re-acquire mapping->i_pages.xa_lock during readahead
(or returns with xa_lock held and IRQs disabled if readahead already ran).
This regression is later resolved in the series by commit "mm/khugepaged:
factor out page cache folio reading", but breaks bisection here.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111175121.1328=
383-1-pfalcato@suse.de?part=3D1

