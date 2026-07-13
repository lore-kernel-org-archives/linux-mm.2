Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F58FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F08F6B013E; Mon, 13 Jul 2026 13:15:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179CE6B0141; Mon, 13 Jul 2026 13:15:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B7476B0142; Mon, 13 Jul 2026 13:15:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 816246B013E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:15:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6EB358C552
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:15:38 +0000 (UTC)
X-FDA: 84984405156.29.CD41262
Received: from va-2-112.ptr.blmpb.com (va-2-112.ptr.blmpb.com [209.127.231.112])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2F0662000F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:15:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Khehaob6;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf31.hostedemail.com: domain of caixiangfeng@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=caixiangfeng@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783962936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EhzDAb+qkscwAvcITNaP5V9HM6bbzYTebqCVp/u0Das=;
	b=NaKxe6YvrOUejXDNlMJO6OwjZfSwUP6malIoEwGlg6iPIZhOMGAu3yG3KWakb/IdiGCXnp
	kP0Y2CJzBtOYesSj82aCj8mU/3A4TmA0o3z/XIzvGwyB/Yeva2j9VQbL1rdq92FVNiHdEV
	xo882NnKMHO9FaFN3HYioUEPVCiy8CQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Khehaob6;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf31.hostedemail.com: domain of caixiangfeng@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=caixiangfeng@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783962936;
	b=GvQBsTaosVaaacpSvJknERB02enRN1hdaIsjrCr7rbw+nWXGtRkMMBLoe/h3qpKbh+xWET
	/wmsV99G48uZ/+VaphjLfoqYSRNGMiPsOt38CUTQ2Z9exH3LjYL4lngZX/vWhccYJcguqM
	V2FLGu5ZT7s/OPm4DEBSzhv4KPcjuM4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783962927; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=EhzDAb+qkscwAvcITNaP5V9HM6bbzYTebqCVp/u0Das=;
 b=Khehaob6LPz1vMbZZml9mIzXEdua6amPZRCHABizJ0WRi/jJeTfPbqY7ElukSqPH/6/vzc
 H6wtWLqEatIiagKxRm9HfWzhGm4YS0YGsji2Qa5jZ4WLbEey39BjzE2e8pm+kxvVxlkqia
 jbjZ1N0uP06nIeo8a8UQio3RqlZVxp36WzaQE6z4rm7Y/5JZyMK8R5y1mvAUxkvgq9MZU8
 b1LYKNCnp9MPpLxj5yJE+oRg5Sq7A7nx6QKqYo3mJ5Fj4LNfC7FZQUKtcXwcS/gj8dfQYC
 6Z6wZzPSTUcNzGqAi3guD/nBHucXtTxHBwQpn3KyGelmpA0Is9HQpLdLFpqyeA==
Content-Type: text/plain; charset=UTF-8
Message-Id: <20260713171456.300518-1-caixiangfeng@bytedance.com>
X-Original-From: Xiangfeng Cai <caixiangfeng@bytedance.com>
Date: Tue, 14 Jul 2026 01:14:54 +0800
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a551d2d+1f9454+kvack.org+caixiangfeng@bytedance.com>
To: <akpm@linux-foundation.org>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>, <david@kernel.org>
Cc: <caixiangfeng@bytedance.com>, <richard.weiyang@linux.alibaba.com>, 
	<baoquan.he@linux.dev>, <shuah@kernel.org>, <linux-mm@kvack.org>, 
	<linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<stable@vger.kernel.org>
