Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99600C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:02:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A14536B00A0; Thu, 10 Sep 2026 05:02:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C47F6B00A1; Thu, 10 Sep 2026 05:02:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88E916B00A2; Thu, 10 Sep 2026 05:02:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A3136B00A0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:02:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD04AA0449
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:02:25 +0000 (UTC)
X-FDA: 85197261450.26.4F87285
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id E178410000C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:02:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oNWSOyjz;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789030944;
	b=eTny7HATM7b0gxLYYVzk8r0qIgTkvY57owuxIud9Nqh3I6so1OCVck6JVwy7RImVU0UtH2
	Xb+C4bxcUKBHSM1RwQBhjeq6hI1M8Jzf0M4RedOXzckvD4skyagk1ROWGZ5iInXtmdbEj4
	hQANs6HKDKQFrRCBeB0zwquw/iEw8qI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oNWSOyjz;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789030944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GYaQ9Qw7yqy+pa99UaWhxp0mlpiBoF24PQM3D3leZU0=;
	b=vo662/Rxu0FslnUbwzOauGqtS/VhmR6vA2tOn9rNYC32goOJHaqIlCl4t+3OlSP6B8WRPu
	7K8W/4ftNI0MNMxe7kW8XnL3t7/PTcs1+pJ4wcLTUUGKza0FRtZElTFZdRrXCJBNnsZMxv
	DU543NRTYlIrgaEQICBG18Ekm3ta0EM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D4A8409E3;
	Thu, 10 Sep 2026 09:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418FF1F000FF;
	Thu, 10 Sep 2026 09:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789030943;
	bh=GYaQ9Qw7yqy+pa99UaWhxp0mlpiBoF24PQM3D3leZU0=;
	h=From:Subject:Date:To:Cc;
	b=oNWSOyjz86/Hxwzvn2CxrT8mfQlE4o6iYiRf6PzgZD9XgpHzTxMjDLCstDnkTwNDb
	 GFBRKUIn3BxU1qI8BWisZ/fGUJIvuoZh8G0XMuH2I0IiGiZON1IcOxayfK8+ZYvavE
	 Z5M1lbHhudEP3bfJz2AWzq8sARR7TGnp8eiNVPf2WcD9bT4uSANOFnwA8qBAgc+mdH
	 oq+C9V9Svv4yNVFd0Sx0L0I6bX0IJSNhAPuP5Y7wEQ7fC/3IyK6Uw1EU3SRlpQX5gc
	 23NCdaBmjY5eBsgwd3aN7p7Qoqk6tq0Lbin++EdhZ/RMvPZsfvpGMR6bEK8peXXixG
	 szY/f915bLmLQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH v21 0/9] rust: add `Ownable` trait and `Owned` type
Date: Thu, 10 Sep 2026 11:00:04 +0200
Message-Id: <20260910-unique-ref-v21-0-e83257373062@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAJRxomoC/2XQy07DMBAF0F+pvMZoPIlfrPgPxCK2x60FSsChE
 ajKvzPppnks51rnju2bGKkWGsXL6SYqTWUsQ88DqqeTiJeuP5MsiQOBgBoa0PLal+8ryUpZos8
 xGauzJy8YfHFYfu9tb+88X8r4M9S/e/mk2iVeegwgtOsePpMglY0BPYUuhvD6QbWnz+ehnsXSN
 Cm90ghbrVk731ByJoCJ8ajNWu92G9YRVZdjUMql5qjtQ5v9zS1rG9rYJPQNBH/UbqVRb7Vj3RK
 YoJ03qbVH7dfabLVnzbmNnXMpp3zQCA/tdu/mT+TdHmyjjUXltrvnef4Hc5kSqRwCAAA=
