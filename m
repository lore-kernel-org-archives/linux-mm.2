Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A79606A681
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 15:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eZ4tYm+S
Received: by kanga.kvack.org (Postfix)
	id 53CB06B0A63; Wed, 25 Nov 2026 10:56:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ED9A6B0A65; Wed, 25 Nov 2026 10:56:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5596B0A66; Wed, 25 Nov 2026 10:56:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DF266B0A63
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:56:01 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 94DB180F16
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:56:00 +0000 (UTC)
X-FDA: 85474092480.12.3CB605A
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8ECE2140007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:55:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eZ4tYm+S;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of shalasheg@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=shalasheg@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795622158;
	b=21zSM3OGFla8Q3TFC8eatFq1xkH/pdJIvrOIjPnL96BUOh42yxQ1o1f33J1W614tW5+sjy
	i92yLL/6qZKN7KlX/Nkf92Y6RnOXfUVwtBYcXXvydm8tT88qYB5fxePlK4LcpYXntp8oor
	LfYygil0LlTN1YVklBDWZMowFK4dl10=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795622158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ilZkP46cGSi8xAEGGltwn2YY6bly9+EZHVBMEUvniWk=;
	b=KiLOC/dgOXRwBbO7I8jrSYChLK7y4Qq7N72/bvlobtNEoo9xoIUWIy19XkWlerKvyFnrLH
	N0+Vfb+tAnz+HnwYNZqjHJ1GzmsbqRMPC/RaMfYs+alVlqbLQvkDLAnb96AdB1D40CADc7
	L2FJlZ5y3oo63hT3qSSOTa8f93Bw4+g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eZ4tYm+S;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of shalasheg@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=shalasheg@gmail.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3adf87fc0c6so51830821fa.0
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795622157; x=1796226957; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:cc:to
         :references:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ilZkP46cGSi8xAEGGltwn2YY6bly9+EZHVBMEUvniWk=;
        b=eZ4tYm+Sosxna1P3M15wIdA15rqK9wWreplf/HMVRZoKSnev+W1UopuXR0rm1zq85z
         gqWoKkisibsQTHHmbt72O+gz8Xa3g8adyjdTkZUjNc1aOZO724/h7+tAwITSh8HflEW+
         LRrIOwSWmP1DJV482nqvbXvabJFu3csWJY7Avm1fEgvFE/A/3S4NoB2Kn4ziNAQpCI5x
         NN88JLZUQ+OurF+52UtayH6DvmpCbR9PUrGbMNHtPLW9fYLNy0kJimnkItqQlW/pDAeN
         emSsnY/T055Ti8ojyrfcXPE8n3GJKp0kjVXgCx5cnqeYYOJf9WtiQKKiesgrq2R/XrAl
         2q6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795622157; x=1796226957;
        h=content-transfer-encoding:content-type:in-reply-to:from:cc:to
         :references:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ilZkP46cGSi8xAEGGltwn2YY6bly9+EZHVBMEUvniWk=;
        b=dLww0rh6NkFFeJQdi+kiA3IBq2dAlkwJlkj5fYAWarODNBgsZMcgTX6wYqBWKMIxZt
         sZvFpF957WBwmYxnvo0BLpRfUqk0sJdJNK4b3zfPh2ODgnUydICOM4SVWCIlIJ8HBunW
         USTsQCdD3gXB/tAA6wlN7Ocm8MC5hkZtD6ZaXbVPUTZP7Qo7/d50i0Oq8xXAfi0UOByv
         FsssUlscBZ0vUAFFiVFp58cM9gAYElENThHuX+oRANRqOhgeFoh/uTmnxERqgPjko7Qz
         pv/UofnLws/GnzQPfHEQV7JJArVGhiv8qtX5tyoQfKaGfbiWte8EMoArgRzzhKDeGQaO
         lYdQ==
