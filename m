Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AEF4F99352
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 08:41:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 090916B0005; Thu, 23 Apr 2026 04:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041416B008A; Thu, 23 Apr 2026 04:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E995D6B008C; Thu, 23 Apr 2026 04:41:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC54C6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 04:41:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A3DD12040F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:41:18 +0000 (UTC)
X-FDA: 84689176236.17.4B53072
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id EA0DC1C0002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:41:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FLcJUqE+;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776933676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AnqwNiNmBE870TAbn0m3IWi2wJAeU1ScdF9aKm0HDwQ=;
	b=b6ay4vKkhW2IGND+ZJnx9BM2gxVNlaq8kNhoz/q1GM80SKXUmC+xmdEoHxEbNoZcgJstgF
	eD8EZcLmdbgnmdaq8qTwvzYeZ3J819jeUmdw1unRDgZHjPi/S1yhPFGXINOSXQFcuIBdn2
	6pufBOx2+4Oij/BCzpHG8eTQ7fkbG6I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776933676; a=rsa-sha256;
	cv=none;
	b=lF3TQEnEIS90QEdErj7UshXxbsZPFw26WUROfAqnJbrY4PPXd5HKUI+TW1mB6vosROflMl
	GY+Rx6GRAAfNxeXeFrjIryw52uh55LQFGvjrx01W1XAd2I94zZbS4O9g04NZsdPQdN9yVf
	uzcbKp5LJuPYux6rek/MGsRXXZl5GPc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FLcJUqE+;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 40BA56001A;
	Thu, 23 Apr 2026 08:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E55C2BCAF;
	Thu, 23 Apr 2026 08:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776933676;
	bh=/o3cyhlI3NGUpyx7vDlXkXGS/7l1clLahFR6qWl4Ock=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=FLcJUqE+7zBvDxLageLu5YyUTMj8lC6wE1/M26SxjfptjMSqgpGlxLccHjh9YvSfp
	 xROm9gPXfErHIJqvFx7WN5jD0HzoO6HV2MAvppfFxyImKdMvwg7pD53cfEeVFMfCOQ
	 KoUcxtirs9rs8z16YYzzGjoGKHUieLX/lYMD9d/bC02bXJvc3rPvuuQPMLeBMYyMxS
	 ggdyxIp2HIOkR5Sp4Z07wdEHzERvLKpLEi4hkeBxkD5as4nDON3vElkI5QmDQBDtaQ
	 wzooCPgouNEtEDgXKs0uKi7/QxUY7Dnq4PdufvO9fyPjDRIeXY/LBxiDJblPV+xob5
	 MJLJICKdkYybw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
  Evangelos Petrongonas
 <epetron@amazon.de>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,
  Samiullah Khawaja <skhawaja@google.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Andrew Morton
 <akpm@linux-foundation.org>,  Vlastimil Babka <vbabka@kernel.org>,  Suren
 Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,
  Brendan Jackman <jackmanb@google.com>,  Johannes Weiner
 <hannes@cmpxchg.org>,  Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v8 1/2] kho: fix deferred initialization of scratch areas
