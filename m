Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4279BEBFD20
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 09:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F2706B0092; Mon, 13 Apr 2026 05:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57BD96B0093; Mon, 13 Apr 2026 05:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46A756B0095; Mon, 13 Apr 2026 05:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3281A6B0092
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:35:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C909A1B93A1
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:35:24 +0000 (UTC)
X-FDA: 84653024568.24.C0D1C54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 42BA2C0008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:35:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b715bc9u;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776072923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Nk7xoozEJi1ro9tenFGPEU5Zl+FKKAQoJl63YSW/FE=;
	b=a9Eb5BoCOeoxYwVcQjXDS7WHDwMPflghxPJxChKHCdWxSplZ+dq71l4JSB9E9JMXqHwijR
	d9QDNB2PrXsc/eZsa/dULq9JZqstsTz40ibHUbKMVWMGeU+yWCMEc1Fvfks0YVsiTDScHT
	myDnWsxyxGRG28acwAM2qjCG+dNOq3o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776072923; a=rsa-sha256;
	cv=none;
	b=a0XT/maSisGg0xq2/EnzqpspeOLMhPIKeGTp3THOaz8KS5IhsgGAklDlIXidQ8G4s5lwF9
	kAp+yqxrOyQkw0Q7UGa/AXjYOBl0z6Qw8JrSZi4GW8dXQGPZeESP3wOjIumXKml0K/5I+8
	/MVAFXPz7jCFwajbkQj6pQrNWXwStAM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b715bc9u;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 93DD660180;
	Mon, 13 Apr 2026 09:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7F8C2BCAF;
	Mon, 13 Apr 2026 09:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776072922;
	bh=K0G+OC7cY44wL3XcPEIszFCe8WkP7B+tqb8dxqmAp5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b715bc9uzu+xDII7oSF3dk+qOb9Vy5kUF5WF9SZfGz2uUH5z4NP3CDsqIEMMddhYl
	 jxoIm1krczDBDHzTrZ8sq9L6EB7Kj3MunIE/1BZkIGy32ct9v6rhIhS1/19UuaqNg/
	 oZSbWBMPwojj5BDvW452xa6g1N+CJPZz2GqXarzFOG8oC3HIt913VTcVEi2Qn1HlO/
	 Gpv2w6oL7N7pmOn0pxC/E6tJNwY5SdVaGvyQs7z/ZZ7sW0ncwMSqrBuXZ3VjbjCCTj
	 QU1VAlcKKugE6apzNGFx0ZaNhz89VrBiv445k93tg26DA8flS5AOnZrZdQFboJd+ti
	 3ihwJIH1ISmoQ==
Date: Mon, 13 Apr 2026 12:35:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/49] mm/sparse: fix vmemmap accounting imbalance on
 memory hotplug error
Message-ID: <ady40BWw5WgQHf3z@kernel.org>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-2-songmuchun@bytedance.com>
 <ady1LQMN1xhPGcuT@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ady1LQMN1xhPGcuT@kernel.org>
