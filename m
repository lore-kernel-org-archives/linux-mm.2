Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F6CC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 753EA6B00A8; Thu,  2 Jul 2026 20:38:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DAD26B00AC; Thu,  2 Jul 2026 20:38:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57CFC6B00AD; Thu,  2 Jul 2026 20:38:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E4AB46B00A8
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:38:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A498A1A0248
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 18:18:49 +0000 (UTC)
X-FDA: 84944647578.19.17A1BC4
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id A6EBDC0009
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 18:18:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UUcdGNKj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783016327;
	b=uq9r6+PmQ9KZs6vpgnOmVouviqmSO2mXS+r4fOvOazI19F6yA86CBREB+7pJoD1r/tBWj+
	c6nVmX53FfB+N4q1NduHLSJwpsCZwIe1X7B2m9wgUNa/xX9yUpmDkFv8e2qk8apu7vOhTO
	hxApjmLA2JDjtj9R11D9f3TGW1OEthM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783016327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5vBKVusUhh+LOlRFYg8livYqrv9N/Nb70pHUw5IFlcQ=;
	b=JuRrmRuJdVqtKNZ7kWT7Tp4XTLkB27WbgHxMbU02FpW4fFSDOJL2E/jhPib4Rhn9LE1HxQ
	/rjxTqxhBNLj5ZCU8aIQx7nkXim2YFmet6fkuSmA5j/KAsDIBDCVq4DNYYV7ssmzOP7rlb
	So15wH/Jm1b+Cl9SmXLuCYz1EYXiFzE=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UUcdGNKj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5aeb6bdeaeaso20718e87.0
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 11:18:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783016326; cv=none;
        d=google.com; s=arc-20260327;
        b=J44ot7CTK5KxVUmSUCcdf/IIifj7oxDm5BN37aTiDh0rWDN6dEI7Dvt3sqKN3nK9Qe
         CVl2D7unnSg4yWNGaE361ci+nuFbf3VvHCkI1exukjowLAMM71zUnGwF08haYLwasJDT
         J89AHfpkJmODwMZXSQkBQJ1f54SdVjq9/IdPakAhRs5PHCWe3Pcp34uNoObdIt8MYGiK
         0JMHES+fTD5QLnsL9GsD30jklhCSCkM3+52QI3xDydkjMeYKKKTXT3Y5MIONtYJf3752
         DA7LCvr1gFtuYgzlEjGgjMa4bqqKdk6shVHNZITio8ddNWSkkOovjRCDSwDktAHgcmGp
         GYYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5vBKVusUhh+LOlRFYg8livYqrv9N/Nb70pHUw5IFlcQ=;
        fh=ZzzrRWhZ01yTIUSip1NG/lnqzXulDBd2VnRHPDjmP1E=;
        b=CSIBgR11BkJQ6Z563yKY3iv5kItRTouH5axZk8RdZFGW/+EzNLMDl9fg4iSQKCUVPA
         YxBVA9LjvDD1Yw2PYhQaA9t6lkzdyobfA9RFE50gTkpVMiAz9/rHXPXjiPTheMxqphV4
         P8s9gRKgwdJVccV1D+xHSswtDtAcyF+YQleRfot2xXZhVQYAM3j+aZ91jxIyXIuVbEjb
         Jotb2vqBIvWO8iboB/7cptBBN0CLUSaH0UPv42e0ruEVahgCKka6LbMCCna9in6SS23Q
         DEC2wzJ5JyavKuRdPaHUM1E/UOxR/4ZBiMBI+RFLfznqV9oyLQacSu0elAbNI3HnhJRe
         Us1w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783016326; x=1783621126; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5vBKVusUhh+LOlRFYg8livYqrv9N/Nb70pHUw5IFlcQ=;
        b=UUcdGNKj+fwsW/OIJdfT+cWpq/M6VCUlKZhV81TBzgGqj7nSASNXcU4YYKJuoUNWBD
         xymdaYPKAz+svHETOmiNtgXQ6wMpYNOG2UOxluYSmeh/nFtWDuuw34U/wx+v2gZ464Uh
         JbaptYAgDgsmMTcjeFvczFCB8oMNkBLjBxjCLdlQVHyPvN/O97UPfvMoqSEAN1RfAly6
         eXfAANqTdFlEufxnux5gS2SYuYdLaDPK3w4bMWguYKliWmd8j5xhyQctt2z0Ur7OZBqz
         kF8Sp659rBFFDAq4i9ZmLiGJKQT7+ZPpi9VzpZlER913cNk2ERV1LpQiRla4DhoK2LXr
         M2Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783016326; x=1783621126;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5vBKVusUhh+LOlRFYg8livYqrv9N/Nb70pHUw5IFlcQ=;
        b=o6M6q6Wgoz6srLugrCbk42m/hG3e3sSyxIztVmQEcu9+0PGe8hODdoxDrXbkEEatNS
         bF2TaW1AvKKYkIQ0TfaNjAgKXTSwr+Z5BoKzLwZ2JjliHrV0C3xnc8q86U1QTSdZfUgQ
         JMN0JZfCWeKglQuRJB03ehfHUrYtntvHUoRuHb7gXpPzKNlDZ/dHQhLFBerSRf/vllpB
         nedw5yoqphRhIy77BgdZgXiV0yIRrecAp7kUSqz3opCkpmlO/z1fzKKtKMbaYS94kySE
         q8g8pRRCN+wPoC8teNyrFwMyquxX2ZrT5jEbH4eO6LK7ibz/RF0NJZvhd5ULflcxqPvk
         kmNA==
