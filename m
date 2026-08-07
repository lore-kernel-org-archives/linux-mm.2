Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C22CCC2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 18:49:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BC0B6B008A; Fri,  7 Aug 2026 14:49:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86D2C6B008C; Fri,  7 Aug 2026 14:49:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75F8A6B0092; Fri,  7 Aug 2026 14:49:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 442756B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 14:49:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF051A010A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 18:49:26 +0000 (UTC)
X-FDA: 85075361532.02.0277BBD
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf29.hostedemail.com (Postfix) with ESMTP id 03A01120003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 18:49:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LnBC7rW+;
	spf=pass (imf29.hostedemail.com: domain of 3syh2agYKCDgmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3syh2agYKCDgmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786128565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s/JtcKWinUL6x2ni4/Rf+XfZdlo3vH7HPHxYmzRfVVQ=;
	b=gOuyevzP9/fd/c7vbCxGHBVffenVJ8m6a5VFGqkwyyzyws1e1hGVkuE/YTbcZsOk73sa1t
	uho4a0ZamqTXiD3oEJ/Stki2gn0t0xZniUwKJjW9dizNzBejP7o363mD2YBv12PHG4K/me
	onZFnn68ZD6imIn0Ci9XDCzpJMBZgrI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786128565;
	b=4IXzeay3IZcKbdNeb0Pz79tDAf7DFRWLwpYUkOjWrTajwH4v7gvosB9HI5zjF3sd67GSEi
	cax/GYve7LdHdiylMgubVfVREEjYlT4CYKEI6UoBr83DL1P3PA0E/b4Gx+tt+M2SxTEbrS
	zJPI3W97kZSuJxVtwPfJ+JA+Uh0AchA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LnBC7rW+;
	spf=pass (imf29.hostedemail.com: domain of 3syh2agYKCDgmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3syh2agYKCDgmYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cab048cdb3eso5041659a12.0
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 11:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786128564; x=1786733364; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=s/JtcKWinUL6x2ni4/Rf+XfZdlo3vH7HPHxYmzRfVVQ=;
        b=LnBC7rW+NgeatZk1ECIURuiALLR8YlfvdZXQHB1IZrihTHT8y/3EGoLdz/iCD2/rwm
         EJlsVjgYcEFVWDQSI42Y/tw2Xs5CG6rOW7r5//0EwYtk96DMLs5oX0D1V1X3nv5b0ni8
         LuLL6+ktmu/l6qBMOJuznBt1sEDqfGz+I50K08C7C5WdZQ7VpGxc5d8AgILcIML84iJl
         +Yn18yund0DPR/G0Ng67Q8NnKwkVx+K+E5AkZu7QTkzyycn4ENDYtHiagtDRU11h78R5
         bc6wKGPesZMfLo3uiiFosY0EQ1xawIy2jl3zCE01IuM+q+Pg2ipsyqasZQUHWzDVh04z
         j9Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786128564; x=1786733364;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s/JtcKWinUL6x2ni4/Rf+XfZdlo3vH7HPHxYmzRfVVQ=;
        b=nBUdrgvOAcke0ESPZNXVnlkJAOdhSUSrr6OSwuwnMid0HVs0eVDcsC7yKLYwsx+Lus
         3H3OsA0b12QLIF9NxfDeof+UKjdpK9GcyEA5WVRx6Nna2K5eRCIw66ALHKO6rVP24l9S
         jeO5k3l4bwzZi3Ci/NSQyiKb3J20J/F4iPdnO+BxjOqCRqItgZ4tPs1EQbACY68qMSmf
         mkvVAlAq8fPCGkOOokGs5B60tUHPzb6qTgyQyc5b2AokjKuIV9ccBwZrOiXtW/WC+HLb
         rHtrIFkYKQpDMWFaLhYjgZ5UqGieug1ygGj4P5QfBLE0DL698XnKU9dNWaxRlSMXXINv
         I6fA==
X-Forwarded-Encrypted: i=1; AHgh+RpWKFgSIRClkghfkATJzSPA8RYW/+UNySNLCRtQ2eBBcgGJsy0k+HKEn8f3jWcIT4Lv65l0CiC0RQ==@kvack.org
X-Gm-Message-State: AOJu0Yx+rRt0GfTe7a3huHG5QgJSXl35McFDlCacyopYC9BOXgwP3BRw
	sf72Svr10gTU6jSFd3ZMFOuHqwlNAbZxcyJA1Q4isuLxilHhGKrQerRTXwA/GsmwRr0D9R0ZW+U
	slcjMxQ==
X-Received: from pgla5.prod.google.com ([2002:a63:b45:0:b0:cbe:948f:d62f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f86:b0:3c3:a3fd:db0a
 with SMTP id adf61e73a8af0-3cb85e3be02mr26267852637.16.1786128563397; Fri, 07
 Aug 2026 11:49:23 -0700 (PDT)
Date: Fri, 7 Aug 2026 11:49:22 -0700
In-Reply-To: <CAO9r8zMr+bi95MzG93cPkVmDUzmHYt0obM_niNOyhFLqgcA_Dw@mail.gmail.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
 <amu5v-e39GKpgFG4@google.com> <DKCQZ9JTKRIO.1K61106YF38GW@linux.dev>
 <amz0jzVPZo_eBeRV@google.com> <anUgqnHKShicIK7C@google.com>
 <CAO9r8zPk-X5+NmtKm5pvPD=zhrDDAqF_2h-a9-0=5-+CVEnUNw@mail.gmail.com>
 <anUkfHGqI07cgSHG@google.com> <CAO9r8zPBdjxPTMCeaLdeFeH=9Ybb8wn6KJZ6x9t=o5DyXdEHwA@mail.gmail.com>
 <anXrH_6oQTtDxzX9@google.com> <CAO9r8zMr+bi95MzG93cPkVmDUzmHYt0obM_niNOyhFLqgcA_Dw@mail.gmail.com>
Message-ID: <anYospX_XhVDHNGl@google.com>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 03A01120003
X-Rspam-User: 
X-Stat-Signature: ecjexigjk4nzgijxoocctfitcya88zcs
X-HE-Tag: 1786128564-295373
X-HE-Meta: U2FsdGVkX1+5jBkleqMGWVYsCgHs+tZLcst/pUA5T3XXbXY4BdXqhaFZZca3csSyYG/7gW8qHxOJYsy5fRux6KD0szLFBA8ZYVuGBH4NnyW98NYN99vb7LmaUtt7sTFn4zI9s6o1V8Tty95S38cvXFjGreN5aTE0xy+kmzLaTnFaoKEF1FvQBiMncC2LUtzvznHqa4ahQYcYf/BSPjWtILF50RwOHqf/C/fB0q7V7UspFXBpERsQ6Fn55/dY5eWAKzcwXzQJ/9Z13qxeeHXlCSfHNwLOU3HA2owzJhowiVq39D6H3+WR3kaP8JU7dlM3TmosbFtFYUp94YYbaWfu0W3P8Ri86/nkn4qD0HZ9VTfSDopY3BkW/hBoZZ+v5MrdayYNwqqjGjNTIKN3Cgyr4Wv6oHNd1yjFVDKnR3o0EuZFSGRGtFiw8VAkzW/j+MZx06Q4LoLBgN9Z2WAtpdtCKuuxBn5UmuqkCLsJrLTTKsYrvwPEfcDNqCibc/Mo/7qFS20vytunP3zjz4n35o56EhbwOh3GTvG1OhLuCcpUbcZ2ErzD6WzyEO57L78HZmdcTluOZ+JNYfi1+0yhrz0LS3HRyP5u6RAOFXKtiIfCTzHMRLnFCXnB/hrot/n4qvJe9o21Vga3NSzRJzRR7nxYad+O2AExa2pQfjtoO/H0iBJnKAMSQ52jEcbn6M7nmdus8xtjictfSC0h9NOF0z12PL2lY9qLDr5/795Cm2anyymsfWY20s9HH/35rFcxmzpkaepNnimMCjBuse1srCz16QZngboH6Z3I+eJwVi285EQ1ckaaJXrx3kIcTv7ILmS644fiZBS7007UXYPJVQUxmD448LzDNQkH7+PGrETxNZuKxNamzzw2+Nea4MdIKvrP9OLy0II51NZDxM68+s1GYUwfeHmBE867WTFsoRut2s96Zc2GG0siWi/fy7ORqMUKJTm7jm0wepwNpuGNrmc
 kvPB+VKc
 SKFkBrRfyPe0F7RKJCuZS3o8r/EnJajXbzryDg0CXocHpzwYiDhl0HuKXQtiSDah46s3cE3S8Rq2eMBJfCiqbdRSH4fql+ac4H6KFheZkQsAEPWbgY3w+06VMoF0VLSltFUiiYzcGyJ4rpR6QPhY2oKzNE9Chy8p+jEBzJhJTILJtyDi4FdHbtX5ayK763uGAwF+onqgwKKLZcDUiKKyp9rFa16K8dmJvgvIjF/XkstQc/jqCreohDARoUeNuL0wZE4Q5DHsbNsvMEAIbD/qxOnFyPgzG6KIZgiTgjeQqa/QNyRohBwygpNjCgGBINS9vpIp1RR91+KZi3CXb3HjAaNL6ma13SWw6hIxd4mcCsfEXYGBcdcq7TIDjHHrAyEhc6Elo0RyZ3upnl7nrqcAW02u5n2i7vqyzNDT6wmE5v2dpW2wEpmzx80R/StxqpNoeQQdlEr2utGgVmnu8l3nksWoL1JpOIK6P3ym8dU5y8NNrvf7+IQIhgOY/2jkYXNDLXhO/gd8GRYkuAsmtXI/Mrd4cgImPeZ5p5JwJx2byYPeaOWfZLPr9SQEUulf+VIFVxgt8q6+Q4bW3rOE4m3jbUV9TO6Wd1r9WK2+jw1StfL/HvSNMvZ6JXrLcKP7HpqMAsqzBloTIMgVo8gXJ/zzzJG8mbIZr1SXWrIcrjxvKL59rmZUh26VXBCc70CRkFfJd5QjpSd6S8GbaK5E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026, Yosry Ahmed wrote:
> On Fri, Aug 7, 2026 at 7:26=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> > > AS_NO_DIRECT_MAP will surely make it a bigger problem, but not a new =
one :P
> >
> > Well, if it disallows GUP, that will be a new problem.
>=20
> Yeah I think we should check here and allow GUP on unmapped pages
> (more below). One thing that confuses me is that the
> GUEST_MEMFD_FLAG_NO_DIRECT_MAP series [1] seems to also have this
> check that disallows GUP. So I am not sure if KVM needs GUP to work
> for guest_memfd now (then how does [1] work?) or it will need it to
> work in the future?

Well, there's a reason that series hasn't been merged. :-)

I didn't get far enough to start looking at the GUP stuff, so I genuinely d=
on't
know if what it proposed is sane/correct.

> [1]https://lore.kernel.org/all/20260410151746.61150-7-kalyazin@amazon.com=
/
>=20
> >
> > > > > > At that point, userspace is basically required to
> > > > > > maintain mappings for all host-accessible guest memory, and if =
there are userspace
> > > > > > mappings, then not using GUP doesn't make much sense.
> > > > > >
> > > > > > Note, I called out x86 because x86 has the most extensive emula=
tor and shadow
> > > > > > paging support, which is where the isolated, one-off accesses h=
appen in spades.
> > > > > > Other architectures might be able to squeak by without userspac=
e mappings, at
> > > > > > least for now.
> > > > > >
> > > > > > So, in all likelihood, KVM will want GUP.
> > > > >
> > > > > Yeah I am thinking that the check here to disallow GUP completely=
 for
> > > > > unmapped pages is aggressive. Maybe it works for now if KVM does =
not
> > > > > currently have any use cases for accessing guest_memfd memory. Bu=
t if it does
> > > > > (or will very soon), we need to think more about it, otherwise
> > > > > AS_NO_DIRECT_MAP is not really usable for guest_memfd. Since you =
said KVM
> > > > > "will want" GUP, I assume it currently doesn't?
> > > >
> > > > Doesn't what?  Have GUP?  KVM heavily uses GUP, including for guest=
_memfd that
> > > > can be mapped into userspace.
> > >
> > > Your wording made me think that KVM doesn't currently use GUP for
> > > guest_memfd, but I was obviously wrong. So IIUC GUP needs to succeed =
for
> > > guest_memfd pages with AS_NO_DIRECT_MAP.
> >
> > Yes, though as I said early, it doesn't *have* to be exactly GUP, just =
something
> > GUP-like.  E.g. it could be a new API, if that's easier/cleaner.  What =
I don't
> > think is a good idea though is handling this entirely in KVM/guest_memf=
d.
>=20
> Just to clarify, you mean that GUP (or GUP-like) should work in terms of
> pinning the page and handing KVM/guest_memfd the pfn/address, but not
> actually making the page accessible or establishing mappings, right?

No, I'm saying that whatever API the kernel provides needs to ensure there'=
s a
valid kernel mapping (or provide one as a return value). =20

> Looking at [2], seems like the consensus was that AS_NO_DIRECT_MAP
> means folios are not in the direct map, and callers are responsible
> for establishing the mappings (e.g. using the mermap).

I'm fine with that direction, but in that case GUP _does_ need to be disall=
owed.
I.e. _if_ we allow GUP, then GUP itself needs to somehow ensure the direct =
map
is populated.  If GUP is not allowed, then IMO the core kernel needs to pro=
vide
an API to get at "inaccessible" mappings.  Or I suppose GUP could take a fl=
ag
that says "I pinky-swear not to try and access the memory via the direct ma=
p".

> [2]https://lore.kernel.org/all/aeemS2wm38Cm4qAf@google.com/
>=20
> >
> > > To actually access the memory, I assume the guest_memfd side will nee=
d to
> > > handle this by either using ephemeral mappings (e.g. mermap), restori=
ng and
> > > zapping direct mappings, or using a userspace mapping. I suppose for =
the
> > > purposes of AS_NO_DIRECT_MAP core support we just need GUP to succeed=
?
> >
> > And establish a (ephemeral?) kernel mapping, because general users of G=
UP will
> > expect that they can access the physical memory through the direct map.=
  That's
> > why I didn't want to handle any of this in KVM[*], the rules and handli=
ng need
> > to be kernel-wide.
>=20
> See above, I am struggling to understand where you think establishing
> mappings should lie. =20

Heh, I'm not surprised you're struggling, because I don't really have an op=
inion
on exactly who/what is responsible for establishing the mappings.  What I c=
are
about at this point is not having guest_memfd itself provide a GUP-like API=
: that
needs to be a generic kernel API.

> The current approach is that AS_NO_DIRECT_MAP just means folios are not
> mapped, and users are responsible for establishing the mappings. I assume=
 you
> agree with this (since you suggested this :P), but you don't want KVM to =
do
> this ad-hoc, but to have a library for it.
>=20
> This library should be the mermap. I imagine (for e.g.) kvm_vcpu_map()
> using the mermap under the hood if it knows the mappings do not exist
> and using the mermap virtual address instead of the direct map
> address. This only works (with the current implementation) if we can
> disable migration (or even better, preemption) while a mapping is
> active, which I imagine would be tricky or just not possible.
>=20
> The alternative could be destroying and recreating the mappings when
> the vCPU moves between CPUs, which is.. interesting :)
>=20
> I imagine we don't have to sort all of this out now. For the purposes
> of AS_NO_DIRECT_MAP (and secretmem AFAICT), we just need to provide a
> facility to allocate unmapped pages. None of this is user-facing at
> this point.
>=20
> >
> > [*] https://lore.kernel.org/all/aeemS2wm38Cm4qAf@google.com

