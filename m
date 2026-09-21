Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27F37C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 06:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7FE6B00DD; Mon, 21 Sep 2026 02:16:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CEF56B00DF; Mon, 21 Sep 2026 02:16:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50BC56B00E2; Mon, 21 Sep 2026 02:16:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 25F0F6B00DF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:16:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9A5E1C056D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:16:36 +0000 (UTC)
X-FDA: 85236760392.29.54A234D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id B3B01140002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:16:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="arr/3l/7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789971394;
	b=0oxTAol+Xi82SzRfya/TVCtvPn4oZ/D83cYF8xUzgdaCG8nT2f+DtQrYpD7+pCR5RDCGHv
	Dw3wpi0aqGcskt329uwTagdNaxuFV8QnN5Q2bJXwXJ/91dsmOvocuQhI7xe3BIOahwmdoO
	mXwKZEhVeFoaLVh/ZRKzgSu58teMrlk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="arr/3l/7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789971394;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dHJxYyouAk18LG2px+LC4C64ebXS3XCKpMThk1mWwRo=;
	b=n1hagK6z0WlFImrq/RPTD2KdleHE8MdQKJC3RABGtqkeva66sXgpTmAVP9BoHPt+OwHzw7
	2w7wBPR4Va/psnLuT6ZjyNu4wsBt0GLW8+6v1rLsKxOGisn3/ZMEJMLI1suhM5DhfRPF5h
	YQ0fnrqyVz35aXhbbZLCvgiU64jqQrk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 52AC1601F0;
	Mon, 21 Sep 2026 06:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7062C2BCB3;
	Mon, 21 Sep 2026 06:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789971393;
	bh=6MJxPjqbgb7Y/VEHgxJibzuGMSiGTlHjpPp7ebXihAI=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=arr/3l/7JjqQDfbP6AjgzUB5eCnkfAd4OIFidWwe6EjU/vnlLaOyO6x4UJI74xXZA
	 sFD8ECSyUJ2k5mMV4JmNFuRz/Vp+YA32hAa7bhD7TxYCQNVq2YWOEfKmI5hyMq6MTo
	 gioFnoTlCqZTwmPWHAsHOoh22El8u2UHMXjZ8ZsFI7Pq+OapElBbogD4f7fMM8IN/d
	 owPDW7TYzRWgIcj5SCgaussS164qoo0vqa7j1YdAsaB6xm9t58Gf/MbQ99fpOUUUCQ
	 dCqGyfy1Rqn4mNoiZuxoXSYnH7Ia8eW/P7QhmGPWIwKp8p5N6+OcsxKJd+MQ8aZ5ng
	 ygrYfL7CJNuTA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1787C982DE;
	Mon, 21 Sep 2026 06:16:32 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Subject: [PATCH v2 0/4] memcg: move memcgid refcount to objcg to unpin
 dying memcgs
