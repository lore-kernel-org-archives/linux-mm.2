Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15AD9CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 09:15:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 710266B0005; Wed, 27 May 2026 05:15:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0D96B008A; Wed, 27 May 2026 05:15:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D7386B008C; Wed, 27 May 2026 05:15:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CA026B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:15:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF2FA1C1B25
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:15:22 +0000 (UTC)
X-FDA: 84812641284.15.9DAC3C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1369B20004
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:15:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kgN/gW/0";
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779873321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWLhOshNYXJ9MO4UiSCvJmB+rzzBwZ7KkJGnpJlz67E=;
	b=Iw7T/XyyZmp5tIDXlVOLiHegZ98Kol2r2UeYUcl2QU4RLL6QyCjThHMAisDBYjyIJ7ku+r
	OyuTpCQaN9FPRMhlsOT7WsHBhjj93LZE9GjnvsJXmDkmxofGvK5NhX1b7faQ3AUeNJ6OAY
	m4mqKZ1vbDK+tUTsbFRfla8oBtvW6Pw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779873321; a=rsa-sha256;
	cv=none;
	b=jXHrURWrFNSk20Po7pRWj9XI3DD9YdlAbMHWGhMEmT+DH31Nss2FhD5gJ+MZ6hGikEErZ9
	r2T+tqSlN07jpMcjbYSLITTtkN1EJSqCQ6MPFvlTItDoD7g6b/wXSCH1DhwEVVwqYtHFSr
	zuz/Qobc6Q6ICh37sJTXAyXvW3g9eoQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kgN/gW/0";
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 85894600B0
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F781F0155C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779873320;
	bh=HWLhOshNYXJ9MO4UiSCvJmB+rzzBwZ7KkJGnpJlz67E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kgN/gW/0xKEGmTrTcfYHn5OZLh8T92/l4OEPvlvT+nmh5BBiiHWn/KrqFAUdOudXT
	 GH8FuVSEaTskOZyLOgxy6QuR+Qm+S5fH7Hcm4ZnIcelkAOQQgHAZtD88UbFLK1xL3g
	 hkAeqcxK4fo46UONYG8CW/eQrX2jlewoWbMUo00jCtMaVB2X3n4/UA4zjNLJFOzRJT
	 Up1/NAYEa8xpYK6HI4wWdwXfqVtaVK/Lj0sg5z0TX8WdsA7iLn3nuyS2TXEkNbBayr
	 o14SXM+uYDaDX0ucVQJzCz7u6GQDyBGcuInHRHifFFtagh26LRfT89nMCqXDqNfkPI
	 BEHHNVehFtqEg==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-90fbf21d9d3so1739806285a.1
        for <linux-mm@kvack.org>; Wed, 27 May 2026 02:15:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+LyQ7rAQkpgLYTMgGGN+brl/1vOtbfpmApjm4akj9EYuOXCpjPLnX9+firCTaHhk+orC15Lgou2w==@kvack.org
X-Gm-Message-State: AOJu0YyUzYfMntuwWChHRc88Az2oYD/Ma5ORV4ZHz1CDEIXcJcPkZzbm
	T+eGjAw77HfcZtzCsQSI0OPsA3f3NfYHejGrg8g/y75dalurKR7kr3rilFWMZwTsHHwiuBu1KAY
	DJG3JIGK7hlXVk5S5DACuJAVxgtkE09Y=
X-Received: by 2002:a05:620a:28c8:b0:910:896e:dd56 with SMTP id
 af79cd13be357-914b49ab2b4mr3181008185a.51.1779873319512; Wed, 27 May 2026
 02:15:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260527085622.1298437-1-zhaoyang.huang@unisoc.com>
In-Reply-To: <20260527085622.1298437-1-zhaoyang.huang@unisoc.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 27 May 2026 17:15:07 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zVu=XooHPzOVtNRV8iV0CEKM0rBwqUBBxfoxiZS-g4-g@mail.gmail.com>
X-Gm-Features: AVHnY4JXOLsnZ8m4_0ni8qRkZtl-wA-548ICjABCkWlR1rF4VzRWpzP1wP3NUIc
Message-ID: <CAGsJ_4zVu=XooHPzOVtNRV8iV0CEKM0rBwqUBBxfoxiZS-g4-g@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/mglru: improve positive_ctrl_err for low refault samples
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Zhaoyang Huang <huangzhaoyang@gmail.com>, 
	steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: im47hodj5axzte3agjc185xkk18kfdfs
