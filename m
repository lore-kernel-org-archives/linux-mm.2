Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C573E68154
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 09:45:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D59026B0005; Tue, 17 Feb 2026 04:45:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D266A6B0089; Tue, 17 Feb 2026 04:45:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2E776B008A; Tue, 17 Feb 2026 04:45:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AB9676B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 04:45:22 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4476D5E200
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:45:22 +0000 (UTC)
X-FDA: 84453465684.25.CFCD7E7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9B93740008
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:45:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vfzdEU8P;
	spf=none (imf01.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771321520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xMgRdiAJqb3usCRSJ8lylhuVSY2ZK9m0DpJKEZWPmIo=;
	b=1OvUxsIv8iI+T7xEDO4p4gcSNCCAiM2Eba94xDTS4sjYgWrYAWZtPTJNwR4D9in2D2qm7K
	fkxm7C82i56f9CHM5lvBKBC7EOsi9NA08n/3oa3iHlYhv8W1XHu0JWR5YPs6wmucBeQEcV
	w/Zkt9hEva9N/eKfK4c0g4QA4xGSE6I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vfzdEU8P;
	spf=none (imf01.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771321520; a=rsa-sha256;
	cv=none;
	b=P5+5IvDVwaQC48FJFuvBR1lkN13L2FGT/y1XedQHjzemHH+aWbbTeKE59nYpLmdsofCA+Y
	EzqZe9ypf7ieHQ81Cmh5k7L5DYqI+Bjx1LSPtcKCZuOLlIA3qO3mDoFP0fIqjadvoNOOh1
	Su+/VInx8nppkVn69M7t28gusaGRSkQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xMgRdiAJqb3usCRSJ8lylhuVSY2ZK9m0DpJKEZWPmIo=; b=vfzdEU8PS31YLqCBPPTsHJKK6M
	Bu2Aofe2rrCYLrsMhtOAqEHczqxe7Uz5Cvtfe+RbqNdNUEY5oF35CfDenGMxMwUP+pKT4U44q7ks+
	eeMq/TdZAd6W6g7FApjOV71LMTLvBRRMqeYQiCqvhNI4vrmp5R7FG0wIbfRzuPtITLQIn2FyBo+lT
	BzmjmiiFOvEg39fwySDUix3tCYxaeq82I0qSJHITsZCmiJCbkdfrEIfC2Nf9kw03brqHIG3KODg14
	a2YrqiE04fHzgZXffdN7VAwlWi5pSI0eufTeiotNfINjXXmwJjXuwg697TeAcRADOJBoSy185DLvG
	f5fyFHpw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsHds-00000004Evt-1Xf8;
	Tue, 17 Feb 2026 09:45:16 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 3A261300CDE; Tue, 17 Feb 2026 10:45:15 +0100 (CET)
Date: Tue, 17 Feb 2026 10:45:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
Message-ID: <20260217094515.GV1395266@noisy.programming.kicks-ass.net>
References: <TZXRjQ6gkmJNdRcfDVKKEl8Zd-8b7HBCLMrrPXyXYq9HmsVE8BJS4a6FE-YxxNsOBrIQl1fiOvfS19rLkPSmiQ==@protonmail.internalid>
 <2026021313-embody-deprive-9da5@gregkh>
 <873434u3yq.fsf@kernel.org>
 <20260213142608.GV2995752@noisy.programming.kicks-ass.net>
 <2026021311-shorten-veal-532c@gregkh>
 <aY9HD7nH5A-DtgmR@tardis.local>
 <2026021326-stark-coastline-c5bc@gregkh>
 <aY9PBfx3RRV7rXZ5@tardis.local>
 <20260217091348.GT1395266@noisy.programming.kicks-ass.net>
 <aZQ19FEeGgigdwz9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZQ19FEeGgigdwz9@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9B93740008
X-Stat-Signature: o6zxu6hi8mu3ot3dstsyhir4gufn6wpn
X-Rspam-User: 
X-HE-Tag: 1771321520-551011
X-HE-Meta: U2FsdGVkX18bvbPpvQ2CdvDC5WAukRBZa4/ChQ4ePnwNs0AsJBj2iDQ5nPkRkl7up026Rb5NgUNCSneuLhOkNrgOX/3ZyIom8ml6j0URfWBQO8ZZMY1QA7i6AbJeoQs/wn6C+LlNTh5tBQaEJbO8G/VMkMkar/xNR+1QYrc0OTwheLP2cobz2TKNT0t0ufGqaNIGHlBy4P5KmQHiC0rhhsUfOhlUjpM1F5AXXQ/C5syJMRvHdmW02esp3eM1be+N0ux66qFSLuqzpGsqun58k3bazlMgqF00Ed23Yx7BL4sU6ShiGxy97Ni30+lszcrMF+oNMGgc8SLztKIBdzjKW/7h21ksWoVcdONudE6DqnZtup/YBdDP7gAgWjfOQL7OJY/dIlIOjsgDQjVOF/D2DySglaaD9s3s84Xq6SLGV6biucLNbt96rSKuFM6L3rWO6FGmriPy7h6p94rdVlMo1NW7fv0gqBBLY0ejpKskAs2h+v/gzbBbvlaT2YleIzIGf5U/sGTzwEFRYGt9ylUz5n+jevTkQvrs8tRIhoy1scdWpQLovNA1urJP5yrhi5bFf32bSSj2/lfDY241HcWpxgDjYv54CAyNwb+UUdwjKlxUgRGKFPLRE/zEpxayNWeutdlEFftpFBMZVBG9DwSjJi7uuUpMzOBk0K2xanaBb5BoT6Zkn9hxJMEt9+OTGSE1Ek4jwsBQn8AqzXA/IhkWQbbgm4Bqik33nSax8YKPf6SggCiYmxHwDUS+Nbd1j89IMqHtfoPIP+Nzl583u8HotOAT7iuzQLZZhkOpER0uvskRgz99T96Jyr5vpWARrNdEN6kz3GL3PPUDYuvJ45w/Ii7MolKXF40qLV8J0Wu0QjMzQAiGZWNJsaGXz6SS9cDPqEAOpwNkIrmrYW2UOoseAtSoNTfmMnpQgq3kGE0l/gjPGcSN/cxePjFhbxUkEr6rzieZndnTFLIjiNDVZnn
 ecdE8q0z
 u4tPKc14n1ATL8fYc0zNpN4mEK4OjpKomo0J4L3H9rLDE1x7XCO/3esTVfvmH+DxmDrGnAPPO8Z3Hel/abMvq61wEVndFyGjTAhURy+orMLtdXFd1ynRXswE0tR4kBncB5EWTy1ytNSgxR6OnIrvPdiE0qUSqegeKxsiUyWGM65VWMuzjMAkZ6gdjxOnj1qqMOwLIEpGQvBLmC4B9DyhVu33bxYG3UzyoTsq914t5JRD8nDMNm9kQ/fzTataaFEjdEUM2LVpNuinTQW2A8rJ7OL7LdZgSzTbAfQ9j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 09:33:40AM +0000, Alice Ryhl wrote:
> On Tue, Feb 17, 2026 at 10:13:48AM +0100, Peter Zijlstra wrote:
> > On Fri, Feb 13, 2026 at 08:19:17AM -0800, Boqun Feng wrote:
> > > Well, in standard C, technically memcpy() has the same problem as Rust's
> > > `core::ptr::copy()` and `core::ptr::copy_nonoverlapping()`, i.e. they
> > > are vulnerable to data races. Our in-kernel memcpy() on the other hand
> > > doesn't have this problem. Why? Because it's volatile byte-wise atomic
> > > per the implementation.
> > 
> > Look at arch/x86/lib/memcpy_64.S, plenty of movq variants there. Not
> > byte-wise.
> 
> movq is a valid implementation of 8 byte-wise copies.
> 
> > Also, not a single atomic operation in sight.
> 
> Relaxed atomics are just mov ops.

They are not atomics at all.

Somewhere along the line 'atomic' seems to have lost any and all meaning
:-(

It must be this C committee and their weasel speak for fear of reality
that has infected everyone or somesuch.

Anyway, all you really want is a normal memcpy and somehow Rust cannot
provide? WTF?!

