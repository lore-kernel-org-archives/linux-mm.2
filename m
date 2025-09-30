Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 163AACAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759F78E002F; Tue, 30 Sep 2025 02:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 731068E0002; Tue, 30 Sep 2025 02:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66E658E002F; Tue, 30 Sep 2025 02:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 50C888E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:33:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F14841405B4
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:33:39 +0000 (UTC)
X-FDA: 83944950558.13.71AAD7D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1DFDD80008
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:33:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="QHzd/VZv";
	spf=pass (imf02.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759214018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kiXxrBcVVFYm8tZKNDHLTv2ddgXNFYWsb2EEhOiKInA=;
	b=5o+3Go59+F2vxsYyOXIFq8TCjATKiR/HYpU+vDteORMnGlsWW9xcZdrCvgub/dgl35nW8c
	lLfs7Wf5mEj5kejU/yH6TZ3h96p8QVUiGxmGur7xasepvir19D1gQ3eXyHVTyLUarhKQ/1
	9x2NyyG5Pgrxx8lIv5WI+cAgfg5Lrr4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759214018; a=rsa-sha256;
	cv=none;
	b=brMFAxC1Ze5Lkotz4ajuxAcPdfB0BgecqmUoLQiSGADi0a8KsLxSNFEP0FRbVh5rZJjq3L
	n/uFHTfqhX3Msl9HgkDsAO4KFeXcZNz52ptQ0MCxTW3Fpty8dmo32x8bU6ozMH7gkdgDzp
	pP3oiIhaszaBMWGOQV6vB04k2+MBYj4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="QHzd/VZv";
	spf=pass (imf02.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759214017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kiXxrBcVVFYm8tZKNDHLTv2ddgXNFYWsb2EEhOiKInA=;
	b=QHzd/VZv0BcvmXnWi5esjWjrWbAk3yb4wXaKMWYNprPJOpc0Lk6Wvcq60wODONxD+/YjN6
	Lhz0pv1JRYY150ENTKRbBgqaZLrhRNmo5Fcyc8roIZzzvY1QGNF1e8/QOF+cr3HznKRBvd
	8FzFi1cb0oY7JTlUjGViDsIULz+pRZM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-629-XUSP3b1nNp6eSyZ0l9ofng-1; Tue,
 30 Sep 2025 02:33:34 -0400
X-MC-Unique: XUSP3b1nNp6eSyZ0l9ofng-1
X-Mimecast-MFC-AGG-ID: XUSP3b1nNp6eSyZ0l9ofng_1759214012
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E1623180A20D;
	Tue, 30 Sep 2025 06:33:19 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.181])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 547321801AD8;
	Tue, 30 Sep 2025 06:33:13 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	youngjun.park@lge.com,
	aaron.lu@intel.com,
	baohua@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v3 0/2] mm/swapfile.c: select the swap device with default priority round robin
