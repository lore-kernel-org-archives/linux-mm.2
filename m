Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85A89D7496A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 09:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BB9E6B0088; Fri, 19 Dec 2025 04:19:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945D16B0089; Fri, 19 Dec 2025 04:19:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84B956B008A; Fri, 19 Dec 2025 04:19:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72C4A6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:19:44 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10C5AB9A4F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:19:44 +0000 (UTC)
X-FDA: 84235673088.25.581DA68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6D711180008
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:19:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gGRZKEmB;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766135982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/1A4ohyblOaTc0UavBxprXVoIV+K4VX6U5X1bS1U9U=;
	b=SvnI6eO6WW0un4Tp2J0X9Huz6LZAuxBm2H1BYSVfB0AqQuQt9wHiwIheoOjHlU9K51wyrf
	+Jjj8kEqTo2A0p2vs3NeMiZQWr4kyUDARpJXleTqhUuCrGq3kRzllzf027UrOK0sAhw56f
	InWdFjKdHi/LqcADbfAzh58VQ5vp7w8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gGRZKEmB;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766135982; a=rsa-sha256;
	cv=none;
	b=yYfQu04ZT8/LwCbX5iUf0vc9dEpZZCwmE/8hZictUpVfOoGT7UWVoywawWwR7fzJdNPMWP
	0L+ycmZdyXQh/Zyu6sgJmMONjKmE6PYlGiXxNKxa59EZUFM+jjjCkzGbuOiLL1KYlNKUBP
	tMLp2y+w8oDxzqT0yPlsiIJm1A2485E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ADC2F600AA;
	Fri, 19 Dec 2025 09:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BB0C4CEF1;
	Fri, 19 Dec 2025 09:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766135981;
	bh=PO6v/fWv1Mc8WnsslILLXQGaglGO94u1Qqdt6Qqrmfo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gGRZKEmBCsW1m5GIxZjWaZh9bzgvAtULm9UOSbnMH0muoSNjNpkZn2qEjD2VIMB1t
	 VJN04JQCI7MEjUfFHNCieyAFihZpXWzTTqnzV4zzOfrdgRBXchL0QtsDfygAeV9Zer
	 0eOB0sQNomMcB6Eki4Os2O4lzyVaY/ldcEAF40Jlu4bAgL0F5taqxBKSy/bbFK1Yoi
	 t5H7gdsY8GyZml2iSYhg9LdJ1Vrh8qS6IP7K7ou7AQbkg8o7sRzoj8eqjsYwVRoerS
	 h+I8QLbXGsT1+d71RygPScj38IKjgj1Pwbnh+vznbyRgkxMSXE09rB6J7b2EA4F6xQ
	 9P5Yb5hezZGhQ==
Date: Fri, 19 Dec 2025 11:19:34 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	nh-open-source@amazon.com
Subject: Re: [PATCH] kho: add support for deferred struct page init
Message-ID: <aUUYprAotKYMiEs0@kernel.org>
References: <20251216084913.86342-1-epetron@amazon.de>
 <aUFJH9xzJXYOt_X8@kernel.org>
 <CA+CK2bDGvgcGJijAtSSa2k_FWjnZXm2jRiFd6Z9-XjEQ-Y68DQ@mail.gmail.com>
 <aUF4fsWwD9BswkFh@kernel.org>
 <CA+CK2bB2mn5b0N9gs1UavYLUQhbpVvdo702oHZa15E9OaZkKWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bB2mn5b0N9gs1UavYLUQhbpVvdo702oHZa15E9OaZkKWg@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: ppqqe3n7jh9k9y1es9opxtjomqs7zb7q
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D711180008
X-HE-Tag: 1766135982-694614
X-HE-Meta: U2FsdGVkX182WNOAc5nOLDdc2RsZyg+vgtorIOgd+5SlentJ7OcCq9ikAC+KWFIcExyn9epXsEIFoa/q0cHeKtm458qxG7PtkXKReylvPotA2656irfZA5QU5GKumxIv9r9ix3RSruXRDeyisRbREtIyXp6DNqCq9D7ywPw7MQ21Ig3dJIVofDn0FQjoEpUGeZmsE/heYXhKebJc+Iixmm1FL9vIbZ3tobitPal8MaH2fEVcUovje9OFBghiOFidNt4dtM9TBJDOXGjklSO34TMUOCefnotvYJiVw97ZdgGWlQZXCevDTs76DQ3enxKxCHACysL+MWGF9PLzGuUFwyn693YlGLldm58YHDrK0KjJGBq4fiMdNmjn4XW8RUARreWPWz6vGvGnsF7TSMZ/qlPaqEwUgwIkZw/A12cEVtHj4d2ZCetu3uBsMb8jNLFp3eIlmtfQxOHvnJhlM4HvuauH+6F0bG8rD9zjIo4nfZigA0uT3XsvJR1kEvGJIxdwgeGhSOQf5xzHIcgzWGBOBg9a6HKXQ7uOgQp2wEJX3AnGX/VzJ7NgOCVEdzb2QLbVZXdr7kvdpslMrABua30Hs6vdV1LDHM1kZ/CfGAAV57L0JJ6i3lcvVtElGhnjy2Tg5riaqcpXaLu04gSyZFymyc/RnetreXcuVhIsichj78G12iGM9r8BZAuA2xfv+SEsBhOda6cnoLSCqAzpiRKmQWBaa2pxYIyxfUi4oVGyidCNqp1HQV+xyZnCUpFPbxEJrTElsF7uF7zGucWmxZdjzJF1//CubkI/vzcGEhWjsJAU9+7t8fUdiw+vU26wdosQ6LP5GiuzbUFbpv242sR8xlMk5iKcYZ1XTj8oNuQhaBGd0QeiHZDq27M+wSceOSd4UVsHAL4VWk4fx/9ZscraiiJ3z+PibQruE4vpebHhj9bYPgCTJGZxy/GKTBkVCmXyMUZ+pWai2jkeYbFYEJm
 R4I6+3R6
 MOVGWr9Hy713CaI/8WMyiMkdGKT3x6YcUihqSD5Ay1XMOT0qVWVefWE+dCWejPLjOxY3Vf2nRyIbPaAIz//xnJLT5zJNmbg4jY8l7oJ4XgETSzPuni+VeBHP9GM/j+yD8DChhRd9+UItbzxZBtY3lYuj+HfivyZkAxSh2fLR4fbYvr9oZYC/gRc34wPLD+J0pekei4Hetbt+QjwTy2a5pXeDgFBvlHpJaMdCBfb+upV3vCKQBIhPnrBHdZxMUeJm9C6NvfHHu/fsJSUGNT8uamNeuDb0e1gGaR8RQiyuOzRLbGho=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 10:36:01AM -0500, Pasha Tatashin wrote:
