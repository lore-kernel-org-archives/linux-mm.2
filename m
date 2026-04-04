Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03F2DE63FEE
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 18:36:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29A4C6B0088; Sat,  4 Apr 2026 14:36:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 249E86B0089; Sat,  4 Apr 2026 14:36:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 139486B008A; Sat,  4 Apr 2026 14:36:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F37786B0088
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 14:36:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E437BBA95
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 18:36:54 +0000 (UTC)
X-FDA: 84621729948.04.D6BBE26
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id A76E6120008
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 18:36:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YcSopdRn;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775327812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwDRF25TgOER+R3egUBoAWDcqivhJxn9663ravWkCLI=;
	b=FUWFqjg60R6HVcCu3prAj+V7NGpLMNdO9vG4E/uuKH3REJIB1uocCTdafbaOkNAhVLuwSR
	xlSUoeMdGm5EVwSxOcoUQmIKmYUGOtsWfosGA84aMRUxX7e/Q6nVEJZseCXcrtOW+OchoS
	XaUAkLmW5qomuWz+KMP859nBcqn8qR4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775327812; a=rsa-sha256;
	cv=pass;
	b=I/zJW4V3Ft1mrYRQ3M5bBTKCjH6NRbpbG48XHT+QAS+7CS+VxRUUPUk659rBNWXeQ3/eYA
	EhlWuu8/SpwmzHSMwzq66tYy2+qkAYlLT/J/jmFHFCxERqpu30oxXnvR2ur6em80JCiBEM
	PMxf+Tf2SgRVIF+FB1TzlGBq9qXPdAw=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YcSopdRn;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-66eaab8a07aso437147a12.2
        for <linux-mm@kvack.org>; Sat, 04 Apr 2026 11:36:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775327811; cv=none;
        d=google.com; s=arc-20240605;
        b=KaW9E4EN1QHHx8SnY8dHB1zlTG6cZAZLQdYrEOYm5DX3pCKxa3vJ7v8JY1wEXJP6kM
         8oa6C6vl3jU7mvo5TKH1dyevZzFxh5lJQHXDcjd/ZteYGTbV0fLNsWcwyRWDjtcCiWyk
         Z/FuBZAGK/dmw0oi5ouuU5fAkgP0bYGAITRQyXo2yG6TqGSheYRaBxLJ96BInpkQy20c
         4ZbB9aG+A86q1TF9NHubUsW54vyp5+LwuRpt6wOUeooLeCGN4c9eM9/dbpVbVs/LGqYm
         r5dyFkzaD+oJlnpAoNdo3sZrrfbkRhdqmYKz9Logzwv+pSnGtdjbwebtVVRTTGTOsIiL
         wu5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mwDRF25TgOER+R3egUBoAWDcqivhJxn9663ravWkCLI=;
        fh=MVkUI3NHJ1Mmy2mdCEGKuh/BTSJB4xYJpTm5UO8daWc=;
        b=deadMeEFfZB9nwCPDckgt7Q6DLM6YXFs3Zxv00r26St8mFY93e28vazfgwHPebkQ0Z
         C2Q1DFksLStco2sVLH9eETkKo0cSMeplsU5VlUahwL/Kt9MpkwxCQUwJs2XwulNqMtvA
         Ts6nKOXnqSQp0XUtJAIdcdcNE5q8DWfB0ahzOQaFOlaugjgHj6Io7f2t2ljbBXxvMOr9
         OEnW3YepkNkK6ZrFGmtYtcBAwUgqfTl+pyj6uDp64zkakJZtBzzE0yKRo4NSAYIUKbK4
         J17jXDQSr2Kcmshdh3G1m+YGvsISh/0rs7RTwHX/CeRgEjvv/ObYZEIukW4T3qVcuRh+
         8yJA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775327811; x=1775932611; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mwDRF25TgOER+R3egUBoAWDcqivhJxn9663ravWkCLI=;
        b=YcSopdRn9LYquNdDSBFTNAlxtWFHj8NQc28kg065DwQLgvcXpxEZYZvpen+wrDHPsr
         jiEE90uKYp3qgvbUDXhXBFAVuff/UTZrDs5/BXvoFHouG6fhMRAyDRQjwEdVrrUXcxhi
         Mmx+dx+fIZfx7mo6xW8XUBzjH53qaVih9nX1ssRnRE/iMd+uaZHLz0j5ptwIkwTIoY4u
         t/ENywUtmaULqK9sRlGSOkbj1BfrgBm0r4oYoTMf4LXaVa0kTHvAmxQsItp8r6ojLgJd
         9mlVdym7mUQHt3Lnr7liPH3gDHxNv67q9IC9mJ0P2IzkMTsfU2SHZw4NnjVMbIWt4ohl
         uEUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775327811; x=1775932611;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mwDRF25TgOER+R3egUBoAWDcqivhJxn9663ravWkCLI=;
        b=PUmZJ/apIIL2FoqGhIV/xiDrfrr7qybltbnnmRX2dHQN9cirDHtR/KjM46zPXdxzUo
         dvwKeLrfE1DE66BJ8Yz7htZKlzl3Mq//EHAYTPQB85dS+asmKPFU7HLcY23KmhRq9oOT
         TkJhEWqNnO6s6c+JoZuk8BHbS7UId0j6mkPXJI5z7oSF3BPNULQA/lTxSJeVNtl8l5az
         VaZeZnEH9e7hw61zaS8CzXA4KPV8PueB7eKu1TIAiQhSn1qe1BrRNxra/kvy9swwb7Jl
         dp6LF2fU3U3InzVkITeLkUzfgj1Mg4OCwipWZu+6bBM6B5P2rCYYRI1duAUVa1iomUbR
         mYWw==
