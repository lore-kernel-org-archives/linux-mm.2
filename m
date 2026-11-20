Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D07C2606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=REeCs4jf
Received: by kanga.kvack.org (Postfix)
	id EA90F6B05B6; Fri, 20 Nov 2026 05:28:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E59086B05B7; Fri, 20 Nov 2026 05:28:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D47CA6B05BA; Fri, 20 Nov 2026 05:28:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ABA576B05B6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:28:08 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4248BC0E47
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:28:08 +0000 (UTC)
X-FDA: 85455122256.30.35C5C6B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8990E180002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:28:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=REeCs4jf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170486;
	b=a3ULLMMeMnSfWq4g/8xd7+vgjlhEnDVZ+P8VPRUN/U1OuqHPrQLxC2j66jG+rD+rsCBtCe
	qeh5zAkaOGnQB4RPzekxg6P9GM4Tb7Ob52zGGQor9XPkCFx4h/EUFeIsOBHSrVME4oyoAl
	JopT2s+Uq8Bbwf7TrI7GxeBiZ33i5qs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=48AW8ufpmYF1nS3yXygoenOKi7Jq3drTzHpOotJHiqE=;
	b=5FSigNnqR1Xw3ue04+prOwEMrmKvAkHzfSjP9S3P53ytBlJUDFEEW+oNJ8fzpxlIJGv8ch
	Tuh9bDKmz0WmjI9+IDMlZjlgDBCHAGz50DhrtfGHd9Iaa1JYbpOR+dKycyigpK9F7Dj4be
	r9ZAhrqtRH9TdgEarpe1t+/QzzXMHjs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=REeCs4jf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 27BF561D0B;
	Fri, 20 Nov 2026 10:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19651F000E1;
	Fri, 20 Nov 2026 10:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170485;
	bh=48AW8ufpmYF1nS3yXygoenOKi7Jq3drTzHpOotJHiqE=;
	h=From:Subject:Date:To:Cc;
	b=REeCs4jfsvaRVHdkJC3F+nPu18uiIUqdTOTu1Sh6pf2Z/ZOzqaaSt5uoldvT2ZYjz
	 l/9UiLLGYuT64ikUtVpd30rokihYch+N5OBU8z3CglWP2lC2WA92UVrFui/NmBZZFM
	 NFPnaNMe0SJMXzXs79bPKZSJvaJRl5nhE1SYX7t+3XhJEK4WsK6e+xY6nNyHwvRp5U
	 12Neaas4vOrDOM6KtiwDcSYVrDQCszYl+j2yY9/oKOViTx0DWkjR9KFTidiKY10Fhq
	 cFHT+Fygz5Ue3gEEkyDgcJIYn0P0wbJfigokZFIC9vz1mjxGV4d/P1ADZkEY6jFAqz
	 IYUqnIHIs/n1Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH 00/11] rust: page: improve access methods for racy memory
 regions
Date: Fri, 20 Nov 2026 11:26:59 +0100
Message-Id: <20261120-page-shared-v1-0-66f8c4c62822@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHMgAGsC/22PzW7DIBCEX8XiXCp+jMnyKlUO/CwNVWISsGmkK
 O8eEvdQqT3O7sx8uzdSsSSsxAw3UrClmvLcBX8biD/Y+RNpCl0TwcTEOQd6tn1WD7ZgoOD0uAs
 jAEokPXEuGNP11fax33Rd3Rf65Vnx4yh4WTtm2WzE2YrU59MpLWZo+n2kxQvyG2+GJ5xxyTZ4y
 0e7pGNfZcpUjAqUYjpI06a/OcUkU3Sd02VF2s+jAqIPk1YREEwT/6H6n2JD5e/Zuk4SCBpGbnf
 SiVdof78/AKMiYWU7AQAA
X-Change-ID: 20261119-page-shared-9b748d499e3e
To: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Mark Rutland <mark.rutland@arm.com>, Lyude Paul <lyude@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, 
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
 Carlos Llamas <cmllamas@google.com>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4331; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=BHZbvkAF+8qU1x9bBgdqAem+iRsGSMXYFrP9PxFuYQ4=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrACB6l33KQq+5JeQb6wqDk4/Mk3E/JfJxPT0gw
 ynOAk7wLZeJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawAgegAKCRD6UCkIqsW9
 0Ic7D/4klhWumsGm6Z/AMzRwWmpTKLugQFFa8ICICKWOF1HpFZcDglrZ92Zih5B8qeruBQfcpDz
 OyEfU92BxjXm+U+Na4qcFAJMyDVR8qppNtiT0ev+nx/gav7xPih/VIsR/LrZnh3a8rr1aNYlmf/
 sBRdhp7jwVCPBKjCdWdKTg+eA1tQMMeY6nH7r0U3netINDaJI/z76GwCbboIvTDRyJCtL4hHE4x
 WHUiDh8uN9HzgJ9TW5jIJQi3b3bV6HUMYEBJ1z5YMwHG3zJlcMTW0XO1BxwYxwEnATyX7nTmOyh
 oIQ4g55+mQJv8TZ7D59TzgcwlVzBg7sn4rFsrvVhbFdBxcTgT6UttkSO6zo0G8hc9JfsmlYV39u
 3M5bpzYOHMjNyy7Mse7t7dTguojCTsFYDeuH33riRj6DACcHRBLdTx0uh4Aj0dRtZ22cn962LlB
 GfL8cR6+2ayYrpjHaLpjDPfvSHeia7Ts7SSdNe31Xp+zjIjpwCzYj/fBknPnu/Y4WfBYN5jSPD1
 TP6+SL31CseIWPMjs9ShiabxUljaV2336LCl8OrTuJnFi5bKf7siHOxVMv5UtYBeGOUBInTIIdb
 xDw5GAmn5IsHG/rYbSoQwYBzUCQM8Iggj7lN14mx+HVCg1R/n+oRuVp9NlJoiSl+F+tSWNQs5V/
 1Q5q3ffUDZqbEbw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam05