In-Reply-To: <aeiFx8tilasoGzwa@kernel.org> (Mike Rapoport's message of "Wed,
	22 Apr 2026 11:24:39 +0300")
References: <20260416110654.247398-1-mclapinski@google.com>
	<20260416110654.247398-2-mclapinski@google.com>
	<aeD2Fzr6yr4pu9-X@kernel.org>
	<CAAi7L5d-ujEa7R21Lmd37X9451KBmK8ZhagSKbJde15aQLi2MQ@mail.gmail.com>
	<aeEKksfLxQ0A7Jun@kernel.org>
	<CAAi7L5cp3B0DFEQex5EqFdLDkqVWwRw228-pgp0PnhfgLP=e6Q@mail.gmail.com>
	<aecUW-Xgm5MPMyVr@kernel.org>
	<CAAi7L5d8x1MB1f6A_h2acj1CYU1wf7DijS1TENC+Lurx5wLhKw@mail.gmail.com>
	<aeiFx8tilasoGzwa@kernel.org>
Date: Thu, 23 Apr 2026 10:41:11 +0200
Message-ID: <2vxzqzo65as8.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EA0DC1C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: jqzp8omjnkgtcc498npfx8z38bnrbhf6
X-Rspam-User: 
X-HE-Tag: 1776933676-217835
X-HE-Meta: U2FsdGVkX1+5u/hTqORjIADAnkEkHDocpyNv1H39Ebqxcv0b/sisDnzJf6+i5BDSx/mRapbN2CXIDZjI3U6UUQunNfRKv0Uqvk8/sNYp64bZmtJmjACRsaiN+3q2femCcj7iELppeDHa4sV1eLxgT9VQjpn1IlWf1Ok40L77C7iQyAyEOfKtBMcuaIvUgbZrLJGqGf+KRl6c49OwsTnEC2WsrYgTaVHauDvHw7u6o5znFb50NcRIRGgcNrPkXRi3bQiydzIw+5CPACG0r8qywEAAEuzYKK2lAgVXhgwnl9jbwv8eQ0+keCA1od4BgciqyD9RqvZxFgsJFGMFcYD/HTiBtf8a1sZ8AuMTJsNttLnmUbqONjz2tinZBRQmAOcEGJjSerFmOYxTd0xEm8oL6eiqNfEvWRbkTLKbMcVvAbaw9BDaunMC3gTXRF1IUCCmoLjxNQFy4T7IBNR/LYDmSW28FdFz8qzky8jK++1ShFFABpLLi2KIervA2Bq7sJNn2dvt4LlI+ufNqq8KL4BXERu2WAaw9MDyigE7eDaUyb5uVilkAWqXPbY4tEcwM6Oi8hsd6h6w2JaoGfKYNNQfIeIr2wx6H1Xqw17rIT/W+EY8yv8ky3EHVHBtwV6GunZAsvyIu2b5pmVzHpdmBA65K4zJZimYlj0qyHZEbHQMy4wIdPsrHYby27X/BmmoJKhoYlwqM8MjevVZDZ1J5E+h+OLjEkCkrl7aGjFDmoDj2iat0pxTcO1iQDa9uR0lw4QHpc4ZAWIJzwx8/CQ4HUFfUMXymL4JzYiBbH/wLqlDKQNXb8HcVAAD6cByldKDw8cTeiNYbFWrjAE4p3SygQGJzS8vkTRHxXUEsOvOI1sIVQVAd67i8xdkadziOz0REIIGZibofBdjAu2PQcx9lwXbl8Qn1Sz1HNn4KpYbvdVPRntp8s43KRKge3YpejptCY/8wUfiGXfxyGM1h1uwFhH
 HyMk7SBS
 ALXWvgy9g9LRW+b2KaqyRLtuXCWPszvyKH6zR5m9nfHl8c73X+eBNVd9sgkS1IHQZD1wdgkyTnIDkBy+oYAACwH21Bnz9cb9E8PEcr8XVYsfKsJY6NCjRiDArCj939wFSh1Ui4VoLzgYIxZcgZDEvEwTukb/beSSiM7YGIV1JIHL3UiPNaO27S+e0ttp9q6q25kwbkKl6orQor/HUD7RUUl9EMcqRZJPwbGLYBVk96wNQdYYEjHbHygo1xA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22 2026, Mike Rapoport wrote:

> On Tue, Apr 21, 2026 at 12:20:27PM +0200, Micha=C5=82 C=C5=82api=C5=84ski=
 wrote:
>> On Tue, Apr 21, 2026 at 8:08=E2=80=AFAM Mike Rapoport <rppt@kernel.org> =
wrote:
>> >
>> > On Mon, Apr 20, 2026 at 03:11:03PM +0200, Micha=C5=82 C=C5=82api=C5=84=
ski wrote:
>> > > On Thu, Apr 16, 2026 at 6:13=E2=80=AFPM Mike Rapoport <rppt@kernel.o=
rg> wrote:
>> > > >
>> > > > On Thu, Apr 16, 2026 at 05:06:10PM +0200, Micha=C5=82 C=C5=82api=
=C5=84ski wrote:
>> > > > > On Thu, Apr 16, 2026 at 4:45=E2=80=AFPM Mike Rapoport <rppt@kern=
el.org> wrote:
>> > > > > >
>> > > > > > Hi Michal,
>> > > > > >
>> > > > > > On Thu, Apr 16, 2026 at 01:06:53PM +0200, Michal Clapinski wro=
te:
>> > > > > > > @@ -2262,6 +2253,12 @@ static void __init memmap_init_reserv=
ed_range(phys_addr_t start,
>> > > > > > >                * access it yet.
>> > > > > > >                */
>> > > > > > >               __SetPageReserved(page);
>> > > > > > > +
>> > > > > > > +#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
>> > > > > >
>> > > > > > No need for #ifdef here, there's a stub returning false for
>> > > > > > CONFIG_MEMBLOCK_KHO_SCRATCH=3Dn case.
>> > > > >
>> > > > > In all 3 places the #ifdef is there because MIGRATE_CMA might be
>> > > > > undefined. I already broke mm-new branch in the past because of =
that.
>> > > >
>> > > > Hmm, that hurts :/
>> > > >
>> > > > The best I can think of is to add a static inline in memblock.h an=
d ifdefs
>> > > > around it.
>> > >
>> > > Sorry, I don't understand what you mean. What would that static inli=
ne contain?
>> >
>> > Something like this:
>> >
>> > #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
>> > static inline enum migratetype kho_scratch_migratetype(unsigned long p=
fn,
>> >                                                        enum migratetyp=
e mt)
>> > {
>> >         if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)))
>> >                 return MIGRATE_CMA
>> >         return mt;
>> > }
>> > #else
>> > static inline enum migratetype kho_scratch_migratetype(unsigned long p=
fn,
>> >                                                        enum migratetyp=
e mt)
>> > {
>> >         return mt;
>> > }
>> > #endif
>>=20
>> How would I use it for this code?
>>=20
>> +#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
>> +             if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)) &&
>> +                 pageblock_aligned(pfn))
>> +                     init_pageblock_migratetype(page, MIGRATE_CMA, fals=
e);
>> +#endif
>
> Something like this
>
> 		enum migratetype mt =3D kho_scratch_migratetype(pfn, MIGRATE_MOVABLE);
>
> 	        ...
>
> 		if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)) &&
> 		    pageblock_aligned(pfn))=20
> 			init_pageblock_migratetype(page, mt, false);

