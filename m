Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17A54606A333
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kMnz+goG
Received: by kanga.kvack.org (Postfix)
	id C24516B0624; Wed, 18 Nov 2026 18:36:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B60CE6B064C; Wed, 18 Nov 2026 18:36:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A50CD6B064D; Wed, 18 Nov 2026 18:36:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67A936B0624
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:36:28 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D46FE408D6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:36:27 +0000 (UTC)
X-FDA: 85449851214.01.AB32077
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 32197A0004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:36:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kMnz+goG;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795044986;
	b=FJaLSOEzC+yF4AB80b7ayoL4+dywP6/oTIjOOHjm7BYZqFDmXZXwwloOK0YQBpknc8SOQu
	bSYwUthUyPKazQaucP447R7F4TOiILYwWZOrTkGytigI8rDR8OVrZdqgRYX0DLLVB0Xiw7
	D8nlhgQ+SpI3L1CLsCu2eA2BgI1QcCk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795044986;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6behX8cIVP3HDTJ0+OalgLDKUWUF8Df8rBu2ILzwjGs=;
	b=q/E+tCh98gHcwpng5KeLZsEegjgao5V1NOJ0erMIeVliMC6xOmdyrhMX8PLNXiZUPlx5PI
	GXSwkGQ05575zkEv4Yf2uF7NpHKsv/lxIqO4SXPsppwueAhR5ZFvNJE/1HHdCFnxZc0zmW
	XZ85ZOsL7WIJ7X3Q3mNvjVI7WezHLF0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kMnz+goG;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C4021642AE;
	Wed, 18 Nov 2026 23:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EDE1F000C4;
	Wed, 18 Nov 2026 23:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795044985;
	bh=6behX8cIVP3HDTJ0+OalgLDKUWUF8Df8rBu2ILzwjGs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kMnz+goGx24d55yCeWAT/unC/uTTRgSAwbrclCmxPUl1zkLYq+BptJbZyEUiupNzu
	 PmproaHljdvYveJPctcjCdEaZOuduWvG39XoRIBLGjYOQ7ukH0MRp0sR32ZsLp+lsl
	 V4QdNdFFGliAGwZf0SFx5/vNH98lNR5bDGRnHp/ClMJE7tql149C+YoNRziE/spJGd
	 cdx97xcqjHNi44pJ0V74r1rw3vCha65NM1d5uJoCBxIoVrh+OheO6r27/eAKmhJG5H
	 +XSIkDyAbsN5MY/P5NnDGbOBKZZGJ51ePm0tPp43vYGcoyUpzyz2dRTSKPgXiEFXoB
	 rhf9uKfSDIA+A==
Message-ID: <sashiko-outbox-222197@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] rust: page: add reference counting, raw pointers
 and a private bit lock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vitaly Wool" <vitaly.wool@konsulko.se>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Jens
 Axboe" <axboe@kernel.dk>, "Miguel Ojeda" <ojeda@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>
Cc: "Boqun Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?b?QmrDtnJuIFJveSBCYXJvbg==?= <bjorn3_gh@protonmail.com>, "Benno
 Lossin" <lossin@kernel.org>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, "Daniel Almeida" <daniel.almeida@collabora.com>, "Tamir
 Duberstein" <tamird@kernel.org>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?b?T251ciDDlnprYW4=?= <work@onurozkan.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R . Howlett" <liam@infradead.org>, linux-mm@kvack.org, "Igor B" <igor.b@beldev.am>
In-Reply-To: <20261117233211.3137168-3-vitaly.wool@konsulko.se>
References: <20261117233211.3137168-1-vitaly.wool@konsulko.se>
 <20261117233211.3137168-3-vitaly.wool@konsulko.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 23:36:24 +0000
