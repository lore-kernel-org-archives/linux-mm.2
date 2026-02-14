Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF681EDF142
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 08:18:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16E8D6B0088; Sat, 14 Feb 2026 03:18:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1254C6B008A; Sat, 14 Feb 2026 03:18:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 031056B008C; Sat, 14 Feb 2026 03:18:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E72A66B0088
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 03:18:37 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B9511A06BA
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 08:18:37 +0000 (UTC)
X-FDA: 84442360674.13.0A9F200
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E8E6E40004
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 08:18:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jR1Z16eo;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771057115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ml9zPCjlCV/18I4r46ecrYmgV0of65yFFkZRFnYsrAg=;
	b=4tIJkkyCXfFxCReD6FWukmpz3ogwsNErXQRv5HRNq52ubXFQZad5/T87x8HYTm8t4H1JRV
	BvzfycXa8Jjt290+YYNxN9LjZTC2tnCG0t9t64R7NLfbg8T9vSa4L1qRhz47yJnoe7iI91
	WBKs3hzEmS02kNe5cpkqrViq0Gp7KEs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jR1Z16eo;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771057115; a=rsa-sha256;
	cv=none;
	b=4SAMcfOUdkdzASw3S4ZfiJMxALqB5IQOERpSOu62aL1mzvdrMhUM903rWG2GncAd25GOC2
	q87FKcCPjccpNPb2j7REcG95fSpRAccy4+RV9vXxPXL/A6iEbDJEAs6wRpOW12dYTt7Qmy
	qNsmM6JJ1FUXNWR+tbY7cUrLKjdCS8g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7268060054;
	Sat, 14 Feb 2026 08:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC384C19421;
	Sat, 14 Feb 2026 08:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771057115;
	bh=Tox5jLa15XoCUBQXIkE0c8jgaNR0Lc1vhq8GCSN9Rw8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=jR1Z16eoNZfM/acOr/gy3tKDRoh2EblMxU/3YD3lCWCGoCjZ+Nl3DVWARKna8UDuh
	 nF0cT5PpnLZ40iKGO1v2PbHleXyxwmgfp+F9wuvjLq0yLQ7kZnNp8cxqnDZJjvt+0f
	 uwwXCQUmFtfey1RA/G0P5MxEtDKKRBgf7zzZmr/L47/Cp1eSwEl0cH6W6+KaW35BZe
	 l+c+s4In4xTNZbcYoSM+TtcLW+DazZJH5hyVYgFiQMRetPfFzOlkXR0eARuPwnyAxY
	 mvi3aLWWqxhnOKpmA4uSxRtxlR7A4OnaZyskCVLobuAS6wwd9GtO+zRsOgLXwNzrBB
	 gtYTDK5uLvyzg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Boqun Feng <boqun@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary
 Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
In-Reply-To: <aY9UedlaCmagVmzh@tardis.local>
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
 <20260213112837.GT2995752@noisy.programming.kicks-ass.net>
 <aY9UedlaCmagVmzh@tardis.local>
