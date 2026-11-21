Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74326606A338
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 13:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KG0iMc5H
Received: by kanga.kvack.org (Postfix)
	id 8E7706B05B1; Sat, 21 Nov 2026 08:12:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898546B05B2; Sat, 21 Nov 2026 08:12:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7876E6B05B3; Sat, 21 Nov 2026 08:12:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 444606B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:12:27 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB571804EB
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:12:26 +0000 (UTC)
X-FDA: 85459165092.30.E4E5858
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id EAC5EC0005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:12:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KG0iMc5H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795266745;
	b=kYJO3+DuqmcM5NflxDPpSs2nIwtkPv0QnIn0MTzpYYvzyuEHzFG6D22c9hR5hHGihhNqb8
	6GQ8TFgB3nwGXtX7wWBltKK4VDe2PsmIcgvMCE+bXnHsr7K/ilFUioLZyVgy2ZcjuIOxZ5
	r+UI4enKyZwRnW+nXS8mat8kMm2KlCI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795266745;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9xI3BBogLqWlxFnl/FtWie5xgI/y1nokptNlOQ8nCq0=;
	b=1DUD8BwVeq3YnHrFHi8CwVD1r37xNl3donTLCHWxi7nJgWT+SphWuxTm79UZpZdNxyJxeE
	+TF+y41GwUW3g2pxN2RAHLdYG8yOrcxvjqX1WJwTaIZ1Ubd/tctDMIXpRcfOrKduvN1wcm
	pQSqJz4jiem/G30OMecSdm8i+eTVe+U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KG0iMc5H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2397F404DB;
	Sat, 21 Nov 2026 13:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B491F000C4;
	Sat, 21 Nov 2026 13:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795266744;
	bh=9xI3BBogLqWlxFnl/FtWie5xgI/y1nokptNlOQ8nCq0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KG0iMc5HZpwOXdD9KfctIKyr+hHYLMFltq6ONQHduV5k2ACeU5Ercbr8a6gJCslc2
	 cc+20xM3qL8OqHt3aOZtueupWL9CIoJYr4cC9ggDbMvLLYbRTuoNwnbAZJdhUNf2JM
	 V0G6aZ4a1+p+EB7hzGJ/2730wYsUHQgxjmumCOMl33jOgFjaD5EUi7m3gu/7najYyp
	 ro0HliaA9E1pX8CzN+0wnhUrLkzUqgMRY4cHzyqQeWUbHWXeFPZKwcCE+92SME0KZd
	 Mh3KJEDTE8tMCSOhDZhY8RVqS+stD7OFOR2AWze6E/JJY2RO0m0ZdpVzGEFopCbFrT
	 NpMRZ6v7jyJ6Q==
Message-ID: <sashiko-outbox-227047@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 07/12] rust: xarray: add entry API
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andreas Hindborg" <a.hindborg@kernel.org>, "Tamir Duberstein" <tamird@kernel.org>, "Miguel
 Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?b?QmrDtnJuIFJveSBCYXJvbg==?= <bjorn3_gh@protonmail.com>, "Benno
 Lossin" <lossin@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>, "Trevor
 Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>, "Daniel
 Almeida" <daniel.almeida@collabora.com>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?b?T251ciDDlnprYW4=?= <work@onurozkan.dev>, "Matthew Wilcox" <willy@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Harry
 Yoo" <harry@kernel.org>, "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org
