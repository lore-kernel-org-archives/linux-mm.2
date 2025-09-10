Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA832CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 00:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193456B0011; Tue,  9 Sep 2025 20:27:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144646B0012; Tue,  9 Sep 2025 20:27:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 059986B0022; Tue,  9 Sep 2025 20:27:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E363D6B0011
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:27:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A965867FF
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 00:27:12 +0000 (UTC)
X-FDA: 83871451104.01.320FF28
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id DC826C000A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 00:27:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nE0Fe/1v";
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757464030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SAHyxOwAe3YRCNFwJ4gRSaYIv2VZODk7Bm26IRUwtT0=;
	b=KIMUVpUMwyTm5LC/6yMEN1buvC/pGyQ6vpYsHnQEuV3alIGQ2fRoDtH+SHMjmCaEnMPX/S
	hODrtiO8bpItAYPp1gBOAluHu1HD2ACAt1hnEXWE+3rCu670XvtUUf/EhK27Z+z2atcB7x
	B3HLYi9XPV8fknrx9fW1uXiXd+u37+4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757464030; a=rsa-sha256;
	cv=none;
	b=ywvx47+62qYYiu1SP4AEJWabEQaImoxYA+Ou0PV04YbxVfksdIV+i705dB0ydXAeuCVuhp
	PwUU6J0xcrntHDNccQYVJ5PdHljTL6VhmK9vtGbI2G4loF6JF8pbjUMVIziQCcuKPAuEJ5
	lPE/z3lrBBS9cEGZ8Fp0+xFz6SkyBrQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nE0Fe/1v";
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 43D4A6023B
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 00:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BFCC2BC86
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 00:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757464029;
	bh=GXXS6Yp6FuJ7Gx5+BIIsDkHLY0iBFugbjimeY8S4Bn8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nE0Fe/1vh6ownMVPPwkt+ywOvxdriVg3oAq2Uckyofgj4I2jk1xWBxlkWEaS80V0D
	 VZX0ZKAmC8Ei8eIclXUcwhZIAA71IvWUrM0QLVwriCBt5A7ApE7SFLPGyN2jegkACN
	 I7gBMNoeLxGHL+PEjNjeOhrF6AA+Ik2hhfIomWmNi2nu0iwGegcZ7op0fBawUpr2wv
	 Oo7InFIiOW2oHfXxeJpxzVI0UqeUoCSYdVz1NYtvPUfPqWE8hJp/8c0bO3Hu6FQ4Et
	 JsJ4qaS6N3iiU5/LfNmB+k2mG8/XbYg2sVCA0pp+fK3kQVnfYGq2n+V9d4B5A2r3wx
	 dLq0fifbG4OVQ==
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45dd9d72f61so36265e9.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 17:27:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWGmu4dtRdecg4OdC9JdBf6wDC9VdPEK7rWu4mQ3j4FtTKoDbTHvSizDo9/bCHTU2ufxYpkYXv+OA==@kvack.org
X-Gm-Message-State: AOJu0YwACh0Wdb6xgmvHKhkoqPsS71oZTccbHE3waNNP8KCSqT2FJoFU
	RbpKm5C501Duu8kky6Y33AWUFyIa4w+M/tUiiNqyjW9PKgE3Gf/WOvsa3/T0n6faLBozzCRpDau
	F440gOc1Q4q5403yGnvu4q41+eRZW1ofDqK2S4FhV
X-Google-Smtp-Source: AGHT+IEjO5KjVXeuirkJYchCdqjel2eUtWLp8SGydR4OerzOF+GrTMIJyccx5AMwbYmmZQutwhButD5dIBxqgYdkJ80=
X-Received: by 2002:a05:600c:a31a:b0:45c:b678:296 with SMTP id
 5b1f17b1804b1-45df82112e9mr295135e9.5.1757464028354; Tue, 09 Sep 2025
 17:27:08 -0700 (PDT)
