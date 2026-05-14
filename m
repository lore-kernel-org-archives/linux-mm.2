Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19017CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 10:51:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83E046B0088; Thu, 14 May 2026 06:51:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815AC6B008A; Thu, 14 May 2026 06:51:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753486B008C; Thu, 14 May 2026 06:51:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 697B16B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:51:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A68E12020C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:51:39 +0000 (UTC)
X-FDA: 84765709518.18.FEADD14
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7D28740015
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:51:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eKopkAyu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778755897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X6PJe5k8v92eFwbwJ9iLW9GS9vrJrq+MMCWDZ6eWxp8=;
	b=WK6NwZPPEmx9GPyC7BF3X8beIytdryeBGHBpBIZiMDZyOFU76bNX/K90lnYlwuq1cvFZTI
	VtPB/uC9zabYBSDEsTcKipefpb7oYmh5CeAjbLIqIHd4tyhKXoe9mWxmMIhxW/5ZLGYsDM
	cfo8yATeF2SrOrQkzoKvNehHZ+Tu0Mc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778755897; a=rsa-sha256;
	cv=none;
	b=D0ySXoxgTFQIP9tWNF5h6wXbHSFOqqM9vbFj20ALQNqr0CgCYtXon0pg32OzJyPeS27Go7
	Ob2yt38iJv+u7xmHx4TtMJkX+t3ZBz58yxXjpFhqtuNeiUY372evYSTpvH5FqWQuOoy2hv
	G6O0Ns3c9iHEi6NfzxG8bU/cIZG1J6Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eKopkAyu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C520760121;
	Thu, 14 May 2026 10:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE156C2BCB3;
	Thu, 14 May 2026 10:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778755896;
	bh=t7Mf6gO0qLO9DDT9r+KMvEg2pPFc/idol/aa5LM/lbc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eKopkAyuWWp5LHI67PR6nwmxm5bsWriRheM3jLQvxjP+A0T9/X73BIBPBADsjqMil
	 bR0ityiEasLZNOKKCKiGE401b3Crs2xe1XLKy1FcJGJ0JbMo1of9ZfTrAGP9e2FrCF
	 go6/qu6k/9xkTqMSgKqTrJ5yD/KkXsrc92p/sOlx0bpbpsVbu+Fd3BN7q4eGA2U+xn
	 F/iEhcpnNg91FCW8l0oMl6vSod9VI314iaFokfHxu0dBCCHQ4+u8TFu4DpE8Wvy9kq
	 Jof9FtjrtyY9Vy4akDkxc81TMW3snlt0VQ/4z/wZm0cHGrxA99AZiF0ubuig5c09Xu
	 HbaJsHrPyTjMw==
Date: Thu, 14 May 2026 11:51:29 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Carlos Llamas <cmllamas@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rust_binder: use lock_vma_under_rcu() in shrinker
Message-ID: <agWpH43TG-E331RP@lucifer>
References: <20260507-binder-shrinker-lockvma-v1-1-76e3406bbfa6@google.com>
 <agHUZ4AKQBgMecBY@lucifer>
 <agLrItFpcWD0N0pO@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agLrItFpcWD0N0pO@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7D28740015
