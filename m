Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A0BD606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 22:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rf+L3/X+
Received: by kanga.kvack.org (Postfix)
	id 51FD16B05B0; Mon,  9 Nov 2026 17:29:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D10E6B05B1; Mon,  9 Nov 2026 17:29:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C0606B05B2; Mon,  9 Nov 2026 17:29:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 08FCF6B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:29:49 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 90CC31C4230
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:29:48 +0000 (UTC)
X-FDA: 85417024056.07.8998877
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id 98F1D80005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:29:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="rf+L3/X+";
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794263386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNrIji48bDKvQSl+1sJXmSNeKsNXMjpGnN8Czk6A87k=;
	b=X3YFNOwKGRFAlizG6uZC56snd3orGfHF0SeePb5uhTufMRku4Ew4deJqkQVT/OBbU9OuwM
	9upfg+JLQovHURDfbsAXeVS0Z75W+ytOXjfsFeLyhmgll8YO4eXOlMDuwZnmRX5c6wWSxI
	3HnB3e7AyOWohie6mD4M9hkn3MROlfE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794263386;
	b=ZHpS67OOH3cyziNGCTPvZUTCXO2PPP7w1MXRA1w6bdcrO3hAKnqCe9jytUHmq54peh7Wg0
	w9nka7xenfZBCG7sNQciF/wCh2n/NyolIV4b2dMjC1nqB4eD3rsWgu8zhO1cQanYOO86+j
	zkA1CSypIKxqPIpvG1czzwC24HQ1XFI=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="rf+L3/X+";
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-490d59c3edaso1044466f8f.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 14:29:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794263385; cv=none;
        d=google.com; s=arc-20260327;
        b=NMd3OYUtgLSU5nLATB8EKCBTf1pp02CNzchkWYVTPPxUS/I+COnsW1uXCzTl3KI0I7
         DEOUTJFLjo6xokmu8xkNHDPcwgEVuGROQ3oZ5+zseH87SFkNuvYKgmp3aJMxfgv8mddk
         EhEjJAV8AMZLNzitDsEarAQ54mQLwzt0GfND8sUhX/kROIYkEjhYz8cpgtPLRpqGALlL
         4bhGuGYYZypZmhAYa9Bj32q7UpZAF99AvewQAqBzIDbMS3VDT5UKgKJkoO8N08WlKA02
         TB5iMeDVA1AobGyfP8XfMq7HFZf6fdumdNAEITkcLEi3n+gxnGpgyA3FvyF3qQrg8RfE
         OZwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pNrIji48bDKvQSl+1sJXmSNeKsNXMjpGnN8Czk6A87k=;
        fh=nPrUN7IUtFBjHQZKF9SYE10mHf8uQvXZup3dnDY5ZTA=;
        b=DzyetY2VIFiPNGpy4SJkpoVhoiaEPPYk9/Sv/s22qOA2giav1EJD6WyLX5SXpQr+Ja
         PPHiFQFAoco/BRCpUW+Axo0OkM9feE+DM+hS/CpuxqeBLi9RaqZeYJtEcuPg2bhfxLe8
         Lp0NfSFT06ZSHniSHuRpMor76g53bwN09RI+aJ3JAkl1ZUZUj6rA2H3N+OnEGC0cbNpA
         EbplryDJhfJDGfTVTwewXidDSe0lpEOh54sCd4hUtnLwOHiop+1Y4puoWUHvtwnt2IRi
         vYgNcVjKVgfPLrOEDRtHB8y1WMO4j9BqTHtijHm4bQTwVMNhL2WQguO/Y2qf3TQrHqvT
         tArQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794263385; x=1794868185; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pNrIji48bDKvQSl+1sJXmSNeKsNXMjpGnN8Czk6A87k=;
        b=rf+L3/X+7AeIoXVYn491Bp4QGZwM4QpIg5aOnWa2KT/P7Hn5AYpDHE3NytXCbff26+
         Wzxi1sponaK3QMKBW777RZpI5vMiONV7WbvItDN4vOX+Za7qvNkD+YVwhAgrgoz8vfCi
         xljXzT99inNiQftIo2tdMUFW7VUrZnGxiukDv+bC/VMoH8ruGKZ/74OR7c9e5eDamSxA
         VwhiPB7okbP0gd/xWzNaoYZ9IBdAqmoRNsFSbxW5gyKNzGYvEzAOVsJyCmrJzR7KmNil
         IoBcJKSVMX2me+2af8yrY5TvfjNUknk8CRmLUxmKzzxdRylWQ76aptRDChgmLhTabUH+
         gcCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794263385; x=1794868185;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pNrIji48bDKvQSl+1sJXmSNeKsNXMjpGnN8Czk6A87k=;
        b=cYdN5omLx0FkMH3IKHqDrB844MfmKmYM+0lECnKFe8+fr7rzbE9tYnlUEBqnCMzx6c
         xRlTI/M1zPd+Mvdf0LcHiZyLeyNrRs/oTXiPAAHVmZ5P75ehbsSVfuaEtOzkHnii9nuu
         dMAsXfpZZGritoYyrR2ngEGIDyUYW7ZWk/rfsuk22aLgaUNvsV1nl/OLngYCP/WVxFit
         IQN3DQYqLnRRd5deoRgMT3wLLUw03DPx/UQQ6NlUW3Qgcbx7m6RWHKFETejcXmLhevOr
         CdVIYI44cr8OFeITco14KHdEevs0Fqptpsk+NdyvEqBggVipyDmRZKO9hGJxpOek9PO9
         ykYw==
