Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2A43C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29A386B0099; Mon,  3 Aug 2026 08:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225CB6B009B; Mon,  3 Aug 2026 08:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 163B66B009D; Mon,  3 Aug 2026 08:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E1EA86B0099
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:49:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C9B6AC06D9
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:34:20 +0000 (UTC)
X-FDA: 85059749880.30.A6FB4F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4852D40010
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:34:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=laxXRj3+;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785756859;
	b=Mh19QZxIZ/J8E6Bsxbk/4OQWmQWxcpUpgNZsB2kdMiHRT0qXv+WJArCmvMMJpzQvK8R5o3
	9U/PJ18j3wRxBvSFql+6BGMhbLTogsR8Cwl/RNdfYPwZQoPATPM12iFWakqVytY7ZxyOYE
	4ROzE8Arhlm2wTbtn3Ikfc1kkv77AJg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=laxXRj3+;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785756859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0kHUmLMeRZVJZjueskv9sjmPlPCMx3RZ4Rj1jejfviM=;
	b=e9cYD/0zst5FljISVsLz/WYDLs7kX+KbwMgDDsrMFViwcsuhkHiVEGxvu87DHCWkGkP2dN
	Noq6hjU22jkvQITl/Uf3eZEqj6b4BrVcFZfsPDdJVCdAuSD1FWu3EMkmN9EpeVuem3ZncU
	fDZpXJKYvJFUJgPAoJx5vAUICm33XV0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8F3960A78;
	Mon,  3 Aug 2026 11:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8171F000E9;
	Mon,  3 Aug 2026 11:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785756858;
	bh=0kHUmLMeRZVJZjueskv9sjmPlPCMx3RZ4Rj1jejfviM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=laxXRj3+r8yZ9K+RSpG6vi6zKPDvYe3GBYTALOFtRWTH76t/I70VijHNz5j7r1YnN
	 K42uEbRi7TYxjqJpNq+sI8ickY/webiCvSvJ4kA92iCsWF1MF+nH2sJgSjPaxlVNaA
	 nkFiYLwbaCdJmmm2ra700kIvVrWHk+HsMAQen60pOIryMAaBgjOWl0fkQzZzefnGmL
	 tywpJe+9RccEmg8ZJLN9bo//HnItnHLK/3+HLNxSC1noJ3RzfapmRypwjRqBQrWqLP
	 78wZoIX9HcVY45Kr80Wpuk4lxUiGHBOySzTDyOnpoRxcpSJjtjHfNbCTMLSf98w+Up
	 pqe/HkGpyJsTw==
Date: Mon, 3 Aug 2026 12:33:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, 
	dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, david@redhat.com, willy@infradead.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/5] binder: Make shrinker rely solely on per-VMA lock
Message-ID: <anB8kGIczeuqRA_P@lucifer>
References: <20260802215459.2769283-1-surenb@google.com>
 <20260802215459.2769283-3-surenb@google.com>
 <anBj40CVAhcGMnQ4@google.com>
 <anByayBh6Ed2bXox@lucifer>
 <anB3XVHI2nVgz_T8@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anB3XVHI2nVgz_T8@lucifer>
