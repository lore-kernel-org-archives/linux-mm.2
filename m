Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9672FE88D67
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 21:27:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 071C76B008A; Fri,  3 Apr 2026 17:27:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0108D6B008C; Fri,  3 Apr 2026 17:26:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E413B6B0092; Fri,  3 Apr 2026 17:26:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D26D26B008A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:26:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A109C1603EB
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 21:26:59 +0000 (UTC)
X-FDA: 84618529758.17.06B0E17
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id 977E24000A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 21:26:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PTdwDalI;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=axelrasmussen@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775251617; a=rsa-sha256;
	cv=pass;
	b=5Lemem2WmrtfS0zWBe5e7gTsNSeJZAsFUNSYSlYUdmSFJiXrLlVAWFw/sSkttqH3hxNEjC
	sI37v9jWiFE9DJHPH5N8vPfqw2PWaTECZm7n4ToQ5FS2xerMN87VTakYEJK9zC4/jen4I8
	rK96Hpp2VaO6dAMZwhDK7F6/M+kMLrM=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PTdwDalI;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=axelrasmussen@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775251617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JygyBPq0IBbgjxo/rdmvZ+d08qdFQfdUpyEam4et1FY=;
	b=7fdN6V+YQh3FYHfB3aQNygZvzRK+w7+tltc0QS0XtHDy/Tob5JOfv12Jp/4pixe3rkWKsW
	YSeUzEQ0hU7D+Kl1tWvdqKptIlJi5XU6FLDBsRb/OD5PmHELKI1yUUdEQf1dmZ2C/udVyr
	kORk+/SwJbqONq7NpMGp02gLsCQwXZI=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-66bb7118c96so14549a12.0
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 14:26:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775251616; cv=none;
        d=google.com; s=arc-20240605;
        b=KhJ3dtQ6TuH0ktAOz+ifn5TgSwHvODxa2Ge8SbmQQXvrIqV0r4ESbdx69RfsfSgTqM
         BUXKAM88+TuJHABMTvsO59FZyVx0EgCgBoIFiCK8Y1Wb68Bgg3CYA5l4mwVORdoCGD6o
         5SlHFxcUdJvTUkLsFonVZ/JAWXZeYvilItg/jbj81x2efo3x+8wdIIw/Q+elnXO/RbeD
         efaGBQozZhj/MLJjcmRt8wM3d2HvYxEbgjLprL5GU7YpWrRqHpJf8yUD8aKkVmafqHTm
         EeoBR4iqhsQQ0zL9lI1ZSbzEPpVEkjvLlnn+F6BDEZ2Al3ZbajmrxxjPe/puTyK9pNz7
         +6xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JygyBPq0IBbgjxo/rdmvZ+d08qdFQfdUpyEam4et1FY=;
        fh=G3KOVX5TDfwMcAVieiVC4GptR+Yq+B6YJ7T7ds0K6bI=;
        b=GYdrzH87RN+5O8P7X2QV3xrIPqccVS1yJhStJ7Qdeb09RDqC7G4x4OP0ofIoZo/EcS
         wFmVAYUbAX5UKLAXoemZA3gaEe39kM9VyIyin19w8WmEJRAgrf4A6FY5kBZ5J/67huWQ
         bzgdC6172b2DLT/f+Wet37Ku6u6YkNs8qjZAFJkYdymAn6szC5g327PqQ8G0WYTvwKzw
         BAq+rsLMG0lXiBnNP2oYcP2u4AbhtGJ0MyzdlyIxGkqE0z3V4s5nDWartuAY6q5D2ApI
         8yXt33CVi2AYfNnXtZrlGn0izZbE6QaPUiq3Y5hR3+XJQOY3ZWwZWtmjgdk9+L3ZXXMo
         CJIA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775251616; x=1775856416; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JygyBPq0IBbgjxo/rdmvZ+d08qdFQfdUpyEam4et1FY=;
        b=PTdwDalIBCZP836UCN8oThL6OOeiAMLj3kfCWcwEKt5s+qvWKH8O/gvpYdi5IXPAMu
         u9m9sD9+ZHMpbrB8GMkEX/fmFwvR+mfw1sx2XQiIqUrxMA5FWAtCuxOFLOUgleuAe/4S
         /wUj6rl1QuzL/OHXhc4WP6ZfcTIk0jqVFuCy+4Q9mzq+Lwc+D8aeoH47v11ryHhdeUDd
         116poXM+rjIMU1Bl0Wbjn2Nb2NVdnveQ2hUSSqeJKLFNtPyQqgsxKNdXsr54gTYZUO9k
         2T5BOAcJM2eJUPugXNoCVeL/1bWnBYM5vVBe3FsAv2hRi3uqmcYGXo+4MOfgzs8TX9XD
         s6PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775251616; x=1775856416;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JygyBPq0IBbgjxo/rdmvZ+d08qdFQfdUpyEam4et1FY=;
        b=LnKPcw6v+1pSeW7Vz43XhF6S4SqengaXPcnrE7Xve3OCCg7Uqxq3O1n9CaZ0LkZ6tj
         rVmFp3AhP0sai9+aO15HfiSEojCRG7A96mVLIu8x7OwcrWiSSybm3ncJ6rsw481azaAE
         QOuS8LytetHe2IfRFcU6q1qKt2l3PoxhJHluyeDda7x840uTJsbqs4aib+TMOVQ+UgMo
         eyMSeP/WuzPjf7BS4BsxB1k/rIt5iupE52h5uGe7Z6E+/kydR1xr4WFQAvFrUgof5JVT
         lcbodYg8TUTLzb1qipc1pN+zM+J++zBhuaKCFa9L5tdCl1xuSyhZfXXp6cxLiZca+JTK
         lB/w==
