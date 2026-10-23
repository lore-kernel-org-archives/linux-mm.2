Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B16D0606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 18:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OZcKwms+
Received: by kanga.kvack.org (Postfix)
	id CB1AB6B0BCE; Fri, 23 Oct 2026 14:49:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C88B66B0BD0; Fri, 23 Oct 2026 14:49:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA6966B0BD1; Fri, 23 Oct 2026 14:49:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 963A86B0BCE
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:49:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 12802A4BD5
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:49:23 +0000 (UTC)
X-FDA: 85354779006.21.9F3983C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 28A861C0005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:49:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OZcKwms+;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792781361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I30wMbvFV4BnwqUrI39cfUABnvDkclC4d7g0soYkp48=;
	b=4O33WQx97beDL/FvXYLGCnPOyrvbcB0ou8ag0YsJ/fbWg77JltiOE8i4W3XackP8EQi7MT
	5OLz/KQ4F3O2RVTJ/suHfxQe8exE/tTAadtNQxtXTYjIyEg2Ib+oGY+CkoaxCWkXCQhvT1
	lNUnzAOpeC+nytdjsg6w2ImDCb6DX34=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OZcKwms+;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792781361;
	b=jVPr8J8iWa41KY9Pfth+jHk7aSqW9fDvpO9FxVCX9jxMVHlgAEQ7jENxSTTARyjIBOJWzE
	yF6QJuBsdxn83HuQscxWXavFiyE3fRBXO8IOnK1tDMxmroiOKNru4x97Wdz5pcPAH5zvsG
	PONnzvUwi7FWFDny/b9ib0TCX4KUKS8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 881B4601DE
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDB01F01829
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792781360;
	bh=I30wMbvFV4BnwqUrI39cfUABnvDkclC4d7g0soYkp48=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OZcKwms+f/ND/QYDagLCmBuCHt11fMNVVSy+QPwavTLKDsj/w672fgN/z8y+zXmSS
	 mKvDGtqr3lDtIo145w+h2r5eVWfuw8dR1S8Vws6C3B/3iNV/gT/RDUDcmMemsXcPpQ
	 90C0DIpc2En91RKva79xGhNHtY/XrpHApnkpr42NyCU4WZH5nR1OYjIdpDCZGUv0tt
	 Y7pTD1177XiIe3qM4tP+mJT6XmRSISIOGLXBjH1iGH/5FfqIeqodhk6sS4WWqoINgy
	 oqL0y1A/VP13l98arpQR2gVk9t0aiqjttesLuItsg71jXcEQp5jmb4o7PlYSXpUCmL
	 Jva2fSJgorRnA==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c445c95d553so158814466b.1
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:49:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzmuF6cbTksAxsKC51EtaePZi4Mvkm1bt+n0jMIKtrx/Vy9VeqbHMWqeDjssgECblRYDhRUebtErg==@kvack.org
X-Gm-Message-State: AFq9FYJ4nd/bHnyOv+nO60Pc35iJN5Uc9r9UKJygTXa+GmmXln9YZw6Z
	SKdN8PIYAz8NwZavHsG96RtP0xKMKJZu8PKGrpG4/LQ0kAYbo6CTVFl8pr06lIABWgXqwumYnBQ
	ze8K10oBrBXK0npBdBf+xDhKCIyMh0yQ=
X-Received: by 2002:a17:907:724a:b0:c3e:d18c:1d7d with SMTP id
 a640c23a62f3a-c46a921eae0mr450266766b.22.1792781359196; Fri, 23 Oct 2026
 11:49:19 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org> <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com> <CAO9r8zOWW8+ARqvjtYYZbBCH26s0YhwrqHTaoXeW9DcFR=3BXw@mail.gmail.com>
