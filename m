Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAF3EF99C88
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 16:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EAC16B02D9; Sat, 18 Apr 2026 12:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C4666B02DA; Sat, 18 Apr 2026 12:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D9846B02DB; Sat, 18 Apr 2026 12:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE0AF6B02D9
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 12:58:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9811359000
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:58:14 +0000 (UTC)
X-FDA: 84672284508.07.DD77EB4
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id A19AD80004
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:58:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TNmrB6XC;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776531492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zQ07OjUwoRamTzId+InxzD4WMxRil7WWgRCU0k4aFGg=;
	b=I6Zd7enSsI4Gm6OfUt9BlWhL2wH8aKr6/O5yq1mvZDlQvmeCktcybiI5Saffd98paonW0v
	KRVSjX0UFBT/W0SxY0el6vugo2doG8DX0uBERwfsnHPu+7EteY2Ip1zbirYTrCJ9yEV58W
	uYxe8QwNxTBCs+l/iPo/dxEdQKBFZnM=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TNmrB6XC;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776531492; a=rsa-sha256;
	cv=pass;
	b=U6h5phnx/no2BSVsL+4eqljP3NPFsltkdu27BqVgz+fi03I/gd27IbVRZQJtBB2l4k9B/I
	fMD0bDusDkjJSxinuU6XalH4Je+eeMYCIJePV3VytlARGpELMp8P4L6ciqecRFyMlQvbKX
	bTrwp77ir60AM+9wIFXZMM85CeBPpTw=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82d0b68837aso1053765b3a.2
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:58:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776531491; cv=none;
        d=google.com; s=arc-20240605;
        b=PwFOBkJYa5NElCFoWPqO8KNRpiKQpyL1+FufUVPJMDodlTl22DxuivMKgJzpVHcxW4
         owa3QNFvVag78sGdHBnAzKZ44DJ2zHgxsBArARUbYeUXH+/RkqOcTXxwuNXCnITeNeQk
         XlZihom2fHCfOPTS1MXZokFPvBEADarMj0cGm3uaJ+cabIqwiS3fM/8A/Cu5VhdztceD
         HwmSn7FfXG0Sz5fOAS44HfFvQBF0D/NI1E9g8+dvYv4z5tJiAh0TMzILOBTYlk0g9jWG
         jDnsuXBYfTgt/kod25+poZtwVOgr8c3hSQm2lTo4AVn4Jxgj9u+VfELZj1k0Ut+rCJ0G
         WnmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zQ07OjUwoRamTzId+InxzD4WMxRil7WWgRCU0k4aFGg=;
        fh=3REOVNzYkQ8+arRUXdGjum57Nfv0U5m/3yka4Z4sNSI=;
        b=jcDiXqyBAB4dcj0fBfM559b0XXWXrTl8SBJ39HC+I6uT9n3NYbtTKd87UZXDCj2GPA
         1hgPULRuD0yWPNNZmsXxVZ09f1OMeN5JdK6NHtYJEBex9VZnE8D7cf5xFWAs4qT7INtA
         4Zgmb3+xtp8cqTDCZi3bmXLaLhX8c/sm0fzZdgq0yYPqw0No2RXRkMk8PydU9e7j0Jv8
         WitYkRsWbPidgiD+oIda4hXANzeyyfi1lTsZN2tMq/WmE0yzmRUAlfqn0iElhtZP5dg7
         QRKLZSkNE3usFi729exMTuz5lh3uWTH93n7myzqSsCyhP+j6kSPIVV81PMTSG9a/Xpt7
         kSPw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776531491; x=1777136291; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zQ07OjUwoRamTzId+InxzD4WMxRil7WWgRCU0k4aFGg=;
        b=TNmrB6XCBaeEv0KKY7LuWIPvmErugDPQoc0NGhB5utoKA4uFV/m9W40hiMTNO9L7uc
         A2dY+8UQ7RDC7WNab4kVBF8aWWVlSOsAlir4ZvdjcS7xtSm3rUSYlK/eBByUeXM/xP/P
         JYsbAQL+U1uKbd8FA7t2+gLG6iHbf/kHAZl5dNs9C7zQ2zjyFRo8F+6hNW9oc4CUJdug
         ka8PxYYo68iwq5nls54fS7iGeftrxkKr/XMK2DqAuM5VCoGXk5IuPixCtaIaSY1XfUol
         rKO3lXROetUpHGL62fIY1IclaNZF0ueO1Migc8BczJrl824LPf0szQJj7NDtwQ+dUvu5
         nO1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776531491; x=1777136291;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zQ07OjUwoRamTzId+InxzD4WMxRil7WWgRCU0k4aFGg=;
        b=odt76FIDALKETyVa5/kn/AzmO66OPQOHuJe3cKjjoQsEelySPXSM9vLWu+ZDDBmdJp
         2ckhl34RpCdkRjSGC7OBQlYMaYLhmMwfTmxl1mWSNoon3VyWytJjN42gmBNLy6KobVzI
         w+O96tXzEG1MwacIVZge/wXf078xYgX8SKA00nPWfhFJyxfK6kcL7VGIutbqgN3W2vDp
         nxu2aqLreYhrq7qpMFAWtMnJkrBkMJ94isaRjiEHVFPoCYZUeTDKksEBF8r4w8+YNSfW
         rumTUEELugUpXa8yRchOaJkq24BIvciLWeD536rGBTIdO/tlBlCRxnNeouxmPyZNZKeR
         7ypg==
