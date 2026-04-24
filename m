Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77AB9FED3F5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B40E66B0005; Fri, 24 Apr 2026 14:05:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1C46B008A; Fri, 24 Apr 2026 14:05:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E07F6B008C; Fri, 24 Apr 2026 14:05:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8E18E6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:05:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA1DEC174F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:05:09 +0000 (UTC)
X-FDA: 84694225938.02.E7EA273
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id BF8E34000C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:05:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tK0OJuN2;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777053907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wCED2gyJ66NMivSm3uMeQZjOR2fIAqNWj1/nJY0+EM=;
	b=2PoN8rlN/jyypn0tDAqradYP0JPTAWfk7zMmFbOeS5Z546ISPmFvWV20V/Wv6Z2+EPP9ON
	ZkbvrLwpEHb3Y6N6Iv7dkepo31l/JPmwqBFVbuhWK4cHZqCG/BXpEMSrRpG/70wRtA88aQ
	h/1gxg3FYdimzAuZYxRD+0H4dnP96Qw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777053907; a=rsa-sha256;
	cv=pass;
	b=l6B36r4/H96+AYSKsn7tTC0BfM9JBuQUpn9plbriz3yqMuaSz7adTAQvJvPZgdrl6l3OSk
	M/1BK3HxSOnClAT7VDKKoSg5FCvNLothYkhoBipN0UrEf7hZgp8pXaze+WMQbD+dGM8gLE
	6/842SgfmPBINUAw6w2ynRQum+U+RQ0=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tK0OJuN2;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6788838d543so3901591a12.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:05:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777053906; cv=none;
        d=google.com; s=arc-20240605;
        b=AXhdazFTDNTqc+IiUyGZdX01iq65HOX/efDYsJ+2hMAsHXCv/Pib7BdxsCCxC4Eo4e
         bTtqaClPNzAi7mU+eR6/DL0BYkSMqs6u5ZPcg1iItyLIae/4NWbj2dVlywZ15/BReiqn
         Yr0ebba2u34GmvpI1KiuKxE4TZqj53g1MCyBd8vFBR+f8xlmVXKfZFflKQdpmr6sIkmV
         HebOT1vfmCjU0cQiwjl5c10cHG/Fl4hLeXECKUSUaRpwxmmA7Sdj5J5hxmtmVOIys4dl
         myIsLkFK8fXCkjGaJJYXGRUGDMD3luwxACxyhtGjbPbRTbukUlPgh1H4wsq0Fyzyt/xA
         B53Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4wCED2gyJ66NMivSm3uMeQZjOR2fIAqNWj1/nJY0+EM=;
        fh=0LbIet+msPiBSrBWmDxcmr9QLg14eGTUleVmGxdLVGM=;
        b=fJj1YND9atjIn+iV+u00K8kGbsbaW5/5nMtd7gn1yleFYQkKyVXWqUTJoDfV3GVcdQ
         iXFFf7MZzgykr3VsAWBoQEM6XL03UK4foeKYM4vl8VJyaAzyp7ZH8CLRkYrUWhXgtJzy
         jTh+NoxHpOAivO+93PKiuLz8o2EoiAD2kQNiZPJh2b2/kW4mlDsmXkBmLlkcHVDM6a1U
         3Zq9yvVXJ1I1d0ccgNtUWJftx561zM4DltSagX/6fF4ZzJz8YOsxCymomIrh9R5zi1Hn
         /fqqukKtdMiL4vFntYG9HrGctsZbmVxHrcHYGPUV0mhDEeZisoToEVBMyj3DxGGXY+E5
         FUWA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777053906; x=1777658706; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4wCED2gyJ66NMivSm3uMeQZjOR2fIAqNWj1/nJY0+EM=;
        b=tK0OJuN2K3CLuUZZednARSJKjhC/a91HS39/2Y9zlk2LaStJH45a24oSR3ggWJOE3V
         L2MuZgqJtIhx+6trKY0LFkSlMN20wzgpoaPnpH/Qod7QgAhv53gk/CL9P2Cl4nN4yusx
         Q9ylyYFagDaGlPb325lmGxDMpsx/hhjcy1F5OmGyMeR6NaGvOdF8NAQFBtOvCzEprHQs
         zR/iEk5cihBg5cu0IuYuRUQKuu/GMwvVyaHIlJmJfqhr3VMvhXIct0qhT8cEN9C5F4ve
         sI8ruLlUXPTFbn7x9sNFIUAmuOChzrjZT+6GcvQxqYme11G+Dd38cMFDNQYSuylGEoE+
         K1ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777053906; x=1777658706;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4wCED2gyJ66NMivSm3uMeQZjOR2fIAqNWj1/nJY0+EM=;
        b=IhmeOg7oO1pRCkfi2xsb9IwCTdDEVcJdbcZjlC1PAK+Wg6rBdyvSg0i8hxngxZ6yo7
         jlPH7BHDoySPH6wOMl7oj6Fvs25MYwp6dBTMFacBh2XWgQRZObrZftFGw5rIr95aWXtw
         ENy4iW94SoGlw8/4U3XeGDWa4EX2AImCDkHayRrsBBP5qHXLC+9Qa1YkeBGaIAeuVCIg
         0czibDH7nGIpkGQuaw9gRXfBPDW6o0ZyX8UPu7Wek88qZtbj8ydWrHxHEfeH99V5xJXr
         2sN+Z97mJ7yN5D8FEwtb8IcCxogXp3q3pThDBnHoaBlEtKqjtqXEAy/mixNGkuTg1HhM
         Q4ew==
