Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD777C98325
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 16:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70A076B0088; Fri, 25 Sep 2026 12:09:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B9F16B008A; Fri, 25 Sep 2026 12:09:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A91B6B008C; Fri, 25 Sep 2026 12:09:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39EDA6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:09:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3AEC806A4
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:09:01 +0000 (UTC)
X-FDA: 85252768482.02.FD844BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1E6454000E
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:08:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ISzJNNrG;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790352540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uw7ew/unsfmuFvfxhLGpSSnLbVpiYISyYVscoi/C9zk=;
	b=uJtS4YFySBOchP976Fx/MMLYCUL4iboff8uq9Gv31fhXWq9X5WcXlo1kvoVl9L59qcZAmT
	MbBl9X7PmaLs5ac35NCZSXE3PL0mVMG21lmSU/c3Ww6Bit+Qh0U7fwUEjZa/n4Mfj2BGUR
	XjPJIk2sg+fVU8+3nWbrCl+aIa0inw0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ISzJNNrG;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790352540;
	b=yPTiG7nNL1QFXek4/FFTGpj8eSWjdceYUQOEwIadv907p+ZqNhhRTjpe0aXKzAx88A4Exd
	t1NCM6PoNVk2IzLWGCuSdMwNR6WLtfoQMWHVaxt3C7kPJqAKsD922LwkxtyGq+ZO9H+js1
	6tCYbP7NZuw0s9NrVUD6tg9k/fi87d0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FA2140BEE;
	Fri, 25 Sep 2026 16:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C294F1F000FF;
	Fri, 25 Sep 2026 16:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790352539;
	bh=Uw7ew/unsfmuFvfxhLGpSSnLbVpiYISyYVscoi/C9zk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ISzJNNrG9u/Oi9GkSszbO9GvibpC8eoQNutMO/baMlmDT46c2dXeOkhbaiJR6f7Zk
	 M8zTgQ0038lnRwgZGCcFvBjhDsQN6C8R602rKVOemSQyyJ2Azj/es6ijJnsxJcZ/C3
	 cFt7okZuzLjYoTTgFS7E/MzfC5DasjgeKlEUGMPwUJaW99oMwaAv0k30WasKVZGtXl
	 /Dkbp3RvHOVUX465LOcRJuXsEC07z9rUJDDe9FqdKEAb67EVHa+cZ8ajgWilDpTCPU
	 wFtDRY4Gsug20MbmmRFKO7KEc7cFCHQgENqRWvVWHp77FYJMAdnbvwoTzL4edkB4H1
	 qs+1lI4Dei+gw==
Date: Fri, 25 Sep 2026 17:08:54 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Pan Deng <pan.deng@intel.com>, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Tianyou Li <tianyou.li@intel.com>, 
	Wangyang Guo <wangyang.guo@intel.com>, Zhiguo Zhou <zhiguo.zhou@intel.com>, 
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] mm/vma: avoid redundant file rmap tree re-insert on
 new_below=0 split
Message-ID: <arab1d8-4b3SzoI6@gremlin>
References: <20260924054301.2330822-1-pan.deng@intel.com>
 <araI4WsI0XMXOR10@gremlin>
 <araVBBBVY-jafePL@pedro-suse.tail5790ac.ts.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <araVBBBVY-jafePL@pedro-suse.tail5790ac.ts.net>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1E6454000E