X-Gm-Message-State: APuU4Z8+Zvf7vYqKpIq5I2oLUIzB6E3pYqezaWMgmLk45XjaVxxDpXrO
	SVVhTJvIoDAaRCwCxIUPIJWFo4sSFfXl5ZZyUccv+dJPr5XOGOZKugsd0YXjlqOwvQI=
X-Gm-Gg: AZFdTZcDU2mXsRWIwz5Se7iARMU03FEsWR9VcXrjBob6g1Q7aJF2D5oDub7Gc5PK3iB
	iK7jpXwKvkDQF9FdKkRiYSJqC2skfVC2hiV3HKZNTIAXfd4x/BKvSX/FZ4B9mYHUKPwXtZ5HjFY
	xHoitmYqVs+8CT/lpG79NR6Fvu6YAosxRRkjehgi/EFq4gAOeJSdEPOFGPJUsuNFicNa038X3Zo
	iLbRbM4bbJzr8/pIbA/p//PxNQBmBEY2h2MAQvFibP38l1nvFK2bRjiworGA0V9UphD92rwVug3
	lqVdB73A1kIBzlXMbEk8c3hgkeYCw91IBQoDTHRaSEotZFCi4zh1F0DNkMAspwt1xO2uSeiecTh
	Ufk6X7ZS8kupGRt4IngLMhG3hCmXLyGfiCclB7DhIO7lUzd6IBj6UwnwQ/73WAobOVnmV0Zp9fl
	B6pSnMCf/NRrLIGa+M16HoTiW6Ms0tBCVcL5Qh5iIsCQ6CQgyMcSV5zNnTIo5JI4VMmqTuMQHl2
	LlxTpj+qwoPvcTnEF/W+A9EhrlTlqzpl3v7Z9wlrG3vRwdsMZZZCF3u9aO/lhACHr1trubSd/zA
	+sFMCrkIijXv6k5lViy/PxKGEBqo40sxIS6v406IoSk7MDczTcuXFJ5jLnRjz47mSm+/mLbYE1b
	+98iJ5Ws=
X-Received: by 2002:a05:6512:3b08:b0:5c1:b29a:1ba3 with SMTP id 2adb3069b0e04-5c1bc7d5ce5mr7526450e87.29.1795622156730;
        Wed, 25 Nov 2026 07:55:56 -0800 (PST)
Received: from [192.168.0.103] ([46.8.6.187])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c1bd0776edsm4838279e87.73.2026.11.25.07.55.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 07:55:56 -0800 (PST)
Message-ID: <6c943754-05b5-4017-9145-0d145766909a@gmail.com>
Date: Wed, 25 Nov 2026 18:55:55 +0300
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH] percpu_ref: make percpu_ref_switch_lock per percpu_ref
Content-Language: en-US
References: <01612865-faa0-4fe5-8184-a177f104843f@gmail.com>
To: linux-mm@kvack.org
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org,
 akpm@linux-foundation.org, zhengqi.arch@bytedance.com,
 linux-kernel@vger.kernel.org
