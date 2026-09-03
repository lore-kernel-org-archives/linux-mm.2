Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60FC4C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 14:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78D0D6B0099; Thu,  3 Sep 2026 10:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 764AE6B009B; Thu,  3 Sep 2026 10:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67AF56B009E; Thu,  3 Sep 2026 10:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43B5F6B0099
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:06:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB55E140569
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:06:18 +0000 (UTC)
X-FDA: 85172625636.20.96F9BC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 987B24001C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:06:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ea9Ee6Sa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788444376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KWSSDYXbxafLtJPXW3Njj6zXDgKYuFr+JGnh2XXB+W0=;
	b=DImdI4Q2wGDmx0o7WnKgpd17r4d5npbWFaA9z6YYCnDsp9d/p5+rSYDe9tlZda0HIh1WqG
	GPUwZMokGNgRMPNMjou/AN76VhmjYB51n/Wtudm1qLR1dktBcOOgDz/XJwcHNgDmcwNi0M
	Qhka6bkNn+zdZK3I1wP+xuAzKiqIVlY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ea9Ee6Sa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788444376;
	b=KKWLoKh1aUYrW64vcOimgXsPx4GcW783kK6Xsp7JlZNnmqXq8qUcRYKO3uuEL0HqtXnDhW
	nC/vyMamh6K9ohE/5XfpszRZ9fTgtFt0vpkwNnBZJArLdoJNqQza6l63/w5YeV3YQ6M2zb
	hgEdxu+C/iFI6pj3x1JUNvn3ccKgO3I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E01A743E2E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82861F0155D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788444375;
	bh=KWSSDYXbxafLtJPXW3Njj6zXDgKYuFr+JGnh2XXB+W0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ea9Ee6SapoZLH6Zs7KC2ZuW0jgAiFh3EBaz/GnCvmEvWX25JJHnb3zoEauFUpsQkF
	 TptAbQ1TkGcu1ZhZuQklfJe+hdga4AiaZbP/cD2s9C7ZspKuAb7oqm2pg2Y8Lrketf
	 Dd0IPZhB8D/UwLAtaKSCloab06EJzFXIVz1ANnOHEn+yrMCsYxr1kuZcJaykr3fns4
	 E29BTNB1+F6AZ89V4p0XS5H7Mi5oO1dzfrs3orGcVzvtRdcdKykKlNJyXIk7Z3Ziv5
	 DASa+9HRispx66kxLd3WgAf1L3uenuzBBo/IN+mkQp7TO83X7StYqfj7skPuSYdpwf
	 iNqcn/Gs5qL/w==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c1712a04ddaso399242766b.2
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 07:06:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzxze+DGZgq/olPPs0Wla7Wac3Tc2EN2GLQxoDHIw3qMYEtDM5XEHaGDn7pl3NR7Z18DTYFkEqaug==@kvack.org
X-Gm-Message-State: AFuF++mbdTZcL08kdsl8vd9y2nJFTGixW34MAPAHJCZpoZ8DaRyrfJ1S
	0spoeWleq7E64I8hhz7VS+u0s+KPcgbNNvBXDBecfh3LQB6/7/rC+d1KpKnQdJzDkTkd+bcOOTl
	sBnBgR8AeQzgIM0ke31bLLU5AfcnCYJw=
X-Received: by 2002:a17:907:3e91:b0:c25:192:99ee with SMTP id
 a640c23a62f3a-c25d5509226mr871430666b.19.1788444374630; Thu, 03 Sep 2026
 07:06:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAO9r8zNJ3mSRf5YyRQYYW-eM2eiFvQMXW4Rh0cT=31jsKZpuSQ@mail.gmail.com>
 <20260903072625.62694-2-itazur@amazon.com>
In-Reply-To: <20260903072625.62694-2-itazur@amazon.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 3 Sep 2026 07:06:02 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMxdg2BTFguwcRQn8n-2CPaEJJfg+T8dWcgO2eV4uNaHQ@mail.gmail.com>
X-Gm-Features: AcwNN1WucjHD1N3a6o32XyIZFyKC9j2svL8NXQIbhxUtIFR94fN3vSg-L59gUkA
Message-ID: <CAO9r8zMxdg2BTFguwcRQn8n-2CPaEJJfg+T8dWcgO2eV4uNaHQ@mail.gmail.com>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
To: Takahiro Itazuri <itazur@amazon.com>
Cc: Sean Christopherson <seanjc@google.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, 
	rientjes@google.com, Roy Patrick <patrick.roy@linux.dev>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>, 
	Ackerley Tng <ackerleytng@google.com>, Takahiro Itazuri <zulinx86@gmail.com>, cc-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 3i1wsbqcqm3wcow1fs5qo7dfrzhwtapr
