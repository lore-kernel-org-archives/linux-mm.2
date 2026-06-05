Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 994DCCD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D83206B0005; Fri,  5 Jun 2026 11:36:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5AEF6B0088; Fri,  5 Jun 2026 11:36:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70156B008C; Fri,  5 Jun 2026 11:36:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B83856B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:36:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B2A7A01A9
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:36:07 +0000 (UTC)
X-FDA: 84846259974.08.815B14D
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9F4D34000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:36:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JfUTba42;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780673765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OrISvpPCKWDj31WRr2OteniiAJNmHCrQHZNb3nzP7nc=;
	b=Z+XljjkwWSIT13ctS0PcKKRu1jmoz0kOfKULi/zhj5PnvZCsU1lPF5a1nBoHUmWp/mQTWH
	3Kx0qBlyzgx4cuNJUEwDf9YTKBkFhR/tQG8fnYnzJ/wudw6ulhD1qUiynExENP1iO87xMj
	LWgaXJuv4okjhL92nY7ABZkcqJI/KNs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JfUTba42;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780673765;
	b=UAoBDhikqDz+xGyY8qkh1tXBvQQ5urYEkURurbn/oEObgaGEC7guTaOC+Q8GYIQHzTfJH6
	3EWrSnjwL4vxLuaXe4Pu2ba4xGC3LBnPHVCU2NXebtd18RKY/K7oRsrPx6PtVVtN154YN/
	vk43D86jogM+QQttKvtLqTjxJ3qXuZk=
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7e6b5e09a96so1532486a34.3
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 08:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780673764; x=1781278564; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OrISvpPCKWDj31WRr2OteniiAJNmHCrQHZNb3nzP7nc=;
        b=JfUTba42qLFJ35qh9jWkY+QqCFThangCHZ6MWW3KTj2heHgGU5QCScQFUnG2x6OUyb
         GmnNHYvzPziJopYpYK0T8HLjM0+ArP9yuBRsZeO0jlxG3bwXez3GyzjNOU6qmBQijXXf
         o3R4mpBhNGbQfuu8dud6ZwjPRzvfwisKZsVQB+eV54ZGTcXs4aLdhFdJ97Zo2AKRF9a4
         3pN6Nn6yASU40Ocmrvj808snm9cJCqYlzemu/o6iEiN2gXdGewijF/RFMuBISG8D4LoJ
         yMEpx7A/6KXC4/ws3KHJbvU4hK2HvyaiwLu3s7Bo7Y/6o6pK4bOEa/Fz4CfaUzauszs5
         u2ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780673764; x=1781278564;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OrISvpPCKWDj31WRr2OteniiAJNmHCrQHZNb3nzP7nc=;
        b=JdkcmDSxc8Aj8hZyT+uXU1IREXrvc5q8H1/sojqV3FwHGU5qeeVgpOGKxtUppGGSWB
         aRiKussCB4een9ODzqtfQ3gYTUvfxKfVJyrwQ+wd4W75A1IWC6/i5t7u8CVGWjKi8CV0
         hx2Jyalc0GGn8Xhaucc6EorccOdbuJLPhmvol2m2DaIMJ/BsLBT4DVZXijiVhBZZA8Nl
         1+NuFfGt7McqCgo21Z6Jb+Yl8UYZG+zSM9dgdpzWP4B8CAQIleNDCkSkVPZpm0d87cYN
         KSk4TEIo0A2LJIHdVjT1Sa1XgBibZS7vac2Y2FC/3qDAOX6btCXhy8eIEu8OR71lK0Yt
         nzBw==
X-Forwarded-Encrypted: i=1; AFNElJ98+tOKm+Arfhlo/2Ap+5Ef6M3j9+Ueb1bE4IkTRSI7Pt25nAro3P73T8nYhNOzJS/OLhn72nYRDA==@kvack.org
X-Gm-Message-State: AOJu0YxDFyFeMO6XwBg8PqNlgwVqPDeFLjJp+MyrN1YPII1MnXrqDF0l
	XeXCTgYEyJ7brU4dk8adIW3Ed0gJ4ydbWRAoN6hKcitSOK17fVG9sAQ3