> On Tue, Dec 16, 2025 at 10:19 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Tue, Dec 16, 2025 at 10:05:27AM -0500, Pasha Tatashin wrote:
> > > > > +static struct page *__init kho_get_preserved_page(phys_addr_t phys,
> > > > > +                                               unsigned int order)
> > > > > +{
> > > > > +     unsigned long pfn = PHYS_PFN(phys);
> > > > > +     int nid = early_pfn_to_nid(pfn);
> > > > > +
> > > > > +     for (int i = 0; i < (1 << order); i++)
> > > > > +             init_deferred_page(pfn + i, nid);
> > > >
> > > > This will skip pages below node->first_deferred_pfn, we need to use
> > > > __init_page_from_nid() here.
> > >
> > > Mike, but those struct pages should be initialized early anyway. If
> > > they are not yet initialized we have a problem, as they are going to
> > > be re-initialized later.
> >
> > Can say I understand your point. Which pages should be initialized earlt?
> 
> All pages below node->first_deferred_pfn.
> 
> > And which pages will be reinitialized?
> 
> kho_memory_init() is called after free_area_init() (which calls
> memmap_init_range to initialize low memory struct pages). So, if we
> use __init_page_from_nid() as suggested, we would be blindly running
> __init_single_page() again on those low-memory pages that
> memmap_init_range() already set up. This would cause double
> initialization and corruptions due to losing the order information.
> 
> > > > > +
> > > > > +     return pfn_to_page(pfn);
> > > > > +}
> > > > > +
> > > > >  static void __init deserialize_bitmap(unsigned int order,
> > > > >                                     struct khoser_mem_bitmap_ptr *elm)
> > > > >  {
> > > > > @@ -449,7 +466,7 @@ static void __init deserialize_bitmap(unsigned int order,
> > > > >               int sz = 1 << (order + PAGE_SHIFT);
> > > > >               phys_addr_t phys =
> > > > >                       elm->phys_start + (bit << (order + PAGE_SHIFT));
> > > > > -             struct page *page = phys_to_page(phys);
> > > > > +             struct page *page = kho_get_preserved_page(phys, order);
> > > >
> > > > I think it's better to initialize deferred struct pages later in
> > > > kho_restore_page. deserialize_bitmap() runs before SMP and it already does
> > >
> > > The KHO memory should still be accessible early in boot, right?
> >
> > The memory is accessible. And we anyway should not use struct page for
> > preserved memory before kho_restore_{folio,pages}.
> 
> This makes sense, what happens if someone calls kho_restore_folio()
> before deferred pages are initialized?

That's fine, because this memory is still memblock_reserve()ed and deferred
init skips reserved ranges.
There is a problem however with the calls to kho_restore_{pages,folio}()
after memblock is gone because we can't use early_pfn_to_nid() then.

I think we can start with Evangelos' approach that initializes struct pages
at deserialize time and then we'll see how to optimize it.

-- 
Sincerely yours,
Mike.

