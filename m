Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5ECDC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 11:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D607E6B008A; Fri, 28 Aug 2026 07:09:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9D96B008C; Fri, 28 Aug 2026 07:09:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C26986B0092; Fri, 28 Aug 2026 07:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A36926B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:09:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D81FA02FD
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:09:52 +0000 (UTC)
X-FDA: 85150408224.20.C9CF214
Received: from mta0.migadu.com (out-107.mta0.migadu.com [91.218.175.107])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8B71940004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:09:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="q/MAiruP";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.107 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787915391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=akBr92FPC2/YPYGwMsHhBDDARqFTGqRFzP7j5PQVwxQ=;
	b=y01/H0OKVXnWYvUA4p36HTt5ebFiuRq6Uazwu9HIvYnUsrU/yP8jHb7trHqLk8X+WQYAi1
	7ypW/ty1q2cm3aCB79pvqOS8GIVtbfsOsFH8e0FKi/lcHmieKwTw8FOIX1MMMyVYdqoh5+
	0VpuOL4KGC/IpOl+6pVbJ/S6DdVB6HA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="q/MAiruP";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.107 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787915391;
	b=7PoLOQAmeohsUFdmnIVIJpjaWW61w/ePilIVdSHbqbEtHW9UnDBPzzkoapQs3cSTydUvEo
	L6IzCJyMPSY4MQoMTn6bo/q/O0dgGA6RXv0xKYpCTxRe+Uz2uiijKPqzD1mLZZ4EeBzb8W
	n2zSLAQOEjcLpAorj18dI5H82H4S868=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=aB2sPXe8ZSnNuzSPG400K7+aKsUxWLpt5p1IJqhSTDk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787915389; v=1; x=1788520189;
 b=q/MAiruP6z7DqG5e7rjLjwFB90It1swu5Sln7BlhPNHhSxMuHu04+R3WTwqw6+bX04y4J8R0
 Xx4VxquQEKd3tpIcY7AF18o/gA/YXvLX2apf7y+ZCXsHrIcA8EZcl9031LR3tSJXkAQAPMpc2o/
 UgkEKFX0fK6BNm1JXWPD4ulw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 55830487e16c8120;
	Fri, 28 Aug 2026 11:09:39 +0000
X-Mizu-Trace-ID: 55830487e16c8120
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Chris Down <chris@chrisdown.name>,
	Tejun Heo <tj@kernel.org>,
	Yu Zhao <yuzhao@google.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v2 0/2] mm/mglru: fix ineffective memory protection for non-kswapd reclaim