In-Reply-To: <CAO9r8zOWW8+ARqvjtYYZbBCH26s0YhwrqHTaoXeW9DcFR=3BXw@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 23 Oct 2026 11:49:07 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNWAC8VEfKs3VB74_WTHeN113Hi1Nvb+BxOVpc+BhptxQ@mail.gmail.com>
X-Gm-Features: AclHuK8FGyKBCpsF-5BHtbxXzqsTxw_wUf5CNlBQO39pbIL8N2kuJNTEx0AhATg
Message-ID: <CAO9r8zNWAC8VEfKs3VB74_WTHeN113Hi1Nvb+BxOVpc+BhptxQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>, Wei Xu <weixugc@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 28A861C0005
X-Stat-Signature: 5ju3asehu7deoyndncf3q7yoxjodgjqq
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792781361-530991
X-HE-Meta: U2FsdGVkX1/F2uAM/B8x/fXEDW+9j1OL/giDpMj7jR5260f59gBY742GaWft8CLdQ7kaxBwhIKvpHr19b3YomVBR+vQirdH/GiTGMUAhVfK3sSDDwo8LUSLxO58zAiie3VsyM+jSI79RqpXtX6Uy1gAVCdjO/1ViZKusSo+wFwOj6YRfAq28Kd9K52XguA7ZzehpsmtJBfv3Rc89RScTGagnhpmbRoHQyxLxjGsE7QdTOg1hGaYuuFpu5tRH/SId9accAGOIFgq0oiexxqzHhgKbCr4MeVvYGRUa1PHlTLbOjXX76uQdsuxFcWCm/jT9QY4Pbap+8/7o+HWowgYeilf2aoJsJsyG7vQAajZpE1ewOG50FQ1XqGncHhFXn4Idr1NgbbVgWzZ25zjkY4JqGM6ITyP/AaSxSkJvYbEUUB77Q4n3FZqZN233sgaMXpPOYMMo6Ald4NL+0QtQhrppR3TNW9ThtP9JP05rGyy9aR3yuwwIDlAASLERZjMuUc8qxEUkJKqvgoCyxzSW8Er0b8SRKpfwRA7QMc8mFNha5uTr04I7rM/t0HmdYr9Ymn4p0mvV8mmOjGRYtY7axDgs7SP0LdUsrrrcoglArRxIrb8KJsAA38zRdgNE7mQAdor7iLwy8/H3fOXi32SJiYxQoLNgLAPRCodZCrnCySETXKvj/8T0dZBPckS9Jp8lwohi+QIb/dUMgzxdF4uyYoELwmKVDLSnySuyCPleYh/x0hKWoHQ5/+X2+25SmNzzVTaDI5+XRryis2hbqJN7YkMOjcpdpDyZCPAli9f/kOP6SF6kz2KqIgiBM0uhUOgvIJ5iNbnUcZj0pvwSUDq7P2fxpFMyCdGL64IN9ZYy7wm7YvHD4rE/ZZxSXypkUzKSYBeM3K6G3248vBFCiu4YZc7GXAbYfimy9OqIRhxD7u4chfDHMckaefnQXHuAKNOKennWBvqNjyjkd/EaA0VAs/Y
 FyHwUSKm
 tOKGk4quKo+aJv1w45IHwhovbKm1hllHtWJGW+h1d8HBIFq9H3CZLZNdG273Lh0lkHke/Zu06KMR0vf5GpRhTadz5RAYvTSNTzL18MjkIqnp4/RYIADJ24Gf9oN1bzwjYToAAFqBxGIMJniXVspo1nyGDILif0u6jphk5KYkZz42msBnEJbZO1GlkLuK2D9VTAcHEToXQSEgrJx0cG6mrijo4xkaa7HKDOz6R7QZvURjfZgjACXOpIh+c4FQO6HHf9ZClrmCZfA7qTdky+aFJKnkvIZytWRBszPiaub9I8iCaCzQAutAC58kJut1sMRLjqGlApM7pIjOxok4lJ1LQC8qN2zW+OyOafLaXvSmLw3ZCz3enh2z5Zw5ZRg/RhP77XltaPQsggB/qxuaCoQD2rq39uE2aw7RDdhioPvUtOUNhQXNt6dBG0xGdxSYV2940FZD2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 11:48=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Fri, Oct 23, 2026 at 10:24=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wr=
ote:
> >
> > On Mon, Oct 19, 2026 at 5:35=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> w=
rote:
> > >
> > > On Mon, Oct 19, 2026 at 5:28=E2=80=AFAM David Hildenbrand (Arm)
> > > <david@kernel.org> wrote:
> > > >
> > > > On 10/19/26 14:24, Nhat Pham wrote:
> > > >
> > > > I'm traveling this week, so it's a bit tricky. I cannot make Thursd=
ay morning.
> > > >
> > > > On Thursday I'll be traveling back from Cambridge. But hang on.
> > > >
> > > > My plan lands on Oct 22, 11:10 PM. I should be home around Friday 1=
.30am - 2am.
> > > >
> > > > I could just naturally join that day.
> > > >
> > > > So one day later would work for me.
> > >
> > > Would that be too rushed for you? :)
> > >
> > > For everyone's convenience, this would be the time slot:
> > >
> > > PDT: Thu Oct 22, 5:00 PM
> > > EDT: Thu Oct 22, 8:00 PM
> > > Europe: Fri Oct 23, 2:00 AM
> > > China: Fri Oct 23, 8:00 AM
> >
> > Hi folks,
> >
> > Thanks everyone for attending - I didn=E2=80=99t realize swap was so we=
ll loved :)
> >
> > I took the liberty to summarize the points being discussed - please let
> > me know if I missed anything or misunderstood any points:
> >
> > * Swapfile sizing: Kernel kept swap slots after read faults to save IOs
> > if these pages are swapped out again, and thus needed swap occupancy
> > (and hence static size) for a heuristics to trigger reclaim of these
> > swap-cache-only swap slots. However, this is not useful for fast
> > compressed backend, and zswap invalidates its compressed copy on page
> > fault anyway. Vswap does not need this heuristics because it just
> > frees up the swap slots eagerly on page fault for in-memory backends,
> > and rely on the existing slot reclaimer for physical swap backends.
> >
> > * Logical footprint limits and charging: cgroupv1 allows logical memory
> > footprint limits (unique page tables). Cgroupv2 controls physical
> > memory and swap resources separately instead. While virtual swap
> > entries continue to count towards memsw, cgroupv2 counts only the
> > actual resources they consumed - post-compression size in
> > memory.current, and nothing in memory.swap.current. While cgroupv1
> > continues to be supported in its current state, a cgroupv2 transition
> > will present a problem for memsw users that still needs to be worked
> > out in some form of overcommit control.
> >
> > * Swapoff: this was brought up as a request, but we ran out of time
> > before we could discuss the motivations and use cases behind them.
> > Folks interested, could you explain as a follow-up?
>
> Adding @Wei Xu for this.

Actually adding Wei this time :)

