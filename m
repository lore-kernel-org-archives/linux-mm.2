Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F347EEC2B3
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 00:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88676B0005; Mon, 23 Feb 2026 19:33:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0B5D6B0089; Mon, 23 Feb 2026 19:33:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D6526B008A; Mon, 23 Feb 2026 19:33:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 843D26B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:33:34 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 28A2D8B4D6
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:33:34 +0000 (UTC)
X-FDA: 84477476748.09.759C81D
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5E0758000D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:33:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TX1NQ7c2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.217.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771893212; a=rsa-sha256;
	cv=none;
	b=b44JT2m8uxGE2xXDekTRSBAmHtXDm2lmm/M+j0L8SxPlNp9of1g1dHCNbwaSTy5u2IERLw
	tzTL3mJbsbi3Qdo70lzKYmI60l8LqlqM5TP8t2H+6SG8qu7AW3AItm2uSUO3skygH3SQHO
	/JaYrHLaI3y6852PQFYTJV8yW7Qa2sI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TX1NQ7c2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.217.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771893212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=r71zDlsdwqZwuXP6L6SMlSArsf0mkKQK+1/SxbuvMeM=;
	b=xWHtc3QVv5p25hi2xn1WPeUhjUHDoxkWWV1sC07aiIFAd18X0IbJFGVQLzu/pRTCqJtO73
	1SsTSTuvYOLLPlCbbh+9oimYqiXgetN/r7hTlvlVTjFUr41qd8DB1kRCKUFW+nduouVMOQ
	zZhpuu8cYXBOqm4FZgQ2I8g/K9VeKy0=
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-5fe086fb0baso2570352137.3
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771893211; x=1772498011; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r71zDlsdwqZwuXP6L6SMlSArsf0mkKQK+1/SxbuvMeM=;
        b=TX1NQ7c23wZjkEa3uSCyQLF5AMKdMWo13Gf57BAciNJkAdMHSjoCdOgid3R8rAoPtI
         wLoLNtCEczQZ5GG3flPdWZnVdPvdf1T6yG+AlMrhXwZfN81EXtB+X8VuKsft6AKFgUyg
         Bh2gn8Me53qkzUSxCflOQRo6eiwcBiIvnevDYWsy4Viudve95XKm3SRequx4ect/QmEv
         VOFlO5dGolT0xQKBXDx1qr2xz80fJIv056XWSJIodL19wla9X24dTLTX7Z49DvGMczxP
         4zj3GmtOAzJkMBp8tzW4LljTgxY0pIhlixn2QmjIvffiq9rvoM3kFfruOgUJWHa40GWT
         GYBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771893211; x=1772498011;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r71zDlsdwqZwuXP6L6SMlSArsf0mkKQK+1/SxbuvMeM=;
        b=KD1I0vzlGlDWgkERgwZeL+WZmMaXuWJsTA4QxqF62S7ZDyPH0raJF/vgDh0AwVdjW1
         NkRFAr+141TjXzq8PbxxLKQ8xA6jU2GyCuUFyyoFa9IIXjMU8bwaBlwQtt7Q6HT9RLmW
         Ys3OIUEiaADvXHYkRgb4vaEgxnFZdv+fZ8n/PQsdlWQgtFvef/qR3XIs7LgWlz+7jO80
         dpHvOswsHM0mZLOahYZl1jSeA0wiJl1Yul08puFfTDmvPPioo4dB5n22T2MRBoQC6bQH
         VzM/ZLoOJeOysUgQ5UkQEsoyN68571bOnBkUqCUPEtZk6vxClO08FPJ5rXcKBOkCF9d8
         ocAg==
X-Forwarded-Encrypted: i=1; AJvYcCXBRNC4rgdQzriuMrVDNyVxZCYQSpGWOOMaTTAtQKboYE9XOQw7S4WnAqhPTaspRo+Db1WdDsTa/A==@kvack.org
X-Gm-Message-State: AOJu0Yyb/dYJDQYgIqWdkwGqo+NqZV/SCwoDO2bAap/OkXN7X5g+fi9y
	32ed4djswMme/See9u0+YhkNYoN6shD+9PSkILSP9JRz4kySUbYV66DA+PGfAw==