From: Egor Shalashnov <shalasheg@gmail.com>
In-Reply-To: <01612865-faa0-4fe5-8184-a177f104843f@gmail.com>
X-Forwarded-Message-Id: <01612865-faa0-4fe5-8184-a177f104843f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Stat-Signature: bskfigticzgqpus3nu6so3kye9wf6xx9
X-Rspamd-Queue-Id: 8ECE2140007
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795622158-25656
X-HE-Meta: U2FsdGVkX1//fZLDisD25xshG3mQ6G8sVleYwVzrBw6QiZXYJZA5/NzKDv6df04iCVaUwVd14maumhuuNkrWqySkjTfuNupEG+F/5vSm92fKjErzSg2IptPqhF8r4FzvJiGfMTpDIoQY+DC36Zs7Ae5C5RKf2yNpUaGIt4WowjPDMNfb176hJWPT79f9WeGem6x9P5+V8axt7kTY9r+xlRMjLkQGVBP33Bi6RsD8/rrx3kAtBQV40ZF3X/ucIjMCsOlgjAsC8leQvNvvc7Y+u2Xc0eSYSNbzzAYVwjfmss4Qj0Iaa6aViRXsuBm5kHIhiVnTXl8UNZGTtJcw7ARLGqlmRYOc38sidxPRLkMcMheUTE+rC9wcc9gN4QQt8aM46YyN3SkhsK7AZxbYpTcCQt8W9Wygd5YMxl0BACVoayr3S+2/ovD6t8ejR5s1tcT2WA7IFyKGNAqxmdfWw6B8Z7mNxjqutzv394ZpCZ2cA2IK0SCIXxrpgJJ34w0nUP5J+qQ/HSLQ2smoTJoDVzvD8YSmltr7FDy6ZD5+JW3E/Mdhm0AI7WEPZQx6w3oehXYgnqqFCwNjqCT1QT1rF6pfCX2KerKCjk6PKt77jcTuefXZk0806ga7G61YsaXQDdjzM/J1DQRde7H8klRu9Y1kfVJPOtVzYWrr/0Dg78SVWcPtL8MNR/W7Nb0XWI3bXv/vs3usPAr5d9cwuYnt70Ed7jFwc1IsRvrdOx9ISj7AN3Ql4hhHaRDEIGw0m4UAm49jVtz++w2vhlDxsSifCd7Kv33w/FjxlollToD1Z6gTikk3AS6mvLVjbGhAXE8nZTEBt1Y1tebB++vzpBT0+6fTH8yp3MUYUle2Y7aid9krNo8ZeHQzOA8LNBS+34EC0y18M1I0ncgm+NMlCvYi6bJvLhhEJIZqUCBxtE4cTnUFyTW/Z1xbS5IZi+58xnzajhC5xcE9zdvA/W0g4TU4Ltj
 KTARcIlD
 m8euUGpQLGzQGEOvMY5d03hMm67kmW+R1bIpeD024GLJ7r3uN4M6nqhock0cgFx5oCWNcIXoAmUvSshQJVFB08k85CvokPP7ERGKjpekO+fZfiMEfwT4nDTZaFEAuyR1Atm9Z5tKr6TJpGGmmDCVKTKhI+9KNS6MZH2occ5u1Qi3R9OTAAfEKy6UyVV80IXdGtZPkLMK3CH6uGG/WMfWk6NaTIP2lHjQyYKoWjisDqm2CFtAxeWqirQjy8thzkBtIFKYPA8mLeelOriUoA9zAfpNdrtJfZu5BJGDhyMPV84G1ExGY8QUThzp9WfvA1L0xk6Scvm91upYTA0impQaCDnub8a0JK8NDFmbtFCNeHmW9lQmcLZqx3EAZltlWNzVBPdkYT/+25V4jKonL8uuq6PsK2JOVehrNow94rLUMle3Z4kARs5hHfE8Td5/IbAd+5ADr0z8bo70MMk0btPbWX3mZ1uDQk+t3w0WSLY8tfynZ1SF2jiMbsxW1F/TFreZg2livZvwdLQy/cUlwtANCQwzxzm3wo7erS9qbqPoIzddeAM0Jj8L+y8Kx7L0/JFS468zd/wRDZ6cikC3Kv8oI9aGGI4y53KYU1hrDuVC4Rpve6fJdxsuI6K56J39bLsNLzn/oSG6GWbFh7q/u+76epPWHQJj0t9RKm1IpfLAPkARR6R8y70GzbR8HbySZ8aVbjA5MZNc4mkxg+lylqpfxuhJvMulx4kbvV14QTHn4NGDNls8QfgeHGaAp6a0FSM1bXHZVWd34gY8qeVTFXbDylEy7PA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

Currently, percpu_ref uses the global percpu_ref_switch_lock to
protect the mode switching operation. When multiple percpu_ref
perform mode switching at the same time, the lock may become a
performance bottleneck.

