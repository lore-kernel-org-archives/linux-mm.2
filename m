Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E05AFC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:43:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB43D6B0088; Wed, 23 Sep 2026 11:43:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8B336B0093; Wed, 23 Sep 2026 11:43:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A541B6B0095; Wed, 23 Sep 2026 11:43:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77FB86B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:43:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF801402BF
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:43:55 +0000 (UTC)
X-FDA: 85245447630.09.02B3039
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf01.hostedemail.com (Postfix) with ESMTP id 026AB40006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:43:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZqRSpaKA;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790178234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Es8e/JK6KVLGMkYWnzLbZUNxa6vgo1yIxcTSFiPCupo=;
	b=YOAk5V4gSMAfINQVdwbmdsydMUD8c1/pnSU+2tYv8MDCTnsuTqvaqvOIvifkk9E2+HbIWa
	/R2lW7xdfcG/a3ozvYOIFHY0Cqp6O0F1H7Dfcvj0RoPRQf6QugP0kNc5iBYk83kngwYc/C
	uWdIcfO9kz1YdYy8hsdErmj9dWiTrPI=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZqRSpaKA;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790178234;
	b=tej4wMYgLZO9B8JcMbuE+TKxEoO/qE72lqXxUo2dEDCEhBa/kG359dg8KO65BWZstloaPS
	OobK2LSlkyzKiyr8nPjXf3hL5Qxg7A7RfzDOJm6RboqiyydRiuppZ/LtdE6cUBtrNNFuEH
	xmMNZs9rr5sjgkGBQw3ebbQ+H1Eui8o=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49ccff31419so9229725e9.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:43:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790178233; cv=none;
        d=google.com; s=arc-20260327;
        b=SAkJ3tOFivPt93Dz3tPqy7+gqRrKkgH+fsGYeKHsSzJ8s0kKKmlnX4hIdOUvnlyFF0
         Lxac+khbFjUjpZ23kjCffFCZ+szVzNhAWceVultxKiM5NuVitY4Kqk86xZqNBppb2XYl
         6bMxoQ7mGrjNLeqrGacGHcCTPnK/i3EWLWboTssw61h2PDZzttAnhJvJjOtBEnvlQdCm
         FMYjQOLssk4ZQBnWkuU7zDW0esbLlStEb8huOGtsw42hi1z++DjXT/WmNi4Fzqa5Oeyq
         11kcZrq7O8MMjDGe3X1XdE8oB7uUXP0XXG4i86oI42GhG/6Zo8YGoGybjk31CNW8AY0z
         tOcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Es8e/JK6KVLGMkYWnzLbZUNxa6vgo1yIxcTSFiPCupo=;
        fh=TTlIMXxDR0O2wBDygyxiDp0eL+7fQRKgp8RvNaJbVdo=;
        b=g4YplOKk0t0U+ED/aorRYhO8TG+NcxtHZh1U0FGdmfHHkz+oX2m/eIowIOaKnDPzBm
         cSYkOtXnjUi6EYrGV5akNFmkzgD9d2SnrHHClErkLkbO0quUC1aFV5jLB2Xspjn9YFqz
         O1qKH2TclQ02xUMPGRNB8kJZ1ktXBlCYmfEQX0CUPSwhNPZzBXZiNS6wL2U5YwSQVKuD
         QMK+BtOrYNtN9oMYqAMYMwwAQfi4P4p96zUscDycdX1EH0D4I3kgDzjUufbGvDjEfoCY
         w2pFikCr1hABL6YQX6rPckb1ZHeSU0l1eCK6fF644kaDqQn4H5yvsVcjH538nuoKMugr
         qohQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790178233; x=1790783033; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Es8e/JK6KVLGMkYWnzLbZUNxa6vgo1yIxcTSFiPCupo=;
        b=ZqRSpaKAU9x/5U2kP/XV7otF52pC6ekn6zhXODL5cgd/aXhFJe0u4haYvh5Mq3rZ3h
         Hf35oIHG8+VN6+8hGRC9JelT60kLGjUh4j5p4t0aTZzZ3bgBu0MACuAhIsbOzhz4ed6G
         GVBMOHcV68K2cqgftJHFmHDrGVTzpX69FktSRMOqmZ0bHOtz6NDpxtf7ozGiynv1hX/x
         UMRx/gUMJI6NNOhximEcWZ0LkydxVJ5g11p05qs5PMFmFhOiVSNKU+p1kTpiLBl3ntd9
         ILl4cfe1zEmmFp4Vcm/+7bFI6Qd4t1sNoM5qdUYbf9ETrOFO4oTSTNOOweCJ4i5yn1T0
         FT1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790178233; x=1790783033;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Es8e/JK6KVLGMkYWnzLbZUNxa6vgo1yIxcTSFiPCupo=;
        b=yeZLmE/Unsdymf+jyOLU1XZeoeEVCanTBoI3pByIbF1oCHkQE0ivD/vWh527D79hvH
         aZ0z7PTkv7GnS3t6y8k8QWGUrZtx8elVqx1/XNC7taJP8N+Msf14PLav+/YgEIPKO/zo
         ocoqrpj0CzZa/8VHJ5RWb9EDwXKl2t9MtPQFHF75dXeojNw2/mUkldP8GxzDUt3SAU9D
         y67WsiwSnM3aZHkEagufv/mgrI/VM7SXdUZnm/mseWbto4x+oeworpORJR06FY4vNLGY
         WQv8lgYRCqxXm66KEDidk6EFJmsI4alFyTBlVXuPEOrHH8THVNDmteJsZu+i6mNUq01K
         nNpg==
