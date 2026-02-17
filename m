Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02B48E9A026
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 17:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C5526B0088; Tue, 17 Feb 2026 12:51:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 178936B0089; Tue, 17 Feb 2026 12:51:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0722B6B008A; Tue, 17 Feb 2026 12:51:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E46246B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:51:43 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28700140137
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 17:51:43 +0000 (UTC)
X-FDA: 84454691286.16.AC6B4D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 83385C0007
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 17:51:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="W/xbXyE6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771350701; a=rsa-sha256;
	cv=none;
	b=RBwAniqZ0EuA3ov0KXovVHycTIRu1AEpYL9EWbrgdSvecrCYgwe6KISBwx2jUxs+U5iWrM
	DaEePFWO79vO//h/ZMs/8XHNxsa0qzUc9kINwSYqsZpWtlmY8WAgAoCRAXqBngXL5Uqq2D
	RRSOWqIwJ5t/vp6hXgq6MUv+GqeKciU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="W/xbXyE6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771350701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=khIjJ9DF0sUEbf+4kABWCtQKXM+w+c9axK6U46Q6ET0=;
	b=2JJ4EbRk/HCZg8H1DPKC3j1KzbgAKfjBVDWgi1svWkyLWw3CVtDqTK3Eo1qC7SUcNDCoq+
	5ZZbbNftR7omCS41RNJ7QziRv3Zg1lzt/UP5cmnE2BK097IQZBIX48zN2Sogz2z9WdaqXl
	qukb+jAPZhRredUOJX/6BeRLceD0Lmc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 57054442EB;
	Tue, 17 Feb 2026 17:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F30CC4CEF7;
	Tue, 17 Feb 2026 17:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771350700;
	bh=+qsGT0BtHCshLG7vFZATbsw1NgFxAVLhghQojwULgOw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=W/xbXyE6xl5b6g0B85OkVAKLFLS7HoIPmkJToi5dx3so5Q2lAYY6ANgrYcsNLwxSz
	 6YhQydBG8z99i2DgfrrInqlAzq+yCHWhwzbsqfCi2CuEe7G/eKlEntqy1+0HxlGqU4
	 lz6+BMC1vDQzFgys2Bav2eFy+V2q2lOrMI5udIx0GFXJkT1VYcR2vsj53p7nTYp5Db
	 hF+iysCfgoNcQR0ENCCKY3cnS+rRRoPFLCMhbHYeoT+dWEB1wXNqTy7czRYdZv6rEz
	 8R4eOYVX3W+jXsZ3u9a/CT44qb3jMVEouJQMgEasScY4T3sDgRa3yMj6KrcdM/GTc5
	 iHp6MzRWUbJfQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Matthew Wilcox <willy@infradead.org>, Daniel Gomez <da.gomez@kernel.org>
Cc: linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org, Alice Ryhl
 <aliceryhl@google.com>, Andrew
 Morton <akpm@linux-foundation.org>, Daniel Gomez <da.gomez@samsung.com>,
 gost.dev@samsung.com, Greg KH <gregkh@linuxfoundation.org>, Julia
 Lawall <julia.lawall@inria.fr>, Kairui Song <kasong@tencent.com>, Luis
 Chamberlain <mcgrof@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
 rust-for-linux@vger.kernel.org, Tamir Duberstein <tamird@gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Evaluating Rust for XArray
In-Reply-To: <aZR-ItMBkiqyBdKd@casper.infradead.org>
References: <aZRncP-sKLLS2K1U@macos>
 <ix0mR76G9a_ieuQUUkkfHMJIviAsrFaO859172fuFx9Goj7QdIfz1jtnv3ptubGEC7uEFCvVfEoWxcisUnTi1g==@protonmail.internalid>
 <aZR-ItMBkiqyBdKd@casper.infradead.org>
