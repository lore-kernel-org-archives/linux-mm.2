Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63062D58E73
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 08:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89D1B6B0005; Mon,  2 Mar 2026 03:14:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84BC16B008A; Mon,  2 Mar 2026 03:14:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701F46B008C; Mon,  2 Mar 2026 03:14:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E5CC6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:14:04 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC5021CEAE
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:14:03 +0000 (UTC)
X-FDA: 84500409966.02.00CD474
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2745A20002
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:14:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mVCfRYEh;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772439242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VUV2wqGxB8FWFkLM2m+rBSW5hlZukSDeL86QKhDIRqA=;
	b=MgreOzLc5QPw0OVGHkMzqvSDnQa3twvcIt/V76ui2tVjG6LiF77JWlSZ/aaPvvh2xwShg2
	fVHPea2dVoCSPxqVT8qH/ZWhNpYo4PoA0xTsdYKeEIwRlVtOboJcYC/4tsGRcYm8fqxl64
	rBWS0DKpl6xMOnp5tSgqVq2MSLz2xDk=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mVCfRYEh;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772439242; a=rsa-sha256;
	cv=pass;
	b=bZHvEUZHDnlDX5FjOPrcgYdBW288thZnjiNJ9p606sN+2hPjllsZlVzujBcDx9MnwBU8Gn
	I93luGIl4X9d8L/MkPvVOIiv270FjDmkE5W/WJfIWKne3B7pK4L6INeQmsxtY+Qv5t0c93
	gkAVh4mtbS0lf+2J3rjsqMFRC0qhuz8=
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-64ae222d978so3675132d50.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 00:14:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772439241; cv=none;
        d=google.com; s=arc-20240605;
        b=Eiq+7vz+v3E5o4SFLxGtBp0Id8ikKRFf44dSQK5wa2ecpgtQWZlr0Se8R9rfJhV94o
         PbKXoWSeir3MuA9tiTAUhyXEubeH1U7x3eekzPZMsKn6rpb2K6D9wgAw0y3vVarU4z53
         GvGH9fbG0iPn1GMRhXQYwYRnCYOQd4SnIjZWhQUkkIrqCFwyttpDO80TB0feyYvH4n1N
         9KXy8fF6PYB6xR9ERemyeLVPX19bsn0f5YgpD3pDW5vvIhXRLQxcXM1NiCZDGIB6PtcP
         QZNMd7gkmlNG/DWZ7EvWmcrlM0yiraKx8prKexhPRW0z8D8771h4FVCkh+3G9KMLxpfF
         UoKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VUV2wqGxB8FWFkLM2m+rBSW5hlZukSDeL86QKhDIRqA=;
        fh=nPi9JXyCywYl+/kcQsjs4tQQEjfzi8L5WDYE9LA9tYM=;
        b=KxSZf6Z5FybarIo/VmcAZ8P45rEgRe3fRP2AaLEYMHhuWI/uCiP0ylbLd/CfjZy+eD
         UEkqwdsgGKBvrrIpeFzi268zPO49dNxczigtj7X6KI9nA8h7+ABO9fGXgtfstnEeaQ95
         L3JQgMW+YnBe5/l4pNpXmxhDqCZ3ZoS3eTSs/RdvMGErAz2xq5gM2PvVmu7ma1hMHF1R
         smPWTZ1X5XTgJpiFLjpkqdHxvp5xJbYkIsbM09Q/jFPXxMUdOubMlmwEiwRy6U7BMCkH
         YbWd9Dt5Z/rN0mo0wkW73BHh369IFv8rj8Habk9f/ajJk1KgFl1bAaganbRahGOTeHQP
         u0gg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772439241; x=1773044041; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VUV2wqGxB8FWFkLM2m+rBSW5hlZukSDeL86QKhDIRqA=;
        b=mVCfRYEhPmfbRp7A40ZjegeATTUA4NCpZvcg1odhutflxw23cJm2pZFDGHYbjJzCfo
         1bCunZ7/V/8YBvt9bJDx/C/BkFQQEVMmTxyO66ucNwYq7BFa2Yxx9DFRaATq6XmXZAMg
         UnvQBwN2xUMwQ/aWKVeNIP+AIZfupaJzSGQXYeL0UgnLiSPJmarNo94zgFpeMoWltfvN
         Pg0FPIOHrs03CfX/R35YstfWCe8jxOS+RqCduHnMWqt/cPQEl98Peg0nfU9TlMqJ9odK
         iPfR9g5ujfht5KGwWUpPNDeZBTeTy9HuTenEVpf0y795TfEZgkT+LAQbo0KDmfjsZn8q
         DkWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772439241; x=1773044041;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VUV2wqGxB8FWFkLM2m+rBSW5hlZukSDeL86QKhDIRqA=;
        b=WdOIa8CHZpkCfpxD2EQPMb615T2pn5EQ3YMGOG59MDwu/sfDFBUd1EGX65HcCAS3zd
         8UrHYuewjIa1FJs8qIoih8aPmbHT6F+Qx4mvYrUwJsUpYJgSKtXsVZmS8CkhgVfKoAsB
         DmgkDR/Fue0oXR9iUCKm3yXMvmcS6OYK7K0wK7FTwtGaK4KY+E8/Y03dCu6+W3wbpmOw
         w4jEo6mt1ohEecyohNTtZ5AkjjmE+uHnIZ/6Zz/CbzioZV1qLDpw9umXYVZGPS+ozVC0
         cVwgGUNe61XnJugPt01VbgtMCVWipeW4uXNhaqqBlOTHXPu1uWpTSTdlia8QmargCOXC
         0gMg==
