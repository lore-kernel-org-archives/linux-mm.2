Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C485CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 05:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 390166B0088; Tue, 13 Oct 2026 01:27:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33EDB6B008A; Tue, 13 Oct 2026 01:27:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2076F6B008C; Tue, 13 Oct 2026 01:27:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E84596B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 01:27:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 67C93809DB
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:27:06 +0000 (UTC)
X-FDA: 85316469252.04.439F8D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 74DA68000B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:27:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bVpPVxMm;
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791869224;
	b=fsm2QTFVzRRueYVmBRqaymaeg/xNNorDuT0kMPwZeR9CGVeqyJriTIn3Ekm0uFKsOnZJXW
	jWtyedgIhubvF0VQk3HCaf1jWLyUUhcCDOBC1G3BDKXCejoIOJBvFQK7NWSExZkq87bQcj
	CCSIkh0jcAB3b0Kt7h+P+NZi/0EIQ6Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bVpPVxMm;
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791869224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hjt7WdqvBS+sKPOEWx62yXCoipEnUvIuBL1q83yUbyo=;
	b=zA87YpXm+1IEw7xW/zqFxXUw4CO6jmFncXiUnIp4Jxtg8rP2ZA3rNHIS32zYihWzcVH/it
	mA36tijyGW7hhXm60865CgDCRw0x73yyw3LasQDtvoEmK6vczmJJPqhco6jpiBvgdzd2os
	RpYTbFsGVx6BoZZfNKE61TCEtb3RC30=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3835B44784
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205641F008A1
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791869223;
	bh=hjt7WdqvBS+sKPOEWx62yXCoipEnUvIuBL1q83yUbyo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bVpPVxMmpxQcIpMDG0cMgSS1waSuQFKprgzLXzk6obHhBhdc74fpIqvek58IpWt85
	 xg2WX6PA/YE2C1AfaIomL97YVvho3bk/NRRq1WMZ8tBe315zIXr4KSIt3VBG9C5FH1
	 NdQIWvewdmeEzcXJMHkGGCJctLRw++mhX+WcV/4AMO3/x9BuivY22l2DGIabQ7nPBJ
	 ubxtYdvDQZkO3L23mZYNks6VNs7WBayuE0twmcXVBZSo2fZEFaG3FvT8YtGJSluJps
	 /R0SSHLkjx/Qoh0+gyiTtUndr7hoL/K7cnW8f8umP4fG6l8pWmcdNHkEzB/oz0lCoP
	 iChKgSqcmvIUQ==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6af8620a7d2so3066522a12.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 22:27:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByuiNy24EJYFQolwr79mYv4KmZidGRnvOsFDUY/ENrc44A6QaxcozOL+oE1vidXtXeBqqUYUHYuuw==@kvack.org
X-Gm-Message-State: AFq9FYIDvsco0yeEFGigBtLCYgbKxtkgbDW72F0WxhapqwUQvRjn3Hrz
	f7bTwMFm8JGb0cmPKGm8Fu4PnLooOtkYKf8K66+PWnijtSBqMSOd8GLZeuUj6H7RNMrbUIY2DL5
	qHZHuuraQCztLHxrqh/8m+haLwMqxdL7ugz5sJKlSZg==
X-Received: by 2002:a17:906:630c:b0:c2e:4601:24d7 with SMTP id
 a640c23a62f3a-c31aa0b038fmr1163593566b.39.1791869221297; Mon, 12 Oct 2026
 22:27:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com> <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
