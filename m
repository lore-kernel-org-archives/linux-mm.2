Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B2D0C44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 22:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A7396B0099; Wed,  8 Jul 2026 18:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57F6D6B009B; Wed,  8 Jul 2026 18:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46F8C6B009D; Wed,  8 Jul 2026 18:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 152726B0099
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:16:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C3941402FB
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:16:58 +0000 (UTC)
X-FDA: 84967020516.23.4515557
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 89D514000A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:16:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=eEwNPtNv;
	dmarc=pass (policy=reject) header.from=cloudflare.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of yunzhao@cloudflare.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=yunzhao@cloudflare.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783549016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EG1CgXIs6qa1Gkz7sXFXS994XYMLQ6F4/xwtNNWIOzg=;
	b=DvJqMFseKAuHaa2clSAKc9qg0OloraMXXlsUKTXNTj0ZWanAT2NBfn7XuVwMDWOv8WNyE+
	JNV+2SiG7kncSMcFORfwweO0cIwIB09gs7V9tRb76MWIv3qz2fPGTVmxs7uavqiuPHyIcQ
	UuJPwQ8MLuPE/cR1BItWIPSpDDgEjE4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=eEwNPtNv;
	dmarc=pass (policy=reject) header.from=cloudflare.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of yunzhao@cloudflare.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=yunzhao@cloudflare.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783549016;
	b=jbIgbiaqI1Laif5QisDTQxO4gG+gDfmLFWlGwvQt7y0angStGnZYTMa4jRsikFv1ZxcM5Y
	QVQ7eWt5lHFfLV7tLW1ot2j1ST918ha/g2YqLY8SXMs0zn5a55XRMYol8o7Omfb88XvC7Q
	geKwgMyvPBt6mZMWw76W2hhDAqG9XCA=
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-485ecc0f2dfso788579b6e.3
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 15:16:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783549015; cv=none;
        d=google.com; s=arc-20260327;
        b=FQuHeXA2Tjzgow1gBlnjw7V9oRq/7iYYvNlUZTQjmwX9s76fOvVtidelVUJVYUVuS0
         Ecs1UCbvOAyt6gq532Kh+ELyYT58h6rxQ1lG/dgLChz0KnZUtdQyF5Rg2EBMmYtgHhWJ
         vd3gcWa5mlTTUTkFLz6KVNh6d6Ew3M9/iewpTiDzSfLk5YitSZNqt7eZ80w2aDmEaZ8G
         hH5vfmssVBLuajr2x5XHXF2GL/+/NziT1ODU3W8eOZemazIVi3gc0bNJRqN9DW8A7Vd2
         el3sgLsj320gV5oc8AO/LTFIlLXOfe3INd9s16Ou+3/2ivb1mHFLburQs+SGsKelTdCu
         IDoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EG1CgXIs6qa1Gkz7sXFXS994XYMLQ6F4/xwtNNWIOzg=;
        fh=WaEIq9awnT2tR/VQF1jBk/rx3w3vIbQXX1Pws4UwlNk=;
        b=ThQ9KWoDf/XJ4IN8Vw/AdRhhFNcDMTGCFUwlCYEY37++x0lrr/qoH87711M6zzp8uI
         PubLluSqClHtfCr8UO0STDCogzYpJDQB9+EfZVCt/Q7/R5YHTxL5R5Cfmz5z4OBdmr9U
         H2rLRZBfg2kfoNzBSWUnPefpv7cvvN4hK3xjKrcxXWJQwY8qTo99p6Eq6jyOWLjDXxDQ
         ysHMugjexCYjIYc1Pg6tGIHL75QEKvpjIj7HiVATpUrauecVLI7mEg0FVxJ6e42V75bE
         QoSJJix9IAJv+nNkv2oT7OmUXO6J9M7x34R8LbZuaT2c/wB9tWjC3MSCBQT57u3qPFGx
         fTcQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1783549015; x=1784153815; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EG1CgXIs6qa1Gkz7sXFXS994XYMLQ6F4/xwtNNWIOzg=;
        b=eEwNPtNv+niBQskXZv3HKV5ty6Sni2NU9NcE6giXKIsbVnJnu5EGD0DTwz3xfKHpA3
         42VG+JFmzzmwygx/PcQEWj6cmB9L1DmXj9LLrxVp5QkMAROZ6L2W8aTHLD4lQ5rNnXEt
         gTTDaRnNQGdcKmxKK8J7Jgi6/1CtbMPFSv7QD8O+6Qct+YYuaZs3Z1qLru7obMZ/mtO/
         Wk91WvXRlMX6h6QfHJJP7Ndua52Fuovb/O2wU2ruaTTjoSOIp32qzei+Ua9MXZIC6l+I
         h4nSI5LcKEjg+At76hcG9X4CX+BWlnusGwzZUOguhLlNEE2t0ARap/398cxuMReHLTHw
         BP2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783549015; x=1784153815;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EG1CgXIs6qa1Gkz7sXFXS994XYMLQ6F4/xwtNNWIOzg=;
        b=GhSO+LjdygSFyCVGPw5AYTbmOIiU4jzdZBEHWI853r1OAsJ7wg2YW/CHVnzx2Q97e/
         1aHYyqAXUWfVRUrv9iiFOGLGby1t7dPGw473a4CdbVvF5FSYXHLRGJ9YEUs+xZ6BoC8V
         uOFroQ7s6zx8m/tRajP1jsdoaoEJ1ZXx4RrjGgi+FYB3vJ3UudwkECd9vK5iEmsSMLOW
         8E89u19Hj2In4RnyloAY19RNNooV+HAZr2DxPrvyumkqPlIIDn5rGT9DEuEadQOS3ZSt
         KDRXLp6mNtjCjW+wwqKR+HDwWc2HlRmbhj7FrT9j17t9596wuVPZY4rRbYufPIpvN6JF
         5wsg==