X-Rspam-User:
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8990E180002
X-Stat-Signature: izn8w81wf7736z3r3sgo5fizr83ptqqe
X-HE-Tag: 1795170486-434406
X-HE-Meta: U2FsdGVkX19ncpWTj4NuLkzR0tYOuAbsx6KOPDKU/mZcRqM4K0ZtQ2bG8iJzQ5ljQKl3pCJ8h3kBPeo70LRquI70CvPwhU+Yig6Hv6yhJ+9odKW18NnDo+srzWOPX+++Z1b48Fe2/ajiVDOHGHzu4lWh60m/QCR9kbqoT9nWsqRc/S1JtxWYdzAamBd6THeR/KwKxlZrUkme/0y1OpxSjF5cztWBRLTE6legf9DaOaXmEK/c5ySHqoSof45bexXIyr+pC0+63pTC1b3PebHSQxbyODMXBJXJUXIUdyJSjz9WV74kuoP9XR5ZO9DC1bSKysBIuYtxoSR2zYPaTgIg2LrH9DdYeMG/Y+9wl8nb95kGTwLdzcA9lYXEKbZPqbTLfLCFBXuY44PG5qTO2UofD89aduGtegLT4do5zH9URalTpjp87LGPw+uCBFxrlo/vQm3cZMklwljZ+GrWDkQ0b3h4irI59A5YMXgoRkQre/8uYAIRxQ+sgX2sv3ZWGl/axdNgd0me9xCFkeLapL8wdLtCseK8HIRxKBTrDeEG6TZG28yisb5JHbhTLhTaaYzJFLXCjKA2IYSla9+5EbwLtSMTYEAMJ16Z7MfeDUS603x//PMzvUvExGvUj3GrP4tVWevZfFpJVDAQx89Fve4dlC3sXjfwk9Z8ym3Mw5nmn2zDPLfLegGoIPE4oGxaYPSVgEdi5Du+EwjN/X/QLUWbLV+gQnkBX7luv+5wdvT4WLpRyq0r0EUcnBiZIXNnFKh4DGtsHyZIMS82DxLpzBHPZLT403MTqFe0inQ3W7V3dYTeaItQ5x08wBswo7D2Cb/5E1ChJHEaAnMmCr+zpzUYw1EW8I+g1UOWEfWttq6I9cobiIez+E3+QScTvXkAp2dTm0WsewovbV8rpuP3YdoFc/PlKdiEOHnUVBL0daLzQ6/ZjLnea42fCFgt9GdDn8ChsAoL6mqAum5w6xZfCwi
 GO0VBoCJ
 73ghhFUj5oIwMs2Pm5UVGdP1HNxDh/2RtmpmWovLhapGoLJslzgvHvvAxSX/iekopVu1MaHSt3hFmgMlhfn0iPaoykymSX39Gs0BHbMHoqZSLCr1FnkHhijDSXhV1gsqt/H4xK1Bm4R4EQgRLybkX95hHLYLWDCo2tkAG6ZoAWkPlUY7hBuM1ilXCGCgj3DrMRj9wEa5X4dICAXn6XYZfoIUvxQ3XPwFUNpb41kuHcFkGDBFQDCaTDbJJbxOn5WSBuza+2FhsdreLdq3vDKqDU6mNW1OFCuKrnezl07BbOli9gRiWrWUiPcZAMaO9X/LY7tANpW+14zo8p+/KkTojVc+T7hxVB2BxhiBg4MbvF+CQKcEL4zHIaO1fZqt6dsP4xKOayTk2Iun5dr0K3bcNNTL/LJ2l6fVP/QZzmGvMh7aE6w6EuaDb+SlEUJaTwiA0h0/wf5ursopRBFXq4SfJvuKJrWsWVoCNo1eZxP5JQUymiOs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

`Page` has a number of methods for manipulating the memory of the page.
These use `core::ptr::{copy_nonoverlapping,write_bytes}`, which are not
valid for use when one end of the operation may be subject to concurrent
reads or writes.