X-Rspamd-Queue-Id: 1369B20004
X-Rspam-User: 
X-HE-Tag: 1779873320-879713
X-HE-Meta: U2FsdGVkX1/aGt6ipDmofto6RQ0faUwVYWCxAgECqg/8eKSmYC//IWFL4+rfAAdADAYEmvz3S/U6QqZmxWpdrZ7wBRea3HVM9KoE2SlEVGVmZOTPCNUPqI4DU0F5F9I4O5FzkwfgUwCTmxar3+pJG3MiHoWJ1XTaLlfVR+FVHN+RLTDND3rI/ekNGm/UStZuGVM065RrqhP8LxO1lReataLHhOjMoixuh+xdnIGfK56lUKrp8IGba3yRv0XBmMs/xHRDv1Ug2G50P58NnV89IpZaa1qft3IkD1b+oU7fQR5eG20z2hE5kxU76tuEw5E7qhnm4Knb+aQRtQ0jknU5IKDIyeKfoXyyEIl7DE9sIzI6f8K3BQEN/kXsGzhOxzZ6FBUojXQVptaCyUR8GVzAJSxuOP1dMdxI1lzP+uH+8V9RhIDllVEuZ5B6ym1YAIGjFoRDW8tq6gjm3PZ2VLQRCbK5SuaJlLWNCPsjuzvOO1SutZzmM4DiHqeWV2s43jw8YB7G3iB1U2hH4XrKTWXDKTc3fDe7g2E7Qu8gr8UYdODDwd6JhPFIA02gXnUTwhOlimrO/XB/PlzZKDCAq32SCAzJGLzvEiWeR/qh15sfrfew5OfYSvbBEWiP554vYijskG/H7wP46M5tv9CAFQkwHrGxP7zuBdQsFwVSdvaSWdUFNIlS1Q7ULgB+lbLDa/1MfzlkS2SLT1yTTr/xfj9BDdDXnqUEIqOE1LbBNF1K6591jEXDrTUVTpoSDEk1T5s51AxzOVNtGyEq0PdDEc12zW7z6DWTDT0u7+nPWPa66BwsOFUFX2w/LlJh8WsbGAN/aLKulOL2rcV3dSIOsO2Ig5PLVPInpMWzRPewh1J5XKADYfkIDb1ysw09Hn/ETk6xupC3mecoDHmRv4GBdeWeh7qs6xqGKZd4AN+6IS0vTdCeipA/ph+dVpbLKoclVhfehO8tKZlJJXP+sjCt7Ya
 55xZ/2lA
 UdZqHc/vFU5IhIqdkTf4oUgGPV4FEXYcRCM3c2QpEUTjCgiuPS17usshz65u8VXs9oUwXKh61BOnwh6FoR2WJW9PBDNUb1vdKXI3y7Gkf6gWCuGCDmgxq3rgEkPKV43YRzD4J7N4nhfa78yR8EjJZqXlFgOPjhMkeUAVxHX/UEyhQecrbup+HJpMvlCT2aWBBfMeNAh2J3ilsvfb6zKje8sWrcDsffGJK3PaoJhnfZ+7mN/JOvunugMThotuPc/UKvxBTcbvTBd/xCO5pPxKNVpyUaHnnVZqbyBH0aVdUSmR70R3nirEKs3nA+M2PqUg1espZh44pQw7IxQKIuLe2XZk2hpeSUw12152A/dxq7mlBks3mTbLWBuTibrr+g4xGuI+s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 4:57=E2=80=AFPM zhaoyang.huang
<zhaoyang.huang@unisoc.com> wrote:
>
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>
> The memory.stat under per-pid memcg & MGLRU[1] observed in android
> system which means current type selection by judging the refault rate
> almost failed since file page's refault count remains 0 which will
> shortcut to file by 'pv->refaulted < MIN_LRU_BATCH'. The reason could be
> both of small lruvec size and bypass of the file refault count when it
> refaulted in another memcg.
> Refine the MGLRU PID comparison when lruvecs lack enough refault
> statistics, using gain-aware fallbacks which is simply respect the
> swappiness and historical integral value without affecting the usual
> refault-rate path under sustained reclaim pressure.
>
> [1]
> /sys/fs/cgroup/apps/uid_10123/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1123 steal_direct=3D32=
 pgactive=3D58
> /sys/fs/cgroup/apps/uid_10136/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D2491 steal_direct=3D64=
 pgactive=3D48
