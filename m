Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B99D1CA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:56:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581EE90021F; Fri, 15 Aug 2025 04:56:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5320E8E0002; Fri, 15 Aug 2025 04:56:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FA2090021F; Fri, 15 Aug 2025 04:56:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2858E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:56:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E14B511709B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:36 +0000 (UTC)
X-FDA: 83778385992.12.1017138
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 57260100006
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cd8SVz56UFDTvkQjpDWLbjdDftI6n7YlnUbxT3vQe+A=;
	b=ixFraiso8AisgkP+0/UoQDvY9kRErdBYnCsUBAo2WKxzIeZACSm4cpoSWqjzWMziX7xiNq
	8bzHOHSDe/H7CiMmOT7vMjLAQbDvedEjnxHAeI5SVQm/HKi1kX4tDeeX2In22ImIFdKsak
	68YTqECdR6f6/C7OAvHRoNTJ7eTxQp0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248195; a=rsa-sha256;
	cv=none;
	b=yW2Yp3zvJSSTwmm5VyEse8l5ZZYpoPI7ngvRd3QPteKPyYCzFRvBpxdpMhp/kkY4wxPgHT
	DpWvNZaUI1mihWxEGtnC68pM6FD4F8+F7bTH/Pz6JDVcHJ2hRwLe2XFkQ3wgcLiBbhaSt7
	+PFQ+Wt4Xr1lxj9zbw21TqMMi4f+K0g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 58492497;
	Fri, 15 Aug 2025 01:56:26 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D5F693F63F;
	Fri, 15 Aug 2025 01:56:29 -0700 (PDT)
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
Subject: [RFC PATCH v5 14/18] arm64: kpkeys: Support KPKEYS_LVL_PGTABLES
Date: Fri, 15 Aug 2025 09:55:08 +0100
Message-ID: <20250815085512.2182322-15-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815085512.2182322-1-kevin.brodsky@arm.com>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 71aim5w7zsmaeh7ipqar7gc4zoidixhc
X-Rspam-User: 
X-Rspamd-Queue-Id: 57260100006
X-Rspamd-Server: rspam01
X-HE-Tag: 1755248195-958701
X-HE-Meta: U2FsdGVkX1+n6w1MuPDxuqOTqq/7PK98/mPyl4kHxuyiROQddfl0CriewcfDZW7/lnEZIeQNFoq6+oMAmMjNrk2ViWNGuOR8XCAiUV1DjqV65W6d5+M6qhu7GtAX8ZwZAFk68Nm/xvzA5FGetB/2pTva+Gpt/jLUEGmFDt8sP8rIpfQ4yZ1gMPXf92BKvE0VUZDNUo/Uoziq5hapNcQh9f/K3c0Wun38dE3PX+zpq44rXa9RrHRy3X5UXElCc6LqHp0C9erISBKIV7zEmv71JRpQ0EuAR6N1ms6yvjR0m7yQB6y4LMu5qUusmCgi5Vm+gLn+V4NpFAo4skN7ck1wGl1dqj6F1f9DKTTkYlTiWnWzOooLcOPrXmTI73PcVKefrJZlItZVDKMCHU54GjRhNF5UYJYxbuRcdtCnuJjNGOATT+3XZ7jmV05iGce5zZs+/PLno3Dlmbhc+1KxMcryNhA0e2cdwViHtr9FOy1msUnIRFVcsJD+52T1+hJV9tScG5OgKVqcshjw8AainorPLg+CNSNqvahSGeTGJnYuMnPwJBd0CY6sx1TeAmUlQNkP3yr5DzFV9We/zm03EZ08tqLJkSQbVAqpLG0QSpOBKXB4KF5XSf619tP91OKBhoFAlFxZQVjZaReL/it8Qasldr1PiDgWComAqt1BlKvtAAL7hdRM7ANVc1zfw/ix+jgqhOGhL05STxRqv+xEtdT7PpMG8ltHvwHzvQLaDq8rs3fUUF1M9j+B4HxOxo2z/0JFk4aPKNsefrJ51oSt7S+OKHWrymLK9x1YxeDQxtdWoVFGzYZH8epI32tUoMLvuIv5B8tgvzVHO89iyVVUJ8ljN1TY59oXDVpx9WcBgWr4p+okYihCFf0JeWNxyTx33GMhjD/2xhT79TMXNRW09vjOpTTvxfKA0zRe8vFTO5o011wMW8esU1WIGMCIi5k3O04MvJZiY7EiGZcwdPUCHMO
 +QVmTQYV
 6aNEbJTY64Vc42yMNdOn9ASM3aT8mbltrgUVQ21C905pMNRgazpUp4uFtuRXNJ8BA/HR2PmNHwew3uUp4xQB+WRAuyAwOykdGMVR+V7M+jwhTz7h0SCS1IS0K4qMaFHNNxfJ11YQTkV1vOr3/1AFQGIqv3Uj93sKy/nmd153VxAJrN4iMPNKFfCTMQ1lYriZHQ30IxFjUEkXRkbc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable RW access to KPKEYS_PKEY_PGTABLES (used to map page table
pages) if switching to KPKEYS_LVL_PGTABLES, otherwise only grant RO
access.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/kpkeys.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
index 79ae33388088..64d6e22740ec 100644
--- a/arch/arm64/include/asm/kpkeys.h
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -12,7 +12,8 @@
  * Equivalent to por_set_kpkeys_level(0, KPKEYS_LVL_DEFAULT), but can also be
  * used in assembly.
  */
-#define POR_EL1_INIT	POR_ELx_PERM_PREP(KPKEYS_PKEY_DEFAULT, POE_RWX)
+#define POR_EL1_INIT	(POR_ELx_PERM_PREP(KPKEYS_PKEY_DEFAULT, POE_RWX) | \
+			 POR_ELx_PERM_PREP(KPKEYS_PKEY_PGTABLES, POE_R))
 
 #ifndef __ASSEMBLY__
 
@@ -26,6 +27,8 @@ static inline bool arch_kpkeys_enabled(void)
 static inline u64 por_set_kpkeys_level(u64 por, int level)
 {
 	por = por_elx_set_pkey_perms(por, KPKEYS_PKEY_DEFAULT, POE_RWX);
+	por = por_elx_set_pkey_perms(por, KPKEYS_PKEY_PGTABLES,
+				     level == KPKEYS_LVL_PGTABLES ? POE_RW : POE_R);
 
 	return por;
 }
-- 
2.47.0


