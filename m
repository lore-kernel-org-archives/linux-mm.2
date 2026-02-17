Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACB83E909CF
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 16:10:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 170576B0099; Tue, 17 Feb 2026 11:10:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E3C6B009B; Tue, 17 Feb 2026 11:10:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04ABD6B009D; Tue, 17 Feb 2026 11:10:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E70E56B0099
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 11:10:56 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A078A8AB41
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:10:56 +0000 (UTC)
X-FDA: 84454437312.07.DA9815D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id B43C42001C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:10:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X+6X96Up;
	spf=pass (imf13.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771344654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MXhxVIHeRx0BZp2W6p41DrKtgS4f5F5WFmdV2+prA3I=;
	b=OdxKNwGG83jv1BNp7L5JrHOcNSfukWVOPw6XJZU5vAHlpz2AsjxTOTBEA46tRsm9xpZI0Y
	dcHhH43waMWLzTOlYWL4ovWxSMpUyt7fE/rpqzO8E97D8AfDyGiWRrb8OkP5aGpYcnqnHn
	EzyPKiGYE7ln3axbeo3kCzX7gn8ijFU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X+6X96Up;
	spf=pass (imf13.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771344654; a=rsa-sha256;
	cv=none;
	b=A/q/dqzpTPi4yetuhTc4iQE1xDoL/g6lFhpMJXGPcbTKh7hEnIlexYaW0Fx8kNUMjt39tp
	iD6h/yljBXhB/oJw02R14lUAAggqLNXwyh8rbXMOcJqJ2pIHUITXsvSxHX0i6ujlo3MkB5
	mAPeKgZ6ayWIrWzVivopx2TM4yTJTWY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 83019441EF;
	Tue, 17 Feb 2026 16:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B95C4CEF7;
	Tue, 17 Feb 2026 16:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771344653;
	bh=MXhxVIHeRx0BZp2W6p41DrKtgS4f5F5WFmdV2+prA3I=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=X+6X96UpPdp4cqp7E/C4NBggV15ypDFjwEo3EL4AaUkDLTTFQrFbAgYYCZpDv8r+H
	 NR3w8etIdXG9TyuAGAG67a/FT02+v3Q3381wGlkvjOuCjmeDwyGFYzcle1us+DxOmS
	 r3pzKu4oOjfNCEi6otQCyIMBt9kiO74sr1iLhc5TeJ8ZAeSDdjJ9cZ8Xt1Vi24HI+R
	 dzPec5h4QNx5gt9lN0CDPA0DdDQXDpX3gezcH4vspUWHQjAADc0DZ298oD1aJaM+SE
	 fvZ+jtvH7PZtQMXb1Z/BBYj1QlVTP1e3DwNqPRYuuXMlXZ56c1WJU1YYogjLZ5lDH1
	 B+Rz05pOLZh3w==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 17 Feb 2026 17:10:48 +0100
Message-Id: <DGHD9TK32CZT.1PGFE238T1YY7@kernel.org>
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
Cc: "Alice Ryhl" <aliceryhl@google.com>, "Boqun Feng" <boqun@kernel.org>,
 "Greg KH" <gregkh@linuxfoundation.org>, "Andreas Hindborg"
 <a.hindborg@kernel.org>, "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Trevor
 Gross" <tmgross@umich.edu>, "Will Deacon" <will@kernel.org>, "Mark Rutland"
 <mark.rutland@arm.com>, <linux-mm@kvack.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: "Peter Zijlstra" <peterz@infradead.org>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <aZQ19FEeGgigdwz9@google.com>
 <20260217094515.GV1395266@noisy.programming.kicks-ass.net>
 <aZQ8lJJ-U_8j03Z4@google.com>
 <20260217102557.GX1395266@noisy.programming.kicks-ass.net>
 <aZRHJ7pSzOHruPA2@google.com>
 <20260217110911.GY1395266@noisy.programming.kicks-ass.net>
 <aZRWOIPThLfIZ1Ph@google.com>
 <20260217120920.GZ1395266@noisy.programming.kicks-ass.net>
 <20260217130024.GP1395416@noisy.programming.kicks-ass.net>
 <DGHADGXGWS45.1A6EHNMKM4SRH@kernel.org>
 <20260217155035.GZ2995752@noisy.programming.kicks-ass.net>
In-Reply-To: <20260217155035.GZ2995752@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: B43C42001C
X-Stat-Signature: 4b571buy63378a85ifgtfuem6ug5yc6g
X-HE-Tag: 1771344654-724316
X-HE-Meta: U2FsdGVkX19cOZRl+cvHPqtqBOSPlZfxvQbxSOPDrCIovc9b1KLh0bYJ/sTPVbZUx6AvQwd6gSQp+2NG0LQjnSLTxblRbjqAwpv7ahpU0KRhGgO/ruEzql1WlARBxgwgXObwllhoIqrA4orvHKDcA6tvDe9TZq+BJI9lM3MlDGaDYNP+5QVQHQpJmsIQgMNXbste9ctYq87YTlw407E37rHxRc6/0JJrWO94eW9GzwEGGfNvc/DLlsgumJR7d35eeyqzLk05oaiHD1sZk2G2Ez7A4PEYiE1MH+7pDKM1YtD4OTvnYCKgBJLPMqc0sJfwHwQXaQ17sdxaoIY6Ek7WXD0VBm/eWjdRH4LCBAqph2qnGtUoQibGH7zcTTxCf140/vnoT8NBPv/CddqskerrHXvbkdohPlH/uJkCXtBZ79WGYMKfse2T6E3h4gs1/XrQDF5HNBTWPAxwQhuZbvRkKykcNeGyLAumVJ4hvuY8ouw3LnsPOm6k+sdAUMSsyUavyKy+1CpZkYOw4ZII18A5xpKkILjsXoVkJ3uXVezpqbEFfFOKVzxcWOo0i+ml1RpuKLGE4qT4bJ3nmUkksGpfWv8CZUiXzjNvP4TeeXaxbYVNhHJq3suSsbLfONuWHZX10Mqh+qdE9YKijuRLEWU7OfuADj59jle93nG1+sPWvP8AeQZekRIWdiE01gErtl/NrqCmJnMzbQJkZN0sb9xpbwE1nANPt+8KlivbCA5RqxFrVfDIC+h4eDGT80Fz4h1oEl4yYHc6B3TJaknu22MhfqEnF+lsSSQPqTfljH7nYwlIJ+s6DMV6US93kZx5G+EPiV8hbgMBtB1LjQYzXeba+XDOLsB3sSXzPEvJtdqaqy4nc2NVy3Ih/F2xMtukbuopOEgMY//Z8KVuEbQO5ADBAYSt0zLetuzesKQ1d4fKr4HuyDnc12Wjlb412MHhrKySZyQ6hKK3GHDzkOtVta5
 bgWOxn2r
 3/XVjsAys5n+b6iaetsw2fZnaAMCd41MW8l0H7IF3fNOMbk6DYWT8tq3A9Q0w93B3TTgcOPMALcZRbXp80BIP+1FsFbGGQfIOrj/GDRiHCa7KoV2THN87lzyfH/A6YNCIa9mbT/2R2i9lUA/AMX/F7Alb5h73cakRfvx783lyiPLLYEUXr0eu95bOYsGegxpDd5W5XuEuypoKxFdFr/DMr7isEaB50/GJ1xQmA6WphI2WoJKxHsQRB9/VhpR+9V3bHwPwL8jkmR+xdDHoXBw8t7hdCTUweiIDa3FMSaBLalZxzCnaEuGctH8+V3k9Ivs8wnid
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Feb 17, 2026 at 4:50 PM CET, Peter Zijlstra wrote:
> On Tue, Feb 17, 2026 at 02:54:30PM +0100, Danilo Krummrich wrote:
>> On Tue Feb 17, 2026 at 2:00 PM CET, Peter Zijlstra wrote:
>> > Anyway, I don't think something like the below is an unreasonable patc=
h.
>> >
>> > It ensures all accesses to the ptr obtained from kmap_local_*() and
>> > released by kunmap_local() stays inside those two.
>>=20
>> I'd argue that not ensuring this is a feature, as I don't see why we wou=
ld want
>> to ensure this if !CONFIG_HIGHMEM.
>
> Because of the principle of least surprise. For the HIGHMEM case 'ptr'
> only lives between kmap and kunmap and any access must necessarily be
> confined in between those. Having the code behave differently for
> !HIGHMEM is surprising.

Well, I'd argue that those are two different things.

I agree that correct code does only ever access the pointer between kmap an=
d
kunmap (and in Rust we could even enforce this at compile time through the =
type
system).

But the memory barrier is not required, i.e. if the compiler reorders thing=
s if
!CONFIG_HIGHMEM, that's fine.

I think it would be wrong if users would - for their code - rely on
"kunmap_local() already issues a memory barrier for me". It's an implementa=
tion
detail that depends on CONFIG_HIGHMEM, not an API guarantee.

>> I think this is not about not escaping a critical scope, but about ensur=
ing to
>> read exactly once.
>
> It ends up being the same thing.

Reading a value multiple times within a certain scope and reading it exactl=
y
once is a difference, no?

