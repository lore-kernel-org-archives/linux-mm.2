Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41B83E7544F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 17:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3D36B008C; Wed, 24 Dec 2025 12:34:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C1616B0093; Wed, 24 Dec 2025 12:34:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6613D6B0092; Wed, 24 Dec 2025 12:34:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4A1A56B0093
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:34:08 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F21CD140437
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 17:34:07 +0000 (UTC)
X-FDA: 84255062934.04.2A9B6CF
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf26.hostedemail.com (Postfix) with ESMTP id 646D0140015
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 17:34:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=wPGl1lV8;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf26.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766597646; a=rsa-sha256;
	cv=none;
	b=OgM3VOtnKNsqDAhUJettSSxKPwuojcG1hgCppnEuc/ZKYFTAkV/FNirfcQLxY92135ytV0
	ANSiXbn/A4iaf/QvlHgx/ie/NRa/rcZqRNe36kca+zHxKxqBeXyRrqPPYBKN0v/JWSM6mW
	xLTiIWsA2pxK4jW8QhUSdW5zEZShvlk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=wPGl1lV8;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf26.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766597646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2CDN18JsLQ2lkxbVIsQQjPwRxfXSOdUFY21zfgGMtQ4=;
	b=liGxA6KSFikhJTstCS/iIiowlNLMswjTKVzhhknh8D2T6fRD6OCPCtb5Z8/ABjh/8b6f6d
	7YBzoyZuIAT/QKfiJxMfVMEmpnX8VIGvyDW+UNYcpRQp5F2aMfb23mPi5G4CATAxpXr+Wm
	IO+42yKbvu0JLT6neMvbgE/1X3JW73A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1766597645;
	bh=2CDN18JsLQ2lkxbVIsQQjPwRxfXSOdUFY21zfgGMtQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPGl1lV8BtmA4wS9kzpWh8wFbWbXztbx81F3m8K9r6NMNkeUCc7vFctVGUWmcmiQr
	 Rj8lbZL82zZVEyBSvdbVlpmqpRpB1InHW2RfF6sQCI/bjZu4CaLolZEYt8XN600fGd
	 1l0Mlu9P9U+WY5noI8j8mDBoQs+LbILtIS4Ia+j7qulcXMQis7kD9gXQoCc0eo1/nU
	 Qi+9AiHBzkSuy7d5379rWGrNdcFtYNuxEZSCnriXfaMEvzKREX3ZJoHVxfoqoSOcyf
	 6oNSC3IfoQehKI/qSrOZWderVFIdT8SexI/hyIGs/3bXjVWJdM8GjfZ3BZG610ABvI
	 ck8PPcc17Z26g==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dbzWd4H7lzfHq;
	Wed, 24 Dec 2025 12:34:05 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	stable@vger.kernel.org,
	linux-mm@kvack.org,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v1 2/3] mm: Rename cpu_bitmap field to flexible_array
Date: Wed, 24 Dec 2025 12:33:57 -0500
Message-Id: <20251224173358.647691-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251224173358.647691-1-mathieu.desnoyers@efficios.com>
References: <20251224173358.647691-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 646D0140015
X-Stat-Signature: qg6fswuew3nmgrfz839muedifdreoycr
X-Rspam-User: 
X-HE-Tag: 1766597646-98538
X-HE-Meta: U2FsdGVkX1/6s0NWj4mBseiMLuksIEVC8tbFGULk4MpWjsXMGV22cekAvyKCsNu6E4NYHyNJuZWwIpw1bk9B26ugxtPGozQpTLszs/hIhwWRnhNPd1hwAz4UrV0HOjSmpd7kHJeBdYlQB2XpnryFG1fJ6ckJ7y+u/3R37Afx5+r9u7PghPVvBLXOPcy1cqipvZl4stPX6IVu1sQTIBWCx9Y+CB2VGmSq/zrwO8yP1ZoIPFnWWm+B+c11Eo5EvnGk+qRUKSLUoz6fLwipvl6G8a6VT84SAQBnahJfmxgZcl7nAhCr+p0v4i/b8y1shgzoaDJ/X/oNd/iJs2HWvxNtOb0PkxfFS8XdlNcNBix7t7aQVMOTMXQnFhwvC03EwXJVyku3/2qPDXDMl7LxwxnSaR4cz6i9+GY5v71cu8jajjM5k8RlaXqePSrNvixPLZvssWFNoPncvghWO9/B3oM5QuUSOoUHRlSvGFLBOhJfHZnfm7DwZ50KcVKDpS1t1FwUaImlFoKS9VI8/q/ltCap/OrjbFS7ERjh0vIn59tgYRvULh+xrG1KifadFHWTQ17WB5ZCBV9qXfCcziBJFdb2FxPWv6M+sFbhAfwMUmq+y8dSYnlQzH440aA2wYJnEroJGAwMTXSh5Q4HxDvsADM5UIfinoZqR7SFi33Oqum3oJQ8FviOsnEr+moJevMY9tGCamLW6Lb7pSc1SBc/4IYxe65dPTRz2r6pSB2ORngxI9KsMMM5ipMAebXZRbMo3XSIkdSMlHe89vXlFWPYMSvqL88+UKjf/F0gqjsEyYiyXyk21H8DeF7neirWsuhkyn6sNDwylRHxeBcD0YXT6B4R+til8owhi0O/lYPVHCne+H7DVSS9h0a85wQqb8Z5W5TIPV7anWaDMzqLk6NuAGVLUbGlml/HmrqZGgUjODBoe9MugR5SgFl83U6Zn+ObktFLxTfZX50Z3s9pTEKOzWS
 Xokhd5zs
 nKSR7ZgX60mbXFnyhdD7sQQ6HknBENPifYb85qrn5pkwYxGuxNgfo7sQ2nrFN3lYRFIceXqrG/MauJUnC+BwEeSn4/BIDPWGULUh4swharLW9kyCH+UfABXjMEfJ459+yxNA4LKnpafAemSyIX3E49PCzcc+dJsCDQv0JA4I/hj28ndP3AoYjOqKg4ctTirv+s8Q5ei3xF0C0ykeI6Pr2h9rlFJfUvwOAF9foiloL2ynAKwnQw/BQf+mpS/Nd7RWtSAyV0rTzelWFoGZ3mroxaU3jGklUmVfd2qnUezbEY08TZfYFVs9Z4zKHqdSZwn6NpW347o3CUBi9qDzDY1UYclEFZbEej3PHkWrtEywaP7scETQVFZu8i8aomhcZwvk2onv1sd6usShfuRfnA8pDIyySYYolr8mLWS1Ewi5luk8BiP6czGn+j7jIE0du+UAYc9aB0lNp6UDmbAK4hgaPdmpP0f+wMfVN1EKv1HCwDXSVZX29sBi5xS9jqpFvdpnHWFR2z96y+WTf56Fvl5J/8yDbLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The cpu_bitmap flexible array now contains more than just the
