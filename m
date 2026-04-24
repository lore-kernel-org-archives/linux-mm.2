Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C27CFB44A0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 04:16:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB8626B008C; Fri, 24 Apr 2026 00:16:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B69CA6B0092; Fri, 24 Apr 2026 00:16:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A584D6B0093; Fri, 24 Apr 2026 00:16:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92BC56B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:16:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29E27C2B5D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:16:11 +0000 (UTC)
X-FDA: 84692136942.10.B25FBAD
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id 102F71C000E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:16:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aTlgWK05;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777004169; a=rsa-sha256;
	cv=pass;
	b=gBvmjXtW+b5z/cwG2V8Z4g226JzS7iAFo8vqABJx/9G130UxMmyVpuQClDR1AhhETxEd0x
	9Kivwix/NWPHMhWOFZvQlwY86mN+jYOFRJy8iWkZVQKeHlwnKmRCslar2scuxksgof3Hwm
	+kryGUjlJxnLVP0SjcG5WF1MGYGVXDU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aTlgWK05;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777004169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMJoD6eFWUzy/CojiSR3e6UD5DqEouSLYBTdudhICzA=;
	b=HZo3Gwc1W2lRyKehOe6qtC3+6q905PSUzDBo3wbafVmEfh9R1E9uTARMuIaDitTOtHixsG
	DpEPH7XkickQxEJfF3PU+kgdaqklasuWDCkvvzCjP52Z0BdsB5G4CnnSdPi3j1UZO26HUK
	Y9Jv7dhE4A/zMtNsNzQ4+amcD6QKmhE=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-67785ef88feso3081539a12.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:16:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777004167; cv=none;
        d=google.com; s=arc-20240605;
        b=ZPqSbX3S98ilsOSasx+8U21myWtq60w7uy2msJ83+T47pWX33wcdJw8cCqcdmdcwJY
         LYVnq6QiJsKlu2ohTuluJXdtLw57xfszGsQ5lkk6SSg2ZHPPhHqG7nlhEqfiG9Z9NLou
         1yqlFmc/EA7n42EXb4YUkbx5e0JwOQenb/LtxxA/VWq9PBc+qGb8QVsQpcHj7sOMh0Qj
         fp5otok7mN9MpmL1bB/z68XuZKX1FHPFA8Ob61gwrM3gVY2k9IjkBqQS3461eKTr+wtT
         PcWaBSbA9NmzPAJ8Gy+MPa6X1xgg0fGLp/HVBZEPA3oSI7g+8ciBtjcQ1n5ymQrx0DWr
         XVrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oMJoD6eFWUzy/CojiSR3e6UD5DqEouSLYBTdudhICzA=;
        fh=jb1lnMHnD3I3yBVAFTh/u3hxpZlgKq+KnXf2qOQjvz4=;
        b=OaysF6zft3ubsuBPlLqpXstK2gWjwN+R3x5igq64u5Ihsd/6WjXJzUfxuCChHpVckG
         91kstCQsb8+H405rBKQuNpyAAa1ub+dC5xobpJUb6m8DzL87CcGz/msIYlaN3qtqb0sz
         3oJ4QgnWRA3Eawe5jTSyXVzHHJ1MvAColfstvtgaK19Cf+yOzzDCDZW7kS6UIfjA+2yi
         KdBFiMTBmhYrOD+hE29o/ovQcg3WzyxuTK5xyctJgviRkM/+68fWiF2lOqRkuoxnNLbH
         8LDz2tWMAOT2RuvIYPQl0lKOf3yKqrif58CZe5ojY9BvAuoez15Po7z1+XiDKqYhV8cM
         NCzA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777004167; x=1777608967; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oMJoD6eFWUzy/CojiSR3e6UD5DqEouSLYBTdudhICzA=;
        b=aTlgWK05mHKIzZ0GoRXQRg/kcWfLVKnc1FRgNFD+e4/TuZTQSzazqV/MF3oibfbVCQ
         yxflfRD08Sa2332+kn+9O9cH2mcEh5+geBAeVVhJSWZQCvxIW20Wa/h9Jm3YuUiCY7yw
         tIQhFzvG2bWdTaPr6+sH90wl5u3X1K7xNDV2x0qDNpQjlV1KVoL0Z4mERc5WrJ8xdsEj
         KbbChKBhSpPDveg05ezCeKyur6qV3rFACDzbojyNOtroWLAN59vio5poctbDDYtnKNc4
         +QKLUqXn4rChQVhlqgmCdNMqNGWy62Klail52Uj6SaTgp2Mwwe7O0uesvciVjADv1guV
         8hLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777004167; x=1777608967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oMJoD6eFWUzy/CojiSR3e6UD5DqEouSLYBTdudhICzA=;
        b=kkYAbAcD4F+K972NUVT+rnqpkz4yNw07qT5CRCydY4NZwrxESijdYJQD3myu84xRlz
         YyZPgVeHy+uDQVqpbeB3mYP22zZzg3ynVECWtNcqT61RtGHkNMEjHy50ejw/V+8JiobD
         aoSBEPzhnOJK8H1+lixmWnqWFMzof39fiVAmtPIEVjIbK/tukY5f1UBmNpu0xlYX4zdB
         nznAIki26kXflNLMbylonG04r8tjUHGuji8BKn7P6TDpcZ1L2rgPK4nF7C4PdLa9UNV4
         sBhoaBNMCwtXw//XtDrcMoP0rP8uiFrIpf5oFgONu8XWPE99ypDd9dXGPXDsQhfGfXLn
         XBUA==
