Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81293CCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:38:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88F3B8E008D; Wed, 29 Oct 2025 11:38:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83FF18E0045; Wed, 29 Oct 2025 11:38:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708638E008D; Wed, 29 Oct 2025 11:38:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5C00D8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:38:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 344C712B222
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:38:51 +0000 (UTC)
X-FDA: 84051559662.25.4B36886
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1EC6F8000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:38:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jx+AwLFU;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761752329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=urYud32J8LwG3U5llh37LUaklfwwM6DUQdvsUUbxIqM=;
	b=XV07idrHWfOsOqz/JN/Apc3yVAI3KFeV/By2tiZj4s3kHEV74zj4/9ddoFVoPGD+TrQJ4w
	Kzdh9d/Z8QDADUK+as0n8a9+nCp1HYTrIRsQI6RMljLxrA3B3syJes9m8J+Ga+dtp0dVVF
	oZXrLlsmXFeLz9FljEhd8imrC7Lh5rU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761752329; a=rsa-sha256;
	cv=none;
	b=x9srngaExNAAoytvDj96I2Hgq6rUFPSPLe4De6XsWLwXCtSIqqBGxO/UxsKjL7ETvYw8XO
	BOtHy0/7hL593Y4OPBviNEFwbarnQL6iUvA6DSKDWSZ0PyZ1HqyOVxvLNnlJaGGP+d8gN7
	jReUqncGagOuRM1MElh+IvaLyeWHeac=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jx+AwLFU;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-63c45c11be7so11944806a12.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761752327; x=1762357127; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=urYud32J8LwG3U5llh37LUaklfwwM6DUQdvsUUbxIqM=;
        b=Jx+AwLFUjMoRTcvqXit+4jYOSXW8xejwElFBEZeSzSx63nkk3GJF/aFu44mkwvUVhP
         qriX02/8JSLgdd7k2JWhdXYRqIMZKSxJs2AlsA33RMP0QsJqgGqGAXGK5O5jZ2II53g9
         q9p/mz2LBfa1hUp9oQdPG+g29INWq5Djsa3aEIgxiiZh4qgxrwxGFZqTzzlAmp0oX5Nv
         nCimX+ULpT0nypfvHKTmyLlqlTMqwWs+JHIuV2tPM8/9UpU0wa41GBjgLj2mBH5otks3
         OJChMN1mIVU4hYckGgqh8pzinXpdOJBwvSZVWwgewd4OaiwdHkCkIh3qNHmVoIk/6JdX
         4w3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761752327; x=1762357127;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=urYud32J8LwG3U5llh37LUaklfwwM6DUQdvsUUbxIqM=;
        b=pSlrD7HYlDQy9mz4xaimCWmOy9BJC+VPVQuuSYSV5KX2/jFPvLhQN0ol2miki7dbiJ
         5ATTuPcoAtqpKb9wFGan5ZAPqHzeTgRYoWelz5IaKO/6sgcqpHpfUTbsPxov0pmkEh8D
         3XrBlHQsVoVtCmTx68PMiVuUhVFdYNz60n5GS5EdHMSPsmWXj0d2MFc2bI9WFAJHDIdx
         rAs0C2lcCoEjzOvjl4Sx01wtOxy8HUtJsKoTIC7k3SAB4uhy870twpGpxbYjIweP/MWU
         r0TIe6AdL4CYp+WfiLfgAQ3R/uWnlN22wImhtRUDun+KQrUGZhfR4BblKNCIDE7wOd+c
         xLlw==
X-Gm-Message-State: AOJu0YxCJgxEgDUgLLH/vzcVDTMLr4k9TjETGt6k5uIdZwAWpwIMreRG
	qtGT4U758R/QvKvEOCL+tKW3qa99JoKFJI5Ax2xK+L2QaORdmgOama6YkZHBt17zRUAFn0UO7S9
	gqGKfjKLs1InZwagqj2GqsMfhO+bOrbU=