X-Forwarded-Encrypted: i=1; AFNElJ+lnuieeQwB/n3F48AU2bID9YSUoSt8SX/GCnaQP/1v3YOge0UOMU8EtxtiskZ0hQGj4ffgONHUvA==@kvack.org
X-Gm-Message-State: AOJu0Yw9pQcLx62NlBJVZCj1HT9ltk2Lu317J2llDswYzY6JVBaSVtxn
	Ndh+NLbPFOMw8bWIKhtpAuYSR6/ozg/A2kLKWvCSQB5BFvdWqB2R9lfbI7/pbZjjk1dwgyh47yz
	YfYDG6TUHDZc4aeyUfQQfPAKqb6Fk++rX+6LPaWzJYg==
X-Gm-Gg: AfdE7ckx1Svov7uMK/xldIrWz6Azh5jRjfUyHIsBYgxRTR1u7dqElcoZxHYBPA4JaMz
	t7+2u1wnFGSeB+XRUXcBACkV+QNzFN8vtGseroYZIMZpno1kHp8AG4AP+KjFmce1+1OTPg8Dw4x
	Q11p9khRs60T2x4wjNnVA41lJ7DdaDuqUg5X3IKIxH3mDKob1/OSJ/07v9RQeGfYZNIwxKiz8HS
	sf9pD/5ImmwEDlXhkwkPJknMmaxxXyNzo9T8FQqYYlnlK5ju1Bn4vCDZBE9a24uESdTp8xCVjtP
	Z8Vn4Uzs6JgPLAs=
X-Received: by 2002:a05:6808:308d:b0:495:f7a2:29a6 with SMTP id
 5614622812f47-4a2045dc393mr3731566b6e.23.1783549015442; Wed, 08 Jul 2026
 15:16:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260702180908.150136-1-yunzhao@cloudflare.com>
 <akbHBZP9HxOJMtQB@cmpxchg.org> <CAO9r8zOiwgG80EjqdZFgWQvODUe1RzecLemxcB7xXNm_f3XfbA@mail.gmail.com>
 <6ecf5579-0b3b-4e8c-a625-bbf0a4a48f94@kernel.org> <CAO9r8zP6JrZcBnzb8A3A9V8so4gJMWLvrJQ7VwPyyU417GikQg@mail.gmail.com>
