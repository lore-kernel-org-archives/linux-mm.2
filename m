Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29D26C5AC67
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 00:30:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D620C6B008A; Thu,  6 Aug 2026 20:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11FC6B0092; Thu,  6 Aug 2026 20:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C01936B0093; Thu,  6 Aug 2026 20:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 831C46B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:30:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F1F5402B0
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:30:14 +0000 (UTC)
X-FDA: 85072591548.17.ABAA2CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6F6B240009
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:30:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nzLe3efx;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786062612;
	b=4VIIdmAd3z1hufpb5kackLX3nwNy8+HZkGF+Fym89CM0z+29dG5aISoDH/e8CrMS8uA+Tv
	84MpoDYXWCZquTcsH6QoHYpUZdXRuBLuXjcgGKAZoroyKtGz/4PuOvgYRZeQpYt/7Bi1WJ
	T7nlP/5iwozISIoQ6N3yzfZ13C//tEQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nzLe3efx;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786062612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5dLBOvMM+4Mx7Qb7hew5Cw/DIaqxpSNUYZ+MD+vt8fk=;
	b=jwFy5BPeimhkiJy0Hy5abytjDdpws/xiZvHEl+ANJSuYvy2O0Dg9qswBIrt/G71p8t4k5p
	AFjxHSloepNvCXv4YTukXD0kvfN8SfVKhckmV9fKSfTxxXvcagF4sg8SeW0ZtzecocQnru
	ThUpsYwxARnuvu3zFtoSyuJRLTsDFw4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B6D44402A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633E11F00ACF
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786062611;
	bh=5dLBOvMM+4Mx7Qb7hew5Cw/DIaqxpSNUYZ+MD+vt8fk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nzLe3efxhOKwmpzBF8Mriw4Ave3LPdezn6CIDidjdWidx2x/Goru9xh/HBDNKOkd+
	 WuaXIYHmJr0mOMj8/jCWWyBtbNsa9gT+khfN+ATxFj1/r8+LqlPBW3KrN2oKpCuUnS
	 Q9/QP4XfgBR3h7cUsTWCt47zKvDIHxiUqfSzQVRdh52PnDESxX8JHK29ZvoooetRWJ
	 YC+IA5B33mf7JlbAWiEhOmIZ9bnG0d5IZzTrGNi6jvvOlF2idiXP1zEBACmj5JqhC7
	 jgm2ZBqAjjZzZ+ouDd4xmO0dTyvdgoZ0MtxoA0+41BSdlY59fkiZSgJVhOLEL+90tt
	 7eZ7smYXdBQeA==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a0a4a18180so4296422a12.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 17:30:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpjpIguqD1KnATCtT1HBSiIjBHG/XIeX9F5FyPSvB4ntw2tYl+vVo2PO34c8Wz7v+o867EIcSBNSw==@kvack.org
X-Gm-Message-State: AOJu0Yxodh1fIllFY9Xm/l8pQjg7wk011iv+qKR6sT3H+mzWmBq3LyYq
	AYDCnHyIY+om8DFxlupGlNIn/RY78ueM4zeufbpHsi1z3l5mECs4pQe3G1QL30Ur8WDnDVEofrH
	3YbCBU+AX380DBonKChJ+WQXeZxFUOYg=
X-Received: by 2002:a17:907:809:b0:c12:83da:7eeb with SMTP id
 a640c23a62f3a-c2039c392c6mr904548066b.19.1786062610173; Thu, 06 Aug 2026
 17:30:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
 <amu5v-e39GKpgFG4@google.com> <DKCQZ9JTKRIO.1K61106YF38GW@linux.dev>
 <amz0jzVPZo_eBeRV@google.com> <anUgqnHKShicIK7C@google.com>
 <CAO9r8zPk-X5+NmtKm5pvPD=zhrDDAqF_2h-a9-0=5-+CVEnUNw@mail.gmail.com> <anUkfHGqI07cgSHG@google.com>
