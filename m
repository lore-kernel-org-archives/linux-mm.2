Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A73F96083616
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=UM9ZY938
Received: by kanga.kvack.org (Postfix)
	id 66A0A6B05BE; Mon,  9 Nov 2026 11:01:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F37C6B05BF; Mon,  9 Nov 2026 11:01:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E1E56B05C0; Mon,  9 Nov 2026 11:01:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 162856B05BE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:01:20 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5331CC0724
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:19 +0000 (UTC)
X-FDA: 85416045078.20.C09DD13
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7718020006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UM9ZY938;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n+IvwUbalMB+lMEj2xh+/SJ+ZMqnlHDeMyWsUhxMutY=;
	b=KpMvzQMVSRRZqrcppGomxhD4QPEBicA6wARUyCyllVGh0QB6Hvk9RdWaiS6M4nKjhYZbEQ
	5WkHl9YXhDnm+JD7rKp+hhYqc7hSAAidWbsVFB7wnU77bXWeT6bVnkNSgibgyfqsPJ4o6K
	rygT7NtQIvA74BuuolhvzDfZBi234Fc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240077;
	b=3gRH0h0kLLoE8L62CD6POanoIAOiBYOQ3XgKlUFRbFCvwS2HP27cxS9YSi+bRAzpI9eJb7
	KHE8sxIOquDxNYf+OTgePwedArSubIdx6H27xz0s7krpc1KUiW00N0hCWTXBoihGXLsTea
	agnRpUE4FI8orKMuOcKH071S2hQbfuI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UM9ZY938;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 954E21516;
	Mon,  9 Nov 2026 08:01:13 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BADC63F632;
	Mon,  9 Nov 2026 08:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240076; bh=69XjZGmtQpsQiw/RLc3kshkLffGbawQIbdoKaGDZULE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=UM9ZY938suJnPaezt9DwztK24sCh6xVc8bxvjH925gRZ5QpwvdBF5JlzN9zILAnWt
	 75X067qjHkhks/llchFRr+0huGUhyju5W3N9EkRLbyXWCUzLymQZBQpxz+W3aVedGN
	 F9h9DhG1c3UN4l5xtCx4daM2U7r1KlKGW3NJWVdY=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:33 +0000
