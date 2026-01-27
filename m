Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A377D2FED9
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 18:53:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F272B6B0005; Tue, 27 Jan 2026 13:53:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1546B008A; Tue, 27 Jan 2026 13:53:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBD176B0005; Tue, 27 Jan 2026 13:53:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C4A2C6B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:53:09 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C690C1842
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:53:09 +0000 (UTC)
X-FDA: 84378641298.10.530CB3C
Received: from mail-dl1-f68.google.com (mail-dl1-f68.google.com [74.125.82.68])
	by imf05.hostedemail.com (Postfix) with ESMTP id 66917100008
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:53:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZIW0tM3N;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769539987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrLY1d8MKKr/lNfj/RjogCGbPhK6ypIdEBSRs17/+is=;
	b=r9VlltiiyW1iI5lWGmgKsxmLZtKLqqGyivFKRMBwmeD3791tdiXRGX8rHSnSB567E2aBOP
	xdRkaY+IUhs7O4NkRRW/68m5DY4mLixuf79VQ6zFwLMZAsY0zwv1tOYkqJKFxPHe+2B/7c
	g1PrInXYYlMutk47R7SsuH68qjnd9tQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769539987; a=rsa-sha256;
	cv=pass;
	b=z+13UnYbq07zfpUgIb+nN63qwwfUyf8D1c9fF38JsA9KMRvL/besFINxtbYwnF4OsjHfry
	Gfyl0pCzqFiYnZknDoXTABSL0m9FCAMCdVcRHhBvCGQ34OTBWStCycg2dAKzBPrrZKXjNP
	cZBcyJe5YSrSFLC0YNPBVVLfTCllXtQ=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZIW0tM3N;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f68.google.com with SMTP id a92af1059eb24-124566b6693so13329077c88.0
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:53:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769539986; cv=none;
        d=google.com; s=arc-20240605;
        b=RmTSYjZW74WYCBDSh+5hDBijLe8Ma7RuS7ghjuFzCd1wf5VKQt6xbLYTF0jlLR3Oft
         F+l+TesH4xTgsyH9HivX32DPDTOgdn3xbpCekLAXAASGqDx7pjj5ltxS+VvPprszjpyB
         b3kofogniOlEXi+IgYzzY5SeBFLwvxjhgOQtvLD0OVmf9q1vg7wcMI695SuSvAspy1TP
         Zn6QdKhnqT4YySr7OYDtDYSJlkWaFKTxoooBdK0A3c+zzAsojNcsyEZ3IDNBBxPhw6aG
         TOosVn4wNZrq4ypCHLbki39LQiXj1EHBttjmsnsAi3ravn+SuDvdNsn3cntLDG+NOrcf
         +qxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hrLY1d8MKKr/lNfj/RjogCGbPhK6ypIdEBSRs17/+is=;
        fh=G/41qzSJkhLScrOa2wb521NW7HSESri5MScSILObPm4=;
        b=MpYsSr8Nv/8ti1Mm282s4ThCmmXpcywv3MZPTsnqgsbpYg+ddvW9z1mWplCxJTLXP0
         fHERZn9OINB+GMOfze1L60DpRL261ur4LOg7Vs8ZhU1YQvy+WeYsr+6xaFMZNsUgj7j5
         0BpmduXdoWpBKEhss9boAn2meztBLot7/MrkmOCBd97lKBpl4+QHvPFiR06AXrjGp5cu
         46/avqxEfyj9ZhGI/T6ZP4d6qTqV22hoLWOMqbrJ6JXuaua2513cEFTrut2GdcsUxph6
         5K4MqhUfmgnBWgGlGIKgC4uI2/tZcqgOkv0hiAPpzc2tLLybkDOsFPSk0cHjWg9HUDu/
         X+DQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769539986; x=1770144786; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hrLY1d8MKKr/lNfj/RjogCGbPhK6ypIdEBSRs17/+is=;
        b=ZIW0tM3NyEcZ8PJC1GIayu09xEYA9jhyHBOMxS9lyUkZF5mJN3qAHDfBrHQTFo8u6Y
         JEH/mTSMHg96WO1d+4qOtxeMZZdbF1MRPTclUy4vZ6AJFl1KPjWUYctoHRiOXlPpsdcq
         U3VHyxzE/JPXLkbCK+B2zxnFSnw+4Go1j7KoKwVr+CqtGnhRt0ad0QCDGm45KFiCFDZA
         HYOSMCBKAJmKw94+f+h6zprXfQPq7QjzBACuPDJCZlusHzoCQgxKkslUqN9dAbq6UAcm
         UsOVOKNy5piujks7gYyQ/7WJktGGEwG+VwFCKQ0YyFl7EtICqjQ7NM+CXZcgSmn2V1y5
         pmLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769539986; x=1770144786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hrLY1d8MKKr/lNfj/RjogCGbPhK6ypIdEBSRs17/+is=;
        b=ct9UMrmmgezlLtQYiFcalIWrp70i3aemBVRzQMiAS7SBqTkxHu57oyT85+k91/u4Rz
         m+YYfeztPZUkU5t6tlnfOxbMtWKuM7RpubBtBQ+hLz+uJvO6hH9vyibyzxsR++l4Yqgf
         aZs0ZHPmM5TskE7Vr25CzNGMWZvxSq3ji9c4ZJuyVGJOI7jckgcuvhol4D2DZ0gOMCMY
         L5UXFGgbOabSMLvrPHNu7UBT2sZQ0sbvbqlWbnYmc2h2gJMXTflZcACsKDKTc8/naqRG
         y53z5m1Psv33iN7wXI2NsBI9qlLOqjbkm/6HPkB5pOEZ3zRk0gMiTGZh3+jtrUHaqvmo
         zCJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQaVY4KNRUZ2NlUyf8TGKLluiPAXRBihL2IRItfldFXPDRCtAtzhXnbNn4haoXZJjArP18BIvV8w==@kvack.org
