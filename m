Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2700F606A330
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 06:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=DdZvNqtE
Received: by kanga.kvack.org (Postfix)
	id 5062B6B05B5; Mon, 26 Oct 2026 02:10:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B7AA6B05B6; Mon, 26 Oct 2026 02:10:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CEAE6B05B7; Mon, 26 Oct 2026 02:10:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 132DF6B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:10:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 99DF114065C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:10:32 +0000 (UTC)
X-FDA: 85363753104.22.ACAB996
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5028820006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:10:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DdZvNqtE;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792995030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6zdNpT49yF2zRejshj3qPDRTy4Hn3G0HLLG7FYdjro=;
	b=cKu9tN9LvbxCqta4+DFCYuGAPFWFMeZFBQz8d6Ei2DR7ULnz0JhiIFXdYd18QadMxWUHS1
	T/741eUt+O+WUriBlzBHOR1EDT4YfQVqWguhp9SG7ilxSyqXoGZMmV8rZ7GVK57Fxy85pn
	0E94g0F9ZLrLL0H8d1B3sFdVu3fSMSg=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DdZvNqtE;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792995030;
	b=COToxVfLU1mBpG3ka+7gSqb8XdIVxhiDyfWq8cZ9QVDwY7DejvSWdPAFesV74sP/tor+gf
	DYeUvWl3Sk27gYCHHigNx2ouFPyB4MwKzuvL2JA+vc6K0EV3B9+79IaRmQFDpvKtQ8bm1T
	O4Abw7gl/s2tJ7uC+XQtShW5QX2xuk8=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a60f9474c4so5515455e9.0
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 23:10:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792995029; cv=none;
        d=google.com; s=arc-20260327;
        b=rm1UuK4WhfXJHmSx/w2mCdAuHw2bh3dgSksZswtyKLiLpBgUU9lslxkjcQdDgCgvd6
         h/2ys5NLBsmcrK6Ilnaa3mcGfBStNVCgKmEXeC6fZBS9eW+hxPYeJCAEegoQGLx2K2yW
         XkNBwDcreK/9iPulHZPUxBAgR7rgtsbX2PjsXYrbU6tK34TgfOMhJUR620ar+PocnCME
         yuJiNhohnTAP1+TCrBvLXtO92mq+BLPcLBf3rhBskEl1ldLY0NohZEWT8CY7UoiUPxy8
         SQY+p7HV59cV4tz8vxK1x8wG2mhIJfPCYfSM3/ou6qYQEykfw+A/HyAuJ6GvncJVqYmh
         MSlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=w6zdNpT49yF2zRejshj3qPDRTy4Hn3G0HLLG7FYdjro=;
        fh=gA86aRF63doNP6OI1PsTKTo+LeCsnQ15fDrYjva43nU=;
        b=aup/hN8vZLaG2lTB9eu4YwBuifbAWJwCErtxFlYqX9p7TotukKlrNr3nh2DXRJ1RjW
         UEUTUAfoTSja7YewEWY5YPQcvTd/bwkPy5CrOsyXF/D2JMeT4XCmXNz2oIZ2/sUbN2VO
         jNRsglianOnykWv5dxGOexFDO4Oyk7v4DEXvd4VxDezJ1qGCPmpdNZ1tX3GusZZ1uZhE
         vBFIJwOZq+P1AiSIOEfjRR99FO3Enkw2qoc9tvndlkQVcn8W3QVKZnbfPESZPCaSE3iQ
         ADGhSE2+lM6ZVnw0Pv1VZJ9nDXSDTp/tLQnL9h27m+lzq9BU1Hfy+NEy8geMtcRW4MEH
         OBjA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792995029; x=1793599829; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w6zdNpT49yF2zRejshj3qPDRTy4Hn3G0HLLG7FYdjro=;
        b=DdZvNqtEgASIZCF368osfbM003pTpy0BdsHMwR/wZiYwFfMChQhMM5OQRl0Ur961IY
         4laMQMJk9woID3GXkuaB6+t0ggs/mM7aUpDOZByD/E/nvzhazlTzsVo+PxY9YCVAScxU
         7EYjx/Ie4opi938/PAOk4LkQTFt2S0mXShSgnXQOmSVj7KqNx9yifnfPBdpCyjxuNWez
         qHIXoWzt8qQekZRSLJQdBJEi9/Jn/Zk7rTu8juGULkaGqXwBuTcSsN8Mu/rF5W49hxyi
         z3tOaIwtXbdWIDlMVNSxMQ7E5NgjML2MQ2LfIKK6tsOHQq7xaenV3YICcOLOgKhC9P2X
         YhtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792995029; x=1793599829;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w6zdNpT49yF2zRejshj3qPDRTy4Hn3G0HLLG7FYdjro=;
        b=tVdC8Z23YR812JlVMXYQQPCKGQRiP0cnQpG7q8MLcSNcPPdnr0p4Bxyz3nD0Fvndn6
         Nzvc+sgd26Vymrev7FJ6yxhipDntnmlghDJbZC2TIV5XtL9KgyS5D+rmhsfbgw1hRXxz
         UeMWGUkImfc0RZqp4xHhucoZdkvglCMMae6aGF0pMfyKGw2sILCgv4PvGllieWbUun0M
         Jj5mpD/B1J/wW3oQQSR5jCAl3me2L9UQzp/zkCUHh5+p0YlI3q8r+L2cDAKhruL80CQg
         HBx3Hf11FOVNSsFOHigpRwWumOimYuZrEmp3WeD8ZNMyCAkBJEi9DmalIVa8Spu2mnyL
         vJgA==
