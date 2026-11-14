Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1AFB606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 00:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eoJ+YsJP
Received: by kanga.kvack.org (Postfix)
	id 033CE6B05B1; Fri, 13 Nov 2026 19:29:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27EF6B05B2; Fri, 13 Nov 2026 19:29:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18F06B05B3; Fri, 13 Nov 2026 19:29:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B402F6B05B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:29:55 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 420B8140181
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:29:55 +0000 (UTC)
X-FDA: 85431841950.24.5D84257
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf12.hostedemail.com (Postfix) with ESMTP id 811A840004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:29:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eoJ+YsJP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794616193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Iq2xOf7brzRimqeh3kCSIQaM8aaawwKdufuiU04kk44=;
	b=WVgjtr5t2+KYTCaFsnFkiK5+5UhG0oq9J21rwIjOAIpvZPq96UXwKcIqI34Jcu7gTv1+lW
	fTmG6dCz11KgENRn1VQ3IEFSiinatJFJThnvdIJ6XUPlBzn7rwr+IbMPxZDaDSQPUZS/mk
	bnlufkOEbyi080oIe6SEcWxSc5THwGE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794616193;
	b=LbuYuIY9G4IfeY+U8Lt/6ffNjhxCG4vV2in6MT2QoCN9Dvkw9OxdYaj1BPYQZYrAHLOjFC
	T65Eo5b4b59OXjKJgSdv3JkQsLAr6GmVf5ALKsYMX3Fu34hweJRfYt/szwYXWVIN7XCCMK
	QuUwGTezjtU1URm7tRHE9YBVBMJp3TU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eoJ+YsJP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-67c6a0abc2eso1829823d50.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794616192; x=1795220992; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Iq2xOf7brzRimqeh3kCSIQaM8aaawwKdufuiU04kk44=;
        b=eoJ+YsJPlc+T4gRfIthrMZcKJSFjoa4fswkeRrOV2pmdZKDmCvmH+ykcA4pnwLUd7g
         JOKV8htSko/JB/huzgnZCTG7mLkHa3rFH5wjblfdWRGCeAzaSPvf1mwYigGwSHm5y1aL
         BkhrD0o+YpNCXyp7U0eQE6EWb7kRICDw7Hdo94reEZ5m2L0j+IWmI3nHpFYOZO3JWVNE
         o+2+10DCNSGygv4TZmf27t0YeCu+2TENLpZ5EaLFknF3iWVNVzfBcnQ+cDKDrXAwtU2Y
         ptinR1dd4xiFONExI0lOOowH8B4elrRnHM8KRwG1M7Geh8SNgp51w/V0DtIZmfbRQ3+J
         TVjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794616192; x=1795220992;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Iq2xOf7brzRimqeh3kCSIQaM8aaawwKdufuiU04kk44=;
        b=syr8swQxPaTx3yyo/20Ws57vBhvGb+p8nCyoLWiOoiQSPXjJ+BmP/3YJs2aaWLhLe1
         wdr5z8A2wt9qKfbFA27O4tlqmz4YHQ0yYfhXBp+rQptbmmmvYsR4uCSULqGcnVnFk/iH
         ooH5UdotUNfBSDNFUIYeSGKWlWpwfi13T7yYLmoIgaRBkAc3UkbcsDom2q5eIR7EPYNV
         QRw1P58DPOLKx8OwlF6enpw82VQPS5xPXhoInf+IpEtpiXA4ivPHlPR65ltiQEkkzLTZ
         TWTJMbXPDgyFkhyE1dotQBCC3bv3tj60yeTkbiqqr68iQJborzy7W/92EpfkggvP5j/A
         Kbxg==
X-Forwarded-Encrypted: i=1; AL+hErEdxanD8+IlnrCUjD7iMmwcuHlSLzv5rbo/wrXVx8Iwy+PQOhKarPmmSCnTLswPO/bEnyE/iyfedA==@kvack.org
X-Gm-Message-State: APuU4Z/BBnzlg0XAggAogyPP9Zl2Xy8shGfw1AecUwcS5s6j6uDS1bxP
	3AvbqS8/BoyXB0GgrBgUoHQa5jOebA/p6Kldb4IAbbU2MDg6/5OKAeSR2SvxvQ==