X-Change-ID: 20250305-unique-ref-29fcd675f9e9
To: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lyude Paul <lyude@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, 
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
 Carlos Llamas <cmllamas@google.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Leon Romanovsky <leon@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar <vireshk@kernel.org>, 
 Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
 Michal Wilczynski <m.wilczynski@samsung.com>, Ira Weiny <iweiny@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Ira Weiny <iweiny@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 driver-core@lists.linux.dev, linux-block@vger.kernel.org, 
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org, 
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
 linux-usb@vger.kernel.org, Asahi Lina <lina+kernel@asahilina.net>, 
 Oliver Mangold <oliver.mangold@pm.me>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Boqun Feng <boqun@kernel.org>, 
 Igor Korotin <igor.korotin@linux.dev>, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=14336;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=Sp6YRCoJj3CawkjK6Gl7pVgDMf8rxdwoCR/Q4hQH9ds=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqonGe+dQbbI/rQgWWQoNjTomIq+LnebWzXRSK+
 as0rQy2UeSJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaqJxngAKCRD6UCkIqsW9
 0BJAEACax/RfVnt3GLXTrNW86+7gqP7CYAFomJCpfdEfnr6ZWoiM12dA6tiwZCX17WjLAJ1Tf9+
 T5wEFgHHrxK9eTzBdNLKCQB5fiRmeoGe53BS6DZFgB6CYhFRz+dnzH1VosCki21ZcyGNH//COIE
 dRrPCqeH1vbpsJ0jTFE2WZE0QeVjkLY9qphFt9Gx3wv2cXqqR4y/Z4ZJ/RvyYS2l/RNSD44RSQa
 c1juKGGJOlns5/sYw1vSFIv8L0bIinXm1ECDokggI3s2YoNyhKH/SP4WRlL8u5WCD2k7cbnSYTW
 SM2yQD3vFDsvP0WCFTs9We7VHO+9QcAPDDOV/iGhibrE+oekPjn7Z6+JBokXgIc07OukKihjCbR
 gbSxMGi735TdVE+n7UtFilZDSGc+Tv4mHJ+Ys2LEzqjmS+sIez6pGU/Zh7vka+8tETgimTRR9Vw
 6eNXVVI8Keizbd9sPN0yJtscprIGVaWjMBz5oiKOp+ReTE1ZBNGSX14+TNRxpqTcNuB9o8HFXQu
 X1MmM1qhigi6QOh65TFHzjISJh5FMGLnFxvTPVKW/FGmXSU7xmaz1yaHjKLdCwpsdUJp658QWe1
 VLEkil311tVppR0XB+13RjNZhBC6qVOxWC/CiNptkyMSa+5gavLIJBOY4LN9Zgauz6tfeC2K88o
 3nsvuyfEUmbW9Ug==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E178410000C