X-Forwarded-Encrypted: i=1; AJvYcCWQB3YqUQWclQRxwo/h+SJQM3rarFwbhHl0WFN3aIUBUJaRtxFnWMXJuPdDDbzzXWtfK6K6uHb+ZQ==@kvack.org
X-Gm-Message-State: AOJu0YxCVLlETXr6bRBfKV4gLs4/DLnKgBfkekwHRk3eryVlr+FHcNkR
	nd/V4TBMmZrDW7uje9TEH3q94rj0DHSf2ealKEgp2mRkB6nUoQr8tJggfgoYUr/p+6v65HCnRSI
	o1UvuYcrskuDkoU8t6mdvcOo7l+X25og=
X-Gm-Gg: ATEYQzy1h+I82yOlbi0ZbNVzp+ASvvd7UfuHViRIDueEliFx4ZpQvHpWH6yzyrEQcSf
	sv7e50SRbt0+PTzyhs/PJ5v9UzMGbaowad7JBOMml5pC0JLz0hXZ3G2th8rbnQY7zS/wRjkNy1l
	8JoYSi6REvy0IU64BxthkthRajlH3krsUDSHJt9C1wodWwqLa+zsqJa9Ny6KdGtnAmAd0Vo9o2b
	nU5q+BYQg4gSEzfBfu1hCYf/KF9dwjKnazXb7A7hs3o6hdmHryTI+ND8ZlLup1V82bkTfozos5/
	/nchOXGp
X-Received: by 2002:a53:e1fb:0:b0:63e:2715:5ac6 with SMTP id
 956f58d0204a3-64cc20c45admr6504476d50.35.1772439241073; Mon, 02 Mar 2026
 00:14:01 -0800 (PST)
MIME-Version: 1.0
References: <20260228161008.707-1-lenohou@gmail.com> <20260228212837.59661-1-21cnbao@gmail.com>
 <CALOAHbBKr5ni=Ap2ASq2hx041WAghd+CzqbXGBSFPExBMJzcUg@mail.gmail.com>
 <CAGsJ_4xA3tApXCs2S-sZh2qA9RK_1masQ7nb1NYyCHXwnP9FAQ@mail.gmail.com>
 <CALOAHbBRBot0EXmzPNb2zpgC2GV5NfnzAZuosTb-iygjaw3U=w@mail.gmail.com> <CAGsJ_4zAY+1feahcVHhJ0NyKHxFZZHJpey1Qd=FAnSnHhh3Yyg@mail.gmail.com>
