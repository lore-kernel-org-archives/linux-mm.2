Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B16BDF8D758
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 15:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B38996B0095; Thu, 16 Apr 2026 11:05:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEA106B0099; Thu, 16 Apr 2026 11:05:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 803AB6B0096; Thu, 16 Apr 2026 11:05:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 59BDB6B0098
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:05:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1FA1313BC2D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:05:41 +0000 (UTC)
X-FDA: 84664743282.02.81F0A96
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf28.hostedemail.com (Postfix) with ESMTP id 67DE3C0016
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:05:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=D5DQ6guF;
	spf=pass (imf28.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776351939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8xulR7JjCNqJss+1hEV+Wl86yGJuhLSBNqNTNYuFwc=;
	b=Ve7GjUlLj4Yzz/mfbT9REdI38v7U1wLeu0eUMQzFjHI3Q97nMjN8NTICP5NAvlkL72/vKG
	JwsKy0B0xDXAFddMuemyKSJRecBi+kWVkpMH4dFYJWsAe4g6qvO/7ptILsPEenoOqnSQwm
	h4mvcpK9xBtq0zcgHNexb6maA6astek=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776351939; a=rsa-sha256;
	cv=none;
	b=WoJvCseE97V42v4QCsV6I8qJ8ASwQ2Q3DREF3VY4i2jOKGjZ66Tf9Go+dMWZO4P1F+/TyA
	QZLdZy/Fw9ksDrUSkbFn3WtqFW3Ii59VkfkfsgZOb33mG0jEC4So/uy+5o9zgbIhWVxUv/
	+VBAh1vRns6yBahOBMNqfYcCe+LgOes=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=D5DQ6guF;
	spf=pass (imf28.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id A14B2C7449;
	Thu, 16 Apr 2026 15:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1776351936;
	bh=D8xulR7JjCNqJss+1hEV+Wl86yGJuhLSBNqNTNYuFwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5DQ6guF7Ywnq+T4TcmGaOvR9vQeJOZ5qbphM7VEVdzCduoknOLynXGcqMXroOQUD
	 Sy/KkZXeMb1oW4Rc6STD5g6Ymo5SiON6w8WYKu6yeJpskapDA5zGG5U4OYXtNR31Jl
	 29TqDiToONSpxM/rdWX86C2ZYc/cO7sAuVqOo4oI=
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
	"Paul E. McKenney" <paulmck@kernel.org>,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v5 6/7] locking: Factor out __queued_read_unlock()/__queued_write_unlock()
Date: Thu, 16 Apr 2026 15:05:12 +0000
Message-ID: <eabc9de3347ca042eb0593c9b81c8e48254a4874.1776350944.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776350944.git.d@ilvokhin.com>
References: <cover.1776350944.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n3by4nsckbuw9yjekjw5mhkpwyqsqpug
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 67DE3C0016
X-Rspam-User: 
X-HE-Tag: 1776351939-593835
X-HE-Meta: U2FsdGVkX18ZmWTWAsnu/K5Dx/Uq307PM8v50e2FtOCvTBmp6BHrUeZ01hzrTnCeuEv/1fBTQBpWzKIKHDteKJoT1NGAlBZ1vfweOa71s56dio2nXv/3ijA62l1CiLQoobhLVmBBpRceFDkRfGPqVYYvb0401lYgKTIBje5Z/IORZHSrQy7CE28UQZyfRjJYUidnLkSac1lBA43lQEPCkB7ayhXgo5Xyv1wL+N/K7wpqboHEjy4+XLl38tlGVY9Zk2i4WIQxkcBkp22aldb8ZpUJh7VZmmLHvM8yNNbTcy2MZe+JUwhUkdPiZxQDm5snphhdAD6HfLbAbprp8gDC/Uvh/me7+lb08i9QXitwemY/fBKSN6nFlwXYXPALo5W3kD0EzLpryhGR5fedFHXNS+OM1Yv+AcpTz7KKiwJO7SPKQmgpQCJjpHp996tSun6b1ZHRCG1ZLNJvxb5+/mJJYRwGFg1Z5hAa/I36KwpGhVbu5QB1gcYYIFatsfF17pGbcDyx9ifsS1KjlbM5RRJYNQ2Y+NaSCcaHZgmcqyFZe8wO0RQcvbxMxEag+UBnOylqd6dfdXPDpSGBddZJNw2cf6ISvYGZnumMvNzdSQ8/wRBLW5kpkZrUFievlV9Ku5Ha+4+tc653kOVEXDVv+d7022JcC+de4gAHkYY2vevHy5yDWUBUQX23msLBroZJIySSO03FJ3dMtBMY6JdRnc5xYCrZNnrb1fTGLfJ1Qph18byeOW7WvaiXreNphxGf/VEMvYypELG3ANZ4yFuKBayK9qy199nOHIQBFexJe/YA5AVqGTni/uiAPpXl/dx6iLWEuuqSQBkd63jHiQfnR0uEaUYxgbIw202U4Y/+jmB9lcRwY5mopRaqtrV0nDnAqRl9N92+L4e/xAtAzpTuVSLETzfKi3X17nGCjkF+CbdWMfZnf31GTZOIlqEAfl31g7WDo9QSERW/u39e+FCgDam
 +4BCouUF
 HNMqZ9RytDsr+oeu2j9UwQGDJI3Rqmib1vZMcjiD83bw6RxgMUFZ05PDsxmXrhXYAiRpz9SbxtNitzUr/sIbHU9Rsd1QF6++mnu5ivevrTaZNQoNFJvAGPwkpwW994v3CjE9cL88QRW+hm3nad+iRaB6IQ9nsep0lLWPvvP4VoWgo3aKNDNy5qDhYoVHmjcm9TE40fHwdotD6RzM5iVMIdFePJyBrsBptJbLfVKTbL79GCsCuHisZn6zT/TIP9pts2dzC5nM4UZ5g0PR/bWEoo+K2YdA4ScAolH4BR3Yq6N44DK0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a preparatory refactoring for the next commit, which adds
contended_release tracepoint instrumentation and needs to call the
unlock from both traced and non-traced paths.

No functional change.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/asm-generic/qrwlock.h | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
index 75b8f4601b28..4b627bafba8b 100644
--- a/include/asm-generic/qrwlock.h
+++ b/include/asm-generic/qrwlock.h
@@ -101,16 +101,26 @@ static inline void queued_write_lock(struct qrwlock *lock)
 	queued_write_lock_slowpath(lock);
 }
 
+static __always_inline void __queued_read_unlock(struct qrwlock *lock)
+{
+	/*
+	 * Atomically decrement the reader count
+	 */
+	(void)atomic_sub_return_release(_QR_BIAS, &lock->cnts);
+}
+
 /**
  * queued_read_unlock - release read lock of a queued rwlock
  * @lock : Pointer to queued rwlock structure
  */
 static inline void queued_read_unlock(struct qrwlock *lock)
 {
-	/*
-	 * Atomically decrement the reader count
-	 */
-	(void)atomic_sub_return_release(_QR_BIAS, &lock->cnts);
+	__queued_read_unlock(lock);
+}
+
+static __always_inline void __queued_write_unlock(struct qrwlock *lock)
+{
+	smp_store_release(&lock->wlocked, 0);
 }
 
 /**
@@ -119,7 +129,7 @@ static inline void queued_read_unlock(struct qrwlock *lock)
  */
 static inline void queued_write_unlock(struct qrwlock *lock)
 {
-	smp_store_release(&lock->wlocked, 0);
+	__queued_write_unlock(lock);
 }
 
 /**
-- 
2.52.0