X-Forwarded-Encrypted: i=1; AL+hErHTMrcRWCE/MXrwr/JiQFm6hfmz+h9KkNKVwOX5Kd8No2c13atd3FwlsoeZayYrnCMXjhcWk1Yrkg==@kvack.org
X-Gm-Message-State: APuU4Z9TDsQHZb1iLpUzMucgs39I9MQ0AN2j6H8dKtk7MFEh2/+9dhYQ
	dJFHMcenuLVk5dKKoY5Msa2FhzQTGURuScBozRia26Xhj1q9G+6aOtc1lzmA0hFurS+OuZsGCv7
	XzvnKLNwc9gmm3PD2gcSgOssYVF0TCWo=
X-Gm-Gg: AYBFou3JhSU54q/kYr/oGJ9qRlYlu4xtufAaFaufbcn/iUEWiUGoiidYZM8msMJx81V
	y2VTxwnvlReKRjDyaT4IQA9K3FCz4DJpLgL2OAXgpFRLZoHLE/QZY19B2AH+DLN9c+Z68T1221F
	qjCQyrOxLTE5DgvWr/xwjCRGUVHjN/yZEJ+WMxmYxBE1czBXCl7hAYTVDgDg6FqNNtkILWypLcS
	TZ21hkVIWBlu1agofDLsbUis69wx8ywVjCnfN5D9llgezvRcu+c8ViHeFfhwnfgbBiYnqI3h+T2
	TiH6kLuIk5+tPoeJ4q7fBagJNB24HSWOk50cRSeQeGKul9MRODh50wc9UOMyg+JV413gyYlBQn7
	3EdkYzrj7GFI8I0qu9CIFsBrstmCa4oRsINF5kOJRLQMEHlw/up58Hiofd+575qBCbL6zAMBUi3
	32il8G0BST/KymSl5/SOw=
X-Received: by 2002:a05:6000:2209:b0:491:c844:f265 with SMTP id
 ffacd0b85a97d-49837ae2cf4mr1357615f8f.16.1794263385034; Mon, 09 Nov 2026
 14:29:45 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-5-joannelkoong@gmail.com> <sashiko-outbox-198104@kernel.org>
 <CAJnrk1auD1u1J0yQrXOeJrxvVsQfbxYf+nsMS-9qFQ0hfchG-w@mail.gmail.com>
 <aux4FcaEdTrJ60NR@thinkstation> <CAJnrk1Za6=B=Y3HOaJjhU7orq_P27QFe92_n9F2y2+108xDSOA@mail.gmail.com>
