Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B8A3C5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 22:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F14756B00C6; Fri,  7 Aug 2026 18:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECBF96B00C7; Fri,  7 Aug 2026 18:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D67286B00CA; Fri,  7 Aug 2026 18:44:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 880C76B00C6
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 18:44:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D27E5A0153
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 22:44:19 +0000 (UTC)
X-FDA: 85075953438.29.66ABAC4
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2DB8640004
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 22:44:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vlq3BRZw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3wF92agYKCLMlXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3wF92agYKCLMlXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786142658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FCIAdlKPQC8LVh2CNqE5/NqRnErFXsfFV6IWU+8zDG0=;
	b=Ay6S45PycdP2z1AR+0K7eUiuSHZMS4LT5+tLIIzzO7lsax10s/pB2vBzFXNZyYraQDGvHM
	L83h8Sp+FjEzvd42xdYeGswAPIMl/FyZfeOvlwEH5NjPci8sqF3snxFBo2XZZFHjIWVmHL
	KU1hp05QGx+Fm4hXRtV8QrpSSOaGGOM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vlq3BRZw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3wF92agYKCLMlXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3wF92agYKCLMlXTgcVZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786142658;
	b=kaSAKtwDKfksn+QDidXCpirwpG2k7ZgpTYxaU5okAfkkxHrFILnGfdsUSAALrrG0glSeRj
	+q9xW37k6OcrPoSAb+vP3Y6iIc64K+9D8yKYmZxscjILUPHbyv4xegKmzMLDRpF3UKQ7Aj
	D2j+QTnO/3+x+ThN2D+SI5sIkgmj4q0=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38f57e31b6eso47073a91.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 15:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786142657; x=1786747457; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FCIAdlKPQC8LVh2CNqE5/NqRnErFXsfFV6IWU+8zDG0=;
        b=vlq3BRZwKPt5NhFp9/xHIbjeVchpPL/I0xJThMjh0JJnc5yoJrkzPDu1291ACtFGmx
         kj3GghY3iaATw7suCbEA69UIWecm3cai93Zvp/lRA4eNcd6qR8wAYJ0B3Y6AdZAIqf37
         lNv1HuJRIzu4SutpJlUSvuZW+Jjte+3JFQq7VUx6RLEA6yr9SCW/x9LsxJwqfDb7/hx3
         gUmsK+VzNi2ervgWwvRZ5ni4iCoCieIGFPJGr0sO94eddIaAN3fW8vPv1j5g2HSuGsMX
         FIL7oOKSVGAuemP2fGx+Rum9mPVbQvHklre0n8/kiHOtVI33OE2zfBlGZRSyQvMjD/jB
         xLvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786142657; x=1786747457;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FCIAdlKPQC8LVh2CNqE5/NqRnErFXsfFV6IWU+8zDG0=;
        b=a8hfnEHxe2JBnFekjlIxSOq7V/Cj59XvgdEYqMYy+3X+WA73FH/m9o6OqtPlymaFc1
         a0EYiA1rtquQ59CLaRVn3399KKKfFBBXFKtrGfKvcghj8qLWSWU8TU/NdiapQYYyh6Ty
         DVOAnJiqjJvjW5h534+tqVzlVB9lrwhKZ0NJtC4UTX1Z/k80sKBf0e4DPZnICW0236Ti
         LivkU0vfI2Cc/N5sjoQncG0sWJa3+WrdL1tl7F2H7Z6eQdfYzuoYv3vUVVNLgk0axk9A
         X/VzNtgzbuWac7R1THttEHAf7Y9iAL4kmZqto2KM/f3qRHm/+EQqp2bzSLMX0mA0C0ZQ
         iDgA==
X-Forwarded-Encrypted: i=1; AHgh+Rr2KKZB9pYbJnyWIehwV0ORplh/TJTTWuFLlAV+ApmD7o//btoo/qPqsWvskTp0pC8CTA/0kYmYVw==@kvack.org
X-Gm-Message-State: AOJu0YxMxozMrxOn4zfTWJW5w2fFuVsId1U6RaL/zu5Bi5+72vZifLf/
	sdWf+mBSzLbOes8A3KwmkPaIeZdh/UJpyH8n2rhAmohoVHiZLRuuMCNfwGzKT9C0CmqOV240dmo
	pAdbQpg==
