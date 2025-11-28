Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29271CFD2F6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 03:10:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 168636B0011; Thu, 27 Nov 2025 22:10:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1190B6B0022; Thu, 27 Nov 2025 22:10:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0078E6B0023; Thu, 27 Nov 2025 22:10:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E0F646B0011
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 22:10:46 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7281B5875A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:10:46 +0000 (UTC)
X-FDA: 84158538492.26.388B82D
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9E46640003
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:10:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B8WBIPO1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.210.195 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764299444; a=rsa-sha256;
	cv=none;
	b=EFcfydHWjbpSfFhayPRGCdbj78W5yF2kVuvzHe/D9fsKQMrIlygJr6TMzNJwqGKHIBIBWy
	eVdTjbllSyXZ9MKaoWh0ST/6behfuNJF/2Z3C8H0UmXMr5RVFCJKzxSM2o0DeoLKJsCno3
	LF+5g89ARxIjqwou/rchvK9d60NXj+I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B8WBIPO1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.210.195 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764299444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QpEVBTEiaMntEeQm5HKo6Y/6A0tcdnVvc0Vesn59Czo=;
	b=E0uYmc0bxTDd2D/wjGEfEap1yqVFPD4tGQdMVPx6zZEBz6Cg9aGMOBaTAmDF4/JU1EcMFJ
	UnJGrZ9lvxH0UIgeg062GELOTKERS7Nmk9nKTuvAsAQWlkbpBso4pNS1hOe4PkibKCzrZl
	pr5yRIG1jhwFV+Q5SzQRVl9daCPJpBI=
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-7aa2170adf9so1211556b3a.0
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764299443; x=1764904243; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QpEVBTEiaMntEeQm5HKo6Y/6A0tcdnVvc0Vesn59Czo=;
        b=B8WBIPO1OplEgxFqu15chJEXFOLdh+a+vFLpGdf3f9NCevpeJrn0CT+3dVcUTXOcj7
         oYpUboY+FWvs98cEs7DIAos9FQ3WJMRfv8DdAkTxQyX3PLuNDVLV430IOD5//RVmWga2
         +Upa3eGFjklF31kYN04RxaD4/FldDU6saRcwaKyJyf9ZAS2lvFlWbmsXdoc/ri5JJtTM
         wY0D5b13LYwmV2YKa8GNpkgJACj8YgDCCX4EfD0nucusEAz51PDonBYDcyc55Fgkvjg9
         RX2OAUD7aeKxJg8/Sf1yf13bqcL7p/+paXV4VrZdkw9kYZ9o4X9qU0a3aGcG1IgQ6ub1
         zREw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764299443; x=1764904243;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QpEVBTEiaMntEeQm5HKo6Y/6A0tcdnVvc0Vesn59Czo=;
        b=Sg29gRC4wyKLw9tbtnQzW839RvzjRWPOyX90oSRPShLozzzU7hatXO4aZGZWIwPL8w
         chhDZof9eb5d6nLEIo6F4HC57DJyyiAtPjX74O6kFGGiYE1UB15AuT4hlbVyTiVKG9Ef
         Cdr5+H3cD0P0u0x1Bh4MyMs21WWVPUovV8ltm8rxzTWHTyqBcuptcjfrOYy9O+ixeP48
         0ITviSkPkSp87g1relmIH38EqvQVWuIkQFBIZ6r6N0xVycKnEcjDlL8m8JtMgnZXRjv5
         w3kfSxC4Rs8gKoNXfY6XnCS1C9m8y++UezWIFZDDE3tjK65Xl7Jfs+dOZEQPPzHfweMF
         L5cA==
X-Gm-Message-State: AOJu0YzaJrzh18xoIrvhx6xJYJ213b2UjRJmnaG4R/BGhN5PHpZQSy4i
	WM7YV8PhrEd7wS49GFRGryfJ9+AYhcmAJwIMB21552/FbANVJJS5yDJ3r0Ri1LIUfd8=
