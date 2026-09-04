Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE66FC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 18:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A14C66B0088; Fri,  4 Sep 2026 14:20:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C5EA6B008A; Fri,  4 Sep 2026 14:20:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B4AA6B008C; Fri,  4 Sep 2026 14:20:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 699156B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:20:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E29B8C0127
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:20:18 +0000 (UTC)
X-FDA: 85176894516.02.1B8E1B9
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id 41551C000E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:20:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KrbQPZUA;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788546017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=15/euYVzQb+bVm46MuDTQD81/N6uJc5AIVkvvPF4JRU=;
	b=1dv2pjUVRYHCqx+MO5xmw79CrjxtnND/YUEeEEN18pXz6Pn9fVuNcXgVPBhPuQULb/xZLh
	IvESdZv2XOAVwwbeAeBIhzb7SSDkHRlfavt9CEdP9DFRWuL0mNyJMSazq1Zi62z+5X3+KJ
	sdNz0Mg5vPFZqbG+5JSBWMrnRsQ+WaE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KrbQPZUA;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788546017;
	b=4QLuY/E18ikLz2z4WhN+wz2bjiSVTOeZ8AvfBqFr7QGwnNVw2zWEtOIfxixyKHb5dp7/VU
	vEcYcWOo5QSCyOPaEr9IaXxpZHM/h3SlwEz/SKh1TdFQ8wdJpOgcy7YlMQ5ZpanIFFFApR
	ZqBPhcN1pNPbsPQ1PNKnvnGY1aNAoKo=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93905b1dc65so98632685a.1
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 11:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788546016; x=1789150816; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=15/euYVzQb+bVm46MuDTQD81/N6uJc5AIVkvvPF4JRU=;
        b=KrbQPZUABe9ebqujiyLghw57Hpp56PtQ+EJqcOHWZnVl/EiyNuQUzdzedM3vOxFuFL
         QJNmYRPaklJ2IV4EyeBuaA/o0PfZGA9Eikjs84yUQKCct2TeuGzwgPriM7PGg4eFe604
         0pXw1p+05Gg3WVRVJivoArio+O+xmaQThP6qaEhjoiyIm/0Wi1dLhya7M5Lqa48ccLz3
         /IDIWm49ES2jnfXn1Htih04R6yTTYxF41CvFt9pnkSMRdVhuqDa2j+qY9sJ6S32ewT4F
         i2GdMiJNr+t6LkBZ4C1/XyiiUZ23wWhYqCZofOIGNFXMLNnDs0bw4VO6IHEJxnfjHiaS
         xa+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788546016; x=1789150816;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=15/euYVzQb+bVm46MuDTQD81/N6uJc5AIVkvvPF4JRU=;
        b=MIcz5uEik43uL4gQAMVdr+aSz0GT2MgQ3QZmpA57d79FZZDu4i06/BGIkYeolAi5tM
         XzHtvbft3a3a8Lsl+2EP04KD96Jukp5L9fV85NXhTXWzqv2tXyXgR8pIuga/6DKmHvJY
         t6V5VDkCFuw/s4uZjRd87tQ+tjtOU/c7vMb0MfaNzdAPrcZ+kotWRk4AzDEHwztjeno3
         0u2BSL+9CjbwJEkD1OBXrtvuc6J6FZZMnZcVLvObDJ+K508AUiqxh0edtC62fXs5Gmpk
         J2tzzmpHUBajgZuQuxObNkrU0VzntR5jX8BqgUJzXYxJgWqJ60AUsC0++T9OPWM+EHZ8
         +FPA==
X-Gm-Message-State: AFuF++m9KDtxQTfibjH02AVopt/gfAQ3jjsp5O/nFefPNt1kwBz4G6ih
	Ww1pbmFzaKK2Pw0HJLTpktfav/XNdNp7VdIrfuR1YcRbMFdQ9206sM0xZeTxR/4gkjqsty4I8VC
	qS+Lp
X-Gm-Gg: AYBFou2aAs71tOFFALwEiNjD+e8hlWu0IlbXULGoIrnJB92ERezUviEthFPrn68Voi9
	k1VVt9XL9MMMVN1YGN1vYmEhhpeDKuHZI2niFfT/3KQ84lMoc6EJx1BKLbrjc82POgswYn8bb9g
	loJWMASzWXIY6pWnOz+YeJIbIXGe+Qe46CAa378bgXoy7qNjZH8o9TrapFV6rWbVN04T78bf0+M
	KNobcsb1d0jcssf/e4wJAP5ffOVIDxcaTORX8W8TNiCxAhOLAjk2QB8bcDPosBcub0guiM3V+oh
	rTIkE51q+d6V1ZcGivvPp9h+plwPUPleT8sGbiNJOilQ3bENsp3elCefawqjqPOOUOtcORNqxF3
	/joQCqwiBGIOiV0+nHzNkdj2829jdleddcErEuvL2PIaqSarZNTjnv3SVRlyALG4diekXIk28M/
	bCdoG89qvE/USEJ/3/XfN2wq4y8ymhWECdKfQKhftWaA2lUwPJnRth4pKdCVTNdMkS/Z5RUnskV
	+iTJgksHHRzLYVYbVEDrXQPTXpP5pHTwXxKdmbvfX8YC071YA==
X-Received: by 2002:a05:620a:3c13:b0:939:69a:4764 with SMTP id af79cd13be357-939804a4503mr516368085a.39.1788546016090;
        Fri, 04 Sep 2026 11:20:16 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93982db6a95sm207374585a.9.2026.09.04.11.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 11:20:15 -0700 (PDT)
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
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	raghavendra.kt@amd.com,
	shy828301@gmail.com,
	baolin.wang@linux.alibaba.com,
	osalvador@suse.de
