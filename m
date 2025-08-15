Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D77CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:55:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A895A900216; Fri, 15 Aug 2025 04:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60568E0002; Fri, 15 Aug 2025 04:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99D6F900216; Fri, 15 Aug 2025 04:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 883B38E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:55:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 609FB1A090D
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:55:48 +0000 (UTC)
X-FDA: 83778383976.07.027EB41
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id A5424C0008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:55:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NBnu1KO525YoNOUTGQZxsVEqYHpv37+j7u/8FOvwZS4=;
	b=ZEvYfnVZCYupJ8lWekLaegtiPOO6/6SgZ50eEZ358e+gwvRoG17w5xzyNOzoWNhlspp/ni
	hchaLqEFBPxkZdjp2OddYP/w0gFygv0/s96jxOYPeWSqyXucQfpWqB+sEfP0cz7VgC3Ml0
	RMdSQ0/3rGfFDP3EKhIqjfwh29OfVQ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248146; a=rsa-sha256;
	cv=none;
	b=NeApiY9Ygl6ZDHnz/E9w3SPVuGk5dc2oteM9v+1znNbaNvP8UN6FeqZaOmHp3iZi/z42tO
	CCnj0IDth2G9d3jpDvtkTD3ScCmgyo2kRl1yvVs7e680AEkiEW4kWyglr/FCVhRMSBTJek
	CwE8Jfr/CERQTKB6Q9Ko+0n8q982Tk8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4FEC1E32;
	Fri, 15 Aug 2025 01:55:37 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4DA8C3F63F;
	Fri, 15 Aug 2025 01:55:41 -0700 (PDT)
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
Subject: [RFC PATCH v5 04/18] arm64: Introduce por_elx_set_pkey_perms() helper
Date: Fri, 15 Aug 2025 09:54:58 +0100
Message-ID: <20250815085512.2182322-5-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815085512.2182322-1-kevin.brodsky@arm.com>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A5424C0008
X-Stat-Signature: a53zgdnreoaw6j7rhjnwf6qa4oniey1t
X-Rspam-User: 
X-HE-Tag: 1755248146-580964
X-HE-Meta: U2FsdGVkX1/tyCIAQmidvcBMdlS7XBHfXpOQKyUEg58x2VVZOV4ol38g87RQvMLDyvvUNg1bRXG5J7W23Efsbpp4fzYapvf2mi8y7rbr+NElsFGxbw7/GYuLWZN4RR2WT3ci2Vu1XnExUis06FO6TKYmihlYG7vWmWT/PqCj9egT8PaK7wy/QScYvuKe/55NmHqn2H871A4vlkjpHQVSvWVxfl9ccn2kYHXDJtC3Molnzx5Ps24eW6rfTCBoO6XSMWvp+oaI9tHHP0UPOAQXp71wwhiq/QWfzfYJ2/O2Gp0e6cMaMLmyryixk0r3TqwByEqERMf11Ej68efe7aXzR7i+mHW51NIMD2HfIgDe+YvP8pG7HrDnfGhw3OJ2OkRSpON+936L6dGeF4KsoeGZ/PjwWdTRhhB8sMxAo1OvYGK76/sbZIC7OHI5ShFO56KOC110rYtoXRw2e9X61XtWFbCCOY1xxzYk59p+4DsY3imgmCFeGKiDq56R0pd4D1gQzkCiTswC6riyZ/tHhoJKNWek0KeUdf6gUTxWo5DZ058ahXPaKBGooASju6Q1ftma7joPwoEHHGq7FpXwvR+rfufZM2/tjRiijGCLkkiw3p95l0iUEs9rMcAi4lH/MJeO1N5pzA1IROBZy2ekFj5iL7zAnsgeg0Cqd3aGgAZr6IIGnQO7IsYtVB6Bhb7uijVyHVI/TwbiOOr3WCouvEr65eaGM5756cFyRmKNRTg9P4CcsE/ZQEB0piekcBj8BAAVJp2JGWy/U+7VXhzfkyNv2lgJMr0bBO9VgzSArjIK/NywO/eDBXzKRU1elMibramsHX/3WhiCIW6IclnIkghjCofzX2Qfa/aNBLy5XLG2zvcDr5JnhLsF+yDofG6hNT5tbpoMCwS1p9VtShjc4+elxyGjEyifPzHbSFv9Z3NQGQgSj6OUilTI4NHQPCsIUQSl61qJAYnuRBl3RvhA+Jw
 5wsqlN6I
 pNgl0OSKRgaHgDAO7Fi3NORc7yfrXshGyZeQzUHK6UTUxTG1cn/DMSb3rooHBFDemMbFT+qo3OPAvIIUYOZdvXl6d+5rJChvKgVKe2e+mnOkvkAskfz7FlU1IrQzvnrHRcobwO6MsXp8k59/uyNGpHswP5BJNvVJIYbyZyWc/bNifGETrPM00DuT2LGzQOdcjOuTBZCq+fIh+GIM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a helper that sets the permissions of a given pkey
