Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AFBCE88D65
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 21:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 382D46B0005; Fri,  3 Apr 2026 17:16:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3341A6B0088; Fri,  3 Apr 2026 17:16:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FC186B008A; Fri,  3 Apr 2026 17:16:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A89A6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:16:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86DBDC0372
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 21:16:12 +0000 (UTC)
X-FDA: 84618502584.01.6F236F0
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf23.hostedemail.com (Postfix) with ESMTP id A065B14001C
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 21:16:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xq9Wmr+m;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=axelrasmussen@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775250970; a=rsa-sha256;
	cv=pass;
	b=o+1oBavaSGGZMzpjGwF71uMIa82JcSxhE/W9EyYcsa+oaZxTqfGfMDiDs+//rBzH2XaRPa
	cyODpP5F3WI/tHp9e9hyl0O4jjZcUjmuYu9jZxG0P2D7KlsLrBjORXUETPybG4D6UVMwAw
	Agn1I1moHYEru5FlqL4SsW5DVQADGZ8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xq9Wmr+m;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=axelrasmussen@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775250970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WFyaBQJz4cb43d5+TwRld6LjlDIX78FHc0ggAynHuJM=;
	b=aEThAT0CY2hXP7Z7FRgs+sByq2BOVZsy9YDA5hPaS4Pece4SLArxSsX2ccr40sRstYxz99
	DOooit2fF+oD9sSYJGbzVs8y2eiMD9Q2YBvtVMvq/kU2i5qul9fY9O5OgMaxpGVA3dnMMj
	aHh0RgZx1RdKWLEr8WZRPWBgWXXBvYE=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-66baa7fdfd3so10828a12.1
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 14:16:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775250969; cv=none;
        d=google.com; s=arc-20240605;
        b=YJtQuFebpOzNyRS1J1tjTCkhF32Vd4hFd4DMcYfFcZWxFjybZTovusLTTi9/8MVW+O
         +fk8nVIOlaG+EhcHeqXBH4k0O3B9xejT5azQB9oTK9f8V20Tf/dcejm74inoWu01Geng
         HGTqIirwDiI17gEmHgwR5Y1IJT6sWD0QFj29qKESISE3xfFU+0Y/n1WHok9wQgKHJOVs
         VyfgAYGIwI5kz9llw/JrAwHHMV4tFd8B2cVLnc0Law6R2hhDxERTSiWtFlryYjoBhbx9
         ey3C75wIFuF1ucv5cQ1Ylt6Rhjc92YuFNWZei7ziQhVdSb9uKl1IGg4iC0JCDyYPyAJV
         78OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WFyaBQJz4cb43d5+TwRld6LjlDIX78FHc0ggAynHuJM=;
        fh=G3KOVX5TDfwMcAVieiVC4GptR+Yq+B6YJ7T7ds0K6bI=;
        b=ACNycEbOPA+s4dgiEgSiLUFM/nlJ6ZP9mBEpK3yDUsnebOxbs2hwHh22ftO+EVtlq8
         RASgQrb3n0WN3a8kOt71ilGMkpADqUkISEBFpxeAqMEM4DvUJ3Atj7utvnJ/dPzHgC/7
         CJl1bNPt2f/oX+qE5FplYMxrCcaqGqcRUCyg0JKI+BxFOQqH5NcviuG5LIPYm6bOaPR0
         A3mJFT30RQ79euCA3zvR/y+q+CGWPI4zSRGytTQAhHd8GjTLk38Fin4GUzw7tV9WSYJC
         y1wQVXn6nlNwFObduEDuh2LEPON3J75W2Da+i4kZeN24AMgG4aL0b0IpajaYtWfopwby
         gtEw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775250969; x=1775855769; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WFyaBQJz4cb43d5+TwRld6LjlDIX78FHc0ggAynHuJM=;
        b=Xq9Wmr+mJjiQ6/dQ5mHLXCwoVhBQ+AniBdLQYgMbKJK2Pzdf1bpLPp9tpGFnL+sZb1
         KVuuo8RoNzpr4ijvfzk/ew/WTvGvVk3xLZN4LiYnS1GM+CspualkNqgDI4zWl902+YbH
         P7N/UbOB9k2WbL+ZVksgQpLFyzGDc/oMDzB/ZzcnC03lJspbh7lxF7BnV1/+TsrUrbds
         bK7/v2XsKRD96Oh3Pls6oQOo4IgoF1qmCdO8noXtKaE9yNYHm5MB3WMNH+/ttDhQRD2A
         qHgY+KESxTO37UvsXTnKzmYvgQdXgr1ZtTId9VM1D9c/Rpp3OlOe3uInScoyKdzeXjZw
         l/yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775250969; x=1775855769;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WFyaBQJz4cb43d5+TwRld6LjlDIX78FHc0ggAynHuJM=;
        b=J8kAU+bkaoEVpr7bA0GlXVbxdguAdKGYY8DsWRRAa2PyANRHLjXpUCIPy/xeX6TB8b
         9hMAIKrRFrz8ZhZw6cFU+SrDNwhWZdFcKJO7/O7/IZ6Ut1ov+86aer8DWHi6joTDkjL7
         jwbf4qSOjXTYfg8QOwOGJm6pS+bgV+FqN6rLa+stqpt0O5wBPx6kCN/rk7XYedezo3H+
         rdxOHMLmYbBS1ff/cZ+1DZNNzdjsFlMjP2wh3wwlYRRW+uNdpgz0tffclCcHKCCpbG+O
         s8IC03/nIF2TNggDhSvjBeVrPqXeBN8Co/U/BrXDhaOULzOilr7K990yX9YldZSFUATO
         SQug==