In-Reply-To: <anUkfHGqI07cgSHG@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 6 Aug 2026 17:29:58 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPBdjxPTMCeaLdeFeH=9Ybb8wn6KJZ6x9t=o5DyXdEHwA@mail.gmail.com>
X-Gm-Features: AUfX_mx7kGRuvAxBMnmJp2BsT8sNQJoWhQpZUawtsCAsOxwOqRY3v3SS91gFTCE
Message-ID: <CAO9r8zPBdjxPTMCeaLdeFeH=9Ybb8wn6KJZ6x9t=o5DyXdEHwA@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6F6B240009
X-Stat-Signature: cknw84zg3jsaeyo4mceqri5ih3cz6pno
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786062612-781657
X-HE-Meta: U2FsdGVkX1/w4n56LZnkpxCUIBI9E1E622v4qi0HmyweiYwzdy8KFx3wnC+l/oK4jWbGHX28c3iQ4Dqr3gacUvHXf/9qX2n0uBnwUE/uBeWEEvcex8+GFcurnD7N7kZp52g7Wb0xCRIS1y5E7E2SRYsyAXhWPT8ON2iWeGEOcp4Pn2sa1ds/tg9e0vZjUtDvdlXj6nwNmf2/P45u7sOMczZ4zJESQfM4gDIR5SEMP9ZlzjRsCUQw0U9mUnFAgdLFcTOT/A5nUkU+zIO3dUqbv4ArUuJQTLxZouudhe5qesL4Zbp2/2d6g7DLmkOX2LTuQlmtHhGbATBmSzL7pEE8NPjw05rp2aVhfzdhhABYNR/THHb826HwaOybK0te0y3Wx/Lb+OlPSlJ1Twj+PF87vsUQHOEAfbbiP3+iiXDOr3a2vJsD1aCEgXFBxoVpJmHtJpXiDjkLmK6ijvVQ5aJTdmCIp0Dd+d16JE6U/0sZo+yD4j35Avt9Irf419Q2r8cXnRkQ+9OwLC9QTVVag1+vHq37+siMG1DLZ/CptenufLhleCMR1NQdLLpE8iW0Nc3hNlcWZZsaxWZD4lwEHOuS7e39j+PGKF918UGsl/lpQzaCm5as1o3iTqkYa2ERSIMwf0Q58iOBmgEQ+lyb7faQt4KQid87v3lWrDbB62QifJ9x/En3o/LxknDZa2wi6DB3CkN+hC7EX6tCevRDd+KPnxLCo26fVaaJUr8RXfl2zSB9vfJ1bLT26194tLwauXwlyzLo2a1DJPFhFMau06gdRPTep6mF3oNj9PJryRV3ysg6NU3sEQoDWQ+dK6dyNFkdOvrj5koEQn3iBOQuwHTWjiPWPtdtSaKIM5KOsq7S4L7O0IM84nNaJ/ZgnwiohKwKYG7BsEV5cR2sxzfOA4aoB70t6ZC4NSPY8hj0js55JG2ygcPB4GhXP0PJdbTKFmnTv4FxjMU15Sf8nvshRVm
 vmL8iWG9
 xN+vsQO44ko4Bj/QGYjZ68mnNJmho6yYmJpfLRND9qwWOmaafZ9QGhZ5ZfQScrMW1dxASVA93desevKVH0L9NFZGhBFk++Eoz7y67g2N7KGeti9wOYBX35h8332rrDRg6/NgZT6J+hjg6pxpCHWX0mwtjyDeWV+GLYiTzYvIfRyOI6Ir/ASNhjRJ/2ldj19oT411nIdYDfKOH2DJWJ1lfCYGPw0ZrqlwWUVPtJIXLhPJLbzrcGN/XlkkSD6fBrpwEyZkdmtgFdr1Ja9EnGGgyQHPsMWfgwE7/qimu2Wg9ttuO9qDqk2W9XZ3bAF8Q0t3tuOPdYsAo7oUOM1VzS0JFqktU/1rmcDVHmWijcMcN4yWBR0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 5:19=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Aug 06, 2026, Yosry Ahmed wrote:
> > On Thu, Aug 6, 2026 at 5:02=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > >
> > > On Fri, Jul 31, 2026, Yosry Ahmed wrote:
> > The mermap provides infrastructure to do this, but I think the assumpti=
on is
> > that mappings are short-lived. Keeping mappings for the lifetime of the=
 VM
