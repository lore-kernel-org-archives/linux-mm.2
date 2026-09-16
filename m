Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77B18C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 21:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 255F16B0088; Wed, 16 Sep 2026 17:05:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206D26B008C; Wed, 16 Sep 2026 17:05:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F6A96B0092; Wed, 16 Sep 2026 17:05:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAD306B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:05:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 62270A3DEE
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:05:58 +0000 (UTC)
X-FDA: 85220857596.27.FDDC43B
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id B11D840005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:05:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LqoDkLMS;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789592756;
	b=ycPhwDDnXdRQjaSQ05Yz9henz5PyUZC+n4NQKtjpWMeIdzlFqFOOfIn/2IagtM665IHmtt
	UEHwzs0xvU9sageObzHWugMA2MQtGecCPzlgaRoEt3QT1dUYW90nPZHxYKp6/P8cUzNo6a
	t2uhmY1OkZZXMjd6yx7Brh+wdH8e5+I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LqoDkLMS;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789592756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CrpLOTKNk/9YQapYhhYSJLfsas1NK9k/H2Cz4g1H2bU=;
	b=q5deMv4ZsdxrI9KFBWm/PbocjBpIpLyLpFs2hxStO9IRqEyB7f3ntSvc2LLQV6SlaWgxMs
	5XtrvMF3LxdytJZieb7yGzeX2s6LN2S6hSn1M2Yr4fqes9KaNomfy76Q/gpgX8yhSwzw+0
	MUc5kG45lYyjiXRBYU3h+SBRF7w0R9A=
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7fccba9c675so103228a34.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789592755; x=1790197555; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CrpLOTKNk/9YQapYhhYSJLfsas1NK9k/H2Cz4g1H2bU=;
        b=LqoDkLMSSOQpygel6HrpjYwdylyDAlT8XISn+KO56V53aIyiQc3+njCsJzkHYPDvMx
         NUSEDtP6HSh9kiHHe3V2NGhyNZXhL6Ke+2dmFiM1HFr765jAXYVsFTi+FcjzaQbJY8rh
         /wYKAJI5zC6uT7SgABHsaqJP2PS2sVzjg4eaiXarTMVTqL3kB/4QBZTUhv3jIzc0GIQB
         240G+FJ4WtzSDO2cMWxsEiIrlg3xN50lM9ylcW9nIORF6WBjsOMjZhLA0Hscs08lye93
         I9xYNHMtdZrwq185ZLbBueVHh8qB0uKG8k223oGxHtLViejku3fKgu9X6bG8FwyReA5R
         KqAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789592755; x=1790197555;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CrpLOTKNk/9YQapYhhYSJLfsas1NK9k/H2Cz4g1H2bU=;
        b=BLooMXCm+9KsUoCnt9ExVDFGfTdlIvB9OWhwiJLDYGJT4sr1rKXURoMNu/iL6PnkP0
         Nt0fS0Q6ycVATkKOUM77yyZEqKxK6V6/FI0UfvY9HzBL88Ww0+ZBrhOQ2EHggZl0N4By
         D+UarxhNrxlLC2iyU/8HMOUkDQSDldV4cqt1QMVOiAEu5veKZQEc616vBe0rkfnfS3CV
         xVFjXXue4Y/mHiW24ckzX1eL5elbXimAWhIJWbjRfuxzBU5wnBvkG0s4gp0wgZs3Dafu
         ANaZsGni7sKod3LUsbWZ7x+y+exvuigx8R+cJW0jsggeh/PivF6nqKZ/720VCRiy/Vlk
         EEcg==
X-Forwarded-Encrypted: i=1; AKwUvBzzzeJuqN96QazKd8pBbkFM83VuOzWIIRbK33WYz/RTuaXZhBVM147hS6x/vU0LhXjQRBtVFpoOgg==@kvack.org
X-Gm-Message-State: AFuF++mH13eUNTfi1finBkIM+QEq6B9J/RcO1cBZwDPjeH8vY3iuyUes
	M58IwTry7APfyyOhz9JT40bsKpwMw7BLrjUydB/HmmCoqcIlGBtXDkTX
