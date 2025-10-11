Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 540D6CCD183
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 08:16:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CBEB8E002C; Sat, 11 Oct 2025 04:16:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A1928E000E; Sat, 11 Oct 2025 04:16:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DE268E002C; Sat, 11 Oct 2025 04:16:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 69C538E000E
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 04:16:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EBB9B1405C7
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 08:16:40 +0000 (UTC)
X-FDA: 83985126960.23.6E9382D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id C167E40004
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 08:16:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Fvu/BBqG";
	spf=pass (imf17.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760170598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Km0X4w+q4IbUyROQU7uukkPjVvewhvy5flqs5vfPfb0=;
	b=tiLbsvF+CtISulBqJkRHxdo89tkgUx1wrPwZHN55dN43loXYTeYCJn0TC2E/ErtlEfAUVt
	IFVLtIPtjAyJ1Chq7+f1Aab76bO0XZkL8nGMJHAfIbOYoPq4gpl/TmVFVgCAfqu8q3xIOU
	XiO89Jwh3RT2yR+r3X8WwmpKtS4+k2s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Fvu/BBqG";
	spf=pass (imf17.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760170598; a=rsa-sha256;
	cv=none;
	b=MX4UF6VXzLazjHfFF4FMGTGBu20LE2UlRw1xI+vKv2Rw959TvMh2oS2wcfk98VF3jHfpxR
	M+zXecP3ED9X+uSJNlZd9h+Sl6IAoWDNNI6QLRtddkcF+dIfxltNuG1Chg7j1nWx2ry3bq
	mrTN1C9XSTEkyKtrqphnN8CuVC+M9uA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760170597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Km0X4w+q4IbUyROQU7uukkPjVvewhvy5flqs5vfPfb0=;
	b=Fvu/BBqGhp/Oz/fkD9u59u3307MhIH21RYR3kzB/5PiIp6DA8xW+iR68vagWi6XbCVrTjl
	jbX2L6NQrT2gEsZH21ruInfyZRnaqGioJZi3TJ02exVlW5ZUf1Tc4vdZ4bWoN5okDP/ztH
	KCicUz9/qqdcnKEQaaeU8/rLpxQtgxo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-220-Ptmjh-y5N6y--q0d0LHWVw-1; Sat,
 11 Oct 2025 04:16:35 -0400
X-MC-Unique: Ptmjh-y5N6y--q0d0LHWVw-1
X-Mimecast-MFC-AGG-ID: Ptmjh-y5N6y--q0d0LHWVw_1760170593
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5DAB11800451;
	Sat, 11 Oct 2025 08:16:33 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.60])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0FD361955F42;
	Sat, 11 Oct 2025 08:16:27 +0000 (UTC)
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
Subject: [PATCH v4 mm-new 0/2] mm/swapfile.c: select the swap device with default priority round robin
Date: Sat, 11 Oct 2025 16:16:22 +0800
Message-ID: <20251011081624.224202-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6b0CpSj9u3DmX3t14LyinPFHSkTI4_AUs_Qa0qQ2kw4_1760170593
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: efbtb1fcakez4yey1b5nj68suf8h94bm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C167E40004
X-HE-Tag: 1760170597-473819
X-HE-Meta: U2FsdGVkX1/xsULzuCxLHZSMo0QQXn8hrVyhv/mVvW1MAivHLJ6N3IpEmCu+JYIlsquFEPWQimApgHGrHwum9xdP07QtmKC4HyNpTDS8H0dUsB9GIQt3sxUguTSU3sW09f5ItfgLHrYAMn9WUnwiTvGbEa0Lt4bvMN/9Y2JeY6G182xdjsBZG1nHNg5u/eMFr0H8HznZQO8VKSqm/1B+EqVFKw+6SYiwrmdJepGYV6GDvWgc4FAXErCl9xDdPMXm9OfWFmx5yjYxIjzatLADedDbpcKe/mJakkOOHUq9rCtHGYzTb+eeZBcBJFlQjVZigZ2fiGHI0Xz8b83T/hYh8/ZBjDnwpFvv2D9ieaf+PMew7ze0tJumjqqleY8RgHvfmZg90HF7A3/E1hHuCJP1zv/FnLv4TIZkW45gkHY198Y+3Bmh0iHEr2hoxAAtWgOUe9lcRE+VcTNQ1vBeptare8nOTWaGuXHORD8y3/hlaS2XMmnthyFNCxtlhkVi2DRYQEblHDgrXzVghddi/LXiX54NO4o3djiontSGziiD2vMLp4mWx/7J+RY/N9O3ikRlZjUWGWp9JKW4TZq3DgLPGy7iQMcekKQ1TF71ZtQbAWrEIAlmN81DbeN9klN/85fgAAlQX5FRJqo+vqMruOUtd1hJN1tci4EkyjsxoOWSi68aHK8KRVjzDcdHalcnIuex7Q8+R9WPSotYJIBWhtGGdP7X7BawTtq7fmvpuzrsaeRl3Y41kLWgXEty6FrDxB9uH9OoDZLXdDPyPrltgQ2JQk8lHPZHVnwEOYHFY9nuy2dKrhSxxSIwsVASS92phyP3C3O6EAtSVKkbLDWLrRAmQFBizTgGF0SX4hX0vxLK/gLEcrgw7NsNKH49bkbuR/tCVk0EqN2A0YaBqaavvX6xm9hqmgB1/FXwMdAmk/+OkXAOCBPa74dQR6GtjylTJPTgylyBlnrD2hS/mgF909U
 lSC/VXWx
 sknXOl7xmrUIyqT+eFfU/ck14A+TPXoPrxdyOUshN0qoLaz7biAc+HPGlztOyooKjwSQ36QRohcqhdIjtKHdbL+cyWqqlPXIdqk3X6Lz2ksIznY5xVAPihLnR3xZsiZn1ZZmNYuPMR2vqj5Rjnfdwmr70IdpJIWl2GSdijuqxUayrXYPItbsQ9UaxCw3sWaYAQYt2XtgD6waFIZDraIPrG1jMPX179fBwI8uOrbmQHw1Qk1M9cz71MBFGKwmNKRvPKC4do3hPBcewB7JgwLVuqnhCmeZLNQpamqfNbVg/BJaRHOdbCTS9MlkXQ9wPcJy3AbTwRwe1soe92YOrgi1e9kXp+TQu3LTRDM2n
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
v3->v4:
------
- Rebase on the latest mm-new;
- Add Chris's Suggested-by and Acked-by.

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