X-Gm-Gg: ATEYQzy4KbM1Mw4dAQaVjBabBt0pjDtMEHL1hCH3Wi8oqW+F87HV7XbUsSJDtvzRjMR
	iN8obZjQ8Xr2BCyfJv5g6dAeSR1SyYD1V1SFbZ33AjKW69ZsWTVm/m6M1rlZD2SBWgib19n6koD
	CDP4ZRTNL1aGDC8Bdn/8QYMugHkq98oPNp6rbrnoGmIDjlPaWx53UQhnKtuUFodEN0xmIvmEnPP
	jUMLNS4+ie9tbwMJ4RlYPwttfNnayprdunoCDfli7eEbpgI76qrSzSYJc33qKF+jFPJ0yL/1x67
	XmKxjERhnLZt6iXNE6jV9KsHFIPneO4R25gd02QDH50yf2t1wFCa50HrxlSEvpMZPXvwTN0lZm/
	ZGakQKSPfSOfHYSlyUak5EiKl0JMCru1oXU7xZZc9EykMfYC1+dZF+6F+v0CVvKdy3Uv9Gx8NBA
	KpbW+4GUdcnCbRw0LW81PGww==
X-Received: by 2002:a05:6820:2d0b:b0:679:92c7:2c07 with SMTP id 006d021491bc7-679c42784famr5858006eaf.29.1771886313849;
        Mon, 23 Feb 2026 14:38:33 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:53::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-679c5630a4bsm7167922eaf.2.2026.02.23.14.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 14:38:31 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: 
Cc: Gregory Price <gourry@gourry.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kaiyang Zhao <kaiyang2@cs.cmu.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Waiman Long <longman@redhat.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH 0/6] mm/memcontrol: Make memcg limits tier-aware
Date: Mon, 23 Feb 2026 14:38:23 -0800
Message-ID: <20260223223830.586018-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nny9uqswsbhu58y9nqo81jgyp7r7n44x
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5E0758000D
X-HE-Tag: 1771893212-815880
X-HE-Meta: U2FsdGVkX1+CdQacFh13Cd+CdqMD4rnODjPhrWTYmmkb6NDjakiCJ3ywbvCF8KqKf4YfjX8OLo37pdYscC9GVIbWD7ZA7jaXZuDIvYNGXYOclyw73H+dDvQqShOqWFL3Tv7RznZ/2OM14yY4XVuv+Ph7l3Ah8IU4rT0zkzb3Gg4bltpOjsZ+HZg+RxEpzBxGaLsmeFyPApHp/xpifvpNWC+0QMxDhG6d/2qeaZfZRyzQn1LaywDhR69yj0SiDDdPkEOgLv8if6l4tRVrb4Oh/P8BqhJoOVoJvdPZ6Kbf8tKfQ4ru1RaNoX28ugr3qoTr5Z9VaxBIXBRk4giJxoBapo886ZNMB4irfAU0GQt5P12hKoGODxvtQKsIB+lZQZc3juSR8lfBnZd5iUCUBXwMqqhBkX3OWUkrykJX+8KT3gFd1chdyaqsxU/QGpNH4Wf3Dx3t6hDl0Nm8fyAOUjar2lUCN8UleUDIBgyG2i7MXYk8n4ktZyVlFUx5NP6qJFCT1urwUQiVgb6kicmPRTkj24RLN9B/7kt5vjvvpVspkr5TQe/G/C7Bu66dLRXuiF7bxlx60x2LNMTN2eANqzVslbxFKpDnDfJIfrmg6LTr2SRqwCUN2VtHm4rUFpDukLCqlsc6HNLFQnWHX4ijQSCxO1TQbDKajpIuMnG606piKyRT5VdnCCqoiYepVj6yhbbFrCXVlz75OKIfl4XxHy2krdhtUonmS6s1IRIRYGwacaPYNWCZMBJr9f7b+fvqqA73FsjJ0yyA22qZBIUZJubKPPkC9EkEvto6QHstpKV4wEgxo89DVMz/HZwhEpcp3xivIL5MtjJHZ4qtJd/LWlDbXn9AludGvETsJFF6zAWS7MWWq6szZf7BnDbbCalZfgjZG9IytCSYI1I7GfF6syNK+YfcyLguF9O+Kg74og1gofpDG4vcOwAFbQVAJKKcDhF+JkAbPpk8ap7ZCZA/kLF
 zoZliOqI
 8vlA6mSj57jnXw6v4kvQNVna1QoX6fj25g11E8pt0bqh47cJJQo9nzVHBFPHAYoP2vwhJ51v69oIWmmM3q9Chcz58N7P4VmAD9T1SScMtiiXEuk3sgraFH2G79BBAQ7ujfGwU8yXxg7rHWD+/W9KcSkJrMNUzO1xRKXlYokNowCw9eIe3K1S3JQXwAo389z+OXF9kMab9OQZKBk3y9JQrYcrfCvLjwXWWX1FLSd0LXECZdJ0/xfFJbC0fCVjnpIsSGMby25wlGWCrfNfVwfB0XXNSoPc/Wi1HdsHbLrQdWMQFaLBHzqkBiN7IO+4rGJSPFsbnTQDafBuLLtQWnq0Pal9MBWg/cNxLiSzR+irTO6D82HYL1tQZLzRPdZ+B/7uabEN4Nc1rRpRZ9eDxpJhxAGTQ1druYx4jnl9OEO1p68qQ1sk4LSuL106hGoPqhvV65n3uN7c3oZnV/vPmOgcYnVEd2VRgNOJZyZesq8z3rCx9UtE4eh2cis8dgdFRBU2z7wgID0t2P/82dC5rjVTe3Ugu9jxblei1W+Nh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory cgroups provide an interface that allow multiple workloads on a
