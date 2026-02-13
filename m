Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4892DEDF157
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 12:18:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78DCC6B0005; Fri, 13 Feb 2026 07:18:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73C016B0089; Fri, 13 Feb 2026 07:18:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63E326B008A; Fri, 13 Feb 2026 07:18:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 525EB6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:18:29 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F76C1404C7
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 12:18:29 +0000 (UTC)
X-FDA: 84439336338.26.DA5AE24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 68D851C0015
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 12:18:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Z9c50Un4;
	spf=pass (imf18.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770985107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jnOEIQqe81TrFl4gJ5VtTgaTv0HjqYicuVTXZGuXJXY=;
	b=oCqxsXjPSKaX4ynl57kk7/Sl94e26vCvCqkciek++bjqNLO1EE6GJus61a483LHgpu3xuS
	/TpZU8ZvAzaAI8OfVIq/kBLC1XoD+J+sUk7xmfV/vBFdDMQOFPXmbwVCOiiqBaxZzcjboO
	vSAZDLaE7VVT1oitJAqi0tunPAGwCrU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Z9c50Un4;
	spf=pass (imf18.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770985107; a=rsa-sha256;
	cv=none;
	b=7yPo5rJaMvYzrFeYiH7jfVH+0qbCDoHn7ex2j0z66svKhOkcoP0b5yLlcRXAYgwFtmOT+6
	Zro5RdFz0yjc2DWJNBYgz3Uk1zKLnIHJNQsqL6twm/LVY0ksoZWgdTn7qzaUJ6RHyPLb/j
	6pmlAorZyGL89exTIbsUcd2vPSw4SNM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7715D6001A;
	Fri, 13 Feb 2026 12:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A39BC116C6;
	Fri, 13 Feb 2026 12:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770985106;
	bh=bA9tPEg6F6cMG3yOPhPfdhdYSRsjB1sk7KG03VOonmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z9c50Un4muRZPCMs5BvWijkyktP3vyYCSwbHID+YTQkd8/WSGaF1eeWQdjFZQR9OE
	 0zLyIVuNR2oq51nOiiR+twpmf/5QWrAHR2wAY39IX+ov9bW/fGCKtMGqipiWpBEjtv
	 5TkvgfS79LOI0XmGI5yYgNiyopjXp4drKuIoBtzM=
Date: Fri, 13 Feb 2026 13:18:17 +0100
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
Message-ID: <2026021343-germicide-baritone-efe8@gregkh>
References: <20260212-page-volatile-io-v2-1-a36cb97d15c2@kernel.org>
 <20260213095557.GS2995752@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213095557.GS2995752@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 68D851C0015
X-Stat-Signature: 1un1i7dgkcdjkb1einx38d4jxgmq4rr1
X-Rspam-User: 
X-HE-Tag: 1770985107-311166
X-HE-Meta: U2FsdGVkX199ER3o2iGLcwANrzNTENiLW8zOS7ujbuk3+aqDDYe2M1wkNp6st3VR+sYPSdgZdTq8NVcDVeic7YmBfagTyBzJA3OJBGS2ErFBQxT9fnNNR3zYlxv4s15eU0HGu9u27CjeNUE8tDGZvwurvSHI7kiuUPHCcxRuPQK/k/OcBZTX/ysscTQcHP6aCmZgh2pwKiCdW0sBmJzVbLtfOR3JsVUqZ1eHlBmCqyuNLVRSac7+RKsTHN3VeiFOkzifBUurL7EqgAZnvC7nISfvTv8EFs0iAHpCECkha1oMooc+iTgFGLb3yL9PuNoG5urgbeB/fS2oGcLePdzVGOEDluSCLdCeHWLrVaTW17bUZZf9IviUrNTdSUAcXlZ7nGB7jSY1A/sb5uvGADtxKWjtSd0V8B4bxB6iCH25yH8FhVrl9tKfwwngRbHnojJqQx7BC9vKSO+ClQgv7LiRx6ZSTHXMVE+QdD5Zd3dPeZINJ6VJNIbw3EwjgS8L85VPD5xPV0CiuPWkL6+15ZomRpFCXaGis2uvV7IA6G8TeVGkdxIeTPrGlsOJUYT5+vFRosOPcWWzFKRoaJo0xXFAIAWyM3GZCrKk7l+aqpecsnrmuWLK7X50BNPt2KplC0Y0g3xKAEWs2gsCtnSUuZOKZz1tp8f7s1thLyVmPS+p1Ks/HqlZcTIA+Sh582V5frCqPVxAc+xa6zllLjiwcnT3kC/XaWW3GvWp9htQO1uVv4lHc87Dt9q7RhHMTrVlDuhU2NiN5WIWEQLGObxWPUwCuaxma3wMDgprmzT3997+Vz+SguVViinKYALamzMCV7bh7SX7uHRZMzucUm1sAk30ue3Z0wBwC7yUrsiEeKZnU0cK6vLJ/SeRG01GnjNUb+keHvMKqamrNH2oea3YB2sJYJNgW0QTbzaZuv4QjDZyRvVLEGzB88aM85BMB9oZeAtg9T8h87tvupiwDzTX1Oy
 UQMNQT/h
 tpKIP/zqzhTY/MpMJ94Fa+ZE6hWHwXOHMI7MRGF43vv4dycmvTFA4OmMVqFTepm8/IAy5kuq+1UFDWyd94mtOITvo6xRxI4h57SqHjdUvANaC6J5HsMh4da34H0knPIF74CkmQWuzozUOHsfP65HKQ3HYJgyk0XQfYkMBKVdhrNmPr2Q6WlIbzaCsjeS7R6FOppY4fMzi9FNTAEFejwkA64aQOEOJC9nOao8ejKYxYRcZIL7+8/G9uvR8mTSdehK2n3wnPgvZhohn+DNyhvkHDvBk2dqontuhbYO53RUyC+fx2weSjwNhJC4A+mV7rJY3skWC/NRA4maYkzM3rtKLv86Z1fN3KAOoMMWZOulQhH1USM0Lrrtxw1sZ6156YgbQSFmrMi+gMJVWiNQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 10:55:57AM +0100, Peter Zijlstra wrote:
> On Thu, Feb 12, 2026 at 03:51:24PM +0100, Andreas Hindborg wrote:
> > When copying data from buffers that are mapped to user space, it is
> > impossible to guarantee absence of concurrent memory operations on those
> > buffers. Copying data to/from `Page` from/to these buffers would be
> > undefined behavior if no special considerations are made.
> > 
> > Add methods on `Page` to read and write the contents using byte-wise atomic
> > operations.
> 
> I'm completely failing to understand. What!?
> 
> There is no such thing as an 'atomic' byte load, nor does it help one
> whit against concurrent modification of the memory you're copying.

I too am totally confused when reading this patch, and the previous
ones.  Shouldn't the "normal" copy_from_user() stuff be used here
correctly?  Why is anything new needed?

thanks,

greg k-h

