Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C1F7C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 18:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F08C26B0098; Tue, 22 Sep 2026 14:29:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9756B009B; Tue, 22 Sep 2026 14:29:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D81356B009D; Tue, 22 Sep 2026 14:29:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEEE16B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:29:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 39AE580564
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:29:34 +0000 (UTC)
X-FDA: 85242236268.11.E99C9F2
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf14.hostedemail.com (Postfix) with ESMTP id 770CC100004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:29:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dDnSvIGw;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790101772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AOswCkwwgcwBAO+R2zWSvXVx/mcY+k3pNgoQsE6AHHc=;
	b=OvDUm2H5385C6ratY8AEP57w99Jbj2dClvhg2Tf2PDjtMzNkSlzehuqAK0uTiURPyFOJPt
	5HWUCLWIHDmnb08j/rhidOmA8AoIj7SVx/GBM2fV/iWZZCHVhfxXmoN9QZS/lwG9b9OVKf
	n2k33mfFLfdLwxRKjtRNQb9JZSfmZE8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dDnSvIGw;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790101772;
	b=mB7QGblxz/R6zB6YU6UN+t9X6LO10fbnka5qQykVglyO1mHlJaYEJZMAE5IMeSTrtkd8hU
	zuvccUna4yAqDXZOKoi+lLptceH5zxM+dMvbHGurUzV1WNdU4nKZWAFeYO27VKMgxh2gds
	D/zjDDSWEBPx/xb+DkhprO6FOdETPyI=
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93910c9ff1fso20799685a.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790101771; x=1790706571; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AOswCkwwgcwBAO+R2zWSvXVx/mcY+k3pNgoQsE6AHHc=;
        b=dDnSvIGw+PLMAnqes5EVUNX4CIPYZrVNc4khRTi/M8oLEgfCf6C8DLD4iunHwq/x9O
         y2yd16DMxBmCOzFtSd2qORQIh27XAiYtx47xlPKHkeQRgbRN7+Gv77OpJmVxN/q8fTDr
         k7836aCtqk1dDDdpcFFbk4WCgU7lP/FprBePuRnHNSE9BDI+fKd6GJOjoxTJL2Pa+p+4
         huhl23smrfiwOOXr5uzOMcyGseO8B+wqbo1T4Gg7ixrE8ZXWB31X5nU5P2X9YED7Gb4S
         gcNYpoN0lpdwzQgkx3KnC0YsOol1g7AXc1vvvS2enUYQb9Y2x5BWVMrrMjV3Y3fFx+QH
         WE7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790101771; x=1790706571;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AOswCkwwgcwBAO+R2zWSvXVx/mcY+k3pNgoQsE6AHHc=;
        b=Jp4e1wyM1TNgxu13On+ofw7cctm3BcNPV5kAkA4WlqAvrxQSRmHtiDZgEog4ckSWVf
         uLD5kZHy5N/2iH0Ut3u6RFoMHO0iuB0oIPc8vzysYacMkL3gqNdCSb22p6T8ZtJFG699
         XhabeWRIoLmnmV3M4a3jxqDFmPThiRC+dRo3ugHp2/QADqAvPiq8kTPZYYdW6Fa2o3fb
         26epJ5OhINZxrUKUpY1V5AEoTHb87Pagw6azDHTaaFTOX8cW0ZV7u5x5UTlf/6tCrcrd
         LBwfRGPqreurJDrPKaJGy/4zs1Hft9wJffgT3E6wO8vMjzjO/yDy/yZ+6D7wREFtCzUk
         10sg==
X-Gm-Message-State: AFuF++lWVLcxVgxKddUtdQbqOyjAfyEg1rqsY2ja6ws/vYeDDDrXJKJU
	QiaxkEwy0iPukGJubtUewAUo6m0wsz3vu2jeyT2MQuqBLIn3/gYGIZEu6M13Ar/R4a/hWuzpp73
	pV80I3Ds=
X-Gm-Gg: AYBFou35zEPFJgqw90SZD2oB/gf24qlCEfa619jPTn6fsmJeeW2XIA5WDOHcc7iBCwI
	Z+dN/qhdY3Q1c7YaBDod6xtREUNfJ2bEMnlR5tFS9gK6JVYQVTC4LTQtzxidKTf2cUJGAObn9pv
	WPEGCkFqZ4MM27sPnLEb5Xzl002yzrd0jfDEKfZ8iz9Q6TcnXRVwAA0dOaKE7MqtrImq3CRPl8a
	HBSk2/DJVqjzncZYWExaKwmFJK9pyVBnjZZnPNxqomiPGLD9umzl8lr+d959PJjfEKx+tq4nkZL
	uU85P2zJLC7Oy1giosHwjZdMZ+nEJq+Bu5lSqi34ylLnNZ0qeGrhhmB4z/SH6bindjMN6cJaokX
	tpTG/S9egOYj/87EbKed9ytZL1snktXKqD0j6B6ictc6S+zWckaS5AGu14dgyvWmKDBH6oqMpGJ
	faN6mhy6LYcPyd8cPz8vt2djP4PyGiunEkA7gqvdBmaSe1tn69ICUOFSpNLoI+Or7yDY4/HStUt
	BgiJMRYG9PbIx+SvSw5MrpfaSGlrEqhVgN7DcIZrF6Y4yRM2llpqBjgT17NBz9sHKmwPkxt