X-Stat-Signature: br7f9awkdgkrcxx1uc94skpshcbsyfkf
X-Rspam-User: 
X-HE-Tag: 1790352539-729293
X-HE-Meta: U2FsdGVkX1/XTGlfjbwHm1NnamK8mdFfuZNZ8KUS8KWsusIGXEwOdmyfy2K8fWFXBdpIAF2IUL1vVZ65lDcoDPL0/AgI9Zzi5J3srRjy5Cn8sXiRtffzH9MccEZj2T+/G6SIK4HMGan+6fsOQRwoKuhaAHiNG6KsJTLJuOG/tkJ9HA7ULQH5SNqequI3dwWJaBms/qgqal/XkECwKe3yQ7YFEzEhZasHf2IfTFvxnFXPYgTwF+1AdSnRIFwMV4qlyZJ3OQ8Tl+ny63Vd57Kj6z09pkcPR500MnkN+4FvJp0yGzVOqeggUdJ8okICVPuwrs7rP0m6HlK5tBS726Zt/jLzOZP7keflZMA+GuGyodCF2o9iZSo4ZZVldj3aicvhB0op4E3nRefj92JJhGFKE/oQTz5IGRR8wGEG6NDUXsLPonhOKSncGg6AxfHXhzyv9hBcFXf3Z9nFokhpdAdLLoXkoFqC6IUsz+wZUGwxAeDwj0nFPEMVB3u2A6CEROCfuE3wiAsdev5s87u2SEHUZKp/wY4dMwqm54GpdxtWG1cQjZpAVZz+I7VpjwAhN5No5DFOz6FznKGJ5Y6WiwAY8TQuf0HUhk9JH9f9cxoM1++8hVfIUICCs3OEeIInDPdACMpfl3FmRAi91Jf/bsdIHFchKa3kXr+fhu5ZlUrTej6z+lJgNN5S1CytIsJuXY/OyTy3SewoYRdUdWPuvw3h84OnCgdrmYoKUYHSLH8onIMRC3tcsAGqgl+qg+/2OQIzeWov/AOp8iK0F6Xv7Hp/T/neDR9px1kPJeEd/Z+qlQEP9nrfGwOV3U5n+skoxS8ebM1cqrOgy4/xgH/f1kMTVlctqO16684anrwVVcptWwYPXgf6WN22ZUbTY49n+7zoDYqAixov9mj+PosM1q331oAo/r6x2tPAFOuJrboKjcHmEaSp18w7vV4UCzdpfaU99qt8m+ZyJTU2oI/I6l5
 L/uikVuv
 gYpwXOcmjRW1FdtAJF1DbwQqpWptSN9xeryxU0Zb1ISLXpXwCTnDpBAV5xMbKQaxCJTed+4eWQOENrlM8zw4RSUihMHOXAPQ38rXTPQkNiGAj/oAcCU5IJFrYj7JvmkCC3h262IT3riNGawHoF0zw4BXjfeFpGQUm+bc2Q8fLDlQDp6vp71HpKrzBwxn3QHG4udMWOr9OcDT6q/PCGJyNW6HfUHbBPi+WqVYrhbAuUf1MltprIO5621KERGAKt00Z6yZgint/a8Y7zK8ThJBACk+Q0Ku+fG/jm/jVXlssTmVDfDN1UyALGes0lXHJKCobX6Tv+u+Xe1YkdAfvwnsb97venrxT/28nXHKIjso2OSgNpk8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 04:43:37PM +0100, Pedro Falcato wrote:
> On Fri, Sep 25, 2026 at 04:27:44PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > This change skips the re-insert for that case.  vma_prepare() no longer
> > > removes vp->vma from the tree; instead vma_complete() detects that case and
> > > only recomputes shared.rb_subtree_last up the ancestor chain.  Everything
> > > else keeps the remove + re-insert path.
> >
> > This could really do with a diagram and a simple explanation.
> >
> > In general you should rewrite the entire commit message yourself and not
> > use the LLM output at all.
>
> +1 on this. Even with the Assisted-by, this needs to be understandable by
> hoomans.

Yes.

> > >
> > > Measured on v7.3-rc4, on a 2-socket 192C/384T system running UnixBench
> > > execl (384 concurrent execve of the same binary), dropping the redundant
> > > remove + re-insert yields ~14% higher throughput by shortening the
> > > i_mmap_rwsem write-side critical section during the file VMA splits that
> > > execve performs on the shared libraries.
>
> For what it's worth, I'm vaguely accepting of a similar change, but this needs
> to be _really_ well commented out, and ideally in file rmap code, _not_
> spaghetti'd in VMAs. The interval tree is complicated and some bits are not
> very intuitive. This needs to be robust. Not LLM'd into existence.
>
> This also reminds me that I should reboot the sharded file rmap effort...

Indeed, which is why I'm treating this as a report rather than a patch.

A member of the core team can do the actual work.

>
> >
> > This is really unconvincing I'm sorry. Real numbers please with statistical
> > evidence to back them.
> >
> > Additionally I notice you have not made one comment referring to locking
> > anywhere.
> >
> > This part of the kernel has VERY subtle and sensitive locking
> > requirements. I am not convinced you understand this, either.
> >
> > >
> > > Signed-off-by: Pan Deng <pan.deng@intel.com>
> >
> > This patch feels like a hack. You are creating a whole new set of very
> > fragile assumptions that have to be maintained throughout.
> >
> > Again as above, a member of the core team should take this over.
> >
> > > Reviewed-by: Tianyou Li <tianyou.li@intel.com>
> > > Reviewed-by: Wangyang Guo <wangyang.guo@intel.com>
> > > Reviewed-by: Zhiguo Zhou <zhiguo.zhou@intel.com>
> > > Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> >
> > Please don't do this.
> >
> > Upstream is not interested in private reviews. Review tags upstream are
> > based on review done in _public_.
>
> Yeah, this too. It's just noise.

Yes!

>
> --
> Pedro

--
Cheers, Lorenzo