Date: Mon, 21 Sep 2026 14:16:23 +0800
Message-Id: <20260921-bingfangguo-memcgid-rework-v2-0-6c0637dc0edb@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALfLsGoC/33OwYrCMBAG4FcpORtJptSMnhYEH8CreGiSSYxLE
 0lrd0X67kaFxQXx+M/A9/9X1lMO1LNVdWWZxtCHFEuAWcXMoY2eeLAlMxCwEAiK6xC9Kw9/Try
 jzvhgeaaflL/5skaChkyrW2AFOGVy4feB7/YlH0I/pHx5dI3yfn2yS4mf2FFywRutXQ0gLKL7G
 igaisPcpI7d4e1mXY3wAgr5EYQCIlmrnGoVNPI9+LIQZf2HJH00/jkKawvSLLDRSv03pmm6AWn
 jPadbAQAA
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789971391; l=4662;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=6MJxPjqbgb7Y/VEHgxJibzuGMSiGTlHjpPp7ebXihAI=;
 b=5Q7x040B0vUoB3GYgoqElocEo3xrwnGVk/iMGoohpF+TahdOPrG0amEOKcw9ubP44iLWxwITD
 E7hGSZoG2lGBt81pbdcPmQLrg8Az/uTwnuMmf9i08Y9/zUEWeKSZz+H
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B3B01140002
X-Stat-Signature: ewfuz7g8f934pgmc671hwbd9zppwk4mi
X-HE-Tag: 1789971394-289404
X-HE-Meta: U2FsdGVkX18pWmLpZNX4eYUGlAkE/YiKJkOfI2eWUoYNkSgTBBmfFmKNeBtbFV/YwfZCN9w4fvACG3xdr4h475+pqXv1bai8G0rOcD0zT14k/K/RCN7R5oYb5UKNEyoSTJb1uLqdh8/qQoX8XxxGE0jgyfTVX0nEPKHreOLpcHZKzE/dKfIyUAALThvjjTWIbHwnRT1OwA03VRftYvDqSqCcW8TiMMivRP6KRcYkzzQ6Haylt+K4gpUo09xghrGUx0V/WO9p7PIR6gGeP/JVwTTGJMsrg7r6VD0choaYePyADiVW1rW9/sNZhCJam70aEW/ZYBJxBYHYXSOoliu4o0eXEA5i0t55GJWl0nA1BWUjAwUwzUCNGQ+nQpRVmY5vT/1yMzwHlLq5h7qcVs6axsx4gT2QesbnEQ0nX68k+muvh+eb4dmY0Z03HR7oBgWAdyDAcrgBr1alf3m+e4+b6OA3c+VbJkee6/q7uBCDjYE2u5XBZp3DYLiie46GnprKr8KokWwlG4M9Y8dqwFyDpqxHdbhu+uahkMCR++MeEkOh6H8D7b4l7mwQAm5fFrTV4k+mu/VthR59BOxcU9psGyo+y90ku7eGs7cCY4FM1U+yQ1z3hm2e3XCGY0xwdIiigt+C3mpG0P+EZVxlzY/OuoYKJW2/mKeGFhbN0/FngP3jD8J/R5RpvOPTYnS4FqJqeqYUoKABdWvKxa/7NBMfSlY+gQQ6B762BQjdHCc0l/ggfVmh866SWPaEQYa1ZNuuawD+XgbjLXnMAGvjTROx4WevVyT4XvzKRsbGis6kkCHPu/UXQvSeOQVQNETTFsohvnC4MM3e+s/a5XPf/dxfr767/8ChheFPQcScsyL7/HzZdrOE/wQcTkCUCcbgeLJIrM3G2cFYAN/bE52vGKsrkaxYinymlJlf4nNkO1E4uE0Hgt8FzrsMIrumKy5N9aNvliJ7duRbz68T7hALTC+
 roIdOeQK
 AZSGGyT5IMEaNFgKn2dHKQGBPPWQpO9IL7CxNYtfixRDChoSWm30oNSge6AuFv4qKXo9NQziedYt2fpS1TzOyEladb9Ps2fx4qttCO/0tEXINJC3VYBIzgYF0FdwAA74KPupHEgTNBmI38UbjPqU8+jfYbKxcwZEFl4UZSYbPiV0YHx2BeA+WbT6/ZwIppACFU6m8MKUZ5ncudY2WB4s6rHxJ+Mq5UNvdCEqHbJYK2YQGd9bIZCe2hRrNhuq/gbcIgfw3IdT5EyZISwT1HBfFdMH7mm/auI3QQvpv0eziY+L9T/gxShp4CpTsbt2WAPUJrYsY3v68wTFD09EA6DjV5nV3QYKPV3tYle6s9N2enr4b5i+JyZAzU0c0CFtWfBH3uwp9Pt7Xs8avPXzP397w6npJt4uZV1+iblr0N3RhlVn0XMVKXIV2xro6Xw9lU64Mx0gl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes in v2:
- Remove the NULL test and use the root in lru_gen_test_recent() to fix
  the uninitialized lruvec pointer. (Shakeel)
- Wrap rcu section in the swap charging path with scoped_guard.
  (Shakeel)
- Replace rcu lock with lockdep assertion in mem_cgroup_private_id_put().
  (Shakeel)
