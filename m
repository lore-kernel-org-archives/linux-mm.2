Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C762FEFB72
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A1606B0099; Fri, 27 Feb 2026 12:56:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05EB56B009B; Fri, 27 Feb 2026 12:56:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2CB6B009D; Fri, 27 Feb 2026 12:56:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D5E126B0099
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:56:23 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D9E0BBA4F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:23 +0000 (UTC)
X-FDA: 84490991046.02.C30641E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id ED943A000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772214982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dYNJlbGwE4Wr13FZSkk2z/ucESOXdlXZCqV8vtx8oiA=;
	b=Thn7Ze7ibyuE0MSvMxABRu8//21Fmmm1pNlnQ5HoZYVwsZ5HN2Zyyx+5yV693ehK61F7n8
	s6z6r4LF598g2GJtBoYqNLz0D+saW3Q3MRZuH0EJS/Cve7+Ed5YeOv83+CzL9IXkwRnPhq
	dSmfT6NrelfDNDxNJN+g7YGf3rlf2Pw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772214982; a=rsa-sha256;
	cv=none;
	b=OKVI6yxcqzOnkVhLrOQ2T+hRjKOB4V9E4+1vRNH7K29oiwqxAeGyi8WjZaJ8UMt3ma5Vco
	gmhhvUnalUiZV8feXmQ2BB1VyHdSyncgondoqA2P5DNzcHgUQIq5M0dL9+uUg0XHNsoAa3
	Wezgtr2kaHBXtQkJZRcHWZO5P5L05Cs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE29819F0;
	Fri, 27 Feb 2026 09:56:14 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AA6363F73B;
	Fri, 27 Feb 2026 09:56:16 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v6 08/30] arm64: Context-switch POR_EL1
Date: Fri, 27 Feb 2026 17:54:56 +0000
Message-ID: <20260227175518.3728055-9-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cbzbh1stc675tj5poxh76ae9wtsbf1rr
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: ED943A000D
X-HE-Tag: 1772214981-941607
X-HE-Meta: U2FsdGVkX19kTyOhOD93I4OL1QCBYeLBxaXe1Nn0tK4oPnM/Mqh9yQnpHptnD138jUtQh8gjPiG7xaPXX/rLGyjVJ8jwb6E6xOqOzv1lOBqNKTMX18q83dYO6U7j+42WVZOba444R4EEgyo7jFvweeYKv5TyPnsFHEisaROAgS657EKA1apk+eEyz6qBPOPAaD9SzDNxJHH3jDYcJSm8CbMvayfyr7+Ajnu4eWff/2Sh1yNkJItoeIK3cHRwPYALHIz/qF0pmt8iOdpDhAiz7LGeGQczRk2b+x9Iop/Bf776VZJBkRysMpEz0LF00U2o0GeC1X8fx/s81vHsIRGGRoU6a9fwUcj6bYg5cu44kNIBQbBTq6YreYxHGPuluRaK/OjfnH3rxJ+ZG6AkT2k9kEMjCwaVnYCK6iW6jdMdTpxsdECcuO0/8ElqK6E7O2AeMfPbeShtCGWIUjLFbF+jgjau/4Hq87d03xil6SyWkRJDkbTL4624XMoQ3uzHOQTRsGPo+l0bM472+WBMrJ1+rqcGXgQEIzjv0ESjIsQFrgKq3+iQS3fQVAiNh30ILuPV1kVJrt7eQeiwqOacOOwH0J0zZVV/Ao+BAq9K6SbXRyDPK3+xrMhxSCVg3fwJyP51cOHqmhU45kJDaXt3kB5L6BKsvNMZofnhkPzToRxaYdbMV9oEFgYSobqHZfJ0zXfduueRZEL5QF9MXikE89oziQe7fRcM5B+u4Kw7rCAm63dH13fjZkhQQ9JDhAHHvr4zb7en+YSa2ijmQ2/jKbz9FFebr5ECPHM3dVwV4sSHC4p/0yntMEtbJsr1m6i2NUdYFqQpuLlixlR8CligX4Aw2YHHja14xLdam5psz78Gcz34fz0epIlEwGakbgmFsFkMHcFEwVdox7S+WP2UieNiMJvicZqmhU8JGjc+ubnc1i7WchjsOZfd/QDgkR5+XSCYOIph9U+Bn5CugZeBeTL
 KbnZdBuL
 ZXcmO19xybBkap9bv6BV8mHbvw92HyfCcUh8Y3CKbE3H2yhG2BeOCeHCVWkTfFg/FqqgxDhhJ7S05v3FykAOYk/XY6+rBzLttckqjTUIYDff5kQsgmYsbpR8lZfKEwC87m25gyagexnZN4A5k2hBgzY+ev2hyrGKOLgayaK1dlynSKK923VpuCcoAXEJqvKIDTNkufGCyY26dEkw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

POR_EL1 is about to be used by the kpkeys framework, modifying it
for (typically small) sections of code. If an exception occurs
during that window and scheduling occurs, we must ensure that
POR_EL1 is context-switched as needed (saving the old value and
restoring the new one). An ISB is needed to ensure the write takes
effect, so we skip it if the new value is the same as the old, like
for POR_EL0.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/processor.h | 1 +
 arch/arm64/kernel/process.c        | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index e30c4c8e3a7a..6095322343fc 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -192,6 +192,7 @@ struct thread_struct {
 	u64			svcr;
 	u64			tpidr2_el0;
 	u64			por_el0;
+	u64			por_el1;
 #ifdef CONFIG_ARM64_GCS
 	unsigned int		gcs_el0_mode;
 	unsigned int		gcs_el0_locked;
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 489554931231..618fb5ce1c1d 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -429,6 +429,9 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 
 	ptrauth_thread_init_kernel(p);
 
+	if (system_supports_poe())
+		p->thread.por_el1 = read_sysreg_s(SYS_POR_EL1);
+
 	if (likely(!args->fn)) {
 		*childregs = *current_pt_regs();
 		childregs->regs[0] = 0;
@@ -679,6 +682,12 @@ static void permission_overlay_switch(struct task_struct *next)
 		 * of POR_EL0.
 		 */
 	}
+
+	current->thread.por_el1 = read_sysreg_s(SYS_POR_EL1);
+	if (current->thread.por_el1 != next->thread.por_el1) {
+		write_sysreg_s(next->thread.por_el1, SYS_POR_EL1);
+		isb();
+	}
 }
 
 /*
-- 
2.51.2


