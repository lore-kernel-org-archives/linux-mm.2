Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8884C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 23:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A7F26B007B; Fri,  1 Aug 2025 19:00:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 458AE6B0089; Fri,  1 Aug 2025 19:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 347AA6B008A; Fri,  1 Aug 2025 19:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 21A176B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:00:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9134F80597
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:00:14 +0000 (UTC)
X-FDA: 83729708748.07.25A8D6B
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 729C0180011
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:00:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mggsSb1T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754089212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zMNMwlGsmPkFnaHU0PDDeLlWFlLk9FifMJ8SvVP4vxY=;
	b=RZ5fajBq4HxkRSJAtxmEoK4mIVPUCaCwXSm3AWfaO7K8ghd2cynI5G3rW4mIg24fUcemXG
	Nk2CV4Rbi6Z2p1w//dyRuWNTGEcV1+qKoHqMZ8+/K0XiMpHYQAFlBhM63tOdTyc+/ynwzb
	pGuvCdg/XeUQzM7tSQ5hhK/eNoLikRM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754089212; a=rsa-sha256;
	cv=none;
	b=hevevYiG5zoDELU/rlLvOFwg+JJpuoeMKr5tcEOQyB+uJtyCXtxjUZLbXQm9ZasXmHJu2O
	dE46Xv1Ps8F+MqkuVu/o2rAvBa6gkEY+ZEPnHgjirlRYmG3/ZrGyJBArPePxr0/nV2FiTo
	oNx9vBB/65Q71B/3SFBAGWpnolsfXXI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mggsSb1T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-61592ff5df8so2791759a12.1
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 16:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754089211; x=1754694011; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zMNMwlGsmPkFnaHU0PDDeLlWFlLk9FifMJ8SvVP4vxY=;
        b=mggsSb1TC2/cQFfS5cOfrNq491PPXBzivqeNd3kn5JLw1T2mPhXhCnAgNmHqBajyEP
         ynMxnUj8Bz9iSKuRge2GuDn3uCvx8sWhghx1/QUAgqliUq5WEVk1ZFFxQevlxQyLZMMx
         dSymwze6FqbNftyEdxiKG8pZJ9uPGfggfTquPDbFFsFUXG0LC5Yk6dRobdmD+gEVdRXH
         J1LpEK1E+ljne54xleAlU/YPFwsFwPU1F1p+M+UV2iXL8pI6NrgTSYDB1lg2G4ciMQ/0
         k1nJ2+x76YyGjsXqBNXp18KuozeQJOoIv4cyT3OjYKvQQj+XzgU2FG1OZqqRkkHuQQRH
         Ta2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754089211; x=1754694011;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zMNMwlGsmPkFnaHU0PDDeLlWFlLk9FifMJ8SvVP4vxY=;
        b=cdRZRaAFkxvfyqgbb4uU5DgE35Nsc81Y9GOI+K00d57xQU11daDAaJdXagUtycRhsQ
         XDTQyQYzPA1OSVuEuhjyLtFdTbjfFX8tgNGkmtJ9ZRa1t7yRQJyCERH2YuysGy0rRh8W
         VhHxUJQn/aTh3bVyn6OWCv6NT+ye12N2RtvQ0gwd/+3YvnJGviE0kQlOoh19I95QADeC
         qJtIj1gcmMXIjnp19th6uv7LqhxUXZUu3TSX1/pn3tAA/WYGRsblpNw8MxUB9Pxj9Vf0
         QI0qneWY9K8Q7Ps1AinGFPc2qztlU3USpf5vbZIwTq/oI4CheZNKVeeEwMmYewkoQVxb
         DYvQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1cqofcsGTrTNtM3c7N0Dgyu2/uyoNkNo9uvhVllY7bg7kGJhT59GzRSiSweVcNaiR3+bxtzGffQ==@kvack.org
X-Gm-Message-State: AOJu0YxVnum8Tb9I4l09tpn/5bsfBuXYxxnMOO/YOS/bjVCfujsHsfM1
	hS8y+z4XS+bZObMPrfxMpz4vS28xXt58ULMqlDCnNrSaFw3ctHP4bQqK
