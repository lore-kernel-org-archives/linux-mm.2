Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7993ED58E6F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 06:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 675C16B0005; Mon,  2 Mar 2026 01:58:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 623D76B0089; Mon,  2 Mar 2026 01:58:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DACD6B008A; Mon,  2 Mar 2026 01:58:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3A76B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 01:58:56 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BDB3513B12C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:58:55 +0000 (UTC)
X-FDA: 84500220630.29.769B59C
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id D1F4A80009
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:58:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RgzqbE+x;
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772434733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5lr6tdfosE8S1wzOI+Jz+/WCFAH+CTWQq3qbbqfW4/M=;
	b=z2vPSsA+UrcO/+WtzY/+/qGcVNEt4K1JyRBWychMx+9xxmTkELoLf87FZQzuk2qLH6ATFb
	z3LK0gVMZyqTVd1SVRDKzEslZl19NRWTyGUfy9SFYVI+DbMZKNzDoWxRijaJmyuxaUzYKj
	ZoD9dnFBNJPKD9ydsTFF3wlje6X250A=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772434733; a=rsa-sha256;
	cv=pass;
	b=fSpqKuBYdxHL/4WY0tcFNiC27wXmp1xXDaU8vffw4cJdnDlnuAcpBsWqvB9wJgx1whLizd
	PYE3pWjRpLBt32rr9I47ExGQ0QMNetKU3fK6b+eEMCMheFk01HJEOe0ujMdLE+pzGzWZhZ
	ChhxhttMh3WH2U3jM3IKpMWb0qjW0dM=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RgzqbE+x;
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-89a018cbbf8so2056266d6.0
        for <linux-mm@kvack.org>; Sun, 01 Mar 2026 22:58:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772434733; cv=none;
        d=google.com; s=arc-20240605;
        b=QCcdFb/0MMoTvvjK4TuBf12z0SfYbrXkwjHkGr9eKFJZGSBFNIBwyJLoPpIB8ZDRws
         AytJdO+jznfz9kSulZfUdw201PClY22mZGuG9Wvaav2WzFkC7WLilq/0PdBnYL597ape
         pNPVEgTIZpsKyJj/SsvRhxthjClMb23QBNBtgYCfzBO3jG2hQK+krHEmsoZ7NHZ3tzDL
         +ZeT6vwr4cKemWVFGbPRXfGqeGltOF2HWYW25VqsqOH0zcfBdrgjxO2a94fBQfV0tYyd
         1hl6Q7ba50ExuECFgZM4gBS8knhSNbWm5HC2WrRHIpK87ozn7KukZuefdhudxEM9/zTA
         RkDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5lr6tdfosE8S1wzOI+Jz+/WCFAH+CTWQq3qbbqfW4/M=;
        fh=jN5MmzFMk7XKjqn9VPWJ/euOezFdUbZea2o9lCaXg7M=;
        b=SGCGYnxrRBbHBjrUn3Hm26c5VrU4Ihx1/h+7SAy7YlxQ7Q8sVAkY8VW7Um/4lcDuL7
         68v/JyxCOllliaB8BSHn4LFikG4e4AGt9OeVyWVIGszD/vKBTKF7qiaZajL5xfnHVDzH
         E4OLSdti5mWOEP4AIt0+pYnm2diVo9Sp4kT0YlmSk81TIHx4LxhDyT+uGl26w371sJyA
         rwgWbfyi20/5AfncmmQ6njlFmLEItG/fE+/hdUYK46JLfc+zY1v+K5O/jGmgz/EDYveR
         SCtNiHZ6hcLq34J6b96/Txvg99rTvGxWsXxBapjKWaBiVwCWUA+XCkAGB7X0g8DRQ/Ba
         P+3Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772434733; x=1773039533; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5lr6tdfosE8S1wzOI+Jz+/WCFAH+CTWQq3qbbqfW4/M=;
        b=RgzqbE+xQSRi71j5w4+FpftTeg89bpG12wP60y4muOTq8VPlkGkC+2/MrATs4NFUWR
         c1T+o/IP3/yVGCvJEBsIsbG8WHCIoadCtW3V289moIvZ+FywFp9nnqQiSYYaBy+PWaMa
         ytG1SM1Lwe7vOJZY6BNxlHRftNYGn+u3y/ECPYC9YviAhzwM6fFynP4WBsJveQRJLv30
         73ObmX/9js0Zhl1go0hzrflAFKZ1WSW4TA9I0Lmx/J8Q2nm4NW0iDN/ZlO8mckWu8WaB
         v6jjq+4Lhu5+SEGE4M8IXUB5kGl7bVZ7/NPHiQ1JWw2nXDWiTpXsHaPU6job4bUj5WZ0
         22rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772434733; x=1773039533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5lr6tdfosE8S1wzOI+Jz+/WCFAH+CTWQq3qbbqfW4/M=;
        b=kke7+BSN29Nv1Nd6VLZQmmYj8bCGTTBey2P0X5dgESVSCqIsjuj2dzqnmPXh+e/iJ2
         /LTzgMCW1h2iZ+aujPo8kjhaVBEmgwvtYnIBdQY1EDfXQDotKO7E8OWPAP0HS7EOYxBH
         71YE9F3xMRHmNWwDaHYOAoHOK/fRdwgirtO5DyNQerk7O6/kNb0PCyC/VwbfgJHDUtGC
         i5y3067g6FRvxiqiT72eDXYhLB6BtWGe4GB3elQb8Ea37o0bpF454ukhBkRdqfLD6Vdm
         joGW+IoyeeQyiPhpd5I3WG8RtM2sft2fPQWAkI7ZxD7z+To7GMy3CtYoZ2/+qySER9ak
         VtuA==
