Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79E8BCD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3CEC6B0005; Fri, 15 May 2026 08:28:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EDFF6B0088; Fri, 15 May 2026 08:28:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 903636B008A; Fri, 15 May 2026 08:28:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7FB7A6B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:28:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2BCBD1C0570
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:28:36 +0000 (UTC)
X-FDA: 84769582632.15.ADB0520
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7E42540007
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:28:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IXQUuydG;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778848114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGRHSKhxWzW+kJ7f/yKFd87uaOMPdOzFJP6T9q/B5JY=;
	b=b9PqyALtGAs2JbaEyFccRqBOba9yoWtV2IU4X+3AQ73xCHYRq4w56YrVzhkldoio7IHD0O
	hHzAD2yNRprZBridoeUU88PLztJTxAlxcMRax9j43wyScmPhtMajBHAtTahOs41OEF5uqS
	bRNMCf+/cbhDauWcczLif544hXUUBJs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IXQUuydG;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778848114; a=rsa-sha256;
	cv=none;
	b=1njCJ54SHJiwEhho3TL+OGLvs/zjoKE3A8kosHWhUQ/hBOAWi7zthkb4Ls9xHYMIlVdIjM
	5mDOhSS2+754mZ87ip4K542xZ+OPDCsU1iFWs+jcc3u/dZYJd5FdVKG1bNz24KkR0q60sM
	XFOUNl53Q6gO2Z8tB59kspAzFOVPG3s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C9E443FBE;
	Fri, 15 May 2026 12:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77805C2BCB0;
	Fri, 15 May 2026 12:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778848113;
	bh=Mjdo9a6AaQT7Z/mPNzEEoDf1qpwjrEf9KTXGEdd3EG0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IXQUuydGwkyU+ZDAKyAQMuwioO3FnEQEqD748my00KnFyvMMfb58eSb7NvcRBCl+d
	 lXgNeFRzwCaGI39BAZPK7relfEu7Q2nkpF5HrLsPW/zCi2P9ODKx290mlfnXysboyZ
	 E6xBT5cal2ABc8/KvWn84+FV+NiX1Qu7+8Wte04WTaPwtNA50pHoFbCVvYGizPjQ2N
	 CK4gpmG50XcbfbVnSy3jay79U/1MNDEX2H/7Lw2HOe/0vkU5+yt4c/8azLwdJeVYHD
	 dskk7uzzzIW37B1KtnbbG0jResIq11nDHhF4kU0tJunpYJL9M2Qem/miTkysilHDYM
	 h7KBtiesdPOdw==
