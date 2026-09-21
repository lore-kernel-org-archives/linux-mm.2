Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47C4AC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 18:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E1D86B00BF; Mon, 21 Sep 2026 14:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B8FB6B00C5; Mon, 21 Sep 2026 14:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CFA86B00C7; Mon, 21 Sep 2026 14:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CA116B00BF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:12:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 82F7880263
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:12:10 +0000 (UTC)
X-FDA: 85238563620.29.FFBF0BA
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9878C180005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:12:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QayIQNlA;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790014328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWAiYwSilURWtvvGZAcBEX6+14GRC4unGK9hsZPrKEw=;
	b=PVkST5iM0RdReBepGjhYJNimyJ6Rah8hC6WSe4DDk/aRy+aPSfP4h56tcmFYd2E+F6HSi1
	WTcq8BVvRBOAm398apRUzKAlJj+KzRDAugpcdgxsW7ojZJvhcidgqeuwpHOB1XEF0K3eFt
	a2KEwFTWluS3cohGTKHjDhQ9XMcVzJA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790014328;
	b=Jho7zOkTLMbHg3e0vX3IfAyjcsWH7bFOsnkXAaFgIEz9EXMiftX1i3ZDnQLp1I4mCoFsv+
	RpAnbEzY4nSIMeJlc1V9JywYmqiruKsW0yXPUM+CpGqfaHbCMgiIkebW+EPazwji6BXD1s
	5HHVwA5jqPr7tZBmQpnFT/b795m3CVQ=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QayIQNlA;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd4ba9f68so45619545e9.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:12:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790014327; cv=none;
        d=google.com; s=arc-20260327;
        b=IbtBe1dshp9nrL3mMsqNMYVg38R3ZrxPiJnqZtQKz4bqTgzzIwTJRkuQJS6ZxqgVzj
         wb6JnD05r9N8CGUTf4CcU4PAIBXqkIUjPbZoJ9PcxtOz62i4lB7WawkmXJQQLTZ5WyTy
         66NQBtizy6VEvLhAXdmX2ElvNdQOFZ9S+p4rm0ONRgwO4NzvWzXmjP+NZWMev40FwQSC
         mAA12kKUAwyCvsvfHGwOhS3DQb7Q+eu27xEccfdtOM9illHDGCZmuVYYkOQFKOOMGBhX
         gStIwWcHy6rAeiKPcbd9OZp5/I/6LE9i+UBbKJUCldMeIiWfy/qkOUl8NtffIAH9Dm7y
         cCow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EWAiYwSilURWtvvGZAcBEX6+14GRC4unGK9hsZPrKEw=;
        fh=tL89fhMaUrBA4qmkRDaZCuEOvGftgMLVjkJU9/En2rU=;
        b=IwlDL2swpF7hOReRgYeJOrerat1RpztfmbIRrExma2e/J6pTPgDVOvwfry49BDjN1H
         PrK+XVQO6s/36lCTVDQisw32MsCvX0PWjE+BCrbGkimJrlnS/YelZm+GQz5w+uZyErse
         ePk9vj1RX5LGcOLH0iEvJb+NPhpyfx1pTsS42wX/ZYqCNDPZMLTVMR1+oyFheQOEIB37
         AN2YMfX+uqbdKItoq2trhyunUElYNoGDQntKhs5/NKyKo4hKLhzkDE2qXKDY3zuIXJwB
         BBFIR7CrvX6AlbmVbCS6xmi00vKdMegis0JDIUO2vdHxfW6RK3POrd63XFcXzgNBEVpk
         ewKA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790014327; x=1790619127; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EWAiYwSilURWtvvGZAcBEX6+14GRC4unGK9hsZPrKEw=;
        b=QayIQNlAm+B2XxHlMPKUYOhyAISFcgFgX5fl+ocE1jFAhOnylQ9E+wcgouCDb2aXEq
         q148uHfX7mfRG492YyQ2S76hHX48lLeeLIod5D4lek2snBb2rXexdx9HhsC9xzJXgVVE
         jyQUKEsvdee75JPkgPo+hp1iOpEpqXOu4+dT2D5XWVDMkxmRfuwIyuAUHdjGhjIN0mUG
         +vsh+YLyS2QQ9Orqm2/kVPxWvxUmZq2zMLP2KP43bGAO9Yp7VrivzlhsZejatx0ymNQ0
         JSwabbnvWp2aXTbhgNBvJbOM49i+Txv16/ws3o7wJksmAaF2yMLqPXYzcVO8HER73TR2
         T19A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790014327; x=1790619127;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EWAiYwSilURWtvvGZAcBEX6+14GRC4unGK9hsZPrKEw=;
        b=U8aqqQNmkWVJbdM8IOYEihNx04/CyrbqyQcQBgm08Ana3CYp5sckEtksIngF39bRyf
         x7aaMrZi2D/dlfSuq3srV2n9So/GGxVPLly2yO4jKNEhX18mbzuFQ4FImJBAJ0jGoZEA
         /zyhKODTlUPngkJbM5wjbsz+qKweJZHkxSURKVKkIw2Nf6ZhfPj/dTfI9mtj8TtwvDwC
         E5XwKK8cCFf+wMXS5ZhCmiuZl4bVYBsOpql//Nc74rcuJH8FBi83MQEf2NNbt+NIcQBN
         6B3rxDDzHx0VCrqvF27AzjkLnQ4nKIwd5w8cZc19MrrRxrPrzZGEcSMQBo8VwC6tRWl5
         xcHQ==
