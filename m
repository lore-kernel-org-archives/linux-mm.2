Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5503AC5AD05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 22:48:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5B86B00C5; Fri,  7 Aug 2026 18:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 858166B00CA; Fri,  7 Aug 2026 18:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E1FE6B00CC; Fri,  7 Aug 2026 18:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 269856B00C5
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 18:48:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C840A1AA3
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 22:48:40 +0000 (UTC)
X-FDA: 85075964400.12.EC2E697
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 88DE740008
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 22:48:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S21A627c;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786142918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LmNeZTISm4dLEnsu3O8xB8HmuUBCWK629nXCPU+0hSw=;
	b=VwCLV7eAOW405q3hWbx7IYFO+aM6Pqe2G8fZB/B0fX83Pb9rmvjCbvwcOJbqR8oAVBG7Ru
	sKwaosuHWnvF9rtpJokv9T7BzsL0FbJ8Ybapwzy4iedr+5GCxvxHRSUeoflEDUCCbcJ9Fm
	IdhwCRuWfqOVNiczeqC0uVs0X3NWD5Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786142918;
	b=6KHJla3QwirCD+SHo+rKe2wOHmIQpXWUgsEIp74FTm81hv7JpnqeJU7Dos9DlJuJM9/V/R
	MC2yh9xtECj9eWIaKT2GnuSOf7VGe50D7x0MIzFskRUSm4sPMFWknDRIkKWQLBRZzoxsw4
	kCzK9xQDTWd63Lx6DJAEhk+tc0/cYLI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S21A627c;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 61E4743E28
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 22:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2B71F00A3F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 22:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786142917;
	bh=LmNeZTISm4dLEnsu3O8xB8HmuUBCWK629nXCPU+0hSw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=S21A627cFCsAwZSeHHhcAtfFm8vNp0ujJ2tThewmV9YlcjfPqzEFNaMh8Cl7uOK5Q
	 17G+/7NYhpm1fgnLwgMOPEaiOU7dW8jGSluvBWhp6o2XLLRz3sjwbIyhaBiBvQuYUe
	 +2S8u5vTGJwwWu5nczSAGxr+DwmFisMBQadXJM6b6ZMseVYTai4Jy4c8i1XrWUF68C
	 udicsGUz6Tbd+jiqa+yriRxASNGpuA8qAP7JwE/rKubvqJ+uGAa1jYuT7YPoM38QKw
	 p3b1QLGKBDoC+aIr17OLIRXenjdybqaihgADDAvr7lzdwitDpEWHFtwIBtpd7nOOlK
	 WbItE3shV3vmg==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c197eaaab00so598527266b.0
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 15:48:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqRnJAb+4GYueLL4C10I78aY4aVwXJrTVvghsnxNz9ndQFnT1G8MZeghLDf7bF6xmgK64LeYXZHEw==@kvack.org
X-Gm-Message-State: AOJu0Ywgr0BMLw/cgvi2VMo58njkau7s2qBiBALeNE10LXKUcBxQqdtl
	+/s9MaSaTGg6f7pNA06M/6uKyzSsopfwDqIhtQD1AU6D4ehCF6HAYMEjIfLKycQx9LgHBaZWAQC
	bUU1OL9TYvrlaZADajuaSCNmvwAoUIp8=
X-Received: by 2002:a17:907:1c1a:b0:c20:3678:c6c2 with SMTP id
 a640c23a62f3a-c207ed3243fmr390876066b.22.1786142915828; Fri, 07 Aug 2026
 15:48:35 -0700 (PDT)
MIME-Version: 1.0
References: <DKCQZ9JTKRIO.1K61106YF38GW@linux.dev> <amz0jzVPZo_eBeRV@google.com>
 <anUgqnHKShicIK7C@google.com> <CAO9r8zPk-X5+NmtKm5pvPD=zhrDDAqF_2h-a9-0=5-+CVEnUNw@mail.gmail.com>
 <anUkfHGqI07cgSHG@google.com> <CAO9r8zPBdjxPTMCeaLdeFeH=9Ybb8wn6KJZ6x9t=o5DyXdEHwA@mail.gmail.com>
 <anXrH_6oQTtDxzX9@google.com> <CAO9r8zMr+bi95MzG93cPkVmDUzmHYt0obM_niNOyhFLqgcA_Dw@mail.gmail.com>
 <anYospX_XhVDHNGl@google.com> <CAO9r8zPTCjJdUKydhej6h0fV9rbpT5WFjfyVSXTbvaGs9XbX4g@mail.gmail.com>
 <anZfv81jLSU2qY9G@google.com>
In-Reply-To: <anZfv81jLSU2qY9G@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 7 Aug 2026 15:48:24 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNJ3mSRf5YyRQYYW-eM2eiFvQMXW4Rh0cT=31jsKZpuSQ@mail.gmail.com>
X-Gm-Features: AUfX_myhDJUP2HPAHfpy4BYbLEB7CJHfzZSIAeqtgbwPSnYMvnETnbwMX6uUmLY
Message-ID: <CAO9r8zNJ3mSRf5YyRQYYW-eM2eiFvQMXW4Rh0cT=31jsKZpuSQ@mail.gmail.com>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
To: Sean Christopherson <seanjc@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>, Brendan Jackman <jackmanb@google.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, 
	rientjes@google.com, patrick.roy@linux.dev, 
	Takahiro Itazuri <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Nikita Kalyazin <nikita.kalyazin@linux.dev>, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 88DE740008
