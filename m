Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F62C606A6B1
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GGLGm4T3
Received: by kanga.kvack.org (Postfix)
	id E913B6B05BD; Fri, 20 Nov 2026 20:09:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E69F16B05BE; Fri, 20 Nov 2026 20:09:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7E726B05BF; Fri, 20 Nov 2026 20:09:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B4DB36B05BD
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:09:36 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 42287120293
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:36 +0000 (UTC)
X-FDA: 85457343552.29.D78492E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id A96801C0004
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GGLGm4T3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795223374;
	b=xuo5oDV6q0Cnl1W3pWFGms8xm1IHsV/JhVl+FTz9bAebZ2LVnCMuVuVfIf+YabVQOCxjpc
	yEBQWPpcvuKJgVh1nCxEDiH4qHIMrTvWiPeIbaGyna9gOvGlpPbz/kF+RuMSfxb7JsR2FE
	WaBsAnnphc52rixm+oMd+z3wAA7PJV4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795223374;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4GOXXmihJlilmY7lm+xLL2aQiZzUZJG4UuRDe+t8TNo=;
	b=hzVS+fUHW7CbFUKZIUeVSOlTDSoq/i6ihJjrcj5J2nKQy//kPJfAKIDCNoUXzuL36L8eGw
	9P+EGO8CDPb/28dO4M+Ilb+VcAY1EdzobYH0UZzqha/OVbmR5p7516H4Jkw3IYL6gu9K9K
	2n0SYIWKGJA4INZnkcu0M24iI+tlxxk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GGLGm4T3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 41696612FF;
	Sat, 21 Nov 2026 01:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6381B1F000D8;
	Sat, 21 Nov 2026 01:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795223373;
	bh=4GOXXmihJlilmY7lm+xLL2aQiZzUZJG4UuRDe+t8TNo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GGLGm4T3V2zAw1kjBhDLAALFD+F6Cb+/n93wB/mHIwZe/3+Y7dODx9bsjA6SC1fmq
	 aebfMzzZ2iqjALuVTjcdjypk3p0+QUXlxdR0KZOXJAOY3G4IHL5PTTr6FjN1u/lCGo
	 oVks/el44y2Z6PVb4ybYkA9jnRHubUr1VPSOKiItSav01zovv2H0q935u00tnJKJAD
	 d01eUrkHUm4rBBhUgf2gJ7tSMqnlN2qfyye1EQAFqRyHqX3pKV2EclD5dmQHTuJKGJ
	 meTPuXcsju4sKdZliKufXWWO/XoAJM3vLvA6QabcGuxiwnt4AuVvhd/BtOtBycsRKt
	 CTTk1KuFIhKPQ==
Message-ID: <sashiko-outbox-226475@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 11/25] mm: Migrate user pages into PISA
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luigi Rizzo" <lrizzo@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Joerg Roedel" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin
 Murphy" <robin.murphy@arm.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>, "Jens
 Axboe" <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, "Luigi Rizzo" <rizzo.unipi@gmail.com>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Zi
 Yan" <ziy@nvidia.com>, "Harry Yoo" <harry@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Hao
 Li" <hao.li@linux.dev>, "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Jann
 Horn" <jannh@google.com>, "Catalin Marinas" <catalin.marinas@arm.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Simon
 Horman" <horms@kernel.org>, "Jesper Dangaard Brouer" <hawk@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Willem de Bruijn" <willemb@google.com>, "Kuniyuki
 Iwashima" <kuniyu@google.com>, "Joshua Washington" <joshwash@google.com>, "Harshitha
 Ramamurthy" <hramamurthy@google.com>, "Alexander Lobakin" <aleksander.lobakin@intel.com>, "Christoph
 Hellwig" <hch@lst.de>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Dragos Tatulea" <dtatulea@nvidia.com>, "Naman
 Gulati" <namangulati@google.com>, "Pranjal Shrivastava" <praan@google.com>, "Mostafa
 Saleh" <smostafa@google.com>, "Randy Dunlap" <rdunlap@infradead.org>, linux-mm@kvack.org
