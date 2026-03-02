Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 012F0D58E5D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 05:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED50A6B008C; Mon,  2 Mar 2026 00:50:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E594A6B0096; Mon,  2 Mar 2026 00:50:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2D9A6B009B; Mon,  2 Mar 2026 00:50:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BCDBF6B008C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 00:50:56 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6751C1C6CB
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 05:50:56 +0000 (UTC)
X-FDA: 84500049312.10.A271F48
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 971968000B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 05:50:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="aLo/Pf/Y";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772430654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VLM1iqk3DG3RQDwRmlRL3VBgtb+kJ7wTeTTeyjfVAbA=;
	b=LNhnSrhnecTFiPoNCzNoZTQekgCWPgpKuCkS9vJm4ImMwLl/RgDP1ygwiHVExEA5Bmgadw
	21PTWfEkcprI8Lt9W8VnSmdX9k2P4kt9zRZ79e2PZOLjLq5/5bSnZqYR060eFX5jS6WR9b
	1kytN68tdi+VHeOKms7/ny1eHUEHTvo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772430654; a=rsa-sha256;
	cv=pass;
	b=3FwWGqg1LUVabPGvXYTPRX+YoxwqosRcO0Y5BvE710QxE0M/gOuCSHOVU1VYmwSDf+ZdGD
	zZN5hAKpUU9iORyuOykVWCIQUEEUcrckbg9ByIENoutm0hSl0y/9QvW1bTvgyfo1WQGqnp
	F8Qyvqg4LCpYTCFQKeF1BpBXNYAfMZw=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="aLo/Pf/Y";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-79854193a54so37535627b3.3
        for <linux-mm@kvack.org>; Sun, 01 Mar 2026 21:50:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772430654; cv=none;
        d=google.com; s=arc-20240605;
        b=U0BMnI6bO3Xrvk7nNNr7gAoYNfsK+sDsv24PUvUbV+Nm5lvHq16mbg2huWkb7wO2Y1
         kRMdnJgX9pozrcG1cnOgtXHUkbqGAW9Sznc9OjXMlYkjiSvHIJCVd958AP7haW2pZF9g
         283w/Ppf91nVAtd0lRZqxGKmsgb2ILYL79Pi1/R4FF3P5S4xJ6XIvM1jxbBlVoSyFyMj
         8P/P/8TeY9hJJ1czTmqig5dYFWOdp4tp+Z6cW7ptNF4NbjE7Ta/FftuPE2i2IbGfEVdk
         x8h5H5SiAoY/dC/2Ze3ToCEz1Rcji7dXp6yYDwZamVmeYNPiVqQtf0nnlerIEO85zKgx
         jGQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VLM1iqk3DG3RQDwRmlRL3VBgtb+kJ7wTeTTeyjfVAbA=;
        fh=8WPCb8AmWyFS9ol34JD+xxy9ENqKYnfxmO88RyFOFqE=;
        b=j8ndXa85+xEvACpkwgxVrOrbXd5wheco/tqk8BxP34bV3KqbdtegaLzjxodm7Ry61Y
         2MVHJV8J0/IDPIb6h6YdJSqoY//3+5PvtHYfbu0Um5/XZDz5PTCDtZmKzyxAQiJ2I9TO
         AXnVFu3Ymi6Mz3DDtkiwKYL5CMOHmREVURr3HdNM0k25peXAEsDuygztJnWgI8KJ7Fuz
         uw4qaiBZ3ZBHSB9QIE7SLxBeMfinX2ywLNFmKoN2c0jdTR3aSoDasXWtsPakjUU4fuIk
         jZWvbJf5p8/+atEANfrfR07pJH69cM1vd+LKfufBB7jxUp1ctOKAu8R6i1a0hY0Ibsti
         /Nxw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772430653; x=1773035453; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VLM1iqk3DG3RQDwRmlRL3VBgtb+kJ7wTeTTeyjfVAbA=;
        b=aLo/Pf/YFk7Re59E9c0FN5zx8NMyw4sC2oznUU59B6zRKjHhM5U+H1xtMgHk+ozd1A
         SGC/DEPYRzxzBnvz3SvOFLStjLO9e3OiSwrYQqhBzkbuHy0XjSLttjyhX98a8kqa7gtj
         hDwqYccBav8IZGKOu2mLp4WF5vCVkquXe9AaG7q2vcBQ3yldnxj3bEBoJwzJh4RuLMhO
         qaiWrkCIstFV4HS/lZivcMg1qlt2+EukGxCMRJG32c4uF2lSpMQJIMgquKePnjhyQHI7
         MFKjoKF40qdwap/Fok+lgJKMXkxwj3ERnytusAWkKT0yRM5rMYBMgqd4iT4hEXtnxAmU
         N3jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772430654; x=1773035454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VLM1iqk3DG3RQDwRmlRL3VBgtb+kJ7wTeTTeyjfVAbA=;
        b=rvwmsEhg/ovH+lb4uUxGTmh9bIDltQwTLOtqgMJCpas9UFWbMP5JmJdq+Gix3y20Kd
         yStEbzQWq7tDSEGsVlnt4a6k/kUQaxMeUNftrmEK+3Fy9yUafduO371KqNNBlCq0jJnt
         LCm697Txmt5xmKSCXfhmucxeBwvVWeWFFRkctRp6BxS8Wv5BhNaVpisaNVz5jy/JtU3n
         gmPTDDLnt+QThHwSYqiAyjoEeHTnG2stW1gPZt9jyh+enZdwbwyzAdmUaXopnHhD0mqI
         qLeb13A8DmLXPr7LWXLPZWcJrORJXsjIpyZAMDmN5hGpuT8NWQIM79l8l01qnDbNI2TL
         eICA==
