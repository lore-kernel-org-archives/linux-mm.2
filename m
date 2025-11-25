Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C04D0EE13
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 19:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 486286B0011; Tue, 25 Nov 2025 14:27:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45DB56B0095; Tue, 25 Nov 2025 14:27:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 372E16B009D; Tue, 25 Nov 2025 14:27:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25EBB6B0011
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:27:21 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D733113ABC9
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 19:27:20 +0000 (UTC)
X-FDA: 84150113040.20.C24E60F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C0A0A100002
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 19:27:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pwNWvatM;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764098839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N0sC1PClLhA8srLcRSvZL4e0bF7dYkYQwZoyvgW6HvQ=;
	b=7a+EIs0xKo/cYzkDQmtfzEe68dpWXIaNahAsaaPDPUhORwTdcImYywDNjo9iSp86kZxxYm
	s2/lOY+vAH7onZ2t0VrZ68QoAkdUeZKurJSjhPPNidht0het6IdoNmvLXA55Cm9ThUvb4X
	FJmHhdyOacm/9+kB+7ESrqSiTzwABhw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pwNWvatM;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764098839; a=rsa-sha256;
	cv=none;
	b=VSdKvAiOrgn8RhL1PmS6/iOapZCPYJBLteFpz/yjNETFVUJS5yfMdYStottVAtnOn8+Wfc
	/Ii1OzezrmgnF1BCX8FJtKGYcfAh2hnrJ8lZOxrw0RdIqV7+OeitngLCutiEPGdk5A1P+k
	qxtc4M6ML9qI/wmiR/Z0d4Qb5aYCjt0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7369D42AEE
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 19:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF77C116D0
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 19:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764098837;
	bh=N0sC1PClLhA8srLcRSvZL4e0bF7dYkYQwZoyvgW6HvQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pwNWvatMnnsafCLSiiehAUFISVdN6IoyYakrAFha28N97azVx3SyDzxjr+DHkxl9R
	 FsDoxm+mF2lS2SSF0itNsqcc3a5iMuedEgoAgBdYRiYMPBgJOOjeaRA5qLV8wvsF6H
	 Vqg8PL/s/dcdCl1q5IKLWTc+TJl2NAO+7ZqyxRVv9TeCmOXLF2owKDP/u8YNIrMgNY
	 3lgJDJxr0HLtS5OvYec8HuHkm7/0zHhFHmYnFEisL1EemSCi4pqLZfH9ncd8ZsMo3p
	 aPvIxnt+HbZ1LWCjuQbJJYzW73lZCi39OLCpryBzxQ7r4oN/SVHN26Blb9tsH0x+1y
	 6qOKquu7BVjzA==
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-7895017c722so56149167b3.2
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:27:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU5Ie9jF5zsEIuqhjzt/bDGdw/hMO73pEqTGYgw5AfFQfVLq396PjpxqnEltWZkFuawri4bgCGtnA==@kvack.org
X-Gm-Message-State: AOJu0Yxv8AXsVbRAPJZL5sEdr3bywEtrVPkrqTTV52l0izYO4oqF1nTm
	bTF1pVmgShsKJoH4E2RJCl79Ml2CGrLuJEOxx9xw4uBo7g7RSRmnEBX3V4iEWXoleYar6P6R+RI
	N7TqSaBmvvUVIqSiVkaXpycj02gGnQPj8L6xRQ88IcQ==
X-Google-Smtp-Source: AGHT+IGDlE1OuTh/D5fShv4sFzFn4q8AeyeqPTXLyhTHY54YZyd9BBJkhjWRj+Na3EkBoGiOqsd6UBM631aJQnfmn0E=
X-Received: by 2002:a05:690c:6902:b0:786:581d:d517 with SMTP id
 00721157ae682-78ab6f7ecbdmr32342277b3.49.1764098836570; Tue, 25 Nov 2025
 11:27:16 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
 <20251124172717.GA476776@cmpxchg.org> <CACePvbXLdf9bC3Juj=wA4_TKeH6XUgHbbvwV5HhNQtgoT3CiBg@mail.gmail.com>
 <20251124193258.GB476776@cmpxchg.org>
