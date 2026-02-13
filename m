Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EE6DEDF15E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 12:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C631C6B0005; Fri, 13 Feb 2026 07:58:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10F66B0089; Fri, 13 Feb 2026 07:58:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1CCC6B008A; Fri, 13 Feb 2026 07:58:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D6E56B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:58:30 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 314F21A04DD
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 12:58:30 +0000 (UTC)
X-FDA: 84439437180.07.E74F493
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 82652160004
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 12:58:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QKTNrLA9;
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770987508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YxGACJG5tjPrceJtCLu+Tcgl5Wr9ISlM1craYZAIvro=;
	b=DVy+5Kj7G2/ZeswBA3+QpFt77AslUrmCUssO9g3s+c/Ck3ynj33aL9aito+efhyYCjspzg
	TlkeVL+G7VQ5+wXHNmnAPBEvw1EfS48mk+peu0PqHIa1C+wg5lkvQYvadviTnaVu1RYna+
	uKUH0eo6ZkJSQHNe+fg6oYkxUucIdns=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QKTNrLA9;
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770987508; a=rsa-sha256;
	cv=none;
	b=xca+KjuVTyPRm2IgxWATeR5He1W7o+uCpILm2cKgSyuDHLuFg2hdDydMHNvXVqs51TRsjj
	wt7QBfX2j/dpnJG8H5wgFBplDHvWyWjMTWozQjJ+sdReWygXLM5tvAIMXpHHMH8fuIl7vv
	CFWGt/kPhzAgpa9At/oG0If5IGQ9TSw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9495640764;
	Fri, 13 Feb 2026 12:58:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5BCC116C6;
	Fri, 13 Feb 2026 12:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770987507;
	bh=mr+a0c/cTqCnHJ+pfrjOEc85QJabkVXEsS2N9SJdxf8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=QKTNrLA9TWhj72HiG/JezifSgEA2dqjhTgfGUZraAunZjWYJLwtRPLiAUmi7asc1/
	 HVB7mKnJEzs6HLVTNJlaJ4Ic8lyaJKu874XrCUyn6gMHp4yUle2R3CYRtOYns+KGq5
	 OKBmnrDeboYfquV1SDvUhNNpSHDvnGhL/+LohiimBNONgffogL5STY6WWBOAPHQ8TR
	 9QB2dSxeADNJjp+8AKNyBsWijB+orJR8Fx61JdBMAPa/fqCbE3s7iSAHzNiOGsxFkT
	 cgKT5jAW4bdOj7d+5f4MxYNW/s/ilEIK920D4dWYnwfUqisvnmnJgB2Uj0PNkCLhNM
	 1ZDqJns12e+yw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary
 Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Will
 Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
In-Reply-To: <2026021343-germicide-baritone-efe8@gregkh>
References: <20260212-page-volatile-io-v2-1-a36cb97d15c2@kernel.org>
 <20260213095557.GS2995752@noisy.programming.kicks-ass.net>
 <40xUh92AU5E9oFxQrdej-AXVg76jmaWGKXZMLoOHXe35Lw9x_eNEoLup9bB60LyGZ_0USPmoxr-9hE3ujA67cQ==@protonmail.internalid>
 <2026021343-germicide-baritone-efe8@gregkh>