X-Gm-Gg: ASbGncvlO6sD/JdrL3wNqUZyTXKKH3GE9BweFWkeRxQnKXSIv8cj+vixqWJjFs/WPk4
	HMvDHP1MPMohIRpHuRnRYv46cotLfF0qH7BZWOhqpG1xHUEm2FjERwBTRZxYcCtjjBRa+H+vLJv
	QFyHPZy+MkHkNr9H4h5lvMowVXrjug/P5cMNvwkPL1GsGIvsh6ndqsqJ5E6CIxWely0V3S/NeeW
	WPzPgPT2HUe0/9ccg0Cp6DPBYSV7VFYi0AuoBP06Li7OxHy90zh5cQab5VClbzXjM9vESJTgik=
X-Google-Smtp-Source: AGHT+IFa0w17Ism/jw2GDjCQ7sAG/Q1E+q/G3wxb1yyhRFkRykg+aKJ0qmQszlwPXBeAcTkA0fJTWPqnP5GQSW5gCo8=
X-Received: by 2002:a05:6402:440d:b0:63e:8f4:88f6 with SMTP id
 4fb4d7f45d1cf-64044380186mr2836333a12.33.1761752327272; Wed, 29 Oct 2025
 08:38:47 -0700 (PDT)
MIME-Version: 1.0
References: <20251028034308.929550-1-bhe@redhat.com>
In-Reply-To: <20251028034308.929550-1-bhe@redhat.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Oct 2025 23:38:10 +0800
X-Gm-Features: AWmQ_bkbVcVgYH9CBOV09m0zwppPgtONywpBNMkVdIe-R04eSJ1Q4aXNhQpthtk
Message-ID: <CAMgjq7CkMXwQuyXZWJuiqxHXQ=CWPoFN+aQtioN941Z6To1qFg@mail.gmail.com>
Subject: Re: [PATCH v5 mm-new 0/2] mm/swapfile.c: select swap devices of
 default priority round robin
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	youngjun.park@lge.com, baohua@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: p9hdxjdtra1c8j3eminix5uoh61y1p3t
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EC6F8000C
X-HE-Tag: 1761752328-174462
X-HE-Meta: U2FsdGVkX19KGvAMh4wv5xiMjZLL3KDq2NRSDCWifwCNkeFivO8hPIqzAOIr5Iwt7va8pHL5gXRWt9+YSfJNDv4HJ1/xbzHy0HXJijZifV8JWoEAWUnB37rPECvgkF/+OULpfmB8llvuSVMzejEn0ookmNlHAQ+Bgl+EvAThv4Ydy4fUf2R2BEvZFgRG2QAtOUGJnkBs/77h8Aou1ewyxs0E4wNZlcxufaPp5Sc9svDRHnkGdSmBtsROTzOIqBfr+CkfgmUmwiS/N+myPR+s/xsBuEj1bfTb+UtbR1PC+luqVHpwyD31+jaskr0hiB5QuObjJacR45ff6dbiT46fxm4Z4EnGLwjVW0KjnzDlS9zbnWb/MHmEMRK1uwo6cnxLoGixeS19rjAPb9s/BrTU9MAbtX4BjvXfpeu+9OiAD5AiVo7Tj95saRTBbrrd76UDcRCT2CIbcYel9QiqQ6EkmPNUBYbGIr262DgaGvP18QAcxwzgrsndf8hhZmny5WmqF+GJcuM4u+CKDS9jXZuBMv5ZjCFVOoy3C0CNKVyCeattb/8USzF+Br2xJpDjOcMeMIWO/8GeEhnAy8vNnNNGhkQUYyGXkL0qdzWxYij+DW5crhr1OxkjZnmVWBo8PYcSHIk/eunmHbxd7mP4pRGXcHXe+YqKs2SMb2cTckFha98vmg5/5ru7cKUNCxUhLr4Ua5xKXshb+1+rhnEQxNU+X3aj+ZNMZFE6758gyRUg3a6hm63Ioi7OH+JIQ8XOLNPJF3JtfQl6/vJoCse+LfKx7pw+Y6rro1bBbDggtpZhXbBNM1zzJ4vw0F9T2WH+viaASM5ej/o8NfFzY9dGQb3t+p0Mw6Qcc/cmjowh+g+vMCU7m+AiP04y1FqnMBEvURtqWKjAIJIjHRChi9OzeVcoGaLWnrL/6wLpNS04McBxd2US3flHl3wyVJY+Npd2paIqKDjqQ5MbsY92z1lAT3q
 I9FCnMNh
 3ZV+SqS9pAq2RDuzD8P0rDqQEedlH36wFQa8wzqn2AJpDczR9nWYqXZLoCvjwJU7EmfoKc4/XqHRBGTfFWJGB/f0ynCYu5awbykJt4ZCB4AFEjCvDEsMHtkkp71AbRMW1XHOJFqT9bLHw3kxmNmDI/Dls4s0iW7LgadpbIkzly3BhWl0HkuiGSCgbSLAPxHHgSnqX1Ekrxx0RoceGmYGcKZ7QH5uBa5LCE1H+gf7AHMBTGR9c78uN/vC5JBuUpckNmrKRPsu74kQ/BODqMihCrvrl90qTi8SL4yU5vuMAiHAn1WrJMJSKStyU16GB6WE9exyFMtO4mCyGbyq7WO3sQphXJlMjUl5/Mdr/Fmjot3pwfagwg2SuD2iuMOz+GlJxX8pk/P79EC31Nw9toU+xBHw4OA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 4:30=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> Currently, on system with multiple swap devices, swap allocation will