X-Forwarded-Encrypted: i=1; AKwUvBxweZ4jPSBs2oTwab3lMl+vQshb4Wk5REypEm9SfK/DROVNDeW5qUFHcKR4IHXTWEuAKCx1ClUgiQ==@kvack.org
X-Gm-Message-State: AFuF++kIbLpw8OTuyDGUaX5mUrkn70CSbqtW788fo2dLDAoMN1MAxM/3
	NOO3TMmudWBqm/GFjBcpjX1SNSjRHV9tJvvcLIk1Pp8J/CubRbg83TWVx2I4ishnyFeECRltmwT
	BW2PcGtdgZFkwIRMTAJ6iLa4TSO/Ty2g=
X-Gm-Gg: AYBFou0Yc4gVQ2wWS1gz0TDbtHRs21w3ErpDBGiMwvvz6YkDrFB0WbxHaSXHu+IQTxR
	n3+844blfHNMDAbMhtuutGzlKwKytVbK8qvsw0d95veo6VxOgMGb0/3vip35wU7uL/bsJHPnAza
	7iiH37kSo+QRTHuZfvhD+Fu1Jgn0bVl1nWe0hVI3YYW3NPYnTgmd7/vp11YVkhaDSztviVfq5gU
	1iqgS5Cx1/wGpBOAnUsizBQ2xu/WZOf1GV1JdpVEzMJ5YJZy4DSsHXiyriG39JuvrxfSUu5xlrt
	wWIHuY0AfDfjZ0//y/0uPBjsUT/hn74zRtaZo1Ck/Qbd1Znu9QlCdb/6LEHtx6bm4SExLmBMNU0
	+YrmgGLTJ8gY=
X-Received: by 2002:a05:600d:1:b0:49f:e3d4:4c1f with SMTP id
 5b1f17b1804b1-49fe3d44c52mr27492235e9.8.1790178232516; Wed, 23 Sep 2026
 08:43:52 -0700 (PDT)
MIME-Version: 1.0
References: <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <arKbXe1Qe-FDCTMM@gourry-fedora-PF4VCD3F> <CACePvbWW4avTV2WB6iRU+LN5zqkMTg3UhBrq41R0iw91-7Ni0g@mail.gmail.com>
 <5a7ad159b2fabf377b7e1fc4248c433287ac11fb.camel@surriel.com>
 <CACePvbUtEdQLmmudON_qC2aKuLYCNktBuAecFKiSvDC6eTfXeQ@mail.gmail.com> <arO0RCCE3Woh_I_z@parmesan.int.kasm.eu>