X-Forwarded-Encrypted: i=1; AJvYcCWUfAMlhtskYsHtDEEICUFWQAihoYv5tk2Lp40klRHdjsAwihv9UvavN5O/asyfZGW3u5VhityOTg==@kvack.org
X-Gm-Message-State: AOJu0YxWGAcco/AnQ5GbY5EyeAP//L6krkoy9ieiyvhtIKoUD+vkKxx5
	KzP/UghSBsgZ9Po9LvNpCBycFbyH5aNOZ4sHUMJMgpjcVusY0JC01Gfl3E9GFs7Anj4eh8Ex263
	ElPSmkzcq407DShtZ0NWJS5tiOyRu91K90lZy
X-Gm-Gg: ATEYQzwhuNYtBnfMBU77i9W/OyvpTNi64t/ikneLoxsJ91rKBVgAsmFjMYMpD7YJBeD
	Ab3+u3YB2Z8UKn6yGNLqB3DX+02X/oTX6IGMHI9p08nEJhrwqFCilsFRuMRJE9lPlfyJqqs4sDD
	Ayd4504WiEOCIpRigUEeg608n6I+oC1TSvegt28nRskUOUE1UfFuEv3QnsaeDkg+6fpfOHAsIrl
	JCz1dwQ2JAPNLRcO34aT3kgmn7yYybtgtKolcodATE4mBArvb86Q1nX11knOCvdRSWrH7t8nsN/
	a+aKlQ==
X-Received: by 2002:a05:6214:21ce:b0:899:b12e:2362 with SMTP id
 6a1803df08f44-899c6837498mr206633866d6.35.1772434732415; Sun, 01 Mar 2026
 22:58:52 -0800 (PST)
MIME-Version: 1.0
References: <20260228161008.707-1-lenohou@gmail.com> <20260228212837.59661-1-21cnbao@gmail.com>
 <CALOAHbBKr5ni=Ap2ASq2hx041WAghd+CzqbXGBSFPExBMJzcUg@mail.gmail.com>
