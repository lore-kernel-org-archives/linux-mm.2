Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 504DDFC72AC
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 06:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B357A6B0096; Sun, 22 Mar 2026 02:10:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6846B009B; Sun, 22 Mar 2026 02:10:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FC616B009E; Sun, 22 Mar 2026 02:10:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F5E86B0096
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 02:10:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 432351A07A2
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 06:10:59 +0000 (UTC)
X-FDA: 84572675838.06.1D94CDF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 91D341C0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 06:10:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bcB9Frvv;
	spf=pass (imf18.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774159857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mmx1uB1Uw/n7cvvAu9S/82zt328oIJIEVRjtJB16IPI=;
	b=v4PMtwCHgL3clycNR/e2k9RP8FfgEsdShqgcn10ZwnUx3cYhfLp4RWjFzjmxjEKKFX+MlO
	I6GiTBE0/eNQlHOK5WdsAJWL8reYYjgyKM9s/SKycky2ftflrD0iFjEHoJeotYI8TJgFYR
	U/7igEGlIPI3K/zvTZuYoBxGY5oNoyI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bcB9Frvv;
	spf=pass (imf18.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774159857; a=rsa-sha256;
	cv=none;
	b=JuXtbmyLfkm3IDtldjvED1GOVRUnEXoxDFCk3SlS2qyO43wdkrPVGXsWdv0i3d1+Q7SJXl
	BHxINxdw7xXfCcwnHZ4G12LM8q8KUIVomvG4UaBtKgmH4uThBJZdf8XnVLg3c3nSvgSeWz
	yZT8prp5m4hUogscwytc4BT5YK5KWPw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774159856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mmx1uB1Uw/n7cvvAu9S/82zt328oIJIEVRjtJB16IPI=;
	b=bcB9FrvvErT1N1cmI5dfKSucIp/cwPS3cups0HZ6vNqf4U+8wBMx2sbZkMoONk89aB4Ho7
	GK+ycSOWmjLvWUUDbQY8OGM7/CK1jdU8X2GhFAgwvlgtrBxQBw5c9yjJRq7S+u1Kkm+BAX
	PK5/femP4wwS+wz7DWQVq4q1wUEQ9bw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-637-ZOPxiDD-MBaUoeesfdrK9Q-1; Sun,
 22 Mar 2026 02:10:53 -0400
X-MC-Unique: ZOPxiDD-MBaUoeesfdrK9Q-1
X-Mimecast-MFC-AGG-ID: ZOPxiDD-MBaUoeesfdrK9Q_1774159851
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6AFEA180044D;
	Sun, 22 Mar 2026 06:10:50 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.34])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 01C161955F21;
	Sun, 22 Mar 2026 06:10:42 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	yosry@kernel.org,
	yosryahmed@google.com,
	nphamcs@gmail.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	mkoutny@suse.com,
	muchun.song@linux.dev,
	tj@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev
Cc: longman@redhat.com,
	liwang@redhat.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 0/7] selftests/cgroup: improve zswap tests robustness and support large page sizes
