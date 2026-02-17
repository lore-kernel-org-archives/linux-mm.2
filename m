Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E37EE909C4
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 15:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57FD46B0005; Tue, 17 Feb 2026 10:52:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56B386B008A; Tue, 17 Feb 2026 10:52:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 481466B008C; Tue, 17 Feb 2026 10:52:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 341916B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:52:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1972C0A20
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:52:52 +0000 (UTC)
X-FDA: 84454391784.20.37746DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A62BE18000A
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:52:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r0VjQkx+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771343570; a=rsa-sha256;
	cv=none;
	b=3+6k3gr2/KvkYzcSg0txHUwEByAWNyYFBBsTT0o2ZSx64ZILKSOIL8InZqrMss5PR4ph04
	yxpOZtjOvjV48xvVA1r/IpUHnFFEWImiPn6c3dxmS7ZJYjuw+ZkVkNuc/OXERqCA7ql+Ca
	XVfAYVdzLBhoiuII73GLNnpjPzTkVPs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r0VjQkx+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771343570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t76YqfYRyx6GasNeY3VH5yWNqOosR3W2kuC8IfexPlg=;
	b=Qk9sahXy417iFplFFUMbq/O2ehbo2O0YJDnMZbOUHUredC0NsHomfOqyuml6unfoNARUOm
	+DUjluKCnoDCn4qzb84YBvCKes2HAzbEOt7exNHfYcKqcb8htjvlDcrpUgiU0vGv21ZEh/
	jg34ZJSwOJv3rHFSZEznMXOoO8ENwUc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AFF724419D;
	Tue, 17 Feb 2026 15:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEFDAC4AF09;
	Tue, 17 Feb 2026 15:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771343569;
	bh=iH/4jHxpjwqHTjjSxGybSY4T89B5U0JcMMqKVFpsIQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r0VjQkx+YtBh718FGVCIvmHajV3QqwqmxutrHa8URvIIJYXXzOARhBZOM5wYiMV4U
	 Se1U4Q9SAaTf1hNbeZJusReqCqtJNT8tLZIR/d12a6k5Ow6IaAK9Tx717eaZTfDNb2
	 nLcqE2qX8d7i8xHW+bg37e5BH3/RQ9fiiv3T7GGto4QGTvGyV/v4Q4X7J7IRLLgS7S
	 48uSq6rl5oi75jX2Yzj9TkUHMedwwv5HE5BNC1ZXBzj+igNeEdrxlbUMkJtmN8OBhb
	 KWdXPe7HMSgZXI8ZIPYfyhJKkaSX1fBxCF4s6cEMaK6BI7HUxeZXJSQnGffttCL7xG
	 c/dAaaW5cq0XQ==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id B30B1F40068;
	Tue, 17 Feb 2026 10:52:47 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 17 Feb 2026 10:52:47 -0500
X-ME-Sender: <xms:z46UaSa3J1PtIw2u2CAFksYpd-_Z9Nvs5vHZhZO-cOKx9pDW4AvrCg>
    <xme:z46UaZXeM336IGk1VclWOpxlfqQyi3mslj5o4OzqbMy3UmLflh70D0bN-8cmMg92d
    JDyq2MrQmlrK6nxH4V4LlTOguGglUmphH3eiaQu0usK-4MWSraieg>
X-ME-Received: <xmr:z46UaRhaYlSJU0o35n-HZ9xIiq-pV3T3oMmep3JZzje5DVC94DR4kn9i3GcvtxcGPYWYWmC810gOEFJuwnrb6dtueD5SrZum>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvddtudejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpe
    ekgffhhfeuheelhfekteeuffejveetjeefffettedtteegfefftdduteduudfgleenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnod
    hmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdelkeegjeduqddujeej
    keehheehvddqsghoqhhunheppehkvghrnhgvlhdrohhrghesfhhigihmvgdrnhgrmhgvpd
    hnsggprhgtphhtthhopeduledpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepphgv
    thgvrhiisehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepghhrvghgkhhhsehlih
    hnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprgdrhhhinhgusghorhhg
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrlhhitggvrhihhhhlsehgohhoghhlvg
    drtghomhdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtohepohhjvggurgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepsghoqhhu
    nhdrfhgvnhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtohepghgrrhihsehgrghrhihguh
    hordhnvght
X-ME-Proxy: <xmx:z46Uacn1lz5fFWzE84s4OvIHicypsayeQfHr78MXXNVb8aLLgljGmA>
    <xmx:z46UaSyatSXICv964C9m0j7jKwUAR9PxuBYt3nYUNBdAq8pbTtot3A>
    <xmx:z46Uaft-VTEsj482c8TWntCQF3MpMIWxyFc-H8CMNYeFaSnRxWFnPA>
    <xmx:z46UafvKlq8fdPv3Eu-_slZfO-M0NCbYOjA3AOaCeU3Hq0I9nCyxuQ>
    <xmx:z46UaVnjVCHLt58ViBBiImupwLKlh8d0Vw5o4BsKgZyyGhcTk1DKbd5R>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Feb 2026 10:52:47 -0500 (EST)