X-Gm-Gg: ASbGncsURqGZTJVPN+O6H1dSPPMexSwzB4btjCpfbBQGl8QQfE742O8gJ1FDD3fwubM
	PVEkUsHLY3APpLprtpjGxS1+t9vCY4JKZL3Wthk/xSPYtWbHa2UM/S8hyU5EDmyzPm1jutpJAct
	XDmHggcjtYKGH2+F1UMCUY+d7OhMnL/etS7l1/bGqntUXtD908lCYjroA1u2cDSSdQEGndlPxp9
	d0VdTB0RldyB1mVTJRLGEFZtd1HVnXKa4j1YMwRHefWxy8mX+Yg1v/qeugYrNYnoqhjxEpw9EP2
	n7sENq8Q25K0yMDPze9kxzjYpPuCPJx7KFx9Br7mbaGEIiGxl8u7GQQzsTYfoYM6kq9hugl8xbq
	DGEEuSQ/VajGFYMiEZ20y52lbT7Zk112/FeCCjSKfl4ufMcXAfTGNNvZB1m9V/3+x1ds9PNL57O
	PLImJBfyYgu/P17Lj5n7EQMBH2C+bvY7PUjAJduA==
X-Google-Smtp-Source: AGHT+IHU0TKIKvTyCwgA6VYM3+420xeEIdmRWaL0GwrquL672aNxLm2f/1lKO1R0yLt6VtVVoZnJCg==
X-Received: by 2002:a05:6a20:244f:b0:343:72ff:af80 with SMTP id adf61e73a8af0-3637e0d4931mr14505450637.58.1764299443334;
        Thu, 27 Nov 2025 19:10:43 -0800 (PST)
Received: from zhr-ThinkStation-K.mioffice.cn ([2408:8607:1b00:8:3638:7863:b439:f5a7])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-be509d5723dsm3065928a12.30.2025.11.27.19.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 19:10:42 -0800 (PST)
From: Hongru Zhang <zhanghongru06@gmail.com>
X-Google-Original-From: Hongru Zhang <zhanghongru@xiaomi.com>
To: akpm@linux-foundation.org,
	vbabka@suse.cz,
	david@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Hongru Zhang <zhanghongru@xiaomi.com>
Subject: [PATCH 0/3] mm: add per-migratetype counts to buddy allocator and optimize pagetypeinfo access
Date: Fri, 28 Nov 2025 11:10:11 +0800
Message-ID: <cover.1764297987.git.zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9E46640003
X-Stat-Signature: ta1r3iro9tpy5h9c4nadjiwe4z45d7gw
X-Rspam-User: 
X-HE-Tag: 1764299444-850193
X-HE-Meta: U2FsdGVkX19yX4b/20VB08UegWySmtOVBbpzIsmPYLCqnT7vS5VtcJ+dmlFOktdcVbizhz1WmKs/TfrgTgronWCqkoJgjVaBncJA23DPXXV401tBDfE+FHbm4/mZ2NySoRYigS4eyQzjKkG0SZXk5LrnUc+wzUNDGi5FBmFTQkd3kMmrYiMiSAUQLpvUFz2vh2gmb8mvr4K4F2SaW6hyPDMWQ/8govvyi6l1ctz4k2d3DD8YUVdad7wk+o92uNrk/BEjfHuHLXkiKwRPRLYUrJIq2Fs1iER/FkU3nwUfpAS3WjhB3kwK10MzoAEpcjj3NR6SupYtR2rQB6lPRxbcbe9KJcnFKy7E7lOOip/DE3WpuRWn0cd4NeOvifcUF6mUSm0d/0pNO6zQ5K4Kel9ZjtTx1V9MFGHnw5By5Kesq8aeUBtfkjH6RsedZW+mYXhdW4roolRONDY55uvuTGiZmOnJ26t1XwtOO/i9DrPwyHr8S5kYXua90oSqJ6Z+auTvrVg2VhAL0IACFxV2EO5CpoUN5Uo3poombQqr1MK5dEpA7g0AnuW78+W7jN70BBPfGgrFDM2VgusTmMtxCsAfL736+dLUnRtMNDTYDgmx0lVfrku2CHuCELcgiIh0IUxVE3ixYbcPVTUK3SplSJY6xh73lkPO9v2PYDCt9hS2Z8YoE+hHOg2/SbjEvhtx2cjXswfgZSEaci/u5k+hzSHtIn/yigssIF5wl/8f7Wkw42b983jA06sPiKDWbrChEtkU6fbuNXaxytWXbfp45UXM92VR6+YU0Zgzxg6p/n8ZL1jFgPBqeDpyoTmWBhmA5/0nialBI8gFEyo5e1YhoqVI+mT6UhMQuHJsECWKvr70uoMn3NY3hxgOKbV7DEU0PJLYVdzuAD0zS25EWDXpJHmTmaJJixDEnQKlb3reBlV/cF58r+rbkI256KNdmHlzETYdlZMGllm9fvzQJVuBiFU
 Z50Hj8qA
 EOoXiGkw1aLD0UM6mnY4FzzhEQ6zngU5Gtfug/jxl/SFgbVWqyKuolFF8PO+NLMxlFq4iuZ9NswlMxpss+KSefx/+YEsLH7gj4VuJ+1yCpIkmcPerjG884iuMpLQYGdY0Fv2jRxvBniQHug7dXb/yQ38fDP8NwKj9lSQBPNxdQjt78ISIQJvjFUyziGPIcPLbYs1D42jQD6zdvLEHN2LfACF54NoAhfq3U9dMY+jCbHXjoVE02kqzAQaaReKf/b3DuB+UkiaiT7p/L58EQoKBX4QayxkQUQT+upvFUsn6a7HU0XfT+5mIJKEo70Bh3rObMVT8i9uBsl6j0jhSVrJ6ncG/af8lqpwH1rAOF3Pkh6uDWKSV7BkAGK0T1ZWWJaW1eFTryt4499INEABLKNX7+RvZUAKP/37V+80wNSeEzqqty+1oX4es7SSM5cJ7c2p0UtU0H5SdxnJESE94KoTM5aQ2aAMOqj4nAW+oQI/pF1NsHkedgBd/0jeDbYQh01zONYRoXbFAQmF5hio=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On mobile devices, some user-space memory management components check
