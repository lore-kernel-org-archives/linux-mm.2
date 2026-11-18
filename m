Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7C14606A337
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bAu+g7DZ
Received: by kanga.kvack.org (Postfix)
	id A00686B05C8; Wed, 18 Nov 2026 10:24:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D81A6B05C9; Wed, 18 Nov 2026 10:24:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EE1B6B05CA; Wed, 18 Nov 2026 10:24:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6056F6B05C8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:24:04 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C97551C419C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:24:03 +0000 (UTC)
X-FDA: 85448610366.09.5815DB3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 40AE9140005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:24:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bAu+g7DZ;
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795015442;
	b=Rcf15vtwS8fQy541xwbL0vF5w5wC/cRnQ3SAxVH1Ip+1IHnwsCFItY88p4HTbBcZ/oMDxZ
	2gxh2yZ+dQMFkKt0dsdqKo+/N2A8dsxrWCd62kqDkF9vk41+4TwVAnXtickPnjdfSHmEx/
	yBmvi9teJ3D4ofT07Do7R8aOAb2qxf4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bAu+g7DZ;
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795015442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RQcOM5LZ+A50DskRP5nF4QpJYB2S5F35ZVxDxecyXLE=;
	b=I066cT3RLzEN4B1dgBdA5PnEeaTwH0hETVsnid10ftXduwr8UoikYETgGeVYgc9aabkOZf
	oZ+e2BjUU5uWGg5vb+A3y8B1BGyJRf91dnKWWWUVwN096vgHXO0QBNhsNtqbeuR9Ub+bL9
	UkSFKUKE8PWXYVyYSAnFK88VubfqZpQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78953623A2;
	Wed, 18 Nov 2026 15:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C755F1F000D0;
	Wed, 18 Nov 2026 15:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795015441;
	bh=RQcOM5LZ+A50DskRP5nF4QpJYB2S5F35ZVxDxecyXLE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=bAu+g7DZw3J/d5gjI5fKw3TQ5XEKjEBdA61DLneCyxO9RyQFJT6NDl4rp2J/zIrby
	 UTRU6hZ4OvYXpq9U96p5J+Jp0RqsBkW0dTjYTMVk1ETfP71i70Qnb9En+xPV1yXXsM
	 5MPUfHlg8dz8XISX3fRv5jql4mAeUyn4Tlx/96Xz6lR1VVeDlDm4SXsJO7iB0jBfqG
	 iACcY4jLn1auGGi1XCeSv4z5KNXdBIdEAld5BQoR4aTSY6tmKz9mgq8ojXPiafJAk1
	 II6HR8YBy70CWBDAWiWqZVZxI7NoTPmt+kZQo2OSHntI+1N6AGCuaBk5PS6wXtHDQ3
	 KVcn3u0OBQG1Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Vitaly Wool <vitaly.wool@konsulko.se>, Jens Axboe <axboe@kernel.dk>,
 Miguel Ojeda <ojeda@kernel.org>, Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Daniel
 Almeida <daniel.almeida@collabora.com>, Tamir
 Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>,
 Onur =?utf-8?Q?=C3=96zkan?= <work@onurozkan.dev>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R
 . Howlett" <liam@infradead.org>, linux-block@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Igor B <igor.b@beldev.am>, Vitaly Wool
 <vitaly.wool@konsulko.se>
Subject: Re: [PATCH 2/3] rust: page: add reference counting, raw pointers
 and a private bit lock
In-Reply-To: <20261117233211.3137168-3-vitaly.wool@konsulko.se>
References: <20261117233211.3137168-1-vitaly.wool@konsulko.se>
 <nJAtLmDmAV24rOe6aN54vqMAgr06LVJtplZTvmqfydTzMhml3convxW0wdHq0nMHqmRM7qsioK1kV78UIwCkzQ==@protonmail.internalid>
 <20261117233211.3137168-3-vitaly.wool@konsulko.se>
