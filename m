Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88748C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 04:11:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ED246B0096; Fri,  7 Aug 2026 00:11:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89E5E6B0098; Fri,  7 Aug 2026 00:11:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D876B0099; Fri,  7 Aug 2026 00:11:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42A306B0096
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:11:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 99F67A1D80
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 04:11:45 +0000 (UTC)
X-FDA: 85073149770.17.BDA1FE0
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id AFEC4C0007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 04:11:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SmUlh0DD;
	spf=pass (imf22.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786075903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i78iyadDU2WNNYbh4XsR+1TGkpkqG3HsIJBD5GjPBmU=;
	b=1vYXs6QFOpyoacwG+Qk0WPKZaOSZH5gfQfU1xxdyv3LypBuRNSX7evDbCIevgGA1fIbvV5
	lHPGwVwE1Z1eF4vyIS6h9hQxqu+jypuHNsANNOPsHaD40GIRCGhZJQU6TNBF+juNEZsspK
	19XdV/At8GMFdK955CDO8Unc+USAppA=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SmUlh0DD;
	spf=pass (imf22.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786075903;
	b=kLGjpMwhPuXu3TPqMo+sQ79VKUH5MmGBDjQlZGBQ2opJ5G7Ce+zjC9SlCFrltcItY1FntI
	v5h68ScFnExN+mFkSOTquZv13GK2IqJKHAAkklO1tpVs0EuTGE2iVajKpkKm956iVEeW4l
	l/sgRlFfUQkIwHbmWzNV1Z1JMhgxcCg=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5b2a8173142so2840e87.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 21:11:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786075902; cv=none;
        d=google.com; s=arc-20260327;
        b=hOVoLKEd4PSaAxQ8373lKTC0Cl+DXgwom+TmWMxc++k2sllDFyMkh+nGPGQX0jtiXF
         7P0KGMpj+r1DHI/cvG82gYLVcL80RSA2EStTenk8w8ESvo61QRYrFueOjz3cVs6ooNBP
         +8yxGYStPJ8KAacBSlaAzW4BH0Q1iVyMjoPqWTzHlO/y0B3KBgVatXzuOxslOz/GUqAN
         sdbeiGZQIPj0uuOn/zRdISqTY+GAwoQ2ZqmQCo8KhqfuOov3sxnNJ0sPd1Mn0OQgQYMn
         NgT2pfutSl+j1VYkUkQdWieraqCBKeaJ6wTDPsfHyC7RqBfycNxboXmcG/sOXe5QrTfA
         C5ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i78iyadDU2WNNYbh4XsR+1TGkpkqG3HsIJBD5GjPBmU=;
        fh=Fj+d0m1nI/bjxe0c37+WkZkzYxXw+g4SbfEBrJs15hk=;
        b=WFd3MkWnVDOLkfKA6kXLNGGzLbYEixtdlDHGLzUQHKmN8VumosTO7M+BnfR2lv2UDR
         NCRKkKeA5h09R689PIlYJ8oDnX9/ry1+C0jauY3dsYVtgxyiRES/1uCYR7eSctEgdqWV
         CL41iyOV9x+SEH0eFXPSlMNmqEdbxEokN8L37dVYv0PVeOrc5BwggJBBGVKgf+4JTykl
         c8x6J+Br4UiMw5BD7usq7S24Eq/Vo3GpHQTxePpImCMDh4qF3cMzqu/+HUS7ScfOxpfS
         5p7CKkITTVY3BwrGuwA9owvzywgQZFZ52EhEwdreJ5YyD04HbiMzd5TLmPqN+i2VZVzT
         f0pw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786075902; x=1786680702; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i78iyadDU2WNNYbh4XsR+1TGkpkqG3HsIJBD5GjPBmU=;
        b=SmUlh0DDz7oHLiwE/UsM8ZjA9DXK+ILevZRQCymXzaLAiUe/7GRPX5CdeITq4ER1xQ
         PYonSkboyh0FFHV9QmZ4HAQM9Kiokjc9HYA4zu+RNwV9iGOXTQnUu8XX9ZjEKEhn4Unq
         l4SUiTy7bGAU7oOnlPaes3LZmwXtdgHFfFiAEcjhcBFAv84njCqbtIj+2VK6a5tZh8Bb
         5A/32huDpWJwjGRd08r4NYJMs1TEmvFr9EhXqfehNC6vS60GIkBjfnIdLtAJzZShK4iu
         oJQboQffl4wmg4JWC5bFE40mD2BRuRVnDrPkyJAF9sNyeK/INtlTKWb/4E5+1AhOHt0b
         YOZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786075902; x=1786680702;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i78iyadDU2WNNYbh4XsR+1TGkpkqG3HsIJBD5GjPBmU=;
        b=fsJ3uR3cMIa/JY8Gs3Om4Bc2WfRazKrBu0/7Y3sJ3mdFQBL6Pk67N2vmKbPu8RC1AV
         vfQeVRIGW3h+pbuv132Bn0Fr9RYzC7mP66Dbq9OZkkMPAP0WYjTMIKRwKnp0qmPUC0+Z
         gGUKoejPtOm0RONYTfJh6FX4tvEIxirE9dEmSmkY4l8wac0++PNASdTUE56JsxK4wcOB
         9NslRzO6JSL0/ibx5yiaD7LfqLatHtb9V0njL6NfLYulaTFZ6J2BpLV2v8+GQZ2L7HZK
         oG7ChP+e2TvANdIv1590IiqBc0gFikgrTXxyhXhVD8FZ33642/HMZtl/nT6+c/+asBbd
         NszA==
X-Forwarded-Encrypted: i=1; AHgh+RouwPLUWTzQSMGx48A7geZaVAQbKn6BMlUPWTbpI/TG3L2MoTADCoLbAr3kl0WwaOe86tYprhEU8g==@kvack.org
X-Gm-Message-State: AOJu0YyABlI2ueJbcdl32fiEMbJ+aDBEGuB8S1si+ExIavznaVCcJpuo
	qwABNP3e6V14wjwCzEGDyPKUA1tMIBpLOPXUnV5LVq1d8zpR0xKk352vRRb2PsQ70MvzDGB30n9
	mwKRA8GtNryfus9c/3mZmvqw0JXq7mlsVI3nFFQe+
X-Gm-Gg: AR+sD13t0iv63dPEm5MF/nqYI8vvhtgtlRiOf38n6pMkuD6NZhQN3gZJo/SDCOnZBsF
	3S92F9canPRarHla8Y8tmFdAN8FWSiXcMULMP4buY1ncPmgyC858rVAwCskAbEeG1jKQkDpCBXK
	OCJ467pny0LVTya2en2WrZHFW+AN4IB8y5k9zo3gYYspptxWJUFT1wan7403v6W8vRy9ZWzvzOg
	nYDNN6qeADhDRVNOPUiR96fUS57Oeu8EnYipkuP/a/DY3c8v+04lWFkyrZxRFDBbbJA7VBbijH6
	bVGnlPdZPtcCIa/WfrFGTWwzl81EX7GE+UPgLFuP7D4WXGy9xmuwn9n7aoXFnPFT0SZr3qC3ZkU
	5hUlZ4f1tpswLRMOvDqYJ9aZbOeVoAgdCyA==
X-Received: by 2002:a05:6512:12ce:b0:5ae:b9c5:f29f with SMTP id
 2adb3069b0e04-5b304c0a61fmr127719e87.2.1786075901406; Thu, 06 Aug 2026
 21:11:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260726072935.3513996-1-souravpanda@google.com>
 <20260805202444.1573218-1-usama.arif@linux.dev> <2qq6r5zvegrk5bbx7qbkscwqmccda7mxtzuvd3wln24yjm2qhx@663fzadsgmg3>
 <CANruzcT9PEXYRu1t_ge9ZNE8hLBpt6rWP4CwsBUkoZQTtpPKdA@mail.gmail.com> <007cdb8b-01e3-4d73-9ac9-1a52ab5798dd@linux.dev>
In-Reply-To: <007cdb8b-01e3-4d73-9ac9-1a52ab5798dd@linux.dev>
From: Sourav Panda <souravpanda@google.com>
Date: Thu, 6 Aug 2026 21:11:29 -0700
X-Gm-Features: AUfX_mxWH60gK9UlA2T2tU0d42j7_xSa11P7VXAxl2IkH57VUwPLlfIVI6cyBc4
Message-ID: <CANruzcR5AZHEg1TdAGG3Qm292vHXMB3BXvssm_rkv+xj+TBnNQ@mail.gmail.com>
Subject: Re: [PATCH v4] mm/hugetlb_cma: Fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
To: Usama Arif <usama.arif@linux.dev>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, muchun.song@linux.dev, osalvador@suse.de, 
	akpm@linux-foundation.org, david@kernel.org, surenb@google.com, 
	fvdl@google.com, gthelen@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: msj37nyw19qf8bikkkkb6rjofjuu5is9
X-Rspamd-Queue-Id: AFEC4C0007
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786075903-905211
X-HE-Meta: U2FsdGVkX1/WUFTrfbtzB3FHxrFP250XNJe6LvsJeRol1LlIc7abW4biitPE4HuYd68jYkDtwQtFX9BmIr8f88bq45f39P3Gr6UgfaCqADsLC3EOdx1qrOTH9bK6axnYCm6EtUaw95+3hKl+U/1dqBZHhbFUbJhRzlrk4ja2uqOjBGNr3YbaR0FjRVTKv8nOiH+gJETJAN9B3YCYzOFjiLhgJsi94pLkwGt5cSijd3R7Y62FDnNl2yOubADNoRE29FC4mFKaklTGFuZNwZuquZF3dRA5PPzHNpZmFSZDdQWwjAXockJHtJT+vtCuiljSDfZphxx7n+5bFYnaNVP+XlgnSMuRO8ARDTst/+IbCBDjEIsuzbtpeCGxglPKsqXwTKIvdM81qQ1U3hki38f3U0a5sab+D/jyM3J8DHSQOH/LDySIty3o/6yxgXvW+UAsXiixD0/VAQYvCQQp/FS0xYCDfUgFoH+BjXxS1v4xMlO/sySdQ8kZ6P6Vlbrgwh6tGXmS2ihPOMVegPC8EKkkyK28g9a1vINpqj2971RhIYpsodMYHOkgNNTXiZZbGTPwPPRMGhBXFyBOsSv5ulQEEWr5eGDG2wvfvBAsxLkpylwfFSVap5wb+Ce3jMoydc4VPbu8tIXJQ6y0EFfraiwJfww9xqgKqDCGeaHiwsmnVJz6MaAq9SSM3Ef93zdETF4K5vZMxfOTO7hLVvmL8oxmGVfuyxJfZi4TPaZWSG42RYAJtoovUiF0YL+5HYgpNkUpjFIoE4L87a2xBLtfdbvmPg5Bv2MDGoJ7Fuu1Wtgil5IVxKKP5DRcwy/xh5wvjC80SxeNPjRoVWqMOgGprpPM0PyUxgbDpzlopLFIEwagbVPdJQRUXQ0SNfBorGw1NN5T+Y+ozbVt+3Hl+dv8WYD+aopeWmqyzaq5rhU8JXDtPEFECGYZi4yFlPP7V3koPND4bTnSf3sxazw6eOag3w1
 8XnALeiR
 6T+l8V0BEJQwRSxDhppQOofZB4YT+gbMU0MWVsJdHLrKxqKsExODsZbOZgGImXbSIRpbo6e/sXBGubM5FZuo9sXygY3pCr19hF7CzV3BXKMdCrbftjug7kTsaX4IK3X/N2gC9sflwtr9I2O0r3aRvKeuWCud7rmS9rtZ+UfuukQwf4ImO2MUrx22mgcOoo3rbp4G7EctTzOtjKt0Fmm0a2UCPI80dj6JTMtxUOxJtxDpj/lk4fiPDdtiPQBQFIZ+9gnaKqvdHgv7nP+W8vzhzGg9Ug8/I/2WsjfTPyN2dbOu6gKKxNSAlFjQJga7LKceYo5PcaU++t4AAl2kHUxe9B04Qp4PFkoZ+XAU9BvZ0DFCQtPZmCxv0NA32+mT4X5ItZYFgcvCsY63zvVw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 4:07=E2=80=AFAM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
>
>
> On 06/08/2026 06:33, Sourav Panda wrote:
> > On Wed, Aug 5, 2026 at 7:47=E2=80=AFPM Anshuman Khandual
> > <anshuman.khandual@arm.com> wrote:
> >>
> >> On Wed, Aug 05, 2026 at 01:24:42PM -0700, Usama Arif wrote:
> >>> On Sun, 26 Jul 2026 07:29:34 +0000 Sourav Panda <souravpanda@google.c=
om> wrote:
> >>>
> >>>> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> >>>> alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> >>>> nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> >>>> the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> >>>> alloc_gigantic_frozen_folio().
> >>>>
> >>>> hugetlb_cma_alloc_frozen_folio() blindly dereferences the nodemask i=
n
> >>>> node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemask),
> >>>> leading to a null pointer dereference kernel panic.
> >>>>
> >>>> Fix this by checking if nodemask is NULL in
> >>>> hugetlb_cma_alloc_frozen_folio() and defaulting it to
> >>>> node_states[N_MEMORY]. This allows hugetlb_cma allocations to fall
> >>>> back to any node with memory, keeping behavior consistent with
> >>>> alloc_contig_frozen_pages() and alloc_buddy_frozen_folio().
> >>>>
> >>>> >From a userspace perspective, this bug allows an unprivileged user =
to
> >>>> crash the kernel (trigger a panic) by requesting a gigantic hugepage
> >>>> allocation with MPOL_PREFERRED_MANY on a system where CMA is only
> >>>> configured on a subset of NUMA nodes.
> >>>>
> >>>> This can be reproduced by booting a VM with two NUMA nodes, restrict=
ing
> >>>> CMA to Node 1 (e.g., hugetlb_cma=3D1:1G default_hugepagesz=3D1G
> >>>> hugepagesz=3D1G hugepages=3D0), and running a program that allocates=
 a
> >>>> 1GB hugepage area without reserving, restricts allocation to Node 0
> >>>> using mbind() with MPOL_PREFERRED_MANY, and triggers a page fault:
> >>>>
> >>>>   void *ptr =3D mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
> >>>>                    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
> >>>>                    MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
> >>>>   unsigned long nodemask =3D 1; /* Node 0 */
> >>>>   mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
> >>>>         sizeof(nodemask) * 8, 0);
> >>>>   memset(ptr, 0, 1UL << 30); /* Trigger fault */
> >>>>
> >>>> This results in a NULL pointer dereference:
> >>>>
> >>>>   BUG: kernel NULL pointer dereference, address: 0000000000000000
> >>>>   #PF: supervisor read access in kernel mode
> >>>>   #PF: error_code(0x0000) - not-present page
> >>>>   Oops: Oops: 0000 [#1] SMP NOPTI
> >>>>   RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
> >>>>   Call Trace:
> >>>>    <TASK>
> >>>>    only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
> >>>>    alloc_surplus_hugetlb_folio+0x6d/0x100
> >>>>    alloc_hugetlb_folio+0x3c5/0x660
> >>>>    hugetlb_no_page+0x3d9/0x650
> >>>>
> >>>> Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic huge=
pages")
> >>>> Cc: stable@vger.kernel.org
> >>>> Signed-off-by: Sourav Panda <souravpanda@google.com>
> >>>> ---
> >>>> Changes in v4:
> >>>> - Reverted the alloc_fresh_hugetlb_folio() cpuset snapshot approach =
from v3.
> >>>>   As Muchun Song pointed out, snapshotting cpuset_current_mems_allow=
ed does
> >>>>   not prevent false-positive allocation failures without complex ret=
ry loops,
> >>>>   and alloc_contig_frozen_pages() / alloc_buddy_frozen_folio() alrea=
dy handle
> >>>>   NULL nodemasks safely internally.
> >>>> - Handled NULL nodemask directly inside hugetlb_cma_alloc_frozen_fol=
io()
> >>>>   by defaulting nodemask to node_states[N_MEMORY] (Option 2), keepin=
g
> >>>>   HugeTLB allocators clean and consistent.
> >>>> - v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-soura=
vpanda@google.com/
> >>>> - v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-sour=
avpanda@google.com/
> >>>> - v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-soura=
vpanda@google.com/
> >>>>
> >>>>  mm/hugetlb_cma.c | 5 ++++-
> >>>>  1 file changed, 4 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> >>>> index 39344d6c78d8..5744de0ceeb7 100644
> >>>> --- a/mm/hugetlb_cma.c
> >>>> +++ b/mm/hugetlb_cma.c
> >>>> @@ -34,7 +34,10 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int =
order, gfp_t gfp_mask,
> >>>>     if (!hugetlb_cma_size)
> >>>>             return NULL;
> >>>>
> >>>> -   if (hugetlb_cma[nid])
> >>>> +   if (!nodemask)
> >>>> +           nodemask =3D &node_states[N_MEMORY];
> >>>
> >>> Hi Sourav,
> >>>
> >>> hmm what if cpuset.mems only allows allocation from node 0, and huget=
lb CMA
> >>> is only available on node 1. This will no now allow allocating a giga=
ntic page
> >>> on node 1 when its explicitly not allowed?
> >>
> >> That's fair point but should not the user be also responsible in provd=
ing a right
> >> nodemask containing CMA memory if it prefers avoiding node_states[N_ME=
MORY] based
> >> fallback mechanism in kernel ?
> >>
>
> I don't think the task can be made responsible for providing a CMA-aware =
fallback mask
> here.  Userspace supplies the MPOL_PREFERRED_MANY preference, but the ker=
nel itself
> changes the second attempt to a NULL nodemask.  That permits fallback out=
side the
> preferred policy nodes; it does not permit fallback outside the task's ha=
rdwall cpuset.
>
> >
> > We have precedence for three options, which makes selecting one difficu=
lt :)
> >
> > 1) nodemask =3D &cpuset_current_mems_allowed is currently being used in=
:
> >        only_alloc_fresh_hugetlb_folio --> alloc_buddy_frozen_folio -->
> > __alloc_frozen_pages_noprof --> prepare_alloc_pages.
>
> Here I think using &cpuset_current_mems_allowed is part of the page alloc=
ator's wider cpuset handling.
>
> > 2) Some places use cookies with cpuset_current_mems_allowed to prevent
> > torn writes. But this adds complexity.
> >        An example would be dequeue_hugetlb_folio_nodemask()
> > 3) node_states[N_MEMORY] is sprinkled all over the kernel (simplest).
> >
>
> I would prefer option 2.  A NULL mempolicy mask should fall back to
> cpuset_current_mems_allowed, not all N_MEMORY nodes.
>

Sounds good Usama :)

I will send a patch that replaces nodemask =3D &node_states[N_MEMORY];
with the below:

+ unsigned int cpuset_mems_cookie;
+
+ do {
+ cpuset_mems_cookie =3D read_mems_allowed_begin();
+ local_node_mask =3D cpuset_current_mems_allowed;
+ } while (read_mems_allowed_retry(cpuset_mems_cookie));
+
+ nodemask =3D &local_node_mask;

Will send it out tomorrow! Let me know if anyone has any objections.

>
> >>>
> >>> Would it not be better to check cpuset as well?
> >>>
> >>> Thanks,
> >>> Usama
> >>>
> >>>> +
> >>>> +   if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
> >>>>             page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], ord=
er);
> >>>>
> >>>>     if (!page && !(gfp_mask & __GFP_THISNODE)) {
> >>>> --
> >>>> 2.55.0
> >>>>
>