X-Gm-Gg: ASbGnctMz04PEM7pbU5iseGxULhUFxh4SiZX82DUwCxTh7PVwmU4danF9BlIiHgLnl9
	lGFADKRNYxXbF443VFewg2wEIBqy7yBxRAZrARoMwMRcxPFSmxlz4+KR3zNvy91P1vqsTxMGzK1
	+sERUaCEuCCC2y8a96nnhNZl7TM4ud3MzECukJghy6u+4mjCYHlYiq+hSiLYB6AEfXgwJnNHPMz
	6NN9lR2ChN1MYp8yqESuVw8rhP8lOeOkq+52cvTd7QV051StaVYV4YtFaR5mWY3CMWyzL27nwuI
	Wr5Agc1sFzvF0V0D1JQ70r2ga8sNwfrWvA7JhpEUYeL9/5xtbMSThX+Vcavhu8O7t02h9+Y2hKH
	o6KT42RgUn+TJ93RFvfZ/mBVUgOM2bxkZo1tsTDp74AC0ao9DAwMt50iaV4xAdxNfi+7PreU=
X-Google-Smtp-Source: AGHT+IFnVRnrsg9ncutTril6bhBhLAh+iORwQnRdsoguSnMGnXS3nrWaw/8zgfS5xc+Ciny5pIJY1w==
X-Received: by 2002:a05:6402:2688:b0:612:b150:75f3 with SMTP id 4fb4d7f45d1cf-615e6ed2172mr1068482a12.8.1754089210430;
        Fri, 01 Aug 2025 16:00:10 -0700 (PDT)
Received: from rs3labsrv8.iccluster.epfl.ch (nat-icclus-192-26-29-9.epfl.ch. [192.26.29.9])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8ffa17csm3279290a12.49.2025.08.01.16.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 16:00:09 -0700 (PDT)
From: pyyjason@gmail.com
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Yueyang Pan <pyyjason@gmail.com>
Subject: [PATCH v3 0/2] mm/damon: Add damos_stat support for vaddr
Date: Fri,  1 Aug 2025 22:59:49 +0000
Message-ID: <cover.1754088635.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yqz8zey8i3qff64ypdxcot5sc9fj594y
X-Rspamd-Queue-Id: 729C0180011
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754089212-312547
X-HE-Meta: U2FsdGVkX1+igDi/BTPOxHkRH0XugifHkKPM9AB9A/xMjdaY1bCqyuGmLohJGNmWYDAsQKVQ7+Nb5/uC8MJtF7Spa3bsRu3664LpYaRQqQKOR2fSPOEm9ea9jgfkc3Ep9LftCKk5r6d2C2EliBrgLzs4ulnWCC3RT7isnLPAbzDXyfPWy0bWa4p4wyiABQhxiFOXh4BgldJpDwm2eZB/93Lr+zxJlaT0LT5otbX3mTAg0n/s+2iOphlylbolQQWYWgP/ExMBvJAleAFeELs3aSjzhMJOTGUDtu3hyRPSckRZDqiv2PQDgwB8zwIjiAtao/Fys/0wRhZDhKbbnU0NdHqEv4a9A64+hyymjhhn+UMWKol8ml41St9az1N8wmaJSLDZj6kuttbqIxxqFbTjMaKgaQUcy/LR6KBzKR2xGBAfLJmfjYgqzJiHTmQZ11HwboTatS7xlts06AJNG+cGVwJSHZabPHSj+/mbd5qM8VOIuk2SZVxQC+yZJjFptcc2okC7YmX0auT5bTK0jzROSk6W6nJVlcfaRLwJj3hTb4Z1HngR6GEK4LrmRK202loYjRsApXiYLA2XP4BTE+eYNVX7S+v3FkmQvhGBmuGi+4MwRj0pzPtpdCAwIOw/h6iRlvpIyKRo1HIRXfF5+OwNFekFPLQlD3egg7gKUet4CstbSe31Lf5+xzQv+j87v8v8q/FBYAAh4BN9ZR2xpXbRC++CavwbTmZDBsMEUEK2LePMFEtxqVTeQcxvttmGnmRNvxSLSs+RoRVsVdi4UWSD9AaFWHjC6CgM0yDQtAErZTQN6hObT7ezUiPQ0agWBe6zGxp0UDippVFx01kj8PZy3Fk6cCaNsihV3T48hNW6IhWGMXbV/XApmmSE3OPTqQgEjYti2eJwYaBoR8NlAwM7V8NwuFKKC2EpVNXAV37vbvgPyz8YL8rBdPARrYeZHZGS9TZL3MoqiwQNZztzCp0
 7aUWmZQo
 aiCatEp6HqqLFWXjKhbzBYz37BV3LBe1LYEQcpu0Rc4jxLqv1Grmx/33u4SSHvQp+1gEgYiZYbYaba4D8zCHJYDdAWwke8ahit3H271FrDe5urHjNBb4mKWOIyHXVBBWpVY2SpZ81So5G8vmfp21K8YYdOGbvC6rdAoykq4+Nj1C0sfzE1QMeC0ZQJJpwIjHI+WStMGXb2K56tW4AAyIJBVqLHgolRD7YAG/ypnd7NgzsbiHAEoZ5zqEE+Q9U4i0LQ5gIZoubHzHtca5JhmkPj/TyE0w82CAj/6a1E14Nt1LggamkKCq7OtKwdfJ6ZLtdkLdY8VGRtjr4NjZ5CJs3K+FySIjgY154frE3UJiVj7WLi2PN4EGDdn0h6HYY8aYP+JW5SZX4twYFmshWFUbfOX7G3/RLYE2UDZDu6VnvKxkyPYoUqNZiK4gNL9et8MYwox7tll+74AASWUn98ntTUrJObgunQJaxs9Tq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yueyang Pan <pyyjason@gmail.com>

