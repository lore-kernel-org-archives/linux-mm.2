Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5D66CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 03:43:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D58080108; Mon, 27 Oct 2025 23:43:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AC46800E4; Mon, 27 Oct 2025 23:43:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EA1280108; Mon, 27 Oct 2025 23:43:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB740800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:43:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9565D14037E
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:43:45 +0000 (UTC)
X-FDA: 84046128810.27.0E70F6E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id A57E740005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:43:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hbMPaWyT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761623024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TV/OgoscSdsYdzZZTvXxbqPnbI3vY6nI+YdCenpStKs=;
	b=L9Jwj1Awbo0L2FPHOB4Rw/U4lkA+02Jk4Xl5WEi/TxaffnlfG13/JlbxmAd4rmz/PH2cPf
	A5uwZSwi/Okljee7ICsN4lTaV7xff5LgcF6womYro7Ni/HlbfoaRFM/Qj7azxSwOftylmo
	O+1oBP41jJ9x+JTs1k4qKKeLGM2/FJU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761623024; a=rsa-sha256;
	cv=none;
	b=lx8En3wkNxie4U42CFBtKIfknVnMovsP5nqrpw2DgAtcloJaDjxXknt15WVgYwg7YuG40f
	9qLO6bggqXzzhVyK5cwD+zML3woFyCD9a9X3cXJW6cfjZxMAJlMs5juFsL4KLrRykl4s1g
	N6q/sibJZLOHSAXaOkrClTgrqwR8WaE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hbMPaWyT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761623022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TV/OgoscSdsYdzZZTvXxbqPnbI3vY6nI+YdCenpStKs=;
	b=hbMPaWyT+uFn7x5a9qas9dYuNGB1t1ftTuEsKYBCb3tE2aRxUc/TmUJCKKUhNKwvvXnHHp
	1BzuYrKyIMUr50aIkn8yCBmeeCngWK96vxkoyzhiPpYcTNTKgmcqq4oc6KG6Nv0sacjL8V
	sbASx2xpdwv1phxKi2eiAZS3WHxf10k=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-348-7RdlUc29PrmaRR3vuQtkyw-1; Mon,
 27 Oct 2025 23:43:39 -0400
X-MC-Unique: 7RdlUc29PrmaRR3vuQtkyw-1
X-Mimecast-MFC-AGG-ID: 7RdlUc29PrmaRR3vuQtkyw_1761623018
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F0B51808972;
	Tue, 28 Oct 2025 03:43:37 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.212])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4ADCA1800298;
	Tue, 28 Oct 2025 03:43:31 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	youngjun.park@lge.com,
	kasong@tencent.com,
	baohua@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v5 mm-new 0/2] mm/swapfile.c: select swap devices of default priority round robin
Date: Tue, 28 Oct 2025 11:43:06 +0800
Message-ID: <20251028034308.929550-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4egC8HYj-r-AoFJhQHD2dFKyckvtjiBARYfw5Qw8Xv4_1761623018
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: jsrqgxo6wx7ww9zu633175b5p9b3zdtp
X-Rspam-User: 
X-Rspamd-Queue-Id: A57E740005
X-HE-Tag: 1761623023-980512
X-HE-Meta: U2FsdGVkX18rnn0hYN6n/2AEEz+YRVtUEDcCh8E0ktsH1gvnkIJlsNky2PWhAJu0WwiWOX6L+9nyo+7N6fhNjNHMXIG/tO4bHvuSgqgP/bmtWqveftUAVTxyHqQW8T6f83rRPVk4/fOINjx0EhMW/TGQIXTs+EZC6WqnXX6v2pHAdCHEmjPEtUnBA6JdkZ/EbChnwCEoz1+84w3ryNYhnboAiHPMSLzYwKz2fTYPBWooSHiyxD2/irM3VYSDDeHe1kRFHi4joC5dXd7ZdG00xwLrlsxvLqlQKePCVlm6dNsB5YGQ1QG5DFsyBz32ZHrPwO7Cu+Km48dkzWpfzrIzYZFVnMRLNS2g24yomxf8bmWA4bp6R3FAVAfnF0mmFv/N/osokSyL+DTlF7s9PjI7g6soGDlR1kSSzN/GAOUpY5wy97S/22Fw58A4USTJzx0gPSj8j+watJSkW8z0SYZBMz9RzhwM2hsIpTeQyI8+Tul5QqJC43pitCOTPlcv8YDHvPIaFcch7loXiDV8Sy6Os1kSNLSKbQIeIkSDJbDABdyLYJ/dCBuvPWOdcKkEYJiDfecFoEWjLcmjetR4ZJkxucP7qS0r61ENpUoqZyv9bI/w7iWf2YY6uL9/q356PvY0T3uvsJ0FuWwTIt+XQIwyglo2dHpJWgd3kgiuVNONl4pJ9gHRpfG+rMccYWzlnpmvKSHOBlZnKCz7rw+pG1Q40IO7OEEb/H/jsJX8RJwal4WTHMsqM30DgbgggWdLbd4EIV3/UZJGqiJFdcLUcJluUvRYC/XfWZQKk6dkFzOUBogC8LPo+eWUd4KXt9yZupaQP0SHe+gG3GR1/CrkPueP4G6F3cmWuTXMZRf2skLrOq0uVa9S4lAp1WIDvQkUOGZFpl2zzW6OQfFBa0YRp3jd16w0VwU0kVYuCvQvwAU3hiJKEn1UHmVcZg97nYHdlVKYaxbJB4/aoTpWcM4sVWv
 kxOOVHYJ
 HLQU+jy/gdI4V1+GcTcMbXI0nXzE/XUTMRysmeL0Vj9NKYtZXahsY3tkUgQ==
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
v4->v5:
------
- Rebase on the latest mm-new;
- Clean up the relics of swap_numa in Documentation/admin-guide/mm/index.rst.

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

 Documentation/admin-guide/mm/index.rst     |   1 -
 Documentation/admin-guide/mm/swap_numa.rst |  78 ---------------
 include/linux/swap.h                       |  11 +--
 mm/swapfile.c                              | 106 ++++-----------------
 4 files changed, 17 insertions(+), 179 deletions(-)
 delete mode 100644 Documentation/admin-guide/mm/swap_numa.rst

-- 
2.41.0


