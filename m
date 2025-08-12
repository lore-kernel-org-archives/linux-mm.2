Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A636ACA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 470418E0136; Tue, 12 Aug 2025 09:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447EA8E00E5; Tue, 12 Aug 2025 09:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 337348E0136; Tue, 12 Aug 2025 09:29:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 231238E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:29:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AFB601A0305
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:29:15 +0000 (UTC)
X-FDA: 83768186670.24.52C67BD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf21.hostedemail.com (Postfix) with ESMTP id 804C01C0003
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:29:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W1Jxq65g;
	spf=pass (imf21.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vtq72QdDzuyXtvGk9IlmoBuW1v+doc629hK/mnAoeUQ=;
	b=rToRm+IqSQHASvipKShdqj5XgKiK0cy8XmPnizAujKKrUVNv66O4xqGxHG/2JWXKQu4qws
	hmGsBVm2AJ9PoCnbzvfK3FJFTtPIk7FYeNM7NPFfbl7GShqk82wLe46fR2FBDUlQLED2vd
	6jC4K0ZwnMtGHKb6uup2Q74POA418qA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005353; a=rsa-sha256;
	cv=none;
	b=BE5vG5A9looyN1EwfqXJU7Px2F4Ljl6VWpRFZsFBU1/ACB6XY+IWOcyQq7dtWe1bDKKBNC
	zH0/zya4SNXEKnYg6J/IZahtIS4BMECX6dSrNuFsdfvawHy+Xg73uUpejudSLykfygHVgG
	ZR/FxIuzNc1xWu53felSNUufBzXS9/E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W1Jxq65g;
	spf=pass (imf21.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755005354; x=1786541354;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UlbhFGz226HIxGPpl32TNHWjf4s+OegZMHU4Z5wVVAQ=;
  b=W1Jxq65gFZuaXsYz54sumoPhCdtFIDm6YDCUPpYIkfZs1+Q/oam2JOy/
   Ezvk4Hu4TXPQaBQalfgPf3VgVr7Jqbim8rfrQyy/jqseJj1osOGjzaQhm
   kVv0JdRPQvBtnJxLt96dbbuYA3iGMDWuBVq8FNQouOW3kj2Lbm+jKLWka
   M+Rdgawi5jXtAe2/6wiHQ1PdbRGRo/NFC0wNMcfT/8l8VUKbRBWF6X3/O
   iYMTKHYObuTZqkW72EouKCg2t2pfMw15U0CmRdNmWE7SUrjEoMCqX7h9l
   LCoqDWbRiTW7LH1B6bx+3FIEz9vrnNs3yyPaWdNBTBBPp9Z1UlPgDloy4
   w==;
X-CSE-ConnectionGUID: aO23PcC3SAKIjysdgOhArQ==
X-CSE-MsgGUID: 0wFeUOtwRlKM3TLIPlpGKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="60903755"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="60903755"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:29:12 -0700
X-CSE-ConnectionGUID: QX9ghsjwQgadzn721t5Dqw==
X-CSE-MsgGUID: JxTTgOkVRwaxXFC7TVl+Qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165831554"
Received: from vpanait-mobl.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:28:48 -0700
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: nathan@kernel.org,
	arnd@arndb.de,
	broonie@kernel.org,
	Liam.Howlett@oracle.com,
	urezki@gmail.com,
	will@kernel.org,
	kaleshsingh@google.com,
	rppt@kernel.org,
	leitao@debian.org,
	coxu@redhat.com,
	surenb@google.com,
	akpm@linux-foundation.org,
	luto@kernel.org,
	jpoimboe@kernel.org,
	changyuanl@google.com,
	hpa@zytor.com,
	dvyukov@google.com,
	kas@kernel.org,
	corbet@lwn.net,
	vincenzo.frascino@arm.com,
	smostafa@google.com,
	nick.desaulniers+lkml@gmail.com,
	morbo@google.com,
	andreyknvl@gmail.com,
	alexander.shishkin@linux.intel.com,
	thiago.bauermann@linaro.org,
	catalin.marinas@arm.com,
	ryabinin.a.a@gmail.com,
	jan.kiszka@siemens.com,
	jbohac@suse.cz,
	dan.j.williams@intel.com,
	joel.granados@kernel.org,
	baohua@kernel.org,
	kevin.brodsky@arm.com,
	nicolas.schier@linux.dev,
	pcc@google.com,
	andriy.shevchenko@linux.intel.com,
	wei.liu@kernel.org,
	bp@alien8.de,
	ada.coupriediaz@arm.com,
	xin@zytor.com,
	pankaj.gupta@amd.com,
	vbabka@suse.cz,
	glider@google.com,
	jgross@suse.com,
	kees@kernel.org,
	jhubbard@nvidia.com,
	joey.gouly@arm.com,
	ardb@kernel.org,
	thuth@redhat.com,
	pasha.tatashin@soleen.com,
	kristina.martsenko@arm.com,
	bigeasy@linutronix.de,
	maciej.wieczor-retman@intel.com,
	lorenzo.stoakes@oracle.com,
	jason.andryuk@amd.com,
	david@redhat.com,
	graf@amazon.com,
	wangkefeng.wang@huawei.com,
	ziy@nvidia.com,
	mark.rutland@arm.com,
	dave.hansen@linux.intel.com,
	samuel.holland@sifive.com,
	kbingham@kernel.org,
	trintaeoitogc@gmail.com,
	scott@os.amperecomputing.com,
	justinstitt@google.com,
	kuan-ying.lee@canonical.com,
	maz@kernel.org,
	tglx@linutronix.de,
	samitolvanen@google.com,
	mhocko@suse.com,
	nunodasneves@linux.microsoft.com,
	brgerst@gmail.com,
	willy@infradead.org,
	ubizjak@gmail.com,
	peterz@infradead.org,
	mingo@redhat.com,
	sohil.mehta@intel.com
Cc: linux-mm@kvack.org,
	linux-kbuild@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	llvm@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 11/18] x86: LAM initialization
Date: Tue, 12 Aug 2025 15:23:47 +0200
Message-ID: <94461b3ac97f13073c8db552f90952aa7edf503a.1755004923.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 804C01C0003
X-Stat-Signature: fzw5kxnmrkt4b5w9gf5wzms5fnwwcp9n
X-Rspam-User: 
X-HE-Tag: 1755005353-95444
X-HE-Meta: U2FsdGVkX1/OHjxXEowH0M9Upv1b1pSKtcrpaoqjOz7rEat/8mbjq+m5xP+pMK1k+fnm8La36FIBLqo/DKTYsfDuXu3oRJnTmlc7AJ7yZeSCs0E2dkxGL7sIY6ebAQrMK+WbanEDDJgYoRjTmBaPq9D5zvIs9rvnLgLCSoXPjwInnC8ZSo0a7G6HhsIfTwBFZNL8wMVHPaBUpJCuEzb7aZvgj18/T82MWw0FNvkvQn73Etp6ARibwZQX3YfJDuVW+nUHkqQMALOctHYzcGBPc7QLqvGdl7jycx/awl1HnWVIpKZ43TMc0C8niEEZhLe704fta62x+Dg3U3nC9ZHyuJ+iK8yAtut/QPH3yz1OzEox+6NGeVMl7ftHkgov5s4oJwOmOeoVqwWJynIg2wt1w0LiiWR+VHLgKBXNm26My+yhA/CtKEqfyWbycd7MM1lGSyAZQLvnbGtbmQ1N5Ep5y9axfUPlX0PW1pTo259jHPQ5ejhW5x5nE6yY7OyntksQktJXNW6/V1HssSDGljDmsXzzkr2cnTLaaWgh6e2c1VEwAxTB33XR8d5uiQm5/Sjs6wSB2ko2g2/spy/VgxNbQ2PmaIqreoVS3bTdaFiksBM/A9HSEmM+i6501Yk0hsSuRRB/oaxm8Xu8fxAA+erV32/5pRgclNhjK2aRPoQZGb4KCj/a/ZflLi6a5StN/0rgcNoarLC1hNK1s9rg36H6Liic0rzqcfY+qMViN6ikUf4xQvWKiM+ZZOOIFovTpD3IZeUEWZF63ByGuEsECN4qy4Ji5VTaBEFJ+Lvj+ukQjQU7eM2CjK5o8LWYZCy+oJmZu8FAR4VybmcTo13bkiSC6AT/RH3Kq8kwUg54h0gekEvFOcFuHR2MTzX9okrlc99rAu3KkaPRAhOMuD2lbEQf3zk1pA4CdHAhrg6RzX6mCy9uBUT2BIh8F542mdQJBqU8P4cL7hN9MvHrO2DX4Ao
 ocnAB8jA
 Lac9EsLoqyUCm8ueEjJWTKikaoxc5T4/qwkZETvZBdPN0gIISBqzxBS9cNBio0FIYvbnemHJkAfGsxY1HR729+AH8yMsvbd+2WABiarL7pdqKVxaY3sdvrEXW2ds7AlgjKTgH7CEJlYJvOZNn1t1UxgaeDE8yZ3N+V6jbQSt1rcg+1i+pxzncIcL4+3Df6U+oyUIhBy8kZeASZ/HRvS/mbjPljxUiOYs55DiHn/s0A3du28/FUfIHadWSivWda1ph6Td1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To make use of KASAN's tag based mode on x86, Linear Address Masking
(LAM) needs to be enabled. To do that the 28th bit in CR4 has to be set.

Set the bit in early memory initialization.

When launching secondary CPUs the LAM bit gets lost. To avoid this add
it in a mask in head_64.S. The bitmask permits some bits of CR4 to pass
from the primary CPU to the secondary CPUs without being cleared.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
 arch/x86/kernel/head_64.S | 3 +++
 arch/x86/mm/init.c        | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 3e9b3a3bd039..18ca77daa481 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -209,6 +209,9 @@ SYM_INNER_LABEL(common_startup_64, SYM_L_LOCAL)
 	 *  there will be no global TLB entries after the execution."
 	 */
 	movl	$(X86_CR4_PAE | X86_CR4_LA57), %edx
+#ifdef CONFIG_ADDRESS_MASKING
+	orl	$X86_CR4_LAM_SUP, %edx
+#endif
 #ifdef CONFIG_X86_MCE
 	/*
 	 * Preserve CR4.MCE if the kernel will enable #MC support.
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index bb57e93b4caf..756bd96c3b8b 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -763,6 +763,9 @@ void __init init_mem_mapping(void)
 	probe_page_size_mask();
 	setup_pcid();
 
+	if (boot_cpu_has(X86_FEATURE_LAM) && IS_ENABLED(CONFIG_KASAN_SW_TAGS))
+		cr4_set_bits_and_update_boot(X86_CR4_LAM_SUP);
+
 #ifdef CONFIG_X86_64
 	end = max_pfn << PAGE_SHIFT;
 #else
-- 
2.50.1