X-Gm-Gg: Acq92OFocS2Rsg8DHO8U+Ctit77dd4D00E5Of/cTe5s1TZKySjjh7o72l+w+9jzop8z
	RXp+RXtny2+P96PEdQiK4Mwiq7MjLeqc7zkFjSTabY+cBCS5HXO15+obVw+iyPgQBSoXcltN7i2
	wwo+AkubxIexdDXx5NLNDGFWxmSn1ncmMESgxmwE7zz6M6uXXIWG5K67eWpTzrpg4qhXabtgMuU
	FdvMTFOsiju3FhwL4y7WS9IM4JMP3IvHbpH0PWvWhhMJVB75ucvPQHnzgBa4VflJ8hZby2zSR7v
	827NNOu2/Va76KyiR5ggqhHN8p16IFA0aUOvG2rX0nEAGMu2mEhbNlOPIUouuBIEi3qtmGz6Rzr
	8NSYlJPbjFP4LI/k+j73g+DZwGuxbzck4sSUxMrSryPEO00D0lA3WEiEttFABbZtvdVmKvsJ1v3
	lM6aNvUG/Lkp/kIZECkR+F/A9OAWC+GXN1SVM/iirdxNxQJ/93SURcE6hc3ye2cquA
X-Received: by 2002:a05:6830:4425:b0:7e6:ff83:4b46 with SMTP id 46e09a7af769-7e70ca5c621mr2621260a34.23.1780673764515;
        Fri, 05 Jun 2026 08:36:04 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:54::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e6e7468f8fsm6342595a34.6.2026.06.05.08.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 08:36:04 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 0/6 v3] mm/memcontrol, page_counter: move stock from mem_cgroup to page_counter