X-Rspamd-Queue-Id: 987B24001C
X-HE-Tag: 1788444376-457837
X-HE-Meta: U2FsdGVkX18lv5NhhD4NZi/nD1XM2WESYTVL0OKbohsbxYRaCAfqMN0W3/P3KKvCnKJf/dfq5rgfKGi31nlBfsNPwkQiBN0uK8QZtKrzfdM1poCgwYqEDdTTKbjiHrzmUlfEkeG6MwyL34k4tvG5ZyFLiBzHryGIkOgRfzyrIMFmy/fcjZOi+KeMzfrfd8/o3Tyss2odRM30VGxdqtzMySLuMfOpDuNSbOypvpC/Sud7LmI3MqKbNjZp8ON73Id5EL16uSu9knkeBXbFZg0NJGoNhytl0l6FozgRc48BE2U0dpB/lryy6eBMRlvhX5ghP5Z8COY2VBzapl50rmtOxaz3xe0KI+ZTyjXQEpnA5cioX15IFjCJnbG6C5c9cjbyYPKTS656t4zrEG0lybN2Gn5Q+w8w3kA5VpeAV8NbjczAwTuGLCUFyI59PFhoT8JpgIXhdenE3vfLGoU2gakysDvJBA4RI85ewGcI9FTZFSAxz8EmJQoBsR2dOlcRGFvqU0tuztkUazb8eIRwdAYECQBxyVxyfD6uizAUH8T+RthxZMylKgKbS3PvTtHF8CIZkysSWg3nKR+yxgYcrua37EgTonkQOoMbVr2j+xfOb9/O2tXqRxQf9qKzthK/CDQcKlj37aw2qzqqpQRAr+B+lY06OrnTaeLjvMItVG+IfS74s4wYLZ+kFXxIfZ2w7X6yEE8uEExSSzRKr3t/b36UWsoY7hyIVsIWuCqdDEpB4oxJY8aovHUL/Jqw5GRpd+7bjgIsNUIJhcQcpa0KAEoeIDv1eJTdoBWuk/6dRRqqkgVwybC/E+a8p26dZQkmnq5vTu0dibavDHpeup2cxXcrmJcFE4H5S2Qtl4xYYEI3jITIiZF3utMeN5f5o75TVv5QRUpzwdMM4v/NshN5IAEqf2lregQG7wu+ouMbsSm3+/VO3BvupKoAAKyZzUyq+bEPewFVnyBhvKReaanzo6O
 GxbBtdqB
 VR6F8yKqHFozXulKqFDQVoMLutmKWIMEYb25xtUgwXR/syPe6luY3xC9nl7hebrkxGocJT6fBtMyeWcI0zWkiNYHvEe9FfPHqmtScm6wgrJwfHWNNcigpEmFb6Hg+sV5a3OB1wG71hUn8FnEZaUDs39ppQdQ5xpGm5yJ794mnabUJ/D+4kZuYCdzVrLRzcc7OdMKJHpHGw162XHb4FprKvgdVxmoSjt95QsdNsnIxl8JPfAmhGmiQXobge/EAYiSlrLrZd/WyGjxzW0vhM5jZBFgWd+2ie/5fvfwXvbANWvh91DO+4Y7thJBNBAGowzrgDB497nzwiIHYWJz+smabWrM1VFmxio8Umr5evPPhO5ZaHHukwoeEoIYwBkSI+tvXytfS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 3, 2026 at 12:27=E2=80=AFAM Takahiro Itazuri <itazur@amazon.com=
> wrote:
>
> Some of you on the KVM side already know this, but for those on the MM
> side who may not, I am taking over the guest_memfd direct-map removal
> series.  I have finally caught up with this thread, and I sincerely
> apologize for joining so late; other commitments kept me from catching
> up sooner.

Hi Takahiro!

>
> On Fri, 7 Aug 2026 15:48:24 -0700, Yosry Ahmed <yosry@kernel.org> wrote:
> > > I'm not ok punting on that, i.e. whatever we come up with needs to la=
nd alongside
> > > AS_NO_DIRECT_MAP, or at least before guest_memfd tries to use AS_NO_D=
IRECT_MAP.
> >
> > Yup, I meant the latter.
> >
> > > The only way KVM can use AS_NO_DIRECT_MAP without GUP is with a massi=
ve list of
> > > caveats and addendums on things the VMM and guest can't do.  I'm not =
ok merging
> > > guest_memfd support for AS_NO_DIRECT_MAP with such a list.
> >
> > This series is not adding the support in guest_memfd, just adding the
> > generic AS_NO_DIRECT_MAP and using it for secretmem. Followup work is
> > needed to plumb it for guest_memfd anyway, and I am proposing that we
> > also punt the GUP story to that (when we have an actual user).
>
> My reading of the discussion is that the generic AS_NO_DIRECT_MAP support
> can land with GUP rejecting such mappings, provided that a generic GUP-li=
ke
> access mechanism is in place before guest_memfd starts using
> AS_NO_DIRECT_MAP.

That's my understanding as well.

> As far as I know, Brendan is no longer at Google.  I do not know whether
> he plans to continue the ALLOC_UNMAPPED / mermap work, or whether someone
> else at Google has taken it over.

I am currently working on a new version of the ALLOC_UNMAPPED series,
I am hoping to send something out soon.

> If that work is not already underway,
> I would like to respin the AS_NO_DIRECT_MAP introduction and secretmem
> adoption as a standalone MM series, separate from ALLOC_UNMAPPED and
> mermap.  The AS_NO_DIRECT_MAP changes originated in the guest_memfd
> direct-map removal series, and splitting the MM and KVM parts was already
> requested during review.
>
> The proposed MM series would include:
>
>   - the folio direct-map helpers;
>   - the AS_NO_DIRECT_MAP flag and filemap lifecycle;
>   - the current GUP and build-ID rejections, while keeping the mlock
>     check specific to secretmem; and
>   - the secretmem conversion.
>
> I would leave ALLOC_UNMAPPED, freetypes, mermap, the allocator fast path,
> and the KVM / guest_memfd integration out of that series.  This would not
> change the requirement discussed by Sean and Yosry above: the GUP-like
> access problem would still need to be resolved before enabling
> AS_NO_DIRECT_MAP for guest_memfd.
>
> Please let me know if this work is already being continued; if not, does
> the standalone MM series described above sound reasonable?

Perhaps wait until I send the new version, then we can discuss if we
want to split it based on how the feedback looks like. Does this work
for you?

