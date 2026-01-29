Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2480D46C01
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 00:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 349B26B0089; Wed, 28 Jan 2026 19:44:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F44D6B008A; Wed, 28 Jan 2026 19:44:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F2FB6B008C; Wed, 28 Jan 2026 19:44:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F7FD6B0089
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 19:44:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD9775B765
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 00:44:40 +0000 (UTC)
X-FDA: 84383155920.17.EE51FC0
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id E03304000E
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 00:44:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OfbsWINi;
	spf=pass (imf04.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769647478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XwM3zfTFqHE5kmjZguuH0nYrlQY8HFwC7+d1W+Ezm88=;
	b=7HslRHvIfa0wJfT6YccitYAnRp8V4alYbdv4+i3jL1YHmMl6cFzoP9ZA5E7Uza9iCM3b6i
	pgPyYvvT1fiiCi3DHU70dEUkcBK6f9nEHbUG+S6pQsrj2QibEPRCpErdkoO3BhY2O62Xta
	n23oETFqSHoDSu3Zi0figLGpQ6vaGTg=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OfbsWINi;
	spf=pass (imf04.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769647478; a=rsa-sha256;
	cv=pass;
	b=1qHaWCyhUSgqgDa2Wgk/391V16dUTMRRJH2MYMD5yc5GdsB4dWlJ/pLrL3tatY3JWCWEb9
	0t0jwqY8c4SBjKkrTxT0xDZHwaJEwnGDhgeUzTkPq19h8kCNAZcv/fYA5bal2OneQi+Pxb
	q/kn0y5QOyFBq+xG5nCzoP/szJOWib0=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-894703956b8so7510106d6.1
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:44:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769647478; cv=none;
        d=google.com; s=arc-20240605;
        b=lFRn5Dsq+SssWa3b3TLBsbEdoBR4kwbXke5yQDEUR6SM2pvsuPOlmkE6v4ZDHFXW8W
         kRySEb4RwuxoNveuAqOrROsQmSYlOf5DAWoVuvvy4EyCAqEdZMP89Xc83+gc82ieO/Vp
         LpteuobTaFph9aB4+shZUyxQ52HGdw3jyCIV0oELMLzH3ln9PigpvMeklsfFzVQp+bfv
         DevifeJ2DefBJp5XF4V96IIO6YEHgbQWujFENyPaWiSVFoNttOOZOSFN1uASwwkPE/G3
         CWaQKhfr5dD5h3k3vbDR6aeP0JPonRpoERa36bXWbUXtr/LBpgvohpys1RcXVm//ZyGm
         V2ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XwM3zfTFqHE5kmjZguuH0nYrlQY8HFwC7+d1W+Ezm88=;
        fh=CzQQQ4l3IJAM5rpWzMuPkrB+6ruLCocjaSBzYZ9/IIY=;
        b=cg82cKbPPjkLJ5sP1HrOSnBel5/bon28lM659pYEzIuPJlmuex8DvEeTOcr3tmX3VP
         /SsTfcXJA4pV3GVsJAaBImE6Laags6NIS7QcUga46n58AC8WDs8uGiLjsUNcrKwFXVXs
         DBU6EX7d66r4aMSNuiKpewqAuso5QDxWkgCAPxeKR8h3d9+XBlnL20eEND6b5rQ3hT2z
         STtFbazGyxY3ODJ1HtSAAXViReqOMY/18TEMutw3xtBahGDlD5CVjQrf4rLF8XXwlZbQ
         CLZnMWw8iyf8aGFje3uw/GKr3BcojGhbX9bpb9rFrp6t+JYTYL/2FPxEz1ejb0oc78u8
         wMXA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769647478; x=1770252278; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XwM3zfTFqHE5kmjZguuH0nYrlQY8HFwC7+d1W+Ezm88=;
        b=OfbsWINi1004LRLGZJQgC0JGOdN7ndBYrCvmpBfuQGK/0tGQ6fYR1/YYpTPBTRS/Dv
         ZAsmn5Q9pG/x1G8Kui26VtdxSN95JcR40wITY16DGCh0oOPFhQR3w5g2HAQOQ9tRP+7O
         AUdZD5viDe2neM9/xnut8ijJ8OiogPxCGXPSmpFSvXEVXw12iyC/UH9UMNQ+58ZsEd5+
         7gbfuJuaFjB5DLvmumxvzC34ovpshZtsloHrvus1uXrEDhKDtAyFanCCHigYdSo8+Rmi
         Qj8knXDciaLGV6KsOpaaDejbAD3Q1w7QXsfWRHeuvFZPBHOdmivkzwpg0Fo8yW7kIda0
         klAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769647478; x=1770252278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XwM3zfTFqHE5kmjZguuH0nYrlQY8HFwC7+d1W+Ezm88=;
        b=oWjR3ySezTxzVc+K88ohx2HKHNit4nlqo0VQUzFVZnFY5siE7t8OWQCG4j8YRI8HQt
         rqO0ilj7hm8+qHqdjoXsfK/KRiS+3cCMQyXZU31eKVHlPIjf2l1zS2iD+QhgB/dNDg5y
         4SwTNsT8g78quFDpJEPRXC1CRs3dV2hDRfFSeSZh7CsEWWwi63LdBINq/fdtgZbHVNAY
         btUquM6IRbml8sDK5oM9etkJJOAPiNz7DkL2NHciQ5v4WBY0jy3tVNzUBCvfRW/kolEO
         bhAfKq9iatCz3GO4r0PsaDwkI2MtMxh5VxVOOgA/f+7TWhty/H9rbtz9N3cWNfD217U0
         dj2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXLJcNHTwKFns7RJttanl1tkbiavGpO056xB9qQoyVaCEio24UfbUBCUFo4LpPPoHikLd9NShRQFw==@kvack.org
X-Gm-Message-State: AOJu0Yyu3ZMMJmNQss1dRXSVphUSiUN0/QWXHQu5bCPGKeRjVRMaDdHo
	OPCGX73sKvYwZtbplj/2Wci2re7jY6kghEyRI+7PY4yFIDKpWcX2BX3DkF/iiJzgQ3DxtwtzazK
	vcasP5EN1fp6zpK1AUEkSatxYVV584mQ=
X-Gm-Gg: AZuq6aIonVENuAmcXou1NPE8pj3BnpHofB2htwH8WFQmBU13aNEv/uKt0vpfTmhKvTm
	u0BeB8VoiKUiP48fTMGG5mrhsZXOlJQHgIs1Zm6/sY6GWyXEahDw8nO7Ke5CnZdvyYZoljz4LSD
	Rwl+7j6PRKXOTw3KbwSHVauyjDmsD81+/rip/wPxkei5/LQD+RcmeCISau3KpG7nVwt5EzxrOzA
	chkRsrNFhFy6DwFsoBuz9jwg4EYcLj7Ml1b8EVtweWriO0Kb24Pj8LEidyJBn1tB1IQxbgurKJi
	fqiAp/uRqFsSrJijKPSG8bE=
X-Received: by 2002:a05:6214:d85:b0:894:7fd1:923a with SMTP id
 6a1803df08f44-894cc835eacmr95525106d6.24.1769647477989; Wed, 28 Jan 2026
 16:44:37 -0800 (PST)
MIME-Version: 1.0
References: <20260108101535.50696-1-akinobu.mita@gmail.com>
 <20260108101535.50696-4-akinobu.mita@gmail.com> <aWEn2ODG0gyej0Xr@gourry-fedora-PF4VCD3F>
 <CAC5umyhoMi_J_Ford2M_1fB-qCuPEDopAK1OF=AisZyDZ8duJQ@mail.gmail.com> <aXkfBF5bdnTZ7t7e@gourry-fedora-PF4VCD3F>
In-Reply-To: <aXkfBF5bdnTZ7t7e@gourry-fedora-PF4VCD3F>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Thu, 29 Jan 2026 09:44:27 +0900
X-Gm-Features: AZwV_QgUyHkG-WUI7iNcz5xWCWhbTMOceR-EUzNXVnt7j2TJLEh0eaXRurf4hjo
Message-ID: <CAC5umyieqMyasC=nZNtpP0jrO-YEYEZ1KyGeX=E=ZtWrYyDpMg@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
To: Gregory Price <gourry@gourry.net>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, bingjiao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: dq5i8hw5ffrhd5xxgqiujqgdawaots1s
X-Rspam-User: 
X-Rspamd-Queue-Id: E03304000E
X-HE-Tag: 1769647478-753764
X-HE-Meta: U2FsdGVkX18oSLivfhyq+//LmPkC5TTsqd1OTcvsStHPPecwguu8pmaceTRHyQCTVnrjWvJAYjXn7PXVgOAORZLinJuTCJootpF3oKff4NE5a6CAYaG05OLNEbpZEz6WVEaKzz+4FzqEQAVIXsv7FtO2g/NV2kviu6EA1235+OG7QnclcSMO97tjxha/5sv1I0HmVbA5fEoJFRXCbSvU998WoWC6MDWjDLnYgVIxIdk9c7s1SJ2ZqP1EcGlr36pk0DdsiAIO/YwtTdY4Mjg3s5wcaB/XqWTwVNmk6CU5ne2Lg8lY0M/ZXjXjrk28XttozZQaVetQOYj2ofcJGmBYug9ziF3Wgz5j7qdJ9m9CuX1TiaNjEW749yYHZVTie0wgFrBILFk1kMyqI7OkCgiZET5f2R0FsyS28cL4BrvMi9QtJPzVPUg+PSr6Yj0VSs3MnbBxMKxpjrB9jOU1oBGsGpvpEF+/yMECiaF7aDvOO3UtsDRg+Vz/uafFicfar44DnC3QYBxuVD9Pdje0n5ZHlD1OSkjuoZXjjqSAyAEn661xDidSlHNmwz8UsVifXTCTeC2kyRk0Y2uAZ9DN1AzzPHc4oVpBYdZ3azRgK1Fupuq9aH28gncr+GDy4Qkwn2NZnR1VeyhZE83fI+P/uzaEdEL3mAMhOB2Ex7Lx6CDVjRgp/Kq+VgOPKGRqolBvHB/vpYFKf9NOGVHO9CjzwUAjwUKO3PAxY+rVf08AlWnzE94XijWCpB/TsHhyLBWa3FUtUk+NNfGK10/PjwYes1FxQgHwkflstaURcf0EugUSzON5/BWWfz47rvkHan3yJaiLEv42memv/OPaUkMx6KLa7Y+FizOfpuyAHrm+Hl7TAXm6J6hZ2bOGTWZBp7kaviYA4LzeYuo4wf6MHD6WxTluIg5/B0ZzQ7U/L1fdygXDgPxhuf74HmXQJU0k4SSyobIFxGxpAqmHecuWbbocR1g
 BN321H4c
 hWiJIg6hgzwu+QlLiHWhXRdP/+QaXH5Z6avhLD9D6vGG9MZEgfq6LcxZRoTiID3c/Gj6IcMwcU1CfsxpGiScgv6bw+fiBScjLtMn5xcyeQ7Vr3OzXdst0pBEWeFUlLCuv4noyrApW7xfjPIYgfAdbSKlRNlmIAO4+exTl06fl1qcYCyYG/KqbfzwxitbGlPPrMYhj4av67PTszJ8TBbHJxNLdCyogAof+edO2MaXsiUDEwLI62He5IEtKnQTaOJgcOt2BiKpIypAZ7iTGo0qYUgTGWy9DFadEy5lwn8K9nMRWwBT1TI5zokOUA2DIK1C+/prqCEnv+aD+CwdXfJ7vabkZfU/LHlUHLZ2Q5ixkRY8ixwm/8cS4XsybYNPSzSPUNzEOiPQSnOP01WBWDd4xwu2Z0Ak+sFTMkj5YTt/qd0f6oKyynjizYqYt2GDMdeRhOQ5fxtq3KPG2ARYFU208A3zQz2vTD272wzbbMtAqGcLPteZ5e9Ei7zKrKWDZYyyI757//gE40uYHUqI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B41=E6=9C=8828=E6=97=A5(=E6=B0=B4) 5:24 Gregory Price <gourry@go=
urry.net>:
>
> On Sat, Jan 10, 2026 at 10:55:02PM +0900, Akinobu Mita wrote:
> > 2026=E5=B9=B41=E6=9C=8810=E6=97=A5(=E5=9C=9F) 1:08 Gregory Price <gourr=
y@gourry.net>:
> > >
> > > > +     for_each_node_mask(nid, allowed_mask) {
> > > > +             int z;
> > > > +             struct zone *zone;
> > > > +             struct pglist_data *pgdat =3D NODE_DATA(nid);
> > > > +
> > > > +             for_each_managed_zone_pgdat(zone, pgdat, z, MAX_NR_ZO=
NES - 1) {
> > > > +                     if (zone_watermark_ok(zone, 0, min_wmark_page=
s(zone),
> > > > +                                             ZONE_MOVABLE, 0))
> > >
> > > Why does this only check zone movable?
> >
> > Here, zone_watermark_ok() checks the free memory for all zones from 0 t=
o
> > MAX_NR_ZONES - 1.
> > There is no strong reason to pass ZONE_MOVABLE as the highest_zoneidx
> > argument every time zone_watermark_ok() is called; I can change it if a=
n
> > appropriate value is found.
> > In v1, highest_zoneidx was "sc ? sc->reclaim_idx : MAX_NR_ZONES - 1"
> >
> > > Also, would this also limit pressure-signal to invoke reclaim when
> > > there is still swap space available?  Should demotion not be a pressu=
re
> > > source for triggering harder reclaim?
> >
> > Since can_reclaim_anon_pages() checks whether there is free space on th=
e swap
> > device before checking with can_demote(), I think the negative impact o=
f this
> > change will be small. However, since I have not been able to confirm th=
e
> > behavior when a swap device is available, I would like to correctly und=
erstand
> > the impact.
>
> Something else is going on here
>
> See demote_folio_list and alloc_demote_folio
>
> static unsigned int demote_folio_list(struct list_head *demote_folios,
>                                       struct pglist_data *pgdat,
>                                       struct mem_cgroup *memcg)
> {
>         struct migration_target_control mtc =3D {
>                  */
>                 .gfp_mask =3D (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
>                         __GFP_NOMEMALLOC | GFP_NOWAIT,
>         };
> }
>
> static struct folio *alloc_demote_folio(struct folio *src,
>                 unsigned long private)
> {
>         /* Only attempt to demote to the preferred node */
>         mtc->nmask =3D NULL;
>         mtc->gfp_mask |=3D __GFP_THISNODE;
>         dst =3D alloc_migration_target(src, (unsigned long)mtc);
>         if (dst)
>                 return dst;
>
>         /* Now attempt to demote to any node in the lower tier */
>         mtc->gfp_mask &=3D ~__GFP_THISNODE;
>         mtc->nmask =3D allowed_mask;
>         return alloc_migration_target(src, (unsigned long)mtc);
> }
>
>
> /*
> * %__GFP_RECLAIM is shorthand to allow/forbid both direct and kswapd recl=
aim.
> */
>
>
> You basically shouldn't be hitting any reclaim behavior at all, and if
> the target nodes are actually under various watermarks, you should be
> getting allocation failures and quick-outs from the demotion logic.
>
> i.e. you should be seeing OOM happen
>
> When I dug in far enough I found this:
>
> static struct folio *alloc_demote_folio(struct folio *src,
>                 unsigned long private)
> {
> ...
>         dst =3D alloc_migration_target(src, (unsigned long)mtc);
> }
>
> struct folio *alloc_migration_target(struct folio *src, unsigned long pri=
vate)
> {
>
> ...
>         if (folio_test_hugetlb(src)) {
>                 struct hstate *h =3D folio_hstate(src);
>
>                 gfp_mask =3D htlb_modify_alloc_mask(h, gfp_mask);
>                 return alloc_hugetlb_folio_nodemask(h, nid, ...)
>         }
> }
>
> static inline gfp_t htlb_modify_alloc_mask(struct hstate *h, gfp_t gfp_ma=
sk)
> {
>         gfp_t modified_mask =3D htlb_alloc_mask(h);
>
>         /* Some callers might want to enforce node */
>         modified_mask |=3D (gfp_mask & __GFP_THISNODE);
>
>         modified_mask |=3D (gfp_mask & __GFP_NOWARN);
>
>         return modified_mask;
> }
>
> /* Movability of hugepages depends on migration support. */
> static inline gfp_t htlb_alloc_mask(struct hstate *h)
> {
>         gfp_t gfp =3D __GFP_COMP | __GFP_NOWARN;
>
>         gfp |=3D hugepage_movable_supported(h) ? GFP_HIGHUSER_MOVABLE : G=
FP_HIGHUSER;
>
>         return gfp;
> }
>
> #define GFP_USER        (__GFP_RECLAIM | __GFP_IO | __GFP_FS | __GFP_HARD=
WALL)
> #define GFP_HIGHUSER    (GFP_USER | __GFP_HIGHMEM)
> #define GFP_HIGHUSER_MOVABLE    (GFP_HIGHUSER | __GFP_MOVABLE | __GFP_SKI=
P_KASAN)
>
>
> If we try to move a hugepage, we start including __GFP_RECLAIM again -
> regardless of whether HIGHUSER_MOVABLE or HIGHUSER is used.
>
>
> Any chance you are using hugetlb on this system?  This looks like a
> clear bug, but it may not be what you're experiencing.

In my case where the issue was reproduced, alloc_demote_folio() failed almo=
st
every time, but the folio passed to alloc_migration_target() was always fal=
se
for both folio_test_hugetlb() and folio_test_large().

