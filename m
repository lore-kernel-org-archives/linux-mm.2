Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D785CA5FAD
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 03:49:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35BE66B0088; Mon, 28 Sep 2026 23:49:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E5C56B008A; Mon, 28 Sep 2026 23:49:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AE186B0093; Mon, 28 Sep 2026 23:49:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB49F6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 23:49:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6D093403D7
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:49:15 +0000 (UTC)
X-FDA: 85265419470.19.F01C841
Received: from mta1.migadu.com (out-127.mta1.migadu.com [95.215.58.127])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3C29B160005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:49:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fgthNkwn;
	spf=pass (imf08.hostedemail.com: domain of alvin.sun@linux.dev designates 95.215.58.127 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790653753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Fvp9hn8BwhRF0NAnwNtaPHEg1s+I/R+7YNBitZfoCQE=;
	b=76MRdV8YDxN1lP/hB06Vy4nks8nr33F+OJA40wzkkh7m4bfqMRjlr9zyzJRGT3Uz1POjpF
	FfaX8AQXxwDn+Q2ME2TXDi/RAhJvaifpw3RP/veFdwkppU0chN7fWYHJR3OGPR5LUoJZI2
	Z8cFgxYZ74+dL0Yi116FLgfRbHb+WXQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fgthNkwn;
	spf=pass (imf08.hostedemail.com: domain of alvin.sun@linux.dev designates 95.215.58.127 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790653753;
	b=uhXdYBdYUbkKqHALKltI8KHOGuqZOX8cFkzdsPru4HzLjusHPLXJ7a9gqHRY0B0rIeYK2k
	QkBkFcu7V3HG0Um9DoYqLnbi6FlyPMeEaWT6V75X0gGbx0zFynjZELX39dO8Z9HDm+6v/J
	Cq47Cb0ZxblZs4zBXQ/Zf27527WeBCo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Fvp9hn8BwhRF0NAnwNtaPHEg1s+I/R+7YNBitZfoCQE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790653751; v=1; x=1791258551;
 b=fgthNkwnHtTRZ0n18mQYOmug/n4yaFmTsfNWs97K9XF1iiU+YkoL7MZjDSevG/G3f/cv4638
 5Dx7VhOXVZie83WWw8fTY5Wqivzqyc4P0XuPeGIcBx7KwEdxmOeayPFIviBhBz/+cff9zSGAjxM
 3kS+HFMtf6D0+uDHnk4r6xCg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 573999a2c23f38af;
	Tue, 29 Sep 2026 03:49:11 +0000
X-Mizu-Trace-ID: 573999a2c23f38af
X-Migadu-Flow: FLOW_OUT
From: Alvin Sun <alvin.sun@linux.dev>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: rust-for-linux@vger.kernel.org, Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Daniel Almeida <daniel.almeida@collabora.com>,
 Tamir Duberstein <tamird@kernel.org>,
 Alexandre Courbot <acourbot@nvidia.com>,
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Lyude Paul <lyude@redhat.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
 Ke Sun <sunke@kylinos.cn>, Alvin Sun <alvin.sun@linux.dev>
Subject: Re: [PATCH v2 1/9] rust: sizes: add SZ_4G constant
Date: Mon, 28 Sep 2026 18:30:00 +0800
Message-Id: <20260928-tyr-ioctls-v3-re-miguel-1@kylinos.cn>
In-Reply-To: <CANiq72mdp9hS_U=Mtf5F6Qv8M9=m38xOXtCP_a4c_QtkwhpFEA@mail.gmail.com>
References: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
 <20260908-tyr-ioctls-v2-0-88bea777df67@kylinos.cn>
 <CANiq72mdp9hS_U=Mtf5F6Qv8M9=m38xOXtCP_a4c_QtkwhpFEA@mail.gmail.com>
X-Mailer: git-send-email 2.43
X-Stat-Signature: 438xizmu9fxshh4c79p3cxgoigc8x8sr
X-Rspamd-Queue-Id: 3C29B160005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790653752-741204
X-HE-Meta: U2FsdGVkX19+VxJvJfOmGhPCWe/K7VyYLvOA3ZmBaVDLQTCIGC/1sTkMSLyf63JAzheEhHuZp+GpbgrOe7XnmiLPmGpYcbBoKHt1DlIswfMNG5cXJa/TaObbt7se6PLiqf2ToAasECKA6CRSMWFzBk5uURqpOgM2y/LWs4z1tw2DfWEoObApuTE32TFhgxCo6ToIFj0jBX0CdkGVUgDmYuIgIor4xO/0evEusUfm9p0+52vMYMNZbhEop8mgF1UWw2bnse7KC9y3IBQNeZgXAWsN2VQKrEdKI11rE25CQPjgv5GESYEQ13h29cgfbl1gXVoidzy4iV1jcJUcgfwWvCdbmhpvZUdRY5lt6Eucqm4II0PXQC9NX04vMUIDxnKfzGMrhGR/0xeUa/Fx+yL+UgTwvqqI7qjLjfNH+iGGZBR2cKlzCEtSE2g+UlytWFVGZCCxULAwQGuHKaFhi3Ri/KoS5oq5iCJq6o80wcu6ltIkV6eDnphJNajtad3O7bGsHHHCnbaz1ZTYpWIY8u14V5Rl9yZHHaX7/HqrHBi7PkmEC3sNnpvyXWpnsMVKf6owdYRliURRExB5thylbDPTs+DGPyhAttEb7zMsKllBoxTWaN0UUFFiBtyF2OLSYtdikXEPat1qWNPoVlWgvhl8WQM6/jXfIJZkS8Y6olbUQ8s8wxSH8dWij4aWz5mhnapAtXLR7sZdd953zt2wE+qVf0wGQ+3aAoqnynEpgGsa1f6Vt/x8fU3OCgjZrZ8Deze49sUtm97bBUO570ksPAoTn5g592s5vAGeMmCLjc/g421dgSdmvrMc5JRvHh54KoQzXFNWM9ZUGL4ZNYZBNkQeMo8KhjxjZ1N2eADJGSb5PDpdbn0ZcIJaDlte5/CcX2i1wiWCTa5b9MYfQgM0hTD+AKtAL4WRSVZT/+iktAUPPtXyD4mpKhPgPLO0QH1T43ZlrW8TKQk1VFjI/9SgtP0
 PxtxGNUj
 vCsyyBcToZ3gJ76O61HV5PZqN6ChZgkqgIG7XNUMlBFTwQIzSVqonWak7boAok6dxdlRAQPve4lnR9BlIGMbKteVXi4w1H0gFV7WlCPuYl83RQxPNc9siK5AYtLg5p4c66pjIVXpCpHNOWZuzngtaMLwJNMckrSMJ4d5yWWWMO9mNJvIND1CdmZvn4tH6F3XhBmhOfEJA0GQtXqhyVBUE9aAidQ48L3Vu80AE/Ng2l/kiU0OuO/QG+D0ftl5w2aD2MLeE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Miguel,

Thank you for the review.

On Mon, Sep 8, 2026 at 9:47 PM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> SZ_4G is used by the Tyr driver when splitting the GPU VA range into
> user and kernel regions.
>
> The message should explain what changes, e.g. a new paragraph after
> this one like "Thus add a new trait that ... and implement it for
> `u64` because ...".

Done in v3 -- the commit message now includes the explanation.

> +const unsigned long long RUST_CONST_HELPER_SZ_4G = SZ_4G;
>
> Is it added here to be nearby other sizes, or something else?

Yes -- to keep the size-related helpers grouped together.

> +/// Only implemented for `u64`.
>
> Intra-doc link: [`u64`]

Addressed.

The Acked-by is already carried in the commit.

Best regards,
Alvin

