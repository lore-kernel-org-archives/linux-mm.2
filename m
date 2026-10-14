Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91375CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A92796B0092; Wed, 14 Oct 2026 05:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68BD6B009B; Wed, 14 Oct 2026 05:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A5D56B00C2; Wed, 14 Oct 2026 05:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9446B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:44:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0CF95120472
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:44:43 +0000 (UTC)
X-FDA: 85320747246.04.DBCD7B6
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf31.hostedemail.com (Postfix) with ESMTP id ABCC020002
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:44:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="iX+8PH/I";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf31.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791971081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=I26JrSuCzA83CNBVA69JTeJPLnyTlk8cgX1YDR6KSNY=;
	b=abXKcVUYLmSRKpuW2hY5ty5nfROTq/DfMsMjsSxB9atQeD1p8j8F+MQVZNYs49eJWeqUs1
	WBwxMlU+wt5twNmr8Vns8/EPkpj+HcO969qtoUYaa8xlnzGhz75ImVFbGe46TLSSnZEyiS
	nhtxHvtiuCjdXqe09MhlLD5JXhT7dQE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="iX+8PH/I";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf31.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791971081;
	b=qh8qorz+0yl1O8ApMP+KTAtWwRkyvT58gym+sINx2Y5oOIYABjiQwQxlTrpuXcZDQ3sgyZ
	Zsce94vVv+VZyyAagnKVEF0oTh2i0RR1H1RxQTvWiUH6BVGucHAwFQGnUqg8exXlrIMbka
	2SdHh3rDby6KMcAeZ26qfpdHAJDghjY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1791971069; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=I26JrSuCzA83CNBVA69JTeJPLnyTlk8cgX1YDR6KSNY=;
 b=iX+8PH/IjUV4qmB6BGd3VL1Lqw6bzkOoASL+EyeTFBOOww1VZFQqdJ9ZnNHAWUb0DFCZ+2
 kdy0ScnYGfIS7bUfhvD2MYj3xJm2yKIZEaLaZjnhspOXbs5H2+Wnwu7ErnoV6cxUTf+7Gx
 wM/b/f6f4It2XcCoBuNpYWLto2ttGB/hUIrYav4PQZNV23AYNsMZh1mj53MEaXTO/sAiOc
 4UgnuI2SqwERzafJkvYQUZ/Z+EVTZpJwv8mhL5DriUV6SUlxcOIHrOPpHIEExDbcwMZbM3
 +YJONXw4G07N1mv53zXC1CBw5lZSrJraxgHrDryoKCXiCVq7iWzQtY3U2rCYOg==
