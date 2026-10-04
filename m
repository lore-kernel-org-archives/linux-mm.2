Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BA73CA5FE6
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 13:41:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D3386B008A; Sun,  4 Oct 2026 09:41:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB536B0092; Sun,  4 Oct 2026 09:41:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDBA46B0093; Sun,  4 Oct 2026 09:41:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC1D26B008A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 09:41:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3CF30120BC2
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:41:08 +0000 (UTC)
X-FDA: 85285055016.16.9A061A1
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf10.hostedemail.com (Postfix) with ESMTP id CD6B5C0006
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:41:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791121266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Q7JMG1h3g+GXlTGGFX7QP0BF5Llh0rqGnDT6H0c1fxg=;
	b=CbgbtfseFlAVgk1O0vsMXeLcGkECR0IoLBS2gq6y3HzZ0LMxZmsmvgwfeSzcNB2Uf3V9dr
	KQ++yz11Ck0vuYd+dVmGzuh2kC6eZ80RNLdzyylKJVGtTiq5X6lw2olAaufZjdYy+Z1s2k
	Yj9mARme+x8LBU37BoLzfTtdkPE0/so=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of chenhuacai@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=chenhuacai@loongson.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791121266;
	b=jJlT+hddo4mXjknYxtBt3W3cwPTlhB7l87JWXS1klcjQDfCYjiXZhshrw1olDWJGErBxRA
	VK7aDljLSdoQuxH+GjzHhGh5YYa4VTt6F7gZX9/fnsXwneyQHtnQbY15TC0lvmHg0eXRxq
	Z5f3LQAHWfMHjjCf5t8JP5vEFvL2jvw=
Received: from loongson.cn (unknown [223.64.68.159])
	by gateway (Coremail) with SMTP id _____8CxPNJnV8JqtIYSAA--.54396S3;
	Sun, 04 Oct 2026 21:40:55 +0800 (CST)
Received: from kernelserver (unknown [223.64.68.159])
	by front1 (Coremail) with SMTP id qMiowJAx2c1gV8JqfWUoAA--.19823S2;
	Sun, 04 Oct 2026 21:40:54 +0800 (CST)
From: Huacai Chen <chenhuacai@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	linux-kernel@vger.kernel.org,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH V3] sched: Update the THREAD_INFO_IN_TASK description
Date: Sun,  4 Oct 2026 21:40:34 +0800
Message-ID: <20261004134034.3622868-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAx2c1gV8JqfWUoAA--.19823S2
X-CM-SenderInfo: hfkh0x5xdftxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7CFWxtw48Aw13Jw1kJw4kXwc_yoW8uF4Upr
	Z3G3W7Gr45Ar4F9rWkJa4xuFn5Jrs2gay5Gr97J34UK34xGw1jgryfCay3Cr15Ar4v93Wj
	yr4qg3sxWFWqkabCm3ZEXasCq-sJn29KB7ZKAUJUUUUx529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Jr0_Gr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2
	x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1D
	McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr4
	1lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67
	AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8I
	cVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v2
	6r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j5o7tUUUUU=
X-Stat-Signature: 4muuiub5hng7roj9zrekx9ixjfgyyouw
X-Rspamd-Queue-Id: CD6B5C0006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1791121263-221149
X-HE-Meta: U2FsdGVkX1/GzqGCycYEMju/afXCVOn59HQMNEgXfaCkwhOXgyUd/Kn9blcWkMXXcejT6VOrCrXt+Bi5ayw4K169pgK4CgWaeEFJ8i4awVLeZQSgjNw2T5QUiv1BdaL6IKt1wMG4nTl7rKF048guoTR5Eb5kCi6qGpXb0EhvZSfFUlgiX/kf4K/uCkRQIONtmxHO+65Bdc1ou2ye8BOdFnP/gPgI6vyc6wf8PXVYSmnyOMgjkIJA0fCSdnNmXMUjv4vjss7uRStrFQUTrB5tPbTp88TGYLF3vOmnPs0hKW3g68pwsxCjpBCfZMX6tcoymlBgV5ujDVqnTuGn4/bWRiTfHy8tl5fZvNraCJI8MDciiDxZblzZ9V4LMcAFf8dx2GG331qbu5/S6G4cchvzqRXV6FbIoukrbbXv+UvRzPXA74IYSrB9AbYXrP15OYm2xhdQ61qNmbyJPekv/dw4ooLWN8TPdDolYDCfTS66ZlEk+NksfJCt+Td7h6EZepodeq7az4K77tH8zd4S+pJohIGwA2RgMUtcGB88p4H1dU9otq6KtovJaXKe5GfGzxNcaNCvmvJwy2KbQqFiU7zBurJgz9Ei9I1ugvtU/ahBKEoZFcXPjAqpm8JCyIgVp72rsCl766gQqWLPW3WfInPLyHi7Zy6boffb2YGmxSUWwyxChA0PcL9TYegmn/cTZBfipGqSVgu9cZJL2vzM17REFbxOLnC3n5ygMNNAjNh1A4P+7gyXe0/80GJOisKWVefinjkz0q3AVB5C0lsjYCiD9eBApW3KA22ZJ4e4XPtajT2S2hl3bf8+gQPOXnCvly4tgkAmljAlj+GEb0QctDY4owzRIoeMtrt8HdBZFb4GSTDGFvGM+E29xj4AzUw3WBDkTQfC3aW6UCaPz8OLMYQepB0OZOrO16671gor2Rf9I1hZlk/EGTufkysGc7jItu+7tQjd91L3d+ETDED6Nq2
 NKaIt9kK
 vMmGgX4EnAEUAyYrGoBAXxgegz9I4uO0OZsptjXI3HJOI1QN6PW1JCdrh9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When commit c65eacbe290b81 ("sched/core: Allow putting thread_info into
task_struct") introduces THREAD_INFO_IN_TASK in 4.9, the only supported
architecture is x86 and thread_info only has a flags field. The Kconfig
description said thread_info should only has the flags field but didn't
explain the reason.

When commit c02433dd6de32f ("arm64: split thread_info from task stack")
introduces THREAD_INFO_IN_TASK for arm64 in 4.10, its thread_info has
more fields than a single flags, and arm64 works well.

Then commit 37a8f7c38339b2 ("x86/asm: Move 'status' from thread_struct
to thread_info") adds status back to thread_info for x86 in 4.16, and
x86 still works well.

After that, risc-v, powerpc and many other architectures all introduce
THREAD_INFO_IN_TASK and their thread_info have more fields rather than
a single flags field, of course they also work well.

I don't know the exact reason of the original description, but obviously
it is wrong and misleading, so I update it, let LoongArch and some other
architectures easier to support THREAD_INFO_IN_TASK.

Also improve the try_get_task_stack() and put_task_stack() description.

Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
V3: Update the Cc list.

 init/Kconfig | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 8583d9f06c52..921f2fcdcb30 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -210,11 +210,12 @@ config THREAD_INFO_IN_TASK
 	bool
 	help
 	  Select this to move thread_info off the stack into task_struct.  To
-	  make this work, an arch will need to remove all thread_info fields
-	  except flags and fix any runtime bugs.
+	  make this work, an arch will need to remove the task_struct pointer
+	  field from thread_info and fix any runtime bugs.
 
 	  One subtle change that will be needed is to use try_get_task_stack()
-	  and put_task_stack() in save_thread_stack_tsk() and get_wchan().
+	  and put_task_stack() in save_thread_stack_tsk(), get_wchan() and any
+	  other stacktrace functions.
 
 menu "General setup"
 
-- 
2.52.0