X-Stat-Signature: gz4a6fj6z594rchr3dthjw566mtyhkow
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4852D40010
X-Rspam-User: 
X-HE-Tag: 1785756859-378877
X-HE-Meta: U2FsdGVkX189HjpMcXJjFlzb1E6VugRJIIX2vDeCN7FBSOGWUv2qum60WqMNCFYDxlGlO7OKwuRJYJY05gRIVC0IqrSNPh8BSQStLFHGi0idtXDHUlYGA4sxOh5IiGOUWUnCVVY3TddbcLZQ5EXe5nOFlZXjReLXlLqPeMLqiUoYEpkl9meRNNNbc6g25riIcc+YG4Fc7e/aKpPA8Nphia9EzyTpwCgvb7DnJ9unPQ4xwlaupZgsDOjYG6rtGFIMb712ov3m1wglPi4Dq7whx+7wGwORFM8+4IFmlwtBau9yJgo9zRigfdoweQKLbChE8ycTvDqGPNSEc6A82PIeMkmMKJu42emomub7i5h36xtM1qjXy8ZOE47YoHWI3PzSaRV/TppthtUE6smTItOlzy4VPZgIGksHS3vq/mvox8h006Vka6BK5rDszilul4CBYpeD3QjTCLW8bZLVwOrfKsCvSuAXmHSPsCVUdPvUJrYdMWPMqHt2hlcXlZ1n8zQlMcm8TQ73U8svujbHUNfxbJtxO+5vEhucCbcuw4xr/cxO/MVKJjjOe3JiDmxLqI2d07U5GHmVN5jJ9d/WeZZOKP6FMSr22TCzo47P5R9MLWgGqvmcoaUQTwFqnhr9DYAvW3/yuMEOk4Zt1WrfI4BlJVtblVC7mMFkgXKChpIK2eWMaJl8Ub9z77LLQcmaK5Ro1lTkCveXrxgMTZ9CI7oBuwjKW1szA6+52UaJojpNUMx9nXgHlgWey0yZFm1eUUIZ0NejwsvNl+Jz2F+giq/H1YZod2HFslZKhTar4u3i1BxwKdfxHZM90N71Dpr7FjgUKonVlJASIOkseW0OpNN2MCRk/EkPC01KysykoHbG5GM1GBBTNnSCVafe8iDFLtHPENu3/REIEd5QM2/fGlR1YLCEpmP90FPQ32BP9b1PHauHtmDx/upLFJPcyAYScLK2lxqjuhE/3FtLT23RQBa
 ZVMaIrrY
 ya9txYqtN87znHWQRdrggthnYPKT1tfrKlNrnacI904i57kbE3bvD9zfFIWM8I+sSTlXNRCctazgmmSjT0unu1uo3yTejBh6ihDY4XjHgkIL37Nyi5iYPYnMLdoAsCDnXwlI3qPzyPDPFvn5ghoBk7pZPGmP+ItP+ipRqbz2WxPg+Rbu7KPjpbtOCFauDKnd4FkC7eeCTeO7WaeGj/A0LvHbbBnMliTM9IvE/7OF3q89YmZ7C5qX7c4N9hug58QIB9JUQu3VY408/+YGlGU/ScLz1meBeGnKudHN5S+TGNlvqm8QOeFFAViShJN9akwy3theNE9sxGfCdQ/DThVAZWX2m/zMj2XAXaiwysfXpvDtJTzrtFnWd/j39WA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 12:11:42PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 03, 2026 at 11:50:41AM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Aug 03, 2026 at 09:48:19AM +0000, Alice Ryhl wrote:
> > > On Sun, Aug 02, 2026 at 02:54:56PM -0700, Suren Baghdasaryan wrote:
> > > > From: Dave Hansen <dave.hansen@linux.intel.com>
> > > >
> > > > tl;dr: lock_vma_under_rcu() is already a trylock. No need to do both
> > > > it and mmap_read_trylock().
> > > >
> > > > Long Version:
> > > >
> > > > == Background ==
> > > >
> > > > Historically, binder used an mmap_read_trylock() in its shrinker code.
> > > > This ensures that reclaim is not blocked on an mmap_lock. Commit
> > > > 95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
> > > > support for the per-VMA lock, but left mmap_read_trylock() as a
> > > > fallback.
> > > >
> > > > This was presumably because the per-VMA locking can fail for several
> > > > reasons and most (all?) lock_vma_under_rcu() callers have a fallback
> > > > to mmap_read_trylock().
> > > >
> > > > == Problem ==
> > > >
> > > > The fallback is not worth the complexity here. lock_vma_under_rcu() is
> > > > essentially already a non-blocking trylock. The main reason it fails
> > > > is also the reason mmap_read_trylock() fails: something is holding
> > > > mmap_write_lock().
> > > >
> > > > The only remedy for a collision with mmap_write_lock() is to wait,
> > > > which this code can not do. So the "fallback" after
> > > > lock_vma_under_rcu() failure is not really a fallback: it is really
> > > > likely to just be retrying in vain. That retry in an of itself isn't
> > > > horrible. But it adds complexity.
> > > >
> > > > == Solution ==
> > > >
> > > > Now that per-VMA locks are universally available, lock_vma_under_rcu()
> > > > will not persistently fail. Rely on it alone and simplify the code.
> > > >
> > > > Full disclosure: I originally tried to do this with
> > > > lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
> > > > trylock semantics. Claude caught this in a review and suggested the
> > > > approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
> > > > I guess.
> > > >
> > > > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > >
> > > Reviewed-by: Alice Ryhl <aliceryhl@google.com>
> >
> > Is there anything on the rust side that needs to be changed also?
>
> Ah ok addressed in 4/5, disregard :)

OK disregard the disregard :)) that addresses something different. So question
remains :P

--
Cheers, Lorenzo