X-Gm-Message-State: AOJu0Yw+hXfr7pNfuM3jHbKKLoOH/dUXi9KMgxPoNRHJTcirMTB61dGS
	4e/HuWNpOzVEb4OSR3XzigzanoS3uSonOuziCyYuRk85CYz2dKEjpV/+v+JCqsL0IaAed/64NEs
	VRZaTwXIDhO8YXX9U2FCbHLQTJyTVxQE=
X-Gm-Gg: AeBDies0srpZ36JIDSTMvk1nm5t9a0hrYSCXuMIkpnDVjTaWyrDTiks7TszrUib4Jx+
	W5IJEPZw/9hCjr12IL9fEICkIWHmLRxPmeabe5C9ALVVwd+b3BjD9ZQbL65Zyu6v6Rxv/jUSeLb
	8yCFzn6Bi3j0Eu9CCmUy6WOmba/fI+LGJ5E4W8r7HgdI4puymBAf7BG7F9W0CzzrhGpcOVW1s0z
	XiKjIlb+UHVzUYKqsYm76jkO9FDyW3TnM6JCThvtBZjhz8fknLpJvNFXtxCkmqWyywpwgBuz3u3
	zA67PVEiopLOhbHrnleAuOjxEoUpVQbXyWL9Vyvdc/9tbrp1ZBY=
X-Received: by 2002:a05:6a00:2889:b0:82a:12e9:c75 with SMTP id
 d2e1a72fcca58-82f8c8c5353mr7484810b3a.30.1776531491289; Sat, 18 Apr 2026
 09:58:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com> <20260413-mglru-reclaim-v5-14-8eaeacbddc44@tencent.com>
In-Reply-To: <20260413-mglru-reclaim-v5-14-8eaeacbddc44@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 19 Apr 2026 00:57:10 +0800
X-Gm-Features: AQROBzAUGXWkKR7RgvV5vm_jWC6LA0CSMA2gE8dv73LqZoiHwdJHn-rulFH6udM
Message-ID: <CAMgjq7DCn8p_yMMhiejFjX6sdybZKYOw8qJbq=+OCsZ=AfJnFA@mail.gmail.com>
Subject: Re: [PATCH v5 14/14] mm/vmscan: unify writeback reclaim statistic and throttling
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A19AD80004
X-Stat-Signature: 5br89dounhx443yy59buxndddhx4cqbb
X-Rspam-User: 
X-HE-Tag: 1776531492-535904
X-HE-Meta: U2FsdGVkX19BEvGlY81V0VwWmITPKzPk2casnD7CaM+wbc6ZVJDj0az/Do2r1GzsaUDhgw3t3shJL+icRXCpPACND3xOn6+SJIjk/YNtNE/dDp2C7kkjkn+xlkEGMuH5dh3erdcjIJCF8SA5YtRcgNtij50oI2Ri+God7SX67fRq/wuJpCT6kZbJsry7dkmNZiEj4NeK7oewB5VXv+vny1IxFpoMo9f1tl0zaKFCkwOOxwrpsSh7jbRgFydz8M8k6/JB/+GdVevBHYB50C5HPMjbvB1ZZCOv3ruNS9T65BJ3vmtP3cBPK2CCurMtl2pV5gYvsspjFvJ0QqVE7sQglmKEGNtQb3MQBYAeYZPerQUioRwdlxPBFmQkI5Y+38gWTWzoGFm4qb2AD6IZ/0LvAnxUZOF4yS36TjhK8ZkN1YIHlBVtS/uxNu7wGBd8rOldqG7MFPDfUzOIC7v+NS1GUwg6f1dhBlukVaQG0jSyGiNERWaTzgNWYmnwm6TI6vubaTO4ev4aabBk2JataiOkZnmYtSN2OPuTEzXY34XVUuPDBWM8mZG6t/9yy5njk+h9UGUOc+f7mnK62YdhoyHFovRNMMZVxANDyM/zmTHNl5lPq6jY8aydoyXp/vgyTdCT9zKZKHEYNLxcbtNTk9/+xx6MlyjWtlcfh7eq6TblZw5RerDAXpCrxMT4Mn16A/8hZdQe+zk+tczA5rvqZKVUb31b3ILUvtl+yrjhUJXvWfoGKepbsW7HbvLYyQ0OXgRPsGZFPHWIcLo5o1CChJn32v3R9fXhs8fdOj0cOmHy1YmIZZcK/zEdnrCl3lYMb1+8FBsQWbVIzffOmcgyhOPBtQjm0+0hjKwX22DReug22UrlHwDj3v96GXccAdirIX4VKv1m6Ap+sIixyPfZQIL24AQ9m/s0Ju7kvhTJF9DceEKfUZzPEjNXOa08A1x0121xiry4F5rMwLK76uFg5aP
 Ci5x2w0n
 rPKlSz/q4Wxi+f+4nXHN1NM/oGNvWInF5S0VnGhqvhKjpQuNH+hDCCvszaNeRuGT6UlXYvStjNVEv9eo3+84E+5ccCFrTrK7nrrZahpxvl7gkuXLBWu8IcR5aawAYBs50fzze+Pg8IptDl++RfnzOkZNssj4xBtlFyKan5k0C5qs25rvM36YwLEADA+1CGD4pQYbwoZt94Z/tqocNi3/r5VY/BF3EjXo6OmYTjAIHC2AAngQ1+GR9GddkJIVFVZYwgU4m7HOR/SaLVBaVF/NSzcODcW6nCRSipubhDAvD3TJES7At58/oDkhq5p1OmnLWOlEscKURRGQinsTpXrwfGzXTaTjw34CSp9RyO8uaJxx4T7LgDUk0HYRX3FOGfvtaiDC3U00jlcaWZe/tWg9GgdjMvqN2ljlABZHv1qPsOPO1O9tT2o7kH5eCCjlFSMnQqsD/nJ01a+aYlbuDC4J/TG11Q1KVmTMabecT3jsTBUwiVGQIm9/F0vQBiakXWp2qJhlno8x6JaeYD9yZwYIDCEygwhye5TXlAQGhcSy9CtM7sqT2LGfYD2nojbbMInrbM4lLfemplvqdPEcokGbxxrqGF+/1CnGtHxmKfTw6E1sgku0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 12:53=E2=80=AFAM Kairui Song via B4 Relay
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
>
> Suggested-by: Chen Ridong <chenridong@huaweicloud.com>
> Tested-by: Leno Hou <lenohou@gmail.com>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 90 ++++++++++++++++++++++++++++---------------------------=
------
>  1 file changed, 41 insertions(+), 49 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a431f94ff3a3..43a3cadbb586 100644
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