- Keep memcg->private_id datatype unchanged and send it separately later
  for simplicity of this series. (Muchun)
- Add blank lines between variable definitions and assertions. (Muchun)
- Remove redundant comments. (Muchun & Shakeel)
- Collect Acked-by tags.
- Link to v1: https://lore.kernel.org/r/20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com

Although the dying memcg problem caused by LRU pages is fixed, I can
still see many dying memcgs on some workloads that use shmem and those
pages are swapped out. For example, programs populating logs to tmpfs or
containers sharing data using shmem.  This series binds the memcgid
refcount to objcgs so dying memcgs can be freed normally in this case.

The memcg private ID identifies memcgs for objects that can outlive the
cgroup itself: swap entries and workingset shadows.  Today the ID's
refcount is embedded in the css, and every outstanding ID reference
(mostly swap entries) pins the css, keeping the entire memcg alive.
This causes a problem: A swapped-out page holds a memcgid reference that
pins the css, so the memcg cannot be freed until the page is swapped
back in and charged back to its online parent.

The work done by Muchun Song and Qi Zheng already charges folios to the
objcg, which is reparented to its parent when the memcg offlines.  This
series applies similar idea to the memcg private ID: the ID's refcount
moves from the css into the objcg, and the memcgid xarray holds a
reference to an objcg instead of pinning the css.  When the memcg
offlines, the objcg is reparented and any remaining memcgid references
resolve to the ancestor, so swapped-out pages no longer pin the dying
memcg and get the online parent naturally on swapin.

Unbinding the ID from the memcg has three consequences the series has to
deal with:

  1. The ID stops pinning the memcg, so the paths that relied on the ID
     reference to keep the memcg alive have to hold the RCU read lock
     instead.  (Patch 1)

  2. Charge and uncharge no longer necessarily happen on the same memcg:
     swapout charges the folio's memcg, while the slot free resolves the
     nearest live ancestor.  The counters are hierarchical, and the
     MEMCG_SWAP stat is either reparented at offline (v1) or not visible
     (v2), so nothing leaks.  But "does this entry carry a counter
     charge at all" can no longer be answered from the resolved memcg:
     root is skipped only because root's swap is not accounted, and a
     non-root ID whose memcg was reparented into root still carries a
     charge that must be released.  Patch 2 adds
     mem_cgroup_private_id_is_root() and makes all three swap paths
     decide on the ID's root status.

  3. An ID can now outlive the memcg it was allocated to, so the memcg
     resolved from an ID is not necessarily the memcg the ID was handed
     out for.  Callers that need exactly that memcg (list_lru, the
     workingset and MGLRU shadow tests) now get NULL and skip the entry,
     while the swap paths, which only need something to account to, get
     the nearest live ancestor.  (Patch 4)

The series is now four patches. The first three are preparation that
keeps today's semantics while the ID is still bound to the css. Only the
last patch changes behavior.

** Testing **

RFC v1 contains some scripts and codes for reproducing the problem and
testing the fix [1].

[1] https://lore.kernel.org/r/20260813-memcgid-objcg-v1-0-83d21c685b77@tencent.com

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
Bingfang Guo (4):
      memcg: keep swap charging under RCU protection
      memcg: base swap charge accounting on memcgid root status
      memcg: manipulate memcg private ID references by ID
      memcg: move memcg private ID refcount to objcg

 include/linux/memcontrol.h |   7 +--
 mm/list_lru.c              |   2 +-
 mm/memcontrol-v1.c         |  21 ++++----
 mm/memcontrol-v1.h         |   8 ++-
 mm/memcontrol.c            | 125 +++++++++++++++++++++++++++++++--------------
 mm/workingset.c            |   2 +-
 6 files changed, 109 insertions(+), 56 deletions(-)
---
base-commit: 8d61431ed2607386b427752505379536eb634ce8
change-id: 20260827-bingfangguo-memcgid-rework-938e25ecaba2

Best regards,
-- 
Bingfang Guo <bingfangguo@tencent.com>