Previously damos_stat only supoort paddr. This patch set adds support 
for damos_stat for vaddr. Also all different types of filters are 
supported. 

Functionality Test
==================
I wrote a small test program which allocates 10GB of DRAM, use 
madvise(MADV_HUGEPAGE) to convert the base pages to 2MB huge pages
Then my program does the following things in order:
1. Write sequentially to the whole 10GB region
2. Read the first 5GB region sequentially for 10 times
3. Sleep 5s
4. Read the second 5GB region sequentially for 10 times

With a proper damon setting, we are expected to see df-passed to be 10GB
and hot region move around with the read

$ # Start damon record
$sudo ./damo/damo start "./my_test/test" --monitoring_intervals 100ms\
1s 2s

$ # damon report
$sudo ./damo/damo report access --snapshot_damos_filter allow \
hugepage_size 2MiB 2MiB
    heatmap:
    # min/max temperatures: -600,000,000, 100,001,000, column size: 137.352 MiB
    intervals: sample 100 ms aggr 1 s (max access hz 10)
    # damos filters (df): reject none hugepage_size [2.000 MiB, 2.000 MiB]
    df-pass:
    # min/max temperatures: -400,000,000, 100,001,000, column size: 128.031 MiB
    0   addr 85.373 TiB   size 745.555 MiB access 0 hz   age 6 s           df-passed 0 B
    1   addr 127.608 TiB  size 877.664 MiB access 3.000 hz age 0 ns          df-passed 878.000 MiB
    2   addr 127.609 TiB  size 219.418 MiB access 2.000 hz age 0 ns          df-passed 220.000 MiB
    3   addr 127.609 TiB  size 316.613 MiB access 1.000 hz age 1 s           df-passed 316.000 MiB
    4   addr 127.609 TiB  size 474.922 MiB access 1.000 hz age 1 s           df-passed 476.000 MiB
    5   addr 127.610 TiB  size 407.188 MiB access 1.000 hz age 0 ns          df-passed 406.000 MiB
    6   addr 127.610 TiB  size 610.781 MiB access 1.000 hz age 0 ns          df-passed 612.000 MiB
    7   addr 127.611 TiB  size 697.309 MiB access 0 hz   age 0 ns          df-passed 696.000 MiB
    8   addr 127.611 TiB  size 77.480 MiB  access 1.000 hz age 0 ns          df-passed 78.000 MiB
    9   addr 127.611 TiB  size 573.102 MiB access 1.000 hz age 0 ns          df-passed 574.000 MiB
    10  addr 127.612 TiB  size 245.617 MiB access 2.000 hz age 0 ns          df-passed 246.000 MiB
    11  addr 127.612 TiB  size 295.102 MiB access 1.000 hz age 1 s           df-passed 294.000 MiB
    12  addr 127.612 TiB  size 295.105 MiB access 1.000 hz age 1 s           df-passed 296.000 MiB
    13  addr 127.613 TiB  size 67.172 MiB  access 1.000 hz age 1 s           df-passed 66.000 MiB
    14  addr 127.613 TiB  size 604.570 MiB access 0 hz   age 1 s           df-passed 606.000 MiB
    15  addr 127.613 TiB  size 389.578 MiB access 0 hz   age 4 s           df-passed 388.000 MiB
    16  addr 127.614 TiB  size 259.719 MiB access 0 hz   age 4 s           df-passed 260.000 MiB
    17  addr 127.614 TiB  size 817.941 MiB access 0 hz   age 4 s           df-passed 818.000 MiB
    18  addr 127.615 TiB  size 204.488 MiB access 0 hz   age 4 s           df-passed 204.000 MiB
    19  addr 127.615 TiB  size 730.902 MiB access 0 hz   age 4 s           df-passed 732.000 MiB
    20  addr 127.616 TiB  size 182.727 MiB access 0 hz   age 4 s           df-passed 182.000 MiB
    21  addr 127.616 TiB  size 926.824 MiB access 0 hz   age 2 s           df-passed 928.000 MiB
    22  addr 127.617 TiB  size 102.984 MiB access 0 hz   age 2 s           df-passed 102.000 MiB
    23  addr 127.617 TiB  size 86.527 MiB  access 0 hz   age 2 s           df-passed 86.000 MiB
    24  addr 127.617 TiB  size 778.777 MiB access 0 hz   age 2 s           df-passed 776.000 MiB
    25  addr 127.999 TiB  size 132.000 KiB access 0 hz   age 6 s           df-passed 0 B
    memory bw estimate: 6.524 GiB per second  df-passed: 6.527 GiB per second
    total size: 10.731 GiB  df-passed 10.000 GiB
    record DAMON intervals: sample 100 ms, aggr 1 s