X-Forwarded-Encrypted: i=1; AFNElJ9PGisGoOumXKoObuyOe/8atY1XKAA81LYvBXTgfobOIJWXSrDe84UTreURfhf1JU4B/70FPvAhHA==@kvack.org
X-Gm-Message-State: AOJu0YzdMfQAWeWi+VSyPZ6xS3ixf2L3s8HwRLt0YB3oYVLhDUoOaLIt
	pbVywf5COwHRnuevGk844UtxgZeJ9FrStdgUsTOexTpZ4EK0D2k5psxUCBfvbrSSj8aoDInWdDn
	RwAjcU7WybOU1WBY5XR+riIC953ytotM=
X-Gm-Gg: AeBDietIesU9vuvYi6jOI7BlDw9eIpsXQDyd+cwqbqwrv2O37S5NECHTPcB8XIozjj9
	+mkjytpR2DNBuyoqTjb8OxKHRdNwYW57iu6vINNc+ICARcWwDAV1lKzf8HByjeQXF3PXDkbI0+F
	KF92cZZlaNVtrPxUH+Fs62ZMvVwWZU7u8FV3u/wL61M8TteL8y5mjAUMzRsKyRiq2dhS2zh5BqV
	TyGEEH2sfilF83DrrPUnOAbySIb1nFq7g1NNnmVDWjOie4gA5Aof9IvszhZyyBtAacj2qRWY6tZ
	gtiYWQjz2I6a+oukP1P2azMOeWIz3vZZCSfHp2mcVKZ+2khVpT6r0LuyD9TbuQ==
X-Received: by 2002:a05:6402:5051:b0:672:c366:b088 with SMTP id
 4fb4d7f45d1cf-672c366b207mr11251845a12.8.1777053905724; Fri, 24 Apr 2026
 11:05:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <aegUoOiUbjUAH5aT@google.com>
 <CAMgjq7C53WRS5oYxO157mX7JxhfoPoi34k+taiKLrMah-b-iRg@mail.gmail.com>
 <aektdlD4npMVThu3@google.com> <CAMgjq7DRrz4Hdy-s4y-C=3BmPt50LKOfdWjjf2mWmCybdRaJ4w@mail.gmail.com>
 <CAO9r8zPvApgxKiVy5NhiWup_m57huF3MTuPvo=iq5kAxjRZC8Q@mail.gmail.com>
 <CAMgjq7AGzBubCkmv7LubBjPLN1DzL472d4zUm+sGxo8ZptMgRw@mail.gmail.com> <CAKEwX=ORdgAwaJLv8CidOQZ0r6ZBHkDYVUxZv1k2PiaZi3qe+g@mail.gmail.com>
