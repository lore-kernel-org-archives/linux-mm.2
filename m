Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 238D1CC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 06:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 619116B0088; Thu,  2 Apr 2026 02:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A27A6B0089; Thu,  2 Apr 2026 02:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46A1F6B008A; Thu,  2 Apr 2026 02:37:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 324D96B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:37:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4192B984A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:37:35 +0000 (UTC)
X-FDA: 84612659670.24.7939F37
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id B282540005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:37:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZOHatIIr;
	spf=pass (imf27.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775111854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5ySkwRxMWsN/b1cF+ftDoDLaCJSoF5606499RQFGjCI=;
	b=ooMH8Nntqf29OaXuEVYdEfk8DNp8IkUNrwOELY4Z8gd7U8Iz+R1DElltYsnV/7hp6micHP
	eWxqpc3pcwmq9NFnm91F45VWZDh0cpyiOpu9wdKsMtaNUzpkVq+E1HBJIPM9TxA6TIy8LP
	GGSpXpucr1HkmlHZjO889a3dLKPUY/k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775111854; a=rsa-sha256;
	cv=none;
	b=va7722UYS57Jlt08xHA6rr01R7+k4FFdX0qnfxEaEkq7CqgOFYAMg1JyvlPslzShN0Ct9a
	ZOumwuIaFMGlQ0d4ngTlomI38Lby+L9aq+AC82Ytr5OSihuj/3gXXVSTxS9ughquBWRMLQ
	op8ErWVgWgAvG/teeiWQqjA5dauuujU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZOHatIIr;
	spf=pass (imf27.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775111853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5ySkwRxMWsN/b1cF+ftDoDLaCJSoF5606499RQFGjCI=;
	b=ZOHatIIrmdCzzxxAXaop/lRF9UPMv3iH2pB8yfYrlfXXhAlhTbB6jrr1bWDhaRjkBTJKWI
	aXB2UWZhGKh7+6cABC8Z7rOwZrm6LCeZ/EN9S2huGZPP0eLXbF/oY0XecDYtjdLEobkaD+
	RtxlpnKLn4Uc+KpZ0XPsgTQgy+ImtEs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-P_vobo2hMEOZLwDmrychMw-1; Thu,
 02 Apr 2026 02:37:29 -0400
X-MC-Unique: P_vobo2hMEOZLwDmrychMw-1
X-Mimecast-MFC-AGG-ID: P_vobo2hMEOZLwDmrychMw_1775111846
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A75019560AA;
	Thu,  2 Apr 2026 06:37:26 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.158])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3BB611800361;
	Thu,  2 Apr 2026 06:37:18 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	david@kernel.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	mhocko@suse.com,
	shuah@kernel.org,
	chengming.zhou@linux.dev,
	longman@redhat.com,
	nphamcs@gmail.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v6 0/8] selftests/cgroup: improve zswap tests robustness and support large page sizes
Date: Thu,  2 Apr 2026 14:37:06 +0800
Message-ID: <20260402063714.55124-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: oZe5sBmVMLkud8qI53SExMBPbcllYaaUn5jo5O30l-c_1775111846
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B282540005
X-Stat-Signature: h4816wdb8tkygpugo7b1ikna1iyurej7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775111853-955752
X-HE-Meta: U2FsdGVkX19korVsgP0nOPVR27VE2C2S7U7/MlJGL+dQ83PKRnufO+FZWHuUTde0SYty7K1DP/WCPRhk8jGDnXgvtfPXpRr+JMeZQ+oaR8nrsImgFjzROyAxBRGqB/8yFoRuc+AFQyC88/nW5X292WgNG/liOXI5B6EuIwFB4UENk0e18eHjQqCxIplHrpmcJqusoYDoZz2ubBrKDyFBtbuUJgtRojQcDiuwWJ8Iz8XjnD5Y/cHabGTp3dm/BHyA6zJSxUy4IKPEHH4CU+xn32orXJtJNNSY6GSkdcj42wW2kmzpXSd2YxflOMaIDMlWg3JkHLBluOVdkca+Swa7UYqZgh+DIha/F2LwRvzGhOPxf5DpAd0blYrlrJFnMJ5QC/PQFMc26zmKl3gJQg8A9jh2EfYCD8z5TacdpyHuVFy8NnvWG2AWoaIe0kgJnQwNdQi2wz3REbdSd/ZXv82+ru3+ro6jArzC8SgLZpP3bFK7nddtSIu+t/+rjG0ka9hjg/8tDZ4KNz38i3O3aCZ1Xo8rQnmG8q//RrkHx6YE2ZMeOwJAsfmkaOT6p/B/Nu0VzXBgzfy94CGqiJIvSam9i+04LL+NUj/Q+GZwHvU0KzgYeNENVXdg8eGWGy5F7g4yaftf0iqrGNtHyf6jTAESVe1gXcGF8Owk7KK176P6b5JPIEk9eSvTfBCJM5dTJONdRaqyiXSBdEfSW5NNTNRzMjbKfuGT4eSyu/7+ZSYHr5nHZl1vU8BWiR3xTJErgy3n9uup/Pjm0Nn+4vZXxL8gWOXveyB/eUCdGwdZn9zdsK0Mpwjdl7MSrNPL6Igw+kbjWKIcvlNjDODMzbTHYAdAF2eQwZNWp8CqxLt0WJs22atoXW6DLm78XV4r+L14RBboUpg0zUjOayizx8S+lqklw78x2MzMWbgBzU9zXyhfGOJ7kRCgK5+gjgfScUC9itjFXmKRSCf7I9qv3OSctk4
 K6+Alu07
 8q4GPvPQS0PsUYmSeuaapT2jga68ih4zJ4+jiYXX4zINfOXGQECQhdAaARVCLQYOFTRDOH1aCma6KBLDIdtROxRxjjzLOB7QaBjQgGbrzgmX8G3chiEvZS3/RLjxWSCiIcV1Zm7lVwz+wPRwdcbmOQ2z1Z3o5XpM6Ott5nT0hgFCoE24Ic5X2pL16QDA+AXRvoxEyNdi6b7uesfAoutMKen24vi27v5P+iEhpDRP5sx6jzcUUW2Ai+TJRkdS1AQs6Hpx7nHO8NqK8n47wAE6mZagCsd1ybOlwVeCXqtZEIj+x3H7loxh0TOA4ERY6jyuSqGY6
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

Changes in v6:
  Patch 4/8: Use page_size instead of BUF_SIZE
             Declear page_size as int but not size_t
  Patch 5/8: Use page_size replace the sysconf(_SC_PAGE_SIZE).
  Patch 7/8: Adjust the code comments.
  Patch 8/8: Declear long type for elapsed and count variables.

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
 tools/testing/selftests/cgroup/test_zswap.c   | 179 ++++++++++++------
 6 files changed, 151 insertions(+), 73 deletions(-)

-- 
2.53.0


