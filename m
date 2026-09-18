Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80BCBC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:04:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A34DB6B009E; Fri, 18 Sep 2026 06:04:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BDE36B009F; Fri, 18 Sep 2026 06:04:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85EE26B00A0; Fri, 18 Sep 2026 06:04:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 583406B009E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:04:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E8E721405E5
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:29 +0000 (UTC)
X-FDA: 85226448258.28.7C82703
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf17.hostedemail.com (Postfix) with ESMTP id B0A864000F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=zvyDPHtM;
	spf=pass (imf17.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789725868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QWRwGA8IIWGqEmgXFHVo35ysA7ES/LPOJVNWp6AUBps=;
	b=pPeBdhnTInP5lnCU5ySMef7T4Yh9UxL+0alZYFTHV+L5E/s4U+jwI4GcXQAn3TaZcBgsiw
	RQsBsua7a3n3XuLHWYN40UQuvm2Hbdb1FN6vyl2l6E88ZIJHVjp5e9e2QAOEAtsYNR2ejT
	0FsDTXwZAWu2ZC47liIFVeq3g4KBRnw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789725868;
	b=5vgYWU3Zn/6CVStrWYmxHs/oqtraSMt3lkZaDGmjQPmaLIaeYd2Is9KfcWrpOWJpeh6MbR
	T9G3Z0qUWpYHPfAOaG5Y38wxtQYAswUD1lDoPbAFKgUQ5/pOdImURh6GkoHVZ72p32vNbv
	dpkJ/DA7uaLVw6aBkNhrH0VLF9upy1Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=zvyDPHtM;
	spf=pass (imf17.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QWRwGA8IIWGqEmgXFHVo35ysA7ES/LPOJVNWp6AUBps=;
	b=zvyDPHtMXrIlKFMijCNSGV93POHhDpPEWLDf6NcDHeY4LQlngXcrut7XT/+zJayfwCPKA+CjB
	rIjWb7CcBTXVBn1eLuOcyP5UPmoRPnG64cslN+lcdwQdBUwDiDN+pGdNJR2HL+wQjqIhN5D0E/5
	lx7RD09w72DQURnUsPZ6Wmk=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hmSbS0pcszpSyG;
	Fri, 18 Sep 2026 17:52:36 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 36D4240572;
	Fri, 18 Sep 2026 18:04:25 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 18:04:23 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<ritesh.list@gmail.com>, <sshegde@linux.ibm.com>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
	<dakr@kernel.org>, <akpm@linux-foundation.org>, <baoquan.he@linux.dev>,
	<rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<ruirui.yang@linux.dev>, <kees@kernel.org>, <thuth@redhat.com>,
	<ruanjinjie@huawei.com>, <gshan@redhat.com>, <ardb@kernel.org>,
	<james.morse@arm.com>, <leitao@debian.org>, <yeoreum.yun@arm.com>,
	<sourabhjain@linux.ibm.com>, <robh@kernel.org>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <liukexin@kylinos.cn>, <guodongtai@kylinos.cn>,
	<maqianga@uniontech.com>, <zhangtianyang@loongson.cn>, <blum@kernel.org>,
	<adityag@linux.ibm.com>, <chao.gao@intel.com>, <kas@kernel.org>,
	<vishal.l.verma@intel.com>, <seanjc@google.com>, <piliu@redhat.com>,
	<jbouron@amazon.com>, <me@linux.beauty>, <mclapinski@google.com>,
	<graf@amazon.com>, <bgwin@google.com>, <eric.devolder@oracle.com>,
	<hbathini@linux.ibm.com>, <takahiro.akashi@linaro.org>,
	<lizhengyu3@huawei.com>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<driver-core@lists.linux.dev>, <kexec@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v5 11/17] crash: Normalize the kexec_load elfcorehdr at load time
Date: Fri, 18 Sep 2026 18:04:36 +0800
Message-ID: <20260918100442.3841135-12-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260918100442.3841135-1-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: an6qm6tzhihks4bkjknmex38oxh8f8zo
X-Rspamd-Queue-Id: B0A864000F
X-HE-Tag: 1789725867-52267
X-HE-Meta: U2FsdGVkX1/LFzPGNHjfZ5rU32iZvbBwlJEdKEEELuid9ic9VMFsd6cx/UTAutezJ6glFeJTxmchN1R6vmY4E+lVC9123GLkgw4kj7Fsr4v9fZ90XHCmdvLm3vjpWo0qeNjacjl7oGh8gHVkGs1Qpw7/01hl9en3rRYqcYOX1L9rmLrXHaXVo6CaqorTO0H7DrCymq76iWs+YQq7XgbLZv8FM+EoG467E0MhoCXuixWIsz9fatJjgiHilvVJ6s7Vq8oCu7rZR0duSf8gR62KdG4mrAVS9YxKFwemWW4P0syri69JxFbhR9njJPW0nKjiw3MkvAv53kKjVryzZvzdbIMQ4SPoEX3ycVyR7xvqUd3n4M8SdzwelQTEAV3BPeYCOZUhq5F4IvsutIyJgFNAEcX6TbQpNDslcSYMFhZHUCWDLwPhkFcBHGV/nGpbP3I7n2GilLxcD6Y4MN6BQrrnMkgzphW9IMbdWpAEzxdmpJ7QAVyzNiwtAHK3Yds5QYoDyUDtS4h4clk20ZDNBRa54i2uCxaEKy2REQWfA6BVasiq8GZaVenIganwdCM6LJAlM7pFG+sQuH0XVpXI9jtEiF9h5d08glVgSsgio2H4IlotNCqsCfN91MTsB8Db1xQ5/1BmkcDG0mp15TxTIz/dlCvMwBVuYn3KbGgovP+G088e6LW/ZgtrgTk2xUijmYPsKi6U4pq99LrgCu0gXFBlulVFzUHpZ6kVLb8s9+oYUduIjg4+1C7dBB6lsDwOT/LHqiRuPNeJQzgXg4dZ2l4BXtMzIH5TAPe44AZ3INYCPEFfE4lQ08ns43ngrWVcVJeDlGiPwtF3ywgz8JkFtC1edNbvV+/UvyAapPHgfr8GryAboRFkebO2cbucdvEodF1VAM+OmKFc10CvHse2ylmytbZWze/FCWT6ZjGqy+BOJCSCeeyQQ4rvgUZJGRoc2sE/YRO6IUDYpY2RHMg88No
 LSv3v+ga
 H84+CPFN3txCpbx+shevn8ELoI2ubHYHy9YZPo9FqAIvV5T1u2qfI4U0Hx0A5RAP0VWm31k62+mGEI1TMyfbHAloZHMQZeQZTjgAYrl6xTzmCgFrY5DRgrT/21QktIR/KHAyh8MiQuSsDpKL5erq1Qhn1z1pori+jh5l/OKxnKHhK8Z7Qas+SPf4K/PtrXxigHx0HnhZ5nCSv+1Hqf/0V4i7s3rtUZT6mI94ZRgp4XtMmywbwudVN7qzZVVYmZTTGpJYSyGmSOm7KrB2daLGzELlZysuFxpBTCgnEYZBmFopQ0G5bK1QOho2UdQE3+YQ/cLdH8oYApunfNtHQ1JTIJHrot54u1CcnNWG+mZXyL/rubDCKpMM8PgecafL7NmkJXsaE4yEauwCB+zJXOTXr8pB2tsEUl+MA31Tr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For kexec_load() the kernel does not build the elfcorehdr, so it is only
rewritten by the first crash hotplug event.  CPU hotplug events do not
change the elfcorehdr, but they may run without device_hotplug_lock
(e.g. CPU offlining during suspend), so they cannot perform that rewrite
without racing with memory hotplug.

Normalize the elfcorehdr once when the crash image is installed, while
device_hotplug_lock can still be taken safely, and let the hotplug paths
skip CPU events entirely.

The elfcorehdr segment is located by scanning the segments for the ELF
magic.  Factor that scan out into crash_find_elfcorehdr() and reuse it
from crash_handle_hotplug_event().  Architectures that do not need the
rewrite (e.g. powerpc) treat KEXEC_CRASH_HP_NONE as a no-op.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/powerpc/kexec/crash.c |  1 +
 arch/x86/kernel/crash.c    |  5 ++--
 include/linux/crash_core.h |  1 +
 kernel/crash_core.c        | 58 +++++++++++++++++++++++++++-----------
 kernel/kexec.c             |  4 +++
 5 files changed, 50 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/kexec/crash.c b/arch/powerpc/kexec/crash.c
index 775895f31037..8ede33740fc0 100644
--- a/arch/powerpc/kexec/crash.c
+++ b/arch/powerpc/kexec/crash.c
@@ -638,6 +638,7 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
 	struct memory_notify *mn;
 
 	switch (image->hp_action) {
+	case KEXEC_CRASH_HP_NONE:
 	case KEXEC_CRASH_HP_REMOVE_CPU:
 		return;
 
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 3c9f4fbbe7ff..f34fa8dba028 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -457,9 +457,8 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
 	 * possible CPUs, there is no need to update the elfcorehdr
 	 * for additional CPU changes.
 	 */
-	if ((image->file_mode || image->elfcorehdr_updated) &&
-		((image->hp_action == KEXEC_CRASH_HP_ADD_CPU) ||
-		(image->hp_action == KEXEC_CRASH_HP_REMOVE_CPU)))
+	if (image->hp_action == KEXEC_CRASH_HP_ADD_CPU ||
+	    image->hp_action == KEXEC_CRASH_HP_REMOVE_CPU)
 		return;
 
 	/*
diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
index b1c816e98143..a740757dff35 100644
--- a/include/linux/crash_core.h
+++ b/include/linux/crash_core.h
@@ -39,6 +39,7 @@ static inline void arch_crash_handle_hotplug_event(struct kimage *image, void *a
 #endif
 
 int crash_check_hotplug_support(void);
+void crash_hotplug_prepare_elfcorehdr(struct kimage *image);
 
 #ifndef arch_crash_hotplug_support
 static inline int arch_crash_hotplug_support(struct kimage *image, unsigned long kexec_flags)
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 406b68d2adfd..47a4579eb97e 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -647,6 +647,28 @@ int crash_check_hotplug_support(void)
 	return rc;
 }
 
+static void crash_find_elfcorehdr(struct kimage *image)
+{
+	unsigned char *ptr;
+	unsigned long mem;
+	unsigned int n;
+
+	if (image->elfcorehdr_index >= 0)
+		return;
+
+	for (n = 0; n < image->nr_segments; n++) {
+		mem = image->segment[n].mem;
+		ptr = kmap_local_page(pfn_to_page(mem >> PAGE_SHIFT));
+		if (!ptr)
+			continue;
+
+		/* The segment containing elfcorehdr */
+		if (memcmp(ptr, ELFMAG, SELFMAG) == 0)
+			image->elfcorehdr_index = (int)n;
+		kunmap_local(ptr);
+	}
+}
+
 /*
  * To accurately reflect hot un/plug changes of CPU and Memory resources
  * (including onling and offlining of those resources), the relevant
@@ -702,22 +724,7 @@ static void crash_handle_hotplug_event(unsigned int hp_action, unsigned int cpu,
 	 * is allocated. Find the segment containing the elfcorehdr,
 	 * if not already found.
 	 */