X-Gm-Gg: AYBFou1Am4o5ZmLtfDQYmF3MnQMpmqvE5AsrC2fKz15BeKjbciYOZ9wyFv6zc5BUwMo
	xAx0eTBmUVByosFUM2PRejD4Wmm27XDriT/fFYofq5OXqd5TCiNMRMpgezobIJNnKZOTCfxgFNo
	JklMjyKyWxP9bxlxOC+GaKo8Al7jcxME7JWg3xvU76d9AVobmHRRHXvaGjoUbxndpUI5ziwGEFw
	96bGQwQ0CTbTzv+4x2DmyPK9bexIlYXZXKwuQpzjNZNDa6zzeXZ322ILNlpm0CFDwPNCQo1AIwK
	4upxrAuzvT2zJNEbpLRVoopCCPnlNPrpjckIPkwfVC9ewnUWPJPGyrJQcgb3oSoodJ15I6rshH/
	lNebC5JSABAZY2AMMwS/gmmncdDSeukMAWeZkakNZ1Gc5m46notR5n42vy4FIGLTIZ0AjptAHj4
	t6ibCVYBvpjaCQ60Hx98rXKoHJrYOrdCrT8VeaX1pRgnRN2mfVAVzT95/R2f8fypzGbmwCpBXQg
	JWFH4/8gWl94de0Si+fRLxnAZ9s
X-Received: by 2002:a9d:64d4:0:b0:803:68df:7827 with SMTP id 46e09a7af769-80c4ef2087amr659287a34.36.1789592755475;
        Wed, 16 Sep 2026 14:05:55 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:3::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-80c466a74d2sm930485a34.12.2026.09.16.14.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 14:05:53 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v6 0/5] mm/page_counter: move stock from mem_cgroup to page_counter
Date: Wed, 16 Sep 2026 14:05:46 -0700
Message-ID: <20260916210552.891730-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B11D840005
X-Rspam-User: 
X-Stat-Signature: iq5o418gupg3r8kaweaxpiorsmjob4sw
X-HE-Tag: 1789592756-616744
X-HE-Meta: U2FsdGVkX18gI0waoRndqqcQYmw7/WBZ+HK5weET16L4bhvo1Knh7yer0PSCCPiYfBfjqwiI7nClQMa2jZa9+Ra5F40n2VZUuAeHVZBvE0X0F8VnbI2GM7F4KLQOcnfvITmtBUTrI88orCwzW/VWnZ1J6HdBlJDGLfWvLO0i0qJ/2/DfLUsjVCk1WM0TUJXaEW65uDn/WYOKdkz0bbbQmdapQTYfuPQs10QL7lw6G/0JH0Su50okpm7t3toDQ51q2ibUXQXDMgEUmjqehKnSOMKtQO0AD5tNZsjlO702ttlcPwQF0HBhy7ZnNRKsGF+QvcMfiJrFODFkklgDBiFzayl8cnmWvJxDUyCFCmpk31YYN/ooWrDaAhW6PFFYWX8pZorYo1lvdwhShHdmyD7BeGHmQLALcCIhugf+lQk9e9NdkcO5PPGKWTi8n393b0jKj/xA00bRy//7ffJx67nvXID56qcVnw9VrnpemvV4wrHt0zRQxugRMf0YcefmBRDa7iqiVL/rI08bWFDVxlYa34ywDbWg0aO5D/VjDy9msOfp3UkUdKFPyU6f8wj9dOZn0A7KP2yyvH5yjP9Gyhj5fP6b2vaINaOhVxiv6QEUqsc0i43cs+Y4I9Q1PyrOw9z8AiUIGzHusgqVQqjVCADOWNqifC+7LIyIicGfiL8Cj3d9wZFbROwgPkxCoHS88DVw4DjSeXXF+bWIgbWz4Twlv7b6MXt2XgINVnO2jZpZO896c4ICu4WBR3luu5JTq7b1pgOT0jEnVrCkSapoaEdWij46I3bHOwvYuyB+KE5FJUbNCSQDoXrur4EB4gOEw01uaJ2qNkj5qbBA8/e2KaaDlX9Fx7FNcabppivWIQPgU4x/6vyBAbS2fPIHTruxq35Zvr1ftvQnmZK9IdmA8KVEN+621GYdcjh5l7+NRSTRLkNbPYOVyURNWROZvbu/1Cr/6lGrUKJO3F523hUHafq
 wkd7WtqD
 dY26rsGCJYWjQBddQLuCcGeKu8Pc3MO/ja8UWkpBvOVhBqvTm5vKJPibsJEHMYsLz1PvpypG/oMyWDBpWQBejZhj5b6MBcVZx8RQD0umON4pfLg20b8CMJT8sxKfaslej251XgmkziCNVu9cMB6OWyyTM12f6CDclX00wpfCBvPL2/I/YKwvHnc/Kp/5gK8G9EsxR4yDWjcFLeixaIxwHPf7C+YVyVugeF12f+ZVTISpyyxPB30fR4zs80hSsM9ohEb7DdNznyD9JXuu/UlGh4GW8n+VHMXLmQ41OPdAtFf1Hv4MeAUVgsXcPMDpixndsmaTHNlZclyAE0WCzzMPZ7RdOMnm93qIp7jVjB5sApiqUz7VjjeCZ+FUPJwAguIgc9YEQTn/6Z5UEOjzywA+soA0Hf3Zo3h/dE6tEPsmNfZ1sX9sMY4mQ+bKRTqcdiVRxOVPB27tQOCwbuybrTqtRuQwY5jbpdxJqaBPYph+bTC+5H6+3nP0INqBOYuGvAyS+TfagJlChBqUQhIYBZ2veEW/jm196y7acyFZV5p9bXGPgqou+uzeC9Als6OFYIBk1600zI+/x60Ae6sA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v5 --> v6
