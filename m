Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6A3410A3D96
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 15:10:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7411F6B008A; Thu, 26 Mar 2026 11:10:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719226B008C; Thu, 26 Mar 2026 11:10:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62E466B0092; Thu, 26 Mar 2026 11:10:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 48F4A6B008A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 11:10:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0DEFC3DAF
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:10:23 +0000 (UTC)
X-FDA: 84588550326.24.2B35CF5
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1D5DD40013
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:10:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=MCsPIKTS;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774537822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jiq9HHreSKv9gJ1OxNDx05z/LXXiM1SwacfPI7vtSKY=;
	b=6JxYgWyzh95S9rHTdvu5YuAgxgEnkR63l9lN20/pTZmhDJ9QXMXY/ZFBGdh7nmOE44IF/n
	QnV6B4uubHN39G5I/ai9Kds0kGl5ZFYcCrOo94O3y4ni1cY5oqWE2zXmv1PXEaEbXYMfih
	nsjd0W1a4aGwpqt4obxFp/7oV4MwqDQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=MCsPIKTS;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774537822; a=rsa-sha256;
	cv=none;
	b=IYyEiDlulayBN1vS5/jY834lvkN6j18k2Y/Uj4+WHrOCDz9aFs1GG9AlirrKKe/tPOshHo
	cmyICjy9xfJxYqtdvXzYOY6XauDnP1XcmvQLbIHVGc00iZpHGnDvNslp+1Y/a9yDlPoEea
	0iRTGNPBClxGMB1XcynvM9m+6Z1Kxbw=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 2C262BDE11;
	Thu, 26 Mar 2026 15:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774537820;
	bh=Jiq9HHreSKv9gJ1OxNDx05z/LXXiM1SwacfPI7vtSKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MCsPIKTSM3jO0DE+O7tGH9or4d7RA3oOYgCViVrViC7aFwieHCibxhbFDn+0u4iUu
	 DxQ5xHMscPKl2VxBrGGVhwNfgbjQ48/yUGPMTAsfUS8AzcUMfc4XCPpvIdDrjm1wi3
	 9Mcozrt1w+UiGqwn8R8+zaLsj7qE/0Qrbi9uF2aU=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v4 2/5] locking/percpu-rwsem: Extract __percpu_up_read()
Date: Thu, 26 Mar 2026 15:10:01 +0000
Message-ID: <223dd069af9f3395d0044398e7996a98a8c94e5a.1774536681.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774536681.git.d@ilvokhin.com>
References: <cover.1774536681.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: tfzw3xh7p8o5r1hctw4f9etay4objs45
X-Rspamd-Queue-Id: 1D5DD40013
X-Rspamd-Server: rspam09
X-HE-Tag: 1774537821-681674
X-HE-Meta: U2FsdGVkX1+KLIQsUjo7Jbyip6TumY0bu/UZCe5+O2M4rzDFpEwLb+RjXjZ16otb0fxDHy7SHG9W6w/ThnrTmKmuojtS52O/FjdfO0xQOwX+NhVJFx1HCh9milxbrd8Wc5EdNW9SOQbeMZ2DBRUDWd2DdPJ/+vRLbdYr6iwPR7GL1Nwc77GqnXqvv2MvYxh3ymJVRNShQUMqEDsdqrGFj/9m/pbJyyJme62Hmb+lMZBGCPfOtQDB5mlaFUIta1bLZvYCg5A/tvlSWHCg+wicDiCHsm4WC22+E1VMqXHfZhE0aU48uFl9m8XYNjtFlMLrzhzsHvL7pfkDGDTWjvl95SDK6xQtNMnXqe2scd3Iu5QXxXIjPNE1p8uzC65XiHuJUsKCo77sR6umtkO2dFgTBf5ojXPDFqpCn56S+R14DP/EfU4G2RgfKAkoNX6eLKY+B6pX8rtNG3yhiTyvOCTe7OySqvlhjGx1pT26K61NOSmfBss1qjISgmfU5+oPTquodln1noexHz3/w82gNoK5HZKIn1sx9qqFNU+K3wQOgmrT5Ah+Iw8b0Ap2wIAbYp7aAHvwwVZkYJ97kF+DHdXmfYaqACio3HELT7CjUdHNCK7GmThdsZkCyoCZvETxroKQvUTpfxpbF/8Tj187rsx3fRbsNgB/okLnIjmNMI8KKWeEBn9S8dhnWWRQdzt5LcgtySHCvxZQlvjfk6FLrQQ1TN5srS3mRwq6ao8aZ4lRvGER6TcHKrvsIoOjKdOS576zXLOLK7dWqkAsEeud5bwKJ+ssFrp9GhpdZtJ4SdCG0YutKt2OTtBXrROw1rpEdQ0NKeLydedO+s/mmCff8F96OglwqsH0t32/yRQrrqA6QYxxWVl++TQfI+N6FExJWbjB75GEiGZTIQ4pnN1hD7reV4MH89VuaQfQ8Ftm6DN8KC2DqG2ZeIAkC9QBBX7qMu7bvJWh8halyQq7fxNRHL1
 cBe7BLKZ
 NBSpNylg2q+ZQvM4eu83dDDFSQB8PJ7EXgcZktuS0XT82yigOzUp/LFpoYgp+KRsZd1NOgpOhycvb/4YJRZ+TU20eS966o37fQpwpNFkwaCju02326V8111TTVSP4jS/opRvhdrVaQSo4qRN+WoByhdbP3bW6adhr+Y1ETmLsHJlRJQ90Ea/oLFkp4POS/ftesWdQzJ+Op8JDUVFyyTV+jAqBgyN0Y/+0bLZDhEkKVBJ1FaprMisGGDkwtEgTRhyzflNB8UlEpeUcJRuNvjCNKiz2m3Sz6Kp8LA+mSlRHN0VH4vjBlkI2OracNIZL4cYAKKyfd5vdmqHR2bQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the percpu_up_read() slowpath out of the inline function into a new
