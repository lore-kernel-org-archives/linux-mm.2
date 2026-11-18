Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D594C606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bTyD3qdz
Received: by kanga.kvack.org (Postfix)
	id 1CA386B05D9; Wed, 18 Nov 2026 18:36:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1280D6B061F; Wed, 18 Nov 2026 18:36:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE2D66B064E; Wed, 18 Nov 2026 18:36:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B36ED6B064C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:36:29 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 311D2A83D6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:36:29 +0000 (UTC)
X-FDA: 85449851298.18.C5C90C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 911AE140009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:36:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bTyD3qdz;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795044987;
	b=0WD3ldp0MXskXpK5UFe/O3XzJdJNqhMHNq/0ylsxy5NJByRFS5sgGMj2VUO+GWFeg/+lVi
	sNl3mt5Fqjy2b0QqewkGziy9ofBC1rXMEG4vixEUwDfoa9KkKRb+RTdaSffA9rNnf7H/M7
	f7ykdzKE2snXdVX4ULH5VKbvi5crEWI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795044987;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=17dXBTLiSfOppuF+1kPe+RfIj6MI5iwybO6b3JQqjb4=;
	b=j5I4cTa8Myzz6kjNl9GlrlcjjEgSjXeJrpJcpESrjCQ0jJOkN0hdyhbDkWwRoYifRD/CVu
	z5FYLLYcylZhYjh7LyKfWnFOX3OO/6b8spnVlYIQKpHwMq8RppfomT6Ikl5Mjvu0CbfKzi
	vP+EImNAWDqWoj3sYAszPWQFgqstFAM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bTyD3qdz;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 260E8642A7;
	Wed, 18 Nov 2026 23:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0053D1F000C4;
	Wed, 18 Nov 2026 23:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795044986;
	bh=17dXBTLiSfOppuF+1kPe+RfIj6MI5iwybO6b3JQqjb4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bTyD3qdzDg/cV2fL7Aweo2cN/CV1qIGsGTkb9tqs66xLKvRgXVwGpq0gNyb4fN13v
	 AG9e5b1wQEVnhsttBaW7/pgIbCysjCO8rbaavDFSFQSkkds5PwGHYWH1DjB27EGARS
	 nj90TkJhxeFWMuF/lYghDHnPzOgzCLBqlO5RvvqJb61NGqXa6Bpu/b0RjXQmZzjYCP
	 zsdeUu24H9S6Td8SHdQwf6WElAE0/8aJQ2RvwCvxoPzl+GA/SAXkwTIGJU+48LYL5J
	 XEo/Buplxrqsc4qPYdTynoTM9XgBURei1gfS4wMnxy1hHc0cNKIMznJ/bv/Y59j2+M
	 kcfOIhEusLj3A==
Message-ID: <sashiko-outbox-222198@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] rust: block: add rbrd, a RAM backed block driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vitaly Wool" <vitaly.wool@konsulko.se>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Jens
 Axboe" <axboe@kernel.dk>, "Miguel Ojeda" <ojeda@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>
Cc: "Boqun Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?b?QmrDtnJuIFJveSBCYXJvbg==?= <bjorn3_gh@protonmail.com>, "Benno
 Lossin" <lossin@kernel.org>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, "Daniel Almeida" <daniel.almeida@collabora.com>, "Tamir
 Duberstein" <tamird@kernel.org>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?b?T251ciDDlnprYW4=?= <work@onurozkan.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R . Howlett" <liam@infradead.org>, linux-mm@kvack.org
In-Reply-To: <20261117233211.3137168-4-vitaly.wool@konsulko.se>
References: <20261117233211.3137168-1-vitaly.wool@konsulko.se>
 <20261117233211.3137168-4-vitaly.wool@konsulko.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 23:36:25 +0000