=========
Following feedback that v5 combined the (1) stock abstraction move from
memcg to page_counter and (2) changing the allocation / draining
behavior, v6 limits itself to only the first goal. It retains the
existing seven-slot per-CPU design and drain policy.

INTRODUCTION
============
Memcg keeps a per-CPU stock of precharged pages so that small, frequent
allocations do not walk the page_counter hierarchy every time.
Today, the stock implementation is within memcontrol code, even though
the operation it caches is a page_counter charge. This makes it
difficult to add new page_counters to a memcg and preserve the fast
path behavior.

This matters for future work like my tiered memcg limits series [1]
which introduces multiple new page_counters to memcg. Without making
stock a page_counter-level property, it means that every memcg charge
now goes through multiple page_counter hierarchy walks, instead of
being able to cache these charges.

To make future page_counters scalable and performant, move stock from
mem_cgroup to page_counter so that each page_counter can opt into its
own per-CPU cache of pre-charged pages.

We get an added benefit of simplifying try_charge_memcg code, which now
has all the stock management handled transparently within the
page_counter layer.

EFFECT ON MEMCG V2 USERS
========================
This series has no functional changes intended for memcg v2 users. We
preserve all draining, refilling, and (un)charging behavior, including
the uncharge path's refills / direct uncharges.

EFFECT ON MEMCG V1 USERS
========================
For memcg v1 users, the decoupling of the memsw and memory stock means
that each of them now manage their own independent stocks and can lead
to a different size of precharged cache for each.

Cgroup v1 has an invariant that memory.memsw.usage_in_bytes is larger
than or equal to memory.usage_in_bytes, because memsw is a superset of
memory. With separate stocking, this could have been broken in scenarios
where the memory stock is bigger than the memsw stock, leading to
memory usage appearing to be inflated and greater than memsw usage,
even though the real usage preserves the invariant.

To prevent this, report the larger value of memory and memsw
usage_in_bytes for memsw reporting, so that the invariant isn't broken.
This is a bounded stock-related overestimate and does not affect
limit enforcement.

Based on latest mm-new as of 9/16/26:
892f5b3b07e5b "mm/swap, PM: hibernate: atomically replace hibernation pin"

[1] https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/

Joshua Hahn (5):
  mm/memcontrol: flatten try_charge_memcg control flow
  mm/page_counter: introduce per-CPU stock
  mm/page_counter: make page_counter_try_charge() stock-aware
  mm/memcontrol: move memory stock to page counters
  mm/memcontrol: add stock to the memsw page counter

 include/linux/page_counter.h |  35 +++-
 kernel/cgroup/dmem.c         |   2 +-
 mm/hugetlb_cgroup.c          |   2 +-
 mm/memcontrol-v1.c           |  12 +-
 mm/memcontrol.c              | 328 ++++++++++-------------------------
 mm/page_counter.c            | 209 ++++++++++++++++++++--
 6 files changed, 334 insertions(+), 254 deletions(-)

-- 
2.53.0-Meta