X-Gm-Gg: AYBFou0ed4YO22I7ZiF3BlzOvVsMM7BdaI+Qs4g9lGF7U3hdaeGRojekOXRzCZHCIgM
	qQjE56q9ZXDa4Rl72HZmxMD5Wngq1F5VLqCRnddj7BRn3KyS2Hv28kfORjlB7uaGMAsMLcofW+H
	zHZZG0QVFTn8wWzoj2aE4dsMgzXa3yrOziGCz7EiGMfIVw0YYDxsNbXhHvkzt682kwz27T8bXCe
	gQeyqmYR745xz1HubGNQ5bBzTYLEpVE/NgYC8Z2rNALNBpwxw00g8I0mh35OliOcScFc6yN0Ifj
	Qkj5/tSkEgiJkXYn4Vpa8IWf69FpxaX6vB7v8VTxDK0o5IfWNXfcW+3YTMBOrJ2xHZ32NH4dIXD
	nBxSKHV9AC01aOYjW33AXg8/CSw7uAzZ6XE5gsG5I5+a3CPVy+Jidmgksz/IQMWdAnzpao9TkpJ
	t0LvU9l8YTc1Wy/Zd8lWAQ8MSqlVCfBxicAkv7mN/GaORUC5CLu6RdXF7vV959CQeGH5xbSda65
	AKJCaY4/izDsFUk+/l3a9f46/haadVe58IB8hv6Wl5N6CZ+w8iOaiXKUhyMaXQAAQUagTJOHXXq
	wwAl9lSUBApxk/YmZ9lqXvnLht9/ppnUlBThVK4fA0Th/FLKRkFYqJYoD9HAHDwTn45mBOcJ/xf
	v45ndh3p1WcxPj4ArP1bwr4gnffM=
X-Received: by 2002:a05:690e:b83:b0:67d:9d2b:91b7 with SMTP id 956f58d0204a3-67d9d2beba2mr161001d50.93.1794616192402;
        Fri, 13 Nov 2026 16:29:52 -0800 (PST)
