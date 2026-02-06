Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEF72EE6B68
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 22:47:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D1A16B0089; Fri,  6 Feb 2026 17:47:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0808C6B0092; Fri,  6 Feb 2026 17:47:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECDE36B0093; Fri,  6 Feb 2026 17:47:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DB48F6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:47:52 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64A7DC029C
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 22:47:52 +0000 (UTC)
X-FDA: 84415520784.13.80F6E5F
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf01.hostedemail.com (Postfix) with ESMTP id 65DD240004
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 22:47:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EjHquAT5;
	spf=pass (imf01.hostedemail.com: domain of yuanchu@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=yuanchu@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770418070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+xzzbafv7IMwH2ifuNO4060POJWB+v1zgMFdCY/APJk=;
	b=FYFVhB/Ie//QtwRS6YmAJ4++eCPMQlXd/1UxrS4l7fP16eF9MNbBjm11JFfm6pzZbtWYn/
	U9nNwNnqPRdeV4cs6ioMgZ+VFPK5RA7XnvFY08R/ouW3FMXi7GJYK8zgW5783WyZ4UzyF5
	lt8gk7R+GJbhX9ohI9zjWtMdQwZzDgo=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EjHquAT5;
	spf=pass (imf01.hostedemail.com: domain of yuanchu@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=yuanchu@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770418070; a=rsa-sha256;
	cv=pass;
	b=XUavH51sGUAKbFYdQ7Cc2HJFMBzNYwDlicIfzsKwzIzvWHdZvYW74EGxJEZROTiIR/1jeL
	wnFC86JbWyy+OVWx+2+g+VfBUdE7xbDbZdV/BM4uMOaqL1o5nupsEJ0pgluDK9/mdMjNtG
	LB6gsG/sSHXYQ93JYYSkj3DBJ7qmZzU=
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1270fc2bdf2so607c88.0
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 14:47:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770418069; cv=none;
        d=google.com; s=arc-20240605;
        b=aWFXQqH28VO8A6lcwGPm6CpzgIJtz/YTwDkA1J+9ZLCqBUfAhj9adJEbU4f03+ejbY
         +9oVb5ZQGvT+WJDG+I1mwio6C7GftfCuiIKG38mX1tIV+ZSeae5L+ceZPSNk0WKrZeKO
         HidQzhrGGiIDsGOyXq5OynQz/itaJYBvecZvNE4Nls5aTd6wG+pri4pLxFgQmONB3QDf
         N+3v4uuS2VLNOkC/3CGBNZ9dNdX2JoIf6b8bwb+9WnTBl5x3QZf8aaUp/APkgJbtxaaR
         DWBo/6DC+dwuTclLXgNpaHgyh4GNYgcJv6TI4Tbf15UjDuLbnU8CnSYmM/UmtRSceMQ6
         wRdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+xzzbafv7IMwH2ifuNO4060POJWB+v1zgMFdCY/APJk=;
        fh=TsH1FIzxTuznNQWAgNlKPychlGG4vBOCt8yGMvqAAZ8=;
        b=EXAd1FQRQgmSKKblCD8FPly/JQk2+TIkdNnttoC/5jEFoFSgy94vxXoVKFgjiJZBWE
         U1iAOhIghodT4LvaRtKa2PTstrGuYjqWD6zIIUFK6oZRcPVeMfef5yy+NaaF4u9vviGu
         wr3GsgF6DucKXUIPgx+Uve7StJCe9DEZAH4eRRAwHo24Gul16YUcZNgDEzoKIZ2P6gAY
         Q4DOp3nymlBXIz9sndZShPOeMDcNpb/y3QWcp7kgdJUa90vFiP11qbquaTunE+tjtPCX
         mARxBpNAB5yxLcV3Kp00sSzojs292QCg/B9zn0Jgc04L0W4ZUyU1KxOKrXNfeShEu+lA
         iDkg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770418069; x=1771022869; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+xzzbafv7IMwH2ifuNO4060POJWB+v1zgMFdCY/APJk=;
        b=EjHquAT5e0rCKZZpRfBr2X3edcre+NEJj18SHJJGlDsy+e0Hp37Vqo5XZ7c7Sh7NXz
         ZMf+HjhRx+u5CKd0BeOmS7/pwW/RcQAsykyOkB1LRj5+X3FZ8FcCOoSfgDenP+Xtxj5q
         JjYM2iZUFVuakEMQfDlK1rRu2RCWISez3hrD+W/VMVl+pKpNfDQ+o6rdO5+c+b2Hxuj0
         vDpgaLpyca09/nMx84cI1cODYgqc2SqmWJ1aRmCWrkLdciDy4U8V3C+MAvsw5UFS4tb+
         VUjJz5m89k+10af2vXEZW1dmw3l+HVOjwp0QKNgWRIjC+n7L3JaIRK0llr0NdhKbOO3U
         wrsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770418069; x=1771022869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+xzzbafv7IMwH2ifuNO4060POJWB+v1zgMFdCY/APJk=;
        b=Q7CF9kyo7z3X9I+ukpcBpV5cBDHcG3bl21suJ38rMf4b4HbBf9bwlRZnEXr400ghR5
         /zz7Z9qT+Q1vx2nApN/njUj9Uvj9YGWrzhXmJj/y+0CmOC06Wu/3fHfkmRSJN7di1B3N
         +qBQONTedY9x8Jq8szvnBc9g6dOH+F9qkiAxW5M15GIbtho6nxZTs6eMLoJIUhz2Jz79
         gL51uwcQ6wdQ6J2PTz94tWevaU7d+Zf2OxmARV8Mefm7rhBK6POdRxo9LfZd6sjcVY2r
         gZ9eVeUgoR1r5SY31BnGylZ3CAkwhfp5j2jttwPI+wjcvsItU2KUdtWiApTdw0xCEAzN
         1eJg==
X-Forwarded-Encrypted: i=1; AJvYcCX7tz2GvAtMBh7iFdR8MppCyrBr5Wf7JnW54Bf5zJPnZ/5O2RG1ECJXK856MrrlG9+tnkHtEzR+Nw==@kvack.org
X-Gm-Message-State: AOJu0YypphG4p30aS+flNLZzhwM56G6Qu0qaW76TUY0ESJZqNPo54f6R
	gP8DAV44xG06d1Ia9tmi+EZmmz8a/OCYH6iKJVJhAZSzRM/ZD+5sbs14+fCN2RdqWnQ9Aa0XXRP
	lOJWiQeL734qi5j1DWDbIppFriRQZVg92l10BFebl
X-Gm-Gg: AZuq6aIqY//xXLKuzy2dKsP35dEEUqmTpIov83HWYzp5QYgn647w7jC6B9eyX3pSa0/
	xnW/2Ktd4OHkX5Wtl3Ks3DUlF4QtujoGJaTT6xbHuzziO4d7pd01xkVrKHflAJCZhhM3mehd6N4
	UOpHEgK5POJAImiK0tP6GqJwyTWqH9LJAuedVUGGbwr3SqVRX6p0EJSn4FXc8nSrppJWIi7dO8s
	/Shz3R0Kln4Xn2Iqt8PL7EcqPGgsaEltKpdbGJy4hzAyw+oSxvfZUK1y0vJ7HGmKeAlgoMdC93J
	4YlOOawOk5F997W5N+TNiOwaOA==
X-Received: by 2002:a05:7022:609:b0:11a:b4dc:7773 with SMTP id
 a92af1059eb24-1270eb77341mr35981c88.12.1770418068642; Fri, 06 Feb 2026
 14:47:48 -0800 (PST)
MIME-Version: 1.0
References: <20260120134256.2271710-1-chenridong@huaweicloud.com> <20260120134256.2271710-2-chenridong@huaweicloud.com>
In-Reply-To: <20260120134256.2271710-2-chenridong@huaweicloud.com>
From: Yuanchu Xie <yuanchu@google.com>
Date: Fri, 6 Feb 2026 16:47:31 -0600
X-Gm-Features: AZwV_Qj0gV48Ve3tLxFlyOkgNoDi9Hpin9IqAYTK628v4lALi6UuflSgTpYRMQQ
Message-ID: <CAJj2-QEvrgQ+R-nc3LZ-cBfnzjakxfSgmNbqDa-RFBVOpdVaAQ@mail.gmail.com>
Subject: Re: [RFC PATCH -next 1/7] vmscan: add memcg heat level for reclaim
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, weixugc@google.com, 
	david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	corbet@lwn.net, skhan@linuxfoundation.org, hannes@cmpxchg.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	zhengqi.arch@bytedance.com, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lujialin4@huawei.com, 
	ryncsn@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 65DD240004
X-Stat-Signature: sy7eouxnxprb73w1ktujokmtisbg8xbd
X-Rspam-User: 
X-HE-Tag: 1770418070-580786
X-HE-Meta: U2FsdGVkX18vR5EpnrIvujqeV+gfyiuOla/qz8vov0eB6F1dnfmVPgE63shfTfwDTuqMTBdY2GVvW9vPro1hN5wuLvnZiIjDd+Y2vKDXN2hvSiaCW9LIGceOb3LtqmFJ/coBh49Ocqwm3sYEU5f5lTRv+VL8IvCbTl29jJTowpc7EOfxjtief1PNvUTC7vN15yV9jhu2UVYTxoG5m87YdTIy4BT16BFwSdNvmlJaFbqcyNj4mMdkj8hEixcNfSgKgnEpsT0Cy2ZppDHgojEpsFnG7CkhqhSrfBG8yIkmRQo8NSmtBFHPTutxItXD8K/3F2L1Ne1uEEN2qtHiWh+TO3xmVC4/pgXDdV9aOfK+fnStuRnNRlHDq2uxlLA1rMcdi/VGuEiM/4X16hfAErkwBc2nCc73ypdm0Ogwg1oVmuZ3N74+NpBNgkq20XNKSKYBfiGIaYU+VW51Qcno28VNukCOPpWbggZced37Ll2IhKqL71Fuyj6z0CNfbKx/kYVVhW2eWSUe58BlIYgsvczQiVn8MIvYrjf6F+d2LG8HoDyJZVLQtbVCWPVWj1gDwPu8gA7F+PHcKiD/RmJDx20Ik2t0F2feeoDwVnVOKAoFwkYTn7eBqqMFR3LOnYypMDzVn1qMJvJhcuwVVHF1ZthedOVBsLNlEuP8qWHsBDxytPLWOsaFQqar+TD4JO9R9VXn2k8j1ysOS3Tn9sLrrXsLIaRHELCEtI39HbCO0YvZOAvO79lzRTFM5KZ4mslcLsgktz4tpg23/ULcPt56WxykReGWeFJgCWX4fNX4FqXN/i4glCar91jfwIrpVrErQ2vk7UCIolZHAlsgHIbki1zD8uYI85wluDJO76WA4iyAg4+GcwszznDvN+2/n+w5mO2gCaVsQwJ9qtlYlvUWL0gXMFtd1TbeomEooEngZ8yzOsiHvIWRa3eVapj3iuoWVqi/eRYQz1CDb4b9F131bAw
 I0iNopOr
 g5AH72S5IrBRZYc87G/z7HmWqn8zdIF6CiWx8dzeuuW1mqsuoA4mPWmK/o6Qv4vxuyZ2kOYlJixRSaRw4UnzL9pxxjiX0S79iK9QTLqR8pVWHbyreAQHF5GWeDmpG4w/7OYhFWBif5qho8qjGzt+kFrKMBjr8F6FEsgHaJYNrrT27o4QJsYNTUaJzQLEhAQLzG4S7r69fhMifwZHyiOQPvZK8tDjTN+2BgvKvs9DXmSCk0rMWj85FOvJmnnzaUCH7gD6jsJHuye6ODEp2eLsH3Ocl2aGsZ7lvuMe09mSLuWrGKnoX4Lh2TXzfVm8fsJ3USzJTD8Z0rTYjQnxcie3Ve8MjopJV/EY2FUYSfVg98SBi/R0MaUtlLvJ3ULCcYIvbvQD2ap8S4LoUwqI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ridong,

Thanks for working to reconcile the gaps between the LRU implementations.

On Tue, Jan 20, 2026 at 7:57=E2=80=AFAM Chen Ridong <chenridong@huaweicloud=
.com> wrote:
>
> From: Chen Ridong <chenridong@huawei.com>
>
> The memcg LRU was originally introduced to improve scalability during
> global reclaim. However, it is complex and only works with gen lru
> global reclaim. Moreover, its implementation complexity has led to
> performance regressions when handling a large number of memory cgroups [1=
].
>
> This patch introduces a per-memcg heat level for reclaim, aiming to unify
> gen lru and traditional LRU global reclaim. The core idea is to track
> per-node per-memcg reclaim state, including heat, last_decay, and
> last_refault. The last_refault records the total reclaimed data from the
> previous memcg reclaim. The last_decay is a time-based parameter; the hea=
t
> level decays over time if the memcg is not reclaimed again. Both last_dec=
ay
> and last_refault are used to calculate the current heat level when reclai=
m
> starts.
>
> Three reclaim heat levels are defined: cold, warm, and hot. Cold memcgs a=
re
> reclaimed first; only if cold memcgs cannot reclaim enough pages, warm
> memcgs become eligible for reclaim. Hot memcgs are reclaimed last.
>
> While this design can be applied to all memcg reclaim scenarios, this pat=
ch
> is conservative and only introduces heat levels for traditional LRU globa=
l
> reclaim. Subsequent patches will replace the memcg LRU with
> heat-level-based reclaim.
>
> Based on tests provided by YU Zhao, traditional LRU global reclaim shows
> significant performance improvement with heat-level reclaim enabled.
>
> The results below are from a 2-hour run of the test [2].
>
> Throughput (number of requests)         before     after        Change
> Total                                   1734169    2353717      +35%
>
> Tail latency (number of requests)       before     after        Change
> [128s, inf)                             1231       1057         -14%
> [64s, 128s)                             586        444          -24%
> [32s, 64s)                              1658       1061         -36%
> [16s, 32s)                              4611       2863         -38%

Do you have any numbers comparing heat-based reclaim to memcg LRU?  I
know Johannes suggested removing memcg LRU, and what you have here
applies to more reclaim scenarios.

>
> [1] https://lore.kernel.org/r/20251126171513.GC135004@cmpxchg.org
> [2] https://lore.kernel.org/all/20221220214923.1229538-1-yuzhao@google.co=
m/
>
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> ---
>  include/linux/memcontrol.h |   7 ++
>  mm/memcontrol.c            |   3 +
>  mm/vmscan.c                | 227 +++++++++++++++++++++++++++++--------
>  3 files changed, 192 insertions(+), 45 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index af352cabedba..b293caf70034 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -76,6 +76,12 @@ struct memcg_vmstats;
>  struct lruvec_stats_percpu;
>  struct lruvec_stats;
>
> +struct memcg_reclaim_state {
> +       atomic_long_t heat;
> +       unsigned long last_decay;
> +       atomic_long_t last_refault;
> +};
> +
>  struct mem_cgroup_reclaim_iter {
>         struct mem_cgroup *position;
>         /* scan generation, increased every round-trip */
> @@ -114,6 +120,7 @@ struct mem_cgroup_per_node {
>         CACHELINE_PADDING(_pad2_);
>         unsigned long           lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS]=
;
>         struct mem_cgroup_reclaim_iter  iter;
> +       struct memcg_reclaim_state      reclaim;
>
>  #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
>         /* slab stats for nmi context */
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f2b87e02574e..675d49ad7e2c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3713,6 +3713,9 @@ static bool alloc_mem_cgroup_per_node_info(struct m=
em_cgroup *memcg, int node)
>
>         lruvec_init(&pn->lruvec);
>         pn->memcg =3D memcg;
> +       atomic_long_set(&pn->reclaim.heat, 0);
> +       pn->reclaim.last_decay =3D jiffies;
> +       atomic_long_set(&pn->reclaim.last_refault, 0);
>
>         memcg->nodeinfo[node] =3D pn;
>         return true;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 4aa73f125772..3759cd52c336 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5978,6 +5978,124 @@ static inline bool should_continue_reclaim(struct=
 pglist_data *pgdat,
>         return inactive_lru_pages > pages_for_compaction;
>  }
>
> +enum memcg_scan_level {
> +       MEMCG_LEVEL_COLD,
> +       MEMCG_LEVEL_WARM,
> +       MEMCG_LEVEL_HOT,
> +       MEMCG_LEVEL_MAX,
> +};
> +
> +#define MEMCG_HEAT_WARM                4
> +#define MEMCG_HEAT_HOT         8
> +#define MEMCG_HEAT_MAX         12
> +#define MEMCG_HEAT_DECAY_STEP  1
> +#define MEMCG_HEAT_DECAY_INTERVAL      (1 * HZ)
I agree with Kairui; I'm somewhat concerned about this fixed decay
interval and how it behaves with many memcgs or heavy pressure.

> +
> +static void memcg_adjust_heat(struct mem_cgroup_per_node *pn, long delta=
)
> +{
> +       long heat, new_heat;
> +
> +       if (mem_cgroup_is_root(pn->memcg))
> +               return;
> +
> +       heat =3D atomic_long_read(&pn->reclaim.heat);
> +       do {
> +               new_heat =3D clamp_t(long, heat + delta, 0, MEMCG_HEAT_MA=
X);
> +               if (atomic_long_cmpxchg(&pn->reclaim.heat, heat, new_heat=
) =3D=3D heat)
> +                       break;
> +               heat =3D atomic_long_read(&pn->reclaim.heat);
> +       } while (1);
> +}
> +
> +static void memcg_decay_heat(struct mem_cgroup_per_node *pn)
> +{
> +       unsigned long last;
> +       unsigned long now =3D jiffies;
> +
> +       if (mem_cgroup_is_root(pn->memcg))
> +               return;
> +
> +       last =3D READ_ONCE(pn->reclaim.last_decay);
> +       if (!time_after(now, last + MEMCG_HEAT_DECAY_INTERVAL))
> +               return;
> +
> +       if (cmpxchg(&pn->reclaim.last_decay, last, now) !=3D last)
> +               return;
> +
> +       memcg_adjust_heat(pn, -MEMCG_HEAT_DECAY_STEP);
> +}
> +
> +static int memcg_heat_level(struct mem_cgroup_per_node *pn)
> +{
> +       long heat;
> +
> +       if (mem_cgroup_is_root(pn->memcg))
> +               return MEMCG_LEVEL_COLD;
> +
> +       memcg_decay_heat(pn);
The decay here is somewhat counterintuitive given the name memcg_heat_level=
.

> +       heat =3D atomic_long_read(&pn->reclaim.heat);
> +
> +       if (heat >=3D MEMCG_HEAT_HOT)
> +               return MEMCG_LEVEL_HOT;
> +       if (heat >=3D MEMCG_HEAT_WARM)
> +               return MEMCG_LEVEL_WARM;
> +       return MEMCG_LEVEL_COLD;
> +}
> +
> +static void memcg_record_reclaim_result(struct mem_cgroup_per_node *pn,
> +                                       struct lruvec *lruvec,
> +                                       unsigned long scanned,
> +                                       unsigned long reclaimed)
> +{
> +       long delta;
> +
> +       if (mem_cgroup_is_root(pn->memcg))
> +               return;
> +
> +       memcg_decay_heat(pn);
Could you combine the decay and adjust later in this function?

> +
> +       /*
> +        * Memory cgroup heat adjustment algorithm:
> +        * - If scanned =3D=3D 0: mark as hottest (+MAX_HEAT)
> +        * - If reclaimed >=3D 50% * scanned: strong cool (-2)
> +        * - If reclaimed >=3D 25% * scanned: mild cool (-1)
> +        * - Otherwise:  warm up (+1)
> +        */
> +       if (!scanned)
> +               delta =3D MEMCG_HEAT_MAX;
> +       else if (reclaimed * 2 >=3D scanned)
> +               delta =3D -2;
> +       else if (reclaimed * 4 >=3D scanned)
> +               delta =3D -1;
> +       else
> +               delta =3D 1;
> +
> +       /*
> +        * Refault-based heat adjustment:
> +        * - If refault increase > reclaimed pages: heat up (more cautiou=
s reclaim)
> +        * - If no refaults and currently warm:     cool down (allow more=
 reclaim)
> +        * This prevents thrashing by backing off when refaults indicate =
over-reclaim.
> +        */
> +       if (lruvec) {
> +               unsigned long total_refaults;
> +               unsigned long prev;
> +               long refault_delta;
> +
> +               total_refaults =3D lruvec_page_state(lruvec, WORKINGSET_A=
CTIVATE_ANON);
> +               total_refaults +=3D lruvec_page_state(lruvec, WORKINGSET_=
ACTIVATE_FILE);
> +
> +               prev =3D atomic_long_xchg(&pn->reclaim.last_refault, tota=
l_refaults);
> +               refault_delta =3D total_refaults - prev;
> +
> +               if (refault_delta > reclaimed)
> +                       delta++;
> +               else if (!refault_delta && delta > 0)
> +                       delta--;
> +       }

I think this metric is based more on the memcg's reclaimability than
on heat. Though the memcgs are grouped based on absolute metrics and
not relative to others.

> +
> +       memcg_adjust_heat(pn, delta);
> +}
> +
>  static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc=
)
>  {
> ...snip
>  }

Thanks,
Yuanchu