> /sys/fs/cgroup/apps/uid_10237/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1355 steal_direct=3D0 =
pgactive=3D1
> /sys/fs/cgroup/system/uid_1002/memory.stat: refault_anon=3D3 active_anon=
=3D1 refault_file=3D0 active_file=3D0 steal_kswapd=3D1162 steal_direct=3D4 =
pgactive=3D3987
> /sys/fs/cgroup/system/uid_1027/memory.stat: refault_anon=3D1 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1157 steal_direct=3D14=
 pgactive=3D1517
> /sys/fs/cgroup/system/uid_1037/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1461 steal_direct=3D0 =
pgactive=3D247
> /sys/fs/cgroup/system/uid_1046/pid_1251/memory.stat: refault_anon=3D0 act=
ive_anon=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1643 steal_dir=
ect=3D18 pgactive=3D2914
> /sys/fs/cgroup/system/uid_1047/pid_724/memory.stat: refault_anon=3D0 acti=
ve_anon=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D8924 steal_dire=
ct=3D449 pgactive=3D3753
> /sys/fs/cgroup/system/uid_1047/pid_789/memory.stat: refault_anon=3D0 acti=
ve_anon=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D3864 steal_dire=
ct=3D157 pgactive=3D3062
> /sys/fs/cgroup/apps/uid_10090/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1285 steal_direct=3D32=
 pgactive=3D36
> /sys/fs/cgroup/apps/uid_10123/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1126 steal_direct=3D32=
 pgactive=3D70
> /sys/fs/cgroup/apps/uid_10136/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D2474 steal_direct=3D69=
 pgactive=3D52
> /sys/fs/cgroup/apps/uid_10175/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D3264 steal_direct=3D10=
 pgactive=3D861
> /sys/fs/cgroup/apps/uid_10211/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1447 steal_direct=3D32=
 pgactive=3D21
> /sys/fs/cgroup/apps/uid_10237/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1354 steal_direct=3D0 =
pgactive=3D2
> /sys/fs/cgroup/system/uid_1000/pid_471/memory.stat: refault_anon=3D0 acti=
ve_anon=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1296 steal_dire=
ct=3D4 pgactive=3D65
> /sys/fs/cgroup/system/uid_1002/memory.stat: refault_anon=3D18 active_anon=
=3D3 refault_file=3D0 active_file=3D0 steal_kswapd=3D1286 steal_direct=3D4 =
pgactive=3D3979
> /sys/fs/cgroup/system/uid_1037/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1462 steal_direct=3D0 =
pgactive=3D246
> /sys/fs/cgroup/system/uid_1041/memory.stat: refault_anon=3D17 active_anon=
=3D5 refault_file=3D0 active_file=3D0 steal_kswapd=3D4429 steal_direct=3D30=
 pgactive=3D5239
> /sys/fs/cgroup/system/uid_1041/pid_820/memory.stat: refault_anon=3D12 act=
ive_anon=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D2441 steal_dir=
ect=3D17 pgactive=3D2034
> /sys/fs/cgroup/system/uid_1041/pid_839/memory.stat: refault_anon=3D5 acti=
ve_anon=3D5 refault_file=3D0 active_file=3D0 steal_kswapd=3D1357 steal_dire=
ct=3D10 pgactive=3D2055
> /sys/fs/cgroup/system/uid_1047/pid_1166/memory.stat: refault_anon=3D0 act=
ive_anon=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1577 steal_dir=
ect=3D70 pgactive=3D1130
> /sys/fs/cgroup/system/uid_1047/pid_732/memory.stat: refault_anon=3D0 acti=
ve_anon=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D7661 steal_dire=
ct=3D115 pgactive=3D3681
> /sys/fs/cgroup/system/uid_1047/pid_799/memory.stat: refault_anon=3D0 acti=
ve_anon=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D2847 steal_dire=
ct=3D62 pgactive=3D3573
> /sys/fs/cgroup/apps/uid_10129/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1153 steal_direct=3D18=
 pgactive=3D42
> /sys/fs/cgroup/apps/uid_10136/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D2336 steal_direct=3D21=
0 pgactive=3D49
> /sys/fs/cgroup/apps/uid_10165/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1491 steal_direct=3D43=
 pgactive=3D525
> /sys/fs/cgroup/apps/uid_10175/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D2229 steal_direct=3D10=
8 pgactive=3D863
> /sys/fs/cgroup/apps/uid_10211/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1299 steal_direct=3D16=
3 pgactive=3D23
> /sys/fs/cgroup/apps/uid_10237/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1323 steal_direct=3D32=
 pgactive=3D2