> select one swap device according to priority. The swap device with the
> highest priority will be chosen to allocate firstly.
>
> People can specify a priority from 0 to 32767 when swapon a swap device,
> or the system will set it from -2 then downwards by default. Meanwhile,
> on NUMA system, the swap device with node_id will be considered first
> on that NUMA node of the node_id.
>
> In the current code, an array of plist, swap_avail_heads[nid], is used
> to organize swap devices on each NUMA node. For each NUMA node, there
> is a plist organizing all swap devices. The 'prio' value in the plist
> is the negated value of the device's priority due to plist being sorted
> from low to high. The swap device owning one node_id will be promoted to
> the front position on that NUMA node, then other swap devices are put in
> order of their default priority.
>
> E.g I got a system with 8 NUMA nodes, and I setup 4 zram partition as
> swap devices.
>
> Current behaviour:
> their priorities will be(note that -1 is skipped):
> NAME       TYPE      SIZE USED PRIO
> /dev/zram0 partition  16G   0B   -2
> /dev/zram1 partition  16G   0B   -3
> /dev/zram2 partition  16G   0B   -4
> /dev/zram3 partition  16G   0B   -5
>
> And their positions in the 8 swap_avail_lists[nid] will be:
> swap_avail_lists[0]: /* node 0's available swap device list */
> zram0   -> zram1   -> zram2   -> zram3
> prio:1     prio:3     prio:4     prio:5
> swap_avali_lists[1]: /* node 1's available swap device list */
> zram1   -> zram0   -> zram2   -> zram3
> prio:1     prio:2     prio:4     prio:5
> swap_avail_lists[2]: /* node 2's available swap device list */
> zram2   -> zram0   -> zram1   -> zram3
> prio:1     prio:2     prio:3     prio:5
> swap_avail_lists[3]: /* node 3's available swap device list */
> zram3   -> zram0   -> zram1   -> zram2
> prio:1     prio:2     prio:3     prio:4
> swap_avail_lists[4-7]: /* node 4,5,6,7's available swap device list */
> zram0   -> zram1   -> zram2   -> zram3
> prio:2     prio:3     prio:4     prio:5
>
> The adjustment for swap device with node_id intended to decrease the
> pressure of lock contention for one swap device by taking different
> swap device on different node. The adjustment was introduced in commit
> a2468cc9bfdf ("swap: choose swap device according to numa node").
> However, the adjustment is a little coarse-grained. On the node, the swap
> device sharing the node's id will always be selected firstly by node's CP=
Us
> until exhausted, then next one. And on other nodes where no swap device
> shares its node id, swap device with priority '-2' will be selected first=
ly
> until exhausted, then next with priority '-3'.
>
> This is the swapon output during the process high pressure vm-scability
> test is being taken. It's clearly showing zram0 is heavily exploited unti=
l
> exhausted.
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [root@hp-dl385g10-03 ~]# swapon
> NAME       TYPE      SIZE  USED PRIO
> /dev/zram0 partition  16G 15.7G   -2
> /dev/zram1 partition  16G  3.4G   -3
> /dev/zram2 partition  16G  3.4G   -4
> /dev/zram3 partition  16G  2.6G   -5
>
> The node based strategy on selecting swap device is much better then the
> old way one by one selecting swap device. However it is still unreasonabl=
e
> because swap devices are assumed to have similar accessing speed if no
> priority is specified when swapon. It's unfair and doesn't make sense jus=
t
> because one swap device is swapped on firstly, its priority will be highe=
r
> than the one swapped on later.
>
> So in this patchset, change is made to select the swap device round robin
> if default priority. In code, the plist array swap_avail_heads[nid] is re=
placed
> with a plist swap_avail_head which reverts commit a2468cc9bfdf. Meanwhile=
,
> on top of the revert, further change is taken to make any device w/o
> specified priority get the same default priority '-1'. Surely, swap devic=
e
> with specified priority are always put foremost, this is not impacted. If
> you care about their different accessing speed, then use 'swapon -p xx' t=
o
> deploy priority for your swap devices.
>
> New behaviour:
>
> swap_avail_list: /* one global available swap device list */
> zram0   -> zram1   -> zram2   -> zram3
> prio:1     prio:1     prio:1     prio:1
>
> This is the swapon output during the process high pressure vm-scability
> being taken, all is selected round robin:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [root@hp-dl385g10-03 linux]# swapon
> NAME       TYPE      SIZE  USED PRIO
> /dev/zram0 partition  16G 12.6G   -1
> /dev/zram1 partition  16G 12.6G   -1
> /dev/zram2 partition  16G 12.6G   -1
> /dev/zram3 partition  16G 12.6G   -1
>
> With the change, we can see about 18% efficiency promotion as below:
>
> vm-scability test:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Test with:
> usemem --init-time -O -y -x -n 31 2G (4G memcg, zram as swap)
>                            Before:          After:
> System time:               637.92 s         526.74 s      (lower is bette=
r)
> Sum Throughput:            3546.56 MB/s     4207.56 MB/s  (higher is bett=
er)
> Single process Throughput: 114.40 MB/s      135.72 MB/s   (higher is bett=
er)
> free latency:              10138455.99 us   6810119.01 us (low is better)
>
> Changelog:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> v4->v5:
> ------
> - Rebase on the latest mm-new;
> - Clean up the relics of swap_numa in Documentation/admin-guide/mm/index.=
rst.
>
> v3->v4:
> ------
> - Rebase on the latest mm-new;
> - Add Chris's Suggested-by and Acked-by.
>
> v2->v3:
> -------
> - Split the v2 patch into two parts, one is reverting commit
>   a2468cc9bfdf, the 2nd is making change to set default priority as -1
>   for all swap devices which makes swapping out select swap device round
>   robin. This eases patch reviewing which is suggested by Chris, thanks.
> - Fix a LKP reported issue I mistakenly added other debugging code into
>   v2 patch. clean that up.
>
> v1->v2:
> -------
> - Remove Documentation/admin-guide/mm/swap_numa.rst;
> - Add back mistakenly removed lockdep_assert_held() line;
> - Remove the unneeded code comment in _enable_swap_info().
>   Thanks a lot for careful reviewing from Chris, YoungJun and Kairui.
>
> Baoquan He (2):
>   mm/swap: do not choose swap device according to numa node
>   mm/swap: select swap device with default priority round robin
>
>  Documentation/admin-guide/mm/index.rst     |   1 -
>  Documentation/admin-guide/mm/swap_numa.rst |  78 ---------------
>  include/linux/swap.h                       |  11 +--
>  mm/swapfile.c                              | 106 ++++-----------------
>  4 files changed, 17 insertions(+), 179 deletions(-)
>  delete mode 100644 Documentation/admin-guide/mm/swap_numa.rst
>
> --
> 2.41.0
>
>

Glad to see the performance is better and the code is cleaner, thanks!

For the series:

Reviewed-by: Kairui Song <kasong@tencent.com>