X-Forwarded-Encrypted: i=1; AKwUvBxx1oo5nyBLYefru8eFl8jC+8yvm7N2H21qTLMcHK1O3w77wIShxsWDsP0crXsSo9gGGHAz1QyVKw==@kvack.org
X-Gm-Message-State: AFq9FYIZvjDi9eplPeVyjIwN7sGqmTn4wT0UPsjRtu80c0pUNKn7IcJD
	LSdv1847klvG/PbJHsTfwUSSGPvmYI54P3qeW0+fMyYe4GKQX+olB9bOeJAFrg3aWJaR32JrRQ6
	AwXgChNdTlHpevGj0rPwEuX3utLEVMkI=
X-Gm-Gg: AYBFou1ehqAQzKIiA59F00za2dG4cKqmtPgMHXdy4TNOEm4a67AEe9SupRzfyVIPjVL
	Mfb6WQSqvoX6UCN0TdXzzIZWG+ntgSnUi/3iyqDjeSdM4XY+LWGfHZzy6xsNgB9zL136JgnZ/nx
	bOOZh8ahUdEenyu+bS5nO2EjmZKelpvuBxqqwyDdiYYWX+QQOJO1BoaEtlnfBMrDRbWix6mCbyC
	c3MotLiSvEpvg8bezTSqxOZuXdQwHW9CL5J20TiIco0Fne4QeQRAHOCzYBFz0h0nVdSPsmJzVl8
	n9asZFcvhaJIuQerE4TeezgQHt+6rvIvG968IsrXZl7PCC8vnNVr3H//DevfS606WWcO7ILKXyX
	BeOp4rN1Di83rcL5I5o6Tns2JbG/tUZLVf2eT9dLDYxU2jK/KucVti6FQuuia6P7XOAQPFS/fed
	YlP8Y3Q2bzPmP6pcbS
X-Received: by 2002:a05:600c:3d8d:b0:4a2:150f:1601 with SMTP id
 5b1f17b1804b1-4a35ac94951mr105384385e9.12.1792995028808; Sun, 25 Oct 2026
 23:10:28 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261003003136.750633-1-hebaoquan@kylinos.cn> <20261003003136.750633-9-hebaoquan@kylinos.cn>
 <CAN_Opa_JCCd-+o5y9JXbzypPtYjTGvyvnOy7KmSUKHYtVab85w@mail.gmail.com> <asyK6t1POEW5c533@fedora>
In-Reply-To: <asyK6t1POEW5c533@fedora>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Mon, 26 Oct 2026 14:10:11 +0800
X-Gm-Features: AclHuK_dhqZYPgJVHUk3C61SxiAZTVv1AhZrMH5pk39-ACZEDnWgeleXWCWtyZ4
Message-ID: <CAN_Opa-RLVCxDm4bEMjobTGB-XSRx3d5ZqJ5=1uSBv+OTbEiig@mail.gmail.com>
Subject: Re: [PATCH v4 08/14] mm, swap: defer xswap shrink to workqueue to
 avoid lock recursion