Date: Fri, 13 Feb 2026 13:58:16 +0100
Message-ID: <877bsgu7fb.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 82652160004
X-Stat-Signature: rizocneeb7sxg9q1fcbjsz7k4atk9rhj
X-Rspam-User: 
X-HE-Tag: 1770987508-412014
X-HE-Meta: U2FsdGVkX19ajJ+723RQzHkLnRfdAvZwJrtum8QpyiKhni5Y6n1oPySDTbeBl88Ev6hVr/3Ogur3F+WKD3pba0YRPkr4sxeV37TyT+0kIesbPNeh20c4tcRZqtJSw9eNM9fOabzcrbhpFmky1KY3PignUhnd9+I3Ie2+cItwiQosOoGvVO+vfS+Xg5Zat9Sbn7Ge7WhS+OsEgYB0oFCaNBAauCb+3HGWrGeA76VJ4Sm4T9WrFyY31g/2Rzma4QT2QdvPrs+9daPr99VeoaKe9Vlt0IIQwI6zjQeVJV+HQ3URS3SPbEzf4h7YgK9tAELsOm2Ux8HN4/CRGaSaKg0mO99iBwbWbZOCgIvZ9dWdmGa7o+Bo+1fTh5b0bE9oMWFHtJ7LHyY308378yD3T3NWLOm4iZBMS7nBRdYFqa4p9iksGqQc6ARTSuVXUVQLdE5m3WHJVPfbIdsPsmqf9WTlgwYqWetkRFITuQuMwB/7SiDFg0jXmN4+41p8v3QJ+2tMVkqPzFLKmWP6KYOI7K5NU7aN8+FijFgry/Dx0DBdfA69AG1HUXZ/eZPgq9R7qy9nFCLDrkn86CNBM/3z+6IBx72GgT7mQSE9DGUQprbATq7RoT9KwupngdZD5SnTwpcPy9PRqLRGaUeiDFOJCCXroKwNkzpihWzXxuXbgux3V8Qi1Bz4EfJzVYkv9Xdyr8/1fzL4/7bvO62SyC3rMZo6uglOYZMN1U/XvmjxUP9tOPfi0vO3iAYKM8LFBmsYaIuEQcK97teWreL+9u628z9HivbamPQc1vsP9sa3pCS4EqYmmwOsLwvEg1shcMbp2PVkiAKB+IB+ef7xf1wmhWUhe/NdXe0E+GhcxynGThn+Ox7tfSt4ckXrjpbC3bfm7/GtBnmzMBxKo0ymtZIcyTPNjWQJOcH+5CfRihbIMD5vmZuTX3UbCwuQoN0rLVmEBv0D+GRp6bv/yX2gse3DkOK
 ePFC6975
 Jf849LarCo5+9HbhFk9wPvOy4P3Q25BFVzZEKM8JeOyTCpj6AG2mUPd/9Fk9A5I4yVP2wiW8L+ngyURYAw4MDHHe/TcOe6oL2ztx7CDu61jSYLtCYHvi1F7coGGbnMhr2kQrseuBPKsn2DUSuycUCPLGLIku2heT9pgwZ/lNrMSH3u4vFvfOMW6PwLS6y/z4XiumXuV3L4gSP37tBAxU+/Wz7qWpUbsYBVnjnHx2KD5bXJIrOlWR4pNrqW0LCOf+VkmlsSvT7rnLRJo25wRiIIxfEDup5o3tZ9OTuqAOOk+SSlWSi1slorbtZDMJnSQ9NcLjnVmGjaTWwe8DH/Pgla1LSsg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Greg KH" <gregkh@linuxfoundation.org> writes:

> On Fri, Feb 13, 2026 at 10:55:57AM +0100, Peter Zijlstra wrote:
>> On Thu, Feb 12, 2026 at 03:51:24PM +0100, Andreas Hindborg wrote:
>> > When copying data from buffers that are mapped to user space, it is
>> > impossible to guarantee absence of concurrent memory operations on those
>> > buffers. Copying data to/from `Page` from/to these buffers would be
>> > undefined behavior if no special considerations are made.
>> >
>> > Add methods on `Page` to read and write the contents using byte-wise atomic
>> > operations.
>>
>> I'm completely failing to understand. What!?
>>
>> There is no such thing as an 'atomic' byte load, nor does it help one
>> whit against concurrent modification of the memory you're copying.
>
> I too am totally confused when reading this patch, and the previous
> ones.  Shouldn't the "normal" copy_from_user() stuff be used here
> correctly?  Why is anything new needed?

One use for this is copying data out of a `struct bio_vec`. As far as I
know, there is no way to know where the pages backing a bio_vec are
mapped. They could be mapped to user space.

Best regards,
Andreas Hindborg




