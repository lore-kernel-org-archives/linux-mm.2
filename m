Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8F20CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:19:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56B736B00C1; Tue, 26 May 2026 07:19:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543316B00C3; Tue, 26 May 2026 07:19:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459DD6B00C4; Tue, 26 May 2026 07:19:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 339E26B00C1
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:19:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA535C1998
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:59 +0000 (UTC)
X-FDA: 84809323998.10.1CA9D93
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 14AD240009
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PxqbdS+p;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J18iXujFK8xYYFlyu0HbKoG2KQuU7cNGKxURAHEC0GA=;
	b=bculb90ABbGW+Q23fxNOCd8VeyNKhEmM7D8ZjPJWVXZF+alHiZ2LZBsBjegu1lIlCR2tcX
	MJ0s1ykcnRxHiLQtKzpeM48BkTkFgeWbXOo57mQwOQv7GOtBwm2HijpkQeDF9czQdv+nLD
	AtttePuAUb3ZBCJKQrIthzJEZvybOpo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PxqbdS+p;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794338; a=rsa-sha256;
	cv=none;
	b=Y6aOfuvWwPmuMCcH3j5j2F5APZaCzO8xGVIIAIuU1tjCCeID0kLjjjJcJ+ItVITdfo5slD
	L6fn2uCE1TjjM/1h+Vq12oOvMaqN8kLlk3JFWR51+4u8Na/lp+SmD/lVzwxgcZZNSJv2GC
	ZTTc3xvWu32r8q8dpPht4OeBEsa57KY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2296F169C;
	Tue, 26 May 2026 04:18:52 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5817B3F7D8;
	Tue, 26 May 2026 04:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794337; bh=XtqotHlvxdKu6c1pkEmCr60+1y0cB/ILuH7HTvPuXjw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=PxqbdS+pd+qvRVofosuD4tlqbJ7HsIW/t2HCH4ya398Dgi87CJg99yt1Aq+nYBx3x
	 tJeSVt6Z+lgZ5rznTTAG01eKmn3j08thN12Dm6pfExf+Cw28K1ncj7kiMuyRh2rlRz
	 Vi/pS7waFfujziQjgHIDFLnl/Gys+XIOsvpJEjyk=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:16:12 +0100
Subject: [PATCH RFC v8 23/24] arm64: kpkeys: Enable
 kpkeys_hardened_pgtables support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-23-eaaacdacc67c@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794212; l=1336;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=XtqotHlvxdKu6c1pkEmCr60+1y0cB/ILuH7HTvPuXjw=;
 b=q0ZKlig0pvkMsU5Rzr4TwUPY7q5CPoZ2WFpVnQeproPcajfAQtMhWY4OrW4f5EEK4yAYTdeAF
 aJZlzPdmgGTBxVIfR8IvUJ7u8XA5UlNnr2EiRJ+77v+PI5otrILrtOO
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: xwatkto1ueghtiwr5x19s1ob8demrwyh
X-Rspamd-Queue-Id: 14AD240009
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779794337-155201
X-HE-Meta: U2FsdGVkX1+mZQQAYpH8pX+lnrGXzD2dZmPFloTZnma2kkb04/IqY/PTqCCAvs+o/a4+X2j8CLJTArT8Lqwi6+YHPKJyb8Yz0m7aQqjDc4QcrvP4nkm9eF0qTgfJdtRdBi0Ob1mMj9mvqDN8n8L96wA9+BtCZxSo5ODrus9znJhHSIMp2nTO/VVwyLQaYXiOzYvvmzB1d0m9g/6SLGpqW2tkbjjmg/EhAbgl41tUEWojr9supyo7aWW+I0D5iOovb8UCewMztfxzSzp/0co3UKKkJegtP72D2oAOOUEi9wpiCI9xRfHz8gyLNkOdJVW/hDdMMGhBP+Jcn4Z3TyIKacR17XNicYRP9CVl7btdSRKr+ns2tEtNd4rISlz6MWVIYRB7/5hC8LYy0dmcUz8tZANe9pmkbSpzDnpvAPZI7fswdy3FHTkQLTy2nSTV1vgoTuqmgX+YMoyYsWOqM3CeKkaUnnYdXji/dJf50IND6ZYgHqlEoInHlgVidOi5WDdAVMDw37kSgZ7NklYkiZ+i6GMUv3yAXuvcPCL4RMZyEsI+pyRgnk2lYXAc7AfVGUr+KOgjJQHM5gnnWG/bGaRbvlOkgZWZG8o2q4XqDBBdYhw+f9St+3itM+LW+I7jZqnCxiUH/fiDssIiB5qswbS+nSE3xHSfoRM553Nu1xLs28s2rAoGffkC0DaoADV1yPoVbDv6kHDsvDo7hcWHoaTYnV0ugSmyownElRE17S35JRsYrdUx99QaTVywzs1QRc3omr9y7c4GJUp+Lsf4itL2oM2v2awWw2oQL3T7giwH8hxJOOgbwLPpq1ccek481+5cWeixYNVmlsm/t/nmsvBmfp2CcRtTOkX4PmV2CtDECRkhzXcruknrtKoyIrA1gv71e/+ohpIRczxp6xPUmnvV3ndpNMjz43fiPlBib8/FBgazftowaq0KK/2bIwdwvOxSKSW7A+or1Ugp6FRqQoB
 UYh00zxk
 udOzICzy6D+ZxHjREb6Zl03bKR4+Ix4f1KDLLIVGCLh/kYv1wSB4RRklToGAyZccwhch2fcN2W9GU/0Tvt+jR4doSLCgwTi6kM12or4n8tvWHVTqaP4oIi0mpFeMqOIA928Tru9jwKLjWedsY71xIXGCtRDSu/vcW92LAq7WrTq7FFpSAiinZJTLM7zAkYwHKyWS85Uka/TGciubtkqGxSqwzRfeREWSt0wS1XDf31OCN4FEhqLX4QaUaikYN3vz7+Lkce1nkQT+Pu4GbbQJu/r5ywEOOr4WCYRztW5siPqQ+zpo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kpkeys_hardened_pgtables feature needs to be initialised as soon
as the buddy allocator becomes available. The canonical place to
handle this is mem_init().

With that done, all the bits are in place and we can advertise
support for kpkeys_hardened_pgtables by selecting
ARCH_HAS_KPKEYS_HARDENED_PGTABLES if ARM64_POE is enabled.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/Kconfig   | 1 +
 arch/arm64/mm/init.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index ab06324a50ae..43d3ab744535 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2146,6 +2146,7 @@ config ARM64_POE
 	select ARCH_USES_HIGH_VMA_FLAGS
 	select ARCH_HAS_PKEYS
 	select ARCH_HAS_KPKEYS
+	select ARCH_HAS_KPKEYS_HARDENED_PGTABLES
 	help
 	  The Permission Overlay Extension is used to implement Memory
 	  Protection Keys. Memory Protection Keys provides a mechanism for
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 97987f850a33..7985045875cf 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -386,6 +386,7 @@ bool page_alloc_available __ro_after_init;
 void __init mem_init(void)
 {
 	page_alloc_available = true;
+	kpkeys_hardened_pgtables_init();
 	swiotlb_update_mem_attributes();
 }
 

-- 
2.51.2