X-Rspam-User:
X-Stat-Signature: dshffc3yqbt3gwugbsynen6113fhxdp1
X-Rspamd-Queue-Id: 32197A0004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795044986-277177
X-HE-Meta: U2FsdGVkX19X815U20Z2SR0DRe0+f26kkRrgVUX9ShoAW3dvgJ5WJkXDQiiJbWlrVvDBBKq5MHUUyvz52imIt3I+WwjDWT3RngmOElfKiwhPxUR/qiw8NLOZG8U2cCSSBQRZkgj72/2tSKmBBGeBRJ7Kh7cQnyrpQJ8IwR0bRoSN0r7p+hf6Vdf2FA1aLMIBkC+xbklRaJWBn+uiDOLpjAlYbqc/ogzTm76M1O4xDfu9vqUMhkwH1Vl6IVX1AxgrSn3RZyte9lsuRmeJQdsWTTl7IGBeHMx8As56ZE3G4A6ghNXI8uDcyEbSYtNBw2/ap3RAWcVJySzvlm+r1E/vZrwqn6pjLrt79Dk6gvMdWxgXscCZAxRHuaTcqKKZaeYxTggBAY9OYsKJeqdQenr/t6e2Z8Go28Xx1yQuSmvUSt4F/ReA3hOgTui1TojgvciSBqbk3gtwS7M4ghRgL1h46iSgopZbATaExRsRzKtr76AHkeA/YetlIDIcuVh3vRPl5HFth+EmIPe/HADsPzLKieBwCzrg/Fj7KIpc5eLW0mnkowRyPescwdfDMtmY8VjyuYQUd5oFHGkdsbcy6sWx1OolPCxjbFQi421nCBRL+K7XTOfbKn9tsvCXpTImaqdiMiCA9NafVCwWxMZxEJtKCO5tUnh8TVNXl+gUhR/90uwfWpqIqSRdHHLs5+ZkDKWrcfJOviEE+Gabd7zIpEuF+PQQO2NKLE2+YPTjpIWHcx9qOs7vOB8ZJgAo+E7XcIJGT0XGVWRPhx0/PPWf5znrhDQeAhR8q1AGdyzhutBh1Q31dc3CKCXYq3TNvIVoGssVe3I6nTMIFtXPc9JHRkvSUELKrSIe7SqVJZOagkdWOLTrHxlrssZOu6pLD4FrdJlrfwPc9+MacyLgxUgQUnz3hYukFbITRDWgrs2RKbBsXJl5no5j9YaLZ7PvvyD3L7k4WJqSVIIC6mKsiTMgZ1H
 qIfJ1Gwy
 ele/dTuMsehd9SKjY88gVMubKjcAPELWY4kU1VHNbJAUCyWexfygXJv6K4GPtnGAPAKO/votuuSudNvTnvuE/O77QAyAs/Z2ri1dpk5lHB3HFNEaq8btmuHXHyrnIzrJ+RxTwLi6l3VpK3C+awB7LuYCq+4DEsIMGZpG7cAcXIPZBdElS/BpjAd/TOoHiGhjipN7ebLAdEWvUsKa+FXvk27GsLsShBuwxRgnBiYmIuzvy7RFLyb5fmc6bdY2iunpqTqJiR8kXIJupGcuLCaY6EOaRoVOfX1M2XDaPz38UqZpYV0HUcEO9WSSKGhGoDphNz67ggf9H0OWNDyrpdpDNiFXJnwRnpTNyE0QWktMpySKItfcXfGJ0Wz2C6Qx+ag445XDnNQSg5QPbU1xXxiFtkOJYngAVbGx6JDFVphjIO7J7+vphA+nH3k66/++tFBmLTQDWJG8j0WJOuAsNSIzLca/Drq9eG+pfcaQQPubF+l4FXdD05iiA/lhOOprQ6JEoWm7b11cW4cf/mxiYXiuYevmR0+or2VU5TpxOyWCghTsZCbenutRDusZ0/pRoIhdC2F0VPdIHGUggdSBH3T5lNW0f25oDEpyLw/ghZ4l26kpuer7/+o7IQtxxnXadn8btJ9tmhoggcX8baFjHiI4KosQDs48iPCNo1YSdUFqQvjnZPkwfE9vxciSjd0v0IbPyJbodPIYJvwnc+n1fm41pzn+WoQ==
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
- [High] rust: page: unsound speculative ref and __free_pages() drop in
  try_get_raw()
- [Medium] rust: page: BorrowedPage lifetime escape via Deref to
  Page::get()
--

commit ce2ee3f082c492cf922004e652ef173e3c507e27
Author: Igor B <igor.b@beldev.am>

rust: page: add reference counting, raw pointers and a private bit lock

This commit adds reference counting, raw pointer conversion helpers, and a
private bit spinlock to the Rust Page abstraction, along with the
underlying C helpers.

> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
> index 1c0796ea229f0..e75d9efbcce63 100644
> --- a/rust/kernel/page.rs
> +++ b/rust/kernel/page.rs
[ ... ]
> @@ -200,6 +205,139 @@ pub fn as_ptr(&self) -> *mut bindings::page {
>          self.page.as_ptr()
>      }
> =20
> +    /// Takes an additional reference on this page.
[ ... ]
> +    #[inline]
> +    pub fn get(&self) -> Self {
> +        // SAFETY: `self.page` is valid by the type invariant, and calli=
ng `get_page` on a page
> +        // that is kept alive by `self` is always safe.
> +        unsafe { bindings::get_page(self.page.as_ptr()) };
> +        // INVARIANT: We just took a new reference to the page pointed t=
o by `self.page`, so the
> +        // new `Page` has ownership over that reference.
> +        Self { page: self.page }
> +    }

[Severity: Medium]
Does taking &self in Page::get() allow a non-owning BorrowedPage<'a> to
escape its borrow lifetime 'a in safe code?

