Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2055DCCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 01:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD2D48E0156; Sat, 25 Oct 2025 21:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAA698E0150; Sat, 25 Oct 2025 21:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC0BF8E0156; Sat, 25 Oct 2025 21:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A5B9D8E0150
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 21:05:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 304E457270
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 01:05:25 +0000 (UTC)
X-FDA: 84038472210.22.44100A8
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8F4E440003
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 01:05:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DMN1HsNl;
	spf=pass (imf12.hostedemail.com: domain of jinji.z.zhong@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=jinji.z.zhong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761440723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yS34+uhylNdFYNWrvgsPGh1bBy7nTRn8Y42YGAOkzr0=;
	b=gsXv+Io6CctWL0FrYazarKkGNaQPfLUURflBVEBquTcai/OCicIr9G2tTixjdcjsSHZYrx
	cJlhjxnt6BT373m3mnqjiNsJCSaxiIHm+LTqOuhmXaGwaqBb8q+bIERO0vPbXyJx7/9d9+
	1sVkHPxAk1H79Jq43+tGZaIHg/kDdis=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DMN1HsNl;
	spf=pass (imf12.hostedemail.com: domain of jinji.z.zhong@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=jinji.z.zhong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761440723; a=rsa-sha256;
	cv=none;
	b=4vrdIPAVEsZug8+kUOG5FkVxXobrntbMj4U/6rp4zvZKwPiGvneb0nfDgY4lB5tbyt7/hl
	EUIjSYKvKMZag7WU4+zH4KCv9S+cOvncqnaD4TLPVSjWfUiwAfkkm0xzvPQxz9qcjR4Fcc
	7SfZt3ACFLlGjfgFxfGg95VQSycc+oc=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7a2852819a8so1909783b3a.3
        for <linux-mm@kvack.org>; Sat, 25 Oct 2025 18:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761440722; x=1762045522; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yS34+uhylNdFYNWrvgsPGh1bBy7nTRn8Y42YGAOkzr0=;
        b=DMN1HsNlxGjnCzBV1bjSdlJSVFFGY4C7bNxl4iRY39VYygea0hax/YgIQ3JsSvBq+7
         Qkr7KW5Ewl9X5W2wVJQZ2QEW/OQbaxfUaqofzBarQJNUdj/zRmriNMfGWtLaj1Jp83Sw
         5MOgr1PItrkCmda6lYUvLIXn1PvE4aZadjoylpDXzCtLJjShkP5B/h7XmVm/jGcTzQ7m
         HnbUMgi4Z3XcPEBHDFHD3DHR7HBo70Cic/joPWM4v4HOWT6L+UiTgI6ta2xIyowQeHHf
         EwCBdVETxXr84E3lmAwxy01+QcXqUkJZiJm2ltP9yKmuLaKRNa4VZXPs4B3fvWuXM8Z4
         fyug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761440722; x=1762045522;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yS34+uhylNdFYNWrvgsPGh1bBy7nTRn8Y42YGAOkzr0=;
        b=vWtBfO0SkoxOWfr0mHnB9gmH0a0vMLoh4aFbhDceS9FVe3EehDzXW0L3rTpZT7hN9E
         BlPEs0CWAlY1XQu+FIJ12PRcTVwNwoI8boDDdEzUD8qKL99DEd3IaPSNoKYPVSvqr83Q
         W9k9hGrYaLg1IC0/vjoE9+Y9u2gSPLNqPZCcRuXVQDJKgOaG9eJj/5aXKH+34JL+X5o0
         5X5Yzj+Tk1xQZzLqrUvGEDinLK1fCbYe8dRpcBOpESy0fr4XsSdrKTaq07zcMshoYljS
         Hh9xMxayU+Th47ya6IEF/EtBC6nPP7J7owkkTSCieazxTFiGIh9NHQYcic+mW7QN1hjo
         1lDw==
X-Forwarded-Encrypted: i=1; AJvYcCUaPxjYibDGAus77uXz2kYHpBfGqo7ykGKFOlUFAPZqj4BduQQWmreb0Hx86eVd5HSAozi55CxL1Q==@kvack.org
X-Gm-Message-State: AOJu0YxziH2sMPt9M66yb/1K3svvXjY1vt8yQBOFI9PPrlyci1BHvKOM
	V2lcAl153sEqiNo2KEzWbqSSYlrM/1BF7EkwpNF6NXCNY0eSlhlqD/8c
X-Gm-Gg: ASbGncvWqR3BDn3uieDV8z+FTqfMu6Cs+xcs6LJhNzIfECge2dJi4PWCmSkdg4FDC5B
	L3w9nIUQIjvTrJOLawaUoD5ae2E5phn/Qtd18uwlWCaT9zxXRT7JtNowjeK5GEJqjd6O4Rh3X0+
	Owil7wXqfqFOdAr0G3ByRYGGw4iuw9FfO6LS/wsJgbAwCFhBG6JeKLxtb9McKJDDC9Kr1nMsaWa
	PVu6LAe5HqwED+Q+MrKCdUf2alote3uXJ3d7popU9jWuF1l6HwV0vkZW6gT1IQccKs/mbppG5L1
	Ze3el0ZNCBUVY5bUoRqKY4PpDAevnKwP3P2giD6CtqIs/2fHUxzwVMPaRMQG+9OGMJ3lxhSG0wU
	qFLIL9wbt+b9QVzZMNUOUZgunQzOA5uZynfHYS1XuPIC2lzzZTUKlrbYEmQdmyxRZjPGo3ysaEQ
	d21XS98P9PfOsyzg==
X-Google-Smtp-Source: AGHT+IGqJ3fK980blF3S2OhDDl1kPCFC3PDx3uiV6lRR9MlLGgQ+c3xMg89feF4XpI76Z2y7cP/wYQ==
X-Received: by 2002:a05:6a00:23c2:b0:780:f758:4133 with SMTP id d2e1a72fcca58-7a274ba91d9mr12147230b3a.10.1761440722260;
        Sat, 25 Oct 2025 18:05:22 -0700 (PDT)
Received: from daniel.. ([221.218.137.209])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a41404987esm3371597b3a.36.2025.10.25.18.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Oct 2025 18:05:21 -0700 (PDT)
From: jinji zhong <jinji.z.zhong@gmail.com>
To: minchan@kernel.org,
	senozhatsky@chromium.org,
	philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com,
	corbet@lwn.net,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	axboe@kernel.dk,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	akpm@linux-foundation.org,
	terrelln@fb.com,
	dsterba@suse.com
Cc: muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	drbd-dev@lists.linbit.com,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	zhongjinji@honor.com,
	liulu.liu@honor.com,
	feng.han@honor.com,
	jinji zhong <jinji.z.zhong@gmail.com>
Subject: [RFC PATCH 0/3] Introduce per-cgroup compression priority
Date: Sun, 26 Oct 2025 01:05:07 +0000
Message-ID: <cover.1761439133.git.jinji.z.zhong@gmail.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jhyashw6jajzgakhqwqzdkufuedzom88
X-Rspamd-Queue-Id: 8F4E440003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761440723-399126
X-HE-Meta: U2FsdGVkX19Iv7fRhk4KeF3wGQKMtQVVs+tyqzL1IDf3ndB2K1w2VZHR6sqHKcI2wP4YEwRNktf3KEq/bApJqdoSEs6fsR5R2cdk1yotRhTD/oJILMPINhoVKA4IMhbeFC98I+B6BNDFSDsZGId5bhLbJ3SY3qS8jPjoZPp/0/meYV9lJyDWqL0iBJVnacibDtTnFLXZJ2x7pN4Cni4q/vq0hyjS7rZLaQXTidjkUwwXmxiyqWaeCuD6L+E/cwKd5c9EzU3lO9dtOixnv64EmfGc8ACqOIpVD1CeXPQuIjmtFfGE9h1dgry2HjQTcWcN5a8OsvCDITIu2eHxK4jwjaH2TM0rEctKusYHp0lXTAFgoaGBAjBXaYCyH0ntt4r46zZ4g5L4qSHlErrYuKnL9MzQ+0sD9e8ZuhgpNRRRVOenarZ1O0EmWx1wRrn4BESucw9wgmoRREQGK5HbnKcHZHBB+BzrMWqDmtSC7TC04g373ChVrb4Z88GwNiFOtXfJZem3fuKqClCl8uYB6WnQdDn12L/IXfGvZG88gXfOcARxPoKsOYLcpF9Zxtr9TqXV1FMpB9dI2XNjPl9TrdL+qa1y0KbyXPW9iw4Eur9q8eZxfB6wNj9eqTiTeDPsDhOKdxP5CQRltfHmVPHwFS0gK1lQuLHyxphQy4Hm1ouR2Vf3Fm+gls/Srslr5PlQRROrgRd1H6ywwXyuQClnwMx1hdpFFzUx8g2mdplpvr8qwMJrFtrpbgdt6yjOgIxmlgJ9fIiUrHXSffjajQ8EHfpwlOgh60iHYX1VzibAX0Cn5XVePHj8QILAQpeOl8egT6XgZXGloEL1yC74vyme8QqFkufkmfNh1baO4KONDLo9L0UvByuRS2GVO7/VCyaacsatRQEJLGf3p/bfZjjHPsk2Sf5ycEph6lY19/3/8W1H+3EtZ9H4yjSe+VwxiuscKJTKT2mIZDzYXsXbQeRAyi6
 x4JTDsNM
 VVfIa4YiCr8t8S8sAy95/OwuVsErrmnC07UMQ8DjeKzyYU9JJUoQQhtVYelb+HPQs/Z7A5B6rM4KWQlwZb1t6U+3tJLNLUhnDZNMGrQE53zuvmXem/RPRZGKNX4EHxgcYKLkYOOo2V0jBr4E4FrCd37/j0gdfszEI28CH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello everyone,

On Android, different applications have varying tolerance for
decompression latency. Applications with higher tolerance for
decompression latency are better suited for algorithms like ZSTD,
which provides high compression ratio but slower decompression
speed. Conversely, applications with lower tolerance for
decompression latency can use algorithms like LZ4 or LZO that
offer faster decompression but lower compression ratios. For example,
lightweight applications (with few anonymous pages) or applications
without foreground UI typically have higher tolerance for decompression
latency.

Similarly, in memory allocation slow paths or under high CPU
pressure, using algorithms with faster compression speeds might
be more appropriate.

This patch introduces a per-cgroup compression priority mechanism,
where different compression priorities map to different algorithms.
This allows administrators to select appropriate compression
algorithms on a per-cgroup basis.

Currently, this patch is experimental and we would greatly
appreciate community feedback. I'm uncertain whether obtaining
compression priority via get_cgroup_comp_priority in zram is the
best approach. While this implementation is convenient, it seems
somewhat unusual. Perhaps the next step should be to pass
compression priority through page->private.

jinji zhong (3):
  mm/memcontrol: Introduce per-cgroup compression priority
  zram: Zram supports per-cgroup compression priority
  Doc: Update documentation for per-cgroup compression priority

 Documentation/admin-guide/blockdev/zram.rst | 18 +++--
 Documentation/admin-guide/cgroup-v2.rst     |  7 ++
 drivers/block/zram/zram_drv.c               | 74 ++++++++++++++++++---
 drivers/block/zram/zram_drv.h               |  2 +
 include/linux/memcontrol.h                  | 19 ++++++
 mm/memcontrol.c                             | 31 +++++++++
 6 files changed, 139 insertions(+), 12 deletions(-)

-- 
2.48.1


