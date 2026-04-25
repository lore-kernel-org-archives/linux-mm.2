Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 944C8FF885D
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 12:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACAC96B0005; Sat, 25 Apr 2026 08:18:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7BBC6B008A; Sat, 25 Apr 2026 08:18:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969A16B008C; Sat, 25 Apr 2026 08:18:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 826F56B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 08:18:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1AC541C03CD
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 12:18:58 +0000 (UTC)
X-FDA: 84696982356.03.2419C15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1ED25140009
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 12:18:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SOELmWJI;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777119536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hIDS7vXAMwmiGcsZKhoiFxKGoUs3/xiJNp4Z6NYtc1k=;
	b=hwh4/pJgueE+cxc/BdfKZJm+sxOLRw3jVsLS80RVJ+BVvveTRUpV2OynF/T3N6uJIocyTr
	E95eCdbHTN1SVc0/TWpxaKWzAB2bW7Q52gqCMnj7rfjdPEnqhyUZVIX0//p3Lzuo3IcAd+
	62ufmk8uXM3ML7oOlwWYZ+C++E1YJ1E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777119536; a=rsa-sha256;
	cv=none;
	b=PI94tf6BImlxp1Ml0MwtW5lJDjXPViRjmw+u3XjSYpz9oddBIyJ0sToEOj7hBmVFejlaaK
	MH5skZtF7w44s2vkAOE+mQPhgeCp3Sg/qNY+Mxz7507T1zRTA46RYPJzNWxqCv6RhTvOoB
	YZDyl+TiEolH2rx+R58aAxjWH3ykgPg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SOELmWJI;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D7AEE445B1
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 12:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1E1C2BCC7
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 12:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777119534;
	bh=y0EdA11+Scj4z0lc4oRAEok9QiRf38USXDDhYl7e5Us=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SOELmWJIkkKKBuj7XMZ8ZExu0Dx/KEQgQUjkfMMnIzjHr0VAZnE7XRc6SMOrjOotb
	 ZS0Jk7EzIVic9tpnJ7MuK133LPv3HgDZLQ0wyojKMS723pLXYKsPcPZ9GVAOaER5+C
	 DIpzpmS+EiS/sdOOvG6Ea6zlvL1TU19cRHfxinJ7tPfq0GFGjzmo8wt0RA9uqZOvNH
	 o5iKpzQwRRKNJIHwJKnMeTl99OTKy4ZbP2YK5bkDS+5Julo8s+GcI4Fj/WAjcQSmc5
	 enE7l8d7/GZFouwLtZ8Gv+uQ+ZhqIxc6ig+2gH27cIE786Kr6NpMENrTgBo1Guo7w3
	 N3vZBWuqC6Vpg==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8ee9ec26edaso550366785a.2
        for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:18:54 -0700 (PDT)
X-Gm-Message-State: AOJu0YyKXgCiahWE4Iiy0ToPn7zXc/3+ien6AzhAikwur6yad0tLSswy
	uEkepEI2wgVDtKQQR1yrPrlbqwel6I1G+0nR84b4ndQKooV9i4fJcWSY5sfku41+jaKmgGsbXqH
	0nsWNSUH/b7K/xdVjjuMSIud9dvv7dp0=
X-Received: by 2002:a05:620a:1999:b0:8cf:ebeb:c284 with SMTP id
 af79cd13be357-8e79217f588mr5090362685a.54.1777119533763; Sat, 25 Apr 2026
 05:18:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260424-mglru-reclaim-v6-0-a57622d770c3@tencent.com>
 <CAGsJ_4wLc15iF4sa6z+i812vaoabAGHS5ErPpjRyjLGMP=44AA@mail.gmail.com>
 <CAGsJ_4xre-x0e+qNVm=KLFnO1dbPkPX5RuecqwvTZu-vS+o8yQ@mail.gmail.com> <CAMgjq7D1bzYd+WmdbkUvS_7sNmC-QKYYY2+J2Oy60njJx4FfJA@mail.gmail.com>