X-Gm-Message-State: AOJu0YyQiY14J2JdEXwol9lf/QIdbc4FNdbC3irzgc6QyjCZS2Ly2dT9
	6loZ02GNH0kWioK33bsuSqOECJYPdBKWSBTneuM023eSVqooCP6oTaGEtdUsh3zoSo+eoDFqzfD
	fKSYxeGELUnIl7eIxgja/U1u2orRy6Q==
X-Gm-Gg: AZuq6aK+c2IK6RfquA7hvaPJY82/l55KiiLHTiGYqpBaTMitZ3/c98OPgDE62i2In6O
	xFkIzF9AXDGEXono8gHZLiGQMTzZPZKypZdnGsRESD1KSyTQor/QsAAzZPQJMjmYwBnAMCo9znz
	ysS47tl27i91cU7SvI1W/I3fETar1cZ6lkO99ydc6nEz1LMRFVTbQTe5Z46yksrKYXBwkY5wkUw
	Bg5k1A9dScmKOdX0gxwbnM3HW169WJnFlwI0k1YNm8JPxlQ1yeBGIcCaZeQkWI7bESEUAw=
X-Received: by 2002:a05:7022:3b86:b0:123:3bba:fc4c with SMTP id
 a92af1059eb24-124a0114530mr1399404c88.38.1769539985752; Tue, 27 Jan 2026
 10:53:05 -0800 (PST)
MIME-Version: 1.0
References: <20260123045733.6954-1-ravis.opensrc@gmail.com> <20260124015045.78075-1-sj@kernel.org>
In-Reply-To: <20260124015045.78075-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Tue, 27 Jan 2026 10:52:53 -0800
X-Gm-Features: AZwV_QhLWpILFmBNmv_VUaKUIKDcnzxznZsbnQGx_3zRIdW1Tlcdm7ps20MNsQ8
Message-ID: <CALa+Y17__d=ZsM1yX+MXx0ozVdsXnFqF4p0g+kATEitrWyZFfg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] mm/damon: Add node_sys_bp quota goal metric for
 PA-based migration control
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, Honggyu Kim <honggyu.kim@sk.com>, 
	Yunjeong Mun <yunjeong.mun@sk.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 66917100008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: kq9pgi18bq3s9n58skxqj3xkks4ua33x