Date: Wed, 18 Nov 2026 16:23:40 +0100
Message-ID: <877biaups3.fsf@t14s.mail-host-address-is-not-set>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 40AE9140005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bs3yozbd9ja4yrtgg8f658ythj6aw7rp
X-Rspam-User: 
X-HE-Tag: 1795015442-406693
X-HE-Meta: U2FsdGVkX18iIj4XXr9+zy6kk17my2Y5DAWjZD2L04tG8U5VZRUUdP+/NmbDtwTOYpp7w8z0+QbJ/qNElWQOrT5wfU5KipcBujXhB8w09Fadac/hjuijlCszVHfBMuAevWwdcmiRjk03pYQYDoJiiyylv3RYVJydoseWuoNlfJy9/DHuOVipidrcc2GxEDysXAS3kSFHl7BMDOkbDV4Uo/F14P4EC2QK8GMAVPr+V5AntMFAvTtCGBR/REOigqspyWSn5FhL8Nur6ZyfeH1sJvFUzYxKZk1Jl6H6QbzbQ08nP5RrgUodQgIpwqD3/g/4noRW6UMqU1smBtG5yPqU9qjVdsfp796pDVfrAOzjYsQkPzM3fIn25z+L72DVmtel7NUCDsTu5lv7e4pnTtr2s/wLeUdQM+oCNQw6Dp4XejDUVuiJB1Wh52kbzr7GHxquT1F3gF/TQG/rS+yC3YYmvoUeEdy+e2ECKQ9NgkM4upUTekOAwd2a7zryCnMQicwCkFPNx6ehB4KGiH2MUXJl3W/Aw6uex4PlJ6wdB0kFgBIWj0Li91M6DRvfgiNNysrW0P4SaxOca9V0xuDw79JT7eEZdMqcnRodbhYFCxWhN+Uy7oPMjXfnywYG3Ul3YvNoCwuL9GE6/aWsIn3IzEYsY+WWlwVvJkkDPnG61ic1i0P0DL964pkHW5Iv3hbsYH7x6f6l7U5adaCpdGTdaAWprPUS/grAu8l4w6w6VEyGWUnngyql7vkkp7P0XTppOAYnMRiEvSsl6znmS92vZMhO5LSZiewK74NW0d2tz8IH6Faewpo++LQoor5pc4RE9ZGvaYRItBIIe39qE7Qx0kImuiGZFIGD3Wgf+tLwTPUOcKulah/EHg0ZI4rsMY8xA0B4G7oekujnGXn1SDVNuvmZOqDQWfDgCthgJr4moRYf8hXAX/rF396gU+2vKCoLGaMD7MDvtZCJXm2hhBm0U2S
 dlN3mEKu
 5+Xnbix1PviHAVl2/ULwi3uu7wObB7Lb6C6vLzSF/Dk8IKrJ2GXDJINuPYNMqXDUjAsqrpZQsUPPfVrvqEmrR8vBkO/pWlEsD7GGpwJM/IfKptX3j4NzXAodGNrJO0nV3YQOX6/HfvsAPxE/GSvJdYDBCig9tLF1IDmuNTQUnGMg0uljVjDpQJo4GqJ0bGGYaXBZlqTKDPfvmBFn1s5W8BMXu67FEbLfRbajOH9jgcV5n2MMAzpIFHc8wJtDvI3Rq6gBEXCIFR0z1vqg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"Vitaly Wool" <vitaly.wool@konsulko.se> writes:

> From: Igor B <igor.b@beldev.am>
>
> A `Page` always owns its page exclusively, with no way to take another
> reference or keep it as a raw pointer. Add:
>
> - `Page::get()`, which takes another reference with `get_page()`;
> - `Page::into_raw()` and `Page::from_raw()`, to convert a `Page` to and
>   from the `struct page` pointer it holds a reference to;
> - `Page::try_get_raw()`, which takes a reference from a possibly stale
>   pointer with `get_page_unless_zero()`, for lock-free lookups like
>   brd_lookup_page(). This is sound because a `struct page` is never
>   freed, even once its memory is;
> - `Page::lock_private_bit()`, which takes a bit spinlock in the page's
>   `private` field and returns a guard that releases it. This gives a
>   page used as plain memory a lock of its own at no memory cost.
>
> Add Rust helpers for `get_page()`, `get_page_unless_zero()`,
> `bit_spin_lock()` and `bit_spin_unlock()`.
>
> This patch was tested with the help of  Claude Code AI coding assistant.
>
> Signed-off-by: Igor Belousov <igor.b@beldev.am>
> Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>

I already submitted most of this as part of the `Ownable` work [1]. I
sent v22 of the `Ownable` series a few days ago [2]. I stripped out the
page stuff to send as a separate series. I plan to send the page things
this week. It covers both reference counted pages and frozen pages.

Best regards,
Andreas Hindborg

[1] https://lore.kernel.org/all/20260910-unique-ref-v21-0-e83257373062@kernel.org/
[2] https://lore.kernel.org/all/20261116-unique-ref-v22-0-12029383206d@kernel.org/