$ # damon report again
$sudo ./damo/damo report access --snapshot_damos_filter allow \
hugepage_size 2MiB 2MiB
    heatmap:
    # min/max temperatures: -1,100,000,000, 2,000, column size: 137.352 MiB
    intervals: sample 100 ms aggr 1 s (max access hz 10)
    # damos filters (df): reject none hugepage_size [2.000 MiB, 2.000 MiB]
    df-pass:
    # min/max temperatures: -900,000,000, 2,000, column size: 128.031 MiB
    0   addr 85.373 TiB   size 745.555 MiB access 0 hz   age 11 s          df-passed 0 B
    1   addr 127.608 TiB  size 579.715 MiB access 2.000 hz age 0 ns          df-passed 580.000 MiB
    2   addr 127.608 TiB  size 144.930 MiB access 2.000 hz age 0 ns          df-passed 146.000 MiB
    3   addr 127.608 TiB  size 452.453 MiB access 2.000 hz age 0 ns          df-passed 452.000 MiB
    4   addr 127.609 TiB  size 113.117 MiB access 1.000 hz age 0 ns          df-passed 114.000 MiB
    5   addr 127.609 TiB  size 182.367 MiB access 2.000 hz age 0 ns          df-passed 182.000 MiB
    6   addr 127.609 TiB  size 182.371 MiB access 2.000 hz age 0 ns          df-passed 182.000 MiB
    7   addr 127.609 TiB  size 350.488 MiB access 1.000 hz age 0 ns          df-passed 350.000 MiB
    8   addr 127.610 TiB  size 525.738 MiB access 1.000 hz age 0 ns          df-passed 526.000 MiB
    9   addr 127.610 TiB  size 401.352 MiB access 1.000 hz age 0 ns          df-passed 402.000 MiB
    10  addr 127.611 TiB  size 100.340 MiB access 1.000 hz age 0 ns          df-passed 100.000 MiB
    11  addr 127.611 TiB  size 19.523 MiB  access 0 hz   age 0 ns          df-passed 20.000 MiB
    12  addr 127.611 TiB  size 175.727 MiB access 0 hz   age 0 ns          df-passed 176.000 MiB
    13  addr 127.611 TiB  size 106.629 MiB access 0 hz   age 0 ns          df-passed 106.000 MiB
    14  addr 127.611 TiB  size 959.676 MiB access 0 hz   age 0 ns          df-passed 960.000 MiB
    15  addr 127.612 TiB  size 424.469 MiB access 1.000 hz age 0 ns          df-passed 424.000 MiB
    16  addr 127.612 TiB  size 424.469 MiB access 1.000 hz age 0 ns          df-passed 424.000 MiB
    17  addr 127.613 TiB  size 201.648 MiB access 0 hz   age 6 s           df-passed 202.000 MiB
    18  addr 127.613 TiB  size 806.609 MiB access 0 hz   age 6 s           df-passed 806.000 MiB
    19  addr 127.614 TiB  size 862.125 MiB access 0 hz   age 9 s           df-passed 862.000 MiB
    20  addr 127.614 TiB  size 215.535 MiB access 0 hz   age 9 s           df-passed 216.000 MiB
    21  addr 127.615 TiB  size 104.500 MiB access 0 hz   age 9 s           df-passed 104.000 MiB
    22  addr 127.615 TiB  size 940.523 MiB access 0 hz   age 9 s           df-passed 942.000 MiB
    23  addr 127.616 TiB  size 640.281 MiB access 0 hz   age 7 s           df-passed 640.000 MiB
    24  addr 127.616 TiB  size 426.855 MiB access 0 hz   age 7 s           df-passed 426.000 MiB
    25  addr 127.617 TiB  size 90.105 MiB  access 0 hz   age 7 s           df-passed 90.000 MiB
    26  addr 127.617 TiB  size 810.965 MiB access 0 hz   age 7 s           df-passed 808.000 MiB
    27  addr 127.999 TiB  size 132.000 KiB access 0 hz   age 11 s          df-passed 0 B
    memory bw estimate: 5.297 GiB per second  df-passed: 5.297 GiB per second
    total size: 10.731 GiB  df-passed 10.000 GiB
    record DAMON intervals: sample 100 ms, aggr 1 s

As you can see the total df-passed region is 10GiB and the hot region
moves as the seq read keeps going

Revision History
================
Changes from v2 [2]:
- Fix some naming and format issues raised by SJ.

Changes from v1 [1]:
- Follow David's advise to combine *pmd_entry() and *pte_entry() into
  one. Also remove manually setting walk->action
- Use vma_normal_page and vma_normal_page_pmd instead of damon_get_folio
  to remove redundant folio_get and folio_put
- Follow SJ's advise to only move damon_pa_scheme_has_filter to
  ops-common
- Change the command used in cover-letter for more natural illustration

[1] https://lore.kernel.org/all/cover.1753794408.git.pyyjason@gmail.com/
[2] https://lore.kernel.org/all/cover.1753895066.git.pyyjason@gmail.com/

Yueyang Pan (2):
  mm/damon: Move has filter to ops-common
  mm/damon: Add damos_stat support for vaddr

 mm/damon/ops-common.c |   9 ++++
 mm/damon/ops-common.h |   2 +
 mm/damon/paddr.c      |  11 +----
 mm/damon/vaddr.c      | 103 +++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 114 insertions(+), 11 deletions(-)

-- 
2.43.0


