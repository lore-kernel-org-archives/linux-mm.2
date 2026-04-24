Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 092F8FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EE7A6B0005; Fri, 24 Apr 2026 14:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 578226B008A; Fri, 24 Apr 2026 14:08:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4400A6B008C; Fri, 24 Apr 2026 14:08:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2FEFF6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:08:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E2E958AAC9
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:08:21 +0000 (UTC)
X-FDA: 84694234002.08.302C5AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id DE16D1C0010
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:08:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AksPa0TK;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777054100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=55X1Ukfwu/jt9RcvEySRhlxyGt44Y5O6N4aHBq/JXP4=;
	b=2+0ZJjqxpZr9x/hb7FTXkm5VGcdxc26WkjJLQ3BSOL35m1hGSdJ6xMe63euplmUK4kGzQk
	Fv2Spz/YsHGYekTQ+96smcoEmGs2sNxIEIKqn8xeeFZmdL+zOm6av9S+zY/NkmmHXt7pqy
	5IY7I1ufb6pveavg+4XpC+DQKvzHus4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AksPa0TK;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777054100; a=rsa-sha256;
	cv=none;
	b=1V1PFNsRgkAV7s5HMiQsVEMoDaYmyifioCdh7PrWKR+kJOJvI+VY16e4A8tWe6okr4TRyx
	A2cI6utE5ORRqip+3/f1SPUNqHksf0OwCiqAN8mlx+dF21oK9S/VJC4Vr4iUscAF7z7Szb
	YlQqzv/mKSThuvICvbYT2K3LQKpFL4g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B3459445AA
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C7AC2BCFC
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777054098;
	bh=55X1Ukfwu/jt9RcvEySRhlxyGt44Y5O6N4aHBq/JXP4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=AksPa0TK94G95mOVyxizQ6IJd/DC7Jh74PX7tJ5S9e10bVvw4lPROnSbfV7XwnIie
	 VpjKcYg08Y9LX5ZGOIzhgl7wspRdAlNTNKAbAv1dUWik9h1S3NcaYhWLYvMB7FJOI0
	 55aM/60AHenFDCAIyQLxtHJLnPVCBPJEDxWwePDlENj4E8kpvYl/jJr1jORPHPc8Gr
	 Dkgt+CeX8jwe2++pz7a4ytorIAhsEQtcjyi6f3CoQVq+KaJdqJT6jNMEObEYAcgkf+
	 ktnwfrNU+pR+AIi0sjSeriXwtlXh2HAlcBpC2SV6PAKE+h0PMMmcK/eGNqQJ69pmmY
	 10d+fap16Zfxw==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ba699316b42so991800266b.3
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:08:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8Fh5FuOG0GEDwcL2Fv1kECXIYZkSAisTniJz+rbAgb9Ui+CxY7HYlsL/bx35pC8vsGlc8IXaVu2A==@kvack.org
X-Gm-Message-State: AOJu0YzxlsNfxQYiNDsBGUHLLq0SOCHVa5kcgB/Ooq4lrUScBDJdo5qH
	4m8a/ITiVPzGA2TbWmBvPmxS/Efm4eykM7ZCBTYDB7wB2FN6pdOp6/t8Zgv/b/9EGBMhBWA127f
	G+YyVOUNktKOjtZCnWrP2GUuklwCiuSk=
X-Received: by 2002:a17:907:3c8a:b0:ba8:2ebd:dfb6 with SMTP id
 a640c23a62f3a-ba82ebde295mr1194657766b.23.1777054096988; Fri, 24 Apr 2026
 11:08:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <aegUoOiUbjUAH5aT@google.com>
 <CAMgjq7C53WRS5oYxO157mX7JxhfoPoi34k+taiKLrMah-b-iRg@mail.gmail.com>
 <aektdlD4npMVThu3@google.com> <CAMgjq7DRrz4Hdy-s4y-C=3BmPt50LKOfdWjjf2mWmCybdRaJ4w@mail.gmail.com>
 <CAO9r8zPvApgxKiVy5NhiWup_m57huF3MTuPvo=iq5kAxjRZC8Q@mail.gmail.com> <CAMgjq7AGzBubCkmv7LubBjPLN1DzL472d4zUm+sGxo8ZptMgRw@mail.gmail.com>
