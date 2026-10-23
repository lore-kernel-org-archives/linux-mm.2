Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E75F3606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 18:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mJ62D+sH
Received: by kanga.kvack.org (Postfix)
	id E838F6B0BCC; Fri, 23 Oct 2026 14:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E346F6B0BCE; Fri, 23 Oct 2026 14:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D23AA6B0BCF; Fri, 23 Oct 2026 14:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB2666B0BCC
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:48:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B55B7A01F3
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:48:42 +0000 (UTC)
X-FDA: 85354777284.28.B7F5853
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C227A100008
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:48:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mJ62D+sH;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792781320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E2FdSZgW1ETVNdAfDb/5mKk/9Ymglr13dfhYqNbiU0s=;
	b=Eua8APpBykW8NgRS4fFCSdZuDD71DTUZcPTA0XZ8Lcm83XIxHiqkG4iE+lpEqYB3FT/OeB
	P3zDBbL+qBwTalY8rMMl8l2tudKxD++AaVj/Q6GeBEnBg7xuiN/mMsuZdisXijHoCoDoqx
	TZK7MoKD+biDixj/81aV1mPlrsvdnWY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792781320;
	b=71qzoOFxGvm2R5PObEAZKUq+kc8gKqoSXlmLC8iS2//mvAtNCC+mo5FkI5Tx057AcD9lXD
	9budIkWckVDGL/VkOK3HuYj+SfUCHwiBEaMbQYQtT5ahAuR98feii9qeFk/P/Skj3a6ywP
	mtjl89RRXe2L4E3jyYV3afpTSqh62gI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mJ62D+sH;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C43DD44226
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA711F01828
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792781319;
	bh=E2FdSZgW1ETVNdAfDb/5mKk/9Ymglr13dfhYqNbiU0s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mJ62D+sH0WW6xEP+v8vbFt48woN5lul0pgNr07iTBBAgUoh+wbpKB7TwGb/SrOhfV
	 cSnm0pCHFZSN/YYlqTy+159i5VENlSenT7ywmZnkFbWsyzLJ8iHuaGrM6Pn9g+2DdS
	 zmrTKvHzqsBa9w3adygfvKcksiAt+4R2TayGY6JWxGLY/46eweV8QUlESTKL4T1JV3
	 L74m1a677qqTjvHEH7vAGWlr46ZZibA5Q3kUuEHgG24N+I6wgBRsLC7yzXLMPkPVag
	 msxfoztMcaxY1gOPzps6rdMdmd+VY2X1a40sMNLRenovvHxd8i/KRhw4Op3jwIa5XI
	 6kHceWodhIQoA==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c263415982eso158852166b.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:48:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByBYSjgY+RecNB/R2ZZ3e42i7eAiwvJsp80KppY6vDsbsggeKTi6QucG931GRO5EJoPBQFPtohKtw==@kvack.org
X-Gm-Message-State: AFq9FYK0m1iDCCo22IskLyQZvvgR8AjQte38VKeFY/1j2gU8JXOKceTY
	v6evV3VaJeAhx+f35zHJ4btpq1gX50psWQ5vq+vISbw+iOw6X9UKBAkqiGBwWgmW4Kgr+Yp8pO1
	aCT8cpEyG/59YFMEkm62JxbjUnvW0Y3M=
X-Received: by 2002:a17:906:c10c:b0:c40:38b5:d784 with SMTP id
 a640c23a62f3a-c46a91fa71emr509539566b.22.1792781318187; Fri, 23 Oct 2026
 11:48:38 -0700 (PDT)
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
 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
