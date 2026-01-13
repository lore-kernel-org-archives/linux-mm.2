Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EE8ED2D0E3
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 12:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39C6D6B0005; Tue, 13 Jan 2026 07:12:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 353AF6B0089; Tue, 13 Jan 2026 07:12:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27CE46B008A; Tue, 13 Jan 2026 07:12:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1551E6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:12:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3E401ACD0F
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:12:57 +0000 (UTC)
X-FDA: 84326829594.28.63BDE34
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id 38BF1C0011
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 12:12:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mmvPJ1qq;
	spf=pass (imf22.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768306376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QIjRrpTXF2MlYBwJ0ocSkqbjSwdZMAcaOgRZENhNgBc=;
	b=CEsKNS9a+hiFSyp62z2JZh3hkOOxxC2WbimhCQRgCKj91uJJYPefb1YK7naEMpGLAS59kF
	k7SnnQE70IY59X2jv48U3c9ys3zf7vXp5czM08+hNxQ1AbiB3c+b1D+Ggu4ogGqKIrVuja
	yLKjTUgMYkiDZweG+i7uxG43G+qWXFY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768306376; a=rsa-sha256;
	cv=none;
	b=YmOLK6Cao7URQP8m7pAT9uy3BhbhMA86X+Ipyk6zJC+OVa+4AWdGh8eDG5JR2Qm1M2hvUz
	Ucd0LbbhH8O/VpT/C7zJQ23ozNmP1hfL+zH4lrxpmyeGFvQzuhJ6XrSRcAqAxSev3GkKS3
	Cah7pBkZQLrGLJyJEbZSWRg0ZomHe4I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mmvPJ1qq;
	spf=pass (imf22.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-81e7477828bso2019128b3a.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768306375; x=1768911175; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QIjRrpTXF2MlYBwJ0ocSkqbjSwdZMAcaOgRZENhNgBc=;
        b=mmvPJ1qq7B9LzfoBNpRMhXocNruqeRKvA+rlIcXx4d8NkqtCDXYCNYd/nLzqHrYG3c
         p4pclNpf4EPmAQRz0iZGpXPmz8yyNeOrycmHrOM1LB0C2wyit1daZkD8Fs6KJrgwnYNc
         GCaOJGZCjyp1sIfF80vOMr/taHQruW6RjKkFKofumucFW4b4xzDfaCcHf0ZAhloeGRcw
         ozxvhygORZe3ZL4G5k9TkJsR/enS0COX3ojFBiAobpP8xavBCWGRta5RIU6a9GalItYb
         q8wggFv3HoKvJx8MbfD+eLGPTsywKBzmAzKkkULJ11vZwkmX0XscrWR+8VWs/Bu82xFp
         YifQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768306375; x=1768911175;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QIjRrpTXF2MlYBwJ0ocSkqbjSwdZMAcaOgRZENhNgBc=;
        b=H/VaRecBVkEJlDPhrNa8OL29vf8hG7UA4ZLPFz+TtIBqOcaluIzEmGOk8bs3qN/kwO
         Ej+mRwDHBWyJTAW37mbGmvYE1zUkBKLmWQZvxExtIkKdwTsv/A7tbvxoikaG7W/Msq54
         9PZhsj5WlLigWxTo4vN3redeWmxYizuFBMlM9sUm+4OGqR4NEEslr7ciquEJrlRj/Hl2
         66ZqgcqsXjt76OogmeIDVAaHlO8U4ilp+vf0jGvOI/GWPLoSQTqKrFsyLSYppzYCVEVK
         9U+scEY4YXcp7wbGBtEbhn9VbBlDzx5er+VWaLTiJsCXn/sepISlTdL0QyfTbQ7zfJsL
         UmZQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8HN5EABgnxdYN8yi97ooJ2BT6gznetpHcVdzNZCWyjKUayhcbOilna/LVbKZZ82BVUdIij2jlHQ==@kvack.org
X-Gm-Message-State: AOJu0YwR2Vs6gQYhGR2oZIa8VXOzSP8VZRj3d+e3B6+Qz+gVYCo1LYBs
	63+13muinl7hZLR9SaTZTXoJf0qd6xSkOA67ExUw2EGE21IYZS2yeVrt
X-Gm-Gg: AY/fxX4ThVH1smZq1ywp/np1uhr0uv0J4KYL2ii1/ZJw6hKKsy6+lEBvohwDa7NEx42
	PdWofB22wxZ6wVJn5weC4Ph5W9iUalt7xZR4LuW8O0SKAZgsNAAmAKHj31BwqpIU1/5X+ow6qND
	MElT+S4hvSi35IiGgDtdaKstE+G1aO+wjxfvY1Tu73/V1xsYCCt3M5Z4LRnyMx1TNF5NKtf139P
	LL0vVlYuXZ0UxUER93Escj2cunOuOkQq4IXkhDgOtJalF5x2BdDqsMA8jt2At+DWuJ6tWe7QRRt
	ZOqUxrtBytfiE772xulTA9OL6O/oqqh2FbKPMYdCv3hnpPfIqYV4U/95CAz/1m4LbzIWikvHt55
	QTPuprhQuDzTpcMJ5B7mGneODR1rROYeFE2Kkw2HWmIpUfUZjVo/JrVc+SP+27qJTmvfEFXsnLU
	FXktRxktrvtxYTa/TeVQzMqVx7nMIZ/kg712PYfajsjtVoWg2YVrDqKeU=
X-Received: by 2002:aa7:88c6:0:b0:80f:4667:a94a with SMTP id d2e1a72fcca58-81f6f74ed6amr2174765b3a.10.1768306374861;
        Tue, 13 Jan 2026 04:12:54 -0800 (PST)
Received: from localhost.localdomain ([2409:891f:1d24:c3f5:8074:4004:163:94af])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81e7fd708fdsm11596703b3a.65.2026.01.13.04.12.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Jan 2026 04:12:54 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: roman.gushchin@linux.dev,
	inwardvessel@gmail.com,
	shakeel.butt@linux.dev,
	akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	mkoutny@suse.com,
	yu.c.chen@intel.com,
	zhao1.liu@intel.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 0/3] BPF-based NUMA balancing 
Date: Tue, 13 Jan 2026 20:12:35 +0800
Message-ID: <20260113121238.11300-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 38BF1C0011
X-Rspam-User: 
X-Stat-Signature: 9jrgguz7fsxes3sx5y7bu59at7kqmfi1
X-HE-Tag: 1768306376-921580
X-HE-Meta: U2FsdGVkX1+p4vRqiU3ktCxDVfGSjwOXFi4kPji2WX/qblUztuQnXkid8Wnrr2YehK21uzkVC8l5Rcpz/3ikptj3qAuH0qdE/IzEMH42V447FJ/n00ZR+jBpnCab34VeVMftbEtXe6XNPC0DTrbsWckWpL2/UDw287jglWoXmsYRIhoUwrsHeJ57tgzjxi7lCH6NNW4ci0wE2GsQY7p9IF70qPVuA7tcC5zLBAFikxxxDZ4XbFZZiy82HSrfvURXQfZvyRRCl4gv2tYA4fnuIrT7PnD/665dtbtmrPFRPn02dJ32DitjMeGs4Jy3myRq3uO7xbSLSOq922TW+qV0lo942jX+6EZHNW29ktxy6i20JUtD3zmJB/85DqnKHGUsa/005RsLNJvYL3ksQNs7q5fMaIxpdlgZlsCpAzWvXVc6JkVY7Z5x1MJ7EO9YPKNHBDjnSx4WMNW3JJDjXbQQIiDnyMDqwW/nGVmrY0faCqyx97Ttgb3wh34I6OL4/UbrYrN32v9ejBRNR2fhYRHzUYGo2fF1WEt8rzwlbkpXjoSNOBZyLLbB5hbGd05ne+HWbyyHt6gizUoc19gqhgOboS6402Y6ozSm8cn4c3W4rDxSD5zzq27FVu2JpZA5Jw9TD5OgaeoG+dKv77RtBTMfLCze9d8Nel7GsJXUqwUr7qBMGXjM8qvE8RzMNz+zdIrWsbQ4kdddzA8tTMmP/3tOFGDaEDaECQeZyVppBN2NmiTs9DZwcGSSKwbyhFhd2p69kBs93+lP0mKm8ssneWTiDHsT7c3MuAg33tN0Nl3WWMAs8wCfck0yKHewIDhCYXsCFzbGK3tT3QCObQ2+MK1qaJjwdgK5lkXNYY/BkpLtZxqwUN0VC2jFCPSb28rL5j8tRHPQKw787Ma+Kociy3w7NH8VZVcqcYeVIgP0x5E1Ruur/lBim9s5rP2G55Xb5fbwwUvHpz39L41+Wp6q7HI
 pr6D2Btw
 gvhWQxPjdNf8oviKIFd+GRdUHmrRDGaJbh9+0wPbl1sHIWOlTtSMawiSbNm2Y1l3QlR1oGeiN6d6Y8taD8cj8v011Vn6k2DW4CcUx97tMf5dPADdcLXtok8Af/Ii5AuTaWSZPVOytFPeeUeyHo0NNt1gqqCJbdw4BXWqcyY0lq1tybtmyQ/uAUKveN71RvGfpqvxfmI7XPFk9lr0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In our large fleet of Kubernetes-managed servers, NUMA balancing has been
historically disabled globally on each server. With increasing deployment
of AMD EPYC servers in our fleet, cross-NUMA access has become a critical
performance issue, prompting us to consider enabling NUMA balancing to
address it.

However, enabling NUMA balancing globally is not acceptable as it would
increase overall system overhead and potentially introduce latency spikes
for latency-sensitive workloads. Instead, we aim to enable it selectively
for workloads that can genuinely benefit from it. Even for such workloads,
we require fine-grained per-workload tuning capabilities.

To maximize cross-NUMA page migration while minimizing overhead, we
propose tuning NUMA balancing per workload using BPF.

This patchset introduces a new BPF hook ->numab_hook() as a memory cgroup
based struct-ops. This enables NUMA balancing for specific workloads
while keeping global NUMA balancing disabled. It also allows tuning
NUMA balancing parameters per workload. Patch #3 demonstrates how to
adjust the hot threshold per workload using BPF.

Since bpf_struct_ops and cgroups integration [0] is still under
development by Roman, this patchset temporarily embeds the cgroup ID
into the struct-ops for review purposes. We can migrate to the new
approach once it's available.

This is still an RFC with limited testing. Any feedback is welcome.

[0]. https://lore.kernel.org/bpf/CAADnVQJGiH_yF=AoFSRy4zh20uneJgBfqGshubLM6aVq069Fhg@mail.gmail.com/

Yafang Shao (3):
  sched: add helpers for numa balancing
  mm: add support for bpf based numa balancing
  mm: set numa balancing hot threshold with bpf

 MAINTAINERS                          |   1 +
 include/linux/memcontrol.h           |   6 +
 include/linux/sched/numa_balancing.h |  44 +++++
 kernel/sched/fair.c                  |  17 +-
 kernel/sched/sched.h                 |   2 -
 mm/Makefile                          |   5 +
 mm/bpf_numa_balancing.c              | 252 +++++++++++++++++++++++++++
 mm/memory-tiers.c                    |   3 +-
 mm/mempolicy.c                       |   3 +-
 mm/migrate.c                         |   7 +-
 mm/vmscan.c                          |   7 +-
 11 files changed, 326 insertions(+), 21 deletions(-)
 create mode 100644 mm/bpf_numa_balancing.c

-- 
2.43.5