In-Reply-To: <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 12 Oct 2026 22:26:49 -0700
X-Gmail-Original-Message-ID: <CACePvbVTnCOh51jvEpkDJ32idvCubgN1eHBps6vESjhVC8E_aQ@mail.gmail.com>
X-Gm-Features: AclHuK_DfQCPO4j2m10REoB4qF9zAuO9SjVMLTAFlHAeodT0hj3mwVtXkmxRAyo
Message-ID: <CACePvbVTnCOh51jvEpkDJ32idvCubgN1eHBps6vESjhVC8E_aQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Kairui Song <ryncsn@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 74DA68000B
X-Rspam-User: 
X-Stat-Signature: ngmz86akdzkxgykndw56is84pwcpitzu
X-HE-Tag: 1791869224-563618
X-HE-Meta: U2FsdGVkX19WSDlbKqDLOvW7wWimdfXFssNIL8FeDwHNQ5alLN38rp/XmyPLDhfqitJvn4reo2sVDFqbyTanK7VcEpuMnwOSG0jF1icVamNTvNkuSzPVz1wCTWfU4E5h67zJ8yKxndh7T9NtfflJY19J/R3hVzin5l3zL1DS6W9ePw831WOxU5/sywtevNBamMOaWOqeCZAJENoPSob/abJqHsOquz9lJHStcxqpP1oOue8fAN4EGerMXy05MN99R362e2+XGVdsgaHiXm0bO4UY4Lp/lyv+FodOz/C+v5bV78dpbRHs8/a+dIpY/QfOBclxVTjyQmBwSzGfr7qzTF9c5BB1NqqaoxTjWGQp5VnG4WitUDTcECpFxCX0ijiDPd84x3r2s8uhU1x5zTtaR7E5SqYwVlcmN+P3EGNCuT2PznBs6EFUH5NEQtN1OS26DNMq8/7m/CuwjR5jr62uz7vDrt/7xvTAdrsasnMqKtZMATtjFrX/mElkkjTkp2uV8VPhes9Rz+65BK6nK/kXleLpErr4kfBEtFZXnQey24yqOb3OM7bNeYipTs69VwJq6ii8lDyGikM9SW7ZM/V24+RaCxo2mEtGGKJ5SLROLbJNYnSC2sMBPOdXqqXEVUM/cGK5zBj7ATOi6VQxasxNKYBhQzKh0tuBRwKpmHlJQJ9Y7lnVn6soCIuPwvuUXcZfdwuQSvX8riSdZtwMrrvi78Wby4DILUjkkqo610vNw0sFrfQZ07eVvJQzt1J6E2ekJMTZbB6r/Uxzj1U9FwZIKwYdWiMiONPx44fv9rwC7rPLXr9DHfMJPgQFkYstGidTiV55Tp6g/fADffVp/R32PI/iSsiGsFKnUegSwOTaS3FyIPOxj4DDiHMNG5Oz7sykT7Peq7IERFK6LISjIl4qRfzIK/v9NOQxTAVntLs+9wqU1xT+aRn485kDi1Yb4hMBRHCuLnu7O/8n2p+zsmb
 /c8nTmvZ
 EugEEwnLemaosraSUGoqjVVuxSWbPH5pUTWhFOXWC09qqu5fgDgdD2tw6ImaCjJPIN0B3ChaAbnkIcimr0YHu96YZ1sstNjt0JlmjxVc9esp5yizg2zkO4F8pUUHAVQRtEJSuSbCIR0ORao9PI86rkH7o30+IZAazRLZpT1P6q0tXpIfE49ckM+G18asBVOJtABbSdBzUaHctqAVu8pUEDAhjJAp37mLN6FC/ra8CF77pKmgYMrw07Koza3QiU0ZENqUByzZCigYuQSA7Qr8EEgM6MZi4k1FfTrN8XV0sWOtibPESFQX86r9LJn4/+rQ5VfpOgSVB2+wu1jV39JJlimk0HqymmR8qkrC3Wt61UyBlecPDcMuD70UWvFmCOebmiXLo0Ql3X8zKFs46TW6JSW8gwowQ0qXg3ppFY7MCcOKbklXonZRaYoTDkLWkomo9y/Mn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 5, 2026 at 5:19=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 9/22/26 15:38, Chris Li wrote:
> > On Mon, Sep 21, 2026 at 8:56=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> w=
rote:
> >>
> >> On Fri, Sep 18, 2026 at 11:50=E2=80=AFPM Chris Li <chrisl@kernel.org> =
wrote:
> >>> No that time slot is too late for Asia developers. I don't think we
> >>> should use that time slot for swap alignment.
> >>>
> >>> We should find a time slot more friendly to Asia.
> >>
> >> Any time slot would have that kind of problem. We're spread out across
> >> the globe.
> >>
> >> Let's just use a standardized time slot we have for MM alignment sessi=
ons.
> >
> > There are more swap maintainers in Asia than in the US + Europe, at
> > least based on the maintainer file. Please be more inclusive. If the
> > alignment is done without key stakeholders, it miss the point.
> >
> > Sigh, we can't even align on a time slot.
> >
> > In that case, let's keep discussing on the mailing list. At least it
> > is accessible to every one.
>
> Looking at the mailing list, that approach doesn't seem to work.
>
> Finding a time slot that makes US, Europe and Asia happy is ... tricky.
>
> 1 AM is certainly unpleasant.
>
> US vs. Asia is also tricky, but doable.
>
> China 8AM vs. US West Coast 5PM?
>
> China 9AM vs. US West Coast 6PM?

Hi David,

Thanks for organizing this. Time slot that works for Baoquan and
Kairui should also work for me.

Hi Kairui,

I understand that you have some face-to-face discussions at the
conference. Do we have a list of what has been aligned and what is
pending to discuss? We should have an agenda to avoid repeating
already aligned items.

Chris