Subject: [PATCH 0/6] sched/numa: fix several NUMA balancing issues
Message-Id: <20261014094347.99157-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26acf4efb+8fb663+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<gourry@gourry.net>, <joshua.hahnjy@gmail.com>, <ziy@nvidia.com>, 
	<mingo@redhat.com>, <peterz@infradead.org>, <mgorman@suse.de>, 
	<riel@redhat.com>, <juri.lelli@redhat.com>, <vincent.guittot@linaro.org>, 
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>, 
	<vschneid@redhat.com>, <kprateek.nayak@amd.com>
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, "Li Zhe" <lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed, 14 Oct 2026 17:43:41 +0800
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: ABCC020002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 9995tpo768enncm8si9b4bgobjj715a5
X-HE-Tag: 1791971080-747128
X-HE-Meta: U2FsdGVkX1+uLVSs7C18leOmUG1nS8Tfv092hegs3DrFXS7whCJ1O7zau03oJAk/gQyWfM2gcSWVCXv9hdjHIRzajN+A/vF2+i0LbO6j//QazxLdptdhWIbq2M3E9xOcoj5Ha2A2XJH4oP8pshnAaTY4NFylhfqnXXW8rD9GiTEtJMppXENAMOIUTZHkBvJPl19jjNiRsAVkEvPppP9i7mfTUQZKm7+WG63jxPlWDClpCji9gI3D0CLph0AhiUA/2Sp9+Q8zpqMPNbbqDT9i2KWITT7C4BaZEXh6bsUOPXg59UGGxbMDfHEmmyipAiF0WsZjFoe0s7XKyN7yUL1lThyYSq5GMqHVQZQW1HmeEGyJ3RFByboA0nvbsRntN7wBUtYVJeeJwzfGHHPBhhjZQhROkbxuLigF/Pd7E/AbMKBBJdNhjqBYtNXu5ylzxlnwJIJwZuQ7SvgDZOFPilmeoDtbdlPq5ZkbvukhYELjeR2nvdmiahpJcstEpWh0CsWMuCmikRKMqDTOE4XBcmZTBTtWDu1vzNFPBIQ+yOkI5vAo5GM2Ygvglxklum9Evbi5iCkAP/kmyH+LHrU4VkqGWVKFBoOo55y6FRmG0SBs+lSu/6dsOxxTKM3sbdKIm1x6AO/NPnNQ4vpAMl/hfDGpU4zJ2eRtZGExVhlN1AOmlHAVIvlyzqRZkVHrp7fMUEzyQALZmHadnREp0DHITGjMpC5vPYEUccdtzKPPbRJXlN1zyRQdxNVXjBR5wmODtKknYlbRRFNSB6++2xN1+L6CuHurfYXpTdpFCaQXwq92XDKnujqf8FtIewJ7qJWuJJMjc0Ny8EP1+mg7PbBVRCSCD49BKIa6NhSccERbkEjFFO1hFSk9tK3EIZAkXHk60w8IMCBJWkjgpPB1h97PFA1GvZCAU4gzBgLwXuwFTVpYCgzvwsSFceS+tVGilFL4mmL0qMQ9nWxuIEFLfp7f/j4
 uybQTnYw
 zsXuGj79zpDNzruQxDPkUyn3rRXZeHDlEpnFGjl/g7E92Y+qqEjpIRCg0khVV3xyr7o2t8acyQelZ+XNdeG5uAJPo0XGIIj4j+otmv5ibX/Xz5U63YBoMvHNRneTtmTZMVH5pqb3W1WZzpkelHedg8lVFIeUtVMdE/Tm2Or3JLHj4grEc9ele88CAVgVVsCRpb9nfA7UrZXPQjSeUt8XTzDDasSWvbBh1a5P7y8r4uYFpRYpjNTCa956XGcPSzw1rAYfgIZaIsDk5+T22HfVm3XfZ5UJFWt6mkc74p3QUhVY7THMd8/7FOwrQVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes several NUMA balancing issues around scan-period
adjustment, memory-tiering promotion feedback, and stale task-placement
state.

Patch 1 clears retained NUMA fault-window and locality state across
execve(), so the new image does not inherit feedback from the old one.

Patch 2 fixes the scan-period ratio denominator checks. The existing code
checks a different sum than the one later used as the divisor.

Patch 3 fixes scan-period adjustment for shared faults. Shared or local
faults should slow scanning down, while speeding up should require enough
faults that are both private and remote.

Patch 4 makes the free-space memory-tiering promotion bypass configurable.
The default behavior is preserved, but users can require the normal hotness
and rate-limit checks even when the top tier has enough free space.

Patch 5 prevents memory-tiering-only promotion faults from feeding normal
AutoNUMA task-placement statistics.

Patch 6 ignores stale preferred-node placement state while normal NUMA
balancing is disabled, so memory-tiering-only mode does not consume old
task-placement decisions.

Li Zhe (6):
  sched/numa: clear fault locality state on execve
  sched/numa: fix scan-period ratio denominator checks
  sched/numa: fix scan-period adjustment for shared faults
  sched/numa: make free-space tiering promotion bypass configurable
  sched/numa: do not feed tiering promotions into task placement stats
  sched/numa: ignore preferred nodes without normal balancing

 Documentation/admin-guide/sysctl/kernel.rst |  16 ++
 include/linux/mm.h                          |   5 +-
 include/linux/mmzone.h                      |   5 +-
 include/linux/sched.h                       |  17 +-
 kernel/sched/fair.c                         | 181 ++++++++++++++------
 mm/memory.c                                 |   2 +-
 6 files changed, 163 insertions(+), 63 deletions(-)

-- 
2.20.1

