Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8659C606A33A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 22:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=g4uMjeTb
Received: by kanga.kvack.org (Postfix)
	id 62AF96B00EF; Fri, 13 Nov 2026 17:05:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C32E6B05B0; Fri, 13 Nov 2026 17:05:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48B956B05B1; Fri, 13 Nov 2026 17:05:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 17A786B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:05:46 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D4DD120275
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:05:45 +0000 (UTC)
X-FDA: 85431478650.27.F3D371C
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id 60139180010
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:05:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=g4uMjeTb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794607543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2L0U74R9+mkRFuCmWnre9IxfyFESeJ4+6hhn8GJhTV0=;
	b=Ny3MNa34qpel71H1SympMRlIXOThzs5Bgjc3wyXTMhyu6Dp+tV1xxQSsdmKeIs90hpNpXu
	1PZa8PcopJ4X83sHgboYlCjQ7pOSv0wuuNtITozmZ2jlkYOW6fa6+xllSTRozFcCVLWu2a
	fNPp7WrDa6J4axDrlLtN9t4LFw/aqbM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794607543;
	b=01I5K8v9IOXDyu6+4875TZEMJhSVf+e61eQ9Ul0hULYfGL5BU0zd+9kqrlJWm9iwLy8pl/
	5+DTHVx5p8jMsEh9kGpuu5A0mpAmfpEoR0StmVLT+n4+rcI3w4nJqw5ZfeCIqUBVRlU8vZ
	zq9T5oTeofmxvAU/2ooVzyT1WAJxhW4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=g4uMjeTb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8b0ca1ebc8bso18878867b3.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794607542; x=1795212342; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2L0U74R9+mkRFuCmWnre9IxfyFESeJ4+6hhn8GJhTV0=;
        b=g4uMjeTb4RF3hs+vy8a8nSKEbdBt4gRX9PXsEWWcRvBbGnsxy8Kd2FHYwY+jkQZ+pa
         Cfr8F55tV9c3ADl1kJNFTEh5olLzIGaPNy/OT4c//VXFMhhnMwH9a3xZxRTXEZfoaAOT
         /t6WXvhI+K0KHt7m6ukhO4I2WfzhjIQoHIo4BwUav94bVtCG0JMS2X2grhEqcOACL6tn
         0JW2uQ8BKHTq3THgnOyRS2KmP7C3SSEXmuguwY1LDl0At8x6mTDz933yS40KSBzWf9KR
         tl1fzTrhLD9zZQWRGJV1R26gUvj6qNOrKZOEcGfhAuepupsZwC/ZQe96mVPzZ2hvk15a
         SlBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794607542; x=1795212342;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2L0U74R9+mkRFuCmWnre9IxfyFESeJ4+6hhn8GJhTV0=;
        b=A/mwozxbPegAl0ZRTk92nss3zv5XaShWhYyOTVF7l2rFoatGeC1DJN0mNoLmNIL0eF
         pFbnssWEAsIjX1GAQLvkzuHzwLbP63GUskvLY4sbm9vCVd2rv2aAUvEku6u703bJwpTv
         M3dNb0gUY0Ti6hTTN6LGA4fFjOWxhz/ZC7GIMfWeM2ItIe8mR95t7VEt6KnMnu8H+6VS
         ZGz93tNJzc/WTfPRmSrBxi+d+czUafLvEzbEoExGqetqPxrXRa13Rt1CkyLO0kuNPi6e
         PnMJQI1QqIplkmWzAmBNQ6MvpIVqGclqGEA5QjEnCXgY/lszU6xvctpFNqVuvEjqZnGT
         0oEA==
X-Forwarded-Encrypted: i=1; AL+hErEgbjx7qksKa1hUTg0OgEamksx8mXtYWHIFGleK2vh57VDF2nwgrl2uMmBTZ8KiBCtmcQS19i5kTQ==@kvack.org
X-Gm-Message-State: APuU4Z/hd7o3EwA7XP6cUOC7m8QBK1cy2dmOLCILV0MpSQ3jiMt/2miI
	0cpnpGILJpQqLxHoxnHgqbwujt8eUuF1ZIEr9b18xbuk7WHuXkkAELFj