Date: Tue, 30 Sep 2025 14:33:08 +0800
Message-ID: <20250930063311.14126-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sjMiv17bIrmx8PvXC0Jcu74Xa-FlPlll3TXnyStSjA0_1759214012
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1DFDD80008
X-Stat-Signature: z4d54ffwb8uco548xyjqecyo5dndis4x
X-Rspam-User: 
X-HE-Tag: 1759214017-389787
X-HE-Meta: U2FsdGVkX19xR5ZRbz2i8YS0quZQA63fRqWJbbMbMVDBWVgPlPnoW3Z/ZPBdVUBE8nK6RNt8l7nghiHqu94KHbph4tNlFkf2cyBgSnd1hhWPCd0YSTRP9plT2wFpfGwlJdhFcGaS5FgKvKWzCGzR8pdsHFXh7+LGId8ph5JmeE8gEk85/mypgoGVyczVeajpBm/3aErNa38rF73NPk7LzTSsRR66DYtG1brHSRsvOF7oufUUGil69/waR6VXB7K0RuNdQGhzf97vZjJPaHCPn6BOH/ts3eIuVAAyhBk1mq6SovkB0SWg6pHHL7k0gPwUUnvVDd+aOs+FB060rO3I4nQGTJeTLt6rgurnH1uX+wbNylN3TvRRAZDumRA8l4RRGCDYaSMPFsZPm6tFmWAGlJH7GqDq0bLvSvdst0TAVpH9a1h10BHNb0WU51xd2+xJsMCDYJ0SuaVChVBbRIW7fCW7rnmKAuHHDPfxKSZBEkh1FmEJZLOIyzyRP7FH7JwjU6UAI7xyCIICvzbdb2C62gHxLLFar4o7NH58TbDQOX0WsJ3+FwjEaGvKhO9xEf69Rd6YLUCF08SGWwTaWowUh73ujFcRylohlbL69efuQRHdjnpg6OsJ3GaygKYUJuYtd/luCBr3k2JvugAtqpKuYdshYrWYVahagbMNkmGYN8D0za/EKfr1LisgS6bA1NnCQiu+Y3ohsI/Wu3sYoKwDcLvVkg4U+WHmP0wS3DvfrS7ebyH+K7gRLQdODxSs3JKswKixIZo8ep88ABoHSsPgXRC3f1JjhxA3TgujLFOFbOQ4o8n3sfAWnOrkF7YS/QnEY9SyxDQRJ4pg9WVR/niSTVyVVAnZQF8BdyvI1gZoXynDdEnr1NS1hSOd5ZYReaSIpisUX/PVcFttyVXcKBh2mWqKV3TM9k42Q/Dr2oe3MaKfO5iPDOE6msvvNiToFJlzYmeeB4ZX40vOUfGk5pg
 daKUvMyj
 FqWgBO7Mxj1VwIANHuoJEm+a584EoWoHgJu6QX+qXh4uiMi2icMv9AmpQzjE3iBqDjQ7yi8i+G5LHHe2QPik246kRtllOy2M2nr1WoJfL5xpgLkspiGk5hgg050NzfWP0zwNTtHAJaE0mu8BAkiK+i0TZQKBMbVI9ic8Xjnne/JksDbrX17IeDrWDq+1NudUjMFmluuZNvL45XlLDTVjvmA9f40+Lp98lUNueDHpI6r5aU0e0iB5jmWNu7A6MIVufDxV26WZLz1rRWGyDu1cCu1KyLtw4DLkUso73WyiUZRdrep1E2zyInQ2kBHkl4Et5RE/qy5Jf7CNFdnbd9zM1/+W9/nGj3eDbb76M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, on system with multiple swap devices, swap allocation will
select one swap device according to priority. The swap device with the
highest priority will be chosen to allocate firstly.

People can specify a priority from 0 to 32767 when swapon a swap device,
or the system will set it from -2 then downwards by default. Meanwhile,
on NUMA system, the swap device with node_id will be considered first
on that NUMA node of the node_id.

In the current code, an array of plist, swap_avail_heads[nid], is used
to organize swap devices on each NUMA node. For each NUMA node, there
is a plist organizing all swap devices. The 'prio' value in the plist
is the negated value of the device's priority due to plist being sorted
from low to high. The swap device owning one node_id will be promoted to
the front position on that NUMA node, then other swap devices are put in
order of their default priority.

E.g I got a system with 8 NUMA nodes, and I setup 4 zram partition as
swap devices.

Current behaviour:
their priorities will be(note that -1 is skipped):
NAME       TYPE      SIZE USED PRIO
/dev/zram0 partition  16G   0B   -2
/dev/zram1 partition  16G   0B   -3
/dev/zram2 partition  16G   0B   -4
/dev/zram3 partition  16G   0B   -5

And their positions in the 8 swap_avail_lists[nid] will be:
swap_avail_lists[0]: /* node 0's available swap device list */
zram0   -> zram1   -> zram2   -> zram3
prio:1     prio:3     prio:4     prio:5
swap_avali_lists[1]: /* node 1's available swap device list */
zram1   -> zram0   -> zram2   -> zram3
prio:1     prio:2     prio:4     prio:5
swap_avail_lists[2]: /* node 2's available swap device list */
zram2   -> zram0   -> zram1   -> zram3
prio:1     prio:2     prio:3     prio:5
swap_avail_lists[3]: /* node 3's available swap device list */
zram3   -> zram0   -> zram1   -> zram2
prio:1     prio:2     prio:3     prio:4
swap_avail_lists[4-7]: /* node 4,5,6,7's available swap device list */
zram0   -> zram1   -> zram2   -> zram3
prio:2     prio:3     prio:4     prio:5

