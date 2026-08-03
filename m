Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A666C55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 06:31:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76D206B007B; Mon,  3 Aug 2026 02:31:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744946B0088; Mon,  3 Aug 2026 02:31:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 633A06B008A; Mon,  3 Aug 2026 02:31:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39CA36B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:31:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BEE1F1A060D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:31:50 +0000 (UTC)
X-FDA: 85058987580.10.6365D2A
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id CD7BF80008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:31:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LC3jllLZ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785738708;
	b=MzGe9dLtwmzLCKbRTDA3NVcRO2rJ9dSLCF00Mbcbn1RCZf7AT2MFOqr8GrIzKe7g8yDe8U
	Yxn6dhl84hYBv45nMiMdVVu2Ok/MtzIgeJjK4Fz/tsNY59MRJDrOYYbWB+BtlMq2Lm9oGJ
	CdfdzUWgOsHC7DX+FFNrQp5C95t0bLs=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LC3jllLZ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785738708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V0K+PxQpPBX6ec1pychHbewUSEpOSn4t29laEsQa9Jc=;
	b=6CRJnQGTbhazu8K0IEvdL7xB/TpEriW2HgObQVplEllSZqhCncY1v07bk1EPbOJkOzVgXw
	asiwc10yJfF2+t6aYEgTaz59W0i7+LLknbjMU8ZEOuAcBpgyqZD3qijKc77ywZ1n2FQX41
	1jGv2DICbmrzjnhb6YGPMbmKw1B7+Rc=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b2a8173142so6260e87.1
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 23:31:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785738707; cv=none;
        d=google.com; s=arc-20260327;
        b=CCA0K8PWNaTX5s9dqQDabQGi7M5+D0ccZtRUDA2tT/6z/RyKDetvdV7368YaMclTDp
         ByIanF0e9pB9NiIMgf7NFPbFeiLPSoUqNsQRRkXL6WtR/VLkYQhdJ1T0hq9lTPYZsDEs
         mRgwTz3+1hG1/cyitd/oLTRW5oZNIjsEC+v0WCjLJ8D1VP0XGZVN8/rrUBczvKKQ0rV8
         Vn5NvbQWZZUyNuTZbzw7htEK7UT0PFPDRph0qi2GYMUROyVyIxALkRtrT0FkGf5/b4NG
         t+TMHlOqGN6Rfz5PKtwVf2tidQUGZTCqLNOh6Q68MSaD98P4iq3oa7k+/sw4cmStBxaR
         JLuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V0K+PxQpPBX6ec1pychHbewUSEpOSn4t29laEsQa9Jc=;
        fh=ucDi7mTr3+dEb6hu6dziRcfkloNSL4GKWfAw7tt1UzE=;
        b=JTnMsQUou3IG1dWUPWXk3C1C6oVAJq3sC+u8GjAO381At8tSNUbGelNZC5SiI9SHZp
         nH1Kr3zri6xMl1aQ1wDD0IBwkepsoRHhtEEHjY4CwxdbNTCgE45h+PtrJnqOdMbz1E29
         0pZc76CyTW7jeDKmSye6ltU2OVPvjokxRu85fU3n7YukiV52+O4g4VSpClfyaGUZIdQJ
         wYWr5CkL7mB6/QBIydS45W+KqwC88rVnPo5OKF5eDfrrYZUmXpYB1l/pJbAgvyGBkGz4
         me/2swqXLttC+lyvb5eZSAkhq3HldyePjuW64Zznb5fUWhVWMcqV2e7RCb9SvdCQoCw5
         gMwA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785738707; x=1786343507; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=V0K+PxQpPBX6ec1pychHbewUSEpOSn4t29laEsQa9Jc=;
        b=LC3jllLZMB58NyB9VTXGmRI+x+SuHNr8yxPLJKmhYw0ZqmRKuAn3RAurrJLC8vDh1R
         VAvnpgFf/W1zq4ICknf39knUItnuaxzlZwMVYPX9G0redGr62XRFRztvUtj+9j+Eeku3
         EbqsR1C0XsJWDNM+FVlxZUX8NsOEyt8zn/R2OzhmFiDUYxitv31sRjnkssF49kmu/4aF
         iRHGUQo34spy2rqXxfXNf6qbjBKxp25pUS0Sh2B9MA5zxdV7lmfrlRiOjX2GX1paAuX/
         u4Df3vov9UWjqOxZJjcyukXAmBNfXsO5DWVuotDg8NbUnT1xIwN86n33Iv5C6jD99Ri5
         TLsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785738707; x=1786343507;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V0K+PxQpPBX6ec1pychHbewUSEpOSn4t29laEsQa9Jc=;
        b=IFQoT+u9crOGXRr9/tN8glVV9h15bSysgpRXA5bz9L36pjFKKGRVAcIV1Rv8RGha/B
         SFrBE21WIhOkH+1npfBXsLo3yr7PfBQmWkpj9i9oI+jyD+jE5u5+qYqb06kplz0fOafv
         4pWC5cGygWrWCb9j4y0JwRnP2CVqq3YgYwpb82lL6INb4hZddphAslYucY9NHlolSaEU
         nFlV9hl3PTlHMg6CzD/EkGdxvSKgLELae7varUInz3Ysh1YQo52cyNg9eO4IrwpAnt28
         tATU5qqYyDoJePpd44n1OrKeNhB+I+DN2JgS5r+aCaoGhwEX9xP3YaBotfoIm6l3FFjJ
         W4jg==