In-Reply-To: <20261120010655.467825-12-lrizzo@google.com>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
 <20261120010655.467825-12-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 01:09:30 +0000
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A96801C0004
X-Rspam-User:
X-Stat-Signature: za3dbdzwuyyruigafii4wpnhxi9qmdsz
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795223374-544839
X-HE-Meta: U2FsdGVkX199S9oUrXVUc1KgwLRdqGAFDF40YKLYw8wVQpKQVJoiyQPiXAukly37R3MxbnK5I3jHAbUNyg7JW1bcwbxFwXxLlRZTXIaNxSufzyjvidpHbnesB31W+dCLmHoKZkdtwEeLDA04csx8i3mruetccfaBJzjx9DIWVWLt71W+oeWjcp7y1fqOY5neQdd9zniYLdw5Ke5buPOm5x3TcSOHAVMI9MlmpJyc3jBO1hZolqvJ8H1ZJYbY7lqLYGQxeYXYKdK+rW3bPvYHkASyGckVFkXplctYPAsZAug2cV7HW4yRod38phaSh2suLS8v/qBY13dbSyn1WNWvFgN6yMeuNqdkDFjllOTfSC+TqErDTK5MWLybTA8Nsr5oOzLh1PcH3ArwlfEQYitWG1q9eCToHr/IziPkfS3Yc6f83u6UYYTP/iyvHQz0W47/xoRZeDcoalFNTiPP6ADv8i3XdIx889Z8G7U1hunG96jD7ab/2aXEnDSTaDNSGW6y9cY/W0/lCTcAakSDT62WkXKAoZo5wyv/sh/9oXkUkTeZG1DwJDFRR1orsjHk5LKBt/vhr+4SprYXmYB9atLDK2Sgd6VlVYFBAWIKdClM8sCw66VESondfo7j4QT8jLYCpZbpxlSCX2jMoB/X/D3/+HCkffviOzPrWUBjUlhnUBfdOprI71W36XKvzLBBeRSqTXn0s/fBZUAFHqNcylP6pnpxAAGW8GfmYSDoexkX2VHWmBLcoE1Jmzwcvj2HC5Ftd+C8Y8oG6QvxxILhGmpGXvsWhLv8cIuA14gpdXlmZa8NUmxci9irxk7DqUKkHAHzMcjDfBCPLMywi1c/4O7fCgHfkERySinTAuiqnoGZtlugWddA9Kf4Q89G71edza4sAKBsKtjwytcMgvvogIYS/9etjcPxxtWfUlLkAzvFsF6NVRRHnSNfMNneqDPjwRKfQt31X5382OQnM1zi9yJ
 xzaXKreV
 AXBzpdfuD1Fmknu9fAQtclJIUJ+m6/UqACc0HohMDyh2+4aM/L7DtILmVAfhjVqBi8jz1vY3dBgKItbcXJdYQ5PoXGDLgsN3dvQ8D7yhEJ26/y61X/jLy3ZUyNkcOvJ5G0yXuM/zMv2E5Rf/01PakP4ujqmUBQs5RZQC0BsR9WnBc/h3ASYNP4sGtYH/+2Dj52yHBTZ1f36KFDj8btRXlXU8T+jWUdsvBOg9UZWKMHhaku+dTZsYR4oEJ91WEtvnqq0hnJBlJfLCs4wWKJ/pYHn84jL6kRK8ap+qKEXSqqAHh8VDFXrGL/0KNhhLCtZg13kh9Z78MrHv+wEbGRrNfBO8yMRq2MbIr2qvpslrjkEDj0fC1zQnUzM0v/r+GIiJy7/QJD4CTOc/efKarEvWmQse/easklY62gPErG85V50JtwL5Cd7nS2DU7UHes1ha2z9Tu/n+gn4fy4pLdsDpqbfaMDHUyvf/wTbXUKnt98uHgvTLuD8Aj85m7q7estsm/ShjtrJLcsWJymY6KUnsJg8AcWZi8TRSjp8TNxbp73ufnymDXs7CSNFfI8NPL9WopI50UD3lpFoqQxC238yzgDFfGl+jm5lWjlQpZPrIYE0gDbifZT9PU8940B+WhcpGAW7KFyHX9KJIUucTAvbiMKXYqkX7To7thG5ta/Yohc8wn42itcqEpW7DwuZoj54tB6PrSRRemmaQklkg1FExxSOkGxiGexaHH06l8AqjWV+Uk8FsH+FuwZKGBd2vzdbNx8MTlNqWV0+/eXujKj6/TCaXsrBFN3zb/UhvpNiQaPEjfYp0OFeoZ5g27zlTgeK1owfDeITzMlNhFkDsuw5wIBE+M445BukkwnVCm7ha6BUlIz9gy75XCT5RhhanQU0kL7Ri7
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
- [Low] mm: shift overflow on unclamped pisa_user_max_pages in
  pisa_user_budget()