X-Rspam-User: 
X-Stat-Signature: 48t7ab14jij1h9j6xtjdjp6tyobn9sjz
X-HE-Tag: 1789030943-374992
X-HE-Meta: U2FsdGVkX1+gq7qtlmzK9Ez6bur68PxKgJX3z9xONKmw7jQab9tYUOtVUqpk3+rVVKGG553h5nnJcRmV57rRRAc2syC3HUxqzYll4EU10xcPPpaXkuNtiuU5TvkX4hw6GzmNquj8wE4ZaTlw4uL7qJX/Ni8Rsx96RnkBBRmPHGSmbb1zKu7QVeR7j/G5b5wC7beHLkttKEizH48LhCtHIYxlY4g3qUQmNtu1KkaKxywr1pcJCVnEHdhUYmsDju0DC2uvKUMu7KJHgJLtEHINbtjbzHi4htnAJRovwp3i4D0QpGROC2JWczhHMThr7wzYRnrRtBGiYn95WQSe/k2wbrcN4fA8+vGw8pUM2vzF7OYqy+RMuZ3OGZgQ/AAvCu1i5GiorINeIGi9VJ/D2YqhL0MfU9LWMTsY61QjGje05f4FdKOIjNCz0taXct5acUBqyRMU1n6binur+7lI7qpUHn7ED8r1Leir1HechD1q9AkvWiQRirAGCPxfjJg9cpqBN0cjSeWTG5i3ONp44+BMRMMIevne+BVnPAJ3pY1rO9oK0Yrnv1a2EVFuVDij4oq8h56hhgwi0Ckg5ccCjT0uXhUxxbf0VBRrxS9cI8TdZKwDT9iEoMJAcFGivLZHj55NNwDZZnsr2gcPsuS3VqPru6bW3gf4wuPJbv1baJahgjyILQ2A2sJy9hrReeN10dxrYhk+F9CN+kO6K6DSnRIVAvFuPsU8aA7OG0mB7u4MxeJLsbXX8uJDr2M4V2WDlubjmrOQCxNFO6BliCaia2hI4eR21LXKwGaSAN+z+lmgn0GBFZZBqFwfALp4tble7NCbO2AmYyr5DSAsGdT6m/TUFM7Y9vl1Eq40r3R/Qro3ivkGBFPXLnBXgoM5c1nB45nTrqLtpQ0VeihbGrI9V5WE6jcSHZTsUvFpM5IhQzYpbZg5vfbpEewGkCBMGF5FHqqWNtB2tuEsTG/OoKKlaJM
 84/L6PzD
 fZ2vSCtxGM+PUg+pPqdHO/XuvDJR4C8F9Ea2bL/JkhnGFuryZ+qDBznU43zPQMgs7YUdnCQhLLBOqkm6WyVHDhlTI17n7lc9v3ExuHO+McCDKswTMXbwP+nfis9FWhCQknrlKX+tfqWAuB4+E0Mg3rEzHySEUgySzGNw+51jSxwzKuvzqt1M/Y5MRD244sIUTiXiHjl808WscBvDvBGaXjH6hTU7M7i7KT+idvuMnNU82nHsid/RVmWngeqPe96P66aEKfL+EO4TXhZFBMRNvMZ+KrjmxSeyrxagbm/CzX6IE7J/3ZxY/R3ti+uLWd1ojH80O7iq0vi5pXMeMroWqCfHEsBipuz3+Woe+YPGzm/nu0M8izuuTfsGRFQlRx+PnQntu7zmyqNkIAgUk5shgthQBbC7MsCOOruuV9LVt55K8kneKAr3yv9yC1r4R61kCno2Dye/YYd1QGMN2SdQYvJSGbkAMSJ9EAiE8opp5xjq5RQPiOPHOJ4Xbx9JMoP/KXBlm5tWTwwAjGmYlDLYZCW18jE4U7YSGWFaRRItPlxX45Wdm4kX8fy6v47vlhgKq0dv5VGMRJqnJeO6xwTa6SkAwt4oXjiL8qQzBko9AR+K2cGUIgfMCoVPM5G8m9jQIYfoZnFKXk84DkaI0hwO2/8Sq2a23y9uRmJR5B0iVIxigo+BdFETzb9+/XzaJHMs/s7kzD8fs45M/1l9CQEkNgvCfv7glqI6O15pMjxkoNqVuhvxeutoh5nyvazbsAIDTjDA9n5D7SuYN4H07fus7x0Ya3Qpi9xHJb7YoFumnXtFDRV3gtnBkUD0tGLL1resm8YdP3F1i2uiNEfSa3VQ4iFWCeaXQxexpHE9lo7te0yI5x8rwQqXiIwtFYocC8XBZ6jL3NHDrqsgjglUrmkCsHyWvAdbSF9bvDl3BXEHJTdFhwtYv7645oVt76JZkF+spzceAuvUbXICPcoqfw15GAYUM490G
 tDLRe15S
 CUBTKArfn6wU4gRnMUGFxmGXmsl1km5MoZAp8UHFV6Sr+qh6g9k6n1HUeN8Nd97Cg2Y8VtExycC+t/3NanuONaTY/XyBcy4h3Ued90jRIWh4ruE1mDA6fLnohfn8eBW+F/agSeu/+DqVt1A2Hlj9XclVAwY2/1P8mMst46yqlRO/HY9OvtWmn1bayC2pAnhIr3RJNXdgXbdLt00dspjgo9Ji3pUkX+LeOvDVR2AAypOrUkQMxR6Nd7YXAUA2pljEIA48xllL61N9hyK7EGVMNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new trait `Ownable` and type `Owned` for types that specify their
