Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B4CCCA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1FB38E0138; Tue, 12 Aug 2025 09:29:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF71A8E00E5; Tue, 12 Aug 2025 09:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE6688E0138; Tue, 12 Aug 2025 09:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE0778E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:29:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A060160326
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:29:37 +0000 (UTC)
X-FDA: 83768187594.11.0DF2184
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf09.hostedemail.com (Postfix) with ESMTP id 25B80140012
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:29:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=csjrIqPo;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005375; a=rsa-sha256;
	cv=none;
	b=cfOEA0/RGXFXKw051TKljthP6vOuJorJRMcx7z/ennQqB9OJTKaSOIeuprWaRdjEZRDBY5
	t0GoMrESDW65w1AoUceLKJXhduwZArkMWf8Aepmlq9zCZJlX7kmiLPE3NrLbZiP2w989WJ
	BzLtFbANOW2wiX3p0Uyr3WmOnnhsCBk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=csjrIqPo;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ex520mDAAluSLXFdiYJ04d7IrdUaRDN9zWUBH2TlPCk=;
	b=mbIDVfqB0Vcpm/e9Ty3v8PJfeBI6AsGwcMOpZakq9zO6SZUwnkwHZfouQz/AYTZ7QqNGFV
	TFfnIphIv415nC5RuoprLW4WHbQCc7sYV0hpNf644gmWR1PPNwUavu9AmQ+T4Kt/r3yLmW
	Lb/tbc9voGcGacV6ejl1MixBucWW/nA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755005376; x=1786541376;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9AhOaWTatNb4QMfmox2H6CEYyqT3KnhFIot1r52xKmg=;
  b=csjrIqPo8dfVBjDEeTlqaU0PVolKQSv8MIdD7AEpSajp/YHExFBsrbAM
   cf40p/IljIGlggU+mvstA3fM1QRE1uRuDfbzI/2zIBDu1/fpqBi7oiSm0
   iKI/pibQcbDAts1cnvcI9cloUJHdgqLRQ0y+tTHyd3YncwsU/alnN0CwA
   8G8zErZF5EFRlJkew4PtB9FAcS3lJFWHGOR3v9fo/1+vZUukUThLA9LD4
   85V76QacQwmopiq4AUW882yCYmIrX48Yf3rsQZ0E6tCPW4aR4oXRZkISs
   DJ1hnVV6mwtph18WldiQu0ILcRvHr2FlBQOm5mqacsXPYVmeEXL8pPTCM
   Q==;