- [Low] mm: redundant lru_add_drain() on large folios in
  pisa_upgrade_user_pages()
--

commit 0013c02c237d37de8c598b2b6ae3c55e334c3521
Author: Luigi Rizzo <lrizzo@google.com>

mm: Migrate user pages into PISA

This commit adds mm/pisa-user.c to migrate private anonymous user pages
into per-node PISA allocators via madvise(MADV_PISA) / MADV_NOPISA and
pisa_upgrade_user_pages(), splitting large anonymous folios to order 0
without remapping zero-filled subpages to the shared zeropage.

> diff --git a/mm/pisa-user.c b/mm/pisa-user.c
> new file mode 100644
> index 0000000000000..6c3efaee4ecda
> --- /dev/null
> +++ b/mm/pisa-user.c
> @@ -0,0 +1,394 @@

[ ... ]

> +static int pisa_user_max_set(const char *val, const struct kernel_param =
*kp)
> +{
> +	unsigned long max_pages;
> +	int ret;
> +
> +	ret =3D kstrtoul(val, 0, &max_pages);
> +	if (ret)
> +		return ret;
> +	WRITE_ONCE(pisa_user_max_pages, max_pages);
> +	if (!max_pages) {
> +		static_branch_disable(&pisa_user_key);
> +	} else if (pisa_nodes[first_memory_node].pa[0][0] && pisa_user_init()) {
> +		WRITE_ONCE(pisa_user_max_pages, 0);
> +		return -ENOMEM;
> +	}
> +	return 0;
> +}

[ ... ]

> +/* Pages that can still be moved in before reaching pisa.user_max_pages.=
 */
> +static long pisa_user_budget(void)
> +{
> +	return (long)((READ_ONCE(pisa_user_max_pages) << PISA_ORDER) - pisa_use=
r_in_use());
> +}

[Severity: Low]
Can READ_ONCE(pisa_user_max_pages) << PISA_ORDER overflow in
pisa_user_budget()?

pisa_user_max_set() stores max_pages without clamping it.  If an
administrator writes a large value such as ULONG_MAX to
pisa.user_max_pages, left-shifting by PISA_ORDER wraps or overflows the
signed long cast, producing a non-positive budget that causes
pisa_madvise() and pisa_upgrade_user_pages() to skip all user page
migrations into PISA.

[ ... ]

> +bool pisa_upgrade_user_pages(struct iov_iter *iter, struct page **pages,
> +			     size_t size, size_t offset)
> +{

[ ... ]

> +	for (unsigned int i =3D 0; i < nr; i++) {
> +		struct folio *folio =3D page_folio(pages[i]);
> +		unsigned int refs =3D 0;
> +
> +		if (!pisa_user_want(folio, true))
> +			continue;
> +		/* Drain per-CPU LRU batches once so freshly faulted folios can be iso=
lated. */
> +		if (!drained && !folio_test_lru(folio)) {
> +			lru_add_drain();
> +			drained =3D true;
> +		}
> +		if (!folio_test_lru(folio))
> +			continue;
> +		for (unsigned int j =3D 0; j < nr; j++)
> +			refs +=3D page_folio(pages[j]) =3D=3D folio;
> +		/* The references from iov_iter_get_pages2() are expected. */
> +		if (folio_maybe_dma_pinned(folio) || pisa_user_busy(folio, refs))
> +			continue;
> +		if (isolate_folio_to_list(folio, &list))
> +			list_move_tail(&folio->lru, &list);
> +	}

[Severity: Low]
Does isolating a large folio on its first subpage trigger an unnecessary
lru_add_drain() on its second subpage?

When pages[] contains multiple subpages of the same large folio,
isolate_folio_to_list() clears PG_lru on the first subpage.  On the next
subpage of that folio, !folio_test_lru(folio) is true and calls
lru_add_drain() even though the folio was already on the LRU and has just
been isolated.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120010655.4678=
25-1-lrizzo@google.com?part=3D11