X-Gm-Message-State: AOJu0YwKn4CzH6pGYbSxZSNycZzmAzvJeUl/kWdYvoBq1sjRmwfPoOVF
	GC5oQlSkBW1HeS6dIc6vlds0idfanE2/DRwc9fWxDcX0jHkc53IZ6xHe4RsDmjAizVtQbGHp/rz
	mnsYPnGuy6Cy2mzXr+GGI+doraKshLEN1URKFpVhR
X-Gm-Gg: AeBDieu1XMnYNNiS/B8CWQboYWurxcRNJD/8rTUSUOZOUGaJCNHOObITQOXj0MCGTq2
	pwhuuX+6I6Z2dXKUf5SMQKSERjtl4XpVE7knQ03MF453K4y2bwO8fObz9pjhCZIxY/n0os3BwuK
	ff/oaCJCKtFEbSQOuMNu71EpzcgIWTtUthA8XBM/AECnd/zUjMuhFryuvGE/nprCC//jWk4VkNd
	XnA9+OKHxhuKv766agCHor4WA1+vwbmTgs+ASPhFlXV6qoCbGXn1Fu1FUCP1Ar57F8IWFG1dR/6
	KZfKxmXd
X-Received: by 2002:aa7:c457:0:b0:668:c2b6:9fa2 with SMTP id
 4fb4d7f45d1cf-66e43f2e6ccmr30036a12.7.1775250968346; Fri, 03 Apr 2026
 14:16:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com> <20260403-mglru-reclaim-v3-14-a285efd6ff91@tencent.com>
In-Reply-To: <20260403-mglru-reclaim-v3-14-a285efd6ff91@tencent.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Fri, 3 Apr 2026 14:15:32 -0700
X-Gm-Features: AQROBzDmWPDBxI-W1YgX1GnVDHmeLB9kw4K8oORXX3mIOnI5UFIYpjSKmbUPazQ
Message-ID: <CAJHvVcjDXktz-_Nk8qj3jXfLkHhJVo+N2KWb1sA+DvENOMkdDw@mail.gmail.com>
Subject: Re: [PATCH v3 14/14] mm/vmscan: unify writeback reclaim statistic and throttling
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6a4jf5p7o674e8dog65a8icbqkrni3c8
X-Rspamd-Queue-Id: A065B14001C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775250970-86683
X-HE-Meta: U2FsdGVkX18xO0mOL06tRKOvVUctTozPdQylm7beDW9KX+UhWZqp91dFQlN6eNfvBc6PyvPtdZM7Qt6btHMD/eWMqxe2jQipXGVmqMyUKxdAWUJmreH5uTeQ+KToX/EBmsg2jfJ6cmAYXxBwrYhooXr7pNS2lY+AocU/Nk8f9Myhc97IMLxQvn1VG3Dp0iiZDccXdWk85ExP881WylGIDqOxNI1+17w6l6O3gv/TQzuENhMOdKfnhkvpOg6USYQvXavGn7ax33Av57ph9ayZLnChdgmlE6jROGB0BgR3i2y4nedwXEkbCMTI730iWS69a8vP2YB+a2lHi2YN5DEjPSeQZNf8GypTIhXo+qY2mNXL1MGroeu44YC2tGpx4+YntLKtPfB8kumubjNEHppG4RVBM6cxguYjyTC33E3ky1TfSrfHaW/xopkXt5Rz80Dpu4MsoBZyraZf5MxKjMqW5TVtZThVvtfKuYALfSwMSqM0YPIji4pxCajYb0j4InKQJi5FNnJWHPRsX80aST9rPR0iBEZc3nkADRZ7pNTiHNR0/e8uivZprKy9H6VgywFF+091oXELJmss2d5eyRd74VxVnAhrRwRxHvY/1IA+J4thGkE+kM+3o7MtaCwGDgbXTiIXEo4uk9n7K8UE+VP2vg0IM1HdptoQMUVX/vom7tCdozXZFIbR5zRTXW9m1wsSgXhRQVDG6NZG8O4f9VeKVyrbVC491R1dTgV5Fvh+cSt6pIkj7o+W49gqfujxwvip3n14mlovwfDqWn/VnfwsaLx321eY813fb5SHR8/ds+vHFrbOhs2v6iBwEuxhj35s4lgczpm+ou77EbCwZIrbVHSuXHVUwezEFqrB6UTXTJXjOEAAX8YAVRJwexzuVpmci1WGOD9c++W3pzV03izXA/OK3pLgdQmzEYHyJxrvVkHDitR2TG390+eaCrMKDjh+UODk4XEMYEQhaZhE4gj
 Z5WCjqMN
 vt1sJFdQrwKX9I2IXWBgnedqZDE+uAqZYpxw4KzdkcMFbmuTEwJ2V8mPiPiAEeSu6jg7ZsGHBhLjSFYeJAWqBRn8fDEM2LBc7LfgviSRUSaJmlgb4VEPnCTF94tjayonpWDk9qQgn33gJkCs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 2, 2026 at 11:53=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Currently MGLRU and non-MGLRU handle the reclaim statistic and