While doing self review, I noticed a small problem here: It should
return without updating the counters below if nr_taken =3D=3D 0. Currently
it only skips the flusher.

We might see nr_taken =3D=3D 0 because MGLRU has a retry logic: if
shrink_folio_list returned some folios for being dirty or writeback,
and, they became clean during that isolation time period, then MGLRU
will try call shrink_folio_list again without doing isolation again.

This patch is still fine with the retry here in most cases. But if a
folio was returned by shrink_folio_list for being dirty, then suddenly
became clean and triggered the retry, then became dirty again. Now the
counter below might be skewed since a dirty folio is counted twice.
Still this is not a big issue, and I couldn't find a way to
reproduce this even on purpose, since that requires a few really short
time windows to hit together, and the result is also hardly
observable. But for a 100% accuracy, I'll update this patch with:

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 71b4ef0e6735..af14efbc0cd8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1958,7 +1958,7 @@ static void handle_reclaim_writeback(unsigned
long nr_taken,
         * the flushers simply cannot keep up with the allocation
         * rate. Nudge the flusher threads in case they are asleep.
         */
-       if (stat->nr_unqueued_dirty =3D=3D nr_taken && nr_taken) {
+       if (stat->nr_unqueued_dirty =3D=3D nr_taken) {
                wakeup_flusher_threads(WB_REASON_VMSCAN);
                /*
                 * For cgroupv1 dirty throttling is achieved by waking up
@@ -4830,7 +4830,9 @@ static int evict_folios(unsigned long
nr_to_scan, struct lruvec *lruvec,
 retry:
        reclaimed =3D shrink_folio_list(&list, pgdat, sc, &stat, false, mem=
cg);
        sc->nr_reclaimed +=3D reclaimed;
-       handle_reclaim_writeback(isolated, pgdat, sc, &stat);
+       /* Retry pass is only meant for clean folios without new isolation =
*/
+       if (isolated)
+               handle_reclaim_writeback(isolated, pgdat, sc, &stat);
        trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
                        type_scanned, reclaimed, &stat, sc->priority,
                        type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);

Then it should be perfect.

We might better just remove that retry logic completely later, it's
meant to avoid folio_rotate_reclaimable from missing isolated folios.
That should be done in a cleaner way. The current retry loop also may
lead to inaccurate tracepoint data, not a new or major problem so not
touching that part for now.