X-Mailer: git-send-email 2.55.0.122.gf85a7e6620
Content-Transfer-Encoding: 7bit
From: "Xiangfeng Cai" <caixiangfeng@bytedance.com>
Subject: [PATCH 0/2] mm/hugetlb: fix list corruption in allocate_file_region_entries()
X-Stat-Signature: pahbb5ynajeh8nhiusy9emuts3n46rjw
X-Rspamd-Queue-Id: 2F0662000F
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783962936-89259
X-HE-Meta: U2FsdGVkX1+i5ry5ul4qPUxCSq7gnb9k0UlN8jY0BABmUW5b6ypV3RG+dooNTnljTIANY+Cf601FIwoA7cgOEwhowPKqr62y9OKRt/8X2J1jGFe6JyiIHOqWQzDlKywnAAp4sXbn89ev3rd2gyBmtV0Q07I10uRe6rvQNSk+YIoWBQrnHAXSm5n/JS9j1oCn4wWnZuuaIhv7kbYEdc2mRspwO/gAlXuuGzXnIqzqtZ6jsUoHvXx0fhCvyEscuoXCTeHKFFCdL2rbgwfgHFKDiDMH6/DTC0wDR+JjBsBQ0SjGkn+g/S4WITzImR5Fht4msk0XfmPizv8SA2PtEG9IFHvhFakyTCylbhJ5jXIEYrLfRr0i9IBMhcBpmm3UL5EKZR4c236xpd04Maz2BaBy0dVsYZ8mhlxaKG6T6NvdpQIcF4/eYwjuHbMEb/vpwwXj6PTuaq+MnHjUAzuQbRHrlifFltdz0aDxorOO03Q+DAfE3Iu1ukebwP4MHlzUz7ublfGcfI5xwVlAGV2vIih0KSpEbzM0T2H3c0FYLyKAagi3ZaIUX/x/pB+9wTZJ3qYVEY4s+NmEJ7JP5hOfPWr0Pfzi8i2ltFARtO5STWBkii4bfHSX7GeQgQ6JoN9cfbY5aFBLUJbDlmjXjqFTDYfSoeqZRpAHKtzZSB8/44iSn9Vjga7Ux2w5wfhRDFImscXoUcdOwX4ZHolCBGR4d7e+mrk/8lirLBCqPGulGLUvmssG+AHq2Yw2UdljGeIAkNoZhD3lgN3KhzY0bFJNUgBrRzPlUjTNvkcZKFsq+LuZ472/Nhe8d6W6Tcl5+n3BWKg/T7KsZV5KQ8yQ98J9OZFn/kVfuXLz4x74omAAe44hnfxOLy7F71r6Ff00UsuB3oF8HH1mEBpzO2sQWxnmMLppcyu/ezGpeYWA3736BEMQPOCVsIVZ0nKEaz+lWgzOrWnJ2+kqNriYiU6IdYtxpnx
 7BvBASld
 +95d4qn93Hkgw+mxjocPUH3dm9+jGuwUqtKYJMlrghNYfe760gl6T+mnqD4PbebCgNbg5WYJ0pHkZcIRnivY0KOriEar4f1FwTCHxH1/8+Dya3QlhvKGtTeFf2EM0BILwE2lWu+SWNccGaqLZtvYlhRA7P7iEtPu5QTxc8n2fpYXFmXn+Hx6w6/jNlE+l56iPP/tOx4kxjg4HKFFJNYDKfipiFtt5D1WJ2t3yON2qPSOI0V/vNuH7wwdsKjbbo+56yrGNoNykGi5iJbNnu4+mzdWLHTRNZiVIrM0SsKpsahMR8cK5phdSVoNaPo4c2ScrJBVOYS24DXZsgEr8Sgd2R/UHOLJKBIjnQtTlQjwr0H/hlTYaguiJpwqjW41/zy01Kd5c6JGuu+Uc2gY908PE+pEzlmkQgs+bREH1v4/pBHyClp9yqvFIucyAFiF5ffLk1yfl8HvXFInAwbSytPF9PZZkY2PPlKdDRqAtN1t7pSfJZGY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <muchun.song@linux.dev>
To: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org

allocate_file_region_entries() refills resv->region_cache with freshly
allocated file_region descriptors.  It allocates with GFP_KERNEL, so it
drops resv->lock, gathers the new entries on a stack-local list head, and
on regaining the lock moves them into resv->region_cache with
list_splice().  list_splice() does not re-initialize the source head, so
if the retry loop iterates again -- which happens when a concurrent
region_* operation on the same shared resv_map consumes cache entries
during the unlocked window -- the next list_add() operates on the stale,
already spliced head and corrupts the list.  On a CONFIG_DEBUG_LIST=y
kernel this is a hard BUG(); without list debugging it silently links a
kernel-stack address into resv->region_cache.

This was observed as a real host panic on a dense KVM host where a QEMU
guest-RAM hugetlbfs file was mapped MAP_SHARED by both QEMU and a separate
SPDK/DPDK vhost-user target, generating concurrent region_* traffic on one
shared resv_map.

Patch 1 fixes it by using list_splice_init().  The bug is present in
mainline; the Fixes: commit dates back to v5.10.

Patch 2 adds a selftest that reproduces the race (opt-in --trigger mode,
since it panics a vulnerable host) and runs a safe single-threaded
functional check by default.

Xiangfeng Cai (2):
  mm/hugetlb: fix list corruption in allocate_file_region_entries()
  selftests/mm: add hugetlb_region_cache_race regression test

 mm/hugetlb.c                                  |   2 +-
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   1 +
 .../selftests/mm/hugetlb_region_cache_race.c  | 315 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   1 +
 5 files changed, 319 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/mm/hugetlb_region_cache_race.c

-- 
2.55.0.122.gf85a7e6620