X-Forwarded-Encrypted: i=1; AHgh+RoYJ5jBi1jWNa21lLP86BUm9mWZlCvVk8tZ9hhjC/Sl3nJwVMsCW/mOhIlMQGYXkWLl+UPrlRHXRw==@kvack.org
X-Gm-Message-State: AOJu0YwYc1ysnH8W4a+Ijh3vL15zwVmFqzoSQT6nFs1U+RszTXoFVykl
	mVaDnTZOVwWsmL5b93psa2kAgP0mma8UWd5neu+KX+7ysYzXgnKaRSky7fPg65rUTevEJJ4N5dO
	mudoPZo1N4qu+YS9tpwOh+R25QfCwxPhYoJuIgfr5
X-Gm-Gg: AfdE7cmVhPD9QZp5kCnqJkUccTKbupokGqZFA0Qnv0IiTR6lBx3Uf1SfvMUZTpxmnES
	6CQrvwqNDMhD8a1T46oeOyjZUvvFKYGOftKCx9s7XCBEUJuyBoYAo/r9eI8sWhZz5k+ZGBouQdk
	nXSi3cqaSn6JpstPVumhi85t2M5Nzkw1LbBwcYklMuJ/gGof4QkWpIkWWZlXdvu5CbytrIwtpPv
	7lF9LMwFBROjIv7n48UrfWNmFKmFnSHQxf1YJIbQtn40usrrYH/tMxfCiCKRT0Sxw5DzjUTlRy2
	tybN+sPL4yoxcnD6su1tBEdCr1W6+uJy5J+A/hfvTqwA7aAN6h+4vzeOSj8W
X-Received: by 2002:a05:6512:3b13:b0:5ae:b9c5:f29f with SMTP id
 2adb3069b0e04-5aeca329781mr250856e87.2.1783016325421; Thu, 02 Jul 2026
 11:18:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260628190155.3655895-1-souravpanda@google.com> <20260630173953.642186-1-usama.arif@linux.dev>
In-Reply-To: <20260630173953.642186-1-usama.arif@linux.dev>
From: Sourav Panda <souravpanda@google.com>
Date: Thu, 2 Jul 2026 11:18:33 -0700
X-Gm-Features: AVVi8CcO3YOMVKbTzeg_nzqFwgAEGNc_iEXsvJ4SgtCLlcE8KSYf07uWfqh9dM8
Message-ID: <CANruzcTqtEmLQo_7nF-=qZm=arZwJK0=a_oitFmebw0ZPFbo5A@mail.gmail.com>
Subject: Re: [PATCH v2] mm/hugetlb_cma: support percentage-based hugetlb_cma reservation
To: Usama Arif <usama.arif@linux.dev>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org, 
	david@kernel.org, surenb@google.com, fvdl@google.com, gthelen@google.com, 
	rientjes@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A6EBDC0009
