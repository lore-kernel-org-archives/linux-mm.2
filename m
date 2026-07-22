Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1567DC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0934C6B00D5; Wed, 22 Jul 2026 11:32:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06AA56B00D7; Wed, 22 Jul 2026 11:32:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC3206B00D8; Wed, 22 Jul 2026 11:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C10DA6B00D5
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:32:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85B1FA09DE
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:32:23 +0000 (UTC)
X-FDA: 85016804166.17.142449D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id A334A20008
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:32:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pVLe2oqL;
	spf=pass (imf31.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d2MlnBPpnWxUihvIuMzHATtyH0nJ5mW8K8ZdAZOSpnM=;
	b=7v6dhKwny1Vv5LdjBYIN802x6oPh8sLZPfIvL8aBZ/HBjob502424pTtKh3+5X8W/ySHd0
	ecm7TVUQrzUqlfm3ZF/VTtNSfFpVOJunLQhqIrhPQImgNHh3R1MVNrhKAEvXIsvWLdkyzy
	7TvBudAsSdt4hTl+IvdkPgO7hUKXLME=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pVLe2oqL;
	spf=pass (imf31.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734341;
	b=BBslad8iXttSZT71FBklPx6xdSNCDm8GHHz9b9knXY2VmQ2nDdulGotFZLovV5JlHVfucd
	kAffJvXbZTFkST3+SUobiFhntv61OORq32cswllfiKpqBW2jOTuVJQ5KlugFmBmikn6eUn
	nUDNB6B5Ir7SLzY5oZxonBAv67ocjcQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA06A1691;
	Wed, 22 Jul 2026 08:32:16 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E103D3F66F;
	Wed, 22 Jul 2026 08:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784734340; bh=wsOvhQKZEG00wg1jKdkAFaJFjNazItDwe0xYFjnlbxQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pVLe2oqLj/GMbp2ufH9X7mDJQq2xQl+JLsb4rdHdEG8P4q6+zwtBTz6kqejK9a4vE
	 42w+M5uZ5nMb5hwWCHtS4s7q+ErSCs2KQQJDkfsn5+wpqdIMcK1OZYCZCB3cZAW4nq
	 AggYvPNSBbaQWNfM1T4fRg3yIp8YqGdn0GMHuuGY=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 22 Jul 2026 16:30:22 +0100
Subject: [PATCH RFC v2 14/20] x86: mm: skip pud setup when using generic
 compile-time folded pagetable
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-dummy_ptxp3-v2-14-d9e4bad31e0a@arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
In-Reply-To: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1647; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=wsOvhQKZEG00wg1jKdkAFaJFjNazItDwe0xYFjnlbxQ=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqYOIWIdSyNNx0bAaN04aBwgqBSXTMZTpRKvbWw
 OqEgUkq1DqJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCamDiFgAKCRBt1cPRWsUx
 M81eC/94aLur5BJub0U5CeumeSspcUbgF2bv6HfdAEYOdi5ZwYiF40PGZxxjAsv/yQlK5UzHDss
 aPkHeJPk8MkK0qc7gd9qgXRevhd2r3SbCV54lAhtxc3a8MyMlApf+nVtp6WMlSqBdjVBghBQYVu
 m4undaF9OwHTn2K6K/oaocwtD+K/DrwVWCi+WofWjdNbz59AZtNKXjUsQqR0sgDROPY7hcFFkTu
 7JAqrngJ/Rkxa+ZTG1nr+VR0zoMGs9k12vLpTWZlxxB6mcDEbvHDicaHyuykmke3jENeOsJTl+3
 HDxSBdyN3Dalc3OL8zAIHav1Idp6Xmu9CL9mfOQg2LeRY3RaajCzKL5rATAEhSKLyGuhW5cJDZR
 69AEYlBnca2Wzl++N47dEOUGO/uXt3c71udqBZTA+I2so2zK3Gu6esbNhxoBe0uOYGsizKiyDEp
 LYPnBnpmu5SBzQ7DL3uDq15sZsUy9WU/F2HnuSrSJnVeaf08gu/ZXr0DZAzMMkUt7bZIA=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A334A20008
X-Stat-Signature: 5dxsk3h18pcx7weykka6cjoepdtzxpyh
X-HE-Tag: 1784734341-192999
X-HE-Meta: U2FsdGVkX193+PjnQeoPd5R81kVD/wYVvUWaF0jIi4NDyRRZ1PlHcH983MD/tJfJ3wmi0g735+ptwbAdWAB5Usow0nYZkaZtr86BFCFcGT2B4uk8ooM6vF8Q2NoGNKXGkdClG9CxrhPvGeAanE3w5PyeLQ1sUTs4BA3YGXOY7lEAMn5cIvQRQP1N1M7uajxBbgETX1Lgdn//N4KNPO8NVSNeToHZ5+D8B69LyMOW0uDkBtnzE3PV5m51r3bdhW5T3lWaq/Vyfd/DFMzD89rBKUw98E2Taeh07VTmbCpaTokKROUr+7bClLNyTxxV5kyJ9TFjncx2+zuO/QZ0GRUnKPgOnRQYHWDhXQrpdeZjDmGgrk07QpoiIb55sv+PXldT36vQ/14LV4hz2VqNjk39tQxHoWKleVj+hJmiOQPzwI0g/OnnT9NM0Oss5UiL/PGbY4X8uK+S8lYasGgrwkO+qFa3IqLTk0XVv6trGhbLPhuKsnIiCx669GxN96Oq/mcqTUTRbN9WA4dQ+RB7XrLZ/Z2GXCoyJJaPll/zE2l9hg9AIqn6H5k1iMnuGw8abVF9VOy0CerpGdnodtEXlhO/nI3+NUUjQiqCUexvuILD872RcdnfQGdqntujvBasMxJEmEdFc1TMQjRFdLar1ZLoPZzUOQV3a2XxsEzVNx7UPU1f3LNg+/5pRr8Lj5BtF5nxVCs68CGo/C8xcaPhvRLoWtTdlExR1NkNml3btJQ9HvIRX2+jIh2k4BAbEdzjj++39dSDAIdYiwqtHPjdptpaFL+uKguqDhVVm6lTJSBbW3hq6eB5q5egLbFSoMcNTbPK38dnF3NHBaWtx+ifuWjDdfYilaHl6NBpl8/w+LzlhDr4C5kDsC8qmW90/PlP0QtaAWX3rS4mxXs3kFTkkMV3IuoK3daGeb0BHhfxIyeG6sy/QIg0+Jr1szjXm5BrffVRy8g1axAv7U6X+CKkeFN
 bu6W/d7C
 rSl/nxcWoC2txS0CFu+T8bphWp67sFqnzZ9/nnxqj47QbRJ4r44wWhITE1RH+2cKcV3rt3kbaMTQkC1Rhy20ujgvWDG7+V65eDF0kIo1HoQIKRqJueplnmoTeNkyhiQh9tS6EkqNTIn1W8ehmc8YnNKVVQvEhdlCrVn0F/ju982QLdIPRisGXg6SO0bakBFzq6Iy7PitbMYZWFzB9BFrKDK34Y5B6YRWMiVWYEdE4HXIZZWKpIvg0kMD2hIRryeZqI0e3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to rework how set_pXd() behaves for generic compile-time folded
page tables by disallowing its use and triggering a compile-time error
when it is used improperly, ensuring that the actual first-level set_pXd()
function is used instead.

The behaviour of pXd_page() will change with generic compile-time folded
page tables by disallowing its use and triggering a compile-time error
when it's used improperly, ensuring that the actual.

To prepare fot that, skip collapse_pud_page() and populate_pud() according
to CONFIG_PGTABLE_LEVELS.

There should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/x86/mm/pat/set_memory.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 078689aa7206..91b33a265a43 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1346,7 +1346,7 @@ static int collapse_pud_page(pud_t *pud, unsigned long addr,
 	pmd_t *pmd, first;
 	int i;
 
-	if (!direct_gbpages)
+	if (CONFIG_PGTABLE_LEVELS == 2 || !direct_gbpages)
 		return 0;
 
 	addr &= PUD_MASK;
@@ -1730,7 +1730,8 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, p4d_t *p4d,
 	/*
 	 * Map everything starting from the Gb boundary, possibly with 1G pages
 	 */
-	while (boot_cpu_has(X86_FEATURE_GBPAGES) && end - start >= PUD_SIZE) {
+	while (CONFIG_PGTABLE_LEVELS > 3 && boot_cpu_has(X86_FEATURE_GBPAGES) &&
+	       end - start >= PUD_SIZE) {
 		set_pud(pud, pud_mkhuge(pfn_pud(cpa->pfn,
 				   canon_pgprot(pud_pgprot))));
 

-- 
2.43.0