In-Reply-To: <CAMgjq7AGzBubCkmv7LubBjPLN1DzL472d4zUm+sGxo8ZptMgRw@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 24 Apr 2026 11:08:05 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO+tm2J0FRC64VKCYOSuKPXX8cQG7C07SwMWKoLiwoV+w@mail.gmail.com>
X-Gm-Features: AQROBzDr9_UVPkP7ii9e54NOgh6DRtA53gr5DNXjoPLdfydsZ8BCWlPjRr_6fms
Message-ID: <CAO9r8zO+tm2J0FRC64VKCYOSuKPXX8cQG7C07SwMWKoLiwoV+w@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Kairui Song <ryncsn@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	akpm@linux-foundation.org, Alistair Popple <apopple@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <bhe@redhat.com>, 
	Byungchul Park <byungchul@sk.com>, 
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
X-Stat-Signature: dgej3iicerr6s67rh6bojxxk444rqxbb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DE16D1C0010
X-Rspam-User: 
X-HE-Tag: 1777054099-771734
X-HE-Meta: U2FsdGVkX18SzluZAPkHLVGK6SZAVcV3WvIODwFK07Hv9HyZrL52G3LV8mrgw7eQos4+bsO+TdcnU37KR5Hd9tqBNuN38OSVNDnGDJGJ7eAQCP3jK70EkcVoJpL8x+Pgfy8ul7VK4SGWgg5kZtOFtMHRlzPiSQxohHVNz/4umBhRzbc8L/40/zFc+nadaaXuSN87gTQyHzJ0OfBMuQN8oD1r2JnBh1IRIfJ8BR4Q/0N+olzJaiQdHD5tG6MLA02BxDCraWNP4+3FhZNo2Yda8Uf15V4d5UKvtlFoxuJD+kbvVszR0EaaEjT1PRzVyNnKQhk8qEz6ad7+N79d10uVvIGSJXjIuWKbcNrksS2iHpKMQkvA3wb6BP9V0veBJCC4uft/aKNiATFRRJr7aHxQNxxIwzl2ssx8jUjeE2T5vZ91zDM8AHcNUEOKPW9wq9iMG806A+9RZUJ5cS5iHVSeNPbooVbndOv5kPXhFm8cBrfMCLN4Amnz0o1dO/NMoVyQmkKtIoIGxklCpGPJSgw/z1ozv/BlXzajL5HpkDuJ0QHsfWJh5osWY8sHIcsuGQ1Nc/GBuSUIxWF+Vf3eGl2FGOA3P/znnvyhCboWenLKwnAtYanyg/mWPiPO0BHa+FFkIYhO+sPyG3cXwANhz0mMzanDsPBUcjTA5M8/bbdL1SM9nCTzTOTAbQRHH1SUkVuCvEvhgKf5UmMVhlqeuB5AfaJ9O8G2G2ObK3b0BXXNhtUWwSs4fTd0bdcFZTnzeGjvHfx6zFjMf3AackBq6Zr1dEo/+0AGLg6dYrqEtbwkrm7y7is5sh1UeVcgDKXRpid+30rdrkCFKPTjb+aGyi/9gvnwoHAhmpIPvnEwl9bD+4Y4nK3Rr2BTzW/qLNh6IL3Kut7q05AXOT/Z4qqOubHsXX2rYv4Hp6K4SYgyp9PCvNtg1rwblR5r+nLq458y6ZHYMp2dkyTwYp7PqoTy2m3
 8glPYyMS
 kz3Rph0GEdHmfE0dfIyKonPfXZLp2tYDZimLNmZ9mhVALfm51MqKzG5YWDJ/qp0dfIovR4UGyEUkhF7Hc7jOGwdlDllkTYQwrT/6o33xakx9q/DCWnTAeoaD1mzBy+wRbMwWf26+hm+O0FqzyeMfmRDEOuoMxVou/zYzYKzBR0fHOG25L0Ch/wzJDPSqGkJ1CzFHWu20gL8xZkvoH3yfcFOY7jaMFiJ67MzyC2/PqrxIqyijkmhSpoRNc/CNiG9oLg54b8PaAb+Wj1zae4fXB8eDzS/38n+TDo+zbmtQ7NKNytzQ+ZEL4WcA+nosqAnNr7XqwGoIHasfC62YChJFoqge20CDjJGFnwBLoZADopt3SWY/j32YukvFUI1mkTPRVbsgq1IYEshQFkNr5K58wlxAJit8/H7flZrOwtmRnFAnLDrQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 9:16=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> Yosry Ahmed <yosry@kernel.org> =E4=BA=8E 2026=E5=B9=B44=E6=9C=8824=E6=97=
