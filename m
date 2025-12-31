Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BDF0EE57F7
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 09:46:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F2E66B0088; Wed, 31 Dec 2025 04:46:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575EA6B0089; Wed, 31 Dec 2025 04:46:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 482C36B008A; Wed, 31 Dec 2025 04:46:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3820D6B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 04:46:50 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A66BA1407EF
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 09:46:49 +0000 (UTC)
X-FDA: 84279286938.16.569E21B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E5248100003
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 09:46:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="VSe/zxSD";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767174408; a=rsa-sha256;
	cv=none;
	b=cJv1WM7tV8eTaXagwC310Xb/aAssLC7uBnKAmOISd7c80vAVb8o/xhfkaCe+JegfwkR4o2
	lR7+1gZFXlvl1rW7QmzOG5Cyfw9BE9bmh/hiQ6t6ojdWbZx0PZaMWxTL7+Os1jPpE9mTZl
	GKjQ6xNrBOgjecFto7iGchJ5dLJFzLM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="VSe/zxSD";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767174408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=puWMIkCqzvcukNc6entSGSZYTJ90NDZmrdy+34MYr64=;
	b=VbZMoR/VV7G5bZjWfQtfpkKwbncMQuWiCofUmKvZ6eE7B2jNzJNE3UzolUR1fF/OIN3LJt
	3dFzSvsn5f1tl+7c6OWDwfOUT5wZCqv1fLdQWOG+Uz+/Ludz3P1t/NwxXmlT7sQjQ0nv6Y
	n0S2WV+bhomiignWafumaxzD/pRaRsk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 90D0C40289;
	Wed, 31 Dec 2025 09:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05723C113D0;
	Wed, 31 Dec 2025 09:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767174406;
	bh=Js4gGVpGtn7C+f3YQhPLQtxd+Rpk3HniIelYKQQwOw4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VSe/zxSDWx34KjwRibmxVhaeoXwJc7vuj1CDNSJId3c2TQLzK6sKsUapbmCiuwwvR
	 fyJpfMDnR8SDywH+tRLlataLTsKEeSz8BqXp8Jaw+nWFiWCqO415Jjvm1xnRncfgaf
	 suBdOV+DX3COyxwr9fW360XBr/n01Hd3E4ULQoykp4RHuEc9JGdjsLPI3rd2pdLnGB
	 7z24kT3OG3AkMlWMQJPEOL9Zmxlhh7CPMXOhnGTc2E+E7t1OL2gL0l5lAKuE/pt2/y
	 kvg9uD40StmRSVnI1EfCiqw2nWitUEvF9Rh8kjXV9/2/TXGZMPXUtPzaAW80yIhbkt
	 DYSG5Henp/leQ==
Date: Wed, 31 Dec 2025 11:46:39 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,
	Evangelos Petrongonas <epetron@amazon.de>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	nh-open-source@amazon.com
Subject: Re: [PATCH] kho: add support for deferred struct page init
Message-ID: <aVTw_08W7zXR7Y0F@kernel.org>
References: <86jyyecyzh.fsf@kernel.org>
 <CA+CK2bDxnTEe9Ohq5zLuyF-jqgD0DPhfdq6z=yztUsXU5p5fSQ@mail.gmail.com>
 <863452cwns.fsf@kernel.org>
 <CA+CK2bCjJWZG_rPoPsHWSxirmUCTOuFQzTCss2AKf9UqpThrdw@mail.gmail.com>
 <864ip99f1a.fsf@kernel.org>
 <CA+CK2bDDEZ5a+LJNDVMtKFtQ1D9rP6rJqU064eoru=a9eHpaAQ@mail.gmail.com>
 <aVP6wBYoHJQsplIl@kernel.org>
 <CA+CK2bDZPwYpUhksDLSbfVdVm5TYbh0XrOKRV=q4YjGpqH+Fwg@mail.gmail.com>
 <aVQJUPOn85WlJaM9@kernel.org>
 <CA+CK2bCm=AGDSLTbs6etbqveFUHU80okE-bCT2zg20nrHXgHRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bCm=AGDSLTbs6etbqveFUHU80okE-bCT2zg20nrHXgHRQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: E5248100003
