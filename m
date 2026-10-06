Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 972B6CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 14:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566856B0088; Tue,  6 Oct 2026 10:01:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517E86B008C; Tue,  6 Oct 2026 10:01:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 405C56B0092; Tue,  6 Oct 2026 10:01:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1ACD26B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 10:01:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 89B9240204
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 14:01:47 +0000 (UTC)
X-FDA: 85292364654.24.03C5D60
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id 86DC140005
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 14:01:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tA7xFXpQ;
	spf=pass (imf07.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791295305;
	b=ChGW2HZfpHJkOdJKc8FSUhiWnMkmu5DclK8qgfPwRUqv1oWkJbGOA2AYC9pvteIsvAEpmt
	NcL8xti85Dm5bHIRvR6m7UoAX6H8SdXJAr+fFawSdT4+4rl2D/JVDlIIiuTA98OQnCEnhW
	JikO3VyoFU2EHq2Pq5WobEnpybk6nkA=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tA7xFXpQ;
	spf=pass (imf07.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791295305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H80LEoa+Ed4z/bo92vNwYanr8Bxl+IJiscZmWaNEy4s=;
	b=cN7ybgWgBD53IRaSH87j4sHoBeVZzjv6RTQTVbaXAZfKBydtTvLGY3pSXKDgutMcR0ZPtY
	RvPQOuWi8obEQ/tcSC/wCO8CJ+JXb4Rfqddwz79maP1/xWV+bn0bnUQhcNUkgldgCPCLML
	4h+jNl+miaNx26DwdtYouGPvkb8/miw=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-885cf67963eso7422567b3.0
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 07:01:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791295304; cv=none;
        d=google.com; s=arc-20260327;
        b=WnVpp2shkTPPQu8vaPLN36aU0jYupZ67TTI3L83YsUEfCcZ6XRE1APz05BW1TZI8J5
         QN5ZaYI/TroS/Cj17eliJWMWHmqzA8mAiZelDkSpvniTIMI3dXitRZf3jUs4yNvD+9tA
         1f1K+AGj+jtu5aO6xmEJhJJq38W+tYi6AvDvdYcCG/evFEgSiQM4+Nl1YrRBWKJt6WWR
         0OnMOGc9fTRzTrcWmG1x0d4RKK8YZj3tomgM6X8FaYb0JevkkvCpRfIIcdrE8LiNGBuH
         dXSEdFWw9lNCqN07OdkQ3bWA0uF4A8OAeXB7CcppeJukeqLwFLeT3kh1xNUwiPa+/Fu5
         kG1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H80LEoa+Ed4z/bo92vNwYanr8Bxl+IJiscZmWaNEy4s=;
        fh=lrprQ98bdp1sbguwXCkpMWL1slV4w6dA3ODk2udLLmE=;
        b=KMwHbLoJ02a7iZFF9lxlE8g2xFWAACX6PCC40Usgpv1Ix/dkB/Vcw+d152kek/6cZo
         FCJqyw8Vtl+Na1avL0xSP8WLrrwfPJBk/1Kj/TIzU6/34tTAhNuFISniK9YXTP0XM5lD
         BbeJx+rvPS5BHzO32iEWnY0b9O9cs1h4W1SOr/WecfAX5NbaTgcg/XgpKPw6UJwCU/ej
         lzDUmWD2xCVSwwwwbpUDvRfXdIjBGQQeYAIF8pdcQNdzA2cJ6wNjnflbZret/Rio0XmM
         OSFZBpL4ah2GTiKEpCdrvk28FP8PDHz+bUbhLPJGzr9zX85HRRUPOk8Cc0aOFK0YejDK
         vSNA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791295304; x=1791900104; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=H80LEoa+Ed4z/bo92vNwYanr8Bxl+IJiscZmWaNEy4s=;
        b=tA7xFXpQ26MI4hpVm+3TEXtG8WKlgS02Z4su9+kAnPKfRMRVMUvLomnhUGoFuxFHv9
         XlFNA5Vw+ayF4MtKX8dayPzmrNwdgEsEjHuVFEme2VGXZhK1ntpGNx/SAot5yUNMK/9Q
         90JSSxfsx037cSFEZUgk2noV7G3Q4Pj7o+/4jd1Rr3lwIFDQNpr8IOm144LtV9VfHIIj
         yZzgPKV/htv8PBn7MTWXbH1mK3Abt8bWPvzLBpYTvyFoAwP2ASrVUkHnfXz9KflHuyxA
         zNkl6vXxcc8/tt93DkM4HdLDUTyosClReBSuFRwUM9GcsvgvRuFyqHaqQN6FpBZJuD22
         A0UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791295304; x=1791900104;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H80LEoa+Ed4z/bo92vNwYanr8Bxl+IJiscZmWaNEy4s=;
        b=HvkYNly+QS9cYUCGmsNzE0qxoNYRDolPUgkkfuAQJ2vi4W6luSk8pc1P19k/RX0+zu
         BcxdpLx5NeUYvbKEa2CYt+xnh3ypXEvh9KPxqxcstiGu1qylFiqqBjutGTP1iy1Ntyh9
         5+S/hpgMI4+M9y1o4eFCejzVKYhJVlOQf4t9s60irg54CCQulstI5Lcs1+VQ537yuneV
         53ag+Y6SYv0ndeJ/4fi1PUbP0YjzMzK/6vExRXmt7a4AqVQKysfrer5cCqKekExkwGxx
         NxdEKwlLkh2CZ/GqbAM5Db11u4H3dSgE7vcKQLNJlj3FEAHUvuKIJcHokL+fhfYIM350
         bKWw==
X-Forwarded-Encrypted: i=1; AKwUvBxzGcQMBI+m7w/9LvI8OEpyTBuALLCZhcZlDeafyb6UymBXWcTYTHaVDgvmm8av+MdH9GIWGYhpUA==@kvack.org
X-Gm-Message-State: AFq9FYIhewP7ewOSnE+BwA2h+yFIRs4jhwldfQoKQ+Xzp4wk2smi37sL
	UPM3R4Da80k+9PrrzHspBM0UkMc/63H4leFrEWhN4DbNOh+NlAjiMqqSpAjgT0LlCHPllymuB4J
	pst4GSM7qUlI3D4602XGuHJ9rco/Y84A=
X-Gm-Gg: AYBFou0EpD+gyhR4HxgTdMRmafjqYKSAv7Zk94ush27whXBu1hrLd49053rrKC7Cfvr
	c6l9k8PjLXqsd1JnEvKHo5qwb+CWKFrBqYdPV4cQ39ACAaWO6y7SW8mGgZM2TCD0+dzplgbRqi4
	WGxEz/EcQCVfmomOoqb/tZlBKwhvKrO3vz5Z4qt2EwhMkybVqxP9pUJQ1kR8ncUW+4ksQplQ1f2
	Dr61i9vDGfwWlr/NuWdIK+xFYnVD4ZVqln6CzwHvU5JULaZVXofqk8Xanfsp57+CgBKPzU57lMe
	N4dOMCrIhaUgY2AiFgzxcQ62ZLKo+NvtvfRp/0zQ9GFexVh0OuNBotHY+lDl1QaEh2JXzKxmPzQ
	ubNxHvS+yg+mJCWTlkujC1v8/YYjW6ELgF3u0wnmNkz+zwSEsyfAQ
X-Received: by 2002:a05:690c:88f:b0:873:5c7b:c0f5 with SMTP id
 00721157ae682-8b04f49907fmr7810607b3.45.1791295304055; Tue, 06 Oct 2026
 07:01:44 -0700 (PDT)
MIME-Version: 1.0
References: <20261003001555.3498357-1-joannelkoong@gmail.com> <gz7cxhldkfkinbzpx4goa6rhdqpzldpaenzhtfoxcztpzj5avw@hkzo4fbdbck3>
In-Reply-To: <gz7cxhldkfkinbzpx4goa6rhdqpzldpaenzhtfoxcztpzj5avw@hkzo4fbdbck3>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 6 Oct 2026 16:01:28 +0200
X-Gm-Features: AclHuK_uZOogQkMdxz27vAGUCfidPFeie1EwYBw8NyEpTx7XUT6D_HjCrQZ5F8w
Message-ID: <CAJnrk1ZaYAy_81OVxZ74wF1EXF8j13giGdu_CD7Q3XLzX-XThQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/3] mm/readahead: avoid per-folio memcg reclaim
To: Jan Kara <jack@suse.cz>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, shakeel.butt@linux.dev, 
	roman.gushchin@linux.dev, willy@infradead.org, mhocko@suse.com, 
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org, vbabka@kernel.org, 
	liam@infradead.org, rppt@kernel.org, surenb@google.com, riel@surriel.com, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 86DC140005
X-Stat-Signature: itbxhami3td1b1kfwjkfc4mxzu98mhft
X-HE-Tag: 1791295305-577968
X-HE-Meta: U2FsdGVkX19qa1sz9n0H7agjrqFm/gfdudQzd7oe8ks5tWJb+7xD4qcHysOCMzPuM/JJSPXG3OBhhc4+tuzKGAc4vEQlCBzhwH23YxeslcXAXDi4YEonryRr43TRaOnqC+Voiorhd6p7RbrJQ3Be6YY+CjbUfNk4HNiBmDmD7A7cpbrEQa+P0MZP2iUcq7z7XiOCzpabJq8gbQlaiXAbipPFuww3N1OHgzSjMGE8CC1CpQ3mIM+2fIW9NOl2iGPkZkYT3WEscg3ZsbJt06z4OFpsD0thrvP6HAaWHVnxZxGaPeHgNbHJu+POvnzkkVNjjPYXpoCrdUWtImUodqJfU/vrfElVXoqW7GFVtE5I7uQDODZ97OrNsfbysYbINearp8DFRxJ1fGYiPGPeoEBWqgZ0l0CCOmodWlCjZctNUoVkF8DeJeYap9KH4fPa/AvZie/3B0n6GWkbbTO4RZS7vF1AWHF5fRaHyMJFLu/IfjRRB84N0rPkFWGZUZTBirPUk35YVDV4BV2U9FB2sOHWoL6vAIx5q9kQuIq+ZNebC4BWFCc45iJoNdtCvOgbk2NTjUsnz5OoRvqwi8/XM6R58dzFJfyKc6THyf1Jb/Y/bEPMmpEyJCvJRMpIslSdukbS/WDcscZGBIbA/wP5cWSgk/aBkHbFJ3+U2LLUW1cDkc5IFeyPwQzmoV8o4jnlp4uiS4eWozHzba8PP5Ju3W+uAn2GQ2FCxBWoRHpmiTdmrzWIQOtYT9p0/Ouz5m30Hjc0NJ5FoFnqNf6z0NnqcYiTFLxjE1eSatUuxgO7A7L8tqzv9wixW1IjQ4LTB6djSX7fGMxbNP5HjY7S/XGnrihNk1e4cvK9tn4U1LDMaJ9gqJUgbdidA3pgHm9zFJkVZIZduPFNQ3ESdVWfinmFKEfnDvf6kjZ6l78cSHlt7hHnW4/cKq3HCwUcbEfknOwEVaGtV/K18IU4nosXjEMussU
 6tm+WJze
 dWVwNVN7TI+KPWXvYQ3dTotsixQ47Bpkp6KrwJPQtFbyVJy8g25F2r5jmVfMbsSfByOgKfDW6ABmUhT9RFZJGpp9wxaAP+fHdgY9waj8xNRUhudkoeheqGCun5jjQGWnlNqawXKO6U9nVO3BrVENoBybIYIpqz+szRWPr/acLy1SDUigjfWJSMpDJcLYeIdELo9fV92yCIiFtuR/L0Hahnb19tnxqoknPdL+TPUm/iewwV44HYAU1O7wIBRaa9+htvAcpQXJY1m5icz6+mNUEzaRde+GhNOTalo5ZgSYoGHr2QK3of2uYBBa7GGKBXsVLJrOy+lkRl2cgmxtqSLIhRLSd9Dhj51lbT/YH7AVliinSdPgwVo4zVW7R2MNEMKNxuGbqGamJ99C3URk1t0+7iG5zPrh3i/XrHL1QRVvXPxL2a9ViVQ0VB698YMtKv7CaXYYbbJFIKIOML7M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jan!

Thanks for taking a look at this.

On Mon, Oct 5, 2026 at 2:27=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> Hello Joanne!
>
> On Fri 02-10-26 17:15:52, Joanne Koong wrote:
> > Readahead adds the folios in its window to the page cache one at a time=
. Each
> > folio is charged separately. When the memcg is at its limit, each one o=
f those
> > charges triggers reclaim. With many tasks faulting in the same cgroup, =
the
> > margin one reclaim pass frees gets consumed by the others, so the fault=
ing
> > tasks keep reclaiming, all to make room for speculative folios, and in =
the
> > worst case, reclaim livelocks.
> >
> > On Meta's fleet, this per-folio reclaim is a large cost. From fleet-wid=
e CPU
> > profiles at Meta:
> >
> >  - Page cache insertion (filemap_add_folio()) triggers about half of al=
l
> >    memcg limit reclaim CPU, more than anonymous faults, swap-in and
> >    memory.high combined.
> >
> >  - 93% of that comes from mmap fault readahead: filemap_fault() ->
> >    do_sync_mmap_readahead() -> page_cache_ra_unbounded() ->
> >    filemap_add_folio() -> mem_cgroup_charge() -> try_charge_memcg() ->
> >    try_to_free_mem_cgroup_pages().
> >
> >  - In filemap_add_folio(), 83% of the CPU is memcg reclaim while the pa=
ge
> >    cache insertion itself is 6%.
> >
> > Most of it comes from services whose worker cgroups run at their limit =
while
> > many threads fault in mmapped files, mostly on btrfs, which our hosts m=
ount
> > with compress-force=3Dzstd:3.
> >
> > This series adds readahead folios to the page cache without direct
> > reclaim. When the memcg is at its limit, readahead reclaims for the res=
t of
> > its window all at once instead of once per folio, and tries a second ti=
me if
> > the window runs out of room again. Please note that this only applies t=
o
> > speculative readahead folios. For the folio a fault or read actually ne=
eds to
> > read in, it is still charged with the mapping's normal gfp mask (with t=
he
> > reclaim flag set), like before.
>
> I cannot really comment on how much sense this makes from memcg POV (I'll
> defer to people understanding that area better). When I'm reading your
> problem description I'm wondering about one thing: Are the folios we are
> faulting around really used in your workloads before they get reclaimed?