In-Reply-To: <CAO9r8zP6JrZcBnzb8A3A9V8so4gJMWLvrJQ7VwPyyU417GikQg@mail.gmail.com>
From: Yunzhao Li <yunzhao@cloudflare.com>
Date: Wed, 8 Jul 2026 15:16:42 -0700
X-Gm-Features: AVVi8Cfk6xAsM7gr5MALZVET72dNG1pELlmyB9fjHMW1S9VLwCOqnXsN-zNc5jc
Message-ID: <CAAnvDSyNbV5xSH0hrX9Tgw_wXU7Neo-XSJ1enebxJXvjOheHWQ@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: use ratelimited stats flush in zswap_shrinker_count()
To: Yosry Ahmed <yosry@kernel.org>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	nphamcs@gmail.com, yosryahmed@google.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, zhouchengming@bytedance.com, 
	James Houghton <jthoughton@google.com>, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 89D514000A
X-Stat-Signature: 1frwtzi4aakrj84fj5raad9pcr1w11tk
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783549016-515278
X-HE-Meta: U2FsdGVkX1867mFIcc86VZZZQMeI7CJFAvE4XcQqZaN17KOwme4Ki3b1SYq7fl5HKg3Av9e+ooat/MMy6f4XOVMq1qBaSQOkgqqgBIJiw9LAtX/VvoQ6g68yVA2XF/Px9d/RY03QRPm+H6LRVaTR2MX+E85Tf/x0ZLmNKGWiusKdoBjTaeh2mQuln2IFse/S55QNvLKTijzFIcumdKCVvY/JouI6mtnDBc3GFaLT1JvDgLyjDJzTk1OqRU6clY/xHFnWNh0+n/h5sXVc3+bzlzhth3kZgIAPHAILdN5WdNa8uO4XjgOZhAJhZ+R+fGzDvQhv8FVieYi4Z5WflsRuhVFZcdTVlTdWRd4R16lH3133NbojPdhD7CtBo8ovuLZGDHBIiUMqibCwaCENShoRLhXbbTUCh07wEQDxIBiWxsUNfAs4vAQLcL+8zeUm15Bd5uYf5v3TBs0CwN9XftZH2uoNB6aARRDajBMOjdGK14RTtMYOrLWOPhC6uKsnORM9U/TXgm/G6PnB3Z7SLpD5g5QL9iIQtlsThJ4zSmNUE2ldY8ypwnTdM8bXui1rJZGraKLK4ZgMclQum8boIdtf84RtPyljgzfA/RBm5q3KykagrqPWRiD2nQm4SSBzSn8d7ipqPhXR73+ILPtKLX787ChM/UHxa28I7rQpfqUVH6x6vfWW0vDjrkKAvIRVQ9dD2rqz4XgovXIkSvcSMG4Gb+pTBx97OOi/1JupWYj5MRRDhpmLSEZ0+C6pqruYNRuqNyd7BvH9fk9Lu+Ooxx0YVqYJg3T5FmL2RkaQMI8DODJ9q8mVTdqNP52b4jOxx4Tz+TVxvQY0xpr9HjSImENp5M/SbI/mrWeEgxoaIzuBkBkP33mFo51m2dcez4Qxa5YIcsxQw8JeYttKXDqQTPz9fDu9uH3CjDrzwK79Ru6AWs81KFIXUJIGy3XYJWxOrUxCBCOMh3H+PbpkcqSBqjJ
 MfR1Kdsm
 iY2SzxRxNomz+R898aV7TRFh/V3d+iRjzGKl1+PmUuYnrVRByoqAkqAqzGV62Cta6soVRrSQ8Yx4SBXXeHhVIGfrNcxKbojn6tM5Sg9XX452yCbm4txBX7p2edpQssE5rTAc87dIcV7SS4pKeEZ1GVTvxrSWor0dMjQe5DAdqlngvJZo0fv0D1uAzgUJ2hy4f5J1AatTVT8zaZCoGjTQ42KjN4gxd3ocY6eAxj66L9rUNBVbbi45vuK3vMkwtt5myrgTEiU/xrxfsyZIynCNeGuxmua2AZLwceE9sGzF3TCHE5viqdLZmoD9QJ7wSfWGJbEz257IFNfjbJncgHlvfAXQ8stxHmhc9xn/4WZC2H3Cg44p0JTtxwqovLc9jlKD9Pc5U2ZbXnL0td+n6E0g8C2tgNyZ4LKnGGSP9Ff8Bics5L+NNASePWp3cvssp9PTRD1vsT8VUax7fvJsXoCle5R11mR3Th0XrjrM/VkPtV1Gomeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> What disadvantages are you running into with disabling the shrinker?

