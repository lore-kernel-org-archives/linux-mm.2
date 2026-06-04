Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36BAACD6E6E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 20:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85F246B00A9; Thu,  4 Jun 2026 16:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836926B00AA; Thu,  4 Jun 2026 16:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74C9B6B00AB; Thu,  4 Jun 2026 16:13:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6299C6B00A9
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:13:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25C3C1C10ED
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:13:58 +0000 (UTC)
X-FDA: 84843331356.29.2EBCCDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3877E4000C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:13:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SCXjgGkY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780604036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iEosbdo8+RwE9O2gAXCo7UD1DvXDlYZ1z4p74PZJVYE=;
	b=NkQVBzYpBGCnpmGe4GJriYYkpnpjgCKjy1YAN3rGdhqmb+7RD/2usrrmOuNF7XnhI2qCsJ
	EW0luwOJMPzbAoZP+LsaREqcYmy5S5k/cRyPHkN+l6T5/VGbMXs1003qCvkxg7rtg6AWLS
	gIvXvzXZXKENAGTAEdLqhBCJbg4IOoA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SCXjgGkY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780604036;
	b=EjDiuwa8R3hCxPL3FV4pwCOX8DrKt+N273XA0tm5ua+8Euo0UFtS0ZzGzgPvP/XlYJ0FF4
	WJ6CnIaiAiL+E5OSpuX4ctgZuN/ccxLDKhi5nxgoIIz2dTwlOv30DwaqYQzdhmZDCjsPZb
	cvW1G9Rpwp0t5K112onFISF/0FzShGM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D09140B89;
	Thu,  4 Jun 2026 20:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546761F00893;
	Thu,  4 Jun 2026 20:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780604035;
	bh=iEosbdo8+RwE9O2gAXCo7UD1DvXDlYZ1z4p74PZJVYE=;
	h=From:Subject:Date:To:Cc;
	b=SCXjgGkY9klJ2whW1nN+WG/siGeNqShjlXzEoT8y1nTm3abpZRC/6tT+VdDSvsiHB
	 Y+4I4OieLkwUyYtXZoLBw6ZN0QuZJ1+jVCTQOiUwgS2UQLy1OMuZxqNDdd5ZKJwhmd
	 R229vi+p6g716xfei+GTWn0VOv7Ub8n2j9sAjLCELU9s83jRVAXc56c2vIH8mv/DjN
	 RvmSKHdBktSga1hlaq5QkUmEK5CrKj5EhbqxEcnKFXwVT2p7kjkKdD/s/dA8H9P1ry
	 sjMmVe0qHBRfkN01wNjM3j1SM9xKa1sytSH82BmbdTymVMOVHj9wK1no3yfDGwFQ+G
	 sNqgGXq39HHMQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH v17 00/10] rust: add `Ownable` trait and `Owned` type
Date: Thu, 04 Jun 2026 22:11:12 +0200
Message-Id: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAODbIWoC/2XN0Q6CIBTG8VdxXEcDFJSueo/WhcBBWU0L0tWc7
 97RK63L87Hfn4kkiAESOWUTiTCGFPoOD14eMmLbumuABocDEUxIljNJhy48B6ARPBXaW6dK6TV
 oguCBY3ivtcsV7zakVx8/a3zkxTIvHcUEK7YdfKOM8tIaocHU1pjzDWIH92MfG7KURi43WrC9l
 qgrnYOrlGHK2n+ttvrnb4XaCl57azivXL7T8zx/ATNhN6YkAQAA
X-Change-ID: 20250305-unique-ref-29fcd675f9e9
To: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 Serge Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 Igor Korotin <igor.korotin@linux.dev>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Boqun Feng <boqun@kernel.org>, 
 Igor Korotin <igor.korotin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, driver-core@lists.linux.dev, 
 Asahi Lina <lina+kernel@asahilina.net>, 
 Oliver Mangold <oliver.mangold@pm.me>, 
 Viresh Kumar <viresh.kumar@linaro.org>, 
 Asahi Lina <lina+kernel@asahilina.net>, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=9900; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=sTJEzbuAi0Zql6Py8Z/jDXX8M9Qx3+zM6af7wQ4Ha/4=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIdvmrTmdF5aqYIvehEzXF9zXaGQMEas/k9vr1
 uB809TXHCSJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiHb5gAKCRD6UCkIqsW9
 0Bj8EACI88nBWOkKs2RydXJUXuaKjHXOVIUS8y/+LGdzzLU/s37Hhm9CxZGUpySo7vWoN97di+y
 Y/6yyVCZtZpXuf4qaKW/KTLUAcgN783OqpHcGefKsTtYP9UbNOGBQq7H1GSEAKmhrgPHydEFtKj
 WAxsKBOpapBn5/gh643BeoWBRxXLR5yE1f0yK9GZ4dPaX0/BR9GXvDWeZ/duesRhvKtj7GOdWyI
 DrgySEUWxn3Jwcw7XY/VbJM7Zwfbpf5ZDY9WjSU5uSfyPM6gjfw/PWuCpfQQy6r5tOeoC1QXkXz
 YHiYp8Xn2qPlNbddLpL2elIE5iY5B0B1DnY4huQW8Uo3tHnsGiUnZpbDorM7Bps302HSQRryGUz
 e91dq7BVaz5EaymnhiT7DNaYZtOtpqcpjYJ+PHnTayn3O7ggvD6m/5Vrn6WFRNy6kpf7ltplGEh
 d5TEcb8P0QIzRxDpTelp8YYFt/B3szZ2hIrRIdoZUQWzIekOn/68jHznvri7JC7erY1yVJlzpqJ
 aFp8o+3yMW0P9sQjGUWWCMhGKF8yaimQd9Fx4+hHcanCozyTUmZZ1OhL25HJIXtqCoLCh4QFtpR
 FYF5tMqaue7JFRWcNgikH7S2NxU0x2MXW20aEwAS/GqI52stKJ7qbRa8+ura2IVvy1aaGdhHt3x
 D9l27m4irH76txA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: a4r83itim38b86w178sncacy1qetc4j6