Subject: [PATCH RFC v10 08/22] arm64: Context-switch POR_EL1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-8-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
In-Reply-To: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=2136;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=69XjZGmtQpsQiw/RLc3kshkLffGbawQIbdoKaGDZULE=;
 b=5odrr2x68jCwQ+LojjKcXp9Zj53vS8pkd5Cr3SnsGrCwJYb2HeRqZVwI5XXSiJQI8HwY8d7kY
 BjKw/bkeILzDFc0crCchfxBG8yFGXa1Y5sKvtR8hH9jveFSPJe6gfkG
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7718020006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: sbte9bq83jp3pabpac49hbfr6mi3sczc
X-Rspam-User: 
X-HE-Tag: 1794240077-599279
X-HE-Meta: U2FsdGVkX1+BJM8vBnX1WxWpkPub55PkAZbDcPz7pupZlW/kuh6tOorM5SvhOy5Qj75P5VW5YM11oNo1aJRoXY1MywYVHP1ZxVnnR7/8tzpDv2rYhVZX+PVEYuu62hjqmlZ3ZmrtlLxZDqLBBCz8ZTjMLtOBauVfW6yPwpNF0yYwyLaIsRvgpfG1dTIVr6kqSwZgwI0BKUQd7tx66TVnEzjb/dbIS6Y26LO4Dn5XStluZCH5faR9kyiD4k1//xN7CM8+ojGv6lOLVlWeiEKSvWIZFHoTMoD0uJtPeGd6ctH0A5EDm+3vei9L4EbvlwKkV3CTpxma/ufnimerxZuIPFyyoM2kaoz8LUg89sQcTK7bxIcp6NPDrpOyIH2fKdhrzbKp54QZ6OPhcgnncjLGZLnfY4N/Iu1+iHL4jk7jyFNVd31yCjCSS5yNjTMt+QJ0yiv6/GXPCCPd16QuOGFw6fnjKBW3WVQXIa2NaFatUI4z9aTSVR2vxXcrNOGciS3aq0faPaS32HabsYWcGEkELbnoZh2BS910u3gidq3uSz+qLuWjEO1StGygaL6zgB0dkQ1wG0bSlqlydiyt2vIuw3p1Te37dpSFWALEggb82TcSXbfY0fEmeA8vF7lvlhZKL4wykTTgmWqbhXKtjnWpcDtlJUwIWHOnbzW+0an90qlBKytYfNVih0xbo0KY7dSXldXXAsgO4+f6WjBOKNZFlgkhBwUHDZEt7kexuIIGcRh77IGGbOX7Fx2tC5BiBi43TAJxtJlyWGCxtZbXo0sfRejeWiBoyerJA2c0WDBq3BpqwmIEiccvA9DDqlzjOU2PZbuV5AKU2Kre4g/Sl8egSws1ELcPRZ9E82NjRibpHM/KQbN0+JaRrDKrFRt/n0wXw25tq3eoyVgepn1rA4LMvW5alGpsm2pR4wX8v67+EKgbV+YgTfTFjCB2uMp5lEdLxGfNHvQR4SeKWPkTZqP
 X4Fytvgo
 lzr7P+tvo87jCqcVccgqoXiPR9HhsgaPZsYaC4932X4WeJucCWU7QFI8IWhuo9WGotNAraW4yN3zomMwGKkA4bwa4AGuCI632Ffv2QggG3zAnBQFLI9s34mBOEXQofBrdSHFbilbz/vcfng009L+H1lbT3SzekzrI+MKZweE2v0/pvnErquaKupLogDkC2D4RIevsgmux0Hx9hWyMm3CG1omxxdnKctX6/5aHTGbzdEQVTh0GFg/vIEtDiP8G1nDCAEtx6b4gfm+GobLQRn5ajN4ku/yTa24RMnqDrj/IHEnoQ7mvkvzYibPbCt1HkmmjXSDpjf8h9n/0MkzdPEokbzA1wTOX1uTiaNpS1dAtZHh366zLjGKEvUBUWbcM/ZsDupynJxYZxpOVcSJBUqbRdVjjwApYuVdU8eu5b2/7ku85c0zAqpuSqGyTNsEBwBx3HVBj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

POR_EL1 is about to be used by the kpkeys framework, modifying it
for (typically small) sections of code. If an exception occurs
during that window and scheduling occurs, we must ensure that
POR_EL1 is context-switched as needed (saving the old value and
restoring the new one). An ISB is needed to ensure the write takes
effect, so we skip it if the new value is the same as the old, like
for POR_EL0.

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Linu Cherian <linu.cherian@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/processor.h |  1 +
 arch/arm64/kernel/process.c        | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 481f1999f7c1..18424d91d8b2 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -195,6 +195,7 @@ struct thread_struct {
 	u64			svcr;
 	u64			tpidr2_el0;
 	u64			por_el0;
+	u64			por_el1;
 #ifdef CONFIG_ARM64_GCS
 	unsigned int		gcs_el0_mode;
 	unsigned int		gcs_el0_locked;
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 42b15b0c069f..a3984aedfebe 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -51,6 +51,7 @@
 #include <asm/exec.h>
 #include <asm/fpsimd.h>
 #include <asm/gcs.h>
+#include <asm/kpkeys.h>
 #include <asm/mmu_context.h>
 #include <asm/mpam.h>
 #include <asm/mte.h>
@@ -446,6 +447,9 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 
 	ptrauth_thread_init_kernel(p);
 
+	if (system_supports_poe())
+		p->thread.por_el1 = POR_EL1_INIT;
+
 	if (likely(!args->fn)) {
 		*childregs = *current_pt_regs();
 		childregs->regs[0] = 0;
@@ -698,6 +702,12 @@ static void permission_overlay_switch(struct task_struct *next)
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
2.56.0