We lose about 16 GiB of MemAvailable per machine. We A/B'd this on
the same hardware (EPYC 9684X, 96c/12 NUMA, 384 GiB), same workload:

  shrinker=3DY: MemAvailable ~75 GiB
  shrinker=3DN: MemAvailable ~59 GiB

Based on my reading of the code, the zswap pool's zsmalloc pages
aren't on any LRU list, so kswapd can only reach them through the
shrinker. With shrinker=3DN the pool just grows until store-time
rejection or swapin frees entries.


Yunzhao

On Wed, Jul 8, 2026 at 12:33=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Wed, Jul 8, 2026 at 2:11=E2=80=AFAM Jesper Dangaard Brouer <hawk@kerne=
l.org> wrote:
> >
> >
> >
> > On 06/07/2026 21.46, Yosry Ahmed wrote:
> > > On Thu, Jul 2, 2026 at 6:01=E2=80=AFPM Johannes Weiner <hannes@cmpxch=
g.org> wrote:
> > >>
> > >> On Thu, Jul 02, 2026 at 11:07:35AM -0700, Yunzhao Li wrote:
> > >>> zswap_shrinker_count() calls mem_cgroup_flush_stats(), which takes =
the
> > >>> global cgroup rstat lock synchronously. On machines with many CPUs =
and
> > >>> NUMA nodes, this creates severe lock contention in the kswapd recla=
im
> > >>> path:
> > >>>
> > >>>    - Multiple kswapd threads (one per NUMA node) run concurrently.
> > >>>    - do_shrink_slab() invokes zswap_shrinker_count() for each
> > >>>      memcg-aware shrinker pass.
> > >>>    - Each call flushes the full cgroup rstat hierarchy under the gl=
obal
> > >>>      lock.
> > >>>
> > >>> On AMD EPYC 9684X machines (96 cores, 192 threads, 12 NUMA nodes)
> > >>> running production workloads with zswap enabled, perf shows 2.88% o=
f
> > >>> kernel cycles in osq_lock contention from this path:
> > >>>
> > >>>       2.88%  [k] osq_lock
> > >>>                --__mutex_lock.constprop.0
> > >>>                    --__cgroup_rstat_lock
> > >>>                        --cgroup_rstat_flush_locked
> > >>>                            --cgroup_rstat_flush
> > >>>                                --zswap_shrinker_count
> > >>>                                    do_shrink_slab
> > >>>                                    shrink_slab
> > >>>                                    shrink_node
> > >>>                                    balance_pgdat
> > >>>                                    kswapd
> > >>>
> > >>> 84% of kswapd kernel cycles are spent in
> > >>> shrink_slab -> zswap_shrinker_count -> cgroup_rstat_flush, not in a=
ctual
> > >>> page reclaim (shrink_lruvec).
> > >>>
> > >>> Controlled A/B on identical hardware and workload:
> > >>>
> > >>>    shrinker=3DY: 2.88% osq_lock, memory PSI 1.58%
> > >>>    shrinker=3DN: 0.00% osq_lock, memory PSI 0.57%
> > >>>
> > >>> eBPF-based rstat lock wait measurement across 8 production metals
> > >>> confirms the contention splits cleanly along shrinker enablement:
> > >>>
> > >>>    shrinker=3DY: 50-250x more contended lock acquisitions (248/s vs=
 1.1/s)
