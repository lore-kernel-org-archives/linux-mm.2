Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B59F5CCFA1A
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 12:49:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3C68E0016; Sun,  9 Nov 2025 07:49:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179D48E0013; Sun,  9 Nov 2025 07:49:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042448E0016; Sun,  9 Nov 2025 07:49:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DAB878E0006
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 07:49:58 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C69589937
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 12:49:58 +0000 (UTC)
X-FDA: 84091050876.20.880B36E
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf08.hostedemail.com (Postfix) with ESMTP id 43D34160004
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 12:49:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762692597; a=rsa-sha256;
	cv=none;
	b=tRuoaSH6sz237otK+Qliu57tvs7DgUybudzoudBeWcUdMQ5xxBQlH8duKRTadu8OwdaLHL
	8IT5ZYeey7yQ9d/EfTBf4+JpjBRNBoXsUqDjZ1LnBcvOyHFYQ+smq+NSzD7NN9xN/8Z3Ia
	BCznRnn5B/i85B0+bBwoxxWC930Q4RA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762692597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=8Lo50mQ3EmEEPm0QQk6gb1gzdYEdJtgAaz9UDW0KA0k=;
	b=hrycm/qDsc0NQZDRrwDWGL1Ef6LK0y9hKsWBGNp1o+yA7FqnqPoxrNTNye2yfDGFSUrQnT
	aI4iR4g7YKLvCyh0ts+M1XeVKH57pRqYA12brzIbifpA1Z4PhLD0kCc5aSJ/GOfH7WXRBz
	adUsajaRbjfcay+ph2BXoXBnjoJ0N8Q=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 9 Nov 2025 21:49:52 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	gunho.lee@lge.com,
	taejoon.song@lge.com
Subject: [RFC] mm/swap, memcg: Introduce swap tiers for cgroup based swap control
Date: Sun,  9 Nov 2025 21:49:44 +0900
Message-Id: <20251109124947.1101520-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 43D34160004
X-Stat-Signature: dskiaha8ywt54593s7x8mi1esy7ageeb
X-Rspam-User: 
X-HE-Tag: 1762692594-326793
X-HE-Meta: U2FsdGVkX19NhO5G2UmdiEMMs9oqlZotFUEecc/jAM78F31DnUtHLi9AVo5YvkdF2DhyxEK/ybhJCQaCmbrx/jNTi3i14GqGsjydBTP/je1y1g2JuVdbfSM52sYvkYNOmn6gkwdyQWJ6eRUrh4qkcDEWaw5ZjGTCN1STMGbadvqJt0NEO7godSE2JrLcwozFDKn5LxUF3CNVL0ubocQZ/p8crmbgIzXdf7VHKpY6k/IBm4SdOiy8ygBXlUXoRm9QogKZbIDOUm1+UMhIFxaRgJaDwmzMaFk6HUuNxPe+VyS+KsYXY4W+vmmHItiRDqGeWv8Wf2hB23C2RJr9AAdBAWCtjCaJ3DNpdW4RcOg0EFAuOV9aVfqC3psTVzH9rXXTh+TR+vylZkN25825cmxaLriaihecVHllNsBeN60ARrmtCbJio1pZ2YIxeQHQtwm5Xrp/KpA+kM8SuHvBh/igO3k2N+MpwLGRI/HjZar681SegWmz/1SiT8M5NCMkKvpPj2QcSjJ3s8H/dDzv2zA2qPEwgg/+10UqIIOd+pzVzkqnnBosMKvhkpfvNXxcq0maxhekUCtAG98MdfQbAc1E62LkhUmdbgihTQVNld8yRzDZ7nrpamRlxVHtOQcn1GXFzUF/+ZLn5/Qmi/T1aF5SzK1dQdDGfh1qahdkKSq5mNOLb4N1rC2Sin0RmKOR8yAnf8IYNvPEbj7VjdDrtPL5eZEOPdBH50C1Y/n4o1xdE1GDWF9cCqnA7SJOqahL8WDMvPlrAaiks6upP2FF8p00GOvPa5/iMDwKbWZ6yLcRzg+fKRoCsCXAdfU3FQ5FJy3l8/fYdZ92QWVoN94OUKianWiAXwOIm+5Qh0q5oL4uoYxcqDjarN3t7FIE7BfW2Ft6NgH7zT57gwGO+lnSAUYhUPTZr+wHGYWwfGKDNKWZMaPkuQFSk6VJtTD+dQlQqll1NFbon4XVT+JCF/HhdnE
 EztQxTmJ
 fjGfAKlxG1Y5r/2LcMTPScEAdcApTX75BFXeX0kqvNaAHl3XnWXlIj0ulbhMjLSnvvsF7uarOvdd8iu8a99S8q90NEHmpqoMyhTnKbK/DYu005a8l4aRqt2khU0U6V598x0noqiyGKbs+RSI7WGvAh4Y7TRhN2iSR2BJ9usV2uPNOjgPbWqttb4Rxx4tLmVY9DxIuJxYL92dkO1VlZw8TiyJOhvqFxayyALjPMOK9lxqx5WtciRrXe8FUtMO/t4+yZuay2jjzML+1SWCJPFh6wJUNkNjxKAL6fBf8hV7wQydz03ZXhOjYs3EWuV1e14kdNWaomrglK0S0D2lxkSdYjnuhjVgEpaITA4fd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