X-Forwarded-Encrypted: i=1; AHgh+RqLm/b1lFUbxL2S90ix9HSBwuu8L6DH/O72h8B+nJ6kVsDVwgDLEpu0fasnyDdAoXYHpvPtIB/1zg==@kvack.org
X-Gm-Message-State: AOJu0YzbzfA8ZGf/M2VrdY2BUc1pjuzb7K73i26zdsy0g6rFzWwv0Uoj
	kGhTAfmCfGDgIXmBbES6cz1p85SBks9jAa3LLseXjo5e0qxYFWcgL8z/prhwZZcW1E68gMGMr0j
	iX0pbVU6pkLwj/rQx2HJE0IRF7paP3K3WqHwh2XI8
X-Gm-Gg: AR+sD125hlWQX3/XO6oAW1R1LsLWBSUPR6Kto3Ma6sZ3KoN3FYtUt0Q/XI7I6MnvV3g
	acgtTcRMcO/65C/uYLDQc4b+VTLbQRpWnhCXS6KHFqYYSdsDzT3rrlb8tnLVjZmnDvg2FWcMPlq
	IaZJzhhPaNYV1d8bqOepesJfr332/2/IMszZb9o1qZo7poQizQuPHP7FmU+ONX+VeP/yifxTGWr
	9k2KG4gjyqIJIPEzzkRWjZmcoLx6a7o51+fkFl11zeLy8wnhzSHpG9za/AkO7Up9uyoQiUbkJrq
	K+eaCSwrkBIdJmGQNGzKGRpO/AehwJJO5/as3pfMlJi+No1Vco6B617s+62gqqYtx58U13xqTXY
	6tB7z2WNfsOz3eCrkVSKHPxhRcY/JosMLlA==
X-Received: by 2002:a05:6512:2343:b0:5a4:ec:53d9 with SMTP id
 2adb3069b0e04-5b2e5c61ea9mr182090e87.1.1785738706508; Sun, 02 Aug 2026
 23:31:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260729163148.3271755-1-souravpanda@google.com> <20260730124938.2619968-1-usama.arif@linux.dev>