In-Reply-To: <arO0RCCE3Woh_I_z@parmesan.int.kasm.eu>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 23 Sep 2026 08:43:41 -0700
X-Gm-Features: AclHuK-DOXD6gmZ00tV-Y_YvQz68XBhp-4953At3s2qoPuH6VxOPtvAoXyV4CLo
Message-ID: <CAKEwX=Mw8DsieAeEK=Wjb2d2o=wxEN3QOoOR153u7Ki28003gw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Klara Modin <klarasmodin@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 026AB40006
X-Stat-Signature: 6iyur7ej16e9u64oy8kd1wi3x8a6ierk
X-HE-Tag: 1790178233-835361
X-HE-Meta: U2FsdGVkX1/qhZAaoUD82AVT8CepZoC9srWbLDTqtIcbVRDWwukG2pWTzDAXU9+QBNK8v9Fj7FHr19Xi1cLI7EoO3ClKedSCJ+CRvL9bLM4JcNuQoFsjK2lRk/o0sK6ezTlA92VHd/5AT/UAB3OxhPosFSCWOidf9OigrrgVwdK3NKQ+JVJxjkOjQOz/uPcGMyR6kj+dsC2erxaZ/svnojfrj2XTgSSgkVInPZ801bjKiKfrAo2stuMOmUi0jEdO0J9O4elSpgPX7NZtKd9qjWLm53PdbTYMoFaOqsdGRPMj+WR5TNZ0jy1eXJXTCQXvBS8ZnNW22GbMO+MO5hV7hjzs8mZoY2TbYMpYqA56jkg9uOntHBjDBEnI51ubH3KriGRFoitMF21bgYOfbkWpmEkvt+ywLoc5RAdImkk8SdFFGusnXkmopkqkF9nNEik0uje1OaFOkA/H015QOAg4sKlxklx9AX/FwsF1ZIM0aYB6xynfiOhboD/xxm//wz3QTaDCUc1o16RM/gGEqqjuoloTK5msv5h/InJuelg3JyqsgJjtB1ltp77jeDpDWm4L7oG5CMyv/72IDzEifrVl+3yd7b+5IkC8N8gXXri1TVPpWtCvpR8ZQ9oFwdxosZYpA55Uxrb4qpuEjiOTAAEISixT8GOw6SujVwgV1pl1w3DA92KcAalNCkoqgfABku4Zwh2Z+myyT1TjvNTnPJqrRU7rdfDVN4OkSUQsuKvQiEMKT/t5KJhV/uwGDl8k1EM9e/1MZhWUJnpXV0uDEHUZMzVuaUOk/31z/kiimHhrt7jA4kYSPwRKv2hua/ivFVVsY6KyzrvsuvTmo0L7txS2/utzX43oIbPgXg6OcIOlPg4A79mHSPv1KtYmfCH4ROPl5LLleeMfvrg/QAbISQdU4is81yTLggLzwpL10pL2sPGhRbTfKOJatDw4MWenaDl+Gyfzj8ZT5+MDdFPV9jB
 PigT6DTQ
 oBC40Tk6lkqzEbRe880xCPehWmXAiPXJyxrIRlS1wyY1RrGWzCXqF2X4bgGSKF7KtLZSqob9tvYqHlrCYY4B1CT1InxO5U0S8u1y/RWgM2rNbDwlUD/PMglEzxid/8j0zAkoUTuO8PT/er6VWz+r/goWl56ymdOItjAiqF8FVoFw5yuHdKI8lv4gmgAemomP4zMuAVgfy0ELPcMu5wJRMwcDuLV4TUmps3otynGoAjtAnI1v4mRKW9DSs5mtUwQu/KkOegd4mlOUE8YqBQ/DMoj1lOzNJncOxgO8i4srlUWbciQRwEWYzgFzi8hq2t9L4ReTAnMkloXhGqHq1f4HI1GBWyHgB95OIWk0RFhbhz9DVL8YU2VpXgcddxaL4Q3bmTANYWhfTNV9HNU5PKdRgTNjiWU1mtKdGjTXX+fbzDOIfe5p9hCu4p8cp4f8/mhZrvW9eydAvsaiY7ycfFvVbZaf2GlSAdB/UVPPkf096H2eJjr2k8N81T+enU8VmLIjMrz5H0rXWolqg6YK7wFguA4Gmx0y7biuVIEQQhA0Sd8VbOR0yOd40mAO3ge9BlQgi5c6QGWGUdrThHTkqTRpSdqmoTozAQDYrYrkpzdccAdEjVYxeVUq6yoJDfrKsLvIHT0wzHJC9pLJOfH+Y8wzwXYRhTQ9Dhjl37xtF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 5:52=E2=80=AFAM Klara Modin <klarasmodin@gmail.com>=
 wrote:
>
> Hi,
>
> On 2026-09-22 21:10:53 -1000, Chris Li wrote:
> > On Tue, Sep 22, 2026 at 5:53=E2=80=AFAM Rik van Riel <riel@surriel.com>=
 wrote:
> > >
> > > On Tue, 2026-09-22 at 05:43 -1000, Chris Li wrote:
> > > > On Tue, Sep 22, 2026 at 5:20=E2=80=AFAM Gregory Price <gourry@gourr=
y.net>
> > > > wrote:
> > > > >
> > > > > On Tue, Sep 22, 2026 at 03:32:44AM -1000, Chris Li wrote:
> > > > > > > Right now it has 64GB of memory.
> > > > > >
> > > > > > That is exactly my point. You are running 1/8 =3D 12.5% system =
ram.
> > > > > >
> > > > >
> > > > > Chris you are missing the point
> > > > >
> > > > > Zswap:           8812236 kB
> > > > > Zswapped:       24927876 kB
> > > >
> > > > I am well aware of the point. The 7%-10% data I provided is before
> > > > compression. After compression, the real saving is about 1.5% - 2%.
> > > >
> > > Here I'm at 28% without any issues, with room for
> > > more.
> >
> > 28% is one thing, 100% is a difference beast completely. If you
> > haven't tried it, don't assume 100% will behave the same as 28%. There
> > is a point where too much zswap makes the system unusable. It is hard
> > to pinpoint the exact upper boundary. However, figuring out the upper
> > bound larger than that exact boundary is not hard at all. I haven't
> > seen any one can use 100% system RAM sized memory swap out to zswap.
> > If you have a data point showing what that system with 100% swap to
> > zswap looks like, please share it.
> >
>
> Chiming in as more of a user perspective.
>
> On my 4 GiB BPI-F3, I can reach more than 10:1 compression ratio on
> zswap during some parts when building GCC 17 snapshots. E.g:
>
> MemTotal:        3966864 kB
> SwapCached:        31872 kB
> SwapTotal:      16777212 kB
> SwapFree:       16638128 kB
> Zswap:            280140 kB
> Zswapped:        2859840 kB
> AnonPages:       2927376 kB
> AnonHugePages:   1409024 kB
>
> While this is 72 % rather than the 100 % you asked for, I think this
> shows that what size a potential limit on the uncompressed size of zswap
> is suitable heavily depends on the workload.
>
> I have been using vswap consistently on all my machines since about
> August, and I have also tried one or two versions of xswap (but the
> current lack of writeback makes it inconvenient for me). I really
> appreciate the work being put in to decouple zswap from needing a
> physical swap device to work.
>
> > >
> > > > You are not listening. The boundary was set due to feedback from th=
e
> > > > application SLO. Those are real deployments not imaginary usage.
> > > > Please respect the user.
> > > >
> > > Different users need different things.
> > >
> > > The kernel needs to be able to accommodate all of them.
> > >
> > > The kernel default should accommodate the people who
> > > are least capable of configuring their systems.
> > >
> > > Hyperscalers can set their own defaults across their
> > > fleets. They know how to adjust settings.
> >
> > They can use a safe value, e.g., 100% of RAM. Let the people who know
> > exactly what they want to swap configure the boundary they want.
>
> My personal preference would be for a default uncapped (or very high,
> and I don't think 100 % of RAM is high) limit on the uncompressed data
> which is backed by zswap, since that would mean one less knob to tune.
>

Thanks for the data, and for the testing. Please let me know if you
have any requests or encounter any problems :)

And yes, I completely agree with you. We're having a very backward
conversation. The default should ALWAYS be less hassle for userspace.
Ergo, as transparent as possible.

Exposing priority, sizing, etc. is *adding work* to userspace. That's
the position that needs justification, not the other way around.