In-Reply-To: <CAJnrk1Za6=B=Y3HOaJjhU7orq_P27QFe92_n9F2y2+108xDSOA@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 9 Nov 2026 14:29:33 -0800
X-Gm-Features: AclHuK_RpE8DNp1HR1kdZtoTcCFOd1Bzv7uaSu11gSX2PJIKNAZGbFUvO2KeEEg
Message-ID: <CAJnrk1YTX=kmDY1zwLncOpzTYsJ9UEa1h1PW9egV59hpnpO=WQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] mm: add anonymous mTHP folios to the deferred
 split list
To: Kiryl Shutsemau <kas@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, baohua@kernel.org, usama.arif@linux.dev, 
	hannes@cmpxchg.org, alex@ghiti.fr, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7s79q6nt189ptg4hanwukz6f77jgpa5j
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 98F1D80005
X-HE-Tag: 1794263386-11832
X-HE-Meta: U2FsdGVkX18D9qnqbZqIkGBl9HboG148Tyd/9gRsw/O80RYUAVzp+3DAwiJgSsclFPPcDKDPC6ZZXO6OWW/KrP3aTbIRK40XFPerfiVv5k0DYZp04pVK5V9W+BNjg3xtZpGvCIeWg7XsSbsHXcFuw6892KPfVGndkiBrtOA8AWtAqV5t7gCvH/iFYMDIKcscg5aAqNabwuCgkI/fK6PU+8734kSF7mU/paP0RlqCAEr+9ctVRoGuPgz6xMFgeE1cbmOlJ/IuX1/NNUYdCsP7Lf3OIKgnr/awJW1QXC5lwqEzNaxggKn8xCJo30BP07QGzeLVZJewE63MbTkgrbWWCK7w+fhVe101Sd8riHfz2Io+DgoJKSjk9dSXlmS3NEAJYAqBzBJAQhcY2sqJH1EG1RS1DT84lRpHNvQLlVj62oiocgJ+O1swzIAAwdeJrfc/qjma3GLFB/3LuWoHHfRpOebFctxdOhy+t/P45d6G8EngZ+qt8a3aD6vWsS0/PMzCAHr8cZr1iJtvf4nxyg6GY7b8hEUPDdBdbOOdexi5Xgs/9n+9+XFGNWN72MSFmMsHt1PJL7HC02z3UcefjmN6vM0bV/PJVyF9WaDMQp3qPpRcBmGRZ6uAsARxYCA6rOBGTdDrN+lLsa6nlxki/VPiQ8nm++AdwKn8F6LZmmuBf8UA4Zo8GSs+O7urZVMt2NrMs424PONj7972F3PvUnvwgA5XZ7Ho3JwWJ8ZDi9zZ3j+r23Hgq9sv23mfBcGs0K6vBb8zGpeB/vUgKGVsnUDilb3pA0bxSBFLmIRFCnZqz8CjhnJzp6ZOVNuosivXn3jr1qgmiWqLL3knqSXf9XCjfhBEBa4ssVjfAjaM8CfXnYdQHLUBmMo9Z3kgb36N0wEx5Lgxy5GzOMuxXTmUbK8h+2QsdKFADEHiC6OAliecBh15poxAr5AjDfCIgAnqpWTR73KZl5Fo+iaDX8nqgif
 8omdMtbj
 HpEV8HUHjY1l9wSAOoboIDuBb7tVW7P6U+fyP3Fif1v0qGVUO8tD6Edk95bW8JJ3hc4ec8WOqual/9Wt6oYC/fKGd53kQFRLL3C5WaLNPEcvu67qE/tUoszOPn96uXaOjVjESwRTZS6LNsz8uVzNp2zmJ+lCPIGbsuK3Q8zSXYYt+rgERv/DFu61+XEiL5Z3hCbWgfqLnB2ZUpgpvaXu7l5wHNiZu+3WNiIOL8yKjUr/cKga6RKB5tZc3h4N62bj323Z/QjXvptj1G+fkatdn64lNKJKQeHF/FC3Sqhw96NSP/wROAJ0Sr2n9Iuj1FDF94ftKBc8pLZA71qJjgKOvQ2ttNTiXn7plUF9rsSOe2rSesfXhaiAuoNxIuYpxeUpOv5MxyuAjfCptqLupNihJAxU6Ie6Dl8Qd1u/2KKgUDDg7UTRvskmqCUYnGzrEWz7dkkp1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 4:05=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> On Thu, Nov 5, 2026 at 4:37=E2=80=AFAM Kiryl Shutsemau <kas@kernel.org> w=