X-Forwarded-Encrypted: i=1; AFNElJ+yKPh9FGseBULY3p6ZwlicG1BeaTeQGr5kNT9eUgp0lwipSi2/Vg0VW+Zhq8fs9tCpR4WZb5ZcwQ==@kvack.org
X-Gm-Message-State: AOJu0Yz0WWg8KHZehp2nk1Dya4KGZsjoVpEKhrrawcE4wZ/bLHt8s5KY
	rrRSFPba8RKloT0oLzD2l/z0XB2W6jzBuEmJznaBlMcbl1pvyK/EeSVlrccjcy1vNFUGZxSdR6g
	Bt26ktcRE7Jw6qm3vMMCVTqk8CnJxRQA=
X-Gm-Gg: AeBDietO/AGZgLiQv5Kh/XkgyfVpKveiL+EFEhdjD2cYlg5aEmuaJTVU9i3q6jKBg3p
	mia7JZFOeXRI4LuiPMIcZwNJhVdri1SMjhagL/514wBahwZMqhhKjk3o83jGDMLNrkCRnIN3zIA
	ll7YrrIxc0lciW/fw+HdZ+V/8E7NGMtw45YVmlYJ4ppdv8rNg0vGmjExK1ImpI1Ej6HC7F4w+uS
	wr59r1dB6ZoJdh8W+pEVpKebYOTpcoDSp8D1oLlpbaprRIeJGIpUZYww0ZYhMkqHbnVJ2CLRpvY
	v7PwxZwUq3J6WU+oQqa6iAcBveojqMekhXhBXHJAAXHiIUnYnkiGvQH0cYJc
X-Received: by 2002:a05:6402:e9c:b0:672:8f26:8a9a with SMTP id
 4fb4d7f45d1cf-672bfd980ccmr11896233a12.8.1777004167137; Thu, 23 Apr 2026
 21:16:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <aegUoOiUbjUAH5aT@google.com>
 <CAMgjq7C53WRS5oYxO157mX7JxhfoPoi34k+taiKLrMah-b-iRg@mail.gmail.com>
 <aektdlD4npMVThu3@google.com> <CAMgjq7DRrz4Hdy-s4y-C=3BmPt50LKOfdWjjf2mWmCybdRaJ4w@mail.gmail.com>
 <CAO9r8zPvApgxKiVy5NhiWup_m57huF3MTuPvo=iq5kAxjRZC8Q@mail.gmail.com>