Date: Tue, 17 Feb 2026 18:51:28 +0100
Message-ID: <87bjhncl7j.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 83385C0007
X-Stat-Signature: tkkcf95je9fcgxa3utshg3m6xpnatdyg
X-HE-Tag: 1771350701-606817
X-HE-Meta: U2FsdGVkX1/38Zum64tSuutIUStKF4RicNlwVLxHfgDuLYv4OVbNEnplQiFN+w5P7+R9rSHdaG6dkfoNMkpuK9G+bV1vn27bpKkpg7ylxe6GCa4aMD5cDdza1sC4TC9DmnsBO2szhFH/4INeQsghbBmyBKUMzTzYNJj9nsrtDtmIeuIOqpHwY/mv2V6vHMtn1nPj4hKC0OV0qeULWNs+Sas0re8ykCXfyPFp1zPA5+lvsDG6+1E7FsdVidHqsapyyQ2yT6z8k7u6PGmJrTF1317pRn0BjOlE/MzgI+aEATlmpB8JAiIInPfxcV7Pj7uBaE5u1oIIAxB/bjs2Kk0wb9W8FyFIWQWnTXWfEOq31K4lmsApXDMu4KPZR9zrdNAvmh6vNqHVS7bxn/6kRpLYCeLmVDNy59OpYcDzL89PSmrGWrCMP1o1tJHDA7IJoz6CFL/uyGr9CpsmkLH4j7Un/t+i0TyHpxjHLdiln8YjRXHoGa5V4WKPSPeeAIsobSftqbxLYpQR5TuP5Avhv/MV7kuQulVYg3+IOcsdUXYjKzn111YkrMTn1VFWPt0QzGTuPyek/6P2b4T7Mv43vrkWA1sQDOigtuDi3tSFxMFiozcBiIM0Mg6G7liyTYfTu6/wPPJGryoZ4ngJ8rMHFSXKndjdVNGZBk9x/oQlvCwhp6u9uk6Lgx1lO6rZfzjjEQBsG8HTTKOdLRKnvPm5P4QHrokj1RVDWFFe40cQq2HPxacNQV4hZc/kLKV3N1pYRp71nhIv8JDTbr4eS0OSE/UzfVRkP6vxtk2YjpVKj866XJmTG6j8mJNUWpbzTTNa3HthgqBbjo0TUoYHyK9NrXnmGJXAUtGUleu+iTjuoquSK/BL5r5ed/6CfLpeRSOpfikYAu6W5xFFl4Ck++WFhPTjP9YkIQvfxTo1ZZ2zGV8HRLUU1aeo997rqxuBnRQHkTZw42J1kBeb+4EkkPsZTnh
 Cnfll+kD
 xoqNWyuQc8lTmmx1lYKgfgCgFIy0EVsp4F1iX6DRNN+mL5J8vHYJNoJqyFTVFK5BhcNxf7tjDIl40rGCBDGS/3G0gizMQfRqDxuglhoE1fisNLKQWY8RyCf0dsEMGBdD/0SyfSD2TNKeq7B4rFD/utndkBwZQik02cjcX2DEMvvUy37+MEXmjWAW/fnrovAMzui4BKlguALUUslYT/AY9TRQE8hxR9+IRlDCS5q8fk+tYX9uDOEXqe2aZGet3il9HShn20FpvmIHajn4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Matthew Wilcox" <willy@infradead.org> writes:

> On Tue, Feb 17, 2026 at 03:28:45PM +0100, Daniel Gomez wrote:
>> We propose a topic to discuss the potential use of Rust in core Linux
>> kernel data structures.
>
> This is premature?  We can't move the pagecache or swap over to use Rust
> until we can compile Rust for m68k/parisc/alpha/... or we drop those
> architectures from the tree.

I disagree that this is premature. And I don't think Daniel is
suggesting we swap anything over at this time. Doing this work is not
the same as swapping anything over.

We don't have to wait 5-10 years for gcc to fully support Rust, before
we start playing with this. We can, and should, start evaluating if we
can deploy Rust in this area now. We might find that we are lacking
something from the Rust language to do what we want. We can work with
the Rust developers to make sure that the Rust language gets all the
bells and whistles that it needs, to support the use cases we have for
the Linux kernel. I think this would benefit everyone. Let's get in
early and help shape the language, rather than board in 10 years when
everything is settled and much more difficult to change.

On the other hand, we might also find that no, Rust does not work for
this. This would be a valuable outcome as well.

At any rate, this is not a call to end support for all architectures
that do not support Rust. Rather, this is a call to figure out if we
should work harder on getting Rust support for m68k et al.

Without doing this exploration, we cannot answer the questions.

Best regards,
Andreas Hindborg