Subject: [PATCH 0/2] sched/numa: stop VMA scan filters from gating promotion
Date: Fri,  4 Sep 2026 14:20:04 -0400
Message-ID: <20260904182006.1562449-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 41551C000E
X-Stat-Signature: bhpthuca53pk4scdzm6qpq1sc3cq6neo
X-Rspam-User: 
X-HE-Tag: 1788546017-897712
X-HE-Meta: U2FsdGVkX1/rSKY2qftFySGNL3TarVyDMYCGUhTdoJL7K/1a9HV/VKq/ga33BlJ6ltjDiqimrh+daOF312fxfVxSDW8oFbKNa7k85Wu7p5F9W4m/+Wp9CfhcyTxP7L7/lUrCTo9LDijWMaGhJG8PfJ8KJmic/FfBjcVdpQz9TaXXbmFioMtVWkzreGBGlsvaufVjbU3OKgsvL5FZ732GFbZpr5kjNR4VzwiqmSBfJyS80KVxDEanEFzpwUfoYqg/9S7m3ZJFYNBblZ5Ex4XSWuTJpVGa7n2Y2cLpqL1zKPI+zP/N9Z759Y12Y/Zfeww7t0treQdmculj+gm5QevOqljbjhUJEZ8JDAg0jUTKwD9M25iYgx5YblnuVRSyyHOcG2r0MTxd3UeVBYDh6BaE29PKW6LIhBKRCjE8dsIgLzMG+xhnZpBcXsP97Xl2i/gTmnyV39NK/6Ek6oTQb/fCIF5ACX+8Dv73PB/AUokuTJ2vxu36qQSqwXuRlCotV7/IegtoOIr7kq2ylcGCcx1yINVIneiQ9J4ZwhGt+1Nrqz7RB0lwDC7b99cSjPYtr2h+GXMtRHkaKM6opYtbGvC9+9E0sV3agJR2jT8ZECGjKz/S7jLlQft15gBzUlpmJbsJIutOvmzb7mHSbfq3xgvM5INCCSpe78mYdDLvakrx0/ndxj2o6GJN1Zt8FP1A1LlKNshOwRPQJa90JG0l18ONp9VVUGqzA+K5hDtzFuE+nxC9nr8mf78AQWtP6wVOQpv7zfB4rbJceXQjxB3mHfW/B4Zo7Bz4s+P5QUbbYJ70b1FK1XPwuktnHbShQTikNkrxlBPb+dqeaWtWI4sfOKkKiFgsLqY+8Ew3hiFF1zlocQkIYM7lj1RBJa24mtADXWZ1KkG1aOEWh+ZAMUhEQD06jYvs3rc8OUEams2np/3ryGLRRDZVWyfAzXnf6pfsm5yfi7OoqMzbFNsZ+FwW8wy
 raj2jnj7
 uW1s9Sdgr/Kt68d6fhKLF6VOeEErBvwIAkRYHTXvFQfrcUG6dRwClMhRrJ5IovukeXvgKFVuoje6VaAzrLJI6ee9fGhcmy+qDir6XC6mur+FCnm/g09cqYaqNHlJWj43tuiia/7PpN2welo0NVklnS79Rz2QPGiM5k5XhSFJcWv1P9EPxQTKlMB4BgH+6ww9ktc0qJc+LvWcy4DRASWAuaATLgPxocSvhqPcFI+PDuHpCGWPBcbQmTE5/L1pQX2OBqb+RqKVZvhAl7Yo/yoY2andIZDTxfTebtNVWfKEVN/GDuSuxdnnFUGUrQnBHx3eXCpUv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

task_numa_work() applies a series of VMA-level filters before it will mark
a VMA for hint faults.  Those filters were written when the hint fault was
a socket-residency signal. Skipping a VMA only cost some resolution.

Under memory tiering the hint fault is not a signal, it is the mechanism.
A folio on the slow tier is considered for promotion only because the scan
marked it and something then touched it.  A VMA excluded from the scan is
excluded from promotion, and stays excluded, because the filters take
their input from faults the scan itself produces.

Patch 1 covers the per-VMA PID filter, which is self-referential: a VMA
needs a hint fault to earn a scan, and a scan to produce a hint fault.

Patch 2 covers the read-only file mapping exclusion, whose premise:
"if we are never going to migrate the page, it is overhead for no gain"
only applies to socket-residency, not tier-residency.

Neither patch removes a filter.

Patch 1 adds vma->numab_state->slow_only, which restricts one scan of one
VMA to folios on non-toptier nodes, and scans the rejected VMAs under it.

Patch 2 reuses it.  A toptier folio is never marked anywhere the filters
would not already have marked it, in any mode, so placement behaviour is
unchanged and only promotion candidates are added.

On a 768G DRAM + 256G CXL host running two ~430G database services:

  before - DRAM bandwidth decayed from 200GB/s to 150GB/s, CXL climbed
           from 5GB/s to 45GB/s and capped, request latency went from
           800us to 5ms and tracked CXL bandwidth

  after  - DRAM holds 200-250GB/s, CXL holds 7-10GB/s, request latency
           sits at 800us-2ms and tracks request load

Gregory Price (2):
  sched/numa: do not let the per-VMA PID filter gate promotion
  sched/numa: scan read-only file mappings in tiering mode

 include/linux/mm_types.h |  7 +++++++
 kernel/sched/fair.c      | 41 ++++++++++++++++++++++++++++++++++------
 mm/mempolicy.c           |  9 +++++----
 3 files changed, 47 insertions(+), 10 deletions(-)

-- 
2.55.0


