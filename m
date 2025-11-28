Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03E81CFD2F6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 03:12:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 478706B0024; Thu, 27 Nov 2025 22:12:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 428876B0026; Thu, 27 Nov 2025 22:12:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F0336B0027; Thu, 27 Nov 2025 22:12:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17B2D6B0024
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 22:12:39 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D8BC7B80C9
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:12:38 +0000 (UTC)
X-FDA: 84158543196.09.961FC02
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	by imf07.hostedemail.com (Postfix) with ESMTP id DFF964000F
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:12:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b8PjHWjL;
	spf=pass (imf07.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764299557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9VXBJ60a07RGP4hbMBT/KJ4u6vYKF5t5iuO5lexYnI=;
	b=Pn0s1on9sac8M/9U03ISzYjh2k36w/w4sK893KrxwYPV9DRqO+exOlZY3yxqJJQXAIOs6h
	eIdwl7GV7diRBaENHZ+E4gMmGrj9ssTqenOyO/qj9opxJvWWTFJlLqtvYurH5ab2vyDe0B
	hFm/J3vaCqM8nWbRyRGeFjUZHnUqRiM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764299557; a=rsa-sha256;
	cv=none;
	b=B+oe4Fvd2ZAd+7xYFngSXIoUG8+ZDoAYzAX+iqdRxLgYclnNdpaUeEKUIvqkXi4TWFVKij
	O8bP7ZGsPTBkc0WA+547p7E7U+r7Lc5Sae7fbSDZFml75KVxaz8EvE++BPzypZl+54LtPE
	zyziv/t37jyn5H0DRyzeAmDJ1qoJMgw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b8PjHWjL;
	spf=pass (imf07.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-2984dfae043so11955205ad.0
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764299556; x=1764904356; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S9VXBJ60a07RGP4hbMBT/KJ4u6vYKF5t5iuO5lexYnI=;
        b=b8PjHWjLR9HRxeQkDoMbMvASTT5VY8vUVucE+C82QWjidoo9MI9YOgil6AcS3rKW8N
         ch2ttH2A5CXWMwZa6cEM7f58kDmUQZEu0PqUPtRm9aPSrWZznT0c0GCdfMr5KHjo77BN
         AeN3/27QNMMQHupZ/Pc7+aCxEd7ykX5S4yONdbz2r97isPFWG8ld5v1xSqnffil3vU/V
         3FfhRRjl/sOXNpmrV533iGBbgYb8V1rB0glf32/jy0T6Rlc/sEjCPuSc2Ri5bpXH7A7J
         r9jIE7Y8vJhosvnsZ2HMEk0ciKTdSkDx63huIN65l/u5YoeeFgrgonwPH6dCG1BwfLkk
         wvUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764299556; x=1764904356;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S9VXBJ60a07RGP4hbMBT/KJ4u6vYKF5t5iuO5lexYnI=;
        b=hWvtEeYHLatDtgX7sI0kOIQX/Hf8rwzOUlSxlf0ZNl9YcI6VhzkdPyBfvhDmxNr526
         BdqfkaP8a8QtxhYxZ63hohaYfUSAweLTYKWVzFyAhJOhY+pC/r/r+B/wC22NSulRgYZz
         hg2k86ydUC2qSpNX3fdJoGCKzQZhfhWQMJeOB1BzC3QMECxjvAvlrX4qDF7A57AtquEl
         BEY99g15E3Mqv/elpyw/se7tau1jmfdxf9Ho928XkLlSfBcUmNms0b/OURmFpRq/Hg5q
         w54ei/xSGUYIxEwKqkf2rqNSYXzXzpbVcsNH+2HHYq/buAt0UkRcKo/J9WnP4yEOfiDX
         g26g==
X-Gm-Message-State: AOJu0Yy2vayBWSmCLZEN6PgbBPXTnbOQSdxL6QygdLR4q2FGeHtt/0Nh
	hN45mQ8ab8ndHiBfE3Or8I4QDsz8Zv7SRspS8ddimapOGvaDG+rOcblG
X-Gm-Gg: ASbGncumsokbhZElrVrEm9KyyAGccJFN3XUcERRqFBeh9iePsSuiygRPAkniLDWavJ1
	7FiYS0CROhlkwwGTFjOxng7fA5VNWdksveYL6lwdoEVbqTVoOlJ+h1PWyFuNc9lZh3IVdjNOtyI
	kMp7HGjUM6ki7afVcrF8nR6cKC7wevl9CP0lH+pYfmyoU4zgwK31W6d5uzOfzOYKhlmHMhSq2sE
	hLYd5f/XYdsSa+25BXErO3g/7dwiHR3uX7RVvptLj82TeCwAHm3RfVtzn/zPrLG15tHxymmPO0a
	EvWiAwHD8wS60RolOckZffXHf+QD+8f7v6NdtP2USHCchgNahRuHwe4T2hWbb+18nCMQFN/Sto2
	aStGl4GqxAVvqxsCidi6CEpOsT1uuMXSAiAIv7Zz22RvTojRVk3xKv1nq1vEC57Ft/dzxU+5ti7
	bgdczKvrIeb5RIjaaO5eP/IkRfWmaZ02zXHVlPqzVnvqM4RCSo
X-Google-Smtp-Source: AGHT+IE1lwR9Ofq4Qqg5eKpVX0cSDeD8qkn4ka7DL91z29m60LfJEWybbHRIS4gz9OtjqCITSYWmuQ==
X-Received: by 2002:a17:902:ce01:b0:295:557e:746a with SMTP id d9443c01a7336-29b6c3e375emr257843275ad.13.1764299555542;
        Thu, 27 Nov 2025 19:12:35 -0800 (PST)
Received: from zhr-ThinkStation-K.mioffice.cn ([2408:8607:1b00:8:3638:7863:b439:f5a7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bceb275a3sm29674945ad.66.2025.11.27.19.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 19:12:35 -0800 (PST)
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
Subject: [PATCH 2/3] mm/vmstat: get fragmentation statistics from per-migragetype count
Date: Fri, 28 Nov 2025 11:12:10 +0800
Message-ID: <780ded63aca04eb513d6e7e2c8862e6972b84b45.1764297987.git.zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764297987.git.zhanghongru@xiaomi.com>
References: <cover.1764297987.git.zhanghongru@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DFF964000F
X-Stat-Signature: y5j9mwtcbz5dkgnda45no3en7hn5559x
X-Rspam-User: 
X-HE-Tag: 1764299556-239455
X-HE-Meta: U2FsdGVkX1+7vYXHTIbxaQf0IznSd0YTsI1SsUtQrk4cNNqdhjfG5HmLCCAzxMroX8JDg0bhTvm4f5rdcL//h1H4zI7g1RpFOypIJQMxh9RNmLJl6/9k4ItAL83BRYRT/gqu4jhvvKCDgjxzRnf2lIc4/7xaamegIw794nJhHT2GOJAe+Pir5nGcso1jRO+fChVkAxOjH65nUui3FROHpLm7sQims/9Fzt/AtUs+0T4dw5OgZbl6RC5CzSU9DDsoKy8L672XKF+cqbFamP8iFr1htDW+HCwEVo+ElpwdA+6kJ/t6OfjWW1UUCE1KsqA3kCuQZRwfLceOLDYyzokQGSVLw+3dUHTmAurfnzEPXQD7vMmt73Z7yHSV72bV98bWrYzb78FUXQzSBg8YE/mKF9VINPP/+p8blrJ7lyYY99pmFXwEByyuZYAanIDLu5XWmWNxVgTj4QfVryQMSKEz7kcPtqlzPwF2hElyungayszFrEEGiM6f9eSLXQBwpFPdG2dMV8XMsDbZvfSb2rtBABtcMn1mHWPrOBGtwhJnFPEGbjDv19CTph5gkHiRCE2iicsdTNrpqwmzkqtTKgqv4QOWpg0Fg9KZAPoljtdhh1GWw4h6bxwkETGJslPUYPWpJP+u907AFZRFWjp+aI+77kz25kVnyoSW4GndDnABetj5k6Ner+QgnxF2ClYUAjTuLKNGH5kAA1tU1tqksM/E0X9bovgVItad/ExJvYF6uUv0MNwf53DCQ/INF0Sq2m8Z/pKrujIwF35nBen95b88Xrg2u53CTgsAXE4XlevpFQCG5ERfYqVqnU+3n6nXXPUVzdDqgZwXDBKJ2MpoH9BkJBWxJpg+69wCSyqhagCZiy9Wk/nFdTLTh5gne5sSQjcDrQRR2lrZ6ntem387BEfEqbOYkAOLTJzsMBCkcs3okyptCFWbJAkIvaK+82S93lZ+dyZaQ4W6kcEwpaitUIi
 5xfTxkDO
 U3TwZ4htk/9MuEvCBycvfiKdAZ6cKH/lCpat1VTpHgwhRv/dAExWxsDZS6V9h3EHwBmyuDO3PvqmkU0g3YD1FPueu1NgHgiPtNlwANUQ7emvLvNQ/AfC/1xXtFD3juXLc/Mw4T20Dom+YDf6ezqFY5DhjVOlHl7YREaDftCwISamoFdm6B/E1iX3ChGOIxSE4ZqniEt+EmpSgy7gksEUOq245nLefmnTPGL/Teb+YJmmPl/KwFSwQnJozVKabs9tiCEqeycBIMXphqCDFzPTZuuagWknY61dS8A5Umhkt22ty5p++3OlLoKrGqLVWEuv8pKV4E4jG17eUCux+p3lTtwxS3RVjNgyJxY/EL551hQZSPXqVcaRDIP8/xEODzXKEFuL6FZFXcm8fUNpEipu143QxJCfuni+TTLd6RsZE3BsNFN4MkQHtC4NAIBx9uUxmRevgI0uwLA9r1rlhutgukdfV3F61IZ7tz3UDwkcbuS0AyKg6oDujBF4mjCA275sdxQIp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongru Zhang <zhanghongru@xiaomi.com>

This patch optimizes /proc/pagetypeinfo access by utilizing the
per-migratetype free page block counts already maintained by the buddy
allocator, instead of iterating through free lists under zone lock.

Accuracy. Both implementations have accuracy limitations. The previous
implementation required acquiring and releasing the zone lock for counting
each order and migratetype, making it potentially inaccurate. Under high
memory pressure, accuracy would further degrade due to zone lock
contention or fragmentation. The new implementation collects data within a
short time window, which helps maintain relatively small errors, and is
unaffected by memory pressure. Furthermore, user-space memory management
components inherently experience decision latency - by the time they
process the collected data and execute actions, the memory state has
already changed. This means that even perfectly accurate data at
collection time becomes stale by decision time. Considering these factors,
the accuracy trade-off introduced by the new implementation should be
acceptable for practical use cases, offering a balance between performance
and accuracy requirements.

Performance benefits:

System setup:
- 12th Gen Intel(R) Core(TM) i7-12700
- 1 NUMA node, 16G memory in total
- Turbo disabled
- cpufreq governor set to performance

1. Average latency over 10,000 /proc/pagetypeinfo accesses
+-----------------------+----------+------------+
|                       | no-patch | with-patch |
+-----------------------+----------+------------+
|    Just after boot    | 700.9 us |  268.6 us  |
+-----------------------+----------+------------+
| After building kernel |  28.7 ms |  269.8 us  |
+-----------------------+----------+------------+

2. Page alloc/free latency with concurrent /proc/pagetypeinfo access
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

Signed-off-by: Hongru Zhang <zhanghongru@xiaomi.com>
---
 mm/page_alloc.c | 10 ++++++----
 mm/vmstat.c     | 30 +++++++-----------------------
 2 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9431073e7255..a90f2bf735f6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -818,7 +818,8 @@ static inline void __add_to_free_list(struct page *page, struct zone *zone,
 	else
 		list_add(&page->buddy_list, &area->free_list[migratetype]);
 	area->nr_free++;
-	area->mt_nr_free[migratetype]++;
+	WRITE_ONCE(area->mt_nr_free[migratetype],
+		area->mt_nr_free[migratetype] + 1);
 
 	if (order >= pageblock_order && !is_migrate_isolate(migratetype))
 		__mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, nr_pages);
@@ -841,8 +842,8 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
 		     get_pageblock_migratetype(page), old_mt, nr_pages);
 
 	list_move_tail(&page->buddy_list, &area->free_list[new_mt]);
-	area->mt_nr_free[old_mt]--;
-	area->mt_nr_free[new_mt]++;
+	WRITE_ONCE(area->mt_nr_free[old_mt], area->mt_nr_free[old_mt] - 1);
+	WRITE_ONCE(area->mt_nr_free[new_mt], area->mt_nr_free[new_mt] + 1);
 
 	account_freepages(zone, -nr_pages, old_mt);
 	account_freepages(zone, nr_pages, new_mt);
@@ -873,7 +874,8 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
 	__ClearPageBuddy(page);
 	set_page_private(page, 0);
 	area->nr_free--;
-	area->mt_nr_free[migratetype]--;
+	WRITE_ONCE(area->mt_nr_free[migratetype],
+		area->mt_nr_free[migratetype] - 1);
 
 	if (order >= pageblock_order && !is_migrate_isolate(migratetype))
 		__mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, -nr_pages);
diff --git a/mm/vmstat.c b/mm/vmstat.c
index bb09c032eecf..9334bbbe1e16 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1590,32 +1590,16 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
 					zone->name,
 					migratetype_names[mtype]);
 		for (order = 0; order < NR_PAGE_ORDERS; ++order) {
-			unsigned long freecount = 0;
-			struct free_area *area;
-			struct list_head *curr;
+			unsigned long freecount;
 			bool overflow = false;
 
-			area = &(zone->free_area[order]);
-
-			list_for_each(curr, &area->free_list[mtype]) {
-				/*
-				 * Cap the free_list iteration because it might
-				 * be really large and we are under a spinlock
-				 * so a long time spent here could trigger a
-				 * hard lockup detector. Anyway this is a
-				 * debugging tool so knowing there is a handful
-				 * of pages of this order should be more than
-				 * sufficient.
-				 */
-				if (++freecount >= 100000) {
-					overflow = true;
-					break;
-				}
+			/* Keep the same output format for user-space tools compatibility */
+			freecount = READ_ONCE(zone->free_area[order].mt_nr_free[mtype]);
+			if (freecount >= 100000) {
+				overflow = true;
+				freecount = 100000;
 			}
 			seq_printf(m, "%s%6lu ", overflow ? ">" : "", freecount);
-			spin_unlock_irq(&zone->lock);
-			cond_resched();
-			spin_lock_irq(&zone->lock);
 		}
 		seq_putc(m, '\n');
 	}
@@ -1633,7 +1617,7 @@ static void pagetypeinfo_showfree(struct seq_file *m, void *arg)
 		seq_printf(m, "%6d ", order);
 	seq_putc(m, '\n');
 
-	walk_zones_in_node(m, pgdat, true, false, pagetypeinfo_showfree_print);
+	walk_zones_in_node(m, pgdat, true, true, pagetypeinfo_showfree_print);
 }
 
 static void pagetypeinfo_showblockcount_print(struct seq_file *m,
-- 
2.43.0