In-Reply-To: <CAKEwX=ORdgAwaJLv8CidOQZ0r6ZBHkDYVUxZv1k2PiaZi3qe+g@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 25 Apr 2026 02:04:28 +0800
X-Gm-Features: AQROBzAYXcS_1H5K9HyPupUmr2KbUwpuBsIN1OBxlrG3dClTVKgn5H7GzhL8dcs
Message-ID: <CAMgjq7A1YLyxBKqVi4moxGPBh0wbnehW91uEqxrNUm2ziTy_dQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, akpm@linux-foundation.org, 
	Alistair Popple <apopple@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Baoquan He <bhe@redhat.com>, Byungchul Park <byungchul@sk.com>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Lance Yang <lance.yang@linux.dev>, lenb@kernel.org, 
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Matthew Brost <matthew.brost@intel.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Mariano Pache <npache@redhat.com>, Pavel Machek <pavel@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Pedro Falcato <pfalcato@suse.de>, 
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>, Rakie Kim <rakie.kim@sk.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Suren Baghdasaryan <surenb@google.com>, tglx@kernel.org, 
	Vlastimil Babka <vbabka@suse.cz>, Wei Xu <weixugc@google.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Yuanchu Xie <yuanchu@google.com>, Qi Zheng <zhengqi.arch@bytedance.com>, Zi Yan <ziy@nvidia.com>, 
	Meta kernel team <kernel-team@meta.com>, Rik van Riel <riel@surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BF8E34000C
X-Rspamd-Server: rspam07
X-Stat-Signature: m7gjr4pko397fkckpm56qu396c4mo9oi
X-Rspam-User: 
X-HE-Tag: 1777053907-700618
X-HE-Meta: U2FsdGVkX1/FwCPdSf8jWQeakCNSDp9lqED0yPYtDudsda9iRWN1Awpp9gsUvXiHxpReroAmuOveEetbyv0CRtaCIYXqg36NuWiHRAF3lLu9xGl6YyW1HIP59SoUsVSh8ZrbDZBLLF9B2Y437pt+LeOh9WioJd0TB81ntvBO8c2CMbVg22rqwlm94AL+17A6RjY0HKmHNB8g/4oLFMtUJ8lXEwMN5cMM39nfZzj45JDQi5b2oJ0tXYG5p3dRrjiXYWOUv2EHc6acotBjoqS5Ox58XSRMrMkO/37xvNfMB+kiLVGN341hlE5o7sKM5dYw3Z7fmVRTiW8Y3AWFZfpKKb4qae0xcjaUCOZDS5/8ZLywwZGZziEWHn8Lxs1TSQVy1Wl9SbcADTeAXvBTcuvw+vXa/MpkDXJh4bvOJRZ74y9tfZr002bt3zay4TJS2O8uASPW4ffKjozdjs8DvFXF8FR/YRdLraBAy6F99BQ+BdDbwzbFUw1OZ6PxO9DNJ8kuLanHvaUlndd/eFCHCV2z/7cPRefo16ykqnaMOW2owTNfqZmvSQwWrNygx5eQBi2TqfWQw8lG5kDyae6l34ov4lmB4YOHbyTDZyQkI5P7C+rHagIkJjtEg8l6MpqO785LjGJFcMVygogBQNWXXcnc1w4vzpjv9jlMYxrWnriQ/hrhcPRpDtVArUDHur2PLN+sThvR8SuuIJ8oRwRsJ+UhXUQJy2N2+zPkvTQImcXkQxvOS7nEgL2FxsLNta5q7i1miKtxtpuc2y7VlOL+O/r9lbvRY99L86sRRB3TvhKDGPR7heFOuK7saJZuEhH3xUSnFsxLXFygjEWK6KR+AEIawDEO/tzq+uRNUwWbOgYHFKZathcT83NCVAoTSml2vPKGYA0P5gsDo6oSo/VZuVFP7NzhRZwvOaRkMDGcuaAvz5eJiZ3f3gvCgwLpJF0ETZzwNUz2MNlR/eTCC7yV7az
 jyywdq++
 +CHo+zl5uzT/gxhJqm4F2/Je4SObTIwnhnp08l2dAHJE2d7e/zUlTz6PkGS/NLj/9e7nctBFE2afTpl0ElX6wY6kCA1RG2i0lp7+ROMEdzW2QN6detw+aekzIp8x4dpvTmxo5sEdNM2HFVqzp/MSiI+EkaSYgRXAFyaob9vbS0kP8uBeZPPkGsxs/iZTzgMt0D1wjUyPzhFvPtvFqcxDiruRNW7xXJ8t6uJELWnsNedTwAElLo8/XMoSi1soKxVySGBJCJ1ZU+Xxo4+HgBS51Jr9GR3R77r15sthERLX0lI1TugNnuQlwqr5z18RgfYSDgYSUACHiMU8ZtDG9lNJoW3VQaMFexnsupyVAAe6Daxw7rzk4cpKiU1yflzmMUkDYwB8Sy5LVa0F7wlq4I/dLqR5V0XepgSpjTbSeKKKSisJzLNMdikeSbN0WOPZuPk1Bz3Xq4XtC3w0RPG8z6bXcX7BjxY2DyUP2+ORu4RhWVA+y6HNAG4WV+9ASBdS4qZ6MvTdPZUfTsJ2TqCb8G2NdglBEvL9GRWA5kik7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 25, 2026 at 1:28=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Thu, Apr 23, 2026 at 9:16=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