X-Gm-Gg: AYBFou2sDf23FLpuKu2zhsvBnMGS8seDt4BHuU2rLeT2/v8WDlz7rqgzLCrmzIAGpjF
	bcqCy785k0k7Q3gz+KvegWSudHI96pJ1AF0XHsoMuJa7radMhCPYqpYBuVl/ozMKoXaWChnTqrV
	xYW5KvRAgFeEwf1sd+B9/i8E5gkUaapn9vEjH3MQooXgbBaKtcTFaf2U9+EfpLD0w4qnHAQVIBv
	QU7SsQGwQRUHwTcSAPj30yUErFCuG3l1kGEETMpWNxIErdPSRoGzgHYzs3e48Vgpf6AkGJK8XAi
	AqPJcxWNqWl4kxYF/4rTgL/tFtieZZw3BW73mAjn1u546hAhKGi721u+4+dvy/M8TIlvP2dELUz
	oGscGn0PqjSQ4S8lLr7Bz+5swIRSh16D0HAdGcPRmyregQRm8CfVsthG+RCaxDS2g55UcNgNJ8y
	xl6G3sap0Rt5LVw7Ey4zj729FwjHQJHCQyShitJgV0srATX/PMASk4SfoHhZwpd00ay8n5rdLpk
	n6iWsaQk4vonazPEfkVDTNl2JGOd7ck0eIxfDFfABpembdMmeYl+uZZvTa2ajBkjZWUOI+zv0fr
	1yheqIMQJC1sYWS2mfs/pMqrslZZkAVkamyAiERGFxBb/yYQ7Xk6xCMCrP2OENIz5NABBM0ZeJ3
	jJWwlyA==
X-Received: by 2002:a05:690c:e284:20b0:8b3:8c44:26df with SMTP id 00721157ae682-8b4aa26fccdmr19298447b3.34.1794607541274;
        Fri, 13 Nov 2026 14:05:41 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:11::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aaa1361fsm30354847b3.43.2026.11.13.14.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 14:05:40 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Harry Yoo <harry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Balbir Singh <balbirs@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v9 0/7] mm/page_counter: move stock from mem_cgroup to page_counter
Date: Fri, 13 Nov 2026 14:05:27 -0800
Message-ID: <20261113220539.2275715-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: noe36aza1xf6k8g7g6jka9jkcsas4u34
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 60139180010
X-HE-Tag: 1794607543-27447
X-HE-Meta: U2FsdGVkX19C2k7ncT0lRPtMaNeoLdZglAJcIb9G1EufTgeTWE8va57cUGwR7rcn7b7nal3kEhfv42kt9HA52LdJ/nBCuwWCiD5rzoI0F8+9jOq/9/kaeT9+6X72qxF0ELRXnFk/VPW5qJ+hpHFXnIV1nrlv0GRjAQSlqQ21YsO1b3hUrRkWfVur0liCKsDkfdU0/1J2WhBGiIcIFnn0Rur72og9r+6x4LBiERAMSy8h5Pfilbqm4TgBzkuNDxKxUwuZPWHwE9q58JkJxEaqTn9ajW6fmrdgSE28b/AwS5Cab1ZrZNjzF3ZGyFq0bUx153eIoyg5GNr5qZrA1w8xpDYp9SQkwwu5wua6cIQJjN3NQe9Z4XaRsBqdEYBfVDQLnVGIEHyz6ZCDi/vcm0hQ1+JepsRgS0vz+1h3KdSYH3tEXkiRhuImMhnuEXjR76Wm7COY+oaY5kkakk5fE0R7wCR+73fR5hIg2mOGi0Lnay34n4PChBblNdU6K7HhqwTxhv3+BoNHY89RLaPOOcnSu8SsR9F1gDoYUUYwq4o3G7u72EA9NDaAKpctZALPeFwaLKL+vctCNeWk4ofBUh9zc3No3AoUt3umQblokE6LwuIU7gGZO7P6OwgAPu3HstqXN4DZlGSrQaN5775xrK/ARxsOQJzPx99mbmqd1I3kudGIaR8rfWri7wc5UmbIw2ZHH07WR4qqUoZ1h/jgMtAGE/FLduQ6mzalj5Xav1fzoL0aRD/I/ZscyQx3jm0nE+UNiB7HjinN002xrlQtrIilbcs3bUwNSvPyzmt9xrUePjZvQfFJfoRqaXXH8/A/Asc7OoZ3D06gfT1NMjb0702fHCV4VSetnY3sSzBaSpn8Bvl+7RNECiUAk8nVmWhVrfPWAGARK00MsGXjRMmmzBLCUqY9outBWT+7cfLkPmLyq2prTw4GEjfNyP3YT0E4KRX9Qwvqiiw9f2VAg3eF9jl
 Y9zT96Wv
 PgQTKqDRBNtZkRPB2vHII2bWUIz3ERKis2lhIsErPpMPkUCfA7OgZa+3yzX6hc4kszvMvUst5tlhT2YmLGyb6f7Mb9PnuXYlGHiTIC4tjKYV/z7AtEa1F3P7arA4M4/m10N/VkvbWlowZOgRC9Uhb+u8NfqKTjTvGkEy/LLyJdGbqL9lP2X/KIjo3+GWmnmVACworx+rL9rZ6MzHk38RQz4ADRzis45G3kJXBYbT91sEh93Tfi4Yg08QjEVxl0Sa7w/b7Ar6EsjIIH+cVkDHC8CueeYgleAgUANXY1BE7ZsIA4tyk2PbgBvXNDXiP0iDgkKvXnDzjKn+Hc7y5jyP05HZyfQH4qgRjM22fw4XoeoXTvZEm6ixHebgCRb/42u6MtmpeJrs4ii7qenosEgu87je87a8MY2Fi+co1JxPgOJu7x2uC/MBREg5WxWufGLyq6MRybkZ9uRepw8nKhAZ5vqqPZcJeuYBGJwpZ2BDCylfbPzxpG+zK8xmoHOssKW2hwe2zCPbSYviHTIcL96ViDlvDWL2tKnQn7x0PKuyfvb7ZHmUxdIxOAluT1S9CnHK3TFeQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