You can optimize this a tiny bit by doing something like this:

	if (pageblock_aligned(pfn)) {
		enum migratetype mt =3D kho_scratch_migratetype(pfn, MIGRATE_MOVABLE);

		init_pageblock_migratetype(page, mt, false);
	}

The kho_scratch_migratetype() you suggested already calls
memblock_is_kho_scratch_memory() so no need to duplicate the search.
Plus, this way this only executes for each pageblock instead for each
page.

>
> seems better to me than ifdef, even though MIGRATE_MOVABLE is bogus here.
>
> And since we anyway changing init_pageblock_migratetype() callers in
> mm_init.c the entire block in memmap_init_reserved_range() can be dropped
> and the change can be done in __init_page_from_nid().
>
>>=20
>> It doesn't invoke init_pageblock_migratetype unless pfn is kho scratch.
>>=20
>> > Can't say I'm happy about the name, but could not think of something
>> > better.
>> >
>> > > > > > > +             if (memblock_is_kho_scratch_memory(PFN_PHYS(pf=
n)) &&
>> > > > > > > +                 pageblock_aligned(pfn))
>> > > > > > > +                     init_pageblock_migratetype(page, MIGRA=
TE_CMA, false);
>> > > > > > > +#endif
>> > > > > > >       }
>> > > > > > >  }
>> > > >
>> > > > --
>> > > > Sincerely yours,
>> > > > Mike.
>> >
>> > --
>> > Sincerely yours,
>> > Mike.

--=20
Regards,
Pratyush Yadav

