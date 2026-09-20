Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A96AC982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 06:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 523706B008C; Sun, 20 Sep 2026 02:21:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4196B0092; Sun, 20 Sep 2026 02:21:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EA726B0093; Sun, 20 Sep 2026 02:21:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 179136B008C
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:21:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D31B1A03CD
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 06:21:53 +0000 (UTC)
X-FDA: 85233144906.19.29D8249
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6A10340002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 06:21:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b="cn61/mpw";
	spf=pass (imf12.hostedemail.com: domain of mingyu.he@shopee.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789885311;
	b=y0mQhbzXlRWU6Lb48CVxwuvusSdV7nYd8RnxmNDPoq89qSIXq7uR8rTYXDaDq7CFlnJ+o5
	79r1kuXPb9KcGfvZCWcT8SQa89l2vYX/QVTPIFuToiNS4VHFMYf1Hn9uj0SWdptbCHFbah
	VRa9nh4WNv48xG5UmzpsKWQmAMe6kPg=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b="cn61/mpw";
	spf=pass (imf12.hostedemail.com: domain of mingyu.he@shopee.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789885311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vUj9SN1p4os49KWD5n51HQql/MUfuSyaRMBvM6ntZs0=;
	b=j3EDOzz2iy0y0hZjQOwHs66nL2xRt5O6gOxXiZuI0/+5ei3sRu1Am5UlfMvgR8pRPS4Ies
	Iamrc2P5B7FKzM/cI+k9ufxwe+Zi/a8B3ejP7Pfg7nCd1hrJ6LhzsbrpFEJYWxPeS58Hk7
	IMIndVf0XtHh2oUIEW/zcnhLPQGrelo=
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396cccbba92so1830627a91.0
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 23:21:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789885310; cv=none;
        d=google.com; s=arc-20260327;
        b=WVxTEI74Gbc+IPpvJP1tQ18AaHcfiMtGznKmc88L9dQhesVgR8fjRb/YQatrS8l/8F
         TS/3CrVY7COWQkhNVB4OK6azAYpgvYO9XHAvntDrSoCDcPsC7P3AyRHztxv7xIoPFYmE
         60gN+RtcXOUBqPjvFYECya0btAFSs2dSlAJ72VCEhxJPB4qA3UNu78GTkWWDDtKip+0B
         dWTyCld7anPkeRIArx0T1bl+Pud3FbGdxvTwXd0YOddO90G5/8Bm8gNJZjh8DisCFjjG
         xdsvez2Hk6vuEg3o2oUpMdKKiUoDEUCDgTSHIDkKbR/ZQ+7Ka7ltGUjh6fD82+oIBANg
         AhPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vUj9SN1p4os49KWD5n51HQql/MUfuSyaRMBvM6ntZs0=;
        fh=wlrZR9b/BEuLL7RmPDjJMGXH07egkIGh+sCcwMjQTIM=;
        b=myKVB3Lpzpuk3Y5Fb9pvznmVFf/i3f3P4maPxuCIL9xlkGOnKYcjmXtfh2anl87n3Z
         jJdfCbn7QEkvVCEAaDDNfj1FF4AOHY53VqtKp/E5kOVCnwLxx9CMF7OFbsBnt5hWOhLL
         FSRUMrEZVe76Sf2prF9aa3ZQVWJuXiEhGfj3GuREH9J2nEecpNLjSJWtn06rMB4buuLv
         Bz9tcPtJOKue8ZmbN7TC+0E4yptiAYAe+/hJK0HCXEcxIUnrk7zMNSr/00jQ0jD/cgUt
         2JMei43TAcMsTasYt9KmQj5ZJBca8CfOSUV1FKV5VLVx1fZ3xwY3eZwc3xLTZglzJU6W
         6tag==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1789885310; x=1790490110; darn=kvack.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vUj9SN1p4os49KWD5n51HQql/MUfuSyaRMBvM6ntZs0=;
        b=cn61/mpwum42cuLg8j901kCV53w2ZnVKkMqBNdcyQswCrAOMB02ciI2sI7PDT/wut5
         HNFVa3cUNbDPvPDmy8cQuqF4pZNfdTsj5bT35a6nNwM96A22wbW4TfYoHHNkM+cYwyry
         CXRQJHWebh5ozlgqGry4Y6LbXUnRj0c9NMwYH8MmrFtnOm88yuw1f65sFowbxcZhpOm3
         hjndlKZGDnhOu4CjvCeBohDZd3NX/sU+bdGbz7Iisn7pRdtCX1GVnh3HNGQ5w5l9Y6/z
         toFDJINrCvDpU7ADprdSML8wvRQAognlmgdBf0FvqxjyHWmqmLN4mMEnSYfsh5jGBb5l
         sOjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789885310; x=1790490110;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vUj9SN1p4os49KWD5n51HQql/MUfuSyaRMBvM6ntZs0=;
        b=rxV42UY50asFmXEaEfYKhUPQIE/dQRjThlJhkWtF9rBsk1qg2gKYBe53nvKDvM6pti
         lcLDsOSh4fi8ScEFRBavtjMXGQbEOfK0ND6jS2NkeWlA3IYaLF17wxj58IEYraSprl4O
         bOcmO0Nh9F1875Fg7Zr2P0GL9tVYttwsiy/2SymJSNwzQOyziiDCF+i8B7Igu/3sAXGa
         yImvYI+HRoqPGP1cwJDOR9yrdVYtwQ6uM21paqfgq/ibaiRRK7O3Z0h8NA5Rxl5ZzfLo
         wcwCQhJWW+3BfbvFw1h+wSey9VSiKFGnSlD9FG3VJ/fOjMHcwcJ9N4mJXea+oWyz1wds
         uTAw==
X-Forwarded-Encrypted: i=1; AKwUvByTVZovi+8opTIfxNzb3wF0LPLWYGuSPnBi4ArzHphNCrTPWCGqlMuYqSwYwNAN55QYtP8C0p1RZw==@kvack.org
X-Gm-Message-State: AFuF++mU4T+q5zLqhHfYXmpjXf60eikVyUw1hl0am1r2LHF3m7y42lAU
	kb2XWiS16cMkyp9ayq8Gjdditg6rhbofcLWF8imzFYF4unCbyK7s372MlQxR1Py/PKP5iH+3jo+
	ZW9fKStfHq0/iUnfKAeShqWQ8Ccv2oVJlAa+WW5708w==
X-Gm-Gg: AYBFou2U459pwYN+fdw0o/u04pAy5vhM/c9k2dEuXrS8u1yEhhNK2EnnIynQ4+rle0+
	/9u9GOHhiiKz/yhC4PNKaKnkXzAy41QbfEKUB4PPPnQD60QMa4DWy33nRZfSB9rMXjw98/9w16N
	oDOj8Wax16p9fll7smyYpYDXHbLhccvLHwaDxY2G31u1AnF1LKxSt5iaU6LdqpZPOlVrWDE6J/p
	vA21s4WAODksdq0G8ne1IpSAcikTdHUPpmKZQePA2aO891XIAJh7QvkkALYs/106ljUvnrynVan
	chcGtyfR0dbyfOFlSlBN0Knkjy3Uwp/ecxYsStSwHNZZsgNnwtvNTLpM
X-Received: by 2002:a17:90a:d00e:b0:39d:fd82:de0c with SMTP id
 98e67ed59e1d1-39e54aeed0emr11395017a91.2.1789885309954; Sat, 19 Sep 2026
 23:21:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260911032905.63683-1-mingyu.he@shopee.com>
In-Reply-To: <20260911032905.63683-1-mingyu.he@shopee.com>
From: Mingyu He <mingyu.he@shopee.com>
Date: Sun, 20 Sep 2026 14:21:38 +0800
X-Gm-Features: AcwNN1VtVso6olA7GUMJNC8_eiIpJqx8f6UVT_hoxF0RUJ-CIsHHLisDmFi6utE
Message-ID: <CAAoBcuQ5xkhhX_dP4eE4GRngs0quOjgNpDD6ccPxG3oRCjMvUg@mail.gmail.com>
Subject: Re: [PATCH] memcg: keep propagating stats updates to ancestors
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6A10340002
X-Stat-Signature: 84ptmfda89xgkjbps1ce7qmd3fg5b9pk
X-HE-Tag: 1789885311-185826
X-HE-Meta: U2FsdGVkX18UQJ5EEA64DOFKtsfQIY79tVDUVYyLuhRkjPGH9b+wKYdo8hXy55pN/4WIz18JPJhyEmFQkDtu27uM1Q1Boco2x/B4Jp5YcAmsHeIXBABjppuXue24dTUG0UF8IWVfe0YjogLOuPqQU/+Ja6qqikvbT1yN8ToUZMoeKFYJ7dTghDWZYyX7cJe6c5yrW1VJfFXf35BzRKXBlCXtZ7me5RyBv6bRJHBsE5s/KkW4hICh3x6Agftm4e+ibIk9HRVQfwP704NvKKtx1h6W/29itjf5zXlejOlGL5bYVSoPAj8t+94/2elqB7sJn+sxZD5vG/z0uSXIcnKY99ZV/qXDvYLMX5yMgJccpJ235IhupBnvu80NNI55XNwNHvGVhsuU6s/FeIkqubJaSyyjYFct7ahzZyz2IOhfblTyqVsqww1oGB6hVFnKS9j2kMzUoIjhYutVMGkgePagnCf8lXlHHiRim1lWWQpmMNusvSbCj+rphOI/3F8V0LIuBbywnYdZxP+9LfEZUyhVTgjl0OmHv7mbyJGngh84OCl/fSLclvqsoNG7Tc+EpV7lWxaY6YgIz9BXOFEwhX1b+qeRYDwRbaXZ2dwM6DrcP/4pr2E7LRszG3+mLht3brc0nfKYjlPCfffDO/e/j5LbdykUtqtnjrVi7uZmolD2nVjrHUqEBhULykvp52kAEOW1dAVGUq0n6EDajrDYZ+bRDiVy8c3Mv8nLbTsuwJ7KPv3KYujvD07UmH2MfhHSMSSDKeeh7RnOk8pyJZzPkuEIZb2RD2JAJ1jgRZpcLZjNro0knNPm6uh3liFjDQwsX3GGwhjrmeWutxoJqNK98dLvNKGBZ8a4hYWwA3gMndyvbuE5HV2iP6JpPs8tFi0LR5Pvln8CpDxHY38eYzi3ClJ4g39++r4qrgW3cjyN3Z8KqsR6aeMYrZ4kCChATiUJse/XdQXmos5Y3AN5hnsBH0a
 tmcDA8z7
 N4GTLPZBa8wSVrAC9shMSzsKQzfWFpOpzNDwxJin85DEDdPmKZfW2rRcJkxgFYWEHyO4zBw6sRYPSE644O7I1sElzd+4TS31kNaZX2lViz81ET0gNuMnyTXDkzyvKmaCblGP4u0vi1qNxgpqTj1DMWk67ngOIYma62HRNeAxM3SDxZZLJ7djpj1uFazOzX+sLtD6LNzWQhwwgLb1LvEFKvOezpQX+lb+HeAxLw+2Rp+BgL0F++e/E/6hfgM3CR2bGVPJGVCov/1U5qpjj/ZFJPmF8e5XSDiJZRkvziSlGHX8xK+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Gentle ping for this patch.

Thanks,
Runli


On Fri, Sep 11, 2026 at 11:29=E2=80=AFAM Runli <mingyu.he@shopee.com> wrote=
:
>
> memcg_rstat_updated() stops walking the ancestors when a memcg exceeds
> the flush threshold. A concurrent flush can leave an ancestor below the
> threshold, so the early exit prevents it from receiving further updates.
>
> Consider root and leaf on a 4-CPU system, with a threshold of 256.
> CPU 0 is flushing another CPU's stats after CPU 1's stats have already
> been flushed. The counts below are shared stats_updates counters:
>
>   CPU 0 (root flush)                CPU 1 (leaf updates)
>   ------------------               --------------------
>   clear leaf->stats_updates
>                                    add 64 to leaf and root
>   clear root->stats_updates
>   finish flush
>                                    leaf =3D 64, root =3D 0
>                                    4 more batches of 64:
>                                      leaf =3D 320, root =3D 256
>                                    next update:
>                                      leaf > threshold
>                                      break; root is not updated
>
> Root remains at the threshold, which is insufficient to trigger a flush,
> while further leaf updates keep taking the early exit. The periodic
> forced flush restores progress, but until then the root's aggregated
> statistics can fall far behind. For example, page cache grows at rate of
> 1 GiB/s, a two-second wait can leave the reported usage about 2 GiB below
> the actual usage.
>
> Skip only the flushable node and continue walking its ancestors, so each
> ancestor can accumulate updates until it exceeds the flush threshold.
>
> Fixes: 60cada258dfe ("memcg: optimize memcg_rstat_updated")
> Signed-off-by: Runli <mingyu.he@shopee.com>
> ---
> Testing:
> Based on commit 893e11787f78, with and without this patch,
>   using 32 concurrent instances of:
>   netperf -H 127.0.0.1 -p 12875 -t TCP_STREAM -l 60 \
>           -T <client_cpu>,<server_cpu> -P 0 -v 0 -f m -- -m 1024
>
> Both netperf and netserver ran in the same leaf memcg, directly below
> root (root -> leaf), with memory bound to NUMA node 0.
> Each kernel was tested for five 60-second runs after a 10-second warmup.
>
> Median aggregate throughput decreased from 107.26 to 105.23 Gbit/s
> (1.9%) with this change.
>
> I think fixing the correctness issue is worth the roughly 2% throughput
> cost.
>
>  mm/memcontrol.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1271d390b617..4600d9c9244e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -729,12 +729,11 @@ static inline void memcg_rstat_updated(struct mem_c=
group *memcg, long val,
>         for (; statc_pcpu; statc_pcpu =3D statc->parent_pcpu) {
>                 statc =3D this_cpu_ptr(statc_pcpu);
>                 /*
> -                * If @memcg is already flushable then all its ancestors =
are
> -                * flushable as well and also there is no need to increas=
e
> -                * stats_updates.
> +                * A concurrent flush may have reset an ancestor's counte=
r.
> +                * Skip this node if flushable, but keep walking the ance=
stors.
>                  */
>                 if (memcg_vmstats_needs_flush(statc->vmstats))
> -                       break;
> +                       continue;
>
>                 stats_updates =3D this_cpu_add_return(statc_pcpu->stats_u=
pdates,
>                                                     abs(val));
> --
> 2.43.0