In-Reply-To: <CAMgjq7D1bzYd+WmdbkUvS_7sNmC-QKYYY2+J2Oy60njJx4FfJA@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 25 Apr 2026 20:18:41 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wKStv8roeKmWLXScz0k0cMJmsnyEPjoLfH21k+R00V+Q@mail.gmail.com>
X-Gm-Features: AQROBzC5VL8rFCyONDpHqiycXrEhPzL_mKcUicSpVCCorC8aqL6znNRioaMeyRE
Message-ID: <CAGsJ_4wKStv8roeKmWLXScz0k0cMJmsnyEPjoLfH21k+R00V+Q@mail.gmail.com>
Subject: Re: [PATCH v6 00/14] mm/mglru: improve reclaim loop and dirty folio handling
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1ED25140009
X-Rspam-User: 
X-Stat-Signature: ms3xorzz8qmr45fxpf3zmmntn787nakk
X-HE-Tag: 1777119535-931390
X-HE-Meta: U2FsdGVkX19FcVjg71/LiBoQc5p5SxbI5O0k+HTUPXOdPHFtf5eixHCalzeen2Hchc8t6k22v8TPBWWZtPR+WQAd0VA1/MBE+gvqU7MKyxaJvxe8oYGS2f9I7x/uqam9NXQ+hC8ifR8DiDJaXAu5dYaKme0Sl7Cw3YSIbF5A9xUo1exmMIjK1GubWAiDRIblH/D4bywbi6NdmA2MKXggFUOh7FyG55s//R9TJ+iInSyQhsJE0kVLf8QJwev7GxB7ViXF0mqSERCmofYm/rl1xBRNyMBVpGhW8zXcstFgP13spXKPSwS56kAYWKnOAddR8VK4+wWkSBbh2MXzMEnGBAH4pyNpQ7Z7dNZEEehkhr6KKJ4pjk5vRamkEu9uCAzfYt9wiV72jQVBNZ7Wp8BHfB6lIFxvFBN4odO2WUFqKr1bVp2ZZLW2iXJygBL2s9zFZMTa66jAjpuddwwaGgL0EYWZfb/8F+HBMksvyfoPlPNQFoXhj8/Z+1DwuxFdMUDpj/0Xm4ilGI93o9hTZN6aJOtG+iZiABPeIrNSdQm8hPploLh8Kw7OG436Zm71EadFj6ALQTYuzVWabyFR1sXpVJ5yWLEI0c6A/Wc1ai9468IchQPLZCawhAX7V5DoxBf/GZ4VnkZ4pkewsqguakc/9IPY7tBrzZfZV4PiVN6U+RWLmwpEKwqmw0L/oQsSFKDVOlTAZgOGsSAussqHNthGfpRAWvAabuDuVxZFaNCnFUyEzzD9J6xNZGB3UmJEbq/7npR8ZWW0bypHXtrOr8RIk0mx1JiZ6tgQHFakR2c7D5eaQYkw9C/tIWqUkaycgKXmwnTWgmUe574EsOf/lryVmD2P3Y4Juvldot/WAWhTQsi6dVXwN9CgOs0tZ64Gg+q1TFpqjncNtutNzQEIVQRtk3/3g8J60HkP2zG54AbqOnyLBQgNsQ6pJnL/76+dCrh+ULwqHKUm27Oo/OmIRus
 XEYDmJ/t
 tVVQSdA0vvo8BYCzYVCTlnUvUfGprvD5oj1UHTHOcfuwNjFGocFJTfM8Ei9EfIcZWXqCu5Whwc7TqTWaKrzVU8mFGe3xoM11F+NukKH66hDUSQhVJZGSHHhcfGLi5FCI2Xbfkw8HvBjp7mANpbBn318ruVUrAYURmB0PaPSLn+CQOyRVdwS+fYNA8zOjAOC/k8PNPzXvUJWYNwqG0Sco6uAfA4KKV9X5hjvSQqhSIGXNZuUux0YXl4X9BNzHjga4fgASaYTXRDnxC5Opt57Dg0/hSNHRk2KbP5rQ1a2HBMOQmoVFp179LmYxfF5BgdSTCGPSZmMTj/XyzMsMR/pNWwrJY5o47jN1UBOh3ECwa+1Z5CyF4HF96m/O7drfOZcnGRN3yycs23v2aPMVYv81BqseCyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 8:56=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Fri, Apr 24, 2026 at 7:58=E2=80=AFPM Barry Song <baohua@kernel.org> wr=
ote:
> > Could this be because get_nr_to_scan() was moved out of the loop by
> > [PATCH v6 04/14] mm/mglru: restructure the reclaim loop,
> > while in mainline it is re-evaluated in each iteration?
> >
> > Will take a look tomorrow or the day after.
> >
> > Thanks
> > Barry
> >
>
> Hi Barry,
>
> I ran your test script a few times, and strangely I can't reproduce
> it. Swapniess behaves similarly after or before this series. I
> directly checked out the mm-new commit of this series (4ce85c040e0a)
> and compare to the mm-new commit right before this series
> (31a112f05f62). I also extended your script a bit to test more
> swappiness:

Hi Kairui,
I reset the repository to commit 4ce85c040e0a using
git reset --hard, and I can still reproduce the
swappiness issue. My machine is:

barry@barry-desktop:~$ lscpu
Architecture:                x86_64
  CPU op-mode(s):            32-bit, 64-bit
  Address sizes:             39 bits physical, 48 bits virtual
  Byte Order:                Little Endian
CPU(s):                      20
  On-line CPU(s) list:       0-19
