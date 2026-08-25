Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C445AC61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C223B6B00A4; Tue, 25 Aug 2026 09:02:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD2346B00A5; Tue, 25 Aug 2026 09:02:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC1826B00A7; Tue, 25 Aug 2026 09:02:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 896746B00A4
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:02:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 03C2A1A03EA
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:02:11 +0000 (UTC)
X-FDA: 85139804904.09.2D55B31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3962140006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:02:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dkp00pUl;
	spf=pass (imf01.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787662930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VNcoz4Pw6SFuZfea+o/jo++KMcxe/kAZME+DPG+fZOo=;
	b=mnYtTXgoUji+KcqcwkIiitf4utfuKvF2k2nvO1A+ZXFSHQTovOzRY+JHMLPYKaCZ1609kd
	S9PewaBgvyZKTEdr0p6HhxBDl12wMRiqPXLdhm27crHIbIr+de0/MQRcXd8Aw2cp3/BdPO
	PHbX4VucrQXOtLpAJGipyGnUWLpDBCQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787662930;
	b=NrBt7hVDlCoCJYGMUkSjgfqYIAHqiO5/BzsZjCT0G/FOXtN67zHfXwOf3hrtKosCFwn4/c
	ZWwkq5ydjMkAkN1w/zLSeoeAm4BdhhkBG36LOFAJR4ogeULfB6xSRZQsrZsaQE/ESjmdDo
	5AJVtzuQmtUAuqE3Wt7edbnESrkIaM0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dkp00pUl;
	spf=pass (imf01.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65B866011F;
	Tue, 25 Aug 2026 13:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1972A1F00A3F;
	Tue, 25 Aug 2026 13:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787662929;
	bh=VNcoz4Pw6SFuZfea+o/jo++KMcxe/kAZME+DPG+fZOo=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To;
	b=Dkp00pUl9EQ7kOKFQgqA2AIpvWU64bXsCrPAHo2qX5sNnLEOXJ5aBfAY6fhEeaYrk
	 plBRhMhwwqmDXjQzXoAF4Y9UnaE6++ghDotlTwDLqWYKco+ySPZ81338ywjIpV8Yuh
	 kG5jEQvKZwhGsnHdrk1/trpBPttTYxDHgVrm53gWUteDdiXjBJVIq/kI3zv6QlPkIM
	 2f7Z1LsZE/FhsO0XeZBWqSuG8SmpE0fgIDqpLmj6Z7m3FMEITvXj/nUH5oYfWO/l67
	 T3X7eYN53W8nSAZXwL/AS8OsYKZ0bU6cnO/xBj/O/fGL++eW5F8VDSMJZSXdfvsV0M
	 Vf4P8RYBCMHAw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Aug 2026 15:01:57 +0200
Message-Id: <DKY1M6ZZENAL.152ELCOMXURCU@kernel.org>
Subject: Re: [PATCH v20 1/8] rust: alloc: add `KBox::into_non_null`
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Uladzislau
 Rezki" <urezki@gmail.com>, "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng"
 <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>, "Trevor Gross"
 <tmgross@umich.edu>, "Daniel Almeida" <daniel.almeida@collabora.com>,
 "Tamir Duberstein" <tamird@kernel.org>, "Alexandre Courbot"
 <acourbot@nvidia.com>, =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 "Lyude Paul" <lyude@redhat.com>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?=
 <arve@android.com>, "Todd Kjos" <tkjos@android.com>, "Christian Brauner"
 <brauner@kernel.org>, "Carlos Llamas" <cmllamas@google.com>, "Rafael J.
 Wysocki" <rafael@kernel.org>, "Dave Ertman" <david.m.ertman@intel.com>,
 "Leon Romanovsky" <leon@kernel.org>, "Paul Moore" <paul@paul-moore.com>,
 "Serge Hallyn" <sergeh@kernel.org>, "David Airlie" <airlied@gmail.com>,
 "Simona Vetter" <simona@ffwll.ch>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>, "Igor Korotin"
 <igor.korotin@linux.dev>, "Viresh Kumar" <vireshk@kernel.org>, "Nishanth
 Menon" <nm@ti.com>, "Stephen Boyd" <sboyd@kernel.org>, "Bjorn Helgaas"
 <bhelgaas@google.com>, =?utf-8?q?Krzysztof_Wilczy=C5=84ski?=
 <kwilczynski@kernel.org>, "Pavel Tikhomirov" <ptikhomirov@virtuozzo.com>,
 "Michal Wilczynski" <m.wilczynski@samsung.com>, "Ira Weiny"
 <iweiny@kernel.org>, "Philipp Stanner" <phasta@kernel.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <driver-core@lists.linux.dev>,
 <linux-block@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
 <dri-devel@lists.freedesktop.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-pm@vger.kernel.org>, <linux-pci@vger.kernel.org>,
 <linux-pwm@vger.kernel.org>, <linux-usb@vger.kernel.org>
To: "Andreas Hindborg" <a.hindborg@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20260824-unique-ref-v20-0-490735672187@kernel.org>
 <20260824-unique-ref-v20-1-490735672187@kernel.org>
In-Reply-To: <20260824-unique-ref-v20-1-490735672187@kernel.org>
X-Rspam-User: 
X-Stat-Signature: xeqfgf6ucrq4b81dkazkgr7rnmqgkwfr
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3962140006
X-HE-Tag: 1787662930-671993
X-HE-Meta: U2FsdGVkX1/M+32XwsIhhNX9yCUeSWZokdUCyuo4K5XKj1ENBKtvvJtAsxVscd0wYOJCPK1bh3q8I8zKXEaMt8ZwR5SfQK4sfJ+iZAxqptPcedcx9kqjFZfXFg3Qd9czYfxQoQpzz3N8fhQMgkVjT8tlUX2J6qIoh7+yX0kkXZL3tNWuINYLJBGN37D2zA1zSdfWqt40IneSCGgJ5ZYwlv/8YRKee2u0iLUJRvTmz/fROvh0g+YCwOioeVKv8HdgQvfidXHUn4IkhtAqdQ9QM1T1cQqSy8OyMbeEkNO/MdsjS8oHe6+g3s1hU6/XoVLH6im+AbnL+0+R8q2I1D9VAiTPACvf6wTmR/PTY13idph5inbXB6sR25/NU7YjJ2i9Vw/pzkmgWDTK4yBGLRxnp7DdXVywXUMtXqISNHNp9PehESGEHtZoK/589jHFptrg4+RF0oY8ATFOlPYehoEFFbJi82QiAadyki2Z2EIND4O8jJ3XGnwe6ns5KL+AgQZzH5YdVfvBw4RVqsMeFRBjbzj0/D38ylpOn53/98ZyEJrGZ0s0HD0MKfQS1J55QsyvmuBPLP2oB4qivVenlj3xEcBPHgjcWjYfMR3rqAcwsVqeB8WQ5da411XrSBiBU2OYjjDqabPNDy1b9IC9IL7AZ5bBhOaiGHs1mLt4D0PdDcDs9J26ZNZcI2lPcPuEO1MDkZHuUHYH2pNcRfmLbxK5BevKwz7Vi+E9GdBQJYl6qUNQrpdARNrbCgzaxmla9omaaDp0Yj4nYM4lpfzIN69SHnlo7FiHrxTyH+hc4xz+l7aaVWfMUZxREZCVP8YJLf51AqWjDzjZ+Q8/gm2U3yan0PBt4cXTCi56ZjeQ1nyizXq1Q51mfOjtg9+aTEojHwsyZFTSI94h8ijiSgFu/XUZcbnA/a8StCx/aswgbUgJrJgPGAmf/kcNtl2cfPzj9k7sglOEA9Nn58GyEJtKO7m
 XCz+are8
 xKGuOacWzKx1Iut2wJ4SlERJWsvNXg5zkebJ3WYg1Ru3VAAVnZJSNP4Rgu68cmyr8jOfgCxbNJw2R3reBV+Geamsy1SSLB3w8vddfx6fn8LJ7zCC0CHoGKpXZq9NGYWPh01doh1X/pTHNFB+hdHZwG+TzBUGcmTzyju+hrv022Bl6sp51NEeNX4XLUBS32IKToELiruNQAUq3NZkrin1XCM/yPnfqSVWxkTvjO1vam2mOjK9zSuDZR4fO3Hbhu/cwpkNFmlgFLJxeJlIw7ptSFM4VPgN4fAeX9OJfSPXjZ2w8N01bsAnF82ThiOswpc2d4XrIbk3Y5MqTbCk2J8mr3daYC64JUrGZazMjhEG7XrIYlFnRpN09d+XcAFeoQNq0kPfwoXjKKJCu6MqgAEkTPGijDUE6X4aXCV04DJgbq0JC2Jt+X6lGUtgIi5jcai7mK7qXBYcMHQgI2kkhIlTwAutMqLEy1zJVCAQr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 24, 2026 at 1:17 PM CEST, Andreas Hindborg wrote:
> Add a method to consume a `Box<T, A>` and return a `NonNull<T>`. This
> is a convenience wrapper around `Self::into_raw` for callers that need
> a `NonNull` pointer rather than a raw pointer.
>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>
> Reviewed-by: Gary Guo <gary@garyguo.net>

Acked-by: Danilo Krummrich <dakr@kernel.org>

