Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EED1E68149
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 09:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED2D16B0089; Tue, 17 Feb 2026 04:17:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80786B008A; Tue, 17 Feb 2026 04:17:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D82D16B008C; Tue, 17 Feb 2026 04:17:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C30B06B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 04:17:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66917C4458
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:17:30 +0000 (UTC)
X-FDA: 84453395460.24.AD38EB3
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf08.hostedemail.com (Postfix) with ESMTP id B336816000D
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:17:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=QZlDrP5Y;
	spf=none (imf08.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771319848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NMcaCvJ+VsP6giBf7ZN1YSDtg3HQ/fOah5gzjE9s5r8=;
	b=vvh9YIZNhM8BIoDQ9o1eKNv9rXLebV9HK662Ko241wt1UK+HJqoF1Doq0792yUrBhHsORT
	dL/ILWOIlGtQecZPfwdOp2Qo3oH1Eg2VGm6Kq0t9c8fhH+zNKihbpYkDRDCZWmOgdA6PNU
	Ok6bqLynDLvfk7EyySqZbwylOqmMs+8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=QZlDrP5Y;
	spf=none (imf08.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771319848; a=rsa-sha256;
	cv=none;
	b=dYAwe7SgNt1AIPcCV3RyBvQ9AFY0YWi/dWoe0/8obFxdln7rdKuH4I/vDIcqzEweU7Jnz+
	Wcd+cE7u4H3YYZwVvR3jm/1sJuIWHaFOjSKMludBU6DP0t0SJkLs7oFNgyirX2/JjMtFiQ
	ccpvr2E0EnvBQgEeRK+4wiP+VB2XqYU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NMcaCvJ+VsP6giBf7ZN1YSDtg3HQ/fOah5gzjE9s5r8=; b=QZlDrP5Y0JpwgCqf29i4FnN/Nu
	Iko1dF7HxW+ARiccGLYmXJN4amHanoHJai1FlCcBNgV8bZyS1klk8UZ+N8f5TBumj2ZEsJTPZd0Wi
	jtfcFU1AnXOOo1bGYjaIDGWRAsa0RmO7y2FY1qvHeMk4W33YFQLt8/S6O4aeApNth5zqEj6QjFVmu
	EVe90V71dcXClO75FXC4DyHGhKSFwS3oTLcn1jBvGZmEF/RnPKrC5UqVejsEDxJkW6C1UasvQxvuP
	o+zZTCYXTAnga9lWEf6E9rrJZaXTLL4C6d2P2BG+m3dNUqUm1Zb+L96JExEZd1OuCJM4UJAAd70eR
	ZLFszwEg==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsHCu-0000000Fe2o-2CHV;
	Tue, 17 Feb 2026 09:17:24 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id CA152300CDE; Tue, 17 Feb 2026 10:17:23 +0100 (CET)
Date: Tue, 17 Feb 2026 10:17:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Boqun Feng <boqun@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
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
Message-ID: <20260217091723.GU1395266@noisy.programming.kicks-ass.net>
References: <20260213095557.GS2995752@noisy.programming.kicks-ass.net>
 <40xUh92AU5E9oFxQrdej-AXVg76jmaWGKXZMLoOHXe35Lw9x_eNEoLup9bB60LyGZ_0USPmoxr-9hE3ujA67cQ==@protonmail.internalid>
 <2026021343-germicide-baritone-efe8@gregkh>
 <877bsgu7fb.fsf@kernel.org>
 <TZXRjQ6gkmJNdRcfDVKKEl8Zd-8b7HBCLMrrPXyXYq9HmsVE8BJS4a6FE-YxxNsOBrIQl1fiOvfS19rLkPSmiQ==@protonmail.internalid>
 <2026021313-embody-deprive-9da5@gregkh>
 <873434u3yq.fsf@kernel.org>
 <20260213142608.GV2995752@noisy.programming.kicks-ass.net>
 <2026021311-shorten-veal-532c@gregkh>
 <aY9HD7nH5A-DtgmR@tardis.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY9HD7nH5A-DtgmR@tardis.local>
X-Rspam-User: 
X-Rspamd-Queue-Id: B336816000D
X-Rspamd-Server: rspam07
X-Stat-Signature: b3k3w65fbn1j5pnuytynowu53ndsjgks
X-HE-Tag: 1771319848-372593
X-HE-Meta: U2FsdGVkX1+6TQKR2Gue2qKAKvK4vvr07fndYKHUhmaFbMHRhuJQaWT0Q5/JapVYgvFaYTkl99eJ8bFw0xKsKlNxRuRkWRAGmevU8NW2WknS9PZUd1YsDY8ykLP8R21OW16fnIwg8G7iWYAI+EHyv11oAJ8G6acFjUu+ddPPLmlcQIu8yq2hgaIIvhg//xJw0IimwOF+f8yAD0QL5KV0M5yqQu+aHqAVSs5ZC54i53cU4gVFDC9dNlJHDDaw8y8Xcb2UF/UHKz3QVQn8dQ/hO8y/O617+hMEGkSQGC4F1FNoSac0yq8UbaXKwsPMAFkFLrIE75YKWipLwJ7LdywrwhYHGYzOkJZX8jTsHzsNXlhX3/tJNkcgLmIxCgdwSBc7PrtEY/5baV5OmNnW2jNnMwRLrvKuRKd7vGdNMHiTfIM7oDEEfN+qdpz5HJStVdlcQ5hYY9Tc/3TR/9qouhZRC/8Ambtk+1+WDQVXkoYsuEV7qtK3Ox2JaCzozPb83zzv8sIDWXj1eHAghD55JMYF5VQmPPhyv8kf+3LtuT2t6YHWJ5ngt78jRS3LnCPo2JB5El7MzsoRphMufrWdTtKJ59Ur78i/anweeXAoHPXgrY5z9BoQV53wdTwv/eHaCEGuVj7/yFdVb9j6T9w2Gw+9z80HXlGd+qHluA22O6HnmPffORQ1nd8RYWXqhmwJYjX6Icu3R18UX1Nx56VdsSEQZP3M2aMwJuh5eQM1oiyGWz0/wbUGwCDWTe35D1a5K99hffDkvTluu99RirNV8m2qnmIlsOT9GzMIsYW6bTUZzf01PR2nEtJej//rTB/cFQEZubX5rt9JGlVitjD6YqF5o3hEipogineYB4w2gj99Q4yP3Fvpq9xoP3ZNt9RzH7GXbSR4AbPCtfKKqbzHerVjnDIt2LHPKjZx/nrtN7fbTXVXn2GijivvrLw8HgzLvZ67BR+Z/qd543bWd+1GT+G
 5jN4GhE7
 dFn5rhRcWbbrBInLnXHZVtQTT0aFgm5rBhXTDVJ4W7HtKDpS9y3WcapO8EPClYbsDhHLHtN88iNh65MmpHmqlRsxtr+bizO1vNVrFxAmAAjDDQndX24adR5EA+Tn/IBCQWpF/a0Pp6V3zFgPKwTyBe+HCucp4Z10ZHeMT7iKcxESlAqTYo40nRhItWY6SPbjsjX37yM7dp4eZiDRCA8uV8L61yBuTAmxnJNjmU1vGU1IyLe3XJ490xKSq1iIuirbuChMC87Cf2+BW9vBpocbseOrsxktvesl3ub/3M+JJDWjhULsrxzH0Jd+lI5iuzn4OIhCpgDQlG0V/kDqq3+/Grn9svA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 07:45:19AM -0800, Boqun Feng wrote:

> > > Suppose the memory was 'AAAA' and while you're reading it, it is written
> > > to be 'BBBB'. The resulting copy can be any combination of
> > > '[AB][AB][AB][AB]'. Not one of them is better than the other.
> > > 
> 
> The idea is if using Rust's own `core::ptr::copy()` or
> `core::ptr::copy_nonoverlapping()`, you may get `CCCC`, because they are
> not semantically guaranteed atomic per byte (i.e. tearing can happen at
> bit level, because they are not designed for using in case of data
> races, and there is no defined asm implementation of them, compilers can
> do anything).

How the heck would they do out-of-thin-air? Any memcpy() implementation
that can cause that is insane and broken.

Compilers are broken crap if they do this.

