Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14F06109E543
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 03:27:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56DE96B0005; Wed, 25 Mar 2026 23:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51D456B0088; Wed, 25 Mar 2026 23:27:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431EA6B0089; Wed, 25 Mar 2026 23:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 329726B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:27:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A97121607DD
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:27:18 +0000 (UTC)
X-FDA: 84586778556.20.258B48E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id B6393180002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:27:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SL6o6WWu;
	spf=pass (imf24.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774495636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oMwBuaz6Iu14n6z5uHUzbEMEARV0sTaqUzLTjM5uB7w=;
	b=VPLO2yLYLovvZGQEJ3Waw59vpTX+ZK/WMUwUZknhCz8NDMFTult72Yc+gU4+HXidu5ezoV
	ZHrPpnt7ZPpAjlEp9ClJ6AXwclCc/sSCYBzl/bXQx3W1HZKNUxuRsFb8QVX37wqEUlMhke
	FYvtKqdCfgKGnAe6GOUAYOBdN/lA8bg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SL6o6WWu;
	spf=pass (imf24.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774495637; a=rsa-sha256;
	cv=none;
	b=kig/9nTYRRitHXmFUcZo/S8SCVGuaOoUyt25Y44GJS7PnFw+84eTaB5Rpw+z/cCu0uezM5
	I35sTuN7dA/r1TSy+/LInSpLgBsUr8K/ooviTz6t8bfFlp8vZ7K5dMyszYkXYEnbQFwyuU
	3vSTUL3EYQRm9T5yU8bA3Dc3Az+PsUM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774495636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oMwBuaz6Iu14n6z5uHUzbEMEARV0sTaqUzLTjM5uB7w=;
	b=SL6o6WWuFBvcfVOJ4zb5ypdKmNwiKeLk1qx2GUec5Rf9QlXhtKJqm96UgrzmdL/6YiDa2y
	gH/YMyaK8dYYoUUykcn09HFoEryvcd2NzmyVZyy7sXhp5MD725mvt5DWRUQu8+lpX0x4tK
	yJ+8seRHn+czl+QAfgFRBIm2b4TWJC0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-179-ntm5MVGbMGCvlJZ59BK7TQ-1; Wed,
 25 Mar 2026 23:27:12 -0400
X-MC-Unique: ntm5MVGbMGCvlJZ59BK7TQ-1
X-Mimecast-MFC-AGG-ID: ntm5MVGbMGCvlJZ59BK7TQ_1774495630
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 095051944F05;
	Thu, 26 Mar 2026 03:27:10 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.83])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 21DCB1955D84;
	Thu, 26 Mar 2026 03:27:02 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	yosry@kernel.org,
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
Subject: [PATCH v5 0/8] selftests/cgroup: improve zswap tests robustness and support large page sizes
Date: Thu, 26 Mar 2026 11:26:50 +0800
Message-ID: <20260326032658.96819-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: lcIiRhayOoCatGoH7o6CxL6mUhH9JfTFiddbD3GLJ3w_1774495630
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B6393180002
X-Stat-Signature: p6xc4igssuu1uot9dkjrt65ts7ebw3st
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774495636-517353
X-HE-Meta: U2FsdGVkX18VDSVzkr7dxBBSvGvGD6Y3zzL628qYM+wP9gFCLRH/HcZbeVwJheOHhEStiexUkwo9bxuXXPO0LhshOudSuAHYtO3DnLiDAaZAhb9Uh8iBCNzAxpMFOWg8h1GFvV4hWghTg8kN12PNdR7JwQAkvcXHYl0Q0gRjGIon9et9URr7iuYGU3vGc+V4Y95GcYaOdbrt5QakQiHJoeGfNVvj7b1ZZaBnoi47SYOiJKmXVJK0kTHd1MUMRmeYUP/N2Iv0jyfjzvwHLTS/mxooHe2TVL6ne9RmRmfwDeI5icgh6MyCrPX0Qh05+mDAPJO+vmNq5z//GuE+ebOxSVzaVnrBQjSvE+k8vfyDiDn8Wya784dm5ZY4WkPiDZOf/O8oZT0PIDzjEtg/0pvj8gwv60M90abNoHCgLPNg4VMhQ/1Jia8OiZklmrweLqODSje9BtYfr8OkTf5BJsOONSYuFxhTGMgBKQZ5wXgLHMVMppjVvYnM225SGEaynHdQybqGeyIEkcFoBTUasj/iIyqKtPCMP8giz5huAuOBB3CDN1l1oqFFMut5qrJO0l4loStifejSiAs77Wll9eh9RO08KQMHgDvnGCdOE/dunNr3sNyDyrw0hzQR+nhzxyBGDi1nuZaZkmLLjqRCw5MDwSO4gVSC+Xfvd3MeWM12IPN4Gvqf25VVfV82qZCld7E6sbNocogeea2VHautQdaRwaKwLo9dBe7myaDewHZDKWb5L2s+icEuCsB7NNVWAelbTJOyUcwVuWyXBOPq1c9nIhOlWy2kDWrZfX743CKp7isvrwqfetbwHv8MQF/2ZWaFlpEShqZolKmyZNUWU02sYlORQxkJotV3Gznz9w5yunDZePAVjKyE5EoYyitRHOJt7ezfzyu2XY0ODy2XTm/5nbe/0HZ9YOHx+45napL6kNKsumA+tzFAbwxSOPtDk7XAX/ATh5615R1Ynb+J0aA
 tERmAKCu
 jvBAJcEj4AEnT50rIyvm7pjHe2ly/5rCcNNnfXnbitbXVMRmgXg3ujv1vwthHakZoqe9F3FfjEQUl+1v010g/iZMNXq0dj0lHlx5BPZ3LhR24KSOTC1UzlKb6yVD0rtoqWse6kKYR/TGaCSyE67YmC44z7gORxrNoQQ7/tHllI02mJwgnHMJrhZ6BYWraY/jdk1mmRG9jVDaeoeZy78oE0IxL9/NlNfRSPlxf+aAdmO1INqHijkXHenhrMDegY8llF7xa8PruOfypbI7qfnwBq1avozvsKJdojkRZKp7t+O3VCmnu43GsTjTrc2l/A35Y2Cic
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