Date: Sun, 22 Mar 2026 14:10:31 +0800
Message-ID: <20260322061038.156146-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: aIoyvnfOMvwqRRL3R8L_4I8hDbgdCQtvm8yHEYEwyjs_1774159851
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 91D341C0005
X-Rspamd-Server: rspam08
X-Stat-Signature: txkwufr5xxcm4qz31qpogsswuuw4y39f
X-HE-Tag: 1774159857-429071
X-HE-Meta: U2FsdGVkX1/Dru4zi7xvoCKQZzXQhbu6nIx4B5uPq+NM4nICZK9fBQYJSVbhQSgd7Eu/myhxGm+kp0Zl2H1rm6GSdDfo62/bMoPxaDabYqzEmh4Sz9veWLKsprhFuTTcAQKTiAkdd+mTSEhySaDE5HJ8+/LlZuSlifA5J8B/C2QZqXVka5S7C7ZsaSt14TbDVGnkgf1ECD2psSQ1P0JSvVTs1u5KNLR723FAnx0kzG73g66nMwRD1DccO4V7BdvkIXAcwEPkuOdRUDIg8EVuvwf900TjQgRjEWlo8g9EIKztAdHH471mLP08KmZkGDoBx3yhPqd87kkvw2ijpdE/qdJj/2ng/v1X0ErZQEf05EHGhITMLZlQTxaNcgjajz4AJ//lg43H/gfPL+GdDidkL0EtsCpU6sh4MmUySvRZLUQaj8gQmbHM9rG7aolqvds9UMIoJN3d1RginQymsfzJZwuPGT98Bxtzo4onFy2aCOxBASqJE/YoJTLqeP9GthfGMHtL4i4TDnIcHZHPkN5Insu7dy3d92nmZzfNFt7aczfTaLW2HL9XD3M0NV4ASfwP/R1icCZZS+pOlR1Wnwpz02yCzSuDTaSiS3QzFZ81Y9Msiitefuvur92P55wG0m5v9X9RQC/owBxr5unZPJP/LwjHUll/BEF6Ux6rFUlf6BKCNhYOFHjYA46RcNsTKmaz9chOVmv2bYFvEk8D4heNXKwPmi4rGux1WUoKZ2Wf9fpDbmRK/8m1F6kUyNzWTgZZy9tQAYg3jcRqWuxAw3A7x4esySIWspu3RDD+vrIL89Yz1AuKPfxX+xs2M3hOTIVM1vFqllnCJwjJLn3uTV9brp82rmleji8bZRnM638/dlrcgstrpw25SANHS6UYO21rvTWv8/Xu+vRh3L7ss2+eeBDS+ZH/oDLwAfObN9IQFymu2GgS6Uf5Wp7OQEd4bd0PrxPgA6qAhRsHJvpkvfb
 dcYY7eoj
 96vzyxA2Tx7UCKSRV293/s9v6SA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset aims to fix various spurious failures and improve the overall
robustness of the cgroup zswap selftests.

The primary motivation is to make the tests compatible with architectures
that use non-4K page sizes (such as 64K on ppc64le and arm64). Currently,
the tests rely heavily on hardcoded 4K page sizes and fixed memory limits.
On 64K page size systems, these hardcoded values lead to sub-page granularity
accesses, incorrect page count calculations, and insufficient memory pressure
to trigger zswap writeback, ultimately causing the tests to fail.

Additionally, this series addresses OOM kills occurring in test_swapin_nozswap
by dynamically scaling memory limits, and prevents spurious test failures
when zswap is built into the kernel but globally disabled.

Changes in v4:
  Patch 2: Use %zu format specifier when printing pagesize.
  Patch 4: Use page_size instead of BUF_SIZE in test_memcontrol.c.
  Patch 6: Print the expected swap amount in KB instead of MB.

Tested on v6.12:
  across x86_64, aarch64, ppc64le archs.

Li Wang (7):
  selftests/cgroup: skip test_zswap if zswap is globally disabled
  selftests/cgroup: avoid OOM in test_swapin_nozswap
  selftests/cgroup: use runtime page size for zswpin check
  selftests/cgroup: rename PAGE_SIZE to BUF_SIZE in cgroup_util
  selftests/cgroup: replace hardcoded page size values in test_zswap
  selftest/cgroup: fix zswap test_no_invasive_cgroup_shrink on large
    pagesize system
  selftest/cgroup: fix zswap attempt_writeback() on 64K pagesize system

 .../selftests/cgroup/lib/cgroup_util.c        | 18 ++---
 .../cgroup/lib/include/cgroup_util.h          |  4 +-
 tools/testing/selftests/cgroup/test_core.c    |  2 +-
 tools/testing/selftests/cgroup/test_freezer.c |  2 +-
 .../selftests/cgroup/test_memcontrol.c        | 15 ++--
 tools/testing/selftests/cgroup/test_zswap.c   | 79 +++++++++++++------
 6 files changed, 74 insertions(+), 46 deletions(-)

-- 
2.53.0