own way of performing allocation and destruction. This is useful for
types from the C side.

Implement `ForeignOwnable` for `Owned`.

Convert `Page` to `AlwaysRefCounted` and add a `from_raw()` method.
`struct page` is managed by a native reference count, so pages are
modelled as shared, reference counted objects rather than exclusively
owned ones.

Add `ExclusivePage`, an `Ownable` wrapper around `Page` with the added
invariant that the page data is free from data races.

Add the trait `OwnableRefCounted` that allows conversion between
`ARef` and `Owned`. This is analogous to conversion between `Arc` and
`UniqueArc`.

Patches 1-3 implement `Ownable` and can be merged on their own.

Patches 4-5 split the `RefCounted` trait out of `AlwaysRefCounted`
and complete the SAFETY documentation for the `ARef` example.

Patch 6 adds `Ownable` -> `ARef` interop via `OwnableRefCounted` and
can be merged later if consensus on its shape cannot be reached.

Patches 7-9 convert `Page` to `AlwaysRefCounted`, add
`Page::from_raw()`, and add `ExclusivePage` as the first in-tree
`Ownable` user.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
Changes in v21:
- Require callers of `Owned::from_raw()` to treat the pointee as
  pinned (Sashiko).
- Import `Page` directly in `allocator.rs` instead of using the
  `page::Page` path (Danilo).
- Update DRM GPUVM for the `RefCounted`/`AlwaysRefCounted` split
  (Sashiko).
- Rework the SAFETY comments in the `ARef::into_raw` doctest to
  justify the correct obligations (Sashiko).
- Use `sync::Refcount` in the `OwnableRefCounted` example (Gary,
  Danilo).
- Add a link to the SAFETY TODO tracking issue to the `ARef` example
  patch (Miguel).
- Convert `Page` to `AlwaysRefCounted` backed by `get_page()` and
  `put_page()` instead of `Ownable`, and return `ARef<Page>` from
  `Page::alloc_page()` (Alice).
- Update Rust Binder to store `ARef<Page>` instead of `Owned<Page>`
  (Alice).
- Add `ExclusivePage` as the in-tree `Owned` user, without
  `Deref<Target = Page>` as that would break its aliasing invariant.
  The type was previously posted as `SafePage` and is renamed here
  (Alice).
- Reorder the series to keep the `Page` patches together at the end.
- Link to v20: https://msgid.link/20260824-unique-ref-v20-0-490735672187@kernel.org

Changes in v20:
- Fix a few copy/paste errors in safety comments (Sashiko).
- Use `self.page.get()` rather than `Opaque::cast_into` (Alice).
- Add a space between generics in a comment (Sashiko).
- Change a safety comment to reference Box rather than KBox (Sashiko).
- Link to v19: https://msgid.link/20260626-unique-ref-v19-0-2607ca88dfdf@kernel.org

Changes in v19:
- Update `workqueue.rs` and the `aref` module docs to use `RefCounted` instead of `AlwaysRefCounted` (Sashiko).
- Remove the default `OwnableRefCounted::into_shared` implementation to keep the trait safe (Sashiko).
- Fix the `ARef<Self>` rustdoc link (Sashiko).
- Reuse `Owned::into_raw`/`from_raw` in the `ForeignOwnable` implementation (Gary).
- Link to v18: https://msgid.link/20260625-unique-ref-v18-0-4e06b5896d47@kernel.org

