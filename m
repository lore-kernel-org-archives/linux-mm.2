Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30E2ACA5FBA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 11:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F0B26B0088; Wed, 30 Sep 2026 07:22:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C72D6B008A; Wed, 30 Sep 2026 07:22:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1EA76B008C; Wed, 30 Sep 2026 07:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C065D6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:22:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 31DA016077E
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:22:13 +0000 (UTC)
X-FDA: 85270189746.18.6E6D347
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf28.hostedemail.com (Postfix) with ESMTP id 63932C000B
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:22:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bgpo9RKP;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790767331;
	b=QmkLAf14mIvOKyekR2NmYRGTe/c/JkUUxxQyb9+oy2t1kqspuZBGhULYFM+R7at9xJYtym
	eOIJKRV8Y82mknabpg8ZCZuHYx7aJ0LvGEJTnKHhbQytwusNV1YiLAvM36vJbpBIwzlhP+
	oNY4P+pRMl5vlRrU08zR9VOZxSiv8Ro=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bgpo9RKP;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790767331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2zLOBQ3G5BdHBovG0b3C1voW7d9ugxt/+vc04TfSY6A=;
	b=hdA6fTa139KGTVQ2azvd0qD05cGk0VfJdG+R7XQmAn0byyJwlqPenF2UwY+k7AuZ2e4FeC
	TVfxCvvuEznMG7enjMpRME9kx+tCMGpEfR8HmIs1CRaW4DbD1sL2Psw07fPp4iVtw71Km0
	EmIql7UOVF720T+2mHPbLKFNHP5q/cc=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49fff72474fso22136965e9.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790767330; x=1791372130; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2zLOBQ3G5BdHBovG0b3C1voW7d9ugxt/+vc04TfSY6A=;
        b=bgpo9RKPUBZyphfk+t8is9P0sX8ez/KpwfOk19BJGJf66kcECUdzdW3JDd39txNCaf
         cxamopfvcZzBX9bs3D71HoKD5f62+HLe+vHQlxE0lRu6KXu0dWoA62R0X+wEi45oepap
         xpYWcQrXC0b8ANgBWl2xT1RtKRthYDi34Gq0sPYfgBUsgI8SE8zZdLUCbQ6axWHZcWlj
         1O7Is7/sGkV2vSL1yOFUMvkw7RBKotVB302RzcNGL4cDQgSSOFuIIATeNvLEEovvS0Vi
         v/Mtbf7WoO62NpxrMWwfg8akiYkD3FE1U+F0AC4gkULEd8+gnunlyaWR9RketuhCBzsR
         5/DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790767330; x=1791372130;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2zLOBQ3G5BdHBovG0b3C1voW7d9ugxt/+vc04TfSY6A=;
        b=aJrgzXNfKXvD0Ed5HKpIqSRFSLvb99jbTAABqTn5zscQ66ZcaRbREV/ezgJorZTOWC
         +W0a4d3CMNggq2z3yFqyTxuh2pmuG407m6Fp4nY+CmsDi+lDpkqsT/L7vxRlqYUDNCQv
         4zbjDk7S5b4rlRwSro7vRb1t9FJ0ihqfb/topnrMTAq5ClSktkOuSvSoBBp9gSP2Pvod
         QpfpGP6Oe1wqHyokIxSMdAUOKd8Y8MEOs2bQW1HM2Rp3B1QnvairJSqiltvkNnBzk45j
         pACc1uHz+D9GQwU+EJyyB2womsnxPz7b+mWnDoKA/F4terB+g4lmf9P/Fgcq+4iWfNR2
         ny3g==
X-Gm-Message-State: AFuF++mq1qpO2s4MpEU/WXgWV2QU0Q/4BAlLr/ola48Rm/HZ/C36QsE/
	Hny4hLpT/JjtXKnrQMipf+5ctVpLDDyumrgoEAi2midHWc+SbyBBJjE83w7kizrKJVtYn/3PRcv
	nMoLKM+LxLQ==