memory pressure and fragmentation status periodically or via PSI, and
take actions such as killing processes or performing memory compaction
based on this information.

Under high load scenarios, reading /proc/pagetypeinfo causes memory
management components or memory allocation/free paths to be blocked
for extended periods waiting for the zone lock, leading to the following
issues:
1. Long interrupt-disabled spinlocks - occasionally exceeding 10ms on Qcom
   8750 platforms, reducing system real-time performance
2. Memory management components being blocked for extended periods,
   preventing rapid acquisition of memory fragmentation information for
   critical memory management decisions and actions
3. Increased latency in memory allocation and free paths due to prolonged
   zone lock contention

Changes:
1. Add per-migratetype counts to the buddy allocator to track free page
   block counts for each migratetype and order
2. Optimize /proc/pagetypeinfo access by utilizing these per-migratetype
   counts instead of iterating through free lists under zone lock

Performance testing shows following improvements:
1. /proc/pagetypeinfo access latency reduced

    +-----------------------+----------+------------+
    |                       | no-patch | with-patch |
    +-----------------------+----------+------------+
    |    Just after boot    | 700.9 us |  268.6 us  |
    +-----------------------+----------+------------+
    | After building kernel |  28.7 ms |  269.8 us  |
    +-----------------------+----------+------------+

2. When /proc/pagetypeinfo is accessed concurrently, memory allocation and
   free performance degradation is reduced compared to the previous
   implementation

Test setup:
- Using config-pagealloc-micro
- Monitor set to proc-pagetypeinfo, update frequency set to 10ms
- PAGEALLOC_ORDER_MIN=4, PAGEALLOC_ORDER_MAX=4

Without patch test results:
                                         vanilla                vanilla
                                       no-monitor               monitor