X-Gm-Message-State: AOJu0Yzyi6dtjk1b6UdHi2FxfPHs2aRan381aYYgf7TalvUYFCYKY75q
	bpB6zZCJK3GLHZp0npmeGJwmLLFIIXpHaDf/KuSirtwABrPyaQWNydE24QY4pqPT+ds1RU3VH97
	mmo+AtYg4CmV+wKca50u3Oa83/bnMswcTHRL9izmS
X-Gm-Gg: AeBDiesXFD+iS8fwLNZ5b3p/AXEWoZ5RE6vU9dDTWVgVSCZAkTmfWBjQogvsi6Bhpwe
	IZq70YxN+CeRy/IcMhUnEWkaZOkUmkzGk59L3RPnBqq2iPKdYTNP/cvQLpZlz2aLGhTM/o2bIET
	GfVDmoHTofJ5XZxqNPDFR5q2MOt6iS9vOiV2cjf20/fUq8FlEa5b5xixYFQH2R7yF+2gMHlaL4K
	Prg/AAEnHyJSceOD/WgkmZdO/Vvaum/ooCbzhYpm2MbdgBvU3U3bfLnKRGXmaSAE7wOXp0HwdIY
	SAjTQuO3
X-Received: by 2002:a05:6402:1804:b0:66b:ed69:a85c with SMTP id
 4fb4d7f45d1cf-66e43f22b75mr36261a12.7.1775251615375; Fri, 03 Apr 2026
 14:26:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
