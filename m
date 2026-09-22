Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D064EC98307
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:33:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971186B00AA; Tue, 22 Sep 2026 13:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 921496B00AB; Tue, 22 Sep 2026 13:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837276B00AC; Tue, 22 Sep 2026 13:33:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54C566B00AA
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:33:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CF0DD8059A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:33:07 +0000 (UTC)
X-FDA: 85242094014.29.D90DFE6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2C31780009
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:33:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SgM0Qx+n;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790098386;
	b=r0QqI8MjLmHwxNzOp9usXcR93WyeOneAPemHfN0/hNYk7YcMk6EQwBUAiGy9JCdksQJlfu
	3D8zlpvK0R3zw7z/vIPRS2h9e1CcwSRLXwgG1KsMVi4u/sARyrvdlXqLkNj7ozjR48tvfm
	nm9KFtQ+DwDKtFIZIaLzSOXyB5hGaDs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SgM0Qx+n;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790098386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6uBN0ZQwvtsGp1jKgpj+hxjeJ464MZfPKqor1IPMdG4=;
	b=IIiLV92Mq2rf3NF1ws2vUiI3qXttfynP4jZ35UKWfuWKKl2WLV6HxZpIh+Td5Ye9sKjNCt
	xS4xGRKC8tLrjLV11nEV4GBhVmyU1dZU0OPytg3IxqmAKeCTlBopgZkpcJTY5PnOjXewM8
	X/jFaS7Zxz1crrzT45y50WvoanlLi2U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4C601595;
	Tue, 22 Sep 2026 10:33:01 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD49E3F86C;
	Tue, 22 Sep 2026 10:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790098385; bh=shLHKCHn3ZdXre7hsjCS5Jwr6cqRreukZfraeH8Cy3s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=SgM0Qx+n9SIyEwK6aMAq6Ppwz1dhcVVmU+Lr/ToZEX+hmzKievt4rrjFlrNonyWHj
	 Kx0OuVjhvw7BEYioGKvMfa7FL7lAcKc8dmLMmbyM40JqkH/qOYzITwD4t/d5FVCOgL
	 ym3nNFw6xAU08NSMAjwa2v6IMkLgy4NQLbeBKLcY=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Tue, 22 Sep 2026 18:31:59 +0100
Subject: [PATCH v2 4/6] arm64: use hw_pte_t for fixmap HW PTEs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-pte0_arm-v2-4-a3f1ddff0a8a@arm.com>
References: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
In-Reply-To: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam06
X-Stat-Signature: g83nekzxnpnx6a8kpc1cx9s5w973s9q3
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C31780009
X-HE-Tag: 1790098385-498636
X-HE-Meta: U2FsdGVkX1/h3gJzrXmtOOLvIdauL4mmfvAx5li9NJBtVF4PJDLXwNjZJqOFTvSS4QEY5jaiNcvcASDLoX8erXVU7I0thBh/6bqOEHJmgQMb8mDTN+X7bPB1PU3mrvH4eEjAGQe3h+Hx1ogndqahKYq8Cbgx8lmiZx89lLIqnnyDovIM27NoTHKVn2z6nT5esJvmZF4+5YoxOY7jLaO6FwmL+39MNx+fgNJKhrIrhPpIz+M6AFB7B//MBMMjv8kxOGN1bqFP5i9zimSKlg/jDHPKRBU7XJgObOW0FqhSHlOPlYBgCUcOvHLTfbGee1r5PWg0hzJurljFgfH+5cwZE0Ew7DngUr2S5jLeMjRQDEtGog+dIpV9uoxREsFNrAg6IkfNHGGZmdgPCOowVrw+C12bRK5CqxVf62XdTtZkPqk/2y9C9e4v65sNQ4CUUR+BYgnZ2HAs7xrZbJfZabyfVDRaEpIN0pAihpkyiDlXN8NBUzeGMnkF7zghEFaKJi0yqy8PrCgA/tyVMGJvAFRCQFPx0fhLBp0ODdgnP1KF7t/DfSoBrYrAeHYsEEA20WVO4npTEs298aYVAXQ5xuZJmA1kiRILT2yuEpaIya9XkZVtCPfjxzvStMLWgPjA+Y6hQZ4k8JGAuSEPmOndaANJi6I8vHHNITmUmZa01tHeghjDnCeb9N0wRlKqTIwU3kMvxzCYxob9VUHfCODdq+RsU4pTUUxWYy5Ic0KhzpfCGTdjqUcVwZ/Yxms8VgkC8LCi8tG5m9MTH8yMMksyC7EVJrXLw9VG9bdWJl8yu+Lw8WdVdgqwKxbTBvpYQFB9h1BMMcIfymmuERZGys7zmvo54Tzts++rvWLNoAjzzqSMks8hquFRi+GZSczwombDxT0vpiHtJ2jc1mjOToRo95p+V0NubyZ7LisuC0S1gn+mSV8xFTrbDm2/KXgX4VkpHEb7DQL3vVgTqS2PwWmvLEQ
 upK8pVOH
 7p5/IX+sxu5SPfhHBN0O7d8stbJUS5cwKW5IEBi8/iWV98bNFVWTY0q7IjksW6aCE+n7zqAlawkgDq4DoNl907WqXbiK/WMy0Jad6vTBoi0lgF+nMBDn179pNewaRsj3mhrWpEu+nM4B8bfM8EYwOGg6VJGE3kVV7tfEksW06C9b6hzigJtEluetv/T+RwJP+t28nkKQI+fTxXQ+l1hwNTbBNv42jz9Boe2+7qC46WES0IsqAbiX2t4OOVktT2OqZ/MVATteGDun6hF/4QTESlA18MVrVtEB2vgAstjRbzR5+ZOyS2Mc5+XK4MlTG9c9IkBVDcZGyihdC8sxcgnrb3LITFLFXqJB1OdTWtQeoLfL+eo3oIzcPwpvJWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

fixmap_pte() returns a pointer into bm_pte, and early_fixmap_init_pte()
installs those arrays as page tables. Their elements are therefore
HW PTEs.

Change the element type of bm_pte to hw_pte_t so it matches the HW PTE
pointers returned and passed to the accessors. This is needed before
ARCH_HAS_HW_PTE_T makes HW PTEs and SW PTE values distinct types; the
array dimensions and placement are unchanged.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 arch/arm64/mm/fixmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
index 237a9136bc73b..709a97fe327d8 100644
--- a/arch/arm64/mm/fixmap.c
+++ b/arch/arm64/mm/fixmap.c
@@ -31,7 +31,7 @@ static_assert(NR_BM_PMD_TABLES == 1);
 
 #define BM_PTE_TABLE_IDX(addr)	__BM_TABLE_IDX(addr, PMD_SHIFT)
 
-static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
+static hw_pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
 static pmd_t bm_pmd[PTRS_PER_PMD] __bss_pgtbl __maybe_unused;
 static pud_t bm_pud[PTRS_PER_PUD] __bss_pgtbl __maybe_unused;
 

-- 
2.47.3