=A5=E5=91=A8=E4=BA=94 04:48=E5=86=99=E9=81=93=EF=BC=9A
> > > Using a swapfile does have its benefits, though. For example, the
> > > virtual layer could act as an ordinary tier following YoungJun's
> > > design:
> > > https://lore.kernel.org/linux-mm/20260421055323.940344-1-youngjun.par=
k@lge.com/
> >
> > Hmm I didn't look too closely at this but I don't understand how
> > making it a swapfile helps with tiering? If anything, I think it makes
> > tiering more difficult. For tiering to work, we need an
> > abstraction/redirection layer, such that we don't need to update the
> > page tables (or shmem pagecache) if we demote/promote pages. That is
> > exactly the use case for a virtual swap layer. The page tables point
> > at a virtual swap ID and the backend could change transparently (e.g.
> > for zswap writeback, or tiering).
> >
> > If we make the virtual layer a swapfile, how do we demote/promote
> > without updating page tables?
> >
> > IOW, I think the whole reason we want a virtual layer is to separate
> > the backends, which would facilitate tiering. If the virtual layer is
> > itself a swapfile, wouldn't it become one of the tiers?
>
> That's exactly what I hoped, virtual layer being part of the tier.
> Tier could be set up per task / cgroup. So is the virtual tier.

Just to clarify. I don't think virtual swap should be one of the
tiers. I think it should be the mechanism through which we implement
tiering (see above). I am not sure if that's what you meant.

>
> A standalone implementation of the virtual layer is more heavy than
> being a swapfile. Actually I think at this point, it is the word
> "swapfile" is misleading now. We may rename it to "swap mapping" or
> something. A swap mapping could be physical or virtual. Virtual
> mapping can realloc from physical ones (redirect), and swapoff of
> physical ones just read its data into virtual mapping's swap cache.

I don't understand this part, please clarify. In my mind, all
references to swap entries from outside backend code should refer to a
virtual swap ID, which could be pointing to physical swap or zswap or
something else.

I *think* what you're saying is that we should make that optional, but
I don't see how this would work. If a page table is pointing at a swap
slot in a swapfile, we cannot do tiering or zswap writeback or
anything dynamic without updating page tables. So even if the system
starts off with one swapfile, we cannot assume we won't add more and
set up tiering (or enable zswap) after that, right?

I guess we'll keep the swap table in the swapfile and then we'll have
it point to a different backend, but I really don't like this design.
It's unnecessarily complicated in my opinion. Page tables will either
refer to a virtual swap ID or a physical swap slot.

I think we can simply have swap tables representing the virtual swap
space and pointing at the backend directly, whether or not we have
zswap or tiering set up or not. Is the overhead really that bad?