X-HE-Tag: 1769539987-499769
X-HE-Meta: U2FsdGVkX19Px0jgsMCZwoJB1VjYO/+Ffy87MRIfBpyqPNQTsDAPFZ5PjzZUd+us7QtWRh6C2UNX53hkB6OST+8xuXKi5NyE0B6a60TLtJqMPa1pgcAF9uFhQvsPoL2MC9Nk+nYRyCxZZsJ2AtgI0IWiVulLCHhKlfwwA6lbCVnr8M1YmPGEsSc9MwjoRiyR2GiWgDz7NhQFq9GobLBJfgSO2QmuP9DHaa8HGDM59jmu2IQqc3r/cL6TDDMuEUIwkrbEAMyrNnhjIYNnm+ZeXf6E5tw1WSRb7CEaNrTj++thSti7fnNI86jLDhiDCYQGW2NF1mlAucQ0+sEjqlB5gFIQfEEmPvJDT6H4FWmS48AOU9+ecZ7JnGWULzzj8QsSO1/8X1VgobwhhWE2Chw5DcftDwfqA/lv6DIOXjT5RGPQbX/oxK6XpB66pmIk3R+Pb43Wz2wpIHwAYYvNoZ4h9lqGwXNOKPcepNtzclezBWFTZvVb3NWbGFlHc6gsLe1hm790I0faOWFSoikHyq6i+c2ETH8B1J15JK8hQfP+yE/IhKmFzc/jcUWe3zEBq/c0eTUwLcGrl/X91yz+P/fSivxp2GdWukd3YO02LJnJigZk/ZHQSxpF/xfyx6vARWBJ2lxkDMQ7Hjjm8h86GIY5Tx0m/a4jGEZB8AlnNAKHkIfxrXsJQaRvRaBA+dY1iScaPk9cU6oNySZyH1eBTC2YFznHpytlKtefvWo4WEjDnxw/1zCvz1WD03xXZyDBHQ8SI0LYiFvaHFYxeHzYc2JPIZ+aF9nYv5PP4ol7jMx+2CSpD67UBhB9eWTjsmM6LM/KKAxVW8bxpvGyP0jQU+Tf2t+5W4K5HlK+TzfjB73GK37KBVu9wKGXi2o9daXjt+FXIi4GbrtoNTdxwPP7IZBPWNU9E6dnge2PXW4hP0/kFVEciW4zgkrmuT3ujHhVjnacgmfEm2CCasyz2X+E4iM
 j0qmg/HS
 ZmtOtoLclaw5kce0sMeRaieTFM0k9I3edy7UxKWXuFamHHBi+bL48JVpxnRqsJ2Usev+kxrEZhtN9PFlQ9PZ5F90jcmmAp8FzZG5gNYkTbWBxJ7ksm6JquIAsfyF6bzbwO3x7IAoAtRIGG/r/+Nk68FDkrPoqaKd3OV1ACdzChbcU/eilirTQE3v5YTGu9yTPTZCrJUC6ljT+uyMhbGXr//JXmkiPsj64jqeh3N2Q+7L73TdlXdc7LvjXOfziLJwwfZFET4H3xdtmE/lTasNQS2gBOz2HFGk7QWaHDSU1mF8V+tIsG7QlFmrVgpbMiBslxm8IGs7GOcq0b0kQ7pCY4/fwqZjsGUG19ZwCE1mnkokZ7pbE890iVTBfnn5cGFPXlnXe1U+pBZaVk8WFx2DnY18nJDsmtvFuSSizEx9WHFOIvLgcqtT81ehg5rG9SLnJHuq/CYjGgXSskw4AVDAAy0qzXhmIZniFrrcxWyEd049FSDH27QXU4AuW/Uvs7JcN6lhirbOyOin/LJm31w1sx0g/mw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 5:50=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> Cc-ing SK hynix folks (Honggyu and Yunjeong) for quota auto-tuning behavi=
