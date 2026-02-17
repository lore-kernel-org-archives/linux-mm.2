Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E683FE68149
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 09:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B7FF6B0089; Tue, 17 Feb 2026 04:23:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30C7F6B0092; Tue, 17 Feb 2026 04:23:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B1D6B008A; Tue, 17 Feb 2026 04:23:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7E336B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 04:23:51 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7698B1B59B4
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:23:51 +0000 (UTC)
X-FDA: 84453411462.05.1C7EC3B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id CD4A5A0008
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:23:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TUngalgS;
	spf=none (imf25.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771320229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iX6DVKaOmRNUphQ+gsku4eCSaCPlo3eiT9uIdeHPd64=;
	b=o9UGEh4KHA0Oo9e/34gXFNbdvsi1/Bc97Y0rpqwhzGpzd24TStifPsW3lF9b5WdEsz/omX
	CdJA3THUrk7K85nvaHHWlMs/yQc3zqerFxg4QmCSWX2/JKewWVQYf7z24SfhDAoGFEnu+t
	Aa5JxlYt5lje0HbUn944lUNuOsVTFMc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TUngalgS;
	spf=none (imf25.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771320229; a=rsa-sha256;
	cv=none;
	b=fi+AQ+wR96jfiOhlXlxv1ZupT+iYVNxoc1+rlZ6x15BaFP7Oplzps6MVeuXerSchQA60kh
	PcDlDbzB5tzQHSuX9UlsOKW9M/3PlKn8gPGJzrqevCHxpYe9shUFrnErGHvK8rhg6A7TPe
	nqNdrlLwu9Z3IxJPaeW2y2D39tpf5R8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iX6DVKaOmRNUphQ+gsku4eCSaCPlo3eiT9uIdeHPd64=; b=TUngalgSiiUh7OzQPWb8KAeqHh
	36TmNB+sI2sitzB+CRkfdZBErBbd5atXi5DEY83NRo2CT87iEgGB1ZcPFRsoMd6jWhxIuzd3CUlJ6
	3zvwUUACkyFXtHoUSEQ+jqHwYKVTs6o+7lamojMQMSKVLIcBYnRP2E3w2xmzbTajNtHUBf6CYYztT
	yKZ1ncJIlhq4Va98hyTjnKFsAoTTCqAUWlva2Sqn5XNK38vthFvNL4+leN9Lg2BpRLaiknOHjg1lp
	nyLyFOx8ukoLRp5FC/AVDTUC9jQotLUCFAQ8/7zipPsqKugW8ih1U/WA58rQCeT5f7GC08redGfpL
	cXZIaJZw==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsHJ2-00000004DSl-1nIr;
	Tue, 17 Feb 2026 09:23:44 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C7EF9300CDE; Tue, 17 Feb 2026 10:23:43 +0100 (CET)
Date: Tue, 17 Feb 2026 10:23:43 +0100
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
Message-ID: <20260217092343.GN1395416@noisy.programming.kicks-ass.net>
References: <40xUh92AU5E9oFxQrdej-AXVg76jmaWGKXZMLoOHXe35Lw9x_eNEoLup9bB60LyGZ_0USPmoxr-9hE3ujA67cQ==@protonmail.internalid>
 <2026021343-germicide-baritone-efe8@gregkh>
 <877bsgu7fb.fsf@kernel.org>
 <TZXRjQ6gkmJNdRcfDVKKEl8Zd-8b7HBCLMrrPXyXYq9HmsVE8BJS4a6FE-YxxNsOBrIQl1fiOvfS19rLkPSmiQ==@protonmail.internalid>
 <2026021313-embody-deprive-9da5@gregkh>
 <873434u3yq.fsf@kernel.org>
 <20260213142608.GV2995752@noisy.programming.kicks-ass.net>
 <2026021311-shorten-veal-532c@gregkh>
 <aY9HD7nH5A-DtgmR@tardis.local>
 <20260217091723.GU1395266@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217091723.GU1395266@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam12
X-Stat-Signature: ihn4nji7ky6fegy3hc8rzu9d496frmr5
X-Rspamd-Queue-Id: CD4A5A0008
X-Rspam-User: 
X-HE-Tag: 1771320229-70949
X-HE-Meta: U2FsdGVkX18wHzQ5cCB9nzw1zTmPcRHkafqT4qBS9sBeEnR3DBz4xFFbYOil9l+fkEYuwEKZMNyqBeAxk3e7Z6DB6OgUGmOtLK/2ZNgW5NTOc3qbtdc3noMlmYYApyuGFdI2WymTYnbA8YwnIXS/40KZGDj52L6jSuV1KJVzgpibm7U2imMjQwoS6Ty+38eRvtquUwdAEerU3cnXpmUkqgClHZiZaVZxtTGU6BQRuZC7095iDRKFt7Cyousng5p0ZEoleq1YqDULiNlR0J7NhNmQSUzG7z8zA/j1UHkyHoS4On/9WLkFdfBNzKIIConxnsloDNOmv0XLvUkbrSZcAwcPRmTedI036rUjovDCuF4I0AbMMkEa7ClUB0WqbgpVfn+yEihUkkmTBccZ91F6VtR1mjto1wmXZX3q76vvJww3oz/XlrtJKDX9B359YyGZ6GYfIZruKhiOJL0g6YOUX6W5pMxj0aAYuCqk7SwLd8nQF/69uuGd9MVWTMMHj5JwFQ32DD4VLUCGDj5HqqSDIJt8qWWvJlEFbfSPyU5DfEwxF19vXfWcKLG0olIC3pE8wYeQWDXKBEF8AJxqJLregR8Xzn6cXbm/qpSCfGmXvXJST6euSiFRthQH1qIcauVtp/y8EglC8h2rtAIt52NbWTs+tDuT0e455vak/0tGQfzbD1942cEhsyj7IkxOf8ckEoEPMLXPUV3AfLPcJ5PZqfbXiTfmpOLd0S4eEYRAGaGkpOgMSWICs0vb5G6EpDpenOUi5Sv1nHPfaIp8IGNkktX34cqe/mYr1sAUYfcBtqGx37VjYfLF7unNi1PehPMHNlZgo7Lhf2zVQKxyODnMpnhr+JTaE1B9SHE/eCOUG1mTKTQTcY0OypHbGel2WyiOzo4Qnp7EqFFQ9ZWzNwmEeEfuSRq3ikLW+ycdWAcqTLiBpbysQZ35QrYRWss36vCiGefE5M76wWvTPmXLZlw
 pDKY+jHE
 rfcH/OqQf9kGril2tW/k+Sl32fiXkAb11tJaLXdC5Xkg6kuLcQ/jGXzM8ofBvkUKzgDjTp9sgJP+zEGa9IdK0icRdfPBrrU8yT5cTCqkH0/PiQq8eEx0TuG7fP8rPS34U6NtFIpAZWgTFW9yRZ+gbeXwsfaK4F9aBbRuG1zXqJXJ0dcUrfmLx+j0npT5bGH/4ZzdAoZ3CpjzQt362p3AF1TQmouDKJQYNCYwkDxXb2Xz86yqbsDtsnglfjjpuxo24zxVelkphl3bRsuQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 10:17:23AM +0100, Peter Zijlstra wrote:
> On Fri, Feb 13, 2026 at 07:45:19AM -0800, Boqun Feng wrote:
> 
> > > > Suppose the memory was 'AAAA' and while you're reading it, it is written
> > > > to be 'BBBB'. The resulting copy can be any combination of
> > > > '[AB][AB][AB][AB]'. Not one of them is better than the other.
> > > > 
> > 
> > The idea is if using Rust's own `core::ptr::copy()` or
> > `core::ptr::copy_nonoverlapping()`, you may get `CCCC`, because they are
> > not semantically guaranteed atomic per byte (i.e. tearing can happen at
> > bit level, because they are not designed for using in case of data
> > races, and there is no defined asm implementation of them, compilers can
> > do anything).
> 
> How the heck would they do out-of-thin-air? Any memcpy() implementation
> that can cause that is insane and broken.
> 
> Compilers are broken crap if they do this.

If rust core code can cause this, I stand by my earlier position that we
should not want that anywhere near the kernel. There is a reason our C
code is free standing.

So fix Rust to not be broken or take it out.