In-Reply-To: <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 23 Oct 2026 11:48:26 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOWW8+ARqvjtYYZbBCH26s0YhwrqHTaoXeW9DcFR=3BXw@mail.gmail.com>
X-Gm-Features: AclHuK8Vn1TWyOOSO3vLHubmDo3arJfqe6mLfCmYzhDd5kWYgbQ2Cbog3YjV-tU
Message-ID: <CAO9r8zOWW8+ARqvjtYYZbBCH26s0YhwrqHTaoXeW9DcFR=3BXw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
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
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C227A100008
X-Stat-Signature: jsphkw1rsczp6cswsocxhewxkjd1kwc7
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792781320-282917
X-HE-Meta: U2FsdGVkX18mQwuxWHF+eiL7/rwRuCQ0xq9OLRl9/qNF9EjmYwJPDm8cMnKghfwsEPf9vWey5J7fr/nS8CMD+29RwkNGwYKv/fLTdHT1ovW9lGVWAnqI70S9j2QPvMYteDMfDgMnUArNqlxbOCvbrDDPh47z/1eJ3aZCWK30q9T9/GCW4Ds19oc6GXb8UjwAlcwXFxW96QvVFOP+Pf8sQe2XcAyA2T0F23/3ov9T9nhY6sD++P/45GpCk4+5Pk+Mrt+GVHsaBSK/j2fr7t0ZKqgZFT9fMcxHikQEhNtb8XYkNjxmQAJObYxwLVs6mSktwOGil4ghTry7A/rV/zb3d9RadxXdSxaxre2/vjizwNI/atBOj5CEMDOa3uwX7cYmqoq+hqX7dNRalncXlY0hLLIC0VnijP3PY8PuBDf/OKgnG+F6fkpLvunj+pFGuDQzSqJ4AHLA+0NE/M2LrIfoN/wvxRMtqxibhP5DBX0WX+J1Tn9BxsfPXZRPt7HzUsy8sCGWrsNGeuHkEL+wTe0//jh+VyQTnHw+UfPYNEZcAafqwD/btQBnGQ9bVWc2yUuGn0P5f0D6+5O0YgyS+E2i/2qycT6NEOq1Y3S/sLNT4t82bowvDhzux474jF0aHf8Rkxpb/cuGnYAJbZOu6+Pzb7fD1UoEHof/exiynnwUuTmtl6Pf9hJwnF93PlnEqZEXBZZTCppyQ7U5gOz81AX5m7ay8wd+aVq/LFxap5zqseoeauOresknZ79bOOCvaY+Y2KGaoqcKrQC3xh8KF2KHN0DrR2h4Y+JaiHi6WZoJQW+zL3rAmIykOyxnyoUwVMbxJhmJT4LfSXZYWN09a63kfHF9jV4okfVqddSm4r4aBlM9W+HXMfMIzQrkReA1W9u11uoOd8qTZMR4EyNJqUce8Srz9F6GoBQnzbkLwRJAs9Cxxo2A6B+sQ36/E8rWGjqz4etJUy4+kV7PNvl+xTV
 spicm43o
 PgGhI2yDmRwJRMFNpXKk9/OxIoQ5gRcdFUJWwXAuae5owPVdXH83Cz029ynXKM/j53E12K7LwKKwH6zGUsfNdZ/QXtBbTGhYiuJo3+FVqTCnlwPG7KgHZa4v0+2MLDkIgwvp+4JLuh0NKPxOUObSGw3PZuJ3zCJcVNl+1LZgsgLv/qW8rlNd5wrjFOjXiPt/XvEYdwFEyzypVI8HPSsGBv96HQLA3tuFY7V8xS+lqCnla/Yt+f6zcjoQBr82tLpwtFRgi6CLKyNQ7f481y1tgeCx7NZZtQ04BE5EsrPXrATXTmpp0+FhDsQ+O9C8Nn5pGQwUNrxfNNxQsK6TrzLj5a6syutzX5ywKyqYQuajZwsDGwZTKeLl4O1AFT9/fzpfBgO/fLwCo8O4dO36m2QQ4HytnlwtCi+7tm+hytoegdkDKQy+Uts+WPo781pEXtaGEta39mTQGIQ9sDfg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 10:24=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Mon, Oct 19, 2026 at 5:35=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Mon, Oct 19, 2026 at 5:28=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > >
> > > On 10/19/26 14:24, Nhat Pham wrote:
> > >
> > > I'm traveling this week, so it's a bit tricky. I cannot make Thursday=
 morning.
> > >
> > > On Thursday I'll be traveling back from Cambridge. But hang on.
> > >
> > > My plan lands on Oct 22, 11:10 PM. I should be home around Friday 1.3=
0am - 2am.
> > >
> > > I could just naturally join that day.
> > >
> > > So one day later would work for me.
> >
> > Would that be too rushed for you? :)
> >
> > For everyone's convenience, this would be the time slot:
> >
> > PDT: Thu Oct 22, 5:00 PM
> > EDT: Thu Oct 22, 8:00 PM
> > Europe: Fri Oct 23, 2:00 AM
> > China: Fri Oct 23, 8:00 AM
>
> Hi folks,
>
> Thanks everyone for attending - I didn=E2=80=99t realize swap was so well=
 loved :)
>
> I took the liberty to summarize the points being discussed - please let
> me know if I missed anything or misunderstood any points:
>
> * Swapfile sizing: Kernel kept swap slots after read faults to save IOs
> if these pages are swapped out again, and thus needed swap occupancy
> (and hence static size) for a heuristics to trigger reclaim of these
> swap-cache-only swap slots. However, this is not useful for fast
> compressed backend, and zswap invalidates its compressed copy on page
> fault anyway. Vswap does not need this heuristics because it just
> frees up the swap slots eagerly on page fault for in-memory backends,
> and rely on the existing slot reclaimer for physical swap backends.
>
> * Logical footprint limits and charging: cgroupv1 allows logical memory
> footprint limits (unique page tables). Cgroupv2 controls physical
> memory and swap resources separately instead. While virtual swap
> entries continue to count towards memsw, cgroupv2 counts only the
> actual resources they consumed - post-compression size in
> memory.current, and nothing in memory.swap.current. While cgroupv1
> continues to be supported in its current state, a cgroupv2 transition
> will present a problem for memsw users that still needs to be worked
> out in some form of overcommit control.
>
> * Swapoff: this was brought up as a request, but we ran out of time
> before we could discuss the motivations and use cases behind them.
> Folks interested, could you explain as a follow-up?

Adding @Wei Xu for this.

>
> * VM_SPARSE v.s xarray: no performance difference between vswap v.s
> part 1 of the xswap=E2=80=99s patch series. With all 3 parts, there is a =
win
> for xswap, according to Baoquan=E2=80=99s testing.
>
> Let us keep the communication line open and coordinate on the next
> steps.