X-Forwarded-Encrypted: i=1; AJvYcCWeGgN7zqjjUTJif+FJG1/aDxKRm13p2Red6wu4xTNb4S+icSWeewDyAUPiwwcrLmYhhJalDGLcNg==@kvack.org
X-Gm-Message-State: AOJu0YzF91oM+Y8RZni0rqRUnvQxoYEHzOqeQN0gApr9HMLaaU7DWjM/
	2+fiGDhBxv54lPghi07cVv0tJl9AH5LW5K5JeDOLNoBTd5siLe5+PM19yUVAxvgXtwSrQZMkRCl
	C9kcAskv5z6+BGJFi4i1Qo9c7wSjf3VV3yxRX
X-Gm-Gg: ATEYQzyumILFTNcfEApIw3nuxC6deS6OgttX7MHOAtALleA7kLafXLhyjpxi8S35cHQ
	HamMr10E/i7YQ6apnvFpV7w8qLu0p3UFBeAveeihR+b/DRpcrU9ItDBG158GO/+dwzZHLPWjTx1
	OBFOXz1mf9TjOhkqWU4dObhtzbODAAk3qH2pfdyurcdf4TDuJ44cjWJvi53VFv6jQz+c/Xfsfg+
	R5O0S8xFgfTjEtMVH/IOf/L8WTnoCuXnJ4dA552PgjOlFkF2TS6VOZ9sfdnSinuvMTWbftfNT8A
	WR19TpTWje75/bS0E08=
X-Received: by 2002:a05:690c:6612:b0:798:3f7:83bb with SMTP id
 00721157ae682-798855ed6bemr100575277b3.61.1772430653599; Sun, 01 Mar 2026
 21:50:53 -0800 (PST)
