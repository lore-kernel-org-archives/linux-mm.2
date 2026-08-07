Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 699EFC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 05:55:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48B086B007B; Fri,  7 Aug 2026 01:54:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 439B56B0088; Fri,  7 Aug 2026 01:54:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30CC86B008A; Fri,  7 Aug 2026 01:54:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F319E6B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 01:54:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 59D4F1202D6
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:54:54 +0000 (UTC)
X-FDA: 85073409708.21.265DF72
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6E91B100002
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:54:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Lw8LWXWH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786082092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCZEpJNJfrzJ2+zf5kv74E8kREBs0HYXycpY26gpuJc=;
	b=B8dBXPfMinJbpNHnDSY6r/92EST13aIo3aYdJD2gItPaKglaxWUr0Axf+4ktqfDx/mXovL
	tmNuinC9F79DFUwCnUHosMTISOPw7MQjQ2Wc9fr6TQT5emQ4cqb2eh9c3cZ1pc78tvELOX
	k406+UNIeq1jTYGoX9YPwdzAMAFgCQc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Lw8LWXWH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786082092;
	b=0pNNOxw9dIDFVyuKy0nQieBkudkej+KbacnwZCFN1SM5D5zHQAXXB3lzqhlAgKN6EjN00O
	p0Wiyke8tCLF6SVUomskdz0qN9e+TfwAbKKv1RWZCOAnSDu3sIWmPl/vQDaYXth1Jwr4dl
	eb/QPHZgIhv5F2VV6xRraji1D3YY4BA=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5b0129cf6ffso3384e87.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 22:54:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786082091; cv=none;
        d=google.com; s=arc-20260327;
        b=kV6HdAxz9PSQv8PHxn0F0Ip2shqhUIFA9rslRqsGKb1Ie1TfKfBuRsHc7pwYV2iq01
         whX4IYwJcHIl0U1AjyuNAHDOlBDg8J4/5n/8AfS5aa9GzkKQD4RFx6oB3KaZKtTKcctQ
         HOOdDjZxJG9z0a5q9V3pXVx6hSteojse6RHv8UhxCtFOyZbH25prD2hJ/QY7NCxMybci
         zib2ij3F1L80j2JF76dlVAoNXsmUGgURo1h9Pd/L6zPlnXPKXT2X0rSqvVC+qukVGFuQ
         sVMVtZeYxJXAXacmFqebCncg3JiejKxJXUS2tFQBZvZXok3eIrNUyjLG1K766XFWQiZS
         inCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RCZEpJNJfrzJ2+zf5kv74E8kREBs0HYXycpY26gpuJc=;
        fh=6S8MflWUr5FhPumjSV42MJs5jTd/kJME8pVkA9/WIj8=;
        b=A8I6zDqNar0PeC99qI6S9MKuMsqaii7JmmGyf0TmS1gHlDt2OaHR2AHNWqzyNcTJKa
         fkfo0R8zPyd7XODSqs2rP7lFOrKPNMcsH3yvni4SAzyfTCMVOs1oO+xOV+Pp+v8misK9
         mjpdU2yTy1nk4v9GDGgQ/68f6+3OWXyJpJ7wfQTguZ+KfEihH62zsgFCMznKNdm3A1VP
         nAJ1LDeH7WHpNBfkfErgf37UNiAAZX2Kzpd6wtrotcZipsi42BkO9lZNUDfLaj90Bn54
         FAHIgwubj1SxyLfBfvmNfW1HZ4YQa+RSAWYFcmW7tE5RSbH7rg/WeDVjPH/86czmzD5c
         tTYw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786082091; x=1786686891; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RCZEpJNJfrzJ2+zf5kv74E8kREBs0HYXycpY26gpuJc=;
        b=Lw8LWXWHJtyE+YoLegLpM47PqMU0l79TWE4fcvG59tQeME77+akVRisZqaOZbsn9cE
         9etJ9yXI+ofS2qkrwZKvfNOrh7FPN84HabJquy0lFyEDx+DgTyUjdgCcr52KsHGjjz76
         U9X/ZffoeFgHsHKQ3OXFUT6Az9fUI8uHs9eXau5qBFevmzDlsTPLvfcVwnABj6rtK65g
         nTI0GHoQC96EsKrJFsDvFknsNMVPm3F46F816jZ/kKovwEjTRX6VGZWMWOAutTtNnD4o
         teOvqRmFtKpjxGVXipXeRrGVGHPEES1PUoAaibqJo+aXoNbJ+NviIm7CSjn3Lk6DGUFi
         nIVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786082091; x=1786686891;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RCZEpJNJfrzJ2+zf5kv74E8kREBs0HYXycpY26gpuJc=;
        b=LahImvGPjQcMtO+OX95KqVZPv9KcqURBstZ4VdIYknLpJfm3yL1ccs4oHfDnNPAgQv
         1nvocFeWuqRDlAA8/BtzMz4pgSPXS0EajfK2tmOtrTV8FcChNQoSo+JM27GDDcTMjwTH
         YNEP2Ug9WPieEbUOK4pVQowM4EwApqAhauq7Q1UJxTHDdM0bw8Oqj8NtvhcYNqhLwSzj
         bNQeYwBbz2+BoBmzb4ZJAO7/Q8ZfP/HE+Ficiq4Jzyip1qZm4OazSq9ZqMkU9xDAPxb6
         ezBh2lv3n3xDSLXULr2tPZxAaGnv1RFRKlZuWmDFSk+byEY8sX6Y4nCiwazsePHeotfz
         /8UQ==
