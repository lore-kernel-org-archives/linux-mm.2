Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABFC5606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCCBE6B05B9; Wed, 11 Nov 2026 04:24:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7D746B05BA; Wed, 11 Nov 2026 04:24:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A93396B05BB; Wed, 11 Nov 2026 04:24:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8832A6B05B9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:24:54 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 18AAF120248
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:24:54 +0000 (UTC)
X-FDA: 85422303708.16.C79C3DD
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf13.hostedemail.com (Postfix) with ESMTP id 594EA20005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:24:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=1HiZVoGdgP26KTrqD2XwxNDHWJELschXpQq9mDiL7Kw=;
	b=D84t1UjlVi8mJpQfLZ/6CmXRbhRee8KmCK0u+KI90c5lXNOPcsqHIB8/vmFs4Cp7+E3HNx
	6rx7TBm4WJ9yn/OPQyDPkIqeE/KVg155lbfIebqs+8v7WxmrqLPNdvlfDoGPYOW99rPK7U
	HNszDM8Yqv3TBn0wyGr7ER/DOmx3wgw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389092;
	b=yIKxdoIDoYlOBy/8WdUGTo7GJMWB1AaxzYjIlF3r1QRhT+CvOHphWuxQyDAvZxfObWMxQ+
	9gvX1ERyt71rLNbLpe5KR4ju92/MYsdNbaC8mv1xh5tAVfkNfZ0a3a61caPy5ZsMG7FMAg
	nvoBVMi6dG1NqmYRBPQW0znb44+TOsE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn
Received: from loongson.cn (unknown [223.64.69.17])
	by gateway (Coremail) with SMTP id _____8DxOvBYNPRq1n8eAA--.22784S3;
	Wed, 11 Nov 2026 17:24:40 +0800 (CST)
Received: from kernelserver (unknown [223.64.69.17])
	by front1 (Coremail) with SMTP id qMiowJDxxMxRNPRqU7IzAA--.12611S2;
	Wed, 11 Nov 2026 17:24:39 +0800 (CST)
From: Huacai Chen <chenhuacai@loongson.cn>
To: Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Huacai Chen <chenhuacai@loongson.cn>,
	stable@vger.kernel.org,
	Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [PATCH] lib/smp_processor_id: Don't warn if there is only one CPU
Date: Wed, 11 Nov 2026 17:24:21 +0800
Message-ID: <20261111092421.3771992-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.52.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxxMxRNPRqU7IzAA--.12611S2
X-CM-SenderInfo: hfkh0x5xdftxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7uryDZr4fCr43CrW3JF47trc_yoW8KFyDpa
	40k3y8Kr48Cr1jva17Ja4kGry5Xas8ua93Cw17Aw45Zr15Aw1DJry5tF12gFyrCF4UGayU
	GF1vqr1Fvr1rXwcCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Yb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	AVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7V
	AKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v2
	6r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
	AIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIev
	Ja73UjIFyTuYvjxUc0eHDUUUU