X-Stat-Signature: i9mxjk51jhh5iui6j1s34aizi7dmi9gm
X-Rspam-User: 
X-HE-Tag: 1778755897-535044
X-HE-Meta: U2FsdGVkX1+HrP0seVNfHBfrLKKHKLfPqRnjMAh3gyUYK5BN8Ib/sy0XglETeNwVOOuk3VNpdfgOmG0087C0sHX7KaYN6xfMTy6nWl+CRPw7BRM8nJ9MqDVkJZgnHfFwrOG1wZn48qIzMwAzJuEc6e+VqCYRnHOMikYB3DMny4aOvy0VWfUkTyn+KNIaEYS8mWOYWafqtWWOMdjgyqFfABH2YH2cAjeCMGyKFtWBMTXzi02mTPwth/EnVdkDe6VNnwzBoGZTox/X6BQhXhPuJOh2DwFDGqNOL+m+WmPMa1XTsQ3kjuRNwtWqch56jnmq30Ql5ByCFavn0OxN2C7qYZbrfyjS9fXOLskTCAw6IDCtwW4ea6dqYOM5pb9rZGK7VTe/pk/JWIbpRVthp0Ag63wdH/oyoXMjLaC1dZcl0LQNhcnOXaS/7R9fVq8u+hwI76UleCgDTTXU66LtQZo7dLC2XZvz1nqVv0ExZB159Nq1+UWZH3nN8i3Bg/BsSMFe2tiHimEba07w2QDwWrmohRzB92A3FsW10KwNgo5YsApmgb3wM46tTgqvVWGb+aH5ceT9BM5Mvmx/u7RsnB/khi/fLsGvMCiesS3Cw+ecEf0GcOCtWwwj9cbnwo+C/k8oaEIG/1DvKGvsMCowDvHbsQDpJYcVMHHYSi8ezdfnGCRPbXERNm80DGm3M1M63Z6e9fBKXr+w62kSQeTsfM52P7lWqVsFKCCa4taS7flGTuHN/Z7fRWJ+XNT97MdAimd/qsN8e6eAVNsSDHkevbzfgYzlaVsPK0eoFUBa42dxvq6fk9sdwiZVKd8tbnAPr+XOE5wvBeEnWKMgBwbiwI5PBpZFanZ6IKtK2aaI3jlZOVMzyqivdJZdezbaG/Sxuj+anEtFQv8o5FLy5pkH2ldyGiKi1DTWENiKTlFxdq1BwwXvIaPdEa5ZTXKkiRVg1tyZEhBUf1n6xsSk8JaOJpH
 FEtH5Nr/
 WY56R+X74ZspxJtEs/ETIl7q5AQy8lLGXRLdJ5hEXA37oZ3vfD53b/6VlxUTerLkl5MST2tW5x4p6UHs0JEdZuySXB/8IkqNGYH6lu5fwi+s4ukIpwreXnrzse9Cghcyb71lFbQkwI9AwKBs2ZD/CLSPKunZkykLFHKznMxkWk0o3D3LozCIRSTqxiC/xDSJlK/v2Q0+D+W18vAruedmdmfjnCXWYF0c19/59OIO7spON5Wis4qGQt4S00xlxzYq14CfrDn5GpKmJ8nJWm+69rVQFwtYgc5y2zqnRxty87qF4sEniPllDQts9+RJVLqSDJgpToxmZoVBOMWtE254XFQoP+YNiW1Ljcar2Bz9YeDb7veqPfwH08zO+rA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 08:56:02AM +0000, Alice Ryhl wrote:
> On Mon, May 11, 2026 at 02:19:42PM +0100, Lorenzo Stoakes wrote:
> > On Thu, May 07, 2026 at 11:07:47AM +0000, Alice Ryhl wrote:
> > > The shrinker callback currently uses the mmap read trylock operation to
> > > attempt to access the vma, but it's generally better to only lock the
> > > vma instead of the whole mmap when you can.
> > >
> > > When lock_vma_under_rcu() fails, there is no reason to lock the mmap
> > > lock instead because it's already a trylock operation that is allowed to
> > > fail.
> > >
> > > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> >
> > This seems similar to Dave's patch [0], not sure if it was inspired by that? :)
> >
> > [0]:https://lore.kernel.org/all/20260429181957.7511C256@davehans-spike.ostc.intel.com/
>
> I was reminded by that change, but it's been on my list since commit
> a0b9b0f1433c ("rust_binder: use lock_vma_under_rcu() in
> use_page_slow()").

Fair :)

>
> > In any case the general approach seems sane to me, as rust code I can't really
> > review it properly, but aside from the comment below (presumably that's fine) it
> > conceptually LGTM so:
> >
> > Acked-by: Lorenzo Stoakes <ljs@kernel.org>
> >
> > > ---
> > >  drivers/android/binder/page_range.rs | 24 +++++++++++-------------
> > >  1 file changed, 11 insertions(+), 13 deletions(-)
> > >
> > > diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
> > > index e54a90e62402..e82a5523804f 100644
> > > --- a/drivers/android/binder/page_range.rs
> > > +++ b/drivers/android/binder/page_range.rs
> > > @@ -705,7 +705,7 @@ fn drop(self: Pin<&mut Self>) {
> > >      let page;
> > >      let page_index;
> > >      let mm;
> > > -    let mmap_read;
> > > +    let vma_read;
> > >      let mm_mutex;
> > >      let vma_addr;
> > >      let range_ptr;
> > > @@ -728,17 +728,18 @@ fn drop(self: Pin<&mut Self>) {
> > >              None => return LRU_SKIP,
> > >          };
> > >
> > > -        mmap_read = match mm.mmap_read_trylock() {
> > > -            Some(guard) => guard,
> > > -            None => return LRU_SKIP,
> > > -        };
> > > -
> > >          // We can't lock it normally here, since we hold the lru lock.
> > >          let inner = match range.lock.try_lock() {
> > >              Some(inner) => inner,
> > >              None => return LRU_SKIP,
> > >          };
> > >
> > > +        vma_addr = inner.vma_addr;
> > > +        vma_read = match mm.lock_vma_under_rcu(vma_addr) {
> > > +            Some(guard) => guard,
> > > +            None => return LRU_SKIP,
> > > +        };
> > > +
> >
> > One question here - are we good to do this _after_ locking the 'inner' lock
> > above?
>
> Well, it's a spinlock so unless lock_vma_under_rcu() can sleep it should
> be fine. Though we also hold *another* spinlock here, so if it can
> sleep, we couldn't take it before `inner` either.

Ack thanks!

>
> Alice

