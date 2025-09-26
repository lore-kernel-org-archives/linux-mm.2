Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55D8BCAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 15:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B10508E0015; Fri, 26 Sep 2025 11:55:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6228E0001; Fri, 26 Sep 2025 11:55:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FC3C8E0015; Fri, 26 Sep 2025 11:55:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 88F2E8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:55:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3616611AB59
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:55:20 +0000 (UTC)
X-FDA: 83931850800.21.CBD4C0C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4C08A14000D
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:55:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NH0Fp7YA;
	spf=pass (imf26.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758902118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=exAyI7gNj7UeI/mRCjOesKjkeOHTQAGBMN6uMH50THs=;
	b=elyKXdP7HkdFb5vPf/mmSfQ/7quqJ/lhQJBep17HZLj8K0jsf+l2FHV9hbZy9U/uuhBpK/
	/C7oJYeA/2boaJd2AkVfHBZac0/Xyjq2xhZfcacAnQ/q7JKx4xRY2CZL2nl+wkwcbZbakK
	caRbvi6/9Ue6kXpJm6mSoo2p1kUfI18=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NH0Fp7YA;
	spf=pass (imf26.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758902118; a=rsa-sha256;
	cv=none;
	b=bL4i8No7Ct8DQm4kzi5DlVWlZxZQh03ubJJdXhfu4gtDXGpjoD1yCPYLHgJ1sEoEF2m/Do
	XaArN4/WKOTpC1QH5b6YjrIzDOB0xR1StIEvNgDjTzizeK2fUCWjcwCRneIrTq/vEMzc2S
	l28de1pKbVrTWs0uctJCGD0z611xFS0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758902117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=exAyI7gNj7UeI/mRCjOesKjkeOHTQAGBMN6uMH50THs=;
	b=NH0Fp7YAtfyIEXxTA337VdBAoCTP1Y3rV+XjlmFZ0nkgcyhgrJaOvttqlJEF3HIV8nKEM0
	l8qdF4rGjeWIFOGPcGPLnrZDoCB0HgXbrkTxxSHiceyvW33qDbLxhcAjFnhbh96LrPY60o
	rp5NmOBEfB0TQNlA2Q10bfAY7zgtBMg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-tIcUB22VPvSQZNQinzN9tA-1; Fri,
 26 Sep 2025 11:55:16 -0400
X-MC-Unique: tIcUB22VPvSQZNQinzN9tA-1
X-Mimecast-MFC-AGG-ID: tIcUB22VPvSQZNQinzN9tA_1758902114
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 32BDC1800562;
	Fri, 26 Sep 2025 15:55:14 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.72.112.25])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C197818001C6;
	Fri, 26 Sep 2025 15:55:08 +0000 (UTC)
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
Subject: [PATCH v2 0/1] mm/swapfile.c: select the swap device with default priority round robin
Date: Fri, 26 Sep 2025 23:55:03 +0800
Message-ID: <20250926155504.5122-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GcHg6yGq9GomqOA5rldR_cg2kCegUmDW7geaovB-1KE_1758902114
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4C08A14000D
X-Rspamd-Server: rspam05
X-Stat-Signature: xm5stau3d4i5jf64n6b3u6gqgmhzj88s
X-Rspam-User: 
X-HE-Tag: 1758902118-96716
X-HE-Meta: U2FsdGVkX1/WW4JKe7mwMXXEMhmynPUMedigqXxfQK4JyNZA2bDfTcZlu3W/yf3Akf5hYH1MFSDO2ERpi++07Ci6RoZPYAqfNFurxvvpwORCTMUhotNzGRQhM478uljMuCLojoALYeo9pApzstHZzlF8r1u3l3X6sR3CXZtu043XscHiny3M7GdqUpA9zSoF4OyBNxeVYyJfHpgQjbKqPnfB9yVyiBznJyl72qbVMtuPyyFGWZKQkUsOO11KKxqc7XfEZUXqqz2p69UcviTLA9cfKdRx+QwSe90EatmzZV4j8RQL/VDP3HpFRbgfCFMjm9zXSji+NUNhb1sv2fJF4Dws4/uHLvBNr9NtNjE91ZAcnGQwtq9Mp2RR9GHSGPSGyQBeY4FcdguVZkBjb1GCn2NsIWkdp2/4b9hKirt8CdBePaN9otUdgO3r7IcvWY5B465jP8Lmz/KPZgYfduTVJAXsgjHpCUPsxJbvUPJe04/Qh8jufEIjQFa1rkOat0w6ymNTYkIjkuWlBG/NJ9XKmk3gWuPZVxYZ3xOMiz1RQqRvw9KlBQTlmZTqCnw0kKgM/1uBrCv2ee2OiANABseN+RrCFjcwUAZUGIdypIZowYeE0HwWUxa+8s+mOP/IhpLtzofncwe24TI1Pgl494Elaza5hzF6jkRDtCtKPLGoytlNSaMR/qKTLVALrvmb4eE0HJpNZnNFK9UTp0FLg10KGhJRT3J51ZA5l7qsZ9ihXUc8sFYjnoqCcy1gK18CSbMY7pkJZIwWg4jL449CXbZXYu8ukDnNfLwuNoKFL7AEBpeQJrMiCGiNOxpZEX8x7ta8fmh+U1lxvQIo9GyyY/cR6+NKjOlOaM+WvKynh5w7Z+JbhpE460uQBAN6u7B/cKQFUkGdccGeNH33Z1tzz4gwv1X2+itV+JXfrQ1R3dGhQwM4h1qrtmGK5QACISTaYj31Yl34Yyim35z2iEDmhWn
 8h1Yb1Vq
 eK79TeW+8zNMPr7emPWlKFrIHWWQd35q9SkizxvF4FQefGvgRkoCU5z0FgUgx1bhUr49Jbzg1yt7sudxWTS+Ac1cnfY6ToUetIMMKf7Ud2zQaUWMK8IbuZw9oJAJWKRcePMsLte9vIAcZQZp5fR8A58ilGyykfVJYJsHKwR1rlt2LXi0vimpEF11UIxfMyHirTz2QA5+QFW7WJ83EK1S3HBVLYfEUKowVANIxJReHPv8l+UuHnANxLHpvhSb/jabq9qYbOaOA7lP+pXiH9TKImg/CfoJtfaUv1NzOy7A0p/3eJd8W8jcSmWOV9U8/oFeI8MZH0TfNwYpwqxLYEjLpgoMpQAsjSmNbYkFd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The detailed information about patch can be found in patch log. Here I