To: Baoquan He <baoquan.he@linux.dev>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	chrisl@kernel.org, kasong@tencent.com, hannes@cmpxchg.org, nphamcs@gmail.com, 
	baohua@kernel.org, youngjun.park@lge.com, yosry@kernel.org, 
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, klarasmodin@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5028820006
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 9a39pccx4i8yms7yuapgxxb8rdkx3fxn
X-HE-Tag: 1792995031-243205
X-HE-Meta: U2FsdGVkX19oSkFBFEvGsYo2G74VeA9ysXPDW2JzuZMNbkdTw47MFqxgRBHGBhz84gaCvED7ms+VUvVe/njNQiyC/fjxbbvUUf4P5JrGZcWnqaks9rnyOHLXMmGZd/TKWafejreLvpuVWhodpZ5sckofY+jGWHwa0YWhYzZyVXgZsht+G8AMd9LL5SVIpD9lfADgbmkuINtzeGJW7zCVtz8N03k3/s0JlWi1xl/RvzAQFV/rcRz4bRy8CNQUySb44ZvDGwZUoBhJcHvgIkqVHR30Kd5GxGDM5EM8GP1UsFoouT5veMY6cYwMYpuA5DIpFsVJdzUR1X3PFheSs31po8qvl0iheFLZYqW09qe/0PWOiAB3K5WAdmZWOitbg6PwxXPK4qsUESoJdHIcn8TU8qqpqHmgec3vCLKjNaIGmk6Bkqo9d1DXw4Wk4XprO3qmd4Q3TyUOV1q9RQNOtaAkv3CDcEPO22UeCQ8njaK/cDkDQVCCNPBD7goimtNt890vqOyShiGC335UcbwuGFy0TAhBI5NoRrQHliGKadVMCK2WiTg042xzoTxpbMBDnaxMsjLDM9p1/BbX5fYrlYvbgooEJt+F8srKZ9jz3UCJ6inLQLpXnWJSX3u82bOI/0/IPE/up7tUE1rvfnzS2o5Hx9GOi6GxARz9KwUhJeIND0fshX9IgD/KP/siAMDa6v+32PZBkizt6isag9KMn8x43c70trxmJPolLCZiEgbcPB22JbRUYDzuWOnquvlK7LO3bkJpqBiOvVVm1QvJ2j8GiQIagIe+chXR8OFobU/4vFgU1GKV3Q6jknm/PsfkGGPlLnqyAcj5YxhYbx78RPaIcm//vrDTA9oAvKDOMnuNW7NaQVqKiCcdMwNZ2P1dhu5M19RCYwWHcIf4g/rEAHY3iEhrcKcmH8YuKMWDM5dQgk5uGQtoEmdFNRFcl8Je6L7a/jTu+80yqIXbW2XyCCH
 KP9xUS2w
 vE8C/MarzS28bz10jOGUtcB5udpyJmmwcNgTRPElXTBMB6NkWm/wpqJ5JtFXL2w2j12XDIey0ACM4vmlwfrUCmx/hVpbhm4nsoBrEDp2zh+vN09dKn65IyC3B0hM63yU/g6Jmq1jZxgz4C5LF/Wxuee3oQwmO4QJ7Z5Y1l6HMXzXZj/D1zg4Bm2d5M3yrdkM1ox1UCMXRzz+O7HG1TRn0EDprZDSiNd+UQwUMvXoSr5F0ywyElV968uW3+i+rYK3PoLM4Vqv+xtFrp+hNqb+ts0sNujr1kLxlc4v/MqtR6gP/Ye/lhB0L+qZUCJls8h0kkB03npTzWC4neDESJtCqf+EX4WDLqJPpVayBAPUVdx33laqoWfhYzhSNuZf32zHhljoq7oA8GJSGT0fSjMTi8hxhFDmLI0MOg0jHLODbv4iZIS4ZZNRAdVzwIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 12, 2026 at 3:23=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> On 10/08/26 at 05:10pm, KunWu Chan wrote:
> > On Sat, Oct 3, 2026 at 8:32=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn=
> wrote:
> ...snip...
> > >  /*
> > >   * Try to shrink the cluster_info tail: unmap contiguous free cluste=
rs
> > >   * at the end of the mapped range.
> > > @@ -4164,14 +4187,20 @@ static int xswap_mapped_end(pte_t *pte, unsig=
ned long addr, void *data)
> > >  static void xswap_try_shrink(struct swap_info_struct *si)
> > >  {
> > >         struct swap_cluster_info *ci;
> > > -       unsigned long nr_mapped, last, keep, idx;
> > > +       unsigned long nr_mapped, nr_tail, keep, nr_unmap, start_idx, =
i;
> > >
> > >         if (!(si->flags & SWP_XSWAP))
> > >                 return;
> > >
> > > +       mutex_lock(&si->xswap_lock);
> > > +
> > > +       /* A swapoff raced us and is about to walk this mapping. */
> > > +       if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
> > > +               goto out_unlock;
> > > +
> > >         nr_mapped =3D READ_ONCE(si->nr_clusters_mapped);
> > > -       if (nr_mapped <=3D 1) /* keep cluster 0 */
> > > -               return;
> > > +       if (nr_mapped <=3D 1)     /* keep cluster 0 */
> > > +               goto out_unlock;
> > >
> > >         /*
> > >          * Reclaim on our own, but only once the mapped range is at m=
ost
> > > @@ -4181,40 +4210,73 @@ static void xswap_try_shrink(struct swap_info=
_struct *si)
> > >          */
> > >         if (swap_usage_in_pages(si) * 100 >
> > >             nr_mapped * SWAPFILE_CLUSTER * XSWAP_SHRINK_WHEN)
> > > -               return;
> > > +               goto out_unlock;
> > >
> > > -       /* Find the last non-free cluster from the tail */
> > > -       last =3D nr_mapped;
> > > -       while (last > 1) {
> > > -               idx =3D last - 1;
> > > -               ci =3D &si->cluster_info[idx];
> > > -               if (ci->count || ci->flags !=3D CLUSTER_FLAG_FREE)
> > > +       /*
> > > +        * Count the free clusters at the tail of the mapped range.  =
Scanned,
> > > +        * not tracked: the count must be exact to size the unmap, an=
d an
> > > +        * incremental count falls behind on out-of-order frees.
> > > +        */
> > > +       nr_tail =3D 0;
> > > +       while (nr_mapped - nr_tail > 1) {
> > > +               ci =3D &si->cluster_info[nr_mapped - nr_tail - 1];
> > > +               if (READ_ONCE(ci->count) ||
> > > +                   READ_ONCE(ci->flags) !=3D CLUSTER_FLAG_FREE)
> > >                         break;
> > > -               last =3D idx;
> > > +               nr_tail++;
> > >         }
> > > -
> > > -       if (last =3D=3D nr_mapped)
> > > -               return; /* nothing to shrink */
> > > -
> > > -       /* Below `last` has to stay mapped: the free ones in between =
are
> > > -        * not part of the tail, and unmapping them orphans what is a=
bove.
> > > -        */
> > > -       if (nr_mapped - last < XSWAP_SHRINK_SLACK + XSWAP_SHRINK_MIN)
> > > -               return;
> > > +       if (nr_tail < XSWAP_SHRINK_SLACK + XSWAP_SHRINK_MIN)
> > > +               goto out_unlock;
> > >
> > >         /*
> > >          * Stop at SHRINK_UNTIL rather than at the end of the tail, o=
r the
> > > -        * range comes out full enough for the grow to be woken.
> > > +        * range comes out full enough for the grow to be woken.  Bel=
ow the
> > > +        * tail everything stays mapped, and one chunk of tail with i=
t.
> > >          */
> > >         keep =3D DIV_ROUND_UP(swap_usage_in_pages(si) * 100,
> > >                             XSWAP_SHRINK_UNTIL * SWAPFILE_CLUSTER);
> > > -       if (keep < last + XSWAP_SHRINK_SLACK)
> > > -               keep =3D last + XSWAP_SHRINK_SLACK;
> > > +       if (keep < nr_mapped - nr_tail + XSWAP_SHRINK_SLACK)
> > > +               keep =3D nr_mapped - nr_tail + XSWAP_SHRINK_SLACK;
> > >
> > >         if (nr_mapped < keep + XSWAP_SHRINK_MIN)
> > > -               return;
> > > +               goto out_unlock;
> > > +
> > > +       nr_unmap =3D rounddown(nr_mapped - keep, XSWAP_GROW_CLUSTERS)=
;
> > > +       if (!nr_unmap)
> > > +               goto out_unlock;
> > > +       start_idx =3D nr_mapped - nr_unmap;
> > > +
> > > +       /*
> > > +        * Only shrink a run that reaches the mapped end; otherwise
> > > +        * truncating nr_clusters_mapped would orphan the active tail=
.
> > > +        */
> > > +       spin_lock(&si->lock);
> > > +       for (i =3D start_idx; i < nr_mapped; i++) {
> > > +               ci =3D &si->cluster_info[i];
> > > +               if (READ_ONCE(ci->flags) !=3D CLUSTER_FLAG_FREE)
> > > +                       break;
> > > +               if (!spin_trylock(&ci->lock)) {
> > > +                       spin_unlock(&si->lock);
> > > +                       goto out_unlock;
> > > +               }
> > > +               spin_unlock(&ci->lock);
> > > +       }
> > > +       if (i !=3D nr_mapped) {
> > > +               spin_unlock(&si->lock);
> > > +               goto out_unlock;
> > > +       }
> > > +
> > > +       for (i =3D start_idx; i < nr_mapped; i++) {
> > > +               ci =3D &si->cluster_info[i];
> > > +               list_del_init(&ci->list);
> > > +               WRITE_ONCE(ci->flags, CLUSTER_FLAG_NONE);
> > > +       }
> > > +       spin_unlock(&si->lock);
> > >
> > > -       xswap_unmap_clusters(si, keep, nr_mapped - keep);
> > > +       xswap_unmap_clusters_locked(si, start_idx, nr_unmap);
> > > +
> > > +out_unlock:
> > > +       mutex_unlock(&si->xswap_lock);
> > >  }
> > >  #endif /* CONFIG_XSWAP */
> > >
> > > @@ -4278,6 +4340,7 @@ static int setup_swap_clusters_info(struct swap=
_info_struct *si,
> > >                         }
> > >                 }
> > >
> > > +               INIT_WORK(&si->xswap_shrink_work, xswap_shrink_work_f=
n);
> > >                 return 0;
> > >
> > >  err_unmap:
> > > --
> > > 2.54.0
> > >
> >
> > Hi Baoquan,
> >
> > While following the shrink path across these patches, I wanted to
> > clarify the lifetime guarantee for the `cluster_info` backing pages.
> >
> > P07 flushes the per-CPU swap cluster cache and calls
> > `synchronize_rcu()` before unmapping the tail. P09 clears
> > `SWP_WRITEOK` and cancels the shrink work before proceeding with
> > `wait_for_allocation()` and `try_to_unuse()`.
> >
> > Could you clarify how the shrink path ensures that, before the tail
> > is unmapped, no allocation-side reader can still access the tail or
> > republish a stale per-CPU cache entry that points into it, and no
> > swapoff-side walker can still access the unmapped range?
>
> Hi Kunwu,
>
> Thanks a lot for your careful review, and for following the shrink path
> across patches. Assume P07 in your saying means patch 07, and P09 means
> patch 09. For the questions,
>
>
> 1. Allocation-side readers of the tail
>
> xswap_try_shrink() removes the clusters to unmap from their lists while
> holding si->lock, and only proceeds if spin_trylock(&ci->lock) succeeds f=
or
> each of them. After that no allocator can get these clusters from a list.
>
> The flag check alone is not enough. move_cluster() writes ci->flags after=
 it