X-Forwarded-Encrypted: i=1; AHgh+RpOSkNA6lO7LLUgq9R5kkb6RKw1Oc25JdoL0ge4tcnSpcnOit5GL42IVD1K2Z1mwFZx2Sx/kky4HQ==@kvack.org
X-Gm-Message-State: AOJu0Yy+6BFDROqjHMMA/F3tT8d5a6V4ZyKJgz1WrP/C7b+8VcfKcQla
	ulGSCVRCtNPs3WseiE1CqALWLOyJ8GTowmEirYeZ8yjQ6uGH5vRz+61oTXoB8exqv3mdtcmBQxh
	x/yYWM5G6t0sih989HKxBI7Lr4wcKTkL8a5rM6L/m
X-Gm-Gg: AR+sD13QWpuO3bLt3UmnTjuTdA2TLPVS5DukG09PNsPatEFLOB0wYXb1CcLdmpVv3pz
	cs/o1lSmucF50Cr9POB/M80dwvFVAtBG8y2W1iSrxA/jTbjMP5ljdQPjTAHIyGGTB9pKdmxgMA2
	9BH6Ql16U1pGDh9GEidTtAt5v9JacnpYvuDmmSq6lM5jUPoP1YU8R4tI/7vi9z/kJfxnC3VMpQs
	59F+XVkrggLIP575jmzFllVd/2K2PwWeWimI5UprLJAaDdypkVwVwwPdSVoozM3GVVFsO51kwoc
	fp4sIHwEjNJ/kOi+JR+32wdQX4/0Ku8PhS6mE1x1vl5hGWxiI6jSYyRRa98UsxH5aCUFh2e8HYS
	YxsxvsaBFTsob5c1TeFzOBP6rt2LPX7gVnQos43DDGyGs
X-Received: by 2002:a05:6512:10cb:b0:5ae:b1b3:145a with SMTP id
 2adb3069b0e04-5b304d41a95mr175952e87.6.1786082090179; Thu, 06 Aug 2026
 22:54:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260726072935.3513996-1-souravpanda@google.com>
 <20260805202444.1573218-1-usama.arif@linux.dev> <2qq6r5zvegrk5bbx7qbkscwqmccda7mxtzuvd3wln24yjm2qhx@663fzadsgmg3>
 <CANruzcT9PEXYRu1t_ge9ZNE8hLBpt6rWP4CwsBUkoZQTtpPKdA@mail.gmail.com>
 <007cdb8b-01e3-4d73-9ac9-1a52ab5798dd@linux.dev> <CANruzcR5AZHEg1TdAGG3Qm292vHXMB3BXvssm_rkv+xj+TBnNQ@mail.gmail.com>
 <2sipzzq7amhd5kn4xbqmtzc25iud2zp76dhpefcujqqpcnpqrt@czyz3dag6hlp>
In-Reply-To: <2sipzzq7amhd5kn4xbqmtzc25iud2zp76dhpefcujqqpcnpqrt@czyz3dag6hlp>
From: Sourav Panda <souravpanda@google.com>
Date: Thu, 6 Aug 2026 22:54:38 -0700
X-Gm-Features: AUfX_mx6Q2IQlc6_66kba5ZDPisz_RPBOxLYGAKq4hpszthEL_25bvWPU-_ZhlY
Message-ID: <CANruzcS7U5Brty6GH7W9-cr_vjUys7MFb_hRcQy-LxDCD8Perg@mail.gmail.com>
Subject: Re: [PATCH v4] mm/hugetlb_cma: Fix null nodemask dereference in hugetlb_cma_alloc_frozen_folio
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>, muchun.song@linux.dev, osalvador@suse.de, 
	akpm@linux-foundation.org, david@kernel.org, surenb@google.com, 
	fvdl@google.com, gthelen@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6E91B100002
