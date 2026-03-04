Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51881EF9008
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 16:56:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21466B0095; Wed,  4 Mar 2026 11:56:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADB686B0096; Wed,  4 Mar 2026 11:56:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C316B009B; Wed,  4 Mar 2026 11:56:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8649E6B0095
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:56:47 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B68F1C8D1
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:56:47 +0000 (UTC)
X-FDA: 84508984854.26.EB2691D
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf24.hostedemail.com (Postfix) with ESMTP id 83C2A180002
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:56:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=lckSuusp;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf24.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772643405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F84vVv5JxOidIYONKjZER4IMrpUQUziDDec8nXOVB6o=;
	b=8Guf2WH8IpxHBi8iLw2o4216lieYtWF4dmm1AIqDvbyMG+yTqaEdeipvWbvJKd8/lpfgX2
	HWlfauy1ZK8jmF4ziMbJvrjBKjFrf2MBTKiyKN/U8pMjBv6LUBZEeHwPIt6dDGit2XEY6Q
	61UTl7hXu3rNpI9g/mRNqLLMVTtXWUE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772643405; a=rsa-sha256;
	cv=none;
	b=emUl/QdlSUjpInYDGDv+bAI2HIBrneN7B0BiRp1b12xJQGF6jAWX6f99Hhf6JpJKHypzNy
	M0/zOec3arpZoEOiFb1+Ey2Xa/TcNRVWZClzwoXKMYGo7ux2Rhl7IEZ+mS6FuokCm3GKAR
	lMy0nesXK8V6WEakt9ZkgvihM+W44DE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=lckSuusp;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf24.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id E174FB31B9;
	Wed, 04 Mar 2026 16:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772643404;
	bh=F84vVv5JxOidIYONKjZER4IMrpUQUziDDec8nXOVB6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lckSuuspCKzKJWcPA1z/bHjJm8kUXbaq+XdXI24TaG59VemiwbNrz9JjhCQk7sGs+
	 6Fg7HLJSmtXsfVD2XqqbI1XUSPcCYtt18jnwBCT8dCalFgwMlSQjmKe7bh7ux979t4
	 CrmXDoycvGo++nglGkJkv6XbSWs8h00MGDXCTUmg=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH RFC 2/3] locking/percpu-rwsem: Extract __percpu_up_read_slowpath()
Date: Wed,  4 Mar 2026 16:56:16 +0000
Message-ID: <6b1f1521ca186d5c402a65619d8f30fe83b93bf6.1772642407.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772642407.git.d@ilvokhin.com>
References: <cover.1772642407.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 83C2A180002
X-Stat-Signature: 64gr68t4k69mpe3sq89uownj6xg7i5uk
X-Rspam-User: 
X-HE-Tag: 1772643405-490307
X-HE-Meta: U2FsdGVkX19W7Z6f3JlP+584zycBBWol1Pa4k2A+UnvfNXj5p0MAaNFyzyNAtj3N344TS85sjK+hAQlieBVCxroqK0Xz+/xybVg65WB3sgLZ8zLSE2lSBlmdoR2gklBSPlgvkgPb+Mj02MUBhJHqdR/HmNIi38IGYKYcsIG8qfb+Ia3P7/xCjNl9fVCYNwQtF5U+of0JJ0D8078PWWBwO5ikTwnaj9EFvqSCiDr5+ao9M04JeZGbjY0A4cCpRp0hmrTbes5k0b/SdPo6z4YE0+dsbLjPhrkxWj88rz3BfeBZjcTAdHKH0DmsgYJ4ymlAXM1tAU1Pe0ggJat63p8U/U4DlkcfKL7ilYQGm8O2u6I17zYUrJW0UbBGZt6S5/mLHFZU3QL0KHn08LqOVTLgMVNw1IqUhSUBLAQib5v6omMmeFGzlzsP3rpdCxisxegGxVOY7ZPXuCI1gYpTZJlM67Dj/WqqjGGWGb4rg7BAm8KGHd73h0Op1L9yP+aRrIs85Vfz76bxb3jnDJnti2paJiHct2QpgT/ArGHsWX5/lhu7+ZTVo+LieJ8CBXOFaeyfJ8zl3257RX/ZnEOdTal3wihyMwBFfp23JvM2DVYOJ/ZWx/avxbb0bvAGv3orb9uWrbu/VwPtD/Dnt3ndy3oU4SYzm989pgXIpSAq+bI+wDUaUSr14kicBUgwn6mB280Re3Fmc1QKawHM9o7ddVNcq4qW0l+I8lt48qXmx1EfOuDfhHgiS1ZvnCwinGUWSNvKEWDuTTQ8tzhkVPaev6goLtIA+ONVV7ad+nuwHQSxWICv2BTtp68va1jnYCd6n1jpDzB/Yw8ZAVv833LvX0kwNOfSfi4roAf3J4Zu+cr3t7CLujHRYA4zZKGFwnTJGiAU2+h/ZcA4L51nx7hiwXLYEVAymPoyjj4eSXDsKbdIgGLxKlUpbaBwR3pigtSWVLIPhmf7Ck71YViYV+DdgPU
 NV/AuOiz
 Wze5y7JFJcDCbQcCzdjnfw6WiqmnfBzI/3EAldO5u+YCscu0V/FS0ggy6TpVaJOGIwaD/UvbmVVNYM5+9yQCLj3+5qrTnnSpYZHP//3XMyUNS2bWL+WvEIlzjqbXu9nBXYihrmhZHiX/XQcXKm1c1SpSvg0OZZqs2CfJSZTIvDz/tMk6u+I7a/2k/QoLY+ZerLet2x5QG/tcAurspCGibvQJ+0sGSQRyWeFbX2h9jtsDBBUjZGQvvtr/Lp0B1dcJ4cqlhshrAUgHz6ZAkCh3M+A9rEGOYDgHKB/9zG6zH98Q4kVmh/QO3q8xpoIABUv/zzjYX5v/ND1RomWQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the percpu_up_read() slowpath out of the inline function into a new
__percpu_up_read_slowpath() to avoid binary size increase from adding a
tracepoint to an inlined function.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/linux/percpu-rwsem.h  | 15 +++------------
 kernel/locking/percpu-rwsem.c | 18 ++++++++++++++++++
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/include/linux/percpu-rwsem.h b/include/linux/percpu-rwsem.h
index c8cb010d655e..89506895365c 100644
--- a/include/linux/percpu-rwsem.h
+++ b/include/linux/percpu-rwsem.h
@@ -107,6 +107,8 @@ static inline bool percpu_down_read_trylock(struct percpu_rw_semaphore *sem)
 	return ret;
 }
 
+void __percpu_up_read_slowpath(struct percpu_rw_semaphore *sem);
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
+		__percpu_up_read_slowpath(sem);
 	}
 	preempt_enable();
 }
diff --git a/kernel/locking/percpu-rwsem.c b/kernel/locking/percpu-rwsem.c
index ef234469baac..4190635458da 100644
--- a/kernel/locking/percpu-rwsem.c
+++ b/kernel/locking/percpu-rwsem.c
@@ -288,3 +288,21 @@ void percpu_up_write(struct percpu_rw_semaphore *sem)
 	rcu_sync_exit(&sem->rss);
 }
 EXPORT_SYMBOL_GPL(percpu_up_write);
+
+void __percpu_up_read_slowpath(struct percpu_rw_semaphore *sem)
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
+EXPORT_SYMBOL_GPL(__percpu_up_read_slowpath);
-- 
2.47.3