Changes in v18:
- Rebase on `rust-next` (2026-06-24).
- Drop the `'static` bound on `ForeignOwnable for Owned` (Gary).
- Make `Ownable::release` take a raw pointer instead of `&mut self` (Alice, Sashiko).
- Drop `types::ARef` re-export (Alice).
- Drop unneeded `#[repr(transparent)]` on `Owned` (Gary).
- Fix `FOREIGN_ALIGN` for `Owned` to report the pointee alignment (Sashiko).
- Remove `BorrowedPage`; use `&Page` directly (Alice).
- Update Rust Binder for the `Owned<Page>` conversion (Alice).
- Update `pwm.rs` for the `RefCounted`/`AlwaysRefCounted` split (Sashiko).
- Fix documentation nits: missing `// INVARIANT:` comments, stale `Page` docs, and a stray `mut` (Sashiko).
- Expand the `use` statements touched by the rename patch to the multi-line style (Onur).
- Link to v17: https://msgid.link/20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org

Changes in v17:
- Rebase on v7.1-rc2.
- Reorder patches so that `Ownable` can merge without `OwnableRefCounted` (Alice).
- Add `#[inline]` directives to short functions added by the series (Gary).
- Link to v16: https://msgid.link/20260224-unique-ref-v16-0-c21afcb118d3@kernel.org

Changes in v16:
- Simplify pointer to reference cast in `Page::from_raw`.
- Use `NonNull<Page>` rather than `Owned<Page>` for `BorrowedPage` internals.
- Use "convertible to reference" wording when converting pointers to references.
- Fix formatting for `Page::from_raw` docs.
- Leave imports alone when adding safety comment to aref example.
- Use `KBox::into_nonnull` for examples.
- Add patch for `KBox::into_nonnull`.
- Change invariants and safety comments of `Ownable` and make the trait safe.
- Make `Ownable::release` take a mutable reference.
- Fix error handling in example for `Ownable`
- Link to v15: https://msgid.link/20260220-unique-ref-v15-0-893ed86b06cc@kernel.org

Changes in v15:
- Update series with original SoB's.
- Rename `AlwaysRefCounted` in `kernel::usb`.
- Rename `Owned::get_pin_mut` to `Owned::as_pin_mut`.
- Link to v14: https://msgid.link/20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org

Changes in v14:
- Rebase on v6.19-rc7.
- Rewrite cover letter.
- Update documentation and safety comments based on v13 feedback.
- Update commit messages.
- Reorder implementation blocks in owned.rs.
- Update example in owned.rs to use try operator rather than `expect`.
- Reformat use statements.
- Add patch: rust: page: convert to `Ownable`.
- Add patch: rust: implement `ForeignOwnable` for `Owned`.
- Add patch: rust: page: add `from_raw()`.
- Link to v13: https://lore.kernel.org/r/20251117-unique-ref-v13-0-b5b243df1250@pm.me