In-Reply-To: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Fri, 3 Apr 2026 14:26:18 -0700
X-Gm-Features: AQROBzBnKqnMcEMsRJabc18tkmfIXoocUCUdWoEHt9gTl7MK9vuztheAN8EiFKs
Message-ID: <CAJHvVcipEXqhrTPmSu4x1XU+dM+GvCag63ekmr4xQMPxGt8XFQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] mm/mglru: improve reclaim loop and dirty folio handling
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
X-Stat-Signature: 8gusknz6r6tgfm59gmanif6kd3acrbqq
X-Rspamd-Queue-Id: 977E24000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775251617-990758
X-HE-Meta: U2FsdGVkX18hk21sAh5BshquLqE9OVwVC2jnhnAVgV0VzAxP2UZSi80DLWcG3ODyBgRD7PJ1387LFV2YTbu7/5YB6CdVoiMqPVkyVCn6bc42P2DJRK++t0ycjuUOrZjs5ttbCf9DQUMk2FfuXFhtMiVPJ5Mr9TXLAXMnxJK5zwqgZDhGkyZc8n0NHujcM5FqgJj0Q9y1vpqEN65+1YmPjlW+FFfoDq7puN23a/XsXEiifdL2GJemIourOXO3aOpPhi+PToRPbSyfKIblBCxFMVVb1Zl7FW/0SzFfhwGSQREEIse5qqfn4dEQbUYxd+Xgqzeg5P5H5RK8/MwRjIQLJNcNtYkO/GS3jXQ3DkaW2VcVc12C/L1QDvpn8nlnPZPWNZtz5cUrJEiAFIGFy8QMNk0qpuKuZeABMscVNIpMa9OB3q7PpSSEOw9CaTZrb0dtdGzhoa4uDxlsTW95xDjj6OYp+YZdRCiJ/Jd7r1o17EpomjKhw202HfRaOYWypZFmxD+Mvw2aILek2AOKjPzAVgXjdaNSiXrU75JJc1iuO6Cay4sX8AiKwPXnvyzLv2z2wDT+qAPAbXN+jA8Ud9sm0kcAbNq8b9gD2KI6RE/Hjekk40Gu7m4lKP0S49bpj0bOf4/JGwI7xEaszhgpns0NWfbN9sAWpK5hCWlB2nR2HLxRUYLwIMsp2z4A+rZPFMEPmTdlEJHnZL67dMTF55y7lp84goGpj2+2dAduDG3Wv+s8VI/4CNbbEBw/iyjKp73jlJ0L3d2Hl8Kl1NzFRM2tAuz/X3aF4RSd0dUaECS4t2w8j4CRBYNOpmfn0G2hHkSpHuHvjEQ69dEvrlAU2sQva3y1O+S0/Yml/z3o5bGRX7jmpMjUXwu4yKUar+J4Vs2y8qnddpV7h9CQBBUdcVkuWJoRE2HAm6eucDW95vEy80CofYaEbeRrF08hCAMiMPIVQcskq65/3R8NvKERVbY
 IRsjd2pn
 ngHOHoiGJl4qdPL10dKmxFK3LUFeY5yt/FfaWxQEihGcnS5NKc1DLQMBAPsxGWbCs5aQF/nVkf23utqfsOn8ZE6nn6Us6Qrr2F7e7dFKCaeyOHyn33fOXqNAiQD8+QqpuCfnOqZZ8N/gzrRLzqr/jFKbFZp07MVZmwMNvoLLVD42Y4A16h2YUNtZwiIlBr/1wO5b8mggr1bEV2/huoQZ0lfK6JdtGTKy+mrPrd3OIhaG9ptZOFb/i1rlh8rrRBqGu1YU77AcEKTo+AGH3QwNCSP2Wg5pobrxscDYKXv6RVP/Gg3z6SPAksMAI9ggQIPwKmVPVJg1IiLC/ZHOecH5CfRGrsz4lZyJKMgv6p61RGbVmUqvr0H4q4YSYI2Tpm1o4kXh4FiYNITZv/L8tIkRbHydRHBIIckYolsFMRgMIsnGTRpyElFc5q+/mH24tzcdxlZ4dM+g+gk9ZbxkoWGPmD3H0JquP7eHipsYoYwYFdOQnF4jrxPZWqB7J+ftzyqewRdUxxmTU2sww0STyhb/ciuqaRHY3sXa+q/nZM1z5htxpv8hIVI/VxI+MIpXX1pfKcDFq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 2, 2026 at 11:53=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> This series is based on mm-new.