I ran some traces on two production hosts and am roughly seeing:
* of the readahead folios that reclaim dropped during runs, ~66-78%
had never been mapped
* running a 60 second sample: mmap read-around accounts for ~86% of
readahead on both hosts. 77% of the folios it adds are never mapped.
Around 10-15% are faulted on directly and the rest are mapped by
fault-around. mmap_miss skipped read-around for only ~2-4% of major
faults. For faults that triggered read-around, mmap_miss was below 10
for 74%-96% of them.

This looks specific to mmap-readaround though. On these same hosts,
I'm seeing much better utilization by buffered read readaheads (only
~30% never accessed).

I think a big part of what's causing this is that btrfs by default
sets ra_pages to at least 4M (in open_ctree() in fs/btrfs/disk-io.c).
In do_sync_mmap_readahead(), I see "ra->size =3D ra->ra_pages;". So it
looks like mmap uses this same value directly for how many pages to
read-around (with 4M ra_pages, this is 1024 pages), even if the faults
are random accesses. I think this also accounts for why mmap_miss is
so low too, since with the readaround windows that large, most faults
land on pages that are already in the page cache, and each of those
minor faults count as up to 16 hits, while each major fault only adds
one miss and happens a lot less frequently. With many processes
mapping the same file, I think it makes the problem worse (eg each
process has minor faults to map it to its page tables, but there was
only 1 major fault to load it into the cache).
(Adding the btrfs list to cc. Apologies for not doing this from the
beginning. The full thread is at
https://lore.kernel.org/linux-fsdevel/20261003001555.3498357-1-joannelkoong=
@gmail.com/).