This patch introduces per percpu_ref percpu_ref_switch_lock to
fixes this situation.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Egor Shalashnov <shalasheg@gmail.com>
---
I would like to revive Qi Zheng's per-reference switch lock patch
from 2022 as a standalone change.

Our workload maintains many independent percpu_ref instances and
repeatedly performs kill, waits for references to drain, and reinitializes
them. Multiple CPUs execute these cycles concurrently on different
instances.

All these transitions compete for the same global switch lock.
Reinitialization also clears the per-CPU counters while holding it.
As the number of concurrent transitions grows, this shared lock
becomes a significant bottleneck.

With a module-local adaptation of Qi's per-reference locking change,
we observed approximately 2.8x to 6.5x lower operation completion times
in the measured workload. This motivates using a lock per instance
so that independent transitions can proceed concurrently.

Original posting:
https://lore.kernel.org/linux-mm/20220429133552.33768-4-zhengqi.arch@bytedance.com/

Rebased onto v7.4-rc4 with an explicit spinlock_types.h include.

 include/linux/percpu-refcount.h |  3 +++
 lib/percpu-refcount.c           | 30 +++++++++++++++---------------
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 1e3212e..4582e79 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -53,6 +53,7 @@
 #include <linux/atomic.h>
 #include <linux/percpu.h>
 #include <linux/rcupdate.h>
+#include <linux/spinlock_types.h>
 #include <linux/types.h>
 #include <linux/gfp.h>
 
@@ -109,6 +110,8 @@ struct percpu_ref {
 	 */
 	unsigned long		percpu_count_ptr;
 
+	spinlock_t percpu_ref_switch_lock;
+
 	/*
 	 * 'percpu_ref' is often embedded into user structure, and only
 	 * 'percpu_count_ptr' is required in fast path, move other fields
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index f8d9068..5d46602 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -36,7 +36,6 @@
 
 #define PERCPU_COUNT_BIAS	(1LU << (BITS_PER_LONG - 1))
 
-static DEFINE_SPINLOCK(percpu_ref_switch_lock);
 static DECLARE_WAIT_QUEUE_HEAD(percpu_ref_switch_waitq);
 
 static unsigned long __percpu *percpu_count_ptr(struct percpu_ref *ref)
@@ -96,6 +95,7 @@ int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release,
 		start_count++;
 
 	atomic_long_set(&data->count, start_count);
+	spin_lock_init(&ref->percpu_ref_switch_lock);
 
 	data->release = release;
 	data->confirm_switch = NULL;
@@ -137,11 +137,11 @@ void percpu_ref_exit(struct percpu_ref *ref)
 	if (!data)
 		return;
 
-	spin_lock_irqsave(&percpu_ref_switch_lock, flags);
+	spin_lock_irqsave(&ref->percpu_ref_switch_lock, flags);
 	ref->percpu_count_ptr |= atomic_long_read(&ref->data->count) <<
 		__PERCPU_REF_FLAG_BITS;
 	ref->data = NULL;
-	spin_unlock_irqrestore(&percpu_ref_switch_lock, flags);
+	spin_unlock_irqrestore(&ref->percpu_ref_switch_lock, flags);
 
 	kfree(data);
 }
@@ -267,7 +267,7 @@ static void __percpu_ref_switch_mode(struct percpu_ref *ref,
 {
 	struct percpu_ref_data *data = ref->data;
 
-	lockdep_assert_held(&percpu_ref_switch_lock);
+	lockdep_assert_held(&ref->percpu_ref_switch_lock);
 
 	/*
 	 * If the previous ATOMIC switching hasn't finished yet, wait for
@@ -275,7 +275,7 @@ static void __percpu_ref_switch_mode(struct percpu_ref *ref,
 	 * isn't in progress, this function can be called from any context.
 	 */
 	wait_event_lock_irq(percpu_ref_switch_waitq, !data->confirm_switch,
-			    percpu_ref_switch_lock);
+			    ref->percpu_ref_switch_lock);
 
 	if (data->force_atomic || percpu_ref_is_dying(ref))
 		__percpu_ref_switch_to_atomic(ref, confirm_switch);