-	if (image->elfcorehdr_index < 0) {
-		unsigned long mem;
-		unsigned char *ptr;
-		unsigned int n;
-
-		for (n = 0; n < image->nr_segments; n++) {
-			mem = image->segment[n].mem;
-			ptr = kmap_local_page(pfn_to_page(mem >> PAGE_SHIFT));
-			if (ptr) {
-				/* The segment containing elfcorehdr */
-				if (memcmp(ptr, ELFMAG, SELFMAG) == 0)
-					image->elfcorehdr_index = (int)n;
-				kunmap_local(ptr);
-			}
-		}
-	}
+	crash_find_elfcorehdr(image);
 
 	if (image->elfcorehdr_index < 0) {
 		pr_err("unable to locate elfcorehdr segment");
@@ -747,6 +754,25 @@ static void crash_handle_hotplug_event(unsigned int hp_action, unsigned int cpu,
 	crash_hotplug_unlock();
 }
 
+void crash_hotplug_prepare_elfcorehdr(struct kimage *image)
+{
+	if (!image || !image->hotplug_support || image->file_mode)
+		return;
+
+	crash_find_elfcorehdr(image);
+	if (image->elfcorehdr_index < 0)
+		return;
+
+	/*
+	 * kexec_load() images are not normalized at load, so do it here while
+	 * the lock is still free to take.  hp_action is KEXEC_CRASH_HP_NONE,
+	 * which the arch handler treats as "just rebuild the elfcorehdr".
+	 */
+	lock_device_hotplug();
+	arch_crash_handle_hotplug_event(image, NULL);
+	unlock_device_hotplug();
+}
+
 static int crash_memhp_notifier(struct notifier_block *nb, unsigned long val, void *arg)
 {
 	switch (val) {
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 90756dc6339b..ea9ba00bc786 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -166,6 +166,10 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
 	/* Install the new kernel and uninstall the old */
 	image = xchg(dest_image, image);
 
+#ifdef CONFIG_CRASH_HOTPLUG
+	if ((flags & KEXEC_ON_CRASH) && kexec_crash_image)
+		crash_hotplug_prepare_elfcorehdr(kexec_crash_image);
+#endif
 out:
 #ifdef CONFIG_CRASH_DUMP
 	if ((flags & KEXEC_ON_CRASH) && kexec_crash_image)
-- 
2.34.1


