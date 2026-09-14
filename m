Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8F76C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 11:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C541B6B0088; Mon, 14 Sep 2026 07:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2CDE6B0095; Mon, 14 Sep 2026 07:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B219F6B0096; Mon, 14 Sep 2026 07:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F61F6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:34:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0457012033E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:34:13 +0000 (UTC)
X-FDA: 85212159228.03.4B79640
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2DE111C0002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:34:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VtqG7JG9;
	spf=pass (imf21.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789385652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zluWgUEfiwqdpafmPuw47cpG+Z5oAjBePu1fe1afIYk=;
	b=Z9nJ+Uhrpom2gRWqYIq/302Oc6+wHbwZEpevXVlUKK6W8htip+0FiX7rN1n//oCh0z7sb1
	MD7HUpXu6ycO3/pA7vqOIBdAqruaywjYluuaj92tIxsMWk0HrGH3epBhxdBxl0j/L6qyvn
	zGJz0HpCbfeMpsbQ7iU5rHGTDtQpo7s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VtqG7JG9;
	spf=pass (imf21.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789385652;
	b=QMwURyoXUH2a1eDGHpJ21CzEW4LmkK1quVmx27rXr7e/EYgwwbOAX4cv0WqGyFhbWXVEq/
	ZVXvVR0SqQ/x63sOxHooJkmmJ2cR+KG2vIiNaVtJTOO+7vJK4rYJ6JhII0AItu1C/iS/G0
	mcJwP0OqDZ5unYVHZW/F5Su0Xh/WCRM=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747f0135fso16360195ad.0
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789385651; x=1789990451; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zluWgUEfiwqdpafmPuw47cpG+Z5oAjBePu1fe1afIYk=;
        b=VtqG7JG9IxUPr4iW98hJtjA7TfKkkyOp8+s7FLlGPn5XHEXxUBHHXeZA4mJfNmsBTY
         SkdXc+yQxXX8na6Af1hst8/GoNpTLXrP02w7lBTIDnoBAWDrPaJ1EMuK986PZPfVMYxF
         0WzcyGnbtf9om6EByTB+Dybz+/dmRmwHPjHo8OmiRUA0q1NLIAYp3k6B1hvfQOPgVMVe
         0M4xNf8/VqVdwUICe9GU14YashC2SYr2q4OmvaH9qA8e/XtYwdcs6E3t+zluuruowVKS
         M8eoh0raYBhY1iDMjKxypYxffieoblZ+1UqXtu+TdvwXeBJYhOIIU4GB+PoCURuOsP8e
         qTFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789385651; x=1789990451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zluWgUEfiwqdpafmPuw47cpG+Z5oAjBePu1fe1afIYk=;
        b=RF5Mxtr5aBXVaozonbfNaZ+D1iqjcVshr/Mp0GHGl2Qg+9p4muXvRqdm49KdNxCYCL
         jqHQhGiTl8omPLUNVv+nt/hLZlUGqu9jnEhSfD7DDFOwDC+8BA8CNs/IIRpSSDRLoa4U
         7LbQBLCaaDNd91psowC5N4v/eF6nc3lpa0dpSX2bTumHhGFM+hkOHqDJ0nnoAWCbT78r
         6YoT+vh4eeo9KER78WUnWSVTrgGP64ZLEmwkCzfhE3GyaIwf0balecuYjxEFdBmeq+2j
         dIPKBQvLVitm0E6FvRN9npjUJGf6W5VNLKin/qRRJFZSDORZ6ME6phR4LusZBBjQuWly
         GAmA==
X-Forwarded-Encrypted: i=1; AKwUvBwyWdhuYOt3A3vl4ufFnispHo2M2J5mqmD6qOQO5d6sFAShmQ1oGnSyes9vrnuGwNT2z07bsWiTLQ==@kvack.org
X-Gm-Message-State: AFuF++kPO0oyIiDiG1mfnhVn5vx/lP7olbb9wty3RqnRbP13aLfFRyp6
	qvkhC2qnbeYf/JCyc9mddcvRXLy8AEAR0rFmbNz5wzCZK/aKQPKOPd/P
X-Gm-Gg: AYBFou0+Lu2fK6QnOgsU1P7+2KnfaqkHFKENQe3v8AXDH8g/zGPaF3J4xZBoLeI5Pho
	NtTC456Qsnizthm0mQ2t6++A7dTSBgDR0ZFYcRUww5tuZ3fTK+s/gT4+RR55r/2uMGyfalMiDxQ
	eCTYmP9GaUEx59Aix3g6RBE+n8aSMgQbnQid9h0Ye/vOsIZr5KcWkmerXyhPUQdELlZEjnNEdP4
	p7vVWvZWUWfHf43KhwxCb12yFKKOiSh+/IYy34Z2HmXUM9H+HcTs/1hQoeJYiB1lqNqpLDvM9OB
	lWEw0DpyLRlIUi/t5LrLxY438kvYBm7l/GOUo0+Y1dm2QOY7g0eU2s8lkbkLkgOtx0CaT+cM7HX
	A7C9xA9Y6JPze4V3MGOg1MV/NdLRwez1UujgPNqoQIIfMSXZ1RvFJYdfg94a2uoVxKTzHULAwEx
	e1mlkUwM+xYPx89dGL5MF27VsLTTfhbfmkds9bpar67xWavQeJj8y9nzI+UdHiW/ZENned2hLZU
	hntUlSKgjo1TsjJge1Cq25VKTr6CxV54/dv8kDf
X-Received: by 2002:a17:902:e88c:b0:2d9:599e:df95 with SMTP id d9443c01a7336-2dd6c5cbdb1mr41439185ad.3.1789385650870;
        Mon, 14 Sep 2026 04:34:10 -0700 (PDT)
Received: from localhost.localdomain (vmi2317699.contaboserver.net. [85.239.239.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2cfd8c84sm46512045ad.62.2026.09.14.04.34.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 14 Sep 2026 04:34:09 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Wang Lian <wanglian@kylinos.cn>,
	Kunwu Chan <chentao@kylinos.cn>,
	liz2nku@gmail.com,
	xueyuan.chen21@gmail.com
Subject: Re: [RFC PATCH v2] mm: Improve pgdat_balanced() to avoid over-reclamation for higher-order allocation
Date: Mon, 14 Sep 2026 19:33:47 +0800
Message-ID: <20260914113353.94964-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <aejtfpBUu7gNV6Tk@cmpxchg.org>
References: <20260422021842.78495-1-baohua@kernel.org> <aejtfpBUu7gNV6Tk@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: g37wfwn8ds5knfp96worsxzttmrrtbrd
X-Rspamd-Queue-Id: 2DE111C0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789385652-564607
X-HE-Meta: U2FsdGVkX1+gUe0fuLsC65dEWqu5qKbxENcoQ0J7LBm83KFYGnmuP26tzcqEJi1KQE0wgiEyP+q+6q8sTZdC2rvaNOOkEHIA7aLBKXJgH4citvaCcHDYnsQpX60XQ8hqyVkMifUBiLaSwHw3jUm2iYg+nUAd64ylddsUPVarrjjUmyZ6Fi9cuNZKgLyGDSws30SJLZUpIVI8GcBbH5lmuV5i4jw4wyaNhaTOy0mlEzhHijMNmtcVxK+VFr2sJYlz+Q2RjHb/GLaPPjLxKJv+kBtVNauoRCY0BJHDWw+A4N/vCSHkkH8nEQDrPWNDrww0ns1J3IJ5vDQWwkNgioL98i3mXCprxkbjytaJCD9qux0xril2W0IdwXFx7fggi+hnaMJAcu+0Gs1lR0ar7m7FPKLtOjTJoxv9gD1OzoIBk4kfrqYufcWrjJVx1m1KtqC8/WRvPybFuMBER/KD+C4F/Dj3Iqtv5lVVany7da6YLEgxwWOZezfzeXxMl8189byXcKPqtKA8HNZdygTy8lZyhVaIMn3kGMMi/hk5M3dm0yzcWWcZbB6KqMd6d75f9UzVi2vWhHrmipN5n3EhWTuqfX0L5z/lhwAfoe/149EkAj3FGaD49nGkKEompTlKaK106eLj70E9wfXtYM2xvuxI60g0pPvmSuYHoiMsW2vvowYvUsJU15Tsk90tSr1gfyp7eUS6/9jmh52mxGrKw+A8JcsmMpKHBa98IeZOrin3IONBxKDApVkjsrL5/+4okT/J6H/tlKFNBpnnGXvn2uPpXdXwVJGqlv21FuE8//p+fD749ovR2FCo8a5thFS6pLCHjNOGuxPur+monq8gHnzTUqW+s/+kO0MxUyeBuNkKjOPnXO/62SgRr91+xDmpqBWVSEKaguBt9cPBTyfoHE73Be2Wp1KlryEVCCaUMIu7dFiKceuEIza/P2A5IVJFWx1T5WOk58MJAeZE+BOKx2X
 WQ4gDpr4
 au3nwFQlEU/X6ElGSEF9MV7fvjsXDqfYWIwd3AU2iMVn97DERXjlGconwdh4MzSFQW2Fl81rG8gY/iwtSp1tI+4kBsYF6Mw758o+O1X8o9iE4Yx2n7y0yYY5uFCHCgngqnq/HyFnzv0KsT5/0/tuvDJNEaFr7Ex5Z9LV9plMSkN2YDF/3x9/Ygjs2wzPaP7N2J8rBTMkf8DYsmpcwttQ8rxfJ/LmyH9MdFNVVVJ6oPGDz/em/MBVBR92MgOwRd975NHNYAvqiyeza8vtV5l61+wyFeeXoxc00VuAvEM+2T+Wfp8fQ0411ok18dDsulGOum4qQSNBrMPZjXOeuyHWGrZrk4Miw+y97GjeA3ixWgBTWZCEwvN7p3sV2IErJDQH6NeZcRUyvblaB00p3j9kaZfTLQX4hf0wniFFmdwwANHH7nuUV407YCPUYL8Uw17/v1VwUOQBqvgcoLt7FVkhcCzmb47DZlmPpOeMZdEuAEGcBivV+qBxECgDlv5Xu6eZwn7bOtePURKQDcR+J2R7QkvMKk1OeMOL53buogNthHBa1CHPl21RkbB3yxZu4Eh83a0zk4nnp3mqm1dRA4Ysaj8POybSx0Yc3qFD53I7/y8VWE48=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>

Hi Johannes, Barry, Baolin, Kairui, everyone,

We revisited the thread and Johannes's earlier analysis on the kswapd/kcompactd
handoff. We agree that a single static `compact_gap()` cannot represent
hundreds or thousands of concurrent higher-order requests. In such workloads,
repeated kswapd wakeups often reflect real unsatisfied demand, and stopping
kswapd too early can shift the burden to direct reclaim and direct compaction.

At the same time, related reclaim issues are still appearing in several
environments:

  - Barry observed order-3 network allocations causing persistent kswapd
    activity and device heating on phones, even though requesters can fall back
    quickly to order-0.
  - Baolin and Kairui have seen similar fragmentation-driven reclaim behavior
    on servers.
  - We have reproduced on PCs and VMs that order-0 memory and total available
    memory can remain plentiful while order-3 blocks are scarce, yet kswapd
    consumes substantial CPU and runs heavy reclaim/scan loops. We have not yet
    reproduced this consistently on our server systems.

There is a useful parallel in Johannes's production work on reclaim storms in
defrag_mode:

https://lore.kernel.org/20260626182215.1107966-1-hannes@cmpxchg.org/

The allocation paths differ, but both threads expose a similar feedback problem:
reclaim may report progress in the number of freed pages, while not making useful
allocation progress for the order, migratetype, or fallback intent that triggered
it.

> The compaction gap is sized for a single allocation, but
> kswapd/kcompactd are a shared resource for potentially hundreds or
> thousands of incoming requests.

We share this concern and do not want to replace the existing incremental
pipeline with one fixed value. We would like to separate two possibilities:

  1. One high-order kswapd wakeup overshoots `compact_gap()` substantially
     before `sc->order` is reset and kcompactd is woken.
  2. Each wakeup makes bounded progress, and the total overhead comes from
     repeated wakeups after best-effort callers have already fallen back to
     order-0.

For the first case, limiting the high-order reclaim scan or per-wakeup reclaim
budget when order-0 watermarks are already satisfied may preserve the repeated-
wakeup pipeline while avoiding a large single-pass overshoot. For the second,
we may need stronger accounting of outstanding higher-order demand, instead of
treating every repeated best-effort attempt as a request that still needs
background progress.

Would it make sense to align on a common, parameterized reproducer and trace set
before choosing between changing `pgdat_balanced()`, bounding the high-order
reclaim budget, or improving demand accounting? A useful matrix could cover:

  - best-effort order-3 allocation with immediate order-0 fallback;
  - sustained and concurrent THP or pageblock-order demand;
  - default mode and defrag_mode;
  - phone, PC/VM, and NUMA server environments.

We can share our reproducer and the PC/VM traces, and adapt the workload to
collect per-wakeup `nr_to_reclaim`, `nr_reclaimed`, `nr_scanned`, order reset,
kcompactd activity, allocation success, and fallback path details. It would be
very helpful if Barry, Baolin, Kairui, and Johannes can tell us which parts of
this matrix and which counters best represent the phone and server cases. Then
we can compare scenarios with aligned measurements and work toward a solution that
does not trade mobile reclaim storms for server direct-reclaim/compaction storms.

Thanks,
Lian