Date: Sat, 14 Feb 2026 09:18:16 +0100
Message-ID: <87tsvjsppz.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E8E6E40004
X-Stat-Signature: wj9igynmzujyhoimcyu85zkz7ji4sgpb
X-Rspam-User: 
X-HE-Tag: 1771057115-282861
X-HE-Meta: U2FsdGVkX191ZBo4IZNv695KOH8YJKVJeGfwZZyTwTxilU7e3WM4I0sKyPnytRUZQPuYVJBtXAPLATInVqwkth4PQHrRICxcray6FGH9gFIJiaU7dsIiGHdUzzbR0OHmtVRbCwgV17v3wftMNkYGam0nfC5kyjgCtqKH/oyj4h3t2xQ1T7+j5Wu8XhdDlr+9yufAx2rrCpojMoev6eOXhWTcC2nshTr3JnJBoL0UhquBxOwkNfWJtJ5mhRZD1pqJ4ISXkj5UtNYhTkllUVrl87JRfu1gRcjn/DByEjQ1BO6JvygB+OtA5vF0KovHb7bOMmVxg6F6CRJ6VBaZ5udbePTcisYHkiy+Nu0aKxtljUNVZ+SD8sX86Nfdpw3eGrh/Nj+gKRxUGS0/w0WKeRkvvjA9xG8T6Uw+QWtiuL8mkNjMwZKn5z6NmoxP2wC4gN2LNiiz8wJQc6G6PkUtfRzpBJ47nnOxYwz9qAqqTtSScwP1yb4nnFiCwtgiGgKBCL2YV7od/zrifXo1HCiWlEVAoQYQ1rTRgV4ok3y4mbOiUfeUFz4PZlZb/bo90/CNOwhTlFpdpzkYKn7tH5jxBIt2QVvwYQkaAJuWbdKg7PW4hjt82s9S97YEShqKaH4ZZBU36xGfaac4c7YMYlE4fetwQ71d0nVhSSrKX/uqz+RHoHMA8dm4rr8GX6WEDn7ukmX/iXxZAuCZYpBPyh79eAIo3Ksx7u9W/vxr8x+d6Hz0jmpVpY4JSeAIBFCGfT7hMTMU07TiRNNcAe+DL72WI25qA6UZNeNHYLlaXYkv5qNC3ArAwF3GZQxD137QGWFGoUqCAHrb2tTpDmIrtWxu8SPb6WzRBCECIHQRD8J3cr5ab/52xRPTPE53RIMVkBEZb00uJ65zSEYZkwKvmfgiZs5EpflpbX8bDqb1WYXFe+dIN/quw7xOckMerJTBE0bL9JQAhnZYb3OCUq0xh+ky/K7
 arnhbToL
 uQNbcWwYORlnlmxTlg5ke3r/JR5iXJps+N2RQLqcWGqrKE4U0VVELcoU86maVArxIvpOvV87e5Dn23FAfnVLthDYk8zbFd4jAQhrPT9EKkYIAJIMmo/BGLCnHphw+oWk6BhizfoounEklrsZNfWS0HVhrzRbNwtd4XvXDeUz59DXvzBQJRyTZd3zgGTzlCwbDtqlTJUhC598QfV/xjpU39K2ESH2tvLiW6u5wmm88+c4TZQduRwBLQKd43x1QVxy3VnU2LUGMA8Km6RcxG1nVcyqg0+8GesG+S5qGSG8Fw4Tj1jo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Boqun Feng <boqun@kernel.org> writes:

> On Fri, Feb 13, 2026 at 12:28:37PM +0100, Peter Zijlstra wrote:
>> On Fri, Feb 13, 2026 at 07:42:53AM +0100, Andreas Hindborg wrote:
>> > When copying data from buffers that are mapped to user space, it is
>> > impossible to guarantee absence of concurrent memory operations on those
>> > buffers. Copying data to/from `Page` from/to these buffers would be
>> > undefined behavior if no special considerations are made.
>> > 
>> > Add methods on `Page` to read and write the contents using byte-wise atomic
>> > operations.
>> > 
>> > Also improve clarity by specifying additional requirements on
>> > `read_raw`/`write_raw` methods regarding concurrent operations on involved
>> > buffers.
>> 
>> 
>> > +    /// - Callers must ensure that this call does not race with a write to the source page that
>> > +    ///   overlaps with this read.
>> 
>> Yeah, but per the bit above, its user mapped, you *CANNOT* ensure this.
>> 
>
> First, this safety requirement is actually incorrect, because of the
> user mapped case you mentioned. I believe Andreas put it to prevent
> others from racing with memcpy(), e.g.

Since context is a bit washed out here, let's make sure we are talking
about `Page::read_bytewise_atomic``.

There are two buffers in play. `src`, which is provided by the `self:
&Page` and `dst: *mut u8`, which is passed as a function parameter.

The requirement for `src` is:

    Callers must ensure that this call does not race with a write to the **source page** that
    overlaps with this read.

This requirement is different than the requirement on `dst`. I do not
want to enforce that all memory operations on `src` be atomic, simply
that they are synchronized. This is a weaker requirement than the
requirement on `dst`. As we hold a shared reference to `self` and there
is no internal synchronization, I think this is the correct requirement.

For `dst` we have:

    For the duration of the call, other accesses to the area described by `dst` and `len`,
    must not cause data races (defined by [`LKMM`]) against atomic operations executed by this
    function. Note that if all other accesses are atomic, then this safety requirement is
    trivially fulfilled.

Which is also requiring no races, but is specifically mentioning atomic
operations, which I did not want on `src`.

With this in mind, do you still think they are redundant?


Best regards,
Andreas Hindborg