In-Reply-To: <CAGsJ_4zAY+1feahcVHhJ0NyKHxFZZHJpey1Qd=FAnSnHhh3Yyg@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 2 Mar 2026 16:13:25 +0800
X-Gm-Features: AaiRm51mmCBoiXyZcW7LOaP9NWc_fWF9G9p2dFdDHlvC0uf7PP0-31j7rro31v4
Message-ID: <CALOAHbCtYoBLbbzX0DU2xuTeDehW__LiJfd16ZrUBG+TijfH_w@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Barry Song <21cnbao@gmail.com>
Cc: lenohou@gmail.com, akpm@linux-foundation.org, axelrasmussen@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, weixugc@google.com, 
	wjl.linux@gmail.com, yuanchu@google.com, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2745A20002
X-Rspamd-Server: rspam07
X-Stat-Signature: cq396cng1crg7e5su9kghzu3d7g56h7g
X-Rspam-User: 
X-HE-Tag: 1772439241-291423
X-HE-Meta: U2FsdGVkX19JDngteoIU8TJ7KkTJoAIfcXonYEmRs7mpONhV5wWuYuAP7Pmofc8BeRGgULfPG9CXIHiJDmBzCdhpgH25iq2LNkcsklh3e3EMa8n5V01aAEode6HA+4r7BBCLXQh2BeuT+MKD+38U4ljHud6AjeUIb+Bi9TDfESBZj2Gv2OBPeSkzC33kz7BsLmc0LbhIovcNODh4NaS7b9uLm1IayNmb7SPPAWs3ci4+Csim/i1B+SPZR3K2jRBKURIJ5Rm4c3ZwNNi88cttb1lMET594Fzh9MAPM+skuYmqV/LgP0cdFCry6IXsmaNYB9uUw0hCjoFFVK06Aai53Hrn9l+3zs48aHDl9UcbQoNujFD0KdQ5GA/SDh/U7F2xK4yBoorYA4dKivBb0Bke6gQyZmCLJrNZHlZCncBjrtCff0PX2IZYve8u2TcJIjxaCqIetDBIvLeYSrp3UbqaQLpZJ59DwSN9vy2T9CgH1Oy1h6RhHj1apWe4hwabUpI05KIDgvCVqO2kaBtbuiXifKnCiC8RQnUHAHIApNFA9sWjsMBT/0FSvJt8Gbt17lRt9OZMTqkhcImvDM+XSBcYhaqbSdh1CLYS/7dGx5Qepqj7U8oMlGCvD/m99Q0tv7t/7FaV7+spVPd0am/BqelfXLVImrZLMpRiSEMznhwqJNGPauujtUxLsF61INYGwfHxihcoMNnfTAuEB+HkMHFpTkHc8KAUcMEo8T9Nv7sEjnqfUJPscr/JTmulI3GFn/hwzY/Tz4KUURnhw48Q5scBFJuVS+Xo9U1MbfXw+p41VokE/k/XjDqgmkiKcfy/tzfrBtzpSw4exiOc1iz8u7rLsixt9CUA6TrqFG80rPd7FrytNCI09Hq5xy2QisgZwkfUg5PKb2FE2a09raCxPSs4iir9mDARIEJzGnXYkBQ4/ceZ7tA76ujxL5wuOsXNpoMdCImUCQtVDSZaprcG59+
 8OMgewSn
 8zjkvfg7BYPsmtaK1FEegMz7YdsdzqH0iv6hiW7C5mkXv7sk/eYHM51wLIQ2N9Pd2UBk4RqyFmisFv9tAZY/cxx4HaxLXhg/PurdeoUMNm99sKIlCyZ8vgJuFNG0Lu5/DvVjAdTzABaBfMtVjK+WWE6WK5/U0qCrIadTS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 4:04=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrote=