rote:
> >
> > On Wed, Nov 04, 2026 at 03:50:58PM -0800, Joanne Koong wrote:
> > > On Wed, Nov 4, 2026 at 1:21=E2=80=AFPM <sashiko-bot@kernel.org> wrote=
:
> > > >
> > > > Thank you for your contribution! Sashiko AI review found 1 potentia=
l issue(s) to consider:
> > > > - [High] mm: try_to_migrate_one() triggers deferred_split_folio() o=
n underused mTHP
> > > > --
> > >
> > > Hi Sashiko,
> > >
> > > I'll try to address these points below.
> > >
> > > >
> > > > commit 82b7b7063b986d802fe52e75e17211e58f3f420c
> > > > Author: Joanne Koong <joannelkoong@gmail.com>
> > > >
> > > > mm: add anonymous mTHP folios to the deferred split list
> > > >
> > > > This commit queues newly mapped anonymous mTHP folios of at least 2=
M onto the
> > > > deferred split list in map_anon_folio_pte_nopf() so that underused =
mTHP folios
> > > > can be split by the deferred split shrinker under memory pressure.
> > > >
> > > > > diff --git a/mm/memory.c b/mm/memory.c
> > > > > index 0c9ed04528d88..44376321180b5 100644
> > > > > --- a/mm/memory.c
> > > > > +++ b/mm/memory.c
> > > > > @@ -5477,6 +5477,8 @@ void map_anon_folio_pte_nopf(struct folio *=
folio, pte_t *pte,
> > > > >       folio_add_lru_vma(folio, vma);
> > > > >       set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
> > > > >       update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
> > > > > +     if (folio_test_large(folio))
> > > > > +             deferred_split_folio(folio, false);
> > > > >  }
> > > >
> > > > [Severity: High]
> > > > When deferred_split_scan() splits an underused PTE-mapped mTHP foli=
o queued
> > > > here with PG_partially_mapped left clear, doesn't unmap_folio() tri=
gger a
> > > > false-positive deferred_split_folio(folio, true) transition during =
the split?
> > >
> > > Yes, but I don't think this is specific to this series. Splitting any
> > > PTE-mapped anon large folio that isn't already marked partially mappe=
d
> > > goes through the try_to_migrate_one() -> folio_remove_rmap_pte() path
> > > you describe below, where __folio_remove_rmap() requeues it as
> > > partially mapped mid-split. That already happens today (eg underused
> > > splits of PMD THPs whose PMD has been split). This series makes it
> > > more frequent since underused mTHP splits now take that path too, but
> > > this issue is pre-existing.
> >
> > I think it is a bit of understatement.
> >
> > For mTHP it is every underused split: the folio is always PTE-mapped an=
d
> > try_to_migrate_one() drops one PTE at a time. Each underused split bump=
s
> > split_deferred for that size next to the new split_underused, and a spl=
it
> > that fails at folio_ref_freeze() leaves a fully mapped folio flagged
> > partially mapped on the queue, which the next scan splits without
> > calling thp_underused().
> >
> > Can the fix go in before this series? I think it is hard requirement.
> > Let's not brush if off as pre-existing.
> >
>
> Sounds good, I am looking into this and will submit a fix separately.

This is the link to the submitted fix:
https://lore.kernel.org/linux-mm/20261109220958.2071687-1-joannelkoong@gmai=
l.com/

I'll wait to submit v5 of this series until I've received feedback on that =
fix.

Thanks,
Joanne