MIME-Version: 1.0
References: <20260228161008.707-1-lenohou@gmail.com> <20260228212837.59661-1-21cnbao@gmail.com>
In-Reply-To: <20260228212837.59661-1-21cnbao@gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 2 Mar 2026 13:50:17 +0800
X-Gm-Features: AaiRm52kvT09wj4Kzx-NRMivJsubDTRMuuUidYGF90ueA7aDtATld4ZtWKTE1hA
Message-ID: <CALOAHbBKr5ni=Ap2ASq2hx041WAghd+CzqbXGBSFPExBMJzcUg@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Barry Song <21cnbao@gmail.com>
Cc: lenohou@gmail.com, akpm@linux-foundation.org, axelrasmussen@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, weixugc@google.com, 
	wjl.linux@gmail.com, yuanchu@google.com, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: kde3kkoekw1qkc5aco7b9hq1981pgxn6
X-Rspamd-Queue-Id: 971968000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1772430654-759263
X-HE-Meta: U2FsdGVkX1+7CPchgqFrHlKOmijzUrKU/jWOGHCm8uQrLExhnaCK7Sq07T1szXNGgOmY9fCiqwMjIfsiv5s7WNkhOfVpvrFZjw6e2qyqxxICSMzQ3rhA8WedIyXoqZzut+tZklBpcvGudePmxFIRP8dLW7Zt2pQ9aLik5XgY2E1UmCt650Cvpa56UXPbhHFrF2dNzTRawO21EbvbGqZc1KwLizwNMwF56mPq4h1aF7HGZzA+4FMq/5BPnE8ZSZlTsqZQzk6ggs69n++1RN2D0vwOXQHT5iku5ABbkjfopuYhwjLKLTm/sk1IFvP+2nNXAohJ8gJ41YwDXhixMfdMIsQU1i/G6gYo5cGjk0Hgp5RtylTb81eb3o/40e1pPMEqG5Hc7sMUnOV4ysSiWWrSicLm/62enZTzCjODh6mBkGDXnnOs1hYiohnfqak3+gduoAfhaU/+ZQ2YccqM2Se+PxXiEvEwpZBpA0rIuziSZ4+BHZjA8zM5T2TcUmAQsMUeWSlNXsJfOQcHUvcRKi+HPwdx+oW4Y+qaCy+AAAt8omZKmgwNaXOKsTiOPkXrFWhX0zpOvHoIJMTpSKBontxpGK9ezjIbrNENX8s6/EmoURSxRys1glVQoLRiu31BwuhlLT7EHZFwSPhszjiHoWxoZxgNPJRyU1eYapF1xNAlRDt34LS7EWe2QMT1pKfEihA1NqzHu1tBIUowrtVL5lMgkb2Rzs/RwxomDoiyn6qsjd0BCEHdGF+XHkRpkczWp1M0s272InGeE++coCM/mIQvUk77RQRLLjCQyZkuKBPrFzLUPi4fW7j1e8n3BQV+1NSVNMKFw7UjNSjbrrNERKIxlkqDid6rnz6HvEH+QrUqXausb280XOgpywGE3GIZxF/uAWxJbEqorHQizPZa6Ja3eDcrTbApe1FRHLM6O1j0jzuSFiRyPUXA8kotKuk9Z+AAmnhzJ6H9Kp49kN4Z7D9
 heT2Vwvt
 WrJT9BgdHx89FM1kY5AWis/F3VOc6jM/xuQcyQuJxrkDoOnd/gBqsGenWqiHwVZvFpelKbY6GEC6T5SYMCaOf3giyfxg2Yb+nTRq8IjToWTO/rwv1U+bi7R1DoazzdehWeM9aaGiykapfBmi+NYv1T6S1ak6sLed2vN11
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 1, 2026 at 5:28=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrote=
:
>
> On Sun, Mar 1, 2026 at 12:10=E2=80=AFAM Leno Hou <lenohou@gmail.com> wrot=
e:
> >
> > When the Multi-Gen LRU (MGLRU) state is toggled dynamically, a race
> > condition exists between the state switching and the memory reclaim
> > path. This can lead to unexpected cgroup OOM kills, even when plenty of
> > reclaimable memory is available.
> >
> > *** Problem Description ***
> >
> > The issue arises from a "reclaim vacuum" during the transition:
> >
> > 1. When disabling MGLRU, lru_gen_change_state() sets lrugen->enabled to
> >    false before the pages are drained from MGLRU lists back to
> >    traditional LRU lists.
> > 2. Concurrent reclaimers in shrink_lruvec() see lrugen->enabled as fals=
e
> >    and skip the MGLRU path.
> > 3. However, these pages might not have reached the traditional LRU list=
s
> >    yet, or the changes are not yet visible to all CPUs due to a lack of
> >    synchronization.
> > 4. get_scan_count() subsequently finds traditional LRU lists empty,
> >    concludes there is no reclaimable memory, and triggers an OOM kill.
> >
> > A similar race can occur during enablement, where the reclaimer sees
> > the new state but the MGLRU lists haven't been populated via
> > fill_evictable() yet.
> >
> > *** Solution ***
> >
> > Introduce a 'draining' state to bridge the gap during transitions:
> >
> > - Use smp_store_release() and smp_load_acquire() to ensure the visibili=
ty
> >   of 'enabled' and 'draining' flags across CPUs.
> > - Modify shrink_lruvec() to allow a "joint reclaim" period. If an lruve=
c
> >   is in the 'draining' state, the reclaimer will attempt to scan MGLRU
> >   lists first, and then fall through to traditional LRU lists instead
> >   of returning early. This ensures that folios are visible to at least
> >   one reclaim path at any given time.
> >
> > *** Reproduction ***
> >
> > The issue was consistently reproduced on v6.1.157 and v6.18.3 using
> > a high-pressure memory cgroup (v1) environment.
> >
> > Reproduction steps:
> > 1. Create a 16GB memcg and populate it with 10GB file cache (5GB active=
)
> >    and 8GB active anonymous memory.
> > 2. Toggle MGLRU state while performing new memory allocations to force
> >    direct reclaim.
> >
> > Reproduction script:
> > ---
> > #!/bin/bash
> > # Fixed reproduction for memcg OOM during MGLRU toggle
> > set -euo pipefail
> >
> > MGLRU_FILE=3D"/sys/kernel/mm/lru_gen/enabled"
> > CGROUP_PATH=3D"/sys/fs/cgroup/memory/memcg_oom_test"
> >
> > # Switch MGLRU dynamically in the background
> > switch_mglru() {
> >     local orig_val=3D$(cat "$MGLRU_FILE")
> >     if [[ "$orig_val" !=3D "0x0000" ]]; then
> >         echo n > "$MGLRU_FILE" &
> >     else
> >         echo y > "$MGLRU_FILE" &
> >     fi
> > }
> >
> > # Setup 16G memcg
> > mkdir -p "$CGROUP_PATH"
> > echo $((16 * 1024 * 1024 * 1024)) > "$CGROUP_PATH/memory.limit_in_bytes=
"
> > echo $$ > "$CGROUP_PATH/cgroup.procs"
> >
> > # 1. Build memory pressure (File + Anon)
> > dd if=3D/dev/urandom of=3D/tmp/test_file bs=3D1M count=3D10240
> > dd if=3D/tmp/test_file of=3D/dev/null bs=3D1M # Warm up cache
> >
> > stress-ng --vm 1 --vm-bytes 8G --vm-keep -t 600 &
> > sleep 5
> >
> > # 2. Trigger switch and concurrent allocation
> > switch_mglru
> > stress-ng --vm 1 --vm-bytes 2G --vm-populate --timeout 5s || echo "OOM =
Triggered"
> >
> > # Check OOM counter
> > grep oom_kill "$CGROUP_PATH/memory.oom_control"
> > ---
> >
> > Signed-off-by: Leno Hou <lenohou@gmail.com>
> >
> > ---
> > To: linux-mm@kvack.org
> > To: linux-kernel@vger.kernel.org
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Axel Rasmussen <axelrasmussen@google.com>
> > Cc: Yuanchu Xie <yuanchu@google.com>
> > Cc: Wei Xu <weixugc@google.com>
> > Cc: Barry Song <21cnbao@gmail.com>
> > Cc: Jialing Wang <wjl.linux@gmail.com>
> > Cc: Yafang Shao <laoar.shao@gmail.com>
> > Cc: Yu Zhao <yuzhao@google.com>
> > ---
> >  include/linux/mmzone.h |  2 ++
> >  mm/vmscan.c            | 14 +++++++++++---
> >  2 files changed, 13 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 7fb7331c5725..0648ce91dbc6 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -509,6 +509,8 @@ struct lru_gen_folio {
> >         atomic_long_t refaulted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIE=
RS];
> >         /* whether the multi-gen LRU is enabled */
> >         bool enabled;
> > +       /* whether the multi-gen LRU is draining to LRU */
> > +       bool draining;
> >         /* the memcg generation this lru_gen_folio belongs to */
> >         u8 gen;
> >         /* the list segment this lru_gen_folio belongs to */
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 06071995dacc..629a00681163 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -5222,7 +5222,8 @@ static void lru_gen_change_state(bool enabled)
> >                         VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
> >                         VM_WARN_ON_ONCE(!state_is_valid(lruvec));
> >
> > -                       lruvec->lrugen.enabled =3D enabled;
> > +                       smp_store_release(&lruvec->lrugen.enabled, enab=
led);
> > +                       smp_store_release(&lruvec->lrugen.draining, tru=
e);
> >
> >                         while (!(enabled ? fill_evictable(lruvec) : dra=
in_evictable(lruvec))) {
> >                                 spin_unlock_irq(&lruvec->lru_lock);
> > @@ -5230,6 +5231,8 @@ static void lru_gen_change_state(bool enabled)
> >                                 spin_lock_irq(&lruvec->lru_lock);
> >                         }
> >
> > +                       smp_store_release(&lruvec->lrugen.draining, fal=
se);
> > +
> >                         spin_unlock_irq(&lruvec->lru_lock);
> >                 }
> >
> > @@ -5813,10 +5816,15 @@ static void shrink_lruvec(struct lruvec *lruvec=
, struct scan_control *sc)
> >         unsigned long nr_to_reclaim =3D sc->nr_to_reclaim;
> >         bool proportional_reclaim;
> >         struct blk_plug plug;
> > +       bool lrugen_enabled =3D smp_load_acquire(&lruvec->lrugen.enable=
d);
> > +       bool lru_draining =3D smp_load_acquire(&lruvec->lrugen.draining=
);
> >
> > -       if (lru_gen_enabled() && !root_reclaim(sc)) {
> > +       if (lrugen_enabled || lru_draining && !root_reclaim(sc)) {
> >                 lru_gen_shrink_lruvec(lruvec, sc);
> > -               return;
>

Hello Barry,

> Is it possible to simply wait for draining to finish instead of performin=
g
> an lru_gen/lru shrink while lru_gen is being disabled or enabled?

This might introduce unexpected latency spikes during the waiting period.

>
> Performing a shrink in an intermediate state may still involve a lot of
> uncertainty, depending on how far the shrink has progressed and how much
> remains in each side=E2=80=99s LRU=EF=BC=9F

The workingset might not be reliable in this intermediate state.
However, since switching MGLRU should not be a frequent operation in a
production environment, I believe the workingset in this intermediate
state should not be a concern. The only reason we would enable or
disable MGLRU is if we find that certain workloads benefit from
it=E2=80=94enabling it when it helps, and disabling it when it causes
degradation. There should be no other scenario in which we would need
to toggle MGLRU on or off.

To identify which workloads can benefit from MGLRU, we must first
ensure that switching it on or off is safe=E2=80=94which is precisely why w=
e
are proposing this patch. Once MGLRU is enabled in production, we can
continue to improve it. Perhaps in the future, we can even implement a
per-workload reclaim mechanism.


--
Regards
Yafang