X-Stat-Signature: sg8xgb4hzeu8ckwrsgwy6cxnshd8cbyn
X-Rspamd-Queue-Id: 911AE140009
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795044987-685850
X-HE-Meta: U2FsdGVkX19wuO5viA0DnGcJ++3ajVuKQeqhWSiu5LqrT5QhCYII5/l0hWFjlEPcTI/7a/jHo2gyRqo6gqW5DMC0tEhWKiRGk8/QfhPOZjP67B8/q1KYC/2KPwdlDcmsxSYMI2/x4aGQ4jkMaf/QhgGdzFuiLOr+5Cf3U0MPzcUO9lt4qk91NFC2zch11OCbMOKqeG6ooeJnK+J+qPCV8xcWh4bL44aBZTpLWhFpwnV0muV3bqvjZNv6NRCD40qk0CV+H7jyqbT/FLKEhAeudPIbDOXyiQaNs/bi3iTF5bBiP8xwS2a+njNlig9TSxfk4lVyKsABl1JcphLupz5vlBLzjbWFwGGCgEpzqmfOfe+AUvw+V52+w+fH+YDhKMYFhDbBRlEeXxqE8lpXcagAUDROU32LasaCKoXpoSKlrxjx7n42AaXm4kBoVTntP0SJBy3Zj9hdFNOKdGN9t9v+8vsCAJCDi5aaeOmN4QArydbtKn/ZrpZbxXt/5yYO64iKpmm4X/1au/kZgLEgthmEEBl5k2ZDkj97uEEg/eyig5YfgmdaFeam6MXoUwdku0ORFm+xIKBEnoVwVARhPlsP6Abgak5UXihCRDJmSxQwE8CFDM+bXBxaZynl0rQWhLrC8JRlhAuWtpOfVawEGzdt61+WZseQMncCaJgXW2oS+yEBxmiPjifEJCdcVwDxUzSjstbGH4tOaAHRaC7BDYtLdhTI6fWnqRttXMHbFJ7J+EEH59YUN8gsHro+iPk5XUCihVarYMdeDwto9vOS8f8Tu4LiePE6vRC3ZAHMINC28RxtABzB21vri2vb+8GTGhBLW/bhWufyYrmIOkuH/96j8hUNePCfJPvT0Yu17hikBhgSGRuvwOzB94zMUL1cKuAd/yq/lMB8Sgwg1kxOmi9VSDp0px5uuXXGQNgKS77dj58XxKkDpjguSjhWVgJEr74wB4EkA49+K/lN7dTcP21
 WyA2s4in
 /5XhmZnsgoto6F98JudTJf/V3jME61OlFaNGNS/6HwCSEHcPrN0A6OjhLgPk3Lzv3iBPvuFs9KNq+meuhYPa4UcSeSWQnqquOYq8laoHsYkgXn8Kk/td5KU16Jdzpx1IsD5uO75UpvndLxyYH52yau/BZzO/lCW4SbbDtmtms3z1tWac5EzWYc74MW9m2qC8YddezRwl5Ut2mRoIF+Xvt7yIvVDVASPK5f6TSynf5bNQ7VidzylDCK++rKOu/S7Z1Smp9k61FX51z2xXq+Rwg5YZd9UJj1Go0vZjHitixT0WE8zp3m+v7JDIUQIMGqstOfHo2yJi5h5xY4tAQglNDEC48NvbL1mOBVMp6fRwBqsO3GY0pbTpmCZ8mTC/MXYKpQOHRhNXn4bbd/2oUNoG0xMZUf+EQ9cyVY9Nh2dYSOJwQ5vQwkG6LQr5tRwVdtq/ZLoxOl05vKi6iH0qKsMLc/XKGXWZB3ZU5R9C6FyiwU+u+upMBhhu9SsTZcguldy/Ome0q+QodTc4fKeEnHBpgJULgkEJ71cf9D+79TA8OGtKC9CHsyh8VLD9I74B619Waksu0Xof3152G46truKf/L1CPm1jiUjwItL0RfyLPoKXDyPQWSO+lGy2ZMd5G1qS1itoZdR/xhBcYfrHxVGj3ZoGhexxLtqpMmYR2lkujnguj//bdmOn+eU3GR6rDNk/BHeQ+iz3tMV1Lgp6VtTc6G88FTQ==
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
- [Medium] rbrd: dropping speculative page in lookup_page() calls
  __free_pages()
- [Medium] rbrd: lookup_page() returns None instead of retrying on
  try_get_raw() failure
- [Low] rbrd: Kbuild module name rbrd_mod mismatches module! macro name
  rbrd
--

commit b57d882ab6ffa2969530912dd82ffe3996588b30
Author: Vitaly Wool <vitaly.wool@konsulko.se>

rust: block: add rbrd, a RAM backed block driver

This commit adds a RAM-backed block device driver in Rust that allocates
backing pages on first write, tracks them in a flat array of atomic
pointers, and exposes device configuration through configfs.

