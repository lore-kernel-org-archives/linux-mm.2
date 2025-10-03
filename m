Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99618CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 17:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E75148E000F; Fri,  3 Oct 2025 13:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4CC58E0005; Fri,  3 Oct 2025 13:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8FB58E000F; Fri,  3 Oct 2025 13:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C83628E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:23:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F4F81A08BE
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:23:37 +0000 (UTC)
X-FDA: 83957474874.13.CC92AF3
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7E1DA160011
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:23:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="d rb1B84";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=rmOeIkPC;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759512215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FuGXzIJfEXuW20iMUCUhINcgf9aFGP9CBkUuEgKGGBg=;
	b=8Ob1gcQ6vgnrVvli+RDBF7u/AkrfaZ1P72N7Btlu0EMu7rurm6Wa021o+C12iWumXtnl9r
	PHTRiiDDR7BnW9092Z3SpwDkMT9V41DlphX5AnB4erfJZ+jkO3/Eeg8Cwqk487U08OJwkS
	nYDoLoxLRMUvpT0mwzDiyS50Ohn4CVM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759512215; a=rsa-sha256;
	cv=none;
	b=6XrvFty0imye4S+GUBhSroWnanMN9N44rELigWnVo3KHY3d6JM5WJY7bOQi1LYMA09JjGP
	a9S8syFKzirKxGcqWOBg4n+dNfPzWNZH5MYDlNIV3L4QyB5Qx5CIIkZB/7L3LBUZLp5rXa
	NXngYcYSZs3oAglnKFnuD8Vqc7WyU3c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="d rb1B84";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=rmOeIkPC;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id C6C24EC0286;
	Fri,  3 Oct 2025 13:23:34 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 03 Oct 2025 13:23:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1759512214; x=
	1759598614; bh=FuGXzIJfEXuW20iMUCUhINcgf9aFGP9CBkUuEgKGGBg=; b=d
	rb1B84wEgJ/h/f3Fkc8z+UyrNpwneJoReo642w9YWTnH5ZShnqua4tbeY2J+BN96
	hRrfO/p+hR1S5YIFGjPQFsLU5YsIdOMJdQbu7kV52YvPJvT8BoV6xEWVpnexEsBu
	f06/WB+RNmxpA20hmaAAby4Ei4EcdsT35sQvnqUF6TrjQ30gi9tTAvkF8nDyIZPB
	FoE6hfbMXpQLG6u4hdIMPlNQQCXqsPAjnMu80LudzmOROrjDTJVqmRS6nOXjVZOg
	AbxAKJ+Pp4+ShbjO0BJiX5fPDIlj4HYzs+MfLzty680WFx7Zh/A6cntniJ6z4lRJ
	12p/bIF82dxWWMCzNJ4FQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1759512214; x=1759598614; bh=FuGXzIJfEXuW20iMUCUhINcgf9aFGP9CBkU
	uEgKGGBg=; b=rmOeIkPCZ2UpHBhz70nD4O3jRWQQrYUEiGp34fjQG45ma0TYYIg
	vknLZPvZufYXaoCdSg34hu/2BUQk4weogtoJQt4453wAU3EMsathzVjhebpKuiJH
	xCIbkxr9ovlGjexn9EUSb5xbTx07GEUnLEfDNyyqFXy2Q+TrEuZHo6iP1PbA+3u1
	FjmLpWkJ9+uRNgS3oWEGBFGcTOk09v1I+sdwpvL/mliRVZLArga+fbeWmblvQM0X
	q6XiVApdJtPzQbv/uDR3Q9G3TMrjntJRF5x0ZMe3konsZ9s4tbpWR2e9+RnVckbO
	Xf8AOqDNH4JBl3OsXhEuRJYO+wzD/Xgs7jQ==
X-ME-Sender: <xms:lQbgaFO5oTfKB1H7hSnXsMQvWDR4MIEoM27eC6WYXlnlVD7MLROszw>
    <xme:lQbgaCDaLSE_HxVrGrIhBV9u40EoUFm1E_IJ49eEvG8zPIKqs3FxXHK8GJlYjsa4D
    wnnH6NNs7ktJ4SqsgFxw3yE2u7hjwVKn2Is8eAKwM-8YHiyg4I1ZuHQ>
X-ME-Received: <xmr:lQbgaEL72Ju8n6Ia5QnaVvJyCDnOF75WoOtBt1rQdAfpzzIfBJhX3rel6IIZ4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdekleeglecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepkedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepthhorhhvrghlughssehlihhnuhigqd
    hfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggv
    rggurdhorhhgpdhrtghpthhtohepmhgtghhrohhfsehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrgh
X-ME-Proxy: <xmx:lgbgaDNCYbi_nlSR-f9IDPZ-qAA_zw2lmtABIyImIxrakUlB42hSUQ>
    <xmx:lgbgaK6_c7feLoRzlsTdSxp80Askl1Zc0sVrxh8Tm6Hg3aZu4BXiiw>
    <xmx:lgbgaN4O0CemABEzNpBqYZu28HGAn4utq8qobv91PZgRnkH6xWHfjw>
    <xmx:lgbgaAFX2EFTeszlDm_MbIBcBVyglTXRrEvLBzDCPGyEV6sitOJ0pA>
    <xmx:lgbgaF26IB3KqqP9mKGC_Inx5g6C8FECa9823J9grS6NjDWibKabs0n9>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Oct 2025 13:23:33 -0400 (EDT)