Changes in v5:
  Patch 1/8: Defined PATH_ZSWAP and PATH_ZSWAP_ENABLED macros.
  Patch 4/8: Merge Waiman's work into this patch (use page_size).
  Patch 5/8: Change pagesize by the global page_size.
  Patch 6/8: Swap data patterns: use getrandom() for wb_group and simple
             memset for zw_group to fix the reversed allocation logic.
  Patch 7/8: Setting zswap.max to zswap_usage/4 to increase writeback pressure.
  Patch 8/8: New added. Just add loops for read zswpwb more times.

Test all passed on:
  x86_64(4k), aarch64(4K, 64K), ppc64le(64K).

Li Wang (8):
  selftests/cgroup: skip test_zswap if zswap is globally disabled
  selftests/cgroup: avoid OOM in test_swapin_nozswap
  selftests/cgroup: use runtime page size for zswpin check
  selftests/cgroup: rename PAGE_SIZE to BUF_SIZE in cgroup_util
  selftests/cgroup: replace hardcoded page size values in test_zswap
  selftest/cgroup: fix zswap test_no_invasive_cgroup_shrink on large
    pagesize system
  selftest/cgroup: fix zswap attempt_writeback() on 64K pagesize system
  selftests/cgroup: test_zswap: wait for asynchronous writeback

 .../selftests/cgroup/lib/cgroup_util.c        |  18 +-
 .../cgroup/lib/include/cgroup_util.h          |   4 +-
 tools/testing/selftests/cgroup/test_core.c    |   2 +-
 tools/testing/selftests/cgroup/test_freezer.c |   2 +-
 .../selftests/cgroup/test_memcontrol.c        |  19 +-
 tools/testing/selftests/cgroup/test_zswap.c   | 174 +++++++++++++-----
 6 files changed, 148 insertions(+), 71 deletions(-)

-- 
2.53.0


