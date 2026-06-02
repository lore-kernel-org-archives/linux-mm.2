Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 833C3CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 17:50:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E76846B0088; Tue,  2 Jun 2026 13:50:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E275F6B008A; Tue,  2 Jun 2026 13:50:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3D526B008C; Tue,  2 Jun 2026 13:50:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BEA346B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:50:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5276CA0976
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:50:17 +0000 (UTC)
X-FDA: 84835711674.15.EFFD109
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B04B140008
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:50:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NSmFgoeh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780422615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GO0ughoX6tIBN7Rfl1sxm5xunBsDcVGcFMz2bkL4sxs=;
	b=IvAwNQMcemVkN+vfbzujLQi9UZ0l8/pBFcIqXYJxD/03pLGozrItuLVfI1CKROYkQUyn9x
	FdeVpn0yMWUjaUdqXB81JCpFWF8GhblLCgnRkLm2rJb9Y565D3t5Gb2daQfuWkZ7mVpApQ
	xBd/YBpLIBa+e3TyXeU4Cxnq4sJe+J0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NSmFgoeh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780422615;
	b=pQns9RP7ZoWmxgAJndkYtroGTxVkIcUlAIA+XYEflpY1KHmFCohmC5vPCxpjkbqx8DaniW
	mD5kt6hYkcUN+xwkauGjbokuuH85bIiiqu9Nn4WEaQm66uFez7UMCUXA6AInhfDuOKEsdb
	ojr7jtnwxBrcD+f3doBbBIhbbJ8K6cs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D3CD60098;
	Tue,  2 Jun 2026 17:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE481F00893;
	Tue,  2 Jun 2026 17:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780422614;
	bh=GO0ughoX6tIBN7Rfl1sxm5xunBsDcVGcFMz2bkL4sxs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NSmFgoehKN8l7Nu3qFjPX9PA1JKtgCb0OnvBI+IS4vrCZ3nnMOE6EM83u9fGdOUah
	 4xXfTfQB/neJj095AmqowvVzylbkcIxgu8Jk2pKdqQH4uACdBr5UHRJ7v33TdcKgvJ
	 E88mOvzEP8uCWRy7hie9kecWXK0/gaDvIfXTC+4gHrK9GB9AMFAVwlvK3Hj4RyjLUa
	 K105NrN4t1D0EqCEE9lcUmUiFRmpQ1XHDtQHq0KcM+4S2NxVRa2AxycnWf9bfs0mSU
	 7GfLZN3Lwc3KC2e6hqwYf5ZxrulvHck5J3aRNpfHCsunz8GxgLf7mXkzGHJy6HrsN8
	 +J9ORV2bzB5Mg==
Date: Tue, 2 Jun 2026 20:50:07 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] mm/hugetlb: make bootmem allocation work with KHO
Message-ID: <ah8Xz3qc3cbHkiuK@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-13-pratyush@kernel.org>
 <agmS5yZRflzN1M8U@kernel.org>
 <2vxzo6i37bs6.fsf@kernel.org>
 <ahyAhyVGzXdrigIw@kernel.org>
 <2vxzpl29dpzj.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzpl29dpzj.fsf@kernel.org>