Instead of having the mmap readaround size coupled 1:1 with ra_pages,
do you think it makes sense to compute it differently? Like either
having some sort of fixed cap (readaround never bigger than
VM_READAHEAD_PAGES) or dynamically adapting the window where it starts
small and grows if/when readaround folios get used and shrinking when
they don't? I don't think this would degrade sequential mmap access
(eg async readahead would ramp the window back up to ra_pages in a few
steps once the fault hits the PG_readahead marker) and I think it
could be beneficial in general too, as less pages need to get read in
speculatively that wouldn't be used, which would also lead to less
reclaim.

> Because what I'd expect to happen in cases under heavy memory pressure is
> that ra->mmap_miss would quickly grow over the limit (100) and we'd just
> stop doing mmap readahead for the files. If the read-around pages aren't
> getting used before being evicted, then the first natural thing would be =
to
> actually stop reading them in the first place :) The mmap_miss logic is
> actually rather dumb so I wouldn't be surprised if it doesn't work in you=
r
> case...

Do you think it'd be better to have mmap_miss count pages read vs
pages used instead of counting misses and hits seen at fault time? I
think the problem we're running into here at Meta which mmap_miss is
not detecting is that there's lots of wasted pages that never reach a
fault. It also seems to overcount hits, eg a single fault can subtract
mmap_miss by up to 16 if there are nearby cached pages (which might
have been cached by buffered reads, not mmap), even if those cached
pages never actually get touched. And the same cached page can be
counted as a hit several times, once for each process that minor
faults it in. Or maybe there's some simple way to get the info from
reclaim instead? Where if reclaim is evicting a readahead page that
was never accessed, that's counted as a miss? imo that seems a lot
more accurate as a signal though that also seems a lot more invasive,
like needing a new page flag.

As I understand it, both these improvements (detangling mmap
readaround size from ra_pages and improving mmap_miss heuristics)
would be complementary to this series rather than a replacement for
the per-folio reclaim fix. Does this match your view?

>
> The experiments you have conducted below indicate that if you effectively
> disable readahead you get more page faults & smaller IO requests (expecte=
d)
> but for your realistic loads under memory pressure is that really an
> overall performance loss?

I haven't measured end-to-end performance for that on production loads
but my suspicion is that losing read-around at the memcg limit
wouldn't affect random-access workloads like these much, while it
would for sequential readers.

Thanks,
Joanne

>
>                                                                 Honza