In-Reply-To: <20260730124938.2619968-1-usama.arif@linux.dev>
From: Sourav Panda <souravpanda@google.com>
Date: Sun, 2 Aug 2026 23:31:35 -0700
X-Gm-Features: AUfX_mzp7fm-ZWi0v-kRZWD_GZSaT7h7sGLv-LmUfFaBnSLYcJBjLazk3hj5WXI
Message-ID: <CANruzcRZeyRc42W7zU=SPQGRYH-qXhOXxGsrMhkf04C7LXQ_Tw@mail.gmail.com>
Subject: Re: [PATCH v3] mm/hugetlb_cma: support percentage-based hugetlb_cma reservation
To: Usama Arif <usama.arif@linux.dev>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org, 
	david@kernel.org, surenb@google.com, fvdl@google.com, gthelen@google.com, 
	rientjes@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9aisi46yi1g4gdjqyx9upi3pcfwoy99s
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CD7BF80008
X-Rspam-User: 
X-HE-Tag: 1785738708-109802
X-HE-Meta: U2FsdGVkX18/FvlNAwuzRMNwke2KutuRlXmAL8yHX9IecHSEHWthnBeGavLB21TEEb8OJg1reuNnVomKQxC3t40W2Ao89OPkg09hsNBEm7+hJ8qwDQMfbRvBmFmvC2STVvT4PzbtSIoCRH1+JhlFjIRzNEdCehMcFpFescJ6wntslXwvkhJs5U2q4hkyoQQFctGUaS4GSPcq1IfJmXah7ts4GXHdkiWf935uIZG9O7Ux/6a/dW3MVe/DlzfUuZP0+8yjYhdOJhWil3jQYjHPJ8ChWg5CuZ48K3AYcAMlTyAodDq7ST05kUTxbLRe7sdVCj0TE3DJNQTWq8/ArE9iX59po568B3uUNhlgsouYPMkx7zWCs0YsUg2lxxhWTXATrMdO7EDvqGNJ5LoaKlz+sZ/RDykZL5dBCHC8aU8GdFYKRlDxCEhxFYNiIpXggpLvfr/HzxdX68mlSwB+qBh6WLp9ZLpHeczIB7zF3Hx3NmD2479HxVWd/grWu9ofRNCc7ftn0sfV3pY1tN5VIMgVr5lECenM6KFFlZFays2wKVzRE00ZrjtX9eGzjzLlaqBmMKgX8XrTvZqkXv5qJTdvQV4Kv82ipaDr+To6e8KEKNjQNJKzhdKNGwU0a7E9RCx+tcAfxLXfLOgMKjmTUDyp54Azrit4FPNUrXuoyJ03wUILeKlt2O0ZJkNhiHVI5Akwpg2yVqjKxU9Couu/DBhpChMT+/6NHE9XBzG1pOZ5IIBE6DaQryL8W8IA9AfmIOBWrzTvZhppOXhZG/GV5SLeWZyFzt6HAdfQCjZGb/uBHDqNSRtFPzsdWC+GjZvWYBBOgR3BTlFgmEc384lATK55AhFZm9fHhIwi+YvDlGfuviSJq7vzuAkOyw1clP4G1gSszbOXwm5Coox6XyLWoWFm80SGFGx3jMq8gSUeGmJf1f2heL7JLP4hB4JrORLdTyOVH+kktzP5qS9ggXynZaN
 9RNBexYD
 Gk3ODdv4/oJ4VeKSOCsUvZbbO1Ovt9tHqSWzHLbuFkOM9lhBtrFQ4rcoK8vS+cY2W3SDyFCJ3N78DSlR4RpUO9lEMIKxiqY7lGhSVljca6bcmmGTrbCpKjHMZ0K+jrDgSvwVqBHWRfhmY0u5O0gEpV9grdfa2E0dcw11gIoH4Vg2fygIR8kbthV8Ovz3Q5lrJw4c1LqrBDmfZBb1HDFcnWTW94VgByCwaVyZizFyC4Vqr890wyz+hlgSJsc0NvL7jNQCBRcQGLqouLgkJJlVr+Fozvw502qZdG0s6Mor1kW5n09H0SZ5tIuFf0+pxqjTzeCaiE8j0WjrSMNM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 5:49=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> On Wed, 29 Jul 2026 16:31:48 +0000 Sourav Panda <souravpanda@google.com> =