In constrained environments, there is a need to improve workload
performance by controlling swap device usage on a per-process or
per-cgroup basis. For example, one might want to direct critical
processes to faster swap devices (like SSDs) while relegating
less critical ones to slower devices (like HDDs or Network Swap).

Initial approach was to introduce a per-cgroup swap priority
mechanism [1]. However, through review and discussion, several
drawbacks were identified:

a. There is a lack of concrete use cases for assigning a fine-grained,
   unique swap priority to each cgroup. 
b. The implementation complexity was high relative to the desired
   level of control.
c. Differing swap priorities between cgroups could lead to LRU
   inversion problems.

To address these concerns, I propose the "swap tiers" concept, 
originally suggested by Chris Li [2] and further developed through 
collaborative discussions. I would like to thank Chris Li and 
He Baoquan for their invaluable contributions in refining this 
approach, and Kairui Song, Nhat Pham, and Michal Koutný for their 
insightful reviews of earlier RFC versions.

Concept
-------
A swap tier is a grouping mechanism that assigns a "named id" to a
range of swap priorities. For example, all swap devices with a
priority of 100 or higher could be grouped into a tier named "SSD",
and all others into a tier named "HDD".

Cgroups can then select which named tiers they are permitted to use for
swapping via a new cgroup interface. This effectively restricts a
cgroup's swap activity to a specific subset of the available swap
devices.

Proposed Interface
------------------
1. Global Tier Definition: /sys/kernel/mm/swap/tiers

This file is used to define the global swap tiers and their associated
minimum priority levels.

- To add tiers:
  Format: + 'tier_name':'prio'[,|' ']'tier_name 2':'prio']...
  Example:
  # echo "+ SSD:100,HDD:2" > /sys/kernel/mm/swap/tiers

  There are several rules for defining tiers:
  - Priority ranges for tiers must not overlap.
  - The combination of all defined tiers must cover the entire valid
    priority range (DEF_SWAP_PRIO to SHRT_MAX) to ensure every swap device
    can be assigned to a tier.
  - A tier's prio value is its inclusive lower bound,
    covering priorities up to the next tier's prio.
    The highest tier extends to SHRT_MAX, and the lowest tier extends to DEF_SWAP_PRIO.
  - If the specified tiers do not cover the entire priority range,
    the priority of the tier with the lowest specified priority value
    is set to SHRT_MIN
  - The total number of tiers is limited. 

- To remove tiers:
  Format: - 'tier_name'[,|' ']'tier_name2']...
  Example:
  # echo "- SSD,HDD" > /sys/kernel/mm/swap/tiers

  Note: A tier cannot be removed if it is currently in use by any
  cgroup or if any active swap device is assigned to it. This acts as
  a reference count to prevent disruption.

- To show current tiers:
  Reading the file displays the currently configured tiers, their
  internal index, and the priority range they cover.
  Example:
  # echo "+ SSD:100,HDD:2" > /sys/kernel/mm/swap/tiers
  # cat /sys/kernel/mm/swap/tiers
  Name      Idx   PrioStart   PrioEnd
            0
  SSD       1    100         32767
  HDD       2     -1         99

  - `Name`: The name of the tier. The unnamed entry is a default tier.
  - `Idx`: The internal index assigned to the tier.
  - `PrioStart`: The starting priority of the range covered by this tier.
  - `PrioEnd`: The ending priority of the range covered by this tier.

Two special tiers are predefined:
- "": Represents the default inheritance behavior in cgroups.
- "zswap": Reserved for zswap integration.

2. Cgroup Tier Selection: memory.swap.tiers

This file controls which swap tiers are enabled for a given cgroup.

- Reading the file:
  The first line shows the operation that was written to the file.
  The second line shows the final, effective set of tiers after
  merging with the parent cgroup's configuration.