Date: Fri, 15 May 2026 13:28:28 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: xu.xin16@zte.com.cn
Cc: david@kernel.org, akpm@linux-foundation.org, hughd@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, michel@lespinasse.org
Subject: Re: [PATCH v4 4/5] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
Message-ID: <agcL72kTdIc__PGD@lucifer>
References: <20260515151344118ESEm1fT7x-Gd6kodR8VVq@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515151344118ESEm1fT7x-Gd6kodR8VVq@zte.com.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7E42540007
X-Stat-Signature: bmuhenkuynjta3qc95nxo1a78rc9pu1b
X-HE-Tag: 1778848114-814563
X-HE-Meta: U2FsdGVkX1+tOLZqBZQYkTAARozMXaBHYKWHdOsFRQQAyCiM179mQrdlpXIJgkj7hp4u+sQNy+pMMJBMoGmvto3jJQrGrgJ4gRfV1XzIbSZIxwU1q0H+qrO9ukh5bHPHwlDVc68tEbVNWZwbMwmAK6lWaIVEIY+X11zGo9inMeGq639P9AqgxuDY65KK/KMFvs+za9YH1xmI37o44YQa4ygLiF8gg0mVDM+qHGlSdMCgixDXQPim/wJJxqKMTw0IHb7vW4XzDgaWcy0Hj4whS3zaN7CS5DSTDFt8UhtWGeUjCBxZ5xwFAsZHfJwcNNmrVLYc+puM2fj84uX+/hd8e6hzrDZy6RoTvxHhFSGl5wyXfd4uwfhDiSM5lCwvZRnzdtP21gilruX4y/ll2go02g4CeLd+7fyleq6mlXE1f4Ktju30V8kYtPH4YgQTKu1Z9K6qioP5jgalXyNUatoF4rpsKBklxCeMI6OuEsVE+bTMOxtLqv/Xu1eujwWmZ9AJ2sZiczuvg/t7BkOT9vuH/Wtz0wTIhp9N1qQEJMBXbKSKWV/Ps8i8wi1AWvBLEMx9suq4IJi4ePZ8hvGZX2MMz13olvSqZPCLOjHJ2yZK/JHGGCA4j9GmBC2Tip3vx6zmpQOSYh++KUVf3BqmiL0eH1d+mG0O+EERWnok8LDBzBIqGP9oZR8kThn24OC3UJiuFm9cjFqJTajq+TBGM5gCuozRL/0TN6WGnpkDK4WwXkUa7GEyaI4E1k6GWWbAHlZhA4gH0vW9RdmSYvuT/n10s+NJCw95RTsKJTfCKsAvl6faugRJzPLY5mJZd6KH9P9XHNuhSpogrHU+HnHVXumvumj/pe0UH2wWZw6SftrgllkJR1B2m0XXQAmMPP13sgGev5ZlKZhaDkT8/sCt3hTs/xMDc12T9WfQuSUGzalOaHOiAfAIlQ5Z6VnSIyMsp5B3wdt1XpXefrBpzEl1+sA
 BtwMFGL6
 9WkFWOKWDQLUfzuw9HfdKzecTvVw5nFHAZd8jIuwlYaQYFh0AmDo6uezqzncuO9etbmOwOR4BBdc53+Xr2gz3nfdI6sHZGJxXw+Ttob9WRe1jUGqgXVDJrcd70piIgKvAGU4lIox/+/c5GtxGphXwN4FtSXpHRGTpBr+oJ+GZ+br3Y9L9vZpupk1PgmSZ4S2+xDS4LSlVWVU3WG6bZOQbZjBiXO2yBDhlFhvB55elOQq/negoJXP06DzuKneUbyUsqUWKLT1SDsW0jT5TLzp07z/b+8jCjfzD6Pkz6e04gbRV6PMVxtV4J3eOAc5+oNvU8JgaHN5i0A/QZSSvO9LH6fDX4bDpzGQuGSaP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 03:13:44PM +0800, xu.xin16@zte.com.cn wrote:
> > > diff --git a/mm/ksm.c b/mm/ksm.c
> > > index 0299a53ba7c9..a13184d00759 100644
> > > --- a/mm/ksm.c
> > > +++ b/mm/ksm.c
> > > @@ -3200,6 +3200,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
> > >  	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
> > >  		/* Ignore the stable/unstable/sqnr flags */
> > >  		const unsigned long addr = rmap_item->address & PAGE_MASK;
> > > +		const unsigned long vm_pgoff = rmap_item->vm_pgoff;
> > >  		struct anon_vma *anon_vma = rmap_item->anon_vma;
> > >  		struct anon_vma_chain *vmac;
> > >  		struct vm_area_struct *vma;
> > > @@ -3213,8 +3214,12 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
> > >  			anon_vma_lock_read(anon_vma);
> > >  		}
> > >
> > > +		/*
> > > +		 * Currently KSM folios are order-0 normal pages, so pgoff_end
> > > +		 * should be the same as pgoff_start.
> > > +		 */
> > >  		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
> > > -					       0, ULONG_MAX) {
> > > +					       vm_pgoff, vm_pgoff) {
> >
> > But vm_pgoff would just correspond to the start of the VMA, not where the page
> > is actually mapped?
> >
> > I&apos;d assume you really want the linear page index of the original page?
>
> Right. I&apos;ve reconsidered and realized that using vm_pgoff is indeed unstable.

Your email client is inserting (kinda) HTML :) & apos ; -> ' please tell it to
behave :P

>
> My initial idea was: as long as we can find the VMA that maps this page,
> it&apos;s sufficient for anon_vma_interval_tree_foreach() to check whether
> "vm_pgoff <= pgoff of the original page <= (vm_pgoff + vma_pages(v) - 1)".
>
> However, the flaw here is that the VMA may be split(e.g., due to madvise or mprotect),
> causing vma_pages(v) to change, thereby making this condition no longer satisfied.
>
> Indeed, it&apos;s better to use the linear page index of the original page.

Yup :)

Partially mapped large folios would cause weirdness also but KSM uses order-0
right?  So probably not a thing.

>
> I&apos;ll send v5 to correct this.
>
> >
> > --
> > Cheers,
> >
> > David
> >

Cheers, Lorenzo