X-Rspamd-Queue-Id: 42BA2C0008
X-Stat-Signature: zaoday3abyuwsn8rr4omboyp88d49pbd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776072923-800941
X-HE-Meta: U2FsdGVkX1/ekhns0+CE6ry0JH9xANLLttWKcteZZchvx+tsFGMfWkwT8SCD2K/ZnHObQXgPg/3Sho7IlXipYY6uvMULlzxuv6nOlMKD8aa2mKUrq+Lj8Bhgizpxu2X7IoRQctyvNc2/a70oSmk9frvrfxV79LGdCAl8fyg1qgQahlsqCl+znUPwebd/jKyx5yj4Vi7rGGTqqL/B3OWUhSjAsAAHhjAbuX5K4IjnK2Dve5apEa6XExE6CU+8lQ7xt3/webozlB4fEFUjhT/OMHYGtsj0bYKxbWwC1ikhQeRa8ES/7Fs4Rm+Z3ZGoZejph4lp54/x+rzmz+koQmDUy+OcvkbQfo4STVT5SKpPhem2+BCuqX+1OlyAudHUJDuCNljOyXbQNZcXBEi5Zk3aOmAPWo1eHwIHjoRri2Xk2S8crn7TQpa0CwjqagxKxAigcnDCpF9u3sSvPzP6CasPOb3exL5ctVApGHMWK41S8jOSGjbf6KIybac9Z1xKSS7y6ObRni48PqliUgCeDkCu7b812mJQry0EyPgmaawixs5nlPj3KPtTZp06v/LlN2nPGmLJwbvRSVh9ToRyP0uRdYE+0yx5NMVrPEV5eMjScjwch4oBaWr2ryFaNHH0B6gWSBfVQwoJi7i3jCUC2CNJDirPSPWTcaaRVd3iZd+2rNcWcgBujSLmeh5zhA9HAIyL9n4XgeoGCCs0bHzcwzQCSrGHzjlBjEA29Yt5jW24FxJFruN7Eu+H2D1rzonm3lMH93SXyr4xVXPEkYOZ1mKV6+Eqi5FZaS+ajwzofjw+JRyReeeUnY963gn8OQ0rXTsbvWMGewDY1t2IyQQLIsEZlQRoxprvTLSUWQ8OSc3Mb6XxSxU/7aovZBzxY4UjHyR6WItp/i32zdsreUZxztp9QIAgQpvUz2Vyd1XvXjQcVpHfRq7BFabJoon+ZE4I8Aq4rvIz6G3EIbffRLNyEUR
 ELBxG6cW
 jD36l/YK0YjRShvbl989b5iIDslvk3OaFJkqSAUyyayXsSuQk2QjGm477XMkEZGzOLvMwdVWLHDIloFRISb9iXNBqukTyIMK/Jk/o5jTQH1ZWoEbl9/NX5EeKqhAP9tQf7vV1trRyal3vHkVwUqnGQijujbbBr8IEeoNVqbO0aYeSB85esDvbPtpVxQRAdxsneA2T8gBbTCUKkDOYkIVRrqxj/EqQ6Ljd45b3q/B+/YGJ4acbz749ZYD9mqFtb7a9rtZW1JpEgB+6kvStUOrB+xK+wA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 12:19:50PM +0300, Mike Rapoport wrote:
> On Sun, Apr 05, 2026 at 08:51:52PM +0800, Muchun Song wrote:
> > In section_activate(), if populate_section_memmap() fails, the error
> > handling path calls section_deactivate() to roll back the state. This
> > approach introduces an accounting imbalance.
> > 
> > Since the commit c3576889d87b ("mm: fix accounting of memmap pages"),
> > memmap pages are accounted for only after populate_section_memmap()
> > succeeds. However, section_deactivate() unconditionally decrements the
> > vmemmap account. Consequently, a failure in populate_section_memmap()
> > leads to a negative offset (underflow) in the system's vmemmap tracking.
> > 
> > We can fix this by ensuring that the vmemmap accounting is incremented
> > immediately before checking for the success of populate_section_memmap().
> > If populate_section_memmap() fails, the subsequent call to
> > section_deactivate() will decrement the accounting, perfectly offsetting
> > the increment and maintaining balance.
> > 
> > Fixes: c3576889d87b ("mm: fix accounting of memmap pages")
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > ---
> >  mm/sparse-vmemmap.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> > index 6eadb9d116e4..ee27d0c0efe2 100644
> > --- a/mm/sparse-vmemmap.c
> > +++ b/mm/sparse-vmemmap.c
> > @@ -822,11 +822,11 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
> >  		return pfn_to_page(pfn);
> >  
> >  	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
> > +	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
> 
> This logically belongs to success path in populate_section_memmap(). If we
> update the counter there, we won't need to temporarily increase it at all.
 
Not strictly related to this patchset, but it seems, we can have a single
memmap_boot_pages_add() in memmap_alloc() rather than to update the counter
in memmap_alloc() callers.

> >  	if (!memmap) {
> >  		section_deactivate(pfn, nr_pages, altmap);
> >  		return ERR_PTR(-ENOMEM);
> >  	}
> > -	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
> >  
> >  	return memmap;
> >  }
> > -- 
> > 2.20.1
> > 
> 
> -- 
> Sincerely yours,
> Mike.

-- 
Sincerely yours,
Mike.