X-Gm-Message-State: AOJu0Yy8kq55A71gGJS+9qcxEVdTob93pXE+fNV20iTBfNBh5OoRdchh
	Gt1OMaJkkiGCLy0tmof6olu2kelheJBxgaRCWW41blGjTJNhRgNlfyyn3nW63SmVub5xpntjo08
	ENvM8SxOwSVoplNVQNPTTZoi3hs7tVbA=
X-Gm-Gg: AeBDiesqOTAWi9GDtqZK+nEn0SijdujwgoKL2yjiGB0l9TnJm8xDc05El/DpAyr2FDM
	mNwnTWmm39HyUcaeqqm1/BDtue1obCymOuwBGEVNbxF3Dy9SOb0cC+3gzOm5IQN0ztdROGbZ6zI
	6D8ArwTQb0Xm+L8J6/BSSaJK/HcOPieoRbbrmRSCMq13HKXo3BuRqfJ0MPLq9MxQjmMqZiL7WwI
	60AuqzOcqd4m72kXai3Fzb8i1w7AtlD5tGs6Gaic3NlTzSDXHSqQY1vz+WZa5y5rPqddohXDx/W
	y3yCvMKUoQpHxSYYBSaWDbAVHuMVjwP/Kped+9hy
X-Received: by 2002:a05:6402:5211:b0:66e:43b:bdff with SMTP id
 4fb4d7f45d1cf-66e3eedee92mr3469604a12.5.1775327810672; Sat, 04 Apr 2026
 11:36:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
 <20260403-mglru-reclaim-v3-14-a285efd6ff91@tencent.com> <CAJHvVcjDXktz-_Nk8qj3jXfLkHhJVo+N2KWb1sA+DvENOMkdDw@mail.gmail.com>