- Writing to the file:
  Format: [+/-] [+|-][TIER_NAME]...
  - `+TIER_NAME`: Explicitly enables this tier for the cgroup.
  - `-TIER_NAME`: Explicitly disables this tier for the cgroup.
  - If a tier is not specified, its setting is inherited from the
    parent cgroup.
  - A standalone `+` at the beginning resets the configuration: it
    ignores the parent's settings, enables all globally defined tiers,
    and then applies the subsequent operations in the command.
  - A standalone `-` at the beginning also resets: it ignores the
    parent's settings, disables all tiers, and then applies subsequent
    operations.
  - The root cgroup defaults to an implicit `+`, enabling all swap
    devices.

  Example:
  # echo "+ -SSD -HDD" > /sys/fs/cgroup/my_cgroup/memory.swap.tiers
  This command first resets the cgroup's configuration to enable all
  tiers (due to the leading `+`), and then explicitly disables the
  "SSD" and "HDD" tiers.

Further Discussion and Open Questions
-------------------------------------
I seek feedback on this concept and have identified several key
points that require further discussion (though this is not an 
exhaustive list). This topic will also be presented at the upcoming 
Linux Plumbers Conference 2025 [3], and I would appreciate any 
feedback here on the list beforehand, or in person at the conference.

1.  The swap fast path utilizes a percpu cluster cache for efficiency.
    In swap tiers, this has been changed to a per-device per-cpu 
    cluster cache. (See the first patch in this series.)
    An alternative approach would be to cache only the swap_info_struct 
    (si) per-tier per-cpu, avoiding cluster caching entirely while still 
    maintaining fast device acquisition without `swap_avail_lock`.
    Should we pursue this alternative, or is the current per-device 
    per-cpu cluster caching approach preferable?

2.  Consistency with cgroup parent-child semantics: Unlike general
    resource distribution, tier selection may bypass parent
    constraints (e.g., a child can enable a tier disabled by its
    parent). Is this behavior acceptable?

3.  Per-cgroup swap tier limit: Is a `swap.tier.max` needed in
    addition to the existing `swap.max`?

4.  Parent-child tier mismatch: If a zombie memcg (child) uses a tier
    that is not available to its new parent, how should this be
    handled during recharging or reparenting? (This question is raised
    in the context of ongoing work to improve memcg reparenting and
    handle zombie memcgs [4, 5].)

5.  Tier mask calculation: What are the trade-offs between calculating
    the effective tier mask at runtime vs. pre-calculating it when the
    interface is written to?

6.  If a swap tier configuration is applied to a memcg, should we
    migrate existing swap-out pages that are on devices not belonging
    to any of the cgroup's allowed tiers?

7.  swap tier could be good abstraction layer. Discuss on extended usage of swap tiers.

Any feedback on the overall concept, interface, and these specific
points would be greatly appreciated.

Best Regards,
Youngjun Park

References
----------
[1] https://lore.kernel.org/linux-mm/aEvLjEInMQC7hEyh@yjaykim-PowerEdge-T330/T/#mbbb6a5e9e30843097e1f5f65fb98f31d582b973d
[2] https://lore.kernel.org/linux-mm/20250716202006.3640584-1-youngjun.park@lge.com/
[3] https://lpc.events/event/19/abstracts/2296/
[4] https://lore.kernel.org/linux-mm/20230720070825.992023-1-yosryahmed@google.com/
[5] https://blogs.oracle.com/linux/post/zombie-memcg-issues

Youngjun Park (3):
  mm, swap: change back to use each swap device's percpu cluster
  mm: swap: introduce swap tier infrastructure
  mm/swap: integrate swap tier infrastructure into swap subsystem

 Documentation/admin-guide/cgroup-v2.rst |  32 ++
 MAINTAINERS                             |   2 +
 include/linux/memcontrol.h              |   4 +
 include/linux/swap.h                    |  16 +-
 mm/Kconfig                              |  13 +
 mm/Makefile                             |   1 +
 mm/memcontrol.c                         |  69 +++
 mm/page_io.c                            |  21 +-
 mm/swap.h                               |   4 +
 mm/swap_state.c                         |  93 ++++
 mm/swap_tier.c                          | 602 ++++++++++++++++++++++++
 mm/swap_tier.h                          |  75 +++
 mm/swapfile.c                           | 169 +++----
 13 files changed, 987 insertions(+), 114 deletions(-)
 create mode 100644 mm/swap_tier.c
 create mode 100644 mm/swap_tier.h

base-commit: 02dafa01ec9a00c3758c1c6478d82fe601f5f1ba
-- 
2.34.1