>
> My apologies for delayed response - I'm cleaning things up, and
> fighting with some memsw issue. I changed the semantic of the
> memory.swap counter a bit, but that makes it diverge operationally
> from memsw. Need to be careful not double charging or double
> uncharging here.

Hi Nhat,

No worries.

About memory.swap, I also thought about changing it a bit previously
to make thing cleaner:
https://lore.kernel.org/linux-mm/20260220-swap-table-p4-v1-7-104795d19815@t=
encent.com/

But I dropped that part so swap table series p4 can be reviewed
without any behavior change. Not sure if related.

> > I think it's actually functionally very similar to Nhat's design
> > already from a high level, the only difference is we don't need
> > standalone infra for virtual parts.
> Well yeah, great minds think alike ;)

:)

>
> As you have noticed, I have also converged towards a lot of your
> metadata design and operational arrangement.
>
> Case in point is the delaying of cgroup check merging with swap
> freeing - I did not notice that patch you had in your series, but I
> realized I had to do it as well after studying the regression for
> awhile.
>
> (I did think about proposing that outside of the vswap series, but I
> was thinking it would not be a problem at all with the current code.
> But in hindsight, since you're also merging swap cgroup with swap
> table, it will have a similar implications, albeit less expensive due
> to no xarray indirection).

There are actually more issues behind that. Later we would also want
to distinguish shmem / anon swap entries again, so swap cache
allocation ensures there is no conflict between these two. That is
also causing some real issues.

>
> Hopefully we can iron out the rest of the differences. I have a couple

Yeah, definitely. I think things are already getting much cleaner as
we keep unifying and simplify the swap infra. Consider the current
swap file something like s swap mapping as an infra seems to make
things easier to understand as well.

> more use cases in mind (compressed writeback from zswap, discontiguous
> fallback for swapout, etc.), but without virtualization they seem like
> a deadend :(
>
> And Gregory's cram stuff too - I think it's not undoable without
> vswap, but it's just a lot hairier :(

Ah, I'm not against a virtual layer at all, actually that's a shared
goal, I mean we might not want something mandatory, and redo
everything again with more overhead.