> writeback handling very differently, especially throttling.
> Basically MGLRU just ignored the throttling part.
>
> Let's just unify this part, use a helper to deduplicate the code
> so both setups will share the same behavior.
>
> Test using following reproducer using bash:
>
>   echo "Setup a slow device using dm delay"
>   dd if=3D/dev/zero of=3D/var/tmp/backing bs=3D1M count=3D2048
>   LOOP=3D$(losetup --show -f /var/tmp/backing)
>   mkfs.ext4 -q $LOOP
>   echo "0 $(blockdev --getsz $LOOP) delay $LOOP 0 0 $LOOP 0 1000" | \
>       dmsetup create slow_dev
>   mkdir -p /mnt/slow && mount /dev/mapper/slow_dev /mnt/slow
>
>   echo "Start writeback pressure"
>   sync && echo 3 > /proc/sys/vm/drop_caches
>   mkdir /sys/fs/cgroup/test_wb
>   echo 128M > /sys/fs/cgroup/test_wb/memory.max
>   (echo $BASHPID > /sys/fs/cgroup/test_wb/cgroup.procs && \
>       dd if=3D/dev/zero of=3D/mnt/slow/testfile bs=3D1M count=3D192)
>
>   echo "Clean up"
>   echo "0 $(blockdev --getsz $LOOP) error" | dmsetup load slow_dev
>   dmsetup resume slow_dev
>   umount -l /mnt/slow && sync
>   dmsetup remove slow_dev
>
> Before this commit, `dd` will get OOM killed immediately if
> MGLRU is enabled. Classic LRU is fine.
>
> After this commit, throttling is now effective and no more spin on
> LRU or premature OOM. Stress test on other workloads also looking good.
>
> Global throttling is not here yet, we will fix that separately later.

If I understand correctly, I think this fixes this regression report
[1] from a long time ago that was never fully resolved?

[1]: https://lore.kernel.org/lkml/ZeC-u7GRSptoVqia@chrisdown.name/

We investigated at that time, but I don't feel we got to a consensus
on how to solve it. I think we got a bit bogged down trying to
"completely solve writeback throttling" rather than just doing some
incremental improvement which fixed that particular case.