Date: Fri, 3 Oct 2025 18:23:31 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: Optimizing small reads
Message-ID: <a3nryktlvr6raisphhw56mdkvff6zr5athu2bsyiotrtkjchf3@z6rdwygtybft>
References: <CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com>
 <flg637pjmcnxqpgmsgo5yvikwznak2rl4il2srddcui2564br5@zmpwmxibahw2>
 <CAHk-=wgy=oOSu+A3cMfVhBK66zdFsstDV3cgVO-=RF4cJ2bZ+A@mail.gmail.com>
 <CAHk-=whThZaXqDdum21SEWXjKQXmBcFN8E5zStX8W-EMEhAFdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whThZaXqDdum21SEWXjKQXmBcFN8E5zStX8W-EMEhAFdQ@mail.gmail.com>
X-Rspamd-Queue-Id: 7E1DA160011
X-Stat-Signature: mpmdj6x8dg57b8xysb4ftt3pmsf4ix16
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759512215-757596
X-HE-Meta: U2FsdGVkX1+QoFa0t7dGVf2RSi6j8RYnUuPtmFEnUm1YPsRlZWHYhxi4jldAers8KASh0/71IgchAwq5bUJR1ek7CsGOMssqEdlw7DqyER3MBLWICO9mY+u6yHVKSGVh0eOWJWyPNu9/KqZUFJZ3jZqSnCv/hqUt7sMPthUH/cV5tdgdKopncVWu3ywNfT68V1bVdGJXjf5CpalJ6cYgXHhkBt5XYXiq9KwQV/9HT14LV+lMP96FeoPVUQdD79lMMxdkZ0IoPIgclAGj15Ya4t+Pnvsl5kh9Yp+4jgfk6lxc7zItN7Kw104l3wgvQ2eqztoOdOsUhSzUji6igg9RzU1jHesY2mRZUQhS+804OtOozYU33T0+hyM8SN85inGuC701sUNN6rz0Ac4Kfs+DaWIkglHjvbOTguH/sOMSooEHtOJV/JsgveFlvJUd2H2W83E0K1L4UR3DBYUPupKCXUftZ8UsvQvfp7298WK7ihjMUiIfHTR6x8YQhcE9FKTreaa6iYEU088uRK3iG4D6JzKLmjVWBIIwYXyWsHl9FZWV3QwPN03bn/OfxmN6OMm7SmZOTJ4Ojjm0nPOieKivfmx7CsXPMQFTjqA+IGBK6nR45UXgZGsZhXUUi1lpwjfg523XE80MDnXQUSa0sQjWLcqx98x4d2YtWxPZ6zCdPKHLYhegID9iyC6dXDtJssNkj0/SJ58Oqk8NvGLMpogjZyzZKc4YeWirCtyV0yP0MGRicFGseqDByObJn5cmyXDWh8Yw7bYP7+fcsyUjj14f0OzGM7xz74YKBi9V0w3rTeF8xeqey+QTmPOr1NhDaKLh16EzxXDBwSTvWC44q1e48uYT0g6lei0x0KO9meL8vuRJ1CKx1qIUvPQnGRdarfPYuzIa3iOQ7vThxJQvvqj4/lDHhs2S2s28l2NcCz0ieWvQX1sEYa4OMpIRxHuaT5vOskpVP0jxmMinXSKVOIx
 vHxSkPjy
 AwA6YmM19d7zBffE6MkCjBiqwTi4R69O6udpLXAehuJndxSN/Q+GedQAf/EMtSHfEH27nd0yQGev82oPEasgtDM5eVT4PwTN3rxG5R08s5e350a0Jyepe6LW0Hiq5pN4Z9AJzXviPs6L3Xz3IJ0XLUhin8VLIUZQ0oGgoqXw9XXrqJj82qvyVw/dyksZv1YFnSjZPhLiUvkw6rOo86JjN59tKrKaPkDUp2hn9BTOj3YAcw4UQa6J9LAboFwjyu9wkK8SKXrmJZxMkXf5KRkkfu4AKhs7eLrR+RNoZN3ZAycYUbEBf7ZoL2EqezXer3ydk12tpc37gZIS0iWrxRufxvBBpxiQsxtcW+3cXpz2qI7MMn98ddQPRLTA9OoPlWPNLgP4SZe0Rkw9tuCOntxiysYjPE/HHRhBzqHqs/Ot6+xJsjpg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 09:40:17AM -0700, Linus Torvalds wrote:
> On Fri, 3 Oct 2025 at 09:18, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > That was one of the theories and it might be the right one. There was
> > some discussion about having a sequence number. It's a long time ago,
> > I forget.
> 
> Ok, this bothered me. So I went back.
> 
> Damn. I actually mentioned that in the original submission (well,
> actually the reply after I had booted into it [1]):
> 
>  "And even then there's the question about replacing the same folio in
>   the same spot in the xarray. I'm not convinced it is worth worrying
>   about in any reality we care about, but it's _technically_ all a bit
>   wrong"
> 
> but then I left it because I was hoping somebody else would deal with it.
> 
> And I brought up the patch again several months later, but by then I
> had obviously repressed that issue.
> 
> So yeah, I think that's it, and I even knew about it originally, but
> in my incompetence I had entirely forgotten.
> 
> And by "that's it", I obviously mean that there might be something
> else going on too.
> 
> How about a sequence number in 'struct address_space' that gets
> incremented by removing folios?
> 
> Or even in 'struct xarray': it would always be protected by xa_lock,
> so it doesn't even need any new atomicity...

We would need a new barriers to serialize the sequence number against
removing folio from the tree, but it should be okay.

One thing that gave me pause is that we free folio while xa_lock is
still held (in __folio_split()), but it should be fine as long as do not
re-allocate it back under the same lock. It is very unlikely as xa_lock
is spinlock_t and would require GFP_ATOMIC.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

