Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8BD8CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 09:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 419978E0015; Tue, 23 Sep 2025 05:16:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A2EC8E0001; Tue, 23 Sep 2025 05:16:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2912F8E0015; Tue, 23 Sep 2025 05:16:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10B418E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 05:16:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8FE52119F47
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:16:50 +0000 (UTC)
X-FDA: 83919960180.19.624E0B6
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id 39D1C100014
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:16:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hCrei8k6;
	spf=pass (imf05.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758619008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4mMHBSR6iVN6xpeCcQzalGxMENnFCjeMLhkVbx6JQl4=;
	b=B9Py4tjEcMqZKJSubV9lhH7tGW9Y3M+ly15l5aj7RyGdnaQaT0f7vBMQUYVMiqIDWat+CS
	BuadcpYGKgtzoQs5iQPJ6HWZSiNIkBap4lIIAcf0X6c7f2UR8IK+Snqfwo2GY4uP8UmHzb
	S4V1emCj/q6AirugYtgK4bAAE7bgAw4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hCrei8k6;
	spf=pass (imf05.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758619008; a=rsa-sha256;
	cv=none;
	b=kPTChe9b/Fm9A86m715YmFMCJBevrABjinmn1WYpV1XnflMGbJ3ZlhsbHHS2xZwzIVpgIX
	yVjz93bjblqApONBErBgdHIh5NOVcULxTPLEvKdeHUftqN4C1T06ApgLPTJom7SkNCEFm7
	KjkYg4YaeuHiUU8206xXddokofyZbx4=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-267fac63459so50715425ad.1
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758619007; x=1759223807; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4mMHBSR6iVN6xpeCcQzalGxMENnFCjeMLhkVbx6JQl4=;
        b=hCrei8k66by26RACtNFuWhOF69HqfwAeCNCeG+OAdmrGQ+UPs5vHWIy897gwZzzzur
         drKjwK3C79LOpa+4VDC5s3F4bMMUxhHZaE2Cl2cLrMZ+B3AxePQDG8WaIvyvt8z02c/H
         vMixvwhMMfl0EKWV72iai/oagBCU484znsmR9fitwiA6X4+8m00kPKxSKbGqED5pYycS
         nN6V7MagakBglymyWZFd2vYPuR+hKmSje6fUQ30Hx3k3zJcP5AJ5OuKPJt9nSfNUOJhA
         l1O/kVBeeJGUVKJO4D/ojIkxjelzqIE5OQ5Xk7WrTHlYG0ie7bEsfJjIq61TPiUmHvaP
         ubIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758619007; x=1759223807;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4mMHBSR6iVN6xpeCcQzalGxMENnFCjeMLhkVbx6JQl4=;
        b=ugQ2ItmR8TPLHYyfhgWb53I4QOKgjCRsF7/Tz7+7fpI5uROOx4a5D+iuV8BFUTv7IP
         19TUNeJYDyncvNqjPjA+YP+jeGvpz+84/22Pb9zZbNoOgUTsFLRMg+k5u2YjEW1Q1xD7
         pgqXJBuOyeRGOTWmzAHj1pHeGfVqCqaQ/DZ8AwEGKoBpzWSKBU513iC6RU4LIKzaPEMD
         yHCcwZc2Pusr9t/+W4KULp0caHJw3MYKfkQCC0WEVpGM7d3UTFA33y/Ep16C2rzffYt7
         zXIxZYLUKBmzNlf29A/5yYElNDK3DuHlArlqk/fw571xapJAYA72TBvrEF0rjFsV800x
         FCSg==
X-Gm-Message-State: AOJu0Yy3wOKof94kpJwyn7pS0AAfVafUhuj9GzdWOFeVs92CwM97uJEN
	W5A+2m2RoZLNFjjl9yFzhOJhQT+4nzW1JEfDeT5YQptn9YZVr2BcJvtRd4SvhMgv7Ps=
X-Gm-Gg: ASbGncshyREey1sp0qvx3REzTNEakRRRrxfEtSSL29gVOOsi+4YyI2rkr+wtd5O/yNg
	H05T2OEsL7iEGNsRL/UN1IMxErSAa/QjLXPVlrFYCUJAy7hVTjptq9X+hUimILlxmpS1LvlRz3C
	SxQrH+b59IcX7+YrB5tOdoDS5SfCIZxrZAMUISr/FQYgFAkmVquUWsH6ZMScyGjisjoOPCiCZnO
	w8WlbCqHIJXAIvPxNRfZiYP8obs9n/3+CnK2/pD36ZVIwz9OHr3/GTqUmnqq8NAUZJUBABEgszx
	TldtNf60stZuFEwHRNEUjdFo3fniWMC3TIMcWc8Sb15KyTXqARKa1gayttd/cgfJRz42v6b73td
	zP2eBFeo6vHoiP9LV8U4xEl/cO1jYzEUNAFAUCsL+R0ER4DVRYdM2CGqLsmfxlI6irUtDzb7CMC
	cDnRNoSw==
X-Google-Smtp-Source: AGHT+IE+pTyYnuUeKNBnXn7u5n9qqZquO3ZZc8vyWV1I57TGD6s8tCb5Ogkdy4UaIq5TtfdFMCYfeg==
X-Received: by 2002:a17:903:1983:b0:24c:da3b:7376 with SMTP id d9443c01a7336-27cc2d8ef77mr24868675ad.26.1758619006912;
        Tue, 23 Sep 2025 02:16:46 -0700 (PDT)
Received: from G7HT0H2MK4.bytedance.net ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ed26a9993sm18724713a91.11.2025.09.23.02.16.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 23 Sep 2025 02:16:46 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 0/4] reparent the THP split queue
Date: Tue, 23 Sep 2025 17:16:21 +0800
Message-ID: <cover.1758618527.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 39D1C100014
X-Rspamd-Server: rspam05
X-Stat-Signature: ptmzz4tgpe8att98w1uy48a11dzennb9
X-Rspam-User: 
X-HE-Tag: 1758619008-781680
X-HE-Meta: U2FsdGVkX1+AEa9So9A/07R9lVc2JkobgyKX0eVpxu7fZtqPqICek72QFk1zfF6e9GY7y1oInbxHoc2t++jdilHvpSsp/y5DjGMFmTU9pFO+0wm8lVXuDIBB7WQs3kms8ISlIXZ0J2ZYq1Sh1ibk4G07sXpOTqzPWRf1fnRJ2b74bQL/uNtHq43TWeyD5dciVxTmMoiFpTAoMjFdRD1XqSYJq9mfK2CIh8yPo69Ws4arh1GYnxZhpZJ5JTFZQjk8KACecjKpi5xlcgrT0f+ilRDPfRzACbHn7vM14JT3zEbQ6i0scmTySV8fQBxjhAcvdfw/YUQMjny5Y0+ZIDVWCiMPeBXOvO/XW7/7p0Vm0fMcQmGUlK9vUv7vQpfUmvOhjGqhxLkGw7x9lsQMzbJhEgH29ADmmICsU36Y/nIZMpFzeTxUboevn1v9tw4KNEriWpcfHWyFC9lS7pNNlup+9ExtrQcUWTd0AddV1sZne4JS+xoKLSiW3+SB6VHUrr0NYTwkR47lc8gfDPJrxGJsK3PtUifD0AJ4+BV1dI8Yw0a1IZf6z8XGH/ylndbd+87Jmf/72y4SPTLz9ewhQ1MkDJfAOa3y/1OmITHof70uDfNBnjfmQpHkD19IOiRo3zdcea4TGkFUmoDkSHDY209VJATE9qgjbsuZRE230wsPQ5QAtOER/AXjn6Qm9QMetetVtCtRHitddKcQMC721ApmogKxXbc9KiYBFd8fvZNZbyhOSUFE41AnPdYPMXC0+Tn72Y1Ip+ZXvlr4RxMdT8gakPeFg74cJLJWXd601OhQPiBhJ5S01V9JiAX5IuQ27U2hxupBkzUkmxyLNwjaPKCyrEumYSovjmkxzNglZxuc5UK+63DZ+/IBj8O2HttdlzZsN189ZodCBmYkBvcJO4Ev5zS/eS2Q2t/D1VB5latj97vBsl8HzsDlt56VdDy391R9wXUrjpZZSrKnvIPkpp0
 HsKq+774
 FrU+iLJxndJQ3xpDTrd4YNKE8ocFuLCDrW3sLUSUN7kCd3vUDImrbH+/nHk+qkeKqYykTXdRSONLJiOEh0HKZfDbaaDEMIAOS7hWa2w3rwMxawWiczP0VA4vfbImxiI/jJMG4jcX7+ryJiwMxLNLN0xd+mKrsL+GHs6YuZ7AZRqyrori7icBbLlQSqe9atriTWh2QrodjF2De420MZK6ZesdLvUljp7eIt1QY+rKItAKQVu9+qp/gGpemv37jFUc7QIKnpQKZ4S23j4i9QbFEyT2ZlYTuavA6b/znZXLTuriB9a8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes in v2:
 - fix build errors in [PATCH 2/4] and [PATCH 4/4]
 - some cleanups for [PATCH 3/4] (suggested by David Hildenbrand)
 - collect Acked-bys and Reviewed-bys
 - rebase onto the next-20250922

Hi all,

In the future, we will reparent LRU folios during memcg offline to eliminate
dying memory cgroups, which requires reparenting the THP split queue to its
parent memcg.

Similar to list_lru, the split queue is relatively independent and does not need
to be reparented along with objcg and LRU folios (holding objcg lock and lru
lock). Therefore, we can apply the same mechanism as list_lru to reparent the
split queue first when memcg is offine.

The first three patches in this series are separated from the series
"Eliminate Dying Memory Cgroup" [1], mainly to do some cleanup and preparatory
work.

The last patch reparents the THP split queue to its parent memcg during memcg
offline.

Comments and suggestions are welcome!

Thanks,
Qi

[1]. https://lore.kernel.org/all/20250415024532.26632-1-songmuchun@bytedance.com/

Muchun Song (3):
  mm: thp: replace folio_memcg() with folio_memcg_charged()
  mm: thp: introduce folio_split_queue_lock and its variants
  mm: thp: use folio_batch to handle THP splitting in
    deferred_split_scan()

Qi Zheng (1):
  mm: thp: reparent the split queue during memcg offline

 include/linux/huge_mm.h    |   2 +
 include/linux/memcontrol.h |  10 ++
 include/linux/mmzone.h     |   1 +
 mm/huge_memory.c           | 229 +++++++++++++++++++++++++------------
 mm/memcontrol.c            |   1 +
 mm/mm_init.c               |   1 +
 6 files changed, 172 insertions(+), 72 deletions(-)

-- 
2.20.1