X-CSE-ConnectionGUID: 2EJwRwjNSGSVIjzB6OUWEg==
X-CSE-MsgGUID: 6WlZVx4FROSG1SEozpg1oA==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="60903816"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="60903816"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:29:34 -0700
X-CSE-ConnectionGUID: t6kjFU4oRZiLZmMpMij85g==
X-CSE-MsgGUID: TDLcIyj9Qy+UaemOVoZKVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165831582"
Received: from vpanait-mobl.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:29:12 -0700
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
Subject: [PATCH v4 12/18] x86: Minimal SLAB alignment
Date: Tue, 12 Aug 2025 15:23:48 +0200
Message-ID: <a765e38bdeae15193215bb8fd713df9350048edc.1755004923.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 25B80140012
X-Stat-Signature: tkcuz4mqq6ddh13bchp1rz4cijd3yxdk
X-HE-Tag: 1755005374-849732
X-HE-Meta: U2FsdGVkX18gRnVfZgklHyR4BnebULM8ZCIf6ywcE0n/y7UUKb8ciD62DEA0nmRRyvGbwzCpr18r2E5pNrte/wDPaaegN7XLeCM45wdYmc+NmJ/nvA7J81dI55Dwo4HQLRLwgcwvCrjDVVGhFG7oNPIAgVH7g1aqvWjyxwKgj4wFE2NeHOUM04TLjEMkZL+8LfYJTodcvWAXVsm7LR8btPWudFxNqCRvhkGOIeATKaRvVYMZG0ULbWwWSDDCGrlv3Q4zJ5HkQwYeMA58aEBuJTbLv44DBh4CKYTS3Gadr1AQYhZwmqbQKOyrLRNAxncKrf9tfe5Re53oRojR64NFUcwYP37jv+559WbVV21CVxAgfkgj5IR5U9GXxXQnRSNw1FqAblDJiMBjCE5kbORt5Ymyz4Q5dtsWOrInF0BXuLjrfafIJmloOjy6pCXitNiowE3Pqw71rQ8Vu65bSX4FpnS/ymh9AT62ZUkCDYAcoHzmjuP813m141CnYvHuTGtThrDVY2Uc2SJYekTbf0CZiHyvakbX16jv9aFu5Y62lNF0Iq3/3IZxj1ZzHGQH1Ymoglv3JRqQKcFZutj9SEGZ+5Eq5SvYUtQvLXeZ6pTX1m/ANfSrCLeGet7BvHCRbMdaBHV5DcSTi7dV47ctzskybhoRHLYjF7/G1x2y5obHEYdvInSzG0r3JG46K0OdggfuEQQGgSLVmei17Hosb2Mt7PMD6CmbQzQjcJ5nsIrjWolkNcY1Z+wOjEb2v1vnbP2DngWcum6d0xeuFnbV5Mi5o3TNu/RRTPZ+UkQH/Huz5QuYTDYAw7ZbjoYBNcmb+HlvIcrlfHNMIYaltXiwOuUInLtw+PbhzlleDaOURUk3787uZ6RpD2rK26ufgyQodLS3boq+ncLB28SeQYhAV4oWXDB1qzl00bBNN7y2g0u8spstGE8+ZgZ17k8n6IIbZIKUlHqT5BEK6ugGBqhASco
 ps+7Px+H
 giclPyQpZthEYkSWvrxcaA3oi46DjDDVIFNWByxPuqGIyxOQQj9LHjIh9UCWwy4W8yuyQaHDnXwPTLIur2TX4TbeAnvst7Yznuj2XKV4PteEuiJkmfE/azZ8Fwz+9DbbuRm0+nDepe3UHE2cr0MsGjpBp2RooE5GIeoyOy8s6JC3tMv75s7ExqSu2/FHmxH4Th9hPYB5aJlyY8RwgjoTksbHSAviNHpgvdCju3Ohim7ZMqPWfoWWDUBsX3sP3zZ8HA2S6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

8 byte minimal SLAB alignment interferes with KASAN's granularity of 16
bytes. It causes a lot of out-of-bounds errors for unaligned 8 byte
allocations.

Compared to a kernel with KASAN disabled, the memory footprint increases
because all kmalloc-8 allocations now are realized as kmalloc-16, which
has twice the object size. But more meaningfully, when compared to a
kernel with generic KASAN enabled, there is no difference. Because of
redzones in generic KASAN, kmalloc-8' and kmalloc-16' object size is the
same (48 bytes). So changing the minimal SLAB alignment of the tag-based
mode doesn't have any negative impact when compared to the other
software KASAN mode.

Adjust x86 minimal SLAB alignment to match KASAN granularity size.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v4:
- Extend the patch message with some more context and impact
  information.

Changelog v3:
- Fix typo in patch message 4 -> 16.
- Change define location to arch/x86/include/asm/cache.c.

 arch/x86/include/asm/cache.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/cache.h b/arch/x86/include/asm/cache.h
index 69404eae9983..3232583b5487 100644
--- a/arch/x86/include/asm/cache.h
+++ b/arch/x86/include/asm/cache.h
@@ -21,4 +21,8 @@
 #endif
 #endif
 
+#ifdef CONFIG_KASAN_SW_TAGS
+#define ARCH_SLAB_MINALIGN (1ULL << KASAN_SHADOW_SCALE_SHIFT)
+#endif
+
 #endif /* _ASM_X86_CACHE_H */
-- 
2.50.1


