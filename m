Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F398C79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 523B06B0095; Thu, 10 Sep 2026 19:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2E96B0099; Thu, 10 Sep 2026 19:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BBB96B0098; Thu, 10 Sep 2026 19:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E7FE26B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:47:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B5D0A06F1
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:47:45 +0000 (UTC)
X-FDA: 85199492490.25.B099497
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf15.hostedemail.com (Postfix) with ESMTP id 83241A0005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:47:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MRuBaKWF;
	spf=pass (imf15.hostedemail.com: domain of 3nUGjagYKCAo241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3nUGjagYKCAo241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jjYzY5hY0HpXPVya+Zd4xkPFjC42gfo+YPj1TM2pAi0=;
	b=bV98OBNqcSmECuM3EYg5nHM1G6p+QEfWOU/vW+Bh4HX46dqvEA4RLDh+zcguTPLwtKVzd0
	GF6642zhkwnxv2qIpErX1eoj357VvUbvBlo2bjaUcM0hmhvF5X54UIhRBB46GjMMClwnn9
	9ZMo1S/Ey8txkp6zJM1jKvbuApyjzXs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084063;
	b=Gg86ie7J6csnGxlhaRnM6K9Wq4fCQIwXEvelBNRAl2woBC2q13sw9wMY7oTEtFr4H5m5+K
	UGMs7ft1KWXwRakX9s2ZB7bpEAdAGwY9YEh0JAK0SmacWjcFU4iENloslMSAjH4HisVnDp
	q4rZ6uDHhAZVYQahkhH8u1dGdv3VCMk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MRuBaKWF;
	spf=pass (imf15.hostedemail.com: domain of 3nUGjagYKCAo241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3nUGjagYKCAo241oxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38e1118e4abso508982a91.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789084062; x=1789688862; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jjYzY5hY0HpXPVya+Zd4xkPFjC42gfo+YPj1TM2pAi0=;
        b=MRuBaKWFAu65Fg/AuTiPIKqoqDNVNiWArC/Bqb9pMSAgWLxxr0xFPa2o2CPgTwS5ei
         3JPB32rUof79uAtn5wk+wsn637scMNxrSPrYWonk6MVK12Ecou7aaKQUM+euWjJ3gCwz
         RJY0WPU+WFrKEWEdQcEEtv9BxOP6G8XN7W//jmnLtnUIgVhnXlUFSUVDwIla7DGuYgLq
         a6/G1hXc2gr8WOgr0pcJll7lXJA+I6u287cCuhcChq5pCc6Y+grSkWtRuL6HBuebPMVi
         pWx4dJChpSyYn0L+xnGTxVPe210mEpLa7qTn5wha4LZcE+ZDBqRRnH/vDLSEM8o4uTQ5
         e38g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789084062; x=1789688862;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jjYzY5hY0HpXPVya+Zd4xkPFjC42gfo+YPj1TM2pAi0=;
        b=DL14CAASqqWgLmUQOo4h3rwLzKCzLNTOokRyDHoBr47P2oW8riv/PFew0rpx1HJ6p4
         byldq6vatF3vsciGMrdAfVjDowCd33Jz6ughE/KgpyUPjej7Bhgs3v+EcAZNjjG1xfv0
         wO3gmqhVzGp4fEt1316kWI506xV5c+lKs87xv6SxnySi/94TmWmOd1SLD5uwVWK7b1Wq
         RUzqaAB3HNxsUTyTnI4kIQbzPpNc9Py4nlBVG+hafwjcJL9TT4qWOnoIRO0qlQDt0od5
         oD5YDyHF2yBnxtE/GR+mFVq59N4WxqLsRTqsCHAaD3/gQDk0nfPh4x4ETcPmjstj+KW9
         ygQw==
X-Forwarded-Encrypted: i=1; AKwUvBzQO5VdsEKV76kLSFpZzOWhg7UFTun4RGKQyMKUDrZWztVxf4CeGPbGFQrQy3No2Cliil1IpsV6FA==@kvack.org
X-Gm-Message-State: AFuF++l52rJ2/smAQpjFQLqCg7ebEBPdoHYwhLCRO1Elv8I3mFeJiug3
	1U5leXkpwi9fiP1nIIAfvdUjz7WFRlnqqE/dijBQy9ReT0DWDYBnwIhAxz160TZ2BqEa7UsrJWu
	Wcf7FUQ==
X-Received: from dll34.prod.google.com ([2002:a05:7022:222:b0:143:6080:6696])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c8b:b0:398:9c00:29ee
 with SMTP id 98e67ed59e1d1-39d9c38fa48mr1808878a91.22.1789084061665; Thu, 10
 Sep 2026 16:47:41 -0700 (PDT)
Date: Thu, 10 Sep 2026 16:47:30 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260910234737.1340642-1-surenb@google.com>
Subject: [PATCH v3 0/7] read proc/pid/smaps_rollup under per-vma lock
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: qo7n7eirqukuwundq1185uxesqjmcf7a
X-Rspam-User: 
X-Rspamd-Queue-Id: 83241A0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1789084063-766418
X-HE-Meta: U2FsdGVkX1+iZVFTgYupY3iWFpUtMJRRwswANm2UCOLl5cVXJ20CbGjg7pEE/ltiIFvGCg1nwDxY4EUka37KNrCFqNqNCCinM1RWbScaXdAooQ7GmRIBkYTlbDl2lCq6AOCXYhQTxqEiOcVrVJwcrPO0IOy7BSMiYmEXxSyA8czYUjrxqLueX+RW9VXYafj1mjuWvmiEoLqB2Sjaw9llcAVzfaVtYM2rRwsWrxCsudfm94UMi5O4jV+k1p+GQBnAtNHj63SxBf8h6Z6wbCNOCfzTDzpXBc3+EwaKJeJKWigt66SvwoU0Vj11Cm15j3LGR32h6Ki35tV+pCMx0IDF9bFsK42Pje3QL6aG8scYmvAtHHH8C6N1g6lHtTGExRPWbtqBzUEt0uyEOziM93/UFLjacilyM4+FOnxONz1dGx7vKRIeWILbE+iK5aDzWO4wBWRhxtdZI0yefG/OBGNmilVslJoJ2/zHq24IVCex1VxtaqjIulvnL0hKD2V1kuQX6AWU4bEI3GyOQEInImk5W1XETM8jCcjwC2jUwYlCoxEvHm/0k6ig42XZhMR6PeCBw9TvQwG2zxF1r0JD1HERrsdpock9Fp59RFvQizdnNkdWoYUkgMdUAcGcn/8JkqIrRkvLq4m1dWKIpkc1Yjjhhs1i31Zb0GvGf8g4UfHhonFdlfsgnADfX2qAEoZG1QY+rYR8LKecbFfPmvMW56A4k2eCmaet8ZMf2JDGuPLoIKUmF7L6P4gFhOuio10aYuwbYY5IINP3tnhUiydjdGSGiSGSDhV9NRd5TLE9XreYm8tiT1NB1DCUhH10G9WK2eGvA2g9yYrw2TRUrApj9m+S+5ygRyuh6u5WyPsvs98o2uwBNtlz61dTJM/3IHUmUZXB2GY+byfry2ewdND2igXFzzvInn+PuHyMAhIbQc6J/paNTLcrk8/NkqhvJ+DFjvmnt+Q5aeF9u5xF2CJBIGg
 tR/ELxCv
 swWYC0Umvn94VHGjY6qkugIb1NaPHIjFCjz7AY2AVOpJ2eTF/kTfLy4X9VDwp5+aRAF3WeLqLKOJu2qDay1LTmEtu0OqFsql8efPbEF6HfM/4jesWBjRRiHAvA0iYecEejBQxoM6ggoaHihr/+pSTAcri4Eh2WcDdPkj1s3nsSH4VQIvVpIvhjgkApSYAFV5aq9N7ggZdWy1AAARsDUX5/OgQGml4+aGHFUSkql5MMfZUg3Fuvjh9K/oE04qIcaTQsmmxOY5t3RosmmYbKZ4I0tQcJ/HVmhqybAFJ5qiofLF/Ip5pK4LHsDIBuZ91tO3LSCAe/8bXPGbVfs439rAgfV8ipIqiNUEHRQSXn4RoXCHZDYV8mkzJNVgumhsKmJUn1b/c4wwNxBWliLTw4ApmBglfmDCWGa7r8Ozr/FJZ4Tdsh61GbF0jB57DyWbn/XMmuDrY6A+1jzUZlb5peL+cxk9gwvtwbbAQfNau5hj5qin5JUoluo0cK6EkfR8svemiBZ1iZKFKW4s0MdpRQs7aPUOPnWrwe0+JlUuC1jrhfqGSWdSZHTkg40soIFmVSzMqKO2yeseDNfNkZrfEEOIh0dlBNzVf4So7cRphWxGwEzJrujQor/+zAzMEQ7X5iMSwEkjNHYcyoELfQx112XaVODbT1bNeH+F1rPELwukz78iHppWY8ukVXbYEnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

proc/pid/smaps_rollup can be read using the combination of RCU and
VMA read locks, similar to proc/pid/{maps|smaps|numa_maps}. RCU is
required to safely traverse the VMA tree and VMA lock stabilizes the
VMA being processed and the pagetable walk.
Note that we have to keep the logic to drop mmap_lock on contention
because even when using per-VMA locks we might have to fall back to
holding the mmap_lock.

The first 3 patches are cleanups making later change simpler. The main
change is in patch 4. Patch 5 extends existing proc-maps-race tearing
test to verify smaps_rollup content.

Changes since v2 [1]:
Patch 1:
- Added Reviewed-by and Acked-by, per Usama Arif, Liam R. Howlett,
  David Hildenbrand, Lorenzo Stoakes
Patch 2:
- Confirmed no change in binary size, added a note in the changelog,
  per Usama Arif
- Converted multiple lines of arguments in modified functions to
  two-tab indents, per Liam R. Howlett, David Hildenbrand
- Added Reviewed-by and Acked-by, per Usama Arif, Liam R. Howlett,
  Lorenzo Stoakes
Patch 3:
- Updated the condition and the comment for walking shmem mappings and
  split it into a separate patch, per David Hildenbrand
- Added Reviewed-by, per Liam R. Howlett
Patch 4:
- Refactored gate VMA handling out of proc_get_vma() as a separate patch.
- Fixed skipping of the first VMA, per Usama Arif
- Removed gate VMA handling inside show_smaps_rollup,
  per David Hildenbrand

[1] https://lore.kernel.org/all/20260907063918.3432401-1-surenb@google.com/

Patchset applies over mm-new branch.

Suren Baghdasaryan (7):
  proc/task_mmu: remove unnecessary helpers
  proc/task_mmu: remove unnecessary inlines in function definitions
  proc/task_mmu: clarify shmem mapping walk conditions in
    smap_gather_stats()
  proc/task_mmu: remove special-casing of smap_gather_stats() start
    parameter
  proc/task_mmu: change proc_get_vma() to stop returning gate VMA at the
    end
  proc/task_mmu: read proc/pid/smaps_rollup under per-vma lock
  selftests/proc: add /proc/pid/smaps_rollup tearing tests

 fs/proc/task_mmu.c                            | 320 ++++++++----------
 tools/testing/selftests/proc/proc-maps-race.c | 187 +++++++++-
 2 files changed, 318 insertions(+), 189 deletions(-)


base-commit: 1f78f28a2945f9e856b4ea8428ac41a6788e4b67
-- 
2.55.0.1007.g17ff1f9808-goog