__percpu_up_read() to avoid binary size increase from adding a
tracepoint to an inlined function.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/percpu-rwsem.h  | 15 +++------------
 kernel/locking/percpu-rwsem.c | 18 ++++++++++++++++++
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/include/linux/percpu-rwsem.h b/include/linux/percpu-rwsem.h
index c8cb010d655e..39d5bf8e6562 100644
--- a/include/linux/percpu-rwsem.h
+++ b/include/linux/percpu-rwsem.h
@@ -107,6 +107,8 @@ static inline bool percpu_down_read_trylock(struct percpu_rw_semaphore *sem)
 	return ret;
 }
 
+extern void __percpu_up_read(struct percpu_rw_semaphore *sem);
+
 static inline void percpu_up_read(struct percpu_rw_semaphore *sem)
 {
 	rwsem_release(&sem->dep_map, _RET_IP_);
@@ -118,18 +120,7 @@ static inline void percpu_up_read(struct percpu_rw_semaphore *sem)
 	if (likely(rcu_sync_is_idle(&sem->rss))) {
 		this_cpu_dec(*sem->read_count);
 	} else {
-		/*
-		 * slowpath; reader will only ever wake a single blocked
-		 * writer.
-		 */
-		smp_mb(); /* B matches C */
-		/*
-		 * In other words, if they see our decrement (presumably to
-		 * aggregate zero, as that is the only time it matters) they
-		 * will also see our critical section.
-		 */
-		this_cpu_dec(*sem->read_count);
-		rcuwait_wake_up(&sem->writer);
+		__percpu_up_read(sem);
 	}
 	preempt_enable();
 }
diff --git a/kernel/locking/percpu-rwsem.c b/kernel/locking/percpu-rwsem.c
index ef234469baac..f3ee7a0d6047 100644
--- a/kernel/locking/percpu-rwsem.c
+++ b/kernel/locking/percpu-rwsem.c
@@ -288,3 +288,21 @@ void percpu_up_write(struct percpu_rw_semaphore *sem)
 	rcu_sync_exit(&sem->rss);
 }
 EXPORT_SYMBOL_GPL(percpu_up_write);
+
+void __percpu_up_read(struct percpu_rw_semaphore *sem)
+{
+	lockdep_assert_preemption_disabled();
+	/*
+	 * slowpath; reader will only ever wake a single blocked
+	 * writer.
+	 */
+	smp_mb(); /* B matches C */
+	/*
+	 * In other words, if they see our decrement (presumably to
+	 * aggregate zero, as that is the only time it matters) they
+	 * will also see our critical section.
+	 */
+	this_cpu_dec(*sem->read_count);
+	rcuwait_wake_up(&sem->writer);
+}
+EXPORT_SYMBOL_GPL(__percpu_up_read);
-- 
2.52.0