MIME-Version: 1.0
References: <CACePvbUJSk23sH01msPcNiiiYw7JqWq_7xP1C7iBUN81nxJ36Q@mail.gmail.com>
 <aLJ4fEWo7V9Xsz15@yjaykim-PowerEdge-T330> <CACePvbW_Q6O2ppMG35gwj7OHCdbjja3qUCF1T7GFsm9VDr2e_g@mail.gmail.com>
 <aLRTyWJN60WEu/3q@yjaykim-PowerEdge-T330> <CACePvbVu7-s1BbXDD4Xk+vBk7my0hef5MBkecg1Vs6CBHMAm3g@mail.gmail.com>
 <aLXEkRAGmTlTGeQO@yjaykim-PowerEdge-T330> <CACePvbXAXbxqRi3_OoiSJKVs0dzuC-021AVaTkE3XOSx7FWvXQ@mail.gmail.com>
 <aLqDkpGr4psGFOcF@yjaykim-PowerEdge-T330> <CAF8kJuPuOWUEMg6C9AnAA-mddgHRjuMVqURrbk6bUHxAmEvgFQ@mail.gmail.com>
 <CAF8kJuNW2kmxKYRE9t8WvSOad9JkLYt0WSAcFOQ9r9=2=XGc9Q@mail.gmail.com> <aL3GHJJ6+elPD7OP@yjaykim-PowerEdge-T330>
In-Reply-To: <aL3GHJJ6+elPD7OP@yjaykim-PowerEdge-T330>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 9 Sep 2025 17:26:57 -0700
X-Gmail-Original-Message-ID: <CAF8kJuPj6-gZ4H+VQtJpJj_MutTgTcR-9BfDQnweayOrXk-NCQ@mail.gmail.com>
X-Gm-Features: AS18NWAzRhK6Sza7aFhZ16A-JN0ICbt6KESSJLX5RLfWjX7iQZOSQJtZI6HXM48
Message-ID: <CAF8kJuPj6-gZ4H+VQtJpJj_MutTgTcR-9BfDQnweayOrXk-NCQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
To: YoungJun Park <youngjun.park@lge.com>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, gunho.lee@lge.com, 
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com, 
	Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@redhat.com>, Kairui Song <ryncsn@gmail.com>, 
	Wei Xu <weixugc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DC826C000A