@@ -308,12 +308,12 @@ void percpu_ref_switch_to_atomic(struct percpu_ref *ref,
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&percpu_ref_switch_lock, flags);
+	spin_lock_irqsave(&ref->percpu_ref_switch_lock, flags);
 
 	ref->data->force_atomic = true;
 	__percpu_ref_switch_mode(ref, confirm_switch);
 
-	spin_unlock_irqrestore(&percpu_ref_switch_lock, flags);
+	spin_unlock_irqrestore(&ref->percpu_ref_switch_lock, flags);
 }
 EXPORT_SYMBOL_GPL(percpu_ref_switch_to_atomic);
 
@@ -354,12 +354,12 @@ void percpu_ref_switch_to_percpu(struct percpu_ref *ref)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&percpu_ref_switch_lock, flags);
+	spin_lock_irqsave(&ref->percpu_ref_switch_lock, flags);
 
 	ref->data->force_atomic = false;
 	__percpu_ref_switch_mode(ref, NULL);
 
-	spin_unlock_irqrestore(&percpu_ref_switch_lock, flags);
+	spin_unlock_irqrestore(&ref->percpu_ref_switch_lock, flags);
 }
 EXPORT_SYMBOL_GPL(percpu_ref_switch_to_percpu);
 
@@ -385,7 +385,7 @@ void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&percpu_ref_switch_lock, flags);
+	spin_lock_irqsave(&ref->percpu_ref_switch_lock, flags);
 
 	WARN_ONCE(percpu_ref_is_dying(ref),
 		  "%s called more than once on %ps!", __func__,
@@ -395,7 +395,7 @@ void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 	__percpu_ref_switch_mode(ref, confirm_kill);
 	percpu_ref_put(ref);
 
-	spin_unlock_irqrestore(&percpu_ref_switch_lock, flags);
+	spin_unlock_irqrestore(&ref->percpu_ref_switch_lock, flags);
 }
 EXPORT_SYMBOL_GPL(percpu_ref_kill_and_confirm);
 
@@ -416,12 +416,12 @@ bool percpu_ref_is_zero(struct percpu_ref *ref)
 		return false;
 
 	/* protect us from being destroyed */
-	spin_lock_irqsave(&percpu_ref_switch_lock, flags);
+	spin_lock_irqsave(&ref->percpu_ref_switch_lock, flags);
 	if (ref->data)
 		count = atomic_long_read(&ref->data->count);
 	else
 		count = ref->percpu_count_ptr >> __PERCPU_REF_FLAG_BITS;
-	spin_unlock_irqrestore(&percpu_ref_switch_lock, flags);
+	spin_unlock_irqrestore(&ref->percpu_ref_switch_lock, flags);
 
 	return count == 0;
 }
@@ -465,7 +465,7 @@ void percpu_ref_resurrect(struct percpu_ref *ref)
 	unsigned long __percpu *percpu_count;
 	unsigned long flags;
 
-	spin_lock_irqsave(&percpu_ref_switch_lock, flags);
+	spin_lock_irqsave(&ref->percpu_ref_switch_lock, flags);
 
 	WARN_ON_ONCE(!percpu_ref_is_dying(ref));
 	WARN_ON_ONCE(__ref_is_percpu(ref, &percpu_count));
@@ -474,6 +474,6 @@ void percpu_ref_resurrect(struct percpu_ref *ref)
 	percpu_ref_get(ref);
 	__percpu_ref_switch_mode(ref, NULL);
 
-	spin_unlock_irqrestore(&percpu_ref_switch_lock, flags);
+	spin_unlock_irqrestore(&ref->percpu_ref_switch_lock, flags);
 }
 EXPORT_SYMBOL_GPL(percpu_ref_resurrect);

base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f