X-Stat-Signature: bne8nfn9pkn8fph5wtd11cwhgau58zrw
X-Rspam-User: 
X-HE-Tag: 1786082092-705475
X-HE-Meta: U2FsdGVkX18Q3eeo0U12720GBWD65RSydMeQf413MWxbvYlvOtYR9X0pjmo7PD7Ljgy7CYsGVATMUI34uKS9L31qmaTsIvwjaz2f/Kwtol0faLsERXPXVQMivw3vzEVrRc9R7cPpuj8bmXFuCOSGFG+xWmPt4GA7+LRjPBBrgo703M6oR1eMiCOD02JTjHwdacJF7re9cJfVDvjP4wV0wy9hN5S02rcGNbWdgWA4Q5M+NDWO6MXOiD5uv2mypJDIumNlzPbmEztOH+c8VpDHl7mT9ryMKOEDoYG9yJNtu0sehuKBrxzBJBUWMW7b4g0ztbqDB/pMGAzB5qr16vzJohuAptPOJdQ1jhfVfuGkEL9mjkdg6naHdDWNZK72A2XNYgnTmJpNTaRlX8PUKoWAb4Me+3gsuUl7vyPXhyrWpO0JyRHeA3TJ9gcEUXC0BQznyQ8dHSdws0ebb1X9XsK9y66+KvwRm1y/bAWdMFuz9hP4oxEIUWM7tAymBMwaL7H5IxVAcuqNtmxmoY9lEAcxSsUasQXu7EJyWHx2eJjGPrwXwFmBxnCOYJEJGKO3XXJRJFYNnXZsxg/Mef06zUBbKMmlP/YS4/SVG+Kpyp2HEyPOjsMmCqd8BVBSk8ye/qvYUV/AFhaFAus7dm9m2jrdbpZuWaZJWk/w1KBHIp/yvgDFsxxekgu2A8kjdqvGp4D/Xp6sdZdLj+LjR5aZWMX8flKWLdTkSym7BbZ3bdKRPtXPjAWYTrg5NqAaxpbZyqRLJYBx4ZeS5trVq2a8RW3RRN14NFmnhAsPJhfvvjAeQxJSmPzy4HgZMU3N7r5Uq1I4d93qRVsp00ozl2547lpZjf4NILi1Q3V6dM1Y0ASL6wT9CSxkQu9PQ18iHj+CpKjIy4CZbTehxTqFm3dgRWozDjJgEIK9mglQ0ZDLMOAtoC2tnRO1Q+IYRs/4QaKIHOBE5KA5i7Bc9r7sgapp147
 2trWNXsE
 H8iH8vfFD1QLpQQ25wmqsJHB6xOrszJ+I1UZqEAhLlyY/OaXYJiy/yvkaZND+bFMAWkPPPNG+iOAaGfN8r0k9h1AfGwjTW6D0PkWyke4vyLxNE8lkDPoLxySv//be3NmVEArqq0nXfTF7UEgu36JUaMwsaoaOYDAgxKzbJnLyMGmwBsnByidXrGIbdA8VQ7KmDgxlzGstIbjo6RXzoaXbAytEQlqFhMplp6fgHQoVcA8cftZmcjaLLrq0hufbiZ7VUofGOBH1o4oOOT32y9TkFYFZia/S6KsWtxEnudJ9CDjQOCJCq0KZZk43try6czHqS6Y+uF8PuK8DIkdYWE8sTPt6jRT4uREJ/nq92gNzwgBTKwBPAicLlSplSiCXxG9jWVoeVipa1tSQK/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 10:29=E2=80=AFPM Anshuman Khandual
