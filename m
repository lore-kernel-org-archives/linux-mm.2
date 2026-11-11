Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54A13606A339
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=CYXD1D4R
Received: by kanga.kvack.org (Postfix)
	id 71DB06B05B5; Wed, 11 Nov 2026 04:30:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6146B05C0; Wed, 11 Nov 2026 04:30:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 595B06B05C1; Wed, 11 Nov 2026 04:30:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 344566B05B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:30:26 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA4B2140236
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:30:25 +0000 (UTC)
X-FDA: 85422317610.06.269D052
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9A1014000D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:30:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=CYXD1D4R;
	spf=pass (imf27.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389424;
	b=Pas/GmtUXh+zS3o7ee/l4rApmnzVBftwCFFisuPXvXcoIrARvP3r3amLO9OWJMxPuy7hcx
	QR8hz2Zd9X5GDucLBjZBqOwaBfuQrvJHthw6wMvsJYK5e660Rm+M+hTtZjPtsZT076DqmV
	dYmNccO1cgqtSATXF3OQviBzXddJJCI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=CYXD1D4R;
	spf=pass (imf27.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84mNVAxJB/4EPEIoYQQ2iI0OwXIBX5UcAERwTVjPWHY=;
	b=oHKgCISX7/MQLeMUNvQfopipWaxA8/4sx9+vjsubiMahk51ryE4M2RAlOpsGXX4sTRwPZi
	4PhKxMbpa+vXmUPq9OTlUKSxj/moxUAxjZvuF3AjCIDUSDriTMps/iZGVOfq2eWuOzsvt+
	yhv0t69TDX6lQDRAr3xF4ZCc3FVH4j0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=84mNVAxJB/4EPEIoYQQ2iI0OwXIBX5UcAERwTVjPWHY=; b=CYXD1D4RloSJvjkVTIKKM0ZLEH
	L71IzC0gJbd/iXHNJVQ+RyUh59BZ66wBfR+Ej+dxaM/fK3HF7i2z21HUaxVPIjXauhMjhYK8ELgww
	BXMSuL2dopUT5z6F8kyEEr7kQGK+JzRGowhDSp6pfgdiFq0bTgndsQ5qV/ch/zNB9dEVdeDF5RyK3
	DWr+yJID/of+vcCT+JKjXNhYKJ1k+vxiIVKqqOu3EF0aX28RJtcqT8AuM+9a8fbVPpZ0pZlzbV9pW
	ps0RfGrNFHYXkOlo5oFwmfBKGL4lb4IOFlb4qzEN2WHRmiYUJd2VT9+7TT9yA8crTPoorn1KuU0H7
	Sg/w4iwQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xR4eo-00000008yUr-2gtD;
	Wed, 11 Nov 2026 09:30:18 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2659B303011; Wed, 11 Nov 2026 10:30:17 +0100 (CET)
Date: Wed, 11 Nov 2026 10:30:17 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Lyude Paul <lyude@redhat.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	driver-core@lists.linux.dev
Subject: Re: [PATCH v5 0/4] rust: byte-wise atomic copies between `Page` and
 shared memory
Message-ID: <20261111093017.GX2668804@noisy.programming.kicks-ass.net>
References: <20261110-page-volatile-io-v5-0-a91ef252c24b@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-page-volatile-io-v5-0-a91ef252c24b@kernel.org>
X-Stat-Signature: ddoo46bw3ua1gdyu5kakn8k5cyu6m4rf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9A1014000D
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794389423-138546
X-HE-Meta: U2FsdGVkX1/X5F0xAaGAi/3uYNcEMC68S4RoFjYam7qCY2kRhBCqyH/HqxLZpX8/ka4uBelAuLaHTAnqDCZfyXw7TeP6dz95XlBTbzRgT9xsxGNZSdFWKSe7qmeEQSOWRWWiwc9vMhHHv6Lg9V44y+zfrNYxqzlf1LsPpwJ9oCZc0feb7SSV9Y7uXR4IP817zMR9IOJWnwbIjZFe+Ukbe5WIclioXAuYO0QFMCNcCAgMJkTVbeiBeKA8q6XItX+fOrp9g84JVrVZb/8PvAAAhBbG7IzC+t04T1KcCBT0mEzdeuedC9269qhhaQHu7SoAE3bIo5xWW/5UZkCtJpMiHbCpf9BXKAvLFnFaJ/S+9Ss+AUX5x8MBgOcf9BRK1zd6TzCpGxjykGt7oeBF/edFOZJ2DkZxCbeGzjQ2mByrTVBF8mQKFam+f5kXkKlMI5wrYev7BWYAKDYYJQ2UOD7afEAlfitIZe6EeUx9an73zvQ9rbjxCDoBbDpNm/ARvegRcK0hfJrzybWsCB3fPkGuJeem4ufB7c6Zh3Sq+2Wxjs+d2rfC6kz/76aJZzhRtFnWhbySualtDAOVDlf33k0j2xDQRJIvVHqWX5Xbk1lerMeV1WzDEOo1vnwftBcfVc+xRIDQCfQmNx1uN0/pkzrGafcyQ1kUb3zbzU8+lIp9uP2bMfyCibKi+2mwKBWjCHH4Hi+uCUDiki3ziRdeaFfmaq94aKa4q42NuwfCQDFVJLvafIgbAg0fleF6oE74oWucw3iGJwWlBJeP3C94yyJ/pNkp/ODbZzXztSJ6cbKmfzOHyJZyi4uGx+FThB0mLCFZwzkd+VR/uYx6riKYxDaycUqLQBVc3lGunGfK7dxLSDzAgecTp3JAg2JU4R/IjntnrixSAYsnQ/lyydwIeaBFbRTPRe3/T/HvGgQxtVEOKNLrtcufSA2vrT77hTpgOkE0dJ4b5+vW2t3HtVn0CBm
 7Vzu6dym
 roQ3DcOeFeFgJCFBH1hxjGzeLAplLlkRompdGVtHbp+gXJ94sIRMBzwytPmlwnakxiPFAw+94l8J4rJmwUmX1HUVt9D6NB9MIfgUyQzFvCqmsC6SLMaHsMqcVf+HqobF2BN9R5tdA7Yt/mVQNKwOejAhver7VrqodMRVypqxQFndnpBksK0Cc7tYbEv3MX2mIWXkz/EhHrzcbQQ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 03:44:18PM +0100, Andreas Hindborg wrote:
> This series adds a way to copy data between a `Page` and memory that is
> shared with actors outside the kernel, such as user space threads or
> hardware, without introducing a data race.
> 
> The copy is built on `SysMem` from `kernel::io`, which already accesses
> system memory with volatile or byte-wise atomic operations. The series
> first makes the requirements of `SysMem` explicit by requiring freedom
> from plain accesses for the lifetime of a view. It then adds
> `atomic_per_byte_memcpy()`, a wrapper around the kernel's `memcpy()`
> with explicit safety requirements, and routes the `SysMem` copies
> through it. Finally, it adds `Page::{read,write}_bytewise_atomic`, which
> take a `SysMem<'_, [u8]>` view of the shared buffer.

I am still completely confused by this. In what universe is your magical
atomic_per_byte_memcpy() not memcpy() ?


