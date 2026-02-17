Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76E42E9A031
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 18:44:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3A0A6B0088; Tue, 17 Feb 2026 13:44:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFABD6B0089; Tue, 17 Feb 2026 13:44:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3B436B008A; Tue, 17 Feb 2026 13:44:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B19896B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:44:02 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 53DDA578EF
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:44:02 +0000 (UTC)
X-FDA: 84454823124.28.BFC05AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 97623160002
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:44:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aUEKmHZ5;
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771353840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pk4Dgfnl0LTSh5k77thtI5cjFrYaqlPjl8PNswtEoZc=;
	b=tIhfnozJ6I9pg5jmomUNf/qMgsiyQ7udQ6ShBufYRyOgSIbKKohJ07yU2H7OThP08UopqA
	+L03BbOeP36g38Zg6T+6gm8dHvW5mCsGELQuHf2oy/8WUJ05c7ZEhYZjFUQXoo4nD4Nx3I
	zyMSkfTpQjC5xeryVh+ncgfLoE7ZkVM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aUEKmHZ5;
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771353840; a=rsa-sha256;
	cv=none;
	b=VPOrvnLullf55AKGvEd+QvQaY+RsE3rCmdPncQ3e9vX7Wn7wQiVG3BUJPt3Xnzb1DSQFbw
	v6i32A3yRYNIfkBAi7nSBhgJ/E7yruG0yblzo/TlT44TTtNslaA+Q3hxDfY6efSzvT/PYX
	jo7Ze4bdfP8ThT9HOgos0s7VaSVu7ss=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A38C140ABF;
	Tue, 17 Feb 2026 18:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B1FC4CEF7;
	Tue, 17 Feb 2026 18:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771353839;
	bh=Pk4Dgfnl0LTSh5k77thtI5cjFrYaqlPjl8PNswtEoZc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=aUEKmHZ5aDwTgKs9nkuh+SBwV4UKqULNKl4BeI1JG2BbWs5fTGwFdfFLVwmb/+haf
	 iRyj6ub4Emg6ti9hngP6J3kHBGJs/SP33wwdJC9BheIfaxPf4GJ3wF61N59XqdLkpQ
	 5cG2XKO6fIjX6jAMNzM3Ob2ukkjzPJtoSdbyHesj2nNvsWxpKgR7HMZPKRdl4QC3An
	 GPC4K1bEhAsG/cTKbiaIX+aukwBTaBYMqO7srG3bdjEl/YYlL5u5Bk5VthTTF/E5cn
	 ZI6Zu0Hmt6mjWD0v96UoHzBuDzXRlMMIQC5vZXEpczapcjoHvmn6QN07Glw/V/YLU4
	 tPrPHwEs4gBAA==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>
Cc: Alice Ryhl <aliceryhl@google.com>, Boqun Feng <boqun@kernel.org>, Greg
 KH <gregkh@linuxfoundation.org>, Lorenzo Stoakes
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
In-Reply-To: <20260217160451.GA2995752@noisy.programming.kicks-ass.net>
References: <20260217091348.GT1395266@noisy.programming.kicks-ass.net>
 <aZQ19FEeGgigdwz9@google.com>
 <20260217094515.GV1395266@noisy.programming.kicks-ass.net>
 <aZQ8lJJ-U_8j03Z4@google.com>
 <20260217102557.GX1395266@noisy.programming.kicks-ass.net>
 <aZRHJ7pSzOHruPA2@google.com>
 <20260217110911.GY1395266@noisy.programming.kicks-ass.net>
 <kkmXYWYC07oImDD0FJFVCCWl45alQdraRLHoLr7zowZfE0tMz0MmPIpuyEYQRSLjBQqrp_Ch0iR2Rix_g49lNg==@protonmail.internalid>
 <aZRWOIPThLfIZ1Ph@google.com> <87ecmjcw2v.fsf@kernel.org>
 <Ubu-HoF6Epp0EBvoi1HO6Q9YgTbAxfjfziFD3wsuTop8XLAXSvW2ZkzmMfb0gA2zCfn1XjwuxBSpyx-lexty6Q==@protonmail.internalid>
 <20260217160451.GA2995752@noisy.programming.kicks-ass.net>