> > >>>    shrinker=3DN: baseline lock wait (0.0017 s/s vs 1.04 s/s)
> > >>>
> > >>> zswap_shrinker_count() only produces a heuristic estimate, scaled b=
y
> > >>> compression ratio via mult_frac(). The actual writeback happens in
> > >>> zswap_shrinker_scan(). Slightly stale stats are acceptable here.
> > >>>
> > >>> Switch to mem_cgroup_flush_stats_ratelimited(), which only flushes =
if
> > >>> the periodic 2-second flusher is one full cycle late. This matches =
the
> > >>> approach already used in prepare_scan_control() (mm/vmscan.c) for t=
he
> > >>> same reclaim path.
> > >>>
> > >>> After applying this patch, rstat flush latency and lock wait time o=
n
> > >>> shrinker=3DY machines dropped to the same level as shrinker=3DN con=
trols,
> > >>> while the zswap shrinker continues to function (pool size remains
> > >>> bounded under the max_pool_percent cap).
> > >>>
> > >>> Previously discussed:
> > >>>    - Chengming Zhou (Dec 2023): rstat contention from
> > >>>      zswap_shrinker_count [1]
> > >>>    - Shakeel Butt (Aug 2024): zswap_shrinker_count still uses sync
> > >>>      flush [2]
> > >>>    - Yosry Ahmed (Aug 2024): suggested eliminating in-kernel
> > >>>      flushers [3]
> > >>>    - Jesper Dangaard Brouer (Sep 2024): cgroup/rstat V11 patch [4]
> > >>>
> > >>> [1] https://lore.kernel.org/linux-mm/20231206103935.3440502-1-zhouc=
hengming@bytedance.com/
> > >>> [2] https://lore.kernel.org/linux-mm/CALvZod7LFxLCxVpOFH8b2Ppm8T40H=
PGMKQwX_=3DNPCWB_mFW+oQ@mail.gmail.com/
> > >>> [3] https://lore.kernel.org/linux-mm/CAJD7tkYvFyOSX+rP_FKGBhxvZiCDx=
tpsNp-c5CGOA-4Bq9oXSg@mail.gmail.com/
> > >>> [4] https://lore.kernel.org/linux-mm/172616070094.2055617.176760425=
22679701515.stgit@firesoul/
> > >>>
> > >>> Suggested-by: Jesper Dangaard Brouer <hawk@kernel.org>
> > >>> Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
> > >>> Signed-off-by: Yunzhao Li <yunzhao@cloudflare.com>
> > >>> Tested-by: Yunzhao Li <yunzhao@cloudflare.com>
> > >>
> > >> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > >>
> > >> A lot can happen in 2s, but I agree doing this every time is
> > >> silly. vmscan has been good with 2s for a while, so this should be
> > >> fine as well. We can re-evaluate if we run into weird behavior.
> > >
> > > Hmm actually we are starting to exercise kernels with the 2s change i=
n
> > > the vmscan path, and we are observing some seemingly premature OOM
> > > kills for VMs under memory pressure. We are still looking into it, bu=
t
> > > I would honestly hold off on adding another ratelimited flush here. I=
t
> > > may not be as big of a deal for the zswap path, but I'd rather fix
> > > this properly instead of just plugging it. We should probably move
> > > away from using rstat for zswapped/zswap_b stats and use page counter=
s
> > > as we discussed previously (i.e. eliminating the flushes to begin
> > > with).
> > >
> > > (Adding James here as he's looking into the premature OOM kills inter=
nally)
> >
> > IMHO it doesn't make any sense to hold off on this patch.
> > This only relates to zswap path with shrinker enabled. Today we are
> > forced to run with shrinker disabled.
> >
> > If you find some better approach to ratelimited flush, then that is
> > great.  You can change this code again for your use-case. No reason to
> > stall this patch IMHO.
>
> I think we should at least try a proper solution before falling back
> to the whack-a-mole approach here. I don't like the ratelimited flush
> because we use stale stats and the formulas start making less sense.
> If it causes any problems, it's hard to reason about them. I agree
> it's probably not gonna cause significant problems with the zswap
> shrinker, but we should at least make an attempt at a proper fix
> before resorting to this.
>
> I *think* we should stop using rstat for MEMCG_ZSWAPPED and
> MEMCG_ZSWAP_B. We can probably use per-memcg atomics for those, and
> just iterate the parents and update the counters. It will also get rid
> of the flush in obj_cgroup_may_zswap(), which is also problematic if
> memory.zswap.max is used. Yes, it's more expensive, but I suspect it
> may be just fine. The reclaim path is a slow path anyway. The fault
> path is probably more concerning but we won't know unless we try.
> rstat has a heavily optimized update path and a really expensive read
> path, and I think that tradeoff just doesn't make much sense in the
> zswap case.
>
> Can we try doing that instead? If there aren't significant performance
> regressions it would put us in a much better place imo.
>
> Also, a curious question, the changelog says:
> > while the zswap shrinker continues to function (pool size remains
> > bounded under the max_pool_percent cap).
>
> AFAICT the shrinker's goal is not to keep the pool size under the cap,
> that should happen regardless of whether or not the shrinker is
> enabled. The shrinker proactively writes back memory from zswap as
> part of reclaim, rather than waiting for the limit (global or memcg)
> to be hit. What disadvantages are you running into with disabling the
> shrinker?