X-Gm-Gg: AYBFou2TiBk8xtZmrFSElIk0k+K0mpIasiRA8Dh6WlG16Q9uGXOeAGgTpV3ovYDhoAZ
	JIcUy9eTLSlkac18LgboySN8b9X2eSXjBGXnm1APnSzUtYaXsMIdAjkG6l3sNrfK1jiLHjWhvJF
	TXcM6yA7B5V1S9CkIKLr+p884YNx+u3mi2yIFz7tENNsa7nJ51RLe01ocLVtAZH98io/2ZB41jw
	qqp96FW8g+bI/MbS3mg9Gng3SvgopgwGPj0t3t3MVn0izzbPbKA+wp+II2b/HQTJepNwcwi4TQd
	2q3qWIW+H3AW5dRN97GTl3YvSWyWxoJG/hvE1Vvku1n4o+UsoDK7ZVlY4wsPxrfwUkhZ31jAZ3j
	jHt3fT0PW4L/ix9kRZhfXHQY7IQHlZxYIir1CyQMfFLNgUOcPLxWYp/mZ4RX28x5XG9VChTzrUi
	v4UgvJ5p4Oob5iXxE3Bc7/bmFMVJTaAuj52Hdm1dqjZD/lpdMRhoa6eTLUnwsRLUzJvqfyiWHQk
	Kq5A9JQCjeLQO0G