X-Forwarded-Encrypted: i=1; AKwUvBySjozl8txRDKyGzw2eFPIPRhEy+78gGS5K7Hc71zHRoYPD2o/OzCM7maMaPLJ8APCLAVh/hWcWNQ==@kvack.org
X-Gm-Message-State: AFuF++kdVgWxguhlq3BFwoGZuBhntBkPJFaRvUMi4d9ty+l2hOst/7Hv
	8aQkXmF87kJtS5FjUXsoW379BAtl3cvPKvkRPtgIFZafMTVCqHgUGHIgRv49pz9QNDxSHaqHKob
	pEnoY09QGEq64dkOHNmTAZPG/R1E8u5M=
X-Gm-Gg: AYBFou2DnQUTmNmxKT8XNWVsW2HdTe5cShySUH5pudPsrhBGdzkS8WROTRCk+Xf/K4w
	bdO3aK3InuAdO/YzVh3+TabPoDShilMt89mFBa4qxCkD/hRpJLPPJckx2/vOw3XR8Ob8G5b1QJJ
	MzdCOtZ4rprQFW7N1YcjoRwnpZtXqSO/1QEGm+XUnZBSbxjVzji3+DmksXMW3mnq40z3fz4femf
	TYSBRr5OvTVJowczx+dQxfnyjwy5SNaVlg+fo8IZeGld40njWWm6fT6wcAGScUijdr9RBE0vHFx
	W/kLKKveiCm+lsYyNJcF5r5P8bMYiv/kke86mc/GeA+t+UZ60K2QWhgM9L+X0UJ9GvRpMwKAake
	MT+AJSQFuh1c=
X-Received: by 2002:a05:600c:6296:b0:49e:6fd2:a45 with SMTP id
 5b1f17b1804b1-49fc5737c43mr165327145e9.16.1790014326849; Mon, 21 Sep 2026
 11:12:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com>
