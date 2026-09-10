Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAD38C79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 15:23:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92FE06B009D; Thu, 10 Sep 2026 11:23:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BA8F6B009E; Thu, 10 Sep 2026 11:23:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75A8E6B009F; Thu, 10 Sep 2026 11:23:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 424D26B009D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:23:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25BA41C2496
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:23:04 +0000 (UTC)
X-FDA: 85198220688.07.9B27975
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf31.hostedemail.com (Postfix) with ESMTP id 393F820005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:23:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IFqLb8a3;
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789053782;
	b=snLn/bwDKczi07lS2AzdMgqAahTMEekmwzabGBNHI7jNE2TiS+sj/4qFojfxJnoZAhwIhx
	YymS57VDLDJwGy1QI6TyEJaMCz4UnqWsuGCklynmQmV1FhBVNjEQQBkeYM6jGEDR4Rj+Cc
	lWfG/fxtHtIexdUeyCFVi1k1AuWOxCw=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IFqLb8a3;
	spf=pass (imf31.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789053782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=foiDQ6diynQrcBaahnIV4yufuKYFC6bgEE9f3Z6k/+4=;
	b=X35KMvsfNPmIK5jVu7zfFn+1j3qnN+DYPkLbh1TyUe9Dn96MlgW5K//Lk8G8P41Mk5ldy0
	QP4nAj/pArIbY1Ojk22vFSKKhaSnRL4lktxy3qgu7f7ZfH7uU3rhNnUsdkfyBtAae6L3bd
	NyfiAh2NSLuyH7Bm/+InKcZ6S6RynI4=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530411c7ee1so301151cf.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:23:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789053781; cv=none;
        d=google.com; s=arc-20260327;
        b=IN3pG0w94cqXTCbRv9EiIriUieUMs4kFbsNOmHHn4u3pbGt+PwBXmVhMesmSe5gZMW
         7bRKiApjqVxo4xyLOaOb7Y4SuUgieziPxU9xoLztg8b541mwgl+RDNhKwwF7TgUy31CD
         JQ5bfrKk+Z47ZpLaw/xxzIvM8UkTMXCnIWJ6KSm1dFEBEwxBovGFxXED5CXbpQE5o/fg
         JYqUACLB9Zrm74XdIGoQPQW1CQYftXFeYUTFT+LRUEtofT7zItksnHbp8HJ7crVCWbh5
         hWH7A8KiDKElc/imsPGHJGOQmmw3aCUaaL51J7wzORjzJV6/424KC1lP9s1wVRBlQDw/
         0vVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=foiDQ6diynQrcBaahnIV4yufuKYFC6bgEE9f3Z6k/+4=;
        fh=e4gkurt/asniuKu4EgFvzVJt1j2tXP/X+Vh6OB26t7k=;
        b=DW7UhfwGOb/6IBQ0ycjaS3WZ9KJLzRnVw0NNveayuqaL27cXKzEEyTOBuvP0CRqRLk
         5C0gkXPkCML2GaPE23qf+BETTp485Tjm6FTrIHPKhshAliZXcxTVe3Ah78Cif53akmeh
         P/v3BiuXOUr4SzZXPDIBXUdy+W9AMOX3cnGskILGJjT6+lHRdq2RS3k+E6Q/DamVQb43
         FgRuEerPycyTZpbL1ek/xhR3HRChWpFLzCquCnqFcFCZvZo0lAjLZkIQDiHc4uR58Q+w
         6nZRnK7J2Z8MMyMCRJw5GQaPHkfc5Eiu1tTqokNEDvjqc29eHezZ+5OtzSKfp7Oe4YAe
         +kTg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789053781; x=1789658581; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=foiDQ6diynQrcBaahnIV4yufuKYFC6bgEE9f3Z6k/+4=;
        b=IFqLb8a35LU+aEFYdLTx61smXX3z/YsMlJlQ5FRKYrXHGUAiUTYesWBUEXbuHzjrbQ
         zS4Lnwld8PaYxWUtBti0f7i58sBJbzHgEXMU1DsYesk0WmCCSg8ZcCtYem7a63V+jS5k
         IIsYJOfpoORE1JHdUemDSp7kMkqKVIhD1POWDUuxo2kOik0KpBbVvWwwCqz5Fh7NKLg0
         7OkY8qQZgSp+qfbCNZM79IGF/VEsqnkaqPw36bXmLqJrB6FUwPiZRg55TGeMGg0CCobS
         ovRVZOYbRUmM+uzhJO+ap2V2tuKcPGbErLw91idHoXe4TSTg9iq47jbRHlkUr7Exk8xU
         luBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789053781; x=1789658581;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=foiDQ6diynQrcBaahnIV4yufuKYFC6bgEE9f3Z6k/+4=;
        b=kUT7ws8xNZBLMVIBI/w8U2SeRyoDcl4QyztQ/rp9cDMZrJNdRt3kRJLpndNN2w/O+J
         Bcp+Ty0IIMKSdVSv4kzz7UQxtPqqZGiaUZz10uIXT7qk+13E52kIp+34wO/R4X0pS606
         1ON0v84PN7XpAjDdRb9V+157XT+WZyGL8eOBY/YQNXG+/eaICkTEGCq+VCEKeRyvu0B0
         XQZiiE16X16yaM+3nYuoh42VmvttO5FYx34o8LiDaNcOu4uI1o+CsMiQaAkYgeDDf7V1
         ewj8kBmovGZumrDytCDo2Ue6TjnMSB/i/+cxxKecvzU5aUV6AIL96pKKQYdMZHiTA8IA
         piZA==
X-Forwarded-Encrypted: i=1; AKwUvBwTCmtu/b5D+3UpvMl3gCbzM7ht60qnIwfUfjtXNZLODkgK34KBDLl40EpN0w+fnfC0oXNyTmKqpg==@kvack.org
X-Gm-Message-State: AFuF++kgR+5zy5oEi0fZwCycbcfczqfUosw2xcjX8RAEQVt+FkwYXTkU
	07z4UnXhUELig2WVaG4tBclrEGB86dw4PRhnCzOjx/8/ZDvyQP5AvvDLCMLeG1hf7ngmZks4H0O
	oJsP4ynrWQRa8gfHX/rs99DJZSWdGfE4ICrMj0/Oc
X-Gm-Gg: AYBFou1TSby5Hr8KTwGhhWo7+M9eTMMFv8DKTWii8ds++TJVHnjJn3UGwbkqmlXaXPX
	QxYHEbEwdkvon8KNY6UnxZI+C2mt9eBhsnD99y2LFsywXmFMv2CPkwtMINlYtAea5+UQmHt/n1G
	h0Zh6JOPjasydQ8UYM2DHOfOZHec2qfaD4rLXhmVEF+6RrLyTQnWXLpecer32gJMIUi4noXBvg6
	ZU3baF5z3JQhwziDavCytG/ycijxtw3u/9gWwFGj5kImbWzn0Mk5/OaCSURenY65YKvRbMW4KX1
	ACtjSYnOAj9/OiUp8/dnKAtieM9o/Rtns3AdxEqTii1Mv92ACDcVPu8eRCK3wj5EJ7mZY0+qe73
	6DuJJgpe+MQ==
X-Received: by 2002:a05:622a:229e:b0:51c:ca9:3d17 with SMTP id
 d75a77b69052e-530b493ec9amr21800701cf.12.1789053780219; Thu, 10 Sep 2026
 08:23:00 -0700 (PDT)
MIME-Version: 1.0
References: <202609102250.lIycVv3n-lkp@intel.com> <CAJuCfpGzZjvC49EJb8KwjzsEKi2HZbrKs=P+06GNLDSFoTedMA@mail.gmail.com>
In-Reply-To: <CAJuCfpGzZjvC49EJb8KwjzsEKi2HZbrKs=P+06GNLDSFoTedMA@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 10 Sep 2026 08:22:49 -0700
X-Gm-Features: AcwNN1Vpd9Nn3bXuKcyUSWjUYWc9CR-onv1HPhUAjO_3tU0VLTHMUNIuNLQxO5s
Message-ID: <CAJuCfpEz8=emKgxjQ3_Sv7knJZW1+kN7b6Y31uoMh2TQ6C0EuA@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 358/388] mm/sparse-vmemmap.c:507:48: error:
 implicit declaration of function 'device_zone'; did you mean 'device_move'?
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 393F820005
X-Rspam-User: 
X-Stat-Signature: 5u9o8nekcx8b3c5m71r7ew8391ez6k5x
X-HE-Tag: 1789053782-819122
X-HE-Meta: U2FsdGVkX1+mY4dpDNjedPj9+h9zEjGQ7rRfbwbCIa9A1e8MzLV5hf6QOvBlOOkurJpi445ndzCc/8UpJbx6KGmkGnhp5TzmeGQbParcBukIc3/WNXIyIj5kjb3T8McWRmOKoMDqnqqMjBPdqixsla60Tq0hEW7u9C4GjCM5Vg+9k0VRJe7IG1yBbW4iPWid8v7Bc67dogrYouEKTQ1uc7V+aHUIiaGS0YZT+Y6IhpnRkgqtppPWTZmAl8+6j1lBBgeJr/MmpEOV8KNawp79WquneEJaX1F1crwte5B2D6s1F4h7VN4GGbSoxsIyRxe2COKdEAqXXLyxtm4DBXNGn6144YfcAyex0HLk2noEGNdLMAIp/j5IhOwILpaeRafgQ/NeTa4tPZlzLEQg08D/JOhfqV14Idb15qfaH3PUzUWsqxJBQJ/lO0DVLzcgVEa2XTEhMUUA+syIi9nyRfWKqdsDLGmi7z8UUAUKmJV+0EcyWdwIY5EgFTw9SX4Nkc54hWwpWkMEHUz+WD8CC8rxURm/l0xZTqANAe9bbyOZy6R3bdAwNgQZAhQ6df7TaDac3q3k6ewdvvpoxYLOidP+Ua6cjUUSE0l2DKOBVV2aDMlfsi0/Atc1ik6DVXNO/GUbLXM4+ECXZ0uuyNFMGOM4g97gSICIY4oIRqOfiIHHhTmQzRybBfmdWCPuDfj339DoNZjyCr9pORM+RA9//GITZHKdzmzC0BYmTjH7Xcg4aetgfEcgISY6rZpc7ytbIiFoOh1P9D9iTyvH0N82EECeUPXbVxVqxVTSX3TpLsXlFC7+cMqSMs7l4e/LlPBHKkqHzr8WfQoMo4jKdMI4jE1hk5aQuOpEM7OqB+oNB3cpsvNNVWrcL8UnCV75XWLyqcx3zq+PjTv3EvfQoHQ0UWT/dsV9hpRvPpP8dXv51xEPtSk3Kk3Vkh55oqpbtUOFz/qGNDofuw06IAeqeanEc0M
 m1ECcyUr
 vfHGFO3MpS0/mo7mtCTEk6biMg/uwzvpC99zJGaLqsayJoUZY5BAXO17bk5xT0svWYsez0iC5ny1Wbff2Pn2I9k91zmouvIDBa32EBelg+C1a5eyy668Qiof971aTh3FqN/vmshkDAWyEaNNTS8mc3tOhaqlKXh507N5FmGAi9XFDJoriSOBVdTtDjy9hxF7UO0+QwzCxHPutV2VFdlsMLYKpfhb1DpgWU0G73lHLXVEXWTiTAD2iBcqFpzLfCpUcCjw/12bTLm3hO24HR0hFjwWhQ6IsWZ522Z9caqh1C3WuR43msfcBUeXJAEM9eZQPqOEgBOGM3OWsNbIvm+5pPCF0SiIlPbVCsL4IB7Ed3Gfr9adny6eOE0RuKUWgdJZ6424AI+7lXBZnZ0L4p39JTDCpinoD9Zm1eDb3i3kEKkvE5PPU5vdtQq8+y3lNoa19sgI+3Ei81NtRf+edVFOHsw4D+8kAIP79+wC33BVx9RpvBps1xASXO5MATza2u+sbsnRVJPoNayCuM3YiwzWwgd+ajesoLR4HFwU+ItC1EneWYcc9iybCx1uFCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 8:16=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Sep 10, 2026 at 7:41=E2=80=AFAM kernel test robot <lkp@intel.com>=
 wrote:
> >
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-=
new
> > head:   cf558a250cf4475a8936902b8978fbb6c61016f8
> > commit: dd35ca2f2cac9d6439a2ba2f523b98b5a9a9f8f5 [358/388] mm-sparse-vm=
emmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix
> > config: s390-randconfig-r121-20260910 (https://download.01.org/0day-ci/=
archive/20260910/202609102250.lIycVv3n-lkp@intel.com/config)
> > compiler: s390-linux-gcc (GCC) 13.4.0
> > sparse: v0.6.5-rc1
> > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20260910/202609102250.lIycVv3n-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202609102250.lIycVv3n-l=
kp@intel.com/
> >
> > All error/warnings (new ones prefixed by >>):
> >
> >    mm/sparse-vmemmap.c: In function 'vmemmap_populate_compound_pages':
> > >> mm/sparse-vmemmap.c:507:48: error: implicit declaration of function =
'device_zone'; did you mean 'device_move'? [-Werror=3Dimplicit-function-dec=
laration]
> >      507 |         page =3D vmemmap_shared_tail_page(order, device_zone=
(node));
> >          |                                                ^~~~~~~~~~~
> >          |                                                device_move
> > >> mm/sparse-vmemmap.c:507:48: warning: passing argument 2 of 'vmemmap_=
shared_tail_page' makes pointer from integer without a cast [-Wint-conversi=
on]
> >      507 |         page =3D vmemmap_shared_tail_page(order, device_zone=
(node));
> >          |                                                ^~~~~~~~~~~~~=
~~~~
> >          |                                                |
> >          |                                                int
> >    mm/sparse-vmemmap.c:172:78: note: expected 'struct zone *' but argum=
ent is of type 'int'
> >      172 | struct page __ref *vmemmap_shared_tail_page(unsigned int ord=
er, struct zone *zone)
> >          |                                                             =
    ~~~~~~~~~~~~~^~~~