Vendor ID:                   GenuineIntel
  Model name:                Intel(R) Core(TM) i9-10900 CPU @ 2.80GHz
    CPU family:              6
    Model:                   165
    Thread(s) per core:      2
    Core(s) per socket:      10
    Socket(s):               1
    Stepping:                5
    CPU max MHz:             2800.0000
    CPU min MHz:             800.0000
    BogoMIPS:                5599.85


swap is zRAM only:
barry@barry-desktop:~$ cat /proc/swaps
Filename Type Size Used Priority
/dev/zram0                              partition 12582908 280940 5

The data is as below,

*** Executing round 1 ***
set swappiness to 35

real 1m51.699s
user 25m31.134s
sys 4m13.127s
pswpin: 1562949
pswpout: 4840525
pgpgin: 8751872
pgpgout: 19741097
swpout_zero: 1095783
swpin_zero: 18079
refault_file: 515292
refault_anon: 1580980

*** Executing round 2 ***
set swappiness to 70

real 1m51.603s
user 25m33.600s
sys 4m21.738s
pswpin: 1786413
pswpout: 5350804
pgpgin: 8833652
pgpgout: 21715596
swpout_zero: 1230981
swpin_zero: 21051
refault_file: 313099
refault_anon: 1807417

*** Executing round 3 ***
set swappiness to 105

real 1m50.315s
user 25m40.863s
sys 4m12.446s
pswpin: 1555289
pswpout: 4911737
pgpgin: 7597548
pgpgout: 19956948
swpout_zero: 1125969
swpin_zero: 17594
refault_file: 237475
refault_anon: 1572835

*** Executing round 4 ***
set swappiness to 140

real 1m50.992s
user 25m34.774s
sys 4m14.068s
pswpin: 1642575
pswpout: 5027730
pgpgin: 7937214
pgpgout: 20426400
swpout_zero: 1155712
swpin_zero: 20248
refault_file: 215237
refault_anon: 1662775

*** Executing round 5 ***
set swappiness to 175

real 1m50.207s
user 25m38.244s
sys 4m7.655s
pswpin: 1522633
pswpout: 4788104
pgpgin: 7307172
pgpgout: 19464984
swpout_zero: 1109281
swpin_zero: 18085
refault_file: 186203
refault_anon: 1540669

I disabled turbo for the test:

echo 1 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo

My bisect shows that the commit causing the swappiness issue is:

[PATCH v6 05/14] mm/mglru: scan and count the exact number of folios

Before that, swappiness behaves as expected, and there is
also less swap-out/in activity(and much shorter sys time).

*** Executing round 1 ***
set swappiness to 35

real 1m49.406s
user 25m28.458s
sys 3m41.098s
pswpin: 984605
pswpout: 3329809
pgpgin: 5985696
pgpgout: 13648560
swpout_zero: 780136
swpin_zero: 11379
refault_file: 367629
refault_anon: 995982

*** Executing round 2 ***
set swappiness to 70

real 1m48.577s
user 25m34.994s
sys 3m42.694s
pswpin: 985650
pswpout: 3450097
pgpgin: 5468828
pgpgout: 14116020
swpout_zero: 820143
swpin_zero: 11808
refault_file: 245353
refault_anon: 997410

*** Executing round 3 ***
set swappiness to 105

real 1m49.262s
user 25m34.871s
sys 3m41.633s
pswpin: 998178
pswpout: 3553741
pgpgin: 5328896
pgpgout: 14535068
swpout_zero: 840706
swpin_zero: 10393
refault_file: 205514
refault_anon: 1008525

*** Executing round 4 ***
set swappiness to 140

real 1m49.417s
user 25m35.395s
sys 3m47.169s
pswpin: 1138043
pswpout: 3756034
pgpgin: 5807584
pgpgout: 15345816
swpout_zero: 884539
swpin_zero: 12652
refault_file: 185767
refault_anon: 1150649

*** Executing round 5 ***
set swappiness to 175

real 1m49.654s
user 25m35.244s
sys 3m53.330s
pswpin: 1235427
pswpout: 4058085
pgpgin: 6108792
pgpgout: 16547764
swpout_zero: 974086
swpin_zero: 14280
refault_file: 170452
refault_anon: 1249705

It=E2=80=99s too late today; I=E2=80=99ll continue debugging tomorrow.

[...]
> Since you mentioned it's mm-new vs mainline, and you have reverted
> part of this series and the problem is still there. Could it be
> related to something else in mm-new? I'll keep testing more stress and
> workload to dig deeper too. Or maybe the swappiness behavior just
> changed slightly, some it may perform better or worse depending on
> timing and workload? Swappiness on MGLRU currently only works as a
> factor for calculating the refault and reclaim balance of anon / file
> so it may behave a bit unpredictable. There isn't a proportional
> calculation like active / inactive LRU. That's a problem too, and we
> might fix that later.

read_ctrl_pos() should also bias towards swappiness, as
both sp and pv gains are affected by it. Yes, we need to
fix the swappiness for mglru.

Best Regards
Barry