v8 --> v9
=========
- Rebase onto mm-new as of 11/13/2026
- Fix draining issues raised by Sashiko for 7/7. Drop the lazy drain of
  disabled stock, instead relying on slot ruse, drain_all_stock, or
  CPU hotplug, just like any other stale stock.

INTRODUCTION
============
Memcg keeps a per-CPU stock of precharged pages so that small and
frequent allocations do not walk the page_counter hierarchy every time.
Today, the stock implementation lives in memcontrol code, even though
the operation it caches is a page_counter charge. This makes it
difficult to add new page_counters to a memcg and preserve the fast path
behavior.

This series moves the stock into the page_counter layer.
page_counter_try_charge() consumes the stock, charges a batch to the
hierarchy on a miss, and refills the stock with the surplus. Memcg no
longer manages the stock in try_charge_memcg.

So the stock keeps the existing layout, which is still a per-CPU bank
of 7 slots, each holding a count of precharged pages that it hands out.
It maintains exclusion using local locks on each CPU, and for remote
drains we schedule on the memcg workqueue.

This change gives us the following benefits:
- Separate charge caching (page_counter) from charge policy (memcg).
- Makes it simple to keep stock out of interior cgroups on cgroup v2.
- Prepares for future work for stock improvement, which can now be
  isolated from memcg changes.

With this change, make sure to preserve:
- All locking behavior is unchanged from before.
- Non-leaf cgroups do not hold stock. Specifically, their stock is
  drained when they become a parent, and remaining stock (isolated CPUs,
  concurrent refills, etc.) gets drained just like any stale stock.
- Exact charging for non-spinning callers.
- Stocks only exist for the memory and memsw page_counters as before.
  Other page_counters (swap, v1 kmem, v1 tcpmem, hugetlb_cgroup, dmem)
  don't stock as before.

EFFECT ON CGROUP V2 USERS
=========================
Currently when a cgroup becomes a parent, it doesn't drain the stock.
Rather, it just prevents new charges from accumulating by nature of
parent cgroups not usually having processes. We can do a little better.
When a cgroup becomes a parent, schedule drains right away, in addition
to making sure parents don't accumulate new charges.

Note that it was possible for interior cgroups to use stock before
(reparented objcgs, swapins, etc). We remove those to not strand stock
charge in interior cgroups.

Everything else is preserved. We preserve all draining, refilling,
and (un)charging behavior, including the uncharge path's refills
and direct uncharges.

EFFECT ON CGROUP V1 USERS
=========================
The memory and memsw counters now have separate stocks, which can hit,
evict, and drain independently. Their raw values can therefore drift
apart by the stocked amounts, even though every charge is applied to
both.

To preserve the user-visible property that
memory.usage_in_bytes <= memory.memsw.usage_in_bytes, the memory
value reports the smaller of the two values. Both raw values are already
upper bounds on real usage, so this stays within the fuzz that
usage_in_bytes always had (and this is also already documented, see
section 5.5 usage_in_bytes in Documentation/admin-guide/cgroup-v1/
memory.rst).

TESTING
=======
This series should not have big changes to performance, so I ran some
benchmarks to verify that. I did testing on a 16-CPU, 32G machine VM.
I ran repeated anonymous memory faults and MADV_DONTNEED to measure the
CPU time spent per page. So + number is worse. I ran each experiment
5 times, with 4 workers.

+-----------+-----------+--------------+-------+
|           | base (ns) | patched (ns) | delta |
+-----------+-----------+--------------+-------+
| cgroup v1 |     890.6 |        901.8 | +1.2% |
| cgroup v2 |     893.5 |        902.2 | +1.0% |
+-----------+-----------+--------------+-------+

Joshua Hahn (7):
  mm/memcontrol: flatten try_charge_memcg control flow
  mm/page_counter: introduce per-CPU stock
  mm/page_counter: make page_counter_try_charge() stock-aware
  mm/memcontrol: check PF_MEMALLOC after trying the limits
  mm/memcontrol: move memory stock to page counters
  mm/memcontrol: add stock to the memsw page counter
  mm/memcontrol: restrict memory stock to leaf cgroups on v2

 include/linux/page_counter.h |  35 ++-
 kernel/cgroup/dmem.c         |   2 +-
 mm/hugetlb_cgroup.c          |   2 +-
 mm/memcontrol-v1.c           |  17 +-
 mm/memcontrol.c              | 435 +++++++++++++----------------------
 mm/page_counter.c            | 227 +++++++++++++++++-
 6 files changed, 429 insertions(+), 289 deletions(-)

-- 
2.53.1-Meta