host to co-exist, and establish both weak and strong memory isolation
guarantees. For large servers and small embedded systems alike, memcgs
provide an effective way to provide a baseline quality of service for
protected workloads.

This works, because for the most part, all memory is equal (except for
zram / zswap). Restricting a cgroup's memory footprint restricts how
much it can hurt other workloads competing for memory. Likewise, setting
memory.low or memory.min limits can provide weak and strong guarantees
to the performance of a cgroup.

However, on systems with tiered memory (e.g. CXL / compressed memory),
the quality of service guarantees that memcg limits enforced become less
effective, as memcg has no awareness of the physical location of its
charged memory. In other words, a workload that is well-behaved within
its memcg limits may still be hurting the performance of other
well-behaving workloads on the system by hogging more than its
"fair share" of toptier memory.

Introduce tier-aware memcg limits, which scale memory.low/high to
reflect the ratio of toptier:total memory the cgroup has access.

Take the following scenario as an example:
On a host with 3:1 toptier:lowtier, say 150G toptier, and 50Glowtier,
setting a cgroup's limits to:
	memory.min:  15G
	memory.low:  20G
	memory.high: 40G
	memory.max:  50G

Will be enforced at the toptier as:
	memory.min:          15G
	memory.toptier_low:  15G (20 * 150/200)
	memory.toptier_high: 30G (40 * 150/200)
	memory.max:          50G

Let's say that there are 4 such cgroups on the host. Previously, it would
be possible for 3 hosts to completely take over all of DRAM, while one
cgroup could only access the lowtier memory. In the perspective of a
tier-agnostic memcg limit enforcement, the three cgroups are all
well-behaved, consuming within their memory limits.

This is not to say that the scenario above is incorrect. In fact, for
letting the hottest cgroups run in DRAM while pushing out colder cgroups
to lowtier memory lets the system perform the most aggregate work total.

But for other scenarios, the target might not be maximizing aggregate
work, but maximizing the minimum performance guarantee for each
individual workload (think hosts shared across different users, such as
VM hosting services).

To reflect these two scenarios, introduce a sysctl tier_aware_memcg,
which allows the host to toggle between enforcing and overlooking
toptier memcg limit breaches.

This work is inspired & based off of Kaiyang Zhao's work from 2024 [1],
where he referred to this concept as "memory tiering fairness".
The biggest difference in the implementations lie in how toptier memory
is tracked; in his implementation, an lruvec stat aggregation is done on
each usage check, while in this implementation, a new cacheline is
introduced in page_coutner to keep track of toptier usage (Kaiyang also
introduces a new cachline in page_counter, but only uses it to cache
capacity and thresholds). This implementation also extends the memory
limit enforcement to memory.high as well.

[1] https://lore.kernel.org/linux-mm/20240920221202.1734227-1-kaiyang2@cs.cmu.edu/

---
Joshua Hahn (6):
  mm/memory-tiers: Introduce tier-aware memcg limit sysfs
  mm/page_counter: Introduce tiered memory awareness to page_counter
  mm/memory-tiers, memcontrol: Introduce toptier capacity updates
  mm/memcontrol: Charge and uncharge from toptier
  mm/memcontrol, page_counter: Make memory.low tier-aware
  mm/memcontrol: Make memory.high tier-aware

 include/linux/memcontrol.h   |  21 ++++-
 include/linux/memory-tiers.h |  30 +++++++
 include/linux/page_counter.h |  31 ++++++-
 include/linux/swap.h         |   3 +-
 kernel/cgroup/cpuset.c       |   2 +-
 kernel/cgroup/dmem.c         |   2 +-
 mm/memcontrol-v1.c           |   6 +-
 mm/memcontrol.c              | 155 +++++++++++++++++++++++++++++++----
 mm/memory-tiers.c            |  63 ++++++++++++++
 mm/page_counter.c            |  77 ++++++++++++++++-
 mm/vmscan.c                  |  24 ++++--
 11 files changed, 376 insertions(+), 38 deletions(-)

-- 
2.47.3