In-Reply-To: <20251124193258.GB476776@cmpxchg.org>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 25 Nov 2025 23:27:04 +0400
X-Gmail-Original-Message-ID: <CACePvbVJEWd64r-o8ezh+0QByYbWjYVKiLgxNiBJOjfRWP__sw@mail.gmail.com>
X-Gm-Features: AWmQ_bn8JDQoOI4X8QoBm9tr0VIJ4h5r1MR2Q3cZLuV9Aa9tZIu2HYrXBrIP5io
Message-ID: <CACePvbVJEWd64r-o8ezh+0QByYbWjYVKiLgxNiBJOjfRWP__sw@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C0A0A100002
X-Rspamd-Server: rspam02
X-Stat-Signature: zysat6t4mafnsmp9idooxjzpqhwegkf9
X-Rspam-User: 
X-HE-Tag: 1764098838-821430
X-HE-Meta: U2FsdGVkX19ZhCEuS6EEv0CjsMKZ1gefpbv87FZuWxYMJUNtf0cddEr4enIBR58cqsBg5Czor2J7hbiWZAjJ9opsd3mtZCCjFH25LyWbJ6Wj8dBVrMWTzHgtYMVRZlKzQCpau6LMM1BVH/q3Xjoo+E69bRt+dEQPRqrKbWbMZP2Fi2DwGDrJEBipe6o6tdP/Hmsp/2eLC7qZRzqX0KQgr2mD0jUeksO7ncytLHc1Z5JJOvy9AJxIW/CN+yUYJ6IrZMwgUaequ823DG4dMXKuhun0ZjBdM5bWQUVmIausLUx7jJMcN1tgWmbX/BLFjBQxaWwFZ8Nq1ED2jiL0VxhAv+3B3tT6+LJa8liGXKZBqyzLTwNBeEDRy/CX57VAjCOwUBdFcoKpb2w666wUwkDJzt48HVeNFY3PcRM2O9ECexRkETOXaoJew8Ese68KikXxWqf+SZ0SUEWGiRFKSdPtSOYHuieKFdhgFI8k8kOY9c6HcWQ7PZHZJsrNh7d81nfQnWH6N/pnGnSU1F1yy5H+CR7A0Vye4D8QWmhakzlPsmbjMpVRr7FulnfaOIqVslZSq0uwRDeQ/aQOrCYBTwntnJiLFYeobUxJl0xYw8OSpnHsQ6JwNrz2WRIWOCE/5jOOCRzV4YDBCPxPb0iU21AITKURn8qmRuksa2Qrv/r43NV4JZ+Y/qm/oobMNjRASb5/4fYM/biHrejv3fTsFHE+fvlti5w+TmRie07CN10R3XG4e6m0Mk+VqQQaodma52D451n3tzS/8zXJQ0beaUPTbwZhE/+vtZuOwHP0iN6ECr/Eir5BEDvyKCigbTmN7UBTFWrRLvba3JYCwrsmvpT6IL5fIlF+OzjAWfXiSK1a5sT4YCcIZH2o7YvcfR2nte0sC8tywENRM0wmDKNHw60YGUPbntVoRM9UU9xDwFTEsXo6qKG4gdSSoaVxpDhO2V9jhigSH6ollcwHr9IP9Gc
 pCOgKlGY
 SgFpZEmn0Q2EC/1qM+AzjQpCBgxYDzn5RBHb0a2hNaxOR04DSre3nRTr57bMujIZL1qdyX0CdEPMGjDssIP3zzIdgF+DCFPe9uKvUnBmJyHdI0gxRsMoYCgFkI1pQjQ1LaNQdAwRtLEU93uKmnyQXJdOGNJOKblypkZoL3BPBRe0unOpNcjnEmSM3ABXdgwff/Zj9N5AwsbYAJaxMeGeB2EZ5hNd+tK5xqIIauHpSeT/d5JRpmQw1LjUSZtkvglXcKniKzuUMXCm1AAMk9hE8tdTkKVCpIfEOJZIaPePOsYFhlb7mRsU/pLWrzG84NQX9yUc1VNl4a1w6z5PYvGdi2UqWFfzN8Lb79n1s8prEOLEAO2T4bajEr0GfZkRqRHGImaSUHeC4GmfHHgw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 11:33=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.or=
g> wrote:
> > > Do you have a link to that proposal?
> >
> > My 2024 LSF swap pony talk already has a mechanism to redirect page
> > cache swap entries to different physical locations.
> > That can also work for redirecting swap entries in different swapfiles.
> >
> > https://lore.kernel.org/linux-mm/CANeU7QnPsTouKxdK2QO8Opho6dh1qMGTox2e5=
kFOV8jKoEJwig@mail.gmail.com/
>
> I looked through your slides and the LWN article, but it's very hard
> for me to find answers to my questions in there.

