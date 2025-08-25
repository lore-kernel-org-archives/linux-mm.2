Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A08E1C8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 20:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E43A78E0077; Mon, 25 Aug 2025 16:29:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF3338E0038; Mon, 25 Aug 2025 16:29:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C97E68E0077; Mon, 25 Aug 2025 16:29:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B0BD18E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:29:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 70F80160534
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:29:26 +0000 (UTC)
X-FDA: 83816419932.04.DD4FA2F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf25.hostedemail.com (Postfix) with ESMTP id 470AEA0007
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:29:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dMNcrVXW;
	spf=pass (imf25.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756153764; a=rsa-sha256;
	cv=none;
	b=R9OE4DGk1EA0G/WmEecQi2lfxwbI4dPBf4rsryN5d7d3QedjAM/y1vPhhrvNzjH023QBuO
	2DmPO/O0CJp45x0sCFNz3Z5RtdjBomHkcwhX89AQFJqwuSrMm5wcRIWUxS8kFzDOsjWrnq
	I5T3tsdwcegpNka7WOLv7vkwm0p7vs0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dMNcrVXW;
	spf=pass (imf25.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756153764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vtq72QdDzuyXtvGk9IlmoBuW1v+doc629hK/mnAoeUQ=;
	b=tfkF+m1PDLzVwRUk+88BqDA5qdiGAdt+M5VAQjqCu2FV2x6i6lXndp4LPj2qXgC5MItUSr
	b2KwPGMjasVqvtX74Td971xlSS+57pMdXrY10NfJxT22+OyI7P3znxjlYxIr0s8fjWG74b
	XNKliHq9AaD897/f80t6Ke/KzcrRqv4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756153764; x=1787689764;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UlbhFGz226HIxGPpl32TNHWjf4s+OegZMHU4Z5wVVAQ=;
  b=dMNcrVXW2dqdFKO6K2QFPU+qRTx7jq/G1YGWVNuiHBmgkb8OmUvT3Xbu
   z8ahOiGiwnzbd4zsrS9W9bXMCiYdzIOy5njTcX/3Dt6mLzSxxE+WsvI3L
   pqWbRU77SQxO67weVtQy/rqpYgiMZL8eHtTN3Il+rMjcfIIhL4Ge2yIqE
   SzFllKAIfyZsS/Ky6F4GlXRpnaxurCzq14U6j5kJTj1nbp6DNkHs2anYJ
   Q/UH1PMoBj0dVZV+ZdrTWSciJW6Xe8qZYF/FenwOykZrjX2UrwjNzeaKa
   EYwihvBROPo9T19rgmUEKHPS9hRL9LzveOTSZnDZ4WZCGSdGBdP+3MD4q
   A==;
X-CSE-ConnectionGUID: mFJgzXnAR1qeL8Q71HW2iQ==
X-CSE-MsgGUID: Dg3KP1eUTEWxTCMIdKEcDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="68970777"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="68970777"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:29:23 -0700
X-CSE-ConnectionGUID: 2iU/MAdEQzuCmnajWPCpwA==
X-CSE-MsgGUID: Li6ndXn4Q1+50YJZ69xiow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169780561"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.6])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:29:02 -0700
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: sohil.mehta@intel.com,
	baohua@kernel.org,
	david@redhat.com,
	kbingham@kernel.org,
	weixugc@google.com,
	Liam.Howlett@oracle.com,
	alexandre.chartre@oracle.com,
	kas@kernel.org,
	mark.rutland@arm.com,
	trintaeoitogc@gmail.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	joey.gouly@arm.com,
	samitolvanen@google.com,
	joel.granados@kernel.org,
	graf@amazon.com,
	vincenzo.frascino@arm.com,
	kees@kernel.org,
	ardb@kernel.org,
	thiago.bauermann@linaro.org,
	glider@google.com,
	thuth@redhat.com,
	kuan-ying.lee@canonical.com,
	pasha.tatashin@soleen.com,
	nick.desaulniers+lkml@gmail.com,
	vbabka@suse.cz,
	kaleshsingh@google.com,
	justinstitt@google.com,
	catalin.marinas@arm.com,
	alexander.shishkin@linux.intel.com,
	samuel.holland@sifive.com,
	dave.hansen@linux.intel.com,
	corbet@lwn.net,
	xin@zytor.com,
	dvyukov@google.com,
	tglx@linutronix.de,
	scott@os.amperecomputing.com,
	jason.andryuk@amd.com,
	morbo@google.com,
	nathan@kernel.org,
	lorenzo.stoakes@oracle.com,
	mingo@redhat.com,
	brgerst@gmail.com,
	kristina.martsenko@arm.com,
	bigeasy@linutronix.de,
	luto@kernel.org,
	jgross@suse.com,
	jpoimboe@kernel.org,
	urezki@gmail.com,
	mhocko@suse.com,
	ada.coupriediaz@arm.com,
	hpa@zytor.com,
	maciej.wieczor-retman@intel.com,
	leitao@debian.org,
	peterz@infradead.org,
	wangkefeng.wang@huawei.com,
	surenb@google.com,
	ziy@nvidia.com,
	smostafa@google.com,
	ryabinin.a.a@gmail.com,
	ubizjak@gmail.com,
	jbohac@suse.cz,
	broonie@kernel.org,
	akpm@linux-foundation.org,
	guoweikang.kernel@gmail.com,
	rppt@kernel.org,
	pcc@google.com,
	jan.kiszka@siemens.com,
	nicolas.schier@linux.dev,
	will@kernel.org,
	andreyknvl@gmail.com,
	jhubbard@nvidia.com,
	bp@alien8.de
Cc: x86@kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	linux-kbuild@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 11/19] x86: LAM initialization
Date: Mon, 25 Aug 2025 22:24:36 +0200
Message-ID: <ffd8c5ee9bfc5acbf068a01ef45d3bf506c191a3.1756151769.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 470AEA0007
X-Stat-Signature: dh7j6u8tnwqxom8b44641wwmkpw88kdz
X-Rspam-User: 
X-HE-Tag: 1756153764-892786
X-HE-Meta: U2FsdGVkX18vYHQaEe7h4yYFVpyqmgpZFLmFU+ujzG2DGHf1O1xwFyK4MxL1F79/vkqucLdfTJKbB9kGOzlncc0JX3p2nfy2+T/myfVfe1gTec/o0n2qhPVvykIWIr3+hW0sbvqM8giplQxSP1I9HGKBy5fuRjXthhkgrmkflHfqWfUl67pSAE14+vLNLylByZ05wjKCWqct0fd0CXIGnTcEjSvkd9C99llzta07KYNPTjeS42gwlABq5rnFu9eIFW6r28BOwbfdH8IeXwsl9jm1eIE30tI9FMzFFS4KPsY1o6lOwK4FmxK4Q36fJB+aEsXDbQTkvF1MqhEbhZ8s1OyArf+3G4WCyJ2i5Rpxkky6PChakrsablbinc4pQrlWynSnJAU1lvTtdy+0ITI+RZko9t2ray2HkGTgNgNT12b9RjLEJa+N/VuledQvao2mpEqmp+tnPxI1OCnfaP8DQ+JHdWa8IIvPXsQ0rJD3YES0YzjjmUeY24gC1dxwm7IyzqmLqDjVAn3aTYlS06fOs01yYIy1Yfw06lIdypZgTsXQV03NeuuhG+SKt187dKU9+wtlT3rdPc7z4ah46ttF6NnunrWHNbhcTUhGCIEjjYIn4i8/jRvFeO10+Vs8VY0D9IA088nFH8gJCxaDnp8UgaQkljjjKfuRWADRZt7IQ+S2YKe+dPfrLUE13xoN7AA7E6JeEqwYBQQbaHOqCuSXXeaLzMg11vPgKj27ydG3lIfWReR90o6K1vlNhEcrsc4OdMV693T6NvK/nAXTtiCoVa9blCpj2VRrkcsX1NukfSktUv7HvY3bIehTfdfmzFKKkgGr438go1bMvYenIpPZ7RfJKTzww7vVAW/OSf1HNo/wfEWuubO3ld7mfAMz3Upq31Himd/6RNovWx52qXKa4DFrjXzGX5Sh3I8YssS7K6HHuqfejY/m0AildE4pye9xLBywkz4Xe81H0W5wRNW
 KLvOF9R8
 4D/PwPUmq3XOnG2EknMATIu+nYWiPvTEgyuDDxGVUo71A0sDfF0OJveZfeRFPQC9wF+cJqicwEmdQ8FnB/2fMf0TF0CmLZEhsYoiwt0rsyPlT8TEsultWLjUY3NHuklEHcmTT1ZETW25ovWGOyUWAx9k6aCA2PLafTUK8cU8H69c+KeGn7khuFHrC4xka+eK0oXsKJ0mI5libZ1XbYOM9AyZp7ZJJBOFWCV5rQ374sqwRamK7T+Yt6hvIOq5lGXiofq2j
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