:
>
> On Mon, Mar 2, 2026 at 3:43=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
> >
> > On Mon, Mar 2, 2026 at 2:58=E2=80=AFPM Barry Song <21cnbao@gmail.com> w=
rote:
> > >
> > > On Mon, Mar 2, 2026 at 1:50=E2=80=AFPM Yafang Shao <laoar.shao@gmail.=
com> wrote:
> > > >
> > > > On Sun, Mar 1, 2026 at 5:28=E2=80=AFAM Barry Song <21cnbao@gmail.co=
m> wrote:
> > > > >
> > > > > On Sun, Mar 1, 2026 at 12:10=E2=80=AFAM Leno Hou <lenohou@gmail.c=
om> wrote:
> > > > > >
> > > > > > When the Multi-Gen LRU (MGLRU) state is toggled dynamically, a =
race
> > > > > > condition exists between the state switching and the memory rec=
laim
> > > > > > path. This can lead to unexpected cgroup OOM kills, even when p=
lenty of
> > > > > > reclaimable memory is available.
> > > > > >
> > > > > > *** Problem Description ***
> > > > > >
> > > > > > The issue arises from a "reclaim vacuum" during the transition:
> > > > > >
> > > > > > 1. When disabling MGLRU, lru_gen_change_state() sets lrugen->en=
abled to
> > > > > >    false before the pages are drained from MGLRU lists back to
> > > > > >    traditional LRU lists.
> > > > > > 2. Concurrent reclaimers in shrink_lruvec() see lrugen->enabled=
 as false
> > > > > >    and skip the MGLRU path.
> > > > > > 3. However, these pages might not have reached the traditional =
LRU lists
> > > > > >    yet, or the changes are not yet visible to all CPUs due to a=
 lack of
> > > > > >    synchronization.
> > > > > > 4. get_scan_count() subsequently finds traditional LRU lists em=
pty,
> > > > > >    concludes there is no reclaimable memory, and triggers an OO=
M kill.
> > > > > >
> > > > > > A similar race can occur during enablement, where the reclaimer=
 sees