> /sys/fs/cgroup/system/uid_0/pid_1203/memory.stat: refault_anon=3D0 active=
_anon=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D2927 steal_direct=
=3D12 pgactive=3D252
> /sys/fs/cgroup/system/uid_1037/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D1359 steal_direct=3D34=
 pgactive=3D253
> /sys/fs/cgroup/system/uid_1047/memory.stat: refault_anon=3D0 active_anon=
=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D4269 steal_direct=3D55=
 pgactive=3D6308
> /sys/fs/cgroup/system/uid_1047/pid_721/memory.stat: refault_anon=3D0 acti=
ve_anon=3D0 refault_file=3D0 active_file=3D0 steal_kswapd=3D2745 steal_dire=
ct=3D44 pgactive=3D2761

Yes.

I agree that the current positive_ctrl_err() has some issues
that could be improved. But could you describe the user-visible
behavior affected by your patch? For example, does it improve
swappiness behavior? Does it eliminate the over-protection of
anon memory?

>
> Assisted-by: Cursor:GPT-5.x
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> ---
>  mm/vmscan.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 52 insertions(+), 4 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bd1b1aa12581..5fecfaa392d8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3179,14 +3179,62 @@ static void reset_ctrl_pos(struct lruvec *lruvec,=
 int type, bool carryover)
>         }
>  }
>
> +/*
> + * positive_ctrl_err() - return true if SP is hotter than PV
> + *
> + * Drives MGLRU type and tier selection in get_type_to_scan() and
> + * get_tier_idx(). A true return means the setpoint is hotter than the p=
rocess
> + * variable and reclaim should favor the other type or a higher tier.
> + *
> + * With reliable refault statistics on both sides, compare refault rates=
. That
> + * path dominates on large lruvecs under sustained memory pressure, incl=
uding
> + * the node-level lruvec when memcg is disabled.
> + *
> + * Small memcg leaf lruvecs often lack reliable refault statistics: few =
pages,
> + * infrequent reclaim, and counters reset on generation advance. Treatin=
g a
> + * low PV refault count as unconditional evidence that SP is hotter igno=
res
> + * swappiness and tier gain and confuses "no samples yet" with "cold". U=
sing
> + * the rate comparison when only SP lacks samples skews the ratio. The
> + * low-sample paths below apply gain-aware fallbacks and apply defaultin=
g to SP
> + * is hotter when neither side has eviction history.
> + */

I assume the new algorithm and the above comment were generated
by AI. Could you rephrase them in more human-understandable
language?

>  static bool positive_ctrl_err(struct ctrl_pos *sp, struct ctrl_pos *pv)
>  {
> +       unsigned long pv_ref =3D pv->refaulted;
> +       /* Used by the rate comparison (SP only) and the total fallback (=
both). */
> +       unsigned long sp_total =3D sp->total + MIN_LRU_BATCH;
> +       unsigned long pv_total =3D pv->total + MIN_LRU_BATCH;
> +
> +       /* Both sides: compare refault rates. */
> +       if (sp->refaulted >=3D MIN_LRU_BATCH && pv->refaulted >=3D MIN_LR=
U_BATCH)
> +               goto compare_rates;
> +
> +       /*
> +        * SP only: PV refault count is not statistically meaningful; tre=
at PV
> +        * refaults as zero and use the rate comparison (yields SP hotter=
).
> +        */
> +       if (sp->refaulted >=3D MIN_LRU_BATCH) {
> +               pv_ref =3D 0;
> +               goto compare_rates;
> +       }
> +
> +       /* PV only: trust PV refault signal; SP is not hotter. */
> +       if (pv->refaulted >=3D MIN_LRU_BATCH)
> +               return false;
> +
> +       /* Neither side has eviction history, pv is colder */
> +       if (!sp->total && !pv->total)
> +               return true;
> +
> +       /* Neither side has enough refaults: compare gain-weighted totals=
. */
> +       return sp->gain * pv_total <=3D pv->gain * sp_total;
> +
> +compare_rates:
>         /*
> -        * Return true if the PV has a limited number of refaults or a lo=
wer
> -        * refaulted/total than the SP.
> +        * Rate comparison with margin on SP total and refault only; PV t=
otal is
> +        * not padded so a meaningful PV refault rate is preserved when s=
ampled.
>          */
> -       return pv->refaulted < MIN_LRU_BATCH ||
> -              pv->refaulted * (sp->total + MIN_LRU_BATCH) * sp->gain <=
=3D
> +       return pv_ref * sp_total * sp->gain <=3D
>                (sp->refaulted + 1) * pv->total * pv->gain;
>  }
>
> --
> 2.25.1
>
>