Min       alloc-odr4-1        8539.00 (   0.00%)     8762.00 (  -2.61%)
Min       alloc-odr4-2        6501.00 (   0.00%)     6683.00 (  -2.80%)
Min       alloc-odr4-4        5537.00 (   0.00%)     5873.00 (  -6.07%)
Min       alloc-odr4-8        5030.00 (   0.00%)     5361.00 (  -6.58%)
Min       alloc-odr4-16       4782.00 (   0.00%)     5162.00 (  -7.95%)
Min       alloc-odr4-32       5838.00 (   0.00%)     6499.00 ( -11.32%)
Min       alloc-odr4-64       6565.00 (   0.00%)     7413.00 ( -12.92%)
Min       alloc-odr4-128      6896.00 (   0.00%)     7898.00 ( -14.53%)
Min       alloc-odr4-256      7303.00 (   0.00%)     8163.00 ( -11.78%)
Min       alloc-odr4-512     10179.00 (   0.00%)    11985.00 ( -17.74%)
Min       alloc-odr4-1024    11000.00 (   0.00%)    12165.00 ( -10.59%)
Min       free-odr4-1          820.00 (   0.00%)     1230.00 ( -50.00%)
Min       free-odr4-2          511.00 (   0.00%)      952.00 ( -86.30%)
Min       free-odr4-4          347.00 (   0.00%)      434.00 ( -25.07%)
Min       free-odr4-8          286.00 (   0.00%)      399.00 ( -39.51%)
Min       free-odr4-16         250.00 (   0.00%)      405.00 ( -62.00%)
Min       free-odr4-32         294.00 (   0.00%)      405.00 ( -37.76%)
Min       free-odr4-64         333.00 (   0.00%)      363.00 (  -9.01%)
Min       free-odr4-128        340.00 (   0.00%)      412.00 ( -21.18%)
Min       free-odr4-256        339.00 (   0.00%)      329.00 (   2.95%)
Min       free-odr4-512        361.00 (   0.00%)      409.00 ( -13.30%)
Min       free-odr4-1024       300.00 (   0.00%)      361.00 ( -20.33%)
Stddev    alloc-odr4-1           7.29 (   0.00%)       90.78 (-1146.00%)
Stddev    alloc-odr4-2           3.87 (   0.00%)       51.30 (-1225.75%)
Stddev    alloc-odr4-4           3.20 (   0.00%)       50.90 (-1491.24%)
Stddev    alloc-odr4-8           4.67 (   0.00%)       52.23 (-1019.35%)
Stddev    alloc-odr4-16          5.72 (   0.00%)       27.53 (-381.04%)
Stddev    alloc-odr4-32          6.25 (   0.00%)      641.23 (-10154.46%)
Stddev    alloc-odr4-64          2.06 (   0.00%)      386.99 (-18714.22%)
Stddev    alloc-odr4-128        14.36 (   0.00%)       52.39 (-264.77%)
Stddev    alloc-odr4-256        32.42 (   0.00%)      326.19 (-906.05%)
Stddev    alloc-odr4-512        65.58 (   0.00%)      184.49 (-181.31%)
Stddev    alloc-odr4-1024        8.88 (   0.00%)      153.01 (-1622.67%)
Stddev    free-odr4-1            2.29 (   0.00%)      152.27 (-6549.85%)
Stddev    free-odr4-2           10.99 (   0.00%)       73.10 (-564.89%)
Stddev    free-odr4-4            1.99 (   0.00%)       28.40 (-1324.45%)
Stddev    free-odr4-8            2.51 (   0.00%)       52.93 (-2007.64%)
Stddev    free-odr4-16           2.85 (   0.00%)       26.04 (-814.88%)
Stddev    free-odr4-32           4.04 (   0.00%)       27.05 (-569.79%)
Stddev    free-odr4-64           2.10 (   0.00%)       48.07 (-2185.66%)
Stddev    free-odr4-128          2.63 (   0.00%)       26.23 (-897.86%)
Stddev    free-odr4-256          6.29 (   0.00%)       37.04 (-488.71%)
Stddev    free-odr4-512          2.56 (   0.00%)       10.65 (-315.28%)
Stddev    free-odr4-1024         0.95 (   0.00%)        6.46 (-582.22%)
Max       alloc-odr4-1        8564.00 (   0.00%)     9099.00 (  -6.25%)
Max       alloc-odr4-2        6511.00 (   0.00%)     6844.00 (  -5.11%)
Max       alloc-odr4-4        5549.00 (   0.00%)     6038.00 (  -8.81%)
Max       alloc-odr4-8        5045.00 (   0.00%)     5551.00 ( -10.03%)
Max       alloc-odr4-16       4800.00 (   0.00%)     5257.00 (  -9.52%)
Max       alloc-odr4-32       5861.00 (   0.00%)     8115.00 ( -38.46%)
Max       alloc-odr4-64       6571.00 (   0.00%)     8292.00 ( -26.19%)
Max       alloc-odr4-128      6930.00 (   0.00%)     8081.00 ( -16.61%)
Max       alloc-odr4-256      7372.00 (   0.00%)     9150.00 ( -24.12%)
Max       alloc-odr4-512     10333.00 (   0.00%)    12636.00 ( -22.29%)
Max       alloc-odr4-1024    11035.00 (   0.00%)    12590.00 ( -14.09%)
Max       free-odr4-1          828.00 (   0.00%)     1724.00 (-108.21%)
Max       free-odr4-2          543.00 (   0.00%)     1192.00 (-119.52%)
Max       free-odr4-4          354.00 (   0.00%)      519.00 ( -46.61%)
Max       free-odr4-8          293.00 (   0.00%)      617.00 (-110.58%)
Max       free-odr4-16         260.00 (   0.00%)      483.00 ( -85.77%)
Max       free-odr4-32         308.00 (   0.00%)      488.00 ( -58.44%)
Max       free-odr4-64         341.00 (   0.00%)      505.00 ( -48.09%)
Max       free-odr4-128        346.00 (   0.00%)      497.00 ( -43.64%)
Max       free-odr4-256        353.00 (   0.00%)      463.00 ( -31.16%)
Max       free-odr4-512        367.00 (   0.00%)      442.00 ( -20.44%)
Max       free-odr4-1024       303.00 (   0.00%)      381.00 ( -25.74%)