(POIndex) in the POR_ELx format, and make use of it in
arch_set_user_pkey_access().

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/por.h |  7 +++++++
 arch/arm64/mm/mmu.c          | 26 ++++++++++----------------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/por.h b/arch/arm64/include/asm/por.h
index d913d5b529e4..bffb4d2b1246 100644
--- a/arch/arm64/include/asm/por.h
+++ b/arch/arm64/include/asm/por.h
@@ -31,4 +31,11 @@ static inline bool por_elx_allows_exec(u64 por, u8 pkey)
 	return perm & POE_X;
 }
 
+static inline u64 por_elx_set_pkey_perms(u64 por, u8 pkey, u64 perms)
+{
+	u64 shift = POR_ELx_PERM_SHIFT(pkey);
+
+	return (por & ~(POE_MASK << shift)) | (perms << shift);
+}
+
 #endif /* _ASM_ARM64_POR_H */
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 34e5d78af076..e41ed9e0d799 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1597,8 +1597,8 @@ void __cpu_replace_ttbr1(pgd_t *pgdp, bool cnp)
 #ifdef CONFIG_ARCH_HAS_PKEYS
 int arch_set_user_pkey_access(struct task_struct *tsk, int pkey, unsigned long init_val)
 {
-	u64 new_por;
-	u64 old_por;
+	u64 new_perms;
+	u64 por;
 
 	if (!system_supports_poe())
 		return -ENOSPC;
@@ -1612,25 +1612,19 @@ int arch_set_user_pkey_access(struct task_struct *tsk, int pkey, unsigned long i
 		return -EINVAL;
 
 	/* Set the bits we need in POR:  */
-	new_por = POE_RWX;
+	new_perms = POE_RWX;
 	if (init_val & PKEY_DISABLE_WRITE)
-		new_por &= ~POE_W;
+		new_perms &= ~POE_W;
 	if (init_val & PKEY_DISABLE_ACCESS)
-		new_por &= ~POE_RW;
+		new_perms &= ~POE_RW;
 	if (init_val & PKEY_DISABLE_READ)
-		new_por &= ~POE_R;
+		new_perms &= ~POE_R;
 	if (init_val & PKEY_DISABLE_EXECUTE)
-		new_por &= ~POE_X;
+		new_perms &= ~POE_X;
 
-	/* Shift the bits in to the correct place in POR for pkey: */
-	new_por = POR_ELx_PERM_PREP(pkey, new_por);
-
-	/* Get old POR and mask off any old bits in place: */
-	old_por = read_sysreg_s(SYS_POR_EL0);
-	old_por &= ~(POE_MASK << POR_ELx_PERM_SHIFT(pkey));
-
-	/* Write old part along with new part: */
-	write_sysreg_s(old_por | new_por, SYS_POR_EL0);
+	por = read_sysreg_s(SYS_POR_EL0);
+	por = por_elx_set_pkey_perms(por, pkey, new_perms);
+	write_sysreg_s(por, SYS_POR_EL0);
 
 	return 0;
 }
-- 
2.47.0


