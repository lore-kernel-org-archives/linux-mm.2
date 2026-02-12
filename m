Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB014EB4900
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 10:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE76D6B0005; Thu, 12 Feb 2026 05:52:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D95546B0089; Thu, 12 Feb 2026 05:52:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA11B6B008A; Thu, 12 Feb 2026 05:52:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B5C1B6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 05:52:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E6641607C3
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 10:52:30 +0000 (UTC)
X-FDA: 84435490860.08.EE23E84
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id D70DF140002
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 10:52:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JGpBP+sW;
	spf=pass (imf26.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770893549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Pyx3FcIrlIeSu7IdkFhtMfJ1XFqoVQj8E3rP5bSCnE=;
	b=oLb/d+Hylrp6kvk1dxWtgnArcuwK44d6XSaFnExYWwjqy8sl6YTia+U7ueksMvaZjnPLbs
	7qCU/V1NftjaFP8JutvQmPD1zLmFTdUPqezx2PXxks6+zmGXLta4cMQBT/fdo00mSUjm68
	PIii4Msz7dlXHf2Yt2v9jUIgL+mUP8g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JGpBP+sW;
	spf=pass (imf26.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770893549; a=rsa-sha256;
	cv=none;
	b=3xyiNkyTX3H2prH4NFzExpPYbqmKFnjvsewBW4KlzqZuJ3q7Zg3Q4s+yPGT35UZy9Iooxi
	Wxj73W7O2GJYVIT8Xu5Hjvs5aVngy1xdheYQ70hgHkfDWxzHH2Pb21apqnQ1Rqo9nxvuXj
	yu4PieSXC5Y8FB3G0Fp8ZV1uvVWTb+g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C857144339;
	Thu, 12 Feb 2026 10:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7046DC16AAE;
	Thu, 12 Feb 2026 10:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770893547;
	bh=9Pyx3FcIrlIeSu7IdkFhtMfJ1XFqoVQj8E3rP5bSCnE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=JGpBP+sWDLYqpKd+0n6IyYuEGPaBwrsrgq5JQr0KEeGvYVS/xpBr4LkEIuvaDCdWL
	 ROM/xTIWczGVueTKJiSXraBFyEFLasHMYkCCbwXyPWacMsOxoH5Tj/hQxqRRtVo3Zo
	 T0MVUvqpp4eK+tpfceNSX1b2J4apk2k72Ia2CqTjLaKVp1ge9wx7o3xBG7ksYYpGLp
	 m/i4UWETP7rmTvSVlXJtMmnOAKwMxN/FvNRipOMlMlKgI+BVtMaZZ5gh1q56L6JTu0
	 yf0jT1oI3jeZFkJpZKnpoRPKxY3srXx1A7o1tZxhOcJ7rIdRajAR67oTaImMyno00T
	 LUcvb03S84W7w==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, Daniel
 Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 03/12] rust: xarray: add `contains_index` method
In-Reply-To: <87y0kytggx.fsf@kernel.org>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org>
 <q43rzzvpfh6ke74eyn3nypiek2ihaq6nat552asiobqge4vxmn@knwkb5dexnga>
 <87fr77viat.fsf@t14s.mail-host-address-is-not-set>
 <fU1FEYt6-SY0KlyJy4VClCr5j6P4d5-wukzc_9TkSDSBuQNlY26xyOIprMbHEVMv-H-nrAJ1iN_9tcfIXEI1iw==@protonmail.internalid>
 <gta2wjt4tkcvyu7g56gqyipiigbmbk2ca3biqzmxc2npch3rk7@ccwzwgnk7mcz>
 <87y0kytggx.fsf@kernel.org>
Date: Thu, 12 Feb 2026 11:52:16 +0100
Message-ID: <87v7g2tesf.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: D70DF140002
X-Rspamd-Server: rspam07
X-Stat-Signature: ps31geytcn9ing6gjsbt5h94rbjdi5t7
X-HE-Tag: 1770893548-567015
X-HE-Meta: U2FsdGVkX184zY0noq4MPsoRN69D8jocpxpOWdSa2wdfdCybnBJFpzekmUa8w94ej/cJClwolxwAdEWKKzGxEyuQv8KFQEQBJlqIZSCKXulJQB9I1WKSg5LkSjjI8veh4HBI2cw14tKFRUVtQ/KzIAFUAVF7oAyAGgDjV0H9pk1t6fVAEdO/xLHpgAlIYsQ/Ov7ZPF4VoIQxHxzKnchbMl7cfhouvouVY+u2+LhDvMiLtIXiWJhnlVlPKX2DYaA7BvRXKFY5qahtkjfUguvkE7HGIwvmkaqSklv1ZZ4k/ENGU0H4fBdZWTwj5il3jFuOb3w6YZl4NnAnUsLV31AC2iCyDrFA9Ut+uPToR8MNvbMblBz6dcMvw0XajV1RpAV2kvtzt5XlE0P2T1V3/e8n41m4HT6FaS6aApQe7OZFW/y94CsRU7syraiwMpvwc31YUmmElH4cGUEMxvm/mC+l1UJQUwE2UvR4TyL0+pwWBFtXNXICzjVld1R7xx+iVQeovHJKQy+o6sGW8HxEi60e1UVuv3iLghe+3+RT6DDelmZAuBZ0tQ7Kr2xHTtLU0adT1zpvYsigx8yuUn3HgxDmw3q2xY7h6W650tKOMDdRPGqH3HTI5XzPnehUSqLzTtEHVRrIntttASlxea8hM7Bpfkm8SODESanhit56N+YAF+rFuaie+psshrsa3caGUC4yj52RInGP2jKvy61nPsNjna1lQq+xbRRuW3c9WTsBFCRWDGbyb2w1CtS7SKs+P6AV2S0fQl+xssvQmiNmJKRg+VJ0kNxu2KmcNJlM9pPUuLVlvGsSLnWp0/p12aGdLIz96YeOBPVcKGoTIgZRHZT4I8qUa1/pMRNuobw++VteOrk2Xm2M+z9oYYk6rPi1bAbX59dOxroRVwzbvOzhsCYIPLBfH+bfbNquzur1aGQ9i9wNkGa0x4eBS4iHHlla1X/+YmDYUFqPPkPIR+nQPgw
 3aQtYuCj
 MXVSJXfc9cTHxXGDGSRX0m1CaFfFeF5sd43RCSMptQagsICmpiUC0G6KM1CnNtckzBPlDoWcMph28Bdx3huo1EzKvl0/9XxnFWMg3pfcUmecVgyCPXnFyEho/RNgfz5LOZNHbZxHUyEXOdtL44S1xNh1JF04l4V5s22G94vHJq3uWp7BtNLtIfJ36DwHUbERmWwIOETuAeJ9cb1CF4WsEHH5l2f0lnDJcfz+iXizM+tfmJ7ri+oHGRl6skfD5kFgvth7e0dNsFYku9HoUhpW2ZgaagJBom0YRICJBoU/MNB7x9a5Mkumaj1/aVHh8frjXNDTq+1W3F9OnzdVkM3MPM8MhyEC5rIpryzCbSTaWB71VQAVJHZbpIlEwCwydk9FtFUSOLHPys2IAmSccTZls4liZhVMnxuD2+n3Zq4Qifj5/6H72+gI+Zu6+2bXSp3wqBFXwQiXRLzbRWWqCbqO+yU+PncbIooCtHl2hjWK1OL/59/YMxu2+mSW9RR6JFGFr+g0jZaKiZI4ceaXRYMd86zn7CfjP3lfhpSvPFxqSlXSf7Qj+Znzy8XouLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andreas Hindborg <a.hindborg@kernel.org> writes:

> As far as I understand, this is a borrow checker limitation. It is easy
> for us to look at this code and decide that the borrow on line 51 will
> never alias with the borrow on line 49.

I did a bit of googling, and this seems to be a well known issue with
the current implementation of lifetime analysis in the rust compiler.
Apparently this kind of code used to be OK [1] but the Rust devs decided
to remove the code that allowed this, because it was causing excessive
compilation times [2]. The upside is that this is solved by the new
lifetime analysis implementation called "Polonius" and it is the
intention to replace the existing implementation with Polonius at some
point [3].

Best regards,
Andreas Hindborg

[1] https://github.com/rust-lang/rust/issues/51545
[2] https://smallcultfollowing.com/babysteps/blog/2018/06/15/mir-based-borrow-check-nll-status-update/
[3] https://rust-lang.github.io/polonius/current_status.html


