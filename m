Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90152C87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 13:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 360068E0053; Mon, 11 Aug 2025 09:29:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3165D8E0045; Mon, 11 Aug 2025 09:29:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24E208E0053; Mon, 11 Aug 2025 09:29:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 14E498E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:29:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB3CF11548A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:29:42 +0000 (UTC)
X-FDA: 83764559004.10.F5BEE41
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2EA7220006
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:29:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W4gDQG8U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754918981; a=rsa-sha256;
	cv=none;
	b=RXmRVk788YyO1cNf1GYRV4VdqZIVPL0pmhDeMuXqVz8LxEvVIDIucy9sgTyxmyfzG5DCaD
	0AYqg+8RvggYUMeH+X05rcCHBV1T5Q5jXfjS+KPZmgVdaazUrEO2VPz4XWp8qmORS9OeQ/
	jbGeHRkw4s81EG+/dfTy8oEKz4arQGI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W4gDQG8U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754918981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tWrn+wPReluOay6jKgPbiSLpygpjZ4fsY4oQPbzsdnc=;
	b=ntoGmwt0DccicYQb0+6mZZL4rF49UF+PLnd8clftOy1Znk3l2iVHF1YePIsErajKZzs+9T
	avIxNZq+1sVhxfyo6JoY7bHY9cGRv4ixuAv83Ctbo77PTzoB/txcLlRxvJ9XuaUZTUMavV
	DESjNaZFfAFeeRsBUpaFXA6zr7z8kbw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 230BB60051;
	Mon, 11 Aug 2025 13:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D133C4CEED;
	Mon, 11 Aug 2025 13:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754918979;
	bh=tWrn+wPReluOay6jKgPbiSLpygpjZ4fsY4oQPbzsdnc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=W4gDQG8UbsccF4DaPC4V54uVda+9Q3ZSrPLN5Kxb/h8XnsU8QSqhIYxgcySxwgFlv
	 3TJaNxA1/OGx93NlaslZpWdcFyFL/EowPe9aNaT1O8IJgvie45RZTWa8oI+gVSo9ht
	 xgY5GJ09CBGeqJH+35sT4WLbkiLz5mnrlgmzhfbvkaehTboIFxsH9wDXnl+VW0UX41
	 B1lDvOTYw5027EYzV3FzhqB+cQL3SO4A+o31sd9JAQyp3w3BAuIN9ApIj/GL8idm+m
	 L8hTRdy6S570AVr5RZBJQplZ7yFzfphxWqR9BzPNO7s5NJIa5FYLrah0f/VmbfDE+v
	 fZzsLlFwhVWnQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Andrew Morton
 <akpm@linux-foundation.org>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Daniel Almeida
 <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@gmail.com>, Janne
 Grunau <j@jannau.net>
Subject: Re: [PATCH v2 1/3] rust: xarray: use the prelude
In-Reply-To: <20250713-xarray-insert-reserve-v2-1-b939645808a2@gmail.com>
References: <20250713-xarray-insert-reserve-v2-0-b939645808a2@gmail.com>
 <ZxXVGFugqt2ByHuv4YzuNyLfOkmahkJq-olAfJteFuvj7twpuzU4461l5hVOWldMI75V-uWr1aQpCtazPRYA0Q==@protonmail.internalid>
 <20250713-xarray-insert-reserve-v2-1-b939645808a2@gmail.com>
Date: Mon, 11 Aug 2025 13:06:16 +0200
Message-ID: <87v7muf787.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: rbixb5gbj6aqggpgzagfs3c6p5ypbi31
X-Rspam-User: 
X-Rspamd-Queue-Id: 2EA7220006
X-Rspamd-Server: rspam02
X-HE-Tag: 1754918981-566554
X-HE-Meta: U2FsdGVkX1+EJUM6p0CaJyjfJVrn82/Uowi9aGHrJrv0xtMF54WbIn609Lt4CGzGaHXIks1FUbDN4mUj0Pn1MHdfQT96ZHbItH/fPErUGVJTqzCAZWesEIcvUu4g8c5BuJuB36GRpIOjIPrn/rRRnOlUszzbmq6mwqqQNqa3/CuFVeIipl5guaoYbfL6SnDMUgqRiCOTFAx+jMMQ1H2eGGfLzsouzqEtKqogitgUrmTTfEAXjgU+ERPEMRE0jzNMJaFuwlxeP0SIEK0U9gCW7iEnAiwP0fq5rEMMPiNaxcvvkkzQf1EkKrblzWuPiJXHygJhP3aSp4vAT29OyGDYzBBO68L+Oa6SVnLim5HJnQd1fqJoJGyO5PdVscsR8wStXjtVb0z/BmWLszlcHbfOUiWEfIRnRgDgkB90T9w9nTTV+dTUkJLYtVrYbkFUjCw34rc6UWcWT0iwg7hWFgugjWv+9K6YNRar3CkZKX90EagP7vecCuRIG0mNN0dC/pCIAAbV1bjx/DCA/qaQ5XmhBWDaVyRPc9AGKwdvZl7B8u4zu1UeyqY3vLxzefHbHrEbhI9+tvgspO7aLyQQjWjaJxt2maYiNWugy9bAcsmrpl7dUBRj2/kRW0Eqk8PbLrLQcFEaXiYXl/h5dxXSFASSAcnlMhSpHWvkvBwvzoWhnP1RuT8UnqWHty1STdr734wblfXdjRQXw7om/EiszJxZpgSZhQ0cOyjLYNISYdOBzJPpa7UIUH2RL9Ovj8q5uJOkqpQ2/z4gtom5bOAgQgAxqE74Yy6gLJYl80u5rtMt8JBzHN2uKeT7vK05m4R+Uz9ptj6PcnHk3JU0eaS6DnsXQVq5wnZl0FIC+7gt4NEZBh+3Tl/Xmo5xQfPOEhZtd+bktoASXoIrobIyA5xLrFmslN7aFGV1ZhRn2XB8q2w5n77Ljkq7+x527bohazUvl0DgJ6elt42O30Wk80Zup4y
 jVR4D4fb
 5YlfgkrkH8V43WL7DsYkAek+YWBkHrqxbAZZYX1yYr0TphqxW+wcuXeshHTWNIEt+3EfyTejA3E6jRnttKTJygTC6etiomOcRzbHJxnbaToAc7H37iDkGHEMngv+6crV4ZQm4NjAN3OvwuaLM/6QG0b2HOxJiWaEQ/hLyYGbOGd6+XCfWQDJWORvysI+VPpsdmrFOTvcpV0KWBUKdSvgTzndFxfWA4S4v95IJpqnOLfRi2s/Ej8+DuK5t7m0y6Uuy8qx+nRxL71Uur98LH05eEskI1MfxZBQT5AEWc7na9iGUOrmDqZTW/CK3QcwbsBiK5PXCj7BgHFLdB+TqPs/QJu9X2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Tamir Duberstein" <tamird@gmail.com> writes:

> Using the prelude is customary in the kernel crate.
>
> This required disambiguating a call to `Iterator::chain` due to the
> presence of `pin_init::Init` which also has a `chain` method.
>
> Tested-by: Janne Grunau <j@jannau.net>
> Reviewed-by: Janne Grunau <j@jannau.net>
> Signed-off-by: Tamir Duberstein <tamird@gmail.com>

Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>


Best regards,
Andreas Hindborg