BorrowedPage<'a> implements Deref<Target =3D Page>, so safe callers can call
borrowed_page.get() to obtain an owned Page with no lifetime bound.
For example, VBox::page_iter() and VVec::page_iter() yield BorrowedPage<'a>
items tied to a mutable borrow of the container; calling .get() lets safe
code retain and access the underlying physical page after 'a ends while
VBox/VVec holds exclusive mutable access or frees the memory.  In addition,
BorrowedPage::from_raw() only requires a valid struct page pointer for 'a,
not a refcounted order-0 page: if it wraps a slab or large_kmalloc page,
get_page() warns and returns without incrementing the refcount, and
dropping the returned Page calls __free_pages() without owning a reference.

> +
> +    /// Consumes the [`Page`], returning the raw pointer to its `struct =
page`.
[ ... ]
> +    /// Attempts to take ownership of a page from a raw, possibly stale =
pointer.
> +    ///
> +    /// On success, returns a new [`Page`] that owns one reference to th=
e page. On failure
> +    /// (meaning the page's reference count had already reached zero, i.=
e. its last owner had
> +    /// already released it), returns `None` without otherwise touching =
the page.
> +    ///
> +    /// This is the kernel's usual way of giving a lock-free, concurrent=
 lookup (such as one
> +    /// protected by the RCU read lock; see [`kernel::sync::rcu`](crate:=
:sync::rcu)) a safe way to
> +    /// turn a pointer it found into an owned reference, without taking =
any lock: unlike
> +    /// [`get`](Self::get), this does not assume `ptr` is already known =
to be alive.
> +    ///
> +    /// # Safety
> +    ///
> +    /// `ptr` must point at a valid `struct page`. Note that, unlike mos=
t kernel objects, a
> +    /// `struct page` is never freed or reused for a different purpose f=
or as long as the system
> +    /// is running: only the memory it describes is freed and may be reu=
sed once its reference
> +    /// count drops to zero. It is therefore always safe to inspect and =
modify the reference count
> +    /// through a `struct page` pointer that was, at some point, validly=
 obtained, even if the
> +    /// page has since been fully released by its last owner, as long as=
 the pointer has not since
> +    /// been reused to mean something other than a `struct page` pointer=
 (which can only happen if
> +    /// the caller itself reinterprets it as something else).
> +    #[inline]
> +    pub unsafe fn try_get_raw(ptr: NonNull<bindings::page>) -> Option<Se=
lf> {
> +        // SAFETY: By the safety requirements of this function, `ptr` po=
ints at a valid
> +        // `struct page`.
> +        //
> +        // INVARIANT: If this call returns `true`, then it has just incr=
emented the reference
> +        // count of the page pointed to by `ptr`, and we have ownership =
over that new reference.
> +        if unsafe { bindings::get_page_unless_zero(ptr.as_ptr()) } {
> +            Some(Self { page: ptr })
> +        } else {
> +            None
> +        }
> +    }

[Severity: High]
Can Page::try_get_raw() acquire a speculative reference to a page that was
freed and reallocated to another kernel subsystem, and then release it with
__free_pages(ptr, 0) instead of put_page()?

CPU0                              CPU1
----                              ----
ptr =3D load page slot
                                  drop(last_page_owner)
                                    __free_pages(ptr, 0)
                                  page reallocated (e.g. compound
                                  or LRU folio, refcount >=3D 1)
Page::try_get_raw(ptr)
  get_page_unless_zero(ptr) -> true
                                  new owner drops its ref
slot check fails:
drop(page)
  __free_pages(ptr, 0)  <-- VM_BUG_ON_PAGE / bad_page()

Because Page::drop() frees pages immediately via __free_pages(ptr, 0)
without an RCU grace period, the struct page at ptr can be reallocated to
an unrelated user (such as a higher-order compound folio or an LRU/memcg
folio) before get_page_unless_zero() runs.  get_page_unless_zero() then
succeeds on the new allocation.  Unlike C's brd_lookup_page(), which
releases a mismatched speculative reference with put_page() (calling
folio_put()), dropping the returned Page calls __free_pages(ptr, 0):

rust/kernel/page.rs:<Page as Drop>::drop() {
    unsafe { bindings::__free_pages(self.page.as_ptr(), 0) };
}

As noted on __free_pages() in mm/page_alloc.c, speculative references must
be dropped with put_page() rather than __free_pages(); calling
__free_pages(ptr, 0) on a compound or LRU folio triggers VM_BUG_ON_PAGE(
compound && compound_order(page) !=3D order) in __free_pages_prepare() or
bad_page() when freeing a page still on an LRU list.

In addition, the Safety contract of try_get_raw() does not require the
caller to re-validate the lookup slot after get_page_unless_zero() succeeds
before accessing the returned Page.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117233211.3137=
168-1-vitaly.wool@konsulko.se?part=3D2

