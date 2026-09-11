Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D1D6C88E4A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 00:18:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 246A46B0092; Thu, 10 Sep 2026 20:18:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21DA06B0093; Thu, 10 Sep 2026 20:18:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 133926B0095; Thu, 10 Sep 2026 20:18:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D17B86B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 20:18:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 941D9805EE
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:18:35 +0000 (UTC)
X-FDA: 85199570190.24.3C825C1
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id C98C040002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:18:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sgyohamF;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789085913;
	b=ksI2gnvCugqDREa2cnpEBkdDDFZMdxdKK3A1pNoHnL3pC48DpAHrBR0MjAiqogmbsHk3ow
	os+vmi9DkIiqQF7P3Q+i4kqnwPjH2pRnhJZK1bApdYXmZwIswamr0yZ38HYRTHpIlGy+mN
	hF3gbPziwZQT3FwpWR0OfxMk5doZEpg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sgyohamF;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789085913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ejo+90E50fXi5k+UdJPEJ6xbgHQPbd1TRBdPlxbvODU=;
	b=pCKoXsEyBBmZ7ddXJmd2zXDS8GNnVPn4vOkWrdVnF0a/hNb2ngIyxKF5gkMgc0QgcVaiqX
	ZWaTAxpvuSMLNSIF8MQloXEaCxcQUBg4azY4uxfGwELm+jvuiqdDxHqapqNYmEfYD3Snvi
	WodjsUVZjxP5INgLccZDBh1AMo+//tM=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-939adff838bso33600085a.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789085913; x=1789690713; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ejo+90E50fXi5k+UdJPEJ6xbgHQPbd1TRBdPlxbvODU=;
        b=sgyohamFfMUenaJb5rUhuopD2LtWW3Yc7gSKuPp+S6eAat0Upu45OZb2vS5CdVIw7+
         gIEjlsuxGqwX2ZB34lQ8zIhqe7bkhF3XIRWC9UGsbZglJ8s8ckrgfUPEzLSOWMXkfFGX
         /RNT38FGRuzUUVLWpB3q5F3sx4HVX01jtJ+FE1wF3cK82KGN35GkSDp1JoCKczjQGvtc
         s5eYhw1YxretlFoAn8BW6OvIQg8ZjeKLIyHVJjpJvTt0n70zaoVjkw+dVeS8zxJogesK
         OrpydmD3/dVQSV72vbqcQ3DYv/K+iWx7KQzBBKLc4yz/9ZjoPw82zSeMW1JiGkNFyJEt
         FuAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789085913; x=1789690713;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ejo+90E50fXi5k+UdJPEJ6xbgHQPbd1TRBdPlxbvODU=;
        b=FujGAQ+NiKRjcetDLiFmNZ8KTrC0kJc1gT4EOXlDSmb8ZQLLRGCWL3FIFPW80uW+bL
         LSiJUDWbqzpHBtOpYSUWsTBgi9vixf//riCAVIxsXb9UlTT3jH3PmLYNfc/CzvZhAYGy
         Eom8SZfIZuz85gpml6PKEhfRYH3D7TwMsEnp6L4JJ8cRz5Y0uEwAndEB40c3GpwN8MFp
         3ybn7MSOeYHJR6R5OGxxeDMBRNZLSeeRkbwFcYe0bvn0bmrr2NxoJiJO1kE+SsuGa2Tw
         bzfxjrlcshwoiZWjEMYw12JWyIM5obQ6VGfICIfN0vxcBhHa/gM12l/bygDH46pXXGuU
         f6Pw==
X-Gm-Message-State: AFuF++kbkmjzHVdZ1vWJmKhbC1Vaby68n6SlnL7EMpPC8Ljd3IOnXOcF
	MIaNNht2oMl4MyPLLmcUk1sXyNcIx5q9iXtCUJXP3kyknS3TkCnPtP6y1TJZK8W/P7Ogp5DuZZY
	bDCGW