Changes in v13:
- Rebase onto v6.18-rc1 (Andreas's work).
- Documentation and style fixes contributed by Andreas
- Link to v12: https://lore.kernel.org/r/20251001-unique-ref-v12-0-fa5c31f0c0c4@pm.me

Changes in v12:
-
- Rebase onto v6.17-rc1 (Andreas's work).
- moved kernel/types/ownable.rs to kernel/owned.rs
- Drop OwnableMut, make DerefMut depend on Unpin instead. I understood
  ML discussion as that being okay, but probably needs further scrunity.
- Lots of more documentation changes suggested by reviewers.
- Usage example for Ownable/Owned.
- Link to v11: https://lore.kernel.org/r/20250618-unique-ref-v11-0-49eadcdc0aa6@pm.me

Changes in v11:
- Rework of documentation. I tried to honor all requests for changes "in
  spirit" plus some clearifications and corrections of my own.
- Dropping `SimpleOwnedRefCounted` by request from Alice, as it creates a
  potentially problematic blanket implementation (which a derive macro that
  could be created later would not have).
- Dropping Miguel's "kbuild: provide `RUSTC_HAS_DO_NOT_RECOMMEND` symbol"
  patch, as it is not needed anymore after dropping `SimpleOwnedRefCounted`.
  (I can add it again, if it is considered useful anyway).
- Link to v10: https://lore.kernel.org/r/20250502-unique-ref-v10-0-25de64c0307f@pm.me

Changes in v10:
- Moved kernel/ownable.rs to kernel/types/ownable.rs
- Fixes in documentation / comments as suggested by Andreas Hindborg
- Added Reviewed-by comment for Andreas Hindborg
- Fix rustfmt of pid_namespace.rs
- Link to v9: https://lore.kernel.org/r/20250325-unique-ref-v9-0-e91618c1de26@pm.me

Changes in v9:
- Rebase onto v6.14-rc7
- Move Ownable/OwnedRefCounted/Ownable, etc., into separate module
- Documentation fixes to Ownable/OwnableMut/OwnableRefCounted
- Add missing SAFETY documentation to ARef example
- Link to v8: https://lore.kernel.org/r/20250313-unique-ref-v8-0-3082ffc67a31@pm.me

Changes in v8:
- Fix Co-developed-by and Suggested-by tags as suggested by Miguel and Boqun
- Some small documentation fixes in Owned/Ownable patch
- removing redundant trait constraint on DerefMut for Owned as suggested by Boqun Feng
- make SimpleOwnedRefCounted no longer implement RefCounted as suggested by Boqun Feng
- documentation for RefCounted as suggested by Boqun Feng
- Link to v7: https://lore.kernel.org/r/20250310-unique-ref-v7-0-4caddb78aa05@pm.me

Changes in v7:
- Squash patch to make Owned::from_raw/into_raw public into parent
- Added Signed-off-by to other people's commits
- Link to v6: https://lore.kernel.org/r/20250310-unique-ref-v6-0-1ff53558617e@pm.me

Changes in v6:
- Changed comments/formatting as suggested by Miguel Ojeda
- Included and used new config flag RUSTC_HAS_DO_NOT_RECOMMEND,
  thus no changes to types.rs will be needed when the attribute
  becomes available.
- Fixed commit message for Owned patch.
- Link to v5: https://lore.kernel.org/r/20250307-unique-ref-v5-0-bffeb633277e@pm.me

Changes in v5:
- Rebase the whole thing on top of the Ownable/Owned traits by Asahi Lina.
- Rename AlwaysRefCounted to RefCounted and make AlwaysRefCounted a
  marker trait instead to allow to obtain an ARef<T> from an &T,
  which (as Alice pointed out) is unsound when combined with UniqueRef/Owned.
- Change the Trait design and naming to implement this feature,
  UniqueRef/UniqueRefCounted is dropped in favor of Ownable/Owned and
  OwnableRefCounted is used to provide the functions to convert
  between Owned and ARef.
- Link to v4: https://lore.kernel.org/r/20250305-unique-ref-v4-1-a8fdef7b1c2c@pm.me

Changes in v4:
- Just a minor change in naming by request from Andreas Hindborg,
  try_shared_to_unique() -> try_from_shared(),
  unique_to_shared() -> into_shared(),
  which is more in line with standard Rust naming conventions.
- Link to v3: https://lore.kernel.org/r/Z8Wuud2UQX6Yukyr@mango

To: Danilo Krummrich <dakr@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Uladzislau Rezki <urezki@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
To: Boqun Feng <boqun@kernel.org>
To: Gary Guo <gary@garyguo.net>
To: Björn Roy Baron <bjorn3_gh@protonmail.com>
To: Benno Lossin <lossin@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
To: Trevor Gross <tmgross@umich.edu>
To: Daniel Almeida <daniel.almeida@collabora.com>
To: Tamir Duberstein <tamird@kernel.org>
To: Alexandre Courbot <acourbot@nvidia.com>
To: Onur Özkan <work@onurozkan.dev>
To: Lyude Paul <lyude@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arve Hjønnevåg <arve@android.com>
To: Todd Kjos <tkjos@android.com>
To: Christian Brauner <brauner@kernel.org>
To: Carlos Llamas <cmllamas@google.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
To: Dave Ertman <david.m.ertman@intel.com>
To: Ira Weiny <ira.weiny@intel.com>
To: Leon Romanovsky <leon@kernel.org>
To: Paul Moore <paul@paul-moore.com>
To: Serge Hallyn <sergeh@kernel.org>
To: David Airlie <airlied@gmail.com>
To: Simona Vetter <simona@ffwll.ch>
To: Alexander Viro <viro@zeniv.linux.org.uk>
To: Jan Kara <jack@suse.cz>
To: Igor Korotin <igor.korotin@linux.dev>
To: Viresh Kumar <vireshk@kernel.org>
To: Nishanth Menon <nm@ti.com>
To: Stephen Boyd <sboyd@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
To: Krzysztof Wilczyński <kwilczynski@kernel.org>
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Michal Wilczynski <m.wilczynski@samsung.com>
To: Ira Weiny <iweiny@kernel.org>
To: Matthew Brost <matthew.brost@intel.com>
To: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Philipp Stanner <phasta@kernel.org>
Cc: rust-for-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: driver-core@lists.linux.dev
Cc: linux-block@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: linux-pwm@vger.kernel.org
Cc: linux-usb@vger.kernel.org

---
Andreas Hindborg (5):
      rust: alloc: add `KBox::into_non_null`
      rust: implement `ForeignOwnable` for `Owned`
      rust: page: convert to `AlwaysRefCounted`
      rust: page: add `from_raw()`
      rust: page: add `ExclusivePage` for race-free page access

Asahi Lina (1):
      rust: types: Add Ownable/Owned types

Oliver Mangold (3):
      rust: rename `AlwaysRefCounted` to `RefCounted`.
      rust: Add missing SAFETY documentation for `ARef` example
      rust: Add `OwnableRefCounted`

 drivers/android/binder/page_range.rs |   8 +-
 rust/helpers/page.c                  |  10 +
 rust/kernel/alloc/allocator.rs       |  21 +-
 rust/kernel/alloc/allocator/iter.rs  |   6 +-
 rust/kernel/alloc/kbox.rs            |   9 +
 rust/kernel/auxiliary.rs             |  10 +-
 rust/kernel/block/mq/request.rs      |  19 +-
 rust/kernel/cred.rs                  |  16 +-
 rust/kernel/device.rs                |  12 +-
 rust/kernel/device/property.rs       |  11 +-
 rust/kernel/drm/device.rs            |   9 +-
 rust/kernel/drm/gem/mod.rs           |  16 +-
 rust/kernel/drm/gpuvm/mod.rs         |   9 +-
 rust/kernel/drm/gpuvm/vm_bo.rs       |   6 +-
 rust/kernel/fs/file.rs               |  23 ++-
 rust/kernel/i2c.rs                   |  13 +-
 rust/kernel/lib.rs                   |   1 +
 rust/kernel/mm.rs                    |  22 +-
 rust/kernel/mm/mmput_async.rs        |  12 +-
 rust/kernel/opp.rs                   |  16 +-
 rust/kernel/owned.rs                 | 378 +++++++++++++++++++++++++++++++++++
 rust/kernel/page.rs                  | 206 ++++++++++---------
 rust/kernel/pci.rs                   |  10 +-
 rust/kernel/pid_namespace.rs         |  15 +-
 rust/kernel/platform.rs              |  10 +-
 rust/kernel/pwm.rs                   |  12 +-
 rust/kernel/sync/aref.rs             |  87 +++++---
 rust/kernel/task.rs                  |  13 +-
 rust/kernel/types.rs                 |  12 ++
 rust/kernel/usb.rs                   |  17 +-
 rust/kernel/workqueue.rs             |   8 +-
 31 files changed, 828 insertions(+), 189 deletions(-)
---
base-commit: df2908090cda368b01ff43709f51890076c56157
change-id: 20250305-unique-ref-29fcd675f9e9

Best regards,
--  
Andreas Hindborg <a.hindborg@kernel.org>