wrote:
>
> > Currently, hugetlb_cma reservation only supports absolute sizes (e.g.,
> > hugetlb_cma=3D2G or hugetlb_cma=3D0:1G,1:1G). This can be restrictive i=
n
> > heterogeneous environments or when deploying common kernel command line=
s
> > across machines with different memory capacities.
> >
> > Add support for percentage-based hugetlb_cma reservation (e.g.,
> > hugetlb_cma=3D20% or hugetlb_cma=3D0:20%,1:10%).
> >
> > The percentage is calculated against the total memory (for global
> > settings) or against the node-specific memory (for node-specific
> > settings) using memblock APIs during early boot.
> >
> > Signed-off-by: Sourav Panda <souravpanda@google.com>
> > ---
> > Link: https://lore.kernel.org/linux-mm/20260628190155.3655895-1-souravp=
anda@google.com/ [v2]
> > Link: https://lore.kernel.org/linux-mm/20260625215900.2151690-1-souravp=
anda@google.com/ [v1]
> >
> > v3:
> > - Enhance pr_info logs to explicitly show percentage-derived sizes per =
Andrew Morton's suggestions.
> > - Explicitly align percentage-derived sizes down to the gigantic page s=
ize to prevent allocation failures (Usama Arif).
> >
> >   .../admin-guide/kernel-parameters.txt         |   7 +-
> >  mm/hugetlb_cma.c                              | 126 ++++++++++++++++--
> >  2 files changed, 123 insertions(+), 10 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Document=
ation/admin-guide/kernel-parameters.txt
> > index 5a05b48d1684..846940ce2858 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -2064,8 +2064,11 @@ Kernel parameters
> >       hugetlb_cma=3D    [HW,CMA,EARLY] The size of a CMA area used for =
allocation
> >                       of gigantic hugepages. Or using node format, the =
size
> >                       of a CMA area per node can be specified.
> > -                     Format: nn[KMGTPE] or (node format)
> > -                             <node>:nn[KMGTPE][,<node>:nn[KMGTPE]]
> > +                     The size can be an absolute value (e.g., 2G) or a
> > +                     percentage of the total memory or node memory (e.=
g., 20%).
> > +                     Format: nn[KMGTPE] or nn% or (node format)
> > +                             <node>:nn[KMGTPE][,<node>:nn[KMGTPE]] or
> > +                             <node>:nn%[,<node>:nn%]
> >
> >                       Reserve a CMA area of given size and allocate gig=
antic
> >                       hugepages using the CMA allocator. If enabled, th=
e
> > diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> > index 7693ccefd0c6..99d05eb82abc 100644
> > --- a/mm/hugetlb_cma.c
> > +++ b/mm/hugetlb_cma.c
> > @@ -9,6 +9,9 @@
> >  #include <asm/setup.h>
> >
> >  #include <linux/hugetlb.h>
> > +#include <linux/memblock.h>
> > +#include <linux/math.h>
> > +#include <linux/math64.h>
> >  #include "internal.h"
> >  #include "hugetlb_cma.h"
> >
> > @@ -18,6 +21,28 @@ static unsigned long hugetlb_cma_size_in_node[MAX_NU=
MNODES] __initdata;
> >  static bool hugetlb_cma_only __ro_after_init;
> >  static unsigned long hugetlb_cma_size __ro_after_init;
> >
> > +static unsigned int hugetlb_cma_percent __initdata;
> > +static unsigned int hugetlb_cma_percent_in_node[MAX_NUMNODES] __initda=
ta;
> > +
> > +#ifdef CONFIG_NUMA
> > +static phys_addr_t __init memblock_node_memory_size(int nid)
> > +{
> > +     struct memblock_region *reg;
> > +     phys_addr_t size =3D 0;
> > +
> > +     for_each_mem_region(reg) {
> > +             if (reg->nid =3D=3D nid)
> > +                     size +=3D reg->size;
> > +     }
> > +     return size;
> > +}
> > +#else
> > +static phys_addr_t __init memblock_node_memory_size(int nid)
> > +{
> > +     return memblock_phys_mem_size();
> > +}
> > +#endif
> > +
> >  void hugetlb_cma_free_frozen_folio(struct folio *folio)
> >  {
> >       WARN_ON_ONCE(!cma_release_frozen(hugetlb_cma[folio_nid(folio)],
> > @@ -100,14 +125,28 @@ static int __init cmdline_parse_hugetlb_cma(char =
*p)
> >                       break;
> >
> >               if (s[count] =3D=3D ':') {
> > +                     char *next;
> > +
> >                       if (tmp >=3D MAX_NUMNODES)
> >                               break;
> >                       nid =3D array_index_nospec(tmp, MAX_NUMNODES);
> >
> >                       s +=3D count + 1;
> > -                     tmp =3D memparse(s, &s);
> > -                     hugetlb_cma_size_in_node[nid] =3D tmp;
> > -                     hugetlb_cma_size +=3D tmp;
> > +                     tmp =3D memparse(s, &next);
> > +                     if (*next =3D=3D '%') {
> > +                             if (tmp > 100) {
> > +                                     pr_warn("hugetlb_cma: invalid per=
centage %lu for node %d\n",
> > +                                             tmp, nid);
> > +                                     break;
> > +                             }
> > +                             hugetlb_cma_percent_in_node[nid] =3D tmp;
> > +                             hugetlb_cma_size_in_node[nid] =3D 0;
> > +                             s =3D next + 1;
> > +                     } else {
> > +                             hugetlb_cma_size_in_node[nid] =3D tmp;
> > +                             hugetlb_cma_percent_in_node[nid] =3D 0;
> > +                             s =3D next;
> > +                     }
> >
> >                       /*
> >                        * Skip the separator if have one, otherwise
> > @@ -118,7 +157,28 @@ static int __init cmdline_parse_hugetlb_cma(char *=
p)
> >                       else
> >                               break;
> >               } else {
> > -                     hugetlb_cma_size =3D memparse(p, &p);
> > +                     char *next;
> > +
> > +                     tmp =3D memparse(p, &next);
> > +                     if (*next =3D=3D '%') {
> > +                             if (tmp > 100) {
> > +                                     pr_warn("hugetlb_cma: invalid per=
centage %lu\n", tmp);
> > +                             } else {
> > +                                     hugetlb_cma_percent =3D tmp;
> > +                                     hugetlb_cma_size =3D 0;
> > +                                     for (nid =3D 0; nid < MAX_NUMNODE=
S; nid++) {
> > +                                             hugetlb_cma_size_in_node[=
nid] =3D 0;
> > +                                             hugetlb_cma_percent_in_no=
de[nid] =3D 0;
> > +                                     }
> > +                             }
> > +                     } else {
> > +                             hugetlb_cma_size =3D tmp;
> > +                             hugetlb_cma_percent =3D 0;
> > +                             for (nid =3D 0; nid < MAX_NUMNODES; nid++=
) {
> > +                                     hugetlb_cma_size_in_node[nid] =3D=
 0;
> > +                                     hugetlb_cma_percent_in_node[nid] =
=3D 0;
> > +                             }
> > +                     }
> >                       break;
> >               }
> >       }
> > @@ -144,8 +204,36 @@ void __init hugetlb_cma_reserve(void)
> >  {
> >       unsigned long size, reserved, per_node, order;
> >       bool node_specific_cma_alloc =3D false;
> > +     bool has_node_specific_param =3D false;
> >       int nid;
> >
> > +     for (nid =3D 0; nid < MAX_NUMNODES; nid++) {
> > +             if (hugetlb_cma_size_in_node[nid] || hugetlb_cma_percent_=
in_node[nid]) {
> > +                     has_node_specific_param =3D true;
> > +                     break;
> > +             }
> > +     }
> > +
> > +     if (has_node_specific_param) {
> > +             hugetlb_cma_size =3D 0;
> > +             for (nid =3D 0; nid < MAX_NUMNODES; nid++) {
> > +                     if (hugetlb_cma_percent_in_node[nid]) {
> > +                             phys_addr_t node_gfp_mem =3D memblock_nod=
e_memory_size(nid);
> > +                             u64 s;
> > +
> > +                             s =3D mul_u64_u32_div((u64)node_gfp_mem,
> > +                                                 hugetlb_cma_percent_i=
n_node[nid],
> > +                                                 100);
> > +
> > +                             hugetlb_cma_size_in_node[nid] =3D s;
> > +                     }
> > +                     hugetlb_cma_size +=3D hugetlb_cma_size_in_node[ni=
d];
> > +             }
> > +     } else if (hugetlb_cma_percent) {
> > +             hugetlb_cma_size =3D mul_u64_u32_div((u64)memblock_phys_m=
em_size(),
> > +                                                hugetlb_cma_percent, 1=
00);
> > +     }
> > +
> >       if (!hugetlb_cma_size)
> >               return;
> >
> > @@ -163,6 +251,20 @@ void __init hugetlb_cma_reserve(void)
> >        */
> >       VM_WARN_ON(order <=3D MAX_PAGE_ORDER);
> >
> > +     if (hugetlb_cma_percent) {
> > +             hugetlb_cma_size =3D ALIGN_DOWN(hugetlb_cma_size, PAGE_SI=
ZE << order);
> > +     } else if (has_node_specific_param) {
>
> Hello,
>
> What will be done here if you have the following in kernel commandline?
>
> hugetlb_cma=3D20% hugetlb_cma=3D0:20%,1:20%
>
>
> It looks like the later node form doesn't clear hugetlb_cma_percent,
> so node specific sizes will be ignored, which I think is not the right
> behaviour.

Thanks for the review, Usama!

Agreed. This was because the node-specific parser in
cmdline_parse_hugetlb_cma() does not clear hugetlb_cma_percent.

Will fix this in v4 by clearing both hugetlb_cma_percent =3D 0 and
hugetlb_cma_size =3D 0 whenever node-specific parameters are parsed.

>
> > +             hugetlb_cma_size =3D 0;
> > +             for (nid =3D 0; nid < MAX_NUMNODES; nid++) {
> > +                     if (hugetlb_cma_percent_in_node[nid]) {
> > +                             hugetlb_cma_size_in_node[nid] =3D
> > +                                     ALIGN_DOWN(hugetlb_cma_size_in_no=
de[nid],
> > +                                                PAGE_SIZE << order);
>
> Maybe print a warning here if you round down to 0?
>
> For example, 5% of a 16G machine will round down to 0.

Sounds good! Will add a pr_warn() whenever ALIGN_DOWN() reduces
reservation size to 0 (for both global and node-specific reservations)
in v4

>
> > +                     }
> > +                     hugetlb_cma_size +=3D hugetlb_cma_size_in_node[ni=
d];
> > +             }
> > +     }
> > +
> >       hugetlb_bootmem_set_nodes();
> >
> >       for (nid =3D 0; nid < MAX_NUMNODES; nid++) {
> > @@ -205,8 +307,12 @@ void __init hugetlb_cma_reserve(void)
> >               per_node =3D DIV_ROUND_UP(hugetlb_cma_size,
> >                                       nodes_weight(hugetlb_bootmem_node=
s));
> >               per_node =3D round_up(per_node, PAGE_SIZE << order);
> > -             pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per =
node\n",
> > -                     hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
> > +             if (hugetlb_cma_percent)
> > +                     pr_info("hugetlb_cma: reserve %lu MiB (%u%%), up =
to %lu MiB per node\n",
> > +                             hugetlb_cma_size / SZ_1M, hugetlb_cma_per=
cent, per_node / SZ_1M);
> > +             else
> > +                     pr_info("hugetlb_cma: reserve %lu MiB, up to %lu =
MiB per node\n",
> > +                             hugetlb_cma_size / SZ_1M, per_node / SZ_1=
M);
> >       }
> >
> >       reserved =3D 0;
> > @@ -241,8 +347,12 @@ void __init hugetlb_cma_reserve(void)
> >               }
> >
> >               reserved +=3D size;
> > -             pr_info("hugetlb_cma: reserved %lu MiB on node %d\n",
> > -                     size / SZ_1M, nid);
> > +             if (hugetlb_cma_percent_in_node[nid])
> > +                     pr_info("hugetlb_cma: reserved %lu MiB (%u%%) on =
node %d\n",
> > +                             size / SZ_1M, hugetlb_cma_percent_in_node=
[nid], nid);
> > +             else
> > +                     pr_info("hugetlb_cma: reserved %lu MiB on node %d=
\n",
> > +                             size / SZ_1M, nid);
> >
> >               if (reserved >=3D hugetlb_cma_size)
> >                       break;
> > --
> > 2.55.0.rc0.799.gd6f94ed593-goog
> >
> >