The adjustment for swap device with node_id intended to decrease the
pressure of lock contention for one swap device by taking different
swap device on different node. The adjustment was introduced in commit
a2468cc9bfdf ("swap: choose swap device according to numa node").
However, the adjustment is a little coarse-grained. On the node, the swap
device sharing the node's id will always be selected firstly by node's CPUs
until exhausted, then next one. And on other nodes where no swap device
shares its node id, swap device with priority '-2' will be selected firstly
until exhausted, then next with priority '-3'.

This is the swapon output during the process high pressure vm-scability
test is being taken. It's clearly showing zram0 is heavily exploited until
exhausted.

===================================
[root@hp-dl385g10-03 ~]# swapon
NAME       TYPE      SIZE  USED PRIO
/dev/zram0 partition  16G 15.7G   -2
/dev/zram1 partition  16G  3.4G   -3
/dev/zram2 partition  16G  3.4G   -4
/dev/zram3 partition  16G  2.6G   -5

The node based strategy on selecting swap device is much better then the
old way one by one selecting swap device. However it is still unreasonable
because swap devices are assumed to have similar accessing speed if no
priority is specified when swapon. It's unfair and doesn't make sense just
because one swap device is swapped on firstly, its priority will be higher
than the one swapped on later.

So in this patchset, change is made to select the swap device round robin
if default priority. In code, the plist array swap_avail_heads[nid] is replaced
with a plist swap_avail_head which reverts commit a2468cc9bfdf. Meanwhile,
on top of the revert, further change is taken to make any device w/o
specified priority get the same default priority '-1'. Surely, swap device
with specified priority are always put foremost, this is not impacted. If
you care about their different accessing speed, then use 'swapon -p xx' to
deploy priority for your swap devices.

New behaviour:

swap_avail_list: /* one global available swap device list */
zram0   -> zram1   -> zram2   -> zram3
prio:1     prio:1     prio:1     prio:1

This is the swapon output during the process high pressure vm-scability
being taken, all is selected round robin:
=======================================
[root@hp-dl385g10-03 linux]# swapon
NAME       TYPE      SIZE  USED PRIO
/dev/zram0 partition  16G 12.6G   -1
/dev/zram1 partition  16G 12.6G   -1
/dev/zram2 partition  16G 12.6G   -1
/dev/zram3 partition  16G 12.6G   -1

With the change, we can see about 18% efficiency promotion as below:

vm-scability test:
==================
Test with:
usemem --init-time -O -y -x -n 31 2G (4G memcg, zram as swap)
                           Before:          After:
System time:               637.92 s         526.74 s      (lower is better)
Sum Throughput:            3546.56 MB/s     4207.56 MB/s  (higher is better)
Single process Throughput: 114.40 MB/s      135.72 MB/s   (higher is better)
free latency:              10138455.99 us   6810119.01 us (low is better)

Changelog:
==========
v2->v3:
-------
- Split the v2 patch into two parts, one is reverting commit
  a2468cc9bfdf, the 2nd is making change to set default priority as -1
  for all swap devices which makes swapping out select swap device round
  robin. This eases patch reviewing which is suggested by Chris, thanks.
- Fix a LKP reported issue I mistakenly added other debugging code into
  v2 patch. clean that up.

v1->v2:
-------
- Remove Documentation/admin-guide/mm/swap_numa.rst;
- Add back mistakenly removed lockdep_assert_held() line;
- Remove the unneeded code comment in _enable_swap_info().
  Thanks a lot for careful reviewing from Chris, YoungJun and Kairui.

Baoquan He (2):
  mm/swap: do not choose swap device according to numa node
  mm/swap: select swap device with default priority round robin

 Documentation/admin-guide/mm/swap_numa.rst |  78 ----------------
 include/linux/swap.h                       |  11 +--
 mm/swapfile.c                              | 103 +++------------------
 3 files changed, 16 insertions(+), 176 deletions(-)
 delete mode 100644 Documentation/admin-guide/mm/swap_numa.rst

-- 
2.41.0


