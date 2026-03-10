Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0112FD4F08
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 17:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 255486B0089; Tue, 10 Mar 2026 13:50:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9C86B008C; Tue, 10 Mar 2026 13:50:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 060ED6B008C; Tue, 10 Mar 2026 13:50:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B25C26B008A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:50:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 35ECA1A02B1
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:50:02 +0000 (UTC)
X-FDA: 84530891844.07.BDDADEE
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf28.hostedemail.com (Postfix) with ESMTP id 869F4C000A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:50:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=kxsOkVRa;
	spf=pass (imf28.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773165000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FFBAWoDKXOeVOuQXKj5q+fWgOHGRaGxuqGKFcXPZMII=;
	b=mYX0RJtapzmwuvk6Al/d8utqSX0ieMhOYIrU/+KQ9JG6EdOblOoTjKUMlNTx273pfkggiu
	Mm765LxBh/kavHPuo7xV8uH0AYhetM11YOsmJRVearuzQu2CZNvEy77o1HSmb4Z4kLbulA
	dBufQj4uPd0Rilm5veS/MAiygorCJgk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773165000; a=rsa-sha256;
	cv=none;
	b=ASmrpWlytkhpGQBMHnMh9ebRNIEPTLxeJYFvqaUpsEuWmKxdRohOE4hAMwVEvhxKyuIovg
	W8QAh0iqZcNSTGHFEAncWxLugPemOpLztBBS4sJA++pjap2NjohvWAIC8uSmmJX1qUBUOj
	jO86tW5jrgy3DZ5jSCqGc9SwXxfl9zE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=kxsOkVRa;
	spf=pass (imf28.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id AC3C1B3828;
	Tue, 10 Mar 2026 17:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1773164998;
	bh=FFBAWoDKXOeVOuQXKj5q+fWgOHGRaGxuqGKFcXPZMII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kxsOkVRaylw2OeN3FtnmfCFnpUQC3bq//Yszn92KJFlLJQSGbjlV8DOKDHZXNFaBB
	 qwYwPijedBiJKjYp9QLJ/5YVy0FhmJEJ9OybLgFzQWId/9awS302KKrYY/4objmnpY
	 DBN721Tcz/2jvUx7EEtsJo31GHCLjDpD33PLhLjU=
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
Subject: [PATCH v2 1/2] locking/percpu-rwsem: Extract __percpu_up_read()
Date: Tue, 10 Mar 2026 17:49:38 +0000
Message-ID: <a065fd88990c0091a168b1d6715cd0cae8e9066c.1773164180.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773164180.git.d@ilvokhin.com>
References: <cover.1773164180.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 869F4C000A
X-Stat-Signature: y8ufkh1gp7jjiooei8hxw7q3c1ifiu4t
X-HE-Tag: 1773165000-869509
X-HE-Meta: U2FsdGVkX196ns/MXuQBbQtzGsxpt/V6ebUjUoRjI4lSBg/S52OYwRDHY/D1om6RLx64IZHFXHQGTlWnQNC6Pg6YBI7sLjZUG6mjr9VF0pbewoWLg143DXMZFmIjkcQ195WTzgX4puy7CUlz8yIdUw1NIW4P65tgZnEeb1j7UZhEqVAugP08vEhW6G7EdnVX0kyL8dH6RpNI4z/lyr4oSbDDyNKESeq9xucrh2OudqZpy3hzfL1lESqbMAE1ZYmhyB2Yup2VJHYew2WACKK/5ECmn2xg4I/3DOWiMW+iKjcWyU6EzWQF3+E8Cu33zfj4W5rD/hgtqq2Nd1/p+G5km5W8T1l6uUSUUFcvLYP5oiRkvKX2scLv3x+/kwf24pXVUMaj07tEF2WOuWuIdbjEvGNbdFJpxX/QtUboA01MAtMCoJuAygD5rXClbg0QD7oct870EvvVlPnY3FqFeWFt7NAfSzg0HmAYiL8uM27mahg4q+yhYTJ8FKOMVtkICDMt/XygZWzXrxRQdJTQk9YSr6RU73Bg91oK2+bipYM6BMeVMCyo9fdF2GjkxKicEWoNMtN2keDxQ1le3RyAMey2/gMwoKvgjbmPk5YVObZALPQbkzig0sAtCSyymh7kKv+Zh0lkjabZM0zEx5c/a+MAydrcMhcm2QTTjzscwfE0yfgPipCkkkudF5oEjEtIbKkhPQoq1FrU6uFo554Zr0y91EfC1BUMSD3KMBFyvm1040h1chfkX68JT4FFjU2rEeQVcc/GGxOIpOOgmZN4zJzGd9Qi02Bp6KAXzgQzBvgxySlZcmeFWzWm7mmM2zUnI7cjLlZ39M6h9xfW/RPEaxa+uVj8V/vcaPiWYfvE/ATQ7pJtu1cXPjZAAlyZhDfyWC1WoCgarg8RW2RgSL2o04YpWdzgtw93Acwzjse5i901YhB0EiLMhm/xDRqnAF+HTY7TPPU4CnUYfNSmc4jPflO
 5+MxdTu2
 M+QnZQjH+cVVnmUsotDi5Ymhf+IMtdxTAGmGBKj+wLcKorPcbJ44h3wJo4ThcIWoe2J//xkZhk4vVMEJIF68NCvVYqbRKp7tUPhuLojoFKxk8rkkIzYA7RsUNchxVL3EPzykinkfgrzyqgU8g3/6ivotvwXUT9Hxw7zAFsPIdb4vMJa+6IWeJ0lOmFNBt3v3mb83zimf+9jtDxRL1dhyShexrSxnIGQ58Q++iTxDX80eoH+wOi4cIYe3NMHxwxxziHOlSLonrfkesCZ4yIiC6cpSuz4Lc9PoW5Tf5ZaeyMlvy62p9XVSiXYS74Ng3B9wOhGJYCEwR5Tk8Dps=
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