X-Stat-Signature: ee1ahtjqm6cy73sm5dy6a8tfknjujzgp
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757464030-531899
X-HE-Meta: U2FsdGVkX18c+HJQWLkb16EVC5HGxMAQ4MNctXveTXbvS/lD8PU85G4914CROVrIPaO/RpribFPsjDmLky27s147H+QtY9jyEudE8TPKNn0Gi8agmuY9fotBGrqte7QjNoWvAXfiKR5L9izzXzEqpf5rQ/NIwqVZ2blrTK641omj4bgOqQLHSTEORFn4d2PIXNVOI6dmnz4wxgr/4lZcLxH5pl7hQgldxJFxuT8HNBl6SoKyW1gvZMt+QjbWNkzKV/5usVZ9DsOEuwuFV2HzzqaoMlJglrTkpRk7xivBS88LQBid9cEKrbkiW5XZD+T+CKutxXxJyNjlVtLkWUEpsoup9TfVnRXT51xgEYeOQHhuPIfOimyCGpxkInsdoGlH0wRys9q0ZwlAIpUhN2YHVONJt7Zzqjd1mVM1o9FMUC2Ad3X0GLPpnFCkIvdv2lUVToFXk4OaBoe85/Q1jfaAusrxEs4usc5vI+a/nMpWVSt6wUmuSzugZbde2G0Bt+gONG8N4xKXabIR0bItnTZG4Ask0mF/WIrHP9p3F0o1uwu5MP66jGy37PEbhKncXrzUUolx5XSomsI3TR13LgJ3KmKzbGM1oLKLpC2yXncDrHdaa/6dl01BwdsQ1eyJLqqnXYkM7U8IuBFB+v2NyQFE3AwLV4J6qH7PxOHyYuM7/r/zghXqhlHdjSW27wjxfWmDHwvAywTvB4+Hw1iuQgzI4KxEl05/f1guOgRljMGv8/Dt6eQn9zl+g5PadiFSdppO8G7rM03tR/zjx83xWGJnEujrk+AVaxiltOn1IRrEy78i9QK7WnzLBpDFqItq21beYu7xuJbitPRHlvzIuiIsR+ih41/QDDoD9GkbG5HPGLPcGzsRaaoCzVbCSB2ahIbF97ThiqrVbiWPTmuLbr8hws6Vsrs6RDNmDG7U8UMHYpki0ifJ4dxijwmNa3zItwjV6+Q/dMCuMPY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 7, 2025 at 10:51=E2=80=AFAM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> > On Fri, Sep 5, 2025 at 4:45=E2=80=AFPM Chris Li <chrisl@kernel.org> wro=
te:
> > > >   - Mask computation: precompute at interface write-time vs runtime
> > > >     recomputation. (TBD; preference?)
> > >
> > > Let's start with runtime. We can have a runtime and cached with
> > > generation numbers on the toplevel. Any change will reset the top
> > > level general number then the next lookup will drop the cache value
> > > and re-evaluate.
> >
> > Scratch that cache value idea. I found the run time evaluation can be
> > very simple and elegant.
> > Each memcg just needs to store the tier onoff value for the local
> > swap.tiers operation. Also a mask to indicate which of those tiers
> > present.
> > e.g. bits 0-1: default, on bit 0 and off bit 1
> >        bits 2-3: zswap, on bit 2 and off bit3
> >        bits 4-6: first custom tier
> >        ...
> >
> > The evaluation of the current tier "memcg" to the parent with the
> > default tier shortcut can be:
> >
> >         onoff =3D memcg->tiers_onoff;
> >         mask =3D memcg->tiers_mask;
> >
> >         for (p =3D memcg->parent; p && !has_default(onoff); p =3D p->pa=
rent) {
> >                 merge =3D mask | p->tiers_mask;
> >                 new =3D merge ^ mask;
> >                 onoff |=3D p->tiers_onoff & new;
> >                 mask =3D merge;
> >         }
> >         if (onoff & DEFAULT_OFF) {
> >                 // default off, look for the on tiers to turn on
> >         } else {
> >                 // default on, look for the off tiers to turn off
> >         }
> >
> > It is an all bit operation that does not need caching at all. This can
> > take advantage of the short cut of the default tier. If the default
> > tier overwrite exists, no need to search the parent further.
> >
> > Chris
> >
>
> Hi Chris,
>
> Thanks a lot for the clear code and explanation.
>
> I=E2=80=99ll proceed with the runtime evaluation approach you suggested.
> I was initially leaning toward precomputing at write-time since (1)
> cgroup depth is might be deep, and (2) swap I/O paths are far more freque=
nt than config

Cgroup depth is typically not deep. Might have a lot of top level
cgroups. That is the more common setup I am family with. If you know
other usage cases contradicting that please let me know.

We can turn this into a LPC discussion question to ask the audience as well=
.

> writes. Is your preference for runtime for implementation simpleness?
> (Any other reasons I don't know?)

Oh, I think it provides the most flexibility with minimal code
complexity. It is kind of the best world. If the child overrides the
default value with leading "-/+" without tiername. It will trigger the
shortcut path and no need to look up the parent.

However, if the child has a default empty "swap.tiers" file, change to
the parent will impact every child cgroup. We can have it both ways
with what I consider pretty minimal code. That is actually the most
common usage case. K8s pods would change from the top level.

It is a good trade off in terms of ROI from complexity vs feature
flexibility point of view.

BTW, the "swap.tiers" file should require root or some kind of CAPS so
non root users can't write to it by themselves. Otherwise they can
abuse their own setting thus rendering the QoS aspect not effective to
other cgroups.

Chris

