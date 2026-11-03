Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD252606D836
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 12:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KiXBTPt5
Received: by kanga.kvack.org (Postfix)
	id E408A6B05B3; Tue,  3 Nov 2026 07:35:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF04E6B05B5; Tue,  3 Nov 2026 07:35:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D06C26B05B9; Tue,  3 Nov 2026 07:35:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B07496B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:35:16 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 471C8C03F3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:35:16 +0000 (UTC)
X-FDA: 85393753032.27.CCF13F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A8330140009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:35:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KiXBTPt5;
	spf=pass (imf26.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793709314;
	b=VNrTJW32RNOuuG7YOGobHpA96xW44XCr+x6VV9WxhzkJuV9dPmiYldFeAFepSxSrzNZPBT
	FT1jHEQZJOgmBqC7fA3mUBt3lHk1ubyGSxHym7nEDDzUaF108A/1u+UsXoucqGwKvfLRuA
	ArIK6KHXIFpV3EsU1E7maBzT7Kr8OB0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KiXBTPt5;
	spf=pass (imf26.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793709314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0zLRVusHuFyKUoOOjchq0acuBxOTUBp4h2LAp6Ua7q8=;
	b=1Lwg2Rw4DkFNWg4F6kSA7dQL/LCjJVTxZtKyLMnizeYfs/jd6NcDLpsDZsoKTQeBTGgYre
	BDMRG95e9xQxiItvDsvf6Y2EJj38OmZt527XisLr7m2+xk3S+lVmiLZXoQeMjxBqpQZ+G1
	VqXg9KNdLNCFjDpY3o/Ntw8AOLMYvro=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C40DB6021D;
	Tue,  3 Nov 2026 12:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9533D1F000C1;
	Tue,  3 Nov 2026 12:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793709313;
	bh=0zLRVusHuFyKUoOOjchq0acuBxOTUBp4h2LAp6Ua7q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KiXBTPt5ex20f8NL5JSpBt5DJO4H6Qkh5P6mO7qoW2S0+f1fGw6juKMolBA0Qkrcw
	 0Vwm+vxcaXe41UfPrtoz8NhlpvwhoAlf0JSuC9TWV/VXJ0SHh7viVJIXTuqsdKal8i
	 HHtLqyB1H5jiRbpGyYH25VTlFKu5A3JaV/EVsvy+AOQFYF0JVOF4L4h1Pl6wOyyBXZ
	 4FxMhVKAZmSZrY1mlIIIp3px+w/z5CAokn7Dmf/EoFV3C12IQfPy3gDzg6F2oDtaZ/
	 l5fDl64NlxyT5eu+8jdI29O79aIjYtWzwgPK3toVgu7Z55OHF+TISE9F0eOvIdeeZA
	 OQ1LAITZkGh7g==
From: Sasha Levin <sashal@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kernel test robot <yi1.lai@intel.com>,
	oe-lkp@lists.linux.dev,
	lkp@intel.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Boqun Feng <boqun.feng@gmail.com>,
	Daniel Borkman <daniel@iogearbox.net>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	Guo Ren <guoren@kernel.org>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonas Bonn <jonas@southpole.se>,
	KP Singh <kpsingh@kernel.org>,
	Marc Rutland <mark.rutland@arm.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Rich Felker <dalias@libc.org>,
	Song Liu <song@kernel.org>,
	Stafford Horne <shorne@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Will Deacon <will@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: [linus:master] [atomic] 80047d84ee: WARNING:at_include/linux/instrumented.h:#__split_huge_pmd_locked
Date: Tue,  3 Nov 2026 07:35:08 -0500
Message-ID: <20261103123508.3910990-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261103122647.GL1813469@noisy.programming.kicks-ass.net>
References: <202611022259.def3e086-lkp@intel.com> <20261103122647.GL1813469@noisy.programming.kicks-ass.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x74g1ww675mpji6ud9qg46yc1je4qgyu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A8330140009
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793709314-313920
X-HE-Meta: U2FsdGVkX19wKzeDsHdk26vRkIBc8ZNwa0NYwnDuKMYBsfjNJi4z/0K77BZjwPe6tz+qZikImpEiEXoM+wVnPXgiPp99QJ8qgpC8kxfFiQJOUIOyL+9ELdOuc1oX9+wS7wdGjYXmWL6+KwnWf7HXVxmtwV1r2xUWi7UO+1Sc6unlty77ErrN3ibYiJGxnYFD5b4+/Xw0HBXeuySlPVdJlzgC11CUTDhANDswui0IXudp5hlohNiTc4Ivy+2P6tqi+Dkoaou4wZQzVTYutNiC76LzTpwnlOO0b6ChFPTToVtDhw5LddKe84vaVwwkPYNiD0J/GVKN27cr7QNXpfrqk9yYcueM/qt+H7krplmiSVK1D33nvBMUunaFjkS2wdWNE+k0lpdzdm9VTHJluJohmNVeHCloyY8kcAfOERt9qUKloM0RF2M9cHa8/v+r9RKdNCEwql8jk0GoORTi2u01Qq1sHTOh8JCkPkBPO26fmkOBdiGQIu4QgYDEPciwSx/aV/TZIRwdgNSgzJ/5h/NcdrhdyTc/M68vSCfINOrTzLUDq017J8KTavOHP89WH1/s9d6QR3CoIhhihcMnUctMN7lxHyM9kappTLdIE4wbcrBlrtKobyQEmU/QZxFoZHVtXkgPE2rH4mPfMAActQB0+Zioy/fO/pCOOkBdeHRIYGUdYuR24Tk+l+kOxCoGIapsf3OpEQg7KQzlBbFRTdNwlk9Lnst5K2r7TF+YYtbYt/Mc8U+g/On+UHJ2VSI4e3dHvaJ1jJ5F1GvCkaQibwWR4Q2K/mI2oucV/41ngX6u6K+o1hx1RNJ+u/Ft6++WSMgNzfXXPKgEKe1v1TxEsXJARvdTI3DAe06fqh3BAxdY7txhtyDhY1Ep5BBk/nTg7XlG2zIOC3IxFm4rW6l/DC0og29fMRzJ3oaoLI/IjyQkQEp7dEbJ/si3FMa4e9/1bpIokqDUdmR82GRXRc66epU
 EASdZuad
 6ts4/hZuniR+Z8gIBniQxn2blx3f7onLSuFbXsA7MNj5gYFMlM7ouPfIwBjdjqZPHzlETVF1IDfQYgQWGst6+n3p9B0PmmTN3oySrcuOlDVWDuw9z1qTP+TsPV4XzCbRmGcxkfs/q1hQ4AddiWwlEEw7WpvXt2VHrVfBe1RieVgZN92tfEsELIvQPA8Ej58LG13cLZPv/Nr7CVIpqGUBDY31PGT6a3En3Qn2OeHr0nWsaQW4ylUKD4TqwhVXuskmFeyotF5xhgWDPnUVQXV4ZJ6yjmMtPNImpLzXVS9eUTXOZcl90Jpny6yM21ZuRRObPG8+0lqFohshr4DI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 01:26:47PM +0100, Peter Zijlstra wrote:
> The below 'fixes' it, but the question is of course, WTF are we using an
> on-stack pmd value for set_pmd().

The split fills in the new PTE table before installing it, and uses a
temporary pmd on the stack so pte_offset_map() can find the table:

	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
	pmd_populate(mm, &_pmd, pgtable);
	pte = pte_offset_map(&_pmd, haddr);

__split_huge_zero_page_pmd() does the same thing.

I tried the typedef change. It works, but gcc ends up realigning the
stack in a lot of pte/pmd code (126 more functions with Arnd's version
in a small config, 204 with yours), including handle_mm_fault(). Just
aligning the two locals seems simpler:

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bd44d58e86845..b8faa6df9bb14 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3132,7 +3132,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pgtable_t pgtable;
-	pmd_t _pmd, old_pmd;
+	pmd_t _pmd __aligned(sizeof(pmd_t)), old_pmd;
 	unsigned long addr;
 	pte_t *pte;
 	int i;
@@ -3180,7 +3180,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	struct folio *folio;
 	struct page *page;
 	pgtable_t pgtable;
-	pmd_t old_pmd, _pmd;
+	pmd_t old_pmd, _pmd __aligned(sizeof(pmd_t));
 	bool soft_dirty, uffd_wp = false, young = false, write = false;
 	bool anon_exclusive = false, dirty = false;
 	unsigned long addr;

Tested in qemu, the warning is gone. I can send it properly if this
works for you.

-- 
Thanks,
Sasha