Received: from localhost ([2a03:2880:ff:59::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67d8a59f1afsm3447586d50.9.2026.11.13.16.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 16:29:51 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: yosry@kernel.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v3 0/4] mm: read root memcg stats from global counters instead of flushing
Date: Fri, 13 Nov 2026 16:28:18 -0800
Message-ID: <20261114002822.1043378-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ibn1hsstxidrj4em6qhejppg5da5ze65
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 811A840004
X-HE-Tag: 1794616193-270292
X-HE-Meta: U2FsdGVkX19oN0j06E4ip0kMefCr4j8zTG1fOYXJjgb0ALNr6jrFLB7NsqkYkIyrFeI1LbDDrSuh14HsM/JFSTxCz1vuk/IB3kvDOtBPuYtgoAkhedEpC02/f2OSIdH4cqGzBSy1gHDMM4nltMhgnOKbHuHff9DyOoCM2/C464Tqc9Oe3W+DT8weQQ360Hn6loUe5jzxFTQuu97QnxyQ9JPdgFWqjOmqZsRqlGHnyQa70bcRzZ5spMMbopINFxxUFY2UJjcJaynoMVj4+nN/M98smxU1aPv1tMNHuZoQhknhWPkmPPz/MQE2KQFpi9mKKtSBWhqPZ0/l1fpzXm2bofqi4T47h2WTsOMdw2h4DtkhHtYd5HiovpX035M9FUzX/zXj1G/Ve0otGMwipDHkZCf1duRqe0y0N+e7vJiBnBECyEY1AJaUmVPQw4sPJ1bLVt5qtDziri9WB3HkxYb40oVAULGk97oyl4cE1B+IKNfZlP/3O802q+d93cUHFLIOBKyn5cqUu+si+gy3X1NrTyARbtp4IQbiNL6HVtQXKHfnN+2PYglt1TRtJsWiepFePLpSHWtlROIgJPt302YLsXSUbdJrTh+ZWaHBiEjaOSE/SDDvmYXYMsiBcp1GPsUW8rHdw6l+35CLzPLWV/mcWDhPYxtUJaP1djO7WQQl/J0Hg39bO6GY42keJ0JulKm9W/nQok7Px3HYG9y6Fvdwjup8kEu/8jmnEBUwK5hBKYOeyuOyUSUun+tRNxhMXoXz/RfcX8L431O8dWaJp3hp3tNlaWdte5M5BZK4a6nb7J+km17zNNui9hxF+8uwQJk2V8YhFzYCji08JKMqRx1H0YKYJXAXALPudAZsRu3Azd5HqlHdHDYTj0x5HoQNoTtyHr4ldJxXxtvz+RraOKpNz1vD5dXRDDDZzhuLrWUJcTTz+FhUl4pmHJib9Z4RCaSTucDl25M2SpzRZC3KY+i
 MDz4rnno
 tjxsPTnPvK4wKFQCTFOyfODn8wusFidOgzteqbNXIr+dQ7xXf7E7A4/KUBV5JqcC5E1kgbhuzxWO+Xzgr0GrpKOnVRkL0uFKcW9kFvEpe8uiWyu1gw/WqroYgq4y55cpcx/RiTlmMNg/LMKrooUiPiOc7Y5FzCI0OzrYe8I4PPiEPIvWrsUU5Ofa2G2kmLGCXjFD0eTrPF5q/5Fu2gVGz+Tmw2g+hX/B4g6xS7slWIbZHFdDK/Y8nkP37vqOADVID9cdo74eSZPHXrswQpKXEkvmEylsKQe0U4OQn5aaDHJnhbcka4Ctwn/KoaRBVTGG5/e63+lyIiXygdkemRIGSvgQZ3mqdmyyoXs57MN+yhw3Fx/B7yE+qEq5QgOgZ+BDUglVAGNptlncUMAeqqY3EIri/2lgBJ4Dq4fwmwbavvw45pvFklhh2weD8j0i2jluNUtTS6FQZkLPChbc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reclaim, refault detection, the zswap shrinker, and DAMON quota goals all
flush the memcg rstat stats before reading them. When the target is the
root memcg (eg global reclaim), that flushes every cgroup in the system,
which is expensive. Most of these flushes are ratelimited today, but the
stats they read can be stale for seconds.

For the root memcg, the call sites can read global counters directly
instead of going through rstat. Global counters are always up to date
and don't need flushing. For stats that only track memory charged to a
memcg (eg LRU sizes, workingset, rotation, and reclaim writeback
counts), the root memcg's hierarchical value equals the node counter.

Of the excluded stats, kernel stack, secondary page tables and
WORKINGSET_NODERECLAIM only differ from the node counters because
accounted kernel memory allocated by tasks in the root cgroup isn't
charged to the root memcg. If the root memcg's stats should include that
memory, then those could read the node counters as well. This is left
for a separate subsequent patchset though since that changes what the
root memcg reports and needs more upstream consensus.

Three root flushes remain. Reclaim also reads the stats of the child
memcgs it scans, and count_shadow_nodes() and filemap_cachestat() need
the root memcg's own (local) stats or the stats of arbitrary memcgs,
which means global counters can't be used as a substitute there. This
will be addressed in a subsequent patchset, as well as getting rid of
ratelimiting for most call sites.

On an 80-CPU machine running proactive reclaim on the root cgroup, a
root flush took 69us on average with little cgroup activity and ~0.9ms
with 128 memcgs repeatedly allocating and freeing memory (wall time,
including waiting for the rstat lock). Reading a node counter doesn't
add any cost: it took the same amount of time as reading the rstat
counter (~150ns, which includes bpftrace probe overhead).

For more context on the background of this series, please see the
discussion about memcg stats flushing in [1].

Changelog
---------
Changes since v2 [3]:
- Change from denylist (patch 2) to allowlist (Sashiko, me, Michal)
- Add SJ's reviewed-by from v1 for the damon patch, which I forgot to add to
  v2

Changes since v1 [2]:
- Read the node counters for the root memcg by default in
  lruvec_page_state()/lruvec_page_state_monotonic(), with explicit
  exclusions, instead of adding lruvec_lru_page_state() helpers that
  callers opt in to (Yosry). As a result, the root memcg's memory.numa_stat
  now also reports the node counters for the non-excluded stats
- Split the workingset_test_recent() flush skip out into its own patch
  (patch 3)
- The DAMON patch (now patch 4) only skips the flush, as
  lruvec_page_state() reads the node counters for the root memcg
- Rebased onto current mm-new

[1] https://lore.kernel.org/linux-fsdevel/CAJnrk1aHdBm4CofvKfx7B3H-uF2xRXZUQs47J_4xeRmRZ4hcZg@mail.gmail.com/
[2] https://lore.kernel.org/linux-mm/20261102225030.2743129-1-joannelkoong@gmail.com/
[3] https://lore.kernel.org/linux-mm/20261110015321.611093-1-joannelkoong@gmail.com/

Joanne Koong (4):
  mm: zswap: fix shrinker count for the root memcg
  mm: memcg: read root lruvec stats from the node counters
  mm: workingset: skip the root memcg flush in workingset_test_recent()
  mm/damon/core: use node counters instead of flushing the root memcg

 mm/damon/core.c |  7 +++++-
 mm/memcontrol.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++--
 mm/workingset.c |  5 ++++-
 mm/zswap.c      |  7 ++++--
 4 files changed, 71 insertions(+), 6 deletions(-)


base-commit: 31a696f9c37defab0f28f774e00ac7f135889ec3
-- 
2.52.1


