Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D18ACA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D700390021A; Fri, 15 Aug 2025 04:56:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D476B8E0002; Fri, 15 Aug 2025 04:56:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5D2590021A; Fri, 15 Aug 2025 04:56:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B48DE8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:56:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7EBA55BB58
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:07 +0000 (UTC)
X-FDA: 83778384774.04.7952F1D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id EFC9D180005
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MGCT3bkpP3C7Q+wzzJSTlvgGQr7R+fFEz/hBpLAh3Gg=;
	b=Jh2EFnUKlfHNRXYJ5O2D+TcFpijFLqmWOfJpc4/eRndc5kR7JDcImuf+PZNpfD1Kyl3vzA
	7PntKystnXuX3sVxCZCELJhfYKjUtkkSZv22XsqJeivx//YcWvKZRZ2W/HsX7mR1ma1zrA
	JxSyaJJjZs9dfS+7Sb+9naoevfDT6IA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248166; a=rsa-sha256;
	cv=none;
	b=BgaTU9RaL0802Yl6q+/dBh1KD9YpxW7Ev3dpcpzIf+DMlzjC3QS/dR5enrKqYohaLOu0tV
	fWo4Zpza2Gjl5nDyhV5E87pOs+yUmsKs/qW9Uidn9TAMuwKSMTfWui1jDywMYgmla/S7uo
	a8aE2jhSFLmWg8ftUXwrrEUtZrFAhWI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1BC321688;
	Fri, 15 Aug 2025 01:55:57 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B4F573F63F;
	Fri, 15 Aug 2025 01:56:00 -0700 (PDT)
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
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [RFC PATCH v5 08/18] arm64: Context-switch POR_EL1
Date: Fri, 15 Aug 2025 09:55:02 +0100
Message-ID: <20250815085512.2182322-9-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815085512.2182322-1-kevin.brodsky@arm.com>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EFC9D180005
X-Stat-Signature: kto9crk3xbpwem117iyczss8oiw3owjs
X-Rspam-User: 
X-HE-Tag: 1755248165-749750
X-HE-Meta: U2FsdGVkX1+oZnKGbz0bL6uypPEpjXB7+D7OuEIcIpBOkts6D4pWlrnQYg8eUZHrYwGU8g7Ut0Tap1bXE0Jql0BWXB8k1pZtJDFD+sp2pOebRvnVuN0Ff1RPccRYRX60L0wQ0Ozxz6YXhy966jAgKHm/gG2j5wrYhbCeetZMA2M+hhWp2Qgiz7ca4khJVXv0i2/57vtswjcN2iwaKrCPUYOfwO6Xm7q5/H7qW+A75pVhI/ojlRcxOBVt63clCwLjFBep+iMOg5x2b1vTlCn47oBRC4zBmUyA83ekSqqZOHrJFiRhD4+yohBrbrYEsQwn8t2fY6w887wDWDby8eh74ZG7Qh4RLKsuFZ2X4bmafr/Oc+ol14i949iBQPyfnTjKIO9UPOoO+IOZUDY6bWEmTvXiJ04vgjRvoq/qYHRFMgpMIHU4AcG9JzVAliOCgNqgwwlleht0btXddSIe5C+Z6hqJfvAXBLkf9fIK5LrQdxqOIPwoD1ypeNFvtqWiy8DAQzapZnmnzOv7uQCmg5dnkBKAGZENdwn4pHZYUZJ1WIGHzJlXfB/mJiNNsPBEVQoPziLiUuwK0nk7oMln2aS9xpsv+I1u+QdV1AYsDvmgIypdSpojtqX9jgib+/ICNCATxcwbfCU0xa3pEmL/mimDHaZjpXnOW3k+Ppr0rzDckMbJmV6S5AH+avCXF7tqUwcnAA1sxwa6h1CMqyy4U4vJhWv1YV2qtY+RB5ujiwLNIRJItDFVuVcH2aj2XXtHxw92uwj+Sx06XoRrSK40nPRGk2jsHGkWuNj7TpjudM6QKQwvYt9btygOjxT47Rr6OV3q/NoT3z2f4FaNbR23lbzbmwFjYOhorNxSVajAiBgFkfHCNDxb3ZNoyfc8piVlu7XTxlY894uB0hcyz39fdksCfE17tlVcp1WAPos/+fdjt9XOdOpHc9VqhZPblzAdufpTYFFMulm2e98f9tkFZ85
 uK/0n7dn
 snmR6ArrvmP7JzYXfFarJq2zFpyFPBFbaJQ3ey6IiAPnmMeUhkVMkTS8SQ9Y1RlWT8Hi9UnTnQGR6lJ7lbKbMtdRM3KcPtGEUwDRr6MhrEdiY+XnD4F+JOcvzx12PJ7x+WnuCh+xpNWmVCLVqWYjda8DKv0YAqHOYIZ1NtCccPS1xoh9RVGC3sm01m2g7K9eH39gvaJOJrMACDm8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 61d62bfd5a7b..9340e94a27f6 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -187,6 +187,7 @@ struct thread_struct {
 	u64			svcr;
 	u64			tpidr2_el0;
 	u64			por_el0;
+	u64			por_el1;
 #ifdef CONFIG_ARM64_GCS
 	unsigned int		gcs_el0_mode;
 	unsigned int		gcs_el0_locked;
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 96482a1412c6..f698839f018f 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -428,6 +428,9 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 
 	ptrauth_thread_init_kernel(p);
 
+	if (system_supports_poe())
+		p->thread.por_el1 = read_sysreg_s(SYS_POR_EL1);
+
 	if (likely(!args->fn)) {
 		*childregs = *current_pt_regs();
 		childregs->regs[0] = 0;
@@ -678,6 +681,12 @@ static void permission_overlay_switch(struct task_struct *next)
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
2.47.0