> diff --git a/drivers/block/rbrd/Makefile b/drivers/block/rbrd/Makefile
> new file mode 100644
> index 0000000000000..b5e0c10b4beaf
> --- /dev/null
> +++ b/drivers/block/rbrd/Makefile
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_BLK_DEV_RUST_RAM) +=3D rbrd_mod.o
> +rbrd_mod-y :=3D rbrd.o

[Severity: Low]
Does naming the Kbuild target rbrd_mod.o mismatch the module! declaration
in drivers/block/rbrd/rbrd.rs, which sets name: "rbrd"?

That sets KBUILD_MODNAME to rbrd_mod and RUST_MODFILE to
drivers/block/rbrd/rbrd_mod, so loadable builds produce rbrd_mod.ko while
built-in builds emit .modinfo entries prefixed with rbrd. that do not match
the rbrd_mod name recorded in modules.builtin.

> diff --git a/drivers/block/rbrd/rbrd.rs b/drivers/block/rbrd/rbrd.rs
> new file mode 100644
> index 0000000000000..e5e6981725074
> --- /dev/null
> +++ b/drivers/block/rbrd/rbrd.rs

[ ... ]

> +    fn lookup_page(&self, index: usize) -> Option<Page> {
> +        let slot =3D self.pages.slot(index)?;
> +
> +        loop {
> +            let ptr =3D NonNull::new(slot.load(Acquire))?;
> +
> +            // SAFETY: Every non-null pointer stored in a slot came from
> +            // `Page::into_raw`, i.e. is a `struct page` pointer; `struc=
t page`
> +            // objects are never freed or reused for anything else, so `=
ptr`
> +            // always points at a valid one, whether or not it is (still)
> +            // actually owned by this slot.
> +            let Some(page) =3D (unsafe { Page::try_get_raw(ptr) }) else {
> +                // The page's last reference was already dropped concurr=
ently.
> +                return None;
> +            };

[Severity: Medium]
Should lookup_page() continue the loop instead of returning None when
Page::try_get_raw(ptr) fails?

CPU0                      CPU1                      CPU2
lookup_page(index)
  ptr =3D slot.load()
                          discard()
                            slot.xchg(null)
                            drop(page1)
                                                    try_insert_page(index)
                                                      slot.cmpxchg(null, pa=
ge2)
  Page::try_get_raw(ptr)
    -> None
  return None  <-- misses page2 in slot

If page1 is discarded and page2 is inserted into the same slot before CPU0
calls Page::try_get_raw(ptr), lookup_page() returns None even though the
slot holds page2.  read_chunk() then zeroes the buffer instead of reading
page2, and write_chunk() calls try_insert_page() and performs an extra
GFP_NOWAIT page allocation that can fail with ENOMEM.

> +
> +            if slot.load(Relaxed) =3D=3D ptr.as_ptr() {
> +                return Some(page);
> +            }
> +
> +            // The slot was concurrently emptied, or now holds a differe=
nt
> +            // page; `page` is not (or no longer) ours to use. Drop our
> +            // reference and retry.
> +            drop(page);
> +        }
> +    }

[Severity: Medium]
Can dropping the speculative Page reference here free a reallocated page
with __free_pages(page, 0) instead of put_page()?

CPU0                           CPU1                      CPU2
lookup_page(index)
  ptr =3D slot.load()
                               discard()
                                 slot.xchg(null)
                                 drop(page)
                                                         (reallocates ptr a=
s a
                                                          compound or LRU f=
olio)
  Page::try_get_raw(ptr)
    get_page_unless_zero(ptr)
                                                         folio_put()
  slot.load() !=3D ptr
  drop(page)
    __free_pages(ptr, 0)  <-- bypasses __folio_put() / wrong order

rust/kernel/page.rs:<Page as Drop>::drop() {
	unsafe { bindings::__free_pages(self.page.as_ptr(), 0) };
}

Once discard() frees the page back to the page allocator, another subsystem
can reallocate that struct page as an LRU, memcg-charged, hugetlb, or
higher-order compound folio before Page::try_get_raw() increments its
refcount.  If the new owner drops its reference before CPU0 re-checks the
slot, drop(page) releases the last reference via __free_pages(ptr, 0)
rather than put_page(ptr), bypassing __folio_put() and triggering
VM_BUG_ON_PAGE() / bad_page() or corrupting the page allocator.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117233211.3137=
168-1-vitaly.wool@konsulko.se?part=3D3