X-Rspamd-Queue-Id: 3877E4000C
X-HE-Tag: 1780604036-434868
X-HE-Meta: U2FsdGVkX19kAe4OydS/zBBjhfNnEFmg1HB6sBA3VtLc4eo0E0Yezp8ewoG56hoBjCDS9hqSAwAjlQxjf3MnQGbgc2dBXa3HX+5rlmQfbPcxyjKsYU2GO9Q2aA7sV3hGKTGedu1322C8pu/ln40/jggkXuGsMmXeTcKqsYTQs0ho8ZycVK/kuLOurmZ81Kynlp4L0xKpXremWv6QYoMZgKjgGevzV8ICbXuarPEAFQ2o7CMxB/aGdaLXaSAmljQ0mrltQmWjwQ6UlFOCKSDJESPqpWhKqkVbzTZU4rjgDmvavii9BuAHNpCNFIrzIfOZiHGIarQ1pbAiK2vc5VjeASp6u46WjKcrP5iDlagqE/4vyYjQeqA2EZIjH+tXifJ3T/LbJhnNWikAJRg19SAHPv1Ei6uud1+4UUtLFLYqN0qUmcyFByi0HBKXtJN7N9Id0IIS779mRGfRzpJLJtddMMlYgPtDDmwsd4tYBSDgQbu2okHSNZcxs5mQWbWOV4/uNn0JZwSZkngBtImhwtz8MiebTLpr8HD8+WqsLYvl5nRduktjwcgSMlqZJmDL63EluRFg16i+jL7QNVP0jkPEi0/ao37mI7M9c4W8n6TLkXTEazVjxhy50wFJJKXiZKiO7jSx3b4I8gl1o4WR9M5AwFT8APYTlJEuYjx27UIGvFddCccnP+sY5RdehXPE50Vk1KTjngz/i/WAs9TTyIQ/FEWzIy9UOUhy7pnbCwyR3SrBnUEyC4yYsgQ5/DYkDIyh0lzky0Kp2RvoMSjsR1SLt4WQ3Lt393z1zDoFK4tRNdHRqY/0ITmnPN+LctvjBpVa1DqMbRqn1EFCDn6aP+1yX1wUsanocha0Uen/Bc8x5DeDObgu0K9Lcfui2CpmWtNVBK3uWF9+EE284u31pnem3BcMNlMIf77bHCIY17fOYGJZtkl7t1PuCMP+GJrqpaRgqhr5uDAsKue5BNT7ZlR
 zNRWIeZq
 PH9mQN/KHx3MjNYh2xrhoBN2Ub0k3F7asO46CDeVnu4JR1tDQERUnq4/ZNTss6TTd/+alNgCampWiYGTzbCOUSwtPFaNv0scqIpnrh4JxNh5/HBu8DOJF5wzpxT22a25YF3W6FGFWIKeKDtwo8lQ2EaoIWgoOqd9J5Lar5+ZemxZgg3Y6bHmi9T4bYy+qSnM0woUSej+rEPffrutyAqlwlwpOCyq/Nc4RQQhY+qh5kEQZNMxzJSyjd8Y3YFGH+/qcPkgiPFmhhgj4q63qgdGIiGvtiwPvjikTq7sUBfK2n2BgTbWej/0vxYxCZ/L/Ufe/vwL2QBUn2n/KN7cnrjbr46aFLeEPJ2OeYV9F8YtJHQg/rKnAtxQWXzklaGEoB3E6byLyV+E3+e7XSKp2tGkB7OKlf0sz76BzCGeCLvVKC3vT0AHF2KCOj1dmlfycoX5mCXvjiA0YqQUd7X3ZSRfatE57kfOyvE2wxz4h9KoOchDSOHwnKkpFvfYkWsvU8tlZUNcaKtq1uCGvthQWsZIncmOpHfT+rzCjmAvztLC7zRHffeoSbuS+vxMWpp4wjg72T78+a/+so1CCA8RsaquJaaH35vR9osJbRp+j4lM+kV5Pk2Jhftytna8/p0njuADZOW7SVtp3rElR2hliTPlVQJsRyGwtrrXwdgjgUSSLKumNEVkCZOug3IPrX12TyeaoSfPzaVrNRaIFeTpM8QPN5ZOYkjRinY4QnV2nvz7vJ86Kf9SoobNdT8LfTvZv7pOUOZQBJhAQ0uCo4rvIjHx6P+PPAO7YesO5TsFbBtuvIRWn98BrxIw/i+qt5ud3mwmWqLRytTAia1twh61dBADDdvmOipTABPSjlQZ6+3cg/qN2tRsWDoeyFV52ZTcKvLNeYeLtATrs2oIeUw29sKjLvA9wgL0SbvjVdWHhc9TjGNtJLj/WYrZVcV68L9PvvW+9vO2WqBWSzF/o8tvupboXm9O1RUBy
 JFE0/uCw
 +u9MEcuGwv+zxfFzc72nw4kBDY1hZvRpLlbKwxfQ3f0+UmbaAPbqz85USQqWjAeYU3WcIWDXoder/ur2t7cIGczY/e2ZxDDAyWSwnPH6q3NxDboRhojVj/vLR+dDV7f3ONxzxNY0tx8Xd2SHPeqUVZYEmsNV4EeAE7fZHfE15DzIRrkVCrjJkw==
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

