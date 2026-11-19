Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 020AC606A331
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 10:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=o5JH2Rt7
Received: by kanga.kvack.org (Postfix)
	id D3C1F6B05DD; Thu, 19 Nov 2026 05:02:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9D6F6B0600; Thu, 19 Nov 2026 05:02:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB3146B05FE; Thu, 19 Nov 2026 05:02:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8EB3F6B05F9
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:02:24 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 03872A8736
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:02:23 +0000 (UTC)
X-FDA: 85451428608.29.F8E7596
Received: from mta0.migadu.com (out-73.mta0.migadu.com [91.218.175.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0CF311C0002
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:02:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o5JH2Rt7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795082542;
	b=5J2mgUgf1NKRUhIq4LM9I17s0m6EKD8fcgnyma26OmhQV8fSnP2r2eLGTzLdL5FuzdMaUx
	ecBjUiGgXjNcrqaiMihvtwtTlv61CIuxJvyRJoqZRW+wP+sXzuggwVWH8BqqylYeD2kU5/
	atBakow9DwWLt6Sf/qMaM2b68W5yDzo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795082542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6SenI4mOj1mO3410qGPpVUgFUHJmec0t3Tk7LJoTcF4=;
	b=tPJNwaJ972TdDZl6aW+RXhfRvafHEyqDWFlrAI78pMpEUuWsL7KzZ/7GQeL4IBqHIlrtFd
	2PQ8L5teeHaQBcp+Sk3Q+YL4VTnSRTw3AWBgoCXx9tApfCB+DjoU3893j0JAUPgPFspnI+
	aJTHpf3xk5L7c66V8MNktann9MmKTXw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o5JH2Rt7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.73 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZvPZUStYyZqiE1rcutwmPpn5KDJpY/jNBe9EWDim99w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795082540; v=1; x=1795687340;
 b=o5JH2Rt7ArgHEghvZnio6UWTdvSfvwMeuFm6zNC4QSaQUhXz/2TLcRqktaesDvGhkMbDrZix
 yZ7Inc9jbKlrpuhfXAtSSW78d96K7tpaLgDNEFoo77l6Wys1K/nOcbCB7bg+UYNU1ZlsLaLpLPp
 GwLO2axTm+ANhoHSO/s/NBec=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 09177ad08c17784d;
	Thu, 19 Nov 2026 10:02:20 +0000
X-Mizu-Trace-ID: 09177ad08c17784d
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org,
	kernel@xen0n.name
Cc: rppt@kernel.org,
	liukexin@kylinos.cn,
	guodongtai@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] LoongArch: Allow memblock arrays to resize
Date: Thu, 19 Nov 2026 19:02:16 +0900
Message-ID: <20261119100216.10182-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 89copoexjqm71kuxztcxasagp4auygq9
X-Rspam-User:
X-Rspamd-Queue-Id: 0CF311C0002
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795082541-504461
X-HE-Meta: U2FsdGVkX18aaWP4c6bI+UCawOeneItLihBu60G0sNn/iBcbAIfwElw0EEIKQHXbUnQuNhcf4y8y7srWjb88dbQk/8YflU/NZGLGbOO03JSmcmwzIj9UIwtLm+HG15sJZjUTAtTsKI2gnQ0UB0SQhKeGgEvRCjfJ8zkEwn7yv0RSGfSwWZ6lIfG0Xb9JqIVhSECWzwC68FX2e8HhDD3yyPGFEIHBNKLFsdn6OzbmHm7SRN4v9NAQUCwaNoiUdrPXEDNlO+K0u7hkNWcyU1cQrAehjY2290Km6+u2tS8wB9913ngS4COd7clj/dWnw9vbTLYvLMS38rMzf3b4D6XoRRe03kcxhWkjR/qHlACu5CJNPrHbbJjYsh8PIvQCSF+kP7CSEANlK55nTMNeX+aZ1K27uvbMoyHwvMWoDHFN0an6t5eC4vnjX8p2bbTow+ZqyZwG2rNgVh42mu6+y1nxcRuacuJCk4X4XjBZIPWRNQe5gT1XCuQI33hfrQDYhlr0+P4cGuwpA0PqeOsArP6iaT+XbJRF1EBNqj8fO3kBeKvOonh44dctX3w2I2+QrWU9/rUQ9+piRj6M2jqE1AugB2r60e1Yx5REzWq4qs7IiIUoonfIw+HsdlhNeeCgqJdKSgHrNc+Y6/Mqgqx285ANhATCj5J0P7IVa/QoDxBNTq+2+vWdimo9S9hGlROR2m0K7YSEgW7fwuS2ABUs5cABqkSHMXZcGLT87a2K0XnvJ7rFhXh7LMGXvNI2Yqot/+ljX2bCkA1sbcsEuA+eFydDJBAR612kW1UWOxcUWh+SmKsKkRiundc/fFUps+ycLhR1I98393H/qwpKGumPBVY2MftFBrZd1W0rx+CfC+JQ7Flb4xDQExhNTq8qxQNYm1iUtKWb0sTvlUdspYbSH4qRmw8vP0YyQbHXgJ2fOsQCCJy5Y4niZgh9LLs8VOKEVnmK6uSkAs9hn6+F2sdmPwJ
 0/+VpTbi
 IeAr3wSydy7FUSrEZ2HPonbaoXyU5mcTNbbZLuc92jcmvsmr1Q+6JiiA08Vo/R3HjvhYMib0ucYUAOujm6+nPzX39Z+Rmag//ZXYUY43LY3qHDpuK/ZrpHf1WQa52OpqqgYXDL4afZJ+5wI7/y4QQ+PE36IEdhUQJZUSWS9XwiqB47sDxEMom5gSSb2hde2gUQog1zgSCbDTWK8sOvBL0i7gGSmg4TC91nrSBlfEoVza4iLq3rDwCKthvvOW6kIXD0R16K6tSjnko0zZbjJ66IYS6gDj6WGg6TfSl0m1i4GFKGik9mEgCnjNQ9B50uuAa/8CQdf/FkJFpyYarOM6tNPp0pMgtbA1RBOuMlLTqKB38WDTXlj1GlLK9UohFhoiUiykixvKFx9CS0i/jCL/Ywtqy7C+AQIk6j+zNN71tPa4TbegC5HqhZd+vOdkNco+ci+ew+bbkOds+zbEWjflMC0eSEV2Kw0AtpNmrIJsCRUMFvlnss3dlD37Iqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: George Guo <guodongtai@kylinos.cn>

LoongArch never calls memblock_allow_resize(), so the memblock region
arrays cannot grow beyond their static sizes. For the reserved array
that is INIT_MEMBLOCK_RESERVED_REGIONS (INIT_MEMBLOCK_REGIONS +
NR_CPUS) entries. Once it is full, the next reservation that needs a
new region panics:

  Kernel panic - not syncing: memblock: cannot resize reserved array

The memory setup code was derived from MIPS, which never enables
resizing either. Nothing on LoongArch needs the arrays to stay static.

When an array is full, memblock allocates a bigger one from free
memory, so resizing is only safe once all memory in use is reserved.
By the time setup_arch() calls arch_mem_init(), the kernel image, the
initrd, the firmware memory map, the device tree reserved-memory
regions and the crash kernel are reserved, so enable resizing there.

Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
This was patch 5/8 of the LoongArch KHO series v6 [1]. Mike suggested
fixing it independently of KHO, and Huacai preferred arch_mem_init()
to platform_init() [1].

KHO for LoongArch needs this: after kexec, kho_memory_init() reserves
every preserved range, and luo_stress_files with 500 files overflows
the reserved array without CONFIG_SMP. A bigger array cannot land on
preserved memory, because KHO limits memblock allocations to its
bootmem areas by then.

Changes since v6 5/8:
- Sent on its own, without the KHO series.
- Reworded the commit message and the comment so they do not depend
  on KHO.

[1] https://lore.kernel.org/all/20261029172956.20791-6-dongtai.guo@linux.dev/

 arch/loongarch/kernel/setup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index 6fa4a22a58fd..8c33346a123a 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -402,6 +402,9 @@ static void __init arch_mem_init(char **cmdline_p)
 
 	check_kernel_sections_mem();
 
+	/* All memory in use is reserved now, so memblock can grow its arrays. */
+	memblock_allow_resize();
+
 	memblock_set_bottom_up(true);
 
 	swiotlb_init(true, SWIOTLB_VERBOSE);

base-commit: 422e532809572ba1043192bf6a0c653bc68b3140
-- 
2.53.0


