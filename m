Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92AFAE94614
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 22:14:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 073D66B0089; Mon,  9 Feb 2026 17:14:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027A86B008A; Mon,  9 Feb 2026 17:14:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6CB96B008C; Mon,  9 Feb 2026 17:14:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D80D46B0089
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:14:53 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 801D516012C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:14:53 +0000 (UTC)
X-FDA: 84426324066.28.2816C55
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9B19F40005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:14:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TRyXDrqD;
	spf=pass (imf01.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770675291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rGs9hCTZyZ7Pjx1oR/68kmPjlLwJFnt3KGvTvJCfD2s=;
	b=uO/ZPMnXQwI0nNLvBvqkNIBhsvIgb8RSoI40jOuqZofL2UmgWL92+R9/+78c1dlF0hwdkt
	ljmRoGwbhpzofOP5EQTheC5ptViXUuZZaHrpgnAZroOlwhnuKvKdK2FNUzefpZzJvnQrl6
	RPCdPJyb9R7+3e9RhachlEQvqTSfBK4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TRyXDrqD;
	spf=pass (imf01.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770675291; a=rsa-sha256;
	cv=none;
	b=UHsk4zA2IhlQKCOpTn/zjZbpqvUYR3zzfyKE3pSXBqykGJZevplkXO62Ftopygm2f05Cgm
	NzBBSqQoeBxBd+eDCLxxRz9IAF7w/HiH5m5CW7si6w81BZM+/KqUQ0qb3VuAvd5c+GXLjd
	v8whAihnH/7OeBfFKN9JqIB6eb6Hb20=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770675291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rGs9hCTZyZ7Pjx1oR/68kmPjlLwJFnt3KGvTvJCfD2s=;
	b=TRyXDrqDikh+IosHa7y0KV8EY4IrRlwhIPKzozrjUZoQjhTKAFnqH5IijoaFXBPL1dFc9Q
	GSZANBCHky/B3J7JyfRTFEpN8wsEYBFy+XYjtSEYxWd1+MbJZKY1akwOVUW9UJtGFRb9fu
	IY0Yg5WFypD9mBOpQmB2o3N9EPja2oU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-FgOUuNvCPre4UmMlbkiGkw-1; Mon,
 09 Feb 2026 17:14:49 -0500
X-MC-Unique: FgOUuNvCPre4UmMlbkiGkw-1
X-Mimecast-MFC-AGG-ID: FgOUuNvCPre4UmMlbkiGkw_1770675288
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5A5E11800464;
	Mon,  9 Feb 2026 22:14:48 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.66])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C6ACA1800464;
	Mon,  9 Feb 2026 22:14:46 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v2 02/11] mm: introduce pgtable_has_pmd_leaves()
Date: Mon,  9 Feb 2026 17:14:24 -0500
Message-ID: <f55ca6204336f52f1651d02dc370bc3b771df3d0.1770675272.git.luizcap@redhat.com>
In-Reply-To: <cover.1770675272.git.luizcap@redhat.com>
References: <cover.1770675272.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: AmFUy-mqdN14XPksC0p24_1wRpUeSTNOq4E7RiMBaDI_1770675288
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam11
X-Stat-Signature: 7ugdit1iudafxw86uprqq7imams6wf4w
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B19F40005
X-HE-Tag: 1770675291-168105
X-HE-Meta: U2FsdGVkX1/wq8GKxDraCvf13G1F6b3LCY8yTA6ATnsd57937qEiLbvuLyo7txe9jEaPObZLvr+HcHvl4Xj/VDQ8J06+tVDsDj4BY5rv5Sdlj9xDGXnV77dv9XQptL71IrC4tu2+nDCJ3Vz3y3n/V+gJGv0fonczTMkaGKgvxwt5CvKzj3mhHIZhwSRpBthsLj7CdVNaYU0mKxqLlI1S6MWOwbOmvyo8LFKYmAmL6Mp2DV+yj3lG5v3n3XlH6ZMzysjkdBMOgL/0a2ew9znmj59Qc1L0jI+2hDANcaI38BOVwkiu71HCA0w8tGiZ8Pk9zQM/56K4uE89zm6VzMiFw6VS67aki9z03a00XspmBCEngjrSYsxLPxs4UCUCZZ95A91dFO3zsekkcBHQfHVpcwQOPGr6c1XTVT3Q/EQAwXugrj3e12X/9OBr3/3R+1S/qhWD/PjPb/NpEDbsdROL3dKemhwdSYnUHJb/MmDROi+u5UJWh0L+ZowyjA/tRVbk4qeDSQ5db2xEuqCSTiMgUpvAnl0GqMIbLytwrx93ziNPlYqfoL0qikKFx/+P8CBD/cq6E5AVcnqDqfwCNZ+xOYjqCb958fAdyD1RbgrZ/Y9quX3W879Udw+KYct4ePxzbmSLCXB0gGioI7Uwk84dIueNaZ2dupMi0HrPT189spsCC+6VVsTWj3oRln7r9X5uQKZdNt2VTzIbJb23mA0XlKD2RRl2HpsGeRoerBBFQNMzhGS8aq8s8xfS/Y1PF/hAV6POm/S2+jHVJ1G+Mq/Wc8cMbeE/WWNT3DQiQYAFy4TJf3UyC8eqikSrM/cKyrMs1nNoMuShshi5S4mLUdaa56ZcIQfbX0bTOfHf20K5lehpa3skk4e8wEknbsfHlBBvMbR1vNHdjjqcMvAAojMDQM+fncOy71bhrF2chRbF/oK7/VeE1QlOJvlQDBzhxSVmHvVQZH8q8E8CWTuZ6CM
 OB/Lf11D
 hHqI1BoO30LUmIM2gXFVkeSvzeTlMZUYhdAONsR6Y7cV9Jnx161i4GPC5VrMvyQ/1UCUv/pGkJ+2Q61pw0/OroFks0zmf8XJ3lnlq2eGp4BUeJwmlvDv4ucs56JL7GzPWLVcpIgtMz++L+YsoMd3k+hhdvSEigDu5yCDaVVGczCGJwz7eJzJGbSzCwgS9G3srXtTGxktD+MDiMRdWRTG/aoBk83ORbsZMvTz3Az7Ktc2Jpjr1yAeuFOHCISerRUkrc3NOp7XPuhIeA9v1Ba7nLvA9vo9g6ukzjbxfDXOVQho1RBvLcKl8z0g4juUGj2w9cBZdqD4udVRi6Gd6sy27ToSRVfxhiindrebHGbGVpKcJ/oxt5Kdrj0bLBlwTVckmQEM3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, we have two helpers that check for PMD-sized pages but have