In-Reply-To: <20261120-xarray-entry-send-v6-7-1f69d7385f70@kernel.org>
References: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
 <20261120-xarray-entry-send-v6-7-1f69d7385f70@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 13:12:22 +0000
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EAC5EC0005
X-Stat-Signature: rmj7b36r4f1p9crxp8j6fsgb4udh7zax
X-HE-Tag: 1795266744-546146
X-HE-Meta: U2FsdGVkX18NP0f0TOfDc8IvxgOO0+wZR4kiH6qOj6vQUAYUnQM2KEK8/7HvqMtTOkDGcSWu9FVcNHqZ/XQ9k+iz94mQDL9X4eRjnL+G+R7Y8POKRd96j1Z4YId601VZLZonlka8AhBh4Z9K+AVBSrZ0+Ag2oVbz7+mR+MLgSEfJsFk/UiwjMRygRzKo3DCOQfQOhqba8Xn94FZoX5ftAo8ErlJ+X8ZIWwkkHkmWOs3QraayU0Ds/WmkgGW4xeAVdKWY6kB8Ic7tGp9OYedqORJj8q8onNCZp9LSZlupYXUTHwLiyUKRk/TMCh77eGO3J7mwszMVOjf3qMsSxuhKmwyX9XnJBZnPAavJr0hbcl+BgnMA7cmDyoWPOZMIeKsKbsl0XqGTvgXoL3W7d9m78sBbyjrQnHO4Nrs/TKhoSwX0v+pllV+IAu8Y7f5Tj8z8COyuJQa2THoQUpDPI3AKH2OHGUL9+mqmahJagGFjBt+vXY3gaVE67yl65igEsU6/L1ad8jk5DD/ihBn7usmoE4/xNw94C+iNAw1pksjdRlEBu6FOf0evuoG+xKY9Wz1pS31EgazT80GCwLAL0DZLgjA+iFHfgD+f0WY1LPYqXHlHlGzmpzsNRJd361svG1SYepF8LAFcs79Sa+Tf5mxXlbFD3x8nxUCi2OeIk911/BqYGRXMiFj3IUA3MZDHKQ7BCsB/k6XNKgM1pIiidibRgAEy9+e+Cv1/rc7pXmdHPQZ5G5Y3gnEsxYPyz7cM0twWl13NCJ7mOYRyfgOfYo8vnzmZx+m3QizaP1KZSvvffiA9P8V74oITVXE5WrAHjb+8q58DzD2rCVYz6fLQi/NsvyaHpU0qpxPngDRpvHZS2UUHL0wIMd1pMJP4CC+yuM22iNicEI9HAKYkxWA+UgD9ipFiUCil60kO0Zh9dh6S+fJJ2P5O5GHhNQB2NQ79gpqafUPFWR70pc51rhCVNBS
 hd9edH8M
 idSGvDYoYj3Gl/oUjTn4Y1ynBbsCYsKGvczWdY2JugFGatVgkzjyWGn7nKgZD8Aqz/8EGFxlsQnh4/Pq56iNoW8UB94BIV5YVejCzId5Mdu0Y9HtWn9GamS9MBtO5BWqmYdckYKLKrDWKKqrO0JryAsaDHBd94XBSL4lExVI8T+O51sCnxwRQZfP9ukyyp9eXbaiyeATv3Uijn2x8HfzV/0qjDhvLx0Bq2wRfE7qd5ZKweDzVxsCDc7YnqgzGNVS77OYaWrpRnOVW9VpzvUr9uNpNMpNBeybCWQJUGlDyFIPn/DhxelyjN8/lGRnJ3phqMUugmQCaCqtlsgEtXSiI6BLqh/giVhEap4U0FAcmrW07z4qPtyiH1hn8rQsiJwKcoWmC7uvV2KMabilk1/7pRNDMeXzqkeLAYl3q4VUqUVgApTH+WGHWDetYceuG7uqqPNNIQz5/HQCXXh/OrVOxUodXxT93JS6Fx9f/PkB9WRNMdNP4NLTlGkBvDSZMfdMFNNnF8BdwlDOa+czwIAJd6CAVktGHKbpswC4Hrwb7G5/pGTRUJthFYZWSwJ7hxCEpoJBfBi14REexe76gFPJbCdddWy0o6Ysi72IkKpiCZcyCrNW1CEYcgOojb6V3ZJREPB+MA0FaNClIWsrSlQ7HVwSkK7kdb65Dxh6YC07rbb7x4uj/l/63gIdR56SRyrl+moxrKJCkSj3bIvHiLvPbtZ4TFmheg9zC+IVCgGZSJK/zMrXrq9NZ1nVpfzYL8ryU5KEFhalXJN1h2yUkS3TdS+5Bua0qXS9DzvVgrpE6YKrUs8Xu+S9Q7grj2Ka+OjUfNWti
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
- [Medium] rust: xarray: OccupiedEntry deref() and deref_mut() use Guard
  borrow lifetime
- [Low] rust: xarray: Guard::entry() discards walked XArrayState from
  load()
- [Low] rust: xarray: inaccurate doc comments and missing
  Guard::insert_entry()
--

commit 6b0e265e85674545670123d4c157941bef632ae4
Author: Andreas Hindborg <a.hindborg@kernel.org>

rust: xarray: add entry API

This commit adds an Entry API (Entry, VacantEntry, and OccupiedEntry) to
the Rust XArray abstraction using the xas_* state operations.

> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> index 07ec08223fbd2..3ff94c05a15a1 100644
> --- a/rust/kernel/xarray.rs
> +++ b/rust/kernel/xarray.rs
[ ... ]
> @@ -251,6 +257,35 @@ pub fn get_mut(&mut self, index: usize) -> Option<T:=
:BorrowedMut<'_>> {
>          Some(unsafe { T::borrow_mut(ptr.as_ptr()) })
>      }
> =20
> +    /// Gets an entry for the specified index, which can be vacant or oc=
cupied.
[ ... ]
> +    pub fn entry<'b>(&'b mut self, index: usize) -> Entry<'a, 'b, T> {
> +        match self.load(index) {
> +            None =3D> Entry::Vacant(VacantEntry::new(self, index)),
> +            Some(ptr) =3D> Entry::Occupied(OccupiedEntry::new(self, inde=
x, ptr)),
> +        }
> +    }