In-Reply-To: <CALOAHbBKr5ni=Ap2ASq2hx041WAghd+CzqbXGBSFPExBMJzcUg@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 2 Mar 2026 14:58:41 +0800
X-Gm-Features: AaiRm50M3GfLG3-IWgFuiB0HBir2wWPgIvL3nU0LTF9WTFH0hHb9R1bqhRLDfV4
Message-ID: <CAGsJ_4xA3tApXCs2S-sZh2qA9RK_1masQ7nb1NYyCHXwnP9FAQ@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Yafang Shao <laoar.shao@gmail.com>
Cc: lenohou@gmail.com, akpm@linux-foundation.org, axelrasmussen@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, weixugc@google.com, 
	wjl.linux@gmail.com, yuanchu@google.com, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4seeaqz6qct8ektrmi5yf43enh5msuz3
X-Rspam-User: 
X-Rspamd-Queue-Id: D1F4A80009
X-Rspamd-Server: rspam12
X-HE-Tag: 1772434733-597902
X-HE-Meta: U2FsdGVkX18jHYAhtyomoNFVq+xTlD6EbFMyr0LJmmHPo+PCTSjcdnJ9BKmDwqUBEHs54lXGsRiLY/IpxFwjfe/PuNzoeMkxcstIViGXnPeOWr0z8RjBA6bNIawlVtdOHfioG5bIUcrmoF0G/U/lFsqksqDO6e/zhj4k1nGm290rGYBMUpZphHefrnNtw66gFa1aZDxBRlRq1IQnYRBw6DLsrSj4CskE0wh9wZOPlKOabd2DjVGnW//xpmoBHyxuZFk4WTg3nd0rQm7DhUlp6ZUGhY1SqmoK+FYH2X+UUH48wz4USJzthLMSGLqMGsqizwrgTcFpC2uxz84iFh2NKoV8L1T1/KgPQRx10rQfettB8512yNC5EilQCGLBuiXQusBmIvbiziaXZBy8sEe3JoFfodiQtTOxwHdkI/Atv6//4/54o+w1A8ggFPRxlK6KorJOi2uqdjbDFYFMlJCx71ryNhdaUzrlWLl1GMMTk+Zeq/z0PsosMMQkM9kUxYyvCg5KZDeojlXXbuW7A/tqHqmGONZCmpeaBq3xrOyTMQlOMTKdDt7Hv30ebr5W2FssAwev856laA/q5KoEeyzmQ2GpN6FPkFC0jdlPQo93Fuey6rof+bClUkWbZN+8PsxWV+y4pMTfHviirNYZd7WqYp8jEAagQL7FM6c1VyLUQ3uUP3u6mwmluG7LBmptCiNVLGT8aK3oxArBtx5rQaQ/EwiAo7UllPGna0NklrzkuKEkvVR2HmZwx069jXsAB1lWHOoB48JPKccLjCriCxcyzFvuWgiXR+28xWbO8FKd/cah7Pdh6GUqvfw/n5jyshLCLrF4kK7zpiRPGkIosswZvMx3a6OJxmaprf1CuowGMoIAisvtaVXhizVBlAO+sxJX/Xp2jNMTUaXnN5I5V01QRodausWyN/fRsUCePbY6FnYgZJ6Rh2XRKgFAa4uFR1OSYc0c/eupTxbHuNfvWya
 WKt/k+SU
 VGqGclUkFVzALSLhYHvpjUmMr+Rn3FlGs47nQz/lFndjez3tz+4M6RO8bG9tDZuWT8bo3vHUcOXw8xmqaV4qJg6YpAjWlqgBNsRQl0sfWk+GyvoukSCldfdFc9OamgWqer7tlv2REQsEasJ+hN2PKKbkPHYrgatL3jUWNUVmPFWBN891WHzow7RcOxBd0vjTqK5zU/YKWxwBS32+Hlq0pyot3Q0kKl9LrxwfrvtCHb1TNeYIp+VF3StU86QQxjkUdbxCQGgEgQXox4PUGxB2KWq9gks/wYDFuek5FqnHqbJK4p4FjifRTrEA249Hq2gejciwzNNp9MxG9L7LZZYM6mjiGoH8RT9A+ut7KVY8k7yaw7iiB3mbFO+5Ze5628npasytNFgUR5Yxx3S++okuy5VvyscHXp1GlxH0TLYy/f9oV4oWmZAP7TPkatBosjIBX/jJOCIOG4ZBuwnawYDBQKsgDmqG2T6xhcKUJunRM9OCaMViJBvhHB3TkBI0SGOql59V2I6LnVxIK79G6yjp5Kww0US2vYNHjzLoTt8GIpa/tcwXLpc1x/MSIwjUr3hYvp5Twa8gOudH3s/t3Bb87U+dTWVhnbmReD2ZFG7ISGHyvqcEIgP6kGFUaGsIkuNx6QdXoczqXTED5O16op5zmXvNoaEZLoVL5yciayJFQYjdnz1mHonTatQOpwsCWdC49tyBBigAGwjpNU74=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 1:50=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> w=