or
> confusion (not stop immediately after satisfying the goal) I discuss belo=
w.
>
> Hello Ravi,
>

 Hi SJ,

  Thank you for the detailed review and for Cc'ing SK hynix folks.

>
> Thank you for sharing this great RFC!
>
> I had a chance to be involved in a high level design of this series, off =
the
> mailing list.  I'm disclosing the fact for others' context, since a few o=
f my
> comments below are based on the previous off-list discussion.
>
> On Thu, 22 Jan 2026 20:57:23 -0800 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> > This series introduces a new DAMON quota goal metric,
>
> As I discussed off the list, I believe the new goal can be useful.  Thank=
 you
> again for making this!
>
> > `node_sys_bp`, designed
> > for controlling memory migration in heterogeneous memory systems (e.g.,
> > DRAM=E2=86=94CXL tiering). These patches are provided as an initial RFC=
 and have
> > not been tested on actual hardware.
>
> I feel like the name is not very self explaining what it is, though.  I'm=
 also
> bit confused about what it does is what we discussed off list.  I'll add =
more
> details below, on more detailed explanation about the new goal.
>

Will change the name to damos_target_mem_node_sys_bp in v2.

> >
> > Background and Motivation
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> >
> > A previous patch series [1] by Bijan Tabatabai and myself added weighte=
d
> > interleave support for DAMON migrate_{hot,cold} actions. That series
> > implemented the feature for vaddr (virtual address) schemes because the
> > weight-based approach requires VMA offset information to determine targ=
et
> > nodes:
> >
> >     target_node =3D (vma_offset % total_weight) =E2=86=92 node_from_wei=
ghts
> >
> > For paddr (physical address) schemes, obtaining VMA offset requires cos=
tly
> > rmap (reverse mapping) walks. As noted in that series:
> >
> >     "However, finding out how a folio is mapped inside of a VMA require=
s
> >      a costly rmap walk when using a paddr scheme. As such, we have
> >      decided that this functionality makes more sense as a vaddr scheme=
."
>
> Indeed the rmap overhead was one main concern.  I'd like to also note tha=
t,
> however, another major concern from me was that the behavior sounds not e=
asy to
> intuitively understand.
>
> >
> > This new series takes a different approach that enables PA-based migrat=
ion
> > WITHOUT requiring rmap walks, by using basis points (bp) target-state g=
oals
> > instead of weight-based action rates.
> >
> > The rmap Cost vs Oscillation Trade-off
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > For PA-based migration with weights, there are two possibilities:
> >
> >   1. Weight-based with rmap:
> >      - Use rmap to find VMA offset for each physical page
> >      - Apply weights based on VMA offset (same algorithm as VA)
> >      - Works correctly: VMA offset provides stable identity
> >      - Problem: rmap walks are expensive for every migration candidate
> >
> >   2. Weight-based without rmap:
> >      - Attempt to apply weights using only physical address information
> >      - No stable identity across migrations
> >      - Results in page oscillation (see below)
> >      - Not viable
> >
> > The Oscillation Problem (Weights Without rmap)
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Weight-based migration relies on a stable identifier to determine which=
 node