X-Rspam-User: 
X-Stat-Signature: 5ks9pf557ki85wd9a5mdawfjq3ycwwo6
X-HE-Tag: 1786142918-53822
X-HE-Meta: U2FsdGVkX192KUg/iZkm9HyvtO7EEuMap3Rma1H2t/Wj6gAcYhDw12hjkWs1lcef20JiXfhka8Cz/XISRpkQUAytKlj2Ph0SOBrkxiAjGkt/JX7x69Wbhe55D17wyaMcpn/h6BoQmqXsEbBvykQV4FrCq3IgBMovVj9fGJ0w3Th+jmrDgbpOvMrDMQnOlUE1jUcO71hyoisTUh4BLjXEJXZTF+YdGALNQiRpzA54tgF6m6634WUvSPFBtX75rf3/UjtwePE2ZuQnmTCS8+tjQFDCA1+msQozhnAfwI1d/qOa+5+l8xjRvCN9YkiLDJTVkM8Vts6y0cW6nd3GNkWMtpCSy1esbFdjfyEnp/m7dLe4SxSlC9vMgwPIYfEFyK22G66mLBAejnAEv2gVtmsSe/opcJqpWAzgvDa0PFy00R1KOa82FaD+CvxRbzwiftFoSkKRWQ6yg5nLpzyhA9bqyqGZLPVnK0glf9wGVfVjqIMc7VPODeppk0MalennWUmyjO5G0QkX6W251RotW97sAGaUDVTcS2ewko3qfovHcuhOqRT5BnOEBtgZUtK5NrdJhWnHFpDG1/mr0CV5Q+ZESL/obDl6IuSP+5krEGt/osQta3P4eL9ihC8GwwoBMT8bDuqrCjLcS1IFQCs+KPFImxdab5RXp1JGtaH9YZdDrrWOdistjlLtSUSfHmpQGc8M26p9FkjGs35+yf6Cj73flrF1qTASBp57jFfBjYTmB/ex0wlijA1VRH6sDVqJdlHDeE56vrKY8IEZzJ15GzwgbkDTw+VwHR+A3Lk6rQHpjvZFC9zMyMK5Ln4W43cSOkOgXm+BMPq5a/hDMEhoqaSCzu4FYnLJJ0cyjMohqYWB98kDcVVhj3Mcj7SHEqqg725jWYySZ27lGJlpZg+4LiTORTXa0FKLz2t+7VerWyaesYE5jU3nKWfsi5+7CSWZn48q6JocrcqWWrROrlU7EAb
 f4MwpEud
 QuowLwueBxePfPP4+ZPeHN6rkdo+GE2kozg0jnkfxEiry1nlm7flFxhym3YbLL6vKbZJm3ZbL/2uH3dQB69o+apSumrbo08oKQm7nrmUD82ROCRpAzfVORqYt1kERKzvHYGJVdvh4l6orfe4ur6fEP+6f/p5be4c2Xjw5y/8gVVMvR8tB+gQdFjy5cff4YTXT1FxD3pEKaVWvpTx39fau9ROOqio1K9JfRjHklW6hCx0mFo9ZwHvD/ctyDwApItGYnThj9UcvauMjpuLHplNyIgtxz1T3KuVqglyqj0LX3Iy6wkCeurGZmQG3jNE/aHpw3BJOSPkug3O69go=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > > Looking at [2], seems like the consensus was that AS_NO_DIRECT_MAP
> > > > means folios are not in the direct map, and callers are responsible
> > > > for establishing the mappings (e.g. using the mermap).
> > >
> > > I'm fine with that direction, but in that case GUP _does_ need to be disallowed.
> > > I.e. _if_ we allow GUP, then GUP itself needs to somehow ensure the direct map
> > > is populated.  If GUP is not allowed, then IMO the core kernel needs to provide
> > > an API to get at "inaccessible" mappings.  Or I suppose GUP could take a flag
> > > that says "I pinky-swear not to try and access the memory via the direct map".
> >
> > Okay in this case I think the simplest thing to do here is to disallow GUP
> > for unmapped pages like this patch does. Once we have a use case (e.g.
> > guest_memfd with unmapped memory using GUP), we can figure out if we want a
> > separate API or a GUP flag. I assume the GUP flag could either be: "I know
> > the page is unmapped, I will map it" or "create an ephemeral mapping for the
> > page".
>
> I'm not ok punting on that, i.e. whatever we come up with needs to land alongside
> AS_NO_DIRECT_MAP, or at least before guest_memfd tries to use AS_NO_DIRECT_MAP.

Yup, I meant the latter.

> The only way KVM can use AS_NO_DIRECT_MAP without GUP is with a massive list of
> caveats and addendums on things the VMM and guest can't do.  I'm not ok merging
> guest_memfd support for AS_NO_DIRECT_MAP with such a list.

This series is not adding the support in guest_memfd, just adding the
generic AS_NO_DIRECT_MAP and using it for secretmem. Followup work is
needed to plumb it for guest_memfd anyway, and I am proposing that we
also punt the GUP story to that (when we have an actual user).