>
> This series cleans up and slightly improves MGLRU's reclaim loop and
> dirty writeback handling. As a result, we can see an up to ~30% increase
> in some workloads like MongoDB with YCSB and a huge decrease in file
> refault, no swap involved. Other common benchmarks have no regression,
> and LOC is reduced, with less unexpected OOM, too.
>
> Some of the problems were found in our production environment, and
> others were mostly exposed while stress testing during the development
> of the LSM/MM/BPF topic on improving MGLRU [1]. This series cleans up
> the code base and fixes several performance issues, preparing for
> further work.
>
> MGLRU's reclaim loop is a bit complex, and hence these problems are
> somehow related to each other. The aging, scan number calculation, and
> reclaim loop are coupled together, and the dirty folio handling logic is
> quite different, making the reclaim loop hard to follow and the dirty
> flush ineffective.
>
> This series slightly cleans up and improves these issues using a scan
> budget by calculating the number of folios to scan at the beginning of
> the loop, and decouples aging from the reclaim calculation helpers.
> Then, move the dirty flush logic inside the reclaim loop so it can kick
> in more effectively. These issues are somehow related, and this series
> handles them and improves MGLRU reclaim in many ways.
>
> Test results: All tests are done on a 48c96t NUMA machine with 2 nodes
> and a 128G memory machine using NVME as storage.
>
> MongoDB
> =3D=3D=3D=3D=3D=3D=3D
> Running YCSB workloadb [2] (recordcount:20000000 operationcount:6000000,
> threads:32), which does 95% read and 5% update to generate mixed read
> and dirty writeback. MongoDB is set up in a 10G cgroup using Docker, and
> the WiredTiger cache size is set to 4.5G, using NVME as storage.
>
> Not using SWAP.
>
> Before:
> Throughput(ops/sec): 62485.02962831822
> AverageLatency(us): 500.9746963330107
> pgpgin 159347462
> pgpgout 5413332
> workingset_refault_anon 0
> workingset_refault_file 34522071
>
> After:
> Throughput(ops/sec): 79760.71784646061 (+27.6%, higher is better)
> AverageLatency(us): 391.25169970043726 (-21.9%, lower is better)
> pgpgin 111093923                       (-30.3%, lower is better)
> pgpgout 5437456
> workingset_refault_anon 0
> workingset_refault_file 19566366       (-43.3%, lower is better)
>
> We can see a significant performance improvement after this series.
> The test is done on NVME and the performance gap would be even larger
> for slow devices, such as HDD or network storage. We observed over
> 100% gain for some workloads with slow IO.
>
> Chrome & Node.js [3]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Using Yu Zhao's test script [3], testing on a x86_64 NUMA machine with 2
> nodes and 128G memory, using 256G ZRAM as swap and spawn 32 memcg 64
> workers:
>
> Before:
> Total requests:            79915
> Per-worker 95% CI (mean):  [1233.9, 1263.5]
> Per-worker stdev:          59.2
> Jain's fairness:           0.997795 (1.0 =3D perfectly fair)
> Latency:
> Bucket     Count      Pct    Cumul
> [0,1)s     26859   33.61%   33.61%
> [1,2)s      7818    9.78%   43.39%
> [2,4)s      5532    6.92%   50.31%
> [4,8)s     39706   49.69%  100.00%
>
> After:
> Total requests:            81382
> Per-worker 95% CI (mean):  [1241.9, 1301.3]
> Per-worker stdev:          118.8
> Jain's fairness:           0.991480 (1.0 =3D perfectly fair)
> Latency:
> Bucket     Count      Pct    Cumul
> [0,1)s     26696   32.80%   32.80%
> [1,2)s      8745   10.75%   43.55%
> [2,4)s      6865    8.44%   51.98%
> [4,8)s     39076   48.02%  100.00%
>
> Reclaim is still fair and effective, total requests number seems
> slightly better.
>
> OOM issue with aging and throttling
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> For the throttling OOM issue, it can be easily reproduced using dd and
> cgroup limit as demonstrated in patch 14, and fixed by this series.
>
> The aging OOM is a bit tricky, a specific reproducer can be used to
> simulate what we encountered in production environment [4]:
> Spawns multiple workers that keep reading the given file using mmap,
> and pauses for 120ms after one file read batch. It also spawns another
> set of workers that keep allocating and freeing a given size of
> anonymous memory. The total memory size exceeds the memory limit
> (eg. 14G anon + 8G file, which is 22G vs a 16G memcg limit).
>
> - MGLRU disabled:
>   Finished 128 iterations.
>
> - MGLRU enabled:
>   OOM with following info after about ~10-20 iterations:
>     [   62.624130] file_anon_mix_p invoked oom-killer: gfp_mask=3D0xcc0(G=
FP_KERNEL), order=3D0, oom_score_adj=3D0
>     [   62.624999] memory: usage 16777216kB, limit 16777216kB, failcnt 24=
460
>     [   62.640200] swap: usage 0kB, limit 9007199254740988kB, failcnt 0
>     [   62.640823] Memory cgroup stats for /demo:
>     [   62.641017] anon 10604879872
>     [   62.641941] file 6574858240
>
>   OOM occurs despite there being still evictable file folios.
>
> - MGLRU enabled after this series:
>   Finished 128 iterations.
>
> Worth noting there is another OOM related issue reported in V1 of
> this series, which is tested and looking OK now [5].
>
> MySQL:
> =3D=3D=3D=3D=3D=3D
>
> Testing with innodb_buffer_pool_size=3D26106127360, in a 2G memcg, using
> ZRAM as swap and test command:
>
> sysbench /usr/share/sysbench/oltp_read_only.lua --mysql-db=3Dsb \
>   --tables=3D48 --table-size=3D2000000 --threads=3D48 --time=3D600 run
>
> Before:            17260.781429 tps
> After this series: 17266.842857 tps
>
> MySQL is anon folios heavy, involves writeback and file and still
> looking good. Seems only noise level changes, no regression.
>
> FIO:
> =3D=3D=3D=3D
> Testing with the following command, where /mnt/ramdisk is a
> 64G EXT4 ramdisk, each test file is 3G, in a 10G memcg,
> 6 test run each:
>
> fio --directory=3D/mnt/ramdisk --filename_format=3D'test.$jobnum.img' \
>   --name=3Dcached --numjobs=3D16 --size=3D3072M --buffered=3D1 --ioengine=
=3Dmmap \
>   --rw=3Drandread --norandommap --time_based \
>   --ramp_time=3D1m --runtime=3D5m --group_reporting
>
> Before:            9196.481429 MB/s
> After this series: 9256.105000 MB/s
>
> Also seem only noise level changes and no regression or slightly better.
>
> Build kernel:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Build kernel test using ZRAM as swap, on top of tmpfs, in a 3G memcg
> using make -j96 and defconfig, measuring system time, 12 test run each.
>
> Before:            2589.63s
> After this series: 2543.58s
>
> Also seem only noise level changes, no regression or very slightly better=
.
>
> Link: https://lore.kernel.org/linux-mm/CAMgjq7BoekNjg-Ra3C8M7=3D8=3D75su3=
8w=3DHD782T5E_cxyeCeH_g@mail.gmail.com/ [1]
> Link: https://github.com/brianfrankcooper/YCSB/blob/master/workloads/work=
loadb [2]
> Link: https://lore.kernel.org/all/20221220214923.1229538-1-yuzhao@google.=
com/ [3]
> Link: https://github.com/ryncsn/emm-test-project/tree/master/file-anon-mi=
x-pressure [4]
> Link: https://lore.kernel.org/linux-mm/acgNCzRDVmSbXrOE@KASONG-MC4/ [5]
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
> Changes in v3:
> - Don't force scan at least SWAP_CLUSTER_MAX pages for each reclaim
>   loop. If the LRU is too small, adjust it accordingly. Now the
>   multi-cgroup scan balance looked even better for tiny cgroups:
>   https://lore.kernel.org/linux-mm/aciejkdIHyXPNS9Y@KASONG-MC4/
> - Add one patch to remove the swap constraint check in isolate_folio. In
>   theory, it's fine, and both stress test and performance test didn't
>   show any issue:
>   https://lore.kernel.org/linux-mm/CAMgjq7C8TCsK99p85i3QzGCwgkXscTfFB6XCU=
TWQOcuqwHQa2Q@mail.gmail.com/
> - I reran most tests, all seem identical, so most data is kept.
>   Intermediate test results are dropped. I ran tests on most patches
>   individually, and there is no problem, but the series is getting too
>   long, and posting them makes it harder to read and unnecessary.
> - Split previously patch 8 into two patches as suggested [ Shakeel Butt ]=
,
>   also some test result is collected to support the design:
>   https://lore.kernel.org/linux-mm/ac44BVOvOm8lhVvj@KASONG-MC4/#t
>   I kept Axel's review-by since the code is identical.
> - Call try_to_inc_min_seq twice to avoid stale empty gen and drop
>   its return argument [ Baolin Wang ]
> - Move a few lines of code between patches to where they fits better,
>   the final result is identical [ Baolin Wang ].
> - Collect tested by and update test setup [ Leno Hou ]
> - Collect review by.
> - Update a few commit message [ Shakeel Butt ].
> - Link to v2: https://patch.msgid.link/20260329-mglru-reclaim-v2-0-b53a36=
78513c@tencent.com
>
> Changes in v2:
> - Rebase on top of mm-new which includes Cgroup V1 fix from
>   [ Baolin Wang ].
> - Added dirty throttling OOM fix as patch 12, as [ Chen Ridong ]'s
>   review suggested that we shouldn't leave the counter and reclaim
>   feedback in shrink_folio_list untracked in this series.
> - Add a minimal scan number of SWAP_CLUSTER_MAX limit in patch
>   "restructure the reclaim loop", the change is trivial but might
>   help avoid livelock for tiny cgroups.
> - Redo the tests, most test are basically identical to before, but just
>   in case, since the patch also solves the throttling issue now, and
>   discussed with reports from CachyOS.
> - Add a separate patch for variable renaming as suggested by [ Barry
>   Song ]. No feature change.
> - Improve several comment and code issue [ Axel Rasmussen ].
> - Remove no longer needed variable [ Axel Rasmussen ].
> - Collect review by.
> - Link to v1: https://lore.kernel.org/r/20260318-mglru-reclaim-v1-0-2c46f=
9eb0508@tencent.com
>
> ---
> Kairui Song (14):
>       mm/mglru: consolidate common code for retrieving evictable size
>       mm/mglru: rename variables related to aging and rotation
>       mm/mglru: relocate the LRU scan batch limit to callers
>       mm/mglru: restructure the reclaim loop
>       mm/mglru: scan and count the exact number of folios
>       mm/mglru: use a smaller batch for reclaim
>       mm/mglru: don't abort scan immediately right after aging
>       mm/mglru: remove redundant swap constrained check upon isolation
>       mm/mglru: use the common routine for dirty/writeback reactivation
>       mm/mglru: simplify and improve dirty writeback handling
>       mm/mglru: remove no longer used reclaim argument for folio protecti=
on
>       mm/vmscan: remove sc->file_taken
>       mm/vmscan: remove sc->unqueued_dirty
>       mm/vmscan: unify writeback reclaim statistic and throttling

I read through all of the v3 patches, for me they look ready to go. I
don't see any of the remaining small optimizations as reasons not to
merge at this point, there can always be some small follow up work. :)
Feel free to take on any of the patches that don't already have it:

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>

>
>  mm/vmscan.c | 332 ++++++++++++++++++++++++++----------------------------=
------
>  1 file changed, 143 insertions(+), 189 deletions(-)
> ---
> base-commit: c17461ca3e91a3fe705685a23ad7edb58d4ee768
> change-id: 20260314-mglru-reclaim-1c9d45ac57f6
>
> Best regards,
> --
> Kairui Song <kasong@tencent.com>
>
>