X-Received: by 2002:a05:620a:2993:b0:93b:d7a3:45cc with SMTP id af79cd13be357-93c251f453amr37224085a.53.1790101771541;
        Tue, 22 Sep 2026 11:29:31 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c24889ac9sm37130085a.27.2026.09.22.11.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 11:29:31 -0700 (PDT)
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
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	hannes@cmpxchg.org,
	shy828301@gmail.com,
	raghavendra.kt@amd.com
Subject: [PATCH v3 0/7] sched/numa: stop VMA scan filters from gating promotion
Date: Tue, 22 Sep 2026 14:29:21 -0400
Message-ID: <20260922182928.2199090-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 770CC100004
X-Rspam-User: 
X-Stat-Signature: xowkh68rfz1xmsekedwqpz1yikcuxfy6
X-HE-Tag: 1790101772-459237
X-HE-Meta: U2FsdGVkX19jGgCRonJhyje4VuLGCMx+qAsJ3vdMTUxuBxmYpy7y4Jqn1cz45tA6F+jEXt3O4OGQJcggQKNaTnVHOdp+j4xs0s+H8nfD6q4ejRn3zol9nA8goyftTAUiXxTkGvWJ/9hOs4v4VTs4apxlgbu7xZsBvNrSOifuQTL7LDEye1A5J1FYIA6DjL4G+1pXXjkVsPcOIGbat9ub+iZpCFc/+82hciqSqW9fgtMFUyXimr0lfuJ83fvOJXYBsuP7Ynrg51rTjxkASvub6owaPIKM19FbZ+e6sR8oxWq9KM1KErj5srCFIqnYO9kXK6ZaV1ZYMPzk2KgQUCu5z5aHa6uafHB8uX5AZBFWiF9Vm9VkivKpi2b4tzWH8VeaNmtaIF0XL8KZ/b9Q4SHLSkvAxPkfHJGuHImUXwPW4s8GSu/ukNTkD9TmN2+K7hCTKMMVCEeKtwPJpqMNHtlOkG4hEm4owaZqVPNKACKtlBnJS8z96oTqgZ1yR/6LBi7Z54yLavbeTaoFS/+1azzPEwoA3g/vNjnAlDp8bbS1w+sJYFc8qNxdOhFXNJAt47hZYoIFfB59wjwfx2l83rQmm0f7rgrCFq3hbPZG77+UVMZOzBsabJ9ghpCKWMZC0zkxWa3VgEinXG7k2CnWJ1ta6ZCah8919HwmUI+pS/Y6Xvty3abJDcJewkwMG0LmNsSiv8RhtHMc1ADiU/79Fv24he08qAANZZbIUPHDur+eNOKbK/Nna8Fb37JT2/GTkMESlEtHsbiDrcCvqLrZks1qhalhq0/lRuVVhqZxenCuPKDUmEWoHbVwjpCh+SdkwfErn9CHlXL12keZiX4Gwc2yrL4w74zIi80508RVbCXndwvvB2cggmCUCzTfmf1n7MNHX7k8ZRksVmfsqAHEB1F5GRgeIIajsk0FTXNpqJwdtbBLMr55yDS3PbMLTmvR3WUm5w4F8BN6qvyu2hV+TS+
 nY/pngu1
 Z4/HLUZBwHUkU/o3tR8C7KnfRLUU2Tv8dp2fM/6+Iigs/bqmEr6Oyff2Ncx7eA+obUocCi/I02g3oD0lbovzvW73RvqJaK452bf3Zqe3lIw+lYDRUG+CPdA7vZJfHXhMs/CAFrnIY2qgJ+/F11MNNXsc04gPU7c1CQXjsMnNvOjNokfIDBs0avj1eobvRfvC72pLLvXlJYd01k/ac2df2iw0fHsYiayULnt1eZwjM4RJe2JYf8AO2j2JzN+t/MYFksMbPN7P69ftjk06WFjEUqfzcLbLnhuWPPjwQ5RN+GWyJR5lyQQP9PxZn8/r/9t0TYlOP
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
     name the lower-tier predicate according to its use.
  3. Scan mappings covered by the legacy file placement filter using
     promotion-only scans.
  4. Separate VMA placement eligibility from partial-scan continuation.
  5. Scan PID-inactive VMAs for promotion and account for placement scans
     separately.

Patch 4 and 5 are technically part of the same fix, but are separated to
make it easier to review - they must be backported together.

Patches 6-7 are independently requested cleanups.

  6. Use BIT() for the change_protection() flags.
  7. Use the VMA flag API in the touched NUMA-balancing code.

Gregory Price (Meta) (7):
  mm: support promotion-only NUMA hinting scans
  mm: allow shared folios to be promoted to a fast tier
  sched/numa: scan read-only file mappings in tiering mode
  sched/numa: separate VMA placement from scan continuation
  sched/numa: scan PID-inactive VMAs for promotion
  mm: use BIT() for change_protection() flags
  mm: use VMA flag helpers in NUMA balancing

 include/linux/mm.h       | 23 +++++-----
 include/linux/mm_types.h | 10 +++++
 kernel/sched/fair.c      | 95 ++++++++++++++++++++++++++++------------
 mm/huge_memory.c         |  3 +-
 mm/internal.h            |  6 +--
 mm/memory-tiers.c        |  9 ++--
 mm/memory.c              |  2 +-
 mm/mempolicy.c           | 37 +++++++++-------
 mm/migrate.c             | 14 ++++--
 mm/mprotect.c            |  7 +--
 10 files changed, 133 insertions(+), 73 deletions(-)

-- 
2.53.0-Meta

base-commit: 8d29b5365d528da545c1fe0768a55babadee95d0