In-Reply-To: <CAO9r8zPvApgxKiVy5NhiWup_m57huF3MTuPvo=iq5kAxjRZC8Q@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 24 Apr 2026 12:15:30 +0800
X-Gm-Features: AQROBzDNkzH6IklDt1vdQEkd4AMoZMIvTXZzrHzuAO6eatZU4lRXpIb_XntAKmY
Message-ID: <CAMgjq7AGzBubCkmv7LubBjPLN1DzL472d4zUm+sGxo8ZptMgRw@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Yosry Ahmed <yosry@kernel.org>
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
X-Rspamd-Queue-Id: 102F71C000E
X-Stat-Signature: hxyy6r7fk3dugyzzdi5orx8bcbcxi7ou
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1777004168-987628
X-HE-Meta: U2FsdGVkX18EaHtIGAKMxfEhMwOLbmRoxAFkceLPTLik0D8e9PbjE3mEbJN+8VFTgRTS1x4b9tCq0t5krNe4RWTR9//i82SKRQWntZ36lmYXKUx4xrT+qbUic2hTCh2fCeppPglb5TP+q0aP3Ejn0kahTp73UbZWPiOTVE9eqRpyRXdrVErTLOLXP3vHf4SlAtR8IKoNYeQAiNXPcgnXo9eyJ1A7BniW557ssk3VzaIVr4yzherTMpSlIjtO99allsrymgvUjJ3a7PoXWwMUC1jLO8Q3XYIfmz6IEPfwAccp7rrn9fjh+sAGmWLfB/U8VaG/YYltb8hV7MKHpiqriZ24QDRjN1ZxXGmKe9Km+Eni2He0s5YIp+2nca43ssol37W9N9f7lgXLLKkjGaf9o+9ocBDSuj0iBTmBabATku+KkI7gim3KF7FwOsXIvzLhc2HcEb1q2DGBi3nHW1bJWdq7BMu7Drhm2fcXi1r/3garw36x4ITfahSrTNdrMRiJHLzReQLQsSzwDgWW43pk0N1xjEV0eqTcNv19iESu+FkRTLwrPuWYf4PEFmHJxTDuvd025Ye8Hw0Kcxmn+4dWrvA6McQVh/HH+fjIdDrJG7+EiULabPYG9LuX3IzLROTpQqi9NztLui8mc18Oz4S5n+U/MeGii+WTGl5CMCdu9QIKYDToBsRQdZBN0YyD3Y5DUdPgxXXzfxvnAtfBX2RDgNkdP3g3g6btEFSbOBj04Pa+qQ9bMMaB+TIFbDMaPGHZV5faC8mK2ZG6BqimmUTfnC7g0p65DHokMjPmtSzgeyLHyyTJU8gGs3w34ISSYRz47iyqATPzZvGA9QYmKOmaKMBVDm0EMGT3AYrvuv+usk3nmWnGMIiSqmPXSfy6w7FnYcp9H85NGh9PF7yp3iLv9tg+3EhLfio66kgFqR7Sy60vPbGVDD5BQqR5cli2uLzQJKwXBtdQBKySTVV08p1
 rDa/8EpV
 mSWkJ760AwUcXozIK48iHHxhJTTegdJt4AA9fEEq/tFz4LTP8OQUmDraCMfisgROcacp80AnsY2x+BkfdVzD/sqLGfSbbFZ2hWNuDTttlMfjhscLzCQiGPzZZscRSMMlEE6hzacsQGCJBJ2LxMNJABtv0eYycwiMMfdo8q9QaGne5uoRTEYvT3vzY6iyUeeYZP/k2QOCgOUSbfvij4ukQSp6xiZSn9SGrFtf0k+X2yM++2OzetXpzzzq9l9+C21VxV8MAMMFrd4FmIc6VT9gLnEP6JtC3VCgJEZqPxiTgR/Cayduw5dzj1I8VoCxzy6qs6HlXj9s7qcXjN2rlRIWj8aebPrdX/RZkEIaJawcR6NCHMUiUYU8UGAcBUnICNepu4pbM7EpYwIiwDCczBQs31S0LDqVJwCeEu+3+Ot46AkWFYRRjGcfWUvtsVLl4QK5LRxQKMmQcukuOrxGjfqYpU6bl2dkMo9n8zEbHqu68B4FmgY3LjtjNn5uDcnao1sOJhJOfqY2POPHQdCA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yosry Ahmed <yosry@kernel.org> =E4=BA=8E 2026=E5=B9=B44=E6=9C=8824=E6=97=A5=
=E5=91=A8=E4=BA=94 04:48=E5=86=99=E9=81=93=EF=BC=9A
> > Using a swapfile does have its benefits, though. For example, the
> > virtual layer could act as an ordinary tier following YoungJun's
> > design:
> > https://lore.kernel.org/linux-mm/20260421055323.940344-1-youngjun.park@=
lge.com/
>
> Hmm I didn't look too closely at this but I don't understand how
> making it a swapfile helps with tiering? If anything, I think it makes
> tiering more difficult. For tiering to work, we need an
> abstraction/redirection layer, such that we don't need to update the
> page tables (or shmem pagecache) if we demote/promote pages. That is
> exactly the use case for a virtual swap layer. The page tables point
> at a virtual swap ID and the backend could change transparently (e.g.
> for zswap writeback, or tiering).
>
> If we make the virtual layer a swapfile, how do we demote/promote
> without updating page tables?
>
> IOW, I think the whole reason we want a virtual layer is to separate
> the backends, which would facilitate tiering. If the virtual layer is
> itself a swapfile, wouldn't it become one of the tiers?

That's exactly what I hoped, virtual layer being part of the tier.
Tier could be set up per task / cgroup. So is the virtual tier.

A standalone implementation of the virtual layer is more heavy than
being a swapfile. Actually I think at this point, it is the word
"swapfile" is misleading now. We may rename it to "swap mapping" or
something. A swap mapping could be physical or virtual. Virtual
mapping can realloc from physical ones (redirect), and swapoff of
physical ones just read its data into virtual mapping's swap cache.

I think it's actually functionally very similar to Nhat's design
already from a high level, the only difference is we don't need
standalone infra for virtual parts.

For swapoff or migration you don't need to touch the page table, same
as in this series, just update the virtual swap mapping to be cached
or update the entry, it's identical to what this series is doing.