>
> Suggested-by: Chen Ridong <chenridong@huaweicloud.com>
> Tested-by: Leno Hou <lenohou@gmail.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 90 ++++++++++++++++++++++++++++---------------------------=
------
>  1 file changed, 41 insertions(+), 49 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9120d914445e..a7b3e5b6676b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1942,6 +1942,44 @@ static int current_may_throttle(void)
>         return !(current->flags & PF_LOCAL_THROTTLE);
>  }
>
> +static void handle_reclaim_writeback(unsigned long nr_taken,
> +                                    struct pglist_data *pgdat,
> +                                    struct scan_control *sc,
> +                                    struct reclaim_stat *stat)
> +{
> +       /*
> +        * If dirty folios are scanned that are not queued for IO, it
> +        * implies that flushers are not doing their job. This can
> +        * happen when memory pressure pushes dirty folios to the end of
> +        * the LRU before the dirty limits are breached and the dirty
> +        * data has expired. It can also happen when the proportion of
> +        * dirty folios grows not through writes but through memory
> +        * pressure reclaiming all the clean cache. And in some cases,
> +        * the flushers simply cannot keep up with the allocation
> +        * rate. Nudge the flusher threads in case they are asleep.
> +        */
> +       if (stat->nr_unqueued_dirty =3D=3D nr_taken && nr_taken) {
> +               wakeup_flusher_threads(WB_REASON_VMSCAN);
> +               /*
> +                * For cgroupv1 dirty throttling is achieved by waking up
> +                * the kernel flusher here and later waiting on folios
> +                * which are in writeback to finish (see shrink_folio_lis=
t()).
> +                *
> +                * Flusher may not be able to issue writeback quickly
> +                * enough for cgroupv1 writeback throttling to work
> +                * on a large system.
> +                */
> +               if (!writeback_throttling_sane(sc))
> +                       reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK=
);
> +       }
> +
> +       sc->nr.dirty +=3D stat->nr_dirty;
> +       sc->nr.congested +=3D stat->nr_congested;
> +       sc->nr.writeback +=3D stat->nr_writeback;
> +       sc->nr.immediate +=3D stat->nr_immediate;
> +       sc->nr.taken +=3D nr_taken;
> +}
> +
>  /*
>   * shrink_inactive_list() is a helper for shrink_node().  It returns the=
 number
>   * of reclaimed pages
> @@ -2005,39 +2043,7 @@ static unsigned long shrink_inactive_list(unsigned=
 long nr_to_scan,
>         lruvec_lock_irq(lruvec);
>         lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
>                                         nr_scanned - nr_reclaimed);
> -
> -       /*
> -        * If dirty folios are scanned that are not queued for IO, it
> -        * implies that flushers are not doing their job. This can
> -        * happen when memory pressure pushes dirty folios to the end of
> -        * the LRU before the dirty limits are breached and the dirty
> -        * data has expired. It can also happen when the proportion of
> -        * dirty folios grows not through writes but through memory
> -        * pressure reclaiming all the clean cache. And in some cases,
> -        * the flushers simply cannot keep up with the allocation
> -        * rate. Nudge the flusher threads in case they are asleep.
> -        */
> -       if (stat.nr_unqueued_dirty =3D=3D nr_taken) {
> -               wakeup_flusher_threads(WB_REASON_VMSCAN);
> -               /*
> -                * For cgroupv1 dirty throttling is achieved by waking up
> -                * the kernel flusher here and later waiting on folios
> -                * which are in writeback to finish (see shrink_folio_lis=
t()).
> -                *
> -                * Flusher may not be able to issue writeback quickly
> -                * enough for cgroupv1 writeback throttling to work
> -                * on a large system.
> -                */
> -               if (!writeback_throttling_sane(sc))
> -                       reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK=
);
> -       }
> -
> -       sc->nr.dirty +=3D stat.nr_dirty;
> -       sc->nr.congested +=3D stat.nr_congested;
> -       sc->nr.writeback +=3D stat.nr_writeback;
> -       sc->nr.immediate +=3D stat.nr_immediate;
> -       sc->nr.taken +=3D nr_taken;
> -
> +       handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);
>         trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
>                         nr_scanned, nr_reclaimed, &stat, sc->priority, fi=
le);
>         return nr_reclaimed;
> @@ -4824,26 +4830,11 @@ static int evict_folios(unsigned long nr_to_scan,=
 struct lruvec *lruvec,
>  retry:
>         reclaimed =3D shrink_folio_list(&list, pgdat, sc, &stat, false, m=
emcg);
>         sc->nr_reclaimed +=3D reclaimed;
> +       handle_reclaim_writeback(isolated, pgdat, sc, &stat);
>         trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
>                         type_scanned, reclaimed, &stat, sc->priority,
>                         type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>
> -       /*
> -        * If too many file cache in the coldest generation can't be evic=
ted
> -        * due to being dirty, wake up the flusher.
> -        */
> -       if (stat.nr_unqueued_dirty =3D=3D isolated) {
> -               wakeup_flusher_threads(WB_REASON_VMSCAN);
> -
> -               /*
> -                * For cgroupv1 dirty throttling is achieved by waking up
> -                * the kernel flusher here and later waiting on folios
> -                * which are in writeback to finish (see shrink_folio_lis=
t()).
> -                */
> -               if (!writeback_throttling_sane(sc))
> -                       reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK=
);
> -       }
> -
>         list_for_each_entry_safe_reverse(folio, next, &list, lru) {
>                 DEFINE_MIN_SEQ(lruvec);
>
> @@ -4886,6 +4877,7 @@ static int evict_folios(unsigned long nr_to_scan, s=
truct lruvec *lruvec,
>
>         if (!list_empty(&list)) {
>                 skip_retry =3D true;
> +               isolated =3D 0;
>                 goto retry;
>         }
>
>
> --
> 2.53.0
>
>