Date: Tue, 17 Feb 2026 19:43:48 +0100
Message-ID: <878qcrcisb.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 97623160002
X-Stat-Signature: jtkk3mmojehzyym7r33ar8mbiu5nk84n
X-Rspam-User: 
X-HE-Tag: 1771353840-578254
X-HE-Meta: U2FsdGVkX19avc/d3s+eRCN6DFuLWlAEk2uWjSpo9PZUO0rCZ0K6Gz5pctcHK6teWVIyQeCTa43JN8nYdgdIHD/yKDgQcwZmzRE6mmhaDk69Dh3iKgi17HkBynIb2BRb/9rQFP8sgz4pgr9659v+blgh3Uh1Qep+E+7zO3elAGJGP44KLXX771yyCiZL/SEVQyaFRAbptUtHuWkyYuAGBuFmfCFq1pUujrKXl6ZImCBMomJHi6Mc3UQ503bOX/Z3U0mmCcb/0oLtIeUNlj3u6cP7fGtc2/VBB2RRGW3sYDtckAmInkLTHQPoMUPuV3aTLd4ECfOkICvsj6U8t4wP+T2Vb+pEKlN5ELDfokjGDH+ebWDGcMNevD6+0FsTAZwHhFHGefcjpQQL0jvFsWRa+nYKEDQHQRwqAt+xugOVoZpVifvIQBg2vlZP7OmXyzSQgUisM/rGotfXVj7RVONt7BO6CyYmBXvi/fjhvpWORj7/E9xHFjX+BCVu0gJ+/RTqpFCknK0souRomCK7IdPpfWZQ/vic1l3ybZ6ch69aJfQ/+93b4SmITr15uNPJhhE5feklHc5PyEILx4dzRogpevQS5wbI03k/DsUOj6rKJOjuyKBKJgDa4CAlBT+ti7sVfspsmQZDrsPzKU6KbX7LdEvH1BGr6IQoYaP161pyTXiijOwtvZ48zkXCxBWGvPeTDKD/bzscB6ST6dYdhSlhzrFy2Bwg3uQMaIcn6J/LFzjJ7peKvOnUgYCRTs9sivAS8WcZxRCRh+xTWx2u6YmxpvtKeYxsQgrZ5IHtYTLK1TH3Msjepl2DKSJbnvdM+O/ia31YZAf1k6VcYObVvEKi7RDOA92ErzZyloI1QhuN5xMErZtw7twifnsJOamR2RNV4abjush6CetdY+nmuxygSRTqCD5IN13xxsfMpdEvZubeHNbpckaLAB0wWVWaW4z6mXwp5iOM0SA17/EPyVI
 IY0wpjyR
 EZBaIhFyFe2mXgJpvSGMBRY2ib3STULw/SauSP8UCEpy8TIBTSYugYgOQZIsaNtWPs42uNII6qYgWYixEPkF3htec/Cu9z3gZw4JjszKzUGo0f7QmmnJilWWyyOzmXsuOP3BYTzhT1L0dGv/sga549DFBs+fJulh7EN/QrULPnSaoGtet7Hec70XYEsWQifKyW4oGiuWvncTLZsP50bcHk4X4pMtQ8uwLiiOyiJB8KdapxA3tJBAqDGyIBxP73lRlrYkU3YkD9OsptzSDKNZkSH959RDbEwPo8mDw7xQlXIQCv+Zdi53i46r7xU/A45dAsiBmy6D+Epqk8n6jzPAECEz4rg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Peter Zijlstra" <peterz@infradead.org> writes:

> On Tue, Feb 17, 2026 at 02:56:40PM +0100, Andreas Hindborg wrote:
>
>> I'm processing disk IO in the Rust null block driver. The pages backing
>> the IO requests may be simultaneously mapped to user space, so there is
>> no way to guarantee that there is no concurrent memory operation to/from
>> the memory area. User space programs can do whatever.
>>
>> I don't have any control flow depending on the data I copy. I just store
>> it somewhere and return it if a read IO for the same sector arrive.
>
> Right, so IIRC the old DIO code used to have this problem. We'd end up
> writing whatever random state to disk if you did DIO of an mmap().
>
> And if IIRC the current state of things is better in that we ensure the
> mapping becomes RO and we have writes fault and wait until the writeback
> is complete, ensuring things are somewhat more consistent.
>
> But you'd better ask Jens or someone that has looked at the various IO
> paths in the past 10 years or so :-)

Oh, this is a really important detail that I did not find while trying
to follow the code path from user space.

Cc: Jens Axboe <axboe@kernel.dk>

@Jens is this so, are pages from user space that are part of a write
request mapped RO during the IO operation?

>
>> Let me add a bit of context as to why I sent this patch. I am not an
>> expert on the finer details of this subject, so I rely on available
>> expertise in our community. It is my understanding that copying the
>> memory in the situation outlined above, without special consideration
>> (in Rust) would be undefined behavior. Such are the rules of the
>> language. Of course I don't want undefined behavior in the Rust null
>> block driver. When asked how to solve this, the experts suggested
>> defining this byte-wise atomic memory copy function, A function that
>> would have well defined behavior in this particular situation.
>
> Yeah, so being a C programmer, stepping in UB and tearing up the spec is
> what you do on the daily. Its called reality :-)

I see. From my observations, "Rust people" in general have a somewhat
different approach to UB. An approach where we avoid it. We would rather
fix the language so that we can do what we need to do, in a well defined
manner.

>
> In reality it is *really* hard to have memcpy() not be sane. And if the
> Rust spec doesn't outlaw out-of-thin-air, then the Rust spec is wrong.
> It really is that simple.

I'm at the far end of my knowledge here, but I believe that I read that
the theoretical model allows OOTA but that this is considered a bug of
the model. I'm not sure what to do with this information though.

>
>> That seems like a reasonable course of action to me. I don't understand
>> why this is such a big deal, and I don't understand the need to use
>> aggressive language and swearing.
>
> Feh, there hardly was any o that :-) Call it cultural differences and
> show how inclusive you are by being open to how other people have
> different norms, whahaha :-)

Touche.


Best regards,
Andreas Hindborg