<anshuman.khandual@arm.com> wrote:
>
> On Thu, Aug 06, 2026 at 09:11:29PM -0700, Sourav Panda wrote:
> > On Thu, Aug 6, 2026 at 4:07=E2=80=AFAM Usama Arif <usama.arif@linux.dev=
> wrote:
> > >
> > >
> > >
> > > On 06/08/2026 06:33, Sourav Panda wrote:
> > > > On Wed, Aug 5, 2026 at 7:47=E2=80=AFPM Anshuman Khandual
> > > > <anshuman.khandual@arm.com> wrote:
> > > >>
> > > >> On Wed, Aug 05, 2026 at 01:24:42PM -0700, Usama Arif wrote:
> > > >>> On Sun, 26 Jul 2026 07:29:34 +0000 Sourav Panda <souravpanda@goog=
le.com> wrote:
> > > >>>
> > > >>>> alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask t=
o
> > > >>>> alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> > > >>>> nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propaga=
tes
> > > >>>> the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() via
> > > >>>> alloc_gigantic_frozen_folio().
> > > >>>>
> > > >>>> hugetlb_cma_alloc_frozen_folio() blindly dereferences the nodema=
sk in
> > > >>>> node_isset(nid, *nodemask) and for_each_node_mask(node, *nodemas=
k),
> > > >>>> leading to a null pointer dereference kernel panic.
> > > >>>>
> > > >>>> Fix this by checking if nodemask is NULL in
> > > >>>> hugetlb_cma_alloc_frozen_folio() and defaulting it to
> > > >>>> node_states[N_MEMORY]. This allows hugetlb_cma allocations to fa=
ll
> > > >>>> back to any node with memory, keeping behavior consistent with
> > > >>>> alloc_contig_frozen_pages() and alloc_buddy_frozen_folio().
> > > >>>>
> > > >>>> >From a userspace perspective, this bug allows an unprivileged u=
ser to
> > > >>>> crash the kernel (trigger a panic) by requesting a gigantic huge=
page
> > > >>>> allocation with MPOL_PREFERRED_MANY on a system where CMA is onl=
y
> > > >>>> configured on a subset of NUMA nodes.
> > > >>>>
> > > >>>> This can be reproduced by booting a VM with two NUMA nodes, rest=
ricting
> > > >>>> CMA to Node 1 (e.g., hugetlb_cma=3D1:1G default_hugepagesz=3D1G
> > > >>>> hugepagesz=3D1G hugepages=3D0), and running a program that alloc=
ates a
> > > >>>> 1GB hugepage area without reserving, restricts allocation to Nod=
e 0
> > > >>>> using mbind() with MPOL_PREFERRED_MANY, and triggers a page faul=
t:
> > > >>>>
> > > >>>>   void *ptr =3D mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
> > > >>>>                    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
> > > >>>>                    MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
> > > >>>>   unsigned long nodemask =3D 1; /* Node 0 */
> > > >>>>   mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
> > > >>>>         sizeof(nodemask) * 8, 0);
> > > >>>>   memset(ptr, 0, 1UL << 30); /* Trigger fault */
> > > >>>>
> > > >>>> This results in a NULL pointer dereference:
> > > >>>>
> > > >>>>   BUG: kernel NULL pointer dereference, address: 000000000000000=
0
> > > >>>>   #PF: supervisor read access in kernel mode
> > > >>>>   #PF: error_code(0x0000) - not-present page
> > > >>>>   Oops: Oops: 0000 [#1] SMP NOPTI
> > > >>>>   RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
> > > >>>>   Call Trace:
> > > >>>>    <TASK>
> > > >>>>    only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
> > > >>>>    alloc_surplus_hugetlb_folio+0x6d/0x100
> > > >>>>    alloc_hugetlb_folio+0x3c5/0x660
> > > >>>>    hugetlb_no_page+0x3d9/0x650
> > > >>>>
> > > >>>> Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic =
hugepages")
> > > >>>> Cc: stable@vger.kernel.org
> > > >>>> Signed-off-by: Sourav Panda <souravpanda@google.com>
> > > >>>> ---
> > > >>>> Changes in v4:
> > > >>>> - Reverted the alloc_fresh_hugetlb_folio() cpuset snapshot appro=
ach from v3.
> > > >>>>   As Muchun Song pointed out, snapshotting cpuset_current_mems_a=
llowed does
> > > >>>>   not prevent false-positive allocation failures without complex=
 retry loops,
> > > >>>>   and alloc_contig_frozen_pages() / alloc_buddy_frozen_folio() a=
lready handle
> > > >>>>   NULL nodemasks safely internally.
> > > >>>> - Handled NULL nodemask directly inside hugetlb_cma_alloc_frozen=
_folio()
> > > >>>>   by defaulting nodemask to node_states[N_MEMORY] (Option 2), ke=
eping
> > > >>>>   HugeTLB allocators clean and consistent.
> > > >>>> - v3: https://lore.kernel.org/linux-mm/20260705175119.440599-1-s=
ouravpanda@google.com/
> > > >>>> - v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-=
souravpanda@google.com/
> > > >>>> - v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-s=
ouravpanda@google.com/
> > > >>>>
> > > >>>>  mm/hugetlb_cma.c | 5 ++++-
> > > >>>>  1 file changed, 4 insertions(+), 1 deletion(-)
> > > >>>>
> > > >>>> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> > > >>>> index 39344d6c78d8..5744de0ceeb7 100644
> > > >>>> --- a/mm/hugetlb_cma.c
> > > >>>> +++ b/mm/hugetlb_cma.c
> > > >>>> @@ -34,7 +34,10 @@ struct folio *hugetlb_cma_alloc_frozen_folio(=
int order, gfp_t gfp_mask,
> > > >>>>     if (!hugetlb_cma_size)
> > > >>>>             return NULL;
> > > >>>>
> > > >>>> -   if (hugetlb_cma[nid])
> > > >>>> +   if (!nodemask)
> > > >>>> +           nodemask =3D &node_states[N_MEMORY];
> > > >>>
> > > >>> Hi Sourav,
> > > >>>
> > > >>> hmm what if cpuset.mems only allows allocation from node 0, and h=
ugetlb CMA
> > > >>> is only available on node 1. This will no now allow allocating a =
gigantic page
> > > >>> on node 1 when its explicitly not allowed?
> > > >>
> > > >> That's fair point but should not the user be also responsible in p=
rovding a right
> > > >> nodemask containing CMA memory if it prefers avoiding node_states[=
N_MEMORY] based
> > > >> fallback mechanism in kernel ?
> > > >>
> > >
> > > I don't think the task can be made responsible for providing a CMA-aw=
are fallback mask
> > > here.  Userspace supplies the MPOL_PREFERRED_MANY preference, but the=
 kernel itself
> > > changes the second attempt to a NULL nodemask.  That permits fallback=
 outside the
> > > preferred policy nodes; it does not permit fallback outside the task'=
s hardwall cpuset.
> > >
> > > >
> > > > We have precedence for three options, which makes selecting one dif=
ficult :)
> > > >
> > > > 1) nodemask =3D &cpuset_current_mems_allowed is currently being use=
d in:
> > > >        only_alloc_fresh_hugetlb_folio --> alloc_buddy_frozen_folio =
-->
> > > > __alloc_frozen_pages_noprof --> prepare_alloc_pages.
> > >
> > > Here I think using &cpuset_current_mems_allowed is part of the page a=
llocator's wider cpuset handling.
> > >
> > > > 2) Some places use cookies with cpuset_current_mems_allowed to prev=
ent
> > > > torn writes. But this adds complexity.
> > > >        An example would be dequeue_hugetlb_folio_nodemask()
> > > > 3) node_states[N_MEMORY] is sprinkled all over the kernel (simplest=
).
> > > >
> > >
> > > I would prefer option 2.  A NULL mempolicy mask should fall back to
> > > cpuset_current_mems_allowed, not all N_MEMORY nodes.
> > >
> >
> > Sounds good Usama :)
> >
> > I will send a patch that replaces nodemask =3D &node_states[N_MEMORY];
> > with the below:
> >
> > + unsigned int cpuset_mems_cookie;
> > +
> > + do {
> > + cpuset_mems_cookie =3D read_mems_allowed_begin();
> > + local_node_mask =3D cpuset_current_mems_allowed;
> > + } while (read_mems_allowed_retry(cpuset_mems_cookie));
> > +
> > + nodemask =3D &local_node_mask;
>
> Although complexity increases with the above mechanism but probably
> it might be better in terms of being compliant with task's hardwall
> cpuset as explained by Usama earlier.
>
> >
> > Will send it out tomorrow! Let me know if anyone has any objections.
>
> I would say let's wait for a day or two before sending the respin.
>

Ack!

Thanks Usama and Anshuman :)

> >
> > >
> > > >>>
> > > >>> Would it not be better to check cpuset as well?
> > > >>>
> > > >>> Thanks,
> > > >>> Usama
> > > >>>
> > > >>>> +
> > > >>>> +   if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
> > > >>>>             page =3D cma_alloc_frozen_compound(hugetlb_cma[nid],=
 order);
> > > >>>>
> > > >>>>     if (!page && !(gfp_mask & __GFP_THISNODE)) {
> > > >>>> --
> > > >>>> 2.55.0
> > > >>>>
> > >