cpu_bitmap. In preparation for changing the static mm_struct
definitions to cover for the additional space required, change the
cpu_bitmap type from "unsigned long" to "char", require an unsigned long
alignment of the flexible array, and rename the field from "cpu_bitmap"
to "flexible_array".

Introduce the MM_STRUCT_FLEXIBLE_ARRAY_INIT macro to statically
initialize the flexible array. This covers the init_mm and efi_mm
static definitions.

This is a preparation step for fixing the missing mm_cid size for static
mm_struct definitions.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Cc: linux-mm@kvack.org
---
 drivers/firmware/efi/efi.c |  2 +-
 include/linux/mm_types.h   | 13 +++++++++----
 mm/init-mm.c               |  2 +-
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index a9070d00b833..3f5c2ae50024 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -73,10 +73,10 @@ struct mm_struct efi_mm = {
 	MMAP_LOCK_INITIALIZER(efi_mm)
 	.page_table_lock	= __SPIN_LOCK_UNLOCKED(efi_mm.page_table_lock),
 	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
-	.cpu_bitmap		= { [BITS_TO_LONGS(NR_CPUS)] = 0},
 #ifdef CONFIG_SCHED_MM_CID
 	.mm_cid.lock		= __RAW_SPIN_LOCK_UNLOCKED(efi_mm.mm_cid.lock),
 #endif
+	.flexible_array		= MM_STRUCT_FLEXIBLE_ARRAY_INIT,
 };
 
 struct workqueue_struct *efi_rts_wq;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 42af2292951d..110b319a2ffb 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1329,7 +1329,7 @@ struct mm_struct {
 	 * The mm_cpumask needs to be at the end of mm_struct, because it
 	 * is dynamically sized based on nr_cpu_ids.
 	 */
-	unsigned long cpu_bitmap[];
+	char flexible_array[] __aligned(__alignof__(unsigned long));
 };
 
 /* Copy value to the first system word of mm flags, non-atomically. */
@@ -1366,19 +1366,24 @@ static inline void __mm_flags_set_mask_bits_word(struct mm_struct *mm,
 			 MT_FLAGS_USE_RCU)
 extern struct mm_struct init_mm;
 
+#define MM_STRUCT_FLEXIBLE_ARRAY_INIT				\
+{								\
+	[0 ... sizeof(cpumask_t)-1] = 0				\
+}
+
 /* Pointer magic because the dynamic array size confuses some compilers. */
 static inline void mm_init_cpumask(struct mm_struct *mm)
 {
 	unsigned long cpu_bitmap = (unsigned long)mm;
 
-	cpu_bitmap += offsetof(struct mm_struct, cpu_bitmap);
+	cpu_bitmap += offsetof(struct mm_struct, flexible_array);
 	cpumask_clear((struct cpumask *)cpu_bitmap);
 }
 
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
 static inline cpumask_t *mm_cpumask(struct mm_struct *mm)
 {
-	return (struct cpumask *)&mm->cpu_bitmap;
+	return (struct cpumask *)&mm->flexible_array;
 }
 
 #ifdef CONFIG_LRU_GEN
@@ -1469,7 +1474,7 @@ static inline cpumask_t *mm_cpus_allowed(struct mm_struct *mm)
 {
 	unsigned long bitmap = (unsigned long)mm;
 
-	bitmap += offsetof(struct mm_struct, cpu_bitmap);
+	bitmap += offsetof(struct mm_struct, flexible_array);
 	/* Skip cpu_bitmap */
 	bitmap += cpumask_size();
 	return (struct cpumask *)bitmap;
diff --git a/mm/init-mm.c b/mm/init-mm.c
index a514f8ce47e3..c5556bb9d5f0 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -47,7 +47,7 @@ struct mm_struct init_mm = {
 #ifdef CONFIG_SCHED_MM_CID
 	.mm_cid.lock = __RAW_SPIN_LOCK_UNLOCKED(init_mm.mm_cid.lock),
 #endif
-	.cpu_bitmap	= CPU_BITS_NONE,
+	.flexible_array	= MM_STRUCT_FLEXIBLE_ARRAY_INIT,
 	INIT_MM_CONTEXT(init_mm)
 };
 
-- 
2.39.5