> > a page "belongs to". For VA, this is the VMA offset - it remains consta=
nt
> > regardless of which physical node backs the page. For PA without rmap, =
no
> > such stable identifier exists.
> >
> > Consider a two-node system with weights {Node 0: 40, Node 1: 60}:
> >
> >   Initial state:
> >     Hot pages on Node 0: PFN 0x1000, 0x1001, 0x1002, 0x1003, 0x1004
> >     Node 1: empty
> >
> >   Iteration 1 - Weight-based selection (no rmap):
> >     System tries to achieve 40/60 distribution
> >     Selects pages at PFN 0x1002, 0x1003, 0x1004 (60%) for Node 1
> >     After migration, these pages get NEW PFNs on Node 1:
> >       PFN 0x1002 =E2=86=92 PFN 0x5000 (Node 1)
> >       PFN 0x1003 =E2=86=92 PFN 0x5001 (Node 1)
> >       PFN 0x1004 =E2=86=92 PFN 0x5002 (Node 1)
> >
> >   State after Iteration 1:
> >     Node 0: PFN 0x1000, 0x1001 (40%)
> >     Node 1: PFN 0x5000, 0x5001, 0x5002 (60%)
> >
> >   Iteration 2 - Weight-based selection runs again:
> >     System sees pages at PFN 0x5000, 0x5001, 0x5002 on Node 1
> >     These are "new" pages from the system's perspective
> >     NO MEMORY that these were just migrated FROM Node 0
> >     Weight-based logic may select some for migration back to Node 0
> >
> >   Iteration 3, 4, 5...:
> >     Same pages continue bouncing between nodes
> >     Each migration changes the PFN, erasing any "history"
> >     System never converges to stable state
> >
> > The fundamental issue: weights define an ACTION RATE ("migrate X% of
> > candidate pages to each node") rather than a TARGET STATE. Without stab=
le
> > page identity (which rmap provides via VMA offset), the system cannot
> > determine which pages have already been "handled" and continues to
> > reprocess the same logical pages indefinitely.
> >
> > With rmap, the VMA offset provides stable identity - a page at file off=
set
> > 0x1000 always hashes to the same target node regardless of its current =
PFN.
> > Without rmap, we have no such anchor, and weights become meaningless.
> >
> > Solution: bp-Based Target State Goals
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Instead of specifying action rates, `node_sys_bp` specifies a TARGET ST=
ATE:
> >
> >     "Node N should contain X basis points (X/10000) of system memory"
>
> I'm not sure if this is exactly what we discussed off list.  What I expec=
ted
> the goal would be based on our discussion is, what the first patch is say=
ing.
> To quote the part,
>
>     @@ -155,6 +155,7 @@ enum damos_action {
>       * @DAMOS_QUOTA_NODE_MEM_FREE_BP:      MemFree ratio of a node.
>       * @DAMOS_QUOTA_NODE_MEMCG_USED_BP:    MemUsed ratio of a node for a=
 cgroup.
>       * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:    MemFree ratio of a node for a=
 cgroup.
>     + * @DAMOS_QUOTA_NODE_SYS_BP:           Scheme-eligible bytes ratio o=
f a node.
>       * @NR_DAMOS_QUOTA_GOAL_METRICS:       Number of DAMOS quota goal me=
trics.
>
> That is, my understanding of what we want to achive with the new goal is,
> letting users to ask DAMON "migrate hot pages of node A to node B, aiming
> X % of node B becomes hot, as a result of the migrations".
>

Yes, this is the intent. Looking back at my implementation, I see the
mismatch:

1. **Numerator**: Should count only scheme-eligible bytes.

2. **Denominator**: Should use node capacity, but I used total system
   memory.

> But your above description is not saying about the "scheme-eligibility". =
 Also,
> the goal metric is the ratio of the memory to the entire system memory, n=
ot
> just a given node.  My quick read of damon_pa_get_node_sys_bp() on the se=
cond
> patch of this series confirms the implementation is following your descri=
ption,
> not what I imagined.
>

You're right. The implementation diverged from what we discussed. I'll
fix both the numerator and denominator in v2.

> Have you found something we missed during the off list discussion, and
> therefore changed the definition of the goal to the current one?  If so, =
could
> you share the details?  Or, you might also wanted to implement what I exp=
ected,
> but something bothered your code and documentation?
>

While implementing, I was thinking about how the metric would behave
in a
system-wide context across multiple nodes and ended up using total
system
memory as the denominator, thinking it would simplify distribution
calculations. However, as you pointed out, using node capacity as the
denominator is the right approach. I'll fix this in v2.

> >
> > The migration control loop:
> >
> >   1. Calculate current_bp: sum bytes per node across monitored regions
> >   2. Compare: if current_bp >=3D target_bp, STOP (goal satisfied)
> >   3. Otherwise: continue migrating toward target
> >
> >   Example with target: "Node 0 should have 4000 bp (40%)"
>
> Regardless of why my expectation was different from this one, the goal I =
was
> expecting might still be used for your descripted case.  That is, the sch=
eme's
> target access pattern could be "any access pattern", and the target metri=
c
> value could be adjusted based on the ratio between the node 0 memory and =
the
> total memory.  For example, let's suppose there is 100 GiB memory in tota=
l, and
> 80 GiB memory in node 0 (80% of total memory in node 0).  Then 40 % of to=
tal
> memory, which is the target of the above example, is 40 GiB, which is 50 =
% of
> node 0.  So, you could use the goal I expected, with 50 % as the target v=
alue.

Agreed.

> Imaginable usage of that would look like,
>
>     # --damos_quota_goal receives <metric name>, <target metric value>, a=
nd
>     # <node id of the goal>
>     damo tune --damos_action migrate_hot --damos_quota_goal new_goal_metr=
ic 50% 0
>
> I sure you know that you could s/migrate_hot/migrate_cold/ if you prefer
> migrating cold pages first.
>
> So, the metric of my expected definition can still be useful for your new=
 use
> case.  I'd prefer my expected definition if there is no concern, since it=
 seems
> useful for more cases.
>
> >
> >     Iteration 1:
> >       current_bp =3D 10000 (100% on Node 0)
>

Got it.

> How could 100% system memory can be on node 0?  Are you saying 100% of "h=
ot"
> memory?  This makes me suspect you _might_ actually wanted to implement w=
hat I
> was expecting and the first patch of this series is documenting
> (Scheme-eligible bytes ratio of a node) but somehow something bothered yo=
u to
> drop the ball in a wrong place.
>
> >       target_bp  =3D 4000 (40%)
> >       current > target =E2=86=92 migrate cold pages away from Node 0
> >
> >     After Iteration 1:
> >       current_bp =3D 4000 (40% on Node 0)
> >
> >     Iteration 2:
> >       current_bp =3D 4000
> >       target_bp  =3D 4000
> >       current >=3D target =E2=86=92 STOP, goal satisfied
>

Right, that example was misleading. With node capacity as denominator,
"current_bp =3D 10000" would mean "100% of the node's capacity is
scheme-eligible pages" which would be a valid state.

> Please note that the goal-based quota auto-tuning works in proportional w=
ay,
> preferring small steps and "eventual" goal convergence.  As a result, mig=
ration
> will occur a few more times until it is completely stopped after the goal=
 is
> satisfied.  Unless there is another scheme that migrates pages into node =
0, you
> may end up having node 0 having a bit less than the 40% memory.
>
> >
> >     No oscillation - migration stops when target state is reached.
>
> So, little bit of oscillation could still happen.  Hopefully that shouldn=
't be
> significant, though.
>

Yes, As we discussed offline, for a two-context approach:

      Context 0: monitors node 0, migrate_hot =E2=86=92 node 1
        goal: damos_target_mem_node_sys_bp, nid=3D1, target=3D4000
        "Stop when node 1 is 40% hot"

      Context 1: monitors node 1, migrate_hot =E2=86=92 node 0
        goal: damos_target_mem_node_sys_bp, nid=3D0, target=3D6000
        "Stop when node 0 is 60% hot"

Each context eventually stops when its target node reaches the desired
threshold,
and the reverse direction is handled by the other context. For my use
case, eventual convergence with this setup could be acceptable.
An immediate-stop feature could still be useful for the broader community.
Will test and post results after the next iteration.

> IIRC, SK hynix people also confused with the behavior when they experimen=
ted
> migrate_{hot,cold} action with NODE_MEM_USED_BP goal based quota auto-tun=
ing,
> but using only a single scheme that does migration in a single direction.
> Because this is at least second time it made confusion, if you need, mayb=
e I
> can try to add a feature for making DAMOS immediately stops after the goa=
l is
> satisfied.  Let me know if such new feature can be useful for you.  Cc-in=
g SK
> hynix people (Honggyu and Yunjeong) so that they can correct me if my mem=
ory is
> broken, or answer if the new feature I described here can be useful for t=
hem.
>
> >
> > No page identity tracking needed because we measure the END STATE, not
> > which specific pages were moved. The early-exit prevents oscillation by
> > stopping when the goal is met.
> >
> > Why get_goal_metric() Ops Callback
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > The bp calculation requires iterating over monitored PA regions:
> >
> >     for (pfn =3D start_pfn; pfn < end_pfn; pfn++) {
> >         if (page_to_nid(pfn_to_page(pfn)) =3D=3D nid)
> >             node_bytes +=3D PAGE_SIZE;
> >     }
> >     bp =3D node_bytes * 10000 / system_total;
> >
> > This requires address-space knowledge that only the ops provider has.
> > Existing goal metrics (PSI, node_mem_*, node_memcg_*) are computed in
> > core using system-wide data that doesn't require iterating monitored
> > regions.
> >
> > The new `get_goal_metric()` callback in `damon_operations` allows:
> >
> >   1. Core to remain generic - handles all common metrics
>
> I agree this is indeed making the design clean.  But, we already having s=
uch
> exception, like core.c code using 'damon_target_has_pid().  Having just o=
ne
> more exception seems ok to me, unless it makes code too ugly.
>
> >   2. Ops providers to implement metrics requiring region iteration
> >   3. Clean separation - PA implements node_sys_bp, VA could add
> >      different metrics in future
>
> I agree it could be useful for clean support of virtual address mode in f=
uture.
> But, I'd prefer making this as simple and small as possible for the suppo=
rt we
> will use at the moment.
>
> >   4. Optional implementation - ops return 0 if metric unsupported
>
> Again, letting core logic having a bit of ops layer information is not a =
big
> problem to my humble perspective.
>
> So, I'd more prefer not adding the Ops callback, unless you have some oth=
er
> concerns.
>

Agreed. I'll remove the get_goal_metric() ops callback in v2

> >
> > This design ensures node_sys_bp is only computed when using PA contexts
> > where it makes sense, while keeping the core quota goal infrastructure
> > unchanged for other metrics and ops providers.
> >
> > The callback pattern allows each ops provider to implement metrics
> > specific to its address space model without burdening the core with
> > ops-specific knowledge.
> >
> > Advantages of PA-Based Migration
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > PA-based migration with DAMON enables integration of multiple hotness
> > sources for migration decisions:
> >
> >   1. DAMON's native access pattern monitoring
> >   2. Fault-based information (similar to NUMA Balancing)
> >   3. Future: Hardware monitoring units (e.g., CXL CHMU)
> >   4. Future: Instruction-Based Sampling (AMD IBS, Intel PEBS)
> >
> > Unlike VA-based approaches tied to individual process address spaces, P=
A
> > monitoring can aggregate hotness information from multiple sources to m=
ake
> > system-wide migration decisions across the entire physical memory space=
.
>
> Maybe you are saying about the damon_report_access() based DAMON extensio=
n
> project [1]?  Since it is not yet upstreamed, and the long term plan is t=
o
> support not only physical address but also virtual address space, I think=
 this
> section is better to be removed, unless the DAMON extension project is me=
rged
> before this patch series.  I expect this patch series will be merged much
> earlier than the extension project.
>

Agreed. I'll remove the references to future hotness sources.

> >
> > Complementary to Existing vaddr Migration
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > This series complements rather than replaces the vaddr weighted interle=
ave
> > migration merged in 6.18:
> >
> >   vaddr migration (weight-based):
> >     - Per-process control
> >     - Fine-grained interleave patterns via VMA offset
> >     - Deterministic placement based on weights
> >
> >   paddr migration (bp-based, this series):
> >     - System-wide control
> >     - Target-state goals for node capacity management
> >     - No rmap overhead
> >     - Aggregates multiple hotness sources
>
> As I mentioned above, the last item could be dropped until the extension
> project [1] is upstreamed.
>
> >
> > Capacity Clamping
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > The series also implements capacity clamping for `node_sys_bp` goals. I=
n a
> > system where Node 0 has 40% of total RAM, setting a target of 50% is
> > impossible. The implementation clamps:
> >
> >     effective_target =3D min(user_target, node_capacity_bp)
> >
> > This prevents the quota auto-tuning from chasing impossible targets and
> > avoids thrashing in two-context DRAM=E2=86=94CXL setups.
> >
> > Patches
> > =3D=3D=3D=3D=3D=3D=3D
> >
> >   1/5: mm/damon/core: add DAMOS_QUOTA_NODE_SYS_BP metric
> >        Adds the enum value and documentation.
> >
> >   2/5: mm/damon: add get_goal_metric() op and PA provider
> >        Introduces the ops callback and PA implementation that iterates
> >        monitored regions to calculate node_sys_bp without rmap.
> >
> >   3/5: mm/damon/core: add new ops-specific goal metric
> >        Wires the new metric into core's quota goal evaluation, delegati=
ng
> >        to ops.get_goal_metric() for DAMOS_QUOTA_NODE_SYS_BP.
> >
> >   4/5: mm/damon/paddr: capacity clamp and directional early-exit
> >        Adds capacity clamping and early-exit logic to prevent migration
> >        when goal is already satisfied.
> >
> >   5/5: mm/damon/sysfs-schemes: accept "node_sys_bp" in goal's target_me=
tric
> >        Exposes the new metric to userspace via sysfs.
> >
> > Status
> > =3D=3D=3D=3D=3D=3D
> >
> > This is an early RFC for design review. The patches:
> >   - Compile successfully with no errors or warnings
> >   - Have NOT been tested on actual hardware
>
> I understand you plan to run tests, and that would be useful, appreciate.=
  Note
> that I think having no test results is blocker for RFC patch series.  So,=
 again
> appreciate for sharing this RFC! :)
>
> >
> > Feedback on the overall approach and design is appreciated.
>
> I hope my above comments helps the forward progress of this nice series.
>

They are very helpful. Thanks a lot.

> >
> > References
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > [1] mm/damon/vaddr: Allow interleaving in migrate_{hot,cold} actions (v=
4)
> >     https://lore.kernel.org/linux-mm/20250709005952.17776-1-bijan311@gm=
ail.com/
> >     Merged in Linux 6.18
> >
> >
> > Ravi Jonnalagadda (5):
> >   mm/damon/core: add DAMOS_QUOTA_NODE_SYS_BP metric
> >   mm/damon: add get_goal_metric() op and PA provider
> >   mm/damon/core: add new ops-specific goal metric
> >   mm/damon/paddr: capacity clamp and directional early-exit for
> >     node_sys_bp
> >   mm/damon/sysfs-schemes: accept "node_sys_bp" in goal's target_metric
> >
> >  include/linux/damon.h    |   5 ++
> >  mm/damon/core.c          |  34 ++++++++++---
> >  mm/damon/paddr.c         | 102 +++++++++++++++++++++++++++++++++++++++
> >  mm/damon/sysfs-schemes.c |   7 +++
> >  4 files changed, 141 insertions(+), 7 deletions(-)
> >
> > --
> > 2.43.0
>
> [1] https://lore.kernel.org/damon/20251208062943.68824-1-sj@kernel.org/
>
>
> Thanks,
> SJ

Thanks,
Ravi.