> > would probably need more thought. For example, migration is disabled wh=
ile a
> > mapping is active (as mappings are per-CPU), and I was even proposing
> > disabling preemption (lol), so that wouldn't work at all with mappings =
that
> > are kept around for that long.  The address space is also currently lim=
ited
> > to 2M per CPU per process, which should be plenty but could also become=
 a
> > limitation.
>
> They don't _need_ to be kept around that long, but I'm skeptical that on-=
demand
> mapping will actually work for KVM's use cases.

Fair.

>
> > >  2. Always access guest memory through userspace mappings, i.e. throu=
gh uaccess.
> > >
> > > #2 sounds nice, but the problem is that it effectively requires hand-=
coded assembly
> > > sequences for anything more complex than basic load/store operations.=
  Which isn't
> > > a complete non-starter, but it's a pretty big blocker.  E.g. see the =
mess that is
> > > record_steal_time(), and then imagine trying to convert something lik=
e
> > > nested_vmx_prepare_msr_bitmap() to use uaccess.
> > >
> > > So, unless someone comes up with a clever idea, KVM will need somethi=
ng GUP-like.
> > > Strictly speaking, it doesn't necessarily need to be exactly GUP, bec=
ause KVM could
> > > poke into guest_memfd directly; KVM would "just" need to manually tra=
ck its own
> > > mappings.
> >
> > Ideally we can have shared infrastructure for this (i.e. the mermap).
> >
> > > But on x86 at least, that's not really a viable option because it onl=
y
> > > works for map-rarely, read/write-many use cases.  For one-off accesse=
s, creating
> > > and destroying (very) shortlived mappings would be too costly, and so=
 we'd want
> > > those to go through uaccess.
> >
> > Not necessarily (I hope). I think the mermap pre-allocates page tables
> > (or some of them) and defers some TLB flushes, it's aimed at
> > short-lived mappings (e.g. for read() syscalls to map a file page,
> > copy to buffer, then unmap).
>
> I highly recommend testing shadow paging if you have aspirations of repla=
cing
> the get_user() in FNAME(walk_addr_generic) with an on-demand mapping.  I =
would
> be (pleasantly) shocked if dynamic mappings can provide acceptable perfor=
mance.

Oh I was thinking of existing cases where KVM uses kernel mappings
(e.g. kvm_vcpu_map()), as these are the ones where KVM uses GUP now,
and need to work for AS_NO_DIRECT_MAP to be usable. I assume the
get_user() calls are already a problem for guest_memfd.
AS_NO_DIRECT_MAP will surely make it a bigger problem, but not a new
one :P

>
> >
> > > At that point, userspace is basically required to
> > > maintain mappings for all host-accessible guest memory, and if there =
are userspace
> > > mappings, then not using GUP doesn't make much sense.
> > >
> > > Note, I called out x86 because x86 has the most extensive emulator an=
d shadow
> > > paging support, which is where the isolated, one-off accesses happen =
in spades.
> > > Other architectures might be able to squeak by without userspace mapp=
ings, at
> > > least for now.
> > >
> > > So, in all likelihood, KVM will want GUP.
> >
> > Yeah I am thinking that the check here to disallow GUP completely for
> > unmapped pages is aggressive. Maybe it works for now if KVM does not
> > currently have any use cases for accessing guest_memfd memory. But if i=
t does
> > (or will very soon), we need to think more about it, otherwise
> > AS_NO_DIRECT_MAP is not really usable for guest_memfd. Since you said K=
VM
> > "will want" GUP, I assume it currently doesn't?
>
> Doesn't what?  Have GUP?  KVM heavily uses GUP, including for guest_memfd=
 that
> can be mapped into userspace.

Your wording made me think that KVM doesn't currently use GUP for
guest_memfd, but I was obviously wrong. So IIUC GUP needs to succeed
for guest_memfd pages with AS_NO_DIRECT_MAP. To actually access the
memory, I assume the guest_memfd side will need to handle this by
either using ephemeral mappings (e.g. mermap), restoring and zapping
direct mappings, or using a userspace mapping. I suppose for the
purposes of AS_NO_DIRECT_MAP core support we just need GUP to succeed?