Naturally, the slide is only intended to cover what is in the current
swap table may be phase VII.
But it does have the physical location pointer consideration.

> In your proposal, let's say you have a swp_entry_t in the page
> table. What does it describe, and what are the data structures to get
> from this key to user data in the following scenarios:

Please keep in mind that I don't have every detail design laid out. I
follow the first principles that redirect a swap entry page should
only take an additional 4 byte per swap entry. VS blow up the swap
entry size by something like 24 bytes? I am pretty sure I am wrong
about the exact value. People who are familiar with VS please correct
me. My impression is that it is too far away from the first principle
value, I would not even consider. Exceptions can be made, but not that
far.

I will try my best to answer your question but usually I am more glad
to work with someone who is going to implement it to iron out all the
details. Right now it is a bit too far.

> - Data is in a swapfile
Same as current.

> - Data is in zswap

I have now realized that what I want from the memory swap tier is
actually not the same as today's zswap. I don't want the current
behavior of zswap in the swap.tiers. The zswap seat in front of every
swapfile. The zswap.writeback does not tell which particular swapfile
it wants to write to. It creates problems in the per memcg swap.tier
to include zswap as it is. I don't want the zswap to use another
swapfile swap entry and write through to it.

If data is in the memory tier swapfile, the swap entry looks up to the
actual data without redirection.

> - Data is in being written from zswap to a swapfile
It will look up the swap table and find a physical pointer, which
points to the physical device and office having the data.

> - Data is back in memory due to a fault from another page table
In the swap cache similar to today's swapfile.

> > > My understanding of swap tiers was about grouping different swapfiles
> > > and assigning them to cgroups. The issue with writeback is relocating
> > > the data that a swp_entry_t page table refers to - without having to
> > > find and update all the possible page tables. I'm not sure how
> > > swap.tiers solve this problem.
> >
> > swap.tiers is part of the picture. You are right the LPC topic mostly
> > covers the per cgroup portion. The VFS swap ops are my two slides of
> > the LPC 2023. You read from one swap file and write to another swap
> > file with a new swap entry allocated.
>
> Ok, and from what you wrote below, presumably at this point you would
> put a redirection pointer in the old location to point to the new one.

From the swap entry front end (also owns the swap cache) point to a
physical location.
>
> This way you only have the indirection IF such a relocation actually
> happened, correct?

Right. The more common

> But how do you store new data in the freed up old slot?
That is the front end swap entry and the physical back end split.
The front end swap entry can't be free until all users release the swap cou=
nt.
The physical back end can be free. The free physical blocks caused by
redirection will likely have a different allocator, not the cluster
based swap allocator. Because those are just pure blocks.

>
> > > As to your specific points - we use xarray lookups in the page cache
> > > fast path. It's a bold claim to say this would be too much overhead
> > > during swapins.
> >
> > Yes, we just get rid of xarray in swap cache lookup and get some
> > performance gain from it.
> > You are saying one extra xarray is no problem, can your team demo some
> > performance number of impact of the extra xarray lookup in VS? Just
> > run some swap benchmarks and share the result.
>
> Average and worst-case for all common usecases matter. There is no
> code on your side for the writeback case. (And it's exceedingly
> difficult to even get a mental model of how it would work from your
> responses and the slides you have linked).

As I said, that slide is only intended to explain swap table phase VII
how physical direction works with swap cache.
The swap.tiers define tiers for swap, obviously how to move data
between the tier is a natural consideration. That I mention in the
2023 talk in two slides.

I don't plan that level of detail that far ahead. I try to follow the
first principle as best as I can. There will be a lot of decisions
made only at the later phases.

> > > Two, it's not clear to me how you want to make writeback efficient
> > > *without* any sort of swap entry redirection. Walking all relevant
> > > page tables is expensive; and you have to be able to find them first.
> >
> > Swap cache can have a physical location redirection, see my 2024 LPC
> > slides. I have considered that way before the VS discussion.
> > https://lore.kernel.org/linux-mm/CANeU7QnPsTouKxdK2QO8Opho6dh1qMGTox2e5=
kFOV8jKoEJwig@mail.gmail.com/
>
> There are no matches for "redir" in either the email or the slides.

Yes, I use a different term in the slide. The continuous is the source
of the redirection, the non continuous is the destination of the
redirection. But in my mind I am not redirecting swap entries. The
swap entry might have an optional physical location pointer. The swap
entry front end and physical layer split.

Chris