With recent patches that allow pages to be exposed as `SysMem` regions, we
can use the `SysMem` infrastructure to do the operations as byte-wise
atomic operations, thus making the operations well defined.

This series builds on the atomic memcpy series [1], the `Ownable` series
[2] and the `Page` refactor series [3] to prepare for handling the pages of
a `Bio` in a well defined way. As part of this work:

Remove the `core::ptr` memory operations from page.

Add a safe method to get a `SysMem` view of a page and use that when
copying into pages from `UserSliceReader`. Remove code paths in
`UserSliceReader` that would make a `&mut [MaybeUninit<u8>]` to page
contents.

As `SysMem` is `Send` and `Sync` but pages are mapped with `kmap_local`,
add a `SysMemLocal` variant that is neither `Send` nor `Sync` and use this
for the views of page data.

Finally, remove `Page::copy_from_user_slice_raw` as it is no longer used.

The three dependency series do not compose without conflicts, so I have
provided my b4 tree with all of them applied [4].

[1] https://lore.kernel.org/all/20261113-page-volatile-io-v6-0-5603e527c919@kernel.org
[2] https://lore.kernel.org/all/20261116-unique-ref-v22-0-12029383206d@kernel.org
[3] https://lore.kernel.org/all/20261118-page-ownable-v22-0-d63ff73f4075@kernel.org
[4] https://github.com/metaspace/linux/tree/page-shared

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
Andreas Hindborg (11):
      rust: page: tighten safety requirements of `SysMem` copy methods
      rust: sync: atomic: add memset
      rust: io: add `SysMem::fill_zero`
      rust: page: use byte-wise atomic operations in raw accessors
      rust: uaccess: take a raw pointer in `UserSliceReader::read_raw`
      rust: uaccess: add `UserSliceReader::read_sysmem`
      rust: page: add `Shared` page kind
      rust: io: add `SysMemLocal`
      rust: page: add `Page::with_page_as_sysmem_local`
      rust_binder: access page data through `SysMemLocal`
      rust: page: remove `Page::copy_from_user_slice_raw`

 drivers/android/binder/page_range.rs |  35 ++--
 rust/kernel/io.rs                    | 151 +++++++++++++--
 rust/kernel/page.rs                  | 355 +++++++++++++++++++++++++----------
 rust/kernel/sync/atomic.rs           |  25 +++
 rust/kernel/uaccess.rs               |  79 ++++++--
 5 files changed, 496 insertions(+), 149 deletions(-)
---
base-commit: fd9230005e85472b81c1c7c16afe93dd878996b1
change-id: 20261119-page-shared-9b748d499e3e
prerequisite-change-id: 20260130-page-volatile-io-05ff595507d3:v6
prerequisite-patch-id: 112f7ee8c101c766ba33128a08c053ff7dd1bd6f
prerequisite-patch-id: 4b725c8c4d3313096ea722ac2866bd5e36227b88
prerequisite-patch-id: bf25326b450044d86f2cc7392f67d17d674afe8a
prerequisite-patch-id: acbb5d7f331c45b8da915ea32bef91447ac0b234
prerequisite-change-id: 20250305-unique-ref-29fcd675f9e9:v22
prerequisite-patch-id: 4e3c7a1a2077aaa0ece2d557fa73486355903ae5
prerequisite-patch-id: d1073c5dcd6287fbcba7848a5d182108930230c1
prerequisite-patch-id: 3244def11bbdf2eabaa6e94e15ce06540b2f5814
prerequisite-patch-id: cef14c5bef5ba519ceaf0a0e7c9e93ef974db7b3
prerequisite-patch-id: 56410da35ed8dbe7b210adae0985af705cc0b5b0
prerequisite-change-id: 20261112-page-ownable-2e97941a83b2:v22
prerequisite-patch-id: 4e3c7a1a2077aaa0ece2d557fa73486355903ae5
prerequisite-patch-id: d1073c5dcd6287fbcba7848a5d182108930230c1
prerequisite-patch-id: 3244def11bbdf2eabaa6e94e15ce06540b2f5814
prerequisite-patch-id: cef14c5bef5ba519ceaf0a0e7c9e93ef974db7b3
prerequisite-patch-id: 56410da35ed8dbe7b210adae0985af705cc0b5b0
prerequisite-patch-id: 7454d72e9d18045c4b45c3be614c51288c7c437a
prerequisite-patch-id: edcc308e1ba9596e7939859cb50230ca56f0b265
prerequisite-patch-id: 90fcb80e26232818fea9472fa83871b6577bbddd
prerequisite-patch-id: 10e8ae82a9750cd76b42754393d3e39b9e849474
prerequisite-patch-id: 881055f06785a8df0ec9f8107065428900ca78d9
prerequisite-patch-id: e0759f2b41824d562a594c9e2452bf41ba514cbd

Best regards,
--  
Andreas Hindborg <a.hindborg@kernel.org>