different names and slightly different semantics:

- has_transparent_hugepage(): the name suggests it checks if THP is
  enabled, but when CONFIG_TRANSPARENT_HUGEPAGE=y and the architecture
  implements this helper, it actually checks if the CPU supports
  PMD-sized pages

- thp_disabled_by_hw(): the name suggests it checks if THP is disabled
  by the hardware, but it just returns a cached value acquired with
  has_transparent_hugepage(). This helper is used in fast paths

This commit introduces a new helper called pgtable_has_pmd_leaves()
which is intended to replace both has_transparent_hugepage() and
thp_disabled_by_hw(). pgtable_has_pmd_leaves() has very clear semantics:
it returns true if the CPU supports PMD-sized pages and false otherwise.
It always returns a cached value, so it can be used in fast paths.

The new helper requires an initialization step which is performed by
init_arch_has_pmd_leaves(). We call init_arch_has_pmd_leaves() very
early during boot in start_kernel() so that users of the API can call it
from __setup() handlers.

The next commits will convert users of both has_transparent_hugepage()
and thp_disabled_by_hw() to pgtable_has_pmd_leaves().

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 include/linux/pgtable.h | 7 +++++++
 init/main.c             | 1 +
 mm/memory.c             | 8 ++++++++
 3 files changed, 16 insertions(+)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 652f287c1ef6..6733f90a1da4 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2017,6 +2017,13 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
 	}
 }
 
+extern bool __arch_has_pmd_leaves;
+static inline bool pgtable_has_pmd_leaves(void)
+{
+	return __arch_has_pmd_leaves;
+}
+void __init init_arch_has_pmd_leaves(void);
+
 #endif /* !__ASSEMBLY__ */
 
 #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
diff --git a/init/main.c b/init/main.c
index b84818ad9685..ad1209fffcde 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1036,6 +1036,7 @@ void start_kernel(void)
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 	early_numa_node_init();
 	boot_cpu_hotplug_init();
+	init_arch_has_pmd_leaves();
 
 	print_kernel_cmdline(saved_command_line);
 	/* parameters may set static keys */
diff --git a/mm/memory.c b/mm/memory.c
index da360a6eb8a4..4c25a3c453c6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -177,6 +177,14 @@ static int __init init_zero_pfn(void)
 }
 early_initcall(init_zero_pfn);
 
+bool __arch_has_pmd_leaves __read_mostly;
+EXPORT_SYMBOL(__arch_has_pmd_leaves);
+
+void __init init_arch_has_pmd_leaves(void)
+{
+	__arch_has_pmd_leaves = has_transparent_hugepage();
+}
+
 void mm_trace_rss_stat(struct mm_struct *mm, int member)
 {
 	trace_rss_stat(mm, member);
-- 
2.53.0