Date: Fri,  5 Jun 2026 08:35:56 -0700
Message-ID: <20260605153603.234296-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9F4D34000A
X-Rspam-User: 
X-Stat-Signature: 5oeytny1n3kfpjpu5gbctds8bqehtxx3
X-Rspamd-Server: rspam09
X-HE-Tag: 1780673765-304073
X-HE-Meta: U2FsdGVkX19eyxFDFLKuaQlnlRJc0vbGvwCdgRG12GZOx6TNkdxV0fSUq8mXl3NMAZXX9KE9zeL3MHJdIFaPE+eHk04JvydFwbbrNQZtRkXWks8aLu2GSKVuSA+EQyqlBQiBw3hNYCvkLzqO/Rtpl0helpaRLCbYO8W4IGzLzcbqE8n1FO1kIIRI3J9c7+DfXnVSRF11deecJqmu/pHF7QqCdIpk8b4tDV0TIqrayIruQLVbbvhol/7ODtlKlE6E9CUQB0Xk7/KaDj2GM1quPXLFB9WJXjQzJw2US44xpXaiXqsoWQ5WEXPIV6DOLX67jk5cDXTP8hiiaGqspOE+KKUnKcaszLAp9yi1LQeMRohvCDjjmcSsADqZpr2m43xwDlJhL/pPTtgEe6OjjdZo8cjEwjt61oVy9yEJIrCoSQsl/vhPA9ou36upXELpiz155f6xX79fwqq1oTXLCfOi5pYtjhm9ASibxFd2PgCMJa+c4J6dXhlbq3xH/AkvqeJuHGlr55+g/qFTcFc2ociF5mOdttcKnCwvZ+ICmH/ykjBiQTP7La8CZZLHNpcOzjB8pcJcNbjirWPmTYwRQIoCWx5SNn68TJ/ZzBRsM8B7hKFiaxZxwzd4JAusm7g1/PCA0rWk4r9NDgjhuvrE2pYbXqVxONw2wYBPJTL81x13es2UBCeU3pVPP8KFxR9yYsLymHzk7UWUklVo3kIU5ch9QPTu0xc3iOVg/ZWKIAjH4WVzvFThdR1IIeoH/gEfDXe3D/ynR6lK5hHIphiX3i91IWWwSnwR31c1/ATdvucyZtHi6P3XKigarMTu5qIokw/BkpC/SU2DSxrlRAMr9n+kORw/d9G+HI7jBIp6eBr4DDlic5qm62mUJenNO6QvuUSq5q9Mb5k22h3zTw5RdgvLzukDqHdsojOoX6Gy7eZmCbVsxZwiEVk3G5yGUIneQgLdKjaXqpKp93CMRCszXMg
 +VUkhEvx
 QyfoQ3/R7Z7zYX000o6KBgbjOCB2BG3JGHbaHEBFiZLKKuus1jZsWsHXxPrkqFLKC8EKbyQ4OgAQrfgQVKdzBSmAz1b1Xk2XMKLvZxeQRzPhO9LwNiCpZf+qwgr2U92ffwt97rkX9pjIf8h2iEHFiS4mH4XWRXZMKnSytH7ErnbbPThfgd9joHp+KortApZK2lShpydh22t6Mohnt44CfG+wgIeNaVdPAfmZ86fbyMJEkculhZfniKpnbGZoJ7z666M4O0hFr2jXWaen04178l/DcVm/++yQrI0kU7dnHFc6BebSaKnqiD+zUhbFMvhD8DwSNYuC7o87897agmXkburGGEQf2m/NlkLzgrid8rbnqWe1D/zb+TFi/KPy2iErjEJLi6dAWh0WBjM6vSr2S1o+pLEwOdIRr4yP25umhkcDfgvdZmsCCOMpzTj178CwAfaMgxeyKcPP3emDZMGQxcOBxm5HflwmYeybtmvMn6rbX5xdFWM+fEssCFmhLLCFlgWNAJbGUqhYYokanVVRS+iAqN5KjgioYvEMZRbJYu1YVOsQtHDhp2raWQ/Yj/D+Bx9vcMIF1Kb+XDpI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memcg currently keeps a "stock" of 64 pages per-cpu to cache pre-charged
allocations, allowing small allocations to avoid walking the expensive
mem_cgroup hierarchy traversal and atomic operations on each charge.
This design introduces a fastpath, but there is room for improvement:

1. Currently, each CPU tracks up to 7 (NR_MEMCG_STOCK) mem_cgroups. When
   more than 7 mem_cgroups are actively charging on a single CPU, a
   random victim is evicted and its associated stock is drained.

2. Stock management is tightly coupled to struct mem_cgroup, which makes
   it difficult to add a new page_counter to mem_cgroup and have
   multiple sources of stock management, which is required when trying
   to introduce fastpaths to multiple hard limit checks.

This series moves the per-cpu stock down into the page_counter which
consolidates stock limit checking and page_counter limit checking into
page_counter_try_charge. This eliminates the 7-memcg-per-cpu slot limit,
the random evictions (drain & refill), and slot traversal.

In turn, we can add independent stock management for additional
page_counters in each memcg, which is used in my tiered memory limits
series to add a new page_counter to track toptier usage [1].

The resulting code in memcg is also easier to follow, as the caching
becomes transparent from memcg's perspective and managed entirely within
page_counter.

There are, however, a few tradeoffs.

First, the bound on how much memory can be overcharged (and remain stale
as stock) is raised. Previously, it was fixed to nr_cpus x 7 x 64 pages.
Now, it becomes nr_leaf_cgroups x nr_cpus x 64 pages. On large machines
with many cgroups, this could be significant.

There are four qualifying points:
1. Larger machines should be able to tolerate the additional overhead,
2. Stock should not remain stale as long as the cgroups are actively
   charging memory,
