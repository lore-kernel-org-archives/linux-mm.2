Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1555F606A31E
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 09:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EF996B00EF; Sun, 15 Nov 2026 04:55:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A03E6B05B0; Sun, 15 Nov 2026 04:55:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6BD6B05B1; Sun, 15 Nov 2026 04:55:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D814A6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 04:55:48 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A64E1C3FE9
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:55:48 +0000 (UTC)
X-FDA: 85436896776.04.4FBB76F
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf31.hostedemail.com (Postfix) with ESMTP id 54AA520004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:55:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	spf=pass (imf31.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794736546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=VfNEYKtq+P1y119j5w9ZasnBrt/MoIaAlnAPJm3j+is=;
	b=W6LEJF4TWPuqnZvbZzP2pPSygLoeinhUZhxL+MgRKtGXNOMyiHD2jVg4L5uBDFut4BKu9U
	+Prdb+2UJv0Dd1Q9hncDiRXQnfB1MQnj3apB4+wXBdByN4ysW2Jfu5z6L6Kjxn41BvOukc
	+pvE8862Y1tVNHVekxOaKmY61jyRzrA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794736546;
	b=GlWAFFa7Di8c7oy73wSNcNS3i3xFzN4CaIRvq0aMsgwO40grBL6zLBLGu3wfySCQ2uT6ol
	weD0jIUWaYY0bQKKvII7BtKX5o40Dc+lsobttP8S5CL8vyXW24oqPuV/wl+3RV2WH8EN+V
	qvcJQQ9r3GtAh+QdTsVa5qTYTl+pjn0=
Received: from loongson.cn (unknown [223.64.69.17])
	by gateway (Coremail) with SMTP id _____8Ax39KbgflqLtkfAA--.25864S3;
	Sun, 15 Nov 2026 17:55:39 +0800 (CST)
Received: from kernelserver (unknown [223.64.69.17])
	by front1 (Coremail) with SMTP id qMiowJAxFs2WgflqibM0AA--.48914S2;
	Sun, 15 Nov 2026 17:55:38 +0800 (CST)
From: Huacai Chen <chenhuacai@loongson.cn>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Huacai Chen <chenhuacai@loongson.cn>,
	stable@vger.kernel.org,
	Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [PATCH V2] lib/smp_processor_id: Don't warn if there is only one CPU
Date: Sun, 15 Nov 2026 17:55:03 +0800
Message-ID: <20261115095503.2922598-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.52.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxFs2WgflqibM0AA--.48914S2
X-CM-SenderInfo: hfkh0x5xdftxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoWxAFW8WF47tw13KryfXFy3WrX_yoW5Xr4Dpa
	40k3y8Kr4rAr1jvw47AaykGFyFq3Z8ua97Gw17A3y5ZF45Aw1Dtry5tF12qFy5CF4UCa18
	JFn2qr1Fvr1rXwcCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
	twAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
	8JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r1Y
	6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7
	AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE
	2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcV
	C2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73
	UjIFyTuYvjxUc0eHDUUUU
X-Stat-Signature: kftwbpn7icgsok16wkjdu1shjibcrqsg
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 54AA520004
X-HE-Tag: 1794736544-597975
X-HE-Meta: U2FsdGVkX1+8I0vEkq0BLt5cyzpktTsF8mzqQ97H9UoRa3eCOaMPe/VIdYRW6ernQsAI6uQ1/AwRxSohZwX4lr3HXtRnYJ+ufiCStq/BTPuW2287gPDp9PxjZYiRCJeDNeHt7Y6Kf5Ak8Ix8Pa4zxST6ThuI/dGxsyEJe5DvQ5OoloXz0kvQbs3oW3H+0EFsrM9d7E4x9v4JoNj7N7dwVegjeh/WOKEAuS73y0vQZgPil2E/Ef6FcgCAs388EtmJb1t8IDpia4f4RtCW/00bICZrmSCU4SWPpDqaotvG3Xq7en2ZpWTgo5HYboHjIV3KGf+DWcn/DnyvR/KiU0ZQC/EFnH2mw8ac2kjJyqvAGPZSZMb7x5H6eqr/ABsxCjFQng6sQMxTnlTIM0gK3qvXsNjLeuknjAoTZAEkkTqHQB3phEO20jGxSUqVPE5yjhJN0cjMdYuOa9RjnQBj67u7BTUyw0a5d6cRdFHO1YARcDQ9F0OCihh7wwq1i4nWIueg+s5d0GoRFTtiO6XXsMAcHfsmNwmNp1NYHhpZ3kuFQ5immJfdoX3dePdEoKrIT8whPbyVrY0nfMwdsIBd7KPJWlJFOmqK5CTcjFSn+tbwYpt+LY47+UP59uI6Qk9uDb4xf10fJiH1Cjl80XM2DV/UlhDNqTnLJHGlam8/6joKxTV5tH4BoPfSVJBT8J2/QRybt4cQx9xUHmhP0xW/vz4akhtkFF+3rwy4qg+BTDD4Qvab3Vsd3L9eVsT/pbnKHIeJpQffF7dHCpZ2wg5ezP9lAT7EO5DI3uVs+HTXLFpBBKPU2w9VI5Qw7fpB588XoM1t6MM7sluHeS/2k0dXkJmW4xH84HZHQpUkdePQ6LP+AgDWEp6lDwG6HnslLQZcH//BLiYW8O0NdBeQw63Ot+J564zTv0PQpjXgXTq7dZcXDZb/MWokn/83T3GES5uI35Fq2awaiibj8w4LI3oVpYU
 tgfu8Y2n
 qwux8CCxOhitPhN0w5ReikUSPoFyw1RP8OZHuVa2/jrOnu5J6rpXdEAzyDDedNineXCaQ552lcv7RoBQ=
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
warning if (!IS_ENABLED(CONFIG_SMP)) in check_preemption_disabled(). The
effect is partially reverting 570a752b7a9bd03b50 ("lib/smp_processor_id:
Use is_percpu_thread() instead of nr_cpus_allowed"), because now in the
UP case nr_cpus_allowed is 1 but PF_NO_SETAFFINITY is unset.

Cc: stable@vger.kernel.org
Reported-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
V2: Keep the behaviors for CONFIG_SMP.

 lib/smp_processor_id.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
index 94b3f6b19538..be079b908504 100644
--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -22,6 +22,9 @@ unsigned int check_preemption_disabled(const char *what1, const char *what2)
 	if (is_percpu_thread())
 		goto out;
 
+	if (!IS_ENABLED(CONFIG_SMP))
+		goto out;
+
 	if (current->migration_disabled)
 		goto out;
 
-- 
2.52.0