> > > > > > the new state but the MGLRU lists haven't been populated via
> > > > > > fill_evictable() yet.
> > > > > >
> > > > > > *** Solution ***
> > > > > >
> > > > > > Introduce a 'draining' state to bridge the gap during transitio=
ns:
> > > > > >
> > > > > > - Use smp_store_release() and smp_load_acquire() to ensure the =
visibility
> > > > > >   of 'enabled' and 'draining' flags across CPUs.
> > > > > > - Modify shrink_lruvec() to allow a "joint reclaim" period. If =
an lruvec
> > > > > >   is in the 'draining' state, the reclaimer will attempt to sca=
n MGLRU
> > > > > >   lists first, and then fall through to traditional LRU lists i=
nstead
> > > > > >   of returning early. This ensures that folios are visible to a=
t least
> > > > > >   one reclaim path at any given time.
> > > > > >
> > > > > > *** Reproduction ***
> > > > > >
> > > > > > The issue was consistently reproduced on v6.1.157 and v6.18.3 u=
sing
> > > > > > a high-pressure memory cgroup (v1) environment.
> > > > > >
> > > > > > Reproduction steps:
> > > > > > 1. Create a 16GB memcg and populate it with 10GB file cache (5G=
B active)
> > > > > >    and 8GB active anonymous memory.
> > > > > > 2. Toggle MGLRU state while performing new memory allocations t=
o force
> > > > > >    direct reclaim.
> > > > > >
> > > > > > Reproduction script:
> > > > > > ---
> > > > > > #!/bin/bash
> > > > > > # Fixed reproduction for memcg OOM during MGLRU toggle
> > > > > > set -euo pipefail
> > > > > >
> > > > > > MGLRU_FILE=3D"/sys/kernel/mm/lru_gen/enabled"
> > > > > > CGROUP_PATH=3D"/sys/fs/cgroup/memory/memcg_oom_test"
> > > > > >
> > > > > > # Switch MGLRU dynamically in the background
> > > > > > switch_mglru() {
> > > > > >     local orig_val=3D$(cat "$MGLRU_FILE")
> > > > > >     if [[ "$orig_val" !=3D "0x0000" ]]; then
> > > > > >         echo n > "$MGLRU_FILE" &
> > > > > >     else
> > > > > >         echo y > "$MGLRU_FILE" &
> > > > > >     fi
> > > > > > }
> > > > > >
> > > > > > # Setup 16G memcg
> > > > > > mkdir -p "$CGROUP_PATH"
> > > > > > echo $((16 * 1024 * 1024 * 1024)) > "$CGROUP_PATH/memory.limit_=
in_bytes"
> > > > > > echo $$ > "$CGROUP_PATH/cgroup.procs"
> > > > > >
> > > > > > # 1. Build memory pressure (File + Anon)
> > > > > > dd if=3D/dev/urandom of=3D/tmp/test_file bs=3D1M count=3D10240
> > > > > > dd if=3D/tmp/test_file of=3D/dev/null bs=3D1M # Warm up cache
> > > > > >
> > > > > > stress-ng --vm 1 --vm-bytes 8G --vm-keep -t 600 &
> > > > > > sleep 5
> > > > > >
> > > > > > # 2. Trigger switch and concurrent allocation
> > > > > > switch_mglru
> > > > > > stress-ng --vm 1 --vm-bytes 2G --vm-populate --timeout 5s || ec=
ho "OOM Triggered"
> > > > > >
> > > > > > # Check OOM counter
> > > > > > grep oom_kill "$CGROUP_PATH/memory.oom_control"
> > > > > > ---
> > > > > >
> > > > > > Signed-off-by: Leno Hou <lenohou@gmail.com>
> > > > > >
> > > > > > ---
> > > > > > To: linux-mm@kvack.org
> > > > > > To: linux-kernel@vger.kernel.org
> > > > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > > > Cc: Axel Rasmussen <axelrasmussen@google.com>
> > > > > > Cc: Yuanchu Xie <yuanchu@google.com>
> > > > > > Cc: Wei Xu <weixugc@google.com>
> > > > > > Cc: Barry Song <21cnbao@gmail.com>
> > > > > > Cc: Jialing Wang <wjl.linux@gmail.com>
> > > > > > Cc: Yafang Shao <laoar.shao@gmail.com>
> > > > > > Cc: Yu Zhao <yuzhao@google.com>
> > > > > > ---
> > > > > >  include/linux/mmzone.h |  2 ++
> > > > > >  mm/vmscan.c            | 14 +++++++++++---
> > > > > >  2 files changed, 13 insertions(+), 3 deletions(-)
> > > > > >
> > > > > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > > > > index 7fb7331c5725..0648ce91dbc6 100644
> > > > > > --- a/include/linux/mmzone.h
> > > > > > +++ b/include/linux/mmzone.h
> > > > > > @@ -509,6 +509,8 @@ struct lru_gen_folio {
> > > > > >         atomic_long_t refaulted[NR_HIST_GENS][ANON_AND_FILE][MA=
X_NR_TIERS];
> > > > > >         /* whether the multi-gen LRU is enabled */
> > > > > >         bool enabled;
> > > > > > +       /* whether the multi-gen LRU is draining to LRU */
> > > > > > +       bool draining;
> > > > > >         /* the memcg generation this lru_gen_folio belongs to *=
/
> > > > > >         u8 gen;
> > > > > >         /* the list segment this lru_gen_folio belongs to */
> > > > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > > > index 06071995dacc..629a00681163 100644
> > > > > > --- a/mm/vmscan.c
> > > > > > +++ b/mm/vmscan.c
> > > > > > @@ -5222,7 +5222,8 @@ static void lru_gen_change_state(bool ena=
bled)
> > > > > >                         VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
> > > > > >                         VM_WARN_ON_ONCE(!state_is_valid(lruvec)=
);
> > > > > >
> > > > > > -                       lruvec->lrugen.enabled =3D enabled;
> > > > > > +                       smp_store_release(&lruvec->lrugen.enabl=
ed, enabled);
> > > > > > +                       smp_store_release(&lruvec->lrugen.drain=
ing, true);
> > > > > >
> > > > > >                         while (!(enabled ? fill_evictable(lruve=
c) : drain_evictable(lruvec))) {
> > > > > >                                 spin_unlock_irq(&lruvec->lru_lo=
ck);
> > > > > > @@ -5230,6 +5231,8 @@ static void lru_gen_change_state(bool ena=
bled)
> > > > > >                                 spin_lock_irq(&lruvec->lru_lock=
);
> > > > > >                         }
> > > > > >
> > > > > > +                       smp_store_release(&lruvec->lrugen.drain=
ing, false);
> > > > > > +
> > > > > >                         spin_unlock_irq(&lruvec->lru_lock);
> > > > > >                 }
> > > > > >
> > > > > > @@ -5813,10 +5816,15 @@ static void shrink_lruvec(struct lruvec=
 *lruvec, struct scan_control *sc)