In-Reply-To: <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 21 Sep 2026 11:11:54 -0700
X-Gm-Features: AcwNN1Uk9oPMFkdbwLdN1Bo4F0Jb_Heb2Kp9V2Y7VRGmpknxLqYukpUi7VnpUYU
Message-ID: <CAKEwX=PCvY=5_+rm+g6RGMXh2+WTfZrHtd1qT_fSb8j5hjz=_A@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Kairui Song <ryncsn@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
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
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: d3jq7och4aqamubgxbe3ezq3a6gtdj1q
X-Rspamd-Queue-Id: 9878C180005
X-HE-Tag: 1790014328-506207
X-HE-Meta: U2FsdGVkX196KB/YRrCInXvdtCz7sYrwjY9YWfKhxM0Weeh7wkQCsNKroamcKuAeiED0NNjROUoKkXK9f54hq+EgjJjqcwjaRpYzJe18G/87dFmcVShb8k9It8/GdPEfq+k/hNfCOVfo5MgsV7SvSJ3RAphc+q28wy8Ei87Z5f6XSq3OlDblgQtGzfi9XUggoggGxp+mjauyDQnSH8G5ilQXJlMpC8ixiNywVeFCnV+VlATwwqHD3To/igDNea9o9D0pA+N+O9zoAjoSlKellLWPhUYzB4FpEb0svWbCvI3ZuvNCUYxRd3mttEM1CTHAswAdxko7lB+OC+Voqv7MFtyp/k61yYbw7wV+AX+5lafJf14r/BDlErDWm0eJxjQc52vR09Y0BTRRjObsKmi9L+tH0jvwfRz2uQsa5Hms25IsAcEVuqHMjslTph/fgf0hggwApVEckR41FeVGRFeeVt+UTV04wqWqbM3ZT7ihf1J5byI+vIe7VALxX4HtyP+/2IP306yVJhln7/Hf+6o/YTnlmej6hfubcNaF8utDeaI1LryQwpefJTDVGscsuZ0iM1vZwk/qfH7ow62mBLpGAvbMTQujfu0Znt1ljEmKEgmj2ArljOfe57lvl2fTutivOuZ51b9smdAe86is03psVRkLJrROhwSOcjBCZam8QakGqHi+DWgMdSt471bauIxqpprBJJGcixeVuDyvuJe+kHl325882XMZ4VDlF7ao/LJTbU4gWw3782pMq0dpW/DV2HM/Qdx9iBNnCMR6AbxutmNWK8ZeM3i8DUBvUlxo7EBbAKEIVnQ6Xwww6OG1gKPg7QAyRo1+In2rbdygJCOh7YSvq+viNHfL9Q7Y9ncfGLwJQ508Mfm6KjlAdWioCQGZt+LBj6Iw14v11oJaAUcwOES+47LYTMqRMdwcZOeTUOkyPyKC9axZZ3K8zl4wJo/QbdShrCd6I3JTPjqoqBt
 ddQLHf7f
 dJHisPabXZufxgFqPig8dMhnjBLeXahZRH9wQX8SOo6AbMwA7894c0cTj46mLQhqC82VQWGMzxRy1jKy+YpQrrE5w3yJsyENkmZjqBGumVTxj3YF2MkQCfpT/S+FPV9yy4oAxa0ZjsEIG3DCUOQVUvtFJcXub8ACkErKU8XsQfsf1x/gEw6ulfDo+K/p63OZ4Q28ciMJvpxg1v7Cra6zlzz+YmaRXrmolzbkD/PwKRlYpD8j3IE/oE9IjSHGSsZ0wIIZme/j/PuFhGciubkjJfSjc+NUSddhnfRo5GOAydOXAs51ocNxw3Cbox6NOWh95QHvYtZDSjurGNDp1efftWo6aI7H1BUYFd+IP23r/L9QVRgCwHmUs6u3zeSaT5p5mLTSDvFLKAHA/bo3QXVlwTHxdUUpRMo85pJhYKxxDx7T4Qf9NUqBGH0CH8UtV/HafzmXkcEfgwmxHcSttIw11JIXh7glYTNDZ3C7RfmLv7xhMAasCFHv4fuEepdhFggbWA6MjEfjl9nKrLbjhkMSlvT7xQx/ZaBUht4PhkqQZmid5k3ISe58Xyuwz8IgczKo+keUWn7a2oU2TqNwJxbSYRulW8CpM94vQOuM5CTcTeC7zLAT5wuIxakdzMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 3:01=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Sat, Sep 19, 2026 at 9:02=E2=80=AFPM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> > On Sat, Sep 19, 2026 at 6:08=E2=80=AFAM Gregory Price <gourry@gourry.ne=