Convert `Page` to be `Ownable` and add a `from_raw` method.

Add the trait `OwnableRefCounted` that allows conversion between
`ARef` and `Owned`. This is analogous to conversion between `Arc` and
`UniqueArc`.

Patches 1-5 implement `Ownable` and applies it to `Page`. These patches
can be merged on their own.

Patches 6-9 add `Ownable` -> `ARef` interop and can be merged later if
consensus on their shape cannot be reached.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
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
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rafael@kernel.org>
To: Dave Ertman <david.m.ertman@intel.com>
To: Ira Weiny <ira.weiny@intel.com>
To: Leon Romanovsky <leon@kernel.org>
To: Paul Moore <paul@paul-moore.com>
To: Serge Hallyn <sergeh@kernel.org>
To: David Airlie <airlied@gmail.com>
To: Simona Vetter <simona@ffwll.ch>
To: Alexander Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
To: Igor Korotin <igor.korotin@linux.dev>
To: Daniel Almeida <daniel.almeida@collabora.com>
To: Viresh Kumar <vireshk@kernel.org>
To: Nishanth Menon <nm@ti.com>
To: Stephen Boyd <sboyd@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
To: Krzysztof Wilczyński <kwilczynski@kernel.org>
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
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

---
Andreas Hindborg (5):
      rust: alloc: add `KBox::into_non_null`
      rust: implement `ForeignOwnable` for `Owned`
      rust: page: update formatting of `use` statements
      rust: aref: update formatting of use statements
      rust: page: add `from_raw()`

Asahi Lina (2):
      rust: types: Add Ownable/Owned types
      rust: page: convert to `Ownable`

Oliver Mangold (3):
      rust: rename `AlwaysRefCounted` to `RefCounted`.
      rust: Add missing SAFETY documentation for `ARef` example
      rust: Add `OwnableRefCounted`

 rust/kernel/alloc/kbox.rs       |   9 +
 rust/kernel/auxiliary.rs        |   7 +-
 rust/kernel/block/mq/request.rs |  15 +-
 rust/kernel/cred.rs             |  13 +-
 rust/kernel/device.rs           |  12 +-
 rust/kernel/device/property.rs  |  11 +-
 rust/kernel/drm/device.rs       |   9 +-
 rust/kernel/drm/gem/mod.rs      |  16 +-
 rust/kernel/fs/file.rs          |  16 +-
 rust/kernel/i2c.rs              |  13 +-
 rust/kernel/lib.rs              |   1 +
 rust/kernel/mm.rs               |  15 +-
 rust/kernel/mm/mmput_async.rs   |   9 +-
 rust/kernel/opp.rs              |  10 +-
 rust/kernel/owned.rs            | 361 ++++++++++++++++++++++++++++++++++++++++
 rust/kernel/page.rs             |  62 +++++--
 rust/kernel/pci.rs              |  10 +-
 rust/kernel/pid_namespace.rs    |  12 +-
 rust/kernel/platform.rs         |   7 +-
 rust/kernel/sync/aref.rs        |  83 ++++++---
 rust/kernel/task.rs             |  13 +-
 rust/kernel/types.rs            |  13 ++
 rust/kernel/usb.rs              |  17 +-
 23 files changed, 652 insertions(+), 82 deletions(-)
---
base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
change-id: 20250305-unique-ref-29fcd675f9e9

Best regards,
--  
Andreas Hindborg <a.hindborg@kernel.org>