X-Gm-Gg: AYBFou1empH8x3t67FL0hFuot9QtN/yw5g3vpsdH7DPObgM6X06jYKlWmi/+wJdifVU
	aiLlyPsmRtT/O7uDsEQ11a4WSzzvTyYLWZmmbWYI2oACSmmwM8fd/rakt9Zb4Hr/uJ4UYyDUu+t
	zdguBjoLrbRjwzI9W7eoK5zU4x2AxUvq9SRY6oeZ9L8E6dAzmXlgYPBD50XhCSifjcBhZi158Wp
	s46V2xNfmHv3Gliw2tZlvmYLRnYFUapEpd8eArHxks0LxFoD/NNX7/Mgk+ELs0IZlhKKUdCKxzR
	X546dNXC2ioiArfTSCbxMVu2QBD3cBZsoMtcN6bDYTE+76MxoQ3k/Iv805qg6a6toNOV9qWH17M
	xspy6vWlmf/ryLPepDxkz3tRMHY4pBZUcvk69f7zO6S51pkvpTRQsawF9ltLvL+/jtR2YI8gFlv
	ZX8qxTs4WuTMJyTkAU/po/Fffh9Sie8dy+X/Ud+ow0pN3uGDjlUKBicoA+9UmQx+3JuvyO2uguh
	9ja+b+Foaulmhsafm9LxzEuIGnnVTdnrwovR+hIZv8O4GqI+AQ5DUKstWWE
X-Received: by 2002:a05:620a:1a22:b0:936:9fd4:e2bf with SMTP id af79cd13be357-939ea189d6dmr225830285a.37.1789085912637;
        Thu, 10 Sep 2026 17:18:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e80e4c36sm108896485a.40.2026.09.10.17.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 17:18:32 -0700 (PDT)
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
	osalvador@suse.de,
	hannes@cmpxchg.org,
	raghavendra.kt@amd.com
Subject: [PATCH v2 0/4] sched/numa: stop VMA scan filters from gating promotion
Date: Thu, 10 Sep 2026 20:18:22 -0400
Message-ID: <20260911001826.2109390-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C98C040002
X-Rspam-User: 
X-Stat-Signature: 8awx99y79osdnwmbib5es1tqo7acumkz
X-HE-Tag: 1789085913-494111
X-HE-Meta: U2FsdGVkX19YQ7YAMx0k+TYTej0SNROr0lU8yODD8fOrtLEvJhbFZ7lBFnuZVHSw1HIwtThH5p2C5FTI3bwQRPWlXFb1Z7qAMnv/12upfGmIs/XfYLiOus18YX6TsGqVVTf5nsibIPCx/TCmbS+SNw9+edf90Gs5DX/hK1G4hw1CvwBK73w49/XiYgHcsab1RC54RZt8k32IKy53uu9kuF4fivty1n276BTHBoj+FyCjhVjuBjgRQNlicTx2l0vsvnLpuj+uTGN0JQ/SaPrnG9qNZ6w8S35CXCPT1o+B4MY34i4Is0hn5iwLpArkoitB40/KVeDJ1blYTYqtj5mqM+Pvp7gonBetK1tpz5oL++nj7ZB5t5iQzIj0MnhkrWsws/e6qnTrsiJ5bzx1O5x0UeLda02AA2IlNBTVj28nAT0j2oAkzIkUhiqC1RUCQuDbDwlWoYjVZHtcPz0r6PvJ0ihmZi2zj1E/XCoQdL+hTixC89xCbcPTsj4BzqvXAjQXmAI537kZNGFgBGvcNVYH1/SWVZTp0ANa89W3LeAD7dg7Rq71gGcV7Bm2v9PlxApysyaOz8BzffdsXxEKeaUXBt5hokzGyPM9lPoNr91ZbeBZPJLcdNrZdCetDqUdrDIaubsbdX4OYobTlsey8CLCIYa35A+02X2Ui4eW3olzCfzkYagz2YX2+PSMqxw9SXqPsoEtMlYG2KxAJosotLO+PhGUA+Gh0Xw1SBx5Kr3enKIwGFhirhW8lfQPM+G+tdo2Z+qIHUgjnt9tHOfxqBS19m6vlFhnsj9f2f1tfl7oUga2BCCd7BUi5m8bRZORq4ndtxpzlgeGYvphwhOoxH+nLDhqRAWFH751ftli4pQsl7oYHRL9JAqLga1rQpQxX6Rv5weyBDjUX7mAFqviLQnMMFmTFeYbkQjiJBjw1hnXDwWgl8qAlMHs58yiWJ+9GGRhiB0KN7TemcHehPEt8Se
 8ElNLl5P
 xAzJ0yVW2PvjhBJfVk4DxoBMu6/zXgfJMpwuz9lUKORFptiAH/cpF79CDyPRjaQrhH6nfAo39kqhjaGYFdVaRTlft/Z1U0LGabnk1zEoHEFBrjB+NXJbe3Q1OyDbGy7otGfEk0aA6sJP98fKsvpxeKTf62fPvtIVPSuMvEAFndGqh+pb9pdh9B3iA9xI2wvLpA+ovs5I3rTlrWzQYtVlFGXtKY9SL35Upq1sHgk5TSpkZgEwdbX9eBxeqewxvNi+SUMD1d+D+tc7FXZiXp6LzIVrCtQasVOD6XqdRdGNuWAsbwG6OsVyqY61pPcCGmfv0cCmh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NUMA balancing uses hinting faults for both task placement and memory-tier