Date: Fri, 28 Aug 2026 19:09:17 +0800
Message-Id: <20260828110919.1324028-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 37e5whu7nqrrhi1czwgmmbwkf1awto5m
X-Rspamd-Queue-Id: 8B71940004
X-HE-Tag: 1787915390-276383
X-HE-Meta: U2FsdGVkX1/ctCMIBfii3AlfJSnQjAQd8tIGAo3F+ElSmcinhBws1rtIg0kAqt9dD3s945JGjWa5dj3mGJ7OoRfVlRPRGrN/RadEQKe6y7s0Jmt9gFwjreRVgIIdj4iPZI9I3FiJ3d8cgr3/O80llppwSKb0/5J2+cU9vWg2MsycRqTYj8lzCoKYKfzmHxOgQx9TZib/5DF23PKBcJhGZ24vA2dMOAs5W5u5RsYChi4OxCmH/hOxMpj7PW12SWXDXaSQ5psfWK8D/5vu+pLeuditiEiDz/0vvTC/s0k93bqsXYrOX9o+6qo7IJBBvbV3EJ4B97VIVk10IPyy7cWf6Fj39IkAgMz4Y0EQW462GIOOvupgBx79BFakKW0zkRK8nzYZ5MusjU1hHpA2j7BMYSNZnVwjVjqORqsCH3xv6ZJcyzIbh0i91kVHMiAlyLp+TMAbicf0XT5n6Cs4LzxL5wwr+qjUQEk3609mV8G20hVZKKSoH5KDs+xMbAIJt3b0n3blpJdAVfAfyvkcOvNcUNwUL6YP2wavtGYpXR+74KIgT6/gXcoOTABDtkytw0bGeVZQ3eQ/y846yX/njH46vsl80HLSEMhY0OkcfZreH76vmqfCRGSAjPp7vn/YuyJELjoeYdVFYzGyN1wU1qTIgEd47Jb2cEE1NAFlmosoBSa5e8Rv2pHItnlEydNGAotbq4EaXOiIFFpVTUAJixxUFCnd7221+OgCDfcqcqqW7UNQBpB4kVx1tWQNqXxDZXbwpM0bY7o21Odsv7jMHGFIqL0f21PmuCuaRh8vElXIa8a8FzqOaUbz8R1vELcMARJCR5GKJk8qalQsotDMX/YdoZ664JB3/yix4NMAHTtq0dKTtlLwZZQzCozQNy9vzq1RVEN1GYEDdNu08MFUUCz1911HdLsVpTTZcLTsIi3D/ATBB7gfZrTpHKGwX4Fh/bUaoykWZmbCwAoLWjoKfVD
 L1pckUr9
 gz5DhSapU5Eui/1Y/lCPhdT4GZZ/b2pUW6o8C2+XV2W/LGWYVVDHrjxVxzFq8MZ638BRls91Mnv0Tm5We2Q4CfncrUJ3VUA1RjfrAWAMoNj4fK3JZ32QsA7vMtVVeTHuihUMPUmmLDyDmSp0qq8Vdn8maIOeYGUcxAYBBpVQ0V3fmyFpMw9h5pTBA1qGxFyELsYwsUxU7KMin6D8mpQo1q9TAwL801sB6UaY19rOABgf9ccKhGHbP4ZskVI63fP/VnYck4OrPpvRV9SYB+mztZYd+uCT4XYnbHLJfs52oHO8ZTcAYzsrhX9eqk06Ty9HDoTDN2aY3/RbCRvFzy2eR3miosdrSPWbuqI88Ro74flpH3IgBlc6ISCquQ/fqSoPQzsfstohk7DTqWvUsnQDaQCO1Uyx8HjJKxpcPFDz/I+/6Ovm4S8sQ/gpVFQvJhPDwFuAdylHgeu7JF9fjbHDD5FtEsmHOLZkoQwwSbm6EHINUMFk+tdwqiTYwMWuoOpHHAns3rDZWKaa9KAJTVOSk4XUXSt+zx9klzW8nfnZy5+g8CMstuQLDB3AJV6Pr8XQHaNvVvYKcK9ekFOCOkYbPMrQzQFpBDBvpp6bPffF5TKwgJ1G4wD90lh9yCwk0Kt94ZzTmxTHeHjZdCbiwf22THU9mlc4yCzINnmBfcq0TkPRKAidf3opsYPQaGfa+99Vq5VKQuriGH9NyfU7hmvO7NT9JVHzUfBJhqOmZ5qrwoa+79sHR1YPDrNT2MmQzn8YVgG4k1NdM4gbjufEcGhPrTKUdYPnFxdU7M0IVGzLYwLGP3P6L5GglsBmkf2WV3UxaQxPpV0L0HdbmI3EoZaBpHSGPwi+dm3V4OxRh+ETXHhBeDIEMzlA16Ybe4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

This series fixes memory.min/low being silently bypassed for MGLRU
during non-kswapd global reclaim (global direct reclaim and root-level
memory.reclaim).

Patch 2 is the actual fix. Patch 1 is a prerequisite: an integer overflow
in effective_protection(), spotted by the sashiko review tool, which
patch 2's new caller would also be exposed to.

---

v2:
- Fix an issue caused by non-atomic read races in patch 1 [1]

[1] https://sashiko.dev/#/patchset/20260828092432.1257917-1-ridong.chen@linux.dev?part=1

Ridong Chen (2):
  mm/page_counter: avoid integer overflow in effective_protection()
  mm/mglru: fix ineffective memory protection for non-kswapd reclaim

 include/linux/memcontrol.h | 11 ++++++++++
 mm/memcontrol.c            | 45 ++++++++++++++++++++++++++++++++++++++
 mm/page_counter.c          | 19 +++++++++++-----
 mm/vmscan.c                |  8 ++++++-
 4 files changed, 76 insertions(+), 7 deletions(-)

-- 
2.34.1