X-Received: by 2002:a05:600d:82e1:b0:4a0:313:3a12 with SMTP id 5b1f17b1804b1-4a01b1162d3mr20334555e9.20.1790767329415;
        Wed, 30 Sep 2026 04:22:09 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.thefacebook.com ([2620:10d:c092:500::6:13b8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a019740c34sm34097095e9.9.2026.09.30.04.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 04:22:08 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	hannes@cmpxchg.org,
	shy828301@gmail.com,
	osalvador@suse.de,
	raghavendra.kt@amd.com
Subject: [PATCH v4 0/7] sched/numa: stop VMA scan filters from gating promotion
Date: Wed, 30 Sep 2026 07:21:59 -0400
Message-ID: <20260930112206.205083-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: fxtt1p45wwsnad69rgpzg179bt3swiip
X-Rspam-User: 
X-Rspamd-Queue-Id: 63932C000B
X-HE-Tag: 1790767331-242687
X-HE-Meta: U2FsdGVkX1+gjjEfNcF03rcGpATwE1lCcypCCjPNtbH1o24eetDXePFvlQ2Q/35nffHLQMWjH1gwT1T5eTR1oY6D3NKocjqtId02l7a15fVcl+JxsomIoxcooA82DaTWJ7NocKX3Au6qJoWvpAEIbhbGv178Uv8OUP+DFEh5aUyl9Razuv1Jkowqmz8SGDGoise6JnoLTaOGWDQfjtdcRWxJ2SDUkMLky0jCdPCTOM+7B/plXn6kXM0b2qRxBzONWhtlmwOVFOvPk2JMcOAYbh/gGHBnbyWC22eJrTTuq5gZ7EypBwnNLkV4/r6/o6CHuJGOieK9/WzEv6n4iY730RyGD/5xT/pNGACne+8yn6IZbK6ZWBYT/2yh/HWhnbFVo3Ygc4a4PhEE/k8eugYQFwfgfXZYDlc7BsXxDKi24tZ3c+9QC11QGiKtaLx+DFDx4KOWDw+5os6TBsN4l1ZJ5CDQ54JhYHypkxsgml3orKXZU9cDgwFit5Uk5pzlqDYftIZCeqBvCX7hfGOQmH/rKGZL6D1VV3tLXGDGw5inkax8ktz31uMbEIzIn+Km1GhUFJTLZdokx7Vr1dyioyRO0xG0OidGlBx9PbT3pZ+PF31O64aOpegRgpmE0R1BaWu/Iu5wer9cwdhm7kj5DHGIQe9nD3MGgwHNKwNSLlbS0vZffQA5RF6cB8ZRBW18CJvwYwo6rnZicCR7eGN1zBuxCCbtCLR/zP2WD10WDMZb1MU8jIp8PGk4gWbcy1ZPwjiSMVu0FNiJ4rjmSRA8PJC92N+huNvmt/nOgyha2rngYyTwHcLFJ4zYSbvqq4/PqUOwDD5ObCrK5I6EzsMBfEcAXZy8raTeSxHNro7T9FtGB8YMu8w8iJJqKPGauOd0V5rG/2GuXoYoYYMC9Tzveop50pjE7Kr7du+Ugw2Uc0gZeErKAI/+zdP8anpxF+QlDoPxBCvVM9T2P2qyG17/efd
 eIPWEV6t
 e87mH6MaIDRiHrm5Fnm+j6Z9c5BK+KJxersJL5aWoSFO86LVfLslGGNIvKrfpRfSX9Xbvy3reK9KNHtUhcNV5wWC0zKdG4r0WTMJj2lx/tpf325OEQBp2BP6i1lKP//4JI0KRbhQyf2gYyoQ0WiudM2kdypsjSpzmb9QbkiPHOj9IZQbpthevnBHEnVLg+ZO6J8UBfIMhS9WJGUWLffQgnRiwB36N2ANIRg6zn6a8NbeRZyab2iEpx/53cE0RmoMSRhaaZL1+l/lGChCA7zuGQzNpsupLz1pq+2GftE/ljukjrKwhFiRI5wiBy8zYXuGBOzsHrrIDACCsZhzhpKraIL2I3njfGTPvWB12Ofocsc0vM1Ygai3snY9K7SW09eh4d8pugOI03xPNGHKDjKnb4+h5Ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NUMA balancing uses hinting faults for both task placement and
memory-tier promotion. Several filters designed to avoid unproductive
socket-placement faults also prevent promotion.

In a production deployment using kernel.numa_balancing=2 on a host
with 768 GB of DRAM and 256 GB of CXL memory running two ~430 GB
database workloads with large shmem VMAs - we discovered poor NUMA
balancing behavior:

Before patch series:
  - 150-200 GB/s DRAM bandwidth
  - 40-45 GB/s CXL bandwidth, saturating the device
  - request latency above 5 ms with longer tails

After patch series:
  - 250+ GB/s sustained DRAM bandwidth
  - approximately 5-10 GB/s sustained CXL bandwidth
  - request latency between 800 us and 2 ms

The core issue is that the global balancing mode says which mechanisms
are enabled, but it cannot describe the intent of an individual
VMA/PTE walk (placement vs promotion).

This plumbs the scan reasoning into the prot_none injection while
retaining the placement-scan filtering.

Patches 1-5 form the backportable fix set:

  1. Add promotion-only NUMA protection walks and derive private VMA
     state in the folio eligibility check.
  2. Permit eligible shared folios to be promoted to a fast tier and
     rename the promotion predicate to folio_numab_promotable().
  3. Scan mappings covered by the legacy file placement filter using
     promotion-only scans.
  4. Separate VMA placement eligibility from partial-scan continuation.
  5. Scan PID-inactive VMAs for promotion and account for placement scans
     separately.

Patches 4 and 5 are technically part of the same fix, but are separated
to make it easier to review - they must be backported together.

Patches 6-7 are independently requested cleanups.

  6. Use BIT() for the change_protection() flags.
  7. Use the VMA flag API in the touched NUMA-balancing code.

Changes in v4:
  - 1/7: commit message fix (David).
         Hoist balancing mode check into variables.
  - 2/7: Rename folio_in_lowtier() to folio_numab_promotable()
         Typo fix.
  - 3/7: Compute placement_scan once per VMA.
         Avoid complex boolean logic (David)
         Fix indentation (David).
  - 4/7: Avoid complex boolean logic (David)
         Store the in-progress state as numab_state->promo_only.
  - 5/7: Avoid complex boolean logic (David).
         Fix "sticky bit" issue where resumed scans would cause
         valid VMAs to drop out of the scanning-eligible set.

v3: https://lore.kernel.org/r/20260922182928.2199090-1-gourry@gourry.net

Gregory Price (Meta) (7):
  mm: support promotion-only NUMA hinting scans
  mm: allow shared folios to be promoted to a fast tier
  sched/numa: scan read-only file mappings in tiering mode
  sched/numa: separate VMA placement from scan continuation
  sched/numa: scan PID-inactive VMAs for promotion
  mm: use BIT() for change_protection() flags
  mm: use VMA flag helpers in NUMA balancing

 include/linux/mm.h       |  23 +++++----
 include/linux/mm_types.h |  13 +++++
 kernel/sched/fair.c      | 100 ++++++++++++++++++++++++++++-----------
 mm/huge_memory.c         |   3 +-
 mm/internal.h            |   6 +--
 mm/memory-tiers.c        |   9 ++--
 mm/memory.c              |   2 +-
 mm/mempolicy.c           |  37 ++++++++-------
 mm/migrate.c             |  13 +++--
 mm/mprotect.c            |   7 +--
 10 files changed, 140 insertions(+), 73 deletions(-)

-- 
2.55.0


