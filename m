Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D73EDF15D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 13:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22C366B008A; Fri, 13 Feb 2026 08:20:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E36D6B008C; Fri, 13 Feb 2026 08:20:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 106DC6B0092; Fri, 13 Feb 2026 08:20:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F17616B008A
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 08:20:58 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B567B9B0F
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 13:20:58 +0000 (UTC)
X-FDA: 84439493796.14.34161C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id CB0E2140006
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 13:20:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=WZl+2gWG;
	spf=pass (imf23.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770988856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aWyhuWtqhZQDDDihzr5gWAPYRFi8q4/kkyhQgDqGj3c=;
	b=sWTrAIuNLJFxRTpnMfQIF98YrUbdFe3h9aH98cZh6WnY/AT3wHuSseYnk5qclc3hljx9Wi
	C7PPdPCGQueKBF0XKxkIw2GQfQo8tzncAAKYLNWAsaZqI2BI0PA5R8Yt8281+IOXUQzGCk
	3PUvnQgfWcv2rjEtH6bZi0jTfykLcJ4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=WZl+2gWG;
	spf=pass (imf23.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770988857; a=rsa-sha256;
	cv=none;
	b=Q8XZ5yRS7s5F64YN5UsliJIoxuEQIXsO7TcYr9/nuK5V1KXs39hvVDervkNDIgPNv5Pngs
	YoD2AjeWLPgUw7EVKhWA+ea6V7K4DJIYeGXAqtaPF2x/cCaAvRroAbmBoI4tyseViTMW8y
	dy8jWba/RilY6T49bxs8zkbMLeVasQ8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 16CC56091C;
	Fri, 13 Feb 2026 13:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CDEC116C6;
	Fri, 13 Feb 2026 13:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770988855;
	bh=hF4hv4U8p+fXcqD0HeUigo1N9WJ/LrK0qTkc3d8CqZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WZl+2gWGc93SuLHD4CnWD+hQssKxOpcWz9hcZ32PuaKgxz1X4V2R+kvwXaHkSmVqd
	 tlG9L7jzsE6KO7eA0Zlpxy/9ko7W7SlARnrVZcnZ2hZgxW0pd4kr1ZZw1EZiu1r9hN
	 sKNGN/L3asPmz45cndh8BcLCSDv7YqlXGATM7MdQ=
Date: Fri, 13 Feb 2026 14:20:52 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <2026021313-embody-deprive-9da5@gregkh>
References: <20260212-page-volatile-io-v2-1-a36cb97d15c2@kernel.org>
 <20260213095557.GS2995752@noisy.programming.kicks-ass.net>
 <40xUh92AU5E9oFxQrdej-AXVg76jmaWGKXZMLoOHXe35Lw9x_eNEoLup9bB60LyGZ_0USPmoxr-9hE3ujA67cQ==@protonmail.internalid>
 <2026021343-germicide-baritone-efe8@gregkh>
 <877bsgu7fb.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877bsgu7fb.fsf@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: trq8rbw6sgmxyok6un4xsn7efrghaxs5
X-Rspamd-Queue-Id: CB0E2140006
X-Rspam-User: 
X-HE-Tag: 1770988856-517793
X-HE-Meta: U2FsdGVkX1/fAqAeWmpfswoaiid+sC8jBsqSqAcSOzjRIKa4yZVfIgkpwqWSzuRTSgXRv2KZbQitXu9AJnV9rGuYHK6LsFdl6+mVP0KNbTza9aPdP9Sop+zJB2jfwAnBn5XfUIjAaxMKlHSwYjU/0zVXwr5gOYJ0nPuRBZ5MyZAosVQOIHyXc0RFknSCrndfdrh3f6lE38J8f5vieOOW5lswXZCPYf3uBVXzuCD+LplOOw7llKHlDlyl65hMrGL8PzrJjph71hI0y6XFVZ6PEM2p+htkUjNowhUTvwJXMZWWfnlJg1SKtYwNQcn7Cusec4Z2nEE/AQ02IGWe7ItAxJtNmcaW40oRMF/VbpN8JVFHiWT5oCH5WwMzYpC5wZOc8v1tjMYzKA5aGKBM6vFd6Ntl+/AiZHl32wOHbGnBihTrhiGVONtUu/yY9hV1N576Tw2SgeAynNc+jzZ7ouIA5qhaxkmEVCrkAnSEHXgA0TlKsEPG8iHZJlYEy7Xz/SaMjxuJdvpDj8LeX7DgQ/JWH/dWlFTQwhpShC3ww6qirNYFZCh5k8YNY7GWAuiRnA6LyXxIRszXYgo6KuNpUnv8VAWwxcr465/+mkoBrm+6Sf/IdNBs6Bll+1lcvxYCG21iWtHhgC3BQHnrHu0pzugKMNOEUkwGepZAST7Dsj4SRlpX8z7inP4+j9JQmprIWlSDvhTegi8+nn662hFDT/juXNbgJwhg4onsd0oVn9KyePQzuQD3LNCfwGX49EIyTcXutub1eFaO2rp2cAPltPnVeNTXDmWwBlcK5+zlgpuwL2GQZqqVfrrrPAeWS1YkYJkJg1ALgLoYtwLsE8f9hSdr9zmVs6zu4jT+k9XQFgv+HxGimVcPAHifsrMfm7OLi0GtRmGisMh6PAdmmu6MuoUI7Qu+EEEuJSVb92n0rdwWbUu6F+iBPtsPqBvdlMBUw4P9Fln0i1OUqwgxS9EL5/h
 z1kk4R5q
 s/3qRlbmxQCqiaiKkaVa2HSEgOalAw1u9gzeWtAGw/63JeRIgdXG4r+odLaPAg7I93eWHmXsFybybgMJRq9nT21rYUZEXbnnRem3hX60ppKON0HxPpkGjugJaKyi1wLlyxywutVEOgDXFUv6BVZr6h5m9uhtbP7/4NcNRr4ucNkd4qzscsmOL/ue0tOn15VAx1jFT20lu1FTpzrtH0IhuFPdwfukonjX0ncHkp7reN9ULJNAJNRIqryjPqDd8P5GrZcHHaS7xONg7RNZoEKrMYn2r+xJwkCgI42B3b3r8xq6przIqZU/p5ORQX6ozT60AcZR0gIpwEXUyhXvZN6Rq+fCZoGuD8w5pwOIP9Offsk4IThn0qBniUnEik2cdBr7g/yxJsGHiAqwI35+V6N0u3saMfw+kbtWCPUYc3bsz2gjOV/+f86M8ElFSMlf2jCDTKoUn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 01:58:16PM +0100, Andreas Hindborg wrote:
> "Greg KH" <gregkh@linuxfoundation.org> writes:
> 
> > On Fri, Feb 13, 2026 at 10:55:57AM +0100, Peter Zijlstra wrote:
> >> On Thu, Feb 12, 2026 at 03:51:24PM +0100, Andreas Hindborg wrote:
> >> > When copying data from buffers that are mapped to user space, it is
> >> > impossible to guarantee absence of concurrent memory operations on those
> >> > buffers. Copying data to/from `Page` from/to these buffers would be
> >> > undefined behavior if no special considerations are made.
> >> >
> >> > Add methods on `Page` to read and write the contents using byte-wise atomic
> >> > operations.
> >>
> >> I'm completely failing to understand. What!?
> >>
> >> There is no such thing as an 'atomic' byte load, nor does it help one
> >> whit against concurrent modification of the memory you're copying.
> >
> > I too am totally confused when reading this patch, and the previous
> > ones.  Shouldn't the "normal" copy_from_user() stuff be used here
> > correctly?  Why is anything new needed?
> 
> One use for this is copying data out of a `struct bio_vec`. As far as I
> know, there is no way to know where the pages backing a bio_vec are
> mapped. They could be mapped to user space.

And how does C code do this today?  Surely there's a function that is
used there that we should also be using here, right?  Why do we need
something different?

thanks,

greg k-h