t> wrote:
> > >
> > > On Sat, Sep 19, 2026 at 03:45:03AM -0500, Chris Li wrote:
> > > >
> > > > I found this new concept of "compression space" very confusing to m=
e.
> > > > Can you explain the swap behavior and problem using only normal mem=
ory
> > > > usage reduction and latency without introducing a new term or new
> > > > metrics?
> > > >
> > > > The normal user doesn't even know what compression space is, let al=
one
> > > > what makes it transparent.
> > > >
> > >
> > > Sure they do - it's the amount of memory consumed by compressed data,
> > > including the metadata associated with it.
> > >
> > > converting Johannes statement to diagram:
> > >
> > > >> Compression space is not a separate resource. It's page tables,
> > > >> backing pages, and swap descriptors. It's just MEMORY.
> > >
> > >                           Page Data (PD)
> > >   [page tables][                uncompressed page                  ]
> > >
> > >
> > >                         Compressed Data (CD)
> > >   [      recovered space     ][pte][swap meta data][compressed page]
> > >                               |                                    |
> > >                               |---------compression space----------|
> > >
> > >
> > >                         Memory Pre-Compression
> > >  |[  PD  ][  PD  ][  PD  ][  PD  ][  PD  ][  PD  ][  PD  ][  PD  ]|
> > >
> > >
> > >                         Memory Post-Compression
> > >  |[CD][CD][CD][CD][CD][CD][CD][CD]-------- free space ------------|
> > >    ^----------------------------^
> > >          Compression Space
> >
> > Thanks for the explanation. So the compression space is just the
> > actual data store backing the zswap/xswap/zram.
> >
> > > It's actually really confusing to represent this space as a tradition=
al
> > > swap device - built on the assumption of a pre-defined size limit - w=
hen
> > > that size limit has already been defined (the memory itself).
> >
> > First of all, the traditional swap counter has a very well-defined
> > meaning. It is the size of the memory that, when accessed, requires a
> > page fault. A page fault adds significant latency to memory access
>
> Yeah I agree on this. Swap just about makes resources not directly
> accessible by the CPU act as RAM, whether that is storage on disk,
> compressed memory, or a network resource, all accessed through a page
> fault. I hope we won't make this fuzzy in the future by introducing
> too many magics.

memcg folks should chime in, but IMHO the cgroup swap limits are there
because we want to provide proper isolation and fair distribution of a
limited, static resource among co-tenants. And without vswap, this is
true with all swap backend and all swap usage, because they all occupy
that limited resource. So charging makes sense in the old setup.

This is not the case with vswap. The vswap slot by itself does not
consume any meaningfully limited resource with the vswap device. When
it acquires a backend, we still gate the resource that backend is
occupying for fairness and isolation (swap.max, zswap.max, the latter
of which arguably is unneeded/harmful outside of 0/max).

Charging vswap arbitrarily towards swap.current opens up new avenue of
contention that is farcical. For instance, a workload's disk swap
usage contends with its zswap usage. Or if a cgroup's zswap usage can
potentially contend with another cgroup's disk swap usage, even though
actually contend with no physical resource. It makes no sense.

If we're talking about confusion, I would argue that the current
design *is* more confusing. We have to answer to users constantly why
zswap is occupying swap even if there is no IO/disk involved. And, we
have a boot parameter - if you turn that on, then you get new
behavior. We can add more documentation, but I don't think we need
more machinery for that.

