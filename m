Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A9ACC5AC67
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 00:19:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116CE6B007B; Thu,  6 Aug 2026 20:19:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C6986B0092; Thu,  6 Aug 2026 20:19:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF7626B0098; Thu,  6 Aug 2026 20:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A8D8C6B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:19:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07D6EC0215
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:19:13 +0000 (UTC)
X-FDA: 85072563786.12.3A79BE8
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf09.hostedemail.com (Postfix) with ESMTP id 45DB8140003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:19:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XLEQD8Na;
	spf=pass (imf09.hostedemail.com: domain of 3fSR1agYKCPQoaWjfYckkcha.Ykihejqt-iigrWYg.knc@flex--seanjc.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3fSR1agYKCPQoaWjfYckkcha.Ykihejqt-iigrWYg.knc@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786061951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=luhPZAd9yDKFqzqDYzNPoL8PFv2nmAeAhL8OrthRHBw=;
	b=SgI/6F27vSS+Xc0T2Wjy0AhmewjumCkB0d7+rp/mYsGd9+EXjiAE51DgpTzXy8OhdjyhqC
	acAJjYrpz+dlsEPPuzuW+/DGU21cn/wXnEnlwB8Wahco0Eao2QplebwoYp41+2G2WKPQwT
	XxaPKBg+H5pqjZp+Rh27PClxR6atC4Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786061951;
	b=IIxOIg4ihHZ2u6oQiAsR18bEmBeeeqLGexMt+Qo6auvnacRH3j159hWAwHg+S6t69n2937
	GaKZugN8W32IIIKbc1mdlVfT7DknbFX3RRxTQxtX9bE1p0pZuIVVGVt4JNLduvrzDMXDvT
	8F6nFsAaGA+CoWt/mGvZWyz/E7NoMyM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XLEQD8Na;
	spf=pass (imf09.hostedemail.com: domain of 3fSR1agYKCPQoaWjfYckkcha.Ykihejqt-iigrWYg.knc@flex--seanjc.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3fSR1agYKCPQoaWjfYckkcha.Ykihejqt-iigrWYg.knc@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2d04908139bso47908235ad.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 17:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786061950; x=1786666750; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=luhPZAd9yDKFqzqDYzNPoL8PFv2nmAeAhL8OrthRHBw=;
        b=XLEQD8NaO7r8mYPW8wjuV4NZvjlx1KI1gH0Fvy/dy8C4K3ZPrvVzEPi3/bvzQmYp6c
         lwfVDpo5a2EXs/mVjMdGv7R0RvxpIXG+Pzuaai4coQ9rY69hYVd834T9EqMYeiNH6eFS
         sQDZKKM/dAbJpjiUfHzOW9GkXRPvajQpU4FpX+EmcHFhczrUXeaX1DMMxgbjdIWfCfvq
         3ypNCqIPDGzfvwhNJSi5erMQC/QVILJ/Cs837CyZR52S9GCGBHoQVUkT5pdcO/ujSSe+
         XE1qjx36Ah9BmEk5wkkj9cOD8JNwrocG8A/y8f3skUi15cPYC88j6T/Jav6DOWmfhy0j
         /rRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786061950; x=1786666750;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=luhPZAd9yDKFqzqDYzNPoL8PFv2nmAeAhL8OrthRHBw=;
        b=HkUEOqaPH/QNpD0gcLrpdcEI8DkKIjMj1DEFZDfE1Hs7ae3Z1Hp2qNhvauGU1FiTiM
         YMTw+O0JMozwe15XVwTcCU0na4tGiSf7yibyze3fletrbWEmaWPDqWn9Ogim3vO23Wj/
         6nrFa5dfN7k/z8iAWLUdq+br2jl7EaqcgeR4AHHHCcGij9ooOhyGCF3W8AEFGti3DA6d
         SiCq1/piQHX5FEA3QX1lNGqvjq6umtiHOEfEZI8UOL991feKlb90ttDkYvPzYfgEG/xU
         uOLN7CkjoZjuj2uuXZYPQPefJFn4nrVOeScvZRq4UkHj7Wu+M/O/ubBKG3oIT+g+c5Xo
         li4A==
X-Forwarded-Encrypted: i=1; AHgh+Rqcfs+uOUFDSf3uPgrNrBAqtRGyyI+rgZHNQTjauoDn4iL6aaH0Z7Pijkxj1OqWafUhVFLohiqBEg==@kvack.org
X-Gm-Message-State: AOJu0Yz7zM2Z7RlY4NEgD+ZvP+J8pkf8AAk5GtrHpKVVPXwWLMiWt9AS
	oF32CTscEtHiPJWPNYBEdXxeIc5wp+z/125/c8ai75B4Jl+hmlFM1L4UvXmareNbDR7DhIARK3o
	gHwzMIQ==
X-Received: from plblg8.prod.google.com ([2002:a17:902:fb88:b0:2cc:61be:8bbb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f788:b0:2c9:d55d:2d3
 with SMTP id d9443c01a7336-2d0ca7834d4mr237958385ad.15.1786061949754; Thu, 06
 Aug 2026 17:19:09 -0700 (PDT)
Date: Thu, 6 Aug 2026 17:19:08 -0700
In-Reply-To: <CAO9r8zPk-X5+NmtKm5pvPD=zhrDDAqF_2h-a9-0=5-+CVEnUNw@mail.gmail.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
 <amu5v-e39GKpgFG4@google.com> <DKCQZ9JTKRIO.1K61106YF38GW@linux.dev>
 <amz0jzVPZo_eBeRV@google.com> <anUgqnHKShicIK7C@google.com> <CAO9r8zPk-X5+NmtKm5pvPD=zhrDDAqF_2h-a9-0=5-+CVEnUNw@mail.gmail.com>
Message-ID: <anUkfHGqI07cgSHG@google.com>
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
X-Rspamd-Queue-Id: 45DB8140003
X-Rspam-User: 
X-Stat-Signature: eojzzhmjh3ei9mj93xququ7d4ao7tcnf
X-HE-Tag: 1786061951-557814
X-HE-Meta: U2FsdGVkX1/hRMB2uygZOzS9tqzVuJvsJpF+WlN3hh+NTPLFis2DWNa5kDx6UdazK3virViTNJohTfKkKcKneAs+zpkp2wBS2BcjV3jSw196N7jYmIpNU8LRjfXu+G3L0eZfHDujEAqO8dkIY1z1nc/a/4kjCOi9Bh2lZsqfkFqxSTUYl6u9zbXhiVVaHUq/pkcNFwC3bSDxJAGu273MvWDU7EWw41nlZVsHaRthdx1pHa99+4yjOL2/Gc6GrUdFowIVbk9IYKabuvPhNVPzqxQ8L3Yake4cOhSMiXosphNeanROOhdq581HIurburN2b6Lxuutc8+5Q3/B+QyfZcBN5tU8PHmY6IuNWJ2hb6m1I4t7/WZqSVVAJn69SG1Y6qIiStBQoIvBObGAO+bI1xHxTfGgji+IcrCP/7jQwPysku7auAE4pr6Q0a/hML0ggKkO0ZZZq1E/8Kd7npeBU/WRsuUMOVqK7YriKAvkgzJz8OOrAdunXybE/mmMCirf3ZSgbIBMU8DT1At/PVUBxU3JAR7BocpZJHmnsfAP3e0lxB+CcNhy90rVtj0ctd1vykmFr0a2zHQyShugg+dHpDcTADQRiMK3+BPucdBsJSCOF+c2iBUvU8VkkXIrGiVP9R0WVw3oFHnrXEFg6WmOGU7FdqdzdDOkcjJ8i9Ozp2DHiIeL4jqvRBxK+wyUy0Lv6hoYov+V9ZVxss+geqIXrhTce7Mq/IaeQtHbH0r3N/pq9K9a2LKKOc0q9nTEau6XThcKvzgeL/ldhwp5ZRQNGuc8kr/dbkYsIC3jVohTd/VOzilfKOTfRYEVYj9lMLB0gbwvNQ/NSgTvnd7ZKP6hNG+MFO8jaU30ILhAl5UxArdFS062gdaRrfFc1MlK8pxBR13EzBWq7M4jQlQzmYtfdUqGTkY1fTXUM4ofaIRsnqqO158BPkoRsGJfBuWAfY/xSbL4bxBJdjFVUpXjhsda
 mGdTogAY
 iMLZX2xAxjqwPau7T3NWyah8nZwcRG8ajwWvRUSJ7eZrBTRYQRjpe/B4LJWTD8Yk/5okU3emGOo/e3CQ9zAAb7fdBE5n5qZbFwQmqWRLXnuk453iBZ1wCxsPmCcBQXDIH3G9Zx+zrs6xCOT8wPLYjEPsuxEuq+3Jp/3JFNqnuk1JQpsX+39csnYJFGQNoPE9+f7wB+ikl3omKWkNIq3ZV/cf5rzrQML6Z6je5n80b42RpBkB3ZFDKqnGFTCDDE8PsVdDsjc66yA/LitM87IYNtTlN0lfghad2BFhGSI2v/ZtBtBZeACsxI7XWhjeSOMhPIsyHeWmpLVAqlYZEnehcuX9ab1ycy9NAFmUUaQJnwmszVZTlqCteJV59O9JxVcv0AWgp4M9Kv+NC+EaT1nzPR62sCktt/ZVfBPrEtEi+y+GsuYlNdZCXF6V8iCkrRIBU/djqgnA4kNOdReznTo1V1WSYp4nOmQHNj2ks6Abs2wK71yQq9r2hlLlkE1wDRxqoKEjRNtS0QZKsBxnUYOaeTLHjcOSS+FVHfCUSwHnT/PHeAuhEgacxxCShukelhQ65nopiz4JJggEiIxXH0NUuX7fmKWuvI8MryG50/EJ9Nm1G+v67uImjiiOCxskcmzwwr6spPrKMM5eBb2lWDYjBHGzLhGGq7uX/1i47
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026, Yosry Ahmed wrote:
> On Thu, Aug 6, 2026 at 5:02=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Fri, Jul 31, 2026, Yosry Ahmed wrote:
> The mermap provides infrastructure to do this, but I think the assumption=
 is
> that mappings are short-lived. Keeping mappings for the lifetime of the V=
M
> would probably need more thought. For example, migration is disabled whil=
e a
> mapping is active (as mappings are per-CPU), and I was even proposing
> disabling preemption (lol), so that wouldn't work at all with mappings th=
at
> are kept around for that long.  The address space is also currently limit=
ed
> to 2M per CPU per process, which should be plenty but could also become a
> limitation.

They don't _need_ to be kept around that long, but I'm skeptical that on-de=
mand
mapping will actually work for KVM's use cases.

> >  2. Always access guest memory through userspace mappings, i.e. through=
 uaccess.
> >
> > #2 sounds nice, but the problem is that it effectively requires hand-co=
ded assembly
> > sequences for anything more complex than basic load/store operations.  =
Which isn't
> > a complete non-starter, but it's a pretty big blocker.  E.g. see the me=
ss that is
> > record_steal_time(), and then imagine trying to convert something like
> > nested_vmx_prepare_msr_bitmap() to use uaccess.
> >
> > So, unless someone comes up with a clever idea, KVM will need something=
 GUP-like.
> > Strictly speaking, it doesn't necessarily need to be exactly GUP, becau=
se KVM could
> > poke into guest_memfd directly; KVM would "just" need to manually track=
 its own
> > mappings.
>=20
> Ideally we can have shared infrastructure for this (i.e. the mermap).
>=20
> > But on x86 at least, that's not really a viable option because it only
> > works for map-rarely, read/write-many use cases.  For one-off accesses,=
 creating
> > and destroying (very) shortlived mappings would be too costly, and so w=
e'd want
> > those to go through uaccess.
>=20
> Not necessarily (I hope). I think the mermap pre-allocates page tables
> (or some of them) and defers some TLB flushes, it's aimed at
> short-lived mappings (e.g. for read() syscalls to map a file page,
> copy to buffer, then unmap).

I highly recommend testing shadow paging if you have aspirations of replaci=
ng
the get_user() in FNAME(walk_addr_generic) with an on-demand mapping.  I wo=
uld
be (pleasantly) shocked if dynamic mappings can provide acceptable performa=
nce.

>=20
> > At that point, userspace is basically required to
> > maintain mappings for all host-accessible guest memory, and if there ar=
e userspace
> > mappings, then not using GUP doesn't make much sense.
> >
> > Note, I called out x86 because x86 has the most extensive emulator and =
shadow
> > paging support, which is where the isolated, one-off accesses happen in=
 spades.
> > Other architectures might be able to squeak by without userspace mappin=
gs, at
> > least for now.
> >
> > So, in all likelihood, KVM will want GUP.
>=20
> Yeah I am thinking that the check here to disallow GUP completely for
> unmapped pages is aggressive. Maybe it works for now if KVM does not
> currently have any use cases for accessing guest_memfd memory. But if it =
does
> (or will very soon), we need to think more about it, otherwise
> AS_NO_DIRECT_MAP is not really usable for guest_memfd. Since you said KVM
> "will want" GUP, I assume it currently doesn't?

Doesn't what?  Have GUP?  KVM heavily uses GUP, including for guest_memfd t=
hat
can be mapped into userspace.