would like to add testing related information.

 On my system, it has 8 nodes, 64G RAM. So I created 4 zram devices of
size 16G. Doing this because I can't find system with 4 free SSD disk
which can be used as swap devices. And nowadays, swap, zram become more
and more popular, even default setup, so I create zram to test patch.
# free -h
               total        used        free      shared  buff/cache   available
Mem:            62Gi       1.6Gi        61Gi       4.8Mi       276Mi        61Gi
Swap:           63Gi          0B        63Gi

1) create zram
#My fedora will add one zram0 by default, I reset it because the zram size if not enough
swapoff /dev/zram0 

cd /sys/block/
echo 1 > zram0/reset
cat /sys/class/zram-control/hot_add
cat /sys/class/zram-control/hot_add
cat /sys/class/zram-control/hot_add
 
echo 16G > zram0/disksize 
echo 16G > zram1/disksize 
echo 16G > zram2/disksize
echo 16G > zram3/disksize 
 
mkswap /dev/zram0
mkswap /dev/zram1
mkswap /dev/zram2
mkswap /dev/zram3
 
swapon /dev/zram0
swapon /dev/zram1
swapon /dev/zram2
swapon /dev/zram3

2) Create memcg with 4G (this avoids noise from other anon process in system)
cd /sys/fs/cgroup/
mkdir testing
echo 4G > testing/memory.max
echo 3G > testing/memory.high

3) Run usemem in memcg
cgexec -g memory:testing ~/vm-scalability/usemem --init-time -O -y -x -n 31 2G > ~/vm-scalability/temp.txt

The usemem output is not easy to understand, I will attach my draft
script in thread for easing result collecting and statistics.

Changelog:
v1->v2:
- Remove Documentation/admin-guide/mm/swap_numa.rst;
- Add back mistakenly removed lockdep_assert_held() line;
- Remove the unneeded code comment in _enable_swap_info().
  Thanks a lot for careful reviewing from Chris, YoungJun and Kairui.

Baoquan He (1):
  mm/swapfile.c: select the swap device with default priority round
    robin

 Documentation/admin-guide/mm/swap_numa.rst |  78 ---------------
 include/linux/swap.h                       |  11 +--
 mm/swapfile.c                              | 109 +++------------------
 3 files changed, 16 insertions(+), 182 deletions(-)
 delete mode 100644 Documentation/admin-guide/mm/swap_numa.rst

-- 
2.41.0