3. Getting close to this overhead is rare, as it would require a process
   to migrate across all CPUs and leave stock there.
4. These charges are not "real" allocated memory, but rather accounting
   done in memcg; they are easily returned on pressure.

Secondly, we introduce some additional memory footprint. The new struct
page_counter_stock adds 2 words of extra overhead per-(cpu x memcg).

A small change is that for cgroupv1, reported memsw usage can be lower
than reported memory usage, if the memsw page_counter overcharges to its
stock whereas the memory page_counter does not.

Finally, to keep the above memory footprint limited, I opted to not
embed a work_struct into page_counter_stock, but rather decided to
trigger synchronous stock draining, since the drain operation is rarer
now, and only happens under memory pressure and on cgroup death.

One side effect of doing synchronous work is that drain_all_stock holds
the percpu_charge_mutex longer while it performs the work, which means
chargers may be more likely to be unable to grab the mutex lock and
exhaust MAX_RECLAIM_RETRIES and OOM, in theory. In practice, I have not
been able to replicate this behavior in my experiments.

Performance testing across single-cgroup, as well as 4-cgroup (under the
7 memcg limit) and 32-cgroup scenarios on a 40CPU, 50G memory system
shows moderate performance gains (~1%). In the tests, I repeatedly
fault and release anonymous pages using madvise(MADV_DONTNEED) to
stress the charge/uncharge path, across 30 trials of 50 iterations.
Metric here is time it took across each iteration (ms).

+----------+--------+-------+-----------+
| #cgroups | before | after | delta (%) |
+----------+--------+-------+-----------+
|        1 |    357 |   350 |    -1.960 |
|        4 |   1221 |  1204 |    -1.392 |
|       32 |   9184 |  9032 |    -1.682 |
+----------+--------+-------+-----------+

Further testing on other stress-ng microbenchmarks also agreed with
these results.

v2 --> v3:
- Dropped the cgroup v2 optimization, since it could indeed lead to too
  much time held with the cgroup_mutex. Instead we let the stock
  accumulate in the parent cgroups, which is not so bad; charges can
  still land on these cgroups, and if we ever reach the mem_cgroup
  limit, we can easily return those charges.
- page_counter_disable_stock no longer drains, just prevents
  accumulating stock. The actual draining is done in the free_stock
  variant, where we know for sure there are no in-flight charges.
- Reordering the page_counter_disable_stock path to disable before
  draining as to prevent accumulating stock first.
- Skip isolated CPUs when draining synchronously
- Rebase on newest mm-new
- Wordsmithing

v1 --> v2:
- Dropped stock returning on uncharge to preserve same behavior as memcg
  stock. This resolves some race conditions present in v1.
- Fixed many race conditions between disabling page_counter_stock and
  in-flight charges
- Restructured drain_all_stock to iterate over all CPUs first before
  memcgs, to reduce the number of synchronous CPU work scheduling
- Optimized cgroup v2 further to drain only on the first child and skip
  the root mem_cgroup
- Dropped RFC
- Wordsmithing cover letter

[1] https://lore.kernel.org/all/20260423203445.2914963-1-joshua.hahnjy@gmail.com/

Joshua Hahn (6):
  mm/page_counter: introduce per-page_counter stock
  mm/page_counter: use page_counter_stock in page_counter_try_charge
  mm/page_counter: introduce stock drain APIs
  mm/memcontrol: convert memcg to use page_counter_stock
  mm/memcontrol: optimize memsw stock for cgroup v1
  mm/memcontrol: remove unused memcg_stock code

 include/linux/page_counter.h |  16 ++
 mm/memcontrol.c              | 276 ++++++-----------------------------
 mm/page_counter.c            | 129 +++++++++++++++-
 3 files changed, 188 insertions(+), 233 deletions(-)

-- 
2.53.0-Meta