> drops si->lock, so spin_trylock() is what actually blocks an allocator th=
at
> just took the cluster.
>
> Then, before the pages are unmapped, xswap_unmap_clusters_locked() does
> flush_percpu_swap_cluster() and synchronize_rcu(). That drains the four
> readers that use cluster_info[] under rcu_read_lock():
> alloc_swap_scan_cluster(), swap_reclaim_full_clusters(), swap_alloc_fast(=
),
> and swap_alloc_hibernation_slot().
>
> 2. Republishing a stale per-CPU cache entry
>
> The per-CPU cache is written in only one place: the end of
> alloc_swap_scan_cluster(), and the value is an offset inside the cluster =
that
> just got the allocation. That cluster cannot be one the shrink unmaps,
> because the shrink only unmaps CLUSTER_FLAG_FREE clusters and a cluster t=
hat
> just took an allocation is not free. So a racing cache write can only poi=
nt
> to a cluster that stays mapped. The flush plus synchronize_rcu() handles =
the
> entries written before it.
>
> 3. Swapoff-side walkers
>
> The swapoff walkers are not RCU readers. swapoff first stops the shrink:
> cancel_work_sync(&p->xswap_shrink_work), then waits on p->xswap_lock (whi=
ch
> grow and shrink also hold). SWP_WRITEOK is cleared, so xswap_try_shrink()=
 bails
> out too. Then wait_for_allocation() drains any in-flight allocation, and
> try_to_unuse() runs. Only after percpu_ref_kill(), synchronize_rcu(), and
> flush_work() of the discard and reclaim works, flush_percpu_swap_cluster(=
)
> run and the mapping get freed.
>
> Not sure if I answer your questions clearly.
>

Hi Baoquan,

Thanks for the detailed explanation. This clarifies my questions
about the cluster_info lifetime and the synchronization between
shrink and swapoff.

I=E2=80=99ll check these paths again against v5.

Thanks,
Kunwu

> Thanks,
> Baoquan

