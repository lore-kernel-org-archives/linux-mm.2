Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C1AAFF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 17:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB77E6B00AF; Tue,  5 May 2026 13:09:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D66D96B00B3; Tue,  5 May 2026 13:09:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2F386B00B4; Tue,  5 May 2026 13:09:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA5526B00AF
	for <linux-mm@kvack.org>; Tue,  5 May 2026 13:09:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C4C212056A
	for <linux-mm@kvack.org>; Tue,  5 May 2026 17:09:57 +0000 (UTC)
X-FDA: 84734003634.16.4864BD6
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf27.hostedemail.com (Postfix) with ESMTP id A132E40003
	for <linux-mm@kvack.org>; Tue,  5 May 2026 17:09:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=sWU2rOJr;
	spf=pass (imf27.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778000995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jiq9HHreSKv9gJ1OxNDx05z/LXXiM1SwacfPI7vtSKY=;
	b=vocxdlFkdS1pR75WxvfaAX4qD5Nq4/ezBk0XHX+1UgTp2ziJJN4MzpcmG1SUwCDef2Vlmu
	Iz0quQZvN6eUJDcHBQm8bvlZuU18uspgTr9QNpNpi3LLRYTq2tRO9Pch1CZFSTEF1mSw3U
	nEUk9z2B/Aej+j+fPOxk0fZa7ETjRvU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=sWU2rOJr;
	spf=pass (imf27.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778000995; a=rsa-sha256;
	cv=none;
	b=4P8QZquq9/XnXxurxIltitfdgO3roC4/1HXWoVbSTXwEbVXU6KIjEbJInrf6D22/hecfvK
	diq7aUiRdfw2qYdTAefx7q1r3KBXVQN8uy6stVNVYLAxYebO3p/pYbMXmyCfRciP3X9a07
	O0UceugsAlSY76wInVtboKo60GFRPbI=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 8367ACFFF3;
	Tue, 05 May 2026 17:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1778000993;
	bh=Jiq9HHreSKv9gJ1OxNDx05z/LXXiM1SwacfPI7vtSKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sWU2rOJrbDjkjTDizt2f9U5ELWqEaXAc5QmT9jVUAdoxkMtiiOnFCeUpOz6Z+KEGX
	 0SGGytVFpYd8E/QFVq933R0++oX41r40I8M6oQeN7FEE8k4o5N+4nxr6ZIgiZbqxxR
	 nQ05tef5x5Wsdba66GspFDa0eZI8GtHF/1JeTlVk=
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
Subject: [PATCH v6 2/7] locking/percpu-rwsem: Extract __percpu_up_read()
Date: Tue,  5 May 2026 17:09:31 +0000
Message-ID: <0a30ed3ffebe5753aabc083bbe93cc123227da76.1777999826.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1777999826.git.d@ilvokhin.com>
References: <cover.1777999826.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A132E40003
X-Rspam-User: 
X-Stat-Signature: etor77xt8mijhnoaamcf5ku5ux858yah
X-HE-Tag: 1778000995-359497
X-HE-Meta: U2FsdGVkX18ybzFWpGYqOJEjrhy37w8DLeC9GmpyHcdwtilxee8VXBmAKq17jzXf5EMP3mVqxbLOi5YiKKh6kfu+TCyj9MVZYiPpj6ifxzyu1b3gvbRyFfRV4gEUC4kv09/t6vg+lghayD7tBiLS3LKwCUmylkyk39Ph+4x5NkQd3z6bHbvbkLLdPMBQxUSI1FFTgD0Qyijunp3Sc57i5+/WEeBJwsRfLKXATdOao9dzWCrn/2kVdExOhA5Bd3FBQ9x8AuOrM5WQLKj0VZWriDNgE+n/GrYjKfqZ8lB+2RcYGzOfOfNzwnCf5Feug4Qq0C5BzgUPYyVdB3qUEQZofP9FLRlsr/5ALvXzHOTrksVBonzLvvZghs6JyzqetRuFGQxcpieZEZ4nk6f1UOsx38VUPTwq54a+Xy7lzwnpPPi47t/as1i+sLcoakrH8r3bcp6Mk0vH6qwloQKXz9FAYqUd9/jjU/fXZqLsDmEQOGt2qnDcAVQdicVagGWiJ48tO5XLpS1wmQ6aohJ1y5xAaNy6DVekAxxc5kC1mKk8VBZPJX6TTdqSjh7jLyxXsqrVIISAwffSbUlzfqgUhdN440zQxCSg41V7g1krHQlOdCy/XTRNsgWv8O6sVzn2WId8KNSkAmPX8da+iADn3octs8S9PmP0Fisz1gtak+Ez2CqtQ+D1MIwvnhnapt8N6ml79aoMzZZzgcY2EjDJJOHBrzzjRGLKYPwvJsXQYDVKpwholrA3oNVEpflwYQoxpbkugUwiivCB6y9FadNtljh2wnRVS+tDB67FuQaGQrCHANtI5k8qUfwB0Ecc25cLa/P6N6PCir+K1F7SArkhvrxiZTkl3b8FUs6F3ZZdlN82ab/CxoaiQ1jbHBjs9naOez+htb4tX8oTZrElG1JzAAG5awyO61ssQ0dtSG/YYuVqMRrBU/lyyS50Lgsv34MWmWqZodZGbV3X7g+grZBiJDS
 6FL+txZu
 8yY5DzNsCjRkhxrv1Hmyf6MRm5LqjhkYBlJHaevSiZ0pONdiFS4ATVrtsKCGGCYRzcLGxk5RXZmvZOrNQsXl+OYH8/LCgWpoa7Aukai5ruwyzsDHqrPEtAXbhhZ0fdtOHNiOHF9aOCMkZj4uzQSStugy3HMk46Gx8bQ5uzqE7kGQ1xvpViIoczAsYls1krTY62KyZcnEbaYKoFEhIWbtqLAd4kgvFc+//zFF4kb/QP8nTkzQh7Bzdm4P7jKBL0gZY7MJcxunEDg4tjMyFVIwiJ0ZVVPFnGQ/E6v2wJKGuhkN/g6yXdrmY3cAeYoKH+V3Ja+dWPJ9UyLdps5w=
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