In-Reply-To: <CAJHvVcjDXktz-_Nk8qj3jXfLkHhJVo+N2KWb1sA+DvENOMkdDw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 5 Apr 2026 02:36:14 +0800
X-Gm-Features: AQROBzAHcxXyQ30yTunBQ9KffT9HT4nIxPp8F33etiHIK7XcVVGQMVNk-UWpGlg
Message-ID: <CAMgjq7DFTUPhXqOxUa0UJa_v4mzseuLf2G9+FFGYtgmNasn6tQ@mail.gmail.com>
Subject: Re: [PATCH v3 14/14] mm/vmscan: unify writeback reclaim statistic and throttling
To: Axel Rasmussen <axelrasmussen@google.com>
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
X-Rspamd-Server: rspam12
X-Stat-Signature: sqo8xhhdjnt64wb545wss3nddqxqighg
X-Rspamd-Queue-Id: A76E6120008
X-Rspam-User: 
X-HE-Tag: 1775327812-990831
X-HE-Meta: U2FsdGVkX1+2b62IQ0BZaFQ1lqapDI1ey7k4MhT6Snvl+afSpEH3mq2rkQjoB3TxPv5p7+0iU8fQy9LreiR9JVkkAPMW6nshrBO+OhapAuRJG44IkZ+6kzlDSInVsQD18JLrL81K35qVc2q+ETzU5OUuuClY4Wq4dkX16KTEUVlsE55IRSRkhZv5QrYvOGTsrWzWNDeapRCB9W8cvH/c7yY5T2CCxJCsazo+2vSRrD0tAAYR2x91AGHRPOQ55Sa1c2LREJBU7bLkWntUGPPjRV6OePSMa0lYLy7/SxVz++V8WSR1yciuaWo5/EeEXBOjs3vA6WukUYnC4m0gJx2RxRHYchaE5/LInBs2So7KYFNh1FGxaOkgbB2zQmjrwgJsqZH1LhtgzLNpvTIvs6ASLaua+YH17ljDkWXBnDc/xErgjjXLPJPq0QJK8JN/Uw/XAsdHOG3jtWZYInaEtNl7RImcKIGQO2mynkJsU9TeNpOju4pJjI4e6kQNr8zgcBTtAxNT5+b5vDodXKbvArz+GtaqEaPN6UMbLdY+tmlbaSIsP2BCCl9cuyF8HJJJkOfclAsS19zgA23y4RrPfOJeQKoCj14mG+OtyEPdS8j8bg675oXcbElp6JfMkvSZSLAOiKTTwI5ePwZRNsox9hlM/j+N4xfMrH6b0YpPwYTwc5V75ckFV+s2Fa6HhinF2BYVtFRLOkUk5UHjCqSWOsa9OnTvAOvzqWxjl/gJP7WjhCn1hCl6CZ/yhbR9sy9x0EJEhfxN6oi9nEPp6gN0nkoW8BiZ0J3golVCaMRS9KHbrqXQOZXUJYGmKETNlRBMosME0mGS1bVW+bBCjv2/zKHT9nC7i3ydTZAq+R9VsQ4vdvbSWQOytuu9Z4v6ZweKqM8UUkUTJ+XOml7PMZi7B5a27m/xBaMHR84lTIlX79b8VTYH23yvz39jDRsS3RtYEj9WQL04CzglhVFshUyM2kX
 SERtRSNI
 1kzxGs+wJKiHTuTXQNSYMHXt+uwsrIsjOdnK0bo2ad+THmYL5S38TogjW2uBuXqnhyeW3eQTnPc00dKq2DrJs0N8MmX33zg84tdZHk3HYNlMYT0pVrL2a+ItGpKk+s8TJW+C63TklOI6qPgz9H6sELmt+G3neNBKNR1oYB9yYNU7sLRmdcMpjQoxJndoqx6mQptPJiAyRNT5d8nbUOU++JsvuoBzQmNX0ysn9xzQPAFWO7awxeF6Cb8i4yoKPr2AB4tDlZWE/AM2QEGAe6HsrtvW0+VEfVLS4892ryZHa99I2L6EnRhtm9LqHohuUQ6TsfQWNBSyycOJjmdqv4eyRsCWgZRYV6F1Xs5VIQIQGIgar7eIWp+DSA7hx2+kT+zq535Ae+0KpLoPCXAHHkL0U2E3Ynsdw6HYw6275SHApmsPPXgcOtOwiZQIBydg/fJTIqN+oJNvemRCmLshU4vRi7yFTiAZG4QV8hItJx5YeKdi5XWP0xAL4wo3Hv79rgO27SH0Fu1+lCI8hqRp0Pe3GCm9/7IB2D/ypT1/oYu5k10lMCNMiYpdKITeYdLwu7xgVAnTYg3DKTYnb7iPtnzz8zvCxIo7heBXPPnCLxf/MHYz1alVJiCQp0Y/g5hvDA1a4285LKT2Mr/5JIFA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 4, 2026 at 5:16=E2=80=AFAM Axel Rasmussen <axelrasmussen@google=