rote:
>
> On Sun, Mar 1, 2026 at 5:28=E2=80=AFAM Barry Song <21cnbao@gmail.com> wro=
te:
> >
> > On Sun, Mar 1, 2026 at 12:10=E2=80=AFAM Leno Hou <lenohou@gmail.com> wr=
ote:
> > >
> > > When the Multi-Gen LRU (MGLRU) state is toggled dynamically, a race
> > > condition exists between the state switching and the memory reclaim
> > > path. This can lead to unexpected cgroup OOM kills, even when plenty =
of
> > > reclaimable memory is available.
> > >
> > > *** Problem Description ***
> > >
> > > The issue arises from a "reclaim vacuum" during the transition:
> > >
> > > 1. When disabling MGLRU, lru_gen_change_state() sets lrugen->enabled =
to
> > >    false before the pages are drained from MGLRU lists back to
> > >    traditional LRU lists.
> > > 2. Concurrent reclaimers in shrink_lruvec() see lrugen->enabled as fa=
lse
> > >    and skip the MGLRU path.
> > > 3. However, these pages might not have reached the traditional LRU li=
sts
> > >    yet, or the changes are not yet visible to all CPUs due to a lack =
of
> > >    synchronization.
> > > 4. get_scan_count() subsequently finds traditional LRU lists empty,
> > >    concludes there is no reclaimable memory, and triggers an OOM kill=
.
> > >
> > > A similar race can occur during enablement, where the reclaimer sees
> > > the new state but the MGLRU lists haven't been populated via
> > > fill_evictable() yet.
> > >
> > > *** Solution ***
> > >
> > > Introduce a 'draining' state to bridge the gap during transitions:
> > >
> > > - Use smp_store_release() and smp_load_acquire() to ensure the visibi=
lity
> > >   of 'enabled' and 'draining' flags across CPUs.
> > > - Modify shrink_lruvec() to allow a "joint reclaim" period. If an lru=
vec
> > >   is in the 'draining' state, the reclaimer will attempt to scan MGLR=
U
> > >   lists first, and then fall through to traditional LRU lists instead
> > >   of returning early. This ensures that folios are visible to at leas=
t
> > >   one reclaim path at any given time.
> > >
> > > *** Reproduction ***
> > >
> > > The issue was consistently reproduced on v6.1.157 and v6.18.3 using
> > > a high-pressure memory cgroup (v1) environment.
> > >
> > > Reproduction steps:
> > > 1. Create a 16GB memcg and populate it with 10GB file cache (5GB acti=
ve)
> > >    and 8GB active anonymous memory.
> > > 2. Toggle MGLRU state while performing new memory allocations to forc=
e
> > >    direct reclaim.
> > >
> > > Reproduction script:
> > > ---
> > > #!/bin/bash
> > > # Fixed reproduction for memcg OOM during MGLRU toggle
> > > set -euo pipefail
> > >
> > > MGLRU_FILE=3D"/sys/kernel/mm/lru_gen/enabled"
> > > CGROUP_PATH=3D"/sys/fs/cgroup/memory/memcg_oom_test"
> > >
> > > # Switch MGLRU dynamically in the background
> > > switch_mglru() {
> > >     local orig_val=3D$(cat "$MGLRU_FILE")
> > >     if [[ "$orig_val" !=3D "0x0000" ]]; then
> > >         echo n > "$MGLRU_FILE" &
> > >     else
> > >         echo y > "$MGLRU_FILE" &
> > >     fi
> > > }
> > >
> > > # Setup 16G memcg
> > > mkdir -p "$CGROUP_PATH"
> > > echo $((16 * 1024 * 1024 * 1024)) > "$CGROUP_PATH/memory.limit_in_byt=
es"
> > > echo $$ > "$CGROUP_PATH/cgroup.procs"
> > >
> > > # 1. Build memory pressure (File + Anon)
> > > dd if=3D/dev/urandom of=3D/tmp/test_file bs=3D1M count=3D10240
> > > dd if=3D/tmp/test_file of=3D/dev/null bs=3D1M # Warm up cache
> > >
> > > stress-ng --vm 1 --vm-bytes 8G --vm-keep -t 600 &
> > > sleep 5
> > >
> > > # 2. Trigger switch and concurrent allocation
> > > switch_mglru
> > > stress-ng --vm 1 --vm-bytes 2G --vm-populate --timeout 5s || echo "OO=
M Triggered"
> > >
> > > # Check OOM counter
> > > grep oom_kill "$CGROUP_PATH/memory.oom_control"
> > > ---
> > >
> > > Signed-off-by: Leno Hou <lenohou@gmail.com>
> > >
> > > ---
> > > To: linux-mm@kvack.org
> > > To: linux-kernel@vger.kernel.org
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: Axel Rasmussen <axelrasmussen@google.com>
> > > Cc: Yuanchu Xie <yuanchu@google.com>
> > > Cc: Wei Xu <weixugc@google.com>
> > > Cc: Barry Song <21cnbao@gmail.com>
> > > Cc: Jialing Wang <wjl.linux@gmail.com>
> > > Cc: Yafang Shao <laoar.shao@gmail.com>
> > > Cc: Yu Zhao <yuzhao@google.com>
> > > ---
> > >  include/linux/mmzone.h |  2 ++
> > >  mm/vmscan.c            | 14 +++++++++++---
> > >  2 files changed, 13 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > index 7fb7331c5725..0648ce91dbc6 100644
> > > --- a/include/linux/mmzone.h
> > > +++ b/include/linux/mmzone.h
> > > @@ -509,6 +509,8 @@ struct lru_gen_folio {
> > >         atomic_long_t refaulted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_T=
IERS];
> > >         /* whether the multi-gen LRU is enabled */
> > >         bool enabled;
> > > +       /* whether the multi-gen LRU is draining to LRU */
> > > +       bool draining;
> > >         /* the memcg generation this lru_gen_folio belongs to */
> > >         u8 gen;
> > >         /* the list segment this lru_gen_folio belongs to */
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 06071995dacc..629a00681163 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -5222,7 +5222,8 @@ static void lru_gen_change_state(bool enabled)
> > >                         VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
> > >                         VM_WARN_ON_ONCE(!state_is_valid(lruvec));
> > >
> > > -                       lruvec->lrugen.enabled =3D enabled;
> > > +                       smp_store_release(&lruvec->lrugen.enabled, en=
abled);
> > > +                       smp_store_release(&lruvec->lrugen.draining, t=
rue);
> > >
> > >                         while (!(enabled ? fill_evictable(lruvec) : d=
rain_evictable(lruvec))) {
> > >                                 spin_unlock_irq(&lruvec->lru_lock);
> > > @@ -5230,6 +5231,8 @@ static void lru_gen_change_state(bool enabled)
> > >                                 spin_lock_irq(&lruvec->lru_lock);
> > >                         }
> > >
> > > +                       smp_store_release(&lruvec->lrugen.draining, f=
alse);
> > > +
> > >                         spin_unlock_irq(&lruvec->lru_lock);
> > >                 }
> > >
> > > @@ -5813,10 +5816,15 @@ static void shrink_lruvec(struct lruvec *lruv=
ec, struct scan_control *sc)
> > >         unsigned long nr_to_reclaim =3D sc->nr_to_reclaim;
> > >         bool proportional_reclaim;
> > >         struct blk_plug plug;
> > > +       bool lrugen_enabled =3D smp_load_acquire(&lruvec->lrugen.enab=
led);
> > > +       bool lru_draining =3D smp_load_acquire(&lruvec->lrugen.draini=
ng);
> > >
> > > -       if (lru_gen_enabled() && !root_reclaim(sc)) {
> > > +       if (lrugen_enabled || lru_draining && !root_reclaim(sc)) {
> > >                 lru_gen_shrink_lruvec(lruvec, sc);
> > > -               return;
> >
>
> Hello Barry,
>
> > Is it possible to simply wait for draining to finish instead of perform=
ing
> > an lru_gen/lru shrink while lru_gen is being disabled or enabled?
>
> This might introduce unexpected latency spikes during the waiting period.

I assume latency is not a concern for a very rare
MGLRU on/off case. Do you require the switch to happen
with zero latency?
My main concern is the correctness of the code.

Now the proposed patch is:

+       bool lrugen_enabled =3D smp_load_acquire(&lruvec->lrugen.enabled);
+       bool lru_draining =3D smp_load_acquire(&lruvec->lrugen.draining);

Then choose MGLRU or active/inactive LRU based on
those values.

However, nothing prevents those values from changing
after they are read. Even within the shrink path,
they can still change.

So I think we need an rwsem or something similar here =E2=80=94
a read lock for shrink and a write lock for on/off. The
write lock should happen very rarely.

>
> >
> > Performing a shrink in an intermediate state may still involve a lot of
> > uncertainty, depending on how far the shrink has progressed and how muc=
h
> > remains in each side=E2=80=99s LRU=EF=BC=9F
>
> The workingset might not be reliable in this intermediate state.
> However, since switching MGLRU should not be a frequent operation in a
> production environment, I believe the workingset in this intermediate
> state should not be a concern. The only reason we would enable or
> disable MGLRU is if we find that certain workloads benefit from
> it=E2=80=94enabling it when it helps, and disabling it when it causes
> degradation. There should be no other scenario in which we would need
> to toggle MGLRU on or off.
>
> To identify which workloads can benefit from MGLRU, we must first
> ensure that switching it on or off is safe=E2=80=94which is precisely why=
 we
> are proposing this patch. Once MGLRU is enabled in production, we can
> continue to improve it. Perhaps in the future, we can even implement a
> per-workload reclaim mechanism.

To be honest, the on/off toggle is quite odd. If possible,
I=E2=80=99d prefer not to switch MGLRU or active/inactive
dynamically. Once it=E2=80=99s set up during system boot, it
should remain unchanged.

If we want a per-workload LRU, this could be a good
place for eBPF to hook into folio enqueue, dequeue,
and scanning. There is a project related to this [1][2].

// Policy function hooks
struct cache_ext_ops {
       s32 (*policy_init)(struct mem_cgroup *memcg);
       // Propose folios to evict
       void (*evict_folios)(struct eviction_ctx *ctx,
                 struct mem_cgroup *memcg);
       void (*folio_added)(struct folio *folio);
       void (*folio_accessed)(struct folio *folio);
       // Folio was removed: clean up metadata
       void (*folio_removed)(struct folio *folio);
       char name[CACHE_EXT_OPS_NAME_LEN];
};

However, we would need a very strong and convincing
user case to justify it.

[1] https://dl.acm.org/doi/pdf/10.1145/3731569.3764820
[2] https://github.com/cache-ext/cache_ext

Thanks
Barry