[Severity: Low]
Does Guard::entry() discard the walked XArrayState from self.load(index)
and force a second tree walk on subsequent entry operations?

self.load(index) constructs a temporary XArrayState, walks the tree via
xas_load(), and drops that state on return.  VacantEntry::new() and
OccupiedEntry::new() then construct a fresh XArrayState with xa_node reset
to XAS_RESTART, so a later insert(), replace(), or remove() walks the tree
from the root again.  Constructing a single XArrayState in Guard::entry(),
calling state.load(), and passing that state into VacantEntry or
OccupiedEntry would preserve the positioned cursor.

> diff --git a/rust/kernel/xarray/entry.rs b/rust/kernel/xarray/entry.rs
> new file mode 100644
> index 0000000000000..e2f01a49c55e0
> --- /dev/null
> +++ b/rust/kernel/xarray/entry.rs
[ ... ]
> +    /// Inserts a value into this vacant entry.
> +    ///
> +    /// Returns a reference to the newly inserted value.
> +    ///
> +    /// - This method will fail if the nodes on the path to the index
> +    ///   represented by this entry are not present in the XArray.
> +    /// - This method will not drop the XArray lock.
[ ... ]
> +    /// Swaps the value in this entry with the provided value.
> +    ///
> +    /// Returns the old value that was in the entry.
[ ... ]
> +    pub fn swap<U>(&mut self, other: &mut U)
> +    where
> +        T: ForeignOwnable<Borrowed<'b> =3D &'b U, BorrowedMut<'b> =3D &'=
b mut U> + 'b,
> +        U: 'b,
> +    {
> +        use core::ops::DerefMut;
> +        core::mem::swap(self.deref_mut(), other);
> +    }
> +}

[Severity: Low]
This isn't a bug, but a few documentation comments do not match the
implementation:

VacantEntry::insert() and VacantEntry::insert_entry() say they fail if the
nodes on the path to the index are not present, whereas xas_store()
allocates missing nodes with GFP_NOWAIT and only fails if that allocation
fails.

OccupiedEntry::swap() says it returns the old value, but it swaps in place
with other and returns ().

Also, the commit message mentions Guard::insert_entry, which is not added
until commit "rust: xarray: add preload API" later in this series.

> +impl<'a, 'b, T, U> core::ops::Deref for OccupiedEntry<'a, 'b, T>
> +where
> +    T: ForeignOwnable<Borrowed<'b> =3D &'b U, BorrowedMut<'b> =3D &'b mu=
t U> + 'b,
> +    U: 'b,
> +{
> +    type Target =3D U;
> +
> +    #[inline]
> +    fn deref(&self) -> &Self::Target {
> +        // SAFETY: `ptr` came from `T::into_foreign`.
> +        unsafe { T::borrow(self.ptr.as_ptr()) }
> +    }
> +}
> +
> +impl<'a, 'b, T, U> core::ops::DerefMut for OccupiedEntry<'a, 'b, T>
> +where
> +    T: ForeignOwnable<Borrowed<'b> =3D &'b U, BorrowedMut<'b> =3D &'b mu=
t U> + 'b,
> +    U: 'b,
> +{
> +    #[inline]
> +    fn deref_mut(&mut self) -> &mut Self::Target {
> +        // SAFETY: `ptr` came from `T::into_foreign`.
> +        unsafe { T::borrow_mut(self.ptr.as_ptr()) }
> +    }
> +}

[Severity: Medium]
Do OccupiedEntry::deref() and OccupiedEntry::deref_mut() violate the
ForeignOwnable::borrow() and ForeignOwnable::borrow_mut() safety contracts
by instantiating them with the Guard borrow lifetime 'b instead of the
lifetime of &self or &mut self?

Because the where-clauses only constrain T::Borrowed<'b> =3D &'b U and
T::BorrowedMut<'b> =3D &'b mut U for the fixed outer lifetime 'b, calling
T::borrow() or T::borrow_mut() here produces a borrow for the entire Guard
borrow lifetime 'b before reborrowing it for &self or &mut self.
ForeignOwnable::borrow_mut<'a>() requires that 'a not overlap with the
lifetime of any other call to borrow() or borrow_mut() on the same object,
and both methods require that any call to from_foreign() happen after 'a
ends.  Dereferencing an OccupiedEntry (for example in OccupiedEntry::swap())
and then dereferencing it again or calling OccupiedEntry::insert() or
OccupiedEntry::remove() creates overlapping 'b borrows or runs
T::from_foreign() while 'b is still active.

In addition, requiring BorrowedMut<'b> =3D &'b mut U on the Deref
implementation prevents shared dereferencing for ForeignOwnable types such
as Arc or ARef that do not yield &mut U from BorrowedMut.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-xarray-ent=
ry-send-v6-0-1f69d7385f70@kernel.org?part=3D7

