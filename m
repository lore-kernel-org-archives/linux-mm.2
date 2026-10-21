Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFE96606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=f0Tuv9wq
Received: by kanga.kvack.org (Postfix)
	id 065C66B0789; Wed, 21 Oct 2026 16:05:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016C36B078C; Wed, 21 Oct 2026 16:05:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47326B078D; Wed, 21 Oct 2026 16:05:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA4706B0789
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:05:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6502C063F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:04:51 +0000 (UTC)
X-FDA: 85347711582.27.9319E67
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id E113F1A0010
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:04:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f0Tuv9wq;
	spf=pass (imf19.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792613089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j1fxjuCDrdT5GfjnmUrHWkbOyMdCUNguBpXdd1GdKyo=;
	b=wiir8VSFJv/IBw/saN4DaEu64+7nbwqFUz4S9Wvd575kjcS6dTiJ46fYeT3A05ecNzXYp4
	INUBvDV+I2NGTcrZJWXDPsZm+EkHdxUjqdFG5FKnBW0FILLIwedGX5Z4zWCFBHS7qhpPU4
	Tm9t3DTqz11qXI/RhhBtM7lXeq8Jv6w=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792613089;
	b=v65x0tNsun9G5CBaHfuVUCockg5ifSL+y/UG+o88WLrTqjzgQ72HtRi7fQEPPtnBI9ljy2
	jWzAOgiaTlh78bTaUVh90GCQfxzw3pwl7q9LudLeek4OLEINpBTaa3U1l+NZkmD14/n0l3
	ALXJb594QiM3DxoY0oXOdMPxF/2ZcvM=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f0Tuv9wq;
	spf=pass (imf19.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a1cef0439aso10806895e9.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 13:04:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792613088; cv=none;
        d=google.com; s=arc-20260327;
        b=dvs3p7KeI4RJOisHGx2QVUF2gkx5zSKsO0OqD3f/vhUODx1smTW8hfH8kk/7GY88Se
         kheVDcleNxng9Kfny0x+Rb/U2WAfAUqFvcRTAQhOLP3I5XcluR/JpHhbFRtuo6ByTQWV
         pNTI6UzKu8+YxohfLepJumkiO8Tu2OakspJWRa+IGThHxLSU/jgpTwhiMpQqMEufI6cs
         6k0LuFScnuUpR4XgrO6xzvrW8mZyz6+1Dg1lokO++PV15h/j1dxEVfDzJ3lF7SZfgY4f
         rbTELXt6J/8kE5+w61XDQOGwfv0Lo5QQ8VUgFHhBeZPwMgE4rs+lKcVH5BDVgo6qsAhN
         qLfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j1fxjuCDrdT5GfjnmUrHWkbOyMdCUNguBpXdd1GdKyo=;
        fh=/XH84YdYRwPtEoxmeb19p7BmY1SLLXoe7LxqSMbiJHE=;
        b=oTUn8B/n6Q+caN5Lp69ESX0dU7gBqLmU2GxOPafe5FPy8MmmEeGwBI0DuWc0SSEzgo
         U0MuZaLvtTz1Zvz6hwklD3T1kgtx5qdR9dwPaQxsLtY9SNLvIGB/EwweYtsndHz8PsvB
         QU+kgY2XXcDJjBbrq3DsZykO0lb64Ax2aCrA+DAf4EjxEt+22PCbWOQ4pNYWK7dFGHpx
         0QFsPUR90jFgsfCT3YfZLPJ6duxVL+nnfwb5oCohkZ7poZyh77wc3dIfVEvlWET+ggTF
         0L5tE2EYAU7Ri6hhyz3Z1Shv57/IY0sjFw1zI6FOD9ERdDBF7QS46rplQzAHzw9/FyT/
         V3ew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792613088; x=1793217888; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=j1fxjuCDrdT5GfjnmUrHWkbOyMdCUNguBpXdd1GdKyo=;
        b=f0Tuv9wqHTTjkusE5KFUcmf2cRlCPzmtoZcR1bfYKhwUd1bgFrcwrPOOecVbGP/S+d
         e7IKz+KizYnl/sqajSaBBEMrlcKR0eAW88uvplSaxgtV8Kk/MVaRndC7hj0T2fQdMXsQ
         5G2dMRuAN8+u6nDLYNPg7dmMWkL4eSXuASdzz/YM+hDThwg1GqqlLRPOwO0TLvWabk21
         2EofNyyrXMcemf/FL4yWlzBL9Vnq+qmgZIB1ODIMHgdiQQxVjMMa2MMOYeDK/QYpHsC/
         qX05yTfLFIbr0/mjcBLOEXQGToRjL9411iVAeucGm8tjia0XwyDcn4kI98PPkGfWZJom
         beqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792613088; x=1793217888;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j1fxjuCDrdT5GfjnmUrHWkbOyMdCUNguBpXdd1GdKyo=;
        b=JSIfl2WssROCOp2SBd+aTEmbd4XwN04v6Qypm/2q80rU98J3atG61AcmC4LSMplS51
         OfYjoT76STpw+GEJ6vRx9GZJiwFpSzzngESLKlqRkLO89OboYOMddu/YXvc1TSaOhMnl
         4h7If90evnkyrCBUokn81pHU8uKeZr0nhd8cvASwj3q/2R1oTkKztf1EIgpFLYXjHQxc
         T2LKNb3dSW6hHY54LcDgYK0yVoscAVkYzvfDdGjO4+7RGQxn+e3nulFyhTZ039xaViC7
         LUkcMLHlYday1hYZBlgRMxSaReOPwZUefmOUBIEotBnXmkCRrSDIpUicWnDeq35QYaEU
         bUZg==
X-Forwarded-Encrypted: i=1; AKwUvBxAa+13DmFL4PYshSclLj8a+Crq3FHBHNMnuTECp+ZeEbwN6EkZdOR4RC7MxNH8iIPHAacyindFZQ==@kvack.org
X-Gm-Message-State: AFq9FYKag0y0uZxTm+8XSzG8oMSDbiHu7PM/vJKoCe8InimS/UU3UKP+
	f2Q8W28+xAS3RRAGw43dZ089XyVlDapSklKYRNdxvecwg0P2yckizCRqCsraOpYs79j79MwTBqR
	5vAc65TpEVooKXX68NJ0fi0w+zTbXc9s=
X-Gm-Gg: AYBFou2De1Xev+BMj+35u9UXRT7yEs/PkkKlojBGGQMfgOMZ6iQhgtY3CPTuW33IBbF
	z+jRU4+qbDgZG7Nl7n68BRQGsQ/yH/bUVj/2bMMY7CjE+Zm96vmkBbu3D9YJApoPH7MU+AL8eFQ
	RzlX7nssazdiRj9fVCfW1iMmuu5QySZfklPVwFmUfFsGIoAY6pX8x/EIuSX2b4QrUNWlY0yu2T0
	eCoh1HiiwFLoo+JZBN4JyZ4M1f08P3Vw1ZdsBbaU/D3c25QCg+BFm/c8SPlM1rqVr7Y4Do0lpXx
	UYjUJ8C/84RKLDSWl1GZXQIJg1VtAdHs9MvrM/bi9V6p6bihvrGW/xADkGJ3bQ8TTZqp9I8uiX4
	t8TsZT9bAq8QbfY0R5U4voV8Iyq3563pEWs54tzt91DLP1qoJcM6+HZZURdz/a7RHKw9wYu/Or6
	1pstgKtHE4NMhKQIQTMDnrAFpPvRJ6mCjEtg==
X-Received: by 2002:a05:600c:a11b:b0:4a2:5db:1f35 with SMTP id
 5b1f17b1804b1-4a205db30famr3506195e9.11.1792613088329; Wed, 21 Oct 2026
 13:04:48 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261020200730.250189-1-joannelkoong@gmail.com>
 <atfrhsr6bft4t7SI@linux.dev> <atjhiAxEyoP48e0X@linux.dev>
In-Reply-To: <atjhiAxEyoP48e0X@linux.dev>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 21 Oct 2026 13:04:36 -0700
X-Gm-Features: AclHuK-XJg9p2pKQVLaqzPUQYnGGSxOsrQ6EL7MNtlukpZPxKO3UA7_Kxk1IV7I
Message-ID: <CAJnrk1Z=ZqTvfO_VYjG=KnHRvwmhNBfYfxpiZiKWPdMYnsA2qg@mail.gmail.com>
Subject: Re: [PATCH v1] memcg: fix cacheline contention between lruvec stat
 updates and LRU lists
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E113F1A0010
X-Stat-Signature: 6hknwajj7cfaoq8ktzqq6cpxiij3kahr
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792613089-87913
X-HE-Meta: U2FsdGVkX1+vurpjxeUMPljEm4wLfvMsrBESprcOa6mkRc+3812BbA/as/IO0I+sMHe1ioKIKzcQLpqzxuFXDLrw3cl+77zkkkUgfoCYncwAPTPTKgseWhczSFaagxfm6O9mcTvQPV5QJNWISf2Wg9ndZPbNscidOcQPgYkDjNqZZZd92E/0ScdxNLDs/j+1B5aol3qLO78/7+t6gBALni7HTbIxUeXJxRsYrhGQIYm/u7UQqurp4EejrUu/+qUiDqRpTftGg3SWo+CVqstbDCXOVr8jfbOP7nGRmV2fe5+nZERq7OksLCCS/wOXIdCOMOe+tA8NsSYysNUVsRILPgT6vZuVOY8QYIKs16+07pqJeMAmw6zo1UO3TcbEulIe6UPbNbQeb0uENVhwK1Mj5khe7UJblY2ESBbWzUTGSsWy5kHJiMoLiYoqKa76zIXubzYZ5HfpifZdZ86amBVUgM+h2LaeXh5L/MzBvFpHBekwXDFZyIYqYilgIIBHnmnF5XoGFk5dDoipTRN6VOsqE/1ZbmoOpHS555/iKWRc+W6Hzc0hbMeMmhsJJCzwx1yy/CkVScOna387soN83YYGfQZoS+KPQU/PaRtLy+vl91Oi4XK23MPWUmDxDTnWBTQMEzVnluAA9ujRGDquCRIP8PRJpVgOI947dT9dPGNM+7UOzYJLzKccHpIhGMmsLPrB92+On8oaz4ahCjJtlzN/Ul2cH7ZGK2/WzdEcpUVzAxC9/zumvYR6qbM3I5oQx6L/DwQAI7BAuwf5f9iIrC5ORXc3lbaAOo983wjMsXelvZIH+VsfaJ0AVQrd8HqdNah92zUA8ft8KbveRI8sYBQQzCIaWd9J8P8PhXVlo2AyLivfx8HOOxitK03wNJfYMzsKrRNYGCEeZPdUD4tkzWV8J8YdDC/RKGNz3tfhGzVamyLgWNbWdWMklD+2lcP2yrY/UTKuiEZKX5gVc06ZCOY
 UOlL1FWd
 UC3v9c4l86IrBOvkHNCSSTOKGGSaY8sQGztHeOh0Mk8xo9fa2R6sQnLwFPGk5yOuOO2YsewjOWC+ycOv+ZRHcoK2f84qJeHCES/pSWhJ6h7RkFvRcfPzOJaGFOBpG+TDK2prBIFYopO1K87UTTAQrP7ak16RuR/g3EM4ZYn//lQaUIf91lmpCBR2SwnO1qFa0HkBT1/V2kwAec85O+t4GTgWw2scWgBZh4It2m8t0lpYyRlyBc2m1q1rHi36m8qi0JWeQHWLh9oz9slF3U94BHT+fFQvjrA8UDm3oAgOVLaRsapnKc+X2cZl3Rjfc7vUJ9IVkFzgtVxb51G7oV4TYYHjhd8hJDSCVLgQ0D9+hWODFllXK3kPqDNVmDgjGY04T5Out9kVTE/HmFUY6z098C1URVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 9:12=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Tue, Oct 20, 2026 at 03:35:59PM -0700, Shakeel Butt wrote:
> > On Tue, Oct 20, 2026 at 01:07:30PM -0700, Joanne Koong wrote:
> > > Every memcg lruvec (per-node) stat update reads the memcg and
> > > lruvec_stats_percpu pointers in the first 64 bytes of struct
> > > mem_cgroup_per_node, and the ones that go through mod_lruvec_state()
> > > (such as lruvec_stat_mod_folio()) also read lruvec->pgdat. These upda=
tes
> > > are extremely frequent (eg these updates happen several times for eve=
ry
> > > page that's faulted in, freed, dirtied, or written back).
> > >
> > > The memcg_pn_read_mostly cacheline group keeps those read-mostly fiel=
ds
> > > on a different cacheline from the lruvec, but on CPUs that do spatial
> > > prefetching [1] (which is most Intel CPUs / modern CPUs), cachelines =
are
> > > fetched in 128-byte aligned pairs. Depending on where struct
> > > mem_cgroup_per_node lands in its slab, that cacheline can be paired w=
ith
> > > the cacheline holding the LRU list heads, and the lruvec->pgdat
> > > cacheline with the one holding lru_lock.
> > >
> > > When this happens, every stat update also pulls in a copy of the LRU
> > > list heads and lru_lock cachelines, which are written to constantly b=
y
> > > other CPUs under the lru_lock. The stat update has to fetch them from
> > > another CPU, which is unnecessary overhead since the stat update does=
n't
> > > use the LRU list heads or lru_lock at all. But even worse, the lru_lo=
ck
> > > holder then has to invalidate those copies and wait for the
> > > acknowledgements to come back before it can do its next write, which
> > > makes the lru_lock critical section longer for everyone waiting on th=
e
> > > lock.
> >
> > Can you please reproduce on a non-intel machine?

I ran this on an arm64 machine but the results don't reproduce, so
this looks specific to intel's prefetcher.

> >
> > Second, can you try the following patch instead of your on the intel
> > machine?
>
> I see there is also removal of access of lruvec->pgdat from stats update
> function. Let's break up the patch into two. One will remove lruvec->pgda=
t
> access and the other one rearrange the fields in mem_cgroup_per_node (I p=
refer
> rearraging than removing the lruvec stat pointer).
>

Sounds good, I'll go the layout rearranging route then. I verified on
the Intel machine that rearranging + the pgdat change gives the same
results as this v1. Do you want me to include your rearrange patch in
v2 (with your authorship and signed-off-by) or do you prefer to post
it yourself and I'll send the pgdat change on top?

Thanks,
Joanne