With patch test results:
                                         patched                patched
                                      no-monitor                monitor
Min       alloc-odr4-1        8488.00 (   0.00%)     8514.00 (  -0.31%)
Min       alloc-odr4-2        6551.00 (   0.00%)     6527.00 (   0.37%)
Min       alloc-odr4-4        5536.00 (   0.00%)     5591.00 (  -0.99%)
Min       alloc-odr4-8        5008.00 (   0.00%)     5098.00 (  -1.80%)
Min       alloc-odr4-16       4760.00 (   0.00%)     4857.00 (  -2.04%)
Min       alloc-odr4-32       5827.00 (   0.00%)     5919.00 (  -1.58%)
Min       alloc-odr4-64       6561.00 (   0.00%)     6680.00 (  -1.81%)
Min       alloc-odr4-128      6898.00 (   0.00%)     7014.00 (  -1.68%)
Min       alloc-odr4-256      7311.00 (   0.00%)     7464.00 (  -2.09%)
Min       alloc-odr4-512     10181.00 (   0.00%)    10286.00 (  -1.03%)
Min       alloc-odr4-1024    11205.00 (   0.00%)    11725.00 (  -4.64%)
Min       free-odr4-1          789.00 (   0.00%)      867.00 (  -9.89%)
Min       free-odr4-2          490.00 (   0.00%)      526.00 (  -7.35%)
Min       free-odr4-4          350.00 (   0.00%)      360.00 (  -2.86%)
Min       free-odr4-8          272.00 (   0.00%)      287.00 (  -5.51%)
Min       free-odr4-16         247.00 (   0.00%)      254.00 (  -2.83%)
Min       free-odr4-32         298.00 (   0.00%)      304.00 (  -2.01%)
Min       free-odr4-64         334.00 (   0.00%)      325.00 (   2.69%)
Min       free-odr4-128        334.00 (   0.00%)      329.00 (   1.50%)
Min       free-odr4-256        336.00 (   0.00%)      336.00 (   0.00%)
Min       free-odr4-512        360.00 (   0.00%)      342.00 (   5.00%)
Min       free-odr4-1024       327.00 (   0.00%)      355.00 (  -8.56%)
Stddev    alloc-odr4-1           5.19 (   0.00%)       45.38 (-775.09%)
Stddev    alloc-odr4-2           6.99 (   0.00%)       37.63 (-437.98%)
Stddev    alloc-odr4-4           3.91 (   0.00%)       17.85 (-356.28%)
Stddev    alloc-odr4-8           5.15 (   0.00%)        9.34 ( -81.47%)
Stddev    alloc-odr4-16          3.83 (   0.00%)        5.34 ( -39.34%)
Stddev    alloc-odr4-32          1.96 (   0.00%)       10.28 (-425.09%)
Stddev    alloc-odr4-64          1.32 (   0.00%)      333.30 (-25141.39%)
Stddev    alloc-odr4-128         2.06 (   0.00%)        7.37 (-258.28%)
Stddev    alloc-odr4-256        15.56 (   0.00%)      113.48 (-629.25%)
Stddev    alloc-odr4-512        61.25 (   0.00%)      165.09 (-169.53%)
Stddev    alloc-odr4-1024       18.89 (   0.00%)        2.93 (  84.51%)
Stddev    free-odr4-1            4.45 (   0.00%)       40.12 (-800.98%)
Stddev    free-odr4-2            1.50 (   0.00%)       29.30 (-1850.31%)
Stddev    free-odr4-4            1.27 (   0.00%)       19.49 (-1439.40%)
Stddev    free-odr4-8            0.97 (   0.00%)        8.93 (-823.07%)
Stddev    free-odr4-16           8.38 (   0.00%)        4.51 (  46.21%)
Stddev    free-odr4-32           3.18 (   0.00%)        6.59 (-107.42%)
Stddev    free-odr4-64           2.40 (   0.00%)        3.09 ( -28.50%)
Stddev    free-odr4-128          1.55 (   0.00%)        2.53 ( -62.92%)
Stddev    free-odr4-256          0.41 (   0.00%)        2.80 (-585.57%)
Stddev    free-odr4-512          1.60 (   0.00%)        4.84 (-202.08%)
Stddev    free-odr4-1024         0.66 (   0.00%)        1.19 ( -80.68%)
Max       alloc-odr4-1        8505.00 (   0.00%)     8676.00 (  -2.01%)
Max       alloc-odr4-2        6572.00 (   0.00%)     6651.00 (  -1.20%)
Max       alloc-odr4-4        5552.00 (   0.00%)     5646.00 (  -1.69%)
Max       alloc-odr4-8        5024.00 (   0.00%)     5131.00 (  -2.13%)
Max       alloc-odr4-16       4774.00 (   0.00%)     4875.00 (  -2.12%)
Max       alloc-odr4-32       5834.00 (   0.00%)     5950.00 (  -1.99%)
Max       alloc-odr4-64       6565.00 (   0.00%)     7434.00 ( -13.24%)
Max       alloc-odr4-128      6907.00 (   0.00%)     7034.00 (  -1.84%)
Max       alloc-odr4-256      7347.00 (   0.00%)     7843.00 (  -6.75%)
Max       alloc-odr4-512     10315.00 (   0.00%)    10866.00 (  -5.34%)
Max       alloc-odr4-1024    11278.00 (   0.00%)    11733.00 (  -4.03%)
Max       free-odr4-1          803.00 (   0.00%)     1009.00 ( -25.65%)
Max       free-odr4-2          495.00 (   0.00%)      607.00 ( -22.63%)
Max       free-odr4-4          354.00 (   0.00%)      417.00 ( -17.80%)
Max       free-odr4-8          275.00 (   0.00%)      313.00 ( -13.82%)
Max       free-odr4-16         273.00 (   0.00%)      272.00 (   0.37%)
Max       free-odr4-32         309.00 (   0.00%)      324.00 (  -4.85%)
Max       free-odr4-64         340.00 (   0.00%)      335.00 (   1.47%)
Max       free-odr4-128        340.00 (   0.00%)      338.00 (   0.59%)
Max       free-odr4-256        338.00 (   0.00%)      346.00 (  -2.37%)
Max       free-odr4-512        364.00 (   0.00%)      359.00 (   1.37%)
Max       free-odr4-1024       329.00 (   0.00%)      359.00 (  -9.12%)

The main overhead is a slight increase in latency on the memory allocation
and free paths due to additional per-migratetype counting, with
theoretically minimal impact on overall performance.

This patch series is based on v6.18-rc7

Hongru Zhang (3):
  mm/page_alloc: add per-migratetype counts to buddy allocator
  mm/vmstat: get fragmentation statistics from per-migragetype count
  mm: optimize free_area_empty() check using per-migratetype counts

 include/linux/mmzone.h |  1 +
 mm/internal.h          |  2 +-
 mm/mm_init.c           |  1 +
 mm/page_alloc.c        |  9 ++++++++-
 mm/vmstat.c            | 30 +++++++-----------------------
 5 files changed, 18 insertions(+), 25 deletions(-)

-- 
2.43.0