X-Rspamd-Server: rspam10
X-Stat-Signature: yf5k5rx78jkwkxp6keii7uzwc1he3wak
X-HE-Tag: 1767174407-414792
X-HE-Meta: U2FsdGVkX1/PgASBa3TGuamJykZq8CApyjdoI6IDAuqpl/7LFsuRnzyGLqXsbkePeVnR/6RD/dIY75At2g0v++EcYM+XiyYmYEotDfGroZ54wgWtXHM66XGouZYje4JwtABCZAD0DdHf3Zg3NBCW6l76cxSIT77vWC7oSq9rF3mxf/8sbpVnrKcCDqMRaAC3WpS7WgedS8PNCEa19SGvSt4U3sM4BJapfajcY9eYuFkwxlFcjGutjPV5wqokX9WaFEGhrKJV5VDwfWvNAj3cKK4heTUsPUduucmHr7bwDQ6F66XLE5cwwJrYVpfbp8d+iKy4AZES/6Vw5lXNtFZ0rxCDWXiSxW6HkSRUFb6W6NvxepYfjO69UF8GsuyXE7SH28aHcUjbGbnsBIaoN0f7kuHmtTXqRtM9tDJaRhu4udRp8+hZV+cpj55wqVrnqSYyG1+t8GiwbR8qVm7cYjlBIxN8/d9fasIzBHGPWcMiWElX6E6oyMYHyp5Q/zkLKueJynWUfZvYUbtKCSUaa+PJwZhxj9CUIqvNA8vFJhVaMIoAxSkdyuG6TZ8K9KfhcCf28WeToHsoHJP7oczc2nmKgqKwmltj2m1LXkJ3xEWpxQyWXe3g1Dmdi05GhyBt3LaHBy3soGbjjH5VNAgOflc+dV3FjgZMIPVfUNVnCwcSMKjEx/koIeql7nhJFJIOGJgvjxON5+TbLe2gRPfJxKBvBcAEBlixP5NYXchiOfcasCiwHTKgZeRD5rbtlNYWJ9FfIUi+l0ophi3l8GcNnWgPU+URkHqQS/pizL5msNKxawoomZ9cExABFuY6APc5z98zv9aLpSNIfvbclaI4jgH9vj8As3rlImNi6dqPNbMOE8EJLVEVeYhVkZ1XX3bEpa6UPeL8b9tXkUGUqEBEtsLCfUuj0UCaEAaSeYCNhgptzgFBYPS7tSRQsw08aYNWgJEtJGPqnXOqRyi868JUNY5
 c38nqddn
 8xJZKW9kRItFxwF3CPuNLGft+2w38q0qyGDVVnBni1P/df5EougBFg5TBj0fy9A4h1eTDJPxYMysttyTv4FBt1Z32RG7Uyq75Ea4jVHKTzLWixKraUC9qmRhV5GJ9tJlB4NDQhKcdhvY3G0CyCCDqoAkw5uWrmlTfXMOqG36Zmd7JAAdb7enZAnB1x0uZ54aRAgiPEATyhNKyXEX8bfRQl8GldkQA6Bp8mjIe/O4xbANznICQzX/WHy2effhquZp1sQx4KJ1ay3TMNus+pngKrfrxUyZxBsiNhY0IlfpyX+ydb2Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 01:21:31PM -0500, Pasha Tatashin wrote:
> On Tue, Dec 30, 2025 at 12:18 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Tue, Dec 30, 2025 at 11:18:12AM -0500, Pasha Tatashin wrote:
> > > On Tue, Dec 30, 2025 at 11:16 AM Mike Rapoport <rppt@kernel.org> wrote:
> > > >
> > > > On Tue, Dec 30, 2025 at 11:05:05AM -0500, Pasha Tatashin wrote:
> > > > > On Mon, Dec 29, 2025 at 4:03 PM Pratyush Yadav <pratyush@kernel.org> wrote:
> > > > > >
> > > > > > The magic is purely sanity checking. It is not used to decide anything
> > > > > > other than to make sure this is actually a KHO page. I don't intend to
> > > > > > change that. My point is, if we make sure the KHO pages are properly
> > > > > > initialized during MM init, then restoring can actually be a very cheap
> > > > > > operation, where you only do the sanity checking. You can even put the
> > > > > > magic check behind CONFIG_KEXEC_HANDOVER_DEBUG if you want, but I think
> > > > > > it is useful enough to keep in production systems too.
> > > > >
> > > > > It is part of a critical hotpath during blackout, should really be
> > > > > behind CONFIG_KEXEC_HANDOVER_DEBUG
> > > >
> > > > Do you have the numbers? ;-)
> > >
> > > The fastest reboot we can achieve is ~0.4s on ARM
> >
> > I meant the difference between assigning info.magic and skipping it.
> 
> It is proportional to the amount of preserved memory. Extra assignment
> for each page. In our fleet we have observed IOMMU page tables to be
> 20G in size. So, let's just assume it is 20G. That is: 20 * 1024^3 /

Do you see 400ms reboot times on machines that have 20G of IOMMU page
tables? That's impressive presuming the overall size of those machines. 

> 4096 = 5.24 million pages. If we access "struct page" only for the
> magic purpose, we fetch full 64-byte cacheline, which is 5.24 million
> * 64 bytes = 335 M, that is ~13ms with ~25G/s DRAM; and also each TLB
> miss will add some latency, 5.2M * 10ns = ~50ms. In total we can get
> 15ms ~ 50ms regression compared to 400ms, that is 4-12%. It will be
> less if we also access "struct page" for another reason at the same
> time, but still it adds up.

Your overhead calculations are based on the assumption that we don't
access struct page, but we do. We assign page->private during
deserialization and then initialize struct page during restore.
We get the hit of cache fetches and TLB misses anyway.

It would be interesting to see the difference *measured* on those large
systems.

> > > (shutdown+purgatory+boot), let's not add anything to regress, as every
> > > microsecond counts during blackout.
> >
> > Any added functionality adds cycles, this is inevitable. And neither KHO
> > nor LUO are near the completion, so we'll have to add functionality to both
> > of them. And the added functionality should be correct first and foremost.
> > And magic sanity check seems pretty useful and presumably cheap enough to
> > always keep it unless you see a real slowdown because of it.
> 
> Magic check is proportional to the amount of preserved memory. It is
> not a required functionality, only a sanity checking. I really do not
> see a reason to enable it in production. All other sanity struct page,
> and pg_flags related sanity checking are usually enabled with
> CONFIG_DEBUG_VM, so enabling it only with CONFIG_KEXEC_HANDOVER_DEBUG
> is better.

Having sanity checks in production could be useful because some errors
could be hard to reproduce in controlled environment with debug kernel.

Just last cycle there was commit 83c8f7b5e194 ("mm/mm_init: Introduce a
boot parameter for check_pages") that allows enabling page sanity checks in
production.

So my take is to keep the magic check until KHO/LUO mature at least.

-- 
Sincerely yours,
Mike.

