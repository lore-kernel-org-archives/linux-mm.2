Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42D75E9A037
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 18:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66A546B0088; Tue, 17 Feb 2026 13:47:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642256B0089; Tue, 17 Feb 2026 13:47:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54E216B008A; Tue, 17 Feb 2026 13:47:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 423046B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:47:28 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B01A1A02CF
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:47:28 +0000 (UTC)
X-FDA: 84454831776.23.4C9A816
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3B4EBA0009
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:47:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EBwuAYlG;
	spf=pass (imf15.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771354046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ks8xvCaMS9D5B+ep6iFO4BkEe09TrAAPVRyNreSXICQ=;
	b=tGtjDvtdKGyh5MJC5iu/+bX3vCnZgztnIO20H2sUcHyC5J4OSWc48NU+jPOnkU1A7zwwJV
	5q/CUWBCdot4rO7N69j0YTE1qqnT3cGaRYl40b+0cBjHOMZr2rKFr2IuinyOTZTrJqtzMe
	u9V9PJFa9OGEntGr9TM/AXQlpdYnja4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771354046; a=rsa-sha256;
	cv=none;
	b=d8pFST4GExmOsZ1gvLxeRFNIRoKIay6tJrFTZJqLUJYRrO7u/Ct9Oz+7NTaAFQTX4BdZPK
	huNuhgnvTryK4i9G8PH+vHGtwzzKKvbLc8Hb2lNOd6g4MiDa5V7F0OBo0JoXC7rBHB5f0S
	GtDtVZ8/a62wMN6JiUWnHBrfX2vorMA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EBwuAYlG;
	spf=pass (imf15.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7865460053;
	Tue, 17 Feb 2026 18:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76187C19421;
	Tue, 17 Feb 2026 18:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771354045;
	bh=WcoLwLQKYqFYG7eyApsHhIbnKT4ueo5I7JT+p13FMtk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EBwuAYlGgaGgsXA8Kkz5XVMh4SNzoiNDdwIkW52Vg/PRJdbFPFMFfmn1C4HjoFTcI
	 uq+zMXMh964YKFyzEnmCSDZHUxdCFNey8lZJdk2KtsmyRGJc3p1jL7bfjBQoAmkxEU
	 uHsaxdpaVO4HaQHzDRJEg4hEFajrJa9VP5YhEeh1Yia6NFA7qrD8oqflt3tiYtztTT
	 Rqr2SCWSnLCSDag3MEey3M9t3kgrzom/7n2ut1oyFTxU99mRFn00sTnBFmwnxpYClO
	 JoxvIiBTV4ektIPPLuqxKluU2SARTkZEN9wWXXsNpGDHfa+J1zej9s8CQt+abyhGlh
	 gwo2IfH5H78cw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 923A6F40068;
	Tue, 17 Feb 2026 13:47:23 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 17 Feb 2026 13:47:23 -0500
X-ME-Sender: <xms:u7eUaVNW-zWqtufYm9_LbeoOK1VromChNjDcUBAW8I3bwd2B1IFtsg>
    <xme:u7eUaT4SW6NZX3j99UYQhc2NJ8x9cjq5B9nZcQ7jped--K8bAF-ZWDj9QF_ljy1LE
    F02a2U1m2cQhbtxB1bWTRHR2BbcB_qc8Fkhr0xikbMbqIxmLj1s6g>
X-ME-Received: <xmr:u7eUaaYUNLhd_WjDsNX8xyhwt42FWb5fIi_JEUGCCUNXCZf677UwHqLKue_CV7kBE-N982Zc06tQOfwjvoPxroZ9IgRiUzHv>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvddthedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpe
    ekgffhhfeuheelhfekteeuffejveetjeefffettedtteegfefftdduteduudfgleenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnod
    hmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdelkeegjeduqddujeej
    keehheehvddqsghoqhhunheppehkvghrnhgvlhdrohhrghesfhhigihmvgdrnhgrmhgvpd
    hnsggprhgtphhtthhopedukedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprgdr
    hhhinhgusghorhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehpvghtvghriiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopegrlhhitggvrhihhhhlsehgohhoghhl
    vgdrtghomhdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvg
    drtghomhdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhm
    pdhrtghpthhtohepohhjvggurgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepsghoqh
    hunhdrfhgvnhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtohepghgrrhihsehgrghrhihg
    uhhordhnvghtpdhrtghpthhtohepsghjohhrnhefpghghhesphhrohhtohhnmhgrihhlrd
    gtohhm
X-ME-Proxy: <xmx:u7eUaYHHZ1hdyNaGFbqped33ByQXLYmhXkkV4XV9IxW_2HeQnsq39w>
    <xmx:u7eUabmKGbemH6hcxaxU0gmEln0S9et69XEBG6TX5TM9k7O2E6L-HQ>
    <xmx:u7eUaXniNtY1V4eWfiyACqYVVr6e-FtqrzgNJck-k5hMYQr0w1hX0Q>
    <xmx:u7eUaQVDAoWoL3673wK80s4XD7vMixwUO4-ekyOUtuRgTqAfLOIY0Q>
    <xmx:u7eUaV-e4ypgAY3Xrj2taoTe95VfGFSpAKHW3Klica3fTMlrlxht7Va9>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Feb 2026 13:47:23 -0500 (EST)
Date: Tue, 17 Feb 2026 10:47:21 -0800
From: Boqun Feng <boqun@kernel.org>
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
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
Message-ID: <aZS3ubEjQo8cycdu@tardis.local>
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
 <20260213112837.GT2995752@noisy.programming.kicks-ass.net>
 <aY9UedlaCmagVmzh@tardis.local>
 <87tsvjsppz.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tsvjsppz.fsf@kernel.org>
X-Rspamd-Queue-Id: 3B4EBA0009
X-Stat-Signature: 4jizde5f57cq1cwunc7hxhjunt7jrbm5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771354046-210853
X-HE-Meta: U2FsdGVkX1+hFqJ9UrvCy0TyeuvCPofQWakOdEIC0Qn2FnlRo6HZmtAKA2cOm0iWYTO6qQANPr261eLoZ4J7DYE0RElI57d+aRyzfJRjm19Ouia2WyxdnrMD3jxyJptTP9/iYbGaiPpnAHPAz+Lsjpe2mD6uT9Yoxxw8fy825MDUUCdkKyXOhKMGLMHl+uprVPMHalOXK+cDQocLc6Ua47bqCUzt3dy0X/tJXznqLjJUHfy2m4zsGoseSYxBRsg+J2wRPYQPpV2LgKumF8qLrJGksrHGTkUmopzZrtiVkTuMzK2Ui8fGVDl0WSmrT/3xrmZ9v4/ML5f9zWh/6tmzueociARUtHUfq4MOJuY+btUvVG0uEHa93oI8Gm5UzPMxiB4OLZp5nmiGqVl9Z291ZBG0ymQQFnZs1VNiBnywCydXQUkQKODgyvNBF4aznXkd0qbibX3diG57nVfiaKXaUryEYjFHbxi0RDSd1I0XY4vbBCYVOcyrLq56d+T7p44fNtyEgFRJLXVPk3BE/3QF7NdH9e1ls+c4epure5/lkuq/uTxV9l5W1V/njlak28p0n8F5o7z+lPw1C8P5mMaPafujgCsauC03wlNIoB36F2Ujk1m7iAe/x6m+y5CB0pb5jzX22DwgsUmGAi4epWfGMT53GVC/BHKDr9R/qkRmSbWErNB5tVk/AApaFp+BKnb2twQU+qqoJ2E6QlWWEnAytkYCBQcNegQUWL8OaH05/SDx8rPYVGESVxy2kgKbPUf/c/ErPD0nD6Q1AeE9QD2mGodKtCdAUEsTSZ3ZfoOXeX15HwP2G+S5upVU6gKQ+2rOcUUR5LWKyvEn13MWmk5BtDz2BJNbSmF4m97sAEf9usaOqv1XrmzM9KJdcA8Fbdr3UC13yjNyw0+rd+8S2+aTzDdpcOQwHUnMDtGFnCqeRm5CVhMsXWEC+6gh2x0P2YzDN90BGMd7DjmzaPWv4d5
 fQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 14, 2026 at 09:18:16AM +0100, Andreas Hindborg wrote:
> Boqun Feng <boqun@kernel.org> writes:
> 
> > On Fri, Feb 13, 2026 at 12:28:37PM +0100, Peter Zijlstra wrote:
> >> On Fri, Feb 13, 2026 at 07:42:53AM +0100, Andreas Hindborg wrote:
> >> > When copying data from buffers that are mapped to user space, it is
> >> > impossible to guarantee absence of concurrent memory operations on those
> >> > buffers. Copying data to/from `Page` from/to these buffers would be
> >> > undefined behavior if no special considerations are made.
> >> > 
> >> > Add methods on `Page` to read and write the contents using byte-wise atomic
> >> > operations.
> >> > 
> >> > Also improve clarity by specifying additional requirements on
> >> > `read_raw`/`write_raw` methods regarding concurrent operations on involved
> >> > buffers.
> >> 
> >> 
> >> > +    /// - Callers must ensure that this call does not race with a write to the source page that
> >> > +    ///   overlaps with this read.
> >> 
> >> Yeah, but per the bit above, its user mapped, you *CANNOT* ensure this.
> >> 
> >
> > First, this safety requirement is actually incorrect, because of the
> > user mapped case you mentioned. I believe Andreas put it to prevent
> > others from racing with memcpy(), e.g.
> 
> Since context is a bit washed out here, let's make sure we are talking
> about `Page::read_bytewise_atomic``.
> 
> There are two buffers in play. `src`, which is provided by the `self:
> &Page` and `dst: *mut u8`, which is passed as a function parameter.
> 
> The requirement for `src` is:
> 
>     Callers must ensure that this call does not race with a write to the **source page** that
>     overlaps with this read.
> 
> This requirement is different than the requirement on `dst`. I do not
> want to enforce that all memory operations on `src` be atomic, simply
> that they are synchronized. This is a weaker requirement than the
> requirement on `dst`. As we hold a shared reference to `self` and there
> is no internal synchronization, I think this is the correct requirement.
> 
> For `dst` we have:
> 
>     For the duration of the call, other accesses to the area described by `dst` and `len`,
>     must not cause data races (defined by [`LKMM`]) against atomic operations executed by this
>     function. Note that if all other accesses are atomic, then this safety requirement is
>     trivially fulfilled.
> 
> Which is also requiring no races, but is specifically mentioning atomic
> operations, which I did not want on `src`.
> 
> With this in mind, do you still think they are redundant?
> 

I see, I've overlooked and I was confused and I guess Peter was too. The
`dst` could be a user mapped page, but the `src` cannot be. I.e. it's
function that copying a public `dst` to a private `src`, of course you
can request no concurrent access to the private `src`. So his objection
is invalid.

It's not redundant, but probably we can make it more clear. Maybe we
start by saying:

/// Notice this function is guaranteed to performs an atomic byte-wise
/// memory write to the `dst` side but it may only perform a normal
/// memory read from the [`Page`] `self`.

Then

/// # Safety
///
/// Callers must ensure that:
/// 
/// - `dst` ..
/// - For ..
/// - No concurrent write to the source page `self` that overlaps with
///   the read.

or anything else that could care out the difference between `src` and
`dst`.

Regards,
Boqun

> 
> Best regards,
> Andreas Hindborg
> 
> 

