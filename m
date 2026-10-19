Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C16E6CCF2DE
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:14:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A705B6B00EA; Mon, 19 Oct 2026 10:14:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48A46B00EB; Mon, 19 Oct 2026 10:14:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9376D6B00EC; Mon, 19 Oct 2026 10:14:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66C6A6B00EA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:14:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E4E21160769
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:14:42 +0000 (UTC)
X-FDA: 85339571604.06.B0C0810
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6C1E2A000C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:14:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=dFvUhypR;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792419281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NEJJZ34u4qlgZ0S11fm90eLB3kl92LQqge8z3SZGpCM=;
	b=o76rdLiblRDKUaH8FlqNV4qrXWKywr72Eu2OEEYtpwm9aMkkFgGovOeK8OIqN5UQh2Atd+
	VI0rn9nLyu0bIgFKR2h8BtC60LY9rZnTYDyBFugYk7KZzh9+Y2q9PmsdJceydmNfOR8aXO
	IrHnC2G5ERmIv6cpLXvzzqXbXOFMDPM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=dFvUhypR;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792419281;
	b=RaNEcME9ThjPgJ/7IX6j2AW+YeO29K2vu/hIDTxsEdRLWUkLxpdd40SvqXstd4DeN0lRNs
	sObWOc4mej62gap52tT4bsyrz518QE1KQUqMJykXCF21PcmhtIadHVdPP892o5AzRomkyK
	L2RPu3xW+gvWIWrqB6GjcpJJdDsR8uY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792419273; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=NEJJZ34u4qlgZ0S11fm90eLB3kl92LQqge8z3SZGpCM=;
 b=dFvUhypRzf1ummP5/JL1m6szKVH6GqQcOUAX+b/BfVsuiGUsaKMGpHsvJIiqn6jLg6c2TZ
 g/GFZyYo4GZ7IcKXQd7tfuMMwxW8ObwK9f1jmKHRvHK5eUpQn/DXHqYlDvDwCwhrPk57cK
 RqXABqFE7yJcTFEhxbg3lyfTEAtkbqyZ5GXeCiMY88nlNi5ipWuwDJqmMi0eV8WamR0KGZ
 4Q0w4SqC1t5mw4QR/C3we4KTNfbh6J6JNkSgOYJgfrFBpuAcCn87VytS4qbQ2uDly3f1oE
 CVHvk0wp5vnzhaY55FKNG4SoAyojsVUs7p9Md4bJjJX4lki8xN6KdkKvZiuB2w==
To: <akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<ziy@nvidia.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, 
	<ying.huang@linux.alibaba.com>, <ljs@kernel.org>, <mhocko@suse.com>, 
	<muchun.song@linux.dev>, <roman.gushchin@linux.dev>, 
	<shakeel.butt@linux.dev>, <weixugc@google.com>
Date: Mon, 19 Oct 2026 22:13:59 +0800
X-Lms-Return-Path: <lba+26ad625c7+9d7cf2+kvack.org+lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [RFC 0/2] mm: add source selectors to memory.reclaim
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Cc: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20261019141401.11927-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6C1E2A000C
X-Stat-Signature: bbmwrgyj6x8pzwqpwpob76neje1qsws5
X-Rspam-User: 
X-HE-Tag: 1792419280-968372
X-HE-Meta: U2FsdGVkX19AcejkJJdNzJvZFJXO43LfgGs/GJh6QYbyhCPyCJvIqbTJeizJcfylFJzlAzvSofUrHoEXa4VeJ2AUth42xiFgAWDaUjSs4zERbrvvGUHh7g/OEWAHEVtCvXekRjyNSPt2mzBfJne2Yss+NjAj8oM2i8zyLldYPuV3Rp/C1h4kj3TN8qz/jPqOG6EWiVkAW5ZpIlTlETir7jnjsr5aslTdjtWNa1N72mDyIAlrW73YFO+SzhMW9vncxzENtPY5FjBKecfFQUy1JACnx7C7VzVDzvAlGOmPJ6jaN36D/fUpaafsT6QB1kvYnnsbMK0z9GZHP6U9DQNPLTM5JeJF3AABKJz+nwFQEGrFIfXAcVwZJOdJkotLEfv99XKQUOD+IOf50NQzoH0NUueFOsRxwgzWW1lDdcqL4JXufdh7iCSM5Lz+GIC9VAd3WqN1e82hL0Hb+aA9SmNmg1dGeYJ01Dedkp7XHMCdPC5qK+tEeZx+IUJ5SGgWVZU8bA/FwmJif33BbyA5DnSyfzjWxRX8wicedRKgTIbqgK315sOWLiLMtTXPZh/ljRZ6WpfxannxendllTTCiVqBSQ1uuJE7YxQl/dieeLOf7KXOc0PmGKooFe+b27/jTmI6FUdVX7dsHdGSTXXOcNSW4fnkEoSopmKtEKocmp12Ik4XHSESuoA+Or/Y+LLrnLc5sijd1ogrKGfzWywK6VungLRaazhISTdMMgmIw2DiyMkD2vfS+XNQxQqLdO7J8VAhWIqKhfjbRLu+785iuhuA/caZ2LHfYuQ2G7nbnIaDDtrr46/sE03Ut11NPIqkPKH9eGGUNofSWZGNgGzc0Q+2yl9hfLuYaA+glJn2rswistFuagenbxVI9dEP24WySTT9zWWa8j2jPReOqAhi1kBSL360gr8lA6v/+O6YXdwI/EnxdXSgShb+//gOI9dl4uFUuEZuHuy+0wpY7pFP2wH
 xjDITI7F
 DhWqkWxITxoxDJKLGZqfqs/mWV3uyhgj1SNx4gU3O/pJBdrz0xqDMyb0fsdlXbF0tGOJEGLAxw7vrMTQ3TTASHmqOH4rNsMGJfDRYz+IqGMPd3gMesmPLK7/Z7Lm6uBnpBd18GlsQ27BPb18FnjEhPuUoZgMIHdxRXnRIH7mz9OE1aTbQ6Us+8PmRdjduOSbZmriXYB70dn/KD/85B3EuiF9GWQplwjK9sVEHtnGcxPFbuNpko95Tg3tN4CBZWiJ7t4Y/yaP5Pu7fWgaWNFgcen8sxr6Mcowx/bSHvlW9cB50qiubQ5XOWgwx0B23gpPzIbOPYeANoyNLNzo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memory.reclaim is a useful proactive reclaim interface for memcgs, but
