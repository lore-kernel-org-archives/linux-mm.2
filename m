Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13AD3CD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 800F86B00BB; Tue,  5 May 2026 12:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78AE86B00BC; Tue,  5 May 2026 12:07:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6535F6B00BD; Tue,  5 May 2026 12:07:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DFE56B00BB
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:07:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB8221204D9
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:38 +0000 (UTC)
X-FDA: 84733846596.04.DD7BB49
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1012918000B
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="QBjPJi1/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997257; a=rsa-sha256;
	cv=none;
	b=Jz5EM0M0NUWlvcmHQ1j6cj31w9hCDlg0QZqr87Y6N7dnGyeGLzMG0efc8uchrHS4LFerSM
	dVb67HYP27HCc63eI/fooQjhhMD2eJ7GTG/hpaAnRo26MxT3VWYgHBVf/k2gSZsVkaeFwC
	s5cFh1T/ymQjf2BI0D70bepdxmP3RYY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="QBjPJi1/";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+eFixALF8IfZDLn5dYxAZaBxp0Au+o7lxcNtP4hjAyA=;
	b=fv/tiXsekIqJcWQdq08PBNPPr4vajMpS10VIFiWA0aHRBMsyvtkeoXle5aFbHTiMA98Uu8
	gZZ0PEzmmfbGUa2FMw56ShP/XJ1k/JN/wTArkQ6XUngTBSIzMgVKC2ZMXqoEapEozra6Jy
	IuwfLQKwIqzKfz+D6lVGENGJXrHGISI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3F7F2681;
	Tue,  5 May 2026 09:07:30 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 095793F763;
	Tue,  5 May 2026 09:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997256; bh=vsdMinjHcw7GB4qy8/zKnMf5FynOii1ipwLVdyRi5mc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=QBjPJi1/0E6z+g6gZwqAfQI1WFbSt7qKOfeB6GB7Sy4KN1Vsg5eydjZPUYNhQIRfb
	 Wj8+LjWxcg0xWmlygab+4pg/br0GqkucMOpztsOW2iTVEzcGFCHmWIKduD4W502UdX
	 QTfoui8eRm+3OK7vvJ7Xuk40egUaUpB0IAOdjR4s=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:05:56 +0100
Subject: [PATCH RFC v7 07/24] arm64: Context-switch POR_EL1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-7-20c0bdd97197@arm.com>
References: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
In-Reply-To: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=1853;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=vsdMinjHcw7GB4qy8/zKnMf5FynOii1ipwLVdyRi5mc=;
 b=YBDAiLc0c0CP2NKo/JSszSKF7du2V36TkWN1C4UOrXRjhGYQiUyPZQC71YJJSGHiWLLjGV37Q
 OI7SIwdrXcUDMdx+2/bPXExdgKENQYI1XV3lJ8zGfvLKCiGBmcFMvsq
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: yeng8x337hd1s9ngiyptkpzm3ofbsorn
X-Rspam-User: 
X-Rspamd-Queue-Id: 1012918000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1777997256-16360
X-HE-Meta: U2FsdGVkX19/Ogg5vNL+4KGTnn0I7pBwZqCrgsH/FNLkSi1osAfWQ6bkMMqq6MS5l+2WJtuMzbUlOl5K7qOm6TUOzdljcq6UrZrsSc2J1mtp4DsN8bv7DtQzPV18q9OZWH9flNQBHUdlX+asXK6kPHgJiDVx6yth95BbJ2t6qA6xNHu+fiyX5tuQAle2LwxQlFTYew9UNDGLHVE2FumJV0K/XFD6K+pVVlsLOH2VVuUSqnnwjgCon9fgY8pUC2gbiAluijH53RX3EahyYBNApc752FNJ0210bedU8Vy1OMKLGCaFO0d5mT+WM8FlBy4nVNOvW3k20TihkQkelJGwArOTkqr1031bXPUkZm9WTAu/a0v8DB6S+wODTwufz2vJkjCrlgiQHrhWxSeh2rdXgN61ACAWmcHUrjqj51yVTUd0FsaZ+i3YBjMUa/O1f2bdVpNFsj5gf3KNeiSm4ooOtwTEc0SfSmmT1zB3qRyAGpH/Y/ThRW0IFxHFrC3x7+xm1+2WcKs3p1GboV14wxiiNG4qTdj0QyfGQxD9Sclmg7sT7rRcEVno6VglHD9jVqxu1kSdfyS9MSBAZ+YpdlsR0uCK3IyQ83lrrLqL8Rf2LViZ0kgxdxEHjnzuF/MHnRaHINfp73VtnWIUPDLEpV2eikeDW7zJw/EyhEFu9NJKWtIK9Livg/m4mXppQu8LHU1VsriPU4Aq4sRzatrb/iiX0m5nIQybLr48oEHcX9/GvuZK2k30K8M0PJ9gN3YcbeIGtFjw5/H3Jx7QoJ1r4+OAdhwRj6RJ9jBZ/TM0u4Z/YJO+gkNTD8F4bVZYDBYYO0VwDfgvH3GJqI1PxyOmqANsVPAohegUm2G2gmEWhHDm4YIJFDX65nDCxAYzuf8ZUUk1pP9DTUttY/tuvmXq5xN16KYs+1Xgrhezd9K9kt7XDGJCecyfElLsHZM4MtWZTc3KfE5GPLh3vVAJWoBr/bE
 lq0/bXy0
 3MFU+0EHe28RUa/ax1/Piwppn3ZLcDH5N+adkdUsihzFAVNgvBjjWhUO5dGFntwD+Llt2ae+5q5wj1N3z7jdTph6JIbZraXPFjhYyTckNkWTV65CWOP474c751erLf9/3cIq2J1ymIIZ+vw0ZbHesr9SIQC0MXCOf0qVeMGkL1aE9l18KPcr6G1w3HVsd6+dBsPfzuf0TK8EYXYfhFEvq1er6qCXTCpsP2NejOKU/NpWfHF5F072svP5cqyAtvP+DQv/6x95R8G6tm4lrQzLO4xhnvTOHhPnUbCJLb/yl+fzsR/Q=
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
index 033643cd4e5e..3ec387076588 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -466,6 +466,9 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 
 	ptrauth_thread_init_kernel(p);
 
+	if (system_supports_poe())
+		p->thread.por_el1 = read_sysreg_s(SYS_POR_EL1);
+
 	if (likely(!args->fn)) {
 		*childregs = *current_pt_regs();
 		childregs->regs[0] = 0;
@@ -716,6 +719,12 @@ static void permission_overlay_switch(struct task_struct *next)
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