.com> wrote:
>
> On Thu, Apr 2, 2026 at 11:53=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Currently MGLRU and non-MGLRU handle the reclaim statistic and
> > writeback handling very differently, especially throttling.
> > Basically MGLRU just ignored the throttling part.
> >
> > Let's just unify this part, use a helper to deduplicate the code
> > so both setups will share the same behavior.
> >
> > Test using following reproducer using bash:
> >
> >   echo "Setup a slow device using dm delay"
> >   dd if=3D/dev/zero of=3D/var/tmp/backing bs=3D1M count=3D2048
> >   LOOP=3D$(losetup --show -f /var/tmp/backing)
> >   mkfs.ext4 -q $LOOP
> >   echo "0 $(blockdev --getsz $LOOP) delay $LOOP 0 0 $LOOP 0 1000" | \
> >       dmsetup create slow_dev
> >   mkdir -p /mnt/slow && mount /dev/mapper/slow_dev /mnt/slow
> >
> >   echo "Start writeback pressure"
> >   sync && echo 3 > /proc/sys/vm/drop_caches
> >   mkdir /sys/fs/cgroup/test_wb
> >   echo 128M > /sys/fs/cgroup/test_wb/memory.max
> >   (echo $BASHPID > /sys/fs/cgroup/test_wb/cgroup.procs && \
> >       dd if=3D/dev/zero of=3D/mnt/slow/testfile bs=3D1M count=3D192)
> >
> >   echo "Clean up"
> >   echo "0 $(blockdev --getsz $LOOP) error" | dmsetup load slow_dev
> >   dmsetup resume slow_dev
> >   umount -l /mnt/slow && sync
> >   dmsetup remove slow_dev
> >
> > Before this commit, `dd` will get OOM killed immediately if
> > MGLRU is enabled. Classic LRU is fine.
> >
> > After this commit, throttling is now effective and no more spin on
> > LRU or premature OOM. Stress test on other workloads also looking good.
> >
> > Global throttling is not here yet, we will fix that separately later.
>
> If I understand correctly, I think this fixes this regression report
> [1] from a long time ago that was never fully resolved?
>
> [1]: https://lore.kernel.org/lkml/ZeC-u7GRSptoVqia@chrisdown.name/
>
> We investigated at that time, but I don't feel we got to a consensus
> on how to solve it. I think we got a bit bogged down trying to
> "completely solve writeback throttling" rather than just doing some
> incremental improvement which fixed that particular case.
>

Hello Axel!

Yes, we also observed that problem. I almost forgot about that report,
thanks for the link! No worry, for the majority of the users I think
the problem was fixed already a year ago.

I asked Jingxiang previously to help fix that by waking up writeback
previously. In that discussion, the info is showing that fluster is
not waking at all, and Yafang reports that reverting 14aa8b2d5c2e can
fix it. So Jingxiang's fix seemed work well at that time:
https://lore.kernel.org/linux-mm/20241026115714.1437435-1-jingxiangzeng.cas=
@gmail.com/

AFAIK there seems to be no more reports of premature OOM in the mail
list since then, but later we found that that fix isn't enough for
some particular and rare setups (for example I used dm delay in the
test script above to simulate slow IO). Usually the reclaim can always
keep up, since it's rare for LRU to be full of writeback folios and
there are always clean folios to drop, waking up flusher is good
enough. But when under extreme pressure or very slow devices, LRU
could get congested with writeback folios. And it's hard to apply a
reasonable throttle or improve the dirty flush without a bit more
refactor first, and that's not the only cgroup OOM problem we
encountered.

With this series, I think the known problems mentioned above are all
covered in a clean way.

Global pressure and throttle is still not here yet, it's an even more
rare problem since LRU getting congested with writeback globally seems
already a really bad situation to me. That can also be fixed
separately later.

