Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2788FEDF175
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 15:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 495796B0005; Fri, 13 Feb 2026 10:34:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4430C6B0088; Fri, 13 Feb 2026 10:34:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 324EF6B008A; Fri, 13 Feb 2026 10:34:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 219EA6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:34:10 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D631EC136D
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:34:09 +0000 (UTC)
X-FDA: 84439829418.27.1F02A7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4F07D180009
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:34:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=EjThWCDg;
	spf=pass (imf06.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770996848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I67gEZyOc1qNvyItMzBIt/zvGrgE5TimEPWHsHHxKYI=;
	b=LT+TMtg7rvWPGPIL+pKFcO38jJLPPiDEgid5xOKX3eMRJmXpVQutJKd+tqwI1pxwRdb/ZU
	U4aLFmfAKF5xnGozDgAXiNren5ryo2bqVA3tRZRroh77XbSRMD+YykHyIO8XyXmkRuzZap
	BaiWpSE21K+mDIsWF8Q7NlzYuI8Ugks=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=EjThWCDg;
	spf=pass (imf06.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770996848; a=rsa-sha256;
	cv=none;
	b=cZG0Vg4ParZXudsO0/2wHyDfcRruzMbfFNupxe2ZIK3uMy+c3vrqHscHh2VXLnX9hUgt7b
	SGi/KClEmEav3v5XGbP+1gMgE8q1E+8MJM0BgUWl6j+LOhFEb5vp6AOI37xksGDOeYaC5L
	v2lLTlxaPvO8SEKGIgeeA7xLG8cIavM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E47960054;
	Fri, 13 Feb 2026 15:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98140C116C6;
	Fri, 13 Feb 2026 15:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770996847;
	bh=36/Z6rZPm8oNQHcyjYevKW/IjMhRwzkHb/9A18Ph3Cc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EjThWCDggdVZsiY4hLoTcNGIfXz4yYtGFQIl5XKl6PmhNjKFq+boUqlEtjuRS+5NI
	 boDwh6BeFOoBqEF7Y5zAq68Qjd4DpZDclyr7OTZ9BFQa7O9Ek4Loq/BfA3JlUCxEmh
	 Y242uqstBw3Mpjf/vED3nv6RAuZEGAodfxzAyWDc=
Date: Fri, 13 Feb 2026 16:34:04 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>,
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
Message-ID: <2026021311-shorten-veal-532c@gregkh>
References: <20260212-page-volatile-io-v2-1-a36cb97d15c2@kernel.org>
 <20260213095557.GS2995752@noisy.programming.kicks-ass.net>
 <40xUh92AU5E9oFxQrdej-AXVg76jmaWGKXZMLoOHXe35Lw9x_eNEoLup9bB60LyGZ_0USPmoxr-9hE3ujA67cQ==@protonmail.internalid>
 <2026021343-germicide-baritone-efe8@gregkh>
 <877bsgu7fb.fsf@kernel.org>
 <TZXRjQ6gkmJNdRcfDVKKEl8Zd-8b7HBCLMrrPXyXYq9HmsVE8BJS4a6FE-YxxNsOBrIQl1fiOvfS19rLkPSmiQ==@protonmail.internalid>
 <2026021313-embody-deprive-9da5@gregkh>
 <873434u3yq.fsf@kernel.org>
 <20260213142608.GV2995752@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213142608.GV2995752@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4F07D180009
X-Stat-Signature: 8as76ytq913estjn5pq89fdgzcumaj49
X-Rspam-User: 
X-HE-Tag: 1770996848-965206
X-HE-Meta: U2FsdGVkX1971JyrzUYvc3zRXUepUdj+TSIEQZjU6boOnJ8OTvB4wGEp9tP29ybdZTof7V/rXdVMqnxhejisVDFEuEXamp8cXMLOCEqSuFVuvekV6kK9E6O9Qc6pcUBXB6eAdux8el8D4tnX3eFicQkcNv6KBHFVz48/eaCEFbQZdZzGIaepf5qo84PpA+gGVN+bcr9O0jlyEcWLv3t5ZC64PfuRtpeGdk2bWmOEXLW6kxvInZgiJa543KYHZJte47sCmTTat7hIv30HLOHM5Yl6jsRiM4/L65x0bV/N9cOClN8gnrcfaL6N+oXmNKJxJwzcBHBjSdLqXSMW3+D//fONR7aEifvrP8IYZfP4iZ3/C8gCGWIntoJjoLUMi245TU8WjqBuhKnralPHTNV6WYQ9mFxFMgbvS3u+PdE467vt++b9YhLiMtajnn+Fx5nGeMS9rI5jTBEfwu3QspAftLaWBimzRBA8PPDJp2fV/lUVe/7SxRGtHiM19Z162d4SyyOrQ3lyvSxeANC6lgNImCwDq+1eBbkqakbpT+uATax8bi/89rjQy1Z8je6kuyGvIrYLGC4r1w6ooSJEY0oR3mHOoEuQ5++nNJZshgSjdI1ENS+xgaKdYM3oFCJRtEe6X5+GN1+OIxNEJSyMDiUPPHiEFP/3YdD3CxdJOwms9YFEfIIweovppUmqbVGrwZPwmObyln/g7q9KGeWtyOJRDkRr3PzK6lGqzDeaND/vt3CiqvqlbqLJat4J07KUZFPs8xjpyb1SvsNdYEGBdNvxCpx523SKjsKn6fU0b3wyOPlw3v7mvE8n/y2RovLgwuAqCAR830VL+mGV6amQS3/zPiNiauzfonUi4B4rAJmMkViknCZ9n0Ga8IhDn5PR2KmG7t6MXxN/oQt+O1nSdo9QfM9WyJQ0UnoJGmaYz1vBc4davCnqAnVZFWJp5jfLOB3MXO6O5GDpJzNfVHhL+Tm
 2FTqrF37
 hzmM/HlEsNmaWn8AZu3u0rkMz2xUdx8enXbLt4cofxB4Q8IPjVqbP8CsK1hdc1SnKQ7XDHKqTeZb5iBCZ/3XHKZ9P2AWmnxxyrDGj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 03:26:08PM +0100, Peter Zijlstra wrote:
> On Fri, Feb 13, 2026 at 03:13:01PM +0100, Andreas Hindborg wrote:
> 
> > C uses memcpy as seen in `bio_copy_data_iter` [1] and in the null_blk
> > driver [2].
> 
> Right. And that is *fine*.
> 
> > Rust has `core::ptr::copy` and `core::ptr::copy_nonoverlapping`. I was
> > informed these are not safe to use if source or destination may incur
> > data races, and that we need an operation that is volatile or byte-wise
> > atomic [3].
> 
> Safe how? It should just copy N bytes. Whatever it thinks those bytes
> are.
> 
> Nothing can guard against concurrent modification. If there is, you get
> to keep the pieces. Pretending anything else is delusional.
> 
> Suppose the memory was 'AAAA' and while you're reading it, it is written
> to be 'BBBB'. The resulting copy can be any combination of
> '[AB][AB][AB][AB]'. Not one of them is better than the other.
> 
> No byte wise volatile barrier using nonsense is going to make this any
> better.
> 

I'm with Peter, just call memcpy() like the C code does, and you will be
"fine" (with a note that "fine" better include checking the data really
is what you think it is if you are going to do anything based on it and
not just pass it off to the hardware.)

thanks,

greg k-h