promotion. Several filters designed to avoid unproductive socket-placement
faults can also prevent promotion.

Read-only file mappings and VMAs without recent PID activity may never be
scanned, while lower MM layers reject some shared folios. Hot memory in
these mappings can therefore remain on a slow tier indefinitely.

Separate promotion-only scans from socket-placement scans.

MM_CP_PROT_NUMA_PROMO_ONLY carries that choice for one protection walk, so
the PTE and PMD paths can restrict hinting faults to promotion candidates.
Keeping this transient state in the protection flags avoids per-mm state and
its associated lifetime, concurrency, and VMA identity problems.

  - Allow eligible shared folios to be promoted to a fast tier.
  - Scan read-only file mappings and PID-inactive VMAs for promotion
    without re-enabling placement sampling.
  - Track the last placement scan separately so promotion-only scans
    cannot postpone the existing placement-starvation fallback.

The series is ordered as follows:

  1. Add promotion-only NUMA protection walks without changing behavior.
  2. Permit eligible shared folios to be promoted to a fast tier.
  3. Scan read-only file mappings using promotion-only scans.
  4. Scan PID-inactive VMAs for promotion and account for placement scans
     separately.

Tested on a host with 768GB/256GB DRAM/CXL.
Ran 2 ~430GB database workloads with large (>300GB) shmem VMAs.

Before change:
  - 150-200GB/s DRAM bandwidth usage
  - 40-45GB/s CXL bandwidth usage (maxed out)
  - request latencies over 5ms (longer tails)

After chage:
  - 250GB/s+ sustained DRAM bandwidth usage
  - ~10GB/s sustained CXL bandwidth usage
  - request latencies 800us-2ms.

Functional observation:
  A 20 GB hash table VMA that previously remained entirely on CXL was
  split evenly between DRAM and CXL after the changes - and tier
  residency tracked hotness.  This was previously affected by the
  stavation issue caused by the "unaccessed VMA" filter.

Gregory Price (Meta) (4):
  mm: support promotion-only NUMA hinting scans
  mm: allow shared folios to be promoted to a fast tier
  sched/numa: scan read-only file mappings in tiering mode
  sched/numa: do not let VMA PID activity gate promotion

 include/linux/mm.h       |  4 ++-
 include/linux/mm_types.h |  7 ++++
 kernel/sched/fair.c      | 72 +++++++++++++++++++++++++++++-----------
 mm/huge_memory.c         |  3 +-
 mm/internal.h            |  5 +--
 mm/mempolicy.c           | 30 +++++++++++------
 mm/migrate.c             |  6 ++--
 mm/mprotect.c            |  4 ++-
 8 files changed, 93 insertions(+), 38 deletions(-)

-- 
2.55.0