X-Stat-Signature: d39tfdthibff7boj7icmd6m5m75xaewd
X-Rspam-User: 
X-HE-Tag: 1783016327-434703
X-HE-Meta: U2FsdGVkX18f/nxNZ3yoIjtggrfMisNEhNsMbuSemduu8XkTqXEv9VZiwiCqBct0aPm0jV6Vcj7TXHdrHglYZHkLmgiJCoqIS3/DfgjnnJ7/MxM/SSbF39mWbuLJyppntTTmtKHlmm4rGAX5MP00Fjtfhn8MCVw1vl7DIcRBok+dKKCTXp+KaieCV9XxUh6jwVtpwEmRGrFH+FhlNcvZM2JVBxeS4G9/NTxa8+xGQATLmNXCHxslBdwhFnMA/bO2m7JK26Ibng/BfeFM2DUc18cxt5kYX2CR0GgAhXEsUA38bJBfvsdZEAl8W+egiLeLUzR3g0z6WlTbJznJH/mGsT42b5DFYzjF/x8rbvC5E0vFxtCGleRB3XXA1i3FrBz1aXlBH0FE0O9QgScvGWnCO1yRwv67QzO1dCcMmNz4SDIeJ7wIe5xHYfc89+fwhB7rRGk04swsGxWg0Yr3q5pyWs8THGqOO/AwYz9/OXokgohgYxCL/NatKn4eU6ORcku72uW35Y71Isn+hnrfi85wPPlhE13gFHup/lF8itLV8Gu2EzUpBlR+tCh0eK3MiGdTebrA8Y6XYZFNgdunTnXa2Mt00hTtcRISDrwTD7mm+7Q9ASYyHtqeLN9TUq132bYGyqO0jYTGhJBERayEXTpV61rVeQviin8/YUFEKZRT+raF3AqeaNifyrRXAcJV1DbxNKvWqLU8rgntVgfIG/qsIQ/SoF+pta5YUOr95t171naKUgpJwmuwmBxkQlM1HJ7fj61LKXPyMjK+ebsdIRNYj27vq8kiB/gliCwq6AbNA+XUHuWRgfekWr8Aaj7GbBc5sXJT4iPvoSvzLeZP+/Q7aAIUPv0mONk5hqa1LHGwttVihRSBmi2zDom6B4f/MiWD1Vp7cWCqD2LIB2WOnDOI6226rDkZfEOVZvh4IqHYouyVe3IxP/pyfYU/nVFcUvL8Orlx6PXe8R6ogaCRhCP
 EZihJEJ/
 yFaVNmSPxcb5SJfMxnrxdiEWRxr5Bgb6ckgQeCYDqf0PgNfCxorkXNvYtXQ0GNgzXW0B9HcTtRkkHSv/Mt1Nf/caNNvw1MBym7KvZwa5oa4TyJPqI/Z4IDiEnIZW/HBHZcccHlWdDQFDiXU61uqkD3LZqBGG8mFLPhNuvSXemP/A7HUnno8BwokpaEFeHKXOgtY4h4Bs7tR+DysG7GACkufGV3CU1f8LgQpye8wqlvjlkqN2i5GWp21kapihoGyhb87l9JI+d3xwDcrjT9Udru9HUvtLTuwxdjWyI8F9//Q0UwqryXB4yeGTujEQignniZZOhi39u7Iv0l/HFeROd0sLIKbckFuW7r0i3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 10:40=E2=80=AFAM Usama Arif <usama.arif@linux.dev> =
wrote:
>
> On Sun, 28 Jun 2026 19:01:55 +0000 Sourav Panda <souravpanda@google.com> =
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
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202606262023.IKUrn01I-lkp=
@intel.com/
> > ---
> > Link: https://lore.kernel.org/linux-mm/20260625215900.2151690-1-souravp=
anda@google.com/ [v1]
> >
> > v2:
> > - Use mul_u64_u32_div() instead of mult_frac() to avoid 64-bit division=
 on 32-bit architectures (Reported by kernel test robot).
> > - Fix physical memory size truncation on 32-bit PAE by using phys_addr_=
t in memblock_node_memory_size() (Sashiko).
> > - Fix boot parameter override logic to respect standard last-one-wins p=
recedence by clearing opposite values during parsing and clearing node-spec=
ific values when global values are parsed.
> >  .../admin-guide/kernel-parameters.txt         |  7 +-
> >  mm/hugetlb_cma.c                              | 96 ++++++++++++++++++-
> >  2 files changed, 97 insertions(+), 6 deletions(-)
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
> > index 7693ccefd0c6..684ffa3537d2 100644
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
>
> Can this round percentage-derived sizes to the gigantic page size before =
the
> existing alignment checks run?
>
> For example, on an x86_64 machine with 64 GiB of memory, hugetlb_cma=3D20=
%
> computes 12.8 GiB.  The later hugetlb_cma_reserve() alignment check requi=
res
> the total to be a multiple of the gigantic_page_size, so the documented 2=
0%
> example is rejected and the reservation is disabled?
>

Hi Usama,

  Good catch :) and thanks for reviewing!

  So right after this block, we get the  order =3D
arch_hugetlb_cma_order();  and carry out a few checks.

  I am thinking we can apply  ALIGN_DOWN(hugetlb_cma_size, PAGE_SIZE
<< order)  right after the  VM_WARN_ON(order <=3D MAX_PAGE_ORDER);

  Something like this:

        VM_WARN_ON(order <=3D MAX_PAGE_ORDER);

        if (hugetlb_cma_percent) {
            hugetlb_cma_size =3D ALIGN_DOWN(hugetlb_cma_size, PAGE_SIZE << =
order);
        } else if (has_node_specific_param) {
            // (Same logic applied in the per-node loop)

  Thanks again!

> >
> > --
> > 2.55.0.rc0.799.gd6f94ed593-goog
> >
> >

