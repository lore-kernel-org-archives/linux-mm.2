Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66E98CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE3526B0093; Tue, 26 May 2026 07:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C94E26B0095; Tue, 26 May 2026 07:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9F46B0096; Tue, 26 May 2026 07:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB7FC6B0093
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:17:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72F6A1614C3
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:16 +0000 (UTC)
X-FDA: 84809319672.20.F07C85A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 748BB4000C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Fdl2Eoy8;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7X/b4u6kPtvxlsc8SAbdzHGk+xYT247Ol9ilcqiHUcw=;
	b=Apngdzxd+2nEvAFgglgcqcUFkcdMPVQP03mF2AIsKc0rBT9y3aw+48b+Pq/AdtDY6W4ADR
	IdYCZQmShgk3X0J5PBMeOquAgG3dTriSJprLPk6FRScPXDFmYHjESEwIfOBqJdYJCF6hSq
	KpTvFHTYU+x5ybWcPyR008/Rj7mbb8o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794234; a=rsa-sha256;
	cv=none;
	b=cUPGXceW5G4Fe2gMM39UhOx54pQlYwH5tP7ISpW9xLRDdL1Ust9CLrVEiRM9V0rSc2DHfp
	+wWQ72wQZY8HRR3ZG2bFhc6eJ7UBwdgCIFiHb/Cr7to+aw/39mLOTVgk9HdR5hHheLLXf2
	+T+tHvj+KwmIU7jmpbGUBYDP4ogftSk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Fdl2Eoy8;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 24EFF16F2;
	Tue, 26 May 2026 04:17:08 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 57D823F86F;
	Tue, 26 May 2026 04:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794233; bh=FtfnjjJofbi5jV3NeDm06k45kac8Me0VolOHCeDZ/oE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Fdl2Eoy8k1/opWjMUNyR4T9mLnSOb/00vt8zuuvYmw7/HnMpRTL4fos9jehKqWnvv
	 qoAqlupxoj+/LgpxLplSATnbUc7A321zcNGBvJGhGKKfNVqp290bWX6WWJkobdITis
	 0nIN9IYODP64D9UCCWQCSD+ZDUrG1/4+Tf07Bn/M=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:15:52 +0100
Subject: [PATCH RFC v8 03/24] arm64: mm: Enable overlays for all EL1
 indirect permissions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-3-eaaacdacc67c@arm.com>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
In-Reply-To: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
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
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794211; l=1693;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=FtfnjjJofbi5jV3NeDm06k45kac8Me0VolOHCeDZ/oE=;
 b=qiEAw0NX1rX59s1vp2G26mnEMdUSA0T+/ZagKERunC5YmnGlfyESa6qGhCObFq6crvPRt0tZL
 xvWgPX4W5gaDO3mV932PN36adecv/yfBeKMsGsmjpDUGJf5wE2TVoOG
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Queue-Id: 748BB4000C
X-Stat-Signature: gpjifi915qfystpxk4qtdrmz4qusj3ka
X-Rspamd-Server: rspam06
X-HE-Tag: 1779794234-877557
X-HE-Meta: U2FsdGVkX19va7umz2vSrXMhgto73azBLUoYBANjm+QxyNXm10PbuEFvNi4WqakTseVjpQsc/JhH64lPDxdYzFTxwMjG6kMV08Eg+R/4Db8HHmKHA5gY3xwQOzsEuDENyP+n2HhFHF5uWx27ybk4lxt1ScyxbuYf7Gc4NI/QpcLUGZf++HdVt7zZhdnX95+j+vDcM+YfnBMnopSpdmlkScUaxTCk8eLNHypJhLVPigeinZ44eMqNx7ws0AFEREOyWsgtFIJ/g5BUq1QLSADswnoMvIDhFzsjR12SAYpZgmKhz/c7sqSFQoB3bPtMZ9/CMtXFDKrVD+/lHddq+A/k+B10Gte1w9A8zyQfOUzOJbCj0Wl8z1qx0HdZ7kJL+OX1UL2yOoy9WtkpIo87qxbrBavPdQx5FuNAm1DGxV7Y4gFHcnnOugFnchNHPZDM0YdgmZdwmTGei4p7BTbeBVYytaJpP8uSzgJOlHwYHSGNh/UBYr3hJtWYe6SYvS96+98kIGet4ysfLTowlY0TJlkWE/pXKECliNP+CeWwuZUdvyyXny2cW0GJXBWUmWtsZihK8fg3vdU3ZOE6aqIGc462syH/8zWKjZPUoWTFmjtA+oy0NW+7qk6pf4GVbwAOSUcA6FV44GVgqs1HRe8azxnDZpe6vY0Qk3kllV5BpPM1qYEuOdZI5iWUwNTP+NPyS5+o6nMIZiiNf6g6/BXff40tipU7xUurYyki27YvKtj16DyTH/MWBuzmHLL2EHnnakUWKq8oZHCyrIWXrVHcgKF72huIT2PTaKrgr6zV8UAxYdyp9bqsR1mAxeqUnrtZiX6jXPkKUxKZGZ0Rjbzrt/XbTB1ExuAKm+X1YLA43XXOtSLIpM2OThtxD8QFaXu8HX/Jj6BKD1LqnTc+DRA1Q7eHcWF6DWohC/Ov1X5UrHvuL62t1ja++V5OzlcD+q0kkOY9RLKxWfye4aRYPD1hjwn
 A2QSkXJS
 V46EH8KI+Zg0IlGdjynrBs88hwMBP05WqYmBj1j0o705UoqK/S7qa0p/NR93yhkhxRWLbFHxNZ+uW+V+3Tfj+0MPQnPUmlldcn0rj7Ukqx5+7APCgPLxVrH6IU1EiIKEoX3O2MDMMBu0bKMrq70JR5wZGuUzGx26MFJ28WjLu350XaMyRYEsFRzmuc0Vg9UbgjbBPzDRBQHwnrDbf7OgaHb2NjCpfq+g1v+F6WewjchWLg3S0dGYYXOWkeU1FKZKPdwYA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation of using POE inside the kernel, enable "Overlay
applied" for kernel memory types in PIR_EL1. This ensures that the
permissions set in POR_EL1 affect all kernel mappings.

User memory types must be left untouched (overlays not applied)
because any privileged access to user memory (e.g. futex atomic
without FEAT_LSUI) would then be mistakenly checked against POR_EL1.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable-prot.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 212ce1b02e15..d4d45ab86a5a 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -183,9 +183,9 @@ static inline bool __pure lpa2_is_enabled(void)
 	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_SHARED_EXEC),   PIE_RW)     | \
 	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_READONLY),      PIE_R)      | \
 	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_SHARED),        PIE_RW)     | \
-	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_ROX),    PIE_RX)     | \
-	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_EXEC),   PIE_RWX)    | \
-	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_RO),     PIE_R)      | \
-	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL),        PIE_RW))
+	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_ROX),    PIE_RX_O)   | \
+	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_EXEC),   PIE_RWX_O)  | \
+	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_RO),     PIE_R_O)    | \
+	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL),        PIE_RW_O))
 
 #endif /* __ASM_PGTABLE_PROT_H */

-- 
2.51.2