X-Received: from pjrq16.prod.google.com ([2002:a17:90a:b990:b0:38e:6cdf:217a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5683:b0:381:26f:8f05
 with SMTP id 98e67ed59e1d1-3903c5380f7mr25970788a91.3.1786142656515; Fri, 07
 Aug 2026 15:44:16 -0700 (PDT)
Date: Fri, 7 Aug 2026 15:44:15 -0700
In-Reply-To: <CAO9r8zPTCjJdUKydhej6h0fV9rbpT5WFjfyVSXTbvaGs9XbX4g@mail.gmail.com>
Mime-Version: 1.0
References: <DKCQZ9JTKRIO.1K61106YF38GW@linux.dev> <amz0jzVPZo_eBeRV@google.com>
 <anUgqnHKShicIK7C@google.com> <CAO9r8zPk-X5+NmtKm5pvPD=zhrDDAqF_2h-a9-0=5-+CVEnUNw@mail.gmail.com>
 <anUkfHGqI07cgSHG@google.com> <CAO9r8zPBdjxPTMCeaLdeFeH=9Ybb8wn6KJZ6x9t=o5DyXdEHwA@mail.gmail.com>
 <anXrH_6oQTtDxzX9@google.com> <CAO9r8zMr+bi95MzG93cPkVmDUzmHYt0obM_niNOyhFLqgcA_Dw@mail.gmail.com>
 <anYospX_XhVDHNGl@google.com> <CAO9r8zPTCjJdUKydhej6h0fV9rbpT5WFjfyVSXTbvaGs9XbX4g@mail.gmail.com>
Message-ID: <anZfv81jLSU2qY9G@google.com>
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
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: abcssjb7hxb8rfoztexw1uh9ohp8dxdf
X-Rspamd-Queue-Id: 2DB8640004
X-HE-Tag: 1786142658-186225
X-HE-Meta: U2FsdGVkX194rQYVTqIbOOhbBPVQxhwQ0qvdg7aZBkiPM3bIoSJuO+42ezWGAgcjO5Lfcw1t74pkK80GdZ+tqYFKMf7OcrCBP/dawt//lnF0Si5lOmedflni9rRO3RwrvwvQr1uJwl6DllUjIXPAgPEJPnL2gvXLimRpcogrMErxLDLCNnobcjt3UK9FoaiLQH+gep3E07hV/jjb0VdSnQT1HrgqBbGpmFR+wCzazstj+DOrTr4p/eAsg6d9ZzdYdnTrL97FSbV64aSMQdGp9b9e8OpNDzWu1jEk3rtnpZlNZdp+jcNCjzIkYNHMLa/xFhLIFNQh7BqytQe+PnewcsuMGP0lliCQgDEmFQ+kPoeJu4J5z1L+HFvevKL9BfhZ0yjTq7q5IEkbPebqSejfJNRS9aLYU99ad4BwycgAUDMB38yFeWf2sfU7ckaNmI1vf+L0agKzBmWTdjWS8a05HcHTvzRQjXFBCCHg5bo8rISmOysaKoJAejWmok5YYMxU+28T+dOZ9iYrqxpf+Dl6OfW4Q/9BlVKigIOqAz0lIz3YXNfemn41tFPcfcgwEL0tpjQjqGWc11Fd4PiT+ac9OHTvxoKTEJP0YOVXSFck2CAoEa3p4ISbUAlFlqrEF2C9/QMKkx7ybl6w/qLU/6Q5lubaI+aDRSp8mXtTBbPLAAP0qYx7RBVQbl6iCM9TDLyb1r1ivUNEmKKYBtUCEkUFhAEeF4WRgl4W8ugtntbRi9H9H7MVthqxBZKPfuDfRVH3vYR1dDQY3NDHhbscHGj1V0UKUJASM/I8DipcTHiDMVZqAnm89MPMJ+JxmUgpQ1x774w1BkqMbM/6Afrz1jO8kNIap5GHIERab6NGr8hiIF4/ec3O0Q1+Jb/xhc/AOnmi8fR4YHsyceQNU1LZMAVnJDSbT8MenvtWa8fvXfQMFPqY10VDq5NK06BK+7qHus+MSdM/0g+Oufq8YC2Wmud
 a32GEX4d
 mKrP1nZDAzFE7J+mcZF+J+AE0J3c5eS4rSp1QnexZBYX+e4grk4sl8+nRVFyVHAzhFgK3047JPojqtYdwVDBpRp7kWF0kstCi1E+aoHxj9jP3jk6VwgN0zG4g8w9wXE2uSh3RROTRASkQJFQvaG3ENwHzozUa5mjXFGSIVpFlMyYdEdtyGWVAsDtM9jqerMQ3ISwJrdN92m03ewNr85O6bHyHnGUD0DEwZiiAq0KJWk8y+14GMo0m3IvVWmtOQKqQcEjT65j5HgLsfOOZjZu/d47i+dLuebKiy6hJ5h1Xb0Iplr+AohBHEj8Ntq4Nlkf0QAujaD+sImuS3QDcsnURjuq1utBvvyeU34p4Qtyxo2O2ApBZj5z1X2lP6gwLbSEbtrXkOVwrHWwS+t2EtDJdrSN95FuEPkcnu16vrJ/sUcN0tqJrmPf+QGHunOA0p59DOmY9rbKvMVgV4WIdMaaz/6Kthtp/ZXquDxKQQBS7OvgloGG5ARq45ZvGCuFhQrppWet8aJ8mwSi+izaXfdR6uj/ECujQ12C+WTJe24nOYUXhHUElVMDFmPbi/FveBwXLAub6Q3LS8D825OgxeU6knj1fWexDaq0qWg1yfG9wjiKcE1vJJs09ZtUogkDysRZYL8ER+hn3/BP1ldq6FDL+qPnhMSmcKlUetKZj1a1T9LtgysM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026, Yosry Ahmed wrote:
> > > > > > > > At that point, userspace is basically required to
> > > > > > > > maintain mappings for all host-accessible guest memory, and if there are userspace
> > > > > > > > mappings, then not using GUP doesn't make much sense.
> > > > > > > >
> > > > > > > > Note, I called out x86 because x86 has the most extensive emulator and shadow
> > > > > > > > paging support, which is where the isolated, one-off accesses happen in spades.
> > > > > > > > Other architectures might be able to squeak by without userspace mappings, at
> > > > > > > > least for now.
> > > > > > > >
> > > > > > > > So, in all likelihood, KVM will want GUP.
> > > > > > >
> > > > > > > Yeah I am thinking that the check here to disallow GUP completely for
> > > > > > > unmapped pages is aggressive. Maybe it works for now if KVM does not
> > > > > > > currently have any use cases for accessing guest_memfd memory. But if it does
> > > > > > > (or will very soon), we need to think more about it, otherwise
> > > > > > > AS_NO_DIRECT_MAP is not really usable for guest_memfd. Since you said KVM
> > > > > > > "will want" GUP, I assume it currently doesn't?
> > > > > >
> > > > > > Doesn't what?  Have GUP?  KVM heavily uses GUP, including for guest_memfd that
> > > > > > can be mapped into userspace.
> > > > >
> > > > > Your wording made me think that KVM doesn't currently use GUP for
> > > > > guest_memfd, but I was obviously wrong. So IIUC GUP needs to succeed for
> > > > > guest_memfd pages with AS_NO_DIRECT_MAP.
> > > >
> > > > Yes, though as I said early, it doesn't *have* to be exactly GUP, just something
> > > > GUP-like.  E.g. it could be a new API, if that's easier/cleaner.  What I don't
> > > > think is a good idea though is handling this entirely in KVM/guest_memfd.
> > >
> > > Just to clarify, you mean that GUP (or GUP-like) should work in terms of
> > > pinning the page and handing KVM/guest_memfd the pfn/address, but not
> > > actually making the page accessible or establishing mappings, right?
> >
> > No, I'm saying that whatever API the kernel provides needs to ensure there's a
> > valid kernel mapping (or provide one as a return value).
> >
> > > Looking at [2], seems like the consensus was that AS_NO_DIRECT_MAP
> > > means folios are not in the direct map, and callers are responsible
> > > for establishing the mappings (e.g. using the mermap).
> >
> > I'm fine with that direction, but in that case GUP _does_ need to be disallowed.
> > I.e. _if_ we allow GUP, then GUP itself needs to somehow ensure the direct map
> > is populated.  If GUP is not allowed, then IMO the core kernel needs to provide
> > an API to get at "inaccessible" mappings.  Or I suppose GUP could take a flag
> > that says "I pinky-swear not to try and access the memory via the direct map".
> 
> Okay in this case I think the simplest thing to do here is to disallow GUP
> for unmapped pages like this patch does. Once we have a use case (e.g.
> guest_memfd with unmapped memory using GUP), we can figure out if we want a
> separate API or a GUP flag. I assume the GUP flag could either be: "I know
> the page is unmapped, I will map it" or "create an ephemeral mapping for the
> page".

I'm not ok punting on that, i.e. whatever we come up with needs to land alongside
AS_NO_DIRECT_MAP, or at least before guest_memfd tries to use AS_NO_DIRECT_MAP.
The only way KVM can use AS_NO_DIRECT_MAP without GUP is with a massive list of
caveats and addendums on things the VMM and guest can't do.  I'm not ok merging
guest_memfd support for AS_NO_DIRECT_MAP with such a list.