X-Stat-Signature: 9gdjtmmb9jy977hj1qraebwt5mr9ajur
X-Rspamd-Queue-Id: 594EA20005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794389089-776717
X-HE-Meta: U2FsdGVkX1+C04fspoAw97Vee5280pJDud5R05688iX4vmkHM44DpjWC7A6cDKcFGO27R/WI/PhUz/oxWqAH3mS9P4CE95qYNiKgJRKIIwhbuG+EkqAQpMnY3HvZtQl/GfhK251pbkN08ywzfwq9yPqEplHytEbdf0je8DvcCPlC0Ik7vd6QacpUSZPgFbmuD/HqFFVEezDFMp8j+81E01c2+3TQIcu4VuKncRPIMJ4of68VK58ElgGPXmdEq2q1pkHWkO722zWtM672yqwYv/0JV8XC7MQZjZRDE+zxQ/zKRJwWiM0AFrJX9qg6xgnKnyWpDPN7BEwxpbD99jghhj8ItG2VlT+2FGwXy+wT4Jd0BL/MEIrsCXbvmvoNZjvuV7UzOMbbNElM/zedczSWo5hAHsnUpRU0vsek6XnK0qyLE1ci9kayRP/cndzn6kLhQ1NzamsgB248d7pmpUj9yL/902424zzMLl24q0BidasdY47sjYsXt/lMOAMK45dpW/bjXe+SY4eEAr8m8Dsxd6IP9NdpM7909vMwF8GI8MljDzAoVMRxHXmDlQMTbQo0dPKPggnTd1kzeYz9FrhiHSz7bqS55WXgFh+lKMxR8MjHF0wMZhmrFER5USKSd0hm9uHlUTP4DHm+gx4YdqzgKnMJoWGAkdtUfgWn/J67eES+55XXMg1KSmV8c6v15M13n0jyMVAFZzm6iimfKBdeKjciZv/dvbV0tZ1kqJjG7ukoTZ3nOC2E0gvgb3xVDQO+CttgPhHPIKrqNJ6XVT1Anio+ikBthru0B3pkECCjFcf1C7CGYwkq11w4Vhx13BL5qiwE8uUz4a0JEQg0UIlIvyDxpFWAILsrUdJtviYdi6BCkZX29e78cNJEO2mpGXlPxSzq2h044QD32/7oDIWIuqr87alyNgv/EPOROAU1jtJtgHnHc65r3RY4U9uTubDeEp4AfHDdYuTDxYDy7Up
 33+r/eJk
 uTFH0dAKuNWKTy7OmUFAobNkK9FUu/0KBplzhmwhx/AHAz8YvJ4f/4GSz/C/kvs56Ays/39oVmMVi0U0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When CONFIG_DEBUG_PREEMPT is enabled on a Non-SMP (single-core) kernel,
calls to smp_processor_id() in preemptible contexts trigger some false
positive "BUG: using smp_processor_id() in preemptible" warnings, which
are harmless noise because the process always executes on CPU 0 and CPU
migration is impossible.

Here are some of the trimmed log messages:

  Call Trace:
  [<9000000000d33e28>] show_stack+0xf8/0x1c0
  [<9000000000d2fdac>] dump_stack_lvl+0x4c/0x78
  [<9000000002456fc0>] check_preemption_disabled.isra.0+0x100/0x110
  [<9000000002456ff8>] debug_smp_processor_id+0x18/0x40
  [<9000000000d31118>] init_cache_level+0x18/0x90
  [<9000000001adbe2c>] detect_cache_attributes+0x4c/0x640
  [<9000000001adc44c>] cacheinfo_cpu_online+0x1c/0x310
  [<9000000000d5ae04>] cpuhp_issue_call.constprop.0+0x94/0xd0
  [<9000000000d5b278>] __cpuhp_setup_state_cpuslocked+0x208/0x320
  [<9000000000d30148>] do_one_initcall+0x68/0x200
  [<90000000024711b8>] kernel_init_freeable+0x1fc/0x294
  [<900000000245824c>] kernel_init+0x20/0x134
  [<9000000002455b54>] ret_from_kernel_thread+0x24/0x1d0
  [<9000000000d31650>] ret_from_kernel_thread_asm+0xc/0x9c

This warning only exists for the !CONFIG_SMP build. This is because for
CONFIG_SMP cpuhp_issue_call() invokes callbacks in cpuhp_thread_fun()
which is a percpu thread, but for !CONFIG_SMP build it invoke callbacks
in the init process which is not a percpu thread. And there is such a
skip condition in check_preemption_disabled():

    if (is_percpu_thread())
            goto out;

Since there is only one CPU for the !CONFIG_SMP, we can simply skip the
warning if (nr_cpu_ids == 1) in check_preemption_disabled().

Cc: stable@vger.kernel.org
Reported-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
 lib/smp_processor_id.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
index 94b3f6b19538..64901d33c0ee 100644
--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -19,6 +19,9 @@ unsigned int check_preemption_disabled(const char *what1, const char *what2)
 	if (irqs_disabled())
 		goto out;
 
+	if (nr_cpu_ids == 1)
+		goto out;
+
 	if (is_percpu_thread())
 		goto out;
 
-- 
2.52.0