> >    cc1: some warnings being treated as errors
>
> I think this breakage happens if CONFIG_ZONE_DEVICE=3Dn.

Sorry, it's the combination of CONFIG_ZONE_DEVICE=3Dn && CONFIG_NUMA=3Dy.
This seems to fix it:

---
 include/linux/mmzone.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 136235b6975d..0e4c09f4ad3b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1700,7 +1700,7 @@ static inline bool zone_is_zone_device(const
struct zone *zone)
 }
 #endif

-#if !defined(CONFIG_ZONE_DEVICE) && !defined(CONFIG_NUMA)
+#if !defined(CONFIG_ZONE_DEVICE)
 static inline struct zone *device_zone(int nid)
 {
  return NULL;
--=20

> The mm-new branch build breakage can be easily reproduced with defconfig =
on x86.
>
> >
> >
> > vim +507 mm/sparse-vmemmap.c
> >
> > 4917f55b4ef963 Joao Martins    2022-04-28  494
> > 4917f55b4ef963 Joao Martins    2022-04-28  495  static int __meminit vm=
emmap_populate_compound_pages(unsigned long start_pfn,
> > 4917f55b4ef963 Joao Martins    2022-04-28  496                         =
                              unsigned long start,
> > 4917f55b4ef963 Joao Martins    2022-04-28  497                         =
                              unsigned long end, int node,
> > 4917f55b4ef963 Joao Martins    2022-04-28  498                         =
                              struct dev_pagemap *pgmap)
> > 4917f55b4ef963 Joao Martins    2022-04-28  499  {
> > 4917f55b4ef963 Joao Martins    2022-04-28  500          unsigned long s=
ize, addr;
> > 4917f55b4ef963 Joao Martins    2022-04-28  501          pte_t *pte;
> > 4917f55b4ef963 Joao Martins    2022-04-28  502          int rc;
> > d1d11861d8a018 Muchun Song     2026-09-08  503          unsigned long f=
lags =3D VMEMMAP_POPULATE_DAX;
> > 8fbaacc4a64bd1 Muchun Song     2026-09-08  504          struct page *pa=
ge;
> > 8fbaacc4a64bd1 Muchun Song     2026-09-08  505          unsigned int or=
der =3D pfn_to_section_order(start_pfn);
> > 4917f55b4ef963 Joao Martins    2022-04-28  506
> > 8fbaacc4a64bd1 Muchun Song     2026-09-08 @507          page =3D vmemma=
p_shared_tail_page(order, device_zone(node));
> > 8fbaacc4a64bd1 Muchun Song     2026-09-08  508          if (!page)
> > 4917f55b4ef963 Joao Martins    2022-04-28  509                  return =
-ENOMEM;
> > 4917f55b4ef963 Joao Martins    2022-04-28  510
> > 8fbaacc4a64bd1 Muchun Song     2026-09-08  511          if (reuse_compo=
und_section(start_pfn, pgmap))
> > 4917f55b4ef963 Joao Martins    2022-04-28  512                  return =
vmemmap_populate_range(start, end, node, NULL,
> > 8fbaacc4a64bd1 Muchun Song     2026-09-08  513                         =
                       page_to_pfn(page), flags);
> > 4917f55b4ef963 Joao Martins    2022-04-28  514
> > 8fbaacc4a64bd1 Muchun Song     2026-09-08  515          size =3D min(en=
d - start, (1UL << order) * sizeof(struct page));
> > 4917f55b4ef963 Joao Martins    2022-04-28  516          for (addr =3D s=
tart; addr < end; addr +=3D size) {
> > 55896f935a60b9 Gautam Menghani 2022-06-12  517                  unsigne=
d long next, last =3D addr + size;
> > 4917f55b4ef963 Joao Martins    2022-04-28  518
> > 4917f55b4ef963 Joao Martins    2022-04-28  519                  /* Popu=
late the head page vmemmap page */
> > d1d11861d8a018 Muchun Song     2026-09-08  520                  pte =3D=
 vmemmap_populate_address(addr, node, NULL, -1, flags);
> > 4917f55b4ef963 Joao Martins    2022-04-28  521                  if (!pt=
e)
> > 4917f55b4ef963 Joao Martins    2022-04-28  522                         =
 return -ENOMEM;
> > 4917f55b4ef963 Joao Martins    2022-04-28  523
> > 4917f55b4ef963 Joao Martins    2022-04-28  524                  /* Popu=
late the tail pages vmemmap page */
> > 4917f55b4ef963 Joao Martins    2022-04-28  525                  next =
=3D addr + PAGE_SIZE;
> > d1d11861d8a018 Muchun Song     2026-09-08  526                  pte =3D=
 vmemmap_populate_address(next, node, NULL, -1, flags);
> > 4917f55b4ef963 Joao Martins    2022-04-28  527                  if (!pt=
e)
> > 4917f55b4ef963 Joao Martins    2022-04-28  528                         =
 return -ENOMEM;
> > 4917f55b4ef963 Joao Martins    2022-04-28  529
> > 4917f55b4ef963 Joao Martins    2022-04-28  530                  /*
> > 8fbaacc4a64bd1 Muchun Song     2026-09-08  531                   * Reus=
e the shared page for the rest of tail pages
> > ee65728e103bb7 Mike Rapoport   2022-06-27  532                   * See =
layout diagram in Documentation/mm/vmemmap_dedup.rst
> > 4917f55b4ef963 Joao Martins    2022-04-28  533                   */
> > 4917f55b4ef963 Joao Martins    2022-04-28  534                  next +=
=3D PAGE_SIZE;
> > 4917f55b4ef963 Joao Martins    2022-04-28  535                  rc =3D =
vmemmap_populate_range(next, last, node, NULL,
> > 8fbaacc4a64bd1 Muchun Song     2026-09-08  536                         =
                     page_to_pfn(page), flags);
> > 4917f55b4ef963 Joao Martins    2022-04-28  537                  if (rc)
> > 4917f55b4ef963 Joao Martins    2022-04-28  538                         =
 return -ENOMEM;
> > 4917f55b4ef963 Joao Martins    2022-04-28  539          }
> > 4917f55b4ef963 Joao Martins    2022-04-28  540
> > 4917f55b4ef963 Joao Martins    2022-04-28  541          return 0;
> > 2beea70a3edc03 Joao Martins    2022-04-28  542  }
> > 2beea70a3edc03 Joao Martins    2022-04-28  543
> >
> > :::::: The code at line 507 was first introduced by commit
> > :::::: 8fbaacc4a64bd1bfbfb11bfb48b5db3f4943cbd7 mm/sparse-vmemmap: swit=
ch device DAX to shared tail vmemmap pages
> >
> > :::::: TO: Muchun Song <songmuchun@bytedance.com>
> > :::::: CC: Andrew Morton <akpm@linux-foundation.org>
> >
> > --
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
> >

