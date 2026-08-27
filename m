Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBE1EC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E50CA6B008C; Thu, 27 Aug 2026 05:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E28826B0092; Thu, 27 Aug 2026 05:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D65A36B00B4; Thu, 27 Aug 2026 05:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B55776B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:50:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3297516036B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:50:00 +0000 (UTC)
X-FDA: 85146578160.05.521E8DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 93745100003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:49:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QnxwIlmE;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787824198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=okdYwXge/FY7cpxLUHBxfPZDHCIFHA5JFploqVuKJS8=;
	b=sQRipFjmGME+4Bqn/gY2agW+7HUwK1SUFd1nRKNmlhUWpvo1NW7yrWWlWjl4/vHFQXa7mw
	oKL6SHD4gIo2frAL85MYN8EOUhhYf4+jXJ3RJoKzCwAY5gY+6MT6J2wNwTlB+ZEMeFOKUB
	9vdsxp2rPPqq/3POYgVbbT6OlC1wWMg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787824198;
	b=kp5/5QkDkHyz6JUvM2PNnRHzodEylc2Vt6TUXSAz7ZTSObHX5VPGvebB3UDF9mcRLlsvRx
	FCoY0GuVFg3TfQ6gvPFkvUJS6/eVjfAzEJcRAe7Lwnk4XYjxxBav2Adpv1uv/fijZveUCI
	CxgoJGHJvPd0Hyj8vZaGaknAJuNKfwg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QnxwIlmE;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 16D6D600D0;
	Thu, 27 Aug 2026 09:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC331F000E9;
	Thu, 27 Aug 2026 09:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787824197;
	bh=okdYwXge/FY7cpxLUHBxfPZDHCIFHA5JFploqVuKJS8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=QnxwIlmEKraWjzXLrsVBDdJtv0fJLC8qPJ56yWA4Cfu461hUx/ZuY2rlNWRlnH6Dc
	 FjbrhPIZ2b0AhNzzt2gK+y+q2bXm7DGnQ2cTFzTBM8O+Vfe7ua0oCTUUSTWCMS5aI9
	 GJjBhL+5asBl8AtTQ+ScdvFgT9AxHW55eTlILTwlOKCzPyTKpluXwKyIs9a0pYCNN/
	 +jOipGjh7IkYq2aqbv+g0L7iONahfOeaHV/Pf/Vb+zZ7sp2HeI3/P8CTQfnI1/1As/
	 U7HFVJcA4AG2c/1YuSS/TZZgcQc2o5wsm0Z04bEbzImw+LyhKJjXMEZqdkEdIR0yDQ
	 CzfktT7NAhAzw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Daniel Almeida <daniel.almeida@collabora.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Tamir Duberstein <tamird@kernel.org>, Boqun
 Feng <boqun@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry
 Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, Daniel Gomez
 <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 06/11] rust: xarray: add `find_next` and `find_next_mut`
In-Reply-To: <BEA4B094-7587-45C8-801C-A6F49E574EA6@collabora.com>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
 <20260604-xarray-entry-send-v4-6-965f6028790e@kernel.org>
 <BEA4B094-7587-45C8-801C-A6F49E574EA6@collabora.com>
Date: Thu, 27 Aug 2026 11:49:37 +0200
Message-ID: <87mru728r2.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 93745100003
X-Stat-Signature: su5h3w4gihf55qobzasp4ib61zzoy1if
X-HE-Tag: 1787824198-216666
X-HE-Meta: U2FsdGVkX1+K8UfOjILFH3Pj3U38kF/7G+QWcaeHxrc8pRTYxvRsMuAwIiOvmr04IC8KgWILkkAXDVsyH3merby8uj/ZpWzj5ykE9lWCRzO8zEjU9cuWg5acMTRDEU9uDo5grmcL5tYMLpVGNnv4fM3K2PR5x5HAI3Feh9rdsop6AetXDncbgx9pp1iSYdMn7cadDIoLDOknMWq25xjJzwdA+JZMK0q2itAaUvY+jj5z6exuL1u0bat1BTS61pbLNp0UZEXqzvL5N6N1xtwSALRsXNhnOZ5DIrmidwmhY+cPX4zB+wFgyFWtl8LyAiSEuensCyB0ynBvAt2OY/x2TGgPuuLSST6wO7viHgequsyCH54TfD43DXTbO1LbDkhE+Jbu634SA9pa1mtRKVzTNuSn4wO+YITzP7lkNPJEUk4U9Qp0U0gUCUvQpe5lBswovyz9d1OEJXym66XM6YaZ3ElsvdOUv5hTwAKmm1sL2KMWWvbKFVu8mSyxuiOPmznCy84vC3SJc0w8+Hh7QL0s4mXH6aUVC09kyxm5s/gyykb3UO7eg70SimlC/sODrTrg3dX0fJvVsWZ2ds5Gj1kKL8C4DFqEOxkZ3r6DUPQNUOfEnrSFcMg3JfNxyr1MbboWiW8CnYzwy86IfMyeRs7u/m0PrCYsFTVMFYcxUG0M70R+kcSKH3yLGIXaDmUUJr5BvydxBTnOS1V70zoDpN5i3Tlr4G7nYfpglG8lBOUbKNeBIKEXwRBitPGraq/r3Wsdaws7j1ZF0gV9BlF7iWvGUwTD9JHmwqy/DaZkjYXpPdfLHNQOmHQKWh9NlXImeYtZ5wTu7ZaMfiY4NlUqSLYCPubZEqCx4Mph/594/7ZtvwD6BLRXlZdUrSH85y4mn3pc/ymTQG2g1QckbD3i46dd1+1vhYCLrYvOihMMuP1G4UssW4SLxOOqZ7IAjYJjjqdIo0MAu2V+736ILDlwIIQ
 eaXkZl+U
 a2cl7iogYPujhRDU6s7GP9SW5qSCQo6Cl0e2YgzAekpBkxbDg3bavahTIRSfeadpuvF7Y+Gy+u+wVnTEhlCV6O6FURaCdiXUh6xE8nAdUmnL4snMGtr7AYQzytSMvbS7rKvAHr8NU5iST5jjzF7JenlBAMS1eDsiq8TEaCupbVPfHMuWKapzDZ22blneNs3QprRRfbHQ+XzzMd2IYnqeasxZbUGKNEiMpUJRfnAhzw9ftIPXQ/ATwo6GD+LltWezT351Cv8nrF9dzXoZM+4/OYzdQ9ZtX/P00P51bM9SpniIukAYZwQZAu5eN0s+O9m7HMu2FS020E3mTBcS07MRrTqME8GcMHvkzvqN6ceTiys8QSR0NbfdpUQRDVwfppqa2CVRLQO36tV4/lo4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Daniel Almeida <daniel.almeida@collabora.com> writes:

> Hi Andreas,
>
> I wonder if we can't hoist most of these calls accessing self.state.state=
 to
> the XArrayState directly? For example, I see this in a couple of places:
>
> +            bindings::xas_result(
> +                &mut self.state.state,
> +                bindings::xa_zero_to_null(bindings::xas_store(
> +                    &mut self.state.state,
> +                    core::ptr::null_mut(),
> +                )),
> +            )
>
>
> How about XArrayState::replace(new: *mut c_void) -> *mut c_void?
>
> Also:
>
> +                state.state.xa_node =3D bindings::XAS_RESTART as *mut bi=
ndings::xa_node;
> +                state.state.xa_index =3D 0;
>
> Could be e.g.: "restart_at(index)=E2=80=9D.
>
>
> WDYT?

I think that is a good suggestion, I will do that.

Best regards,
Andreas Hindborg



