Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 734D4D111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 06:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C83F56B0010; Mon,  1 Dec 2025 01:54:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5BA36B0011; Mon,  1 Dec 2025 01:54:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98526B0012; Mon,  1 Dec 2025 01:54:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A81306B0010
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 01:54:48 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 54CEC1608FC
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 06:54:46 +0000 (UTC)
X-FDA: 84169989372.14.530C461
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id BDCEE140002
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 06:54:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WdAKNk1h;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764572084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kfnxiyig/VfJvWqtVCcPQgBGGzc0M6lW4gRh+8zP8B4=;
	b=Re6mCLYNivOb+FRDHpZ2938JVYtnwS/FbzW0nrX2RcYAOpxd2H235EL2S66A30Gq+DavA+
	oK/rCJSWInjkUP3DVEgJvWUCbP4CTAnPqzIUv/AvEV7wmzkq/Im2sIAgZNJXm6QsuzwpTK
	4nRtgI449dr0xPce1xg8FewLOH4XCHs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WdAKNk1h;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764572084; a=rsa-sha256;
	cv=none;
	b=I9AxwZw+66z30Z3DAQDF9bmTBF8N6/Pk+xRw5g/rSYd8JZvAb9HwOMRSG/f7TUGMtg8wd9
	sHAnx+p/iANauGmC6qiMawaZ8q0y2FWj43BihREpZXG7KWpEXuFQdeFJ1N1L5JmDaR+zHL
	HJxztFNE31hsHw/f/lP5eJHXwRMZCT4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A0AA6014B;
	Mon,  1 Dec 2025 06:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EAD2C4CEF1;
	Mon,  1 Dec 2025 06:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764572083;
	bh=GZa2G5potCEIy2zDYWbNMaWHtJEpt1+etp9afgwxZe4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WdAKNk1hWm3DX8qCSqa7BmET/VUYWlGAiMYdrMjsuaX41rYPyBHVMB+q12pm22Vrv
	 rBqn9IWfSxYleSP6P4jyohMRicda6JSV2BzlKydRxOh2xWNEVtFbxmPDlSVisR316X
	 q7x4fgGqRjOPywcvXoPk+yXbBb9pxIPyEPJ2lChanfBYSjqzo55+npSk53iJZOXWuJ
	 x5NVxFEMeCE6kkUHB1rwzRx88EOl5OJuOth3QofJnhftx81+He3b3ZKev+26Kkj7ll
	 ewUlqp6vlnDeSar9607LapxHYwgAVguPFqBDrkcfVxONYTkGHcKzzgTUr8Vpn7fblO
	 Z7gUz3+bu5Q8g==
Date: Mon, 1 Dec 2025 08:54:37 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kho: fix restoring of contiguous ranges of order-0
 pages
Message-ID: <aS07racwRsh4ep_L@kernel.org>
References: <20251125110917.843744-1-rppt@kernel.org>
 <20251125110917.843744-3-rppt@kernel.org>
 <mafs0pl96w7hk.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs0pl96w7hk.fsf@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BDCEE140002