X-Rspamd-Queue-Id: B04B140008
X-Rspam-User: 
X-Stat-Signature: w59bsxbmtmca4wh1rj4uem76ykhzqbpd
X-Rspamd-Server: rspam09
X-HE-Tag: 1780422615-794222
X-HE-Meta: U2FsdGVkX18xYKC6D3t9X1PywrGMsyI1R2ze8sqPi57bMnXifTNl2sqJ85ZFI8VnRwwINdj15FRUoz/3wDwFbV35gq7UHr4RPb7VwYMz6R3U2XApMmTi7QDlGe0W1tVTR+SHdd7gmaL8O3pPT+8x0U4yh6D6uqcqQZCGTgCEVLxDA+87mBpzG+m8129Qg5FZSjcpjwOodyggZlwd7tK2FmsD8xbQotPm7tqNjedgBaaIGcy6jWPnPD/jvV4hynx7ABULMrYHpPTPd1LrjJVCbjnWphkjo+tknYNqgOpFFbmbvbgI9uXqO2+g37R74kA84pzz/a2hCDlFB41lcZajcSucYJuBVaITTMjt07MxpTGIeTD7/tOj+2aIEpC3e01HZUdL6fZPsAquRa62oZTjbfVIWclceRy4cPDWyPkf1tCHlrtxNo1ZknXDq4mZU974t3G556oPUmSzzdKtCl1YCor0IRf7ijfBg3h6NmawZqiJqMziGozmK3p0MEGDaadZj82JfT4115vGrYxtHpN23ExHGi5NI/P2NBqjh1MpFUNhVRazlMtGkFFa2/OIIn6MkVET6xt6cJmcOJEh50WrQ5Ckk9WRABek8vPcGxYahcvotVKq9yeVQIYS3LFh3JeOBW60eJH5pc+XSS/Ef8O3H7WRgn3FjVnidkiJTihQa/KOTMhQkiEjvFof4wNZiiLRn5/j5iiXh2deFORYbKaW5Ii7b2XA6WFBE9+jRyGaJ9DuiBfD6fzDzV0OqlZfN9SEWANrZ18WrauezmKUgzEd5xHfATanqOFp6ILijdyOJna2Dz52eE6R6LTCZSd7/4nA0jFW8cmiW6O4P3F4rC6FT4529vSuWRY8f+/cuAWcOGji9Rm+nbWYIhCAFR3WTK+KGST+A1Ir6+J6I8vE27WjMGMSGZPtKI4Z2FoxaHe7UUyEAZgh4eR4YK2sjfl9X1hedGVgf68KFILgZBAeW6d
 pY5RvayP
 Nf/Ut8KLwT5AACEtCkeKgo5dcyRTMx6OTCRpTCNrGTimSOVEoKkrg1x8tv9PkeHCBSr4jInXRXwM8JWtuUieZcv5PQ6xmyoaUh+HOwVNYGEk5JwX0urtthdZRjJSwBQmWZssciGlDyRXWAC+UoqKh2bpIe5v5GWSLziO/ly8d6xgudwbvJ4ePqF5OfixFkwr0X6Rwz7oNKBklVuB+OtHSIsheoLjcqB/t8nHxD/LOFIqpwWC5H+pc1nmyACfcS8keFD62/9OoGUpM86BkE+9iNR+Eeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 03:35:44PM +0200, Pratyush Yadav wrote:
> On Sun, May 31 2026, Mike Rapoport wrote:
> 
> > On Mon, May 25, 2026 at 05:24:09PM +0200, Pratyush Yadav wrote:
> >> On Sun, May 17 2026, Mike Rapoport wrote:
> >> > On Wed, Apr 29, 2026 at 03:39:14PM +0200, Pratyush Yadav wrote:
> >> >> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> >> 
> >> So, in summary, I would like to pursue option 1 and try to make it more
> >> appetizing. But I would like to at least know if you hate the "extended
> >> scratch" (ignore the name) as a concept or only the code it results in.
> >
> > Let's retry this one :)
> >
> > I looked more closely, and it seems that mixing SCRATCH and SCRATCH_EXT
> > should be a lesser headache than going with option 4.
> 
> I also had some time to ruminate on this. I still think option 1 has the
> most promise, but my opinion on option 4 has improved a bit. While I
> still am not sure adding a 3rd phase to struct page/MM init (early ->
> deferred -> KHO reserved blocks) is a good idea, I think it might not be
> as bad as I first thought. Dunno...

Until (if ever) we enlighten memblock_free_all()/deferred_init_pages()
about KHO, small scattered reservation make memblock slower. It's hard to
tell if delaying more complex initialization of the large reserved chunks
until SMP is worth speedup in a few memblock operations between
kho_memory_init() and the end of deferred_init_pages().
 
> Anyway, for now I think I will try to make option 1 more appetizing.
> 
> Here's an idea I want to try out: I get rid of SCRATCH_EXT and mark the
> free blocks as SCRATCH. For HugeTLB, I can teach the special
> memblock_alloc_hugetlb_something() function to exclude scratch areas
> when looking for free memory ranges. So core memblock does not get a new
> memory type, and the complexity of hugepage allocation does not leak
> into memblock.
> 
> How does that sound?

It sounds fine, let's see how it looks :) 

> > Tracking the changes in gigantic pages in hugetlb also does not seem
> > something we'd like to pursue especially considering that memory from freed
> > or demoted gigantic pages could be reserved.
> >
> > If we add a dedicated memblock_something to allocate gigantic pages, we
> > can reduce branching in alloc_bootmem() to
> >
> > 	if (cma)
> > 		do_cma()
> > 	else
> > 		do_memblock()
> >
> > For hugetlb_cma we might want to teach CMA to create pre-allocated areas
> > and then it could reuse the same memblock API. This seems useful even
> > regardless of KHO.
> 
> Sorry, I don't get what you mean by this. What pre-allocated areas? When
> creating CMA areas it calls cma_alloc_mem() which calls into memblock.
> What would we change about this?

s/teach CMA to create/teach CMA to use/

I mean that we might want to be able first allocate gigantic pages and then
feed them to empty CMA areas.
 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