tiered memory makes "reclaim N bytes from this memcg" underspecified for
userspace controllers that manage memory placement across tiers. The
kernel's reclaim policy is aging-based, and on tiered systems aging may
demote folios before they are eventually evicted. Without a way to
declare where reclaim pressure should start, userspace can only reclaim
from the memcg as a whole and observe one aggregate progress value.

There is prior history here [1]. The old nodes= proposal tried to let
memory.reclaim scan selected NUMA nodes, but the discussion left several
ABI questions unresolved:

- nodes= did not clearly say whether the mask was a source selector, a
  reclaim domain, or a demotion-target constraint.
- The implementation did not apply the mask to the whole reclaim path,
  so demotion could allocate outside the mask. If userspace interpreted
  the mask as a domain or target constraint, the ABI did not provide
  that.
- Selecting top-tier nodes could become an implicit way to request
  demotion without uncharge. That would make userspace depend on a
  particular reclaim policy and could make future policy changes hard.
- The separate completion-accounting question remained: demotion can
  count as reclaim progress even though memory.current is not reduced.

This series takes a narrower approach. It adds a typed source= key which
declares only the source on which the existing memory.reclaim aging
pipeline should be applied. It is not a demotion target selector, not a
demotion-only goal, not an eviction-only goal, and not a change to the
existing completion accounting. Leaving source unspecified preserves the
existing memory.reclaim behavior.

In that sense, this series extends node-scoped reclaim pressure to the
memcg memory.reclaim interface. The existing node memory_reclaim
interface can apply pressure to a node, but it is not scoped to a
particular memcg. This series lets userspace apply the same kind of
source-scoped pressure to a cgroup's resident memory on selected nodes
or tiers, while still using the normal memcg reclaim path.

The main benefit of this series is to give userspace a steering knob
for per-node and per-tier memory placement control. A tiering controller
can observe the resident memory distribution across nodes or memory
tiers, and then apply reclaim pressure to the source that should be
relieved. For example, it can apply pressure to top-tier nodes so that,
under the existing tiering policy, cold folios can be aged and usually
demoted to lower tiers, or reclaim from a terminal tier when it needs
actual charge reduction.

The existing memory.reclaim interface cannot express this. It applies
pressure to the memcg as a whole, so on a multi-tier system the kernel
may make progress in a tier different from the one userspace is trying
to control. That makes feedback control of tier ratios ineffective: the
controller can observe that a specific tier is over its desired resident
footprint, but it cannot direct the next reclaim request to that tier.

Patch 1 adds source=nodes:<nodelist>, which is the basic source
selector. Patch 2 adds source=tier:<N>, where N is the memory_tierN id
exposed by /sys/devices/virtual/memory_tiering/. The tier selector is
only a convenience layer over the same source semantics: it resolves the
current tier nodelist at write time and then uses the same source-scoped
reclaim path as source=nodes:<nodelist>.

The remaining issues from the old discussion are intentionally left out
of this series. If userspace needs to control demotion targets, that
should be a separate target/demotion-policy ABI rather than folded into
source=. If userspace needs a strict "bytes actually uncharged"
completion mode, that should be discussed as a separate accounting or
goal extension because it would change the observable meaning of
memory.reclaim progress. This series only adds source selection for the
existing reclaim policy.

References:
[1] https://lore.kernel.org/all/Y5bsmpCyeryu3Zz1@dhcp22.suse.cz/

Li Zhe (2):
  mm: add source selector to memory.reclaim
  mm: add tier source selector to memory.reclaim

 Documentation/admin-guide/cgroup-v2.rst | 29 +++++++++++
 include/linux/memory-tiers.h            |  6 +++
 mm/internal.h                           |  3 +-
 mm/memcontrol-v1.c                      |  6 ++-
 mm/memcontrol.c                         | 11 +++--
 mm/memory-tiers.c                       | 24 ++++++++++
 mm/vmscan.c                             | 64 +++++++++++++++++++++++--
 7 files changed, 133 insertions(+), 10 deletions(-)

-- 
2.20.1