> > > > > >         unsigned long nr_to_reclaim =3D sc->nr_to_reclaim;
> > > > > >         bool proportional_reclaim;
> > > > > >         struct blk_plug plug;
> > > > > > +       bool lrugen_enabled =3D smp_load_acquire(&lruvec->lruge=
n.enabled);
> > > > > > +       bool lru_draining =3D smp_load_acquire(&lruvec->lrugen.=
draining);
> > > > > >
> > > > > > -       if (lru_gen_enabled() && !root_reclaim(sc)) {
> > > > > > +       if (lrugen_enabled || lru_draining && !root_reclaim(sc)=
) {
> > > > > >                 lru_gen_shrink_lruvec(lruvec, sc);
> > > > > > -               return;
> > > > >
> > > >
> > > > Hello Barry,
> > > >
> > > > > Is it possible to simply wait for draining to finish instead of p=
erforming
> > > > > an lru_gen/lru shrink while lru_gen is being disabled or enabled?
> > > >
> > > > This might introduce unexpected latency spikes during the waiting p=
eriod.
> > >
> > > I assume latency is not a concern for a very rare
> > > MGLRU on/off case. Do you require the switch to happen
> > > with zero latency?
> > > My main concern is the correctness of the code.
> > >
> > > Now the proposed patch is:
> > >
> > > +       bool lrugen_enabled =3D smp_load_acquire(&lruvec->lrugen.enab=
led);
> > > +       bool lru_draining =3D smp_load_acquire(&lruvec->lrugen.draini=
ng);
> > >
> > > Then choose MGLRU or active/inactive LRU based on
> > > those values.
> > >
> > > However, nothing prevents those values from changing
> > > after they are read. Even within the shrink path,
> > > they can still change.
> >
> > If these values are changed during reclaim, the currently running
> > reclaimer will continue to operate with the old settings, while any
> > new reclaimer processes will adopt the new values. This approach
> > should prevent any immediate issues, but the primary risk of this
> > lockless method is the potential for a user to rapidly toggle the
> > MGLRU feature, particularly during an intermediate state.
> >
> > >
> > > So I think we need an rwsem or something similar here =E2=80=94
> > > a read lock for shrink and a write lock for on/off. The
> > > write lock should happen very rarely.
> >
> > We can introduce a lock-based mechanism in v2.
>
> Honestly, the on/off toggle is quite fragile. For instance,
>
> folio_check_references() is doing:
>
>         if (lru_gen_enabled()) {
>                 if (!referenced_ptes)
>                         return FOLIOREF_RECLAIM;
>
>                 return lru_gen_set_refs(folio) ? FOLIOREF_ACTIVATE :
> FOLIOREF_KEEP;
>         }
>
> However, `lru_gen_enabled()` does not indicate the actual LRU
> where the folio resides.
>
> `lru_gen_enabled()` is called in many places, but in this case it does
> not accurately reflect where folios are placed if a dynamic toggle is
> active. During the switching, many unexpected behaviors may occur.
>
> >
> > >
> > > >
> > > > >
> > > > > Performing a shrink in an intermediate state may still involve a =
lot of
> > > > > uncertainty, depending on how far the shrink has progressed and h=
ow much
> > > > > remains in each side=E2=80=99s LRU=EF=BC=9F
> > > >
> > > > The workingset might not be reliable in this intermediate state.
> > > > However, since switching MGLRU should not be a frequent operation i=
n a
> > > > production environment, I believe the workingset in this intermedia=
te
> > > > state should not be a concern. The only reason we would enable or
> > > > disable MGLRU is if we find that certain workloads benefit from
> > > > it=E2=80=94enabling it when it helps, and disabling it when it caus=
es
> > > > degradation. There should be no other scenario in which we would ne=
ed
> > > > to toggle MGLRU on or off.
> > > >
> > > > To identify which workloads can benefit from MGLRU, we must first
> > > > ensure that switching it on or off is safe=E2=80=94which is precise=
ly why we
> > > > are proposing this patch. Once MGLRU is enabled in production, we c=
an
> > > > continue to improve it. Perhaps in the future, we can even implemen=
t a
> > > > per-workload reclaim mechanism.
> > >
> > > To be honest, the on/off toggle is quite odd. If possible,
> > > I=E2=80=99d prefer not to switch MGLRU or active/inactive
> > > dynamically. Once it=E2=80=99s set up during system boot, it
> > > should remain unchanged.
> >
> > While it is well-suited for Android environments, it is not viable for
> > Kubernetes production servers, where rebooting is highly disruptive.
> > This limitation is precisely why we need to introduce dynamic toggles.
>
> Perhaps we really need to unify MGLRU with the active/inactive lists,
> combining the benefits of both approaches. The dynamic toggle, as it
> stands, is quite fragile.
> A topic was suggested by Kairui here [1].
>
> >
> > >
> > > If we want a per-workload LRU, this could be a good
> > > place for eBPF to hook into folio enqueue, dequeue,
> > > and scanning. There is a project related to this [1][2].
> > >
> > > // Policy function hooks
> > > struct cache_ext_ops {
> > >        s32 (*policy_init)(struct mem_cgroup *memcg);
> > >        // Propose folios to evict
> > >        void (*evict_folios)(struct eviction_ctx *ctx,
> > >                  struct mem_cgroup *memcg);
> > >        void (*folio_added)(struct folio *folio);
> > >        void (*folio_accessed)(struct folio *folio);
> > >        // Folio was removed: clean up metadata
> > >        void (*folio_removed)(struct folio *folio);
> > >        char name[CACHE_EXT_OPS_NAME_LEN];
> > > };
> > >
> > > However, we would need a very strong and convincing
> > > user case to justify it.
> >
> > Thanks for the info.
> > We're actually already running a BPF-based reclaimer in production,
> > but we don't have immediate plans to upstream or propose it just yet.
>
> I know you are always far ahead of everyone else. I=E2=80=99m looking for=
ward
> to seeing your code and use cases when you are ready.

Don't say it that way, that is not cooperative.
We've only deployed a limited BPF-based memcg async reclaimer
internally, and it is currently scoped to our own workloads.

--=20
Regards
Yafang