Date: Tue, 17 Feb 2026 07:52:46 -0800
From: Boqun Feng <boqun@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <aZSOzjdntYOB-DxZ@tardis.local>
References: <877bsgu7fb.fsf@kernel.org>
 <TZXRjQ6gkmJNdRcfDVKKEl8Zd-8b7HBCLMrrPXyXYq9HmsVE8BJS4a6FE-YxxNsOBrIQl1fiOvfS19rLkPSmiQ==@protonmail.internalid>
 <2026021313-embody-deprive-9da5@gregkh>
 <873434u3yq.fsf@kernel.org>
 <20260213142608.GV2995752@noisy.programming.kicks-ass.net>
 <2026021311-shorten-veal-532c@gregkh>
 <aY9HD7nH5A-DtgmR@tardis.local>
 <2026021326-stark-coastline-c5bc@gregkh>
 <aY9PBfx3RRV7rXZ5@tardis.local>
 <20260217091348.GT1395266@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217091348.GT1395266@noisy.programming.kicks-ass.net>
X-Stat-Signature: iqr4qb1cpw31785dthfmpfm6d5f3mrx8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A62BE18000A
X-HE-Tag: 1771343570-807462
X-HE-Meta: U2FsdGVkX18gzHX5vTTzWKgZ/sQffBO25k+uxHkFjdkFyQuAHIHAQvgcgr8FSX+44OKu+nOXM1mhOmcIu40/5+EhrGJ7HP3m9DbiQ3IhdJ7JX2ynn3ywPKPj9ZJbrwzhzaKCTMZFPLGzESf4sr2eoXp6WQDX1oBO50vd+uqGXf2JaIXt8uj2xQmgz2fBXt+3VK6CRY5Vniw2yzQvB+ffJQ3elQ8wHtKbLb8s7R3itOpESrxmt9MCvs7zV3KXkNqRtMGP0ssxQnu4+M2OHEowQ0k+f772aWuajqg2dOjH4cVSOC79wxEWQiUXo7PKsaxDRK2+Ubja+P+AItlG6LNrZ4hyhoHvppyurq1HHH8yBNzvytCe8z4qUkWa6fzsT+EOJeM4o3L+9Wg3CdO0FWObIDT0EKS3f3stsWuhOtbzGHTSU8EbKxxpifSDb6Gj0l5vB18s3CCDOUF4EVw2od3WUlOQlY4ao9bC6jFmu+TTTNO/AvQhhzESV3tYyCik+x71W3cuHBEsouB/z/Etz0aI+UlmQiK4Bcz22xVJLCdw40isd+v7T2oLhZmWBYseZxDCd6GeruEjNBCngoe038GW+AAdqemotVT5BytV11S+9O3a0/jQOyqyxqM4RyBNmxso114Qc+6lUCuYCjxyHyH+SnPxU88M8ufmpOCZxHFvkHl+mfWyMqKwTbPttYM3OKfsyyEEixWLWEUi3U9TNE372MqNpO5triu87Nt4U6+PIgKalTI7N2ZvzKU8cSPn+udicPCO+ikyzlpl3597YzhJ8brh6YfEkc/gVogRAX7OxDpvGwo20sgN+mtEl/Taudqjmq6og3lzKRZyNMY82S1UAW289G9NH6kJF5YfG4A0JRJld9sg4IeC4OsLHpJwKL6LKJ/qMPyppbPjCpnILSmjbjBARcjhN4n5wsqXU8QW+bWTx4HfL8mF0Lfua1o1SXVFiDVWb0x2Sd613hoaNev
 lVX+GeUe
 RckJRxvPWmZA6dHvE8btvDygYiQSyxcPy6Cc/nzryYOrpvDnYUginDcgFs6hb6ZO2u3bvXq1aNC4bN5ybdhAum1F9sjPkQsBeZnO9EkZRF8Q7kBc1cp1ow/FL7O1pV1TxbL+KOgaZd/RByLx97/+HwKuKoJBF6HgCMXU6/+HpXVAd9zUUqnHDab6gcNusvmFTRjkMRuWnWpYOBMgnCxFjauzcbT8suJhvCUCa74l/9ewC5d2QmTxHgHJQq7zHHu0oSfsP5hCifhiq4sP0BTNwwjXD61M3wgStz63x7Qk7UF4jISCusxlVYv2g0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 10:13:48AM +0100, Peter Zijlstra wrote:
> On Fri, Feb 13, 2026 at 08:19:17AM -0800, Boqun Feng wrote:
> > Well, in standard C, technically memcpy() has the same problem as Rust's
> > `core::ptr::copy()` and `core::ptr::copy_nonoverlapping()`, i.e. they
> > are vulnerable to data races. Our in-kernel memcpy() on the other hand
> > doesn't have this problem. Why? Because it's volatile byte-wise atomic
> > per the implementation.
> 
> Look at arch/x86/lib/memcpy_64.S, plenty of movq variants there. Not
> byte-wise. Also, not a single atomic operation in sight.
> 

Sigh, byte-wise means you at least need to byte-wise atomic, if movq is
atomic at 32bit or 64 bit level in x86, then it's fine implementation
for byte wise. Or you are saying on x86 it can tear at byte level?

Regards,
Boqun