X-Stat-Signature: hsbs9gotgfa9qzxj3xwwdhwaimpack4b
X-Rspam-User: 
X-HE-Tag: 1764572084-710152
X-HE-Meta: U2FsdGVkX18mkqIus8/Wl0S80It5vbdhyTy9J5HwgQ1kKjuA4jHI8Vm/lDDnPYYoL2oclk186YRzVAh231uaPmQo3af6b+nZbTxyAmPzFz47uFlVJ75foebA14OkmEPqP8iafD7aJVzvn0TCoGtRfF5+lDEy/uqLWnolwMRmn2Yjek2ybEllCReLa7+aWsidQ+B6vf3gxvDapcTaO6TMsQ/hB5UTuaY0gPWaR5DgUJ59OZRbF8Ngwx8mdMBKHG9R+oTNTFPp64YJdSmnd5cPXO4ZK9FZaHL9eR1oMMIWrUlUcTh1HZi/Tj487XPXTcaFogRvrXujxp6CVOenvdia4myRxtU84gEnZvVUq4IVNooBPrKn+29DgG9wAHDCrhoSTKy6mL7gcv3H7RQNfruf3OWyUrbM1AKiXWnl3Zcan/kVqjmIAtj/JpGPNggqD9HgeIAxd4NviRqrO7lJI/H5EskfX0OmTmKcFW/sfd/cOMl8JtJMwvO2mZhL2YNBirkcuh+p8BDH/DK75Cgw5bQp8MAoMdtobvyll4vO4snfBqnaryb3djTHUQ5FuGOf8ZLa/fX8/9hBA1KZoOzV3SCCHZ/GRcNfHVOtjUti270RcRRypdcOsPZz0qLz/egRGdesZpWYxa/Opp9mZrYEIpSYe9qKCoXJIQmkkdx0ycobjNN9SA8KRu7g8D1wBVPIT58vOtNrJATMfz3fqCLNlta1ZKTZaFX/I8sPzHdgccO3xJzUPwEi6Ul2qgDZRYgadTFu3xuOT5BVE6ovlN1l8sgePC5zZjCaVAa7eodlyUZuAC9TJV/DKpDlppYkTUfrYEsFF65xg2pcQHK9hfxIJMZamePsn9OG+je6vCUxkH4cw9YQf+XA6yN8va438MqtPeYzPCFGqlv6W6ctRHReY17PUp0J+gEUUeS5jVTtzQ97k4LoD4kio9cCA5iyklg9vk3C6ONHSOhMdaXjOeqfB8i
 yQSI/iG8
 YHKuScGB9xZCCrket1UYj9vVptWM7kO6nVUGM4iP6kO3ehjpQiCIcYXM23xGZEZQQRz13t7CAjLn03hCYfVXJZaaolDj0CoyGSqAn2OmKegzvkp0CPkckDVdhpmAotsQ47hM8T9ZZa03wTzLhXEtI2XmQ5eIK9N5gtkVtb2oC0g1Z/5G9gdxpO6uCSdea8yX/sojQemk8Zdu4rvNFd82miizVXTCi2FWS1yZxW0IM94zq8kygz2SBVTmkqBHII9XMc4Cu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pratyush,

On Tue, Nov 25, 2025 at 02:45:59PM +0100, Pratyush Yadav wrote:
> On Tue, Nov 25 2025, Mike Rapoport wrote:

...

> > @@ -243,11 +243,16 @@ static struct page *kho_restore_page(phys_addr_t phys)
> >  	/* Head page gets refcount of 1. */
> >  	set_page_count(page, 1);
> >  
> > -	/* For higher order folios, tail pages get a page count of zero. */
> > +	/*
> > +	 * For higher order folios, tail pages get a page count of zero.
> > +	 * For physically contiguous order-0 pages every pages gets a page
> > +	 * count of 1
> > +	 */
> > +	ref_cnt = is_folio ? 0 : 1;
> >  	for (unsigned int i = 1; i < nr_pages; i++)
> > -		set_page_count(page + i, 0);
> > +		set_page_count(page + i, ref_cnt);
> >  
> > -	if (info.order > 0)
> > +	if (is_folio && info.order)
> 
> This is getting a bit difficult to parse. Let's separate out folio and
> page initialization to separate helpers:
 
Sorry, I've missed this earlier and now the patches are in akpm's -stable
branch.
Let's postpone these changes for the next cycle, maybe along with support
for deferred initialization of struct page.

> 	/* Initalize 0-order KHO pages */
> 	static void kho_init_page(struct page *page, unsigned int nr_pages)
> 	{
> 		for (unsigned int i = 0; i < nr_pages; i++)
> 			set_page_count(page + i, 1);
> 	}
> 	
> 	static void kho_init_folio(struct page *page, unsigned int order)
> 	{
> 		unsigned int nr_pages = (1 << order);
> 	
> 		/* Head page gets refcount of 1. */
> 		set_page_count(page, 1);
> 	
> 		/* For higher order folios, tail pages get a page count of zero. */
> 		for (unsigned int i = 1; i < nr_pages; i++)
> 			set_page_count(page + i, 0);
> 	
> 		if (order > 0)
> 			prep_compound_page(page, order);
> 	}

-- 
Sincerely yours,
Mike.

